#!/bin/bash

mkdir -p frames

width=500
height=100
frames_per_slide=40   
delay=8               
gap=40                

logos=("eco.png" "boston.png" "vforce.png" "enatel.png")

rm -f frames/*.png

for ((i=0; i<${#logos[@]}; i++)); do
    current=${logos[$i]}
    next=${logos[$(( (i+1) % ${#logos[@]} ))]}

    current_h=$(identify -format "%h" "$current")
    next_h=$(identify -format "%h" "$next")

    current_y=$(( (height - current_h) / 2 ))
    next_y=$(( (height - next_h) / 2 ))

    for ((f=0; f<=frames_per_slide; f++)); do
        offset=$(( (width + gap) * f / frames_per_slide ))
        magick -size ${width}x${height} xc:white \
            \( "$current" -geometry +$(( -offset ))+${current_y} \) -composite \
            \( "$next" -geometry +$(( width + gap - offset ))+${next_y} \) -composite \
            frames/frame_$(printf "%03d" $((i*frames_per_slide+f))).png
    done
done

magick frames/frame_*.png -delay $delay -loop 0 banner.apng

