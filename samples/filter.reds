Red/System [
	Title:		"OpenCV Tests: Filtering"
	Author:		"François Jouen"
	Rights:		"Copyright (c) 2012-2013 François Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]
 

    #include %../opencv.reds
    filename: "/Users/fjouen/Desktop/newOpenCV/red/samples/images/baboon.jpg"
    srcWnd: "Using cvTrackbar: ESC to close"
    dstWnd: "Filtering"
    tBar: "Filtre"
    ; for the trackbar  we need a pointer to get back value
    pos: 0
    &pos: declare pointer! [integer!]
    &pos: :pos
    
    ; apply a gaussian blur according to the position of the trackbar (gaussain kernel= param1 * 3.0)
    trackEvent: func [[cdecl] pos [integer!] /local v param1] [ 
        v: (pos // 2) ; param1 must be odd !!!
        if v = 1  [param1: pos cvSmooth &src &dst CV_GAUSSIAN param1 3 0.0 0.0 ]
	cvShowImage dstWnd &dst
    ]
    
    ; load an image and make a copy 
    src: cvLoadImage filename CV_LOAD_IMAGE_COLOR; CV_LOAD_IMAGE_UNCHANGED 
    dst: cvCloneImage src
    &src: as byte-ptr! src ; pointer address
    &dst: as byte-ptr! dst ; pointer address
    &&src: declare double-byte-ptr! ;double pointeur for release
    &&src/ptr: &src
    &&dst: declare double-byte-ptr!; double pointeur for release
    &&dst/ptr: &dst

    ;create windows for output images
    cvNamedWindow srcWnd CV_WINDOW_AUTOSIZE
    cvNamedWindow dstWnd CV_WINDOW_AUTOSIZE
    cvMoveWindow dstWnd 630 150
    
    ; trackbars for the source window 
    cvCreateTrackbar tBar srcWnd &pos 100 :trackEvent &pos
    
    ; repeat show images 
    cvShowImage srcWnd &src
    cvShowImage dstWnd &dst
    cvWaitKey 0 ; until a key is pressed
    
    ; release window and images
    
    cvDestroyAllWindows
    cvReleaseImage &&src
    cvReleaseImage &&dst
    