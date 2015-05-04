				# -*- mode:octave; -*-
# see http://pivius.blogspot.it/2015/05/string-around-rod.html
L=12;                    # rod length
c=4;                     # rod circumference
r=c/(2*pi);              # rod radius
b=2*r;                   # minor axis
a=sqrt((L/8)**2 + b**2); # major axis
k=sqrt(1 - (b/a)**2);    # eccentricity
[t, Ek]=ellipke(k);      # E(k)
p=2*a*Ek;                # circum. of ellipse
sl=8*p/2;                # 8 half ellipses
expres=20;               # expected result
printf("length: %f\n", sl);
printf("err/7: %f\n", (expres-sl)/7);
