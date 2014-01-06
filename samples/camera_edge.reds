Red/System [
	Title:		"OpenCV Camera with laplacian"
	Author:		"François Jouen"
	Rights:		"Copyright (c) 2012-2013 François Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

#include %../opencv.reds


trackEvent: func [[cdecl] pos [integer!] /local v param1] [ 
        v: (pos // 2) ; param must be odd !!!
        image: cvRetrieveFrame capture      ; get the frame
        if v = 1  [either pos <= 7 [neighbourhoodSize: pos] [neighbourhoodSize: 7]] ; odd and <= 7
        cvLaplace &image &laplace neighbourhoodSize
        ;cvResizeWindow windowName 800 600
       	cvShowImage windowName &laplace   ; show frame
       
        
]

cvStartWindowThread  ; own's window thread 


windowName: "Laplace Edge Detection: ESC for quit"
tbarname: "Threshold"
neighbourhoodSize: 1 

; for the trackbar  we need a pointer to get back value
pos: 0
&pos: declare pointer! [integer!]
&pos: :pos

; we also need an image from the camera

capture: cvCreateCameraCapture 0; capture is a byte-ptr! 

&&capture: declare double-byte-ptr!
&&capture/ptr: capture

cvNamedWindow windowName CV_WINDOW_AUTOSIZE ; create window to show movie

image: cvRetrieveFrame capture ; get the first image 
&image: as byte-ptr! image ; pointer address
&&image: declare double-byte-ptr!
&&image/ptr: &image; double pointeur 

;create the output window

laplace: cvCreateImage image/width image/height IPL_DEPTH_32F image/nChannels
&laplace: as byte-ptr! laplace ; pointer address
&&laplace: declare double-byte-ptr!; double pointeur for release
&&laplace/ptr: &laplace


cvCreateTrackbar tbarname windowName &pos 7 :trackEvent &pos
trackEvent 0

key:  27; 
foo: 0

; repeat until q keypress
while [foo <> key] [
        trackEvent neighbourhoodSize
        foo: cvWaitKey 1
]


print ["Done. Any key to quit" lf]
cvWaitKey 0

; releases structures and windows

&&capture/ptr: capture 
cvDestroyAllWindows
cvReleaseImage &&image
cvReleaseImage &&laplace

;cvReleaseCapture &&capture ; a pb with MacOSX due to the 32 bit framework


