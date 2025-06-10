# PERN Stack Deployment Project

This repository provides a comprehensive guide for deploying a PERN (PostgreSQL, Express, React, Node.js) application. It covers both a manual AWS deployment setup and a Dockerized approach for local development and future container-based deployments.

## Table of Contents

- [Project Overview](#project-overview)
- [Deployment Options](#deployment-options)
  - [Local Development (Dockerized)](#local-development-dockerized)
  - [AWS Deployment (Manual EC2/RDS)](#aws-deployment-manual-ec2rds)
- [Branch Navigation](#branch-navigation)
- [Core Technologies](#core-technologies)

---

## Project Overview

This project demonstrates how to set up and deploy a full-stack PERN application. It includes a React frontend, an Express/Node.js backend, and uses PostgreSQL as the database. The deployment strategies vary to showcase different approaches.

## Deployment Options

Explore the different deployment strategies implemented in this repository.

### Local Development (Dockerized)

This branch (`local-docker`) provides instructions and configuration (using `docker-compose.yml`) to run your PERN application locally within Docker containers. This approach offers environment consistency and simplifies local setup.

**Key Features:**
* Frontend (React) served by Nginx.
* Backend (Node.js/Express) API.
* Uses your **AWS RDS PostgreSQL instance** for the database connection.

**Get Started with Dockerized Local Development:**
1.  **Clone this repository** to your local machine.
2.  **Switch to the `local-docker` branch:**
    ```bash
    git checkout local-docker
    ```
3.  **Follow the setup instructions** within the `README.md` file on that branch.

**[Click here to view the `local-docker` branch instructions](https://github.com/Umarsatti1/aws-pern-stack-deploy/tree/local-docker)**

--

### AWS Deployment (Manual EC2/RDS)

The `aws-deploy-manual` branch contains the detailed steps and configuration for manually deploying your PERN application on AWS using individual services like EC2, RDS, VPC, IAM, and Systems Manager. This approach is useful for understanding the underlying AWS infrastructure.

**Key AWS Services Used:**
* **IAM:** For managing user permissions and EC2 roles.
* **EC2:** To host the Node.js backend and React frontend (served by Nginx via user-data script).
* **RDS:** For a managed PostgreSQL database.
* **VPC:** To set up a custom network environment.
* **Systems Manager (Parameter Store):** For secure storage of database credentials.

**Get Started with Manual AWS Deployment:**
1.  **Clone this repository** to your local machine.
2.  **Switch to the `aws-deploy-manual` branch:**
    ```bash
    git checkout aws-deploy-manual
    ```
3.  **Follow the step-by-step guide** provided in the `README.md` file on that branch.

**[Click here to view the `aws-deploy-manual` branch instructions](https://github.com/Umarsatti1/aws-pern-stack-deploy/tree/aws-deploy-manual)**

--

## Branch Navigation

This repository is structured into several branches, each focusing on a specific aspect of the project:

* `main`: The root branch, providing an overview of the project.
* `local`: (Your original local development branch, potentially deprecated by `local-docker` if it's for non-Dockerized local setup)
* `local-docker`: Contains files and instructions for running the application locally using Docker Compose.
* `aws-deploy-manual`: Contains files and detailed instructions for manual deployment on AWS EC2/RDS.

## Core Technologies

* **Frontend:** React.js
* **Backend:** Node.js, Express.js
* **Database:** PostgreSQL
* **Deployment:** AWS (EC2, RDS, VPC, IAM, Systems Manager), Docker, Nginx, PM2

--