FROM parrot.run/security
MAINTAINER SHAKUGAN <shakugan@disbox.net>

RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN apt update && apt-get upgrade -y && apt-get -y dist-upgrade && apt-get -y autoremove
RUN apt-get install -y tzdata locales openssh-server sudo curl vim wget build-essential net-tools dialog apt-utils libevent* libsecret* tor parrot-tools-full
RUN locale-gen en_US.UTF-8
RUN apt-get install -y -d parrot-interface parrot-interface-full


RUN useradd -m -s /bin/bash shakugan
RUN usermod -append --groups sudo shakugan
RUN echo "shakugan:AliAly032230" | chpasswd
RUN echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# sshd
RUN mkdir -p /var/run/sshd
RUN sed -i 's\#PermitRootLogin prohibit-password\PermitRootLogin yes\ ' /etc/ssh/sshd_config
RUN sed -i 's\#PubkeyAuthentication yes\PubkeyAuthentication yes\ ' /etc/ssh/sshd_config
RUN apt clean

# VSCODETOr

RUN wget https://github.com/coder/code-server/releases/download/v4.10.0/code-server_4.10.0_amd64.deb
RUN dpkg -i code-server_4.10.0_amd64.deb
RUN mkdir -p ~/.config/code-server
RUN echo "password: AliAly032230" >> ~/.config/code-server/config.yaml
RUN rm -rf code-server_4.10.0_amd64.deb

RUN wget -O - https://deb.nodesource.com/setup_19.x | bash && apt-get -y install nodejs

#RUN wget https://download.nomachine.com/download/8.4/Linux/nomachine_8.4.2_1_amd64.deb && dpkg -i nomachine_8.4.2_1_amd64.deb

# TOr

RUN echo "HiddenServiceDir /var/lib/tor/onion/" >> /etc/tor/torrc
RUN echo "HiddenServicePort 80 127.0.0.1:80" >> /etc/tor/torrc
RUN echo "HiddenServicePort 22 127.0.0.1:22" >> /etc/tor/torrc
RUN echo "HiddenServicePort 8080 127.0.0.1:8080" >> /etc/tor/torrc
RUN echo "HiddenServicePort 4000 127.0.0.1:4000" >> /etc/tor/torrc
RUN echo "HiddenServicePort 8000 127.0.0.1:8000" >> /etc/tor/torrc
RUN echo "HiddenServicePort 9000 127.0.0.1:9000" >> /etc/tor/torrc
RUN echo "HiddenServicePort 3389 127.0.0.1:3389" >> /etc/tor/torrc
RUN echo "HiddenServicePort 10000 127.0.0.1:10000" >> /etc/tor/torrc

# CONFIG
RUN echo "service tor start" >> /VSCODETOr.sh
RUN echo "cat /var/lib/tor/onion/hostname" >> /VSCODETOr.sh
RUN echo "code-server --bind-addr 127.0.0.1:10000" >> /VSCODETOr.sh
#RUN echo "code-server --bind-addr 127.0.0.1:12345 >> vscode.log &"  >>/VSCODETOr.sh
#RUN echo "lt --port 12345 >> localtunnel &"  >>/VSCODETOr.sh
#RUN echo "tor >> tor.log &"  >>/VSCODETOr.sh
#RUN echo "./tmate -F >> tmate.log &"  >>/VSCODETOr.sh
#RUN echo 'echo "######### wait Tor #########"' >>/VSCODETOr.sh
#RUN echo 'sleep 1m' >>/VSCODETOr.sh
#RUN echo "cat tmate.log"  >>/VSCODETOr.sh
#RUN echo "cat localtunnel" >>/VSCODETOr.sh
#RUN echo "cat /var/lib/tor/hidden_service/hostname" >>/VSCODETOr.sh
#RUN echo "sed -n '3'p ~/.config/code-server/config.yaml" >>/VSCODETOr.sh
#RUN echo 'echo "######### OK #########"' >>/VSCODETOr.sh
#RUN echo 'sleep 90d' >>/VSCODETOr.sh

RUN chmod 755 /VSCODETOr.sh
EXPOSE 10000

CMD  ./VSCODETOr.sh
