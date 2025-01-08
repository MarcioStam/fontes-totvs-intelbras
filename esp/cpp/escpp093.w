&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCPP093 2.00.00.001}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCPP093
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2 br-industr bt-filtro ~
                              bt-saldo bt-pendente bt-docto bt-nf bt-reportar bt-atualizar
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE TEMP-TABLE tt-industr LIKE industr
    FIELD selecao           AS LOGICAL  LABEL "*"
    FIELD it-codigo         LIKE ITEM.it-codigo
    FIELD quantidade        LIKE ord-prod.qt-ordem
    FIELD nr-nota-fis-serv  LIKE nota-fiscal.nr-nota-fis
    FIELD nr-nota-fis-ret   LIKE nota-fiscal.nr-nota-fis
    FIELD serie-docto-serv  LIKE docum-est.serie-docto
    FIELD nro-docto-serv    LIKE docum-est.nro-docto
    FIELD serie-docto-ret   LIKE docum-est.serie-docto
    FIELD nro-docto-ret     LIKE docum-est.nro-docto
    FIELD cod-emitente      LIKE docum-est.cod-emitente
    FIELD nat-oper-serv     LIKE docum-est.nat-operacao                                    
    FIELD nat-oper-ret      LIKE docum-est.nat-operacao
    .
    

DEFINE TEMP-TABLE tt-item-estrut NO-UNDO 
    FIELD sequencia     LIKE componente.sequencia
    FIELD cod-emitente  LIKE ordem-compra.cod-emitente
    FIELD cod-estabel   LIKE ordem-compra.cod-estabel
    FIELD it-codigo     LIKE componente.it-codigo
    FIELD nr-ord-prod   LIKE componente.nr-ord-prod
    FIELD quantidade    LIKE componente.quantidade
    FIELD preco-unit    LIKE item-doc-est.preco-unit extent 0
    FIELD preco-total   LIKE componente.preco-total  extent 0
    FIELD data-corte    LIKE componente.dt-retorno
    FIELD cod-depos     LIKE componente.cod-depos
    FIELD rw-reservas   AS   ROWID
    FIELD aux           AS   CHAR
    INDEX seq
          sequencia .

def temp-table tt-item-saldo-terc no-undo
    field rw-saldo-terc   as rowid
    field quantidade      like saldo-terc.quantidade
    field preco-total     like componente.preco-total extent 0
    field desconto        like componente.desconto    extent 0    
    field cod-depos       like saldo-terc.cod-depos
    field nr-ord-prod     like saldo-terc.nr-ord-prod.

def temp-table tt-item-saldo-terc-aux
    field rw-saldo-terc   as rowid
    field quantidade      like saldo-terc.quantidade
    field preco-total     like componente.preco-total extent 0
    field desconto        like componente.desconto    extent 0    
    field cod-depos       like saldo-terc.cod-depos
    field nr-ord-prod     like saldo-terc.nr-ord-prod
    field item-pai        like reservas.item-pai   
    field cod-roteiro     like reservas.cod-roteiro
    field op-codigo       like reservas.op-codigo
    field sequencia       as int
    field char-1          as char
    field int-i           as int
    field log-1           as log
    field date-1          as date.

{esbo/boes705.i tt-ind-bo}

DEFINE VARIABLE h-boes705 AS HANDLE         NO-UNDO.
DEFINE VARIABLE iqtd AS INTEGER             NO-UNDO.
DEFINE VARIABLE l-pendente AS LOGICAL       INIT true   NO-UNDO.
DEFINE VARIABLE l-confirmado AS LOGICAL     INIT true   NO-UNDO.
DEFINE VARIABLE l-emitido AS LOGICAL        INIT true   NO-UNDO.
DEFINE VARIABLE l-atualizado AS LOGICAL     INIT TRUE   NO-UNDO.
DEFINE VARIABLE l-finalizado AS LOGICAL     INIT true   NO-UNDO.
DEFINE VARIABLE l-cancelado AS LOGICAL      INIT true   NO-UNDO.
DEFINE VARIABLE c-situacao AS CHARACTER   NO-UNDO.

DEFINE BUFFER b-item FOR ITEM.

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino           AS INTEGER
    FIELD arquivo           AS CHAR FORMAT "x(35)":U
    FIELD usuario           AS CHAR FORMAT "x(12)":U
    FIELD data-exec         AS DATE
    FIELD hora-exec         AS INTEGER
    FIELD cod-estabel       LIKE docum-est.cod-estabel
    FIELD serie             LIKE docum-est.serie
    FIELD nro-docto         AS INTEGER FORMAT "9999999":U
    FIELD nat-retorno       LIKE docum-est.nat-operacao
    FIELD nat-servico       LIKE docum-est.nat-operacao
    FIELD num-pedido        LIKE pedido-compr.num-pedido
    FIELD nr-ord-prod       LIKE ord-prod.nr-ord-prod
    FIELD dt-trans          LIKE docum-est.dt-trans
    FIELD cod-depos-ret     LIKE saldo-terc.cod-depos
    FIELD cod-depos-serv    LIKE saldo-terc.cod-depos
    FIELD cod-fornec        LIKE emitente.cod-emitente
    FIELD it-codigo         LIKE ITEM.it-codigo
    FIELD qtd               LIKE saldo-terc.quantidade
    FIELD cod-modalid-frete LIKE modalid-frete.cod-modalid-frete.

DEFINE TEMP-TABLE tt-digita
    FIELD serie-docto   LIKE docum-est.serie-docto
    FIELD nro-docto     LIKE docum-est.nro-docto
    FIELD cod-emitente  LIKE docum-est.cod-emitente
    FIELD nat-operacao  LIKE docum-est.nat-operacao.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita       AS RAW.

define temp-table tt-param2
      field destino            as integer
      field arquivo            as char
      field usuario            as char format "x(12)"
      field data-exec          as date
      field hora-exec          as integer
      FIELD c-cod-estab        AS CHAR
      field da-dt-trans-ini     as date format "99/99/9999"
      field da-dt-trans-fim     as date format "99/99/9999"
      field c-esp-ini          as char
      field c-esp-fim          as char
      field c-ser-ini          as char
      field c-ser-fim          as char
      field c-num-ini          as char
      field c-num-fim          as char
      field i-emit-ini         as integer
      field i-emit-fim         as integer
      field c-nat-ini          as char
      field c-nat-fim          as char
      FIELD c-usuar-ini        AS CHAR
      FIELD c-usuar-fim        AS CHAR.

def temp-table tt-rep
    field serie like movto-estoq.serie-docto
    field it-codigo like movto-estoq.it-codigo
    field quantidade as dec format ">>>>9" label "QTD"
    field tipo as logical format "N/S"  /* normal/seletivo */
    field hora as char format "x(5)"
    field nr-ae AS INT /*like ae-item.nr-ae*/
    field cod-depos-ent   like movto-estoq.cod-depos
    field sequencia AS INT /*like ae-item.sequencia*/
    FIELD desc-item         LIKE ITEM.desc-item
    FIELD nr-ord-prod LIKE ord-prod.nr-ord-prod
    FIELD cEtiqueta AS CHAR
    index codigo is primary it-codigo.

DEF VAR hproc AS HANDLE NO-UNDO.
DEF VAR hprog AS HANDLE NO-UNDO.
DEFINE VARIABLE c-msg-erro AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp AS HANDLE      NO-UNDO.

{esp/ShowMsg.i}   
{upc/btb910za-upc.i}
{esp/es0018.i}
{esp/utp/acesso-rpc.i}

{cpp/cpapi001.i}  /*** tt-rep-prod tt-refugo tt-res-neg tt-apont-mob ***/
{esapi/esapi001tt.i}
{cdp/cd0666.i} /* tt-erros */
{esapi/esapi006tt.i}

DEFINE BUFFER b-operacao FOR operacao.
DEFINE BUFFER b-rot-item FOR rot-item.

DEFINE VARIABLE c-desc-item AS CHARACTER   NO-UNDO.

DEF NEW GLOBAL SHARED VAR vNomProg            AS   CHAR             NO-UNDO.
def new global shared var gr-documento  as rowid no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-industr

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-industr

/* Definitions for BROWSE br-industr                                    */
&Scoped-define FIELDS-IN-QUERY-br-industr tt-industr.selecao tt-industr.num-pedido tt-industr.nr-ord-produ tt-industr.it-codigo f-desc-item(tt-industr.it-codigo) @ c-desc-item tt-industr.quantidade f-situacao(tt-industr.situacao) @ c-situacao tt-industr.serie-docto-serv tt-industr.nro-docto-serv tt-industr.nr-nota-fis-serv tt-industr.serie-docto-ret tt-industr.nro-docto-ret tt-industr.nr-nota-fis-ret   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-industr   
&Scoped-define SELF-NAME br-industr
&Scoped-define QUERY-STRING-br-industr FOR EACH tt-industr
&Scoped-define OPEN-QUERY-br-industr OPEN QUERY {&SELF-NAME} FOR EACH tt-industr.
&Scoped-define TABLES-IN-QUERY-br-industr tt-industr
&Scoped-define FIRST-TABLE-IN-QUERY-br-industr tt-industr


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-industr}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar bt-filtro btQueryJoins ~
btReportsJoins btExit btHelp br-industr bt-saldo bt-pendente bt-docto bt-nf ~
bt-reportar bt-atualizar btOK btCancel btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-desc-item wWindow 
FUNCTION f-desc-item RETURNS CHARACTER
  ( INPUT p-it-codigo AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-situacao wWindow 
FUNCTION f-situacao RETURNS CHARACTER
  ( INPUT p-situacao AS INTEGER )  FORWARD.

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
DEFINE BUTTON bt-atualizar 
     LABEL "Atualizar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-docto 
     LABEL "Gerar Docto" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-filtro 
     IMAGE-UP FILE "image/im-fil.bmp":U
     LABEL "Filtro" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON bt-nf 
     LABEL "Gerar Nota" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-pendente 
     LABEL "Pendente" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-reportar 
     LABEL "Reportar OP" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-saldo 
     LABEL "Saldo Terc" 
     SIZE 10 BY 1.

DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

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
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-industr FOR 
      tt-industr SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-industr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-industr wWindow _FREEFORM
  QUERY br-industr DISPLAY
      tt-industr.selecao        FORMAT "*/ "        COLUMN-LABEL "*"
            tt-industr.num-pedido  
            tt-industr.nr-ord-produ
            tt-industr.it-codigo   
            f-desc-item(tt-industr.it-codigo) @ c-desc-item FORMAT "X(40)"   COLUMN-LABEL "Descri‡Æo"
            tt-industr.quantidade  
            f-situacao(tt-industr.situacao)    @ c-situacao  FORMAT "X(12)"    COLUMN-LABEL "Situa‡Æo" WIDTH 16
            tt-industr.serie-docto-serv     COLUMN-LABEL "Serie Serv"
            tt-industr.nro-docto-serv       COLUMN-LABEL "Nr Docto Serv"
            tt-industr.nr-nota-fis-serv     COLUMN-LABEL "Nota Fis Serv"
            tt-industr.serie-docto-ret      COLUMN-LABEL "Serie Retorno"
            tt-industr.nro-docto-ret        COLUMN-LABEL "Nr Docto Retorno"
            tt-industr.nr-nota-fis-ret      COLUMN-LABEL "Nota Fis Retorno"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 88 BY 12.25
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     bt-filtro AT ROW 1.13 COL 70.72 HELP
          "Consultas relacionadas" WIDGET-ID 10
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     br-industr AT ROW 2.75 COL 2 WIDGET-ID 200
     bt-saldo AT ROW 15 COL 2 WIDGET-ID 2
     bt-pendente AT ROW 15 COL 12 WIDGET-ID 4
     bt-docto AT ROW 15 COL 22 WIDGET-ID 6
     bt-nf AT ROW 15 COL 32 WIDGET-ID 14
     bt-reportar AT ROW 15 COL 42 WIDGET-ID 8
     bt-atualizar AT ROW 15 COL 80 WIDGET-ID 12
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 16.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17
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
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB br-industr btHelp fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-industr
/* Query rebuild information for BROWSE br-industr
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-industr.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-industr */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
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


&Scoped-define BROWSE-NAME br-industr
&Scoped-define SELF-NAME br-industr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-industr wWindow
ON MOUSE-SELECT-DBLCLICK OF br-industr IN FRAME fpage0
DO:

    IF AVAIL tt-industr THEN DO:

        ASSIGN tt-industr.selecao = NOT tt-industr.selecao.

        br-industr:REFRESH() IN FRAME fPage0.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-atualizar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-atualizar wWindow
ON CHOOSE OF bt-atualizar IN FRAME fpage0 /* Atualizar */
DO:

    run utp/ut-acomp.p persistent set h-acomp.  
    run pi-inicializar in h-acomp (input "Processando").

    FOR EACH tt-industr:

        FOR FIRST ord-prod NO-LOCK
            WHERE ord-prod.nr-ord-produ = tt-industr.nr-ord-produ,
        FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = ord-prod.it-codigo,
        FIRST pedido-compr NO-LOCK
            WHERE pedido-compr.num-pedido = tt-industr.num-pedido,
        FIRST ordem-compra NO-LOCK
            WHERE ordem-compra.num-pedido = pedido-compr.num-pedido:

            RUN pi-atualizar.

        END.

        IF NOT AVAIL ord-prod OR
           NOT AVAIL pedido-compr THEN DO:

            RUN pi-elimina-industr.

        END.

    END.

    RUN pi-finalizar IN h-acomp.

    /*{&open-query-br-industr}*/

    RUN pi-disp-browse.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-docto wWindow
ON CHOOSE OF bt-docto IN FRAME fpage0 /* Gerar Docto */
DO:

    IF CAN-FIND(FIRST tt-industr
                WHERE tt-industr.selecao
                AND   tt-industr.situacao = 2) THEN DO:

        RUN pi-gera-docto.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-filtro wWindow
ON CHOOSE OF bt-filtro IN FRAME fpage0 /* Filtro */
DO:

    {&WINDOW-NAME}:SENSITIVE = FALSE.
    RUN esp/cpp/escpp093a.w (INPUT-OUTPUT l-pendente,
                             INPUT-OUTPUT l-confirmado,
                             INPUT-OUTPUT l-emitido,
                             INPUT-OUTPUT l-atualizado,
                             INPUT-OUTPUT l-finalizado,
                             INPUT-OUTPUT l-cancelado).
    {&WINDOW-NAME}:SENSITIVE = TRUE.

    RUN pi-disp-browse.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-nf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-nf wWindow
ON CHOOSE OF bt-nf IN FRAME fpage0 /* Gerar Nota */
DO:

    IF CAN-FIND(FIRST tt-industr
                WHERE tt-industr.selecao
                AND   tt-industr.situacao = 3) THEN DO:

        RUN pi-gera-nf.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-pendente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-pendente wWindow
ON CHOOSE OF bt-pendente IN FRAME fpage0 /* Pendente */
DO:

    RUN pi-pendente.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-reportar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-reportar wWindow
ON CHOOSE OF bt-reportar IN FRAME fpage0 /* Reportar OP */
DO:

    IF CAN-FIND(FIRST tt-industr
                WHERE tt-industr.selecao
                AND   tt-industr.situacao = 4) THEN DO:

        RUN pi-reporta-op.

        {&open-query-br-industr}

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-saldo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-saldo wWindow
ON CHOOSE OF bt-saldo IN FRAME fpage0 /* Saldo Terc */
DO:

    RUN pi-saldo-terc.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
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


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wWindow
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

PROCEDURE WinExec EXTERNAL "kernel32.dll":U:
  DEF INPUT  PARAM prg_name                          AS CHARACTER.
  DEF INPUT  PARAM prg_style                         AS SHORT.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wWindow 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN esbo/boes705.p PERSISTENT SET h-boes705.

    RUN pi-disp-browse.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-altera-situacao wWindow 
PROCEDURE pi-altera-situacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-situacao AS INTEGER     NO-UNDO.


    IF AVAIL tt-industr THEN DO:

        RUN emptyRowErrors IN h-boes705.

        RUN goToKey IN h-boes705 (INPUT tt-industr.nr-ord-produ).

        EMPTY TEMP-TABLE tt-ind-bo.
    
        RUN getRecord IN h-boes705 (OUTPUT TABLE tt-ind-bo).

        FOR FIRST tt-ind-bo:
            ASSIGN tt-ind-bo.situacao = p-situacao.
        END.

        RUN setRecord IN h-boes705 (INPUT TABLE tt-ind-bo).

        RUN updateRecord IN h-boes705.

        IF RETURN-VALUE = "OK" THEN DO:

            ASSIGN tt-industr.situacao = p-situacao.

        END.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-dados-docto wWindow 
PROCEDURE pi-atualiza-dados-docto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF AVAIL tt-industr THEN DO:

        /* Doc Servi‡o */
        FOR FIRST docum-est NO-LOCK
            WHERE docum-est.serie-docto  = tt-industr.serie-docto-serv
            AND   docum-est.nro-docto    = tt-industr.nro-docto-serv
            AND   docum-est.cod-emitente = tt-industr.cod-emitente
            AND   docum-est.nat-operacao = tt-industr.nat-oper-serv:

            FOR EACH item-doc-est NO-LOCK
                WHERE item-doc-est.serie-docto  = tt-industr.serie-docto-serv
                AND   item-doc-est.nro-docto    = tt-industr.nro-docto-serv
                AND   item-doc-est.cod-emitente = tt-industr.cod-emitente
                AND   item-doc-est.nat-operacao = tt-industr.nat-oper-serv:

                IF item-doc-est.it-codigo = tt-industr.it-codigo THEN DO:

                    ASSIGN tt-industr.rw-doc-serv = string(ROWID(docum-est)).

                END.

            END.

        END.

        /* Doc Retorno */
        FOR FIRST docum-est NO-LOCK
            WHERE docum-est.serie-docto  = tt-industr.serie-docto-ret
            AND   docum-est.nro-docto    = tt-industr.nro-docto-ret
            AND   docum-est.cod-emitente = tt-industr.cod-emitente
            AND   docum-est.nat-operacao = tt-industr.nat-oper-ret:

            FOR FIRST item-doc-est NO-LOCK
                WHERE item-doc-est.serie-docto  = tt-industr.serie-docto-ret
                AND   item-doc-est.nro-docto    = tt-industr.nro-docto-ret
                AND   item-doc-est.cod-emitente = tt-industr.cod-emitente
                AND   item-doc-est.nat-operacao = tt-industr.nat-oper-serv:

                ASSIGN tt-industr.rw-doc-ret = string(ROWID(docum-est)).

            END.

        END.


        RUN goToKey IN h-boes705 (INPUT tt-industr.nr-ord-produ).

        EMPTY TEMP-TABLE tt-ind-bo.
    
        RUN getRecord IN h-boes705 (OUTPUT TABLE tt-ind-bo).

        FOR FIRST tt-ind-bo:               
            ASSIGN tt-ind-bo.rw-doc-serv   = tt-industr.rw-doc-serv
                   tt-ind-bo.rw-doc-ret    = tt-industr.rw-doc-ret.
        END.

        RUN setRecord IN h-boes705 (INPUT TABLE tt-ind-bo).

        RUN updateRecord IN h-boes705.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-dados-nf wWindow 
PROCEDURE pi-atualiza-dados-nf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF AVAIL tt-industr THEN DO:

        /* Doc Servi‡o */
        FOR FIRST docum-est NO-LOCK
            WHERE rowid(docum-est)  = TO-ROWID(tt-industr.rw-doc-serv):
            
            ASSIGN tt-industr.serie-docto-serv = docum-est.serie-docto
                   tt-industr.nro-docto-serv   = docum-est.nro-docto.

            IF docum-est.ce-atual THEN DO:

                FOR FIRST nota-fiscal NO-LOCK
                    WHERE nota-fiscal.cod-estabel = tt-industr.cod-estabel
                    AND   nota-fiscal.serie       = tt-industr.serie-docto-serv
                    AND   nota-fiscal.nr-nota-fis   = tt-industr.nro-docto-serv:
    
                    ASSIGN tt-industr.nr-nota-fis-serv = nota-fiscal.nr-nota-fis.
    
                END.

            END.

        END.

        /* Doc Retorno */
        FOR FIRST docum-est NO-LOCK
            WHERE rowid(docum-est)  = TO-ROWID(tt-industr.rw-doc-ret):
            
            ASSIGN tt-industr.serie-docto-ret = docum-est.serie-docto
                   tt-industr.nro-docto-ret   = docum-est.nro-docto.

            IF docum-est.ce-atual THEN DO:

                FOR FIRST nota-fiscal NO-LOCK
                    WHERE nota-fiscal.cod-estabel = tt-industr.cod-estabel
                    AND   nota-fiscal.serie       = tt-industr.serie-docto-ret
                    AND   nota-fiscal.nr-nota-fis   = tt-industr.nro-docto-ret:
    
                    ASSIGN tt-industr.nr-nota-fis-ret = nota-fiscal.nr-nota-fis.
    
                END.

            END.

        END.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualizar wWindow 
PROCEDURE pi-atualizar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE l-criou AS LOGICAL     NO-UNDO.


    run pi-inicializar in h-acomp (input "Atualizando Situa‡Æo...").

    RUN pi-acompanhar IN h-acomp (INPUT "Pedido: " + STRING(pedido-compr.num-pedido)).

    IF AVAIL tt-industr THEN DO:

        CASE tt-industr.situacao:

            /* Confirmado */
            WHEN 2 THEN DO:

                ASSIGN l-criou = TRUE.

                IF NOT CAN-FIND (FIRST docum-est NO-LOCK
                                 WHERE rowid(docum-est) = to-rowid(tt-industr.rw-doc-serv)) THEN DO:

                    ASSIGN l-criou = FALSE.

                END.

                IF NOT CAN-FIND (FIRST docum-est NO-LOCK
                                 WHERE rowid(docum-est) = to-rowid(tt-industr.rw-doc-ret)) THEN DO:

                    ASSIGN l-criou = FALSE.

                END.


                IF l-criou THEN DO:

                    RUN pi-altera-situacao(3).  /* Emitido */

                END.

            END.


            /* Emitido */
            WHEN 3 THEN DO:

                FOR FIRST docum-est NO-LOCK
                    WHERE rowid(docum-est) = TO-ROWID(tt-industr.rw-doc-serv):

                    /* Documento foi Atualizado */
                    IF docum-est.ce-atual THEN DO:

                        FOR FIRST nota-fiscal NO-LOCK
                            WHERE nota-fiscal.cod-estabel = tt-industr.cod-estabel
                            AND   nota-fiscal.serie       = docum-est.serie-docto
                            AND   nota-fiscal.nr-nota-fis = docum-est.nro-docto:

                            FOR FIRST it-nota-fisc NO-LOCK
                                WHERE it-nota-fisc.cod-estabel         = nota-fiscal.cod-estabel
                                AND   it-nota-fisc.serie               = nota-fiscal.serie
                                AND   it-nota-fisc.nr-nota-fis         = nota-fiscal.nr-nota-fis
                                AND   it-nota-fisc.it-codigo           = tt-industr.it-codigo:
            
                                RUN pi-altera-situacao(4).  /* Atualizado */
            
                            END.

                        END.

                    END.

                END.

            END.


            /*
            /* Atualizado */
            WHEN 4 THEN DO:

                IF CAN-FIND(FIRST rep-oper
                            WHERE rep-oper.nr-ord-produ = tt-industr.nr-ord-produ
                            AND   rep-oper.op-seq = 0
                            AND   rep-oper.dt-trans =  THEN

                RUN pi-altera-situacao(5).  /* Finalizado */

            END.
            */


        END CASE.

        br-industr:REFRESH() IN FRAME fPage0.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-btb911zb wWindow 
PROCEDURE pi-btb911zb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    /*    
    assign c-imp = p_arquivo.
    assign v_log_program_api = no.
    {utp/ut-liter.i Arquivo BTB R}
    assign c-arquivo = return-value. 
    {utp/ut-liter.i Impressora BTB R}
    assign c-impressora = return-value. 
    /* Begin_Include: i_verifica_configuracao_usuario_rpw */
    if  v_cod_usuar_corren = "" or 
       v_cod_usuar_corren = ?
    then do: 
       {utp/ut-liter.i Usu rio BTB R}
       if  v_log_program_api = yes
       then do:           
          return ("2407" + CHR(10) + return-value).
       end /* if */.
       else do:
            run utp/ut-msgs.p (input "show",
                           input 4850,
                           input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                              trim(return-value))) /*msg_2704*/. 
            return error.  
       end /* else */.
    end /* if */.    
    if  (v_cod_empres_usuar  = ? or v_cod_empres_usuar  = "") and
        (v_cdn_empres_usuar  = ? or v_cdn_empres_usuar  = 0)  and
        (i-ep-codigo-usuario = ? or i-ep-codigo-usuario = 0)
    then do:
       {utp/ut-liter.i Empresa_do_Usu rio BTB R}
       if  v_log_program_api = yes
         then do:
            return ("5394" + CHR(10) + return-value).
         end /* if */.
       else do:
          run utp/ut-msgs.p (input "show",
                           input 5394,
                           input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                              trim(return-value))) /*msg_4625*/.
          return error.
       end /* else */.
    end.   
    if  v_cod_pais_empres_usuar = "" or v_cod_pais_empres_usuar = ?
    then do:
       {utp/ut-liter.i Pa¡s_da_Empresa BTB R}
       if  v_log_program_api = yes
       then do:   
           return ("2407" + CHR(10) + return-value /*l_pais_da_empresa*/).  
       end /* if */.
       else do:   
            run utp/ut-msgs.p (input "show",
                           input 4850,
                           input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                             trim(return-value))) /*msg_2704*/. 
          return error.    
       end /* else */.
    end /* if */.
    /* End_Include: i_verifica_configuracao_usuario_rpw */ 
    
    /* Begin_Include: i_verify_security */
    run men/men901za.p (Input 'fnc_criac_ped_exec') /*prg_fnc_verify_security*/.
    if  return-value = "2014"
    then do:
        run utp/ut-msgs.p (input "show",
                         input 3045,
                         input 'fnc_criac_ped_exec').
        return.
    end /* if */.
    if  return-value = "2012"
    then do:  
        run utp/ut-msgs.p (input "show",
                         input 2858,
                         input 'fnc_criac_ped_exec').
        return.
    end /* if */.
    /* End_Include: i_verify_security */
    
    /* Begin_Include: i_log_exec_prog_dtsul_ini */
    log_exec:
    do transaction:
        assign v_rec_log = ?.
        find prog_dtsul no-lock
             where prog_dtsul.cod_prog_dtsul = 'fnc_criac_ped_exec' /*cl_program of prog_dtsul*/
    
              no-error.
        if  available prog_dtsul
        and  prog_dtsul.log_gera_log_exec = yes
        then do:
            create log_exec_prog_dtsul.
            assign log_exec_prog_dtsul.cod_prog_dtsul           = 'fnc_criac_ped_exec'
                   log_exec_prog_dtsul.cod_usuario              = v_cod_usuar_corren
                   log_exec_prog_dtsul.dat_inic_exec_prog_dtsul = today
                   log_exec_prog_dtsul.hra_inic_exec_prog_dtsul = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/),":","").
            assign v_rec_log = recid(log_exec_prog_dtsul).
            release log_exec_prog_dtsul no-error.
        end /* if */.
    end /* do log_exec */.
    /* End_Include: i_log_exec_prog_dtsul_ini */
    
    /* Begin_Include: i_std_dialog_box */
    /* tratamento do titulo e versÆo */
    assign frame f_dlg_01_criac_ped_exec:title = frame f_dlg_01_criac_ped_exec:title 
                                + chr(32)
                                + chr(40)
                                + trim(" 1.01.002":U)
                                + chr(41).
    /* menu pop-up de ajuda e sobre */
    assign menu m_help:popup-only = yes
           bt_hel2:popup-menu in frame f_dlg_01_criac_ped_exec = menu m_help:handle.
    
    /* End_Include: i_std_dialog_box */
    
    run utp/ut-trdfr.p (input frame f_dlg_01_criac_ped_exec:handle, input 'fnc_criac_ped_exec', input c-prg-vrs).
    
    {utp/ut-liter.i "Publica‡Æo" BTB R}
    
    view frame f_dlg_01_criac_ped_exec.
    
    assign ped_exec.log-2:label in frame f_dlg_01_criac_ped_exec = return-value + " WebDesk":U.
    
    block:
    do on error undo block, leave block
              on endkey undo block, leave block:
    
       {utp/ut-liter.i "Cria Pedidos Peri¢dicos" BTB R}
    
        assign bt_agendar:help    = return-value
               bt_agendar:tooltip = return-value.
    
        /*** VALIDAR UTILIZA€ÇO DE AGENDA AUTOMµTICA RPW - PROGRAMAS GENRICOS ***/
    
        {utp/ut-liter.i "Utiliza_Agenda_Autom tica" BTB L}
    
        assign tg-agenda-auto:label in frame f_dlg_01_criac_ped_exec = trim(return-value)
               v-log-agenda-auto-ok                                  = yes.
    
        find first agenda-rpw no-lock
            where agenda-rpw.modulo      = 5
              and agenda-rpw.operacao    = 0
              and agenda-rpw.maq-destino = 0
              and agenda-rpw.trans-mp    = ""
              and agenda-rpw.trans-cl    = p_cod_prog_dtsul_w
              and agenda-rpw.trans-edi   = i-ep-codigo-usuario 
              and agenda-rpw.parceiro    = 0 no-error.
    
        if avail agenda-rpw and
                 agenda-rpw.situacao-rpw = yes
        then do:
    
            &if "{&mguni_version}" >= "2.05" &then
                if agenda-rpw.qtd-ped-agendar   <> 0 and
                   agenda-rpw.qtd-ped-executado  > agenda-rpw.qtd-ped-agendar
                then
                    assign v-log-agenda-auto-ok = no.
            &else            
                if agenda-rpw.dec-1 <> 0 and
                   agenda-rpw.dec-2  > agenda-rpw.dec-1
                then
                    assign v-log-agenda-auto-ok = no.
            &endif    
    
            if v-log-agenda-auto-ok = yes
            then
                &if "{&mguni_version}" >= "2.05" &then
                    if agenda-rpw.dat-limit-exec <> ? and
                       agenda-rpw.dat-limit-exec  < today
                    then
                        assign v-log-agenda-auto-ok = no.
                &else            
                    if agenda-rpw.data-1 <> ? and
                       agenda-rpw.data-1  < today
                    then
                        assign v-log-agenda-auto-ok = no.
                &endif    
    
            if v-log-agenda-auto-ok = yes
            then do:
                find first horario-rpw no-lock
                    where  horario-rpw.modulo      = agenda-rpw.modulo      
                      and  horario-rpw.operacao    = agenda-rpw.operacao    
                      and  horario-rpw.maq-destino = agenda-rpw.maq-destino 
                      and  horario-rpw.trans-mp    = agenda-rpw.trans-mp    
                      and  horario-rpw.trans-cl    = agenda-rpw.trans-cl    
                      and  horario-rpw.trans-edi   = agenda-rpw.trans-edi   
                      and  horario-rpw.parceiro    = agenda-rpw.parceiro no-error.
    
                if not avail horario-rpw 
                then
                    assign v-log-agenda-auto-ok = no.
            end.
    
            if v-log-agenda-auto-ok = yes 
            then   
                assign tg-agenda-auto:visible   in frame f_dlg_01_criac_ped_exec = yes /*** POSSUI AGENDA DISPONÖVEL E ESTµ TUDO OK ***/
                       tg-agenda-auto:sensitive in frame f_dlg_01_criac_ped_exec = yes.
            else  
                assign tg-agenda-auto:visible   in frame f_dlg_01_criac_ped_exec = yes /*** POSSUI AGENDA DISPONÖVEL MAS COM RESTRI€åES ***/
                       tg-agenda-auto:sensitive in frame f_dlg_01_criac_ped_exec = no.
        end.
        else
            assign tg-agenda-auto:visible   in frame f_dlg_01_criac_ped_exec = no /*** NÇO POSSUI AGENDA, OU AGENDA NÇO ESTµ DISPONÖVEL ***/
                   tg-agenda-auto:sensitive in frame f_dlg_01_criac_ped_exec = no.
    
        create ped_exec.
        assign v_num_aux = next-value(seq_ped_exec).
    
         repeat:
             assign ped_exec.num_ped_exec = v_num_aux no-error.
             If (ped_exec.num_ped_exec = 0) then do:
                 assign v_num_aux = next-value(seq_ped_exec) /*v_num_aux + 1*/.
             end.
             else do:
                leave.
             end.
         end.
    
        IF ROWID(ped_exec) = ? THEN.
    
        run pi_sec_to_formatted_time (Input time,
                                      output ped_exec.hra_criac_ped_exec) /*pi_sec_to_formatted_time*/.
    
        assign v_dat_exec_ped_exec_old = today
               v_hra_exec_ped_exec_old = ped_exec.hra_criac_ped_exec
               ped_exec.cod_usuario = v_cod_usuar_corren
               ped_exec.dat_criac_ped_exec = today                
               ped_exec.dat_exec_ped_exec:screen-value in frame f_dlg_01_criac_ped_exec = string(ped_exec.dat_criac_ped_exec)
               ped_exec.hra_exec_ped_exec:screen-value in frame f_dlg_01_criac_ped_exec = string(ped_exec.hra_criac_ped_exec)
               ped_exec.ind_sit_ped_exec       = "1"  /*nÆo executado*/
               ped_exec.ind_motiv_sit_ped_exec = "14" /*enfileirado*/
               ped_exec.cdn_estil_dwb          = p_cdn_estil_dwb
               ped_exec.cod_release_prog_dtsul = p_cod_release.
    
       enable bt_can
              bt_hel2
              bt_ok
              ped_exec.cod_servid_exec
              ped_exec.dat_exec_ped_exec
              ped_exec.hra_exec_ped_exec
              ped_exec.log_exec_prog_depend
              with frame f_dlg_01_criac_ped_exec.
    
       disable bt_zoo_100771
               with frame f_dlg_01_criac_ped_exec.
    
       display ped_exec.cod_usuario
               ped_exec.num_ped_exec
               ped_exec.num_ped_exec_pai
               with frame f_dlg_01_criac_ped_exec. 
    
    
       /* --- FO 1554.199 - */
       IF  (    p_cod_prog_dtsul_w   MATCHES 'BTB934aa':U
            And p_cod_prog_dtsul_rp  MATCHES 'BTB/BTB934rp.p':U)
       Or  (    p_cod_prog_dtsul_w   MATCHES 'au0108':U
            And p_cod_prog_dtsul_rp  MATCHES 'aup/au0108rp.p':U)
        THEN DO:
           DISABLE bt_agendar
                   ped_exec.log_exec_prog_depend
                   WITH FRAME f_dlg_01_criac_ped_exec.
       END.
    
       find usuar_mestre no-lock
            where usuar_mestre.cod_usuario = v_cod_usuar_corren
            use-index srmstr_id /*cl_usuar_corren of usuar_mestre*/ 
             no-error.
    
       if  available usuar_mestre and usuar_mestre.cod_servid_exec <> ""
       then do:
           assign ped_exec.cod_servid_exec:screen-value in frame f_dlg_01_criac_ped_exec = usuar_mestre.cod_servid_exec.
           apply "leave" to ped_exec.cod_servid_exec in frame f_dlg_01_criac_ped_exec.
           if  usuar_mestre.log_servid_exec_obrig = no
           then do:
              enable ped_exec.cod_servid_exec
                     bt_zoo_100765
                     with frame f_dlg_01_criac_ped_exec.
           end /* if */.
           else do:
              disable ped_exec.cod_servid_exec
                      bt_zoo_100765
                      with frame f_dlg_01_criac_ped_exec.
              assign ped_exec.cod_servid_exec = usuar_mestre.cod_servid_exec.
           end /* else */.
       end /* if */.
    
       /* Verifica se o WebDesk est  instalado */
    
       if search("wdk/wdapi004.p":U) <> ?
       or search ("wdk/wdapi004.r":U) <> ? then do:
           FIND FIRST catal_docto_anexo 
               WHERE catal_docto_anexo.cod_catal_docto_anexo = "WebDesk":U 
               NO-LOCK NO-ERROR.
           IF AVAILABLE catal_docto_anexo AND 
              CONNECTED("webdesk":U)      AND 
              (catal_docto_anexo.char-2 = "*" OR
               catal_docto_anexo.char-2 = ""  OR
               CAN-FIND(usuar_grp_usuar 
                    WHERE usuar_grp_usuar.cod_grp_usuar = catal_docto_anexo.char-2
                      AND usuar_grp_usuar.cod_usuario   = v_cod_usuar_corren))     THEN
              enable ped_exec.log-2
                     with frame f_dlg_01_criac_ped_exec.
          else
             disable ped_exec.log-2
                     with frame f_dlg_01_criac_ped_exec.
    
       end.      
       else 
           disable ped_exec.log-2
                   with frame f_dlg_01_criac_ped_exec.
    
       wait_block:
       repeat on endkey undo block, leave block:
           if  valid-handle(v_wgh_focus)
           then do:
               wait-for go of frame f_dlg_01_criac_ped_exec focus v_wgh_focus.
           end /* if */.
           else do:    
               wait-for go of frame f_dlg_01_criac_ped_exec.
           end /* else */.
    
           run pi_vld_criac_ped_exec /*pi_vld_criac_ped_exec*/. 
    
           save_block:
           do on error undo save_block, leave save_block:        
              assign ped_exec.cod_prog_dtsul = p_cod_prog_dtsul_w                 
                     ped_exec.nom_prog_ext   = replace(p_cod_prog_dtsul_rp, "~\", "~/").       
              if  ped_exec.cod_servid_exec:sensitive in frame f_dlg_01_criac_ped_exec = yes
              then do:
                 assign input frame f_dlg_01_criac_ped_exec ped_exec.cod_servid_exec.
              end /* if */.          
    
              assign input frame f_dlg_01_criac_ped_exec ped_exec.dat_exec_ped_exec
                     input frame f_dlg_01_criac_ped_exec ped_exec.hra_exec_ped_exec
                     input frame f_dlg_01_criac_ped_exec ped_exec.log_exec_prog_depend
                     input frame f_dlg_01_criac_ped_exec ped_exec.num_ped_exec
                     input frame f_dlg_01_criac_ped_exec ped_exec.num_ped_exec_pai
                     input frame f_dlg_01_criac_ped_exec ped_exec.log-1.
    
              if ped_exec.log-2:sensitive in frame f_dlg_01_criac_ped_exec then
                  assign input frame f_dlg_01_criac_ped_exec ped_exec.log-2.
    
              run pi_criar_ped_exec /*pi_criar_ped_exec*/.
    
              if tg-agenda-auto:SENSITIVE in frame f_dlg_01_criac_ped_exec and
                 input frame f_dlg_01_criac_ped_exec tg-agenda-auto = yes
              then do:
                  assign ped_exec.cod_orig_ped_exec = "Generico":U. /* INDICA QUE PEDIDO  DEPENDENTE DE AGENDA AUTOMµTICA */
    
                  if avail agenda-rpw
                  then do:
                      find current agenda-rpw exclusive-lock no-error.
                      assign agenda-rpw.dat-ult-exec = input frame f_dlg_01_criac_ped_exec ped_exec.dat_exec_ped_exec
                             agenda-rpw.hra-ult-exec = input frame f_dlg_01_criac_ped_exec ped_exec.hra_exec_ped_exec.
    
                      &if "{&mguni_version}" >= "2.05" &then
                          assign agenda-rpw.num-ult-ped-exec  = 0
                                 agenda-rpw.num-ult-ped-prog = if ped_exec.num_ped_exec <> 0
                                                                then ped_exec.num_ped_exec
                                                                else 0.
                      &else            
                          assign agenda-rpw.int-2 = 0
                                 agenda-rpw.int-1 = if ped_exec.num_ped_exec <> 0
                                                    then ped_exec.num_ped_exec
                                                    else 0.
                      &endif
    
                      find current agenda-rpw no-lock no-error.
                  end.
              end.
    
              assign v_rec_ped_exec = recid(ped_exec)
                     p_num_ped_exec = ped_exec.num_ped_exec.
              if  v_log_answer = yes
              then do:                                           
                 leave block.
              end /* if */.   
    
           end /* do save_block */.
       end /* repeat wait_block */.
    
    end /* do block */.
    
    hide frame f_dlg_01_criac_ped_exec.
    
    /* Begin_Include: i_log_exec_prog_dtsul_fim */
    log_exec_block:
    do transaction:
        find log_exec_prog_dtsul where recid(log_exec_prog_dtsul) = v_rec_log exclusive-lock no-error.
        if  avail log_exec_prog_dtsul
        then do:
            assign log_exec_prog_dtsul.dat_fim_exec_prog_dtsul = today
                   log_exec_prog_dtsul.hra_fim_exec_prog_dtsul = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/),":","").
        end /* if */.
        release log_exec_prog_dtsul.
    end /* do log_exec_block */.
    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-disp-browse wWindow 
PROCEDURE pi-disp-browse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-industr.
    EMPTY TEMP-TABLE tt-ind-bo.

    RUN setConstraintFiltro IN h-boes705 (INPUT l-pendente,
                                          INPUT l-confirmado,
                                          INPUT l-emitido,
                                          INPUT l-atualizado,
                                          INPUT l-finalizado,
                                          INPUT l-cancelado).

    RUN openQueryStatic IN h-boes705 (INPUT "Filtro":U) NO-ERROR.

    EMPTY TEMP-TABLE tt-ind-bo.

    RUN getBatchRecords IN h-boes705 (INPUT ?,
                                      INPUT ?,
                                      INPUT ?,
                                      OUTPUT iqtd,
                                      OUTPUT TABLE tt-ind-bo).


    FOR EACH tt-ind-bo:

        FOR FIRST ord-prod NO-LOCK
            WHERE ord-prod.nr-ord-produ = tt-ind-bo.nr-ord-produ:

            CREATE tt-industr.

            BUFFER-COPY tt-ind-bo TO tt-industr.
    
            ASSIGN tt-industr.selecao       = FALSE
                   tt-industr.it-codigo     = ord-prod.it-codigo
                   tt-industr.quantidade    = ord-prod.qt-ordem.

            FOR FIRST docum-est NO-LOCK
                WHERE ROWID(docum-est) = TO-ROWID(tt-industr.rw-doc-serv):

                ASSIGN tt-industr.serie-docto-serv = docum-est.serie-docto
                       tt-industr.nro-docto-serv   = docum-est.nro-docto 
                       tt-industr.nat-oper-serv    = docum-est.nat-operacao 
                       tt-industr.cod-emitente     = docum-est.cod-emitente.

                IF docum-est.ce-atual THEN DO:

                    FOR FIRST nota-fiscal NO-LOCK
                        WHERE nota-fiscal.cod-estabel = tt-industr.cod-estabel
                        AND   nota-fiscal.serie       = docum-est.serie-docto
                        AND   nota-fiscal.nr-nota-fis = docum-est.nro-docto:

                        ASSIGN tt-industr.nr-nota-fis-serv = nota-fiscal.nr-nota-fis.

                    END.

                END.

            END.

            FOR FIRST docum-est NO-LOCK
                WHERE ROWID(docum-est) = TO-ROWID(tt-industr.rw-doc-ret):

                ASSIGN tt-industr.serie-docto-ret = docum-est.serie-docto
                       tt-industr.nro-docto-ret   = docum-est.nro-docto
                       tt-industr.nat-oper-ret    = docum-est.nat-operacao.

                IF docum-est.ce-atual THEN DO:

                    FOR FIRST nota-fiscal NO-LOCK
                        WHERE nota-fiscal.cod-estabel = tt-industr.cod-estabel
                        AND   nota-fiscal.serie       = docum-est.serie-docto
                        AND   nota-fiscal.nr-nota-fis = docum-est.nro-docto:

                        ASSIGN tt-industr.nr-nota-fis-ret = nota-fiscal.nr-nota-fis.

                    END.

                END.

            END.

        END.
        
    END.

    {&open-query-br-industr}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-elimina-industr wWindow 
PROCEDURE pi-elimina-industr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF AVAIL tt-industr THEN DO:

        RUN goToKey IN h-boes705 (INPUT tt-industr.nr-ord-produ).

        RUN deleteRecord IN h-boes705.

        IF RETURN-VALUE = "OK" THEN DO:

            DELETE tt-industr.

            br-industr:REFRESH() IN FRAME fpage0.

        END.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-fichacq wWindow 
PROCEDURE pi-fichacq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN vNomProg = "CP0311". 

    FOR FIRST movto-estoq NO-LOCK
        WHERE movto-estoq.cod-estabel   = ficha-cq.cod-estabel
        and   movto-estoq.nr-ord-produ  = ficha-cq.nr-ord-produ
        AND   movto-estoq.it-codigo     = ficha-cq.it-codigo
        and   movto-estoq.serie         = ficha-cq.serie          
        and   movto-estoq.nro-docto     = ficha-cq.nro-docto      
        and   movto-estoq.cod-emitente  = ficha-cq.cod-emitente   
        and   movto-estoq.nat-operacao  = ficha-cq.nat-operacao   
        and   movto-estoq.dt-trans      = ficha-cq.dt-ficha       
        AND   movto-estoq.quantidade    = ficha-cq.qt-original    
        AND   movto-estoq.esp-docto     = 1:

        IF ficha-cq.cod-estabel = "101" OR
           (ficha-cq.cod-estabel <> "101" AND (ord-prod.tipo = 2 OR ord-prod.tipo = 5)) THEN DO:

            RUN piTrataFicha.

        END.
            
    END.

    ASSIGN vNomProg = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-docto wWindow 
PROCEDURE pi-gera-docto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE i-seq-doc AS INTEGER     NO-UNDO.
    DEFINE VARIABLE raw-param AS RAW       NO-UNDO.
    DEFINE VARIABLE l-erro AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE c-spool-win AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-spool-unix AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE h-caminho AS HANDLE      NO-UNDO.
    DEFINE VARIABLE l-criou AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE c-retorno AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-primeiro AS LOGICAL     INIT TRUE NO-UNDO.
    
    
    /* Cria‡Æo do diret¢rio para os logs */

    RUN esp/es0018p.p (INPUT  "spool-win":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).
    
    FOR FIRST tt-prog-ponto:

        ASSIGN c-spool-win = tt-prog-ponto.conteudo + "\" + c-seg-usuario + "\".

        OS-CREATE-DIR VALUE(c-spool-win).

        IF OS-ERROR <> 0 THEN DO:

            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "NÆo foi poss¡vel criar diret¢rio para gera‡Æo dos logs: " + c-spool-win).

            RETURN "NOK":U.

        END.

    END.

    RUN esp/es0018p.p (INPUT  "spool-unix":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR FIRST tt-prog-ponto:

        ASSIGN c-spool-unix = tt-prog-ponto.conteudo + "/" + c-seg-usuario + "/".

    END.


    ASSIGN l-erro = FALSE.

    RUN conecta-rpc IN THIS-PROCEDURE (output hproc).

    IF RETURN-VALUE = "NOK" THEN DO:
        RUN ShowMessage (1, "Erro na conex’o com o servidor RPC", 
                            "N’o foi poss¡vel conectar o servidor RPC. Encaminhe esta mensagem para TIC. Mensagem:" + c-msg-erro).
    
        RUN desconecta-rpc IN THIS-PROCEDURE (INPUT hproc).
        ASSIGN hproc = ?.

        RETURN "NOK":U.
        
    END.

    run utp/ut-acomp.p persistent set h-acomp.  
    run pi-inicializar in h-acomp (input "Processando").



    /* Autentica»’o usuÿrio TOTVS11 RPC */

    create tt-control-prog.
    assign tt-control-prog.cod-versao-integracao = 1.
    
    assign tt-control-prog.wgh-servid-rpc = hproc.
    
    run btb/btb923za.p (input-output table tt-control-prog).


    /* Execu‡Æo do RP.P */

    FOR EACH tt-industr
        WHERE tt-industr.selecao
        AND   tt-industr.situacao = 2:   /* Confirmado */

        FOR FIRST ord-prod NO-LOCK
            WHERE ord-prod.nr-ord-produ = tt-industr.nr-ord-produ,
        FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = ord-prod.it-codigo,
        FIRST pedido-compr NO-LOCK
            WHERE pedido-compr.num-pedido = tt-industr.num-pedido,
        FIRST ordem-compra NO-LOCK
            WHERE ordem-compra.num-pedido = pedido-compr.num-pedido:

            RUN pi-acompanhar IN h-acomp (INPUT "Pedido: " + STRING(pedido-compr.num-pedido)).

            FOR LAST docum-est NO-LOCK
                WHERE docum-est.serie = "8"
                AND   docum-est.cod-emitente = ordem-compra.cod-emitente
                BY docum-est.nro-docto:

                IF l-primeiro THEN
                    ASSIGN i-seq-doc = INT(docum-est.nro-docto) + 1
                           l-primeiro = FALSE.
                ELSE
                    ASSIGN i-seq-doc = INT(docum-est.nro-docto) + 2.
        
            END.

            EMPTY TEMP-TABLE tt-param.
            EMPTY TEMP-TABLE tt-digita.
            EMPTY TEMP-TABLE tt-raw-digita.
                     
            CREATE tt-param.
            ASSIGN tt-param.destino           = 2 /* Arquivo */                                                                               
                   tt-param.arquivo           = c-spool-unix + "/" + 'escpp093-gera-doc-' + c-seg-usuario + "-" + string(pedido-compr.num-pedido) + "-" + string(TIME) + '.lst'
                   tt-param.usuario           = c-seg-usuario                                                                                 
                   tt-param.data-exec         = TODAY                                                                                         
                   tt-param.hora-exec         = TIME                                                                                          
                   tt-param.cod-estabel       = ord-prod.cod-estabel                                                                          
                   tt-param.serie             = "8"                                                                                           
                   tt-param.nro-docto         = i-seq-doc                                                                                     
                   tt-param.nat-retorno       = "190201"                                                                                      
                   tt-param.nat-servico       = "112401"                                                                                      
                   tt-param.num-pedido        = pedido-compr.num-pedido                                                                       
                   tt-param.nr-ord-prod       = ord-prod.nr-ord-produ                                                                         
                   tt-param.dt-trans          = TODAY                                                                                         
                   tt-param.cod-depos-ret     = "ind"                                                                                         
                   tt-param.cod-depos-serv    = "alm"                                                                                         
                   tt-param.cod-fornec        = ordem-compra.cod-emitente                                                                     
                   tt-param.it-codigo         = ord-prod.it-codigo                                                                            
                   tt-param.qtd               = ordem-compra.qt-solic                                                                         
                   tt-param.cod-modalid-frete = "0".

            RAW-TRANSFER tt-param TO raw-param.
            
            /**/

            ASSIGN tt-industr.serie-docto-serv   = tt-param.serie
                   tt-industr.nro-docto-serv     = string(tt-param.nro-docto, "9999999")
                   tt-industr.serie-docto-ret    = tt-param.serie
                   tt-industr.nro-docto-ret      = string(tt-param.nro-docto, "9999999")
                   tt-industr.cod-emitente  = tt-param.cod-fornec
                   tt-industr.nat-oper-ret  = "190201"
                   tt-industr.nat-oper-serv = "112401".

            /*RUN pi-atualiza-dados-docto.*/

        
             IF VALID-HANDLE(hproc) THEN DO:

                SESSION:SET-WAIT-STATE("GENERAL":U).

                RUN esp/rep/esrep031rp.p  ON SERVER hproc(INPUT raw-param,
                                                          INPUT TABLE tt-raw-digita).

                ASSIGN c-retorno = RETURN-VALUE.

                SESSION:SET-WAIT-STATE("":U).

                if c-retorno = "NOK" then do:

                    ASSIGN tt-industr.serie-docto-serv   = ""
                           tt-industr.nro-docto-serv     = ""
                           tt-industr.serie-docto-ret   = ""
                           tt-industr.nro-docto-ret     = ""
                           tt-industr.cod-emitente  = 0
                           tt-industr.nat-oper-ret  = ""
                           tt-industr.nat-oper-serv = "".

                   IF c-msg-erro > "" THEN DO:
                       RUN ShowMessage (1, entry(1, c-msg-erro, "|"), 
                                        IF NUM-ENTRIES(c-msg-erro, "|") = 2 THEN entry(2, c-msg-erro, "|") ELSE "" ) .
                   END.
                   ASSIGN l-erro = TRUE.
                end.
                ELSE DO:

                    RUN pi-atualiza-dados-docto.

                    RUN pi-atualizar.
                   
                end.
        
            END.
            ELSE DO:
                
                RUN ShowMessage (1, "Erro na conex’o com o servidor RPC", 
                                    "N’o foi poss­vel conectar o servidor RPC. Entre em contato com o responsÿvel em TI").
                ASSIGN l-erro = TRUE.
            END.
            
        END.   /* for first ord-prod / item / pedido-compr / ordem-compra */

    END.  /* for each tt-industr */



    /* Finaliza‡Æo */
    RUN pi-finalizar IN h-acomp.
    RUN desconecta-rpc IN THIS-PROCEDURE (INPUT hproc).
    ASSIGN hproc = ?.
    {&open-query-br-industr}


    RUN ShowMessage(2, "Execu‡Æo finalizada. Verifique os logs em " + c-spool-win, "").

    IF l-erro THEN
        RETURN 'nok':U.
    ELSE
        RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-nf wWindow 
PROCEDURE pi-gera-nf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE raw-param AS RAW       NO-UNDO.
    DEFINE VARIABLE l-erro AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE c-spool-win AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-spool-unix AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE h-caminho AS HANDLE      NO-UNDO.
    DEFINE VARIABLE l-criou AS LOGICAL     NO-UNDO.
    
    
    
    /* Cria‡Æo do diret¢rio para os logs */

    RUN esp/es0018p.p (INPUT  "spool-win":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).
    
    FOR FIRST tt-prog-ponto:

        ASSIGN c-spool-win = tt-prog-ponto.conteudo + "\" + c-seg-usuario + "\".

        OS-CREATE-DIR VALUE(c-spool-win).

        IF OS-ERROR <> 0 THEN DO:

            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "NÆo foi poss¡vel criar diret¢rio para gera‡Æo dos logs: " + c-spool-win).

            RETURN "NOK":U.

        END.

    END.

    RUN esp/es0018p.p (INPUT  "spool-unix":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR FIRST tt-prog-ponto:

        ASSIGN c-spool-unix = tt-prog-ponto.conteudo + "/" + c-seg-usuario + "/".

    END.



    ASSIGN l-erro = FALSE.

    RUN conecta-rpc IN THIS-PROCEDURE (output hproc).

    IF RETURN-VALUE = "NOK" THEN DO:
        RUN ShowMessage (1, "Erro na conex’o com o servidor RPC", 
                            "N’o foi poss¡vel conectar o servidor RPC. Encaminhe esta mensagem para TIC. Mensagem:" + c-msg-erro).
    
        RUN desconecta-rpc IN THIS-PROCEDURE (INPUT hproc).
        ASSIGN hproc = ?.

        RETURN "NOK":U.
        
    END.


    run utp/ut-acomp.p persistent set h-acomp.  
    run pi-inicializar in h-acomp (input "Processando").



    /* Autentica»’o usuÿrio TOTVS11 RPC */

    create tt-control-prog.
    assign tt-control-prog.cod-versao-integracao = 1.
    
    assign tt-control-prog.wgh-servid-rpc = hproc.
    
    run btb/btb923za.p (input-output table tt-control-prog).



    /* Execu‡Æo do RP.P */

    EMPTY TEMP-TABLE tt-param2.
    EMPTY TEMP-TABLE tt-digita.
    EMPTY TEMP-TABLE tt-raw-digita.
             
    CREATE tt-param2.
    ASSIGN tt-param2.destino            = 2 /* Arquivo */                                                                               
           tt-param2.arquivo            = c-spool-unix + "/" + 'escpp093-gera-nf-' + c-seg-usuario + "-" + string(TIME) + '.lst'
           tt-param2.usuario            = c-seg-usuario                                                                                 
           tt-param2.data-exec          = TODAY                                                                                         
           tt-param2.hora-exec          = TIME                                                                                          
           tt-param2.c-cod-estab        = v_cod_estab_usuar
           tt-param2.da-dt-trans-ini    = TODAY
           tt-param2.da-dt-trans-fim    = TODAY
           tt-param2.c-ser-ini          = "" 
           tt-param2.c-ser-fim          = "ZZZZZ"
           tt-param2.c-num-ini          = ""
           tt-param2.c-num-fim          = "9999999999999999"
           tt-param2.i-emit-ini         = 0
           tt-param2.i-emit-fim         = 999999999
           tt-param2.c-nat-ini          = ""
           tt-param2.c-nat-fim          = "ZZZZZZ"
           tt-param2.c-usuar-ini        = c-seg-usuario
           tt-param2.c-usuar-fim        = c-seg-usuario.

    RAW-TRANSFER tt-param2 TO raw-param.

    FOR EACH tt-industr
        WHERE tt-industr.selecao
        AND   tt-industr.situacao = 3:   /* Emitido */

        FOR FIRST ord-prod NO-LOCK
            WHERE ord-prod.nr-ord-produ = tt-industr.nr-ord-produ,
        FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = ord-prod.it-codigo,
        FIRST pedido-compr NO-LOCK
            WHERE pedido-compr.num-pedido = tt-industr.num-pedido,
        FIRST ordem-compra NO-LOCK
            WHERE ordem-compra.num-pedido = pedido-compr.num-pedido:

            /**/

            CREATE tt-digita.
            ASSIGN tt-digita.serie-docto    = tt-industr.serie-docto-serv
                   tt-digita.nro-docto      = tt-industr.nro-docto-serv
                   tt-digita.cod-emitente   = tt-industr.cod-emitente
                   tt-digita.nat-operacao   = tt-industr.nat-oper-serv.

            CREATE tt-digita.
            ASSIGN tt-digita.serie-docto    = tt-industr.serie-docto-ret
                   tt-digita.nro-docto      = tt-industr.nro-docto-ret
                   tt-digita.cod-emitente   = tt-industr.cod-emitente
                   tt-digita.nat-operacao   = tt-industr.nat-oper-ret.

            RUN pi-acompanhar IN h-acomp (INPUT "Pedido: " + STRING(pedido-compr.num-pedido)).

        END.

    END.

    FOR EACH tt-digita:
        CREATE tt-raw-digita.
        RAW-TRANSFER tt-digita TO tt-raw-digita.raw-digita.
    END.
            
    /**/

    IF VALID-HANDLE(hproc) THEN DO:

        SESSION:SET-WAIT-STATE("GENERAL":U).

        RUN esp/rep/esrep1005rp.p ON SERVER hproc (INPUT raw-param,
                                                   INPUT TABLE tt-raw-digita).
        SESSION:SET-WAIT-STATE("":U).
        
        if return-value = "NOK" then do:
           IF c-msg-erro > "" THEN DO:
               RUN ShowMessage (1, entry(1, c-msg-erro, "|"), 
                                IF NUM-ENTRIES(c-msg-erro, "|") = 2 THEN entry(2, c-msg-erro, "|") ELSE "" ) .
           END.
           ASSIGN l-erro = TRUE.
        end.
        ELSE DO:

            FOR EACH tt-industr
                WHERE tt-industr.selecao
                AND   tt-industr.situacao = 3:   /* Emitido */
    
                RUN pi-atualiza-dados-nf.
    
                RUN pi-atualizar.

            END.
           
        end.

    END.
    ELSE DO:
        RUN ShowMessage (1, "Erro na conex’o com o servidor RPC", 
                            "N’o foi poss­vel conectar o servidor RPC. Entre em contato com o responsÿvel em TI").
        ASSIGN l-erro = TRUE.
    END.

    /* Finaliza‡Æo */
    RUN pi-finalizar IN h-acomp.
    RUN desconecta-rpc IN THIS-PROCEDURE (INPUT hproc).
    ASSIGN hproc = ?.
    {&open-query-br-industr}


    RUN ShowMessage(2, "Execu‡Æo finalizada. Verifique os logs em " + c-spool-win, "").

    IF l-erro THEN
        RETURN 'nok':U.
    ELSE
        RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-pendente wWindow 
PROCEDURE pi-pendente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH tt-industr
        WHERE tt-industr.selecao
        AND   (tt-industr.nr-nota-fis-serv = "" OR tt-industr.nr-nota-fis-serv = ?)
        AND   tt-industr.situacao <> 1:  

        RUN pi-altera-situacao (INPUT 1).  /* Pendente */

    END.

    br-industr:REFRESH() IN FRAME fPage0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-reporta-op wWindow 
PROCEDURE pi-reporta-op :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-seq-doc AS INTEGER     NO-UNDO.
    DEFINE VARIABLE raw-param AS RAW       NO-UNDO.
    DEFINE VARIABLE h-caminho AS HANDLE      NO-UNDO.
    DEFINE VARIABLE l-criou AS LOGICAL     NO-UNDO.
    
    DEFINE VARIABLE c-depos-ent AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-depos-sai AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-qtd-cont AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE c-cod-localiz AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-operacao AS LOGICAL     NO-UNDO.
    
    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT "bloq-rep", /* Nome do programa */
                       INPUT 1,          /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto).    

    IF CAN-FIND(FIRST tt-prog-ponto NO-LOCK 
                WHERE entry(1, tt-prog-ponto.conteudo, ";") = v_cod_estab_usuar
                AND   entry(2, tt-prog-ponto.conteudo, ";") = "bloqueia") THEN DO:

        RUN utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 17006, 
                           INPUT "Reportes estÆo bloqueados para realiza‡Æo do Planejamento. Aguarde libera‡Æo.").
        RETURN ERROR.
    END.
    
    RUN conecta-rpc IN THIS-PROCEDURE (output hproc).

    IF RETURN-VALUE = "NOK" THEN DO:
        RUN ShowMessage (1, "Erro na conex’o com o servidor RPC - Ponto 1", 
                            "N’o foi poss¡vel conectar o servidor RPC. Encaminhe esta mensagem para TIC. Mensagem:" + c-msg-erro).
    
        RUN desconecta-rpc IN THIS-PROCEDURE (INPUT hproc).
        ASSIGN hproc = ?.

        RETURN "NOK":U.
        
    END.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar IN h-acomp (INPUT "Processando").


    /* Autentica»’o usuÿrio TOTVS11 RPC */
    CREATE tt-control-prog.
    ASSIGN tt-control-prog.cod-versao-integracao = 1.
    
    ASSIGN tt-control-prog.wgh-servid-rpc = hproc.
    
    RUN btb/btb923za.p (INPUT-OUTPUT TABLE tt-control-prog).

    /* Execu‡Æo do RP.P */
    FOR EACH tt-industr
        WHERE tt-industr.selecao
        AND   tt-industr.situacao = 4:   /* Atualizado */

        FOR FIRST ord-prod NO-LOCK
            WHERE ord-prod.nr-ord-produ = tt-industr.nr-ord-produ,
        FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = ord-prod.it-codigo,
        FIRST pedido-compr NO-LOCK
            WHERE pedido-compr.num-pedido = tt-industr.num-pedido,
        FIRST ordem-compra NO-LOCK
            WHERE ordem-compra.num-pedido = pedido-compr.num-pedido:

            RUN pi-acompanhar IN h-acomp (INPUT "Pedido: " + STRING(pedido-compr.num-pedido)).

            FOR FIRST docum-est NO-LOCK
                WHERE rowid(docum-est) = to-rowid(tt-industr.rw-doc-serv):

                
                IF VALID-HANDLE(hproc) THEN DO:
                    
                    ASSIGN c-depos-ent = ord-prod.cod-depos.

                    FIND FIRST int-lin-prod 
                        WHERE int-lin-prod.cod-estabel = ord-prod.cod-estabel 
                        AND   int-lin-prod.nr-linha    = ord-prod.nr-linha NO-LOCK NO-ERROR.

                    IF AVAIL int-lin-prod THEN DO:
                        
                        IF int-lin-prod.transf-auto = YES AND
                           int-lin-prod.deposito-trans <> "" THEN
                            ASSIGN c-depos-ent = int-lin-prod.deposito-trans.

                        ASSIGN c-depos-sai = int-lin-prod.deposito-saida.

                    END.
                    ELSE DO:
                        run utp/ut-msgs.p (INPUT "show":U, 
                                           INPUT 17567, 
                                           INPUT "A linha de produ‡Æo do Item deve ser definida.").

                        RUN pi-finalizar IN h-acomp.
                        RUN desconecta-rpc IN THIS-PROCEDURE (INPUT hproc).
                        ASSIGN hproc = ?.

                        RETURN ERROR.
                    END.
                                    
                    /* Verifica tipo de Requisi‡Æo do item */
                    EMPTY TEMP-TABLE tt-estrutura.
        
                    RUN esapi/esapi006.p ( INPUT ROWID(ITEM),  /* Rowid */
                                           INPUT "",           /* Refer */
                                           INPUT 1,            /* Quantidade */
                                           INPUT 0,            /* Quantidade Liq */
                                           INPUT 0,            /* N¡vel */
                                           INPUT-OUTPUT TABLE tt-estrutura,
                                           INPUT TODAY,        /* Data Corte */
                                           INPUT YES,          /* Recursivo */
                                           INPUT 19,           /* N¡veis */
                                           INPUT ord-prod.cod-estabel).       /* Estabel */

                    FOR EACH tt-estrutura
                        WHERE tt-estrutura.log-fantasma = NO:

                        FOR FIRST item-uni-estab FIELDS(it-codigo tipo-requis) NO-LOCK
                            WHERE item-uni-estab.cod-estabel = ord-prod.cod-estabel
                            AND   item-uni-estab.it-codigo   = tt-estrutura.es-codigo:

                            IF  item-uni-estab.tipo-requis = 3 THEN DO:

                                run utp/ut-msgs.p (INPUT "show":U, 
                                                   INPUT 17567, 
                                                   INPUT "O Componente " + tt-estrutura.es-codigo + " ‚ do tipo de REPORTE GGF, favor verificar.").

                                RUN pi-finalizar IN h-acomp.
                                RUN desconecta-rpc IN THIS-PROCEDURE (INPUT hproc).
                                ASSIGN hproc = ?.

                                RETURN ERROR.
                            END.
                        END.
                    END.

                    ASSIGN i-qtd-cont = ord-prod.qt-ordem - ord-prod.qt-produzida.
                        
                    IF  i-qtd-cont = 0 THEN DO:

                        run utp/ut-msgs.p (INPUT "show":U, 
                                           INPUT 17006, 
                                           INPUT "Quantidade total da ordem j  foi reportada.").

                        RUN pi-finalizar IN h-acomp.
                        RUN desconecta-rpc IN THIS-PROCEDURE (INPUT hproc).
                        ASSIGN hproc = ?.

                        RETURN ERROR.

                    END.

                    ASSIGN c-cod-localiz = "".
            
                    EMPTY TEMP-TABLE ttRepApi.

                    CREATE ttRepApi.
                    ASSIGN ttRepApi.nr-ord-produ    = ord-prod.nr-ord-produ    
                           ttRepApi.op-codigo       = 0                        
                           ttRepApi.qt-reporte      = i-qtd-cont               
                           ttRepApi.depos-ent       = c-depos-ent              
                           ttRepApi.depos-sai       = c-depos-sai              
                           ttRepApi.c-enche         = "TOTAL"                  
                           ttRepApi.cEtiqueta       = ""                       
                           ttRepApi.c-nome-imp      = ""                       
                           ttRepApi.cNomeLayout     = ""                       
                           ttRepApi.nao-imprimir    = NO                       
                           ttRepApi.da-data-reporte = TODAY                    
                           ttRepApi.l-ver-sel       = NO                       
                           ttRepApi.c-localizacao   = c-cod-localiz            
                           ttRepApi.linha           = "".
            
                    ASSIGN l-operacao = YES.
                    FIND FIRST b-operacao OF item NO-LOCK NO-ERROR.
                    IF NOT AVAIL b-operacao THEN ASSIGN l-operacao = NO.
                    
                    IF l-operacao = NO THEN DO:
                        FIND FIRST b-rot-item OF item NO-LOCK NO-ERROR.
                        IF NOT AVAIL b-rot-item THEN DO:
                            run utp/ut-msgs.p (INPUT "show":U, 
                                               INPUT 17567, 
                                               INPUT "Item deve possuir uma opera‡Æo ou roteiro cadastrado. Reporte nÆo pode ser efetuado!").

                            RUN pi-finalizar IN h-acomp.
                            RUN desconecta-rpc IN THIS-PROCEDURE (INPUT hproc).
                            ASSIGN hproc = ?.

                            RETURN ERROR.
                        END.
                    END.

                    ASSIGN l-operacao = YES.
                    FIND FIRST oper-ord 
                         WHERE oper-ord.nr-ord-prod = ord-prod.nr-ord-prod NO-LOCK no-error.
                    IF NOT AVAIL oper-ord THEN ASSIGN l-operacao = NO.
                    
                    IF l-operacao = NO THEN DO:
                        run utp/ut-msgs.p (INPUT "show":U, 
                                           INPUT 17567, 
                                           INPUT "A ORDEM " + string(ord-prod.nr-ord-prod) + " deve possuir uma opera‡Æo cadastrada. Reporte nÆo pode ser efetuado! ").

                        RUN pi-finalizar IN h-acomp.
                        RUN desconecta-rpc IN THIS-PROCEDURE (INPUT hproc).
                        ASSIGN hproc = ?.

                        RETURN ERROR.
                    END.

                    SESSION:SET-WAIT-STATE("GENERAL":U).

                    RUN esapi/esapi001a.p PERSISTENT SET hprog ON SERVER hproc.

                    EMPTY TEMP-TABLE tt-erro.

                    RUN piInicializaReporte IN hprog (INPUT TABLE ttRepApi,
                                                      INPUT "NORMAL").

                    RUN piReportaProducao IN hprog (INPUT tt-industr.cod-estabel,
                                                    INPUT 1,
                                                    INPUT ROWID(ord-prod)).  /* CPP */

                    EMPTY TEMP-TABLE tt-erro.

                    RUN piRetornaErro IN hprog (OUTPUT TABLE tt-erro).

                    RUN pi-Destroy IN hprog.

                    DELETE OBJECT hprog.
                    ASSIGN hprog = ?.

                    SESSION:SET-WAIT-STATE("":U).
                    
                    IF CAN-FIND (FIRST tt-erro) THEN DO:

                        RUN cdp/cd0666.w (INPUT TABLE tt-erro).

                        RUN pi-finalizar IN h-acomp.
                        RUN desconecta-rpc IN THIS-PROCEDURE (INPUT hproc).
                        ASSIGN hproc = ?.
                       

                        RETURN ERROR.

                    END. 
                    ELSE DO:
                        RUN pi-altera-situacao(5).  /* Finalizado */
                    
                        FIND FIRST ficha-cq NO-LOCK
                            WHERE ficha-cq.cod-estabel  = ord-prod.cod-estabel
                            and   ficha-cq.nr-ord-produ = ord-prod.nr-ord-produ 
                            AND   ficha-cq.serie        = ""
                            AND   ficha-cq.nro-docto    = STRING(ord-prod.nr-ord-produ)
                            AND   ficha-cq.cod-emitente = 0
                            AND   ficha-cq.nat-operacao = ""
                            AND   ficha-cq.nr-ord-cq    = 0
                            AND   ficha-cq.situacao     = 1 NO-ERROR.
                
                        IF AVAIL ficha-cq THEN do:
                            RUN pi-fichacq.
                        END.
                    END.

                END.
                ELSE DO:
                    RUN ShowMessage (1, "Erro na conex’o com o servidor RPC - Ponto 2", 
                                        "N’o foi poss­vel conectar o servidor RPC. Entre em contato com o responsÿvel em TI").
                END.

            END.  /* for first docum-est */
            
        END.   /* for first ord-prod / item / pedido-compr / ordem-compra */

    END.  /* for each tt-industr */

    /* Finaliza‡Æo */
    RUN pi-finalizar IN h-acomp.
    RUN desconecta-rpc IN THIS-PROCEDURE (INPUT hproc).
    ASSIGN hproc = ?.
    {&open-query-br-industr}

    RUN ShowMessage(2, "Execu‡Æo finalizada.", "").

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-saldo-terc wWindow 
PROCEDURE pi-saldo-terc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE de-saldo-ordem  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE i-sequencia     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE de-qtd-saldo    AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE l-reserva       AS LOGICAL     NO-UNDO.

    DEFINE VARIABLE de-quantidade   AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-preco-total  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE c-ordens-prod   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE de-diferenca    AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE l-algum-sem-saldo-geral AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE c-arq-lista-saldo AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE l-prim-saida AS LOGICAL    INIT TRUE NO-UNDO.

    FORM 
        tt-item-estrut.it-codigo FORMAT "x(12)" COLUMN-LABEL "Componente"
        b-item.desc-item  FORMAT "x(40)" COLUMN-LABEL "Descri‡Æo"
        de-quantidade  COLUMN-LABEL "Quantidade"
        de-qtd-saldo   COLUMN-LABEL "Saldo"
        de-diferenca   COLUMN-LABEL "Diferen‡a"
        c-ordens-prod  FORMAT "x(132)" COLUMN-LABEL "Ordens de Produ‡Æo" 
        WITH STREAM-IO NO-ATTR-SPACE NO-BOX WIDTH 255 DOWN FRAME f-saldo-label.

    FORM 
        tt-item-estrut.it-codigo FORMAT "x(12)" 
        b-item.desc-item  FORMAT "x(40)" 
        de-quantidade  
        de-qtd-saldo   
        de-diferenca  
        c-ordens-prod  FORMAT "x(132)" 
        WITH STREAM-IO NO-ATTR-SPACE NO-BOX NO-LABELS WIDTH 255 DOWN FRAME f-saldo.
    

    ASSIGN c-arq-lista-saldo = SESSION:TEMP-DIR + "escpp093-lista-saldo-" + string(YEAR(TODAY)) + '-' + STRING(MONTH(TODAY)) + '-' + STRING(DAY(TODAY)) + '-' + string(TIME) + ".txt"
           l-algum-sem-saldo-geral = FALSE.

    EMPTY TEMP-TABLE tt-item-estrut.

    FOR EACH tt-industr
        WHERE tt-industr.selecao
        AND   tt-industr.situacao = 1:  /* Pendente */

        FOR FIRST ord-prod NO-LOCK
            WHERE ord-prod.nr-ord-produ = tt-industr.nr-ord-produ,
        FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = ord-prod.it-codigo,
        FIRST pedido-compr NO-LOCK
            WHERE pedido-compr.num-pedido = tt-industr.num-pedido:

            /*EMPTY TEMP-TABLE tt-item-estrut.*/

            ASSIGN de-saldo-ordem = if   ord-prod.qt-ordem - ord-prod.qt-produzida > 0
                                    then ord-prod.qt-ordem - ord-prod.qt-produzida
                                    else 0.

            find last tt-item-estrut no-lock no-error.
    
            assign i-sequencia = if  avail tt-item-estrut then 
                                     tt-item-estrut.sequencia + 10
                                 else 
                                     10.

            for each reservas 
                fields (reservas.nr-ord-prod
                        reservas.quant-orig 
                        reservas.quant-atend
                        reservas.quant-terc
                        reservas.it-codigo)
                where reservas.nr-ord-prod = ord-prod.nr-ord-produ
                and   reservas.quant-orig  > 0 no-lock:
             
                assign de-qtd-saldo = reservas.quant-orig - (reservas.quant-atend + reservas.quant-terc).
        
                create tt-item-estrut.             
                assign tt-item-estrut.sequencia    = i-sequencia
                       tt-item-estrut.aux          = "*"
                       tt-item-estrut.it-codigo    = reservas.it-codigo
                       tt-item-estrut.nr-ord-prod  = reservas.nr-ord-prod
                       tt-item-estrut.quantidade   = de-saldo-ordem * reservas.quant-orig / ord-prod.qt-ordem
                       tt-item-estrut.rw-reservas  = rowid(reservas)
                       tt-item-estrut.cod-emitente = pedido-compr.cod-emitente
                       tt-item-estrut.cod-estabel  = pedido-compr.cod-estabel
                       i-sequencia                 = i-sequencia + 10.
                                                                          
                assign l-reserva = yes.
        
            end.

        END.

    END.
            
    /**/
    
    for each tt-item-saldo-terc:
        delete tt-item-saldo-terc.
    end.

    FOR EACH tt-item-saldo-terc-aux:
        DELETE tt-item-saldo-terc-aux.
    END.
    
    for each tt-item-estrut BREAK BY tt-item-estrut.it-codigo:
        
        IF FIRST-OF(tt-item-estrut.it-codigo) THEN
            assign de-quantidade   = 0
                   de-preco-total  = 0
                   c-ordens-prod   = "".

        assign de-quantidade             = de-quantidade  + tt-item-estrut.quantidade
               de-preco-total            = de-preco-total + tt-item-estrut.preco-total
               c-ordens-prod             = c-ordens-prod + IF c-ordens-prod = "" THEN STRING(tt-item-estrut.nr-ord-prod) ELSE "," + STRING(tt-item-estrut.nr-ord-prod)
               tt-item-estrut.preco-unit = tt-item-estrut.preco-total / tt-item-estrut.quantidade.

        IF LAST-OF(tt-item-estrut.it-codigo) THEN DO:

            ASSIGN de-qtd-saldo = 0.

            FIND FIRST b-ITEM NO-LOCK
                 WHERE b-ITEM.it-codigo = tt-item-estrut.it-codigo NO-ERROR.

            for each saldo-terc use-index estab-fornec
                where saldo-terc.it-codigo     = tt-item-estrut.it-codigo
                  and saldo-terc.cod-emitente  = tt-item-estrut.cod-emitente
                  and saldo-terc.cod-estabel   = tt-item-estrut.cod-estabel 
                  and saldo-terc.tipo-sal-terc = 1
                  and saldo-terc.quantidade    > 0 NO-LOCK
                by saldo-terc.dt-retorno :             

                /* --- its35061 --- */
                &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN 
                   IF i-pais-impto-usuario <> 1 AND saldo-terc.log-entreg-fut THEN
                       NEXT.
                &ENDIF

                /* O CAMPO DEC-1 ESTA SENDO UTILIZADO PARA ARMAZENAR O SALDO 
                    ALOCADO, OU SEJA, QUE JA ESTEJA SENDO UTILIZADO NA DIGITACAO 
                    DE OUTRA NOTA FISCAL 
                */

                assign de-qtd-saldo = de-qtd-saldo + saldo-terc.quantidade - saldo-terc.dec-1.
               
            end.            

            if de-quantidade - de-qtd-saldo > 0 then do:

                ASSIGN de-diferenca = de-qtd-saldo - de-quantidade
                       l-algum-sem-saldo-geral = TRUE.

                IF l-prim-saida THEN DO:
                    ASSIGN l-prim-saida = FALSE.
                    OUTPUT to value(c-arq-lista-saldo) NO-CONVERT.
                    PUT UNFORMATTED 
                        SKIP
                        '   *** Componentes sem saldo em Poder de Terceiros ***' SKIP(2).

                    DISP tt-item-estrut.it-codigo
                         b-item.desc-item
                         de-quantidade
                         de-qtd-saldo
                         de-diferenca
                         c-ordens-prod
                        WITH FRAME f-saldo-label.
                            
                END.
                ELSE DO:
                    OUTPUT to value(c-arq-lista-saldo) NO-CONVERT APPEND.

                     DISP tt-item-estrut.it-codigo
                          b-item.desc-item
                          de-quantidade
                          de-qtd-saldo
                          de-diferenca
                          c-ordens-prod
                         WITH FRAME f-saldo.

                END.

                OUTPUT CLOSE.

            end.
        END.
    end.


    IF NOT l-algum-sem-saldo-geral THEN DO:

        RUN utp/ut-msgs.p (INPUT 'show',
                           INPUT 27100,
                           INPUT "Deseja alterar a situa‡Æo para Confirmado ?").

        IF RETURN-VALUE = 'YES' THEN DO:

            FOR EACH tt-industr
                WHERE tt-industr.selecao
                AND   tt-industr.situacao = 1:
    
                RUN pi-altera-situacao (INPUT 2).  /* Confirmado */
    
            END.

        END.

        br-industr:REFRESH() IN FRAME fPage0.

    END.
    ELSE DO:

        run winexec (input "notepad.exe" + chr(32) + c-arq-lista-saldo, input 1).

    END.

    {&open-query-br-industr}
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piTrataFicha wWindow 
PROCEDURE piTrataFicha :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE i-ultimo-ae AS INTEGER     NO-UNDO.


    /*RUN piPedeDadosDocto.*/

    FIND CURRENT ficha-cq EXCLUSIVE-LOCK.

    FIND FIRST item-doc-est NO-LOCK
        WHERE item-doc-est.serie-docto  = docum-est.serie-docto
        AND   item-doc-est.nro-docto    = docum-est.nro-docto
        AND   item-doc-est.cod-emitente = docum-est.cod-emitente
        AND   item-doc-est.nat-operacao = docum-est.nat-operacao
        AND   item-doc-est.it-codigo    = tt-industr.it-codigo NO-ERROR.

    IF AVAIL item-doc-est THEN DO:

        MESSAGE 'achou item-doc-est'
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    
        ASSIGN ficha-cq.serie        = item-doc-est.serie-docto
               ficha-cq.nro-docto    = item-doc-est.nro-docto 
               ficha-cq.cod-emitente = item-doc-est.cod-emitente 
               ficha-cq.nat-operacao = item-doc-est.nat-operacao
               ficha-cq.nr-ord-cq    = item-doc-est.sequencia.
    
        /**/
    
        FIND CURRENT movto-estoq EXCLUSIVE-LOCK.
    
        ASSIGN movto-estoq.descricao-db = item-doc-est.serie-docto + ";" + item-doc-est.nro-docto + ";" + STRING(item-doc-est.cod-emitente) + ";" + item-doc-est.nat-operacao + ";" + string(item-doc-est.sequencia).
    
        FIND CURRENT movto-estoq NO-LOCK.
    
        /**/
    
        FIND CURRENT ficha-cq NO-LOCK.
    
        FIND CURRENT item-doc-est EXCLUSIVE-LOCK.
        ASSIGN item-doc-est.nr-ficha = ficha-cq.nr-ficha.
        FIND CURRENT item-doc-est NO-LOCK.
    
        FIND first mgesp.ae-entrada NO-LOCK
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
        
        FIND first mgesp.ae-inspecao NO-LOCK WHERE 
             ae-inspecao.cod-estabel  = movto-estoq.cod-estabel and
             ae-inspecao.nro-docto    = INT(ficha-cq.nro-docto) AND 
             ae-inspecao.serie        = ficha-cq.serie          AND 
             ae-inspecao.cod-emitente = ficha-cq.cod-emitente   AND
             ae-inspecao.nat-operacao = ficha-cq.nat-operacao   AND 
             ae-inspecao.it-codigo    = ficha-cq.it-codigo NO-ERROR.
        
        IF AVAIL ae-inspecao THEN 
            ASSIGN i-ultimo-ae = ae-inspecao.nr-ae.
        ELSE DO:    
            FIND FIRST mgesp.aviso-entrada EXCLUSIVE-LOCK
                where mgesp.aviso-entrada.cod-estabel = movto-estoq.cod-estabel NO-ERROR.
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
        
        FIND first ae-inspecao NO-LOCK WHERE 
             ae-inspecao.cod-estabel  = movto-estoq.cod-estabel and
             ae-inspecao.nro-docto    = INT(ficha-cq.nro-docto) AND 
             ae-inspecao.serie        = ficha-cq.serie          AND 
             ae-inspecao.cod-emitente = ficha-cq.cod-emitente   AND 
             ae-inspecao.nat-operacao = ficha-cq.nat-operacao   AND 
             ae-inspecao.it-codigo    = ficha-cq.it-codigo      AND 
             ae-inspecao.sequencia    = item-doc-est.sequencia NO-ERROR.
             
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

        IF AVAIL docum-est                AND 
           docum-est.cod-estabel  = "101" AND 
           (docum-est.cod-emitente = 18963 OR
            docum-est.cod-emitente = 175028) THEN DO:
            ASSIGN gr-documento = ROWID(docum-est).

            RUN pi-finalizar IN h-acomp.
    
            RUN esp/cqp/escqp003.w.
    
            ASSIGN gr-documento = ?.
        END.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-desc-item wWindow 
FUNCTION f-desc-item RETURNS CHARACTER
  ( INPUT p-it-codigo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FOR FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = p-it-codigo:

        RETURN ITEM.desc-item.

    END.

    RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-situacao wWindow 
FUNCTION f-situacao RETURNS CHARACTER
  ( INPUT p-situacao AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-sit AS CHARACTER   NO-UNDO.

    ASSIGN c-sit = {esinc/i01es704.i 04 p-situacao}.

    RETURN c-sit.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

