# Spring Petclinic Microservices – DevOps CI/CD Project

## Project Overview
This repository demonstrates an end-to-end DevOps pipeline for a real-world
Spring Boot microservices application.

The project covers:
- Git branching strategy
- Maven build automation
- SonarQube code quality analysis
- Jenkins CI/CD pipelines
- Docker image creation and publishing
- Kubernetes deployment with Ingress
- ConfigMaps, Secrets, and PVC-based storage

## Application
Base application:
Spring Petclinic Microservices (Spring Boot + Spring Cloud)

Microservices deployed:
- api-gateway
- customers-service
- vets-service
- visits-service
- discovery-server (Eureka)
- config-server
- admin-server

## DevOps Stack
- GitHub
- Jenkins
- Maven
- SonarQube
- Docker & Docker Hub
- Kubernetes
- NGINX Ingress
- NFS-backed Persistent Volumes

## Environments
- dev
- uat
- prod (structure ready)

## Documentation
Detailed documentation, architecture diagrams, pipeline flow,
and troubleshooting notes are available under the `docs/` directory.

## Author
DevOps Practice Project
