&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
*******************************************************************************/
{include/i-prgvrs.i ESCQ0210 1.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ESCQ0210 <m¢dulo>}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCQ0210
&GLOBAL-DEFINE Version        1.00.00.000

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   br-table br-exam-ficha c-cod-emitente c-serie-docto c-nro-docto ~
                              c-nat-operacao c-lote bt-cancela bt-confirma bt-resultado bt-marcar bt-desmarcar bt-todos bt-nenhum ~
                              bt-retorno
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

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

DEFINE TEMP-TABLE tt-exam-ficha NO-UNDO
    LIKE exam-ficha
    FIELD r-exam-ficha AS ROWID.

DEFINE BUFFER b-ficha-cq FOR ficha-cq.
DEFINE BUFFER b-res-fic-cq FOR res-fic-cq.

def var c-texto         as char    no-undo.
def var r-rej           as rowid   no-undo.
def var l-ok            as logical no-undo.

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

DEFINE VARIABLE wh-pesquisa                      AS HANDLE NO-UNDO.
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

/* /* include com a defini‡Æo da frame de cabe‡alho e rodap‚ */ */
{include/i-rpcab.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-exam-ficha

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-exam-ficha exame tt-ficha

/* Definitions for BROWSE br-exam-ficha                                 */
&Scoped-define FIELDS-IN-QUERY-br-exam-ficha tt-exam-ficha.cod-exame exame.descricao tt-exam-ficha.cdn-versao tt-exam-ficha.responsavel tt-exam-ficha.nr-ac-ex tt-exam-ficha.nr-aceita tt-exam-ficha.nr-rejeita tt-exam-ficha.tam-amostra   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-exam-ficha tt-exam-ficha.nr-ac-ex   
&Scoped-define ENABLED-TABLES-IN-QUERY-br-exam-ficha tt-exam-ficha
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br-exam-ficha tt-exam-ficha
&Scoped-define SELF-NAME br-exam-ficha
&Scoped-define QUERY-STRING-br-exam-ficha FOR EACH tt-exam-ficha                            WHERE tt-exam-ficha.nr-ficha = tt-ficha.nr-ficha NO-LOCK, ~
                                   EACH exame WHERE exame.cod-exame = tt-exam-ficha.cod-exame                              AND exame.cdn-versao = tt-exam-ficha.cdn-versao NO-LOCK
&Scoped-define OPEN-QUERY-br-exam-ficha OPEN QUERY {&SELF-NAME} FOR EACH tt-exam-ficha                            WHERE tt-exam-ficha.nr-ficha = tt-ficha.nr-ficha NO-LOCK, ~
                                   EACH exame WHERE exame.cod-exame = tt-exam-ficha.cod-exame                              AND exame.cdn-versao = tt-exam-ficha.cdn-versao NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br-exam-ficha tt-exam-ficha exame
&Scoped-define FIRST-TABLE-IN-QUERY-br-exam-ficha tt-exam-ficha
&Scoped-define SECOND-TABLE-IN-QUERY-br-exam-ficha exame


/* Definitions for BROWSE br-table                                      */
&Scoped-define FIELDS-IN-QUERY-br-table tt-ficha.l-marcado tt-ficha.nr-ficha tt-ficha.it-codigo tt-ficha.desc-item tt-ficha.cod-emitente tt-ficha.cod-estabel tt-ficha.cod-depos tt-ficha.situacao tt-ficha.quantidade tt-ficha.cod-localiz tt-ficha.cod-refer tt-ficha.lote tt-ficha.dt-vali tt-ficha.cod-resp tt-ficha.dt-trans   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-table   
&Scoped-define SELF-NAME br-table
&Scoped-define QUERY-STRING-br-table FOR EACH tt-ficha
&Scoped-define OPEN-QUERY-br-table OPEN QUERY {&SELF-NAME} FOR EACH tt-ficha.
&Scoped-define TABLES-IN-QUERY-br-table tt-ficha
&Scoped-define FIRST-TABLE-IN-QUERY-br-table tt-ficha


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-br-exam-ficha}~
    ~{&OPEN-QUERY-br-table}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar btQueryJoins ~
btReportsJoins btExit btHelp btOK btCancel btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
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
     SIZE 132 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 132 BY 1.5
     BGCOLOR 7 .

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

DEFINE BUTTON bt-resultado 
     LABEL "Resultado" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-retorno 
     LABEL "Retorno" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-todos 
     LABEL "Todos" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-cod-emitente AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Emitente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-lote AS CHARACTER FORMAT "x(40)" 
     LABEL "Lote/S‚rie" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .79 NO-UNDO.

DEFINE VARIABLE c-nat-operacao AS CHARACTER FORMAT "x(06)" 
     LABEL "Nat Opera‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-nro-docto AS CHARACTER FORMAT "x(16)" 
     LABEL "Documento" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-serie-docto AS CHARACTER FORMAT "x(5)" 
     LABEL "S‚rie" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 34.57 BY 8.5.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 32 BY 6.79.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 5.63.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 10.25.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-exam-ficha FOR 
      tt-exam-ficha, 
      exame SCROLLING.

DEFINE QUERY br-table FOR 
      tt-ficha SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-exam-ficha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-exam-ficha wWindow _FREEFORM
  QUERY br-exam-ficha DISPLAY
      tt-exam-ficha.cod-exame FORMAT ">>>>>9":U
exame.descricao FORMAT "x(30)":U
tt-exam-ficha.cdn-versao FORMAT ">9":U
tt-exam-ficha.responsavel FORMAT "x(12)":U
tt-exam-ficha.nr-ac-ex FORMAT ">>9":U
tt-exam-ficha.nr-aceita FORMAT ">>9":U
tt-exam-ficha.nr-rejeita FORMAT ">>9":U
tt-exam-ficha.tam-amostra FORMAT ">>>9":U 
ENABLE
tt-exam-ficha.nr-ac-ex
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 74 BY 5
         FONT 1 FIT-LAST-COLUMN.

DEFINE BROWSE br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-table wWindow _FREEFORM
  QUERY br-table DISPLAY
      tt-ficha.l-marcado    COLUMN-LABEL "*"       
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
    WITH NO-ROW-MARKERS SEPARATORS NO-TAB-STOP SIZE 87 BY 8
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 116.57 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 120.57 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 124.57 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 128.57 HELP
          "Ajuda"
     btOK AT ROW 23.21 COL 2
     btCancel AT ROW 23.21 COL 13
     btHelp2 AT ROW 23.21 COL 122.43
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 23 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 132 BY 23.67
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     br-table AT ROW 2 COL 3 WIDGET-ID 200
     c-cod-emitente AT ROW 2.25 COL 104 COLON-ALIGNED WIDGET-ID 6
     c-serie-docto AT ROW 3.25 COL 104 COLON-ALIGNED WIDGET-ID 64
     c-nro-docto AT ROW 4.25 COL 104 COLON-ALIGNED WIDGET-ID 66
     c-nat-operacao AT ROW 5.25 COL 104 COLON-ALIGNED WIDGET-ID 68
     c-lote AT ROW 6.25 COL 104 COLON-ALIGNED WIDGET-ID 72
     bt-cancela AT ROW 7.25 COL 114 WIDGET-ID 40 NO-TAB-STOP 
     bt-confirma AT ROW 7.25 COL 118 WIDGET-ID 36 NO-TAB-STOP 
     bt-marcar AT ROW 10.17 COL 5 WIDGET-ID 92
     bt-desmarcar AT ROW 10.17 COL 15.57 WIDGET-ID 94
     bt-todos AT ROW 10.17 COL 26 WIDGET-ID 98
     bt-nenhum AT ROW 10.17 COL 36.57 WIDGET-ID 96
     br-exam-ficha AT ROW 12.33 COL 5 WIDGET-ID 300
     bt-resultado AT ROW 17.83 COL 30 WIDGET-ID 44
     bt-retorno AT ROW 17.83 COL 41 WIDGET-ID 42
     "Dados Nota Fiscal:" VIEW-AS TEXT
          SIZE 14 BY .54 AT ROW 1.25 COL 94 WIDGET-ID 4
     "Roteiros de Inspe‡Æo:" VIEW-AS TEXT
          SIZE 16 BY .54 AT ROW 1 COL 5 WIDGET-ID 80
     "Exames Roteiros de Inspe‡Æo:" VIEW-AS TEXT
          SIZE 22 BY .54 AT ROW 11.67 COL 5 WIDGET-ID 74
     RECT-15 AT ROW 1.5 COL 93 WIDGET-ID 2
     RECT-16 AT ROW 2 COL 94 WIDGET-ID 8
     RECT-17 AT ROW 12 COL 3 WIDGET-ID 76
     RECT-18 AT ROW 1.25 COL 2 WIDGET-ID 78
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 4
         SIZE 128 BY 18
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
         HEIGHT             = 23.67
         WIDTH              = 132
         MAX-HEIGHT         = 36.21
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 36.21
         VIRTUAL-WIDTH      = 182.86
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB br-table RECT-18 fPage1 */
/* BROWSE-TAB br-exam-ficha bt-nenhum fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-exam-ficha
/* Query rebuild information for BROWSE br-exam-ficha
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-exam-ficha
                           WHERE tt-exam-ficha.nr-ficha = tt-ficha.nr-ficha NO-LOCK,
                            EACH exame WHERE exame.cod-exame = tt-exam-ficha.cod-exame
                             AND exame.cdn-versao = tt-exam-ficha.cdn-versao NO-LOCK
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-exam-ficha */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-table
/* Query rebuild information for BROWSE br-table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ficha.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-table */
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


&Scoped-define BROWSE-NAME br-table
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table wWindow
ON MOUSE-SELECT-CLICK OF br-table IN FRAME fPage1
DO:
    
    {&open-query-br-exam-ficha}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table wWindow
ON MOUSE-SELECT-DBLCLICK OF br-table IN FRAME fPage1
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table wWindow
ON VALUE-CHANGED OF br-table IN FRAME fPage1
DO:
  FIND tt-ficha
      WHERE tt-ficha.nr-ficha = INPUT BROWSE br-table tt-ficha.nr-ficha NO-LOCK NO-ERROR.

  IF NOT AVAIL tt-ficha THEN DO:

      ASSIGN bt-resultado:SENSITIVE = NO
             bt-retorno:SENSITIVE   = NO.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela wWindow
ON CHOOSE OF bt-cancela IN FRAME fPage1 /* Cancel */
DO:
  RUN pi-limpa-tela.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-confirma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-confirma wWindow
ON CHOOSE OF bt-confirma IN FRAME fPage1 /* Save */
DO:    
    RUN pi-executa.
    
    APPLY "entry" TO c-cod-emitente.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-desmarcar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-desmarcar wWindow
ON CHOOSE OF bt-desmarcar IN FRAME fPage1 /* Desmarcar */
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-marcar wWindow
ON CHOOSE OF bt-marcar IN FRAME fPage1 /* Marcar */
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-nenhum wWindow
ON CHOOSE OF bt-nenhum IN FRAME fPage1 /* Nenhum */
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


&Scoped-define SELF-NAME bt-resultado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-resultado wWindow
ON CHOOSE OF bt-resultado IN FRAME fPage1 /* Resultado */
DO:

    if  rowid(tt-exam-ficha) = ? then
    apply "entry" to browse br-exam-ficha /*in frame {&frame-name}*/ .

    FIND FIRST tt-ficha
         WHERE tt-ficha.l-marcado = YES NO-ERROR.

    IF NOT AVAIL tt-ficha THEN DO:
        RUN utp/ut-msgs.p(INPUT "show",
                          INPUT 17006,
                          INPUT "Selecione ao menos uma ficha.").
        RETURN 'adm-error'.
    END.
    
    FIND FIRST tt-exam-ficha WHERE tt-exam-ficha.nr-ficha =  tt-ficha.nr-ficha NO-LOCK no-error.
    
    find ficha-cq where ficha-cq.nr-ficha = tt-ficha.nr-ficha NO-LOCK no-error.

    FIND FIRST exam-ficha NO-LOCK
         WHERE exam-ficha.nr-ficha  = ficha-cq.nr-ficha
           AND exam-ficha.cod-exame = tt-exam-ficha.cod-exame NO-ERROR.

    assign r-exam-ficha = rowid(exam-ficha).

    if  not avail exam-ficha then do:
        {utp/ut-liter.i Roteiro MCQ}
        assign c-mesg1 = trim(return-value).
        {utp/ut-table.i mgind exame 1}
        assign c-mesg2 = trim(return-value).
        run utp/ut-msgs.p (input "show", input 2734, input c-mesg1 + "~~" + c-mesg2).
        return 'adm-error'.
    end.

    find responsavel where responsavel.cod-resp = c-seg-usuario no-lock no-error.
    if avail responsavel and
       exam-ficha.responsavel <> responsavel.cod-resp then do:
        find b-responsavel
            where b-responsavel.cod-resp = exam-ficha.responsavel
            no-lock no-error.
        if  avail b-responsavel and b-responsavel.log-1 = no then do:
            run utp/ut-msgs.p (input "show",
                               input 4304,
                               input string(exam-ficha.cod-exame) + "~~" +
                                            exam-ficha.responsavel).
            return no-apply.
        end.
    end.

    if  avail exam-ficha then do:
        find ficha-cq where ficha-cq.nr-ficha = exam-ficha.nr-ficha NO-LOCK no-error.
        if  avail ficha-cq then do:
            if  ficha-cq.inspecionado = yes then do:
                run utp/ut-msgs.p (input "show", input 827, input "").
                return 'adm-error'.
            end.
            if  ficha-cq.situacao <> 2 then do:
                run utp/ut-msgs.p (input "show", input 828, input "").
                return 'adm-error'.
            end.
            if  ficha-cq.qt-original  - ficha-cq.qt-aprovada
              - ficha-cq.qt-consumida - ficha-cq.qt-rejeitada
              - ficha-cq.qt-apr-cond <= 0 then do:
                run utp/ut-msgs.p (input "show", input 829, input "").
                return 'adm-error'.
            end.
        end.
    end.
    assign l-atualiza = yes.
    {&WINDOW-NAME}:SENSITIVE = NO.
    run cqp/escq0210a.w (input r-exam-ficha).
    apply "entry" to browse br-exam-ficha.
    {&WINDOW-NAME}:SENSITIVE = YES.

    IF RETURN-VALUE <> "NOK" THEN DO:

        find CURRENT ficha-cq EXCLUSIVE-LOCK no-error.
    
        assign l-todos = yes.
        for each  b-exam-ficha use-index codigo no-lock
            where b-exam-ficha.nr-ficha = ficha-cq.nr-ficha:
            if can-find (first it-comp-exame where
                               it-comp-exame.it-codigo = ficha-cq.it-codigo and
                               it-comp-exame.cod-exame = b-exam-ficha.cod-exame)
               then do:
                for each  it-comp-exame no-lock
                    where it-comp-exame.it-codigo = ficha-cq.it-codigo and
                          it-comp-exame.cod-exame = b-exam-ficha.cod-exame and
                          it-comp-exame.situacao  = 1:
    
                    find first res-fic-cq
                        where  res-fic-cq.nr-ficha  = ficha-cq.nr-ficha
                        and    res-fic-cq.it-codigo = ficha-cq.it-codigo
                        and    res-fic-cq.cod-exame = b-exam-ficha.cod-exame
                        and    res-fic-cq.cod-comp  = it-comp-exame.cod-comp no-lock no-error.
                    if  not avail res-fic-cq then assign l-todos = no.
                end.   
            end.
            else do:
                for each  comp-exame no-lock
                    where comp-exame.cod-exame  = b-exam-ficha.cod-exame 
                      and comp-exame.cdn-versao = b-exam-ficha.cdn-versao 
                      and comp-exame.log-1      = yes :  /* Ativo */
    
                    find first res-fic-cq
                        where  res-fic-cq.nr-ficha  = ficha-cq.nr-ficha
                        and    res-fic-cq.it-codigo = ficha-cq.it-codigo
                        and    res-fic-cq.cod-exame = b-exam-ficha.cod-exame
                        and    res-fic-cq.cod-comp  = comp-exame.cod-comp no-lock no-error.
                    if  not avail res-fic-cq then assign l-todos = no.
                end.
            end.
        end.
        if  l-todos = yes then do:
            assign ficha-cq.situacao = 3
                   ficha-cq.dt-ult-sit = today.
        end.
    
        assign ficha-cq.sit-rot = 0.
    
        if  exame.amostragem = yes then do:
            assign tt-exam-ficha.nr-ac-ex:read-only in browse br-exam-ficha = no.
            apply 'entry' to browse br-exam-ficha.
            apply 'entry' to tt-exam-ficha.nr-ac-ex in browse br-exam-ficha.
        end.
    
        FIND CURRENT ficha-cq NO-LOCK NO-ERROR.
    
        FOR EACH exam-ficha NO-LOCK
           WHERE exam-ficha.nr-ficha = ficha-cq.nr-ficha.
    
           FOR EACH b-ficha-cq 
              WHERE b-ficha-cq.cod-emitente = ficha-cq.cod-emitente
                AND b-ficha-cq.serie-docto  = ficha-cq.serie-docto
                AND b-ficha-cq.nat-operacao = ficha-cq.nat-operacao
                AND b-ficha-cq.nro-docto    = ficha-cq.nro-docto
                AND b-ficha-cq.lote         = ficha-cq.lote
                AND b-ficha-cq.nr-ficha    <> ficha-cq.nr-ficha 
                AND b-ficha-cq.situacao     = 2,
              FIRST tt-ficha
              WHERE tt-ficha.l-marcado
                AND tt-ficha.nr-ficha       = b-ficha-cq.nr-ficha.

               FIND FIRST b-exam-ficha NO-LOCK
                    WHERE b-exam-ficha.nr-ficha  = b-ficha-cq.nr-ficha
                      AND b-exam-ficha.cod-exame = exam-ficha.cod-exame NO-ERROR.
    
               IF NOT AVAIL b-exam-ficha THEN NEXT.
    
                     FOR EACH res-fic-cq NO-LOCK
                        WHERE res-fic-cq.nr-ficha  = exam-ficha.nr-ficha
                          AND res-fic-cq.cod-exame = exam-ficha.cod-exame.
    
                         FIND FIRST b-res-fic-cq 
                              WHERE b-res-fic-cq.nr-ficha  = b-exam-ficha.nr-ficha
                                AND b-res-fic-cq.cod-exame = b-exam-ficha.cod-exame
                                AND b-res-fic-cq.cod-comp  = res-fic-cq.cod-comp NO-ERROR.
    
                         IF NOT AVAIL b-res-fic-cq THEN DO:
    
                             CREATE b-res-fic-cq.
                             BUFFER-COPY res-fic-cq EXCEPT it-codigo nr-ficha TO b-res-fic-cq.
                             ASSIGN b-res-fic-cq.it-codigo = b-ficha-cq.it-codigo
                                    b-res-fic-cq.nr-ficha  = b-ficha-cq.nr-ficha.
    
                         END.
    
                         ELSE DO:
    
                             ASSIGN b-res-fic-cq.dt-result = res-fic-cq.dt-result
                                    b-res-fic-cq.resultado = res-fic-cq.resultado
                                    b-res-fic-cq.nr-tabela = res-fic-cq.nr-tabela
                                    b-res-fic-cq.seq-comp  = res-fic-cq.seq-comp
                                    b-res-fic-cq.laudo     = res-fic-cq.laudo
                                    b-res-fic-cq.resultado = res-fic-cq.resultado
                                    b-res-fic-cq.res-max   = res-fic-cq.res-max
                                    b-res-fic-cq.narrativa = res-fic-cq.narrativa.
                         END.
    
                     END.
    
    
                     if  l-todos = yes then do:
                        assign b-ficha-cq.situacao = 3
                               b-ficha-cq.dt-ult-sit = today.
                     end.
    
           END.
    
        END.

    END.

    RUN pi-executa.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-retorno
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-retorno wWindow
ON CHOOSE OF bt-retorno IN FRAME fPage1 /* Retorno */
DO:
    FIND FIRST tt-ficha
         WHERE tt-ficha.l-marcado = YES NO-ERROR.

    IF NOT AVAIL tt-ficha THEN DO:
        RUN utp/ut-msgs.p(INPUT "show",
                          INPUT 17006,
                          INPUT "Selecione ao menos uma ficha.").
        RETURN 'adm-error'.
    END.

    if  rowid(tt-exam-ficha) = ? then
    apply "entry" to browse br-exam-ficha /*in frame {&frame-name}*/ .

    assign r-exam-ficha = rowid(tt-exam-ficha).

    find tt-exam-ficha where rowid(tt-exam-ficha) = r-exam-ficha NO-LOCK no-error.

    RUN cqp/escq0210f.p (INPUT tt-exam-ficha.nr-ficha,
                         INPUT ROWID(exame),
                         INPUT TABLE tt-ficha).

    RUN pi-executa.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-todos wWindow
ON CHOOSE OF bt-todos IN FRAME fPage1 /* Todos */
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


&Scoped-define FRAME-NAME fpage0
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME c-nro-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nro-docto wWindow
ON f5 OF c-nro-docto IN FRAME fPage1 /* Documento */
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
                       &campo5=c-lote
                       &campozoom5=lote
                       &FRAME=fpage1}



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nro-docto wWindow
ON MOUSE-SELECT-DBLCLICK OF c-nro-docto IN FRAME fPage1 /* Documento */
DO:

apply "f5":U to self.

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


&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-exam-ficha
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/*Colocar a declara?'o da procedure no main-block*/
PROCEDURE ShellExecuteA EXTERNAL "shell32.dll":U:
    DEFINE INPUT PARAMETER  plHWND       AS LONG      NO-UNDO.
    DEFINE INPUT PARAMETER  pcOperation  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER  pcFile       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER  pcParameters AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER  pcDirectory  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER  plShowCmd    AS LONG      NO-UNDO.
    DEFINE RETURN PARAMETER plInstance  AS LONG      NO-UNDO.
END.

/* Code placed here will execute AFTER standard behavior.    */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    APPLY "leave":U TO c-cod-emitente IN FRAME fPage1.
    APPLY "entry":U TO c-cod-emitente IN FRAME fPage1.

    IF c-nro-docto:LOAD-MOUSE-POINTER("image/lupa.cur") IN FRAME fPage1 THEN.

    RETURN "Ok":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy wWindow 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

    &if "{&bf_mat_versao_ems}" >= "2.062" &then
        IF  VALID-HANDLE(h-ceapi001k) THEN DELETE PROCEDURE h-ceapi001k.
        ASSIGN h-ceapi001k = ?.
    &endif

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executa wWindow 
PROCEDURE pi-executa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-ficha.
    EMPTY TEMP-TABLE tt-exam-ficha.

    FOR EACH ficha-cq NO-LOCK
       WHERE ficha-cq.cod-emitente   = INT(INPUT FRAME fPage1 c-cod-emitente)
         AND ficha-cq.serie-docto    = INPUT FRAME fPage1 c-serie-docto
         AND ficha-cq.nro-docto      = INPUT FRAME fPage1 c-nro-docto
         AND ficha-cq.nat-operacao   = INPUT FRAME fPage1 c-nat-operacao
         AND ficha-cq.lote           = INPUT FRAME fPage1 c-lote
         AND ficha-cq.origem         = 2
         AND ficha-cq.nat-operacao <> ""
         AND ficha-cq.cod-emitente <> 0
         AND ficha-cq.situacao <> 4,
        FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = ficha-cq.it-codigo,
        FIRST in-grup-estoq NO-LOCK WHERE in-grup-estoq.ge-codigo = ITEM.ge-codigo
          AND in-grup-estoq.log-ckd = YES.

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

        IF AVAIL ITEM THEN DO:
            
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

        FOR EACH exam-ficha NO-LOCK
           WHERE exam-ficha.nr-ficha = ficha-cq.nr-ficha:

            FIND FIRST tt-exam-ficha NO-LOCK
                 WHERE tt-exam-ficha.nr-ficha = exam-ficha.nr-ficha NO-ERROR.

            IF NOT AVAIL tt-exam-ficha THEN DO:

               CREATE tt-exam-ficha.          
               BUFFER-COPY exam-ficha TO tt-exam-ficha NO-ERROR.
               ASSIGN tt-exam-ficha.r-exam-ficha = ROWID(exam-ficha).
            END.
        END.
    
    END.
             
    {&open-query-br-table}
    {&open-query-br-exam-ficha}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-limpa-tela wWindow 
PROCEDURE pi-limpa-tela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 ASSIGN c-cod-emitente:SCREEN-VALUE IN FRAME fPage1 = ""
        c-serie-docto:SCREEN-VALUE IN FRAME fPage1  = ""
        c-nro-docto:SCREEN-VALUE IN FRAME fPage1    = ""
        c-nat-operacao:SCREEN-VALUE IN FRAME fPage1 = ""
        c-lote:SCREEN-VALUE IN FRAME fPage1         = "".

EMPTY TEMP-TABLE tt-ficha.
EMPTY TEMP-TABLE tt-exam-ficha.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

