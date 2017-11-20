# Frog detector
# 2 = frog
# 1 = !frog

convert .\pix\image00.jpg -scale 200x100 -fx "hue>0.25 && hue<0.45 && saturation>0.2 && lightness>0.1 && lightness<0.9 ?1:0" -morphology Erode Octagon -format %%k histogram:info:-
