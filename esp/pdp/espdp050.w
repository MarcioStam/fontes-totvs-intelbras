&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
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
{include/i-prgvrs.i espdp050 1.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        espdp050
&GLOBAL-DEFINE Version        1.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         no
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define new global shared variable adm-broker-hdl as handle       no-undo.
define variable wh-pesquisa as handle       no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-b2c.cod-depos ~
param-b2c.cod-depos-saldao param-b2c.cod-gr-cli param-b2c.cod-moeda-b2c ~
param-b2c.cod-transp-sedex param-b2c.cond-pagto-cred ~
param-b2c.cond-pagto-deb param-b2c.cond-pagto-bol ~
param-b2c.cond-pagto-cre-par param-b2c.cond-pagto-bol-par ~
param-b2c.remetente param-b2c.url-webservices 
&Scoped-define ENABLED-TABLES param-b2c
&Scoped-define FIRST-ENABLED-TABLE param-b2c
&Scoped-Define ENABLED-OBJECTS rtToolBar fiDesc-depos fiDesc-depos-saldao ~
fiGr-cliente fiMo-desc fiDesc-transp fiDescPagCred fiDescPagDeb ~
fiDescPagBol fiDescPagCreEsp fiDescPagBolPar c-email btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-FIELDS param-b2c.cod-depos ~
param-b2c.cod-depos-saldao param-b2c.cod-gr-cli param-b2c.cod-moeda-b2c ~
param-b2c.cod-transp-sedex param-b2c.cond-pagto-cred ~
param-b2c.cond-pagto-deb param-b2c.cond-pagto-bol ~
param-b2c.cond-pagto-cre-par param-b2c.cond-pagto-bol-par ~
param-b2c.remetente param-b2c.url-webservices 
&Scoped-define DISPLAYED-TABLES param-b2c
&Scoped-define FIRST-DISPLAYED-TABLE param-b2c
&Scoped-Define DISPLAYED-OBJECTS fiDesc-depos fiDesc-depos-saldao ~
fiGr-cliente fiMo-desc fiDesc-transp fiDescPagCred fiDescPagDeb ~
fiDescPagBol fiDescPagCreEsp fiDescPagBolPar c-email 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-email AS CHARACTER FORMAT "X(256)":U 
     LABEL "E-mail Log B2C" 
     VIEW-AS FILL-IN 
     SIZE 57.43 BY .79 NO-UNDO.

DEFINE VARIABLE fiDesc-depos AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39.43 BY .88 NO-UNDO.

DEFINE VARIABLE fiDesc-depos-saldao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39.43 BY .88 NO-UNDO.

DEFINE VARIABLE fiDesc-transp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38.29 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescPagBol AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.72 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescPagBolPar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.72 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescPagCred AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.72 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescPagCreEsp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.72 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescPagDeb AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.72 BY .88 NO-UNDO.

DEFINE VARIABLE fiGr-cliente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE fiMo-desc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.72 BY .88 NO-UNDO.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fiDesc-depos AT ROW 1.67 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     param-b2c.cod-depos AT ROW 1.75 COL 23 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     param-b2c.cod-depos-saldao AT ROW 2.75 COL 23 COLON-ALIGNED WIDGET-ID 52
          VIEW-AS FILL-IN 
          SIZE 7 BY .79
     fiDesc-depos-saldao AT ROW 2.75 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 50
     param-b2c.cod-gr-cli AT ROW 3.75 COL 23 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     fiGr-cliente AT ROW 3.75 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     param-b2c.cod-moeda-b2c AT ROW 5 COL 23 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     fiMo-desc AT ROW 5 COL 29.29 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     param-b2c.cod-transp-sedex AT ROW 6.17 COL 23 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     fiDesc-transp AT ROW 6.17 COL 30.43 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     param-b2c.cond-pagto-cred AT ROW 7.33 COL 23 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     fiDescPagCred AT ROW 7.33 COL 29.29 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     param-b2c.cond-pagto-deb AT ROW 8.5 COL 23 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     fiDescPagDeb AT ROW 8.5 COL 29.29 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     param-b2c.cond-pagto-bol AT ROW 9.67 COL 23 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     fiDescPagBol AT ROW 9.67 COL 29.29 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     param-b2c.cond-pagto-cre-par AT ROW 10.75 COL 23 COLON-ALIGNED WIDGET-ID 40
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .79
     fiDescPagCreEsp AT ROW 10.75 COL 29.43 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     param-b2c.cond-pagto-bol-par AT ROW 11.75 COL 23 COLON-ALIGNED WIDGET-ID 44
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .79
     fiDescPagBolPar AT ROW 11.75 COL 29.43 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     c-email AT ROW 12.75 COL 23 COLON-ALIGNED WIDGET-ID 48
     param-b2c.remetente AT ROW 13.75 COL 23 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 42.29 BY .88
     param-b2c.url-webservices AT ROW 14.75 COL 23 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 44 BY .88
     btOK AT ROW 17.25 COL 2
     btCancel AT ROW 17.25 COL 13
     btHelp2 AT ROW 17.25 COL 80
     rtToolBar AT ROW 17 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.63
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17.63
         WIDTH              = 90
         MAX-HEIGHT         = 17.63
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17.63
         VIRTUAL-WIDTH      = 90
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
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
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
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    
    run saveRecord in this-procedure.
    if return-value = 'NOK' then do:
        {method/showmessage.i1}
        {method/showmessage.i2 &modal="yes"}
        {method/showmessage.i3}

        return no-apply.
    end.
    else
        apply "CLOSE":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-b2c.cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-b2c.cod-depos wWindow
ON F5 OF param-b2c.cod-depos IN FRAME fpage0 /* Deposito */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in084.w"
                                   &campo="param-b2c.cod-depos"
                                   &campozoom="cod-depos"
                                   &frame="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-b2c.cod-depos wWindow
ON LEAVE OF param-b2c.cod-depos IN FRAME fpage0 /* Deposito */
DO:
    find deposito no-lock where deposito.cod-depos = input frame fPage0 param-b2c.cod-depos no-error.
    assign fiDesc-depos = if available deposito then deposito.nome else ''.

    display fiDesc-depos with frame fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-b2c.cod-depos wWindow
ON MOUSE-SELECT-DBLCLICK OF param-b2c.cod-depos IN FRAME fpage0 /* Deposito */
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-b2c.cod-depos-saldao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-b2c.cod-depos-saldao wWindow
ON F5 OF param-b2c.cod-depos-saldao IN FRAME fpage0 /* Deposito SaldÆo */
DO:
      {include/zoomvar.i &prog-zoom="inzoom/z01in084.w"
                                   &campo="param-b2c.cod-depos-saldao"
                                   &campozoom="cod-depos"
                                   &frame="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-b2c.cod-depos-saldao wWindow
ON LEAVE OF param-b2c.cod-depos-saldao IN FRAME fpage0 /* Deposito SaldÆo */
DO:
  DO:
    find deposito no-lock where deposito.cod-depos = input frame fPage0 param-b2c.cod-depos-saldao no-error.
    assign fiDesc-depos-saldao = if available deposito then deposito.nome else ''.

    display fiDesc-depos-saldao with frame fpage0.
END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-b2c.cod-depos-saldao wWindow
ON MOUSE-SELECT-DBLCLICK OF param-b2c.cod-depos-saldao IN FRAME fpage0 /* Deposito SaldÆo */
DO:
  APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-b2c.cod-gr-cli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-b2c.cod-gr-cli wWindow
ON F5 OF param-b2c.cod-gr-cli IN FRAME fpage0 /* Grupo de Cliente no EMS */
DO:
    {method/ZoomFields.i &ProgramZoom="adzoom/z02ad129.w"
                         &FieldZoom1="cod-gr-cli"
                         &FieldScreen1="param-b2c.cod-gr-cli"
                         &Frame1="fPage0"
                         &EnableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-b2c.cod-gr-cli wWindow
ON LEAVE OF param-b2c.cod-gr-cli IN FRAME fpage0 /* Grupo de Cliente no EMS */
DO:
    find gr-cli no-lock where gr-cli.cod-gr-cli = input frame fPage0 param-b2c.cod-gr-cli no-error.
    assign fiGr-cliente = if available gr-cli then gr-cli.descricao else ''.

    display fiGr-cliente with frame fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-b2c.cod-gr-cli wWindow
ON MOUSE-SELECT-DBLCLICK OF param-b2c.cod-gr-cli IN FRAME fpage0 /* Grupo de Cliente no EMS */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-b2c.cod-moeda-b2c
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-b2c.cod-moeda-b2c wWindow
ON F5 OF param-b2c.cod-moeda-b2c IN FRAME fpage0 /* Moeda B2C */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad178.w"
                                   &campo="param-b2c.cod-moeda-b2c"
                                   &campozoom="mo-codigo"
                                   &frame="fPage0"}
/*    {method/ZoomFields.i &ProgramZoom="adzoom/z01ad178.w"
                         &FieldZoom1="mo-codigo"
                         &FieldScreen1="param-b2c.cod-moeda-b2c"
                         &Frame1="fPage0"
                         &EnableImplant="no"}*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-b2c.cod-moeda-b2c wWindow
ON LEAVE OF param-b2c.cod-moeda-b2c IN FRAME fpage0 /* Moeda B2C */
DO:
    find moeda no-lock where moeda.mo-codigo = input frame fPage0 param-b2c.cod-moeda-b2c no-error.
    assign fiMo-desc = if available moeda then moeda.descricao else ''.

    display fimo-desc with frame fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-b2c.cod-moeda-b2c wWindow
ON MOUSE-SELECT-DBLCLICK OF param-b2c.cod-moeda-b2c IN FRAME fpage0 /* Moeda B2C */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-b2c.cod-transp-sedex
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-b2c.cod-transp-sedex wWindow
ON F5 OF param-b2c.cod-transp-sedex IN FRAME fpage0 /* Transportador SEDEX */
DO:
    {method/ZoomFields.i &ProgramZoom="adzoom/z10ad268.w"
                         &FieldZoom1="cod-transp"
                         &FieldScreen1="param-b2c.cod-transp-sedex"
                         &Frame1="fPage0"
                         &EnableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-b2c.cod-transp-sedex wWindow
ON LEAVE OF param-b2c.cod-transp-sedex IN FRAME fpage0 /* Transportador SEDEX */
DO:
    find transporte no-lock where transporte.cod-transp = input frame fPage0 param-b2c.cod-transp-sedex no-error.
    assign fiDesc-transp = if available transporte then transporte.nome else ''.

    display fiDesc-transp with frame fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-b2c.cod-transp-sedex wWindow
ON MOUSE-SELECT-DBLCLICK OF param-b2c.cod-transp-sedex IN FRAME fpage0 /* Transportador SEDEX */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-b2c.cond-pagto-bol
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-b2c.cond-pagto-bol wWindow
ON F5 OF param-b2c.cond-pagto-bol IN FRAME fpage0 /* Cond Pagto Boleto */
DO:
    {method/ZoomFields.i &ProgramZoom="adzoom/z10ad039.w"
                         &FieldZoom1="cod-cond-pag"
                         &FieldScreen1="param-b2c.cond-pagto-bol"
                         &Frame1="fPage0"
                         &EnableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-b2c.cond-pagto-bol wWindow
ON LEAVE OF param-b2c.cond-pagto-bol IN FRAME fpage0 /* Cond Pagto Boleto */
DO:
    find cond-pagto no-lock where cond-pagto.cod-cond-pag = input frame fPage0 param-b2c.cond-pagto-bol no-error.
    assign fiDescPagbol = if available cond-pagto then cond-pagto.descricao else ''.

    display fiDescPagbol with frame fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-b2c.cond-pagto-bol wWindow
ON MOUSE-SELECT-DBLCLICK OF param-b2c.cond-pagto-bol IN FRAME fpage0 /* Cond Pagto Boleto */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-b2c.cond-pagto-bol-par
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-b2c.cond-pagto-bol-par wWindow
ON F5 OF param-b2c.cond-pagto-bol-par IN FRAME fpage0 /* Cond Pagto Boleto Par */
DO:
    {method/ZoomFields.i &ProgramZoom="adzoom/z10ad039.w"
                         &FieldZoom1="cod-cond-pag"
                         &FieldScreen1="param-b2c.cond-pagto-bol-par"
                         &Frame1="fPage0"
                         &EnableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-b2c.cond-pagto-bol-par wWindow
ON LEAVE OF param-b2c.cond-pagto-bol-par IN FRAME fpage0 /* Cond Pagto Boleto Par */
DO:
    find cond-pagto no-lock where cond-pagto.cod-cond-pag = input frame fPage0 param-b2c.cond-pagto-bol-par no-error.
    assign fiDescPagbolPar = if available cond-pagto then cond-pagto.descricao else ''.

    display fiDescPagbolPar with frame fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-b2c.cond-pagto-bol-par wWindow
ON MOUSE-SELECT-DBLCLICK OF param-b2c.cond-pagto-bol-par IN FRAME fpage0 /* Cond Pagto Boleto Par */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-b2c.cond-pagto-cre-par
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-b2c.cond-pagto-cre-par wWindow
ON F5 OF param-b2c.cond-pagto-cre-par IN FRAME fpage0 /* Cond Pagto Credito Especial */
DO:
    {method/ZoomFields.i &ProgramZoom="adzoom/z10ad039.w"
                         &FieldZoom1="cod-cond-pag"
                         &FieldScreen1="param-b2c.cond-pagto-cre-par"
                         &Frame1="fPage0"
                         &EnableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-b2c.cond-pagto-cre-par wWindow
ON LEAVE OF param-b2c.cond-pagto-cre-par IN FRAME fpage0 /* Cond Pagto Credito Especial */
DO:
    find cond-pagto no-lock where cond-pagto.cod-cond-pag = input frame fPage0 param-b2c.cond-pagto-cre-par no-error.
    assign fiDescPagCreEsp = if available cond-pagto then cond-pagto.descricao else ''.

    display fiDescPagcreEsp with frame fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-b2c.cond-pagto-cre-par wWindow
ON MOUSE-SELECT-DBLCLICK OF param-b2c.cond-pagto-cre-par IN FRAME fpage0 /* Cond Pagto Credito Especial */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-b2c.cond-pagto-cred
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-b2c.cond-pagto-cred wWindow
ON F5 OF param-b2c.cond-pagto-cred IN FRAME fpage0 /* Cond Pagto Cr‚dito */
DO:
    {method/ZoomFields.i &ProgramZoom="adzoom/z10ad039.w"
                         &FieldZoom1="cod-cond-pag"
                         &FieldScreen1="param-b2c.cond-pagto-cred"
                         &Frame1="fPage0"
                         &EnableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-b2c.cond-pagto-cred wWindow
ON LEAVE OF param-b2c.cond-pagto-cred IN FRAME fpage0 /* Cond Pagto Cr‚dito */
DO:
    find cond-pagto no-lock where cond-pagto.cod-cond-pag = input frame fPage0 param-b2c.cond-pagto-cred no-error.
    assign fiDescPagCred = if available cond-pagto then cond-pagto.descricao else ''.

    display fiDescPagCred with frame fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-b2c.cond-pagto-cred wWindow
ON MOUSE-SELECT-DBLCLICK OF param-b2c.cond-pagto-cred IN FRAME fpage0 /* Cond Pagto Cr‚dito */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-b2c.cond-pagto-deb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-b2c.cond-pagto-deb wWindow
ON F5 OF param-b2c.cond-pagto-deb IN FRAME fpage0 /* Cond Pagto D‚bito */
DO:
    {method/ZoomFields.i &ProgramZoom="adzoom/z10ad039.w"
                         &FieldZoom1="cod-cond-pag"
                         &FieldScreen1="param-b2c.cond-pagto-deb"
                         &Frame1="fPage0"
                         &EnableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-b2c.cond-pagto-deb wWindow
ON LEAVE OF param-b2c.cond-pagto-deb IN FRAME fpage0 /* Cond Pagto D‚bito */
DO:
    find cond-pagto no-lock where cond-pagto.cod-cond-pag = input frame fPage0 param-b2c.cond-pagto-deb no-error.
    assign fiDescPagdeb = if available cond-pagto then cond-pagto.descricao else ''.

    display fiDescPagdeb with frame fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-b2c.cond-pagto-deb wWindow
ON MOUSE-SELECT-DBLCLICK OF param-b2c.cond-pagto-deb IN FRAME fpage0 /* Cond Pagto D‚bito */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
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

    param-b2c.cod-depos:load-mouse-pointer('image/lupa.cur') in frame fPage0.
    param-b2c.cod-depos-saldao:load-mouse-pointer('image/lupa.cur') in frame fPage0.
    param-b2c.cod-gr-cli:load-mouse-pointer('image/lupa.cur') in frame fPage0.
    param-b2c.cod-moeda-b2c:load-mouse-pointer('image/lupa.cur') in frame fPage0.
    param-b2c.cod-transp-sedex:load-mouse-pointer('image/lupa.cur') in frame fPage0.
    param-b2c.cond-pagto-bol:load-mouse-pointer('image/lupa.cur') in frame fPage0.
    param-b2c.cond-pagto-cred:load-mouse-pointer('image/lupa.cur') in frame fPage0.
    param-b2c.cond-pagto-deb:load-mouse-pointer('image/lupa.cur') in frame fPage0.
    param-b2c.cond-pagto-cre-par:load-mouse-pointer('image/lupa.cur') in frame fPage0.
    param-b2c.cond-pagto-bol-par:load-mouse-pointer('image/lupa.cur') in frame fPage0.
    
    param-b2c.remetente:load-mouse-pointer('image/lupa.cur') in frame fPage0.
    param-b2c.url-webservices:load-mouse-pointer('image/lupa.cur') in frame fPage0.
    ASSIGN c-email = param-b2c.e-mail-log.
    display 
        param-b2c.cod-depos 
        param-b2c.cod-depos-saldao
        param-b2c.cod-gr-cli 
        param-b2c.cod-moeda-b2c 
        param-b2c.cod-transp-sedex 
        param-b2c.cond-pagto-bol 
        param-b2c.cond-pagto-cred 
        param-b2c.cond-pagto-deb 
        param-b2c.cond-pagto-cre-par
        param-b2c.cond-pagto-bol-par
        c-email
        param-b2c.remetente 
        param-b2c.url-webservices 
       with frame fPage0.

    enable
        param-b2c.cod-depos 
        param-b2c.cod-depos-saldao
        param-b2c.cod-gr-cli 
        param-b2c.cod-moeda-b2c 
        param-b2c.cod-transp-sedex 
        param-b2c.cond-pagto-bol 
        param-b2c.cond-pagto-cred 
        param-b2c.cond-pagto-deb 
        param-b2c.cond-pagto-cre-par
        param-b2c.cond-pagto-bol-par
        c-email
        param-b2c.remetente 
        param-b2c.url-webservices 
       with frame fPage0.


    apply 'leave' to param-b2c.cod-depos in frame fPage0.
    apply 'leave' to param-b2c.cod-depos-saldao in frame fPage0.
    apply 'leave' to param-b2c.cod-gr-cli in frame fPage0.
    apply 'leave' to param-b2c.cod-moeda-b2c in frame fPage0.
    apply 'leave' to param-b2c.cod-transp-sedex in frame fPage0.
    apply 'leave' to param-b2c.cond-pagto-bol in frame fPage0.
    apply 'leave' to param-b2c.cond-pagto-cred in frame fPage0.
    apply 'leave' to param-b2c.cond-pagto-deb in frame fPage0.
    apply 'leave' to param-b2c.cond-pagto-cre-par in frame fPage0.
    apply 'leave' to param-b2c.cond-pagto-bol-par in frame fPage0.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wWindow 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    find first param-b2c no-lock no-error.
    if not available param-b2c then do: 
        do transaction:
            create param-b2c.
        end.
        find first param-b2c no-lock no-error.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE insertError wWindow 
PROCEDURE insertError :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pErrorNumber      AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pErrorType        AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pErrorSubType     AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pErrorParameters  AS CHARACTER NO-UNDO.

    DEFINE VARIABLE iErrorSequence AS INTEGER NO-UNDO.

    find last RowErrors no-lock no-error.

    if available RowErrors then
        assign iErrorSequence = RowErrors.ErrorSequence + 1.
    else
        assign iErrorSequence = iErrorSequence + 1.

    create RowErrors.
    assign RowErrors.ErrorSequence    = iErrorSequence
           RowErrors.ErrorNumber      = pErrorNumber
           RowErrors.ErrorType        = pErrorType
           RowErrors.ErrorSubType     = pErrorSubType
           RowErrors.ErrorParameters  = pErrorParameters.

    run utp/ut-msgs.p ('msg', pErrorNumber, pErrorParameters).
    assign RowErrors.ErrorDescription = return-value.

    run utp/ut-msgs.p ('help', pErrorNumber, pErrorParameters).
    assign RowErrors.ErrorHelp = return-value.



    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveRecord wWindow 
PROCEDURE saveRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    run validateRecord in this-procedure.
    if return-value = 'NOK' then
        return 'NOK'.


    do transaction on error undo, return 'nok':
        find current param-b2c exclusive-lock.
        assign param-b2c.cod-depos          = input frame fPage0 param-b2c.cod-depos        
               param-b2c.cod-depos-saldao   = input frame fPage0 param-b2c.cod-depos-saldao    
               param-b2c.cod-gr-cli         = input frame fPage0 param-b2c.cod-gr-cli       
               param-b2c.cod-moeda-b2c      = input frame fPage0 param-b2c.cod-moeda-b2c    
               param-b2c.cod-transp-sedex   = input frame fPage0 param-b2c.cod-transp-sedex 
               param-b2c.cond-pagto-bol     = input frame fPage0 param-b2c.cond-pagto-bol   
               param-b2c.cond-pagto-cred    = input frame fPage0 param-b2c.cond-pagto-cred  
               param-b2c.cond-pagto-deb     = input frame fPage0 param-b2c.cond-pagto-deb   
               param-b2c.cond-pagto-cre-par = input frame fPage0 param-b2c.cond-pagto-cre-par
               param-b2c.cond-pagto-bol-par = input frame fPage0 param-b2c.cond-pagto-bol-par
               param-b2c.e-mail-log         = input frame fPage0 c-email     
               param-b2c.remetente          = input frame fPage0 param-b2c.remetente        
               param-b2c.url-webservices    = input frame fPage0 param-b2c.url-webservices  .
    end.

    return 'OK'.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord wWindow 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    empty temp-table RowErrors.

    if not can-find(deposito where deposito.cod-depos = input frame fPage0 param-b2c.cod-depos) then
        run insertError in this-procedure (2, 'EMS', 'ERROR', 'Dep¢sito~~' + input frame fPage0 param-b2c.cod-depos).

    if not can-find(deposito where deposito.cod-depos = input frame fPage0 param-b2c.cod-depos-saldao) then
        run insertError in this-procedure (2, 'EMS', 'ERROR', 'Dep¢sito Saldao~~' + input frame fPage0 param-b2c.cod-depos).

    if not can-find(gr-cli where gr-cli.cod-gr-cli = input frame fPage0 param-b2c.cod-gr-cli) then
        run insertError in this-procedure (2, 'EMS', 'ERROR', 'Grupo de Cliente~~~~' + input frame fPage0 param-b2c.cod-gr-cli).

    if not can-find(moeda where moeda.mo-codigo = input frame fPage0 param-b2c.cod-moeda-b2c) then
        run insertError in this-procedure (2, 'EMS', 'ERROR', 'Moeda~~~~' + input frame fPage0 param-b2c.cod-moeda-b2c).

    if not can-find(transporte where transporte.cod-transp = input frame fPage0 param-b2c.cod-transp-sedex) then
        run insertError in this-procedure (2, 'EMS', 'ERROR', 'Moeda~~~~' + input frame fPage0 param-b2c.cod-transp-sedex).

    if not can-find(cond-pagto where cond-pagto.cod-cond-pag = input frame fPage0 param-b2c.cond-pagto-cred) then
        run insertError in this-procedure (2, 'EMS', 'ERROR', 'Condi‡Æo de pagamento Cr‚dito~~~~' + input frame fPage0 param-b2c.cond-pagto-cred).

    if not can-find(cond-pagto where cond-pagto.cod-cond-pag = input frame fPage0 param-b2c.cond-pagto-deb) then
        run insertError in this-procedure (2, 'EMS', 'ERROR', 'Condi‡Æo de pagamento D‚bito~~~~' + input frame fPage0 param-b2c.cond-pagto-deb).

    if not can-find(cond-pagto where cond-pagto.cod-cond-pag = input frame fPage0 param-b2c.cond-pagto-bol) then
        run insertError in this-procedure (2, 'EMS', 'ERROR', 'Condi‡Æo de pagamento Boleto~~~~' + input frame fPage0 param-b2c.cond-pagto-bol).
    
    if not can-find(cond-pagto where cond-pagto.cod-cond-pag = input frame fPage0 param-b2c.cond-pagto-bol-par) then
        run insertError in this-procedure (2, 'EMS', 'ERROR', 'Condi‡Æo de pagamento Boleto PAR~~~~' + input frame fPage0 param-b2c.cond-pagto-bol-par).
    if not can-find(cond-pagto where cond-pagto.cod-cond-pag = input frame fPage0 param-b2c.cond-pagto-cre-par) then
        run insertError in this-procedure (2, 'EMS', 'ERROR', 'Condi‡Æo de pagamento Credito Especial~~~~' + input frame fPage0 param-b2c.cond-pagto-cre-par).

    if input FRAME fpage0 c-email = '' then
        run insertError in this-procedure (54, 'EMS', 'ERROR', 'E-mail Log Erros Integra‡Æo B2C').

    if input frame fPage0 param-b2c.remetente = '' then
        run insertError in this-procedure (54, 'EMS', 'ERROR', 'Remetente Log Erros Integra‡Æo B2C').

    if input frame fPage0 param-b2c.url-webservices = '' then
        run insertError in this-procedure (54, 'EMS', 'ERROR', 'URL Web Services B2C').


    if can-find(first RowErrors) then
        return 'NOK'.

    return 'OK'.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

