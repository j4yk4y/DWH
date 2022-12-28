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

## Server Admin

Current Setup:

OS: Centos 8
RAM: 4GB
Cores: 2
Disk: 40GB SSD

SLL: not yet
Domain: `test.aiforge.ch`

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

````bash
ssh centos@86.119.36.239 -L 9090:localhost:9090
````