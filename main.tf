# Specify the AWS provider and region
provider "aws" {
  region = "us-east-1"
}

# Define the VPC ID
variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

# Define the Subnet ID
variable "subnet_id" {
  description = "ID of the subnet"
  type        = string
}

# Create the VPC
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create the subnet within the VPC
resource "aws_subnet" "example_subnet" {
  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
}

# Create the EC2 instances within the subnet
resource "aws_instance" "example_instance1" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  key_name      = "example_key_pair"
  subnet_id     = aws_subnet.example_subnet.id
  tags = {
    Name = "Example Instance 1"
  }
}

resource "aws_instance" "example_instance2" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  key_name      = "example_key_pair"
  subnet_id     = aws_subnet.example_subnet.id
  tags = {
    Name = "Example Instance 2"
  }
}

# Create an EBS volume for each instance
resource "aws_ebs_volume" "example_ebs_volume1" {
  availability_zone = "us-east-1a"
  size              = 10
  tags = {
    Name = "Example EBS Volume 1"
  }
}

resource "aws_ebs_volume" "example_ebs_volume2" {
  availability_zone = "us-east-1a"
  size              = 10
  tags = {
    Name = "Example EBS Volume 2"
  }
}

# Attach the EBS volumes to the instances
resource "aws_volume_attachment" "example_volume_attachment1" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.example_ebs_volume1.id
  instance_id = aws_instance.example_instance1.id
}

resource "aws_volume_attachment" "example_volume_attachment2" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.example_ebs_volume2.id
  instance_id = aws_instance.example_instance2.id
}

# Create the S3 bucket outside the VPC
resource "aws_s3_bucket" "example_s3_bucket" {
  bucket = "example-bucket"
  acl    = "private"
  tags = {
    Name = "Example S3 Bucket"
  }
}