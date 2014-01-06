Red/System [
	Title:		"OpenCV Red Types"
	Author:		"François Jouen"
	Rights:		"Copyright (c) 2012-2013 François Jouen. All rights reserved."
	License: 	"BSD-3 - https:;github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]


;****************** these libraries  are necessary for maths value  **************

#include %C-library.reds ; Kaj de Vos's C lib binding (must be updated to the new ansi version)
#include %math.reds      ; Kaj de Vos's C math lib binding
#include %user.reds      ; Boleslav Brezovsky's conversion functions


;****************** we need some specific structures for talking to OPenCV  **************

; * pointers
;int-ptr! is defined by red
;byte-ptr is defined by red
#define float32-ptr!        [pointer! [float32!]]
#define float-ptr!          [pointer! [float!]]

;** pointers
#define double-byte-ptr!    [struct! [ptr [byte-ptr!]]]    ; equivalent to C's byte **
#define double-int-ptr!     [struct! [ptr [int-ptr!]]]     ; equivalent to C's int **
#define double-float-ptr!   [struct! [ptr [float-ptr!]]]   ; equivalent to C's double **
#define p-buffer!           [struct! [buffer [c-string!]]] ; equivalent to C's char **



;****************** Some comments about this binding  **************


{ OpenCV Conventions: 
Macros are in upperCase. Example:  #define CV_RGB (r g b).

In a few cases, I had to transfrom macros into Functions and
in this case functions are also in upperCase but without parentheses.

OpenCV types and structures are Capitalized. Example: Cv32suf!

Functions and routines begin with 2 lowerCase characters. Example cvShowImage

This binding uses alias for structure definition and follows Red/S convention (!)
OpenCV mainly use pointers to various structures; Thanks to Nenad, pointers are rather easy to use with Red.
For example structures are implicit pointers: great!

CAUTION : OpenCV  use a CvArr* structure as a generic function parameter for images and matrices.
We use a similar CvArr! (a simple byte-ptr).
Structures (IplImage!, CvMat! or even CvSeq!) can not be directly used  when passed as parameter to an external routine wating for a CvArr! parameter
Structures have to be casted  to byte-ptr!
example:
&image: as byte-ptr! image;
By convention, in Red OpenCV libs, all structures are defined as structureName! [structureBody]
By convention, Red/S programs using libs should use name for a structure pointer,  &name for the pointer address
and a &&name for a double pointer

CAUTION : mainy OpenCV routines return *pointers to structures  and in this case we can directly send back our  structureName! such as CvSeq!
In certain cas, structures and not pointers  are returned by the routine. To make the things clearer in the code, in this case we use a _structureName  such as _CvSeq

CAUTION: for the routines requiring a structure (and not a pointer) we have to use structures members as parameters
Example: 
create a size structure

size: declare CvSize! 
    size/width: 1000
    size/height: 700

and use members as parameter 
image: cvCreateImage size/width size/height IPL_DEPTH_32F 3
and not as in C language 
image = cvCreateImage(size, IPL_DEPTH_32F, 3)

}