resource "aws_efs_file_system" "disk" {
  performance_mode = "generalPurpose"
  encrypted        = true

  tags = {
    Name = "efs-disk"
  }
}

resource "aws_efs_mount_target" "efs-mount" {
  file_system_id  = aws_efs_file_system.disk.id
  subnet_id       = your-efs_subnet_ids
  security_groups = your-efs_security_groups
}
