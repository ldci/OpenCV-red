Red/System [
	Title:		"OpenCV cxerror"
	Author:		"François Jouen"
	Rights:		"Copyright (c) 2012013 François Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

;************Below is declaration of error handling stuff in PLSuite manner**

 
#define CVStatus 	integer!

;this part of CVStatus is compatible with IPLStatus Some of below symbols are not [yet] used in OpenCV

#define CV_StsOk                    0  ; everithing is ok                
#define CV_StsBackTrace            -1  ; pseudo error for back trace     
#define CV_StsError                -2  ; unknown /unspecified error      
#define CV_StsInternal             -3  ; internal error (bad state)      
#define CV_StsNoMem                -4  ; insufficient memory             
#define CV_StsBadArg               -5  ; function arg/param is bad       
#define CV_StsBadFunc              -6  ; unsupported function            
#define CV_StsNoConv               -7  ; iter. didn't converge           
#define CV_StsAutoTrace            -8  ; tracing                         

#define CV_HeaderIsNull            -9  ; image header is NULL            
#define CV_BadImageSize            -10 ; image size is invalid           
#define CV_BadOffset               -11 ; offset is invalid               
#define CV_BadDataPtr              -12 ;
#define CV_BadStep                 -13 ;
#define CV_BadModelOrChSeq         -14 ;
#define CV_BadNumChannels          -15 ;
#define CV_BadNumChannel1U         -16 ;
#define CV_BadDepth                -17 ;
#define CV_BadAlphaChannel         -18 ;
#define CV_BadOrder                -19 ;
#define CV_BadOrigin               -20 ;
#define CV_BadAlign                -21 ;
#define CV_BadCallBack             -22 ;
#define CV_BadTileSize             -23 ;
#define CV_BadCOI                  -24 ;
#define CV_BadROISize              -25 ;

#define CV_MaskIsTiled             -26 ;

#define CV_StsNullPtr                -27 ; null pointer 
#define CV_StsVecLengthErr           -28 ; incorrect vector length 
#define CV_StsFilterStructContentErr -29 ; incorr. filter structure content 
#define CV_StsKernelStructContentErr -30 ; incorr. transform kernel content 
#define CV_StsFilterOffsetErr        -31 ; incorrect filter ofset value 

;extra for CV 
#define CV_StsBadSize                -201 ; the input/output structure size is incorrect  
#define CV_StsDivByZero              -202 ; division by zero 
#define CV_StsInplaceNotSupported    -203 ; in-place operation is not supported 
#define CV_StsObjectNotFound         -204 ; request can't be completed 
#define CV_StsUnmatchedFormats       -205 ; formats of input/output arrays differ 
#define CV_StsBadFlag                -206 ; flag is wrong or not supported   
#define CV_StsBadPoint               -207 ; bad CvPoint  
#define CV_StsBadMask                -208 ; bad format of mask (neither 8uC1 nor 8sC1)
#define CV_StsUnmatchedSizes         -209 ; sizes of input/output structures do not match 
#define CV_StsUnsupportedFormat      -210 ; the data format/type is not supported by the function
#define CV_StsOutOfRange             -211 ; some of parameters are out of range 
#define CV_StsParseError             -212 ; invalid syntax/structure of the parsed file 
#define CV_StsNotImplemented         -213 ; the requested function/feature is not implemented 
#define CV_StsBadMemBlock            -214 ; an allocated block has been corrupted 
