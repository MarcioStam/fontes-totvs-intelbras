define temp-table tt-central 
    /*Dados canal central, ser∆o so mesmos quando n∆o for apuraá∆o centralizada*/
    FIELD       canal-central AS INTEGER
    FIELD  guid-canal-central AS CHAR FORMAT "x(36)"
    FIELD   dt-adesao-central AS DATE FORMAT "99/99/9999" 
    FIELD  guid-class-central AS CHAR FORMAT "X(36)"
    FIELD  nome-abrev-central AS CHAR
    FIELD   nome-emit-central AS CHAR
    FIELD         cgc-central AS CHAR
    FIELD nome-matriz-central AS CHAR
    FIELD r-row-central       AS ROWID

    /*dados canal filial */
    FIELD        canal-filial AS INTEGER     
    FIELD   nome-abrev-filial AS CHAR 
    FIELD    nome-emit-filial AS CHAR
    FIELD          cgc-filial AS CHAR
    FIELD  nome-matriz-filial AS CHAR 
    FIELD   guid-canal-filial AS CHAR FORMAT "x(36)"
    FIELD    dt-adesao-filial AS DATE FORMAT "99/99/9999" 
    FIELD   guid-class-filial AS CHAR FORMAT "X(36)"
    FIELD        r-row-filial AS ROWID

    FIELD       centralizada       AS LOG
    FIELD      exclusividade      AS LOG  FORMAT "SIM/N«O"                
        INDEX idx-canal IS PRIMARY UNIQUE canal-filial.
