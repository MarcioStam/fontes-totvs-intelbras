&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESFTP068B 2.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESFTP068B
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO

&GLOBAL-DEFINE page0Widgets   btOK btCancel
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
DEFINE INPUT-OUTPUT PARAMETER p-nome-abrev-ini AS CHARACTER   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-nome-abrev-fim AS CHARACTER   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-nr-pedcli-ini  AS CHARACTER   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-nr-pedcli-fim  AS CHARACTER   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-dt-entrega-ini AS DATE        NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-dt-entrega-fim AS DATE        NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-atend-ini      AS CHARACTER   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-atend-fim      AS CHARACTER   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-estab-ini      AS CHARACTER   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-estab-fim      AS CHARACTER   NO-UNDO.
DEFINE OUTPUT       PARAMETER p-cancela        AS LOGICAL     NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS rtToolBar IMAGE-1 IMAGE-2 IMAGE-3 IMAGE-4 ~
IMAGE-5 IMAGE-6 IMAGE-7 IMAGE-8 RECT-18 IMAGE-9 IMAGE-10 c-nome-abrev-ini ~
c-nome-abrev-fim c-nr-pedcli-ini c-nr-pedcli-fim dt-entrega-ini ~
dt-entrega-fim c-atend-ini c-atend-fim fi-estab-ini fi-estab-fim btOK ~
btCancel 
&Scoped-Define DISPLAYED-OBJECTS c-nome-abrev-ini c-nome-abrev-fim ~
c-nr-pedcli-ini c-nr-pedcli-fim dt-entrega-ini dt-entrega-fim c-atend-ini ~
c-atend-fim fi-estab-ini fi-estab-fim 

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

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-atend-fim AS CHARACTER FORMAT "x(2)" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88.

DEFINE VARIABLE c-atend-ini AS CHARACTER FORMAT "x(2)" 
     LABEL "Atendente" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88.

DEFINE VARIABLE c-nome-abrev-fim AS CHARACTER FORMAT "x(12)" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88.

DEFINE VARIABLE c-nome-abrev-ini AS CHARACTER FORMAT "x(12)" 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88.

DEFINE VARIABLE c-nr-pedcli-fim AS CHARACTER FORMAT "x(12)" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88.

DEFINE VARIABLE c-nr-pedcli-ini AS CHARACTER FORMAT "x(12)" 
     LABEL "Pedido Cliente" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88.

DEFINE VARIABLE dt-entrega-fim AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88.

DEFINE VARIABLE dt-entrega-ini AS DATE FORMAT "99/99/9999" 
     LABEL "Prev.Fatur" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88.

DEFINE VARIABLE fi-estab-fim AS CHARACTER FORMAT "X(256)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estab-ini AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir.bmp":U
     SIZE 2.72 BY .67.

DEFINE IMAGE IMAGE-10
     FILENAME "image/im-las.bmp":U
     SIZE 2.29 BY .67.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las.bmp":U
     SIZE 2.29 BY .67.

DEFINE IMAGE IMAGE-3
     FILENAME "image/im-fir.bmp":U
     SIZE 2.72 BY .75.

DEFINE IMAGE IMAGE-4
     FILENAME "image/im-las.bmp":U
     SIZE 2.29 BY .75.

DEFINE IMAGE IMAGE-5
     FILENAME "image/im-fir.bmp":U
     SIZE 2.72 BY .67.

DEFINE IMAGE IMAGE-6
     FILENAME "image/im-las.bmp":U
     SIZE 2.29 BY .67.

DEFINE IMAGE IMAGE-7
     FILENAME "image/im-fir.bmp":U
     SIZE 2.72 BY .75.

DEFINE IMAGE IMAGE-8
     FILENAME "image/im-las.bmp":U
     SIZE 2.29 BY .75.

DEFINE IMAGE IMAGE-9
     FILENAME "image/im-fir.bmp":U
     SIZE 2.72 BY .67.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 69 BY 5.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 71 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     c-nome-abrev-ini AT ROW 1.58 COL 14.14 COLON-ALIGNED HELP
          "Nome abreviado do cliente" WIDGET-ID 12
     c-nome-abrev-fim AT ROW 1.58 COL 42 COLON-ALIGNED HELP
          "Nome abreviado do cliente" NO-LABEL WIDGET-ID 10
     c-nr-pedcli-ini AT ROW 2.58 COL 14.14 COLON-ALIGNED HELP
          "N£mero do pedido do cliente" WIDGET-ID 8
     c-nr-pedcli-fim AT ROW 2.58 COL 42 COLON-ALIGNED HELP
          "N£mero do pedido do cliente" NO-LABEL WIDGET-ID 6
     dt-entrega-ini AT ROW 3.58 COL 14.14 COLON-ALIGNED HELP
          "Data prevista para Faturamento do Pedido" WIDGET-ID 58
     dt-entrega-fim AT ROW 3.58 COL 42 COLON-ALIGNED HELP
          "Data prevista para Faturamento do Pedido" NO-LABEL WIDGET-ID 56
     c-atend-ini AT ROW 4.58 COL 14.14 COLON-ALIGNED HELP
          "Dispon¡vel para classifica‡Æo/indica‡Æo pr¢pria do usu rio" WIDGET-ID 62
     c-atend-fim AT ROW 4.58 COL 42 COLON-ALIGNED HELP
          "Dispon¡vel para classifica‡Æo/indica‡Æo pr¢pria do usu rio" NO-LABEL WIDGET-ID 60
     fi-estab-ini AT ROW 5.58 COL 14.14 COLON-ALIGNED WIDGET-ID 76
     fi-estab-fim AT ROW 5.58 COL 42.14 COLON-ALIGNED NO-LABEL WIDGET-ID 78
     btOK AT ROW 7.88 COL 2
     btCancel AT ROW 7.88 COL 13
     rtToolBar AT ROW 7.63 COL 1
     IMAGE-1 AT ROW 1.67 COL 32.57 WIDGET-ID 28
     IMAGE-2 AT ROW 1.67 COL 38.86 WIDGET-ID 30
     IMAGE-3 AT ROW 2.67 COL 32.57 WIDGET-ID 52
     IMAGE-4 AT ROW 2.67 COL 38.86 WIDGET-ID 54
     IMAGE-5 AT ROW 3.67 COL 32.57 WIDGET-ID 64
     IMAGE-6 AT ROW 3.67 COL 38.86 WIDGET-ID 66
     IMAGE-7 AT ROW 4.67 COL 32.57 WIDGET-ID 68
     IMAGE-8 AT ROW 4.67 COL 38.86 WIDGET-ID 70
     RECT-18 AT ROW 1.25 COL 2 WIDGET-ID 74
     IMAGE-9 AT ROW 5.71 COL 32.57 WIDGET-ID 80
     IMAGE-10 AT ROW 5.75 COL 39 WIDGET-ID 82
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 71 BY 8.21
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
         HEIGHT             = 8.21
         WIDTH              = 71
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
    ASSIGN p-cancela = YES.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fPage0 /* OK */
DO:
    RUN pi-salvar.
    IF  RETURN-VALUE = "OK" THEN
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

    ASSIGN c-nome-abrev-ini = p-nome-abrev-ini
           c-nome-abrev-fim = p-nome-abrev-fim
           c-nr-pedcli-ini  = p-nr-pedcli-ini
           c-nr-pedcli-fim  = p-nr-pedcli-fim
           dt-entrega-ini   = p-dt-entrega-ini
           dt-entrega-fim   = p-dt-entrega-fim
           c-atend-ini      = p-atend-ini
           c-atend-fim      = p-atend-fim
           fi-estab-ini     = p-estab-ini
           fi-estab-fim     = p-estab-fim.

    DISPLAY c-nome-abrev-ini
            c-nome-abrev-fim
            c-nr-pedcli-ini
            c-nr-pedcli-fim
            dt-entrega-ini
            dt-entrega-fim
            c-atend-ini
            c-atend-fim
            fi-estab-ini
            fi-estab-fim
        WITH FRAME fPage0.

    ENABLE c-nome-abrev-ini
           c-nome-abrev-fim
           c-nr-pedcli-ini
           c-nr-pedcli-fim
           dt-entrega-ini
           dt-entrega-fim
           c-atend-ini
           c-atend-fim
           fi-estab-ini
           fi-estab-fim
        WITH FRAME fPage0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salvar wWindow 
PROCEDURE pi-salvar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN INPUT FRAME fPage0 c-nome-abrev-ini
           INPUT FRAME fPage0 c-nome-abrev-fim
           INPUT FRAME fPage0 c-nr-pedcli-ini
           INPUT FRAME fPage0 c-nr-pedcli-fim
           INPUT FRAME fPage0 dt-entrega-ini
           INPUT FRAME fPage0 dt-entrega-fim
           INPUT FRAME fPage0 c-atend-ini
           INPUT FRAME fPage0 c-atend-fim
           INPUT FRAME fpage0 fi-estab-ini
           INPUT FRAME fpage0 fi-estab-fim.

    ASSIGN p-nome-abrev-ini = c-nome-abrev-ini
           p-nome-abrev-fim = c-nome-abrev-fim
           p-nr-pedcli-ini  = c-nr-pedcli-ini
           p-nr-pedcli-fim  = c-nr-pedcli-fim
           p-dt-entrega-ini = dt-entrega-ini
           p-dt-entrega-fim = dt-entrega-fim
           p-atend-ini      = c-atend-ini
           p-atend-fim      = c-atend-fim
           p-estab-ini      = fi-estab-ini
           p-estab-fim      = fi-estab-fim
           p-cancela        = NO.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

