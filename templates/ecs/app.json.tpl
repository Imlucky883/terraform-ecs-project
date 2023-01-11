{
    "name":"my_app",
    "image": "${docker_image}:${tag}",
    "cpu": $(fargate_cpu},
    "memory": ${fargate_memory},
    "networkMode" : "awsvpc",
    "portMappings": [
    {
        "containerPort": ${app_port},
        "hostPort": ${app_port},
    }
]