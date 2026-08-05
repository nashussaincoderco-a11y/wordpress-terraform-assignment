#!/bin/bash
# Update system packages
apt-get update -y
apt-get install -y docker.io docker-compose

# Start and enable Docker
systemctl start docker
systemctl enable docker

# Set up WordPress container environment
mkdir -p /opt/wordpress
cat << 'EOF' > /opt/wordpress/docker-compose.yml
version: '3.1'

services:
  wordpress:
    image: wordpress:latest
    restart: always
    ports:
      - "80:80"
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress_password
      WORDPRESS_DB_NAME: wordpress
  db:
    image: mysql:5.7
    restart: always
    environment:
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress_password
      MYSQL_ROOT_PASSWORD: root_password
EOF

# Launch the containers
cd /opt/wordpress
docker-compose up -d