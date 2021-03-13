# Terraform-EKS-Gitlab

In this Project I haven demonstrated the Provisioning of AWS Architecture using HashiCorp Tool Terraform,also associated a lock using S3 object store and DynamoDB for serving the Terraform automation backend which is basically used to store the terraform state file called tfstate as Terraform maintains a state file inorder to track the services being deployed in AWS. Terraform is written in Go Language and the workflow in the backend includes API calling in-order to deploy resources in AWS or in other words the go language makes API calls to AWS API's to deploy necessary services and resources written by the user using Terraform. I have also made use of GitOps Technology which is bacically the ArgoCD which is a Declarative Gitops based approach to deploy applications in kubernetes and also managing them. One of the greatest advantage of ArgoCD is that it maintains the state of deployment in Kubernetes. The deployments are version controlled and provides continuous deployment.Argo CD follows the GitOps pattern of using Git repositories as the source of truth for defining the desired application state. Argo CD automates the deployment of the desired application states in the specified target environments. Application deployments can track updates to branches, tags, or pinned to a specific version of manifests at a Git commit. 





Architecture

![alt text](https://github.com/Abhishek010397/Terraform-EKS-Gitlab/blob/master/Architecture.png)
