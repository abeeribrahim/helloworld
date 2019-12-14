# FROM jenkins/jenkins:lts
# USER root
# RUN apt-get update && \
# apt-get -y install apt-transport-https \
#     ca-certificates \
#     curl \
#     gnupg2 \
#     software-properties-common && \
# curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
# add-apt-repository \
#     "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
#     $(lsb_release -cs) \
#     stable" && \
# apt-get update && \
# apt-get -y install docker-ce
# RUN apt-get install -y docker-ce
# CMD DOCKER_GID=$(stat -c '%g' /var/run/docker.sock) && \
#     groupadd -for -g ${DOCKER_GID} docker && \
#     usermod -aG docker jenkins && \
#     sudo -E -H -u jenkins bash -c /usr/local/bin/jenkins.sh
# RUN sudo usermod -a -G docker jenkins
# USER jenkins

# ############################################################
# # Dockerfile to build Nginx Installed Containers
# # Based on Ubuntu
# ############################################################


# Set the base image to Ubuntu
FROM ubuntu


# Install Nginx

# Add application repository URL to the default sources
# RUN echo "deb http://archive.ubuntu.com/ubuntu/ raring main universe" >> /etc/apt/sources.list

# Update the repository
RUN apt-get update

# Install necessary tools
RUN apt-get install -y vim wget dialog net-tools

RUN apt-get install -y nginx

# Remove the default Nginx configuration file
RUN rm -v /etc/nginx/nginx.conf

# Copy a configuration file from the current directory
ADD nginx.conf /etc/nginx/

RUN mkdir /etc/nginx/logs

# Add a sample index file
ADD index.html /www/data/

# Append "daemon off;" to the beginning of the configuration
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Create a runner script for the entrypoint
COPY runner.sh /runner.sh
RUN chmod +x /runner.sh

# Expose ports
EXPOSE 80

ENTRYPOINT ["/runner.sh"]

# Set the default command to execute
# when creating a new container
CMD ["nginx"]