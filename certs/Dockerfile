FROM openjdk:8
COPY ./create-certs.sh /app/
WORKDIR /app
VOLUME /certificates
CMD ["./create-certs.sh"]
