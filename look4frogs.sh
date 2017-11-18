#!/bin/bash
# look4frogs.sh
# SJP 18 November 2017
#
# STAN is the leader of the pack. He is raspi with a brain.
# litoriaCam is a humble wifi webcam who becomes activated when
# someone wants a picture of a green tree frog.
# litoriaCam's LAN IP address is in stan's /etc/hosts file
#
# In this script, stan asks whether litoria is awake and then
# starts grabbing photos.
# If a frog is found, STAN does 'something'. In this version, that's not much.
# In a later version it may be tweeted.
#
# This script is called by a timer service

# Is litoriCam awake?
ping litoriacam  -c 4 1>/dev/null
if [[ $? -eq 0 ]] ; then
    #echo "I can see you"
    curl litoriacam/image.jpg -o canhazfrogs.jpg
else
    echo "No response from litoriacam"
fi



