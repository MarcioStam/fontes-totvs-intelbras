&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-relat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-relat 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i escdp060 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i escdp060 MCD}
&ENDIF



/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Preprocessadores do Template de Relat¢rio                            */
/* Obs: Retirar o valor do preprocessador para as p†ginas que n∆o existirem  */

&GLOBAL-DEFINE Program        escdp060
&GLOBAL-DEFINE PGSEL f-pg-sel
&GLOBAL-DEFINE PGCLA f-pg-cla
&GLOBAL-DEFINE PGPAR f-pg-par
&GLOBAL-DEFINE PGDIG f-pg-dig
&GLOBAL-DEFINE PGIMP f-pg-imp
  
/* Parameters Definitions ---                                           */

/* Temporary Table Definitions ---                                      */

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char    format "x(35)"
    field usuario          as char    format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer 
    field c-item-ini       as char    format "x(16)"
    field c-item-fim       as char    format "x(16)"
    field c-gr-estoq-ini   as integer format ">9"
    field c-gr-estoq-fim   as integer format ">9"
    field c-fam-mat-ini    as char    format "x(8)"
    field c-fam-mat-fim    as char    format "x(8)"
    field c-fam-coml-ini   as char    format "x(8)"
    field c-fam-coml-fim   as char    format "x(8)"
    field l-tipo           as logical format "Sim/N∆o"
    field rs-lista         as integer
    field l-narrativa      as logical format "Sim/N∆o"
    FIELD c-ncm-ini        AS CHAR    FORMAT 9999.99.99
    FIELD c-ncm-fim        AS CHAR    FORMAT 9999.99.99.

/* Transfer Definitions */
DEFINE TEMP-TABLE tt-digita
    FIELD it-codigo LIKE item.it-codigo
    FIELD desc-item LIKE item.desc-item
    INDEX item it-codigo.

DEFINE BUFFER b-tt-digita FOR tt-digita.
DEFINE VARIABLE raw-param AS RAW NO-UNDO.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.
                    
/* Local Variable Definitions ---                                       */
def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-relat
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-pg-cla
&Scoped-define BROWSE-NAME br-digita

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-digita

/* Definitions for BROWSE br-digita                                     */
&Scoped-define FIELDS-IN-QUERY-br-digita tt-digita.it-codigo tt-digita.desc-item   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-digita tt-digita.it-codigo   
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
&Scoped-Define ENABLED-OBJECTS RECT-16 RECT-19 rs-classifica ~
text-classificacao 
&Scoped-Define DISPLAYED-OBJECTS rs-classifica text-classificacao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-relat AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE text-classificacao AS CHARACTER FORMAT "X(20)":U INITIAL "Classificaá∆o" 
      VIEW-AS TEXT 
     SIZE 13.57 BY .67
     FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE rs-classifica AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Item", 1,
"Grupo de Estoque", 2,
"Fam°lia de Material", 3,
"Fam°lia Comercial", 4
     SIZE 26.43 BY 3.75 NO-UNDO.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 76 BY 10.5.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 72 BY 4.79.

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

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 76 BY 10.5.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 1.71.

DEFINE VARIABLE text-lista AS CHARACTER FORMAT "X(20)":U INITIAL "Lista Itens:" 
      VIEW-AS TEXT 
     SIZE 11.29 BY .67 NO-UNDO.

DEFINE VARIABLE text-tipo AS CHARACTER FORMAT "X(20)":U INITIAL "Tipo do Relat¢rio:" 
      VIEW-AS TEXT 
     SIZE 16.72 BY .67 NO-UNDO.

DEFINE VARIABLE l-tipo AS LOGICAL INITIAL yes 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Resumido", yes
     SIZE 49.29 BY 1.08 NO-UNDO.

DEFINE VARIABLE rs-lista AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todos", 1,
"Somente os Ativos", 2,
"Somente os Obsoletos Ordens Autom†ticas", 3,
"Somente os Obsoletos Todas as Ordens", 4,
"Totalmente Obsoletos", 5
     SIZE 43.43 BY 4.25 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 76 BY 10.5.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 72 BY 1.92.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 72 BY 5.25.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 72 BY 1.71.

DEFINE VARIABLE l-narrativa AS LOGICAL INITIAL no 
     LABEL "Listar Narrativa" 
     VIEW-AS TOGGLE-BOX
     SIZE 18.86 BY 1.08 NO-UNDO.

DEFINE VARIABLE c-fam-coml-fim AS CHARACTER FORMAT "X(8)":U INITIAL "ZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-fam-coml-ini AS CHARACTER FORMAT "x(8)":U 
     LABEL "Fam°lia Comercial" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-fam-mat-fim AS CHARACTER FORMAT "x(8)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-fam-mat-ini AS CHARACTER FORMAT "X(8)":U 
     LABEL "Fam°lia de Materiais" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-gr-estoq-fim AS INTEGER FORMAT ">9":U INITIAL 99 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE c-gr-estoq-ini AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Grupo de Estoque" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE c-item-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-item-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-ncm-fim AS CHARACTER FORMAT "X(8)":U INITIAL "ZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-ncm-ini AS CHARACTER FORMAT "X(8)":U 
     LABEL "NCM" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-17
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-21
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 76 BY 10.5.

DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-executar 
     LABEL "Executar" 
     SIZE 10 BY 1.

DEFINE IMAGE im-pg-cla
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-dig
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
DEFINE QUERY br-digita FOR 
      tt-digita SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-digita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-digita w-relat _FREEFORM
  QUERY br-digita DISPLAY
      tt-digita.it-codigo  FORMAT "X(16)" LABEL "Item"
      tt-digita.desc-item  WIDTH 57       LABEL "Descriá∆o"
ENABLE
      tt-digita.it-codigo
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 74 BY 8.75
         BGCOLOR 15 FONT 7.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-pg-sel
     c-item-ini AT ROW 2.29 COL 20.57 COLON-ALIGNED HELP
          "C¢digo do item inicial"
     c-item-fim AT ROW 2.29 COL 48.29 COLON-ALIGNED HELP
          "C¢digo do item final" NO-LABEL
     c-gr-estoq-ini AT ROW 3.33 COL 28.57 COLON-ALIGNED HELP
          "Grupo de estoque do item inicial"
     c-gr-estoq-fim AT ROW 3.33 COL 48.29 COLON-ALIGNED HELP
          "Grupo de estoque do item final" NO-LABEL
     c-fam-mat-ini AT ROW 4.38 COL 25.57 COLON-ALIGNED HELP
          "C¢digo da fam°lia de materiais do item inicial"
     c-fam-mat-fim AT ROW 4.38 COL 48.29 COLON-ALIGNED HELP
          "C¢digo da fam°lia de materiais do item final" NO-LABEL
     c-fam-coml-ini AT ROW 5.42 COL 25.57 COLON-ALIGNED HELP
          "C¢digo da fam°lia comercial do item inicial"
     c-fam-coml-fim AT ROW 5.42 COL 48.29 COLON-ALIGNED HELP
          "C¢digo da fam°lia comercial do item final" NO-LABEL
     c-ncm-ini AT ROW 6.5 COL 25.57 COLON-ALIGNED HELP
          "C¢digo da fam°lia comercial do item inicial" WIDGET-ID 12
     c-ncm-fim AT ROW 6.5 COL 48.29 COLON-ALIGNED HELP
          "C¢digo da fam°lia comercial do item final" NO-LABEL WIDGET-ID 10
     RECT-10 AT ROW 1 COL 1.43
     IMAGE-1 AT ROW 2.29 COL 39.43
     IMAGE-2 AT ROW 2.29 COL 47.29
     IMAGE-13 AT ROW 3.33 COL 39.43
     IMAGE-14 AT ROW 3.33 COL 47.29
     IMAGE-15 AT ROW 4.38 COL 39.43
     IMAGE-16 AT ROW 4.38 COL 47.29
     IMAGE-17 AT ROW 5.42 COL 39.43
     IMAGE-18 AT ROW 5.42 COL 47.29
     IMAGE-21 AT ROW 6.5 COL 39.43 WIDGET-ID 14
     IMAGE-22 AT ROW 6.5 COL 47.29 WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.85
         SIZE 76.86 BY 10.75.

DEFINE FRAME f-pg-par
     l-tipo AT ROW 2.33 COL 5 HELP
          "Tipo do relat¢rio" NO-LABEL
     rs-lista AT ROW 4.54 COL 5 HELP
          "Opá‰es de listagem" NO-LABEL
     l-narrativa AT ROW 9.75 COL 4.86 HELP
          "Listar a narrativa do item?"
     text-tipo AT ROW 1.46 COL 3.43 COLON-ALIGNED NO-LABEL
     text-lista AT ROW 3.75 COL 3.43 COLON-ALIGNED NO-LABEL
     RECT-12 AT ROW 1 COL 1.43
     RECT-13 AT ROW 1.71 COL 3.43
     RECT-14 AT ROW 3.96 COL 3.43
     RECT-15 AT ROW 9.38 COL 3.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.85
         SIZE 76.86 BY 10.75.

DEFINE FRAME f-pg-cla
     rs-classifica AT ROW 2.42 COL 5 HELP
          "Classificaá∆o para emiss∆o do relat¢rio" NO-LABEL
     text-classificacao AT ROW 1.46 COL 3.86 COLON-ALIGNED NO-LABEL
     RECT-16 AT ROW 1 COL 1.43
     RECT-19 AT ROW 1.75 COL 3.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.85
         SIZE 76.86 BY 10.75.

DEFINE FRAME f-relat
     bt-executar AT ROW 14.54 COL 3 HELP
          "Dispara a execuá∆o do relat¢rio"
     bt-cancelar AT ROW 14.54 COL 14 HELP
          "Fechar"
     bt-ajuda AT ROW 14.54 COL 70 HELP
          "Ajuda"
     im-pg-sel AT ROW 1.5 COL 2.14
     im-pg-cla AT ROW 1.5 COL 17.86
     im-pg-par AT ROW 1.5 COL 33.57
     im-pg-imp AT ROW 1.5 COL 64.86
     rt-folder AT ROW 2.5 COL 2
     rt-folder-top AT ROW 2.54 COL 2.14
     rt-folder-left AT ROW 2.54 COL 2.14
     rt-folder-right AT ROW 2.67 COL 80.43
     RECT-6 AT ROW 13.75 COL 2.14
     RECT-1 AT ROW 14.29 COL 2
     im-pg-dig AT ROW 1.5 COL 49.29 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.86 BY 15
         DEFAULT-BUTTON bt-executar.

DEFINE FRAME f-pg-imp
     rs-destino AT ROW 2.38 COL 4.43 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     bt-config-impr AT ROW 3.58 COL 44.43 HELP
          "Configuraá∆o da impressora"
     bt-arquivo AT ROW 3.58 COL 44.43 HELP
          "Escolha do nome do arquivo"
     c-arquivo AT ROW 3.63 COL 4.43 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rs-execucao AT ROW 5.75 COL 4.14 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-destino AT ROW 1.63 COL 5 NO-LABEL
     text-modo AT ROW 5 COL 2.43 COLON-ALIGNED NO-LABEL
     RECT-18 AT ROW 1 COL 1.43
     RECT-7 AT ROW 1.92 COL 3.29
     RECT-9 AT ROW 5.29 COL 3.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.85
         SIZE 76.86 BY 10.75.

DEFINE FRAME f-pg-dig
     br-digita AT ROW 1.25 COL 1.43 WIDGET-ID 200
     bt-inserir AT ROW 10 COL 1.29 WIDGET-ID 4
     bt-alterar AT ROW 10 COL 16.14 WIDGET-ID 2
     bt-retirar AT ROW 10 COL 31 WIDGET-ID 8
     bt-salvar AT ROW 10 COL 45.86 WIDGET-ID 10
     bt-recuperar AT ROW 10 COL 60.57 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.85
         SIZE 76.86 BY 10.75
         FONT 7 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-relat
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-relat ASSIGN
         HIDDEN             = YES
         TITLE              = "<Title>"
         HEIGHT             = 15
         WIDTH              = 80.86
         MAX-HEIGHT         = 24
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 24
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
/* SETTINGS FOR FRAME f-pg-cla
   FRAME-NAME                                                           */
ASSIGN 
       text-classificacao:PRIVATE-DATA IN FRAME f-pg-cla     = 
                "Classificaá∆o".

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
                "Execuá∆o".

/* SETTINGS FOR FRAME f-pg-par
                                                                        */
/* SETTINGS FOR FILL-IN text-lista IN FRAME f-pg-par
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       text-lista:PRIVATE-DATA IN FRAME f-pg-par     = 
                "Lista Itens".

/* SETTINGS FOR FILL-IN text-tipo IN FRAME f-pg-par
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       text-tipo:PRIVATE-DATA IN FRAME f-pg-par     = 
                "Tipo do Relat¢rio".

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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-relat)
THEN w-relat:HIDDEN = no.

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


&Scoped-define BROWSE-NAME br-digita
&Scoped-define FRAME-NAME f-pg-dig
&Scoped-define SELF-NAME br-digita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita w-relat
ON DEL OF br-digita IN FRAME f-pg-dig
DO:
   APPLY 'CHOOSE' TO bt-retirar IN FRAME f-pg-dig.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita w-relat
ON END-ERROR OF br-digita IN FRAME f-pg-dig
ANYWHERE DO:
    IF  br-digita:NEW-ROW IN FRAME f-pg-dig THEN DO:
        IF  AVAIL tt-digita THEN
            DELETE tt-digita.
        IF  br-digita:DELETE-CURRENT-ROW() IN FRAME f-pg-dig THEN. 
    END.                                                               
    ELSE DO:
        GET CURRENT br-digita.
        DISPLAY tt-digita.it-codigo
                tt-digita.desc-item WITH BROWSE br-digita. 
    END.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita w-relat
ON ENTER OF br-digita IN FRAME f-pg-dig
ANYWHERE DO:
    APPLY 'TAB' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita w-relat
ON INS OF br-digita IN FRAME f-pg-dig
DO:
    APPLY 'CHOOSE' TO bt-inserir IN FRAME f-pg-dig.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita w-relat
ON OFF-END OF br-digita IN FRAME f-pg-dig
DO:
    APPLY 'ENTRY' TO bt-inserir IN FRAME f-pg-dig.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita w-relat
ON OFF-HOME OF br-digita IN FRAME f-pg-dig
DO:
    APPLY 'ENTRY' TO bt-recuperar IN FRAME f-pg-dig.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita w-relat
ON ROW-ENTRY OF br-digita IN FRAME f-pg-dig
DO:
   /* trigger para inicializar campos da temp table de digitaá∆o */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita w-relat
ON ROW-LEAVE OF br-digita IN FRAME f-pg-dig
DO:
    /* ê aqui que a gravaá∆o da linha da temp-table Ç efetivada.
       PorÇm as validaá‰es dos registros devem ser feitas na procedure pi-executar,
       no local indicado pelo coment†rio */
    IF br-digita:NEW-ROW IN FRAME f-pg-dig THEN DO TRANSACTION ON ERROR UNDO, RETURN NO-APPLY:
        CREATE tt-digita.
        ASSIGN INPUT BROWSE br-digita tt-digita.it-codigo.
        IF AVAIL item THEN
            ASSIGN tt-digita.desc-item = item.desc-item.
    END.
    ELSE DO TRANSACTION ON ERROR UNDO, RETURN NO-APPLY:
        ASSIGN INPUT BROWSE br-digita tt-digita.it-codigo.
        IF AVAIL item THEN
            ASSIGN tt-digita.desc-item = item.desc-item.

        FOR FIRST item FIELDS(it-codigo desc-item)
            WHERE item.it-codigo = INPUT BROWSE br-digita tt-digita.it-codigo NO-LOCK: END.

        IF AVAIL item THEN
            ASSIGN tt-digita.desc-item:SCREEN-VALUE IN BROWSE br-digita = item.desc-item.
    END.

    IF br-digita:NEW-ROW THEN
        br-digita:CREATE-RESULT-LIST-ENTRY() IN FRAME f-pg-dig.
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


&Scoped-define FRAME-NAME f-pg-dig
&Scoped-define SELF-NAME bt-alterar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-alterar w-relat
ON CHOOSE OF bt-alterar IN FRAME f-pg-dig /* Alterar */
DO:
    APPLY 'ENTRY' TO tt-digita.it-codigo IN BROWSE br-digita. 
    IF CAN-FIND(FIRST tt-digita) THEN
        ASSIGN c-item-ini:SENSITIVE    IN FRAME f-pg-sel = NO
               c-item-fim:SENSITIVE    IN FRAME f-pg-sel = NO
               c-item-ini:SCREEN-VALUE IN FRAME f-pg-sel = ""
               c-item-fim:SCREEN-VALUE IN FRAME f-pg-sel = "".
    ELSE
        ASSIGN c-item-ini:SENSITIVE    IN FRAME f-pg-sel = YES
               c-item-fim:SENSITIVE    IN FRAME f-pg-sel = YES
               c-item-ini:SCREEN-VALUE IN FRAME f-pg-sel = ""
               c-item-fim:SCREEN-VALUE IN FRAME f-pg-sel = "ZZZZZZZZZZZZZZZZ".
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
   apply "close" to this-procedure.
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


&Scoped-define FRAME-NAME f-pg-dig
&Scoped-define SELF-NAME bt-inserir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-inserir w-relat
ON CHOOSE OF bt-inserir IN FRAME f-pg-dig /* Inserir */
DO:
    ASSIGN bt-alterar:SENSITIVE IN FRAME f-pg-dig = YES
           bt-retirar:SENSITIVE IN FRAME f-pg-dig = YES
           bt-salvar :SENSITIVE IN FRAME f-pg-dig = YES.

    IF NUM-RESULTS("br-digita") > 0 THEN
        br-digita:INSERT-ROW("AFTER") IN FRAME f-pg-dig.
    ELSE DO TRANSACTION:
        CREATE tt-digita.

        OPEN QUERY br-digita FOR EACH tt-digita.

        APPLY "ENTRY" TO tt-digita.it-codigo IN BROWSE br-digita. 
    END.

    IF CAN-FIND(FIRST tt-digita) THEN
        ASSIGN c-item-ini:SENSITIVE    IN FRAME f-pg-sel = NO
               c-item-fim:SENSITIVE    IN FRAME f-pg-sel = NO
               c-item-ini:SCREEN-VALUE IN FRAME f-pg-sel = ""
               c-item-fim:SCREEN-VALUE IN FRAME f-pg-sel = "".
    ELSE
        ASSIGN c-item-ini:SENSITIVE    IN FRAME f-pg-sel = YES
               c-item-fim:SENSITIVE    IN FRAME f-pg-sel = YES
               c-item-ini:SCREEN-VALUE IN FRAME f-pg-sel = ""
               c-item-fim:SCREEN-VALUE IN FRAME f-pg-sel = "ZZZZZZZZZZZZZZZZ".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-recuperar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-recuperar w-relat
ON CHOOSE OF bt-recuperar IN FRAME f-pg-dig /* Recuperar */
DO:
    {include/i-rprcd.i}
    IF CAN-FIND(FIRST tt-digita) THEN
        ASSIGN c-item-ini:SENSITIVE    IN FRAME f-pg-sel = NO
               c-item-fim:SENSITIVE    IN FRAME f-pg-sel = NO
               c-item-ini:SCREEN-VALUE IN FRAME f-pg-sel = ""
               c-item-fim:SCREEN-VALUE IN FRAME f-pg-sel = "".
    ELSE
        ASSIGN c-item-ini:SENSITIVE    IN FRAME f-pg-sel = YES
               c-item-fim:SENSITIVE    IN FRAME f-pg-sel = YES
               c-item-ini:SCREEN-VALUE IN FRAME f-pg-sel = ""
               c-item-fim:SCREEN-VALUE IN FRAME f-pg-sel = "ZZZZZZZZZZZZZZZZ".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-retirar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-retirar w-relat
ON CHOOSE OF bt-retirar IN FRAME f-pg-dig /* Retirar */
DO:
    IF br-digita:NUM-SELECTED-ROWS > 0 THEN DO ON ERROR UNDO, RETURN NO-APPLY:
        DELETE tt-digita.
        IF  br-digita:DELETE-CURRENT-ROW() IN FRAME f-pg-dig THEN.
    END.

    IF NUM-RESULTS("br-digita") = 0 THEN
        ASSIGN bt-alterar:SENSITIVE IN FRAME f-pg-dig = NO
               bt-retirar:SENSITIVE IN FRAME f-pg-dig = NO
               bt-salvar :SENSITIVE IN FRAME f-pg-dig = NO.

    FIND FIRST tt-digita NO-LOCK NO-ERROR.

    IF AVAIL tt-digita THEN DO:
        ASSIGN c-item-ini:SENSITIVE    IN FRAME f-pg-sel = NO
               c-item-fim:SENSITIVE    IN FRAME f-pg-sel = NO
               c-item-ini:SCREEN-VALUE IN FRAME f-pg-sel = ""
               c-item-fim:SCREEN-VALUE IN FRAME f-pg-sel = "".

    END.
    ELSE
        ASSIGN c-item-ini:SENSITIVE    IN FRAME f-pg-sel = YES
               c-item-fim:SENSITIVE    IN FRAME f-pg-sel = YES
               c-item-ini:SCREEN-VALUE IN FRAME f-pg-sel = ""
               c-item-fim:SCREEN-VALUE IN FRAME f-pg-sel = "ZZZZZZZZZZZZZZZZ".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-salvar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-salvar w-relat
ON CHOOSE OF bt-salvar IN FRAME f-pg-dig /* Salvar */
DO:
    {include/i-rpsvd.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME im-pg-cla
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-cla w-relat
ON MOUSE-SELECT-CLICK OF im-pg-cla IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-dig
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-dig w-relat
ON MOUSE-SELECT-CLICK OF im-pg-dig IN FRAME f-relat
DO:
    run pi-troca-pagina.
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


&Scoped-define SELF-NAME im-pg-par
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-par w-relat
ON MOUSE-SELECT-CLICK OF im-pg-par IN FRAME f-relat
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-execucao w-relat
ON VALUE-CHANGED OF rs-execucao IN FRAME f-pg-imp
DO:
   {include/i-rprse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-cla
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-relat 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

{utp/ut9000.i "escdp060" "2.00.00.003"}

/* inicializaá‰es do template de relat¢rio */
{include/i-rpini.i imp-pg-sel}

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
  ENABLE im-pg-sel im-pg-cla im-pg-par im-pg-imp im-pg-dig bt-executar 
         bt-cancelar bt-ajuda 
      WITH FRAME f-relat IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  DISPLAY rs-classifica text-classificacao 
      WITH FRAME f-pg-cla IN WINDOW w-relat.
  ENABLE RECT-16 RECT-19 rs-classifica text-classificacao 
      WITH FRAME f-pg-cla IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-cla}
  ENABLE br-digita bt-inserir bt-alterar bt-retirar bt-salvar bt-recuperar 
      WITH FRAME f-pg-dig IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-dig}
  DISPLAY rs-destino c-arquivo rs-execucao 
      WITH FRAME f-pg-imp IN WINDOW w-relat.
  ENABLE RECT-18 RECT-7 RECT-9 rs-destino bt-config-impr bt-arquivo c-arquivo 
         rs-execucao 
      WITH FRAME f-pg-imp IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-imp}
  DISPLAY l-tipo rs-lista l-narrativa 
      WITH FRAME f-pg-par IN WINDOW w-relat.
  ENABLE RECT-12 RECT-13 RECT-14 RECT-15 l-tipo rs-lista l-narrativa 
      WITH FRAME f-pg-par IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-par}
  DISPLAY c-item-ini c-item-fim c-gr-estoq-ini c-gr-estoq-fim c-fam-mat-ini 
          c-fam-mat-fim c-fam-coml-ini c-fam-coml-fim c-ncm-ini c-ncm-fim 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  ENABLE RECT-10 IMAGE-1 IMAGE-2 IMAGE-13 IMAGE-14 IMAGE-15 IMAGE-16 IMAGE-17 
         IMAGE-18 IMAGE-21 IMAGE-22 c-item-ini c-item-fim c-gr-estoq-ini 
         c-gr-estoq-fim c-fam-mat-ini c-fam-mat-fim c-fam-coml-ini 
         c-fam-coml-fim c-ncm-ini c-ncm-fim 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
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
    
    if input frame f-pg-imp rs-destino = 2 and
       input frame f-pg-imp rs-execucao = 1 then do:
        run utp/ut-vlarq.p (input input frame f-pg-imp c-arquivo).
        
        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show", input 73, input "").
            
            apply "MOUSE-SELECT-CLICK":U to im-pg-imp in frame f-relat.
            apply "ENTRY":U to c-arquivo in frame f-pg-imp.
            return error.
        end.
    end.
    
    if input frame f-pg-sel c-item-ini > input frame f-pg-sel c-item-fim then do:
       {utp/ut-field.i mgind item it-codigo 1}
       run utp/ut-msgs.p (input "SHOW",
                          input 515, 
                          input return-value).                        
       apply 'mouse-select-click' to im-pg-sel in frame f-relat.
       apply 'entry' to c-item-ini in frame f-pg-sel.
       return 'adm-error'.       
     end.    

    if input frame f-pg-sel c-gr-estoq-ini > input frame f-pg-sel c-gr-estoq-fim then do:
       {utp/ut-field.i mgind item ge-codigo 1}
       run utp/ut-msgs.p (input "SHOW",
                          input 515, 
                          input return-value).                        
       apply 'mouse-select-click' to im-pg-sel in frame f-relat.
       apply 'entry' to c-gr-estoq-ini in frame f-pg-sel.
       return 'adm-error'.       
     end.    
    
    if input frame f-pg-sel c-fam-mat-ini > input frame f-pg-sel c-fam-mat-fim then do:
       {utp/ut-field.i mgind item fm-codigo 1}
       run utp/ut-msgs.p (input "SHOW",
                          input 515, 
                          input return-value).                        
       apply 'mouse-select-click' to im-pg-sel in frame f-relat.
       apply 'entry' to c-fam-mat-ini in frame f-pg-sel.
       return 'adm-error'.       
     end.    
    
    if input frame f-pg-sel c-fam-coml-ini > input frame f-pg-sel c-fam-coml-fim then do:
       {utp/ut-field.i mgind item fm-cod-com 1}
       run utp/ut-msgs.p (input "SHOW",
                          input 515, 
                          input return-value).                        
       apply 'mouse-select-click' to im-pg-sel in frame f-relat.
       apply 'entry' to c-fam-coml-ini in frame f-pg-sel.
       return 'adm-error'.       
     end.    

     if input frame f-pg-sel c-ncm-ini > input frame f-pg-sel c-ncm-fim then do:
       {utp/ut-field.i mgind item class-fiscal 1}
       run utp/ut-msgs.p (input "SHOW",
                          input 515, 
                          input return-value).                        
       apply 'mouse-select-click' to im-pg-sel in frame f-relat.
       apply 'entry' to c-ncm-ini in frame f-pg-sel.
       return 'adm-error'.       
     end.    
    
    /* Aqui s∆o gravados os campos da temp-table que ser† passada como parÉmetro
       para o programa RP.P */
    
    FOR EACH tt-digita:
        ASSIGN r-tt-digita = ROWID(tt-digita).

        /*:T Validaá∆o de duplicidade de registro na temp-table tt-digita */
        FIND FIRST b-tt-digita
            WHERE b-tt-digita.it-codigo = tt-digita.it-codigo
            AND   ROWID(b-tt-digita) <> ROWID(tt-digita) NO-LOCK NO-ERROR.

        IF  AVAIL b-tt-digita THEN DO:
            REPOSITION br-digita TO ROWID ROWID(b-tt-digita).

            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 108, INPUT "":U).
            APPLY "ENTRY":U TO tt-digita.it-codigo IN BROWSE br-digita.

            RETURN ERROR.
        END.
        
        /*:T As demais validaá‰es devem ser feitas aqui */
        IF  tt-digita.it-codigo = "" THEN DO:
            ASSIGN BROWSE br-digita:CURRENT-COLUMN = tt-digita.it-codigo:HANDLE IN BROWSE br-digita.

            REPOSITION br-digita TO ROWID r-tt-digita.
           
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17006, INPUT "":U).
            APPLY "ENTRY":U TO tt-digita.it-codigo IN BROWSE br-digita.
            
            RETURN ERROR.
        END.        
    END.

    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame f-pg-imp rs-destino
           tt-param.data-exec       = today
           tt-param.hora-exec       = time.
    
    if tt-param.destino = 1 
    then assign tt-param.arquivo = "".
    else if  tt-param.destino = 2 
         then assign tt-param.arquivo = input frame f-pg-imp c-arquivo.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp".

     assign tt-param.c-item-ini      = input frame f-pg-sel c-item-ini
            tt-param.c-item-fim      = input frame f-pg-sel c-item-fim
            tt-param.c-gr-estoq-ini  = input frame f-pg-sel c-gr-estoq-ini
            tt-param.c-gr-estoq-fim  = input frame f-pg-sel c-gr-estoq-fim
            tt-param.c-fam-mat-ini   = input frame f-pg-sel c-fam-mat-ini
            tt-param.c-fam-mat-fim   = input frame f-pg-sel c-fam-mat-fim
            tt-param.c-fam-coml-ini  = input frame f-pg-sel c-fam-coml-ini
            tt-param.c-fam-coml-fim  = input frame f-pg-sel c-fam-coml-fim
            tt-param.c-ncm-ini       = input frame f-pg-sel c-ncm-ini
            tt-param.c-ncm-fim       = input frame f-pg-sel c-ncm-fim
            tt-param.l-tipo          = input frame f-pg-par l-tipo
            tt-param.rs-lista        = input frame f-pg-par rs-lista             
            tt-param.l-narrativa     = input frame f-pg-par l-narrativa
            tt-param.classifica      = input frame f-pg-cla rs-classifica.
            .
            
    /* Executar do programa RP.P que ir† criar o relat¢rio */
    {include/i-rpexb.i}
    
    SESSION:SET-WAIT-STATE("general":U).
    
    {include/i-rprun.i esp/cdp/escdp060rp.p}
   
    {include/i-rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {include/i-rptrm.i}
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-pagina w-relat 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-relat  _ADM-SEND-RECORDS
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

