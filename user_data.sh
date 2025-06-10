#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status.

# 1. Update system packages
# 'apt update -y': Refreshes the list of available packages.
# 'apt upgrade -y': Upgrades all installed packages to their latest versions.
apt update -y
apt upgrade -y

# 2. Install required packages
# 'nginx': Web server for serving the pern-app frontend and proxying API requests.
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
# 'npm install': Installs all dependencies for the pern-app application.
# 'npm run build': Creates a production-ready build of your pern-app application in the 'build' directory.
cd ../client
npm install
npm run build

# 7. Copy pern-app build to Nginx directory
# 'rm -rf /var/www/pern-app': Removes any existing 'pern-app' directory to ensure a clean copy.
# 'cp -r build /var/www/pern-app': Copies the compiled pern-app build files to the Nginx web root directory.
rm -rf /var/www/pern-app
cp -r build /var/www/pern-app

# 8. Configure Nginx
# This section configures Nginx to:
# - Listen on port 80 (standard HTTP).
# - Serve static files (your pern-app frontend) from '/var/www/pern-app'.
# - Handle client-side routing by trying files and falling back to 'index.html'.
# - Proxy API requests starting with '/todos' to your Node.js backend running on 'http://localhost:5000'.
# 'cat <<EOF > /etc/nginx/sites-available/pern-app': Creates a new Nginx server block configuration.
# 'rm -f /etc/nginx/sites-enabled/default': Removes the default Nginx site configuration.
# 'ln -s ...': Creates a symbolic link to enable the new Nginx configuration.
# 'nginx -t && systemctl reload nginx': Tests the Nginx configuration for syntax errors and reloads Nginx to apply changes.
cat <<EOF > /etc/nginx/sites-available/pern-app
server {
    listen 80;
    root /var/www/pern-app;
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
ln -s /etc/nginx/sites-available/pern-app /etc/nginx/sites-enabled/pern-app

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