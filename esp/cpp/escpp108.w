&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgmov            PROGRESS
*/
&Scoped-define WINDOW-NAME w-cadsim


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-ord-prod NO-UNDO LIKE ord-prod
       field selecionada as log
       field ind-status-industr as int
       field num-pedido as int
       field docto-ret as char
       field docto-serv as char
       field status-nota-ret as char
       field status-nota-serv as char
       field vl-tot-nota-serv like nota-fiscal.vl-tot-nota
       field dt-emis like nota-fiscal.dt-emis
       field user-calc like nota-fiscal.user-calc
       field data-reporte like rep-prod.data
       field usuario-reporte like rep-prod.usuario.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadsim 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i escpp108 2.00.00.000}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> <m¢dulo>}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
{upc/btb910za-upc.i}
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define variable wh-imprime as handle no-undo.
DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "x(80)"  NO-UNDO.
DEFINE VARIABLE c-estado    AS CHARACTER FORMAT "x(20)"  NO-UNDO.

DEF VAR c-cod-estabel-ini    AS CHAR INITIAL "".
DEF VAR c-cod-estabel-fim    AS CHAR INITIAL "ZZZZZ".
DEF VAR i-nr-ord-produ-ini   AS INT  INITIAL "0".
DEF VAR i-nr-ord-produ-fim   AS INT  INITIAL "999999999".
DEF VAR c-it-codigo-ini      AS CHAR INITIAL "".
DEF VAR c-it-codigo-fim      AS CHAR INITIAL "ZZZZZZZZZZZZZZZZ".
DEF VAR d-dt-faturamento-ini AS DATE INITIAL "01/01/1900".
DEF VAR d-dt-faturamento-fim AS DATE INITIAL "12/31/9999".
DEF VAR d-dt-recebimento-ini AS DATE INITIAL "01/01/1900".
DEF VAR d-dt-recebimento-fim AS DATE INITIAL "12/31/9999".
DEF VAR d-dt-emissao-ini AS DATE INITIAL "01/01/1900".
DEF VAR d-dt-emissao-fim AS DATE INITIAL "12/31/9999".

ASSIGN c-cod-estabel-ini = v_cod_estab_usuar
       c-cod-estabel-fim = v_cod_estab_usuar.

ASSIGN d-dt-faturamento-ini = date("01" + "/" + STRING(MONTH(TODAY)) + "/" + STRING(YEAR(TODAY)))
       d-dt-recebimento-ini = date("01" + "/" + STRING(MONTH(TODAY)) + "/" + STRING(YEAR(TODAY))).

/* DEF VAR l-tg-nao-iniciada    AS LOG INITIAL YES. */
/* DEF VAR l-tg-liberada        AS LOG INITIAL YES. */
/* DEF VAR l-tg-reservada       AS LOG INITIAL YES. */
/* DEF VAR l-tg-separada        AS LOG INITIAL YES. */
/* DEF VAR l-tg-requisitada     AS LOG INITIAL YES. */
/* DEF VAR l-tg-iniciada        AS LOG INITIAL YES. */
/* DEF VAR l-tg-finalizada      AS LOG INITIAL NO.  */
/* DEF VAR l-tg-terminada       AS LOG INITIAL NO.  */

DEF VAR l-tg-status-0        AS LOG INITIAL YES.
DEF VAR l-tg-status-1        AS LOG INITIAL YES.
DEF VAR l-tg-status-2        AS LOG INITIAL NO.
DEFINE VARIABLE c-estab AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-ord-prod-sel LIKE tt-ord-prod
       FIELD l-fatura-nf AS LOG.

DEF VAR l-openquery        AS LOG.


DEFINE VARIABLE c-nr-ord-prod AS CHARACTER   NO-UNDO.
DEF VAR raw-param AS RAW.


{method/dbotterr.i}
{esp/es0018.i}
{utp/ut-glob.i}
{esp/cpp/escpp108rpatt.i}

DEFINE TEMP-TABLE ttRepApi
    FIELD nr-ord-produ    LIKE ord-prod.nr-ord-produ
    FIELD op-codigo       AS   INTEGER 
    FIELD qt-reporte      AS   INTEGER
    FIELD depos-ent       AS   CHAR
    FIELD depos-sai       AS   CHAR
    FIELD c-enche         AS   CHAR
    FIELD linha           AS   CHAR
    FIELD c-localizacao   AS   CHAR
    FIELD cEtiqueta       AS   CHAR
    FIELD c-nome-imp      AS   CHAR                              
    FIELD cNomeLayout     AS   CHAR 
    FIELD nao-imprimir    AS   LOGICAL
    FIELD procura-saldo   AS   LOGICAL
    FIELD da-data-reporte AS   DATE
    FIELD l-ver-sel       AS   LOGICAL.

DEFINE TEMP-TABLE tt-resultado-fatura-nf NO-UNDO
    FIELD nr-ord-produ     LIKE ord-prod.nr-ord-produ
    FIELD erros AS CHAR.

DEFINE TEMP-TABLE tt-resultado-receber-nf NO-UNDO
    FIELD nr-ord-produ     LIKE ord-prod.nr-ord-produ
    FIELD erros AS CHAR.

DEFINE TEMP-TABLE tt-erro-reporte           NO-UNDO
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

DEFINE TEMP-TABLE tt-erro-faturar-nf      NO-UNDO
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

DEFINE TEMP-TABLE tt-digita-aux NO-UNDO
    FIELD cod-estabel       LIKE nota-fiscal.cod-estabel
    FIELD serie             like nota-fiscal.serie
    FIELD nr-nota-fis       LIKE nota-fiscal.nr-nota-fis
    FIELD cdd-embarq        like nota-fiscal.cdd-embarq COLUMN-LABEL "Embarque".

def temp-table tt-param-aux
    field destino              as integer
    field destino-bloq         as integer
    field arquivo              as char
    field arquivo-bloq         as char
    field usuario              as char
    field data-exec            as date
    field hora-exec            as integer
    field parametro            as logical
    field formato              as integer
    field cod-layout           as character
    field des-layout           as character
    field log-impr-dados       as logical  
    field v_num_tip_aces_usuar as integer
&IF "{&mguni_version}" >= "2.071" &THEN
    field ep-codigo            LIKE mgcad.empresa.ep-codigo
&ELSE
    field ep-codigo            as integer
&ENDIF
    field da-dt-saida          like movdis.nota-fiscal.dt-saida
    field c-hr-saida           AS CHAR FORMAT "xx:xx:xx":U INITIAL "000000"
    field banco                as integer
    field cod-febraban         as integer      
    field cod-portador         as integer      
    field prox-bloq            as char         
    field c-instrucao          as char extent 5
    field imprime-bloq         as logical
    field rs-imprime           as integer
    FIELD impressora-so        AS CHAR
    FIELD impressora-so-bloq   AS CHAR
    FIELD nr-copias            AS INTEGER
    FIELD l-gera-danfe-xml     AS LOGICAL
    FIELD c-dir-hist-xml       AS CHARACTER
    FIELD ind-execucao         AS INT
    FIELD data-ini             AS DATE
    FIELD data-fim             AS DATE
    FIELD nr-nota-fis          AS CHAR
    FIELD serie                AS CHAR
    FIELD cod-estabel          AS CHAR.

DEFINE VARIABLE c-status AS CHARACTER FORMAT "x(20)"  NO-UNDO.

   define variable h-acomp as handle no-undo.

DEFINE BUFFER b-nota-fiscal FOR nota-fiscal.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME br-ordens

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ord-prod tt-ord-prod-sel

/* Definitions for BROWSE br-ordens                                     */
&Scoped-define FIELDS-IN-QUERY-br-ordens tt-ord-prod.selecionada tt-ord-prod.nr-ord-prod tt-ord-prod.cod-estabel tt-ord-prod.it-codigo fnDescItem(tt-ord-prod.it-codigo) @ c-desc-item tt-ord-prod.qt-ordem tt-ord-prod.un fnEstadoOrdem(tt-ord-prod.estado) @ c-estado fnStatus(tt-ord-prod.ind-status-industr) @ c-status tt-ord-prod.num-pedido tt-ord-prod.docto-ret tt-ord-prod.status-nota-ret tt-ord-prod.docto-serv tt-ord-prod.status-nota-serv tt-ord-prod.vl-tot-nota-serv tt-ord-prod.dt-emis tt-ord-prod.user-calc tt-ord-prod.data-reporte tt-ord-prod.usuario-reporte   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-ordens   
&Scoped-define SELF-NAME br-ordens
&Scoped-define QUERY-STRING-br-ordens FOR EACH tt-ord-prod
&Scoped-define OPEN-QUERY-br-ordens OPEN QUERY {&SELF-NAME} FOR EACH tt-ord-prod.
&Scoped-define TABLES-IN-QUERY-br-ordens tt-ord-prod
&Scoped-define FIRST-TABLE-IN-QUERY-br-ordens tt-ord-prod


/* Definitions for BROWSE br-selecionadas                               */
&Scoped-define FIELDS-IN-QUERY-br-selecionadas tt-ord-prod-sel.nr-ord-prod tt-ord-prod-sel.cod-estabel tt-ord-prod-sel.it-codigo fnDescItem(tt-ord-prod-sel.it-codigo) @ c-desc-item tt-ord-prod-sel.qt-ordem tt-ord-prod-sel.un fnEstadoOrdem(tt-ord-prod-sel.estado) @ c-estado fnStatus(tt-ord-prod-sel.ind-status-industr) @ c-status tt-ord-prod-sel.num-pedido tt-ord-prod-sel.docto-ret tt-ord-prod-sel.status-nota-ret tt-ord-prod-sel.docto-serv tt-ord-prod-sel.status-nota-serv tt-ord-prod-sel.vl-tot-nota-serv tt-ord-prod-sel.dt-emis tt-ord-prod-sel.user-calc tt-ord-prod-sel.data-reporte tt-ord-prod-sel.usuario-reporte   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-selecionadas   
&Scoped-define SELF-NAME br-selecionadas
&Scoped-define QUERY-STRING-br-selecionadas FOR EACH tt-ord-prod-sel
&Scoped-define OPEN-QUERY-br-selecionadas OPEN QUERY {&SELF-NAME} FOR EACH tt-ord-prod-sel.
&Scoped-define TABLES-IN-QUERY-br-selecionadas tt-ord-prod-sel
&Scoped-define FIRST-TABLE-IN-QUERY-br-selecionadas tt-ord-prod-sel


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-br-ordens}~
    ~{&OPEN-QUERY-br-selecionadas}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button rt-button-3 RECT-7 btSelecao ~
btAtualiza bt-exit br-ordens bt-todos bt-nenhum br-selecionadas bt-remover ~
bt-limpar bt-saldo-terc bt-faturar-nf bt-imprimir-nf bt-receber-nf bt-ok ~
bt-cancela 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescitem w-cadsim 
FUNCTION fnDescitem RETURNS CHARACTER
  ( p-it-codigo AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnEstadoOrdem w-cadsim 
FUNCTION fnEstadoOrdem RETURNS CHARACTER
  ( p-estado AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnItemPai w-cadsim 
FUNCTION fnItemPai RETURNS CHARACTER
  ( p-nr-pedido AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnSitItem w-cadsim 
FUNCTION fnSitItem RETURNS CHARACTER
  ( p-cod-sit-item AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnStatus w-cadsim 
FUNCTION fnStatus RETURNS CHARACTER
  ( p-status AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-cadsim AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-bt-ajuda 
       MENU-ITEM mi-sobre       LABEL "Sobre..."      .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "&Ajuda" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-exit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-DOWN FILE "image\ii-exi":U
     LABEL "" 
     SIZE 4 BY 1.17.

DEFINE BUTTON bt-faturar-nf 
     LABEL "Faturar NF" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-imprime 
     LABEL "&Imprimir" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-imprimir-nf 
     LABEL "Imprimir NF" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-limpar 
     LABEL "Limpar" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-nenhum 
     LABEL "Nenhum" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-receber-nf 
     LABEL "Receber NF" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-remover 
     LABEL "Remover" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-saldo-terc 
     LABEL "Saldo Terceiros" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-todos 
     LABEL "Todos" 
     SIZE 15 BY 1.13.

DEFINE BUTTON btAtualiza 
     IMAGE-UP FILE "image/im-relo.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-relo.bmp":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSelecao 
     IMAGE-UP FILE "image\im-ran":U
     IMAGE-INSENSITIVE FILE "image\ii-ran":U
     LABEL "Seleá∆o" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 169 BY 18.75.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 169 BY 1.38
     BGCOLOR 7 .

DEFINE RECTANGLE rt-button-3
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 169.29 BY 1.38
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-ordens FOR 
      tt-ord-prod SCROLLING.

DEFINE QUERY br-selecionadas FOR 
      tt-ord-prod-sel SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-ordens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-ordens w-cadsim _FREEFORM
  QUERY br-ordens DISPLAY
      tt-ord-prod.selecionada COLUMN-LABEL "*" format "*/"
      tt-ord-prod.nr-ord-prod
      tt-ord-prod.cod-estabel
      tt-ord-prod.it-codigo
      fnDescItem(tt-ord-prod.it-codigo) @ c-desc-item COLUMN-LABEL "Descriá∆o"
      tt-ord-prod.qt-ordem
      tt-ord-prod.un
      fnEstadoOrdem(tt-ord-prod.estado) @ c-estado COLUMN-LABEL "Estado"
      fnStatus(tt-ord-prod.ind-status-industr) @ c-status COLUMN-LABEL "Status Industr."
      tt-ord-prod.num-pedido COLUMN-LABEL "Pedido"
      tt-ord-prod.docto-ret COLUMN-LABEL "NF Retorno" FORMAT "X(20)"
      tt-ord-prod.status-nota-ret COLUMN-LABEL "Status NF Retorno" FORMAT "X(20)"
      tt-ord-prod.docto-serv COLUMN-LABEL "NF Serviáo" FORMAT "X(20)"
      tt-ord-prod.status-nota-serv COLUMN-LABEL "Status NF Serviáo" FORMAT "X(20)"
      tt-ord-prod.vl-tot-nota-serv
      tt-ord-prod.dt-emis COLUMN-LABEL "Data NF"
      tt-ord-prod.user-calc COLUMN-LABEL "Usu†rio NF"
      tt-ord-prod.data-reporte COLUMN-LABEL "Data Receb."
      tt-ord-prod.usuario-reporte COLUMN-LABEL "Usu†rio Receb."
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 167 BY 8
         TITLE "Ordens de Produá∆o" FIT-LAST-COLUMN.

DEFINE BROWSE br-selecionadas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-selecionadas w-cadsim _FREEFORM
  QUERY br-selecionadas DISPLAY
      tt-ord-prod-sel.nr-ord-prod
      tt-ord-prod-sel.cod-estabel
      tt-ord-prod-sel.it-codigo
      fnDescItem(tt-ord-prod-sel.it-codigo) @ c-desc-item COLUMN-LABEL "Descriá∆o"
      tt-ord-prod-sel.qt-ordem
      tt-ord-prod-sel.un
      fnEstadoOrdem(tt-ord-prod-sel.estado) @ c-estado COLUMN-LABEL "Estado"
      fnStatus(tt-ord-prod-sel.ind-status-industr) @ c-status COLUMN-LABEL "Status Industr."
      tt-ord-prod-sel.num-pedido COLUMN-LABEL "Pedido"
      tt-ord-prod-sel.docto-ret COLUMN-LABEL "NF Retorno" FORMAT "X(20)"
      tt-ord-prod-sel.status-nota-ret COLUMN-LABEL "Status NF Retorno" FORMAT "X(20)"
      tt-ord-prod-sel.docto-serv COLUMN-LABEL "NF Serviáo" FORMAT "X(20)"
      tt-ord-prod-sel.status-nota-serv COLUMN-LABEL "Status NF Serviáo" FORMAT "X(20)"
      tt-ord-prod-sel.vl-tot-nota-serv
      tt-ord-prod-sel.dt-emis COLUMN-LABEL "Data NF"
      tt-ord-prod-sel.user-calc COLUMN-LABEL "Usu†rio NF"
      tt-ord-prod-sel.data-reporte COLUMN-LABEL "Data Receb."
      tt-ord-prod-sel.usuario-reporte COLUMN-LABEL "Usu†rio Receb."
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 167 BY 7
         TITLE "Selecionadas" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     btSelecao AT ROW 1.13 COL 2.14 HELP
          "Seleá∆o" WIDGET-ID 176
     btAtualiza AT ROW 1.13 COL 6 HELP
          "Atualizar" WIDGET-ID 160
     bt-exit AT ROW 1.17 COL 166.29 WIDGET-ID 178
     br-ordens AT ROW 2.75 COL 3 WIDGET-ID 200
     bt-todos AT ROW 11 COL 3 WIDGET-ID 196
     bt-nenhum AT ROW 11 COL 18.86 WIDGET-ID 198
     br-selecionadas AT ROW 12.25 COL 3 WIDGET-ID 300
     bt-remover AT ROW 19.67 COL 3 WIDGET-ID 202
     bt-limpar AT ROW 19.67 COL 18.86 WIDGET-ID 200
     bt-saldo-terc AT ROW 19.67 COL 56 WIDGET-ID 188
     bt-faturar-nf AT ROW 19.67 COL 72 WIDGET-ID 192
     bt-imprimir-nf AT ROW 19.67 COL 88 WIDGET-ID 190
     bt-receber-nf AT ROW 19.67 COL 104 WIDGET-ID 194
     bt-ok AT ROW 21.58 COL 2.86
     bt-cancela AT ROW 21.58 COL 13.86
     bt-imprime AT ROW 21.58 COL 24.86
     bt-ajuda AT ROW 21.58 COL 160.29
     rt-button AT ROW 21.42 COL 2
     rt-button-3 AT ROW 1.04 COL 1.72 WIDGET-ID 180
     RECT-7 AT ROW 2.5 COL 2 WIDGET-ID 182
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 170.72 BY 21.92 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-ord-prod T "?" NO-UNDO mgmov ord-prod
      ADDITIONAL-FIELDS:
          field selecionada as log
          field ind-status-industr as int
          field num-pedido as int
          field docto-ret as char
          field docto-serv as char
          field status-nota-ret as char
          field status-nota-serv as char
          field vl-tot-nota-serv like nota-fiscal.vl-tot-nota
          field dt-emis like nota-fiscal.dt-emis
          field user-calc like nota-fiscal.user-calc
          field data-reporte like rep-prod.data
          field usuario-reporte like rep-prod.usuario
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-cadsim ASSIGN
         HIDDEN             = YES
         TITLE              = "Manutená∆o <Insira o complemento>"
         HEIGHT             = 22.08
         WIDTH              = 170.43
         MAX-HEIGHT         = 29.13
         MAX-WIDTH          = 177.72
         VIRTUAL-HEIGHT     = 29.13
         VIRTUAL-WIDTH      = 177.72
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
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME L-To-R                                                    */
/* BROWSE-TAB br-ordens bt-exit f-cad */
/* BROWSE-TAB br-selecionadas bt-nenhum f-cad */
/* SETTINGS FOR BUTTON bt-ajuda IN FRAME f-cad
   NO-ENABLE                                                            */
ASSIGN 
       bt-ajuda:HIDDEN IN FRAME f-cad           = TRUE
       bt-ajuda:POPUP-MENU IN FRAME f-cad       = MENU POPUP-MENU-bt-ajuda:HANDLE.

/* SETTINGS FOR BUTTON bt-imprime IN FRAME f-cad
   NO-ENABLE                                                            */
ASSIGN 
       bt-imprime:HIDDEN IN FRAME f-cad           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-ordens
/* Query rebuild information for BROWSE br-ordens
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ord-prod.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-ordens */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-selecionadas
/* Query rebuild information for BROWSE br-selecionadas
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ord-prod-sel.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-selecionadas */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON END-ERROR OF w-cadsim /* Manutená∆o <Insira o complemento> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON WINDOW-CLOSE OF w-cadsim /* Manutená∆o <Insira o complemento> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-ordens
&Scoped-define SELF-NAME br-ordens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-ordens w-cadsim
ON MOUSE-SELECT-DBLCLICK OF br-ordens IN FRAME f-cad /* Ordens de Produá∆o */
DO: 
   ASSIGN tt-ord-prod.selecionada = NOT tt-ord-prod.selecionada.

   DISPLAY tt-ord-prod.selecionada WITH BROWSE br-ordens.

   IF tt-ord-prod.selecionada THEN DO:
       FIND FIRST tt-ord-prod-sel
            WHERE tt-ord-prod-sel.nr-ord-prod = tt-ord-prod.nr-ord-prod NO-ERROR.

       IF NOT AVAIL tt-ord-prod-sel THEN DO:
           CREATE tt-ord-prod-sel.        
           BUFFER-COPY tt-ord-prod TO tt-ord-prod-sel.
       END.
   END.
   ELSE DO:
       FIND FIRST tt-ord-prod-sel
            WHERE tt-ord-prod-sel.nr-ord-prod = tt-ord-prod.nr-ord-prod NO-ERROR.

       IF AVAIL tt-ord-prod-sel THEN
           DELETE tt-ord-prod-sel.
   END.

   {&open-query-br-selecionadas}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-ordens w-cadsim
ON ROW-DISPLAY OF br-ordens IN FRAME f-cad /* Ordens de Produá∆o */
DO:
    IF tt-ord-prod.ind-status-industr = 1 THEN DO:                               
        ASSIGN tt-ord-prod.selecionada:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
               tt-ord-prod.nr-ord-prod:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
               tt-ord-prod.cod-estabel:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
               tt-ord-prod.it-codigo  :FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
               c-desc-item            :FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
               tt-ord-prod.qt-ordem   :FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
               tt-ord-prod.un         :FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
               c-estado               :FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
               c-status               :FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
               tt-ord-prod.num-pedido :FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
               tt-ord-prod.docto-ret  :FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
               tt-ord-prod.docto-serv :FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
               tt-ord-prod.status-nota-ret :FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
               tt-ord-prod.status-nota-serv:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9 
               tt-ord-prod.vl-tot-nota-serv:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9 
               tt-ord-prod.dt-emis         :FGCOLOR IN BROWSE {&BROWSE-NAME} = 9 
               tt-ord-prod.user-calc       :FGCOLOR IN BROWSE {&BROWSE-NAME} = 9 
               tt-ord-prod.data-reporte    :FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
               tt-ord-prod.usuario-reporte :FGCOLOR IN BROWSE {&BROWSE-NAME} = 9.
            

               
    END.
    ELSE IF tt-ord-prod.ind-status-industr = 2 THEN DO:                               
        ASSIGN tt-ord-prod.selecionada:FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
               tt-ord-prod.nr-ord-prod:FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
               tt-ord-prod.cod-estabel:FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
               tt-ord-prod.it-codigo  :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
               c-desc-item            :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2 
               tt-ord-prod.qt-ordem   :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2 
               tt-ord-prod.un         :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2 
               c-estado               :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2 
               c-status               :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2 
               tt-ord-prod.num-pedido :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2 
               tt-ord-prod.docto-ret  :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2 
               tt-ord-prod.docto-serv :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
               tt-ord-prod.status-nota-ret :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
               tt-ord-prod.status-nota-serv:FGCOLOR IN BROWSE {&BROWSE-NAME} = 2 
               tt-ord-prod.vl-tot-nota-serv:FGCOLOR IN BROWSE {&BROWSE-NAME} = 2 
               tt-ord-prod.dt-emis         :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2 
               tt-ord-prod.user-calc       :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2 
               tt-ord-prod.data-reporte    :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
               tt-ord-prod.usuario-reporte :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2. 


               
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-selecionadas
&Scoped-define SELF-NAME br-selecionadas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-selecionadas w-cadsim
ON MOUSE-SELECT-DBLCLICK OF br-selecionadas IN FRAME f-cad /* Selecionadas */
DO:
    APPLY "choose" TO bt-remover.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-selecionadas w-cadsim
ON ROW-DISPLAY OF br-selecionadas IN FRAME f-cad /* Selecionadas */
DO:
    IF tt-ord-prod-sel.ind-status-industr = 1 THEN DO:                               
        ASSIGN tt-ord-prod-sel.nr-ord-prod:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
               tt-ord-prod-sel.cod-estabel:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
               tt-ord-prod-sel.it-codigo  :FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
               c-desc-item            :FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
               tt-ord-prod-sel.qt-ordem   :FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
               tt-ord-prod-sel.un         :FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
               c-estado               :FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
               c-status               :FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
               tt-ord-prod-sel.num-pedido :FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
               tt-ord-prod-sel.docto-ret  :FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
               tt-ord-prod-sel.docto-serv :FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
               tt-ord-prod-sel.status-nota-ret :FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
               tt-ord-prod-sel.status-nota-serv:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9 
               tt-ord-prod-sel.vl-tot-nota-serv:FGCOLOR IN BROWSE {&BROWSE-NAME} = 9 
               tt-ord-prod-sel.dt-emis         :FGCOLOR IN BROWSE {&BROWSE-NAME} = 9 
               tt-ord-prod-sel.user-calc       :FGCOLOR IN BROWSE {&BROWSE-NAME} = 9 
               tt-ord-prod-sel.data-reporte    :FGCOLOR IN BROWSE {&BROWSE-NAME} = 9
               tt-ord-prod-sel.usuario-reporte :FGCOLOR IN BROWSE {&BROWSE-NAME} = 9.
            

               
    END.
    ELSE IF tt-ord-prod-sel.ind-status-industr = 2 THEN DO:                               
        ASSIGN tt-ord-prod-sel.nr-ord-prod:FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
               tt-ord-prod-sel.cod-estabel:FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
               tt-ord-prod-sel.it-codigo  :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
               c-desc-item            :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2 
               tt-ord-prod-sel.qt-ordem   :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2 
               tt-ord-prod-sel.un         :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2 
               c-estado               :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2 
               c-status               :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2 
               tt-ord-prod-sel.num-pedido :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2 
               tt-ord-prod-sel.docto-ret  :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2 
               tt-ord-prod-sel.docto-serv :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
               tt-ord-prod-sel.status-nota-ret :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
               tt-ord-prod-sel.status-nota-serv:FGCOLOR IN BROWSE {&BROWSE-NAME} = 2 
               tt-ord-prod-sel.vl-tot-nota-serv:FGCOLOR IN BROWSE {&BROWSE-NAME} = 2 
               tt-ord-prod-sel.dt-emis         :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2 
               tt-ord-prod-sel.user-calc       :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2 
               tt-ord-prod-sel.data-reporte    :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
               tt-ord-prod-sel.usuario-reporte :FGCOLOR IN BROWSE {&BROWSE-NAME} = 2. 


               
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-cadsim
ON CHOOSE OF bt-ajuda IN FRAME f-cad /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela w-cadsim
ON CHOOSE OF bt-cancela IN FRAME f-cad /* Cancelar */
DO:
  RUN notify ('cancel-record':U).
  APPLY "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-exit w-cadsim
ON CHOOSE OF bt-exit IN FRAME f-cad
DO:
  APPLY "close" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-faturar-nf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-faturar-nf w-cadsim
ON CHOOSE OF bt-faturar-nf IN FRAME f-cad /* Faturar NF */
DO:
    DEFINE VARIABLE c-arquivo AS CHARACTER   NO-UNDO.

    EMPTY TEMP-TABLE tt-resultado-fatura-nf.

    IF NOT CAN-FIND (FIRST tt-ord-prod-sel) THEN DO:
        
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Selecione pelo menos uma Ordem de Produá∆o").
    
        RETURN "NOK".
     END.
     ELSE DO:
    
         IF CAN-FIND (FIRST tt-ord-prod-sel
                      WHERE tt-ord-prod-sel.ind-status-indust <> 0) THEN DO:
    
             RUN utp/ut-msgs.p (INPUT "show",
                                INPUT 17006,
                                INPUT "Selecione apenas ordens n∆o iniciada.").
    
             RETURN "NOK".
         END.

         FOR EACH tt-ord-prod-sel:

             IF tt-ord-prod-sel.l-fatura-nf = YES THEN do:
                
                 RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                    INPUT 17006,
                                    INPUT "OP: " + string(tt-ord-prod-sel.nr-ord-prod) + " ! ~~ " +
                                          " ja enviada para a Neogrid, favor aguardar o retorno").                 
                 NEXT.
             END.

             FIND FIRST int-ord-prod-monitor NO-LOCK
                  WHERE int-ord-prod-monitor.nr-ord-produ = tt-ord-prod-sel.nr-ord-produ NO-ERROR.
           
             //Nota ja emitida para a ordem de producao
             FIND FIRST docum-est NO-LOCK
                  WHERE ROWID(docum-est) = TO-ROWID(int-ord-prod-monitor.r-docum-est-serv) NO-ERROR.
           
             FIND FIRST nota-fiscal NO-LOCK
                  WHERE nota-fiscal.cod-estabel = docum-est.cod-estabel
                    AND nota-fiscal.nr-nota-fis = docum-est.nro-docto
                    AND nota-fiscal.serie       = docum-est.serie-docto NO-ERROR.
             IF AVAIL nota-fiscal THEN DO:
               
                 RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                    INPUT 17006,
                                    INPUT "OP: " + string(tt-ord-prod-sel.nr-ord-prod) + " ! ~~ " +
                                          " ja gerada a nota fiscal " + nota-fiscal.nr-nota-fis + " serie " + nota-fiscal.serie).          
                 NEXT.
             END.
            
             RUN esp/cpp/escpp108c.p (INPUT tt-ord-prod-sel.nr-ord-prod,
                                      OUTPUT TABLE tt-erro-faturar-nf).
            
             CREATE tt-resultado-fatura-nf.
             ASSIGN tt-resultado-fatura-nf.nr-ord-prod = tt-ord-prod-sel.nr-ord-prod.

             IF CAN-FIND (FIRST tt-erro-faturar-nf) THEN DO:
                 FOR EACH tt-erro-faturar-nf:
                     IF tt-resultado-fatura-nf.erros = "" THEN
                        ASSIGN tt-resultado-fatura-nf.erros = tt-erro-faturar-nf.mensagem.
                     ELSE 
                        ASSIGN tt-resultado-fatura-nf.erros = tt-resultado-fatura-nf.erros + " - " +  tt-erro-faturar-nf.mensagem.
                 END.
                 ASSIGN tt-ord-prod-sel.l-fatura-nf = NO. //nao grava yes se retornar tt com erro
             END.
             ELSE
                 ASSIGN tt-ord-prod-sel.l-fatura-nf = YES.
         END.

         ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "escpp108_faturar_nf_" + STRING(TIME) + ".csv".
         OUTPUT TO VALUE(c-arquivo) NO-CONVERT.

         PUT UNFORMATTED "Ordem de Produá∆o;Pedido;Nota de Serviáo;Nota de Retorno;Erros" SKIP.
         FOR EACH tt-resultado-fatura-nf:
             PUT UNFORMATTED string(tt-resultado-fatura-nf.nr-ord-prod) + ";".

             /*se n∆o deu erro imprime pedido e notas*/
             IF tt-resultado-fatura-nf.erros <> "" THEN
                 PUT UNFORMATTED ";;;".
             ELSE DO:
                 FIND FIRST int-ord-prod-monitor NO-LOCK
                      WHERE int-ord-prod-monitor.nr-ord-prod = tt-resultado-fatura-nf.nr-ord-prod NO-ERROR.

                 PUT UNFORMATTED STRING(int-ord-prod-monitor.num-pedido) + ";" .

                 /*Nota serviáo*/
                 FIND FIRST docum-est NO-LOCK
                      WHERE ROWID(docum-est) = TO-ROWID(int-ord-prod-monitor.r-docum-est-serv) NO-ERROR.

                 IF AVAIL docum-est THEN
                     PUT UNFORMATTED docum-est.nro-docto + "/" + docum-est.serie-docto + ";" .
                 ELSE 
                     PUT UNFORMATTED ";" .

                 /*Nota retorno*/
                 FIND FIRST docum-est NO-LOCK
                      WHERE ROWID(docum-est) = TO-ROWID(int-ord-prod-monitor.r-docum-est-ret) NO-ERROR.

                 IF AVAIL docum-est THEN
                     PUT UNFORMATTED docum-est.nro-docto + "/" + docum-est.serie-docto + ";" .
                 ELSE 
                     PUT UNFORMATTED ";" .
             END.

             PUT UNFORMATTED tt-resultado-fatura-nf.erros SKIP.
         END.
         OUTPUT CLOSE.

         DOS SILENT START excel VALUE(c-arquivo).
     END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-imprime
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-imprime w-cadsim
ON CHOOSE OF bt-imprime IN FRAME f-cad /* Imprimir */
DO:
run utp/ut-relat.w persistent set wh-imprime (input c-programa-mg97).
if valid-handle(wh-imprime) then
  run dispatch in wh-imprime ('initialize':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-imprimir-nf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-imprimir-nf w-cadsim
ON CHOOSE OF bt-imprimir-nf IN FRAME f-cad /* Imprimir NF */
DO:
    IF NOT CAN-FIND (FIRST tt-ord-prod-sel) THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Selecione pelo menos uma Ordem de Produá∆o").

        RETURN "NOK".
    END.
    ELSE DO:
/*         FIND FIRST nota-fiscal NO-LOCK                 */
/*              WHERE nota-fiscal.nr-nota-fis = "1169076" */
/*                AND nota-fiscal.serie = "1" NO-ERROR.   */

        IF CAN-FIND (FIRST tt-ord-prod-sel
                     WHERE tt-ord-prod-sel.ind-status-indust <> 1) THEN DO:

            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "Selecione apenas ordens Faturadas.").

            RETURN "NOK".
        END.
         
        EMPTY TEMP-TABLE tt-param-aux.
        EMPTY TEMP-TABLE tt-digita-aux.

        FOR EACH tt-ord-prod-sel:

            FIND FIRST int-ord-prod-monitor NO-LOCK
                 WHERE int-ord-prod-monitor.nr-ord-prod = tt-ord-prod-sel.nr-ord-prod NO-ERROR.

            FIND FIRST docum-est NO-LOCK
                 WHERE ROWID(docum-est) = TO-ROWID(int-ord-prod-monitor.r-docum-est-ret) NO-ERROR.

            FIND FIRST nota-fiscal NO-LOCK
                 WHERE nota-fiscal.cod-estabel = docum-est.cod-estabel
                   AND nota-fiscal.nr-nota-fis = docum-est.nro-docto
                   AND nota-fiscal.serie       = docum-est.serie-docto NO-ERROR.

            IF nota-fiscal.idi-sit-nf-eletro <> 3 /*Uso Autorizado*/ THEN DO:
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "Selecione apenas notas com Uso Autorizado.").

                RETURN "NOK".
            END.

            FIND FIRST docum-est NO-LOCK
                 WHERE ROWID(docum-est) = TO-ROWID(int-ord-prod-monitor.r-docum-est-serv) NO-ERROR.

            FIND FIRST b-nota-fiscal NO-LOCK
                 WHERE b-nota-fiscal.cod-estabel = docum-est.cod-estabel
                   AND b-nota-fiscal.nr-nota-fis = docum-est.nro-docto
                   AND b-nota-fiscal.serie       = docum-est.serie-docto NO-ERROR.

            IF b-nota-fiscal.idi-sit-nf-eletro <> 3 /*Uso Autorizado*/ THEN DO:
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "Selecione apenas notas com Uso Autorizado.").

                RETURN "NOK".
            END.
            
            IF NOT CAN-FIND (FIRST tt-param-aux) THEN DO:
                CREATE tt-param-aux.
                ASSIGN tt-param-aux.usuario              = c-seg-usuario
                       tt-param-aux.destino              = 3 /*Terminal*/
                       tt-param-aux.data-exec            = today
                       tt-param-aux.hora-exec            = time
                       tt-param-aux.ep-codigo            = i-ep-codigo-usuario
                       tt-param-aux.da-dt-saida          = TODAY
                       tt-param-aux.c-hr-saida           = string(TIME,"hh:mm:ss")
                       tt-param-aux.nr-copias            = 1
                       tt-param-aux.imprime-bloq         = NO
                       tt-param-aux.rs-imprime           = 3
                       tt-param-aux.impressora-so        = ""
                       tt-param-aux.impressora-so-bloq   = ''
                       tt-param-aux.l-gera-danfe-xml     = NO
                       tt-param-aux.c-dir-hist-xml       = ""
                       tt-param-aux.ind-execucao         = 1. /*online*/
            
                FIND FIRST ser-estab NO-LOCK
                     WHERE ser-estab.cod-estabel  = nota-fiscal.cod-estabel
                       AND ser-estab.serie        = nota-fiscal.serie NO-ERROR.
                
                IF  AVAIL ser-estab THEN DO:
            
                    IF &if "{&bf_dis_versao_ems}"  >=  "2.07":U &then
                           ser-estab.idi-format-emis-danfe = 1 OR 
                           ser-estab.idi-format-emis-danfe = 2 
                       &else
                           INT(SUBSTRING(ser-estab.char-1,4,01)) = 1 OR
                           INT(SUBSTRING(ser-estab.char-1,4,01)) = 2  
                       &endif
                    THEN DO:
                       run utp/ut-msgs.p (input "show",
                                           INPUT 52042,
                                           input "").
                    end.
            
                    &if "{&bf_dis_versao_ems}"  >=  "2.07":U &then
                       IF ser-estab.idi-format-emis-danfe = 1 THEN
                            ASSIGN tt-param-aux.cod-layout = "DANFE-Mod.1":U.
                       ELSE
                           IF ser-estab.idi-format-emis-danfe = 2 THEN
                                ASSIGN tt-param-aux.cod-layout = "DANFE-Mod.2":U.
                    &else
                       IF INT(SUBSTRING(ser-estab.char-1,4,01)) = 1 THEN
                           ASSIGN tt-param-aux.cod-layout = "DANFE-Mod.1":U.
                       ELSE
                           IF INT(SUBSTRING(ser-estab.char-1,4,01)) = 2 THEN
                               ASSIGN tt-param-aux.cod-layout = "DANFE-Mod.2":U.
                   &endif
                END.
            
                IF tt-param-aux.cod-layout = "" THEN
                   ASSIGN tt-param-aux.cod-layout = "DANFE-Mod.1":U.
            
                
                IF NOT CAN-FIND(FIRST funcao NO-LOCK
                    WHERE funcao.cd-funcao = "spp-danfe":U
                    AND   funcao.ativo) THEN
                    assign tt-param-aux.arquivo = session:temp-directory + "FT0527":U + REPLACE(STRING(TODAY,"99/99/99"),"/","") + REPLACE(STRING(TIME,"HH:MM:SS"),":","") + "." + "pdf".
                ELSE
                    assign tt-param-aux.arquivo = session:temp-directory + "FT0527":U + REPLACE(STRING(TODAY,"99/99/99"),"/","") + REPLACE(STRING(TIME,"HH:MM:SS"),":","") + string(RANDOM(1,9999999)) + "." + "pdf".

                
                ASSIGN raw-param = ?.
                raw-transfer tt-param-aux to raw-param.
            END.
        
            /**Cria tt-digita-aux**/
            CREATE tt-digita-aux.            
            ASSIGN tt-digita-aux.cod-estabel = nota-fiscal.cod-estabel 
                   tt-digita-aux.serie       = nota-fiscal.serie      
                   tt-digita-aux.nr-nota-fis = nota-fiscal.nr-nota-fis
                   tt-digita-aux.cdd-embarq  = nota-fiscal.cdd-embarq.

            CREATE tt-digita-aux.            
            ASSIGN tt-digita-aux.cod-estabel = b-nota-fiscal.cod-estabel 
                   tt-digita-aux.serie       = b-nota-fiscal.serie      
                   tt-digita-aux.nr-nota-fis = b-nota-fiscal.nr-nota-fis
                   tt-digita-aux.cdd-embarq  = b-nota-fiscal.cdd-embarq.
        
            EMPTY TEMP-TABLE tt-raw-digita.
            FOR EACH tt-digita-aux:
                CREATE tt-raw-digita.
                RAW-TRANSFER tt-digita-aux to tt-raw-digita.raw-digita.
            END. 
        END.

        RUN esp/ftp/esftp0527rp.p (INPUT raw-param, INPUT TABLE tt-raw-digita).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-limpar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-limpar w-cadsim
ON CHOOSE OF bt-limpar IN FRAME f-cad /* Limpar */
DO:
    FOR EACH tt-ord-prod-sel:
        FIND FIRST tt-ord-prod
             WHERE tt-ord-prod.nr-ord-prod = tt-ord-prod-sel.nr-ord-prod NO-ERROR.

        IF AVAIL tt-ord-prod THEN
            ASSIGN tt-ord-prod.selecionada = NO.

        DELETE tt-ord-prod-sel.
    END.

    br-ordens:REFRESH().
    {&open-query-br-selecionadas}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-nenhum
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-nenhum w-cadsim
ON CHOOSE OF bt-nenhum IN FRAME f-cad /* Nenhum */
DO:
   FOR EACH tt-ord-prod:
       ASSIGN tt-ord-prod.selecionada = NO.

       FIND FIRST tt-ord-prod-sel
            WHERE tt-ord-prod-sel.nr-ord-prod = tt-ord-prod.nr-ord-prod NO-ERROR.

       IF AVAIL tt-ord-prod-sel THEN DO:
           DELETE tt-ord-prod-sel.
       END.
   END.

   br-ordens:REFRESH().
   {&open-query-br-selecionadas}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-cadsim
ON CHOOSE OF bt-ok IN FRAME f-cad /* OK */
DO:
  RUN notify ('update-record':U).
  if return-value <> "adm-error":U then
     apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-receber-nf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-receber-nf w-cadsim
ON CHOOSE OF bt-receber-nf IN FRAME f-cad /* Receber NF */
DO:
    DEFINE VARIABLE c-arquivo AS CHARACTER   NO-UNDO.

    EMPTY TEMP-TABLE tt-resultado-receber-nf.

    IF NOT CAN-FIND (FIRST tt-ord-prod-sel) THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Selecione pelo menos uma Ordem de Produá∆o").

        RETURN "NOK".
    END.
    ELSE DO:

        IF CAN-FIND (FIRST tt-ord-prod-sel
                     WHERE tt-ord-prod-sel.ind-status-indust <> 1) THEN DO:

            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "Selecione apenas ordens Faturadas.").

            RETURN "NOK".
        END.


        /*Valida Situaá∆o da nota*/
        FOR EACH tt-ord-prod-sel:

            FIND FIRST int-ord-prod-monitor NO-LOCK
                 WHERE int-ord-prod-monitor.nr-ord-prod = tt-ord-prod-sel.nr-ord-prod NO-ERROR.

            FIND FIRST docum-est NO-LOCK
                 WHERE ROWID(docum-est) = TO-ROWID(int-ord-prod-monitor.r-docum-est-ret) NO-ERROR.

            FIND FIRST nota-fiscal NO-LOCK
                 WHERE nota-fiscal.cod-estabel = docum-est.cod-estabel
                   AND nota-fiscal.nr-nota-fis = docum-est.nro-docto
                   AND nota-fiscal.serie       = docum-est.serie-docto NO-ERROR.

            IF NOT AVAIL nota-fiscal
            OR nota-fiscal.idi-sit-nf-eletro <> 3 /*Uso Autorizado*/ THEN DO:
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "Selecione apenas notas com Uso Autorizado.").

                RETURN "NOK".
            END.

            FIND FIRST docum-est NO-LOCK
                 WHERE ROWID(docum-est) = TO-ROWID(int-ord-prod-monitor.r-docum-est-serv) NO-ERROR.

            FIND FIRST b-nota-fiscal NO-LOCK
                 WHERE b-nota-fiscal.cod-estabel = docum-est.cod-estabel
                   AND b-nota-fiscal.nr-nota-fis = docum-est.nro-docto
                   AND b-nota-fiscal.serie       = docum-est.serie-docto NO-ERROR.

            IF NOT AVAIL b-nota-fiscal
            OR b-nota-fiscal.idi-sit-nf-eletro <> 3 /*Uso Autorizado*/ THEN DO:
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "Selecione apenas notas com Uso Autorizado.").

                RETURN "NOK".
            END.

            IF tt-ord-prod-sel.estado <> 5 THEN DO:
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "Selecione apenas ordens com estado Requisitada.").

                RETURN "NOK".

            END.
        END.

        FOR EACH tt-ord-prod-sel:

            RUN pi-reporta-ordem (INPUT tt-ord-prod-sel.nr-ord-prod).

            CREATE tt-resultado-receber-nf.
            ASSIGN tt-resultado-receber-nf.nr-ord-prod = tt-ord-prod-sel.nr-ord-prod.

            FOR EACH tt-erro-reporte:
                IF tt-resultado-receber-nf.erros = "" THEN
                   ASSIGN tt-resultado-receber-nf.erros = tt-erro-reporte.mensagem.
                ELSE 
                   ASSIGN tt-resultado-receber-nf.erros = tt-resultado-receber-nf.erros + " - " +  tt-erro-reporte.mensagem.
            END.

            IF tt-resultado-receber-nf.erros = "" THEN
                ASSIGN tt-resultado-receber-nf.erros = "Sucesso".
        END.

        ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "escpp108_receber_nf_" + STRING(TIME) + ".csv".
        OUTPUT TO VALUE(c-arquivo) NO-CONVERT.

        PUT UNFORMATTED "Ordem de Produá∆o;Erros" SKIP.

        FOR EACH tt-resultado-receber-nf:
            PUT UNFORMATTED string(tt-resultado-receber-nf.nr-ord-prod) + ";"
                            tt-resultado-receber-nf.erros SKIP.

        END.

        OUTPUT CLOSE.

        DOS SILENT START excel VALUE(c-arquivo).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-remover
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-remover w-cadsim
ON CHOOSE OF bt-remover IN FRAME f-cad /* Remover */
DO:
    IF AVAIL tt-ord-prod-sel THEN DO:
        FIND FIRST tt-ord-prod
             WHERE tt-ord-prod.nr-ord-prod = tt-ord-prod-sel.nr-ord-prod NO-ERROR.

        IF AVAIL tt-ord-prod THEN
            ASSIGN tt-ord-prod.selecionada = NO.

        DELETE tt-ord-prod-sel.
    END.

    br-ordens:REFRESH().
    {&open-query-br-selecionadas}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-saldo-terc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-saldo-terc w-cadsim
ON CHOOSE OF bt-saldo-terc IN FRAME f-cad /* Saldo Terceiros */
DO:
    IF NOT CAN-FIND (FIRST tt-ord-prod-sel) THEN DO:

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Selecione pelo menos uma Ordem de Produá∆o").

        RETURN "NOK".
    END.
    ELSE DO:

        IF CAN-FIND (FIRST tt-ord-prod-sel
                     WHERE tt-ord-prod-sel.ind-status-indust <> 0) THEN DO:
    
             RUN utp/ut-msgs.p (INPUT "show",
                                INPUT 17006,
                                INPUT "Selecione apenas ordens n∆o iniciada.").
    
             RETURN "NOK".
         END.

        EMPTY TEMP-TABLE tt-param-rpa.
        EMPTY TEMP-TABLE tt-digita-rpa.
        EMPTY TEMP-TABLE tt-raw-digita.

        create tt-param-rpa.
        assign tt-param-rpa.usuario         = c-seg-usuario
               tt-param-rpa.destino         = 2
               tt-param-rpa.data-exec       = today
               tt-param-rpa.hora-exec       = time
               tt-param-rpa.arquivo         = SESSION:TEMP-DIRECTORY + "escpp108rpa" + STRING(TIME) + ".txt".

        FOR EACH tt-ord-prod-sel
           WHERE tt-ord-prod-sel.estado < 7:

            CREATE tt-digita-rpa.
            ASSIGN tt-digita-rpa.l-sel = YES
                   tt-digita-rpa.nr-ord-produ = tt-ord-prod-sel.nr-ord-produ.
        END.

        FOR EACH tt-digita-rpa: 
            CREATE tt-raw-digita.
            RAW-TRANSFER tt-digita-rpa TO tt-raw-digita.raw-digita.
        END.

        RAW-TRANSFER tt-param-rpa TO raw-param.

        RUN esp/cpp/escpp108rpa.p (INPUT raw-param, INPUT TABLE tt-raw-digita).

        OS-COMMAND NO-WAIT notepad VALUE(tt-param-rpa.arquivo ).
        
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-todos w-cadsim
ON CHOOSE OF bt-todos IN FRAME f-cad /* Todos */
DO:
   FOR EACH tt-ord-prod:
       ASSIGN tt-ord-prod.selecionada = YES.

       IF NOT CAN-FIND (FIRST tt-ord-prod-sel
                        WHERE tt-ord-prod-sel.nr-ord-prod = tt-ord-prod.nr-ord-prod) THEN DO:
           CREATE tt-ord-prod-sel.
           BUFFER-COPY tt-ord-prod TO tt-ord-prod-sel.
       END.
   END.

   br-ordens:REFRESH().
   {&open-query-br-selecionadas}
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


&Scoped-define SELF-NAME btSelecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSelecao w-cadsim
ON CHOOSE OF btSelecao IN FRAME f-cad /* Seleá∆o */
DO:
   RUN esp/cpp/escpp108a.w (INPUT-OUTPUT  c-cod-estabel-ini,
                            INPUT-OUTPUT  c-cod-estabel-fim,
                            INPUT-OUTPUT  i-nr-ord-produ-ini,
                            INPUT-OUTPUT  i-nr-ord-produ-fim,
                            INPUT-OUTPUT  c-it-codigo-ini,
                            INPUT-OUTPUT  c-it-codigo-fim,
                            INPUT-OUTPUT  d-dt-faturamento-ini,
                            INPUT-OUTPUT  d-dt-faturamento-fim,
                            INPUT-OUTPUT  d-dt-recebimento-ini,
                            INPUT-OUTPUT  d-dt-recebimento-fim,
                            INPUT-OUTPUT  d-dt-emissao-ini,
                            INPUT-OUTPUT  d-dt-emissao-fim,
/*                             INPUT-OUTPUT  l-tg-nao-iniciada, */
/*                             INPUT-OUTPUT  l-tg-liberada,     */
/*                             INPUT-OUTPUT  l-tg-reservada,    */
/*                             INPUT-OUTPUT  l-tg-separada,     */
/*                             INPUT-OUTPUT  l-tg-requisitada,  */
/*                             INPUT-OUTPUT  l-tg-iniciada,     */
/*                             INPUT-OUTPUT  l-tg-finalizada,   */
/*                             INPUT-OUTPUT  l-tg-terminada,    */
                            INPUT-OUTPUT  l-tg-status-0, 
                            INPUT-OUTPUT  l-tg-status-1, 
                            INPUT-OUTPUT  l-tg-status-2, 
                            OUTPUT l-openquery).

   IF l-openquery THEN
        RUN pi-carrega.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-cadsim
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-ordens
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
  ENABLE rt-button rt-button-3 RECT-7 btSelecao btAtualiza bt-exit br-ordens 
         bt-todos bt-nenhum br-selecionadas bt-remover bt-limpar bt-saldo-terc 
         bt-faturar-nf bt-imprimir-nf bt-receber-nf bt-ok bt-cancela 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
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
  DEFINE VARIABLE l-habilita-receber-NF AS LOGICAL     NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}

  {utp/ut9000.i "escpp108" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  RUN esp/es0018p.p (INPUT "escpp108":U,
                     INPUT 2,
                     INPUT 0,
                     INPUT "":U,
                     OUTPUT TABLE tt-prog-ponto).
  
  FOR EACH tt-prog-ponto:
      IF CAN-FIND (FIRST usuar_grp_usuar
                   WHERE usuar_grp_usuar.cod_grp_usuar = tt-prog-ponto.conteudo
                     AND usuar_grp_usuar.cod_usuar     = c-seg-usuario) THEN DO:

          ASSIGN l-habilita-receber-NF = YES.
          LEAVE.
      END.
  END.

  ASSIGN bt-receber-nf:SENSITIVE IN FRAME {&FRAME-NAME} = l-habilita-receber-NF.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN dispatch  IN this-procedure ('enable-fields':U).

  {include/i-inifld.i}

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
DEFINE VARIABLE l-next      AS LOGICAL NO-UNDO.
DEFINE VARIABLE data-inicio AS DATE    NO-UNDO.


EMPTY TEMP-TABLE tt-ord-prod.   

run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp (input 'Carregando').

RUN esp/es0018p.p (INPUT "escpp108":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

FIND FIRST tt-prog-ponto. 

ASSIGN data-inicio = DATE(tt-prog-ponto.conteudo).

RUN esp/es0018p.p (INPUT "escpp108":U,
                   INPUT 3,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

FOR EACH tt-prog-ponto:
    FOR EACH ord-prod
       WHERE ord-prod.nr-linha = INT(tt-prog-ponto.conteudo)
         AND ord-prod.tipo = 1
         AND ord-prod.cod-estabel  >= c-cod-estabel-ini
         AND ord-prod.cod-estabel  <= c-cod-estabel-fim
         AND ord-prod.nr-ord-produ >= i-nr-ord-produ-ini
         AND ord-prod.nr-ord-produ <= i-nr-ord-produ-fim
         AND ord-prod.it-codigo >= c-it-codigo-ini
         AND ord-prod.it-codigo <= c-it-codigo-fim
         AND ord-prod.dt-inicio >= data-inicio
         AND ord-prod.dt-emissao >= d-dt-emissao-ini
         AND ord-prod.dt-emissao <= d-dt-emissao-fim NO-LOCK:
    
    /*     d-dt-faturamento-ini, */
    /*  d-dt-faturamento-fim,    */
    /*  d-dt-recebimento-ini,    */
    /*  d-dt-recebimento-fim,    */
    /*                                  */
    /*     IF  NOT l-tg-nao-iniciada    */
    /*     AND ord-prod.estado = 1 THEN */
    /*         NEXT.                    */
    /*                                  */
    /*     IF  NOT l-tg-liberada        */
    /*     AND ord-prod.estado = 2 THEN */
    /*         NEXT.                    */
    /*                                  */
    /*     IF  NOT l-tg-reservada       */
    /*     AND ord-prod.estado = 3 THEN */
    /*         NEXT.                    */
    /*                                  */
    /*     IF  NOT l-tg-separada        */
    /*     AND ord-prod.estado = 4 THEN */
    /*         NEXT.                    */
    /*                                  */
    /*     IF  NOT l-tg-requisitada     */
    /*     AND ord-prod.estado = 5 THEN */
    /*         NEXT.                    */
    /*                                  */
    /*     IF  NOT l-tg-iniciada        */
    /*     AND ord-prod.estado = 6 THEN */
    /*         NEXT.                    */
    /*                                  */
    /*     IF  NOT l-tg-finalizada      */
    /*     AND ord-prod.estado = 7 THEN */
    /*         NEXT.                    */
    /*                                  */
    /*     IF  NOT l-tg-terminada       */
    /*     AND ord-prod.estado = 8 THEN */
    /*         NEXT.                    */
    
        FIND FIRST int-ord-prod-monitor NO-LOCK
             WHERE int-ord-prod-monitor.nr-ord-produ = ord-prod.nr-ord-produ NO-ERROR.
        
        /*Filtro data faturamento*/
        FIND FIRST docum-est NO-LOCK
             WHERE ROWID(docum-est) = TO-ROWID(int-ord-prod-monitor.r-docum-est-serv) NO-ERROR.
    
        FIND FIRST nota-fiscal NO-LOCK
             WHERE nota-fiscal.cod-estabel = docum-est.cod-estabel
               AND nota-fiscal.nr-nota-fis = docum-est.nro-docto
               AND nota-fiscal.serie       = docum-est.serie-docto NO-ERROR.
    
        IF  AVAIL nota-fiscal
        AND (nota-fiscal.dt-emis < d-dt-faturamento-ini OR nota-fiscal.dt-emis > d-dt-faturamento-fim) THEN
            NEXT.
    
        IF NOT l-tg-status-0
        AND (NOT AVAIL int-ord-prod-monitor OR int-ord-prod-monitor.ind-status-industr = 0) THEN
            NEXT.
    
        IF  NOT l-tg-status-1
        AND AVAIL int-ord-prod-monitor 
        AND int-ord-prod-monitor.ind-status-industr = 1 THEN
            NEXT.
    
        IF  NOT l-tg-status-2
        AND AVAIL int-ord-prod-monitor 
        AND int-ord-prod-monitor.ind-status-industr = 2 THEN
            NEXT.
    
        /*Filtro recebimento*/
        ASSIGN l-next = NO.
        FOR LAST ord-rep NO-LOCK
           WHERE ord-rep.nr-ord-prod = ord-prod.nr-ord-prod:
    
            FIND FIRST rep-prod NO-LOCK
                 WHERE rep-prod.nr-reporte = ord-rep.nr-reporte NO-ERROR.
    
            IF rep-prod.data < d-dt-recebimento-ini 
            OR rep-prod.data > d-dt-recebimento-fim THEN
                ASSIGN l-next = YES.
        END.
    
        IF l-next THEN
            NEXT.
    
        RUN pi-acompanhar IN h-acomp (INPUT 'Carregando ordem: ' + STRING(ord-prod.nr-ord-produ)).
    
        CREATE tt-ord-prod.
        BUFFER-COPY ord-prod TO tt-ord-prod.
    
        ASSIGN tt-ord-prod.dt-emis = ?.
        IF AVAIL int-ord-prod-monitor THEN DO:
            ASSIGN tt-ord-prod.num-pedido  = int-ord-prod-monitor.num-pedido
    /*                tt-ord-prod.docto-ret   = int-ord-prod-monitor.nro-docto-ret  + "/" + int-ord-prod-monitor.serie-docto-ret  */
    /*                tt-ord-prod.docto-serv  = int-ord-prod-monitor.nro-docto-serv + "/" + int-ord-prod-monitor.serie-docto-serv */
                   tt-ord-prod.ind-status-industr = int-ord-prod-monitor.ind-status-industr.
    
            FIND FIRST docum-est NO-LOCK
                 WHERE ROWID(docum-est) = TO-ROWID(int-ord-prod-monitor.r-docum-est-ret) NO-ERROR.
    
            FIND FIRST nota-fiscal NO-LOCK
                 WHERE nota-fiscal.cod-estabel = docum-est.cod-estabel
                   AND nota-fiscal.nr-nota-fis = docum-est.nro-docto
                   AND nota-fiscal.serie       = docum-est.serie-docto NO-ERROR.
    
            IF AVAIL nota-fiscal THEN
                ASSIGN tt-ord-prod.status-nota-ret = {diinc/i01di135.i 04 nota-fiscal.idi-sit-nf-eletro}.
            ELSE 
                ASSIGN tt-ord-prod.status-nota-ret = "".
    
            FIND FIRST docum-est NO-LOCK
                 WHERE ROWID(docum-est) = TO-ROWID(int-ord-prod-monitor.r-docum-est-serv) NO-ERROR.
    
            FIND FIRST nota-fiscal NO-LOCK
                 WHERE nota-fiscal.cod-estabel = docum-est.cod-estabel
                   AND nota-fiscal.nr-nota-fis = docum-est.nro-docto
                   AND nota-fiscal.serie       = docum-est.serie-docto NO-ERROR.
    
            IF AVAIL nota-fiscal THEN
                ASSIGN tt-ord-prod.status-nota-serv = {diinc/i01di135.i 04 nota-fiscal.idi-sit-nf-eletro}
                       tt-ord-prod.vl-tot-nota-serv = nota-fiscal.vl-tot-nota
                       tt-ord-prod.dt-emis          = nota-fiscal.dt-emis
                       tt-ord-prod.user-calc        = nota-fiscal.user-calc.
    
            FOR LAST ord-rep NO-LOCK
               WHERE ord-rep.nr-ord-prod = tt-ord-prod.nr-ord-prod:
    
                FIND FIRST rep-prod NO-LOCK
                     WHERE rep-prod.nr-reporte = ord-rep.nr-reporte NO-ERROR.
    
                ASSIGN tt-ord-prod.data-reporte    = rep-prod.data
                       tt-ord-prod.usuario-reporte = rep-prod.usuario.
                
            END.
        END.
    
        FIND FIRST docum-est NO-LOCK
             WHERE ROWID(docum-est) = TO-ROWID(int-ord-prod-monitor.r-docum-est-ret) NO-ERROR.
    
        IF AVAIL docum-est THEN
            ASSIGN tt-ord-prod.docto-ret   = docum-est.nro-docto + "/" + docum-est.serie-docto.
    
        FIND FIRST docum-est NO-LOCK
             WHERE ROWID(docum-est) = TO-ROWID(int-ord-prod-monitor.r-docum-est-serv) NO-ERROR.
    
        IF AVAIL docum-est THEN
            ASSIGN tt-ord-prod.docto-serv   = docum-est.nro-docto + "/" + docum-est.serie-docto.
    
        FIND FIRST tt-ord-prod-sel
             WHERE tt-ord-prod-sel.nr-ord-prod = tt-ord-prod.nr-ord-prod NO-ERROR.
    
        IF AVAIL tt-ord-prod-sel THEN DO:
            BUFFER-COPY tt-ord-prod TO tt-ord-prod-sel.
            ASSIGN tt-ord-prod.selecionada = YES.
        END.
    END.
    
    /*Atualiza campos da seleá∆o*/
    FOR EACH tt-ord-prod-sel:
        FIND FIRST ord-prod OF tt-ord-prod-sel NO-LOCK NO-ERROR.
            
        FIND FIRST int-ord-prod-monitor NO-LOCK
             WHERE int-ord-prod-monitor.nr-ord-produ = ord-prod.nr-ord-produ NO-ERROR.
    
        FIND FIRST docum-est NO-LOCK
             WHERE ROWID(docum-est) = TO-ROWID(int-ord-prod-monitor.r-docum-est-ret) NO-ERROR.
    
        IF AVAIL docum-est THEN
            ASSIGN tt-ord-prod-sel.docto-ret   = docum-est.nro-docto + "/" + docum-est.serie-docto.
    
        FIND FIRST nota-fiscal NO-LOCK
             WHERE nota-fiscal.cod-estabel = docum-est.cod-estabel
               AND nota-fiscal.nr-nota-fis = docum-est.nro-docto
               AND nota-fiscal.serie       = docum-est.serie-docto NO-ERROR.
    
        IF AVAIL nota-fiscal THEN
            ASSIGN tt-ord-prod-sel.status-nota-ret = {diinc/i01di135.i 04 nota-fiscal.idi-sit-nf-eletro}.
        ELSE 
            ASSIGN tt-ord-prod-sel.status-nota-ret = "".
    
        FIND FIRST docum-est NO-LOCK
             WHERE ROWID(docum-est) = TO-ROWID(int-ord-prod-monitor.r-docum-est-serv) NO-ERROR.
    
        IF AVAIL docum-est THEN
            ASSIGN tt-ord-prod-sel.docto-serv   = docum-est.nro-docto + "/" + docum-est.serie-docto.
    
        FIND FIRST nota-fiscal NO-LOCK
             WHERE nota-fiscal.cod-estabel = docum-est.cod-estabel
               AND nota-fiscal.nr-nota-fis = docum-est.nro-docto
               AND nota-fiscal.serie       = docum-est.serie-docto NO-ERROR.
    
        IF AVAIL nota-fiscal THEN
            ASSIGN tt-ord-prod-sel.status-nota-serv = {diinc/i01di135.i 04 nota-fiscal.idi-sit-nf-eletro}
                   tt-ord-prod-sel.vl-tot-nota-serv = nota-fiscal.vl-tot-nota
                   tt-ord-prod-sel.dt-emis          = nota-fiscal.dt-emis
                   tt-ord-prod-sel.user-calc        = nota-fiscal.user-calc.
    
        ASSIGN tt-ord-prod-sel.estado = ord-prod.estado
               tt-ord-prod-sel.ind-status-industr = int-ord-prod-monitor.ind-status-industr
               tt-ord-prod-sel.num-pedido = int-ord-prod-monitor.num-pedido.
    
         FOR LAST ord-rep NO-LOCK
            WHERE ord-rep.nr-ord-prod = tt-ord-prod-sel.nr-ord-prod:
        
             FIND FIRST rep-prod NO-LOCK
                  WHERE rep-prod.nr-reporte = ord-rep.nr-reporte NO-ERROR.
        
             ASSIGN tt-ord-prod-sel.data-reporte    = rep-prod.data
                    tt-ord-prod-sel.usuario-reporte = rep-prod.usuario.
             
         END.
    END.
END.

/* Quando Fatura:            */
/*                           */
/* Estado                    */
/* Status Ind                */
/* Pedido                    */
/* NF Retorno                */
/* Status NF Retorno         */
/* NF Serviáo                */
/* Status NF Serviáo         */
/* Vl TOt Nots               */
/* Data NF                   */
/* Usuario NF                */
/*                           */
/* Quando reporta:           */
/*                           */
/* Estado                    */
/* Data Receb                */
/* Usuario Receb             */
/*                           */
/* E as cores em ambos casos */



RUN pi-finalizar IN h-acomp.
{&open-query-br-ordens}
APPLY "value-changed" TO br-ordens IN FRAME f-cad.

IF CAN-FIND (FIRST tt-ord-prod-sel) THEN
    br-selecionadas:REFRESH() IN FRAME f-cad.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cq w-cadsim 
PROCEDURE pi-cq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-row-table AS ROWID.

    FIND FIRST ord-prod NO-LOCK
         WHERE ROWID(ord-prod) = p-row-table NO-ERROR.

    IF AVAIL ord-prod THEN DO:

        FIND FIRST ficha-cq NO-LOCK
             WHERE ficha-cq.cod-estabel  = ord-prod.cod-estabel
               AND ficha-cq.nr-ord-produ = ord-prod.nr-ord-produ 
               AND ficha-cq.serie        = ""
               AND ficha-cq.nro-docto    = STRING(ord-prod.nr-ord-produ)
               AND ficha-cq.cod-emitente = 0
               AND ficha-cq.nat-operacao = ""
               AND ficha-cq.nr-ord-cq    = 0
               AND ficha-cq.situacao     = 1 NO-ERROR.

        IF AVAIL ficha-cq THEN do:
            EMPTY TEMP-TABLE tt-prog-ponto.

            ASSIGN c-estab = "".

            RUN esp/es0018p.p (INPUT "cp0311-upc", /* Nome do programa */
                               INPUT 2,            /* Ponto do programa */
                               INPUT 0,
                               INPUT "",
                               OUTPUT TABLE tt-prog-ponto).    
        
            FOR FIRST tt-prog-ponto:
                ASSIGN c-estab = tt-prog-ponto.conteudo.
            END.

            RUN pi-fichacq.
            
            IF RETURN-VALUE <> "OK" THEN
                RETURN "NOK".
        END.
        ELSE DO:
            
            FIND FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo = ord-prod.it-codigo NO-ERROR.

            FIND FIRST item-uni-estab NO-LOCK
                 WHERE item-uni-estab.cod-estabel = ord-prod.cod-estabel
                   AND item-uni-estab.it-codigo   = ITEM.it-codigo NO-ERROR.
            
        END.

/*         RUN pi-mail. */
    END. 

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-fichacq w-cadsim 
PROCEDURE pi-fichacq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF LOOKUP(ficha-cq.cod-estabel,c-estab) > 0 THEN DO:
        FOR FIRST movto-estoq NO-LOCK
            WHERE movto-estoq.cod-estabel   = ficha-cq.cod-estabel
              AND movto-estoq.nr-ord-produ  = ficha-cq.nr-ord-produ
              AND movto-estoq.it-codigo     = ficha-cq.it-codigo
              AND movto-estoq.serie         = ficha-cq.serie          
              AND movto-estoq.nro-docto     = ficha-cq.nro-docto      
              AND movto-estoq.cod-emitente  = ficha-cq.cod-emitente   
              AND movto-estoq.nat-operacao  = ficha-cq.nat-operacao   
              AND movto-estoq.dt-trans      = ficha-cq.dt-ficha       
              AND movto-estoq.quantidade    = ficha-cq.qt-original    
              AND movto-estoq.esp-docto     = 1,
            FIRST ord-prod NO-LOCK
            WHERE ord-prod.cod-estabel     = movto-estoq.cod-estabel
              AND ord-prod.nr-ord-produ    = ficha-cq.nr-ord-produ:
            
            RUN piTrataFicha.

            IF RETURN-VALUE <> "OK" THEN
                RETURN "NOK".
        END.
    END.
    ELSE DO:
        FOR FIRST movto-estoq NO-LOCK
            WHERE movto-estoq.cod-estabel   = ficha-cq.cod-estabel
              AND movto-estoq.nr-ord-produ  = ficha-cq.nr-ord-produ
              AND movto-estoq.it-codigo     = ficha-cq.it-codigo
              AND movto-estoq.serie         = ficha-cq.serie          
              AND movto-estoq.nro-docto     = ficha-cq.nro-docto      
              AND movto-estoq.cod-emitente  = ficha-cq.cod-emitente   
              AND movto-estoq.nat-operacao  = ficha-cq.nat-operacao   
              AND movto-estoq.dt-trans      = ficha-cq.dt-ficha       
              AND movto-estoq.quantidade    = ficha-cq.qt-original    
              AND movto-estoq.esp-docto     = 1,
            FIRST ord-prod NO-LOCK
            WHERE ord-prod.cod-estabel     = movto-estoq.cod-estabel
              AND ord-prod.nr-ord-produ    = ficha-cq.nr-ord-produ
              AND (ord-prod.tipo = 2 OR ord-prod.tipo = 5):

            RUN piTrataFicha.

            IF RETURN-VALUE <> "OK" THEN
                RETURN "NOK".
        END.
    END.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-reporta-ordem w-cadsim 
PROCEDURE pi-reporta-ordem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE ttRepApi.
    EMPTY TEMP-TABLE tt-erro-reporte.
    DEFINE INPUT PARAM p-nr-ord-prod LIKE ord-prod.nr-ord-prod.
    
    DEFINE VARIABLE h-escpp108d AS HANDLE      NO-UNDO.

    FIND FIRST ord-prod NO-LOCK
         WHERE ord-prod.nr-ord-prod = p-nr-ord-prod NO-ERROR.

    FIND FIRST int-param-ord-prod-monitor NO-LOCK
         WHERE int-param-ord-prod-monitor.cod-estabel = ord-prod.cod-estabel NO-ERROR.

    FIND FIRST param-cp NO-LOCK NO-ERROR.
    
    CREATE ttRepApi.
    ASSIGN ttRepApi.nr-ord-produ    = ord-prod.nr-ord-produ    
           ttRepApi.op-codigo       = 0                        
           ttRepApi.qt-reporte      = ord-prod.qt-ordem
           ttRepApi.depos-ent       = int-param-ord-prod-monitor.cod-depos-reporte-prod
           ttRepApi.depos-sai       = param-cp.dep-fabrica
           ttRepApi.c-enche         = "TOTAL"                  
           ttRepApi.cEtiqueta       = ""                       
           ttRepApi.c-nome-imp      = ""                       
           ttRepApi.cNomeLayout     = ""                       
           ttRepApi.nao-imprimir    = NO                       
           ttRepApi.da-data-reporte = TODAY                    
           ttRepApi.l-ver-sel       = NO                       
           ttRepApi.c-localizacao   = ""
           ttRepApi.linha           = "".

    reporte:
    DO TRANS ON ERROR UNDO reporte,LEAVE reporte:

        RUN esp/cpp/escpp108d.p PERSISTENT SET h-escpp108d.
        
        RUN piInicializaReporte IN h-escpp108d (INPUT TABLE ttRepApi,
                                                INPUT "NORMAL").
        
        RUN piReportaProducao IN h-escpp108d (INPUT ord-prod.cod-estabel,
                                              INPUT 1,
                                              INPUT ROWID(ord-prod)).  /* CPP */
        
        RUN piRetornaErro IN h-escpp108d (OUTPUT TABLE tt-erro-reporte).
    
        IF NOT CAN-FIND (FIRST tt-erro-reporte) THEN DO:
            FIND FIRST int-ord-prod-monitor EXCLUSIVE-LOCK
                 WHERE int-ord-prod-monitor.nr-ord-produ = ord-prod.nr-ord-produ NO-ERROR.
    
            ASSIGN int-ord-prod-monitor.ind-status-industr = 2 /*Reportada*/.
        END.
        ELSE DO:
            UNDO reporte, LEAVE reporte.
        END.

        RUN pi-cq (INPUT ROWID(ord-prod)).
        
        IF RETURN-VALUE <> "OK" THEN
            UNDO reporte, LEAVE reporte.
    END.

    DELETE PROCEDURE h-escpp108d.
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piTrataFicha w-cadsim 
PROCEDURE piTrataFicha :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-ultimo-ae AS INTEGER     NO-UNDO.

    FIND FIRST int-ord-prod-monitor NO-LOCK
         WHERE int-ord-prod-monitor.nr-ord-produ = ord-prod.nr-ord-produ NO-ERROR.

    FIND FIRST docum-est NO-LOCK
         WHERE ROWID(docum-est) = TO-ROWID(int-ord-prod-monitor.r-docum-est-serv) NO-ERROR.

    FIND FIRST item-doc-est OF docum-est NO-LOCK
         WHERE item-doc-est.it-codigo = ord-prod.it-codigo NO-ERROR.

    IF NOT AVAIL docum-est 
    OR NOT AVAIL item-doc-est THEN
        RETURN "NOK".

    FIND CURRENT ficha-cq EXCLUSIVE-LOCK.
        
    ASSIGN ficha-cq.serie        = IF AVAIL docum-est THEN docum-est.serie-docto  ELSE ""
           ficha-cq.nro-docto    = IF AVAIL docum-est THEN docum-est.nro-docto    ELSE ""
           ficha-cq.cod-emitente = IF AVAIL docum-est THEN docum-est.cod-emitente ELSE 0
           ficha-cq.nat-operacao = IF AVAIL docum-est THEN docum-est.nat-operacao ELSE ""
           ficha-cq.nr-ord-cq    = item-doc-est.sequencia.

    FIND CURRENT movto-estoq EXCLUSIVE-LOCK.

    ASSIGN movto-estoq.descricao-db = ficha-cq.serie + ";" + ficha-cq.nro-docto + ";" + STRING(ficha-cq.cod-emitente) + ";" + ficha-cq.nat-operacao + ";" + string(item-doc-est.sequencia).

    FIND CURRENT movto-estoq NO-LOCK.

    /**/

    FIND CURRENT ficha-cq NO-LOCK.

    FIND CURRENT item-doc-est EXCLUSIVE-LOCK.
    ASSIGN item-doc-est.nr-ficha = ficha-cq.nr-ficha.
    FIND CURRENT item-doc-est NO-LOCK.

    FIND FIRST ae-entrada NO-LOCK
         WHERE ae-entrada.cod-estabel  = movto-estoq.cod-estabel
           and ae-entrada.nro-docto    = INT(movto-estoq.nro-docto)
           AND ae-entrada.cod-emitente = movto-estoq.cod-emitente NO-ERROR.

    IF NOT AVAIL ae-entrada THEN DO:
        CREATE ae-entrada.
        ASSIGN ae-entrada.cod-estabel      = movto-estoq.cod-estabel
               ae-entrada.nro-docto        = INT(movto-estoq.nro-docto)
               ae-entrada.cod-emitente     = movto-estoq.cod-emitente
               ae-entrada.data             = TODAY 
               ae-entrada.hora             = STRING(TIME,"HH:MM:SS").
    END. 
    
    FIND FIRST ae-inspecao NO-LOCK 
         WHERE ae-inspecao.cod-estabel  = movto-estoq.cod-estabel 
           AND ae-inspecao.nro-docto    = INT(ficha-cq.nro-docto) 
           AND ae-inspecao.serie        = ficha-cq.serie          
           AND ae-inspecao.cod-emitente = ficha-cq.cod-emitente   
           AND ae-inspecao.nat-operacao = ficha-cq.nat-operacao   
           AND ae-inspecao.it-codigo    = ficha-cq.it-codigo NO-ERROR.
    
    IF AVAIL ae-inspecao THEN 
        ASSIGN i-ultimo-ae = ae-inspecao.nr-ae.
    ELSE DO:    
        FIND FIRST aviso-entrada EXCLUSIVE-LOCK
            where aviso-entrada.cod-estabel = movto-estoq.cod-estabel NO-ERROR.
        IF AVAIL aviso-entrada THEN
            ASSIGN i-ultimo-ae             = aviso-entrada.ultimo-ae + 1
                   aviso-entrada.ultimo-ae = i-ultimo-ae.                
        ELSE DO:
            CREATE aviso-entrada.
            ASSIGN aviso-entrada.cod-estabel = movto-estoq.cod-estabel
                   aviso-entrada.ultimo-ae   = 1.
        END.
        FIND CURRENT aviso-entrada no-lock no-error.
    END.
    
    FIND FIRST ae-inspecao NO-LOCK
         WHERE ae-inspecao.cod-estabel  = movto-estoq.cod-estabel 
           AND ae-inspecao.nro-docto    = INT(ficha-cq.nro-docto) 
           AND ae-inspecao.serie        = ficha-cq.serie          
           AND ae-inspecao.cod-emitente = ficha-cq.cod-emitente   
           AND ae-inspecao.nat-operacao = ficha-cq.nat-operacao   
           AND ae-inspecao.it-codigo    = ficha-cq.it-codigo      
           AND ae-inspecao.sequencia    = item-doc-est.sequencia NO-ERROR.
         
    IF NOT AVAIL ae-inspecao THEN DO:
       CREATE ae-inspecao.
       ASSIGN ae-inspecao.cod-estabel  = movto-estoq.cod-estabel
              ae-inspecao.nro-docto    = INT(ficha-cq.nro-docto)
              ae-inspecao.cod-emitente = ficha-cq.cod-emitente
              ae-inspecao.it-codigo    = ficha-cq.it-codigo
              ae-inspecao.nat-operacao = ficha-cq.nat-operacao
              ae-inspecao.serie        = ficha-cq.serie-docto
              ae-inspecao.nr-ae        = i-ultimo-ae 
              ae-inspecao.sequencia    = item-doc-est.sequencia
              ae-inspecao.quantidade   = movto-estoq.quantidade
              ae-inspecao.nr-ficha     = ficha-cq.nr-ficha.
    END.

    RETURN "OK".
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
  {src/adm/template/snd-list.i "tt-ord-prod-sel"}
  {src/adm/template/snd-list.i "tt-ord-prod"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescitem w-cadsim 
FUNCTION fnDescitem RETURNS CHARACTER
  ( p-it-codigo AS CHAR ) :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnEstadoOrdem w-cadsim 
FUNCTION fnEstadoOrdem RETURNS CHARACTER
  ( p-estado AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN {ininc/i01in271.i 04 p-estado}.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnItemPai w-cadsim 
FUNCTION fnItemPai RETURNS CHARACTER
  ( p-nr-pedido AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

FIND FIRST int-item NO-LOCK
     WHERE int-item.nr-ped-energia = string(p-nr-pedido) NO-ERROR.

IF AVAIL int-item THEN
    RETURN int-item.it-codigo.
ELSE 
    RETURN "". 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnSitItem w-cadsim 
FUNCTION fnSitItem RETURNS CHARACTER
  ( p-cod-sit-item AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN {diinc/i03di149.i 04 p-cod-sit-item}.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnStatus w-cadsim 
FUNCTION fnStatus RETURNS CHARACTER
  ( p-status AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF p-status = 0 THEN
      RETURN "N∆o Iniciada".   /* Function return value. */
  ELSE IF p-status = 1 THEN
      RETURN "Faturada".   /* Function return value. */
  ELSE IF p-status = 2 THEN
      RETURN "Reportada".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

