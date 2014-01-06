Red/System [
	Title:		"OpenCV Machine Learning"
	Author:		"François Jouen"
	Rights:		"Copyright (c) 2012-2013 François Jouen. All rights reserved."
	License: 	"BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

#include %cxtypes.reds  ; for standalone testing


; machine

#switch OS [
	Windows		[#define machine "c:\windows\system32\ml100.dll"]
        MacOSX		[#define machine "/Library/Frameworks/OpenCV1-0.framework/Versions/A/OpenCV"]  ; 1.0.0
        ;MacOSX		[#define machine "/Library/Frameworks/OpenCV2-0.framework/Versions/B/OpenCV"]  ; 2.2.0
        ;MacOSX		[#define machine "/usr/local/lib/ibopencv_highgui.dylib"]                      ; 64-bit version
        Linux           []
	#default	[#define machine "/Library/Frameworks/OpenCV1-0.framework/Versions/A/OpenCV"]
]

;The Machine Learning Library (MLL) is a set of classes and functions for statistical classification,
;regression and clustering of data.

;log(2*PI) 
#define CV_LOG2PI       [(1.8378770664093454835606594728112)]

;columns of <trainData> matrix are training samples 
#define CV_COL_SAMPLE   0

;rows of <trainData> matrix are training samples
#define CV_ROW_SAMPLE   1

#define CV_IS_ROW_SAMPLE(flags) [((flags) AND CV_ROW_SAMPLE)]

union!: alias struct![
    ptr         [double-byte-ptr!]; uchar** 
    fl          [double-float-ptr!]; float** 
    db          [double-float-ptr!]; double** 
]

CvVectors!: alias struct! [
    type        [integer!]
    dims        [integer!]
    count       [integer!]
    next        [CvVectors!]
    data        [union!]
]