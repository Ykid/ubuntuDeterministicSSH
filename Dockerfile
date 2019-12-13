FROM ubuntu

WORKDIR /home

RUN apt-get update && apt-get install -y openssh-server
RUN apt-get install -y net-tools iputils-ping iproute2

COPY ssh_host_* "/etc/ssh/"
#RUN  ssh-keygen -t ed25519 -b 521 -N "" -f ssh_host_ed25519_key
#RUN  ssh-keygen -t ecdsa -b 521 -N "" -f ssh_host_ecdsa_key


#RUN echo 'root:password' | chpasswd
RUN echo "export VISIBLE=now" >> /etc/profile

# RUN sed -i '/#PasswordAuthentication yes/s/^#//g' /etc/ssh/sshd_config
RUN sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/" /etc/ssh/sshd_config
RUN sed -i "s/#Port 22.*/Port 8023/" /etc/ssh/sshd_config

# configure ssh connection
COPY ssh_docker_key.pub /home/ssh_docker_key.pub
RUN mkdir -p ~/.ssh
RUN cat /home/ssh_docker_key.pub >> ~/.ssh/authorized_keys

ENTRYPOINT ["bash", "-c", "service ssh restart && bash"]