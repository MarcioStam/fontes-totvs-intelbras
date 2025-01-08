/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i RE1005C-EPC 2.03.00.015}  /*** 010015 ***/

/***********************************************************************************/
/** GRE1005C.P - Programa upc que deve ser cadastrado para o programa re1005c     **/
/**              Grava os valores de Rota, Volume e Nome do Transportador na      **/ 
/**              nota fiscal                                                      **/ 
/***********************************************************************************/

{include/i-epc200.i1} /* Definiá∆o da temp-table tt-epc */
def input param p-ind-event  as char  NO-UNDO FORMAT "x(20)".
def input-output param table for tt-epc.

DEFINE VARIABLE r-docum-est  AS ROWID   NO-UNDO.
DEFINE VARIABLE c-docto-novo AS CHARACTER NO-UNDO.
 
FIND FIRST tt-epc WHERE tt-epc.cod-event = p-ind-event NO-LOCK NO-ERROR.
IF AVAIL tt-epc THEN DO:
    CASE p-ind-event:
        WHEN "numero-nota":U THEN DO:
            ASSIGN r-docum-est  = TO-ROWID(tt-epc.val-parameter)
                   c-docto-novo = ENTRY(1,tt-epc.cod-parameter,"*").
            FOR FIRST docum-est WHERE
                ROWID(docum-est) = r-docum-est EXCLUSIVE-LOCK:
                
/*                 ASSIGN docum-est.idi-sit-nf-eletro = 3.  */ /* Com a vers∆o padr∆o do Gati n∆o atualiza automaticamente o status da nota */
                
                FIND FIRST ae-entrada 
                     WHERE ae-entrada.cod-estabel  = docum-est.cod-estabel 
                       AND ae-entrada.nro-docto    = int(c-docto-novo) 
                       AND ae-entrada.cod-emitente = docum-est.cod-emitente  NO-LOCK NO-ERROR.
                IF NOT AVAIL ae-entrada THEN DO:
                    FOR FIRST ae-entrada 
                         WHERE ae-entrada.cod-estabel  = docum-est.cod-estabel 
                           AND ae-entrada.nro-docto    = int(docum-est.nro-docto) 
                           AND ae-entrada.cod-emitente = docum-est.cod-emitente  exclusive-LOCK:
                        ASSIGN ae-entrada.nro-docto = INT(c-docto-novo).
                    END.
                END.
                FIND int-docum-est
                     WHERE int-docum-est.serie-docto  = docum-est.serie-docto
                       AND int-docum-est.nro-docto    = c-docto-novo
                       AND int-docum-est.cod-emitente = docum-est.cod-emitente
                       AND int-docum-est.nat-operacao = docum-est.nat-operacao NO-LOCK NO-ERROR.
                IF NOT AVAIL int-docum-est THEN DO:
                    FOR FIRST int-docum-est
                         WHERE int-docum-est.serie-docto  = docum-est.serie-docto
                           AND int-docum-est.nro-docto    = docum-est.nro-docto
                           AND int-docum-est.cod-emitente = docum-est.cod-emitente
                           AND int-docum-est.nat-operacao = docum-est.nat-operacao EXCLUSIVE-LOCK:
                        ASSIGN int-docum-est.nro-docto = c-docto-novo.
                    END.
                END.
            END.
        END.
    END.
END.
