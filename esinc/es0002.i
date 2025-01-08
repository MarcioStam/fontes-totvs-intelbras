&IF {1} = 132 &THEN
    def frame fCabec{1} header
        fill("-",{1}) FORMAT "x(132)" AT 1 SKIP    
        c-empresa at 1 format "x(40)"
        (
         fill(" ", INT((132 - (40 + LENGTH(trim(C-Titulo-Relat)))) / 2)) +
                                           trim(C-Titulo-Relat) +
         fill(" ", INT((132 - (40 + LENGTH(trim(C-Titulo-Relat)))) / 2)) 
        ) FORMAT "x(80)" to 121
        "P gina: " at 122 (page-number (Stream_1)) to 132 format ">>9" 
        fill("-",{1}) FORMAT "x(111)" AT 1
        TODAY at 112 format "99/99/9999"
        "-" at 123
        String(TIME,"HH:MM:SS") at 125 skip (1)
        with no-box no-labels width 132 page-top stream-io.

    def frame fRodape{1} header
        skip (1)
        "--------------------------------------------------------------------------------------------------------------" at 1
        C-Programa at 112
        "-" at 123
        "1.00.000" at 125 skip
        with no-box no-labels width 132 page-bottom stream-io.
&ELSE IF {1} = 255 THEN
    def frame fCabec{1} header
        fill("-",{1}) FORMAT "x(255)" AT 1 SKIP
        c-empresa at 1 format "x(40)"
        
        (
         fill(" ", INT(({1} - (40 + LENGTH(trim(C-Titulo-Relat)))) / 2)) +
                                           trim(C-Titulo-Relat) +
         fill(" ", INT(({1} - (40 + LENGTH(trim(C-Titulo-Relat)))) / 2)) 
        ) FORMAT "x(200)" to 244 
        "P gina: " at 245 (page-number (Stream_1)) to 255 format ">>9" 
        skip
        fill("-",{1}) FORMAT "x(234)" AT 1
        TODAY at 235 format "99/99/9999"
        "-" at 246
        String(TIME,"HH:MM:SS") at 248 skip (1)
        with no-box no-labels width {1} page-top stream-io.
      
    def frame fRodape{1} header
        skip (1)
        fill("-",{1}) FORMAT "x(234)" AT 1
        C-Programa FORMAT 'x(10)' at 235
        "-" at 246
        "1.00.000" at 248 skip
        with no-box no-labels width {1} page-bottom stream-io.
&ENDif.
