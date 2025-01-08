&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttcont-emit NO-UNDO LIKE cont-emit
       field r-rowid as rowid
       field cc-codigo like int-cont-emit.cc-codigo.
DEFINE TEMP-TABLE ttemitente NO-UNDO LIKE emitente
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
{include/i-prgvrs.i XX9999 9.99.99.999}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esccp013
&GLOBAL-DEFINE Version        2.00.04.000

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1


&GLOBAL-DEFINE First          NO
&GLOBAL-DEFINE Prev           NO
&GLOBAL-DEFINE Next           NO
&GLOBAL-DEFINE Last           NO
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            NO
&GLOBAL-DEFINE Copy           NO
&GLOBAL-DEFINE Update         YES
&GLOBAL-DEFINE Delete         NO
&GLOBAL-DEFINE Undo           YES
&GLOBAL-DEFINE Cancel         YES
&GLOBAL-DEFINE Save           YES


&GLOBAL-DEFINE ttTable        ttEmitente
&GLOBAL-DEFINE hDBOTable      hboEmitente
&GLOBAL-DEFINE DBOTable       Emitente


&GLOBAL-DEFINE ttTable2        ttCont-emit
&GLOBAL-DEFINE hDBOTable2      hboCont-emit
&GLOBAL-DEFINE DBOTable2       Cont-emit




&GLOBAL-DEFINE page0KeyFields 

&GLOBAL-DEFINE page0Fields     fi-teste

&GLOBAL-DEFINE page1Fields     /*ttEmitente.nome-abrev ttEmitente.endereco ttEmitente.bairro ttEmitente.cidade ~
                               ttEmitente.estado ttEmitente.cep */ ttEmitente.cod-transp ttEmitente.cod-cond-pag /*ttEmitente.nat-operacao */ ~
                               fi-cod-emitente-ini fi-cod-emitente-fim fi-comprador-ini fi-comprador-fim tg-b2s txt-cond-pag



&GLOBAL-DEFINE page2Fields    

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTable2} AS HANDLE NO-UNDO.



DEF VAR cod-emit LIKE emitente.cod-emitente.

DEF VAR seq LIKE cont-emit.sequencia.


/*
DEF TEMP-TABLE tt-Cont-emit
    FIELD cod-emitente  LIKE cont-emit.cod-emitente
    FIELD nome          LIKE cont-emit.nome
    FIELD telefone      LIKE cont-emit.telefone
    FIELD telefax       LIKE cont-emit.telefax
    FIELD e-mail        LIKE cont-emit.e-mail 
    FIELD cc-codigo     LIKE int-cont-emit.cc-codigo.
*/                                                 





DEF VAR codi LIKE emitente.cod-emitente.
DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.


DEF VAR i-cod-emitente LIKE emitente.cod-emitente.


DEF VAR resp AS LOGICAL INITIAL NO NO-UNDO.


DEF NEW GLOBAL SHARED VAR gr-emitente AS ROWID NO-UNDO.
define new global shared var gr-cont-emit as rowid no-undo.




DEFINE BUTTON    btGoToOK     AUTO-GO LABEL "&OK" SIZE 10 BY 1 BGCOLOR 8.
DEFINE BUTTON    btGoToCancel AUTO-GO LABEL "&Cancela" SIZE 10 BY 1 BGCOLOR 8.
DEFINE RECTANGLE rtGoToFields  EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 65 BY 9.3 BGCOLOR 8.
DEFINE RECTANGLE rtGoToButton  EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 65 BY 1.5 BGCOLOR 7.


DEFINE VARIABLE  iSequencia     LIKE cont-emit.sequencia        LABEL "Sequˆncia"       VIEW-AS FILL-IN  SIZE 3  BY .88 NO-UNDO.
DEFINE VARIABLE  iCodEmitente   LIKE cont-emit.cod-emitente     LABEL "Emitente"        VIEW-AS FILL-IN  SIZE 9  BY .88 NO-UNDO.
DEFINE VARIABLE  cNome          LIKE cont-emit.nome             LABEL "Contato"            VIEW-AS FILL-IN  SIZE 45 BY .88 NO-UNDO.
DEFINE VARIABLE  cTelefone      LIKE cont-emit.telefone         LABEL "Telefone"        VIEW-AS FILL-IN  SIZE 15 BY .88 NO-UNDO.
DEFINE VARIABLE  cTelefax       LIKE cont-emit.telefax          LABEL "Fax"             VIEW-AS FILL-IN  SIZE 15 BY .88 NO-UNDO.
DEFINE VARIABLE  cEmail         LIKE cont-emit.e-mail           LABEL "E-mail"          VIEW-AS FILL-IN  SIZE 45 BY .88 NO-UNDO.
DEFINE VARIABLE  cCentroCusto   LIKE int-cont-emit.cc-codigo    LABEL "Centro Custo"    VIEW-AS FILL-IN  SIZE 10 BY .88 NO-UNDO.





DEFINE VARIABLE wh-pesquisa                       AS HANDLE       NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl  AS HANDLE       NO-UNDO.

DEF VAR ex-seq LIKE cont-emit.sequencia.
DEF VAR ex-cod LIKE cont-emit.cod-emitente.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-Contato

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES cont-emit int-cont-emit ttEmitente

/* Definitions for BROWSE br-Contato                                    */
&Scoped-define FIELDS-IN-QUERY-br-Contato cont-emit.sequencia cont-emit.cod-emitente cont-emit.nome cont-emit.telefone cont-emit.telefax int-cont-emit.cc-codigo cont-emit.e-mail   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-Contato   
&Scoped-define SELF-NAME br-Contato
&Scoped-define QUERY-STRING-br-Contato FOR EACH cont-emit WHERE             cont-emit.cod-emitente = ttEmitente.cod-emitente, ~
                   EACH int-cont-emit OF cont-emit
&Scoped-define OPEN-QUERY-br-Contato OPEN QUERY {&self-name} FOR EACH cont-emit WHERE             cont-emit.cod-emitente = ttEmitente.cod-emitente, ~
                   EACH int-cont-emit OF cont-emit.
&Scoped-define TABLES-IN-QUERY-br-Contato cont-emit int-cont-emit
&Scoped-define FIRST-TABLE-IN-QUERY-br-Contato cont-emit
&Scoped-define SECOND-TABLE-IN-QUERY-br-Contato int-cont-emit


/* Definitions for BROWSE br-emitente                                   */
&Scoped-define FIELDS-IN-QUERY-br-emitente ttEmitente.cod-emitente ttEmitente.Nome-abrev   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-emitente   
&Scoped-define SELF-NAME br-emitente
&Scoped-define QUERY-STRING-br-emitente FOR EACH ttEmitente
&Scoped-define OPEN-QUERY-br-emitente OPEN QUERY {&SELF-NAME} FOR EACH ttEmitente.
&Scoped-define TABLES-IN-QUERY-br-emitente ttEmitente
&Scoped-define FIRST-TABLE-IN-QUERY-br-emitente ttEmitente


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-br-Contato}~
    ~{&OPEN-QUERY-br-emitente}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btGoTo btSearch btAdd btCopy ~
btUpdate btDelete btUndo btCancel btSave bt-exporta btQueryJoins ~
btReportsJoins btExit btHelp fi-teste 
&Scoped-Define DISPLAYED-OBJECTS fi-teste 

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
DEFINE BUTTON bt-exporta 
     IMAGE-UP FILE "Image\im-exp":U
     IMAGE-INSENSITIVE FILE "Image\ii-exp":U
     LABEL "Exportar" 
     SIZE 4 BY 1.25.

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

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image\im-mod":U
     IMAGE-INSENSITIVE FILE "image\ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE fi-teste AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 2 BY .79 NO-UNDO.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 111 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-excluir 
     LABEL "Excluir Contato" 
     SIZE 13 BY 1.13.

DEFINE BUTTON bt-incluir 
     LABEL "Incluir Contato" 
     SIZE 13 BY 1.13.

DEFINE BUTTON bt-pesquisa-Comprador 
     LABEL "Comprador ..." 
     SIZE 11 BY 1.

DEFINE BUTTON bt-Pesquisa-Fornecedor 
     LABEL "Fornecedor ..." 
     SIZE 11 BY 1.

DEFINE VARIABLE fi-cod-emitente-fim AS CHARACTER FORMAT "X(9)":U INITIAL "ZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-emitente-ini AS CHARACTER FORMAT "X(8)":U 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fi-comprador-fim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fi-comprador-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Comprador" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-cond-pag AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE txt-cond-pag AS CHARACTER FORMAT "X(256)":U INITIAL "Cond. Pagto:" 
      VIEW-AS TEXT 
     SIZE 8.86 BY .67 NO-UNDO.

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

DEFINE RECTANGLE RECT-43
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 109 BY 9.25.

DEFINE RECTANGLE RECT-44
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 109 BY 7.25.

DEFINE RECTANGLE RECT-45
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 55 BY 1.5.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 55 BY 1.5.

DEFINE VARIABLE tg-b2s AS LOGICAL INITIAL no 
     LABEL "Usa B2B Suprimentos?" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-Contato FOR 
      cont-emit, 
      int-cont-emit SCROLLING.

DEFINE QUERY br-emitente FOR 
      ttEmitente SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-Contato
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-Contato wMaintenance _FREEFORM
  QUERY br-Contato DISPLAY
      cont-emit.sequencia                   COLUMN-LABEL "Seq" 
   cont-emit.cod-emitente                   COLUMN-LABEL "Emitente"
   cont-emit.nome                           COLUMN-LABEL "Contato"
   cont-emit.telefone       FORMAT "x(18)"  COLUMN-LABEL "Telefone"    
   cont-emit.telefax        FORMAT "x(18)"  COLUMN-LABEL "Fax"
   int-cont-emit.cc-codigo                  COLUMN-LABEL "Cento Custo"
   cont-emit.e-mail         FORMAT "x(80)"  COLUMN-LABEL "E-mail"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 107 BY 5.5
         FONT 1 ROW-HEIGHT-CHARS .5.

DEFINE BROWSE br-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-emitente wMaintenance _FREEFORM
  QUERY br-emitente DISPLAY
      ttEmitente.cod-emitente                   COLUMN-LABEL "C¢digo"
    ttEmitente.Nome-abrev     FORMAT "x(55)"  COLUMN-LABEL "Descri‡Æo"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 55 BY 5.5
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V  Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btAdd AT ROW 1.13 COL 31 HELP
          "Inclui nova ocorrˆncia"
     btCopy AT ROW 1.13 COL 35 HELP
          "Cria uma c¢pia da ocorrˆncia corrente"
     btUpdate AT ROW 1.13 COL 39 HELP
          "Altera ocorrˆncia corrente"
     btDelete AT ROW 1.13 COL 43 HELP
          "Elimina ocorrˆncia corrente"
     btUndo AT ROW 1.13 COL 47 HELP
          "Desfaz altera‡äes"
     btCancel AT ROW 1.13 COL 51 HELP
          "Cancela altera‡äes"
     btSave AT ROW 1.13 COL 55 HELP
          "Confirma altera‡äes"
     bt-exporta AT ROW 1.13 COL 71.86 HELP
          "Exportar" WIDGET-ID 2
     btQueryJoins AT ROW 1.13 COL 95.29 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 99.29 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 103.29 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 107.29 HELP
          "Ajuda"
     fi-teste AT ROW 18.5 COL 2 NO-LABEL
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 111.86 BY 19.33
         FONT 1.

DEFINE FRAME fPage1
     fi-cod-emitente-ini AT ROW 1.83 COL 11 COLON-ALIGNED
     fi-cod-emitente-fim AT ROW 1.83 COL 32 COLON-ALIGNED NO-LABEL
     bt-Pesquisa-Fornecedor AT ROW 1.83 COL 46
     ttemitente.nome-abrev AT ROW 2 COL 69 COLON-ALIGNED
          LABEL "Fornecedor":R17
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     ttemitente.endereco AT ROW 3 COL 69 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 38 BY .88
     fi-comprador-ini AT ROW 3.33 COL 11 COLON-ALIGNED
     fi-comprador-fim AT ROW 3.33 COL 32 COLON-ALIGNED NO-LABEL
     bt-pesquisa-Comprador AT ROW 3.33 COL 46
     ttemitente.bairro AT ROW 4 COL 69 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 38 BY .88
     br-emitente AT ROW 4.75 COL 3
     ttemitente.cidade AT ROW 5 COL 69 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 38 BY .88
     ttemitente.cod-cond-pag AT ROW 6 COL 69 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     fi-desc-cond-pag AT ROW 6 COL 75 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     ttemitente.estado AT ROW 7 COL 69 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     ttemitente.cod-transp AT ROW 7 COL 98 COLON-ALIGNED
          LABEL "Transportador":R24
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     ttemitente.cep AT ROW 8 COL 69 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     ttemitente.nat-operacao AT ROW 8 COL 98 COLON-ALIGNED
          LABEL "Nat. Opera‡Æo":R21
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     tg-b2s AT ROW 9.25 COL 71 WIDGET-ID 4
     br-Contato AT ROW 11 COL 3
     bt-incluir AT ROW 16.75 COL 4
     bt-excluir AT ROW 16.75 COL 17
     txt-cond-pag AT ROW 6.08 COL 59.72 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     RECT-43 AT ROW 1.25 COL 2
     IMAGE-1 AT ROW 1.83 COL 25
     IMAGE-2 AT ROW 1.83 COL 30
     IMAGE-3 AT ROW 3.33 COL 25
     IMAGE-4 AT ROW 3.33 COL 30
     RECT-44 AT ROW 10.75 COL 2
     RECT-45 AT ROW 1.5 COL 3
     RECT-46 AT ROW 3 COL 3
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 2.75
         SIZE 111 BY 17.25
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttcont-emit T "?" NO-UNDO mgcad cont-emit
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
          field cc-codigo like int-cont-emit.cc-codigo
      END-FIELDS.
      TABLE: ttemitente T "?" NO-UNDO mgcad emitente
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
         HEIGHT             = 19.33
         WIDTH              = 111.86
         MAX-HEIGHT         = 38.88
         MAX-WIDTH          = 205.72
         VIRTUAL-HEIGHT     = 38.88
         VIRTUAL-WIDTH      = 205.72
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
  NOT-VISIBLE,                                                          */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN fi-teste IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB br-emitente bairro fPage1 */
/* BROWSE-TAB br-Contato tg-b2s fPage1 */
/* SETTINGS FOR FILL-IN ttemitente.cod-cond-pag IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttemitente.cod-transp IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttemitente.nat-operacao IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttemitente.nome-abrev IN FRAME fPage1
   EXP-LABEL                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-Contato
/* Query rebuild information for BROWSE br-Contato
     _START_FREEFORM
OPEN QUERY {&self-name} FOR EACH cont-emit WHERE
            cont-emit.cod-emitente = ttEmitente.cod-emitente,
            EACH int-cont-emit OF cont-emit.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-Contato */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-emitente
/* Query rebuild information for BROWSE br-emitente
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttEmitente.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-emitente */
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
ON ENTRY OF wMaintenance
DO:
    btUpdate:SENSITIVE     IN FRAME fpage0 = FALSE.
    bt-excluir:SENSITIVE   IN FRAME fpage1 = FALSE.

    /*
    ASSIGN ttEmitente.nome-abrev:SCREEN-VALUE IN FRAME fpage1    = ""
           ttEmitente.endereco:SCREEN-VALUE IN FRAME fpage1      = ""
           ttEmitente.bairro:SCREEN-VALUE IN FRAME fpage1        = ""
           ttEmitente.cidade:SCREEN-VALUE IN FRAME fpage1        = ""
           ttEmitente.estado:SCREEN-VALUE IN FRAME fpage1        = ""
           ttEmitente.cep:SCREEN-VALUE IN FRAME fpage1           = ""
           ttEmitente.cod-cond-pag:SCREEN-VALUE IN FRAME fpage1  = ""
           ttEmitente.cod-transp:SCREEN-VALUE IN FRAME fpage1    = ""
           ttEmitente.nat-operacao:SCREEN-VALUE IN FRAME fpage1  = "".
    */
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


&Scoped-define SELF-NAME fpage0
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fpage0 wMaintenance
ON ENTRY OF FRAME fpage0
DO:
  
    fi-cod-emitente-ini:SENSITIVE IN FRAME fpage1 = TRUE.
    fi-cod-emitente-fim:SENSITIVE IN FRAME fpage1 = TRUE.
    fi-comprador-ini:SENSITIVE    IN FRAME fpage1 = TRUE.
    fi-comprador-fim:SENSITIVE    IN FRAME fpage1 = TRUE.

    bt-pesquisa-fornecedor:SENSITIVE     IN FRAME fpage1 = TRUE.  
    bt-pesquisa-comprador:SENSITIVE      IN FRAME fpage1 = TRUE.  

    br-emitente:SENSITIVE     IN FRAME fpage1 = TRUE.
    br-contato:SENSITIVE      IN FRAME fpage1 = TRUE.

    btGoto:SENSITIVE       IN FRAME fpage0 = TRUE.    
    btSearch:SENSITIVE     IN FRAME fpage0 = TRUE.





END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fPage1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fPage1 wMaintenance
ON ENTRY OF FRAME fPage1
DO:

    /*
    FOR EACH ttEmitente:
        DELETE ttEmitente.
    END.
    {&OPEN-QUERY-br-emitente}


    FOR EACH emitente:
        FIND cont-emit NO-LOCK WHERE 
             cont-emit.cod-emitente = emitente.cod-emitente NO-ERROR.
        FIND int-cont-emit NO-LOCK WHERE 
             int-cont-emit.cod-emitente = emitente.cod-emitente NO-ERROR.

        CREATE ttEmitente.
           ASSIGN ttEmitente.cod-emitente  = emitente.cod-emitente
                  ttEmitente.nome-abrev    = emitente.nome-abrev. /*
                  ttEmitente.seq           = cont-emit.seq
                  ttEmitente.cc-codigo     = int-cont-emit.cc-codigo]
                  ttEmitente.nome          = cont-emit.nome
                  ttEmitente.telefone      = cont-emit.telefone
                  ttEmitente.e-mail        = cont-emit.e-mail.      */

    END.
    {&OPEN-QUERY-br-emitente}
      */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-Contato
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME br-Contato
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-Contato wMaintenance
ON MOUSE-SELECT-CLICK OF br-Contato IN FRAME fPage1
DO:
    IF cont-emit.sequencia <> 0 THEN DO:
       bt-excluir:SENSITIVE   IN FRAME fpage1 = TRUE.
       ASSIGN ex-seq = cont-emit.sequencia
              ex-cod = cont-emit.cod-emitente.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-Contato wMaintenance
ON MOUSE-SELECT-DBLCLICK OF br-Contato IN FRAME fPage1
DO:
    FIND emitente WHERE 
         emitente.cod-emitente = ttEmitente.cod-emitente NO-ERROR.

    run pi-atualiza-variaveis.

    ASSIGN gr-emitente = ROWID(Emitente).

    RUN cdp/cd0401b.w.
    RUN dispatch IN this-procedure('open-query').
    {&OPEN-QUERY-BR-CONTATO}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-emitente
&Scoped-define SELF-NAME br-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-emitente wMaintenance
ON ENTRY OF br-emitente IN FRAME fPage1
DO:
    RUN montaContato.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-emitente wMaintenance
ON MOUSE-SELECT-CLICK OF br-emitente IN FRAME fPage1
DO:
    
    RUN montaContato.


    /*
    FIND FIRST emitente WHERE
               emitente.cod-emitente = ttEmitente.cod-emitente NO-ERROR.

    IF AVAIL emitente THEN DO:

       BUFFER-COPY emitente TO ttEmitente.
      
       ASSIGN ttEmitente.nome-abrev:SCREEN-VALUE IN FRAME fpage1    = emitente.nome-abrev
              ttEmitente.endereco:SCREEN-VALUE IN FRAME fpage1      = emitente.endereco  
              ttEmitente.bairro:SCREEN-VALUE IN FRAME fpage1        = emitente.bairro
              ttEmitente.cidade:SCREEN-VALUE IN FRAME fpage1        = emitente.cidade
              ttEmitente.estado:SCREEN-VALUE IN FRAME fpage1        = emitente.estado
              ttEmitente.cep:SCREEN-VALUE IN FRAME fpage1           = emitente.cep
              ttEmitente.cod-cond-pag:SCREEN-VALUE IN FRAME fpage1  = STRING(emitente.cod-cond-pag)
              ttEmitente.cod-transp:SCREEN-VALUE IN FRAME fpage1    = STRING(emitente.cod-transp)
              ttEmitente.nat-operacao:SCREEN-VALUE IN FRAME fpage1  = emitente.nat-operacao. 
       
    END.

/*
    FOR EACH tt-Contato:
        DELETE tt-contato.
    END.
    */
    {&OPEN-QUERY-BR-CONTATO}


    btUpdate:SENSITIVE     IN FRAME fpage0 = TRUE.
    bt-incluir:SENSITIVE   IN FRAME fpage1 = TRUE.
    bt-excluir:SENSITIVE   IN FRAME fpage1 = FALSE.
*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-emitente wMaintenance
ON VALUE-CHANGED OF br-emitente IN FRAME fPage1
DO:
    RUN montaContato.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-excluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-excluir wMaintenance
ON CHOOSE OF bt-excluir IN FRAME fPage1 /* Excluir Contato */
DO:
    FIND FIRST cont-emit WHERE
               cont-emit.cod-emitente = ex-cod  AND
               cont-emit.sequencia    = ex-seq.             
    IF AVAIL cont-emit THEN DO: 
       DELETE cont-emit.
    END.
    BROWSE BR-CONTATO:REFRESH().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME bt-exporta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-exporta wMaintenance
ON CHOOSE OF bt-exporta IN FRAME fpage0 /* Exportar */
DO:
    RUN esp/ccp/esccp013a.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-incluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-incluir wMaintenance
ON CHOOSE OF bt-incluir IN FRAME fPage1 /* Incluir Contato */
DO:

    FIND emitente WHERE 
         emitente.cod-emitente = ttEmitente.cod-emitente NO-ERROR.

    ASSIGN gr-emitente = ROWID(Emitente).

    RUN cdp/cd0401b.w.
    RUN dispatch IN this-procedure('open-query').
    {&OPEN-QUERY-BR-CONTATO}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-pesquisa-Comprador
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-pesquisa-Comprador wMaintenance
ON CHOOSE OF bt-pesquisa-Comprador IN FRAME fPage1 /* Comprador ... */
DO:

    ASSIGN ttEmitente.nome-abrev:SCREEN-VALUE IN FRAME fpage1    = ""
           ttEmitente.endereco:SCREEN-VALUE IN FRAME fpage1      = ""
           ttEmitente.bairro:SCREEN-VALUE IN FRAME fpage1        = ""
           ttEmitente.cidade:SCREEN-VALUE IN FRAME fpage1        = ""
           ttEmitente.estado:SCREEN-VALUE IN FRAME fpage1        = ""
           ttEmitente.cep:SCREEN-VALUE IN FRAME fpage1           = ""
           ttEmitente.cod-cond-pag:SCREEN-VALUE IN FRAME fpage1  = ""
           ttEmitente.cod-transp:SCREEN-VALUE IN FRAME fpage1    = ""
           ttEmitente.nat-operacao:SCREEN-VALUE IN FRAME fpage1  = ""
           tg-b2s:SCREEN-VALUE IN FRAME fpage1  = "no".

    FOR EACH ttEmitente:
        DELETE ttEmitente.
    END.
    {&OPEN-QUERY-BR-EMITENTE}
    {&OPEN-QUERY-BR-CONTATO}

    STATUS DEFAULT "Buscando Comprador, AGUARDE...".
    FOR EACH ITEM NO-LOCK USE-INDEX comprador WHERE
             ITEM.cod-comprado >= fi-comprador-ini:SCREEN-VALUE IN FRAME fpage1  AND
             ITEM.cod-comprado <= fi-comprador-fim:SCREEN-VALUE IN FRAME fpage1,
        EACH item-fornec NO-LOCK USE-INDEX onde-compra WHERE
             item-fornec.it-codigo     = ITEM.it-codigo                                         AND
             item-fornec.cod-emitente >= int(fi-cod-emitente-ini:SCREEN-VALUE IN FRAME fpage1)  AND 
             item-fornec.cod-emitente <= int(fi-cod-emitente-fim:SCREEN-VALUE IN FRAME fpage1):

        FIND emitente NO-LOCK WHERE
             emitente.cod-emitente = item-fornec.cod-emitente NO-ERROR.

        FIND ttEmitente WHERE 
             ttEmitente.cod-emitente = emitente.cod-emitente NO-ERROR.


        IF NOT AVAIL ttEmitente THEN DO:
            CREATE ttEmitente.
                ASSIGN ttEmitente.cod-emitente = emitente.cod-emitente
                       ttEmitente.nome-abrev   = emitente.nome-abrev.
        END.
    END.
    STATUS DEFAULT.

    {&OPEN-QUERY-BR-EMITENTE}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-Pesquisa-Fornecedor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-Pesquisa-Fornecedor wMaintenance
ON CHOOSE OF bt-Pesquisa-Fornecedor IN FRAME fPage1 /* Fornecedor ... */
DO:

    ASSIGN ttEmitente.nome-abrev:SCREEN-VALUE IN FRAME fpage1    = ""
           ttEmitente.endereco:SCREEN-VALUE IN FRAME fpage1      = ""
           ttEmitente.bairro:SCREEN-VALUE IN FRAME fpage1        = ""
           ttEmitente.cidade:SCREEN-VALUE IN FRAME fpage1        = ""
           ttEmitente.estado:SCREEN-VALUE IN FRAME fpage1        = ""
           ttEmitente.cep:SCREEN-VALUE IN FRAME fpage1           = ""
           ttEmitente.cod-cond-pag:SCREEN-VALUE IN FRAME fpage1  = ""
           ttEmitente.cod-transp:SCREEN-VALUE IN FRAME fpage1    = ""
           ttEmitente.nat-operacao:SCREEN-VALUE IN FRAME fpage1  = ""
           tg-b2s:SCREEN-VALUE IN FRAME fpage1  = "no".

    FOR EACH ttEmitente:
        DELETE ttEmitente.
    END.
    {&OPEN-QUERY-BR-EMITENTE}
    {&OPEN-QUERY-BR-CONTATO}

    STATUS DEFAULT "Buscando Fornecedor, AGUARDE...".
    FOR EACH emitente WHERE
        emitente.cod-emitente >= int(fi-cod-emitente-ini:SCREEN-VALUE IN FRAME fpage1) AND
        emitente.cod-emitente <= int(fi-cod-emitente-fim:SCREEN-VALUE IN FRAME fpage1):
        CREATE ttEmitente.
            ASSIGN ttEmitente.cod-emitente = emitente.cod-emitente
                   ttEmitente.nome-abrev   = emitente.nome-abrev.
    END.
    STATUS DEFAULT.

    {&OPEN-QUERY-BR-EMITENTE}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMaintenance
ON CHOOSE OF btAdd IN FRAME fpage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd in MENU mbMain DO:
    RUN addRecord IN THIS-PROCEDURE.

    FOR EACH ttEmitente:
        DELETE ttEmitente.
    END.
    {&OPEN-QUERY-BR-EMITENTE}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenance
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:
    
    RUN cancelRecord IN THIS-PROCEDURE.

    
    FOR EACH ttEmitente:
        DELETE ttEmitente.
    END.
    {&OPEN-QUERY-BR-EMITENTE}
    {&OPEN-QUERY-BR-CONTATO}


    fi-cod-emitente-ini:SENSITIVE IN FRAME fpage1 = TRUE.
    fi-cod-emitente-fim:SENSITIVE IN FRAME fpage1 = TRUE.
    fi-comprador-ini:SENSITIVE    IN FRAME fpage1 = TRUE.
    fi-comprador-fim:SENSITIVE    IN FRAME fpage1 = TRUE.

    bt-pesquisa-fornecedor:SENSITIVE IN FRAME fpage1 = TRUE.  
    bt-pesquisa-comprador:SENSITIVE  IN FRAME fpage1 = TRUE.  

    br-emitente:SENSITIVE     IN FRAME fpage1 = TRUE.

    ttemitente.nome-abrev:SCREEN-VALUE   IN FRAME fpage1 = "".
    ttemitente.endereco:SCREEN-VALUE     IN FRAME fpage1 = "".
    ttemitente.bairro:SCREEN-VALUE       IN FRAME fpage1 = "".
    ttemitente.cidade:SCREEN-VALUE       IN FRAME fpage1 = "".
    ttemitente.estado:SCREEN-VALUE       IN FRAME fpage1 = "".
    ttemitente.cep:SCREEN-VALUE          IN FRAME fpage1 = "".
    ttemitente.cod-transp:SCREEN-VALUE   IN FRAME fpage1 = "".
    ttemitente.cod-cond-pag:SCREEN-VALUE IN FRAME fpage1 = "".
    fi-desc-cond-pag:SCREEN-VALUE        IN FRAME fpage1 = "".


    btUpdate:SENSITIVE     IN FRAME fpage0 = FALSE.

    bt-incluir:SENSITIVE   IN FRAME fpage1 = FALSE.
    bt-excluir:SENSITIVE   IN FRAME fpage1 = FALSE.

/*
    FOR EACH tt-Contato:
        DELETE tt-contato.
    END.
    {&OPEN-QUERY-BR-CONTATO}
*/

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


    /*
    ASSIGN i-cod-emitente = ttEmitente.cod-emitente.

    RUN goToKey IN {&hDBOTable} (INPUT i-cod-emitente).
    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "emitente":U).

        RETURN NO-APPLY.
    END.

    /*:T Retorna rowid do registro corrente do DBO */
    RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).


     RUN deleteRecord IN THIS-PROCEDURE.


    /*:T Reposiciona registro com base em um rowid */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
*/

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


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMaintenance
ON CHOOSE OF btGoTo IN FRAME fpage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    
    RUN goToRecord IN THIS-PROCEDURE.

    RUN monta.

    btUpdate:SENSITIVE     IN FRAME fpage0 = FALSE.    
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

    /*
    FIND FIRST emitente WHERE 
     emitente.cod-emitente = ttEmitente.cod-emitente NO-ERROR.

    IF AVAIL emitente THEN DO:
       ASSIGN emitente.nat-operacao = ttemitente.nat-operacao:SCREEN-VALUE IN FRAME fpage1 NO-ERROR.
    END.
    */



    ASSIGN i-cod-emitente = ttEmitente.cod-emitente.

    
    RUN goToKey IN {&hDBOTable} (INPUT i-cod-emitente).
    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "emitente":U).
        RETURN NO-APPLY.
    END.

    /*:T Retorna rowid do registro corrente do DBO */
    RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).


    RUN saveRecord IN THIS-PROCEDURE.


    /*:T Reposiciona registro com base em um rowid */
    RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).



    /*
    FOR EACH ttEmitente:
        DELETE ttEmitente.
    END.
    {&OPEN-QUERY-BR-EMITENTE}
    */


    btUpdate:SENSITIVE     IN FRAME fpage0 = FALSE.


    


/*
    FOR EACH ttEmitente:
        DELETE ttEmitente.
    END.
    {&OPEN-QUERY-BR-EMITENTE}

    
    FOR EACH emitente WHERE
        emitente.cod-emitente >= int(fi-cod-emitente-ini:SCREEN-VALUE IN FRAME fpage1) AND
        emitente.cod-emitente <= int(fi-cod-emitente-fim:SCREEN-VALUE IN FRAME fpage1):
        CREATE ttEmitente.
            ASSIGN ttEmitente.cod-emitente = emitente.cod-emitente
                   ttEmitente.nome-abrev   = emitente.nome-abrev.
    END.
    {&OPEN-QUERY-BR-EMITENTE}
    /* BROWSE br-emitente:REFRESH(). */







        RUN cancelRecord IN THIS-PROCEDURE.


        FOR EACH ttEmitente:
            DELETE ttEmitente.
        END.
        {&OPEN-QUERY-BR-EMITENTE}

        fi-cod-emitente-ini:SENSITIVE IN FRAME fpage1 = TRUE.
        fi-cod-emitente-fim:SENSITIVE IN FRAME fpage1 = TRUE.
        fi-comprador-ini:SENSITIVE IN FRAME fpage1 = TRUE.
        fi-comprador-fim:SENSITIVE IN FRAME fpage1 = TRUE.
        fi-cc-ini:SENSITIVE IN FRAME fpage1 = TRUE. 
        fi-cc-fim:SENSITIVE IN FRAME fpage1 = TRUE.

        bt-pesquisa:SENSITIVE     IN FRAME fpage1 = TRUE.  
        br-emitente:SENSITIVE     IN FRAME fpage1 = TRUE.



        ttemitente.nome-abrev:SCREEN-VALUE IN FRAME fpage1 = "".
        ttemitente.endereco:SCREEN-VALUE IN FRAME fpage1 = "".
        ttemitente.bairro:SCREEN-VALUE IN FRAME fpage1 = "".
        ttemitente.cidade:SCREEN-VALUE IN FRAME fpage1 = "".
        ttemitente.estado:SCREEN-VALUE IN FRAME fpage1 = "".
        ttemitente.cep:SCREEN-VALUE IN FRAME fpage1 = "".
        ttemitente.cod-transp:SCREEN-VALUE IN FRAME fpage1 = "".
        ttemitente.cod-cond-pag:SCREEN-VALUE IN FRAME fpage1  = "".


        FOR EACH tt-Contato:
            DELETE tt-contato.
        END.
        {&OPEN-QUERY-BR-CONTATO}

*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    /*
    {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
                 &campo=ttcomis-rep.cod-rep
                 &campozoom=cod-rep
                 &campo2=cDescRep
                 &campozoom2=nome}
      */

        {include/zoomvar.i &prog-zoom=adzoom/z01ad098.w
                           &campo=fi-cod-emitente-ini
                           &campozoom=cod-emitente
                           &FRAME=fPage1
                           }
                           

/*
            ASSIGN fi-cod-emitente-fim:SCREEN-VALUE IN FRAME fpage1 = fi-cod-emitente-ini:SCREEN-VALUE IN FRAME fpage1.
*/




    /* {method/ZoomReposition.i &ProgramZoom="adzoom/z03ad098.w"}  */
    
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


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMaintenance
ON CHOOSE OF btUpdate IN FRAME fpage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:

    RUN updateRecord IN THIS-PROCEDURE.

    fi-cod-emitente-ini:SENSITIVE IN FRAME fpage1 = TRUE.
    fi-cod-emitente-fim:SENSITIVE IN FRAME fpage1 = TRUE.
    fi-comprador-ini:SENSITIVE IN FRAME fpage1 = TRUE.
    fi-comprador-fim:SENSITIVE IN FRAME fpage1 = TRUE.

    bt-pesquisa-comprador:SENSITIVE     IN FRAME fpage1 = TRUE.  
    bt-pesquisa-fornecedor:SENSITIVE     IN FRAME fpage1 = TRUE.  

    br-emitente:SENSITIVE     IN FRAME fpage1 = TRUE.


    ttEmitente.nome-abrev:SENSITIVE IN FRAME fpage1 = FALSE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttemitente.cod-cond-pag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttemitente.cod-cond-pag wMaintenance
ON LEAVE OF ttemitente.cod-cond-pag IN FRAME fPage1 /* cod-cond-pag */
DO:
    FIND FIRST cond-pagto NO-LOCK WHERE
               cond-pagto.cod-cond-pag = INPUT FRAME fPage1 ttemitente.cod-cond-pag NO-ERROR.
    ASSIGN fi-desc-cond-pag = IF AVAIL cond-pagto THEN cond-pagto.descricao ELSE "":U.

    DISP fi-desc-cond-pag 
        WITH FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttemitente.cod-cond-pag wMaintenance
ON MOUSE-SELECT-DBLCLICK OF ttemitente.cod-cond-pag IN FRAME fPage1 /* cod-cond-pag */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad039.w
                       &campo=ttemitente.cod-cond-pag
                       &campozoom=cod-cond-pag
                       &frame=fPage1
                       &campo2=fi-desc-cond-pag
                       &campozoom2=descricao
                       &frame2=fPage1}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-emitente-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-emitente-fim wMaintenance
ON MOUSE-SELECT-DBLCLICK OF fi-cod-emitente-fim IN FRAME fPage1
DO:
    ASSIGN fi-cod-emitente-fim:SCREEN-VALUE IN FRAME fpage1 = fi-cod-emitente-ini:SCREEN-VALUE IN FRAME fpage1.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-comprador-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-comprador-fim wMaintenance
ON MOUSE-SELECT-DBLCLICK OF fi-comprador-fim IN FRAME fPage1
DO:
    ASSIGN fi-comprador-fim:SCREEN-VALUE IN FRAME fpage1 = fi-comprador-ini:SCREEN-VALUE IN FRAME fpage1.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-Contato
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
ttemitente.cod-cond-pag:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.

{maintenance/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenance 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN bt-exporta:SENSITIVE IN FRAME fpage0 = TRUE.

    RUN pi-limpa-tela IN THIS-PROCEDURE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterSaveFields wMaintenance 
PROCEDURE afterSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF AVAIL ttEmitente THEN DO:
        ASSIGN INPUT FRAME fPage1 tg-b2s.

        FIND FIRST int-emitente EXCLUSIVE-LOCK
             WHERE int-emitente.cod-emitente = ttEmitente.cod-emitente NO-ERROR.
        IF AVAIL int-emitente THEN
            ASSIGN int-emitente.b2s = tg-b2s.
    END.
    
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

    DEFINE VARIABLE i-cod-emitente LIKE {&ttTable}.cod-emitente NO-UNDO.

    DEFINE FRAME fGoToRecord
        i-cod-emitente  AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 2.63 COL 2.14
        btGoToCancel      AT ROW 2.63 COL 13
        rtGoToButton      AT ROW 2.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Emitente" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN i-cod-emitente.
        ASSIGN cod-emit = i-cod-emitente.

        RUN goToKey IN {&hDBOTable} (INPUT i-cod-emitente).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "emitente":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        RUN pi-limpa-tela IN THIS-PROCEDURE.

        APPLY "GO":U TO FRAME fGoToRecord.
    END.

    
    ENABLE i-cod-emitente btGoToOK btGoToCancel 
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
       {&hDBOTable}:FILE-NAME <> "esboad098.p":U THEN DO:
        {btb/btb008za.i1 esbo\esboad098.p YES}
        {btb/btb008za.i2 esbo\esboad098.p '' {&hDBOTable}}
    END.

    RUN setConstraintmain IN {&hDBOTable} NO-ERROR.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "main":U) NO-ERROR.


/*

        /*:T--- Verifica se o DBO j  est  inicializado ---*/
        IF NOT VALID-HANDLE({&hDBOTable2}) OR
           {&hDBOTable2}:TYPE <> "PROCEDURE":U OR
           {&hDBOTable2}:FILE-NAME <> "boes043.p":U THEN DO:
            {btb/btb008za.i1 esbo\boes043.p YES}
            {btb/btb008za.i2 esbo\boes043.p '' {&hDBOTable2}}
        END.
    
*/



    RETURN "OK":U.    
    
    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Monta wMaintenance 
PROCEDURE Monta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH ttEmitente:
        DELETE ttEmitente.
    END.
    {&OPEN-QUERY-br-emitente}
    
    
    FIND FIRST emitente WHERE 
         emitente.cod-emitente = cod-emit NO-ERROR.
    IF AVAIL emitente THEN DO:
        CREATE ttEmitente.
                ASSIGN ttEmitente.cod-emitente = emitente.cod-emitente
                       ttEmitente.nome-abrev   = emitente.nome-abrev.
    END.
    ELSE
        LEAVE.

    {&OPEN-QUERY-br-emitente}
    {&OPEN-QUERY-BR-CONTATO}

    APPLY "LEAVE" TO ttemitente.cod-cond-pag IN FRAME fPage1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MontaContato wMaintenance 
PROCEDURE MontaContato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST emitente WHERE
               emitente.cod-emitente = ttEmitente.cod-emitente NO-ERROR.

    IF AVAIL emitente THEN DO:

       BUFFER-COPY emitente TO ttEmitente.

       ASSIGN ttEmitente.nome-abrev:SCREEN-VALUE   IN FRAME fpage1 = emitente.nome-abrev
              ttEmitente.endereco:SCREEN-VALUE     IN FRAME fpage1 = emitente.endereco  
              ttEmitente.bairro:SCREEN-VALUE       IN FRAME fpage1 = emitente.bairro
              ttEmitente.cidade:SCREEN-VALUE       IN FRAME fpage1 = emitente.cidade
              ttEmitente.estado:SCREEN-VALUE       IN FRAME fpage1 = emitente.estado
              ttEmitente.cep:SCREEN-VALUE          IN FRAME fpage1 = emitente.cep
              ttEmitente.cod-cond-pag:SCREEN-VALUE IN FRAME fpage1 = STRING(emitente.cod-cond-pag)
              ttEmitente.cod-transp:SCREEN-VALUE   IN FRAME fpage1 = STRING(emitente.cod-transp)
              ttEmitente.nat-operacao:SCREEN-VALUE IN FRAME fpage1 = emitente.nat-operacao. 

       FIND FIRST int-emitente NO-LOCK
            WHERE int-emitente.cod-emitente = ttEmitente.cod-emitente NO-ERROR.
       IF AVAIL int-emitente THEN
           ASSIGN tg-b2s:SCREEN-VALU IN FRAME fPage1 = STRING(int-emitente.b2s).
       ELSE
           ASSIGN tg-b2s:SCREEN-VALU IN FRAME fPage1 = "No".
    END.

    {&OPEN-QUERY-BR-CONTATO}

    btUpdate:SENSITIVE     IN FRAME fpage0 = TRUE.
    bt-incluir:SENSITIVE   IN FRAME fpage1 = TRUE.
    bt-excluir:SENSITIVE   IN FRAME fpage1 = FALSE.

    APPLY "LEAVE" TO ttemitente.cod-cond-pag IN FRAME fPage1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-variaveis wMaintenance 
PROCEDURE pi-atualiza-variaveis :
/*------------------------------------------------------------------------------
    Purpose:     
    Parameters:  <none>
    Notes:       
------------------------------------------------------------------------------*/

    if  avail cont-emit then
        assign gr-cont-emit = rowid(cont-emit).
    else
        assign gr-cont-emit = ?.
        
    if  avail emitente then
        assign gr-emitente = rowid(emitente).
    else
        assign gr-emitente = ?.    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-limpa-tela wMaintenance 
PROCEDURE pi-limpa-tela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN ttEmitente.nome-abrev:SCREEN-VALUE   IN FRAME fpage1 = ""
           ttEmitente.endereco:SCREEN-VALUE     IN FRAME fpage1 = ""
           ttEmitente.bairro:SCREEN-VALUE       IN FRAME fpage1 = ""
           ttEmitente.cidade:SCREEN-VALUE       IN FRAME fpage1 = ""
           ttEmitente.estado:SCREEN-VALUE       IN FRAME fpage1 = ""
           ttEmitente.cep:SCREEN-VALUE          IN FRAME fpage1 = ""
           ttEmitente.cod-cond-pag:SCREEN-VALUE IN FRAME fpage1 = ""
           ttEmitente.cod-transp:SCREEN-VALUE   IN FRAME fpage1 = ""
           ttEmitente.nat-operacao:SCREEN-VALUE IN FRAME fpage1 = ""
           fi-desc-cond-pag:SCREEN-VALUE        IN FRAME fpage1 = "".

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

