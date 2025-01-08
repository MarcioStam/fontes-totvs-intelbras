

DEF PARAM BUFFER b-fam-uni-estab      FOR fam-uni-estab.
DEF PARAM BUFFER b-old-fam-uni-estab  FOR fam-uni-estab.


IF  NEW(b-fam-uni-estab) THEN
    assign substring(b-fam-uni-estab.char-1,132,1) = "1" 
                     b-fam-uni-estab.int-1         = 0.
