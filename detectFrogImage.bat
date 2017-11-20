# Frog detector

convert .\pix\image19.jpg -fx "hue>0.25 && hue<0.45 && saturation>0.2 && lightness>0.1 && lightness<0.9 ?1:0" -morphology Erode Octagon .\pix\image19.png
