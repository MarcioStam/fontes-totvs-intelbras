/***********************************************************************
**  Programa..: UPC\CP0313-UPC.P
**  Autor.....: Maicon Correa - Sensus
**  Data......: Janeiro/2014 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

{utp/ut-glob.i}

DEFINE BUFFER b-ord-prod FOR ord-prod.

    /*
DEF VAR c-objeto  AS CHAR            NO-UNDO.
DEF VAR h-frame   AS HANDLE          NO-UNDO.

DEFINE NEW GLOBAL SHARED VAR vNrOrdProdu LIKE ord-prod.nr-ord-produ NO-UNDO.

IF valid-handle(p-wgh-object) THEN
    assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                            p-wgh-object:file-name,"~/").
                            */
/*
MESSAGE 'p-ind-event  ' p-ind-event  SKIP
        'p-ind-object ' p-ind-object SKIP
        'p-cod-table  ' p-cod-table  SKIP
        'p-row-table  ' string(p-row-table) SKIP
        'c-objeto     ' c-objeto
    VIEW-AS ALERT-BOX INFO BUTTONS OK. */
/****************************  Variaveis    ****************************/

IF p-ind-event              = "DEPOIS-ESTORNO"      AND
   p-ind-object             = "BT-OK"               AND 
   p-wgh-object:file-name   = "inbrw/b10in379.w"    THEN DO: 

    FOR FIRST b-ord-prod NO-LOCK
        WHERE ROWID(b-ord-prod) = p-row-table:

        FOR EACH ficha-cq EXCLUSIVE-LOCK
            WHERE ficha-cq.nr-ficha = b-ord-prod.nr-ficha:

            for each ae-inspecao EXCLUSIVE-LOCK
                where ae-inspecao.cod-estabel  = ficha-cq.cod-estabel
                AND   ae-inspecao.nro-docto    = int(ficha-cq.nro-docto)
                and   ae-inspecao.serie        = ficha-cq.serie-docto
                and   ae-inspecao.nat-operacao = ficha-cq.nat-operacao
                and   ae-inspecao.cod-emitente = ficha-cq.cod-emitente:
    
                delete ae-inspecao.
    
            end.

            for each exam-ficha use-index codigo 
                where exam-ficha.nr-ficha = ficha-cq.nr-ficha exclusive-lock:  
                delete exam-ficha. 
            end.

            for each rej-ficha use-index ficha-cq 
                where rej-ficha.nr-ficha = ficha-cq.nr-ficha exclusive-lock: 
                delete rej-ficha.     
            end.

            for each res-fic-cq use-index codigo 
                where res-fic-cq.nr-ficha = ficha-cq.nr-ficha exclusive-lock:
                delete res-fic-cq. 
            end.

            for each tex-ex-fic use-index codigo 
                where tex-ex-fic.nr-ficha = ficha-cq.nr-ficha exclusive-lock:
                delete tex-ex-fic.     
            end. 

            delete ficha-cq.
       
        END.

    END.
    
END.


RETURN "OK":U.
