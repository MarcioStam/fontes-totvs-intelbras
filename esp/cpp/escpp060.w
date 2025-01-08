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
{include/i-prgvrs.i ESCPP060 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCPP060
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   NO

&GLOBAL-DEFINE page0Widgets   btReimprimir ~
                              cb-modelo ~
                              bt-imp-mac ~
                              btQueryJoins ~
                              btReportsJoins ~
                              btExit ~
                              btHelp ~
                              fiItCodigo ~
                              fiQtdEtiqueta ~
                              btConfigImpr ~
                              btImprimir ~
                              rsDestiny  ~
                              rs-formata

/* Include Definitions ---                                              */

{esapi/esapi016.i}
{esapi/esapi023.i}   /*ttItem*/
{cdp/cd0666.i}       /*tt-erro*/

{esp/es0018.i}

DEF BUFFER b01-mac-address FOR mac-address.

/* Local Temp-Table Definitions ---                                     */

DEF TEMP-TABLE tt-mac-address-fiber LIKE mac-address-fiber.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE wh-pesquisa AS HANDLE    NO-UNDO.
DEFINE VARIABLE cPrinter    AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-terminal  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cAuxFile    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cLayout     AS CHARACTER NO-UNDO.
DEFINE VARIABLE h-api023    AS HANDLE    NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE h-acomp AS HANDLE NO-UNDO.

DEFINE STREAM st-mac.

/* Global Shared Variable Definitions ---                               */

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl    AS HANDLE      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_nom_disposit_so AS CHARACTER   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren AS CHARACTER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btReimprimir btQueryJoins btReportsJoins ~
btExit btHelp fiItCodigo fiQtdEtiqueta btConfigImpr rsDestiny fiDescItem ~
rs-formata btImprimir fiPrinter bt-imp-mac rtToolBar-2 RECT-14 
&Scoped-Define DISPLAYED-OBJECTS cb-modelo fiItCodigo fiQtdEtiqueta ~
rsDestiny fiDescItem rs-formata fiPrinter 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD conv-dec-to-hex wWindow 
FUNCTION conv-dec-to-hex RETURNS CHARACTER
  ( INPUT p-num-decimal AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD conv-hex-to-dec wWindow 
FUNCTION conv-hex-to-dec RETURNS INTEGER
  ( INPUT p-val-hexadecimal AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fator wWindow 
FUNCTION fator RETURNS INTEGER
  ( INPUT p-fator AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miReimprimir   LABEL "&Reimprimir Etiqueta"
       RULE
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-imp-mac 
     IMAGE-UP FILE "image\ii-barras":U
     LABEL "Imprimir MAC" 
     SIZE 4 BY 1.25 TOOLTIP "Impress∆o de MAC".

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "Configuraá∆o da impressora" 
     SIZE 4 BY 1 TOOLTIP "Configuraá∆o da impressora".

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btImprimir 
     LABEL "&Imprimir" 
     SIZE 15 BY 1 TOOLTIP "Imprimir Etiqueta".

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReimprimir 
     IMAGE-UP FILE "image\im-repr2":U
     IMAGE-INSENSITIVE FILE "image\ii-repr2":U
     LABEL "Reimprimir" 
     SIZE 4 BY 1.25 TOOLTIP "Reimprimir Etiqueta".

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE cb-modelo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 9
     LIST-ITEMS "Somente c¢digo de barras","C¢digo de barras + gponsn","Somente qr-code","Qr-code com senha m†ster","Qr-code com senha m†ster e acesso remoto","MAC + GPON C¢digo de Barra","Qr-code com senha m†ster e acesso remoto Positron","MAC + GPON C¢digo de Barra Tripla","QR CODE com senha ADMIN + Senha WIFI" 
     DROP-DOWN-LIST
     SIZE 39.86 BY 1 NO-UNDO.

DEFINE VARIABLE fiPrinter AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 44 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiDescItem AS CHARACTER FORMAT "x(60)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .88 NO-UNDO.

DEFINE VARIABLE fiItCodigo AS CHARACTER FORMAT "x(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiQtdEtiqueta AS INTEGER FORMAT ">,>>9":U INITIAL 0 
     LABEL "Quantidade Etiqueta" 
     VIEW-AS FILL-IN 
     SIZE 8.14 BY .88 NO-UNDO.

DEFINE VARIABLE rs-formata AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Com Formataá∆o", 1,
"Sem Formataá∆o", 2
     SIZE 37.43 BY .88 NO-UNDO.

DEFINE VARIABLE rsDestiny AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Terminal", 2
     SIZE 36 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 48 BY 4.5.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 85 BY 1.5
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     cb-modelo AT ROW 8.63 COL 21.14 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     btReimprimir AT ROW 1.13 COL 1.57 HELP
          "Reimprimir Etiqueta"
     btQueryJoins AT ROW 1.13 COL 69.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 73.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 77.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 81.72 HELP
          "Ajuda"
     fiItCodigo AT ROW 3.88 COL 18.86 COLON-ALIGNED HELP
          "C¢digo do Item"
     fiQtdEtiqueta AT ROW 4.88 COL 18.86 COLON-ALIGNED HELP
          "Quantidade de Etiqueta"
     btConfigImpr AT ROW 5.79 COL 64.86 HELP
          "Configuraá∆o da impressora"
     rsDestiny AT ROW 7.29 COL 23 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL WIDGET-ID 2
     fiDescItem AT ROW 3.88 COL 31.72 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     rs-formata AT ROW 10.04 COL 23 NO-LABEL WIDGET-ID 8
     btImprimir AT ROW 12.63 COL 37.43 HELP
          "Imprimir Etiqueta"
     fiPrinter AT ROW 5.88 COL 20.86 NO-LABEL NO-TAB-STOP 
     bt-imp-mac AT ROW 1.13 COL 5.86 HELP
          "Reimprimir Etiqueta" WIDGET-ID 24
     "Impressora:" VIEW-AS TEXT
          SIZE 8 BY .63 AT ROW 6 COL 12.72
          FONT 1
     rtToolBar-2 AT ROW 1 COL 1
     RECT-14 AT ROW 7 COL 21 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 86.14 BY 12.92
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
         HEIGHT             = 12.92
         WIDTH              = 86.14
         MAX-HEIGHT         = 12.92
         MAX-WIDTH          = 86.14
         VIRTUAL-HEIGHT     = 12.92
         VIRTUAL-WIDTH      = 86.14
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
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
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR COMBO-BOX cb-modelo IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       fiPrinter:READ-ONLY IN FRAME fpage0        = TRUE.

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


&Scoped-define SELF-NAME bt-imp-mac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-imp-mac wWindow
ON CHOOSE OF bt-imp-mac IN FRAME fpage0 /* Imprimir MAC */
DO:
    {&WINDOW-NAME}:SENSITIVE = NO.
    RUN esp/cpp/escpp060b.w.
    {&WINDOW-NAME}:SENSITIVE = YES.
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


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btImprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImprimir wWindow
ON CHOOSE OF btImprimir IN FRAME fpage0 /* Imprimir */
DO:
    RUN piExecute IN THIS-PROCEDURE. 

    IF RETURN-VALUE = "NOK":U THEN
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Etiquetas n∆o foram impressas!":U).
    ELSE
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 15825,
                           INPUT "Etiqueta(s) impressa(s) com sucesso!":U).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReimprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReimprimir wWindow
ON CHOOSE OF btReimprimir IN FRAME fpage0 /* Reimprimir */
OR CHOOSE OF MENU-ITEM miReimprimir IN MENU mbMain DO:
    {&WINDOW-NAME}:SENSITIVE = NO.
    RUN esp/cpp/escpp060a.w.
    {&WINDOW-NAME}:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiItCodigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiItCodigo wWindow
ON F5 OF fiItCodigo IN FRAME fpage0 /* Item */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in172.w"
                       &campo="fiItCodigo"
                       &campozoom="it-codigo"
                       &frame="fPage0"}

    IF VALID-HANDLE(wh-pesquisa) THEN
        WAIT-FOR CLOSE OF wh-pesquisa.

    APPLY "LEAVE":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiItCodigo wWindow
ON LEAVE OF fiItCodigo IN FRAME fpage0 /* Item */
DO:
    ASSIGN INPUT FRAME fPage0 fiItCodigo.

    FIND FIRST item
        WHERE item.it-codigo = fiItCodigo NO-LOCK NO-ERROR.

    ASSIGN fiDescItem = IF AVAILABLE item THEN item.desc-item ELSE "":U.

    FIND FIRST item-ean
        WHERE item-ean.it-codigo = fiItCodigo NO-LOCK NO-ERROR.
    IF AVAIL item-ean THEN DO:
        ASSIGN cb-modelo:SCREEN-VALUE IN FRAME fpage0 = fnModelo(item-ean.modelo-mac-address).

        IF item-ean.modelo-mac-address > 3 /* senha master e/ou senha acesso */ THEN DO:
            DISABLE rs-formata WITH FRAME fpage0.
            ASSIGN rs-formata:SCREEN-VALUE IN FRAME fpage0 = "2".
        END.
    END.
        


    DISPLAY fiDescItem cb-modelo
        WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiItCodigo wWindow
ON MOUSE-SELECT-DBLCLICK OF fiItCodigo IN FRAME fpage0 /* Item */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wWindow
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
    {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsDestiny
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDestiny wWindow
ON VALUE-CHANGED OF rsDestiny IN FRAME fpage0
DO:
  do  with frame fPage0:
      case self:screen-value:
          when "1":U then do:
              assign btConfigImpr:SENSITIVE  = YES
                     /* rsTipo:SENSITIVE        = YES 
                     tg-gponsn:SENSITIVE     = YES */ .
           end.
           when "2":U then do:
               assign btConfigImpr:SENSITIVE  = NO
                     /* rsTipo:SENSITIVE        = NO
                      rsTipo:SCREEN-VALUE     = "1"
                      tg-gponsn:CHECKED       = NO
                      tg-gponsn:SENSITIVE     = NO */ .
           end.
        end case.
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

/*--- Seta cursor do mouse para lupa, quando estiver posicionado sobre o fill-in ---*/
IF fiItCodigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0 THEN.

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
    APPLY "LEAVE":U TO fiItCodigo IN FRAME fPage0.

    /*
    ASSIGN rsTipo:SCREEN-VALUE IN FRAME fpage0 = "1".
    IF  rsDestiny:SCREEN-VALUE IN FRAME fpage0 = "1" THEN
        ASSIGN rsTipo:SENSITIVE = YES.
    ELSE
        ASSIGN rsTipo:SENSITIVE = NO.
    */

    ASSIGN cb-modelo:SENSITIVE = NO.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEfetivaMac wWindow 
PROCEDURE piEfetivaMac :
/*------------------------------------------------------------------------------
  Purpose: Executa rotina de efetivaá∆o dos mac address    
  Notes:   Carlos Daniel - 22/09/2015
------------------------------------------------------------------------------*/
IF NOT VALID-HANDLE(h-api023) THEN
    RUN esapi/esapi023.p PERSISTENT SET h-api023.

RUN piGeraMac IN h-api023 (INPUT 0,
                           INPUT-OUTPUT TABLE tt-mac-address,
                           INPUT-OUTPUT TABLE tt-erro).

IF RETURN-VALUE NE 'OK' THEN DO:
    RUN cdp/cd0666.w( INPUT TABLE tt-erro).
    RETURN "NOK".
END.
IF CAN-FIND(FIRST tt-erro) THEN
    RUN cdp/cd0666.w( INPUT TABLE tt-erro).

RETURN "OK".
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wWindow 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/

IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Gerando etiqueta para impress∆o...":U).

ASSIGN INPUT FRAME fPage0 fiItCodigo
                          fiQtdEtiqueta
                          fiPrinter.

RUN piValidateParam IN THIS-PROCEDURE (INPUT fiItCodigo,
                                       INPUT fiQtdEtiqueta,
                                       INPUT fiPrinter).

IF RETURN-VALUE = "NOK":U THEN DO:
    IF VALID-HANDLE(h-acomp) THEN
        DELETE PROCEDURE h-acomp.
    RETURN "NOK".
END.

/* Executa API para prÇ e geraá∆o de MAC */
RUN esapi/esapi023.p PERSISTENT SET h-api023.
RUN piPreMac.
IF RETURN-VALUE <> "OK" THEN DO:
    IF VALID-HANDLE(h-api023) THEN
        DELETE PROCEDURE h-api023.
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
    RETURN "NOK".
END.
RUN piEfetivaMac.
IF VALID-HANDLE(h-api023) THEN
    DELETE PROCEDURE h-api023.
/* fim execuá∆o API gera MAC */

IF RETURN-VALUE <> "OK" THEN DO:
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
    RETURN "NOK".
END.

/* QRCODE com senha ADMIN + Senha WIFI */
IF item-ean.modelo-mac-address = 9 THEN DO:
   
   RUN piGeraSN.
   
   FOR EACH tt-mac-address
       BREAK BY tt-mac-address.mac:

       IF tt-mac-address.impresso THEN DO:
          IF FIRST(tt-mac-address.mac)  THEN
             FIND FIRST tt-lista-ns NO-ERROR.
          ELSE
             FIND NEXT tt-lista-ns NO-ERROR.
       END.

       IF AVAIL tt-lista-ns THEN DO:
          FIND FIRST mac-address WHERE mac-address.mac = tt-mac-address.mac EXCLUSIVE-LOCK NO-ERROR.

          IF AVAIL mac-address THEN DO:
             ASSIGN mac-address.n-serie = tt-lista-ns.num-serie.
             RELEASE mac-address.
          END.
       END.
   END.    

   RUN piPlanilhaFiberHome.
END.


/* Para 1 em rsDestiny = imprimir, piMac = gera arquivo txt */
IF rsDestiny:SCREEN-VALUE IN FRAME fpage0 = "1" THEN 
    RUN piImprimirEtiqueta IN THIS-PROCEDURE (INPUT "",
                                              INPUT "1", /*Impress∆o*/
                                              INPUT string(item-ean.modelo-mac-address)).
ELSE  RUN piMac IN THIS-PROCEDURE.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraSN wWindow 
PROCEDURE piGeraSN :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE h-esapi016 AS HANDLE  NO-UNDO.

RUN esapi/esapi016.p PERSISTENT SET h-esapi016.

EMPTY TEMP-TABLE tt-lista-ns NO-ERROR.

RUN piGeraNS IN h-esapi016 (INPUT fiItCodigo:SCREEN-VALUE IN FRAME fPage0,
                            INPUT 1,  /* Colocado um modelo com tipo 1 - N£mero de SÇrie para gerar os N£meros de SÇrie */
                            INPUT "",
                            INPUT INTEGER(fiQtdEtiqueta:SCREEN-VALUE),
                            INPUT 0,
                            INPUT 0,
                            INPUT "",
                            INPUT 3,
                            INPUT NO,  /* Tratamento ASTEC */
                            INPUT "",
                            INPUT "",
                            OUTPUT TABLE tt-lista-ns).

IF  RETURN-VALUE <> "OK":U THEN DO:
    EMPTY TEMP-TABLE tt-erro NO-ERROR.
    RUN piRetornaErros IN h-esapi016 (OUTPUT TABLE tt-erro).
    DELETE PROCEDURE h-esapi016.
    RETURN "NOK":U.
END. /* IF  RETURN-VALUE <> "OK":U THEN DO: */

DELETE PROCEDURE h-esapi016.


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
    DEFINE INPUT PARAMETER pCodBarras   AS CHAR        NO-UNDO. /* Modelo Mac Address */

    {esp/cpp/escpp060.i}

    RETURN "OK":U.

/*
DEFINE VARIABLE iColuna AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-mac AS CHAR NO-UNDO.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-seta-titulo IN h-acomp (INPUT "Imprimindo etiqueta...":U).

IF v_nom_disposit_so NE "" THEN DO:
    OUTPUT TO VALUE(v_nom_disposit_so) PAGE-SIZE 0 CONVERT TARGET SESSION:CHARSET.
END.
ELSE DO:
    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 17006,
                       INPUT "Impressora inv†lida!":U).
    RETURN "NOK":U.
END.

PUT "^XA"    SKIP.   /* Inicio Label */
PUT "^PW832" SKIP.   /* Width 832 */
PUT "^MNY"   SKIP.   /* Papel de etiquetas n∆o continuo */
PUT "^MTT"   SKIP.   /* Papel Comum - usa ribon */
PUT "^BY2"   SKIP.   /* Magnitude EAN */ 
PUT "^PRA"   SKIP.   /* Velocidade 50mm/seg */
PUT "^JUS"   SKIP.   /* Grava Configuracao */
PUT "^PON"   SKIP.
PUT "^FWN"   SKIP.
PUT "^LL296" SKIP.
PUT "^XZ"    SKIP.

ASSIGN iColuna = 1
       c-mac   = "".

FOR EACH tt-mac-address USE-INDEX ch-pri
    WHERE tt-mac-address.impresso = YES:

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-acompanhar IN h-acomp (INPUT "MAC: ":U + tt-mac-address.mac).
    
    IF rs-formata:SCREEN-VALUE IN FRAME fPage0 = "1" THEN DO:        
        IF iColuna = 1 THEN DO:
            PUT "^XA" SKIP.
            ASSIGN c-mac =  SUBSTRING (tt-mac-address.mac,1,2) + "?" +
                            SUBSTRING (tt-mac-address.mac,3,2) + "?" +
                            SUBSTRING (tt-mac-address.mac,5,2) + "?" +
                            SUBSTRING (tt-mac-address.mac,7,2) + "?" +
                            SUBSTRING (tt-mac-address.mac,9,2) + "?" +
                            SUBSTRING (tt-mac-address.mac,11,2).

            PUT UNFORMATTED "^FO40,3^BY1,2.0,10 ^BCN,50,N,N,N,N^FD" c-mac "^FS" SKIP.
            PUT UNFORMATTED "^FO50,57^ADN^FD"
                SUBSTRING (tt-mac-address.mac,1,2) + ":" +              
                SUBSTRING (tt-mac-address.mac,3,2) + ":" +             
                SUBSTRING (tt-mac-address.mac,5,2) + ":" +             
                SUBSTRING (tt-mac-address.mac,7,2) + ":" +             
                SUBSTRING (tt-mac-address.mac,9,2) + ":" +             
                SUBSTRING (tt-mac-address.mac,11,2) "^FS" SKIP. 
        
            ASSIGN iColuna = 2.
        END.

        ELSE DO:
            ASSIGN c-mac =  SUBSTRING (tt-mac-address.mac,1,2) + "?" +
                            SUBSTRING (tt-mac-address.mac,3,2) + "?" +
                            SUBSTRING (tt-mac-address.mac,5,2) + "?" +
                            SUBSTRING (tt-mac-address.mac,7,2) + "?" +
                            SUBSTRING (tt-mac-address.mac,9,2) + "?" +
                            SUBSTRING (tt-mac-address.mac,11,2).

            PUT UNFORMATTED "^FO340,3^BY1,2.0,10 ^BCN,50,N,N,N^FD" c-mac "^FS" SKIP. 
            PUT UNFORMATTED "^FO350,57^ADN^FD"
                 SUBSTRING (tt-mac-address.mac,1,2) + ":" +            
                 SUBSTRING (tt-mac-address.mac,3,2) + ":" +            
                 SUBSTRING (tt-mac-address.mac,5,2) + ":" +            
                 SUBSTRING (tt-mac-address.mac,7,2) + ":" +            
                 SUBSTRING (tt-mac-address.mac,9,2) + ":" +            
                 SUBSTRING (tt-mac-address.mac,11,2) "^FS" SKIP.
            PUT "^XZ" SKIP.
               
            ASSIGN iColuna = 1.
        END.
    END.
    ELSE DO:
        IF iColuna = 1 THEN DO:
            PUT "^XA" SKIP.
            PUT UNFORMATTED "^FO63,3^BY1,2.0,10 ^BCN,50,N,N,N,N^FD"  tt-mac-address.mac  "^FS" SKIP.
            PUT UNFORMATTED "^FO50,57^ADN^FDMAC:" tt-mac-address.mac "^FS" SKIP.

            ASSIGN iColuna = 2.
        END.
        ELSE DO:
            PUT UNFORMATTED "^FO363,3^BY1,2.0,10 ^BCN,50,N,N,N^FD" tt-mac-address.mac "^FS" SKIP.
            PUT UNFORMATTED "^FO350,57^ADN^FDMAC:" tt-mac-address.mac "^FS" SKIP.
            PUT "^XZ" SKIP.
               
            ASSIGN iColuna = 1.
        END.
    END.
END.

IF iColuna = 2 THEN
    PUT "^XZ" SKIP.

OUTPUT CLOSE.

RETURN "OK":U.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMac wWindow 
PROCEDURE piMac :
/*------------------------------------------------------------------------------
  Purpose: Gerar o codigo mac em arquivo txt.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE arquivo AS CHARACTER NO-UNDO.

ASSIGN arquivo = SESSION:TEMP-DIRECTORY + "MacAddress-" + STRING(TIME) + ".txt".

OUTPUT TO VALUE(arquivo).

FOR EACH tt-mac-address
    WHERE tt-mac-address.impresso = YES:

    IF rs-formata:SCREEN-VALUE IN FRAME fPage0 = "1" THEN
        PUT UNFORMAT SUBSTRING (tt-mac-address.mac,1,2)  + ":" +  
                     SUBSTRING (tt-mac-address.mac,3,2)  + ":" +  
                     SUBSTRING (tt-mac-address.mac,5,2)  + ":" + 
                     SUBSTRING (tt-mac-address.mac,7,2)  + ":" +  
                     SUBSTRING (tt-mac-address.mac,9,2)  + ":" +  
                     SUBSTRING (tt-mac-address.mac,11,2) + ";" SKIP.
    ELSE
        PUT UNFORMAT tt-mac-address.mac + ";" SKIP.

END. 

OUTPUT CLOSE.

OS-COMMAND NO-WAIT notepad VALUE(arquivo).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPlanilhaFiberHome wWindow 
PROCEDURE piPlanilhaFiberHome :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO. 
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO. 
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.

    DEFINE VARIABLE i-cont  AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-col   AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-aux   AS INTEGER NO-UNDO.
    DEFINE VARIABLE h-acomp AS HANDLE  NO-UNDO.
    DEFINE VARIABLE h-prog  AS HANDLE  NO-UNDO.

    DEFINE VARIABLE c-diretorio   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-arquivo     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-arquivo-aux AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE c-nome-wifi   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-senha-wifi  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-senha-admin AS CHARACTER NO-UNDO.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Gerando planilha excel...":U).

    
    /* Cria a Nova Aplicacao Excel object */ 
    CREATE "Excel.Application" chExcelApplication. 

    /* Cria o arquivo */ 
    chWorkbook = chExcelApplication:Workbooks:ADD(search('esp/layout/Fiber Home.xlsx')).

    chexcelapplication:worksheets:ITEM(1):SELECT.
    chWorkSheet = chExcelApplication:Sheets:ITEM(1).

    ASSIGN i-cont = 2.

    /* Diretorio para a gravaá∆o dos arquivos */
    RUN esp/es0018p.p (INPUT "escpp060":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FIND FIRST tt-prog-ponto NO-ERROR.

    IF AVAIL tt-prog-ponto THEN
       ASSIGN c-diretorio = tt-prog-ponto.conteudo.

    RUN esp/es0018p.p (INPUT "escpp060":U,
                       INPUT 2,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).
   
    
    FOR EACH tt-lista-ns,
        FIRST num-serie WHERE num-serie.n-serie = tt-lista-ns.num-serie NO-LOCK,
        FIRST item-ean WHERE item-ean.it-codigo = ttitem.it-codigo NO-LOCK:
        
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "NS: ":U + num-serie.n-serie).

        //chexcelapplication:Range('B' + string(i-cont)):NumberFormat = '@'

        ASSIGN chexcelapplication:Range('A' + string(i-cont)):VALUE = num-serie.cod-estabel
               chexcelapplication:Range('B' + string(i-cont)):VALUE = 'INTELBRAS'
               chexcelapplication:Range('C' + string(i-cont)):VALUE = item-ean.nome-abrev.

        ASSIGN i-aux = 0.
                
        FOR EACH mac-address USE-INDEX num-serie
            WHERE mac-address.n-serie = num-serie.n-serie NO-LOCK
            BREAK BY mac-address.mac:

            ASSIGN i-aux = i-aux + 1.
       
            IF FIRST(mac-address.mac) THEN DO:

               ASSIGN c-nome-wifi   = CAPS(TRIM(item-ean.texto[5])) + '_' + LOWER(SUBSTRING(mac-address.mac,9,4))
                      c-senha-wifi  = mac-address.char-1
                      c-senha-admin = mac-address.char-2
                      chexcelapplication:Range('D' + string(i-cont)):NumberFormat = '@'
                      chexcelapplication:Range('D' + string(i-cont)):VALUE = mac-address.mac.

               /* Consome GPON FiberHome */
               RUN esapi/esapi041.p (INPUT 1, /* Qtde MACs utilizados */
                                     INPUT ttitem.it-codigo,
                                     OUTPUT TABLE tt-mac-address-fiber).
          
               FOR EACH tt-mac-address-fiber
                   BREAK BY tt-mac-address-fiber.mac:
                   IF FIRST(tt-mac-address-fiber.mac) THEN DO:
                       ASSIGN chexcelapplication:Range('R' + string(i-cont)):NumberFormat = '@'
                              chexcelapplication:Range('R' + string(i-cont)):VALUE = tt-mac-address-fiber.mac. 
        
                       ASSIGN chexcelapplication:Range('S' + string(i-cont)):NumberFormat = '@'
                              chexcelapplication:Range('S' + string(i-cont)):VALUE = tt-mac-address-fiber.mac. 
        
                       ASSIGN chexcelapplication:Range('T' + string(i-cont)):NumberFormat = '@'
                              chexcelapplication:Range('T' + string(i-cont)):VALUE = tt-mac-address-fiber.mac. 
                   END.
               END.

               ASSIGN chexcelapplication:Range('K' + string(i-cont)):VALUE = c-nome-wifi
                      chexcelapplication:Range('L' + string(i-cont)):VALUE = c-senha-wifi /* Senha WIFI */
                      chexcelapplication:Range('W' + string(i-cont)):VALUE = c-nome-wifi  + '_5G'
                      chexcelapplication:Range('X' + string(i-cont)):VALUE = c-senha-wifi. 

               chexcelapplication:Range('AP' + string(i-cont)):VALUE = mac-address.char-2. /* Senha Admin */
                    
            END.

            IF LAST(mac-address.mac) THEN
               ASSIGN chexcelapplication:Range('E' + string(i-cont)):VALUE = STRING(i-aux) 
                      chexcelapplication:Range('F' + string(i-cont)):NumberFormat = '@'
                      chexcelapplication:Range('F' + string(i-cont)):VALUE = mac-address.mac.

            FOR EACH tt-mac-address-fiber:
                FIND FIRST b01-mac-address 
                     WHERE b01-mac-address.mac = mac-address.mac     
                EXCLUSIVE-LOCK NO-ERROR.

                IF AVAIL b01-mac-address THEN DO:
                   ASSIGN b01-mac-address.motiv-re = tt-mac-address-fiber.mac. /* grava GPON FiberHome */ 

                   RELEASE b01-mac-address.
                END.
            END.    
        END.

        FOR EACH tt-prog-ponto:
            IF ENTRY(1,tt-prog-ponto.conteudo,';') = item-ean.nome-abrev THEN 
               ASSIGN chexcelapplication:Range('J' + string(i-cont)):VALUE = ENTRY(2,tt-prog-ponto.conteudo,';').
        END.
     
        /*
        IF INDEX(item-ean.nome-abrev,'HG6145F3') <> 0 THEN
           ASSIGN chexcelapplication:Range('J' + string(i-cont)):VALUE = '2094373-A01BR12'.
        ELSE
           ASSIGN chexcelapplication:Range('J' + string(i-cont)):VALUE = '2094443-A02BR12'.
        */   
       
        ASSIGN chexcelapplication:Range('M' + string(i-cont)):VALUE = TRIM(REPLACE(item-ean.texto[6],'IP Gerància:','')) /* IP Gerencia */

               chexcelapplication:Range('N' + string(i-cont)):VALUE = 'user'     /*item-ean.texto[7] */ /* Admin */
               chexcelapplication:Range('O' + string(i-cont)):VALUE = 'user1234' /*mac-address.char-2*/ /* Senha Admin */
               chexcelapplication:Range('P' + string(i-cont)):VALUE = item-ean.info-tec[1] //'12V'
               chexcelapplication:Range('Q' + string(i-cont)):VALUE = item-ean.info-tec[2].

        ASSIGN chexcelapplication:Range('Y' + string(i-cont)):VALUE = num-serie.it-codigo.
       
        ASSIGN chexcelapplication:Range('Z' + string(i-cont)):VALUE  = '00000'
               chexcelapplication:Range('AA' + string(i-cont)):VALUE = 'GPON ONU'.
        
        /*
        IF INDEX(item-ean.nome-abrev,'HG6145F3') <> 0 THEN
           ASSIGN chexcelapplication:Range('AB' + string(i-cont)):VALUE = 'WKE2.094.476A01'.
        ELSE 
           ASSIGN chexcelapplication:Range('AB' + string(i-cont)):VALUE = 'WKE2.094.443A01'.
        */

       FOR EACH tt-prog-ponto:
           IF ENTRY(1,tt-prog-ponto.conteudo,';') = item-ean.nome-abrev THEN 
              ASSIGN chexcelapplication:Range('AB' + string(i-cont)):VALUE = ENTRY(3,tt-prog-ponto.conteudo,';').
       END.

       ASSIGN chexcelapplication:Range('AN' + string(i-cont)):NumberFormat = '@'
              chexcelapplication:Range('AN' + string(i-cont)):VALUE = num-serie.n-serie
              
              chexcelapplication:Range('AO' + string(i-cont)):VALUE = 'admin'.

        ASSIGN i-cont = i-cont + 1.
    END.

    chexcelapplication:Cells:SELECT.
    chexcelapplication:Cells:EntireColumn:AutoFit.
    
    chexcelapplication:VISIBLE = NO.

    ASSIGN c-arquivo = STRING(YEAR(TODAY),'9999') + STRING(MONTH(TODAY),'99') + STRING(DAY(TODAY),'99') + REPLACE(STRING(TIME,'HH:MM:SS'),':','').
           c-arquivo-aux = c-arquivo.

    FIND FIRST usuar_mestre 
         WHERE usuar_mestre.cod_usuario =  v_cod_usuar_corren   
    NO-LOCK NO-ERROR.
    
    ASSIGN FILE-INFO:FILE-NAME = usuar_mestre.nom_dir_spool + '\' + v_cod_usuar_corren.

    IF FILE-INFO:FULL-PATHNAME <> ? THEN 
       ASSIGN c-arquivo = FILE-INFO:FULL-PATHNAME + '\' + c-arquivo + ".xlsx" .
    ELSE 
       ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + c-arquivo + ".xlsx". 

    ASSIGN c-arquivo = REPLACE(c-arquivo,"/","\").

    ASSIGN c-arquivo-aux = /*'\\erpapp\spool\is055792\'*/ c-diretorio + c-arquivo-aux + ".xlsx".

    chexcelapplication:Workbooks:Item(1):SaveAs(c-arquivo-aux,"51",,,,,).

    RELEASE OBJECT chExcelApplication.
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

    ASSIGN  chExcelApplication = ?     
            chWorkbook         = ?     
            chWorksheet        = ?.              
        
    IF VALID-HANDLE(h-acomp) THEN
       DELETE PROCEDURE h-acomp.

    OS-COPY VALUE(c-arquivo-aux) VALUE(c-arquivo).

    IF SEARCH(c-arquivo) <> ? THEN DO:
       MESSAGE 'Arquivo FiberHome gerado com Sucesso !' SKIP(1)
               'CAMINHO: ' c-arquivo
           VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.

    IF NOT VALID-HANDLE(h-prog) THEN
       RUN utp/ut-utils.p PERSISTENT SET h-prog.

    IF VALID-HANDLE(h-prog) THEN
       RUN execute IN h-prog(INPUT c-arquivo,
                             INPUT "":U).

    IF VALID-HANDLE(h-prog) THEN
       DELETE PROCEDURE h-prog.

    

    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPreMac wWindow 
PROCEDURE piPreMac :
/*------------------------------------------------------------------------------
  Purpose:    Transferido rotina de premac para api esapi023.p  
  Notes:      Carlos Daniel - 22/09/2015
------------------------------------------------------------------------------*/
EMPTY TEMP-TABLE tt-mac-address.
EMPTY TEMP-TABLE tt-erro.
EMPTY TEMP-TABLE ttItem.

CREATE ttItem.
ASSIGN ttItem.it-codigo = fiItCodigo:SCREEN-VALUE IN FRAME fPage0
       ttitem.marcado   = YES
       ttItem.qt-pedido = INTEGER(fiQtdEtiqueta:SCREEN-VALUE).

IF NOT VALID-HANDLE(h-api023) THEN
    RUN esapi/esapi023.p PERSISTENT SET h-api023.

RUN piPreMac IN h-api023 (INPUT TABLE ttItem,
                          OUTPUT TABLE tt-mac-address,
                          OUTPUT TABLE tt-erro).

IF RETURN-VALUE NE 'OK' THEN DO:
    RUN cdp/cd0666.w( INPUT TABLE tt-erro).
    RETURN "NOK".
END.

RETURN "OK".

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
    DEFINE INPUT  PARAMETER pItCodigo    LIKE item.it-codigo NO-UNDO.
    DEFINE INPUT  PARAMETER pQtdEtiqueta AS INTEGER          NO-UNDO.
    DEFINE INPUT  PARAMETER pPrinter     AS CHARACTER        NO-UNDO.

    FIND FIRST item
        WHERE item.it-codigo = pItCodigo NO-LOCK NO-ERROR.

    IF NOT AVAILABLE item THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 2,
                           INPUT "Item":U).

        RETURN "NOK":U.
    END.
    ELSE DO:
        FIND FIRST item-ean
            WHERE item-ean.it-codigo = item.it-codigo NO-LOCK NO-ERROR.

        IF NOT AVAILABLE item-ean OR item-ean.qtd-mac <= 0  THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "N∆o foi poss°vel gerar Mac Address.~~" +
                                     "O item " + item.it-codigo + " n∆o utiliza Mac Address. Caso necess†rio, solicitar a parametrizaá∆o para o departamento de Engenharia Industrial.":U).

            RETURN "NOK":U.
        END.
    END.

    IF fiQtdEtiqueta <= 0 THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Quantidade de Etiquetas deve ser informada.":U).

        RETURN "NOK":U.
    END.

   
    IF rsDestiny:SCREEN-VALUE IN FRAME fpage0 = "1"  THEN DO:

    
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
                WHERE  layout_impres.nom_impressora    = cPrinter
                  AND  layout_impres.cod_layout_impres = cLayout NO-LOCK NO-ERROR.
    
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
    END.
    

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION conv-dec-to-hex wWindow 
FUNCTION conv-dec-to-hex RETURNS CHARACTER
  ( INPUT p-num-decimal AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-simbolos        AS CHARACTER   NO-UNDO
        FORMAT "x(1)":U
        EXTENT 16
        INITIAL ["0":U, "1":U, "2":U, "3":U, "4":U, "5":U, "6":U, "7":U, "8":U, "9":U, "A":U, "B":U, "C":U, "D":U, "E":U, "F":U].

    DEFINE VARIABLE c-val-hexadecimal AS CHARACTER   NO-UNDO INITIAL "":U.

    DEFINE VARIABLE i-quociente       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-resto           AS INTEGER     NO-UNDO INITIAL 0.

    ASSIGN i-quociente = p-num-decimal.

    REPEAT:
        ASSIGN i-resto           = i-quociente MODULO 16
               i-quociente       = TRUNCATE((i-quociente / 16), 0)
               c-val-hexadecimal = c-simbolos[(i-resto + 1)] + c-val-hexadecimal.

        IF i-quociente <= 0 THEN
            LEAVE.
    END.

    IF LENGTH(c-val-hexadecimal) < 6 THEN DO:

        ASSIGN c-val-hexadecimal = FILL("0", 6 - LENGTH(c-val-hexadecimal)) + c-val-hexadecimal.

    END.

    RETURN c-val-hexadecimal. /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION conv-hex-to-dec wWindow 
FUNCTION conv-hex-to-dec RETURNS INTEGER
  ( INPUT p-val-hexadecimal AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-cont        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-valor       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-num-decimal AS INTEGER     NO-UNDO.

    DO i-cont = 1 TO LENGTH(p-val-hexadecimal):
        CASE SUBSTRING(p-val-hexadecimal, i-cont, 1):
            WHEN "A":U THEN
                ASSIGN i-valor = 10.
            WHEN "B":U THEN
                ASSIGN i-valor = 11.
            WHEN "C":U THEN
                ASSIGN i-valor = 12.
            WHEN "D":U THEN
                ASSIGN i-valor = 13.
            WHEN "E":U THEN
                ASSIGN i-valor = 14.
            WHEN "F":U THEN
                ASSIGN i-valor = 15.
            OTHERWISE DO:
                ASSIGN i-valor = INTEGER(SUBSTRING(p-val-hexadecimal, i-cont, 1)) NO-ERROR.

                IF ERROR-STATUS:ERROR THEN
                    RETURN 0. /* Function return value. */
            END.
        END CASE.

        ASSIGN i-num-decimal = i-num-decimal + (i-valor * fator(LENGTH(p-val-hexadecimal) - i-cont)).
    END.

    RETURN i-num-decimal. /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fator wWindow 
FUNCTION fator RETURNS INTEGER
  ( INPUT p-fator AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-cont  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-valor AS INTEGER     NO-UNDO.

    ASSIGN i-valor = 1.

    IF p-fator > 0 THEN DO:
        DO i-cont = 1 TO p-fator:
            ASSIGN i-valor = i-valor * 16.
        END.
    END.

    RETURN i-valor. /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
        WHEN 9           THEN RETURN "QR CODE com senha ADMIN + Senha WIFI".
    END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

