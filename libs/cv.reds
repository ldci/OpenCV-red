Red/System [
	Title:		"OpenCV Binding: Image processing "
	Author:		"François Jouen"
	Rights:		"Copyright (c) 2012-2013 François Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

;cvision

;#include %cxtypes.reds    ; for standalone testing
;#include %cvtypes.reds    ; for standalone testing


#define CvDistanceFunction! byte-ptr! ; to be modified !!!
#define CvContourScanner! byte-ptr! ; to be modified !!!
#define CvQuadEdge2D! byte-ptr! ; to be modified !!!

#define CvPOSITObject! byte-ptr!

;*                                    Image Processing                                    *

#import [
    cvision cdecl [
        cvCopyMakeBorder: "cvCopyMakeBorder" [
        "Copies source 2D array inside of the larger destination array and makes a border of the specified type (IPL_BORDER_*) around the copied area."
            src 	                [CvArr!]
            dst 	                [CvArr!]
            x  		                [integer!] ; in fact CvPoint
            y		                [integer!]
            bordertype                  [integer!]
            ;value 	                [_CvScalar] ;CvScalar CV_DEFAULT(cvScalarAll(0))
            v0                          [float!]
            v1                          [float!]
            v2                          [float!]
            v3                          [float!]
        ]
        
        #define CV_BLUR_NO_SCALE        0
        #define CV_BLUR                 1
        #define CV_GAUSSIAN             2
        #define CV_MEDIAN               3
        #define CV_BILATERAL            4
        
        cvSmooth: "cvSmooth" [
        "Smoothes array (removes noise)"
            src 		        [CvArr!]
            dst 		        [CvArr!]
            smoothtype 	                [integer!] ; CV_DEFAULT(CV_GAUSSIAN)
            param1		        [integer!] ; CV_DEFAULT(3)
            param2		        [integer!] ; CV_DEFAULT(0)
            param3		        [float!] ; CV_DEFAULT(0)
            param4		        [float!] ; CV_DEFAULT(0)	
        ]
        
        cvFilter2D: "cvFilter2D" [
        "Convolves the image with the kernel"
            src 		        [CvArr!]
            dst 		        [CvArr!]
            kernel		        [CvMat!]
            x  			        [integer!] ; in fact CvPoint 
            y			        [integer!] ;CV_DEFAULT(cvPoint(-1,-1))
        ]
        cvIntegral: "cvIntegral" [
        "Finds integral image: SUM(X,Y) = sum(x<X,y<Y)I(x,y)"
            image 		        [CvArr!]
            sum 		        [CvArr!]
            sqsum		        [CvArr!] ;CV_DEFAULT(NULL) none
            tilted_sum	                [CvArr!] ;CV_DEFAULT(NULL) none	
        ]
        
        ;dst_width = floor(src_width/2)[+1], dst_height = floor(src_height/2)[+1]   
        cvPyrDown: "cvPyrDown" [
        "Smoothes the input image with gaussian kernel and then down-samples it."
            src 		        [CvArr!]
            dst 		        [CvArr!]
            filter		        [integer!]; CV_DEFAULT(CV_GAUSSIAN_5x5)
        ]
        
        ;dst_width = src_width*2, dst_height = src_height*2
        cvPyrUp: "cvPyrUp" [
        "Up-samples image and smoothes the result with gaussian kernel."
            src 		        [CvArr!]
            dst 		        [CvArr!]
            filter		        [integer!]; CV_DEFAULT(CV_GAUSSIAN_5x5)
        ]
        
        cvCreatePyramid: "cvCreatePyramid" [
        "Builds pyramid for an image" 
            img 			[CvArr!]
            extra_layers	        [integer!]
            rate			[float!]
            layer_sizes		        [CvSize!]; pointer to CvSize ; CV_DEFAULT(0), use an array of 2 integer with red/S
            bufarr 			[integer!] ; CV_DEFAULT(0)
            calc			[integer!]; CV_DEFAULT(1)
            filter			[integer!]; CV_DEFAULT(CV_GAUSSIAN_5x5)
            return 			[double-byte-ptr!] ;a double pointer CvMat**
        ]
        
        cvReleasePyramid: "cvReleasePyramid" [
            ***pyramid	        [struct! [ptr [double-byte-ptr!]]] ; pointer CvMat***; triple pointer (to be tested )
            extra_layers	[integer!]
        ]
        
        ;comp with contain a pointer to sequence (CvSeq) of connected components (CvConnectedComp)}
        cvPyrSegmentation: "cvPyrSegmentation" [
        "Splits color or grayscale image into multiple connected components of nearly the same color/brightness using modification of Burt algorithm."
            src 			[iplImage!]
            dst 			[iplImage!]
            storage			[CvMemStorage!]
            **comp			[double-byte-ptr!] ; pointer CvSeq**
            level			[integer!]
            threshold1		        [float!]
            threshold2		        [float!]
        ]
        
        cvPyrMeanShiftFiltering: "cvPyrMeanShiftFiltering" [
        "Filters image using meanshift algorithm"
            src 		        [CvArr!]
            dst 		        [CvArr!]
            sp			        [float!]
            sr			        [float!]
            max_level	                [integer!] ;  CV_DEFAULT(1)
            termcrit	                [CvTermCriteria!] ; CV_DEFAULT(cvTermCriteria(CV_TERMCRIT_ITER+CV_TERMCRIT_EPS,5,1)))
        ]
        
        cvWatershed: "cvWatershed" [
        "Segments image using seed markers"
            src 		        [CvArr!]
            markers 	                [CvArr!]
        ]
        
        #define CV_INPAINT_NS           0
        #define CV_INPAINT_TELEA        1
        
        cvInpaint: "cvInpaint" [
        "Inpaints the selected region in the image"
            src 			[CvArr!]
            inpaint_mask 	        [CvArr!]
            dst 			[CvArr!]
            inpaintRange	        [float!]
            flags			[integer!]	
        ]
        
        #define CV_SCHARR -1
        #define CV_MAX_SOBEL_KSIZE 7
        
        cvSobel: "cvSobel" [
        {Calculates an image derivative using generalized Sobel (aperture_size = 1,3,5,7) or Scharr (aperture_size = -1) operator.
        Scharr can be used only for the first dx or dy derivative}
            src 			[CvArr!]
            dst 			[CvArr!]
            xorder			[integer!]
            yorder			[integer!]
            aperture_size	[integer!];  CV_DEFAULT(3)
        ]
        
        cvLaplace: "cvLaplace" [
        "Calculates the image Laplacian: (d2/dx + d2/dy)I"
            src 			[CvArr!]
            dst 			[CvArr!]
            aperture_size	        [integer!];  CV_DEFAULT(3)
        ]
        
        ;Constants for color conversion */
        #define  CV_BGR2BGRA    0
        #define  CV_RGB2RGBA    CV_BGR2BGRA

        #define  CV_BGRA2BGR    1
        #define  CV_RGBA2RGB    CV_BGRA2BGR

        #define  CV_BGR2RGBA    2
        #define  CV_RGB2BGRA    CV_BGR2RGBA
    
        #define  CV_RGBA2BGR    3
        #define  CV_BGRA2RGB    CV_RGBA2BGR

        #define  CV_BGR2RGB     4
        #define  CV_RGB2BGR     CV_BGR2RGB

        #define  CV_BGRA2RGBA   5
        #define  CV_RGBA2BGRA   CV_BGRA2RGBA

        #define  CV_BGR2GRAY    6
        #define  CV_RGB2GRAY    7
        #define  CV_GRAY2BGR    8
        #define  CV_GRAY2RGB    CV_GRAY2BGR
        #define  CV_GRAY2BGRA   9
        #define  CV_GRAY2RGBA   CV_GRAY2BGRA
        #define  CV_BGRA2GRAY   10
        #define  CV_RGBA2GRAY   11

        #define  CV_BGR2BGR565  12
        #define  CV_RGB2BGR565  13
        #define  CV_BGR5652BGR  14
        #define  CV_BGR5652RGB  15
        #define  CV_BGRA2BGR565 16
        #define  CV_RGBA2BGR565 17
        #define  CV_BGR5652BGRA 18
        #define  CV_BGR5652RGBA 19

        #define  CV_GRAY2BGR565 20
        #define  CV_BGR5652GRAY 21

        #define  CV_BGR2BGR555  22
        #define  CV_RGB2BGR555  23
        #define  CV_BGR5552BGR  24
        #define  CV_BGR5552RGB  25
        #define  CV_BGRA2BGR555 26
        #define  CV_RGBA2BGR555 27
        #define  CV_BGR5552BGRA 28
        #define  CV_BGR5552RGBA 29

        #define  CV_GRAY2BGR555 30
        #define  CV_BGR5552GRAY 31

        #define  CV_BGR2XYZ     32
        #define  CV_RGB2XYZ     33
        #define  CV_XYZ2BGR     34
        #define  CV_XYZ2RGB     35

        #define  CV_BGR2YCrCb   36
        #define  CV_RGB2YCrCb   37
        #define  CV_YCrCb2BGR   38
        #define  CV_YCrCb2RGB   39

        #define  CV_BGR2HSV     40
        #define  CV_RGB2HSV     41

        #define  CV_BGR2Lab     44
        #define  CV_RGB2Lab     45

        #define  CV_BayerBG2BGR 46
        #define  CV_BayerGB2BGR 47
        #define  CV_BayerRG2BGR 48
        #define  CV_BayerGR2BGR 49
    
        #define  CV_BayerBG2RGB CV_BayerRG2BGR
        #define  CV_BayerGB2RGB CV_BayerGR2BGR
        #define  CV_BayerRG2RGB CV_BayerBG2BGR
        #define  CV_BayerGR2RGB CV_BayerGB2BGR

        #define  CV_BGR2Luv     50
        #define  CV_RGB2Luv     51
        #define  CV_BGR2HLS     52
        #define  CV_RGB2HLS     53
    
        #define  CV_HSV2BGR     54
        #define  CV_HSV2RGB     55
    
        #define  CV_Lab2BGR     56
        #define  CV_Lab2RGB     57
        #define  CV_Luv2BGR     58
        #define  CV_Luv2RGB     59
        #define  CV_HLS2BGR     60
        #define  CV_HLS2RGB     61
    
        #define  CV_COLORCVT_MAX  100
        
        cvCvtColor: "cvCvtColor" [
        "Converts input array pixels from one color space to another "
            src 			[CvArr!]
            dst 			[CvArr!]
            code			[integer!]
        ]
        
        #define  CV_INTER_NN        0
        #define  CV_INTER_LINEAR    1
        #define  CV_INTER_CUBIC     2
        #define  CV_INTER_AREA      3

        #define  CV_WARP_FILL_OUTLIERS 8
        #define  CV_WARP_INVERSE_MAP  16
        
        cvResize: "cvResize" [
        "Resizes image (input array is resized to fit the destination array) "
            src 			    [CvArr!]
            dst 			    [CvArr!]
            interpolation	            [integer!] ;CV_DEFAULT( CV_INTER_LINEAR ))
        ]
        cvWarpAffine: "cvWarpAffine"[
        "Warps image with affine transform"
            src 			[CvArr!]
            dst 			[CvArr!]
            map_matrix		        [CvMat!]
            flags			[integer!] ;CV_DEFAULT(CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS)
            b				[float!]  ; a CvScalar
            g				[float!]
            r				[float!]
            a				[float!] ;CV_DEFAULT(cvScalarAll(0))
        ]
        
        cvGetAffineTransform: "cvGetAffineTransform" [
        "computes affine transform matrix for mapping src[i] to dst[i] (i=0,1,2) "
            *src 			[CvPoint2D32f!] ; pointer
            *dst 			[CvPoint2D32f!] ; idem
            map_matrix		        [CvMat!]
            return:			[CvMat!]
        ]
        
        cv2DRotationMatrix: "cv2DRotationMatrix" [
        "Computes rotation_matrix matrix"
            x                           [integer!] ;CvPoint2D32f! x
            y                           [integer!] ;CvPoint2D32f! y
            angle 			[float!]
            scale			[float!]
            map_matrix		        [CvMat!]
            return:			[CvMat!]
        ]
        cvWarpPerspective: "cvWarpPerspective" [
        "Warps image with perspective (projective) transform"
            src 			[CvArr!]
            dst 			[CvArr!]
            map_matrix		        [CvMat!]
            flags			[integer!] ;CV_DEFAULT(CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS)
            b				[float!]  ;  fillval a CvScalar CV_DEFAULT(cvScalarAll(0))
            g				[float!]
            r				[float!]
            a				[float!]
        ]
        
        cvGetPerspectiveTransform: "cvGetPerspectiveTransform" [
        "Computes perspective transform matrix for mapping src[i] to dst[i] (i=0,1,2,3)"
            src 			[CvPoint2D32f!]
            dest 			[CvPoint2D32f!]
            map_matrix		        [CvMat!]
            return:			[CvMat!]
        ]
        
        cvRemap: "cvRemap" [
        "Performs generic geometric transformation using the specified coordinate maps "
            src 			[CvArr!]
            dst 			[CvArr!]
            mapx			[CvArr!]
            mapy			[CvArr!]
            flags			[integer!] ;CV_DEFAULT(CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS)
            b				[float!]  ;  fillval a CvScalar CV_DEFAULT(cvScalarAll(0))
            g				[float!]
            r				[float!]
            a				[float!]
        ]
        
        cvLogPolar: "cvLogPolar" [
        "Performs forward or inverse log-polar image transform"
            src 			[CvArr!]
            dest 			[CvArr!]
            x                           [integer!] ;CvPoint2D32f! x center
            y                           [integer!] ;CvPoint2D32f! y center
            m				[float!]
            flags			[integer!] ;CV_DEFAULT(CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS)
        ]
        
        #define  CV_SHAPE_RECT          0
        #define  CV_SHAPE_CROSS         1
        #define  CV_SHAPE_ELLIPSE       2
        #define  CV_SHAPE_CUSTOM        100
        
        cvCreateStructuringElementEx: "cvCreateStructuringElementEx" [
        "creates structuring element used for morphological operations"
            cols		        [integer!]
            rows		        [integer!]
            anchor_x	                [integer!]
            anchor_y	                [integer!]
            shapes		        [integer!]
            *values		        [int-ptr!] ; pointer to values CV_DEFAULT(NULL)
            return:		        [IplConvKernel!]
        ]
        
        
        cvReleaseStructuringElement: "cvReleaseStructuringElement" [
        "releases structuring element"
            **element		[double-byte-ptr!] ; double pointer IplConvKernel
        ]
        
        cvErode: "cvErode" [
        "erodes input image (applies minimum filter) one or more times. If element pointer is NULL, 3x3 rectangular element is used"
            src 			[CvArr!]
            dest 			[CvArr!]
            *element			[IplConvKernel!] ;CV_DEFAULT(NULL)
            iterations		        [integer!] ;CV_DEFAULT(1)
        ]
        
        cvDilate: "cvDilate" [
        "dilates input image (applies maximum filter) one or more times. If element pointer is NULL, 3x3 rectangular element is used "
            src 			[CvArr!]
            dest 			[CvArr!]
            *element			[IplConvKernel!] ;pointer CV_DEFAULT(NULL)
            iterations		        [integer!] ;CV_DEFAULT(1)
        ]
        
        #define CV_MOP_OPEN         2
        #define CV_MOP_CLOSE        3
        #define CV_MOP_GRADIENT     4
        #define CV_MOP_TOPHAT       5
        #define CV_MOP_BLACKHAT     6
        
        cvMorphologyEx: "cvMorphologyEx" [
        "Performs complex morphological transformation"
            src 			[CvArr!]
            dest 			[CvArr!]
            temp 			[CvArr!]
            *element			[IplConvKernel!] ;pointer CV_DEFAULT(NULL)
            operation		        [integer!] ;CV_DEFAULT(1)
            iterations		        [integer!] ;CV_DEFAULT(1)
        ]
        
        cvMoments: "cvMoments" [
        "Calculates all spatial and central moments up to the 3rd order"
            arr 			[CvArr!]
            moments 		        [CvMoments!]
            binary			[integer!] ;CV_DEFAULT(0)
        ]
        
        cvGetSpatialMoment: "cvGetSpatialMoment" [
        "Retrieve particular spatial moments "
            moments 		        [CvMoments!]
            x_order			[integer!] 
            y_order			[integer!] 
            return:			[float!]
        ]
        
        cvGetCentralMoment: "cvGetCentralMoment" [
        "Retrieve particular central moments "
            moments 		        [CvMoments!]
            x_order			[integer!] 
            y_order			[integer!] 
            return:			[float!]
        ]
        cvGetNormalizedCentralMoment: "cvGetNormalizedCentralMoment" [
        "Retrieve particular normalized central moments  "
            moments 		        [CvMoments!]
            x_order			[integer!] 
            y_order			[integer!] 
            return:			[float!]
        ]
        
        cvGetHuMoments: "cvGetHuMoments" [
        "Calculates 7 Hu's invariants from precalculated spatial and central moments"
            moments 		    [CvMoments!]
            hu_moments 		    [CvMoments!]
        ]
        
        ;/*********************************** data sampling **************************************/

        cvSampleLine: "cvSampleLine" [
        "Fetches pixels that belong to the specified line segment and stores them to the buffer. Returns the number of retrieved points."
            image 			[CvArr!]
            pt1_x	 		[integer!];CvPoint
            pt1_y	 		[integer!];CvPoint
            pt2_x	 		[integer!];CvPoint
            pt2_y	 		[integer!];CvPoint
            void*	 		[byte-ptr!] ; pointer
            connectivity	        [integer!] ;CV_DEFAULT(8)
            return:			[integer!]
        ]
        
        cvGetRectSubPix: "cvGetRectSubPix" [
        {Retrieves the rectangular image region with specified center from the input array.
        dst(x,y) <- src(x + center.x - dst_width/2, y + center.y - dst_height/2).
        Values of pixels with fractional coordinates are retrieved using bilinear interpolation}
            src 			[CvArr!]
            dst 			[CvArr!]
            x                           [integer!] ;CvPoint2D32f! x center
            y                           [integer!] ;CvPoint2D32f! y center
        ]
        
        cvGetQuadrangleSubPix: "cvGetQuadrangleSubPix" [
        {Retrieves quadrangle from the input array. matrixarr = ( a11  a12 | b1 )   dst(x,y) <- src(A[x y]' + b)
        ( a21  a22 | b2 )   (bilinear interpolation is used to retrieve pixels with fractional coordinates)}
            src 			[CvArr!]
            dst 			[CvArr!]
            map_matrix 		        [CvArr!]
        ]
        
        ;Methods for comparing two array
        #define  CV_TM_SQDIFF        0
        #define  CV_TM_SQDIFF_NORMED 1
        #define  CV_TM_CCORR         2
        #define  CV_TM_CCORR_NORMED  3
        #define  CV_TM_CCOEFF        4
        #define  CV_TM_CCOEFF_NORMED 5
        
        cvMatchTemplate: "cvMatchTemplate" [
        "Measures similarity between template and overlapped windows in the source image and fills the resultant image with the measurements "
            image 			[CvArr!]
            temp1 			[CvArr!]
            result	 		[CvArr!]
            method			[integer!]
        ]
        
        cvCalcEMD2: "cvCalcEMD2" [
        "Computes earth mover distance between two weighted point sets (called signatures)"
            signature1 			[CvArr!]
            signature2 			[CvArr!]
            distance_type		[integer!]
            distance_func 		[CvDistanceFunction!] ; pointer CV_DEFAULT(NULL) to CvDistanceFunction A REVOIR
            cost_matrix	 		[CvArr!]; CV_DEFAULT(NULL)
            flow			[CvArr!]; CV_DEFAULT(NULL)
            lower_bound			[float!];  CV_DEFAULT(NULL)
            *userdata			[byte-ptr!]; null pointer CV_DEFAULT(NULL));
        ]
        ;*******************************Contours retrieving**********************************************
        cvFindContours:"cvFindContours" [
        "Retrieves outer and optionally inner boundaries of white (non-zero) connected components in the black (zero) background"
            image 			[CvArr!]
            storage 		        [CvMemStorage!]
            first_contour	        [CvSeq**] ; double pointer to CvSeq
            header_size		        [integer!];CV_DEFAULT(sizeof(CvContour))
            mode			[integer!];CV_DEFAULT(CV_RETR_LIST)
            method			[integer!];CV_DEFAULT(CV_CHAIN_APPROX_SIMPLE)
            offset_x		        [integer!]; cvPoint CV_DEFAULT(cvPoint(0,0))
            offset_y		        [integer!];cvPoint CV_DEFAULT(cvPoint(0,0))
            return: 		        [integer!]
        ]
        
        cvStartFindContours: "cvStartFindContours" [
        {Initalizes contour retrieving process. Calls cvStartFindContours.
        Calls cvFindNextContour until null pointer is returned or some other condition becomes true.
        Calls cvEndFindContours at the end.}
            image 			[CvArr!]
            storage 		        [CvMemStorage!]
            header_size		        [integer!];CV_DEFAULT(sizeof(CvContour))
            mode			[integer!];CV_DEFAULT(CV_RETR_LIST)
            method			[integer!];CV_DEFAULT(CV_CHAIN_APPROX_SIMPLE)
            offset_x		        [integer!]; cvPoint CV_DEFAULT(cvPoint(0,0))
            offset_y		        [integer!];cvPoint CV_DEFAULT(cvPoint(0,0))
            return: 		        [integer!]; pointer to CvContourScanner
        ]
        
        cvFindNextContour: "cvFindNextContour" [
        "Retrieves next contour"
	    scanner                     [CvContourScanner!]; CvContourScanner
	    return:                     [CvSeq!]	
        ]
        
        cvSubstituteContour: "cvSubstituteContour" [
        "Substitutes the last retrieved contour with the new one  (if the substitutor is null, the last retrieved contour is removed from the tree)"
	    scanner                     [CvContourScanner!]; CvContourScanner
	    new_contour                 [CvSeq!]	
        ]
        
        cvEndFindContours: "cvEndFindContours"  [
        "Releases contour scanner and returns pointer to the first outer contour"
	    scanner                     [CvContourScanner!]; CvContourScanner
	    return:                     [CvSeq!]	
        ]
        
        cvApproxChains: "cvApproxChains" [
        "Approximates a single Freeman chain or a tree of chains to polygonal curves"
            src_seq			[CvSeq!]
            storage			[CvMemStorage!]
            method			[integer!];CV_DEFAULT(0)
            parameter			[float!];CV_DEFAULT(0)
            minimal_perimeter	        [integer!];CV_DEFAULT(0)
            recursive			[integer!];CV_DEFAULT(0)
            return:                     [CvSeq!]	
        ]
        
        cvStartReadChainPoints: "cvStartReadChainPoints"  [
        {Initalizes Freeman chain reader.
        The reader is used to iteratively get coordinates of all the chain points.
        If the Freeman codes should be read as is, a simple sequence reader should be used}
            chain		        [CvChain!]
            reader		        [CvChainPtReader!]
        ]
        
        cvReadChainPoint: "cvReadChainPoint" [
        "Retrieves the next chain point"
            reader		    [CvChainPtReader!]
            return		    [CvPoint!]
        ]
        
        ;*                                  Motion Analysis                                       *
        ;************************************ optical flow ***************************************
        cvCalcOpticalFlowLK: "cvCalcOpticalFlowLK" [
        "Calculates optical flow for 2 images using classical Lucas & Kanade algorithm "
            prev                    [CvArr!]
            curr                    [CvArr!]
            win_width               [integer!] ;_CvSize
            win_height              [integer!] ;_CvSize
            velx                    [CvArr!]
            vely                    [CvArr!]
        ]
        
        cvCalcOpticalFlowBM: "cvCalcOpticalFlowBM" [
        "Calculates optical flow for 2 images using block matching algorithm "
            prev                    [CvArr!]
            curr                    [CvArr!]
            win_width               [integer!] ;_CvSize
            win_height              [integer!] ;_CvSize
            shift_width             [integer!] ;_CvSize
            shift_height            [integer!] ;_CvSize
            max_width               [integer!] ;_CvSize
            max_height              [integer!] ;_CvSize
            use_previous            [integer!]
            velx                    [CvArr!]
            vely                    [CvArr!]
        ]
        
        cvCalcOpticalFlowHS: "cvCalcOpticalFlowHS" [
        "Calculates Optical flow for 2 images using Horn & Schunck algorithm"
            prev                    [CvArr!]
            curr                    [CvArr!]
            use_previous            [integer!]
            velx                    [CvArr!]
            vely                    [CvArr!]
            lambda                  [float!]
            criteria                [CvTermCriteria!]
        ]
        #define  CV_LKFLOW_PYR_A_READY       1
        #define  CV_LKFLOW_PYR_B_READY       2
        #define  CV_LKFLOW_INITIAL_GUESSES   4
        
        cvCalcOpticalFlowPyrLK: "cvCalcOpticalFlowPyrLK" [
        "It is Lucas & Kanade method, modified to use pyramids"
            prev                    [CvArr!]
            curr                    [CvArr!]
            prev_features           [CvPoint2D32f!] ; *pointer 
            curr_features           [CvPoint2D32f!] ;*pointer 
            count                   [integer!]
            win_width               [integer!] ;_CvSize
            win_height              [integer!] ;_CvSize
            level                   [integer!]
            status                  [c-string!]
            track_error             [float-ptr!] ; pointer
            criteria                [CvTermCriteria!]
            flags                   [integer!]
        ]
        
        cvCalcAffineFlowPyrLK: "cvCalcAffineFlowPyrLK" [
        "Modification of a previous sparse optical flow algorithm to calculate affine flow "
            prev                    [CvArr!]
            curr                    [CvArr!]
            prev_pyr                [CvArr!]
            curr_pyr                [CvArr!]
            prev_features           [CvPoint2D32f!] ; *pointer 
            curr_features           [CvPoint2D32f!] ;*pointer 
            matrices                [float-ptr!]
            count                   [integer!]
            win_width               [integer!] ;_CvSize
            win_height              [integer!] ;_CvSize
            level                   [integer!]
            status                  [c-string!]
            track_error             [float-ptr!] ; pointer
            criteria                [CvTermCriteria!]
            flags                   [integer!]
        ]
        
        cvEstimateRigidTransform: "cvEstimateRigidTransform" [
        "Estimate rigid transformation between 2 images or 2 point sets"
            A                       [cvArr!]
            B                       [cvArr!]
            M                       [cvArr!]
            full_affine             [integer!]
            return:                 [integer!]
        ]
        
        ;******************************** motion templates *************************************/

        ;/****************************************************************************************\
        ;*        All the motion template functions work only with single channel images.         *
        ;*        Silhouette image must have depth IPL_DEPTH_8U or IPL_DEPTH_8S                   *
        ;*        Motion history image must have depth IPL_DEPTH_32F,                             *
        ;*        Gradient mask - IPL_DEPTH_8U or IPL_DEPTH_8S,                                   *
        ;*        Motion orientation image - IPL_DEPTH_32F                                        *
        ;*        Segmentation mask - IPL_DEPTH_32F                                               *
        ;*        All the angles are in degrees, all the times are in milliseconds                *
        ;\****************************************************************************************/
        
        cvUpdateMotionHistory: "cvUpdateMotionHistory" [
        "Updates motion history image given motion silhouette"
            silhouette              [cvArr!]
            mhi                     [cvArr!]
            timestamp               [float!]
            duration                [float!]
        ]
        
        cvCalcMotionGradient: "cvCalcMotionGradient" [
        "Calculates gradient of the motion history image and fills a mask indicating where the gradient is valid "
            mhi                     [cvArr!]
            mask                    [cvArr!]
            orientation             [cvArr!]
            delta1                  [float!]
            delta2                  [float!]
            aperture_size           [integer!] ;CV_DEFAULT(3))
        ]
        
        cvCalcGlobalOrientation: "cvCalcGlobalOrientation" [
        {Calculates average motion direction within a selected motion region 
        (region can be selected by setting ROIs and/or by composing a valid gradient mask
         with the region mask) }
            orientation             [cvArr!]
            mask                    [cvArr!]
            mhi                     [cvArr!]
            timestamp               [float!]
            duration                [float!]
            return:                 [float!]
        ]
        cvSegmentMotion: "cvSegmentMotion" [
        "Splits a motion history image into a few parts corresponding to separate independent motions (e.g. left hand, right hand)"
            mhi                     [cvArr!]
            seg_mask                [cvArr!]
            storage                 [CvMemStorage!]
            timestamp               [float!]
            seg_thresh              [float!]
            return:                 [CvSeq!] ; a pointer to CvSeq
        ]
        
        ;*********************** Background statistics accumulation *****************************/
        cvAcc: "cvAcc" [
        "Adds image to accumulator"
            image                   [cvArr!]
            sum                     [cvArr!]
            mask                    [cvArr!] ; CV_DEFAULT(NULL))
        ]
        
        cvSquareAcc: "cvSquareAcc" [
        "Adds squared image to accumulator"
            image                   [cvArr!]
            sqsum                   [cvArr!]
            mask                    [cvArr!] ; CV_DEFAULT(NULL))
        ]
        
        cvMultiplyAcc: "cvMultiplyAcc" [
        "Adds a product of two images to accumulator"
            image1                  [cvArr!]
            image2                  [cvArr!]
            acc                     [cvArr!]
            mask                    [cvArr!] ; CV_DEFAULT(NULL))
        ]
        
        cvRunningAvg: "cvRunningAvg" [
        "Adds image to accumulator with weights: acc = acc*(1-alpha) + image*alpha "
            image                   [cvArr!]
            acc                     [cvArr!]
            alpha                   [float!]
            mask                    [cvArr!] ; CV_DEFAULT(NULL))
        ]
        
        ;******************************** Tracking ********************************
        cvCamShift: "cvCamShift" [
        "Implements CAMSHIFT algorithm - determines object position, size and orientation from the object histogram back project (extension of meanshift)"
            prob_image              [cvArr!]
            window_x                [integer!] ;_CvRect
            window_y                [integer!]
            window_w                [integer!]
            window_h                [integer!]
            criteria                [CvTermCriteria!]
            comp                    [CvConnectedComp!]
            *box                    [CvBox2D!] ; pointer CV_DEFAULT(NULL)
            return:                 [integer!]
        ]
        
        cvMeanShift: "cvMeanShift" [
        "mplements MeanShift algorithm - determines object position from the object histogram back project"
            prob_image              [cvArr!]
            window_x                [integer!] ;_CvRect
            window_y                [integer!]
            window_w                [integer!]
            window_h                [integer!]
            criteria                [CvTermCriteria!]
            comp                    [CvConnectedComp!]
            return:                 [integer!]
        ]
        
        cvCreateConDensation: "cvCreateConDensation" [
        "Creates ConDensation filter state"
            dynam_params            [integer!]
            measure_params          [integer!]
            sample_count            [integer!]
            return:                 [CvConDensation!]     
        ]
        
        cvReleaseConDensation: "cvReleaseConDensation" [
        "Releases ConDensation filter state"
            **condens               [double-byte-ptr!]   
        ]
        
        cvConDensUpdateByTime: "cvConDensUpdateByTime" [
        "Updates ConDensation filter by time (predict future state of the system)"
            *condens               [CvConDensation!]   ; pointer 
        ]
        
        cvConDensInitSampleSet: "cvConDensInitSampleSet" [
        "Updates ConDensation filter by time (predict future state of the system)"
            condens                 [CvConDensation!] 
            lower_bound             [CvMat!]
            upper_bound             [CvMat!]
        ]
        
        cvCreateKalman: "cvCreateKalman" [
        "Creates Kalman filter and sets A, B, Q, R and state to some initial values"
            dynam_params            [integer!]
            measure_params          [integer!]
            control_params          [integer!] ;CV_DEFAULT(0)
            return:                 [CvKalman!]
        ]
        
        cvReleaseKalman: "cvReleaseKalman" [
        "Releases Kalman filter state"
            kalman                  [double-byte-ptr!]  
        ]
        
        cvKalmanPredict: "cvKalmanPredict" [
        "Updates Kalman filter by time (predicts future state of the system)"
            kalman                  [CvKalman!]
            control                 [CvMat!] ;CV_DEFAULT(NULL)
            return:                 [CvMat!]
        ]
        
        cvKalmanCorrect: "cvKalmanCorrect" [
        "pdates Kalman filter by measurement (corrects state of the system and internal matrices)"
            kalman                  [CvKalman!]
            measurement             [CvMat!] ;CV_DEFAULT(NULL)
            return:                 [CvMat!]
        ]
        
        ;********************************Planar subdivisions *************************
        cvInitSubdivDelaunay2D: "cvInitSubdivDelaunay2D" [
        "Initializes Delaunay triangulation"
            subdiv                  [CvSubdiv2D!]
            rect_x                  [integer!] ;_CvRect
            rect_y                  [integer!]
            rect_w                  [integer!]
            rect_h                  [integer!]
        ]
        
        cvCreateSubdiv2D: "cvCreateSubdiv2D" [
        "Creates new subdivision"
            subdiv_type             [integer!]
            header_size             [integer!]
            vtx_size                [integer!]
            uadedge_size            [integer!]
            storage                 [CvMemStorage!]
            return:                 [CvSubdiv2D!]
        ]
        
        ;/************************* high-level subdivision functions ***************************/
        cvSubdivDelaunay2DInsert: "cvSubdivDelaunay2DInsert" [
        "Inserts new point to the Delaunay triangulation"
            subdiv                  [CvSubdiv2D!]
            pt_x                    [float!] ;_CvPoint2D32f
            pt_y                    [float!]
            return:                 [CvSubdiv2DPoint!]
        ]
        
        cvSubdiv2DLocate: "cvSubdiv2DLocate" [
        "Locates a point within the Delaunay triangulation (finds the edgethe point is left to or belongs to, or the triangulation point the given point coinsides with"
            subdiv                  [CvSubdiv2D!]
            pt_x                    [float!] ;_CvPoint2D32f
            pt_y                    [float!]
            edge                    [CvSubdiv2DPoint!]
            vertex                  [double-byte-ptr!] ;CvSubdiv2DPoint**  CV_DEFAULT(NULL)
            return:                 [CvSubdiv2DPointLocation!]
        ]
        
        cvCalcSubdivVoronoi2D: "cvCalcSubdivVoronoi2D" [
        "Calculates Voronoi tesselation (i.e. coordinates of Voronoi points) "
            subdiv                  [CvSubdiv2D!]
        ]
        
        cvClearSubdivVoronoi2D: "cvClearSubdivVoronoi2D" [
        "Removes all Voronoi points from the tesselation "
            subdiv                  [CvSubdiv2D!]
        ]
        
        cvFindNearestPoint2D: "cvFindNearestPoint2D" [
        "Finds the nearest to the given point vertex in subdivision."
            subdiv                  [CvSubdiv2D!]
            pt_x                    [float!] ;_CvPoint2D32f
            pt_y                    [float!]
            return:                 [CvSubdiv2DPointLocation!]  
        ]
        
        ;*************************** Contour Processing and Shape Analysis *************************
        #define CV_POLY_APPROX_DP 0
        
        cvApproxPoly: "cvApproxPoly" [
        "Approximates a single polygonal curve (contour) or a tree of polygonal curves (contours)"
            src_seq                     [byte-ptr!] ;void*
            header_size                 [integer!]
            storage                     [CvMemStorage!]
            method                      [integer!]
            parameter                   [float!]
            parameter2                  [integer!] ;CV_DEFAULT(0)
            return:                     [CvSeq!]
        ]
        ;#define CV_DOMINANT_IPAN 1
        cvFindDominantPoints: "cvFindDominantPoints" [
        "Finds high-curvature points of the contour"
            contour                     [CvSeq!]
            storage                     [CvMemStorage!]
            parameter1                  [float!] ;CV_DEFAULT(0)
            parameter2                  [float!] ;CV_DEFAULT(0)
            parameter3                  [float!] ;CV_DEFAULT(0)
            parameter4                  [float!] ;CV_DEFAULT(0)
            return:                     [CvSeq!] ;CV_DEFAULT(0)
        ]
        
        cvArcLength: "cvArcLength" [
        "Calculates perimeter of a contour or length of a part of contour"
            curve                       [byte-ptr!] ;void*
            slice_start_index           [integer!]; _CvSlice  ;CV_DEFAULT(CV_WHOLE_SEQ)
            slice_end_index             [integer!]
            is_closed                   [integer!]   ; CV_DEFAULT(-1)
            return:                     [float!]
        ]
        #define cvContourPerimeter (contour) [cvArcLength contour CV_WHOLE_SEQ 1]
        
        cvBoundingRect: "cvBoundingRect" [
        "Calculates contour boundning rectangle (update=1) or just retrieves pre-calculated rectangle (update=0)"
            points                      [CvArr!]
            update                      [integer!] ;CV_DEFAULT(0)
            return:                     [CvRect!] ; may be problematic 
        ]
        cvContourArea: "cvContourArea" [
        "Calculates area of a contour or contour segment"
            points                      [CvArr!]
            slice_start_index           [integer!] ;_CvSlice CV_DEFAULT(CV_WHOLE_SEQ))
            slice_end_index             [integer!] ;_CvSlice CV_DEFAULT(CV_WHOLE_SEQ))
            return:                     [float!]
        ]
        cvMinAreaRect2: "cvMinAreaRect2" [
        "Finds minimum area rotated rectangle bounding a set of points"
             points                      [CvArr!]
             storage                     [CvMemStorage!] ;CV_DEFAULT(NULL)
             return:                     [CvBox2D!]
        ]
        
        cvMinEnclosingCircle: "cvMinEnclosingCircle" [
        "Finds minimum enclosing circle for a set of points"
            points                      [CvArr!]
            center                      [CvPoint2D32f!] ;* pointer
            radius                      [float-ptr!]
            return:                     [integer!]
        ]
        #define CV_CONTOURS_MATCH_I1  1
        #define CV_CONTOURS_MATCH_I2  2
        #define CV_CONTOURS_MATCH_I3  3
        
        cvMatchShapes: "cvMatchShapes" [
        "Compares two contours by matching their moments"
            object1                     [byte-ptr!]
            object2                     [byte-ptr!]
            method                      [integer!]
            parameter                   [float!]
            return:                     [float!]
        ]
        
        cvCreateContourTree: "cvCreateContourTree" [
        "Builds hierarhical representation of a contour"  
            contour                     [CvSeq!]
            storage                     [CvMemStorage!]
            threshold                   [float!]
            return:                     [CvContourTree!]           
        ]
        
        cvContourFromContourTree: "cvContourFromContourTree" [
        "Reconstruct (completelly or partially) contour a from contour tree"
            tree                        [CvContourTree!]
            storage                     [CvMemStorage!]
            criteria_type               [integer!] ; CvCriteria not pointed
            criteria_max_iter           [integer!]
            ctriteria_epsilon           [float!]
            return:                     [CvSeq!]
        ]
        
        #define  CV_CONTOUR_TREES_MATCH_I1  1
        cvMatchContourTrees: "cvMatchContourTrees" [
        "Compares two contour trees"
            tree1                       [CvContourTree!]
            tree2                       [CvContourTree!]
            method                      [integer!]
            threshold                   [float!]
            return:                     [float!]
        ]
        
        cvCalcPGH: "cvCalcPGH" [
        "Calculates histogram of a contour"
            contour                     [CvSeq!]
            hist                        [CvHistogram!]
        ]
        
        #define CV_CLOCKWISE         1
        #define CV_COUNTER_CLOCKWISE 2
        
        cvConvexHull2: "cvConvexHull2" [
        "Calculates exact convex hull of 2d point set"
            input                       [CvArr!]
            hull_storage                [byte-ptr!] ; void * ;CV_DEFAULT(NULL)
            orientation                 [integer!]  ;CV_DEFAULT(CV_CLOCKWISE)
            return_points               [integer!]   ;CV_DEFAULT(0)
            return:                     [CvSeq!]
        ]
        
        cvCheckContourConvexity: "cvCheckContourConvexity" [
        "Checks whether the contour is convex or not (returns 1 if convex, 0 if not)"
            contour                       [CvArr!]
            return:                       [integer!]
        ]
        
        cvConvexityDefects: "cvConvexityDefects" [
            contour                       [CvArr!]
            convexhull                    [CvArr!]
            storage                       [CvMemStorage!] ;CV_DEFAULT(NULL)
            return:                       [CvSeq!]
        ]
        
        cvFitEllipse2: "cvFitEllipse2" [
        "Fits ellipse into a set of 2d points"
            points                       [CvArr!]
            return:                      [CvBox2D!] ; may be problematic
        ]
        
        cvMaxRect: "cvMaxRect" [
            rect1                       [CvRect!]
            rect2                       [CvRect!]
            return:                     [CvRect!] ; may be problematic
        ]
        
        cvBoxPoints: "cvBoxPoints" [
        "Finds coordinates of the box vertices "
            box_center_x                    [float32!]  ;CvBox2D
            box_center_y                    [float32!]  ;CvBox2D
            box_size_width                  [float32!]  ;CvBox2D
            box_size_height                 [float32!]  ;CvBox2D
            box_angle                       [float32!]  ;CvBox2D
            pt_4                            [pointer! [float32!]] ; pointeur array 4 float32
        ]
        
        cvPointSeqFromMat: "cvPointSeqFromMat" [
        "Initializes sequence header for a matrix (column or row vector) of points - a wrapper for cvMakeSeqHeaderForArray (it does not initialize bounding rectangle!!!)"
            seq_kind                        [integer!]
            mat                             [CvArr!]
            contour_header                  [CvContour!]
            block                           [CvSeqBlock!]
            return:                         [CvSeq!]
        ]
        
        cvPointPolygonTest: "cvPointPolygonTest" [
            
            contour                         [CvArr!]
            pt_x                            [float32!]
            pt_y                            [float32!]
            measure_dist                    [integer!]
            return:                         [float!]
        ]
        
        ;*********************************** Histogram functions ****************************
         cvCreateHist: "cvCreateHist" [
        "Creates new histogram"
            dims                            [integer!]
            sizes                           [pointer![integer!]]
            type                            [integer!]
            ranges                          [double-float-ptr!] ; ** float CV_DEFAULT(NULL)
            uniform                         [integer!]          ;CV_DEFAULT(1)
            return:                         [CvHistogram!]
        ]
        
        cvSetHistBinRanges: "cvSetHistBinRanges" [
        "Assignes histogram bin ranges"
            hist                            [CvHistogram!]
            ranges                          [double-float-ptr!] ; **float
            uniform                         [integer!]          ;CV_DEFAULT(1)
        ]
        
        cvMakeHistHeaderForArray: "cvMakeHistHeaderForArray" [
        "Creates histogram header for array"
            dims                            [integer!]
            sizes                           [int-ptr!]
            data                            [float-ptr!]
            ranges                          [double-float-ptr!] ; ** float CV_DEFAULT(NULL)
            uniform                         [integer!]
            return:                         [CvHistogram!]
        ]
        
        cvReleaseHist: "cvReleaseHist" [
        "Releases histogram"
            CvHistogram                     [double-byte-ptr!]
        ]
        
        cvClearHist: "cvClearHist" [
            hist                            [CvHistogram!]
        ]
        
        cvGetMinMaxHistValue: "cvGetMinMaxHistValue" [
        "Finds indices and values of minimum and maximum histogram bins"
            hist                            [CvHistogram!]
            min_value                       [float-ptr!]
            max_value                       [float-ptr!]
            min_idx                         [int-ptr!] ;CV_DEFAULT(NULL)
            max_idx                         [int-ptr!] ;CV_DEFAULT(NULL)
        ]
        
        cvNormalizeHist: "cvNormalizeHist" [
        "Normalizes histogram by dividing all bins by sum of the bins, multiplied by <factor>. After that sum of histogram bins is equal to <factor>"
            hist                            [CvHistogram!]
            factor                          [float!]
        ]
        
        cvThreshHist: "cvThreshHist" [
        "Clear all histogram bins that are below the threshold"
            hist                            [CvHistogram!]
            threshold                       [float!]
            
        ]
        
        #define CV_COMP_CORREL              0
        #define CV_COMP_CHISQR              1
        #define CV_COMP_INTERSECT           2
        #define CV_COMP_BHATTACHARYYA       3
        
        cvCompareHist: "cvCompareHist" [
        "Compares two histogram"
            hist1                          [CvHistogram!]
            hist2                          [CvHistogram!]
            method                         [integer!]
            return:                        [float!]
        ]
        
        cvCopyHist: "cvCopyHist" [
        "Copies one histogram to another. Destination histogram is created if the destination pointer is NULL"
            src                          [CvHistogram!]
            dst                          [double-byte-ptr!] ;CvHistogram**
        ]
        
        cvCalcBayesianProb: "cvCalcBayesianProb" [
        "Calculates bayesian probabilistic histograms (each or src and dst is an array of <number> histograms"
            src                         [double-byte-ptr!] ;CvHistogram**
            number                      [integer!]
            dst                         [double-byte-ptr!] ;CvHistogram**
        ]
        
        cvCalcArrHist: "cvCalcArrHist" [
            arr                         [double-byte-ptr!] ; ** CvArr
            hist                        [CvHistogram!]
            accumulate                  [integer!]          ; CV_DEFAULT(0)
            mask                        [CvArr!]            ;CV_DEFAULT(NULL)
        ]
        
        cvCalcArrBackProject: "cvCalcArrBackProject" [
        "Calculates back project"
            image                       [double-byte-ptr!] ; ** CvArr
            dst                         [Cvarr!] ; * CvArr
            hist                        [CvHistogram!]
        ]
        
        #define  cvCalcBackProject(image dst hist) [(cvCalcArrBackProject image dst hist)]
        
        cvCalcArrBackProjectPatch: "cvCalcArrBackProjectPatch" [
        "Does some sort of template matching but compares histograms of template and each window location"
            image                       [double-byte-ptr!] ; ** CvArr
            dst                         [Cvarr!] ; * CvArr
            range_w                     [integer!] ; _CvSize
            range_h                     [integer!] ; _CvSize
            hist                        [CvHistogram!]
            method                      [integer!]
            factor                      [float!]
        ]
        
        #define  cvCalcBackProjectPatch (image dst range hist method factor) [
            (cvCalcArrBackProjectPatch image dst range hist method factor)    
        ]
        
        cvCalcProbDensity: "cvCalcProbDensity" [
        "calculates probabilistic density (divides one histogram by another)"
            hist1                          [CvHistogram!]
            hist2                          [CvHistogram!]
            dst_hist                       [CvHistogram!]
            scale                          [float!]
        ]
        
        cvEqualizeHist: "cvEqualizeHist" [
        "equalizes histogram of 8-bit single-channel image"
            src                             [CvArr!]
            dst                             [CvArr!]
        ]
        
        #define  CV_VALUE  1
        #define  CV_ARRAY  2
        
        cvSnakeImage: "cvSnakeImage" [
        "Updates active contour in order to minimize its cummulative (internal and external) energy."
            image                       [IplImage!]
            points                      [CvPoint!]
            length                      [integer!]
            alpha                       [float-ptr!]
            beta                        [float-ptr!]
            gamma                       [float-ptr!]
            coeff_usage                 [integer!]
            win_w                       [integer!] ; _CvSize
            win_h                       [integer!] ; _CvSize
            criteria                    [CvTermCriteria!]
            calc_gradient               [integer!]  ; CV_DEFAULT(1)
        ]
        
        cvCalcImageHomography: "cvCalcImageHomography" [
        "Calculates the cooficients of the homography matrix"
            line                        [float-ptr!]
            center                      [CvPoint3D32f!] ;* pointer
            intrinsic                   [float-ptr!]
            homography                  [float-ptr!]
        ]
        
        #define CV_DIST_MASK_3   3
        #define CV_DIST_MASK_5   5
        #define CV_DIST_MASK_PRECISE 0
        
        cvDistTransform: "cvDistTransform" [
        "Applies distance transform to binary image"
            src                 [CvArr!]
            dst                 [CvArr!]
            distance_type       [integer!] ; CV_DEFAULT(CV_DIST_L2)
            mask_size           [integer!] ; CV_DEFAULT(3)
            mask                [float-ptr!] ; CV_DEFAULT(NULL)
            labels              [CvArr!] ; CV_DEFAULT(NULL) 
        ]
        
        ; Types of thresholding 
        #define CV_THRESH_BINARY      0  ; value = value > threshold ? max_value : 0       
        #define CV_THRESH_BINARY_INV  1  ; value = value > threshold ? 0 : max_value       
        #define CV_THRESH_TRUNC       2  ; value = value > threshold ? threshold : value   
        #define CV_THRESH_TOZERO      3  ; value = value > threshold ? value : 0           
        #define CV_THRESH_TOZERO_INV  4  ; value = value > threshold ? 0 : value           
        #define CV_THRESH_MASK        7
        #define CV_THRESH_OTSU        8  ; use Otsu algorithm to choose the optimal threshold value; combine the flag with one of the above CV_THRESH_* values 

        cvThreshold: "cvThreshold" [
            src                 [CvArr!]
            dst                 [CvArr!]
            threshold           [float!]
            max_value           [float!]
            threshold_type      [integer!]
            return:             [float!] 
        ]
        
        #define CV_ADAPTIVE_THRESH_MEAN_C  0
        #define CV_ADAPTIVE_THRESH_GAUSSIAN_C  1
        
        ;Applies adaptive threshold to grayscale image.
        ;The two parameters for methods CV_ADAPTIVE_THRESH_MEAN_C and CV_ADAPTIVE_THRESH_GAUSSIAN_C are:
        ;neighborhood size (3, 5, 7 etc.), and a constant subtracted from mean (...,-3,-2,-1,0,1,2,3,...)
        
        cvAdaptiveThreshold: "cvAdaptiveThreshold" [
        "Applies adaptive threshold to grayscale image."
            src                 [CvArr!]
            dst                 [CvArr!]
            max_value           [float!]
            adaptive_method     [integer!]  ;CV_DEFAULT(CV_ADAPTIVE_THRESH_MEAN_C)
            threshold_type      [integer!]  ; CV_DEFAULT(CV_THRESH_BINARY)
            block_size          [integer!]  ; CV_DEFAULT(3)
            param1              [float!]    ; CV_DEFAULT(5))
        ]
        
        #define CV_FLOODFILL_FIXED_RANGE    [(1 << 16)]
        #define CV_FLOODFILL_MASK_ONLY      [(1 << 17)]
        
        cvFloodFill: "cvFloodFill" [
        "Fills the connected component until the color difference gets large enough"
            image               [CvArr!]
            seed_point_x        [integer!]
            seed_point_y        [integer!]
            new_val0            [float!]    ;CvScalar
            new_val1            [float!]    ;CvScalar
            new_val2            [float!]    ;CvScalar
            new_val3            [float!]    ;CvScalar
            lo_diff0            [float!]    ;CvScalar CV_DEFAULT(cvScalarAll(0))
            lo_diff1            [float!]    ;CvScalar CV_DEFAULT(cvScalarAll(0)
            lo_diff2            [float!]    ;CvScalar CV_DEFAULT(cvScalarAll(0)
            lo_diff3            [float!]    ;CvScalar CV_DEFAULT(cvScalarAll(0)
            up_diff0            [float!]    ;CvScalar CV_DEFAULT(cvScalarAll(0))
            up_diff1            [float!]    ;CvScalar CV_DEFAULT(cvScalarAll(0)
            up_diff2            [float!]    ;CvScalar CV_DEFAULT(cvScalarAll(0)
            up_diff3            [float!]    ;CvScalar CV_DEFAULT(cvScalarAll(0)
            comp                [CvConnectedComp!]
            flags               [integer!]  ;CV_DEFAULT(4)
            mask                [CvArr!]    ; CV_DEFAULT(NULL)  
        ]
        
        ;*********************** Feature detection  ***************************
        #define CV_CANNY_L2_GRADIENT  [(1 << 31)]
        
        cvCanny: "cvCanny" [
            image               [CvArr!]
            edges               [CvArr!]
            threshold1          [float!]
            threshold2          [float!]
            aperture_size       [integer!] ; CV_DEFAULT(3)
        ]
        
        ;Applying threshold to the result gives coordinates of corners
        cvPreCornerDetect: "cvPreCornerDetect" [
        "Calculates constraint image for corner detection Dx^2 * Dyy + Dxx * Dy^2 - 2 * Dx * Dy * Dxy."
            image               [CvArr!]
            edges               [CvArr!]
            aperture_size       [integer!] ; CV_DEFAULT(3)
        ]
        
        cvCornerEigenValsAndVecs: "cvCornerEigenValsAndVecs" [
        "Calculates eigen values and vectors of 2x2 gradient covariation matrix at every image pixel"
            image               [CvArr!]
            eigenvv             [CvArr!]
            block_size          [integer!]
            aperture_size       [integer!] ; CV_DEFAULT(3)
        ]
        cvCornerMinEigenVal: "cvCornerMinEigenVal" [
        "Calculates minimal eigenvalue for 2x2 gradient covariation matrix at every image pixel"
            image               [CvArr!]
            eigenval            [CvArr!]
            block_size          [integer!]
            aperture_size       [integer!] ; CV_DEFAULT(3)
        ]
        
        cvCornerHarris: "cvCornerHarris" [
        "Harris corner detector: Calculates det(M) - k*(trace(M)^2), where M is 2x2 gradient covariation matrix for each pixel"    
            image               [CvArr!]
            harris_responce     [CvArr!]
            block_size          [integer!]
            aperture_size       [integer!] ; CV_DEFAULT(3)
            k                   [float!]   ; CV_DEFAULT(0.04)
        ]
        
        cvFindCornerSubPix: "cvFindCornerSubPix" [
        "Adjust corner position using some sort of gradient search"
            image               [CvArr!]
            corners             [CvPoint2D32f!]
            count               [integer!]
            win_w               [integer!] ; CvSize
            win_h               [integer!] ; CvSize
            zero_zone_w         [integer!] ; CvSize
            zero_zone_h         [integer!] ; CvSize
            criteria            [CvTermCriteria!] 
        ]
        
        cvGoodFeaturesToTrack: "cvGoodFeaturesToTrack" [
        "Finds a sparse set of points within the selected region that seem to be easy to track"
            image               [CvArr!]
            eig_image           [CvArr!]
            temp_image          [CvArr!]
            corners             [CvPoint2D32f!]
            corner_count        [int-ptr!]
            quality_level       [float!]
            min_distance        [float!]
            mask                [CvArr!]   ;CV_DEFAULT(NULL)
            block_size          [integer!] ;CV_DEFAULT(3)
            use_harris          [integer!] ; CV_DEFAULT(0)
            k                   [float!]   ; CV_DEFAULT(0.04)
        ]
        
        #define CV_HOUGH_STANDARD 0
        #define CV_HOUGH_PROBABILISTIC 1
        #define CV_HOUGH_MULTI_SCALE 2
        #define CV_HOUGH_GRADIENT 3
        
        ;Finds lines on binary image using one of several methods.
        ;line_storage is either memory storage or 1 x <max number of lines> CvMat, its
        ;number of columns is changed by the function.
        ; method is one of CV_HOUGH_*;
        ;rho, theta and threshold are used for each of those methods;
        ;param1 ~ line length, param2 ~ line gap - for probabilistic,
        ;param1 ~ srn, param2 ~ stn - for multi-scale
        
        cvHoughLines2: "cvHoughLines2" [
        "Finds lines on binary image using one of several methods"
            image               [CvArr!]
            line_storage        [byte-ptr!] ;*void
            method              [integer!]
            rho                 [float!]
            theta               [float!]
            threshold           [integer!]
            param1              [float!] ; CV_DEFAULT(0)
            param2              [float!] ; CV_DEFAULT(0)
            return:             [CvSeq!]
        ]
        
        cvHoughCircles: "cvHoughCircles" [
        "Finds circles in the image"
            image               [CvArr!]
            circle_storage      [byte-ptr!] ;*void
            method              [integer!]
            dp                  [float!]
            min_dist            [float!]
            param1              [float!] ; CV_DEFAULT(100)
            param2              [float!] ; CV_DEFAULT(100)
            min_radius          [integer!] ; CV_DEFAULT(0)
            max_radius          [integer!]
            return:             [CvSeq!]
        ]
        
        cvFitLine: "cvFitLine" [
        "Fits a line into set of 2d or 3d points in a robust way (M-estimator technique)"
            points              [CvArr!]
            dist_type           [integer!]
            param               [float!]
            reps                [float!]
            aeps                [float!]
            line                [float-ptr!]
        ]
        
        ;********************** Haar-like Object Detection functions ************************
        
        ;It is obsolete: convert your cascade to xml and use cvLoad instead
        cvLoadHaarClassifierCascade: "cvLoadHaarClassifierCascade" [
        "Loads haar classifier cascade from a directory."
            directory           [c-string!]
            orig_window_size_x  [integer!]  ;CvSize
            orig_window_size_y  [integer!]  ;CvSize
            return:             [CvHaarClassifierCascade!]
        ]
        cvReleaseHaarClassifierCascade: "cvReleaseHaarClassifierCascade" [
            cascade             [double-byte-ptr!]   ;CvHaarClassifierCascade** 
        ]
        
        #define CV_HAAR_DO_CANNY_PRUNING    1
        #define CV_HAAR_SCALE_IMAGE         2
        #define CV_HAAR_FIND_BIGGEST_OBJECT 4 
        #define CV_HAAR_DO_ROUGH_SEARCH     8
        
        cvHaarDetectObjects: "cvHaarDetectObjects" [
            image               [CvArr!]
            cascade             [CvHaarClassifierCascade!]
            storage             [CvMemStorage!]
            scale_factor        [float!]  ;CV_DEFAULT(1.1)
            min_neighbors       [integer!] ; CV_DEFAULT(3)
            flags               [integer!]  ;CV_DEFAULT(0)
            min_size_w          [integer!]  ; CvSize CV_DEFAULT(cvSize(0,0))
            min_size_h          [integer!]  ; CvSize CV_DEFAULT(cvSize(0,0))
            return:             [CvSeq!]
        ]
        
        cvSetImagesForHaarClassifierCascade: "cvSetImagesForHaarClassifierCascade" [
        "sets images for haar classifier cascade"
            cascade             [CvHaarClassifierCascade!]
            sum                 [CvArr!]
            squm                [CvArr!]
            tilted_sum          [CvArr!]
            scale               [float!]
        ]
        
        cvRunHaarClassifierCascade: "cvRunHaarClassifierCascade" [
        "runs the cascade on the specified window "
            cascade             [CvHaarClassifierCascade!]
            pt_x                [integer!] ; CvPoint
            pt_y                [integer!] ; CvPoint
            start_stage         [integer!] ; CV_DEFAULT(0)
            return:             [integer!]
        ]
        
        ;******************** Camera Calibration and Rectification functions ***************
        cvUndistort2: "cvUndistort2" [
        "transforms the input image to compensate lens distortion"
            src                     [CvArr!]
            dst                     [CvArr!]
            intrinsic_matrix        [CvMat!]
            distortion_coeffs       [CvMat!]
        ]
        
        cvInitUndistortMap: "cvInitUndistortMap" [
        "computes transformation map from intrinsic camera parameters that can used by cvRemap"
            intrinsic_matrix        [CvMat!]
            distortion_coeffs       [CvMat!]
            mapx                    [CvArr!]
            mapy                    [CvArr!]
        ]
        
        cvRodrigues2: "cvRodrigues2" [
        "converts rotation vector to rotation matrix or vice versa"
            src                     [CvArr!]
            dst                     [CvMat!]
            jacobian                [CvMat!] ; CV_DEFAULT(0)
            return:                 [integer!]
        ]
        
        cvFindHomography: "cvFindHomography" [
        "finds perspective transformation between the object plane and image (view) plane"
            src_points                [CvMat!]
            dst_points                [CvMat!]
            homography                [CvMat!] 
        ]
        
        cvProjectPoints2: "cvProjectPoints2" [
        "projects object points to the view plane using the specified extrinsic and intrinsic camera parameters"
            object_points               [CvMat!]
            rotation_vector             [CvMat!]
            translation_vector          [CvMat!]
            intrinsic_matrix            [CvMat!]
            distortion_coeffs           [CvMat!]
            image_points                [CvMat!]
            dpdrot                      [CvMat!] ;CV_DEFAULT(NULL)
            dpdt                        [CvMat!] ;CV_DEFAULT(NULL)
            dpdf                        [CvMat!] ;CV_DEFAULT(NULL)
            dpdc                        [CvMat!] ;CV_DEFAULT(NULL)
            dpddist                     [CvMat!] ;CV_DEFAULT(NULL)          
        ]
        
        cvFindExtrinsicCameraParams2: "cvFindExtrinsicCameraParams2" [
        "Finds extrinsic camera parameters from a few known corresponding point pairs and intrinsic parameters"
            object_points               [CvMat!]
            image_points                [CvMat!]
            intrinsic_matrix            [CvMat!]
            distortion_coeffs           [CvMat!]
            rotation_vector             [CvMat!]
            translation_vector          [CvMat!]
        ]
        
        #define CV_CALIB_USE_INTRINSIC_GUESS  1
        #define CV_CALIB_FIX_ASPECT_RATIO     2
        #define CV_CALIB_FIX_PRINCIPAL_POINT  4
        #define CV_CALIB_ZERO_TANGENT_DIST    8
        
        cvCalibrateCamera2: "cvCalibrateCamera2" [
            object_points               [CvMat!]
            image_points                [CvMat!]
            point_counts                [CvMat!]
            image_size_w                [integer!] ;_CvSize
            image_size_h                [integer!] ; _CvSize
            intrinsic_matrix            [CvMat!]
            distortion_coeffs           [CvMat!]
            rotation_vectors            [CvMat!]   ;CV_DEFAULT(NULL)
            translation_vectors         [CvMat!]   ;CV_DEFAULT(NULL)
            flags                       [integer!] ;CV_DEFAULT(0)    
        ]
        
        #define CV_CALIB_CB_ADAPTIVE_THRESH  1
        #define CV_CALIB_CB_NORMALIZE_IMAGE  2
        #define CV_CALIB_CB_FILTER_QUADS     4
        
        cvFindChessboardCorners: "cvFindChessboardCorners" [
        "Detects corners on a chessboard calibration pattern"
            image                   [byte-ptr!]   ; *void
            pattern_size_w          [integer!]    ; _CvSize
            pattern_size_h          [integer!]    ; _CvSize
            corners                 [CvPoint2D32f!]
            corner_count            [int-ptr!] ;CV_DEFAULT(NULL)
            flags                   [integer!] ;CV_DEFAULT(CV_CALIB_CB_ADAPTIVE_THRESH)
        ]
        
        cvDrawChessboardCorners: "cvDrawChessboardCorners" [
        "Draws individual chessboard corners or the whole chessboard detected"
            image                   [CvArr!]   ; 
            pattern_size_w          [integer!]    ; _CvSize
            pattern_size_h          [integer!]    ; _CvSize
            corners                 [CvPoint2D32f!]
            count                   [integer!]
            pattern_was_found       [integer!]
        ]
        
        cvCreatePOSITObject: "cvCreatePOSITObject" [
        "Allocates and initializes CvPOSITObject structure before doing cvPOSIT"
            points                  [CvPoint2D32f!]
            point_count             [integer!]
            return:                 [CvPOSITObject!]
        ]
        
        cvPOSIT: "cvPOSIT" [
        "Runs POSIT (POSe from ITeration) algorithm for determining 3d position of an object given its model and projection in a weak-perspective case"
            posit_object            [CvPOSITObject!]
            image_points            [CvPoint2D32f!]
            focal_length            [float!]
            criteria                [CvTermCriteria!]
            rotation_matrix         [float!]  ; old CvMatr32f
            translation_vector      [float!]  ; old CvMatr32f
        ]
        
        cvReleasePOSITObject: "cvReleasePOSITObject" [
            posit_object            [double-byte-ptr!]     ;CvPOSITObject**
        ]
        
        ;****************************** Epipolar Geometry ****************************
        
        cvRANSACUpdateNumIters: "cvRANSACUpdateNumIters" [
        "updates the number of RANSAC iterations"
            p                   [float!]
            err_prob            [integer!]
            model_points        [integer!]
            max_iters           [float!]
            return:             [integer!]
        ]
        
        cvConvertPointsHomogenious: "cvConvertPointsHomogenious" [
            src                     [CvMat!]
            dst                     [CvMat!] 
        ]
        
        ;Calculates fundamental matrix given a set of corresponding points
        #define CV_FM_7POINT 1
        #define CV_FM_8POINT 2
        #define CV_FM_LMEDS_ONLY  4
        #define CV_FM_RANSAC_ONLY 8
        #define CV_FM_LMEDS [(CV_FM_LMEDS_ONLY + CV_FM_8POINT)]
        #define CV_FM_RANSAC [(CV_FM_RANSAC_ONLY + CV_FM_8POINT)]
        
        cvFindFundamentalMat: "cvFindFundamentalMat" [
        "Calculates fundamental matrix given a set of corresponding points"
            points1                 [CvMat!]
            points2                 [CvMat!]
            fundamental_matrix      [CvMat!]
            method                  [integer!]  ; CV_DEFAULT(CV_FM_RANSAC)
            param1                  [float!]    ; CV_DEFAULT(1.)
            param2                  [float!]    ; CV_DEFAULT(0.99)
            status                  [CvMat!]
            return:                 [integer!]
        ]
        
        cvComputeCorrespondEpilines: "cvComputeCorrespondEpilines" [
        "For each input point on one of images computes parameters of the corresponding epipolar line on the other image"
            points                  [CvMat!]
            which_image             [integer!]
            fundamental_matrix      [CvMat!]
            correspondent_lines     [CvMat!]
        ]
        

       
    ] ;end cdecl
]; end import

; inline functions
cvCreateSubdivDelaunay2D: func [rect [CvRect!] storage [CvMemStorage!] /local subdiv c][
"Simplified Delaunay diagram creation "
    subdiv: declare CvSubdiv2D!
    c: declare CvQuadEdge2D!
    subdiv: cvCreateSubdiv2D CV_SEQ_KIND_SUBDIV2D size? subdiv size? CvSubdiv2DPoint! size? c storage
    cvInitSubdivDelaunay2D subdiv rect/x rect/y rect/width rect/height
    subdiv
]

;************ Basic quad-edge navigation and operations ************


cvSubdiv2DNextEdge: func [ edge [CvSubdiv2DEdge!]] [CV_SUBDIV2D_NEXT_EDGE (edge/size)]

cvSubdiv2DRotateEdge: func [ edge [CvSubdiv2DEdge!] rotate [integer!] return: [CvSubdiv2DEdge!] /local e] [
    e: declare CvSubdiv2DEdge!
    e/size: (edge/size and not 3) + ((edge/size + rotate) and 3)
    e
]
cvSubdiv2DSymEdge: func [ edge [CvSubdiv2DEdge!] return: [CvSubdiv2DEdge!] /local e] [
    e: declare CvSubdiv2DEdge!
    e/size: edge/size * edge/size
    e
]

;TBD
;cvSubdiv2DGetEdge( CvSubdiv2DEdge edge, CvNextEdgeType type )
;CvSubdiv2DPoint*  cvSubdiv2DEdgeOrg( CvSubdiv2DEdge edge )
;CvSubdiv2DPoint*  cvSubdiv2DEdgeDst( CvSubdiv2DEdge edge )

cvTriangleArea: func [a [CvPoint2D32f!] b [CvPoint2D32f!] c [CvPoint2D32f!] return: [float32!]][(b/x - a/x) * (c/y - a/y) - (b/y - a/y) * (c/x - a/x)]

cvCalcHist: func [image [double-byte-ptr!] hist [CvHistogram!] accumulate [integer!] mask [CvArr!]] [
"Calculates array histogram (image : IplImage**)"
    cvCalcArrHist image hist accumulate mask
]


