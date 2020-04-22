# Deployment Pipeline And Infrastructure as Code

### Prerequisites:

- AWS Account
- AWS CLI >= 1.10
- Terraform >= 0.7.5
- Ansible >= 2.1.2.0
- rsync

In case that you don't have them installed in your local machine or if you don't want to install them for whatever reason, there is a Dockerfile in the root directory that will install every prerequisite in a docker image. (more on Using Dockerfile section)

Generate access and secret keys for your account in AWS IAM and export them as environment variables:`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`. Run `aws configure` to configure region and output type to be used when interacting with AWS. 

```shell
export AWS_ACCESS_KEY_ID=XXXX
export AWS_SECRET_ACCESS_KEY=YYYY
```


Update `public_key` variable in `terraform-aws/variables.tf` with your public ssh key. In case that you don't have one, generate it. (HOWTO: Linux - https://www.ssh.com/ssh/keygen/)

### Assumptions

This will run in Amazon AWS region eu-west-1, and you will only need AZA and AZB.

### AWS resources

This application will create the following resources:

 * VPC
 * Routing Tables
 * Subnets
 * Internet Gateway
 * Security Groups
 * Elatic Loadbalance
 * Launch Configuration
 * Autoscaling Groups
 * EC2 Key
 * EC2 Instance(s)

**Note**: Some of these resource will incur a charge

### Files and Directories:

```
├── ansible
│   ├── hosts.template
│   └── playbook.yml
├── cloud-automation.sh
├── docker
│   ├── nginx
│   │   ├── Dockerfile  
│   │   └── config
│   │       ├── default.conf
│   │       └── nginx.conf
│   ├── tomcat
│   │   ├── Dockerfile  
│   │   ├── config
│   │   │   ├── context.xml
│   │   │   └── tomcat-users.xml
│   │   └── webapps
│   │       └── *.war
│   └── docker-compose.yml
├── ips_to_file.py
├── LICENSE.md
├── Dockerfile
├── README.md
└── terraform-aws
    ├── modules
    │   ├── app_sg
    │   │   ├── main.tf
    │   │   └── variables.tf
    │   ├── asg
    │   │   ├── main.tf
    │   │   └── variables.tf
    │   ├── ec2key
    │   │   ├── main.tf
    │   │   └── variables.tf
    │   ├── elb
    │   │   ├── main.tf
    │   │   └── variables.tf
    │   ├── elb_sg
    │   │   ├── main.tf
    │   │   └── variables.tf
    │   ├── ssh_sg
    │   │   ├── main.tf
    │   │   └── variables.tf
    │   └── vpc_subnets
    │       ├── main.tf
    │       └── variables.tf
    ├── outputs.tf
    ├── site.tf
    ├── userdata.sh
    └── variables.tf
```
### Getting started

To run the application, simply execute the following command:
```shell
./cloud-automation.sh web dev 1 t2.nano flre
```

**Note**: `web` is for application variable - default: `app`, `dev` is for environment variables - default: `dev`, `1` is for instance count - default: `1`, `t2.nano` is for EC2 instance type - default: `t2.nano` and `flre` is for name variable - default: `flre`. All variables can be found in `terraform-aws/variables.tf`. Please make sure that you use an instance type that has 4 or 8GB memory space, otherwise, docker containers may not be working properly.

### Tools Used:

Terraform will create all the resources in AWS.
Ansible is used to deploy any changes in EC2 instance, build docker images and start docker containers.
Docker is used to create images with all neccessary packages and configurations. Tomcat with Java8 is placed in one image, Nginx is placed in one image. Nginx will redirect traffic to Tomcat container.

### Using Dockefile

If you want to use Dockerfile to run application, follow below steps. Dockerfile use `ubuntu` as base image.

1.  In root directory, build docker image: `docker build .`
2.  Run docker image: `docker run -d [IMAGE_ID]`
3.  Go inside docker container: `docker exec -it [CONTAINER_ID] bash`
4.  Clone repo inside container and change directory to `REPOSITORY_NAME`: `git clone https://github.com/flakronrexhepaj/devops && cd devops`
5.  Export `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` as environment variables
6.  Configure aws setup: `aws configure`
7.  Generate public key for SSH: `ssh-keygen`
8.  Update `public_key` variable in `terraform-aws/variables.tf` with your generated ssh public key.
9.  Run application: `./cloud-automation.sh web dev 1 t2.large flre`
10. Re-run command 9 everytime there is a change in resources, docker, nginx, tomcat config files or webapps! 


### References:

- https://dev.to/codebarber/dockerfile-ansible-awscli-packer-terraform-4ppi
- https://github.com/saidsef/aws-terraform-ansible-docker
- https://github.com/ricktbaker/docker-java-tomcat-nginx