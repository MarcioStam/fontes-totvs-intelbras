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
{include/i-prgvrs.i esftp093b 2.06.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esftp093b
&GLOBAL-DEFINE Version        2.06.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 c-nr-nota-fis-fim c-nr-nota-fis-ini c-serie-fim c-serie-ini d-dt-emis-fim d-dt-emis-ini

/* Parameters Definitions ---                                           */
DEFINE INPUT-OUTPUT PARAMETER p-serie-ini       AS CHARACTER INIT "":U                 NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-serie-fim       AS CHARACTER INIT "ZZZZZ":U            NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-nr-nota-fis-ini AS CHARACTER INIT "":U                 NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-nr-nota-fis-fim AS CHARACTER INIT "ZZZZZZZZZZZZZZZZ":U NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-dt-emis-ini     AS DATE    FORMAT "99/99/9999":U       NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-dt-emis-fim     AS DATE    FORMAT "99/99/9999":U       NO-UNDO.
DEFINE       OUTPUT PARAMETER p-bt-press        AS LOGICAL FORMAT "OK/Cancela":U       NO-UNDO.

/* Local Variable Definitions ---                                       */
{upc/btb910za-upc.i} /* v_cod_estab_usuar */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar IMAGE-1 IMAGE-2 IMAGE-7 IMAGE-8 ~
IMAGE-9 IMAGE-10 RECT-14 RECT-15 c-serie-ini c-serie-fim c-nr-nota-fis-ini ~
c-nr-nota-fis-fim d-dt-emis-ini d-dt-emis-fim btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS c-cod-estabel c-desc-estabel c-serie-ini ~
c-serie-fim c-nr-nota-fis-ini c-nr-nota-fis-fim d-dt-emis-ini d-dt-emis-fim 

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

DEFINE VARIABLE c-cod-estabel AS CHARACTER FORMAT "X(3)" 
     LABEL "Estab":R7 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estabel AS CHARACTER FORMAT "x(60)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-nota-fis-fim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-nota-fis-ini AS CHARACTER FORMAT "x(16)" 
     LABEL "Nr Nota Fiscal":R17 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE c-serie-fim AS CHARACTER FORMAT "x(5)" INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c-serie-ini AS CHARACTER FORMAT "x(5)" 
     LABEL "SÇrie":R7 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE d-dt-emis-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE d-dt-emis-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Emiss∆o" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 61 BY 1.5.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 61 BY 3.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 61 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     c-cod-estabel AT ROW 1.5 COL 12 COLON-ALIGNED HELP
          "C¢digo do estabelecimento" WIDGET-ID 10
     c-desc-estabel AT ROW 1.5 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 54
     c-serie-ini AT ROW 3.04 COL 12 COLON-ALIGNED HELP
          "SÇrie da nota fiscal" WIDGET-ID 12
     c-serie-fim AT ROW 3.04 COL 39 COLON-ALIGNED HELP
          "SÇrie da nota fiscal" NO-LABEL WIDGET-ID 58
     c-nr-nota-fis-ini AT ROW 4.04 COL 12 COLON-ALIGNED HELP
          "N£mero da nota fiscal" WIDGET-ID 14
     c-nr-nota-fis-fim AT ROW 4.04 COL 39 COLON-ALIGNED HELP
          "N£mero da nota fiscal" NO-LABEL WIDGET-ID 56
     d-dt-emis-ini AT ROW 5.04 COL 12 COLON-ALIGNED WIDGET-ID 32
     d-dt-emis-fim AT ROW 5.04 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     btOK AT ROW 6.54 COL 2.72
     btCancel AT ROW 6.54 COL 13
     btHelp2 AT ROW 6.54 COL 52.43
     rtToolBar AT ROW 6.33 COL 2
     IMAGE-1 AT ROW 5.04 COL 33 WIDGET-ID 26
     IMAGE-2 AT ROW 5.04 COL 37 WIDGET-ID 28
     IMAGE-7 AT ROW 3.04 COL 33 WIDGET-ID 40
     IMAGE-8 AT ROW 3.04 COL 37 WIDGET-ID 42
     IMAGE-9 AT ROW 4.04 COL 33 WIDGET-ID 44
     IMAGE-10 AT ROW 4.04 COL 37 WIDGET-ID 46
     RECT-14 AT ROW 1.25 COL 2 WIDGET-ID 48
     RECT-15 AT ROW 2.79 COL 2 WIDGET-ID 50
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 62.57 BY 6.96
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
         HEIGHT             = 7.08
         WIDTH              = 62.57
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
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
/* SETTINGS FOR FILL-IN c-cod-estabel IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-estabel IN FRAME fpage0
   NO-ENABLE                                                            */
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
    ASSIGN p-bt-press = FALSE.

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
    ASSIGN p-serie-ini       = input frame fPage0 c-serie-ini
           p-serie-fim       = input frame fPage0 c-serie-fim
           p-nr-nota-fis-ini = input frame fPage0 c-nr-nota-fis-ini
           p-nr-nota-fis-fim = input frame fPage0 c-nr-nota-fis-fim
           p-dt-emis-ini     = input frame fPage0 d-dt-emis-ini
           p-dt-emis-fim     = input frame fPage0 d-dt-emis-fim
           p-bt-press        = TRUE.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
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
    Notes:       
------------------------------------------------------------------------------*/
    /*---[ Estabelecimento Usu†rio Intelbras ]---*/
    ASSIGN c-cod-estabel:SCREEN-VALUE IN FRAME fPage0 = v_cod_estab_usuar.
    
    find first estabelec no-lock
        where  estabelec.cod-estabel = input frame fPage0 c-cod-estabel no-error.
    if  avail  estabelec then
        assign c-desc-estabel:screen-value in frame fPage0 = estabelec.nome.
    else 
        assign c-desc-estabel:screen-value in frame fPage0 = "":U.

    /*---[ Faixa de Datas de Emiss∆o ]-----------*/
    IF  MONTH(today) = 12 then 
        ASSIGN d-dt-emis-ini:screen-value in frame fPage0 = "01/01/2000":U
               d-dt-emis-fim:screen-value in frame fPage0 = string(date(01, 01, year(today) + 1) - 1).
    else 
        ASSIGN d-dt-emis-ini:screen-value in frame fPage0 = "01/01/2000":U
               d-dt-emis-fim:screen-value in frame fPage0 = string(date(month(today) + 1, 01, year(today)) - 1).

    /*---[ Carregamento com o conte£do dos parÉmetros ]---*/
    IF  p-dt-emis-ini <> ? THEN
        ASSIGN c-serie-ini:SCREEN-VALUE       IN FRAME fPage0 = p-serie-ini
               c-serie-fim:SCREEN-VALUE       IN FRAME fPage0 = p-serie-fim
               c-nr-nota-fis-ini:SCREEN-VALUE IN FRAME fPage0 = p-nr-nota-fis-ini
               c-nr-nota-fis-fim:SCREEN-VALUE IN FRAME fPage0 = p-nr-nota-fis-fim
               d-dt-emis-ini:SCREEN-VALUE     IN FRAME fPage0 = string(p-dt-emis-ini, "99/99/9999":U)
               d-dt-emis-fim:SCREEN-VALUE     IN FRAME fPage0 = string(p-dt-emis-fim, "99/99/9999":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

