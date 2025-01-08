/********************************************************************************
 ** Programa..: eswso0020.i
 ** Data......: 26/12/2022
 ** Objetivo..: Include para gera‡Æo do Json.
********************************************************************************/

DEF VAR jsonObjectOutput  AS JsonObject NO-UNDO.
DEF VAR jsonObjectPayload AS jsonObject NO-UNDO.
DEF VAR objNota           AS JsonObject NO-UNDO.
DEF VAR objItens          AS JsonObject NO-UNDO.
DEF VAR objGerais         AS JsonObject NO-UNDO.
DEF VAR objBaixas         AS JsonObject NO-UNDO.
DEF VAR arrayNota         AS jsonArray  NO-UNDO.
DEF VAR arrayItem         AS jsonArray  NO-UNDO.
DEF VAR arrayGerais       AS jsonArray  NO-UNDO.
DEF VAR arrayBaixas       AS jsonArray  NO-UNDO.
DEF VAR jsonArrayPayload  AS jsonArray  NO-UNDO.
DEF VAR c-jason           AS LONGCHAR   NO-UNDO.
DEF VAR l-producao        AS LOG        NO-UNDO.

/****************************************************************************************************/

PROCEDURE pi-gera-json.
    
    /*
    OUTPUT TO "\\erpapp\spool\an052677\nfs\log_v360_prd.txt" APPEND.
    PUT UNFORMATTED "1 - eswso0020" skip(2).
    OUTPUT CLOSE.  
    */

    FIND FIRST docum-est
        WHERE ROWID(docum-est) = p_row_nota NO-LOCK NO-ERROR.

    IF  AVAIL docum-est THEN DO:
        /*
        OUTPUT TO "\\erpapp\spool\an052677\nfs\log_v360_prd.txt" APPEND.
        PUT UNFORMATTED "2 - eswso0020 - docum-est.serie-docto "  docum-est.serie-docto   skip
                                        "docum-est.nro-docto "    docum-est.nro-docto     skip
                                        "docum-est.cod-emitente " docum-est.cod-emitente  skip
                                        "docum-est.nat-operacao " docum-est.nat-operacao  skip(2).
        OUTPUT CLOSE.  
        */

        FIND FIRST docto-orig-nfse NO-LOCK
             WHERE docto-orig-nfse.serie-docto   = docum-est.serie-docto
             AND   docto-orig-nfse.nro-docto     = docum-est.nro-docto
             AND   docto-orig-nfse.cod-emitente  = docum-est.cod-emitente
             AND   docto-orig-nfse.nat-operacao  = docum-est.nat-operacao
             AND   docto-orig-nfse.idi-orig-trad = 2 /* traducao da nfs */ NO-ERROR.

        IF  AVAIL docto-orig-nfse THEN DO:
            /*
            OUTPUT TO "\\erpapp\spool\an052677\nfs\log_v360_prd.txt" APPEND.
            PUT UNFORMATTED "3 - eswso0020 - docum-est.serie-docto "       docum-est.serie-docto   skip
                                            "docum-est.nro-docto "         docum-est.nro-docto     skip
                                            "docum-est.cod-emitente "      docum-est.cod-emitente  skip
                                            "docum-est.nat-operacao "      docum-est.nat-operacao  skip
                                            "docto-orig-nfse.cod-livre-1 " docto-orig-nfse.cod-livre-1 SKIP(2).
            OUTPUT CLOSE.  
            */

            /*ASSIGN c-endereco = /*es-api-URI.end-tst +*/ "http://v360-wso2-homolog.apps.ocp.intelbras.com.br/v360/tax-documents/" + docto-orig-nfse.cod-livre-1.*/

            objNota = NEW JsonObject().
            objNota:ADD("id", string(rowid(docum-est))).
        END.
        /*ELSE
            MESSAGE "eswso0020 - 3" VIEW-AS ALERT-BOX.*/ 
    END.
    
    ASSIGN c-jason = objNota:getjsontext()   /*jsonObjectOutput:getjsontext()*/.
    
END PROCEDURE. 
