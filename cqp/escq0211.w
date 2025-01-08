&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-livre 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCQ0211 1.00.00.001}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ESCQ0211 <m¢dulo>}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

{cdp/cd0666.i}
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}
{cdp/cdcfgman.i}

/* DEF VAR hShowMsg AS HANDLE NO-UNDO.  */

&if "{&bf_mat_versao_ems}" >= "2.062" &then
     {cep/ceapi001k.i}
     {cdp/cd9590.i}
    
    DEF BUFFER b-tt-movto FOR tt-movto.

    DEF VAR h-ceapi001k      AS HANDLE NO-UNDO.
    DEF VAR h-cdapi024       AS HANDLE NO-UNDO.
    DEF VAR c-unid-negoc     AS CHAR NO-UNDO.
    DEF VAR c-unid-negoc-des AS CHAR NO-UNDO.
&ELSE      
    {cep/ceapi001.i}
&ENDIF

/* Variaveis utilizadas na cd9320.i1 */
&IF '{&bf_lote_avancado_liberado}' = 'yes' &THEN
    DEF VAR severa-normal-lote        AS INT NO-UNDO.
    DEF VAR severa-normal-rejeitado   AS INT NO-UNDO.
    DEF VAR normal-severa-lote        AS INT NO-UNDO.
    DEF VAR normal-severa-rejeitado   AS INT NO-UNDO.
    DEF VAR normal-atenuada-lote      AS INT NO-UNDO.
    DEF VAR normal-atenuada-rejeitado AS INT NO-UNDO.
    DEF VAR atenuada-normal-lote      AS INT NO-UNDO.
    DEF VAR atenuada-normal-rejeitado AS INT NO-UNDO.
&endif


DEFINE TEMP-TABLE tt-ficha NO-UNDO
    FIELD l-marcado          AS LOG FORM "*/"  
    FIELD nr-ficha           LIKE ficha-cq.nr-ficha
    FIELD cod-emitente       LIKE movto-estoq.cod-emitente
    FIELD it-codigo          LIKE ficha-cq.it-codigo
    FIELD desc-item          LIKE ITEM.desc-item
    FIELD quantidade         LIKE movto-estoq.quantidade
    FIELD nat-operacao       LIKE ficha-cq.nat-operacao
    FIELD situacao           AS CHAR FORMAT "x(20)"
    FIELD cod-estabel        LIKE ficha-cq.cod-estabel
    FIELD cod-depos          LIKE ficha-cq.cod-depos
    FIELD cod-localiz        LIKE ficha-cq.cod-localiz
    FIELD lote               LIKE ficha-cq.lote
    FIELD dt-vali            LIKE saldo-estoq.dt-vali-lote
    FIELD cod-refer          LIKE movto-estoq.cod-refer
    FIELD un                 LIKE movto-estoq.un
    FIELD cod-resp           LIKE ficha-cq.cod-resp
    FIELD dt-trans           AS DATE FORMAT 99/99/9999
    FIELD serie-docto        LIKE movto-estoq.serie-docto
    FIELD nro-docto          LIKE movto-estoq.nro-docto
    FIELD conta-contabil     LIKE movto-estoq.conta-contabil
    FIELD mov-cod-estabel    LIKE ficha-cq.cod-estabel
    FIELD mov-cod-depos      LIKE ficha-cq.cod-depos
    FIELD mov-cod-localiz    LIKE ficha-cq.cod-localiz
    FIELD mov-lote           LIKE ficha-cq.lote
    FIELD mov-dt-vali        LIKE saldo-estoq.dt-vali-lote
    FIELD mov-cod-refer      LIKE movto-estoq.cod-refer
    FIELD per-ppm            LIKE saldo-estoq.per-ppm
    FIELD valida-retorno     AS LOGICAL INITIAL YES
    FIELD origem             LIKE ficha-cq.origem
    FIELD baixa-estoq        LIKE ficha-cq.baixa-estoq.

DEF temp-table tt-gera-transf NO-UNDO
    FIELD l-considera   AS CHAR FORMAT "x(01)" LABEL "Retorna Roteiro?"
    FIELD cod-estabel   LIKE ficha-cq.cod-estabel
    FIELD nr-ficha      LIKE ficha-cq.nr-ficha
    FIELD it-codigo     LIKE ficha-cq.it-codigo
    FIELD desc-item     LIKE ITEM.desc-item
    FIELD dt-fabricacao AS DATE FORMAT "99/99/9999" LABEL "DT Fabrica‡Æo"
    FIELD quantidade    LIKE ficha-cq.qt-original
    FIELD dep-saida     LIKE ficha-cq.cod-depos
    FIELD loc-saida     LIKE ficha-cq.cod-localiz
    FIELD cod-refer     LIKE ficha-cq.cod-refer
    FIELD lote          LIKE ficha-cq.lote
    FIELD dep-entrada   LIKE saldo-estoq.cod-depos
    FIELD loc-entrada   LIKE saldo-estoq.cod-localiz
    FIELD dt-trans      LIKE movto-estoq.dt-trans
    FIELD nro-docto     LIKE movto-estoq.nro-docto   
    FIELD serie-docto   LIKE movto-estoq.serie-docto
    FIELD narrativa     LIKE ficha-cq.narrativa
    FIELD cod-emitente  LIKE ficha-cq.cod-emitente
    FIELD cod-rej       LIKE cod-rejeicao.codigo-rejei
    FIELD nat-operacao  LIKE ficha-cq.nat-operacao
    FIELD obs           LIKE ficha-cq.narrativa
    FIELD ct-codigo     AS CHAR
    FIELD sc-codigo     AS CHAR. 

DEF BUFFER b-tt-gera-transf FOR tt-gera-transf.

DEFINE BUFFER b-ficha-cq FOR ficha-cq.
DEFINE BUFFER b-res-fic-cq FOR res-fic-cq.

def var c-texto         as char    no-undo.
def var r-rej           as rowid   no-undo.
def var l-ok            as logical no-undo.

DEFINE VARIABLE d-dt-fabric  AS DATE      NO-UNDO.
DEFINE VARIABLE i-nr-ficha   AS INTEGER   NO-UNDO.
DEFINE VARIABLE l-todos      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE l-nr-ac-ex   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE l-rejeita    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE l-cliente    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE l-rej-desab  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE l-disab      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE c-op-des     AS CHARACTER NO-UNDO.
DEFINE VARIABLE de-inspecao  AS DATE      NO-UNDO.
DEFINE VARIABLE c-rejeitado  AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-codigo     AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-emite      AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-cancela    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE r-ficha-cq   AS ROWID     NO-UNDO.
DEFINE VARIABLE r-exam-ficha AS ROWID     NO-UNDO.
DEFINE VARIABLE c-dep-rej    AS CHARACTER NO-UNDO.
DEFINE VARIABLE viReturnCode AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-fileName   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp      AS HANDLE      NO-UNDO.

DEF VAR i-insp                      AS INTEGER            NO-UNDO.
DEF VAR i-var-aux                   AS INTEGER            NO-UNDO.
DEF VAR i-var-aux-tot               AS INTEGER            NO-UNDO.
DEF VAR l-retorno                   AS LOGICAL INITIAL NO NO-UNDO.
DEF VAR l-leitura-item-fornec-estab AS LOGICAL INIT NO    NO-UNDO.
DEF VAR l-integra-ems-his           AS LOG                NO-UNDO.
DEF VAR l-deleta-erros              AS LOGICAL            NO-UNDO.
DEF VAR l-erro                      AS LOGICAL            NO-UNDO.

def buffer b-responsavel for responsavel.
def buffer b-exam-ficha  for exam-ficha.
def var l-atualiza      as logical no-undo.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

def var c-mesg1         as char    no-undo.
def var c-mesg2         as char    no-undo.

DEFINE BUFFER b-saldo-estoq  FOR saldo-estoq.
DEFINE BUFFER b-saldo-origem  FOR saldo-estoq.
DEFINE BUFFER b-movto-lote    FOR movto-estoq.

DEF TEMP-TABLE tt-erro-verif LIKE tt-erro
    FIELD nr-ficha LIKE ficha-cq.nr-ficha.

def var c-lb-ficha      as char    no-undo.
def var c-lb-exame      as char    no-undo.

DEFINE VAR c-empresa       AS CHARACTER FORMAT "x(40)"                    NO-UNDO.
DEFINE VAR c-titulo-relat  AS CHARACTER FORMAT "x(50)"  INITIAL "Gera‡Æo de Retornos  - Relat¢rio de Erros" NO-UNDO.
DEFINE VAR c-sistema       AS CHARACTER FORMAT "x(25)"                    NO-UNDO.
DEFINE VAR i-numper-x      AS INTEGER   FORMAT "ZZ"                       NO-UNDO.
DEFINE VAR da-iniper-x     AS DATE      FORMAT "99/99/9999"               NO-UNDO.
DEFINE VAR da-fimper-x     AS DATE      FORMAT "99/99/9999"               NO-UNDO.
DEFINE VAR c-rodape        AS CHARACTER                                   NO-UNDO.
DEFINE VAR v_num_count     AS INTEGER                                     NO-UNDO.
DEFINE VAR c-arq-control   AS CHARACTER                                   NO-UNDO.
DEFINE VAR i-page-size-rel AS INTEGER                                     NO-UNDO.
DEFINE VAR c-programa      AS CHARACTER FORMAT "x(08)" INITIAL "ESCQ0210" NO-UNDO.
DEFINE VAR c-versao        AS CHARACTER FORMAT "x(04)" INITIAL "1.00"     NO-UNDO.
DEFINE VAR c-revisao       AS CHARACTER                INITIAL ".00.000"  NO-UNDO.
DEFINE VAR c-impressora    AS CHARACTER                                   NO-UNDO.
DEFINE VAR c-layout        AS CHARACTER                                   NO-UNDO.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-livre
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME br-table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ficha

/* Definitions for BROWSE br-table                                      */
&Scoped-define FIELDS-IN-QUERY-br-table tt-ficha.l-marcado tt-ficha.nr-ficha tt-ficha.it-codigo tt-ficha.desc-item tt-ficha.cod-emitente tt-ficha.cod-estabel tt-ficha.cod-depos tt-ficha.situacao tt-ficha.quantidade tt-ficha.cod-localiz tt-ficha.cod-refer tt-ficha.lote tt-ficha.dt-vali tt-ficha.cod-resp tt-ficha.dt-trans   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-table   
&Scoped-define SELF-NAME br-table
&Scoped-define QUERY-STRING-br-table FOR EACH tt-ficha
&Scoped-define OPEN-QUERY-br-table OPEN QUERY {&SELF-NAME} FOR EACH tt-ficha.
&Scoped-define TABLES-IN-QUERY-br-table tt-ficha
&Scoped-define FIRST-TABLE-IN-QUERY-br-table tt-ficha


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-br-table}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button rtToolBar RECT-15 RECT-18 ~
bt-cancela bt-confirma c-nro-docto c-serie-docto c-cod-emitente ~
c-nat-operacao br-table bt-marcar bt-desmarcar bt-todos bt-nenhum ~
bt-retorno btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS c-nro-docto c-serie-docto c-cod-emitente ~
c-nat-operacao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-livre AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU mi-programa 
       MENU-ITEM mi-consultas   LABEL "Co&nsultas"     ACCELERATOR "CTRL-L"
       MENU-ITEM mi-imprimir    LABEL "&Relat¢rios"    ACCELERATOR "CTRL-P"
       RULE
       MENU-ITEM mi-sair        LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU m_Ajuda 
       MENU-ITEM mi-conteudo    LABEL "&Conteudo"     
       MENU-ITEM mi-sobre       LABEL "&Sobre..."     .

DEFINE MENU m-livre MENUBAR
       SUB-MENU  mi-programa    LABEL "ESCQ0211"      
       SUB-MENU  m_Ajuda        LABEL "&Ajuda"        .


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_p-exihel AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-cancela 
     IMAGE-UP FILE "image\im-can":U
     IMAGE-INSENSITIVE FILE "image\ii-can":U
     LABEL "Cancel" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON bt-confirma 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON bt-desmarcar 
     LABEL "Desmarcar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-marcar 
     LABEL "Marcar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-nenhum 
     LABEL "Nenhum" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-retorno 
     LABEL "Retorno" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-todos 
     LABEL "Todos" 
     SIZE 10 BY 1.

DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-cod-emitente AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Emitente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-nat-operacao AS CHARACTER FORMAT "x(06)" 
     LABEL "Nat Opera‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-nro-docto AS CHARACTER FORMAT "x(16)" 
     LABEL "Documento" 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-serie-docto AS CHARACTER FORMAT "x(5)" 
     LABEL "S‚rie" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 131.57 BY 2.5.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 131.29 BY 16.58.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 132 BY 1.46
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 132 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-table FOR 
      tt-ficha SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-table w-livre _FREEFORM
  QUERY br-table DISPLAY
      tt-ficha.l-marcado    COLUMN-LABEL ""    FORM "*/" WIDTH 1
      tt-ficha.nr-ficha     COLUMN-LABEL "Roteiro"       WIDTH 10
      tt-ficha.it-codigo    COLUMN-LABEL "Item"          WIDTH 16
      tt-ficha.desc-item    COLUMN-LABEL "Desc Item"     WIDTH 20
      tt-ficha.cod-emitente COLUMN-LABEL "Emitente"      WIDTH 10
      tt-ficha.cod-estabel  COLUMN-LABEL "Estab"         WIDTH 6
      tt-ficha.cod-depos    COLUMN-LABEL "Dep¢sito"      WIDTH 8
      tt-ficha.situacao     COLUMN-LABEL "Situa‡Æo"      WIDTH 20
      tt-ficha.quantidade   COLUMN-LABEL "Quantidade CQ" WIDTH 15
      tt-ficha.cod-localiz  COLUMN-LABEL "Local"         WIDTH 12
      tt-ficha.cod-refer    COLUMN-LABEL "Referˆncia"    WIDTH 12
      tt-ficha.lote         COLUMN-LABEL "Lote"          WIDTH 20
      tt-ficha.dt-vali      COLUMN-LABEL "Validade Lote" WIDTH 12
      tt-ficha.cod-resp     COLUMN-LABEL "Respons vel"   WIDTH 12
      tt-ficha.dt-trans     COLUMN-LABEL "Data Roteiro"  WIDTH 12
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS NO-TAB-STOP SIZE 127.86 BY 14.04
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     bt-cancela AT ROW 3.25 COL 83 WIDGET-ID 40 NO-TAB-STOP 
     bt-confirma AT ROW 3.25 COL 87 WIDGET-ID 36 NO-TAB-STOP 
     c-nro-docto AT ROW 3.5 COL 11.86 COLON-ALIGNED WIDGET-ID 66
     c-serie-docto AT ROW 3.5 COL 30.86 COLON-ALIGNED WIDGET-ID 64
     c-cod-emitente AT ROW 3.5 COL 47 COLON-ALIGNED WIDGET-ID 88
     c-nat-operacao AT ROW 3.5 COL 71 COLON-ALIGNED WIDGET-ID 68
     br-table AT ROW 6.21 COL 3.14 WIDGET-ID 200
     bt-marcar AT ROW 20.5 COL 3 WIDGET-ID 92
     bt-desmarcar AT ROW 20.5 COL 13.57 WIDGET-ID 94
     bt-todos AT ROW 20.5 COL 24 WIDGET-ID 98
     bt-nenhum AT ROW 20.5 COL 34.57 WIDGET-ID 96
     bt-retorno AT ROW 22.67 COL 60 WIDGET-ID 90
     btOK AT ROW 24.38 COL 2 WIDGET-ID 6
     btCancel AT ROW 24.38 COL 13 WIDGET-ID 2
     btHelp2 AT ROW 24.38 COL 122.43 WIDGET-ID 4
     "Dados Nota Fiscal:" VIEW-AS TEXT
          SIZE 13.57 BY .54 AT ROW 2.5 COL 3.43 WIDGET-ID 86
     "Roteiros de Inspe‡Æo:" VIEW-AS TEXT
          SIZE 15.57 BY .54 AT ROW 5.42 COL 3.43 WIDGET-ID 80
     rt-button AT ROW 1 COL 1
     rtToolBar AT ROW 24.13 COL 1 WIDGET-ID 8
     RECT-15 AT ROW 2.75 COL 1.43 WIDGET-ID 82
     RECT-18 AT ROW 5.67 COL 1.57 WIDGET-ID 78
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 132.43 BY 24.67
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-livre
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-livre ASSIGN
         HIDDEN             = YES
         TITLE              = "ESCQ0211 - Libera‡Æo roteiro por NF"
         HEIGHT             = 24.67
         WIDTH              = 132.43
         MAX-HEIGHT         = 24.71
         MAX-WIDTH          = 132.43
         VIRTUAL-HEIGHT     = 24.71
         VIRTUAL-WIDTH      = 132.43
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU m-livre:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-livre 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-livre.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-livre
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME L-To-R                                                    */
/* BROWSE-TAB br-table c-nat-operacao f-cad */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
THEN w-livre:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-table
/* Query rebuild information for BROWSE br-table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ficha.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-table */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON END-ERROR OF w-livre /* ESCQ0211 - Libera‡Æo roteiro por NF */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON WINDOW-CLOSE OF w-livre /* ESCQ0211 - Libera‡Æo roteiro por NF */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-table
&Scoped-define SELF-NAME br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table w-livre
ON MOUSE-SELECT-DBLCLICK OF br-table IN FRAME f-cad
DO:
   FIND CURRENT tt-ficha NO-ERROR.
   IF AVAIL tt-ficha THEN DO:
      IF tt-ficha.l-marcado THEN
         APPLY "choose" TO bt-desmarcar.
      ELSE
         APPLY "choose" TO bt-marcar.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table w-livre
ON VALUE-CHANGED OF br-table IN FRAME f-cad
DO:
  FIND tt-ficha
      WHERE tt-ficha.nr-ficha = INPUT BROWSE br-table tt-ficha.nr-ficha NO-LOCK NO-ERROR.

  IF NOT AVAIL tt-ficha THEN DO:

      ASSIGN bt-retorno:SENSITIVE   = NO.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela w-livre
ON CHOOSE OF bt-cancela IN FRAME f-cad /* Cancel */
DO:
  RUN pi-limpa-tela.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-confirma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-confirma w-livre
ON CHOOSE OF bt-confirma IN FRAME f-cad /* Save */
DO:    
    RUN pi-executa.
    
    APPLY "entry" TO c-cod-emitente.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-desmarcar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-desmarcar w-livre
ON CHOOSE OF bt-desmarcar IN FRAME f-cad /* Desmarcar */
DO:
  FIND CURRENT tt-ficha NO-ERROR.
  IF AVAIL tt-ficha THEN DO:
     FIND FIRST ficha-cq NO-LOCK
          WHERE ficha-cq.nr-ficha = tt-ficha.nr-ficha NO-ERROR.
     IF ficha-cq.situacao = 1 OR 
        ficha-cq.situacao = 2 THEN
        ASSIGN tt-ficha.l-marcado = NO
               tt-ficha.l-marcado:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "".

  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-marcar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-marcar w-livre
ON CHOOSE OF bt-marcar IN FRAME f-cad /* Marcar */
DO:
  FIND CURRENT tt-ficha NO-ERROR.
  IF AVAIL tt-ficha THEN DO:
     FIND FIRST ficha-cq NO-LOCK
          WHERE ficha-cq.nr-ficha = tt-ficha.nr-ficha NO-ERROR.
     IF ficha-cq.situacao = 1 OR 
        ficha-cq.situacao = 2 THEN
        ASSIGN tt-ficha.l-marcado = YES
               tt-ficha.l-marcado:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "*".

  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-nenhum
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-nenhum w-livre
ON CHOOSE OF bt-nenhum IN FRAME f-cad /* Nenhum */
DO:
  FOR EACH tt-ficha:
      FIND FIRST ficha-cq NO-LOCK
           WHERE ficha-cq.nr-ficha = tt-ficha.nr-ficha NO-ERROR.
      IF ficha-cq.situacao = 1 OR 
         ficha-cq.situacao = 2 THEN
         ASSIGN tt-ficha.l-marcado = NO.
  END.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-retorno
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-retorno w-livre
ON CHOOSE OF bt-retorno IN FRAME f-cad /* Retorno */
DO:
  RUN pi-retorno.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-todos w-livre
ON CHOOSE OF bt-todos IN FRAME f-cad /* Todos */
DO:
  FOR EACH tt-ficha:
      FIND FIRST ficha-cq NO-LOCK
           WHERE ficha-cq.nr-ficha = tt-ficha.nr-ficha NO-ERROR.
      IF ficha-cq.situacao = 1 OR 
         ficha-cq.situacao = 2 THEN
         ASSIGN tt-ficha.l-marcado = YES.
  END.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-nro-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nro-docto w-livre
ON F5 OF c-nro-docto IN FRAME f-cad /* Documento */
DO:
  {include/zoomvar.i &prog-zoom="inzoom\esz01in124.w"
                       &campo=c-cod-emitente
                       &campozoom=cod-emitente
                       &campo2=c-serie-docto
                       &campozoom2=serie-docto
                       &campo3=c-nro-docto
                       &campozoom3=nro-docto
                       &campo4=c-nat-operacao
                       &campozoom4=nat-operacao
                       &FRAME=f-cad}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nro-docto w-livre
ON MOUSE-SELECT-DBLCLICK OF c-nro-docto IN FRAME f-cad /* Documento */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-consultas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-consultas w-livre
ON CHOOSE OF MENU-ITEM mi-consultas /* Consultas */
DO:
  RUN pi-consulta IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-conteudo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-conteudo w-livre
ON CHOOSE OF MENU-ITEM mi-conteudo /* Conteudo */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  RUN pi-ajuda IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-imprimir w-livre
ON CHOOSE OF MENU-ITEM mi-imprimir /* Relat¢rios */
DO:
  RUN pi-imprimir IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-programa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-programa w-livre
ON MENU-DROP OF MENU mi-programa /* ESCQ0211 */
DO:
  run pi-disable-menu.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sair w-livre
ON CHOOSE OF MENU-ITEM mi-sair /* Sair */
DO:
  RUN pi-sair IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-livre
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-livre 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-livre  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'panel/p-exihel.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-exihel ).
       RUN set-position IN h_p-exihel ( 1.13 , 116.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.25 , 16.00 ) */

       /* Links to SmartPanel h_p-exihel. */
       RUN add-link IN adm-broker-hdl ( h_p-exihel , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-livre  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-livre  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
  THEN DELETE WIDGET w-livre.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-livre  _DEFAULT-ENABLE
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
  DISPLAY c-nro-docto c-serie-docto c-cod-emitente c-nat-operacao 
      WITH FRAME f-cad IN WINDOW w-livre.
  ENABLE rt-button rtToolBar RECT-15 RECT-18 bt-cancela bt-confirma c-nro-docto 
         c-serie-docto c-cod-emitente c-nat-operacao br-table bt-marcar 
         bt-desmarcar bt-todos bt-nenhum bt-retorno btOK btCancel btHelp2 
      WITH FRAME f-cad IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW w-livre.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-livre 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-livre 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-livre 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  run pi-before-initialize.

  {include/win-size.i}

  {utp/ut9000.i "ESCQ0211" "1.00.00.001"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  IF c-nro-docto:LOAD-MOUSE-POINTER("image/lupa.cur") IN FRAME {&FRAME-NAME} THEN.

  /* Code placed here will execute AFTER standard behavior.    */

  run pi-after-initialize.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-aprov-cond w-livre 
PROCEDURE pi-aprov-cond :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-----------------------------------------------------------------------------*/
     EMPTY TEMP-TABLE tt-gera-transf.
     EMPTY TEMP-TABLE tt-movto.
     
     FIND FIRST ficha-cq NO-LOCK
          WHERE ROWID(ficha-cq) = r-ficha-cq NO-ERROR.
     
     IF AVAIL ficha-cq THEN DO:
     
        FOR EACH tt-ficha
           WHERE tt-ficha.l-marcado,
           FIRST b-ficha-cq NO-LOCK
           WHERE b-ficha-cq.nr-ficha = tt-ficha.nr-ficha:
           CREATE tt-gera-transf.
           ASSIGN tt-gera-transf.l-considera   = "*"
                  tt-gera-transf.cod-estabel   = b-ficha-cq.cod-estabel
                  tt-gera-transf.nr-ficha      = b-ficha-cq.nr-ficha
                  tt-gera-transf.it-codigo     = b-ficha-cq.it-codigo
                  tt-gera-transf.quantidade    = (b-ficha-cq.qt-original - b-ficha-cq.qt-consumida -
                                                  b-ficha-cq.qt-aprovada - b-ficha-cq.qt-rejeitada -
                                                  b-ficha-cq.qt-apr-cond)
                  tt-gera-transf.lote          = b-ficha-cq.lote
                  tt-gera-transf.dep-saida     = b-ficha-cq.cod-depos
                  tt-gera-transf.loc-saida     = b-ficha-cq.cod-localiz
                  tt-gera-transf.cod-refer     = b-ficha-cq.cod-refer
                  tt-gera-transf.dt-fabricacao = b-ficha-cq.dt-ficha
                  tt-gera-transf.nro-docto     = b-ficha-cq.nro-docto
                  tt-gera-transf.serie-docto   = b-ficha-cq.serie-docto
                  tt-gera-transf.narrativa     = b-ficha-cq.narrativa
                  tt-gera-transf.cod-emitente  = b-ficha-cq.cod-emitente
                  tt-gera-transf.dt-trans      = de-inspecao.
    
           FIND FIRST ITEM NO-LOCK
                WHERE ITEM.it-codigo = b-ficha-cq.it-codigo NO-ERROR.
    
                  IF AVAIL ITEM THEN DO:
    
                      ASSIGN tt-gera-transf.desc-item = ITEM.desc-item.
    
                  END.

           //Valida se Observacao na ficha de inspecao esta preenchida - M2008-082 - 08/03/21 - IAB 
           RUN pi-valida-obs-insp.

           IF RETURN-VALUE = "NOK" THEN
              DELETE tt-gera-transf.

        END.

         FIND FIRST tt-gera-transf NO-ERROR.

         IF NOT AVAIL tt-gera-transf THEN
            RETURN "NOK".

     
         RUN cqp/escq0210e-ac.w (INPUT-OUTPUT TABLE tt-gera-transf,
                                  OUTPUT l-ok).  
     
         IF l-ok = NO THEN DO:
     
              RETURN "NOK".
                      
         END.
     
         ELSE DO:
     
             RUN pi-inicializar in h-acomp ("Processando Retorno"). 
     
             EMPTY TEMP-TABLE tt-movto.
     
             FOR EACH tt-gera-transf NO-LOCK
                WHERE tt-gera-transf.l-considera = "*".
     
                   FIND FIRST ITEM NO-LOCK
                        WHERE ITEM.it-codigo = tt-gera-transf.it-codigo NO-ERROR.
                  
                   find estab-mat where
                        estab-mat.cod-estabel = tt-gera-transf.cod-estabel no-lock no-error.
     
                   FIND FIRST item-uni-estab NO-LOCK
                        WHERE item-uni-estab.it-codigo   = tt-gera-transf.it-codigo
                          AND item-uni-estab.cod-estabel = tt-gera-transf.cod-estabel NO-ERROR.
     
                   FIND FIRST int-familia NO-LOCK
                        WHERE int-familia.fm-codigo = ITEM.fm-codigo NO-ERROR.
     
                   IF AVAIL int-familia THEN DO: 
                       
                       ASSIGN d-dt-fabric = tt-gera-transf.dt-fabricacao    
                              tt-gera-transf.dt-fabricacao = tt-gera-transf.dt-fabricacao + (int-familia.meses-validade * 30).
     
                   END.
     
                   IF tt-gera-transf.dt-fabricacao < TODAY THEN DO:
     
                       RUN utp/ut-msgs.p (INPUT 'show',
                                          INPUT 17006,
                                          INPUT "Data de Fabrica‡Æo Inv lida!"
                                          + "~~" +
                                          "A data de fabrica‡Æo informada + os meses de validade da fam¡lia resultam numa data de validade inferior ao dia de hoje. Revise a data de fabrica‡Æo informada.").
     
                       RUN pi-finalizar IN h-acomp.
                         
                       RETURN "NOK".
     
                   END.

     
                   CREATE tt-movto.
     
                   assign tt-movto.ct-codigo = estab-mat.cod-cta-transf-unif
                          tt-movto.sc-codigo = estab-mat.cod-ccusto-transf-unif.  
     
                   assign tt-movto.cod-versao-integracao = 1 
                          tt-movto.dt-trans       = tt-gera-transf.dt-trans
                          tt-movto.nro-docto      = tt-gera-transf.nro-docto
                          tt-movto.serie-docto    = tt-gera-transf.serie-docto
                          tt-movto.cod-depos      = tt-gera-transf.dep-saida
                          tt-movto.cod-estabel    = tt-gera-transf.cod-estabel
                          tt-movto.it-codigo      = tt-gera-transf.it-codigo
                          tt-movto.cod-localiz    = tt-gera-transf.loc-saida
                          tt-movto.lote           = tt-gera-transf.lote
                          tt-movto.dt-vali-lote   = date(month(tt-gera-transf.dt-fabricacao), 1, year(tt-gera-transf.dt-fabricacao))
                          tt-movto.cod-refer      = tt-gera-transf.cod-refer
                          tt-movto.quantidade     = tt-gera-transf.quantidade
                          tt-movto.un             = ITEM.un
                          tt-movto.esp-docto      = 33
                          tt-movto.tipo-trans     = 2
                          tt-movto.descricao-db   = tt-gera-transf.narrativa
                          tt-movto.cod-prog-orig  = "v03in218"
                          tt-movto.cod-emitente   = tt-gera-transf.cod-emitente
                          tt-movto.usuario        = c-seg-usuario
                          tt-movto.cod-unid-negoc = item-uni-estab.cod-unid-negoc.
     
                   CREATE tt-movto.
     
                   assign tt-movto.ct-codigo = estab-mat.cod-cta-transf-unif
                          tt-movto.sc-codigo = estab-mat.cod-ccusto-transf-unif.  
     
                   assign tt-movto.cod-versao-integracao = 1 
                          tt-movto.dt-trans       = tt-gera-transf.dt-trans
                          tt-movto.nro-docto      = tt-gera-transf.nro-docto
                          tt-movto.serie-docto    = tt-gera-transf.serie-docto
                          tt-movto.cod-depos      = tt-gera-transf.dep-ent
                          tt-movto.cod-estabel    = tt-gera-transf.cod-estabel
                          tt-movto.it-codigo      = tt-gera-transf.it-codigo
                          tt-movto.cod-localiz    = tt-gera-transf.loc-ent
                          tt-movto.lote           = string(tt-gera-transf.cod-emitente) + "-" + substr(STRING(d-dt-fabric,"99/99/9999"),7,4) + substr(STRING(d-dt-fabric,"99/99/9999"),4,2)
                          tt-movto.dt-vali-lote   = date(month(tt-gera-transf.dt-fabricacao), 1, year(tt-gera-transf.dt-fabricacao))
                          tt-movto.cod-refer      = tt-gera-transf.cod-refer
                          tt-movto.quantidade     = tt-gera-transf.quantidade
                          tt-movto.un             = ITEM.un
                          tt-movto.esp-docto      = 33
                          tt-movto.tipo-trans     = 1
                          tt-movto.descricao-db   = tt-gera-transf.narrativa
                          tt-movto.cod-prog-orig  = "v03in218"
                          tt-movto.cod-emitente   = tt-gera-transf.cod-emitente
                          tt-movto.usuario        = c-seg-usuario
                          tt-movto.cod-unid-negoc = item-uni-estab.cod-unid-negoc.

                   ASSIGN tt-gera-transf.lote = tt-movto.lote.
     
             END.
     
             RUN pi-acompanhar IN h-acomp (INPUT "Gerando Transferˆncia").
     
             RUN cep/ceapi001k.p persistent set h-ceapi001k.
             
             RUN pi-execute IN h-ceapi001k (input-output table tt-movto,
                                            input-output table tt-erro, 
                                            INPUT l-deleta-erros).
     
             FIND FIRST tt-erro NO-LOCK no-error.
     
             IF RETURN-VALUE = "NOK":U OR AVAIL tt-erro THEN DO:
                  run cdp/cd0666.w (input table tt-erro).
                  l-erro = yes.  
     
                  RUN pi-finalizar IN h-acomp.
     
                  FOR EACH tt-erro.
                      DELETE tt-erro.
                  END.
     
                  RETURN "NOK".
     
             END.
     
             ELSE DO:
     
                 FOR EACH tt-gera-transf NO-LOCK
                    WHERE tt-gera-transf.l-considera = "*",
                     EACH ITEM NO-LOCK 
                    WHERE ITEM.it-codigo = tt-gera-transf.it-codigo
                     AND (ITEM.tipo-con-est = 3 OR ITEM.tipo-con-est = 4),
                     EACH saldo-estoq EXCLUSIVE-LOCK
                    WHERE saldo-estoq.it-codigo = tt-gera-transf.it-codigo
                      AND saldo-estoq.lote      = tt-gera-transf.lote:
     
                         ASSIGN saldo-estoq.dt-vali-lote = date(month(tt-gera-transf.dt-fabricacao), 1, year(tt-gera-transf.dt-fabricacao)).
     
                 END.
     
                  /* WMS X CQ */
                 RUN wmp/eswm9035.p (INPUT-OUTPUT table tt-gera-transf,
                                     INPUT-OUTPUT table tt-erro).
     
                 FIND FIRST tt-erro NO-LOCK no-error.
     
                 IF RETURN-VALUE = "NOK":U OR AVAIL tt-erro THEN DO:
     
                       run cdp/cd0666.w (input table tt-erro).
     
                       l-erro = yes.  
      
                       RUN pi-finalizar IN h-acomp.
      
                       FOR EACH tt-erro.
                           DELETE tt-erro.
                       END.
      
                       RETURN "NOK".
      
                 END.
     
             END.
     
             RUN pi-finalizar IN h-acomp.
             
             FOR EACH tt-gera-transf NO-LOCK
                WHERE tt-gera-transf.l-considera = "*".
     
                 FIND FIRST ficha-cq 
                      WHERE ficha-cq.nr-ficha = tt-gera-transf.nr-ficha NO-ERROR.
     
                 IF AVAIL ficha-cq THEN DO: 
                     
                     ASSIGN ficha-cq.qt-apr-cond      = ficha-cq.qt-apr-cond + tt-gera-transf.quantidade
                            ficha-cq.inspecionado     = YES
                            ficha-cq.situacao         = 4
                            ficha-cq.dt-ult-sit       = TODAY
                            ficha-cq.liberada         = YES
                            ficha-cq.cod-resp         = c-seg-usuario
                            ficha-cq.narrativa        = c-texto.
     
                     IF ficha-cq.dt-inspecao = ? THEN ASSIGN ficha-cq.dt-inspecao = tt-gera-transf.dt-trans.
     
                     /* ATUALIZA€ÇO DA INSPE€ÇO DO FORNECEDOR */
                     {cdp/cd9320.i}
     
                     RELEASE item-fornec.
                     RELEASE item-fornec-estab.
     
                 END.
     
             END.
     
         END.
     
     END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-aprova w-livre 
PROCEDURE pi-aprova :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-----------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-gera-transf.
    EMPTY TEMP-TABLE tt-movto.

    FIND FIRST ficha-cq NO-LOCK
         WHERE ROWID(ficha-cq) = r-ficha-cq NO-ERROR.
    
    IF AVAIL ficha-cq THEN DO:
        FOR EACH tt-ficha
           WHERE tt-ficha.l-marcado,
           FIRST b-ficha-cq NO-LOCK
           WHERE b-ficha-cq.nr-ficha = tt-ficha.nr-ficha:
           CREATE tt-gera-transf.
           ASSIGN tt-gera-transf.l-considera   = "*"
                  tt-gera-transf.cod-estabel   = b-ficha-cq.cod-estabel
                  tt-gera-transf.nr-ficha      = b-ficha-cq.nr-ficha
                  tt-gera-transf.it-codigo     = b-ficha-cq.it-codigo
                  tt-gera-transf.quantidade    = (b-ficha-cq.qt-original - b-ficha-cq.qt-consumida -
                                                  b-ficha-cq.qt-aprovada - b-ficha-cq.qt-rejeitada -
                                                  b-ficha-cq.qt-apr-cond)
                  tt-gera-transf.lote          = b-ficha-cq.lote
                  tt-gera-transf.dep-saida     = b-ficha-cq.cod-depos
                  tt-gera-transf.loc-saida     = b-ficha-cq.cod-localiz
                  tt-gera-transf.cod-refer     = b-ficha-cq.cod-refer
                  tt-gera-transf.dt-fabricacao = b-ficha-cq.dt-ficha
                  tt-gera-transf.nro-docto     = b-ficha-cq.nro-docto
                  tt-gera-transf.serie-docto   = b-ficha-cq.serie-docto
                  tt-gera-transf.narrativa     = b-ficha-cq.narrativa
                  tt-gera-transf.cod-emitente  = b-ficha-cq.cod-emitente
                  tt-gera-transf.dt-trans      = de-inspecao.
    
           FIND FIRST ITEM NO-LOCK
                WHERE ITEM.it-codigo = b-ficha-cq.it-codigo NO-ERROR.
    
                  IF AVAIL ITEM THEN DO:
    
                      ASSIGN tt-gera-transf.desc-item = ITEM.desc-item.
    
                  END.

           //Valida se Observacao na ficha de inspecao esta preenchida - M2008-082 - 08/03/21 - IAB 
           RUN pi-valida-obs-insp.

           IF RETURN-VALUE = "NOK" THEN
              DELETE tt-gera-transf.

        END.

        FIND FIRST tt-gera-transf NO-ERROR.

        IF NOT AVAIL tt-gera-transf THEN
           RETURN "NOK".

    
        RUN cqp/escq0210e-ap.w (INPUT-OUTPUT TABLE tt-gera-transf,
                                OUTPUT l-ok).  
    
        IF l-ok = NO THEN DO:
    
             RETURN "NOK".
                     
        END.
    
        ELSE DO:
    
            RUN pi-inicializar in h-acomp ("Processando Retorno"). 
    
            EMPTY TEMP-TABLE tt-movto.
    
            FOR EACH tt-gera-transf NO-LOCK
               WHERE tt-gera-transf.l-considera = "*".
    
                  FIND FIRST ITEM NO-LOCK
                       WHERE ITEM.it-codigo = tt-gera-transf.it-codigo NO-ERROR.
                 
                  find estab-mat where
                       estab-mat.cod-estabel = tt-gera-transf.cod-estabel no-lock no-error.
    
                  FIND FIRST item-uni-estab NO-LOCK
                       WHERE item-uni-estab.it-codigo   = tt-gera-transf.it-codigo
                         AND item-uni-estab.cod-estabel = tt-gera-transf.cod-estabel NO-ERROR.
    
                  FIND FIRST int-familia NO-LOCK
                       WHERE int-familia.fm-codigo = ITEM.fm-codigo NO-ERROR.
    
                  IF AVAIL int-familia THEN DO: 
                      
                      ASSIGN d-dt-fabric = tt-gera-transf.dt-fabricacao          
                             tt-gera-transf.dt-fabricacao = tt-gera-transf.dt-fabricacao + (int-familia.meses-validade * 30).
    
                  END.
    
                  IF tt-gera-transf.dt-fabricacao < TODAY THEN DO:
    
                      RUN utp/ut-msgs.p (INPUT 'show',
                                         INPUT 17006,
                                         INPUT "Data de Fabrica‡Æo Inv lida!"
                                         + "~~" +
                                         "A data de fabrica‡Æo informada + os meses de validade da fam¡lia resultam numa data de validade inferior ao dia de hoje. Revise a data de fabrica‡Æo informada.").
    
                      RUN pi-finalizar IN h-acomp.
                        
                      RETURN "NOK".
    
                  END.
 

    
                  CREATE tt-movto.
    
                  assign tt-movto.ct-codigo = estab-mat.cod-cta-transf-unif
                         tt-movto.sc-codigo = estab-mat.cod-ccusto-transf-unif.  
    
                  assign tt-movto.cod-versao-integracao = 1 
                         tt-movto.dt-trans       = tt-gera-transf.dt-trans
                         tt-movto.nro-docto      = tt-gera-transf.nro-docto
                         tt-movto.serie-docto    = tt-gera-transf.serie-docto
                         tt-movto.cod-depos      = tt-gera-transf.dep-saida
                         tt-movto.cod-estabel    = tt-gera-transf.cod-estabel
                         tt-movto.it-codigo      = tt-gera-transf.it-codigo
                         tt-movto.cod-localiz    = tt-gera-transf.loc-saida
                         tt-movto.lote           = tt-gera-transf.lote
                         tt-movto.dt-vali-lote   = date(month(tt-gera-transf.dt-fabricacao), 1, year(tt-gera-transf.dt-fabricacao))
                         tt-movto.cod-refer      = tt-gera-transf.cod-refer
                         tt-movto.quantidade     = tt-gera-transf.quantidade
                         tt-movto.un             = ITEM.un
                         tt-movto.esp-docto      = 33
                         tt-movto.tipo-trans     = 2
                         tt-movto.descricao-db   = tt-gera-transf.narrativa
                         tt-movto.cod-prog-orig  = "v03in218"
                         tt-movto.cod-emitente   = tt-gera-transf.cod-emitente
                         tt-movto.usuario        = c-seg-usuario
                         tt-movto.cod-unid-negoc = item-uni-estab.cod-unid-negoc.
    
                  CREATE tt-movto.
    
                  assign tt-movto.ct-codigo = estab-mat.cod-cta-transf-unif
                         tt-movto.sc-codigo = estab-mat.cod-ccusto-transf-unif.  
    
                  assign tt-movto.cod-versao-integracao = 1 
                         tt-movto.dt-trans       = tt-gera-transf.dt-trans
                         tt-movto.nro-docto      = tt-gera-transf.nro-docto
                         tt-movto.serie-docto    = tt-gera-transf.serie-docto
                         tt-movto.cod-depos      = tt-gera-transf.dep-ent
                         tt-movto.cod-estabel    = tt-gera-transf.cod-estabel
                         tt-movto.it-codigo      = tt-gera-transf.it-codigo
                         tt-movto.cod-localiz    = tt-gera-transf.loc-ent
                         tt-movto.lote           = string(tt-gera-transf.cod-emitente) + "-" + substr(STRING(d-dt-fabric,"99/99/9999"),7,4) + substr(STRING(d-dt-fabric,"99/99/9999"),4,2)
                         tt-movto.dt-vali-lote   = date(month(tt-gera-transf.dt-fabricacao), 1, year(tt-gera-transf.dt-fabricacao))
                         tt-movto.cod-refer      = tt-gera-transf.cod-refer
                         tt-movto.quantidade     = tt-gera-transf.quantidade
                         tt-movto.un             = ITEM.un
                         tt-movto.esp-docto      = 33
                         tt-movto.tipo-trans     = 1
                         tt-movto.descricao-db   = tt-gera-transf.narrativa
                         tt-movto.cod-prog-orig  = "v03in218"
                         tt-movto.cod-emitente   = tt-gera-transf.cod-emitente
                         tt-movto.usuario        = c-seg-usuario
                         tt-movto.cod-unid-negoc = item-uni-estab.cod-unid-negoc.

                  ASSIGN tt-gera-transf.lote = tt-movto.lote.
    
            END.
    
            RUN pi-acompanhar IN h-acomp (INPUT "Gerando Transferˆncia").
    
            RUN cep/ceapi001k.p persistent set h-ceapi001k.
            
            RUN pi-execute IN h-ceapi001k (input-output table tt-movto,
                                           input-output table tt-erro, 
                                           INPUT l-deleta-erros).
    
            FIND FIRST tt-erro NO-LOCK no-error.
    
            IF RETURN-VALUE = "NOK":U OR AVAIL tt-erro THEN DO:
                 run cdp/cd0666.w (input table tt-erro).
                 l-erro = yes.  
    
                 RUN pi-finalizar IN h-acomp.
    
                 FOR EACH tt-erro.
                     DELETE tt-erro.
                 END.
    
                 RETURN "NOK".
            END.
    
            ELSE DO:
    
                FOR EACH tt-gera-transf NO-LOCK
                   WHERE tt-gera-transf.l-considera = "*",
                    EACH ITEM NO-LOCK 
                   WHERE ITEM.it-codigo = tt-gera-transf.it-codigo
                    AND (ITEM.tipo-con-est = 3 OR ITEM.tipo-con-est = 4),
                    EACH saldo-estoq EXCLUSIVE-LOCK
                   WHERE saldo-estoq.it-codigo = tt-gera-transf.it-codigo
                     AND saldo-estoq.lote      = tt-gera-transf.lote:
    
                        ASSIGN saldo-estoq.dt-vali-lote = date(month(tt-gera-transf.dt-fabricacao), 1, year(tt-gera-transf.dt-fabricacao)).
    
                END.
    
                /* WMS X CQ */
                RUN wmp/eswm9035.p (INPUT-OUTPUT table tt-gera-transf,
                                    INPUT-OUTPUT table tt-erro).
    
                FIND FIRST tt-erro NO-LOCK no-error.
    
                IF RETURN-VALUE = "NOK":U OR AVAIL tt-erro THEN DO:
    
                      run cdp/cd0666.w (input table tt-erro).
    
                      l-erro = yes.  
     
                      RUN pi-finalizar IN h-acomp.
     
                      FOR EACH tt-erro.
                          DELETE tt-erro.
                      END.
     
                      RETURN "NOK".
     
                END.
    
            END.
    
            RUN pi-finalizar IN h-acomp.
            
            FOR EACH tt-gera-transf NO-LOCK
               WHERE tt-gera-transf.l-considera = "*".
    
                FIND FIRST ficha-cq 
                     WHERE ficha-cq.nr-ficha = tt-gera-transf.nr-ficha NO-ERROR.
    
                IF AVAIL ficha-cq THEN DO: 
                    
                    ASSIGN ficha-cq.qt-aprovada  = ficha-cq.qt-aprovada + tt-gera-transf.quantidade
                           ficha-cq.inspecionado = YES
                           ficha-cq.situacao     = 4
                           ficha-cq.dt-ult-sit   = TODAY
                           ficha-cq.liberada     = YES
                           ficha-cq.cod-resp     = c-seg-usuario
                           ficha-cq.narrativa    = c-texto.
    
                    IF ficha-cq.dt-inspecao = ? THEN ASSIGN ficha-cq.dt-inspecao = tt-gera-transf.dt-trans.
    
                    /* ATUALIZA€ÇO DA INSPE€ÇO DO FORNECEDOR */
                    {cdp/cd9320.i}
    
                    RELEASE item-fornec.
                    RELEASE item-fornec-estab.
    
                END.
    
            END.
    
        END.
    
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executa w-livre 
PROCEDURE pi-executa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-ficha.

    FOR EACH ficha-cq NO-LOCK
       WHERE ficha-cq.cod-emitente   = INT(INPUT FRAME {&frame-name} c-cod-emitente)
         AND ficha-cq.serie-docto    = INPUT FRAME {&frame-name} c-serie-docto
         AND ficha-cq.nro-docto      = INPUT FRAME {&frame-name} c-nro-docto
         AND ficha-cq.nat-operacao   = INPUT FRAME {&frame-name} c-nat-operacao
         AND ficha-cq.origem         = 2
         AND ficha-cq.nat-operacao <> ""
         AND ficha-cq.cod-emitente <> 0
         AND (ficha-cq.situacao     =  1 OR 
              ficha-cq.situacao     =  2),
        FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = ficha-cq.it-codigo:

        FIND FIRST tt-ficha NO-LOCK
             WHERE tt-ficha.cod-emitente = ficha-cq.cod-emitente
               AND tt-ficha.serie-docto  = ficha-cq.serie-docto
               AND tt-ficha.nro-docto    = ficha-cq.nro-docto
               AND tt-ficha.nat-operacao = ficha-cq.nat-operacao
               AND tt-ficha.nr-ficha     = ficha-cq.nr-ficha
               AND tt-ficha.lote         = ficha-cq.lote NO-ERROR.
    
        IF NOT AVAIL tt-ficha THEN DO:
          CREATE tt-ficha.          
          ASSIGN tt-ficha.nr-ficha        = ficha-cq.nr-ficha
                 tt-ficha.it-codigo       = ficha-cq.it-codigo
                 tt-ficha.cod-emitente    = ficha-cq.cod-emitente
                 tt-ficha.cod-estabel     = ficha-cq.cod-estabel
                 tt-ficha.cod-depos       = ficha-cq.cod-depos
                 tt-ficha.quantidade      = (ficha-cq.qt-original - ficha-cq.qt-consumida -
                                             ficha-cq.qt-aprovada - ficha-cq.qt-rejeitada -
                                             ficha-cq.qt-apr-cond)
                 tt-ficha.cod-localiz     = ficha-cq.cod-localiz
                 tt-ficha.cod-refer       = ficha-cq.cod-refer
                 tt-ficha.lote            = ficha-cq.lote
                 tt-ficha.cod-resp        = ficha-cq.cod-resp
                 tt-ficha.dt-trans        = ficha-cq.dt-ficha
                 tt-ficha.serie-docto     = ficha-cq.serie-docto
                 tt-ficha.nro-docto       = ficha-cq.nro-docto
                 tt-ficha.nat-operacao    = ficha-cq.nat-operacao
                 tt-ficha.origem          = ficha-cq.origem
                 tt-ficha.baixa-estoq     = ficha-cq.baixa-estoq. 

          CASE ficha-cq.situacao:

              WHEN 1 THEN ASSIGN tt-ficha.situacao = "Pendente".
              WHEN 2 THEN ASSIGN tt-ficha.situacao = "Em An lise".
              WHEN 3 THEN ASSIGN tt-ficha.situacao = "Pendente de Retorno".
              WHEN 4 THEN ASSIGN tt-ficha.situacao = "Terminado".
              WHEN 5 THEN ASSIGN tt-ficha.situacao = "Cancelado".
              WHEN 6 THEN ASSIGN tt-ficha.situacao = "Pendente NF".

          END CASE.
    
        END.

        ASSIGN tt-ficha.desc-item = ITEM.desc-item.  

        IF ITEM.tipo-con-est = 2 OR ITEM.tipo-con-est = 3 THEN DO: 

            FIND FIRST saldo-estoq NO-LOCK    
                 WHERE saldo-estoq.it-codigo   = tt-ficha.it-codigo
                   AND saldo-estoq.cod-estabel = tt-ficha.cod-estabel
                   AND saldo-estoq.cod-depos   = tt-ficha.cod-depos
                   AND saldo-estoq.cod-localiz = tt-ficha.cod-localiz
                   AND saldo-estoq.lote        = tt-ficha.lote
                   AND saldo-estoq.cod-refer   = tt-ficha.cod-refer NO-ERROR.
    
            IF AVAIL saldo-estoq THEN ASSIGN tt-ficha.dt-vali = saldo-estoq.dt-vali-lote.

        END.
    END.
             
    {&open-query-br-table}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-limpa-tela w-livre 
PROCEDURE pi-limpa-tela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 ASSIGN c-cod-emitente:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
        c-serie-docto:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = ""
        c-nro-docto:SCREEN-VALUE IN FRAME {&FRAME-NAME}    = ""
        c-nat-operacao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

EMPTY TEMP-TABLE tt-ficha.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-perda w-livre 
PROCEDURE pi-perda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-----------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-gera-transf.
    EMPTY TEMP-TABLE tt-movto.

    FIND FIRST ficha-cq NO-LOCK
         WHERE ROWID(ficha-cq) = r-ficha-cq NO-ERROR.

    IF AVAIL ficha-cq THEN DO:

        FOR EACH tt-ficha
           WHERE tt-ficha.l-marcado,
           FIRST b-ficha-cq NO-LOCK
           WHERE b-ficha-cq.nr-ficha = tt-ficha.nr-ficha:
           CREATE tt-gera-transf.
           ASSIGN tt-gera-transf.l-considera   = "*"
                  tt-gera-transf.cod-estabel   = b-ficha-cq.cod-estabel
                  tt-gera-transf.nr-ficha      = b-ficha-cq.nr-ficha
                  tt-gera-transf.it-codigo     = b-ficha-cq.it-codigo
                  tt-gera-transf.quantidade    = (b-ficha-cq.qt-original - b-ficha-cq.qt-consumida -
                                                  b-ficha-cq.qt-aprovada - b-ficha-cq.qt-rejeitada -
                                                  b-ficha-cq.qt-apr-cond)
                  tt-gera-transf.lote          = b-ficha-cq.lote
                  tt-gera-transf.dep-saida     = b-ficha-cq.cod-depos
                  tt-gera-transf.loc-saida     = b-ficha-cq.cod-localiz
                  tt-gera-transf.cod-refer     = b-ficha-cq.cod-refer
                  tt-gera-transf.dt-fabricacao = b-ficha-cq.dt-ficha
                  tt-gera-transf.nro-docto     = b-ficha-cq.nro-docto
                  tt-gera-transf.serie-docto   = b-ficha-cq.serie-docto
                  tt-gera-transf.narrativa     = b-ficha-cq.narrativa
                  tt-gera-transf.cod-emitente  = b-ficha-cq.cod-emitente
                  tt-gera-transf.dt-trans      = de-inspecao.
    
           FIND FIRST ITEM NO-LOCK
                WHERE ITEM.it-codigo = b-ficha-cq.it-codigo NO-ERROR.
    
                  IF AVAIL ITEM THEN DO:
    
                      ASSIGN tt-gera-transf.desc-item = ITEM.desc-item.
    
                  END.

           //Valida se Observacao na ficha de inspecao esta preenchida - M2008-082 - 08/03/21 - IAB 
           RUN pi-valida-obs-insp.

           IF RETURN-VALUE = "NOK" THEN
              DELETE tt-gera-transf.

        END.


        FIND FIRST tt-gera-transf NO-ERROR.

        IF NOT AVAIL tt-gera-transf THEN
           RETURN "NOK".


        RUN cqp/escq0210e-pe.w (INPUT-OUTPUT TABLE tt-gera-transf,
                                OUTPUT l-ok).  

        IF l-ok = NO THEN DO:

             RETURN "NOK".
                     
        END.

        ELSE DO:

            RUN pi-inicializar in h-acomp ("Processando Retorno"). 

            EMPTY TEMP-TABLE tt-movto.

            FOR EACH tt-gera-transf NO-LOCK
               WHERE tt-gera-transf.l-considera = "*".

                  CREATE tt-movto.

                  FIND FIRST ITEM NO-LOCK
                       WHERE ITEM.it-codigo = tt-gera-transf.it-codigo NO-ERROR.

                  FIND FIRST item-uni-estab NO-LOCK
                       WHERE item-uni-estab.it-codigo   = tt-gera-transf.it-codigo
                         AND item-uni-estab.cod-estabel = tt-gera-transf.cod-estabel NO-ERROR.

                  assign tt-movto.cod-versao-integracao = 1 
                         tt-movto.ct-codigo      = tt-gera-transf.ct-codigo
                         tt-movto.sc-codigo      = tt-gera-transf.sc-codigo
                         tt-movto.dt-trans       = tt-gera-transf.dt-trans
                         tt-movto.nro-docto      = tt-gera-transf.nro-docto
                         tt-movto.serie-docto    = tt-gera-transf.serie-docto
                         tt-movto.cod-depos      = tt-gera-transf.dep-saida
                         tt-movto.cod-estabel    = tt-gera-transf.cod-estabel
                         tt-movto.it-codigo      = tt-gera-transf.it-codigo
                         tt-movto.cod-localiz    = tt-gera-transf.loc-saida
                         tt-movto.lote           = tt-gera-transf.lote
                         tt-movto.dt-vali-lote   = tt-gera-transf.dt-fabricacao
                         tt-movto.cod-refer      = tt-gera-transf.cod-refer
                         tt-movto.quantidade     = tt-gera-transf.quantidade
                         tt-movto.un             = ITEM.un
                         tt-movto.esp-docto      = 28
                         tt-movto.tipo-trans     = 2
                         tt-movto.descricao-db   = tt-gera-transf.narrativa
                         tt-movto.cod-prog-orig  = "v04in218"
                         tt-movto.cod-emitente   = tt-gera-transf.cod-emitente
                         tt-movto.usuario        = c-seg-usuario
                         tt-movto.cod-unid-negoc = item-uni-estab.cod-unid-negoc.

            END.

            RUN pi-acompanhar IN h-acomp (INPUT "Gerando Baixa").

            RUN cep/ceapi001k.p persistent set h-ceapi001k.
            
            RUN pi-execute IN h-ceapi001k (input-output table tt-movto,
                                           input-output table tt-erro, 
                                           INPUT l-deleta-erros).

            FIND FIRST tt-erro NO-LOCK no-error.

            IF RETURN-VALUE = "NOK":U OR AVAIL tt-erro THEN DO:
                 run cdp/cd0666.w (input table tt-erro).
                 l-erro = yes.  

                 RUN pi-finalizar IN h-acomp.

                 FOR EACH tt-erro.
                     DELETE tt-erro.
                 END.

                 RETURN "NOK".

            END.

            ELSE DO:

                RUN pi-finalizar IN h-acomp.

                FOR EACH tt-gera-transf NO-LOCK
                   WHERE tt-gera-transf.l-considera = "*".

                    FIND FIRST ficha-cq 
                         WHERE ficha-cq.nr-ficha = tt-gera-transf.nr-ficha NO-ERROR.

                    IF AVAIL ficha-cq THEN DO: 
                        
                        ASSIGN ficha-cq.qt-consumida = ficha-cq.qt-consumida + tt-gera-transf.quantidade
                               ficha-cq.inspecionado = YES
                               ficha-cq.situacao     = 4
                               ficha-cq.dt-ult-sit   = TODAY
                               ficha-cq.liberada     = YES
                               ficha-cq.cod-resp     = c-seg-usuario
                               ficha-cq.narrativa    = c-texto.

                        IF ficha-cq.dt-inspecao = ? THEN ASSIGN ficha-cq.dt-inspecao = tt-gera-transf.dt-trans.

                        /* ATUALIZA€ÇO DA INSPE€ÇO DO FORNECEDOR */
                        {cdp/cd9320.i}

                        RELEASE item-fornec.
                        RELEASE item-fornec-estab.

                    END.

                END.

            END.

        END.

    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-rejeita w-livre 
PROCEDURE pi-rejeita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-----------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-gera-transf.
    EMPTY TEMP-TABLE tt-movto.

    FIND FIRST ficha-cq NO-LOCK
         WHERE ROWID(ficha-cq) = r-ficha-cq NO-ERROR.

    IF AVAIL ficha-cq THEN DO:

        FOR EACH tt-ficha
           WHERE tt-ficha.l-marcado,
           FIRST b-ficha-cq NO-LOCK
           WHERE b-ficha-cq.nr-ficha = tt-ficha.nr-ficha:
           CREATE tt-gera-transf.
           ASSIGN tt-gera-transf.l-considera   = "*"
                  tt-gera-transf.cod-estabel   = b-ficha-cq.cod-estabel
                  tt-gera-transf.nr-ficha      = b-ficha-cq.nr-ficha
                  tt-gera-transf.it-codigo     = b-ficha-cq.it-codigo
                  tt-gera-transf.quantidade    = (b-ficha-cq.qt-original - b-ficha-cq.qt-consumida -
                                                  b-ficha-cq.qt-aprovada - b-ficha-cq.qt-rejeitada -
                                                  b-ficha-cq.qt-apr-cond)
                  tt-gera-transf.lote          = b-ficha-cq.lote
                  tt-gera-transf.dep-saida     = b-ficha-cq.cod-depos
                  tt-gera-transf.loc-saida     = b-ficha-cq.cod-localiz
                  tt-gera-transf.cod-refer     = b-ficha-cq.cod-refer
                  tt-gera-transf.dt-fabricacao = b-ficha-cq.dt-ficha
                  tt-gera-transf.nro-docto     = b-ficha-cq.nro-docto
                  tt-gera-transf.serie-docto   = b-ficha-cq.serie-docto
                  tt-gera-transf.narrativa     = b-ficha-cq.narrativa
                  tt-gera-transf.cod-emitente  = b-ficha-cq.cod-emitente
                  tt-gera-transf.dt-trans      = de-inspecao.
    
           FIND FIRST ITEM NO-LOCK
                WHERE ITEM.it-codigo = b-ficha-cq.it-codigo NO-ERROR.
    
                  IF AVAIL ITEM THEN DO:
    
                      ASSIGN tt-gera-transf.desc-item = ITEM.desc-item.
    
                  END.

           //Valida se Observacao na ficha de inspecao esta preenchida - M2008-082 - 08/03/21 - IAB 
           RUN pi-valida-obs-insp.
          
           IF RETURN-VALUE = "NOK" THEN
              DELETE tt-gera-transf.

        END.


        FIND FIRST tt-gera-transf NO-ERROR.

        IF NOT AVAIL tt-gera-transf THEN
           RETURN "NOK".


        RUN cqp/escq0210e-re.w (INPUT-OUTPUT TABLE tt-gera-transf,
                                OUTPUT l-ok).  

        IF l-ok = NO THEN DO:

             RETURN "NOK".
                     
        END.

        ELSE DO:

            RUN pi-inicializar in h-acomp ("Processando Retorno"). 

            EMPTY TEMP-TABLE tt-movto.

            FOR EACH tt-gera-transf NO-LOCK
               WHERE tt-gera-transf.l-considera = "*".

                  FIND FIRST ITEM NO-LOCK
                       WHERE ITEM.it-codigo = tt-gera-transf.it-codigo NO-ERROR.
                 
                  find estab-mat where
                       estab-mat.cod-estabel = tt-gera-transf.cod-estabel no-lock no-error.

                  FIND FIRST item-uni-estab NO-LOCK
                       WHERE item-uni-estab.it-codigo   = tt-gera-transf.it-codigo
                         AND item-uni-estab.cod-estabel = tt-gera-transf.cod-estabel NO-ERROR.

                  FIND FIRST int-familia NO-LOCK
                       WHERE int-familia.fm-codigo = ITEM.fm-codigo NO-ERROR.

                  IF AVAIL int-familia THEN DO: 
                      
                      ASSIGN d-dt-fabric = tt-gera-transf.dt-fabricacao
                             tt-gera-transf.dt-fabricacao = tt-gera-transf.dt-fabricacao + (int-familia.meses-validade * 30).

                  END.

                  IF tt-gera-transf.dt-fabricacao < TODAY THEN DO:

                      RUN utp/ut-msgs.p (INPUT 'show',
                                         INPUT 17006,
                                         INPUT "Data de Fabrica‡Æo Inv lida!"
                                         + "~~" +
                                         "A data de fabrica‡Æo informada + os meses de validade da fam¡lia resultam numa data de validade inferior ao dia de hoje. Revise a data de fabrica‡Æo informada.").

                      RUN pi-finalizar IN h-acomp.
                        
                      RETURN "NOK".

                  END.



                  CREATE tt-movto.

                  assign tt-movto.ct-codigo = estab-mat.cod-cta-transf-unif
                         tt-movto.sc-codigo = estab-mat.cod-ccusto-transf-unif.  

                  assign tt-movto.cod-versao-integracao = 1 
                         tt-movto.dt-trans       = tt-gera-transf.dt-trans
                         tt-movto.nro-docto      = tt-gera-transf.nro-docto
                         tt-movto.serie-docto    = tt-gera-transf.serie-docto
                         tt-movto.cod-depos      = tt-gera-transf.dep-saida
                         tt-movto.cod-estabel    = tt-gera-transf.cod-estabel
                         tt-movto.it-codigo      = tt-gera-transf.it-codigo
                         tt-movto.cod-localiz    = tt-gera-transf.loc-saida
                         tt-movto.lote           = tt-gera-transf.lote
                         tt-movto.dt-vali-lote   = date(month(tt-gera-transf.dt-fabricacao), 1, year(tt-gera-transf.dt-fabricacao))
                         tt-movto.cod-refer      = tt-gera-transf.cod-refer
                         tt-movto.quantidade     = tt-gera-transf.quantidade
                         tt-movto.un             = ITEM.un
                         tt-movto.esp-docto      = 33
                         tt-movto.tipo-trans     = 2
                         tt-movto.descricao-db   = tt-gera-transf.narrativa
                         tt-movto.cod-prog-orig  = "v03in218"
                         tt-movto.cod-emitente   = tt-gera-transf.cod-emitente
                         tt-movto.usuario        = c-seg-usuario
                         tt-movto.cod-unid-negoc = item-uni-estab.cod-unid-negoc.

                  CREATE tt-movto.

                  assign tt-movto.ct-codigo = estab-mat.cod-cta-transf-unif
                         tt-movto.sc-codigo = estab-mat.cod-ccusto-transf-unif.  

                  assign tt-movto.cod-versao-integracao = 1 
                         tt-movto.dt-trans       = tt-gera-transf.dt-trans
                         tt-movto.nro-docto      = tt-gera-transf.nro-docto
                         tt-movto.serie-docto    = tt-gera-transf.serie-docto
                         tt-movto.cod-depos      = tt-gera-transf.dep-ent
                         tt-movto.cod-estabel    = tt-gera-transf.cod-estabel
                         tt-movto.it-codigo      = tt-gera-transf.it-codigo
                         tt-movto.cod-localiz    = tt-gera-transf.loc-ent
                         tt-movto.lote           = string(tt-gera-transf.cod-emitente) + "-" + substr(STRING(d-dt-fabric,"99/99/9999"),7,4) + substr(STRING(d-dt-fabric,"99/99/9999"),4,2)
                         tt-movto.dt-vali-lote   = date(month(tt-gera-transf.dt-fabricacao), 1, year(tt-gera-transf.dt-fabricacao))
                         tt-movto.cod-refer      = tt-gera-transf.cod-refer
                         tt-movto.quantidade     = tt-gera-transf.quantidade
                         tt-movto.un             = ITEM.un
                         tt-movto.esp-docto      = 33
                         tt-movto.tipo-trans     = 1
                         tt-movto.descricao-db   = tt-gera-transf.narrativa
                         tt-movto.cod-prog-orig  = "v03in218"
                         tt-movto.cod-emitente   = tt-gera-transf.cod-emitente
                         tt-movto.usuario        = c-seg-usuario
                         tt-movto.cod-unid-negoc = item-uni-estab.cod-unid-negoc.

                  ASSIGN tt-gera-transf.lote = tt-movto.lote.

            END.

            RUN pi-acompanhar IN h-acomp (INPUT "Gerando Transferˆncia").

            RUN cep/ceapi001k.p persistent set h-ceapi001k.
            
            RUN pi-execute IN h-ceapi001k (input-output table tt-movto,
                                           input-output table tt-erro, 
                                           INPUT l-deleta-erros).

            FIND FIRST tt-erro NO-LOCK no-error.

            IF RETURN-VALUE = "NOK":U OR AVAIL tt-erro THEN DO:
                 run cdp/cd0666.w (input table tt-erro).
                 l-erro = yes.  

                 RUN pi-finalizar IN h-acomp.

                 FOR EACH tt-erro.
                     DELETE tt-erro.
                 END.

                 RETURN "NOK".

            END.

            ELSE DO:

                RUN pi-finalizar IN h-acomp.

                FOR EACH tt-gera-transf NO-LOCK
                   WHERE tt-gera-transf.l-considera = "*".

                    FIND FIRST ficha-cq 
                         WHERE ficha-cq.nr-ficha = tt-gera-transf.nr-ficha NO-ERROR.

                    IF AVAIL ficha-cq THEN DO: 
                        
                        ASSIGN ficha-cq.qt-rejeitada  = ficha-cq.qt-rejeitada + tt-gera-transf.quantidade
                               ficha-cq.qt-a-liberar  = ficha-cq.qt-a-liberar + tt-gera-transf.quantidade
                               ficha-cq.inspecionado = YES
                               ficha-cq.situacao     = 4
                               ficha-cq.dt-ult-sit   = TODAY
                               ficha-cq.cod-resp     = c-seg-usuario
                               ficha-cq.narrativa    = c-texto.

                        IF ficha-cq.dt-inspecao = ? THEN ASSIGN ficha-cq.dt-inspecao = tt-gera-transf.dt-trans.

                             FIND FIRST rej-ficha NO-LOCK
                                  WHERE rej-ficha.nr-ficha = ficha-cq.nr-ficha NO-ERROR.

                             IF NOT AVAIL rej-ficha THEN DO:

                                create rej-ficha.
                                assign rej-ficha.nr-ficha     = ficha-cq.nr-ficha 
                                       rej-ficha.dep-rej      = tt-gera-transf.dep-ent
                                       rej-ficha.codigo-rejei = tt-gera-transf.cod-rej
                                       rej-ficha.observacao   = tt-gera-transf.obs
                                       rej-ficha.qt-rejeitada = tt-gera-transf.quantidade
                                       rej-ficha.quant-rej    = tt-gera-transf.quantidade.  
                             END.

                        /* ATUALIZA€ÇO DA INSPE€ÇO DO FORNECEDOR */
                        {cdp/cd9320.i}

                        RELEASE item-fornec.
                        RELEASE item-fornec-estab.

                    END.

                END.

            END.

        END.

    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorno w-livre 
PROCEDURE pi-retorno :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-----------------------------------------------------------------------------*/

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    assign l-cliente = NO
           l-nr-ac-ex = NO.

    BlocoRetorno:
    DO TRANSACTION:
        FIND FIRST param-cq NO-LOCK NO-ERROR.

        FOR FIRST tt-ficha
            WHERE tt-ficha.l-marcado:
           FIND FIRST ficha-cq NO-LOCK
                WHERE ficha-cq.nr-ficha = tt-ficha.nr-ficha NO-ERROR.
           IF AVAIL ficha-cq 
                AND ficha-cq.origem = 2 
                AND ficha-cq.nat-operacao <> "" then do:
           
               ASSIGN i-nr-ficha = ficha-cq.nr-ficha.
               find b-responsavel where b-responsavel.cod-resp = c-seg-usuario no-lock no-error.

               RUN pi-valida-ficha.
               IF RETURN-VALUE = "NOK" THEN
                  UNDO BlocoRetorno, return no-apply.
           
               
               if  ficha-cq.origem = 2 then do:
                   assign l-rejeita = no.
                   find estabelec where estabel.cod-estabel = ficha-cq.cod-estabel NO-LOCK no-error.
                   if  avail estabelec then do:
                       if  estabelec.dep-rej-cq = ""
                           then assign l-rej-desab = no.
                           else assign l-rej-desab = yes.
                   end.                        
                   if  l-nr-ac-ex = no then do:
                       assign l-disab = no.
                       run cqp/escq0210d.w (input-output l-disab,
                                         input-output c-op-des,
                                         input-output de-inspecao,
                                         input-output c-rejeitado,
                                         input-output c-codigo,
                                         input-output c-emite,
                                         output       l-cancela,
                                         input-output l-rej-desab,
                                         input        l-cliente).
                       if  l-cancela = no then 
                           UNDO BlocoRetorno, RETURN NO-APPLY.

                       run cqp/escq0211b.w (input-output c-texto).
                   end.
                   else do:
                       assign l-rejeita = yes
                              l-disab   = yes.
                       if ficha-cq.sit-rot <> 0 then do:
                          if exame.rejeita-lote = no then do:
                              run utp/ut-msgs.p (input "show", input 1163, input ""). 
                             /* Lote possui N’o Conformes. Confirma Rejei»’o? */
                             if  return-value = 'no' then do:
                                 assign l-nr-ac-ex = no.
                                 UNDO BlocoRetorno, RETURN NO-APPLY.
                             end.
                             else do:
                                run cqp/escq0210d.w (input-output l-disab,
                                                  input-output c-op-des,
                                                  input-output de-inspecao,
                                                  input-output c-rejeitado,
                                                  input-output c-codigo,
                                                  input-output c-emite,
                                                  output       l-cancela,
                                                  input-output l-rej-desab,
                                                  input        l-cliente). 
                                if  l-cancela = no then do:
                                    assign l-nr-ac-ex = no.
                                    UNDO BlocoRetorno, RETURN NO-APPLY. 
                                end.        

                                run cqp/escq0211b.w (input-output c-texto).
                                assign c-op-des = "3".
                             end.
                          end.
                          else do:            
                             run utp/ut-msgs.p (input "show", input 17095, input ""). 
                             /* Lote possui N’o Conformes. Serÿ Rejeitado automaticamente! */
                             run cqp/escq0210d.w (input-output l-disab,
                                               input-output c-op-des,
                                               input-output de-inspecao,
                                               input-output c-rejeitado,
                                               input-output c-codigo,
                                               input-output c-emite,
                                               output       l-cancela,
                                               input-output l-rej-desab,
                                               input        l-cliente).   

                             run cqp/escq0211b.w (input-output c-texto).
                          end.   
                       end.   
                       ELSE DO:
                          assign l-disab = no.
                          RUN cqp/escq0210d.w (input-output l-disab,
                                         input-output c-op-des,
                                         input-output de-inspecao,
                                         input-output c-rejeitado,
                                         input-output c-codigo,
                                         input-output c-emite,
                                         output       l-cancela,
                                         input-output l-rej-desab,
                                         input        l-cliente).
                          if  l-cancela = no then 
                          UNDO BlocoRetorno, RETURN NO-APPLY.
                          run cqp/escq0211b.w (input-output c-texto).
                       END.
                   end. 
                   assign r-ficha-cq = rowid(ficha-cq)
/*                           c-texto    = ""                 */
/*                           c-texto    = ficha-cq.narrativa */
                          l-nr-ac-ex = no.
                   
                   find ficha-cq where rowid(ficha-cq) = r-ficha-cq EXCLUSIVE-LOCK no-error.
                   if  avail ficha-cq THEN
                       assign ficha-cq.narrativa = c-texto.
           
                   /* APROVADO */
                   if  c-op-des = "1" then do:
                      RUN pi-aprova.
                      IF RETURN-VALUE = "NOK" THEN
                         UNDO BlocoRetorno, RETURN NO-APPLY.
                   END.
                                
                   /* APROVADO CONDICIONAL */
                   if  c-op-des = "2" then do:
                      RUN pi-aprov-cond.
                      IF RETURN-VALUE = "NOK" THEN
                         UNDO BlocoRetorno, RETURN NO-APPLY.
                   END.
           
                   /* REJEITADO */
                   if  c-op-des = "3" then do:
                      RUN pi-rejeita.
                      IF RETURN-VALUE = "NOK" THEN
                         UNDO BlocoRetorno, RETURN NO-APPLY.
                   END.
           
                   /* PERDA */
                   if  c-op-des = "4" THEN DO:
                      RUN pi-perda.
                      IF RETURN-VALUE = "NOK" THEN
                         UNDO BlocoRetorno, RETURN NO-APPLY.
                   END.
           
               END.
           
           END.
           ELSE DO:
               RUN utp/ut-msgs.p (INPUT 'show',
                                  INPUT 17006,
                                  INPUT "Origem roteiro inv lida!"
                                  + "~~" +
                                  "Este programa aceita apenas roteiros originados no recebimento.").
               
               UNDO BlocoRetorno, RETURN NO-APPLY.
           END.
        END.
    END.

    RUN pi-executa.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-ficha w-livre 
PROCEDURE pi-valida-ficha :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-----------------------------------------------------------------------------*/

    if  avail b-responsavel and ficha-cq.cod-resp <> "" then do:
        if  ficha-cq.cod-resp <> c-seg-usuario and b-responsavel.log-1 = no then do:
            run utp/ut-msgs.p (input "show", input 15636, input ""). /* Este roteiro n’o ² de responsabilidade deste usuÿrio. */
            RETURN "NOK".
        end.
    end.
   
    if  ficha-cq.origem       = 1
    and ficha-cq.baixa-estoq  = no
    and ficha-cq.inspecionado = yes
    and ficha-cq.situacao     = 4
    and ficha-cq.liberada     = yes then do:
        run utp/ut-msgs.p (input "show", input 829, input ""). /* Quantidade em CQ igual a zero, Roteiro jÿ inspecionado */
        RETURN "NOK".
    end.
    if  ficha-cq.qt-original  - ficha-cq.qt-aprovada
      - ficha-cq.qt-consumida - ficha-cq.qt-rejeitada
      - ficha-cq.qt-apr-cond <= 0 then do:
        run utp/ut-msgs.p (input "show", input 829, input ""). /* Quantidade em CQ igual a zero, Roteiro jÿ inspecionado */
        RETURN "NOK".
    end.

    assign l-todos = yes.
    
    IF NOT CAN-FIND (FIRST exam-ficha WHERE exam-ficha.nr-ficha = ficha-cq.nr-ficha) THEN DO:
            {utp/ut-liter.i "Roteiro_Inspe»’o"}
                ASSIGN c-lb-ficha = RETURN-VALUE.
            {utp/ut-liter.i "Exames"}
                ASSIGN c-lb-exame = RETURN-VALUE.
            {utp/ut-liter.i "continuar"}
             run utp/ut-msgs.p (input "show", input 25508, INPUT c-lb-ficha + " " + string(ficha-cq.nr-ficha) + "~~" +
                                                                 c-lb-exame + "~~" + RETURN-VALUE + "~~" + c-lb-exame). 
              /*Roteiro Inspe»’o n’o possui Exames. Deseja continuar?*/                                           
             if  return-value = 'no' then
                 return 'adm-error'.
    END.
    ELSE DO:
        for each  exam-ficha use-index codigo no-lock
            where exam-ficha.nr-ficha = ficha-cq.nr-ficha:
   
            if avail exam-ficha and
               exam-ficha.nr-ac-ex > exam-ficha.nr-aceita then do:
   
               if  exame.homogeneo = no then do:
                   if  exam-ficha.nr-ac-ex > 0 and 
                       exam-ficha.nr-ac-ex >= exam-ficha.nr-rejeita then
                       assign l-nr-ac-ex = yes. 
               end.
   
               if  exame.homogeneo = yes then do:
                   if  exam-ficha.nr-ac-ex > 0 then
                       assign l-nr-ac-ex = yes.                                       
               end.
   
            end.
   
            if can-find (first it-comp-exame where
                   it-comp-exame.cod-exame = exam-ficha.cod-exame) then
            for each  it-comp-exame no-lock
                where it-comp-exame.cod-exame = exam-ficha.cod-exame and 
                      it-comp-exame.it-codigo = ficha-cq.it-codigo and
                      it-comp-exame.situacao = 1:
   
                find first res-fic-cq
                    where  res-fic-cq.nr-ficha = ficha-cq.nr-ficha
                    and   res-fic-cq.it-codigo = ficha-cq.it-codigo
                    and   res-fic-cq.cod-exame = exam-ficha.cod-exame
                    and   res-fic-cq.cod-comp  = it-comp-exame.cod-comp
                    no-lock no-error.
                if  not avail res-fic-cq then assign l-todos = no.
            end.
            else 
            for each  comp-exame no-lock
                where comp-exame.cod-exame  = exam-ficha.cod-exame
                  and comp-exame.cdn-versao = exam-ficha.cdn-versao
                  and comp-exame.log-1 :
   
                find first res-fic-cq
                     where res-fic-cq.nr-ficha = ficha-cq.nr-ficha
                     and   res-fic-cq.it-codigo = ficha-cq.it-codigo
                     and   res-fic-cq.cod-exame = exam-ficha.cod-exame
                     and   res-fic-cq.cod-comp  = comp-exame.cod-comp
                     no-lock no-error.
                if  not avail res-fic-cq then assign l-todos = no.
            end.
        end.
    END.
   
/*     if  l-todos = no then do:                                                                                      */
/*         run utp/ut-msgs.p (input "show", input 1162, input ""). /* Existem componentes sem resultado. Continua? */ */
/*         if  return-value = 'no' then                                                                               */
/*             RETURN "NOK".                                                                    */
/*     end.                                                                                                           */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-obs-insp w-livre 
PROCEDURE pi-valida-obs-insp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST int-item-fornec NO-LOCK 
     WHERE int-item-fornec.cod-emitente = b-ficha-cq.cod-emitente 
       AND int-item-fornec.it-codigo = b-ficha-cq.it-codigo 
NO-ERROR.

IF AVAIL int-item-fornec THEN
DO:
    IF int-item-fornec.obs-rec <> '' THEN
    DO:
        run utp/ut-msgs.p (input "show":U,
                input 27100,                                            
                input 'Deseja realmente liberar o Roteiro ?~~' + 'Item ' + upper(int-item-fornec.it-codigo) + ' possui observacao' +  CHR(13) + CHR(13) + 
                      'Conteudo: ' + upper(int-item-fornec.obs-rec)  ).

        IF RETURN-VALUE = 'no' THEN
           RETURN "NOK":U. 
    END.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-livre  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-ficha"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-livre 
PROCEDURE state-changed :
/*:T -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

