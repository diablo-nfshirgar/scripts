FROM python:3.10

LABEL An image to build DNS over TLS proxy in the form of Docker container

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y openssl

ADD dns_over_tls.py /

EXPOSE 950 950/udp

CMD [ "python", "./dns_over_tls.py" ]
