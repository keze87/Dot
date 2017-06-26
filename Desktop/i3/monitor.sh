#!/bin/bash

if nvidia-settings --query CurrentMetaMode | grep -q 1280; then #Monitor activo

	i3-msg focus output DVI-I-0

	nvidia-settings --assign CurrentMetaMode='DPY-0: 1920x1080_60 @1920x1080 +0+0 {ViewPortIn=1920x1080, ViewPortOut=1920x1080+0+0, ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}'

else

	nvidia-settings --assign CurrentMetaMode='DPY-2: 1280x1024_60 @1280x1024 +0+28 {ViewPortIn=1280x1024, ViewPortOut=1280x1024+0+0, ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}, DPY-0: 1920x1080_60 @1920x1080 +1280+0 {ViewPortIn=1920x1080, ViewPortOut=1920x1080+0+0, ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}'

	i3-msg focus output HDMI-0

fi

i3-msg restart

if pgrep conky; then

	killall -SIGUSR1 conky

fi
