FROM phusion/baseimage
MAINTAINER Brian Morton <brian@xq3.net>

RUN apt-get update && apt-get install -q -y language-pack-en
RUN update-locale LANG=en_US.UTF-8

# Use -h mail.example.com to set the hostname for this mail server
ENV DOMAIN hippunk.com
ENV SHARED_SECRET 1234123412341234
ENV POST_ENDPOINT http://requestb.in/qnu88zqn

# Install Postfix.
RUN echo "postfix postfix/main_mailer_type string Internet site" > preseed.txt
RUN echo "postfix postfix/mailname string mail.$DOMAIN" >> preseed.txt

# Use Mailbox format.
RUN debconf-set-selections preseed.txt
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y postfix

RUN postconf -e myhostname=$DOMAIN
RUN postconf -e mydestination="mail.$DOMAIN, $DOMAIN, localhost.localdomain, localhost"
RUN postconf -e mail_spool_directory="/var/spool/mail/"
RUN postconf -e mailbox_command=""
RUN postconf -e virtual_alias_maps="hash:/etc/virtual"

# Setup HTTP POSTing of emails using Ruby
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install ruby1.9.1 ruby1.9.1-dev \
  rubygems1.9.1 libopenssl-ruby1.9.1 libssl-dev zlib1g-dev
RUN gem install incoming --no-ri --no-rdoc

# Update virtual domains
RUN echo "@$DOMAIN http_post" > /etc/virtual
RUN chown root:root /etc/virtual
RUN postmap /etc/virtual

# Update aliases
RUN echo "http_post: \"|/usr/local/bin/http_post -s $SHARED_SECRET $POST_ENDPOINT\"" > /etc/aliases
RUN chown root:root /etc/aliases
RUN newaliases

RUN touch /var/log/mail.log

EXPOSE 25
CMD ["sh", "-c", "service syslog-ng start ; service postfix start ; tail -f /var/log/mail.log"]
