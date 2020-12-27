# HOW TO :-) 
## go to your github account
### in developer settings, generate a new personal token and update terraform.tfvars with this github token
## update terraform.tfvars (default is terraform_version is variables.tf)
## make sure the terraform version in build_hello_world_lambda and terraform on your laptop are the same
## terraform init
## terraform apply
## or 
## terraform apply -target module.s3 --auto-approve
## terraform apply -target module.vpc --auto-approve
## terraform apply -target module.alb --auto-approve
## terraform apply -target module.ecr --auto-approve
## terraform apply -target module.lambda --auto-approve
## terraform apply -target module.role --auto-approve
## terraform apply -target module.dynamodb --auto-approve
## terraform apply -target module.codebuild_base_img --auto-approve
## terraform apply -target module.codebuild_app_lambda --auto-approve
## terraform apply -target module.codebuild_app_docker --auto-approve
## terraform apply -target module.codepipeline_app --auto-approve
## terraform apply -target module.ecs --auto-approve

## terraform destroy -target module.s3 
## terraform destroy -target module.vpc --auto-approve
## terraform destroy -target module.alb --auto-approve
## terraform destroy -target module.ecr --auto-approve
## terraform destroy -target module.lambda --auto-approve
## terraform destroy -target module.role --auto-approve
## terraform destroy -target module.dynamodb --auto-approve
## terraform destroy -target module.codebuild_base_img --auto-approve
## terraform destroy -target module.codebuild_app_lambda --auto-approve
## terraform destroy -target module.codebuild_app_docker --auto-approve
## terraform destroy -target module.codepipeline_app --auto-approve
## terraform destroy -target module.ecs --auto-approve