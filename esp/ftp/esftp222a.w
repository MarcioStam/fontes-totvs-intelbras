&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadsim 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i wso0004b 2.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
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

{esp/ftp/esftp222.i}

DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-filtro.

    /*
DEF INPUT-OUTPUT PARAM p-cod-estabel-ini        AS CHAR.
DEF INPUT-OUTPUT PARAM p-cod-estabel-fim        AS CHAR.
DEF INPUT-OUTPUT PARAM p-dt-implant-ini         AS DATE.
DEF INPUT-OUTPUT PARAM p-dt-implant-fim         AS DATE.
DEF INPUT-OUTPUT PARAM p-cod-emitente-ini       AS INT.
DEF INPUT-OUTPUT PARAM p-cod-emitente-fim       AS INT.
DEF INPUT-OUTPUT PARAM p-nr-pedido-ini          AS INT.
DEF INPUT-OUTPUT PARAM p-nr-pedido-fim          AS INT.
                                                
DEF INPUT-OUTPUT PARAM p-tg-aberto              AS LOG.
DEF INPUT-OUTPUT PARAM p-tg-atendido-parc       AS LOG.
DEF INPUT-OUTPUT PARAM p-tg-atendido-tot        AS LOG.
DEF INPUT-OUTPUT PARAM p-tg-pendente            AS LOG.
DEF INPUT-OUTPUT PARAM p-tg-suspenso            AS LOG.
DEF INPUT-OUTPUT PARAM p-tg-cancelado           AS LOG.

DEF INPUT-OUTPUT PARAM p-tg-aguardando-lib      AS LOG.
DEF INPUT-OUTPUT PARAM p-tg-aguardando-ger-fci  AS LOG.
DEF INPUT-OUTPUT PARAM p-tg-aguardando-sep      AS LOG.
DEF INPUT-OUTPUT PARAM p-tg-lib-fat             AS LOG.
DEF INPUT-OUTPUT PARAM p-tg-faturado            AS LOG.
                                                
DEF INPUT-OUTPUT PARAM p-tg-aloc-pendente       AS LOG.
DEF INPUT-OUTPUT PARAM p-tg-aloc-bloqueada      AS LOG.
DEF INPUT-OUTPUT PARAM p-tg-aloc-parcial        AS LOG.
DEF INPUT-OUTPUT PARAM p-tg-aloc-finalizada     AS LOG.

DEF OUTPUT PARAM l-openquery                    AS LOG.

ASSIGN l-openquery = NO.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button IMAGE-1 IMAGE-2 IMAGE-7 IMAGE-8 ~
IMAGE-9 IMAGE-10 IMAGE-13 IMAGE-14 RECT-9 RECT-10 RECT-11 RECT-12 RECT-13 ~
RECT-14 c-cod-estabel-ini c-cod-estabel-fim dt-implant-ini dt-implant-fim ~
i-nr-ordem-ini i-nr-ordem-fim i-nr-pedido-ini i-nr-pedido-fim tg-aberto ~
tg-pendente tg-atendido-parc tg-suspenso tg-atendido-tot tg-cancelado ~
tg-aguardando-lib tg-aguardando-ger-fci tg-lib-fat tg-aguardando-sep ~
tg-faturado tg-nf-calculada tg-nf-impressa tg-nf-confirmada ~
tg-aloc-pendente tg-aloc-parcial tg-aloc-bloqueada tg-aloc-Finalizada ~
cod-depos-alocacao bt-ok bt-cancela bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS c-cod-estabel-ini c-cod-estabel-fim ~
dt-implant-ini dt-implant-fim i-nr-ordem-ini i-nr-ordem-fim i-nr-pedido-ini ~
i-nr-pedido-fim tg-aberto tg-pendente tg-atendido-parc tg-suspenso ~
tg-atendido-tot tg-cancelado tg-aguardando-lib tg-aguardando-ger-fci ~
tg-lib-fat tg-aguardando-sep tg-faturado tg-nf-calculada tg-nf-impressa ~
tg-nf-confirmada tg-aloc-pendente tg-aloc-parcial tg-aloc-bloqueada ~
tg-aloc-Finalizada cod-depos-alocacao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
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

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE c-cod-estabel-fim AS CHARACTER FORMAT "X(5)":U INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estabel-ini AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE cod-depos-alocacao AS CHARACTER FORMAT "X(03)":U 
     LABEL "Dep Aloca‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 TOOLTIP "Dep¢sito Aloca‡Æo" NO-UNDO.

DEFINE VARIABLE dt-implant-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE dt-implant-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Implanta‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-ordem-fim AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-ordem-ini AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Ordem" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-pedido-fim AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-pedido-ini AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Pedido" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 3.46.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 4.5.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 2.67.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 1.5.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 2.67.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 3.46.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 78 BY 1.38
     BGCOLOR 7 .

DEFINE VARIABLE tg-aberto AS LOGICAL INITIAL no 
     LABEL "Aberto" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-aguardando-ger-fci AS LOGICAL INITIAL no 
     LABEL "Aguardando Gera‡Æo FCI" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .83 NO-UNDO.

DEFINE VARIABLE tg-aguardando-lib AS LOGICAL INITIAL no 
     LABEL "Aguardando Lib. Financeira" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .83 NO-UNDO.

DEFINE VARIABLE tg-aguardando-sep AS LOGICAL INITIAL no 
     LABEL "Aguardando Separa‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .83 NO-UNDO.

DEFINE VARIABLE tg-aloc-bloqueada AS LOGICAL INITIAL no 
     LABEL "Bloqueada" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .83 NO-UNDO.

DEFINE VARIABLE tg-aloc-Finalizada AS LOGICAL INITIAL no 
     LABEL "Finalizada" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-aloc-parcial AS LOGICAL INITIAL no 
     LABEL "Parcial" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-aloc-pendente AS LOGICAL INITIAL no 
     LABEL "Pendente" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-atendido-parc AS LOGICAL INITIAL no 
     LABEL "Atendido Parcial" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .83 NO-UNDO.

DEFINE VARIABLE tg-atendido-tot AS LOGICAL INITIAL no 
     LABEL "Atendido Total" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83 NO-UNDO.

DEFINE VARIABLE tg-cancelado AS LOGICAL INITIAL no 
     LABEL "Cancelado" 
     VIEW-AS TOGGLE-BOX
     SIZE 12.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-faturado AS LOGICAL INITIAL no 
     LABEL "Faturado" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-lib-fat AS LOGICAL INITIAL no 
     LABEL "Liberado Faturamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.

DEFINE VARIABLE tg-nf-calculada AS LOGICAL INITIAL no 
     LABEL "Calculada" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-nf-confirmada AS LOGICAL INITIAL no 
     LABEL "Confirmada" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .83 NO-UNDO.

DEFINE VARIABLE tg-nf-impressa AS LOGICAL INITIAL no 
     LABEL "Impressa" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-pendente AS LOGICAL INITIAL no 
     LABEL "Pendente" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-suspenso AS LOGICAL INITIAL no 
     LABEL "Suspenso" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     c-cod-estabel-ini AT ROW 1.5 COL 17 COLON-ALIGNED WIDGET-ID 70
     c-cod-estabel-fim AT ROW 1.5 COL 50.86 COLON-ALIGNED NO-LABEL WIDGET-ID 68
     dt-implant-ini AT ROW 2.5 COL 17 COLON-ALIGNED WIDGET-ID 4
     dt-implant-fim AT ROW 2.5 COL 50.86 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     i-nr-ordem-ini AT ROW 3.5 COL 17 COLON-ALIGNED WIDGET-ID 36
     i-nr-ordem-fim AT ROW 3.5 COL 50.86 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     i-nr-pedido-ini AT ROW 4.5 COL 17 COLON-ALIGNED WIDGET-ID 28
     i-nr-pedido-fim AT ROW 4.5 COL 51 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     tg-aberto AT ROW 6.5 COL 19 WIDGET-ID 42
     tg-pendente AT ROW 6.5 COL 53 WIDGET-ID 48
     tg-atendido-parc AT ROW 7.5 COL 19 WIDGET-ID 44
     tg-suspenso AT ROW 7.5 COL 53 WIDGET-ID 50
     tg-atendido-tot AT ROW 8.5 COL 19 WIDGET-ID 46
     tg-cancelado AT ROW 8.5 COL 53 WIDGET-ID 52
     tg-aguardando-lib AT ROW 10.25 COL 19 WIDGET-ID 84
     tg-aguardando-ger-fci AT ROW 10.25 COL 53 WIDGET-ID 90
     tg-lib-fat AT ROW 11.13 COL 53 WIDGET-ID 88
     tg-aguardando-sep AT ROW 11.25 COL 19 WIDGET-ID 86
     tg-faturado AT ROW 12.13 COL 19 WIDGET-ID 92
     tg-nf-calculada AT ROW 14 COL 19 WIDGET-ID 98
     tg-nf-impressa AT ROW 14 COL 53 WIDGET-ID 106
     tg-nf-confirmada AT ROW 15 COL 19 WIDGET-ID 100
     tg-aloc-pendente AT ROW 17 COL 19 WIDGET-ID 126
     tg-aloc-parcial AT ROW 17 COL 53 WIDGET-ID 124
     tg-aloc-bloqueada AT ROW 18 COL 19 WIDGET-ID 120
     tg-aloc-Finalizada AT ROW 18 COL 53 WIDGET-ID 122
     cod-depos-alocacao AT ROW 19.5 COL 17 COLON-ALIGNED WIDGET-ID 112
     bt-ok AT ROW 21 COL 3
     bt-cancela AT ROW 21 COL 14
     bt-ajuda AT ROW 21 COL 68
     "Status Pedido" VIEW-AS TEXT
          SIZE 13 BY .67 AT ROW 5.75 COL 3.43 WIDGET-ID 58
     "Situa‡Æo Aloca‡Æo" VIEW-AS TEXT
          SIZE 13 BY .67 AT ROW 16.25 COL 3.43 WIDGET-ID 118
     "Eventos do Pedido" VIEW-AS TEXT
          SIZE 18.57 BY .67 AT ROW 9.5 COL 3.43 WIDGET-ID 80
     "Situa‡Æo Nota Fiscal" VIEW-AS TEXT
          SIZE 17.57 BY .67 AT ROW 13.25 COL 3.43 WIDGET-ID 96
     rt-button AT ROW 20.75 COL 2
     IMAGE-1 AT ROW 2.5 COL 33.86 WIDGET-ID 6
     IMAGE-2 AT ROW 2.5 COL 50 WIDGET-ID 8
     IMAGE-7 AT ROW 4.5 COL 33.86 WIDGET-ID 30
     IMAGE-8 AT ROW 4.5 COL 50 WIDGET-ID 32
     IMAGE-9 AT ROW 3.5 COL 33.86 WIDGET-ID 38
     IMAGE-10 AT ROW 3.5 COL 50 WIDGET-ID 40
     IMAGE-13 AT ROW 1.5 COL 33.86 WIDGET-ID 72
     IMAGE-14 AT ROW 1.5 COL 50 WIDGET-ID 74
     RECT-9 AT ROW 6.08 COL 2 WIDGET-ID 76
     RECT-10 AT ROW 9.83 COL 2 WIDGET-ID 78
     RECT-11 AT ROW 1.25 COL 2 WIDGET-ID 82
     RECT-12 AT ROW 13.58 COL 2 WIDGET-ID 94
     RECT-13 AT ROW 19.25 COL 2 WIDGET-ID 114
     RECT-14 AT ROW 16.58 COL 2 WIDGET-ID 116
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.14 ROW 1
         SIZE 79.57 BY 21.33 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-cadsim ASSIGN
         HIDDEN             = YES
         TITLE              = "Manuten‡Æo <Insira o complemento>"
         HEIGHT             = 21.21
         WIDTH              = 80.57
         MAX-HEIGHT         = 26
         MAX-WIDTH          = 116.14
         VIRTUAL-HEIGHT     = 26
         VIRTUAL-WIDTH      = 116.14
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
ASSIGN 
       bt-ajuda:POPUP-MENU IN FRAME f-cad       = MENU POPUP-MENU-bt-ajuda:HANDLE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
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


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-cadsim
ON CHOOSE OF bt-ok IN FRAME f-cad /* OK */
DO:
    ASSIGN  tt-filtro.cod-estabel-ini       = c-cod-estabel-ini:SCREEN-VALUE IN FRAME f-cad  
            tt-filtro.cod-estabel-fim       = c-cod-estabel-fim:SCREEN-VALUE IN FRAME f-cad
            tt-filtro.dt-implant-ini        = date(dt-implant-ini:SCREEN-VALUE IN FRAME f-cad)
            tt-filtro.dt-implant-fim        = date(dt-implant-fim:SCREEN-VALUE IN FRAME f-cad)
            tt-filtro.nr-ordem-ini          = int(i-nr-ordem-ini:SCREEN-VALUE IN FRAME f-cad) 
            tt-filtro.nr-ordem-fim          = int(i-nr-ordem-fim:SCREEN-VALUE IN FRAME f-cad)
            tt-filtro.nr-pedido-ini         = int(i-nr-pedido-ini:SCREEN-VALUE IN FRAME f-cad)  
            tt-filtro.nr-pedido-fim         = int(i-nr-pedido-fim:SCREEN-VALUE IN FRAME f-cad)
            tt-filtro.cod-depos-alocacao    = cod-depos-alocacao:SCREEN-VALUE IN FRAME f-cad
            tt-filtro.tg-aberto             = tg-aberto:CHECKED IN FRAME f-cad
            tt-filtro.tg-atendido-parc      = tg-atendido-parc:CHECKED IN FRAME f-cad
            tt-filtro.tg-atendido-tot       = tg-atendido-tot:CHECKED IN FRAME f-cad
            tt-filtro.tg-pendente           = tg-pendente:CHECKED IN FRAME f-cad
            tt-filtro.tg-suspenso           = tg-suspenso:CHECKED IN FRAME f-cad
            tt-filtro.tg-cancelado          = tg-cancelado:CHECKED IN FRAME f-cad
            tt-filtro.tg-aguardando-lib     = tg-aguardando-lib:CHECKED IN FRAME f-cad
            tt-filtro.tg-aguardando-ger-fci = tg-aguardando-ger-fci:CHECKED IN FRAME f-cad
            tt-filtro.tg-aguardando-sep     = tg-aguardando-sep:CHECKED IN FRAME f-cad
            tt-filtro.tg-lib-fat            = tg-lib-fat:CHECKED IN FRAME f-cad
            tt-filtro.tg-faturado           = tg-faturado:CHECKED IN FRAME f-cad
            tt-filtro.tg-aloc-pendente      = tg-aloc-pendente  :CHECKED IN FRAME f-cad
            tt-filtro.tg-aloc-bloqueada     = tg-aloc-bloqueada :CHECKED IN FRAME f-cad
            tt-filtro.tg-aloc-parcial       = tg-aloc-parcial   :CHECKED IN FRAME f-cad
            tt-filtro.tg-aloc-finalizada    = tg-aloc-finalizada:CHECKED IN FRAME f-cad
            tt-filtro.tg-nf-calculada       = tg-nf-calculada :CHECKED IN FRAME f-cad
            tt-filtro.tg-nf-confirmada      = tg-nf-confirmada   :CHECKED IN FRAME f-cad
            tt-filtro.tg-nf-impressa        = tg-nf-impressa:CHECKED IN FRAME f-cad

            tt-filtro.tg-openquery          = YES.

    APPLY "close":U TO THIS-PROCEDURE.
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
  DISPLAY c-cod-estabel-ini c-cod-estabel-fim dt-implant-ini dt-implant-fim 
          i-nr-ordem-ini i-nr-ordem-fim i-nr-pedido-ini i-nr-pedido-fim 
          tg-aberto tg-pendente tg-atendido-parc tg-suspenso tg-atendido-tot 
          tg-cancelado tg-aguardando-lib tg-aguardando-ger-fci tg-lib-fat 
          tg-aguardando-sep tg-faturado tg-nf-calculada tg-nf-impressa 
          tg-nf-confirmada tg-aloc-pendente tg-aloc-parcial tg-aloc-bloqueada 
          tg-aloc-Finalizada cod-depos-alocacao 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  ENABLE rt-button IMAGE-1 IMAGE-2 IMAGE-7 IMAGE-8 IMAGE-9 IMAGE-10 IMAGE-13 
         IMAGE-14 RECT-9 RECT-10 RECT-11 RECT-12 RECT-13 RECT-14 
         c-cod-estabel-ini c-cod-estabel-fim dt-implant-ini dt-implant-fim 
         i-nr-ordem-ini i-nr-ordem-fim i-nr-pedido-ini i-nr-pedido-fim 
         tg-aberto tg-pendente tg-atendido-parc tg-suspenso tg-atendido-tot 
         tg-cancelado tg-aguardando-lib tg-aguardando-ger-fci tg-lib-fat 
         tg-aguardando-sep tg-faturado tg-nf-calculada tg-nf-impressa 
         tg-nf-confirmada tg-aloc-pendente tg-aloc-parcial tg-aloc-bloqueada 
         tg-aloc-Finalizada cod-depos-alocacao bt-ok bt-cancela bt-ajuda 
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

  {utp/ut9000.i "esftp222" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  RUN dispatch  IN this-procedure ('enable-fields':U).

    FIND FIRST tt-filtro NO-LOCK NO-ERROR.

    ASSIGN  c-cod-estabel-ini          :SCREEN-VALUE IN FRAME f-cad = STRING(tt-filtro.cod-estabel-ini)
            c-cod-estabel-fim          :SCREEN-VALUE IN FRAME f-cad = STRING(tt-filtro.cod-estabel-fim)
            dt-implant-ini          :SCREEN-VALUE IN FRAME f-cad = STRING(tt-filtro.dt-implant-ini)
            dt-implant-fim          :SCREEN-VALUE IN FRAME f-cad = STRING(tt-filtro.dt-implant-fim)
            i-nr-pedido-ini         :SCREEN-VALUE IN FRAME f-cad = STRING(tt-filtro.nr-pedido-ini)
            i-nr-pedido-fim         :SCREEN-VALUE IN FRAME f-cad = STRING(tt-filtro.nr-pedido-fim)
            i-nr-ordem-ini          :SCREEN-VALUE IN FRAME f-cad = STRING(tt-filtro.nr-ordem-ini)
            i-nr-ordem-fim          :SCREEN-VALUE IN FRAME f-cad = STRING(tt-filtro.nr-ordem-fim)
            cod-depos-alocacao      :SCREEN-VALUE IN FRAME f-cad = STRING(tt-filtro.cod-depos-alocacao)
            tg-aberto               :CHECKED IN FRAME f-cad = tt-filtro.tg-aberto
            tg-atendido-parc        :CHECKED IN FRAME f-cad = tt-filtro.tg-atendido-parc
            tg-atendido-tot         :CHECKED IN FRAME f-cad = tt-filtro.tg-atendido-tot
            tg-pendente             :CHECKED IN FRAME f-cad = tt-filtro.tg-pendente
            tg-suspenso             :CHECKED IN FRAME f-cad = tt-filtro.tg-suspenso
            tg-cancelado            :CHECKED IN FRAME f-cad = tt-filtro.tg-cancelado
            tg-aguardando-lib       :CHECKED IN FRAME f-cad = tt-filtro.tg-aguardando-lib
            tg-aguardando-ger-fci   :CHECKED IN FRAME f-cad = tt-filtro.tg-aguardando-ger-fci
            tg-aguardando-sep       :CHECKED IN FRAME f-cad = tt-filtro.tg-aguardando-sep
            tg-lib-fat              :CHECKED IN FRAME f-cad = tt-filtro.tg-lib-fat       
            tg-faturado             :CHECKED IN FRAME f-cad = tt-filtro.tg-faturado
            tg-aloc-pendente        :CHECKED IN FRAME f-cad = tt-filtro.tg-aloc-pendente
            tg-aloc-bloqueada       :CHECKED IN FRAME f-cad = tt-filtro.tg-aloc-bloqueada
            tg-aloc-parcial         :CHECKED IN FRAME f-cad = tt-filtro.tg-aloc-parcial
            tg-aloc-finalizada      :CHECKED IN FRAME f-cad = tt-filtro.tg-aloc-finalizada
            tg-nf-calculada         :CHECKED IN FRAME f-cad = tt-filtro.tg-nf-calculada
            tg-nf-confirmada        :CHECKED IN FRAME f-cad = tt-filtro.tg-nf-confirmada
            tg-nf-impressa          :CHECKED IN FRAME f-cad = tt-filtro.tg-nf-impressa.

  {include/i-inifld.i}

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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

