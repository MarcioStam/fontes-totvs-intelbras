{utp/ut-glob.i}
{include/i-epc200.i1}
{method/dbotterr.i}
{include/boerrtab.i}
{upc/btb910za-upc.i}
def var da-data           as date                      no-undo extent 12.
def var da-partida        as date                      no-undo. 

DEFINE INPUT PARAMETER p-ind-event  AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-epc.

FOR EACH tt-epc 
   WHERE tt-epc.cod-event     = 'FimGeraDocto'
     AND tt-epc.cod-parameter = 'RowidDocumEst':
   FIND FIRST docum-est NO-LOCK
        WHERE ROWID(docum-est) = TO-ROWID(tt-epc.val-parameter) NO-ERROR.
   IF AVAIL docum-est THEN DO:
      FOR EACH dupli-apagar-cex EXCLUSIVE-LOCK
         WHERE dupli-apagar-cex.serie-docto  = docum-est.serie-docto 
           AND dupli-apagar-cex.nro-docto    = docum-est.nro-docto   
           AND dupli-apagar-cex.cod-emitente = docum-est.cod-emitente
           AND dupli-apagar-cex.nat-operacao = docum-est.nat-operacao,
         FIRST emscad.fornecedor NO-LOCK
         WHERE fornecedor.cod_empresa    = v_cod_empres_usuar
           AND fornecedor.cdn_fornecedor = dupli-apagar-cex.cod-emitente-desp
           AND fornecedor.cod_grp_fornec = "50", /* Agente de carga */
         FIRST desp-embarque NO-LOCK
         WHERE desp-embarque.cod-estabel       = docum-est.cod-estabel
           AND desp-embarque.embarque          = docum-est.embarque
           AND desp-embarque.cod-emitente-desp = dupli-apagar-cex.cod-emitente-desp,
         FIRST historico-embarque NO-LOCK
         where historico-embarque.cod-estabel   = docum-est.cod-estabel
           and historico-embarque.embarque      = docum-est.embarque
           and historico-embarque.cod-itiner    = desp-embarque.cod-itiner
           and historico-embarque.cod-pto-contr = desp-embarque.cod-pto-contr,
         FIRST cond-pagto NO-LOCK
         WHERE cond-pagto.cod-cond-pag = desp-embarque.cod-cond-pag:
          RUN pi-calcula-validade.
          ASSIGN dupli-apagar-cex.dt-vencim = da-data[1].
          IF dupli-apagar-cex.dt-vencim < TODAY THEN
             ASSIGN dupli-apagar-cex.dt-vencim = TODAY.
      END.
   END.
END.    

RETURN "Ok":U.

PROCEDURE pi-calcula-validade:
   /**********************************************************
**  CD9020.I7 - C lculo da data de vencimento da duplicata
**              com base no calend-coml
**********************************************************/
def var i-avanco-diaa  as integer no-undo.
def var i-dia-auxa     as integer no-undo.
def var i-ultimo-diaa  as date    no-undo.
DEFINE VARIABLE i-ind AS INTEGER     NO-UNDO.

ASSIGN da-partida = historico-embarque.dt-efetiva.

FIND FIRST emitente NO-LOCK
    WHERE emitente.cod-emitente = desp-embarque.cod-emitente-desp NO-ERROR.
if avail emitente then do:                     
    if  cond-pagto.cod-vencto >= 5 and cond-pagto.cod-vencto <= 8 then
        assign da-partida = da-partida + 1.
    if  cond-pagto.cod-vencto = 5 then
        do  while day(da-partida) <> 1 and day(da-partida) <> 11
                                       and day(da-partida) <> 21:
            assign da-partida = da-partida + 1.
        end.
    if  cond-pagto.cod-vencto = 6 then
        do  while day(da-partida) <> 1 and day(da-partida) <> 16:
            assign da-partida = da-partida + 1.
        end.
    if  cond-pagto.cod-vencto = 7 then
        do  while day(da-partida) <> 1:
            assign da-partida = da-partida + 1.
        end.
    if  cond-pagto.cod-vencto = 8 then
        do  while weekday(da-partida) <> 2:
            assign da-partida = da-partida + 1.
        end.
    if  cond-pagto.dia-mes-base <> 0 and day(da-partida)<> dia-mes-base then
        do  while day(da-partida) <> cond-pagto.dia-mes-base:
            assign da-partida = da-partida + 1.
        end.
    
    if  cond-pagto.dia-sem-base <> 8 and cond-pagto.dia-sem-base <> 0
    and weekday(da-partida)<> dia-sem-base then
        do  while weekday(da-partida) <> cond-pagto.dia-sem-base:
            assign da-partida = da-partida + 1.
        end.
    
    /* Calculo das datas das parcelas */
    do  i-ind = 1 to cond-pagto.num-parcelas:
        assign da-data[i-ind] = da-partida + cond-pagto.prazos[i-ind].
        if  cond-pagto.dia-mes-venc >= 29 then
            assign i-ultimo-diaa = da-data[i-ind]  - day(da-data[i-ind]) + 33
                   i-ultimo-diaa = i-ultimo-diaa - day(i-ultimo-diaa)
                   i-dia-auxa    = if day(i-ultimo-diaa) < cond-pagto.dia-mes-venc
                                     then day(i-ultimo-diaa)
                                     else cond-pagto.dia-mes-venc.
        else
            assign i-dia-auxa = cond-pagto.dia-mes-venc.
        if  cond-pagto.dia-mes-venc <> 0
        and day(da-data[i-ind]) <> i-dia-auxa then
            do  while day(da-data[i-ind]) <> i-dia-auxa:
                assign da-data[i-ind] = da-data[i-ind] + 1.
            end.
        if  cond-pagto.dia-sem-venc <> 8 and cond-pagto.dia-sem-venc <> 0
        and weekday(da-data[i-ind]) <> cond-pagto.dia-sem-venc then
            do  while weekday(da-data[i-ind]) <> cond-pagto.dia-sem-venc:
                assign da-data[i-ind] = da-data[i-ind] + 1.
            end.
    
        find first calen-coml 
             where calen-coml.cod-estabel = docum-est.cod-estabel
             and   calen-coml.ep-codigo   = param-global.empresa-prin
             and   calen-coml.data        = da-data[i-ind]
             no-lock no-error.
        i-avanco-diaa = 0.
        if  avail calen-coml then
            &if defined(bf-mat-comex) &then
              do while calen-coml.tipo-dia <> "1":          
            &else
              do while calen-coml.tipo-dia <> 1:
            &endif
                if weekday(da-data[i-ind]) = 1 then /* Domingo */
                    if  emitente.ven-domingo = 3 then leave.
                    else do:
                        if  i-avanco-diaa = 0 then
                            if emitente.ven-domingo = 2 then
                                assign i-avanco-diaa = -1.
                            else 
                            if  emitente.ven-domingo = 1 then
                                assign i-avanco-diaa = 1.
                        da-data[i-ind] = da-data[i-ind] + i-avanco-diaa.
                    end.
                else
                    if  weekday(da-data[i-ind]) = 7 then /* Sabado */
                        if  emitente.ven-sabado = 3 then leave.
                        else do:
                            if  i-avanco-diaa = 0 then
                                if  emitente.ven-sabado = 2 then
                                    assign i-avanco-diaa = -1.
                                else
                                if  emitente.ven-sabado = 1 then
                                    assign i-avanco-diaa = 1.
                            da-data[i-ind] = da-data[i-ind] + i-avanco-diaa.
                        end.
                    else                            /* Feriado */
                        if  emitente.ven-feriado = 3 then leave.
                        else do:
                            if  i-avanco-diaa = 0 then
                                if  emitente.ven-feriado = 2 then
                                    assign i-avanco-diaa = -1.
                                else
                                if  emitente.ven-feriado = 1 then
                                    assign i-avanco-diaa = 1.
                            da-data[i-ind] = da-data[i-ind] + i-avanco-diaa.
                        end.
                find first calen-coml 
                     where calen-coml.cod-estabel = docum-est.cod-estabel
                     and   calen-coml.ep-codigo   = param-global.empresa-prin
                     and   calen-coml.data        = da-data[i-ind]
                     no-lock no-error.
            end.
    end.

end.
/* CD9020.I7 */


END.


      
