
&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCQP008 2.00.00.000}  /*** 010000 ***/


/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Preprocessadores do Template de Relat¢rio                            */
/* Obs: Retirar o valor do preprocessador para as p†ginas que n∆o existirem  */

&GLOBAL-DEFINE PGSEL f-pg-sel
&GLOBAL-DEFINE PGCLA f-pg-cla
&GLOBAL-DEFINE PGPAR f-pg-par
&GLOBAL-DEFINE PGIMP f-pg-imp

/* Include Com as Vari†veis Globais */
{cdp/cdcfgmat.i}
{utp/ut-glob.i}

{include/i_dbtype.i}

/* Parameters Definitions ---                                           */

/* Temporary Table Definitions ---                                      */

define temp-table tt-param
    field destino        as integer
    field arquivo        as char
    field arquivo-csv    as char
    field usuario        as char
    field data-exec      as date
    field hora-exec      as integer
    field classifica     as integer
    field c-est-ini      like ficha-cq.cod-estabel
    field c-est-fim      like ficha-cq.cod-estabel
    field c-ite-ini      like ficha-cq.it-codigo
    field c-ite-fim      like ficha-cq.it-codigo
    field i-for-ini      like ficha-cq.cod-emitente
    field i-for-fim      like ficha-cq.cod-emitente
    field c-dat-ini      like docum-est.dt-emiss
    field c-dat-fim      like docum-est.dt-emiss
    field i-fic-ini      like ficha-cq.nr-ficha 
    field i-fic-fim      like ficha-cq.nr-ficha
    field c-dtl-ini      like ficha-cq.dt-inspecao
    field c-dtl-fim      like ficha-cq.dt-inspecao   
    field c-dep-ini      as char 
    field c-dep-fim      as char
    field c-resp-ini     as char
    field c-resp-fim     as char 
    field l-todos        as logical format "Sim/N∆o"
    field l-so-insp      as logical format "Sim/N∆o"
    field l-so-nao       as logical format "Sim/N∆o"
    field l-tudo         as logical format "Sim/N∆o"
    field c-classe       as char
    field c-destino      as char
    field l-analise      as logical format "Sim/N∆o"
    field l-pendente     as logical format "Sim/N∆o"
    field l-pendente-ret as logical format "Sim/N∆o"
    field l-cancelado    as logical format "Sim/N∆o"
    field l-terminado    as logical format "Sim/N∆o"
    FIELD l-nacional     AS LOGICAL FORMAT "Sim/N∆o"
    FIELD l-estrangeiro  AS LOGICAL FORMAT "Sim/N∆o".

define temp-table tt-digita
    field ordem      as integer   format ">>>>9"
    field exemplo    as character format "x(30)"
    index id is primary unique ordem.

define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */

def var raw-param    as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita  as raw.

/* Local Variable Definitions ---                                       */

def var l-ok         as logical no-undo.
def var c-arq-digita as char    no-undo.
def var c-terminal   as char    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-pg-cla

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ficha-cq docum-est

/* Definitions for FRAME f-pg-sel                                       */
&Scoped-define QUERY-STRING-f-pg-sel FOR EACH mgind.ficha-cq SHARE-LOCK, ~
      EACH mgind.docum-est OF mgind.ficha-cq SHARE-LOCK
&Scoped-define OPEN-QUERY-f-pg-sel OPEN QUERY f-pg-sel FOR EACH mgind.ficha-cq SHARE-LOCK, ~
      EACH mgind.docum-est OF mgind.ficha-cq SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-f-pg-sel ficha-cq docum-est
&Scoped-define FIRST-TABLE-IN-QUERY-f-pg-sel ficha-cq
&Scoped-define SECOND-TABLE-IN-QUERY-f-pg-sel docum-est


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rs-classif 
&Scoped-Define DISPLAYED-OBJECTS rs-classif 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE rs-classif AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Por Data de Transaá∆o", 1,
"Por Fornecedor", 2,
"Por Item", 3
     SIZE 40 BY 3 NO-UNDO.

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

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execuá∆o" 
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
     SIZE 46.29 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 1.71.

DEFINE VARIABLE txt-inspecao AS CHARACTER FORMAT "X(256)":U INITIAL "Situaá∆o Roteiro" 
      VIEW-AS TEXT 
     SIZE 18.57 BY .67 NO-UNDO.

DEFINE VARIABLE txt-integracao AS CHARACTER FORMAT "X(256)":U INITIAL "Integraá∆o M¢dulo Recebimento" 
      VIEW-AS TEXT 
     SIZE 30.86 BY .67 NO-UNDO.

DEFINE VARIABLE txt-nacional AS CHARACTER FORMAT "X(256)":U INITIAL "Origem Fornecedor" 
      VIEW-AS TEXT 
     SIZE 19 BY .67 NO-UNDO.

DEFINE VARIABLE txt-roteiro AS CHARACTER FORMAT "X(256)":U INITIAL "Situaá∆o Inspeá∆o" 
      VIEW-AS TEXT 
     SIZE 21 BY .67 NO-UNDO.

DEFINE RECTANGLE rt-roteiro
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 36 BY 3.

DEFINE RECTANGLE rt-roteiro-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 36 BY 2.25.

DEFINE RECTANGLE rt-roteiro-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 35 BY 6.

DEFINE RECTANGLE rt-roteiro-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 36 BY 3.

DEFINE VARIABLE l-analise AS LOGICAL INITIAL yes 
     LABEL "Em An†lise" 
     VIEW-AS TOGGLE-BOX
     SIZE 29.14 BY .88 NO-UNDO.

DEFINE VARIABLE l-cancelado AS LOGICAL INITIAL yes 
     LABEL "Cancelados" 
     VIEW-AS TOGGLE-BOX
     SIZE 29.72 BY .88 NO-UNDO.

DEFINE VARIABLE l-estrangeiro AS LOGICAL INITIAL yes 
     LABEL "Estrangeiro" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE l-nacional AS LOGICAL INITIAL yes 
     LABEL "Nacional" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE l-pendente AS LOGICAL INITIAL yes 
     LABEL "Pendentes" 
     VIEW-AS TOGGLE-BOX
     SIZE 30.29 BY .88 NO-UNDO.

DEFINE VARIABLE l-pendente-ret AS LOGICAL INITIAL yes 
     LABEL "Pendentes de Retorno" 
     VIEW-AS TOGGLE-BOX
     SIZE 28.43 BY .88 NO-UNDO.

DEFINE VARIABLE l-so-insp AS LOGICAL INITIAL yes 
     LABEL "Inspecionados" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.43 BY .88 NO-UNDO.

DEFINE VARIABLE l-so-nao AS LOGICAL INITIAL yes 
     LABEL "N∆o Inspecionados" 
     VIEW-AS TOGGLE-BOX
     SIZE 25.43 BY .88 NO-UNDO.

DEFINE VARIABLE l-terminado AS LOGICAL INITIAL yes 
     LABEL "Terminados" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE l-tudo AS LOGICAL INITIAL yes 
     LABEL "Sem Documento no Recebimento" 
     VIEW-AS TOGGLE-BOX
     SIZE 33.5 BY .88 NO-UNDO.

DEFINE VARIABLE c-dat-fim AS DATE FORMAT "99/99/9999" INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88.

DEFINE VARIABLE c-dat-ini AS DATE FORMAT "99/99/9999" INITIAL 01/01/001 
     LABEL "Data Emiss∆o":R17 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88.

DEFINE VARIABLE c-dep-fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-dep-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Dep¢sito" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-dtl-fim AS DATE FORMAT "99/99/9999" INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88.

DEFINE VARIABLE c-dtl-ini AS DATE FORMAT "99/99/9999" INITIAL 01/01/001 
     LABEL "Data Inspeá∆o":R16 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88.

DEFINE VARIABLE c-est-fim AS CHARACTER FORMAT "x(3)" INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE c-est-ini AS CHARACTER FORMAT "x(3)" 
     LABEL "Estabelecimento":R18 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE c-ite-fim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88.

DEFINE VARIABLE c-ite-ini AS CHARACTER FORMAT "x(16)" 
     LABEL "Item":R5 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88.

DEFINE VARIABLE c-resp-fim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-resp-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Respons†vel" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 DROP-TARGET NO-UNDO.

DEFINE VARIABLE i-fic-fim AS INTEGER FORMAT ">>>>,>>9" INITIAL 9999999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE i-fic-ini AS INTEGER FORMAT ">>>>,>>9" INITIAL 0 
     LABEL "Roteiro Inspeá∆o":R20 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE i-for-fim AS INTEGER FORMAT ">>>>>>>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 11.57 BY .88.

DEFINE VARIABLE i-for-ini AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Emitente":R10 
     VIEW-AS FILL-IN 
     SIZE 11.57 BY .88.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-24
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-25
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-26
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-27
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-28
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-29
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-30
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-31
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-32
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-33
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-34
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-35
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-36
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-37
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-executar 
     LABEL "Executar" 
     SIZE 10 BY 1.

DEFINE IMAGE im-pg-cla
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-imp
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-par
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

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY f-pg-sel FOR 
      ficha-cq, 
      docum-est SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-pg-cla
     rs-classif AT ROW 2 COL 5 HELP
          "Classificaá∆o para emiss∆o do relat¢rio" NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 75 BY 10.

DEFINE FRAME f-pg-imp
     rs-destino AT ROW 2.38 COL 3.29 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     bt-arquivo AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
     bt-config-impr AT ROW 3.58 COL 43.29 HELP
          "Configuraá∆o da impressora"
     c-arquivo AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rs-execucao AT ROW 5.75 COL 3 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-destino AT ROW 1.63 COL 3.86 NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 75 BY 10.

DEFINE FRAME f-relat
     l-nacional AT ROW 9.75 COL 4 WIDGET-ID 2
          LABEL "Nacional"
          VIEW-AS TOGGLE-BOX
          SIZE 13 BY .88
     bt-executar AT ROW 14.54 COL 3 HELP
          "Dispara a execuá∆o do relat¢rio"
     bt-cancelar AT ROW 14.54 COL 14 HELP
          "Cancelar"
     bt-ajuda AT ROW 14.54 COL 70 HELP
          "Ajuda"
     rt-folder AT ROW 2.5 COL 2
     rt-folder-left AT ROW 2.54 COL 2.14
     rt-folder-top AT ROW 2.54 COL 2.14
     rt-folder-right AT ROW 2.67 COL 80.43
     RECT-6 AT ROW 13.75 COL 2.14
     RECT-1 AT ROW 14.29 COL 2
     im-pg-cla AT ROW 1.5 COL 17.86
     im-pg-imp AT ROW 1.5 COL 49.29
     im-pg-par AT ROW 1.5 COL 33.57
     im-pg-sel AT ROW 1.5 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81.14 BY 15.13
         DEFAULT-BUTTON bt-executar.

DEFINE FRAME f-pg-sel
     c-est-ini AT ROW 2 COL 20 COLON-ALIGNED
     c-est-fim AT ROW 2 COL 51 COLON-ALIGNED NO-LABEL
     c-ite-ini AT ROW 3 COL 20 COLON-ALIGNED
     c-ite-fim AT ROW 3 COL 51 COLON-ALIGNED NO-LABEL
     i-for-ini AT ROW 4 COL 20 COLON-ALIGNED
     i-for-fim AT ROW 4 COL 51 COLON-ALIGNED NO-LABEL
     c-dat-ini AT ROW 5 COL 20 COLON-ALIGNED
     c-dat-fim AT ROW 5 COL 51 COLON-ALIGNED NO-LABEL
     i-fic-ini AT ROW 6 COL 20 COLON-ALIGNED HELP
          "N£mero do Roteiro de Inspeá∆o"
     i-fic-fim AT ROW 6 COL 51 COLON-ALIGNED HELP
          "N£mero do Roteiro de Inspeá∆o" NO-LABEL
     c-dtl-ini AT ROW 7 COL 20 COLON-ALIGNED
     c-dtl-fim AT ROW 7 COL 51 COLON-ALIGNED NO-LABEL
     c-dep-ini AT ROW 8 COL 20 COLON-ALIGNED
     c-dep-fim AT ROW 8 COL 51 COLON-ALIGNED NO-LABEL
     c-resp-ini AT ROW 9 COL 20 COLON-ALIGNED
     c-resp-fim AT ROW 9 COL 51 COLON-ALIGNED NO-LABEL
     IMAGE-1 AT ROW 2 COL 45
     IMAGE-2 AT ROW 2 COL 50
     IMAGE-24 AT ROW 3 COL 45
     IMAGE-25 AT ROW 3 COL 50
     IMAGE-26 AT ROW 4 COL 45
     IMAGE-27 AT ROW 4 COL 50
     IMAGE-28 AT ROW 5 COL 45
     IMAGE-29 AT ROW 5 COL 50
     IMAGE-30 AT ROW 6 COL 45
     IMAGE-31 AT ROW 6 COL 50
     IMAGE-32 AT ROW 7 COL 45
     IMAGE-33 AT ROW 7 COL 50
     IMAGE-34 AT ROW 8 COL 45
     IMAGE-35 AT ROW 8 COL 50
     IMAGE-36 AT ROW 9 COL 45
     IMAGE-37 AT ROW 9 COL 50
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 75 BY 10.

DEFINE FRAME f-pg-par
     l-so-insp AT ROW 2.25 COL 4
     l-analise AT ROW 2.33 COL 43
     l-so-nao AT ROW 3.25 COL 4
     l-pendente AT ROW 3.33 COL 43
     l-pendente-ret AT ROW 4.33 COL 43
     l-cancelado AT ROW 5.33 COL 43
     l-tudo AT ROW 6 COL 4
     l-terminado AT ROW 6.33 COL 43
     l-nacional AT ROW 9 COL 4 WIDGET-ID 2
     l-estrangeiro AT ROW 10 COL 4 WIDGET-ID 8
     txt-roteiro AT ROW 1.17 COL 3 NO-LABEL
     txt-inspecao AT ROW 1.25 COL 42 NO-LABEL
     txt-integracao AT ROW 4.92 COL 3 NO-LABEL
     txt-nacional AT ROW 7.92 COL 3 NO-LABEL WIDGET-ID 6
     rt-roteiro AT ROW 1.5 COL 2
     rt-roteiro-2 AT ROW 5.25 COL 2
     rt-roteiro-3 AT ROW 1.58 COL 41
     rt-roteiro-4 AT ROW 8.25 COL 2 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 75 BY 10.38.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Relat¢rio de Inspeá∆o"
         HEIGHT             = 15.21
         WIDTH              = 81.29
         MAX-HEIGHT         = 38.63
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 38.63
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB C-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-relat.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-pg-cla
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME f-pg-imp
                                                                        */
/* SETTINGS FOR FILL-IN text-destino IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Destino".

/* SETTINGS FOR FILL-IN text-modo IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Execuá∆o".

/* SETTINGS FOR FRAME f-pg-par
                                                                        */
/* SETTINGS FOR FILL-IN txt-inspecao IN FRAME f-pg-par
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       txt-inspecao:PRIVATE-DATA IN FRAME f-pg-par     = 
                "Situaá∆o Roteiro".

/* SETTINGS FOR FILL-IN txt-integracao IN FRAME f-pg-par
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       txt-integracao:PRIVATE-DATA IN FRAME f-pg-par     = 
                "Integraá∆o M¢dulo Recebimento".

/* SETTINGS FOR FILL-IN txt-nacional IN FRAME f-pg-par
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       txt-nacional:PRIVATE-DATA IN FRAME f-pg-par     = 
                "Origem Fornecedor".

/* SETTINGS FOR FILL-IN txt-roteiro IN FRAME f-pg-par
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       txt-roteiro:PRIVATE-DATA IN FRAME f-pg-par     = 
                "Situaá∆o Inspeá∆o".

/* SETTINGS FOR FRAME f-pg-sel
                                                                        */
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

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
     _TblList          = "mgind.ficha-cq,mgind.docum-est OF mgind.ficha-cq"
     _Query            is NOT OPENED
*/  /* FRAME f-pg-sel */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Relat¢rio de Inspeá∆o */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Relat¢rio de Inspeá∆o */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda C-Win
ON CHOOSE OF bt-ajuda IN FRAME f-relat /* Ajuda */
DO:
   {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo C-Win
ON CHOOSE OF bt-arquivo IN FRAME f-pg-imp
DO:
    {include/i-rparq.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar C-Win
ON CHOOSE OF bt-cancelar IN FRAME f-relat /* Cancelar */
DO:
   apply "close" to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-config-impr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-config-impr C-Win
ON CHOOSE OF bt-config-impr IN FRAME f-pg-imp
DO:
   {include/i-rpimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executar C-Win
ON CHOOSE OF bt-executar IN FRAME f-relat /* Executar */
DO:
   do  on error undo, return no-apply:
       run pi-executar.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-cla
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-cla C-Win
ON MOUSE-SELECT-CLICK OF im-pg-cla IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-imp C-Win
ON MOUSE-SELECT-CLICK OF im-pg-imp IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-par
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-par C-Win
ON MOUSE-SELECT-CLICK OF im-pg-par IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-sel C-Win
ON MOUSE-SELECT-CLICK OF im-pg-sel IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME rs-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-destino C-Win
ON VALUE-CHANGED OF rs-destino IN FRAME f-pg-imp
DO:
do  with frame f-pg-imp:
    case self:screen-value:
        when "1" then do:
            assign c-arquivo:sensitive    = no
                   bt-arquivo:visible     = no
                   bt-config-impr:visible = yes.
        end.
        when "2" then do:
            assign c-arquivo:sensitive     = yes
                   bt-arquivo:visible      = yes
                   bt-config-impr:visible  = no.
        end.
        when "3" then do:
            assign c-arquivo:sensitive     = no
                   bt-arquivo:visible      = no
                   bt-config-impr:visible  = no.
        end.
    end case.
end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-execucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-execucao C-Win
ON VALUE-CHANGED OF rs-execucao IN FRAME f-pg-imp
DO:
   {include/i-rprse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-cla
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

{utp/ut9000.i "ESCQP008" "2.00.00.000"}

/* inicializaá‰es do template de relat¢rio */
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

    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects C-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available C-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  DISPLAY l-nacional 
      WITH FRAME f-relat IN WINDOW C-Win.
  ENABLE im-pg-cla im-pg-imp im-pg-par im-pg-sel l-nacional bt-executar 
         bt-cancelar bt-ajuda 
      WITH FRAME f-relat IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  DISPLAY rs-classif 
      WITH FRAME f-pg-cla IN WINDOW C-Win.
  ENABLE rs-classif 
      WITH FRAME f-pg-cla IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-cla}
  DISPLAY rs-destino c-arquivo rs-execucao 
      WITH FRAME f-pg-imp IN WINDOW C-Win.
  ENABLE RECT-7 RECT-9 rs-destino bt-arquivo bt-config-impr c-arquivo 
         rs-execucao 
      WITH FRAME f-pg-imp IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-imp}
  DISPLAY l-so-insp l-analise l-so-nao l-pendente l-pendente-ret l-cancelado 
          l-tudo l-terminado l-nacional l-estrangeiro 
      WITH FRAME f-pg-par IN WINDOW C-Win.
  ENABLE rt-roteiro rt-roteiro-2 rt-roteiro-3 rt-roteiro-4 l-so-insp l-analise 
         l-so-nao l-pendente l-pendente-ret l-cancelado l-tudo l-terminado 
         l-nacional l-estrangeiro 
      WITH FRAME f-pg-par IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-par}
  DISPLAY c-est-ini c-est-fim c-ite-ini c-ite-fim i-for-ini i-for-fim c-dat-ini 
          c-dat-fim i-fic-ini i-fic-fim c-dtl-ini c-dtl-fim c-dep-ini c-dep-fim 
          c-resp-ini c-resp-fim 
      WITH FRAME f-pg-sel IN WINDOW C-Win.
  ENABLE IMAGE-1 IMAGE-2 IMAGE-24 IMAGE-25 IMAGE-26 IMAGE-27 IMAGE-28 IMAGE-29 
         IMAGE-30 IMAGE-31 IMAGE-32 IMAGE-33 IMAGE-34 IMAGE-35 IMAGE-36 
         IMAGE-37 c-est-ini c-est-fim c-ite-ini c-ite-fim i-for-ini i-for-fim 
         c-dat-ini c-dat-fim i-fic-ini i-fic-fim c-dtl-ini c-dtl-fim c-dep-ini 
         c-dep-fim c-resp-ini c-resp-fim 
      WITH FRAME f-pg-sel IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit C-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize C-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */    

{utp/ut9000.i "ESCQP008" "2.00.00.000"}

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
    /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar C-Win 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

do  on error undo, return error
    on stop  undo, return error:     

    {include/i-rpexa.i}

    if  input frame f-pg-imp rs-destino = 2 then do:
        run utp/ut-vlarq.p (input input frame f-pg-imp c-arquivo).
        if  return-value = "nok" then do:
            run utp/ut-msgs.p (input "show", input 73, input "").
            apply 'mouse-select-click' to im-pg-imp in frame f-relat.
            apply 'entry' to c-arquivo in frame f-pg-imp.
            return error.
        end.
    end.

    /* Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas
       devem apresentar uma mensagem de erro cadastrada, posicionar na p†gina 
       com problemas e colocar o focus no campo com problemas             */    

    create tt-param.
    assign tt-param.usuario        = c-seg-usuario
           tt-param.destino        = input frame f-pg-imp rs-destino
           tt-param.data-exec      = today
           tt-param.hora-exec      = time
           tt-param.classifica     = input frame f-pg-cla rs-classif
           tt-param.c-est-ini      = input frame f-pg-sel c-est-ini
           tt-param.c-est-fim      = input frame f-pg-sel c-est-fim
           tt-param.c-ite-ini      = input frame f-pg-sel c-ite-ini
           tt-param.c-ite-fim      = input frame f-pg-sel c-ite-fim
           tt-param.i-for-ini      = input frame f-pg-sel i-for-ini
           tt-param.i-for-fim      = input frame f-pg-sel i-for-fim
           tt-param.c-dat-ini      = input frame f-pg-sel c-dat-ini
           tt-param.c-dat-fim      = input frame f-pg-sel c-dat-fim
           tt-param.i-fic-ini      = input frame f-pg-sel i-fic-ini
           tt-param.i-fic-fim      = input frame f-pg-sel i-fic-fim
           tt-param.c-dtl-ini      = input frame f-pg-sel c-dtl-ini
           tt-param.c-dtl-fim      = input frame f-pg-sel c-dtl-fim           
           tt-param.c-dep-ini      = input frame f-pg-sel c-dep-ini
           tt-param.c-dep-fim      = input frame f-pg-sel c-dep-fim
           tt-param.c-resp-ini     = input frame f-pg-sel c-resp-ini
           tt-param.c-resp-fim     = input frame f-pg-sel c-resp-fim
           tt-param.l-so-insp      = input frame f-pg-par l-so-insp
           tt-param.l-so-nao       = input frame f-pg-par l-so-nao
           tt-param.l-tudo         = input frame f-pg-par l-tudo
           tt-param.c-classe       = entry((tt-param.classifica - 1) * 2 + 1,
                                           rs-classif:radio-buttons in frame f-pg-cla)
           tt-param.c-destino      = entry((tt-param.destino - 1) * 2 + 1,
                                           rs-destino:radio-buttons in frame f-pg-imp)
           tt-param.l-analise      = input frame f-pg-par l-analise
           tt-param.l-pendente     = input frame f-pg-par l-pendente
           tt-param.l-pendente-ret = input frame f-pg-par l-pendente-ret
           tt-param.l-cancelado    = input frame f-pg-par l-cancelado
           tt-param.l-terminado    = input frame f-pg-par l-terminado
           tt-param.l-nacional     = input frame f-pg-par l-nacional
           tt-param.l-estrangeiro  = input frame f-pg-par l-estrangeiro.

    if  tt-param.destino = 1 then
        assign tt-param.arquivo = "".
    else
    if  tt-param.destino = 2 then 
        assign tt-param.arquivo = input frame f-pg-imp c-arquivo.
    else
        assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp".

    /* Coloque aqui a l¢gica de gravaá∆o dos parÉmtros e seleá∆o na temp-table
       tt-param */ 

    IF tt-param.arquivo = "":U THEN
        ASSIGN tt-param.arquivo-csv = SESSION:TEMP-DIRECTORY + c-programa-mg97 + ".txt".
    ELSE
        ASSIGN tt-param.arquivo-csv = REPLACE(tt-param.arquivo, ENTRY(NUM-ENTRIES(tt-param.arquivo, ".":U), tt-param.arquivo, ".":U), "txt":U).

    {include/i-rpexb.i}

    if  session:set-wait-state("general") then.

    {include/i-rprun.i esp/cqp/escqp008rp.p}

    {include/i-rpexc.i}

    if  session:set-wait-state("") then.

    /*{include/i-rptrm.i}*/
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-pagina C-Win 
PROCEDURE pi-troca-pagina :
/*------------------------------------------------------------------------------
  Purpose: Gerencia a Troca de P†gina (folder)   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{include/i-rptrp.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records C-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "ficha-cq"}
  {src/adm/template/snd-list.i "docum-est"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed C-Win 
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


