&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : ESSDCV002.P
    Purpose     : Integra‡Æo OutBuyCenter com o ERP TOTVS/EMS.
    Syntax      : <none>
    Description : <none>

    Author(s)   : Heron Borba ( SENSUS Tecnologia )
    Created     : Agosto de 2013
    Notes       : <none>
----------------------------------------------------------------------*/

/****************************  Definitions  ***************************/
/* Preprocessor Definitions ---                                       */
{utp/ut-glob.i}
{esp/es0018.i}

/* Temp-tables Definitions ---                                        */
DEFINE TEMP-TABLE tt-pedido-compra NO-UNDO
    FIELD cod-estabel      LIKE pedido-compr.cod-estabel
    FIELD cod-emitente     LIKE pedido-compr.cod-emitente
    FIELD cod-comprado     LIKE usuar_mestre.cod_usuario
    FIELD cod-transp       LIKE pedido-compr.cod-transp
    FIELD frete            AS   INTEGER 
    FIELD observacao       AS   CHARACTER FORMAT "x(100)":U
    FIELD end-entrega      LIKE pedido-compr.end-entrega
    FIELD cod-cond-pag     LIKE pedido-compr.cod-cond-pag
    FIELD cod-compra       AS   CHARACTER
    FIELD mo-codigo        LIKE moeda.mo-codigo.

DEFINE TEMP-TABLE tt-ordem-compra NO-UNDO
    FIELD cod-compra       AS   CHARACTER
    FIELD numero-ordem     LIKE ordem-compra.numero-ordem
    FIELD cod-item         LIKE ordem-compra.it-codigo
    FIELD qt-solic         LIKE ordem-compra.qt-solic
    FIELD prazo-entreg     AS   DATE
    FIELD preco-unit       LIKE cotacao-item.preco-unit
    FIELD aliquota-icm     LIKE cotacao-item.aliquota-icm
    FIELD aliquota-ipi     LIKE cotacao-item.aliquota-ipi
    FIELD cod-sdcv         AS   CHARACTER
    FIELD requisitante     LIKE usuar_mestre.cod_usuario
    FIELD ct-codigo        LIKE ordem-compra.ct-codigo
    FIELD sc-codigo        LIKE ordem-compra.sc-codigo
    FIELD desc-sdcv        AS   CHARACTER.

DEFINE TEMP-TABLE tt-rateio-ordem NO-UNDO
    FIELD cod-sdcv         AS   CHARACTER
    FIELD ct-codigo        LIKE matriz-rat-ordem.ct-codigo
    FIELD sc-codigo        LIKE matriz-rat-ordem.sc-codigo
    FIELD perc             LIKE matriz-rat-ordem.perc-rateio.

DEFINE TEMP-TABLE tt-retorno-pedido NO-UNDO
    FIELD cod_compra       AS   CHARACTER 
    FIELD num_pedido_compr LIKE pedido-compr.num-pedido
    FIELD num_mensagem     AS   CHARACTER.

DEFINE TEMP-TABLE tt-retorno-ordem NO-UNDO
    FIELD cod_sdcv         AS   CHARACTER
    FIELD numero_ordem     LIKE ordem-compra.numero-ordem.

DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD cod_erro         AS INTEGER
    FIELD desc_erro        AS CHARACTER.

/* Parameters Definitions ---                                         */
DEFINE INPUT PARAMETER TABLE FOR tt-pedido-compra.
DEFINE INPUT PARAMETER TABLE FOR tt-ordem-compra.
DEFINE INPUT PARAMETER TABLE FOR tt-rateio-ordem.

/* TT retorno pedido */
DEFINE OUTPUT PARAMETER TABLE FOR tt-retorno-pedido.
DEFINE OUTPUT PARAMETER TABLE FOR tt-retorno-ordem.
DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.

DEFINE VARIABLE c-usuario AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-senha   AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 7.83
         WIDTH              = 40.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

main-block:
DO  ON ERROR   UNDO main-block, RETURN "NOK":U
    ON END-KEY UNDO main-block, RETURN "NOK":U:

    /*---[ Carregamento do usu rio/senha --------------------------------------*/
    FIND FIRST ponto-programa
        WHERE  ponto-programa.nome-programa = "essdcv002":U
        AND    ponto-programa.ponto         = 1 NO-LOCK NO-ERROR.
    IF  AVAILABLE ponto-programa THEN DO:
        FOR EACH  conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

            IF  conteudo-programa.sequencia = 1 THEN DO:
                assign c-usuario = ENTRY(1,conteudo-programa.conteudo,",")
                       c-senha   = ENTRY(2,conteudo-programa.conteudo,",").
            END. /* IF  conteudo-programa.sequencia = 1 */
        END. /* FOR EACH  conteudo-programa */
    END. /* IF  AVAILABLE ponto-programa */

    /*RUN bi/esbi002.p (INPUT c-usuario, INPUT c-senha).*/
    /*---[ Carregamento do usu rio/senha --------------------------------------*/

    RUN piInicializar IN THIS-PROCEDURE.
END.

RETURN "OK":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-piInicializar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piInicializar Procedure 
PROCEDURE piInicializar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN esp/sdcv/essdcv002api.p (INPUT  TABLE tt-pedido-compra,
                                 INPUT  TABLE tt-ordem-compra,
                                 INPUT  TABLE tt-rateio-ordem,
                                 OUTPUT TABLE tt-retorno-pedido,
                                 OUTPUT TABLE tt-retorno-ordem,
                                 OUTPUT TABLE tt-erro).

    IF  CAN-FIND(FIRST tt-erro) THEN DO:
        RUN esp/es0018p.p (INPUT "spool-unix":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
        
        FIND FIRST tt-prog-ponto NO-ERROR.
        OUTPUT TO VALUE (tt-prog-ponto.conteudo + "/Erros-SDCV.txt") NO-CONVERT APPEND.
        PUT UNFORMATTED 
            "Data"      AT 01
            "Hora"      AT 12
            "Usu rio"   AT 21
            "Erro"      TO 41
            "Descri‡Æo" AT 43 SKIP
            "---------- -------- ------------ -------- ------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP.
            
        FOR EACH tt-erro:
            PUT UNFORMATTED 
                STRING(TODAY, "99/99/9999":U)          AT 01
                STRING(TIME, "HH:MM:SS":U)             AT 12
                c-seg-usuario                          AT 21
                tt-erro.cod_erro  FORMAT '>>>>>>>9':U  TO 41
                tt-erro.desc_erro FORMAT 'x(150)':U    AT 43 SKIP.
        END. /* FOR EACH tt-erro: */
        OUTPUT CLOSE.

        RETURN "NOK":U.
    END. /* IF  CAN-FIND(FIRST tt-erro) THEN DO: */
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

