/* ----------------------------------------------------------------------------
   Programa..: upc/boin317ef-upc.p
   Data......: Dezembro / 2004.
   Autor.....: Robinson Rafael Koprowski - Datasul Gestech.
   Objetivo..: Alteracao de status da ped-fiscal na efetivacao da NF
---------------------------------------------------------------------------- */

DEFINE VARIABLE hBODI317ef          AS HANDLE     NO-UNDO.
DEFINE VARIABLE l-procedimento-ok   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE i-proximo-vol       AS INTEGER    NO-UNDO.
DEFINE VARIABLE l-so-portaria       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE h-boes150b          AS HANDLE     NO-UNDO.
DEFINE VARIABLE c-retorno           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-mensagem          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-tipo-transacao    AS CHARACTER  NO-UNDO.
DEFINE variable c-nat-vinculada     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-nome-abrev-tri    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-cod-entrega-tri   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE h-esapi014          AS HANDLE      NO-UNDO.
DEFINE VARIABLE pcNroCartao         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-programa-bodi317sd AS HANDLE      NO-UNDO.

/* Include i-epc200.i: Definiá∆o Temp-Table tt-epc */
{include/i-epc200.i1}
{utp/utapi019.i}
{utp/ut-glob.i}    
{method/dbotterr.i}

DEFINE TEMP-TABLE tt-notas-geradas NO-UNDO
    FIELD rw-nota-fiscal    AS ROWID
    FIELD nr-nota           LIKE nota-fiscal.nr-nota-fis
    FIELD seq-wt-docto      LIKE wt-docto.seq-wt-docto.

def temp-table tt-resto NO-UNDO
    field it-codigo like item.it-codigo
    field qtde      as dec
    index tt-resto is primary unique it-codigo
    index qtde     qtde.

def temp-table rowerrorsaux NO-UNDO like rowerrors.
DEFINE INPUT PARAMETER p-ind-event  AS CHARACTER    NO-UNDO. 
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-epc.
DEF NEW GLOBAL SHARED VARIABLE g-codigo-orig-bodi317sd AS INTEGER.

/** Tratamento de ponto de programa **/
DEF VAR i-nome-programa AS CHAR NO-UNDO.
DEF VAR i-ponto         AS INT  NO-UNDO.
DEF VAR i-sequencia     AS INT  NO-UNDO.
DEF VAR i-conteudo      AS CHAR NO-UNDO.

DEF VAR d-totalItens AS DEC     NO-UNDO.
DEF VAR d-aliq-ipi   AS DECIMAL NO-UNDO.

IF p-ind-event = 'afterGravaPerc' THEN DO TRANSACTION ON ERROR UNDO, RETURN 'NOK':

    ASSIGN g-codigo-orig-bodi317sd = 0.

    FOR FIRST tt-epc
        WHERE tt-epc.cod-event     = p-ind-event
          AND tt-epc.cod-parameter = 'wt-it-imposto',
        FIRST wt-it-docto
        WHERE ROWID(wt-it-docto) = TO-ROWID(ENTRY(2, tt-epc.val-parameter, ";"))
              NO-LOCK,
        FIRST ITEM
        WHERE ITEM.it-codigo = wt-it-docto.it-codigo
              NO-LOCK:
        ASSIGN g-codigo-orig-bodi317sd = ITEM.codigo-orig.
    END.
END.

IF p-ind-event = 'afterCriaWtDocto' THEN DO TRANSACTION ON ERROR UNDO, RETURN 'NOK':

    FIND FIRST tt-epc
         WHERE tt-epc.cod-event     = p-ind-event
           AND tt-epc.cod-parameter = "object-handle" NO-ERROR.
    IF AVAIL tt-epc THEN DO:
        ASSIGN h-programa-bodi317sd = WIDGET-HANDLE(tt-epc.val-parameter).
    END.

    IF VALID-HANDLE(h-programa-bodi317sd) THEN DO:
        FOR FIRST tt-epc
            WHERE tt-epc.cod-event     = p-ind-event
              AND tt-epc.cod-parameter = 'table-rowid':

            FIND FIRST wt-docto NO-LOCK
                 WHERE ROWID(wt-docto) = TO-ROWID(tt-epc.val-parameter) NO-ERROR.
            IF AVAIL wt-docto THEN DO:
                IF ((INDEX(PROGRAM-NAME(1),'ft4003') <> 0 and
                     INDEX(PROGRAM-NAME(1),'ft4003') <> ?) OR
        
                    (INDEX(PROGRAM-NAME(2),'ft4003') <> 0 and
                     INDEX(PROGRAM-NAME(2),'ft4003') <> ?) OR
        
                    (INDEX(PROGRAM-NAME(3),'ft4003') <> 0 and
                     INDEX(PROGRAM-NAME(3),'ft4003') <> ?) OR
        
                    (INDEX(PROGRAM-NAME(4),'ft4003') <> 0 and
                     INDEX(PROGRAM-NAME(4),'ft4003') <> ?) OR
        
                    (INDEX(PROGRAM-NAME(5),'ft4003') <> 0 and
                     INDEX(PROGRAM-NAME(5),'ft4003') <> ?) OR
        
                    (INDEX(PROGRAM-NAME(6),'ft4003') <> 0 and
                     INDEX(PROGRAM-NAME(6),'ft4003') <> ?) OR
                
                    (INDEX(PROGRAM-NAME(7),'ft4003') <> 0 and
                     INDEX(PROGRAM-NAME(7),'ft4003') <> ?) OR
        
                    (INDEX(PROGRAM-NAME(8),'ft4003') <> 0 and
                     INDEX(PROGRAM-NAME(8),'ft4003') <> ?) OR
                    
                    (INDEX(PROGRAM-NAME(9),'ft4003') <> 0 and
                     INDEX(PROGRAM-NAME(9),'ft4003') <> ?) OR
                   
                    (INDEX(PROGRAM-NAME(10),'ft4003') <> 0 and
                     INDEX(PROGRAM-NAME(10),'ft4003') <> ?) OR
                    
                    (INDEX(PROGRAM-NAME(1),'pd4000') <> 0 and 
                     INDEX(PROGRAM-NAME(1),'pd4000') <> ?) OR 
                                                              
                    (INDEX(PROGRAM-NAME(2),'pd4000') <> 0 and 
                     INDEX(PROGRAM-NAME(2),'pd4000') <> ?) OR 
                                                              
                    (INDEX(PROGRAM-NAME(3),'pd4000') <> 0 and 
                     INDEX(PROGRAM-NAME(3),'pd4000') <> ?) OR 
                                                              
                    (INDEX(PROGRAM-NAME(4),'pd4000') <> 0 and 
                     INDEX(PROGRAM-NAME(4),'pd4000') <> ?) OR 
                                                              
                    (INDEX(PROGRAM-NAME(5),'pd4000') <> 0 and 
                     INDEX(PROGRAM-NAME(5),'pd4000') <> ?) OR 
                                                              
                    (INDEX(PROGRAM-NAME(6),'pd4000') <> 0 and 
                     INDEX(PROGRAM-NAME(6),'pd4000') <> ?) OR 
                                                              
                    (INDEX(PROGRAM-NAME(7),'pd4000') <> 0 and 
                     INDEX(PROGRAM-NAME(7),'pd4000') <> ?) OR 
                                                              
                    (INDEX(PROGRAM-NAME(8),'pd4000') <> 0 and 
                     INDEX(PROGRAM-NAME(8),'pd4000') <> ?) OR 
                                                              
                    (INDEX(PROGRAM-NAME(9),'pd4000') <> 0 and 
                     INDEX(PROGRAM-NAME(9),'pd4000') <> ?) OR 
                                                              
                    (INDEX(PROGRAM-NAME(10),'pd4000') <> 0 and
                     INDEX(PROGRAM-NAME(10),'pd4000') <> ?)) THEN DO:
                    
                    FIND FIRST usuar-nat-operacao
                        WHERE usuar-nat-operacao.cod-usuario  = v_cod_usuar_corren 
                          AND wt-docto.nat-operacao           BEGINS usuar-nat-operacao.nat-operacao NO-LOCK NO-ERROR.
                    IF NOT AVAIL usuar-nat-operacao THEN DO:
                        FIND FIRST usuar-nat-operacao
                            WHERE usuar-nat-operacao.cod-usuario  = v_cod_usuar_corren
                              AND usuar-nat-operacao.nat-operacao = "*" NO-LOCK NO-ERROR.
                        IF NOT AVAIL usuar-nat-operacao THEN DO:
                            RUN _insertErrorManual IN h-programa-bodi317sd (INPUT 0,
                                                                            INPUT 'EMS',
                                                                            INPUT 'ERROR', 
                                                                            INPUT 'Natureza de operaá∆o n∆o liberada para este usu†rio emitir nota fiscal',
                                                                            INPUT 'Solicite para o grupo.fiscal liberaá∆o desta natureza de operaá∆o para seu usu†rio emitir a nota fiscal.',
                                                                            INPUT '':U).
                        END.
                    END.
                END.

                FIND CURRENT wt-docto EXCLUSIVE-LOCK NO-ERROR.
                IF AVAIL wt-docto 
                THEN DO:
                    FOR EACH ped-venda no-lock
                        WHERE ped-venda.nome-abrev = wt-docto.nome-abrev
                        AND   ped-venda.nr-pedcli  = wt-docto.nr-pedcli,
                        FIRST int-ped-venda
                        WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido
                          AND int-ped-venda.cod-estabel = ped-venda.cod-estabel
                              NO-LOCK:

                        IF int-ped-venda.ValorFrete <> 0 THEN DO:
                            ASSIGN wt-docto.vl-frete-inf = int-ped-venda.ValorFrete.
                        END.
                        ELSE DO:
                            IF int-ped-venda.vl-frete <> 0 THEN DO:
                                ASSIGN d-aliq-ipi   = 0
                                       d-totalItens = 0.
                                FOR EACH wt-it-docto NO-LOCK
                                   WHERE wt-it-docto.seq-wt-docto  = wt-docto.seq-wt-docto
                                     AND wt-it-docto.calcula:
                                    FIND FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = wt-it-docto.it-codigo NO-ERROR.
                                    IF AVAIL ITEM AND ITEM.aliquota-ipi > 0 THEN
                                        ASSIGN d-aliq-ipi = d-aliq-ipi + int-ped-venda.vl-frete * wt-it-docto.vl-preori * wt-it-docto.quantidade[1] * ITEM.aliquota-ipi.
                                    ASSIGN d-totalItens = d-totalItens + (wt-it-docto.vl-preori * wt-it-docto.quantidade[1]).
                                END.
                                ASSIGN d-aliq-ipi = d-aliq-ipi / 100 / int-ped-venda.vl-frete / d-totalItens.
        
                                IF d-aliq-ipi = ? THEN
                                    ASSIGN d-aliq-ipi = 0.
                                
                                IF ped-venda.estado <> "EX" THEN

                                    ASSIGN wt-docto.vl-frete-inf = ROUND(int-ped-venda.vl-frete  / (1 + d-aliq-ipi),2).
                                ELSE
                                    ASSIGN wt-docto.vl-frete-inf = ROUND(int-ped-venda.vl-frete,2).
                            END.
                        END.
                    
                        ASSIGN wt-docto.nr-volumes       = int-ped-venda.nr-volumes
                               wt-docto.vl-seguro-inf    = int-ped-venda.vl-seguro    /* * vConversao */
                               wt-docto.vl-embalagem-inf = int-ped-venda.vl-embalagem.  /* * vConversao */ 
                    
                        IF wt-docto.serie = "Pedido" and
                           (int-ped-venda.vl-frete     > 0 OR
                            int-ped-venda.vl-seguro    > 0 OR
                            int-ped-venda.vl-embalagem > 0) THEN DO:
                           ASSIGN wt-docto.serie            = "PedidoIntelbras".
                        END.
                    END.
                    IF SUBSTRING(wt-docto.char-1,158,8) = "" THEN DO:
                       ASSIGN OVERLAY(wt-docto.char-1,158,8) = "0".
                    END.
                END.

                RELEASE wt-docto.
            END.

            FIND wt-docto EXCLUSIVE-LOCK 
                 WHERE ROWID(wt-docto) = TO-ROWID(tt-epc.val-parameter) NO-ERROR.
            IF AVAIL wt-docto THEN DO:

                FOR EACH ped-venda no-lock
                    WHERE ped-venda.nome-abrev = wt-docto.nome-abrev
                    AND   ped-venda.nr-pedcli  = wt-docto.nr-pedcli,
                    FIRST int-ped-venda
                    WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido
                      AND int-ped-venda.cod-estabel = ped-venda.cod-estabel:

                    IF int-ped-venda.ValorFrete <> 0 THEN DO:
                        ASSIGN wt-docto.vl-frete-inf = int-ped-venda.ValorFrete.
                    END.
                    ELSE DO:
                        IF int-ped-venda.vl-frete <> 0 THEN DO:
    
                            ASSIGN d-aliq-ipi   = 0
                                   d-totalItens = 0.
                            FOR EACH wt-it-docto NO-LOCK
                               WHERE wt-it-docto.seq-wt-docto  = wt-docto.seq-wt-docto
                                 AND wt-it-docto.calcula:
                                FIND FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = wt-it-docto.it-codigo NO-ERROR.
                                IF AVAIL ITEM AND ITEM.aliquota-ipi > 0 THEN
                                    ASSIGN d-aliq-ipi = d-aliq-ipi + int-ped-venda.vl-frete * wt-it-docto.vl-preori * wt-it-docto.quantidade[1] * ITEM.aliquota-ipi.
                                ASSIGN d-totalItens = d-totalItens + (wt-it-docto.vl-preori * wt-it-docto.quantidade[1]).
                            END.
                            ASSIGN d-aliq-ipi = d-aliq-ipi / 100 / int-ped-venda.vl-frete / d-totalItens.
    
                            IF d-aliq-ipi = ? THEN
                                ASSIGN d-aliq-ipi = 0.  
    
                            ASSIGN wt-docto.vl-frete-inf = ROUND(int-ped-venda.vl-frete  / (1 + d-aliq-ipi),2).
                        END.
                    END.
                END.
            END.    
        END.
    END.
     
    IF NOT((INDEX(PROGRAM-NAME(1),'pd400') <> 0 and
            INDEX(PROGRAM-NAME(1),'pd400') <> ?) OR

           (INDEX(PROGRAM-NAME(2),'pd400') <> 0 and
            INDEX(PROGRAM-NAME(2),'pd400') <> ?) OR

           (INDEX(PROGRAM-NAME(3),'pd400') <> 0 and
            INDEX(PROGRAM-NAME(3),'pd400') <> ?) OR

           (INDEX(PROGRAM-NAME(4),'pd400') <> 0 and
            INDEX(PROGRAM-NAME(4),'pd400') <> ?) OR

           (INDEX(PROGRAM-NAME(5),'pd400') <> 0 and
            INDEX(PROGRAM-NAME(5),'pd400') <> ?) OR

           (INDEX(PROGRAM-NAME(6),'pd400') <> 0 and
            INDEX(PROGRAM-NAME(6),'pd400') <> ?) OR
        
           (INDEX(PROGRAM-NAME(7),'pd400') <> 0 and
            INDEX(PROGRAM-NAME(7),'pd400') <> ?) OR

           (INDEX(PROGRAM-NAME(8),'pd400') <> 0 and
            INDEX(PROGRAM-NAME(8),'pd400') <> ?) OR
           
           (INDEX(PROGRAM-NAME(9),'pd400') <> 0 and
            INDEX(PROGRAM-NAME(9),'pd400') <> ?) OR
           
           (INDEX(PROGRAM-NAME(10),'pd400') <> 0 and
            INDEX(PROGRAM-NAME(10),'pd400') <> ?)) THEN DO:

        IF VALID-HANDLE(h-programa-bodi317sd) THEN DO:
            FOR FIRST tt-epc
                WHERE tt-epc.cod-event     = p-ind-event
                  AND tt-epc.cod-parameter = 'table-rowid':
                IF VALID-HANDLE(h-programa-bodi317sd) THEN DO:
                    RUN GetRowerrors IN h-programa-bodi317sd (OUTPUT table RowErrorsAux).
                
                    run EmptyRowErrors in h-programa-bodi317sd.
                
                    for each RowErrorsAux
                        where RowErrorsAux.ErrorDescription = 'Cliente Inativo. N∆o Ç permitido Emitir NF':U
                          AND rowerrorsaux.ErrorNumber = 0:
                        delete RowErrorsAux.
                    end.
                    FOR EACH RowErrorsAux:
                        RUN _insertErrorManual IN h-programa-bodi317sd (INPUT RowErrorsAux.errornumber,
                                                                        INPUT RowErrorsAux.ERRORtype,
                                                                        INPUT RowErrorsAux.ERRORsubtype, 
                                                                        INPUT RowErrorsAux.errordescription,
                                                                        INPUT RowErrorsAux.errorhelp,
                                                                        INPUT '':U).              
                    END.
                END.  
                FIND wt-docto NO-LOCK 
                     WHERE ROWID(wt-docto) = TO-ROWID(tt-epc.val-parameter) NO-ERROR.
                
                FIND natur-oper
                     WHERE natur-oper.nat-operacao = wt-docto.nat-operacao NO-LOCK NO-ERROR.

                FIND emitente
                     WHERE emitente.cod-emitente = wt-docto.cod-emitente NO-LOCK NO-ERROR.

                IF AVAIL emitente and
                   emitente.cod-gr-cli <> 8 AND
                   emitente.cod-gr-cli <> 9 and
                   emitente.cod-gr-cli <> 10 and
                   emitente.cod-gr-cli <> 15 and
                   emitente.cod-gr-cli <> 16 AND
                   wt-docto.nat-operacao <> '694924' AND
                   wt-docto.nat-operacao <> '594934' THEN DO:

                    FIND int-emitente
                         WHERE int-emitente.cod-emitente = wt-docto.cod-emitente NO-LOCK NO-ERROR.
                    IF AVAIL  int-emitente THEN DO:
                        IF int-emitente.id-ativo = NO AND
                           natur-oper.emite-duplic = YES THEN DO:
                            RUN _insertErrorManual IN h-programa-bodi317sd (INPUT 0,
                                                                            INPUT 'EMS',
                                                                            INPUT 'ERROR', 
                                                                            INPUT 'Cliente Inativo por estar sem movimentacao nos ultimos 180 dias, gentileza solicitar atualizacao cadastral diretamente com a central de cadastro',
                                                                            INPUT 'Cliente Inativo por estar sem movimentacao nos ultimos 180 dias, gentileza solicitar atualizacao cadastral diretamente com a central de cadastro',
                                                                            INPUT '':U).
                        END.
                    END.
                    ELSE DO:
                        RUN _insertErrorManual IN h-programa-bodi317sd (INPUT 0,
                                                                        INPUT 'EMS',
                                                                        INPUT 'ERROR', 
                                                                        INPUT 'Extens∆o do emitente n∆o cadastrado',
                                                                        INPUT 'Extens∆o do emitente n∆o cadastrado',
                                                                        INPUT '':U). 
                    END.

                END.

                FIND FIRST int-cond-pagto
                    WHERE int-cond-pagto.cod-cond-pag = wt-docto.cod-cond-pag NO-LOCK NO-ERROR.

                IF AVAILABLE int-cond-pagto                       AND
                   SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S":U THEN DO:
                    
                    FIND CURRENT wt-docto EXCLUSIVE-LOCK NO-ERROR.

                    IF AVAILABLE wt-docto THEN DO:
                        ASSIGN wt-docto.tip-cob-desp = 2.

                        FOR FIRST ped-venda
                            WHERE ped-venda.nome-abrev = wt-docto.nome-abrev
                              AND ped-venda.nr-pedcli  = wt-docto.nr-pedcli 
                                  EXCLUSIVE-LOCK:
                            ASSIGN ped-venda.tip-cob-desp = 2.
                        END.

                        RELEASE wt-docto.
                    END.                    
                END.
				
        		FIND wt-docto EXCLUSIVE-LOCK 
        			 WHERE ROWID(wt-docto) = TO-ROWID(tt-epc.val-parameter) NO-ERROR.
        		IF AVAIL wt-docto THEN DO:
        			FOR EACH ped-venda no-lock
        				WHERE ped-venda.nome-abrev = wt-docto.nome-abrev
        				AND   ped-venda.nr-pedcli  = wt-docto.nr-pedcli,
        				FIRST int-ped-venda
        				WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido
        				  AND int-ped-venda.cod-estabel = ped-venda.cod-estabel:

                        IF int-ped-venda.ValorFrete <> 0 THEN DO:
                            ASSIGN wt-docto.vl-frete-inf = int-ped-venda.ValorFrete.
                        END.
                        ELSE DO:
                            IF int-ped-venda.vl-frete <> 0 THEN DO:
            
                                ASSIGN d-aliq-ipi   = 0
                                       d-totalItens = 0.
                                FOR EACH wt-it-docto NO-LOCK
                                   WHERE wt-it-docto.seq-wt-docto  = wt-docto.seq-wt-docto
                                     AND wt-it-docto.calcula:
                                    FIND FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = wt-it-docto.it-codigo NO-ERROR.
                                    IF AVAIL ITEM AND ITEM.aliquota-ipi > 0 THEN
                                        ASSIGN d-aliq-ipi = d-aliq-ipi + int-ped-venda.vl-frete * wt-it-docto.vl-preori * wt-it-docto.quantidade[1] * ITEM.aliquota-ipi.
                                    ASSIGN d-totalItens = d-totalItens + (wt-it-docto.vl-preori * wt-it-docto.quantidade[1]).
                                END.
                                ASSIGN d-aliq-ipi = d-aliq-ipi / 100 / int-ped-venda.vl-frete / d-totalItens.
            
                                IF d-aliq-ipi = ? THEN
                                    ASSIGN d-aliq-ipi = 0.  
            
                                ASSIGN wt-docto.vl-frete-inf = ROUND(int-ped-venda.vl-frete  / (1 + d-aliq-ipi),2).
                            END.
                        END.
                    END.
                END.
                RELEASE wt-docto.
            END.
        END.
    END.
END.
    
