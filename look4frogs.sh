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

# frog perception parameters
maxHue=0.4  # based on a real frog
#maxHue=0.6  # training with teapots for when there are no frogs
minHue=0.2  # based on a real frog
minSat=0.2  # minimum saturation
minLight=0.15
maxLight=0.95
threshold=1 # minimum percentage of frog pixels
thisDir="/home/st33v/shed/dev/frogcam/litoria"


function gotodaydir {
	yr=$(date +%Y)     # 4-digit year
	mo=$(date +%m)
	day=$(date +%d)
	if [ ! -d ${yr}/${mo}/${day} ]; then
		mkdir -p ${yr}/${mo}/${day}
	fi
	cd ${yr}/${mo}/${day}
	# echo $PWD
}

function createFrogLayer {
  convert pix/canhazfrogs.jpg -fx \
  "hue>${minHue} && hue<${maxHue} && \
  saturation>${minSat} && \
  lightness>${minLight} && lightness<${maxLight} ?1:0"\
  -morphology Erode:2 Octagon pix/greenscreen.png
}

# Is litoriaCam awake?
function hazcam {
  ping litoriacam  -c 1 1>/dev/null
  if [[ $? -eq 0 ]] ; then
      # echo "Cam is alive"
      return 0
  else
      # echo "No response from litoriacam"
      return 1
  fi
}

# take a photo and look for frogs
function findafrog {
  curl litoriacam/image.jpg -o pix/canhazfrogs.jpg
  createFrogLayer
  # count the black (non-frog) and white (froggy) pixels
  pixelHisto=$(convert pix/greenscreen.png -format %c histogram:info:-)
  blackPixels=$(grep 000000 <<<$pixelHisto | awk '{print $1}' | sed 's/[^0-9]//g')
  frogPixels=$(grep FFFFFF <<<$pixelHisto | awk '{print $1}' | sed 's/[^0-9]//g')
  echo X$frogPixelsX$blackPixelsX
  totalPixels=$((frogPixels+blackPixels))
  echo ${totalPixels}
  percent=$(awk "BEGIN { pc=100*${frogPixels}/${totalPixels}; \
          i=int(pc); print (pc-i<0.5)?i:i+1 }")
  echo ${pixelHisto}
  echo frog ${frogPixels} non-frog ${blackPixels} ratio  ${percent}
  if [[ $percent -gt $threshold ]] ; then
    return 0
  else
    return 1  # no frogs today
  fi
}

cd $thisDir		#need to be explicit when the script is run in /usr/local/bin
hazcam
findafrog
if [[ $? -eq 0 ]] ; then
  #here=$PWD
  # gotodaydir  # cd to a directory
  cp pix/canhazfrogs.jpg frogs/$(date +%Y-%m-%d_%H%M%S).jpg
fi
