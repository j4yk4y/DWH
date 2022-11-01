# DWH
Data Warehouse and Data Lake Project















## Server Admin

Current Setup:

OS: Centos 8
RAM: 4GB
Cores: 2
Disk: 40GB SSD

SLL: not yet
Domain: test.aiforge.ch




sudo docker run -d -p 9443:9443 -p 8000:8000 \
    --name portainer_ssl --restart always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    -v /etc/letsencrypt/live/test.aiforge.ch:/certs/live/test.aiforge.ch:ro \
    -v /etc/letsencrypt/archive/test.aiforge.ch:/certs/archive/test.aiforge.ch:ro \
    portainer/portainer-ce:latest \
    --sslcert /certs/live/test.aiforge.ch/fullchain.pem \
    --sslkey /certs/live/test.aiforge.ch/privkey.pem



ssh centos@86.119.36.239 -L 9090:localhost:9090
