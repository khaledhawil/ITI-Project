resource "tls_private_key" "my_key" { 
algorithm = "RSA" 
rsa_bits = 2048 
}
resource "local_file" "private_key" {
  filename = "${path.module}/Project_Keys/jenkins.pem"
  content  = tls_private_key.my_key.private_key_pem
  file_permission = "0600"
}

resource "local_file" "public_key" {
  filename = "${path.module}/Project_Keys/jenkins.pub"
  content  = tls_private_key.my_key.public_key_openssh
}


resource "aws_key_pair" "my_key_pair" { 
    key_name = "jenkins" # Desired key name 
     public_key = local_file.public_key.content
     depends_on = [ tls_private_key.my_key ]
}

# resource "null_resource" "Change_key_permission" {
#   depends_on = [ tls_private_key.my_key ]
#   provisioner "local-exec" {
#     command = "echo '0' | sudo -S chmod 400 ./jenkins.pem"
#   }  
#  }