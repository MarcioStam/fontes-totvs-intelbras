/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BODI317va-upc 2.03.01.050}  /*** 010150 ***/
{include/i-epc200.i bodi317}
DEFINE INPUT        PARAMETER p-ind-event AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-epc.

{method/dbotterr.i}
{esp/es0018.i} 

DEFINE BUFFER b-tt-epc      FOR tt-epc.
DEFINE BUFFER b-wt-it-docto FOR wt-it-docto.
DEFINE BUFFER b-wt-fat-ser-lote FOR wt-fat-ser-lote.
DEFINE BUFFER b-nota-fisc-adc   FOR nota-fisc-adc.

DEFINE VARIABLE i-cod-servico       AS INTEGER     NO-UNDO.
DEFINE VARIABLE r-wt-docto          AS ROWID       NO-UNDO.
DEFINE VARIABLE rw-wt-docto         AS ROWID       NO-UNDO.
DEFINE VARIABLE r-wt-it-docto       AS ROWID       NO-UNDO.
DEFINE VARIABLE h-cdapi704          AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-rua               AS CHARACTER   FORMAT "x(70)" NO-UNDO.
DEFINE VARIABLE c-nro               AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-comp              AS CHARACTER   FORMAT "x(80)" NO-UNDO.
DEFINE VARIABLE da-data             AS DATETIME    NO-UNDO.
DEFINE VARIABLE da-data-atual       AS DATETIME    NO-UNDO.
DEFINE VARIABLE da-data-ini         AS DATETIME    NO-UNDO.
DEFINE VARIABLE  l-servico          AS LOGICAL     NO-UNDO.
DEFINE VARIABLE  l-produto          AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-indice            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-encontrou         AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-nota-compl-imp    AS LOGICAL    INIT NO NO-UNDO.
DEFINE VARIABLE cReturn             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-wmsErro           AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-mensagem          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cest              AS INTEGER     NO-UNDO.
DEFINE VARIABLE h-esmsspapi001      AS HANDLE      NO-UNDO.
DEFINE VARIABLE l-eh-ser-servico    AS LOG INIT NO NO-UNDO.
DEFINE VARIABLE l-deducao           AS LOG         NO-UNDO.

DEFINE VARIABLE l-simulacao-espdp027 AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-tem-ST             AS LOGICAL     NO-UNDO.

DEFINE VARIABLE d-total              AS DEC         NO-UNDO.

{utp/ut-glob.i} 
{cdp/cd0666.i} 
{esp/pdp/espdp006fn.i}
{include/boini.i}
def temp-table rowerrorsaux NO-UNDO like rowerrors.
def var h-bodi317pr     as handle no-undo.
def var h-bodi317sd     as handle no-undo.
def var h-bodi317im1bra as handle no-undo.
def var h-bodi317va     as handle no-undo.
def var h-bodi317in     as handle no-undo.
def var h-bodi317pd     as handle no-undo.
def var h-bodi317ef     as handle no-undo.
def var h-bodi317ef2    as handle no-undo.

def var l-proc-ok-aux   as log    no-undo.
DEF VAR i-cont AS INTEGER.
 
def var i-seq-wt-docto     like wt-it-docto.seq-wt-docto    no-undo.
def var i-seq-wt-it-docto  like wt-it-docto.seq-wt-it-docto no-undo.

def var c-ultimo-metodo-exec as char no-undo.
DEF BUFFER b-natur-oper FOR natur-oper.
DEF BUFFER b-emitente FOR emitente.


//Chamado C2106-0760 - Serie distinta Entreposto Manaus
IF p-ind-event = 'validaNatOperacaoGeral' THEN DO:
   FOR EACH tt-epc
       WHERE tt-epc.cod-event     = p-ind-event
         AND tt-epc.cod-parameter = 'rowid_wt-docto':
        
       FIND FIRST wt-docto WHERE ROWID(wt-docto) = TO-ROWID(tt-epc.val-parameter) EXCLUSIVE-LOCK NO-ERROR.

       IF AVAIL wt-docto THEN DO:
          FIND FIRST int-natur-oper 
               WHERE int-natur-oper.nat-operacao = wt-docto.nat-operacao 
          NO-LOCK NO-ERROR.
               
          IF AVAIL int-natur-oper THEN DO:
             IF int-natur-oper.serie <> '' THEN
                ASSIGN wt-docto.serie = int-natur-oper.serie.
          END.
       END.
   END.    
END.



IF p-ind-event = "afterValidaIntegracaoFretes" THEN DO:

    FIND FIRST tt-epc
         WHERE tt-epc.cod-event   = p-ind-event
           AND tt-epc.cod-parameter = "object-handle" NO-LOCK NO-ERROR.

    ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).

    FIND FIRST tt-epc
         WHERE tt-epc.cod-event     = p-ind-event
           AND tt-epc.cod-parameter = "TABLE-ROWID" NO-ERROR.

    IF  AVAIL tt-epc THEN DO:
        FOR FIRST wt-docto
            WHERE ROWID(wt-docto) = TO-ROWID(tt-epc.val-parameter) NO-LOCK:

            /* SIMULACAO CALCULO PEDIDOS ECOMMERCE */
            IF wt-docto.nr-prog = 9993 THEN NEXT.

            RUN pi-libera-simulacao-fat (OUTPUT l-simulacao-espdp027).

            IF l-simulacao-espdp027 THEN NEXT.   
            
            FOR EACH wt-fat-ser-lote NO-LOCK
               WHERE wt-fat-ser-lote.seq-wt-docto = wt-docto.seq-wt-docto:
                
                IF CAN-FIND(FIRST b-wt-fat-ser-lote NO-LOCK
                            WHERE b-wt-fat-ser-lote.seq-wt-docto     = wt-fat-ser-lote.seq-wt-docto
                              AND b-wt-fat-ser-lote.seq-wt-it-docto <> wt-fat-ser-lote.seq-wt-it-docto
                              AND b-wt-fat-ser-lote.cod-depos       <> wt-fat-ser-lote.cod-depos) THEN DO:

                    RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                           INPUT "EMS",
                                                           INPUT "ERROR",
                                                           INPUT "N∆o Ç permitido faturar dois dep¢sitos na mesma NF!",
                                                           INPUT "Deve ser gerado uma NF para cada dep¢sito!",
                                                           INPUT "").
                    RETURN.
                END.
            END.
        END.
    END.
END.

IF p-ind-event = "aftervalidaItemDaNota" THEN DO:

    FIND FIRST tt-epc
        WHERE tt-epc.cod-event   = p-ind-event
        AND tt-epc.cod-parameter = "TABLE-ROWID" NO-ERROR.

    IF  AVAIL tt-epc THEN DO:

        FOR FIRST wt-docto
            WHERE  ROWID(wt-docto) = TO-ROWID(tt-epc.val-parameter) NO-LOCK:

            FIND FIRST estabelec  WHERE estabelec.cod-estabel   = wt-docto.cod-estabel  NO-LOCK NO-ERROR.

            FOR EACH wt-it-docto OF wt-docto NO-LOCK,
                FIRST natur-oper
                WHERE natur-oper.nat-operacao = wt-it-docto.nat-operacao NO-LOCK,
                FIRST item
                WHERE item.it-codigo = wt-it-docto.it-codigo NO-LOCK:

                IF natur-oper.tipo = 2 AND wt-docto.nat-operacao BEGINS "6" AND
                    (item.codigo-orig = 3 OR item.codigo-orig = 5 OR item.codigo-orig = 8) THEN DO:

                    ASSIGN c-indice = (TRIM(wt-docto.cod-estabel ) + CHR(2) + TRIM(wt-it-docto.it-codigo) + CHR(2)) NO-ERROR.

                    IF  c-indice <> "":U THEN DO:

                        ASSIGN l-encontrou = NO.

                        FOR FIRST reg-inf-compl NO-LOCK /*Registros gravados no FT0918*/
                            WHERE reg-inf-compl.cod-tab-inform   = "FCI":U
                            AND   reg-inf-compl.cod-campo-inform = "FCI":U,
                            LAST inf-compl NO-LOCK  /*Èltimo registro iniciando com Cod Estabel + Item - a leitura ir† buscar pela ultima data*/
                            WHERE inf-compl.cdn-identif = reg-inf-compl.cdn-identif /*6*/
                            AND inf-compl.cod-indice BEGINS c-indice
                            AND inf-compl.dat-campo <= TODAY: /*Filtro por data da FCI em relaá∆o a data da emiss∆o da nota*/
                            
                            ASSIGN l-encontrou = YES.
                        END.

                        IF l-encontrou = NO THEN DO:

                            FIND tt-epc
                                WHERE tt-epc.cod-event   = p-ind-event
                                AND tt-epc.cod-parameter = "object-handle" NO-LOCK NO-ERROR.

                            ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).

                            RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                                   INPUT "EMS",
                                                                   INPUT "ERROR",
                                                                   INPUT "item " + wt-it-docto.it-codigo + " com CST (C¢digo de Situaá∆o Tribut†ria) = 3, 5 ou 8 e que n∆o possui n£mero de FCI Cadastrada, entre em contato com grupo.tributario@intelbras.com.br",
                                                                   INPUT "item " + wt-it-docto.it-codigo + " com CST (C¢digo de Situaá∆o Tribut†ria) = 3, 5 ou 8 e que n∆o possui n£mero de FCI Cadastrada, entre em contato com grupo.tributario@intelbras.com.br",
                                                                   INPUT "").
                        END.
                    END.
                END.



            END.
        END.
    END.
END.

IF p-ind-event = "Message27565" THEN DO:

    /* SIMULACAO CALCULO PEDIDOS ECOMMERCE */
    FIND first tt-epc 
         where tt-epc.cod-event = "Message27565"
           AND tt-epc.cod-parameter = "rowid-ped-venda" NO-ERROR.
    IF AVAIL tt-epc THEN DO:

        RUN pi-libera-simulacao-fat (OUTPUT l-simulacao-espdp027).

        FIND FIRST ped-venda NO-LOCK
             WHERE ROWID(ped-venda) = TO-ROWID(tt-epc.val-parameter)
               AND ped-venda.origem = 12
               AND ped-venda.user-impl = 'adm' NO-ERROR.

        IF AVAIL ped-venda OR l-simulacao-espdp027 THEN DO:
            for first tt-epc 
                where tt-epc.cod-event = p-ind-event
                  AND tt-epc.cod-parameter = "ShowMessage27565":
                ASSIGN tt-epc.val-parameter = "NO".
            END.
        END.
    END.
END.

IF p-ind-event = "VALIDATE-MSG-15047" THEN DO:
    
    for first tt-epc 
        where tt-epc.cod-event = p-ind-event
          AND tt-epc.cod-parameter = "MSG-15047":
        ASSIGN tt-epc.cod-parameter = "MSG-15047-RETURN"
               tt-epc.val-parameter = "NO".
    END.

    for first tt-epc 
        where tt-epc.cod-event = "Inicio-bodi317va"
          AND tt-epc.cod-parameter = "OBJECT-HANDLE":   

        if  valid-handle(widget-handle(tt-epc.val-parameter)) then do:

            ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).  
    
            RUN GetRowerrors IN h-bodi317va (OUTPUT table RowErrorsAux).
            run EmptyRowErrors in h-bodi317va.
    
            for each RowErrorsAux
               where (RowErrorsAux.ErrorNumber = 15045
                  OR  RowErrorsAux.ErrorNumber = 15046
                  OR  RowErrorsAux.ErrorNumber = 27179) :
                delete RowErrorsAux.
            END.

            FOR EACH RowErrorsAux:
                RUN _insertErrorManual IN h-bodi317va (INPUT RowErrorsAux.errornumber,
                                                       INPUT RowErrorsAux.ERRORtype,
                                                       INPUT RowErrorsAux.ERRORsubtype, 
                                                       INPUT RowErrorsAux.errordescription,
                                                       INPUT RowErrorsAux.errorhelp,
                                                       INPUT "":U).   
                DELETE RowErrorsAux.
            END.
        END.
    END. /* FOR EACH tt-epc */
END.

IF  p-ind-event = "antes-validar-nota" THEN DO:

    FIND FIRST tt-epc NO-LOCK
        WHERE  tt-epc.cod-event     = p-ind-event
        AND    tt-epc.cod-parameter = "this-procedure":U NO-ERROR.
    IF AVAIL tt-epc THEN DO:

    ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).

   END. /* IF AVAIL tt-epc THEN DO: (cod-parameter = "this-procedure") */                                

    FIND FIRST tt-epc
        WHERE tt-epc.cod-event     = p-ind-event
        AND tt-epc.cod-parameter = "TABLE-ROWID" NO-ERROR.
    IF  AVAIL tt-epc THEN DO:

        ASSIGN da-data-atual =  DATETIME(TODAY, MTIME). 

        FIND FIRST wt-docto EXCLUSIVE-LOCK
            WHERE  ROWID(wt-docto) = to-rowid(tt-epc.val-parameter) NO-ERROR.        
        IF AVAIL wt-docto THEN DO:

            /**   Bloqueio Fat - Estabelecimento   **/
            /**   Bloqueio Fat - Estabelecimento   **/
            /**   Bloqueio Fat - Estabelecimento   **/
            find tt-epc
                  where tt-epc.cod-event     = p-ind-event
                    AND tt-epc.cod-parameter = "this-procedure"
                    NO-LOCK NO-ERROR.
            ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).

            IF  (INDEX(PROGRAM-NAME(1),'ft4001') <> 0 AND INDEX(PROGRAM-NAME(1),'ft4001') <> ?) OR  
                (INDEX(PROGRAM-NAME(2),'ft4001') <> 0 AND INDEX(PROGRAM-NAME(2),'ft4001') <> ?) OR  
                (INDEX(PROGRAM-NAME(3),'ft4001') <> 0 AND INDEX(PROGRAM-NAME(3),'ft4001') <> ?) OR  
                (INDEX(PROGRAM-NAME(4),'ft4001') <> 0 AND INDEX(PROGRAM-NAME(4),'ft4001') <> ?) OR  
                (INDEX(PROGRAM-NAME(5),'ft4001') <> 0 AND INDEX(PROGRAM-NAME(5),'ft4001') <> ?) OR  
                (INDEX(PROGRAM-NAME(6),'ft4001') <> 0 AND INDEX(PROGRAM-NAME(6),'ft4001') <> ?) OR  
                (INDEX(PROGRAM-NAME(7),'ft4001') <> 0 AND INDEX(PROGRAM-NAME(7),'ft4001') <> ?) OR  
                (INDEX(PROGRAM-NAME(8),'ft4001') <> 0 AND INDEX(PROGRAM-NAME(8),'ft4001') <> ?) 
            OR
                (INDEX(PROGRAM-NAME(1),'ft4100') <> 0 AND INDEX(PROGRAM-NAME(1),'ft4100') <> ?) OR  
                (INDEX(PROGRAM-NAME(2),'ft4100') <> 0 AND INDEX(PROGRAM-NAME(2),'ft4100') <> ?) OR  
                (INDEX(PROGRAM-NAME(3),'ft4100') <> 0 AND INDEX(PROGRAM-NAME(3),'ft4100') <> ?) OR  
                (INDEX(PROGRAM-NAME(4),'ft4100') <> 0 AND INDEX(PROGRAM-NAME(4),'ft4100') <> ?) OR  
                (INDEX(PROGRAM-NAME(5),'ft4100') <> 0 AND INDEX(PROGRAM-NAME(5),'ft4100') <> ?) OR  
                (INDEX(PROGRAM-NAME(6),'ft4100') <> 0 AND INDEX(PROGRAM-NAME(6),'ft4100') <> ?) OR  
                (INDEX(PROGRAM-NAME(7),'ft4100') <> 0 AND INDEX(PROGRAM-NAME(7),'ft4100') <> ?) OR  
                (INDEX(PROGRAM-NAME(8),'ft4100') <> 0 AND INDEX(PROGRAM-NAME(8),'ft4100') <> ?) 
            THEN DO:

                  FIND FIRST bloqueio-fat NO-LOCK.
                  IF AVAIL bloqueio-fat THEN
                      IF bloqueio-fat.dt-bloq-ft4001-ft4100 <> ? THEN DO:
                         ASSIGN da-data-ini =  datetime(bloqueio-fat.dt-bloq-ft4001-ft4100).

                         RUN bloq-faturamento(INPUT da-data-ini  ,
                                              INPUT ROWID(tt-epc),
                                              INPUT bloqueio-fat.usua-ft4001-ft4100,
                                              INPUT wt-docto.cod-estabel,
                                              INPUT bloqueio-fat.estab-ft4001-ft4100).

                         RUN bloq-faturamento-estab (INPUT da-data-ini  ,
                                                     INPUT ROWID(tt-epc),
                                                     INPUT wt-docto.cod-estabel,
                                                     INPUT bloqueio-fat.estab-ft4001-ft4100,
                                                     INPUT bloqueio-fat.usua-ft4001-ft4100).
                      END. /* IF bloqueio-fat.dt-bloq-ft4001-ft4100 <> ? THEN DO: */

            END. /* IF  (INDEX(PROGRAM-NAME(1),'ft4001-ft4100') <> 0 AND INDEX(PROGRAM-NAME(1),'ft4001-ft4100') <> ?) OR   */

            IF  (INDEX(PROGRAM-NAME(1),'ft4002') <> 0 AND INDEX(PROGRAM-NAME(1),'ft4002') <> ?) OR  
                (INDEX(PROGRAM-NAME(2),'ft4002') <> 0 AND INDEX(PROGRAM-NAME(2),'ft4002') <> ?) OR  
                (INDEX(PROGRAM-NAME(3),'ft4002') <> 0 AND INDEX(PROGRAM-NAME(3),'ft4002') <> ?) OR  
                (INDEX(PROGRAM-NAME(4),'ft4002') <> 0 AND INDEX(PROGRAM-NAME(4),'ft4002') <> ?) OR  
                (INDEX(PROGRAM-NAME(5),'ft4002') <> 0 AND INDEX(PROGRAM-NAME(5),'ft4002') <> ?) OR  
                (INDEX(PROGRAM-NAME(6),'ft4002') <> 0 AND INDEX(PROGRAM-NAME(6),'ft4002') <> ?) OR  
                (INDEX(PROGRAM-NAME(7),'ft4002') <> 0 AND INDEX(PROGRAM-NAME(7),'ft4002') <> ?) OR  
                (INDEX(PROGRAM-NAME(8),'ft4002') <> 0 AND INDEX(PROGRAM-NAME(8),'ft4002') <> ?) 
            THEN DO:

                  FIND FIRST bloqueio-fat NO-LOCK.
                  IF AVAIL bloqueio-fat THEN
                      IF bloqueio-fat.dt-bloq-ft4002 <> ? THEN DO:
                         ASSIGN da-data-ini =  datetime(bloqueio-fat.dt-bloq-ft4002).

                         RUN bloq-faturamento(INPUT da-data-ini  ,
                                              INPUT ROWID(tt-epc),
                                              INPUT bloqueio-fat.usua-ft4002,
                                              INPUT wt-docto.cod-estabel,
                                              INPUT bloqueio-fat.estab-ft4002).

                         RUN bloq-faturamento-estab (INPUT da-data-ini  ,
                                                     INPUT ROWID(tt-epc),
                                                     INPUT wt-docto.cod-estabel,
                                                     INPUT bloqueio-fat.estab-ft4002,
                                                     INPUT bloqueio-fat.usua-ft4002).
                      END. /* IF bloqueio-fat.dt-bloq-ft4002 <> ? THEN DO: */

            END. /* IF  (INDEX(PROGRAM-NAME(1),'ft4002') <> 0 AND INDEX(PROGRAM-NAME(1),'ft4002') <> ?) OR   */

            IF  (INDEX(PROGRAM-NAME(1),'ft4003') <> 0 AND INDEX(PROGRAM-NAME(1),'ft4003') <> ?) OR  
                (INDEX(PROGRAM-NAME(2),'ft4003') <> 0 AND INDEX(PROGRAM-NAME(2),'ft4003') <> ?) OR  
                (INDEX(PROGRAM-NAME(3),'ft4003') <> 0 AND INDEX(PROGRAM-NAME(3),'ft4003') <> ?) OR  
                (INDEX(PROGRAM-NAME(4),'ft4003') <> 0 AND INDEX(PROGRAM-NAME(4),'ft4003') <> ?) OR  
                (INDEX(PROGRAM-NAME(5),'ft4003') <> 0 AND INDEX(PROGRAM-NAME(5),'ft4003') <> ?) OR  
                (INDEX(PROGRAM-NAME(6),'ft4003') <> 0 AND INDEX(PROGRAM-NAME(6),'ft4003') <> ?) OR  
                (INDEX(PROGRAM-NAME(7),'ft4003') <> 0 AND INDEX(PROGRAM-NAME(7),'ft4003') <> ?) OR  
                (INDEX(PROGRAM-NAME(8),'ft4003') <> 0 AND INDEX(PROGRAM-NAME(8),'ft4003') <> ?) 
            THEN DO:

                  FIND FIRST bloqueio-fat NO-LOCK.
                  IF AVAIL bloqueio-fat THEN
                      IF bloqueio-fat.dt-bloq-ft4003 <> ? THEN DO:
                         ASSIGN da-data-ini =  datetime(bloqueio-fat.dt-bloq-ft4003).

                         RUN bloq-faturamento(INPUT da-data-ini  ,
                                              INPUT ROWID(tt-epc),
                                              INPUT bloqueio-fat.usua-ft4003,
                                              INPUT wt-docto.cod-estabel,
                                              INPUT bloqueio-fat.estab-ft4003).

                         RUN bloq-faturamento-estab (INPUT da-data-ini  ,
                                                     INPUT ROWID(tt-epc),
                                                     INPUT wt-docto.cod-estabel,
                                                     INPUT bloqueio-fat.estab-ft4003,
                                                     INPUT bloqueio-fat.usua-ft4003).
                      END. /* IF bloqueio-fat.dt-bloq-ft4003 <> ? THEN DO: */

            END. /* IF  (INDEX(PROGRAM-NAME(1),'ft4003') <> 0 AND INDEX(PROGRAM-NAME(1),'ft4003') <> ?) OR   */
            /** FIM Bloqueio Fat - Estabelecimento **/
            /** FIM Bloqueio Fat - Estabelecimento **/
            /** FIM Bloqueio Fat - Estabelecimento **/

            IF (wt-docto.cod-estabel = "101"
             OR wt-docto.cod-estabel = "104"
             OR wt-docto.cod-estabel = "601"
             OR wt-docto.cod-estabel = "602")
            AND (wt-docto.serie       = "R2" 
            OR  wt-docto.serie       = "R3")  THEN DO:

                 RUN _insertErrorManual IN h-bodi317va (INPUT 99988,
                                                        INPUT "EMS",
                                                        INPUT "ERROR",
                                                        INPUT "Serie Invalida. Para NF de servico Por gentileza utilizar serie R4 ",
                                                        INPUT "Serie Invalida. Para NF de servico Por gentileza utilizar serie R4 ",
                                                        INPUT "").



            END.
            
            for first ponto-programa
                where ponto-programa.nome-programa = "bodi317va"
                      NO-LOCK,
                 EACH conteudo-programa NO-LOCK
                WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                  and ENTRY(1, conteudo-programa.conteudo, ";") = wt-docto.cod-estabel:
                find tt-epc
                      where tt-epc.cod-event     = p-ind-event
                        AND tt-epc.cod-parameter = "this-procedure"
                        NO-LOCK NO-ERROR.

                ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).  
                RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                       INPUT "EMS",
                                                       INPUT "ERROR",
                                                       INPUT "Estabelecimento Bloqueado para Emiss∆o de Notas Fiscais",
                                                       INPUT "Estabelecimento Bloqueado para Emiss∆o de Notas Fiscais",
                                                       INPUT "").


            END.
            
           /* IF wt-docto.nome-transp BEGINS "retira" THEN DO:
                IF wt-docto.cod-emitente = 151373 THEN
                    ASSIGN OVERLAY(wt-docto.char-1,158,1) = "0".  /* Por solicitaá∆o Cristiane - Controladoria - chamado ir110265 - 07/08 - 11:04 */
                ELSE
                    ASSIGN OVERLAY(wt-docto.char-1,158,1) = "3".  
            END. */

            FIND FIRST emitente NO-LOCK 
                WHERE emitente.cod-emitente = wt-docto.cod-emitente NO-ERROR.

            FIND FIRST estabelec NO-LOCK 
                WHERE estabelec.cod-estabel = wt-docto.cod-estabel NO-ERROR.

            FIND FIRST natur-oper NO-LOCK
                WHERE natur-oper.nat-operacao = wt-docto.nat-operacao NO-ERROR.

            IF natur-oper.terceiros THEN DO:
                FOR EACH wt-it-docto OF wt-docto NO-LOCK:
                    IF  CAN-FIND (FIRST int-natur-oper-item NO-LOCK
                                     WHERE int-natur-oper-item.nat-operacao = wt-it-docto.nat-operacao 
                                       AND int-natur-oper-item.it-codigo    = wt-it-docto.it-codigo) THEN DO:
                        ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).  
                        RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                               INPUT "EMS",
                                                               INPUT "ERROR",
                                                               INPUT "Item " + wt-it-docto.it-codigo + " n∆o pode ser movimentado com natureza de operaá∆o que atualiza saldo em poder de terceiros",
                                                               INPUT "Item " + wt-it-docto.it-codigo + " n∆o pode ser movimentado com natureza de operaá∆o que atualiza saldo em poder de terceiros",
                                                               INPUT "").
                    END.
                END.
            END.

            IF  natur-oper.emite-duplic 
            AND wt-docto.nr-pedcli = "" THEN DO:

                IF wt-docto.ind-tip-nota = 50 THEN
                    ASSIGN l-nota-compl-imp = YES.

                IF l-nota-compl-imp = NO THEN DO:
                    ASSIGN l-nota-compl-imp = NO.
                    FOR FIRST ponto-programa
                        where ponto-programa.nome-programa = "bodi317va"
                          AND ponto-programa.ponto         = 2
                              NO-LOCK,
                         FIRST conteudo-programa NO-LOCK
                        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                          and conteudo-programa.conteudo = v_cod_usuar_corren:    
                        ASSIGN l-nota-compl-imp = YES.
                        
                    END.
                    IF l-nota-compl-imp = NO THEN DO:
                        find tt-epc
                                  where tt-epc.cod-event     = p-ind-event
                                    AND tt-epc.cod-parameter = "this-procedure"
                                    NO-LOCK NO-ERROR.
        
                        ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).  
                        RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                       INPUT "EMS",
                                                       INPUT "ERROR",
                                                       INPUT "Faturamento que gera cobranáa Ç obrigat¢rio a emiss∆o de pedido de venda",
                                                       INPUT "Faturamento que gera cobranáa Ç obrigat¢rio a emiss∆o de pedido de venda",
                                                       INPUT "").
                    END.
                END.
     
            END.
            FIND loc-entr
                WHERE loc-entr.nome-abrev = wt-docto.nome-abrev
                  AND loc-entr.cod-entrega = wt-docto.cod-entrega 
                NO-LOCK NO-ERROR.
            
            IF emitente.estado = "EX" THEN DO:

                IF NOT wt-docto.nat-operacao BEGINS "7" THEN DO:
                   find tt-epc
                      where tt-epc.cod-event     = p-ind-event
                        AND tt-epc.cod-parameter = "this-procedure"
                        NO-LOCK NO-ERROR.

                    ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).  
                    RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                           INPUT "EMS",
                                                           INPUT "ERROR",
                                                           INPUT "Para operaá‰es internacionais deve ser utilizada uma natureza de operaá∆o que inicie com 7",
                                                           INPUT "Para operaá‰es internacionais deve ser utilizada uma natureza de operaá∆o que inicie com 7",
                                                           INPUT "").
                END.
            END.

            IF wt-docto.ind-tip-nota = 5  THEN DO:
                IF natur-oper.tipo <> 3 /* servico */ THEN DO:
                    IF natur-oper.mercado = 1 /* interno */ THEN DO:
                        IF loc-entr.estado <> estabelec.estado THEN DO:
                            IF  NOT wt-docto.nat-operacao BEGINS "2"
                            AND NOT wt-docto.nat-operacao BEGINS "3" THEN DO:
                                find tt-epc
                                      where tt-epc.cod-event     = p-ind-event
                                        AND tt-epc.cod-parameter = "this-procedure"
                                        NO-LOCK NO-ERROR.
            
                                ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).  
            
                                RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                                       INPUT "EMS",
                                                                       INPUT "ERROR",
                                                                       INPUT "Para operaá‰es interestaduais de Entrada a natureza de operaá∆o deve iniciar com 2",
                                                                       INPUT "Para operaá‰es interestaduais de Entrada a natureza de operaá∆o deve iniciar com 2",
                                                                       INPUT "").
                            END.
                        END.
                        ELSE DO:
                            IF  NOT wt-docto.nat-operacao BEGINS "1"
                            AND NOT wt-docto.nat-operacao BEGINS "3" THEN DO:
                                find tt-epc
                                      where tt-epc.cod-event     = p-ind-event
                                        AND tt-epc.cod-parameter = "this-procedure"
                                        NO-LOCK NO-ERROR.
            
                                ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).  
            
                                RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                                       INPUT "EMS",
                                                                       INPUT "ERROR",
                                                                       INPUT "Para operaá‰es estaduais de Entrada a natureza de operaá∆o deve iniciar com 1",
                                                                       INPUT "Para operaá‰es estaduais de Entrada a natureza de operaá∆o deve iniciar com 1",
                                                                       INPUT "").
                            END.
                        END.
                    END.
                    ELSE DO:
                        IF  NOT wt-docto.nat-operacao BEGINS "3"THEN DO:
                            FIND FIRST tt-epc NO-LOCK
                                 WHERE tt-epc.cod-event     = p-ind-event
                                   AND tt-epc.cod-parameter = "this-procedure" NO-ERROR.
    
                            ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter). 
                            RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                                   INPUT "EMS",
                                                                   INPUT "ERROR",
                                                                   INPUT "Para operaá‰es de Importaá∆o a natureza de operaá∆o deve iniciar com 3",
                                                                   INPUT "Para operaá‰es de Importaá∆o a natureza de operaá∆o deve iniciar com 3",
                                                                   INPUT "").
                        END.
                    END.
                END. /* natur-oper.tipo <> 3 /* servico */ */
            END.
            ELSE DO:
                IF natur-oper.tipo <> 3 /* servico */ THEN DO:
                    IF natur-oper.mercado = 1 /* interno */ THEN DO:
                        IF loc-entr.estado <> estabelec.estado THEN DO:
            
                            IF  NOT wt-docto.nat-operacao BEGINS "6"
                            AND NOT wt-docto.nat-operacao BEGINS "8" THEN DO:
                                find tt-epc
                                      where tt-epc.cod-event     = p-ind-event
                                        AND tt-epc.cod-parameter = "this-procedure"
                                        NO-LOCK NO-ERROR.
            
            
                                ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter). 
                                RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                                       INPUT "EMS",
                                                                       INPUT "ERROR",
                                                                       INPUT "Para operaá‰es interestaduais de Sa°da a natureza de operaá∆o deve iniciar com 6",
                                                                       INPUT "Para operaá‰es interestaduais de Sa°da a natureza de operaá∆o deve iniciar com 6",
                                                                       INPUT "").
                            END.
                        END.
                        ELSE DO:
                            
                            IF  NOT wt-docto.nat-operacao BEGINS "5" 
                            AND NOT wt-docto.nat-operacao BEGINS "8"    THEN DO:
                                find tt-epc
                                      where tt-epc.cod-event     = p-ind-event
                                        AND tt-epc.cod-parameter = "this-procedure"
                                        NO-LOCK NO-ERROR.
                                
            
                                ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).  
                                RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                                       INPUT "EMS",
                                                                       INPUT "ERROR",
                                                                       INPUT "Para operaá‰es estaduais de Sa°da a natureza de operaá∆o deve iniciar com 5",
                                                                       INPUT "Para operaá‰es estaduais de Sa°da a natureza de operaá∆o deve iniciar com 5",
                                                                       INPUT "").
                            END.
                        END.
                    END.
                    ELSE DO:
                        IF  NOT wt-docto.nat-operacao BEGINS "7" THEN DO:
                            FIND FIRST tt-epc NO-LOCK
                                 WHERE tt-epc.cod-event     = p-ind-event
                                   AND tt-epc.cod-parameter = "this-procedure" NO-ERROR.
    
                            ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter). 
                            RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                                   INPUT "EMS",
                                                                   INPUT "ERROR",
                                                                   INPUT "Para operaá‰es de Exportaá∆o a natureza de operaá∆o deve iniciar com 7",
                                                                   INPUT "Para operaá‰es de Exportaá∆o a natureza de operaá∆o deve iniciar com 7",
                                                                   INPUT "").
                        END.
                    END.
                END. /* natur-oper.tipo <> 3 /* servico */ */
            END.

            IF NOT CAN-FIND (FIRST modalid-frete WHERE modalid-frete.cod-modalid-frete = substring(wt-docto.char-1,158,8)) THEN DO:
                    find tt-epc
                          where tt-epc.cod-event     = p-ind-event
                            AND tt-epc.cod-parameter = "this-procedure"
                            NO-LOCK NO-ERROR.

                    ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).  
                    RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                           INPUT "EMS",
                                                           INPUT "ERROR",
                                                           INPUT "Deve ser informado uma unidade de frete valida existente no cadastro cd0600",
                                                           INPUT "Deve ser informado uma unidade de frete valida existente no cadastro cd0600",
                                                           INPUT "").
            END.
            
            IF AVAIL estabelec THEN DO:
                IF estabelec.estado = wt-docto.estado  AND
                   estabelec.pais = "brasil"           and
                   substring(wt-docto.nat-operacao,1,1) <> "5" AND
                   substring(wt-docto.nat-operacao,1,1) <> "8" THEN DO:
                    find tt-epc
                          where tt-epc.cod-event     = p-ind-event
                            AND tt-epc.cod-parameter = "this-procedure"
                            NO-LOCK NO-ERROR.

                    ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).  
                    RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                           INPUT "EMS",
                                                           INPUT "ERROR",
                                                           INPUT "Para notas dentro de estado devera ser utilizado naturezas iniciando com 5 - " + string(wt-docto.cod-emitente),
                                                           INPUT "Para notas dentro de estado devera ser utilizado naturezas iniciando com 5 - " + string(wt-docto.cod-emitente),
                                                           INPUT "").
                END.
            END.

            /*Com o MasterSaf, n∆o ser† mais permitido itens de venda e itens de serviáo na mesma nota.*/
            FIND FIRST b-natur-oper NO-LOCK
                WHERE b-natur-oper.nat-operacao = wt-docto.nat-operacao NO-ERROR.
            ASSIGN l-servico = NO
                   l-produto = NO
                   i-cod-servico = 0.

            FOR EACH wt-it-docto OF wt-docto NO-LOCK
                ,FIRST natur-oper  NO-LOCK
                    WHERE natur-oper.nat-operacao = wt-it-docto.nat-operacao:

                IF wt-docto.nr-pedcli = "" AND
                   AVAIL unid-neg-canal-venda THEN DO:
                    FIND b-wt-it-docto
                         WHERE ROWID(b-wt-it-docto) = rowid(wt-it-docto) EXCLUSIVE-LOCK NO-ERROR.
                    IF AVAIL b-wt-it-docto THEN DO:
                       FIND FIRST unid_negoc NO-LOCK
                            WHERE unid_negoc.cdn_unid_negoc = unid-neg-canal-venda.cdn_unid_negoc NO-ERROR.
                       IF AVAIL unid_negoc THEN DO:
                           ASSIGN b-wt-it-docto.cod-unid-neg = unid_negoc.cod_unid_negoc.
                       END.

                       RELEASE b-wt-it-docto.
                    END.                    
                END.
                FIND FIRST ITEM NO-LOCK
                     WHERE ITEM.it-codigo = wt-it-docto.it-codigo NO-ERROR.

                 IF AVAIL ITEM THEN DO:
                     /*97507*/
                     FIND FIRST tab-codser NO-LOCK
                          WHERE tab-codser.cod-servico = ITEM.cod-servico
                            AND SUBSTRING(tab-codser.char-1,1,4) <> "" NO-ERROR.

                     IF AVAIL tab-codser THEN DO:
                        IF i-cod-servico = 0 THEN
                           ASSIGN i-cod-servico = ITEM.cod-servico.
                        ELSE
                            IF i-cod-servico <> ITEM.cod-servico THEN
                               ASSIGN i-cod-servico = 999999. /* significa que tem itens de serviáo com codigos diferentes, n∆o permitido pela prefeitura */
                        ASSIGN l-servico = YES.
                     END.
                     ELSE
                        ASSIGN l-produto = YES.

                        /* Desativado Temporariamente por solicitaá∆o Hudson - chamado 3814 */

                      IF natur-oper.tipo = 2 AND
                        wt-docto.nat-operacao BEGINS "6" AND
                        (ITEM.codigo-orig = 3 OR
                         ITEM.codigo-orig = 5 OR
                         ITEM.codigo-orig = 8) THEN DO:
                         ASSIGN c-indice = (TRIM(wt-docto.cod-estabel ) + CHR(2) +
                                            TRIM(wt-it-docto.it-codigo) + CHR(2)) NO-ERROR.

                         IF  c-indice <> "":U THEN DO:

                             ASSIGN l-encontrou = NO.
                             FOR FIRST reg-inf-compl NO-LOCK /*Registros gravados no FT0918*/
                                 WHERE reg-inf-compl.cod-tab-inform   = "FCI":U
                                 AND   reg-inf-compl.cod-campo-inform = "FCI":U,

                                  LAST inf-compl NO-LOCK  /*Èltimo registro iniciando com Cod Estabel + Item - a leitura ir† buscar pela ultima data*/
                                 WHERE inf-compl.cdn-identif = reg-inf-compl.cdn-identif /*6*/
                                   AND inf-compl.cod-indice BEGINS c-indice
                                   AND inf-compl.dat-campo <= TODAY: /*Filtro por data da FCI em relaá∆o a data da emiss∆o da nota*/
                                 ASSIGN l-encontrou = YES.
                              END.
                              IF l-encontrou = NO THEN DO:
                                    find tt-epc
                                          where tt-epc.cod-event     = p-ind-event
                                            AND tt-epc.cod-parameter = "this-procedure"
                                            NO-LOCK NO-ERROR.

                                    ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).
                                    RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                                           INPUT "EMS",
                                                                           INPUT "ERROR",
                                                                           INPUT "item " + wt-it-docto.it-codigo + " com CST (C¢digo de Situaá∆o Tribut†ria) = 3, 5 ou 8 e que n∆o possui n£mero de FCI Cadastrada, entre em contato com grupo.tributario@intelbras.com.br",
                                                                           INPUT "item " + wt-it-docto.it-codigo + " com CST (C¢digo de Situaá∆o Tribut†ria) = 3, 5 ou 8 e que n∆o possui n£mero de FCI Cadastrada, entre em contato com grupo.tributario@intelbras.com.br",
                                                                           INPUT "").
                             END.

                         END.
                    END.
             
                 END.
                 
                 IF ITEM.fm-cod-com = "" THEN DO:
                 
                      find tt-epc
                         where tt-epc.cod-event     = p-ind-event
                           AND tt-epc.cod-parameter = "this-procedure"
                           NO-LOCK NO-ERROR.
                      ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).
             
                      RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                             INPUT "EMS",
                                                             INPUT "ERROR",
                                                             INPUT "Familia comercial em branco no cadastro do item " + ITEM.it-codigo,
                                                             INPUT "Informe a familia comercial no cadastro do item cd0204",
                                                             INPUT "").
                 END.
                 IF  natur-oper.tipo <> b-natur-oper.tipo THEN DO:
                     find tt-epc
                         where tt-epc.cod-event     = p-ind-event
                           AND tt-epc.cod-parameter = "this-procedure"
                           NO-LOCK NO-ERROR.
                      ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).
             
                      RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                             INPUT "EMS",
                                                             INPUT "ERROR",
                                                             INPUT "Itens com tipos de natureza inv†lidos",
                                                             INPUT "Itens de naturezas de serviáo e de venda n∆o pode estar juntos na mesma nota fiscal",
                                                             INPUT "").
                 END.
                 
                 IF AVAIL emitente
                    AND emitente.contrib-icms = YES 
                    AND substring(wt-docto.nat-operacao,1,1) <> "7"
                    AND  wt-docto.estado <> estabelec.estado THEN DO:

                     FIND int-wt-it-docto                                                                      
                    WHERE int-wt-it-docto.seq-wt-docto     = wt-it-docto.seq-wt-docto                     
                      AND int-wt-it-docto.seq-wt-it-docto  = wt-it-docto.seq-wt-it-docto NO-LOCK NO-ERROR.
                     
                     IF AVAIL int-wt-it-docto THEN DO:

                        IF    INDEX(PROGRAM-NAME(1),'esftp009') = 0 and 
                              INDEX(PROGRAM-NAME(2),'esftp009') = 0 and 
                              INDEX(PROGRAM-NAME(3),'esftp009') = 0 and 
                              INDEX(PROGRAM-NAME(4),'esftp009') = 0 and 
                              INDEX(PROGRAM-NAME(5),'esftp009') = 0 and 
                              INDEX(PROGRAM-NAME(6),'esftp009') = 0 and 
                              INDEX(PROGRAM-NAME(7),'esftp009') = 0 and 
                              INDEX(PROGRAM-NAME(8),'esftp009') = 0 THEN DO:
                          
                    
                                IF (int-wt-it-docto.codigo-orig = 1
                                OR  int-wt-it-docto.codigo-orig = 2
                                OR  int-wt-it-docto.codigo-orig = 3
                                OR  int-wt-it-docto.codigo-orig = 8) THEN DO:
        
                                    FOR EACH wt-it-imposto OF wt-it-docto NO-LOCK
                                       WHERE wt-it-imposto.aliquota-icm <> 4:
                                       find tt-epc
                                         where tt-epc.cod-event     = p-ind-event
                                           AND tt-epc.cod-parameter = "this-procedure"
                                           NO-LOCK NO-ERROR.
        
                                       ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).
                                       RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                                              INPUT "EMS",
                                                                              INPUT "ERROR",
                                                                              INPUT "Aliquota de ICMS Incorreta, Entre em Contato com Grupo Tributario, Item = " + wt-it-docto.it-codigo,
                                                                              INPUT "Aliquota de ICMS Incorreta, Entre em Contato com Grupo Tributario, Item = " + wt-it-docto.it-codigo,
                                                                              INPUT "").
                                    END.
                                    
                                END.
                                ELSE
                                    IF (int-wt-it-docto.codigo-orig = 0
                                    OR  int-wt-it-docto.codigo-orig = 4
                                    OR  int-wt-it-docto.codigo-orig = 5
                                    OR  int-wt-it-docto.codigo-orig = 6
                                    OR  int-wt-it-docto.codigo-orig = 7) THEN DO:
            
                                        FOR EACH wt-it-imposto OF wt-it-docto NO-LOCK
                                           WHERE wt-it-imposto.aliquota-icm = 4:
                                           find tt-epc
                                             where tt-epc.cod-event     = p-ind-event
                                               AND tt-epc.cod-parameter = "this-procedure"
                                               NO-LOCK NO-ERROR.
            
                                           ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).
                                           RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                                                  INPUT "EMS",
                                                                                  INPUT "ERROR",
                                                                                  INPUT "Aliquota de ICMS Incorreta, Entre em Contato com Grupo Tributario, Item = " + wt-it-docto.it-codigo,
                                                                                  INPUT "Aliquota de ICMS Incorreta, Entre em Contato com Grupo Tributario, Item = " + wt-it-docto.it-codigo,
                                                                                  INPUT "").
                                        END.
                                        
                                    END.
                          END.
                     END.
                     ELSE DO:
                         IF    INDEX(PROGRAM-NAME(1),'esftp009') = 0 and 
                               INDEX(PROGRAM-NAME(2),'esftp009') = 0 and 
                               INDEX(PROGRAM-NAME(3),'esftp009') = 0 and 
                               INDEX(PROGRAM-NAME(4),'esftp009') = 0 and 
                               INDEX(PROGRAM-NAME(5),'esftp009') = 0 and 
                               INDEX(PROGRAM-NAME(6),'esftp009') = 0 and 
                               INDEX(PROGRAM-NAME(7),'esftp009') = 0 and 
                               INDEX(PROGRAM-NAME(8),'esftp009') = 0 THEN DO:

                             IF AVAIL ITEM
                                  and (ITEM.codigo-orig = 1
                                   OR  ITEM.codigo-orig = 2
                                   OR  ITEM.codigo-orig = 3
                                   OR  ITEM.codigo-orig = 8) THEN DO:
        
                                   FOR EACH wt-it-imposto OF wt-it-docto NO-LOCK
                                       WHERE wt-it-imposto.aliquota-icm <> 4:
    
                                      find tt-epc
                                         where tt-epc.cod-event     = p-ind-event
                                           AND tt-epc.cod-parameter = "this-procedure"
                                           NO-LOCK NO-ERROR.
                                       ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).
                                       RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                                              INPUT "EMS",
                                                                              INPUT "ERROR",
                                                                              INPUT "Aliquota de ICMS Incorreta, Entre em Contato com Grupo Tributario, Item = " + wt-it-docto.it-codigo,
                                                                              INPUT "Aliquota de ICMS Incorreta, Entre em Contato com Grupo Tributario, Item = " + wt-it-docto.it-codigo,
                                                                              INPUT "").
                                    END.
                             END.
                             ELSE
                                 IF (item.codigo-orig = 0
                                 OR  item.codigo-orig = 4
                                 OR  item.codigo-orig = 5
                                 OR  item.codigo-orig = 6
                                 OR  item.codigo-orig = 7) THEN DO:

                                     FOR EACH wt-it-imposto OF wt-it-docto NO-LOCK
                                        WHERE wt-it-imposto.aliquota-icm = 4:
                                        find tt-epc
                                          where tt-epc.cod-event     = p-ind-event
                                            AND tt-epc.cod-parameter = "this-procedure"
                                            NO-LOCK NO-ERROR.

                                        ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).
                                        RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                                               INPUT "EMS",
                                                                               INPUT "ERROR",
                                                                               INPUT "Aliquota de ICMS Incorreta, Entre em Contato com Grupo Tributario, Item = " + wt-it-docto.it-codigo,
                                                                               INPUT "Aliquota de ICMS Incorreta, Entre em Contato com Grupo Tributario, Item = " + wt-it-docto.it-codigo,
                                                                               INPUT "").
                                     END.

                                 END.

                         END.
                     END.
                 END.
            END.
            
            IF l-servico AND l-produto THEN DO:
                find tt-epc
                    where tt-epc.cod-event     = p-ind-event
                      AND tt-epc.cod-parameter = "this-procedure"
                      NO-LOCK NO-ERROR.
                 ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).

                 RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                        INPUT "EMS",
                                                        INPUT "ERROR",
                                                        INPUT "Itens de Servico e Produto na mesma nota",
                                                        INPUT "Nao Ç Permitido itens de Serviáo e Produto na mesma Nota Fiscal",
                                                        INPUT "").

            END.
            
            /* SÇries de Serviáo */
            EMPTY TEMP-TABLE tt-prog-ponto.
            RUN esp/es0018p.p (INPUT "bodi317va",                       
                               INPUT 3,
                               INPUT 0,
                               INPUT "",
                               OUTPUT TABLE tt-prog-ponto).

            IF  NOT CAN-FIND(FIRST tt-prog-ponto) THEN DO:
                find tt-epc
                    where tt-epc.cod-event     = p-ind-event
                      AND tt-epc.cod-parameter = "this-procedure"
                      NO-LOCK NO-ERROR.
                 ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).

                 RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                        INPUT "EMS",
                                                        INPUT "ERROR",
                                                        INPUT "As sÇries de serviáo devem estar cadastradas no programa es0018, ponto bodi317-va",
                                                        INPUT "As sÇries de serviáo devem estar cadastradas no programa es0018, ponto bodi317-va",
                                                        INPUT "").
            END.

                

            FOR EACH tt-prog-ponto:
                IF  wt-docto.serie = tt-prog-ponto.conteudo THEN DO:
                    l-eh-ser-servico = YES.
                    LEAVE.
                END.
            END.
            
            
            EMPTY TEMP-TABLE tt-prog-ponto.
            RUN esp/es0018p.p (INPUT "bodi317va",                       
                               INPUT 5,
                               INPUT 0,
                               INPUT "",
                               OUTPUT TABLE tt-prog-ponto).


            FIND FIRST tt-prog-ponto
                 WHERE tt-prog-ponto.conteudo = substring(wt-docto.nat-operacao,1,3) NO-LOCK NO-ERROR.

                IF NOT AVAIL tt-prog-ponto AND  l-eh-ser-servico THEN DO:
               // IF  l-eh-ser-servico AND substring(wt-docto.nat-operacao,1,3) <> tt-prog-ponto.conteudo THEN DO:
                    find tt-epc
                        where tt-epc.cod-event     = p-ind-event
                          AND tt-epc.cod-parameter = "this-procedure"
                          NO-LOCK NO-ERROR.
                     ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).
               
                     RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                            INPUT "EMS",
                                                            INPUT "ERROR",
                                                            INPUT "Nao Ç permitido serie de Serviáo com Natureza de Operaá∆o que n∆o inicie com 500 ou 700",
                                                            INPUT "Nao Ç permitido serie de Serviáo com Natureza de Operaá∆o que n∆o inicie com 500 ou 700",
                                                            INPUT "").
               
                END.
          
            
            IF  l-eh-ser-servico AND l-produto = YES THEN DO:
                find tt-epc
                    where tt-epc.cod-event     = p-ind-event
                      AND tt-epc.cod-parameter = "this-procedure"
                      NO-LOCK NO-ERROR.
                 ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).

                 RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                        INPUT "EMS",
                                                        INPUT "ERROR",
                                                        INPUT "Nao Ç permitido serie de Serviáo para notas de Produto",
                                                        INPUT "Nao Ç permitido serie de Serviáo para notas de Produto",
                                                        INPUT "").                   

            END.
            IF  l-eh-ser-servico = NO AND l-servico = YES THEN DO:
                find tt-epc
                    where tt-epc.cod-event     = p-ind-event
                      AND tt-epc.cod-parameter = "this-procedure"
                      NO-LOCK NO-ERROR.
                 ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).

                 RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                        INPUT "EMS",
                                                        INPUT "ERROR",
                                                        INPUT "Nao Ç permitido serie diferente de Serviáo para notas com itens de Servico",
                                                        INPUT "Nao Ç permitido serie diferente de Serviáo para notas com itens de Servico",
                                                        INPUT "").

            END.

            IF l-servico THEN DO: //tratar nota de servico com deducao, nao deixar faturar
                ASSIGN l-deducao = NO.
                IF wt-docto.nr-pedcli <> "" THEN DO:
                    FIND FIRST ped-venda NO-LOCK
                         WHERE ped-venda.nr-pedcli = wt-docto.nr-pedcli NO-ERROR.
                    IF AVAIL ped-venda THEN DO:
                        IF ped-venda.des-pct-desconto-inform  <> "" OR ped-venda.perc-desco1 > 0 THEN
                            ASSIGN l-deducao = YES.
                        FOR EACH ped-item OF ped-venda NO-LOCK:
                            IF ped-item.des-pct-desconto-inform <> "" THEN
                                ASSIGN l-deducao = YES.
                        END.
                    END.
                END.

                IF l-deducao THEN DO:
                    RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                           INPUT "EMS",
                                                           INPUT "ERROR",
                                                           INPUT "Nao Ç permitido deducoes para notas de Servico",
                                                           INPUT "Nao Ç permitido deducoes para notas de Servico",
                                                           INPUT "").
                END.
            END.
            
            IF b-natur-oper.tipo = 3 THEN DO:
                 find tt-epc
                      where tt-epc.cod-event     = p-ind-event
                        AND tt-epc.cod-parameter = "this-procedure"
                        NO-LOCK NO-ERROR.
                   ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).

                   RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                          INPUT "EMS",
                                                          INPUT "WARNING",
                                                          INPUT "ATENCAO - NOTA DE SERVIÄO",
                                                          INPUT "VERIFIQUE SE O SERVIÄO FOI PRESTADO NA SUA CIDADE, CASO NAO TENHA SIDO INFORME O MUNICIPIO DA PRESTAÄ«O NO CAMPO ADEQUADO",
                                                          INPUT "").
                   IF wt-docto.serie = "7" THEN DO:
                       find tt-epc
                          where tt-epc.cod-event     = p-ind-event
                            AND tt-epc.cod-parameter = "this-procedure"
                            NO-LOCK NO-ERROR.
                       ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).

                       RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                              INPUT "EMS",
                                                              INPUT "ERROR",
                                                              INPUT "ATENCAO - NOTA DE SERVIÄO - NAO ê PERMITIDO GERAR NOTA DE SERVIÄO COM SERIE 7",
                                                              INPUT "PARA NOTA DE SERVIÄO INFORME A SERIE CORRETA",
                                                              INPUT "").

                   END.
            END.
            
            IF  wt-docto.nat-operacao BEGINS "7" THEN DO:
                FOR FIRST rota NO-LOCK
                    WHERE rota.cod-rota = wt-docto.cod-rota:
                END.
                IF NOT AVAIL rota THEN DO:
                   FIND tt-epc
                         WHERE tt-epc.cod-event     = p-ind-event
                           AND tt-epc.cod-parameter = "this-procedure"
                         NO-LOCK NO-ERROR.

                   ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).  
                   RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                          INPUT "EMS",
                                                          INPUT "ERROR",
                                                          INPUT "ROTA NAO ENCONTRADA",
                                                          INPUT "ROTA NAO ENCONTRADA",
                                                          INPUT "").
                    
                    RETURN.
                END.
                FIND unid-feder
                     WHERE unid-feder.pais   =  "Brasil"
                       AND unid-feder.estado = substring(rota.roteiro,1,2)
                     NO-LOCK NO-ERROR.
                IF NOT AVAIL unid-feder THEN DO:
                   FIND tt-epc
                         WHERE tt-epc.cod-event     = p-ind-event
                           AND tt-epc.cod-parameter = "this-procedure"
                           NO-LOCK NO-ERROR.

                   ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).  
                   RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                          INPUT "EMS",
                                                          INPUT "ERROR",
                                                          INPUT "PARA EXPORTACAO ê OBRIGATORIO A INFORMACAO DO ESTADO DO EMBARQUE NA ROTA DO PEDIDO",
                                                          INPUT "INFORME UMA ROTA INDICADA PARA EXPORTACAO EM QUE NO ROTEIRO AS DUAS PRIMEIRAS POSIÄÂES SEJA O ESTADO DE EMBARQUE. O PROGRAMA DE CADASTRO DE ROTAS ê O CD0706",
                                                          INPUT "").
                    RETURN.
                END.
            END.
            FIND natur-oper
                 WHERE natur-oper.nat-operacao = wt-docto.nat-operacao NO-LOCK NO-ERROR.

            IF wt-docto.nr-pedcli <> "" THEN DO:
                 FOR EACH wt-it-docto OF wt-docto NO-LOCK,
                     FIRST item NO-LOCK
                     WHERE ITEM.it-codigo = wt-it-docto.it-codigo:
                     IF wt-docto.cod-estabel          = "105" and
                        ITEM.compr-fabric             = 2 AND /* Fabricado */
                        item.cod-dcr-item = ""    THEN DO:
                            find tt-epc
                                  where tt-epc.cod-event     = p-ind-event
                                    AND tt-epc.cod-parameter = "this-procedure"
                                    NO-LOCK NO-ERROR.

                            ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).
                            RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                                   INPUT "EMS",
                                                                   INPUT "ERROR",
                                                                   INPUT "DCR-E do item " + ITEM.it-codigo + " nao informada, cadastre no cd0903, ou solicite para a controladoria",
                                                                   INPUT "DCR-E do item " + ITEM.it-codigo + " nao informada, cadastre no cd0903, ou solicite para a controladoria",
                                                                   INPUT "").

                     END.
                     IF CAN-FIND(FIRST ACORDO-CONTRATO WHERE ACORDO-CONTRATO.raiz-cnpj = SUBSTRING(emitente.cgc,1,8) NO-LOCK) THEN DO:
                         IF can-find(FIRST unid-neg-ped NO-LOCK
                             where unid-neg-ped.nome-abrev   = wt-docto.nome-abrev
                             and   unid-neg-ped.nr-pedcli    = wt-it-docto.nr-pedcli
                             AND   unid-neg-ped.nr-sequencia = wt-it-docto.nr-seq-ped
                             AND   unid-neg-ped.it-codigo    = wt-it-docto.it-codigo
                             AND   unid-neg-ped.cod_unid_neg = "ADM") THEN DO:
                             find tt-epc
                                   where tt-epc.cod-event     = p-ind-event
                                     AND tt-epc.cod-parameter = "this-procedure"
                                     NO-LOCK NO-ERROR.

                             ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).  
                             RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                                    INPUT "EMS",
                                                                    INPUT "ERROR",
                                                                    INPUT "Pedido " + wt-it-docto.nr-pedcli + " com Unidade de negocios ADM e com acordo comercial ativo favor corrigir a unidade de negocios do item do pedido " + wt-it-docto.it-codigo + " Programa pd1300 ",
                                                                    INPUT "Pedido " + wt-it-docto.nr-pedcli + " com Unidade de negocios ADM e com acordo comercial ativo favor corrigir a unidade de negocios do item do pedido " + wt-it-docto.it-codigo + " Programa pd1300 ",
                                                                    INPUT "").
                         END.
                         ELSE DO:
                              IF can-find(first unid-neg-fam-com
                                 where unid-neg-fam-com.fm-codigo = item.fm-cod-com
                                   AND unid-neg-fam-com.cod_unid_negoc  = "adm" no-lock) THEN DO:
                                  find tt-epc
                                        where tt-epc.cod-event     = p-ind-event
                                          AND tt-epc.cod-parameter = "this-procedure"
                                          NO-LOCK NO-ERROR.

                                  ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).  
                                  RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                                          INPUT "EMS",
                                                                          INPUT "ERROR",
                                                                          INPUT "Familia do Item " + wt-it-docto.it-codigo + " com Unidade de negocios ADM e com acordo comercial ativo favor corrigir a unidade de negocios na familia do item do pedido " + wt-it-docto.nr-pedcli + " Programa cd1310",
                                                                          INPUT "Familia do Item " + wt-it-docto.it-codigo + " com Unidade de negocios ADM e com acordo comercial ativo favor corrigir a unidade de negocios na familia do item do pedido " + wt-it-docto.nr-pedcli + " Programa cd1310",
                                                                          INPUT "").
                              
                              END.
                         END.
                     END.
                     //validar se o item calcula ST mas nao esta marcado no pd4000 o campo retem icms
                     FIND FIRST ped-venda NO-LOCK
                          WHERE ped-venda.nr-pedcli = wt-docto.nr-pedcli NO-ERROR.
                     IF AVAIL ped-venda THEN DO:
                         FOR EACH ped-item OF ped-venda NO-LOCK
                            WHERE ped-item.it-codigo = wt-it-docto.it-codigo: 
                
                             RUN pi-verifica-ST(INPUT wt-it-docto.nat-operacao,
                                                OUTPUT l-tem-ST).
                
                             IF AVAIL emitente AND emitente.insc-subs-trib = "" THEN DO:
                                 IF (NOT l-tem-ST AND ped-item.ind-icm-ret) OR
                                    (l-tem-ST AND NOT ped-item.ind-icm-ret)  THEN DO:
                
                                     find tt-epc
                                          where tt-epc.cod-event     = p-ind-event
                                            AND tt-epc.cod-parameter = "this-procedure"
                                            NO-LOCK NO-ERROR.
                
                                      ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).  
                                      RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                                             INPUT "EMS",
                                                                             INPUT "ERROR",
                                                                             INPUT "Item " + ped-item.it-codigo + " do pedido " + ped-item.nr-pedcli + " com parametro Retem Icms incorreto.",
                                                                             INPUT "Favor recompletar o pedido no PD4000 ou procurar a area tributaria para mais detalhes",
                                                                             INPUT "").
                                 END.
                             END.
                         END.
                     END. //find ped-venda
                 END.
            END.
            ELSE DO:
                FOR EACH wt-it-docto OF wt-docto NO-LOCK:
                    FIND ITEM
                        WHERE ITEM.it-codigo = wt-it-docto.it-codigo
                         NO-LOCK NO-ERROR.                 
                    IF AVAIL ITEM THEN DO:

                        IF wt-docto.cod-estabel          = "105" and
                            ITEM.compr-fabric             = 2 AND /* Fabricado */
                            item.cod-dcr-item = ""    THEN DO:
                                find tt-epc
                                      where tt-epc.cod-event     = p-ind-event
                                        AND tt-epc.cod-parameter = "this-procedure"
                                        NO-LOCK NO-ERROR.

                                ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).
                                RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                                       INPUT "EMS",
                                                                       INPUT "ERROR",
                                                                       INPUT "DCR-E do item " + ITEM.it-codigo + " nao informada, cadastre no cd0903, ou solicite para a controladoria",
                                                                       INPUT "DCR-E do item " + ITEM.it-codigo + " nao informada, cadastre no cd0903, ou solicite para a controladoria",
                                                                       INPUT "").

                        END.
                        IF ITEM.ind-imp-desc = 7 THEN do:
                            IF length(wt-it-docto.narrativa) = 0 OR LENGTH(wt-it-docto.narrativa ) > 120 THEN DO:
                                find tt-epc
                                      where tt-epc.cod-event     = p-ind-event
                                        AND tt-epc.cod-parameter = "this-procedure"
                                        NO-LOCK NO-ERROR.

                                ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).  
                                RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                                       INPUT "EMS",
                                                                       INPUT "ERROR",
                                                                       INPUT "Narrativa n∆o inforamda na nota ou ultrapassou 120 posiá‰es aceita pela SEFAZ",
                                                                       INPUT "Narrativa n∆o inforamda na nota ou ultrapassou 120 posiá‰es aceita pela SEFAZ",
                                                                       INPUT "").

                            END.
                        END.
                        IF ITEM.ind-imp-desc = 5 THEN do:
                            IF length(ITEM.narrativa) = 0 OR LENGTH(ITEM.narrativa ) > 120 THEN DO:
                                find tt-epc
                                      where tt-epc.cod-event     = p-ind-event
                                        AND tt-epc.cod-parameter = "this-procedure"
                                        NO-LOCK NO-ERROR.

                                ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).  
                                RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                                       INPUT "EMS",
                                                                       INPUT "ERROR",
                                                                       INPUT "Narrativa do item n∆o inforamda ou ultrapassou 120 posiá‰es aceita pela SEFAZ",
                                                                       INPUT "Narrativa do item n∆o inforamda ou ultrapassou 120 posiá‰es aceita pela SEFAZ",
                                                                       INPUT "").

                            END.
                        END.

                    END.
                END.
            END.

            IF AVAIL emitente  THEN DO:
                RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.
                RUN pi-trata-endereco IN h-cdapi704 (INPUT  emitente.endereco,
                                                     OUTPUT c-rua, 
                                                     OUTPUT c-nro, 
                                                     OUTPUT c-comp).
                DELETE PROCEDURE h-cdapi704.
                IF c-nro = "" THEN DO:
                    find tt-epc
                          where tt-epc.cod-event     = p-ind-event
                            AND tt-epc.cod-parameter = "this-procedure" 
                            NO-LOCK NO-ERROR.
                     IF AVAIL tt-epc  THEN DO:
                         ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).  
                         RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                                 INPUT "EMS",
                                                                 INPUT "ERROR",
                                                                 INPUT "Cliente com endereáo sem numero, favor informar o numero no endereáo do cliente",
                                                                 INPUT "Cliente com endereáo sem numero, favor informar o numero no endereáo do cliente",
                                                                 INPUT "").
                         RETURN.
                     END.
                END.
                RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.
                RUN pi-trata-endereco IN h-cdapi704 (INPUT  wt-docto.endereco,
                                                     OUTPUT c-rua, 
                                                     OUTPUT c-nro, 
                                                     OUTPUT c-comp).
                DELETE PROCEDURE h-cdapi704.
                IF c-nro = "" THEN DO:
                    find tt-epc
                          where tt-epc.cod-event     = p-ind-event
                            AND tt-epc.cod-parameter = "this-procedure"
                            NO-LOCK NO-ERROR.
                     IF AVAIL tt-epc  THEN DO:
                         ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).  
                         RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                                 INPUT "EMS",
                                                                 INPUT "ERROR",
                                                                 INPUT "Endereáo do cliente na NF sem numero, favor informar o numero no endereáo do cliente na NF",
                                                                 INPUT "Endereáo do cliente na NF sem numero, favor informar o numero no endereáo do cliente na NF",
                                                                 INPUT "").
                         RETURN.
                     END.
                END.
            END.

            FIND int-emitente
                 WHERE int-emitente.cod-emitente = emitente.cod-emitente
                 NO-LOCK NO-ERROR.
            IF AVAIL int-emitente AND
               int-emitente.dispositivo-legal <> "" AND
               int-emitente.dt-vcto-concessao < TODAY THEN DO:
                find tt-epc
                      where tt-epc.cod-event     = p-ind-event
                        AND tt-epc.cod-parameter = "this-procedure"
                        NO-LOCK NO-ERROR.
                 IF AVAIL tt-epc  THEN DO:
                    ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).  

                    RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                           INPUT "EMS",
                                                           INPUT "ERROR",
                                                           INPUT "Cliente " + string(emitente.cod-emitente) + " com data de Concess∆o RS Vencida " + STRING(int-emitente.dt-vcto-concessao) + " - Entre em contato com Controladoria",
                                                           INPUT "Cliente " + string(emitente.cod-emitente) + " com data de Concess∆o RS Vencida " + STRING(int-emitente.dt-vcto-concessao) + " - Entre em contato com Controladoria",
                                                           INPUT "").
                    RETURN.
                 END.
            END.    


            IF wt-docto.nome-transp = "" AND
               SUBSTRING(wt-docto.char-1,158,1) = "0" THEN DO:
               RUN _insertErrorManual IN h-bodi317va (INPUT 0,
                                                      INPUT "EMS":U,
                                                      INPUT "ERROR":U,
                                                      INPUT "Transportadora n∆o informada":U,
                                                      INPUT "Para frete CIF transportadora Ç obrigat¢ria",
                                                      INPUT "Para frete CIF transportadora Ç obrigat¢ria").
                RETURN.

            END.
            IF wt-docto.nr-pedcli <> "" THEN DO:
                FIND ped-venda
                    WHERE ped-venda.nr-pedcli  = wt-docto.nr-pedcli
                      AND ped-venda.nome-abrev = wt-docto.nome-abrev NO-LOCK NO-ERROR.


                IF AVAIL ped-venda and
                   ped-venda.dt-entrega > TODAY THEN DO:
                    find tt-epc
                              where tt-epc.cod-event     = p-ind-event
                                AND tt-epc.cod-parameter = "this-procedure"
                                NO-LOCK NO-ERROR.

                    ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).  
                    RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                   INPUT "EMS",
                                                   INPUT "ERROR",
                                                   INPUT "Data de Previs∆o de Faturamento superior a data atual",
                                                   INPUT "Data de Previs∆o de Faturamento superior a data atual faturamento n∆o permitido",
                                                   INPUT "").
                END.

                IF AVAIL ped-venda AND 
                   ped-venda.cod-priori = 44 THEN DO:
                   find tt-epc
                        where tt-epc.cod-event     = p-ind-event
                          AND tt-epc.cod-parameter = "this-procedure"
                          NO-LOCK NO-ERROR.
                   IF AVAIL tt-epc  THEN DO:
                       ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).  
                       RUN _insertErrorManual IN h-bodi317va (INPUT 0,
                                                              INPUT "EMS",
                                                              INPUT "ERROR", 
                                                              INPUT "PEDIDO COM PRIORIDADE 44 (ORÄAMENTO) N«O PODE SER FATURADO",
                                                              INPUT "PEDIDO COM PRIORIDADE 44 (ORÄAMENTO) N«O PODE SER FATURADO",
                                                              INPUT "":U). 
                       RETURN.
                   END.
                END.

                IF AVAIL ped-venda THEN DO:

                    FIND FIRST int-cond-pagto
                        WHERE int-cond-pagto.cod-cond-pag = wt-docto.cod-cond-pag NO-LOCK NO-ERROR.
                    IF AVAILABLE int-cond-pagto                        AND
                        SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S":U THEN DO:                 /*  SupplierCard */

                        FIND FIRST natur-oper
                            WHERE natur-oper.nat-operacao = wt-docto.nat-operacao NO-LOCK NO-ERROR.
                        IF AVAIL natur-oper THEN DO:
                            IF natur-oper.tipo = 3 THEN DO:

                                FIND FIRST tt-epc
                                     WHERE tt-epc.cod-event     = p-ind-event
                                       AND tt-epc.cod-parameter = "this-procedure" NO-LOCK NO-ERROR.
                                IF AVAIL tt-epc  THEN DO:
                                    ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).  

                                    RUN _insertErrorManual IN h-bodi317va (INPUT 17006,
                                                                           INPUT "EMS",
                                                                           INPUT "ERROR", 
                                                                           INPUT "Natureza de Operaá∆o utilizada Ç de Serviáo",
                                                                           INPUT "A Natureza de Operaá∆o ":U + TRIM(wt-docto.nat-operacao) + ", do Cliente ":U + TRIM(ped-venda.nome-abrev) + 
                                                                                 " e Pedido ":U + TRIM(ped-venda.nr-pedcli) + " utilizada Ç de serviáo. A mesma n∆o poder† ser utilizada com a Condiá∆o de Pagamento do Cart∆o Intelbras Clube.",
                                                                           INPUT "":U). 
                                    RETURN.
                                END. /* IF AVAIL tt-epc  THEN DO: */

/*                                 RUN utp/ut-msgs.p (INPUT "SHOW":U,                                                                                                                                                           */
/*                                                    INPUT 17006,                                                                                                                                                              */
/*                                                    INPUT "Natureza de Operaá∆o utilizada Ç de Serviáo":U + "~~":U +                                                                                                          */
/*                                                          "A Natureza de Operaá∆o ":U + TRIM(ped-venda.nat-operacao) + ", do Cliente ":U + TRIM(ped-venda.nome-abrev) +                                                       */
/*                                                          " e Pedido ":U + TRIM(ped-venda.nr-pedcli) + " utilizada Ç de serviáo. A mesma n∆o poder† ser utilizada com a Condiá∆o de Pagamento do Cart∆o Intelbras Clube.":U). */

                            END. /* IF natur-oper.tipo = 3 THEN DO: */

                        END. /* IF AVAIL natur-oper THEN DO: */

                    END. /* IF AVAILABLE int-cond-pagto AND */

                END. /* IF AVAIL ped-venda THEN DO: */

                FIND FIRST int-ped-venda
                     WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-LOCK NO-ERROR.
                IF AVAIL int-ped-venda THEN DO:
                    FIND int-cond-pagto
                        WHERE int-cond-pagto.cod-cond-pag = wt-docto.cod-cond-pag NO-LOCK NO-ERROR.
                    IF AVAIL int-cond-pagto AND
                       int-cond-pagto.transacao-com-cartao = YES and
                       int-ped-venda.CarTID = "" THEN DO:
                         find tt-epc
                                where tt-epc.cod-event     = p-ind-event
                                  AND tt-epc.cod-parameter = "this-procedure"
                                  NO-LOCK NO-ERROR.
                           IF AVAIL tt-epc  THEN DO:
                               ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).  
                               RUN _insertErrorManual IN h-bodi317va (INPUT 0,
                                                                      INPUT "EMS",
                                                                      INPUT "ERROR", 
                                                                      INPUT "PEDIDO DE CARTAO DE CREDITO SEM CONFIRMACAO DE PAGAMENTO (CARTID)",
                                                                      INPUT "PEDIDO DE CARTAO DE CREDITO SEM CONFIRMACAO DE PAGAMENTO (CARTID)",
                                                                      INPUT "":U). 
                               RETURN.
                           END.
                   END.
                END.
                IF AVAIL int-ped-venda AND
                   SUBSTRING(int-ped-venda.char-1, 11, 1) = "S":U THEN DO:
                   IF CAN-FIND(FIRST wt-fat-ser-lote NO-LOCK WHERE wt-fat-ser-lote.seq-wt-docto = wt-docto.seq-wt-docto
                                 AND wt-fat-ser-lote.cod-depos    <> "TNF") THEN DO:
                         find tt-epc
                                where tt-epc.cod-event     = p-ind-event
                                  AND tt-epc.cod-parameter = "this-procedure"
                                  NO-LOCK NO-ERROR.
                           IF AVAIL tt-epc  THEN DO:
                               ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).  
                               RUN _insertErrorManual IN h-bodi317va (INPUT 0,
                                                                      INPUT "EMS",
                                                                      INPUT "ERROR", 
                                                                      INPUT "PEDIDO DE TROCA DE NOTA SENDO FATURADO EM DEPOSITO DIFERENTE DE TNF",
                                                                      INPUT "PEDIDO DE TROCA DE NOTA SENDO FATURADO EM DEPOSITO DIFERENTE DE TNF",
                                                                      INPUT "":U). 
                               RETURN.
                           END.
                   END.
                END.

            END.

            /*********** Naturezas que podem ser faturadas no depÛsito ACA *********/
            EMPTY TEMP-TABLE tt-prog-ponto.
            RUN esp/es0018p.p (INPUT "bodi317va",                       
                               INPUT 4,
                               INPUT 0,
                               INPUT "",
                               OUTPUT TABLE tt-prog-ponto).

            FOR FIRST natur-oper 
                WHERE natur-oper.nat-operacao = wt-docto.nat-operacao NO-LOCK:
                IF NOT CAN-FIND(FIRST tt-prog-ponto
                                WHERE tt-prog-ponto.conteudo = natur-oper.nat-operacao) THEN DO:

                    IF CAN-FIND(FIRST wt-fat-ser-lote NO-LOCK
                                WHERE wt-fat-ser-lote.seq-wt-docto = wt-docto.seq-wt-docto
                                  AND wt-fat-ser-lote.cod-depos    = "ACA") THEN DO:

                        /* SIMULACAO DE CALCULO ESPDP027 - ORCAMENTO PEDIDO */
                        RUN pi-libera-simulacao-fat (OUTPUT  l-simulacao-espdp027).

                        IF l-simulacao-espdp027 THEN NEXT.                              

                        FIND FIRST tt-epc
                             WHERE tt-epc.cod-event     = p-ind-event
                               AND tt-epc.cod-parameter = "this-procedure" NO-LOCK NO-ERROR.
                        IF AVAIL tt-epc  THEN DO:
                            ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).  
                            RUN _insertErrorManual IN h-bodi317va (INPUT 0,
                                                                   INPUT "EMS",
                                                                   INPUT "ERROR", 
                                                                   INPUT "Nao Ç permitido efetuar faturamento do deposito ACA",
                                                                   INPUT "Nao Ç permitido efetuar faturamento do deposito ACA",
                                                                   INPUT "":U). 
                            RETURN.
                        END.
                    END.
                END.
            END.

            FIND FIRST wt-fat-ser-lote 
                WHERE  wt-fat-ser-lote.seq-wt-docto = wt-docto.seq-wt-docto
                  AND (wt-fat-ser-lote.cod-depos    = "exp"
                   OR  wt-fat-ser-lote.cod-depos    = "WEX"
                   OR  wt-fat-ser-lote.cod-depos    = "WEC"
                   OR  wt-fat-ser-lote.cod-depos    = "FAT") /* Alteracao solicitada no chamado C2109-1420 */
                  AND  wt-fat-ser-lote.cod-locali   <> "" NO-LOCK NO-ERROR.
            IF AVAIL wt-fat-ser-lote THEN DO:
                  find tt-epc
                       where tt-epc.cod-event     = p-ind-event
                         AND tt-epc.cod-parameter = "this-procedure"
                         NO-LOCK NO-ERROR.
                  IF AVAIL tt-epc  THEN DO:
                      ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).  
                      RUN _insertErrorManual IN h-bodi317va (INPUT 0,
                                                             INPUT "EMS",
                                                             INPUT "ERROR", 
                                                             INPUT "Nao Ç permitido efetuar faturamento dos deposito EXP, WEX, WEC e FAT localizado",
                                                             INPUT "Nao Ç permitido efetuar faturamento dos deposito EXP, WEXM WEC e FAT localizacao diferente de BRANCO, verifique o item " + wt-fat-ser-lote.it-codigo, 
                                                             INPUT "":U). 
                      RETURN.
                  END.
            END.

            FIND FIRST wt-fat-ser-lote 
                WHERE wt-fat-ser-lote.seq-wt-docto = wt-docto.seq-wt-docto
                  AND wt-fat-ser-lote.cod-depos    = "b2c"
                  AND wt-fat-ser-lote.cod-locali   <> "" NO-LOCK NO-ERROR.
            IF AVAIL wt-fat-ser-lote THEN DO:
                 find tt-epc
                      where tt-epc.cod-event     = p-ind-event
                        AND tt-epc.cod-parameter = "this-procedure"
                        NO-LOCK NO-ERROR.
                 IF AVAIL tt-epc  THEN DO:
                     ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).  
                     RUN _insertErrorManual IN h-bodi317va (INPUT 0,
                                                            INPUT "EMS",
                                                            INPUT "ERROR", 
                                                            INPUT "Nao Ç permitido efetuar faturamento dos deposito B2C localizado",
                                                            INPUT "Nao Ç permitido efetuar faturamento dos deposito B2C localizado, verifique o item " + wt-fat-ser-lote.it-codigo,
                                                            INPUT "":U). 
                     RETURN.
                 END.
            END.

            FIND FIRST wt-fat-ser-lote 
                WHERE wt-fat-ser-lote.seq-wt-docto = wt-docto.seq-wt-docto
                  AND wt-fat-ser-lote.cod-depos    = "sal"
                  AND wt-fat-ser-lote.cod-locali   <> "" NO-LOCK NO-ERROR.
            IF AVAIL wt-fat-ser-lote THEN DO:
                 find tt-epc
                      where tt-epc.cod-event     = p-ind-event
                        AND tt-epc.cod-parameter = "this-procedure"
                        NO-LOCK NO-ERROR.
                 IF AVAIL tt-epc  THEN DO:
                     ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).  
                     RUN _insertErrorManual IN h-bodi317va (INPUT 0,
                                                            INPUT "EMS",
                                                            INPUT "ERROR", 
                                                            INPUT "Nao Ç permitido efetuar faturamento dos deposito SAL localizado",
                                                            INPUT "Nao Ç permitido efetuar faturamento dos deposito SAL localizado, verifique o item " + wt-fat-ser-lote.it-codigo,
                                                            INPUT "":U). 
                     RETURN.
                 END.
            END.

            IF AVAIL natur-oper AND 
                natur-oper.especie = "NFT" THEN DO:
                FOR EACH wt-it-docto OF wt-docto NO-LOCK,
                    FIRST ITEM NO-LOCK
                    WHERE item.it-codigo = wt-it-docto.it-codigo 
                    AND ITEM.tipo-contr = 4:
                    find tt-epc
                         where tt-epc.cod-event     = p-ind-event
                           AND tt-epc.cod-parameter = "this-procedure"
                           NO-LOCK NO-ERROR.
                    IF AVAIL tt-epc  THEN DO:
                        ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter). 
                        RUN _insertErrorManual IN h-bodi317va (INPUT 0,
                                                               INPUT "EMS",
                                                               INPUT "ERROR", 
                                                               INPUT "Nota de Transferencia, n∆o Ç permitido com itens de Debito Direto " + wt-it-docto.it-codigo,
                                                               INPUT "Nota de Transferencia, n∆o Ç permitido com itens de Debito Direto " + wt-it-docto.it-codigo,
                                                               INPUT "":U). 
                    END.
                END.
            END.

            IF  wt-docto.cod-estabel    = "105" /* Manaus */          AND
                natur-oper.emite-duplic = YES                         AND
                emitente.natureza       = 2     /* Pessoa Jur°dica */ THEN DO:
                FIND FIRST int-emitente-trib NO-LOCK
                    WHERE  int-emitente-trib.raiz-cnpj = SUBSTRING(emitente.cgc,1,8) NO-ERROR.
                IF  NOT AVAIL int-emitente-trib OR
                    NOT int-emitente-trib.ind-declaracao THEN DO:
                    FIND FIRST tt-epc NO-LOCK
                        WHERE  tt-epc.cod-event     = p-ind-event
                        AND    tt-epc.cod-parameter = "this-procedure" NO-ERROR.

                    ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).  
                    RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                           INPUT "EMS",
                                                           INPUT "ERROR",
                                                           INPUT "Cliente n∆o fez a entrega da Declaraá∆o de Forma de Tributaá∆o!",
                                                           INPUT "Cliente n∆o fez a entrega da Declaraá∆o de Forma de Tributaá∆o, favor verificar o cadastro ESCDP066.",
                                                           INPUT "").
                END.
            END.

            IF wt-docto.dt-emis-nota <> TODAY THEN DO:

                FIND FIRST bloqueio-fat NO-LOCK NO-ERROR.
                IF AVAIL bloqueio-fat 
                AND LOOKUP(wt-docto.cod-estabel,bloqueio-fat.estab-fatcom) = 0 THEN DO:

                    ASSIGN wt-docto.dt-emis-nota = TODAY.

                    RUN GetRowerrors IN h-bodi317va (OUTPUT TABLE RowErrorsAux).
                    RUN EmptyRowErrors IN h-bodi317va.
    
                    FIND FIRST RowErrorsAux
                         WHERE RowErrorsAux.ErrorNumber = 27179 NO-LOCK NO-ERROR.
                    IF AVAIL RowErrorsAux THEN DO:
                        DELETE RowErrorsAux.
                    END.

                    FOR EACH RowErrorsAux:
                        RUN _insertErrorManual IN h-bodi317va (INPUT RowErrorsAux.errornumber,
                                                               INPUT RowErrorsAux.ERRORtype,
                                                               INPUT RowErrorsAux.ERRORsubtype, 
                                                               INPUT RowErrorsAux.errordescription,
                                                               INPUT RowErrorsAux.errorhelp,
                                                               INPUT "":U).   
                        DELETE RowErrorsAux.
                    END.

                END.
            END.

            FOR EACH wt-fat-ser-lote NO-LOCK
               WHERE wt-fat-ser-lote.seq-wt-docto = wt-docto.seq-wt-docto:

                /* SIMULACAO CALCULO PEDIDOS ECOMMERCE */
                IF wt-docto.nr-prog = 9993 THEN NEXT.

                /* SIMULACAO DE CALCULO ESPDP027 - ORCAMENTO PEDIDO */
                RUN pi-libera-simulacao-fat (OUTPUT l-simulacao-espdp027).

                IF l-simulacao-espdp027 THEN NEXT.                              
               
                IF CAN-FIND(FIRST b-wt-fat-ser-lote NO-LOCK
                            WHERE b-wt-fat-ser-lote.seq-wt-docto     = wt-fat-ser-lote.seq-wt-docto
                              AND b-wt-fat-ser-lote.seq-wt-it-docto <> wt-fat-ser-lote.seq-wt-it-docto
                              AND b-wt-fat-ser-lote.cod-depos       <> wt-fat-ser-lote.cod-depos) THEN DO:

                    RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                           INPUT "EMS",
                                                           INPUT "ERROR",
                                                           INPUT "N∆o Ç permitido faturar dois dep¢sitos na mesma NF!",
                                                           INPUT "Deve ser gerado uma NF para cada dep¢sito!",
                                                           INPUT "").
                    RETURN.
                END.
            END.
        END. /*IF AVAIL wt-docto THEN DO:*/

        /*Chamado C2009-1272  nao lancar documento fiscal ja lancado no of0311 */
        IF  (INDEX(PROGRAM-NAME(1),'ft4003') <> 0 AND INDEX(PROGRAM-NAME(1),'ft4003') <> ?) OR  
            (INDEX(PROGRAM-NAME(2),'ft4003') <> 0 AND INDEX(PROGRAM-NAME(2),'ft4003') <> ?) OR  
            (INDEX(PROGRAM-NAME(3),'ft4003') <> 0 AND INDEX(PROGRAM-NAME(3),'ft4003') <> ?) OR  
            (INDEX(PROGRAM-NAME(4),'ft4003') <> 0 AND INDEX(PROGRAM-NAME(4),'ft4003') <> ?) OR  
            (INDEX(PROGRAM-NAME(5),'ft4003') <> 0 AND INDEX(PROGRAM-NAME(5),'ft4003') <> ?) OR  
            (INDEX(PROGRAM-NAME(6),'ft4003') <> 0 AND INDEX(PROGRAM-NAME(6),'ft4003') <> ?) OR  
            (INDEX(PROGRAM-NAME(7),'ft4003') <> 0 AND INDEX(PROGRAM-NAME(7),'ft4003') <> ?) OR  
            (INDEX(PROGRAM-NAME(8),'ft4003') <> 0 AND INDEX(PROGRAM-NAME(8),'ft4003') <> ?)  THEN DO:

            FIND FIRST nota-fisc-adc NO-LOCK
                 WHERE nota-fisc-adc.cod-estab                = wt-docto.cod-estabel
                   AND nota-fisc-adc.cod-serie                = wt-docto.serie
                   AND nota-fisc-adc.cod-nota-fis             = STRING(absolute(wt-docto.seq-wt-docto))
                   AND nota-fisc-adc.cdn-emitente             = wt-docto.cod-emitente
                   AND nota-fisc-adc.idi-tip-dado             = 03 NO-ERROR.
            IF AVAIL nota-fisc-adc THEN DO:
                FOR EACH b-nota-fisc-adc NO-LOCK
                   WHERE b-nota-fisc-adc.cod-estab                 = nota-fisc-adc.cod-estab   
                     and b-nota-fisc-adc.cod-ser-docto-referado    = nota-fisc-adc.cod-ser-docto-referado   
                     and b-nota-fisc-adc.cod-docto-referado        = nota-fisc-adc.cod-docto-referado
                     and b-nota-fisc-adc.cdn-emit-docto-referado   = nota-fisc-adc.cdn-emit-docto-referado
                     and b-nota-fisc-adc.idi-tip-dado              = nota-fisc-adc.idi-tip-dado
                     AND b-nota-fisc-adc.cod-nota-fis             <> nota-fisc-adc.cod-nota-fis 
                     AND b-nota-fisc-adc.cod-model-docto-referado  = "57":
                    
                    FIND FIRST nota-fiscal NO-LOCK
                         WHERE nota-fiscal.cod-estabel       = b-nota-fisc-adc.cod-estab
                           AND nota-fiscal.serie             = b-nota-fisc-adc.cod-serie
                           AND nota-fiscal.nr-nota-fis       = b-nota-fisc-adc.cod-nota-fis 
                           AND nota-fiscal.cod-emitente      = b-nota-fisc-adc.cdn-emit-docto-referado 
                           AND nota-fiscal.idi-sit-nf-eletro = 3 NO-ERROR.
                    IF AVAIL nota-fiscal THEN DO:
                       RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                              INPUT "EMS",
                                                              INPUT "ERROR",
                                                              INPUT "Documento fiscal referenciado ja lancado na nota: " + STRING(b-nota-fisc-adc.cod-nota-fisc) + " Serie: " 
                                                                    + STRING(b-nota-fisc-adc.cod-serie) + " Estab: " + STRING(b-nota-fisc-adc.cod-estab),
                                                              INPUT "Favor verificar os dados informados no FT4003 docto fiscal referenciado",
                                                              INPUT "").
                    END. /*avail nota-fiscal*/
                END. /*avail b-nota-fisc*/
            END. /*avail nota-fisc-adc*/ 
        END. /*program-name ft4003*/


        //CHAMADO C2106-0754 - Bloqueio preventivo Entreposto 
        FIND FIRST estabelec NO-LOCK WHERE estabelec.cod-estabel = wt-docto.cod-estabel NO-ERROR.

        FIND FIRST natur-oper NO-LOCK WHERE natur-oper.nat-operacao = wt-docto.nat-operacao NO-ERROR.

        IF AVAIL estabelec AND AVAIL natur-oper THEN DO:

           IF SUBSTRING(estabelec.char-1,396,1) = 'S' THEN DO: //DEPOSITO FECHADO 

              FOR FIRST wt-fat-ser-lote NO-LOCK
                  WHERE wt-fat-ser-lote.seq-wt-docto = wt-docto.seq-wt-docto:
                  
                  FIND FIRST deposito WHERE deposito.cod-depos = wt-fat-ser-lote.cod-depos NO-LOCK NO-ERROR. 
             
                  IF AVAIL deposito THEN DO:
                     //DEPOSITO INTERNO
                     IF deposito.ind-tipo-dep = 1 THEN DO:
                        IF natur-oper.cod-mensagem = 926 THEN DO:
                           RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                                  INPUT "EMS",
                                                                  INPUT "ERROR",
                                                                  INPUT "Natureza de operaá∆o de entreposto n∆o pode ser utilizada para venda de mercadoria do Dep¢sito Interno",
                                                                  INPUT "",
                                                                  INPUT "").
                           RETURN.
                        END.
                     END.
                     ELSE DO:
                        //DEPOSITO EXTERNO
                        IF deposito.ind-tipo-dep = 2 THEN DO:
                           IF natur-oper.cod-mensagem <> 926 THEN DO:
                              RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                                     INPUT "EMS",
                                                                     INPUT "ERROR",
                                                                     INPUT "Natureza de operaá∆o n∆o pode ser utilizada para venda de mercadoria do Entreposto",
                                                                     INPUT "",
                                                                     INPUT "").
                              RETURN.
                           END.
                        END. //deposito.ind-tipo-dep = 2
                     END. //ELSE
                  END. //AVAIL deposito
              END. //FOR FIRST wt-fat-ser-lote 
           END. //SUBSTRING(estabelec.char-1,396,1)
        END. //AVAIL estabelec


        //validacao nota acima de 1 milhao marcios
        IF wt-docto.nr-pedcli = "" THEN DO:
            ASSIGN d-total = 0.
            FOR EACH wt-it-docto NO-LOCK OF wt-docto:
                ASSIGN d-total = d-total + (wt-it-docto.quantidade[1] * wt-it-docto.vl-preuni).
            END.
         
            RUN esp/es0018p.p (INPUT "bodi317va",                       
                               INPUT 6,
                               INPUT 0,
                               INPUT "",
                               OUTPUT TABLE tt-prog-ponto).
         
            FIND FIRST tt-prog-ponto NO-ERROR.
         
            IF d-total > INT(tt-prog-ponto.conteudo) THEN DO:
                   RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                          INPUT "EMS",
                                                          INPUT "ERROR",
                                                          INPUT "Valor total da nota ultrapassa 1 milhao",
                                                          INPUT "Valor total da nota:  R$ " + STRING(d-total,">>>,>>>,>>9.99999"),
                                                          INPUT "").
                
            END. 
        END.
    END. /*IF  AVAIL tt-epc THEN DO:*/
END. /*IF  p-ind-event = "antes-validar-nota" THEN DO:*/


IF p-ind-event = "fim-validacoes" THEN DO:

    DEF VAR l-valida-cest AS LOG NO-UNDO.
/*     for EACH tt-epc                            */
/*         where tt-epc.cod-event = p-ind-event:  */
/*         MESSAGE tt-epc.cod-parameter           */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK. */
/*     END.                                       */
    
    
    /** Validacao para o MFT x WMS **/
    for first tt-epc 
        where tt-epc.cod-event = p-ind-event
          AND tt-epc.cod-parameter = "OBJECT-HANDLE":   

        if  valid-handle(widget-handle(tt-epc.val-parameter)) then do:

            ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).  
    
            RUN GetRowerrors IN h-bodi317va (OUTPUT table RowErrorsAux).
            run EmptyRowErrors in h-bodi317va.
    
            FIND FIRST RowErrorsAux
                WHERE RowErrorsAux.ErrorNumber = 27607 NO-LOCK NO-ERROR.
            IF AVAIL RowErrorsAux THEN DO:
                ASSIGN l-wmsErro = YES.
            END.
            IF l-wmsErro THEN DO:
                for each RowErrorsAux
                    where (RowErrorsAux.ErrorNumber = 15178
                       OR  RowErrorsAux.ErrorNumber = 15811
                       OR  RowErrorsAux.ErrorNumber = 26082
                       OR  RowErrorsAux.ErrorNumber = 27607) :
                    delete RowErrorsAux.
                end.
            END.

            FOR EACH RowErrorsAux:
                RUN _insertErrorManual IN h-bodi317va (INPUT RowErrorsAux.errornumber,
                                                       INPUT RowErrorsAux.ERRORtype,
                                                       INPUT RowErrorsAux.ERRORsubtype, 
                                                       INPUT RowErrorsAux.errordescription,
                                                       INPUT RowErrorsAux.errorhelp,
                                                       INPUT "":U).   
                DELETE RowErrorsAux.
            END.
    
        END.

    END. /* FOR EACH tt-epc */
    IF VALID-HANDLE(h-bodi317va) THEN
        ASSIGN h-bodi317va = ?.
    find FIRST tt-epc
      where tt-epc.cod-event     = p-ind-event
       AND tt-epc.cod-parameter = "OBJECT-HANDLE"
       NO-LOCK NO-ERROR.
    

    ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).

    find tt-epc
         where tt-epc.cod-event     = p-ind-event
           and tt-epc.cod-parameter = "rowid-wt-docto"
         no-error.

     if avail tt-epc then do:

         /* Chamados 64990/71127 */
         IF TODAY >= 05/01/2017 THEN DO:         

             find wt-docto
                 where rowid(wt-docto) = to-rowid(tt-epc.val-parameter)
                 NO-LOCK no-error.
             FOR EACH wt-it-docto OF wt-docto NO-LOCK,
                 FIRST natur-oper
                 WHERE natur-oper.nat-operacao = wt-it-docto.nat-operacao NO-LOCK:
                
                ASSIGN l-valida-cest = NO.

                FIND estabelec     NO-LOCK WHERE estabelec.cod-estabel = wt-docto.cod-estabel  NO-ERROR.
                FIND emitente      NO-LOCK WHERE emitente.cod-emitente = wt-docto.cod-emitente NO-ERROR.

                IF AVAIL estabelec THEN DO:
                   IF AVAIL emitente THEN DO:   
                       FIND FIRST item-uf NO-LOCK
                            WHERE item-uf.it-codigo       = wt-it-docto.it-codigo
                              AND item-uf.cod-estado-orig = estabelec.estado
                              AND item-uf.estado          = emitente.estado    
                       NO-ERROR.
    
                       IF AVAIL item-uf THEN
                          ASSIGN l-valida-cest = YES.
                   END.
                END.

                /*
                IF  (AVAIL estabelec AND AVAIL item-uf AND AVAIL emitente)
                AND item-uf.cod-estado-orig = estabelec.estado
                AND estabelec.estado        = emitente.estado
                THEN 
                    ASSIGN l-valida-cest = YES.
                ELSE DO:
                    FIND FIRST ct-clas-item NO-LOCK
                        WHERE ct-clas-item.cod-item = wt-it-docto.it-codigo NO-ERROR.
                    IF  AVAIL ct-clas-item THEN
                        ASSIGN l-valida-cest = YES.
                END.
                */


                IF  l-valida-cest THEN DO:
                    FIND ITEM 
                        WHERE ITEM.it-codigo = wt-it-docto.it-codigo NO-LOCK NO-ERROR.
               
                    RUN esp/mssp/esmsspapi001.p PERSISTENT SET h-esmsspapi001.
                    RUN piBuscaCEST IN h-esmsspapi001 (INPUT 2,
                                                   INPUT IF TODAY > 04/01/2016 THEN TODAY ELSE 04/01/2016,
                                                   INPUT "",
                                                   INPUT wt-docto.estado,
                                                   INPUT "",
                                                   INPUT ITEM.class-fiscal,
                                                   INPUT ITEM.it-codigo,
                                                   INPUT 0,
                                                   OUTPUT c-mensagem,
                                                   OUTPUT i-cest).
                   DELETE PROCEDURE h-esmsspapi001.
                   IF i-cest = 0 THEN DO:
                       
                       RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                              INPUT "EMS",
                                                              INPUT "ERROR",
                                                              INPUT "Item com ICMS ST sem CEST preenchido, gentileza informar a area Tribut†ria, Item = " + wt-it-docto.it-codigo,
                                                              INPUT "Item com ICMS ST sem CEST preenchido, gentileza informar a area Tribut†ria, Item = " + wt-it-docto.it-codigo,
                                                              INPUT "").
                   END.
                END.

             END.
         END. /* IF TODAY >= 05/01/2017 THEN DO:  */
     end.

     if avail wt-docto and
        wt-docto.ind-lib-nota then do:

         for first ponto-programa
             where ponto-programa.nome-programa = "esftp012"
                   NO-LOCK,
              EACH conteudo-programa NO-LOCK
             WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
               and conteudo-programa.conteudo = "Sim":

            for first tt-epc 
                where tt-epc.cod-event = p-ind-event
                  AND tt-epc.cod-parameter = "OBJECT-HANDLE":     
                if  valid-handle(widget-handle(tt-epc.val-parameter)) then do:
      
                    ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).  
       
                    RUN GetRowerrors IN h-bodi317va (OUTPUT table RowErrorsAux).
                    run EmptyRowErrors in h-bodi317va.
      
                    for each RowErrorsAux
                        where RowErrorsAux.ErrorSubType = "WARNING":U
                          AND rowerrorsaux.ErrorNumber = 31520:
                         
                        delete RowErrorsAux.
                    end.
                    FOR EACH RowErrorsAux:
                        RUN _insertErrorManual IN h-bodi317va (INPUT RowErrorsAux.errornumber,
                                                               INPUT RowErrorsAux.ERRORtype,
                                                               INPUT RowErrorsAux.ERRORsubtype, 
                                                               INPUT RowErrorsAux.errordescription,
                                                               INPUT RowErrorsAux.errorhelp,
                                                               INPUT "":U).              
                    END.

                END.
            END.

         end.    

     end.

END.

IF p-ind-event = "aftervalidaItemDaNota" THEN DO:

    find tt-epc
         where tt-epc.cod-event     = p-ind-event
           and tt-epc.cod-parameter = "table-rowid"
         no-error.

    if avail tt-epc then do:
        FIND wt-docto
             WHERE rowid(wt-docto) = to-rowid(tt-epc.val-parameter) NO-LOCK NO-ERROR.
     end.

     IF AVAIL wt-docto THEN DO:
         FIND estabelec
             WHERE estabelec.cod-estabel = wt-docto.cod-estabel NO-LOCK NO-ERROR.

         FIND emitente
             WHERE emitente.cod-emitente = wt-docto.cod-emitente NO-LOCK NO-ERROR.
     
         FOR EACH wt-it-docto OF wt-docto NO-LOCK,
             FIRST natur-oper  NO-LOCK
                    WHERE natur-oper.nat-operacao = wt-it-docto.nat-operacao:

                FIND ITEM
                    WHERE ITEM.it-codigo = wt-it-docto.it-codigo NO-LOCK NO-ERROR.
                 
                FIND int-wt-it-docto
                     WHERE int-wt-it-docto.seq-wt-docto     = wt-it-docto.seq-wt-docto
                       AND int-wt-it-docto.seq-wt-it-docto  = wt-it-docto.seq-wt-it-docto NO-LOCK NO-ERROR.
                 
                IF AVAIL emitente
                    AND emitente.contrib-icms = YES 
                    AND substring(wt-docto.nat-operacao,1,1) <> "7"
                    AND  wt-docto.estado <> estabelec.estado THEN DO:
                     
                     IF AVAIL int-wt-it-docto THEN DO:
                        
                         IF    INDEX(PROGRAM-NAME(1),'esftp009') = 0 and 
                               INDEX(PROGRAM-NAME(2),'esftp009') = 0 and 
                               INDEX(PROGRAM-NAME(3),'esftp009') = 0 and 
                               INDEX(PROGRAM-NAME(4),'esftp009') = 0 and 
                               INDEX(PROGRAM-NAME(5),'esftp009') = 0 and 
                               INDEX(PROGRAM-NAME(6),'esftp009') = 0 and 
                               INDEX(PROGRAM-NAME(7),'esftp009') = 0 and 
                               INDEX(PROGRAM-NAME(8),'esftp009') = 0 THEN DO:

                                IF (int-wt-it-docto.codigo-orig = 1
                                OR  int-wt-it-docto.codigo-orig = 2
                                OR  int-wt-it-docto.codigo-orig = 3
                                OR  int-wt-it-docto.codigo-orig = 8) THEN DO:
        
                                    FOR EACH wt-it-imposto OF wt-it-docto NO-LOCK
                                       WHERE wt-it-imposto.aliquota-icm <> 4:
                                       find tt-epc
                                         where tt-epc.cod-event     = p-ind-event
                                           AND tt-epc.cod-parameter = "object-handle"
                                           NO-LOCK NO-ERROR.
        
                                       ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).
                                       RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                                              INPUT "EMS",
                                                                              INPUT "ERROR",
                                                                              INPUT "Aliquota de ICMS Incorreta, Entre em Contato com Grupo Tributario, Item = " + wt-it-docto.it-codigo,
                                                                              INPUT "Aliquota de ICMS Incorreta, Entre em Contato com Grupo Tributario, Item = " + wt-it-docto.it-codigo,
                                                                              INPUT "").
                                    END.
                                    
                                END.
                                ELSE
                                    IF (int-wt-it-docto.codigo-orig = 0
                                    OR  int-wt-it-docto.codigo-orig = 4
                                    OR  int-wt-it-docto.codigo-orig = 5
                                    OR  int-wt-it-docto.codigo-orig = 6
                                    OR  int-wt-it-docto.codigo-orig = 7) THEN DO:
            
                                        FOR EACH wt-it-imposto OF wt-it-docto NO-LOCK
                                           WHERE wt-it-imposto.aliquota-icm = 4:
                                           find tt-epc
                                             where tt-epc.cod-event     = p-ind-event
                                               AND tt-epc.cod-parameter = "this-procedure"
                                               NO-LOCK NO-ERROR.
            
                                           ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).
                                           RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                                                  INPUT "EMS",
                                                                                  INPUT "ERROR",
                                                                                  INPUT "Aliquota de ICMS Incorreta, Entre em Contato com Grupo Tributario, Item = " + wt-it-docto.it-codigo,
                                                                                  INPUT "Aliquota de ICMS Incorreta, Entre em Contato com Grupo Tributario, Item = " + wt-it-docto.it-codigo,
                                                                                  INPUT "").
                                        END.
                                        
                                    END.

                          END.
                     END.
                     ELSE DO:
                         IF    INDEX(PROGRAM-NAME(1),'esftp009') = 0 and 
                               INDEX(PROGRAM-NAME(2),'esftp009') = 0 and 
                               INDEX(PROGRAM-NAME(3),'esftp009') = 0 and 
                               INDEX(PROGRAM-NAME(4),'esftp009') = 0 and 
                               INDEX(PROGRAM-NAME(5),'esftp009') = 0 and 
                               INDEX(PROGRAM-NAME(6),'esftp009') = 0 and 
                               INDEX(PROGRAM-NAME(7),'esftp009') = 0 and 
                               INDEX(PROGRAM-NAME(8),'esftp009') = 0 THEN DO:

                                 IF AVAIL ITEM
                                      and (ITEM.codigo-orig = 1
                                       OR  ITEM.codigo-orig = 2
                                       OR  ITEM.codigo-orig = 3
                                       OR  ITEM.codigo-orig = 8) THEN DO:
            
                                        FOR EACH wt-it-imposto OF wt-it-docto NO-LOCK
                                           WHERE wt-it-imposto.aliquota-icm <> 4:
        
                                           find tt-epc
                                             where tt-epc.cod-event     = p-ind-event
                                               AND tt-epc.cod-parameter = "object-handle"
                                               NO-LOCK NO-ERROR.
        
                                           ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).
                                           RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                                                  INPUT "EMS",
                                                                                  INPUT "ERROR",
                                                                                  INPUT "Aliquota de ICMS Incorreta, Entre em Contato com Grupo Tributario, Item = " + wt-it-docto.it-codigo,
                                                                                  INPUT "Aliquota de ICMS Incorreta, Entre em Contato com Grupo Tributario, Item = " + wt-it-docto.it-codigo,
                                                                                  INPUT "").
                                        END.
                                 END.
                                 ELSE
                                     IF (item.codigo-orig = 0
                                     OR  item.codigo-orig = 4
                                     OR  item.codigo-orig = 5
                                     OR  item.codigo-orig = 6
                                     OR  item.codigo-orig = 7) THEN DO:

                                         FOR EACH wt-it-imposto OF wt-it-docto NO-LOCK
                                            WHERE wt-it-imposto.aliquota-icm = 4:
                                            find tt-epc
                                              where tt-epc.cod-event     = p-ind-event
                                                AND tt-epc.cod-parameter = "this-procedure"
                                                NO-LOCK NO-ERROR.

                                            ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).
                                            RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                                                   INPUT "EMS",
                                                                                   INPUT "ERROR",
                                                                                   INPUT "Aliquota de ICMS Incorreta, Entre em Contato com Grupo Tributario, Item = " + wt-it-docto.it-codigo,
                                                                                   INPUT "Aliquota de ICMS Incorreta, Entre em Contato com Grupo Tributario, Item = " + wt-it-docto.it-codigo,
                                                                                   INPUT "").
                                         END.

                                     END.

                         END.
                     END.
                 END.
           
        END.
     END.
  END.

 IF p-ind-event = "AfterValidaCriacaoWtDocto" THEN DO:
  
    FOR FIRST tt-epc NO-LOCK
        WHERE tt-epc.cod-event = p-ind-event
          AND tt-epc.cod-parameter = "Object-Handle":
        ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).
    END.

    FOR FIRST tt-epc NO-LOCK
        WHERE tt-epc.cod-event = p-ind-event
          AND tt-epc.cod-parameter = "Table-Rowid":

        FIND FIRST wt-docto WHERE ROWID(wt-docto) = TO-ROWID(tt-epc.val-parameter) NO-LOCK NO-ERROR.
        IF AVAIL wt-docto THEN DO: 

            IF wt-docto.dt-emis-nota <> TODAY THEN DO:

                ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).

                FIND FIRST bloqueio-fat NO-LOCK NO-ERROR.
                IF AVAIL bloqueio-fat 
                AND LOOKUP(wt-docto.cod-estabel,bloqueio-fat.estab-fatcom) = 0 THEN DO:
                    RUN _insertErrorManual IN h-bodi317va (INPUT 17006,
                                                           INPUT "EMS",
                                                           INPUT "ERROR",
                                                           INPUT "Data de faturamento diferente da Data de Emiss∆o da NF!",
                                                           INPUT "Data de faturamento diferente da Data de Emiss∆o da NF!",
                                                           INPUT "").
                END.
            END.
        END.
    END.
END.

PROCEDURE bloq-faturamento:
    DEFINE INPUT PARAMETER da-data-inicial  AS DATETIME NO-UNDO.
    DEFINE INPUT PARAMETER r-ttEpc          AS ROWID NO-UNDO.
    DEFINE INPUT PARAMETER usuarios         AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER estabsNota       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER estabsBloq       AS CHARACTER NO-UNDO.
    
    ASSIGN da-data-atual =  DATETIME(TODAY, MTIME). 

    IF  da-data-atual > da-data-inicial 
    AND LOOKUP(v_cod_usuar_corren, usuarios) = 0 
    AND LOOKUP(estabsNota, estabsBloq)       = 0 THEN DO:

        FIND FIRST tt-epc WHERE ROWID(tt-epc) = r-ttEpc NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-epc THEN DO:
            FOR first tt-epc 
                where tt-epc.cod-event      = p-ind-event
                  AND tt-epc.cod-parameter  = "OBJECT-HANDLE" NO-LOCK:
            END.
        END. /* IF NOT AVAIL tt-epc THEN DO:*/

        IF AVAIL tt-epc THEN DO:

            ASSIGN h-bodi317va = WIDGET-HANDLE(tt-epc.val-parameter).

                
            RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                                       INPUT "EMS",
                                                       INPUT "ERROR",
                                                       INPUT "Bloqueado para Faturamento a partir de " + string(da-data-ini) + " Horas ref Usuario",  
                                                       INPUT "Bloqueado para Faturamento a partir de " + string(da-data-ini) + " Horas ref Usuario",
                                                       INPUT "").
        END.
    END.

END PROCEDURE.

PROCEDURE bloq-faturamento-estab:
    DEFINE INPUT PARAMETER da-data-inicial  AS DATETIME NO-UNDO.
    DEFINE INPUT PARAMETER r-ttEpc          AS ROWID NO-UNDO.
    DEFINE INPUT PARAMETER estabsNota       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER estabsBloq       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER usuarios         AS CHARACTER NO-UNDO.

    IF  da-data-atual > da-data-inicial 
    AND LOOKUP(v_cod_usuar_corren, usuarios) = 0
    AND LOOKUP(estabsNota, estabsBloq)       = 0 THEN DO:

      RUN _insertErrorManual IN h-bodi317va (INPUT 99999,
                                               INPUT "EMS",
                                               INPUT "ERROR",
                                               INPUT "Bloqueado para Faturamento a partir de " + string(da-data-ini) + " Horas ref Estabelecimento",  
                                               INPUT "Bloqueado para Faturamento a partir de " + string(da-data-ini) + " Horas ref Estabelecimento",
                                               INPUT "").
    END.

END PROCEDURE.


PROCEDURE pi-libera-simulacao-fat:

    DEF OUTPUT PARAM p-libera-simul-fat AS LOG NO-UNDO.

    ASSIGN p-libera-simul-fat = NO.

    /* SIMULACAO DE CALCULO ESPDP027 - ORCAMENTO PEDIDO */
    IF index(PROGRAM-NAME(1) ,'espdp097') <> 0 or
       index(PROGRAM-NAME(2) ,'espdp097') <> 0 or
       index(PROGRAM-NAME(3) ,'espdp097') <> 0 or
       index(PROGRAM-NAME(4) ,'espdp097') <> 0 or
       index(PROGRAM-NAME(5) ,'espdp097') <> 0 or
       index(PROGRAM-NAME(6) ,'espdp097') <> 0 or
       index(PROGRAM-NAME(7) ,'espdp097') <> 0 or
       index(PROGRAM-NAME(8) ,'espdp097') <> 0 or
       index(PROGRAM-NAME(9) ,'espdp097') <> 0 or
       index(PROGRAM-NAME(10),'espdp097') <> 0 THEN 
       ASSIGN p-libera-simul-fat = YES.

END PROCEDURE.

PROCEDURE pi-verifica-ST:
    DEFINE INPUT  PARAM pNatOper AS CHAR    NO-UNDO.
    DEFINE OUTPUT PARAM p-ST AS LOG INIT NO NO-UNDO.

   /* DEFINE VAR h-boes505          AS HANDLE NO-UNDO.
    DEFINE VAR c-nat-oper         AS CHAR   NO-UNDO.
    DEFINE VAR l-return           AS LOG    NO-UNDO. */
    DEFINE VAR l-consumidor-final AS LOG    NO-UNDO.

    IF ped-venda.cod-des-merc = 1 THEN
        ASSIGN l-consumidor-final = NO.
    ELSE
        ASSIGN l-consumidor-final = YES.

    FIND FIRST b-emitente NO-LOCK
         WHERE b-emitente.nome-abrev = ped-venda.nome-abrev NO-ERROR.

    FIND FIRST unid-feder NO-LOCK
         WHERE unid-feder.pais   = b-emitente.pais
           AND unid-feder.estado = b-emitente.estado NO-ERROR.
    FIND estabelec
        WHERE estabelec.cod-estabel = ped-venda.cod-estabel NO-LOCK NO-ERROR.

    IF  b-emitente.natureza <> 3 
    AND b-emitente.contrib-icms = NO
    AND (b-emitente.ins-estadual = ""
    OR   b-emitente.ins-estadual = "ISENTO"
    OR   b-emitente.ins-estadual = "ISENTA") THEN
        ASSIGN l-consumidor-final = YES.
            
   /* RUN esbo/boes505.p PERSISTENT SET h-boes505.

    RUN defineNatOperacao IN h-boes505 (INPUT ped-venda.cod-estabel,
                                        INPUT ped-venda.cod-emitente,
                                        INPUT ped-venda.cod-entrega,
                                        INPUT ITEM.it-codigo,
                                        INPUT l-consumidor-final,
                                        OUTPUT c-nat-oper,
                                        OUTPUT l-return).
    DELETE PROCEDURE h-boes505. */

    IF b-emitente.contrib-icms AND AVAIL unid-feder AND unid-feder.ind-uf-subs THEN DO:

      FIND FIRST item-uf NO-LOCK
           WHERE ITEM-uf.it-codigo       = ITEM.it-codigo
             AND item-uf.cod-estado-orig = estabelec.estado
             AND item-uf.estado          = b-emitente.estado NO-ERROR.
      FIND FIRST dist-emitente OF b-emitente NO-LOCK NO-ERROR.

      FIND FIRST natur-oper
           WHERE natur-oper.nat-operacao = pNatOper NO-LOCK NO-ERROR.
      IF AVAIL natur-oper THEN DO:
          if  natur-oper.subs-trib AND
             AVAIL item-uf AND AVAIL dist-emitente AND dist-emitente.nr-tb-pauta = ""
             AND b-emitente.insc-subs-trib = "" THEN  DO:

             ASSIGN p-ST = YES.
          END.
      END. /* IF AVAIL natur-oper THEN DO: */

   END. /* IF emitente.contrib-icms AND AVAIL unid-feder AND unid-feder.ind-uf-subs THEN DO: */

END PROCEDURE.
