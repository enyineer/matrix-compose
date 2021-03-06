# matrix-compose 🧝
A simple starting point for self-hosting a matrix server with a massive feature list:
- Synapse Server (Matrix Server)
- Element Client (Matrix Client)
- Postgresql as database
- Synapse-Admin Backend
- NGINX Reverse Proxy
- Fully Automatic LetsEncrypt Certificates

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

Set `SYNAPSE_ADMIN_URL` to the hostname of your synapse admin backend url

### Edit homeserver.yaml 📃
Open the previously generated homserver.yaml file

```
sudo nano matrix/synapse/homeserver.yaml
```
Replace the "database:" property with the following:
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
See [Synapse GitHub](https://github.com/matrix-org/synapse/tree/develop/docker#generating-an-admin-user) for a tutorial on how to do this. Replace "synapse" (containers name) in the provided command with `matrix-compose_synapse_1` - which is the auto-generated name of your docker-compose synapse server container.

## hello world
If you want anyone from the world wide web to be able to open your element instance or connect to your Synapse-Server, simply open/forward the following ports to your docker host:
```
80/tcp (For letsencrypt challenge)
443/tcp (For Element and Synapse HTTPS traffic)
8448/tcp (For Synapse federation)
```