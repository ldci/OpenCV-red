Red/System [
	Title:		"OpenCV Tests"
	Author:		"François Jouen"
	Rights:		"Copyright (c) 2012 François Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]


#include %../opencv.reds


movie: "/Users/fjouen/Desktop/newOpenCV/red/samples/images/test.mov" ; use your own movie
cvStartWindowThread

capture: cvCreateFileCapture movie
&&capture: declare double-byte-ptr!; double pointeur
&&capture/ptr: capture

print [capture " " &&capture]
assert capture <> null
; some infomation about our movie
print ["Width:  " cvGetCaptureProperty capture CV_CAP_PROP_FRAME_WIDTH lf]
print ["Height:  " cvGetCaptureProperty capture CV_CAP_PROP_FRAME_HEIGHT lf]
print ["N of Frames:  " cvGetCaptureProperty capture CV_CAP_PROP_FRAME_COUNT lf]
print ["FPS:  " cvGetCaptureProperty capture CV_CAP_PROP_FPS lf]
;print ["FOURCC:  " cvGetCaptureProperty capture CV_CAP_PROP_FOURCC lf] ; we have a pb with FOURCC with OSX


cvNamedWindow movie CV_WINDOW_AUTOSIZE ; create window to show the movie

image: cvQueryFrame capture ; for movie frames
&image: as byte-ptr! image
&&image: declare double-byte-ptr!
&&image/ptr: &image 

;cvWaitKey 0

foo: 0


while [foo <> 113] [
  	image: cvQueryFrame capture ; get frame
 	cvShowImage movie &image ; show frame
	foo: cvWaitKey 42 ; wait for 42 ms  (1/FPS * 1000)
]

print ["Done. Any key to quit" lf]
cvWaitKey 0
cvDestroyAllWindows
cvReleaseImage &&image
;cvReleaseCapture &&capture ; a pb with MacOSX due to the 32 bit framework
 

