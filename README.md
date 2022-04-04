# Optra YOLOv5 PyTorch Sample Skill

This sample skill is derived from YOLOv5's inferencing example, [detect.py](https://github.com/ultralytics/yolov5/blob/master/detect.py). Functionally, it tracks objects detected (person, car, etc.) by the YOLOv5 model and reports that via an IoT message to the Optra portal at a defined interval.  The skill's behavior is configurable with `includeObjectsFilter` to track only specified objects and `summaryFrequencyMinutes` to affect the reporting interval.

It also demonstrates the following key points of using YOLOv5 on the Optra Vision hardware.

- The base docker image 'l4t-pytorch' includes a prebuilt PyTorch package compatible with the Optra Vision hardware.
- Use of docker buildx to build the skill for the ARM hardware in non-ARM environments.
- Use of the Python Azure Device SDK Module Client to do the following:
  - Obtain the camera URL from the device sensors configured via the Optra portal.
  - Obtain the skill inputs from the module twin to change behavior of the skill.
  - Observe twin changes to see skill inputs modified via the Optra portal.
  - Send messages to the IoT hub.
  
# Prerequisites

## Docker

**Windows** and **Mac**: We've tested this project with [Docker Desktop](https://www.docker.com/products/docker-desktop).

**Linux**: Follow the instructions [here](https://docs.docker.com/engine/install/ubuntu/).

Once you have docker installed, you can verify your installation by running docker <em>hello world</em>.

```> docker run hello-world```

<hr>

## Docker buildx

To build multi-architecture docker images (for example, those that can be run on ARM-based devices), you'll need docker buildx. Docker buildx is a CLI plugin that extends the docker command line to include the buildx option. The latest versions of Docker include buildx as standard.  It was previously introduced in Docker version 19.03 as an experimental feature.  Instructions for enabling are [here](https://github.com/docker/cli/tree/master/experimental).

You can verify you have buildx support by running this command:

```> docker buildx ```

Linux users will need to run the following each time they reboot (for an explanation of why read [this](https://www.docker.com/blog/multi-platform-docker-builds/)):

- ```> docker run --rm --privileged docker/binfmt:a7996909642ee92942dcd6cff44b9b95f08dad64```
---

## Build and run
<hr>

Create an ```env.sh``` (Mac/Linux) or ```env.bat``` (Windows) in the project directory. The contents of this file will set environment variables necessary for the build. Here is an example:

```
#!/bin/bash

# In order to push your skill to your container registry,
# you'll need to define the following variables.

export registry=mycontainerregistry.example.io
export registry_username=myregistryusername
export registry_password=myregistrypassword

# Here you can name your skill and provide it with a tag.
export skill_name=yolov5-sample-skill
export skill_tag=0.0.1
```

After you've verified your environment variables, you can run the build by running:

```>./docker-build.sh``` (Mac or Linux)

```> docker-build.bat``` (Windows)
