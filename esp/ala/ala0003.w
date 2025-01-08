&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME w-relat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-relat 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i XX9999 9.99.99.999}

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

/*:T Preprocessadores do Template de Relat¢rio                            */
/*:T Obs: Retirar o valor do preprocessador para as p ginas que nÆo existirem  */

&GLOBAL-DEFINE PGSEL f-pg-sel
&GLOBAL-DEFINE PGCLA 
&GLOBAL-DEFINE PGPAR 
&GLOBAL-DEFINE PGDIG 
&GLOBAL-DEFINE PGIMP f-pg-imp

&GLOBAL-DEFINE RTF   NO
  
/* Parameters Definitions ---                                           */

/* Temporary Table Definitions ---                                      */

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino                       AS INTEGER
    FIELD arquivo                       AS CHAR FORMAT "x(35)"
    FIELD usuario                       AS CHAR FORMAT "x(12)"
    FIELD data-exec                     AS DATE
    field hora-exec                     as INTEGER
    FIELD tipo-exec                     AS CHAR
    FIELD l-adiantamento                AS LOG
    FIELD adiantamento-rq               AS CHAR
    FIELD adiantamento-ex               AS CHAR
    FIELD adiantamento-dt               AS CHAR
    FIELD l-adiantamento-viagem         AS LOG
    FIELD adiantamento-viagem-rq        AS CHAR
    FIELD adiantamento-viagem-ex        AS CHAR
    FIELD adiantamento-viagem-dt        AS CHAR
    FIELD l-cartao-credito              AS LOG
    FIELD cartao-credito-rq             AS CHAR
    FIELD cartao-credito-ex             AS CHAR
    FIELD cartao-credito-dt             AS CHAR
    FIELD l-prestacao-contas            AS LOG
    FIELD prestacao-contas-rq           AS CHAR
    FIELD prestacao-contas-ex           AS CHAR
    FIELD prestacao-contas-dt           AS CHAR
    FIELD l-prestacao-contas-ad         AS LOG
    FIELD prestacao-contas-ad-rq        AS CHAR
    FIELD prestacao-contas-ad-ex        AS CHAR
    FIELD prestacao-contas-ad-dt        AS CHAR
    FIELD l-prestacao-contas-ad-viagem  AS LOG
    FIELD prestacao-contas-ad-viagem-rq AS CHAR
    FIELD prestacao-contas-ad-viagem-ex AS CHAR
    FIELD prestacao-contas-ad-viagem-dt AS CHAR
    FIELD l-avulso                      AS LOG
    FIELD avulso-rq                     AS CHAR
    FIELD avulso-ex                     AS CHAR
    FIELD avulso-dt                     AS CHAR
    FIELD data-avulso-ini               AS DATE
    FIELD data-avulso-fim               AS DATE.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id ordem.

define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.
                    
/* Local Variable Definitions ---                                       */

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-rtf              as char    no-undo.
def var c-modelo-default   as char    no-undo.

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est  rodando no WebEnabler*/
DEFINE SHARED VARIABLE hWenController AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-relat
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-pg-imp

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-7 RECT-9 rs-destino bt-arquivo ~
bt-config-impr c-arquivo rs-execucao 
&Scoped-Define DISPLAYED-OBJECTS rs-destino c-arquivo rs-execucao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-relat AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-arquivo 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-config-impr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE c-arquivo AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.57 BY .63 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execu‡Æo" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63 NO-UNDO.

DEFINE VARIABLE rs-destino AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 44 BY 1.08 NO-UNDO.

DEFINE VARIABLE rs-execucao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.72 BY .92 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 2.79.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 1.71.

DEFINE VARIABLE adiantamento-dt AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE adiantamento-ex AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE adiantamento-rq AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE adiantamento-viagem-dt AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE adiantamento-viagem-ex AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE adiantamento-viagem-rq AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE avulso-dt AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE avulso-ex AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE avulso-rq AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE cartao-credito-dt AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE cartao-credito-ex AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE cartao-credito-rq AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE d-data-avulso-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE d-data-avulso-ini AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE prestacao-contas-ad-dt AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE prestacao-contas-ad-ex AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE prestacao-contas-ad-rq AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE prestacao-contas-ad-viagem-dt AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE prestacao-contas-ad-viagem-ex AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE prestacao-contas-ad-viagem-rq AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE prestacao-contas-dt AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE prestacao-contas-ex AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE prestacao-contas-rq AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE rs-tipo-exec AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Relat¢rio", 1,
"Integra‡Æo", 2
     SIZE 26 BY .75 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 72 BY 2.5.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 72 BY 6.88.

DEFINE VARIABLE tg-adiantamento AS LOGICAL INITIAL no 
     LABEL "Adiantamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .83 NO-UNDO.

DEFINE VARIABLE tg-adiantamento-viagem AS LOGICAL INITIAL no 
     LABEL "Adiantamento Viagem" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83 NO-UNDO.

DEFINE VARIABLE tg-avulso AS LOGICAL INITIAL no 
     LABEL "Avulso" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-cartao-credito AS LOGICAL INITIAL no 
     LABEL "CartÆo de Cr‚dito" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83 NO-UNDO.

DEFINE VARIABLE tg-prestacao-contas AS LOGICAL INITIAL no 
     LABEL "Presta‡Æo Contas" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .83 NO-UNDO.

DEFINE VARIABLE tg-prestacao-contas-ad AS LOGICAL INITIAL no 
     LABEL "Presta‡Æo Contas AD" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.

DEFINE VARIABLE tg-prestacao-contas-ad-viagem AS LOGICAL INITIAL no 
     LABEL "Presta‡Æo Contas AD Viagem" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-executar 
     LABEL "Executar" 
     SIZE 10 BY 1.

DEFINE IMAGE im-pg-imp
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-sel
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 79 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 0    
     SIZE 78.72 BY .13
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder
     EDGE-PIXELS 1 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 11.38
     FGCOLOR 0 .

DEFINE RECTANGLE rt-folder-left
     EDGE-PIXELS 0    
     SIZE .43 BY 11.21
     BGCOLOR 15 .

DEFINE RECTANGLE rt-folder-right
     EDGE-PIXELS 0    
     SIZE .43 BY 11.17
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder-top
     EDGE-PIXELS 0    
     SIZE 78.72 BY .13
     BGCOLOR 15 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-relat
     bt-executar AT ROW 14.54 COL 3 HELP
          "Dispara a execu‡Æo do relat¢rio"
     bt-cancelar AT ROW 14.54 COL 14 HELP
          "Fechar"
     bt-ajuda AT ROW 14.54 COL 70 HELP
          "Ajuda"
     RECT-1 AT ROW 14.29 COL 2
     RECT-6 AT ROW 13.75 COL 2.14
     rt-folder-top AT ROW 2.54 COL 2.14
     rt-folder-right AT ROW 2.67 COL 80.43
     rt-folder-left AT ROW 2.54 COL 2.14
     rt-folder AT ROW 2.5 COL 2
     im-pg-imp AT ROW 1.5 COL 17.86
     im-pg-sel AT ROW 1.5 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81 BY 15
         DEFAULT-BUTTON bt-executar WIDGET-ID 100.

DEFINE FRAME f-pg-imp
     rs-destino AT ROW 1.63 COL 3.29 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     bt-arquivo AT ROW 2.71 COL 43.29 HELP
          "Escolha do nome do arquivo"
     bt-config-impr AT ROW 2.71 COL 43.29 HELP
          "Configura‡Æo da impressora"
     c-arquivo AT ROW 2.75 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rs-execucao AT ROW 8.88 COL 2.86 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-destino AT ROW 1.04 COL 3.86 NO-LABEL
     text-modo AT ROW 8.13 COL 1.14 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.33 COL 2.14
     RECT-9 AT ROW 8.33 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 73.72 BY 10.5
         FONT 7 WIDGET-ID 100.

DEFINE FRAME f-pg-sel
     rs-tipo-exec AT ROW 1 COL 3 NO-LABEL WIDGET-ID 2
     tg-adiantamento AT ROW 2.63 COL 4 WIDGET-ID 8
     adiantamento-rq AT ROW 2.63 COL 29.72 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     adiantamento-ex AT ROW 2.63 COL 41.86 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     adiantamento-dt AT ROW 2.63 COL 54 COLON-ALIGNED NO-LABEL WIDGET-ID 64
     tg-adiantamento-viagem AT ROW 3.63 COL 4 WIDGET-ID 10
     adiantamento-viagem-rq AT ROW 3.63 COL 29.72 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     adiantamento-viagem-ex AT ROW 3.63 COL 41.86 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     adiantamento-viagem-dt AT ROW 3.63 COL 54 COLON-ALIGNED NO-LABEL WIDGET-ID 66
     tg-cartao-credito AT ROW 4.63 COL 4 WIDGET-ID 12
     cartao-credito-rq AT ROW 4.63 COL 29.72 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     cartao-credito-ex AT ROW 4.63 COL 41.86 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     cartao-credito-dt AT ROW 4.63 COL 54 COLON-ALIGNED NO-LABEL WIDGET-ID 54
     tg-prestacao-contas AT ROW 5.63 COL 4 WIDGET-ID 14
     prestacao-contas-rq AT ROW 5.63 COL 29.72 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     prestacao-contas-ex AT ROW 5.63 COL 41.86 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     prestacao-contas-dt AT ROW 5.63 COL 54 COLON-ALIGNED NO-LABEL WIDGET-ID 56
     tg-prestacao-contas-ad AT ROW 6.63 COL 4 WIDGET-ID 16
     prestacao-contas-ad-rq AT ROW 6.63 COL 29.72 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     prestacao-contas-ad-ex AT ROW 6.63 COL 41.86 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     prestacao-contas-ad-dt AT ROW 6.63 COL 54 COLON-ALIGNED NO-LABEL WIDGET-ID 58
     tg-prestacao-contas-ad-viagem AT ROW 7.63 COL 4 WIDGET-ID 18
     prestacao-contas-ad-viagem-rq AT ROW 7.63 COL 29.72 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     prestacao-contas-ad-viagem-ex AT ROW 7.63 COL 41.86 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     prestacao-contas-ad-viagem-dt AT ROW 7.63 COL 54 COLON-ALIGNED NO-LABEL WIDGET-ID 60
     tg-avulso AT ROW 9.13 COL 4 WIDGET-ID 20
     avulso-rq AT ROW 9.13 COL 29.72 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     avulso-ex AT ROW 9.13 COL 41.86 COLON-ALIGNED NO-LABEL WIDGET-ID 48
     avulso-dt AT ROW 9.13 COL 54 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     d-data-avulso-ini AT ROW 10.13 COL 29.72 COLON-ALIGNED NO-LABEL WIDGET-ID 50
     d-data-avulso-fim AT ROW 10.13 COL 54 COLON-ALIGNED NO-LABEL
     "Data Type" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 2.04 COL 56.14 WIDGET-ID 80
     "Request State" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 2.04 COL 31.86 WIDGET-ID 74
     "Expense State" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 2.04 COL 43.86 WIDGET-ID 78
     IMAGE-1 AT ROW 10.13 COL 42.72
     IMAGE-2 AT ROW 10.13 COL 53.14
     RECT-12 AT ROW 1.88 COL 3 WIDGET-ID 86
     RECT-11 AT ROW 8.88 COL 3 WIDGET-ID 92
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.85
         SIZE 76.86 BY 10.62
         FONT 7 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-relat
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-relat ASSIGN
         HIDDEN             = YES
         TITLE              = "<Title>"
         HEIGHT             = 15
         WIDTH              = 81.14
         MAX-HEIGHT         = 22.33
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22.33
         VIRTUAL-WIDTH      = 114.29
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-relat 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-relat.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-relat
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-pg-imp
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN text-destino IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Destino".

/* SETTINGS FOR FILL-IN text-modo IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Execu‡Æo".

/* SETTINGS FOR FRAME f-pg-sel
                                                                        */
/* SETTINGS FOR FILL-IN adiantamento-dt IN FRAME f-pg-sel
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN adiantamento-ex IN FRAME f-pg-sel
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN adiantamento-rq IN FRAME f-pg-sel
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN adiantamento-viagem-dt IN FRAME f-pg-sel
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN adiantamento-viagem-ex IN FRAME f-pg-sel
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN adiantamento-viagem-rq IN FRAME f-pg-sel
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cartao-credito-dt IN FRAME f-pg-sel
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cartao-credito-ex IN FRAME f-pg-sel
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cartao-credito-rq IN FRAME f-pg-sel
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN prestacao-contas-ad-dt IN FRAME f-pg-sel
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN prestacao-contas-ad-ex IN FRAME f-pg-sel
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN prestacao-contas-ad-rq IN FRAME f-pg-sel
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN prestacao-contas-ad-viagem-dt IN FRAME f-pg-sel
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN prestacao-contas-ad-viagem-ex IN FRAME f-pg-sel
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN prestacao-contas-ad-viagem-rq IN FRAME f-pg-sel
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN prestacao-contas-dt IN FRAME f-pg-sel
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN prestacao-contas-ex IN FRAME f-pg-sel
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN prestacao-contas-rq IN FRAME f-pg-sel
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME f-relat
                                                                        */
/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-6 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-left IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-right IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-top IN FRAME f-relat
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-relat)
THEN w-relat:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-imp
/* Query rebuild information for FRAME f-pg-imp
     _Query            is NOT OPENED
*/  /* FRAME f-pg-imp */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-sel
/* Query rebuild information for FRAME f-pg-sel
     _Query            is NOT OPENED
*/  /* FRAME f-pg-sel */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-relat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-relat w-relat
ON END-ERROR OF w-relat /* <Title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-relat w-relat
ON WINDOW-CLOSE OF w-relat /* <Title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-relat
ON CHOOSE OF bt-ajuda IN FRAME f-relat /* Ajuda */
DO:
   {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo w-relat
ON CHOOSE OF bt-arquivo IN FRAME f-pg-imp
DO:
    {include/i-rparq.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar w-relat
ON CHOOSE OF bt-cancelar IN FRAME f-relat /* Fechar */
DO:
   apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-config-impr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-config-impr w-relat
ON CHOOSE OF bt-config-impr IN FRAME f-pg-imp
DO:
   {include/i-rpimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executar w-relat
ON CHOOSE OF bt-executar IN FRAME f-relat /* Executar */
DO:
   do  on error undo, return no-apply:
       run pi-executar.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-imp w-relat
ON MOUSE-SELECT-CLICK OF im-pg-imp IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-sel w-relat
ON MOUSE-SELECT-CLICK OF im-pg-sel IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME rs-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-destino w-relat
ON VALUE-CHANGED OF rs-destino IN FRAME f-pg-imp
DO:
/*Alterado 15/02/2005 - tech1007 - Evento alterado para correto funcionamento dos novos widgets
  utilizados para a funcionalidade de RTF*/
do  with frame f-pg-imp:
    case self:screen-value:
        when "1" then do:
            assign c-arquivo:sensitive    = no
                   bt-arquivo:visible     = no
                   bt-config-impr:visible = YES
                   /*Alterado 17/02/2005 - tech1007 - Realizado teste de preprocessador para
                     verificar se o RTF est  ativo*/
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = NO
                   l-habilitaRtf:SCREEN-VALUE IN FRAME f-pg-imp = "No"
                   l-habilitaRtf = NO
                   &endif
                   /*Fim alteracao 17/02/2005*/
                   .
        end.
        when "2" then do:
            assign c-arquivo:sensitive     = yes
                   bt-arquivo:visible      = yes
                   bt-config-impr:visible  = NO
                   /*Alterado 17/02/2005 - tech1007 - Realizado teste de preprocessador para
                     verificar se o RTF est  ativo*/
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = YES
                   &endif
                   /*Fim alteracao 17/02/2005*/
                   .
        end.
        when "3" then do:
            assign c-arquivo:sensitive     = no
                   bt-arquivo:visible      = no
                   bt-config-impr:visible  = no
                   /*Alterado 17/02/2005 - tech1007 - Realizado teste de preprocessador para
                     verificar se o RTF est  ativo*/
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = YES
                   &endif
                   /*Fim alteracao 17/02/2005*/
                   .
            /*Alterado 15/02/2005 - tech1007 - Teste para funcionar corretamente no WebEnabler*/
            &IF "{&RTF}":U = "YES":U &THEN
            IF VALID-HANDLE(hWenController) THEN DO:
                ASSIGN l-habilitaRtf:sensitive  = NO
                       l-habilitaRtf:SCREEN-VALUE IN FRAME f-pg-imp = "No"
                       l-habilitaRtf = NO.
            END.
            &endif
            /*Fim alteracao 15/02/2005*/
        end.
    end case.
end.
&IF "{&RTF}":U = "YES":U &THEN
RUN pi-habilitaRtf.
&endif
/*Fim alteracao 15/02/2005*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-execucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-execucao w-relat
ON VALUE-CHANGED OF rs-execucao IN FRAME f-pg-imp
DO:
   {include/i-rprse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-sel
&Scoped-define SELF-NAME rs-tipo-exec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-tipo-exec w-relat
ON VALUE-CHANGED OF rs-tipo-exec IN FRAME f-pg-sel
DO:
    IF SELF:SCREEN-VALUE = "1" THEN DO:
        ASSIGN tg-avulso:SENSITIVE IN FRAME f-pg-sel = YES.
        APPLY "value-changed" TO tg-avulso IN FRAME f-pg-sel.
    END.
    ELSE DO:
        ASSIGN tg-avulso:SENSITIVE IN FRAME f-pg-sel = NO.
        ASSIGN tg-avulso:CHECKED IN FRAME f-pg-sel = NO.
        APPLY "value-changed" TO tg-avulso IN FRAME f-pg-sel.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-adiantamento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-adiantamento w-relat
ON VALUE-CHANGED OF tg-adiantamento IN FRAME f-pg-sel /* Adiantamento */
DO:
/*     IF SELF:CHECKED THEN DO:                                        */
/*         ASSIGN adiantamento-rq:SENSITIVE IN FRAME f-pg-sel = YES    */
/*                adiantamento-ex:SENSITIVE IN FRAME f-pg-sel = YES    */
/*                adiantamento-dt:SENSITIVE IN FRAME f-pg-sel = YES.   */
/*     END.                                                            */
/*     ELSE DO:                                                        */
/*         ASSIGN adiantamento-rq:SENSITIVE    IN FRAME f-pg-sel = NO  */
/*                adiantamento-ex:SENSITIVE    IN FRAME f-pg-sel = NO  */
/*                adiantamento-dt:SENSITIVE    IN FRAME f-pg-sel = NO  */
/*                adiantamento-rq:SCREEN-VALUE IN FRAME f-pg-sel = ""  */
/*                adiantamento-ex:SCREEN-VALUE IN FRAME f-pg-sel = ""  */
/*                adiantamento-dt:SCREEN-VALUE IN FRAME f-pg-sel = "". */
/*     END.                                                            */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-adiantamento-viagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-adiantamento-viagem w-relat
ON VALUE-CHANGED OF tg-adiantamento-viagem IN FRAME f-pg-sel /* Adiantamento Viagem */
DO:
/*     IF SELF:CHECKED THEN DO:                                               */
/*         ASSIGN adiantamento-viagem-rq:SENSITIVE IN FRAME f-pg-sel = YES    */
/*                adiantamento-viagem-ex:SENSITIVE IN FRAME f-pg-sel = YES    */
/*                adiantamento-viagem-dt:SENSITIVE IN FRAME f-pg-sel = YES.   */
/*     END.                                                                   */
/*     ELSE DO:                                                               */
/*         ASSIGN adiantamento-viagem-rq:SENSITIVE    IN FRAME f-pg-sel = NO  */
/*                adiantamento-viagem-ex:SENSITIVE    IN FRAME f-pg-sel = NO  */
/*                adiantamento-viagem-dt:SENSITIVE    IN FRAME f-pg-sel = NO  */
/*                adiantamento-viagem-rq:SCREEN-VALUE IN FRAME f-pg-sel = ""  */
/*                adiantamento-viagem-ex:SCREEN-VALUE IN FRAME f-pg-sel = ""  */
/*                adiantamento-viagem-dt:SCREEN-VALUE IN FRAME f-pg-sel = "". */
/*     END.                                                                   */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-avulso
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-avulso w-relat
ON VALUE-CHANGED OF tg-avulso IN FRAME f-pg-sel /* Avulso */
DO:
    IF SELF:CHECKED THEN DO:
        ASSIGN avulso-rq:SENSITIVE         IN FRAME f-pg-sel = YES
               avulso-ex:SENSITIVE         IN FRAME f-pg-sel = YES
               avulso-dt:SENSITIVE         IN FRAME f-pg-sel = YES
               d-data-avulso-ini:SENSITIVE IN FRAME f-pg-sel = YES
               d-data-avulso-fim:SENSITIVE IN FRAME f-pg-sel = YES.
    END.
    ELSE DO:
        ASSIGN avulso-rq:SENSITIVE            IN FRAME f-pg-sel = NO
               avulso-ex:SENSITIVE            IN FRAME f-pg-sel = NO
               avulso-dt:SENSITIVE            IN FRAME f-pg-sel = NO
               d-data-avulso-ini:SENSITIVE    IN FRAME f-pg-sel = NO
               d-data-avulso-fim:SENSITIVE    IN FRAME f-pg-sel = NO
               avulso-rq:SCREEN-VALUE         IN FRAME f-pg-sel = ""
               avulso-ex:SCREEN-VALUE         IN FRAME f-pg-sel = ""
               avulso-dt:SCREEN-VALUE         IN FRAME f-pg-sel = ""
               d-data-avulso-ini:SCREEN-VALUE IN FRAME f-pg-sel = ?
               d-data-avulso-fim:SCREEN-VALUE IN FRAME f-pg-sel = ?.
    END.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-cartao-credito
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-cartao-credito w-relat
ON VALUE-CHANGED OF tg-cartao-credito IN FRAME f-pg-sel /* CartÆo de Cr‚dito */
DO:
/*     IF SELF:CHECKED THEN DO:                                          */
/*         ASSIGN cartao-credito-rq:SENSITIVE IN FRAME f-pg-sel = YES    */
/*                cartao-credito-ex:SENSITIVE IN FRAME f-pg-sel = YES    */
/*                cartao-credito-dt:SENSITIVE IN FRAME f-pg-sel = YES.   */
/*     END.                                                              */
/*     ELSE DO:                                                          */
/*         ASSIGN cartao-credito-rq:SENSITIVE    IN FRAME f-pg-sel = NO  */
/*                cartao-credito-ex:SENSITIVE    IN FRAME f-pg-sel = NO  */
/*                cartao-credito-dt:SENSITIVE    IN FRAME f-pg-sel = NO  */
/*                cartao-credito-rq:SCREEN-VALUE IN FRAME f-pg-sel = ""  */
/*                cartao-credito-ex:SCREEN-VALUE IN FRAME f-pg-sel = ""  */
/*                cartao-credito-dt:SCREEN-VALUE IN FRAME f-pg-sel = "". */
/*     END.                                                              */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-prestacao-contas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-prestacao-contas w-relat
ON VALUE-CHANGED OF tg-prestacao-contas IN FRAME f-pg-sel /* Presta‡Æo Contas */
DO:
/*     IF SELF:CHECKED THEN DO:                                            */
/*         ASSIGN prestacao-contas-rq:SENSITIVE IN FRAME f-pg-sel = YES    */
/*                prestacao-contas-ex:SENSITIVE IN FRAME f-pg-sel = YES    */
/*                prestacao-contas-dt:SENSITIVE IN FRAME f-pg-sel = YES.   */
/*     END.                                                                */
/*     ELSE DO:                                                            */
/*         ASSIGN prestacao-contas-rq:SENSITIVE    IN FRAME f-pg-sel = NO  */
/*                prestacao-contas-ex:SENSITIVE    IN FRAME f-pg-sel = NO  */
/*                prestacao-contas-dt:SENSITIVE    IN FRAME f-pg-sel = NO  */
/*                prestacao-contas-rq:SCREEN-VALUE IN FRAME f-pg-sel = ""  */
/*                prestacao-contas-ex:SCREEN-VALUE IN FRAME f-pg-sel = ""  */
/*                prestacao-contas-dt:SCREEN-VALUE IN FRAME f-pg-sel = "". */
/*     END.                                                                */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-prestacao-contas-ad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-prestacao-contas-ad w-relat
ON VALUE-CHANGED OF tg-prestacao-contas-ad IN FRAME f-pg-sel /* Presta‡Æo Contas AD */
DO:
/*     IF SELF:CHECKED THEN DO:                                               */
/*         ASSIGN prestacao-contas-ad-rq:SENSITIVE IN FRAME f-pg-sel = YES    */
/*                prestacao-contas-ad-ex:SENSITIVE IN FRAME f-pg-sel = YES    */
/*                prestacao-contas-ad-dt:SENSITIVE IN FRAME f-pg-sel = YES.   */
/*     END.                                                                   */
/*     ELSE DO:                                                               */
/*         ASSIGN prestacao-contas-ad-rq:SENSITIVE    IN FRAME f-pg-sel = NO  */
/*                prestacao-contas-ad-ex:SENSITIVE    IN FRAME f-pg-sel = NO  */
/*                prestacao-contas-ad-dt:SENSITIVE    IN FRAME f-pg-sel = NO  */
/*                prestacao-contas-ad-rq:SCREEN-VALUE IN FRAME f-pg-sel = ""  */
/*                prestacao-contas-ad-ex:SCREEN-VALUE IN FRAME f-pg-sel = ""  */
/*                prestacao-contas-ad-dt:SCREEN-VALUE IN FRAME f-pg-sel = "". */
/*     END.                                                                   */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-prestacao-contas-ad-viagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-prestacao-contas-ad-viagem w-relat
ON VALUE-CHANGED OF tg-prestacao-contas-ad-viagem IN FRAME f-pg-sel /* Presta‡Æo Contas AD Viagem */
DO:
/*     IF SELF:CHECKED THEN DO:                                                      */
/*         ASSIGN prestacao-contas-ad-viagem-rq:SENSITIVE IN FRAME f-pg-sel = YES    */
/*                prestacao-contas-ad-viagem-ex:SENSITIVE IN FRAME f-pg-sel = YES    */
/*                prestacao-contas-ad-viagem-dt:SENSITIVE IN FRAME f-pg-sel = YES.   */
/*     END.                                                                          */
/*     ELSE DO:                                                                      */
/*         ASSIGN prestacao-contas-ad-viagem-rq:SENSITIVE    IN FRAME f-pg-sel = NO  */
/*                prestacao-contas-ad-viagem-ex:SENSITIVE    IN FRAME f-pg-sel = NO  */
/*                prestacao-contas-ad-viagem-dt:SENSITIVE    IN FRAME f-pg-sel = NO  */
/*                prestacao-contas-ad-viagem-rq:SCREEN-VALUE IN FRAME f-pg-sel = ""  */
/*                prestacao-contas-ad-viagem-ex:SCREEN-VALUE IN FRAME f-pg-sel = ""  */
/*                prestacao-contas-ad-viagem-dt:SCREEN-VALUE IN FRAME f-pg-sel = "". */
/*     END.                                                                          */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-relat 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

{utp/ut9000.i "ala0003" "2.00.00.000"}

/*:T inicializa‡äes do template de relat¢rio */
{include/i-rpini.i}

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

{include/i-rplbl.i}

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO  ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    RUN enable_UI.
    
    {include/i-rpmbl.i}

    APPLY "value-changed" TO tg-adiantamento IN FRAME f-pg-sel.
    APPLY "value-changed" TO tg-adiantamento-viagem IN FRAME f-pg-sel.
    APPLY "value-changed" TO tg-cartao-credito IN FRAME f-pg-sel.
    APPLY "value-changed" TO tg-prestacao-contas IN FRAME f-pg-sel.
    APPLY "value-changed" TO tg-prestacao-contas-ad IN FRAME f-pg-sel.
    APPLY "value-changed" TO tg-prestacao-contas-ad-viagem IN FRAME f-pg-sel.
    APPLY "value-changed" TO tg-avulso IN FRAME f-pg-sel.

    FOR LAST int_param_alatur NO-LOCK:
        ASSIGN adiantamento-rq:SCREEN-VALUE IN FRAME f-pg-sel = ENTRY(1, int_param_alatur.cod_param_ad, ",")
               adiantamento-ex:SCREEN-VALUE IN FRAME f-pg-sel = ENTRY(2, int_param_alatur.cod_param_ad, ",")
               adiantamento-dt:SCREEN-VALUE IN FRAME f-pg-sel = ENTRY(3, int_param_alatur.cod_param_ad, ",")
               adiantamento-viagem-rq:SCREEN-VALUE IN FRAME f-pg-sel = ENTRY(1, int_param_alatur.cod_param_ad_viagem, ",")
               adiantamento-viagem-ex:SCREEN-VALUE IN FRAME f-pg-sel = ENTRY(2, int_param_alatur.cod_param_ad_viagem, ",")
               adiantamento-viagem-dt:SCREEN-VALUE IN FRAME f-pg-sel = ENTRY(3, int_param_alatur.cod_param_ad_viagem, ",")
               cartao-credito-rq:SCREEN-VALUE IN FRAME f-pg-sel = ENTRY(1, int_param_alatur.cod_param_ad_cr, ",")
               cartao-credito-ex:SCREEN-VALUE IN FRAME f-pg-sel = ENTRY(2, int_param_alatur.cod_param_ad_cr, ",")
               cartao-credito-dt:SCREEN-VALUE IN FRAME f-pg-sel = ENTRY(3, int_param_alatur.cod_param_ad_cr, ",")
               prestacao-contas-rq:SCREEN-VALUE IN FRAME f-pg-sel = ENTRY(1, int_param_alatur.cod_param_pc, ",")
               prestacao-contas-ex:SCREEN-VALUE IN FRAME f-pg-sel = ENTRY(2, int_param_alatur.cod_param_pc, ",")
               prestacao-contas-dt:SCREEN-VALUE IN FRAME f-pg-sel = ENTRY(3, int_param_alatur.cod_param_pc, ",")
               prestacao-contas-ad-rq:SCREEN-VALUE IN FRAME f-pg-sel = ENTRY(1, int_param_alatur.cod_param_pc_ad, ",")
               prestacao-contas-ad-ex:SCREEN-VALUE IN FRAME f-pg-sel = ENTRY(2, int_param_alatur.cod_param_pc_ad, ",")
               prestacao-contas-ad-dt:SCREEN-VALUE IN FRAME f-pg-sel = ENTRY(3, int_param_alatur.cod_param_pc_ad, ",")
               prestacao-contas-ad-viagem-rq:SCREEN-VALUE IN FRAME f-pg-sel = ENTRY(1, int_param_alatur.cod_param_pc_ad_viagem, ",")
               prestacao-contas-ad-viagem-ex:SCREEN-VALUE IN FRAME f-pg-sel = ENTRY(2, int_param_alatur.cod_param_pc_ad_viagem, ",")
               prestacao-contas-ad-viagem-dt:SCREEN-VALUE IN FRAME f-pg-sel = ENTRY(3, int_param_alatur.cod_param_pc_ad_viagem, ",").
    END.
    
  
    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-relat  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-relat  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-relat  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-relat)
  THEN DELETE WIDGET w-relat.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-relat  _DEFAULT-ENABLE
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
  ENABLE im-pg-imp im-pg-sel bt-executar bt-cancelar bt-ajuda 
      WITH FRAME f-relat IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  DISPLAY rs-tipo-exec tg-adiantamento adiantamento-rq adiantamento-ex 
          adiantamento-dt tg-adiantamento-viagem adiantamento-viagem-rq 
          adiantamento-viagem-ex adiantamento-viagem-dt tg-cartao-credito 
          cartao-credito-rq cartao-credito-ex cartao-credito-dt 
          tg-prestacao-contas prestacao-contas-rq prestacao-contas-ex 
          prestacao-contas-dt tg-prestacao-contas-ad prestacao-contas-ad-rq 
          prestacao-contas-ad-ex prestacao-contas-ad-dt 
          tg-prestacao-contas-ad-viagem prestacao-contas-ad-viagem-rq 
          prestacao-contas-ad-viagem-ex prestacao-contas-ad-viagem-dt tg-avulso 
          avulso-rq avulso-ex avulso-dt d-data-avulso-ini d-data-avulso-fim 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  ENABLE IMAGE-1 IMAGE-2 RECT-12 RECT-11 rs-tipo-exec tg-adiantamento 
         tg-adiantamento-viagem tg-cartao-credito tg-prestacao-contas 
         tg-prestacao-contas-ad tg-prestacao-contas-ad-viagem tg-avulso 
         avulso-rq avulso-ex avulso-dt d-data-avulso-ini d-data-avulso-fim 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
  DISPLAY rs-destino c-arquivo rs-execucao 
      WITH FRAME f-pg-imp IN WINDOW w-relat.
  ENABLE RECT-7 RECT-9 rs-destino bt-arquivo bt-config-impr c-arquivo 
         rs-execucao 
      WITH FRAME f-pg-imp IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-imp}
  VIEW w-relat.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-relat 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar w-relat 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define var r-tt-digita as rowid no-undo.

do on error undo, return error on stop  undo, return error:
    {include/i-rpexa.i}
    /*14/02/2005 - tech1007 - Alterada condicao para nÆo considerar mai o RTF como destino*/
    if input frame f-pg-imp rs-destino = 2 and
       input frame f-pg-imp rs-execucao = 1 then do:
        run utp/ut-vlarq.p (input input frame f-pg-imp c-arquivo).
        
        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show":U, input 73, input "").
            
            apply "MOUSE-SELECT-CLICK":U to im-pg-imp in frame f-relat.
            apply "ENTRY":U to c-arquivo in frame f-pg-imp.
            return error.
        end.
    end.

    /*14/02/2005 - tech1007 - Teste efetuado para nao permitir modelo em branco*/
    &IF "{&RTF}":U = "YES":U &THEN
    IF ( INPUT FRAME f-pg-imp c-modelo-rtf = "" AND
         INPUT FRAME f-pg-imp l-habilitaRtf = "Yes" ) OR
       ( SEARCH(INPUT FRAME f-pg-imp c-modelo-rtf) = ? AND
         input frame f-pg-imp rs-execucao = 1 AND
         INPUT FRAME f-pg-imp l-habilitaRtf = "Yes" )
         THEN DO:
        run utp/ut-msgs.p (input "show":U, input 73, input "").        
        apply "MOUSE-SELECT-CLICK":U to im-pg-imp in frame f-relat.
        /*30/12/2004 - tech1007 - Evento removido pois causa problemas no WebEnabler*/
        /*apply "CHOOSE":U to bt-modelo-rtf in frame f-pg-imp.*/
        return error.
    END.
    &endif
    /*Fim teste Modelo*/
    
    /*:T Coloque aqui as valida‡äes da p gina de Digita‡Æo, lembrando que elas devem
       apresentar uma mensagem de erro cadastrada, posicionar nesta p gina e colocar
       o focus no campo com problemas */
    /*browse br-digita:SET-REPOSITIONED-ROW (browse br-digita:DOWN, "ALWAYS":U).*/
    
    /*:T Coloque aqui as valida‡äes das outras p ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p gina com 
       problemas e colocar o focus no campo com problemas */
    
    
    
    /*:T Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
       para o programa RP.P */
    
    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame f-pg-imp rs-destino
           tt-param.data-exec       = today
           tt-param.hora-exec       = time
           tt-param.tipo-exec                     = rs-tipo-exec:SCREEN-VALUE IN FRAME f-pg-sel
           tt-param.l-adiantamento                = tg-adiantamento:CHECKED IN FRAME f-pg-sel        
           tt-param.adiantamento-rq               = adiantamento-rq:SCREEN-VALUE IN FRAME f-pg-sel
           tt-param.adiantamento-ex               = adiantamento-ex:SCREEN-VALUE IN FRAME f-pg-sel
           tt-param.adiantamento-dt               = adiantamento-dt:SCREEN-VALUE IN FRAME f-pg-sel
           tt-param.l-adiantamento-viagem         = tg-adiantamento-viagem:CHECKED IN FRAME f-pg-sel
           tt-param.adiantamento-viagem-rq        = adiantamento-viagem-rq:SCREEN-VALUE IN FRAME f-pg-sel
           tt-param.adiantamento-viagem-ex        = adiantamento-viagem-ex:SCREEN-VALUE IN FRAME f-pg-sel
           tt-param.adiantamento-viagem-dt        = adiantamento-viagem-dt:SCREEN-VALUE IN FRAME f-pg-sel
           tt-param.l-cartao-credito              = tg-cartao-credito:CHECKED IN FRAME f-pg-sel
           tt-param.cartao-credito-rq             = cartao-credito-rq:SCREEN-VALUE IN FRAME f-pg-sel
           tt-param.cartao-credito-ex             = cartao-credito-ex:SCREEN-VALUE IN FRAME f-pg-sel
           tt-param.cartao-credito-dt             = cartao-credito-dt:SCREEN-VALUE IN FRAME f-pg-sel
           tt-param.l-prestacao-contas            = tg-prestacao-contas:CHECKED IN FRAME f-pg-sel
           tt-param.prestacao-contas-rq           = prestacao-contas-rq:SCREEN-VALUE IN FRAME f-pg-sel
           tt-param.prestacao-contas-ex           = prestacao-contas-ex:SCREEN-VALUE IN FRAME f-pg-sel
           tt-param.prestacao-contas-dt           = prestacao-contas-dt:SCREEN-VALUE IN FRAME f-pg-sel
           tt-param.l-prestacao-contas-ad         = tg-prestacao-contas-ad:CHECKED IN FRAME f-pg-sel
           tt-param.prestacao-contas-ad-rq        = prestacao-contas-ad-rq:SCREEN-VALUE IN FRAME f-pg-sel
           tt-param.prestacao-contas-ad-ex        = prestacao-contas-ad-ex:SCREEN-VALUE IN FRAME f-pg-sel
           tt-param.prestacao-contas-ad-dt        = prestacao-contas-ad-dt:SCREEN-VALUE IN FRAME f-pg-sel
           tt-param.l-prestacao-contas-ad-viagem  = tg-prestacao-contas-ad-viagem:CHECKED IN FRAME f-pg-sel
           tt-param.prestacao-contas-ad-viagem-rq = prestacao-contas-ad-viagem-rq:SCREEN-VALUE IN FRAME f-pg-sel
           tt-param.prestacao-contas-ad-viagem-ex = prestacao-contas-ad-viagem-ex:SCREEN-VALUE IN FRAME f-pg-sel
           tt-param.prestacao-contas-ad-viagem-dt = prestacao-contas-ad-viagem-dt:SCREEN-VALUE IN FRAME f-pg-sel
           tt-param.l-avulso                      = tg-avulso:CHECKED IN FRAME f-pg-sel
           tt-param.avulso-rq                     = avulso-rq:SCREEN-VALUE IN FRAME f-pg-sel
           tt-param.avulso-ex                     = avulso-ex:SCREEN-VALUE IN FRAME f-pg-sel
           tt-param.avulso-dt                     = avulso-dt:SCREEN-VALUE IN FRAME f-pg-sel
           tt-param.data-avulso-ini               = DATE(d-data-avulso-ini:SCREEN-VALUE IN FRAME f-pg-sel)
           tt-param.data-avulso-fim               = DATE(d-data-avulso-fim:SCREEN-VALUE IN FRAME f-pg-sel)
           .
    
    /*Alterado 14/02/2005 - tech1007 - Alterado o teste para verificar se a op‡Æo de RTF est  selecionada*/
    if tt-param.destino = 1 
    then assign tt-param.arquivo = "".
    else if  tt-param.destino = 2
         then assign tt-param.arquivo = input frame f-pg-imp c-arquivo.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    /*Fim alteracao 14/02/2005*/

    /*:T Coloque aqui a/l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */
    
    
    
    /*:T Executar do programa RP.P que ir  criar o relat¢rio */
    {include/i-rpexb.i}
    
    SESSION:SET-WAIT-STATE("general":U).
    
    {include/i-rprun.i esp/ala/ala0003rp.p}
    
    {include/i-rpexc.i} 
    
    SESSION:SET-WAIT-STATE("":U).
    
/*     {include/i-rptrm.i} */
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-pagina w-relat 
PROCEDURE pi-troca-pagina :
/*:T------------------------------------------------------------------------------
  Purpose: Gerencia a Troca de P gina (folder)   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{include/i-rptrp.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-relat  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this w-relat, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-relat 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
  
  run pi-trata-state (p-issuer-hdl, p-state).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

