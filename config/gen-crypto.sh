# FIRST TIME MUST call with 'all' as argument
# If 'all' not passed then crypto not regenrated

rm -rf temp
rm  -rf ./artefacts/*

#1 Check if all was passed
if [ ! -z $1 ]; then
    if [ $1 == "all" ]; then
        #1. Generate the crypto
        echo "====> Generating the crypto-config"
        rm -rf crypto-config
        cryptogen generate --config=./crypto-config.yaml
    fi
else
    echo 'Use ./gen-crypto.sh   all      to regenerate the crypto'
fi

echo    "====> Generating : Organization MSPs : orgs-msp.tar"
#2 Generate the orgs-msp.tar
rm -rf temp/orgs-msp
mkdir -p ./temp/orgs-msp/orderer
cp -R crypto-config/ordererOrganizations/healthcare.tech/msp    temp/orgs-msp/orderer/msp
mkdir -p temp/orgs-msp/thuduchospital
cp -R crypto-config/peerOrganizations/thuduchospital.healthcare.tech/msp    temp/orgs-msp/thuduchospital/msp
mkdir -p temp/orgs-msp/govaphospital
cp -R crypto-config/peerOrganizations/govaphospital.healthcare.tech/msp    temp/orgs-msp/govaphospital/msp
# Create the orgs-msp tar file
cd temp
tar -c orgs-msp -f ../artefacts/orgs-msp.tar
cd ../

#3 Generate the orderer-msp.tar
echo   "====> Generating : Orderer MSP : orderer-msp.tar"
mkdir -p temp/orderer-msp
cp -R crypto-config/ordererOrganizations/healthcare.tech/orderers/orderer.healthcare.tech/msp  temp/orderer-msp
cd temp
tar -c orderer-msp -f ../artefacts/orderer-msp.tar
cd ../

#4 Generate the thuduchospital-msp.tar
echo   "====> Generating : thuduchospital MSP : thuduchospital-msp.tar"
mkdir -p temp/msps
cp -R crypto-config/peerOrganizations/thuduchospital.healthcare.tech/peers/peer1.thuduchospital.healthcare.tech/msp              temp/msps/peer
cp -R crypto-config/peerOrganizations/thuduchospital.healthcare.tech/users/Admin@thuduchospital.healthcare.tech/msp              temp/msps/admin
cp -R crypto-config/peerOrganizations/thuduchospital.healthcare.tech/users/User1@thuduchospital.healthcare.tech/msp              temp/msps/user1
cd temp
tar -c msps -f ../artefacts/thuduchospital-msp.tar
cd ../
rm -rf temp/msps/**

#5 Generate the govaphospital-msp.tar
echo   "====> Generating : govaphospital MSP : govaphospital-msp.tar"
mkdir -p temp/msps
cp -R crypto-config/peerOrganizations/govaphospital.healthcare.tech/peers/peer1.govaphospital.healthcare.tech/msp              temp/msps/peer
cp -R crypto-config/peerOrganizations/govaphospital.healthcare.tech/users/Admin@govaphospital.healthcare.tech/msp              temp/msps/admin
cp -R crypto-config/peerOrganizations/govaphospital.healthcare.tech/users/User1@govaphospital.healthcare.tech/msp              temp/msps/user1
cd temp
tar -c msps -f ../artefacts/govaphospital-msp.tar
cd ../
rm -rf temp/msps/*

