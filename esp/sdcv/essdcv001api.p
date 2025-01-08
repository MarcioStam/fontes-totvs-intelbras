&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : ESSDCV001API.P
    Purpose     : Integra‡Æo das Triggers do ERP TOTVS/Datasul EMS 2 com o
                  OutBuyCenter.
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI)
    Created     : Julho de 2013
    Notes       : <none>
----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Preprocessor Definitions ---                                         */

/* Separador de campos nos registros exportados */
&GLOBAL-DEFINE SEPARADOR    #SEP#

/* Include Definitions ---                                              */

/* Global Variable Definitions ---                                      */

/* Defini‡Æo da temp-table "ttRawTempTable" */
{esp/sdcv/essdcv001api.i}

/* Defini‡Æo da temp-table "RowErrors" */
{method/dbotterr.i}

/* Defini‡Æo da temp-table "tt-prog-ponto" */
{esp/es0018.i}

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-emitente          NO-UNDO LIKE emitente.
DEFINE TEMP-TABLE tt-classif-fisc      NO-UNDO LIKE classif-fisc.
DEFINE TEMP-TABLE tt-cond-pagto        NO-UNDO LIKE cond-pagto.
DEFINE TEMP-TABLE tt-cotacao           NO-UNDO LIKE cotacao.
DEFINE TEMP-TABLE tt-mensagem          NO-UNDO LIKE mensagem.
DEFINE TEMP-TABLE tt-ccusto_unid_negoc NO-UNDO LIKE emscad.ccusto_unid_negoc.
DEFINE TEMP-TABLE tt-cta_ctbl          NO-UNDO LIKE cta_ctbl.
DEFINE TEMP-TABLE tt-dia_calend_glob   NO-UNDO LIKE dia_calend_glob.
DEFINE TEMP-TABLE tt-clas_dia_calend   NO-UNDO LIKE clas_dia_calend.

DEFINE TEMP-TABLE tt-conta-auxiliar NO-UNDO
    FIELD marca              AS CHAR FORMAT "x(01)"
    FIELD cod_plano_cta_ctbl LIKE plano_cta_ctbl.cod_plano_cta_ctbl
    FIELD cod_cta_ctbl       LIKE cta_ctbl.cod_cta_ctbl
    FIELD des_cta_ctbl       LIKE cta_ctbl.des_tit_ctbl.

DEFINE TEMP-TABLE tt-ccusto-auxiliar NO-UNDO
    FIELD cod_plano_ccusto   LIKE plano_ccusto.cod_plano_ccusto 
    FIELD cod_ccusto         LIKE emscad.ccusto_unid_negoc.cod_ccusto
    FIELD des_ccusto         LIKE emscad.ccusto.des_tit_ctbl
    FIELD cod_unid_negoc     LIKE emscad.ccusto_unid_negoc.cod_unid_negoc.

DEFINE TEMP-TABLE tt-exp-ccusto NO-UNDO
    FIELD cod_plano_ccusto LIKE plano_ccusto.cod_plano_ccusto 
    FIELD cod_unid_negoc   LIKE cc_uni_estab.cod_unid_negoc
    FIELD cod_ccusto       LIKE emscad.ccusto.cod_ccusto
    FIELD des_ccusto       LIKE emscad.ccusto.des_tit_ctbl
    FIELD cod_estab        LIKE cc_uni_estab.cod_estab.

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER pTabela AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER pAcao   AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR ttRawTabela.
DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

/* Variable Definitions ---                                             */
{upc/btb910za-upc.i}
{esp/sdcv/essdcv001api.i2}

/* Buffer Definitions ---                                               */

DEFINE BUFFER b-cont-emit FOR cont-emit.

{esp/sdcv/essdcv001api.i3} /* criar a tabela int-integrado-obc */

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
         HEIGHT             = 16.46
         WIDTH              = 33.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */
{esp/sdcv/essdcv001api.i1}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* Parƒmetros para conexÆo com o Web Service */

/* Exemplo: http://wsa.intelbras.com.br:8080/wsa1/wsa1/wsdl?targetURI=urn:sharepoint:intelbras.com.br */
EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p (INPUT "ambiente":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

FIND FIRST tt-prog-ponto NO-ERROR.

IF AVAILABLE tt-prog-ponto               AND
   tt-prog-ponto.conteudo = "PRODUCAO":U THEN
    ASSIGN vWSDL = "http://10.1.1.108:8080/OBC/Integracao?wsdl":U.
ELSE
    ASSIGN vWSDL = "http://10.1.1.108:8080/OBChomo/Integracao?wsdl":U.

/* Exemplo: integracaoSPObj */
ASSIGN vPORTTYPE = "Integracao":U.

/* Exemplo: integracaoItem */
ASSIGN vOPERATION = "add":U.

main-block:
DO ON ERROR   UNDO main-block, RETURN "NOK":U
   ON END-KEY UNDO main-block, RETURN "NOK":U:
    RUN piConstroiRegistro IN THIS-PROCEDURE.
    RUN piIntegracao       IN THIS-PROCEDURE.
END.

RETURN "OK":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-piCentroCustoByCC) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCentroCustoByCC Procedure 
PROCEDURE piCentroCustoByCC :
/*------------------------------------------------------------------------------
  Purpose:     Gerar registros da tabela "ccusto" (uni018).
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-exp-ccusto.

    FOR EACH ttRawTabela:
        CREATE tt-exp-ccusto.
        RAW-TRANSFER ttRawTabela.rawTabela TO tt-exp-ccusto.
    END.

    RUN piLimparTtRegistro IN THIS-PROCEDURE.

/*     OUTPUT TO VALUE("c:\temp\Registro-ccusto.txt") NO-CONVERT.  */

    FOR EACH  tt-exp-ccusto,
        FIRST emscad.ccusto NO-LOCK
        WHERE emscad.ccusto.cod_plano_ccusto = tt-exp-ccusto.cod_plano_ccusto
        AND   emscad.ccusto.cod_ccusto       = tt-exp-ccusto.cod_ccusto
        BY  tt-exp-ccusto.cod_ccusto:

        ASSIGN cRegistro = TRIM(tt-exp-ccusto.cod_unid_negoc) + TRIM(tt-exp-ccusto.cod_ccusto) + "." + TRIM(tt-exp-ccusto.cod_estab) + "{&SEPARADOR}" +
                           TRIM(tt-exp-ccusto.cod_unid_negoc) + TRIM(tt-exp-ccusto.cod_ccusto) + "." + TRIM(tt-exp-ccusto.cod_estab) + "{&SEPARADOR}" +
                           TRIM(tt-exp-ccusto.des_ccusto) + "{&SEPARADOR}".

        IF  gc-ccusto = "INATCC":U 
        THEN ASSIGN cRegistro = cRegistro + TRIM("I") + "{&SEPARADOR}".
        ELSE DO:
            IF pAcao = "E" THEN ASSIGN cRegistro = cRegistro + TRIM("I") + "{&SEPARADOR}"
                                       /*pAcao     = "A"*/ .
                           ELSE DO:
                               IF  ccusto.dat_inic_valid <= TODAY 
                               AND ccusto.dat_fim_valid  >= TODAY THEN ASSIGN cRegistro = cRegistro + TRIM("A") + "{&SEPARADOR}".
                                                                  ELSE ASSIGN cRegistro = cRegistro + TRIM("I") + "{&SEPARADOR}". 
                           END. /* ELSE DO: */
        END.
        
        
        ASSIGN cRegistro = cRegistro +
                           TRIM("U") + "{&SEPARADOR}" + /* Tipo */
                           TRIM("")  + "{&SEPARADOR}" + /* Grupo Filial - Enviar vazio */
                           TRIM(tt-exp-ccusto.cod_estab).

/*         PUT UNFORMATTED cRegistro SKIP.  */

        RUN piCriarTtRegistro IN THIS-PROCEDURE (INPUT "CENTRO_CUSTO":U,
                                                 INPUT TRIM(tt-exp-ccusto.cod_ccusto),
                                                 INPUT cRegistro).

    END. /* FOR EACH tt-exp-ccusto */

/*     OUTPUT CLOSE.  */

    EMPTY TEMP-TABLE tt-exp-ccusto.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piCondPagto) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCondPagto Procedure 
PROCEDURE piCondPagto :
/*------------------------------------------------------------------------------
  Purpose:     Gerar registros da tabela "cond-pagto" (ad039).
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iContParc     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cCondicao     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cPercentual   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE deMediaPrazos AS DECIMAL     NO-UNDO.

    EMPTY TEMP-TABLE tt-cond-pagto.

    FOR EACH ttRawTabela:
        CREATE tt-cond-pagto.
        RAW-TRANSFER ttRawTabela.rawTabela TO tt-cond-pagto.
    END.

    RUN piLimparTtRegistro IN THIS-PROCEDURE.

    FOR EACH tt-cond-pagto:
        ASSIGN cCondicao     = "":U
               cPercentual   = "":U
               deMediaPrazos = 0.

        DO iContParc = 1 TO tt-cond-pagto.num-parcelas:
            ASSIGN cCondicao     = cCondicao     + (IF cCondicao   = "":U THEN "":U ELSE ",":U) + TRIM(STRING(tt-cond-pagto.prazos[iContParc], ">>9":U))
                   cPercentual   = cPercentual   + (IF cPercentual = "":U THEN "":U ELSE ",":U) + REPLACE(TRIM(STRING(tt-cond-pagto.per-pg-dup[iContParc], ">>9.99":U)), SESSION:NUMERIC-DECIMAL-POINT, ".":U)
                   deMediaPrazos = deMediaPrazos + tt-cond-pagto.prazos[iContParc].
        END.

        ASSIGN deMediaPrazos = deMediaPrazos / tt-cond-pagto.num-parcelas.

        ASSIGN cRegistro = TRIM(STRING(tt-cond-pagto.cod-cond-pag, ">>>9":U)) + "{&SEPARADOR}":U +
                           TRIM(tt-cond-pagto.descricao)                      + "{&SEPARADOR}":U +
                           TRIM(cCondicao)                                    + "{&SEPARADOR}":U +
                           TRIM(cPercentual)                                  + "{&SEPARADOR}":U.

        IF pAcao = "E":U THEN
            ASSIGN cRegistro = cRegistro + TRIM("I":U) + "{&SEPARADOR}":U
                   pAcao     = "A":U.
        ELSE DO:
            FIND FIRST int-cond-pagto NO-LOCK
                WHERE  int-cond-pagto.cod-cond-pag = tt-cond-pagto.cod-cond-pag NO-ERROR.

            IF  AVAILABLE int-cond-pagto AND NOT int-cond-pagto.log-sdcv THEN /* se nÆo for para SDCV segue como inativo para o OutbuyCenter */
                ASSIGN cRegistro = cRegistro + TRIM("I":U) + "{&SEPARADOR}":U.
            ELSE
                ASSIGN cRegistro = cRegistro + TRIM("A":U) + "{&SEPARADOR}":U.
        END.

        ASSIGN cRegistro = cRegistro + REPLACE(TRIM(STRING(deMediaPrazos, ">>9.99":U)), SESSION:NUMERIC-DECIMAL-POINT, ".":U).

        RUN piCriarTtRegistro IN THIS-PROCEDURE (INPUT "COND_PGTO":U,
                                                 INPUT TRIM(STRING(tt-cond-pagto.cod-cond-pag, ">>>9":U)),
                                                 INPUT cRegistro).
    END.

    EMPTY TEMP-TABLE tt-cond-pagto.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piConstroiRegistro) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piConstroiRegistro Procedure 
PROCEDURE piConstroiRegistro :
/*------------------------------------------------------------------------------
  Purpose:     Chama, baseado na tabela, as procedures que constroem os registros
               para exporta‡Æo.
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    
    CASE pTabela:
        WHEN "classif-fisc":U                           THEN RUN piNCM                  IN THIS-PROCEDURE.
        WHEN "emitente":U                               THEN RUN piEmitente             IN THIS-PROCEDURE.
        WHEN "cond-pagto":U                             THEN RUN piCondPagto            IN THIS-PROCEDURE.
        WHEN "cotacao":U                                THEN RUN piCotacao              IN THIS-PROCEDURE.
        WHEN "mensagem":U                               THEN RUN piMensagem             IN THIS-PROCEDURE.
        WHEN "centro-custo" OR WHEN "ccusto_unid_negoc" THEN RUN piCentroCustoByCC      IN THIS-PROCEDURE.
        WHEN "conta-contab" OR WHEN "cta_ctbl"          THEN RUN piContaContabil        IN THIS-PROCEDURE.
        WHEN "plano-conta-conta-contabil"               THEN RUN piPlanoContas          IN THIS-PROCEDURE.
        WHEN "dia_calend_glob"                          THEN RUN piFeriadoByCalendario  IN THIS-PROCEDURE.
        WHEN "clas_dia_calend"                          THEN RUN piFeriadoByClasse      IN THIS-PROCEDURE.
        WHEN "inativa-conta"                            THEN RUN piInativaCtaCtbl       IN THIS-PROCEDURE.
        OTHERWISE DO:
            RUN piCriarRowErrors IN THIS-PROCEDURE (INPUT 17006, INPUT "Tabela nÆo encontrada!":U).
            RETURN ERROR.
        END. /* OTHERWISE DO: */
    END CASE.

    IF VALID-HANDLE(h_api_cta_ctbl) THEN DELETE PROCEDURE h_api_cta_ctbl.
    IF VALID-HANDLE(h_api_ccusto)   THEN DELETE PROCEDURE h_api_ccusto.

    IF RETURN-VALUE = "NOK":U THEN RETURN ERROR.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piContaContabil) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piContaContabil Procedure 
PROCEDURE piContaContabil :
/*------------------------------------------------------------------------------
  Purpose:     Gerar registros da tabela "cta_ctbl" (uni044).
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-conta-auxiliar.
 
    /*OUTPUT TO VALUE("c:\temp\Registro-tt-conta-auxiliar-ESSDCV001api.txt") NO-CONVERT.*/
    FOR EACH ttRawTabela:
        CREATE tt-conta-auxiliar.
        RAW-TRANSFER ttRawTabela.rawTabela TO tt-conta-auxiliar.

        /*PUT UNFORMATTED tt-conta-auxiliar.marca " - "
                        tt-conta-auxiliar.cod_plano_cta_ctbl " - "
                        tt-conta-auxiliar.cod_cta_ctbl " - "
                        tt-conta-auxiliar.des_cta_ctbl SKIP.*/
    END.
    /*OUTPUT CLOSE.*/

    RUN piLimparTtRegistro IN THIS-PROCEDURE.


    /*OUTPUT TO VALUE("c:\temp\Registro-Conta-ESSDCV001api.txt") NO-CONVERT.*/

    FOR EACH  tt-conta-auxiliar 
        WHERE tt-conta-auxiliar.marca = "*",
        FIRST cta_ctbl NO-LOCK
        WHERE cta_ctbl.cod_plano_cta_ctbl = tt-conta-auxiliar.cod_plano_cta_ctbl
        AND   cta_ctbl.cod_cta_ctbl       = tt-conta-auxiliar.cod_cta_ctbl:
        ASSIGN cRegistro = TRIM(STRING(tt-conta-auxiliar.cod_cta_ctbl, "9.9.9.99.999")) + "{&SEPARADOR}" +
                           TRIM(tt-conta-auxiliar.cod_cta_ctbl)                         + "{&SEPARADOR}" +
                           TRIM(tt-conta-auxiliar.des_cta_ctbl)                         + "{&SEPARADOR}".

        IF cta_ctbl.ind_espec_cta_ctbl = "Anal¡tica" 
        THEN ASSIGN cRegistro = cRegistro + TRIM("C") + "{&SEPARADOR}". /* Cont bil */
        ELSE IF cta_ctbl.ind_espec_cta_ctbl = "Sint‚tica" 
             THEN ASSIGN cRegistro = cRegistro + TRIM("T") + "{&SEPARADOR}". /* Totalizadora */
             ELSE ASSIGN cRegistro = cRegistro + "{&SEPARADOR}".

        ASSIGN cRegistro = cRegistro + TRIM("N") + "{&SEPARADOR}". /* Valor definido por 'default' igual … 'N' */

        IF pAcao = "E" THEN ASSIGN cRegistro = cRegistro + TRIM("I")
                                   /*pAcao     = "A"*/ . 
                       ELSE ASSIGN cRegistro = cRegistro + TRIM("A").


        /*PUT UNFORMATTED cRegistro SKIP.*/

        RUN piCriarTtRegistro IN THIS-PROCEDURE (INPUT "CONTA_CONTABIL":U,
                                                 INPUT TRIM(tt-conta-auxiliar.cod_cta_ctbl),
                                                 INPUT cRegistro).

    END. /* FOR EACH  tt-conta-auxiliar */
    /*OUTPUT CLOSE.*/

    EMPTY TEMP-TABLE tt-conta-auxiliar.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piCotacao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCotacao Procedure 
PROCEDURE piCotacao :
/*------------------------------------------------------------------------------
  Purpose:     Gerar registros da tabela "cotacao" (un003).
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE VARIABLE daAux       AS DATE        NO-UNDO.
    DEFINE VARIABLE iNumDiasMes AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iContDias   AS INTEGER     NO-UNDO.

    DEFINE VARIABLE d-data-aux AS DATE FORMAT "99/99/9999":U NO-UNDO.

    EMPTY TEMP-TABLE tt-cotacao.
    ASSIGN d-data-aux = ?.

    FOR EACH ttRawTabela:
        CREATE tt-cotacao.
        RAW-TRANSFER ttRawTabela.rawTabela TO tt-cotacao.
    END.

    RUN piLimparTtRegistro IN THIS-PROCEDURE.
    
    /*OUTPUT TO VALUE("\\totvs\spool\integracao-cotacao.txt":U) APPEND CONVERT TARGET "iso8859-1":U. */
    FOR FIRST tt-cotacao NO-LOCK:

        DO  iContDias = 1 TO 31: 

            ASSIGN d-data-aux = DATE(string(DATE(int(SUBSTRING(tt-cotacao.ano-periodo,5,2)),iContDias,int(SUBSTRING(tt-cotacao.ano-periodo,1,4))))) NO-ERROR.
            IF  ERROR-STATUS:ERROR THEN NEXT.

            ASSIGN cRegistro = TRIM(STRING(tt-cotacao.mo-codigo, ">9":U)) + "{&SEPARADOR}":U +
                               string(d-data-aux) + "{&SEPARADOR}":U +
                               TRIM(REPLACE(STRING(tt-cotacao.cotacao[iContDias], ">>>>>9.99999999":U), SESSION:NUMERIC-DECIMAL-POINT, ".":U)).

            RUN piCriarTtRegistro IN THIS-PROCEDURE (INPUT "COTACAO_MOEDA":U,
                                                     INPUT TRIM(STRING(tt-cotacao.mo-codigo, ">9":U)),
                                                     INPUT cRegistro).
         END.  /*DO iContDias = 1 TO 31: */

    END. /* FOR EACH tt-cotacao NO-LOCK: */
    /*OUTPUT CLOSE.*/
    
    EMPTY TEMP-TABLE tt-cotacao.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piEmitente) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEmitente Procedure 
PROCEDURE piEmitente :
/*------------------------------------------------------------------------------
  Purpose:     Gerar registros da tabela "emitente" (ad098).
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-cod-transp LIKE transporte.cod-transp NO-UNDO.
    
    EMPTY TEMP-TABLE tt-emitente.

    FOR EACH ttRawTabela:
        CREATE tt-emitente.
        RAW-TRANSFER ttRawTabela.rawTabela TO tt-emitente.
    END.

    RUN piLimparTtRegistro IN THIS-PROCEDURE.

    FOR EACH tt-emitente
        WHERE tt-emitente.identific = 2
           OR tt-emitente.identific = 3:
        ASSIGN cRegistro = TRIM(STRING(tt-emitente.cod-emitente, ">>>>>>>>9":U)) + "{&SEPARADOR}":U +
                           TRIM(tt-emitente.nome-emit)                           + "{&SEPARADOR}":U +
                           TRIM(tt-emitente.endereco)                            + "{&SEPARADOR}":U +
                           TRIM(tt-emitente.bairro)                              + "{&SEPARADOR}":U +
                           TRIM(tt-emitente.cep)                                 + "{&SEPARADOR}":U +
                           TRIM(tt-emitente.cidade)                              + "{&SEPARADOR}":U +
                           TRIM(UPPER(tt-emitente.estado))                       + "{&SEPARADOR}":U +
                           TRIM(tt-emitente.cgc)                                 + "{&SEPARADOR}":U +
                           TRIM(tt-emitente.ins-estadual)                        + "{&SEPARADOR}":U +
                           TRIM(tt-emitente.ins-municipal)                       + "{&SEPARADOR}":U.

        /* Contato, Telefone 1, Fax e E-mail - In¡cio */
        FIND FIRST cont-emit
            WHERE  cont-emit.cod-emitente = tt-emitente.cod-emitente NO-LOCK NO-ERROR.

        IF AVAILABLE cont-emit 
        THEN ASSIGN cRegistro = cRegistro                                                                           +
                                TRIM(string(substring(cont-emit.nome,1,50),"X(50)"))      + "{&SEPARADOR}":U +
                                TRIM(cont-emit.telefone + " ":U + cont-emit.ramal) + "{&SEPARADOR}":U +
                                TRIM(cont-emit.telefax)                                   + "{&SEPARADOR}":U +
                                TRIM(cont-emit.e-mail)                                    + "{&SEPARADOR}":U.
        ELSE ASSIGN cRegistro = cRegistro        +
                                "{&SEPARADOR}":U +
                                "{&SEPARADOR}":U +
                                "{&SEPARADOR}":U +
                                "{&SEPARADOR}":U.
        /* Contato, Telefone 1, Fax e E-mail - Final */

        ASSIGN cRegistro = cRegistro + "{&SEPARADOR}":U. /* Home-Page - EM BRANCO */

        ASSIGN cRegistro = cRegistro                                                                     +
                           TRIM(STRING(tt-emitente.data-implant, "99/99/9999":U)) + "{&SEPARADOR}":U +
                           TRIM(tt-emitente.nome-emit)                            + "{&SEPARADOR}":U.
         
        ASSIGN cRegistro = cRegistro + "{&SEPARADOR}":U + "{&SEPARADOR}":U. /* DDD dos telefones 1 e 2 j  estÆo nos campos Telefone 1 e Telefone 2 */

        /* Telefone 2 - In¡cio */
        IF AVAILABLE cont-emit THEN DO:
            FIND FIRST b-cont-emit
                WHERE  b-cont-emit.cod-emitente = cont-emit.cod-emitente
                  AND  b-cont-emit.sequencia    > cont-emit.sequencia NO-LOCK NO-ERROR.

            IF AVAILABLE b-cont-emit THEN
                ASSIGN cRegistro = cRegistro + TRIM(b-cont-emit.telefone + " ":U + b-cont-emit.ramal) + "{&SEPARADOR}":U.
            ELSE
                ASSIGN cRegistro = cRegistro + "{&SEPARADOR}":U.
        END.
        ELSE
            ASSIGN cRegistro = cRegistro + "{&SEPARADOR}":U.
        /* Telefone 2 - Final */

        ASSIGN cRegistro = cRegistro + TRIM(tt-emitente.pais) + "{&SEPARADOR}":U.

        IF pAcao = "E":U THEN
            ASSIGN cRegistro = cRegistro + TRIM("I":U) + "{&SEPARADOR}":U
                   pAcao     = "A":U.
        ELSE DO:
            FIND FIRST dist-emitente
                WHERE dist-emitente.cod-emitente = tt-emitente.cod-emitente NO-LOCK NO-ERROR.

            IF AVAILABLE dist-emitente AND dist-emitente.idi-sit-fornec <> 1 THEN
                ASSIGN cRegistro = cRegistro + TRIM("I":U) + "{&SEPARADOR}":U.
            ELSE
                ASSIGN cRegistro = cRegistro + TRIM("A":U) + "{&SEPARADOR}":U.
        END.

        /* Fornecedor ‚ transportadora? - In¡cio */
        FIND FIRST transporte
            WHERE transporte.cgc = tt-emitente.cgc NO-LOCK NO-ERROR.

        IF  AVAILABLE transporte 
        THEN ASSIGN cRegistro    = cRegistro + TRIM("S":U) + "{&SEPARADOR}":U
                    i-cod-transp = transporte.cod-transp.
        ELSE ASSIGN cRegistro    = cRegistro + TRIM("N":U) + "{&SEPARADOR}":U
                    i-cod-transp = tt-emitente.cod-transp. 
        /* Fornecedor ‚ transportadora? - In¡cio */

        /* E-mail 2 - In¡cio */
        IF AVAILABLE cont-emit THEN DO:
            FIND FIRST b-cont-emit
                WHERE b-cont-emit.cod-emitente = cont-emit.cod-emitente
                  AND b-cont-emit.sequencia    > cont-emit.sequencia NO-LOCK NO-ERROR.

            IF AVAILABLE b-cont-emit THEN
                ASSIGN cRegistro = cRegistro + TRIM(b-cont-emit.e-mail) + "{&SEPARADOR}":U.
            ELSE
                ASSIGN cRegistro = cRegistro + "{&SEPARADOR}":U.
        END.
        ELSE
            ASSIGN cRegistro = cRegistro + "{&SEPARADOR}":U.
        /* E-mail 2 - Final */

        /* Idioma - In¡cio */
        IF tt-emitente.pais = "Brasil":U THEN
            ASSIGN cRegistro = cRegistro + TRIM("PT":U) + "{&SEPARADOR}":U.
        ELSE
            ASSIGN cRegistro = cRegistro + TRIM("EN":U) + "{&SEPARADOR}":U.
        /* Idioma - Final */

        ASSIGN cRegistro = cRegistro                                        + "{&SEPARADOR}":U + /* Observa‡Æo - EM BRANCO */
                           TRIM(STRING(tt-emitente.cod-cond-pag, ">>>9":U)) + "{&SEPARADOR}":U.
        
        FIND FIRST dist-emitente NO-LOCK
            WHERE  dist-emitente.cod-emitente = tt-emitente.cod-emitente NO-ERROR.
        IF  AVAIL  dist-emitente
        THEN ASSIGN cRegistro = cRegistro + TRIM(STRING(dist-emitente.mo-fatur)) + "{&SEPARADOR}":U.
        ELSE ASSIGN cRegistro = cRegistro + TRIM("0":U) + "{&SEPARADOR}":U.
            
        ASSIGN cRegistro = cRegistro + TRIM(STRING(i-cod-transp)).

        RUN piCriarTtRegistro IN THIS-PROCEDURE (INPUT "FORNECEDOR":U,
                                                 INPUT TRIM(STRING(tt-emitente.cod-emitente, ">>>>>>>>9":U)),
                                                 INPUT cRegistro).
    END.

    EMPTY TEMP-TABLE tt-emitente.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piFeriadoByCalendario) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piFeriadoByCalendario Procedure 
PROCEDURE piFeriadoByCalendario :
/*------------------------------------------------------------------------------
  Purpose:     Gerar registros da tabela "dia_calend_glob" (uni177).
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-contaRegistros AS INTEGER NO-UNDO.

    ASSIGN i-contaRegistros = 0.

    EMPTY TEMP-TABLE tt-dia_calend_glob.

    FOR EACH ttRawTabela:
        CREATE tt-dia_calend_glob.
        RAW-TRANSFER ttRawTabela.rawTabela TO tt-dia_calend_glob.
    END.

    RUN piLimparTtRegistro IN THIS-PROCEDURE.

    FOR EACH tt-dia_calend_glob:
        FIND FIRST clas_dia_calend
            WHERE clas_dia_calend.cod_clas_dia_calend = tt-dia_calend_glob.cod_clas_dia_calend NO-LOCK NO-ERROR.

        IF  NOT AVAILABLE clas_dia_calend                      OR
           (AVAILABLE clas_dia_calend                          AND
            clas_dia_calend.ind_tip_dia_calend <> "Feriado") THEN
            ASSIGN pAcao = "E".

        /* Nesta procedure foi utilizado um campo contador, pois a repeti‡Æo do campo 
           tt-dia_calend_glob.cod_clas_dia_calend estava dando confusÆo no lado do Outbuycenter */

        ASSIGN i-contaRegistros = i-contaRegistros + 1
               cRegistro = TRIM(STRING(i-contaRegistros))                           + "{&SEPARADOR}" +
                           TRIM(tt-dia_calend_glob.des_dia_calend)                  + "{&SEPARADOR}" +
                           TRIM(STRING(DAY(tt-dia_calend_glob.dat_calend), "99"))   + "{&SEPARADOR}" +
                           TRIM(STRING(MONTH(tt-dia_calend_glob.dat_calend), "99")) + "{&SEPARADOR}" +
                           TRIM(STRING(YEAR(tt-dia_calend_glob.dat_calend), "9999")).

        RUN piCriarTtRegistro IN THIS-PROCEDURE (INPUT "FERIADO",
                                                 INPUT TRIM(REPLACE(STRING(tt-dia_calend_glob.dat_calend, "99/99/9999"), "/", "")),
                                                 INPUT cRegistro).
    END.

    EMPTY TEMP-TABLE tt-dia_calend_glob.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piFeriadoByClasse) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piFeriadoByClasse Procedure 
PROCEDURE piFeriadoByClasse :
/*------------------------------------------------------------------------------
  Purpose:     Gerar registros da tabela "clas_dia_calend" (uni178).
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-clas_dia_calend.

    FOR EACH ttRawTabela:
        CREATE tt-clas_dia_calend.
        RAW-TRANSFER ttRawTabela.rawTabela TO tt-clas_dia_calend.
    END.

    RUN piLimparTtRegistro IN THIS-PROCEDURE.

    FOR EACH tt-clas_dia_calend:
        IF tt-clas_dia_calend.ind_tip_dia_calend = "Feriado" THEN
            ASSIGN pAcao = "A".
        ELSE
            ASSIGN pAcao = "E".

        FOR EACH dia_calend_glob NO-LOCK
            WHERE dia_calend_glob.cod_clas_dia_calend = tt-clas_dia_calend.cod_clas_dia_calend:
            ASSIGN cRegistro = TRIM(dia_calend_glob.cod_calend)                        + "{&SEPARADOR}" +
                               TRIM(dia_calend_glob.des_dia_calend)                    + "{&SEPARADOR}" +
                               TRIM(STRING(DAY(dia_calend_glob.dat_calend), "99"))   + "{&SEPARADOR}" +
                               TRIM(STRING(MONTH(dia_calend_glob.dat_calend), "99")) + "{&SEPARADOR}" +
                               TRIM(STRING(YEAR(dia_calend_glob.dat_calend), "9999")).

            RUN piCriarTtRegistro IN THIS-PROCEDURE (INPUT "FERIADO",
                                                     INPUT TRIM(REPLACE(STRING(dia_calend_glob.dat_calend, "99/99/9999"), "/", "")),
                                                     INPUT cRegistro).
        END.
    END.

    EMPTY TEMP-TABLE tt-clas_dia_calend.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piInativaCtaCtbl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piInativaCtaCtbl Procedure 
PROCEDURE piInativaCtaCtbl :
/*------------------------------------------------------------------------------
  Purpose:     Gerar registros da tabela "cta_ctbl".Para Inativar.
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-conta-auxiliar.

    FOR EACH ttRawTabela:
        CREATE tt-conta-auxiliar.
        RAW-TRANSFER ttRawTabela.rawTabela TO tt-conta-auxiliar.
    END.

    RUN piLimparTtRegistro IN THIS-PROCEDURE.

    FOR EACH  tt-conta-auxiliar 
        WHERE tt-conta-auxiliar.marca = "*",
        FIRST cta_ctbl NO-LOCK
        WHERE cta_ctbl.cod_plano_cta_ctbl = tt-conta-auxiliar.cod_plano_cta_ctbl
        AND   cta_ctbl.cod_cta_ctbl       = tt-conta-auxiliar.cod_cta_ctbl:
        ASSIGN cRegistro = TRIM(STRING(tt-conta-auxiliar.cod_cta_ctbl, "9.9.9.99.999")) + "{&SEPARADOR}" +
                           TRIM(tt-conta-auxiliar.cod_cta_ctbl)                         + "{&SEPARADOR}" +
                           TRIM(tt-conta-auxiliar.des_cta_ctbl)                         + "{&SEPARADOR}".

        IF cta_ctbl.ind_espec_cta_ctbl = "Anal¡tica" 
        THEN ASSIGN cRegistro = cRegistro + TRIM("C") + "{&SEPARADOR}". /* Cont bil */
        ELSE IF cta_ctbl.ind_espec_cta_ctbl = "Sint‚tica" 
             THEN ASSIGN cRegistro = cRegistro + TRIM("T") + "{&SEPARADOR}". /* Totalizadora */
             ELSE ASSIGN cRegistro = cRegistro + "{&SEPARADOR}".

        ASSIGN cRegistro = cRegistro + TRIM("N") + "{&SEPARADOR}" + TRIM("I").
        
        RUN piCriarTtRegistro IN THIS-PROCEDURE (INPUT "CONTA_CONTABIL":U,
                                                 INPUT TRIM(tt-conta-auxiliar.cod_cta_ctbl),
                                                 INPUT cRegistro).

    END. /* FOR EACH  tt-conta-auxiliar */
    
    EMPTY TEMP-TABLE tt-conta-auxiliar.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piMensagem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMensagem Procedure 
PROCEDURE piMensagem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-mensagem.

    FOR EACH ttRawTabela:
        CREATE tt-mensagem.
        RAW-TRANSFER ttRawTabela.rawTabela TO tt-mensagem.
    END.

    RUN piLimparTtRegistro IN THIS-PROCEDURE.

    FOR EACH tt-mensagem:
        ASSIGN cRegistro = TRIM(STRING(tt-mensagem.cod-mensagem, ">>9":U)) + "{&SEPARADOR}":U +
                           TRIM(tt-mensagem.descricao)                     + "{&SEPARADOR}":U.

        ASSIGN cRegistro = cRegistro + IF trim(tt-mensagem.texto-mensag) <> "" 
                                       THEN trim(tt-mensagem.texto-mensag)
                                       ELSE ".":U.

        RUN piCriarTtRegistro IN THIS-PROCEDURE (INPUT "MENSAGEM":U,
                                                 INPUT TRIM(STRING(tt-mensagem.cod-mensagem, ">>9":U)),
                                                 INPUT cRegistro).
    END.

    EMPTY TEMP-TABLE tt-mensagem.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piNCM) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piNCM Procedure 
PROCEDURE piNCM :
/*------------------------------------------------------------------------------
  Purpose:     Gerar registros da tabela "classif-fisc" (in046).
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-classif-fisc.

    FOR EACH ttRawTabela:
        CREATE tt-classif-fisc.
        RAW-TRANSFER ttRawTabela.rawTabela TO tt-classif-fisc.
    END.

    RUN piLimparTtRegistro IN THIS-PROCEDURE.

    FOR EACH tt-classif-fisc:
        ASSIGN cRegistro = TRIM(STRING(tt-classif-fisc.class-fiscal, "9999.99.99":U)) + "{&SEPARADOR}":U +
                           TRIM(tt-classif-fisc.descricao).

        RUN piCriarTtRegistro IN THIS-PROCEDURE (INPUT "NCM":U,
                                                 INPUT TRIM(STRING(tt-classif-fisc.class-fiscal, "99999999":U)),
                                                 INPUT cRegistro).
    END.

    EMPTY TEMP-TABLE tt-classif-fisc.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piPlanoContas) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPlanoContas Procedure 
PROCEDURE piPlanoContas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-plano-aux.

    FOR EACH ttRawTabela:
        CREATE tt-plano-aux.
        RAW-TRANSFER ttRawTabela.rawTabela TO tt-plano-aux.
    END.

    RUN piLimparTtRegistro IN THIS-PROCEDURE.

/*     OUTPUT TO VALUE("c:\temp\Registro-planoconta.txt") NO-CONVERT.  */
    FOR EACH tt-plano-aux:
        
        ASSIGN cRegistro = TRIM(tt-plano-aux.cod_unid_negoc) + TRIM(tt-plano-aux.cod_ccusto) + "." +  TRIM(tt-plano-aux.cod_estab) + "{&SEPARADOR}" + TRIM(tt-plano-aux.cod_cta_ctbl).


/*         PUT UNFORMATTED cRegistro SKIP.  */

        RUN piCriarTtRegistro IN THIS-PROCEDURE (INPUT "PLANO_CONTA":U,
                                                 INPUT "0",
                                                 INPUT cRegistro).
        DELETE tt-plano-aux.
    END. /* FOR EACH tt-plano-aux: */
/*     OUTPUT CLOSE.  */
    
    EMPTY TEMP-TABLE tt-plano-aux.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

