#!/bin/sh
peer channel create -c healthcare-channel -f ../config/healthcare-channel.tx --outputBlock ../config/healthcare-channel.block -o $ORDERER_ADDRESS
