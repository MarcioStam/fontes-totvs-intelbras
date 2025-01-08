&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-emitente NO-UNDO LIKE emitente
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-pagto-vpc NO-UNDO LIKE pagto-vpc
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-vpc NO-UNDO LIKE vpc
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESUTP022A 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           ESUTO022A
&GLOBAL-DEFINE Version           2.04.00.001

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      Comercial,CheckList,Observa‡äes

&GLOBAL-DEFINE ttTable           tt-vpc
&GLOBAL-DEFINE hDBOTable         h-boes455
&GLOBAL-DEFINE DBOTable          vpc

&GLOBAL-DEFINE ttParent          tt-emitente
&GLOBAL-DEFINE DBOParentTable    h-boad098

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields tt-emitente.cod-emitente tt-emitente.nome-emit tt-emitente.cod-rep
&GLOBAL-DEFINE page1Fields       tt-vpc.forma-pagto tt-vpc.cod-estab tt-vpc.tipo-acordo tt-vpc.tipo-verba ~
                                 tt-vpc.data-evento tt-vpc.data-vencto ~
                                 tt-vpc.valor tt-vpc.email-repres tt-vpc.data-trans 
&GLOBAL-DEFINE page2Fields       tt-vpc.empenho tt-vpc.comprovacao tt-vpc.id-pagto tt-vpc.num-pagto
&GLOBAL-DEFINE page3Fields       tt-vpc.observacoes

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.

DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

DEFINE TEMP-TABLE tt-unid-negoc NO-UNDO
    FIELD cod-unid-negoc AS CHARACTER
    FIELD descricao      AS CHARACTER.

DEF temp-table tt-vpc-rateio LIKE vpc-rateio.
DEF BUFFER b-vpc-rateio FOR vpc-rateio.

DEF VAR l-inclui AS LOG NO-UNDO.

DEF NEW GLOBAL SHARED VAR h-esutp022-brson1 AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-rateio

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-vpc-rateio

/* Definitions for BROWSE br-rateio                                     */
&Scoped-define FIELDS-IN-QUERY-br-rateio tt-vpc-rateio.cod-unid-negoc tt-vpc-rateio.cod_ccusto tt-vpc-rateio.valor   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-rateio   
&Scoped-define SELF-NAME br-rateio
&Scoped-define QUERY-STRING-br-rateio FOR EACH tt-vpc-rateio
&Scoped-define OPEN-QUERY-br-rateio OPEN QUERY {&SELF-NAME} FOR EACH tt-vpc-rateio.
&Scoped-define TABLES-IN-QUERY-br-rateio tt-vpc-rateio
&Scoped-define FIRST-TABLE-IN-QUERY-br-rateio tt-vpc-rateio


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-br-rateio}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-emitente.cod-emitente ~
tt-emitente.nome-emit tt-emitente.cod-rep tt-vpc.nr-vpc 
&Scoped-define ENABLED-TABLES tt-emitente tt-vpc
&Scoped-define FIRST-ENABLED-TABLE tt-emitente
&Scoped-define SECOND-ENABLED-TABLE tt-vpc
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar btOK btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-emitente.cod-emitente ~
tt-emitente.nome-emit tt-emitente.cod-rep tt-vpc.nr-vpc 
&Scoped-define DISPLAYED-TABLES tt-emitente tt-vpc
&Scoped-define FIRST-DISPLAYED-TABLE tt-emitente
&Scoped-define SECOND-DISPLAYED-TABLE tt-vpc


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON Bt-Altera 
     LABEL "Altera" 
     SIZE 6.86 BY 1 TOOLTIP "Alterar Rateio".

DEFINE BUTTON bt-confirma 
     IMAGE-UP FILE "adeicon/check.bmp":U
     LABEL "Confirma" 
     SIZE 5 BY 1.13.

DEFINE BUTTON bt-exclui 
     LABEL "Exclui" 
     SIZE 6.86 BY 1 TOOLTIP "Excluir Rateio".

DEFINE BUTTON bt-inclui 
     LABEL "Inclui" 
     SIZE 7 BY 1 TOOLTIP "Incluir Rateio".

DEFINE BUTTON bt-volta 
     IMAGE-UP FILE "adeicon/export-u.bmp":U
     LABEL "" 
     SIZE 5 BY 1.13.

DEFINE VARIABLE fi-unid AS CHARACTER FORMAT "X(256)":U 
     LABEL "Unid.Neg" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 31.29 BY 1 NO-UNDO.

DEFINE VARIABLE fi-centro-custo AS CHARACTER FORMAT "X(5)":U 
     LABEL "C.Custo" 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-acordo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-verba AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-valor AS DECIMAL FORMAT ">>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fiCentroCusto AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 24.14 BY .88 NO-UNDO.

DEFINE RECTANGLE r-ret
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 8.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44.29 BY 2.42.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44.29 BY 1.42.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 35.29 BY 2.29.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-rateio FOR 
      tt-vpc-rateio SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-rateio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-rateio wMaintenanceNoNavigation _FREEFORM
  QUERY br-rateio DISPLAY
      tt-vpc-rateio.cod-unid-negoc WIDTH 12
     tt-vpc-rateio.cod_ccusto WIDTH 12
     tt-vpc-rateio.valor WIDTH 13
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 45 BY 5.83
         FONT 1
         TITLE "Rateio" ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-emitente.cod-emitente AT ROW 1.29 COL 16 COLON-ALIGNED WIDGET-ID 36
          LABEL "Fornecedor":R10
          VIEW-AS FILL-IN 
          SIZE 7.57 BY .88
     tt-emitente.nome-emit AT ROW 1.29 COL 23.86 COLON-ALIGNED NO-LABEL WIDGET-ID 38
          VIEW-AS FILL-IN 
          SIZE 46.14 BY .88
     tt-emitente.cod-rep AT ROW 2.25 COL 64 COLON-ALIGNED WIDGET-ID 40
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt-vpc.nr-vpc AT ROW 2.29 COL 16 COLON-ALIGNED WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     btOK AT ROW 23.29 COL 2
     btCancel AT ROW 23.29 COL 13
     btSave AT ROW 23.29 COL 13
     btHelp AT ROW 23.29 COL 80
     rtKeys AT ROW 1.08 COL 1.29
     rtToolBar AT ROW 23.04 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.43 BY 23.63
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     tt-vpc.forma-pagto AT ROW 1.46 COL 13.72 NO-LABEL WIDGET-ID 42
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Boleto", 0,
"Desconto", 1,
"Produto", 2,
"Dep¢sito", 3
          SIZE 39 BY 1
     tt-vpc.cod-estabel AT ROW 2.5 COL 11.57 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     fi-desc-estabel AT ROW 2.5 COL 16.86 COLON-ALIGNED NO-LABEL WIDGET-ID 48
     tt-vpc.data-trans AT ROW 1.5 COL 69 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-vpc.tipo-acordo AT ROW 3.5 COL 11.57 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     fi-desc-acordo AT ROW 3.5 COL 17.86 COLON-ALIGNED NO-LABEL WIDGET-ID 50
     tt-vpc.usuario-trans AT ROW 2.5 COL 69 COLON-ALIGNED WIDGET-ID 24
          LABEL "Usu rio Transa‡Æo"
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     tt-vpc.tipo-verba AT ROW 4.5 COL 11.57 COLON-ALIGNED WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     fi-desc-verba AT ROW 4.5 COL 17.86 COLON-ALIGNED NO-LABEL WIDGET-ID 52
     tt-vpc.data-liberacao AT ROW 3.5 COL 69 COLON-ALIGNED WIDGET-ID 62
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-vpc.usuario-liberacao AT ROW 4.5 COL 69 COLON-ALIGNED WIDGET-ID 66
          VIEW-AS FILL-IN 
          SIZE 15.86 BY .88
     fiCentroCusto AT ROW 11.04 COL 61.43 COLON-ALIGNED NO-LABEL WIDGET-ID 70
     tt-vpc.nro-docto AT ROW 5.5 COL 69 COLON-ALIGNED WIDGET-ID 32
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     tt-vpc.data-evento AT ROW 5.5 COL 11.57 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-vpc.serie-docto AT ROW 6.5 COL 69 COLON-ALIGNED WIDGET-ID 36
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     tt-vpc.data-vencto AT ROW 6.5 COL 11.57 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-vpc.cod-esp AT ROW 7.5 COL 69 COLON-ALIGNED WIDGET-ID 26
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-vpc.email-repres AT ROW 7.5 COL 11.72 COLON-ALIGNED WIDGET-ID 12
          LABEL "Email Repres" FORMAT "x(100)"
          VIEW-AS FILL-IN 
          SIZE 49.29 BY .88
     br-rateio AT ROW 9.83 COL 3 WIDGET-ID 700
     bt-inclui AT ROW 16 COL 27.29 WIDGET-ID 16
     Bt-Altera AT ROW 16 COL 34.29 WIDGET-ID 18
     bt-exclui AT ROW 16 COL 41.14 WIDGET-ID 72
     fi-unid AT ROW 10 COL 54.29 COLON-ALIGNED WIDGET-ID 82
     fi-centro-custo AT ROW 11.04 COL 54.29 COLON-ALIGNED WIDGET-ID 76
     fi-valor AT ROW 12.04 COL 54.29 COLON-ALIGNED WIDGET-ID 28
     bt-confirma AT ROW 13.29 COL 56.29 WIDGET-ID 74
     bt-volta AT ROW 13.29 COL 61.14 WIDGET-ID 34
     tt-vpc.valor AT ROW 16 COL 5.43 COLON-ALIGNED WIDGET-ID 56
          VIEW-AS FILL-IN 
          SIZE 11 BY .88 NO-TAB-STOP 
     "  Rateio de Valores por Unidade de Neg¢cio  ." VIEW-AS TEXT
          SIZE 30.86 BY .54 AT ROW 8.92 COL 27.43 WIDGET-ID 80
     "Forma Pagto:" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 1.67 COL 4 WIDGET-ID 46
     r-ret AT ROW 9.25 COL 2 WIDGET-ID 30
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.14 ROW 5
         SIZE 87.86 BY 17.75
         FONT 1 WIDGET-ID 200.

DEFINE FRAME fPage2
     tt-vpc.empenho AT ROW 2.25 COL 8 WIDGET-ID 2
          VIEW-AS TOGGLE-BOX
          SIZE 11.57 BY .83
     tt-vpc.comprovacao AT ROW 3.25 COL 8 WIDGET-ID 4
          LABEL "Comprova‡Æo(CD/Foto/Tabl¢ide,etc)"
          VIEW-AS TOGGLE-BOX
          SIZE 30 BY .83
     tt-vpc.id-pagto AT ROW 5.5 COL 8 NO-LABEL WIDGET-ID 6
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Boleto", 0,
"Duplicata", 1,
"Nota Debito", 2,
"Pedido", 3
          SIZE 42.29 BY .92
     tt-vpc.num-pagto AT ROW 6.42 COL 6.14 COLON-ALIGNED NO-LABEL WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 41.72 BY .88
     tt-vpc.situacao AT ROW 8.46 COL 7.86 NO-LABEL WIDGET-ID 10
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Bloqueado", 0,
"Liberado", 1,
"Finalizado", 2,
"Cancelado", 3
          SIZE 42.29 BY 1
     "Situa‡Æo VPC:" VIEW-AS TEXT
          SIZE 10.43 BY .54 AT ROW 7.88 COL 7.72 WIDGET-ID 20
     "Pagamento:" VIEW-AS TEXT
          SIZE 9.29 BY .54 AT ROW 4.88 COL 7.72 WIDGET-ID 16
     RECT-1 AT ROW 5.21 COL 7 WIDGET-ID 14
     RECT-2 AT ROW 8.21 COL 7 WIDGET-ID 18
     RECT-3 AT ROW 2 COL 6.72 WIDGET-ID 22
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.14 ROW 5
         SIZE 87.86 BY 17.75
         FONT 1 WIDGET-ID 400.

DEFINE FRAME fPage3
     tt-vpc.observacoes AT ROW 1.67 COL 2 NO-LABEL WIDGET-ID 2
          VIEW-AS EDITOR NO-WORD-WRAP MAX-CHARS 2000 SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 85 BY 9.5
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.14 ROW 5
         SIZE 87.86 BY 18
         FONT 1 WIDGET-ID 600.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-emitente T "?" NO-UNDO mgcad emitente
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-pagto-vpc T "?" NO-UNDO mgesp pagto-vpc
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-vpc T "?" NO-UNDO mgesp vpc
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenanceNoNavigation ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 23.67
         WIDTH              = 90.86
         MAX-HEIGHT         = 39.67
         MAX-WIDTH          = 194.29
         VIRTUAL-HEIGHT     = 39.67
         VIRTUAL-WIDTH      = 194.29
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenanceNoNavigation 
/* ************************* Included-Libraries *********************** */

{maintenancenonavigation/maintenancenonavigation.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenanceNoNavigation
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON btSave IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       btSave:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR FILL-IN tt-emitente.cod-emitente IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
/* BROWSE-TAB br-rateio email-repres fPage1 */
/* SETTINGS FOR FILL-IN tt-vpc.email-repres IN FRAME fPage1
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN tt-vpc.usuario-trans IN FRAME fPage1
   EXP-LABEL                                                            */
ASSIGN 
       tt-vpc.valor:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR TOGGLE-BOX tt-vpc.comprovacao IN FRAME fPage2
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage3
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenanceNoNavigation)
THEN wMaintenanceNoNavigation:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-rateio
/* Query rebuild information for BROWSE br-rateio
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-vpc-rateio
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-rateio */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage3
/* Query rebuild information for FRAME fPage3
     _Query            is NOT OPENED
*/  /* FRAME fPage3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenanceNoNavigation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON END-ERROR OF wMaintenanceNoNavigation
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-rateio
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME br-rateio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-rateio wMaintenanceNoNavigation
ON MOUSE-SELECT-CLICK OF br-rateio IN FRAME fPage1 /* Rateio */
DO:
  RUN pi-mostra-campos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-rateio wMaintenanceNoNavigation
ON VALUE-CHANGED OF br-rateio IN FRAME fPage1 /* Rateio */
DO:
  RUN pi-habilita-campos (NO) .
  RUN pi-habilita-botoes (NO) .
  RUN pi-mostra-campos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Bt-Altera
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-Altera wMaintenanceNoNavigation
ON CHOOSE OF Bt-Altera IN FRAME fPage1 /* Altera */
DO:
  
  IF  AVAIL tt-vpc AND AVAIL tt-vpc-rateio THEN DO:
        RUN pi-carrega-unidades.
        RUN pi-habilita-campos (INPUT YES).
        RUN pi-habilita-botoes ( YES ) .
        ASSIGN fi-unid:SENSITIVE IN FRAME fpage1 = NO
               fi-centro-custo:SENSITIVE IN FRAME fpage1 = NO
               fi-unid:SCREEN-VALUE IN FRAME fpage1 = tt-vpc-rateio.cod-unid-negoc
               fi-centro-custo:SCREEN-VALUE IN FRAME fpage1 = string(tt-vpc-rateio.cod_ccusto)
        l-inclui = NO.
        APPLY "entry" TO fi-unid IN FRAME fpage1.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-confirma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-confirma wMaintenanceNoNavigation
ON CHOOSE OF bt-confirma IN FRAME fPage1 /* Confirma */
DO:
  IF  AVAIL tt-vpc THEN DO TRANS:
      IF  fi-unid:SCREEN-VALUE IN FRAME fpage1 = "" THEN DO:
          RUN utp/ut-msgs.p ("SHOW",
                             17006,
                             "Deve ser informada uma unidade de neg¢cio").
          RETURN NO-APPLY.
      END.
      IF  dec(fi-valor:SCREEN-VALUE IN FRAME fpage1) = 0 THEN DO:
          RUN utp/ut-msgs.p ("SHOW",
                             17006,
                             "Valor para o rateio deve ser informado.").
          RETURN NO-APPLY.
      END.

      IF  NOT CAN-FIND(FIRST centro-custo
                           WHERE centro-custo.cc-codigo = fi-Centro-Custo:SCREEN-VALUE IN FRAME fpage1) THEN DO:
          RUN utp/ut-msgs.p ("SHOW",
                             17006,
                             "Centro de Custo inv lido").
          RETURN NO-APPLY.
      END.
      
      FIND FIRST tt-vpc-rateio 
           WHERE tt-vpc-rateio.nr-vpc         = tt-vpc.nr-vpc
             AND tt-vpc-rateio.cod-unid-negoc = fi-unid:SCREEN-VALUE IN FRAME fpage1 
             AND tt-vpc-rateio.cod_ccusto     = fi-Centro-Custo:SCREEN-VALUE IN FRAME fpage1  NO-ERROR.

      IF  AVAIL tt-vpc-rateio THEN DO:
          IF  l-inclui THEN DO:
              RUN utp/ut-msgs.p ("SHOW",
                   17006,
                   "Rateio j  existente.").
                RETURN NO-APPLY.
          END.
      END.
      ELSE
          CREATE tt-vpc-rateio.

      ASSIGN tt-vpc-rateio.nr-vpc         = tt-vpc.nr-vpc
             tt-vpc-rateio.cod-unid-negoc = fi-unid:SCREEN-VALUE IN FRAME fpage1
             tt-vpc-rateio.cod_ccusto     = fi-centro-custo:SCREEN-VALUE IN FRAME fpage1
             tt-vpc-rateio.valor          = dec(fi-valor:SCREEN-VALUE IN FRAME fpage1).

      RUN pi-habilita-campos ( NO ).
      RUN pi-habilita-botoes ( NO ).
      RUN pi-totaliza-vpc.

      {&OPEN-QUERY-br-rateio} .
    
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-exclui
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-exclui wMaintenanceNoNavigation
ON CHOOSE OF bt-exclui IN FRAME fPage1 /* Exclui */
DO:
    IF  AVAIL tt-vpc-rateio THEN DO:
/*         run utp/ut-msgs.p (input "show", input 27100, input "Confirma elimina‡Æo deste rateio?").  */
/*         IF  RETURN-VALUE <> "YES" THEN                                                             */
/*             RETURN NO-APPLY.                                                                       */
/*         ELSE DO:                                                                                   */
            DELETE tt-vpc-rateio.

            RUN pi-totaliza-vpc.

            {&OPEN-QUERY-br-rateio} .
            RUN pi-carrega-unidades.
/*         END.  */
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-inclui
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-inclui wMaintenanceNoNavigation
ON CHOOSE OF bt-inclui IN FRAME fPage1 /* Inclui */
DO:

    IF  AVAIL tt-vpc THEN DO:
        RUN pi-carrega-unidades.


        RUN pi-habilita-campos (INPUT YES).
        RUN pi-habilita-botoes ( YES ) .

        DO WITH FRAME fpage1:
            ASSIGN fi-unid:SCREEN-VALUE         = ""
                   fi-centro-custo:SCREEN-VALUE = ""
                   fi-valor:SCREEN-VALUE        = "0,00".
    
        END.    

        l-inclui = YES.

        APPLY "entry" TO fi-unid IN FRAME fpage1.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-volta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-volta wMaintenanceNoNavigation
ON CHOOSE OF bt-volta IN FRAME fPage1
DO:
    IF  AVAIL tt-vpc THEN DO:
        RUN pi-habilita-campos ( NO ).
        RUN pi-habilita-botoes ( NO ).
    END.
    IF  AVAIL tt-vpc-rateio THEN
        ASSIGN fi-unid:SCREEN-VALUE IN FRAME fpage1        = tt-vpc-rateio.cod-unid-negoc
               fi-centro-custo:SCREEN-VALUE IN FRAME fpage1 = tt-vpc-rateio.cod_ccusto
               fi-valor:SCREEN-VALUE IN FRAME fpage1        = string(tt-vpc-rateio.valor).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenanceNoNavigation
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenanceNoNavigation
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wMaintenanceNoNavigation
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:

    RUN setVPCRateio IN h-boes455 (INPUT TABLE tt-vpc-rateio).

    DO TRANS:
    
        RUN saveRecord IN THIS-PROCEDURE.
    
        IF  RETURN-VALUE = "OK":U THEN DO:
            RUN GetVPCRateio IN h-boes455 (OUTPUT TABLE tt-vpc-rateio).
    
            FOR EACH vpc-rateio EXCLUSIVE-LOCK
                WHERE vpc-rateio.nr-vpc = tt-vpc.nr-vpc:
                DELETE vpc-rateio.
            END.
            FOR EACH tt-vpc-rateio:
                CREATE vpc-rateio.
                BUFFER-COPY tt-vpc-rateio TO vpc-rateio.
            END.
        END.
        ELSE 
            RETURN NO-APPLY.
    END.

    IF  VALID-HANDLE(h-esutp022-brson1) THEN
        RUN pi-refresh IN h-esutp022-brson1.


    APPLY "CLOSE":U TO THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-vpc.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-vpc.cod-estabel wMaintenanceNoNavigation
ON F5 OF tt-vpc.cod-estabel IN FRAME fPage1 /* Estab */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                        &campo=tt-vpc.cod-estabel
                        &campozoom=cod-estabel
                        &campo2=fi-desc-estabel
                        &campozoom2=nome}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-vpc.cod-estabel wMaintenanceNoNavigation
ON LEAVE OF tt-vpc.cod-estabel IN FRAME fPage1 /* Estab */
DO:
    assign input frame fPage1 tt-vpc.cod-estabel.

    {include/leave.i &tabela=estabelec
                    &atributo-ref=nome
                    &variavel-ref=fi-desc-estabel
                    &where="estabelec.cod-estabel = tt-vpc.cod-estabel"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-vpc.cod-estabel wMaintenanceNoNavigation
ON LEFT-MOUSE-DBLCLICK OF tt-vpc.cod-estabel IN FRAME fPage1 /* Estab */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-centro-custo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-centro-custo wMaintenanceNoNavigation
ON F5 OF fi-centro-custo IN FRAME fPage1 /* C.Custo */
DO:
        {include/zoomvar.i &prog-zoom="inzoom/z01in042"
                       &campo="fi-centro-custo"
                       &campozoom="cc-codigo"
                       &campo2="fiCentroCusto"
                       &campozoom2="descricao"
                       &frame="fPage1"}  
    
    /*
    {method/ZoomFields.i &ProgramZoom="inzoom/z01in042.w"
                         &FieldZoom1="cc-codigo"
                         &FieldScreen1="fi-centro-custo"
                         &Frame1="fPage1"
                         &FieldZoom2="descricao"
                         &FieldScreen2="fiCentroCusto"
                         &Frame2="fPage1"
                         &EnableImplant="NO"}
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-centro-custo wMaintenanceNoNavigation
ON LEAVE OF fi-centro-custo IN FRAME fPage1 /* C.Custo */
DO:

       ASSIGN INPUT FRAME fPage1 fi-Centro-Custo.
      {include/LEAVE.i &tabela=centro-custo
                     &atributo-ref=descricao
                     &variavel-ref=fiCentroCusto
                     &WHERE="centro-custo.cc-codigo = fi-Centro-Custo"}
                     
       

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-centro-custo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF fi-centro-custo IN FRAME fPage1 /* C.Custo */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-vpc.tipo-acordo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-vpc.tipo-acordo wMaintenanceNoNavigation
ON F5 OF tt-vpc.tipo-acordo IN FRAME fPage1 /* Tipo Acordo */
DO:
    {method/ZoomFields.i &ProgramZoom="eszoom/z01es452.w"
                         &FieldZoom1="codigo"
                         &FieldScreen1="tt-vpc.tipo-acordo"
                         &Frame1="fPage1"
                         &FieldZoom2="descricao"
                         &FieldScreen2="fi-desc-acordo"
                         &Frame2="fPage1"
                         &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-vpc.tipo-acordo wMaintenanceNoNavigation
ON LEAVE OF tt-vpc.tipo-acordo IN FRAME fPage1 /* Tipo Acordo */
DO:
    ASSIGN INPUT FRAME fPage1 tt-vpc.tipo-acordo.
    {include/leave.i &tabela=tipo-acordo
                     &atributo-ref=descricao
                     &variavel-ref=fi-desc-acordo
                     &where="tipo-acordo.codigo = tt-vpc.tipo-acordo"}  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-vpc.tipo-acordo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-vpc.tipo-acordo IN FRAME fPage1 /* Tipo Acordo */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-vpc.tipo-verba
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-vpc.tipo-verba wMaintenanceNoNavigation
ON F5 OF tt-vpc.tipo-verba IN FRAME fPage1 /* Tipo Verba */
DO:
    {method/ZoomFields.i &ProgramZoom="eszoom/z01es454.w"
                         &FieldZoom1="codigo"
                         &FieldScreen1="tt-vpc.tipo-verba"
                         &Frame1="fPage1"
                         &FieldZoom2="descricao"
                         &FieldScreen2="fi-desc-verba"
                         &Frame2="fPage1"
                         &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-vpc.tipo-verba wMaintenanceNoNavigation
ON LEAVE OF tt-vpc.tipo-verba IN FRAME fPage1 /* Tipo Verba */
DO:
    ASSIGN INPUT FRAME fPage1 tt-vpc.tipo-verba.
    {include/leave.i &tabela=tipo-verba
                     &atributo-ref=descricao
                     &variavel-ref=fi-desc-verba
                     &where="tipo-verba.codigo = tt-vpc.tipo-verba"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-vpc.tipo-verba wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-vpc.tipo-verba IN FRAME fPage1 /* Tipo Verba */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
tt-vpc.cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-vpc.tipo-acordo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
tt-vpc.tipo-verba:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.

{maintenancenonavigation/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*if avail tt-emitente then do:
        apply 'leave' to tt-emitente.cod-estabel in frame fPage0.
        apply 'leave' to tt-cc-equipamentos.cc-codigo in frame fPage0.
    end.*/

    /*  R A T E I O  */
    DEF VAR de-tot-rateio AS DEC NO-UNDO.
    EMPTY TEMP-TABLE tt-vpc-rateio.

    FOR EACH vpc-rateio NO-LOCK
        WHERE vpc-rateio.nr-vpc = tt-vpc.nr-vpc:
        CREATE tt-vpc-rateio.
        BUFFER-COPY vpc-rateio TO tt-vpc-rateio.
        ASSIGN de-tot-rateio = de-tot-rateio + vpc-rateio.valor. 
    END.
    IF  tt-vpc.situacao <> 1 THEN
        DO WITH FRAME fpage1:
            ASSIGN br-rateio:SENSITIVE = YES
                   bt-inclui:SENSITIVE = YES
                   bt-altera:SENSITIVE = YES
                   bt-exclui:SENSITIVE = YES.
    
        END.

     ASSIGN tt-vpc.valor:SCREEN-VALUE IN FRAME fpage1 = string(de-tot-rateio).
    {&OPEN-QUERY-br-rateio} 
    /* fim rateio */


    IF pcAction = "ADD" THEN DO:
        ASSIGN tt-vpc.data-trans:SCREEN-VALUE        IN FRAME fPage1 = STRING(TODAY,"99/99/9999")
               tt-vpc.usuario-trans:SCREEN-VALUE     IN FRAME fPage1 = c-seg-usuario
               tt-vpc.data-liberacao:SCREEN-VALUE    IN FRAME fPage1 = ""
               tt-vpc.usuario-liberacao:SCREEN-VALUE IN FRAME fPage1 = ""
               tt-vpc.nro-docto:SCREEN-VALUE         IN FRAME fPage1 = ""
               tt-vpc.serie:SCREEN-VALUE             IN FRAME fPage1 = ""
               tt-vpc.cod-esp:SCREEN-VALUE           IN FRAME fPage1 = ""
               tt-vpc.situacao:SCREEN-VALUE          IN FRAME fPage2 = "1".

        FIND FIRST emitente NO-LOCK 
             WHERE emitente.cod-emitente = tt-emitente.cod-emitente NO-ERROR.
        IF AVAIL emitente THEN DO:
            FIND FIRST repres NO-LOCK
                 WHERE repres.cod-rep = emitente.cod-rep NO-ERROR.
            IF AVAIL repres THEN DO:
                ASSIGN tt-vpc.email-repres:SCREEN-VALUE IN FRAME fPage1 = repres.e-mail.
            END.
        END.
    END.
    ELSE 
    IF pcAction = "update" THEN DO:
        ASSIGN tt-vpc.data-trans:SCREEN-VALUE        IN FRAME fPage1 = STRING(tt-vpc.data-trans,"99/99/9999")
               tt-vpc.usuario-trans:SCREEN-VALUE     IN FRAME fPage1 = tt-vpc.usuario-trans
               tt-vpc.data-liberacao:SCREEN-VALUE    IN FRAME fPage1 = STRING(tt-vpc.data-liberacao,"99/99/9999")
               tt-vpc.usuario-liberacao:SCREEN-VALUE IN FRAME fPage1 = tt-vpc.usuario-liberacao
               tt-vpc.nro-docto:SCREEN-VALUE         IN FRAME fPage1 = tt-vpc.nro-docto
               tt-vpc.serie:SCREEN-VALUE             IN FRAME fPage1 = tt-vpc.serie
               tt-vpc.cod-esp:SCREEN-VALUE           IN FRAME fPage1 = tt-vpc.cod-esp
               tt-vpc.situacao:SCREEN-VALUE          IN FRAME fPage2 = STRING(tt-vpc.situacao).

        ASSIGN tt-vpc.nr-vpc:SCREEN-VALUE IN FRAME fPage0 = STRING(tt-vpc.nr-vpc).
    END.
    ELSE 
        IF pcAction = "COPY" THEN DO:
            ASSIGN tt-vpc.data-trans:SCREEN-VALUE        IN FRAME fPage1 = STRING(tt-vpc.data-trans,"99/99/9999")
                   tt-vpc.usuario-trans:SCREEN-VALUE     IN FRAME fPage1 = tt-vpc.usuario-trans
                   tt-vpc.data-liberacao:SCREEN-VALUE    IN FRAME fPage1 = STRING(tt-vpc.data-liberacao,"99/99/9999")
                   tt-vpc.usuario-liberacao:SCREEN-VALUE IN FRAME fPage1 = tt-vpc.usuario-liberacao
                   tt-vpc.nro-docto:SCREEN-VALUE         IN FRAME fPage1 = tt-vpc.nro-docto
                   tt-vpc.serie:SCREEN-VALUE             IN FRAME fPage1 = tt-vpc.serie
                   tt-vpc.cod-esp:SCREEN-VALUE           IN FRAME fPage1 = tt-vpc.cod-esp
                   tt-vpc.situacao:SCREEN-VALUE          IN FRAME fPage2 = STRING(tt-vpc.situacao).
        END.
    
    IF AVAIL tt-vpc THEN DO:
        APPLY "leave" TO tt-vpc.cod-estabel IN FRAME fPage1.
        APPLY "leave" TO tt-vpc.tipo-acordo IN FRAME fPage1.
        APPLY "leave" TO tt-vpc.tipo-verba IN FRAME fPage1.
    END.
    
    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenanceNoNavigation 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF AVAIL tt-vpc THEN DO:
        IF tt-vpc.situacao <> 0 THEN DO:
            DISABLE {&page3Fields} WITH FRAME fPage3.
            DISABLE {&page1Fields} WITH FRAME fPage1.

            ENABLE tt-vpc.cod-esp 
                   WITH FRAME fPage1.

            ASSIGN tt-vpc.cod-esp:READ-ONLY   IN FRAME fPage1 = YES.

            ASSIGN tt-vpc.observacoes:SENSITIVE IN FRAME fPage3 = YES
                   tt-vpc.observacoes:READ-ONLY IN FRAME fPage3 = YES.
        END.

        IF tt-vpc.situacao <> 1 THEN DO:
            IF tt-vpc.situacao = 0 THEN DO:
                FIND FIRST param-vpc NO-LOCK
                     WHERE param-vpc.cod-estabel = tt-vpc.cod-estabel NO-ERROR.
                IF AVAIL param-vpc AND LOOKUP(c-seg-usuario,param-vpc.aprovadores) <> 0 THEN DO:
                    ASSIGN tt-vpc.data-trans:SENSITIVE IN FRAME fPage1 = YES.
                END.
                ELSE DO:
                    ASSIGN tt-vpc.data-trans:SENSITIVE IN FRAME fPage1 = NO.
                END.
            END.
        END.

        IF pcAction = "COPY" THEN DO:
           RUN habilitaCopia.
        END.

        IF tt-vpc.situacao <= 1 THEN DO:
            ENABLE tt-vpc.forma-pagto WITH FRAME fPage1.
        END.

        IF tt-vpc.situacao = 3 THEN DO:
            DISABLE {&page2Fields} WITH FRAME fPage2.
        END.
    END.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDisplayFields wMaintenanceNoNavigation 
PROCEDURE beforeDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    RUN pi-carrega-unidades.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE habilitaCopia wMaintenanceNoNavigation 
PROCEDURE habilitaCopia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 ASSIGN tt-vpc.cod-estabel:SENSITIVE IN FRAME fPage1       = YES
        tt-vpc.tipo-acordo:SENSITIVE IN FRAME fPage1       = YES
        tt-vpc.tipo-verba:SENSITIVE IN FRAME fPage1        = YES
        tt-vpc.data-evento:SENSITIVE IN FRAME fPage1       = YES
        tt-vpc.data-vencto:SENSITIVE IN FRAME fPage1       = YES
        tt-vpc.valor:SENSITIVE IN FRAME fPage1             = YES
        tt-vpc.email-repres:SENSITIVE IN FRAME fPage1      = YES
        tt-vpc.data-trans:SENSITIVE IN FRAME fPage1        = YES
        tt-vpc.usuario-trans:SENSITIVE IN FRAME fPage1     = YES
        tt-vpc.data-liberacao:SENSITIVE IN FRAME fPage1    = YES
        tt-vpc.usuario-liberacao:SENSITIVE IN FRAME fPage1 = YES
        tt-vpc.nro-docto:SENSITIVE IN FRAME fPage1         = YES
        tt-vpc.serie-docto:SENSITIVE IN FRAME fPage1       = YES
        tt-vpc.cod-esp:SENSITIVE IN FRAME fPage1           = YES
        tt-vpc.empenho:SENSITIVE IN FRAME fPage2           = YES
        tt-vpc.comprovacao:SENSITIVE IN FRAME fPage2       = YES
        tt-vpc.num-pagto:SENSITIVE IN FRAME fPage2         = YES
        tt-vpc.situacao:SENSITIVE IN FRAME fPage2          = YES
        /*tt-vpc.observacoes:SENSITIVE IN FRAME fPage3       = YES*/
        tt-vpc.observacoes:READ-ONLY IN FRAME fPage3       = NO.
 
 ENABLE tt-vpc.forma-pagto       WITH FRAME fPage1.     
 ENABLE tt-vpc.cod-estabel       WITH FRAME fPage1.      
 ENABLE tt-vpc.tipo-acordo       WITH FRAME fPage1.      
 ENABLE tt-vpc.tipo-verba        WITH FRAME fPage1.       
 ENABLE tt-vpc.data-evento       WITH FRAME fPage1.      
 ENABLE tt-vpc.data-vencto       WITH FRAME fPage1.      
 ENABLE tt-vpc.valor             WITH FRAME fPage1.            
 ENABLE tt-vpc.email-repres      WITH FRAME fPage1.     
 ENABLE tt-vpc.data-trans        WITH FRAME fPage1.       
 ENABLE tt-vpc.usuario-trans     WITH FRAME fPage1.    
 ENABLE tt-vpc.data-liberacao    WITH FRAME fPage1.   
 ENABLE tt-vpc.usuario-liberacao WITH FRAME fPage1.
 ENABLE tt-vpc.nro-docto         WITH FRAME fPage1.        
 ENABLE tt-vpc.serie-docto       WITH FRAME fPage1.      
 ENABLE tt-vpc.cod-esp           WITH FRAME fPage1.          
 ENABLE tt-vpc.empenho           WITH FRAME fPage2.          
 ENABLE tt-vpc.comprovacao       WITH FRAME fPage2.      
 ENABLE tt-vpc.num-pagto         WITH FRAME fPage2.        
 ENABLE tt-vpc.situacao          WITH FRAME fPage2.         
 ENABLE tt-vpc.observacoes       WITH FRAME fPage3.
 ENABLE btSave                   WITH FRAME fPage0. 
     
 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-rateio wMaintenanceNoNavigation 
PROCEDURE pi-carrega-rateio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*     /*  R A T E I O  */                                          */
/*     DEF VAR de-tot-rateio AS DEC NO-UNDO.                        */
/*     FOR EACH vpc-rateio NO-LOCK                                  */
/*         WHERE vpc-rateio.nr-vpc = tt-vpc.nr-vpc:                 */
/*         CREATE tt-vpc-rateio.                                    */
/*         BUFFER-COPY vpc-rateio TO tt-vpc-rateio.                 */
/*         ASSIGN de-tot-rateio = de-tot-rateio + vpc-rateio.valor. */
/*     END.                                                         */
/*                                                                  */
    {&OPEN-QUERY-br-rateio} .
    /* fim rateio */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-unidades wMaintenanceNoNavigation 
PROCEDURE pi-carrega-unidades :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-desc AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE h-esapi015 AS HANDLE      NO-UNDO.

    FOR EACH tt-unid-negoc:
        DELETE tt-unid-negoc.
    END.
    
    RUN esapi/esapi015.p PERSISTENT SET h-esapi015.
    RUN pi-retorna-unidade IN h-esapi015 (OUTPUT TABLE tt-unid-negoc).
    DELETE PROCEDURE h-esapi015.

    ASSIGN fi-unid:LIST-ITEM-PAIRS IN FRAME fPage1 = ",".

    FOR EACH tt-unid-negoc BY tt-unid-negoc.cod-unid-negoc:
        ASSIGN c-desc = tt-unid-negoc.cod-unid-negoc + "-" + tt-unid-negoc.descricao.

        fi-unid:add-last(c-desc, tt-unid-negoc.cod-unid-negoc) IN FRAME fPage1 NO-ERROR.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-botoes wMaintenanceNoNavigation 
PROCEDURE pi-habilita-botoes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-habilita AS LOG NO-UNDO.    

    DO WITH FRAME fpage1:
        ASSIGN bt-confirma:SENSITIVE = p-habilita
               bt-volta:SENSITIVE    = p-habilita
               fiCentroCusto         = "".
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-campos wMaintenanceNoNavigation 
PROCEDURE pi-habilita-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-habilita AS LOG NO-UNDO.

    DO WITH FRAME fPage1:
        ASSIGN fi-unid:SENSITIVE         = p-habilita
               fi-centro-custo:SENSITIVE = p-habilita
               fi-valor:SENSITIVE        = p-habilita.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-campos wMaintenanceNoNavigation 
PROCEDURE pi-mostra-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF  NOT AVAIL tt-vpc-rateio THEN
        RETURN.

    DO WITH FRAME fpage1:
        ASSIGN fi-unid:SCREEN-VALUE         = tt-vpc-rateio.cod-unid-negoc
               fi-centro-custo:SCREEN-VALUE = tt-vpc-rateio.cod_ccusto
               fi-valor:SCREEN-VALUE        = string(tt-vpc-rateio.valor).

    END.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-totaliza-vpc wMaintenanceNoNavigation 
PROCEDURE pi-totaliza-vpc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR de-tot-rateio AS DEC NO-UNDO.
    FOR EACH tt-vpc-rateio
        WHERE tt-vpc-rateio.nr-vpc = tt-vpc.nr-vpc:
        ASSIGN de-tot-rateio = de-tot-rateio + tt-vpc-rateio.valor.
    END.

    ASSIGN tt-vpc.valor:SCREEN-VALUE IN FRAME fpage1 = STRING(de-tot-rateio).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-campos-rateio wMaintenanceNoNavigation 
PROCEDURE pi-valida-campos-rateio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*:T------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela filho ({&ttTable}) com base 
               nos campos da tabela pai ({&ttParent})
  Parameters:  
  Notes:       Este m‚todo somente ‚ executado quando a vari vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/
    assign tt-vpc.cod-emitente  = tt-emitente.cod-emitente
           tt-vpc.nr-vpc        = INT(tt-vpc.nr-vpc:SCREEN-VALUE IN FRAME fPage0)
           tt-vpc.data-trans    = DATE(tt-vpc.data-trans:SCREEN-VALUE IN FRAME fPage1)
           tt-vpc.usuario-trans = tt-vpc.usuario-trans:SCREEN-VALUE IN FRAME fPage1.
    



    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

