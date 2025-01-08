/*----------------------------------------------------------------*/
/*  Programa..: esp/esb/esesbapi003-apb.p                          */
/*  Objetivo..: Api para integraá∆o/alteraá∆o de t°tulos no EMS5  */
/*     Autor..: Roger Marcelino Bruhn                             */
/*----------------------------------------------------------------*/

DEFINE VARIABLE v_hdl_aux AS HANDLE     NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE v_des_contdo_prog_valid_dtsul AS CHARACTER   NO-UNDO FORMAT "x(40)":U.

v_des_contdo_prog_valid_dtsul = "esesb005rp".

/*Define variaveis*/
def var p_num_vers_integr_api as integer format ">>>>,>>9" no-undo. 
def var v_cod_matriz_trad_org_ext as character format "x(8)" no-undo. 
def var v_int as i no-undo.

DEFINE VARIABLE c-mensagem AS CHARACTER   NO-UNDO.

{esapi/esapi015tt.i}
{utp/utapi009.i}

DEFINE TEMP-TABLE tt-vpc NO-UNDO LIKE vpc
FIELD r-Rowid AS ROWID.

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)"
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.

DEFINE VARIABLE c-referencia         AS CHAR FORMAT "X(20)"    NO-UNDO.
DEFINE VARIABLE c-cod-titulo         AS CHAR FORMAT "X(09)"    NO-UNDO.
DEFINE VARIABLE c-conta              AS CHAR FORMAT "X(20)"    NO-UNDO.
DEFINE VARIABLE c-centro-custo       AS CHAR FORMAT "X(20)"    NO-UNDO.
DEFINE VARIABLE c-cod-estab          AS CHAR FORMAT "X(05)"    NO-UNDO.
DEFINE VARIABLE c-especie            AS CHAR                   NO-UNDO.
DEFINE VARIABLE c-tipo-fluxo         AS CHAR                   NO-UNDO.

/* Procedures comuns aos programas esesbapi003-apb e a este programa.*/
{esp/esb/esesbapi003-apb.i}

/************************  FIM DEFINIÄÂES APB  ***********************/
DEFINE VARIABLE i-seq-ref            AS INTEGER                NO-UNDO.
DEFINE VARIABLE da-ini-trimestre     AS DATE                   NO-UNDO.
DEFINE VARIABLE da-fim-trimestre     AS DATE                   NO-UNDO.

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(200)"
    FIELD ajuda    AS CHAR FORMAT "X(250)".

FUNCTION fn-retorna-nome-beneficio RETURNS CHAR
    (p-beneficio AS INT) FORWARD.


/* Temp-table tt-beneficio */
{esp/esb/esesbapi004-benef.i}

{esp/esb/esesbapi010-saldo.i1} /*tt-saldo*/

DEF TEMP-TABLE tt-erro-benef NO-UNDO LIKE tt-erro.
/*Temp-tables com os dados do faturamento/devoluá‰es*/
{esp/esb/esesbapi002.i} /* tt-canal; tt-fat-mensal; tt-fat-mensal-det */
DEF TEMP-TABLE tt-erro-saldo   LIKE tt-erro.
DEF VAR c-usuario AS CHAR INIT "integra" NO-UNDO.

PROCEDURE pi-seta-usuario:
    DEF INPUT PARAMETER p-usuario AS CHAR NO-UNDO.

    ASSIGN c-usuario = p-usuario.

END.

PROCEDURE pi-Integra-Despesas-APB:
    
    DEF INPUT PARAM p-rowid-cc        AS ROWID NO-UNDO.
    DEF INPUT PARAM p-valor           AS DEC   NO-UNDO.
    DEF INPUT PARAM p-log-valor-full  AS LOG   NO-UNDO. /*se YES, ent∆o n∆o aplica o % de custo, e assume o valor integral passado*/
    DEF INPUT PARAM p-dt-trasacao-ap  AS DATE  NO-UNDO.
    DEF INPUT PARAM p-da-fim          AS DATE  NO-UNDO.
    DEF INPUT PARAM p-desconto-duplic AS LOG   NO-UNDO.
    DEF INPUT PARAM TABLE FOR tt-beneficio.
    DEF OUTPUT PARAM TABLE FOR tt-erro.
    
    DEF VAR v_hdl_aux                 AS HANDLE             NO-UNDO.
    DEF VAR v_cod_matriz_trad_org_ext AS CHAR FORMAT "x(8)" NO-UNDO. 
    DEF VAR l-atualizou-pagto         AS LOGICAL            NO-UNDO.
    DEF VAR c-estab-ant               AS CHAR     INIT "1"  NO-UNDO.
    DEF VAR c-ep-codigo               AS CHAR               NO-UNDO.
    DEF VAR de-valor-provisionado-ant AS DEC                NO-UNDO.
    DEF VAR de-valor-ap               AS DEC                NO-UNDO.
    DEF VAR l-ok                      AS LOG  INIT NO       NO-UNDO.
    DEF VAR de-disponivel             AS DEC                NO-UNDO.
    DEF VAR de-empenho                AS DEC                NO-UNDO.
    DEF VAR l-zerar-saldo-tit         AS LOG  INIT NO       NO-UNDO.
    DEF VAR de-saldo-tit              AS DEC                NO-UNDO.       
    DEF VAR de-perc-custo             AS DEC                NO-UNDO.

    ASSIGN i-seq-ref    = 0
           c-referencia = "".

    /*----------------------------*/
    /*        ZERAR TABLELAS      */
    /*----------------------------*/
    EMPTY TEMP-TABLE tt-canal.
    EMPTY TEMP-TABLE tt-erro.
    EMPTY TEMP-TABLE tt-erro-benef.
    RUN pi-zera-tabelas.

    FIND FIRST int-cc-benef no-lock
        WHERE rowid(int-cc-benef) = p-rowid-cc NO-ERROR.

    IF  NOT AVAIL int-cc-benef THEN
        RETURN "NOK".

    FIND FIRST Int-emitente NO-LOCK
        WHERE int-emitente.cod-emitente = int-cc-benef.canal NO-ERROR.
    IF  NOT AVAIL int-emitente THEN
        RETURN "NOK".

    /*---------------------------*/
    /*  APURAÄ«O DOS BENEF÷CIOS  */
    /*---------------------------*/

    IF  NOT CAN-FIND (FIRST tt-beneficio) THEN DO:
        RUN pi-busca-beneficios-canal (INPUT NO).
        IF  RETURN-VALUE <> "OK" THEN 
           RETURN "NOK".
    END.

    /* Calcular a data inicial do trimestre do per°odo a partir da data de apuraá∆o informada */
    CASE MONTH(p-da-fim):
        WHEN 01 OR WHEN 02 OR WHEN 03 THEN 
            ASSIGN da-ini-trimestre = DATE(01,01,YEAR(p-da-fim))
                   da-fim-trimestre = DATE(03,31,YEAR(p-da-fim)).
        WHEN 04 OR WHEN 05 OR WHEN 06 THEN 
            ASSIGN da-ini-trimestre = DATE(04,01,YEAR(p-da-fim))
                   da-fim-trimestre = DATE(06,30,YEAR(p-da-fim)).
        WHEN 07 OR WHEN 08 OR WHEN 09 THEN 
            ASSIGN da-ini-trimestre = DATE(07,01,YEAR(p-da-fim))
                   da-fim-trimestre = DATE(09,30,YEAR(p-da-fim)).
        WHEN 10 OR WHEN 11 OR WHEN 12 THEN 
            ASSIGN da-ini-trimestre = DATE(10,01,YEAR(p-da-fim))
                   da-fim-trimestre = DATE(12,31,YEAR(p-da-fim)).
    END CASE.
               
    /* Busca benef°cios */
    FOR FIRST int-cc-benef NO-LOCK   
        WHERE rowid(int-cc-benef) = p-rowid-cc :

        /* ATENÄ«O, AO MUDAR DA NOMENCLATURA DO T÷TULO, ESTA DEVERµ SER CONSIDERADA TAMBêM NO PROGRAMA ESESB005RP.P (CµLCULO) - POIS ELE UTILIZA-SE  */
        /* DESTA CODIFICAÄ«O PARA EFETUAR O ESTORNO DA PROVIS«O. O PROGRAMA ESESBAPI003-ABP.P TAMBêM DEVERµ SER ALTERADO                             */
        ASSIGN c-cod-titulo = STRING             (int-cc-benef.tipo-beneficio)        + 
                              TRIM (STRING       (int-cc-benef.unid-neg))             + 
                              STRING(MONTH       (int-cc-benef.dt-periodo-fim), "99") +
                              SUBSTR(string(YEAR (int-cc-benef.dt-periodo-fim), "9999"), 3, 2).

        
        /* WEB SERVICE DO CRM RETORNARµ AS INFORMAÄÂES ABAIXO */
        FIND FIRST tt-beneficio
            WHERE tt-beneficio.tipo-beneficio = int-cc-benef.tipo-beneficio
              AND tt-beneficio.unid-neg       = int-cc-benef.unid-neg NO-ERROR.
        IF  NOT AVAIL tt-beneficio THEN DO:
            RUN pi-cria-erro (INPUT 17006, /* Erro */
                              INPUT "Erro ao buscar a conta, centro de custo, estabelecimento e espÇcie. " + CHR(10) +
                                    "Canal EMS: " + string(int-cc-benef.canal)                             + CHR(10) +
                                    "Unidade..: " + int-cc-benef.unid-neg                                  + CHR(10) +
                                    "Benef°cio: " + fn-retorna-nome-beneficio(int-cc-benef.tipo-beneficio),
                              INPUT "Favor entrar em contato com a TIC da Intelbras.":U).
            RETURN "NOK".
        END.

        ASSIGN c-conta        = tt-beneficio.conta       
               c-centro-custo = tt-beneficio.centro-custo
               c-cod-estab    = tt-beneficio.cod-estabel          
               c-especie      = tt-beneficio.cod-especie 
               c-tipo-fluxo   = tt-beneficio.tipo-fluxo  .

        FIND FIRST estabelec NO-LOCK
             WHERE estabelec.cod-estabel = c-cod-estab NO-ERROR.
        IF NOT AVAIL estabelec THEN DO:
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                        INPUT "Rotina integraá∆o de despesas APB. Estabelecimento inv†lido: " + c-cod-estab,
                                        INPUT "Canal: " + string(int-cc-benef.canal) + ", favor entrar em contato com a TIC da Intelbras.").
            RETURN "NOK".
        END.
        ASSIGN c-estab-ant = c-cod-estab
               c-ep-codigo = estabelec.ep-codigo.
        
        FIND FIRST tit_ap NO-LOCK
            WHERE tit_ap.cod_estab     = int-cc-benef.cod_estab
              AND tit_ap.num_id_tit_ap = int-cc-benef.num_id_tit_ap NO-ERROR.
        IF  AVAIL tit_ap THEN
            ASSIGN de-saldo-tit = tit_ap.val_sdo_tit_ap.

        /*-----------------------------------*/
        /*   APLICA NO SALDO, O % DE CUSTO   */
        /*-----------------------------------*/
        IF  NOT (tt-beneficio.perc-custo > 0) THEN DO:
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                INPUT "% de custo para c†lcular saldo do t°tulo Ç inv†lido",
                                                INPUT "Canal EMS.: " + STRING(int-cc-benef.canal)    + CHR(10) +
                                                      "Unidade...: " +       int-cc-benef.unid-neg   + CHR(10) +  
                                                      "Benef°cio.: " +       fn-retorna-nome-beneficio(tt-beneficio.tipo-beneficio)+ CHR(10) +  
                                                      "Canal CRM.: " + int-cc-benef.guid-canal ).
            RETURN "NOK".
        END.

        /*-----------------------------------------------------------------------------------------------------------------------------*/
        /* Sempre que for abater algum valor do Saldo do t°tulo, deve-se verificar se o saldo dispon°vel da conta corrente est† zerado */
        /* e se n∆o h† mais nada pendente de pagamento. Neste caso deve-se zerar o saldo do contas a pagar, para evitar que por algum  */
        /* motivo de arredondamento possa ficar um saldo de centavos residual no t°tulo.                                               */
        /*-----------------------------------------------------------------------------------------------------------------------------*/
        /* Verificar existencia de saldo */                                 
        RUN esp/esb/esesbapi010-saldo.p (INPUT int-cc-benef.canal,          
                                         INPUT int-cc-benef.tipo-beneficio, 
                                         INPUT int-cc-benef.unid-neg,       
                                         INPUT int-cc-benef.dt-periodo-ini, 
                                         INPUT int-cc-benef.dt-periodo-fim, 
                                         INPUT ?,                           
                                         INPUT ?,                           
                                         OUTPUT l-ok,                       
                                         OUTPUT TABLE tt-saldo,             
                                         OUTPUT TABLE tt-erro-saldo).       
        IF  l-ok THEN DO:
            FOR FIRST tt-saldo: 
                ASSIGN de-disponivel = tt-saldo.VerbaDisponivel
                       de-empenho    = tt-saldo.VerbaEmpenhadaTotal.
            END.
    
             IF  de-disponivel = 0 
             AND de-empenho    = 0                           
             AND de-saldo-tit  > 0      
             THEN
                 ASSIGN de-valor-ap = 0
                        l-zerar-saldo-tit = YES.        

        END.

        ASSIGN de-perc-custo = (tt-beneficio.perc-custo / 100).
        /* se for desconto em duplicata...sempre fator deve ser 1 */
        IF  p-desconto-duplic THEN
            ASSIGN de-perc-custo = 1.

        IF  p-log-valor-full THEN /*quando o programa chamador passou j† o valor TOTAL que o t°tulo deve assumir (utilizado apenas pelo esesb010c.w)*/
            ASSIGN de-valor-ap = p-valor.
        ELSE
            IF  NOT l-zerar-saldo-tit THEN DO:
                IF  p-valor < 0 
                AND ((p-valor * de-perc-custo) * -1) > de-saldo-tit THEN
                     ASSIGN de-valor-ap = 0.
                ELSE
                    ASSIGN de-valor-ap = de-saldo-tit + (p-valor * de-perc-custo).
            END.

        
        IF  AVAIL tit_ap THEN DO:
            RUN pi-ALTERA-temp-table-titulo (INPUT c-cod-estab,
                                             INPUT p-dt-trasacao-ap,
                                             INPUT tit_ap.dat_vencto_tit_ap,
                                             INPUT de-valor-ap,
                                             INPUT "Alteraá∆o saldo e vencimento t°tulo",
                                             INPUT c-referencia).
            IF  RETURN-VALUE <> "OK" THEN
                RETURN "NOK".
        END.
        ELSE DO:
            RUN pi-cria-temp-table-titulo (INPUT NO, /* se NO indica que n∆o Ç provis∆o, e sim despesa*/
                                           INPUT c-cod-estab,
                                           INPUT c-ep-codigo,
                                           INPUT c-referencia,
                                           INPUT c-conta,
                                           INPUT c-centro-custo,
                                           INPUT c-especie,
                                           INPUT tt-beneficio.tipo-fluxo,
                                           INPUT c-cod-titulo,
                                           INPUT p-dt-trasacao-ap,
                                           INPUT (IF int-cc-benef.dt-vencimento < p-dt-trasacao-ap THEN p-dt-trasacao-ap ELSE int-cc-benef.dt-vencimento),
                                           INPUT int-cc-benef.canal,
                                           INPUT int-cc-benef.unid-neg,
                                           INPUT int-cc-benef.tipo-beneficio,
                                           INPUT int-cc-benef.categoria,
                                           INPUT de-valor-ap,
                                           INPUT p-da-fim).

            IF  RETURN-VALUE <> "OK" THEN
                RETURN "NOK".
        END.
    END. /* Fim for first benef°cios*/

    /*--------------------------------------------------------------*/
    /*          ROTINA PARA CRIAÄ«O DO T÷TULO  (INCLUS«O)           */
    /*--------------------------------------------------------------*/ 
    bloco-tit:
    DO TRANS ON ERROR UNDO:

        IF  CAN-FIND (FIRST tt_integr_apb_item_lote_impl_3) THEN DO:
            RUN pi-efetiva-CRIACAO-titulo-APB.
            

            IF  RETURN-VALUE <> "OK" THEN DO:
                UNDO bloco-tit, RETURN "NOK".
            END.
    
            /*------------------------------------------------------------------------*/
            /*     Atualizaá∆o dos dados do t°tulo no registro da conta conrrente     */
            /*------------------------------------------------------------------------*/
            FOR FIRST int-cc-benef EXCLUSIVE-LOCK
                WHERE rowid(int-cc-benef) = p-rowid-cc: /* N«O GERA PARA STOCK ROTATION */
    
                ASSIGN l-atualizou-pagto = NO.
    
                /* WEB SERVICE DO CRM RETORNARµ AS INFORMAÄÂES ABAIXO */
                FIND FIRST tt-beneficio
                    WHERE tt-beneficio.tipo-beneficio = int-cc-benef.tipo-beneficio
                      AND tt-beneficio.unid-neg       = int-cc-benef.unid-neg NO-ERROR.
                IF  NOT AVAIL tt-beneficio THEN DO:
                    RUN pi-cria-erro (INPUT 17006, /* Erro */
                                      INPUT "Erro ao buscar a conta, centro de custo, estabelecimento e espÇcie. " + CHR(10) +
                                            "Canal EMS: " + string(int-cc-benef.canal)                             + CHR(10) +
                                            "Unidade..: " + int-cc-benef.unid-neg                                  + CHR(10) +
                                            "Benef°cio: " + fn-retorna-nome-beneficio(int-cc-benef.tipo-beneficio),
                                      INPUT "Favor entrar em contato com a TIC da Intelbras.":U).
                    RETURN "NOK".
                END.

                /* ATENÄ«O, AO MUDAR DA NOMENCLATURA DO T÷TULO, ESTA DEVERµ SER CONSIDERADA TAMBêM NO PROGRAMA ESESB005RP.P (CµLCULO) / ESESB009RP.P */
                ASSIGN c-cod-titulo = STRING             (int-cc-benef.tipo-beneficio)        + 
                                      TRIM (STRING       (int-cc-benef.unid-neg))             + 
                                      STRING(MONTH       (int-cc-benef.dt-periodo-fim), "99") +
                                      SUBSTR(string(YEAR (int-cc-benef.dt-periodo-fim), "9999"), 3, 2).

                FIND FIRST tit_ap NO-LOCK          
                    WHERE tit_ap.cod_estab         = tt-beneficio.cod-estabel 
                      AND tit_ap.cdn_fornecedor    = int-cc-benef.canal
                      AND tit_ap.cod_espec_docto   = tt-beneficio.cod-especie 
                      AND tit_ap.cod_ser_docto     = "U" 
                      AND tit_ap.cod_tit_ap        = c-cod-titulo     
                      AND tit_ap.cod_parcela       = "01"    NO-ERROR.
    
                IF  AVAIL tit_ap THEN DO:
                    ASSIGN int-cc-benef.cod_estab     = tit_ap.cod_estab     
                           int-cc-benef.num_id_tit_ap = tit_ap.num_id_tit_ap
                           l-atualizou-pagto          = YES.
                END.
                ELSE
                    ASSIGN l-atualizou-pagto = NO.

                IF  NOT l-atualizou-pagto THEN DO:

                    RUN pi-cria-erro (INPUT 17006, /* Erro */
                                      INPUT "Erro ao tentar atualizar o registro de conta corrente para o Canal " + STRING(int-cc-benef.canal) + ", Unidade de Neg¢cio: " + int-cc-benef.unid-neg,
                                      INPUT "Favor entrar em contato com a TIC da Intelbras.":U).
                    UNDO bloco-tit, RETURN "NOK".
                END.
            END.
    
            FIND CURRENT int-cc-benef NO-LOCK NO-ERROR.
            RELEASE int-cc-benef NO-ERROR.
    
        END.
        
        /*-----------------------------------------------------*/
        /*             ROTINA ALTERAÄ«O DO T÷TULO              */
        /*-----------------------------------------------------*/
        IF  CAN-FIND (FIRST tt_tit_ap_alteracao_base_aux_1)  THEN DO:

            RUN pi-efetiva-ALTERECAO-titulo-ABP.
            
        END.

        EMPTY TEMP-TABLE tt_tit_ap_alteracao_base_aux_1.
    
        IF  RETURN-VALUE <> "OK" THEN DO:
            UNDO, RETURN "NOK".
        END.
    
    END.
    

    RETURN "OK".

END.


/* PROCEDURE pi-Integra-PROVISAO-APB:                                                                                                                                            */
/*                                                                                                                                                                               */
/*     DEF INPUT PARAM p-rowid-cc       AS ROWID NO-UNDO.                                                                                                                        */
/*     DEF INPUT PARAM p-dt-trasacao-ap AS DATE  NO-UNDO.                                                                                                                        */
/*     DEF INPUT PARAM p-da-fim         AS DATE  NO-UNDO.                                                                                                                        */
/*     DEF OUTPUT PARAM TABLE FOR tt-erro.                                                                                                                                       */
/*     /*-----------------------------*/                                                                                                                                         */
/*     /*     INTEGRAÄ«O PROVIS«O     */                                                                                                                                         */
/*     /*-----------------------------*/                                                                                                                                         */
/*                                                                                                                                                                               */
/*     DEF VAR v_hdl_aux                 AS HANDLE             NO-UNDO.                                                                                                          */
/*     DEF VAR v_cod_matriz_trad_org_ext AS CHAR FORMAT "x(8)" NO-UNDO.                                                                                                          */
/*     DEF VAR l-atualizou-pagto         AS LOGICAL            NO-UNDO.                                                                                                          */
/*     DEF VAR c-ep-codigo               AS CHAR               NO-UNDO.                                                                                                          */
/*     DEF BUFFER b-int-cc-benef-prov FOR int-cc-benef.                                                                                                                          */
/*                                                                                                                                                                               */
/*     ASSIGN i-seq-ref    = 0                                                                                                                                                   */
/*            c-referencia = "".                                                                                                                                                 */
/*                                                                                                                                                                               */
/*     /*----------------------------*/                                                                                                                                          */
/*     /*        ZERAR TABLELAS      */                                                                                                                                          */
/*     /*----------------------------*/                                                                                                                                          */
/*     EMPTY TEMP-TABLE tt-canal.                                                                                                                                                */
/*     EMPTY TEMP-TABLE tt-erro.                                                                                                                                                 */
/*     EMPTY TEMP-TABLE tt-erro-benef.                                                                                                                                           */
/*     RUN pi-zera-tabelas.                                                                                                                                                      */
/*                                                                                                                                                                               */
/*     FIND FIRST int-cc-benef no-lock                                                                                                                                           */
/*         WHERE rowid(int-cc-benef) = p-rowid-cc NO-ERROR.                                                                                                                      */
/*                                                                                                                                                                               */
/*     IF  NOT AVAIL int-cc-benef THEN                                                                                                                                           */
/*         RETURN "NOK".                                                                                                                                                         */
/*                                                                                                                                                                               */
/*     FIND FIRST Int-emitente NO-LOCK                                                                                                                                           */
/*         WHERE int-emitente.cod-emitente = int-cc-benef.canal NO-ERROR.                                                                                                        */
/*     IF  NOT AVAIL int-emitente THEN                                                                                                                                           */
/*         RETURN "NOK".                                                                                                                                                         */
/*                                                                                                                                                                               */
/*     /*---------------------------*/                                                                                                                                           */
/*     /*  APURAÄ«O DOS BENEF÷CIOS  */                                                                                                                                           */
/*     /*---------------------------*/                                                                                                                                           */
/*     RUN pi-busca-beneficios-canal (INPUT YES).                                                                                                                                */
/*     IF  RETURN-VALUE <> "OK" THEN                                                                                                                                             */
/*        RETURN "NOK".                                                                                                                                                          */
/*                                                                                                                                                                               */
/*     FOR FIRST int-cc-benef NO-LOCK                                                                                                                                            */
/*         WHERE ROWID(int-cc-benef) = p-rowid-cc                                                                                                                                */
/*         ,FIRST tt-beneficio                                                                                                                                                   */
/*              WHERE tt-beneficio.tipo-beneficio = int-cc-benef.tipo-beneficio                                                                                                  */
/*                AND tt-beneficio.unid-neg       = int-cc-benef.unid-neg:                                                                                                       */
/*                                                                                                                                                                               */
/*         /* ATENÄ«O, AO MUDAR DA NOMENCLATURA DO T÷TULO, ESTA DEVERµ SER CONSIDERADA TAMBêM NO PROGRAMA ESESB005RP.P (CµLCULO) - POIS ELE UTILIZA-SE  */                       */
/*         /* DESTA CODIFICAÄ«O PARA EFETUAR O ESTORNO DA PROVIS«O.O PROGRAMA ESESBAPI003-APB.P TAMBêM UTILIZAR ESSE FORMATO DE C‡DIGO                  */                       */
/*         ASSIGN c-cod-titulo =  STRING             (int-cc-benef.tipo-beneficio)        +                                                                                      */
/*                                TRIM(STRING        (int-cc-benef.unid-neg))             +                                                                                      */
/*                                STRING(MONTH       (int-cc-benef.dt-periodo-fim), "99") +                                                                                      */
/*                                SUBSTR(string(YEAR (int-cc-benef.dt-periodo-fim), "9999"), 3, 2).                                                                              */
/*                                                                                                                                                                               */
/*         FIND FIRST estabelec NO-LOCK                                                                                                                                          */
/*              WHERE estabelec.cod-estabel = tt-beneficio.cod-estabel NO-ERROR.                                                                                                 */
/*         IF NOT AVAIL estabelec THEN DO:                                                                                                                                       */
/*             RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */                                                                                                       */
/*                                         INPUT "Estabelecimento inv†lido: " + tt-beneficio.cod-estabel,                                                                        */
/*                                         INPUT "Canal EMS: " + string(int-cc-benef.canal) + "Processamento n∆o conclu°do.").                                                   */
/*             RETURN "NOK".                                                                                                                                                     */
/*         END.                                                                                                                                                                  */
/*                                                                                                                                                                               */
/*         ASSIGN c-ep-codigo = estabelec.ep-codigo.                                                                                                                             */
/*                                                                                                                                                                               */
/*         /*  Verifica se o benef°cio j† possui t°tulo de provis∆o criada em ocasi‰es anteriores  */                                                                            */
/*         FIND FIRST b-int-cc-benef-prov NO-LOCK                                                                                                                                */
/*             WHERE b-int-cc-benef-prov.tp-movto       = 1 /*Provis∆o*/                                                                                                         */
/*               AND b-int-cc-benef-prov.canal          = int-cc-benef.canal                                                                                                     */
/*               AND b-int-cc-benef-prov.tipo-beneficio = int-cc-benef.tipo-beneficio                                                                                            */
/*               AND b-int-cc-benef-prov.unid-neg       = int-cc-benef.unid-neg                                                                                                  */
/*               AND b-int-cc-benef-prov.dt-periodo-ini = int-cc-benef.dt-periodo-ini                                                                                            */
/*               AND b-int-cc-benef-prov.dt-periodo-fim = int-cc-benef.dt-periodo-fim NO-ERROR.                                                                                  */
/*                                                                                                                                                                               */
/*         IF  AVAIL b-int-cc-benef-prov THEN                                                                                                                                    */
/*             FIND FIRST tit_ap NO-LOCK                                                                                                                                         */
/*                 WHERE tit_ap.cod_estab     = b-int-cc-benef-prov.cod_estab                                                                                                    */
/*                   AND tit_ap.num_id_tit_ap = b-int-cc-benef-prov.num_id_tit_ap NO-ERROR.                                                                                      */
/*                                                                                                                                                                               */
/* /*         /* Buscar referància */                                    */                                                                                                      */
/* /*         RUN pi-busca-referencia (INPUT  "BPRV",                    */                                                                                                      */
/* /*                                  INPUT  tt-beneficio.cod-estabel,  */                                                                                                      */
/* /*                                  OUTPUT c-referencia).             */                                                                                                      */
/*                                                                                                                                                                               */
/*         IF  AVAIL b-int-cc-benef-prov AND AVAIL tit_ap THEN DO:                                                                                                               */
/*             RUN pi-altera-temp-table-titulo (INPUT tt-beneficio.cod-estabel,                                                                                                  */
/*                                              INPUT p-dt-trasacao-ap, /*tt-cc-benef.dt-transacao*/  /* data da transaá∆o */                                                    */
/*                                              INPUT int-cc-benef.dt-vencimento,                                                                                                */
/*                                              INPUT int-cc-benef.vl-saldo,                                                                                                     */
/*                                              INPUT "Alteraá∆o Provis∆o realizada manualmente em: " + STRING(TODAY, '99/99/9999') +  ", pelo usu†rio: " + v_cod_usuar_corren,  */
/*                                              INPUT c-referencia).                                                                                                             */
/*                                                                                                                                                                               */
/*             IF  RETURN-VALUE <> "OK" THEN                                                                                                                                     */
/*                 RETURN "NOK".                                                                                                                                                 */
/*         END.                                                                                                                                                                  */
/*         ELSE DO:                                                                                                                                                              */
/*                                                                                                                                                                               */
/*              RUN pi-cria-temp-table-titulo  (INPUT YES, /*Provis∆o ?*/                                                                                                        */
/*                                             INPUT tt-beneficio.cod-estabel,                                                                                                   */
/*                                             INPUT c-ep-codigo,                                                                                                                */
/*                                             INPUT c-referencia,                                                                                                               */
/*                                             INPUT tt-beneficio.conta,                                                                                                         */
/*                                             INPUT tt-beneficio.centro-custo,                                                                                                  */
/*                                             INPUT "CPO",                                                                                                                      */
/*                                             INPUT tt-beneficio.tipo-fluxo,                                                                                                    */
/*                                             INPUT c-cod-titulo,                                                                                                               */
/*                                             INPUT p-dt-trasacao-ap,                                                                                                           */
/*                                             INPUT int-cc-benef.dt-vencimento,                                                                                                 */
/*                                             INPUT int-cc-benef.canal,                                                                                                         */
/*                                             INPUT int-cc-benef.unid-neg,                                                                                                      */
/*                                             INPUT int-cc-benef.tipo-beneficio,                                                                                                */
/*                                             INPUT int-cc-benef.categoria,                                                                                                     */
/*                                             INPUT int-cc-benef.vl-saldo,                                                                                                      */
/*                                             INPUT p-da-fim).                                                                                                                  */
/*                                                                                                                                                                               */
/*             IF  RETURN-VALUE <> "OK" THEN                                                                                                                                     */
/*                 RETURN "NOK".                                                                                                                                                 */
/*         END.                                                                                                                                                                  */
/*     END.                                                                                                                                                                      */
/*                                                                                                                                                                               */
/*     /*-----------------------------------------------------*/                                                                                                                 */
/*     /*          EFETIVAÄ«O DO T÷TULO DE PROVIS«O           */                                                                                                                 */
/*     /*-----------------------------------------------------*/                                                                                                                 */
/*     DEF VAR l-atualizou-provisao AS LOG NO-UNDO.                                                                                                                              */
/*                                                                                                                                                                               */
/*     RUN pi-efetiva-CRIACAO-titulo-APB.                                                                                                                                        */
/*                                                                                                                                                                               */
/*     IF  RETURN-VALUE <> "OK" THEN                                                                                                                                             */
/*         RETURN "NOK".                                                                                                                                                         */
/*                                                                                                                                                                               */
/*     /*------------------------------------------------------------------------*/                                                                                              */
/*     /*     Atualizaá∆o dos dados do t°tulo no registro da conta conrrente     */                                                                                              */
/*     /*    OBS: s¢ entra quando o t°tulo Ç novo, atualizaá∆o n∆o deve entrar   */                                                                                              */
/*     /*------------------------------------------------------------------------*/                                                                                              */
/*                                                                                                                                                                               */
/*                                                                                                                                                                               */
/*     IF  int-cc-benef.num_id_tit_ap = 0 THEN  DO:                                                                                                                              */
/*         FIND CURRENT int-cc-benef EXCLUSIVE-LOCK.                                                                                                                             */
/*         ASSIGN l-atualizou-provisao = NO.                                                                                                                                     */
/*                                                                                                                                                                               */
/*         FIND FIRST tt-beneficio                                                                                                                                               */
/*             WHERE tt-beneficio.tipo-beneficio = int-cc-benef.tipo-beneficio                                                                                                   */
/*               AND tt-beneficio.unid-neg       = int-cc-benef.unid-neg   NO-ERROR.                                                                                             */
/*                                                                                                                                                                               */
/*         /* ATENÄ«O, AO MUDAR DA NOMENCLATURA DO T÷TULO, ESTA DEVERµ SER CONSIDERADA TAMBêM NO PROGRAMA ESESB005RP.P (CµLCULO) - POIS ELE UTILIZA-SE  */                       */
/*         /* DESTA CODIFICAÄ«O PARA EFETUAR O ESTORNO DA PROVIS«O. O PROGRAMA ESESBAPI003-APB.P TAMBêM UTILIZAR ESSE FORMATO DE C‡DIGO                 */                       */
/*         ASSIGN c-cod-titulo = STRING      (int-cc-benef.tipo-beneficio)        +                                                                                              */
/*                               TRIM(STRING (int-cc-benef.unid-neg))             +                                                                                              */
/*                               string(MONTH(int-cc-benef.dt-periodo-fim), "99") +                                                                                              */
/*                               SUBSTR(string(YEAR (int-cc-benef.dt-periodo-fim), "9999"), 3, 2).                                                                               */
/*                                                                                                                                                                               */
/*         FIND FIRST tit_ap NO-LOCK                                                                                                                                             */
/*             WHERE tit_ap.cod_estab         = tt-beneficio.cod-estabel                                                                                                         */
/*               AND tit_ap.cdn_fornecedor    = int-cc-benef.canal                                                                                                               */
/*               AND tit_ap.cod_espec_docto   = "CPO"                                                                                                                            */
/*               AND tit_ap.cod_ser_docto     = "U"                                                                                                                              */
/*               AND tit_ap.cod_tit_ap        = c-cod-titulo                                                                                                                     */
/*               AND tit_ap.cod_parcela       = "01"   NO-ERROR.                                                                                                                 */
/*                                                                                                                                                                               */
/*         IF  AVAIL tit_ap THEN DO:                                                                                                                                             */
/*              ASSIGN int-cc-benef.cod_estab     = tit_ap.cod_estab                                                                                                             */
/*                     int-cc-benef.num_id_tit_ap = tit_ap.num_id_tit_ap                                                                                                         */
/*                     l-atualizou-provisao       = YES.                                                                                                                         */
/*          END.                                                                                                                                                                 */
/*          ELSE                                                                                                                                                                 */
/*              ASSIGN l-atualizou-provisao = NO.                                                                                                                                */
/*                                                                                                                                                                               */
/*         IF  NOT l-atualizou-provisao THEN DO:                                                                                                                                 */
/*                                                                                                                                                                               */
/*             RUN pi-cria-erro (INPUT 17006, /* Erro */                                                                                                                         */
/*                               INPUT "N∆o foi poss°vel atualizar o registro de provis∆o com o c¢digo do t°tulo: " +                                                            */
/*                                      "     Canal.......: " + STRING(int-cc-benef.canal) +  CHR(10) +                                                                          */
/*                                      "     Unid Neg¢cio: " + int-cc-benef.unid-neg      +  CHR(10) +                                                                          */
/*                                      "     Estab.......: " + tt-beneficio.cod-estabel   +  CHR(10) +                                                                          */
/*                                      "     Cod T°tulo..: " + c-cod-titulo               +  CHR(10),                                                                           */
/*                               INPUT "Processamento n∆o conclu°do.":U).                                                                                                        */
/*             RETURN "NOK".                                                                                                                                                     */
/*         END.                                                                                                                                                                  */
/*         FIND CURRENT int-cc-benef NO-LOCK.                                                                                                                                    */
/*         RELEASE int-cc-benef.                                                                                                                                                 */
/*                                                                                                                                                                               */
/*     END.                                                                                                                                                                      */
/*                                                                                                                                                                               */
/*     /*------------------------------------------------------*/                                                                                                                */
/*     /*        ROTINA ALTERAÄ«O DO T÷TULO DE PROVIS«O        */                                                                                                                */
/*     /*------------------------------------------------------*/                                                                                                                */
/*     RUN pi-efetiva-ALTERECAO-titulo-ABP.                                                                                                                                      */
/*                                                                                                                                                                               */
/*     EMPTY TEMP-TABLE tt_tit_ap_alteracao_base_aux_1.                                                                                                                          */
/*                                                                                                                                                                               */
/*     IF  RETURN-VALUE <> "OK" THEN                                                                                                                                             */
/*         RETURN "NOK".                                                                                                                                                         */
/*                                                                                                                                                                               */
/*     RETURN "OK".                                                                                                                                                              */
/*                                                                                                                                                                               */
/* END.                                                                                                                                                                          */

/* CRIAÄ«O DO T÷TULO REFERENTE AO BENEF÷CIO NO APB*/
PROCEDURE pi-cria-temp-table-titulo:

    DEF INPUT PARAM p-provisao          AS LOG  NO-UNDO.     
    DEF INPUT PARAM p-cod-estab         AS CHAR NO-UNDO.     
    DEF INPUT PARAM p-ep-codigo         AS CHAR NO-UNDO.     
    DEF INPUT PARAM p-referencia        AS CHAR NO-UNDO.     
    DEF INPUT PARAM p-conta             AS CHAR NO-UNDO.     
    DEF INPUT PARAM p-centro-custo      AS CHAR NO-UNDO.     
    DEF INPUT PARAM p-especie           AS CHAR NO-UNDO.     
    DEF INPUT PARAM p-tipo-fluxo        AS CHAR NO-UNDO.     
    DEF INPUT PARAM p-cod-titulo        AS CHAR NO-UNDO.     
    DEF INPUT PARAM p-dt-transacao      AS DATE NO-UNDO.     
    DEF INPUT PARAM p-dt-vencimento     AS DATE NO-UNDO.     
    DEF INPUT PARAM p-canal             AS INT  NO-UNDO.     
    DEF INPUT PARAM p-unid-neg          AS CHAR NO-UNDO.     
    DEF INPUT PARAM p-tipo-beneficio    AS INT  NO-UNDO.     
    DEF INPUT PARAM p-categoria         AS CHAR NO-UNDO.     
    DEF INPUT PARAM p-vl-saldo          AS DEC  NO-UNDO.     
    DEF INPUT PARAM p-da-fim            AS DATE NO-UNDO.  
    
    DEF VAR da-per-ini AS DATE NO-UNDO.
    DEF VAR da-per-fim AS DATE NO-UNDO.

    DEF VAR de-saldo-aprop AS DEC NO-UNDO.
    DEF VAR c-tta_cod_plano_cta_ctbl AS CHAR NO-UNDO.
    DEF VAR c-tta_cod_plano_ccusto  AS CHAR NO-UNDO.
    
    DEF VAR c-refer-aux AS CHAR NO-UNDO.

    v_log_atualiza_refer_apb = YES.

    IF  c-referencia = "" THEN DO:
        DO WHILE TRUE:
            RUN pi-busca-referencia (INPUT  "BNEF",
                                     INPUT  p-cod-estab,
                                     OUTPUT c-refer-aux).
    
            IF  NOT CAN-FIND (FIRST tt_tit_ap_alteracao_base_aux_1
                               WHERE tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer = c-refer-aux) 
            AND NOT CAN-FIND (FIRST tt_integr_apb_lote_impl
                                WHERE tt_integr_apb_lote_impl.tta_cod_refer = c-refer-aux) THEN DO:
    
                ASSIGN c-referencia = c-refer-aux.
                LEAVE.
            END.
        END.
    END.


    /* Verifica se j† existe um lote criado para o esta para o estabelecimento */
    FIND FIRST tt_integr_apb_lote_impl
        WHERE tt_integr_apb_lote_impl.tta_cod_estab         = p-cod-estab
          AND tt_integr_apb_lote_impl.tta_cod_refer         = c-referencia
          AND tt_integr_apb_lote_impl.tta_dat_transacao     = p-dt-transacao
          AND tt_integr_apb_lote_impl.tta_ind_origin_tit_ap = "APB"
          AND tt_integr_apb_lote_impl.tta_cod_empresa       = p-ep-codigo 
          AND IF p-provisao THEN 
              tt_integr_apb_lote_impl.tta_cod_espec_docto = p-especie ELSE 
          YES NO-ERROR.


    IF  NOT AVAIL tt_integr_apb_lote_impl THEN DO:
        CREATE tt_integr_apb_lote_impl.
        ASSIGN tt_integr_apb_lote_impl.tta_cod_estab         = p-cod-estab                  
               tt_integr_apb_lote_impl.tta_cod_refer         = c-referencia.
        
        IF  p-provisao THEN
               tt_integr_apb_lote_impl.tta_cod_espec_docto   = p-especie.

        ASSIGN tt_integr_apb_lote_impl.tta_dat_transacao     = p-dt-transacao 
               tt_integr_apb_lote_impl.tta_ind_origin_tit_ap = "APB"                        
               tt_integr_apb_lote_impl.tta_cod_empresa       = p-ep-codigo. 
        
        VALIDATE tt_integr_apb_lote_impl.

    END.
    
    
    ASSIGN i-seq-ref = i-seq-ref + 1.

    CREATE tt_integr_apb_item_lote_impl_3.
    ASSIGN tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_lote_impl     = recid(tt_integr_apb_lote_impl)
           tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_item_lote     = recid(tt_integr_apb_item_lote_impl_3)
           tt_integr_apb_item_lote_impl_3.tta_num_seq_refer                = i-seq-ref
           tt_integr_apb_item_lote_impl_3.tta_cdn_fornecedor               = p-canal
           tt_integr_apb_item_lote_impl_3.tta_cod_espec_docto              = p-especie
           tt_integr_apb_item_lote_impl_3.tta_cod_ser_docto                = "U"
           tt_integr_apb_item_lote_impl_3.tta_cod_tit_ap                   = p-cod-titulo
           tt_integr_apb_item_lote_impl_3.tta_cod_parcela                  = "01"
           tt_integr_apb_item_lote_impl_3.tta_dat_emis_docto               = p-dt-transacao
           tt_integr_apb_item_lote_impl_3.tta_dat_vencto_tit_ap            = p-dt-vencimento
           tt_integr_apb_item_lote_impl_3.tta_dat_prev_pagto               = p-dt-vencimento
           tt_integr_apb_item_lote_impl_3.tta_cod_forma_pagto              = "30" /*boleto*/
           tt_integr_apb_item_lote_impl_3.tta_cod_indic_econ               = "real"
           tt_integr_apb_item_lote_impl_3.tta_val_tit_ap                   = p-vl-saldo
           tt_integr_apb_item_lote_impl_3.tta_cod_portador                 = "999"
           tt_integr_apb_item_lote_impl_3.tta_val_cotac_indic_econ         = 1.

/*     MESSAGE "tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_lote_impl : " tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_lote_impl    skip  */
/*             "tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_item_lote : " tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_item_lote    skip  */
/*             "tt_integr_apb_item_lote_impl_3.tta_num_seq_refer            : " tt_integr_apb_item_lote_impl_3.tta_num_seq_refer               skip  */
/*             "tt_integr_apb_item_lote_impl_3.tta_cdn_fornecedor           : " tt_integr_apb_item_lote_impl_3.tta_cdn_fornecedor              skip  */
/*             "tt_integr_apb_item_lote_impl_3.tta_cod_espec_docto          : " tt_integr_apb_item_lote_impl_3.tta_cod_espec_docto             skip  */
/*             "tt_integr_apb_item_lote_impl_3.tta_cod_ser_docto            : " tt_integr_apb_item_lote_impl_3.tta_cod_ser_docto               skip  */
/*             "tt_integr_apb_item_lote_impl_3.tta_cod_tit_ap               : " tt_integr_apb_item_lote_impl_3.tta_cod_tit_ap                  skip  */
/*             "tt_integr_apb_item_lote_impl_3.tta_cod_parcela              : " tt_integr_apb_item_lote_impl_3.tta_cod_parcela                 skip  */
/*             "tt_integr_apb_item_lote_impl_3.tta_dat_emis_docto           : " tt_integr_apb_item_lote_impl_3.tta_dat_emis_docto              skip  */
/*             "tt_integr_apb_item_lote_impl_3.tta_dat_vencto_tit_ap        : " tt_integr_apb_item_lote_impl_3.tta_dat_vencto_tit_ap           skip  */
/*             "tt_integr_apb_item_lote_impl_3.tta_dat_prev_pagto           : " tt_integr_apb_item_lote_impl_3.tta_dat_prev_pagto              skip  */
/*             "tt_integr_apb_item_lote_impl_3.tta_cod_forma_pagto          : " tt_integr_apb_item_lote_impl_3.tta_cod_forma_pagto             skip  */
/*             "tt_integr_apb_item_lote_impl_3.tta_cod_indic_econ           : " tt_integr_apb_item_lote_impl_3.tta_cod_indic_econ              skip  */
/*             "tt_integr_apb_item_lote_impl_3.tta_val_tit_ap               : " tt_integr_apb_item_lote_impl_3.tta_val_tit_ap                  skip  */
/*             "tt_integr_apb_item_lote_impl_3.tta_cod_portador             : " tt_integr_apb_item_lote_impl_3.tta_cod_portador                skip  */
/*             "tt_integr_apb_item_lote_impl_3.tta_val_cotac_indic_econ     : " tt_integr_apb_item_lote_impl_3.tta_val_cotac_indic_econ              */
/*             "                                                                                                                                     */
/*             "                                                                                                                                     */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                                                        */


    VALIDATE tt_integr_apb_item_lote_impl_3.
      
    ASSIGN de-saldo-aprop           = p-vl-saldo
           c-tta_cod_plano_cta_ctbl = "Padrao"
           c-tta_cod_plano_ccusto   = "Padrao".


    /* Verifica o per°odo inicial e final, pois para o VMC-Prata/bronze Ç diferente */
    IF  p-tipo-beneficio = 21 AND p-categoria <> "OURO" THEN 
        ASSIGN da-per-ini = IF  MONTH(p-da-fim) <= 9 THEN  DATE(01,01,YEAR(p-da-fim)) ELSE DATE(10,01,YEAR(p-da-fim))  
               da-per-fim = IF  MONTH(p-da-fim) <= 9 THEN  DATE(09,30,YEAR(p-da-fim)) ELSE DATE(12,31,YEAR(p-da-fim)). 
    ELSE
        ASSIGN da-per-ini = da-ini-trimestre 
               da-per-fim = da-fim-trimestre. 

    IF  NOT p-provisao THEN DO:
        IF  MONTH(p-da-fim) = 3
        OR  MONTH(p-da-fim) = 6
        OR  MONTH(p-da-fim) = 9
        OR  MONTH(p-da-fim) = 12 THEN
            RUN pi-altera-provisao (INPUT  p-canal,
                                    INPUT  p-tipo-beneficio,
                                    INPUT  p-unid-neg,
                                    INPUT  p-categoria,
                                    INPUT  "CPO",  /*EspÇcie*/
                                    INPUT  da-per-ini,
                                    INPUT  da-per-fim,
                                    INPUT  p-vl-saldo,
                                    INPUT  p-dt-transacao /*p-da-fim*/,
                                    OUTPUT de-saldo-aprop).

        IF  RETURN-VALUE <> "OK" THEN
            RETURN "NOK".
    END.

    /*Apropriaá∆o dos t°tulos*/
    create tt_integr_apb_aprop_ctbl_pend.
    assign tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_item_lote  = recid(tt_integr_apb_item_lote_impl_3)
           tt_integr_apb_aprop_ctbl_pend.ttv_rec_antecip_pef_pend      = ?
           tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_impto_pend = ?
           tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc            = p-unid-neg
           tt_integr_apb_aprop_ctbl_pend.tta_cod_tip_fluxo_financ      = p-tipo-fluxo
           tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl            = p-vl-saldo /* Saldo da conta de despesas */
           tt_integr_apb_aprop_ctbl_pend.tta_cod_pais                  = ""
           tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_federac          = ""
           tt_integr_apb_aprop_ctbl_pend.tta_cod_imposto               = ""
           tt_integr_apb_aprop_ctbl_pend.tta_cod_classif_impto         = ""
           tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl        = c-tta_cod_plano_cta_ctbl
           tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl              = p-conta
           tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_ccusto          = c-tta_cod_plano_ccusto
           tt_integr_apb_aprop_ctbl_pend.tta_cod_ccusto                = p-centro-custo.
    VALIDATE tt_integr_apb_aprop_ctbl_pend.


/*     MESSAGE 'tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_item_lote  : ' tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_item_lote     skip  */
/*             'tt_integr_apb_aprop_ctbl_pend.ttv_rec_antecip_pef_pend      : ' tt_integr_apb_aprop_ctbl_pend.ttv_rec_antecip_pef_pend         skip  */
/*             'tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_impto_pend : ' tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_impto_pend    skip  */
/*             'tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc            : ' tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc               skip  */
/*             'tt_integr_apb_aprop_ctbl_pend.tta_cod_tip_fluxo_financ      : ' tt_integr_apb_aprop_ctbl_pend.tta_cod_tip_fluxo_financ         skip  */
/*             'tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl            : ' tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl               skip  */
/*             'tt_integr_apb_aprop_ctbl_pend.tta_cod_pais                  : ' tt_integr_apb_aprop_ctbl_pend.tta_cod_pais                     skip  */
/*             'tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_federac          : ' tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_federac             skip  */
/*             'tt_integr_apb_aprop_ctbl_pend.tta_cod_imposto               : ' tt_integr_apb_aprop_ctbl_pend.tta_cod_imposto                  skip  */
/*             'tt_integr_apb_aprop_ctbl_pend.tta_cod_classif_impto         : ' tt_integr_apb_aprop_ctbl_pend.tta_cod_classif_impto            skip  */
/*             'tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl        : ' tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl           skip  */
/*             'tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl              : ' tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl                 skip  */
/*             'tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_ccusto          : ' tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_ccusto             skip  */
/*             'tt_integr_apb_aprop_ctbl_pend.tta_cod_ccusto                : ' tt_integr_apb_aprop_ctbl_pend.tta_cod_ccusto                   skip  */
/*                                                                                                                                                   */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                                                        */


    RETURN "OK".           
END.

/* ALTERAÄ«O DO T÷TULO REFERENTE AO BENEF÷CIO NO APB*/
PROCEDURE pi-ALTERA-temp-table-titulo:

    DEF INPUT PARAM p-cod-estab   AS CHAR NO-UNDO.
    DEF INPUT PARAM p-dt-transcao AS DATE NO-UNDO.
    DEF INPUT PARAM p-dt-vencto   AS DATE NO-UNDO.
    DEF INPUT PARAM p-de-saldo    AS DEC  NO-UNDO.
    DEF INPUT PARAM p-motivo      AS CHAR NO-UNDO.
    DEF INPUT PARAM p-referencia  AS CHAR NO-UNDO.

    DEF VAR c-refer AS CHAR NO-UNDO.

    /*busca referencia*/
    ASSIGN c-refer = "".
/*     RUN pi-busca-referencia (INPUT  "BNEF",       */
/*                              INPUT  p-cod-estab,  */
/*                              OUTPUT c-refer).     */

    DO WHILE TRUE:
    
        RUN pi-busca-referencia (INPUT  "BNEF",
                                 INPUT  p-cod-estab,
                                 OUTPUT c-refer).
        IF  NOT CAN-FIND (FIRST tt_tit_ap_alteracao_base_aux_1
                           WHERE tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer = c-refer) 
        AND NOT CAN-FIND (FIRST tt_integr_apb_lote_impl
                            WHERE tt_integr_apb_lote_impl.tta_cod_refer = c-refer) THEN
            LEAVE.

    END.

    create tt_tit_ap_alteracao_base_aux_1.
    assign tt_tit_ap_alteracao_base_aux_1.ttv_cod_usuar_corren             = c-usuario
           tt_tit_ap_alteracao_base_aux_1.tta_cod_empresa                  = tit_ap.cod_empresa
           tt_tit_ap_alteracao_base_aux_1.tta_cod_estab                    = tit_ap.cod_estab
           tt_tit_ap_alteracao_base_aux_1.tta_num_id_tit_ap                = tit_ap.num_id_tit_ap
           tt_tit_ap_alteracao_base_aux_1.ttv_rec_tit_ap                   = recid(tt_tit_ap_alteracao_base_aux_1)
           tt_tit_ap_alteracao_base_aux_1.tta_cdn_fornecedor               = tit_ap.cdn_fornecedor
           tt_tit_ap_alteracao_base_aux_1.tta_cod_espec_docto              = tit_ap.cod_espec_docto
           tt_tit_ap_alteracao_base_aux_1.tta_cod_ser_docto                = tit_ap.cod_ser_docto
           tt_tit_ap_alteracao_base_aux_1.tta_cod_tit_ap                   = tit_ap.cod_tit_ap
           tt_tit_ap_alteracao_base_aux_1.tta_cod_parcela                  = tit_ap.cod_parcela
           tt_tit_ap_alteracao_base_aux_1.ttv_dat_transacao                = p-dt-transcao
           tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer                    = c-refer 
           tt_tit_ap_alteracao_base_aux_1.tta_val_sdo_tit_ap               = p-de-saldo
           tt_tit_ap_alteracao_base_aux_1.tta_dat_emis_docto               = tit_ap.dat_emis_docto
           tt_tit_ap_alteracao_base_aux_1.tta_dat_vencto_tit_ap            = p-dt-vencto
           tt_tit_ap_alteracao_base_aux_1.tta_dat_prev_pagto               = tit_ap.dat_prev_pagto
           tt_tit_ap_alteracao_base_aux_1.tta_dat_ult_pagto                = tit_ap.dat_ult_pagto
           tt_tit_ap_alteracao_base_aux_1.tta_num_dias_atraso              = tit_ap.num_dias_atraso
           tt_tit_ap_alteracao_base_aux_1.tta_val_perc_multa_atraso        = tit_ap.val_perc_multa_atraso
           tt_tit_ap_alteracao_base_aux_1.tta_val_juros_dia_atraso         = tit_ap.val_juros_dia_atraso
           tt_tit_ap_alteracao_base_aux_1.tta_val_perc_juros_dia_atraso    = tit_ap.val_perc_juros_dia_atraso
           tt_tit_ap_alteracao_base_aux_1.tta_dat_desconto                 = tit_ap.dat_desconto
           tt_tit_ap_alteracao_base_aux_1.tta_val_perc_desc                = tit_ap.val_perc_desc
           tt_tit_ap_alteracao_base_aux_1.tta_val_desconto                 = tit_ap.val_desconto
           tt_tit_ap_alteracao_base_aux_1.tta_cod_portador                 = tit_ap.cod_portador
           tt_tit_ap_alteracao_base_aux_1.tta_log_pagto_bloqdo             = tit_ap.log_pagto_bloqdo
           tt_tit_ap_alteracao_base_aux_1.tta_cod_seguradora               = tit_ap.cod_seguradora
           tt_tit_ap_alteracao_base_aux_1.tta_cod_apol_seguro              = tit_ap.cod_apol_seguro
           tt_tit_ap_alteracao_base_aux_1.tta_cod_arrendador               = tit_ap.cod_arrendador
           tt_tit_ap_alteracao_base_aux_1.tta_cod_contrat_leas             = tit_ap.cod_contrat_leas
           tt_tit_ap_alteracao_base_aux_1.tta_ind_tip_espec_docto          = tit_ap.ind_tip_espec_docto
           tt_tit_ap_alteracao_base_aux_1.tta_cod_indic_econ               = tit_ap.cod_indic_econ
           tt_tit_ap_alteracao_base_aux_1.ttv_ind_motiv_alter_val_tit_ap   = "alteraá∆o"
           tt_tit_ap_alteracao_base_aux_1.tta_cod_histor_padr              = ""
           tt_tit_ap_alteracao_base_aux_1.tta_des_histor_padr              = p-motivo + " -> Programas chamadores: " +  (IF  PROGRAM-NAME( 1) <> ? THEN PROGRAM-NAME( 1) ELSE "") + chr(10)
                                                                                                                     +  (IF  PROGRAM-NAME( 2) <> ? THEN PROGRAM-NAME( 2) ELSE "") + chr(10)
                                                                                                                     +  (IF  PROGRAM-NAME( 3) <> ? THEN PROGRAM-NAME( 3) ELSE "") + chr(10)
                                                                                                                     +  (IF  PROGRAM-NAME( 4) <> ? THEN PROGRAM-NAME( 4) ELSE "") + chr(10)
                                                                                                                     +  (IF  PROGRAM-NAME( 5) <> ? THEN PROGRAM-NAME( 5) ELSE "") + chr(10)
                                                                                                                     +  (IF  PROGRAM-NAME( 6) <> ? THEN PROGRAM-NAME( 6) ELSE "") + chr(10)
                                                                                                                     +  (IF  PROGRAM-NAME( 7) <> ? THEN PROGRAM-NAME( 7) ELSE "") + chr(10)
                                                                                                                     +  (IF  PROGRAM-NAME( 8) <> ? THEN PROGRAM-NAME( 8) ELSE "") + chr(10)
                                                                                                                     +  (IF  PROGRAM-NAME( 9) <> ? THEN PROGRAM-NAME( 9) ELSE "") + chr(10)
                                                                                                                     +  (IF  PROGRAM-NAME(10) <> ? THEN PROGRAM-NAME(10) ELSE "")
           tt_tit_ap_alteracao_base_aux_1.tta_ind_sit_tit_ap               = tit_ap.ind_sit_tit_ap              
           tt_tit_ap_alteracao_base_aux_1.tta_cod_forma_pagto              = tit_ap.cod_forma_pagto.

           VALIDATE tt_tit_ap_alteracao_base_aux_1.

/*     MESSAGE "tt_tit_ap_alteracao_base_aux_1.ttv_cod_usuar_corren           : " tt_tit_ap_alteracao_base_aux_1.ttv_cod_usuar_corren            skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_empresa                : " tt_tit_ap_alteracao_base_aux_1.tta_cod_empresa                 skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_estab                  : " tt_tit_ap_alteracao_base_aux_1.tta_cod_estab                   skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_num_id_tit_ap              : " tt_tit_ap_alteracao_base_aux_1.tta_num_id_tit_ap               skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.ttv_rec_tit_ap                 : " tt_tit_ap_alteracao_base_aux_1.ttv_rec_tit_ap                  skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_cdn_fornecedor             : " tt_tit_ap_alteracao_base_aux_1.tta_cdn_fornecedor              skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_espec_docto            : " tt_tit_ap_alteracao_base_aux_1.tta_cod_espec_docto             skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_ser_docto              : " tt_tit_ap_alteracao_base_aux_1.tta_cod_ser_docto               skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_tit_ap                 : " tt_tit_ap_alteracao_base_aux_1.tta_cod_tit_ap                  skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_parcela                : " tt_tit_ap_alteracao_base_aux_1.tta_cod_parcela                 skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.ttv_dat_transacao              : " tt_tit_ap_alteracao_base_aux_1.ttv_dat_transacao               skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer                  : " tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer                   skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_val_sdo_tit_ap             : " tt_tit_ap_alteracao_base_aux_1.tta_val_sdo_tit_ap              skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_dat_emis_docto             : " tt_tit_ap_alteracao_base_aux_1.tta_dat_emis_docto              skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_dat_vencto_tit_ap          : " tt_tit_ap_alteracao_base_aux_1.tta_dat_vencto_tit_ap           skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_dat_prev_pagto             : " tt_tit_ap_alteracao_base_aux_1.tta_dat_prev_pagto              skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_dat_ult_pagto              : " tt_tit_ap_alteracao_base_aux_1.tta_dat_ult_pagto               skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_num_dias_atraso            : " tt_tit_ap_alteracao_base_aux_1.tta_num_dias_atraso             skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_val_perc_multa_atraso      : " tt_tit_ap_alteracao_base_aux_1.tta_val_perc_multa_atraso       skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_val_juros_dia_atraso       : " tt_tit_ap_alteracao_base_aux_1.tta_val_juros_dia_atraso        skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_val_perc_juros_dia_atraso  : " tt_tit_ap_alteracao_base_aux_1.tta_val_perc_juros_dia_atraso   skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_dat_desconto               : " tt_tit_ap_alteracao_base_aux_1.tta_dat_desconto                skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_val_perc_desc              : " tt_tit_ap_alteracao_base_aux_1.tta_val_perc_desc               skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_val_desconto               : " tt_tit_ap_alteracao_base_aux_1.tta_val_desconto                skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_portador               : " tt_tit_ap_alteracao_base_aux_1.tta_cod_portador                skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_log_pagto_bloqdo           : " tt_tit_ap_alteracao_base_aux_1.tta_log_pagto_bloqdo            skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_seguradora             : " tt_tit_ap_alteracao_base_aux_1.tta_cod_seguradora              skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_apol_seguro            : " tt_tit_ap_alteracao_base_aux_1.tta_cod_apol_seguro             skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_arrendador             : " tt_tit_ap_alteracao_base_aux_1.tta_cod_arrendador              skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_contrat_leas           : " tt_tit_ap_alteracao_base_aux_1.tta_cod_contrat_leas            skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_ind_tip_espec_docto        : " tt_tit_ap_alteracao_base_aux_1.tta_ind_tip_espec_docto         skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_indic_econ             : " tt_tit_ap_alteracao_base_aux_1.tta_cod_indic_econ              skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.ttv_ind_motiv_alter_val_tit_ap : " tt_tit_ap_alteracao_base_aux_1.ttv_ind_motiv_alter_val_tit_ap  skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_histor_padr            : " tt_tit_ap_alteracao_base_aux_1.tta_cod_histor_padr             skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_des_histor_padr            : " tt_tit_ap_alteracao_base_aux_1.tta_des_histor_padr             skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_ind_sit_tit_ap             : " tt_tit_ap_alteracao_base_aux_1.tta_ind_sit_tit_ap              skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_forma_pagto            : " tt_tit_ap_alteracao_base_aux_1.tta_cod_forma_pagto             skip  */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                                                          */

    RETURN "OK".
END.

PROCEDURE pi-cria-erro:

    DEFINE INPUT PARAM p-erro     AS INTEGER NO-UNDO.
    DEFINE INPUT PARAM p-mensagem AS CHAR NO-UNDO.
    DEFINE INPUT PARAM p-ajuda    AS CHAR NO-UNDO.

    CREATE tt-erro.
    ASSIGN tt-erro.codigo   = p-erro
           tt-erro.mensagem = p-mensagem
           tt-erro.ajuda    = p-ajuda.

END.


/*-------------------------------------------------------------------*/
/*        B U S C A R   B E N E F ÷ C I O S   D O   C A N A L        */
/*-------------------------------------------------------------------*/
PROCEDURE pi-busca-beneficios-canal:

    DEF INPUT PARAM p-provisao AS LOGICAL NO-UNDO.
    
    /*------------------------------------------------------------------------------*/
    /*  API QUE RETORA OS BENEF÷CIOS DO CANAL, COM OS %(s) PARA PROVIS«O E CµLCULO  */
    /*------------------------------------------------------------------------------*/

    CREATE tt-canal.
    ASSIGN tt-canal.canal      = int-cc-benef.canal
           tt-canal.guid-canal = int-emitente.cod-guid
           tt-canal.guid-class = int-emitente.guid-class.

    EMPTY TEMP-TABLE tt-erro-benef.
    EMPTY TEMP-TABLE tt-beneficio.

    RUN esp/esb/esesbapi004-benef.p (INPUT  p-provisao,
                                     INPUT  YES,  /* Buscar msg0111 com o % global de cada benef°cio   */
                                     INPUT  YES,  /* Buscar msg0142, parÉmetros financeiros e provis∆o */
                                     INPUT  int-cc-benef.unid-neg,        /* (?) para buscar todas as unidades, ou informar uma unidade espec°fica */
                                     INPUT  int-cc-benef.tipo-beneficio,  /* (?) para buscar todas os beneficios, ou informar uma beneficio espec°fico */
                                     INPUT  TABLE tt-canal,
                                     OUTPUT TABLE tt-erro-benef,
                                     OUTPUT TABLE tt-beneficio).

    IF  RETURN-VALUE <> "OK" 
    OR  CAN-FIND (FIRST tt-erro-benef) THEN DO:
        FOR EACH tt-erro-benef:
            CREATE tt-erro.
            BUFFER-COPY tt-erro-benef TO tt-erro.
        END.
        RETURN "NOK".
    END.
    
    RETURN "OK".
END.


PROCEDURE pi-altera-provisao:

    DEF INPUT  PARAM p-canal         AS INTEGER NO-UNDO.
    DEF INPUT  PARAM p-tp-beneficio  AS INTEGER NO-UNDO.
    DEF INPUT  PARAM p-unid-neg      AS CHAR    NO-UNDO.
    DEF INPUT  PARAM p-categoria     AS CHAR    NO-UNDO.
    DEF INPUT  PARAM p-especie       AS CHAR    NO-UNDO.
    DEF INPUT  PARAM p-periodo-ini   AS DATE    NO-UNDO.
    DEF INPUT  PARAM p-periodo-fim   AS DATE    NO-UNDO.
    DEF INPUT  PARAM p-saldo         AS DEC     NO-UNDO. /*Saldo da operaá∆o Rebate*/
    DEF INPUT  PARAM p-da-transacao  AS DATE    NO-UNDO.
    DEF OUTPUT PARAM p-saldo-aprop   AS DEC     NO-UNDO. /*Saldo da apropriacao*/
    
    DEF BUFFER b-int-cc-benef FOR int-cc-benef.

    FIND FIRST b-int-cc-benef NO-LOCK
         WHERE b-int-cc-benef.tp-movto       = 1 /*PROVIS«O*/
           AND b-int-cc-benef.canal          = p-canal
           AND b-int-cc-benef.tipo-beneficio = p-tp-beneficio
           AND b-int-cc-benef.unid-neg       = p-unid-neg
           AND b-int-cc-benef.dt-periodo-ini = p-periodo-ini
           AND b-int-cc-benef.dt-periodo-fim = p-periodo-fim NO-ERROR.

    IF  NOT AVAIL b-int-cc-benef THEN
        RETURN "OK".

    FIND FIRST tit_ap
        WHERE tit_ap.cod_estab     = b-int-cc-benef.cod_estab
          AND tit_ap.num_id_tit_ap = b-int-cc-benef.num_id_tit_ap NO-LOCK NO-ERROR.
    
    IF  AVAILABLE tit_ap /*AND tit_ap.val_sdo_tit_ap > 0 */ THEN DO: 
        CREATE tt_integr_apb_abat_prev_provis.
        ASSIGN tt_integr_apb_abat_prev_provis.ttv_rec_integr_apb_item_lote = tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_item_lote
               tt_integr_apb_abat_prev_provis.ttv_rec_antecip_pef_pend     = ? 
               tt_integr_apb_abat_prev_provis.tta_cod_estab                = tit_ap.cod_estab
               tt_integr_apb_abat_prev_provis.tta_cod_espec_docto          = p-especie
               tt_integr_apb_abat_prev_provis.tta_cod_ser_docto            = tit_ap.cod_ser_docto 
               tt_integr_apb_abat_prev_provis.tta_cdn_fornecedor           = tit_ap.cdn_fornecedor
               tt_integr_apb_abat_prev_provis.tta_cod_tit_ap               = tit_ap.cod_tit_ap    
               tt_integr_apb_abat_prev_provis.tta_cod_parcela              = tit_ap.cod_parcela.
    
        /*-----------------------------------------------------------------------------*/
        /*   VALOR DO SALDO DO BENEFICIO EFETIVAMENTE APURADO, EXCEDE O PROVISIONADO   */
        /*-----------------------------------------------------------------------------*/
        IF  p-saldo > b-int-cc-benef.vl-saldo  THEN DO:
            /* Para que o valor da apropriaá∆o fique correto, abate do Saldo do Benef°cio apurado, o valor que havia side provisionado */
            ASSIGN tt_integr_apb_abat_prev_provis.tta_val_abat_tit_ap = tit_ap.val_sdo_tit_ap 
                   p-saldo-aprop = p-saldo - tit_ap.val_sdo_tit_ap.
        END.

        /*-------------------------------------------------------------------------------------------*/
        /*   VALOR DO SALDO DO BENEFICIO EFETIVAMENTE APURADO, ê INFERIOR OU IGUAL AO PROVISIONADO   */
        /*-------------------------------------------------------------------------------------------*/
        IF  p-saldo <= b-int-cc-benef.vl-saldo THEN DO:
            ASSIGN tt_integr_apb_abat_prev_provis.tta_val_abat_tit_ap = p-saldo
                   p-saldo-aprop = p-saldo.
            /* ZERAR O SALDO DO T÷TULO PROVISIONADO */
            RUN pi-ALTERA-temp-table-titulo (INPUT c-cod-estab,
                                             INPUT p-da-transacao, /* data da transaá∆o */
                                             INPUT tit_ap.dat_vencto_tit_ap,
                                             INPUT 0, /*alteraá∆o de saldo*/
                                             INPUT "Zerado saldo t°tulo provis∆o, visto que o valor de Benef°cio apurado excede o provisionado",
                                             INPUT "" /*dentro da api ser† buscada uma referencia de provis∆o*/).
            IF  RETURN-VALUE <> "OK" THEN
                RETURN "NOK".

        END.
/*         MESSAGE 'tt_integr_apb_abat_prev_provis.ttv_rec_integr_apb_item_lote : ' tt_integr_apb_abat_prev_provis.ttv_rec_integr_apb_item_lote skip  */
/*                 'tt_integr_apb_abat_prev_provis.ttv_rec_antecip_pef_pend     : ' tt_integr_apb_abat_prev_provis.ttv_rec_antecip_pef_pend     skip  */
/*                 'tt_integr_apb_abat_prev_provis.tta_cod_estab                : ' tt_integr_apb_abat_prev_provis.tta_cod_estab                skip  */
/*                 'tt_integr_apb_abat_prev_provis.tta_cod_espec_docto          : ' tt_integr_apb_abat_prev_provis.tta_cod_espec_docto          skip  */
/*                 'tt_integr_apb_abat_prev_provis.tta_cod_ser_docto            : ' tt_integr_apb_abat_prev_provis.tta_cod_ser_docto            skip  */
/*                 'tt_integr_apb_abat_prev_provis.tta_cdn_fornecedor           : ' tt_integr_apb_abat_prev_provis.tta_cdn_fornecedor           skip  */
/*                 'tt_integr_apb_abat_prev_provis.tta_cod_tit_ap               : ' tt_integr_apb_abat_prev_provis.tta_cod_tit_ap               skip  */
/*                 'tt_integr_apb_abat_prev_provis.tta_cod_parcela              : ' tt_integr_apb_abat_prev_provis.tta_cod_parcela              skip  */
/*                 "tt_integr_apb_abat_prev_provis.tta_val_abat_tit_ap          : " tt_integr_apb_abat_prev_provis.tta_val_abat_tit_ap SKIP           */
/*                 "p-saldo-aprop: " p-saldo-aprop                                                                                                    */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                                                     */

        VALIDATE tt_integr_apb_abat_prev_provis.

    END.

    RETURN "OK".
END.

FUNCTION fn-retorna-nome-beneficio RETURNS CHAR
    (p-beneficio AS INT):
    
    CASE p-beneficio:
        WHEN 21 THEN RETURN "VMC".
        WHEN 22 THEN RETURN "STOCK ROTATION".
        WHEN 37 THEN RETURN "REBATE".
        WHEN 66 THEN RETURN "REBATE P‡S-VENDA".
        WHEN 08 THEN RETURN "PRICE PROTECTION".
    END CASE.

    RETURN "".
END FUNCTION.

