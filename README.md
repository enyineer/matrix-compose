# matrix-compose
A simple starting point for self-hosting a synapse server with nginx + letsencrypt as a reverse proxy

## Setup
### Create networks and Config
Open the file setup.sh and change SYNAPSE_SERVER_NAME to your Synapse Home URL

After that, run:

```
chmod +x setup.sh
./setup.sh
```

This creates a docker network named matrix_backend and matrix_frontend which will later be used by services defined in the docker-compose file.

### Set Variables
Copy the .evn.example file to a .env file:
```
cp .env.example .env
```
Set `POSTGRES_PASSWORD` to a randomly generated password

Set `LETSENCRYPT_MAIL` to your email for Lets-Encrypt notifications

Set `ELEMENT_URL` to the hostname of your element url

Set `SYNAPSE_URL` to the hostname of your synapse home url

### Edit homeserver.yaml
Open the previously generated homserver.yaml file

```
sudo nano matrix/synapse/homeserver.yaml
```
Replace the database: property with the following:
```
database:
  name: psycopg2
  args:
    user: synapse
    password: <the .env Postgresql password>
    database: synapse
    host: postgres
    cp_min: 5
    cp_max: 10
```
Save the file.

## Start the engines 🚂
Run:
```
chmod +x start.sh
./start.sh
```