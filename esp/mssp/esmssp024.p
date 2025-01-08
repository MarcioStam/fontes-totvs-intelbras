/*------------------------------------------------------------------------
    File        : ESMSSP024.P
    Purpose     : Alteraá∆o de Medidas do Item
    Procedure   : alterarMedidasItem
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (SQL Works / Exponencial TI)
    Created     : Julho de 2012
    Notes       : <none>
------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-item NO-UNDO
    FIELD it-codigo    LIKE item.it-codigo    /* C¢digo do Item             */
    FIELD responsavel  LIKE item.responsavel  /* Respons†vel                */
    FIELD peso-liquido LIKE item.peso-liquido /* Peso L°quido               */
    FIELD peso-bruto   LIKE item.peso-bruto   /* Peso Bruto                 */
    FIELD comprim      LIKE item.comprim      /* Comprimento                */
    FIELD largura      LIKE item.largura      /* Largura                    */
    FIELD altura       LIKE item.altura       /* Altura                     */
    FIELD versao       AS DECIMAL             /* Vers∆o                     */
    FIELD data-versao  AS DATE                /* Data de Vers∆o             */
    FIELD cod-acond    AS CHARACTER           /* Acondicionamento           */
    FIELD des-acond    AS CHARACTER           /* Descriá∆o Acondicionamento */
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

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER TABLE FOR tt-item.
DEFINE OUTPUT PARAMETER TABLE FOR tt-mensagem.


/* ***************************  Main Block  *************************** */

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

ASSIGN item.responsavel  = tt-item.responsavel
       item.peso-liquido = tt-item.peso-liquido
       item.peso-bruto   = tt-item.peso-bruto
       item.comprim      = tt-item.comprim
       item.largura      = tt-item.largura
       item.altura       = tt-item.altura.

RUN pi-caracteristica-item.

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

        /* Acondicionamento */
        IF comp-folh.nr-tabela = 4 THEN DO:
            FOR EACH it-res-carac EXCLUSIVE-LOCK
                WHERE it-res-carac.it-codigo = tt-item.it-codigo
                  AND it-res-carac.cd-folha  = comp-folh.cd-folha
                  AND it-res-carac.cd-comp   = comp-folh.cd-comp
                  AND it-res-carac.nr-tabela = comp-folh.nr-tabela:
                DELETE it-res-carac.
            END.

            CREATE it-res-carac.
            ASSIGN it-res-carac.it-codigo   = tt-item.it-codigo
                   it-res-carac.cd-folha    = comp-folh.cd-folha
                   it-res-carac.cd-comp     = comp-folh.cd-comp
                   it-res-carac.nr-tabela   = comp-folh.nr-tabela
                   it-res-carac.sequencia   = INTEGER(tt-item.cod-acond)
                   it-res-carac.tipo-result = comp-folh.tipo-result.

            ASSIGN it-carac-tec.observacao = tt-item.des-acond.
        END.

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

