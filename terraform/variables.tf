variable "aws_region" {
  description = "AWS region in which to deploy the catalog."
  type        = string
  default     = "us-east-1"
}

variable "app_name" {
  description = "Name used for AWS resources."
  type        = string
  default     = "lumina-catalog"
}

variable "image_tag" {
  description = "Docker image tag to build locally on the EC2 instance."
  type        = string
  default     = "latest"
}

variable "repository_url" {
  description = "Public Git repository containing the Dockerfile and application."
  type        = string
  default     = "https://github.com/parikshit245/Entrata-ai-coding-challange-E.git"
}

variable "instance_type" {
  description = "EC2 instance type. t3.micro is suitable for a small test deployment."
  type        = string
  default     = "t3.micro"
}
