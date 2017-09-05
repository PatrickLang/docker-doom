FROM ubuntu:16.04

#Disable Upstart (not sure if 16.04 still has Upstart but whatever)
RUN dpkg-divert --local --rename --add /sbin/initctl && \
 ln -sf /bin/true /sbin/initctl && \
 ln -sf /bin/false /usr/sbin/policy-rc.d

#Update the OS
RUN apt-get update --yes ; apt-get install -y software-properties-common curl sudo ; apt-get upgrade --yes

#Specifically add the Zandronum repo and install the application
RUN apt-add-repository 'deb http://debian.drdteam.org/ stable multiverse'
RUN curl http://debian.drdteam.org/drdteam.gpg | sudo apt-key add -
RUN apt-get update && apt-get upgrade
RUN apt-get install --yes --quiet libsdl-image1.2 zandronum 

#Create a non-privileged user
RUN useradd -ms /bin/bash zandronum
USER zandronum
WORKDIR /home/zandronum

#Build the application directory and add files
RUN mkdir /home/zandronum/config && \
  mkdir /home/zandronum/wads && \
  mkdir /home/zandronum/iwads && \
  mkdir /home/zandronum/bin/
ADD /zandronum/config/ /home/zandronum/config/
ADD /zandronum/bin/ /home/zandronum/bin/

CMD ["/zandronum/srv-exec/summon.sh"]
ENTRYPOINT ["/zandronum/srv-exec/summon"]
EXPOSE 10666
