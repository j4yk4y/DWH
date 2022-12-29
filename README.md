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
|--HLS-scraper\                                     # Webscraper for [Historical Dictionary of Switzerland (HDS)](https://hls-dhs-dss.ch/)
    |--.github\workflows\
        |--main.yml                      # Running Automated Unit Tests on each Commit
    |--.vscode\
        |--settings.josn                 # VScode Development Settings
    |--data\                             # Base Data Folder provided so that people don't need to rescrape HLS from scratch (12.12.2022)
        |--hls_base.csv                  
    |--hlsscraper\
        |--locators\                     # Selectors
            |--article.py
            |--family.py
            |--open_data.py
            |--person.py
            |--place.py
        |--pages\                        # Pages
            |--article.py
            |--family.py
            |--logging_utils.py
            |--open_data.py
            |--person.py
            |--place.py
        |--scraper.py                    # Web-Scraper
    |--tests\                            # Unit Tests
|--DWH_dags\airflow\dags\hls\                       # Airflow Pipeline
    |--hls_scrape.py                                # 1. HLS-Scraping
    |--hhb_aggregation.py                           # 2. Retrieve Hist-Hub Information
    |--hls_and_hhb_cleaning.py                      # 3. Clean HLS and HHB Data
    |--nlp_tagger.py                                # 4. Flair Named Entity Recognition Model German Large
    |--flair_cleaning.py                            # 5. Clean the Flair Model Output (Full Names and Locations)
    |--gmaps.py                                     # 6. Retrieve Google Maps Information for Flair Locations
    |--data_base.py                                 # 7. Push New and Updated Data to PostgresDB
    |--clean_up_temp.py                             # 8. Remove temporary files and folders
|--dwh_sql
    |--materialized_views\                          # All Materialized Views - Transforms and Load
        |--00_exploratory_data_analysis.sql         # A first MV to explore the data
        |--01_dim_author.sql                        # A list of article authors
        |--02_dim_institute.sql                     # Institutes Categorised
        |--03_dim_location.sql                      # Detailed location information with a natural geographic hierarchy
        |--04_dim_name.sql                          # Source dimension for article related data
        |--05_fact_institute.sql                    # Measure of how frequently insitutes are mentioned
        |--06_fact_location.sql                     # Measure of how often a location is mentioned
        |--07_fact_name.sql                         # Count of how many times an individual is named
        |--08_analysis_secret_council.sql           # The analytical view required to get an insight into the secret council
        |--09_analysis_geographic_analysis.sql      # The geographical footprint of people mentioned in the Lexicon
        |--10_analysis_influential_figures.sql      # A detailed view of influential figures
        |--11_network_analysis.sql                  # The network view of which articles mention which people

    |--stored_procedures\                           # Contains All SPROCs to Refresh MVs and load tables
        |--01_load_new.sql                          # Load any new article to the staging table
        |--02_update_existing.sql                   # Update any existing article 
        |--03_refresh_staging_mvs.sql               # Refresh the main staging table with new or updated articles
        |--04_dwh_data_cleaning.sql                 # Perform minor data cleaning
        |--05_dwh_update_dim_article.sql            # Update the dimensional data relating to the article
        |--06_dwh_update_fact_focal_point.sql       # Update the focal point fact table
        |--07_dwh_update_fact_influence.sql         # Update the influencer fact table
        |--08_dwh_update_fact_spread.sql            # Update the geographic spread fact table
        |--09_dwh_update_all_analytical_views.sql   # Refresh the main analytical views for Tableau

    |--visuals\                                     # Contains the Tableau Workbook file
        |--The Secret Council.twbx                  # The main Tableau workbook file
|--Dockerfile                                       # Used by docker-compose in order to build the airflow image
|--docker-compose.yaml                              # Used to start the instance of airflow and all its' modules
|--requirements.txt                                 # Used by the Dockerfile to install the required python packages
|--server_operation_manual.md                       # Short description of the server architecture as well as some instructions on Port forwarding
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

