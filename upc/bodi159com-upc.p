/***********************************************************************
**  Programa..: UPC\BODI159-EPC.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: EPC - BODI159-EPC ONDE:
**              001 - Limpar descontos na implantaá∆o do registro.  
**  Vers∆o....: 001 10/11/2004 - Marcio Chaves
**                  Desenvolvimento Programa
************************************************************************/
{include/i-epc200.i1}
{upc/btb910za-upc.i}
{esp/es0018.i}
{esp/esb/esesb000.i}

def input param pIndEvent as char no-undo.
def input-output param table for tt-epc.

define temp-table tt-sf-ped-venda no-undo like ped-venda.
define temp-table tt-sf-ped-item  no-undo like ped-item.

DEFINE TEMP-TABLE tt-pedido-integra NO-UNDO
    FIELD r-rowid AS ROWID
    FIELD i-origem-inegr AS INT /*1 - Pedido, 2 - Faturamento*/.

define temp-table tt-envio NO-UNDO
    field versao-integracao   as integer format ">>9"
    field servidor            as char
    field porta               as integer init 0
    field exchange            as logical init no
    field destino             as char
    field copia               as char
    field remetente           as char
    field assunto             as char
    field mensagem            as char
    field arq-anexo           as char
    field importancia         as integer init 0
    field log-enviada         as logical
    field log-lida            as logical
    field acomp               as logical init yes.

define temp-table tt-envio2 NO-UNDO
    field versao-integracao   as integer format ">>9"
    field servidor            as char
    field porta               as integer init 0
    field exchange            as logical init no
    field destino             as char
    field copia               as char
    field remetente           as char
    field assunto             as char
    field mensagem            as char
    field arq-anexo           as char
    field importancia         as integer init 0
    field log-enviada         as logical
    field log-lida            as logical
    field acomp               as logical init yes    
    field formato             as char init "texto".

DEFINE TEMP-TABLE tt-mensagem1 NO-UNDO
    FIELD seq-mensagem        AS INTEGER
    FIELD mensagem            AS CHAR
    INDEX i-seq-mensagem
          seq-mensagem        ASCENDING.

define temp-table tt-erros NO-UNDO
    field cod-erro  as integer
    field desc-erro as character format "x(256)"
    field desc-arq  as character.

DEFINE TEMP-TABLE tt-prog-ponto-nat NO-UNDO LIKE tt-prog-ponto.

{esp/crm/escrm001.i}

DEFINE VARIABLE h-escrm001api       AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bodi159com        AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boes505           AS HANDLE      NO-UNDO.
DEFINE VARIABLE l-consumidor-final  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-valida-natureza   AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-return            AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-nat-oper          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-entrou            AS LOGICAL     NO-UNDO.
DEFINE VARIABLE de-preco            AS DECIMAL DECIMALS 5    NO-UNDO.
DEFINE VARIABLE de-liquido          LIKE ped-item.vl-preori NO-UNDO.
DEFINE VARIABLE c-mensagem-html     AS CHAR        NO-UNDO.
DEFINE VARIABLE de-perc-total       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE raw-param           AS RAW         NO-UNDO.
DEFINE VARIABLE v_log_nat_deps      AS LOG         NO-UNDO.
DEFINE VARIABLE l-pedido-empresa-grupo AS LOG      NO-UNDO.

DEF TEMP-TABLE rowerrors   NO-UNDO    /* Temp-table dos erros */
    FIELD errorsequence    AS INT
    FIELD errornumber      AS INT
    FIELD errordescription AS CHAR FORMAT "x(150)"
    FIELD errorparameters  AS CHAR
    FIELD errortype        AS CHAR
    FIELD errorhelp        AS CHAR FORMAT "x(150)"
    FIELD errorsubtype     AS CHAR.
def temp-table rowerrorsaux NO-UNDO like rowerrors.
DEFINE VARIABLE h-cdapi704 AS HANDLE      NO-UNDO.

DEFINE VARIABLE c-rua AS CHARACTER FORMAT "x(70)" NO-UNDO.
DEFINE VARIABLE c-nro  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-comp AS CHARACTER FORMAT "x(80)" NO-UNDO.

DEFINE VARIABLE c-erro-unid-neg-ped AS CHARACTER   NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_cod_categ  AS CHAR                   NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_val_dec_1  LIKE int-ped-venda2.dec-2 NO-UNDO.

DEF BUFFER b-unid-feder FOR unid-feder.
DEF BUFFER b-emitente   FOR emitente.

{utp/ut-glob.i}
FIND FIRST para-dis NO-LOCK NO-ERROR.

CASE pIndEvent:
    WHEN "beforeCompleteOrder" THEN DO:
        FOR first  tt-epc
            WHERE tt-epc.cod-event     = pIndEvent
            AND   tt-epc.cod-parameter = "Table-Rowid":
        END.

        IF AVAIL tt-epc THEN DO:
            FOR FIRST ped-venda EXCLUSIVE-LOCK
                WHERE ROWID(ped-venda) = TO-ROWID(tt-epc.val-parameter):

                FIND emitente
                    WHERE emitente.nome-abrev = ped-venda.nome-abrev NO-LOCK NO-ERROR.
                IF AVAIL emitente THEN DO:
                    FIND b-emitente
                        WHERE b-emitente.nome-abrev = emitente.nome-matriz NO-LOCK NO-ERROR.
                    IF NOT AVAIL b-emitente THEN DO:
                        for first tt-epc 
                            where tt-epc.cod-event = pIndEvent
                              AND tt-epc.cod-parameter = "OBJECT-HANDLE":   
        
                            if  valid-handle(widget-handle(tt-epc.val-parameter)) then do:
                                ASSIGN h-bodi159com = WIDGET-HANDLE(tt-epc.val-parameter).  
                               RUN _insertErrorManual IN h-bodi159com (INPUT 17567,
                                                                       INPUT "EMS",
                                                                       INPUT "ERROR",
                                                                       INPUT "Matriz DO Cliente nao encontrada NO cadastro, verifique NO CRM e corrija o cadastro",
                                                                       INPUT "Matriz DO Cliente nao encontrada NO cadastro, verifique NO CRM e corrija o cadastro",
                                                                       INPUT "").

                               RETURN "NOK":U.
                            END.
                        END.
                    END.
                END.
                IF NOT CAN-FIND (FIRST modalid-frete WHERE modalid-frete.cod-modalid-frete = substring(ped-venda.char-2,109,8)) THEN DO:
                      for first tt-epc 
                            where tt-epc.cod-event = pIndEvent
                              AND tt-epc.cod-parameter = "OBJECT-HANDLE":   
        
                            if  valid-handle(widget-handle(tt-epc.val-parameter)) then do:
                                ASSIGN h-bodi159com = WIDGET-HANDLE(tt-epc.val-parameter).  
                               RUN _insertErrorManual IN h-bodi159com (INPUT 17567,
                                                                       INPUT "EMS",
                                                                       INPUT "ERROR",
                                                                       INPUT "Deve ser informado uma unidade de frete valida existente no cadastro cd0600",
                                                                       INPUT "Deve ser informado uma unidade de frete valida existente no cadastro cd0600, no PD4000 Ç informado na pasta complementos",
                                                                       INPUT "").

                               RETURN "NOK":U.
                            END.
                        END.
                END.
                
               RUN pi-verifica-se-valida-natureza (INPUT ped-venda.nat-operacao, OUTPUT l-valida-natureza).
        
               IF l-valida-natureza = YES THEN DO:
                   IF ped-venda.cod-des-merc = 1 THEN
                      ASSIGN l-consumidor-final = NO.
                   ELSE
                      ASSIGN l-consumidor-final = YES.
        
                   RUN esbo/boes505.p PERSISTENT SET h-boes505.
        
                   RUN defineNatOperacao IN h-boes505 (INPUT ped-venda.cod-estabel,
                                                       INPUT ped-venda.cod-emitente,
                                                       INPUT ped-venda.cod-entrega,
                                                       INPUT "",
                                                       INPUT l-consumidor-final,
                                                       OUTPUT c-nat-oper,
                                                       OUTPUT l-return).
                   DELETE PROCEDURE h-boes505.
        
                   IF l-return = YES THEN DO:
                      ASSIGN ped-venda.nat-operacao = c-nat-oper.
                   END.
                   ELSE DO: 
                        for first tt-epc 
                                    where tt-epc.cod-event = pIndEvent
                                      AND tt-epc.cod-parameter = "OBJECT-HANDLE":   
                
                                    if  valid-handle(widget-handle(tt-epc.val-parameter)) then do:
                                        ASSIGN h-bodi159com = WIDGET-HANDLE(tt-epc.val-parameter).  
                                       RUN _insertErrorManual IN h-bodi159com (INPUT 17567,
                                                                               INPUT "EMS",
                                                                               INPUT "ERROR",
                                                                               INPUT "Natureza de operaá∆o n∆o encontrada para este Estabelecimento x Cliente x Comercio/Industria, Verifique com GRUPO.TRIBUTARIO - escdp015",
                                                                               INPUT "Natureza de operaá∆o n∆o encontrada para este Estabelecimento x Cliente x Comercio/Industria, Verifique com GRUPO.TRIBUTARIO - escdp015",
                                                                               INPUT "").

                                       RETURN "NOK":U.
                                    END.
                        END.
                   END.
                   FOR EACH ped-item OF ped-venda EXCLUSIVE-LOCK:
            
                       RUN pi-verifica-se-valida-natureza (INPUT ped-item.nat-operacao, OUTPUT l-valida-natureza).
                       
                       IF l-valida-natureza = YES THEN DO:
                           IF ped-venda.cod-des-merc = 1 THEN
                              ASSIGN l-consumidor-final = NO.
                           ELSE
                              ASSIGN l-consumidor-final = YES.

                           RUN esbo/boes505.p PERSISTENT SET h-boes505.

                           RUN defineNatOperacao IN h-boes505 (INPUT ped-venda.cod-estabel,
                                                               INPUT ped-venda.cod-emitente,
                                                               INPUT ped-venda.cod-entrega,
                                                               INPUT ped-item.it-codigo,
                                                               INPUT l-consumidor-final,
                                                               OUTPUT c-nat-oper,
                                                               OUTPUT l-return).
                           DELETE PROCEDURE h-boes505.

                           IF l-return = YES THEN DO:
                              ASSIGN ped-item.nat-operacao = c-nat-oper.
                           END.
                           ELSE DO: 
                                for first tt-epc 
                                    where tt-epc.cod-event = pIndEvent
                                      AND tt-epc.cod-parameter = "OBJECT-HANDLE":   
                
                                    if  valid-handle(widget-handle(tt-epc.val-parameter)) then do:
                                        ASSIGN h-bodi159com = WIDGET-HANDLE(tt-epc.val-parameter).  
                                        RUN _insertErrorManual IN h-bodi159com (INPUT 17567,
                                                                                INPUT "EMS",
                                                                                INPUT "ERROR",
                                                                                INPUT "Natureza de operaá∆o n∆o encontrada para este Estabelecimento x Cliente x Comercio/Industria, Verifique com GRUPO.TRIBUTARIO - escdp015",
                                                                                INPUT "Natureza de operaá∆o n∆o encontrada para este Estabelecimento x Cliente x Comercio/Industria, Verifique com GRUPO.TRIBUTARIO - escdp015",
                                                                                INPUT "").

                                        RETURN "NOK":U.
                                   END.
                                END.
                           END.
                       END. 

                       IF CAN-FIND(FIRST ped-item-segmentos 
                                   WHERE ped-item-segmentos.nome-abrev          = ped-item.nome-abrev
                                     AND ped-item-segmentos.nr-pedcli           = ped-item.nr-pedcli) THEN DO:

                           ASSIGN de-perc-total = 0.
                           FOR EACH ped-item-segmentos
                               WHERE ped-item-segmentos.nome-abrev          = ped-item.nome-abrev
                                 AND ped-item-segmentos.nr-pedcli           = ped-item.nr-pedcli
                                 AND ped-item-segmentos.nr-sequencia        = ped-item.nr-sequencia
                                 AND ped-item-segmentos.it-codigo           = ped-item.it-codigo NO-LOCK:
                               ASSIGN de-perc-total = de-perc-total + ped-item-segmentos.val-percentual.
                           END.
                           IF de-perc-total <> 100 THEN DO:
                              for first tt-epc 
                                   where tt-epc.cod-event = pIndEvent
                                     AND tt-epc.cod-parameter = "OBJECT-HANDLE":   
    
                                   if  valid-handle(widget-handle(tt-epc.val-parameter)) then do:
                                       ASSIGN h-bodi159com = WIDGET-HANDLE(tt-epc.val-parameter).  
                                       RUN _insertErrorManual IN h-bodi159com (INPUT 17567,
                                                                               INPUT "EMS",
                                                                               INPUT "ERROR",
                                                                               INPUT "Rateio por Segmento n∆o fecha em 100%",
                                                                               INPUT "A somatoria dos percentuais informados por segmento devem fechar em 100%",
                                                                               INPUT "").
    
                                       RETURN "NOK":U.
                                  END.
                               END.
                           END.
                                   
                       END.
                   
                   END.
               END.


                FIND FIRST natur-oper NO-LOCK
                     WHERE natur-oper.nat-operacao = ped-venda.nat-operacao
                     NO-ERROR.
                FIND int-cond-pagto
                     WHERE int-cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag
                     NO-LOCK NO-ERROR.
                IF (AVAIL int-cond-pagto AND
                    int-cond-pagto.transacao-com-cartao = YES) OR
                    (AVAIL natur-oper AND
                    natur-oper.emite-duplic = NO) THEN DO:
                    assign ped-venda.cod-sit-aval = 3 /* Aprovado */
                           ped-venda.desc-bloq-cr = "".
                    for first tt-epc 
                        where tt-epc.cod-event = pIndEvent
                          AND tt-epc.cod-parameter = "OBJECT-HANDLE":   
        
                        if  valid-handle(widget-handle(tt-epc.val-parameter)) then do:
              
                            ASSIGN h-bodi159com = WIDGET-HANDLE(tt-epc.val-parameter).  
               
                            RUN GetRowerrors IN h-bodi159com (OUTPUT table RowErrorsAux).
              
                            run EmptyRowErrors in h-bodi159com.
              
                            for each RowErrorsAux
                                where RowErrorsAux.ErrorSubType = "WARNING":U
                                  AND rowerrorsaux.ErrorNumber = 8259:
                                delete RowErrorsAux.
                            end.
                            FOR EACH RowErrorsAux:
                                RUN _insertErrorManual IN h-bodi159com (INPUT RowErrorsAux.errornumber,
                                                                        INPUT RowErrorsAux.ERRORtype,
                                                                        INPUT RowErrorsAux.ERRORsubtype, 
                                                                        INPUT RowErrorsAux.errordescription,
                                                                        INPUT RowErrorsAux.errorhelp,
                                                                        INPUT "":U).              
                            END.
                        END.
                    end.
                END.
                ELSE DO:
                     FIND cond-pagto
                          WHERE cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag
                           NO-LOCK NO-ERROR.
                     IF AVAIL cond-pagto THEN DO:
                         ASSIGN l-entrou = NO.
                         FIND int-cond-pagto
                              WHERE int-cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag
                              NO-LOCK NO-ERROR.
                         IF  AVAIL int-cond-pagto and
                             substring(int-cond-pagto.char-1,5,1) = "N" OR 
                             substring(int-cond-pagto.char-1,5,1) = "" THEN DO:
                             
                             ASSIGN l-entrou = YES.
                             ASSIGN ped-venda.cod-sit-aval = 1
                                    ped-venda.user-aprov   = ""
                                    ped-venda.quem-aprovou = ""
                                    ped-venda.dt-apr-cred  = ?
                                    ped-venda.desc-bloq-cr = "Condiá∆o de Pagamento N∆o permite liberaá∆o Autom†tica".
                             for first tt-epc 
                                 where tt-epc.cod-event = pIndEvent
                                   AND tt-epc.cod-parameter = "OBJECT-HANDLE":   
    
                                 if  valid-handle(widget-handle(tt-epc.val-parameter)) then do:
    
                                     ASSIGN h-bodi159com = WIDGET-HANDLE(tt-epc.val-parameter).  
    
                                     RUN GetRowerrors IN h-bodi159com (OUTPUT table RowErrorsAux).
    
                                     run EmptyRowErrors in h-bodi159com.
                                     RUN _insertErrorManual IN h-bodi159com (INPUT 0,
                                                                             INPUT "EMS",
                                                                             INPUT "Warning",
                                                                             INPUT "Condiá∆o de Pagamento N∆o permite liberaá∆o de CrÇdito Autom†tica",
                                                                             INPUT "Condiá∆o de Pagamento N∆o permite liberaá∆o de CrÇdito Autom†tica, dia atual superior ao dia parametrizado",
                                                                             INPUT "":U).   
                                 END.
                             end.    
                         END.    
/* Solicitado por Andre para retirar, foi criado parametro na condiá∆o de pagamento se deve avaliar ou n∆o 03/06/2014                                             */
/*                          IF l-entrou = NO THEN DO:                                                                                                             */
/*                              for first ponto-programa                                                                                                   */
/*                                  where ponto-programa.nome-programa = "pd4000"                                                                                 */
/*                                    AND ponto-programa.ponto = 1,                                                                                               */
/*                                   EACH conteudo-programa NO-LOCK                                                                                        */
/*                                  WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:                                                           */
/*                                  IF cond-pagto.num-parcelas >= int(conteudo-programa.conteudo) THEN DO:                                                        */
/*                                                                                                                                                                */
/*                                        ASSIGN ped-venda.cod-sit-aval = 1                                                                                       */
/*                                               ped-venda.user-aprov   = ""                                                                                      */
/*                                               ped-venda.quem-aprovou = ""                                                                                      */
/*                                               ped-venda.dt-apr-cred  = ?                                                                                       */
/*                                               ped-venda.desc-bloq-cr = "Numero de Parcelas N∆o permite liberaá∆o Autom†tica".                                  */
/*                                        for first tt-epc                                                                                                        */
/*                                            where tt-epc.cod-event = pIndEvent                                                                                  */
/*                                              AND tt-epc.cod-parameter = "OBJECT-HANDLE":                                                                       */
/*                                                                                                                                                                */
/*                                            if  valid-handle(widget-handle(tt-epc.val-parameter)) then do:                                                      */
/*                                                                                                                                                                */
/*                                                ASSIGN h-bodi159com = WIDGET-HANDLE(tt-epc.val-parameter).                                                      */
/*                                                                                                                                                                */
/*                                                RUN GetRowerrors IN h-bodi159com (OUTPUT table RowErrorsAux).                                                   */
/*                                                                                                                                                                */
/*                                                run EmptyRowErrors in h-bodi159com.                                                                             */
/*                                                RUN _insertErrorManual IN h-bodi159com (INPUT 0,                                                                */
/*                                                                                        INPUT "EMS",                                                            */
/*                                                                                        INPUT "Warning",                                                        */
/*                                                                                        INPUT "Numero de Parcelas N∆o permite liberaá∆o de CrÇdito Autom†tica", */
/*                                                                                        INPUT "Numero de Parcelas N∆o permite liberaá∆o de CrÇdito Autom†tica", */
/*                                                                                        INPUT "":U).                                                            */
/*                                                                                                                                                                */
/*                                            END.                                                                                                                */
/*                                        end.                                                                                                                    */
/*                                  END.                                                                                                                          */
/*                              END.                                                                                                                              */
/*                         END. */
                     END.
                     ELSE DO:
                           FIND FIRST cond-ped NO-LOCK
                                WHERE cond-ped.nr-pedido    = ped-venda.nr-pedido
                                  AND cond-ped.nr-sequencia = 10 NO-ERROR.

                           IF (ped-venda.origem = 12 AND ped-venda.cod-cond-pag = 0)
                           OR (AVAIL cond-ped AND cond-ped.observacoes BEGINS "Marketplace") THEN DO: /*chamado 150541*/
                               ASSIGN ped-venda.cod-sit-aval       = 3 /** Aprovado **/
                                      ped-venda.desc-bloq-cr       = ''
                                      ped-venda.dsp-pre-fat        = YES 
                                      ped-venda.cod-message-alerta = 0
                                      ped-venda.dt-mensagem        = ?
                                      ped-venda.nome-prog          = ''
                                      ped-venda.dt-apr-cred        = TODAY.
                           END.
                           ELSE DO:
                               ASSIGN ped-venda.cod-sit-aval = 1
                                      ped-venda.user-aprov   = ""
                                      ped-venda.quem-aprovou = ""
                                      ped-venda.dt-apr-cred  = ?
                                      ped-venda.desc-bloq-cr = "Condiá∆o de Pagamento N∆o Encontrado Pedido nao pode ser avaliado".
                               for first tt-epc 
                                   where tt-epc.cod-event = pIndEvent
                                     AND tt-epc.cod-parameter = "OBJECT-HANDLE":   
                              
                                   if  valid-handle(widget-handle(tt-epc.val-parameter)) then do:
                              
                                       ASSIGN h-bodi159com = WIDGET-HANDLE(tt-epc.val-parameter).  
                              
                                       RUN GetRowerrors IN h-bodi159com (OUTPUT table RowErrorsAux).
                              
                                       run EmptyRowErrors in h-bodi159com.
                                       RUN _insertErrorManual IN h-bodi159com (INPUT 0,
                                                                               INPUT "EMS",
                                                                               INPUT "Warning",
                                                                               INPUT "Condiá∆o de Pagamento N∆o permite liberaá∆o de CrÇdito Autom†tica",
                                                                               INPUT "Condiá∆o de Pagamento N∆o permite liberaá∆o de CrÇdito Autom†tica",
                                                                               INPUT "":U).              
                              
                                   END.
                               end.
                           END.
                     END.
                END.

                IF ped-venda.cod-estabel BEGINS "6" THEN DO: //pedidos emitidos pela Decio aprovar automatico cliente intelbras
                    FIND FIRST emitente NO-LOCK
                         WHERE emitente.nome-abrev = ped-venda.nome-abrev NO-ERROR.
                    IF AVAIL emitente THEN DO:
                        FIND FIRST estabelec NO-LOCK
                             WHERE estabelec.cgc = emitente.cgc NO-ERROR.
                        IF AVAIL estabelec THEN DO:
                            ASSIGN ped-venda.cod-sit-aval       = 3 /** Aprovado **/
                                   ped-venda.desc-bloq-cr       = ''
                                   ped-venda.dsp-pre-fat        = YES 
                                   ped-venda.cod-message-alerta = 0
                                   ped-venda.dt-mensagem        = ?
                                   ped-venda.nome-prog          = ''
                                   ped-venda.dt-apr-cred        = TODAY
                                   ped-venda.quem-aprovou       = "Sistema".
                        END.
                    END.
                END.

                //quando for pedido solar, aprova automatico
                FIND FIRST int-item NO-LOCK
                     WHERE int-item.nr-ped-energia = ped-venda.nr-pedcli NO-ERROR.
                IF AVAIL int-item THEN DO:
                   ASSIGN ped-venda.cod-sit-aval       = 3 /** Aprovado **/
                          ped-venda.desc-bloq-cr       = ''
                          ped-venda.dsp-pre-fat        = YES 
                          ped-venda.cod-message-alerta = 0
                          ped-venda.dt-mensagem        = ?
                          ped-venda.nome-prog          = ''
                          ped-venda.dt-apr-cred        = TODAY
                          ped-venda.quem-aprovou       = "Sistema".
                END.

                for first tt-epc 
                    where tt-epc.cod-event = pIndEvent
                      AND tt-epc.cod-parameter = "OBJECT-HANDLE":   

                    if  valid-handle(widget-handle(tt-epc.val-parameter)) then do:
                        ASSIGN h-bodi159com = WIDGET-HANDLE(tt-epc.val-parameter).  

                        FIND FIRST int-emitente 
                             WHERE int-emitente.cod-emitente = ped-venda.cod-emitente NO-LOCK NO-ERROR.
                        FIND natur-oper
                             WHERE natur-oper.nat-operacao = ped-venda.nat-operacao
                             NO-LOCK NO-ERROR.
                        IF NOT AVAIL INT-emitente  THEN DO:
                            RUN _insertErrorManual IN h-bodi159com (INPUT 99999,
                                                                    INPUT "EMS",
                                                                    INPUT "ERROR",
                                                                    INPUT "Extens∆o do Emitente Inexistente",
                                                                    INPUT "Extens∆o do Emitente Inexistente",
                                                                    INPUT "").
                            RETURN.
                        END.
                        ELSE DO:
                            IF int-emitente.id-ativo = NO AND
                               natur-oper.emite-duplic = YES THEN DO:
                                RUN _insertErrorManual IN h-bodi159com (INPUT 99999,
                                                                        INPUT "EMS",
                                                                        INPUT "ERROR",
                                                                        INPUT "Cliente n∆o esta ativo, n∆o Ç possivel efetivar ou completar pedidos",
                                                                        INPUT "Cliente n∆o esta ativo, n∆o Ç possivel efetivar ou completar pedidos",
                                                                        INPUT "").
                                RETURN.
                            END.
                        END.
                        FIND emitente
                             WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-LOCK NO-ERROR.
                        IF AVAIL emitente  THEN DO:
                           RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.
                           RUN pi-trata-endereco IN h-cdapi704 (INPUT  emitente.endereco,
                                                                OUTPUT c-rua, 
                                                                OUTPUT c-nro, 
                                                                OUTPUT c-comp).
                           DELETE PROCEDURE h-cdapi704.
                           IF c-nro = "" THEN DO:
                               RUN _insertErrorManual IN h-bodi159com (INPUT 99999,
                                                                       INPUT "EMS",
                                                                       INPUT "ERROR",
                                                                       INPUT "Cliente com endereáo sem numero, favor informar o numero no endereáo do cliente",
                                                                       INPUT "Cliente com endereáo sem numero, favor informar o numero no endereáo do cliente",
                                                                       INPUT "").
                               RETURN.
                           END.
                        END.
                    END.
                END.

                for first tt-epc 
                    where tt-epc.cod-event = pIndEvent
                      AND tt-epc.cod-parameter = "OBJECT-HANDLE":   

                    if  valid-handle(widget-handle(tt-epc.val-parameter)) then do:
                        ASSIGN h-bodi159com = WIDGET-HANDLE(tt-epc.val-parameter).  

                        ASSIGN c-erro-unid-neg-ped = "".
                        FOR EACH ped-item NO-LOCK OF ped-venda
                           WHERE ped-item.cod-sit-item <> 6:
                            IF NOT CAN-FIND(FIRST unid-neg-ped OF ped-item NO-LOCK) THEN DO:
                                IF c-erro-unid-neg-ped = "" THEN
                                    ASSIGN c-erro-unid-neg-ped = STRING(ped-item.it-codigo).
                                ELSE
                                    ASSIGN c-erro-unid-neg-ped = c-erro-unid-neg-ped + ", " + STRING(ped-item.it-codigo).
                            END.
                        END.

/*                         IF c-erro-unid-neg-ped <> "" THEN DO:                                                                                */
/*                             ASSIGN c-erro-unid-neg-ped = "Unidade de Neg¢cio do Pedido n∆o encontrada para item(s): " + c-erro-unid-neg-ped. */
/*                                                                                                                                              */
/*                             RUN _insertErrorManual IN h-bodi159com (INPUT 99999,                                                             */
/*                                                                     INPUT "EMS",                                                             */
/*                                                                     INPUT "ERROR",                                                           */
/*                                                                     INPUT c-erro-unid-neg-ped,                                               */
/*                                                                     INPUT c-erro-unid-neg-ped,                                               */
/*                                                                     INPUT "").                                                               */
/*                             RETURN.                                                                                                          */
/*                         END.                                                                                                                 */
                    END.
                END.

                /* Incidente 57823
                for first tt-epc 
                    where tt-epc.cod-event = pIndEvent
                      AND tt-epc.cod-parameter = "OBJECT-HANDLE":   

                    FIND FIRST repres
                        WHERE repres.nome-abrev = ped-venda.no-ab-reppri NO-LOCK NO-ERROR.
                    IF AVAIL repres THEN DO:
                        FIND FIRST int-repres
                            WHERE int-repres.cod-repres = repres.cod-rep NO-LOCK NO-ERROR.
                        IF AVAIL int-repres THEN DO:
                            IF substring(int-repres.char-1,3,1) = "n" or
                               substring(int-repres.char-1,3,1) = " " THEN DO:
    
                                RUN _insertErrorManual IN h-bodi159com (INPUT 17567,
                                                                        INPUT "EMS",
                                                                        INPUT "ERROR",
                                                                        INPUT "Representante n∆o est† ativo.",
                                                                        INPUT "Representante n∆o est† ativo no cadastro de representantes.",
                                                                        INPUT "").
                            END.
                        END.
                    END.
                END.
                */

/* Retirado atraves do chamado 48772 - por Eduardo Jose da Silva */
/*                 IF  ped-venda.cod-estabel = "105" /* Manaus */ THEN DO:                                                                                                         */
/*                     FOR FIRST emitente FIELDS(cgc) NO-LOCK                                                                                                                      */
/*                         WHERE emitente.nome-abrev = ped-venda.nome-abrev: END.                                                                                                  */
/*                     IF  AVAIL emitente AND emitente.natureza = 2 /* Pessoa Jur°dica */ THEN DO:                                                                                 */
/*                         FIND FIRST int-emitente-trib NO-LOCK                                                                                                                    */
/*                             WHERE  int-emitente-trib.raiz-cnpj = SUBSTRING(emitente.cgc,1,8) NO-ERROR.                                                                          */
/*                         IF  NOT AVAIL int-emitente-trib OR                                                                                                                      */
/*                             NOT int-emitente-trib.ind-declaracao THEN DO:                                                                                                       */
/*                             FOR FIRST tt-epc NO-LOCK                                                                                                                            */
/*                                 WHERE tt-epc.cod-event     = pIndEvent                                                                                                          */
/*                                 AND   tt-epc.cod-parameter = "OBJECT-HANDLE": END.                                                                                              */
/*                             ASSIGN h-bodi159com = WIDGET-HANDLE(tt-epc.val-parameter).                                                                                          */
/*                                                                                                                                                                                 */
/*                             RUN _insertErrorManual IN h-bodi159com (INPUT 17006,                                                                                                */
/*                                                                     INPUT "EMS",                                                                                                */
/*                                                                     INPUT "ERROR",                                                                                              */
/*                                                                     INPUT "Declaracao de Forma de Tributacao n∆o enviado para Intelbras.",                                      */
/*                                                                     INPUT "Declaracao de Forma de Tributacao n∆o enviado para Intelbras, favor verificar o cadastro ESCDP066.", */
/*                                                                     INPUT "").                                                                                                  */
/*                         END.                                                                                                                                                    */
/*                     END.                                                                                                                                                        */
/*                 END.                                                                                                                                                            */

            END. /*FOR FIRST ped-venda EXCLUSIVE-LOCK*/
        END. /*IF AVAIL tt-epc THEN DO:*/
    END.  /*  beforecompleteorder */

    WHEN "afterCompleteOrder"  /* Ap¢s efetivacao envia pedido/itens para o CRM */  THEN DO:
            
        {esp/crm/escrm001a.i1}
        
        FOR first  tt-epc WHERE 
                   tt-epc.cod-event     = pIndEvent AND   
                   tt-epc.cod-parameter = "Table-Rowid": END.

        ASSIGN c-mensagem-html = "".

        IF AVAIL tt-epc THEN DO:
           FOR FIRST ped-venda NO-LOCK WHERE 
               ROWID(ped-venda) = TO-ROWID(tt-epc.val-parameter):

               IF ped-venda.cod-priori <> 44 AND
                  CAN-FIND (FIRST int-emitente
                            WHERE int-emitente.cod-emitente = ped-venda.cod-emitente
                              AND int-emitente.ind-participa-canais = 993520001) THEN DO:

                   IF  PROGRAM-NAME(1)  MATCHES "*msg0093*" OR
                       PROGRAM-NAME(2)  MATCHES "*msg0093*" OR
                       PROGRAM-NAME(3)  MATCHES "*msg0093*" OR
                       PROGRAM-NAME(4)  MATCHES "*msg0093*" OR
                       PROGRAM-NAME(5)  MATCHES "*msg0093*" OR
                       PROGRAM-NAME(6)  MATCHES "*msg0093*" OR
                       PROGRAM-NAME(7)  MATCHES "*msg0093*" OR
                       PROGRAM-NAME(8)  MATCHES "*msg0093*" OR
                       PROGRAM-NAME(9)  MATCHES "*msg0093*" OR
                       PROGRAM-NAME(10) MATCHES "*msg0093*" OR
                       PROGRAM-NAME(11) MATCHES "*msg0093*" THEN DO:

                   END.
                   ELSE DO:

                       /*
                       IF opsys <> 'WIN32' THEN DO:
                           log-manager:write-message("UPC ENVIANDO MSG0091 PROGRAM-NAME(1)  " + PROGRAM-NAME(1) ).
                           log-manager:write-message("UPC ENVIANDO MSG0091 PROGRAM-NAME(2)  " + PROGRAM-NAME(2) ).
                           log-manager:write-message("UPC ENVIANDO MSG0091 PROGRAM-NAME(3)  " + PROGRAM-NAME(3) ).
                           log-manager:write-message("UPC ENVIANDO MSG0091 PROGRAM-NAME(4)  " + PROGRAM-NAME(4) ).
                           log-manager:write-message("UPC ENVIANDO MSG0091 PROGRAM-NAME(5)  " + PROGRAM-NAME(5) ).
                           log-manager:write-message("UPC ENVIANDO MSG0091 PROGRAM-NAME(6)  " + PROGRAM-NAME(6) ).
                           log-manager:write-message("UPC ENVIANDO MSG0091 PROGRAM-NAME(7)  " + PROGRAM-NAME(7) ).
                           log-manager:write-message("UPC ENVIANDO MSG0091 PROGRAM-NAME(8)  " + PROGRAM-NAME(8) ).
                           log-manager:write-message("UPC ENVIANDO MSG0091 PROGRAM-NAME(9)  " + PROGRAM-NAME(9) ).
                           log-manager:write-message("UPC ENVIANDO MSG0091 PROGRAM-NAME(10) " + PROGRAM-NAME(10)).
                           log-manager:write-message("UPC ENVIANDO MSG0091 PROGRAM-NAME(11) " + PROGRAM-NAME(11)).
                           log-manager:write-message("UPC ENVIANDO MSG0091 " + ped-venda.nr-pedcli + " - " + string(ped-venda.cod-priori) + " | " + string(ped-venda.cod-sit-ped) +  string(ped-venda.cod-sit-aval)).
                       END. /* IF opsys <> 'WIN32' THEN DO: */
                       */

                       RUN esp/es0018p.p (INPUT "msg0091", /* Nome do programa */
                                          INPUT 1,         /* Ponto do programa */
                                          INPUT 0,
                                          INPUT "",
                                          OUTPUT TABLE tt-prog-ponto) NO-ERROR.

                       FIND FIRST tt-prog-ponto 
                            WHERE tt-prog-ponto.conteudo = "online" NO-ERROR.

                       IF AVAIL tt-prog-ponto THEN DO:
                           RAW-TRANSFER ped-venda TO raw-param.
                           RUN esp/esb/esesb003.p (INPUT        "msg0091", /* Nome Mensagem */  
                                                   INPUT        raw-param, /* Tupla do registro */
                                                   OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.
                       END.
                   END.
                   
               END.

               /// Decio aprovar automatico cliente intelbras
               ASSIGN l-pedido-empresa-grupo = NO.
               FIND FIRST emitente NO-LOCK
                    WHERE emitente.nome-abrev = ped-venda.nome-abrev NO-ERROR.
               IF AVAIL emitente THEN DO:
                   FIND FIRST estabelec NO-LOCK
                        WHERE estabelec.cgc = emitente.cgc NO-ERROR.
                   IF AVAIL estabelec THEN DO:
                       ASSIGN ped-venda.cod-sit-aval       = 3 /** Aprovado **/
                              ped-venda.desc-bloq-cr       = ''
                              ped-venda.dsp-pre-fat        = YES 
                              ped-venda.cod-message-alerta = 0
                              ped-venda.dt-mensagem        = ?
                              ped-venda.nome-prog          = ''
                              ped-venda.dt-apr-cred        = TODAY
                              ped-venda.quem-aprovou       = "Sistema".

                       ASSIGN l-pedido-empresa-grupo = YES.
                   END.
               END. 
                  
                 
               RUN esp/es0018p.p (INPUT "bodi159com", /* Nome do programa */
                                  INPUT 1,         /* Ponto do programa */
                                  INPUT 0,
                                  INPUT "",
                                  OUTPUT TABLE tt-prog-ponto-nat) NO-ERROR.
               
               FIND FIRST tt-prog-ponto-nat
                    WHERE tt-prog-ponto-nat.conteudo = ped-venda.nat-oper NO-ERROR.
               IF AVAIL tt-prog-ponto-nat THEN DO:
               
                   ASSIGN ped-venda.cod-sit-aval       = 3 /** Aprovado **/
                          ped-venda.desc-bloq-cr       = ''
                          ped-venda.dsp-pre-fat        = YES 
                          ped-venda.cod-message-alerta = 0
                          ped-venda.dt-mensagem        = ?
                          ped-venda.nome-prog          = ''
                          ped-venda.dt-apr-cred        = TODAY
                          ped-venda.quem-aprovou       = "Sistema".
               END.
               FIND CURRENT ped-venda NO-LOCK NO-ERROR.
               

               /* Chamado 13783 (De no-lock para exclusive-lock) */
               FOR EACH ped-item OF ped-venda EXCLUSIVE-LOCK:

                   FIND FIRST natur-oper NO-LOCK
                       WHERE natur-oper.nat-operacao = ped-item.nat-operacao NO-ERROR.

                   FIND FIRST int-natur-oper NO-LOCK
                       WHERE  int-natur-oper.nat-operacao = natur-oper.nat-operacao NO-ERROR.
                    
                   IF AVAIL natur-oper
                        AND natur-oper.emite-duplic = NO  
                        AND int-natur-oper.contab-unid-neg  = NO
                        AND NOT CAN-FIND (FIRST int-unid-neg-natur
                                          WHERE int-unid-neg-natur.cod-estabel    = ped-venda.cod-estabel
                                            AND int-unid-neg-natur.nat-operacao   = ped-item.nat-operacao
                                            AND int-unid-neg-natur.cod-unid-negoc = ped-item.cod-unid-negoc) THEN DO:
                       
                       FOR FIRST unid-neg-canal-venda NO-LOCK
                           WHERE unid-neg-canal-venda.cod-canal-venda = ped-venda.cod-canal-venda:

                       FIND FIRST unid_negoc NO-LOCK
                           WHERE unid_negoc.cdn_unid_negoc = unid-neg-canal-venda.cdn_unid_negoc NO-ERROR.

                           ASSIGN ped-item.cod-unid-neg = unid_negoc.cod_unid_negoc.
                       END.

                   END.
                   /* Projeto Aprovaá∆o de pedidos abaixo do m°nimo */
                   IF ped-item.cod-sit-item < 3 THEN
                      RUN pi-aprova-abaixo-minimo.
                   /************************************************/

               END.
             
                RUN esp/crm/escrm001api.p PERSISTENT SET h-escrm001api.
                
                empty temp-table tt-param-mov.
                create tt-param-mov.
                assign tt-param-mov.prog-orig       = "wdi159-com"
                       tt-param-mov.action          = "W"  
                       tt-param-mov.tabela-pai      = "salesorder"   
                       tt-param-mov.rw-tabela-pai   = rowid(ped-venda)
                       tt-param-mov.tabela-filho    = "salesorderdetail"
                       tt-param-mov.rw-tabela-filho = ?.        
                      
                RUN piCarregaPedido IN h-escrm001api (input-output TABLE tt-param-mov,
                                                      INPUT  TABLE tt-raw-transfer, 
                                                      output TABLE RowErrors).  
                
                IF  VALID-HANDLE(h-escrm001api) THEN
                    DELETE OBJECT h-escrm001api.

                IF AVAIL ped-venda THEN DO:
                    /*Integraá∆o DEPS*/
                    CREATE tt-pedido-integra.
                    ASSIGN tt-pedido-integra.r-rowid = ROWID(ped-venda)
                           tt-pedido-integra.i-origem-inegr = 1.
                    
                    RAW-TRANSFER tt-pedido-integra TO raw-param.
                    
                    ASSIGN v_log_nat_deps = YES.

                    IF  ped-venda.cod-cond-pag = 0
                    AND (ped-venda.tp-pedido   = "94" 
                     OR  ped-venda.tp-pedido   = "97")
                     OR l-pedido-empresa-grupo = YES  THEN
                        ASSIGN v_log_nat_deps = NO.
                    ELSE DO:
                        EMPTY TEMP-TABLE tt-prog-ponto.
                        RUN esp/es0018p.p (INPUT "dps-nat-oper", /* Nome do programa */
                                           INPUT 1,             /* Ponto do programa */
                                           INPUT 0,
                                           INPUT "",
                                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.
                
                        IF  CAN-FIND (FIRST tt-prog-ponto
                                         WHERE tt-prog-ponto.conteudo = string(ped-venda.nat-operacao)) THEN
                            ASSIGN v_log_nat_deps = NO.
                    END.

                    FIND FIRST int-emitente NO-LOCK
                         WHERE int-emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.
            
                    IF  AVAIL int-emitente THEN DO:
                        EMPTY TEMP-TABLE tt-prog-ponto.
                        RUN esp/es0018p.p (INPUT "dps-canal-vd", /* Nome do programa */
                                           INPUT 1,              /* Ponto do programa */
                                           INPUT 0,
                                           INPUT "",
                                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    
                        IF  CAN-FIND (FIRST tt-prog-ponto
                                         WHERE tt-prog-ponto.conteudo = string(int-emitente.cod-gr-cob)) THEN DO:
    
                            IF  v_log_nat_deps = YES /* garantia */ THEN DO:
                                RUN esp/trgw/wes727a.p (INPUT raw-param,
                                                        INPUT 'msg0310').
                            END.
                        END.
                    END.

                    FIND FIRST int-ped-venda2 EXCLUSIVE-LOCK
                         WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
                         AND   int-ped-venda2.nr-pedido   = ped-venda.nr-pedido NO-ERROR.

                    IF  AVAIL int-ped-venda2 THEN
                        ASSIGN int-ped-venda2.char-3 = v_cod_categ
                               int-ped-venda2.dec-1  = v_val_dec_1.

                END.
           END. 

           IF ped-venda.cod-sit-aval = 3 AND ped-venda.origem = 12 THEN DO:
               for first tt-epc 
                   where tt-epc.cod-event = pIndEvent
                     AND tt-epc.cod-parameter = "OBJECT-HANDLE":   

                   if  valid-handle(widget-handle(tt-epc.val-parameter)) then do:
                   
                        ASSIGN h-bodi159com = WIDGET-HANDLE(tt-epc.val-parameter).  
                   
                        RUN GetRowerrors IN h-bodi159com (OUTPUT table RowErrorsAux).
                   
                        run EmptyRowErrors in h-bodi159com.
                            
                        for each RowErrorsAux
                            where RowErrorsAux.ErrorSubType = "WARNING":U
                              AND rowerrorsaux.ErrorNumber = 8259:
                            delete RowErrorsAux.
                        end.
                    END.
               END.
           END.

           /* Envia email para atendente, caso existam itens abaixo do valor m°nimo de tabela */
           IF  trim(c-mensagem-html) <> "" THEN
               RUN pi-envia-email-atendente.

           //RUN pi-integra-salesforce.
        END.      

    END. /* afterCompleteOrder */

END CASE.

PROCEDURE pi-verifica-se-valida-natureza:
    DEF INPUT  PARAMETER c-natureza AS CHARACTER.
    DEF OUTPUT PARAMETER l-valida AS LOGICAL.

    ASSIGN l-valida = YES.
    IF c-natureza <> "" THEN DO:
        FIND emitente
             WHERE emitente.cod-emitente = ped-venda.cod-emitente
             NO-LOCK NO-ERROR.
             
        FIND natur-oper
            WHERE natur-oper.nat-operacao = c-natureza NO-LOCK NO-ERROR.
        IF AVAIL emitente and emitente.natureza = 4 THEN 
           ASSIGN l-valida = NO.
        ELSE
           IF AVAIL natur-oper THEN 
                IF  natur-oper.cod-mensagem    = 11  OR
                    natur-oper.cod-mensagem    = 31  OR
                    natur-oper.cod-mensagem    = 70  OR
                    natur-oper.cod-mensagem    = 83  OR
                    natur-oper.cod-mensagem    = 120 OR
                    natur-oper.cod-mensagem    = 816 OR
                    natur-oper.cod-mensagem    = 819 OR
                    natur-oper.cod-mensagem    = 834 OR
                    natur-oper.cod-mensagem    = 906 OR
                    natur-oper.log-oper-triang = YES OR
                    natur-oper.nat-operacao BEGINS "8" OR
                    natur-oper.tipo = 3 THEN /* Venda de ativo imobilizado */
                    ASSIGN l-valida = NO.
                ELSE
                   IF natur-oper.emite-duplic = YES THEN 
                      ASSIGN l-valida = YES.
                   ELSE
                      ASSIGN l-valida = NO.
            ELSE
                ASSIGN l-valida = YES.
    END.
    ELSE
        ASSIGN l-valida = YES.

    
    IF ped-venda.cod-estabel = "105" THEN DO: 
        FIND emitente
            WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-LOCK NO-ERROR.
              
        IF AVAIL emitente AND emitente.estado <> "RS" THEN DO: //entreposto M2107-068
         RUN esp/es0018p.p (INPUT "espdp079",
                            INPUT 2,
                            INPUT 0,
                            INPUT "", 
                            OUTPUT TABLE tt-prog-ponto).

         IF CAN-FIND (FIRST tt-prog-ponto
                      WHERE tt-prog-ponto.conteudo = c-natureza)  THEN
             ASSIGN l-valida = NO.

        END.
    END.
     IF ped-venda.cod-estabel BEGINS "6" THEN DO: //Natureza Decio
         RUN esp/es0018p.p (INPUT "espdp079",
                            INPUT 4,
                            INPUT 0,
                            INPUT "", 
                            OUTPUT TABLE tt-prog-ponto).

         IF CAN-FIND (FIRST tt-prog-ponto
                      WHERE tt-prog-ponto.conteudo = c-natureza)  THEN
             ASSIGN l-valida = NO.

     END.

     //nao validar natureza qndo atualiza pedido pelo espdp012
      IF PROGRAM-NAME(1)  MATCHES "*espdp012*" OR
         PROGRAM-NAME(2)  MATCHES "*espdp012*" OR
         PROGRAM-NAME(3)  MATCHES "*espdp012*" OR
         PROGRAM-NAME(4)  MATCHES "*espdp012*" OR
         PROGRAM-NAME(5)  MATCHES "*espdp012*" OR
         PROGRAM-NAME(6)  MATCHES "*espdp012*" OR
         PROGRAM-NAME(7)  MATCHES "*espdp012*" OR
         PROGRAM-NAME(8)  MATCHES "*espdp012*" OR
         PROGRAM-NAME(9)  MATCHES "*espdp012*" OR
         PROGRAM-NAME(10) MATCHES "*espdp012*" OR
         PROGRAM-NAME(11) MATCHES "*espdp012*"  THEN 
            ASSIGN l-valida = NO.

    

END PROCEDURE.


/* PROCEDURE CreateUnidNeg.                                                                             */
/*     FIND FIRST item-uni-estab                                                                        */
/*         WHERE item-uni-estab.cod-estabel = ped-venda.cod-estabel                                     */
/*           AND item-uni-estab.it-codigo   = ped-item.it-codigo                                        */
/*         NO-LOCK NO-ERROR.                                                                            */
/*     if  ped-item.ind-componen <> 3 /* diferente de componente */                                     */
/*         and AVAIL para-dis AND para-dis.log-unid-neg                                                 */
/*         and not can-find(first unid-neg-ped                                                          */
/*                          where unid-neg-ped.nome-abrev   = ped-item.nome-abrev                       */
/*                          and   unid-neg-ped.nr-pedcli    = ped-item.nr-pedcli                        */
/*                          and   unid-neg-ped.nr-sequencia = ped-item.nr-sequencia                     */
/*                          and   unid-neg-ped.it-codigo    = ped-item.it-codigo                        */
/*                          and   unid-neg-ped.cod-refer    = ped-item.cod-refer                        */
/*                          AND   unid-neg-ped.cod_unid_negoc = item-uni-estab.cod-unid-negoc) then do: */
/*                                                                                                      */
/*                                                                                                      */
/*                                                                                                      */
/*         IF AVAIL item-uni-estab THEN DO:                                                             */
/*             create unid-neg-ped.                                                                     */
/*             assign unid-neg-ped.nome-abrev     = ped-item.nome-abrev                                 */
/*                    unid-neg-ped.nr-pedcli      = ped-item.nr-pedcli                                  */
/*                    unid-neg-ped.nr-sequencia   = ped-item.nr-sequencia                               */
/*                    unid-neg-ped.it-codigo      = ped-item.it-codigo                                  */
/*                    unid-neg-ped.cod-refer      = ped-item.cod-refer                                  */
/*                    unid-neg-ped.cod_unid_negoc = item-uni-estab.cod-unid-negoc                       */
/*                    unid-neg-ped.perc-unid-neg  = 100.                                                */
/*         END.                                                                                         */
/*                                                                                                      */
/*     end.                                                                                             */
/* END PROCEDURE.                                                                                       */

PROCEDURE pi-aprova-abaixo-minimo:

    FIND FIRST atendente NO-LOCK
        WHERE atendente.cd-oper = int(ped-venda.tp-pedido) NO-ERROR.

    IF NOT AVAIL atendente
    OR (AVAIL atendente AND trim(atendente.aprovador) = "") 
    OR ped-venda.cod-priori = 44 THEN /* Oráamento */
        RETURN "OK".

    ASSIGN de-preco = 0.
    RUN esp/pdp/espdp071.p (INPUT ped-venda.cod-estabel,
                            INPUT ped-item.nome-abrev,
                            INPUT ped-item.nr-pedcli,
                            INPUT ped-item.nr-sequencia,
                            INPUT ped-item.it-codigo,
                            INPUT ped-item.qt-pedida,
                            INPUT ped-item.nat-operacao,
                            OUTPUT de-preco).

    ASSIGN de-liquido = ped-item.vl-preori.

    RUN esp/pdp/espdp074.p (INPUT ped-venda.nome-abrev,
                            INPUT ped-venda.nr-pedcli,   
                            INPUT ped-item.nr-sequencia,
                            INPUT ped-item.it-codigo,   
                            INPUT ped-item.cod-refer,   
                            INPUT NO,
                            INPUT "", 
                            INPUT-OUTPUT de-liquido). /* preori sem os descontos - l°quido */
    /************ VERIFICA SE O PREÄO COM ICMS E DESCONTE DE ICMS, ê MENOR QUE O PREÄO M÷NIMO DA TABELA **********/
    IF  (de-liquido < de-preco OR de-preco = 0) THEN DO:

        FOR FIRST int-ped-item FIELDS (ult-preco-aprov) NO-lock
            WHERE int-ped-item.nome-abrev        = ped-item.nome-abrev
              AND int-ped-item.nr-pedcli         = ped-item.nr-pedcli
              AND int-ped-item.nr-sequencia      = ped-item.nr-sequencia
              AND int-ped-item.it-codigo         = ped-item.it-codigo
              AND int-ped-item.cod-refer         = ped-item.cod-refer
              AND int-ped-item.ind-status-preco  = 2: /*Aprovado*/
            
              IF  de-liquido <> int-ped-item.ult-preco-aprov AND de-liquido < de-preco
              OR int-ped-item.ult-preco-aprov = 0 
              THEN DO:
                  RUN pi-bloqueia-item.
                  RETURN "OK".
              END.
        END.
        RUN pi-bloqueia-item.

    END.
    ELSE DO TRANS:
    
        /* Verifica se o pr¢prio usu†rio j† corrigiu o preáo e confirmou o pedido */
        FOR FIRST int-ped-item EXCLUSIVE-LOCK
            WHERE int-ped-item.nome-abrev        = ped-item.nome-abrev
              AND int-ped-item.nr-pedcli         = ped-item.nr-pedcli
              AND int-ped-item.nr-sequencia      = ped-item.nr-sequencia
              AND int-ped-item.it-codigo         = ped-item.it-codigo
              AND int-ped-item.cod-refer         = ped-item.cod-refer:

              /* Passa o status do item para APROVADO */
              IF  int-ped-item.ind-status-preco = 1 OR int-ped-item.ind-status-preco = 3 THEN
                  ASSIGN int-ped-item.ind-status-preco = 2
                         int-ped-item.data-aprovacao   = TODAY
                         int-ped-item.motivo-aprovacao = int-ped-item.motivo-aprovacao + " | " + "Usu†rio " + c-seg-usuario + " alterou o valor do item para R$ " + trim(STRING(de-liquido, ">>>,>>>,>>9.99999")).
                         int-ped-item.cod-aprovador    = trim(atendente.aprovador).  

        END.
    END.
END.

PROCEDURE pi-bloqueia-item:

    DO TRANS:

        FIND FIRST int-ped-item NO-LOCK 
            WHERE int-ped-item.nome-abrev   = ped-item.nome-abrev
              AND int-ped-item.nr-pedcli    = ped-item.nr-pedcli
              AND int-ped-item.nr-sequencia = ped-item.nr-sequencia
              AND int-ped-item.it-codigo    = ped-item.it-codigo
              AND int-ped-item.cod-refer    = ped-item.cod-refer NO-ERROR.

        IF  NOT AVAIL int-ped-item THEN DO:
            /* esse c¢digo Ç para quando vem o pedido do CRM, e a int-ped-item n∆o est† dispon°vel */
            CREATE int-ped-item.
            ASSIGN int-ped-item.nome-abrev   = ped-item.nome-abrev     
                   int-ped-item.nr-pedcli    = ped-item.nr-pedcli      
                   int-ped-item.nr-sequencia = ped-item.nr-sequencia   
                   int-ped-item.it-codigo    = ped-item.it-codigo      
                   int-ped-item.cod-refer    = ped-item.cod-refer
                   int-ped-item.ind-status-preco = 1. 
             RELEASE int-ped-item.
        END.

        FOR FIRST int-ped-item EXCLUSIVE-LOCK
            WHERE int-ped-item.nome-abrev   = ped-item.nome-abrev
              AND int-ped-item.nr-pedcli    = ped-item.nr-pedcli
              AND int-ped-item.nr-sequencia = ped-item.nr-sequencia
              AND int-ped-item.it-codigo    = ped-item.it-codigo
              AND int-ped-item.cod-refer    = ped-item.cod-refer
              ,FIRST ITEM WHERE ITEM.it-codigo = ped-item.it-codigo NO-LOCK :

            FIND FIRST ped-venda NO-LOCK 
                WHERE ped-venda.nr-pedcli = int-ped-item.nr-pedcli
                  AND ped-venda.nome-abrev = int-ped-item.nome-abrev NO-ERROR.

            FIND FIRST mot-aprov-auto-ped NO-LOCK 
                WHERE mot-aprov-auto-ped.cod-emitente = ped-venda.cod-emitente
                  AND mot-aprov-auto-ped.atendente    = int(ped-venda.tp-pedido) NO-ERROR.
            IF AVAIL mot-aprov-auto-ped THEN DO:
                
                    ASSIGN int-ped-item.ind-status-preco   = 2 /* APROVADO */
                           int-ped-item.data-aprovacao     = TODAY
                           int-ped-item.motivo-aprovacao   = int-ped-item.motivo-aprovacao + " | " + mot-aprov-auto-ped.c-motivo
                           int-ped-item.cod-aprovador      = trim(atendente.aprovador)
                           int-ped-item.ult-preco-aprov    = ped-item.vl-preori.
            END.
            ELSE DO:

                ASSIGN int-ped-item.ind-status-preco = 1  /* BLOQUEADO */
                       int-ped-item.preco-tabela     = de-preco
                       int-ped-item.data-aprovacao   = ?
                       int-ped-item.cod-aprovador    = trim(atendente.aprovador).

                       c-mensagem-html = c-mensagem-html + "<TR>" +
                                      "<TD>" + STRING(ped-item.it-codigo                       , "x(16)")             + "</TD>" +
                                      "<TD>" + STRING(ITEM.desc-item                           , "x(45)")             + "</TD>" +
                                      "<TD>" + STRING(ped-item.qt-pedida - ped-item.qt-atendida, ">>>>,>>9")      + "</TD>" +
                                      "<TD>" + STRING(de-liquido                               , ">>>,>>>,>>9.99") + "</TD>" +
                                      "<TD>" + STRING(de-preco                                 , ">>>,>>>,>>9.99") + "</TD>" +
                                      "</TR>".
            END.
              
        END.
    END.

END.


PROCEDURE pi-envia-email-atendente:

     DEF VAR h-utapi019 AS HANDLE NO-UNDO.
    
    def var l-producao   AS LOG NO-UNDO.

    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT "ambiente":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FIND FIRST tt-prog-ponto NO-ERROR.

    IF AVAILABLE tt-prog-ponto               AND
       tt-prog-ponto.conteudo = "PRODUCAO":U THEN
        ASSIGN l-producao = YES.
    ELSE
        ASSIGN l-producao = NO.

     EMPTY TEMP-TABLE tt-envio2.
     EMPTY TEMP-TABLE tt-mensagem1.
     EMPTY TEMP-TABLE tt-erros.

     FIND FIRST usuar_mestre NO-LOCK
         WHERE usuar_mestre.cod_usuario = trim(atendente.aprovador) NO-ERROR.
     FIND FIRST param-global NO-LOCK NO-ERROR.

     DEF VAR c-mensagem-Atendente AS CHAR NO-UNDO.
     DEF VAR c-mensagem-Aprovador AS CHAR NO-UNDO.
     
     FOR FIRST emitente FIELDS(cod-emitente nome-emit) NO-LOCK
         WHERE emitente.nome-abrev = ped-venda.nome-abrev:
     END.
     
     /********************************************************** MENSAGEM PARA O APROVADOR *****************************************************************/
     FOR FIRST repres FIELDS (nome) NO-LOCK
         WHERE repres.nome-abrev = ped-venda.no-ab-reppri: END.

     ASSIGN c-mensagem-Aprovador = "<html>Prezado, " + "<BR>" + "<BR>" +
                                   "    Abaixo Pedido que possui itens com Preáo abaixo do M°nimo, " +
                                   "favor efetuar a aprovaá∆o ou reprovaá∆o clicando no link abaixo:" + "<BR>" + "<BR>" +
                                   "PEDIDO: " + STRING(ped-venda.nr-pedcli) 
                                    + " -  Implant: " + STRING(ped-venda.dt-implant, "99/99/9999")  
                                    + " -  Entrega: " + STRING(ped-venda.dt-entrega, "99/99/9999") +   "<BR>" + "<BR>" +
                                   
                                   "CLIENTE: " + string(emitente.cod-emitente) + " - " + emitente.nome-emit + "<BR>" + "<BR>" +
                                   "REPRESENTANTE: " + ped-venda.no-ab-reppri + "<BR>" + "<BR>" +
                                   "OBSERVAÄÂES: " + ped-venda.observacoes + "<BR>" + "<BR>" +
                                   "ATENDENTE: " + atendente.nm-oper + "<BR>" + "<BR>".

     ASSIGN c-mensagem-Aprovador =  c-mensagem-Aprovador + '<table border=~'1~'>' +
                                    '<TR>' + '<TH>Produto</TH>'          +
                                             '<TH>Descriá∆o</TH>'        +
                                             '<TH>Saldo</TH>'            +   
                                             '<TH>Preáo Negociado</TH>'  +   
                                             '<TH>Preáo M°nimo</TH>'     +   
                                     '</TR>'                             +
                                      c-mensagem-html                    +  
                                     '</table>'   +
                                    '<BR>' + '<BR>' + 
                                    'Acesse o link para Aprovar/Reprovar os itens: ' +
                                    (IF  l-producao THEN
                                        '<a href="http://corporativo.intelbras.com.br/B2BSharepoint/PedidoMinimo.aspx?ID='
                                    ELSE
                                        '<a href="http://sjo-sp-01:5050/B2BSharepoint/PedidoMinimo.aspx?ID=') + STRING(ped-venda.nr-pedido) + '">Aprovar/Reprovar Pedidos</a>' +
                                    '<BR>' + '<BR>' + 'Atenciosamente,' + '</html>' .

     RUN utp/utapi019.p PERSISTENT SET h-utapi019.

     IF  AVAIL usuar_mestre THEN DO:
         
         create tt-envio2.
         assign tt-envio2.versao-integracao = 1
                tt-envio2.servidor          = param-global.serv-mail
                tt-envio2.porta             = param-global.porta-mail
                tt-envio2.remetente         = "EMS@intelbras.com.br"
                tt-envio2.destino           = usuar_mestre.cod_e_mail_local
                tt-envio2.assunto           = "Pedido com itens abaixo do valor m°nimo"
                tt-envio2.formato           = "HTML"
                tt-envio2.exchange          = NO.
  
         CREATE tt-mensagem1.
         ASSIGN tt-mensagem1.seq-mensagem = 1
                tt-mensagem1.mensagem = c-mensagem-Aprovador.

         RUN pi-execute2 IN h-utapi019 (INPUT TABLE tt-envio2,
                                        INPUT TABLE tt-mensagem1,
                                        OUTPUT TABLE tt-erros).

         if  return-value = "NOK" 
         AND AVAIL tt-erros then do:

             for first tt-epc 
                 where tt-epc.cod-event = pIndEvent
                   AND tt-epc.cod-parameter = "OBJECT-HANDLE":   

                 if  valid-handle(widget-handle(tt-epc.val-parameter)) then do:
                     ASSIGN h-bodi159com = WIDGET-HANDLE(tt-epc.val-parameter).  
                     RUN _insertErrorManual IN h-bodi159com (INPUT 99999,
                                                             INPUT "EMS",
                                                             INPUT "ERROR",
                                                             INPUT "Erro na rotina de geraá∆o autom†tica de email com itens abaixo do preáo m°nimo para Atendente",
                                                             INPUT "",
                                                             INPUT "").
                     RETURN "OK".
                 END.
             END.
         END.
     END.


    
     /********************************************************** MENSAGEM PARA O ATENDENTE *****************************************************************/
     EMPTY TEMP-TABLE tt-envio2.
     EMPTY TEMP-TABLE tt-mensagem1.
     EMPTY TEMP-TABLE tt-erros.

     FOR FIRST repres FIELDS (nome) NO-LOCK
         WHERE repres.nome-abrev = ped-venda.no-ab-reppri: END.

     ASSIGN c-mensagem-Atendente = "<html>Prezado, " + "<BR>" + "<BR>" +
                                   "    Abaixo para seu conhecimento, segue Pedido que possui Itens com Preáo Abaixo do M°nimo:" + "<BR>" + "<BR>" +
                                   "PEDIDO: " + STRING(ped-venda.nr-pedcli) + "<BR>" + 
                                   "CLIENTE: " + string(emitente.cod-emitente) + " - " + emitente.nome-emit + "<BR>" + 
                                   "REPRESENTANTE: " + ped-venda.no-ab-reppri + "<BR>" + "<BR>" +
                                   "Aprovador: " + usuar_mestre.nom_usuario + "<BR>" + "<BR>".

     ASSIGN c-mensagem-Atendente = c-mensagem-Atendente + '<table border=~'1~'>' +
                                    '<TR>' + '<TH>Produto</TH>'          +
                                             '<TH>Descriá∆o</TH>'        +
                                             '<TH>Saldo</TH>'            +   
                                             '<TH>Preáo Negociado</TH>'  +   
                                             '<TH>Preáo M°nimo</TH>'     +   
                                     '</TR>'                             +
                                      c-mensagem-html                    +  
                                     '</table>'   +
                                    '<BR>' + '<BR>' + 'Atenciosamente,' + '</html>'.

     create tt-envio2.
     assign tt-envio2.versao-integracao = 1
            tt-envio2.servidor          = param-global.serv-mail
            tt-envio2.porta             = param-global.porta-mail
            tt-envio2.remetente         = "EMS@intelbras.com.br"
            tt-envio2.destino           = atendente.email
            tt-envio2.assunto           = "Pedido com itens abaixo do valor m°nimo"
            tt-envio2.formato           = "HTML"
            tt-envio2.exchange          = NO.

     CREATE tt-mensagem1.
     ASSIGN tt-mensagem1.seq-mensagem = 1
            tt-mensagem1.mensagem = c-mensagem-Atendente.

     RUN pi-execute2 IN h-utapi019 (INPUT TABLE tt-envio2,
                                    INPUT TABLE tt-mensagem1,
                                    OUTPUT TABLE tt-erros).

     if  return-value = "NOK" 
     AND AVAIL tt-erros then do:

         for first tt-epc 
             where tt-epc.cod-event = pIndEvent
               AND tt-epc.cod-parameter = "OBJECT-HANDLE":   

             if  valid-handle(widget-handle(tt-epc.val-parameter)) then do:
                 ASSIGN h-bodi159com = WIDGET-HANDLE(tt-epc.val-parameter).  
                 RUN _insertErrorManual IN h-bodi159com (INPUT 99999,
                                                         INPUT "EMS",
                                                         INPUT "ERROR",
                                                         INPUT "Erro na rotina de geraá∆o autom†tica de email com itens abaixo do preáo m°nimo para Atendente",
                                                         INPUT "",
                                                         INPUT "").
             END.
         END.
     END.

     DELETE PROCEDURE h-utapi019.
END.


/*procedure pi-integra-salesforce:
  
  empty temp-table tt-sf-ped-venda.
  empty temp-table tt-sf-ped-item.

  create tt-sf-ped-venda.
  buffer-copy ped-venda to tt-sf-ped-venda.

  for each ped-item of ped-venda no-lock:
    create tt-sf-ped-item.
    buffer-copy ped-item to tt-sf-ped-item.
  end.
  run esp/wso/eswso0011.p(input table tt-sf-ped-venda,
                          input table tt-sf-ped-item).
end procedure.
*/
