/************************************************************************/
/*        FONTE RESPONSAVEL POR RETIRAR DO GKO A CONTABILIZACAO         */
/************************************************************************/
/* 15/06/2023 - Novo item de frete                                      */
/* 24/06/2023 - Nova Busca por UF origem x Destino                      */
/* 07/07/2023 - Correcao regra para diferenca no rateio do frete        */
/* 07/07/2023 - Inclusao regra para restricao de uso de UND.Neg por CC  */
/* 27/07/2023 - Correcoes no processo de abortar processamento com erro */
/*              Retirada de restricao para codigo do item dif.vazio     */
/*              Correcao de codigo de mensagem de erro                  */
/* 08/08/2023 - Novo procedimento para processar CT-e complementar      */
/* 16/10/2023 - Controle para nao permitir peso menor que uma grama     */
/*                                                                      */
/************************************************************************/

DEF VAR i-cod-emitente LIKE docto-orig-cte.cod-emitente NO-UNDO.
DEF VAR c-cod-estabel  LIKE docto-orig-cte.cod-estabel  NO-UNDO.
DEF VAR c-serie-docto  LIKE docto-orig-cte.nro-docto    NO-UNDO.
DEF VAR c-nro-docto    LIKE docto-orig-cte.nro-docto    NO-UNDO.
DEF VAR i-situacao     AS INTEGER                       NO-UNDO.

{utp/ut-glob.i}
{method/dbotterr.i}

DEF BUFFER bf-docto-orig-cte  FOR docto-orig-cte.
DEF BUFFER bfmsg-ret-nfe      FOR msg-ret-nfe.
DEF BUFFER bf-docum-est       FOR docum-est.
DEF BUFFER b-unid-feder       FOR unid-feder.

DEFINE TEMP-TABLE tt-docum-est NO-UNDO like docum-est
    field r-rowid  as rowid.

DEFINE TEMP-TABLE tt-item-doc-est NO-UNDO like item-doc-est
    field r-rowid  as rowid.
 
DEFINE TEMP-TABLE tt-dupli-apagar NO-UNDO LIKE dupli-apagar
    FIELD r-Rowid AS ROWID.

DEFINE TEMP-TABLE tt-dupli-imp NO-UNDO LIKE dupli-imp
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-rat-docum NO-UNDO LIKE rat-docum
    FIELD r-Rowid AS ROWID.

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD identif-segment AS CHAR
    FIELD cd-erro         AS INT
    FIELD desc-erro       AS CHAR FORMAT "x(80)".

DEF VAR de-valor-frete       AS DEC  NO-UNDO.
DEF VAR c-serie              AS CHAR NO-UNDO.
DEF VAR c-nota               AS CHAR NO-UNDO.
DEF VAR c-anomes             AS CHAR NO-UNDO.
DEF VAR c-chave              AS CHAR NO-UNDO.
DEF VAR c-ano-mes-aux        AS CHAR NO-UNDO.
DEF VAR p-valor-retorno      AS CHAR NO-UNDO. 
DEF VAR p-cod-regra-util     AS CHAR NO-UNDO.
DEF VAR p-erro               AS CHAR NO-UNDO. 
DEF VAR c-nat-oper           AS CHAR NO-UNDO.
DEF VAR i-sequencia          AS INT  NO-UNDO.
DEF VAR de-nota-peso-liq-tot AS DEC  NO-UNDO.
DEF VAR c-estab-ini          AS CHAR NO-UNDO.
DEF VAR c-estab-fim          AS CHAR NO-UNDO.
DEF VAR c-cnpj               AS CHAR NO-UNDO.
DEF VAR i-serie              AS INT  NO-UNDO.
DEF VAR c-it-codigo          AS CHAR NO-UNDO.
DEF VAR c-nat-operacao       AS CHAR NO-UNDO.   

DEF VAR h-acomp    AS HANDLE NO-UNDO.
DEF VAR h-boin871  AS HANDLE NO-UNDO.

DEF TEMP-TABLE tt-rateio-item NO-UNDO
    FIELD nr-nota-fis     AS CHAR 
    FIELD cod-emitente    AS INT 
    FIELD serie           AS CHAR
    FIELD nr-sequencia    AS INT 
    FIELD it-codigo       AS CHAR 
    FIELD cod-canal-venda AS INT 
    FIELD cod-unid-negoc  AS CHAR
    FIELD valor-frete     LIKE item-doc-est.preco-total[1]
    FIELD cod-estabel     AS CHAR 
    FIELD nat-operacao    AS CHAR 
    FIELD peso-liquido    LIKE item-doc-est.peso-liquido
    FIELD valor-it-nota   LIKE it-nota-fisc.vl-tot-item
    FIELD uf-origem       AS CHAR 
    FIELD uf-destino      AS CHAR
    .

DEF TEMP-TABLE tt-notas-nfe         NO-UNDO
    FIELD cod-estabel               AS CHAR 
    FIELD serie                     AS CHAR
    FIELD nr-nota-fis               AS CHAR 
    FIELD ano-mes                   AS CHAR
    FIELD cod-chave-aces-nf-eletro  LIKE nota-fiscal.cod-chave-aces-nf-eletro
          INDEX ch_01
                ano-mes 
                cod-estabel    
                serie          
                nr-nota-fis 
          INDEX ch_02
                cod-chave-aces-nf-eletro.

DEFINE TEMP-TABLE tt-nota-fisc-adc NO-UNDO LIKE nota-fisc-adc
    FIELD r-Rowid AS ROWID.

def temp-table tt_log_erro  no-undo 
    field ttv_num_cod_erro  as integer   initial ?
    field ttv_des_msg_ajuda as character initial ?
    field ttv_des_msg_erro  as character initial ?.

def temp-table tt-variavel no-undo
    field cod-var-oper   like config-var-operac-regra-cond.cod-variavel
    field valor-variavel like config-var-operac-regra-cond.cod-val-var.

def temp-table tt-retorno no-undo
    field valor-retorno like config-var-operac-regra-ret.cod-val-ret
    field campo-retorno like config-var-operac-regra-ret.cod-campo-ret
    field perc-rateio   like config-var-operac-regra-ret.cdd-perc-rat.

def var i-cod-regra-utilizada as integer no-undo.

DEF VAR texto-msg           AS CHAR   NO-UNDO.
DEF VAR l-frete-embarcador  AS LOG    NO-UNDO.
DEF VAR l-altera-dt-trans   AS LOG    NO-UNDO.
DEF VAR h-boin862           AS HANDLE NO-UNDO.

PROCEDURE pi-busca-regras:

    DEFINE INPUT PARAMETER P-cdn-empresa    AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER P-cod-estab      AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER P-cod-tip-operac LIKE config-operac.cod-tip-operac NO-UNDO.
    DEFINE INPUT PARAMETER TABLE FOR tt-variavel.
    
    DEF OUTPUT param P-valor-retorno  LIKE config-var-operac-regra-ret.cod-val-ret.
    DEF OUTPUT param p-cod-regra-util AS INTEGER.
    DEF OUTPUT PARAM p-erro           AS CHARACTER FORMAT "X(200)".
    
    empty temp-table tt-erro.
    empty temp-table tt-retorno.
    empty temp-table RowErrors.
    
    FIND FIRST config-operac WHERE 
               config-operac.cdn-empresa    = STRING(P-cdn-empresa) AND 
               config-operac.cod-estab      = P-cod-estab           AND 
               config-operac.cod-tip-operac = P-cod-tip-operac      NO-LOCK NO-ERROR.
    
    IF AVAIL config-operac THEN 
       DO:
          RUN cdp/cdapi034.p (INPUT config-operac.cdn-empresa,
                              INPUT config-operac.cod-estab,
                              INPUT config-operac.cod-tip-operac,
                              INPUT TABLE tt-variavel,
                              output i-cod-regra-utilizada,
                              output table tt-retorno,
                              output table RowErrors).
    
        
       END.
    
    IF CAN-FIND(FIRST RowErrors ) THEN
       DO:
          p-erro = "".
          FOR EACH RowErrors WHERE 
                   Rowerrors.errorsubtype = "ERROR" NO-LOCK:
                   p-erro = TRIM(p-erro + " " + rowerrors.errordescription + "~~" + rowerrors.errorhelp).
          END.
       END.
    ELSE 
       DO:
          IF NOT CAN-FIND(FIRST tt-retorno) THEN p-erro = "Nenhuma regra encontrada".
          ELSE 
             DO:
                p-cod-regra-util = i-cod-regra-utilizada.
                FOR FIRST tt-retorno:
                    P-valor-retorno = tt-retorno.valor-retorno.
                END.
             END.
       END.

END PROCEDURE.

PROCEDURE pi-gera-docto-recebimento:

    DEF INPUT  PARAM pr-nota         AS ROWID NO-UNDO.
    DEF INPUT  PARAM pr-tipo-entrada AS CHAR  NO-UNDO.
    DEF OUTPUT PARAM l-ok            AS LOG   NO-UNDO.

    DEF VAR ch-acesso AS CHAR NO-UNDO.
    DEF VAR i-cod-emitente LIKE docto-orig-cte.cod-emitente NO-UNDO.
    DEF VAR c-cod-estabel  LIKE docto-orig-cte.cod-estabel  NO-UNDO.
    DEF VAR c-serie-docto  LIKE docto-orig-cte.nro-docto    NO-UNDO.
    DEF VAR c-nro-docto    LIKE docto-orig-cte.nro-docto    NO-UNDO.
    DEF VAR r-ct-codigo    AS CHAR                          NO-UNDO.
    DEF VAR r-sc-codigo    AS CHAR                          NO-UNDO.
    DEF VAR r-un-codigo    AS CHAR                          NO-UNDO.
    DEF VAR h-boin356      AS HANDLE                        NO-UNDO.
    DEF VAR l-re0522       AS LOG                           NO-UNDO.
    
    DEF VAR c-lista-prog AS CHAR NO-UNDO.
    DEF VAR i-cont       AS INT  NO-UNDO.

    ASSIGN i-cont       = 1
           c-lista-prog = "".

    REPEAT:
        IF PROGRAM-NAME(i-cont) = ? THEN LEAVE.
        c-lista-prog = c-lista-prog + (IF c-lista-prog <> "" THEN "," ELSE "") + PROGRAM-NAME(i-cont).
        i-cont = i-cont + 1.
    END.

    ASSIGN l-re0522 = c-lista-prog MATCHES "*re0522*".

    EMPTY TEMP-TABLE tt-docum-est.
    EMPTY TEMP-TABLE tt-item-doc-est.
    EMPTY TEMP-TABLE tt-rateio-item.
    EMPTY TEMP-TABLE tt-dupli-apagar. 
    EMPTY TEMP-TABLE tt-erro.
    EMPTY TEMP-TABLE tt-rat-docum.

    ASSIGN l-ok = YES.
    
    run utp/ut-acomp.p persistent set h-acomp.
    run pi-inicializar in h-acomp (input "Gerando RE1001").
    blocoNota:
    FOR FIRST bf-docto-orig-cte EXCLUSIVE-LOCK
        WHERE ROWID(bf-docto-orig-cte) = pr-nota:
        
        ASSIGN i-cod-emitente = bf-docto-orig-cte.cod-emitente
               c-cod-estabel  = bf-docto-orig-cte.cod-estabel
               c-serie-docto  = bf-docto-orig-cte.serie-docto
               c-nro-docto    = bf-docto-orig-cte.nro-docto.

        RUN pi-acompanhar IN h-acomp (INPUT "Processando docto: " + c-nro-docto).

        /* 13/09/2023 - Regra para ignorar CTe de Compra */
        IF (pr-tipo-entrada = "l-cte-compra") THEN DO:
            {utp/ut-liter.i "Conhecimento_de_transporte_com_referencia_a_nota_fiscal_de_compra_n∆o_processa_no_especifico" *}
            RUN utp/ut-msgs.p (INPUT "MSG":U,
                               INPUT 17010,
                               INPUT RETURN-VALUE).

            ASSIGN texto-msg = RETURN-VALUE.

            FIND FIRST msg-ret-nfe NO-LOCK
                 WHERE msg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                   AND msg-ret-nfe.idi-orig-trad      = 2
                   AND msg-ret-nfe.log-ativo          = YES
                   AND msg-ret-nfe.cd-msg             = 17013 NO-ERROR.

            IF NOT AVAIL msg-ret-nfe THEN DO:
                CREATE msg-ret-nfe.
                ASSIGN msg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                       msg-ret-nfe.idi-orig-trad      = 2
                       msg-ret-nfe.dt-msg             = TODAY
                       msg-ret-nfe.hr-msg             = STRING(TIME, "HH:MM:SS")
                       msg-ret-nfe.log-ativo          = YES
                       msg-ret-nfe.cd-msg             = 17013
                       msg-ret-nfe.texto-msg          = texto-msg
                       msg-ret-nfe.seq-msg            = NEXT-VALUE(seq-msg-ret-nfe).

                RUN pi-grava-erro(INPUT 17013,
                                  INPUT texto-msg,
                                  INPUT bf-docto-orig-cte.cod-aces-comp-nfe).

                RELEASE msg-ret-nfe.
            END.

            /* Aborta */
            ASSIGN l-ok = NO.
            LEAVE blocoNota.
        END.

        FIND FIRST emitente NO-LOCK WHERE emitente.cgc = bf-docto-orig-cte.cnpj-emit NO-ERROR.
        FIND FIRST estabelec NO-LOCK WHERE estabelec.cod-estabel =  c-cod-estabel  NO-ERROR.

        IF NOT AVAIL emitente THEN DO:           
            {utp/ut-liter.i "fornecedor_com_o_CNPJ_do_conhecimento_de_transporte" *}
            RUN utp/ut-msgs.p (INPUT "MSG":U,
                               INPUT 32099,
                               INPUT RETURN-VALUE).

            ASSIGN texto-msg  = RETURN-VALUE.

            FIND FIRST msg-ret-nfe NO-LOCK
                 WHERE msg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                   AND msg-ret-nfe.idi-orig-trad      = 2
                   AND msg-ret-nfe.log-ativo          = YES
                   AND msg-ret-nfe.cd-msg             = 32099 NO-ERROR.
            IF NOT AVAIL msg-ret-nfe THEN DO:
                CREATE msg-ret-nfe.
                ASSIGN msg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                       msg-ret-nfe.idi-orig-trad      = 2
                       msg-ret-nfe.dt-msg             = TODAY
                       msg-ret-nfe.hr-msg             = STRING(TIME, "HH:MM:SS")
                       msg-ret-nfe.log-ativo          = YES
                       msg-ret-nfe.cd-msg             = 32099
                       msg-ret-nfe.texto-msg          = texto-msg
                       msg-ret-nfe.seq-msg            = NEXT-VALUE(seq-msg-ret-nfe).

                RUN pi-grava-erro(INPUT 17006,
                                  INPUT texto-msg,
                                  INPUT bf-docto-orig-cte.cod-aces-comp-nfe).

                RELEASE msg-ret-nfe.
            END.

            /* Aborta */
            ASSIGN l-ok = NO.
            LEAVE blocoNota.
        END.
        ELSE /* Fornecedor Emite Documento Eletronico */
            IF (NOT emitente.log-nf-eletro        AND emitente.identific <> 2)
            OR (NOT emitente.log-possui-nf-eletro AND emitente.identific <> 1) THEN DO:
                FIND CURRENT emitente EXCLUSIVE-LOCK NO-ERROR.
                ASSIGN emitente.log-nf-eletro        = YES WHEN emitente.identific <> 2
                       emitente.log-possui-nf-eletro = YES WHEN emitente.identific <> 1.
                FIND CURRENT emitente NO-LOCK NO-ERROR.
            END.

        /* TESTE
        MESSAGE "Condicao Pagamento" emitente.cod-emitente emitente.cod-cond-pag
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        */

        IF emitente.cod-cond-pag = 0 THEN DO:
            {utp/ut-liter.i "Condiá∆o_de_pagamento_n∆o_definida_no_transportador" *}
            RUN utp/ut-msgs.p (INPUT "MSG":U,
                               INPUT 17006,
                               INPUT RETURN-VALUE).

            ASSIGN texto-msg  = RETURN-VALUE.

            FIND FIRST msg-ret-nfe NO-LOCK
                 WHERE msg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                   AND msg-ret-nfe.idi-orig-trad      = 2
                   AND msg-ret-nfe.log-ativo          = YES
                   AND msg-ret-nfe.cd-msg             = 17012 NO-ERROR.
            IF NOT AVAIL msg-ret-nfe THEN DO:
                CREATE msg-ret-nfe.
                ASSIGN msg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                       msg-ret-nfe.idi-orig-trad      = 2
                       msg-ret-nfe.dt-msg             = TODAY
                       msg-ret-nfe.hr-msg             = STRING(TIME, "HH:MM:SS")
                       msg-ret-nfe.log-ativo          = YES
                       msg-ret-nfe.cd-msg             = 17012
                       msg-ret-nfe.texto-msg          = texto-msg
                       msg-ret-nfe.seq-msg            = NEXT-VALUE(seq-msg-ret-nfe).

                RUN pi-grava-erro(INPUT 17006,
                                  INPUT texto-msg,
                                  INPUT bf-docto-orig-cte.cod-aces-comp-nfe).

                RELEASE msg-ret-nfe.            
            END.

            /* Aborta */
            ASSIGN l-ok = NO.
            LEAVE blocoNota.
        END.
        
        ASSIGN p-valor-retorno = bf-docto-orig-cte.nat-operacao.

        /********** SE NÄO TIVER CFOP DEFINIDA BUSCA NA REGRA */
        IF bf-docto-orig-cte.nat-operacao = "" THEN DO:
            EMPTY TEMP-TABLE tt-variavel.

            CREATE tt-variavel.
            ASSIGN tt-variavel.cod-var-oper     = "cnpj-rem"
                   tt-variavel.valor-variavel   = SUBSTRING(bf-docto-orig-cte.cod-livre-1,1,14). // config-var-operac-regra-cond.cod-val-var.

           CREATE tt-variavel.
           ASSIGN tt-variavel.cod-var-oper     = "cod-cfop"
                  tt-variavel.valor-variavel   = bf-docto-orig-cte.cod-cfop.  // config-var-operac-regra-cond.cod-val-var.


           CREATE tt-variavel.
           ASSIGN tt-variavel.cod-var-oper     = "UF-ent"
                  tt-variavel.valor-variavel   = bf-docto-orig-cte.cod-uf-dest.  // config-var-operac-regra-cond.cod-val-var.

            RUN pi-busca-regras (input  estabelec.ep-codigo,        
                                 input  estabelec.cod-estabel,           
                                 input  "cte-nat-oper",      
                                 input  TABLE tt-variavel,     
                                 output P-valor-retorno,       
                                 output p-cod-regra-util,      
                                 output p-erro).               


        END.
        FIND FIRST natur-oper NO-LOCK
             WHERE natur-oper.nat-operacao = p-valor-retorno NO-ERROR.
             
        IF  NOT AVAIL natur-oper THEN DO:

            FIND FIRST bfmsg-ret-nfe NO-LOCK
                 WHERE bfmsg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                   AND bfmsg-ret-nfe.idi-orig-trad      = 2
                   AND bfmsg-ret-nfe.log-ativo          = YES
                   AND bfmsg-ret-nfe.cd-msg             = 17006 NO-ERROR.
            IF NOT AVAIL bfmsg-ret-nfe THEN DO:      
                {utp/ut-liter.i "Natureza_Operaªío" *}
                RUN utp/ut-msgs.p (INPUT "MSG":U,
                                   INPUT 2, /* Nao encontrada natureza de operacao para a chave informada */
                                   INPUT RETURN-VALUE).

                ASSIGN texto-msg  = RETURN-VALUE.
                CREATE msg-ret-nfe.
                ASSIGN msg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                       msg-ret-nfe.idi-orig-trad      = 2
                       msg-ret-nfe.dt-msg             = TODAY
                       msg-ret-nfe.hr-msg             = STRING(TIME, "HH:MM:SS")
                       msg-ret-nfe.log-ativo          = YES
                       msg-ret-nfe.cd-msg             = 17006
                       msg-ret-nfe.texto-msg          = texto-msg
                       msg-ret-nfe.seq-msg            = NEXT-VALUE(seq-msg-ret-nfe).

                RUN pi-grava-erro(INPUT 17006,
                                  INPUT texto-msg,
                                  INPUT bf-docto-orig-cte.cod-aces-comp-nfe).

                RELEASE msg-ret-nfe.
            END.

            /* Aborta */
            ASSIGN l-ok = NO.
            LEAVE blocoNota.
        END.

        ASSIGN bf-docto-orig-cte.nat-operacao = natur-oper.nat-operacao.

        /*******cria a capa do docto re1001*/

        RUN createTT-docum-est.

        EMPTY TEMP-TABLE tt-notas-nfe.

        RUN pi-rateia-nota(INPUT tt-docum-est.valor-mercad,
                           INPUT c-cod-estabel).


        IF CAN-FIND(FIRST tt-rateio-item) THEN DO:

            /*--- 15/06/2023 ---*/
            DEF VAR c-item-frete    AS CHAR NO-UNDO.
            /*--- 24/06/2023
            RUN pi-busca-item-frete(INPUT  tt-rateio-item.uf-origem, /*bf-docto-orig-cte.cod-uf-emit,*/
                                    INPUT  tt-rateio-item.uf-destino,
                                    OUTPUT c-item-frete).
            ---*/
            FIND FIRST unid-feder
                 WHERE unid-feder.cod-uf-ibge = substring(bf-docto-orig-cte.cod-livre-1,21,2) /* Origem */
                 NO-LOCK NO-ERROR.
            FIND FIRST b-unid-feder
                 WHERE b-unid-feder.cod-uf-ibge = substring(bf-docto-orig-cte.cod-livre-1,31,2) /* Destino */
                 NO-LOCK NO-ERROR.

            IF NOT AVAIL unid-feder OR NOT AVAIL b-unid-feder THEN DO:
                FIND FIRST bfmsg-ret-nfe NO-LOCK
                     WHERE bfmsg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                       AND bfmsg-ret-nfe.idi-orig-trad      = 2
                       AND bfmsg-ret-nfe.log-ativo          = YES
                       AND bfmsg-ret-nfe.cd-msg             = 17011 NO-ERROR.
                IF NOT AVAIL bfmsg-ret-nfe THEN DO:
                    {utp/ut-liter.i "Item_da_Nota" *}
                    RUN utp/ut-msgs.p (INPUT "MSG":U,
                                       INPUT 2,
                                       INPUT RETURN-VALUE).
                    ASSIGN texto-msg  = RETURN-VALUE + " N∆o foi poss°vel definir o item de frete para UF origem "
                                                     + substr(bf-docto-orig-cte.cod-livre-1,21,2) 
                                                     + " e UF destino " + substr(bf-docto-orig-cte.cod-livre-1,31,2).
                    CREATE msg-ret-nfe.
                    ASSIGN msg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                           msg-ret-nfe.idi-orig-trad      = 2
                           msg-ret-nfe.dt-msg             = TODAY
                           msg-ret-nfe.hr-msg             = STRING(TIME, "HH:MM:SS")
                           msg-ret-nfe.log-ativo          = YES
                           msg-ret-nfe.cd-msg             = 17011
                           msg-ret-nfe.texto-msg          = texto-msg
                           msg-ret-nfe.seq-msg            = NEXT-VALUE(seq-msg-ret-nfe).

                    RUN pi-grava-erro(INPUT 17006,
                                      INPUT texto-msg,
                                      INPUT bf-docto-orig-cte.cod-aces-comp-nfe).

                    RELEASE msg-ret-nfe.
                END.

                /* Aborta */
                ASSIGN l-ok = NO.
                LEAVE blocoNota.
            END.
            RUN pi-busca-item-frete(INPUT  unid-feder.estado,
                                    INPUT  b-unid-feder.estado,
                                    OUTPUT c-item-frete).

            IF c-item-frete = "" THEN DO:

                FIND FIRST bfmsg-ret-nfe NO-LOCK
                     WHERE bfmsg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                       AND bfmsg-ret-nfe.idi-orig-trad      = 2
                       AND bfmsg-ret-nfe.log-ativo          = YES
                       AND bfmsg-ret-nfe.cd-msg             = 17010 NO-ERROR.
                IF NOT AVAIL bfmsg-ret-nfe THEN DO:      
                    {utp/ut-liter.i "Item_da_Nota" *}
                    RUN utp/ut-msgs.p (INPUT "MSG":U,
                                       INPUT 2, /* Nao encontrada natureza de operacao para a chave informada */
                                       INPUT RETURN-VALUE).

                    ASSIGN texto-msg  = RETURN-VALUE + " N∆o tem traduá∆o".
                    CREATE msg-ret-nfe.
                    ASSIGN msg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                           msg-ret-nfe.idi-orig-trad      = 2
                           msg-ret-nfe.dt-msg             = TODAY
                           msg-ret-nfe.hr-msg             = STRING(TIME, "HH:MM:SS")
                           msg-ret-nfe.log-ativo          = YES
                           msg-ret-nfe.cd-msg             = 17010
                           msg-ret-nfe.texto-msg          = texto-msg
                           msg-ret-nfe.seq-msg            = NEXT-VALUE(seq-msg-ret-nfe).

                    RUN pi-grava-erro(INPUT 17006,
                                      INPUT texto-msg,
                                      INPUT bf-docto-orig-cte.cod-aces-comp-nfe).

                    RELEASE msg-ret-nfe.
                END.

                /* Aborta */
                ASSIGN l-ok = NO.
                LEAVE blocoNota.
            END.

           ASSIGN i-sequencia = 0.
           
           FOR EACH tt-rateio-item:
               // WHERE tt-rateio-item.it-codigo <> "":
			   
			   run pi-saida-gk0008(INPUT tt-rateio-item.cod-estabel,
								   INPUT tt-rateio-item.serie,
								   INPUT tt-rateio-item.nr-nota-fis,
								   INPUT tt-rateio-item.nat-operacao,
								   INPUT tt-rateio-item.cod-unid-neg,
								   INPUT tt-rateio-item.cod-canal-venda,
								   INPUT tt-rateio-item.it-codigo,
								   output r-ct-codigo,
								   output r-sc-codigo,
								   OUTPUT r-un-codigo).	
								   
				assign tt-rateio-item.cod-unid-neg = r-un-codigo.
				
				IF r-ct-codigo = "" THEN DO:                      
					FIND FIRST bfmsg-ret-nfe NO-LOCK
						 WHERE bfmsg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
						   AND bfmsg-ret-nfe.idi-orig-trad      = 2
						   AND bfmsg-ret-nfe.log-ativo          = YES
						   AND bfmsg-ret-nfe.cd-msg             = 17007 NO-ERROR.
					IF NOT AVAIL bfmsg-ret-nfe THEN DO:
						/* Inicio -- Projeto Internacional */
						{utp/ut-liter.i "N∆o_foi_encontrado_parametrizaá∆o_no_GK0008" *}
						RUN utp/ut-msgs.p (INPUT "MSG":U,
										   INPUT 2, /* Nao encontrada natureza de operacao para a chave informada */
										   INPUT RETURN-VALUE).
		
						ASSIGN texto-msg  = RETURN-VALUE + " Para o item: " + tt-rateio-item.it-codigo
														 + " Estab " + tt-rateio-item.cod-estabel
														 + " NF/Ser " + tt-rateio-item.nr-nota-fis + "/" + tt-rateio-item.serie
														 + " Nat Oper " + tt-rateio-item.nat-operacao
														 + " Unid Neg " + tt-rateio-item.cod-unid-neg.
						CREATE msg-ret-nfe.
						ASSIGN msg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
							   msg-ret-nfe.idi-orig-trad      = 2
							   msg-ret-nfe.dt-msg             = TODAY
							   msg-ret-nfe.hr-msg             = STRING(TIME, "HH:MM:SS")
							   msg-ret-nfe.log-ativo          = YES
							   msg-ret-nfe.cd-msg             = 17007
							   msg-ret-nfe.texto-msg          = texto-msg
							   msg-ret-nfe.seq-msg            = NEXT-VALUE(seq-msg-ret-nfe).
		
						RUN pi-grava-erro(INPUT 17006,
										  INPUT texto-msg,
										  INPUT bf-docto-orig-cte.cod-aces-comp-nfe).
		
						RELEASE msg-ret-nfe.
					END.

                    /* Aborta */
                    ASSIGN l-ok = NO.
                    LEAVE blocoNota.
			   END.
			   
               //NF / Serie / Emitente / Natureza / Sequencia Item
               ASSIGN c-nat-oper = bf-docto-orig-cte.nat-operacao.
                                                              
               FIND FIRST int-natur-oper-cte NO-LOCK 
                    WHERE int-natur-oper-cte.nat-operacao-cte = c-nat-oper
                      AND int-natur-oper-cte.nat-operacao-nfs = tt-rateio-item.nat-operacao NO-ERROR.

               IF AVAIL int-natur-oper-cte THEN DO:
                  ASSIGN c-nat-oper = int-natur-oper-cte.nat-operacao-para.
               END.
               /*--- 15/06/2023 ---*/
               ELSE DO:
                  FIND FIRST bfmsg-ret-nfe NO-LOCK
                       WHERE bfmsg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                         AND bfmsg-ret-nfe.idi-orig-trad      = 2
                         AND bfmsg-ret-nfe.log-ativo          = YES
                         AND bfmsg-ret-nfe.cd-msg             = 17008 NO-ERROR.
                  IF NOT AVAIL bfmsg-ret-nfe THEN DO:
                      /* Inicio -- Projeto Internacional */
                      {utp/ut-liter.i "Natureza_Operacao_Rateio_item_n∆o_localizada_no_de_x_para" *}
                      RUN utp/ut-msgs.p (INPUT "MSG":U,
                                         INPUT 2, /* Nao encontrada natureza de operacao para a chave informada */
                                         INPUT RETURN-VALUE).

                      ASSIGN texto-msg  = RETURN-VALUE + " Para o item: " + tt-rateio-item.it-codigo + " / Natureza CT " + c-nat-oper + " / Natureza item " + tt-rateio-item.nat-operacao.
                      CREATE msg-ret-nfe.
                      ASSIGN msg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                             msg-ret-nfe.idi-orig-trad      = 2
                             msg-ret-nfe.dt-msg             = TODAY
                             msg-ret-nfe.hr-msg             = STRING(TIME, "HH:MM:SS")
                             msg-ret-nfe.log-ativo          = YES
                             msg-ret-nfe.cd-msg             = 17008
                             msg-ret-nfe.texto-msg          = texto-msg
                             msg-ret-nfe.seq-msg            = NEXT-VALUE(seq-msg-ret-nfe).

                      RUN pi-grava-erro(INPUT 17006,
                                        INPUT texto-msg,
                                        INPUT bf-docto-orig-cte.cod-aces-comp-nfe).

                      RELEASE msg-ret-nfe.
                  END.

                  /* Aborta */
                  ASSIGN l-ok = NO.
                  LEAVE blocoNota.
               END.

               FIND FIRST natur-oper NO-LOCK
                    WHERE natur-oper.nat-operacao = c-nat-oper NO-ERROR.

               IF  NOT AVAIL natur-oper THEN DO:

                   FIND FIRST bfmsg-ret-nfe NO-LOCK
                        WHERE bfmsg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                          AND bfmsg-ret-nfe.idi-orig-trad      = 2
                          AND bfmsg-ret-nfe.log-ativo          = YES
                          AND bfmsg-ret-nfe.cd-msg             = 17009 NO-ERROR.
                   IF NOT AVAIL bfmsg-ret-nfe THEN DO:
                       /* Inicio -- Projeto Internacional */
                       {utp/ut-liter.i "Natureza_Operaªío_Rateio_item_nío_localizada_no_de_x_para" *}
                       RUN utp/ut-msgs.p (INPUT "MSG":U,
                                          INPUT 2, /* Nao encontrada natureza de operacao para a chave informada */
                                          INPUT RETURN-VALUE).

                       ASSIGN texto-msg  = RETURN-VALUE + " Para o item: " + tt-rateio-item.it-codigo + " / Natureza " + c-nat-oper.
                       CREATE msg-ret-nfe.
                       ASSIGN msg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                              msg-ret-nfe.idi-orig-trad      = 2
                              msg-ret-nfe.dt-msg             = TODAY
                              msg-ret-nfe.hr-msg             = STRING(TIME, "HH:MM:SS")
                              msg-ret-nfe.log-ativo          = YES
                              msg-ret-nfe.cd-msg             = 17009
                              msg-ret-nfe.texto-msg          = texto-msg
                              msg-ret-nfe.seq-msg            = NEXT-VALUE(seq-msg-ret-nfe).

                       RUN pi-grava-erro(INPUT 17006,
                                         INPUT texto-msg,
                                         INPUT bf-docto-orig-cte.cod-aces-comp-nfe).

                       RELEASE msg-ret-nfe.
                   END.

                   /* Aborta */
                   ASSIGN l-ok = NO.
                   LEAVE blocoNota.
               END.
               
               ASSIGN i-sequencia = i-sequencia + 20.

               FIND FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = tt-rateio-item.it-codigo NO-ERROR.

               CREATE tt-item-doc-est.
               ASSIGN tt-item-doc-est.cod-emitente   = i-cod-emitente
                      tt-item-doc-est.nat-operacao   = bf-docto-orig-cte.nat-operacao
                      tt-item-doc-est.nat-of         = c-nat-oper
                      tt-item-doc-est.nro-docto      = c-nro-docto
                      tt-item-doc-est.serie-docto    = c-serie-docto 
                      tt-item-doc-est.it-codigo      = c-item-frete
                      tt-item-doc-est.preco-unit[1]  = tt-rateio-item.valor-frete
                      tt-item-doc-est.quantidade     = 1
                      tt-item-doc-est.sequencia      = i-sequencia 
                      tt-item-doc-est.narrativa      = ""
                      tt-item-doc-est.cd-trib-icm    = natur-oper.cd-trib-icm
                      tt-item-doc-est.cd-trib-ipi    = ITEM.cd-trib-ipi WHEN AVAIL ITEM
                      tt-item-doc-est.num-pedido     = 0
                      tt-item-doc-est.numero-ordem   = 0
                      tt-item-doc-est.int-1          = 0
                      tt-item-doc-est.parcela        = 0
                      tt-item-doc-est.encerra-pa     = NO
                      tt-item-doc-est.narrativa      = tt-rateio-item.nr-nota-fis 
                                                     + "/" + tt-rateio-item.serie 
                                                     + "/" + STRING(tt-rateio-item.cod-emitente) 
                                                     + "/" + tt-rateio-item.nat-operacao 
                                                     + "/" + STRING(tt-rateio-item.nr-sequencia)
                                                     + "/" + TRIM(tt-rateio-item.it-codigo) 
                                                     + "/" + tt-rateio-item.cod-estabel 
                                                     + "/" + STRING(tt-rateio-item.valor-it-nota)
                                                     + "/GKO" 
                      tt-item-doc-est.ct-codigo      = r-ct-codigo  
                      tt-item-doc-est.sc-codigo      = r-sc-codigo 
                      tt-item-doc-est.conta-contabil = TRIM(r-ct-codigo) + TRIM(r-sc-codigo)
                      tt-item-doc-est.peso-liquido   = tt-rateio-item.peso-liquido
                      tt-item-doc-est.baixa-ce       = NO
                      tt-item-doc-est.cod-unid-neg   = tt-rateio-item.cod-unid-neg.

               OVERLAY(tt-item-doc-est.char-2,819,13) = SUBSTRING(tt-docum-est.char-2,153,13).

               IF item.tipo-con-est <> 1 THEN DO:
                  FOR FIRST fat-ser-lote NO-LOCK 
                      WHERE fat-ser-lote.cod-estabel  = tt-rateio-item.cod-estabel 
                        AND fat-ser-lote.serie        = tt-rateio-item.serie       
                        AND fat-ser-lote.nr-nota-fis  = tt-rateio-item.nr-nota-fis 
                        AND fat-ser-lote.it-codigo    = tt-rateio-item.it-codigo:

                      ASSIGN tt-item-doc-est.dt-vali-lote  = fat-ser-lote.dt-vali-lote  
                             tt-item-doc-est.lote          = fat-ser-lote.nr-serlote.
                  END.
               END.
           END.
        END. /* IF CAN-FIND(FIRST */

        DO  ON ERROR UNDO, LEAVE:
            RUN rep/reapi316b.p (INPUT  "ADD",
                                 INPUT  TABLE tt-docum-est,
                                 INPUT  TABLE tt-rat-docum,
                                 INPUT  TABLE tt-item-doc-est,
                                 INPUT  TABLE tt-dupli-apagar,
                                 INPUT  TABLE tt-dupli-imp,
                                 OUTPUT TABLE tt-erro) NO-ERROR.

            IF  ERROR-STATUS:ERROR = TRUE THEN DO:
                FIND FIRST tt-erro NO-ERROR.
                FIND FIRST bfmsg-ret-nfe NO-LOCK
                     WHERE bfmsg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                       AND bfmsg-ret-nfe.idi-orig-trad      = 2
                       AND bfmsg-ret-nfe.log-ativo          = YES
                       AND bfmsg-ret-nfe.cd-msg             = tt-erro.cd-erro NO-ERROR.

                IF NOT AVAIL bfmsg-ret-nfe THEN DO:
                    CREATE msg-ret-nfe.
                    ASSIGN msg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                           msg-ret-nfe.idi-orig-trad      = 2
                           msg-ret-nfe.dt-msg             = TODAY
                           msg-ret-nfe.hr-msg             = STRING(TIME, "HH:MM:SS")
                           msg-ret-nfe.log-ativo          = YES
                           msg-ret-nfe.cd-msg             = ERROR-STATUS:GET-NUMBER(1)
                           msg-ret-nfe.texto-msg          = ERROR-STATUS:GET-MESSAGE(1)
                           msg-ret-nfe.seq-msg            = NEXT-VALUE(seq-msg-ret-nfe).
                    RELEASE msg-ret-nfe.
                END.

                /* Aborta */
                ASSIGN l-ok = NO.
            END.
            
            FOR EACH bfmsg-ret-nfe NO-LOCK
                WHERE bfmsg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                  AND bfmsg-ret-nfe.idi-orig-trad      = 2:
    
                FOR FIRST msg-ret-nfe EXCLUSIVE-LOCK
                    WHERE msg-ret-nfe.seq-msg = bfmsg-ret-nfe.seq-msg:
                    ASSIGN msg-ret-nfe.log-ativo = NO.
                END.
                RELEASE msg-ret-nfe.
            END.
            
            FOR EACH tt-erro:
                FIND FIRST bfmsg-ret-nfe NO-LOCK
                     WHERE bfmsg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                       AND bfmsg-ret-nfe.idi-orig-trad      = 2
                       AND bfmsg-ret-nfe.log-ativo          = YES
                       AND bfmsg-ret-nfe.cd-msg             = tt-erro.cd-erro NO-ERROR.

                IF NOT AVAIL bfmsg-ret-nfe THEN DO:
                    CREATE msg-ret-nfe.
                    ASSIGN msg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                           msg-ret-nfe.idi-orig-trad      = 2
                           msg-ret-nfe.dt-msg             = TODAY
                           msg-ret-nfe.hr-msg             = STRING(TIME, "HH:MM:SS")
                           msg-ret-nfe.log-ativo          = YES
                           msg-ret-nfe.cd-msg             = tt-erro.cd-erro
                           msg-ret-nfe.texto-msg          = tt-erro.desc-erro
                           msg-ret-nfe.seq-msg            = NEXT-VALUE(seq-msg-ret-nfe).
                    RELEASE msg-ret-nfe.
                END.

                /* Aborta */
                ASSIGN l-ok = NO.
            END. /* FOR EACH tt-erro */

            IF NOT CAN-FIND(FIRST tt-erro) THEN DO:
                if  not avail tt-docum-est then
                     find first tt-docum-est no-error.
                 
                 if  avail tt-docum-est then do:
                     find first natur-oper where natur-oper.nat-operacao = tt-docum-est.nat-operacao no-lock no-error.
                     
                     if avail natur-oper and natur-oper.emite-duplic then do:
                     
                         /*--- geracao de duplicatas ---*/
                         find first bf-docum-est
                              where bf-docum-est.cod-emitente = tt-docum-est.cod-emitente
                                and bf-docum-est.nat-operacao = tt-docum-est.nat-operacao
                                and bf-docum-est.nro-docto    = tt-docum-est.nro-docto   
                                and bf-docum-est.serie-docto  = tt-docum-est.serie-docto no-lock no-error.
                         if  avail bf-docum-est
                         and not can-find(first dupli-apagar
                                          where dupli-apagar.cod-emitente = tt-docum-est.cod-emitente
                                            and dupli-apagar.nat-operacao = tt-docum-est.nat-operacao
                                            and dupli-apagar.nro-docto    = tt-docum-est.nro-docto   
                                            and dupli-apagar.serie-docto  = tt-docum-est.serie-docto) then do:
                                            
                             run rep/re9341.p (rowid(bf-docum-est),no).
                             
                         end.
                         if  avail bf-docum-est THEN DO:

                             FIND FIRST int-docum-est EXCLUSIVE-LOCK 
                                  WHERE int-docum-est.serie-docto  = bf-docum-est.serie-docto
                                    AND int-docum-est.nro-docto    = bf-docum-est.nro-docto
                                    AND int-docum-est.cod-emitente = bf-docum-est.cod-emitente
                                    AND int-docum-est.nat-operacao = bf-docum-est.nat-operacao  NO-ERROR.

                             IF NOT AVAIL int-docum-est THEN DO:

                                 CREATE int-docum-est.
                                 ASSIGN int-docum-est.serie-docto   = bf-docum-est.serie-docto
                                        int-docum-est.nro-docto     = bf-docum-est.nro-docto
                                        int-docum-est.cod-emitente  = bf-docum-est.cod-emitente
                                        int-docum-est.nat-operacao  = bf-docum-est.nat-operacao.
                                        
                             END.
                             ASSIGN int-docum-est.nota-completa = YES.
                         END.

                     end.
                end.
                ASSIGN bf-docto-orig-cte.idi-situacao = 1 /* Digitada Recebimento */ .
                RELEASE bf-docto-orig-cte.
            END.
        END.
    END.
    
    IF NOT l-ok THEN DO:
        RUN atualizaSituacao (INPUT i-cod-emitente,
                              INPUT c-cod-estabel,
                              INPUT c-serie-docto,
                              INPUT c-nro-docto,
                              INPUT 2).
    END.

    IF  VALID-HANDLE(h-boin356) THEN DO:
        DELETE PROCEDURE h-boin356.
        ASSIGN h-boin356 = ?.
    END.
    
    IF VALID-HANDLE(h-acomp) THEN
       RUN pi-finalizar IN  h-acomp.

    IF NOT l-ok AND l-re0522 THEN DO:

        FOR FIRST bf-docto-orig-cte NO-LOCK 
            WHERE ROWID(bf-docto-orig-cte) = pr-nota:
                                                                         
            RUN pi-elimina-reg(INPUT bf-docto-orig-cte.cod-aces-comp-nfe).

            PUT "**************************LOG ERROS VALIDAÄ«O ESPECIFICAS***********************************" SKIP.
            FOR EACH tt-erro.                
                PUT "CHAVE CTE : " + tt-erro.identif-segment FORMAT "x(100)" SKIP 
                    STRING(tt-erro.cd-erro) +  " - " + tt-erro.desc-erro FORMAT "x(200)" SKIP.
            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-gera-docto-recebimento-complementar:

    DEF INPUT  PARAM pr-nota         AS ROWID NO-UNDO.
    DEF INPUT  PARAM pr-tipo-entrada AS CHAR  NO-UNDO.
    DEF OUTPUT PARAM l-ok            AS LOG   NO-UNDO.

    DEF VAR ch-acesso      AS CHAR                          NO-UNDO.
    DEF VAR i-cod-emitente LIKE docto-orig-cte.cod-emitente NO-UNDO.
    DEF VAR c-cod-estabel  LIKE docto-orig-cte.cod-estabel  NO-UNDO.
    DEF VAR c-serie-docto  LIKE docto-orig-cte.nro-docto    NO-UNDO.
    DEF VAR c-nro-docto    LIKE docto-orig-cte.nro-docto    NO-UNDO.
    DEF VAR r-ct-codigo    AS CHAR                          NO-UNDO.
    DEF VAR r-sc-codigo    AS CHAR                          NO-UNDO.
    DEF VAR r-un-codigo    AS CHAR                          NO-UNDO.
    DEF VAR h-boin356      AS HANDLE                        NO-UNDO.
    DEF VAR l-re0522       AS LOG                           NO-UNDO.
    DEF VAR c-item-frete   AS CHAR                          NO-UNDO.

    EMPTY TEMP-TABLE tt-docum-est.
    EMPTY TEMP-TABLE tt-item-doc-est.
    EMPTY TEMP-TABLE tt-rateio-item.
    EMPTY TEMP-TABLE tt-dupli-apagar. 
    EMPTY TEMP-TABLE tt-erro.
    EMPTY TEMP-TABLE tt-rat-docum.

    ASSIGN l-ok = YES.
    
    run utp/ut-acomp.p persistent set h-acomp.
    run pi-inicializar in h-acomp (input "Gerando RE1001").

    blocoNota:
    FOR FIRST bf-docto-orig-cte EXCLUSIVE-LOCK
        WHERE ROWID(bf-docto-orig-cte) = pr-nota:
        
        ASSIGN i-cod-emitente = bf-docto-orig-cte.cod-emitente
               c-cod-estabel  = bf-docto-orig-cte.cod-estabel
               c-serie-docto  = bf-docto-orig-cte.serie-docto
               c-nro-docto    = bf-docto-orig-cte.nro-docto.

        RUN pi-acompanhar IN h-acomp (INPUT "Processando docto: " + c-nro-docto).


        FIND FIRST emitente NO-LOCK
             WHERE emitente.cgc = bf-docto-orig-cte.cnpj-emit NO-ERROR.

        FIND FIRST estabelec NO-LOCK 
             WHERE estabelec.cod-estabel =  c-cod-estabel  NO-ERROR.

        IF NOT AVAIL emitente THEN DO:           
            {utp/ut-liter.i "fornecedor_com_o_CNPJ_do_conhecimento_de_transporte" *}
            RUN utp/ut-msgs.p (INPUT "MSG":U,
                               INPUT 32099,
                               INPUT RETURN-VALUE).

            ASSIGN texto-msg  = RETURN-VALUE.

            FIND FIRST msg-ret-nfe NO-LOCK
                 WHERE msg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                   AND msg-ret-nfe.idi-orig-trad      = 2
                   AND msg-ret-nfe.log-ativo          = YES
                   AND msg-ret-nfe.cd-msg             = 32099 NO-ERROR.
            IF NOT AVAIL msg-ret-nfe THEN DO:
                CREATE msg-ret-nfe.
                ASSIGN msg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                       msg-ret-nfe.idi-orig-trad      = 2
                       msg-ret-nfe.dt-msg             = TODAY
                       msg-ret-nfe.hr-msg             = STRING(TIME, "HH:MM:SS")
                       msg-ret-nfe.log-ativo          = YES
                       msg-ret-nfe.cd-msg             = 32099
                       msg-ret-nfe.texto-msg          = texto-msg
                       msg-ret-nfe.seq-msg            = NEXT-VALUE(seq-msg-ret-nfe).

                RUN pi-grava-erro(INPUT 17006,
                                  INPUT texto-msg,
                                  INPUT bf-docto-orig-cte.cod-aces-comp-nfe).

                RELEASE msg-ret-nfe.
            END.

            /* Aborta */
            ASSIGN l-ok = NO.
            LEAVE blocoNota.
        END.
        ELSE /* Fornecedor Emite Documento Eletronico */
            IF (NOT emitente.log-nf-eletro        AND emitente.identific <> 2)
            OR (NOT emitente.log-possui-nf-eletro AND emitente.identific <> 1) THEN DO:
                FIND CURRENT emitente EXCLUSIVE-LOCK NO-ERROR.
                ASSIGN emitente.log-nf-eletro        = YES WHEN emitente.identific <> 2
                       emitente.log-possui-nf-eletro = YES WHEN emitente.identific <> 1.
                FIND CURRENT emitente NO-LOCK NO-ERROR.
            END.

        IF emitente.cod-cond-pag = 0 THEN DO:
            {utp/ut-liter.i "Condiá∆o_de_pagamento_n∆o_definida_no_transportador" *}
            RUN utp/ut-msgs.p (INPUT "MSG":U,
                               INPUT 17006,
                               INPUT RETURN-VALUE).

            ASSIGN texto-msg  = RETURN-VALUE.

            FIND FIRST msg-ret-nfe NO-LOCK
                 WHERE msg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                   AND msg-ret-nfe.idi-orig-trad      = 2
                   AND msg-ret-nfe.log-ativo          = YES
                   AND msg-ret-nfe.cd-msg             = 17012 NO-ERROR.
            IF NOT AVAIL msg-ret-nfe THEN DO:
                CREATE msg-ret-nfe.
                ASSIGN msg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                       msg-ret-nfe.idi-orig-trad      = 2
                       msg-ret-nfe.dt-msg             = TODAY
                       msg-ret-nfe.hr-msg             = STRING(TIME, "HH:MM:SS")
                       msg-ret-nfe.log-ativo          = YES
                       msg-ret-nfe.cd-msg             = 17012
                       msg-ret-nfe.texto-msg          = texto-msg
                       msg-ret-nfe.seq-msg            = NEXT-VALUE(seq-msg-ret-nfe).

                RUN pi-grava-erro(INPUT 17006,
                                  INPUT texto-msg,
                                  INPUT bf-docto-orig-cte.cod-aces-comp-nfe).

                RELEASE msg-ret-nfe.            
            END.

            /* Aborta */
            ASSIGN l-ok = NO.
            LEAVE blocoNota.
        END.
                                                                           
        FIND FIRST natur-oper NO-LOCK
             WHERE natur-oper.nat-operacao = bf-docto-orig-cte.nat-operacao NO-ERROR.
             
        IF  NOT AVAIL natur-oper THEN DO:
            FIND FIRST bfmsg-ret-nfe NO-LOCK
                 WHERE bfmsg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                   AND bfmsg-ret-nfe.idi-orig-trad      = 2
                   AND bfmsg-ret-nfe.log-ativo          = YES
                   AND bfmsg-ret-nfe.cd-msg             = 17006 NO-ERROR.
            IF NOT AVAIL bfmsg-ret-nfe THEN DO:      
                {utp/ut-liter.i "Natureza_Operaªío" *}
                RUN utp/ut-msgs.p (INPUT "MSG":U,
                                   INPUT 2, /* Nao encontrada natureza de operacao para a chave informada */
                                   INPUT RETURN-VALUE).

                ASSIGN texto-msg  = RETURN-VALUE.
                CREATE msg-ret-nfe.
                ASSIGN msg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                       msg-ret-nfe.idi-orig-trad      = 2
                       msg-ret-nfe.dt-msg             = TODAY
                       msg-ret-nfe.hr-msg             = STRING(TIME, "HH:MM:SS")
                       msg-ret-nfe.log-ativo          = YES
                       msg-ret-nfe.cd-msg             = 17006
                       msg-ret-nfe.texto-msg          = texto-msg
                       msg-ret-nfe.seq-msg            = NEXT-VALUE(seq-msg-ret-nfe).

                RUN pi-grava-erro(INPUT 17006,
                                  INPUT texto-msg,
                                  INPUT bf-docto-orig-cte.cod-aces-comp-nfe).

                RELEASE msg-ret-nfe.
            END.

            /* Aborta */
            ASSIGN l-ok = NO.
            LEAVE blocoNota.
        END.
                                                                           
        /*******cria a capa do docto re1001*/

        RUN createTT-docum-est.                 
                                                  
        FIND FIRST unid-feder
             WHERE unid-feder.cod-uf-ibge = substring(bf-docto-orig-cte.cod-livre-1,21,2) /* Origem */
             NO-LOCK NO-ERROR.
        FIND FIRST b-unid-feder
             WHERE b-unid-feder.cod-uf-ibge = substring(bf-docto-orig-cte.cod-livre-1,31,2) /* Destino */
             NO-LOCK NO-ERROR.

        IF NOT AVAIL unid-feder OR NOT AVAIL b-unid-feder THEN DO:
            FIND FIRST bfmsg-ret-nfe NO-LOCK
                 WHERE bfmsg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                   AND bfmsg-ret-nfe.idi-orig-trad      = 2
                   AND bfmsg-ret-nfe.log-ativo          = YES
                   AND bfmsg-ret-nfe.cd-msg             = 17011 NO-ERROR.
            IF NOT AVAIL bfmsg-ret-nfe THEN DO:
                {utp/ut-liter.i "Item_da_Nota" *}
                RUN utp/ut-msgs.p (INPUT "MSG":U,
                                   INPUT 2,
                                   INPUT RETURN-VALUE).
                ASSIGN texto-msg  = RETURN-VALUE + " N∆o foi poss°vel definir o item de frete para UF origem "
                                                 + substr(bf-docto-orig-cte.cod-livre-1,21,2) 
                                                 + " e UF destino " + substr(bf-docto-orig-cte.cod-livre-1,31,2).
                CREATE msg-ret-nfe.
                ASSIGN msg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                       msg-ret-nfe.idi-orig-trad      = 2
                       msg-ret-nfe.dt-msg             = TODAY
                       msg-ret-nfe.hr-msg             = STRING(TIME, "HH:MM:SS")
                       msg-ret-nfe.log-ativo          = YES
                       msg-ret-nfe.cd-msg             = 17011
                       msg-ret-nfe.texto-msg          = texto-msg
                       msg-ret-nfe.seq-msg            = NEXT-VALUE(seq-msg-ret-nfe).

                RUN pi-grava-erro(INPUT 17006,
                                  INPUT texto-msg,
                                  INPUT bf-docto-orig-cte.cod-aces-comp-nfe).

                RELEASE msg-ret-nfe.
            END.

            /* Aborta */
            ASSIGN l-ok = NO.
            LEAVE blocoNota.
        END.

        RUN pi-busca-item-frete(INPUT  unid-feder.estado,
                                INPUT  b-unid-feder.estado,
                                OUTPUT c-item-frete).

        IF c-item-frete = "" THEN DO:
            FIND FIRST bfmsg-ret-nfe NO-LOCK
                 WHERE bfmsg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                   AND bfmsg-ret-nfe.idi-orig-trad      = 2
                   AND bfmsg-ret-nfe.log-ativo          = YES
                   AND bfmsg-ret-nfe.cd-msg             = 17010 NO-ERROR.
            IF NOT AVAIL bfmsg-ret-nfe THEN DO:      
                {utp/ut-liter.i "Item_da_Nota" *}
                RUN utp/ut-msgs.p (INPUT "MSG":U,
                                   INPUT 2, /* Nao encontrada natureza de operacao para a chave informada */
                                   INPUT RETURN-VALUE).

                ASSIGN texto-msg  = RETURN-VALUE + " N∆o tem traduá∆o".
                CREATE msg-ret-nfe.
                ASSIGN msg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                       msg-ret-nfe.idi-orig-trad      = 2
                       msg-ret-nfe.dt-msg             = TODAY
                       msg-ret-nfe.hr-msg             = STRING(TIME, "HH:MM:SS")
                       msg-ret-nfe.log-ativo          = YES
                       msg-ret-nfe.cd-msg             = 17010
                       msg-ret-nfe.texto-msg          = texto-msg
                       msg-ret-nfe.seq-msg            = NEXT-VALUE(seq-msg-ret-nfe).

                RUN pi-grava-erro(INPUT 17006,
                                  INPUT texto-msg,
                                  INPUT bf-docto-orig-cte.cod-aces-comp-nfe).

                RELEASE msg-ret-nfe.
            END.

            /* Aborta */
            ASSIGN l-ok = NO.
            LEAVE blocoNota.
        END.

       ASSIGN i-sequencia = 0
              r-ct-codigo = "11910160"
              r-sc-codigo = ""
              r-un-codigo = "ADM".
                                                          
       ASSIGN c-nat-oper  = bf-docto-orig-cte.nat-operacao.       
              i-sequencia = i-sequencia + 20.

       FIND FIRST natur-oper NO-LOCK
            WHERE natur-oper.nat-operacao = bf-docto-orig-cte.nat-operacao NO-ERROR.
                                                                                        
       CREATE tt-item-doc-est.
       ASSIGN tt-item-doc-est.cod-emitente   = i-cod-emitente
              tt-item-doc-est.nat-operacao   = bf-docto-orig-cte.nat-operacao
              tt-item-doc-est.nat-of         = c-nat-oper
              tt-item-doc-est.nro-docto      = c-nro-docto
              tt-item-doc-est.serie-docto    = c-serie-docto 
              tt-item-doc-est.it-codigo      = c-item-frete
              tt-item-doc-est.preco-unit[1]  = bf-docto-orig-cte.val-tot-mercad
              tt-item-doc-est.quantidade     = 1
              tt-item-doc-est.sequencia      = i-sequencia 
              tt-item-doc-est.narrativa      = ""
              tt-item-doc-est.cd-trib-icm    = natur-oper.cd-trib-icm
              tt-item-doc-est.num-pedido     = 0
              tt-item-doc-est.numero-ordem   = 0
              tt-item-doc-est.int-1          = 0
              tt-item-doc-est.parcela        = 0
              tt-item-doc-est.encerra-pa     = NO
              tt-item-doc-est.narrativa      = "CTE COMPLEMENTAR/GKO" 
              tt-item-doc-est.ct-codigo      = r-ct-codigo  
              tt-item-doc-est.sc-codigo      = r-sc-codigo 
              tt-item-doc-est.conta-contabil = TRIM(r-ct-codigo) + TRIM(r-sc-codigo)
              tt-item-doc-est.peso-liquido   = 0
              tt-item-doc-est.baixa-ce       = NO
              tt-item-doc-est.cod-unid-neg   = r-un-codigo.

       OVERLAY(tt-item-doc-est.char-2,819,13) = SUBSTRING(tt-docum-est.char-2,153,13).

       DO ON ERROR UNDO, LEAVE:
            RUN rep/reapi316b.p (INPUT  "ADD",
                                 INPUT  TABLE tt-docum-est,
                                 INPUT  TABLE tt-rat-docum,
                                 INPUT  TABLE tt-item-doc-est,
                                 INPUT  TABLE tt-dupli-apagar,
                                 INPUT  TABLE tt-dupli-imp,
                                 OUTPUT TABLE tt-erro) NO-ERROR.

            IF  ERROR-STATUS:ERROR = TRUE THEN DO:
                FIND FIRST tt-erro NO-ERROR.
                FIND FIRST bfmsg-ret-nfe NO-LOCK
                     WHERE bfmsg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                       AND bfmsg-ret-nfe.idi-orig-trad      = 2
                       AND bfmsg-ret-nfe.log-ativo          = YES
                       AND bfmsg-ret-nfe.cd-msg             = tt-erro.cd-erro NO-ERROR.

                IF NOT AVAIL bfmsg-ret-nfe THEN DO:
                    CREATE msg-ret-nfe.
                    ASSIGN msg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                           msg-ret-nfe.idi-orig-trad      = 2
                           msg-ret-nfe.dt-msg             = TODAY
                           msg-ret-nfe.hr-msg             = STRING(TIME, "HH:MM:SS")
                           msg-ret-nfe.log-ativo          = YES
                           msg-ret-nfe.cd-msg             = ERROR-STATUS:GET-NUMBER(1)
                           msg-ret-nfe.texto-msg          = ERROR-STATUS:GET-MESSAGE(1)
                           msg-ret-nfe.seq-msg            = NEXT-VALUE(seq-msg-ret-nfe).
                    RELEASE msg-ret-nfe.
                END.

                /* Aborta */
                ASSIGN l-ok = NO.
            END.
            
            FOR EACH bfmsg-ret-nfe NO-LOCK
                WHERE bfmsg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                  AND bfmsg-ret-nfe.idi-orig-trad      = 2:
    
                FOR FIRST msg-ret-nfe EXCLUSIVE-LOCK
                    WHERE msg-ret-nfe.seq-msg = bfmsg-ret-nfe.seq-msg:
                    ASSIGN msg-ret-nfe.log-ativo = NO.
                END.
                RELEASE msg-ret-nfe.
            END.
            
            FOR EACH tt-erro:
                FIND FIRST bfmsg-ret-nfe NO-LOCK
                     WHERE bfmsg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                       AND bfmsg-ret-nfe.idi-orig-trad      = 2
                       AND bfmsg-ret-nfe.log-ativo          = YES
                       AND bfmsg-ret-nfe.cd-msg             = tt-erro.cd-erro NO-ERROR.

                IF NOT AVAIL bfmsg-ret-nfe THEN DO:
                    CREATE msg-ret-nfe.
                    ASSIGN msg-ret-nfe.ch-acesso-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
                           msg-ret-nfe.idi-orig-trad      = 2
                           msg-ret-nfe.dt-msg             = TODAY
                           msg-ret-nfe.hr-msg             = STRING(TIME, "HH:MM:SS")
                           msg-ret-nfe.log-ativo          = YES
                           msg-ret-nfe.cd-msg             = tt-erro.cd-erro
                           msg-ret-nfe.texto-msg          = tt-erro.desc-erro
                           msg-ret-nfe.seq-msg            = NEXT-VALUE(seq-msg-ret-nfe).
                    RELEASE msg-ret-nfe.
                END.

                /* Aborta */
                ASSIGN l-ok = NO.
            END. /* FOR EACH tt-erro */

            IF NOT CAN-FIND(FIRST tt-erro) THEN DO:
                if  not avail tt-docum-est then
                     find first tt-docum-est no-error.
                 
                 if  avail tt-docum-est then do:
                     find first natur-oper where natur-oper.nat-operacao = tt-docum-est.nat-operacao no-lock no-error.
                     
                     if avail natur-oper and natur-oper.emite-duplic then do:
                     
                         /*--- geracao de duplicatas ---*/
                         find first bf-docum-est
                              where bf-docum-est.cod-emitente = tt-docum-est.cod-emitente
                                and bf-docum-est.nat-operacao = tt-docum-est.nat-operacao
                                and bf-docum-est.nro-docto    = tt-docum-est.nro-docto   
                                and bf-docum-est.serie-docto  = tt-docum-est.serie-docto no-lock no-error.
                         if  avail bf-docum-est
                         and not can-find(first dupli-apagar
                                          where dupli-apagar.cod-emitente = tt-docum-est.cod-emitente
                                            and dupli-apagar.nat-operacao = tt-docum-est.nat-operacao
                                            and dupli-apagar.nro-docto    = tt-docum-est.nro-docto   
                                            and dupli-apagar.serie-docto  = tt-docum-est.serie-docto) then do:
                                            
                             run rep/re9341.p (rowid(bf-docum-est),no).
                             
                         end.
                         if  avail bf-docum-est THEN DO:

                             FIND FIRST int-docum-est EXCLUSIVE-LOCK 
                                  WHERE int-docum-est.serie-docto  = bf-docum-est.serie-docto
                                    AND int-docum-est.nro-docto    = bf-docum-est.nro-docto
                                    AND int-docum-est.cod-emitente = bf-docum-est.cod-emitente
                                    AND int-docum-est.nat-operacao = bf-docum-est.nat-operacao  NO-ERROR.

                             IF NOT AVAIL int-docum-est THEN DO:

                                 CREATE int-docum-est.
                                 ASSIGN int-docum-est.serie-docto   = bf-docum-est.serie-docto
                                        int-docum-est.nro-docto     = bf-docum-est.nro-docto
                                        int-docum-est.cod-emitente  = bf-docum-est.cod-emitente
                                        int-docum-est.nat-operacao  = bf-docum-est.nat-operacao.
                                        
                             END.
                             ASSIGN int-docum-est.nota-completa = YES.
                         END.

                     end.
                end.
                ASSIGN bf-docto-orig-cte.idi-situacao = 1 /* Digitada Recebimento */ .
                RELEASE bf-docto-orig-cte.
            END.
       END.
    END.
    
    IF NOT l-ok THEN DO:
        RUN atualizaSituacao (INPUT i-cod-emitente,
                              INPUT c-cod-estabel,
                              INPUT c-serie-docto,
                              INPUT c-nro-docto,
                              INPUT 2).
    END.

    IF  VALID-HANDLE(h-boin356) THEN DO:
        DELETE PROCEDURE h-boin356.
        ASSIGN h-boin356 = ?.
    END.
    
    IF VALID-HANDLE(h-acomp) THEN
       RUN pi-finalizar IN  h-acomp.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-rateia-nota:

    DEF INPUT PARAMETER p-valor-frete AS DEC  NO-UNDO.
    DEF INPUT PARAMETER p-cod-estabel AS CHAR NO-UNDO. 
    
    DEF BUFFER emitente  FOR emitente.
    DEF BUFFER estabelec FOR estabelec.
    
    DEF VAR l-peso-bruto AS DEC  NO-UNDO.
    
    ASSIGN de-nota-peso-liq-tot = 0.
    
    FOR EACH rat-docto-orig-cte NO-LOCK 
        WHERE rat-docto-orig-cte.cod-aces-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
          AND rat-docto-orig-cte.idi-orig-trad     = 1:
    
        ASSIGN c-chave  = TRIM(SUBSTRING(rat-docto-orig-cte.cod-livre-1,1,50))
               c-serie  = SUBSTRING(TRIM(SUBSTRING(rat-docto-orig-cte.cod-livre-1,1,50)),23,3)
               c-nota   = SUBSTRING(TRIM(SUBSTRING(rat-docto-orig-cte.cod-livre-1,1,50)),28,7)
               c-anomes = SUBSTRING(TRIM(SUBSTRING(rat-docto-orig-cte.cod-livre-1,1,50)),3,4).
               c-cnpj   = SUBSTRING(TRIM(SUBSTRING(rat-docto-orig-cte.cod-livre-1,1,50)),7,14).
    
        ASSIGN i-serie = INT(c-serie)
               c-serie = STRING(i-serie).
    
        ASSIGN c-estab-ini   = "".
        FOR FIRST estabelec NO-LOCK 
         WHERE estabelec.cgc = c-cnpj:
    
           ASSIGN c-estab-ini = estabelec.cod-estabel. 
        END.
    
        FOR EACH nota-fiscal NO-LOCK 
             WHERE nota-fiscal.cod-estabel  = c-estab-ini
               AND nota-fiscal.serie        = c-serie 
               AND nota-fiscal.nr-nota-fis  = c-nota:
                                                                                                         
            ASSIGN c-ano-mes-aux = SUBSTRING(STRING(YEAR(nota-fiscal.dt-emis-nota),"9999"),3,2) + STRING(MONTH(nota-fiscal.dt-emis-nota),"99").
    
            IF c-anomes <> c-ano-mes-aux  THEN NEXT.
    
            CREATE tt-notas-nfe.
            ASSIGN tt-notas-nfe.cod-estabel              = nota-fiscal.cod-estabel   
                   tt-notas-nfe.serie                    = nota-fiscal.serie         
                   tt-notas-nfe.nr-nota-fis              = nota-fiscal.nr-nota-fis   
                   tt-notas-nfe.ano-mes                  = c-anomes
                   tt-notas-nfe.cod-chave-aces-nf-eletro = nota-fiscal.cod-chave-aces-nf-eletro.
        END.
    
    
    END.
    
    FOR EACH rat-docto-orig-cte NO-LOCK 
        WHERE rat-docto-orig-cte.cod-aces-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
          AND rat-docto-orig-cte.idi-orig-trad     = 1:
    
        FOR EACH tt-notas-nfe 
            WHERE tt-notas-nfe.cod-chave-aces-nf-eletro = TRIM(SUBSTRING(rat-docto-orig-cte.cod-livre-1,1,50)),
            EACH nota-fiscal NO-LOCK 
            WHERE nota-fiscal.cod-estabel  = tt-notas-nfe.cod-estabel
              AND nota-fiscal.serie        = tt-notas-nfe.serie      
              AND nota-fiscal.nr-nota-fis  = tt-notas-nfe.nr-nota-fis:

            FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
                /* 16/10/2023 - Controle de peso ser pelo menos uma grama */
                ASSIGN l-peso-bruto = it-nota-fisc.peso-bruto.                
                IF (l-peso-bruto < 0.001) THEN DO:
                    ASSIGN l-peso-bruto = 0.001.
                END.
            
                ASSIGN de-nota-peso-liq-tot = de-nota-peso-liq-tot + l-peso-bruto. /*2-(ITEM.peso-liquido * it-nota-fisc.qt-faturada[1]). 1-it-nota-fisc.peso-liq-fat.*/
            END.
    
        END.
    END.
    
    FOR EACH rat-docto-orig-cte NO-LOCK 
        WHERE rat-docto-orig-cte.cod-aces-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
          AND rat-docto-orig-cte.idi-orig-trad     = 1,
        EACH tt-notas-nfe 
        WHERE tt-notas-nfe.cod-chave-aces-nf-eletro = TRIM(SUBSTRING(rat-docto-orig-cte.cod-livre-1,1,50)),
        EACH nota-fiscal NO-LOCK 
        WHERE nota-fiscal.cod-estabel  = tt-notas-nfe.cod-estabel
          AND nota-fiscal.serie        = tt-notas-nfe.serie      
          AND nota-fiscal.nr-nota-fis  = tt-notas-nfe.nr-nota-fis:
    
        FOR FIRST emitente FIELDS(cod-emitente estado) NO-LOCK 
            WHERE emitente.cod-emitente = nota-fiscal.cod-emitente:
        END.
    
        FOR FIRST estabelec FIELDS(cod-estabel estado) NO-LOCK 
            WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel.
        END.
    
        FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
            
            /* 16/10/2023 - Controle de peso ser pelo menos uma grama */
            ASSIGN l-peso-bruto = it-nota-fisc.peso-bruto.                
            IF (l-peso-bruto < 0.001) THEN DO:
                ASSIGN l-peso-bruto = 0.001.
            END.
    
            CREATE tt-rateio-item.
            ASSIGN tt-rateio-item.nr-sequencia     = it-nota-fisc.nr-seq-fat
                   tt-rateio-item.it-codigo        = it-nota-fisc.it-codigo
                   tt-rateio-item.cod-canal-venda  = nota-fiscal.cod-canal-venda
                   tt-rateio-item.cod-estabel      = nota-fiscal.cod-estabel
                   tt-rateio-item.cod-unid-negoc   = it-nota-fisc.cod-unid-negoc 
                   tt-rateio-item.nat-operacao     = it-nota-fisc.nat-operacao
                   tt-rateio-item.serie            = nota-fiscal.serie
                   tt-rateio-item.cod-emitente     = nota-fiscal.cod-emitente
                   tt-rateio-item.nr-nota-fis      = nota-fiscal.nr-nota-fis
                   tt-rateio-item.peso-liquido     = l-peso-bruto
                   tt-rateio-item.uf-origem        = estabelec.estado
                   tt-rateio-item.uf-destino       = bf-docto-orig-cte.cod-uf-dest
                   tt-rateio-item.valor-it-nota    = it-nota-fisc.vl-tot-item.
    
            ASSIGN tt-rateio-item.valor-frete = ROUND((p-valor-frete / de-nota-peso-liq-tot) * l-peso-bruto, 2).
    
            IF tt-rateio-item.valor-frete < 0.01 THEN ASSIGN tt-rateio-item.valor-frete = 0.01.
        END.
    END.
    
    IF NOT CAN-FIND(FIRST tt-rateio-item) THEN DO:
    
        ASSIGN de-nota-peso-liq-tot = 0.
    
        FOR EACH rat-docto-orig-cte NO-LOCK 
            WHERE rat-docto-orig-cte.cod-aces-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
              AND rat-docto-orig-cte.idi-orig-trad     = 1:

            ASSIGN c-chave  = TRIM(SUBSTRING(rat-docto-orig-cte.cod-livre-1,1,50))
                   c-serie  = SUBSTRING(TRIM(SUBSTRING(rat-docto-orig-cte.cod-livre-1,1,50)),23,3)
                   c-nota   = SUBSTRING(TRIM(SUBSTRING(rat-docto-orig-cte.cod-livre-1,1,50)),28,7)
                   c-anomes = SUBSTRING(TRIM(SUBSTRING(rat-docto-orig-cte.cod-livre-1,1,50)),3,4)
                   c-cnpj   = SUBSTRING(TRIM(SUBSTRING(rat-docto-orig-cte.cod-livre-1,1,50)),7,14).
    
            ASSIGN i-serie = INT(c-serie)
                   c-serie = STRING(i-serie).

            FOR FIRST docum-est NO-LOCK
                WHERE docum-est.cod-chave-aces-nf-eletro = c-chave:                                
                FOR EACH item-doc-est NO-LOCK OF docum-est:
                    ASSIGN de-nota-peso-liq-tot = de-nota-peso-liq-tot + item-doc-est.peso-liquido.
                END.
            END.
        END.

        FOR EACH rat-docto-orig-cte NO-LOCK 
            WHERE rat-docto-orig-cte.cod-aces-comp-nfe = bf-docto-orig-cte.cod-aces-comp-nfe
              AND rat-docto-orig-cte.idi-orig-trad     = 1:

            ASSIGN c-chave  = TRIM(SUBSTRING(rat-docto-orig-cte.cod-livre-1,1,50))
                   c-serie  = SUBSTRING(TRIM(SUBSTRING(rat-docto-orig-cte.cod-livre-1,1,50)),23,3)
                   c-nota   = SUBSTRING(TRIM(SUBSTRING(rat-docto-orig-cte.cod-livre-1,1,50)),28,7)
                   c-anomes = SUBSTRING(TRIM(SUBSTRING(rat-docto-orig-cte.cod-livre-1,1,50)),3,4)
                   c-cnpj   = SUBSTRING(TRIM(SUBSTRING(rat-docto-orig-cte.cod-livre-1,1,50)),7,14).

            ASSIGN i-serie = INT(c-serie)
                   c-serie = STRING(i-serie).

            FOR FIRST docum-est NO-LOCK
                WHERE docum-est.cod-chave-aces-nf-eletro = c-chave:
    
                FOR FIRST emitente FIELDS(cod-emitente estado) NO-LOCK 
                    WHERE emitente.cod-emitente = docum-est.cod-emitente:
                END.
    
                FOR FIRST estabelec FIELDS(cod-estabel estado) NO-LOCK 
                    WHERE estabelec.cod-estabel = docum-est.cod-estabel.
                END.
    
                FOR EACH item-doc-est NO-LOCK OF docum-est:
    
                    FOR FIRST ITEM FIELDS(cod-unid-neg it-codigo) NO-LOCK 
                        WHERE ITEM.it-codigo = item-doc-est.it-codigo.
                    END.
    
                    CREATE tt-rateio-item.
                    ASSIGN tt-rateio-item.nr-sequencia     = item-doc-est.sequencia 
                           tt-rateio-item.it-codigo        = item-doc-est.it-codigo
                           tt-rateio-item.cod-canal-venda  = 0
                           tt-rateio-item.cod-estabel      = docum-est.cod-estabel
                           tt-rateio-item.cod-unid-negoc   = IF item-doc-est.cod-unid-negoc <> "" THEN item-doc-est.cod-unid-negoc ELSE ITEM.cod-unid-neg
                           tt-rateio-item.nat-operacao     = docum-est.nat-operacao
                           tt-rateio-item.serie            = docum-est.serie-docto
                           tt-rateio-item.cod-emitente     = docum-est.cod-emitente
                           tt-rateio-item.nr-nota-fis      = docum-est.nro-docto
                           tt-rateio-item.peso-liquido     = item-doc-est.peso-liquido
                           tt-rateio-item.uf-origem        = bf-docto-orig-cte.cod-uf-emit
                           tt-rateio-item.uf-destino       = estabelec.estado
                           tt-rateio-item.valor-it-nota    = item-doc-est.preco-total[1].
    
                    ASSIGN tt-rateio-item.valor-frete = ROUND((p-valor-frete / de-nota-peso-liq-tot) * item-doc-est.peso-liquido, 2).
    
                    IF tt-rateio-item.valor-frete < 0.01 THEN
                       ASSIGN tt-rateio-item.valor-frete = 0.01.
    
                END.
            END.
        END.
    END.
    DEF VAR de-tot-frete AS DEC NO-UNDO.
    DEF VAR de-tot-dif   AS DEC NO-UNDO.
    
    
    ASSIGN de-tot-frete = 0.
    FOR EACH tt-rateio-item:
        //WHERE tt-rateio-item.it-codigo <> "":
    
        ASSIGN de-tot-frete = de-tot-frete + tt-rateio-item.valor-frete.
    
    END.
    IF de-tot-frete < p-valor-frete  THEN
       ASSIGN de-tot-dif = (p-valor-frete - de-tot-frete).
    ELSE 
        ASSIGN de-tot-dif = (p-valor-frete - de-tot-frete).
    
    
    IF de-tot-dif <> 0 THEN DO:
        
        FOR FIRST tt-rateio-item
            WHERE /*tt-rateio-item.it-codigo <> ""
              AND*/ tt-rateio-item.valor-frete > ABS(de-tot-dif):
    
            ASSIGN tt-rateio-item.valor-frete = tt-rateio-item.valor-frete + de-tot-dif.
        END.
    END.


END PROCEDURE.

PROCEDURE createTT-docum-est:

    DEF VAR c-tip-cte      AS CHAR NO-UNDO.

    DEF BUFFER cidade FOR mgcad.cidade.

    IF NOT VALID-HANDLE(h-boin862) /* -> BO param-convrsr-nfe */
    OR h-boin862:TYPE      <> "PROCEDURE":U 
    OR h-boin862:FILE-NAME <> "inbo/boin862.p":U THEN
        RUN inbo/boin862.p PERSISTENT SET h-boin862.
    
    RUN openQueryStatic IN h-boin862 (INPUT "Main":U) NO-ERROR.
    RUN getFirst IN h-boin862.
    IF  RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    ELSE DO:
        RUN getLogField IN h-boin862 (INPUT "log-altera-dat-trans":U, OUTPUT l-altera-dt-trans).
    END.   

    IF  VALID-HANDLE(h-boin862)        AND
        h-boin862:TYPE = "PROCEDURE":U AND
        h-boin862:FILE-NAME = "inbo/boin862.p":U THEN DO:
        DELETE PROCEDURE h-boin862.
        ASSIGN h-boin862 = ?.
    END.    

    IF  l-altera-dt-trans THEN DO:  /*verifica parÉmetro RE0119*/
        ASSIGN bf-docto-orig-cte.dt-trans = TODAY.
    END.
    
    CREATE tt-docum-est.
    ASSIGN tt-docum-est.nro-docto    = bf-docto-orig-cte.nro-docto
           tt-docum-est.nat-operacao = bf-docto-orig-cte.nat-operacao
           tt-docum-est.serie-docto  = bf-docto-orig-cte.serie-docto
           tt-docum-est.cod-emitente = bf-docto-orig-cte.cod-emitente
           tt-docum-est.cod-estabel  = bf-docto-orig-cte.cod-estabel
           tt-docum-est.cod-observa  = 1
           tt-docum-est.dt-trans     = bf-docto-orig-cte.dt-trans 
           tt-docum-est.valor-mercad = bf-docto-orig-cte.val-tot-mercad
           tt-docum-est.tipo-nota    = 1 /* nota de rateio */
           tt-docum-est.via-transp   = bf-docto-orig-cte.cdn-modalid-frete
           tt-docum-est.usuario      = c-seg-usuario
           tt-docum-est.dt-emissao   = bf-docto-orig-cte.dt-emissao
   OVERLAY(tt-docum-est.char-2,153,13) = string(bf-docto-orig-cte.val-livre-1).

    &IF '{&bf_mat_versao_ems}' > '2.08' &THEN
        ASSIGN tt-docum-est.cod-item-serv   = bf-docto-orig-cte.cod-item-serv.
    &ELSE
        ASSIGN OVERLAY(tt-docum-est.char-1,176,16)   = bf-docto-orig-cte.cod-item-serv.
    &ENDIF
    
    &IF "{&bf_mat_versao_ems}" < "2.07" &THEN
        ASSIGN OVERLAY(tt-docum-est.char-1,93,60) = bf-docto-orig-cte.cod-aces-comp-nfe
               OVERLAY(tt-docum-est.char-1,153,1) = "1".
    &ELSE
        ASSIGN tt-docum-est.cod-chave-aces-nf-eletro = bf-docto-orig-cte.cod-aces-comp-nfe
               tt-docum-est.cdn-sit-nfe              = 1.
    &ENDIF
    ASSIGN c-tip-cte = "".
    CASE bf-docto-orig-cte.tp-nf:
        WHEN "0" THEN ASSIGN c-tip-cte = "1".
        WHEN "1" THEN ASSIGN c-tip-cte = "2".
        WHEN "2" THEN ASSIGN c-tip-cte = "3".
        WHEN "3" THEN ASSIGN c-tip-cte = "4".

    END CASE.
    ASSIGN tt-docum-est.cod-chave-aces-nf-eletro = bf-docto-orig-cte.cod-aces-comp-nfe
           tt-docum-est.cdn-sit-nfe              = 1.

    ASSIGN OVERLAY(tt-docum-est.char-2,151,2) = c-tip-cte.

    FOR FIRST cidade NO-LOCK
        WHERE cidade.cidade = bf-docto-orig-cte.cod-munpio-emit
          AND cidade.estado = bf-docto-orig-cte.cod-uf-emit:
        ASSIGN tt-docum-est.pais = cidade.pais.
    END.
    
    ASSIGN tt-docum-est.cod-placa[1] = bf-docto-orig-cte.cod-placa
           tt-docum-est.bairro       = bf-docto-orig-cte.cod-bairro-emit
           tt-docum-est.cidade       = bf-docto-orig-cte.cod-munpio-emit
           tt-docum-est.endereco     = bf-docto-orig-cte.cod-lograd-emit + ", " + bf-docto-orig-cte.num-end-emit
           tt-docum-est.mod-frete    = bf-docto-orig-cte.cdn-modalid-frete.
    
    FOR FIRST emitente FIELDS (cgc)
        WHERE emitente.cod-emitente = bf-docto-orig-cte.cod-emitente NO-LOCK:

        FOR FIRST transporte FIELDS (nome-abrev)
            WHERE transporte.cgc = emitente.cgc NO-LOCK:

            ASSIGN tt-docum-est.nome-transp = transporte.nome-abrev.

        END.
    END.

    ASSIGN OVERLAY(tt-docum-est.char-2,236,10)= SUBSTRING(bf-docto-orig-cte.cod-livre-1,31,10) /*CΩd IBGE Munic Dest*/
           OVERLAY(tt-docum-est.char-2,246,10)= SUBSTRING(bf-docto-orig-cte.cod-livre-1,21,10) /*CΩd IBGE Munic Orig*/
           OVERLAY(tt-docum-est.char-2,211,2) = SUBSTRING(bf-docto-orig-cte.cod-livre-1,41,2). /*UF Orig/Dest GIA SP*/

END PROCEDURE.

PROCEDURE atualizaSituacao :

    DEF INPUT PARAM i-cod-emitente LIKE docto-orig-cte.cod-emitente NO-UNDO.
    DEF INPUT PARAM c-cod-estabel  LIKE docto-orig-cte.cod-estabel  NO-UNDO.
    DEF INPUT PARAM c-serie-docto  LIKE docto-orig-cte.nro-docto    NO-UNDO.
    DEF INPUT PARAM c-nro-docto    LIKE docto-orig-cte.nro-docto    NO-UNDO.
    DEF INPUT PARAM i-situacao     AS INTEGER                       NO-UNDO.

    FIND FIRST bf-docto-orig-cte EXCLUSIVE-LOCK
         WHERE bf-docto-orig-cte.cod-emitente  = i-cod-emitente
           AND bf-docto-orig-cte.cod-estabel   = c-cod-estabel
           AND bf-docto-orig-cte.serie-docto   = c-serie-docto
           AND bf-docto-orig-cte.nro-docto     = c-nro-docto
           AND bf-docto-orig-cte.idi-orig-trad = 2 NO-ERROR.

    IF AVAIL bf-docto-orig-cte THEN
        ASSIGN bf-docto-orig-cte.idi-situacao = i-situacao.

    RELEASE bf-docto-orig-cte.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-define-tipo-entrada:

    DEF INPUT   PARAMETER p-rowid-docto-orig-cte     AS ROWID NO-UNDO.
    DEF INPUT   PARAMETER p-rowid-rat-docto-orig-cte AS ROWID NO-UNDO.
    DEF OUTPUT  PARAMETER l-cte-dev                  AS LOG   NO-UNDO.
    DEF OUTPUT  PARAMETER l-cte-saida                AS LOG   NO-UNDO.
    DEF OUTPUT  PARAMETER l-cte-log                  AS LOG   NO-UNDO.
    DEF OUTPUT  PARAMETER l-cte-compra               AS LOG   NO-UNDO.

    DEF VAR l-ok AS LOG NO-UNDO.

    FIND FIRST rat-docto-orig-cte NO-LOCK 
        WHERE ROWID(rat-docto-orig-cte) = p-rowid-rat-docto-orig-cte NO-ERROR.
        
    IF NOT AVAIL rat-docto-orig-cte THEN
        RETURN.

    FIND FIRST docto-orig-cte NO-LOCK 
        WHERE ROWID(docto-orig-cte) = p-rowid-docto-orig-cte NO-ERROR.

    IF NOT AVAIL docto-orig-cte THEN
        RETURN.

    ASSIGN l-cte-dev   = NO
           l-cte-saida = NO
           l-cte-log   = NO
           l-cte-compra= NO.

    ASSIGN c-chave  = TRIM(SUBSTRING(rat-docto-orig-cte.cod-livre-1,1,50))
           c-serie  = SUBSTRING(TRIM(SUBSTRING(rat-docto-orig-cte.cod-livre-1,1,50)),23,3)
           c-nota   = SUBSTRING(TRIM(SUBSTRING(rat-docto-orig-cte.cod-livre-1,1,50)),28,7)
           c-cnpj   = SUBSTRING(TRIM(SUBSTRING(rat-docto-orig-cte.cod-livre-1,1,50)),7,14).

    ASSIGN i-serie = INT(c-serie)
           c-serie = STRING(i-serie).

    ASSIGN c-estab-ini = "".
    FOR FIRST estabelec NO-LOCK 
        WHERE estabelec.cgc = c-cnpj:
        ASSIGN c-estab-ini = estabelec.cod-estabel.
    END.

    FOR EACH nota-fiscal NO-LOCK 
        WHERE nota-fiscal.cod-estabel  = c-estab-ini
          AND nota-fiscal.serie        = c-serie
          AND nota-fiscal.nr-nota-fis  = c-nota:

        IF nota-fiscal.cod-chave-aces-nf-eletro <> TRIM(SUBSTRING(rat-docto-orig-cte.cod-livre-1,1,50)) THEN NEXT.

        FOR FIRST natur-oper FIELDS(nat-operacao tipo  tp-rec-desp cod-esp) NO-LOCK 
            WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao:
        END.
        IF AVAIL natur-oper AND natur-oper.tipo <> 2 THEN DO:
           ASSIGN l-cte-saida = NO
                  l-ok        = NO.
           
           IF natur-oper.tipo = 1 AND natur-oper.cod-esp = "DV" AND 
              natur-oper.tp-rec-desp = 110 THEN
              ASSIGN l-cte-dev = YES.
           ELSE DO:
                IF natur-oper.tipo = 1 THEN DO:
                    FIND int-natur-oper NO-LOCK 
                         WHERE int-natur-oper.nat-operacao = natur-oper.nat-operacao NO-ERROR.

                    IF AVAIL int-natur-oper AND int-natur-oper.log-1 = YES THEN
                       ASSIGN l-cte-log = YES.
                    ELSE
                       ASSIGN l-cte-compra = YES.
                END.
           END.
        END.
        ELSE 
            ASSIGN l-cte-saida = YES.
    END.

    IF l-cte-saida = NO AND 
       l-cte-dev   = NO AND 
       l-cte-log   = NO AND
       l-cte-compra= NO THEN DO:

       FOR FIRST docum-est NO-LOCK
           WHERE docum-est.cod-chave-aces-nf-eletro = c-chave:
                                       
           FOR FIRST natur-oper FIELDS(nat-operacao tipo  tp-rec-desp cod-esp) NO-LOCK 
               WHERE natur-oper.nat-operacao = docum-est.nat-operacao:
           END.
           IF AVAIL natur-oper AND natur-oper.tipo <> 2 THEN DO:
              ASSIGN l-cte-saida = NO
                     l-ok        = NO.

              IF natur-oper.tipo = 1 AND natur-oper.cod-esp = "DV" AND 
                 natur-oper.tp-rec-desp = 110 THEN
                 ASSIGN l-cte-dev = YES.
              ELSE DO:
                  /* Daniel 28/06/2023 - Todas as NF de logistica sao de terceiros */
                  IF natur-oper.tipo = 1 THEN DO:

                    FIND int-natur-oper NO-LOCK 
                         WHERE int-natur-oper.nat-operacao = natur-oper.nat-operacao NO-ERROR.
                    IF AVAIL int-natur-oper AND int-natur-oper.log-1 = YES THEN
                       ASSIGN l-cte-log = YES.
                    ELSE
                       ASSIGN l-cte-compra = YES.
                END.
              END.
           END.
       END.
    END.

END PROCEDURE.

PROCEDURE pi-busca-item-frete:
    DEF INPUT  PARAMETER p-cod-uf-dest      AS CHAR NO-UNDO.
    DEF INPUT  PARAMETER p-cod-uf-orig      AS CHAR NO-UNDO.
    DEF OUTPUT PARAMETER p-cod-item         AS CHAR NO-UNDO.
    
    /* UF do emitente da NF */
    DEF VAR uf-origem AS CHAR NO-UNDO.
    /* UF do destinatŸrio da NF */
    DEF VAR uf-destino AS CHAR NO-UNDO.
    
    
    DEF VAR aliquota-icms AS DEC INITIAL 0.    
    DEF VAR item-frete AS CHAR FORMAT "x(20)" INITIAL "".    
    DEF VAR i AS INTEGER.    
    
    ASSIGN uf-origem  = p-cod-uf-dest
           uf-destino = p-cod-uf-orig.
        
    FOR EACH unid-feder NO-LOCK
        WHERE pais = "brasil"
          AND estado = uf-origem:
                     
        IF (uf-origem = uf-destino) THEN DO:
            ASSIGN aliquota-icms = unid-feder.per-icms-int.           
        END.
        ELSE DO:
            ASSIGN aliquota-icms = unid-feder.per-icms-ext.
    
            DO i = 1 TO EXTENT(unid-feder.est-exc):
                if (unid-feder.est-exc[i] = uf-destino) THEN DO:
                    IF (unid-feder.perc-exc[i] > 0) THEN DO:
                        ASSIGN aliquota-icms = unid-feder.perc-exc[i].
                    END.                                        
                END.                                   
            END.
        END.
    end.
    
    /*
        Regra ICMS 4%
        Apenas frete aereo, interestadual, onde o destinat†rio Ç contribuinte de ICMS
    */
    IF bf-docto-orig-cte.cdn-modalid-frete = 2
      AND p-cod-uf-dest  <> p-cod-uf-orig THEN DO:
    
        find first emitente NO-LOCK
          where emitente.cgc = bf-docto-orig-cte.cod-cnpj-dest
          no-error.
        IF AVAIL emitente AND emitente.natureza = 2 AND emitente.contrib-icms THEN 
           ASSIGN aliquota-icms = 4.
    
    END.
    
    ASSIGN item-frete = "".
    FOR EACH ponto-programa NO-LOCK
        WHERE ponto-programa.nome-programa = "re1001"
          AND ponto-programa.ponto = 8
          AND ponto-programa.tipo = 3,
         each conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
        IF (DEC(entry(1, conteudo-programa.conteudo, ";")) = aliquota-icms) THEN DO:
            ASSIGN item-frete = entry(2, conteudo-programa.conteudo, ";").
        END.
    END.
    ASSIGN p-cod-item = item-frete.

END PROCEDURE.

PROCEDURE pi-elimina-reg:

    DEF INPUT PARAMETER c-cod-aces-comp-nfe LIKE  docto-orig-cte.cod-aces-comp-nfe NO-UNDO.

    IF  NOT VALID-HANDLE(h-boin871) THEN
        RUN inbo/boin871.p PERSISTENT SET h-boin871.

    /* Eliminaa a CT-e */
    RUN EliminaCTe IN h-boin871(INPUT c-cod-aces-comp-nfe).
   
    IF  VALID-HANDLE(h-boin871) THEN DO:
        DELETE PROCEDURE h-boin871.
        ASSIGN h-boin871 = ?.
    END.

END PROCEDURE.

PROCEDURE pi-grava-erro:
    DEF INPUT PARAM p-erro            AS INT  NO-UNDO.
    DEF INPUT PARAM p-desc-erro       AS CHAR NO-UNDO.
    DEF INPUT PARAM p-chave           AS CHAR NO-UNDO.        

    CREATE tt-erro.
    ASSIGN tt-erro.identif-segment = p-chave
           tt-erro.cd-erro         = p-erro
           tt-erro.desc-erro       = p-desc-erro.

END PROCEDURE.

PROCEDURE pi-saida-gk0008:
    DEF INPUT PARAM p-estab AS CHAR NO-UNDO.
    DEF INPUT PARAM p-serie-nf AS CHAR NO-UNDO.
    DEF INPUT PARAM p-nr-nf AS CHAR NO-UNDO.
    DEF INPUT PARAM p-nat-oper AS CHAR NO-UNDO.
    DEF INPUT PARAM p-unid-neg AS CHAR NO-UNDO.
    DEF INPUT PARAM p-canal AS INT NO-UNDO.
    DEF INPUT PARAM p-item AS CHAR NO-UNDO.
    DEF OUTPUT PARAM r-ct-codigo AS CHAR NO-UNDO.
    DEF OUTPUT PARAM r-sc-codigo AS CHAR NO-UNDO.
    DEF OUTPUT PARAM r-un-codigo AS CHAR NO-UNDO.
                                   
    DEF BUFFER bf-item FOR ITEM.
    DEF BUFFER bf-natur-oper FOR natur-oper.
    DEF BUFFER bf-estabelec FOR estabelec.

    ASSIGN r-ct-codigo = ""
           r-sc-codigo = ""
           r-un-codigo = p-unid-neg.

    /* Transferencia - CPV */
    FIND FIRST bf-natur-oper NO-LOCK 
        WHERE bf-natur-oper.nat-operacao = p-nat-oper
        NO-ERROR.         
    
    IF (AVAIL bf-natur-oper AND bf-natur-oper.transf) THEN DO:
        FIND FIRST bf-item NO-LOCK
            WHERE bf-item.it-codigo = p-item
            NO-ERROR.

        IF (AVAIL bf-item) THEN
            ASSIGN r-un-codigo = bf-item.cod-unid-neg.
    END.

    /* Regras para pedido fiscal */
    FOR FIRST ped-fiscal FIELDS(ct-codigo sc-codigo)
        WHERE ped-fiscal.cod-estabel = p-estab
        AND   ped-fiscal.serie       = p-serie-nf
        AND   ped-fiscal.nr-nota-fis = p-nr-nf NO-LOCK:

        ASSIGN r-sc-codigo = ped-fiscal.sc-codigo.
    END.
                                                  
    /* GK0008 */
    FIND FIRST gko-param-contab-totvs11
        WHERE  gko-param-contab-totvs11.cod-estabel     = p-estab
        AND    gko-param-contab-totvs11.nat-operacao    = p-nat-oper
        AND    gko-param-contab-totvs11.cod-unid-negoc  = r-un-codigo
        AND    gko-param-contab-totvs11.cod-canal-venda = p-canal NO-LOCK NO-ERROR.

    IF NOT AVAIL gko-param-contab-totvs11 THEN
        FIND FIRST gko-param-contab-totvs11 
            WHERE  gko-param-contab-totvs11.cod-estabel     = p-estab
            AND    gko-param-contab-totvs11.nat-operacao    = p-nat-oper
            AND    gko-param-contab-totvs11.cod-unid-negoc  = r-un-codigo
            AND    gko-param-contab-totvs11.cod-canal-venda = ? NO-LOCK NO-ERROR.       

    IF NOT AVAIL gko-param-contab-totvs11 THEN
        FIND FIRST gko-param-contab-totvs11 
            WHERE  gko-param-contab-totvs11.cod-estabel     = p-estab
            AND    gko-param-contab-totvs11.nat-operacao    = p-nat-oper
            AND    gko-param-contab-totvs11.cod-unid-negoc  = ?
            AND    gko-param-contab-totvs11.cod-canal-venda = p-canal NO-LOCK NO-ERROR.

    IF NOT AVAIL gko-param-contab-totvs11 THEN
        FIND FIRST gko-param-contab-totvs11 
            WHERE  gko-param-contab-totvs11.cod-estabel     = p-estab
            AND    gko-param-contab-totvs11.nat-operacao    = p-nat-oper
            AND    gko-param-contab-totvs11.cod-unid-negoc  = "?"
            AND    gko-param-contab-totvs11.cod-canal-venda = p-canal NO-LOCK NO-ERROR.    

    IF NOT AVAIL gko-param-contab-totvs11 THEN
        FIND FIRST gko-param-contab-totvs11 
            WHERE  gko-param-contab-totvs11.cod-estabel     = p-estab
            AND    gko-param-contab-totvs11.nat-operacao    = p-nat-oper
            AND    gko-param-contab-totvs11.cod-unid-negoc  = ?
            AND    gko-param-contab-totvs11.cod-canal-venda = ? NO-LOCK NO-ERROR.

    IF NOT AVAIL gko-param-contab-totvs11 THEN
        FIND FIRST gko-param-contab-totvs11 
            WHERE  gko-param-contab-totvs11.cod-estabel     = p-estab
            AND    gko-param-contab-totvs11.nat-operacao    = p-nat-oper
            AND    gko-param-contab-totvs11.cod-unid-negoc  = "?"
            AND    gko-param-contab-totvs11.cod-canal-venda = ? NO-LOCK NO-ERROR.
                 
    FIND FIRST unid_negoc WHERE unid_negoc.cod_unid_negoc = p-unid-neg NO-LOCK NO-ERROR.
    
    IF  AVAIL gko-param-contab-totvs11 AND AVAIL unid_negoc THEN DO:
        /* Excecao para canal 12 */
        IF r-sc-codigo <> "" AND (gko-param-contab-totvs11.cod-canal-venda = 12 OR gko-param-contab-totvs11.sc-codigo = "10000") THEN 
            ASSIGN r-sc-codigo = r-sc-codigo.
        ELSE
            ASSIGN r-sc-codigo = gko-param-contab-totvs11.sc-codigo.

        ASSIGN r-ct-codigo = gko-param-contab-totvs11.ct-codigo.
    END.

    /* Regra de mudanáa de unidade de negocio */
    IF (r-un-codigo <> "" AND r-sc-codigo <> "") THEN DO:
        FIND FIRST bf-estabelec NO-LOCK
            WHERE bf-estabelec.cod-estabel = p-estab.

        FIND FIRST emscad.ccusto_unid_negoc NO-LOCK
            WHERE emscad.ccusto_unid_negoc.cod_empresa  = bf-estabelec.ep-codigo
            AND emscad.ccusto_unid_negoc.cod_ccusto     = r-sc-codigo
            AND emscad.ccusto_unid_negoc.cod_unid_negoc = r-un-codigo
            NO-ERROR.
                                                                                              
        IF (NOT AVAIL emscad.ccusto_unid_negoc) THEN DO:
            DEF VAR l-un-codigo-unq AS CHAR.
            DEF VAR l-count AS INT.

            ASSIGN l-un-codigo-unq = ""
                   l-count         = 0.

            FOR EACH emscad.ccusto_unid_negoc NO-LOCK
                WHERE emscad.ccusto_unid_negoc.cod_empresa = bf-estabelec.ep-codigo
                AND emscad.ccusto_unid_negoc.cod_ccusto    = r-sc-codigo:
                ASSIGN l-count         = l-count + 1
                       l-un-codigo-unq = emscad.ccusto_unid_negoc.cod_unid_negoc.
            END.

            // Unica restricao de unidade para CC
            IF (l-count = 1) THEN
                ASSIGN r-un-codigo = l-un-codigo-unq.
        END. 
    END.

END PROCEDURE.
