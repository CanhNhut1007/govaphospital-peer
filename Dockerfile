#Docker file for setting up the acme peer
# FROM hyperledger/fabric-peer:1.4.2
FROM golang:alpine3.12 as builder

FROM hyperledger/fabric-peer:2.2.1

LABEL  maintainer="Thach Canh Nhut"

#1. Create a folder
RUN rm -r /etc/hyperledger/fabric

ENV FABRIC_LOGGING_SPEC=INFO

ENV ORG_CONTEXT="GoVapHospital"
ENV ORG_NAME="GoVapHospitalMSP"
#2. Copy the crypto for peer crypto
COPY ./config-org/GoVapHospital/peers/peer1 /var/hyperledger/GoVapHospital

ENV FABRIC_CFG_PATH=/var/hyperledger/GoVapHospital

ENV CORE_PEER_ADDRESS="peer1-govaphospital:30851"

ENV CORE_PEER_GOSSIP_USELEADERELECTION=true

ENV CORE_PEER_GOSSIP_ORGLEADER=false

#ENV CORE_PEER_GOSSIP_BOOTSTRAP="peer2-govaphospital:31851"

ENV CORE_PEER_ENDORSER_ENABLED=true

ENV CORE_PEER_GOSSIP_EXTERNALENDPOINT="peer1-govaphospital:30851"

ENV CORE_PEER_GOSSIP_ENDPOINT="peer1-govaphospital:30851"

#3. Copy the crypto for admin crypto
COPY ./config-org/GoVapHospital/users /var/hyperledger/users

ENV CORE_PEER_MSPCONFIGPATH=/var/hyperledger/GoVapHospital/msp

#4. Copy the channel create tx file
COPY hospitalchannel.tx  /var/hyperledger/GoVapHospital/hospitalchannel.tx

#5. Copy the core YAML
COPY ./config-org/GoVapHospital/peers/peer1/core.yaml /var/hyperledger/GoVapHospital

#6. Copy the test chaincode
#COPY ./nodechaincode  /var/hyperledger/nodechaincode

#7. Install the jq package - used in scripts
RUN apk update \
&& apk add jq \
&& rm -rf /var/cache/apk/*

#8. COPY Golang
RUN mkdir /usr/local/go
RUN mkdir /go

COPY --from=builder /usr/local/go /usr/local/go
COPY --from=builder /go /go
ENV PATH=/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV GOPATH=/go


#8. Launch the peer
CMD peer node start

#12. Create the package folder
#RUN mkdir -p /var/hyperledger/packages

#13. Copy the gocc package tar file to the image
#COPY ./packages/gocc.1.0-1.0.tar.gz /var/hyperledger/packages/gocc.1.0-1.0.tar.gz

#14. COPY fabric-ca-client
#COPY ./bin/fabric-ca-client /usr/local/bin
