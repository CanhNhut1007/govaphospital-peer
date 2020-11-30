#Docker file for setting up the acme peer
# FROM hyperledger/fabric-peer:1.4.2
FROM hyperledger/fabric-peer:2.2.1

LABEL  maintainer="Thach Canh Nhut"

#1. Create a folder
RUN rm -r /etc/hyperledger/fabric

ENV FABRIC_LOGGING_SPEC=INFO

ENV ORG_CONTEXT="GoVapHospital"
ENV ORG_NAME="GoVapHospital"
#2. Copy the crypto for peer crypto
COPY ./config-org/GoVapHospital/peers/peer2 /var/hyperledger/GoVapHospital

ENV FABRIC_CFG_PATH=/var/hyperledger/GoVapHospital

#3. Copy the crypto for admin crypto
COPY ./config-org/GoVapHospital/users /var/hyperledger/users

ENV CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@GoVapHospital/msp

#4. Copy the channel create tx file
COPY channel.tx  /var/hyperledger/GoVapHospital/channel.tx

#5. Copy the core YAML
COPY ./config-org/GoVapHospital/peers/peer2/core.yaml /var/hyperledger/GoVapHospital

#6. Copy the test chaincode
COPY ./nodechaincode  /var/hyperledger/nodechaincode

#7. Install the jq package - used in scripts
RUN apk update \
&& apk add jq \
&& rm -rf /var/cache/apk/*

#8. Launch the peer
CMD peer node start

#12. Create the package folder
#RUN mkdir -p /var/hyperledger/packages

#13. Copy the gocc package tar file to the image
#COPY ./packages/gocc.1.0-1.0.tar.gz /var/hyperledger/packages/gocc.1.0-1.0.tar.gz

#14. COPY fabric-ca-client
#COPY ./bin/fabric-ca-client /usr/local/bin

