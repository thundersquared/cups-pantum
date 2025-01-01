# syntax=docker/dockerfile:1
ARG DEBIAN_FRONTEND=noninteractive
FROM debian:bullseye-slim

ENV ADMIN_PASSWORD=admin

# Install required packages for building
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    sudo \
    cups \
    cups-bsd \
    cups-filters \
    foomatic-db-compressed-ppds \
    printer-driver-all \
    openprinting-ppds \
    hpijs-ppds \
    hp-ppd \
    hplip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Download and install Pantum driver
WORKDIR /tmp
RUN curl -fsSLo driver.zip -H 'Referer: https://global.pantum.com/support/download/driver/' \
    'https://drivers.pantum.com/userfiles/files/download/drive/2013/Pantum%20Ubuntu%20Driver%20V1_1_123.zip' \
    && unzip driver.zip \
    && cd Pantum* \
    && dpkg -i Resources/pantum_1.1.123-1_amd64.deb \
    && cd .. \
    && rm -rf /tmp/*

# Add print user
RUN adduser --home /home/admin --shell /bin/bash --gecos "admin" --disabled-password admin \
  && adduser admin sudo \
  && adduser admin lp \
  && adduser admin lpadmin

# Disable sudo password checking
RUN echo 'admin ALL=(ALL:ALL) ALL' >> /etc/sudoers

# Enable access to CUPS
RUN /usr/sbin/cupsd \
  && while [ ! -f /var/run/cups/cupsd.pid ]; do sleep 1; done \
  && cupsctl --remote-admin --remote-any --share-printers \
  && kill $(cat /var/run/cups/cupsd.pid) \
  && echo "ServerAlias *" >> /etc/cups/cupsd.conf

# Copy /etc/cups for skeleton usage
RUN cp -rp /etc/cups /etc/cups-skel

ADD docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD ["cupsd", "-f"]
VOLUME ["/etc/cups"]
EXPOSE 631
