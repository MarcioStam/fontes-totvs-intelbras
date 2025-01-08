/***********************************************************************
**  Programa.: ft2010-upc.p
**  Autor ...: Datasul S/A
**  Descricao: Gera o NSU na efetiva‡Æo da nota fiscal de sa¡da atrav‚s 
**             dos programas FT2015, RE1005, RI0207
************************************************************************/
{include/i-epc200.i ft2010}

DEF INPUT PARAM p-ind-event  AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.

IF  p-ind-event = "Single-Point":U THEN DO:

    FIND FIRST tt-epc WHERE
               tt-epc.cod-event     = p-ind-event           AND
               tt-epc.cod-parameter = "nota-fiscal rowid":U NO-LOCK NO-ERROR.
    IF  AVAIL tt-epc THEN DO:
        FIND FIRST nota-fiscal WHERE
             ROWID(nota-fiscal) = TO-ROWID(tt-epc.val-parameter) NO-LOCK NO-ERROR.
        IF  AVAIL nota-fiscal THEN
            FIND FIRST esp-nsu-estabel WHERE
                       esp-nsu-estabel.cod-estabel = nota-fiscal.cod-estabel EXCLUSIVE-LOCK NO-ERROR.
            IF  AVAIL esp-nsu-estabel THEN DO:
                IF  esp-nsu-estabel.num-seq-unico = 9999999999 THEN
                    ASSIGN esp-nsu-estabel.num-seq-unico = 0000000001.
                ELSE
                    ASSIGN esp-nsu-estabel.num-seq-unico = esp-nsu-estabel.num-seq-unico + 1.
                
                CREATE esp-nsu-gera.
                ASSIGN esp-nsu-gera.cod-estabel   = nota-fiscal.cod-estabel
                       esp-nsu-gera.serie         = nota-fiscal.serie
                       esp-nsu-gera.nr-nota-fis   = nota-fiscal.nr-nota-fis
                       esp-nsu-gera.num-seq-unico = esp-nsu-estabel.num-seq-unico
                       esp-nsu-gera.dt-gera-nsu   = DATE(STRING(DAY(TODAY)) + "/" + STRING(MONTH(TODAY),"99") + "/" + STRING(SUBSTR(STRING(YEAR(TODAY),"9999"),3,2))). 
                       esp-nsu-gera.hr-gera-nsu   = STRING(TIME,"HH:MM").
            END.
    END.

END.
