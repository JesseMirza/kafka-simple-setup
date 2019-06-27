#!/bin/sh

# This script is used by create-with-docker.ps1 or create-with-docker.sh.
# This script is copied into a java container and executed there.
# Output (certificates) are copied to host machine. 

mkdir -p /certificates

echo "Generate CA Root"
openssl req -new -x509 -keyout ca-key -out ca-cert -days 1825 -subj "/C=NL/ST=NH/L=Amsterdam/O=KafkaTeam/CN=kafkaca" -passout pass:test1234

echo "Generate Keystore Files"
keytool -genkey -noprompt -keystore server1.keystore.jks -alias kafka1 -validity 1825 -keyalg RSA -dname "CN=kafka1, OU=KafkaTeam, O=KafkaNet, L=Amsterdam, S=NH, C=NL" -storepass test1234 -keypass test1234
keytool -genkey -noprompt -keystore server2.keystore.jks -alias kafka2 -validity 1825 -keyalg RSA -dname "CN=kafka2, OU=KafkaTeam, O=KafkaNet, L=Amsterdam, S=NH, C=NL" -storepass test1234 -keypass test1234
keytool -genkey -noprompt -keystore client.keystore.jks -alias client -validity 1825 -keyalg RSA -dname "CN=client, OU=KafkaTeam, O=KafkaNet, L=Amsterdam, S=NH, C=NL" -storepass test1234 -keypass test1234
keytool -genkey -noprompt -keystore admin.keystore.jks -alias admin -validity 1825 -keyalg RSA -dname "CN=admin, OU=KafkaTeam, O=KafkaNet, L=Amsterdam, S=NH, C=NL" -storepass test1234 -keypass test1234


echo "Generate Truststore Files which imports CARoot as well (so they trust anyone who has cert signed by this CA)"
keytool -noprompt -keystore server1.truststore.jks -alias CARoot -import -file ca-cert -storepass test1234
keytool -noprompt -keystore server2.truststore.jks -alias CARoot -import -file ca-cert -storepass test1234
keytool -noprompt -keystore client.truststore.jks -alias CARoot -import -file ca-cert -storepass test1234
keytool -noprompt -keystore admin.truststore.jks -alias CARoot -import -file ca-cert -storepass test1234

echo "Create Cert Req"
keytool -keystore server1.keystore.jks -alias kafka1 -certreq -file cert-file-server-1 -keypass test1234 -storepass test1234
keytool -keystore server2.keystore.jks -alias kafka2 -certreq -file cert-file-server-2 -keypass test1234 -storepass test1234
keytool -keystore client.keystore.jks -alias client -certreq -file cert-file-client -keypass test1234 -storepass test1234
keytool -keystore admin.keystore.jks -alias admin -certreq -file cert-file-admin -keypass test1234 -storepass test1234

echo "Sign Cert Req with CA Root"
openssl x509 -req -CA ca-cert -CAkey ca-key -in cert-file-server-1 -out cert-signed-server-1 -days 1825 -CAcreateserial -passin pass:test1234
openssl x509 -req -CA ca-cert -CAkey ca-key -in cert-file-server-2 -out cert-signed-server-2 -days 1825 -CAcreateserial -passin pass:test1234
openssl x509 -req -CA ca-cert -CAkey ca-key -in cert-file-client -out cert-signed-client -days 1825 -CAcreateserial -passin pass:test1234
openssl x509 -req -CA ca-cert -CAkey ca-key -in cert-file-admin -out cert-signed-admin -days 1825 -CAcreateserial -passin pass:test1234


echo "Add CARoot and Signed Request to Server1 keystore"
keytool -keystore server1.keystore.jks -alias CARoot -import -file ca-cert -storepass test1234 -noprompt
keytool -keystore server1.keystore.jks -alias kafka1 -import -file cert-signed-server-1 -storepass test1234 -noprompt

echo "Add CARoot and Signed Request to Server2 keystore"
keytool -keystore server2.keystore.jks -alias CARoot -import -file ca-cert -storepass test1234 -noprompt
keytool -keystore server2.keystore.jks -alias kafka2 -import -file cert-signed-server-2 -storepass test1234 -noprompt

echo "Add CARoot and Signed Request to Client keystore"
keytool -keystore client.keystore.jks -alias CARoot -import -file ca-cert -storepass test1234 -noprompt
keytool -keystore client.keystore.jks -alias client -import -file cert-signed-client -storepass test1234 -noprompt

echo "Add CARoot and Signed Request to Admin keystore"
keytool -keystore admin.keystore.jks -alias CARoot -import -file ca-cert -storepass test1234 -noprompt
keytool -keystore admin.keystore.jks -alias admin -import -file cert-signed-admin -storepass test1234 -noprompt


rm -f /certificates/*.jks
cp ./*.jks /certificates/
