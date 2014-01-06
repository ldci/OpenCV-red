Red/System [
	Title:		"OpenCV CVAux"
	Author:		"François Jouen"
	Rights:		"Copyright (c) 2012-2013 François Jouen. All rights reserved."
	License: 	"BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

;#include %cxtypes.reds  ; for standalone testing
;#include %cvtypes.reds  ; for standalone testing

; cvaux

#switch OS [
	Windows		[#define cvaux "c:\windows\system32\cvaux100.dll"]
        MacOSX		[#define cvaux "/Library/Frameworks/OpenCV1-0.framework/Versions/A/OpenCV"]  ; 1.0.0
        ;MacOSX		[#define cvaux "/Library/Frameworks/OpenCV2-0.framework/Versions/B/OpenCV"]  ; 2.2.0
        ;MacOSX		[#define cvaux "/usr/local/lib/ibopencv_highgui.dylib"]                      ; 64-bit version
        Linux           []
	#default	[#define cvaux "/Library/Frameworks/OpenCV1-0.framework/Versions/A/OpenCV"]
]

#include %cxtypes.reds  ; for standalone testing


;int (CV_CDECL * CvCallback)(int index, void* buffer, void* user_data)

CvInput!: alias struct!
[
    callback            [byte-ptr!] ;CvCallback 
    data                [byte-ptr!]; void* 
]

;Struct for 1 image
CvImgObsInfo!: alias struct![
    obs_x               [integer!]
    obs_y               [integer!]
    obs_size            [integer!]
    obs                 [float-ptr!]    ;consequtive observations
    istate              [int-ptr!]      ;arr of pairs superstate/state to which observation belong
    mix                 [int-ptr!]      ;number of mixture to which observation belong
]

Cv1DObsInfo: declare CvImgObsInfo!

CvEHMMState!: alias struct! [
    num_mix             [integer!]      ;number of mixtures in this state
    mu                  [float-ptr!]    ;mean vectors corresponding to each mixture
    inv_var             [float-ptr!]    ;square root of inversed variances corresp. to each mixture
    log_var_val         [float-ptr!]    ;sum of 0.5 (LN2PI + ln(variance[i]) ) for i=1,n 
    weight              [float-ptr!]    ;array of mixture weights. Summ of all weights in state is 1. 
]

CvEHMM!: alias struct! [

    level               [integer!]          ; 0 - lowest(i.e its states are real states), ..... 
    num_states          [integer!]          ; number of HMM states
    transP              [float-ptr!]        ;transition probab. matrices for states
    obsProb             [double-float-ptr!] ;if level == 0 - array of brob matrices corresponding to hmm. if level == 1 - martix of matrices */
    u                   [byte-ptr!]         ; union CvEHMMState* state or struct CvEHMM* ehmm
]

;*                           More operations on sequences                                 *
; this must be improved!!!
#define CV_CURRENT_INT( reader ) [(as int-ptr reader/ptr)]
CV_GRAPH_WEIGHTED_VERTEX_FIELDS!: alias struct! [ptr [CvGraphVtx!] weight [float!]]
CV_GRAPH_WEIGHTED_EDGE_FIELDS!: alias  struct! [ptr [CvGraphEdge!]]

CvGraphWeightedVtx!: alias struct! [ptr [CV_GRAPH_WEIGHTED_VERTEX_FIELDS!]]
CvGraphWeightedEdge!: alias struct! [ptr [CV_GRAPH_WEIGHTED_EDGE_FIELDS!]]

; end comment

#enum CvGraphWeightType! [CV_NOT_WEIGHTED CV_WEIGHTED_VTX CV_WEIGHTED_EDGE CV_WEIGHTED_ALL]

;/*******************************Stereo correspondence*************************************/


#import [
    cvaux cdecl [
        cvSegmentImage: "cvSegmentImage" [
            srcarr              [CvArr!]
            dstarr              [CvArr!]
            canny_threshold     [float!]
            ffill_threshold     [float!]
            storage             [CvMemStorage!]
            return:             [CvSeq!] ; pointer
        ]
        
        ;/****************************************************************************************\
        ;*                                  Eigen objects                                         *
        ;\****************************************************************************************/
        
        #define CV_EIGOBJ_NO_CALLBACK     0
        #define CV_EIGOBJ_INPUT_CALLBACK  1
        #define CV_EIGOBJ_OUTPUT_CALLBACK 2
        #define CV_EIGOBJ_BOTH_CALLBACK   3
        
        cvCalcCovarMatrixEx: "cvCalcCovarMatrixEx" [
        "Calculates covariation matrix of a set of arrays"
            nObjects            [integer!]
            input               [byte-ptr!] ;*void
            ioFlags             [integer!]
            ioBufSize           [integer!]
            buffer              [byte-ptr!] ;uchar*
            userData            [byte-ptr!] ;*void
            avg                 [iplImage!]
            covarMatrix         [float-ptr!]
        ]
        
        cvCalcEigenObjects: "cvCalcEigenObjects" [
        "Calculates eigen values and vectors of covariation matrix of a set of arrays "
            nObjects            [integer!]
            input               [byte-ptr!] ;*void
            output              [byte-ptr!] ;*void
            ioFlags             [integer!]
            ioBufSize           [integer!]
            userData            [byte-ptr!] ;*void
            calcLimit           [CvTermCriteria!]
            avg                 [iplImage!]
            eigVals             [float-ptr!]
        ]
        
        cvCalcDecompCoeff: "cvCalcDecompCoeff" [
        "Calculates dot product (obj - avg) * eigObj (i.e. projects image to eigen vector)"
            obj                 [iplImage!]
            eigObj              [iplImage!]
            avg                 [iplImage!]
            return:             [float!]
        ]
        
        cvEigenDecomposite: "cvEigenDecomposite" [
        "Projects image to eigen space (finds all decomposion coefficients"
            obj                 [iplImage!]
            nEigObjs            [integer!]
            eigInput            [byte-ptr!] ;*void
            ioFlags             [integer!]
            userData            [byte-ptr!] ;*void
            avg                 [iplImage!]
            coeffs              [float-ptr!]
        ]
        
        cvEigenProjection: "cvEigenProjection" [
        "Projects original objects used to calculate eigen space basis to that space"
            eigInput            [byte-ptr!] ;*void
            nEigObjs            [integer!]
            ioFlags             [integer!]
            userData            [byte-ptr!] ;*void
            coeffs              [float-ptr!]
            avg                 [iplImage!]
            proj                [iplImage!]
        ]
        
        ;/****************************************************************************************\
        ;*                                       1D/2D HMM                                        *
        ;\****************************************************************************************/
        ; some obsolete functions are not included
        ;/*********************************** Embedded HMMs *************************************/
        
        cvCreate2DHMM: "cvCreate2DHMM" [
        "Creates 2D HMM"
            stateNumber         [int-ptr!]
            numMix              [int-ptr!]
            obsSize             [integer!]
            return:             [CvEHMM!]   ;pointer
        ]
        
        cvRelease2DHMM: "cvRelease2DHMM" [
        "Releases HMM "
            hmm                 [double-byte-ptr!]; CvEHMM**  
        ]
        
        #define CV_COUNT_OBS(roi win delta numObs )  [
        (numObs/width  = roi/width  - win/width  + delta/width / delta/width)
        (numObs/height = roi/height - win/height + delta/height / delta/height)
        ]
        
        cvCreateObsInfo: "cvCreateObsInfo" [
        "Creates storage for observation vectors"
            numObs_width            [integer!]      ; CvSize
            numObs_height           [integer!]      ; CvSize
            obsSize                 [integer!]
            return:                 [CvImgObsInfo!] ; pointer
        ]
        
        cvReleaseObsInfo: "cvReleaseObsInfo" [
        "Releases storage for observation vectors"
            obs_info                [double-byte-ptr!] ; CvImgObsInfo**
        ]
        
        cvImgToObs_DCT: "cvImgToObs_DCT" [
        {The function takes an image on input and and returns the sequnce of observations to be used with an embedded HMM;
        Each observation is top-left block of DCTcoefficient matrix }
            arr                     [CvArr!]
            obs                     [float-ptr!]
            dctSize_width            [integer!]      ; CvSize
            dctSize_height           [integer!]      ; CvSize
            Obs_width                [integer!]      ; CvSize
            Obs_height               [integer!]      ; CvSize
            delta_width              [integer!]      ; CvSize
            delta_height             [integer!]      ; CvSize
        ]
        
        cvUniformImgSegm: "cvUniformImgSegm" [
        "Uniformly segments all observation vectors extracted from image"
            obs_info                [CvImgObsInfo!]
            ehmm                    [CvEHMM!]
        ]
        
        cvInitMixSegm: "cvInitMixSegm" [
        "Does mixture segmentation of the states of embedded HMM"
            obs_info_array          [double-byte-ptr!] ; CvImgObsInfo** 
            num_img                 [integer!]
            ehmm                    [CvEHMM!] 
        ]
        
        cvEstimateHMMStateParams: "cvEstimateHMMStateParams" [
        "Function calculates means, variances, weights of every Gaussian mixture of every low-level state of embedded HMM"
            obs_info_array          [double-byte-ptr!] ; CvImgObsInfo** 
            num_img                 [integer!]
            ehmm                    [CvEHMM!]   
        ]
        
        cvEstimateTransProb: "cvEstimateTransProb" [
        "Function computes transition probability matrices of embedded HMM given observations segmentation"
            obs_info_array          [double-byte-ptr!] ; CvImgObsInfo** 
            num_img                 [integer!]
            ehmm                    [CvEHMM!]   
        ]
        
        cvEstimateObsProb: "cvEstimateObsProb" [
        "Function computes probabilities of appearing observations at any state (i.e. computes P(obs|state) for every pair(obs,state))"
            obs_info                [CvImgObsInfo!]
            ehmm                    [CvEHMM!]   
        ]
        
        cvEViterbi: "cvEViterbi" [
        "Runs Viterbi algorithm for embedded HMM"
            obs_info                [CvImgObsInfo!]
            ehmm                    [CvEHMM!]    
        ]
        
        cvMixSegmL2: "cvMixSegmL2" [
         {Function clusters observation vectors from several images given observations segmentation.
        Euclidean distance used for clustering vectors.Centers of clusters are given means of every mixture}
            obs_info_array          [double-byte-ptr!] ; CvImgObsInfo** 
            num_img                 [integer!]
            ehmm                    [CvEHMM!]   
            
        ]
        
        ;/****************************************************************************************\
        ;*               A few functions from old stereo gesture recognition demosions            *
        ;\****************************************************************************************/
        
        cvCreateHandMask: "cvCreateHandMask" [
        "Creates hand mask image given several points on the hand"
            hand_points             [CvSeq!]
            img_mask                [IplImage!]
            roi                     [CvRect!]
        ]
        
        cvFindHandRegion: "cvFindHandRegion" [
            points                  [CvPoint3D32f!]
            count                   [integer!]
            line                    [float-ptr!]
            size_w                  [float32!]  ;CvSize2D32f
            size_h                  [float32!]  ;CvSize2D32f
            flag                    [integer!]
            center_w                [float32!]  ;CvSize2D32f
            center_h                [float32!]  ;CvSize2D32f
            storage                 [CvMemStorage!]
            numbers                 [double-byte-ptr!] ;CvSeq **numbers
        ]
        
        cvFindHandRegionA: "cvFindHandRegionA" [
        "Finds hand region in range image data (advanced version)"
            points                  [CvPoint3D32f!]
            count                   [integer!]
            indexs                  [CvSeq!]
            line                    [float-ptr!]
            size_w                  [float32!]  ;CvSize2D32f
            size_h                  [float32!]  ;CvSize2D32f
            jc                      [integer!]
            center_w                [float32!]  ;CvSize2D32f
            center_h                [float32!]  ;CvSize2D32f
            storage                 [CvMemStorage!]
            numbers                 [double-byte-ptr!] ;CvSeq **numbers 
        ]
        
        ;/****************************************************************************************\
        ;*                           Additional operations on Subdivisions                        *
        ;\****************************************************************************************/
        
        icvDrawMosaic: "icvDrawMosaic" [
        "paints voronoi diagram: just demo function"
            subdiv              [CvSubdiv2D!]
            src                 [IplImage!]
            dst                 [IplImage!]   
        ]
        
        icvSubdiv2DCheck: "icvSubdiv2DCheck" [
        "Checks planar subdivision for correctness. It is not an absolute check, but it verifies some relations between quad-edges"   
            subdiv              [CvSubdiv2D!]
            return:             [integer!]
        ]
        
        ;/****************************************************************************************\
        ;*                           More operations on sequences                                 *
        ;\****************************************************************************************/
        
        
        
        
        
     
    ] ; cdecl end
] ;import end


; inline functions

icvSqDist2D32f: func [pt1 [CvPoint2D32f!] pt2 [CvPoint2D32f!] /local dx dy return [float!]] [
"returns squared distance between two 2D points with floating-point coordinates."
    dx: pt1/x - pt2/x
    dy: pt1/y - pt2/y
    dx * dx + dy * dy 
]

