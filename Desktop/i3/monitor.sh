#!/bin/bash

if nvidia-settings --query CurrentMetaMode | grep -q 1280; then #Monitor activo

	nvidia-settings --assign CurrentMetaMode='DPY-0: 1920x1080_60 @1920x1080 +0+0 {ViewPortIn=1920x1080, ViewPortOut=1920x1080+0+0, ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}'

else

	nvidia-settings --assign CurrentMetaMode='DPY-0: nvidia-auto-select @1920x1080 +1280+0 {ViewPortIn=1920x1080, ViewPortOut=1920x1080+0+0, ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}, DPY-2: nvidia-auto-select @1280x1024 +0+1060 {ViewPortIn=1280x1024, ViewPortOut=1280x1024+0+0, ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}'

fi

nitrogen --restore
