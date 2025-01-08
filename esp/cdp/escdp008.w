&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-historico-credito NO-UNDO LIKE historico-credito.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCDP008 2.04.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCDP008
&GLOBAL-DEFINE Version        2.04.00.000

&GLOBAL-DEFINE WindowType     master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    0
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   br-historico-credito ed-motivo btExit btHelp btFechar
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p-tipo         AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER p-nr-pedido    AS INTEGER NO-UNDO.

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-historico-credito

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-historico-credito

/* Definitions for BROWSE br-historico-credito                          */
&Scoped-define FIELDS-IN-QUERY-br-historico-credito ~
tt-historico-credito.nr-sequencia tt-historico-credito.tipo-movto ~
tt-historico-credito.dt-data-movto tt-historico-credito.usuar-movto ~
tt-historico-credito.motivo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-historico-credito 
&Scoped-define QUERY-STRING-br-historico-credito FOR EACH tt-historico-credito NO-LOCK ~
    BY tt-historico-credito.nr-sequencia DESCENDING INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-historico-credito OPEN QUERY br-historico-credito FOR EACH tt-historico-credito NO-LOCK ~
    BY tt-historico-credito.nr-sequencia DESCENDING INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-historico-credito tt-historico-credito
&Scoped-define FIRST-TABLE-IN-QUERY-br-historico-credito tt-historico-credito


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-historico-credito}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tg-liberacao-forcada br-historico-credito ~
ed-motivo btFechar btExit btHelp fi-nr-pedcli rtToolBar-2 rtToolBar RECT-1 ~
RECT-2 
&Scoped-Define DISPLAYED-OBJECTS tg-liberacao-forcada ed-motivo ~
fi-nr-pedcli 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
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
DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFechar 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE ed-motivo AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 75.72 BY 2.63 NO-UNDO.

DEFINE VARIABLE fi-nr-pedcli AS CHARACTER FORMAT "X(256)" 
     LABEL "Pedido":R8 
     VIEW-AS FILL-IN 
     SIZE 14.57 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 1.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 10.38.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 80 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 80 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE tg-liberacao-forcada AS LOGICAL 
     LABEL "Libera‡Æo For‡ada" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-historico-credito FOR 
      tt-historico-credito SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-historico-credito
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-historico-credito wWindow _STRUCTURED
  QUERY br-historico-credito NO-LOCK DISPLAY
      tt-historico-credito.nr-sequencia FORMAT ">>>,>>9":U
      tt-historico-credito.tipo-movto FORMAT "x(5)":U
      tt-historico-credito.dt-data-movto FORMAT "99/99/9999":U
      tt-historico-credito.usuar-movto FORMAT "x(15)":U
      tt-historico-credito.motivo FORMAT "x(200)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 75.72 BY 6.63
         FONT 1
         TITLE "Hist¢rico Cr‚dito" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tg-liberacao-forcada AT ROW 3.08 COL 34 HELP
          "Libera‡Æo For‡ada do Pedido" WIDGET-ID 14
     br-historico-credito AT ROW 4.63 COL 3.29 WIDGET-ID 200
     ed-motivo AT ROW 11.92 COL 3.29 NO-LABEL WIDGET-ID 10
     btFechar AT ROW 15.17 COL 2
     btExit AT ROW 1.13 COL 72.57 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 76.57 HELP
          "Ajuda"
     fi-nr-pedcli AT ROW 3.08 COL 10.43 COLON-ALIGNED WIDGET-ID 2
     "Motivo:" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 11.29 COL 3.29 WIDGET-ID 12
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 14.96 COL 1
     RECT-1 AT ROW 2.75 COL 2.14 WIDGET-ID 6
     RECT-2 AT ROW 4.38 COL 2.14 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.14 BY 15.42
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-historico-credito T "?" NO-UNDO mgesp historico-credito
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 15.42
         WIDTH              = 80.14
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
/* BROWSE-TAB br-historico-credito 1 fpage0 */
ASSIGN 
       ed-motivo:READ-ONLY IN FRAME fpage0        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-historico-credito
/* Query rebuild information for BROWSE br-historico-credito
     _TblList          = "Temp-Tables.tt-historico-credito"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.tt-historico-credito.nr-sequencia|no"
     _FldNameList[1]   = Temp-Tables.tt-historico-credito.nr-sequencia
     _FldNameList[2]   = Temp-Tables.tt-historico-credito.tipo-movto
     _FldNameList[3]   = Temp-Tables.tt-historico-credito.dt-data-movto
     _FldNameList[4]   = Temp-Tables.tt-historico-credito.usuar-movto
     _FldNameList[5]   = Temp-Tables.tt-historico-credito.motivo
     _Query            is OPENED
*/  /* BROWSE br-historico-credito */
&ANALYZE-RESUME

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


&Scoped-define BROWSE-NAME br-historico-credito
&Scoped-define SELF-NAME br-historico-credito
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-historico-credito wWindow
ON VALUE-CHANGED OF br-historico-credito IN FRAME fpage0 /* Hist¢rico Cr‚dito */
DO:
    IF AVAIL tt-historico-credito THEN DO:
        ASSIGN ed-motivo:SCREEN-VALUE IN FRAME fPage0 = tt-historico-credito.motivo.
    END.
    ELSE ASSIGN ed-motivo:SCREEN-VALUE IN FRAME fPage0 = "".
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


&Scoped-define SELF-NAME btFechar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFechar wWindow
ON CHOOSE OF btFechar IN FRAME fpage0 /* Fechar */
DO:
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


RUN pi-carrega-dados.

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
    
    APPLY "VALUE-CHANGED" TO br-historico-credito IN FRAME fPage0.
    br-historico-credito:SELECT-FOCUSED-ROW().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-dados wWindow 
PROCEDURE pi-carrega-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH tt-historico-credito NO-LOCK:
        DELETE tt-historico-credito.
    END.
    FIND ped-venda
        WHERE ped-venda.nr-pedido = p-nr-pedido
        NO-LOCK NO-ERROR.

    FIND FIRST int-ped-venda NO-LOCK
        WHERE  int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
    ASSIGN tg-liberacao-forcada:CHECKED IN FRAME fPage0 = IF AVAIL int-ped-venda THEN int-ped-venda.liberacao-forcada ELSE NO.

    FIND FIRST historico-credito NO-LOCK
         WHERE historico-credito.nome-abrev = ped-venda.nome-abrev
           AND historico-credito.nr-pedcli  = ped-venda.nr-pedcli
         NO-ERROR.
    IF AVAIL historico-credito THEN DO:
       ASSIGN fi-nr-pedcli:SCREEN-VALUE IN FRAME fPage0 = STRING(ped-venda.Nr-pedcli).
        FOR EACH historico-credito NO-LOCK
            WHERE historico-credito.nome-abrev = ped-venda.nome-abrev
              AND historico-credito.nr-pedcli  = ped-venda.nr-pedcli:
            CREATE tt-historico-credito.
            BUFFER-COPY historico-credito TO tt-historico-credito.
        END.
        {&OPEN-QUERY-br-historico-credito}
    END.
    ELSE DO:
        MESSAGE "NÆo existe hist¢rico Para o Pedido"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        APPLY "close" TO THIS-PROCEDURE.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

