# Running a PERN Stack Application Locally with Docker

This guide provides instructions for setting up and running a **PERN** (PostgreSQL, Express.js, React.js, Node.js) stack application locally using **Docker**. The application is containerized using `docker-compose.yml`, individual `Dockerfiles` for the frontend and backend, and an Nginx configuration for serving the frontend.

---

## Prerequisites

Before you begin, ensure you have the following installed:

* **Docker Desktop:** This includes Docker Engine, Docker CLI, Docker Compose, and Kubernetes (optional).
    * [Download Docker Desktop](https://www.docker.com/products/docker-desktop/)

---

## Getting Started

Follow these steps to get your PERN application up and running.

### Step 1: Install Docker Desktop

If you haven't already, download and install Docker Desktop from the link above.

### Step 2: Ensure Docker Desktop is Running

Verify that Docker Desktop is **active and running** on your local machine. You can usually find the Docker icon in your system tray (Windows) or menu bar (macOS).

### Step 3: Application Structure

This project utilizes separate `Dockerfiles` for the frontend (which includes Nginx for serving static files) and the backend services. The `docker-compose.yml` orchestrates these services.

### Step 4: Running the Application Locally with Docker

Navigate to the **root directory** of your project where `docker-compose.yml` and your `Dockerfiles` are located.

#### Build and Run Docker Compose

To build the Docker images and start the containers, execute the following command:

```bash
docker-compose -f docker-compose.yml --env-file .env up --build
```
Specifies the Docker Compose file to use and load environment variables from the .env file.

To see the containers that are currently running:

```bash
docker ps
```

Lists all currently running Docker containers.

```bash
docker ps -a
```
Lists all Docker containers, including those that are stopped or have exited. 

### Step 5: Test the Application
Once all containers are up and running, you can access your PERN application in your web browser:

http://localhost:3000/

Verify that your PERN application is accessible and fully functional.

Stopping and Cleaning Up
Shutdown Docker Compose
To stop and remove the containers, networks, and volumes created by docker-compose up:

```bash

docker-compose down -v
```
Stops and removes containers, networks, and volumes.

#### Delete Docker Resources (Optional)
These commands are used to free up disk space by removing Docker images and unused Docker resources. Use with caution!

Remove Specific Docker Images
```bash
docker rmi <IMAGE_ID>
```


