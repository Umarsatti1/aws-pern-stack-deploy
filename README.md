# Deploying a PERN Stack on AWS

This project outlines a simple setup for deploying a PERN (PostgreSQL, Express, React, Node.js) application on Amazon Web Services (AWS). The deployment leverages essential AWS services like IAM, EC2, RDS, VPC, and Systems Manager (Parameter Store) to create a functional and manageable environment.

**Important Note on Security:** This guide prioritizes a clear and understandable deployment process for testing and learning. For a production environment, consider enhanced security measures such as private subnets for EC2 and RDS, bastion hosts for access, and more restrictive security group rules.

## Table of Contents

- [Local Setup](#local-setup)
- [AWS Infrastructure Setup](#aws-infrastructure-setup)
  - [1. Create a Virtual Private Cloud (VPC)](#1-create-a-virtual-private-cloud-vpc)
  - [2. Configure IAM Role for EC2](#2-configure-iam-role-for-ec2)
  - [3. Create RDS DB Subnet Group](#3-create-rds-db-subnet-group)
  - [4. Create an RDS Instance](#4-create-an-rds-instance)
  - [5. Systems Manager Parameter Store Configuration](#5-systems-manager-parameter-store-configuration)
  - [6. Create an EC2 Instance](#6-create-an-ec2-instance)
- [Testing the Application](#testing-the-application)

---

## Local Setup

Before deploying to AWS, ensure your PERN application runs correctly on your local machine.

1.  **Start Backend Server:**
    ```bash
    cd client # This should be 'server' based on your previous description
    node index.js
    ```
    *Correction*: This command should be run in the `server` directory.

2.  **Start Frontend Development Server:**
    ```bash
    cd client
    npm start
    ```

3.  **Local PostgreSQL Database Setup:**
    * Set up a local PostgreSQL database.
    * Use a tool like `pgAdmin` to create and manage your database table.
    * Ensure your application can connect to this local database.

4.  **Test Application Functionality:**
    * Add, remove, and edit to-do task descriptions to verify your application's CRUD (Create, Read, Update, Delete) operations.

---

## AWS Infrastructure Setup

This section guides you through setting up the necessary AWS infrastructure for your PERN application.

### 1. Create a Virtual Private Cloud (VPC)

A VPC provides an isolated network environment in AWS for your resources.

* **Subnets:** Create public subnets for both your EC2 instance and RDS database (for testing purposes). In a production scenario, use private subnets for improved security.
* **Internet Gateway:** Attach an Internet Gateway to your VPC to enable communication between your VPC and the internet.
* **Route Tables:** Configure route tables to direct internet-bound traffic through the Internet Gateway.
* **Security Groups:**
    * **EC2 Security Group:** Allow inbound SSH (port 22) and HTTP (port 80) traffic.
    * **RDS Security Group:** Allow inbound TCP traffic on port 5432 (PostgreSQL default) from the EC2 security group.

### 2. Configure IAM Role for EC2

An IAM role grants permissions to your EC2 instance without managing credentials directly on the instance.

* **Purpose:** This role enables your EC2 instance to securely retrieve database credentials from AWS Systems Manager Parameter Store.
* **Policy Attachment:** Attach the following least-privileged IAM policy to the role:

    ```json
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": "ssm:GetParameter",
          "Resource": "arn:aws:ssm:*:*:parameter/pern/*"
        }
      ]
    }
    ```

### 3. Create RDS DB Subnet Group

A DB Subnet Group is required for your RDS instance to be launched within your VPC.

* Select the VPC you created in Step 1.
* Choose the appropriate subnets for your RDS database.

### 4. Create an RDS Instance

This will host your PostgreSQL database.

* **Engine:** Select PostgreSQL.
* **Credentials:** Copy your database name, master username, password, and port. You'll need these later.
* **Public Access:** Set to "No" (recommended for security, even in testing).
* **Tier:** Use the "Free tier" option for cost-effectiveness during testing.
* **Production Note:** For production, choose the "Production" template which offers higher availability and performance options.

### 5. Systems Manager Parameter Store Configuration

Securely store your database credentials using Systems Manager Parameter Store.

* Navigate to the Parameter Store in AWS Systems Manager.
* Add the following parameters. Ensure they are prefixed with `/pern/` as per the IAM policy:
    * `/pern/DB_HOST` (This will be the RDS endpoint)
    * `/pern/DB_NAME`
    * `/pern/DB_PASSWORD`
    * `/pern/DB_PORT`
    * `/pern/DB_USER`

### 6. Create an EC2 Instance

This instance will host your Node.js backend and React frontend.

* **AMI:** Choose a Linux-based AMI (e.g., Ubuntu, Amazon Linux).
* **Instance Type:** Select `t2.micro` (eligible for the free tier).
* **VPC:** Select the VPC you created.
* **Security Groups:** Assign the EC2 security group configured in Step 1.
* **IAM Role:** Attach the IAM role created in Step 2.
* **User Data Script:** Paste the following bash script into the User Data section. This script automates the setup of your EC2 instance.

    ```bash
    #!/bin/bash
    set -e # Exit immediately if a command exits with a non-zero status.

    # 1. Update system packages
    # 'apt update -y': Refreshes the list of available packages.
    # 'apt upgrade -y': Upgrades all installed packages to their latest versions.
    apt update -y
    apt upgrade -y

    # 2. Install required packages
    # 'nginx': Web server for serving the React frontend and proxying API requests.
    # 'nodejs': JavaScript runtime for the backend.
    # 'npm': Node.js package manager.
    # 'git': Version control system to clone your application repository.
    # 'postgresql-client': Command-line tools for interacting with PostgreSQL (useful for debugging).
    apt install -y nginx nodejs npm git postgresql-client

    # 3. Install PM2 globally
    # 'npm install -g pm2': Installs PM2, a production process manager for Node.js applications, globally.
    # PM2 keeps your Node.js application running continuously and automatically restarts it on crashes.
    npm install -g pm2

    # 4. Clone your repository
    # 'cd /home/ubuntu': Changes the current directory to '/home/ubuntu'.
    # 'git clone [https://github.com/YourUser/aws-pern-stack-deploy.git](https://github.com/YourUser/aws-pern-stack-deploy.git)': Clones your PERN application repository
    #                                                                   Replace 'YourUser/aws-pern-stack-deploy.git' with your actual repository URL.
    # 'cd aws-pern-stack-deploy': Navigates into the cloned repository directory.
    cd /home/ubuntu
    git clone [https://github.com/YourUser/aws-pern-stack-deploy.git](https://github.com/YourUser/aws-pern-stack-deploy.git) # **IMPORTANT: Replace with your actual repo URL**
    cd aws-pern-stack-deploy

    # 5. Install backend dependencies
    # 'cd server': Navigates into the backend server directory.
    # 'npm install': Installs all dependencies listed in 'package.json' for the backend.
    cd server
    npm install

    # 6. Install frontend dependencies and build
    # 'cd ../client': Navigates to the frontend client directory.
    # 'npm install': Installs all dependencies for the React application.
    # 'npm run build': Creates a production-ready build of your React application in the 'build' directory.
    cd ../client
    npm install
    npm run build

    # 7. Copy React build to Nginx directory
    # 'rm -rf /var/www/react-app': Removes any existing 'react-app' directory to ensure a clean copy.
    # 'cp -r build /var/www/react-app': Copies the compiled React build files to the Nginx web root directory.
    rm -rf /var/www/react-app
    cp -r build /var/www/react-app

    # 8. Configure Nginx
    # This section configures Nginx to:
    # - Listen on port 80 (standard HTTP).
    # - Serve static files (your React frontend) from '/var/www/react-app'.
    # - Handle client-side routing by trying files and falling back to 'index.html'.
    # - Proxy API requests starting with '/todos' to your Node.js backend running on 'http://localhost:5000'.
    # 'cat <<EOF > /etc/nginx/sites-available/react': Creates a new Nginx server block configuration.
    # 'rm -f /etc/nginx/sites-enabled/default': Removes the default Nginx site configuration.
    # 'ln -s ...': Creates a symbolic link to enable the new Nginx configuration.
    # 'nginx -t && systemctl reload nginx': Tests the Nginx configuration for syntax errors and reloads Nginx to apply changes.
    cat <<EOF > /etc/nginx/sites-available/react
    server {
        listen 80;
        root /var/www/react-app;
        index index.html;
        server_name _;

        location / {
            try_files \$uri /index.html;
        }

        location /todos {
            proxy_pass http://localhost:5000;
            proxy_http_version 1.1;
            proxy_set_header Upgrade \$http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host \$host;
            proxy_cache_bypass \$http_upgrade;
        }
    }
    EOF

    rm -f /etc/nginx/sites-enabled/default
    ln -s /etc/nginx/sites-available/react /etc/nginx/sites-enabled/react

    nginx -t && systemctl reload nginx

    # 9. Start backend with PM2 in production mode
    # 'cd ../server': Navigates back to the backend server directory.
    # 'NODE_ENV=production pm2 start index.js --name pern-api --env production': Starts your Node.js backend
    #                                                                           using PM2 in production mode.
    #                                                                           It names the process 'pern-api'.
    # 'pm2 save': Saves the current PM2 process list so it can be restored on reboot.
    # 'pm2 startup': Generates and configures a system startup script to ensure PM2 processes
    #                are started automatically when the EC2 instance boots.
    cd ../server
    NODE_ENV=production pm2 start index.js --name pern-api --env production
    pm2 save
    pm2 startup
    ```

---

## Testing the Application

Once your EC2 instance is running and the user data script has completed:

* **Access the Application:** Open your web browser and navigate to the Public IP address of your EC2 instance on Port 80 (e.g., `http://your-ec2-public-ip`).
* Verify that your PERN application is accessible and fully functional.

---