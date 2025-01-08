&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttitem NO-UNDO LIKE item
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esp/cep/escep005 1.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        escep005
&GLOBAL-DEFINE Version        1.00.00.000

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            NO
&GLOBAL-DEFINE Copy           NO
&GLOBAL-DEFINE Update         NO
&GLOBAL-DEFINE Delete         NO
&GLOBAL-DEFINE Undo           NO
&GLOBAL-DEFINE Cancel         NO
&GLOBAL-DEFINE Save           NO

&GLOBAL-DEFINE ttTable        ttitem 
&GLOBAL-DEFINE hDBOTable      HBOitem
&GLOBAL-DEFINE DBOTable       ITEM   

&GLOBAL-DEFINE page0KeyFields 
&GLOBAL-DEFINE page0Fields    ttitem.it-codigo ttitem.desc-item fi-saldo-ae                                           
&GLOBAL-DEFINE page1Fields     
&GLOBAL-DEFINE page2Fields    

/* Parameters Definitions ---                                           */


/* Local Variable Definitions ---                                       */

DEF VAR i-tipo          AS INT INIT 1 NO-UNDO.
DEF VAR c-cod-estabel   AS CHAR FORMAT "x(3)" NO-UNDO.
DEF VAR c-cod-depos-ini AS CHAR FORMAT "x(3)" INITIAL "" NO-UNDO.
DEF VAR c-cod-depos-fim AS CHAR FORMAT "x(3)" INITIAL "ZZZ" NO-UNDO.
DEF VAR d-saldo-tot-ae  AS DECIMAL FORMAT "->>,>>>,>>9.99" NO-UNDO.
DEF VAR d-saldo-tot-est AS DECIMAL FORMAT "->>,>>>,>>9.99" NO-UNDO.
DEF VAR c-local         LIKE item.cod-localiz  NO-UNDO.

def temp-table tt-ae
    field nr-ae         AS int  format ">>>>>>9"    label "AE"
    field sequencia     AS int  format ">>9"        label "Seq"
    field quantidade    AS int  format ">>>,>>9"    label "QTD"
    field data          LIKE ae-item.data           label "Data" 
    field cod-depos     AS char format "x(3)"       label "Dep"
    field localizacao   LIKE ae-item.localizacao    label "Local"   FORMAT "X(20)"
    field roteiro       LIKE ae-item.roteiro.

DEF TEMP-TABLE tt-saldo
    FIELD cod-depos     LIKE saldo-estoq.cod-depos   label "Dep"
    FIELD cod-localiz   LIKE saldo-estoq.cod-localiz label "Local"      format "x(20)"
    FIELD quantidade    AS DEC                       label "Quantidade" format "->>>>,>>9.99"
    INDEX pr cod-depos cod-localiz.    

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
DEF VAR wh-pesquisa AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR adm-broker-hdl AS HANDLE NO-UNDO. 

{upc/btb910za-upc.i} /* Defini‡Æo do estabelecimento do usu rio */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-ae

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ae tt-saldo

/* Definitions for BROWSE br-ae                                         */
&Scoped-define FIELDS-IN-QUERY-br-ae tt-ae.nr-ae tt-ae.sequencia tt-ae.quantidade tt-ae.data tt-ae.cod-depos tt-ae.localizacao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-ae   
&Scoped-define SELF-NAME br-ae
&Scoped-define OPEN-QUERY-br-ae IF i-tipo = 1 THEN    OPEN QUERY {&SELF-NAME} FOR EACH tt-ae NO-LOCK                                 BY tt-ae.data                                 BY tt-ae.nr-ae                                 BY tt-ae.sequencia. ELSE    OPEN QUERY {&SELF-NAME} FOR EACH tt-ae NO-LOCK                                 BY tt-ae.data                                 BY tt-ae.localizacao.
&Scoped-define TABLES-IN-QUERY-br-ae tt-ae
&Scoped-define FIRST-TABLE-IN-QUERY-br-ae tt-ae


/* Definitions for BROWSE br-saldo                                      */
&Scoped-define FIELDS-IN-QUERY-br-saldo tt-saldo.cod-depos tt-saldo.cod-localiz tt-saldo.quantidade   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-saldo   
&Scoped-define SELF-NAME br-saldo
&Scoped-define QUERY-STRING-br-saldo FOR EACH tt-saldo NO-LOCK BY tt-saldo.cod-depos BY tt-saldo.cod-localiz
&Scoped-define OPEN-QUERY-br-saldo OPEN QUERY {&SELF-NAME} FOR EACH tt-saldo NO-LOCK BY tt-saldo.cod-depos BY tt-saldo.cod-localiz.
&Scoped-define TABLES-IN-QUERY-br-saldo tt-saldo
&Scoped-define FIRST-TABLE-IN-QUERY-br-saldo tt-saldo


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-ae}~
    ~{&OPEN-QUERY-br-saldo}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttitem.it-codigo ttitem.desc-item 
&Scoped-define ENABLED-TABLES ttitem
&Scoped-define FIRST-ENABLED-TABLE ttitem
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys RECT-4 RECT-5 btFirst ~
btPrev btNext btLast btGoTo btSearch btFil btQueryJoins btReportsJoins ~
btExit btHelp br-ae br-saldo fi-saldo-estoq fi-saldo-ae fi-local 
&Scoped-Define DISPLAYED-FIELDS ttitem.it-codigo ttitem.desc-item 
&Scoped-define DISPLAYED-TABLES ttitem
&Scoped-define FIRST-DISPLAYED-TABLE ttitem
&Scoped-Define DISPLAYED-OBJECTS fi-saldo-estoq fi-saldo-ae fi-local 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&éltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V  Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM miCopy         LABEL "&Copiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
       RULE
       MENU-ITEM miUndo         LABEL "&Desfazer"      ACCELERATOR "CTRL-U"
       MENU-ITEM miCancel       LABEL "&Cancelar"      ACCELERATOR "CTRL-F4"
       RULE
       MENU-ITEM miSave         LABEL "&Salvar"        ACCELERATOR "CTRL-S"
       RULE
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
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

DEFINE BUTTON btFil 
     IMAGE-UP FILE "adeicon/filt-u95.bmp":U
     LABEL "Button 1" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image\im-fir":U
     IMAGE-INSENSITIVE FILE "image\ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image\im-las":U
     IMAGE-INSENSITIVE FILE "image\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image\im-nex":U
     IMAGE-INSENSITIVE FILE "image\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image\im-pre":U
     IMAGE-INSENSITIVE FILE "image\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE VARIABLE fi-local AS CHARACTER FORMAT "X(256)":U 
     LABEL "Local PadrÆo" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE fi-saldo-ae AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Saldo AE" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-saldo-estoq AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Saldo Estoq." 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 13.25.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 36 BY 4.25.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-ae FOR 
      tt-ae SCROLLING.

DEFINE QUERY br-saldo FOR 
      tt-saldo SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-ae
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-ae wMaintenance _FREEFORM
  QUERY br-ae DISPLAY
      tt-ae.nr-ae         
    tt-ae.sequencia     
    tt-ae.quantidade    
    tt-ae.data          
    tt-ae.cod-depos     COLUMN-LABEL "Dep¢sito"
    tt-ae.localizacao   COLUMN-LABEL "Localiza‡Æo"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 47 BY 12.25
         FONT 1 FIT-LAST-COLUMN.

DEFINE BROWSE br-saldo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-saldo wMaintenance _FREEFORM
  QUERY br-saldo DISPLAY
      tt-saldo.cod-depos    COLUMN-LABEL "Dep¢sito" 
    tt-saldo.cod-localiz  COLUMN-LABEL "Localiza‡Æo" FORMAT "X(20)" 
    tt-saldo.quantidade
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 36 BY 7.75
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrˆncia"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrˆncia anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrˆncia"
     btLast AT ROW 1.13 COL 13.57 HELP
          "éltima ocorrˆncia"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V  Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btFil AT ROW 1.13 COL 70.57 WIDGET-ID 6
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     ttitem.it-codigo AT ROW 3.25 COL 10 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     ttitem.desc-item AT ROW 3.25 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 64 BY .88
     br-ae AT ROW 5.25 COL 4 WIDGET-ID 300
     br-saldo AT ROW 5.25 COL 54 WIDGET-ID 200
     fi-saldo-estoq AT ROW 13.88 COL 65 COLON-ALIGNED WIDGET-ID 14
     fi-saldo-ae AT ROW 14.92 COL 65 COLON-ALIGNED WIDGET-ID 12
     fi-local AT ROW 16 COL 65 COLON-ALIGNED WIDGET-ID 16
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1
     RECT-4 AT ROW 4.75 COL 1 WIDGET-ID 8
     RECT-5 AT ROW 13.25 COL 54 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.14 BY 17
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttitem T "?" NO-UNDO mgcad item
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenance ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17
         WIDTH              = 90.14
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90.14
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90.14
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenance 
/* ************************* Included-Libraries *********************** */

{maintenance/maintenance.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenance
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB br-ae desc-item fpage0 */
/* BROWSE-TAB br-saldo br-ae fpage0 */
ASSIGN 
       br-ae:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE.

ASSIGN 
       br-saldo:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE.

ASSIGN 
       btFil:AUTO-RESIZE IN FRAME fpage0      = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-ae
/* Query rebuild information for BROWSE br-ae
     _START_FREEFORM
IF i-tipo = 1 THEN
   OPEN QUERY {&SELF-NAME} FOR EACH tt-ae NO-LOCK
                                BY tt-ae.data
                                BY tt-ae.nr-ae
                                BY tt-ae.sequencia.
ELSE
   OPEN QUERY {&SELF-NAME} FOR EACH tt-ae NO-LOCK
                                BY tt-ae.data
                                BY tt-ae.localizacao.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-ae */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-saldo
/* Query rebuild information for BROWSE br-saldo
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-saldo NO-LOCK BY tt-saldo.cod-depos BY tt-saldo.cod-localiz.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-saldo */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON END-ERROR OF wMaintenance
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON WINDOW-CLOSE OF wMaintenance
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-ae
&Scoped-define SELF-NAME br-ae
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-ae wMaintenance
ON MOUSE-SELECT-DBLCLICK OF br-ae IN FRAME fpage0
DO:
    APPLY "return" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-ae wMaintenance
ON RETURN OF br-ae IN FRAME fpage0
DO:
    IF AVAIL tt-ae THEN DO:
        FIND FIRST ficha-cq NO-LOCK
            WHERE ficha-cq.nr-ficha = tt-ae.roteiro NO-ERROR.
        IF AVAIL ficha-cq THEN
            RUN esp/cep/escep005a.w (INPUT tt-ae.roteiro).
        ELSE DO:
            MESSAGE "Erro na ficha da AE. Verifique com Almoxarifado"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMaintenance
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFil
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFil wMaintenance
ON CHOOSE OF btFil IN FRAME fpage0 /* Button 1 */
DO:
    DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
         LABEL "Cancel" 
         SIZE 10 BY 1.13
         BGCOLOR 8 .
    
    DEFINE BUTTON Btn_OK AUTO-GO 
         LABEL "OK" 
         SIZE 10 BY 1.13
         BGCOLOR 8 .
    
    DEFINE VARIABLE fi-cod-estabel AS CHARACTER FORMAT "x(3)" 
         LABEL "Estab.":R10 
         VIEW-AS FILL-IN 
         SIZE 5 BY .88.

    DEFINE VARIABLE fi-cod-depos-fim AS CHARACTER FORMAT "x(3)" 
         VIEW-AS FILL-IN 
         SIZE 5 BY .88.
    
    DEFINE VARIABLE fi-cod-depos-ini AS CHARACTER FORMAT "x(3)" 
         LABEL "Dep¢sito":R10 
         VIEW-AS FILL-IN 
         SIZE 5 BY .88.
    
    DEFINE IMAGE IMAGE-3
         FILENAME "image/im-fir.bmp":U
         SIZE 3 BY 1.
    
    DEFINE IMAGE IMAGE-4
         FILENAME "image/im-las.bmp":U
         SIZE 3 BY 1.
    
    DEFINE VARIABLE rs-tipo AS INTEGER 
         VIEW-AS RADIO-SET HORIZONTAL
         RADIO-BUTTONS 
              "Total", 1,
    "Parcial", 2
         SIZE 32 BY .88 NO-UNDO.
    
    DEFINE RECTANGLE RECT-17
         EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
         SIZE 64.14 BY 2.5.
    
    DEFINE RECTANGLE RECT-18
         EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
         SIZE 64.14 BY 2.
    
    DEFINE RECTANGLE rtToolBar
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 64.14 BY 1.5
         BGCOLOR 7 .
    
    
    /* ************************  Frame Definitions  *********************** */
    
    DEFINE FRAME fFiltro
         fi-cod-estabel   AT ROW 1.30 COL 18 COLON-ALIGNED
         fi-cod-depos-ini AT ROW 2.30 COL 18 COLON-ALIGNED
         fi-cod-depos-fim AT ROW 2.30 COL 35 COLON-ALIGNED NO-LABEL
         rs-tipo AT ROW 4.25 COL 17 NO-LABEL
         Btn_OK AT ROW 6.25 COL 2
         Btn_Cancel AT ROW 6.25 COL 12
         IMAGE-3 AT ROW 2.30 COL 25
         IMAGE-4 AT ROW 2.30 COL 34
         RECT-17 AT ROW 1 COL 1
         RECT-18 AT ROW 3.75 COL 1
         rtToolBar AT ROW 6 COL 1
         SPACE(0.00) SKIP(0.07)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
             SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
             FONT 1
             TITLE "Filtro"
             DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.
    
      ASSIGN fi-cod-estabel   = c-cod-estabel
             fi-cod-depos-ini = c-cod-depos-ini 
             fi-cod-depos-fim = c-cod-depos-fim
             rs-tipo          = i-tipo.
    
      DISPLAY fi-cod-estabel fi-cod-depos-ini fi-cod-depos-fim rs-tipo 
          WITH FRAME fFiltro.
    
      ENABLE fi-cod-estabel fi-cod-depos-ini fi-cod-depos-fim rs-tipo Btn_OK Btn_Cancel IMAGE-3 IMAGE-4 
             RECT-17 RECT-18 rtToolBar 
          WITH FRAME fFiltro.
    
      ON CHOOSE OF Btn_OK IN FRAME fFiltro DO:
          ASSIGN c-cod-estabel   = INPUT FRAME fFiltro fi-cod-estabel
                 c-cod-depos-ini = INPUT FRAME fFiltro fi-cod-depos-ini
                 c-cod-depos-fim = INPUT FRAME fFiltro fi-cod-depos-fim
                 i-tipo          = INPUT FRAME fFiltro rs-tipo.

          APPLY "GO":U TO FRAME fFiltro.
          RUN pi-calcula. 
      END.


      WAIT-FOR "GO" OF FRAME fFiltro. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMaintenance
ON CHOOSE OF btFirst IN FRAME fpage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMaintenance
ON CHOOSE OF btGoTo IN FRAME fpage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenance
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMaintenance
ON CHOOSE OF btLast IN FRAME fpage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMaintenance
ON CHOOSE OF btNext IN FRAME fpage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMaintenance
ON CHOOSE OF btPrev IN FRAME fpage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMaintenance
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMaintenance
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    /* RUN showReportsJoins IN THIS-PROCEDURE. */
    RUN esp/cep/escep005b.w (INPUT ttitem.it-codigo,
                             INPUT c-cod-estabel,
                             INPUT TABLE tt-ae).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    DEFINE VARIABLE cStatus AS CHAR NO-UNDO.
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.   

    {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                       &campo="ttitem.it-codigo"    
                       &campo2="ttitem.desc-item"
                       &campozoom="it-codigo"
                       &campozoom2="desc-item"
                       &frame="fpage0"
                       &frame2="fpage0"}

      
    IF VALID-HANDLE(wh-pesquisa) THEN
        WAIT-FOR CLOSE OF wh-pesquisa.

    RUN goToKey IN {&hDBOTable} (INPUT FRAME fPage0 ttitem.it-codigo ).
    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Item":U).
        RETURN NO-APPLY.
    END.

    /*:T Retorna rowid do registro corrente do DBO */
    RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).

    /*:T Reposiciona registro com base em um rowid */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wMaintenance
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenance/mainblock.i}

ENABLE btFil 
       br-ae  
       br-saldo
       WITH FRAME fPage0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDisplayFields wMaintenance 
PROCEDURE AfterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN pi-calcula. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V  Para
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUTTON btGoToCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btGoToOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE c-it-codigo LIKE {&ttTable}.it-codigo NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        c-it-codigo  AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para ITEM" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_Item"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-it-codigo.
        
        RUN goToKey IN {&hDBOTable} (INPUT c-it-codigo).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "<Table>":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-it-codigo btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenance 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "inbo\boin172q01.r":U THEN DO:
        {btb/btb008za.i1 inbo\boin172q01.r YES}
        {btb/btb008za.i2 inbo\boin172q01.r '' {&hDBOTable}}
    END.
        
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula wMaintenance 
PROCEDURE pi-calcula :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-ae.
    EMPTY TEMP-TABLE tt-saldo.

    ASSIGN d-saldo-tot-ae  = 0
           d-saldo-tot-est = 0
           c-local         = "".

    IF c-cod-estabel = "" THEN
        ASSIGN c-cod-estabel = v_cod_estab_usuar.

    /* Saldo considerando saldo-estoq */
    FOR EACH saldo-estoq NO-LOCK
       WHERE saldo-estoq.cod-estabel  = c-cod-estabel
         AND saldo-estoq.cod-depos    >= c-cod-depos-ini
         AND saldo-estoq.cod-depos    <= c-cod-depos-fim
         AND saldo-estoq.it-codigo    = INPUT FRAME fPage0 ttitem.it-codigo
         AND saldo-estoq.qtidade-atu <> 0:

        
        CREATE tt-saldo.
        ASSIGN tt-saldo.cod-depos     = saldo-estoq.cod-depos   
               tt-saldo.cod-localiz   = saldo-estoq.cod-localiz 
               tt-saldo.quantidade    = (saldo-estoq.qtidade-atu  - 
                                         saldo-estoq.qt-aloc-prod - 
                                         saldo-estoq.qt-aloc-ped  - 
                                         saldo-estoq.qt-alocada)
               d-saldo-tot-est        = d-saldo-tot-est + 
                                        (saldo-estoq.qtidade-atu  - 
                                         saldo-estoq.qt-aloc-prod - 
                                         saldo-estoq.qt-aloc-ped  - 
                                         saldo-estoq.qt-alocada).
    
    END.
    
    /* Saldo considerando AE */
    IF i-tipo = 1 then do: /* Total */
        for each ae-item no-lock
            where ae-item.cod-estabel = c-cod-estabel
              and ae-item.it-codigo   = INPUT FRAME fPage0 ttitem.it-codigo     
              and ae-item.situacao    = NO 
              and ae-item.cod-depos  >= c-cod-depos-ini
              and ae-item.cod-depos  <= c-cod-depos-fim
              break by ae-item.data
                    by ae-item.localizacao:
    
            create tt-ae.
            assign tt-ae.nr-ae       = ae-item.nr-ae
                   tt-ae.sequencia   = ae-item.sequencia
                   tt-ae.quantidade  = ae-item.quantidade
                   tt-ae.data        = ae-item.data
                   tt-ae.localizacao = ae-item.localizacao
                   tt-ae.cod-depos   = ae-item.cod-depos
                   tt-ae.roteiro     = ae-item.roteiro
                   d-saldo-tot-ae    = d-saldo-tot-ae + ae-item.quantidade.
        end.
    end.
    else do: /* Parcial */
        for each ae-item no-lock
            where ae-item.cod-estabel = c-cod-estabel
              and ae-item.it-codigo   = INPUT FRAME fPage0 ttitem.it-codigo     
              and ae-item.situacao    = NO 
              and ae-item.cod-depos  >= c-cod-depos-ini
              and ae-item.cod-depos  <= c-cod-depos-fim
              break by ae-item.nr-ae
                    by ae-item.localizacao:
        
            if first-of(ae-item.localizacao) then do:
    
                create tt-ae.
                assign tt-ae.nr-ae         = ae-item.nr-ae
                       tt-ae.data          = ae-item.data
                       tt-ae.localizacao   = ae-item.localizacao
                       tt-ae.cod-depos     = ae-item.cod-depos
                       tt-ae.roteiro       = ae-item.roteiro.
            end.
    
            assign tt-ae.quantidade = tt-ae.quantidade + 1
                   d-saldo-tot-ae   = d-saldo-tot-ae   + 1. 
        end.
    end.

    {&OPEN-QUERY-br-ae}
    {&OPEN-QUERY-br-saldo}

    FIND FIRST item-uni-estab NO-LOCK
         WHERE item-uni-estab.cod-estabel = c-cod-estabel
           AND item-uni-estab.it-codigo   = INPUT FRAME fPage0 ttitem.it-codigo NO-ERROR.
    IF AVAIL item-uni-estab THEN
        ASSIGN c-local = item-uni-estab.cod-localiz.
    ELSE DO:
        FIND FIRST ITEM NO-LOCK 
            WHERE ITEM.it-codigo = INPUT FRAME fPage0 ttitem.it-codigo NO-ERROR. 
        ASSIGN c-local = IF AVAIL ITEM THEN ITEM.cod-localiz ELSE "".
    END.

    ASSIGN fi-saldo-ae    = d-saldo-tot-ae
           fi-saldo-estoq = d-saldo-tot-est
           fi-local       = c-local.

    DISP fi-saldo-ae 
         fi-saldo-estoq 
         fi-local WITH FRAME FPage0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

