variable "aws_region"{
    description= "The region where resources are to be provisioned"
    default = "us-east-1"
}

variable "az_count"{
    description= "The number of availability zones in a region"
    default = 2
}

variable "docker_image"{
    description= "The image in the ECR"
    default = ""
}

variable "app_port"{
    description= "The port exposed in the docker image"
    default = 8080
}

variable "app_count"{
    description= "The minimum number of docker containers that need to run at a given time"
    default = 2
}

variable "fargate_cpu"{
    description= "Fargate instace CPU( in CPU Units)"
    default = "1024"
}

variable "fargate_cpu"{
    description= "Fargate instace memory( in MiB )"
    default = "2048"
}

variable "tag"{
    # While deploying the applcation we will be prompted to enter which version of the docker image to deploy
    # For automatic deployment, github actions will get a default ta
}