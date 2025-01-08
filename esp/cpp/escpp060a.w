&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCPP060A 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCPP060A
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   fiMacAddressIni ~
                              fiMacAddressFin ~
                              cb-modelo ~
                              fiMotivo ~
                              btConfigImpr ~
                              btOK ~
                              btCancel ~
                              btHelp2 ~
                              rs-formata

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-mac-address NO-UNDO LIKE mac-address
    FIELD r-Rowid AS ROWID.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE cPrinter AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cAuxFile AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLayout  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp  AS HANDLE      NO-UNDO.

/* Global Shared Variable Definitions ---                               */

DEFINE NEW GLOBAL SHARED VARIABLE v_nom_disposit_so AS CHARACTER   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar IMAGE-1 IMAGE-2 RECT-15 ~
fiMacAddressIni fiMacAddressFin fiMotivo btConfigImpr fiPrinter rs-formata ~
btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS fiMacAddressIni fiMacAddressFin fiMotivo ~
fiPrinter cb-modelo rs-formata 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnGeraSenha wWindow 
FUNCTION fnGeraSenha RETURNS CHARACTER
  ( pTpSenha AS CHAR, pSenhaMaster AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnModelo wWindow 
FUNCTION fnModelo RETURNS CHARACTER
  (p-tipo AS INTEGER  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Sair" 
     SIZE 10 BY 1.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image/im-cfprt":U
     LABEL "Configuraá∆o da impressora" 
     SIZE 4 BY 1 TOOLTIP "Configuraá∆o da impressora".

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&Reimprimir" 
     SIZE 10 BY 1.

DEFINE VARIABLE cb-modelo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 8
     LIST-ITEMS "Somente c¢digo de barras","C¢digo de barras + gponsn","Somente qr-code","Qr-code com senha m†ster","Qr-code com senha m†ster e acesso remoto","MAC + GPON C¢digo de Barra","Qr-code com senha m†ster e acesso remoto Positron","MAC + GPON C¢digo de Barra Tripla" 
     DROP-DOWN-LIST
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE fiMotivo AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256 SCROLLBAR-VERTICAL
     SIZE 44 BY 3.88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiPrinter AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 44 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiMacAddressFin AS CHARACTER FORMAT "x(12)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fiMacAddressIni AS CHARACTER FORMAT "x(12)":U 
     LABEL "Mac Address" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE rs-formata AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Com Formataá∆o", 1,
"Sem Formataá∆o", 2
     SIZE 39 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44 BY 3.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 75 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fiMacAddressIni AT ROW 1.5 COL 10.71 HELP
          "Mac Address Inicial"
     fiMacAddressFin AT ROW 1.5 COL 48.43 COLON-ALIGNED HELP
          "Mac Address Final" NO-LABEL
     fiMotivo AT ROW 2.5 COL 20.43 HELP
          "Motivo da Reimpress∆o" NO-LABEL
     btConfigImpr AT ROW 6.42 COL 64.43 HELP
          "Configuraá∆o da impressora"
     fiPrinter AT ROW 6.5 COL 20.43 NO-LABEL NO-TAB-STOP 
     cb-modelo AT ROW 8.33 COL 20 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     rs-formata AT ROW 9.71 COL 22 NO-LABEL WIDGET-ID 2
     btOK AT ROW 12.25 COL 2 HELP
          "Reimprimir"
     btCancel AT ROW 12.25 COL 13 HELP
          "Sair do Programa"
     btHelp2 AT ROW 12.25 COL 64 HELP
          "Ajuda"
     "Motivo Reimpress∆o:" VIEW-AS TEXT
          SIZE 14.29 BY .63 AT ROW 2.63 COL 19.15 RIGHT-ALIGNED
     "Impressora:" VIEW-AS TEXT
          SIZE 8 BY .63 AT ROW 6.63 COL 12.29
     rtToolBar AT ROW 12 COL 1
     IMAGE-1 AT ROW 1.5 COL 34.57
     IMAGE-2 AT ROW 1.5 COL 47.29
     RECT-15 AT ROW 7.75 COL 20.43 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 75.43 BY 12.58
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 12.58
         WIDTH              = 75.43
         MAX-HEIGHT         = 12.58
         MAX-WIDTH          = 75.57
         VIRTUAL-HEIGHT     = 12.58
         VIRTUAL-WIDTH      = 75.57
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR COMBO-BOX cb-modelo IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiMacAddressIni IN FRAME fpage0
   ALIGN-L                                                              */
ASSIGN 
       fiPrinter:READ-ONLY IN FRAME fpage0        = TRUE.

/* SETTINGS FOR TEXT-LITERAL "Motivo Reimpress∆o:"
          SIZE 14.29 BY .63 AT ROW 2.63 COL 19.15 RIGHT-ALIGNED         */

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Sair */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btConfigImpr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfigImpr wWindow
ON CHOOSE OF btConfigImpr IN FRAME fpage0 /* Configuraá∆o da impressora */
DO:
    RUN piSelectPrinter IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* Reimprimir */
DO:
    IF NOT CAN-FIND( FIRST mac-address
        WHERE mac-address.mac = fiMacAddressIni:SCREEN-VALUE IN FRAME fPage0) THEN DO:

        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Na faixa inicial deve ser informado um Mac v†lido para que seja definido o modelo da etiqueta!":U).
        RETURN NO-APPLY.
    END.


    RUN piExecute IN THIS-PROCEDURE.

    IF RETURN-VALUE = "NOK":U THEN
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Etiquetas n∆o foram reimpressas!":U).
    ELSE
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 15825,
                           INPUT "Etiqueta(s) reimpressa(s) com sucesso!":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiMacAddressIni
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiMacAddressIni wWindow
ON LEAVE OF fiMacAddressIni IN FRAME fpage0 /* Mac Address */
DO:
   
    FIND FIRST mac-address
        WHERE mac-address.mac = fiMacAddressIni:SCREEN-VALUE IN FRAME fPage0 NO-LOCK NO-ERROR.

    IF AVAIL mac-address THEN DO:
        
        FIND FIRST item-ean
            WHERE item-ean.it-codigo = mac-address.it-codigo NO-LOCK NO-ERROR.
        IF AVAIL item-ean THEN DO:
            ASSIGN cb-modelo:SCREEN-VALUE IN FRAME fpage0 = fnModelo(item-ean.modelo-mac-address).
    
            IF item-ean.modelo-mac-address > 3 /* senha master e/ou senha acesso */ THEN DO:
                DISABLE rs-formata WITH FRAME fpage0.
                ASSIGN rs-formata:SCREEN-VALUE IN FRAME fpage0 = "2".
            END.
        END.
    END.
    

    DISPLAY cb-modelo rs-formata
        WITH FRAME fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN fiMacAddressIni                     = "":U
           fiMacAddressFin                     = FILL("Z":U, 12)
           cb-modelo:SENSITIVE IN FRAME fPage0 = NO.

    DISPLAY fiMacAddressIni
            fiMacAddressFin
        WITH FRAME fPage0.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wWindow 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Reimpress∆o de etiquetas...":U).

    ASSIGN INPUT FRAME fPage0 fiMacAddressIni
                              fiMacAddressFin
                              fiPrinter
                              fiMotivo.

    RUN piValidateParam IN THIS-PROCEDURE (INPUT fiMacAddressIni,
                                           INPUT fiMacAddressFin,
                                           INPUT fiPrinter,
                                           INPUT fiMotivo).

    IF RETURN-VALUE = "NOK":U THEN DO:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-finalizar IN h-acomp.

        IF VALID-HANDLE(h-acomp) THEN
            DELETE PROCEDURE h-acomp.

        ASSIGN h-acomp = ?.

        RETURN "NOK":U.
    END.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Preparando para reimpress∆o...":U).

    EMPTY TEMP-TABLE tt-mac-address.

    FOR EACH mac-address USE-INDEX ch-pri NO-LOCK
        WHERE mac-address.mac     >= fiMacAddressIni
          AND mac-address.mac     <= fiMacAddressFin
          AND mac-address.impresso = YES:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "MAC: ":U + mac-address.mac).

        CREATE tt-mac-address.
        BUFFER-COPY mac-address TO tt-mac-address.
        ASSIGN tt-mac-address.r-Rowid = ROWID(mac-address).
    END.

    RUN piImprimirEtiqueta IN THIS-PROCEDURE (INPUT fiMotivo,
                                              INPUT "2", /*Reimpress∆o*/
                                              INPUT STRING(item-ean.modelo-mac-address)).

    IF RETURN-VALUE = "NOK":U THEN DO:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-finalizar IN h-acomp.

        IF VALID-HANDLE(h-acomp) THEN
            DELETE PROCEDURE h-acomp.

        ASSIGN h-acomp = ?.

        RETURN "NOK":U.
    END.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        DELETE PROCEDURE h-acomp.

    ASSIGN h-acomp = ?.

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImprimirEtiqueta wWindow 
PROCEDURE piImprimirEtiqueta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pMotivo      AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER pTpImpressao AS CHAR        NO-UNDO. /* 1-Impress∆o, 2 Reimpress∆o*/ 
    DEFINE INPUT PARAMETER pCodBarras   AS CHAR        NO-UNDO. /* C¢digo de Barras ou QRCode*/

    {esp/cpp/escpp060.i}

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSelectPrinter wWindow 
PROCEDURE piSelectPrinter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cTempFile AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cAuxFile  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cPrev     AS CHARACTER   NO-UNDO.

    ASSIGN INPUT FRAME fPage0 fiPrinter.

    ASSIGN cPrev     = fiPrinter
           cTempFile = REPLACE(fiPrinter, ":":U, ",":U).

    IF fiPrinter <> "":U THEN DO:
        IF NUM-ENTRIES(cTempFile) = 4 THEN
            ASSIGN cPrinter = ENTRY(1, cTempFile)
                   cLayout  = ENTRY(2, cTempFile)
                   cAuxFile = ENTRY(3, cTempFile) + ":":U + ENTRY(4, cTempFile).

        IF NUM-ENTRIES(cTempFile) = 3 THEN
            ASSIGN cPrinter = ENTRY(1, cTempFile)
                   cLayout  = ENTRY(2, cTempFile)
                   cAuxFile = ENTRY(3, cTempFile).

        IF NUM-ENTRIES(cTempFile) = 2 THEN
            ASSIGN cPrinter = ENTRY(1, cTempFile)
                   cLayout  = ENTRY(2, cTempFile)
                   cAuxFile = "":U.
    END.

    RUN utp/ut-impr.w (INPUT-OUTPUT cPrinter,
                       INPUT-OUTPUT cLayout,
                       INPUT-OUTPUT cAuxFile).

    IF cAuxFile = "":U THEN
        ASSIGN fiPrinter = cPrinter + ":":U + cLayout.
    ELSE
        ASSIGN fiPrinter = cPrinter + ":":U + cLayout + ":":U + cAuxFile.

    IF fiPrinter = ":":U THEN
        ASSIGN fiPrinter = cPrev.

    DISPLAY fiPrinter
        WITH FRAME fPage0.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidateParam wWindow 
PROCEDURE piValidateParam :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pMacAddressIni AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pMacAddressFin AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pPrinter       AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pMotivo        AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE cItCodigo AS CHARACTER   NO-UNDO.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Validando parÉmetros...":U).

    IF pMacAddressIni > pMacAddressFin THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "O Mac Address Inicial Ç maior que o Mac Address Final":U).

        RETURN "NOK":U.
    END.

    IF SUBSTRING(pMacAddressIni, 1, 6) <> SUBSTRING(pMacAddressFin, 1, 6) THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Os Macs Address informados tem o Mac da Intelbras diferentes":U).

        RETURN "NOK":U.
    END.

    IF pMotivo = "":U THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Motivo da Reimpress∆o deve ser preenchido!":U).

        RETURN "NOK":U.
    END.

    FIND FIRST mac-address USE-INDEX ch-pri
        WHERE mac-address.mac     >= pMacAddressIni
          AND mac-address.mac     <= pMacAddressFin
          AND mac-address.impresso = YES NO-LOCK NO-ERROR.

    IF NOT AVAILABLE mac-address THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "N∆o existe etiqueta a ser impressa na faixa informada.":U).

        RETURN "NOK":U.
    END.

    ASSIGN cItCodigo = "":U.

    FOR FIRST mac-address USE-INDEX ch-pri NO-LOCK
        WHERE mac-address.mac >= pMacAddressIni
          AND mac-address.mac <= pMacAddressFin:
        ASSIGN cItCodigo = mac-address.it-codigo.
    END.

    FOR EACH mac-address USE-INDEX ch-pri NO-LOCK
        WHERE mac-address.mac >= pMacAddressIni
          AND mac-address.mac <= pMacAddressFin:
        IF cItCodigo <> mac-address.it-codigo THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "A faixa de Mac Address informada contÇm Mac Address de itens diferentes":U).

            RETURN "NOK":U.
        END.
    END.

    IF NUM-ENTRIES(pPrinter, ":":U) = 2 THEN DO:
        ASSIGN cPrinter = SUBSTRING(pPrinter, 1, INDEX(pPrinter, ":":U) - 1)
               cLayout  = SUBSTRING(pPrinter, INDEX(pPrinter, ":":U) + 1, LENGTH(pPrinter) - INDEX(pPrinter, ":":U)).

        FIND FIRST imprsor_usuar USE-INDEX imprsrsr_id
            WHERE imprsor_usuar.nom_impressora = cPrinter
              AND imprsor_usuar.cod_usuario    = c-seg-usuario NO-LOCK NO-ERROR.

        IF NOT AVAILABLE imprsor_usuar THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 4306,
                               INPUT c-seg-usuario).

            RETURN "NOK":U.
        END.

        FIND FIRST layout_impres
            WHERE layout_impres.nom_impressora    = cPrinter
              AND layout_impres.cod_layout_impres = cLayout NO-LOCK NO-ERROR.

        IF NOT AVAILABLE layout_impres THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 4306,
                               INPUT c-seg-usuario).

            RETURN "NOK":U.
        END.
    END.
    ELSE DO:
        IF NUM-ENTRIES(pPrinter, ":":U) < 2 THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 4306,
                               INPUT c-seg-usuario).

            RETURN "NOK":U.
        END.

        ASSIGN cPrinter = ENTRY(1, pPrinter, ":":U)
               cLayout  = ENTRY(2, pPrinter, ":":U).

        FIND FIRST imprsor_usuar USE-INDEX imprsrsr_id
            WHERE imprsor_usuar.nom_impressora = cPrinter
              AND imprsor_usuar.cod_usuario    = c-seg-usuario NO-LOCK NO-ERROR.

        IF NOT AVAILABLE imprsor_usuar THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 4306,
                               INPUT c-seg-usuario).

            RETURN "NOK":U.
        END.

        FIND FIRST layout_impres
            WHERE layout_impres.nom_impressora = cPrinter
              AND layout_impres.cod_layout_impres = cLayout NO-LOCK NO-ERROR.

        IF NOT AVAILABLE layout_impres THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 4306,
                               INPUT c-seg-usuario).

            RETURN "NOK":U.
        END.
    END.

    ASSIGN v_nom_disposit_so = imprsor_usuar.nom_disposit_so.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnGeraSenha wWindow 
FUNCTION fnGeraSenha RETURNS CHARACTER
  ( pTpSenha AS CHAR, pSenhaMaster AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE i-senha AS CHAR     NO-UNDO.
    
    IF pTpSenha = "master" THEN DO:
        blk_senha:
        REPEAT:
            ASSIGN i-senha = string(RANDOM(1,9999),"9999").

            IF i-senha <> "9090" THEN
                LEAVE blk_senha.
        END.
    END.
    ELSE IF pTpSenha = "remoto" THEN DO:
        blk_senha:
        REPEAT:
            ASSIGN i-senha = string(RANDOM(1,999999),"999999").

            IF  SUBSTRING(i-senha,1,4) <> "9090" 
            AND NOT i-senha BEGINS pSenhaMaster THEN
                LEAVE blk_senha.
        END.
    END.

    RETURN i-senha.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnModelo wWindow 
FUNCTION fnModelo RETURNS CHARACTER
  (p-tipo AS INTEGER  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    CASE p-tipo: 
        WHEN 0 OR WHEN 1 THEN RETURN "Somente c¢digo de barras".
        WHEN 2           THEN RETURN "C¢digo de barras + gponsn".              
        WHEN 3           THEN RETURN "Somente qr-code".                        
        WHEN 4           THEN RETURN "Qr-code com senha m†ster".
        WHEN 5           THEN RETURN "Qr-code com senha m†ster e acesso remoto".
        WHEN 6           THEN RETURN "MAC + GPON C¢digo de Barra".
        WHEN 7           THEN RETURN "Qr-code com senha m†ster e acesso remoto Positron".
        WHEN 8           THEN RETURN "MAC + GPON C¢digo de Barra Tripla".
    END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

