Red/System [
	Title:		"OpenCV cxtypes"
	Author:		"François Jouen"
	Rights:		"Copyright (c) 2012-2013 François Jouen. All rights reserved."
	License: 	"BSD-3 - https:;github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; for testing
#define libopencv "/Library/Frameworks/OpenCV1-0.framework/Versions/A/OpenCV"

;#include %cxtypes.reds ;for standalone testing

;spatial and central moments
CvMoments!: alias struct!
[
	;/* spatial moments */ all values should be double
    m00                  [float!]
    m10                  [float!]
    m01                  [float!]
    m20                  [float!]
    m11                  [float!]
    m02                  [float!]
    m30                  [float!]
    m21                  [float!]
    m12                  [float!]
    m03                  [float!]
    ; /* central moments */ 
    mu20                  [float!]
    mu11                  [float!]
    mu02                  [float!]
    mu30                  [float!]
    mu21                  [float!]
    mu12                  [float!]
    mu03                  [float!]
    inv_sqrt_m00          [float!]; /* m00 != 0 ? 1/sqrt(m00)0 */
]

;Hu invariants
CvHuMoments!: alias struct! [
    hu1                 [float!] 
    hu2                 [float!] 
    hu3                 [float!] 
    hu4                 [float!] 
    hu5                 [float!] 
    hu6                 [float!] 
    hu7                 [float!] 
]

;**************************** Connected Component  **************************************
CvConnectedComp!: alias struct! 
[
    area		[float!]     ;area of the connected component
    value 		[cvScalar!]  ;average color of the connected component
    rect 		[CvRect!]    ;ROI of the component
    contour 	        [CvSeq!]     ;optional component boundary (the contour might have child contours corresponding to the holes)
]

;typedef struct _CvContourScanner* CvContourScanner;

;contour retrieval mode */
#define CV_RETR_EXTERNAL            0
#define CV_RETR_LIST                1
#define CV_RETR_CCOMP               2
#define CV_RETR_TREE                3

;contour approximation method */
#define CV_CHAIN_CODE               0
#define CV_CHAIN_APPROX_NONE        1
#define CV_CHAIN_APPROX_SIMPLE      2
#define CV_CHAIN_APPROX_TC89_L1     3
#define CV_CHAIN_APPROX_TC89_KCOS   4
#define CV_LINK_RUNS                5

;Freeman chain reader state  ;supprimer dans  cxtypes.reds!!!
_CvChainPtReader!: alias struct! [
    CV_SEQ_READER_FIELDS
    code        [integer!];
    pt          [CvPoint!]; 
    deltas      [int-ptr!] ;char      deltas[8][2];
]


;initializes 8-element array for fast access to 3x3 neighborhood of a pixel


CV_INIT_3X3_DELTAS: func [step [integer!] nch [integer!] return: [int-ptr!] /local deltas][
        arraySize: 8 * size? integer!
        mem: allocate arraySize
	deltas: as pointer! [integer!] mem
	deltas/1: nch
	deltas/2: negate step + nch
	deltas/3: negate step
	deltas/4: negate step - nch
	deltas/5: negate nch
	deltas/6: step - nch
	deltas/7: step
	deltas/8: step + nch
	return deltas
]

;Contour tree header 
CvContourTree!: alias struct! [
    CV_SEQUENCE_FIELDS ; pointer to the result of CV_SEQUENCE_FIELDS funtion (see cxtypes.r)
    p1			[cvPoint!] ;the first point of the binary tree root segment
    p2			[cvPoint!] ;the last point of the binary tree root segment
]

;finds a sequence of convexity defects of given contour

CvConvexityDefect: alias struct! [
    start		[cvPoint!]	;point of the contour where the defect begins 
    end			[cvPoint!]	;point of the contour where the defect ends 
    depth_point	        [cvPoint!]	;the farthest from the convex hull point within the defect
    depth		[float!]	;distance between the farthest point and the convex hull
]

;************ Data structures and related enumerations for Planar Subdivisions ************/

#define CvSubdiv2DEdge [integer!] ; size_t 
CvSubdiv2DEdge!: alias struct!   [ size [integer!]] ; size_t 

#define CV_SUBDIV2D_POINT_FIELDS[
    flags			[integer!]
    first			[CvSubdiv2DEdge] ;CvSubdiv2DEdge;
    pt_x                        [float32!] 
    pt_y                        [float32!] 
]

CvSubdiv2DPoint!: alias struct! [CV_SUBDIV2D_POINT_FIELDS]

#define CV_SUBDIV2D_FIELDS[ 
    [CV_GRAPH_FIELDS]
    quad_edges			[integer!]         
    is_geometry_valid	        [integer!]
    recent_edge			[CvSubdiv2DEdge] ;CvSubdiv2DEdge
    topleft_x			[float32!]
    topleft_y			[float32!]
    bottomright_x		[float32!]
    bottomright_y		[float32!]
] 

#define CV_QUADEDGE2D_FIELDS[
    flags			[integer!];               
    pt_4			[CvSubdiv2DPoint!]	; pointer to struct CvSubdiv2DPoint* ];
    next_4                      [CvSubdiv2DEdge]  ;CvSubdiv2DEdge;
]

#define CV_SUBDIV2D_VIRTUAL_POINT_FLAG      [1 << 30]
CvQuadEdge2D!: alias  struct! [CV_QUADEDGE2D_FIELDS]
CvSubdiv2D!: alias struct! [byte-ptr!] ;CV_SUBDIV2D_FIELDS

#enum CvSubdiv2DPointLocation![CV_PTLOC_ERROR: -2 CV_PTLOC_OUTSIDE_RECT: -1 CV_PTLOC_INSIDE: 0 CV_PTLOC_VERTEX: 1 CV_PTLOC_ON_EDGE: 2]
#enum CvNextEdgeType! [CV_NEXT_AROUND_ORG: 00h CV_NEXT_AROUND_DST: 22h CV_PREV_AROUND_ORG: 11h CV_PREV_AROUND_DST: 33h CV_NEXT_AROUND_LEFT: 13h CV_NEXT_AROUND_RIGHT: 31h CV_PREV_AROUND_LEFT: 20h CV_PREV_AROUND_RIGHT: 02h]
#define  CV_SUBDIV2D_NEXT_EDGE( edge ) [ edge and not 3 ] ;REVOIR

;Defines for Distance Transform

#define CV_DIST_USER            -1  ; User defined distance 
#define CV_DIST_L1              1   ; distance = |x1-x2| + |y1-y2| 
#define CV_DIST_L2              2   ; the simple euclidean distance 
#define CV_DIST_C               3   ; distance = max(|x1-x2|,|y1-y2|) 
#define CV_DIST_L12             4   ; L1-L2 metric: distance = 2(sqrt(1+x*x/2) - 1)) 
#define CV_DIST_FAIR            5   ; distance = c^2(|x|/c-log(1+|x|/c)), c = 1.3998 
#define CV_DIST_WELSCH          6   ; distance = c^2/2(1-exp(-(x/c)^2)), c = 2.9846 
#define CV_DIST_HUBER           7   ; distance = |x|<c ? x^2/2 : c(|x|-c/2), c=1.345 

#enum CvFilter [CV_GAUSSIAN_5x5: 7]

;/****************************************************************************************/
;/*                                    Older definitions                                 */
;/****************************************************************************************/
 
tCvVect32f: as float32! 0.0
CvMatr32f: as float32! 0.0
CvVect64d: as float64! 0.0
CvMatr64d: as float64! 0.0


;m: as pointer! [integer!] allocate 36 (3x3 size? integer!)
CvMatrix3!: alias struct![m [int-ptr!] ]


;revoir CvRandState quand défini
CvConDensation!: alias struct! [
    MP				[integer!]
    DP				[integer!]
    DynamMatr			[float!]		;Matrix of the linear Dynamics system
    State			[float!]		;Vector of State 
    SamplesNum                  [integer!]		;Number of the Samples
    flSamples			[pointer![float!]]	;**pointer array of the Sample Vectors (float**)
    flNewSamples		[pointer![float!]]	;**pointer to temporary array of the Sample Vectors (float**)
    flConfidence		[pointer![float!]]	;pointer Confidence for each Sample (float*)
    flCumulative		[pointer![float!]]	;idem Cumulative confidence
    Temp			[pointer![float!]]	;idem Temporary vector
    RandomSample		[pointer![float!]]	;idem RandomVector to update sample set
    RandS			[integer!]		; pointer to CvRandState Array of structures to generate random vectors
]

;standard Kalman filter (in G. Welch' and G. Bishop's notation):
;  x(k)=A*x(k-1)+B*u(k)+w(k)  p(w)~N(0,Q)
;  z(k)=H*x(k)+v(k),   p(v)~N(0,R)

;see cvgtype.h for  backward compatibility fields *
CvKalman!: alias struct! [
    MP				[integer!] 		; number of measurement vector dimensions */
    DP				[integer!]		; number of state vector dimensions */
    CP				[integer!]		; number of control vector dimensions */
    ;#if 1 backward compatibility fields  #endif
    Cstate_pre         		[CvMat!]                ;predicted state (x'(k)): x(k)=A*x(k-1)+B*u(k) */
    state_post			[CvMat!]	        ; corrected state (x(k)): x(k)=x'(k)+K(k)*(z(k)-H*x'(k)) */
    transition_matrix		[CvMat!]	        ;state transition matrix (A) */
    control_matrix		[CvMat!]	        ;control matrix (B) (it is not used if there is no control)*/
    measurement_matrix		[CvMat!]	        ;measurement matrix (H) */
    process_noise_cov		[CvMat!]	        ;process noise covariance matrix (Q) */
    measurement_noise_cov	[CvMat!]	        ;measurement noise covariance matrix (R) */
    error_cov_pre		[CvMat!]	        ;priori error estimate covariance matrix (P'(k)):P'(k)=A*P(k-1)*At + Q)*/
    gain			[CvMat!]	        ;Kalman gain matrix (K(k))  K(k)=P'(k)*Ht*inv(H*P'(k)*Ht+R)*/
    error_cov_post		[CvMat!]	        ;posteriori error estimate covariance matrix (P(k)):P(k)=(I-K(k)*H)*P'(k) */
    temp1			[CvMat!]	        ;temporary matrices */
    temp2			[CvMat!];
    temp3			[CvMat!]
    temp4			[CvMat!]
    temp5			[CvMat!]
]

;/*********************** Haar-like Object Detection structures **************************/
#define CV_HAAR_MAGIC_VAL       42500000h
#define CV_TYPE_NAME_HAAR       "opencv-haar-classifier"
#define CV_HAAR_FEATURE_MAX  3

CvHaarFeature!: alias struct!
[
    tilted 		    [integer!];
    rect 		    [struct! [
    				r [CvRect!];
        			weight [float!];
                            ]] ;rect [CV_HAAR_FEATURE_MAX]
]

CvHaarClassifier!: alias struct! [
    count			[integer!]
    haar_feature		[CvHaarFeature!]; CvHaarFeature! 
    threshold			[pointer![float!]] 
    left			[pointer![integer!]]
    right			[pointer![integer!]]
    alpha			[pointer![float!]]
]

CvHaarStageClassifier!: alias struct![
    count			[integer!];
    threshold			[float!]
    classifier			[CvHaarClassifier!]
    _next			[integer!]
    child			[integer!]
    parent			[integer!]
]

CvHaarClassifierCascade!: alias struct! 
[
    flags			[integer!]
    count			[integer!]
    orig_window_size 	        [CvSize!]
    real_window_size	        [CvSize!]
    scale			[float!]
    stage_classifier	        [CvHaarClassifier!]
    hid_cascade			[CvHaarClassifier!]
]

CvHidHaarClassifierCascade!: alias struct! [ ptr [CvHaarClassifierCascade!]]

;revoir les macros
CV_IS_HAAR_CLASSIFIER: func [haar [CvHaarClassifierCascade!] /local v]
[
        v: 0
	;if (haar not null) [v: v+ 1]
        ;if  (haar/flags and CV_MAGIC_MASK = CV_HAAR_MAGIC_VAL) [v: v+ 1]
        either v = 2 [true] [false]
]

CvAvgComp!: alias struct!
[
    rect			[CvRect!]
    neighbors			[integer!]
] 
