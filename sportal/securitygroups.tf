resource "aws_security_group" "sportal_web" {
  name        = "sportal_web"
  description = "Sportal Web Server access SG"
  vpc_id      = "${aws_vpc.main.id}"

  # allow traffic to HTTP port
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${aws_eip.ansible_host_ip.public_ip}/32", "82.25.7.144/32", "62.253.83.190/32", "109.73.148.70/32"]
  }

  ingress {
    security_groups = ["${aws_security_group.Ansible_SSH_Access.id}", "${aws_security_group.openvpn.id}"]
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    self            = true
  }

  ingress {
    security_groups = ["${aws_security_group.Ansible_SSH_Access.id}", "${aws_security_group.openvpn.id}"]
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    self            = true
  }

  ingress {
    security_groups = ["${aws_security_group.sportal_web_elb.id}"]
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    self            = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "Sportal Web SG"
    Application = "sportal"
  }
}

resource "aws_security_group" "sportal_web_efs" {
  name        = "sportal_web_efs"
  description = "Sportal Web Efs access SG"
  vpc_id      = "${aws_vpc.main.id}"

  # allow NFS traffic 
  ingress {
    security_groups = ["${aws_security_group.sportal_cms.id}", "${aws_security_group.sportal_web.id}", "${aws_security_group.Ansible_SSH_Access.id}"]
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
  }

  tags {
    Name        = "Sportal Web EFS SG"
    Application = "sportal"
  }
}

resource "aws_security_group" "sportal_cms_efs" {
  name        = "sportal_cms_efs"
  description = "Sportal CMS Efs access SG"
  vpc_id      = "${aws_vpc.main.id}"

  # allow NFS traffic
  ingress {
    security_groups = ["${aws_security_group.sportal_cms.id}", "${aws_security_group.Ansible_SSH_Access.id}"]
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
  }

  tags {
    Name        = "Sportal cms EFS SG"
    Application = "sportal"
  }
}

resource "aws_security_group" "Ansible_SSH_Access" {
  name        = "ANSIBLE-SSH-ACCESS"
  description = "Ansible SSH access SG"
  vpc_id      = "${aws_vpc.main.id}"

  # allow traffic to SSH port
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["62.253.83.190/32", "82.11.218.115/32", "82.25.7.144/32", "82.27.144.252/32", "109.73.148.70/32", "185.42.236.254/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "Ansible Host SSH Access SG"
    Application = "sportal"
  }
}

resource "aws_security_group" "openvpn" {
  name        = "openvpn-sg"
  description = "openvpn access SG"
  vpc_id      = "${aws_vpc.main.id}"

  # allow traffic to SSH port
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["62.253.83.190/32", "82.11.218.115/32", "82.25.7.144/32", "82.27.144.252/32", "176.26.193.114/32", "109.73.148.70/32"]
  }

  # allow traffic to HTTPS port
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow traffic to Admin port
  ingress {
    from_port   = 943
    to_port     = 943
    protocol    = "tcp"
    cidr_blocks = ["62.253.83.190/32", "82.11.218.115/32", "82.25.7.144/32", "82.27.144.252/32", "176.26.193.114/32", "109.73.148.70/32"]
  }

  # allow traffic to UDP OVPN port
  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "openvpn Access SG"
    Application = "sportal"
  }
}

resource "aws_security_group" "sportal_cms" {
  name        = "sportal_cms"
  description = "Sportal CMS Server access SG"
  vpc_id      = "${aws_vpc.main.id}"

  # allow traffic to HTTP port
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${aws_eip.ansible_host_ip.public_ip}/32", "82.25.7.144/32", "62.253.83.190/32", "109.73.148.70/32"]
  }

  ingress {
    security_groups = ["${aws_security_group.Ansible_SSH_Access.id}", "${aws_security_group.openvpn.id}"]
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    self            = true
  }

  ingress {
    security_groups = ["${aws_security_group.openvpn.id}"]
    from_port       = 4000
    to_port         = 4000
    protocol        = "tcp"
    self            = true
  }

  ingress {
    security_groups = ["${aws_security_group.openvpn.id}"]
    from_port       = 4000
    to_port         = 4000
    protocol        = "udp"
    self            = true
  }

  ingress {
    security_groups = ["${aws_security_group.openvpn.id}"]
    from_port       = 81
    to_port         = 81
    protocol        = "tcp"
    self            = true
  }

  ingress {
    security_groups = ["${aws_security_group.sportal_cms_elb.id}"]
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    self            = true
  }

  ingress {
    security_groups = ["${aws_security_group.sportal_ftp_elb.id}"]
    from_port       = 0
    to_port         = 0
    protocol        = "tcp"
    self            = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "Sportal CMS SG"
    Application = "sportal"
  }
}

resource "aws_security_group" "sportal_web_elb" {
  name        = "sportal_web_elb"
  description = "Sportal Web ELB access SG"
  vpc_id      = "${aws_vpc.main.id}"

  # allow traffic to HTTP port
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "Sportal Web ELB SG"
    Application = "sportal"
  }
}

resource "aws_security_group" "sportal_cms_elb" {
  name        = "sportal_cms_elb"
  description = "Sportal CMS ELB access SG"
  vpc_id      = "${aws_vpc.main.id}"

  # allow traffic to HTTP port
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "Sportal CMS ELB SG"
    Application = "sportal"
  }
}

resource "aws_security_group" "sportal_ftp_elb" {
  name        = "sportal_ftp_elb"
  description = "Sportal FTP ELB access SG"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 21
    to_port     = 21
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 20
    to_port     = 20
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1024
    to_port     = 1048
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "Sportal FTP ELB SG"
    Application = "sportal"
  }
}

resource "aws_security_group" "sportal_db" {
  name        = "sportal_dg"
  description = "Sportal DB access SG"
  vpc_id      = "${aws_vpc.main.id}"

  # allow traffic to MYSQL port
  ingress {
    security_groups = ["${aws_security_group.sportal_cms.id}", "${aws_security_group.sportal_web.id}", "${aws_security_group.Ansible_SSH_Access.id}", "${aws_security_group.openvpn.id}"]
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    self            = true
  }

  tags {
    Name        = "Sportal DB SG"
    Application = "sportal"
  }
}

resource "aws_security_group" "ops_monitoring" {
  name        = "monitoring"
  description = "Sportal monitoring access SG"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    security_groups = ["${aws_security_group.Ansible_SSH_Access.id}", "${aws_security_group.openvpn.id}"]
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    self            = true
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["82.25.7.144/32", "62.253.83.190/32", "109.73.148.70/32"]
  }

  tags {
    Name        = "Sportal Monitoring SG"
    Application = "sportal"
  }
}
