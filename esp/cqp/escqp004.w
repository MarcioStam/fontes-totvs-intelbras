&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          mgmov           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttficha-cq NO-UNDO LIKE ficha-cq
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttitem-fornec NO-UNDO LIKE item-fornec
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttrej-ficha NO-UNDO LIKE rej-ficha
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i escqp004 2.04.000.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        escqp004
&GLOBAL-DEFINE Version        2.04.000.000

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Documento,Destino

&GLOBAL-DEFINE page0Widgets   btExit btHelp btParametros btConfirma btCancela
&GLOBAL-DEFINE page1Widgets   fi-cod-emitente fi-denominacao fi-nat-operacao ~
                              fi-nome-emit fi-nro-docto fi-serie-docto
&GLOBAL-DEFINE page2Widgets   btConfigImpr fiPrinter
&GLOBAL-DEFINE page3Widgets   brItem btAprovar btCondicional btOutros ~
                              btRejeitar
&GLOBAL-DEFINE ttTable        ttficha-cq
&GLOBAL-DEFINE hDBOTable      dboficha-cq
&GLOBAL-DEFINE DBOTable       boin124
&GLOBAL-DEFINE ttTable2       ttitem-fornec
&GLOBAL-DEFINE hDBOTable2     dboitem-fornec
&GLOBAL-DEFINE DBOTable2      boin178
&GLOBAL-DEFINE ttTable3       ttrej-ficha
&GLOBAL-DEFINE hDBOTable3     dborej-ficha
&GLOBAL-DEFINE DBOTable3      esboin378

/* Parameters Definitions ---                                           */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl    AS   HANDLE                    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gs-nr-ficha       LIKE ficha-cq.nr-ficha         NO-UNDO.
DEFINE NEW        SHARED VARIABLE i-lote-multiplo-s LIKE item.lote-multipl         NO-UNDO.
DEFINE NEW        SHARED VARIABLE l-troca-s         AS   LOGICAL                   NO-UNDO.
DEFINE NEW        SHARED VARIABLE i-contenedor-s    AS   DECIMAL                   NO-UNDO.
DEFINE NEW        SHARED VARIABLE c-mensagem-mail-s AS   CHAR                      NO-UNDO.
DEFINE NEW        SHARED VARIABLE i-quantidade-s    LIKE ficha-cq.qt-original      NO-UNDO.
DEFINE NEW        SHARED VARIABLE i-cod-fabric-s    AS   int                       NO-UNDO.
DEFINE NEW        SHARED VARIABLE dt-validade-s     AS   DATE                      NO-UNDO.
DEFINE NEW        SHARED VARIABLE i-cod-rej-s       LIKE cod-rejeicao.codigo-rejei NO-UNDO.
DEFINE NEW        SHARED VARIABLE c-narrativa-s     LIKE ficha-cq.narrativa        NO-UNDO.
DEFINE NEW        SHARED VARIABLE c-localizacao-s   LIKE movto-estoq.cod-localiz   NO-UNDO.
DEFINE NEW        SHARED VARIABLE c-depos-ent-s     LIKE deposito.cod-depos        NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE {&hDBOTable}  AS   HANDLE    NO-UNDO.
DEFINE VARIABLE {&hDBOTable2} AS   HANDLE    NO-UNDO.
DEFINE VARIABLE {&hDBOTable3} AS   HANDLE    NO-UNDO.
DEFINE VARIABLE cPrinter      AS   CHARACTER NO-UNDO.
DEFINE VARIABLE cAuxFile      AS   CHARACTER NO-UNDO.
DEFINE VARIABLE cLayout       AS   CHARACTER NO-UNDO.
DEFINE VARIABLE h_esapi020    AS   HANDLE    NO-UNDO.
DEFINE VARIABLE wh-pesquisa   AS   HANDLE    NO-UNDO.
DEFINE VARIABLE rs-deposito   AS   CHARACTER INITIAL "rec" VIEW-AS RADIO-SET VERTICAL RADIO-BUTTONS "REC", "rec", "IP", "ip" SIZE 12 BY 3 NO-UNDO.
DEFINE VARIABLE i-nr-ae       LIKE ae-item.nr-ae            NO-UNDO.
DEFINE VARIABLE i-seq-ini     LIKE ae-item.sequencia INIT 1 NO-UNDO.
DEFINE VARIABLE l-cond        as   LOGICAL                  NO-UNDO. /* yes = condicional */
DEFINE VARIABLE l-rejei       as   LOGICAL                  NO-UNDO. /* yes = rejeitado */
DEFINE VARIABLE i-tipo        as   INT                      NO-UNDO. /* 1 - aprovado | 2 - rejeitado | 3 - aprovado condicional | 4 - skip lote */
DEFINE VARIABLE c-depos-ent   LIKE deposito.cod-depos       NO-UNDO.
DEFINE VARIABLE i-aprovada    LIKE ficha-cq.qt-aprovada     NO-UNDO.
DEFINE VARIABLE l-perm        as   LOGICAL                  NO-UNDO.
DEFINE VARIABLE i-apr-cond    LIKE ficha-cq.qt-apr-cond     NO-UNDO.
DEFINE VARIABLE i-rejeitada   LIKE ficha-cq.qt-rejeitada    NO-UNDO.
DEFINE VARIABLE c-loc-x       LIKE saldo-estoq.cod-localiz  NO-UNDO.
DEFINE VARIABLE c-msg         AS   CHAR                     NO-UNDO.
DEFINE VARIABLE i-cont        AS   INTEGER                  NO-UNDO.
DEFINE VARIABLE c-cod-fabric  AS   CHAR                     NO-UNDO.

DEFINE VARIABLE p-msg-erro AS CHARACTER   NO-UNDO.

{esp/es0478.i "new"} /* definicao de variaveis */
{esp/es0478-rpc.i}
{esp/es0018.i} /* ponto-programa */

DEF TEMP-TABLE tt-troca
    FIELD rec-ficha AS ROWID
    FIELD troca AS LOGICAL.

DEF TEMP-TABLE tt-item-sem-fornecedor NO-UNDO
    FIELD it-codigo LIKE ITEM.it-codigo.

DEF BUFFER b-emitente FOR emitente.

DEF TEMP-TABLE ttficha-cq-unique LIKE ttficha-cq.

DEFINE VARIABLE marca AS CHAR.

{upc\btb910za-upc.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brItem

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttficha-cq item

/* Definitions for BROWSE brItem                                        */
&Scoped-define FIELDS-IN-QUERY-brItem ttficha-cq.it-codigo item.desc-item ~
ttficha-cq.nr-ficha ttficha-cq.qt-original ttficha-cq.qt-aprovada ~
ttficha-cq.qt-apr-cond ttficha-cq.qt-rejeitada ttficha-cq.codigo-rejei ~
ttficha-cq.log-1 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brItem 
&Scoped-define QUERY-STRING-brItem FOR EACH ttficha-cq NO-LOCK, ~
      FIRST item OF ttficha-cq NO-LOCK ~
    BY ttficha-cq.it-codigo ~
       BY ttficha-cq.cod-emitente ~
        BY ttficha-cq.dt-inspecao INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brItem OPEN QUERY brItem FOR EACH ttficha-cq NO-LOCK, ~
      FIRST item OF ttficha-cq NO-LOCK ~
    BY ttficha-cq.it-codigo ~
       BY ttficha-cq.cod-emitente ~
        BY ttficha-cq.dt-inspecao INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brItem ttficha-cq item
&Scoped-define FIRST-TABLE-IN-QUERY-brItem ttficha-cq
&Scoped-define SECOND-TABLE-IN-QUERY-brItem item


/* Definitions for FRAME fpage3                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage3 ~
    ~{&OPEN-QUERY-brItem}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 btConfirma btParametros btExit ~
btHelp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 btCancela btConfirma 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-situacao-ficha wWindow 
FUNCTION fn-situacao-ficha RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-valida-operacao wWindow 
FUNCTION fn-valida-operacao RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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
DEFINE BUTTON btCancela 
     IMAGE-UP FILE "image/im-can.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-can.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Cancela"
     FONT 4.

DEFINE BUTTON btConfirma 
     IMAGE-UP FILE "image/im-sav.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-sav.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Confirma"
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btParametros 
     IMAGE-UP FILE "image/im-param.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-param.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "ParÉmetros"
     FONT 4.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE fi-cod-emitente AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Emitente":R10 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-denominacao AS CHARACTER FORMAT "x(35)" 
     VIEW-AS FILL-IN 
     SIZE 41.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nat-operacao AS CHARACTER FORMAT "x(06)" 
     LABEL "Nat Operaá∆o":R15 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-emit AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 46.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nro-docto AS CHARACTER FORMAT "x(16)" 
     LABEL "Documento":R11 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-serie-docto AS CHARACTER FORMAT "x(5)" 
     LABEL "SÇrie":R7 
     VIEW-AS FILL-IN 
     SIZE 6.86 BY .88 NO-UNDO.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "Configuraá∆o da impressora" 
     SIZE 4 BY 1 TOOLTIP "Configuraá∆o da impressora".

DEFINE VARIABLE fiPrinter AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 44 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 61 BY 2.25.

DEFINE BUTTON btAprovar 
     LABEL "&Aprovar" 
     SIZE 10 BY 1.

DEFINE BUTTON btCondicional 
     LABEL "&Condicional" 
     SIZE 10 BY 1.

DEFINE BUTTON btOutros 
     LABEL "&Outros" 
     SIZE 10 BY 1.

DEFINE BUTTON btRejeitar 
     LABEL "&Rejeitar" 
     SIZE 10 BY 1.

DEFINE VARIABLE tg-condicional AS LOGICAL INITIAL no 
     LABEL "Escrever Condicional" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brItem FOR 
      ttficha-cq, 
      item SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brItem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brItem wWindow _STRUCTURED
  QUERY brItem NO-LOCK DISPLAY
      ttficha-cq.it-codigo FORMAT "x(16)":U WIDTH 8
      item.desc-item FORMAT "x(60)":U WIDTH 20
      ttficha-cq.nr-ficha COLUMN-LABEL "Roteiro" FORMAT ">>>>,>>9":U
      ttficha-cq.qt-original COLUMN-LABEL "Quantidade" FORMAT ">>,>>>,>>9":U
            WIDTH 9.57
      ttficha-cq.qt-aprovada COLUMN-LABEL "Aprovada" FORMAT ">>,>>>,>>9":U
            WIDTH 9.57
      ttficha-cq.qt-apr-cond COLUMN-LABEL "Condicional" FORMAT ">>,>>>,>>9":U
            WIDTH 9.57
      ttficha-cq.qt-rejeitada COLUMN-LABEL "Rejeitada" FORMAT ">>,>>>,>>9":U
            WIDTH 9.57
      ttficha-cq.codigo-rejei COLUMN-LABEL "CR" FORMAT ">9":U
      ttficha-cq.log-1 COLUMN-LABEL "T" FORMAT "X/":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 84 BY 8
         FONT 1 ROW-HEIGHT-CHARS .46 FIT-LAST-COLUMN TOOLTIP "Duplo-clique alterna troca/n∆o troca contenedor".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btCancela AT ROW 1.13 COL 1.72 HELP
          "Sair"
     btConfirma AT ROW 1.13 COL 5.72 HELP
          "Sair"
     btParametros AT ROW 1.13 COL 9.72 HELP
          "Sair"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda" NO-TAB-STOP 
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.33
         FONT 1.

DEFINE FRAME fPage2
     btConfigImpr AT ROW 3.79 COL 62.57 HELP
          "Configuraá∆o da impressora" WIDGET-ID 32
     fiPrinter AT ROW 3.88 COL 18 NO-LABEL WIDGET-ID 34 NO-TAB-STOP 
     "Destino:" VIEW-AS TEXT
          SIZE 7.29 BY .54 AT ROW 3 COL 12.72 WIDGET-ID 28
     RECT-4 AT ROW 3.21 COL 11 WIDGET-ID 22
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.6 ROW 3.71
         SIZE 84.4 BY 13.29
         FONT 1.

DEFINE FRAME fpage3
     brItem AT ROW 1.25 COL 1.29 HELP
          "A = Aprovar  C = Condicional  R = Rejeitar O = Outros"
     btAprovar AT ROW 9.25 COL 1.29
     btCondicional AT ROW 9.25 COL 11.29
     btRejeitar AT ROW 9.25 COL 21.29
     btOutros AT ROW 9.25 COL 31.29
     tg-condicional AT ROW 9.25 COL 67
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 7.75
         SIZE 84.43 BY 9.5
         FONT 1.

DEFINE FRAME fPage1
     fi-cod-emitente AT ROW 1.17 COL 11 COLON-ALIGNED
     fi-nome-emit AT ROW 1.17 COL 23 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     fi-serie-docto AT ROW 2.17 COL 11 COLON-ALIGNED
     fi-nro-docto AT ROW 3.17 COL 11 COLON-ALIGNED
     fi-nat-operacao AT ROW 4.17 COL 11 COLON-ALIGNED
     fi-denominacao AT ROW 4.17 COL 19.72 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.6 ROW 3.7 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window Template
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttficha-cq T "?" NO-UNDO mgmov ficha-cq
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttitem-fornec T "?" NO-UNDO mgcad item-fornec
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttrej-ficha T "?" NO-UNDO mgmov rej-ficha
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
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
         HEIGHT             = 17.33
         WIDTH              = 90
         MAX-HEIGHT         = 19.88
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 19.88
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

{esp/ShowMsg.i}
{window/window.i}
{esp/eslib.i}
{btb/btb008za.i0}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fpage3:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON btCancela IN FRAME fpage0
   NO-ENABLE 1                                                          */
/* SETTINGS FOR BUTTON btConfirma IN FRAME fpage0
   1                                                                    */
/* SETTINGS FOR FRAME fPage1
   Size-to-Fit                                                          */
ASSIGN 
       FRAME fPage1:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN fi-denominacao IN FRAME fPage1
   NO-ENABLE                                                            */
ASSIGN 
       fi-denominacao:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FILL-IN fi-nome-emit IN FRAME fPage1
   NO-ENABLE                                                            */
ASSIGN 
       fi-nome-emit:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR BUTTON btConfigImpr IN FRAME fPage2
   NO-ENABLE                                                            */
ASSIGN 
       fiPrinter:READ-ONLY IN FRAME fPage2        = TRUE.

/* SETTINGS FOR FRAME fpage3
                                                                        */
/* BROWSE-TAB brItem 1 fpage3 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brItem
/* Query rebuild information for BROWSE brItem
     _TblList          = "Temp-Tables.ttficha-cq,mgcad.item OF Temp-Tables.ttficha-cq"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST"
     _OrdList          = "Temp-Tables.ttficha-cq.it-codigo|yes,Temp-Tables.ttficha-cq.cod-emitente|yes,Temp-Tables.ttficha-cq.dt-inspecao|yes"
     _FldNameList[1]   > Temp-Tables.ttficha-cq.it-codigo
"ttficha-cq.it-codigo" ? ? "character" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > mgcad.item.desc-item
"item.desc-item" ? ? "character" ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.ttficha-cq.nr-ficha
"ttficha-cq.nr-ficha" "Roteiro" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.ttficha-cq.qt-original
"ttficha-cq.qt-original" "Quantidade" ">>,>>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "9.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.ttficha-cq.qt-aprovada
"ttficha-cq.qt-aprovada" "Aprovada" ">>,>>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "9.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ttficha-cq.qt-apr-cond
"ttficha-cq.qt-apr-cond" "Condicional" ">>,>>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "9.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.ttficha-cq.qt-rejeitada
"ttficha-cq.qt-rejeitada" "Rejeitada" ">>,>>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "9.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.ttficha-cq.codigo-rejei
"ttficha-cq.codigo-rejei" "CR" ">9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.ttficha-cq.log-1
"ttficha-cq.log-1" "T" "X/" "logical" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brItem */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage3
/* Query rebuild information for FRAME fpage3
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage3 */
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


&Scoped-define SELF-NAME fpage0
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fpage0 wWindow
ON GO OF FRAME fpage0
DO:
    tg-condicional:SENSITIVE IN FRAME fpage3 = TRUE.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brItem
&Scoped-define FRAME-NAME fpage3
&Scoped-define SELF-NAME brItem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brItem wWindow
ON a OF brItem IN FRAME fpage3
OR "A" OF BROWSE brItem DO:
    APPLY "choose" TO btAprovar IN FRAME fpage3.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brItem wWindow
ON c OF brItem IN FRAME fpage3
OR "C" OF BROWSE brItem DO:
    APPLY "choose" TO btCondicional IN FRAME fpage3.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brItem wWindow
ON MOUSE-SELECT-DBLCLICK OF brItem IN FRAME fpage3
DO:
  IF AVAIL ttficha-cq THEN DO:
      FIND FIRST tt-troca
          WHERE tt-troca.rec-ficha = ttficha-cq.r-rowid NO-ERROR.
      IF NOT AVAIL tt-troca THEN
          CREATE tt-troca.
      ASSIGN tt-troca.troca = NOT tt-troca.troca
             tt-troca.rec-ficha = ttficha-cq.r-rowid
             ttficha-cq.log-1:SCREEN-VALUE IN BROWSE brItem = STRING(tt-troca.troca).

  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brItem wWindow
ON o OF brItem IN FRAME fpage3
OR "O" OF BROWSE brItem DO:
  APPLY "choose" TO btOutros IN FRAME fpage3.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brItem wWindow
ON r OF brItem IN FRAME fpage3
OR "R" OF BROWSE brItem DO:
    APPLY "choose" TO btRejeitar IN FRAME fpage3.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brItem wWindow
ON ROW-DISPLAY OF brItem IN FRAME fpage3
DO:
    IF AVAIL ttficha-cq THEN DO:
        FIND FIRST tt-troca
            WHERE tt-troca.rec-ficha = ttficha-cq.r-rowid NO-ERROR.
        IF AVAIL tt-troca THEN
            ttficha-cq.log-1:SCREEN-VALUE IN BROWSE brItem = STRING(tt-troca.troca).
        ELSE
            ttficha-cq.log-1:SCREEN-VALUE IN BROWSE brItem = "NO".

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAprovar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAprovar wWindow
ON CHOOSE OF btAprovar IN FRAME fpage3 /* Aprovar */
DO:
  IF fn-valida-operacao() THEN DO:
      run prepara. 
      IF RETURN-VALUE = "NOK" THEN RETURN NO-APPLY.

      assign l-cond  = no
             l-rejei = no
             i-tipo = 1
             c-depos-ent = if rs-deposito = "rec" then "alm"
             else "exp".

      run esp/es0590a.p (input "escqp004", 
                        input c-depos-ent,
                        input yes, /*ent*/
                        INPUT c-seg-usuario,
                        output l-perm).

      if not l-perm then RETURN NO-APPLY. 
      run busca-lote.
      i-contenedor-s = i-lote-multiplo-s.
      RUN esp/cqp/escqp004a.w (INPUT ttficha-cq.r-rowid, INPUT 1, OUTPUT c-cod-fabric).
      IF RETURN-VALUE = "NOK" THEN RETURN NO-APPLY.
      i-aprovada = i-quantidade-s.
      
      IF congelado(input v_cod_estab_usuar,
                   input ttficha-cq.it-codigo,
                   input rs-deposito,
                   input ?) then do:
          RUN ShowMessage (1, "Item/Dep¢sito/Localizaá∆o de Origem Congelada para Invent†rio", "").
          RETURN NO-APPLY.
      end.
      IF congelado(input v_cod_estab_usuar,
                   input ttficha-cq.it-codigo,
                   input c-depos-ent,
                   input ?) then do:
          RUN ShowMessage (1, "Item/Dep¢sito/Localizaá∆o de Origem Congelada para Invent†rio", "").
          RETURN NO-APPLY.
      end.

      run aprova.
      IF l-deu-erro THEN DO:
          RUN ShowMessage (2, "Ocorreram problemas na transferància", "").
      END.
      ELSE DO:

          /***
          FIND FIRST reservas-ast
              WHERE reservas-ast.cod-estabel  = v_cod_estab_usuar
                AND reservas-ast.cod-depos    = rs-deposito
                AND reservas-ast.it-codigo    = item.it-codigo NO-LOCK NO-ERROR.
          IF AVAIL reservas-ast THEN DO:

             assign cMensagem = cMensagem + '~nSaldo dispon°vel para movimentaá∆o: Estab: ' + reservas-ast.cod-estabel + ', Dep¢sito: ' + reservas-ast.cod-depos + ', ITEM: ' + reservas-ast.it-codigo + '~n'.

              /** Manda e-mail **/
              if (cMensagem <> '') THEN DO:

                  FOR FIRST mgesp.ponto-programa
                      WHERE ponto-programa.nome-programa = "escqp004"
                        AND ponto-programa.ponto         = 2,
                       EACH mgesp.conteudo-programa exclusive-lock
                      WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

                      run enviaMail (input 'ems@intelbras.com.br', input conteudo-programa.conteudo, input 'Saldo Dispon°vel para Transferància', input cMensagem).

                  END. /* FOR FIRST mgesp.ponto-programa */

              END. /* if (cMensagem <> '') THEN DO: */

          END. /* IF AVAIL reservar-ast THEN DO: */
          ***/
          
          RUN ShowMessage (2, "Transferància executada com sucesso", "").

      END.

      RUN piRecarrega.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancela wWindow
ON CHOOSE OF btCancela IN FRAME fpage0
DO:
    CLEAR FRAME fpage1 ALL.
    ENABLE ALL WITH FRAME fpage1.
    DISABLE ALL WITH FRAME fpage3.
    ENABLE {&List-1} WITH FRAME fpage0.
    EMPTY TEMP-TABLE ttficha-cq.
    {&OPEN-QUERY-brItem}
    run setFolder IN hFolder (input 1).
    APPLY "entry" TO fi-cod-emitente IN FRAME fpage1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage3
&Scoped-define SELF-NAME btCondicional
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCondicional wWindow
ON CHOOSE OF btCondicional IN FRAME fpage3 /* Condicional */
DO:
    
    IF tg-condicional:CHECKED = YES THEN DO:
       ASSIGN Marca = "CONDIC.".
    END.
    ELSE DO:
       ASSIGN Marca = "".
    END.


    IF fn-valida-operacao() THEN DO:
       RUN prepara. 
       IF RETURN-VALUE = "NOK" THEN RETURN NO-APPLY.

       ASSIGN l-cond      = YES
              l-rejei     = NO
              i-tipo      = 3
              c-depos-ent = IF rs-deposito = "rec" THEN 
                               "alm"
                            ELSE 
                               "exp".

       RUN esp/es0590a.p (input "escqp004", 
                          input c-depos-ent,
                          input yes, /*ent*/
                          INPUT c-seg-usuario,
                          output l-perm).

       IF NOT l-perm THEN RETURN NO-APPLY. 
       RUN busca-lote.
       i-contenedor-s = i-lote-multiplo-s.
       RUN esp/cqp/escqp004a.w (INPUT ttficha-cq.r-rowid, INPUT 3, OUTPUT c-cod-fabric).
       IF RETURN-VALUE = "NOK" THEN RETURN NO-APPLY.
       i-apr-cond = i-quantidade-s.

       IF congelado(input v_cod_estab_usuar,
                    input ttficha-cq.it-codigo,
                    input rs-deposito,
                    input ?) THEN DO:
          RUN ShowMessage (1, "Item/Dep¢sito/Localizaá∆o de Origem Congelada para Invent†rio", "").
          RETURN NO-APPLY.
       END.

       IF congelado(input v_cod_estab_usuar,
                    input ttficha-cq.it-codigo,
                    input c-depos-ent,
                    input ?) THEN DO:
          RUN ShowMessage (1, "Item/Dep¢sito/Localizaá∆o de Origem Congelada para Invent†rio", "").
          RETURN NO-APPLY.
       END.

       RUN criaRejFicha.

       RUN aprova.

       IF l-deu-erro THEN DO:
          RUN ShowMessage (2, "Ocorreram problemas na transferància", "").
          RETURN NO-APPLY.
       END.
       ELSE 
          RUN ShowMessage (2, "Transferància executada com sucesso", "").

       RUN imprime-rej.

       RUN piRecarrega.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btConfigImpr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfigImpr wWindow
ON CHOOSE OF btConfigImpr IN FRAME fPage2 /* Configuraá∆o da impressora */
DO:
    RUN piSelectPrinter IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btConfirma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfirma wWindow
ON CHOOSE OF btConfirma IN FRAME fpage0
DO:
  ASSIGN INPUT FRAME fpage1 fi-cod-emitente fi-nat-operacao fi-nro-docto fi-serie-docto.

  IF NOT CAN-FIND(FIRST ae-inspecao NO-LOCK
                  where ae-inspecao.cod-estabel  = v_cod_estab_usuar
                  AND   ae-inspecao.cod-emitente = fi-cod-emitente
                  and ae-inspecao.serie          = fi-serie-docto
                  and ae-inspecao.nro-docto      = int(fi-nro-docto)) THEN DO:
      RUN ShowMessage (1, "ATENÄ«O! N∆o encontrado ficha para Nota." + CHR(10) + "Poss°veis Motivos:",
                 "1)Nota j† liberada." + chr(10) + 
                 "2)ITEM n∆o gera ficha. Verificar(CQ0124)" + chr(10) +  
                 "3)Chave da nota digitada pode estar diferente DO lanáamento. Verificar(CE0814).").
      run setFolder IN hFolder (input 1).
      APPLY "entry" TO fi-cod-emitente IN FRAME fpage1.
      RETURN NO-APPLY.
  END.

  EMPTY TEMP-TABLE ttficha-cq.
  EMPTY TEMP-TABLE tt-item-sem-fornecedor.
  FOR EACH ficha-cq NO-LOCK
      WHERE ficha-cq.cod-estabel  = v_cod_estab_usuar
      and   ficha-cq.cod-emitente = fi-cod-emitente
      AND   ficha-cq.serie-docto  = fi-serie-docto
      AND   ficha-cq.nro-docto    = fi-nro-docto
      AND   ficha-cq.nat-operacao = fi-nat-operacao
      AND   ficha-cq.situacao     = 1:
      CREATE ttficha-cq.
      BUFFER-COPY ficha-cq TO ttficha-cq.
      ttficha-cq.r-rowid = ROWID(ficha-cq).
      IF substring(fi-nat-operacao, 2, 2) NE "13" THEN DO:
          IF NOT can-find(FIRST item-fornec NO-LOCK
                          where item-fornec.it-codigo = ficha-cq.it-codigo
                          and item-fornec.cod-emitente = ficha-cq.cod-emitente) THEN DO:
              FOR FIRST emitente FIELDS (nome-matriz) NO-LOCK
                  WHERE emitente.cod-emitente = fi-cod-emitente,
                  EACH b-emitente FIELDS (cod-emitente) NO-LOCK
                  WHERE b-emitente.nome-matriz = emitente.nome-matriz:
                  IF NOT can-find(FIRST item-fornec NO-LOCK
                                  where item-fornec.it-codigo = ficha-cq.it-codigo
                                  and item-fornec.cod-emitente = b-emitente.cod-emitente) THEN DO:
                      FIND FIRST tt-item-sem-fornecedor
                          WHERE tt-item-sem-fornecedor.it-codigo = ficha-cq.it-codigo NO-ERROR.
                      IF NOT AVAIL tt-item-sem-fornecedor THEN DO:
                          CREATE tt-item-sem-fornecedor.
                          tt-item-sem-fornecedor.it-codigo = ficha-cq.it-codigo.
                      END.
                  END.
              END.
          END.
      END.
  END.
  {&OPEN-QUERY-brItem}
  IF BROWSE brItem:NUM-ITERATIONS > 0 THEN
      ENABLE ALL WITH FRAME fpage3.
  ELSE DO:
      DISABLE ALL WITH FRAME fpage3.
      RUN ShowMessage (2, "Nota j† foi totalmente liberada", "").
      run setFolder IN hFolder (input 1).
      APPLY "entry" TO fi-cod-emitente IN FRAME fpage1.
      RETURN NO-APPLY.
  END.
  IF CAN-FIND(FIRST tt-item-sem-fornecedor) THEN DO:
      ASSIGN c-msg  = ""
             i-cont = 0.
      FOR EACH tt-item-sem-fornecedor:
        ASSIGN c-msg  = c-msg + tt-item-sem-fornecedor.it-codigo + " "
               i-cont = i-cont + 1.
      END.
      c-msg = "N∆o foram encontrados relacionamentos Item Fornecedor para o" +
              IF i-cont > 1 THEN "s" ELSE "" + " ite" + IF i-cont > 1 THEN "ns" ELSE "m" +
              " abaixo:~n" + TRIM(c-msg).

      RUN ShowMessage (3, "Relaá∆o Item Fornecedor n∆o cadastrada.~nA nota n∆o ser† liberada. Continua?", 
                       c-msg).
      IF RETURN-VALUE = "no" THEN DO:
          run setFolder IN hFolder (input 1).
          APPLY "entry" TO fi-cod-emitente IN FRAME fpage1.
          RETURN NO-APPLY.
      END.
  END.
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


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage3
&Scoped-define SELF-NAME btOutros
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOutros wWindow
ON CHOOSE OF btOutros IN FRAME fpage3 /* Outros */
DO:
    IF fn-valida-operacao() THEN DO:
        run prepara. 
        IF RETURN-VALUE = "NOK" THEN RETURN NO-APPLY.

        assign l-cond  = no
               l-rejei = no
               i-tipo = 1.

        /*
        run esp/es0590a.p (input "es0483", 
                          input c-depos-ent,
                          input yes, /*ent*/
                          output l-perm).

        if not l-perm then RETURN NO-APPLY. 
        */
        run busca-lote.
        i-contenedor-s = i-lote-multiplo-s.
        RUN esp/cqp/escqp004a.w (INPUT ttficha-cq.r-rowid, INPUT 4, OUTPUT c-cod-fabric).
        IF RETURN-VALUE = "NOK" THEN RETURN NO-APPLY.
        ASSIGN i-aprovada  = i-quantidade-s
               c-depos-ent = c-depos-ent-s.
        IF congelado(input v_cod_estab_usuar,
                     input ttficha-cq.it-codigo,
                     input rs-deposito,
                     input ?) then do:
            RUN ShowMessage (1, "Item/Dep¢sito/Localizaá∆o de Origem Congelada para Invent†rio", "").
            RETURN NO-APPLY.
        end.
        IF congelado(input v_cod_estab_usuar,
                     input ttficha-cq.it-codigo,
                     input c-depos-ent,
                     input ?) then do:
            RUN ShowMessage (1, "Item/Dep¢sito/Localizaá∆o de Origem Congelada para Invent†rio", "").
            RETURN NO-APPLY.
        end.

        run aprova.
        IF l-deu-erro THEN DO:
            RUN ShowMessage (2, "Ocorreram problemas na transferància", "").
        END.
        ELSE DO:

            RUN piEnviaEmail.
             
            RUN ShowMessage (2, "Transferància executada com sucesso", "").

        END.

        if c-depos-ent = "hml" then run imprime-hml.
        RUN piRecarrega.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btParametros
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btParametros wWindow
ON CHOOSE OF btParametros IN FRAME fpage0
DO:
  RUN pi-parametro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage3
&Scoped-define SELF-NAME btRejeitar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRejeitar wWindow
ON CHOOSE OF btRejeitar IN FRAME fpage3 /* Rejeitar */
DO:
    IF fn-valida-operacao() THEN DO:
        run prepara. 
        IF RETURN-VALUE = "NOK" THEN RETURN NO-APPLY.

        assign l-cond  = NO
               l-rejei = YES
               i-tipo = 2
               i-contenedor-s = 0
               c-localizacao-s = "".

        run busca-lote.
        i-contenedor-s = i-lote-multiplo-s.
        RUN esp/cqp/escqp004a.w (INPUT ttficha-cq.r-rowid, INPUT 2, OUTPUT c-cod-fabric).
        IF RETURN-VALUE = "NOK" THEN RETURN NO-APPLY.
        ASSIGN c-depos-ent = IF i-cod-rej-s = 4 THEN "fal" 
                             ELSE 
                                IF i-cod-rej-s = 15 THEN "tra" ELSE "dev"
               i-rejeitada  = i-quantidade-s.
        run esp/es0590a.p (input "escqp004", 
                          input c-depos-ent,
                          input yes, /*ent*/
                          INPUT c-seg-usuario,
                          output l-perm).

        if not l-perm then RETURN NO-APPLY. 

        IF congelado(input v_cod_estab_usuar,
                     input ttficha-cq.it-codigo,
                     input rs-deposito,
                     input ?) then do:
            RUN ShowMessage (1, "Item/Dep¢sito/Localizaá∆o de Origem Congelada para Invent†rio", "").
            RETURN NO-APPLY.
        end.
        IF congelado(input v_cod_estab_usuar,
                     input ttficha-cq.it-codigo,
                     input c-depos-ent,
                     input ?) then do:
            RUN ShowMessage (1, "Item/Dep¢sito/Localizaá∆o de Origem Congelada para Invent†rio", "").
            RETURN NO-APPLY.
        end.

        RUN criaRejFicha.

        run aprova.
        IF l-deu-erro THEN DO:
            RUN ShowMessage (2, "Ocorreram problemas na transferància", "").
            RETURN NO-APPLY.
        END.
        ELSE RUN ShowMessage (2, "Transferància executada com sucesso", "").
        run imprime-rej.
        RUN piRecarrega.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME fi-cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-emitente wWindow
ON F5 OF fi-cod-emitente IN FRAME fPage1 /* Emitente */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in090"
                       &campo="fi-nat-operacao"
                       &campozoom="nat-operacao"
                       &frame="fPage1"
                       &campo2="fi-nro-docto"
                       &campozoom2="nro-docto"
                       &frame2="fPage1"
                       &campo3="fi-serie-docto"
                       &campozoom3="serie-docto"
                       &frame3="fPage1"
                       &campo4="fi-cod-emitente"
                       &campozoom4="cod-emitente"
                       &frame4="fPage1"}
                       
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-emitente wWindow
ON LEAVE OF fi-cod-emitente IN FRAME fPage1 /* Emitente */
DO:
    {include/leave.i &tabela=emitente
                     &atributo-ref=nome-emit
                     &variavel-ref=fi-nome-emit
                     &where="emitente.cod-emitente = input frame fpage1 fi-cod-emitente"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-emitente wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-cod-emitente IN FRAME fPage1 /* Emitente */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-nat-operacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nat-operacao wWindow
ON LEAVE OF fi-nat-operacao IN FRAME fPage1 /* Nat Operaá∆o */
DO:
    {include/leave.i &tabela=natur-oper
                     &atributo-ref=denominacao
                     &variavel-ref=fi-denominacao
                     &where="natur-oper.nat-operacao = input frame fpage1 fi-nat-operacao"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/MainBlock.i}

{esp/es0020.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterdestroyInterface wWindow 
PROCEDURE AfterdestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*--- Destr¢i os Servidores RPC inicializados pelos DBOs ---*/
    {btb/btb008za.i3}
        
    /*Alteracao para deletar da mem¢ria o WindowStyles e o btb008za.p*/
    IF VALID-HANDLE(h-servid-rpc) THEN
    DO:
       DELETE PROCEDURE h-servid-rpc.
       ASSIGN h-servid-rpc = ?. /*Garantir que a vari†vel n∆o vai mais apontar para nenhum handle de outro objeto - este problema apareceu na v9.1B com Windows2000*/
    END.

    IF VALID-HANDLE(hWindowStyles) THEN
        DELETE PROCEDURE hWindowStyles.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterinitializeInterface wWindow 
PROCEDURE AfterinitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    fi-cod-emitente:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
    
    APPLY "entry" TO fi-cod-emitente IN FRAME fpage1.
/*     FOR FIRST param-estoq NO-LOCK: */
/*     END. */
    RUN initializeDBOs.
    DISABLE ALL WITH FRAME fpage3.
    CREATE ttficha-cq-unique.

    FOR FIRST imprsor_usuar NO-LOCK
        WHERE imprsor_usuar.cod_usuario = c-seg-usuario
        AND   imprsor_usuar.log_imprsor_princ:

        FOR FIRST layout_impres NO-LOCK
            WHERE layout_impres.nom_impressora = imprsor_usuar.nom_impressora
            AND   layout_impres.log_layout_impres_princ:

            ASSIGN fiPrinter:SCREEN-VALUE IN FRAME fPage2 = layout_impres.nom_impressora + ":" +
                                                            layout_impres.cod_layout_impres.

        END.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE aprova wWindow 
PROCEDURE aprova :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DISABLE {&List-1} WITH FRAME fpage0.
    DISABLE ALL WITH FRAME fpage1.
    DISABLE ALL WITH FRAME fpage3.

    def var p-localiz as char no-undo.
    def var l-local-informado as logical no-undo.


    FOR FIRST int-item-fornec NO-LOCK
        WHERE int-item-fornec.it-codigo = ttficha-cq.it-codigo
        AND   int-item-fornec.cod-emitente = ttficha-cq.cod-emitente:

        IF int-item-fornec.obs-rec <> ? AND
           int-item-fornec.obs-rec <> "" THEN DO:

            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 27100,
                               INPUT "Este item contÇm a informaá∆o abaixo. Deseja aprovar o item assim mesmo ?~~" + int-item-fornec.obs-rec).


            IF RETURN-VALUE = "no" THEN DO:

                ASSIGN l-deu-erro = TRUE.

                RETURN "NOK":U.

            END.

        END.

    END.


    ASSIGN ttficha-cq.cod-resp = c-seg-usuario.

    IF l-cond THEN 
       ASSIGN ttficha-cq.qt-apr-cond  = ttficha-cq.qt-apr-cond + i-apr-cond
              ttficha-cq.codigo-rejei = i-cod-rej-s
              ttficha-cq.narrativa    = c-narrativa-s .
    IF NOT l-cond  AND 
       NOT l-rejei THEN      
       ASSIGN ttficha-cq.qt-aprovada  = ttficha-cq.qt-aprovada + i-aprovada
              ttficha-cq.narrativa    = c-narrativa-s .

    IF l-rejei THEN      
       ASSIGN ttficha-cq.qt-rejeitada = ttficha-cq.qt-rejeitada + i-rejeitada
              ttficha-cq.codigo-rejei = i-cod-rej-s
              ttficha-cq.narrativa     = c-narrativa-s .
         
    IF c-depos-ent = "hml" THEN 
       ASSIGN ttficha-cq.codigo-rejei = 12.

    FIND int-ficha-cq OF ttficha-cq exclusive-lock NO-ERROR.
    IF NOT AVAIL int-ficha-cq THEN DO:
       CREATE int-ficha-cq.
              ASSIGN int-ficha-cq.nr-ficha = ttficha-cq.nr-ficha.
    END.
    ASSIGN int-ficha-cq.cod-fabric = i-cod-fabric-s.
             
    FIND FIRST saldo-estoq NO-LOCK                               WHERE
               saldo-estoq.it-codigo = item.it-codigo            AND
               saldo-estoq.cod-depos = rs-deposito               AND
               saldo-estoq.cod-estabel = v_cod_estab_usuar AND
               saldo-estoq.qtidade-atu > 0                       NO-ERROR.
    IF AVAIL saldo-estoq THEN 
       ASSIGN c-loc-x = saldo-estoq.cod-localiz.
    ELSE 
       ASSIGN c-loc-x = "".
    
    l-deu-erro = NO.

    assign p-localiz = IF LOOKUP(c-depos-ent,"hml,dev") > 0 THEN c-localizacao-s ELSE ""
           l-local-informado = if LOOKUP(c-depos-ent,"hml,dev") > 0 then yes else no.

    RUN piTransfere (input i-quantidade-s,                        /* quantidade total */
                     input ttficha-cq.nro-docto,                  /* numero docto */
                     input ttficha-cq.serie-docto,                /* serie */
                     input i-nr-ae,                               /* numero do AE */
                     input 0,                                     /* sequencia do AE */
                     input ttficha-cq.nr-ficha,                   /* roteiro */  
                     input int(ttficha-cq.nro-docto),             /* nota */
                     input i-contenedor-s,                        /* contenedor */
                     input 0,                                     /* fornecedor */
                     INPUT marca,                                 /* Marca Condicional */
                     INPUT l-local-informado,                     /* usa local informado */
                     input p-localiz).                            /* local destino */

    if not l-deu-erro then do:                     
        ASSIGN ttficha-cq.inspecionado = yes
               ttficha-cq.liberada     = yes
               ttficha-cq.situacao     = fn-situacao-ficha()
               ttficha-cq.dt-inspecao  = today.
        
        IF ttficha-cq.situacao = 4 THEN 
           RUN trata-skip-lote. 

        RUN emptyRowErrors IN {&hDBOTable} NO-ERROR.        
        RUN setConstraintNrFicha IN {&hDBOTable} (INPUT ttficha-cq.nr-ficha,
                                                  INPUT ttficha-cq.nr-ficha).
        RUN openQueryStatic IN {&hDBOTable} (INPUT "NrFicha":U) NO-ERROR.
        FIND FIRST ttficha-cq-unique NO-ERROR.
        BUFFER-COPY ttficha-cq TO ttficha-cq-unique.
        RUN setrecord IN {&hDBOTable} (INPUT TABLE ttficha-cq-unique).  
        RUN updaterecord IN {&hDBOTable}.                        
        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.errortype = "error") THEN DO:
            {method/ShowMessage.i1}.
            {method/ShowMessage.i2 &Modal="YES"}.
            {method/ShowMessage.i3}.
        END.
    end.

    RETURN "OK":U.
                     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforedestroyInterface wWindow 
PROCEDURE BeforedestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        &IF "{&hDBOTable}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable}) THEN
                RUN destroy IN {&hDBOTable}.
        &ENDIF

        &IF "{&hDBOTable2}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable2}) THEN
                RUN destroy IN {&hDBOTable2}.
        &ENDIF

        &IF "{&hDBOTable3}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable3}) THEN
                RUN destroy IN {&hDBOTable3}.
        &ENDIF

        &IF "{&hDBOTable4}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable4}) THEN
                RUN destroy IN {&hDBOTable4}.
        &ENDIF

        &IF "{&hDBOTable5}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable5}) THEN
                RUN destroy IN {&hDBOTable5}.
        &ENDIF
        
        &IF "{&hDBOTable6}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable6}) THEN
                RUN destroy IN {&hDBOTable6}.
        &ENDIF

        &IF "{&hDBOTable7}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable7}) THEN
                RUN destroy IN {&hDBOTable7}.
        &ENDIF

        &IF "{&hDBOTable8}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable8}) THEN
                RUN destroy IN {&hDBOTable8}.
        &ENDIF

        &IF "{&hDBOTable9}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable9}) THEN
                RUN destroy IN {&hDBOTable9}.
        &ENDIF
        
        &IF "{&hDBOTable10}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable10}) THEN
                RUN destroy IN {&hDBOTable10}.
        &ENDIF


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE busca-lote wWindow 
PROCEDURE busca-lote :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF BUFFER b-emitente FOR emitente.
    DEF BUFFER b-item-fornec FOR item-fornec.

    ASSIGN i-lote-multiplo-s = 0
           c-mensagem-mail-s = "".
           
    if v_cod_estab_usuar ne "102" then do:           

        FIND item-fornec                                        WHERE
             item-fornec.it-codigo = ttficha-cq.it-codigo       AND
             item-fornec.cod-emitente = ttficha-cq.cod-emitente NO-LOCK NO-ERROR.
        IF NOT AVAIL item-fornec THEN DO:
           FIND emitente WHERE
                emitente.cod-emitente = ttficha-cq.cod-emitente NO-LOCK.
           FOR EACH b-emitente NO-LOCK WHERE
                    b-emitente.nome-matriz = emitente.nome-matriz:
               FIND b-item-fornec                                        WHERE
                    b-item-fornec.it-codigo = ttficha-cq.it-codigo       AND
                    b-item-fornec.cod-emitente = b-emitente.cod-emitente NO-LOCK NO-ERROR.
               IF AVAIL b-item-fornec THEN DO:
                  ASSIGN i-lote-multiplo-s = b-item-fornec.lote-mul-for.
                  ASSIGN c-mensagem-mail-s = "Foi assumido o contenedor do fornecedor: " +  
                                              STRING(b-emitente.cod-emitente) + " - " +
                                              b-emitente.nome-abrev .
                  RUN ShowMessage (2, c-mensagem-mail-s, "").
               END.
           END.
    
           IF i-lote-multiplo-s = 0 THEN DO:
              ASSIGN i-lote-multiplo-s = item.lote-multipl.
              ASSIGN c-mensagem-mail-s =  "Foi assumido o contenedor do item. ".
              RUN ShowMessage (2, c-mensagem-mail-s, "").
           END.        
        END.
        ELSE 
           ASSIGN i-lote-multiplo-s = item-fornec.lote-mul-for.
    end.
    else do:
        /* Esta regra v†lida somente para Nova Inform†tica
           foi implementada a pedido do Sr. Carlos do Recebimento Nova
           Giovane Oliveira - Sys Developer - 15/01/08
        */   
        find item no-lock
            where item.it-codigo = ttficha-cq.it-codigo no-error.
         ASSIGN i-lote-multiplo-s = item.lote-mult.
    end.    
                       

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaRejFicha wWindow 
PROCEDURE criaRejFicha :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE ttrej-ficha.
    CREATE ttrej-ficha.
           ASSIGN ttrej-ficha.nr-ficha     = ttficha-cq.nr-ficha
                  ttrej-ficha.codigo-rejei = i-cod-rej-s
                  ttrej-ficha.qt-apr-cond  = i-quantidade-s
                  ttrej-ficha.dec-1        = i-quantidade-s.

    RUN emptyRowErrors IN {&hDBOTable3} NO-ERROR.        
    RUN setConstraintMain IN {&hDBOTable3} ("Main") NO-ERROR.
    RUN openQueryStatic IN {&hDBOTable3} (INPUT "Main":U) NO-ERROR.
    RUN setrecord IN {&hDBOTable3} (INPUT TABLE ttrej-ficha).  
    RUN createRecord IN {&hDBOTable3}.                        
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.errortype = "error") THEN DO:
        {method/ShowMessage.i1}.
        {method/ShowMessage.i2 &Modal="YES"}.
        {method/ShowMessage.i3}.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprime-hml wWindow 
PROCEDURE imprime-hml :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN esp/cqp/escqp004b.w (INPUT ttficha-cq.r-rowid, INPUT fiPrinter:SCREEN-VALUE IN FRAME fpage2, OUTPUT c-cod-fabric).
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprime-rej wWindow 
PROCEDURE imprime-rej :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN ShowMessage (3, "Deseja imprimir roteiro rejeitado?", "").
    IF RETURN-VALUE = "yes" THEN do:
        gs-nr-ficha = ttficha-cq.nr-ficha.
        RUN esp/cqp/escqp005.w.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wWindow 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "inbo/boin124a.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin124a.p YES}
        {btb/btb008za.i2 inbo/boin124a.p '' {&hDBOTable}}
    END.
    
    RUN setConstraintMain IN {&hDBOTable} ("Main") NO-ERROR.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    
    IF NOT VALID-HANDLE({&hDBOTable2}) OR
       {&hDBOTable2}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable2}:FILE-NAME <> "inbo/boin178.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin178.p YES}
        {btb/btb008za.i2 inbo/boin178.p '' {&hDBOTable2}}
    END.
    
    RUN setConstraintMain IN {&hDBOTable2} ("Main") NO-ERROR.
    RUN openQueryStatic IN {&hDBOTable2} (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE({&hDBOTable3}) OR
       {&hDBOTable3}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable3}:FILE-NAME <> "esbo/esboin378.p":U THEN DO:
        {btb/btb008za.i1 esbo/esboin378.p YES}
        {btb/btb008za.i2 esbo/esboin378.p '' {&hDBOTable3}}
    END.
    
    RUN setConstraintMain IN {&hDBOTable3} ("Main") NO-ERROR.
    RUN openQueryStatic IN {&hDBOTable3} (INPUT "Main":U) NO-ERROR.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-item-fornec wWindow 
PROCEDURE pi-atualiza-item-fornec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var i-insp        as integer no-undo.
    def var i-var-aux     as integer no-undo.
    def var i-var-aux-tot as integer no-undo.

    /*if (ttficha-cq.qt-original - ttficha-cq.qt-aprovada - ttficha-cq.qt-consumida -
        ttficha-cq.qt-rejeitada - ttficha-cq.qt-apr-cond = 0) and
        param-cq.tipo-cq = 3 then do:*/

        if ttficha-cq.qt-rejeitada > 0 then
            assign i-insp = 2.
        else if ttficha-cq.qt-apr-cond > 0 then
            assign i-insp = 3.
        else
            assign i-insp = 1.

       do i-var-aux = 2 to 30:
           assign ttitem-fornec.aval-insp[i-var-aux - 1] =
                              ttitem-fornec.aval-insp[i-var-aux].
       end.
       assign ttitem-fornec.aval-insp[30] = i-insp.
       if ttitem-fornec.tp-inspecao < 4 then do:
           i-var-aux-tot = 0.
           if  ttitem-fornec.tp-inspecao = 1 
           and param-cq.com-sn-lote <> 0 then do:
               if ttitem-fornec.aval-insp[31 - param-cq.com-sn-lote] <> 5 then do:
                   do i-var-aux = 31 - param-cq.com-sn-lote to 30:
                       if ttitem-fornec.aval-insp[i-var-aux] = 2 or
                          ttitem-fornec.aval-insp[i-var-aux] = 3 then
                           assign i-var-aux-tot = i-var-aux-tot + 1.
                   end.
                   if i-var-aux-tot <= param-cq.com-sn-reje then
                       assign ttitem-fornec.tp-inspecao = 2.
               end.
           end.
           else if  ttitem-fornec.tp-inspecao = 2 
                and param-cq.com-ns-lote   <> 0
                and param-cq.com-na-lote   <> 0 then do:
                    if ttitem-fornec.aval-insp[31 - param-cq.com-ns-lote] <> 5 then do:
                        do i-var-aux = 31 - param-cq.com-ns-lote to 30:
                            if ttitem-fornec.aval-insp[i-var-aux] = 2 or
                               ttitem-fornec.aval-insp[i-var-aux] = 3 then
                                assign i-var-aux-tot = i-var-aux-tot + 1.
                        end.
                        if i-var-aux-tot >= param-cq.com-ns-reje then
                            assign ttitem-fornec.tp-inspecao = 1.
                    end.
                    assign i-var-aux-tot = 0.
                    if ttitem-fornec.aval-insp[31 - param-cq.com-na-lote] <> 5 then do:
                        do i-var-aux = 31 - param-cq.com-na-lote to 30:
                            if ttitem-fornec.aval-insp[i-var-aux] = 2 or
                               ttitem-fornec.aval-insp[i-var-aux] = 3 then
                                assign i-var-aux-tot = i-var-aux-tot + 1.
                        end.
                        if i-var-aux-tot <= param-cq.com-na-reje then
                           assign ttitem-fornec.tp-inspecao = 3.
                    end.
                end.
           else if  param-cq.com-an-lote <> 0 then do:
                    if ttitem-fornec.aval-insp[31 - param-cq.com-an-lote] <> 5 then do:
                        do i-var-aux = 31 - param-cq.com-an-lote to 30:
                            if ttitem-fornec.aval-insp[i-var-aux] = 2 or
                               ttitem-fornec.aval-insp[i-var-aux] = 3 then
                                assign i-var-aux-tot = i-var-aux-tot + 1.
                        end.
                        if i-var-aux-tot >= param-cq.com-an-reje then
                            assign ttitem-fornec.tp-inspecao = 2.
                    end.
                end.               
       end.
    /*end.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-parametro wWindow 
PROCEDURE pi-parametro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUTTON btCancela 
         LABEL "&Cancelar" 
         SIZE 10 BY 1.
    
    DEFINE BUTTON btOK 
         LABEL "OK" 
         SIZE 10 BY 1.
    
    
    DEFINE RECTANGLE RECT-16
         EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
         SIZE 20 BY 4.
    
    DEFINE RECTANGLE RECT-17
         EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
         SIZE 60 BY 6.5.
    
    DEFINE RECTANGLE RECT-18
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 60 BY 1.5
         BGCOLOR 7 .
    
    
    /* ************************  Frame Definitions  *********************** */
    
    DEFINE FRAME fDeposito
         rs-deposito AT ROW 2.5 COL 24 NO-LABEL
         btCancela AT ROW 7.79 COL 12
         btOK AT ROW 7.8 COL 2
         RECT-16 AT ROW 2 COL 20
         RECT-17 AT ROW 1 COL 1
         RECT-18 AT ROW 7.5 COL 1
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
             SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
             TITLE "Dep¢sito de Sa°da"
             DEFAULT-BUTTON btOK CANCEL-BUTTON btCancela FONT 1.

    ON 'choose':U OF btOK IN FRAME fDeposito
    DO:
        ASSIGN INPUT FRAME fDeposito rs-deposito.
        APPLY "END-ERROR":U TO FRAME fDeposito.
        RETURN.
    END.

    ON 'choose':U OF btCancela IN FRAME fDeposito
    DO:
        APPLY "END-ERROR":U TO FRAME fDeposito.
        RETURN.
    END.

    DISP rs-deposito WITH FRAME fDeposito.
    ENABLE rs-deposito btOK btCancela WITH FRAME fDeposito.
    VIEW FRAME fDeposito.
    WAIT-FOR WINDOW-CLOSE OF FRAME fDeposito.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEnviaEmail wWindow 
PROCEDURE piEnviaEmail :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEF VAR icont AS INT. 


    IF AVAIL ttficha-cq AND 
       c-depos-ent = "hml" then DO:

        FOR EACH tt-envio2:
            DELETE tt-envio2.
        END.

        FOR EACH tt-mensagem:
            DELETE tt-mensagem.
        END.

        FOR EACH tt-erros:
            DELETE tt-erros.
        END.

        FOR FIRST param-global NO-LOCK:
        END.

        FOR FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = ttficha-cq.it-codigo:
        END.

        RUN utp/utapi019.p PERSISTENT SET h-utapi019.
        
        CREATE tt-envio2.
        ASSIGN tt-envio2.versao-integracao = 1
               tt-envio2.servidor          = param-global.serv-mail         /* Servidor de E-Mail */ 
               tt-envio2.porta             = param-global.porta-mail        /* Porta do Servidor  */ 
               tt-envio2.destino           = "grupo.eqf@intelbras.com.br"   /* Destinatˇrio       */ 
               tt-envio2.remetente         = "sem@intelbras.com.br"         /* Remetente          */ 
               tt-envio2.assunto           = "Transferància HML"            /* Assunto            */
               tt-envio2.arq-anexo         = ""                             /* Arquivo Temporˇrio */
               tt-envio2.formato           = "TEXTO".

        CREATE tt-mensagem.
        ASSIGN tt-mensagem.seq-mensagem = 1
               tt-mensagem.mensagem     = "Foi movimentando a quantidade de " + STRING(i-quantidade-s, ">>>,>>>,>>9.9999") + " " + ITEM.un + " do item " + item.it-codigo + " para o dep¢sito HML." + CHR(10) + CHR(10).
                
        RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                       INPUT  TABLE tt-mensagem,
                                       OUTPUT TABLE tt-erros).

        FIND FIRST tt-erros NO-LOCK NO-ERROR.
        IF AVAIL tt-erros THEN DO:

            OUTPUT TO erros-comerc.LOG APPEND.

            FOR EACH tt-erros:
                DISP tt-erros.cod-erro
                     tt-erros.desc-erro + tt-erros.desc-arq FORMAT "X(200)" WITH STREAM-IO WIDTH 202.
            END.

            OUTPUT CLOSE.

        END.

        DELETE PROCEDURE h-utapi019.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRecarrega wWindow 
PROCEDURE piRecarrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  EMPTY TEMP-TABLE ttficha-cq.
  FOR EACH ficha-cq NO-LOCK WHERE
           ficha-cq.cod-estabel  = v_cod_estab_usuar and
           ficha-cq.cod-emitente = fi-cod-emitente AND
           ficha-cq.serie-docto  = fi-serie-docto  AND
           ficha-cq.nro-docto    = fi-nro-docto    AND
           ficha-cq.situacao     = 1:
      CREATE ttficha-cq.
      BUFFER-COPY ficha-cq TO ttficha-cq.
      ttficha-cq.r-rowid = ROWID(ficha-cq).
  END.
  {&OPEN-QUERY-brItem}

  IF BROWSE brItem:NUM-ITERATIONS > 0 THEN
     ENABLE ALL WITH FRAME fpage3.
  ELSE DO:
      DISABLE ALL WITH FRAME fpage3.
  END.

  ENABLE ALL WITH FRAME fpage1.
  ENABLE btCancela btConfirma WITH FRAME fpage0.
  RUN setFolder IN hFolder (input 1).
  APPLY "entry" TO fi-cod-emitente IN FRAME fpage1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSelectPrinter wWindow 
PROCEDURE piSelectPrinter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cTempFile AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cAuxFile  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cPrev     AS CHARACTER   NO-UNDO.

    ASSIGN INPUT FRAME fPage2 fiPrinter.

    ASSIGN cPrev     = fiPrinter
           cTempFile = REPLACE(fiPrinter, ":":U, ",":U).

    IF fiPrinter <> "":U THEN DO:
        IF NUM-ENTRIES(cTempFile) = 4 THEN
            ASSIGN cPrinter = ENTRY(1, cTempFile)
                   cLayout  = ENTRY(2, cTempFile)
                   cAuxFile = ENTRY(3, cTempFile) + ":":U + ENTRY(4, cTempFile).

        IF NUM-ENTRIES(cTempFile) = 3 THEN
            ASSIGN cPrinter = ENTRY(1, cTempFile)
                   cLayout  = ENTRY(2, cTempFile)
                   cAuxFile = ENTRY(3, cTempFile).

        IF NUM-ENTRIES(cTempFile) = 2 THEN
            ASSIGN cPrinter = ENTRY(1, cTempFile)
                   cLayout  = ENTRY(2, cTempFile)
                   cAuxFile = "":U.
    END.

    RUN utp/ut-impr.w (INPUT-OUTPUT cPrinter,
                       INPUT-OUTPUT cLayout,
                       INPUT-OUTPUT cAuxFile).

    IF cAuxFile = "":U THEN
        ASSIGN fiPrinter = cPrinter + ":":U + cLayout.
    ELSE
        ASSIGN fiPrinter = cPrinter + ":":U + cLayout + ":":U + cAuxFile.

    IF fiPrinter = ":":U THEN
        ASSIGN fiPrinter = cPrev.

    DISPLAY fiPrinter
        WITH FRAME fPage2.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piTransfere wWindow 
PROCEDURE piTransfere :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-quantidade AS DECIMAL NO-UNDO.
    DEF INPUT PARAM p-num-docto AS INTEGER NO-UNDO.
    DEF INPUT PARAM p-serie AS CHAR NO-UNDO.
    DEF INPUT PARAM p-nr-ae AS INTEGER NO-UNDO.
    DEF INPUT PARAM p-sequencia AS INTEGER NO-UNDO.
    DEF INPUT PARAM p-nr-ficha AS INTEGER NO-UNDO.
    DEF INPUT PARAM p-nota AS INT NO-UNDO.
    DEF INPUT PARAM p-contenedor AS DECIMAL NO-UNDO.
    DEF INPUT PARAM p-cod-emitente AS INTEGER NO-UNDO.
    DEF INPUT PARAM p-marca AS CHAR NO-UNDO.    
    DEF INPUT PARAM p-usa-local AS LOGICAL NO-UNDO.
    DEF INPUT PARAM p-local-dest AS CHAR NO-UNDO.    
    
    DEF VAR c-dispositivo AS CHAR NO-UNDO.

    IF  INPUT FRAME fPage2 fiPrinter = "" THEN DO:
        MESSAGE "Impressora destino deve ser informada." VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        ASSIGN l-deu-erro = TRUE.
        LEAVE.
    END.

    DO WITH FRAME fpage1:
        STATUS DEFAULT "Processando a transferància. Por favor aguarde".
        SESSION:SET-WAIT-STATE("GENERAL":U).
        
        ASSIGN c-dispositivo = INPUT FRAME fPage2 fiPrinter.

        l-deu-erro = NO.

        
        RUN esp/es0018p.p (INPUT "{&Program}", /* Nome do programa */
                       INPUT 1,            /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto).
                       
        find first tt-prog-ponto
            where tt-prog-ponto.nome-programa = "{&Program}"
            and   tt-prog-ponto.ponto         = 1 
            and   entry(1, tt-prog-ponto.conteudo) = input frame fpage1 fi-nat-operacao no-error.
        if avail tt-prog-ponto then 
            assign c-depos-ent = entry(2,tt-prog-ponto.conteudo).
        
        run esp/es0478-n.p (
              input item.it-codigo,                 /* item */
              input rs-deposito,                    /* deposito de saida */                
              input c-loc-x,                        /* local de saida */
              input p-quantidade,                   /* quantidade total */
              input c-depos-ent,                    /* deposito de entrada */
              input p-num-docto,                    /* numero docto */
              input p-serie,                        /* serie */
              input c-narrativa-s,                  /* historico */
              input p-nr-ae,                        /* numero do AE */
              input p-sequencia,                    /* sequencia do AE */
              input p-nr-ficha,                     /* roteiro */  
              input p-nota,                         /* nota */
              input no,                             /* baixa parcial */
              input no,                             /* devolucao ou transferencia */
              input p-contenedor,                   /* contenedor */
              input p-cod-emitente,                 /* fornecedor */
              input i-seq-ini,                      /* sequencia inicial */
              input p-usa-local,                    /* usa local informado */
              input p-local-dest,                   /* local destino */
              input today,                          /* data movto-estoq */
              input dt-validade-s,                  /* Validade da AE */
              input "escqp004," + c-dispositivo,    /* Campo Caracter livre */
              input v_cod_estab_usuar,              /* C¢digo do estabelecimento */
              output table tt-etiqueta,
              OUTPUT p-msg-erro).   
              
        SESSION:SET-WAIT-STATE("":U).
        STATUS DEFAULT.

    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prepara wWindow 
PROCEDURE prepara :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    BROWSE brItem:FETCH-SELECTED-ROW(1).

    ASSIGN i-quantidade-s = ttficha-cq.qt-original
           l-troca-s      = NO.

    FOR FIRST tt-troca WHERE
              tt-troca.rec-ficha = ttficha-cq.r-rowid:
        l-troca-s = tt-troca.troca.
    END.

    FIND FIRST ae-inspecao                                          WHERE
               ae-inspecao.cod-estabel  = v_cod_estab_usuar         AND
               ae-inspecao.cod-emitente = ttficha-cq.cod-emitente   AND
               ae-inspecao.serie        = ttficha-cq.serie-docto    AND
               ae-inspecao.nro-docto    = int(ttficha-cq.nro-docto) AND
               ae-inspecao.it-codigo    = ttficha-cq.it-codigo      AND
               ae-inspecao.nr-ficha     = ttficha-cq.nr-ficha       NO-LOCK NO-ERROR.        
    IF NOT AVAIL ae-inspecao THEN DO:                    
       RUN ShowMessage (1, "Erro na geraá∆o do AE Inspeá∆o", "").
       RETURN "NOK".
    END.

    ASSIGN i-nr-ae = ae-inspecao.nr-ae.

    FIND LAST ae-item USE-INDEX it-ae-seq              WHERE
              ae-item.cod-estabel = v_cod_estab_usuar and
              ae-item.it-codigo = ttficha-cq.it-codigo AND
              ae-item.nr-ae     = i-nr-ae              NO-LOCK NO-ERROR.
    IF AVAIL ae-item AND ae-item.sequencia >= 999 THEN DO:
        RUN ShowMessage (1, "Ultima sequencia igual a 999. Entre em contato com a Informatica", "").
    END.

    FOR EACH ae-inspecao                                          WHERE
             ae-inspecao.cod-estabel  = v_cod_estab_usuar         AND
             ae-inspecao.cod-emitente = ttficha-cq.cod-emitente   AND
             ae-inspecao.serie        = ttficha-cq.serie-docto    AND
             ae-inspecao.nro-docto    = int(ttficha-cq.nro-docto) AND
             ae-inspecao.it-codigo    = ttficha-cq.it-codigo      AND
             ae-inspecao.nr-ficha     = ttficha-cq.nr-ficha       NO-LOCK:
        ASSIGN i-nr-ae = ae-inspecao.nr-ae.

        FIND LAST ae-item USE-INDEX it-ae-seq              WHERE
                  ae-item.cod-estabel = v_cod_estab_usuar and
                  ae-item.it-codigo = ttficha-cq.it-codigo AND
                  ae-item.nr-ae     = i-nr-ae              NO-LOCK NO-ERROR.
        IF AVAIL ae-item AND ae-item.sequencia >= 999 THEN DO:
            NEXT.
        END.
        IF AVAIL ae-item THEN
           ASSIGN i-seq-ini = ae-item.sequencia + 1.
        ELSE
           ASSIGN i-seq-ini = 1.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trata-skip-lote wWindow 
PROCEDURE trata-skip-lote :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR i-cont AS INT NO-UNDO.
    DEF VAR i-qt-rejeitada AS INT NO-UNDO.
    DEF VAR i-qt-lotes AS INT NO-UNDO.

    find int-ficha-cq of ttficha-cq no-lock no-error.
    if avail int-ficha-cq 
         and int-ficha-cq.l-inspeciona
         and not l-cond
         and not l-rejei then assign i-tipo = 4.
    
    /*     Trata Skip-Lote     */   
    
    find first param-cq no-lock no-error.

    RUN setConstraintCodEmitente IN {&hDBOTable2} (INPUT ttficha-cq.cod-emitente,
                                                   INPUT ROWID(ITEM)).
    RUN openQueryStatic IN {&hDBOTable2} (INPUT "CodEmitente":U) NO-ERROR.
    RUN getRecord IN {&hDBOTable2} (OUTPUT TABLE ttitem-fornec).
    FIND FIRST ttitem-fornec NO-ERROR.

    if avail ttitem-fornec then do:
        /* puxa os resultados das inspecoes anteriores e 
           grava o resultado da inspecao corrente no ultimo registro */
           

        /*do i-cont = 1 to 29:
           assign  ttitem-fornec.aval-insp[i-cont] =  ttitem-fornec.aval-insp[i-cont + 1].
        end.            
        assign ttitem-fornec.aval-insp[30] = i-tipo.*/
    
        /*case ttitem-fornec.tp-inspecao:
    
            when 1 then do:
        
                /* Severa-Normal */
                
                assign i-qt-rejeitada = 0
                       i-qt-lotes = 0.
                
                do i-cont = 0 to param-cq.com-sn-lote - 1:
                   if ttitem-fornec.aval-insp[30 - i-cont] = 1 or
                      ttitem-fornec.aval-insp[30 - i-cont] = 2 then
                      assign i-qt-rejeitada = i-qt-rejeitada + 1.
                   if ttitem-fornec.aval-insp[30 - i-cont] <> ? then
                      assign i-qt-lotes = i-qt-lotes + 1. 
                      /* deve contar o numero de lotes para beneficiar
                         somente se ja houver lotes suficientes */                  
                end.
                if i-qt-rejeitada <= param-cq.com-sn-reje then do:
                    if i-qt-lotes >= param-cq.com-sn-lote then
                        assign ttitem-fornec.tp-inspecao = 2.
                end.
            end.
            when 2 then do:
    
                /*  Normal - Atenuada */
                
                assign i-qt-rejeitada = 0
                       i-qt-lotes = 0.
                
                do i-cont = 0 to param-cq.com-na-lote - 1 :
                   if ttitem-fornec.aval-insp[30 - i-cont] = 1 or
                      ttitem-fornec.aval-insp[30 - i-cont] = 2 then
                      assign i-qt-rejeitada = i-qt-rejeitada + 1.
                      if ttitem-fornec.aval-insp[30 - i-cont] <> ? then
                         assign i-qt-lotes = i-qt-lotes + 1. 
                      /* deve contar o numero de lotes para beneficiar
                         somente se ja houver lotes suficientes */                   
                end.
                if i-qt-rejeitada  <= param-cq.com-na-reje then do:
                    if i-qt-lotes >= param-cq.com-na-lote then
                      assign ttitem-fornec.tp-inspecao = 3.
    
                end.
       
                /* Normal - Severa */
                assign i-qt-rejeitada = 0
                       i-qt-lotes = 0.
                      
                do i-cont = 0 to param-cq.com-ns-lote - 1:
                   if ttitem-fornec.aval-insp[30 - i-cont] = 1 or
                      ttitem-fornec.aval-insp[30 - i-cont] = 2 then
                      assign i-qt-rejeitada = i-qt-rejeitada + 1.
                end.
                if i-qt-rejeitada >= param-cq.com-ns-reje then
                   assign ttitem-fornec.tp-inspecao = 1.        
            end.
        
            when 3 then do:
    
                /* Atenuada - Normal */
                assign i-qt-rejeitada = 0.
            
                do i-cont = 0 to param-cq.com-an-lote - 1:
                   if ttitem-fornec.aval-insp[30 - i-cont] = 1 or
                      ttitem-fornec.aval-insp[30 - i-cont] = 2 then
                      assign i-qt-rejeitada = i-qt-rejeitada + 1.
                end.
                if i-qt-rejeitada >= param-cq.com-an-reje then
                    assign ttitem-fornec.tp-inspecao = 2.
    
                /* Atenuada - Assegurada */
                assign i-qt-rejeitada = 0.
            
                do i-cont = 0 to 10:
                   if ttitem-fornec.aval-insp[30 - i-cont] = 1 or 
                      ttitem-fornec.aval-insp[30 - i-cont] = 2 then
                      assign i-qt-rejeitada = i-qt-rejeitada + 1.
                      if ttitem-fornec.aval-insp[30 - i-cont] <> ? then
                         assign i-qt-lotes = i-qt-lotes + 1. 
                      /* deve contar o numero de lotes para beneficiar
                         somente se ja houver lotes suficientes */
    
                end.
                if i-qt-rejeitada = 0 then do:
                    if i-qt-lotes >= 10 then 
                       assign ttitem-fornec.tp-inspecao = 4.
                end.   
            end.
            when 4 then do:
                /* assegurada para normal */
                
                if ttitem-fornec.aval-insp[30] = 1 or 
                   ttitem-fornec.aval-insp[30] = 2 then 
                   assign ttitem-fornec.tp-inspecao = 2.        
            end.        
        end case.*/

        RUN pi-atualiza-item-fornec.


        RUN emptyRowErrors IN {&hDBOTable2} NO-ERROR.        
        RUN setrecord IN {&hDBOTable2} (INPUT TABLE ttitem-fornec).  
        RUN updaterecord IN {&hDBOTable2}.                        
        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.errortype = "error") THEN DO:
            {method/ShowMessage.i1}.
            {method/ShowMessage.i2 &Modal="YES"}.
            {method/ShowMessage.i3}.
        END.
    end.
    else do:
        RUN ShowMessage (2, "Relaá∆o Item-Fornecedor n∆o encontrada", "SKIP LOTE n∆o foi executado").
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-situacao-ficha wWindow 
FUNCTION fn-situacao-ficha RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    RETURN 
        IF (ttficha-cq.qt-aprovada + ttficha-cq.qt-apr-cond + ttficha-cq.qt-rejeitada) =
        ttficha-cq.qt-original THEN 4 ELSE 1.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-valida-operacao wWindow 
FUNCTION fn-valida-operacao RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    RETURN BROWSE brItem:NUM-ITERATIONS > 0 AND BROWSE brItem:NUM-SELECTED-ROWS > 0.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

