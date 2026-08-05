# AWS WordPress Infrastructure with Terraform & Docker 

I built an automated AWS Infrastructure using Terraform to provision resources and host a containerised WordPress application powered by Docker and Docker compose.  


## Architecture Overview

- **Cloud Provider:** AWS (`eu-west-2` London)
- **Compute:** EC2 (`t3.micro` running Ubuntu 22.04 LTS)
- **Security:** Security Group allowing HTTP (Port 80) and SSH (Port 22)
- **Containerization:** Docker & Docker Compose executed via EC2 `user_data` script


--- 


## Repository Structure 

I structured the repository modularly across separate Terraform and shell script files to keep configuration code clean, manageable and easy to navigate.  

```text
├── .gitignore          # Excludes Terraform state files and credentials
├── provider.tf         # AWS Provider & version definitions
├── main.tf             # Security Group & EC2 instance resources
├── variables.tf        # Input variable declarations
├── outputs.tf          # Public IP and website URL output values
├── user_data.sh        # Startup bash script to install Docker & run WordPress
└── README.md           # Project documentation
```

### Purpose of files within the repository

- **.gitignore :** - Keep sensitive credentials, local Terraform state files and temporary cache folders safely off GitHub.
- **provider.tf:** - I connected Terraform to AWS and set the correct version settings.
- **variables.tf:** - I stored flexible settings here, like the AWS region and server size so they're easy to change.
- **main.tf:** I built the main setup here with the AWS core infrastructure resources. I dynamically fetched the latest Ubuntu AMI, configured a Security Group for HTTP and SSH access and launched the EC2 instance tied to those rules.
- **user_data.sh:** I created a startup script that automatically installs Docker and runs WordPress when the server starts up.
- **outputs.tf:** I set up output values to automatically display the public IP address and WordPress web URL right in the terminal upon successful deployment when the deployment has finished.


## Initialisation & Apply 

```bash
terraform init - I ran this to initialize my workspace and download the required AWS provider plugins.
terraform plan - I used this to preview the AWS resources Terraform would create before executing the changes. 
terraform apply - I used apply to execute and provision the deployment of the actual infrastructure directly to AWS.
terraform destroy - I ran this safely to tear down all created AWS resources and avoid unnecessary charges.  
```


## Proof of Deployment 


<img width="940" height="511" alt="image" src="https://github.com/user-attachments/assets/9ed1b912-0770-4a40-875d-43c1af4a2a4d" />


I captured this screenshot of the WordPress initialisation page to confirm that the EC2 instance, Docker container and network security rules were running successfully. 



<img width="940" height="785" alt="image" src="https://github.com/user-attachments/assets/fae586ea-6341-4d34-9e52-f6204ea065a6" />



I also took a snapshot of the terminal output to confirm that ```terraform apply``` successfully provisioned the AWS resources and generated the public IP and URL outputs. 




## What I learnt 

By completing this project, I gained hand-on experience across key DevOps and Cloud Engineering Domains. Here are a few key takeaways: 
- **Infrastructure as Code (IaC) - I learnt how to write, structure and execute modular Terraform code (main.tf, variables.tf, outputs.tf, provider.tf) to provision cloud infrastructure consistently instead of manually configuring it in the console.**
- **AWS Core Services - I gained more practical experience configuring compute (EC2 instances), networking access control (Security Groups for HTTP/SSH) and dynamically fetching Amazon machine images (AMIs).**
- **Containerization & Orchestration: I excelled in hosting applications with Docker and Docker Compose by configuring multi-container environments (WordPress and MySQL) and managing container persistence.**
- **Automated Server Bootstrap: I learnt how to use setup scripts (user_data.sh) to automatically install dependencies, start services and deploy applications by installing Docker. This launched WordPress as soon as the server boots up without needing to log in manually.**
- **Security & Repository Best Practices: I am getting a better understanding of applying best practices to secure GitHub repositories by using a .gitignore file to keep sensitive passwords, state files and temporary code off my public Github repository.**

## Issues I ran into and what I done to fix it

Upon running ``terraform apply`` the first time, I ran into a slight error preventing the WordPress infrastructure from launching. The error is in the following screenshot below. 

<img width="940" height="509" alt="image" src="https://github.com/user-attachments/assets/9a6f5e42-ed4c-4692-9571-ec4abf9f82a1" />


- **The issue: ``terraform apply`` failed because the AMI ID was invalid or unavailable in my region. (InvalidAMIID.Malformed)**
- **The Fix: I fixed the broken AMI error by replacing the hardcoded ID with an aws_ami data block to dynamically fetch the latest Ubuntu image, then updated the ami argument in the ``main.tf`` to reference ``data.aws_ami.ubuntu.id``.**
- **In the ``variables.tf`` file, I set the default variables for the region (``eu-west-2``) and server size(``t3.micro``) so the settings are all in one place and easy to change.**



