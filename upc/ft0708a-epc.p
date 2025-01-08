/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ft0708a-epc 2.03.00.001}  /*** 010001 ***/
/************************************************************************

*************************************************************************/
{include/i-epc200.i1}

def input param p-ind-event as char no-undo.
def input-output param table for tt-epc.

DEF VAR c-unid-neg AS CHAR NO-UNDO.
DEFINE VARIABLE i-cod-unid-neg AS INTEGER     NO-UNDO.
DEF VAR i-empresa    like param-global.empresa-prin NO-UNDO.
CASE p-ind-event:
    WHEN "CONTAB-TRANSF" THEN DO:
        for each tt-epc
            where tt-epc.cod-event = p-ind-event:
            assign tt-epc.cod-parameter = "troca-conta".
        end.    
    END.
    WHEN "before_create_sumar-ft" THEN DO:
        FIND FIRST tt-epc
             WHERE tt-epc.cod-event     = "before_create_sumar-ft"
               AND tt-epc.cod-parameter = "it-nota-fisc rowid"  NO-ERROR.

        IF AVAIL tt-epc THEN DO:

            FIND FIRST it-nota-fisc NO-LOCK
                 WHERE ROWID(it-nota-fisc) = TO-ROWID(tt-epc.val-parameter) NO-ERROR.
             

            IF NOT AVAIL it-nota-fisc THEN
                RETURN "NOK":U.

            FIND FIRST tt-epc
                 WHERE tt-epc.cod-event     = "before_create_sumar-ft"
                   AND tt-epc.cod-parameter = "value_c-conta-aux-upc"  EXCLUSIVE-LOCK NO-ERROR.

            FIND FIRST nota-fiscal NO-LOCK
                 WHERE nota-fiscal.cod-estabel = it-nota-fisc.cod-estabel
                   AND nota-fiscal.serie       = it-nota-fisc.serie
                   AND nota-fiscal.nr-nota-fis = it-nota-fisc.nr-nota-fis NO-ERROR.
            FIND ped-fiscal
                 WHERE ped-fiscal.cod-estabel = nota-fiscal.cod-estabel
                   AND ped-fiscal.serie       = nota-fiscal.serie
                   AND ped-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis
                 NO-LOCK NO-ERROR.
            IF NOT AVAIL nota-fiscal THEN
                RETURN "NOK":U.

/*             FIND item-uni-estab NO-LOCK                                               */
/*                 WHERE item-uni-estab.it-codigo   = it-nota-fisc.it-codigo             */
/*                   AND item-uni-estab.cod-estabel = it-nota-fisc.cod-estabel NO-ERROR. */
/*                                                                                       */
/*             IF  AVAIL item-uni-estab                                                  */
/*             THEN                                                                      */
            
            ASSIGN c-unid-neg =  it-nota-fisc.cod-unid-neg.
/*                                                                                                           */
/*             IF substring(tt-epc.val-parameter,1,1) = "3" AND                                              */
/*                 substring(it-nota-fisc.it-codigo,1,1) <> "4" THEN do: /* Quando for conta de resultado */ */
/*                                                                                                           */
/*                 ASSIGN i-cod-unid-neg = 0.                                                                */
/*                                                                                                           */
/*                 RUN upc/ft0708a-epca.p (INPUT c-unid-neg, OUTPUT i-cod-unid-neg).                         */
/*                                                                                                           */
/*                 IF i-cod-unid-neg <> 0 THEN DO:                                                           */
/*                                                                                                           */
/*                     ASSIGN OVERLAY(tt-epc.val-parameter,11,1) = string(i-cod-unid-neg,"9").               */
/*                                                                                                           */
/*                     RETURN "OK":U.                                                                        */
/*                                                                                                           */
/*                 END.                                                                                      */
/*             END.                                                                                          */
            FIND int-natur-oper WHERE
                 int-natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-LOCK NO-ERROR.

            IF substring(tt-epc.val-parameter,1,1) = "4" /* somente troca a conta que iniciam com 4 */
               AND c-unid-neg <> "" THEN DO:
                FIND FIRST param-global NO-LOCK NO-ERROR.
                ASSIGN i-empresa = param-global.empresa-prin.

                find estabelec where
                     estabelec.cod-estabel = nota-fiscal.cod-estabel no-lock no-error.

                run cdp/cd9970.p (input rowid(estabelec),
                                  output i-empresa).
                IF AVAIL int-natur-oper 
                     AND int-natur-oper.contab-unid-neg THEN DO:
                    FIND FIRST int-unid-neg-natur
                         WHERE int-unid-neg-natur.cod-estabel  = nota-fiscal.cod-estabel
                           AND int-unid-neg-natur.cod-unid-neg = c-unid-neg
                           AND int-unid-neg-natur.nat-operacao = nota-fiscal.nat-operacao NO-ERROR.          
                    IF AVAIL int-unid-neg-natur THEN DO:
                        ASSIGN tt-epc.val-parameter = int-unid-neg-natur.ct-codigo.
                        
                        FIND FIRST tt-epc
                             WHERE tt-epc.cod-event     = "before_create_sumar-ft"
                               AND tt-epc.cod-parameter = "value_c-centro-aux-upc"  EXCLUSIVE-LOCK NO-ERROR.
                        IF AVAIL tt-epc THEN DO:
                            ASSIGN tt-epc.val-parameter = int-unid-neg-natur.sc-codigo.
                        END.
                    END.
                END.

            END.

            IF substring(tt-epc.val-parameter,1,1) = "4" THEN DO: /* somente troca a conta que iniciam com 4 */
            
                IF AVAIL ped-fiscal THEN DO:
                    FIND FIRST tt-epc
                         WHERE tt-epc.cod-event     = "before_create_sumar-ft"
                           AND tt-epc.cod-parameter = "value_c-centro-aux-upc"  EXCLUSIVE-LOCK NO-ERROR.
                    IF AVAIL tt-epc THEN DO:
                        ASSIGN tt-epc.val-parameter = ped-fiscal.sc-codigo.
                    END.
    
                END.           
            END.
            OUTPUT CLOSE.
        END.
    END.
END CASE.

RETURN "OK":U.
