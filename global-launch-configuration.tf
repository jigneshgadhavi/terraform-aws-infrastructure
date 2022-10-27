resource "random_id" "id_lc" {
	  byte_length = 8
}

resource "aws_launch_configuration" "ecs_asg_lc" {
  name                 = "${var.stack_name}_${random_id.id_lc.hex}_lc"
  image_id             = var.image_id
  instance_type        = var.instance-type
  iam_instance_profile = aws_iam_instance_profile.asg_ec2_instance_profile.name
  security_groups      = [aws_security_group.asg_ec2_devser.id]
  user_data            = <<EOF
#!/bin/bash
yum update -y
echo ECS_CLUSTER=${var.cluser_name} >> /etc/ecs/ecs.config
echo ${var.cluser_name}.local > /etc/hostname
echo 127.0.0.1 ${var.cluser_name}.local >> /etc/hosts
reboot
  EOF

  key_name                    = "ec2-e2msolutions-com"
  associate_public_ip_address = true
  enable_monitoring           = true
  root_block_device {
    volume_type = "gp3"
    volume_size = "30"
    iops        = "3000"
    throughput  = "400"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "shared_ecs_asg_lc" {
  name                 = "${var.shared_cluster_name}_${random_id.id_lc.hex}_lc"
  image_id             = var.image_id
  instance_type        = var.instance-type
  iam_instance_profile = aws_iam_instance_profile.asg_ec2_instance_profile.name
  security_groups      = [aws_security_group.asg_ec2_shared.id]
  user_data            = <<EOF
#!/bin/bash
yum update -y
echo ECS_CLUSTER=${var.shared_cluster_name} >> /etc/ecs/ecs.config
echo ${var.shared_cluster_name}.local > /etc/hostname
echo 127.0.0.1 ${var.shared_cluster_name}.local >> /etc/hosts
reboot
  EOF

  key_name                    = "ec2-e2msolutions-com"
  associate_public_ip_address = true
  enable_monitoring           = true
  root_block_device {
    volume_type = "gp3"
    volume_size = "30"
    iops        = "3000"
    throughput  = "400"
  }
  lifecycle {
    create_before_destroy = true
  }
}