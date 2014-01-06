Red/System [
	Title:		"OpenCV Tests: Edge"
	Author:		"Franois Jouen"
	Rights:		"Copyright (c) 2012-2013 Franois Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]
 

#include %../opencv.reds
filename: "/Users/fjouen/Desktop/newOpenCV/red/samples/images/fruits.jpg"

wndname: "Edge"
tbarname: "Threshold"
edge_thresh: 1
&edge_thresh: declare pointer![integer!]
&edge_thresh/value: edge_thresh

;define a trackbar callback

on_trackbar: func [[cdecl] h [integer!] ] [
    cvSmooth &gray &edge CV_BLUR 3 3 0.0 0.0
    cvNot &gray &edge
    ; specific to Red/S get back pointer value 
    edge_thresh: &edge_thresh/value
    
    ;Run the edge detector on grayscale
    cvZero &cedge
    
    if h > 0 [ cvCanny &gray  &edge int-to-float edge_thresh int-to-float edge_thresh * 3 3]
    
    ;copy edge points and show results
    cvCopy &image &cedge &edge
    cvShowImage wndname &cedge
    
    
]


image: cvLoadImage filename 1 
&image: as byte-ptr! image
&&image: declare double-byte-ptr!
&&image/ptr: &image


;Create the output image
cedge: cvCreateImage image/width image/height IPL_DEPTH_8U 3
&cedge: as byte-ptr! cedge
&&cedge: declare double-byte-ptr!
&&cedge/ptr: &cedge

;Convert to grayscale

gray: cvCreateImage image/width image/height IPL_DEPTH_8U 1
&gray: as byte-ptr! gray
&&gray: declare double-byte-ptr!
&&gray/ptr: &gray

edge: cvCreateImage image/width image/height IPL_DEPTH_8U 1
&edge: as byte-ptr! edge
&&edge: declare double-byte-ptr!
&&edge/ptr: &edge

cvCvtColor &image &gray CV_BGR2GRAY
;Create a window
cvNamedWindow wndname 1

;  create trackbar
cvCreateTrackbar tbarname wndname &edge_thresh 100 :on_trackbar

;Show the image

on_trackbar 0

;Wait for a key stroke; the same function arranges events processing
cvWaitKey 0

cvReleaseImage &&image
cvReleaseImage &&gray
cvReleaseImage &&edge
cvDestroyWindow wndname