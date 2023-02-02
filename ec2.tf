
resource "aws_instance" "new_instance" {
  count                       = length(var.public_subnet_cidrs)
  ami                         = var.ec2_ami
  instance_type               = var.instance_type
  key_name                    = var.ec2_keypair
  vpc_security_group_ids      = ["${aws_security_group.allow_web.id}"]
  subnet_id                   = element(aws_subnet.custom_subnet.*.id, count.index)
  associate_public_ip_address = true

  depends_on = [
    aws_subnet.custom_subnet,
  ]
}

resource "null_resource" "provision_instance" {
  count = length(var.public_subnet_cidrs)

  #depends_on = [
  # aws_instance.new_instance,
  #]
  provisioner "remote-exec" {
    inline = [
      "echo 'ssh connected'"
    ]
    connection {
      type        = "ssh"
      host        = aws_instance.new_instance[count.index].public_ip
      user        = "ubuntu"
      private_key = file("~/terraform-assignment/ass-key.cer")
    }
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.new_instance[count.index].public_ip} >> inventory && ansible-playbook -i inventory --private-key ${var.private_key_path} site.yml"


    #"ansible-playbook -i ${aws_instance.new_instance[count.index].public_ip}, --private-key ${var.private_key_path} site.yml"

    #"echo ${aws_instance.new_instance[count.index].public_ip} >> inventory && ansible-playbook -i #inventory site.yml"
    #only    = var.provision_instance == true
  }
}
