# Jenkins Docker Setup
This repository contains a custom Docker image and a shell script to automate the setup and configuration of Jenkins. The Docker image is based on the official jenkins/jenkins:lts-alpine image and includes additional configuration and plugin installation as part of the setup.


## To build the Jenkins Docker image, follow these steps:

Clone this repository or download the Dockerfile and setup script.
Place the jenkins-setup.sh file in the same directory as your Dockerfile.
In the terminal, navigate to the directory containing the Dockerfile and the setup script.

Run the following command to build the Docker image:
```
docker build -t custom-jenkins:latest .
```
This will build the image and tag it as custom-jenkins:latest.

## Running the Jenkins Container
After building the Docker image, you can run it using the following command:
```
docker run -d -p 8080:8080 -p 50000:50000 --name jenkins custom-jenkins:latest
```
This command runs Jenkins in detached mode (-d).
It exposes Jenkins on port 8080 for the web UI and port 50000 for agent communication.
Jenkins Setup Script
The jenkins-setup.sh script is responsible for automating the Jenkins setup. It performs the following tasks:

 -> Waits for Jenkins to start and become available at http://localhost:8080.
 
 -> Retrieves the default admin password.
 
 -> Creates a new admin user with the provided username and password.
 
 -> Installs necessary Jenkins plugins for building, testing, and deployment.
 
 -> Configures Jenkins with the URL of the Jenkins instance.

## The script performs the following actions:
Admin User Creation: The script creates a new Jenkins admin user using the credentials provided in the script (username, password, fullname, email).

Plugin Installation: A set of essential Jenkins plugins is installed, including plugins for Git, pipeline jobs, email notifications, and more.

Configuration: It configures the Jenkins instance with the correct URL and sets up the necessary paths for Jenkins to run smoothly.

## Configuration Details
# Jenkins URL:
The script uses http://localhost:8080 as the default Jenkins URL. If needed, this can be modified during the script's execution to suit different environments.
# Admin User Credentials: 
The username, password, fullname, and email fields are configurable within the script. These details are used to create the Jenkins administrator account.
# Installed Plugins: 
A variety of Jenkins plugins are installed to enable additional functionality. The plugins include support for various build tools, version control systems, and Jenkins-specific functionalities like pipeline support.

## Default Credentials
```
Username: user
Password: password
Full Name: Full Name
Email: hello@world.com
```
These credentials are used for the Jenkins admin account creation. Make sure to update them as needed in the script before running.

Additional Notes
Waiting for Jenkins to Start: The script waits for Jenkins to be fully up and running by repeatedly checking the login page until it receives a 200 OK response.

Error Handling: The script checks if the default admin password file exists. If not, it exits with an error message indicating the issue.

Customization: You can customize the jenkins-setup.sh script further if you need additional steps or different plugin configurations.


# Jenkins Helm Chart
This repository contains a Helm chart for deploying Jenkins on Kubernetes with custom configurations. It includes options for persistence, security, and scaling, along with the ability to customize various components like the Jenkins image, URL, and resource allocations.


Prerequisites
Kubernetes 1.12+ (tested on Kubernetes 1.18+)
Helm 3.0+
A running Kubernetes cluster

## Installation
To install the Jenkins Helm chart, follow these steps:

Clone this repository:
```
git clone https://github.com/yugannkt/Jenkins_helm_charts.git
cd Jenkins_helm_charts
```
Install the Helm chart using the following command:
```
helm install jenkins ./jenkins-chart
```
Verify the deployment:
```
kubectl get pods
```
Configuration
You can modify the following configuration options in the values.yaml file.


## Persistence
Jenkins data can be persisted across restarts using persistent volumes. You can configure the persistence size, storage class, and enable/disable the persistence feature in the values.yaml file.
Set up persistent storage for Jenkins data.
```
persistence.enabled: Enable persistence (default: true).
persistence.storageClass: Storage class for PVC (default: default).
persistence.size: Size of the persistent volume (default: 10Gi).
```
## Ingress Configuration
If you need to expose Jenkins to the internet via Ingress, configure it in the ingress section of the values.yaml. Make sure your Kubernetes cluster has an Ingress controller installed.
To expose Jenkins externally through Ingress, enable and configure Ingress:
```
ingress.enabled: Enable/Disable Ingress (default: false).
ingress.host: The hostname for the Jenkins ingress (default: jenkins.local).
ingress.path: The Ingress path (default: /).
ingress.annotations: Custom annotations for the ingress.
```
## Service Configuration
Configure how Jenkins is exposed internally in the Kubernetes cluster.
```
service.type: Service type (default: ClusterIP).
service.port: Port for the Jenkins service (default: 8080).
service.targetPort: Target port (default: 8080).
```
## Resource Requests and Limits
The Helm chart allows you to define resource requests and limits for CPU and memory. This ensures Jenkins has the necessary resources to run efficiently in the Kubernetes cluster.
Set CPU and memory resource requests and limits:
```
resources:
  requests:
    memory: "2Gi"
    cpu: "1"
  limits:
    memory: "4Gi"
    cpu: "2"
```

## Secrets
You can securely store your Jenkins admin credentials using Kubernetes Secrets. Enable this feature by setting secret.enabled to true in the values.yaml.
Optionally, use secrets to store sensitive information:
```
secret.enabled: Enable/Disable Jenkins secrets (default: false).
secret.jenkins-admin-username: Base64 encoded Jenkins admin username.
secret.jenkins-admin-password: Base64 encoded Jenkins admin password.
```



