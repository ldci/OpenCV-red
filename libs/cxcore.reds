Red/System [
	Title:		"OpenCV cxcore"
	Author:		"Franois Jouen"
	Rights:		"Copyright (c) 2012-2013 Franois Jouen. All rights reserved."
	License: 	"BSD-3 - https:;github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

;cxcore

;#include %cxtypes.reds ; for standalone testing
;#include %cvtypes.reds ; for standalone testing

;**************** some structures required by cvcore *********

CvNArrayIterator!: alias struct! [
    count		[integer!]; number of arrays
    dims		[integer!]; number of dimensions to iterate
    ;size		[CvSize!]; maximal common linear size: { width = size, height = 1 }
    width		[integer!]
    height!		[integer!]
    ptr			[byte-ptr!];pointers to the array slices [CV_MAX_ARR]
    stack		[integer!]; for internal use [CV_MAX_DIM
    hdr			[integer!];/* pointers to the headers of the CvMatND! matrices that are processed [CV_MAX_ARR] ; may be we need a CvMatND! struct!  
]

;graph scanner
CvGraphScanner!: alias struct!  [ 
            vtx 		[CvGraphVtx!] ; current graph vertex (or current edge origin) 
            dst     		[CvGraphVtx!] ; current graph edge destination vertex 
            edge   		[CvGraphEdge!]  ; current edge 
            graph      		[CvGraph!] ; the graph 
            stack		[CvSeq!] ; the graph vertex stack 
            index		[integer!]        ; the lower bound of certainly visited vertices 
            mask 		[integer!]        ; event mask 
]

CvFont!: alias struct! [
    font_face 	        [integer!]; /* =CV_FONT_* */
    ascii 		[pointer![integer!]]; int* /* font data and metrics */
    greek		[pointer![integer!]]; int*
    cyrillic	        [pointer![integer!]]; int*
    hscale 		[float!]
    vscale		[float!]
    shear		[float!] ; /* slope coefficient: 0 - normal, >0 - italic */
    thickness	        [integer!] ; /* letters thickness */
    dx			[float!]; /* horizontal interval between letters */
    line_type	        [integer!];
]

CvTreeNodeIterator!: alias struct! [
    node                [byte-ptr!]
    level               [integer!]
    max_level           [integer!]  
]

;RED/S version of orginal typedef int (CV_CDECL *CvErrorCallback)
CvErrorCallback!: alias struct! [
    status              [integer!]
    func_name           [c-string!]
    err_msg             [c-string!]
    file_name           [c-string!]
    line                [integer!]
    userdata            [byte-ptr!]    
]
 


#import [
    cxcore cdecl [
        ccvAlloc: "cvAlloc" [
            size    [integer!]
        ]
        cvFree: "cvFree" [
            ptr	    [double-byte-ptr!] ; in fact double pointer
	]
        ;Rebol Specific ; normally we have to use a CvSize! structure to creates images or header
        ; but we returns a block of value so we used 2 integers (width and height)
        
        
        cvCreateImageHeader: "cvCreateImageHeader"[
        "Allocates and initializes IplImage header"
            width 		[integer!] ;CvSize/width
            height 		[integer!] ;CvSize/height
            depth		[integer!]
            channels    [integer!]
            return:     [IplImage!] 
        ]
        cvInitImageHeader: "cvInitImageHeader" [
        "Inializes IplImage header"
            image		[IplImage!] ;structure considered as pointer
            width 		[integer!] ;CvSize/width
            height 		[integer!] ;CvSize/height
            depth		[integer!]
            channels	        [integer!]
            origin		[integer!];CV_DEFAULT(0)
            align		[integer!];CV_DEFAULT(4)
            return:             [IplImage!]  
        ]
        cvCreateImage: "cvCreateImage" [
        "Creates IPL image (header and data). Can  be used by highgui!!!"
            width 		[integer!] ;CvSize/width
            height 		[integer!] ;CvSize/height
            depth 		[integer!]
            channels 	        [integer!]
            return: 	        [IplImage!] ; returns an iplImage structure
        ]
        cvReleaseImageHeader: "cvReleaseImageHeader" [
        "Releases (i.e. deallocates) IPL image header"
            image		[IplImage!]
        ]
        cvReleaseImage: "cvReleaseImage" [
        "Releases IPL image header and data"
            **image		[double-byte-ptr!] ;IplImage** image (use as byte-ptr! IplImage since IplImage is still a pointer ( a struct))
        ]
        cvCloneImage: "cvCloneImage" [
            image		[IplImage!]
            return: 	        [IplImage!] 
        ]
        cvSetImageCOI: "cvSetImageCOI" [
        "Sets a Channel Of Interest (only a few functions support COI) - use cvCopy to extract the selected channel and/or put it back"
            image		[IplImage!]
            coi			[integer!]
        ]
        cvGetImageCOI: "cvGetImageCOI" [
        "Retrieves image Channel Of Interest"
            image		[IplImage!]
            return: 	        [integer!] 
        ]
        cvSetImageROI: "cvSetImageROI" [
        "Sets image ROI (region of interest) (COI is not changed)"
            image		[IplImage!]
            rect_x		[integer!]  ; CvRect not a pointer
            rect_y		[integer!]
            rect_w		[integer!]
            rect_h		[integer!]
        ]
        cvResetImageROI: "cvResetImageROI" [
        "Resets image ROI and COI"
            image		[IplImage!]
        ]
        cvGetImageROI:"cvGetImageROI" [
            image		[IplImage!]    
            return: 	        [_CvRect] ; not a pointer 
        ]
        cvCreateMatHeader: "cvCreateMatHeader" [
        "Allocates and initalizes CvMat header"
            rows	[integer!]
            cols	[integer!]
            type	[integer!]
            return:	[CvMat!] 
        ]
        #define CV_AUTOSTEP             7FFFFFFFh
        
        cvInitMatHeader: "cvInitMatHeader" [
        "Initializes CvMat header"
            mat	        [CvMat!]
            rows	[integer!]
            cols	[integer!]
            type	[integer!]
            data    [byte-ptr!] ; void null 
            step	[integer!] ; CV_DEFAULT(CV_AUTOSTEP)
        ]
        
        cvCreateMat: "cvCreateMat"[
        "Allocates and initializes CvMat header and allocates data"
            rows	[integer!]
            cols	[integer!]
            type 	[integer!]
            return:	[CvMat!]
        ]
        
        cvReleaseMat: "cvReleaseMat" [
        "Releases CvMat header and deallocates matrix data (reference counting is used for data)"
            **mat	[double-byte-ptr!] ;use a byte-ptr CVmat! double pointer
        ]
        
        cvCloneMat: "cvCloneMat" [
        "Creates an exact copy of the input matrix (except, may be, step value)"
            mat	        [CvMat!]
            return:	[CvMat!]
        ]
        
        cvGetSubRect: "cvGetSubRect" [
        "Makes a new matrix from <rect> subrectangle of input array No data is copied"
            arr			[CvArr!] ; cvArr* : pointer to generic array
            submat		[CvMat!]
            rect_x		[integer!]  ; CvRect not a pointer
    		rect_y		[integer!]
    		rect_w		[integer!]
    		rect_h		[integer!]
            return:	    [CvMat!]    
        ]
        cvGetRows: "cvGetRows" [
        "Selects row span of the input array: arr(start_row:delta_row:end_row (end_row is not included into the span)"
            arr			[CvArr!] ; cvArr* : pointer to generic array
            submat		[CvMat!]
            start_row   [integer!]
            end_row		[integer!]
            delta_row	[integer!] ; CV_DEFAULT(1)
            return:	    [CvMat!]     
        ]
        cvGetCols: "cvGetCols" [
            arr			[CvArr!] ; cvArr* : pointer to generic array
            submat		[CvMat!]
            start_col   [integer!]
            end_col		[integer!]
            return:	    [CvMat!]     
        ]
        cvGetDiag: "cvGetDiag" [
        {Select a diagonal of the input array. (diag = 0 means the main diagonal, >0 means a diagonal above the main one,
        <0 - below the main one). The diagonal will be represented as a column (nx1 matrix)}    
            arr			[CvArr!] ; cvArr* : pointer to generic array
            submat		[CvMat!]
            diag		[integer!];CV_DEFAULT(0)
            return:	        [CvMat!] 
        ]
        
        cvScalarToRawData: "cvScalarToRawData" [
        "low-level scalar <-> raw data conversion functions"
            scalar		[CvScalar!]	
            data		[byte-ptr!]; *void
            type		[integer!]
            extend_to_12	[integer!];CV_DEFAULT(0)
        ]
        cvRawDataToScalar: "cvRawDataToScalar"[
        "low-level raw data conversion <-> scalar  functions"
            data		[byte-ptr!]; *void
            type		[integer!]
            scalar		[CvScalar!]
        ]
        cvCreateMatNDHeader: "cvCreateMatNDHeader" [
        "Allocates and initializes CvMatND header"
            dims		[integer!]
            sizes		[int-ptr!] ;int* sizes
            type		[integer!]
            return:		[CvMatND!]
        ]
        cvCreateMatND: "cvCreateMatND" [
        "Allocates and initializes CvMatND header and allocates data"
            dims		[integer!]
            sizes		[int-ptr!] ;int* sizes
            type		[integer!]
            return:		[CvMatND!]
        ]
        cvInitMatNDHeader: "cvInitMatNDHeader" [
        "Initializes preallocated CvMatND header"
            mat			[CvMatND!]
            dims		[integer!]
            sizes		[int-ptr!] ;int* sizes
            type		[integer!]
            data		[byte-ptr!]; *void  CV_DEFAULT(NULL)
            return:		[CvMatND!]
        ]
        
        cvCloneMatND: "cvCloneMatND" [
        "Creates a copy of CvMatND (except, may be, steps)"
            mat		         [CvMatND!]
            return:	         [CvMatND!]
        ]
        
        cvCreateSparseMat: "cvCreateSparseMat" [
        "Allocates and initializes CvSparseMat header and allocates data"
            dims		 [integer!]
            sizes		 [int-ptr!] ;int* sizes
            type		 [integer!]
            return:		 [CvSparseMat!]
        ]
        
        cvReleaseSparseMat: "cvReleaseSparseMat" [
        "Releases CvSparseMat"
            mat                 [double-byte-ptr!] ;CvSparseMat** mat double pointer
        ]
        
        cvCloneSparseMat: "cvCloneSparseMat" [
        "Creates a copy of CvSparseMat (except, may be, zero items)"
            mat 	            [CvSparseMat!]
            return:             [CvSparseMat!]
        ]
        
        cvInitSparseMatIterator: "cvInitSparseMatIterator" [
        "Initializes sparse array iterator (returns the first node or NULL if the array is empty)"
            mat 		        [CvSparseMat!]
            mat_iterator	    [CvSparseMatIterator!]
            return: 		    [CvSparseNode!]
        ]
        
        ;**************** matrix iterator: used for n-array operations on dense arrays *********
        
        #define CV_MAX_ARR              10
        #define CV_NO_DEPTH_CHECK       1
        #define CV_NO_CN_CHECK          2
        #define CV_NO_SIZE_CHECK        4
        
        cvInitNArrayIterator: "cvInitNArrayIterator" [
        {Initializes iterator that traverses through several arrays simulteneously.
        (the function together with cvNextArraySlice is used for N-ari element-wise operations)}
            count		        [integer!]
            arrs			[CvArr!] ; double pointer
            mask			[CvArr!] ;; double pointer
            stubs			[CvMatND!]
            array_iterator	        [CvNArrayIterator!]
            flags			[integer!] ;CV_DEFAULT(0)
            return:			[integer!] 
            
        ]
        
        cvNextNArraySlice: "cvNextNArraySlice" [
        "Returns zero value if iteration is finished, non-zero (slice length) otherwise"
            array_iterator	        [CvNArrayIterator!]
            return:			[integer!] 
        ]
        
        cvGetElemType: "cvGetElemType" [
        "Returns type of array elements: CV_8UC1 ... CV_64FC4 ... "
            arr			[CvArr!]
            return:		[integer!]
            
        ]
        
        cvGetDims: "cvGetDims" [
        "Retrieves number of an array dimensions and optionally sizes of the dimensions"
            arr			[CvArr!]
            sizes		[int-ptr!] ;CV_DEFAULT(NULL) 
            return:		[integer!]   
        ]
        
        cvGetDimSize: "cvGetDimSize" [
        {Retrieves size of a particular array dimension.
        For 2d arrays cvGetDimSize(arr,0) returns number of rows (image height) and cvGetDimSize(arr,1) returns number}
            arr			[CvArr!]
            index		[int-ptr!]; CV_DEFAULT(NULL)
            return:		[integer!]
        ]
        
        cvPtr1D: "cvPtr1D" [
            arr			[CvArr!]
            idx0		[integer!]; 
            type		[int-ptr!]; CV_DEFAULT(NULL)
            return:		[byte-ptr!]
        ]
        
        cvPtr2D: "cvPtr2D" [
            arr			[CvArr!]
            idx0		[integer!]; 
            idx1		[integer!];
            type		[int-ptr!]; CV_DEFAULT(NULL)
            return:		[byte-ptr!]           
        ]
        cvPtr3D: "cvPtr3D" [
            arr			[CvArr!]
            idx0		[integer!]; 
            idx1		[integer!];
            idx2		[integer!];
            type		[int-ptr!]; CV_DEFAULT(NULL) 
            return:		[byte-ptr!]           
        ]
        
        cvPtrND: "cvPtrND" [
        {For CvMat or IplImage number of indices should be 2
        (row index (y) goes first, column index (x) goes next).
        For CvMatND or CvSparseMat number of infices should match number of <dims> and
        indices order should match the array dimension order}
            arr			[CvArr!]
            idx			[integer!]; 
            type                [int-ptr!]; CV_DEFAULT(NULL) 
            create_node		[int-ptr!];CV_DEFAULT(1)
            precalc_hashval	[int-ptr!]; CV_DEFAULT(NULL)
            return:		[byte-ptr!]
            
        ]
        ;value = arr(idx0,idx1,...)
        cvGet1D: "cvGet1D" [
            arr		        [CvArr!]
            idx0		[integer!]
            return:		[_CvScalar] ; not a pointer	          
        ]
        cvGet2D: "cvGet2D" [
            arr		        [CvArr!]
            idx0		[integer!]
            idx1		[integer!]
            return:		[_CvScalar] ; not a pointer	          
        ]
        cvGet3D: "cvGet3D" [
            arr		        [CvArr!]
            idx0		[integer!]
            idx1		[integer!]
            idx2		[integer!]
            return:		[_CvScalar] ; not a pointer	          
        ]
        cvGetND: "cvGetND" [
            arr		        [CvArr!]
            idx 		[pointer! [integer!]] 
            return:		[_CvScalar] ; not a pointer	
        ]
        
        ;for 1-channel arrays
        cvGetReal1D: "cvGetReal1D" [
            arr		        [CvArr!]
            idx0		[integer!]
            return:             [float!]
        ]
        
        cvGetReal2D: "cvGetReal2D" [
            arr		        [CvArr!]
            idx0		[integer!]
            idx1		[integer!]
            return:             [float!]
        ]
        cvGetReal3D: "cvGetReal3D" [
            arr		        [CvArr!]
            idx0		[integer!]
            idx1		[integer!]
            idx2		[integer!]
            return:             [float!]
        ]
        cvGetRealND: "cvGetRealND" [
            arr		        [CvArr!]
            idx 		[pointer! [integer!]] 
            return:		[float!]	
        ]
        
        ;arr(idx0,idx1,...) = value
        cvSet1D: "cvSet1D" [
            arr		        [CvArr!]
            idx0		[integer!]
            value               [_CvScalar] 
        ]
        cvSet2D: "cvSet2D" [
            arr		        [CvArr!]
            idx0		[integer!]
            idx1		[integer!]
            value               [_CvScalar] 
        ]
        cvSet3D: "cvSet3D" [
            arr		        [CvArr!]
            idx0		[integer!]
            idx1		[integer!]
            idx2		[integer!]
            value               [_CvScalar] 
        ]
        cvSetND: "cvSetND" [
            arr		        [CvArr!]
            idx 		[int-ptr!] 
            value               [_CvScalar]	
        ]
        
        cvSetReal1D: "cvSetReal1D" [
            arr		        [CvArr!]
            idx0		[integer!]
            value		[float!]
        ]
        cvSetReal2D: "cvSetReal2D" [
            arr		        [CvArr!]
            idx0		[integer!]
            idx1		[integer!]
            value		[float!]
        ]
        cvSetReal3D: "cvSetReal3D" [
            arr		        [CvArr!]
            idx0		[integer!]
            idx1		[integer!]
            idx2		[integer!]
            value		[float!]
        ]
        cvSetRealND: "cvSetRealND" [
            arr		        [CvArr!]
            idx 		[int-ptr!] 
            value		[float!]
        ]
        cvClearND: "cvClearND" [
        "clears element of ND dense array, in case of sparse arrays it deletes the specified node"
            arr		        [CvArr!]
            idx 		[int-ptr!]
        ]
        ;Converts CvArr (IplImage or CvMat,...) to CvMat.
        ;If the last parameter is non-zero, function can
        ;convert multi(>2)-dimensional array to CvMat as long as
        ;the last array's dimension is continous. The resultant
        ;matrix will be have appropriate (a huge) number of rows
        cvGetMat: "cvGetMat" [
        "Converts CvArr (IplImage or CvMat,...) to CvMat."
            arr		        [CvArr!]
            header		[CvMat!]
            coi			[int-ptr!];CV_DEFAULT(NULL)
            allowND		[integer!];CV_DEFAULT(0)
            return: 	        [CvMat!]
        ]
        
        cvGetImage: "cvGetImage" [
        "Converts CvArr (IplImage or CvMat) to IplImage"
            arr		        [CvArr!]
            image_header 	[IplImage!]
            return: 		[IplImage!]	
        ]
        ;Changes a shape of multi-dimensional array.
        ;new_cn == 0 means that number of channels remains unchanged.
        ;new_dims == 0 means that number and sizes of dimensions remain the same
        ;(unless they need to be changed to set the new number of channels)
        ;if new_dims == 1, there is no need to specify new dimension sizes
        ;The resultant configuration should be achievable w/o data copying.
        ;If the resultant array is sparse, CvSparseMat header should be passed
        ;to the function else if the result is 1 or 2 dimensional,
        ;CvMat header should be passed to the function else CvMatND header should be passed
        
        cvReshapeMatND: "cvReshapeMatND" [
        "Changes a shape of multi-dimensional array."
            arr		        [CvArr!]
            sizeof_header	[integer!]
            header		[CvArr!]
            new_cn		[integer!]
            new_dims		[integer!]
            new_sizes		[int-ptr!]
            return: 		[CvArr!]
        ]
        #define cvReshapeND (arr header new_cn new_dims new_sizes) [cvReshapeMatND arr size? header header new_cn new_dims new_sizes]
        
        cvReshape: "cvReshape" [
            arr		        [CvArr!]
            header		[CvMat!]
            new_cn		[integer!]
            new_rows		[integer!];CV_DEFAULT(0)
            return: 		[CvMat!]   
        ]
        
        cvRepeat: "cvRepeat" [
        "Repeats source 2d array several times in both horizontal and vertical direction to fill destination array"
            src		        [CvArr!]
            dest		[CvArr!]   
        ]
        
        cvCreateData: "cvCreateData" [
             arr		 [CvArr!]
        ]
        
        cvReleaseData: "cvReleaseData" [
		"releases array data"
			arr		[double-byte-ptr!] ;  pointer to CvArr!
		]  
        
        ;Attaches user data to the array header. The step is reffered to
        ;the pre-last dimension. That is, all the planes of the array must be joint (w/o gaps)
        
        cvSetData: "cvSetData" [
        "Attaches user data to the array header"
            arr		        [CvArr!]
            data	        [byte-ptr!];void* pointer 
            step	        [integer!]
        ]
        
        ;Retrieves raw data of CvMat, IplImage or CvMatND.
        ;In the latter case the function raises an error if the array can not be represented as a matrix
        
        cvGetRawData: "cvGetRawData" [
        "Retrieves raw data of CvMat, IplImage or CvMatND"
            arr		        [CvArr!]
            data	        [byte-ptr!];uchar** pointer 
            step	        [int-ptr!] ;CV_DEFAULT(NULL)
            roi_size		[CvSize!];CV_DEFAULT(NULL) 
        ]
        
        
        cvGetSize: "cvGetSize" [
        "Returns width and height of array in elements"
            arr		        [CvArr!]
            return:         [_CvSize] ; not a pointer
        ]
             
        
        cvCopy: "cvCopy" [
        "Copies source array to destination array"
            src		    [CvArr!]
            dest		[CvArr!]
            mask		[CvArr!]   
        ]
        
        cvSet: "cvSet" [
        "Sets all or masked elements of input array to the same value"
            arr			[CvArr!]
            v0			[float!]; CvScalar not a pointer
            v1			[float!]
            v2			[float!]
            v3			[float!]
            mask		[CvArr!] ; CV_DEFAULT(NULL) 
        ]
        
        cvSetZero: "cvSetZero" [
        "Clears all the array elements (sets them to 0)"
            arr			[CvArr!]
        ]
        #define cvZero  cvSetZero
        
        cvSplit: "cvSplit" [
        "Splits a multi-channel array into the set of single-channel arrays or extracts particular [color] plane"
            src			[CvArr!]
            dst0		[CvArr!]
            dst1		[CvArr!]
            dst2		[CvArr!]
            dst3		[CvArr!]       
        ]
        
        cvMerge: "cvMerge" [
        "Merges a set of single-channel arrays into the single multi-channel array or inserts one particular [color] plane to the array"
            src0		[CvArr!]
            src1		[CvArr!]
            src2		[CvArr!]
            src3		[CvArr!]
            dst 		[CvArr!] 
        ]
        
        cvMixChannels: "cvMixChannels" [
        "Copies several channels from input arrays to certain channels of output arrays"
            src			[CvArr!] 
            src_count	        [integer!]
            dst			[CvArr!] 
            dst_count	        [integer!]
            from_to		[int-ptr!]
            pair_count 	        [integer!]	   
        ]
        
        ;Performs linear transformation on every source array element: dst(x,y,c) = scale*src(x,y,c)+shift.
        ;Arbitrary combination of input and output array depths are allowed (number of channels must be the same), thus the function can be used for type conversion
        
        cvConvertScale: "cvConvertScale" [
        "Performs linear transformation on every source array element"
            src			[CvArr!] 
            dst			[CvArr!] 
            scale		[float!];CV_DEFAULT(1)
            shift		[float!];CV_DEFAULT(0)
        ]
        #define cvCvtScale cvConvertScale
        #define cvScale  cvConvertScale
        #define cvConvert( src dst )  [cvConvertScale( (src) (dst) 1 0 )]
        
        ;Performs linear transformation on every source array element,
        ;stores absolute value of the result: dst(x,y,c) = abs(scale*src(x,y,c)+shift).
        ;destination array must have 8u type.In other cases one may use cvConvertScale + cvAbsDiffS}
        
        cvConvertScaleAbs: "cvConvertScaleAbs" [
        "Performs linear transformation on every source array element"
            src			[CvArr!] 
            dst			[CvArr!] 
            scale		[float!];CV_DEFAULT(1)
            shift		[float!];CV_DEFAULT(0)
        ]
        #define cvCvtScaleAbs  cvConvertScaleAbs
        
        ;checks termination criteria validity and sets eps to default_eps (if it is not set),
        ;max_iter to default_max_iters (if it is not set)
        cvCheckTermCriteria: "cvCheckTermCriteria" [
        "Checks termination criteria validity and sets eps to default_eps (if it is not set)."
            criteria			[CvTermCriteria!]
            default_eps			[float!]
            default_max_iters 	[integer!]
            return: 			[CvTermCriteria!]  
        ]
        ;****************************************************************************************\
        ;*                   Arithmetic, logic and comparison operations                          *
        ;****************************************************************************************/
        cvAdd:"cvAdd" [
        "dst(mask) = src1(mask) + src2(mask)"
            src1			[CvArr!]
            src2			[CvArr!]
            dst				[CvArr!]
            mask			[CvArr!];CV_DEFAULT(NULL)
        ]
        
        cvAddS: "cvAddS" [
        "dst(mask) = src(mask) + value"
            src 			[CvArr!]
           ; value			[_CvScalar]
           v0               [float!]    
           v1               [float!]
           v2               [float!]
           v3               [float!]
           dst				[CvArr!]
           mask				[CvArr!];CV_DEFAULT(NULL)  
        ]
        cvSub: "cvSub" [
        "dst(mask) = src1(mask) - src2(mask)"
            src1			[CvArr!]
            src2			[CvArr!]
            dst				[CvArr!]
            mask			[CvArr!];CV_DEFAULT(NULL)
        ]
        
        cvSubRS: "cvSubRS" [
        "dst(mask) = value - src(mask)"
            src 			[CvArr!]
            v0              [float!]    
            v1              [float!]
            v2              [float!]
            v3              [float!]
            dst				[CvArr!]
            mask			[CvArr!];CV_DEFAULT(NULL)  
        ]
        
        cvMul: "cvMul" [
        "dst(idx) = src1(idx) * src2(idx) * scale (scaled element-wise multiplication of 2 arrays)"
            src1			[CvArr!]
            src2			[CvArr!]
            dst				[CvArr!]
            scale			[float!];CV_DEFAULT(1)
        ]
        cvDiv: "cvDiv" [
        "element-wise division/inversion with scaling: dst(idx) = src1(idx) * scale / src2(idx) or dst(idx) = scale / src2(idx) if src1 == 0"    
            src1			[CvArr!]
            src2			[CvArr!]
            dst				[CvArr!]
            scale			[float!];CV_DEFAULT(1)   
        ]
        
        cvScaleAdd: "cvScaleAdd" [
        "dst = src1 * scale + src2"
            src1			[CvArr!]
            ;scale			[_CvScalar]
            v0                          [float!]    
            v1                          [float!]
            v2                          [float!]
            v3                          [float!]
            src2			[CvArr!]
            dst				[CvArr!]
        ]
        #define cvAXPY ( A real_scalar B C )  [cvScaleAdd(A cvRealScalar real_scalar B C)]
        
        cvAddWeighted: "cvAddWeighted" [
        "dst = src1 * alpha + src2 * beta + gamma"
            src1			[CvArr!]
            alpha			[float!]
            src2			[CvArr!]
            beta		        [float!]
            gamma			[float!]
            dst				[CvArr!]
        ]
        cvDotProduct: "cvDotProduct" [
        "result = sum_i(src1(i) * src2(i)) (results for all channels are accumulated together)"
            src1			[CvArr!]
            src 			[CvArr!]
            return:                     [float!]
        ]
        
        cvAnd: "cvAnd" [
        "dst(idx) = src1(idx) & src2(idx)"
            src1			[CvArr!]
            src2			[CvArr!]
            dst				[CvArr!]
            mask			[CvArr!];CV_DEFAULT(NULL)
        ]
        cvAndS: "cvAndS" [
        "dst(idx) = src(idx) & value"
            src1			[CvArr!]
            v0              [float!]  ;CvScalar  
            v1              [float!]
            v2              [float!]
            v3              [float!]
            dst				[CvArr!]
            mask			[CvArr!];CV_DEFAULT(NULL)
        ]
        cvOr: "cvOr" [
        "dst(idx) = src1(idx) | src2(idx)"
            src1			[CvArr!]
            src2			[CvArr!]
            dst				[CvArr!]
            mask			[CvArr!];CV_DEFAULT(NULL)
        ]
        cvOrS: "cvOrS" [
        "dst(idx) = src(idx) | value"
            src1			[CvArr!]
            v0              [float!]  ;CvScalar  
            v1              [float!]
            v2              [float!]
            v3              [float!]
            dst				[CvArr!]
            mask			[CvArr!];CV_DEFAULT(NULL)
        ]
        cvxOr: "cvXor" [
        "dst(idx) = src1(idx) ^ src2(idx)"
            src1			[CvArr!]
            src2			[CvArr!]
            dst				[CvArr!]
            mask			[CvArr!];CV_DEFAULT(NULL)
        ]
        cvXorS: "cvXorS" [
        "dst(idx) = src(idx) ^ value"
            src1			[CvArr!]
            v0              [float!]  ;CvScalar  
            v1              [float!]
            v2              [float!]
            v3              [float!]
            dst				[CvArr!]
            mask			[CvArr!];CV_DEFAULT(NULL)
        ]
        cvNot: "cvNot" [
        "dst(idx) = ~src(idx)"
            src		                [CvArr!]
            dst				[CvArr!]
        ]
        cvInRange: "cvInRange" [
        ";dst(idx) = lower <= src(idx) < upper"
            src		                [CvArr!]
            lower                       [CvArr!]
            upper                       [CvArr!]
            dst				[CvArr!]    
        ]
        
        cvInRangeS: "cvInRangeS" [
        ";dst(idx) = lower <= src(idx) < upper"
            src		                [CvArr!]
            ;lower                      [_CvScalar]
            lower_v0                    [float!]    
            lower_v1                    [float!]
            lower_v2                    [float!]
            lower_v3                    [float!]
            ;upper                      [_CvScalar]
            upper_v0                    [float!]    
            upper_v1                    [float!]
            upper_v2                    [float!]
            upper_v3                    [float!]
            dst				[CvArr!]    
        ]
        
        #define CV_CMP_EQ   0
        #define CV_CMP_GT   1
        #define CV_CMP_GE   2
        #define CV_CMP_LT   3
        #define CV_CMP_LE   4
        #define CV_CMP_NE   5
        
        cvCmp: "cvCmp" [
        "The comparison operation support single-channel arrays only. Destination image should be 8uC1 or 8sC1 dst(idx) = src1(idx) _cmp_op_ src2(idx)"
            src1			[CvArr!]
            src2			[CvArr!]
            dst				[CvArr!]
            cmp_op			[integer!]
        ]
        
        cvCmpS: "cvCmpS" [
        "dst(idx) = src1(idx) _cmp_op_ value"
            src 			[CvArr!]
            value			[float!]
            dst				[CvArr!]
            cmp_op			[integer!]
        ]
        
        cvMin: "cvMin" [
        "dst(idx) = min(src1(idx),src2(idx)"
            src1			[CvArr!]
            src2			[CvArr!]
            dst				[CvArr!]
        ]
        
        cvMax: "cvMax" [
        "dst(idx) = max(src1(idx),src2(idx)"
            src1			[CvArr!]
            src2			[CvArr!]
            dst				[CvArr!]
        ]
        
        cvMinS: "cvMinS" [
        "dst(idx) = min(src(idx),value)"
            src 			[CvArr!]
            value			[float!]
            dst				[CvArr!]
        ]
        
        cvMaxS: "cvMaxS" [
        "dst(idx) = max(src(idx),value)"
            src 			[CvArr!]
            value			[float!]
            dst				[CvArr!]
        ]
        
        cvAbsDiff: "cvAbsDiff" [
        "dst(x,y,c) = abs(src1(x,y,c) - src2(x,y,c)"
            src1			[CvArr!]
            src2			[CvArr!]
            dst				[CvArr!]
        ]
        
        cvAbsDiffS: "cvAbsDiffS" [
        "dst(x,y,c) = abs(src(x,y,c) - value(c)"
            src 			[CvArr!]
            v0              [float!]  ;CvScalar  
            v1              [float!]
            v2              [float!]
            v3              [float!]
            dst				[CvArr!]
        ]
        #define cvAbs ( src dst ) [(cvAbsDiffS( (src) (dst) cvScalarAll(0)))]

        ;/****************************************************************************************\
        ;*                                Math operations                                         *
        ;\****************************************************************************************
        
        cvCartToPolar: "cvCartToPolar" [
        " ;Does cartesian->polar coordinates conversion. Either of output components (magnitude or angle) is optional"
            x					[CvArr!]
            y					[CvArr!]
            magnitude			[CvArr!]
            angle				[CvArr!]; CV_DEFAULT(NULL)
            angle_in_degrees	[integer!]; CV_DEFAULT(0)   
        ]
        
        cvPolarToCart: "cvPolarToCart" [
        "Does polar->cartesian coordinates conversion.Either of output components (magnitude or angle) is optional.If magnitude is missing it is assumed to be all 1's"
            magnitude			[CvArr!]
            angle				[CvArr!]
            x					[CvArr!]
            y					[CvArr!]
            angle_in_degrees	[integer!]; CV_DEFAULT(0) 
        ]
        
        cvPow: "cvPow" [
        "Does powering: dst(idx) = src(idx)^power"
            src		            [CvArr!]
            dst					[CvArr!]  
        ]
        
        ;WARNING: Overflow is not handled yet. Underflow is handled. Maximal relative error is ~7e-6 for single-precision input
        cvExp: "cvExp" [
        "Does exponention: dst(idx) = exp(src(idx))."
            src		        [CvArr!]
            dst				[CvArr!]  
        ]
        
        cvLog: "cvLog" [
        "Calculates natural logarithms: dst(idx) = log(abs(src(idx)))."
            src		        [CvArr!]
            dst				[CvArr!]  
        ]
        
        cvFastArctan: "cvFastArctan" [
        "Fast arctangent calculation"
            y	                    [float!]
            x	[                   float!]
            return:                 [float!]
        ]
        cvCbrt: "cvCbrt" [
        "Fast cubic root calculation"
            value	            [float!]
        ]
        
        ;Checks array values for NaNs, Infs or simply for too large numbers
        ;(if CV_CHECK_RANGE is set). If CV_CHECK_QUIET is set,
        ;no runtime errors is raised (function returns zero value in case of "bad" values).
        ;Otherwise cvError is called */ 

        #define  CV_CHECK_RANGE    1
        #define  CV_CHECK_QUIET    2
        
        cvCheckArr: "cvCheckArr" [
            arr			[CvArr!]
            flags		[integer!] ;CV_DEFAULT(0)
            min_val 	[float!]; CV_DEFAULT(0) 
            max_val 	[float!];CV_DEFAULT(0))
	]
        
        #define cvCheckArray cvCheckArr
        
        #define CV_RAND_UNI      0
        #define CV_RAND_NORMAL   1
        
        cvRandArr: "cvRandArr" [
            rng			   	[byte-ptr!] ; function pointer to CvRNG funct
            arr				[CvArr!]
            dist_type		[integer!]
            ;param1			[_CvScalar]
            param1_v0       [float!]    
            param1_v1                    [float!]
            param1_v2                    [float!]
            param1_v3                    [float!]
            ;param2			[_CvScalar]
            param2_v0                    [float!]    
            param2_v1                    [float!]
            param2_v2                    [float!]
            param2_v3                    [float!]
        ]
        cvRandShuffle: "cvRandShuffle" [
            mat				[CvArr!]		
            rng				[byte-ptr!] ; function pointer to CvRNG funct
            iter_factor		[float!]; CV_DEFAULT(1.0)
        ]
        
        cvSolveCubic: "cvSolveCubic" [
            coeffs			[CvMat!]
            roots			[CvMat!]
            return: 		[integer!]
        ]
        
        ;/****************************************************************************************\
        ;*                                Matrix operations                                       *
        ;\****************************************************************************************/
        
        cvCrossProduct: "cvCrossProduct" [
        "Calculates cross product of two 3d vectors"
            src1			[CvArr!]
            src2			[CvArr!]
            dst				[CvArr!]
        ]
        
        #define CV_GEMM_A_T 1
        #define CV_GEMM_B_T 2
        #define CV_GEMM_C_T 4
        
        cvGEMM: "cvGEMM" [
        "Extended matrix transform: dst = alpha*op(A)*op(B) + beta*op(C), where op(X) is X or X^T"
            src1			[CvArr!]
            src2			[CvArr!]
            alpha			[float!]
            src3			[CvArr!]
            beta			[float!]
            dst				[CvArr!]
            tABC			[integer!];CV_DEFAULT(0)	
        ]
        #define cvMatMulAddEx cvGEMM
        ;Matrix transform: dst = A*B + C, C is optional */
        #define cvMatMulAdd( src1 src2 src3 dst ) [(cvGEMM src1 src2 1.0 src3 1.0 dst 0)]
        #define cvMatMul( src1 src2 dst )  [(cvMatMulAdd src1 src2 NULL dst)]
        
        cvTransform: "cvTransform" [
        "transforms each element of source array and stores resultant vectors in destination array"
            src			[CvArr!]
            dst			[CvArr!]
            transmat	[CvMat!]
            shiftvec	[CvMat!] ;CV_DEFAULT(NULL)
        ]
        #define cvMatMulAddS cvTransform
        
        cvPerspectiveTransform: "cvPerspectiveTransform" [
        "Does perspective transform on every element of input array "
            src			[CvArr!]
            dst			[CvArr!]
            mat			[CvMat!]
        ]
        
        cvMulTransposed: "cvMulTransposed" [
        "Calculates (A-delta)*(A-delta)^T (order=0) or (A-delta)^T*(A-delta) (order=1)"
            src			[CvArr!]
            dst			[CvArr!]
            order		[integer!]
            delta		[CvArr!] ;CV_DEFAULT(NULL)
            scale		[float!];CV_DEFAULT(1.)
        ]
        
        cvTranspose: "cvTranspose" [
        "Tranposes matrix. Square matrices can be transposed in-place"
            src			[CvArr!]
            dst			[CvArr!]
        ]
        #define cvT cvTranspose
        
        ;Mirror array data around horizontal (flip=0), vertical (flip=1) or both(flip=-1) axises
        cvFlip: "cvFlip" [
        "cvFlip(src) flips images vertically and sequences horizontally (inplace)"
            src			[CvArr!]
            dst			[CvArr!] ;CV_DEFAULT(NULL)
            flip_mode	        [integer!]
        ] 
        #define cvMirror cvFlip
        
        #define CV_SVD_MODIFY_A   1
        #define CV_SVD_U_T        2
        #define CV_SVD_V_T        4
        
        cvSVD: "cvSVD" [
        "Performs Singular Value Decomposition of a matrix"
            A			[CvArr!]
            W			[CvArr!]
            U			[CvArr!]
            V			[CvArr!]
            flags		[integer!]
        ]
        
        cvSVBkSb: "cvSVBkSb" [
        "Performs Singular Value Back Substitution (solves A*X = B): flags must be the same as in cvSVD"
            W			[CvArr!]
            U			[CvArr!]
            V			[CvArr!]
            B			[CvArr!]
            flags		[integer!]
        ]
        
        #define CV_LU  0
        #define CV_SVD 1
        #define CV_SVD_SYM 2
        
        cvInvert: "cvInvert"[
        "Inverts matrix"
            src			[CvArr!]
            dst			[CvArr!]
            method		[integer!]
            return: 	[float!];CV_DEFAULT(CV_LU)
        ]
        cvSolve: "cvSolve" [
        "Solves linear system (src1)*(dst) = (src2) (returns 0 if src1 is a singular and CV_LU method is used)"
            src1		[CvArr!]
            src2		[CvArr!]
            dst			[CvArr!]
            method		[integer!];CV_DEFAULT(CV_LU)
            return: 	[integer!]
        ]
        
        cvDet: "cvDet" [
        "Calculates determinant of input matrix"
            mat			[CvArr!]
            return: 	[float!]
        ]
    
        
        cvTrace: "cvTrace" [
        "Calculates trace of the matrix (sum of elements on the main diagonal)"
            mat			[CvArr!]
            return: 	[CvScalar!] ; not a pointer but 4 decimal
        ]
        
        cvEigenVV: "cvEigenVV" [
        "Finds eigen values and vectors of a symmetric matrix"
            mat			[CvArr!]
            evects		[CvArr!]
            evals		[CvArr!]
            eps			[float!];CV_DEFAULT(0)
        ]
        
        cvSetIdentity: "cvSetIdentity" [
        "Makes an identity matrix (mat_ij = i == j)"
            mat			[CvArr!]
            v0          [float!]  ;CvScalar  CV_DEFAULT(cvRealScalar 1 
            v1          [float!]
            v2          [float!]
            v3          [float!] ;
        ]
        
        cvRange: "cvRange" [
        "Fills matrix with given range of numbers"
            mat			[CvMat!]
            start		[float!]
            end			[float!]
        ]
        
        ; Calculates covariation matrix for a set of vectors transpose([v1-avg, v2-avg,...]) * [v1-avg,v2-avg,...] 
        #define CV_COVAR_SCRAMBLED   0
        ; [v1-avg, v2-avg,...] * transpose([v1-avg,v2-avg,...]) 
        #define CV_COVAR_NORMAL    1
        ; do not calc average (i.e. mean vector) - use the input vector instead (useful for calculating covariance matrix by parts) 
        #define CV_COVAR_USE_AVG   2
        ; scale the covariance matrix coefficients by number of the vectors 
        #define  CV_COVAR_SCALE    4
        ; all the input vectors are stored in a single matrix, as its rows 
        #define CV_COVAR_ROWS      8
        ; all the input vectors are stored in a single matrix, as its columns 
        #define CV_COVAR_COLS     16
        
        cvCalcCovarMatrix: "cvCalcCovarMatrix" [
            vects		[CvArr!]
            count		[integer!]
            cov_mat		[CvArr!]
            avg			[CvArr!]
            flags		[integer!]
        ]
        #define CV_PCA_DATA_AS_ROW 0 
        #define CV_PCA_DATA_AS_COL 1
        #define CV_PCA_USE_AVG 2
        
        cvCalcPCA: "cvCalcPCA" [
            data		[CvArr!]
            mean		[CvArr!]
            eigenvals	        [CvArr!]
            eigenvects	        [CvArr!]
            flags		[integer!]
        ]
        
        cvProjectPCA: "cvProjectPCA" [
            data		[CvArr!]
            mean		[CvArr!]
            eigenvects	        [CvArr!]
            result	        [CvArr!]
        ]
        
        cvBackProjectPCA: "cvBackProjectPCA" [
            proj		[CvArr!]
            mean		[CvArr!]
            eigenvects	        [CvArr!]
            result	        [CvArr!]
        ]
        
        cvMahalanobis: "cvMahalanobis" [
        "Calculates Mahalanobis(weighted) distance"
            vec1		[CvArr!]
            vec2		[CvArr!]
            mat			[CvArr!]
            return: 	        [float!]
        ]
        
        ;/****************************************************************************************\
        ;*                                    Array Statistics                                    *
        ;\****************************************************************************************/
        
       
        cvSum: "cvSum" [
        " Finds sum of array elements "
            arr		[CvArr!]
            return:	[_CvScalar] ; not a pointer 
        ]
        
        cvCountNonZero: "cvCountNonZero" [
        "Calculates number of non-zero pixels"
            arr		[CvArr!]
            return:	[integer!]
        ]
        
        cvAvg: "cvAvg" [
        "Calculates mean value of array elements"
            arr		[CvArr!]
            mask	[CvArr!];CV_DEFAULT(NULL)
            return:	[_CvScalar] ; not a pointer 
        ]
        
        cvAvgSdv: "cvAvgSdv" [
        "Calculates mean and standard deviation of pixel values"
            arr		[CvArr!]
            mean	[CvScalar!]
            std_dev     [CvScalar!]
            mask	[CvArr!];CV_DEFAULT(NULL)
        ]
       
        cvMinMaxLoc: "cvMinMaxLoc" [
        " Finds global minimum, maximum and their positions"
            arr			[CvArr!]
            min_val		[float-ptr!]
            max_val		[float-ptr!]
            min_loc		[CvPoint!];CV_DEFAULT(NULL)
            max_loc		[CvPoint!];CV_DEFAULT(NULL)
            mask	 	[CvArr!];CV_DEFAULT(NULL)
        ]
        
        ;types of array norm 
        #define CV_C            1
        #define CV_L1           2
        #define CV_L2           4
        #define CV_NORM_MASK    7
        #define CV_RELATIVE     8
        #define CV_DIFF         16
        #define CV_MINMAX       32

        #define CV_DIFF_C       [(CV_DIFF or CV_C)]
        #define CV_DIFF_L1      [(CV_DIFF or CV_L1)]
        #define CV_DIFF_L2      [(CV_DIFF or CV_L2)]
        #define CV_RELATIVE_C   [(CV_RELATIVE or CV_C)]
        #define CV_RELATIVE_L1  [(CV_RELATIVE or CV_L1)]
        #define CV_RELATIVE_L2  [(CV_RELATIVE or CV_L2)]
        
       
        cvNorm: "cvNorm" [
        " Finds norm, difference norm or relative difference norm for an array (or two arrays)"
            arr1			[CvArr!]
            arr2			[CvArr!];CV_DEFAULT(NULL)
            norm_type 		[integer!]; CV_DEFAULT(CV_L2
            mask	 		[CvArr!];CV_DEFAULT(NULL)
            return:			[float!]
        ]
        
        cvNormalize: "cvNormalize" [
            src			        [CvArr!]
            dst			        [CvArr!]
            a			        [float!];CV_DEFAULT(1.)
            b			        [float!];CV_DEFAULT(0.)
            norm_type	        [integer!];CV_DEFAULT(CV_L2)
            mask	 	        [CvArr!];CV_DEFAULT(NULL)
        ]
        
        #define CV_REDUCE_SUM 0
        #define CV_REDUCE_AVG 1
        #define CV_REDUCE_MAX 2
        #define CV_REDUCE_MIN 3
        
        cvReduce: "cvReduce" [
            src			[CvArr!]
            dst			[CvArr!]
            dim 		[integer!];CV_DEFAULT(-1)
            op 			[integer!];CV_DEFAULT(CV_REDUCE_SUM) )
        ]
        
        ;/****************************************************************************************\
        ;*                      Discrete Linear Transforms and Related Functions                  *
        ;\****************************************************************************************/
        
        #define CV_DXT_FORWARD  0
        #define CV_DXT_INVERSE  1
        #define CV_DXT_SCALE    2 ; divide result by size of array 
        #define CV_DXT_INV_SCALE [(CV_DXT_INVERSE + CV_DXT_SCALE)]
        #define CV_DXT_INVERSE_SCALE [CV_DXT_INV_SCALE]
        #define CV_DXT_ROWS     4 ;transform each row individually 
        #define CV_DXT_MUL_CONJ 8 ;conjugate the second argument of cvMulSpectrums
        
        
        cvDFT: "cvDFT" [
        "Discrete Fourier Transform: complex->complex,real->ccs (forward),ccs->real (inverse)"
            src				[CvArr!]
            dst				[CvArr!]
            flags			[integer!]
            nonzero_rows 	        [integer!];CV_DEFAULT(0)
        ]
        #define cvFFT cvDFT
        
        cvMulSpectrums: "cvMulSpectrums" [
        "Multiply results of DFTs: DFT(X)*DFT(Y) or DFT(X)*conj(DFT(Y))"
            src1			[CvArr!]
            src2			[CvArr!]
            dst				[CvArr!]
            flags			[integer!]
        ]
        
        cvGetOptimalDFTSize: "cvGetOptimalDFTSize"[
        "Finds optimal DFT vector size >= size0"
            size0		[integer!]
            return:		[integer!]
        ]
        
        cvDCT: "cvDCT" [
        "Discrete Cosine Transform"
            src				[CvArr!]
            dst				[CvArr!]
            flags			[integer!]
        ]
        
        ;/****************************************************************************************\
        ;*                              Dynamic data structures                                   *
        ;\****************************************************************************************/
        cvSliceLength: "cvSliceLength" [
        "Calculates length of sequence slice (with support of negative indices)"
            slice_start_index         [integer!] ;_CvSlice
            slice_end_index           [integer!]
            seq			      [CvSeq!]
            return:		      [integer!]
        ]
        
        cvCreateMemStorage: "cvCreateMemStorage" [
        "Creates new memory storage. block_size == 0 means that default,somewhat optimal size, is used (currently, it is 64K)"
            block_size 		[integer!];CV_DEFAULT(0)
            return:		    [CvMemStorage!]
        ]
        cvCreateChildMemStorage: "cvCreateChildMemStorage"  [
        "Creates a memory storage that will borrow memory blocks from parent storage"
            parent	 		[CvMemStorage!]
            return:			[CvMemStorage!]
        ]
        
        cvReleaseMemStorage: "cvReleaseMemStorage" [
        {Releases memory storage. All the children of a parent must be released before the parent.
        A child storage returns all the blocks to parent when it is released"}
            storage	 		[double-byte-ptr!] ;CvMemStorage** (address?)
        ]
        
        cvClearMemStorage: "cvClearMemStorage" [
        {Clears memory storage. This is the only way(!!!) (besides cvRestoreMemStoragePos)
        to reuse memory allocated for the storage - cvClearSeq,cvClearSet ...
        do not free any memory.A child storage returns all the blocks to the parent when it is cleared}
            storage	 		[CvMemStorage!] ;CvMemStorage*
        ]
        
        
        cvSaveMemStoragePos: "cvSaveMemStoragePos" [
        "Remember a storage free memory position"
            storage	 		[CvMemStorage!] 
            pos		 		[CvMemStorage!]
        ]
        
       
        cvRestoreMemStoragePos: "cvRestoreMemStoragePos" [
         "Restore a storage free memory position"
            storage	 		[CvMemStorage!]
            pos		 		[CvMemStorage!]
        ]
        
        cvMemStorageAlloc: "cvMemStorageAlloc" [
        "Allocates continuous buffer of the specified size in the storage"
            storage	 		[CvMemStorage!]
            size_t		 	[integer!] 
        ]
        
        cvMemStorageAllocString: "cvMemStorageAllocString" [
            storage	 		[CvMemStorage!] 
            ptr		 	        [byte-ptr!] ; pointer
            len				[integer!];CV_DEFAULT(-1)
            return:			[c-string!]
        ]
        
        cvCreateSeq: "cvCreateSeq" [
        "Creates new empty sequence that will reside in the specified storage "
            seq_flags		        [integer!]	
            header_size		        [integer!]
            elem_size		        [integer!]
            storage			[CvMemStorage!]
            return: 		        [CvSeq!]
        ]
        cvSetSeqBlockSize: "cvSetSeqBlockSize" [
        "changes default size (granularity) of sequence blocks. The default size is ~1Kbyte"
            seq				[CvSeq!]
            delta_elems		        [integer!]
        ]
        
        cvSeqPush: "cvSeqPush" [
        "Adds new element to the end of sequence. Returns pointer to the element"
            seq				[CvSeq!]
            element 		        [integer!];CV_DEFAULT(NULL) pointer
            return: 		        [byte-ptr!]
        ]
        
        cvSeqPushFront: "cvSeqPushFront" [
        "Adds new element to the beginning of sequence. Returns pointer to it"
            seq				[CvSeq!]
            element 		        [integer!];CV_DEFAULT(NULL) pointer
            return: 		        [byte-ptr!]
        ]
        
        cvSeqPop: "cvSeqPop" [
        "Removes the last element from sequence and optionally saves it"
            seq				[CvSeq!]
            element 		        [integer!];CV_DEFAULT(NULL) pointer
        ]
        
        cvSeqPopFront: "cvSeqPopFront" [
        "Removes the first element from sequence and optioanally saves it"
            seq				[CvSeq!]
            element 		        [integer!];CV_DEFAULT(NULL) pointer
        ] 
        #define CV_FRONT 1
        #define CV_BACK 0
        
        cvSeqPushMulti: "cvSeqPushMulti" [
        "Adds several new elements to the end of sequence"
            seq				[CvSeq!]
            element 		        [integer!];CV_DEFAULT(NULL) pointer
            count			[integer!]
            in_front		        [integer!]; CV_DEFAULT(0)
        ]
        
        cvSeqPopMulti: "cvSeqPopMulti" [
        "Removes several elements from the end of sequence and optionally saves them"
            seq				[CvSeq!]
            element 		        [integer!];CV_DEFAULT(NULL) pointer
            count			[integer!]
            in_front		        [integer!]; CV_DEFAULT(0)
        ]
        
        cvSeqInsert: "cvSeqInsert" [
        "Inserts a new element in the middle of sequence.cvSeqInsert(seq,0,elem) == cvSeqPushFront(seq,elem)"
            seq				[CvSeq!]
            before_index	        [integer!]
            element 		        [integer!];CV_DEFAULT(NULL) pointer
            return: 		        [byte-ptr!]
        ]
        
        cvSeqRemove: "cvSeqRemove" [
        "Removes specified sequence element"
            seq				[CvSeq!]
            index			[integer!]
        ]
        
        ;Removes all the elements from the sequence. The freed memory
        ;can be reused later only by the same sequence unless cvClearMemStorage
        ;or cvRestoreMemStoragePos is called}
        
        cvClearSeq: "cvClearSeq" [
        "Removes all the elements from the sequence."
            seq				[CvSeq!]
        ]
        
        cvGetSeqElem: "cvGetSeqElem" [
        {Retrives pointer to specified sequence element.Negative indices are supported and mean
        counting from the end (e.g -1 means the last sequence element)}
            seq				[CvSeq!]
            index			[integer!]
            return:			[byte-ptr!]
        ]
        
        cvSeqElemIdx: "cvSeqElemIdx" [
        "Calculates index of the specified sequence element. Returns -1 if element does not belong to the sequence "
            seq				[CvSeq!]
            element			[byte-ptr!] ; pointer to void*
            return:			[CvSeqBlock!]; CV_DEFAULT(NULL) address?
        ]
        
        cvStartAppendToSeq: "cvStartAppendToSeq" [
        "Initializes sequence writer. The new elements will be added to the end of sequence"
            seq				[CvSeq!]
	    writer			[CvSeqWriter!]
        ]
        
        CvStartWriteSeq: "CvStartWriteSeq" [
        "Combination of cvCreateSeq and cvStartAppendToSeq"
            seq_flags		        [integer!]
            header_size		        [integer!]
            elem_size		        [integer!]
            storage			[CvMemStorage!]
            writer			[CvSeqWriter!]
        ]
        
        cvEndWriteSeq: "cvEndWriteSeq" [
        {Closes sequence writer, updates sequence header and returns pointer to the resultant sequence
        (which may be useful if the sequence was created using cvStartWriteSeq))}
            writer			[CvSeqWriter!]
            return: 		        [CvSeq!]
        ]
        
        cvFlushSeqWriter: "cvFlushSeqWriter" [
        " Updates sequence header. May be useful to get access to some of previously written elements via cvGetSeqElem or sequence reader"
           writer			[CvSeqWriter!]
        ]
        
        cvStartReadSeq: "cvStartReadSeq" [
        "Initializes sequence reader. The sequence can be read in forward or backward direction"
            seq				[CvSeq!]
            reader			[CvSeqReader!]
            _reverse                    [integer!];CV_DEFAULT(0)
        ]
        
        cvGetSeqReaderPos: "cvGetSeqReaderPos" [
        "Returns current sequence reader position (currently observed sequence element)"
            reader			[CvSeqReader!]
            return:			[integer!]
        ]
        cvSetSeqReaderPos: "cvSetSeqReaderPos" [
        "Changes sequence reader position. It may seek to an absolute or to relative to the current position"
            reader			[CvSeqReader!]
            index			[integer!]
            is_relative 	        [integer!];CV_DEFAULT(0))
        ]
        
        cvCvtSeqToArray: "cvCvtSeqToArray" [
        "Copies sequence content to a continuous piece of memory "
            seq				[CvSeq!]
            elements		        [byte-ptr!]; pointer
            slice		 	[CvSlice!];CV_DEFAULT(CV_WHOLE_SEQ)
        ] 
        ;Creates sequence header for array.
        ;After that all the operations on sequences that do not alter the conten can be applied to the resultant sequence
        
        cvMakeSeqHeaderForArray: "cvMakeSeqHeaderForArray" [
            seq_type			[integer!]
            header_size		 	[integer!]
            elem_size		 	[integer!]
            elements			[byte-ptr!]; pointer
            total			[integer!]
            seq				[CvSeq!]
            block			[CvSeqBlock!]
            return:			[CvSeq!]
        ]
        
        cvSeqSlice: "cvSeqSlice" [
        "Extracts sequence slice (with or without copying sequence elements)"
            seq				[CvSeq!]
            slice                       [_CvSlice]
            storage			[CvMemStorage!];CV_DEFAULT(NULL)
            copy_data			[integer!];CV_DEFAULT(NULL)
        ]
        
        cvSeqRemoveSlice: "cvSeqRemoveSlice" [
        "Removes sequence slice"
            seq				[CvSeq!]
            slice_start_index           [integer!] ;_CvSlice
            slice_end_index             [integer!]
        ]
        
        cvSeqInsertSlice: "cvSeqInsertSlice" [
        "Inserts a sequence or array into another sequence"
            seq				[CvSeq!]
            before_index		[integer!]
            from_arr			[CvArr!]
        ]
        
        cvSeqSort: "cvSeqSort" [
        "Sorts sequence in-place given element comparison function"
            seq				[CvSeq!]
            CvCmpFunc			[byte-ptr!] ;CvCmpFunc func
            userdata			[byte-ptr!];CV_DEFAULT(NULL)
        ]
        
        cvSeqSearch: "cvSeqSearch" [
        "Finds element in a sorted or not sequence"
            seq				[CvSeq!]
            elem			[byte-ptr!]
            CvCmpFunc			[byte-ptr!] ; CvCmpFunc func
            is_sorted			[integer!]
            elem_idx			[int-ptr!]
            userdata			[byte-ptr!];CV_DEFAULT(NULL)
        ]
        
        cvSeqInvert: "cvSeqInvert" [
        "Reverses order of sequence elements in-place"
            seq				[CvSeq!]
        ]
        
        cvSeqPartition: "cvSeqPartition" [
            seq				[CvSeq!]
            storage			[CvMemStorage!]
            labels			[CvSeq!];  use &CvSeq! (CvSeq**)
            is_equal			[integer!]
            userdata			[byte-ptr!] ; void*
            return:			[integer!]
        ]
        ;/************ Internal sequence functions ************/
        cvChangeSeqBlock: "cvChangeSeqBlock" [
            reader			[byte-ptr!];void*
            direction			[integer!]
        ]
        cvCreateSeqBlock: "cvCreateSeqBlock" [
            writer			[CvSeqWriter!]
        ]
        
        cvCreateSet: "cvCreateSet" [
        "Creates a new set"
            set_flags			[integer!]
            header_size			[integer!]
            elem_size			[integer!]
            storage			[CvMemStorage!]
            return:			[CvSet!]
        ]
        
        cvSetAdd: "cvSetAdd" [
        "Adds new element to the set and returns pointer to it"
            set_header			[CvSet!]
            elem			[CvSetElem!]; V_DEFAULT(NULL)
            inserted_elem 		[CvSetElem!] ; double pointer CvSetElem** V_DEFAULT(NULL)
            return:			[integer!]
        ]
        cvSetRemove: "cvSetRemove" [
        "Removes element from the set by its index"
            set_header		        [CvSet!]
            index 			[integer!]
        ]
        
        cvClearSet: "cvClearSet" [
        "Removes all the elements from the set"
            set_header		        [CvSet!]
        ]
        
        cvCreateGraph: "cvCreateGraph" [
        "Creates new graph"
            graph_flags			[integer!]
            header_size			[integer!]
            vtx_size			[integer!]
            edge_size			[integer!]
            storage			[CvMemStorage!]
            return:			[CvGraph!]
        ]
        
        cvGraphAddVtx: "cvGraphAddVtx" [
        "Adds new vertex to the graph"
            graph			[CvGraph!]
            vtx				[CvGraphVtx!];CV_DEFAULT(NULL)
            inserted_vtx	        [CvGraphVtx!]; double pointer address? CV_DEFAULT(NULL)
            return:			[integer!]
        ]
        
        cvGraphRemoveVtx: "cvGraphRemoveVtx" [
        "Removes vertex from the graph together with all incident edges"
            graph			[CvGraph!]
            index			[integer!]
            return:			[integer!]
        ]
        
        cvGraphRemoveVtxByPtr: "cvGraphRemoveVtxByPtr" [
        "non documented"
            graph			[CvGraph!]
            vtx				[CvGraphVtx!];CV_DEFAULT(NULL)
            return:			[integer!]
        ]
        ;Link two vertices specifed by indices or pointers if they are not connected
        ;or return pointer to already existing edge connecting the vertices.
        cvGraphAddEdge: "cvGraphAddEdge" [
        "Functions return 1 if a new edge was created, 0 otherwise"
            graph			[CvGraph!]
            start_idx		        [integer!]
            end_idx			[integer!]
            edge			[CvGraphEdge!];CV_DEFAULT(NULL)
            inserted_edge	        [CvGraphEdge!];double pointer address CV_DEFAULT(NULL)
            return:			[integer!]
        ]
        
        cvGraphAddEdgeByPtr: "cvGraphAddEdgeByPtr" [
            graph			[CvGraph!]
            start_vtx		        [CvGraphVtx!]
            end_vtx			[CvGraphVtx!]
            edge			[CvGraphEdge!];CV_DEFAULT(NULL)
            inserted_edge	        [CvGraphEdge!];double pointer address CV_DEFAULT(NULL)
            return:			[integer!]
        ]
        
        cvGraphRemoveEdge: "cvGraphRemoveEdge" [
        "Remove edge connecting two vertices"
            graph			[CvGraph!]
            start_idx		        [integer!]
            end_idx			[integer!]
        ]
        
        cvGraphRemoveEdgeByPtr: "cvGraphRemoveEdgeByPtr" [
            graph			[CvGraph!]
            start_vtx		        [CvGraphVtx!]
            end_vtx			[CvGraphVtx!]
        ]
        
        cvFindGraphEdge: "cvFindGraphEdge" [
        "Find edge connecting two vertices"
            graph			[CvGraph!]
            start_idx		        [integer!]
            end_idx			[integer!]
            return:			[CvGraphEdge!]
        ]
        
        cvFindGraphEdgeByPtr: "cvFindGraphEdgeByPtr" [
            graph			[CvGraph!]
            start_idx		        [CvGraphVtx!]
            end_idx			[CvGraphVtx!]
            return:			[CvGraphEdge!]
        ]
        
        #define cvGraphFindEdge cvFindGraphEdge
        #define cvGraphFindEdgeByPtr cvFindGraphEdgeByPtr
       
        cvClearGraph: "cvClearGraph" [
        "Remove all vertices and edges from the graph "
            graph			[CvGraph!]
        ]
        
        cvGraphVtxDegree: "cvGraphVtxDegree" [
        "Count number of edges incident to the vertex"
            graph			[CvGraph!]
            vtx_idx			[integer!]
            return:			[integer!]
        ]
        cvGraphVtxDegreeByPtr: "cvGraphVtxDegreeByPtr" [
            graph			[CvGraph!]
            vtx				[CvGraphVtx!]
            return:			[integer!]
        ]
        ;retrieves graph vertex by given index REVOIR
        ; #define cvGetGraphVtx( graph idx ) (CvGraphVtx*)cvGetSetElem((CvSet*)(graph), (idx))
        
        ; Retrieves index of a graph vertex given its pointer */
        #define cvGraphVtxIdx( graph vtx ) [(vtx/flags & CV_SET_ELEM_IDX_MASK)]
        
        ;Retrieves index of a graph edge given its pointer
        #define cvGraphEdgeIdx( graph edge ) [(edge/flags & CV_SET_ELEM_IDX_MASK)]
        
        #define cvGraphGetVtxCount( graph ) [(graph/active_count)]
        #define cvGraphGetEdgeCount( graph ) [(graph/edges/active_count)]
        
        #define  CV_GRAPH_VERTEX        1
        #define  CV_GRAPH_TREE_EDGE     2
        #define  CV_GRAPH_BACK_EDGE     4
        #define  CV_GRAPH_FORWARD_EDGE  8
        #define  CV_GRAPH_CROSS_EDGE    16
        #define  CV_GRAPH_ANY_EDGE      30
        #define  CV_GRAPH_NEW_TREE      32
        #define  CV_GRAPH_BACKTRACKING  64
        #define  CV_GRAPH_OVER          -1
        #define  CV_GRAPH_ALL_ITEMS    -1
        
        ;flags for graph vertices and edges */
        #define  CV_GRAPH_ITEM_VISITED_FLAG  [(1 << 30)]
        #define  CV_IS_GRAPH_VERTEX_VISITED(vtx) [(CvGraphVtx!/vtx/flags & CV_GRAPH_ITEM_VISITED_FLAG)]
        #define  CV_IS_GRAPH_EDGE_VISITED(edge) [(CvGraphEdge!/edge/flags & CV_GRAPH_ITEM_VISITED_FLAG)]
        #define  CV_GRAPH_SEARCH_TREE_NODE_FLAG   [(1 << 29)]
        #define  CV_GRAPH_FORWARD_EDGE_FLAG       [(1 << 28)]
        
        cvCreateGraphScanner: "cvCreateGraphScanner" [
        "Creates new graph scanner."
            graph			[CvGraph!]
            vtx 			[CvGraphVtx!] ;CV_DEFAULT(NULL)
            mask			[integer!];V_DEFAULT(CV_GRAPH_ALL_ITEMS))
            return:			[CvGraphScanner!]
        ]
        
        cvReleaseGraphScanner: "cvReleaseGraphScanner" [
        "Releases graph scanner"
            scanner		        [double-byte-ptr!] ; double pointer CvGraphScanner** 
        ]
        
        cvNextGraphItem: "cvNextGraphItem" [
        "Get next graph element "
            scanner		[CvGraphScanner!]
            return:		[integer!]
        ]
        
        cvCloneGraph: "cvCloneGraph" [
        "creates a copy of graph"
            graph		[CvGraph!]
            storage		[CvMemStorage!]
            return: 	        [CvGraph!]
        ]
        ;/****************************************************************************************\
        ;*                                     Drawing                                            *
        ;\****************************************************************************************/

        ;/****************************************************************************************\
        ;*       Drawing functions work with images/matrices of arbitrary type.                   *
        ;*       For color images the channel order is BGR[A]                                     *
        ;*       Antialiasing is supported only for 8-bit image now.                              *
        ;*       All the functions include parameter color that means rgb value (that may be      *
        ;*       constructed with CV_RGB macro) for color images and brightness                   *
        ;*       for grayscale images.                                                            *
        ;*       If a drawn figure is partially or completely outside of the image, it is clipped.*
        ;\****************************************************************************************/
        
        #define CV_RGB (r g b)  [(cvScalar  (b) (g) (r) 0.0 )]
        #define CV_FILLED -1
        #define CV_AA 16
        
        cvLine: "cvLine" [
        "Draws 4-connected, 8-connected or antialiased line segment connecting two points "
            img				[CvArr!]
            pt1_x			[integer!] ; normally CvPoint
            pt1_y 			[integer!]
            pt2_x 			[integer!] ; normally CvPoint
            pt2_y 			[integer!]
            b				[float!]
            g				[float!]
            r				[float!]
            a				[float!]
            thickness		        [integer!] ;
            line_type		        [integer!] ;CV_DEFAULT(8)
            shift			[integer!] ;CV_DEFAULT(0)
        ]
        
        cvRectangle: "cvRectangle" [
        "Draws a rectangle given two opposite corners of the rectangle (pt1 & pt2),if thickness<0 (e.g. thickness == CV_FILLED), the filled box is drawn" 
            img				[CvArr!]
            pt1_x			[integer!]
            pt1_y 			[integer!]
            pt2_x 			[integer!]
            pt2_y 			[integer!]
            b				[float!]
            g				[float!]
            r				[float!]
            a				[float!]
            thickness		        [integer!]
            line_type		        [integer!];CV_DEFAULT(8)
            shift			[integer!];CV_DEFAULT(0)
        ]
        
        cvCircle: "cvCircle" [
        "Draws a circle with specified center and radius. Thickness works in the same way as with cvRectangle"
        
            img				[CvArr!]
            center_x		        [integer!]
            center_y 		        [integer!]
            radius			[integer!]
            b				[float!]
            g				[float!]
            r				[float!]
            a				[float!]
            thickness		        [integer!];CV_DEFAULT(1)
            line_type		        [integer!];CV_DEFAULT(8)
            shift			[integer!];CV_DEFAULT(0)
        ]
        
        cvEllipse: "cvEllipse" [
            img				[CvArr!]
            center_x		        [integer!]
            center_y 		        [integer!]
            width			[integer!]
            height			[integer!]
            angle			[float!]
            start_angle		        [float!]
            end_angle		        [float!]
            b				[float!]
            g				[float!]
            r				[float!]
            a				[float!]
            thickness		        [integer!];CV_DEFAULT(1)
            line_type		        [integer!];CV_DEFAULT(8)
            shift			[integer!];CV_DEFAULT(0)
        ]
        
        cvFillConvexPoly: "cvFillConvexPoly" [
        "Fills convex or monotonous polygon"
	img				[CvArr!]
	pts				[int-ptr!]  ; * CvPoint! pointer to array of points
	npts			        [integer!] ; nb of vertices
	b				[float!]
        g				[float!]
        r				[float!]
        a				[float!]
	line_type		        [integer!];CV_DEFAULT(8)
	shift			        [integer!];CV_DEFAULT(0)
    ]
    
    cvFillPoly: "cvFillPoly" [
    ";Fills an area bounded by one or more arbitrary polygons"
	img				[CvArr!]
	pts				[double-int-ptr!];  ** CvPoints pointer to array of CvPoints 
	npts			        [int-ptr!] ;pointer nb of points by polygons
	contours		        [integer!] ; nb of polygons to draw
	b				[float!]
        g				[float!]
        r				[float!]
        a				[float!]
	line_type		        [integer!];CV_DEFAULT(8)
	shift			        [integer!];CV_DEFAULT(0)
    ]
    
    cvPolyLine: "cvPolyLine" [
    "Draws one or more polygonal curves"
        img                             [CvArr!]
        pts				[double-int-ptr!];  ** CvPoints pointer to array of CvPoints ;Array of pointers to polylines.
        npts			        [int-ptr!] ; pointer to int array ; Array of polyline vertex counters
        contours		        [integer!] ;  Array of polyline vertex counters
        is_closed                       [integer!] ; closed or not
        b				[float!]
        g				[float!]
        r				[float!]
        a				[float!]
        thickness                       [integer!];CV_DEFAULT(1)
	line_type		        [integer!];CV_DEFAULT(8)
	shift			        [integer!];CV_DEFAULT(0)
    ]
    
    
    #define cvDrawRect cvRectangle
    #define cvDrawLine cvLine
    #define cvDrawCircle cvCircle
    #define cvDrawEllipse cvEllipse
    #define cvDrawPolyLine cvPolyLine
    
    cvClipLine: "cvClipLine" [
    "Clips the line segment connecting *pt1 and *pt2 by the rectangular window (0<=x<img_size.width, 0<=y<img_size.height)."
	width 		[integer!]; x CvSize
	height 		[integer!]; y CvSize
	*pt1		[CvPoint!]; pointer to cvPoint
	*pt2		[CvPoint!] ; pointer to cvPoint
	return:		[integer!]
    ]
    
    cvInitLineIterator: "cvInitLineIterator" [
    {Initializes line iterator. Initially, line_iterator->ptr will point
    to pt1 (or pt2, see left_to_right description) location in the image.
    Returns the number of pixels on the line between the ending points}
	img			[CvArr!]
	pt1_x			[integer!]
	pt1_y 			[integer!]
	pt2_x 			[integer!]
	pt2_y 			[integer!]
	line_iterator           [CvLineIterator!] ; pointer 
	connectivity	        [integer!] ;CV_DEFAULT(8)
	left_to_right	        [integer!] ;CV_DEFAULT(0)
	return:			[integer!]
    ]
    
    #define CV_NEXT_LINE_POINT( line_iterator ) [
        _line_iterator_mask: declare cvInitLineIterator!
        either line_iterator/err < 0 [_line_iterator_mask: -1] [_line_iterator_mask: 0]
        line_iterator/err: line_iterator/err + line_iterator/delta + (line_iterator/plus_delta AND _line_iterator_mask)
        line_iterator/ptr: line_iterator/ptr + line_iterator/minus_step + (line_iterator/plus_step AND _line_iterator_mask)
    ]
    ;basic font types */
    #define CV_FONT_HERSHEY_SIMPLEX         0
    #define CV_FONT_HERSHEY_PLAIN           1
    #define CV_FONT_HERSHEY_DUPLEX          2
    #define CV_FONT_HERSHEY_COMPLEX         3 
    #define CV_FONT_HERSHEY_TRIPLEX         4
    #define CV_FONT_HERSHEY_COMPLEX_SMALL   5
    #define CV_FONT_HERSHEY_SCRIPT_SIMPLEX  6
    #define CV_FONT_HERSHEY_SCRIPT_COMPLEX  7
    
    ;font flags 
    #define CV_FONT_ITALIC                 16  
    #define CV_FONT_VECTOR0    CV_FONT_HERSHEY_SIMPLEX
    
    cvInitFont: "cvInitFont" [
    "Initializes font structure used further in cvPutText"
	font				[CvFont!] ; pointer to fonts CvFont!
	font_face			[integer!]
	hscale				[float!]
	vscale				[float!]
	shear				[float!]; CV_DEFAULT(0) ;italic
	thickness			[integer!]; CV_DEFAULT(1)
	line_type			[integer!];CV_DEFAULT(8))
    ]
    cvPutText: "cvPutText" [
    "Renders text stroke with specified font and color at specified location. CvFont should be initialized with cvInitFont"
	img				[CvArr!]
	text			        [c-string!]
	orgx			        [integer!]
	orgy			        [integer!]
	font			        [CvFont!]; & CvFont!font pointer 
	b				[float!]
	g				[float!]
	r				[float!]
	a				[float!]
    ]
    
    cvGetTextSize: "cvGetTextSize" [
    "Calculates bounding box of text stroke (useful for alignment)"
	text			[c-string!]
	font			[CvFont!]               ; pointer to CvFont
    text_size       [CvSize!]               ; pointer to CvSize is updated by the routine ;
	baseline		[int-ptr!]   ; pointer updated by the routine  (byte-ptr can be also used )
    ]
    cvColorToScalar: "cvColorToScalar" [
    { Unpacks color value, if arrtype is CV_8UC?, <color> is treated as
     packed color value, otherwise the first channels (depending on arrtype)
    of destination scalar are set to the same value = <color> }
	packed_color	        [float!]
	arrtype			[integer!]
	return: 		[_CvScalar] ; not a pointer 		
    ]
    
    cvEllipse2Poly: "cvEllipse2Poly" [
    {Returns the polygon points which make up the given ellipse.  The ellipse is define by
    the box of size 'axes' rotated 'angle' around the 'center'.  A partial sweep
    of the ellipse arc can be done by spcifying arc_start and arc_end to be something
    other than 0 and 360, respectively.  The input array 'pts' must be large enough to
    hold the result.  The total number of points stored into 'pts' is returned by this function.}

	center_x			[integer!];_cvPoint
	center_y			[integer!];cvPoint
	axe_x				[integer!];cvSize
	axe_y				[integer!];cvSize
	angle				[integer!]
	arc_start			[integer!]
	arc_end				[integer!]
        *pts                            [int-ptr!] ; pointeur to array CvPoints
	delta				[integer!]; 
	return:				[integer!]
    ]
    
    cvDrawContours: "cvDrawContours" [
    "Draws contour outlines or filled interiors on the image"
	img			        [CvArr!]
	contour		                [CvSeq!]
	eb				[float!]
	eg				[float!]
	er				[float!]
	ea				[float!]
	hb				[float!]
	hg				[float!]
	hr				[float!]
	ha				[float!]
	thickness 		        [integer!];CV_DEFAULT(1)
	line_type		        [integer!];CV_DEFAULT(8)
	offset_x		        [integer!];CV_DEFAULT(0)
	offset_y		        [integer!];CV_DEFAULT(0)
    ]
    cvLUT: "cvLUT" [
    "Does look-up transformation. Elements of the source array (that should be 8uC1 or 8sC1) are used as indexes in lutarr 256-element table"
	src		                [CvArr!]
	dst		                [CvArr!]
	lut		                [CvArr!]
    ]
    ;******************* Iteration through the sequence tree *****************/
    cvInitTreeNodeIterator: "cvInitTreeNodeIterator"  [
        tree_iterator                   [CvTreeNodeIterator!]
        first                           [byte-ptr!]
        max_level                       [integer!]
    ]
    cvNextTreeNode: "cvInitTreeNodeIterator" [tree_iterator [CvTreeNodeIterator!]]
    cvPrevTreeNode: "cvInitTreeNodeIterator" [tree_iterator [CvTreeNodeIterator!]]
    
    ;Inserts sequence into tree with specified "parent" sequence. If parent is equal to frame (e.g. the most external contour),
    ;then added contour will have null pointer to parent.
    
    cvInsertNodeIntoTree: "cvInsertNodeIntoTree" [
    "Inserts sequence into tree with specified parent sequence."
        node                            [byte-ptr!] ;*void
        parent                          [byte-ptr!] ;*void
        frame                           [byte-ptr!] ;*void
    ]
    
    cvRemoveNodeFromTree: "cvRemoveNodeFromTree" [
    "Removes contour from tree (together with the contour children)."
        node                            [byte-ptr!] ;*void
        frame                           [byte-ptr!] ;*void
    ]
    
    cvTreeToNodeSeq: "cvTreeToNodeSeq" [
    "Gathers pointers to all the sequences, accessible from the first, to the single sequence "
        first                           [byte-ptr!]
        header_size                     [integer!]
        storage                         [CvMemStorage!]
        return:                         [CvSeq!]  
    ]
    
    cvKMeans2: "cvKMeans2" [
        samples                         [CvArr!]
        cluster_count                   [integer!]
        labels                          [CvArr!]
        termcrit                        [CvTermCriteria!]  
    ]
    
    ;/****************************************************************************************\
    ;*                                    System functions                                    *
    ;\****************************************************************************************/
    cvRegisterModule: "cvRegisterModule" [
    "Add the function pointers table with associated information to the IPP primitives list"
        module_info                     [CvModuleInfo!]
        return:                         [integer!]
    ]
    
    cvUseOptimized: "cvUseOptimized" [
    "Loads optimized functions from IPP, MKL etc. or switches back to pure C code"
        on_off                          [integer!]
        return:                         [integer!]
    ]
    
    cvGetModuleInfo: "cvGetModuleInfo" [
    "Retrieves information about the registered modules and loaded optimized plugins"
        module_name                     [c-string!]; const char* 
        version                         [p-buffer!] ;char**
        loaded_addon_plugins            [p-buffer!] ;char** 
    ]
                              
    ;Get current OpenCV error status
    cvGetErrStatus: "cvGetErrStatus" [return:  [integer!]]
    ;Sets error status silently
    cvSetErrStatus: "cvSetErrStatus" [status  [integer!]]
    
    #define CV_ErrModeLeaf     0   ;Print error and exit program
    #define CV_ErrModeParent   1   ;Print error and continue
    #define CV_ErrModeSilent   2   ;Don't print and continue
    
    ;Retrives current error processing mode
    cvGetErrMode: "cvGetErrMode" [return: [integer!]]
    ;Sets error processing mode, returns previously used mode
    cvSetErrMode: "" [mode [integer!] return: [integer!]]
    
    ;Sets error status and performs some additonal actions (displaying message box,writing message to stderr, terminating application etc.)
    cvError: "cvError" [
        status              [integer!]
        func_name           [c-string!]
        err_msg             [c-string!]
        file_name           [c-string!]
        line                [integer!]
    ]
    ; Retrieves textual description of the error given its code
    cvErrorStr: "cvErrorStr" [
        status              [integer!]
        return:             [c-string!]     
    ]
    
    ;Retrieves detailed information about the last error occured
    cvGetErrInfo: "cvGetErrInfo" [
        errcode_desc            [p-buffer!] ;char**
        description             [p-buffer!] ;char**
        filename                [p-buffer!] ;char**
        line                    [pointer! [integer!]]
        return:                 [integer!]    
    ]
    ;Maps IPP error codes to the counterparts from OpenCV
    cvErrorFromIppStatus: "cvErrorFromIppStatus" [
        ipp_status              [integer!]
        return:                 [integer!]   
    ]
    
    cvRedirectError: "cvRedirectError" [
        error_handler           [CvErrorCallback!]
        userdata                [byte-ptr!]         ;void*
        prev_userdata           [double-byte-ptr!]  ;void**
    ]
    
    ;Output to:
    ;    cvNulDevReport - nothing
    ;   cvStdErrReport - console(fprintf(stderr,...))
    ;    cvGuiBoxReport - MessageBox(WIN32)
   
    cvNulDevReport: "cvNulDevReport" [
        status              [integer!]
        func_name           [c-string!]
        err_msg             [c-string!]
        file_name           [c-string!]
        line                [integer!]
        userdata            [byte-ptr!]
        return:             [integer!]
    ]
    
    cvStdErrReport: "cvStdErrReport" [
        status              [integer!]
        func_name           [c-string!]
        err_msg             [c-string!]
        file_name           [c-string!]
        line                [integer!]
        userdata            [byte-ptr!]
        return:             [integer!]
    ]
    
    cvGuiBoxReport: "cvGuiBoxReport" [
        status              [integer!]
        func_name           [c-string!]
        err_msg             [c-string!]
        file_name           [c-string!]
        line                [integer!]
        userdata            [byte-ptr!]
        return:             [integer!]
    ]
    
    ; old IPL compatibility
    ;typedef void* (CV_CDECL *CvAllocFunc)(size_t size, void* userdata);
    ;typedef int (CV_CDECL *CvFreeFunc)(void* pptr, void* userdata);
    ; prefer use Red/S
    cvSetMemoryManager: "cvSetMemoryManager" [
        alloc_func           [byte-ptr!] ; CvAllocFunc function pointer
        free_func            [byte-ptr!] ; CvFreeFunc function pointer
        userdata             [byte-ptr!]
    ]
    
   ; Makes OpenCV use IPL functions for IplImage allocation/deallocation (see stdcall below)
    cvSetIPLAllocators: "cvSetIPLAllocators" [
    "Use stdcall old ipl functions" ; 
        create_header       [IplImage!] ; Cv_iplCreateImageHeader  result
        allocate_data       [byte-ptr!] ;Cv_iplAllocateImageData
        deallocate          [byte-ptr!] ;Cv_iplDeallocate
        create_roi          [IplROI!]  ;Cv_iplCreateROI
        clone_image         [IplImage!] ;Cv_iplCloneImage
    ]
    
    #define CV_TURN_ON_IPL_COMPATIBILITY [(cvSetIPLAllocators iplCreateImageHeader iplAllocateImage iplDeallocate iplCreateROIiplCloneImage)]
    
    ;*                                    Data Persistence                                    *
    ;********************************** High-level functions ********************************
    cvOpenFileStorage: "cvOpenFileStorage" [
    "opens existing or creates new file storage"
        filename                [c-string!]
        memstorage              [CvMemStorage!]
        flags                   [integer!]
        return                  [CvFileStorage!]
    ]
    
    cvReleaseFileStorage: "cvReleaseFileStorage" [
    "closes file storage and deallocates buffers"
        fs                      [double-byte-ptr!] ;CvFileStorage** 
    ]
    
    cvAttrValue: "cvAttrValue" [
    "returns attribute value or 0 (NULL) if there is no such attribute"
        attr                    [CvAttrList!]
        attr_name               [c-string!]
        return:                 [byte!] ; 0 or null
    ]
    
    cvStartWriteStruct: "cvStartWriteStruct" [
    "starts writing compound structure (map or sequence)"
        fs                      [CvFileStorage!]
        name                    [c-string!]
        flags                   [integer!]
        type_name               [c-string!]  ;CV_DEFAULT(NULL)
        attribute               [CvAttrList!] ;CV_DEFAULT(cvAttrList()
    ]
    cvEndWriteStruct: "cvEndWriteStruct" [
        "finishes writing compound structure"
        fs                      [CvFileStorage!]
    ]
    
    cvWriteInt: "cvWriteInt" [
    "writes an integer"
        fs                      [CvFileStorage!]
        name                    [c-string!]
        value                   [integer!]  
    ]
    
    cvWriteReal: "cvWriteReal" [
    "writes a floating-point number"
        fs                      [CvFileStorage!]
        name                    [c-string!]
        value                   [float!]  
    ]
    
    cvWriteString: "cvWriteString" [
    "writes a string"
        fs                      [CvFileStorage!]
        name                    [c-string!]
        str                     [c-string!]
        quote                   [integer!]  ; CV_DEFAULT(0)
    ]
    cvWriteComment: "cvWriteComment" [
   "writes a comment"
        fs                      [CvFileStorage!]
        comment                 [c-string!]
        eol_comment             [integer!]          
    ]
    
    ;writes instance of a standard type (matrix, image, sequence, graph etc.)  or user-defined type
    cvWrite: "cvWrite" [
        fs                      [CvFileStorage!]
        name                    [c-string!]
        ptr                     [byte-ptr!]
        attributes              [CvAttrList!] ;CV_DEFAULT(cvAttrList()    
    ]
        
    cvStartNextStream: "cvStartNextStream" [
    "starts the next stream"
        fs                      [CvFileStorage!]
    ]
    
    cvWriteRawData: "cvWriteRawData" [
    "helper function: writes multiple integer or floating-point numbers"
        fs                      [CvFileStorage!]
        src                     [byte-ptr!] ; *void on data
        len                     [integer!]
        dt                      [byte-ptr!]  
    ]
    
    cvGetHashedKey: "cvGetHashedKey" [
    "returns the hash entry corresponding to the specified literal key string or 0 if there is no such a key in the storage"
        fs                      [CvFileStorage!]
        name                    [c-string!]
        len                     [integer!]
        create_missing          [integer!] ;CV_DEFAULT(0)
        return:                 [CvStringHashNode!]
    ]
    cvGetRootFileNode: "cvGetRootFileNode" [
    "returns file node with the specified key within the specified map (collection of named nodes)"
        fs                      [CvFileStorage!]
        stream_index            [integer!]
        return:                 [CvFileNode!]
    ]
    
    cvGetFileNodeByName: "cvGetFileNodeByName" [
    "this is a slower version of cvGetFileNode that takes the key as a literal string"
        fs                      [CvFileStorage!]
        map                     [CvFileNode!]
        name                    [c-string!]
        return:                 [CvFileNode!]
    ]
    
    cvRead: "cvRead" [
    "decodes standard or user-defined object and returns it"
        fs                      [CvFileStorage!]
        node                    [CvFileNode!]
        attributes              [CvAttrList!] ;CV_DEFAULT(NULL)    
    ]
    
    cvStartReadRawData: "cvStartReadRawData" [
    "starts reading data from sequence or scalar numeric node"
        fs                      [CvFileStorage!]
        src                     [CvFileNode!]
        reader                  [CvSeqReader!]
    ]
    
    cvReadRawData: "cvReadRawData" [
    "combination of two previous functions for easier reading of whole sequences"
        fs                      [CvFileStorage!]
        src                     [CvFileNode!]
        dst                     [byte-ptr!]
        dt                      [byte!]
    ]
    cvWriteFileNode: "cvWriteFileNode" [
    "writes a copy of file node to file storage"
        fs                      [CvFileStorage!]
        new_node_name           [c-string!]
        node                    [CvFileNode!]
        embed                   [integer!]
    ]
    cvGetFileNodeName: "cvGetFileNodeName" [
    "returns name of file node"
     node                       [CvFileNode!]
     return:                    [c-string!]
    ]
    
    ;*********************************** Adding own types ***********************************
    cvRegisterType: "cvRegisterType" [info [CvTypeInfo!]]
    cvUnregisterType: "cvUnregisterType" [type_name [c-string!]]
    cvFirstType: "cvFirstType" [ return:     [CvTypeInfo!]]
    cvFindType: "cvFindType" [type_name [c-string!] return: [CvTypeInfo!]]
    cvTypeOf: "cvTypeOf" [struct_ptr [byte-ptr!] return: [CvTypeInfo!]]
    cvClone: "cvClone" [struct_ptr [byte-ptr!] return: [CvTypeInfo!]]
    ;universal functions
    cvRelease: "cvRelease" [struct_ptr [double-byte-ptr!]]
    
    ;simple API for reading/writing data
    cvSave: "cvSave" [
        filename                [c-string!]
        struct_ptr              [byte-ptr!]
        name                    [c-string!]     ;CV_DEFAULT(NULL)
        comment                 [c-string!]     ;CV_DEFAULT(NULL)
        attributes              [CvAttrList!]   ;CV_DEFAULT(cvAttrList() 
    ]
    
    cvLoad: "cvLoad" [
        memstorage              [CvMemStorage!]
        name                    [c-string!]     ;CV_DEFAULT(NULL)
        real_name               [struct! [str [c-string!]]]
    ]
    
    ;*********************************** Measuring Execution Time ***************************
    ;helper functions for RNG initialization and accurate time measurement: uses internal clock counter on x86 
    cvGetTickCount: "cvGetTickCount" [return: [float!]]
    cvGetTickFrequency: "cvGetTickFrequency" [return: [float!]]
    
    ;*********************************** Multi-Threading ************************************
    cvGetNumThreads:"cvGetNumThreads" [return: [integer!]]
    cvSetNumThreads: "cvSetNumThreads" [threads [integer!]]
    ;get index of the thread being executed
    cvGetThreadNum: "cvGetThreadNum" [return: [integer!]]
    ] ;fin cedl
    
    
    ; for old ipl data with stdcall
    cxcore stdcall [
    Cv_iplCreateImageHeader: "Cv_iplCreateImageHeader" [
        n1              [integer!]
        n2              [integer!]
        n3              [integer!]
        s1              [c-string!]
        s2              [c-string!]
        n4              [integer!]
        n5              [integer!]
        n6              [integer!]
        n7              [integer!]
        n8              [integer!] 
        return:         [IplImage!]   
    ]
    
    Cv_iplAllocateImageData: "Cv_iplAllocateImageData" [
        image           [IplImage!]
        n1              [integer!]
        n2              [integer!]
    ]
    Cv_iplDeallocate: " " [
        image           [IplImage!]
        n1              [integer!]
    ]
    
    Cv_iplCreateROI: "Cv_iplCreateROI" [
        n1              [integer!]
        n2              [integer!]
        n3              [integer!]
        n4              [integer!]
        n5              [integer!]
        return:         [IplROI!]    
    ]
    
    Cv_iplCloneImage: "Cv_iplCloneImage" [
        image           [IplImage!]
        return:         [IplImage!]        
    ]
    
    
    
    ]; fin stdcall
]; end import


; inline functions

;Decrements CvMat data reference counter and deallocates the data if it reaches 0
cvDecRefData: func [arr [CvArr!] /local v mat matnd ptr] [
    mat: declare CvMAt! arr
    matnd: declare CvMatND! arr
    if CV_IS_MAT mat [ v: 0
            mat/data: NULL
            if mat/refcount <> null [v: v + 1]
            if mat/refcount/value = 0 [v: v + 1] ;pointeur
            ptr: as double-byte-ptr! mat/refcount
            if v = 2 [cvFree ptr]
    ]
    
    if CV_IS_MATND matnd [ v: 0
            mat/data: NULL
            if mat/refcount <> null [v: v + 1]
            if mat/refcount/value = 0 [v: v + 1] ;pointeur
            ptr: as double-byte-ptr! mat/refcount
            if v = 2 [cvFree ptr]
    ]
]

;increments CvMat data reference counter
cvIncRefData: func [arr [CvArr!] return: [integer!] /local refcount mat matnd ] [
    mat: declare CvMAt! arr
    matnd: declare CvMatND! arr
    refcount: 0
    if CV_IS_MAT mat [ if mat/refcount <> null [refcount: refcount + mat/refcount/value]]
    if CV_IS_MATND matnd [ if mat/refcount <> null [refcount: refcount + mat/refcount/value]]
    refcount       
]


cvGetRow: func [arr [CvArr!] submat [CvMat!] row [integer!]] [cvGetRows arr submat row row + 1 1]
cvGetCol: func [arr [CvArr!] submat [CvMat!] col [integer!]] [cvGetCols arr submat col col + 1]

;inline Releases CvMatND: use CvMatND** mat as parameter
cvReleaseMatND: func [mat [CvMat!]] [ &mat: as double-byte-ptr! mat cvReleaseMat &mat]

;returns next sparse array node (or NULL if there is no more nodes)
;function uses CvSparseMatIterator! as parameter and returns  CvSparseNode! 

cvGetNextSparseNode: func [mat_iterator [CvSparseMatIterator!] return: [CvSparseNode!] /local node idx]
[
    node: declare CvSparseNode! mat_iterator
    either (mat_iterator/node/next <> null) [mat_iterator/node: mat_iterator/node/next]
    [
        
        print ["to be done" lf]
    ]
    node
]

cvSubS: func [src [CvArr!] value [CvScalar!] dst [CvArr!] mask [CvArr!] /local cvalue]  [
    cvalue: declare CvScalar!
    cvalue/v0: 0.0 - value/v0
    cvalue/v1: 0.0 - value/v1
    cvalue/v2: 0.0 - value/v2
    cvalue/v3: 0.0 - value/v3
    cvAddS src cvalue/v0 cvalue/v1 cvalue/v2 cvalue/v3 dst mask
]




cvCloneSeq: func [seq [CvSeq!] storage [CvMemStorage!] defaut [integer!] ] [cvSeqSlice seq CV_WHOLE_SEQ storage 1]
CvCmpFunc: func [a [byte-ptr!] b [byte-ptr!] userdata [byte-ptr!]][
	tmp: 0
	if a < b [tmp: -1]
	if a > b [tmp: 1]
	tmp
]

;inline Fast variant of cvSetAdd; REVOIR
cvSetNew: func [set_header [CvSet!] return: [CvSetElem!] /local elem]
[
	elem: declare CvSetElem!
        either (elem <> null)
            [print "a"]
        
            [print "b"]
        
        
    return elem
]



;REVOIR
;inline Removes set element given its pointer 
;REBOL !! use CvSet! as first parameter and CvSetElem! as second
;cvSetRemoveByPtr: func [set_header elem]

;inline func Returns a set element by index. If the element doesn't belong to the set,NULL is returned
;cvGetSetElem: func [set_header index ]



cvEllipseBox: func [img [CvArr!] box [CvBox2D!] color [CvScalar!]thickness [integer!] line_type [integer!] shift [integer!]
/local axes x y]
[ 
  axes: declare cvSize!
  axes/width: cvRound 0.5 * box/size/height
  axes/height: cvRound 0.5 * box/size/width
  xy: cvPointFrom32f box/center
  x: xy/x
  y: xy/y
  cvEllipse img x y axes/width  axes/height (0.0 + box/angle) 0.0 360.0 color/v2 color/v1 color/v0 color/v3 thickness line_type shift
]

cvFont: func [scale [float!] thickness [integer!] return: [CvFont!]]
[
    font: declare CvFont!
    cvInitFont font CV_FONT_HERSHEY_PLAIN scale scale 0.0 thickness CV_AA
    font
]


; To be controlled UNION
cvReadInt: func [node [CvFilenode!] default_value [integer!] return: [integer!] /local rvalue] [
    either CV_NODE_IS_INT (node/tag)  [rvalue: 1 * node/data/value] [
    either CV_NODE_IS_REAL (node/tag) [rvalue: 1 * node/data/value] [rvalue: 7FFFFFFFh]]
    either node = null [default_value ] [rvalue]   
]

cvReadIntByName: func [fs [CvFileStorage!] map [CvFilenode!] name [c-string!] default_value [integer!] return: [integer!]][
    cvReadInt cvGetFileNodeByName fs map name default_value 
]

cvReadReal: func [node [CvFilenode!] default_value [float!] return: [float!] /local rvalue] [
   either CV_NODE_IS_INT (node/tag)  [rvalue: 1 * node/data/value] [
   either CV_NODE_IS_REAL (node/tag) [rvalue: 1 * node/data/value] [rvalue: E300h]]
   either node = null [default_value ] [ 1.0 * rvalue] 
]

cvReadRealByName: func [fs [CvFileStorage!] map [CvFilenode!] name [c-string!] default_value [float!] return: [float!]][
    cvReadReal cvGetFileNodeByName fs map name default_value 
]

cvReadString: func [node [CvFilenode!] default_value [c-string!] return: [c-string!] /local rvalue][
    either CV_NODE_IS_STRING(node/tag) [rvalue: as integer! node/data/value ] [rvalue: 0]
    either node = null [default_value] [ as c-string! rvalue] 
]


cvReadStringByName: func [fs [CvFileStorage!] map [CvFilenode!] name [c-string!] default_value [c-string!] return: [c-string!]][
    cvReadString cvGetFileNodeByName fs map name  default_value
]


cvReadByName: func [
    "decodes standard or user-defined object and returns it"
        fs                      [CvFileStorage!]
        map                     [CvFileNode!]
        name                    [c-string!]
        attributes              [CvAttrList!] ;CV_DEFAULT(NULL)
    ][
    cvRead  fs cvGetFileNodeByName fs map name attributes    
]


;not in lib but usefull for us

;ATTENTION BGRA values are bit: -128 .. 127 and not 0..255 in OpenCV
; we use a func to transform r fg b a 0..255 to use with red/system

tocvRGB: func [vr [float!] vg [float!] vb [float!] va  [float!] return: [CvScalar!]/local r g b a]
[ val: vr / 255.0 either val > 0.5 [b: val * 127.0] [b: -1.0 * (val * 128.0)]
  val: vg / 255.0 either val > 0.5 [g: val * 127.0] [g: -1.0 * (val * 128.0)]
  val: vb / 255.0 either val > 0.5 [r: val * 127.0] [r: -1.0 * (val * 128.0)]
  if va = 0.0 [a: 0.0]
  if va <> 0.0 [val: va / 255.0 either val > 0.5 [a: val * 127.0] [a: -1.0 * (val * 128.0)]]
   
  cvScalar b g r a
]

_cvGetSize: func [arr [IplImage!] return: [CvSize!] /local s] [
"Returns width and height of array in elements"
    s: declare CvSize!
    s/width: arr/width
    s/height: arr/height
    s ; CvSize! 
]
   


