&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : ESSDCV001API.P
    Purpose     : Integraá∆o das Triggers do ERP TOTVS/Datasul EMS 2 com o
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

/* Definiá∆o da temp-table "ttRawTempTable" ttRawTabela */
{esp/sdcv/essdcv001api.i}

/* Definiá∆o da temp-table "RowErrors" */
{method/dbotterr.i}

/* Definiá∆o da temp-table "tt-prog-ponto" */
{esp/es0018.i}

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-cotacao           NO-UNDO LIKE cotacao.

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER pTabela AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER pAcao   AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER pcot-ini   AS date     NO-UNDO.
DEFINE INPUT  PARAMETER pcot-fim   AS date     NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

/* Variable Definitions ---                                             */
{upc/btb910za-upc.i}
{esp/sdcv/essdcv001api.i2}

/* Buffer Definitions ---                                               */

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

/* ParÉmetros para conex∆o com o Web Service */

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

&IF DEFINED(EXCLUDE-piConstroiRegistro) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piConstroiRegistro Procedure 
PROCEDURE piConstroiRegistro :
/*------------------------------------------------------------------------------
  Purpose:     Chama, baseado na tabela, as procedures que constroem os registros
               para exportaá∆o.
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    
    CASE pTabela:
        WHEN "cotacao":U   THEN RUN piCotacao IN THIS-PROCEDURE.
        OTHERWISE DO:
            RUN piCriarRowErrors IN THIS-PROCEDURE (INPUT 17006, INPUT "Tabela n∆o encontrada!":U).
            RETURN ERROR.
        END. /* OTHERWISE DO: */
    END CASE.

    IF RETURN-VALUE = "NOK":U THEN RETURN ERROR.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piCotacao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCotacao Procedure 
PROCEDURE piCotacao :
/*------------------------------------------------------------------------------
  Purpose:     Gerar registros da tabela "cotacao" .
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE VARIABLE daAux       AS DATE        NO-UNDO.
    DEFINE VARIABLE iNumDiasMes AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iContDias   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-per-ini   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-per-fim   AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE d-data-aux AS DATE FORMAT "99/99/9999":U NO-UNDO.

    ASSIGN c-per-ini = string(SUBSTR(STRING(pcot-ini,'99/99/9999'),7,4),'9999') + string(SUBSTR(STRING(pcot-ini),4,2))
           c-per-fim = string(SUBSTR(STRING(pcot-fim,'99/99/9999'),7,4),'9999') + string(SUBSTR(STRING(pcot-fim),4,2)).

    RUN piLimparTtRegistro IN THIS-PROCEDURE.

    ASSIGN d-data-aux = pcot-ini.

    DO WHILE d-data-aux <= pcot-fim :

        FOR EACH cotacao NO-LOCK
            WHERE cotacao.ano-periodo = string(SUBSTR(STRING(d-data-aux,'99/99/9999'),7,4),'9999') + string(SUBSTR(STRING(d-data-aux),4,2)):

            ASSIGN cRegistro = TRIM(STRING(cotacao.mo-codigo, ">9":U)) + "{&SEPARADOR}":U +
                                  STRING(d-data-aux) + "{&SEPARADOR}":U + TRIM(REPLACE(STRING(cotacao.cotacao[DAY(d-data-aux)], ">>>>>9.99999999":U), SESSION:NUMERIC-DECIMAL-POINT, ".":U)).
    
            RUN piCriarTtRegistro IN THIS-PROCEDURE (INPUT "COTACAO_MOEDA":U,
                                                     INPUT TRIM(STRING(cotacao.mo-codigo, ">9":U)),
                                                     INPUT cRegistro).    

        END.  
        ASSIGN d-data-aux = d-data-aux + 1.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
