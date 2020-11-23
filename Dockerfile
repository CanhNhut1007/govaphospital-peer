#Docker file for setting up the acme peer
# FROM hyperledger/fabric-peer:1.4.2
FROM hyperledger/fabric-peer:2.2.1

LABEL  maintainer="Thach Canh Nhut"

#COPY ./config-org/ThuDuc/peers/peer1/tls /etc/hyperledger/fabric/tls

#1. Create a folder
RUN rm -r /etc/hyperledger/fabric

ENV CORE_PEER_MSPCONFIGPATH=/var/hyperledger/GoVapHospital/msp

ENV FABRIC_CFG_PATH=/var/hyperledger/GoVapHospital

#2. Copy the crypto for peer crypto
COPY ./config-org/GoVapHospital/peers/peer2 /var/hyperledger/GoVapHospital

#3. Copy the crypto for admin crypto
COPY ./config-org/GoVapHospital/users /var/hyperledger/users

#4. Copy the anchor peer update tx
#COPY ./config/acme-peer-update.tx /var/hyperledger/config/acme-peer-update.tx

#5. Copy the channel create tx file
#COPY ./config/healthcare-channel.tx  /var/hyperledger/config/healthcare-channel.tx

#6. Copy the core YAML
COPY ./config-org/GoVapHospital/peers/peer2/core.yaml /var/hyperledger/GoVapHospital

RUN mkdir /var/hyperledger/bins

#7. Copy the bins
COPY ./config-org/GoVapHospital/set-context.sh /var/hyperledger/bins

#8. Copy the test chaincode
COPY ./nodechaincode  /var/hyperledger/nodechaincode

#9. Set the working dir
# RUN  echo "cd /var/hyperledger/bins" >> $HOME/.profile
# RUN  echo "cd /var/hyperledger/bins" >> $HOME/.bashrc
ENV  ENV="/etc/profile"
RUN  echo "cd /var/hyperledger/bins" >> /etc/profile

#10. Set the context for Admin user
# RUN echo ". /var/hyperledger/bins/set-context.sh" >> $HOME/.bashrc
RUN echo ". /var/hyperledger/bins/set-context.sh " >> /etc/profile

#11. Install the jq package - used in scripts
RUN apk update \
&& apk add jq \
&& rm -rf /var/cache/apk/*

#12. Create the package folder
#RUN mkdir -p /var/hyperledger/packages

#13. Copy the gocc package tar file to the image
#COPY ./packages/gocc.1.0-1.0.tar.gz /var/hyperledger/packages/gocc.1.0-1.0.tar.gz

#14. COPY fabric-ca-client
#COPY ./bin/fabric-ca-client /usr/local/bin

#15. Launch the peer
CMD peer node start

