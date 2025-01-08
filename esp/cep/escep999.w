&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i ESCEP999 2.00.00.023}  /*** 010023 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ESCEP999 MCE}
&ENDIF

{cdp/cdcfgdis.i} /*  defini‡Æo e pr‚-processadores distribui‡Æo */

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
/* Obs: Retirar o valor do preprocessador para as p ginas que nÆo existirem  */

&GLOBAL-DEFINE PGSEL f-pg-sel
&GLOBAL-DEFINE PGCLA 
&GLOBAL-DEFINE PGPAR f-pg-par
&GLOBAL-DEFINE PGDIG f-pg-dig
&GLOBAL-DEFINE PGIMP f-pg-imp

/* Include Com as Vari veis Globais */
{utp/ut-glob.i}

/* Parameters Definitions ---                                           */
{cdp/cdcfgmat.i}
/* Temporary Table Definitions ---                                      */

define temp-table tt-param
    field destino          as integer
    field arquivo          as char
    field usuario          as char
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field i-ge-ini         as integer format ">9"
    field i-ge-fim         as integer format ">9"
    field c-estab-ini      as char    format "x(03)"
    field c-estab-fim      as char    format "x(03)"
    field c-item-ini       as char    format "x(16)"
    field c-item-fim       as char    format "x(16)"
    field l-critico        as logical
    field l-acerto         as logical
    field l-pagina         as logical
    field i-moeda          as integer format "9"
    field c-moeda          as char    format "x(10)"  
    field i-mo             as integer
    FIELD l-parametro      AS LOGICAL 
    &IF '{&BF_MAT_VERSAO_EMS}' >= '2.04' &THEN
        FIELD c-fm-cod-ini LIKE ITEM.fm-codigo
        FIELD c-fm-cod-fim LIKE ITEM.fm-codigo
    &ENDIF.    

define temp-table tt-digita
    field cod-estabel           like movto-estoq.cod-estabel
    field nome                  as character format "x(40)"
    field data-ini              like param-estoq.ult-fech-dia
    field data-fim              like param-estoq.ult-fech-dia
    field ult-per-fech          like param-estoq.ult-per-fech
    field mensal-ate            like param-estoq.mensal-ate
    field l-processou           like item.loc-unica
    index codigo cod-estabel.

define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.

/* Local Variable Definitions ---                                       */

def new shared var  i-mo            as integer init 1.
def new shared var  i-per-corrente  as integer.
def new shared var  i-ano-corrente  as integer.
def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-cod-estab-usuar  as char    no-undo.

def var i-moeda as integer no-undo.
def var c-moeda as char    no-undo.

def var i-tp-fech          as i init 1    no-undo.
def var r-tt-digita        as rowid       no-undo.
def var c-per-aux          like param-estoq.ult-per-fech no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
def var c-estabelec        as char format "x(05)" no-undo.
&ELSE
def var c-estabelec        as char format "x(3)" no-undo.
&ENDIF
def var da-iniper-fech     like param-estoq.ult-fech-dia no-undo.
def var da-fimper-fech     like param-estoq.ult-fech-dia no-undo.
def var c-empresa          as character format "x(40)"   no-undo.
DEF VAR da-iniper-x        AS DATE FORMAT 99/99/9999      NO-UNDO.
DEF VAR da-fimper-x        AS DATE FORMAT 99/99/9999      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-pg-dig
&Scoped-define BROWSE-NAME br-digita

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-digita

/* Definitions for BROWSE br-digita                                     */
&Scoped-define FIELDS-IN-QUERY-br-digita tt-digita.cod-estabel tt-digita.nome tt-digita.ult-per-fech tt-digita.mensal-ate   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-digita tt-digita.cod-estabel   
&Scoped-define ENABLED-TABLES-IN-QUERY-br-digita tt-digita
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br-digita tt-digita
&Scoped-define SELF-NAME br-digita
&Scoped-define QUERY-STRING-br-digita FOR EACH tt-digita
&Scoped-define OPEN-QUERY-br-digita OPEN QUERY br-digita FOR EACH tt-digita.
&Scoped-define TABLES-IN-QUERY-br-digita tt-digita
&Scoped-define FIRST-TABLE-IN-QUERY-br-digita tt-digita


/* Definitions for FRAME f-pg-dig                                       */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-pg-dig ~
    ~{&OPEN-QUERY-br-digita}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br-digita bt-inserir bt-alterar bt-retirar ~
bt-salvar bt-recuperar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-alterar 
     LABEL "Alterar" 
     SIZE 15 BY 1.

DEFINE BUTTON bt-inserir 
     LABEL "Inserir" 
     SIZE 15 BY 1.

DEFINE BUTTON bt-recuperar 
     LABEL "Recuperar" 
     SIZE 15 BY 1.

DEFINE BUTTON bt-retirar 
     LABEL "Retirar" 
     SIZE 15 BY 1.

DEFINE BUTTON bt-salvar 
     LABEL "Salvar" 
     SIZE 15 BY 1.

DEFINE BUTTON bt-arquivo 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-config-impr 
     IMAGE-UP FILE "image~\im-cfprt":U
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

DEFINE VARIABLE text-parametro AS CHARACTER FORMAT "X(256)":U INITIAL "Parƒmetros de ImpressÆo" 
      VIEW-AS TEXT 
     SIZE 24.86 BY .67 NO-UNDO.

DEFINE VARIABLE rs-destino AS INTEGER INITIAL 3 
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

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 1.71.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 1.71.

DEFINE VARIABLE l-parametro AS LOGICAL INITIAL yes 
     LABEL "Imprimir Parƒmetros" 
     VIEW-AS TOGGLE-BOX
     SIZE 32.57 BY .83 NO-UNDO.

DEFINE VARIABLE cb-moeda AS CHARACTER FORMAT "X(256)":U 
     LABEL "Moeda" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 63.57 BY 4.

DEFINE VARIABLE l-acerto AS LOGICAL INITIAL yes 
     LABEL "Acertados" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.72 BY .75 NO-UNDO.

DEFINE VARIABLE l-critico AS LOGICAL INITIAL yes 
     LABEL "Cr¡ticos" 
     VIEW-AS TOGGLE-BOX
     SIZE 12.43 BY .75 NO-UNDO.

DEFINE VARIABLE l-pagina AS LOGICAL INITIAL no 
     LABEL "Salta p g. a cada item." 
     VIEW-AS TOGGLE-BOX
     SIZE 25.72 BY .75 NO-UNDO.

DEFINE VARIABLE c-estab-fim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-estab-ini LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-fm-fim AS CHARACTER FORMAT "X(08)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-fm-ini AS CHARACTER FORMAT "X(08)":U 
     LABEL "Fam¡lia" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-item-fim AS CHARACTER FORMAT "x(16)" INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-item-ini AS CHARACTER FORMAT "x(16)" INITIAL ? 
     LABEL "Item":R5 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE i-ge-fim AS INTEGER FORMAT ">9" INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE i-ge-ini AS INTEGER FORMAT ">9" INITIAL ? 
     LABEL "Grupo Estoque":R16 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image~\im-las":U
     SIZE 2.72 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image~\im-las":U
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

DEFINE IMAGE im-pg-dig
     FILENAME "image~\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-imp
     FILENAME "image~\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-par
     FILENAME "image~\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-sel
     FILENAME "image~\im-fldup":U
     SIZE 15.86 BY 1.21.

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
DEFINE QUERY br-digita FOR 
      tt-digita SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-digita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-digita C-Win _FREEFORM
  QUERY br-digita DISPLAY
      tt-digita.cod-estabel  FORMAT "x(5)" label "Estab" 
      tt-digita.nome         label "Nome"
      tt-digita.ult-per-fech label "Ult Per Fech"
      tt-digita.mensal-ate   label "M‚dio At‚" 
ENABLE
      tt-digita.cod-estabel
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 75 BY 9
         BGCOLOR 15 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-pg-par
     l-critico AT ROW 3.75 COL 26.86
     l-acerto AT ROW 4.58 COL 26.86
     l-pagina AT ROW 5.38 COL 26.86
     cb-moeda AT ROW 6.25 COL 25 COLON-ALIGNED
     RECT-15 AT ROW 3.5 COL 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 75 BY 10.

DEFINE FRAME f-pg-imp
     rs-destino AT ROW 2.38 COL 3.29 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     bt-config-impr AT ROW 3.58 COL 43.29 HELP
          "Configura‡Æo da impressora"
     bt-arquivo AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
     c-arquivo AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rs-execucao AT ROW 5.75 COL 3 HELP
          "Modo de Execu‡Æo" NO-LABEL
     l-parametro AT ROW 7.96 COL 3.57
     text-destino AT ROW 1.63 COL 3.86 NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     text-parametro AT ROW 7.21 COL 1.43 COLON-ALIGNED NO-LABEL
     RECT-10 AT ROW 7.46 COL 2.14
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 73.72 BY 10.

DEFINE FRAME f-pg-sel
     c-estab-ini AT ROW 1.75 COL 22 COLON-ALIGNED
     c-estab-fim AT ROW 1.75 COL 51 COLON-ALIGNED NO-LABEL
     i-ge-ini AT ROW 2.75 COL 22 COLON-ALIGNED
     i-ge-fim AT ROW 2.75 COL 53 NO-LABEL
     c-item-ini AT ROW 3.75 COL 22 COLON-ALIGNED
     c-item-fim AT ROW 3.75 COL 51 COLON-ALIGNED NO-LABEL
     c-fm-ini AT ROW 4.75 COL 22 COLON-ALIGNED
     c-fm-fim AT ROW 4.75 COL 51 COLON-ALIGNED NO-LABEL
     IMAGE-1 AT ROW 1.75 COL 44.29
     IMAGE-2 AT ROW 1.75 COL 49.86
     IMAGE-3 AT ROW 2.75 COL 44.29
     IMAGE-4 AT ROW 2.75 COL 49.86
     IMAGE-5 AT ROW 3.75 COL 44.29
     IMAGE-6 AT ROW 3.75 COL 49.86
     IMAGE-7 AT ROW 4.75 COL 44
     IMAGE-8 AT ROW 4.75 COL 50
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.83
         SIZE 76.86 BY 10.54.

DEFINE FRAME f-relat
     bt-executar AT ROW 14.54 COL 3 HELP
          "Dispara a execu‡Æo do relat¢rio"
     bt-cancelar AT ROW 14.54 COL 14 HELP
          "Cancelar"
     bt-ajuda AT ROW 14.54 COL 70 HELP
          "Ajuda"
     RECT-6 AT ROW 13.75 COL 2.14
     RECT-1 AT ROW 14.29 COL 2
     rt-folder-right AT ROW 2.67 COL 80.43
     rt-folder AT ROW 2.5 COL 2
     rt-folder-top AT ROW 2.54 COL 2.14
     rt-folder-left AT ROW 2.54 COL 2.14
     im-pg-dig AT ROW 1.5 COL 33.57
     im-pg-imp AT ROW 1.5 COL 49.29
     im-pg-par AT ROW 1.5 COL 17.86
     im-pg-sel AT ROW 1.5 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81.14 BY 15.13
         DEFAULT-BUTTON bt-executar.

DEFINE FRAME f-pg-dig
     br-digita AT ROW 1 COL 1
     bt-inserir AT ROW 10 COL 1
     bt-alterar AT ROW 10 COL 16
     bt-retirar AT ROW 10 COL 31
     bt-salvar AT ROW 10 COL 46
     bt-recuperar AT ROW 10 COL 61
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 76.5 BY 10.5.


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
         TITLE              = "Relat¢rio Itens Cr¡ticos"
         HEIGHT             = 15.13
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
/* REPARENT FRAME */
ASSIGN FRAME f-pg-dig:FRAME = FRAME f-relat:HANDLE.

/* SETTINGS FOR FRAME f-pg-dig
                                                                        */
/* BROWSE-TAB br-digita 1 f-pg-dig */
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
                "Execu‡Æo".

/* SETTINGS FOR FILL-IN text-parametro IN FRAME f-pg-imp
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME f-pg-par
                                                                        */
/* SETTINGS FOR FRAME f-pg-sel
                                                                        */
/* SETTINGS FOR FILL-IN c-estab-fim IN FRAME f-pg-sel
   LIKE = mgadm.estabelec.cod-estabel EXP-SIZE                          */
/* SETTINGS FOR FILL-IN c-estab-ini IN FRAME f-pg-sel
   LIKE = mgadm.estabelec.cod-estabel EXP-SIZE                          */
/* SETTINGS FOR FILL-IN i-ge-fim IN FRAME f-pg-sel
   ALIGN-L                                                              */
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

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-digita
/* Query rebuild information for BROWSE br-digita
     _START_FREEFORM
 OPEN QUERY br-digita FOR EACH tt-digita.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-digita */
&ANALYZE-RESUME

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

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Relat¢rio Itens Cr¡ticos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Relat¢rio Itens Cr¡ticos */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-digita
&Scoped-define SELF-NAME br-digita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita C-Win
ON DEL OF br-digita IN FRAME f-pg-dig
DO:
   apply 'choose' to bt-retirar in frame f-pg-dig.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita C-Win
ON END-ERROR OF br-digita IN FRAME f-pg-dig
ANYWHERE 
DO:
    if  br-digita:new-row in frame f-pg-dig then do:
        if  avail tt-digita then
            delete tt-digita.
        if  br-digita:delete-current-row() in frame f-pg-dig then. 
    end.                                                               
    else do:
        get current br-digita.
        display tt-digita.cod-estabel
                tt-digita.nome with browse br-digita. 
    end.
    return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita C-Win
ON ENTER OF br-digita IN FRAME f-pg-dig
ANYWHERE
DO:
  apply 'tab' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita C-Win
ON INS OF br-digita IN FRAME f-pg-dig
DO:
   apply 'choose' to bt-inserir in frame f-pg-dig.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita C-Win
ON OFF-END OF br-digita IN FRAME f-pg-dig
DO:
   apply 'entry' to bt-inserir in frame f-pg-dig.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita C-Win
ON OFF-HOME OF br-digita IN FRAME f-pg-dig
DO:
  apply 'entry' to bt-recuperar in frame f-pg-dig.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita C-Win
ON ROW-ENTRY OF br-digita IN FRAME f-pg-dig
DO:
   /* trigger para inicializar campos da temp table de digita‡Æo */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita C-Win
ON ROW-LEAVE OF br-digita IN FRAME f-pg-dig
DO:
    /*  aqui que a grava‡Æo da linha da temp-table ‚ efetivada.
       Por‚m as valida‡äes dos registros devem ser feitas na procedure pi-executar,
       no local indicado pelo coment rio */
&if defined(bf_mat_fech_estab) &then    
    if br-digita:NEW-ROW in frame f-pg-dig then 
    do transaction on error undo, return no-apply:
        create tt-digita.
        assign input browse br-digita tt-digita.cod-estabel.
        if avail estabelec then
            assign tt-digita.nome = estabelec.nome.
        if avail estab-mat then
            assign tt-digita.ult-per-fech = estab-mat.ult-per-fech
                   tt-digita.mensal-ate   = estab-mat.mensal-ate.
    end.
    else do transaction on error undo, return no-apply:
        assign input browse br-digita tt-digita.cod-estabel.
        if avail estabelec then
            assign tt-digita.nome = estabelec.nome.
        if avail estab-mat then
            assign tt-digita.ult-per-fech = estab-mat.ult-per-fech
                   tt-digita.mensal-ate   = estab-mat.mensal-ate.

        for first estabelec fields(cod-estabel nome) where
            estabelec.cod-estabel = input browse br-digita tt-digita.cod-estabel
            no-lock: end.
        if avail estabelec then
            assign tt-digita.nome:screen-value in browse br-digita = estabelec.nome.
        for first estab-mat fields(cod-estabel ult-per-fech mensal-ate) where
            estab-mat.cod-estabel = input browse br-digita tt-digita.cod-estabel
            no-lock: end.
        if avail estab-mat then
            assign tt-digita.ult-per-fech:screen-value in browse br-digita = estab-mat.ult-per-fech
                   tt-digita.mensal-ate:screen-value in browse br-digita   = string(estab-mat.mensal-ate).

    end.    
    if br-digita:new-row then br-digita:CREATE-RESULT-LIST-ENTRY() in frame f-pg-dig.
&endif   
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


&Scoped-define FRAME-NAME f-pg-dig
&Scoped-define SELF-NAME bt-alterar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-alterar C-Win
ON CHOOSE OF bt-alterar IN FRAME f-pg-dig /* Alterar */
DO:
   apply 'entry' to tt-digita.cod-estabel in browse br-digita. 
   if can-find(first tt-digita) then
       assign c-estab-ini:sensitive in frame f-pg-sel = no
              c-estab-fim:sensitive in frame f-pg-sel = no
              c-estab-ini:screen-value in frame f-pg-sel = " "
              c-estab-fim:screen-value in frame f-pg-sel    = " ".
   else
       assign c-estab-ini:sensitive in frame f-pg-sel = yes
              c-estab-fim:sensitive in frame f-pg-sel = yes
              c-estab-ini:screen-value in frame f-pg-sel = " "
&IF "{&mguni_version}" >= "2.071" &THEN
              c-estab-fim:screen-value in frame f-pg-sel    = "ZZZZZ".
&ELSE
              c-estab-fim:screen-value in frame f-pg-sel    = "ZZZ".
&ENDIF
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


&Scoped-define FRAME-NAME f-pg-dig
&Scoped-define SELF-NAME bt-inserir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-inserir C-Win
ON CHOOSE OF bt-inserir IN FRAME f-pg-dig /* Inserir */
DO:
    assign bt-alterar:SENSITIVE in frame f-pg-dig = yes
           bt-retirar:SENSITIVE in frame f-pg-dig = yes
           bt-salvar:SENSITIVE in frame f-pg-dig  = yes.

    if num-results("br-digita") > 0 then
        br-digita:INSERT-ROW("after") in frame f-pg-dig.
    else do transaction:
        create tt-digita.

        open query br-digita for each tt-digita.

        apply "entry" to tt-digita.cod-estabel in browse br-digita. 
    end.
    if can-find(first tt-digita) then
        assign c-estab-ini:sensitive in frame f-pg-sel = no
               c-estab-fim:sensitive in frame f-pg-sel = no
               c-estab-ini:screen-value in frame f-pg-sel = " "
               c-estab-fim:screen-value in frame f-pg-sel    = " ".
    else
        assign c-estab-ini:sensitive in frame f-pg-sel = yes
               c-estab-fim:sensitive in frame f-pg-sel = yes
               c-estab-ini:screen-value in frame f-pg-sel = " "
&IF "{&mguni_version}" >= "2.071" &THEN
               c-estab-fim:screen-value in frame f-pg-sel    = "ZZZZZ".
&ELSE
               c-estab-fim:screen-value in frame f-pg-sel    = "ZZZ".
&ENDIF

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-recuperar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-recuperar C-Win
ON CHOOSE OF bt-recuperar IN FRAME f-pg-dig /* Recuperar */
DO:
    {include/i-rprcd.i}
    if can-find(first tt-digita) then
        assign c-estab-ini:sensitive in frame f-pg-sel = no
               c-estab-fim:sensitive in frame f-pg-sel = no
               c-estab-ini:screen-value in frame f-pg-sel = " "
               c-estab-fim:screen-value in frame f-pg-sel    = " ".
    else
        assign c-estab-ini:sensitive in frame f-pg-sel = yes
               c-estab-fim:sensitive in frame f-pg-sel = yes
               c-estab-ini:screen-value in frame f-pg-sel = " "
&IF "{&mguni_version}" >= "2.071" &THEN
               c-estab-fim:screen-value in frame f-pg-sel    = "ZZZZZ".
&ELSE
               c-estab-fim:screen-value in frame f-pg-sel    = "ZZZ".
&ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-retirar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-retirar C-Win
ON CHOOSE OF bt-retirar IN FRAME f-pg-dig /* Retirar */
DO:


    if  br-digita:num-selected-rows > 0 then do on error undo, return no-apply:
        delete tt-digita.
        if  br-digita:delete-current-row() in frame f-pg-dig then.
    end.

    if num-results("br-digita") = 0 then
        assign bt-alterar:SENSITIVE in frame f-pg-dig = no
               bt-retirar:SENSITIVE in frame f-pg-dig = no
               bt-salvar:SENSITIVE in frame f-pg-dig  = no.


    find first tt-digita no-lock no-error.
    if avail tt-digita then do:
        assign c-estab-ini:sensitive in frame f-pg-sel = no
               c-estab-fim:sensitive in frame f-pg-sel = no
               c-estab-ini:screen-value in frame f-pg-sel = " "
               c-estab-fim:screen-value in frame f-pg-sel    = " ".

        /*for first estab-mat fields(cod-estabel ult-per-fech) where
            estab-mat.cod-estabel = tt-digita.cod-estabel no-lock: end.

        if avail estab-mat then do:            

            run cdp/cdapi005.p (input  estab-mat.ult-per-fech,
                                output da-iniper-x,
                                output da-fimper-x,
                                output i-per-corrente,
                                output i-ano-corrente,
                                output da-iniper-fech,
                                output da-fimper-fech).

            assign c-periodo = string(i-ano-corrente,"9999") + string(i-per-corrente,"99")
                   i-mes-periodo = i-per-corrente
                   i-ano-periodo = i-ano-corrente
                   i-numper-x    = i-per-corrente
                   da-data-aux   = da-iniper-x
                   da-data-aux-2 = da-fimper-x
                   da-data-val   = today
                   c-periodo:screen-value in frame f-pg-par = string(i-ano-periodo,"9999")
                                                            + string(i-mes-periodo,"99").                              
        end.*/
    end.
    else
        assign c-estab-ini:sensitive in frame f-pg-sel = yes
               c-estab-fim:sensitive in frame f-pg-sel = yes
               c-estab-ini:screen-value in frame f-pg-sel = " "
&IF "{&mguni_version}" >= "2.071" &THEN
               c-estab-fim:screen-value in frame f-pg-sel    = "ZZZZZ".               
&ELSE
               c-estab-fim:screen-value in frame f-pg-sel    = "ZZZ".               
&ENDIF


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-salvar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-salvar C-Win
ON CHOOSE OF bt-salvar IN FRAME f-pg-dig /* Salvar */
DO:
   {include/i-rpsvd.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME im-pg-dig
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-dig C-Win
ON MOUSE-SELECT-CLICK OF im-pg-dig IN FRAME f-relat
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


&Scoped-define FRAME-NAME f-pg-dig
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

{utp/ut9000.i "ESCEP999" "2.00.00.023"}

/* inicializa‡äes do template de relat¢rio */
{include/i-rpini.i}

/* Carrega o combo-box Moeda */
find first moeda where moeda.mo-codigo = 0 no-lock no-error.
  assign cb-moeda:list-items in frame f-pg-par = "0 - " + moeda.descricao.

  find first param-estoq no-lock no-error.

  if avail param-estoq then do: 
     if param-estoq.tem-moeda1 then do:
        find first moeda where moeda.mo-codigo = param-estoq.moeda1 no-lock no-error.
        assign cb-moeda:list-items in frame f-pg-par =
               cb-moeda:list-items in frame f-pg-par + ",1 - " + moeda.descricao.
     end.

     if param-estoq.tem-moeda2 then do:
        find first moeda where moeda.mo-codigo = param-estoq.moeda2 no-lock no-error.
        assign cb-moeda:list-items in frame f-pg-par =
               cb-moeda:list-items in frame f-pg-par + ",2 - " + moeda.descricao.
     end.
  end.

  assign cb-moeda:screen-value in frame f-pg-par = cb-moeda:entry(1).

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

/************************** In¡cio consistˆncia p/ chamada da tela ***********************/ 

if  not avail param-global then    
    find first param-global no-lock no-error.

    if available param-global then 
          assign c-empresa = param-global.grupo.
    else do:
          run utp/ut-msgs.p(input "show",
                            input  16,
                            input "").    
          return.
    end. 

if  not avail param-estoq then     
find first param-estoq no-lock no-error.

     if not available param-estoq then do:
          run utp/ut-msgs.p(input "show",
                            input  1059,
                            input "").    
          apply "close" to this-procedure.
     end. 

if avail param-estoq then 
  {cep/ce9998.i}.


assign i-ge-ini:screen-value in frame f-pg-sel = string(00)
       i-ge-fim:screen-value in frame f-pg-sel = string(99)
       c-estab-ini:screen-value in frame f-pg-sel = string("")
&IF "{&mguni_version}" >= "2.071" &THEN
       c-estab-fim:screen-value in frame f-pg-sel = string("ZZZZZ")
&ELSE
       c-estab-fim:screen-value in frame f-pg-sel = string("ZZZ")
&ENDIF
       c-item-ini:screen-value in frame f-pg-sel = string("")
       c-item-fim:screen-value in frame f-pg-sel = string("ZZZZZZZZZZZZZZZZ")
       l-critico:screen-value in frame f-pg-par = string("yes")
       l-acerto:screen-value in frame f-pg-par = string("yes").                    

&if defined(bf_mat_fech_estab) &then
    if param-estoq.tp-fech = 2 then 
        assign i-tp-fech = 2.
&endif.

if  avail param-estoq then
    assign c-cod-estab-usuar = param-estoq.estabel-pad.

&if defined(bf_dis_usuario_estab) &then
    if  can-find (funcao where funcao.cd-funcao = "fn-estab-usuario"
                        and funcao.ativo) then do:
        run cdp/cd8702.p (input c-seg-usuario,
                          input-output c-cod-estab-usuar).
    end.
&endif

if i-tp-fech = 1 then do:
    if param-estoq.ult-per-fech = "" or
       param-estoq.ult-per-fech = ? then do:
        run utp/ut-msgs.p (input "show", input 17109, input "").
        apply "close" to this-procedure.   
        return.    
    end.

    run cdp/cdapi005.p (input  param-estoq.ult-per-fech,
                        output da-iniper-x,
                        output da-fimper-x,
                        output i-per-corrente,
                        output i-ano-corrente,
                        output da-iniper-fech,
                        output da-fimper-fech).


end.
else do:
    &if defined(bf_mat_fech_estab) &then
        for first estab-mat fields(cod-estabel ult-per-fech mensal-ate) where
            estab-mat.cod-estabel = c-cod-estab-usuar
            no-lock: end.

        run cdp/cdapi005.p (input  estab-mat.ult-per-fech,
                            output da-iniper-x,
                            output da-fimper-x,
                            output i-per-corrente,
                            output i-ano-corrente,
                            output da-iniper-fech,
                            output da-fimper-fech).        
    &endif
end.
if i-per-corrente = ? or 
   i-ano-corrente = 0 then do:
    run utp/ut-msgs.p ("show",16459,"").
    apply "close" to this-procedure.   
    return.    
end.    

&if defined(bf_mat_fech_estab) &then
    pause 0.
    /* Desabilita Digitacao para o EMS 2.04 com o tipo de fechamento "éNICO" */
    if param-estoq.tp-fech = 1 then do:
        def var wh-label-dig1 as widget-handle no-undo.
        assign im-pg-dig:sensitive in frame f-relat = no.
        run utp/ut-liter.p (input "Digita‡Æo",
                            input "*",
                            input "R").
        create text wh-label-dig1
        assign frame        = frame f-relat:handle
               format       = "x(9)"
               font         = 1
               screen-value = return-value
               width        = 10
               row          = 1.8
               col          = im-pg-dig:col in frame f-relat + 1.7
               fgcolor      = 7
               visible      = yes.
    end.
&else
    pause 0.    
    /* Desabilita Digitacao para o EMS 2.00 */
    def var wh-label-dig1 as widget-handle no-undo.
    assign im-pg-dig:sensitive in frame f-relat = no.
    run utp/ut-liter.p (input "Digita‡Æo",
                        input "*",
                        input "R").
    create text wh-label-dig1
    assign frame        = frame f-relat:handle
           format       = "x(9)"
           font         = 1
           screen-value = return-value
           width        = 10
           row          = 1.8
           col          = im-pg-dig:col in frame f-relat + 1.7
           fgcolor      = 7
           visible      = yes.
&endif

/************************** Fim consistˆncia p/ chamada da tela ***********************/ 

    {utp/ut-liter.i Estabelecimento * R}
    assign c-estab-ini:label in frame f-pg-sel = trim(return-value).

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
  ENABLE im-pg-dig im-pg-imp im-pg-par im-pg-sel bt-executar bt-cancelar 
         bt-ajuda 
      WITH FRAME f-relat IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  DISPLAY c-estab-ini c-estab-fim i-ge-ini i-ge-fim c-item-ini c-item-fim 
          c-fm-ini c-fm-fim 
      WITH FRAME f-pg-sel IN WINDOW C-Win.
  ENABLE IMAGE-1 IMAGE-2 IMAGE-3 IMAGE-4 IMAGE-5 IMAGE-6 IMAGE-7 IMAGE-8 
         c-estab-ini c-estab-fim i-ge-ini i-ge-fim c-item-ini c-item-fim 
         c-fm-ini c-fm-fim 
      WITH FRAME f-pg-sel IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
  ENABLE br-digita bt-inserir bt-alterar bt-retirar bt-salvar bt-recuperar 
      WITH FRAME f-pg-dig IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-dig}
  DISPLAY rs-destino c-arquivo rs-execucao l-parametro text-parametro 
      WITH FRAME f-pg-imp IN WINDOW C-Win.
  ENABLE RECT-10 RECT-7 RECT-9 rs-destino bt-config-impr bt-arquivo c-arquivo 
         rs-execucao l-parametro 
      WITH FRAME f-pg-imp IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-imp}
  DISPLAY l-critico l-acerto l-pagina cb-moeda 
      WITH FRAME f-pg-par IN WINDOW C-Win.
  ENABLE RECT-15 l-critico l-acerto l-pagina cb-moeda 
      WITH FRAME f-pg-par IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-par}
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

  /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    &IF '{&BF_MAT_VERSAO_EMS}' < '2.04' &THEN
        ASSIGN c-fm-ini:VISIBLE  IN FRAME f-pg-sel = NO
               c-fm-fim:VISIBLE  IN FRAME f-pg-sel = NO
               image-7:VISIBLE   IN FRAME f-pg-sel = NO
               image-8:VISIBLE   IN FRAME f-pg-sel = NO.
    &ENDIF  
    
    &IF "{&mguni_version}" >= "2.071" &THEN
      assign c-estab-fim:screen-value in frame f-pg-sel = "ZZZZZ"
             tt-digita.cod-estabel:WIDTH IN BROWSE br-digita = 9.
    &ELSE
      assign c-estab-fim:screen-value in frame f-pg-sel = "ZZZ".
    &ENDIF
    
      assign tt-digita.mensal-ate:width in browse br-digita = 10.
    
   


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

/*********  In¡cio da Valida‡Æo p/ a sele‡Æo  ***********/    

if  input frame f-pg-sel c-estab-ini > input frame f-pg-sel c-estab-fim  then do:
        run utp/ut-msgs.p (input "show",
                           input 1352,
                           input c-estab-ini:label in frame f-pg-sel + "~~" +
                                 c-estab-ini:label in frame f-pg-sel).
        apply 'mouse-select-click' to im-pg-sel in frame f-relat.
        apply 'entry' to c-estab-ini in frame f-pg-sel.                   
        return error.
end.

if  input frame f-pg-sel i-ge-ini > input frame f-pg-sel i-ge-fim  then do:
       run utp/ut-msgs.p (input "show",
                          input 1352,
                          input i-ge-ini:label in frame f-pg-sel + "~~" +
                                i-ge-ini:label in frame f-pg-sel).
       apply 'mouse-select-click' to im-pg-sel in frame f-relat.
       apply 'entry' to i-ge-ini in frame f-pg-sel.                   
       return error.
end.

if  input frame f-pg-sel c-item-ini > input frame f-pg-sel c-item-fim  then do:
       run utp/ut-msgs.p (input "show",
                          input 1352,
                          input c-item-ini:label in frame f-pg-sel + "~~" +
                                c-item-ini:label in frame f-pg-sel).
       apply 'mouse-select-click' to im-pg-sel in frame f-relat.
       apply 'entry' to c-item-ini in frame f-pg-sel.                   
       return error.
end. 

/*********  Fim da Valida‡Æo p/ a sele‡Æo  ***********/  

/*********  In¡cio da Valida‡Æo p/ os parƒmetros  ***********/  

/*********  Fim da Valida‡Æo p/ os parƒmetros  ***********/ 

    if  input frame f-pg-imp rs-destino = 2 then do:
        run utp/ut-vlarq.p (input input frame f-pg-imp c-arquivo).
        if  return-value = "nok" then do:
            run utp/ut-msgs.p (input "show",
                               input 73,
                               input "").
            apply 'mouse-select-click' to im-pg-imp in frame f-relat.
            apply 'entry' to c-arquivo in frame f-pg-imp.                   
            return error.
        end.
    end.

    &if defined(bf_mat_fech_estab) &then
        def var c-ult-per-fech  like param-estoq.ult-per-fech no-undo.
        def var c-estabelec-aux like estabelec.cod-estabel    no-undo.

        def buffer b-estab-mat for estab-mat.

        assign c-per-aux = ?
               c-estabelec = ?.

        if  param-estoq.tp-fech = 2 then do:

            if not can-find(first tt-digita) then do:
                /*****************************************************************
                **                      EMS 2.04 ou superior                    **
                ** Verifica se os estabelecimentos da faixa possuem os mesmos   **
                ** periodos em aberto no estoque                                **
                *****************************************************************/

                for each estab-mat 
                   where estab-mat.cod-estabel >= input frame f-pg-sel c-estab-ini
                     and estab-mat.cod-estabel <= input frame f-pg-sel c-estab-fim no-lock:

                    if c-per-aux = ? then do:
                        assign c-per-aux   = estab-mat.ult-per-fech
                               c-estabelec = estab-mat.cod-estabel.
                        run cdp/cdapi005.p (input  estab-mat.ult-per-fech,
                                            output da-iniper-x,
                                            output da-fimper-x,
                                            output i-per-corrente,
                                            output i-ano-corrente,
                                            output da-iniper-fech,
                                            output da-fimper-fech).
                    end.
                    else do:
                        run cdp/cdapi005.p (input  estab-mat.ult-per-fech,
                                            output da-iniper-x,
                                            output da-fimper-x,
                                            output i-per-corrente,
                                            output i-ano-corrente,
                                            output da-iniper-fech,
                                            output da-fimper-fech).
                        if estab-mat.ult-per-fech <> c-per-aux then do:
                            assign c-ult-per-fech  = estab-mat.ult-per-fech
                                   c-estabelec-aux = estab-mat.cod-estabel.
                            apply "MOUSE-SELECT-CLICK":U to im-pg-sel in frame f-relat.
                            run utp/ut-msgs.p (input "show", 
                                               input 19091, 
&IF "{&mguni_version}" >= "2.071" &THEN
                                               input string(c-estabelec,"x(05)")           + '~~' +
&ELSE
                                               input string(c-estabelec,"x(3)")           + '~~' +
&ENDIF
                                                     string(c-per-aux,"9999/99")          + '~~' +
&IF "{&mguni_version}" >= "2.071" &THEN
                                                     string(c-estabelec-aux,"x(05)") + '~~' +
&ELSE
                                                     string(c-estabelec-aux,"x(3)") + '~~' +
&ENDIF
                                                     string(c-ult-per-fech,"9999/99")).
                            apply "ENTRY":U to c-estab-ini in frame f-pg-sel.
                            return error.
                        end.
                    end.
                    if i-per-corrente = ? or 
                       i-ano-corrente = 0 then do:
                        apply "MOUSE-SELECT-CLICK":U to im-pg-sel in frame f-relat.
                        run utp/ut-msgs.p (input "show", input 16459, input "").
                        apply "ENTRY":U to c-estab-ini in frame f-pg-sel.
                        return error.

                    end.            
                    if estab-mat.ult-per-fech = "" or
                       estab-mat.ult-per-fech = ? then do:
                        apply "MOUSE-SELECT-CLICK":U to im-pg-sel in frame f-relat.
                        run utp/ut-msgs.p (input "show", input 17109, input "").
                        apply "ENTRY":U to c-estab-ini in frame f-pg-sel.
                        return error.    
                    end.
                end.
            end.
            else for each tt-digita no-lock:
                assign r-tt-digita = rowid(tt-digita).

                /* Valida‡Æo de duplicidade de registro na temp-table tt-digita */
                find first b-tt-digita where b-tt-digita.cod-estabel = tt-digita.cod-estabel and 
                                             rowid(b-tt-digita) <> rowid(tt-digita) no-lock no-error.
                if avail b-tt-digita then do:
                    apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.
                    reposition br-digita to rowid rowid(b-tt-digita).

                    run utp/ut-msgs.p (input "show", input 108, input "").
                    apply "ENTRY":U to tt-digita.cod-estabel in browse br-digita.
                    return error.
                end.

                /* As demais valida‡äes devem ser feitas aqui */
                if not can-find(estabelec where estabelec.cod-estabel = tt-digita.cod-estabel)
                then do:        
                    apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.
                    reposition br-digita to rowid r-tt-digita.

                    {utp/ut-table.i mgadm estabelec 1}
                    run utp/ut-msgs.p (input "show", input 2, input return-value).
                    apply "ENTRY":U to tt-digita.cod-estabel in browse br-digita.
                    return error.
                end.

                find estab-mat where estab-mat.cod-estabel = tt-digita.cod-estabel 
                     no-lock no-error.
                if not avail estab-mat then do:        
                    apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.
                    reposition br-digita to rowid r-tt-digita.

                    {utp/ut-table.i mgind estab-mat 1}
                    run utp/ut-msgs.p (input "show", input 2, input return-value).
                    apply "ENTRY":U to tt-digita.cod-estabel in browse br-digita.
                    return error.
                end.                
                if c-per-aux = ? then do:
                    assign c-per-aux = estab-mat.ult-per-fech
                           c-estabelec = tt-digita.cod-estabel.
                    run cdp/cdapi005.p (input  estab-mat.ult-per-fech,
                                        output da-iniper-x,
                                        output da-fimper-x,
                                        output i-per-corrente,
                                        output i-ano-corrente,
                                        output da-iniper-fech,
                                        output da-fimper-fech).
                end.
                else do:
                    run cdp/cdapi005.p (input  estab-mat.ult-per-fech,
                                        output da-iniper-x,
                                        output da-fimper-x,
                                        output i-per-corrente,
                                        output i-ano-corrente,
                                        output da-iniper-fech,
                                        output da-fimper-fech).
                    if estab-mat.ult-per-fech <> c-per-aux then do:
                        assign c-ult-per-fech = estab-mat.ult-per-fech
                               c-estabelec-aux = estab-mat.cod-estabel.
                        apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.
                        reposition br-digita to rowid r-tt-digita.
                        run utp/ut-msgs.p (input "show", 
                                           input 19091, 
&IF "{&mguni_version}" >= "2.071" &THEN
                                           input string(c-estabelec,"x(05)")           + '~~' +
&ELSE
                                           input string(c-estabelec,"x(3)")           + '~~' +
&ENDIF
                                                 string(c-per-aux,"9999/99")          + '~~' +
&IF "{&mguni_version}" >= "2.071" &THEN
                                                 string(c-estabelec-aux,"x(05)") + '~~' +
&ELSE
                                                 string(c-estabelec-aux,"x(3)") + '~~' +
&ENDIF
                                                 string(c-ult-per-fech,"9999/99")).

                        apply "ENTRY":U to tt-digita.cod-estabel in browse br-digita.
                        return error.
                    end.
                end.
                if i-per-corrente = ? or 
                   i-ano-corrente = 0 then do:
                    apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.
                    reposition br-digita to rowid r-tt-digita.
                    run utp/ut-msgs.p (input "show", input 16459, input "").
                    apply "ENTRY":U to tt-digita.cod-estabel in browse br-digita.
                    return error.

                end.            
                if estab-mat.ult-per-fech = "" or
                   estab-mat.ult-per-fech = ? then do:
                    apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.
                    reposition br-digita to rowid r-tt-digita.
                    run utp/ut-msgs.p (input "show", input 17109, input "").
                    apply "ENTRY":U to tt-digita.cod-estabel in browse br-digita.
                    return error.    
                end.

            end.            
        end.
    &endif.        

    /* Coloque aqui as valida‡äes das outras p ginas, lembrando que elas
       devem apresentar uma mensagem de erro cadastrada, posicionar na p gina 
       com problemas e colocar o focus no campo com problemas             */    

    create tt-param.
    assign tt-param.usuario    = c-seg-usuario
           tt-param.destino    = input frame f-pg-imp rs-destino
           tt-param.data-exec  = today
           tt-param.hora-exec  = time.

    /************** Grava vari veis de tela (sele‡Æo, parƒmetro,...) na temp table tt-param ***************/

    assign i-ge-ini            = input frame f-pg-sel i-ge-ini
           i-ge-fim            = input frame f-pg-sel i-ge-fim
           c-estab-ini         = input frame f-pg-sel c-estab-ini
           c-estab-fim         = input frame f-pg-sel c-estab-fim
           c-item-ini          = input frame f-pg-sel c-item-ini
           c-item-fim          = input frame f-pg-sel c-item-fim
           l-critico           = input frame f-pg-par l-critico
           l-acerto            = input frame f-pg-par l-acerto
           l-pagina            = input frame f-pg-par l-pagina
           i-moeda             = int(substring(cb-moeda:screen-value in frame f-pg-par,1,1))
           c-moeda             = substring(cb-moeda:screen-value in frame f-pg-par,
                                 5,(length(cb-moeda:screen-value in frame f-pg-par) - 4 ))
           i-mo                = i-moeda + 1.

    assign tt-param.i-ge-ini            = input frame f-pg-sel i-ge-ini
           tt-param.i-ge-fim            = input frame f-pg-sel i-ge-fim
           tt-param.c-estab-ini         = input frame f-pg-sel c-estab-ini
           tt-param.c-estab-fim         = input frame f-pg-sel c-estab-fim
           tt-param.c-item-ini          = input frame f-pg-sel c-item-ini
           tt-param.c-item-fim          = input frame f-pg-sel c-item-fim
           tt-param.l-critico           = input frame f-pg-par l-critico
           tt-param.l-acerto            = input frame f-pg-par l-acerto
           tt-param.l-pagina            = input frame f-pg-par l-pagina
           tt-param.i-moeda             = i-moeda
           tt-param.c-moeda             = c-moeda
           tt-param.i-mo                = i-mo
           tt-param.l-parametro         = INPUT FRAME f-pg-imp l-parametro
           &IF '{&BF_MAT_VERSAO_EMS}' >= '2.04' &THEN
               tt-param.c-fm-cod-ini = input frame f-pg-sel c-fm-ini
               tt-param.c-fm-cod-fim = input frame f-pg-sel c-fm-fim
           &ENDIF.

    if  tt-param.destino = 1 then
        assign tt-param.arquivo = "".
    else
    if  tt-param.destino = 2 then 
        assign tt-param.arquivo = input frame f-pg-imp c-arquivo.
    else
        assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp".

    /* Coloque aqui a l¢gica de grava‡Æo dos parƒmetros e sele‡Æo na temp-table
       tt-param */ 

    {include/i-rpexb.i}

    if  session:set-wait-state("general") then.

    {include/i-rprun.i esp/cep/ESCEP999rp.p}

    {include/i-rpexc.i}

    if  session:set-wait-state("") then.

    {include/i-rptrm.i}

end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-pagina C-Win 
PROCEDURE pi-troca-pagina :
/*------------------------------------------------------------------------------
  Purpose: Gerencia a Troca de P gina (folder)   
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
  {src/adm/template/snd-list.i "tt-digita"}

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

