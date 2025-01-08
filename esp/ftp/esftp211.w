&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
          mgmov            PROGRESS
*/
&Scoped-define WINDOW-NAME w-cadsim


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-ped-item NO-UNDO LIKE ped-item.
DEFINE TEMP-TABLE tt-ped-venda NO-UNDO LIKE ped-venda
       field cod-projeto like int-ped-venda.cod-projeto
       field vlr-comissao like int-ped-venda.vlr-comissao
       field des-sit-ped as char
       field des-sit-solar as char
       field vl-serv-inst like int-ped-venda.vl-serv-inst
       field ind-status-solar like int-ped-venda.ind-status-solar.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadsim 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esftp211 2.00.00.000}

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

/* Parameters Definitions ---                                           */

/* Temp-Table and Buffer definitions                                    */


/* Local Variable Definitions ---                                       */
define variable wh-imprime as handle no-undo.
DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "x(80)"  NO-UNDO.

DEF VAR c-cod-estabel-ini   AS CHAR INITIAL "".
DEF VAR c-cod-estabel-fim   AS CHAR INITIAL "ZZZZZ".
DEF VAR d-dt-implant-ini    AS DATE INITIAL "01/01/1900".  
DEF VAR d-dt-implant-fim    AS DATE INITIAL "12/31/9999".
DEF VAR i-cod-emitente-ini  AS INT INITIAL "0".
DEF VAR i-cod-emitente-fim  AS INT INITIAL "999999999".
DEF VAR i-nr-pedido-ini     AS INT INITIAL 0.
DEF VAR i-nr-pedido-fim     AS INT INITIAL 999999999.
                            
DEF VAR l-tg-aberto         AS LOG INITIAL YES.
DEF VAR l-tg-atendido-parc  AS LOG INITIAL YES.
DEF VAR l-tg-atendido-tot   AS LOG INITIAL NO.
DEF VAR l-tg-pendente       AS LOG INITIAL NO.
DEF VAR l-tg-suspenso       AS LOG INITIAL YES.
DEF VAR l-tg-cancelado      AS LOG INITIAL NO.

DEF VAR l-tg-aguardando-lib AS LOG INITIAL YES.
DEF VAR l-tg-aguardando-ger-fci AS LOG INITIAL YES.
DEF VAR l-tg-aguardando-sep AS LOG INITIAL YES.
DEF VAR l-tg-lib-fat        AS LOG INITIAL YES.
DEF VAR l-tg-faturado       AS LOG INITIAL YES.

DEF VAR l-openquery        AS LOG.
DEF VAR c-situacao         AS CHARACTER FORMAT "x(20)"  NO-UNDO.

DEFINE VAR l-verifica-saldo AS LOG NO-UNDO.

define new global shared var wh-dt-entrega-pd4000  as widget-handle no-undo.
DEFINE VARIABLE h-pd4000      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-ft4002      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-cd0402      AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-ped-venda      AS ROWID         NO-UNDO.


DEF NEW GLOBAL SHARED VAR gr-item      AS ROWID         NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-ord-prod  AS ROWID         NO-UNDO.

DEFINE VARIABLE c-item-pai AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-sit-item AS CHARACTER FORMAT "x(20)"  NO-UNDO.

DEFINE VARIABLE h-bodi159com AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-nr-ord-prod AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-deposito   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-sit-docto  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cont       AS INTEGER     NO-UNDO.

DEFINE VARIABLE c-nota AS CHARACTER   NO-UNDO.

DEF VAR h-acomp         AS HANDLE NO-UNDO.
DEFINE VARIABLE hProxy  AS HANDLE NO-UNDO.

DEF TEMP-TABLE tt-itens-docto LIKE wm-docto-itens.

DEF TEMP-TABLE tt-itens-saldo NO-UNDO
    FIELD it-codigo LIKE ITEM.it-codigo
    FIELD qt-disp     AS DEC
    FIELD cod-estabel AS CHAR.


{method/dbotterr.i}
{esp/es0018.i}
{utp/ut-glob.i}
{utp/utapi019.i}
{include/pdf_inc.i "THIS-PROCEDURE"}
{cdp/cd0666.i}
{esp/pdp/espdp006fn.i}


DEFINE TEMP-TABLE ttAlocaReservaAux LIKE aloca-reserva.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME br-ped-item

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ped-item tt-ped-venda int-ped-venda

/* Definitions for BROWSE br-ped-item                                   */
&Scoped-define FIELDS-IN-QUERY-br-ped-item tt-ped-item.nr-pedcli tt-ped-item.it-codigo tt-ped-item.qt-pedida tt-ped-item.qt-atendida tt-ped-item.vl-tot-it fnDescItem(tt-ped-item.it-codigo) @ c-desc-item fnSitItem(tt-ped-item.cod-sit-item) @ c-sit-item /*{diinc/i03di149.i 04 tt-ped-item.cod-sit-item}*/ /*Ordem Produá∆o (ord-prod.nr-ord-prod) - pesquisar a ordem de produá∆o que possui o pedido e o c¢digo do item pai.*/   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-ped-item   
&Scoped-define SELF-NAME br-ped-item
&Scoped-define QUERY-STRING-br-ped-item FOR EACH tt-ped-item BY tt-ped-item.nr-sequencia DESC
&Scoped-define OPEN-QUERY-br-ped-item OPEN QUERY {&SELF-NAME} FOR EACH tt-ped-item BY tt-ped-item.nr-sequencia DESC.
&Scoped-define TABLES-IN-QUERY-br-ped-item tt-ped-item
&Scoped-define FIRST-TABLE-IN-QUERY-br-ped-item tt-ped-item


/* Definitions for BROWSE br-pedidos                                    */
&Scoped-define FIELDS-IN-QUERY-br-pedidos tt-ped-venda.nr-pedido tt-ped-venda.dt-implant tt-ped-venda.cod-emitente tt-ped-venda.nome-abrev fnItemPai(tt-ped-venda.nr-pedido) @ c-item-pai fnOrdProd(tt-ped-venda.nr-pedcli) @ c-nr-ord-prod FnRetornaNF(tt-ped-venda.nome-abrev,tt-ped-venda.nr-pedcli) @ c-nota tt-ped-venda.estado tt-ped-venda.no-ab-reppri tt-ped-venda.cod-estabel tt-ped-venda.cod-cond-pag tt-ped-venda.vl-tot-ped tt-ped-venda.vlr-comissao tt-ped-venda.vl-serv-inst tt-ped-venda.des-sit-ped tt-ped-venda.des-sit-solar fnSitDocWMS(tt-ped-venda.cod-estabel,fnOrdProd(tt-ped-venda.nr-pedcli)) @ c-sit-docto tt-ped-venda.dt-entrega tt-ped-venda.nat-operacao tt-ped-venda.nome-transp tt-ped-venda.cod-projeto int-ped-venda.num-serie-solar   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-pedidos   
&Scoped-define SELF-NAME br-pedidos
&Scoped-define QUERY-STRING-br-pedidos FOR EACH tt-ped-venda, ~
                                   EACH int-ped-venda     WHERE tt-ped-venda.nr-pedido  = int-ped-venda.nr-pedido       AND tt-ped-venda.cod-estabel = int-ped-venda.cod-estabel
&Scoped-define OPEN-QUERY-br-pedidos OPEN QUERY {&SELF-NAME} FOR EACH tt-ped-venda, ~
                                   EACH int-ped-venda     WHERE tt-ped-venda.nr-pedido  = int-ped-venda.nr-pedido       AND tt-ped-venda.cod-estabel = int-ped-venda.cod-estabel .
&Scoped-define TABLES-IN-QUERY-br-pedidos tt-ped-venda int-ped-venda
&Scoped-define FIRST-TABLE-IN-QUERY-br-pedidos tt-ped-venda
&Scoped-define SECOND-TABLE-IN-QUERY-br-pedidos int-ped-venda


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-br-ped-item}~
    ~{&OPEN-QUERY-br-pedidos}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button rt-button-2 rt-button-3 RECT-7 ~
RECT-8 btExcel btSelecao btAtualiza bt-exit br-pedidos bt-detalhar ~
bt-liberar-pagto bt-faturar bt-nota-fiscal bt-observacao bt-libera-WMS ~
br-ped-item bt-detalhar-it bt-estrutura bt-ord-prod bt-rep-ord bt-estoque ~
bt-folha-rosto bt-ok bt-cancela 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnItemPai w-cadsim 
FUNCTION fnItemPai RETURNS CHARACTER
  ( p-nr-pedido AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnOrdProd w-cadsim 
FUNCTION fnOrdProd RETURNS CHARACTER
  ( p-nr-pedcli AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD FnRetornaNF w-cadsim 
FUNCTION FnRetornaNF RETURNS CHARACTER
  (c-nome-abrev AS CHAR, c-num-ped AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD FnSitDocWMS w-cadsim 
FUNCTION FnSitDocWMS RETURNS CHARACTER
  ( c-estab AS CHAR, c-docto AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnSitItem w-cadsim 
FUNCTION fnSitItem RETURNS CHARACTER
  ( p-cod-sit-item AS INT )  FORWARD.

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

DEFINE BUTTON bt-detalhar 
     LABEL "Detalhar" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-detalhar-it 
     LABEL "Detalhar" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-estoque 
     LABEL "Estoque" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-estrutura 
     LABEL "Estrutura" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-exit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-DOWN FILE "image\ii-exi":U
     LABEL "" 
     SIZE 4 BY 1.17.

DEFINE BUTTON bt-faturar 
     LABEL "Faturar" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-folha-rosto 
     LABEL "Folha de Rosto" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-imprime 
     LABEL "&Imprimir" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-libera-WMS 
     LABEL "Libera Saldo WMS" 
     SIZE 18 BY 1.13.

DEFINE BUTTON bt-liberar-pagto 
     LABEL "Lib. Financeiro" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-nota-fiscal 
     LABEL "Notas Fiscais" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-observacao 
     LABEL "Observaá∆o" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ord-prod 
     LABEL "Sumarizar" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-rep-ord 
     LABEL "Reportar Ordem" 
     SIZE 15 BY 1.13.

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

DEFINE BUTTON btSelecao 
     IMAGE-UP FILE "image\im-ran":U
     IMAGE-INSENSITIVE FILE "image\ii-ran":U
     LABEL "Seleá∆o" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 169 BY 16.5.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 169 BY 9.13.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 169 BY 1.38
     BGCOLOR 7 .

DEFINE RECTANGLE rt-button-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 169.29 BY 1.38
     BGCOLOR 7 .

DEFINE RECTANGLE rt-button-3
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 169.29 BY 1.38
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-ped-item FOR 
      tt-ped-item SCROLLING.

DEFINE QUERY br-pedidos FOR 
      tt-ped-venda, 
      int-ped-venda SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-ped-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-ped-item w-cadsim _FREEFORM
  QUERY br-ped-item DISPLAY
      tt-ped-item.nr-pedcli
tt-ped-item.it-codigo
tt-ped-item.qt-pedida
tt-ped-item.qt-atendida
tt-ped-item.vl-tot-it
fnDescItem(tt-ped-item.it-codigo) @ c-desc-item COLUMN-LABEL "Item"
fnSitItem(tt-ped-item.cod-sit-item) @ c-sit-item COLUMN-LABEL "Situaá∆o"
/*{diinc/i03di149.i 04 tt-ped-item.cod-sit-item}*/
/*Ordem Produá∆o (ord-prod.nr-ord-prod) - pesquisar a ordem de produá∆o que possui o pedido e o c¢digo do item pai.*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 151 BY 8
         TITLE "Itens Pedido" ROW-HEIGHT-CHARS .67 FIT-LAST-COLUMN.

DEFINE BROWSE br-pedidos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-pedidos w-cadsim _FREEFORM
  QUERY br-pedidos DISPLAY
      tt-ped-venda.nr-pedido
tt-ped-venda.dt-implant
tt-ped-venda.cod-emitente WIDTH 7
tt-ped-venda.nome-abrev COLUMN-LABEL "Nome" WIDTH 12
fnItemPai(tt-ped-venda.nr-pedido) @ c-item-pai COLUMN-LABEL "Item Pai"    WIDTH 7
fnOrdProd(tt-ped-venda.nr-pedcli) @ c-nr-ord-prod COLUMN-LABEL "Ord.Prod" WIDTH 7
FnRetornaNF(tt-ped-venda.nome-abrev,tt-ped-venda.nr-pedcli) @ c-nota COLUMN-LABEL "Nota Fiscal" WIDTH 8
tt-ped-venda.estado
tt-ped-venda.no-ab-reppri WIDTH 12
tt-ped-venda.cod-estabel  WIDTH 3  COLUMN-LABEL 'Estab'
tt-ped-venda.cod-cond-pag
tt-ped-venda.vl-tot-ped   
tt-ped-venda.vlr-comissao WIDTH 10
tt-ped-venda.vl-serv-inst WIDTH 10
tt-ped-venda.des-sit-ped COLUMN-LABEL "Situaá∆o" WIDTH 8
tt-ped-venda.des-sit-solar WIDTH 18 COLUMN-LABEL "Sit Sol." FORMAT "x(40)" 
fnSitDocWMS(tt-ped-venda.cod-estabel,fnOrdProd(tt-ped-venda.nr-pedcli)) @ c-sit-docto COLUMN-LABEL "Situaá∆o WMS"  FORMAT "x(12)" 
tt-ped-venda.dt-entrega
tt-ped-venda.nat-operacao
tt-ped-venda.nome-transp WIDTH 14
tt-ped-venda.cod-projeto
int-ped-venda.num-serie-solar  COLUMN-LABEL "Num Serie Gerador"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 167 BY 14.46
         TITLE "Pedidos" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     btExcel AT ROW 1.13 COL 2.14 HELP
          "Gerar Relatorio Excel" WIDGET-ID 174
     btSelecao AT ROW 1.13 COL 6 HELP
          "Seleá∆o" WIDGET-ID 176
     btAtualiza AT ROW 1.13 COL 9.86 HELP
          "Atualizar" WIDGET-ID 160
     bt-exit AT ROW 1.17 COL 166.29 WIDGET-ID 178
     br-pedidos AT ROW 2.75 COL 3 WIDGET-ID 200
     bt-detalhar AT ROW 17.54 COL 3 WIDGET-ID 188
     bt-liberar-pagto AT ROW 17.54 COL 18 WIDGET-ID 190
     bt-faturar AT ROW 17.54 COL 33 WIDGET-ID 192
     bt-nota-fiscal AT ROW 17.54 COL 48 WIDGET-ID 194
     bt-observacao AT ROW 17.54 COL 63 WIDGET-ID 196
     bt-libera-WMS AT ROW 17.54 COL 78 WIDGET-ID 212
     br-ped-item AT ROW 19.5 COL 3 WIDGET-ID 300
     bt-detalhar-it AT ROW 20.33 COL 155 WIDGET-ID 200
     bt-estrutura AT ROW 21.5 COL 155 WIDGET-ID 202
     bt-ord-prod AT ROW 22.67 COL 155 WIDGET-ID 204
     bt-rep-ord AT ROW 23.83 COL 155 WIDGET-ID 208
     bt-estoque AT ROW 25 COL 155 WIDGET-ID 206
     bt-folha-rosto AT ROW 26.17 COL 155 WIDGET-ID 210
     bt-ok AT ROW 28.71 COL 3
     bt-cancela AT ROW 28.71 COL 14
     bt-imprime AT ROW 28.71 COL 25
     bt-ajuda AT ROW 28.71 COL 160.43
     rt-button AT ROW 28.5 COL 2
     rt-button-2 AT ROW 28.5 COL 1.72 WIDGET-ID 2
     rt-button-3 AT ROW 1.04 COL 1.72 WIDGET-ID 180
     RECT-7 AT ROW 2.5 COL 2 WIDGET-ID 182
     RECT-8 AT ROW 19.13 COL 2 WIDGET-ID 198
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 170.72 BY 28.88 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-ped-item T "?" NO-UNDO mgmov ped-item
      TABLE: tt-ped-venda T "?" NO-UNDO mgmov ped-venda
      ADDITIONAL-FIELDS:
          field cod-projeto like int-ped-venda.cod-projeto
          field vlr-comissao like int-ped-venda.vlr-comissao
          field des-sit-ped as char
          field des-sit-solar as char
          field vl-serv-inst like int-ped-venda.vl-serv-inst
          field ind-status-solar like int-ped-venda.ind-status-solar
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
         HEIGHT             = 28.88
         WIDTH              = 170.72
         MAX-HEIGHT         = 29.13
         MAX-WIDTH          = 170.72
         VIRTUAL-HEIGHT     = 29.13
         VIRTUAL-WIDTH      = 170.72
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
/* BROWSE-TAB br-pedidos bt-exit f-cad */
/* BROWSE-TAB br-ped-item bt-libera-WMS f-cad */
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

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-ped-item
/* Query rebuild information for BROWSE br-ped-item
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ped-item BY tt-ped-item.nr-sequencia DESC
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-ped-item */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-pedidos
/* Query rebuild information for BROWSE br-pedidos
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ped-venda,
                            EACH int-ped-venda
    WHERE tt-ped-venda.nr-pedido  = int-ped-venda.nr-pedido
      AND tt-ped-venda.cod-estabel = int-ped-venda.cod-estabel .
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-pedidos */
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


&Scoped-define BROWSE-NAME br-ped-item
&Scoped-define SELF-NAME br-ped-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-ped-item w-cadsim
ON ROW-DISPLAY OF br-ped-item IN FRAME f-cad /* Itens Pedido */
DO:
   IF tt-ped-item.cod-sit-item = 6 THEN DO:
       ASSIGN tt-ped-item.nr-pedcli:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
              tt-ped-item.it-codigo:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
              tt-ped-item.qt-pedida:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
              tt-ped-item.qt-atendida:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
              tt-ped-item.vl-tot-it:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
              c-desc-item:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
              c-sit-item:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-pedidos
&Scoped-define SELF-NAME br-pedidos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-pedidos w-cadsim
ON ROW-DISPLAY OF br-pedidos IN FRAME f-cad /* Pedidos */
DO:
    IF tt-ped-venda.ind-status-solar = 4 THEN DO:
         ASSIGN tt-ped-venda.des-sit-solar:FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
                tt-ped-venda.nr-pedido:FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
                tt-ped-venda.dt-implant:FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
                tt-ped-venda.cod-emitente:FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
                tt-ped-venda.nome-abrev:FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
                c-item-pai:FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
                c-sit-docto:FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
                tt-ped-venda.estado:FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
                tt-ped-venda.no-ab-reppri:FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
                tt-ped-venda.cod-estabel:FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
                tt-ped-venda.cod-cond-pag:FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
                tt-ped-venda.vl-tot-ped:FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
                tt-ped-venda.vlr-comissao:FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
                tt-ped-venda.vl-serv-inst:FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
                tt-ped-venda.des-sit-ped:FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
                tt-ped-venda.des-sit-solar:FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
                tt-ped-venda.dt-entrega:FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
                tt-ped-venda.nat-operacao:FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
                tt-ped-venda.nome-transp:FGCOLOR IN BROWSE {&BROWSE-NAME} = 2
                tt-ped-venda.cod-projeto:FGCOLOR IN BROWSE {&BROWSE-NAME} = 2.

    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-pedidos w-cadsim
ON VALUE-CHANGED OF br-pedidos IN FRAME f-cad /* Pedidos */
DO:
   IF AVAIL tt-ped-venda THEN DO:
       RUN pi-carrega-itens.
    
       FIND FIRST int-ped-venda NO-LOCK
            WHERE int-ped-venda.nr-pedido = tt-ped-venda.nr-pedido NO-ERROR.

       RUN esp/es0018p.p (INPUT "esftp211":U,
                          INPUT 1,
                          INPUT 0,
                          INPUT "":U,
                          OUTPUT TABLE tt-prog-ponto).
    
       IF int-ped-venda.ind-status-solar = 2 THEN
           ASSIGN bt-liberar-pagto:SENSITIVE IN FRAME f-cad = NO.
       ELSE DO:
           /*S¢ habilita para usu†rios com permiss∆o*/
           IF CAN-FIND (FIRST tt-prog-ponto
                        WHERE tt-prog-ponto.conteudo = c-seg-usuario) THEN DO:
           
               RUN esp/es0018p.p (INPUT "Solar":U,
                                  INPUT 5,
                                  INPUT 0,
                                  INPUT "":U,
                                  OUTPUT TABLE tt-prog-ponto).

               /*S¢ habilita para condiá‰es de pagamento cadastradas*/
               IF CAN-FIND (FIRST tt-prog-ponto
                            WHERE tt-prog-ponto.conteudo = string(tt-ped-venda.cod-cond-pag)) THEN
                   ASSIGN bt-liberar-pagto:SENSITIVE IN FRAME f-cad = YES.
           END.
       END.

       IF int-ped-venda.ind-status-solar = 4 THEN
           ASSIGN bt-faturar:SENSITIVE IN FRAME f-cad = YES.
       ELSE
           ASSIGN bt-faturar:SENSITIVE IN FRAME f-cad = NO.


       IF int-ped-venda.ind-status-solar = 3 THEN
          ASSIGN bt-liberar-pagto:SENSITIVE IN FRAME f-cad = NO.
       ELSE
          ASSIGN bt-liberar-pagto:SENSITIVE IN FRAME f-cad = YES.


       /*
       IF tt-ped-venda.des-sit-solar = "Aguardando Separaá∆o" OR 
          tt-ped-venda.des-sit-solar = "Aguardando Lib. Financeira" THEN
          ASSIGN bt-libera-WMS:SENSITIVE IN FRAME f-cad = YES.
       ELSE
          ASSIGN bt-libera-WMS:SENSITIVE IN FRAME f-cad = NO.
       */
        ASSIGN bt-libera-WMS:SENSITIVE IN FRAME f-cad = NO.


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


&Scoped-define SELF-NAME bt-detalhar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-detalhar w-cadsim
ON CHOOSE OF bt-detalhar IN FRAME f-cad /* Detalhar */
DO:
    IF  VALID-HANDLE(wh-dt-entrega-pd4000) AND NOT VALID-HANDLE(h-pd4000) THEN DO:
        run utp/ut-msgs.p (INPUT "show":U,
                           INPUT 17006,
                           INPUT "Atená∆o, j† existe uma Tela do PD4000 aberta em sua sess∆o EMS, favor fechar a tela recÇm aberta. ~~ " + 
                                 "Por restriá‰es tÇcnicas, n∆o Ç poss°vel trabalhar com mais de uma tela do PD4000 na mesma sess∆o do EMS.").

        RETURN "OK".

    END.

    FIND FIRST ped-venda NO-LOCK 
         WHERE ped-venda.nr-pedido = tt-ped-venda.nr-pedido NO-ERROR.
    
    IF AVAIL ped-venda THEN DO:
        ASSIGN gr-ped-venda = ROWID(ped-venda).
        IF NOT VALID-HANDLE(h-pd4000) THEN DO:
            RUN pdp/pd4000.w PERSISTENT SET h-pd4000.
            RUN dispatch IN h-pd4000 ('initialize') no-error.
            RUN repositionRecord IN h-pd4000 (INPUT gr-ped-venda).
        END.
        ELSE
            RUN repositionRecord IN h-pd4000 (INPUT gr-ped-venda).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-detalhar-it
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-detalhar-it w-cadsim
ON CHOOSE OF bt-detalhar-it IN FRAME f-cad /* Detalhar */
DO:
    FIND FIRST ITEM NO-LOCK 
         WHERE ITEM.it-codigo = tt-ped-item.it-codigo NO-ERROR.
    
    IF AVAIL ITEM THEN DO:
        ASSIGN gr-item = ROWID(ITEM).
        RUN cdp/cd0903.w.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-estoque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-estoque w-cadsim
ON CHOOSE OF bt-estoque IN FRAME f-cad /* Estoque */
DO:
    FIND FIRST ped-venda NO-LOCK 
         WHERE ped-venda.nr-pedido = tt-ped-venda.nr-pedido NO-ERROR.
    
    IF AVAIL ped-venda THEN DO:
        ASSIGN gr-ped-venda = ROWID(ped-venda).
        RUN esp/pdp/espdp005a.w.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-estrutura
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-estrutura w-cadsim
ON CHOOSE OF bt-estrutura IN FRAME f-cad /* Estrutura */
DO:
/*     FIND FIRST ITEM NO-LOCK                                     */
/*          WHERE ITEM.it-codigo = tt-ped-item.it-codigo NO-ERROR. */
/*                                                                 */
/*     IF AVAIL ITEM THEN DO:                                      */
/*         ASSIGN gr-item = ROWID(ITEM).                           */
/*         RUN enp/en0105.w.                                       */
/*     END.                                                        */
    FIND FIRST int-item NO-LOCK
         WHERE int-item.nr-ped-energia = string(tt-ped-venda.nr-pedcli) NO-ERROR.

    IF AVAIL int-item THEN DO:
        FIND FIRST ord-prod NO-LOCK
             WHERE ord-prod.nr-pedido = tt-ped-venda.nr-pedcli 
               AND ord-prod.it-codigo = int-item.it-codigo NO-ERROR.

        RUN pi-imprime-estrutura (INPUT tt-ped-item.it-codigo,
                                  INPUT ord-prod.nr-ord-prod,
                                  INPUT tt-ped-venda.nr-pedcli).
    END.
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


&Scoped-define SELF-NAME bt-faturar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-faturar w-cadsim
ON CHOOSE OF bt-faturar IN FRAME f-cad /* Faturar */
DO:
    FIND FIRST ped-venda NO-LOCK 
         WHERE ped-venda.nr-pedido = tt-ped-venda.nr-pedido NO-ERROR.
    
    IF AVAIL ped-venda THEN DO:

        IF NOT ped-venda.completo THEN DO:
            RUN dibo/bodi159com.p PERSISTENT SET h-bodi159com.
            RUN completeOrder IN h-bodi159com (INPUT  ROWID(ped-venda),
                                               OUTPUT TABLE rowErrors).
            DELETE PROCEDURE h-bodi159com.
        END.

        ASSIGN gr-ped-venda = ROWID(ped-venda).
        IF NOT VALID-HANDLE(h-ft4002) THEN DO:
            RUN ftp/ft4002.w PERSISTENT SET h-ft4002.
            RUN dispatch IN h-ft4002 ('initialize') no-error.
            RUN repositionRecord IN h-ft4002 (INPUT gr-ped-venda).
        END.
        ELSE
            RUN repositionRecord IN h-ft4002 (INPUT gr-ped-venda).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-folha-rosto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-folha-rosto w-cadsim
ON CHOOSE OF bt-folha-rosto IN FRAME f-cad /* Folha de Rosto */
DO:

   FIND FIRST int-item NO-LOCK
        WHERE int-item.nr-ped-energia = string(tt-ped-venda.nr-pedcli) NO-ERROR.
   
     IF AVAIL int-item THEN DO:
   
         FIND FIRST int-ped-venda NO-LOCK
              WHERE int-ped-venda.nr-pedido = tt-ped-venda.nr-pedido NO-ERROR.
   
         FIND LAST nota-fiscal NO-LOCK
             WHERE nota-fiscal.nome-ab-cli = tt-ped-venda.nome-abrev
               AND nota-fiscal.nr-pedcli   = tt-ped-venda.nr-pedcli NO-ERROR.
     
         FIND LAST volume-nf NO-LOCK 
             WHERE volume-nf.cod-estabel = nota-fiscal.cod-estabel
               AND volume-nf.serie       = nota-fiscal.serie
               AND volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.    
   
         FIND FIRST ord-prod NO-LOCK
              WHERE ord-prod.nr-pedido = tt-ped-venda.nr-pedcli 
                AND ord-prod.it-codigo = int-item.it-codigo NO-ERROR.
   
         RUN pi-folha-rosto-pdf (INPUT IF AVAIL ord-prod THEN ord-prod.nr-ord-produ ELSE 0,
                                 INPUT tt-ped-venda.nr-pedcli,
                                 INPUT IF AVAIL ord-prod THEN ord-prod.nr-ord-produ ELSE 0,
                                 INPUT int-item.it-codigo,
                                 INPUT IF AVAIL volume-nf THEN string(volume-nf.nr-volume) ELSE "",
                                 INPUT tt-ped-venda.nome-transp,
                                 INPUT IF AVAIL int-ped-venda THEN int-ped-venda.num-serie-solar ELSE "").
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


&Scoped-define SELF-NAME bt-libera-WMS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-libera-WMS w-cadsim
ON CHOOSE OF bt-libera-WMS IN FRAME f-cad /* Libera Saldo WMS */
DO: 
    DEFINE VARIABLE i-ordem-prod    AS INTEGER   NO-UNDO.
    DEFINE VARIABLE c-depos-destino AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-retorno       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE l-usuar-liber   AS LOGICAL   NO-UNDO.


    RUN pi-valida-antecip-fat-WMS (OUTPUT l-usuar-liber).

    IF NOT l-usuar-liber THEN DO:
        MESSAGE 'Usuario sem acesso para Antecipar Faturamento' SKIP(1) 
                'Procure pelo analista responsavel na TIC - Area de Sustentacao Totvs' 
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.

        RETURN NO-APPLY.
    END.


    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.            

    RUN pi-inicializar IN h-acomp (INPUT "Carregando Docto WMS").

    FOR EACH tt-itens-docto: DELETE tt-itens-docto. END.

    FIND FIRST ped-venda NO-LOCK 
         WHERE ped-venda.nr-pedido = int(tt-ped-venda.nr-pedido:SCREEN-VALUE IN BROWSE br-pedidos) NO-ERROR.

    IF NOT AVAIL ped-venda THEN LEAVE.
    
    FIND FIRST int-item NO-LOCK
         WHERE int-item.nr-ped-energia = ped-venda.nr-pedcli  NO-ERROR.

    IF AVAIL int-item THEN DO:
        FIND FIRST ord-prod NO-LOCK
             WHERE ord-prod.nr-pedido = ped-venda.nr-pedcli 
               AND ord-prod.it-codigo = int-item.it-codigo NO-ERROR.

        IF AVAIL ord-prod THEN
           ASSIGN i-ordem-prod = ord-prod.nr-ord-prod.
    END.

    RUN esp/es0018p.p (INPUT "esftp211":U,
                       INPUT 2,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).
    
    FOR EACH tt-prog-ponto:
        IF entry(1,tt-prog-ponto.conteudo,';') = tt-ped-venda.cod-estabel:SCREEN-VALUE IN BROWSE br-pedidos THEN
           ASSIGN c-deposito = entry(2,tt-prog-ponto.conteudo,';').
    END.
    
    FOR EACH wm-docto NO-LOCK 
        WHERE wm-docto.cod-estabel = tt-ped-venda.cod-estabel:SCREEN-VALUE IN BROWSE br-pedidos   /*estabelecimento do pedido de venda*/
          AND wm-docto.cod-local   = c-deposito             /*deposito de alocaá∆o da ordem CP0319 */
          AND wm-docto.num-docto   = string(i-ordem-prod)   /*numero da Ordem de Produá∆o*/
          AND wm-docto.ind-origem-docto = 19:               /*requisiá∆o material produá∆o */

         FOR EACH wm-docto-itens NO-LOCK
             WHERE wm-docto-itens.id-docto = wm-docto.id-docto: 

             RUN pi-acompanhar IN h-acomp (INPUT "Lendo Itens Docto WMS: " + wm-docto-itens.cod-item).
              
             IF AVAIL wm-docto-itens THEN DO:
                CREATE tt-itens-docto.
                BUFFER-COPY wm-docto-itens TO tt-itens-docto.
             END.
         END.
    END.

    RUN pi-finalizar in h-acomp.


    FIND FIRST tt-itens-docto NO-ERROR.

    IF NOT AVAIL tt-itens-docto THEN DO:
        MESSAGE 'Nao encontrado documento WMS'
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.

        RETURN 'ERROR'.
    END.                                      


    RUN esp/ftp/esftp211d.w (INPUT string(i-ordem-prod),
                             INPUT TABLE tt-itens-docto,
                             OUTPUT c-depos-destino,
                             OUTPUT c-retorno).

    IF c-retorno = '' THEN LEAVE.

    IF INDEX(c-retorno,'ERRO') = 0 THEN DO: 
         
        MESSAGE 'Transferencia realizada com Sucesso'
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

        FIND FIRST tt-itens-docto NO-ERROR.

        IF AVAIL tt-itens-docto THEN
        DO: 
            FIND FIRST wm-docto WHERE wm-docto.id-docto = tt-itens-docto.id-docto NO-LOCK NO-ERROR.

            IF AVAIL wm-docto THEN
            DO: 
                CREATE int-wm-docto.
                assign int-wm-docto.cod-estabel    = wm-docto.cod-estabel 
                       int-wm-docto.cod-local      = wm-docto.cod-local   
                       int-wm-docto.id-docto       = wm-docto.id-docto    
                       int-wm-docto.log-atualizado = YES.
                
                FOR EACH aloca-reserva EXCLUSIVE-LOCK 
                    WHERE aloca-reserva.nr-ord-prod = INT(wm-docto.num-docto):
                    ASSIGN aloca-reserva.cod-depos  = c-depos-destino.
                END.
                
                /*
                FOR EACH wm-docto-itens NO-LOCK
                    WHERE wm-docto-itens.id-docto = wm-docto.id-docto,
                    FIRST wm-local WHERE wm-local.cod-estabel = wm-docto-itens.cod-estabel
                                     AND wm-local.cod-local   = wm-docto-itens.cod-local NO-LOCK: 

                    /*
                    RUN openQueryStatic IN hProxy (INPUT "Main":U) NO-ERROR.

                    /*desfazer alocaá∆o ralizadas pela ordem de produá∆o no deposito do WMS*/
                    RUN desalocaProducao IN hProxy(INPUT wm-docto.num-docto,
                                                   INPUT wm-local.cod-deposito,
                                                   INPUT ROWID(wm-docto-itens), 
                                                   INPUT  wm-docto-itens.qtd-item,
                                                   OUTPUT TABLE ttAlocaReservaAux,
                                                   OUTPUT TABLE RowErrors).*/

                    /* Logica da API wmprx281 - Nao foi possivel utlizar a API pois a mesma olha a WM-BOX e neste momento esta tabela nao esta criada */
                    FIND FIRST saldo-estoq 
                         WHERE saldo-estoq.cod-depos   = wm-local.cod-deposito
                           AND saldo-estoq.it-codigo   = wm-docto-itens.cod-item
                           AND saldo-estoq.cod-estabel = wm-docto-itens.cod-estabel
                    EXCLUSIVE-LOCK NO-ERROR.

                    IF AVAIL saldo-estoq THEN
                       ASSIGN saldo-estoq.qt-aloc-prod = saldo-estoq.qt-aloc-prod - wm-docto-itens.qtd-item.
                END.*/

                IF VALID-HANDLE(hProxy) THEN DO:
                    RUN destroy IN hProxy.
                    ASSIGN hProxy = ?.
                END.                   
            END.
        END.

        FIND FIRST int-ped-venda EXCLUSIVE-LOCK 
             WHERE int-ped-venda.nr-pedido = int(tt-ped-venda.nr-pedido:SCREEN-VALUE IN BROWSE br-pedidos) NO-ERROR.

        IF AVAIL int-ped-venda THEN
        DO:
           ASSIGN int-ped-venda.ind-status-solar = 4.
           //RUN pi-carrega.

           ASSIGN tt-ped-venda.des-sit-solar:SCREEN-VALUE IN BROWSE br-pedidos = "Aguardando Faturamento"

                  tt-ped-venda.des-sit-solar:FGCOLOR IN BROWSE br-pedidos = 2
                  tt-ped-venda.nr-pedido:FGCOLOR IN BROWSE br-pedidos = 2
                  tt-ped-venda.dt-implant:FGCOLOR IN BROWSE br-pedidos = 2
                  tt-ped-venda.cod-emitente:FGCOLOR IN BROWSE br-pedidos = 2
                  tt-ped-venda.nome-abrev:FGCOLOR IN BROWSE br-pedidos = 2
                  c-item-pai:FGCOLOR IN BROWSE br-pedidos = 2
                  c-sit-docto:FGCOLOR IN BROWSE br-pedidos = 2
                  tt-ped-venda.estado:FGCOLOR IN BROWSE br-pedidos = 2
                  tt-ped-venda.no-ab-reppri:FGCOLOR IN BROWSE br-pedidos = 2
                  tt-ped-venda.cod-estabel:FGCOLOR IN BROWSE br-pedidos = 2
                  tt-ped-venda.cod-cond-pag:FGCOLOR IN BROWSE br-pedidos = 2
                  tt-ped-venda.vl-tot-ped:FGCOLOR IN BROWSE br-pedidos = 2
                  tt-ped-venda.vlr-comissao:FGCOLOR IN BROWSE br-pedidos = 2
                  tt-ped-venda.vl-serv-inst:FGCOLOR IN BROWSE br-pedidos = 2
                  tt-ped-venda.des-sit-ped:FGCOLOR IN BROWSE br-pedidos = 2
                  tt-ped-venda.des-sit-solar:FGCOLOR IN BROWSE br-pedidos = 2
                  tt-ped-venda.dt-entrega:FGCOLOR IN BROWSE br-pedidos = 2
                  tt-ped-venda.nat-operacao:FGCOLOR IN BROWSE br-pedidos = 2
                  tt-ped-venda.nome-transp:FGCOLOR IN BROWSE br-pedidos = 2
                  tt-ped-venda.cod-projeto:FGCOLOR IN BROWSE br-pedidos = 2 NO-ERROR.

           FIND FIRST tt-ped-venda 
                WHERE tt-ped-venda.nr-pedido = int-ped-venda.nr-pedido
           NO-ERROR.

           IF AVAIL tt-ped-venda THEN DO:
               ASSIGN tt-ped-venda.des-sit-solar = "Aguardando Faturamento".

               //{&open-query-br-pedidos}
               APPLY "value-changed" TO br-pedidos IN FRAME f-cad.
           END.


        END.              
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-liberar-pagto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-liberar-pagto w-cadsim
ON CHOOSE OF bt-liberar-pagto IN FRAME f-cad /* Lib. Financeiro */
DO:
    FIND FIRST ped-venda NO-LOCK
         WHERE ped-venda.nr-pedido = tt-ped-venda.nr-pedido NO-ERROR.

    RUN esp/ftp/esftp211b.w(INPUT ROWID(ped-venda)).

    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-nota-fiscal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-nota-fiscal w-cadsim
ON CHOOSE OF bt-nota-fiscal IN FRAME f-cad /* Notas Fiscais */
DO:
    FIND FIRST ped-venda NO-LOCK 
         WHERE ped-venda.nr-pedido = tt-ped-venda.nr-pedido NO-ERROR.
    
    IF AVAIL ped-venda THEN DO:
        ASSIGN gr-ped-venda = ROWID(ped-venda).
        RUN esp/pdp/espdp007.w.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-observacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-observacao w-cadsim
ON CHOOSE OF bt-observacao IN FRAME f-cad /* Observaá∆o */
DO:
    FIND FIRST ped-venda NO-LOCK
         WHERE ped-venda.nr-pedido = tt-ped-venda.nr-pedido NO-ERROR.

    RUN esp/ftp/esftp211c.w(INPUT ROWID(ped-venda)).
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


&Scoped-define SELF-NAME bt-ord-prod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ord-prod w-cadsim
ON CHOOSE OF bt-ord-prod IN FRAME f-cad /* Sumarizar */
DO:
    FIND FIRST int-item NO-LOCK
         WHERE int-item.nr-ped-energia = string(tt-ped-venda.nr-pedcli) NO-ERROR.

    IF AVAIL int-item THEN DO:
        FIND FIRST ord-prod NO-LOCK
             WHERE ord-prod.nr-pedido = tt-ped-venda.nr-pedcli 
               AND ord-prod.it-codigo = int-item.it-codigo NO-ERROR.

        IF AVAIL ord-prod THEN DO:
            ASSIGN gr-ord-prod = ROWID(ord-prod).
            RUN cpp/CP0304.w.
        END.
    END.

    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-rep-ord
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-rep-ord w-cadsim
ON CHOOSE OF bt-rep-ord IN FRAME f-cad /* Reportar Ordem */
DO:
    FIND FIRST int-item NO-LOCK
         WHERE int-item.nr-ped-energia = string(tt-ped-venda.nr-pedcli) NO-ERROR.

    IF AVAIL int-item THEN DO:
        FIND FIRST ord-prod NO-LOCK
             WHERE ord-prod.nr-pedido = tt-ped-venda.nr-pedcli 
               AND ord-prod.it-codigo = int-item.it-codigo NO-ERROR.

        IF AVAIL ord-prod THEN DO:
            ASSIGN gr-ord-prod = ROWID(ord-prod).
            RUN cpp/CP0311.w.
        END.
    END.

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
    RUN esp\ftp\esftp211e(OUTPUT l-verifica-saldo).
    
    RUN pi-excel(INPUT l-verifica-saldo). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSelecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSelecao w-cadsim
ON CHOOSE OF btSelecao IN FRAME f-cad /* Seleá∆o */
DO:
   RUN esp/ftp/esftp211a.w (INPUT-OUTPUT c-cod-estabel-ini,
                            INPUT-OUTPUT c-cod-estabel-fim,
                            INPUT-OUTPUT d-dt-implant-ini,
                            INPUT-OUTPUT d-dt-implant-fim,
                            INPUT-OUTPUT i-cod-emitente-ini,
                            INPUT-OUTPUT i-cod-emitente-fim,
                            INPUT-OUTPUT i-nr-pedido-ini,
                            INPUT-OUTPUT i-nr-pedido-fim,
                            INPUT-OUTPUT l-tg-aberto,
                            INPUT-OUTPUT l-tg-atendido-parc,
                            INPUT-OUTPUT l-tg-atendido-tot,
                            INPUT-OUTPUT l-tg-pendente,
                            INPUT-OUTPUT l-tg-suspenso,
                            INPUT-OUTPUT l-tg-cancelado,
                            INPUT-OUTPUT l-tg-aguardando-lib,
                            INPUT-OUTPUT l-tg-aguardando-ger-fci,
                            INPUT-OUTPUT l-tg-aguardando-sep,
                            INPUT-OUTPUT l-tg-lib-fat,
                            INPUT-OUTPUT l-tg-faturado,
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


&Scoped-define BROWSE-NAME br-ped-item
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
  ENABLE rt-button rt-button-2 rt-button-3 RECT-7 RECT-8 btExcel btSelecao 
         btAtualiza bt-exit br-pedidos bt-detalhar bt-liberar-pagto bt-faturar 
         bt-nota-fiscal bt-observacao bt-libera-WMS br-ped-item bt-detalhar-it 
         bt-estrutura bt-ord-prod bt-rep-ord bt-estoque bt-folha-rosto bt-ok 
         bt-cancela 
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

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}

  {utp/ut9000.i "ESFTP211" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN dispatch  IN this-procedure ('enable-fields':U).
  ASSIGN bt-libera-WMS:SENSITIVE IN FRAME f-cad = NO.

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
EMPTY TEMP-TABLE tt-ped-venda.
EMPTY TEMP-TABLE tt-ped-item.
EMPTY TEMP-TABLE tt-itens-saldo.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  

RUN pi-inicializar IN h-acomp (INPUT "Carregando Pedidos").

FOR EACH int-ped-venda NO-LOCK
   WHERE int-ped-venda.cod-projeto <> ""
     AND int-ped-venda.nr-pedido   >= i-nr-pedido-ini
     AND int-ped-venda.nr-pedido   <= i-nr-pedido-fim,
   FIRST ped-venda NO-LOCK
   WHERE ped-venda.nr-pedido     = int-ped-venda.nr-pedido
     AND ped-venda.cod-estabel  >= c-cod-estabel-ini
     AND ped-venda.cod-estabel  <= c-cod-estabel-fim
     AND ped-venda.dt-implant   >= d-dt-implant-ini
     AND ped-venda.dt-implant   <= d-dt-implant-fim
     AND ped-venda.cod-emitente >= i-cod-emitente-ini
     AND ped-venda.cod-emitente <= i-cod-emitente-fim:

    FIND FIRST int-item NO-LOCK
         WHERE int-item.nr-ped-energia = string(ped-venda.nr-pedido) NO-ERROR.
    IF NOT AVAIL int-item THEN NEXT.

    RUN pi-acompanhar IN h-acomp (INPUT "Pedido: " + ped-venda.nr-pedcli).

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


    IF  NOT l-tg-aguardando-lib 
    AND int-ped-venda.ind-status-solar = 1 THEN
        NEXT.

    IF  NOT l-tg-aguardando-ger-fci 
    AND int-ped-venda.ind-status-solar = 2 THEN
        NEXT.

    IF  NOT l-tg-aguardando-sep 
    AND int-ped-venda.ind-status-solar = 3 THEN
        NEXT.

    IF  NOT l-tg-lib-fat 
    AND int-ped-venda.ind-status-solar = 4 THEN
        NEXT.

    IF  NOT l-tg-faturado 
    AND int-ped-venda.ind-status-solar = 5 THEN
        NEXT.
    
    CREATE tt-ped-venda.
    BUFFER-COPY ped-venda TO tt-ped-venda.

    ASSIGN tt-ped-venda.des-sit-ped      = {diinc/i03di149.i 04 ped-venda.cod-sit-ped}
           tt-ped-venda.vlr-comissao     = int-ped-venda.vlr-comissao
           tt-ped-venda.cod-projeto      = int-ped-venda.cod-projeto
           tt-ped-venda.vl-serv-inst     = int-ped-venda.vl-serv-inst
           tt-ped-venda.ind-status-solar = int-ped-venda.ind-status-solar.

    IF int-ped-venda.ind-status-solar = 1 THEN 
        ASSIGN tt-ped-venda.des-sit-solar = "Aguardando Lib. Financeira".

    IF int-ped-venda.ind-status-solar = 2 THEN 
        ASSIGN tt-ped-venda.des-sit-solar = "Aguardando Geraá∆o FCI".

    IF int-ped-venda.ind-status-solar = 3 THEN 
        ASSIGN tt-ped-venda.des-sit-solar = "Aguardando Separaá∆o".

    IF int-ped-venda.ind-status-solar = 4 THEN 
        ASSIGN tt-ped-venda.des-sit-solar = "Aguardando Faturamento".

    IF int-ped-venda.ind-status-solar = 5 THEN 
        ASSIGN tt-ped-venda.des-sit-solar = "Faturado".

    FOR EACH ped-item OF ped-venda NO-LOCK:
        FIND FIRST tt-itens-saldo 
             WHERE tt-itens-saldo.it-codigo   = ped-item.it-codigo
               AND tt-itens-saldo.cod-estabel = ped-venda.cod-estabel NO-ERROR.
        IF NOT AVAIL tt-itens-saldo THEN DO:
            CREATE tt-itens-saldo.
            ASSIGN tt-itens-saldo.it-codigo   = ped-item.it-codigo
                   tt-itens-saldo.cod-estabel = ped-venda.cod-estabel
                   tt-itens-saldo.qt-disp     = fnEstoque(ped-venda.cod-estabel, ped-item.it-codigo, "WFT", "", NO).
        END.
    END.

END.

{&open-query-br-pedidos}
APPLY "value-changed" TO br-pedidos IN FRAME f-cad.

RUN pi-finalizar in h-acomp.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-itens w-cadsim 
PROCEDURE pi-carrega-itens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tt-ped-item.

FOR EACH ped-item OF tt-ped-venda:

    CREATE tt-ped-item.
    BUFFER-COPY ped-item TO tt-ped-item.
END.

{&open-query-br-ped-item}

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
DEFINE INPUT PARAM pVerificaSaldo AS LOG NO-UNDO.

DEFINE VARIABLE c-ordem   AS CHAR NO-UNDO.
DEFINE VARIABLE c-arquivo AS CHARACTER   NO-UNDO.

DEFINE VAR c-itens AS CHAR NO-UNDO. /*itens sem saldo disponivel*/

ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "eswso0004" + STRING(TIME) + ".csv".
OUTPUT TO VALUE(c-arquivo) NO-CONVERT.

/*Exorta Pedidos*/
IF pVerificaSaldo THEN
   PUT UNFORMATTED "Pedido;Implantaá∆o;Emitente;Nome;Item Pai;Ord Prod;Estado;Representante;Estabelecimento;Cond. Pagto.;Valor Total;Valor Comiss;Valor Serv;Situaá∆o;Sit Solar;Entrega;Nat Oper;Transp;Projeto;Itens sem saldo" SKIP.
ELSE
   PUT UNFORMATTED "Pedido;Implantaá∆o;Emitente;Nome;Item Pai;Ord Prod;Estado;Representante;Estabelecimento;Cond. Pagto.;Valor Total;Valor Comiss;Valor Serv;Situaá∆o;Sit Solar;Entrega;Nat Oper;Transp;Projeto" SKIP.

FOR EACH tt-ped-venda:

    IF pVerificaSaldo THEN DO:

       ASSIGN c-itens = "".
       FOR EACH ped-item OF tt-ped-venda NO-LOCK:

           IF  fnItemPai(tt-ped-venda.nr-pedido) = ped-item.it-codigo THEN NEXT.

           FIND FIRST tt-itens-saldo
                WHERE tt-itens-saldo.it-codigo   = ped-item.it-codigo
                  AND tt-itens-saldo.cod-estabel = tt-ped-venda.cod-estabel NO-ERROR.
           IF AVAIL tt-itens-saldo THEN DO:
              IF tt-itens-saldo.qt-disp < (ped-item.qt-pedida - ped-item.qt-atendida) THEN DO:
                 IF c-itens = "" THEN
                     ASSIGN c-itens = ped-item.it-codigo + "-" + string(ped-item.qt-pedida).
                 ELSE
                     ASSIGN c-itens = c-itens + "|" + ped-item.it-codigo + "-" + string(ped-item.qt-pedida).
              END.
           END.
       END.
    END.


    ASSIGN c-ordem = "".
    FIND FIRST int-item NO-LOCK
         WHERE int-item.nr-ped-energia = tt-ped-venda.nr-pedcli NO-ERROR.
    IF AVAIL int-item THEN DO:
        FIND FIRST ord-prod NO-LOCK
             WHERE ord-prod.nr-pedido = tt-ped-venda.nr-pedcli
               AND ord-prod.it-codigo = int-item.it-codigo NO-ERROR.
        IF AVAIL ord-prod THEN
            ASSIGN c-ordem = string(ord-prod.nr-ord-prod).
    END.

    PUT UNFORMATTED string(tt-ped-venda.nr-pedido   ) + ";" +
                    string(tt-ped-venda.dt-implant  ) + ";" +
                    string(tt-ped-venda.cod-emitente) + ";" +
                    string(tt-ped-venda.nome-abrev  ) + ";" +
                    fnItemPai(tt-ped-venda.nr-pedido) + ";" +
                    STRING(c-ordem)                   + ";" +
                    string(tt-ped-venda.estado      ) + ";" +
                    string(tt-ped-venda.no-ab-reppri) + ";" +
                    string(tt-ped-venda.cod-estabel ) + ";" +
                    string(tt-ped-venda.cod-cond-pag) + ";" +
                    string(tt-ped-venda.vl-tot-ped  ) + ";" +
                    string(tt-ped-venda.vlr-comissao) + ";" +
                    string(tt-ped-venda.vl-serv-inst) + ";" +
                    string(tt-ped-venda.des-sit-ped ) + ";" +
                    string(tt-ped-venda.des-sit-solar) + ";" +
                    string(tt-ped-venda.dt-entrega  ) + ";" +
                    string(tt-ped-venda.nat-operacao) + ";" +
                    string(tt-ped-venda.nome-transp ) + ";" +
                    string(tt-ped-venda.cod-projeto ) + ";" + 
                    c-itens SKIP.

    
END.

OUTPUT CLOSE.

OS-COMMAND NO-WAIT VALUE(c-arquivo) NO-ERROR.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-folha-rosto w-cadsim 
PROCEDURE pi-folha-rosto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-nr-ord-produ  LIKE ord-prod.nr-ord-produ.
    DEFINE INPUT PARAM p-nr-pedcli     LIKE ped-venda.nr-pedcli .
    DEFINE INPUT PARAM p-ean           AS CHAR.
    DEFINE INPUT PARAM p-it-codigo     LIKE int-item.it-codigo.
    DEFINE INPUT PARAM p-volumes       AS CHAR.
    DEFINE INPUT PARAM p-transp        AS CHAR.

    DEFINE VARIABLE c-arquivo AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE AppWord   AS COM-HANDLE       NO-UNDO.
        
    ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "/esftp211-" + STRING(TIME) + ".docx".
    
    OS-COPY VALUE(SEARCH("esp/ftp/esftp211.docx")) VALUE(c-arquivo).
    
    CREATE "Word.Application" AppWord.
    AppWord:Documents:OPEN(c-arquivo).
    AppWord:VISIBLE = FALSE.
    
    AppWord:Selection:Font:bold = 1.
    AppWord:Selection:Font:Name = "Calibri" .
    AppWord:Selection:Font:Size = 35.
    AppWord:Selection:ParagraphFormat:Alignment = 1.
    AppWord:Selection:TypeParagraph().
    AppWord:Selection:TypeText("ORDEM: " + STRING(p-nr-ord-produ)).
    AppWord:Selection:TypeParagraph().
    AppWord:Selection:TypeParagraph().
    
    AppWord:Selection:Font:bold = 0.
    AppWord:Selection:Font:Size = 130.
    AppWord:Selection:Font:Name = "EAN-13 Half Height".
    AppWord:Selection:TypeText(p-ean).
    AppWord:Selection:Font:Size = 35.
    AppWord:Selection:Font:bold = 1.
    AppWord:Selection:TypeParagraph().
    AppWord:Selection:TypeParagraph().
    
    AppWord:Selection:Font:Name = "Calibri" .
    AppWord:Selection:TypeText("(Pedido Venda: " + p-nr-pedcli + ")").
    AppWord:Selection:TypeParagraph().
    AppWord:Selection:TypeParagraph().
    
    AppWord:Selection:Font:UNDERLINE = 1.
    AppWord:Selection:TypeText("ITEM: " + p-it-codigo).
    AppWord:Selection:TypeParagraph().
    AppWord:Selection:TypeParagraph().

    AppWord:Selection:Font:UNDERLINE = 0.
    AppWord:Selection:TypeText(p-volumes + " VOLUMES").
    AppWord:Selection:TypeParagraph().
    AppWord:Selection:TypeParagraph().

    AppWord:Selection:TypeText(p-transp).
    
    AppWord:ActiveDocument:Save().
    AppWord:ActiveDocument:CLOSE.                                /* Fecha o arquivo do WORD */
    AppWord:QUIT().                                              /* Fechar o WORD */
    RELEASE OBJECT AppWord. 

    OS-COMMAND NO-WAIT VALUE(c-arquivo) NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-folha-rosto-pdf w-cadsim 
PROCEDURE pi-folha-rosto-pdf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-nr-ord-produ  LIKE ord-prod.nr-ord-produ.
    DEFINE INPUT PARAM p-nr-pedcli     LIKE ped-venda.nr-pedcli .
    DEFINE INPUT PARAM p-ean           AS CHAR.
    DEFINE INPUT PARAM p-it-codigo     LIKE int-item.it-codigo.
    DEFINE INPUT PARAM p-volumes       AS CHAR.
    DEFINE INPUT PARAM p-transp        AS CHAR.
    DEFINE INPUT PARAM p-nr-serie-gerador AS CHAR.

    DEFINE VARIABLE h-bcapi016    AS HANDLE      NO-UNDO.
    DEFINE VARIABLE c-arq-pdf     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-bar-code    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-bar-gerador AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE c-arquivo AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE AppWord   AS COM-HANDLE       NO-UNDO.

    RUN bcp/bcapi016.p PERSISTENT SET h-bcapi016.
    RUN generateCODE128C IN h-bcapi016 (TRIM(p-ean),OUTPUT c-bar-code).
    RUN generateCODE128C IN h-bcapi016 (TRIM(p-nr-serie-gerador), OUTPUT c-bar-gerador).
    DELETE PROCEDURE h-bcapi016.
        
    ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "/esftp211-" + STRING(TIME) + ".pdf".

    RUN pdf_new ("Spdf",c-arquivo).
    RUN pdf_set_PaperType("Spdf","A4").
    RUN pdf_new_page("Spdf").
    RUN pdf_load_font ("Spdf","IQsCode128","c:\windows\fonts\dc-code128.ttf", "PDFinclude/dc-code128.afm","").

    RUN pdf_set_font("Spdf","Courier-bold", 50).
    RUN pdf_text_align("Spdf", "ORDEM: " + STRING(p-nr-ord-produ),"CENTER",300,750).

    RUN pdf_set_font ("Spdf", "IQsCode128",100).
    RUN pdf_text_align("Spdf", c-bar-code,"CENTER",190,600).
    
    RUN pdf_set_font("Spdf","Courier-bold", 40).
    RUN pdf_text_align("Spdf", "(Pedido Venda: " + p-nr-pedcli + ")","CENTER",320,500).

    RUN pdf_text_align("Spdf", "ITEM: " + p-it-codigo,"CENTER",300,350).

    IF p-nr-serie-gerador <> "" THEN DO:
        //RUN pdf_set_font ("Spdf", "IQsCode128",50).
        RUN pdf_text_align("Spdf", "NS Gerador:" + p-nr-serie-gerador ,"CENTER",305,130).
        RUN pdf_text_align("Spdf", c-bar-gerador,"CENTER",100,600).
    END.

    IF p-volumes <> "" THEN
        RUN pdf_text_align("Spdf", p-volumes + " VOLUMES","CENTER",300,200).

    RUN pdf_text_align("Spdf", p-transp,"CENTER",300,50).


    RUN pdf_close ("Spdf").
    
/*     AppWord:Selection:Font:bold = 1.                                                           */
/*     AppWord:Selection:Font:Name = "Calibri" .                                                  */
/*     AppWord:Selection:Font:Size = 35.                                                          */
/*     AppWord:Selection:ParagraphFormat:Alignment = 1.                                           */
/*     AppWord:Selection:TypeParagraph().                                                         */
/*     AppWord:Selection:TypeText("ORDEM: " + STRING(p-nr-ord-produ)).                            */
/*     AppWord:Selection:TypeParagraph().                                                         */
/*     AppWord:Selection:TypeParagraph().                                                         */
/*                                                                                                */
/*     AppWord:Selection:Font:bold = 0.                                                           */
/*     AppWord:Selection:Font:Size = 130.                                                         */
/*     AppWord:Selection:Font:Name = "EAN-13 Half Height".                                        */
/*     AppWord:Selection:TypeText(p-ean).                                                         */
/*     AppWord:Selection:Font:Size = 35.                                                          */
/*     AppWord:Selection:Font:bold = 1.                                                           */
/*     AppWord:Selection:TypeParagraph().                                                         */
/*     AppWord:Selection:TypeParagraph().                                                         */
/*                                                                                                */
/*     AppWord:Selection:Font:Name = "Calibri" .                                                  */
/*     AppWord:Selection:TypeText("(Pedido Venda: " + p-nr-pedcli + ")").                         */
/*     AppWord:Selection:TypeParagraph().                                                         */
/*     AppWord:Selection:TypeParagraph().                                                         */
/*                                                                                                */
/*     AppWord:Selection:Font:UNDERLINE = 1.                                                      */
/*     AppWord:Selection:TypeText("ITEM: " + p-it-codigo).                                        */
/*     AppWord:Selection:TypeParagraph().                                                         */
/*     AppWord:Selection:TypeParagraph().                                                         */
/*                                                                                                */
/*     AppWord:Selection:Font:UNDERLINE = 0.                                                      */
/*     AppWord:Selection:TypeText(p-volumes + " VOLUMES").                                        */
/*     AppWord:Selection:TypeParagraph().                                                         */
/*     AppWord:Selection:TypeParagraph().                                                         */
/*                                                                                                */
/*     AppWord:Selection:TypeText(p-transp).                                                      */
/*                                                                                                */
/*     AppWord:ActiveDocument:Save().                                                             */
/*     AppWord:ActiveDocument:CLOSE.                                /* Fecha o arquivo do WORD */ */
/*     AppWord:QUIT().                                              /* Fechar o WORD */           */
/*     RELEASE OBJECT AppWord.                                                                    */

    OS-COMMAND NO-WAIT VALUE(c-arquivo) NO-ERROR.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-imprime-estrutura w-cadsim 
PROCEDURE pi-imprime-estrutura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-it-codigo AS CHAR.
    DEFINE INPUT PARAM p-nr-ord-prod LIKE ord-prod.nr-ord-prod.
    DEFINE INPUT PARAM p-nr-pedido LIKE ped-venda.nr-pedido.

    DEFINE VARIABLE i-linha AS INTEGER       NO-UNDO.
    DEFINE VARIABLE c-arq-pdf AS CHARACTER   NO-UNDO.

    ASSIGN c-arq-pdf = SESSION:TEMP-DIRECTORY + "estrutura_" + p-it-codigo + "_" + STRING(TIME) + ".pdf".

    RUN pdf_new ("Spdf",c-arq-pdf).
    RUN pdf_set_PaperType("Spdf","A4").
    RUN pdf_set_Orientation("Spdf","Landscape").
   
    RUN pdf_new_page("Spdf"). 

    RUN pdf_set_font("Spdf","Courier-bold", 17). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Estrutura do Item: " + p-it-codigo,  40,  pdf_PageHeight("Spdf") - 60).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Ordem: " + string(p-nr-ord-prod),  162,  pdf_PageHeight("Spdf") - 75).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Pedido: " + string(p-nr-pedido),  152,  pdf_PageHeight("Spdf") - 90).                      

    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               pdf_PageHeight("Spdf") - 113 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               18, /* Height */ 
                               1  /* Weight */).

    
    ASSIGN i-linha = 482.

    RUN pdf_set_font("Spdf","Courier-bold", 17). 
    /*RUN pdf_text_xy IN h_PDFinc ("Spdf","Seq",  40,  pdf_PageHeight("Spdf") - 107).      */                
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Item",  15,  pdf_PageHeight("Spdf") - 107).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Descriá∆o",  100,  pdf_PageHeight("Spdf") - 107).                      
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Quantidade",  720,  pdf_PageHeight("Spdf") - 107).                      

    /*Solar, somente 1 item*/

    FOR EACH estrutura NO-LOCK
        WHERE estrutura.it-codigo = p-it-codigo:

        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = estrutura.es-codigo NO-ERROR.

        ASSIGN i-linha = i-linha - 17.
        RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                                    5,    /*From Column*/
                                    i-linha /*From  Row*/,
                                    pdf_PageWidth("Spdf") - 10 /*Width*/,
                                    17, /* Height */ 
                                    1  /* Weight */).

        RUN pdf_set_font("Spdf","Courier", 17). 
        RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(estrutura.es-codigo),  15,  i-linha + 4).     
/*         RUN pdf_text_xy IN h_PDFinc ("Spdf",estrutura.es-codigo,  90,  i-linha + 4). */
        RUN pdf_text_xy IN h_PDFinc ("Spdf",ITEM.desc-item,  100,  i-linha + 4).                      
        RUN pdf_text_xy IN h_PDFinc ("Spdf",string(estrutura.quant-usada),  720,  i-linha + 4).                      

    END.
    

    RUN pdf_close ("Spdf").  

    OS-COMMAND NO-WAIT VALUE(c-arq-pdf) NO-ERROR.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-antecip-fat-WMS w-cadsim 
PROCEDURE pi-valida-antecip-fat-WMS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAM p-usuar-liber AS LOG NO-UNDO.

RUN esp/es0018p.p (INPUT "esftp211":U,
                              INPUT 3,
                              INPUT 0,
                              INPUT "":U,
                              OUTPUT TABLE tt-prog-ponto).

ASSIGN p-usuar-liber = NO.
  
FOR EACH usuar_mestre NO-LOCK
    WHERE usuar_mestre.cod_usuario = c-seg-usuario,
    EACH usuar_grp_usuar   OF  usuar_mestre NO-LOCK ,
    EACH grp_usuar WHERE grp_usuar.cod_grp_usuar = usuar_grp_usuar.cod_grp_usuar NO-LOCK,
    EACH prog_dtsul_segur NO-LOCK
    WHERE prog_dtsul_segur.cod_grp_usuar = usuar_grp_usuar.cod_grp_usuar 
    BREAK BY  grp_usuar.cod_grp_usuar:

    IF FIRST-OF(grp_usuar.cod_grp_usuar) THEN DO:
       FIND FIRST tt-prog-ponto WHERE tt-prog-ponto.conteudo = grp_usuar.cod_grp_usuar NO-ERROR.
       
       IF AVAIL tt-prog-ponto THEN
          ASSIGN p-usuar-liber = YES.
    END.                             
END.                                 


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
  {src/adm/template/snd-list.i "tt-ped-venda"}
  {src/adm/template/snd-list.i "int-ped-venda"}
  {src/adm/template/snd-list.i "tt-ped-item"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnOrdProd w-cadsim 
FUNCTION fnOrdProd RETURNS CHARACTER
  ( p-nr-pedcli AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    FIND FIRST int-item NO-LOCK
         WHERE int-item.nr-ped-energia = string(p-nr-pedcli) NO-ERROR.

    IF AVAIL int-item THEN DO:
        FIND FIRST ord-prod NO-LOCK
             WHERE ord-prod.nr-pedido = STRING(p-nr-pedcli)
               AND ord-prod.it-codigo = int-item.it-codigo NO-ERROR.
    END.

    IF AVAIL ord-prod THEN 
        RETURN STRING(ord-prod.nr-ord-prod).
    ELSE 
        RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION FnRetornaNF w-cadsim 
FUNCTION FnRetornaNF RETURNS CHARACTER
  (c-nome-abrev AS CHAR, c-num-ped AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FIND FIRST nota-fiscal NO-LOCK 
       WHERE nota-fiscal.nome-ab-cli       = c-nome-abrev
         AND nota-fiscal.nr-pedcli         = c-num-ped 
         AND nota-fiscal.idi-sit-nf-eletro = 3 NO-ERROR. //buscar a nota autorizada

  IF AVAIL nota-fiscal THEN
     RETURN nota-fiscal.nr-nota-fis.
  ELSE 
     RETURN ''.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION FnSitDocWMS w-cadsim 
FUNCTION FnSitDocWMS RETURNS CHARACTER
  ( c-estab AS CHAR, c-docto AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  ASSIGN i-cont = 0. 

  RUN esp/es0018p.p (INPUT "esftp211":U,
                     INPUT 2,
                     INPUT 0,
                     INPUT "":U,
                     OUTPUT TABLE tt-prog-ponto).
  
  FOR EACH tt-prog-ponto:
      IF entry(1,tt-prog-ponto.conteudo,';') = c-estab THEN
         ASSIGN c-deposito = entry(2,tt-prog-ponto.conteudo,';').
  END.

  FOR EACH wm-docto NO-LOCK 
      WHERE wm-docto.cod-estabel = c-estab
        AND wm-docto.cod-local   = c-deposito /*deposito de alocaá∆o da ordem CP0319 */
        AND wm-docto.num-docto   = c-docto    /*numero da Ordem de Produá∆o*/
        AND wm-docto.ind-origem-docto = 19:   /*requisiá∆o material produá∆o */
      
      ASSIGN i-cont = i-cont + 1.

      IF wm-docto.ind-sit-docto = 1 THEN
         RETURN 'Pendente'.
      ELSE
         RETURN 'Separado'.
  END.

  IF i-cont = 0 THEN RETURN ''.

  

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

