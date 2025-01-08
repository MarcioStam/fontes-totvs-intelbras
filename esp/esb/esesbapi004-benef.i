/* Mesma temp-table utilizada no programa esesb005rp...para c lculo dos benef¡cios */
DEF TEMP-TABLE tt-beneficio  NO-UNDO
    FIELD canal                AS INTEGER
    FIELD guid-canal           AS CHAR FORMAT "X(36)"
    FIELD unid-neg             AS CHAR 
    FIELD guid-categoria       AS CHAR FORMAT "X(36)"
    FIELD guid-beneficio       AS CHAR FORMAT "X(36)"
    FIELD tipo-beneficio       AS INTEGER
    FIELD tipo-categoria       AS CHAR
    FIELD guid-class           AS CHAR FORMAT "X(36)"
    FIELD nome-class           AS CHAR FORMAT "X(50)"
    FIELD exclusividade        AS LOGICAL
    FIELD id-status            AS INT
    FIELD calcula-verba        AS LOGICAL
    /*MSG OBTER_PARAMETROS_GLOBAIS*/
    FIELD perc-global          AS DECIMAL
    /*MSG142*/
    FIELD conta-contab         AS CHAR FORMAT "X(20)" 
    FIELD centro-custo         AS CHAR FORMAT "X(20)" 
    FIELD cod-estabel          AS CHAR FORMAT "X(5)"  
    FIELD cod-especie          AS CHAR                
    FIELD tipo-fluxo           AS CHAR
    FIELD perc-custo           AS DECIMAL              /*MSG0142*/   
    FIELD perc-prov-meta       AS DECIMAL              /*MSG0142*/   
    FIELD guid-beneficio-canal AS CHAR FORMAT "X(36)"
            INDEX IDX-PRIMARY IS UNIQUE PRIMARY
            canal
            unid-neg
            tipo-beneficio.

