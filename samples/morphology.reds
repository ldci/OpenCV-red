Red/System [
	Title:		"OpenCV Tests: Morphology Transformations"
	Author:		"Franois Jouen"
	Rights:		"Copyright (c) 2012-2013 Franois Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]
 

    #include %../opencv.reds
    filename: "/Users/fjouen/Desktop/newOpenCV/red/samples/images/baboon.jpg"

    element_shape: CV_SHAPE_RECT
    max_iters: 10;
    open_close_pos: max_iters + 1
    erode_dilate_pos: max_iters + 1
    
   
    

    ;the address of variable which receives trackbar position update
    &open_close_pos: declare pointer![integer!] &open_close_pos: :open_close_pos
    &erode_dilate_pos: declare pointer![integer!] &erode_dilate_pos: :erode_dilate_pos

    ;callback functions for open/close trackbar
    OpenClose: func [[cdecl] pos [integer!] /local n an][
        n: &open_close_pos/value - max_iters
        either n > 0 [an: n] [an: 0 - n]
        element: cvCreateStructuringElementEx (an * 2) + 1 (an * 2) + 1 an an element_shape null ; 0
        &element: as byte-ptr! element
        &&element: declare double-byte-ptr!
        &&element/ptr: &element 
        either n < 0 [cvErode &src &dst element 1 cvDilate &dst &dst element 1]
                     [cvDilate &src &dst element 1 cvErode &dst &dst element 1]
        cvReleaseStructuringElement  &&element
        cvShowImage "Open/Close" &dst
    ]
    
    
    ErodeDilate: func [[cdecl] pos [integer! ] /local n an][
        n: &erode_dilate_pos/value - max_iters
	either n > 0 [an: n] [an: 0 - n]
        element: cvCreateStructuringElementEx (an * 2) + 1 (an * 2) + 1 an an element_shape null ; 0
        &element: as byte-ptr! element
        &&element: declare double-byte-ptr!
        &&element/ptr: &element
        either n < 0 [cvErode &src &dst element 1] [cvDilate &src &dst element 1 ]
        cvReleaseStructuringElement  &&element
        cvShowImage "Erode/Dilate" &dst
        ]


    src: cvLoadImage filename CV_LOAD_IMAGE_UNCHANGED 
    dst: cvCloneImage src
    &src: as byte-ptr! src ; pointer address
    &dst: as byte-ptr! dst ; pointer address
    &&src: declare double-byte-ptr! ;double pointeur for release
    &&src/ptr: &src
    &&dst: declare double-byte-ptr!; double pointeur for release
    &&dst/ptr: &dst

    ;create windows for output images
    cvNamedWindow "Open/Close" CV_WINDOW_AUTOSIZE
    cvNamedWindow "Erode/Dilate" CV_WINDOW_AUTOSIZE
    cvMoveWindow "Erode/Dilate" 630 100
    
    ; trackbars
    cvCreateTrackbar  "Iterations" "Open/Close" &open_close_pos max_iters * 2 + 1 :OpenClose 
    cvCreateTrackbar "Iterations" "Erode/Dilate" &erode_dilate_pos max_iters * 2 + 1 :ErodeDilate


    cvShowImage "Open/Close" &dst
    cvShowImage "Erode/Dilate" &dst
    
    print ["Hot keys:" lf "ESC - quit the program" lf "r - use rectangle structuring element" lf "e - use elliptic structuring element" lf
           "c - use cross-shaped structuring element" lf "SPACE - loop through all the options" lf]
    
    
    c: 0
    until [
    OpenClose open_close_pos
    ErodeDilate erode_dilate_pos
    if c = 99 [element_shape: CV_SHAPE_CROSS]  ; c: use cross-shaped structuring element
    if c = 101 [element_shape: CV_SHAPE_ELLIPSE] ; e : use elliptic structuring element
    if c = 114 [element_shape: CV_SHAPE_RECT] ; r: use rectangle structuring element
    if c = 32 [element_shape: element_shape + 1 // 3]; space : loop through all the options
    c: cvWaitKey 0
    c = 27
    ]
    
    
    cvDestroyAllWindows
    cvReleaseImage &&src
    cvReleaseImage &&dst
    