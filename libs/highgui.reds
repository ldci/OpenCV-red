Red/System [
	Title:		"OpenCV highgui"
	Author:		"Fran�ois Jouen"
	Rights:		"Copyright (c) 2012-2013 Fran�ois Jouen. All rights reserved."
	License: 	"BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; Highgui



;#include %cxtypes.reds  ; for standalone testing


;The  opencv structure CvCapture does not have public interface and is used only as a parameter for video capturing functions.
#define CvCapture! byte-ptr!
#define CvHandle! byte-ptr! ; for the native window handle (not used in OSX)
#define CvVideoWriter! [double-byte-ptr!]

; for callback ; this corresponds to function prototyped as void position(int) OK
#define CvTrackbarCallback! [function! [position [integer!]]] 
;for mouse events: OK 
#define CvMouseCallback! [function! [
        event 	        [integer!] 
        x 		[integer!]
        y 		[integer!]
        flags	        [integer!]
        param           [byte-ptr!]
    ]
]

; windows size

#define CV_WINDOW_AUTOSIZE          1

; mouse events 

 #define CV_EVENT_MOUSEMOVE         0
 #define CV_EVENT_LBUTTONDOWN       1
 #define CV_EVENT_RBUTTONDOWN       2
 #define CV_EVENT_MBUTTONDOWN       3
 #define CV_EVENT_LBUTTONUP         4
 #define CV_EVENT_RBUTTONUP         5
 #define CV_EVENT_MBUTTONUP         6
 #define CV_EVENT_LBUTTONDBLCLK     7
 #define CV_EVENT_RBUTTONDBLCLK     8
 #define CV_EVENT_MBUTTONDBLCLK     9
 #define CV_EVENT_FLAG_LBUTTON      1
 #define CV_EVENT_FLAG_RBUTTON      2
 #define CV_EVENT_FLAG_MBUTTON      4
 #define CV_EVENT_FLAG_CTRLKEY      8
 #define CV_EVENT_FLAG_SHIFTKEY     16
 #define CV_EVENT_FLAG_ALTKEY       32

;flags when loading image
#define CV_LOAD_IMAGE_UNCHANGED     -1 ;8bit, color or not
#define CV_LOAD_IMAGE_GRAYSCALE     0 ;8bit, gray
#define CV_LOAD_IMAGE_COLOR         1 ; ?, color
#define CV_LOAD_IMAGE_ANYDEPTH      2 ;any depth, ? 
#define CV_LOAD_IMAGE_ANYCOLOR      4 ;?, any color


; convert one image to another 
#define CV_CVTIMG_FLIP              1
#define CV_CVTIMG_SWAP_RB           2 
#define CV_DEFAULT		    0

; playing with camera
#define CV_CAP_ANY                  0     ; autodetect
#define CV_CAP_MIL                  100   ; MIL proprietary drivers
#define CV_CAP_VFW                  200   ; platform native
#define CV_CAP_V4L                  200
#define CV_CAP_V4L2                 200
#define CV_CAP_FIREWARE             300   ; IEEE 1394 drivers
#define CV_CAP_IEEE1394             300
#define CV_CAP_DC1394               300
#define CV_CAP_CMU1394              300
#define CV_CAP_STEREO               400   ;TYZX proprietary drivers
#define CV_CAP_TYZX                 400
#define CV_TYZX_LEFT                400
#define CV_TYZX_RIGHT               401
#define CV_TYZX_COLOR               402
#define CV_TYZX_Z                   403
#define CV_CAP_QT                   500   ; QuickTime

; capture properties

#define CV_CAP_PROP_POS_MSEC       0
#define CV_CAP_PROP_POS_FRAMES     1
#define CV_CAP_PROP_POS_AVI_RATIO  2
#define CV_CAP_PROP_FRAME_WIDTH    3
#define CV_CAP_PROP_FRAME_HEIGHT   4
#define CV_CAP_PROP_FPS            5
#define CV_CAP_PROP_FOURCC         6
#define CV_CAP_PROP_FRAME_COUNT    7 
#define CV_CAP_PROP_FORMAT         8
#define CV_CAP_PROP_MODE           9
#define CV_CAP_PROP_BRIGHTNESS    10
#define CV_CAP_PROP_CONTRAST      11
#define CV_CAP_PROP_SATURATION    12
#define CV_CAP_PROP_HUE           13
#define CV_CAP_PROP_GAIN          14
#define CV_CAP_PROP_CONVERT_RGB   15

; great with Red 0.31 we can define macros!!!
#define CV_FOURCC(c1 c2 c3 c4) [(((((as integer! c1)) and 255) + (((as integer! c2) and 255) << 8) + (((as integer! c3) and 255) << 16) + (((as integer! c4) and 255) << 24)))]

#define CV_FOURCC_PROMPT        -1  ; Open Codec Selection Dialog (Windows only) */
#define CV_FOURCC_DEFAULT       -1 ; Use default codec for specified filename (Linux only) */


#import [
    highgui cdecl [
    cvInitSystem: "cvInitSystem" [
        "This function is used to set some external parameters in case of X Window"
		argc 	[integer!]
		char** 	[c-string!]
		return: [integer!]
	]
    ;Start a separated window thread that will manage mouse events inside the windows. Status : OK  
    cvStartWindowThread: "cvStartWindowThread" []    
    ; create window :flags CV_DEFAULT(CV_WINDOW_AUTOSIZE) ). Status: OK
	cvNamedWindow: "cvNamedWindow" [
		name 	[c-string!]
		flags 	[integer!]
		return: [integer!]
	]
        
    ;destroy window and all the trackers associated with it. Status: OK
	cvDestroyWindow: "cvDestroyWindow" [
		name [c-string!]
	]
		
	cvDestroyAllWindows: "cvDestroyAllWindows" [
        ] ;Status: OK
		
	;resize/move window.Status: both OK
	cvResizeWindow: "cvResizeWindow" [
		name 	[c-string!]
		width 	[integer!]
		height 	[integer!]
	]  
		
	cvMoveWindow: "cvMoveWindow" [
		name 	[c-string!]
		x 	[integer!]
		y 	[integer!]
	]
        
    ;get native window handle (HWND in case of Win32 and Widget in case of X Window).Status: not tested (MacOSX)
	cvGetWindowHandle: "cvGetWindowHandle" [
		name 	[c-string!]
		return: [CvHandle!] ; handle: void*  
	]
	;get name of highgui window given its native handle 
	cvGetWindowName: "cvGetWindowName" [
		window_handle 	[cvHandle!]; void*
		return: 	[c-string!]
	]
        
; all about images
        ; normally defined in cxCore ; so should be moved in next version
        ; this function returns an IplImage! structure and not a CvArr!
        ;Status: OK
        hcvCreateImage: "cvCreateImage" [
		x 		[integer!]
		y 		[integer!]
		depth 		[integer!]
		channels 	[integer!]
		return: 	[IplImage!] ; struct used as pointer since in red/system structures are implicit pointers 	
	]
	
        ;show images.Status: OK	
	cvShowImage:"cvShowImage" [
		name            [c-string!]
		image           [CvArr!] ; 
	]
        ;create trackbar and display it on top of given window, set callback.Status: OK
	cvCreateTrackbar: "cvCreateTrackbar" [
                trackbar_name   [c-string!]
		window_name     [c-string!]
		value           [int-ptr!] ; a pointer int* value
		count           [integer!]
		on_change       [CvTrackbarCallback!] ; Pointer to the function; can be null (none)
	]
	;retrieve or set trackbar position.Status: OK
	cvGetTrackbarPos: "cvGetTrackbarPos" [
		trackbar_name   [c-string!]
		window_name     [c-string!]
		return:         [integer!]
	]
	;Status: OK	
	cvSetTrackbarPos: "cvSetTrackbarPos" [
		trackbar_name   [c-string!]
		window_name     [c-string!]
        pos             [integer!]
	]
	;assign callback for mouse events. Status: OK
	cvSetMouseCallback: "cvSetMouseCallback" [
		window_name     [c-string!]
		on_mouse        [CvMouseCallback!] ; pointer sur une fonction
        param	        [byte-ptr!] ; must be null
        ]
        
        ;load image from file . Status: OK
  		;iscolor can be a combination of above flags where CV_LOAD_IMAGE_UNCHANGED overrides the other flags
  		;using CV_LOAD_IMAGE_ANYCOLOR alone is equivalent to CV_LOAD_IMAGE_UNCHANGED
  		;unless CV_LOAD_IMAGE_ANYDEPTH is specified images are converted to 8bit
  		
        cvLoadImage: "cvLoadImage" [
		filename        [c-string!]
		flags           [integer!]
		return:         [IplImage!]
	] 
	; to be tested for matrix	
	cvLoadImageM: "cvLoadImage" [
		filename        [c-string!]
		iscolor         [integer!] ;CV_DEFAULT(CV_LOAD_IMAGE_COLOR))
		return:         [CvMat!]
	] 
		
	;save image to file. Status: OK
	cvSaveImage: "cvSaveImage" [
		filename        [c-string!]
		image           [CvArr!];  OK
	]
		
	;utility function: convert one image to another with optional vertical flip. Status: OK
	cvConvertImage: "cvConvertImage" [
	    	src             [CvArr!]
	    	des             [CvArr!]
	    	flags           [integer!] ;CV_DEFAULT(0)
	]
	; wait for key event infinitely (delay<=0) or for "delay" milliseconds. Status: OK
        cvWaitKey: "cvWaitKey" [
		delay           [integer!]
		return:         [integer!]
	]                       
        ;******************************************************************************************************    
        ;playing with camera
	;start capturing frames from camera: index = camera_index + domain_offset (CV_CAP_*)
	cvCreateCameraCapture: "cvCreateCameraCapture" [
		index           [integer!]
		return:         [CvCapture!] ;an implicit pointer in Red     
	]
        
        cvCaptureFromCAM_QT:   "cvCreateCameraCapture" [
		index           [integer!]
		return:         [CvCapture!] ;an implicit pointer in Red     
	]
        
	;start capturing frames from video file. Status: OK
	cvCreateFileCapture: "cvCreateFileCapture" [
		filename        [c-string!]
		return:         [CvCapture!]
	] 
	;grab a frame, ATTENTION return 1 on success, 0 on fail Status: OK
	cvGrabFrame: "cvGrabFrame" [
		capture         [CvCapture!]
		return:         [integer!]
	] 
		
	;get the frame grabbed with cvGrabFrame(..). This function may apply some frame processing like frame decompression, flipping etc.
  	;!!!DO NOT RELEASE or MODIFY the retrieved frame!!!
        ;Status: OK
	cvRetrieveFrame: "cvRetrieveFrame" [
		capture         [CvCapture!]
		return:         [IplImage!]
	]
		
	;Just a combination of cvGrabFrame and cvRetrieveFrame !!!DO NOT RELEASE or MODIFY the retrieved frame!!! Status: OK
	cvQueryFrame: "cvQueryFrame" [
		capture         [CvCapture!]
		return:         [IplImage!]
	]
		
	;stop capturing/reading and free resources. Status: OK except for OSX Framework Pb
	cvReleaseCapture: "cvReleaseCapture" [
		capture			[double-byte-ptr!]
		return:         [integer!]
	] 
	;retrieve or set capture properties. Status: both OK
	cvGetCaptureProperty: "cvGetCaptureProperty" [
		capture         [CvCapture!] 
		property_id     [integer!]
		return:         [float!] ; double in c (64-bit)
	]
	cvSetCaptureProperty: "cvSetCaptureProperty" [
		capture         [CvCapture!]
		property_id     [integer!]
		value           [float!] ; double in c (64-bit)
		return:         [integer!]
	]
		
	;initialize video file writer; Status: OK
        ;On Windows HighGui uses Video for Windows (VfW), on Linux ffmpeg is used and on Mac OS X the back end is QuickTime
        ; To be tested : CV_FOURCC 
	cvCreateVideoWriter: "cvCreateVideoWriter" [
		filename        [c-string!]
		fourcc          [integer!]
		pfs             [float!] ; double in c (32-bit)
		;frame-size      [cvSize!] ; use 2 integers rather cvSize! structure!
                width           [integer!]
                height          [integer!]
		is_color        [integer!] ;CV_DEFAULT(1))
		return:         [CvVideoWriter!]
	]		
	;write frame to video file. Status: OK
	cvWriteFrame: "cvWriteFrame" [
		writer          [CvVideoWriter!]
		image           [IplImage!]
                return:         [integer!]
	]
		
	;close video file writer. Status: OK
	cvReleaseVideoWriter: "cvReleaseVideoWriter" [
                writer**          [double-byte-ptr!]
	]	
        
    ]; fin cedl
]; fin import

 ;******************************************************************************************************    
;Obsolete functions/synonyms   

;#ifndef HIGHGUI_NO_BACKWARD_COMPATIBILITY
 ;   #define HIGHGUI_BACKWARD_COMPATIBILITY
;#endif
;#ifdef HIGHGUI_BACKWARD_COMPATIBILITY
; en cas de HIGHGUI_BACKWARD_COMPATIBILITY
#define cvCaptureFromFile cvCreateFileCapture
#define cvCaptureFromCAM cvCreateCameraCapture
#define cvCaptureFromAVI cvCaptureFromFile
#define cvCreateAVIWriter cvCreateVideoWriter
#define cvWriteToAVI cvWriteFrame
#define cvAddSearchPath(path)
#define cvvInitSystem cvInitSystem
#define cvvNamedWindow cvNamedWindow
#define cvvShowImage cvShowImage
#define cvvResizeWindow cvResizeWindow
#define cvvDestroyWindow cvDestroyWindow
#define cvvCreateTrackbar cvCreateTrackbar
#define cvvLoadImage(name) (cvLoadImage name 1)
#define cvvSaveImage cvSaveImage
#define cvvAddSearchPath cvAddSearchPath
#define cvvWaitKey(name) (cvWaitKey0)
#define cvvWaitKeyEx(name delay) (cvWaitKey delay)
#define cvvConvertImage cvConvertImage
#define HG_AUTOSIZE CV_WINDOW_AUTOSIZE

#if OS = 'Windows [
	; TBD if necessary
]

; not necessary for us  __cplusplus
