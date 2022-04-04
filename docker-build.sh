
# Shell script to build and deploy our skill to a container registry.

if [ ! -f "env.sh" ]; then
  echo "No env.sh file found. Please create one. See README.md for details."
  exit
fi

# Bring in registry information and skill name and tag.
source ./env.sh

if [ -z "$registry" ]
  then
    echo "You're missing the container registry URL. We cannot proceed without that."
    exit
fi

if [ -z "$registry_username" ]
  then
    echo "Missing container registry username."
    exit
fi

if [ -z "$registry_password" ]
  then
    echo "Missing container registry password."
    exit
fi

if [ -z "$skill_name" ]
  then
    echo "Missing skill name."
    exit
fi

if [ -z "$skill_tag" ]
  then
    echo "Missing skill tag."
    exit
fi


# Log in to the registry, build the image, and push it to the repository.
docker login -u $registry_username -p $registry_password $registry

# Kick off buildx and push the results to the container registry.
# For multi-stage docker build: -f MultiStageDockerfile

docker buildx build --platform linux/arm64 -t $registry/$skill_name:$skill_tag --push .


