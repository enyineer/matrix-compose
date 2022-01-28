#sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
#sudo chmod a+x /usr/local/bin/yq
#sudo apt install moreutils
sudo docker network rm matrix_backend
sudo docker network create --driver=bridge --subnet=10.10.10.0/24 --gateway=10.10.10.1 matrix_backend
sudo docker network rm matrix_frontend
sudo docker network create --driver=bridge --subnet=10.10.11.0/24 --gateway=10.10.11.1 matrix_frontend
# Create conf, then edit matrix/synapse/homserver.yml
sudo docker run -it --rm -v "$PWD/matrix/synapse:/data" -e SYNAPSE_SERVER_NAME=home.xhosted.de -e SYNAPSE_REPORT_STATS=no matrixdotorg/synapse:latest generate
# Edit database:
# database:
#   name: psycopg2
#   args:
#     user: synapse
#     password: STRONGPASSWORD
#     database: synapse
#     host: postgres
#     cp_min: 5
#     cp_max: 10