#!/bin/sh
#After running this script confirm that peer has joined
#by running peer channel list
peer channel join   -b ../config/healthcare-channel.block -o $ORDERER_ADDRESS

