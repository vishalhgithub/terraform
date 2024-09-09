resource "aws_instance" "natural" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name

  tags = {
    Name = var.instance_name
  }

    
    user_data = <<-EOF
    #!/bin/bash
    exec > /var/log/user-data.log 2>&1
    set -x

    # Install AWS CLI if not installed
    if ! command -v aws &> /dev/null; then
      sudo apt-get update -y
      sudo apt-get install awscli -y
    fi

    # Define the S3 bucket and the script name
    BUCKET_NAME="mynatural"
    SCRIPT1_NAME="config.sh"
    SCRIPT2_NAME="NaturalAPIMYRUN.sh"
    SCRIPT3_NAME="naturalMVCMYRUN.txt"
    
    # change the directory
    cd /home/ubuntu

    # clone the files
    git clone https://github.com/vishalhgithub/natural.git

    # Make the script executable
    chmod +x /home/ubuntu/natural/dotnet.sh

    # Make the script executable
    chmod +x /home/ubuntu/Atural/PI.sh

    # Make the script executable
    chmod +x /home/ubuntu/natural/MVC.sh

    # Execute the script
    bash /home/ubuntu/natural/dotnet.sh
  EOF
}


resource "null_resource" "create_ami" {
  provisioner "local-exec" {
    command = <<-EOT
      sleep 120  # Wait for 30 seconds before creating the AMI
      ami_id=$(aws ec2 create-image --instance-id ${aws_instance.natural.id} --region ap-south-1 --name "ConfiguredAMI" --description "An AMI of the configured instance" --no-reboot --query 'ImageId' --output text)
      echo "ami_id=$${ami_id}" > ami_id.txt
    EOT
  }

  depends_on = [aws_instance.natural]
}

