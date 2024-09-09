output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.natural.id
}

output "public_ip" {
  description = "The public IP address of the instance"
  value       = aws_instance.natural.public_ip
}

output "private_ip" {
  description = "The private IP address of the instance"
  value       = aws_instance.natural.private_ip
}

data "local_file" "ami_id_file" {
  depends_on = [null_resource.create_ami]
  filename = "${path.module}/ami_id.txt"
}

output "configured_ami_id" {
  value = data.local_file.ami_id_file.content
}

