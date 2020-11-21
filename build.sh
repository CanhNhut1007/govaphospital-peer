project=""				# project-name
tag=""			 		# docker image tag (branch)
Dockerfile="Dockerfile" # Dockerfile

if [ ! -z "$2" ]; then
	project="$1"
	if [ $2 == "master" ]; then
	tag="latest"
	elif [ $2 == "pro" ] || [ $2 == "prod" ]  || [ $2 == "release" ]; then
			tag="stable"
	else
		tag=$2
	fi
else
	echo "Can not build empty tag for project $2"
	exit 1
fi
# Check parameter Dockerfile
if [ ! -z "$3" ]; then
	Dockerfile="$3"
fi

# Check local & remote Dockerfile (Dockerfile in repo first)
if [ -f "Dockerfile" ]; then
        echo "$(date +'%d-%m-%Y %H:%M:%S') [$HOSTNAME] Build $dockerImageName:$tag from: $targetLocation/$dockerImageName/Dockerfile"
        DOCKER_BUILDKIT=1 docker build -f $Dockerfile -t $project:$tag . 
else
	echo "$Dockerfile not found!"
	exit 1
fi
retVal=$?
if [ $retVal -gt 0 ]; then
    echo "Build failed - exit code: $retVal"
    exit 1
fi
docker login -u nhutori4 -p Nnnq@1998
docker tag $project:$tag nhutori4/$project:$tag
docker push nhutori4/$project:$tag
