DEFINE BUFFER empresa FOR mgcad.empresa.

{cdp/cdcfgman.i}
{method/dbotterr.i}
{utp/ut-glob.i}
{cpp/cpapi301.i} 
{cdp/cd0666.i}
{esp/es0018.i}
{utp/utapi019.i}

DEFINE VARIABLE i-seq           AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-financiamento AS LOGICAL     NO-UNDO.
DEFINE VARIABLE h-acomp         AS HANDLE      NO-UNDO.
DEFINE VARIABLE l-achou-offgrid AS LOG         NO-UNDO.

DEFINE TEMP-TABLE tt-ped-item      NO-UNDO LIKE ped-item
    FIELD r-rowid AS ROWID.

DEF TEMP-TABLE tt-erro-solar NO-UNDO
    FIELD mensagem    AS CHAR FORMAT "x(100)".

def temp-table tt-alocacao no-undo
    field cod-versao-integracao as   integer format "999"
    field tipo-trans            as   integer init 1
    field sit-aloc              as   integer init 1
    field nr-ord-produ          like ord-prod.nr-ord-produ
    field prioridade            as   integer init 3
    field informa-dep           as   logical
    field reaproveita           as   logical
    field aloca-altern          as   logical init ?
    field prog-seg              as   char
    field perc-proporcional     as   decimal init 100.

def temp-table tt-deposito NO-UNDO
    field indicador    as logical format "*/ "
    field cod-depos    like deposito.cod-depos
    field nome         like deposito.nome
    field ind-tipo-dep as char format "x(15)"
    field ind-processo like deposito.ind-processo
    field alocado      like deposito.alocado
    field prioridade   as int init 0
    index deposito is unique primary cod-depos
    index prioridade prioridade.

DEFINE INPUT PARAM p-item LIKE ITEM.it-codigo.

FIND FIRST ITEM NO-LOCK
     WHERE ITEM.it-codigo = p-item NO-ERROR.

RUN pi-pedido-solar.

PROCEDURE pi-pedido-solar:

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.             
    RUN pi-inicializar IN h-acomp (INPUT "Gerador Fotovoltaico."). 

    bloco:
    DO TRANSACTION 
    ON ERROR  UNDO bloco, LEAVE bloco:

        FIND FIRST int-item NO-LOCK
             WHERE int-item.it-codigo = ITEM.it-codigo NO-ERROR.
    
        IF  AVAIL int-item 
        AND int-item.nr-ped-energia <> "" THEN DO:
            
            FIND FIRST ped-venda NO-LOCK
                 WHERE ped-venda.nr-pedcli = int-item.nr-ped-energia NO-ERROR.

            EMPTY TEMP-TABLE tt-prog-ponto.
            RUN esp/es0018p.p (INPUT "Solar":U,
                               INPUT 5,
                               INPUT 0,
                               INPUT "":U,
                               OUTPUT TABLE tt-prog-ponto).

            IF CAN-FIND (FIRST tt-prog-ponto
                         WHERE tt-prog-ponto.conteudo = string(ped-venda.cod-cond-pag)) THEN 
                ASSIGN l-financiamento = YES.
            ELSE 
                ASSIGN l-financiamento = NO.

                
            IF  AVAIL ped-venda
            AND ped-venda.cod-sit-ped = 1 THEN DO:
                IF NOT CAN-FIND (FIRST ped-item OF ped-venda
                                 WHERE ped-item.it-codigo = int-item.it-codigo) THEN DO:
                    
                    RUN pi-adiciona-item-pedido.
                    
                    IF RETURN-VALUE = "NOK" THEN 
                        UNDO bloco, LEAVE bloco.
                END.    
                ELSE DO: 
                    RUN pi-finalizar in h-acomp.

                    IF VALID-HANDLE(h-acomp) THEN
                        DELETE PROCEDURE h-acomp.
                    RETURN "OK".
                END.
            END.
            ELSE DO:
                RUN pi-finalizar in h-acomp.

                IF VALID-HANDLE(h-acomp) THEN
                    DELETE PROCEDURE h-acomp.
                RETURN "OK".
            END.

            
            RUN pi-ordem-producao.  

            IF RETURN-VALUE = "NOK" THEN
                UNDO bloco, LEAVE bloco.
            
            FOR FIRST int-ped-venda EXCLUSIVE-LOCK
                WHERE int-ped-venda.nr-pedido  = ped-venda.nr-pedido:

                IF l-financiamento THEN
                    ASSIGN int-ped-venda.ind-status-solar = 1.
                ELSE 
                    ASSIGN int-ped-venda.ind-status-solar = 3.
            END.
        END.
    END.

    RUN pi-finalizar in h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        DELETE PROCEDURE h-acomp.

    RUN pi-email.
    
END PROCEDURE.

PROCEDURE pi-adiciona-item-pedido:

    DEFINE VARIABLE h-bodi154sdf AS HANDLE    NO-UNDO.
    DEFINE VARIABLE h-bodi154    AS HANDLE    NO-UNDO.
    DEFINE VARIABLE h-bodi159cal AS HANDLE    NO-UNDO.
    DEFINE VARIABLE h-bodi154can AS HANDLE      NO-UNDO.
    DEFINE VARIABLE i-sequencia  AS INTEGER     NO-UNDO.
    
    RUN pi-acompanhar in h-acomp (input "Adicionando item " + ITEM.it-codigo + " ao pedido.").
    
    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.

    FIND FIRST natur-oper NO-LOCK
         WHERE natur-oper.nat-operacao = ped-venda.nat-operacao NO-ERROR.

    FIND LAST ped-item NO-LOCK
        WHERE ped-item.nome-abrev = ped-venda.nome-abrev
          AND ped-item.nr-pedcli = ped-venda.nr-pedcli NO-ERROR.

    IF AVAIL ped-item THEN 
        ASSIGN i-sequencia = ped-item.nr-sequencia.
    ELSE 
        ASSIGN i-sequencia = 0.
    
    CREATE tt-ped-item.
    ASSIGN tt-ped-item.nr-pedcli           = ped-venda.nr-pedcli
           tt-ped-item.nome-abrev          = ped-venda.nome-abrev
           tt-ped-item.it-codigo           = ITEM.it-codigo
           tt-ped-item.aliquota-ipi        = ITEM.aliquota-ipi
           tt-ped-item.des-un-medida       = ITEM.un
           tt-ped-item.cod-entrega         = ped-venda.cod-entrega
           OVERLAY(tt-ped-item.char-2,1,8) = ITEM.class-fiscal.
    
    ASSIGN i-sequencia              = i-sequencia + 10
           tt-ped-item.nr-sequencia = i-sequencia.

     /*cria tabela de pre‡os*/
     EMPTY TEMP-TABLE tt-prog-ponto.
     RUN esp/es0018p.p (INPUT "Solar":U,
                        INPUT 4,
                        INPUT 0,
                        INPUT "":U,
                        OUTPUT TABLE tt-prog-ponto).
     
     FIND FIRST tt-prog-ponto NO-ERROR.
    
     FIND FIRST preco-item EXCLUSIVE-LOCK
          WHERE preco-item.it-codigo = ITEM.it-codigo
            AND preco-item.cod-refer = ""
            AND preco-item.nr-tabpre = tt-prog-ponto.conteudo NO-ERROR.
    
    ASSIGN tt-ped-item.qt-pedida               = 1
           tt-ped-item.qt-un-fat               = 1
           tt-ped-item.cod-sit-item            = 1 /* aberto */
           tt-ped-item.cod-sit-pre             = 1 /* nao alocado */
           tt-ped-item.dt-entorig              = ped-venda.dt-entorig
           tt-ped-item.dt-userimp              = ped-venda.dt-userimp
           tt-ped-item.esp-ped                 = 1 /* pedido simples */
           tt-ped-item.nat-operacao            = natur-oper.nat-operacao
           tt-ped-item.per-des-icms            = natur-oper.per-des-icms
           tt-ped-item.tp-adm-lote             = 1
           tt-ped-item.tp-preco                = 0
           tt-ped-item.user-impl               = ped-venda.user-impl
           tt-ped-item.vl-pretab               = IF AVAIL preco-item THEN preco-item.preco-venda ELSE ped-venda.vl-tot-ped
           tt-ped-item.vl-preori               = IF AVAIL preco-item THEN preco-item.preco-venda ELSE ped-venda.vl-tot-ped
           tt-ped-item.log-usa-tabela-desconto = NO
           tt-ped-item.observacao              = ""
           tt-ped-item.per-minfat              = IF AVAIL emitente THEN emitente.per-minfat ELSE 0
           tt-ped-item.cd-origem               = 2
           tt-ped-item.tipo-atend              = IF ITEM.baixa-estoq = NO OR ped-venda.ind-fat-par THEN 2 ELSE 1.
    
    IF NOT CAN-FIND (FIRST int-ped-item
                     WHERE int-ped-item.nome-abrev    = tt-ped-item.nome-abrev
                      AND  int-ped-item.nr-pedcli     = tt-ped-item.nr-pedcli
                      AND  int-ped-item.nr-sequencia  = tt-ped-item.nr-sequencia
                      AND  int-ped-item.it-codigo     = tt-ped-item.it-codigo) THEN DO:
    
        CREATE int-ped-item.
        ASSIGN int-ped-item.nome-abrev    = tt-ped-item.nome-abrev
               int-ped-item.nr-pedcli     = tt-ped-item.nr-pedcli
               int-ped-item.nr-sequencia  = tt-ped-item.nr-sequencia
               int-ped-item.it-codigo     = tt-ped-item.it-codigo.
    END.

    /*Busca ICMS retido*/
    IF  NOT VALID-HANDLE(h-bodi154sdf) 
    OR  h-bodi154sdf:TYPE     <> "PROCEDURE":U 
    OR h-bodi154sdf:FILE-NAME <> "dibo/bodi154sdf.p":U THEN
        RUN dibo/bodi154sdf.p PERSISTENT SET h-bodi154sdf.

    IF  AVAIL emitente 
    AND AVAIL natur-oper THEN DO:    
        RUN setICMRetido IN h-bodi154sdf (INPUT  tt-ped-item.nome-abrev,
                                          INPUT  tt-ped-item.cod-entrega,
                                          INPUT  tt-ped-item.it-codigo,
                                          INPUT  ped-venda.cod-estabel,
                                          INPUT  emitente.insc-subs-trib,
                                          INPUT  natur-oper.subs-trib,
                                          OUTPUT tt-ped-item.ind-icm-ret).   
    END.
    
    DELETE PROCEDURE h-bodi154sdf.
    
    ASSIGN tt-ped-item.vl-liq-it   = tt-ped-item.qt-pedida * 
                                     tt-ped-item.vl-preuni
           tt-ped-item.vl-merc-abe = tt-ped-item.qt-pedida * 
                                     tt-ped-item.vl-preuni
           tt-ped-item.vl-tot-it   = tt-ped-item.vl-liq-abe.

    FIND FIRST item-uni-estab EXCLUSIVE-LOCK
         WHERE item-uni-estab.cod-estabel = ped-venda.cod-estabel
           AND item-uni-estab.it-codigo   = tt-ped-item.it-codigo NO-ERROR.

    IF AVAIL item-uni-estab THEN DO:
        ASSIGN item-uni-estab.ind-item-fat = YES.

        RELEASE item-uni-estab.
    END.

   /*CREATE ped-ent.
   ASSIGN ped-ent.nr-pedcli    = tt-ped-item.nr-pedcli
          ped-ent.cod-sit-ent  = tt-ped-item.cod-sit-item
          ped-ent.cod-sit-pre  = tt-ped-item.cod-sit-pre
          ped-ent.dt-entorig   = tt-ped-item.dt-entorig
          ped-ent.dt-entrega   = tt-ped-item.dt-entrega
          ped-ent.dt-userimp   = tt-ped-item.dt-userimp
          ped-ent.it-codigo    = tt-ped-item.it-codigo
          ped-ent.nome-abrev   = tt-ped-item.nome-abrev
          ped-ent.qt-pedida    = tt-ped-item.qt-pedida
          ped-ent.user-impl    = tt-ped-item.user-impl
          ped-ent.vl-liq-it    = tt-ped-item.vl-liq-it
          ped-ent.nr-sequencia = tt-ped-item.nr-sequencia
          ped-ent.vl-liq-abe   = tt-ped-item.vl-liq-abe.*/

   FIND CURRENT ped-venda EXCLUSIVE-LOCK.

   ASSIGN ped-venda.vl-tot-ped = tt-ped-item.vl-liq-abe
          ped-venda.vl-liq-abe = tt-ped-item.vl-liq-abe
          ped-venda.vl-mer-abe = tt-ped-item.vl-liq-it
          ped-venda.vl-liq-ped = tt-ped-item.vl-liq-it.

   FIND CURRENT ped-venda NO-LOCK.

   FIND FIRST item-uni-estab NO-LOCK
        WHERE item-uni-estab.cod-estabel = ped-venda.cod-estabel
          AND item-uni-estab.it-codigo   = tt-ped-item.it-codigo NO-ERROR.

   IF AVAIL item-uni-estab THEN
      ASSIGN tt-ped-item.cod-unid-negoc = item-uni-estab.cod-unid-negoc.
   ELSE
      ASSIGN tt-ped-item.cod-unid-negoc = ITEM.cod-unid-negoc.
      
    IF  NOT VALID-HANDLE(h-bodi154) THEN
        RUN dibo/bodi154.p PERSISTENT SET h-bodi154.

    RUN openQueryStatic IN h-bodi154(INPUT "Default":U).
    RUN emptyRowErrors  IN h-bodi154.
    RUN setRecord       IN h-bodi154(INPUT TABLE tt-ped-item).
    RUN createMPLog     IN h-bodi154(INPUT NO).
    RUN createRecord    IN h-bodi154.
    RUN getRowErrors    IN h-bodi154(OUTPUT TABLE RowErrors).
    
    IF VALID-HANDLE(h-bodi154) THEN
        DELETE PROCEDURE h-bodi154.

    FOR EACH RowErrors NO-LOCK
       WHERE RowErrors.ErrorType   <> "INTERNAL":U
         AND RowErrors.ErrorSubType = "Error":U:
        
        CREATE tt-erro-solar.
        ASSIGN tt-erro-solar.mensagem  = RowErrors.errorDescription + " Item: " + tt-ped-item.it-codigo.
               
    END.
    
    IF CAN-FIND (FIRST tt-erro-solar) THEN
        RETURN "NOK".

    
    FOR EACH ped-item OF ped-venda 
       WHERE ped-item.nr-sequencia <> tt-ped-item.nr-sequencia
         AND ped-item.cod-sit-item = 1:

        IF NOT CAN-FIND (FIRST estrutura
                         WHERE estrutura.it-codigo = tt-ped-item.it-codigo
                           AND estrutura.es-codigo = ped-item.it-codigo) THEN
            NEXT.

        RUN pi-acompanhar in h-acomp (input "Cancelando item " + ped-item.it-codigo + " do pedido.").

        IF NOT VALID-HANDLE(h-bodi154can) 
        OR h-bodi154can:TYPE      <> "PROCEDURE":U 
        OR h-bodi154can:FILE-NAME <> "dibo/bodi154can.p" THEN
           RUN dibo/bodi154can.p PERSISTENT SET h-bodi154can.

        RUN setUserLog IN h-bodi154can (INPUT c-seg-usuario).
    
        RUN validateCancelation IN h-bodi154can (INPUT ROWID(ped-item),
                                                 INPUT "Cancelamento item do pedido ap¢s libera‡Æo do Gerador Fotovoltaico para faturamento",
                                                 INPUT-OUTPUT TABLE RowErrors).

        
        FOR EACH rowErrors
           WHERE RowErrors.ErrorType <> "INTERNAL"
             AND RowErrors.ErrorSubType = "Error":U:
 
           CREATE tt-erro-solar.
           ASSIGN tt-erro-solar.mensagem  = RowErrors.errorDescription + " Item: " + ped-item.it-codigo.
        END.
        
        IF CAN-FIND (FIRST tt-erro-solar) THEN
            RETURN "NOK".

        RUN updateCancelation in h-bodi154can (INPUT  ROWID(ped-item),
                                               INPUT  "Cancelamento item do pedido ap¢s libera‡Æo do Gerador Fotovoltaico para faturamento",
                                               INPUT  TODAY,
                                               INPUT  13).

        RUN getRowErrors IN h-bodi154can (OUTPUT TABLE RowErrors). 
        RUN destroyBO    IN h-bodi154can.
        RUN Destroy      IN h-bodi154can.

        IF VALID-HANDLE(h-bodi154can) THEN
            DELETE PROCEDURE h-bodi154can.

        FOR EACH rowErrors
           WHERE RowErrors.ErrorType <> "INTERNAL"
             AND RowErrors.ErrorSubType = "Error":U:
 
           CREATE tt-erro-solar.
           ASSIGN tt-erro-solar.mensagem  = RowErrors.errorDescription + " Item: " + ped-item.it-codigo.
        END.

        IF CAN-FIND (FIRST tt-erro-solar) THEN
            RETURN "NOK".
    END.
    
    
    IF NOT ped-venda.completo THEN DO:
        IF NOT VALID-HANDLE(h-bodi159cal) THEN
           RUN dibo/bodi159com.p PERSISTENT SET h-bodi159cal.
            
           RUN completeOrder IN h-bodi159cal (INPUT  ROWID(ped-venda),
                                              OUTPUT TABLE rowErrors).

           IF VALID-HANDLE (h-bodi159cal) THEN
               DELETE PROCEDURE h-bodi159cal.
    END.

    RETURN "OK".
END PROCEDURE.

PROCEDURE pi-ordem-producao:
    DEFINE VARIABLE h-cpapi301 AS HANDLE      NO-UNDO.

    EMPTY TEMP-TABLE tt-ord-prod.
    
    RUN pi-acompanhar in h-acomp (input "Gerando ordem de produ‡Æo.").
    IF NOT VALID-HANDLE(h-cpapi301) THEN
        RUN cpp/cpapi301.p PERSISTENT SET h-cpapi301 (INPUT-OUTPUT TABLE tt-ord-prod,
                                                      INPUT-OUTPUT TABLE tt-reapro,
                                                      INPUT-OUTPUT TABLE tt-erro,
                                                      YES).

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.

    CREATE tt-ord-prod.
    ASSIGN tt-ord-prod.it-codigo             = ITEM.it-codigo
           tt-ord-prod.cod-refer             = ""
           tt-ord-prod.dt-inicio             = TODAY
           tt-ord-prod.dt-termino            = TODAY
           tt-ord-prod.nome-abrev            = ped-venda.nome-abrev
           tt-ord-prod.nr-sequencia          = 0                      
           tt-ord-prod.nr-entrega            = 0                      
           tt-ord-prod.prioridade            = 99                     
           tt-ord-prod.qt-ordem              = 1             
           tt-ord-prod.cod-estabel           = ped-venda.cod-estabel          
           tt-ord-prod.ind-tipo-movto        = 1 /* Inclus’o */       
           tt-ord-prod.gera-relacionamentos  = yes                    
           tt-ord-prod.prog-seg              = "cp0301":U
           tt-ord-prod.faixa-numeracao       = 1 /* Ordens Automaticas */
           tt-ord-prod.nr-ord-produ          = ?                     
           tt-ord-prod.dt-orig               = TODAY                 
           tt-ord-prod.nr-pedido             = string(ped-venda.nr-pedido).
	
    ASSIGN tt-ord-prod.considera-dias-desl   = YES
           tt-ord-prod.sit-aloc              = ? 
           tt-ord-prod.calc-cs-mat           = ? 
           tt-ord-prod.calc-cs-ggf           = ? 
           tt-ord-prod.calc-cs-mob           = ? 
           tt-ord-prod.rep-prod              = ? 
           tt-ord-prod.tipo                  = ? 
           tt-ord-prod.reporte-mob           = ? 
           tt-ord-prod.reporte-ggf           = ? 
           tt-ord-prod.origem                = "CP":U
           tt-ord-prod.cod-depos             = "WAL"
           tt-ord-prod.nr-linha              = ITEM.nr-linha
           tt-ord-prod.cod-unid-negoc        = ITEM.cod-unid-negoc
           tt-ord-prod.cod-gr-cli            = emitente.cod-gr-cli
           tt-ord-prod.estado                = 6.

    &IF DEFINED(bf_man_204) &THEN
    ASSIGN tt-ord-prod.cod-versao-integracao = 003.
    &ELSE
    ASSIGN tt-ord-prod.cod-versao-integracao = 002.
    &ENDIF
    
    /* Cria a Ordem */
    IF  CAN-FIND(FIRST tt-ord-prod) THEN
        RUN pi-processa-ordens IN h-cpapi301 (INPUT-OUTPUT TABLE tt-ord-prod,
                                              INPUT-OUTPUT TABLE tt-reapro,
                                              INPUT-OUTPUT TABLE tt-erro,
                                              INPUT        YES). /* deleta erros */

    IF VALID-HANDLE(h-cpapi301) THEN DO:
         RUN finalizaAPI IN h-cpapi301.
         IF VALID-HANDLE(h-cpapi301) THEN
            DELETE PROCEDURE h-cpapi301.
         ASSIGN h-cpapi301 = ?.
    END.
    
    IF RETURN-VALUE <> "OK" THEN DO: /*return pi-processa-ordens*/
       IF CAN-FIND(FIRST tt-erro) THEN DO:
           FOR EACH tt-erro:
               CREATE tt-erro-solar.
               ASSIGN tt-erro-solar.mensagem  = tt-erro.mensagem.
           END.
       END.
    END.

    IF CAN-FIND (FIRST tt-erro-solar) THEN
        RETURN "NOK".

    FIND FIRST tt-ord-prod NO-ERROR.

    FIND FIRST ord-prod NO-LOCK  
         WHERE ROWID(ord-prod) = tt-ord-prod.rw-ord-prod NO-ERROR.

    IF  AVAIL ord-prod THEN DO:
        CREATE tt-alocacao.
        ASSIGN tt-alocacao.cod-versao-integracao = 001
               tt-alocacao.tipo-trans   = 1
               tt-alocacao.nr-ord-produ = ord-prod.nr-ord-produ
               //tt-alocacao.prioridade   = 3 /* Aleat¢ria */
               tt-alocacao.prioridade   = 2 /* Dep¢sitos de Processo - conforme chamado M2006-007*/
               tt-alocacao.sit-aloc     = ord-prod.sit-aloc
               tt-alocacao.informa-dep  = YES
               tt-alocacao.prog-seg     = "cp0330". 
    END.

    CREATE tt-deposito.
    ASSIGN tt-deposito.indicador = yes
           tt-deposito.cod-depos = "WFT"
           tt-deposito.alocado   = yes.

    EMPTY TEMP-TABLE tt-erro.

    RUN cpp/cpapi013.p (INPUT        TABLE tt-alocacao,
                        INPUT        TABLE tt-deposito,
                        INPUT-OUTPUT TABLE tt-erro,
                        YES).    

    IF CAN-FIND(FIRST tt-erro) THEN DO:
        FOR EACH tt-erro:
            CREATE tt-erro-solar.
            ASSIGN tt-erro-solar.mensagem = tt-erro.mensagem.
        END.
    END.

/*     IF CAN-FIND (FIRST tt-erro-solar) THEN */
/*         RETURN "NOK".                      */

    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-email:
    DEFINE VARIABLE c-mail     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE h-utapi019 AS HANDLE      NO-UNDO.

    FIND FIRST int-item NO-LOCK
         WHERE int-item.it-codigo = ITEM.it-codigo NO-ERROR.

    IF NOT CAN-FIND (FIRST tt-erro-solar) THEN DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
        RUN esp/es0018p.p (INPUT "win172":U,
                           INPUT 3,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).

        ASSIGN c-mail = "".

        FOR EACH tt-prog-ponto:
            IF c-mail = "" THEN
                ASSIGN c-mail = tt-prog-ponto.conteudo.
            ELSE 
                ASSIGN c-mail = c-mail + ", " + tt-prog-ponto.conteudo.
        END.

        
        IF c-mail <> "" THEN DO:

            FOR FIRST param-global NO-LOCK:
            END.

            FIND FIRST usuar_mestre NO-LOCK
                 WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-ERROR.
            
            RUN utp/utapi019.p PERSISTENT SET h-utapi019.
      
            FOR EACH tt-envio2.   DELETE tt-envio2.   END.
            FOR EACH tt-mensagem. DELETE tt-mensagem. END.
    
            CREATE tt-envio2.
            ASSIGN tt-envio2.versao-integracao = 1
                   tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
                   tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
                   tt-envio2.destino           = c-mail                   /* Destinat˜rio       */ 
                   tt-envio2.remetente         = usuar_mestre.cod_e_mail_local  /* Remetente          */ 
                   tt-envio2.assunto           = "Ordem: " + STRING(ord-prod.nr-ord-produ) + " do Pedido de Venda: " + STRING(int-item.nr-ped-energia) + " dispon¡vel para separa‡Æo." /* Assunto */
                   tt-envio2.formato           = "TEXTO".

            CREATE tt-mensagem.
            ASSIGN tt-mensagem.seq-mensagem = 1
                   tt-mensagem.mensagem     = "Prezado Colaborador(a)," + CHR(13) + CHR(13) + 
                                              "A Ordem de Produ‡Æo " + STRING(ord-prod.nr-ord-produ) +  " encontra-se alocada e dispon¡vel para separa‡Æo."  + CHR(13) + 
                                              "Atenciosamente," + CHR(13) +
                                              "Controladoria.".

            RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                           INPUT  TABLE tt-mensagem,
                                           OUTPUT TABLE tt-erros).
           
            FIND FIRST tt-erros NO-LOCK NO-ERROR.

            IF VALID-HANDLE(h-utapi019) THEN
                DELETE PROCEDURE h-utapi019.
        END.
        
    END.
    ELSE DO:
        ASSIGN c-mail = "".

        ASSIGN l-achou-offgrid = NO.
        FOR FIRST ponto-programa NO-LOCK
            where ponto-programa.nome-programa = 'solar'
              AND ponto-programa.ponto         = 7,
            FIRST conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa          = ponto-programa.cod-programa
              AND entry(1,conteudo-programa.conteudo,";") = substring(ITEM.fm-cod-com,3,2):

            ASSIGN c-mail = entry(2,conteudo-programa.conteudo,";")
                   l-achou-offgrid = YES.
        END.

        IF NOT l-achou-offgrid THEN DO:
           EMPTY TEMP-TABLE tt-prog-ponto.
           RUN esp/es0018p.p (INPUT "Solar":U,
                              INPUT 1,
                              INPUT 0,
                              INPUT "":U,
                              OUTPUT TABLE tt-prog-ponto).

           FOR EACH tt-prog-ponto:
               IF c-mail = "" THEN
                   ASSIGN c-mail = tt-prog-ponto.conteudo.
               ELSE 
                   ASSIGN c-mail = c-mail + "," + tt-prog-ponto.conteudo.
           END.
        END.
        IF c-mail <> "" THEN DO:

            FOR FIRST param-global NO-LOCK:
            END.

            FIND FIRST usuar_mestre NO-LOCK
                 WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-ERROR.
            
            RUN utp/utapi019.p PERSISTENT SET h-utapi019.
      
            FOR EACH tt-envio2.   DELETE tt-envio2.   END.
            FOR EACH tt-mensagem. DELETE tt-mensagem. END.
    
            CREATE tt-envio2.
            ASSIGN tt-envio2.versao-integracao = 1
                   tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
                   tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
                   tt-envio2.destino           = c-mail                   /* Destinat˜rio       */ 
                   tt-envio2.remetente         = usuar_mestre.cod_e_mail_local  /* Remetente          */ 
                   tt-envio2.assunto           = "Erros no processo de libera‡Æo para faturamento do pedido solar." /* Assunto */
                   tt-envio2.formato           = "TEXTO".

            CREATE tt-mensagem.
            ASSIGN tt-mensagem.seq-mensagem = 1
                   tt-mensagem.mensagem     = "Prezado Colaborador(a)," + CHR(13) + CHR(13) + 
                                              "Segue erros no processo de libera‡Æo para faturamento do pedido solar " + STRING(int-item.nr-ped-energia)  + CHR(13) + CHR(13).

            FOR EACH tt-erro-solar:
                ASSIGN tt-mensagem.mensagem = tt-mensagem.mensagem + tt-erro-solar.mensagem + CHR(13).
            END.

            RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                           INPUT  TABLE tt-mensagem,
                                           OUTPUT TABLE tt-erros).
           
            FIND FIRST tt-erros NO-LOCK NO-ERROR.
            
            IF VALID-HANDLE(h-utapi019) THEN
                DELETE PROCEDURE h-utapi019.
        END.
    END.
END.
