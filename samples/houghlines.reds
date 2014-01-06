Red/System [
	Title:		"OpenCV Tests: Houghlines"
	Author:		"François Jouen"
	Rights:		"Copyright (c) 2012-2013 François Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

#include %../opencv.reds

h: as time-reference! 0
t1: 0
t2: 0

t1: now-time h


filename: "/Users/fjouen/Desktop/newOpenCV/red/samples/images/building.jpg"


src: cvLoadImage filename 0
&src: as byte-ptr! src
&&src: declare double-byte-ptr!
&&src/ptr: &src

dst: cvCreateImage src/width src/height 8 1
&dst: as byte-ptr! dst
&&dst: declare double-byte-ptr!
&&dst/ptr: &dst

color_dst: cvCreateImage src/width src/height 8 3
&color_dst: as byte-ptr! color_dst
&&color_dst: declare double-byte-ptr!
&&color_dst/ptr: &color_dst

cvCanny &src &dst 50.0 200.0 3
cvCvtColor &dst &color_dst CV_GRAY2BGR

storage: declare CvMemStorage!
storage: cvCreateMemStorage 0
&storage: as byte-ptr! storage

lines: declare CvSeq!
line: as int-ptr! lines ; should be a float pointer but float do not work (??)

rho: 0.0
theta: 0.0
pt1: declare CvPoint!
pt2: declare CvPoint!
a: 0.0
b: 0.0
x0: 0.0
y0: 0.0
bb: 0.0

; OK function is sending back values in lines 
;print [lines/flags " " lines/total " " lines/h_prev " " lines/h_next  " " lines/v_prev " " lines/v_next lf]
;print [lines/total " " lines/elem_size " " as integer! lines/block_max " " as integer! lines/ptr " " lines/delta_elems lf]
;print [as integer! lines/storage " " lines/free_blocks " " as integer! lines/first lf]



HNormal: func [] [
    lines: cvHoughLines2 &dst &storage CV_HOUGH_STANDARD 1.0 CV_PI / 180.0 100 0.0 0.0
    i: 0
    correction: 0
    until [
        line: as int-ptr! cvGetSeqElem lines i  ; adresse du pointeur
        rho: 1.0 * line/1                       ; cast to float! OK
        theta: 1.0 * line/2                     ; cast to float! OK
        a: cosine-radians theta
        b: sine-radians theta
        x0: a * rho
        y0: b * rho
        bb: 0.0 - b ; negate b
        pt1/x: CvRound (x0 + (1000.0 * bb)) 
        pt1/y: CvRound (y0 + (1000.0 * a)) 
        pt2/x: CvRound (x0 - (1000.0 * bb))
        pt2/y: CvRound (y0 - (1000.0 * a))
        ;print [i " "x0 " "y0  " " a " "  bb" " pt1/x  " " pt1/y " " pt2/x " "  pt2/y lf]
        cvLine &color_dst pt1/x pt1/y pt2/x pt2/y 0.0 0.0 255.0 0.0 3 CV_AA 0
        i: i + 1
        i =  MIN(lines/total 100)  
    ]
]

HProba: func [] [
    lines:  cvHoughLines2  &dst &storage CV_HOUGH_PROBABILISTIC 1.0 CV_PI / 180.0 50 50.0 10.0
  ; print [lines/flags " " lines/header_size  " " lines/h_prev " " lines/h_next  " " lines/v_prev " " lines/v_next lf]
  ; print [lines/total " " lines/elem_size " " as integer! lines/block_max " " as integer! lines/ptr " " lines/delta_elems lf]
   ;print [as integer! lines/storage " " lines/free_blocks " " as integer! lines/first lf]
    i: 0
    until [
        line: as int-ptr! cvGetSeqElem lines i  ; pointeur address with data
        pt1/x: line/1
        pt1/y: line/2
        pt2/x: line/3
        pt2/y: line/4
        print [line " " i " : " pt1/x " " pt1/y " " pt2/x " " pt2/y lf]
        cvLine &color_dst pt1/x pt1/y pt2/x pt2/y 0.0 0.0 255.0 0.0 3 CV_AA 0
        i: i + 1
        i = lines/total
    ]   
]




;use either
HProba
;HNormal

  
cvNamedWindow "Source" 1
cvShowImage "Source" &src

cvNamedWindow "Hough" 1

cvMoveWindow "Hough" 1000 100
cvShowImage "Hough" &color_dst

t2: now-time h

print ["Test done in " subtract-time t2 t1 " sec" lf]

cvWaitKey(0);
