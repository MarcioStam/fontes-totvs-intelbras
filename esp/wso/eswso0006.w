&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME w-cadsim


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-int-ocorrencias-vtex NO-UNDO LIKE int-ocorrencias-vtex.
DEFINE TEMP-TABLE tt-int-ped-item-vtex NO-UNDO LIKE int-ped-item-vtex.
DEFINE TEMP-TABLE tt-int-pedido-vtex NO-UNDO LIKE int-pedido-vtex
       field cod-estabel  like ped-venda.cod-estabel
       field cod-emitente like ped-venda.cod-emitente
       field atendente    like ped-venda.tp-pedido
       field nome-transp like ped-venda.nome-transp
       field nome-emit like emitente.nome-emit
       field cod-sit-ped like ped-venda.cod-sit-ped
       FIELD nr-nota-fis LIKE nota-fiscal.nr-nota-fis
       FIELD serie       LIKE nota-fiscal.serie.
DEFINE TEMP-TABLE tt-int-pedido-vtex-erro NO-UNDO LIKE int-pedido-vtex.
DEFINE TEMP-TABLE tt-int-pedido-vtex-param NO-UNDO LIKE int-pedido-vtex.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadsim 
{include/i-prgvrs.i eswso0006 2.00.00.000}

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
{utp/ut-glob.i}
{esp/es0018.i}
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define variable wh-imprime as handle no-undo.
def new global shared var h-facelift as handle no-undo.

DEF BUFFER bint-pedido-vtex FOR int-pedido-vtex.

DEF VAR i-folder AS INTEGER INIT 1 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(40)"  NO-UNDO.

DEFINE VARIABLE i-aba-atual AS INTEGER     NO-UNDO.

DEF VAR d-dt-implant-ini AS DATE INITIAL "01/01/1900".  
DEF VAR d-dt-implant-fim AS DATE INITIAL "12/31/9999".
DEF VAR d-dt-integr-ini  AS DATE INITIAL "01/01/1900".  
DEF VAR d-dt-integr-fim  AS DATE INITIAL "12/31/9999".
DEF VAR c-cd-loja-ini    AS CHAR INITIAL "".
DEF VAR c-cd-loja-fim    AS CHAR INITIAL "ZZZZZZZZZZZZZZZZ".
DEF VAR c-nr-pedido-ini  AS CHAR INITIAL "".
DEF VAR c-nr-pedido-fim  AS CHAR INITIAL "ZZZZZZZZZZZZZZZZ".

DEF VAR i-cod-emitente-ini AS INT INITIAL "0".
DEF VAR i-cod-emitente-fim AS INT INITIAL "999999999".
DEF VAR i-tp-pedido-ini    AS INT INITIAL "0".
DEF VAR i-tp-pedido-fim    AS INT INITIAL "99".
DEF VAR l-tg-aberto        AS LOG INITIAL YES.
DEF VAR l-tg-atendido-parc AS LOG INITIAL YES.
DEF VAR l-tg-atendido-tot  AS LOG INITIAL NO.
DEF VAR l-tg-pendente      AS LOG INITIAL NO.
DEF VAR l-tg-suspenso      AS LOG INITIAL YES.
DEF VAR l-tg-cancelado     AS LOG INITIAL NO.

DEF VAR l-openquery        AS LOG.
DEF VAR c-situacao         AS CHARACTER FORMAT "x(20)"  NO-UNDO.
DEF VAR c-marketplace      AS CHARACTER NO-UNDO.

DEFINE VARIABLE bo-ped-venda-can    AS HANDLE    NO-UNDO.
{method/dbotterr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME br-aprovados

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-int-pedido-vtex tt-int-ocorrencias-vtex ~
tt-int-ped-item-vtex tt-int-pedido-vtex-erro

/* Definitions for BROWSE br-aprovados                                  */
&Scoped-define FIELDS-IN-QUERY-br-aprovados tt-int-pedido-vtex.dt-criacao tt-int-pedido-vtex.dt-integracao tt-int-pedido-vtex.cod-estabel tt-int-pedido-vtex.nr-pedido tt-int-pedido-vtex.nr-pedcli tt-int-pedido-vtex.nr-nota-fis tt-int-pedido-vtex.serie tt-int-pedido-vtex.cod-emitente tt-int-pedido-vtex.nome-emit tt-int-pedido-vtex.vl-tot-pagto tt-int-pedido-vtex.cod-loja fnSitPed(tt-int-pedido-vtex.cod-sit-ped) @ c-situacao tt-int-pedido-vtex.atendente tt-int-pedido-vtex.nome-transp tt-int-pedido-vtex.estado tt-int-pedido-vtex.cidade   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-aprovados   
&Scoped-define SELF-NAME br-aprovados
&Scoped-define QUERY-STRING-br-aprovados FOR EACH tt-int-pedido-vtex BY tt-int-pedido-vtex.dt-integracao DESC       BY tt-int-pedido-vtex.hr-integracao DESC
&Scoped-define OPEN-QUERY-br-aprovados OPEN QUERY {&SELF-NAME} FOR EACH tt-int-pedido-vtex BY tt-int-pedido-vtex.dt-integracao DESC       BY tt-int-pedido-vtex.hr-integracao DESC.
&Scoped-define TABLES-IN-QUERY-br-aprovados tt-int-pedido-vtex
&Scoped-define FIRST-TABLE-IN-QUERY-br-aprovados tt-int-pedido-vtex


/* Definitions for BROWSE br-erros                                      */
&Scoped-define FIELDS-IN-QUERY-br-erros tt-int-ocorrencias-vtex.tipo-registro tt-int-ocorrencias-vtex.cod-erro tt-int-ocorrencias-vtex.descricao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-erros   
&Scoped-define SELF-NAME br-erros
&Scoped-define QUERY-STRING-br-erros FOR EACH tt-int-ocorrencias-vtex
&Scoped-define OPEN-QUERY-br-erros OPEN QUERY {&SELF-NAME} FOR EACH tt-int-ocorrencias-vtex.
&Scoped-define TABLES-IN-QUERY-br-erros tt-int-ocorrencias-vtex
&Scoped-define FIRST-TABLE-IN-QUERY-br-erros tt-int-ocorrencias-vtex


/* Definitions for BROWSE br-itens                                      */
&Scoped-define FIELDS-IN-QUERY-br-itens tt-int-ped-item-vtex.it-codigo tt-int-ped-item-vtex.quantidade tt-int-ped-item-vtex.vl-preco-item fnDescItem(tt-int-ped-item-vtex.it-codigo) @ c-desc-item   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-itens   
&Scoped-define SELF-NAME br-itens
&Scoped-define QUERY-STRING-br-itens FOR EACH tt-int-ped-item-vtex
&Scoped-define OPEN-QUERY-br-itens OPEN QUERY {&SELF-NAME} FOR EACH tt-int-ped-item-vtex.
&Scoped-define TABLES-IN-QUERY-br-itens tt-int-ped-item-vtex
&Scoped-define FIRST-TABLE-IN-QUERY-br-itens tt-int-ped-item-vtex


/* Definitions for BROWSE br-rejeitados                                 */
&Scoped-define FIELDS-IN-QUERY-br-rejeitados tt-int-pedido-vtex-erro.dt-criacao tt-int-pedido-vtex-erro.nr-pedido tt-int-pedido-vtex-erro.nome tt-int-pedido-vtex-erro.vl-tot-pagto tt-int-pedido-vtex-erro.forma-pagto tt-int-pedido-vtex-erro.cidade tt-int-pedido-vtex-erro.estado tt-int-pedido-vtex-erro.dt-integracao tt-int-pedido-vtex-erro.hr-integracao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-rejeitados   
&Scoped-define SELF-NAME br-rejeitados
&Scoped-define QUERY-STRING-br-rejeitados FOR EACH tt-int-pedido-vtex-erro BY tt-int-pedido-vtex-erro.dt-integracao DESC       BY tt-int-pedido-vtex-erro.hr-integracao DESC
&Scoped-define OPEN-QUERY-br-rejeitados OPEN QUERY {&SELF-NAME} FOR EACH tt-int-pedido-vtex-erro BY tt-int-pedido-vtex-erro.dt-integracao DESC       BY tt-int-pedido-vtex-erro.hr-integracao DESC.
&Scoped-define TABLES-IN-QUERY-br-rejeitados tt-int-pedido-vtex-erro
&Scoped-define FIRST-TABLE-IN-QUERY-br-rejeitados tt-int-pedido-vtex-erro


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-br-aprovados}~
    ~{&OPEN-QUERY-br-itens}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-br-erros}~
    ~{&OPEN-QUERY-br-rejeitados}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button folder-1 folder-2 RECT-4 btExcel ~
btSelecao btImportar bt-exit btAtualiza bt-ok bt-cancela 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescItem w-cadsim 
FUNCTION fnDescItem RETURNS CHARACTER
  ( p-it-codigo AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD FnSitPed w-cadsim 
FUNCTION FnSitPed RETURNS CHARACTER
  ( p-cod-sit-ped AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-cadsim AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-cancela 
     LABEL "Button 5" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-exit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-DOWN FILE "image\ii-exi":U
     LABEL "" 
     SIZE 4 BY 1.17.

DEFINE BUTTON bt-ok 
     LABEL "Button 4" 
     SIZE 10 BY 1.

DEFINE BUTTON btAtualiza 
     IMAGE-UP FILE "image/im-relo.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-relo.bmp":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btExcel 
     IMAGE-UP FILE "image\im-excel":U
     IMAGE-INSENSITIVE FILE "image/im-excel.bmp":U
     LABEL "Gerar Excel" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btImportar 
     IMAGE-UP FILE "adeicon/y-combo.bmp":U
     LABEL "Importar" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSelecao 
     IMAGE-UP FILE "image\im-ran":U
     IMAGE-INSENSITIVE FILE "image\ii-ran":U
     LABEL "Sele‡Æo" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE IMAGE folder-1
     FILENAME "image\ts-up110.bmp":U
     SIZE 16 BY 1.21.

DEFINE IMAGE folder-2
     FILENAME "image\ts-dn110.bmp":U
     SIZE 16 BY 1.21.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 114.29 BY 2.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 114.29 BY 1.38
     BGCOLOR 7 .

DEFINE BUTTON bt-consultar 
     LABEL "Consultar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 114.29 BY 1.75.

DEFINE BUTTON bt-editar 
     LABEL "Editar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 114.29 BY 1.75.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-aprovados FOR 
      tt-int-pedido-vtex SCROLLING.

DEFINE QUERY br-erros FOR 
      tt-int-ocorrencias-vtex SCROLLING.

DEFINE QUERY br-itens FOR 
      tt-int-ped-item-vtex SCROLLING.

DEFINE QUERY br-rejeitados FOR 
      tt-int-pedido-vtex-erro SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-aprovados
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-aprovados w-cadsim _FREEFORM
  QUERY br-aprovados DISPLAY
      tt-int-pedido-vtex.dt-criacao
      tt-int-pedido-vtex.dt-integracao
      tt-int-pedido-vtex.cod-estabel WIDTH 2
      tt-int-pedido-vtex.nr-pedido WIDTH 13
      tt-int-pedido-vtex.nr-pedcli WIDTH 13
      tt-int-pedido-vtex.nr-nota-fis COLUMN-LABEL "Nr Nota Fiscal"
      tt-int-pedido-vtex.serie       COLUMN-LABEL "Serie"
      tt-int-pedido-vtex.cod-emitente
      tt-int-pedido-vtex.nome-emit WIDTH 25 COLUMN-LABEL "Nome"
      tt-int-pedido-vtex.vl-tot-pagto WIDTH 10
      tt-int-pedido-vtex.cod-loja WIDTH 6
      fnSitPed(tt-int-pedido-vtex.cod-sit-ped) @ c-situacao COLUMN-LABEL "Sit. Ped." WIDTH 8
      tt-int-pedido-vtex.atendente COLUMN-LABEL "Atendente"
      tt-int-pedido-vtex.nome-transp WIDTH 12
      tt-int-pedido-vtex.estado
      tt-int-pedido-vtex.cidade WIDTH 10
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 114.29 BY 8.75
         FONT 7
         TITLE "Pedidos Aprovados" FIT-LAST-COLUMN.

DEFINE BROWSE br-erros
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-erros w-cadsim _FREEFORM
  QUERY br-erros DISPLAY
      tt-int-ocorrencias-vtex.tipo-registro
tt-int-ocorrencias-vtex.cod-erro
tt-int-ocorrencias-vtex.descricao FORMAT "x(200)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 114.29 BY 5.5
         FONT 7
         TITLE "Erros" FIT-LAST-COLUMN.

DEFINE BROWSE br-itens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-itens w-cadsim _FREEFORM
  QUERY br-itens DISPLAY
      tt-int-ped-item-vtex.it-codigo
tt-int-ped-item-vtex.quantidade
tt-int-ped-item-vtex.vl-preco-item
fnDescItem(tt-int-ped-item-vtex.it-codigo) @ c-desc-item COLUMN-LABEL "Descri‡Æo"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 114.29 BY 5.5
         FONT 7
         TITLE "Itens do Pedido" FIT-LAST-COLUMN.

DEFINE BROWSE br-rejeitados
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-rejeitados w-cadsim _FREEFORM
  QUERY br-rejeitados DISPLAY
      tt-int-pedido-vtex-erro.dt-criacao
      tt-int-pedido-vtex-erro.nr-pedido
      tt-int-pedido-vtex-erro.nome WIDTH 15
      tt-int-pedido-vtex-erro.vl-tot-pagto
      tt-int-pedido-vtex-erro.forma-pagto
      tt-int-pedido-vtex-erro.cidade WIDTH 15
      tt-int-pedido-vtex-erro.estado
      tt-int-pedido-vtex-erro.dt-integracao
      tt-int-pedido-vtex-erro.hr-integracao
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 114.29 BY 8.75
         FONT 7
         TITLE "Pedidos Rejeitados" ROW-HEIGHT-CHARS .67 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     btExcel AT ROW 1.13 COL 2.14 HELP
          "Gerar Relatorio Excel" WIDGET-ID 174
     btSelecao AT ROW 1.13 COL 6 HELP
          "Sele‡Æo" WIDGET-ID 176
     btImportar AT ROW 1.13 COL 9.86 HELP
          "Sele‡Æo" WIDGET-ID 180
     bt-exit AT ROW 1.17 COL 111.29
     btAtualiza AT ROW 2.96 COL 2.43 HELP
          "Atualizar" WIDGET-ID 160
     bt-ok AT ROW 23.5 COL 3 WIDGET-ID 168
     bt-cancela AT ROW 23.5 COL 14 WIDGET-ID 170
     "Pedidos" VIEW-AS TEXT
          SIZE 6.29 BY .67 AT ROW 4.96 COL 6.57
          BGCOLOR 8 FONT 7
     "Rejei‡äes" VIEW-AS TEXT
          SIZE 6.86 BY .67 AT ROW 4.92 COL 21.14
          BGCOLOR 8 FONT 7
     rt-button AT ROW 1.04 COL 1.72
     folder-1 AT ROW 4.75 COL 2
     folder-2 AT ROW 4.75 COL 17.72
     RECT-4 AT ROW 2.63 COL 1.72 WIDGET-ID 178
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 116.14 BY 23.96
         BGCOLOR 15 .

DEFINE FRAME fPage1
     br-aprovados AT ROW 1.25 COL 1.72 WIDGET-ID 200
     bt-consultar AT ROW 10.58 COL 2.86 WIDGET-ID 4
     br-itens AT ROW 12.17 COL 1.72 WIDGET-ID 400
     RECT-6 AT ROW 10.25 COL 1.72 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.29 ROW 6
         SIZE 115.72 BY 17.25
         BGCOLOR 15 FGCOLOR 0 FONT 7.

DEFINE FRAME fPage2
     br-rejeitados AT ROW 1.25 COL 1.72 WIDGET-ID 100
     bt-editar AT ROW 10.58 COL 2.86 WIDGET-ID 2
     br-erros AT ROW 12.17 COL 1.72 WIDGET-ID 300
     RECT-5 AT ROW 10.25 COL 1.72 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.29 ROW 6
         SIZE 115.72 BY 17.25
         BGCOLOR 15 FGCOLOR 0 FONT 7.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Temp-Tables and Buffers:
      TABLE: tt-int-ocorrencias-vtex T "?" NO-UNDO mgesp int-ocorrencias-vtex
      TABLE: tt-int-ped-item-vtex T "?" NO-UNDO mgesp int-ped-item-vtex
      TABLE: tt-int-pedido-vtex T "?" NO-UNDO mgesp int-pedido-vtex
      ADDITIONAL-FIELDS:
          field cod-estabel  like ped-venda.cod-estabel
          field cod-emitente like ped-venda.cod-emitente
          field atendente    like ped-venda.tp-pedido
          field nome-transp like ped-venda.nome-transp
          field nome-emit like emitente.nome-emit
          field cod-sit-ped like ped-venda.cod-sit-ped
      END-FIELDS.
      TABLE: tt-int-pedido-vtex-erro T "?" NO-UNDO mgesp int-pedido-vtex
      TABLE: tt-int-pedido-vtex-param T "?" NO-UNDO mgesp int-pedido-vtex
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-cadsim ASSIGN
         HIDDEN             = YES
         TITLE              = "Manuten‡Æo <Insira o complemento>"
         HEIGHT             = 24.25
         WIDTH              = 117
         MAX-HEIGHT         = 29.71
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 29.71
         VIRTUAL-WIDTH      = 182.86
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-cadsim 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-incsim.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-cadsim
  VISIBLE,,RUN-PERSISTENT                                               */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME f-cad:HANDLE
       FRAME fPage2:FRAME = FRAME f-cad:HANDLE.

/* SETTINGS FOR FRAME f-cad
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB br-aprovados RECT-6 fPage1 */
/* BROWSE-TAB br-itens bt-consultar fPage1 */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB br-rejeitados RECT-5 fPage2 */
/* BROWSE-TAB br-erros bt-editar fPage2 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-aprovados
/* Query rebuild information for BROWSE br-aprovados
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-int-pedido-vtex BY tt-int-pedido-vtex.dt-integracao DESC
      BY tt-int-pedido-vtex.hr-integracao DESC.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-aprovados */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-erros
/* Query rebuild information for BROWSE br-erros
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-int-ocorrencias-vtex.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-erros */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-itens
/* Query rebuild information for BROWSE br-itens
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-int-ped-item-vtex.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-itens */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-rejeitados
/* Query rebuild information for BROWSE br-rejeitados
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-int-pedido-vtex-erro BY tt-int-pedido-vtex-erro.dt-integracao DESC
      BY tt-int-pedido-vtex-erro.hr-integracao DESC.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-rejeitados */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON END-ERROR OF w-cadsim /* Manuten‡Æo <Insira o complemento> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON WINDOW-CLOSE OF w-cadsim /* Manuten‡Æo <Insira o complemento> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-aprovados
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME br-aprovados
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-aprovados w-cadsim
ON ROW-DISPLAY OF br-aprovados IN FRAME fPage1 /* Pedidos Aprovados */
DO:
    IF tt-int-pedido-vtex.tipo-docto = "CNPJ" THEN DO:
         ASSIGN tt-int-pedido-vtex.dt-criacao    :FGCOLOR IN BROWSE br-aprovados = 9
                tt-int-pedido-vtex.dt-integracao :FGCOLOR IN BROWSE br-aprovados = 9
                tt-int-pedido-vtex.cod-estabel   :FGCOLOR IN BROWSE br-aprovados = 9              
                tt-int-pedido-vtex.nr-pedido     :FGCOLOR IN BROWSE br-aprovados = 9        
                tt-int-pedido-vtex.nr-pedcli     :FGCOLOR IN BROWSE br-aprovados = 9
                tt-int-pedido-vtex.nr-nota-fis   :FGCOLOR IN BROWSE br-aprovados = 9
                tt-int-pedido-vtex.serie         :FGCOLOR IN BROWSE br-aprovados = 9
                tt-int-pedido-vtex.cod-emitente  :FGCOLOR IN BROWSE br-aprovados = 9       
                tt-int-pedido-vtex.nome-emit     :FGCOLOR IN BROWSE br-aprovados = 9
                tt-int-pedido-vtex.vl-tot-pagto  :FGCOLOR IN BROWSE br-aprovados = 9            
                tt-int-pedido-vtex.cod-loja      :FGCOLOR IN BROWSE br-aprovados = 9     
                c-situacao                       :FGCOLOR IN BROWSE br-aprovados = 9     
                tt-int-pedido-vtex.atendente     :FGCOLOR IN BROWSE br-aprovados = 9    
                tt-int-pedido-vtex.nome-transp   :FGCOLOR IN BROWSE br-aprovados = 9    
                tt-int-pedido-vtex.estado        :FGCOLOR IN BROWSE br-aprovados = 9    
                tt-int-pedido-vtex.cidade        :FGCOLOR IN BROWSE br-aprovados = 9.

         ASSIGN tt-int-pedido-vtex.dt-criacao    :FONT IN BROWSE br-aprovados = 6
                tt-int-pedido-vtex.dt-integracao :FONT IN BROWSE br-aprovados = 6
                tt-int-pedido-vtex.cod-estabel   :FONT IN BROWSE br-aprovados = 6
                tt-int-pedido-vtex.nr-pedido     :FONT IN BROWSE br-aprovados = 6
                tt-int-pedido-vtex.nr-pedcli     :FONT IN BROWSE br-aprovados = 6
                tt-int-pedido-vtex.nr-nota-fis   :FONT IN BROWSE br-aprovados = 6
                tt-int-pedido-vtex.serie         :FONT IN BROWSE br-aprovados = 6
                tt-int-pedido-vtex.cod-emitente  :FONT IN BROWSE br-aprovados = 6
                tt-int-pedido-vtex.nome-emit     :FONT IN BROWSE br-aprovados = 6
                tt-int-pedido-vtex.vl-tot-pagto  :FONT IN BROWSE br-aprovados = 6
                tt-int-pedido-vtex.cod-loja      :FONT IN BROWSE br-aprovados = 6
                c-situacao                       :FONT IN BROWSE br-aprovados = 6
                tt-int-pedido-vtex.atendente     :FONT IN BROWSE br-aprovados = 6
                tt-int-pedido-vtex.nome-transp   :FONT IN BROWSE br-aprovados = 6
                tt-int-pedido-vtex.estado        :FONT IN BROWSE br-aprovados = 6
                tt-int-pedido-vtex.cidade        :FONT IN BROWSE br-aprovados = 6.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-aprovados w-cadsim
ON VALUE-CHANGED OF br-aprovados IN FRAME fPage1 /* Pedidos Aprovados */
DO:
    EMPTY TEMP-TABLE tt-int-ped-item-vtex.

    FOR EACH int-ped-item-vtex NO-LOCK
       WHERE int-ped-item-vtex.nr-pedido     = tt-int-pedido-vtex.nr-pedido    
         AND int-ped-item-vtex.seq-pedido    = tt-int-pedido-vtex.seq-pedido   
         AND int-ped-item-vtex.dt-integracao = tt-int-pedido-vtex.dt-integracao
         AND SUBSTRING(int-ped-item-vtex.hr-integracao,1,8) = tt-int-pedido-vtex.hr-integracao:
    
        CREATE tt-int-ped-item-vtex.
        BUFFER-COPY int-ped-item-vtex TO tt-int-ped-item-vtex.
    
    END.

    {&open-query-br-itens}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-rejeitados
&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME br-rejeitados
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-rejeitados w-cadsim
ON ROW-DISPLAY OF br-rejeitados IN FRAME fPage2 /* Pedidos Rejeitados */
DO:
    IF  CAN-FIND(FIRST int-pedido-vtex
                    WHERE int-pedido-vtex.nr-pedido = tt-int-pedido-vtex-erro.nr-pedido
                      AND int-pedido-vtex.nr-pedcli <> '')  THEN DO:

         ASSIGN tt-int-pedido-vtex-erro.dt-criacao:FGCOLOR    IN BROWSE br-rejeitados = 2        
                tt-int-pedido-vtex-erro.nr-pedido:FGCOLOR     IN BROWSE br-rejeitados = 2         
                tt-int-pedido-vtex-erro.nome:FGCOLOR          IN BROWSE br-rejeitados = 2 
                tt-int-pedido-vtex-erro.vl-tot-pagto:FGCOLOR  IN BROWSE br-rejeitados = 2      
                tt-int-pedido-vtex-erro.forma-pagto:FGCOLOR   IN BROWSE br-rejeitados = 2       
                tt-int-pedido-vtex-erro.cidade:FGCOLOR        IN BROWSE br-rejeitados = 2
                tt-int-pedido-vtex-erro.estado:FGCOLOR        IN BROWSE br-rejeitados = 2            
                tt-int-pedido-vtex-erro.dt-integracao:FGCOLOR IN BROWSE br-rejeitados = 2     
                tt-int-pedido-vtex-erro.hr-integracao:FGCOLOR IN BROWSE br-rejeitados = 2.     

    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-rejeitados w-cadsim
ON VALUE-CHANGED OF br-rejeitados IN FRAME fPage2 /* Pedidos Rejeitados */
DO:
    EMPTY TEMP-TABLE tt-int-ocorrencias-vtex.

    FOR EACH int-ocorrencias-vtex NO-LOCK
       WHERE int-ocorrencias-vtex.nr-pedido     = tt-int-pedido-vtex-erro.nr-pedido    
         AND int-ocorrencias-vtex.seq-pedido    = tt-int-pedido-vtex-erro.seq-pedido   
         AND int-ocorrencias-vtex.dt-integracao = tt-int-pedido-vtex-erro.dt-integracao
         AND int-ocorrencias-vtex.hr-integracao = tt-int-pedido-vtex-erro.hr-integracao:
    
        CREATE tt-int-ocorrencias-vtex.
        BUFFER-COPY int-ocorrencias-vtex TO tt-int-ocorrencias-vtex.
    
    END.

    {&open-query-br-erros}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-consultar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-consultar w-cadsim
ON CHOOSE OF bt-consultar IN FRAME fPage1 /* Consultar */
DO:
    EMPTY TEMP-TABLE tt-int-pedido-vtex-param.

    IF AVAIL tt-int-pedido-vtex THEN DO:
        CREATE tt-int-pedido-vtex-param.
        BUFFER-COPY tt-int-pedido-vtex TO tt-int-pedido-vtex-param.
        RUN esp/wso/eswso0004a.w (INPUT TABLE tt-int-pedido-vtex-param,
                                  INPUT NO).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME bt-editar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-editar w-cadsim
ON CHOOSE OF bt-editar IN FRAME fPage2 /* Editar */
DO:
    EMPTY TEMP-TABLE tt-int-pedido-vtex-param.

    IF AVAIL tt-int-pedido-vtex-erro THEN DO:
        CREATE tt-int-pedido-vtex-param.
        BUFFER-COPY tt-int-pedido-vtex-erro TO tt-int-pedido-vtex-param.
        RUN esp/wso/eswso0004a.w (INPUT TABLE tt-int-pedido-vtex-param,
                                  INPUT YES).

        RUN pi-carrega.
    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-cad
&Scoped-define SELF-NAME bt-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-exit w-cadsim
ON CHOOSE OF bt-exit IN FRAME f-cad
DO:
  APPLY "close" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAtualiza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAtualiza w-cadsim
ON CHOOSE OF btAtualiza IN FRAME f-cad /* Query Joins */
DO:
    RUN pi-carrega.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExcel w-cadsim
ON CHOOSE OF btExcel IN FRAME f-cad /* Gerar Excel */
DO:
    RUN pi-excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btImportar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImportar w-cadsim
ON CHOOSE OF btImportar IN FRAME f-cad /* Importar */
DO:
   RUN esp/wso/eswso0004c.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSelecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSelecao w-cadsim
ON CHOOSE OF btSelecao IN FRAME f-cad /* Sele‡Æo */
DO:
   RUN esp/wso/eswso0004b.w (INPUT-OUTPUT d-dt-implant-ini,
                             INPUT-OUTPUT d-dt-implant-fim,
                             INPUT-OUTPUT d-dt-integr-ini,
                             INPUT-OUTPUT d-dt-integr-fim,
                             INPUT-OUTPUT c-cd-loja-ini,      
                             INPUT-OUTPUT c-cd-loja-fim,      
                             INPUT-OUTPUT c-nr-pedido-ini,
                             INPUT-OUTPUT c-nr-pedido-fim,
                             INPUT-OUTPUT i-cod-emitente-ini,
                             INPUT-OUTPUT i-cod-emitente-fim,
                             INPUT-OUTPUT i-tp-pedido-ini,
                             INPUT-OUTPUT i-tp-pedido-fim,
                             INPUT-OUTPUT l-tg-aberto,
                             INPUT-OUTPUT l-tg-atendido-parc,
                             INPUT-OUTPUT l-tg-atendido-tot,
                             INPUT-OUTPUT l-tg-pendente,
                             INPUT-OUTPUT l-tg-suspenso,
                             INPUT-OUTPUT l-tg-cancelado,
                             OUTPUT l-openquery).

   IF l-openquery THEN
       RUN pi-carrega.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME folder-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL folder-1 w-cadsim
ON MOUSE-SELECT-CLICK OF folder-1 IN FRAME f-cad
DO:
  folder-1:LOAD-IMAGE("image/ts-up110.bmp").
  folder-2:LOAD-IMAGE("image/ts-dn110.bmp").
  
  APPLY "VALUE-CHANGED" TO br-aprovados IN FRAME fPage1.
  
  VIEW FRAME fPage1.
  HIDE FRAME fPage2.
  

  ASSIGN i-folder = 1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME folder-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL folder-2 w-cadsim
ON MOUSE-SELECT-CLICK OF folder-2 IN FRAME f-cad
DO:
  folder-1:LOAD-IMAGE("image/ts-dn110.bmp").
  folder-2:LOAD-IMAGE("image/ts-up110.bmp").
  HIDE FRAME fPage1.
  VIEW FRAME fPage2.

  APPLY "VALUE-CHANGED" TO br-rejeitados IN FRAME fPage2.

  ASSIGN i-folder = 2.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-aprovados
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-cadsim 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-cadsim  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-cadsim  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-cadsim  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
  THEN DELETE WIDGET w-cadsim.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-cadsim  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  ENABLE rt-button folder-1 folder-2 RECT-4 btExcel btSelecao btImportar 
         bt-exit btAtualiza bt-ok bt-cancela 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  ENABLE RECT-6 br-aprovados bt-consultar br-itens 
      WITH FRAME fPage1 IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-fPage1}
  ENABLE RECT-5 br-rejeitados bt-editar br-erros 
      WITH FRAME fPage2 IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-fPage2}
  VIEW w-cadsim.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-cadsim 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-cadsim 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-cadsim 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}

  {utp/ut9000.i "eswso0006" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  RUN dispatch  IN this-procedure ('enable-fields':U).
  
  {include/i-inifld.i}

  APPLY 'mouse-select-click' TO folder-1 IN FRAME f-cad.

  IF NOT VALID-HANDLE(h-facelift) THEN
    RUN btb/btb901zo.p PERSISTENT SET h-facelift.

  RUN pi_aplica_facelift_thin IN h-facelift (INPUT FRAME fpage1:HANDLE ).
  RUN pi_aplica_facelift_thin IN h-facelift (INPUT FRAME fpage2:HANDLE ).

  //RUN pi-carrega.

  APPLY "value-changed" TO br-aprovados IN FRAME fPage1.
  
  ASSIGN bt-ok:HIDDEN IN FRAME f-cad = YES
         bt-ok:VISIBLE IN FRAME f-cad = NO
         bt-cancela:HIDDEN IN FRAME f-cad = YES
         bt-cancela:VISIBLE IN FRAME f-cad = NO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cancela-pedido-dupli w-cadsim 
PROCEDURE pi-cancela-pedido-dupli :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST ped-venda NO-LOCK
         WHERE ped-venda.nr-pedcli = bint-pedido-vtex.nr-pedcli NO-ERROR.
    IF AVAIL ped-venda THEN DO:
        FOR FIRST int-ped-venda EXCLUSIVE-LOCK
            WHERE int-ped-venda.nr-pedido = int(bint-pedido-vtex.nr-pedcli):
            DELETE int-ped-venda.
        END.
    
        FOR FIRST int-ped-venda2 EXCLUSIVE-LOCK
            WHERE int-ped-venda2.nr-pedido   = int(bint-pedido-vtex.nr-pedcli):
            DELETE int-ped-venda2.
        END.

        FOR EACH int-ocorrencias-vtex EXCLUSIVE-LOCK
           WHERE int-ocorrencias-vtex.nr-pedido     = bint-pedido-vtex.nr-pedido    
             AND int-ocorrencias-vtex.seq-pedido    = bint-pedido-vtex.seq-pedido   
             AND int-ocorrencias-vtex.dt-integracao = bint-pedido-vtex.dt-integracao
             AND int-ocorrencias-vtex.hr-integracao = bint-pedido-vtex.hr-integracao:
            DELETE int-ocorrencias-vtex.
        END.

        DELETE bint-pedido-vtex.

        IF NOT VALID-HANDLE(bo-ped-venda-can) 
        OR bo-ped-venda-can:TYPE <> "PROCEDURE":U 
        OR bo-ped-venda-can:FILE-NAME <> "dibo/bodi159can.p" THEN
            RUN dibo/bodi159can.p PERSISTENT SET bo-ped-venda-can.

        FIND FIRST emitente
             WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-LOCK NO-ERROR.

        RUN emptyRowErrors  IN bo-ped-venda-can.
        RUN setUserLog IN bo-ped-venda-can (INPUT c-seg-usuario).
        RUN validateCancelation IN bo-ped-venda-can (INPUT  ROWID(ped-venda),
                                                     OUTPUT TABLE Rowerrors).
        IF NOT CAN-FIND(FIRST RowErrors
                        WHERE RowErrors.ErrorType <> "INTERNAL"
                          AND RowErrors.ErrorSubType = "Error":U) THEN DO:
            RUN updateCancelation    IN bo-ped-venda-can(INPUT ROWID(ped-venda),
                                                         INPUT "Cancelamento por pedido em duplicidade no ecommerce.",
                                                         INPUT TODAY,
                                                         INPUT 13).
        END.

        IF VALID-HANDLE (bo-ped-venda-can) THEN DO:
            DELETE PROCEDURE bo-ped-venda-can.
            ASSIGN bo-ped-venda-can = ?.
        END.
    END.
 
    RETURN "OK":U.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega w-cadsim 
PROCEDURE pi-carrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
EMPTY TEMP-TABLE tt-int-pedido-vtex.
EMPTY TEMP-TABLE tt-int-pedido-vtex-erro.

EMPTY TEMP-TABLE tt-prog-ponto.
RUN esp/es0018p.p (INPUT "eswso0006":U, INPUT 1, INPUT 0, INPUT "":U, OUTPUT TABLE tt-prog-ponto).

FOR EACH tt-prog-ponto:
  IF c-marketplace = "" THEN
      ASSIGN c-marketplace = tt-prog-ponto.conteudo.
  ELSE 
      ASSIGN c-marketplace = c-marketplace + "," + tt-prog-ponto.conteudo.
END.

FOR EACH int-pedido-vtex 
   WHERE int-pedido-vtex.dt-integr >= d-dt-integr-ini 
     AND int-pedido-vtex.dt-integr <= d-dt-integr-fim
     AND int-pedido-vtex.cod-loja >= c-cd-loja-ini 
     AND int-pedido-vtex.cod-loja <= c-cd-loja-fim
     AND int-pedido-vtex.nr-pedido >= c-nr-pedido-ini
     AND int-pedido-vtex.nr-pedido <= c-nr-pedido-fim NO-LOCK:

    IF LOOKUP(int-pedido-vtex.marketplace,c-marketplace) = 0 THEN NEXT.

    IF int-pedido-vtex.nr-pedcli <> "" THEN DO:

        FIND FIRST ped-venda NO-LOCK
             WHERE ped-venda.nr-pedcli = int-pedido-vtex.nr-pedcli NO-ERROR.
        IF AVAIL ped-venda THEN DO:

            IF ped-venda.dt-implant < d-dt-implant-ini
            OR ped-venda.dt-implant > d-dt-implant-fim THEN
                NEXT.

            IF ped-venda.cod-emitente < i-cod-emitente-ini
            OR ped-venda.cod-emitente > i-cod-emitente-fim THEN
                NEXT.

            IF ped-venda.tp-pedido < string(i-tp-pedido-ini)
            OR ped-venda.tp-pedido > string(i-tp-pedido-fim) THEN
                NEXT.

            IF  NOT l-tg-aberto 
            AND ped-venda.cod-sit-ped = 1 THEN
                NEXT.

            IF  NOT l-tg-atendido-parc 
            AND ped-venda.cod-sit-ped = 2 THEN
                NEXT.

            IF  NOT l-tg-atendido-tot 
            AND ped-venda.cod-sit-ped = 3 THEN
                NEXT.

            IF  NOT l-tg-pendente 
            AND ped-venda.cod-sit-ped = 4 THEN
                NEXT.

            IF  NOT l-tg-suspenso 
            AND ped-venda.cod-sit-ped = 5 THEN
                NEXT.

            IF  NOT l-tg-cancelado 
            AND ped-venda.cod-sit-ped = 6 THEN
                NEXT.

            CREATE tt-int-pedido-vtex.
            BUFFER-COPY int-pedido-vtex TO tt-int-pedido-vtex.

            ASSIGN tt-int-pedido-vtex.cod-estabel  = ped-venda.cod-estabel
                   tt-int-pedido-vtex.cod-emitente = ped-venda.cod-emitente
                   tt-int-pedido-vtex.nome-transp  = ped-venda.nome-transp
                   tt-int-pedido-vtex.atendente    = ped-venda.tp-pedido
                   tt-int-pedido-vtex.cod-sit-ped  = ped-venda.cod-sit-ped.

            FOR FIRST emitente FIELDS(nome-emit) NO-LOCK
                WHERE emitente.nome-abrev = ped-venda.nome-abrev:
                ASSIGN tt-int-pedido-vtex.nome-emit = emitente.nome-emit.
            END.

            FIND FIRST nota-fiscal USE-INDEX ch-pedido
                 WHERE nota-fiscal.nome-ab-cli      = ped-venda.nome-abrev
                   AND nota-fiscal.nr-pedcli        = ped-venda.nr-pedcli NO-LOCK NO-ERROR.

            IF AVAIL nota-fiscal THEN DO:
                ASSIGN tt-int-pedido-vtex.nr-nota-fis = nota-fiscal.nr-nota-fis
                       tt-int-pedido-vtex.serie       = nota-fiscal.serie.
            END.

            IF CAN-FIND(FIRST bint-pedido-vtex NO-LOCK
                        WHERE bint-pedido-vtex.nr-pedido  = int-pedido-vtex.nr-pedido
                          AND bint-pedido-vtex.nr-pedcli <> int-pedido-vtex.nr-pedcli) THEN DO:
                FOR EACH bint-pedido-vtex EXCLUSIVE-LOCK
                   WHERE bint-pedido-vtex.nr-pedido  = int-pedido-vtex.nr-pedido
                     AND bint-pedido-vtex.nr-pedcli <> int-pedido-vtex.nr-pedcli:

                    RUN pi-cancela-pedido-dupli.
                END.
            END.
        END.
    END.
    ELSE DO:
        CREATE tt-int-pedido-vtex-erro.
        BUFFER-COPY int-pedido-vtex TO tt-int-pedido-vtex-erro.
    END.
END.

{&OPEN-query-br-rejeitados}
{&OPEN-query-br-aprovados}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-excel w-cadsim 
PROCEDURE pi-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-arquivo AS CHARACTER   NO-UNDO.
ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "eswso0006" + STRING(TIME) + ".csv".
OUTPUT TO VALUE(c-arquivo) NO-CONVERT.

/*Exorta Pedidos*/
IF i-folder = 1 THEN DO:
    FOR EACH tt-int-pedido-vtex:
        PUT UNFORMATTED "Cria‡Æo;Integracao;Estab;Pedido;Ped Cli;Nr NotaFiscal;Serie;Cliente;Loja;Atendente;Transp;Estado;Cidade;Valor;" SKIP.
        PUT UNFORMATTED string(tt-int-pedido-vtex.dt-criacao)    + ";" +
                        STRING(tt-int-pedido-vtex.dt-integracao) + ";" +
                        tt-int-pedido-vtex.cod-estabel           + ";" +
                        tt-int-pedido-vtex.nr-pedido             + ";" +
                        tt-int-pedido-vtex.nr-pedcli             + ";" +
                        tt-int-pedido-vtex.nr-nota-fis           + ";" +
                        tt-int-pedido-vtex.serie                 + ";" +
                        string(tt-int-pedido-vtex.cod-emitente)  + ";" +
                        string(tt-int-pedido-vtex.cod-loja)      + ";" +
                        string(tt-int-pedido-vtex.atendente)     + ";" +
                        tt-int-pedido-vtex.nome-transp           + ";" +
                        tt-int-pedido-vtex.estado                + ";" +
                        tt-int-pedido-vtex.cidade                + ";" +
                        string(tt-int-pedido-vtex.vl-tot-pedido) + ";" SKIP.

        PUT UNFORMATTED "Item;Quantidade;Pre‡o;Descri‡Æo" SKIP.
        FOR EACH int-ped-item-vtex NO-LOCK
           WHERE int-ped-item-vtex.nr-pedido     = tt-int-pedido-vtex.nr-pedido    
             AND int-ped-item-vtex.seq-pedido    = tt-int-pedido-vtex.seq-pedido   
             AND int-ped-item-vtex.dt-integracao = tt-int-pedido-vtex.dt-integracao
             AND SUBSTRING(int-ped-item-vtex.hr-integracao,1,8) = tt-int-pedido-vtex.hr-integracao:

            PUT UNFORMATTED int-ped-item-vtex.it-codigo + ";"
                            string(int-ped-item-vtex.quantidade) + ";" +
                            string(int-ped-item-vtex.vl-preco-item) + ";" +
                            fnDescItem(int-ped-item-vtex.it-codigo) SKIP.
        END.
        PUT SKIP(1).
    END.
END.
/*Exporta Rejei‡äes*/
ELSE IF i-folder = 2 THEN DO:
    FOR EACH tt-int-pedido-vtex-erro:
        PUT UNFORMATTED "Cria‡Æo;Pedido;Nome;Vlr Pago;Forma Pagto;Cidade;Estado;Integra‡Æo;Hora;" SKIP.

        PUT UNFORMATTED string(tt-int-pedido-vtex-erro.dt-criacao )   + ";" +
                        tt-int-pedido-vtex-erro.nr-pedido             + ";" +
                        tt-int-pedido-vtex-erro.nome                  + ";" +
                        string(tt-int-pedido-vtex-erro.vl-tot-pagto)  + ";" +
                        tt-int-pedido-vtex-erro.forma-pagto           + ";" +
                        tt-int-pedido-vtex-erro.cidade                + ";" +
                        tt-int-pedido-vtex-erro.estado                + ";" +
                        string(tt-int-pedido-vtex-erro.dt-integracao) + ";" +
                        tt-int-pedido-vtex-erro.hr-integracao SKIP.

        PUT UNFORMATTED "Tipo;Erro;Descri‡Æo" SKIP.
        FOR EACH int-ocorrencias-vtex NO-LOCK
           WHERE int-ocorrencias-vtex.nr-pedido     = tt-int-pedido-vtex-erro.nr-pedido    
             AND int-ocorrencias-vtex.seq-pedido    = tt-int-pedido-vtex-erro.seq-pedido   
             AND int-ocorrencias-vtex.dt-integracao = tt-int-pedido-vtex-erro.dt-integracao
             AND int-ocorrencias-vtex.hr-integracao = tt-int-pedido-vtex-erro.hr-integracao:

            PUT UNFORMATTED int-ocorrencias-vtex.tipo-registro    + ";" +
                            string(int-ocorrencias-vtex.cod-erro) + ";" +
                            trim(int-ocorrencias-vtex.descricao) SKIP.
        END.
        PUT SKIP(1).
    END.

END.

OUTPUT CLOSE.

OS-COMMAND NO-WAIT VALUE(c-arquivo) NO-ERROR.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-cadsim  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-int-pedido-vtex-erro"}
  {src/adm/template/snd-list.i "tt-int-ocorrencias-vtex"}
  {src/adm/template/snd-list.i "tt-int-ped-item-vtex"}
  {src/adm/template/snd-list.i "tt-int-pedido-vtex"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-cadsim 
PROCEDURE state-changed :
/*:T -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescItem w-cadsim 
FUNCTION fnDescItem RETURNS CHARACTER
  ( p-it-codigo AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = p-it-codigo NO-ERROR.

    IF AVAIL ITEM THEN
        RETURN ITEM.desc-item.
    ELSE
        RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION FnSitPed w-cadsim 
FUNCTION FnSitPed RETURNS CHARACTER
  ( p-cod-sit-ped AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN {diinc/i03di149.i 04 p-cod-sit-ped} .   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

