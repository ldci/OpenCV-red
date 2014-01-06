Red/System [
	Title:		"OpenCV Camera Test"
	Author:		"François Jouen"
	Rights:		"Copyright (c) 2012-2013 François Jouen. All rights reserved."
	License:     "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

#include %../opencv.reds


; function pointer that can be called by TrackBar callback 
trackEvent: func [[cdecl] pos [integer!]/local p][
    p: (1.0 * pos)
    ;seuil: p / 100.0
print [p " " pos " Threshold : " seuil lf]]  


lineType: CV_AA;
thickness: 2
method: CV_TM_CCOEFF_NORMED
min_val: 0.0
max_val: 0.0

&min_val: :min_val ; pointer 
&max_val: :max_val ; pointer

&min_loc: declare cvPoint! 0 0
&max_loc: declare cvPoint! 0 0
max_loc2: declare CvPoint! 0 0

seuil: 0.0
&seuil_int: declare pointer! [integer!] 



; use  default camera 
cvStartWindowThread ; separate window thread

capture: cvCreateCameraCapture CV_CAP_ANY ; create a cature using default webcam (iSight) ; change to n for other cam

src:  cvRetrieveFrame capture; cvCreateImage 640 480 8 3
&src: as byte-ptr! src ; pointer address
&&src: declare double-byte-ptr!
&&src/ptr: &src; double pointeur

w: src/width / 4 
h: src/height / 2

cvNamedWindow "Out" CV_WINDOW_AUTOSIZE 

templ: cvCreateImage w h 8 3
&templ: as byte-ptr! templ ; pointer address
&&templ: declare double-byte-ptr!
&&templ/ptr: &templ; double pointeur

cvNamedWindow "Template" CV_WINDOW_AUTOSIZE


;définition de la taille(largeur, hauteur) de l'image ftmp
iwidth: src/width - templ/width + 1
iheight: src/height - templ/height + 1
ftmp: cvCreateImage iwidth iheight IPL_DEPTH_32F 1
&ftmp: as byte-ptr! ftmp ; pointer address
&&ftmp: declare double-byte-ptr!
&&ftmp/ptr: &ftmp; double pointeur

cvNamedWindow "max min" CV_WINDOW_AUTOSIZE


cadre_pt1: declare CvPoint! cadre_pt1/x: ((src/width - templ/width) / 2) cadre_pt1/y: ((src/height - templ/height) / 2)
cadre_pt2: declare CvPoint! cadre_pt2/x: cadre_pt1/x + templ/width cadre_pt2/y: cadre_pt1/y + templ/height



cvCreateTrackbar "Threshold" "Out" &seuil_int 100 :trackEvent ; function as parameter


roi: declare cvRect!
key: 0
while [key <> 27] [
    src: cvRetrieveFrame capture
   ; &src: as byte-ptr! src
    ;applique le filtre médian pour réduire le bruit
    cvSmooth &src &src CV_GAUSSIAN 3 3 0.0 0.0
    
    ;si la touche 'espace' code ASCII '32' est appuyée, on enregistre le template à partir de l'image 'src'
    if key = 32 [
        cvZero &templ
        cvRectangle &src cadre_pt1/x cadre_pt1/y cadre_pt2/x cadre_pt2/y 0.0 0.0 255.0 0.0 thickness lineType 0
        roi: cvRect cadre_pt1/x cadre_pt1/y templ/width templ/height
        ;print [roi/x " " roi/y  " " roi/width " " roi/height lf]
        cvSetImageROI src roi/x roi/y roi/width roi/height
        cvCopy &src &templ null
        cvShowImage "Template" &templ 
        cvResetImageROI src
    ]
    ; if touche  = r 
    ;if key = 114
    cvMatchTemplate &src &templ &ftmp method ;OK
    
    cvMinMaxLoc &ftmp &min_val &max_val &min_loc &max_loc null
    max_val: &max_val/value
    max_loc2/x: &max_loc/x + templ/width 
    max_loc2/y: &max_loc/y + templ/height
    
    if  max_val < 1.0 [
        if  max_val > seuil [cvRectangle &src &max_loc/x &max_loc/y max_loc2/x max_loc2/y 0.0 255.0 0.0 0.0 thickness lineType 0]
    ]

    cvShowImage "Out" &src
    cvShowImage "max min" &ftmp
    
    key: cvWaitKey 1
]
