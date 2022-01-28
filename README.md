# matrix-compose 🧝
A simple starting point for self-hosting a synapse server with nginx + letsencrypt as a reverse proxy and element as a frontend.

## Setup 🔨
### Create networks and Config 🧑‍💻
Open the file setup.sh and change SYNAPSE_SERVER_NAME to your Synapse Home URL

After that, run:

```
chmod +x setup.sh
./setup.sh
```

This creates a docker network named matrix_backend and matrix_frontend which will later be used by services defined in the docker-compose file.

### Set Variables 📝
Copy the .evn.example file to a .env file:
```
cp .env.example .env
```
Set `POSTGRES_PASSWORD` to a randomly generated password

Set `LETSENCRYPT_MAIL` to your email for Lets-Encrypt notifications

Set `ELEMENT_URL` to the hostname of your element url

Set `SYNAPSE_URL` to the hostname of your synapse home url

### Edit homeserver.yaml 📃
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
Replace the default listeners resources (under listeners object) with this:
```
- names: [client, federation, openid]
```
Save the file.

### Edit the element config 📜
Open matrix/element/element-config.json and replace the following with your data:
```
"base_url": "https://home.xhosted.de",
"server_name": "XHosted"
```

### First start 🚀
Start your compose file once to create all the data directories:
```
docker-compose up -d
```
After it started, shut it down:
```
docker-compose down
```

### Add federation port to nginx-proxy host 🛂
Create a new file in the vhost directory
```
nano matrix/nginx/vhost/your.synapse.domain
```
And paste:
```
# For the federation port
listen 8448 ssl http2 default_server;
listen [::]:8448 ssl http2 default_server;
```
Save the file.

You are done configuring!

## Start the engines 🚂
Run:
```
docker-compose up -d
```

## Add an admin user 🧑‍🦰
See [Synapse GitHub](https://github.com/matrix-org/synapse/tree/develop/docker#generating-an-admin-user) for a tutorial on how to do this. Switch "synapse" (containers name) in with `matrix-compose_synapse_1`.