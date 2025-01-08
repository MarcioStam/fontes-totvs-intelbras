DEF TEMP-TABLE tt-canal NO-UNDO
    FIELD canal      AS INTEGER
    FIELD guid-canal AS CHAR FORMAT "x(36)"
    FIELD guid-class AS CHAR FORMAT "x(36)"
       INDEX idx-canal  IS PRIMARY UNIQUE canal .

/*
 DEF TEMP-TABLE tt-fat-mensal-det NO-UNDO LIKE int-fat-mensal-det
     FIELD rebate-antecipado AS LOGICAL.

 DEF TEMP-TABLE tt-fat-mensal     NO-UNDO LIKE int-fat-mensal.
*/
