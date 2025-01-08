/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN274UPC 2.00.00.000}  /*** 010000 ***/
/***********************************************************************
**  Programa.: BOIN274-UPC
**  Descricao: UPC
************************************************************************/
{include/i-epc200.i1}
{method/dbotterr.i}
DEF INPUT PARAM  p-ind-event AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.

define buffer bfordem-compra for ordem-compra.

define variable i-cont     as int  no-undo.
define variable c-mensagem as char no-undo.

DEFINE VARIABLE h-dbo-handle AS HANDLE NO-UNDO.
/* ------------------------------------------- */

FIND FIRST tt-epc
    WHERE (tt-epc.cod-event     = 'beforeUpdateRecord' OR tt-epc.cod-event     = 'afterCreateRecord')

      AND tt-epc.cod-parameter = "Object-Handle":U NO-ERROR.

IF AVAILABLE tt-epc THEN
    ASSIGN h-dbo-handle = WIDGET-HANDLE(tt-epc.val-parameter).
ELSE
    RETURN "OK":U.

IF NOT VALID-HANDLE(h-dbo-handle) THEN
    RETURN "OK":U.

for first tt-epc
    where (tt-epc.cod-event     = 'beforeUpdateRecord' OR tt-epc.cod-event     = 'afterCreateRecord')
      and tt-epc.cod-parameter = 'TABLE-ROWID':
      
    find first bfordem-compra no-lock
        where rowid(bfordem-compra) = to-rowid(tt-epc.val-parameter) no-error.
        
    if avail bfordem-compra then do:
    
        FIND FIRST pedido-compr NO-LOCK 
            WHERE pedido-compr.num-pedido = bfordem-compra.num-pedido NO-ERROR.
    
        IF AVAILABLE pedido-compr THEN DO:
                        
            ASSIGN c-mensagem = "":U
                   i-cont     = 0.
    
            FOR FIRST tb-pr-cc NO-LOCK
                WHERE tb-pr-cc.cod-emitente = pedido-compr.cod-emitente
                  AND tb-pr-cc.cod-cond-pag = pedido-compr.cod-cond-pag
                  AND tb-pr-cc.dt-inicio   <= pedido-compr.data-pedido
                  AND tb-pr-cc.dt-termino  >= pedido-compr.data-pedido
                  AND tb-pr-cc.situacao     = 1,
                EACH item-tab NO-LOCK
                WHERE item-tab.it-codigo    = TRIM(bfordem-compra.it-codigo)
                  AND item-tab.cod-emitente = tb-pr-cc.cod-emitente
                  AND item-tab.cod-cond-pag = tb-pr-cc.cod-cond-pag
                  AND item-tab.nr-tab       = tb-pr-cc.nr-tab:
                  
                FIND FIRST item-fornec USE-INDEX it-forn
                    WHERE item-fornec.it-codigo    = item-tab.it-codigo
                      AND item-fornec.cod-emitente = item-tab.cod-emitente NO-LOCK NO-ERROR.
    
                FIND FIRST moeda
                    WHERE moeda.mo-codigo = tb-pr-cc.mo-codigo NO-LOCK NO-ERROR.
    
                ASSIGN c-mensagem = c-mensagem + STRING(item-tab.quant-min, ">>>>,>>9.9999":U) + " ":U + STRING((IF AVAILABLE item-fornec THEN item-fornec.unid-med-for ELSE "":U), "xx":U) + " - ":U + STRING((IF AVAILABLE moeda THEN moeda.sigla ELSE "":U), "x(04)":U) + " ":U + TRIM(STRING(item-tab.pr-item, ">>>>>,>>>,>>9.99999":U)) + CHR(10)
                       i-cont     = i-cont + 1.
            END. 
    
            IF i-cont > 1 THEN DO:
            
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 27100,
                                   INPUT "Item ~"":U + TRIM(bfordem-compra.it-codigo) + "~" tem variaá∆o de preáo MOQ. Deseja continuar?":U +
                                         "~~":U +
                                         "Item ~"":U + TRIM(bfordem-compra.it-codigo) + "~" tem variaá∆o de preáo MOQ:":U + CHR(10) + CHR(10) + c-mensagem).
    
                IF RETURN-VALUE = "NO":U THEN DO:
                
                    RUN _insertErrorManual IN h-dbo-handle (INPUT 17006,
                                                            INPUT "EMS":U,
                                                            INPUT "ERROR":U,
                                                            INPUT "Variaá∆o de preáo MOQ.",
                                                            INPUT "Processo Interrompido por opá∆o do usu†rio.",
                                                            INPUT "").
                    RETURN "NOK":U.
                END.
            END. 

            IF tt-epc.cod-event  = 'beforeUpdateRecord' THEN DO:
        
                FIND FIRST int-item-uni-estab NO-LOCK
                     WHERE int-item-uni-estab.cod-estabel = pedido-compr.cod-estabel
                       AND int-item-uni-estab.it-codigo   = TRIM(bfordem-compra.it-codigo) NO-ERROR.
    
                IF AVAIL int-item-uni-estab 
                     AND int-item-uni-estab.observacao <> "" THEN DO: 
    
                    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                       INPUT 27979,
                                       INPUT "Item com observaá∆o especial para emiss∆o do pedido." + "~~" + int-item-uni-estab.observacao).
                END.
            END.
        END.
    END.
END.

RETURN "OK".
