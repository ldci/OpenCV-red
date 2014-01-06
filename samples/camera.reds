Red/System [
	Title:		"OpenCV Camera Test"
	Author:		"François Jouen"
	Rights:		"Copyright (c) 2012-2013 François Jouen. All rights reserved."
	License:     "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

#include %../opencv.reds
; use  default camera 
cvStartWindowThread ; separate window thread

capture: cvCreateCameraCapture CV_CAP_ANY ; create a cature using default webcam (iSight) ; change to n for other cam
print [capture lf]
if capture = null [print "error!" lf]

;set our movie properties
fps: 24.00
camW: 1280
camH: 1024
rec: false ; no automatic movie recording 

; creates a writer to record video
movie: "/Users/fjouen/Movies/camera.mov"
writer: cvCreateVideoWriter movie CV_FOURCC(#"D" #"I" #"V" #"X") fps camW camH 1 ; 1: CV_DEFAULT (1)
&writer: as byte-ptr! writer ; get the pointer address
if &writer = null [print "error"]


cvNamedWindow "Test Window" CV_WINDOW_AUTOSIZE ; create window to show movie
handle: cvGetWindowHandle "Test Window" ; not used  when using mac OSX without X 
image: cvRetrieveFrame capture ; get the first image 
&image: as byte-ptr! image ; pointer address
&&image: declare double-byte-ptr!
&&image/ptr: &image; double pointeur 

assert &image <> null ; test image status

key:  27
foo: 0

; repeat until q keypress
while [foo <> key] [
        image: cvRetrieveFrame capture      ; get the frame
       	cvShowImage "Test Window" &image    ; show frame
        if rec [cvWriteFrame writer image]  ; write frame on disk if we want to record movie (set rec to true for testing)
        foo: cvWaitKey 1
]


print ["Done. Any key to quit" lf]
cvWaitKey 0

; releases structures and windows
cvDestroyAllWindows
cvReleaseImage &&image 
;cvReleaseCapture capture ; a pb with MacOSX due to the 32 bit framework
;cvReleaseVideoWriter &writer


