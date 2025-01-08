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
{include/i-prgvrs.i ESCDP033B 2.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCDP033B
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
DEFINE INPUT-OUTPUT PARAMETER p-cod-gr-cli-ini   LIKE crm-desc-manga.cod-gr-cli    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-cod-gr-cli-fim   LIKE crm-desc-manga.cod-gr-cli    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-cd-categoria-ini LIKE crm-desc-manga.cd-categoria  NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-cd-categoria-fim LIKE crm-desc-manga.cd-categoria  NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-cod-rep-ini      LIKE crm-desc-manga.cod-rep       NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-cod-rep-fim      LIKE crm-desc-manga.cod-rep       NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-fm-cod-com-ini   LIKE crm-desc-manga.fm-cod-com    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-fm-cod-com-fim   LIKE crm-desc-manga.fm-cod-com    NO-UNDO.

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar IMAGE-9 IMAGE-10 IMAGE-11 IMAGE-12 ~
IMAGE-13 IMAGE-14 IMAGE-15 IMAGE-16 i-cod-gr-cli-ini i-cod-gr-cli-fim ~
i-cd-categoria-ini i-cd-categoria-fim i-cod-rep-ini i-cod-rep-fim ~
c-fm-cod-com-ini c-fm-cod-com-fim btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS i-cod-gr-cli-ini i-cod-gr-cli-fim ~
i-cd-categoria-ini i-cd-categoria-fim i-cod-rep-ini i-cod-rep-fim ~
c-fm-cod-com-ini c-fm-cod-com-fim 

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

DEFINE VARIABLE c-fm-cod-com-fim AS CHARACTER FORMAT "x(8)" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-fm-cod-com-ini AS CHARACTER FORMAT "x(8)" 
     LABEL "Fam¡lia Comercial" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-cd-categoria-fim AS INTEGER FORMAT ">>9" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-cd-categoria-ini AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Categoria" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-gr-cli-fim AS INTEGER FORMAT ">9" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-gr-cli-ini AS INTEGER FORMAT ">9" INITIAL 0 
     LABEL "Grupo Cliente" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-rep-fim AS INTEGER FORMAT ">>>>9" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-rep-ini AS INTEGER FORMAT ">>>>9" INITIAL 0 
     LABEL "Representante" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-10
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .92.

DEFINE IMAGE IMAGE-11
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .92.

DEFINE IMAGE IMAGE-12
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .92.

DEFINE IMAGE IMAGE-13
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .92.

DEFINE IMAGE IMAGE-14
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .92.

DEFINE IMAGE IMAGE-15
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .92.

DEFINE IMAGE IMAGE-16
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .92.

DEFINE IMAGE IMAGE-9
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .92.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     i-cod-gr-cli-ini AT ROW 1.5 COL 24.14 COLON-ALIGNED HELP
          "C¢digo do Grupo de Cliente" WIDGET-ID 2
     i-cod-gr-cli-fim AT ROW 1.5 COL 50.43 COLON-ALIGNED HELP
          "C¢digo do Grupo de Cliente" NO-LABEL WIDGET-ID 4
     i-cd-categoria-ini AT ROW 2.5 COL 24.14 COLON-ALIGNED HELP
          "C¢digo da Categoria" WIDGET-ID 6
     i-cd-categoria-fim AT ROW 2.5 COL 50.43 COLON-ALIGNED HELP
          "C¢digo da Categoria" NO-LABEL WIDGET-ID 8
     i-cod-rep-ini AT ROW 3.5 COL 24.14 COLON-ALIGNED HELP
          "C¢digo do Representante" WIDGET-ID 28
     i-cod-rep-fim AT ROW 3.5 COL 50.43 COLON-ALIGNED HELP
          "C¢digo do Representante" NO-LABEL WIDGET-ID 26
     c-fm-cod-com-ini AT ROW 4.5 COL 24.14 COLON-ALIGNED HELP
          "C¢digo da Fam¡lia Comercial" WIDGET-ID 24
     c-fm-cod-com-fim AT ROW 4.5 COL 50.43 COLON-ALIGNED HELP
          "C¢digo da Fam¡lia Comercial" NO-LABEL WIDGET-ID 22
     btOK AT ROW 6.17 COL 2
     btCancel AT ROW 6.17 COL 13
     btHelp2 AT ROW 6.17 COL 80
     rtToolBar AT ROW 5.96 COL 1
     IMAGE-9 AT ROW 1.5 COL 41.14 WIDGET-ID 16
     IMAGE-10 AT ROW 1.5 COL 48.43 WIDGET-ID 14
     IMAGE-11 AT ROW 2.5 COL 41.14 WIDGET-ID 20
     IMAGE-12 AT ROW 2.5 COL 48.43 WIDGET-ID 18
     IMAGE-13 AT ROW 3.5 COL 41.14 WIDGET-ID 36
     IMAGE-14 AT ROW 3.5 COL 48.43 WIDGET-ID 30
     IMAGE-15 AT ROW 4.5 COL 41.14 WIDGET-ID 32
     IMAGE-16 AT ROW 4.5 COL 48.43 WIDGET-ID 34
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 6.42
         FONT 1 WIDGET-ID 100.


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
         HEIGHT             = 6.42
         WIDTH              = 90
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
/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
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
ON CHOOSE OF btCancel IN FRAME fPage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fPage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fPage0 /* OK */
DO:
    ASSIGN INPUT FRAME fPage0 i-cod-gr-cli-ini
           INPUT FRAME fPage0 i-cod-gr-cli-fim
           INPUT FRAME fPage0 i-cd-categoria-ini
           INPUT FRAME fPage0 i-cd-categoria-fim
           INPUT FRAME fPage0 i-cod-rep-ini
           INPUT FRAME fPage0 i-cod-rep-fim
           INPUT FRAME fPage0 c-fm-cod-com-ini
           INPUT FRAME fPage0 c-fm-cod-com-fim.

    ASSIGN p-cod-gr-cli-ini   = i-cod-gr-cli-ini
           p-cod-gr-cli-fim   = i-cod-gr-cli-fim
           p-cd-categoria-ini = i-cd-categoria-ini
           p-cd-categoria-fim = i-cd-categoria-fim
           p-cod-rep-ini      = i-cod-rep-ini
           p-cod-rep-fim      = i-cod-rep-fim
           p-fm-cod-com-ini   = c-fm-cod-com-ini
           p-fm-cod-com-fim   = c-fm-cod-com-fim.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
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

    ASSIGN i-cod-gr-cli-ini   = p-cod-gr-cli-ini
           i-cod-gr-cli-fim   = p-cod-gr-cli-fim
           i-cd-categoria-ini = p-cd-categoria-ini
           i-cd-categoria-fim = p-cd-categoria-fim
           i-cod-rep-ini      = p-cod-rep-ini
           i-cod-rep-fim      = p-cod-rep-fim
           c-fm-cod-com-ini   = p-fm-cod-com-ini
           c-fm-cod-com-fim   = p-fm-cod-com-fim.

    DISPLAY i-cod-gr-cli-ini
            i-cod-gr-cli-fim
            i-cd-categoria-ini
            i-cd-categoria-fim
            i-cod-rep-ini
            i-cod-rep-fim
            c-fm-cod-com-ini
            c-fm-cod-com-fim
        WITH FRAME fPage0.

    ENABLE i-cod-gr-cli-ini
           i-cod-gr-cli-fim
           i-cd-categoria-ini
           i-cd-categoria-fim
           i-cod-rep-ini
           i-cod-rep-fim
           c-fm-cod-com-ini
           c-fm-cod-com-fim
        WITH FRAME fPage0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

