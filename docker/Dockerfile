FROM ubuntu:18.04
#FROM tiangolo/uwsgi-nginx-flask:python3.7
LABEL maintainer="Jonathan LEGRAND <jonathan.legrand@ens-lyon.fr>"
# To build docker image run following command from 'docker/' folder:
# $ docker build -t romidb romiDB/
# To start built docker image:
# $ docker run -it -p 5000:5000 -v /data/ROMI/integration_tests:/home/romi/db_test romidb
# To clean-up after build:
# $ docker rm $(docker ps -a -q)
ENV LANG=C.UTF-8
ENV PYTHONUNBUFFERED=1

# Set non-root user name:
ENV SETUSER=romi

USER root
# Change shell to 'bash', default is 'sh'
SHELL ["/bin/bash", "-c"]
# Update package manager & install requirements:
RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
    git ca-certificates \
    python3 python3-pip python3-wheel && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -m ${SETUSER} && \
    cd /home/${SETUSER} && \
    mkdir project && \
    chown -R ${SETUSER}: /home/${SETUSER}

# Change user
USER ${SETUSER}
# Change working directory:
WORKDIR /home/${SETUSER}/project

RUN git clone https://github.com/romi/data-storage.git && \
    cd data-storage && \
    pip3 install setuptools setuptools-scm flask flask-restful flask-cors && \
    pip3 install . && \
    git clone https://github.com/romi/Scan3D.git && \
    cd Scan3D && \
#    pip3 install setuptools flask flask-restful flask-cors && \
    pip3 install . && \
    # Initialize a test databse:
    cd ~/ && \
    mkdir db_test

ENV DB_LOCATION="/home/${SETUSER}/db_test"
# Start a Flask server:
CMD ["/bin/bash", "-c", "python3 ~/project/data-storage/bin/romi_scanner_rest_api"]