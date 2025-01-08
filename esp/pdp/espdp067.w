&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-int-licenca-softphone NO-UNDO LIKE int-licenca-softphone
       FIELD r-Rowid AS ROWID.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESPDP067 2.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESPDP067
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Licenáas

&GLOBAL-DEFINE page0Widgets   btFilter btImportCSV btQueryJoins btReportsJoins btExit btHelp
&GLOBAL-DEFINE page1Widgets   brLicenca btAdd btUpdate btDelete btDetalheNF btDetalhePedido

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE hBoes601     AS HANDLE      NO-UNDO.
DEFINE VARIABLE iRows        AS INTEGER     NO-UNDO.
DEFINE VARIABLE hPrograma    AS HANDLE      NO-UNDO.
DEFINE VARIABLE hProgramaCSV AS HANDLE      NO-UNDO.

DEFINE VARIABLE v-coluna AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-asc    AS LOGICAL     NO-UNDO.

DEFINE VARIABLE v-desc-item AS CHARACTER   NO-UNDO.

DEFINE VARIABLE h-ft0904  AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-pd1001a AS HANDLE      NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE gr-nota-fiscal AS ROWID       NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gr-ped-venda   AS ROWID       NO-UNDO.

DEFINE VARIABLE v-it-codigo-ini   LIKE int-licenca-softphone.it-codigo   NO-UNDO VIEW-AS FILL-IN SIZE 17 BY 0.88.
DEFINE VARIABLE v-it-codigo-fin   LIKE int-licenca-softphone.it-codigo   NO-UNDO VIEW-AS FILL-IN SIZE 17 BY 0.88.
DEFINE VARIABLE v-it-fornec-ini   LIKE int-licenca-softphone.it-fornec   NO-UNDO VIEW-AS FILL-IN SIZE 17 BY 0.88.
DEFINE VARIABLE v-it-fornec-fin   LIKE int-licenca-softphone.it-fornec   NO-UNDO VIEW-AS FILL-IN SIZE 17 BY 0.88.
DEFINE VARIABLE v-licenca-ini     LIKE int-licenca-softphone.licenca     NO-UNDO VIEW-AS FILL-IN SIZE 41 BY 0.88.
DEFINE VARIABLE v-licenca-fin     LIKE int-licenca-softphone.licenca     NO-UNDO VIEW-AS FILL-IN SIZE 41 BY 0.88.
DEFINE VARIABLE v-nome-abrev-ini  LIKE int-licenca-softphone.nome-abrev  NO-UNDO VIEW-AS FILL-IN SIZE 13 BY 0.88.
DEFINE VARIABLE v-nome-abrev-fin  LIKE int-licenca-softphone.nome-abrev  NO-UNDO VIEW-AS FILL-IN SIZE 13 BY 0.88.
DEFINE VARIABLE v-nr-pedcli-ini   LIKE int-licenca-softphone.nr-pedcli   NO-UNDO VIEW-AS FILL-IN SIZE 13 BY 0.88.
DEFINE VARIABLE v-nr-pedcli-fin   LIKE int-licenca-softphone.nr-pedcli   NO-UNDO VIEW-AS FILL-IN SIZE 13 BY 0.88.
DEFINE VARIABLE v-cod-estabel-ini LIKE int-licenca-softphone.cod-estabel NO-UNDO VIEW-AS FILL-IN SIZE 4  BY 0.88.
DEFINE VARIABLE v-cod-estabel-fin LIKE int-licenca-softphone.cod-estabel NO-UNDO VIEW-AS FILL-IN SIZE 4  BY 0.88.
DEFINE VARIABLE v-serie-ini       LIKE int-licenca-softphone.serie       NO-UNDO VIEW-AS FILL-IN SIZE 6  BY 0.88.
DEFINE VARIABLE v-serie-fin       LIKE int-licenca-softphone.serie       NO-UNDO VIEW-AS FILL-IN SIZE 6  BY 0.88.
DEFINE VARIABLE v-nr-nota-fis-ini LIKE int-licenca-softphone.nr-nota-fis NO-UNDO VIEW-AS FILL-IN SIZE 17 BY 0.88.
DEFINE VARIABLE v-nr-nota-fis-fin LIKE int-licenca-softphone.nr-nota-fis NO-UNDO VIEW-AS FILL-IN SIZE 17 BY 0.88.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brLicenca

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-int-licenca-softphone

/* Definitions for BROWSE brLicenca                                     */
&Scoped-define FIELDS-IN-QUERY-brLicenca tt-int-licenca-softphone.it-codigo ~
fn-desc-item(tt-int-licenca-softphone.it-codigo) @ v-desc-item ~
tt-int-licenca-softphone.it-fornec tt-int-licenca-softphone.licenca ~
tt-int-licenca-softphone.nome-abrev tt-int-licenca-softphone.nr-pedcli ~
tt-int-licenca-softphone.cod-estabel tt-int-licenca-softphone.serie ~
tt-int-licenca-softphone.nr-nota-fis 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brLicenca 
&Scoped-define QUERY-STRING-brLicenca FOR EACH tt-int-licenca-softphone NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brLicenca OPEN QUERY brLicenca FOR EACH tt-int-licenca-softphone NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brLicenca tt-int-licenca-softphone
&Scoped-define FIRST-TABLE-IN-QUERY-brLicenca tt-int-licenca-softphone


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brLicenca}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 btFilter btImportCSV ~
btQueryJoins btReportsJoins btExit btHelp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-desc-item wWindow 
FUNCTION fn-desc-item RETURNS CHARACTER
  ( p-it-codigo AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
       RULE
       MENU-ITEM miDetalheNF    LABEL "Detalhe &Nota Fiscal"
       MENU-ITEM miDetalhePedido LABEL "Detalhe &Pedido"
       RULE
       MENU-ITEM miFilter       LABEL "&Filtro"       
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
DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFilter 
     IMAGE-UP FILE "image/im-fil.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-fil.bmp":U
     LABEL "&Filtro" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btImportCSV 
     IMAGE-UP FILE "image/excel.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-excel.gif":U
     LABEL "Button 6" 
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

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btAdd 
     LABEL "&Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDelete 
     LABEL "&Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btDetalheNF 
     LABEL "Detalhe NF" 
     SIZE 10 BY 1.

DEFINE BUTTON btDetalhePedido 
     LABEL "Det. Pedido" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdate 
     LABEL "&Alterar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brLicenca FOR 
      tt-int-licenca-softphone SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brLicenca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brLicenca wWindow _STRUCTURED
  QUERY brLicenca NO-LOCK DISPLAY
      tt-int-licenca-softphone.it-codigo FORMAT "x(16)":U WIDTH 13.43
      fn-desc-item(tt-int-licenca-softphone.it-codigo) @ v-desc-item COLUMN-LABEL "Descriá∆o" FORMAT "x(60)":U
            WIDTH 33.43
      tt-int-licenca-softphone.it-fornec FORMAT "x(16)":U WIDTH 13
      tt-int-licenca-softphone.licenca FORMAT "x(40)":U
      tt-int-licenca-softphone.nome-abrev FORMAT "x(12)":U
      tt-int-licenca-softphone.nr-pedcli FORMAT "x(12)":U
      tt-int-licenca-softphone.cod-estabel FORMAT "x(3)":U
      tt-int-licenca-softphone.serie FORMAT "x(5)":U
      tt-int-licenca-softphone.nr-nota-fis FORMAT "x(16)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 11.75
         FONT 2 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btFilter AT ROW 1.13 COL 1.57
     btImportCSV AT ROW 1.13 COL 66.72
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.96
         FONT 1.

DEFINE FRAME fPage1
     brLicenca AT ROW 1.17 COL 2
     btAdd AT ROW 12.96 COL 2 HELP
          "Incluir Registro"
     btUpdate AT ROW 12.96 COL 12 HELP
          "Alterar Registro"
     btDelete AT ROW 12.96 COL 22 HELP
          "Eliminar Registro"
     btDetalhePedido AT ROW 12.96 COL 32 HELP
          "Detalhe do Pedido"
     btDetalheNF AT ROW 12.96 COL 42 HELP
          "Detalhe da Nota Fiscal"
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 84.43 BY 13.25
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-int-licenca-softphone T "?" NO-UNDO mgesp int-licenca-softphone
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 16.96
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brLicenca 1 fPage1 */
ASSIGN 
       brLicenca:ALLOW-COLUMN-SEARCHING IN FRAME fPage1 = TRUE
       brLicenca:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brLicenca
/* Query rebuild information for BROWSE brLicenca
     _TblList          = "Temp-Tables.tt-int-licenca-softphone"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST USED"
     _FldNameList[1]   > Temp-Tables.tt-int-licenca-softphone.it-codigo
"tt-int-licenca-softphone.it-codigo" ? ? "character" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fn-desc-item(tt-int-licenca-softphone.it-codigo) @ v-desc-item" "Descriá∆o" "x(60)" ? ? ? ? ? ? ? no "Descriá∆o do Item" no no "33.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-int-licenca-softphone.it-fornec
"tt-int-licenca-softphone.it-fornec" ? ? "character" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = Temp-Tables.tt-int-licenca-softphone.licenca
     _FldNameList[5]   = Temp-Tables.tt-int-licenca-softphone.nome-abrev
     _FldNameList[6]   = Temp-Tables.tt-int-licenca-softphone.nr-pedcli
     _FldNameList[7]   = Temp-Tables.tt-int-licenca-softphone.cod-estabel
     _FldNameList[8]   = Temp-Tables.tt-int-licenca-softphone.serie
     _FldNameList[9]   = Temp-Tables.tt-int-licenca-softphone.nr-nota-fis
     _Query            is OPENED
*/  /* BROWSE brLicenca */
&ANALYZE-RESUME

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


&Scoped-define BROWSE-NAME brLicenca
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brLicenca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brLicenca wWindow
ON CTRL-A OF brLicenca IN FRAME fPage1
DO:
    IF btUpdate:SENSITIVE IN FRAME fPage1 THEN
        APPLY "CHOOSE":U TO btUpdate IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brLicenca wWindow
ON CTRL-DEL OF brLicenca IN FRAME fPage1
DO:
    IF btDelete:SENSITIVE IN FRAME fPage1 THEN
        APPLY "CHOOSE":U TO btDelete IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brLicenca wWindow
ON CTRL-INS OF brLicenca IN FRAME fPage1
DO:
    IF btAdd:SENSITIVE IN FRAME fPage1 THEN
        APPLY "CHOOSE":U TO btAdd IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brLicenca wWindow
ON MOUSE-SELECT-DBLCLICK OF brLicenca IN FRAME fPage1
DO:
    APPLY "CTRL-A":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brLicenca wWindow
ON START-SEARCH OF brLicenca IN FRAME fPage1
DO:
    DEFINE VARIABLE i-cont  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-index AS INTEGER     NO-UNDO.

    IF v-coluna <> SELF:CURRENT-COLUMN:NAME THEN
        ASSIGN v-coluna = SELF:CURRENT-COLUMN:NAME
               l-asc    = YES.
    ELSE
        ASSIGN l-asc = NOT l-asc.

    SELF:CLEAR-SORT-ARROWS().

    IF SELF:CURRENT-COLUMN:TABLE <> "":U AND SELF:CURRENT-COLUMN:TABLE <> ? THEN DO:
        IF l-asc THEN
            SELF:QUERY:QUERY-PREPARE("FOR EACH tt-int-licenca-softphone ":U +
                                     "    OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME).
        ELSE
            SELF:QUERY:QUERY-PREPARE("FOR EACH tt-int-licenca-softphone ":U +
                                     "    OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME + " DESC":U).

        DO i-cont = 1 TO SELF:NUM-COLUMNS:
            IF SELF:CURRENT-COLUMN = SELF:GET-BROWSE-COLUMN(i-cont) THEN
                ASSIGN i-index = i-cont.
        END.

        SELF:SET-SORT-ARROW(i-index, l-asc).

        SELF:QUERY:QUERY-OPEN().
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wWindow
ON CHOOSE OF btAdd IN FRAME fPage1 /* Incluir */
DO:
    RUN piCadastro (INPUT ?,
                    INPUT "Add":U,
                    INPUT "esp/pdp/espdp067b.w":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wWindow
ON CHOOSE OF btDelete IN FRAME fPage1 /* Eliminar */
DO:
    RUN piDelete.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDetalheNF
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDetalheNF wWindow
ON CHOOSE OF btDetalheNF IN FRAME fPage1 /* Detalhe NF */
DO:
    RUN piDetalheNF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDetalhePedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDetalhePedido wWindow
ON CHOOSE OF btDetalhePedido IN FRAME fPage1 /* Det. Pedido */
DO:
    RUN piDetalhePedido.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFilter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFilter wWindow
ON CHOOSE OF btFilter IN FRAME fpage0 /* Filtro */
OR CHOOSE OF MENU-ITEM miFilter IN MENU mbMain DO:
    RUN piFilter IN THIS-PROCEDURE.
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


&Scoped-define SELF-NAME btImportCSV
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImportCSV wWindow
ON CHOOSE OF btImportCSV IN FRAME fpage0 /* Button 6 */
DO:
    RUN piImportCSV.
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


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wWindow
ON CHOOSE OF btUpdate IN FRAME fPage1 /* Alterar */
DO:
    IF AVAILABLE tt-int-licenca-softphone THEN DO:
        RUN piCadastro (INPUT tt-int-licenca-softphone.r-Rowid,
                        INPUT "Update":U,
                        INPUT "esp/pdp/espdp067b.w":U).
    END.
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


&Scoped-define SELF-NAME miAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAdd wWindow
ON CHOOSE OF MENU-ITEM miAdd /* Incluir */
DO:
    IF btAdd:SENSITIVE IN FRAME fPage1 THEN
        APPLY "CHOOSE":U TO btAdd IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miDelete wWindow
ON CHOOSE OF MENU-ITEM miDelete /* Eliminar */
DO:
    IF btDelete:SENSITIVE IN FRAME fPage1 THEN
        APPLY "CHOOSE":U TO btDelete IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miDetalheNF
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miDetalheNF wWindow
ON CHOOSE OF MENU-ITEM miDetalheNF /* Detalhe Nota Fiscal */
DO:
    IF btDetalheNF:SENSITIVE IN FRAME fPage1 THEN
        APPLY "CHOOSE":U TO btDetalheNF IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miDetalhePedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miDetalhePedido wWindow
ON CHOOSE OF MENU-ITEM miDetalhePedido /* Detalhe Pedido */
DO:
    IF btDetalhePedido:SENSITIVE IN FRAME fPage1 THEN
        APPLY "CHOOSE":U TO btDetalhePedido IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miUpdate wWindow
ON CHOOSE OF MENU-ITEM miUpdate /* Alterar */
DO:
    IF btUpdate:SENSITIVE IN FRAME fPage1 THEN
        APPLY "CHOOSE":U TO btUpdate IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(hBoes601) THEN
        DELETE PROCEDURE hBoes601.

    ASSIGN hBoes601 = ?.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN v-it-codigo-ini   = "":U
           v-it-codigo-fin   = FILL("Z":U, 16)
           v-it-fornec-ini   = "":U
           v-it-fornec-fin   = FILL("Z":U, 16)
           v-licenca-ini     = "":U
           v-licenca-fin     = FILL("Z":U, 40)
           v-nome-abrev-ini  = "":U
           v-nome-abrev-fin  = FILL("Z":U, 12)
           v-nr-pedcli-ini   = "":U
           v-nr-pedcli-fin   = FILL("Z":U, 12)
           v-cod-estabel-ini = "":U
           v-cod-estabel-fin = FILL("Z":U, 3)
           v-serie-ini       = "":U
           v-serie-fin       = FILL("Z":U, 5)
           v-nr-nota-fis-ini = "":U
           v-nr-nota-fis-fin = FILL("Z":U, 16).

    RUN piOpenQueryBrLicenca (INPUT ?).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCadastro wWindow 
PROCEDURE piCadastro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pRowid    AS ROWID       NO-UNDO.
    DEFINE INPUT  PARAMETER pAcao     AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pPrograma AS CHARACTER   NO-UNDO.

    SESSION:SET-WAIT-STATE("GENERAL":U).

    RUN VALUE(pPrograma) PERSISTENT SET hPrograma (INPUT  pRowid,
                                                   INPUT  pAcao,
                                                   INPUT THIS-PROCEDURE).

    IF VALID-HANDLE(hPrograma)             AND
       hPrograma:TYPE      = "PROCEDURE":U AND
       hPrograma:FILE-NAME = pPrograma     THEN
        RUN initializeInterface IN hPrograma.

    SESSION:SET-WAIT-STATE("":U).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDelete wWindow 
PROCEDURE piDelete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    SESSION:SET-WAIT-STATE("GENERAL":U).
    IF AVAILABLE tt-int-licenca-softphone THEN DO:
        SESSION:SET-WAIT-STATE("":U).

        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 550,
                           INPUT "":U).

        SESSION:SET-WAIT-STATE("GENERAL":U).

        IF RETURN-VALUE = "YES":U THEN DO:
            IF NOT VALID-HANDLE(hBoes601) THEN
                RUN esbo/boes601.p PERSISTENT SET hBoes601.

            RUN repositionRecord IN hBoes601 (INPUT tt-int-licenca-softphone.r-Rowid).

            IF RETURN-VALUE = "OK":U THEN DO:
                RUN deleteRecord IN hBoes601.

                IF RETURN-VALUE = "NOK":U THEN DO:
                    RUN getRowErrors IN hBoes601 (OUTPUT TABLE RowErrors).

                    IF CAN-FIND(FIRST RowErrors
                                WHERE RowErrors.ErrorType   = "INTERNAL":U
                                  AND RowErrors.ErrorNumber = 8) THEN DO:
                    END.
                    ELSE IF NOT CAN-FIND(FIRST RowErrors
                                         WHERE RowErrors.ErrorType   = "INTERNAL":U
                                           AND RowErrors.ErrorNumber = 10) THEN DO:
                        SESSION:SET-WAIT-STATE("":U).

                        {method/showmessage.i1}
                        {method/showmessage.i2 &Modal="YES"}
                        {method/showmessage.i3}

                        RETURN NO-APPLY.
                    END.
                END.

                RUN piOpenQueryBrLicenca (INPUT ?).
            END.
            ELSE DO:
                RUN getRowErrors IN hBoes601 (OUTPUT TABLE RowErrors).

                SESSION:SET-WAIT-STATE("":U).

                IF CAN-FIND(FIRST RowErrors) THEN DO:
                    {method/showmessage.i1}
                    {method/showmessage.i2 &Modal="YES"}
                    {method/showmessage.i3}
                END.

                RETURN NO-APPLY.
            END.
        END.
    END.
    SESSION:SET-WAIT-STATE("":U).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDetalheNF wWindow 
PROCEDURE piDetalheNF :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    SESSION:SET-WAIT-STATE("GENERAL":U).

    IF AVAILABLE tt-int-licenca-softphone             AND
       (tt-int-licenca-softphone.cod-estabel <> "":U  OR
        tt-int-licenca-softphone.serie       <> "":U  OR
        tt-int-licenca-softphone.nr-nota-fis <> "":U) THEN DO:
        FIND FIRST nota-fiscal
            WHERE nota-fiscal.cod-estabel = tt-int-licenca-softphone.cod-estabel
              AND nota-fiscal.serie       = tt-int-licenca-softphone.serie
              AND nota-fiscal.nr-nota-fis = tt-int-licenca-softphone.nr-nota-fis NO-LOCK NO-ERROR.

        IF NOT AVAILABLE nota-fiscal THEN DO:
            SESSION:SET-WAIT-STATE("":U).

            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Nota fiscal n∆o encontrada.":U +
                                     "~~":U +
                                     "Nota fiscal n∆o encontrada.":U + CHR(10) +
                                     "Estab.: ":U + tt-int-licenca-softphone.cod-estabel + CHR(10) +
                                     "SÇrie: ":U + tt-int-licenca-softphone.serie + CHR(10) +
                                     "Nro Nota Fiscal: ":U + tt-int-licenca-softphone.nr-nota-fis).

            RETURN NO-APPLY.
        END.

        ASSIGN gr-nota-fiscal = ROWID(nota-fiscal).

        IF NOT VALID-HANDLE(h-ft0904) THEN
            RUN ftp/ft0904.w PERSISTENT SET h-ft0904.

        RUN dispatch IN h-ft0904 (INPUT "Initialize":U).

        IF VALID-HANDLE(h-ft0904) THEN
            DELETE PROCEDURE h-ft0904.
    END.

    SESSION:SET-WAIT-STATE("":U).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDetalhePedido wWindow 
PROCEDURE piDetalhePedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    SESSION:SET-WAIT-STATE("GENERAL":U).

    IF AVAILABLE tt-int-licenca-softphone            AND
       (tt-int-licenca-softphone.nome-abrev <> "":U  OR
        tt-int-licenca-softphone.nr-pedcli  <> "":U) THEN DO:
        FIND FIRST ped-venda
            WHERE ped-venda.nome-abrev = tt-int-licenca-softphone.nome-abrev
              AND ped-venda.nr-pedcli  = tt-int-licenca-softphone.nr-pedcli NO-LOCK NO-ERROR.

        IF NOT AVAILABLE ped-venda THEN DO:
            SESSION:SET-WAIT-STATE("":U).

            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Pedido n∆o encontrado.":U +
                                     "~~":U +
                                     "Pedido n∆o encontrado.":U + CHR(10) +
                                     "Cliente: ":U + tt-int-licenca-softphone.nome-abrev + CHR(10) +
                                     "Pedido Cliente: ":U + tt-int-licenca-softphone.nr-pedcli).

            RETURN NO-APPLY.
        END.

        ASSIGN gr-ped-venda = ROWID(ped-venda).

        IF NOT VALID-HANDLE(h-pd1001a) THEN
            RUN pdp/pd1001a.w PERSISTENT SET h-pd1001a.

        RUN dispatch IN h-pd1001a (INPUT "Initialize":U).

        IF VALID-HANDLE(h-pd1001a) THEN
            DELETE PROCEDURE h-pd1001a.

    END.

    SESSION:SET-WAIT-STATE("":U).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piFilter wWindow 
PROCEDURE piFilter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE IMAGE IMAGE-1
        FILENAME "image\im-fir":U
        SIZE 3 BY 0.88.

    DEFINE IMAGE IMAGE-2
        FILENAME "image\im-las":U
        SIZE 3 BY 0.88.

    DEFINE IMAGE IMAGE-3
        FILENAME "image\im-fir":U
        SIZE 3 BY 0.88.

    DEFINE IMAGE IMAGE-4
        FILENAME "image\im-las":U
        SIZE 3 BY 0.88.

    DEFINE IMAGE IMAGE-5
        FILENAME "image\im-fir":U
        SIZE 3 BY 0.88.

    DEFINE IMAGE IMAGE-6
        FILENAME "image\im-las":U
        SIZE 3 BY 0.88.

    DEFINE IMAGE IMAGE-7
        FILENAME "image\im-fir":U
        SIZE 3 BY 0.88.

    DEFINE IMAGE IMAGE-8
        FILENAME "image\im-las":U
        SIZE 3 BY 0.88.

    DEFINE IMAGE IMAGE-9
        FILENAME "image\im-fir":U
        SIZE 3 BY 0.88.

    DEFINE IMAGE IMAGE-10
        FILENAME "image\im-las":U
        SIZE 3 BY 0.88.

    DEFINE IMAGE IMAGE-11
        FILENAME "image\im-fir":U
        SIZE 3 BY 0.88.

    DEFINE IMAGE IMAGE-12
        FILENAME "image\im-las":U
        SIZE 3 BY 0.88.

    DEFINE IMAGE IMAGE-13
        FILENAME "image\im-fir":U
        SIZE 3 BY 0.88.

    DEFINE IMAGE IMAGE-14
        FILENAME "image\im-las":U
        SIZE 3 BY 0.88.

    DEFINE IMAGE IMAGE-15
        FILENAME "image\im-fir":U
        SIZE 3 BY 0.88.

    DEFINE IMAGE IMAGE-16
        FILENAME "image\im-las":U
        SIZE 3 BY 0.88.

    DEFINE BUTTON btFilterOK AUTO-GO
         LABEL "&OK":U
         SIZE 10 BY 1
         BGCOLOR 8.

    DEFINE BUTTON btFilterCancel AUTO-END-KEY
         LABEL "&Cancelar":U
         SIZE 10 BY 1
         BGCOLOR 8.

    DEFINE RECTANGLE rtFilterButton
         EDGE-PIXELS 2 GRAPHIC-EDGE
         SIZE 112 BY 1.42
         BGCOLOR 7.
    
    DEFINE FRAME fFilterRecord
        v-it-codigo-ini     AT ROW 1.21 COL 55.00 RIGHT-ALIGNED
        IMAGE-1             AT ROW 1.21 COL 56.40
        IMAGE-2             AT ROW 1.21 COL 61.70
        v-it-codigo-fin     AT ROW 1.21 COL 65.00 LEFT-ALIGNED  NO-LABEL
        v-it-fornec-ini     AT ROW 2.21 COL 55.00 RIGHT-ALIGNED
        IMAGE-3             AT ROW 2.21 COL 56.40
        IMAGE-4             AT ROW 2.21 COL 61.70
        v-it-fornec-fin     AT ROW 2.21 COL 65.00 LEFT-ALIGNED  NO-LABEL
        v-licenca-ini       AT ROW 3.21 COL 55.00 RIGHT-ALIGNED
        IMAGE-5             AT ROW 3.21 COL 56.40
        IMAGE-6             AT ROW 3.21 COL 61.70
        v-licenca-fin       AT ROW 3.21 COL 65.00 LEFT-ALIGNED  NO-LABEL
        v-nome-abrev-ini    AT ROW 4.21 COL 55.00 RIGHT-ALIGNED
        IMAGE-7             AT ROW 4.21 COL 56.40
        IMAGE-8             AT ROW 4.21 COL 61.70
        v-nome-abrev-fin    AT ROW 4.21 COL 65.00 LEFT-ALIGNED  NO-LABEL
        v-nr-pedcli-ini     AT ROW 5.21 COL 55.00 RIGHT-ALIGNED
        IMAGE-9             AT ROW 5.21 COL 56.40
        IMAGE-10            AT ROW 5.21 COL 61.70
        v-nr-pedcli-fin     AT ROW 5.21 COL 65.00 LEFT-ALIGNED  NO-LABEL
        v-cod-estabel-ini   AT ROW 6.21 COL 55.00 RIGHT-ALIGNED
        IMAGE-11            AT ROW 6.21 COL 56.40
        IMAGE-12            AT ROW 6.21 COL 61.70
        v-cod-estabel-fin   AT ROW 6.21 COL 65.00 LEFT-ALIGNED  NO-LABEL
        v-serie-ini         AT ROW 7.21 COL 55.00 RIGHT-ALIGNED
        IMAGE-13            AT ROW 7.21 COL 56.40
        IMAGE-14            AT ROW 7.21 COL 61.70
        v-serie-fin         AT ROW 7.21 COL 65.00 LEFT-ALIGNED  NO-LABEL
        v-nr-nota-fis-ini   AT ROW 8.21 COL 55.00 RIGHT-ALIGNED
        IMAGE-15            AT ROW 8.21 COL 56.40
        IMAGE-16            AT ROW 8.21 COL 61.70
        v-nr-nota-fis-fin   AT ROW 8.21 COL 65.00 LEFT-ALIGNED  NO-LABEL
        btFilterOK          AT ROW 9.63 COL 2.14
        btFilterCancel      AT ROW 9.63 COL 13
        rtFilterButton      AT ROW 9.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Filtro" FONT 1
             DEFAULT-BUTTON btFilterOK CANCEL-BUTTON btFilterCancel.

    ON "CHOOSE":U OF btFilterOK IN FRAME fFilterRecord DO:
        ASSIGN v-it-codigo-ini
               v-it-codigo-fin
               v-it-fornec-ini
               v-it-fornec-fin
               v-licenca-ini
               v-licenca-fin
               v-nome-abrev-ini
               v-nome-abrev-fin
               v-nr-pedcli-ini
               v-nr-pedcli-fin
               v-cod-estabel-ini
               v-cod-estabel-fin
               v-serie-ini
               v-serie-fin
               v-nr-nota-fis-ini
               v-nr-nota-fis-fin.

        RUN piOpenQueryBrLicenca IN THIS-PROCEDURE (INPUT ?).

        APPLY "GO":U TO FRAME fFilterRecord.
    END.
    
    ENABLE v-it-codigo-ini
           v-it-codigo-fin
           v-it-fornec-ini
           v-it-fornec-fin
           v-licenca-ini
           v-licenca-fin
           v-nome-abrev-ini
           v-nome-abrev-fin
           v-nr-pedcli-ini
           v-nr-pedcli-fin
           v-cod-estabel-ini
           v-cod-estabel-fin
           v-serie-ini
           v-serie-fin
           v-nr-nota-fis-ini
           v-nr-nota-fis-fin
           btFilterOK
           btFilterCancel 
        WITH FRAME fFilterRecord.

    DISPLAY v-it-codigo-ini
            v-it-codigo-fin
            v-it-fornec-ini
            v-it-fornec-fin
            v-licenca-ini
            v-licenca-fin
            v-nome-abrev-ini
            v-nome-abrev-fin
            v-nr-pedcli-ini
            v-nr-pedcli-fin
            v-cod-estabel-ini
            v-cod-estabel-fin
            v-serie-ini
            v-serie-fin
            v-nr-nota-fis-ini
            v-nr-nota-fis-fin
        WITH FRAME fFilterRecord.
    
    WAIT-FOR "GO":U OF FRAME fFilterRecord.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piImportCSV wWindow 
PROCEDURE piImportCSV :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    SESSION:SET-WAIT-STATE("GENERAL":U).

    RUN esp/pdp/espdp067a.w PERSISTENT SET hProgramaCSV (INPUT THIS-PROCEDURE).

    IF VALID-HANDLE(hProgramaCSV)             AND
       hProgramaCSV:TYPE      = "PROCEDURE":U AND
       hProgramaCSV:FILE-NAME = "esp/pdp/espdp067a.w":U     THEN
        RUN initializeInterface IN hProgramaCSV.

    SESSION:SET-WAIT-STATE("":U).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piOpenQueryBrLicenca wWindow 
PROCEDURE piOpenQueryBrLicenca :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER rRowidRegistro AS ROWID       NO-UNDO.

    SESSION:SET-WAIT-STATE("GENERAL":U).

    IF NOT VALID-HANDLE(hBoes601) THEN
        RUN esbo/boes601.p PERSISTENT SET hBoes601.

    RUN setConstraintFiltro IN hBoes601 (INPUT v-it-codigo-ini,
                                         INPUT v-it-codigo-fin,
                                         INPUT v-it-fornec-ini,
                                         INPUT v-it-fornec-fin,
                                         INPUT v-licenca-ini,
                                         INPUT v-licenca-fin,
                                         INPUT v-nome-abrev-ini,
                                         INPUT v-nome-abrev-fin,
                                         INPUT v-nr-pedcli-ini,
                                         INPUT v-nr-pedcli-fin,
                                         INPUT v-cod-estabel-ini,
                                         INPUT v-cod-estabel-fin,
                                         INPUT v-serie-ini,
                                         INPUT v-serie-fin,
                                         INPUT v-nr-nota-fis-ini,
                                         INPUT v-nr-nota-fis-fin).

    RUN openQueryStatic IN hBoes601 (INPUT "Filtro":U).

    RUN getBatchRecords IN hBoes601 (INPUT  ?,
                                     INPUT  ?,
                                     INPUT  ?,
                                     OUTPUT iRows,
                                     OUTPUT TABLE tt-int-licenca-softphone).

    {&OPEN-QUERY-brLicenca}

    IF CAN-FIND(FIRST tt-int-licenca-softphone) THEN
        ENABLE btUpdate
               btDelete
               btDetalhePedido
               btDetalheNF
            WITH FRAME fPage1.
    ELSE
        DISABLE btUpdate
                btDelete
                btDetalhePedido
                btDetalheNF
            WITH FRAME fPage1.

    IF rRowidRegistro <> ? THEN DO:
        FIND FIRST tt-int-licenca-softphone
            WHERE tt-int-licenca-softphone.r-Rowid = rRowidRegistro NO-LOCK NO-ERROR.

        IF AVAILABLE tt-int-licenca-softphone THEN
            REPOSITION brLicenca TO ROWID(ROWID(tt-int-licenca-softphone)).
    END.

    ASSIGN v-coluna = "it-codigo":U
           l-asc    = YES.

    brLicenca:CLEAR-SORT-ARROWS() IN FRAME fPage1.
    brLicenca:SET-SORT-ARROW(1, l-asc) IN FRAME fPage1.

    SESSION:SET-WAIT-STATE("":U).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-desc-item wWindow 
FUNCTION fn-desc-item RETURNS CHARACTER
  ( p-it-codigo AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    FIND FIRST item
        WHERE item.it-codigo = p-it-codigo NO-LOCK NO-ERROR.

    IF AVAILABLE item THEN
        RETURN item.desc-item.
    ELSE
        RETURN "":U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

