# Data Warehouse and Data Lake Project (Secret Council)

**Authors:** Jorit Studer, Keith Lawless and Remo Kälin

**Module:** Data Warehouse and Data Lake Systems (January 8th, 2023)

**Supervisor:** Aigul Kaskina, José Mancera and Luis Terán


## Cloning the repo

````bash
git clone --recurse-submodules -j8 git@github.com:j4yk4y/DWH.git
````

## Project Structure

```
|--HLS-scraper\                   # Webscraper for [Historical Dictionary of Switzerland (HDS)](https://hls-dhs-dss.ch/)
|--DWH_dags\airflow\dags\hls\     # Airflow Pipeline
    |--hls_scrape.py                 # 1. HLS-Scraping
    |--hhb_aggregation.py            # 2. Retrieve Hist-Hub Information
    |--hls_and_hhb_cleaning.py       # 3. Clean HLS and HHB Data
    |--nlp_tagger.py                 # 4. Flair Named Entity Recognition Model German Large
    |--flair_cleaning.py             # 5. Clean the Flair Model Output (Full Names and Locations)
    |--gmaps.py                      # 6. Retrieve Google Maps Information for Flair Locations
    |--data_base.py                  # 7. Push New and Updated Data to PostgresDB
    |--clean_up_temp.py              # 8. Remove temporary files and folders
|--dwh_sql\                       # PostgresDB (Stored Procedures & Materliazed Views)
```

## Development

Updating the Submodules:

````bash
git submodule update --remote
````

## Server Admin

Current Setup:

OS: Centos 8
RAM: 8GB
Cores: 4
Disk: 2x50GB (failover)

SLL: implemented with Certbot
Domain: `test.aiforge.ch`

The following command starts portainer on the server. Portainer is used to monitor the health and logs of the PostgreSQL database, as well as all the airflow instances.

````bash
sudo docker run -d -p 9443:9443 -p 8000:8000 \
    --name portainer_ssl --restart always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    -v /etc/letsencrypt/live/test.aiforge.ch:/certs/live/test.aiforge.ch:ro \
    -v /etc/letsencrypt/archive/test.aiforge.ch:/certs/archive/test.aiforge.ch:ro \
    portainer/portainer-ce:latest \
    --sslcert /certs/live/test.aiforge.ch/fullchain.pem \
    --sslkey /certs/live/test.aiforge.ch/privkey.pem
````

## SSH-Tunneling

We use SSH-Tunneling to access airflow in order to maintain security.

````bash
ssh centos@86.119.36.239 -L 9090:localhost:9090
````

## Starting Airflow

The Airflow instances are containerized. In order to start them, use the following command in the linux shell:

````bash
docker compose up -d
````

This will call the docker-compose file and build the image automatically by executing the contents of the Dockerfile itself. We use an adapted docker-compose file from Airflows official repositories. The adaptions mainly center around installing custom python packages and setting the correct python version (3.9 required).

For lecturers we reccommend the official report. The "server_operation_manual.md" is designed to give an overview of the server setup, as well as an introduction to SSH-Tunneling. It is therefore more aimed towards fellow students. 

