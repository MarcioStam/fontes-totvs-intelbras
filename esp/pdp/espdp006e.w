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
{include/i-prgvrs.i espdp006e 1.12.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i espdp006e mft}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        espdp006e
&GLOBAL-DEFINE Version        1.12.00.000

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Sele‡Æo

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   i-orig-mercad           fi-Estabel-ini          fi-Estabel-fim          i-sit-cred              fi-Atendente-ini        ~
                              fi-Atendente-fim        cb-unid-negoc           fi-Atendente-mestre-ini fi-Atendente-mestre-fim ~
                              fi-Cod-repres-ini       fi-Cod-Repres-fim       it-codigo               fi-dt-entrega-ini       ~
                              fi-dt-entrega-fim       br-EstabDepos           fi-nr-pedcli-ini        fi-nr-pedcli-fim        ~
                              fi-dt-implant-ini       fi-dt-implant-fim       fi-cond-pagto-ini       fi-Cond-pagto-fim       ~
                              fi-prioridade-ini       fi-prioridade-fim       fi-cod-emitente-ini     fi-Cod-emitente-fim     tg-entregaFutura tg-parc-minima tg-alocado ~
                              
&GLOBAL-DEFINE page2Widgets   

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-unid-negoc AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-estab-depos NO-UNDO                                  
    FIELD cod-estabel LIKE estabelec.cod-estabel
    FIELD cod-depos   LIKE deposito.cod-depos.

/* Parameters Definitions ---                                           */
DEFINE INPUT-OUTPUT PARAM pEstabel-ini    LIKE ped-venda.cod-estabel         . 
DEFINE INPUT-OUTPUT PARAM pEstabel-fim    LIKE ped-venda.cod-estabel         . 
DEFINE INPUT-OUTPUT PARAM pAtendente-ini  LIKE ped-venda.tp-pedido           . 
DEFINE INPUT-OUTPUT PARAM pAtendente-fim  LIKE ped-venda.tp-pedido           . 
DEFINE INPUT-OUTPUT PARAM pRepres-ini     LIKE repres.cod-rep                . 
DEFINE INPUT-OUTPUT PARAM pRepres-fim     LIKE repres.cod-rep                . 
DEFINE INPUT-OUTPUT PARAM pEntrega-ini    LIKE ped-item.dt-entrega           . 
DEFINE INPUT-OUTPUT PARAM pEntrega-fim    LIKE ped-item.dt-entrega           . 
DEFINE INPUT-OUTPUT PARAM pPedido-ini     LIKE ped-venda.nr-pedcli           . 
DEFINE INPUT-OUTPUT PARAM pPedido-fim     LIKE ped-venda.nr-pedcli           . 
DEFINE INPUT-OUTPUT PARAM pImpPed-ini     LIKE ped-venda.dt-implant          . 
DEFINE INPUT-OUTPUT PARAM pImpPed-fim     LIKE ped-venda.dt-implant          . 
DEFINE INPUT-OUTPUT PARAM pCond-ini       LIKE ped-venda.cod-cond-pag        . 
DEFINE INPUT-OUTPUT PARAM pCond-fim       LIKE ped-venda.cod-cond-pag        . 
DEFINE INPUT-OUTPUT PARAM pPrior-ini      LIKE ped-venda.cod-priori          . 
DEFINE INPUT-OUTPUT PARAM pPrior-fim      LIKE ped-venda.cod-priori          . 
DEFINE INPUT-OUTPUT PARAM poperMestreIni  LIKE mgesp.atendente.oper-mestre  . 
DEFINE INPUT-OUTPUT PARAM poperMestreFim  LIKE mgesp.atendente.oper-mestre  . 
DEFINE INPUT-OUTPUT PARAM pCodEmite-ini   AS INTEGER  FORMAT '>>>>>>>>9'     . 
DEFINE INPUT-OUTPUT PARAM pCodEmite-fim   AS INTEGER  FORMAT '>>>>>>>>9'     . 
DEFINE INPUT-OUTPUT PARAM pItCodigo       AS CHARACTER                       . 
DEFINE INPUT-OUTPUT PARAM pUnid-Neg       LIKE unid-negoc.cod-unid-negoc     . 
DEFINE INPUT-OUTPUT PARAM pCodSitAval     AS CHARACTER                       . 
DEFINE INPUT-OUTPUT PARAM pEntFutura      AS LOGICAL                         . 
DEFINE INPUT-OUTPUT PARAM pOrig-mercad    AS INTEGER INITIAL 1 NO-UNDO.
DEFINE INPUT-OUTPUT PARAM pParcMinima     AS LOGICAL NO-UNDO.
DEFINE INPUT-OUTPUT PARAM pPedAlocado     AS LOGICAL NO-UNDO.
DEFINE OUTPUT       PARAM pAbreQuery      AS LOGICAL                         . 
DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-estab-depos.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-EstabDepos

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-estab-depos

/* Definitions for BROWSE br-EstabDepos                                 */
&Scoped-define FIELDS-IN-QUERY-br-EstabDepos tt-estab-depos.cod-estabel tt-estab-depos.cod-depos   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-EstabDepos tt-estab-depos.cod-depos   
&Scoped-define ENABLED-TABLES-IN-QUERY-br-EstabDepos tt-estab-depos
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br-EstabDepos tt-estab-depos
&Scoped-define SELF-NAME br-EstabDepos
&Scoped-define QUERY-STRING-br-EstabDepos FOR EACH tt-estab-depos     WHERE tt-estab-depos.cod-estabel >= fi-Estabel-ini:SCREEN-VALUE IN FRAME fPage1       AND tt-estab-depos.cod-estabel <= fi-Estabel-fim:SCREEN-VALUE IN FRAME fPage1 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-EstabDepos OPEN QUERY {&SELF-NAME} FOR EACH tt-estab-depos     WHERE tt-estab-depos.cod-estabel >= fi-Estabel-ini:SCREEN-VALUE IN FRAME fPage1       AND tt-estab-depos.cod-estabel <= fi-Estabel-fim:SCREEN-VALUE IN FRAME fPage1 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-EstabDepos tt-estab-depos
&Scoped-define FIRST-TABLE-IN-QUERY-br-EstabDepos tt-estab-depos


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-br-EstabDepos}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar IMAGE-21 IMAGE-22 ~
IMAGE-23 IMAGE-24 btQueryJoins btReportsJoins btExit btHelp btOK btCancel ~
btHelp2 

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

DEFINE IMAGE IMAGE-21
     FILENAME "image/im-fir.bmp":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "image/im-las.bmp":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-23
     FILENAME "image/im-fir.bmp":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-24
     FILENAME "image/im-las.bmp":U
     SIZE 4 BY .88.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE cb-unid-negoc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Un. Neg." 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 17 BY 1 NO-UNDO.

DEFINE VARIABLE i-sit-cred AS CHARACTER FORMAT "X(256)":U 
     LABEL "Sit. Cred." 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "NÆo Avaliado","Avaliado","Aprovado","NÆo Aprovado","Pendente Inf","Todos" 
     DROP-DOWN-LIST
     SIZE 17 BY 1 NO-UNDO.

DEFINE VARIABLE fi-Atendente-fim AS CHARACTER FORMAT "X(2)":U INITIAL "00" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-Atendente-ini AS CHARACTER FORMAT "X(2)":U INITIAL "0" 
     LABEL "Atendente" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-Atendente-mestre-fim AS INTEGER FORMAT ">9":U INITIAL 99 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-Atendente-mestre-ini AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Atendente Mestre" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-emitente-fim AS INTEGER FORMAT ">>>>>>>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-emitente-ini AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-Cod-Repres-fim AS INTEGER FORMAT ">>>>9":U INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fi-Cod-repres-ini AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "Representante" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-Cond-pagto-fim AS INTEGER FORMAT ">>9":U INITIAL 999 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cond-pagto-ini AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Cond Pagto" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dt-entrega-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/2999 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dt-entrega-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/1900 
     LABEL "Prev.Fatur" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dt-implant-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/2999 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dt-implant-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/1900 
     LABEL "Dt.Implanta‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-Estabel-fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-Estabel-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nr-pedcli-fim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nr-pedcli-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Pedido Cliente" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-prioridade-fim AS INTEGER FORMAT "99":U INITIAL 1 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE fi-prioridade-ini AS INTEGER FORMAT "99":U INITIAL 1 
     LABEL "Prioridade" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE it-codigo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir.bmp":U
     SIZE 4 BY 1.

DEFINE IMAGE IMAGE-10
     FILENAME "image/im-las.bmp":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image/im-fir.bmp":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image/im-las.bmp":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image/im-fir.bmp":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image/im-las.bmp":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image/im-fir.bmp":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image/im-las.bmp":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-17
     FILENAME "image/im-fir.bmp":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "image/im-las.bmp":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-19
     FILENAME "image/im-fir.bmp":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las.bmp":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-20
     FILENAME "image/im-las.bmp":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image/im-fir.bmp":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image/im-las.bmp":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image/im-fir.bmp":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image/im-las.bmp":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image/im-fir.bmp":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image/im-las.bmp":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image/im-fir.bmp":U
     SIZE 4 BY .88.

DEFINE VARIABLE i-orig-mercad AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Estab Intelbras", 1,
"Deposito Entreposto", 2
     SIZE 44 BY .71 NO-UNDO.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83.57 BY 11.92.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83.57 BY 1.5.

DEFINE VARIABLE tg-alocado AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.14 BY .83 NO-UNDO.

DEFINE VARIABLE tg-entregaFutura AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.43 BY .88 NO-UNDO.

DEFINE VARIABLE tg-parc-minima AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-EstabDepos FOR 
      tt-estab-depos SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-EstabDepos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-EstabDepos wWindow _FREEFORM
  QUERY br-EstabDepos NO-LOCK DISPLAY
      tt-estab-depos.cod-estabel 
      tt-estab-depos.cod-depos 
  ENABLE
      tt-estab-depos.cod-depos
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 23.86 BY 6.21
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     btOK AT ROW 17.63 COL 2
     btCancel AT ROW 17.63 COL 13
     btHelp2 AT ROW 17.63 COL 80
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 17.42 COL 1
     IMAGE-21 AT ROW 10.5 COL 38.43 WIDGET-ID 42
     IMAGE-22 AT ROW 10.5 COL 34.43 WIDGET-ID 40
     IMAGE-23 AT ROW 10.5 COL 38.43 WIDGET-ID 48
     IMAGE-24 AT ROW 10.5 COL 34.43 WIDGET-ID 50
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.14 BY 18.04
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     i-orig-mercad AT ROW 1.75 COL 15.86 NO-LABEL WIDGET-ID 124
     i-sit-cred AT ROW 3.08 COL 62 COLON-ALIGNED WIDGET-ID 52
     fi-Estabel-ini AT ROW 3.25 COL 14 COLON-ALIGNED WIDGET-ID 72
     fi-Estabel-fim AT ROW 3.25 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 70
     cb-unid-negoc AT ROW 4.04 COL 62 COLON-ALIGNED WIDGET-ID 98
     fi-Atendente-ini AT ROW 4.25 COL 14 COLON-ALIGNED WIDGET-ID 2
     fi-Atendente-fim AT ROW 4.25 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     tg-entregaFutura AT ROW 4.79 COL 79 WIDGET-ID 94
     fi-Atendente-mestre-ini AT ROW 5.25 COL 14 COLON-ALIGNED WIDGET-ID 56
     fi-Atendente-mestre-fim AT ROW 5.25 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 54
     tg-parc-minima AT ROW 5.71 COL 79 WIDGET-ID 134
     fi-Cod-repres-ini AT ROW 6.25 COL 14 COLON-ALIGNED WIDGET-ID 80
     fi-Cod-Repres-fim AT ROW 6.25 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 78
     tg-alocado AT ROW 6.5 COL 79 WIDGET-ID 138
     fi-dt-entrega-ini AT ROW 7.25 COL 14 COLON-ALIGNED WIDGET-ID 84
     fi-dt-entrega-fim AT ROW 7.25 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 82
     it-codigo AT ROW 7.29 COL 62 COLON-ALIGNED WIDGET-ID 96
     fi-nr-pedcli-ini AT ROW 8.25 COL 14 COLON-ALIGNED WIDGET-ID 92
     fi-nr-pedcli-fim AT ROW 8.25 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 90
     br-EstabDepos AT ROW 8.33 COL 57.14 WIDGET-ID 200
     fi-dt-implant-ini AT ROW 9.25 COL 14 COLON-ALIGNED WIDGET-ID 88
     fi-dt-implant-fim AT ROW 9.25 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 86
     fi-cond-pagto-ini AT ROW 10.25 COL 14 COLON-ALIGNED WIDGET-ID 22
     fi-Cond-pagto-fim AT ROW 10.25 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     fi-prioridade-ini AT ROW 11.25 COL 14 COLON-ALIGNED WIDGET-ID 30
     fi-prioridade-fim AT ROW 11.25 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     fi-cod-emitente-ini AT ROW 12.25 COL 14 COLON-ALIGNED HELP
          "C¢digo do emitente" WIDGET-ID 38
     fi-cod-emitente-fim AT ROW 12.25 COL 38 COLON-ALIGNED HELP
          "C¢digo do emitente" NO-LABEL WIDGET-ID 36
     "Somente Ped Aloc" VIEW-AS TEXT
          SIZE 13 BY .54 TOOLTIP "Somente pedidos alocados" AT ROW 6.58 COL 65.29 WIDGET-ID 140
     "Origem de Mercadoria" VIEW-AS TEXT
          SIZE 16 BY .54 AT ROW 1.04 COL 2.57 WIDGET-ID 130
     "Entrega Futura" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 5 COL 68.43 WIDGET-ID 132
     "Somente abaixo Parc Minima" VIEW-AS TEXT
          SIZE 19.86 BY .54 TOOLTIP "Somente abaixo Parc Minima" AT ROW 5.75 COL 58.57 WIDGET-ID 136
     IMAGE-1 AT ROW 6.29 COL 35 WIDGET-ID 4
     IMAGE-2 AT ROW 6.29 COL 31 WIDGET-ID 6
     IMAGE-3 AT ROW 7.29 COL 35 WIDGET-ID 8
     IMAGE-4 AT ROW 7.29 COL 31 WIDGET-ID 10
     IMAGE-5 AT ROW 8.29 COL 35 WIDGET-ID 12
     IMAGE-6 AT ROW 8.29 COL 31 WIDGET-ID 14
     IMAGE-7 AT ROW 9.29 COL 35 WIDGET-ID 16
     IMAGE-8 AT ROW 9.29 COL 31 WIDGET-ID 18
     IMAGE-9 AT ROW 10.29 COL 35 WIDGET-ID 24
     IMAGE-10 AT ROW 10.29 COL 31 WIDGET-ID 26
     IMAGE-11 AT ROW 11.29 COL 35 WIDGET-ID 32
     IMAGE-12 AT ROW 11.29 COL 31 WIDGET-ID 34
     IMAGE-13 AT ROW 12.29 COL 35 WIDGET-ID 42
     IMAGE-14 AT ROW 12.29 COL 31 WIDGET-ID 40
     IMAGE-15 AT ROW 4.29 COL 35 WIDGET-ID 46
     IMAGE-16 AT ROW 4.29 COL 31 WIDGET-ID 48
     IMAGE-17 AT ROW 5.29 COL 35 WIDGET-ID 58
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.75
         SIZE 84.43 BY 14.25
         FONT 1 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fPage1
     IMAGE-18 AT ROW 5.29 COL 31 WIDGET-ID 60
     IMAGE-19 AT ROW 3.25 COL 35 WIDGET-ID 74
     IMAGE-20 AT ROW 3.25 COL 31 WIDGET-ID 76
     RECT-14 AT ROW 2.83 COL 1.29 WIDGET-ID 100
     RECT-15 AT ROW 1.25 COL 1.29 WIDGET-ID 102
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.75
         SIZE 84.43 BY 14.25
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
         HEIGHT             = 18.04
         WIDTH              = 90.14
         MAX-HEIGHT         = 18.04
         MAX-WIDTH          = 90.14
         VIRTUAL-HEIGHT     = 18.04
         VIRTUAL-WIDTH      = 90.14
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
/* BROWSE-TAB br-EstabDepos fi-nr-pedcli-fim fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-EstabDepos
/* Query rebuild information for BROWSE br-EstabDepos
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-estab-depos
    WHERE tt-estab-depos.cod-estabel >= fi-Estabel-ini:SCREEN-VALUE IN FRAME fPage1
      AND tt-estab-depos.cod-estabel <= fi-Estabel-fim:SCREEN-VALUE IN FRAME fPage1 NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "mgesp.ponto-programa.cod-programa = 'espdp006'
 AND mgesp.ponto-programa.ponto = 14"
     _Query            is OPENED
*/  /* BROWSE br-EstabDepos */
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


&Scoped-define BROWSE-NAME br-EstabDepos
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME br-EstabDepos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-EstabDepos wWindow
ON VALUE-CHANGED OF br-EstabDepos IN FRAME fPage1
DO:
    DEFINE VARIABLE l-wms-estab-ativo AS LOGICAL NO-UNDO.

    IF tt-estab-depos.cod-depos:SCREEN-VALUE IN BROWSE br-EstabDepos <> '' THEN DO:
        
        FIND CURRENT tt-estab-depos EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL tt-estab-depos THEN DO:
            FIND FIRST deposito WHERE deposito.cod-depos = tt-estab-depos.cod-depos:SCREEN-VALUE IN BROWSE br-EstabDepos NO-LOCK NO-ERROR.
            IF AVAIL deposito THEN DO:
                RUN esp/wmp/eswmpapi006.p( INPUT tt-estab-depos.cod-estabel, OUTPUT l-wms-estab-ativo).
                IF  l-wms-estab-ativo 
                AND deposito.cod-depos = 'EXP' THEN DO:
                    run utp/ut-msgs.p (input "show":U, input 17006, input "Dep¢sito Inv lido!~~Dep¢sito informado nÆo pode ser utilizado no estabelecimento 104.":U).
                    apply "ENTRY":U to tt-estab-depos.cod-depos in BROWSE br-EstabDepos.
                    RETURN NO-APPLY.
                END.
                ASSIGN tt-estab-depos.cod-depos = tt-estab-depos.cod-depos:SCREEN-VALUE IN BROWSE br-EstabDepos.
            END.
            ELSE DO:
                run utp/ut-msgs.p (input "show":U, input 17006, input "Dep¢sito Inv lido!~~Dep¢sito informado nÆo existe.":U).
                apply "ENTRY":U to tt-estab-depos.cod-depos in BROWSE br-EstabDepos.
                RETURN NO-APPLY.
            END.
        END.
    END.

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
    ASSIGN pAbreQuery = NO.

    DO WITH FRAME fPage1:
        FOR EACH mgesp.ponto-programa NO-LOCK
            WHERE ponto-programa.nome-programa = "espdp006"
              AND ponto-programa.ponto         = 10,  
             EACH mgesp.conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

            IF (fi-atendente-ini >  entry(2,conteudo-programa.conteudo, ";")     or
                fi-atendente-fim <  entry(1,conteudo-programa.conteudo, ";")) THEN .
            ELSE DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "Existe execu‡Æo de Aloca‡Æo Autom tica para atendente do pedido, usuario : " +  entry(3,conteudo-programa.conteudo, ";") ).     
                 RETURN "NOK":U.
            END.
        END.

        FOR EACH tt-estab-depos     
           WHERE tt-estab-depos.cod-estabel >= fi-Estabel-ini:SCREEN-VALUE IN FRAME fPage1       
             AND tt-estab-depos.cod-estabel <= fi-Estabel-fim:SCREEN-VALUE IN FRAME fPage1:
            FOR FIRST mgesp.ponto-programa                                            
                WHERE ponto-programa.nome-programa = "espdp006"                        
                  AND ponto-programa.ponto = 5:

                IF NOT CAN-FIND (FIRST conteudo-programa 
                                 WHERE conteudo-programa.cod-programa      = ponto-programa.cod-programa
                                   AND ENTRY(2,conteudo-programa.conteudo) = c-seg-usuario
                                   AND ENTRY(1,conteudo-programa.conteudo) = tt-estab-depos.cod-depos) THEN DO:

                    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                       INPUT 17006,
                                       INPUT "Usu rio " + c-seg-usuario + " sem permissÆo para alocar no dep¢sito " +  tt-estab-depos.cod-depos).     
                 RETURN "NOK":U.
                END.
            END.


            FIND FIRST deposito WHERE deposito.cod-depos = tt-estab-depos.cod-depos NO-LOCK NO-ERROR.

            IF AVAIL deposito THEN DO:
               IF i-orig-mercad:SCREEN-VALUE IN FRAME fPage1 = '1' THEN DO: //ESTAB INTELBRAS
                  IF deposito.ind-tipo-dep = 2 THEN DO: //DEPOSITO EXTERNO
                     RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                        INPUT 17006,
                                        INPUT "Estabelecimento Intelbras nao permite utilizar deposito externo"  ).

                     APPLY 'entry' TO tt-estab-depos.cod-depos IN BROWSE br-EstabDepos.

                     RETURN "NOK":U.
                  END.
               END.
               ELSE DO: //DEPOSITO ENTREPOSTO
                  IF deposito.ind-tipo-dep = 1 THEN DO: //DEPOSITO INTERNO
                     RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                        INPUT 17006,
                                        INPUT "Deposito Entreposto nao permite utilizar deposito interno" ).

                     APPLY 'entry' TO tt-estab-depos.cod-depos IN BROWSE br-EstabDepos.

                     RETURN "NOK":U.
                  END.
               END.
            END.
        END.

    END.

    
    ASSIGN pEstabel-ini   = INPUT FRAME fPage1 fi-estabel-ini
           pEstabel-fim   = INPUT FRAME fPage1 fi-estabel-fim
           pAtendente-ini = INPUT FRAME fPage1 fi-atendente-ini
           pAtendente-fim = INPUT FRAME fPage1 fi-atendente-fim
           pRepres-ini    = INPUT FRAME fPage1 fi-cod-repres-ini  
           pRepres-fim    = INPUT FRAME fPage1 fi-cod-repres-fim  
           pEntrega-ini   = INPUT FRAME fPage1 fi-dt-entrega-ini
           pEntrega-fim   = INPUT FRAME fPage1 fi-dt-entrega-fim
           pPedido-ini    = INPUT FRAME fPage1 fi-nr-pedcli-ini
           pPedido-fim    = INPUT FRAME fPage1 fi-nr-pedcli-fim
           pImpPed-ini    = INPUT FRAME fPage1 fi-dt-implant-ini
           pImpPed-fim    = INPUT FRAME fPage1 fi-dt-implant-fim
           pCond-ini      = INPUT FRAME fPage1 fi-cond-pagto-ini
           pCond-fim      = INPUT FRAME fPage1 fi-cond-pagto-fim
           pPrior-ini     = INPUT FRAME fPage1 fi-prioridade-ini
           pPrior-fim     = INPUT FRAME fPage1 fi-prioridade-fim
           poperMestreIni = INPUT FRAME fPage1 fi-atendente-mestre-ini
           poperMestreFim = INPUT FRAME fPage1 fi-atendente-mestre-fim
           pCodEmite-ini  = INPUT FRAME fPage1 fi-cod-emitente-ini
           pCodEmite-fim  = INPUT FRAME fPage1 fi-cod-emitente-fim
           pItCodigo      = INPUT FRAME fPage1 it-codigo
           pUnid-Neg      = INPUT FRAME fPage1 cb-unid-negoc
           pCodSitAval    = INPUT FRAME fPage1 i-sit-cred
           pEntFutura     = INPUT FRAME fPage1 tg-entregaFutura
           pOrig-mercad   = INPUT FRAME fPage1 i-orig-mercad
           pParcMinima    = INPUT FRAME fpage1 tg-parc-minima
           pPedAlocado    = INPUT FRAME fpage1 tg-alocado.

     ASSIGN pAbreQuery = YES.
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
&Scoped-define SELF-NAME fi-Atendente-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Atendente-fim wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-Atendente-fim IN FRAME fPage1
DO:

/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-Atendente-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Atendente-ini wWindow
ON ENTRY OF fi-Atendente-ini IN FRAME fPage1 /* Atendente */
DO:
  
    FIND FIRST mgesp.ponto-programa NO-LOCK
        WHERE ponto-programa.nome-programa = "pd4000"
          AND ponto-programa.ponto         = 7 NO-ERROR.
    IF AVAIL mgesp.ponto-programa THEN DO:
        IF NOT CAN-FIND(FIRST mgesp.conteudo-programa NO-LOCK
                WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                  AND conteudo-programa.conteudo     = c-seg-usuario) THEN DO:
        END. /* IF NOT CAN-FIND(FIRST mgesp.conteudo-programa NO-LOCK */
    END. /* IF AVAIL mgesp.ponto-programa THEN DO: */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Atendente-ini wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-Atendente-ini IN FRAME fPage1 /* Atendente */
DO:

/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-Atendente-mestre-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Atendente-mestre-fim wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-Atendente-mestre-fim IN FRAME fPage1
DO:

/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-Atendente-mestre-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Atendente-mestre-ini wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-Atendente-mestre-ini IN FRAME fPage1 /* Atendente Mestre */
DO:

/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-emitente-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-emitente-ini wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-cod-emitente-ini IN FRAME fPage1 /* Cliente */
DO:

/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-Cod-repres-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Cod-repres-ini wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-Cod-repres-ini IN FRAME fPage1 /* Representante */
DO:

/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cond-pagto-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cond-pagto-ini wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-cond-pagto-ini IN FRAME fPage1 /* Cond Pagto */
DO:

/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-Estabel-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Estabel-fim wWindow
ON LEAVE OF fi-Estabel-fim IN FRAME fPage1
DO:
  {&OPEN-QUERY-br-EstabDepos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Estabel-fim wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-Estabel-fim IN FRAME fPage1
DO:

/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-Estabel-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Estabel-ini wWindow
ON ENTRY OF fi-Estabel-ini IN FRAME fPage1 /* Estabelecimento */
DO:
 IF CAN-FIND (FIRST tt-estab-depos) THEN

 {&open-query-br-EstabDepos}
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Estabel-ini wWindow
ON LEAVE OF fi-Estabel-ini IN FRAME fPage1 /* Estabelecimento */
DO:
  {&OPEN-QUERY-br-EstabDepos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Estabel-ini wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-Estabel-ini IN FRAME fPage1 /* Estabelecimento */
DO:
    RUN cria-ttBrowser.


/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-orig-mercad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-orig-mercad wWindow
ON VALUE-CHANGED OF i-orig-mercad IN FRAME fPage1
DO:
   FOR EACH  tt-estab-depos: DELETE  tt-estab-depos. END.
   RUN pi-CriaTT.
   {&OPEN-QUERY-br-EstabDepos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-codigo wWindow
ON LEAVE OF it-codigo IN FRAME fPage1 /* Item */
DO:

    FIND FIRST ITEM WHERE ITEM.it-codigo = it-codigo:SCREEN-VALUE IN FRAME fPage1 NO-LOCK NO-ERROR.
    IF NOT AVAIL ITEM THEN DO:
        run utp/ut-msgs.p (input "show":U, input 17006, input "Item Inv lido!~~Item informado nÆo existe.":U).
        apply "ENTRY":U to it-codigo IN FRAME fPage1.
        RETURN NO-APPLY.
    END.
  
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
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

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
    
    
    DO WITH FRAME fPage1:
        IF cb-unid-negoc:SCREEN-VALUE = ? OR cb-unid-negoc:SCREEN-VALUE = "":U OR cb-unid-negoc:LIST-ITEMS = ? THEN DO:
            FOR EACH unid-negoc NO-LOCK:
                cb-unid-negoc:ADD-LAST (unid-negoc.cod-unid-negoc).
            END.

            IF INDEX(cb-unid-negoc:LIST-ITEMS, cb-unid-negoc) = 0 OR
               INDEX(cb-unid-negoc:LIST-ITEMS, cb-unid-negoc) = ? THEN
                ASSIGN cb-unid-negoc = ENTRY(1, cb-unid-negoc:LIST-ITEMS, ",":U).

        END.

        ASSIGN fi-Estabel-ini         :SCREEN-VALUE = STRING(pEstabel-ini  ) 
               fi-Estabel-fim         :SCREEN-VALUE = STRING(pEstabel-fim  ) 
               fi-Atendente-ini       :SCREEN-VALUE = STRING(pAtendente-ini) 
               fi-Atendente-fim       :SCREEN-VALUE = STRING(pAtendente-fim) 
               fi-cod-Repres-ini      :SCREEN-VALUE = STRING(pRepres-ini   ) 
               fi-cod-Repres-fim      :SCREEN-VALUE = STRING(pRepres-fim   ) 
               fi-dt-Entrega-ini      :SCREEN-VALUE = STRING(pEntrega-ini  ) 
               fi-dt-Entrega-fim      :SCREEN-VALUE = STRING(pEntrega-fim  ) 
               fi-nr-pedcli-ini       :SCREEN-VALUE = STRING(pPedido-ini   ) 
               fi-nr-pedcli-fim       :SCREEN-VALUE = STRING(pPedido-fim   ) 
               fi-dt-implant-ini      :SCREEN-VALUE = STRING(pImpPed-ini   ) 
               fi-dt-implant-fim      :SCREEN-VALUE = STRING(pImpPed-fim   ) 
               fi-cond-pagto-ini      :SCREEN-VALUE = STRING(pCond-ini     ) 
               fi-cond-pagto-fim      :SCREEN-VALUE = STRING(pCond-fim     ) 
               fi-prioridade-ini      :SCREEN-VALUE = STRING(pPrior-ini    ) 
               fi-prioridade-fim      :SCREEN-VALUE = STRING(pPrior-fim    ) 
               fi-Atendente-mestre-ini:SCREEN-VALUE = STRING(poperMestreIni) 
               fi-Atendente-mestre-fim:SCREEN-VALUE = STRING(poperMestreFim) 
               fi-cod-emitente-ini    :SCREEN-VALUE = STRING(pCodEmite-ini ) 
               fi-cod-emitente-fim    :SCREEN-VALUE = STRING(pCodEmite-fim ) 
               it-codigo              :SCREEN-VALUE = STRING(pItCodigo     ) 
               cb-unid-negoc          :SCREEN-VALUE = STRING(pUnid-Neg     ) 
               tg-entregaFutura       :CHECKED      = pEntFutura  
               i-orig-mercad          :SCREEN-VALUE = string(pOrig-mercad)
               tg-parc-minima         :CHECKED      = pParcMinima
               tg-alocado             :CHECKED      = pPedAlocado.

    END. /* DO WITH FRAME fPage1: */

    RUN pi-CriaTT.

    

    APPLY 'entry' TO fi-Estabel-ini IN FRAME fPage1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-CriaTT wWindow 
PROCEDURE pi-CriaTT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR FIRST mgesp.ponto-programa
    WHERE ponto-programa.nome-programa = "espdp006"
      AND ponto-programa.ponto = 14,
    EACH mgesp.conteudo-programa NO-LOCK
    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

    FIND FIRST deposito WHERE deposito.cod-depos = ENTRY(2,conteudo-programa.conteudo) NO-LOCK NO-ERROR.

    IF NOT AVAIL deposito THEN NEXT.

    IF i-orig-mercad:SCREEN-VALUE IN FRAME fPage1 = '1' THEN DO: //ESTAB INTELBRAS
       IF deposito.ind-tipo-dep = 2 THEN //DEPOSITO EXTERNO
          NEXT. 
    END.
    ELSE DO: //DEPOSITO ENTREPOSTO
       IF deposito.ind-tipo-dep = 1 THEN //DEPOSITO INTERNO
          NEXT.
    END.
    

    FIND FIRST tt-estab-depos
         WHERE tt-estab-depos.cod-estabel = ENTRY(1,conteudo-programa.conteudo) EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAIL tt-estab-depos THEN DO:
       CREATE tt-estab-depos.
       ASSIGN tt-estab-depos.cod-estabel = ENTRY(1,conteudo-programa.conteudo)
              tt-estab-depos.cod-depos = ENTRY(2,conteudo-programa.conteudo).
    END.
    

END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

