convert fc.jpg -colorspace HSL -hue 125 -separate +channel \
-threshold 28% -negate \
-define connected-components:mean-color=true \
-define connected-components:area-threshold=255 \
-connected-components 1 \
-morphology open octagon:4 \
result1.png

