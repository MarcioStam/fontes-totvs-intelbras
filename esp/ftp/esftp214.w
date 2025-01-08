&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgmov            PROGRESS
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME w-cadsim


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-int-pv-canal NO-UNDO LIKE int-pv-canal
       field periodo-meta as char
       field qt-faturada-disp as dec
       field r-rowid as rowid
       .
DEFINE TEMP-TABLE tt-ped-carteira NO-UNDO LIKE ped-item
       field cod-estabel like ped-venda.cod-estabel
       field tp-pedido like ped-venda.tp-pedido
       field cod-priori like ped-venda.cod-priori
       field no-ab-reppri like ped-venda.no-ab-reppri
       field nome-transp like  ped-venda.nome-transp
       field cod-cond-pag like ped-venda.cod-cond-pag
       field dt-implant like ped-venda.dt-implant
       field qt-saldo like ped-item.qt-pedida
       field dt-fim as date
       field seq as int
       index ch-pri is primary unique seq.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadsim 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esftp214 2.00.00.000}

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

/* Local Variable Definitions ---                                       */
define variable wh-imprime as handle no-undo.
DEF NEW GLOBAL SHARED VAR gr-ped-venda      AS ROWID         NO-UNDO.
def new global shared var gr-item as rowid no-undo.
DEFINE VARIABLE h-pd4000      AS HANDLE NO-UNDO.

DEF VAR c-periodo-ini   AS CHAR.
DEF VAR i-cod-canal-ini AS INT INIT 0.
DEF VAR i-cod-canal-fim AS INT INIT 999.
DEF VAR v-it-codigo-ini AS CHAR INIT "".
DEF VAR v-it-codigo-fim AS CHAR INIT "ZZZZZZZZZZZZZZZZ".
DEF VAR i-item-meta     AS INT INIT 3.
DEF VAR l-openquery     AS LOG.
DEF VAR d-data-ini-meta AS DATE.
DEF VAR d-data-fim-meta AS DATE.

ASSIGN c-periodo-ini = string(MONTH(TODAY),"99") + STRING(YEAR(TODAY)).

DEFINE VARIABLE c-desc-canal AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-desc-item  AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-int-pv-canal-param LIKE int-pv-canal.
{esp/es0018.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME br-metas

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-int-pv-canal tt-ped-carteira

/* Definitions for BROWSE br-metas                                      */
&Scoped-define FIELDS-IN-QUERY-br-metas tt-int-pv-canal.dt-ini-meta tt-int-pv-canal.dt-fim-meta tt-int-pv-canal.cod-canal fnDescCanal(tt-int-pv-canal.cod-canal) @ c-desc-canal tt-int-pv-canal.it-codigo fnDescItem(tt-int-pv-canal.it-codigo) @ c-desc-item tt-int-pv-canal.qt-meta tt-int-pv-canal.qt-faturada-disp tt-int-pv-canal.qt-carteira tt-int-pv-canal.dt-entrega-item   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-metas   
&Scoped-define SELF-NAME br-metas
&Scoped-define QUERY-STRING-br-metas FOR EACH tt-int-pv-canal
&Scoped-define OPEN-QUERY-br-metas OPEN QUERY {&SELF-NAME} FOR EACH tt-int-pv-canal.
&Scoped-define TABLES-IN-QUERY-br-metas tt-int-pv-canal
&Scoped-define FIRST-TABLE-IN-QUERY-br-metas tt-int-pv-canal


/* Definitions for BROWSE br-pedidos                                    */
&Scoped-define FIELDS-IN-QUERY-br-pedidos tt-ped-carteira.cod-estabel tt-ped-carteira.nr-pedcli tt-ped-carteira.nome-abrev tt-ped-carteira.tp-pedido tt-ped-carteira.cod-priori tt-ped-carteira.no-ab-reppri tt-ped-carteira.nome-transp tt-ped-carteira.cod-cond-pag tt-ped-carteira.dt-implant tt-ped-carteira.dt-entorig tt-ped-carteira.dt-entrega tt-ped-carteira.qt-pedida tt-ped-carteira.qt-atendida tt-ped-carteira.qt-saldo   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-pedidos   
&Scoped-define SELF-NAME br-pedidos
&Scoped-define QUERY-STRING-br-pedidos FOR EACH tt-ped-carteira
&Scoped-define OPEN-QUERY-br-pedidos OPEN QUERY {&SELF-NAME} FOR EACH tt-ped-carteira.
&Scoped-define TABLES-IN-QUERY-br-pedidos tt-ped-carteira
&Scoped-define FIRST-TABLE-IN-QUERY-br-pedidos tt-ped-carteira


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-br-metas}~
    ~{&OPEN-QUERY-br-pedidos}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button rt-button-2 rt-button-3 RECT-7 ~
RECT-8 btExcel btSelecao btAtualiza bt-incluir bt-alterar bt-eliminar ~
bt-import bt-exit br-metas br-pedidos bt-pedido bt-det-ped bt-sdo-estoq ~
bt-ok bt-cancela 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescCanal w-cadsim 
FUNCTION fnDescCanal RETURNS CHARACTER
  ( p-cod-canal AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescitem w-cadsim 
FUNCTION fnDescitem RETURNS CHARACTER
  ( p-it-codigo AS CHAR )  FORWARD.

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

DEFINE BUTTON bt-alterar 
     IMAGE-UP FILE "image\im-mod":U
     IMAGE-INSENSITIVE FILE "image\ii-mod":U
     LABEL "Button 1" 
     SIZE 4 BY 1.25.

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-det-ped 
     LABEL "Detalhe Pedido" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-eliminar 
     IMAGE-UP FILE "image\im-era":U
     IMAGE-INSENSITIVE FILE "image\ii-era":U
     LABEL "Eliminar" 
     SIZE 4 BY 1.25.

DEFINE BUTTON bt-exit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-DOWN FILE "image\ii-exi":U
     LABEL "" 
     SIZE 4 BY 1.17.

DEFINE BUTTON bt-import 
     IMAGE-UP FILE "image/im-inl3.bmp":U
     IMAGE-INSENSITIVE FILE "image\ii-mod":U
     LABEL "Importar" 
     SIZE 4 BY 1.25.

DEFINE BUTTON bt-imprime 
     LABEL "&Imprimir" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-incluir 
     IMAGE-UP FILE "image\im-add":U
     IMAGE-INSENSITIVE FILE "image\ii-add":U
     LABEL "Incluir" 
     SIZE 4 BY 1.25.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-pedido 
     LABEL "Manut. Pedido" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-sdo-estoq 
     LABEL "Saldo Estoque" 
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
     SIZE 169 BY 16.25.

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
DEFINE QUERY br-metas FOR 
      tt-int-pv-canal SCROLLING.

DEFINE QUERY br-pedidos FOR 
      tt-ped-carteira SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-metas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-metas w-cadsim _FREEFORM
  QUERY br-metas DISPLAY
      tt-int-pv-canal.dt-ini-meta  COLUMN-LABEL "Data Inicio"
tt-int-pv-canal.dt-fim-meta  COLUMN-LABEL "Data Fim"
tt-int-pv-canal.cod-canal
fnDescCanal(tt-int-pv-canal.cod-canal) @ c-desc-canal COLUMN-LABEL "Nome" WIDTH 30 FORMAT "x(20)"
tt-int-pv-canal.it-codigo
fnDescItem(tt-int-pv-canal.it-codigo) @ c-desc-item COLUMN-LABEL "Descriá∆o" WIDTH 40 FORMAT "x(50)"
tt-int-pv-canal.qt-meta
tt-int-pv-canal.qt-faturada-disp COLUMN-LABEL "Qt. Faturada" FORMAT "->>>>>>>>>>>>9"
tt-int-pv-canal.qt-carteira
tt-int-pv-canal.dt-entrega-item
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 167 BY 15.75
         TITLE "Metas" FIT-LAST-COLUMN.

DEFINE BROWSE br-pedidos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-pedidos w-cadsim _FREEFORM
  QUERY br-pedidos DISPLAY
      tt-ped-carteira.cod-estabel 
tt-ped-carteira.nr-pedcli   
tt-ped-carteira.nome-abrev  
tt-ped-carteira.tp-pedido   
tt-ped-carteira.cod-priori  
tt-ped-carteira.no-ab-reppri
tt-ped-carteira.nome-transp 
tt-ped-carteira.cod-cond-pag
tt-ped-carteira.dt-implant  
tt-ped-carteira.dt-entorig  
tt-ped-carteira.dt-entrega  
tt-ped-carteira.qt-pedida   
tt-ped-carteira.qt-atendida 
tt-ped-carteira.qt-saldo COLUMN-LABEL "Qt. Saldo"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 151 BY 8
         TITLE "PEDIDOS DA CARTEIRA" ROW-HEIGHT-CHARS .67 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     btExcel AT ROW 1.13 COL 2.14 HELP
          "Gerar Relatorio Excel" WIDGET-ID 174
     btSelecao AT ROW 1.13 COL 6 HELP
          "Seleá∆o" WIDGET-ID 176
     btAtualiza AT ROW 1.13 COL 9.86 HELP
          "Atualizar" WIDGET-ID 160
     bt-incluir AT ROW 1.13 COL 18 HELP
          "Incluir" WIDGET-ID 212
     bt-alterar AT ROW 1.13 COL 21.86 HELP
          "Alterar" WIDGET-ID 208
     bt-eliminar AT ROW 1.13 COL 25.86 HELP
          "Eliminar" WIDGET-ID 214
     bt-import AT ROW 1.13 COL 38 HELP
          "Importar" WIDGET-ID 210
     bt-exit AT ROW 1.17 COL 166.29 WIDGET-ID 178
     br-metas AT ROW 2.75 COL 3 WIDGET-ID 200
     br-pedidos AT ROW 19.5 COL 3 WIDGET-ID 300
     bt-pedido AT ROW 20.33 COL 155 WIDGET-ID 200
     bt-det-ped AT ROW 21.5 COL 155 WIDGET-ID 202
     bt-sdo-estoq AT ROW 22.67 COL 155 WIDGET-ID 204
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
         SIZE 170.72 BY 29.08 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-int-pv-canal T "?" NO-UNDO mgesp int-pv-canal
      ADDITIONAL-FIELDS:
          field periodo-meta as char
          field qt-faturada-disp as dec
          field r-rowid as rowid
          
      END-FIELDS.
      TABLE: tt-ped-carteira T "?" NO-UNDO mgmov ped-item
      ADDITIONAL-FIELDS:
          field cod-estabel like ped-venda.cod-estabel
          field tp-pedido like ped-venda.tp-pedido
          field cod-priori like ped-venda.cod-priori
          field no-ab-reppri like ped-venda.no-ab-reppri
          field nome-transp like  ped-venda.nome-transp
          field cod-cond-pag like ped-venda.cod-cond-pag
          field dt-implant like ped-venda.dt-implant
          field qt-saldo like ped-item.qt-pedida
          field dt-fim as date
          field seq as int
          index ch-pri is primary unique seq
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
         HEIGHT             = 29.08
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
/* BROWSE-TAB br-metas bt-exit f-cad */
/* BROWSE-TAB br-pedidos br-metas f-cad */
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

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-metas
/* Query rebuild information for BROWSE br-metas
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-int-pv-canal.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-metas */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-pedidos
/* Query rebuild information for BROWSE br-pedidos
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ped-carteira
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


&Scoped-define BROWSE-NAME br-metas
&Scoped-define SELF-NAME br-metas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-metas w-cadsim
ON ROW-DISPLAY OF br-metas IN FRAME f-cad /* Metas */
DO:
   IF tt-int-pv-canal.qt-faturada + tt-int-pv-canal.qt-carteira > tt-int-pv-canal.qt-meta THEN DO:
         ASSIGN tt-int-pv-canal.cod-canal:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
                c-desc-canal:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
                tt-int-pv-canal.it-codigo:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
                c-desc-item:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
                tt-int-pv-canal.qt-meta:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
                tt-int-pv-canal.qt-faturada-disp:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
                tt-int-pv-canal.qt-carteira:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12
                tt-int-pv-canal.dt-entrega-item:FGCOLOR IN BROWSE {&BROWSE-NAME} = 12.

   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-metas w-cadsim
ON VALUE-CHANGED OF br-metas IN FRAME f-cad /* Metas */
DO:
   RUN pi-carrega-pedidos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-pedidos
&Scoped-define SELF-NAME br-pedidos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-pedidos w-cadsim
ON ROW-DISPLAY OF br-pedidos IN FRAME f-cad /* PEDIDOS DA CARTEIRA */
DO:
    IF tt-ped-carteira.dt-entrega > tt-ped-carteira.dt-fim THEN
        ASSIGN tt-ped-carteira.cod-estabel:FGCOLOR IN BROWSE br-pedidos = 9
               tt-ped-carteira.nr-pedcli:FGCOLOR IN BROWSE br-pedidos = 9
               tt-ped-carteira.nome-abrev:FGCOLOR IN BROWSE br-pedidos = 9    
               tt-ped-carteira.tp-pedido:FGCOLOR IN BROWSE br-pedidos = 9     
               tt-ped-carteira.cod-priori:FGCOLOR IN BROWSE br-pedidos = 9    
               tt-ped-carteira.no-ab-reppri:FGCOLOR IN BROWSE br-pedidos = 9  
               tt-ped-carteira.nome-transp:FGCOLOR IN BROWSE br-pedidos = 9   
               tt-ped-carteira.cod-cond-pag:FGCOLOR IN BROWSE br-pedidos = 9  
               tt-ped-carteira.dt-implant:FGCOLOR IN BROWSE br-pedidos = 9    
               tt-ped-carteira.dt-entorig:FGCOLOR IN BROWSE br-pedidos = 9    
               tt-ped-carteira.dt-entrega:FGCOLOR IN BROWSE br-pedidos = 9    
               tt-ped-carteira.qt-pedida:FGCOLOR IN BROWSE br-pedidos = 9     
               tt-ped-carteira.qt-atendida:FGCOLOR IN BROWSE br-pedidos = 9   
               tt-ped-carteira.qt-saldo:FGCOLOR IN BROWSE br-pedidos = 9. 
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


&Scoped-define SELF-NAME bt-alterar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-alterar w-cadsim
ON CHOOSE OF bt-alterar IN FRAME f-cad /* Button 1 */
DO:
    DEFINE VARIABLE r-rowid AS ROWID       NO-UNDO.
    EMPTY TEMP-TABLE tt-int-pv-canal-param.

    IF AVAIL tt-int-pv-canal THEN DO:
        CREATE tt-int-pv-canal-param.
        BUFFER-COPY tt-int-pv-canal TO tt-int-pv-canal-param.
        RUN esp/ftp/esftp214b.w (INPUT 2, /*Alteraá∆o*/
                                 INPUT TABLE tt-int-pv-canal-param).

        ASSIGN r-rowid = tt-int-pv-canal.r-rowid.
       
        RUN pi-carrega.
        
        FIND FIRST tt-int-pv-canal NO-LOCK
             WHERE tt-int-pv-canal.r-rowid = r-rowid NO-ERROR.

        REPOSITION br-metas TO ROWID ROWID(tt-int-pv-canal).
    END.
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


&Scoped-define SELF-NAME bt-det-ped
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-det-ped w-cadsim
ON CHOOSE OF bt-det-ped IN FRAME f-cad /* Detalhe Pedido */
DO:
    FIND FIRST ped-venda NO-LOCK 
         WHERE ped-venda.nr-pedcli = tt-ped-carteira.nr-pedcli NO-ERROR.
    
    IF AVAIL ped-venda THEN DO:
        ASSIGN gr-ped-venda = ROWID(ped-venda).
        RUN pdp/pd1001.w.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-eliminar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-eliminar w-cadsim
ON CHOOSE OF bt-eliminar IN FRAME f-cad /* Eliminar */
DO: 
    IF AVAIL tt-int-pv-canal THEN DO:
        FIND FIRST int-pv-canal OF tt-int-pv-canal EXCLUSIVE-LOCK.
        DELETE int-pv-canal.
    END.
    RUN pi-carrega.
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


&Scoped-define SELF-NAME bt-import
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-import w-cadsim
ON CHOOSE OF bt-import IN FRAME f-cad /* Importar */
DO:
    RUN esp/ftp/esftp213.w.
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


&Scoped-define SELF-NAME bt-incluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-incluir w-cadsim
ON CHOOSE OF bt-incluir IN FRAME f-cad /* Incluir */
DO:
    DEFINE VARIABLE r-rowid AS ROWID       NO-UNDO.
    EMPTY TEMP-TABLE tt-int-pv-canal-param.

    
    CREATE tt-int-pv-canal-param.
    RUN esp/ftp/esftp214b.w (INPUT 1, /*inclus∆o*/
                             INPUT TABLE tt-int-pv-canal-param).

    RUN pi-carrega.
    
    
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


&Scoped-define SELF-NAME bt-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-pedido w-cadsim
ON CHOOSE OF bt-pedido IN FRAME f-cad /* Manut. Pedido */
DO:
    FIND FIRST ped-venda NO-LOCK 
         WHERE ped-venda.nr-pedcli = tt-ped-carteira.nr-pedcli NO-ERROR.
    
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


&Scoped-define SELF-NAME bt-sdo-estoq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sdo-estoq w-cadsim
ON CHOOSE OF bt-sdo-estoq IN FRAME f-cad /* Saldo Estoque */
DO:
    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = tt-int-pv-canal.it-codigo NO-ERROR.

    IF AVAIL ITEM THEN
        ASSIGN gr-item = ROWID(ITEM).

    RUN cep/ce0830.w.
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


&Scoped-define SELF-NAME btSelecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSelecao w-cadsim
ON CHOOSE OF btSelecao IN FRAME f-cad /* Seleá∆o */
DO:
    DEFINE VARIABLE r-rowid AS ROWID       NO-UNDO.

   RUN esp/ftp/esftp214a.w (INPUT-OUTPUT c-periodo-ini,
                            INPUT-OUTPUT i-cod-canal-ini,
                            INPUT-OUTPUT i-cod-canal-fim,
                            INPUT-OUTPUT v-it-codigo-ini,
                            INPUT-OUTPUT v-it-codigo-fim,
                            INPUT-OUTPUT i-item-meta,
                            INPUT-OUTPUT d-data-ini-meta,
                            INPUT-OUTPUT d-data-fim-meta,
                            OUTPUT l-openquery).

   ASSIGN c-periodo-ini = REPLACE(c-periodo-ini,"/","").
    
   IF l-openquery THEN DO:
       RUN pi-carrega.
   END.
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


&Scoped-define BROWSE-NAME br-metas
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
         btAtualiza bt-incluir bt-alterar bt-eliminar bt-import bt-exit 
         br-metas br-pedidos bt-pedido bt-det-ped bt-sdo-estoq bt-ok bt-cancela 
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

  {utp/ut9000.i "ESFTP214" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  RUN dispatch  IN this-procedure ('enable-fields':U).

  RUN esp/es0018p.p (INPUT "esftp214":U,
                     INPUT 1,
                     INPUT 0,
                     INPUT "":U,
                     OUTPUT TABLE tt-prog-ponto).

  IF CAN-FIND (FIRST tt-prog-ponto
               WHERE tt-prog-ponto.conteudo = c-seg-usuario) THEN 
      ASSIGN bt-alterar:SENSITIVE IN FRAME f-cad = YES.
  ELSE 
      ASSIGN bt-alterar:SENSITIVE IN FRAME f-cad = NO.

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
EMPTY TEMP-TABLE tt-int-pv-canal.
EMPTY TEMP-TABLE tt-ped-carteira.

FOR EACH int-pv-canal NO-LOCK
   WHERE int-pv-canal.dt-ini-meta   >= d-data-ini-meta
     AND int-pv-canal.dt-fim-meta   <= d-data-fim-meta
     AND int-pv-canal.cod-canal     >= i-cod-canal-ini
     AND int-pv-canal.cod-canal     <= i-cod-canal-fim
     AND int-pv-canal.it-codigo     >= v-it-codigo-ini
     AND int-pv-canal.it-codigo     <= v-it-codigo-fim:

    IF i-item-meta = 1 THEN DO:
        IF int-pv-canal.qt-faturada + int-pv-canal.qt-carteira > int-pv-canal.qt-meta THEN
            NEXT.
    END.

    IF i-item-meta = 2 THEN DO:
        IF int-pv-canal.qt-faturada + int-pv-canal.qt-carteira <= int-pv-canal.qt-meta THEN
            NEXT.
    END.

    CREATE tt-int-pv-canal.
    BUFFER-COPY int-pv-canal TO tt-int-pv-canal.
    
    ASSIGN tt-int-pv-canal.qt-faturada-disp = int-pv-canal.qt-faturada
          // tt-int-pv-canal.periodo-meta = string(tt-int-pv-canal.mes-meta) + "/" + string(tt-int-pv-canal.ano-meta)
           tt-int-pv-canal.r-rowid = ROWID(int-pv-canal).
END.

{&open-query-br-metas}

IF AVAIL tt-int-pv-canal THEN
    APPLY "value-changed" TO br-metas IN FRAME f-cad.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-pedidos w-cadsim 
PROCEDURE pi-carrega-pedidos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE dt-ini         AS DATE        NO-UNDO.
DEFINE VARIABLE dt-fim         AS DATE        NO-UNDO.
DEFINE VARIABLE dt-aux         AS DATE        NO-UNDO.
DEFINE VARIABLE dt-ini-periodo AS DATE        NO-UNDO.
DEFINE VARIABLE i-seq          AS INTEGER     NO-UNDO.



EMPTY TEMP-TABLE tt-ped-carteira.

//ASSIGN dt-ini-periodo = DATE("01/" + STRING(tt-int-pv-canal.mes-meta) + "/" + STRING(tt-int-pv-canal.ano-meta))
ASSIGN dt-ini = tt-int-pv-canal.dt-ini-meta
       dt-fim = ADD-INTERVAL(dt-ini-periodo, 1, 'months') - 1.

DO dt-aux = dt-ini TO dt-fim:
    
    FOR EACH ped-item NO-LOCK
       WHERE (ped-item.cod-sit-item <= 2 OR ped-item.cod-sit-item = 5)
/*          AND ped-item.dt-entorig = dt-aux */
        AND ped-item.dt-entrega    = dt-aux
         AND ped-item.it-codigo  = tt-int-pv-canal.it-codigo,
       FIRST ped-venda OF ped-item NO-LOCK,
       FIRST int-ped-venda2 NO-LOCK
       WHERE int-ped-venda2.nr-pedido = ped-venda.nr-pedido
         AND int-ped-venda2.int-1     = tt-int-pv-canal.cod-canal:

        /*considerar somente os pedidos que geram titulo*/
        FIND FIRST natur-oper NO-LOCK
             WHERE natur-oper.nat-operacao = ped-item.nat-operacao NO-ERROR.

        IF NOT natur-oper.emite-duplic THEN
            NEXT.
        
        IF ped-venda.cod-priori = 44 /* oráamento */ then next.

        ASSIGN i-seq = i-seq + 1.

        CREATE tt-ped-carteira.
        ASSIGN tt-ped-carteira.cod-estabel   = ped-venda.cod-estabel
               tt-ped-carteira.nr-pedcli     = ped-venda.nr-pedcli
               tt-ped-carteira.nome-abrev    = ped-venda.nome-abrev
               tt-ped-carteira.tp-pedido     = ped-venda.tp-pedido
               tt-ped-carteira.cod-priori    = ped-venda.cod-priori
               tt-ped-carteira.no-ab-reppri  = ped-venda.no-ab-reppri
               tt-ped-carteira.nome-transp   = ped-venda.nome-transp
               tt-ped-carteira.cod-cond-pag  = ped-venda.cod-cond-pag
               tt-ped-carteira.dt-implant    = ped-venda.dt-implant
               tt-ped-carteira.dt-entorig    = ped-item.dt-entorig
               tt-ped-carteira.dt-entrega    = ped-item.dt-entrega
               tt-ped-carteira.qt-pedida     = ped-item.qt-pedida
               tt-ped-carteira.qt-atendida   = ped-item.qt-atendida
               tt-ped-carteira.qt-saldo      = ped-item.qt-pedida - ped-item.qt-atendida
               tt-ped-carteira.dt-fim        = dt-fim
               tt-ped-carteira.seq           = i-seq.

    END.
END.


{&open-query-br-pedidos}

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
ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "eswso0004" + STRING(TIME) + ".csv".
OUTPUT TO VALUE(c-arquivo) NO-CONVERT.

/*Exorta Pedidos*/
PUT UNFORMATTED "Data Ini. Meta;Data Fim Meta;C¢d. Canal;Nome;Item;Descriá∆o;Meta PV;Faturado;Carteira;Data Entrega Futura;" SKIP.
FOR EACH tt-int-pv-canal:

    FIND FIRST grupo-canais NO-LOCK
         WHERE grupo-canais.cod-gr-canais = tt-int-pv-canal.cod-canal NO-ERROR.

    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = tt-int-pv-canal.it-codigo NO-ERROR.

    PUT UNFORMATTED string(tt-int-pv-canal.dt-ini-meta    ) + ";" +
                    string(tt-int-pv-canal.dt-fim-meta    ) + ";" +
                    string(tt-int-pv-canal.cod-canal      ) + ";" +
                    string(grupo-canais.descricao         ) + ";" +
                    string(tt-int-pv-canal.it-codigo      ) + ";" +
                    string(ITEM.desc-item                 ) + ";" +
                    string(tt-int-pv-canal.qt-meta        ) + ";" +
                    string(tt-int-pv-canal.qt-faturada    ) + ";" +
                    string(tt-int-pv-canal.qt-carteira    ) + ";" +
                    string(tt-int-pv-canal.dt-entrega-item) SKIP.

    
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
  {src/adm/template/snd-list.i "tt-ped-carteira"}
  {src/adm/template/snd-list.i "tt-int-pv-canal"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescCanal w-cadsim 
FUNCTION fnDescCanal RETURNS CHARACTER
  ( p-cod-canal AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

FIND FIRST grupo-canais NO-LOCK
     WHERE grupo-canais.cod-gr-canais = p-cod-canal NO-ERROR.

IF AVAIL grupo-canais THEN
    RETURN grupo-canais.descricao.
ELSE
    RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

