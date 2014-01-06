Red/System [
	Title:		"OpenCV Tests: Drawing"
	Author:		"François Jouen"
	Rights:		"Copyright (c) 2012-2013 François Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

#include %../opencv.reds



#define NUMBER 100
#define DELAY 5

wndname: "OpenCV drawing and text output functions"
lineType: CV_AA; // change it to 8 to see non-antialiased graphics
i: 1 
width: 1000 
height: 700

width3: width * 3
height3: height * 3;
thickness: 0
; random generator
rng: cvRNG -1

random_color: func [ rng [float!] return: [CvScalar!] /local  icolor val c ][
    icolor: cvRandFloat % rng 
    c: declare CvScalar!
    c/v0: icolor - 128.0  
    icolor: cvRandFloat % rng 
    c/v1: icolor - 128.0 
    icolor: cvRandFloat % rng 
    c/v2: icolor - 128.0 
    c/v3: 0.0
    c 
]


_random_color: func [ rng [float!] return: [CvScalar!] /local  icolor c r g b ][
 icolor: cvRandFloat % rng 
 r: icolor
 icolor: cvRandFloat % rng 
 g: icolor
 icolor: cvRandFloat % rng 
 b: icolor
 icolor: cvRandFloat % rng 
 a: 0.0
 tocvRGB r g b a
 ;CV_RGB (r g b)
]




image: cvCreateImage width height IPL_DEPTH_32F 3
&image: as byte-ptr! image ; pointer address
&&image: declare double-byte-ptr!
&&image/ptr: &image
cvNamedWindow wndname CV_WINDOW_AUTOSIZE

cvZero &image
cvShowImage wndname &image

pt1: declare CvPoint!
pt2: declare CvPoint!

sz: declare CvSize!
color: declare CvScalar!
angle: 0.0
radius: 0
font: declare CvFont!


cvInitFont font CV_FONT_HERSHEY_SIMPLEX 1.0 1.0 0.0 1 CV_AA
_font: 0
vs: 0.0
hs: 0.0

text_size: declare CvSize!
ymin: 0

&ymin: as int-ptr! ymin
cvGetTextSize "Any key to start" font text_size &ymin


pt1/x: (width - text_size/width) / 2
pt1/y: (height + text_size/height) / 2

;rng: 1



print ["Focus the window and hit any key to start " lf]
cvPutText &image "Any key to start" pt1/x pt1/y font 0.0 56.0 -56.0 0.0
cvShowImage wndname &image
cvwaitKey 0
h: as time-reference! 0
t1: 0
t2: 0

t1: now-time h

cvZero &image
print ["Drawing Lines" lf]
; draw lines
until [
    pt1/x: cvRandInt  % width3 - width
    pt1/y: cvRandInt  % height3 - height
    pt2/x: CvRandInt  % width3 - width
    pt2/y: cvRandInt  % height3 - height
    color: random_color 255.0
    thickness: cvRandInt % 10
    cvLine &image pt1/x pt1/y pt2/x pt2/y color/v0 color/v1 color/v2 color/v3 thickness lineType 0
    cvShowImage wndname &image
    cvwaitKey delay
    i: i + 1
    i = (number + 1)
]


print ["Drawing Rectangles" lf]
cvZero &image

; draw rectangles
i: 1
until [
    pt1/x: cvRandInt  % width3 - width
    pt1/y: cvRandInt  % height3 - height
    pt2/x: CvRandInt  % width3 - width
    pt2/y: cvRandInt  % height3 - height
    color: random_color 255.0
    thickness: cvRandInt % 10 - 1 ; - 1 for filled form
    cvRectangle &image pt1/x pt1/y pt2/x pt2/y color/v0 color/v1 color/v2 color/v3 thickness lineType 0
    cvShowImage wndname &image
    cvwaitKey delay
    i: i + 1
    i = (number + 1)
]
cvwaitKey delay

print ["Drawing Elipses" lf]
cvZero &image
; draw elipses
i: 1
until [
    pt1/x: cvRandInt  % width3 - width
    pt1/y: cvRandInt  % height3 - height
    sz/width: cvRandInt % 200
    sz/height: cvRandInt % 200
    angle: (cvRandFloat % 1000) * 0.180
    color: random_color 255.0
    thickness: cvRandInt % 10 - 1
    cvEllipse &image pt1/x pt1/y sz/width sz/height angle angle + 100.0 angle + 200.0
              color/v0 color/v1 color/v2 color/v3 thickness lineType 0
    cvShowImage wndname &image
    cvwaitKey delay
    i: i + 1
    i = (number + 1)
]



print ["Drawing Polygons" lf]
cvZero &image
; draw polygons

i: 1

; Array of polyline vertex counters [3][3]
mem1: allocate 2 * size? integer!
&arr: as pointer! [integer!] mem1
&arr/1: 3
&arr/2: 3

;Array of pointers to polylines
mem2: allocate 12 * size? integer!

&points: as [int-ptr!] mem2 ; a pointer to CvPoints array
&&points: declare double-int-ptr!; double pointer to CvPoints array
&&points/ptr: &points ; point to the array
copy1: &points
    copy2: &&points
until [
    ; first we have to create the array of integers;
    &points/1: cvRandInt  % width3 - width
    &points/2: cvRandInt  % height3 - height
    &points/3: cvRandInt  % width3 - width
    &points/4: cvRandInt  % height3 - height
    &points/5: cvRandInt  % width3 - width
    &points/6: cvRandInt  % height3 - height
    &points/7: cvRandInt  % width3 - width
    &points/8: cvRandInt  % height3 - height
    &points/9: cvRandInt  % width3 - width
    &points/10: cvRandInt  % height3 - height
    &points/11: cvRandInt  % width3 - width
    &points/12: cvRandInt  % height3 - height
    
    ;seems necessary to update double pointers 
    copy1: &points
    copy2: &&points
    
    color: random_color 255.0
    thickness: cvRandInt % 10
    cvPolyLine &image &&points &arr 2 1 color/v0 color/v1 color/v2 color/v3 thickness lineType 0
    cvShowImage wndname &image
    cvwaitKey delay
    i: i + 1
    
    i = (number + 1)
]


print ["Fill Polygons" lf]
cvZero &image


i: 1

until [
    ; first we have to create the array of integers;
    &points/1: cvRandInt  % width3 - width
    &points/2: cvRandInt  % height3 - height
    &points/3: cvRandInt  % width3 - width
    &points/4: cvRandInt  % height3 - height
    &points/5: cvRandInt  % width3 - width
    &points/6: cvRandInt  % height3 - height
    &points/7: cvRandInt  % width3 - width
    &points/8: cvRandInt  % height3 - height
    &points/9: cvRandInt  % width3 - width
    &points/10: cvRandInt  % height3 - height
    &points/11: cvRandInt  % width3 - width
    &points/12: cvRandInt  % height3 - height
    
   
   
    color: random_color 255.0
    ;print [i ": " &points  " "  &&points " "  lf]
    ;cvFillPoly &image &&points &arr 2 color/v0 color/v1 color/v2 color/v3 lineType 0 ; ok but very slow 
    cvFillConvexPoly &image &points 6 color/v0 color/v1 color/v2 color/v3 lineType 0
    cvShowImage wndname &image
    cvwaitKey delay
    i: i + 1
    i = (number + 1)
]



print ["Drawing Circles" lf]
cvZero &image
; draw circles
i: 1
until [
    pt1/x: cvRandInt  % width3 - width
    pt1/y: cvRandInt  % height3 - height
    color: random_color 255.0
    thickness: cvRandInt % 10 - 1 ; -1 for filled form
    radius: cvRandInt % 200
    cvCircle &image pt1/x pt1/y radius color/v0 color/v1 color/v2 color/v3 thickness lineType 0
    cvShowImage wndname &image
    cvwaitKey delay
    i: i + 1
i = (number + 1)
]


print ["Testing Fonts" lf]
cvZero &image

i: 1
until [
    pt1/x: cvRandInt  % width3 - width
    pt1/y: cvRandInt  % height3 - height
    color: random_color 255.0
    thickness: cvRandInt % 3
    _font: cvRandInt % 7  ; 0 to 7 see basic font types in cxcore.reds
    vs: cvrandFloat % 5.0 + 1.0
    hs: cvrandFloat % 3.0 + 1.0
    cvInitFont font _font hs vs 0.0 thickness CV_AA
    
    cvPutText &image "Testing text rendering" pt1/x pt1/y font color/v0 color/v1 color/v2 color/v3 
    cvShowImage wndname &image
    cvwaitKey delay
    i: i + 1
    i = (number + 1)
]



cvInitFont  font CV_FONT_HERSHEY_COMPLEX 3.0 3.0 0.0 5 lineType
cvGetTextSize "OpenCV forever!" font text_size &ymin

pt1/x: (width - text_size/width) / 2
pt1/y: (height + text_size/height) / 2
image2: cvCloneImage image 
&image2: as byte-ptr! image2
&&image2: declare double-byte-ptr!
&&image2/ptr: &image2

print ["Testing Images substraction " lf]
ii: 1.0
until [
    cvSubS &image2 cvScalarAll ii &image null ; OK
    ;cvNot &image &image2 ; OK aussi
    ;color: CV_RGB (255.00 ii ii)
    color: random_color 255.0
    cvPutText &image "OpenCV forever!" pt1/x pt1/y font color/v0 color/v1 color/v2 color/v3
    cvShowImage wndname &image
    cvWaitKey DELAY
    ii: ii + 1.0    
    ii = 255.00    
]

cvZero &image
cvShowImage wndname &image

cvPutText &image "Any key to close" pt1/x pt1/y font 255.00 0.0 0.0 0.0
t2: now-time h
print ["All tests done in " subtract-time t2 t1 " sec" lf]
print ["Any key to close" lf]
cvShowImage wndname &image
cvwaitKey 0

free mem1
free mem2
cvDestroyWindow wndname
cvReleaseImage &&image
cvReleaseImage &&image2
