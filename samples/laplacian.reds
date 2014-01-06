Red/System [
	Title:		"OpenCV Tests: Laplacian"
	Author:		"François Jouen"
	Rights:		"Copyright (c) 2012-2013 François Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]
 

    #include %../opencv.reds
    filename: "/Users/fjouen/Desktop/newOpenCV/red/examples/samples/fruits.jpg"
    srcWnd: "Source"
    dstWnd: "Laplacian"
   
    
    ; load an image and make a copy 
    src: cvLoadImage filename CV_LOAD_IMAGE_UNCHANGED
    &src: as byte-ptr! src ; pointer address
   
    &&src: declare double-byte-ptr! ;double pointeur for release
    &&src/ptr: &src
    size: declare CvSize!
    size: CvGetSize &src
    print [size lf]
    dst: cvCreateImage src/width src/height IPL_DEPTH_32F 3
    &dst: as byte-ptr! dst ; pointer address
    &&dst: declare double-byte-ptr!; double pointeur for release
    &&dst/ptr: &dst
    
    ;create windows for output images
    cvNamedWindow srcWnd CV_WINDOW_AUTOSIZE
    cvNamedWindow dstWnd CV_WINDOW_AUTOSIZE
    cvMoveWindow dstWnd 630 100
    
    ; repeat show images
    
    cvLaplace &src &dst 3  ; 1 to 7 and odd !
    cvShowImage srcWnd &src
    cvShowImage dstWnd &dst
   
    cvWaitKey 0 ; until a key is pressed
    
    ; release window and images
    
    cvDestroyAllWindows
    cvReleaseImage &&src
    cvReleaseImage &&dst
    
    