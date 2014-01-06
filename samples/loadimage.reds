Red/System [
	Title:		"OpenCV Tests"
	Author:		"François Jouen"
	Rights:		"Copyright (c) 2012-2013 François Jouen. All rights reserved."
	License:     "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

#include %../opencv.reds

; function pointer that can be called by TrackBar callback 
trackEvent: func [[cdecl] pos [integer!]][cvGetTrackbarPos "Track" windowsName print ["Trackbar position is : " pos lf]]  


; this is pointer  to the function  called by mouse callback
mouseEvent: func [
	[cdecl]
            event 	[integer!]
            x	        [integer!]
            y	        [integer!]
            flags	[integer!]
            param	[pointer! [byte!]]
	] [
	print ["Mouse Position xy : " x " " y lf]
]

cvStartWindowThread  ; own's window thread 

*p: declare pointer! [integer!]  ; for trackbar position 
windowsName: "Lena: What a Wonderful World!"
print ["Loading a tiff image" lf]
lena: "/Users/fjouen/Desktop/newOpenCV/red/samples/images/lena.tiff"
lenaWin: cvNamedWindow windowsName CV_WINDOW_AUTOSIZE ; create window 

; for trackbar events 
cvCreateTrackbar "Track" windowsName *p 100 :trackEvent ; function as parameter
cvSetTrackBarPos "Track" windowsName 0
; for mouse events
cvSetMouseCallBack windowsName :mouseEvent none

;load image 
img: cvLoadImage lena CV_LOAD_IMAGE_COLOR
&img: as byte-ptr! img ; pointer address
&&img: declare double-byte-ptr!
&&img/ptr: as byte-ptr! img
print [img " " &img lf]
print [windowsName " is " img/width  "x" img/height lf]


cvShowImage windowsName &img ; show image
cvWaitKey 500 ;wait 500 ms
cvResizeWindow windowsName 256 256 ; resize window
print [windowsName " is now 256x256 " lf]
cvWaitKey 500
print [windowsName " is now 512x512" lf]
cvResizeWindow windowsName 512 512
cvWaitKey 500
print [windowsName " is moved to 300x50 "lf]
cvMoveWindow windowsName 300 50  ;move window
cvWaitKey 0
print ["Saving the image in jpg" lf]
cvSaveImage "/Users/fjouen/Desktop/newOpenCV/red/examples/images/lena.jpg" &img ; save tiff as jpg
print ["done! Bye "]


cvDestroyWindow windowsName
cvReleaseImage &&img ; release image pointer
