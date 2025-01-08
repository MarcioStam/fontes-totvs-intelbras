/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i acr777zd_epc 2.00.00.001}  /*** 020001 ***/
/***********************************************************************
************************************************************************/
{include/i-epc200.i1}


def input param  p-ind-event  as char          no-undo.
def input-output param table for tt-epc.
DEFINE VARIABLE c-cod-estabel AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-num-id-tit  AS CHARACTER   NO-UNDO.

CASE p-ind-event:
    WHEN "Consiste pagamento Externo" then do: 
         ASSIGN c-cod-estabel = ""
                c-num-id-tit  = "".
        for each tt-epc no-lock
            where tt-epc.cod-event     = p-ind-event:
              
              IF tt-epc.cod-parameter  = "Cod estab Tit ACR" THEN
                  ASSIGN c-cod-estabel = tt-epc.val-parameter.

              IF tt-epc.cod-parameter  = "Num ID tit ACR" THEN
                  ASSIGN c-num-id-tit  = tt-epc.val-parameter.
        END.

        IF  c-cod-estabel <> "" AND
            c-num-id-tit  <> "" THEN DO:  
             find tit_acr no-lock
                 where tit_acr.cod_estab      = c-cod-estabel
                   and tit_acr.num_id_tit_acr = integer(c-num-id-tit)
                 no-error.
             IF AVAIL tit_acr THEN DO:
/*                  OUTPUT TO c:\temp\acr777zd.txt APPEND.         */
/*                  PUT "acr777zd "                                */
/*                      tit_acr.cdn_cliente " "                    */
/*                      tit_acr.cod_estab          " "             */
/*                                      tit_acr.num_id_tit_acr " " */
/*                      tit_acr.val_origin_tit_acr                 */
/*                      tit_acr.cod_portador SKIP.                 */
                 FOR FIRST ponto-programa NO-LOCK USE-INDEX ponto
                        WHERE ponto-programa.nome-programa = "acr777zd":U
                          AND ponto-programa.ponto         = 1:
    
                        FIND FIRST conteudo-programa
                            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                              AND  conteudo-programa.conteudo    = tit_acr.cod_portador NO-LOCK NO-ERROR.
    
                        IF AVAILABLE conteudo-programa THEN DO:
/*                              PUT "desconsiderou " SKIP. */
                             create tt-epc.
                             assign tt-epc.cod-event     = "Consiste pagamento Externo" /*l_consiste_pagto*/ 
                                    tt-epc.cod-parameter = "log_titulo_pago" /*l_data_base*/  
                                    tt-epc.val-parameter = "YES".
                        END.
                  END.
/*                   OUTPUT CLOSE. */
             END.

        END.
            
    end.
END CASE.
RETURN "OK":U.
