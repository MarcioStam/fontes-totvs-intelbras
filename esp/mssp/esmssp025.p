/*------------------------------------------------------------------------
    File        : ESMSSP025.P
    Purpose     : Alteraá∆o Fiscal do Item
    Procedure   : alterarFiscalItem
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (SQL Works / Exponencial TI)
    Created     : Julho de 2012
    Notes       : <none>
------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-item NO-UNDO
    FIELD it-codigo        LIKE item.it-codigo            /* C¢digo do Item              */
    FIELD fm-codigo        LIKE item.fm-codigo            /* Fam°lia Material            */
    FIELD narrativa        LIKE item.narrativa            /* Narrativa                   */
    FIELD responsavel      LIKE item.responsavel          /* Respons†vel                 */
    FIELD class-fiscal     LIKE item.class-fiscal         /* NCM                         */
    FIELD ge-codigo        LIKE item.ge-codigo            /* Grupo de Estoque            */
    FIELD destaq-ncm       LIKE int-item.destaque         /* Destaque NCM                */
    FIELD perc-gatt        LIKE int-item.perc-gatt        /* Percentual GATT             */
    FIELD ex-tarifario     LIKE int-item.ex-tarifario     /* Ex Tarif†rio                */
    FIELD nve              LIKE int-item.nve              /* NVE                         */
    FIELD seq-suframa      LIKE int-item.seq-suframa      /* Sequància SUFRAMA           */
    FIELD tipo-item        AS CHARACTER FORMAT "x(02)":U  /* Tipo do Item                */
    FIELD versao           AS DECIMAL                     /* Vers∆o                      */
    FIELD data-versao      AS DATE                        /* Data de Vers∆o              */
    FIELD aliquota-ii      AS DECIMAL                     /* Al°quota Imposto Importaá∆o */
    FIELD aliquota-ipi     LIKE item.aliquota-ipi         /* Al°quota IPI                */
    FIELD aliquota-pis     AS DECIMAL                     /* Al°quota PIS                */
    FIELD aliquota-cofins  AS DECIMAL                     /* Al°quota COFINS             */
    FIELD log-necessita-li LIKE item.log-necessita-li     /* Necessita LI?               */
    FIELD log-antidumping  LIKE int-item.log-antidumping  /* Tem Antidumping             */
    FIELD obs-antidumping  LIKE int-item.obs-antidumping  /* Observaá∆o Antidumping      */
    FIELD cest             LIKE sit-tribut.cdn-sit-tribut /* CEST                        */
    INDEX idx-item AS PRIMARY
        it-codigo.

DEFINE TEMP-TABLE tt-mensagem NO-UNDO
    FIELD sequencia   AS INTEGER   FORMAT ">>>>9":U LABEL "Sequància":U     COLUMN-LABEL "Seq":U
    FIELD codigo      LIKE cadast_msg.cdn_msg
    FIELD tipo        AS CHARACTER FORMAT "x(20)":U LABEL "Tipo Mensagem":U COLUMN-LABEL "Tipo Msg":U
    FIELD mensagem    LIKE cadast_msg.des_text_msg
    FIELD complemento LIKE cadast_msg.dsl_help_msg
    INDEX chPrimaria IS PRIMARY UNIQUE
        sequencia
    INDEX chCodigo
        sequencia
        codigo
    INDEX chTipo
        sequencia
        tipo.

DEFINE VARIABLE c-usuario      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-senha        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-esmsspapi001 AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-mensagem     AS CHARACTER   NO-UNDO.
/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER TABLE FOR tt-item.
DEFINE OUTPUT PARAMETER TABLE FOR tt-mensagem.


/* ***************************  Main Block  *************************** */

FIND FIRST ponto-programa
    WHERE ponto-programa.nome-programa = "escrm004":U
    AND ponto-programa.ponto         = 1 NO-LOCK NO-ERROR.
    
IF AVAILABLE ponto-programa THEN DO:
    FOR EACH conteudo-programa
       WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa NO-LOCK:
            
        IF conteudo-programa.sequencia = 1 THEN DO:
            assign c-usuario = ENTRY(1,conteudo-programa.conteudo,",")
                   c-senha   = ENTRY(2,conteudo-programa.conteudo,",").
        END.
    END.
END.
    
RUN bi/esbi002.p (INPUT c-usuario,
                  INPUT c-senha).

/**/

EMPTY TEMP-TABLE tt-mensagem.

FIND FIRST tt-item NO-ERROR.

IF NOT AVAILABLE tt-item THEN DO:
    RUN pi-cria-mensagem (INPUT 17006,
                          INPUT "ParÉmetros do item est† vazio!":U).

    RETURN "NOK":U.
END.

FIND FIRST item
    WHERE item.it-codigo = tt-item.it-codigo EXCLUSIVE-LOCK NO-ERROR.

IF NOT AVAILABLE item THEN DO:
    RUN pi-cria-mensagem (INPUT 2,
                          INPUT "Item":U).

    RETURN "NOK":U.
END.

ASSIGN item.fm-codigo              = tt-item.fm-codigo
       item.narrativa              = tt-item.narrativa
       item.responsavel            = tt-item.responsavel
       item.class-fiscal           = tt-item.class-fiscal
       /*item.ge-codigo              = tt-item.ge-codigo*/
       /*ITEM.aliquota-ii            = tt-item.aliquota-ii*/
       overlay(ITEM.char-2, 22, 6) = string(tt-item.aliquota-ii, ">>9.99")
       item.aliquota-ipi           = tt-item.aliquota-ipi
       OVERLAY(item.char-2, 31, 5) = STRING(tt-item.aliquota-pis, ">9.99":U)
       OVERLAY(item.char-2, 36, 5) = STRING(tt-item.aliquota-cofins, ">9.99":U)
       item.log-necessita-li       = tt-item.log-necessita-li.

FIND FIRST item-mat
    WHERE item-mat.it-codigo = item.it-codigo EXCLUSIVE-LOCK NO-ERROR.

IF AVAILABLE item-mat THEN
    ASSIGN item-mat.val-aliq-ext-pis    = tt-item.aliquota-pis
           item-mat.val-aliq-ext-cofins = tt-item.aliquota-cofins.

FIND FIRST int-item
    WHERE int-item.it-codigo = tt-item.it-codigo EXCLUSIVE-LOCK NO-ERROR.

IF NOT AVAILABLE int-item THEN DO:
    CREATE int-item.
    ASSIGN int-item.it-codigo = tt-item.it-codigo.
END.

ASSIGN int-item.destaque        = tt-item.destaq-ncm
       int-item.perc-gatt       = tt-item.perc-gatt
       int-item.log-gatt        = tt-item.perc-gatt <> 0
       int-item.ex-tarifario    = tt-item.ex-tarifario
       int-item.nve             = tt-item.nve
       int-item.seq-suframa     = tt-item.seq-suframa
       int-item.log-antidumping = tt-item.log-antidumping
       int-item.obs-antidumping = tt-item.obs-antidumping.

RUN pi-caracteristica-item.

/* CEST - C¢digo especificador da substituiá∆o tribut†ria - Carlos Daniel - 04/03/2016*/
RUN esp/mssp/esmsspapi001.p PERSISTENT SET h-esmsspapi001.

ASSIGN c-mensagem = "".

RUN piGeraRelactoCest IN h-esmsspapi001 (INPUT tt-item.cest,     /* CEST */
                                         INPUT TODAY,             /* Data inicio validade */
                                         INPUT "*",               /* Estabelecimento */
                                         INPUT "*",               /* UF */
                                         INPUT "*",               /* Natureza de Operaá∆o */
                                         INPUT "*",               /* NCM */
                                         INPUT tt-item.it-codigo, /* Item */
                                         INPUT 0,                 /* Emitente */
                                         OUTPUT c-mensagem).

IF VALID-HANDLE(h-esmsspapi001) THEN
    DELETE PROCEDURE h-esmsspapi001.

IF RETURN-VALUE <> "OK" THEN DO:
    RUN pi-cria-mensagem (INPUT 17006,
                          INPUT c-mensagem).
    RETURN "NOK".
END.

RETURN "OK":U.


/* **********************  Internal Procedures  *********************** */

PROCEDURE pi-caracteristica-item :
/*------------------------------------------------------------------------------
  Purpose:     Cadastros das caracter°sticas do item.
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    IF NOT AVAILABLE tt-item THEN
        FIND FIRST tt-item NO-ERROR.

    FOR EACH comp-folh NO-LOCK
        WHERE comp-folh.cd-folha = "1":U:
        FIND FIRST it-carac-tec
            WHERE it-carac-tec.it-codigo = tt-item.it-codigo
              AND it-carac-tec.cd-folha  = comp-folh.cd-folha
              AND it-carac-tec.cd-comp   = comp-folh.cd-comp EXCLUSIVE-LOCK NO-ERROR.

        IF NOT AVAILABLE it-carac-tec THEN DO:
            CREATE it-carac-tec.
            ASSIGN it-carac-tec.it-codigo = tt-item.it-codigo 
                   it-carac-tec.cd-folha  = comp-folh.cd-folha 
                   it-carac-tec.cd-comp   = comp-folh.cd-comp.
        END.

        ASSIGN it-carac-tec.tipo-result = comp-folh.tipo-result.

        /* Vers∆o - tipo numerico = 1 */
        IF comp-folh.tipo-result = 1 THEN
            IF comp-folh.descricao = "versao":U THEN
                ASSIGN it-carac-tec.vl-result = INTEGER(tt-item.versao).

        /* Responsavel - tipo observacao = 4 */
        IF comp-folh.tipo-result = 4 THEN
            IF comp-folh.descricao = "responsavel":U THEN
                ASSIGN it-carac-tec.observacao = tt-item.responsavel.

        /* Data Versao - tipo data = 6 */
        IF comp-folh.tipo-result = 6 THEN
            IF comp-folh.descricao = "data da versao":U THEN
                ASSIGN it-carac-tec.dt-result  = DATE(tt-item.data-versao).
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-cria-mensagem :
/*------------------------------------------------------------------------------
  Purpose:     Criar mensagem baseado nas mensagens do Datasul EMS 2.
  Parameters:  INPUT p-codigo    AS INTEGER,
               INPUT p-parametro AS CHARACTER.
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-codigo    AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER p-parametro AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE i-sequencia AS INTEGER     NO-UNDO.

    FIND LAST tt-mensagem NO-ERROR.

    ASSIGN i-sequencia = IF AVAILABLE tt-mensagem THEN tt-mensagem.sequencia + 1 ELSE 1.

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.sequencia = i-sequencia
           tt-mensagem.codigo    = p-codigo.

    /* Tipo da Mensagem (Erro, Advertància, Informaá∆o ou Quest∆o) */
    RUN utp/ut-msgs.p (INPUT "TYPE":U,
                       INPUT p-codigo,
                       INPUT p-parametro).

    ASSIGN tt-mensagem.tipo = RETURN-VALUE.

    /* Mensagem */
    RUN utp/ut-msgs.p (INPUT "MSG":U,
                       INPUT p-codigo,
                       INPUT p-parametro).

    ASSIGN tt-mensagem.mensagem = RETURN-VALUE.

    /* Ajuda da Mensagem */
    RUN utp/ut-msgs.p (INPUT "HELP":U,
                       INPUT p-codigo,
                       INPUT p-parametro).

    ASSIGN tt-mensagem.complemento = RETURN-VALUE.

    RETURN "OK":U.

END PROCEDURE.

