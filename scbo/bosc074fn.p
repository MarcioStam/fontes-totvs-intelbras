&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOFunction 

{include/i-prgvrs.i BOSC074FN 2.00.00.006 } /*** 010006 ***/

/*:T--------------------------------------------------------------------------
    File       : dbofun.p
    Purpose    : O DBO Function (Datasul Business Objects) ‚ um programa 
                 PROGRESS que cont‚m a l¢gica de neg¢cio.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOSC074FN
&GLOBAL-DEFINE DBOVersion 1.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName wm-etiqueta
&GLOBAL-DEFINE TableLabel

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{scbo/bosc074.i RowObject}

DEFINE TEMP-TABLE tt-wm-etiqueta-ordem NO-UNDO
    FIELD id-etiqueta  AS DECIMAL FORMAT ">>>>>>>>>>>>>9"   LABEL "Etiqueta"
    FIELD qtd-item     AS DECIMAL FORMAT ">>>,>>>,>>9.9999" LABEL "Quantidade"
    FIELD dt-geracao   AS DATE    FORMAT "99/99/9999"       LABEL "Data"
    FIELD cod-estabel  AS CHAR    FORMAT "X(3)"             LABEL "Estab"
    FIELD cod-local    AS CHAR    FORMAT "X(3)"             LABEL "Local"
    FIELD c-armazenado AS CHAR    FORMAT "X(5)"             LABEL "Armazenado"
    FIELD c-endereco   AS CHAR    FORMAT "X(30)"            LABEL "Endere‡o"
    INDEX codigo IS PRIMARY id-etiqueta.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOFunction
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOFunction
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOFunction ASSIGN
         HEIGHT             = 23.46
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOFunction 
/* ************************* Included-Libraries *********************** */

{method/dbofun.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOFunction 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getEtiquetaOrdem DBOFunction 
PROCEDURE getEtiquetaOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-nr-ordem AS INT NO-UNDO.
    DEF INPUT PARAM pIdEtiquetaIni    AS DECIMAL    NO-UNDO.
    DEF INPUT PARAM pIdEtiquetaFim    AS DECIMAL    NO-UNDO.
    DEF INPUT PARAM pDtEtiquetaIni    AS DATE       NO-UNDO.
    DEF INPUT PARAM pDtEtiquetaFim    AS DATE       NO-UNDO.
    DEF INPUT PARAM pSituacaoEtiqueta AS INTEGER    NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-wm-etiqueta-ordem.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE hProxy AS HANDLE      NO-UNDO.
    DEFINE VARIABLE c-num-docto LIKE wm-docto.num-docto NO-UNDO.
    DEFINE VARIABLE c-aux-sim AS CHARACTER FORMAT "x(10)" NO-UNDO.
    DEFINE VARIABLE c-aux-nao AS CHARACTER FORMAT "x(10)" NO-UNDO.
    DEFINE VARIABLE c-aux-esq AS CHARACTER FORMAT "x(10)" NO-UNDO.
    DEFINE VARIABLE c-aux-dir AS CHARACTER FORMAT "x(10)" NO-UNDO.

    DEFINE VARIABLE c-aux-trad-aux   AS CHARACTER FORMAT "x(100)" NO-UNDO.
    DEFINE VARIABLE c-aux-trad-aux-1 AS CHARACTER FORMAT "x(100)" NO-UNDO.

    DEFINE VARIABLE c-cod-estabel AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-cod-depos   AS CHARACTER   NO-UNDO.

    FOR EACH RowErrors:
        DELETE RowErrors.
    END.

    FIND FIRST wm-param NO-LOCK NO-ERROR.
    IF NOT wm-param.log-rel-movto-etiqueta THEN DO:

        {utp/ut-liter.i "estornar a ordem de produ‡Æo"}
        ASSIGN c-aux-trad-aux = TRIM(RETURN-VALUE).
        {utp/ut-liter.i "relacionamento das etiquetas. Verificar parƒmetros do WMS"}
        ASSIGN c-aux-trad-aux-1 = TRIM(RETURN-VALUE).

        {method/svc/errors/inserr.i &ErrorNumber="30963"
                                    &ErrorType="EMS"
                                    &ErrorParameters="trim(c-aux-trad-aux) + '~~~~' + trim(c-aux-trad-aux-1)"}
        RETURN "NOK":U.
    END.

    {utp/ut-liter.i Sim}
    ASSIGN c-aux-sim = TRIM(RETURN-VALUE).
    {utp/ut-liter.i NÆo}
    ASSIGN c-aux-nao = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Esq}
    ASSIGN c-aux-esq = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Dir}
    ASSIGN c-aux-dir = TRIM(RETURN-VALUE).

    &IF INTEGER(ENTRY(1,proversion,".")) >= 9 &THEN
        EMPTY TEMP-TABLE tt-wm-etiqueta-ordem.
    &ELSE
        FOR EACH tt-wm-etiqueta-ordem:
            DELETE tt-wm-etiqueta-ordem.
        END.
    &ENDIF

    IF  NOT VALID-HANDLE(hProxy) THEN
        RUN wmp/wmprx271.p PERSISTENT SET hProxy.
    IF VALID-HANDLE(hProxy) THEN DO:
        RUN proxyOrdProd IN hProxy (INPUT  p-nr-ordem,
                                    OUTPUT c-cod-estabel,
                                    OUTPUT c-cod-depos).
        RUN destroy IN hProxy.
        DELETE PROCEDURE hProxy NO-ERROR.
        ASSIGN hProxy = ?.
    END.

    FIND FIRST wm-local NO-LOCK
         WHERE wm-local.cod-estabel  = c-cod-estabel
           AND wm-local.cod-deposito = c-cod-depos   NO-ERROR.
        
    IF NOT AVAIL wm-local THEN
        FOR FIRST wm-local-deposito FIELDS(cod-estabel cod-deposito cod-local)
            WHERE wm-local-deposito.cod-estabel  = c-cod-estabel
              AND wm-local-deposito.cod-deposito = c-cod-depos:
        IF AVAIL wm-local-deposito THEN
            FIND FIRST wm-local NO-LOCK 
                 WHERE wm-local.cod-estabel  = wm-local-deposito.cod-estabel
                   AND wm-local.cod-local    = wm-local-deposito.cod-local NO-ERROR.
        END.

    IF NOT AVAIL wm-local THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-ordem-de-producao AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Ordem_de_Produ‡Æo" *}
        ASSIGN c-lbl-liter-ordem-de-producao = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
            &ErrorNumber="47"
            &ErrorType="EMS"
            &ErrorParameters="c-lbl-liter-ordem-de-producao"}    
        RETURN "NOK":U.
    END.

    FOR EACH wm-docto NO-LOCK
         WHERE wm-docto.cod-estabel      = wm-local.cod-estabel
           AND wm-docto.cod-local        = wm-local.cod-local
           AND wm-docto.num-docto        = STRING(p-nr-ordem)
           AND wm-docto.ind-tipo-trans   = 1
           AND wm-docto.ind-origem-docto = 13
           AND wm-docto.id-carga         > 0:

        FOR EACH wm-etiqueta NO-LOCK
           WHERE wm-etiqueta.id-carga = wm-docto.id-carga
             AND wm-etiqueta.id-etiqueta >= pIdEtiquetaIni
             AND wm-etiqueta.id-etiqueta <= pIdEtiquetaFim
             AND wm-etiqueta.dt-geracao >= pDtEtiquetaIni
             AND wm-etiqueta.dt-geracao <= pDtEtiquetaFim:

            /*NÆo considera as etiquetas estornadas.*/
            IF wm-etiqueta.ind-leitura-etiqueta = 4 THEN
                NEXT.

            CREATE tt-wm-etiqueta-ordem.
            ASSIGN tt-wm-etiqueta-ordem.id-etiqueta  = wm-etiqueta.id-etiqueta
                   tt-wm-etiqueta-ordem.qtd-item     = wm-etiqueta.qtd-item - wm-etiqueta.qtd-item-retirado
                   tt-wm-etiqueta-ordem.dt-geracao   = wm-etiqueta.dt-geracao
                   tt-wm-etiqueta-ordem.cod-estabel  = wm-docto.cod-estabel
                   tt-wm-etiqueta-ordem.cod-local    = wm-docto.cod-local.

            FIND FIRST wm-movto-etiqueta NO-LOCK
                 WHERE wm-movto-etiqueta.cod-estabel = wm-docto.cod-estabel
                   AND wm-movto-etiqueta.cod-local   = wm-docto.cod-local  
                   AND wm-movto-etiqueta.id-etiqueta = wm-etiqueta.id-etiqueta NO-ERROR.

            IF AVAIL wm-movto-etiqueta THEN DO:
                FIND FIRST wm-box-movto NO-LOCK
                     WHERE wm-box-movto.cod-estabel = wm-docto.cod-estabel
                       AND wm-box-movto.cod-local   = wm-docto.cod-local  
                       AND wm-box-movto.id-movto    = wm-movto-etiqueta.id-movto NO-ERROR.
                IF AVAIL wm-box-movto THEN DO:
                    FIND FIRST wm-box NO-LOCK
                         WHERE wm-box.cod-estabel = wm-box-movto.cod-estabel
                           AND wm-box.cod-local   = wm-box-movto.cod-local
                           AND wm-box.id-box      = wm-box-movto.id-box NO-ERROR.
                    IF AVAIL wm-box THEN
                        ASSIGN tt-wm-etiqueta-ordem.c-armazenado = IF wm-box-movto.ind-status-movto = 1 THEN
                                                               c-aux-nao
                                                           ELSE
                                                               c-aux-sim
                               tt-wm-etiqueta-ordem.c-endereco = wm-box.cod-bloco  + " / " +
                                                                 wm-box.cod-rua    + " / " +
                                                                 wm-box.cod-nivel  + " / " +
                                                                 wm-box.cod-coluna + " / " +
                                                                 IF wm-box.ind-posicao-box = 1 THEN
                                                                     c-aux-esq
                                                                 ELSE
                                                                     c-aux-dir.
                END.
            END.
        END.
    END.

    FOR EACH tt-wm-etiqueta-ordem:
        IF pSituacaoEtiqueta = 1 THEN DO: /* Armazenada */
            IF tt-wm-etiqueta-ordem.c-armazenado = c-aux-nao THEN
                DELETE tt-wm-etiqueta-ordem.
        END.
        ELSE IF pSituacaoEtiqueta = 2 THEN /* NÆo armazenadas */
            IF tt-wm-etiqueta-ordem.c-armazenado = c-aux-sim THEN 
                DELETE tt-wm-etiqueta-ordem.
    END.


    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

