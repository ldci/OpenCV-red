Red/System [
	Title:		"OpenCV cxtypes"
	Author:		"François Jouen"
	Rights:		"Copyright (c) 2012-2013 François Jouen. All rights reserved."
	License: 	"BSD-3 - https:;github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; for testing  
;#define libopencv "/Library/Frameworks/OpenCV1-0.framework/Versions/A/OpenCV"


;#include %rstypes.reds ; for standalone testing



;The metatype opencv CvArr* is used only as a function parameter to specify that the function accepts arrays of more than a single type, 
;for example IplImage*, CvMat* or even CvSeq*.The particular array type is determined at runtime by analyzing the first 4 bytes of the header.

#define CvArr! byte-ptr! ; OK for raw memory access with Red : metatype for images used as a function parameter
#define CvFileStorage! byte-ptr!



;;from  opencv cxtypes.h
Cv32suf!: alias struct! [
    i 		[integer!]
    u 		[integer!]
    f 		[float32!]
]

Cv64suf!: alias struct! [
    i 		[integer!]
    u 		[integer!]
    f 		[float!] ; double
]



;/****************************************************************************************\
;*                             Common macros and inline functions                         *
;\****************************************************************************************/

#define CV_PI   3.1415926535897932384626433832795
#define CV_LOG2 0.69314718055994530941723212145818

#define CV_SWAP(a b t) [t: a a: b b: t]
#define MIN(a b) [either a > b [b][a]]
#define MAX(a b) [either a > b [a][b]]


;min & max without jumps
#define  CV_IMIN(a b) [ (a or (a or b) and a) < b - 1]
#define  CV_IMAX (a b) [ (a or (a or b) and a) > b - 1]

;absolute value without jumps 
#define  CV_IABS(a)     [float-absolute a]
#define  CV_CMP(a b)    [(a > b) - (a < b)]
#define  CV_SIGN(a)     [CV_CMP(a 0)]

cvRound: func [value [float!] return: [integer!]] [float-to-int round-ceiling value] 
cvFloor: func [value [float!] return: [float!]][ round-floor value]
cvCeil: func [value [float!]return: [float!]][round-ceiling value]     
cvInvSqrt: func [value [float!] return: [float!]][ 1.0 / square-root value]
cvSqrt: func [value [float!] return: [float!]] [square-root value]


; is not a number? 
cvIsNaN: func [ value [float!] return: [logic!]] [isNaN value]
; infinite? 
cvIsInf: func [ value [float!] return: [integer!]] [IsInf value]

; random 
cvRNG: func [seed [integer!] return: [integer!] /local rng] [
rng: 0
either rng = seed [rng: seed][rng: -1]
rng
]



;returns random 32-bit unsigned integer
;examples for rand 
;v1: cvRandInt % 100           // v1 in the range 0 to 99
;v2: cvRandInt % 100 + 1;     // v2 in the range 1 to 100
;v3: cvRandInt % 30 + 1985;   // v3 in the range 1985-2014 

cvRandInt: func [ return: [integer!]][random] ; 0 MaxInt;
cvRandFloat: func [ return: [float!]][int-to-float (random)] ; 0 MaxInt;


;openCV returns random 32-bit unsigned integer ; but pbs so use previous

_cvRandInt: func [ rng [integer!]return: [integer!] /local temp][
tmp: rng
;tmp: tmp * 1554115554 + (tmp >> 312)
tmp 
]





;returns random floating-point number between 0 and 1 
cvRandReal: func [return: [float!] /local val][ val: int-to-float random val 3.0 * float-power 2.0 -32.0 ]  


;/****************************************************************************************\
;*                                  Image type (IplImage)                                 *
;\****************************************************************************************/

 {* The following definitions (until #endif)
 * is an extract from IPL headers.
 * Copyright (c) 1995 Intel Corporation.}

#define IPL_DEPTH_SIGN          80000000h ; 2147483648 en dec

#define IPL_DEPTH_1U            1
#define IPL_DEPTH_8U            8
#define IPL_DEPTH_16U           16
#define IPL_DEPTH_32F           32

#define IPL_DEPTH_8S            10; (IPL_DEPTH_SIGN OR 8)
#define IPL_DEPTH_16S           [(IPL_DEPTH_SIGN or 16)]
#define IPL_DEPTH_32S           [(IPL_DEPTH_SIGN or 32)]

#define IPL_DATA_ORDER_PIXEL    0
#define IPL_DATA_ORDER_PLANE    1

#define IPL_ORIGIN_TL           0
#define IPL_ORIGIN_BL           1

#define IPL_ALIGN_4BYTES        4
#define IPL_ALIGN_8BYTES        8
#define IPL_ALIGN_16BYTES       16
#define IPL_ALIGN_32BYTES       32

#define IPL_ALIGN_DWORD         IPL_ALIGN_4BYTES
#define IPL_ALIGN_QWORD         IPL_ALIGN_8BYTES

#define IPL_BORDER_CONSTANT     0
#define IPL_BORDER_REPLICATE    1
#define IPL_BORDER_REFLECT      2
#define IPL_BORDER_WRAP         3





IplROI!: alias struct!  [
    coi                         [integer!] ;0 - no COI (all channels are selected), 1 - 0th channel is selected ..
    xOffset                     [integer!]
    yOffset                     [integer!]
    width                       [integer!]
    height                      [integer!]
] 


IplImage!: alias struct! [
    nSize                       [integer!]; sizeof(IplImage)
    ID                          [integer!]; version (=0)
    nChannels                   [integer!]; Most of OpenCV functions support 1,2,3 or 4 channels
    alphaChannel                [integer!]; Ignored by OpenCV */
    depth                       [integer!]; Pixel depth in bits: 
    colorModel                  [c-string!];Ignored by OpenCV
    channelSeq                  [c-string!];ditto *
    dataOrder                   [integer!];0 - interleaved color channels, 1 - separate color channels.
    origin                      [integer!];0 - top-left origin, 1 - bottom-left origin (Windows bitmaps style). 
    align                       [integer!];Alignment of image rows (4 or 8).OpenCV ignores it and uses widthStep instead.
    width                       [integer!];Image width in pixels
    height                      [integer!];Image height in pixels. `
    *roi                        [IplROI!];Image ROI. If NULL, the whole image is selected                          	
    *maskROI                    [byte-ptr!];Must be NULL.
    *imageId                    [byte-ptr!] ;"           " 
    *tileInfo                   [byte-ptr!]	;"           "
    imageSize                   [integer!];Image data size in bytes
    *imageData                  [integer!];Pointer to aligned image data.         
    widthStep                   [integer!];Size of aligned image row in bytes.    
    BorderMode                  [integer!];Ignored by OpenCV.                     
    BorderConst                 [integer!]; Ditto.                                
    *imageDataOrigin            [byte-ptr!] ;Pointer to very origin of image data
]

IplConvKernel!: alias struct! [
    nCols                       [integer!]
    nRows                       [integer!]
    anchorX                     [integer!]
    anchorY                     [integer!]
    *values                     [int-ptr!]
    nShiftR                     [integer!]
]

IplConvKernelFP!: alias struct! [
    nCols                       [integer!]
    nRows                       [integer!]
    anchorX                     [integer!]
    anchorY                     [integer!]
    *values                     [int-ptr!]
]

#define IPL_IMAGE_HEADER 1
#define IPL_IMAGE_DATA   2
#define IPL_IMAGE_ROI    4

;/* extra border mode */
#define IPL_BORDER_REFLECT_101      4
#define IPL_IMAGE_MAGIC_VAL         [size? IplImage!]
#define CV_TYPE_NAME_IMAGE          "opencv-image"
#define IPL_DEPTH_64F               64 ; ;/* for storing double-precision floating point data in IplImage's */

#define CV_IS_IMAGE_HDR             [img <> null and IplImage!/nSize = size? IplImage!]
#define CV_IS_IMAGE	            [IplImage!/imageData <> null] 

;REVOIR 
;/* get reference to pixel at (col,row), for multi-channel images (col) should be multiplied by number of channels
;#define CV_IMAGE_ELEM( image, elemtype, row, col )  (((elemtype*)((image)->imageData + (image)->widthStep*(row)))[(col)])

CV_IMAGE_ELEM: func [image [IplImage!] elemtype [integer!] row [integer!] col [integer!]] [
    image/*imageData + image/widthStep * row * col
] ;

{****************************************************************************************\
*                                  Matrix type (CvMat)                                   *
\****************************************************************************************/}

; due to some limitations of Red for macros, original macros for matrices are replaced by functions if necessary


#define CV_CN_MAX     	                64
#define CV_CN_SHIFT   	                3
#define CV_DEPTH_MAX  	                [1 << CV_CN_SHIFT] ; ok 8
#define CV_8U   		        0
#define CV_8S   		        1
#define CV_16U  		        2
#define CV_16S  		        3
#define CV_32S  		        4
#define CV_32F  		        5
#define CV_64F  		        6
#define CV_USRTYPE1 	                7

#define CV_MAKETYPE (depth cn)  [depth + cn - 1 << CV_CN_SHIFT]
#define CV_MAKE_TYPE                    [CV_MAKETYPE]
#define CV_8UC1                         [CV_MAKETYPE (CV_8U 1)]
#define CV_8UC1                         [CV_MAKETYPE(CV_8U 1)]
#define CV_8UC2                         [CV_MAKETYPE(CV_8U 2)]
#define CV_8UC3                         [CV_MAKETYPE(CV_8U 3)]
#define CV_8UC4                         [CV_MAKETYPE(CV_8U 4)]
#define CV_8UC(n)                       [CV_MAKETYPE(CV_8U (n))] ; example print [ CV_8UC(5) lf ]  -> 32
#define CV_8SC1                         [CV_MAKETYPE(CV_8S 1)]
#define CV_8SC2                         [CV_MAKETYPE(CV_8S 2)]
#define CV_8SC3                         [CV_MAKETYPE(CV_8S 3)]
#define CV_8SC4                         [CV_MAKETYPE(CV_8S 4)]
#define CV_8SC(n)                       [CV_MAKETYPE(CV_8S (n))]
#define CV_16UC1                        [CV_MAKETYPE(CV_16U 1)]
#define CV_16UC2                        [CV_MAKETYPE(CV_16U 2)]
#define CV_16UC3                        [CV_MAKETYPE(CV_16U 3)]
#define CV_16UC4                        [CV_MAKETYPE(CV_16U 4)]
#define CV_16UC(n)                      [CV_MAKETYPE(CV_16U (n))]
#define CV_16SC1                        [CV_MAKETYPE(CV_16S 1)]
#define CV_16SC2                        [CV_MAKETYPE(CV_16S 2)]
#define CV_16SC3                        [CV_MAKETYPE(CV_16S 3)]
#define CV_16SC4                        [CV_MAKETYPE(CV_16S 4)]
#define CV_16SC(n)                      [CV_MAKETYPE(CV_16S(n))]
#define CV_32SC1                        [CV_MAKETYPE(CV_32S 1)]
#define CV_32SC2                        [CV_MAKETYPE(CV_32S 2)]
#define CV_32SC3                        [CV_MAKETYPE(CV_32S 3)]
#define CV_32SC4                        [CV_MAKETYPE(CV_32S 4)]
#define CV_32SC(n)                      [CV_MAKETYPE(CV_32S (n))]
#define CV_32FC1                        [CV_MAKETYPE(CV_32F 1)]
#define CV_32FC2                        [CV_MAKETYPE(CV_32F 2)]
#define CV_32FC3                        [CV_MAKETYPE(CV_32F 3)]
#define CV_32FC4                        [CV_MAKETYPE(CV_32F 4)]
#define CV_32FC(n)                      [CV_MAKETYPE(CV_32F (n))]
#define CV_64FC1                        [CV_MAKETYPE(CV_64F 1)]
#define CV_64FC2                        [CV_MAKETYPE(CV_64F 2)]
#define CV_64FC3                        [CV_MAKETYPE(CV_64F 3)]
#define CV_64FC4                        [CV_MAKETYPE(CV_64F 4)]
#define CV_64FC(n)                      [CV_MAKETYPE(CV_64F (n))]

#define CV_AUTO_STEP  		        7FFFFFFFh					 
#define CV_WHOLE_ARR  		        [cvslice 0 3FFFFFFFh]

#define CV_MAT_CN_MASK                  [CV_CN_MAX - 1 << CV_CN_SHIFT]
#define CV_MAT_CN(flags)                [flags AND CV_MAT_CN_MASK >> CV_CN_SHIFT + 1]
#define CV_MAT_DEPTH_MASK               [CV_DEPTH_MAX - 1]
#define CV_MAT_DEPTH(flags)             [flags AND CV_MAT_DEPTH_MASK]
#define CV_MAT_TYPE_MASK                [CV_DEPTH_MAX * CV_CN_MAX - 1]
#define CV_MAT_TYPE(flags)              [flags AND CV_MAT_TYPE_MASK]
#define CV_MAT_CONT_FLAG_SHIFT          14
#define CV_MAT_CONT_FLAG                [1 << CV_MAT_CONT_FLAG_SHIFT]
#define CV_IS_MAT_CONT(flags)           [flags AND CV_MAT_CONT_FLAG]
#define CV_IS_CONT_MAT                  [CV_IS_MAT_CONT] ; ???
#define CV_MAT_TEMP_FLAG_SHIFT          15
#define CV_MAT_TEMP_FLAG                [1 << CV_MAT_TEMP_FLAG_SHIFT]
#define CV_IS_TEMP_MAT(flags)           [flags AND CV_MAT_TEMP_FLAG]

#define CV_MAGIC_MASK       		FFFF0000h
#define CV_MAT_MAGIC_VAL    		42420000h
#define CV_TYPE_NAME_MAT    		"opencv-matrix"

CvMat!: alias struct! [
	type            [integer!]              ; CvMat signature (CV_MAT_MAGIC_VAL), element type and flags 
	step            [integer!]              ; full row length in bytes
    ;for internal use only 
	refcount        [int-ptr!]              ; underlying data reference counter (a integer pointer) 
	hdr_refcount    [integer!] ;
	data            [float-ptr!]            ; in C an union [ uchar* ptr;short* s;int* i;float* fl;double* db;]
	rows            [integer!]              ;number of rows
	cols            [integer!]              ;number of cols
]

;#define CV_IS_MAT_HDR (mat) [((mat <> null) and ((mat/type and CV_MAGIC_MASK) = CV_MAT_MAGIC_VAL) and ((mat/cols > 0) and (mat/rows > 0)))]

CV_IS_MAT_HDR: func [mat [cvMat!] return: [logic!] /local v tmp result] [
    v: 0
    if mat <> null [v: v + 1]
    tmp: mat/type and CV_MAGIC_MASK
    if tmp = CV_MAT_MAGIC_VAL [v: v +1]
    if mat/cols > 0 [v: v +1]
    if mat/rows > 0 [v: v +1]
    either v = 4 [result: true] [result: false]
    result
]


;#define CV_IS_MAT(mat) [(CV_IS_MAT_HDR (mat) and mat/data <> NULL)]

CV_IS_MAT:  func [mat [cvMat!] return: [logic!]  /local v result] [
        v: 0 
 	if mat/data <> null [v: v + 1 ]
 	if CV_IS_MAT_HDR mat [v: v + 1 ]
 	either v = 2 [result: true] [result: false]
 	return result
]

#define CV_IS_MASK_ARR(mat) [(mat/type and (CV_MAT_TYPE_MASK and CV_8SC1)) == 0]
#define CV_ARE_TYPES_EQ (mat1 mat2) [(((mat1/type xor mat2/type) and (CV_MAT_TYPE_MASK)) = 0)]
#define CV_ARE_CNS_EQ (mat1 mat2) [(((mat1/type xor mat2/type) and CV_MAT_CN_MASK) = 0)]
#define CV_ARE_SIZES_EQ (mat1 mat2) [((mat1/height = mat2/height) and (mat1/width = mat2/width))]
#define CV_ARE_DEPTHS_EQ (mat1 mat2) [((mat1/type xor mat2/type) and (CV_MAT_DEPTH_MASK) = 0)]
#define CV_IS_MAT_CONST (mat) [mat/rows or mat/cols = 1]

;* size of each channel item 0x124489 = 1000 0100 0100 0010 0010 0001 0001 ~ array of sizeof(arr_type_elem) */
#define CV_ELEM_SIZE1 (type) [(((size? integer!) << (28 or 138682897))  >> ((CV_MAT_DEPTH (type) * 4) and 15))]
;* 0x3a50 = 11 10 10 01 01 00 00 ~ array of log2(sizeof(arr_type_elem)) */
#define CV_ELEM_SIZE (type) [((CV_MAT_CN(type)) << (((((size? integer!) / 4) + 1) * 16384) or 3A50h) >> ((CV_MAT_DEPTH (type) * 2) and 3))]


cvMat: func [
{inline constructor. No data is allocated internally!!!
use together with cvCreateData, or use cvCreateMat instead to get a matrix with allocated data}
	rows            [integer!]
	cols            [integer!]
	type            [integer!]
	data            [float-ptr!]
	return:         [cvMat!]]
	[m: declare cvMat!
	assert (m/type and  CV_MAT_DEPTH_MASK) <= CV_64F
	m/type: CV_MAT_MAGIC_VAL OR CV_MAT_CONT_FLAG OR type
	m/cols: cols;
    	m/rows: rows
    	either rows > 1 [m/step: m/cols * CV_ELEM_SIZE (type) ][m/step: 0]
    	m/data: data;
    	m/refcount: null;
   	m/hdr_refcount: 0;
   	m
]


#define CV_MAT_ELEM_PTR_FAST( mat row col pix_size) [ (assert (row < mat/rows) and (col < mat/cols)
                    ((size? integer!) * mat/step * row + pix_size * col) + mat/data)]
#define CV_MAT_ELEM_PTR( mat row col ) [CV_MAT_ELEM_PTR_FAST (mat row col (CV_ELEM_SIZE (mat/type)))]
#define CV_MAT_ELEM ( mat elemtype row col )  [ CV_MAT_ELEM_PTR_FAST (mat row col (size? elemtype))]

cvmGet: func [
"Return the particular element of single-channel floating-point matrix"
		mat 	[cvMat!]
		row 	[integer!]
		col 	[integer!]
		return: [float!]
		/local index type ]
		[
                type: mat/type AND CV_MAT_TYPE_MASK
		assert row < mat/rows
                assert col < mat/cols
                if type = (CV_32FC1 or CV_64FC1) [
                index: (mat/cols * mat/step * row  + col) - mat/cols; index of element REVOIR
                mat/data: mat/data + index ] ; move pointer to 
                either mat/data <> null [mat/data/value] [0.0]; get value
]

cvmSet: func [
"Set the particular element of single-channel floating-point matrix"
		mat 	[cvMat!]
		row 	[integer!]
		col 	[integer!]
		value 	[float!]
		/local type index]
		[
		type: CV_MAT_TYPE (mat/type)
		assert row < mat/rows
                assert col < mat/cols
                if type = (CV_32FC1 or CV_64FC1) [
                index: (mat/cols * mat/step * row  + col) - mat/cols  ; index of element 
                mat/data: mat/data + index ] ; move pointer to
                mat/data/value: value ; set the value 		
]

cvCvToIplDepth: func [
	type [integer!]
	return: [integer!]
	/local depth val ]
	[depth: CV_MAT_DEPTH(type)
	val: 0
	either depth = CV_8S  [val: IPL_DEPTH_SIGN] [val: 0]
	either depth = CV_16S [val: IPL_DEPTH_SIGN] [val: 0]
	either depth = CV_32S [val: IPL_DEPTH_SIGN] [val: 0]
        CV_ELEM_SIZE1 (depth) * 8 or val 
]


;/****************************************************************************************\
;*                       Multi-dimensional dense array (CvMatND)                          *
;\****************************************************************************************/
#define CV_MATND_MAGIC_VAL   	42430000h
#define CV_TYPE_NAME_MATND    	"opencv-nd-matrix"
#define CV_MAX_DIM              32
#define CV_MAX_DIM_HEAP         [1 << 16]

CvMatND!: alias struct! [
	type                    [integer!]              ;CvMatND signature (CV_MATND_MAGIC_VAL), element type and flags
	dims                    [integer!]              ;number of array dimensions
	refcount                [int-ptr!]              ;underlying data reference counter (a integer pointer)
	hdr_refcount 			[integer!]
	data                    [float-ptr!]                ; in C an union [ uchar* ptr;short* s;int* i;float* fl;double* db;]
	dim                     [struct! [
                                    size [integer!]
                                    step [integer!]
                                ]                       ;pairs (number of elements, distance between elements in bytes) for every dimension [CV_MAX_DIM]
	]
] 

;#define CV_IS_MATND_HDR (mat) [ ((mat <> null)  and (mat/type AND CV_MAGIC_MASK = CV_MATND_MAGIC_VAL))]


CV_IS_MATND_HDR: func [mat [CvMatND!] return: [logic!]/local v result] [
        v: 0    
         if mat <> null [v: v + 1]
         if ((mat/type AND CV_MAGIC_MASK) = CV_MATND_MAGIC_VAL) [v: v + 1]
         either v = 2 [result: true] [result: true]
         result
]


#define CV_IS_MATND (mat) [((mat/data <> null) and (CV_IS_MATND_HDR(mat)))]
CV_IS_MATND:  func [mat [CvMatND!] return: [logic!]/local v result] [
    v: 0
    if mat <> null [v: v + 1]
    if CV_IS_MATND_HDR mat [v: v + 1]
    either v = 2 [result: true] [result: true]
    result
    
]




;/****************************************************************************************\
;*                      Multi-dimensional sparse array (CvSparseMat)                      *
;\****************************************************************************************/

#define CV_SPARSE_MAT_MAGIC_VAL         42440000h
#define CV_TYPE_NAME_SPARSE_MAT         "opencv-sparse-matrix"



CvSparseMat!: alias struct! [
	type                            [integer!]              ;CvSparseMat signature (CV_SPARSE_MAT_MAGIC_VAL), element type and flags
	dims                            [integer!]              ;number of dimensions
	refcount                        [int-ptr!]              ; not used null
        hdr_refcount                    [integer!]
	heap                            [byte-ptr!]             ; a pool of hashtable nodes (structure CvSet! not defined here) 
	hashtable                       [double-byte-ptr!]      ; void** hashtable: each entry has a list of nodes having the same "hashvalue modulo hashsize
	hashsize                        [integer!]              ;size of hashtable
	total                           [integer!]              ;total number of sparse array nodes
	valoffset                       [integer!]              ;value offset in bytes for the array nodes
	idxoffset                       [integer!]              ;index offset in bytes for the array nodes 
	size                            [integer!]              ;arr of dimension sizes [CV_MAX_DIM];
]

#define CV_IS_SPARSE_MAT_HDR (mat) [((mat <> null) and ((mat/type AND CV_MAGIC_MASK) = CV_SPARSE_MAT_MAGIC_VAL) )]
#define CV_IS_SPARSE_MAT (mat) [ CV_IS_SPARSE_MAT_HDR(mat)]
    



;/**************** iteration through a sparse array *****************/

CvSparseNode!: alias struct! [
    hashval		[integer!]; unsigned32
    next		[CvSparseNode!]
]  

CvSparseMatIterator!: alias struct! [
    mat			[CvSparseMat!];
    node		[CvSparseNode!]
    curidx		[integer!]
]


;#define CV_NODE_VAL(mat,node)   ((void*)((uchar*)(node) + (mat)->valoffset))
CV_NODE_VAL: func [
{Gets Value of the Node.
Because there are a lot of types possible IntPtr is returned and needs to convert to the necessary type}

	mat			[CvSparseMat!]
	node		        [CvSparseNode!]
	return:                 [pointer! [byte!]] /local ptr]
	[ptr: as [pointer! [byte!]] node
         ptr: ptr + mat/valoffset
         ptr
]

CV_NODE_IDX: func [
"Get Adress of next node."
	mat			[CvSparseMat!]
	node		        [CvSparseNode!]
	return:                 [pointer! [byte!]] /local ptr]
	[ptr: as [pointer! [byte!]] node
         ptr: ptr + mat/idxoffset
         ptr
]

;/****************************************************************************************\
;*                                         Histogram                                      *
;\****************************************************************************************/

#define CvHistType! 			[integer!]
#define CV_HIST_MAGIC_VAL     	        42450000h
#define CV_HIST_UNIFORM_FLAG  	        [1 << 10]
;indicates whether bin ranges are set already or not 
#define CV_HIST_RANGES_FLAG   	        [1 << 11]
#define CV_HIST_ARRAY         	        0
#define CV_HIST_SPARSE        	        1
#define CV_HIST_TREE          	        [CV_HIST_SPARSE]

CvHistogram!: alias struct![
    type 			[integer!];
    bins 			[CvArr!]; ;must be verified pointer
    thresh			[float!] ; [CV_MAX_DIM][2]; /* for uniform histograms */
    thresh2			[double-float-ptr!] ; float** /* for non-uniform histograms 
    mat			        [CvMatND!] ; /* embedded matrix header for array histograms */
]

#define CV_IS_HIST (hist) [ (hist <> null) and ((hist/type  AND CV_MAGIC_MASK) = CV_HIST_MAGIC_VAL) and (hist/bins <> null) ]
#define CV_IS_UNIFORM_HIST (hist) [ ((hist/type AND CV_HIST_UNIFORM_FLAG) <> 0)]
#define CV_IS_SPARSE_HIST (hist) [ (CV_IS_SPARSE_MAT (hist/bins))]
#define CV_HIST_HAS_RANGES (hist) [(hist/type AND CV_HIST_RANGES_FLAG <> 0)]

;/****************************************************************************************\
;*                      Other supplementary data type definitions                         *
;\****************************************************************************************/

;/*************************************** CvRect *****************************************/     
CvRect!: alias struct!  [
	x 		[integer!]  ;x-coordinate of the left-most rectangle corner[s]
	y 		[integer!]  ;y-coordinate of the top-most or bottom-most corner[s]
	width 	        [integer!]  ;width of the rectangle 
	height 	        [integer!]  ;height of the rectangle 
]     

#define _CvRect  [CvRect!] ; _ are not pointer struct

cvRect: func [
	x 		[integer!]
	y 		[integer!]
	width 	        [integer!]
	height 	        [integer!]
	return:         [cvRect!]
	/local r]
	[r: declare cvRect!
	r/x: 		x
	r/y: 		y
	r/width: 	width
	r/height: 	height
	r
]

cvRectToROI: func[
"Rectangle to Region of Interest"
	rect		[cvRect!]
	coi		[integer!]
	return: 	[IplROI!]
                        /local roi]
        [
        roi:                declare IplROI!
        roi/xOffset:        rect/x
        roi/yOffset:        rect/y
        roi/width:          rect/width
        roi/height:         rect/height
        roi/coi: coi
        roi
]

cvROIToRect: func [
"Region of Interest to Rectangle"
	roi 		[IplROI!]
	return:		[cvRect!]
                        /local r]
        [r:                 declare cvRect!
        r/x: 		roi/xOffset
        r/y: 		roi/yOffset
        r/width: 	        roi/width
        r/height: 	        roi/height
        r
]

;/*********************************** CvTermCriteria *************************************/

#define CV_TERMCRIT_ITER    		1
#define CV_TERMCRIT_NUMBER  		CV_TERMCRIT_ITER
#define CV_TERMCRIT_EPS     		2

CvTermCriteria!: alias struct! [
	type		[integer!] ;  may be combination of  CV_TERMCRIT_ITER CV_TERMCRIT_EPS
	max_iter	[integer!]
	epsilon		[float!]
]

cvTermCriteria: func [
	type		[integer!]
	max_iter	[integer!]
	epsilon 	[float!]
	return:  	[CvTermCriteria!]
                        /local t]
	[t: declare CvTermCriteria!
	t/type: type
	t/max_iter: max_iter
        t/epsilon: epsilon
	t
]

;/******************************* CvPoint and variants ***********************************/
; we use user.reds for conversion. See the evolution of Red
CvPoint!: alias struct!  [
	x               [integer!]
	y               [integer!]
] 

#define _CvPoint        [CvPoint!]
cvPoint: func [
	x               [integer!]
	y               [integer!]
	return:         [cvPoint!]
                        /local p
	][
	p: declare cvPoint!
	p/x: x
	p/y: y
	p
]

CvPoint2D32f!: alias struct! [
        x               [float32!]
        y               [float32!]
]

#define _CvPoint2D32f   [CvPoint2D32f!]

cvPoint2D32f: func [
	x               [float32!]
	y               [float32!]
	return:         [CvPoint2D32f!]
                        /local p
	][
	p: declare CvPoint2D32f!
	p/x: x
	p/y: y
	p
]

cvPointTo32f: func [
	xy              [cvPoint!]
	return:         [CvPoint2D32f!]
                        /local p x y
	][
	p: declare CvPoint2D32f!
	x: int-to-float xy/x
        p/x: as float32! x
        y: int-to-float xy/y
        p/y: as float32! y
       	p
]

cvPointFrom32f: func [
	xy              [CvPoint2D32f!]
	return:         [cvPoint!]
                        /local p x y
	][
        x: as float! xy/x
        y: as float! xy/y
	p: declare cvPoint!
	p/x: float-to-int x ; cvRound can be used to
	p/y: float-to-int y ; cvRound
        p
]

#define _CvPoint3D32f        [CvPoint3D32f!]

CvPoint3D32f!: alias struct! [
        x          [float32!]
        y          [float32!]
        z          [float32!]
]

cvPoint3D32f: func [
	x           [float32!]
	y           [float32!]
	z           [float32!]
	return:     [CvPoint3D32f!]
	/local p]
	[
	p: declare  CvPoint3D32f!
	p/x: x
	p/y: y
	p/z: z
	p
]


CvPoint2D64f!: alias struct! [
        x          [float!]
        y          [float!]
]

#define _CvPoint2D64f        [CvPoint2D64f!]

cvPoint2D64f: func [
        x           [float!]
        y           [float!]
                    return: [CvPoint2D64f!]
                    /local p]
	[
	p: declare CvPoint2D64f!
	p/x: x
	p/y: y
	p
]

CvPoint3D64f!: alias struct! [
    x           [float!]
    y           [float!]
    z           [float!]
]

#define _CvPoint3D64f        [CvPoint3D64f!]

cvPoint3D64f: func [
    x           [float!]
    y           [float!]
    z           [float!]
		return: [CvPoint3D64f!]
		/local p]
		[
		p: declare CvPoint3D64f!
		p/x: x
		p/y: y
		p/z: z
		p
]

;/******************************** CvSize's & CvBox **************************************/

CvSize!: alias struct! [
    width           [integer!];
    height          [integer!]
]

#define _CvSize [CvSize!]


cvSize: func [
    width       [integer!]
    height      [integer!]
    return:     [CvSize!]
                /local s]
    [
    s: declare CvSize!
    s/width: width
    s/height: height
    s
]

CvSize2D32f!: alias struct! [
    width       [float32!]
    height      [float32!];
]

#define _CvSize2D32f [CvSize2D32f!]

cvSize2D32f: func [
    width       [float32!]
    height      [float32!]
		return: [cvSize2D32f!]
		/local s]
    [
    s: declare cvSize2D32f!
    s/width: width
    s/height: height
    s
]

CvBox2D!: alias struct! [
    center      [_CvPoint2D32f] ;center of the box 
    size        [_CvSize2D32f]	;box width and length
    angle       [float32!]	;angle between the horizontal axis and the first side (i.e. length) in degrees
]

#define _CvBox2D [CvBox2D!]

; Line iterator state */

CvLineIterator!: alias struct! [
    ;pointer to the current point 
    uchar*      [byte-ptr!]
                ;Bresenham algorithm state */
    err         [integer!]
    plus_delta  [integer!]
    minus_delta [integer!]
    plus_step   [integer!]
    minus_step  [integer!]
]

;/************************************* CvSlice ******************************************/

CvSlice!: alias struct! [ 
    start_index         [integer!]
    end_index           [integer!]
]

#define _CvSlice [CvSlice!]

cvSlice: func [
    start_index     [integer!]
    end_index       [integer!]
    return:         [CvSlice!]
                    /local slice]
    [
    slice: declare CvSlice!
    slice/start_index: start_index
    slice/end_index: end_index
    slice
]

#define CV_WHOLE_SEQ_END_INDEX 3FFFFFFFh
#define CV_WHOLE_SEQ  [(cvSlice 0 CV_WHOLE_SEQ_END_INDEX)]


;/************************************* CvScalar *****************************************/
; tableau de 4 float ;double val[4];


CvIntScalar!: alias struct! [
    v0        [integer!]
    v1        [integer!]
    v2        [integer!]
    v3        [integer!]
]

#define _CvIntScalar [CvIntScalar!]

CvScalar!: alias struct! [
    v0        [float!]
    v1        [float!]
    v2        [float!]
    v3        [float!]
]

#define _CvScalar [CvIntScalar!]

cvScalar: func [
    v0          [float!]
    v1          [float!]
    v2          [float!]
    v3          [float!]
    return:     [CvScalar!]
                /local c
    ][
    c: declare cvScalar!
    c/v0: v0
    c/v1: v1
    c/v2: v2
    c/v3: v3
    c
]

cvRealScalar: func [
    v0          [float!] ;should be double
    return:     [CvScalar!]
    /local      c
    ][
    c: declare cvScalar!
    c/v0: v0
    c/v1: 0.0
    c/v2: 0.0
    c/v3: 0.0
    c
]

cvScalarAll: func [
    val0123         [float!] ;should be double
    return:         [CvScalar!]
    /local          c
    ][
    c: declare cvScalar!
    c/v0: val0123
    c/v1: val0123
    c/v2: val0123
    c/v3: val0123
    c
]


;/****************************************************************************************\
;*                                   Dynamic Data structures                              *
;\****************************************************************************************/

;/******************************** Memory storage ****************************************/


CvMemBlock!: alias struct! [
    prev 		[CvMemBlock!]
    next 		[CvMemBlock!]
]

#define CV_STORAGE_MAGIC_VAL    42890000h

CvMemStorage!: alias struct! [
    signature 		        [integer!]
    bottom 			[cvMemBlock!]	        ; first allocated block */
    top 			[cvMemBlock!]	        ; current memory block - top of the stack */
    parent 			[cvMemStorage!]	        ; *cvMemStorage pointer that borrows new blocks from */
    block_size 		        [integer!]		; block size */
    free_space 		        [integer!]		; free space in the current block */
]

#define CV_IS_STORAGE (storage) [((storage <> null) and ((storage/signature AND CV_MAGIC_MASK) = CV_STORAGE_MAGIC_VAL))]

CvMemStoragePos: alias struct! [
    top                     [CvMemBlock!]
    free_space              [integer!]
]

;/*********************************** Sequence *******************************************/
CvSeqBlock!: alias struct! [
    prev                    [CvSeqBlock!]           ;*CvSeqBlock pointer previous sequence block */
    next                    [CvSeqBlock!]           ;*CvSeqBlock pointernext sequence block */
    start_index             [integer!]		    ; index of the first element in the block + sequence->first->start_index */
    count                   [integer!]              ; number of elements in the block */
    data                    [byte-ptr!]             ; pointer to the first element of the block */
]


#define CV_TREE_NODE_FIELDS (node_type) [
            flags               [integer!]    ;micsellaneous flags    
            header_size         [integer!]    ;size of sequence header 
            h_prev              [CvSeq!]   ;struct previous sequence     
            h_next              [CvSeq!]   ;struct next sequence
            v_prev              [CvSeq!]   ;struct 2nd previous sequence 
            v_next              [CvSeq!]   ;struct 2nd next sequence
]

; Read/Write sequence. Elements can be dynamically inserted to or deleted from the sequence.

#define CV_SEQUENCE_FIELDS  [
        CV_TREE_NODE_FIELDS (CvSeq!)
        total                   [integer!]              ;total number of elements
        elem_size               [integer!]              ;size of sequence element in bytes 
        block_max               [byte-ptr!]             ; maximal bound of the last block
        ptr                     [byte-ptr!]             ;current write pointer
        delta_elems             [byte-ptr!]              ;how many elements allocated when the seq grows
        storage                 [CvMemStorage!]         ;where the seq is stored
        free_blocks             [CvSeqBlock!]           ;free blocks list 
        first                   [CvSeqBlock!]           ;pointer to the first sequence block 
]


; this an alternative  regrouping in  sole struct
CvSeq!: alias struct! [
        flags                   [integer!]              ;micsellaneous flags    
        header_size             [integer!]              ;size of sequence header 
        h_prev                  [CvSeq!]                ;struct previous sequence     
        h_next                  [CvSeq!]                ;struct next sequence
        v_prev                  [CvSeq!]                ;struct 2nd previous sequence 
        v_next                  [CvSeq!]                ;struct 2nd next sequence
        total                   [integer!]              ;total number of elements
        elem_size               [integer!]              ;size of sequence element in bytes 
        block_max               [byte-ptr!]             ; maximal bound of the last block
        ptr                     [byte-ptr!]             ;current write pointer
        delta_elems             [integer!]              ;how many elements allocated when the seq grows
        storage                 [CvMemStorage!]         ;where the seq is stored
        free_blocks             [CvSeqBlock!]           ;free blocks list 
        first                   [CvSeqBlock!]           ;pointer to the first sequence block 
]

_CvSeq!: alias struct! [CV_SEQUENCE_FIELDS ] ; for test it's a pointer
CvSeq**: alias struct! [seq [CvSeq!]] ; it's a double pointer


#define CV_TYPE_NAME_SEQ             "opencv-sequence"
#define CV_TYPE_NAME_SEQ_TREE        "opencv-sequence-tree"

;/*************************************** Set ********************************************/
{
  Set.Order is not preserved. There can be gaps between sequence elements.
  After the element has been inserted it stays in the same place all the time.
  The MSB(most-significant or sign bit) of the first field (flags) is 0 iff the element exists.
}

#define CV_SET_ELEM_FIELDS (elem_type) [flags [integer!] next_free [byte-ptr!]]
CvSetElem!: alias struct! [CV_SET_ELEM_FIELDS (CvSetElem!)]

#define CV_SET_FIELDS [CV_SEQUENCE_FIELDS free_elems [CvSetElem!] active_count [integer!] ]
CvSet!: alias struct! [CV_SET_FIELDS]

#define CV_SET_ELEM_IDX_MASK   [1 << 26 - 1]
#define CV_SET_ELEM_FREE_FLAG  [1 <<  (size? integer! * 8) - 1]

;Checks whether the element pointed by ptr belongs to a set or not
#define CV_IS_SET_ELEM ( ptr )  [ptr/ptr/flags >= 0]


;/************************************* Graph ********************************************/

{
  Graph is represented as a set of vertices.
  Vertices contain their adjacency lists (more exactly, pointers to first incoming or
  outcoming edge (or 0 if isolated vertex)). Edges are stored in another set.
  There is a single-linked list of incoming/outcoming edges for each vertex.

  Each edge consists of:
    two pointers to the starting and the ending vertices (vtx[0] and vtx[1],
    respectively). Graph may be oriented or not. In the second case, edges between
    vertex i to vertex j are not distingueshed (during the search operations).

    two pointers to next edges for the starting and the ending vertices.
    next[0] points to the next edge in the vtx[0] adjacency list and
    next[1] points to the next edge in the vtx[1] adjacency list.
}

#define CV_GRAPH_EDGE_FIELDS[      
    flags			[integer!];        
    weight			[integer!];    
    next			[byte-ptr!] ; pointer struct CvGraphEdge*  
    vtx				[byte-ptr!] ; pointer struct CvGraphVtx* 
]

CvGraphEdge!: alias struct! [ CV_GRAPH_EDGE_FIELDS ]

#define CV_GRAPH_VERTEX_FIELDS [    
    flags			[integer!];                
    first 			[CvGraphEdge!] ; pointer struct CvGraphEdge* ;
]

CvGraphVtx!: alias struct![CV_GRAPH_VERTEX_FIELDS]

CvGraphVtx2D!: alias struct! 
[
    CV_GRAPH_VERTEX_FIELDS
    ptr                    [CvPoint2D32f!]
]

;Graph is "derived" from the set (this is set a of vertices) and includes another set (edges)

#define CV_GRAPH_FIELDS[
    CV_SET_FIELDS
    edges     [CvSet!]; pointer CvSet* 
]

CvGraph!: alias struct! [CV_GRAPH_FIELDS]

#define CV_TYPE_NAME_GRAPH          "opencv-graph"

;/*********************************** Chain/Countour *************************************/

CvChain!: alias struct! [
	CV_SEQUENCE_FIELDS
        origin      [CvPoint!]
]

#define CV_CONTOUR_FIELDS [
    CV_SEQUENCE_FIELDS 
    ;rect           [_CvRect]
    rect_x          [integer!]
    rect_y          [integer!]
    rect_w          [integer!]
    rect_h          [integer!]
    color           [integer!];          
    reserved        [integer!];
]

CvContour!: alias struct! [CV_CONTOUR_FIELDS]

#define CvPoint2DSeq! CvContour! ;

;/****************************************************************************************\
;*                                    Sequence types                                      *
;\****************************************************************************************/

#define CV_SEQ_MAGIC_VAL             42990000h

CV_IS_SEQ: func [seq [cvSeq!] return: [logic!] /local v] [
    v: 0
    if seq <> NULL [v: v + 1]
    if (seq/flags and CV_MAGIC_MASK) = CV_SEQ_MAGIC_VAL [v: v + 1]
    either v = 2 [true][false]
]

#define CV_SET_MAGIC_VAL             42980000h

CV_IS_SET: func [set [cvSet!] return: [logic!] /local v] [
    v: 0
    if set <> NULL [v: v + 1]
    if (set/flags and CV_MAGIC_MASK) = CV_SEQ_MAGIC_VAL [v: v + 1]
    either v = 2 [true][false]
]

#define CV_SEQ_ELTYPE_BITS              9
#define CV_SEQ_ELTYPE_MASK              [((1 << CV_SEQ_ELTYPE_BITS) - 1)]

#define CV_SEQ_ELTYPE_POINT             [CV_32SC2]                       ;(x,y)
#define CV_SEQ_ELTYPE_CODE              [CV_8UC1]                        ;freeman code: 0..7 
#define CV_SEQ_ELTYPE_GENERIC           0
#define CV_SEQ_ELTYPE_PTR               [CV_USRTYPE1]
#define CV_SEQ_ELTYPE_PPOINT            [CV_SEQ_ELTYPE_PTR]              ; &(x,y)
#define CV_SEQ_ELTYPE_INDEX             [CV_32SC1]                       ;#(x,y) 
#define CV_SEQ_ELTYPE_GRAPH_EDGE        0                              ;&next_o, &next_d, &vtx_o, &vtx_d
#define CV_SEQ_ELTYPE_GRAPH_VERTEX      0                              ;first_edge, &(x,y)
#define CV_SEQ_ELTYPE_TRIAN_ATR         0                              ;vertex of the binary tree
#define CV_SEQ_ELTYPE_CONNECTED_COMP    0                              ;connected component
#define CV_SEQ_ELTYPE_POINT3D           [CV_32FC3]; (x,y,z)

#define CV_SEQ_KIND_BITS                3
#define CV_SEQ_KIND_MASK                [(1 << (CV_SEQ_KIND_BITS - 1) << CV_SEQ_ELTYPE_BITS)]

;types of sequences 
#define CV_SEQ_KIND_GENERIC             [(0 << CV_SEQ_ELTYPE_BITS)]
#define CV_SEQ_KIND_CURVE               [(1 << CV_SEQ_ELTYPE_BITS)]
#define CV_SEQ_KIND_BIN_TREE            [(2 << CV_SEQ_ELTYPE_BITS)]

;types of sparse sequences (sets) 
#define CV_SEQ_KIND_GRAPH               [(3 << CV_SEQ_ELTYPE_BITS)]
#define CV_SEQ_KIND_SUBDIV2D            [(4 << CV_SEQ_ELTYPE_BITS)]
#define CV_SEQ_FLAG_SHIFT               [(CV_SEQ_KIND_BITS + CV_SEQ_ELTYPE_BITS)]

;flags for curves 
#define CV_SEQ_FLAG_CLOSED              [(1 << CV_SEQ_FLAG_SHIFT)]
#define CV_SEQ_FLAG_SIMPLE              [(2 << CV_SEQ_FLAG_SHIFT)]
#define CV_SEQ_FLAG_CONVEX              [(4 << CV_SEQ_FLAG_SHIFT)]
#define CV_SEQ_FLAG_HOLE                [(8 << CV_SEQ_FLAG_SHIFT)]

;flags for graphs
#define CV_GRAPH_FLAG_ORIENTED          [(1 << CV_SEQ_FLAG_SHIFT)]
#define CV_GRAPH                        [(CV_SEQ_KIND_GRAPH)]
#define CV_ORIENTED_GRAPH               [(CV_SEQ_KIND_GRAPH|CV_GRAPH_FLAG_ORIENTED)]

;point sets 
#define CV_SEQ_POINT_SET                [(CV_SEQ_KIND_GENERIC or CV_SEQ_ELTYPE_POINT)]
#define CV_SEQ_POINT3D_SET              [(CV_SEQ_KIND_GENERIC or CV_SEQ_ELTYPE_POINT3D)]
#define CV_SEQ_POLYLINE                 [(CV_SEQ_KIND_CURVE  or CV_SEQ_ELTYPE_POINT)]
#define CV_SEQ_POLYGON                  [(CV_SEQ_FLAG_CLOSED or CV_SEQ_POLYLINE)]
#define CV_SEQ_CONTOUR                  [(CV_SEQ_POLYGON)]
#define CV_SEQ_SIMPLE_POLYGON           [(CV_SEQ_FLAG_SIMPLE or CV_SEQ_POLYGON)]

;chain-coded curves
#define CV_SEQ_CHAIN                    [(CV_SEQ_KIND_CURVE  or CV_SEQ_ELTYPE_CODE)]
#define CV_SEQ_CHAIN_CONTOUR            [(CV_SEQ_FLAG_CLOSED or CV_SEQ_CHAIN)]

;binary tree for the contour 
#define CV_SEQ_POLYGON_TREE             [(CV_SEQ_KIND_BIN_TREE  or CV_SEQ_ELTYPE_TRIAN_ATR)]

;sequence of the connected components
#define CV_SEQ_CONNECTED_COMP           [(CV_SEQ_KIND_GENERIC  or CV_SEQ_ELTYPE_CONNECTED_COMP)]

;sequence of the integer numbers
#define CV_SEQ_INDEX                    [(CV_SEQ_KIND_GENERIC  or CV_SEQ_ELTYPE_INDEX)]
#define CV_SEQ_ELTYPE( seq )            [(seq/ptr/ptr/flags and  CV_SEQ_ELTYPE_MASK)]
#define CV_SEQ_KIND( seq )              [(seq/ptr/ptr/flags and CV_SEQ_KIND_MASK)]

;lag checking
#define CV_IS_SEQ_INDEX (seq)           [(CV_SEQ_ELTYPE(seq) = CV_SEQ_ELTYPE_INDEX and CV_SEQ_KIND(seq) = CV_SEQ_KIND_GENERIC)]
#define CV_IS_SEQ_CURVE (seq)           [(CV_SEQ_KIND seq = CV_SEQ_KIND_CURVE)]
#define CV_IS_SEQ_CLOSED (seq)          [(seq/ptr/ptr/flags and CV_SEQ_FLAG_CLOSED <> 0)]
#define CV_IS_SEQ_CONVEX (seq)          [(seq/ptr/ptr/flags and CV_SEQ_FLAG_CONVEX <> 0)]
#define CV_IS_SEQ_HOLE (seq)            [(seq/ptr/ptr/flags and CV_SEQ_FLAG_HOLE <> 0)]
#define CV_IS_SEQ_SIMPLE (seq)          [(seq/ptr/ptr/flags & CV_SEQ_FLAG_SIMPLE <> 0 or CV_IS_SEQ_CONVEX(seq))]

;type checking macros 
#define CV_IS_SEQ_POINT_SET (seq)       [(CV_SEQ_ELTYPE (seq) = CV_32SC2 or CV_SEQ_ELTYPE (seq) =  CV_32FC2)]
#define CV_IS_SEQ_POINT_SUBSET (seq)    [(CV_IS_SEQ_INDEX (seq) or CV_SEQ_ELTYPE (seq) = CV_SEQ_ELTYPE_PPOINT)]
#define CV_IS_SEQ_POLYLINE (seq)        [(CV_SEQ_KIND (seq) = CV_SEQ_KIND_CURVE and CV_IS_SEQ_POINT_SET (seq))]
#define CV_IS_SEQ_POLYGON (seq)         [(CV_IS_SEQ_POLYLINE (seq) and CV_IS_SEQ_CLOSED(seq))]
#define CV_IS_SEQ_CHAIN (seq)           [(CV_SEQ_KIND(seq)  CV_SEQ_KIND_CURVE and seq/elem_size =1)]
#define CV_IS_SEQ_CONTOUR (seq)         [(CV_IS_SEQ_CLOSED(seq) and CV_IS_SEQ_POLYLINE(seq) or CV_IS_SEQ_CHAIN(seq))]
#define CV_IS_SEQ_CHAIN_CONTOUR (seq)   [(CV_IS_SEQ_CHAIN( seq ) and CV_IS_SEQ_CLOSED( seq ))]
#define CV_IS_SEQ_POLYGON_TREE (seq)    [(CV_SEQ_ELTYPE (seq) =  CV_SEQ_ELTYPE_TRIAN_ATR and CV_SEQ_KIND( seq ) = CV_SEQ_KIND_BIN_TREE)]
#define CV_IS_GRAPH (seq)               [(CV_IS_SET(seq) and CV_SEQ_KIND(seq) = CV_SEQ_KIND_GRAPH)]
#define CV_IS_GRAPH_ORIENTED (seq)      [(seq/ptr/ptr/flags and CV_GRAPH_FLAG_ORIENTED <> 0)]
#define CV_IS_SUBDIV2D (seq)            [(CV_IS_SET(seq) and CV_SEQ_KIND(seq) = CV_SEQ_KIND_SUBDIV2D)]

;/****************************************************************************************/
;/*                            Sequence writer & reader                                  */
;/****************************************************************************************/

#define CV_SEQ_WRITER_FIELDS [                                   
    header_size                 [integer!]                                                               
    seq			        [CvSeq!]                 ;CvSeq* the sequence written
    block 		        [CvSeqBlock!]	         ;CvSeqBlock* current block
    ptr			        [pointer! [byte!]]	 ;pointer to free space          
    block_min	                [pointer! [byte!]]       ; pointer to the beginning of block
    block_max	                [pointer! [byte!]]       ; pointer to the end of block
]
CvSeqWriter!: alias struct! [CV_SEQ_WRITER_FIELDS]

#define CV_SEQ_READER_FIELDS[                                   
    header_size                 [integer!]                                                               
    seq			        [CvSeq!]                ;CvSeq* the sequence written
    block 		        [CvSeqBlock!]	        ;CvSeqBlock* current block
    ptr			        [pointer! [byte!]]	;pointer to free space          
    block_min	                [pointer! [byte!]]      ; pointer to the beginning of block
    block_max	                [pointer! [byte!]]      ; pointer to the end of block
    delta_index                 [pointer! [integer!]]   ;= seq/first/start_index
    prev_elem                   [pointer! [byte!]]      ;pointer to previous element
]

CvSeqReader!: alias struct! [CV_SEQ_READER_FIELDS]

; cette structure est nkormalement définie dans cvTypes et elle ne restera pas ici 
CvChainPtReader!: alias struct! [
    CV_SEQ_READER_FIELDS
    code        [integer!];
    pt          [CvPoint!];  pt;
    deltas      [pointer! [integer!]] ;char deltas[8][2];
]

;/****************************************************************************************/
;/*                                Operations on sequences                               */
;/****************************************************************************************/

#define  CV_SEQ_ELEM( seq elem_type index )  [
    assert size? seq/first = size? CvSeqBlock! and size? seq/elem_size = size? elem_type
    either seq/first and index < seq/first/count [seq/first/data + index * (size? (elem_type))]
                                                  [CV_GET_SEQ_ELEM (int seq index)]
]

#define CV_GET_SEQ_ELEM (elem_type seq index ) [(CV_SEQ_ELEM ((seq) elem_type (index)))]

;/* macro that adds element to sequence
#define CV_WRITE_SEQ_ELEM_VAR ( elem_ptr writer ) [
    &writer: as byte-ptr! writer 
    if writer/ptr >= writer/block_max  [cvCreateSeqBlock &writer] ; new seq to add
     _copy-part writer/ptr elem_ptr writer/seq/ptr/elem_size ; copy memory dest source size 
     writer/ptr: writer/ptr + writer/ptr/elem_size ; increase struct address
]

#define  CV_WRITE_SEQ_ELEM ( elem writer ) [
    assert writer/seq = size? elem
    if writer/ptr >= writer/block_max  [cvCreateSeqBlock &writer] ; new seq to add
    assert writer/ptr <= (writer/block_max - size? elem)
    &elem: as byte-ptr! elem ; 
    _copy-part writer/ptr &elem size? elem_ptr
]

; move reader position forward
#define CV_NEXT_SEQ_ELEM ( elem_size reader )[
    &reader: as byte-ptr! reader
    if reader/ptr + elem_size >= reader/block_max [cvChangeSeqBlock &reader 1 ] ;&reader 
]

;move reader position backward
#define CV_PREV_SEQ_ELEM( elem_size reader )[
    &reader: as byte-ptr! reader
    if reader/ptr - elem_size < reader/block_min [cvChangeSeqBlock &reader 1 ] ;&reader 
]

;read element and move read position forward
#define CV_READ_SEQ_ELEM( elem reader )[
    assert reader/seq/elem_size = size? elem
    &elem: as byte-ptr! elem
    _copy-part &elem reader/ptr size? elem
    CV_NEXT_SEQ_ELEM ((size? elem_ptr) reader) 
]

; read element and move read position backward
#define CV_REV_READ_SEQ_ELEM( elem reader ) [
    assert reader/elem_size = size? elem
    &elem: as byte-ptr! elem
    _copy-part &elem reader/ptr size? elem
    CV_PREV_SEQ_ELEM ((size? elem) reader)  
]


#define CV_READ_CHAIN_POINT ( _pt reader ) [
    _pt: reader/pt
    if (reader/ptr <> null)                                                  
    [
        CV_READ_SEQ_ELEM (reader/code reader)
        assert reader/code and 7 = 0
        reader/pt/x: reader/pt/x +  reader/deltas/1 ;deltas[(int)(reader).code][0]
        reader/pt/y: reader/pt/y +  reader/deltas/2 ;deltas[(int)(reader).code][1]    
    ]   
]

#define CV_PREV_POINT(reader) [
    p: declare CvPoint!
    p/x: as integer! reader/ptr/prev_elem/1
    p/y: as integer! reader/ptr/prev_elem/2
    p    
]

#define CV_PREV_POINT(reader) [
    p: declare CvPoint!
    p/x: as integer! reader/ptr/prev_elem/1
    p/y: as integer! reader/ptr/prev_elem/2
    p    
]

#define CV_READ_EDGE( pt1 pt2 reader)   [
    p: size? CvPoint!
    p1: size? pt1
    p2: size? pt2
    assert (size? p1) = p
    assert p2 = p
    assert reader/ptr/seq/ptr/elem_size = p
    pt1: CV_PREV_POINT(reader)                   
    pt2: CV_CURRENT_POINT(reader)
    reader/ptr/prev_elem: as byte-ptr! reader/ptr
    CV_NEXT_SEQ_ELEM (p reader)
]

;************ Graph macros ************/

;returns next graph edge for given vertex 
#define  CV_NEXT_GRAPH_EDGE( edge vertex ) [
    assert edge/vtx/1 = vertex OR
    assert edge/vtx/2 = vertex OR
    assert edge/next/vtx/1 = vertex
]

;/****************************************************************************************\
;*             Data structures for persistence (a.k.a serialization) functionality        *
;\****************************************************************************************/
;
;/* "black box" file storage */
;typedef struct CvFileStorage CvFileStorage;


;/* storage flags */
#define CV_STORAGE_READ          0
#define CV_STORAGE_WRITE         1
#define CV_STORAGE_WRITE_TEXT    [CV_STORAGE_WRITE]
#define CV_STORAGE_WRITE_BINARY  [CV_STORAGE_WRITE]
#define CV_STORAGE_APPEND        2

;/* list of attributes */
CvAttrList!: alias struct! [
    attr		[c-string!] 	; char** NULL-terminated array of (attribute_name,attribute_value) pairs
    next		[CvAttrList!]	; CvAttrList* pointer to next chunk of the attributes list
]

cvAttrList: func [attr [c-string!] next [CvAttrList!] return: [CvAttrList!] /local l] [
    l: declare CvAttrList! 
    l/attr: attr;
    l/next: next;
    l
]

;struct CvTypeInfo;
#define CV_NODE_NONE        0
#define CV_NODE_INT         1
#define CV_NODE_INTEGER     [CV_NODE_INT]
#define CV_NODE_REAL        2
#define CV_NODE_FLOAT       [CV_NODE_REAL]
#define CV_NODE_STR         3
#define CV_NODE_STRING      [CV_NODE_STR]
#define CV_NODE_REF         4 ;/* not used */
#define CV_NODE_SEQ         5
#define CV_NODE_MAP         6
#define CV_NODE_TYPE_MASK   7

#define CV_NODE_TYPE(flags)  [flags and CV_NODE_TYPE_MASK]

;file node flags */
#define CV_NODE_FLOW        8 ; used only for writing structures to YAML format */
#define CV_NODE_USER        16
#define CV_NODE_EMPTY       32
#define CV_NODE_NAMED       64

#define CV_NODE_IS_INT(flags)        [CV_NODE_TYPE(flags) = CV_NODE_INT]
#define CV_NODE_IS_REAL(flags)       [CV_NODE_TYPE(flags) = CV_NODE_REAL]
#define CV_NODE_IS_STRING(flags)     [CV_NODE_TYPE(flags) = CV_NODE_STRING]
#define CV_NODE_IS_SEQ(flags)        [CV_NODE_TYPE(flags) = CV_NODE_SEQ]
#define CV_NODE_IS_MAP(flags)        [CV_NODE_TYPE(flags) = CV_NODE_MAP]
#define CV_NODE_IS_COLLECTION(flags) [CV_NODE_TYPE(flags) >= CV_NODE_SEQ]
#define CV_NODE_IS_FLOW(flags)       [flags and CV_NODE_FLOW <> 0]
#define CV_NODE_IS_EMPTY(flags)      [flags and CV_NODE_EMPTY <> 0]
#define CV_NODE_IS_USER(flags)       [flags and CV_NODE_USER <> 0]
#define CV_NODE_HAS_NAME(flags)      [flags and CV_NODE_NAMED <> 0]

#define CV_NODE_SEQ_SIMPLE 256
#define CV_NODE_SEQ_IS_SIMPLE(seq)  [(seq/flags and CV_NODE_SEQ_SIMPLE <> 0)]

CvString!: alias struct! [
    len 	[integer!]
    ptr		[c-string!]
]

{all the keys (names) of elements in the readed file storage
are stored in the hash to speed up the lookup operations }

CvStringHashNode!: alias struct! [
    hashval			[integer!];
    str				[Cvstring!]		; should be CvString!
    next			[CvStringHashNode!]	;pointer to  CvStringHashNode* ;
]

; when using C++
CvTypeInfo!: alias struct!
[
    flags				[integer!];
    header_size			        [integer!];
    prev				[CvTypeInfo!]	; pointer CvTypeInfo;
    next				[CvTypeInfo!]	; pointer CvTypeInfo;
    type_name			        [c-string!];
    is_instance			        [byte-ptr!]	;pointer to function CvIsInstanceFunc TBD
    release				[byte-ptr!]	;pointer to function CvReleaseFunc ;
    read				[byte-ptr!]      ;CvReadFunc ;
    write				[byte-ptr!]      ;CvWriteFunc write;
    clone				[byte-ptr!]      ;CvCloneFunc ;
]

CvFileNode!: alias struct! [
    tag			[integer!];
    info 		[CvTypeInfo!]; CvTypeInfo* info; /* type information (only for user-defined object, for others it is 0)
    data 		[byte-ptr!] ; pointer to union double, int, CbString, CvSeq* CvFileNodeHash*
]

;/**** System data types ******/

CvPluginFuncInfo!: alias struct! [
    func_addr			[byte-ptr!]; void pointer
    default_func_addr	        [byte-ptr!]; void pointer
    func_names			[c-string!];
    search_modules		[integer!];
    loaded_from			[integer!];
]

CvModuleInfo!: alias struct!
[
    _next			[CvModuleInfo!]	    ;pointer CvModuleInfo;
    name			[c-string!]
    version			[c-string!]
    func_tab		        [CvPluginFuncInfo!] ;pointer CvPluginFuncInfo! ;
]

