# Copyright 2016 Chris Marchesi
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Terraform tempalte for a simple VPC, ELB, and 3 instances off of an AWS SDK.

variable region {}
variable ami_id {}
variable vpc_subnet {
  default = "10.0.0.0/24"
}

provider aws {
  region = "${var.region}"
}

resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_subnet}"
}

resource "aws_subnet" "vpc_subnet" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.vpc_subnet}"
  map_public_ip_on_launch = false
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route_table" "public_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route_table_association" "public_route_table_association" {
  subnet_id = "${aws_subnet.vpc_subnet.id}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}

resource "aws_route" "public_default_route" {
  route_table_id = "${aws_route_table.public_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.internet_gateway.id}"
}

resource "aws_security_group" "instance_security_group" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_security_group_rule" "instance_security_group_inbound" {
  type = "ingress"
  from_port = 4567
  to_port = 4567
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.instance_security_group.id}"
}

resource "aws_security_group" "elb_security_group" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_security_group_rule" "elb_security_group_inbound" {
  type = "ingress"
  from_port = 4567
  to_port = 4567
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.elb_security_group.id}"
}

resource "aws_security_group_rule" "elb_security_group_outbound" {
  type = "egress"
  from_port = 4567
  to_port = 4567
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.elb_security_group.id}"
}

resource "aws_elb" "elb" {
  subnets = ["${aws_subnet.vpc_subnet.id}"]
  security_groups = ["${aws_security_group.elb_security_group.id}"]

  listener {
    instance_port = 4567
    instance_protocol = "http"
    lb_port = 4567
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:4567/"
    interval = 30
  }

  instances = ["${aws_instance.web_servers.*.id}"]
}

resource "aws_instance" "web_servers" {
  count = 3
  ami = "${var.ami_id}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.vpc_subnet.id}"
  security_groups = ["${aws_security_group.instance_security_group.id}"]
}

output "elb_hostname" {
  value = "${aws_elb.elb.dns_name}"
}
