&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttresgate-premios NO-UNDO LIKE resgate-premios
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esutp044 2.04.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esutp044
&GLOBAL-DEFINE Version        2.04.00.000

&GLOBAL-DEFINE Folder         yes
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   Geral,Pedido,Observaá∆o

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            YES
&GLOBAL-DEFINE Copy           YES
&GLOBAL-DEFINE Update         YES
&GLOBAL-DEFINE Delete         YES
&GLOBAL-DEFINE Undo           YES
&GLOBAL-DEFINE Cancel         YES
&GLOBAL-DEFINE Save           YES

&GLOBAL-DEFINE ttTable        ttresgate-premios
&GLOBAL-DEFINE hDBOTable      hboes520
&GLOBAL-DEFINE DBOTable       resgate-premios

&GLOBAL-DEFINE page0KeyFields ttresgate-premios.cpf-cnpj ttresgate-premios.data-movto ttresgate-premios.sequencia
&GLOBAL-DEFINE page0Fields    ttresgate-premios.concluido
&GLOBAL-DEFINE page1Fields    ttresgate-premios.cod-premio ttresgate-premios.pontos ttresgate-premios.nro-docto ~
                              ttresgate-premios.serie-docto ttresgate-premios.vl-liquido ttresgate-premios.vl-total ~
                              ttresgate-premios.forma-pagto fiDescricaoPremio ttresgate-premios.quantidade
&GLOBAL-DEFINE page2Fields    ttresgate-premios.cod-estabel ttresgate-premios.nome-abrev ttresgate-premios.nr-pedcli ~
                              fiNomeEmit fiItCodigo fiDescItem fiDtPedido fiSituacao
&GLOBAL-DEFINE page3Fields    ttresgate-premios.observacao

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttresgate-premios.cpf-cnpj ~
ttresgate-premios.data-movto ttresgate-premios.sequencia ~
ttresgate-premios.concluido 
&Scoped-define ENABLED-TABLES ttresgate-premios
&Scoped-define FIRST-ENABLED-TABLE ttresgate-premios
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys btFirst btPrev btNext ~
btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo btCancel ~
btSave btUnidade btQueryJoins btReportsJoins btExit btHelp fiNomeUsuario 
&Scoped-Define DISPLAYED-FIELDS ttresgate-premios.cpf-cnpj ~
ttresgate-premios.data-movto ttresgate-premios.sequencia ~
ttresgate-premios.concluido 
&Scoped-define DISPLAYED-TABLES ttresgate-premios
&Scoped-define FIRST-DISPLAYED-TABLE ttresgate-premios
&Scoped-Define DISPLAYED-OBJECTS fiNomeUsuario 

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
       MENU-ITEM miLast         LABEL "&Èltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V† Para"       ACCELERATOR "CTRL-T"
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
DEFINE BUTTON btAdd 
     IMAGE-UP FILE "image\im-add":U
     IMAGE-INSENSITIVE FILE "image\ii-add":U
     LABEL "Add" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCancel 
     IMAGE-UP FILE "image\im-can":U
     IMAGE-INSENSITIVE FILE "image\im-can":U
     LABEL "Cancel" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCopy 
     IMAGE-UP FILE "image\im-copy":U
     IMAGE-INSENSITIVE FILE "image\ii-copy":U
     LABEL "Copy" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btDelete 
     IMAGE-UP FILE "image\im-era":U
     IMAGE-INSENSITIVE FILE "image\ii-era":U
     LABEL "Delete" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

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

DEFINE BUTTON btSave 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btUndo 
     IMAGE-UP FILE "image\im-undo":U
     IMAGE-INSENSITIVE FILE "image\ii-undo":U
     LABEL "Undo" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btUnidade 
     IMAGE-UP FILE "image/fields2.bmp":U
     IMAGE-INSENSITIVE FILE "image/fields-i4.bmp":U
     LABEL "Unidade" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image\im-mod":U
     IMAGE-INSENSITIVE FILE "image\ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE fiNomeUsuario AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nome" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .79 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.33.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE fiDescricaoPremio AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .79 NO-UNDO.

DEFINE VARIABLE fiDescItem AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .79 NO-UNDO.

DEFINE VARIABLE fiDtPedido AS CHARACTER FORMAT "X(256)":U 
     LABEL "Data de Entrega" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE fiItCodigo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE fiNomeEmit AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .79 NO-UNDO.

DEFINE VARIABLE fiSituacao AS CHARACTER FORMAT "X(256)":U 
     LABEL "Situaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .79 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrància"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrància anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrància"
     btLast AT ROW 1.13 COL 13.57 HELP
          "Èltima ocorrància"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V† Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btAdd AT ROW 1.13 COL 31 HELP
          "Inclui nova ocorrància"
     btCopy AT ROW 1.13 COL 35 HELP
          "Cria uma c¢pia da ocorrància corrente"
     btUpdate AT ROW 1.13 COL 39 HELP
          "Altera ocorrància corrente"
     btDelete AT ROW 1.13 COL 43 HELP
          "Elimina ocorrància corrente"
     btUndo AT ROW 1.13 COL 47 HELP
          "Desfaz alteraá‰es"
     btCancel AT ROW 1.13 COL 51 HELP
          "Cancela alteraá‰es"
     btSave AT ROW 1.13 COL 55 HELP
          "Confirma alteraá‰es"
     btUnidade AT ROW 1.13 COL 70.72 HELP
          "Manutená∆o Unidade de Neg¢cio" WIDGET-ID 16
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     ttresgate-premios.cpf-cnpj AT ROW 3.5 COL 9 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 16 BY .79
     ttresgate-premios.data-movto AT ROW 3.5 COL 57 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 10 BY .79
     fiNomeUsuario AT ROW 4.5 COL 9 COLON-ALIGNED WIDGET-ID 10 NO-TAB-STOP 
     ttresgate-premios.sequencia AT ROW 4.5 COL 57 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 7.57 BY .79 NO-TAB-STOP 
     ttresgate-premios.concluido AT ROW 4.5 COL 71 WIDGET-ID 14
          VIEW-AS TOGGLE-BOX
          SIZE 11.29 BY .83
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 14.13
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     ttresgate-premios.cod-premio AT ROW 1.5 COL 19 COLON-ALIGNED WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 9 BY .79
     fiDescricaoPremio AT ROW 1.5 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 52 NO-TAB-STOP 
     ttresgate-premios.pontos AT ROW 2.5 COL 19 COLON-ALIGNED WIDGET-ID 44
          VIEW-AS FILL-IN 
          SIZE 9 BY .79 NO-TAB-STOP 
     ttresgate-premios.quantidade AT ROW 2.5 COL 38 COLON-ALIGNED WIDGET-ID 54
          VIEW-AS FILL-IN 
          SIZE 3.29 BY .79
     ttresgate-premios.nro-docto AT ROW 3.5 COL 19 COLON-ALIGNED WIDGET-ID 42
          VIEW-AS FILL-IN 
          SIZE 12 BY .79
     ttresgate-premios.serie-docto AT ROW 3.5 COL 36.57 COLON-ALIGNED WIDGET-ID 46
          VIEW-AS FILL-IN 
          SIZE 4.72 BY .79
     ttresgate-premios.vl-liquido AT ROW 4.5 COL 19 COLON-ALIGNED WIDGET-ID 48
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .79
     ttresgate-premios.vl-total AT ROW 5.5 COL 19 COLON-ALIGNED WIDGET-ID 50
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .79
     ttresgate-premios.forma-pagto AT ROW 6.5 COL 19 COLON-ALIGNED WIDGET-ID 36
          VIEW-AS COMBO-BOX 
          LIST-ITEM-PAIRS "Cart∆o Corporativo",1,
                     "Boleto Banc†rio",2,
                     "Dep¢sito em Conta",3,
                     "Outro",4
          DROP-DOWN-LIST
          SIZE 16.86 BY 1
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.71
         SIZE 84.43 BY 6.88
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage3
     ttresgate-premios.observacao AT ROW 2 COL 14 NO-LABEL WIDGET-ID 22
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 60 BY 5
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.71
         SIZE 84.43 BY 6.88
         FONT 1 WIDGET-ID 200.

DEFINE FRAME fPage2
     ttresgate-premios.cod-estabel AT ROW 1.5 COL 19 COLON-ALIGNED WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 4 BY .79
     ttresgate-premios.nome-abrev AT ROW 2.5 COL 19 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 12 BY .79
     fiNomeEmit AT ROW 2.5 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 28 NO-TAB-STOP 
     ttresgate-premios.nr-pedcli AT ROW 3.5 COL 19 COLON-ALIGNED WIDGET-ID 26
          VIEW-AS FILL-IN 
          SIZE 12 BY .79
     fiItCodigo AT ROW 4.5 COL 19 COLON-ALIGNED WIDGET-ID 30 NO-TAB-STOP 
     fiDescItem AT ROW 4.5 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 32 NO-TAB-STOP 
     fiDtPedido AT ROW 5.5 COL 19 COLON-ALIGNED WIDGET-ID 34 NO-TAB-STOP 
     fiSituacao AT ROW 6.5 COL 19 COLON-ALIGNED WIDGET-ID 36 NO-TAB-STOP 
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.71
         SIZE 84.43 BY 6.88
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttresgate-premios T "?" NO-UNDO mgesp resgate-premios
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
         HEIGHT             = 14.13
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenance 
/* ************************* Included-Libraries *********************** */

{maintenance/maintenance.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenance
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
ASSIGN 
       fiNomeUsuario:READ-ONLY IN FRAME fpage0        = TRUE.

ASSIGN 
       ttresgate-premios.sequencia:READ-ONLY IN FRAME fpage0        = TRUE.

/* SETTINGS FOR FRAME fPage1
                                                                        */
ASSIGN 
       fiDescricaoPremio:READ-ONLY IN FRAME fPage1        = TRUE.

ASSIGN 
       ttresgate-premios.pontos:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FRAME fPage2
                                                                        */
ASSIGN 
       fiDescItem:READ-ONLY IN FRAME fPage2        = TRUE.

ASSIGN 
       fiDtPedido:READ-ONLY IN FRAME fPage2        = TRUE.

ASSIGN 
       fiItCodigo:READ-ONLY IN FRAME fPage2        = TRUE.

ASSIGN 
       fiNomeEmit:READ-ONLY IN FRAME fPage2        = TRUE.

ASSIGN 
       fiSituacao:READ-ONLY IN FRAME fPage2        = TRUE.

/* SETTINGS FOR FRAME fPage3
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage3
/* Query rebuild information for FRAME fPage3
     _Query            is NOT OPENED
*/  /* FRAME fPage3 */
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


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMaintenance
ON CHOOSE OF btAdd IN FRAME fpage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd in MENU mbMain DO:
    RUN addRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenance
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:
    RUN cancelRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMaintenance
ON CHOOSE OF btCopy IN FRAME fpage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    RUN copyRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMaintenance
ON CHOOSE OF btDelete IN FRAME fpage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    RUN deleteRecord IN THIS-PROCEDURE.
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
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenance
ON CHOOSE OF btSave IN FRAME fpage0 /* Save */
OR CHOOSE OF MENU-ITEM miSave IN MENU mbMain DO:
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="eszoom/z01es520.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUndo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUndo wMaintenance
ON CHOOSE OF btUndo IN FRAME fpage0 /* Undo */
OR CHOOSE OF MENU-ITEM miUndo IN MENU mbMain DO:
    RUN undoRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUnidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUnidade wMaintenance
ON CHOOSE OF btUnidade IN FRAME fpage0 /* Unidade */
do:
   def var l-ok as logical no-undo.
   
   do transaction:
      find first resgate-premios of ttresgate-premios no-error.
      run esp/utp/esutp044a.w (buffer resgate-premios, output l-ok).

      if not l-ok then
         undo, return no-apply.
   end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMaintenance
ON CHOOSE OF btUpdate IN FRAME fpage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    RUN updateRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttresgate-premios.cod-premio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttresgate-premios.cod-premio wMaintenance
ON LEAVE OF ttresgate-premios.cod-premio IN FRAME fPage1 /* C¢digo Pràmio */
do:
   find first premios-fidelidade no-lock
      where premios-fidelidade.cod-premio = int({&ttTable}.cod-premio:screen-value) no-error.

   if available premios-fidelidade then do:
      if premios-fidelidade.it-codigo <> '' then
         find first item no-lock
            where item.it-codigo = premios-fidelidade.it-codigo no-error.

      assign fiDescricaoPremio:screen-value = premios-fidelidade.descricao.
      
      if {&ttTable}.cod-premio <> premios-fidelidade.cod-premio then
         assign {&ttTable}.pontos:screen-value = string(premios-fidelidade.qt-pontos).

      if available item then
         assign fiItCodigo:screen-value in frame fPage2 = item.it-codigo
                fiDescItem:screen-value in frame fPage2 = item.desc-item.
   end.
   else
      assign fiDescricaoPremio:screen-value          = ''
             {&ttTable}.pontos:screen-value          = '0'
             fiItCodigo:screen-value in frame fPage2 = ''
             fiDescItem:screen-value in frame fPage2 = ''.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME ttresgate-premios.cpf-cnpj
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttresgate-premios.cpf-cnpj wMaintenance
ON LEAVE OF ttresgate-premios.cpf-cnpj IN FRAME fpage0 /* CPF/CNPJ */
do:
   find first usuario-fidelidade no-lock
      where usuario-fidelidade.cpf-cnpj = {&ttTable}.cpf-cnpj:screen-value no-error.

   if available usuario-fidelidade then
      assign fiNomeUsuario:screen-value = usuario-fidelidade.nome.
   else
      assign fiNomeUsuario:screen-value = ''.

   apply 'Leave' to {&ttTable}.data-movto.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttresgate-premios.data-movto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttresgate-premios.data-movto wMaintenance
ON LEAVE OF ttresgate-premios.data-movto IN FRAME fpage0 /* Data Movimento */
do:
   if cAction = "ADD" then do:
      find last resgate-premios no-lock
         where resgate-premios.cpf-cnpj   = {&ttTable}.cpf-cnpj:screen-value
           and resgate-premios.data-movto = date({&ttTable}.data-movto:screen-value) no-error.

      if available resgate-premios then
         assign {&ttTable}.sequencia:screen-value = string(resgate-premios.sequencia + 10, ">>>>>>9").
      else
         assign {&ttTable}.sequencia:screen-value = "10".
   end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME ttresgate-premios.nome-abrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttresgate-premios.nome-abrev wMaintenance
ON LEAVE OF ttresgate-premios.nome-abrev IN FRAME fPage2 /* Cliente */
do:
   if {&ttTable}.nome-abrev:screen-value <> '' then do:
      find emitente no-lock
         where emitente.cod-emitente = int({&ttTable}.nome-abrev:screen-value) no-error.
   
      if available emitente then
         assign {&ttTable}.nome-abrev:screen-value = emitente.nome-abrev
                fiNomeEmit:screen-value            = emitente.nome-emit.
      else do:
         find emitente no-lock
            where emitente.nome-abrev = {&ttTable}.nome-abrev:screen-value no-error.
      
         if available emitente then
            assign fiNomeEmit:screen-value = emitente.nome-emit.
         else
            assign fiNomeEmit:screen-value = ''.
      end.
   end.
   else
      assign fiNomeEmit:screen-value = ''.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttresgate-premios.nr-pedcli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttresgate-premios.nr-pedcli wMaintenance
ON LEAVE OF ttresgate-premios.nr-pedcli IN FRAME fPage2 /* Nr Pedido */
do:
   find first ped-venda no-lock
      where ped-venda.cod-estabel = {&ttTable}.cod-estabel:screen-value
        and ped-venda.nome-abrev  = {&ttTable}.nome-abrev:screen-value
        and ped-venda.nr-pedcli   = {&ttTable}.nr-pedcli:screen-value no-error.

   if available ped-venda then
      assign fiDtPedido:screen-value = string(ped-venda.dt-entrega, "99/99/9999")
             fiSituacao:screen-value = if ped-venda.cod-sit-ped = 1 then
                                          "Aberto"
                                       else if ped-venda.cod-sit-ped = 2 then
                                          "Atendido Parcial"
                                       else if ped-venda.cod-sit-ped = 3 then
                                          "Atendido Total"
                                       else if ped-venda.cod-sit-ped = 4 then
                                          "Pendente"
                                       else if ped-venda.cod-sit-ped = 5 then
                                          "Suspenso"
                                       else if ped-venda.cod-sit-ped = 6 then
                                          "Cancelado"
                                       else if ped-venda.cod-sit-ped = 7 then
                                          "Fatur. Balc∆o"
                                       else
                                          "Desconhecido".
   else
      assign fiDtPedido:screen-value = ''
             fiSituacao:screen-value = ''.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenance/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenance 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   apply 'Leave' to {&ttTable}.cpf-cnpj   in frame fPage0.
   apply 'Leave' to {&ttTable}.cod-premio in frame fPage1.
   apply 'Leave' to {&ttTable}.nome-abrev in frame fPage2.
   apply 'Leave' to {&ttTable}.nr-pedcli  in frame fPage2.

   btUnidade:sensitive = true.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V† Para
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
    
    DEFINE VARIABLE ccpf-cnpj    LIKE {&ttTable}.cpf-cnpj   NO-UNDO.
    DEFINE VARIABLE dtdata-movto LIKE {&ttTable}.data-movto NO-UNDO.
    DEFINE VARIABLE isequencia   LIKE {&ttTable}.sequencia  NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        ccpf-cnpj         AT ROW 1.21 COL 17.72 COLON-ALIGNED
        dtdata-movto      at row 2.21 col 7.72
        isequencia        at row 3.21 col 11.52
        btGoToOK          AT ROW 4.63 COL 2.14
        btGoToCancel      AT ROW 4.63 COL 13
        rtGoToButton      AT ROW 4.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Resgate Fidelidade" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V†_Para_Resgate_Fidelidade"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN ccpf-cnpj dtdata-movto isequencia.
        
        RUN goToKey IN {&hDBOTable} (INPUT ccpf-cnpj, input dtdata-movto, input isequencia).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Resgate Fidelidade":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE ccpf-cnpj dtdata-movto isequencia btGoToOK btGoToCancel 
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
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "esbo/boes520.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes520.p YES}
        {btb/btb008za.i2 esbo/boes520.p '' {&hDBOTable}}
    END.
    
    /*RUN setConstraint<Description> IN {&hDBOTable} (<pamameters>) NO-ERROR.*/
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

