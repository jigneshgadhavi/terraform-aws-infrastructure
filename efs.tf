resource "aws_efs_file_system" "efs" {
  creation_token   = "efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "true"
  tags = {
    Name = "${var.cluser_name} EFS"
  }
}

resource "aws_efs_mount_target" "efs-mt" {
  count           = length(aws_subnet.main_vpc_subnet.*.id)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = element(aws_subnet.main_vpc_subnet.*.id, count.index)
  security_groups = ["${aws_security_group.efs.id}"]
}