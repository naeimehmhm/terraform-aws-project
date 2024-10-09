# # Create Security Group for ALB
# resource "aws_security_group" "alb_sg" {
#   vpc_id = aws_vpc.wordpress-vpc.id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP traffic from anywhere
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]  # Allow outbound traffic
#   }

#   tags = {
#     Name = "wordpress-alb-sg"
#   }
# }

# # Create the Application Load Balancer
# resource "aws_lb" "wordpress_alb" {
#   name               = "wordpress-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.alb_sg.id]
#   subnets            = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]

#   enable_deletion_protection = false

#   tags = {
#     Name = "wordpress-alb"
#   }
# }


# # Create Target Group for EC2 Instances
# resource "aws_lb_target_group" "wordpress_tg" {
#   name        = "wordpress-target-group"
#   port        = 80
#   protocol    = "HTTP"
#   vpc_id      = aws_vpc.wordpress-vpc.id
#   target_type = "instance"

#   health_check {
#     path                = "/"
#     interval            = 30
#     timeout             = 5
#     healthy_threshold   = 5
#     unhealthy_threshold = 2
#     matcher             = "200"
#   }

#   tags = {
#     Name = "wordpress-target-group"
#   }
# }


# # Create Listener for ALB
# resource "aws_lb_listener" "http_listener" {
#   load_balancer_arn = aws_lb.wordpress_alb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.wordpress_tg.arn
#   }
# }

# # Attach EC2 Instances to Target Group
# resource "aws_lb_target_group_attachment" "wordpress_tg_attachment" {
#   target_group_arn = aws_lb_target_group.wordpress_tg.arn
#   target_id        = aws_instance.wordpress-able.id
#   port             = 80
# }
