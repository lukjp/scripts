#!/bin/bash

# factor for one step
stepFactorPerCent=140

# minimum brightness, set to more than 0 to disable complete shutdown of the backlight
minBrightness=0


# get Settings
currentBrightness=$(qdbus local.org_kde_powerdevil /org/kde/Solid/PowerManagement/Actions/BrightnessControl org.kde.Solid.PowerManagement.Actions.BrightnessControl.brightness)
maxBrightness=$(qdbus local.org_kde_powerdevil /org/kde/Solid/PowerManagement/Actions/BrightnessControl org.kde.Solid.PowerManagement.Actions.BrightnessControl.brightnessMax)

#decrease
if [[ "$1" = - ]] ; then
    if [[ $currentBrightness -gt $minBrightness ]] ; then
        # the addition is to round since it only uses integer arithmetic
        newBrightness=$(( ( $currentBrightness * 100 + $stepFactorPerCent / 2 ) / $stepFactorPerCent ))
        if [[ $currentBrightness == $newBrightness ]] ; then
            # if it did not change we decrease it by one
            newBrightness=$(( $currentBrightness - 1 ))
        fi
        if [[ $newBrightness -lt $minBrightness ]] ; then
            # do not decrease the brightness below minBrightness
            newBrightness=$minBrightness
        fi
    else
        #if it was below min brightness we keep it
        newBrightness=$currentBrightness
    fi
fi

#increase (same as above, only inverted)
if [[ "$1" = + ]] ; then
    if [[ $currentBrightness -lt $maxBrightness ]] ; then
        newBrightness=$(( ( $currentBrightness * $stepFactorPerCent + 100 / 2 ) / 100 ))
        if [[ $currentBrightness == $newBrightness ]] ; then
            newBrightness=$(( $currentBrightness + 1 ))
        fi
        if [[ $newBrightness -gt $maxBrightness ]] ; then
            newBrightness=$maxBrightness
        fi
    else
        newBrightness=$maxBrightness
    fi
fi

#set new brightness
if [[ "$1" = + ]] || [[ "$1" = - ]] ; then
    qdbus local.org_kde_powerdevil /org/kde/Solid/PowerManagement/Actions/BrightnessControl org.kde.Solid.PowerManagement.Actions.BrightnessControl.setBrightness $newBrightness
    exit 0
fi
exit 1
