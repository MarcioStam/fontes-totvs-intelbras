&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
          mgmov            PROGRESS
*/
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
{include/i-prgvrs.i re1001-upcv 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        re1001-upcv
&GLOBAL-DEFINE Version        2.04.00.001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Dep¢sitos, Devoluá∆o, Sol. NF Terc, Transf Imob.

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btHelp ~
                              btOK btHelp2 
&GLOBAL-DEFINE page1Widgets   bt-Altera bt-altera-2 bt-altera-origem
&GLOBAL-DEFINE page2Widgets   iCod-mensagem cconta-transit c-sc-codigo cnarrativa c-nom-solicitante
&GLOBAL-DEFINE page3Widgets   c-usuar-solic-nf-terc
&GLOBAL-DEFINE page4Widgets   bt-transf

/* Parameters Definitions ---                                           */

DEFINE INPUT PARAMETER p-cod-emitente AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER p-serie        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-documento    AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-natureza     AS CHARACTER NO-UNDO.

/*
DEFINE variable p-cod-emitente AS INTEGER   NO-UNDO.
DEFINE variable p-serie        AS CHARACTER NO-UNDO.
DEFINE variable p-documento    AS CHARACTER NO-UNDO.
DEFINE variable p-natureza     AS CHARACTER NO-UNDO.
*/


/* Local Variable Definitions ---                                       */

DEFINE VARIABLE lValidaMsg       AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-ex-tarifario   AS CHARACTER FORM "x(20)"   NO-UNDO.
DEFINE VARIABLE l-skip-lote      AS LOGICAL     NO-UNDO.
DEFINE VARIABLE lErros           AS LOGICAL     NO-UNDO.
DEFINE VARIABLE wh-pesquisa      AS HANDLE NO-UNDO.
DEFINE VARIABLE v-num-entr-param AS INTEGER     NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR r-doc-entrada AS RECID NO-UNDO.

DEF TEMP-TABLE tt-msg NO-UNDO
    FIELD num-msg AS INT.

DEF TEMP-TABLE tt-conta-transit NO-UNDO
    FIELD conta-transit LIKE docum-est.conta-transit
    FIELD ct-transit    LIKE docum-est.ct-transit
    FIELD sc-transit    LIKE docum-est.sc-transit.

{upc/btb910za-upc.i} /* Definiá∆o da vari†vel New Global Shared "v_cod_estab_usuar" */
{esp/es0018.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brDepositos

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES rat-lote item item-doc-est

/* Definitions for BROWSE brDepositos                                   */
&Scoped-define FIELDS-IN-QUERY-brDepositos rat-lote.sequencia ~
rat-lote.it-codigo item.codigo-orig ~
fnExTarifario(rat-lote.it-codigo) @ c-ex-tarifario rat-lote.cod-depos ~
FnSkipLote(rat-lote.it-codigo) @ l-skip-lote rat-lote.cod-localiz ~
item-doc-est.class-fiscal 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDepositos 
&Scoped-define QUERY-STRING-brDepositos FOR EACH rat-lote ~
      WHERE rat-lote.cod-emitente = p-cod-emitente ~
 AND rat-lote.serie-docto = p-serie ~
 AND rat-lote.nro-docto = p-documento ~
 AND rat-lote.nat-operacao = p-natureza ~
 AND rat-lote.sequencia >= 10 NO-LOCK, ~
      FIRST item WHERE item.it-codigo = rat-lote.it-codigo OUTER-JOIN NO-LOCK, ~
      FIRST item-doc-est OF rat-lote NO-LOCK ~
    BY rat-lote.sequencia INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brDepositos OPEN QUERY brDepositos FOR EACH rat-lote ~
      WHERE rat-lote.cod-emitente = p-cod-emitente ~
 AND rat-lote.serie-docto = p-serie ~
 AND rat-lote.nro-docto = p-documento ~
 AND rat-lote.nat-operacao = p-natureza ~
 AND rat-lote.sequencia >= 10 NO-LOCK, ~
      FIRST item WHERE item.it-codigo = rat-lote.it-codigo OUTER-JOIN NO-LOCK, ~
      FIRST item-doc-est OF rat-lote NO-LOCK ~
    BY rat-lote.sequencia INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brDepositos rat-lote item item-doc-est
&Scoped-define FIRST-TABLE-IN-QUERY-brDepositos rat-lote
&Scoped-define SECOND-TABLE-IN-QUERY-brDepositos item
&Scoped-define THIRD-TABLE-IN-QUERY-brDepositos item-doc-est


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brDepositos}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar btQueryJoins ~
btReportsJoins btHelp btOK btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnExTarifario wWindow 
FUNCTION fnExTarifario RETURNS CHARACTER
  ( p-it-codigo AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnSkipLote wWindow 
FUNCTION fnSkipLote RETURNS LOGICAL
  ( p-it-codigo AS CHAR )  FORWARD.

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
DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

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

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 89 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 89 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON bt-altera 
     LABEL "Alterar Todos" 
     SIZE 13 BY 1.

DEFINE BUTTON bt-altera-2 
     LABEL "Alterar Item" 
     SIZE 13 BY 1.

DEFINE BUTTON bt-altera-origem 
     LABEL "Alterar Origem" 
     SIZE 13 BY 1.

DEFINE VARIABLE cnarrativa AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 68.57 BY 2.75 NO-UNDO.

DEFINE VARIABLE cTexto-mensag AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 68.57 BY 2.5 NO-UNDO.

DEFINE VARIABLE c-desc-conta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-sub-conta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .88 NO-UNDO.

DEFINE VARIABLE c-nom-solicitante AS CHARACTER FORMAT "X(50)":U 
     LABEL "Solicitante" 
     VIEW-AS FILL-IN 
     SIZE 40.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-sc-codigo AS CHARACTER FORMAT "x(8)" 
     LABEL "Sub-Conta":R16 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE cconta-transit AS CHARACTER FORMAT "x(8)" 
     LABEL "Conta":R16 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE cDescricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31.43 BY .88 NO-UNDO.

DEFINE VARIABLE iCod-mensagem AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Mensagem devoluá∆o" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 5.38.

DEFINE RECTANGLE rtKeys-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 3.54.

DEFINE RECTANGLE rtKeys-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 2.42.

DEFINE VARIABLE c-ccusto-nf-terc AS CHARACTER FORMAT "X(11)":U 
     LABEL "Centro de Custos NF Terc." 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-ccusto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-usuar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE c-usuar-solic-nf-terc AS CHARACTER FORMAT "X(16)":U 
     LABEL "Solicitante NF Terc" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE BUTTON bt-transf 
     LABEL "Transf Imob":U 
     SIZE 13 BY 1 TOOLTIP "SolicitaÁ„oo de TransferÍncia de Imobilizado":U.

DEFINE RECTANGLE rtTransf
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 5.38.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brDepositos FOR 
      rat-lote, 
      item, 
      item-doc-est SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brDepositos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDepositos wWindow _STRUCTURED
  QUERY brDepositos NO-LOCK DISPLAY
      rat-lote.sequencia FORMAT ">>>>9":U WIDTH 8
      rat-lote.it-codigo FORMAT "x(16)":U WIDTH 19.57
      item.codigo-orig FORMAT ">9":U WIDTH 5
      fnExTarifario(rat-lote.it-codigo) @ c-ex-tarifario COLUMN-LABEL "Ex Tarif" FORMAT "x(20)":U
            WIDTH 12
      rat-lote.cod-depos FORMAT "x(3)":U WIDTH 5.43
      FnSkipLote(rat-lote.it-codigo) @ l-skip-lote COLUMN-LABEL "Seq Skip Lote" FORMAT "Sim/N∆o":U
            WIDTH 13
      rat-lote.cod-localiz FORMAT "x(20)":U WIDTH 19.72
      item-doc-est.class-fiscal FORMAT "9999.99.99":U WIDTH 15.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 85.43 BY 7.63
         FONT 1
         TITLE "Dep¢sitos" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 73.29 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 77.29 HELP
          "Relat¢rios relacionados"
     btHelp AT ROW 1.13 COL 85.29 HELP
          "Ajuda"
     btOK AT ROW 16.79 COL 2.29
     btHelp2 AT ROW 16.83 COL 76.43
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 16.58 COL 1.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 89.86 BY 17.13
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     brDepositos AT ROW 1.38 COL 2.29 WIDGET-ID 500
     bt-altera AT ROW 8.96 COL 2.14 WIDGET-ID 2
     bt-altera-2 AT ROW 8.96 COL 16.43 WIDGET-ID 4
     bt-altera-origem AT ROW 8.96 COL 30.86 WIDGET-ID 6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 3.75
         SIZE 88 BY 12.75 WIDGET-ID 400.

DEFINE FRAME fPage4
     bt-transf AT ROW 3.25 COL 22 WIDGET-ID 2
     rtTransf AT ROW 1.25 COL 6 WIDGET-ID 4
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 3.75
         SIZE 88 BY 12.75
         FONT 1 WIDGET-ID 700.

DEFINE FRAME fPage3
     c-usuar-solic-nf-terc AT ROW 2.75 COL 20 COLON-ALIGNED WIDGET-ID 2
     c-nome-usuar AT ROW 2.75 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     c-ccusto-nf-terc AT ROW 3.75 COL 20 COLON-ALIGNED WIDGET-ID 4
     c-desc-ccusto AT ROW 3.75 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 8
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 3.75
         SIZE 88 BY 12.75
         FONT 1 WIDGET-ID 600.

DEFINE FRAME fPage2
     iCod-mensagem AT ROW 1.5 COL 24 COLON-ALIGNED WIDGET-ID 32
     cDescricao AT ROW 1.5 COL 32.86 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     c-nom-solicitante AT ROW 2.5 COL 24 COLON-ALIGNED WIDGET-ID 42
     cTexto-mensag AT ROW 3.75 COL 10.43 NO-LABEL WIDGET-ID 30
     cconta-transit AT ROW 6.92 COL 17.86 COLON-ALIGNED HELP
          "Conta Transitoria" WIDGET-ID 24
     c-desc-conta AT ROW 6.92 COL 28.43 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     c-sc-codigo AT ROW 7.92 COL 17.86 COLON-ALIGNED HELP
          "Conta Transitoria" WIDGET-ID 4
     c-desc-sub-conta AT ROW 7.92 COL 28.43 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     cnarrativa AT ROW 9.83 COL 10.43 NO-LABEL WIDGET-ID 28
     "Observaá∆o:" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 9.13 COL 7 WIDGET-ID 40
     rtKeys-2 AT ROW 1.25 COL 6 WIDGET-ID 34
     rtKeys-3 AT ROW 9.42 COL 6 WIDGET-ID 36
     rtKeys-4 AT ROW 6.67 COL 6 WIDGET-ID 38
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 3.75
         SIZE 88 BY 12.75
         FONT 1 WIDGET-ID 200.


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
         HEIGHT             = 17.17
         WIDTH              = 89.86
         MAX-HEIGHT         = 28.83
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28.83
         VIRTUAL-WIDTH      = 195.14
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

ASSIGN brDepositos:SENSITIVE IN FRAME fPage1 = YES.

{&OPEN-QUERY-brDepositos}

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brDepositos 1 fPage1 */
ASSIGN 
       brDepositos:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE.

/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN c-desc-conta IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-sub-conta IN FRAME fPage2
   NO-ENABLE                                                            */
ASSIGN 
       cTexto-mensag:READ-ONLY IN FRAME fPage2        = TRUE.

/* SETTINGS FOR FRAME fPage3
                                                                        */
/* SETTINGS FOR FILL-IN c-ccusto-nf-terc IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-ccusto IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-usuar IN FRAME fPage3
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage4
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDepositos
/* Query rebuild information for BROWSE brDepositos
     _TblList          = "mgmov.rat-lote,mgcad.item WHERE mgmov.rat-lote ...,mgmov.item-doc-est OF mgmov.rat-lote"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST OUTER, FIRST"
     _OrdList          = "mgmov.rat-lote.sequencia|yes"
     _Where[1]         = "mgmov.rat-lote.cod-emitente = p-cod-emitente
 AND mgmov.rat-lote.serie-docto = p-serie
 AND mgmov.rat-lote.nro-docto = p-documento
 AND mgmov.rat-lote.nat-operacao = p-natureza
 AND mgmov.rat-lote.sequencia >= 10"
     _JoinCode[2]      = "mgcad.item.it-codigo = mgmov.rat-lote.it-codigo"
     _FldNameList[1]   > mgmov.rat-lote.sequencia
"rat-lote.sequencia" ? ? "integer" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > mgmov.rat-lote.it-codigo
"rat-lote.it-codigo" ? ? "character" ? ? ? ? ? ? no ? no no "19.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > mgcad.item.codigo-orig
"item.codigo-orig" ? ? "integer" ? ? ? ? ? ? no ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"fnExTarifario(rat-lote.it-codigo) @ c-ex-tarifario" "Ex Tarif" "x(20)" ? ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > mgmov.rat-lote.cod-depos
"rat-lote.cod-depos" ? ? "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"FnSkipLote(rat-lote.it-codigo) @ l-skip-lote" "Seq Skip Lote" "Sim/N∆o" ? ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > mgmov.rat-lote.cod-localiz
"rat-lote.cod-localiz" ? ? "character" ? ? ? ? ? ? no ? no no "19.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > mgmov.item-doc-est.class-fiscal
"item-doc-est.class-fiscal" ? ? "character" ? ? ? ? ? ? no ? no no "15.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brDepositos */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage3
/* Query rebuild information for FRAME fPage3
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage4
/* Query rebuild information for FRAME fPage4
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage4 */
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
/*   APPLY "CLOSE":U TO THIS-PROCEDURE. */
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-altera
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-altera wWindow
ON CHOOSE OF bt-altera IN FRAME fPage1 /* Alterar Todos */
DO:
  RUN esp/rep/esrep037.w (INPUT p-cod-emitente,
                          INPUT p-serie,      
                          INPUT p-documento,  
                          INPUT p-natureza).
  
  {&open-query-brDepositos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-altera-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-altera-2 wWindow
ON CHOOSE OF bt-altera-2 IN FRAME fPage1 /* Alterar Item */
DO:
    DEFINE VARIABLE p-item AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE r-rat-lote AS ROWID       NO-UNDO.
    ASSIGN p-item = INPUT BROWSE brDepositos rat-lote.it-codigo
           r-rat-lote = IF AVAIL rat-lote THEN ROWID(rat-lote) ELSE ?.
    
/*     FIND FIRST docum-est NO-LOCK                                                                                                                                                 */
/*          WHERE docum-est.cod-emitente = p-cod-emitente                                                                                                                           */
/*            AND docum-est.serie        = p-serie                                                                                                                                  */
/*            AND docum-est.nro-docto    = p-documento                                                                                                                              */
/*            AND docum-est.nat-operacao = p-natureza      NO-ERROR.                                                                                                                */
/*     IF AVAIL docum-est AND docum-est.esp-docto = 21 /* NFE */ THEN DO:                                                                                                           */
/*         FIND FIRST wm-local-deposito                                                                                                                                             */
/*              WHERE wm-local-deposito.cod-estabel = docum-est.cod-estab                                                                                                           */
/*                AND wm-local-deposito.cod-depos   = 'REC'   NO-LOCK NO-ERROR.                                                                                                     */
/*         IF AVAIL wm-local-deposito THEN DO:                                                                                                                                      */
/*             FIND FIRST int-item-fornec-skip-lote NO-LOCK                                                                                                                         */
/*                  WHERE int-item-fornec-skip-lote.it-codigo    = p-item                                                                                                           */
/*                    AND int-item-fornec-skip-lote.cod-emitente = 0 NO-ERROR.                                                                                                      */
/*             IF AVAIL int-item-fornec-skip-lote THEN DO:                                                                                                                          */
/*                 run utp/ut-msgs.p (input "show",                                                                                                                                 */
/*                                    input 17242,                                                                                                                                  */
/*                                    input "Item n∆o pode ser alterado." + "~~" + "Item n∆o pode ser alterado pois existe registro de sequenciamento de SKIP Lote - (ESCQP015)."). */
/*                                                                                                                                                                                  */
/*                 RETURN NO-APPLY.                                                                                                                                                 */
/*             END.                                                                                                                                                                 */
/*         END.                                                                                                                                                                     */
/*     END.                                                                                                                                                                         */
    
    RUN esp/rep/esrep037a.w (INPUT p-cod-emitente,
                             INPUT p-serie,      
                             INPUT p-documento,  
                             INPUT p-natureza,
                             INPUT p-item).

    {&open-query-brDepositos}

    IF r-rat-lote <> ? THEN
        reposition brDepositos to rowid r-rat-lote.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-altera-origem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-altera-origem wWindow
ON CHOOSE OF bt-altera-origem IN FRAME fPage1 /* Alterar Origem */
DO:
  DEFINE VARIABLE p-item AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE r-rat-lote AS ROWID   NO-UNDO.

  ASSIGN p-item = INPUT BROWSE brDepositos rat-lote.it-codigo
         r-rat-lote = IF AVAIL rat-lote THEN ROWID(rat-lote) ELSE ?.

  
  FIND rat-lote WHERE rowid(rat-lote) = r-rat-lote NO-LOCK NO-ERROR.

  IF AVAIL rat-lote THEN
  DO: 
      FIND item-doc-est OF rat-lote NO-LOCK NO-ERROR.

      IF AVAIL item-doc-est THEN
      DO: 
          IF substring(item-doc-est.nat-of,1,1) <> '3' THEN
          DO:
              RUN utp/ut-msgs.p(INPUT "show",
                                INPUT 17006,
                                INPUT "Alteracao nao permitida~~Alteracao permitida apenas quando a CFOP da operacao iniciar com 3").
          
              RETURN NO-APPLY.
          END.
      END.
  END.


  FIND ITEM WHERE item.it-codigo = p-item NO-LOCK NO-ERROR.

  IF AVAIL ITEM THEN
     IF ITEM.ind-item-fat THEN
     DO:
         RUN utp/ut-msgs.p(INPUT "show",
                           INPUT 17006,
                           INPUT "Alteracao nao permitida~~Item " + ITEM.it-codigo + " esta parametrizado como faturavel," +
                                 " entrar em contato com grupo tributario.").
  
         RETURN NO-APPLY.
     END. 


  
  RUN esp/rep/esrep037c.w (INPUT p-item).


  {&open-query-brDepositos}

  IF r-rat-lote <> ? THEN
     reposition brDepositos to rowid r-rat-lote.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME bt-transf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-transf wWindow
ON CHOOSE OF bt-transf IN FRAME fPage4 /* Transf Imob */
DO:
    IF  AVAIL docum-est THEN
        ASSIGN r-doc-entrada = RECID(docum-est).
    ELSE
        ASSIGN r-doc-entrada = ?.

    RUN esp/fas/esfas016.r .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
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
    APPLY "leave" TO iCod-mensagem  IN FRAME fPage2.

    FIND FIRST docum-est NO-LOCK 
         WHERE docum-est.cod-emitente = p-cod-emitente  
           AND docum-est.serie        = p-serie         
           AND docum-est.nro-docto    = p-documento     
           AND docum-est.nat-operacao = p-natureza      NO-ERROR.

    IF docum-est.esp-docto        = 20  /* NFD */ OR
       CAN-FIND(FIRST item-doc-est OF docum-est
                WHERE item-doc-est.cod-depos = "TNF") THEN
       ASSIGN lValidaMsg = YES.

    IF lValidaMsg = YES THEN DO:
        RUN saveDevolucao.
        IF RETURN-VALUE <> "OK" THEN
           RETURN NO-APPLY.

    END.
        



    RUN SaveSolic.

    IF RETURN-VALUE <> "NOK" THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
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


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME c-ccusto-nf-terc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-nf-terc wWindow
ON LEAVE OF c-ccusto-nf-terc IN FRAME fPage3 /* Centro de Custos NF Terc. */
DO:
     FIND FIRST emscad.ccusto NO-LOCK
          WHERE ccusto.cod_ccusto = INPUT FRAME fPage3 c-ccusto-nf-terc NO-ERROR.

    IF AVAIL ccusto THEN
        ASSIGN c-desc-ccusto:SCREEN-VALUE IN FRAME fPage3 = ccusto.des_tit_ctbl.
    ELSE 
        ASSIGN c-desc-ccusto:SCREEN-VALUE IN FRAME fPage3 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME c-sc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-codigo wWindow
ON F5 OF c-sc-codigo IN FRAME fPage2 /* Sub-Conta */
DO:
     ASSIGN c-sc-codigo:SCREEN-VALUE      = ""
            c-desc-sub-conta:SCREEN-VALUE = "".

     EMPTY TEMP-TABLE tt_log_erro.
     run pi_zoom_ccusto in h_api_ccusto (INPUT  "",
                                         INPUT  "",
                                         INPUT  "",
                                         INPUT  TODAY,
                                         OUTPUT v_cod_ccusto,
                                         OUTPUT v_des_titulo_ccusto,
                                         OUTPUT TABLE tt_log_erro).
     IF  v_cod_ccusto <> "" THEN
         ASSIGN c-sc-codigo:SCREEN-VALUE      = v_cod_ccusto
                c-desc-sub-conta:SCREEN-VALUE = v_des_titulo_ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-codigo wWindow
ON LEAVE OF c-sc-codigo IN FRAME fPage2 /* Sub-Conta */
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME} c-sc-codigo
           c-desc-sub-conta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".  

    EMPTY TEMP-TABLE tt_log_erro.
   ASSIGN lErros  = NO.

    RUN pi_busca_dados_ccusto IN h_api_ccusto (INPUT  i-ep-codigo-usuario, /* EMPRESA EMS2 */
                                               INPUT  "",                  /* CODIGO DO PLANO CCUSTO */
                                               INPUT  c-sc-codigo,         /* CCUSTO */
                                               INPUT  TODAY,               /* DATA DE TRANSACAO */
                                               OUTPUT v_des_titulo_ccusto, /* DESCRICAO DO CCUSTO */
                                               OUTPUT TABLE tt_log_erro).  /* ERROS */
   

    ASSIGN c-desc-sub-conta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_des_titulo_ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-codigo wWindow
ON MOUSE-SELECT-DBLCLICK OF c-sc-codigo IN FRAME fPage2 /* Sub-Conta */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME c-usuar-solic-nf-terc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-usuar-solic-nf-terc wWindow
ON F5 OF c-usuar-solic-nf-terc IN FRAME fPage3 /* Solicitante NF Terc */
DO:
  {include/zoomvar.i &prog-zoom=unzoom/z01un178.w
                      &campo=c-usuar-solic-nf-terc
                      &campozoom=cod_usuario}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-usuar-solic-nf-terc wWindow
ON LEAVE OF c-usuar-solic-nf-terc IN FRAME fPage3 /* Solicitante NF Terc */
DO:
    FIND FIRST usuar_mestre NO-LOCK
         WHERE usuar_mestre.cod_usuar = INPUT FRAME fPage3 c-usuar-solic-nf-terc NO-ERROR.

    IF AVAIL usuar_mestre THEN
        ASSIGN c-nome-usuar:SCREEN-VALUE IN FRAME fPage3 = usuar_mestre.nom_usuario.
    ELSE 
        ASSIGN c-nome-usuar:SCREEN-VALUE IN FRAME fPage3 = "".

    FIND FIRST usuar_univ NO-LOCK
         WHERE usuar_univ.cod_usuario = INPUT FRAME fPage3 c-usuar-solic-nf-terc NO-ERROR.

    IF AVAIL usuar_univ THEN
        ASSIGN c-ccusto-nf-terc:SCREEN-VALUE IN FRAME fPage3 = usuar_univ.cod_ccusto.

    APPLY "leave" TO c-ccusto-nf-terc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-usuar-solic-nf-terc wWindow
ON MOUSE-SELECT-DBLCLICK OF c-usuar-solic-nf-terc IN FRAME fPage3 /* Solicitante NF Terc */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME cconta-transit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cconta-transit wWindow
ON F5 OF cconta-transit IN FRAME fPage2 /* Conta */
DO:
    ASSIGN v_ind_finalid_cta = "(nenhum)".
    
    EMPTY TEMP-TABLE tt_log_erro.
    run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (INPUT  i-ep-codigo-usuario,
                                                   INPUT  "CEP",
                                                   INPUT  "",
                                                   INPUT  v_ind_finalid_cta,
                                                   INPUT  TODAY,
                                                   OUTPUT v_cod_conta,
                                                   OUTPUT v_des_titulo_conta,
                                                   OUTPUT v_ind_finalid_cta,
                                                   OUTPUT TABLE tt_log_erro).

    IF  NOT CAN-FIND(FIRST tt_log_erro) AND v_cod_conta <> "" THEN
        ASSIGN SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_conta
               c-desc-conta:SCREEN-VALUE                = v_des_titulo_conta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cconta-transit wWindow
ON LEAVE OF cconta-transit IN FRAME fPage2 /* Conta */
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME} cconta-transit
           c-desc-conta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "". 

    EMPTY TEMP-TABLE tt_log_erro.
    ASSIGN lErros  = NO.
   
    ASSIGN v_cod_conta = INPUT FRAME fPage2 cconta-transit.

    RUN pi_verifica_utilizacao_ccusto IN h_api_ccusto (INPUT  "",                 /* EMPRESA EMS 2 */
                                                       INPUT  "",                 /* ESTABELECIMENTO EMS2 */
                                                       INPUT  "",                 /* PLANO CONTAS */
                                                       INPUT  v_cod_conta,        /* CONTA */
                                                       INPUT  TODAY,              /* DT TRANSACAO */
                                                       OUTPUT p_log_ccusto,       /* UTILIZA CCUSTO ? */
                                                       OUTPUT table tt_log_erro). /* ERROS */

     FOR EACH tt_log_erro:
        RUN utp/ut-msgs.p (INPUT 'show':U,
                           INPUT 17006,
                           INPUT tt_log_erro.ttv_des_msg_erro + "~~" + tt_log_erro.ttv_des_msg_ajuda).
        ASSIGN lErros = YES.
    END.
    IF lErros = YES THEN RETURN.

    IF  NOT p_log_ccusto THEN DO:
        ASSIGN c-sc-codigo:SCREEN-VALUE IN FRAME fPage2 = ""
               c-sc-codigo:SENSITIVE    IN FRAME fPage2 = NO.
    END.
    ELSE DO:
        ASSIGN c-sc-codigo:SENSITIVE IN FRAME fPage2 = YES.
    END.

    RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT        i-ep-codigo-usuario, /* EMPRESA EMS2 */
                                                   INPUT        "",                  /* PLANO DE CONTAS */
                                                   INPUT-OUTPUT v_cod_conta,         /* CONTA */
                                                   INPUT        TODAY,               /* DATA TRANSACAO */   
                                                   OUTPUT       v_des_titulo_conta,  /* DESCRICAO CONTA */
                                                   OUTPUT       v_num_tip_cta_ctbl,  /* TIPO DA CONTA */
                                                   OUTPUT       v_num_sit_cta_ctbl,  /* SITUA∞ÄO DA CONTA */
                                                   OUTPUT       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                   OUTPUT TABLE tt_log_erro).        /* ERROS */


    FOR EACH tt_log_erro:
        RUN utp/ut-msgs.p (INPUT 'show':U,
                           INPUT 17006,
                           INPUT tt_log_erro.ttv_des_msg_erro + "~~" + tt_log_erro.ttv_des_msg_ajuda).
        ASSIGN lErros = YES.
    END.
    IF lErros = YES THEN RETURN.

    ASSIGN cconta-transit:SCREEN-VALUE IN FRAME fPage2 = v_cod_conta
           c-desc-conta:SCREEN-VALUE   IN FRAME fPage2 = v_des_titulo_conta.

    APPLY "LEAVE":U TO c-sc-codigo IN FRAME fPage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cconta-transit wWindow
ON MOUSE-SELECT-DBLCLICK OF cconta-transit IN FRAME fPage2 /* Conta */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME iCod-mensagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL iCod-mensagem wWindow
ON F5 OF iCod-mensagem IN FRAME fPage2 /* Mensagem devoluá∆o */
DO:
    ASSIGN l-implanta = NO.
  {include/zoomvar.i &prog-zoom=adzoom/z01ad176.w
                     &campo=iCod-mensagem
                     &campozoom=cod-mensagem
                     &FRAME=fPage2}.
    
           WAIT-FOR CLOSE  OF wh-pesquisa.
           APPLY "LEAVE" TO iCod-mensagem IN FRAME fPage2.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL iCod-mensagem wWindow
ON LEAVE OF iCod-mensagem IN FRAME fPage2 /* Mensagem devoluá∆o */
DO:
    FIND FIRST mensagem NO-LOCK WHERE mensagem.cod-mensagem = INPUT FRAME fPage2 iCod-mensagem NO-ERROR.
    ASSIGN cDescricao    = (IF AVAILABLE mensagem THEN mensagem.descricao    ELSE 'Mensagem n∆o cadastrada')
           cTexto-mensag = (IF AVAILABLE mensagem THEN mensagem.texto-mensag ELSE 'Mensagem invalida! N∆o cadastrada com este c¢digo').

    DISPLAY cDescricao cTexto-mensag WITH FRAME fPage2.

    IF INPUT FRAME fPage2 iCod-mensagem <> 0 then do:
        FIND FIRST mensagem NO-LOCK WHERE
             mensagem.cod-mensagem = INPUT FRAME fPage2 iCod-mensagem NO-ERROR.
        IF NOT AVAILABLE mensagem THEN DO:
            RUN utp/ut-msgs.p ('show', 2, 'Mensagem').
             RETURN NO-APPLY.
        END.
    END.

/*     RUN esp/es0018p.p (INPUT "re1001-upcv":U,                                                      */
/*                        INPUT 1,                                                                    */
/*                        INPUT 0,                                                                    */
/*                        INPUT "":U,                                                                 */
/*                        OUTPUT TABLE tt-prog-ponto).                                                */
/*                                                                                                    */
/*     IF CAN-FIND (FIRST tt-prog-ponto                                                               */
/*                  WHERE tt-prog-ponto.conteudo = string(INPUT FRAME fPage2 iCod-mensagem)) THEN DO: */
/*         ASSIGN c-nom-solicitante:SENSITIVE IN FRAME fPage2 = YES.                                  */
/*     END.                                                                                           */
/*     ELSE DO:                                                                                       */
/*         ASSIGN c-nom-solicitante:SENSITIVE IN FRAME fPage2 = NO                                    */
/*                c-nom-solicitante:SCREEN-VALUE IN FRAME fPage2 = "".                                */
/*     END.                                                                                           */


    FIND FIRST item-doc-est NO-LOCK
         WHERE item-doc-est.cod-emitente = p-cod-emitente
           AND item-doc-est.serie-docto  = p-serie
           AND item-doc-est.nro-docto    = p-documento
           AND item-doc-est.nat-operacao = p-natureza 
           AND item-doc-est.cod-depos   = "TNF" NO-ERROR.
    IF AVAIL item-doc-est THEN DO:
        ASSIGN c-nom-solicitante:SENSITIVE IN FRAME fPage2 = YES.
    END.
    ELSE DO:
        ASSIGN c-nom-solicitante:SENSITIVE IN FRAME fPage2 = NO
               c-nom-solicitante:SCREEN-VALUE IN FRAME fPage2 = "".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL iCod-mensagem wWindow
ON MOUSE-SELECT-DBLCLICK OF iCod-mensagem IN FRAME fPage2 /* Mensagem devoluá∆o */
DO:
  APPLY "F5" TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brDepositos
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterinitializeinterface wWindow 
PROCEDURE afterinitializeinterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN brDepositos:SENSITIVE IN FRAME fPage1 = YES.

    RELEASE ITEM NO-ERROR.

    {&OPEN-QUERY-brDepositos}

    cconta-transit:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage2.
    c-sc-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage2.
    c-usuar-solic-nf-terc:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage3.

    IF iCod-mensagem:LOAD-MOUSE-POINTER ("image\lupa.cur") IN FRAME fPage2 THEN.
    RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.
    RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.
    
    FIND FIRST docum-est NO-LOCK 
         WHERE docum-est.cod-emitente = p-cod-emitente  
           AND docum-est.serie        = p-serie         
           AND docum-est.nro-docto    = p-documento     
           AND docum-est.nat-operacao = p-natureza      NO-ERROR.

    IF AVAIL docum-est THEN DO:
        ASSIGN cconta-transit:SCREEN-VALUE IN FRAME fPage2 = docum-est.ct-transit    
               c-sc-codigo:SCREEN-VALUE    IN FRAME fPage2 = docum-est.sc-transit
               cnarrativa:SCREEN-VALUE     IN FRAME fPage2 = docum-est.observacao.

        RUN esp/es0018p.p (INPUT "esfas016", /* naturezas de transferencia de imobilizado */
                           INPUT 1,
                           INPUT 0,
                           INPUT "", 
                           OUTPUT TABLE tt-prog-ponto).
    
        IF  CAN-FIND (FIRST tt-prog-ponto
                      WHERE tt-prog-ponto.conteudo = docum-est.nat-operacao) THEN
            ASSIGN bt-transf:SENSITIVE IN FRAME fPage4 = YES.
        ELSE
            ASSIGN bt-transf:SENSITIVE IN FRAME fPage4 = NO.

        FIND FIRST int-docum-est NO-LOCK
             WHERE int-docum-est.serie-docto  = docum-est.serie-docto  
               AND int-docum-est.nro-docto    = docum-est.nro-docto    
               AND int-docum-est.cod-emitente = docum-est.cod-emitente 
               AND int-docum-est.nat-operacao = docum-est.nat-operacao NO-ERROR.

        IF AVAIL int-docum-est THEN
            ASSIGN iCod-mensagem:SCREEN-VALUE IN FRAME fPage2 = STRING(int-docum-est.cod-msg-devolucao)
                   c-nom-solicitante:SCREEN-VALUE IN FRAME fPage2 = int-docum-est.nom-solicitante
                   c-usuar-solic-nf-terc:SCREEN-VALUE IN FRAME fPage3 = int-docum-est.user-solic-nf-terc
                   c-ccusto-nf-terc:SCREEN-VALUE IN FRAME fPage3 = int-docum-est.cod-ccusto-nf-terc.

        APPLY "LEAVE" TO c-usuar-solic-nf-terc IN FRAME fPage3.
        APPLY "LEAVE" TO c-ccusto-nf-terc      IN FRAME fPage3.
        
        FOR FIRST nota-fiscal NO-LOCK
            WHERE nota-fiscal.cod-estabel = docum-est.cod-estabel
              AND nota-fiscal.serie       = docum-est.serie-docto
              AND nota-fiscal.nr-nota-fis = docum-est.nro-docto:
        END.

/*         IF AVAIL nota-fiscal THEN DO:                                     */
/*             IF  nota-fiscal.esp-docto        = 20  /* NFD */ THEN DO:     */
/*                                                                           */
/*                 ASSIGN lValidaMsg                                   = YES */
/*                        cconta-transit :SENSITIVE    IN FRAME fPage2 = YES */
/*                        c-sc-codigo   :SENSITIVE    IN FRAME fPage2 = YES  */
/*                        cnarrativa    :SENSITIVE    IN FRAME fPage2 = YES  */
/*                        iCod-mensagem :SENSITIVE    IN FRAME fPage2 = YES. */
/*             END.                                                          */
/*             ELSE DO:                                                      */
/*                                                                           */
/*                 ASSIGN lValidaMsg                                   = NO  */
/*                        cconta-transit :SENSITIVE    IN FRAME fPage2 = no  */
/*                        c-sc-codigo   :SENSITIVE    IN FRAME fPage2 = no   */
/*                        cnarrativa    :SENSITIVE    IN FRAME fPage2 = no   */
/*                        iCod-mensagem :SENSITIVE    IN FRAME fPage2 = no.  */
/*             END.                                                          */
/*         END.                                                              */
/*         ELSE DO:                                                          */
            IF docum-est.esp-docto        = 20  /* NFD */ OR
               CAN-FIND(FIRST item-doc-est OF docum-est
                        WHERE item-doc-est.cod-depos = "TNF") THEN DO:
                
                ASSIGN lValidaMsg                                   = YES
                       cconta-transit :SENSITIVE    IN FRAME fPage2 = YES    
                       c-sc-codigo   :SENSITIVE    IN FRAME fPage2 = YES  
                       cnarrativa    :SENSITIVE    IN FRAME fPage2 = YES
                       iCod-mensagem :SENSITIVE    IN FRAME fPage2 = YES.
            END.
            ELSE DO:
                
                ASSIGN lValidaMsg                                   = NO
                       cconta-transit :SENSITIVE    IN FRAME fPage2 = no   
                       c-sc-codigo   :SENSITIVE    IN FRAME fPage2 = no 
                       cnarrativa    :SENSITIVE    IN FRAME fPage2 = no.
            END.
        /*END.*/
    END.
    
    /* Identificar mensagens v†lidas */
    EMPTY TEMP-TABLE tt-msg.
    EMPTY TEMP-TABLE tt-conta-transit.
    FOR FIRST mgesp.ponto-programa
        WHERE ponto-programa.nome-programa = "esrep001"
          AND ponto-programa.ponto         = 1,
         EACH mgesp.conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
            
        IF  conteudo-programa.conteudo                  <> "" 
        AND NUM-ENTRIES(conteudo-programa.conteudo,";")  > 1 THEN DO:
            IF  ENTRY(1,conteudo-programa.conteudo,";") = "Conta_Transit" THEN DO:
                DO v-num-entr-param = 2 TO NUM-ENTRIES(conteudo-programa.conteudo,";"):
                    CREATE tt-conta-transit.
                    ASSIGN tt-conta-transit.conta-transit = TRIM(ENTRY(v-num-entr-param,conteudo-programa.conteudo,";"))
                           tt-conta-transit.ct-transit    = SUBSTR(tt-conta-transit.conta-transit,1,8)
                           tt-conta-transit.sc-transit    = SUBSTR(tt-conta-transit.conta-transit,9,8).
                END.
            END.
            IF  ENTRY(1,conteudo-programa.conteudo,";") = "MSG"
            THEN DO:
                DO v-num-entr-param = 2 TO NUM-ENTRIES(conteudo-programa.conteudo,";"):
                    CREATE tt-msg.
                    ASSIGN tt-msg.num-msg = INT(ENTRY(v-num-entr-param,conteudo-programa.conteudo,";")).
                END.
            END.
        END.
    END.

    APPLY "leave" TO iCod-mensagem  IN FRAME fPage2.
    APPLY "leave" TO cconta-transit IN FRAME fPage2.
    APPLY "leave" TO c-sc-codigo    IN FRAME fPage2.

    RETURN "OK".
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveDevolucao wWindow 
PROCEDURE saveDevolucao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lValidaCC AS LOGICAL     NO-UNDO.

    IF docum-est.esp-docto        = 20  /* NFD */ THEN DO:
       FIND FIRST tt-conta-transit NO-LOCK
            WHERE tt-conta-transit.ct-transit = cconta-transit:SCREEN-VALUE IN  FRAME fPage2
              AND tt-conta-transit.sc-transit = c-sc-codigo:SCREEN-VALUE IN  FRAME fPage2 NO-ERROR.
       
       IF  AVAIL tt-conta-transit THEN DO:
           FIND FIRST tt-msg NO-LOCK
               WHERE  tt-msg.num-msg = INT(iCod-mensagem:SCREEN-VALUE) NO-ERROR.
       
           IF  NOT AVAIL tt-msg THEN DO:
               RUN utp\ut-msgs.p (INPUT "show",
                                  INPUT 17006,
                                  INPUT "Mensagem inv†lida para devoluá∆o. ~~ê necess†rio preencher a mensagem de devoluá∆o correta. Em caso de d£vidas, contate o departamento TIC para avaliar as parametrizaá‰es no programa ES0018.").
               RETURN "NOK".
           END.
       END.
       
       IF INPUT FRAME fPage2 iCod-mensagem <> 0 then do:
           FIND FIRST mensagem NO-LOCK WHERE
                mensagem.cod-mensagem = INPUT FRAME fPage2 iCod-mensagem NO-ERROR.
           IF NOT AVAILABLE mensagem THEN DO:
               RUN utp/ut-msgs.p ('show', 2, 'Mensagem').
                RETURN "NOK".
           END.
       END.
       ELSE DO:
           RUN utp/ut-msgs.p ('show', 17006, 'Informe uma Mensagem v†lida.~~A Mensagem de Devoluá∆o deve ser diferente de ZERO.').
            RETURN "NOK".
       END.
       
       EMPTY TEMP-TABLE tt_log_erro.
       RUN pi_valida_conta_contabil IN h_api_cta_ctbl (INPUT  i-ep-codigo-usuario,                      /* EMPRESA EMS2 */
                                                       INPUT  v_cod_estab_usuar,                        /* ESTABELECIMENTO EMS2 */
                                                       INPUT  "",                                       /* UNIDADE NEG‡CIO */
                                                       INPUT  "",                                       /* PLANO CONTAS */ 
                                                       INPUT  INPUT FRAME fPage2 cconta-transit, /* CONTA */
                                                       INPUT  "",                                       /* PLANO CCUSTO */ 
                                                       INPUT  INPUT FRAME fPage2 c-sc-codigo,    /* CCUSTO */
                                                       INPUT  TODAY,                                    /* DATA TRANSACAO */
                                                       OUTPUT TABLE tt_log_erro).                       /* ERROS */
       FOR EACH tt_log_erro:
           RUN utp/ut-msgs.p (INPUT 'show':U,
                              INPUT 17006,
                              INPUT tt_log_erro.ttv_des_msg_erro + "~~" + tt_log_erro.ttv_des_msg_ajuda).
       END.
       IF  CAN-FIND(FIRST tt_log_erro) THEN
            RETURN "NOK".
       
       
       ASSIGN v_cod_conta = INPUT FRAME fPage2 cconta-transit
              lValidaCC   = YES.
       
       RUN pi_verifica_utilizacao_ccusto IN h_api_ccusto (INPUT  "",                 /* EMPRESA EMS 2 */
                                                          INPUT  "",                 /* ESTABELECIMENTO EMS2 */
                                                          INPUT  "",                 /* PLANO CONTAS */
                                                          INPUT  v_cod_conta,        /* CONTA */
                                                          INPUT  TODAY,              /* DT TRANSACAO */
                                                          OUTPUT lValidaCC,          /* UTILIZA CCUSTO ? */
                                                          OUTPUT table tt_log_erro). /* ERROS */
       
        FOR EACH tt_log_erro:
           RUN utp/ut-msgs.p (INPUT 'show':U,
                              INPUT 17006,
                              INPUT tt_log_erro.ttv_des_msg_erro + "~~" + tt_log_erro.ttv_des_msg_ajuda).
           ASSIGN lErros = YES.
       END.
       IF  CAN-FIND(FIRST tt_log_erro) THEN
            RETURN "NOK".
       
       IF  lValidaCC = YES THEN DO:
       
           RUN pi_busca_dados_ccusto IN h_api_ccusto (INPUT  i-ep-codigo-usuario, /* EMPRESA EMS2 */
                                                      INPUT  "",                  /* CODIGO DO PLANO CCUSTO */
                                                      INPUT  INPUT FRAME fPage2 c-sc-codigo,         /* CCUSTO */
                                                      INPUT  TODAY,               /* DATA DE TRANSACAO */
                                                      OUTPUT v_des_titulo_ccusto, /* DESCRICAO DO CCUSTO */
                                                      OUTPUT TABLE tt_log_erro).  /* ERROS */
       
            FOR EACH tt_log_erro:
               RUN utp/ut-msgs.p (INPUT 'show':U,
                                  INPUT 17006,
                                  INPUT tt_log_erro.ttv_des_msg_erro + "~~" + tt_log_erro.ttv_des_msg_ajuda).
           END.
       
           IF  CAN-FIND(FIRST tt_log_erro) THEN
                RETURN "NOK".
       END.
    END.

    IF  c-nom-solicitante:SENSITIVE IN FRAME fPage2 
    AND c-nom-solicitante:SCREEN-VALUE IN FRAME fPage2 = "" THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Solicitante n∆o informado. ~~ ê necess†rio preencher solicitante.").
        RETURN "NOK".
    END.
    

    FIND FIRST mgesp.int-docum-est EXCLUSIVE-LOCK 
         WHERE int-docum-est.serie-docto  = p-serie
           AND int-docum-est.nro-docto    = p-documento
           AND int-docum-est.cod-emitente = p-cod-emitente
           AND int-docum-est.nat-operacao = p-natureza NO-ERROR.

    IF NOT AVAIL int-docum-est THEN DO:
        CREATE mgesp.int-docum-est.
        ASSIGN int-docum-est.serie-docto  = p-serie        
               int-docum-est.nro-docto    = p-documento    
               int-docum-est.cod-emitente = p-cod-emitente 
               int-docum-est.nat-operacao = p-natureza.
    END.

    IF AVAIL int-docum-est THEN
       ASSIGN int-docum-est.cod-msg-devolucao  = INPUT FRAME fPage2 iCod-mensagem
              int-docum-est.nom-solicitante    = INPUT FRAME fPage2 c-nom-solicitante.

    FIND CURRENT  int-docum-est NO-LOCK NO-ERROR.

    FIND FIRST docum-est EXCLUSIVE-LOCK 
         WHERE docum-est.serie-docto  = p-serie        
           AND docum-est.nro-docto    = p-documento    
           AND docum-est.cod-emitente = p-cod-emitente 
           AND docum-est.nat-operacao = p-natureza NO-ERROR.

    IF AVAIL docum-est THEN
        ASSIGN docum-est.ct-transit = INPUT FRAME fPage2 cconta-transit
               docum-est.sc-transit = INPUT FRAME fPage2 c-sc-codigo
               docum-est.observacao = INPUT FRAME fPage2 cnarrativa.


     FIND CURRENT docum-est NO-LOCK NO-ERROR.

     RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveSolic wWindow 
PROCEDURE saveSolic :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    IF INPUT FRAME fPage3 c-usuar-solic-nf-terc <> "" THEN DO:
        IF NOT CAN-FIND (FIRST usuar_mestre
                         WHERE usuar_mestre.cod_usuar = INPUT FRAME fPage3 c-usuar-solic-nf-terc) THEN DO:
    
            RUN utp/ut-msgs.p ('show', 17006, 'Informe um usu†rio v†lido.~~O Solicitante NF Terc n∆o existe.').
            RETURN "NOK".
    
        END.
    END.
    
    IF INPUT FRAME fPage3 c-ccusto-nf-terc <> "" THEN DO:
        IF NOT CAN-FIND (FIRST emscad.ccusto
                         WHERE ccusto.cod_ccusto = INPUT FRAME fPage3 c-ccusto-nf-terc) THEN DO:
    
            RUN utp/ut-msgs.p ('show', 17006, 'Informe um centro de custo v†lido.~~O Centro de Custos NF Terc n∆o existe.').
            RETURN "NOK".
    
        END.
    END.


     FIND FIRST int-docum-est EXCLUSIVE-LOCK 
          WHERE int-docum-est.serie-docto  = p-serie
            AND int-docum-est.nro-docto    = p-documento
            AND int-docum-est.cod-emitente = p-cod-emitente
            AND int-docum-est.nat-operacao = p-natureza NO-ERROR.
     
     IF NOT AVAIL int-docum-est THEN DO:
         CREATE mgesp.int-docum-est.
         ASSIGN int-docum-est.serie-docto  = p-serie        
                int-docum-est.nro-docto    = p-documento    
                int-docum-est.cod-emitente = p-cod-emitente 
                int-docum-est.nat-operacao = p-natureza.
     END.
     
     IF AVAIL int-docum-est THEN
        ASSIGN int-docum-est.user-solic-nf-terc = INPUT FRAME fPage3 c-usuar-solic-nf-terc
               int-docum-est.cod-ccusto-nf-terc = INPUT FRAME fPage3 c-ccusto-nf-terc.
     
    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnExTarifario wWindow 
FUNCTION fnExTarifario RETURNS CHARACTER
  ( p-it-codigo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  FIND FIRST int-item NO-LOCK
       WHERE int-item.it-codigo = p-it-codigo NO-ERROR.

  IF AVAIL int-item THEN
      RETURN int-item.ex-tarifario.
  ELSE 
      RETURN "".

  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnSkipLote wWindow 
FUNCTION fnSkipLote RETURNS LOGICAL
  ( p-it-codigo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    RELEASE int-item-fornec-skip-lote.

    FIND FIRST docum-est NO-LOCK 
         WHERE docum-est.cod-emitente = p-cod-emitente  
           AND docum-est.serie        = p-serie         
           AND docum-est.nro-docto    = p-documento     
           AND docum-est.nat-operacao = p-natureza      NO-ERROR.
    IF AVAIL docum-est THEN DO:
        FIND FIRST wm-local-deposito 
             WHERE wm-local-deposito.cod-estabel = docum-est.cod-estab
               AND wm-local-deposito.cod-depos   = 'REC'   NO-LOCK NO-ERROR.
        IF AVAIL wm-local-deposito THEN DO:
    
            FIND FIRST int-item-fornec-skip-lote NO-LOCK
                 WHERE int-item-fornec-skip-lote.it-codigo    = p-it-codigo
                   AND int-item-fornec-skip-lote.cod-emitente = 0 NO-ERROR.
        END.
    END.

    RETURN AVAIL int-item-fornec-skip-lote.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

