FROM nvcr.io/nvidia/l4t-pytorch:r32.5.0-pth1.7-py3

# Base image includes:
#
#    python 3.6
#    pip3 9.0.1
#
# Python packages included:
#
#    torch v1.7.0
#    torchvision v0.8.0

# yolov5 opencv-python package requires newer pip3 - upgrade it
RUN pip3 install --upgrade pip

RUN mkdir /work
WORKDIR /work
RUN git clone --single-branch -b v6.1 https://github.com/ultralytics/yolov5
WORKDIR /work/yolov5

# The base image already includes the torch and torchvision python
# packages.  Furthermore, torchvision MUST remain at 0.8.0 to be compatible
# with torch 1.7.0.  Comment out these packages in yolov5's requirements.txt.
RUN sed -e '/torchvision>=/ s/^#*/#/' -e '/torch>=/ s/^#*/#/' -i requirements.txt
RUN pip3 install -r requirements.txt

# This sample skill uses the Azure IoT Hub Device SDK to send data to the Optra portal.
RUN pip3 install azure-iot-device

# Copy a sample video from the deep stream samples image.  This will be used
# as our video source when no camera is setup in the Optra portal.
COPY --from=nvcr.io/nvidia/deepstream-l4t:6.0.1-samples /opt/nvidia/deepstream/deepstream-6.0/samples/streams/sample_720p.mp4 /work/yolov5/.

# Copy over custom detect application with helper utility.
COPY detect.py .
COPY edge_iot_util.py .

# This sample skill is capable of displaying video with detections.  To enable
# setup the DISPLAY variable and enable the HDMI privilege within the skill's
# definition in the Optra portal.
ENV DISPLAY=:0

CMD [ "python3", "-u",  "detect.py", "--source", "sample_720p.mp4", "--view-img" ]
