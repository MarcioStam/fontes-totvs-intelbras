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
{include/i-prgvrs.i ESCEP066A 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCEP066A
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Filtro

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   fi-familia-ini fi-familia-fim fi-cod-estabel-ini fi-cod-estabel-fim fi-it-codigo-ini fi-it-codigo-fim fi-cod-fabricante-ini fi-cod-fabricante-fim tg-ativos tg-vencidos
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */


DEFINE INPUT-OUTPUT PARAMETER io-item-fam-ini       AS CHAR     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER io-item-fam-fim       AS CHAR     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER io-cod-estabel-ini    AS CHAR     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER io-cod-estabel-fim    AS CHAR     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER io-it-codigo-ini      AS CHAR     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER io-it-codigo-fim      AS CHAR     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER io-cod-fabric-ini     AS INT      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER io-cod-fabric-fim     AS INT      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER io-ativos             AS LOG      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER io-vencidos           AS LOG      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp2 

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

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE fi-cod-estabel-fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-cod-estabel-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-cod-fabricante-fim AS INTEGER FORMAT ">>>,>>9":U INITIAL 999999 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-cod-fabricante-ini AS INTEGER FORMAT ">>>,>>9":U INITIAL 0 
     LABEL "Fabricante" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-familia-fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-familia-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Fam¡lia de C¢digo de Item" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-it-codigo-fim AS CHARACTER FORMAT "X(7)":U INITIAL "ZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-it-codigo-ini AS CHARACTER FORMAT "X(7)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88
     FONT 1 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE tg-ativos AS LOGICAL INITIAL yes 
     LABEL "Ativos" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-vencidos AS LOGICAL INITIAL yes 
     LABEL "Vencidos" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 15.13 COL 2
     btCancel AT ROW 15.13 COL 13
     btHelp2 AT ROW 15.13 COL 80
     rtToolBar AT ROW 14.92 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 15.54
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     fi-familia-ini AT ROW 1.5 COL 14.57 WIDGET-ID 4
     fi-familia-fim AT ROW 1.5 COL 49 NO-LABEL WIDGET-ID 2
     fi-cod-estabel-ini AT ROW 2.5 COL 21 WIDGET-ID 12
     fi-cod-estabel-fim AT ROW 2.5 COL 49 NO-LABEL WIDGET-ID 10
     fi-it-codigo-ini AT ROW 3.5 COL 23.28 WIDGET-ID 20
     fi-it-codigo-fim AT ROW 3.5 COL 49 NO-LABEL WIDGET-ID 18
     fi-cod-fabricante-ini AT ROW 4.5 COL 23 WIDGET-ID 28
     fi-cod-fabricante-fim AT ROW 4.5 COL 49 NO-LABEL WIDGET-ID 26
     tg-ativos AT ROW 6.5 COL 39 WIDGET-ID 34
     tg-vencidos AT ROW 7.5 COL 39 WIDGET-ID 36
     IMAGE-1 AT ROW 1.5 COL 38.86 WIDGET-ID 6
     IMAGE-2 AT ROW 1.5 COL 46 WIDGET-ID 8
     IMAGE-3 AT ROW 2.5 COL 38.86 WIDGET-ID 14
     IMAGE-4 AT ROW 2.5 COL 46 WIDGET-ID 16
     IMAGE-5 AT ROW 3.5 COL 38.86 WIDGET-ID 22
     IMAGE-6 AT ROW 3.5 COL 46 WIDGET-ID 24
     IMAGE-7 AT ROW 4.5 COL 38.86 WIDGET-ID 30
     IMAGE-8 AT ROW 4.5 COL 46 WIDGET-ID 32
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.38
         SIZE 84.43 BY 11.83
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
         HEIGHT             = 15.54
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN fi-cod-estabel-fim IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-cod-estabel-ini IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-cod-fabricante-fim IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-cod-fabricante-ini IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-familia-fim IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-familia-ini IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-it-codigo-fim IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-it-codigo-ini IN FRAME fPage1
   ALIGN-L                                                              */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
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

    DO WITH FRAME fPage1:

        ASSIGN io-item-fam-ini    = fi-familia-ini:SCREEN-VALUE
               io-item-fam-fim    = fi-familia-fim:SCREEN-VALUE
               io-cod-estabel-ini = fi-cod-estabel-ini:SCREEN-VALUE
               io-cod-estabel-fim = fi-cod-estabel-fim:SCREEN-VALUE
               io-it-codigo-ini   = fi-it-codigo-ini:SCREEN-VALUE
               io-it-codigo-fim   = fi-it-codigo-fim:SCREEN-VALUE
               io-cod-fabric-ini  = int(fi-cod-fabricante-ini:SCREEN-VALUE)
               io-cod-fabric-fim  = int(fi-cod-fabricante-fim:SCREEN-VALUE)
               io-ativos          = tg-ativos:CHECKED
               io-vencidos        = tg-vencidos:CHECKED.

    END.

    APPLY "CLOSE":U TO THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME fi-cod-fabricante-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-fabricante-fim wWindow
ON F5 OF fi-cod-fabricante-fim IN FRAME fPage1
DO:

    {method/ZoomFields.i &ProgramZoom="eszoom/z01es077.w"
                         &FieldZoom1="cod-fabric"
                         &FieldScreen1="fi-cod-fabricante-fim"
                         &Frame1="fPage1"
                         &EnableImplant="NO"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-fabricante-fim wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-cod-fabricante-fim IN FRAME fPage1
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-fabricante-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-fabricante-ini wWindow
ON F5 OF fi-cod-fabricante-ini IN FRAME fPage1 /* Fabricante */
DO:

    {method/ZoomFields.i &ProgramZoom="eszoom/z01es077.w"
                         &FieldZoom1="cod-fabric"
                         &FieldScreen1="fi-cod-fabricante-ini"
                         &Frame1="fPage1"
                         &EnableImplant="NO"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-fabricante-ini wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-cod-fabricante-ini IN FRAME fPage1 /* Fabricante */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/

fi-cod-fabricante-ini:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
fi-cod-fabricante-fim:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wWindow 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME fPage1:

        ASSIGN fi-familia-ini:SCREEN-VALUE             = io-item-fam-ini   
               fi-familia-fim:SCREEN-VALUE             = io-item-fam-fim   
               fi-cod-estabel-ini:SCREEN-VALUE         = io-cod-estabel-ini
               fi-cod-estabel-fim:SCREEN-VALUE         = io-cod-estabel-fim
               fi-it-codigo-ini:SCREEN-VALUE           = io-it-codigo-ini  
               fi-it-codigo-fim:SCREEN-VALUE           = io-it-codigo-fim  
               fi-cod-fabricante-ini:SCREEN-VALUE      = string(io-cod-fabric-ini)
               fi-cod-fabricante-fim:SCREEN-VALUE      = string(io-cod-fabric-fim)
               tg-ativos:CHECKED                       = io-ativos         
               tg-vencidos:CHECKED                     = io-vencidos.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

