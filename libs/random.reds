Red/System [
  Title:		"Random first draft"
	Author:		"Arnold van Hofwegen"
	Rights:		"Copyright (c) 2011-2013 Arnold van Hofwegen. All rights reserved."
	License:  {to be determined}
	About:    {This program is completely based on the random algorythm by Knuth
	           It has been translated to Red/System language. 
	           I absolutely give NO guaranty about this program still being correct
	           and producing random numbers.}
]

KK: 101                         ; KK: 100
LL:  38                         ; LL:  37
MM: 1 << 30                     ; the modulus 

#define mod_diff(x y) [((x) - (y)) and (MM - 1)] ; subtraction mod MM 

ran_x: as int-ptr! allocate 101 * size? integer!
aa:    as int-ptr! allocate 101 * size? integer!

idx1: 1
idx2: 1
twoj: 1
twoj-1: 1
j-1: 1

ran_array: func [
    aa [pointer! [integer!]]
    n [integer!] ; array length n has to be at least as big as KK
    /local i [integer!]
           j [integer!]
][
    j: 1
    while [j <= KK][
        aa/j: ran_x/j
        j: j + 1
    ]
    while [j < n][
        idx1: j - KK + 1
        idx2: j - LL + 1
        aa/j: mod_diff(aa/idx1 aa/idx2);
        j: j + 1
    ]
    i: 1
    while [i <= LL][
        idx1: j - KK + 1
        idx2: j - LL + 1
        ran_x/i: mod_diff(aa/idx1 aa/idx2)
        i: i + 1
        j: j + 1
    ]
    while [i <= KK][
        idx1: j - KK + 10
        idx2: i - LL + 1
        ran_x/i: mod_diff(aa/idx1 ran_x/idx2)
        i: i + 1
        j: j + 1
    ] 
]

;QUALITY: 1009
ran_arr_buf: as int-ptr! allocate 1009 * size? integer!
ran_arr_dummy: -1 
ran_arr_started: -1
ran_arr_ptr: declare pointer! [integer!]
ran_arr_ptr/value: ran_arr_dummy

TT: 70
#define is_odd(x) [(x) and (1)] ; test on the unit bit of x 

ra: as int-ptr! allocate 202 * size? integer!
ran_start: func [seed [integer!]
                 /local
                 t [integer!]
                 j [integer!]
                 ;x [rarray!] ;array 2 * KK (in C it is KK+KK-1 )
                 ss [integer!]
                ][
    ss: ((seed + 2) and (MM - 2))
    j: 1
    while [j <= KK][
        ra/j: ss
        ss: ss << 1
        if  MM < ss [
            ss: ss - (MM - 2)
        ]
        j: j + 1        
    ]
    ra/1: ra/1 + 1 ; Make only ra/1 odd
    ;
    ; for (ss=seed&(MM-1),t=TT-1; t; )
    ss: (seed and (MM - 1))
    t: TT - 1
    while [t > 0][
        j: KK ;  base 1 not 0 removed: - 1
        while [j > 0][
            ; C source comment: "square"
            twoj: j + j
            twoj-1: twoj - 1
            ra/twoj: ra/j
            ra/twoj-1: 0
            j: j - 1
        ]
        ;
        j: KK + KK - 2 ; How to adapt this for base 1 versus base 0?
        while [KK <= j][
            idx1: j - (KK - LL) + 1
            ra/idx1: mod_diff(ra/idx1 ra/j)
            idx2: j - KK + 1
            ra/idx2: mod_diff(ra/idx2 ra/j)
            j: j - 1
        ]
        if  (is_odd(ss) = 1) [
            j: KK
            while [j > 1][
                j-1: j - 1
                ra/j: ra/j-1
                j: j - 1
            ]
            ; Note: this next line used index 0 and that reminded me of the difference 
            ; using the zero'th element in the array that we do not!!
            ; source is kind of adapted to corrcet this.
            ra/1: ra/KK ; C source comment: shift buffer cyclically
            ra/LL: mod_diff(ra/LL ra/KK)
        ]
        ;
        either ss > 0 [
            ss: ss >> 1
        ][
            t: t - 1
        ]
    ]
    ;
    j: 1
    while [j <= LL][
        idx1: j + KK - LL
        ran_x/idx1: ra/j
        j: j + 1
    ]
    ;
    while [j <= KK][
        idx1: j - LL
        ran_x/idx1: ra/j
        j: j + 1
    ]
    ;
    j: 1
    while [j <= 10][
        ran_array ra (KK + KK - 1); Warm things up
        j: j + 1
    ]
    ;
    ran_arr_ptr/value: ran_arr_started 
]

ran_arr_next: func [][
    either ran_arr_ptr/value > 0 [
        ran_arr_ptr/value: ran_arr_ptr/value + 1
    ][
        ran_arr_cycle
    ]
]

ran_arr_cycle: func [return: [integer!]][
    if  ran_arr_ptr/value = ran_arr_dummy [
        ran_start(314159) ; User forgot to initialize, this uses pi (why not tau?)
    ]
    ran_arr_buf/KK: -1
    ran_arr_ptr: ran_arr_buf + 1
    return ran_arr_buf/1
]

rval: ran_arr_cycle
print rval


free as byte-ptr! ran_x
free as byte-ptr! ra

;End with newline
print newline
