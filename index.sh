#!/bin/bash

mkdir -p frames

# Set parameters
width=500
height=100
frames_per_slide=40   # Smoother animation = higher number
delay=8               # Frame delay (higher = slower)
gap=40                # White gap between logos (px)

logos=("eco.png" "boston.png" "vforce.png" "enatel.png")

# Clean old frames
rm -f frames/*.png

# Loop through each logo transition
for ((i=0; i<${#logos[@]}; i++)); do
    current=${logos[$i]}
    next=${logos[$(( (i+1) % ${#logos[@]} ))]}

    # Get current logo height
    current_h=$(identify -format "%h" "$current")
    next_h=$(identify -format "%h" "$next")

    # Calculate vertical offsets to center logos
    current_y=$(( (height - current_h) / 2 ))
    next_y=$(( (height - next_h) / 2 ))

    for ((f=0; f<=frames_per_slide; f++)); do
        # Calculate horizontal offset with padding
        offset=$(( (width + gap) * f / frames_per_slide ))

        # Create the frame with white background
        magick -size ${width}x${height} xc:white \
            \( "$current" -geometry +$(( -offset ))+${current_y} \) -composite \
            \( "$next" -geometry +$(( width + gap - offset ))+${next_y} \) -composite \
            frames/frame_$(printf "%03d" $((i*frames_per_slide+f))).png
    done
done

# Generate final animated PNG
magick frames/frame_*.png -delay $delay -loop 0 banner.apng

