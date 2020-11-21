#!/bin/bash
# Script for the generation of the 
# genesis block & create channel tx files
# Both files written under the artefacts subfolder

#1 Make sure the orgs-msp.tar is available
mkdir -p ./temp
tar -xvf $PWD/artefacts/orgs-msp.tar -C temp 

#2 Generate the Genesis block
export FABRIC_CFG_PATH=$PWD
GENESIS_FILE=./artefacts/healthcare-genesis.block
CHANNEL_NAME=ordererchannel
echo "====> Generating Genesis"
configtxgen -profile HealthcareOrdererGenesis -channelID $CHANNEL_NAME -outputBlock $GENESIS_FILE

#3 Generate the airline channel transaction file
CHANNEL_TX_FILE=./artefacts/healthcare-channel.tx
CHANNEL_NAME=healthcare-channel
echo "====> Generating Channel Tx"
configtxgen -profile HealthcareChannel -outputCreateChannelTx $CHANNEL_TX_FILE -channelID $CHANNEL_NAME

rm -rf ./temp/*
