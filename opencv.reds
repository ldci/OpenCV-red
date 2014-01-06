Red/System [
	Title:		"OpenCV Binding"
	Author:		"François Jouen"
	Rights:		"Copyright (c) 2012-2013 François Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; comment and uncomment lib path according to your opencv version 

;cxcore lib 
#switch OS [
	;MacOSX		[#define cxcore "/Library/Frameworks/OpenCV1-0.framework/Versions/Current/OpenCV"]  ; 1.0.0
        MacOSX		[#define cxcore "/Library/Frameworks/OpenCV2-0.framework/Versions/Current/OpenCV"]  ; 2.2.0
        ;MacOSX		[#define cxcore "/usr/local/lib/cxcore_core.2.4.dylib"]                             ; 64-bit version
        ;Windows	[#define cxcore "c:\windows\system32\cxcore100.dll"]                                ; 1.0.0
        Windows		[#define cxcore "c:\OpenCV2.0\bin\libcxcore200.dll"]                                ; 2.2.0
        Linux           [#define cxcore "/usr/lib/libcxcore.so.2.1"]                                        ; 2.0.0
	#default	[#define cxcore "/Library/Frameworks/OpenCV1-0.framework/Versions/Current/OpenCV"]
]


;cvision lib
#switch OS [
        ;MacOSX		[#define cvision "/Library/Frameworks/OpenCV1-0.framework/Versions/A/OpenCV"]   ; 1.0.0
        MacOSX		[#define cvision "/Library/Frameworks/OpenCV2-0.framework/Versions/B/OpenCV"]   ; 2.2.0
        ;MacOSX		[#define cvision "/usr/local/lib/ibopencv_imgproc.2.4.dylib"]                   ; 64-bit version
        ;Windows	[#define cvision "c:\windows\system32\cv100.dll"]                               ; 1.0.0
        Windows		[#define cvision "c:\OpenCV2.0\bin\libcv200.dll"]                               ; 2.2.0
        Linux           [#define cvision "/usr/lib/libcv.so.2.1"]                                       ; 2.0.0
	#default	[#define cvision "/Library/Frameworks/OpenCV1-0.framework/Versions/Current/OpenCV"]
]

; highgui lib 
#switch OS [
        ;MacOSX		[#define highgui "/Library/Frameworks/OpenCV1-0.framework/Versions/A/OpenCV"]   ; 1.0.0
        MacOSX		[#define highgui "/Library/Frameworks/OpenCV2-0.framework/Versions/B/OpenCV"]   ; 2.2.0
        ;MacOSX		[#define highgui "/usr/local/lib/ibopencv_highgui.dylib"]                       ; 64-bit version
        ;Windows	[#define highgui "c:\windows\system32\highgui100.dll"]                          ; 1.0.0
        Windows		[#define highgui "c:\OpenCV2.0\bin\libhighgui200.dll"]                          ; 2.2.0
        Linux           [#define highgui "/usr/lib/libhighgui.so.2.1"]                                  ; 2.0.0
	#default	[#define highgui "/Library/Frameworks/OpenCV1-0.framework/Versions/Current/OpenCV"]
] 




;include all we need for openCV
#include %libs/rstypes.reds                             ; some specific structures for Red/S
#include %libs/cvver.reds				; version numbering
#include %libs/cxerror.reds				; error processing
#include %libs/cxtypes.reds  	                        ; cxcore structures
#include %libs/cxcore.reds   	                        ; cxcore functions                          :cxcore
#include %libs/cvtypes.reds                             ; Computer Vision structures
#include %libs/cv.reds		 			; Computer Vision functions                 :cvision
#include %libs/highgui.reds 	                        ; Simple Highgui structures and functions   :highui










