# Use -h mail.example.com to set the hostname for this mail server
FROM phusion/baseimage
MAINTAINER Brian Morton <brian@xq3.net>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update && apt-get install -q -y language-pack-en
RUN update-locale LANG=en_US.UTF-8
RUN apt-get -y update && apt-get install -q -y postfix

RUN postconf -e mail_spool_directory="/var/spool/mail/"
RUN postconf -e mailbox_command=""
RUN postconf -e virtual_alias_maps="hash:/etc/virtual"

# Setup HTTP POSTing of emails using Ruby
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install ruby1.9.1 ruby1.9.1-dev \
  rubygems1.9.1 libopenssl-ruby1.9.1 libssl-dev zlib1g-dev
RUN gem install incoming --no-ri --no-rdoc

# Update virtual domains
RUN touch /etc/virtual
RUN chown root:root /etc/virtual

# Update aliases
ADD aliases /etc/aliases
RUN chown root:root /etc/aliases
RUN newaliases

RUN touch /var/log/mail.log

ADD env /env
RUN chmod +x /env

EXPOSE 25
ENTRYPOINT ["/env"]
CMD ["sh", "-c", "service syslog-ng start ; service postfix start ; tail -f /var/log/mail.log"]
