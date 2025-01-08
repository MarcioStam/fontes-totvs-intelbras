&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadsim 
{include/i-prgvrs.i esesb008F 2.00.00.000}


CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
/* Parameters Definitions ---                                           */
def new global shared var gr-nota-fiscal as rowid no-undo.
def new global shared var gr-documento as rowid no-undo.
def new global shared var gr-it-nota-fisc as rowid no-undo.

/* Local Variable Definitions ---                                       */
define variable wh-imprime as handle no-undo.
DEFINE VARIABLE cTransacao AS CHARACTER FORMAT "X(15)"  NO-UNDO.
DEFINE VARIABLE hprogramzoom AS HANDLE NO-UNDO.
DEFINE VARIABLE c-fat AS CHAR NO-UNDO.
DEFINE VARIABLE c-dev AS CHAR NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_rec_tit_ap  AS RECID FORMAT ">>>>>>>9" INITIAL ? NO-UNDO.
/*{cdp/cd0666.i}*/
DEF BUFFER b-int-cc-benef       FOR int-cc-benef.
DEF BUFFER b-novo               FOR int-cc-benef.
DEF BUFFER b-int-fat-mensal-det FOR int-fat-mensal-det.

DEF STREAM s-1.


DEF TEMP-TABLE tt-fat   NO-UNDO LIKE int-fat-mensal-det.
DEF TEMP-TABLE tt-devol NO-UNDO LIKE int-fat-mensal-det
    FIELD central  AS INT
    FIELD filial   AS INT
    FIELD c-search AS CHAR 
    FIELD r-rowid  AS ROWID
    FIELD cgc         AS CHAR
    FIELD nome-abrev  AS CHAR
    FIELD nome-emit   AS CHAR
        INDEX idx-search c-search.

DEF TEMP-TABLE tt-nota NO-UNDO
    FIELD tp-movto     AS INT
    FIELD ano          AS INT
    FIELD mes          AS INT
    FIELD central      AS INT
    FIELD filial       AS INT
    FIELD unid-neg     AS CHAR
    FIELD cod-estabel  AS CHAR
    FIELD serie        AS CHAR
    FIELD nr-nota-fis  AS CHAR
    FIELD dt-emis-nota AS DATE
    FIELD vl-tot-nota LIKE it-nota-fisc.vl-merc-liq
    FIELD vl-tot-nota-base-rebate LIKE it-nota-fisc.vl-merc-liq
    FIELD r-rowid      AS ROWID
    FIELD c-search     AS CHAR 
    FIELD cgc         AS CHAR
    FIELD nome-abrev  AS CHAR
    FIELD nome-emit   AS CHAR
        INDEX idx-1 IS PRIMARY dt-emis-nota 
                               cod-estabel 
                               serie
                               nr-nota-fis
        INDEX idx-search c-search.

DEF TEMP-TABLE tt-nota-det NO-UNDO LIKE int-fat-mensal-det.

def temp-table tt-erro-aux no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(200)"
    FIELD ajuda    AS CHAR FORMAT "X(250)".

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD ano                AS INT
    FIELD mes                AS INT
    FIELD canal-ini          AS INT
    FIELD canal-fim          AS INT
    FIELD unid-ini           AS CHAR
    FIELD unid-fim           AS CHAR.

DEF VAR i-mes-tri-ini AS INTEGER INIT 1 NO-UNDO.
DEF VAR i-mes-tri-fim AS INTEGER INIT 3 NO-UNDO.

def new global shared var h-facelift as handle no-undo.

IF NOT VALID-HANDLE(h-facelift) THEN
    RUN btb/btb901zo.p PERSISTENT SET h-facelift.

DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-implanta  AS LOGICAL.

DEF VAR h-acomp AS HANDLE NO-UNDO.

DEF VAR i-cor AS INT NO-UNDO.

{utp/ut-glob.i}

DEFINE VARIABLE v_win_original_width  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_win_original_height AS DECIMAL     NO-UNDO.

DEFINE VARIABLE v_column AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_asc    AS LOGICAL     NO-UNDO.


DEF NEW GLOBAL SHARED VAR r-row-canal AS ROWID NO-UNDO.
DEF NEW GLOBAL SHARED VAR r-row-cc    AS ROWID NO-UNDO.

/* Definiá∆o da tt-central */                       
{esp/esb/esesbapi005.i}
DEF TEMP-TABLE tt-central-lista LIKE tt-central.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME br-devol

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-devol tt-nota-det tt-nota

/* Definitions for BROWSE br-devol                                      */
&Scoped-define FIELDS-IN-QUERY-br-devol tt-devol.ano tt-devol.mes tt-devol.canal tt-devol.unid-neg tt-devol.data tt-devol.cod-emitente tt-devol.serie-docto tt-devol.nro-docto tt-devol.nat-operacao tt-devol.sequencia tt-devol.qt-devolvida tt-devol.vl-devolvido tt-devol.vl-devolvido-rebate tt-devol.cod-estabel tt-devol.serie tt-devol.nr-nota-fis tt-devol.nr-seq-fat tt-devol.it-codigo   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-devol   
&Scoped-define SELF-NAME br-devol
&Scoped-define QUERY-STRING-br-devol FOR EACH tt-devol BY tt-devol.data
&Scoped-define OPEN-QUERY-br-devol OPEN QUERY {&SELF-NAME} FOR EACH tt-devol BY tt-devol.data.
&Scoped-define TABLES-IN-QUERY-br-devol tt-devol
&Scoped-define FIRST-TABLE-IN-QUERY-br-devol tt-devol


/* Definitions for BROWSE br-fat                                        */
&Scoped-define FIELDS-IN-QUERY-br-fat tt-nota-det.ano tt-nota-det.mes tt-nota-det.canal tt-nota-det.unid-neg tt-nota-det.data tt-nota-det.cod-estabel tt-nota-det.serie tt-nota-det.nr-nota-fis tt-nota-det.nr-seq-fat tt-nota-det.it-codigo tt-nota-det.qt-faturada tt-nota-det.vl-faturado   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-fat   
&Scoped-define SELF-NAME br-fat
&Scoped-define QUERY-STRING-br-fat FOR EACH tt-nota-det NO-LOCK
&Scoped-define OPEN-QUERY-br-fat OPEN QUERY {&SELF-NAME} FOR EACH tt-nota-det NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br-fat tt-nota-det
&Scoped-define FIRST-TABLE-IN-QUERY-br-fat tt-nota-det


/* Definitions for BROWSE br-nota                                       */
&Scoped-define FIELDS-IN-QUERY-br-nota tt-nota.ano tt-nota.mes tt-nota.central tt-nota.filial tt-nota.cod-estabel tt-nota.serie tt-nota.nr-nota-fis tt-nota.dt-emis-nota tt-nota.vl-tot-nota   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-nota   
&Scoped-define SELF-NAME br-nota
&Scoped-define QUERY-STRING-br-nota FOR EACH tt-nota NO-LOCK BY tt-nota.dt-emis-nota                                                  BY tt-nota.cod-estabel                                                  BY tt-nota.serie                                                  BY tt-nota.nr-nota-fis
&Scoped-define OPEN-QUERY-br-nota OPEN QUERY {&SELF-NAME} FOR EACH tt-nota NO-LOCK BY tt-nota.dt-emis-nota                                                  BY tt-nota.cod-estabel                                                  BY tt-nota.serie                                                  BY tt-nota.nr-nota-fis.
&Scoped-define TABLES-IN-QUERY-br-nota tt-nota
&Scoped-define FIRST-TABLE-IN-QUERY-br-nota tt-nota


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-br-fat}~
    ~{&OPEN-QUERY-br-nota}

/* Definitions for FRAME fpage4                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage4 ~
    ~{&OPEN-QUERY-br-devol}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi-periodo fi-texto cb-Ano cb-mes ~
cb-trimestre fi-canal-ini fi-unidade-ini fi-unidade-fim bt-refresh ~
fi-faturado fi-devolvido fi-total rt-button bt-exit folder-1 bt-ok folder-4 ~
Rect-Main RECT-133 IMAGE-27 IMAGE-28 RECT-135 rt-button-3 RECT-137 ~
fi-faturado-rebate fi-devolvido-rebate fi-total-rebate 
&Scoped-Define DISPLAYED-OBJECTS fi-periodo fi-nome fi-texto cb-Ano ~
rs-apuracao cb-mes cb-trimestre fi-canal-ini fi-unidade-ini fi-unidade-fim ~
fi-faturado fi-devolvido fi-total fi-faturado-rebate fi-devolvido-rebate ~
fi-total-rebate 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnbeneficio w-cadsim 
FUNCTION fnbeneficio RETURNS CHARACTER
  (INPUT p-tipo AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnMes w-cadsim 
FUNCTION fnMes RETURNS INTEGER
  ( INPUT p-mes AS CHAR /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnMesExt w-cadsim 
FUNCTION fnMesExt RETURNS CHARACTER
  (INPUT p-mes AS INT /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnMovto w-cadsim 
FUNCTION fnMovto RETURNS CHARACTER
  ( p-movto AS INTEGER /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnStatus w-cadsim 
FUNCTION fnStatus RETURNS CHARACTER
  ( p-status AS INTEGER /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnTransacao w-cadsim 
FUNCTION fnTransacao RETURNS CHARACTER
  (INPUT p-tipo AS INT /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnTrimestre w-cadsim 
FUNCTION fnTrimestre RETURNS CHARACTER
  ( INPUT p-mes AS INT /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-cadsim AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-exit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-DOWN FILE "image\ii-exi":U
     LABEL "" 
     SIZE 4 BY 1.17 TOOLTIP "Sair do programa".

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&Fechar" 
     SIZE 10 BY 1 TOOLTIP "Sair do programa"
     BGCOLOR 8 .

DEFINE BUTTON bt-refresh 
     IMAGE-UP FILE "adeicon/check.bmp":U
     LABEL "" 
     SIZE 6 BY 1.75 TOOLTIP "Filtrar".

DEFINE VARIABLE cb-Ano AS CHARACTER FORMAT "X(256)":U 
     LABEL "Ano" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "2014","2015","2016","2017","2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030" 
     DROP-DOWN-LIST
     SIZE 9.72 BY 1 TOOLTIP "Màs da apuraá∆o" NO-UNDO.

DEFINE VARIABLE cb-mes AS CHARACTER FORMAT "X(256)":U INITIAL "Janeiro" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "Janeiro","Fevereiro","Maráo","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro" 
     DROP-DOWN-LIST
     SIZE 13.72 BY 1 TOOLTIP "Màs da apuraá∆o" NO-UNDO.

DEFINE VARIABLE cb-trimestre AS CHARACTER FORMAT "X(256)":U INITIAL "Primeiro" 
     VIEW-AS COMBO-BOX INNER-LINES 4
     LIST-ITEMS "Primeiro","Segundo","Terceiro","Quarto" 
     DROP-DOWN-LIST
     SIZE 13.72 BY 1 TOOLTIP "Màs da apuraá∆o" NO-UNDO.

DEFINE VARIABLE fi-canal-ini AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Canal" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-devolvido AS DECIMAL FORMAT "->>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Total Devolvido" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-devolvido-rebate AS DECIMAL FORMAT "->>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Total Devolvido" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-faturado AS DECIMAL FORMAT "->>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Total Faturado" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-faturado-rebate AS DECIMAL FORMAT "->>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Total Faturado" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-periodo AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 7.57 BY .67 NO-UNDO.

DEFINE VARIABLE fi-texto AS CHARACTER FORMAT "X(256)":U INITIAL "Consulta valores de Faturamento/Devoluá‰es/SellOut utilizados como base para C†lculo de Benef°cios dos Canais" 
      VIEW-AS TEXT 
     SIZE 129 BY .67
     BGCOLOR 7 FGCOLOR 0 FONT 1 NO-UNDO.

DEFINE VARIABLE fi-total AS DECIMAL FORMAT "->>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Faturamento - Devol" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-total-rebate AS DECIMAL FORMAT "->>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Faturamento - Devol" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-unidade-fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-unidade-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unid. Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE IMAGE folder-1
     FILENAME "image\ts-up110.bmp":U
     SIZE 16 BY 1.21.

DEFINE IMAGE folder-4
     FILENAME "image\ts-dn110.bmp":U
     SIZE 16 BY 1.21.

DEFINE IMAGE IMAGE-27
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-28
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE rs-apuracao AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "C†lculo", 1,
"Provis∆o", 2
     SIZE 28.72 BY .75 NO-UNDO.

DEFINE RECTANGLE RECT-133
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 70 BY 4.

DEFINE RECTANGLE RECT-135
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 36 BY 4.

DEFINE RECTANGLE RECT-137
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 36 BY 4.

DEFINE RECTANGLE Rect-Main
     EDGE-PIXELS 1 GRAPHIC-EDGE    
     SIZE 136 BY 14.71
     BGCOLOR 8 FGCOLOR 0 .

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 143 BY 1.38
     BGCOLOR 7 .

DEFINE RECTANGLE rt-button-3
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 136 BY 1.38
     BGCOLOR 7 .

DEFINE BUTTON bt-consulta-nota 
     IMAGE-UP FILE "adeicon/prevw-u.bmp":U
     LABEL "" 
     SIZE 6 BY 1.75 TOOLTIP "Consulta Nota fiscal".

DEFINE BUTTON bt-excel-fat 
     IMAGE-UP FILE "image/excel.jpg":U
     LABEL "" 
     SIZE 6 BY 1.75 TOOLTIP "Exportar Faturamentos".

DEFINE VARIABLE fi-emitente-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 85.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-search AS CHARACTER FORMAT "X(256)":U 
     LABEL "Procurar por" 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88 NO-UNDO.

DEFINE BUTTON bt-consulta-doctos 
     IMAGE-UP FILE "adeicon/prevw-u.bmp":U
     LABEL "Button 1" 
     SIZE 6 BY 1.75 TOOLTIP "Consulta Documento".

DEFINE BUTTON bt-exporta-dev 
     IMAGE-UP FILE "image/excel.jpg":U
     LABEL "" 
     SIZE 6 BY 1.75 TOOLTIP "Exportar Devoluá‰es para Excel".

DEFINE VARIABLE fi-emitente AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 83.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-search-dev AS CHARACTER FORMAT "X(256)":U 
     LABEL "Procurar por" 
     VIEW-AS FILL-IN 
     SIZE 18.14 BY .88 NO-UNDO.

DEFINE VARIABLE rs-nota AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Recebimento", 1,
"Faturamento", 2
     SIZE 25 BY .79 NO-UNDO.

DEFINE RECTANGLE RECT-136
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 132 BY 2.21.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-devol FOR 
      tt-devol SCROLLING.

DEFINE QUERY br-fat FOR 
      tt-nota-det SCROLLING.

DEFINE QUERY br-nota FOR 
      tt-nota SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-devol
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-devol w-cadsim _FREEFORM
  QUERY br-devol DISPLAY
      tt-devol.ano           COLUMN-LABEL "Ano"          WIDTH 5
        tt-devol.mes           COLUMN-LABEL "Màs"        WIDTH 5
        tt-devol.canal         COLUMN-LABEL "Canal"      WIDTH 8
        tt-devol.unid-neg      COLUMN-LABEL "Unidade"    WIDTH 6 FORMAT "!!!"
        tt-devol.data          COLUMN-LABEL "data"       WIDTH 10
        tt-devol.cod-emitente  COLUMN-LABEL "Emitente"   WIDTH 8    
        tt-devol.serie-docto   COLUMN-LABEL "Ser Rec."   WIDTH 6    
        tt-devol.nro-docto     COLUMN-LABEL "Nr Doc Rec" WIDTH 8     
        tt-devol.nat-operacao  COLUMN-LABEL "Nat Rec"    WIDTH 6
        tt-devol.sequencia     COLUMN-LABEL "Seq"        WIDTH 4
        tt-devol.qt-devolvida  COLUMN-LABEL "Qtde Devol" WIDTH 8   
        tt-devol.vl-devolvido  COLUMN-LABEL "Vl Devol"  WIDTH 9
        tt-devol.vl-devolvido-rebate COLUMN-LABEL "Vl Devol Rebate"  WIDTH 11
        tt-devol.cod-estabel   COLUMN-LABEL "Estab"      WIDTH 5
        tt-devol.serie         COLUMN-LABEL "SÇrie"      WIDTH 5
        tt-devol.nr-nota-fis   COLUMN-LABEL "NF-e"       WIDTH 10
        tt-devol.nr-seq-fat    COLUMN-LABEL "Seq"        WIDTH 5    
        tt-devol.it-codigo     COLUMN-LABEL "Item"       WIDTH 15
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 132 BY 10
         FONT 7
         TITLE "Devoluá‰es" ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.

DEFINE BROWSE br-fat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-fat w-cadsim _FREEFORM
  QUERY br-fat DISPLAY
      tt-nota-det.ano         COLUMN-LABEL "Ano"      WIDTH 5 
       tt-nota-det.mes         COLUMN-LABEL "Màs"      WIDTH 5 
       tt-nota-det.canal       COLUMN-LABEL "Canal"    WIDTH 14 
       tt-nota-det.unid-neg    COLUMN-LABEL "Unid Neg" WIDTH 10 FORMAT "!!!"
       tt-nota-det.data        COLUMN-LABEL "Emiss∆o"  WIDTH 10 
       tt-nota-det.cod-estabel COLUMN-LABEL "Estab"    WIDTH 6 
       tt-nota-det.serie       COLUMN-LABEL "SÇrie"    WIDTH 6 
       tt-nota-det.nr-nota-fis COLUMN-LABEL "NF-e"     WIDTH 10 
       tt-nota-det.nr-seq-fat  COLUMN-LABEL "Seq"      WIDTH 6 
       tt-nota-det.it-codigo   COLUMN-LABEL "Item"     WIDTH 20 
       tt-nota-det.qt-faturada COLUMN-LABEL "Qtde"     WIDTH 15 
       tt-nota-det.vl-faturado COLUMN-LABEL "Valor"    WIDTH 15
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 132 BY 5.75
         FONT 7
         TITLE "Detalhe Itens" ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.

DEFINE BROWSE br-nota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-nota w-cadsim _FREEFORM
  QUERY br-nota DISPLAY
      tt-nota.ano          COLUMN-LABEL "Ano"      WIDTH 5
        tt-nota.mes          COLUMN-LABEL "Màs"      WIDTH 5
        tt-nota.central      COLUMN-LABEL "Central"   WIDTH 8
        tt-nota.filial       COLUMN-LABEL "Filial"   WIDTH 8
        tt-nota.cod-estabel  COLUMN-LABEL "Estab"    WIDTH 6
        tt-nota.serie        COLUMN-LABEL "SÇrie"    WIDTH 6
        tt-nota.nr-nota-fis  COLUMN-LABEL "NF-e"     WIDTH 10
        tt-nota.dt-emis-nota COLUMN-LABEL "Data Emiss∆o"  WIDTH 10
        tt-nota.vl-tot-nota  COLUMN-LABEL "Total Nota (Sem imposto)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 118 BY 6.75
         FONT 7
         TITLE "Faturamento Canal" ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     fi-periodo AT ROW 3.54 COL 21.43 COLON-ALIGNED NO-LABEL WIDGET-ID 118
     fi-nome AT ROW 4.58 COL 22.86 COLON-ALIGNED NO-LABEL WIDGET-ID 114
     fi-texto AT ROW 1.5 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 110
     cb-Ano AT ROW 3.38 COL 8.43 COLON-ALIGNED HELP
          "Màs de Apuraá∆o" WIDGET-ID 62
     rs-apuracao AT ROW 5.71 COL 42 NO-LABEL WIDGET-ID 56
     cb-mes AT ROW 3.38 COL 29.43 COLON-ALIGNED HELP
          "Màs de Apuraá∆o" NO-LABEL WIDGET-ID 44
     cb-trimestre AT ROW 3.38 COL 29.43 COLON-ALIGNED HELP
          "Màs de Apuraá∆o" NO-LABEL WIDGET-ID 60
     fi-canal-ini AT ROW 4.58 COL 8.29 COLON-ALIGNED WIDGET-ID 82
     fi-unidade-ini AT ROW 5.67 COL 16 COLON-ALIGNED WIDGET-ID 90
     fi-unidade-fim AT ROW 5.67 COL 31.29 COLON-ALIGNED NO-LABEL WIDGET-ID 96
     bt-refresh AT ROW 3.25 COL 65 HELP
          "Filtrar" WIDGET-ID 66
     fi-faturado AT ROW 3.58 COL 127.86 COLON-ALIGNED WIDGET-ID 78
     fi-devolvido AT ROW 4.67 COL 127.86 COLON-ALIGNED WIDGET-ID 76
     fi-total AT ROW 5.79 COL 128 COLON-ALIGNED WIDGET-ID 112
     bt-exit AT ROW 1.21 COL 140.43 HELP
          "Sair do programa"
     bt-ok AT ROW 23.42 COL 68.29 HELP
          "Sair do programa"
     fi-faturado-rebate AT ROW 3.63 COL 91.57 COLON-ALIGNED WIDGET-ID 132
     fi-devolvido-rebate AT ROW 4.71 COL 91.57 COLON-ALIGNED WIDGET-ID 130
     fi-total-rebate AT ROW 5.83 COL 91.72 COLON-ALIGNED WIDGET-ID 134
     "Faturamento" VIEW-AS TEXT
          SIZE 9.43 BY .67 AT ROW 7.38 COL 9.57 WIDGET-ID 50
          BGCOLOR 8 FONT 7
     "Devoluá‰es" VIEW-AS TEXT
          SIZE 10.29 BY .67 AT ROW 7.38 COL 25.43 WIDGET-ID 52
          BGCOLOR 8 FONT 7
     "Base p/ Apuraá∆o REBATE:" VIEW-AS TEXT
          SIZE 26 BY .5 AT ROW 2.79 COL 74 WIDGET-ID 100
     "ParÉmetros Pesquisa:" VIEW-AS TEXT
          SIZE 15.29 BY .75 AT ROW 2.54 COL 2.72 WIDGET-ID 102
     "Base demais Benef°cios:" VIEW-AS TEXT
          SIZE 23 BY .5 AT ROW 2.75 COL 111 WIDGET-ID 128
     rt-button AT ROW 1.08 COL 2
     folder-1 AT ROW 7.17 COL 6.29 WIDGET-ID 46
     folder-4 AT ROW 7.17 COL 22.29 WIDGET-ID 48
     Rect-Main AT ROW 8.42 COL 6.29 WIDGET-ID 54
     RECT-133 AT ROW 3 COL 2 WIDGET-ID 64
     IMAGE-27 AT ROW 5.67 COL 25.72 WIDGET-ID 92
     IMAGE-28 AT ROW 5.67 COL 29.72 WIDGET-ID 94
     RECT-135 AT ROW 3 COL 72.72 WIDGET-ID 98
     rt-button-3 AT ROW 23.21 COL 6.29 WIDGET-ID 104
     RECT-137 AT ROW 3 COL 109.43 WIDGET-ID 126
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 144.72 BY 23.58
         BGCOLOR 15 .

DEFINE FRAME fPage1
     fi-emitente-1 AT ROW 1.25 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 110
     fi-search AT ROW 1.17 COL 15.86 COLON-ALIGNED WIDGET-ID 82
     br-fat AT ROW 9.33 COL 2 WIDGET-ID 200
     bt-consulta-nota AT ROW 2.13 COL 128 WIDGET-ID 10
     bt-excel-fat AT ROW 7.29 COL 128 HELP
          "Filtrar Conta Corrente" WIDGET-ID 106
     br-nota AT ROW 2.25 COL 8.72 WIDGET-ID 500
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7.29 ROW 8.67
         SIZE 134 BY 14.21
         BGCOLOR 15 FGCOLOR 0 FONT 7 WIDGET-ID 400.

DEFINE FRAME fpage4
     fi-emitente AT ROW 1.21 COL 48 COLON-ALIGNED NO-LABEL WIDGET-ID 108
     fi-search-dev AT ROW 1.13 COL 9.29 COLON-ALIGNED WIDGET-ID 82
     br-devol AT ROW 2.25 COL 2 WIDGET-ID 500
     rs-nota AT ROW 13.54 COL 4 NO-LABEL WIDGET-ID 2
     bt-consulta-doctos AT ROW 13 COL 30.29 WIDGET-ID 10
     bt-exporta-dev AT ROW 13 COL 127.14 HELP
          "Exportar Devoluá‰es para Excel" WIDGET-ID 106
     "Consultar a devoluá∆o no:" VIEW-AS TEXT
          SIZE 18.14 BY .5 AT ROW 12.5 COL 2.86 WIDGET-ID 6
     RECT-136 AT ROW 12.79 COL 2 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7.29 ROW 8.67
         SIZE 134 BY 14.21
         BGCOLOR 15 FGCOLOR 0 FONT 7 WIDGET-ID 600.

DEFINE FRAME fpage5
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7.29 ROW 8.67
         SIZE 134 BY 12.04
         BGCOLOR 15 FGCOLOR 0 FONT 7 WIDGET-ID 700.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-cadsim ASSIGN
         HIDDEN             = YES
         TITLE              = "Manutená∆o <Insira o complemento>"
         HEIGHT             = 23.83
         WIDTH              = 146
         MAX-HEIGHT         = 27.71
         MAX-WIDTH          = 146
         VIRTUAL-HEIGHT     = 27.71
         VIRTUAL-WIDTH      = 146
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME f-cad:HANDLE
       FRAME fpage4:FRAME = FRAME f-cad:HANDLE
       FRAME fpage5:FRAME = FRAME f-cad:HANDLE.

/* SETTINGS FOR FRAME f-cad
   FRAME-NAME Custom                                                    */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

ASSIGN XXTABVALXX = FRAME fpage5:MOVE-AFTER-TAB-ITEM (fi-nome:HANDLE IN FRAME f-cad)
       XXTABVALXX = FRAME fpage5:MOVE-BEFORE-TAB-ITEM (cb-Ano:HANDLE IN FRAME f-cad)
       XXTABVALXX = FRAME fPage1:MOVE-AFTER-TAB-ITEM (rs-apuracao:HANDLE IN FRAME f-cad)
       XXTABVALXX = FRAME fpage4:MOVE-BEFORE-TAB-ITEM (cb-mes:HANDLE IN FRAME f-cad)
       XXTABVALXX = FRAME fPage1:MOVE-BEFORE-TAB-ITEM (FRAME fpage4:HANDLE)
/* END-ASSIGN-TABS */.

ASSIGN 
       bt-ok:HIDDEN IN FRAME f-cad           = TRUE.

ASSIGN 
       fi-devolvido:READ-ONLY IN FRAME f-cad        = TRUE.

ASSIGN 
       fi-devolvido-rebate:READ-ONLY IN FRAME f-cad        = TRUE.

ASSIGN 
       fi-faturado:READ-ONLY IN FRAME f-cad        = TRUE.

ASSIGN 
       fi-faturado-rebate:READ-ONLY IN FRAME f-cad        = TRUE.

/* SETTINGS FOR FILL-IN fi-nome IN FRAME f-cad
   NO-ENABLE                                                            */
ASSIGN 
       fi-nome:READ-ONLY IN FRAME f-cad        = TRUE.

ASSIGN 
       fi-texto:READ-ONLY IN FRAME f-cad        = TRUE.

ASSIGN 
       fi-total:READ-ONLY IN FRAME f-cad        = TRUE.

ASSIGN 
       fi-total-rebate:READ-ONLY IN FRAME f-cad        = TRUE.

/* SETTINGS FOR RADIO-SET rs-apuracao IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
/* BROWSE-TAB br-fat fi-search fPage1 */
/* BROWSE-TAB br-nota bt-excel-fat fPage1 */
ASSIGN 
       br-fat:ALLOW-COLUMN-SEARCHING IN FRAME fPage1 = TRUE
       br-fat:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE.

ASSIGN 
       br-nota:ALLOW-COLUMN-SEARCHING IN FRAME fPage1 = TRUE
       br-nota:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE.

ASSIGN 
       fi-emitente-1:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FRAME fpage4
   Custom                                                               */
/* BROWSE-TAB br-devol fi-search-dev fpage4 */
ASSIGN 
       br-devol:ALLOW-COLUMN-SEARCHING IN FRAME fpage4 = TRUE
       br-devol:COLUMN-RESIZABLE IN FRAME fpage4       = TRUE.

ASSIGN 
       fi-emitente:READ-ONLY IN FRAME fpage4        = TRUE.

/* SETTINGS FOR FRAME fpage5
   Custom                                                               */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-devol
/* Query rebuild information for BROWSE br-devol
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-devol BY tt-devol.data
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-devol */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-fat
/* Query rebuild information for BROWSE br-fat
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-nota-det NO-LOCK
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-fat */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-nota
/* Query rebuild information for BROWSE br-nota
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-nota NO-LOCK BY tt-nota.dt-emis-nota
                                                 BY tt-nota.cod-estabel
                                                 BY tt-nota.serie
                                                 BY tt-nota.nr-nota-fis
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-nota */
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


&Scoped-define BROWSE-NAME br-devol
&Scoped-define FRAME-NAME fpage4
&Scoped-define SELF-NAME br-devol
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-devol w-cadsim
ON MOUSE-SELECT-DBLCLICK OF br-devol IN FRAME fpage4 /* Devoluá‰es */
DO:
/*   IF NOT AVAIL tt-nota THEN                                         */
/*       RETURN.                                                       */
/*                                                                     */
/*   FIND FIRST nota-fiscal NO-LOCK                                    */
/*       WHERE nota-fiscal.cod-estabel = tt-nota.cod-estabel           */
/*         AND nota-fiscal.serie       = tt-nota.serie                 */
/*         AND nota-fiscal.nr-nota-fis = tt-nota.nr-nota-fis NO-ERROR. */
/*                                                                     */
/*   IF  AVAIL nota-fiscal THEN DO:                                    */
/*                                                                     */
/*       ASSIGN gr-nota-fiscal = ROWID(nota-fiscal).                   */
/*       RUN ftp/ft0904.w.                                             */
/*                                                                     */
/*   END.                                                              */
/*                                                                     */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-devol w-cadsim
ON START-SEARCH OF br-devol IN FRAME fpage4 /* Devoluá‰es */
DO:
  
    DEFINE VARIABLE i_count AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i_index AS INTEGER     NO-UNDO.

    SELF:CLEAR-SORT-ARROWS().

    IF SELF:CURRENT-COLUMN:TABLE = "":U OR
       SELF:CURRENT-COLUMN:TABLE = ?    THEN
        RETURN NO-APPLY.

    IF v_column <> SELF:CURRENT-COLUMN:NAME THEN
        ASSIGN v_column = SELF:CURRENT-COLUMN:NAME
               v_asc    = YES.
    ELSE
        ASSIGN v_asc = NOT v_asc.

    IF v_asc THEN
        SELF:QUERY:QUERY-PREPARE("FOR EACH ":U + SELF:CURRENT-COLUMN:TABLE + " ":U +
                                 "    OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME).
    ELSE
        SELF:QUERY:QUERY-PREPARE("FOR EACH ":U + SELF:CURRENT-COLUMN:TABLE + " ":U +
                                 "    OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME + " DESC":U).
            
    DO i_count = 1 TO SELF:NUM-COLUMNS:
        IF SELF:CURRENT-COLUMN = SELF:GET-BROWSE-COLUMN(i_count) THEN
            ASSIGN i_index = i_count.
    END.

    SELF:SET-SORT-ARROW(i_index, v_asc).

    SELF:QUERY:QUERY-OPEN().

    /*{&open-query-br-devol}*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-devol w-cadsim
ON VALUE-CHANGED OF br-devol IN FRAME fpage4 /* Devoluá‰es */
DO:
  IF  AVAIL tt-devol THEN
      ASSIGN fi-emitente:SCREEN-VALUE IN FRAME fpage4 = tt-devol.nome-abrev + " - " + 
                                                        tt-devol.nome-emit  + " - CGC: " + 
                                                        tt-devol.cgc.
  ELSE
      ASSIGN fi-emitente:SCREEN-VALUE IN FRAME fpage4 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-fat
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME br-fat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-fat w-cadsim
ON START-SEARCH OF br-fat IN FRAME fPage1 /* Detalhe Itens */
DO:
  
    DEFINE VARIABLE i_count AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i_index AS INTEGER     NO-UNDO.

    SELF:CLEAR-SORT-ARROWS().

    IF SELF:CURRENT-COLUMN:TABLE = "":U OR
       SELF:CURRENT-COLUMN:TABLE = ?    THEN
        RETURN NO-APPLY.

    IF v_column <> SELF:CURRENT-COLUMN:NAME THEN
        ASSIGN v_column = SELF:CURRENT-COLUMN:NAME
               v_asc    = YES.
    ELSE
        ASSIGN v_asc = NOT v_asc.

    IF v_asc THEN
        SELF:QUERY:QUERY-PREPARE("FOR EACH ":U + SELF:CURRENT-COLUMN:TABLE + " ":U +
                                 "    OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME).
    ELSE
        SELF:QUERY:QUERY-PREPARE("FOR EACH ":U + SELF:CURRENT-COLUMN:TABLE + " ":U +
                                 "    OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME + " DESC":U).
            
    DO i_count = 1 TO SELF:NUM-COLUMNS:
        IF SELF:CURRENT-COLUMN = SELF:GET-BROWSE-COLUMN(i_count) THEN
            ASSIGN i_index = i_count.
    END.

    SELF:SET-SORT-ARROW(i_index, v_asc).

    SELF:QUERY:QUERY-OPEN().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-nota
&Scoped-define SELF-NAME br-nota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-nota w-cadsim
ON MOUSE-SELECT-DBLCLICK OF br-nota IN FRAME fPage1 /* Faturamento Canal */
DO:
  IF NOT AVAIL tt-nota THEN
      RETURN.

  FIND FIRST nota-fiscal NO-LOCK
      WHERE nota-fiscal.cod-estabel = tt-nota.cod-estabel
        AND nota-fiscal.serie       = tt-nota.serie
        AND nota-fiscal.nr-nota-fis = tt-nota.nr-nota-fis NO-ERROR.

  IF  AVAIL nota-fiscal THEN DO:
  
      ASSIGN gr-nota-fiscal = ROWID(nota-fiscal).
      RUN ftp/ft0904.w.

  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-nota w-cadsim
ON START-SEARCH OF br-nota IN FRAME fPage1 /* Faturamento Canal */
DO:
  
    DEFINE VARIABLE i_count AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i_index AS INTEGER     NO-UNDO.

    SELF:CLEAR-SORT-ARROWS().

    IF SELF:CURRENT-COLUMN:TABLE = "":U OR
       SELF:CURRENT-COLUMN:TABLE = ?    THEN
        RETURN NO-APPLY.

    IF v_column <> SELF:CURRENT-COLUMN:NAME THEN
        ASSIGN v_column = SELF:CURRENT-COLUMN:NAME
               v_asc    = YES.
    ELSE
        ASSIGN v_asc = NOT v_asc.

    IF v_asc THEN
        SELF:QUERY:QUERY-PREPARE("FOR EACH ":U + SELF:CURRENT-COLUMN:TABLE + " ":U +
                                 "    OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME).
    ELSE
        SELF:QUERY:QUERY-PREPARE("FOR EACH ":U + SELF:CURRENT-COLUMN:TABLE + " ":U +
                                 "    OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME + " DESC":U).
            
    DO i_count = 1 TO SELF:NUM-COLUMNS:
        IF SELF:CURRENT-COLUMN = SELF:GET-BROWSE-COLUMN(i_count) THEN
            ASSIGN i_index = i_count.
    END.

    SELF:SET-SORT-ARROW(i_index, v_asc).

    SELF:QUERY:QUERY-OPEN().

    {&open-query-br-fat}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-nota w-cadsim
ON VALUE-CHANGED OF br-nota IN FRAME fPage1 /* Faturamento Canal */
DO:
   IF  AVAIL tt-nota THEN
       ASSIGN fi-emitente-1:SCREEN-VALUE IN FRAME fpage1 = tt-nota.nome-abrev + " - " + 
                                                           tt-nota.nome-emit  + " - CGC: " + 
                                                           tt-nota.cgc.
   ELSE
       ASSIGN fi-emitente-1:SCREEN-VALUE IN FRAME fpage1 = "".

   RUN pi-busca-detalhes-nota.                                                    
                                                                   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage4
&Scoped-define SELF-NAME bt-consulta-doctos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-consulta-doctos w-cadsim
ON CHOOSE OF bt-consulta-doctos IN FRAME fpage4 /* Button 1 */
DO:
  
    IF  NOT AVAIL tt-devol THEN 
        RETURN.


    IF  rs-nota:SCREEN-VALUE IN FRAME fpage4 = "1" THEN DO:
        FIND FIRST docum-est NO-LOCK
            WHERE docum-est.serie-docto   = tt-devol.serie-docto 
              AND docum-est.nro-docto     = tt-devol.nro-docto   
              AND docum-est.nat-operacao  = tt-devol.nat-operacao
              AND docum-est.cod-emitente  = tt-devol.cod-emitente NO-ERROR.
        IF  AVAIL docum-est THEN DO:
            ASSIGN gr-documento = ROWID(docum-est).
            RUN rep/re0701a.w.
        END.
    END.
    ELSE DO:
        FIND FIRST it-nota-fisc NO-LOCK
            WHERE it-nota-fisc.cod-estabel  = tt-devol.cod-estabel 
              AND it-nota-fisc.serie        = tt-devol.serie   
              AND it-nota-fisc.nr-nota-fis  = tt-devol.nr-nota-fis
              AND it-nota-fisc.nr-seq-fat   = tt-devol.nr-seq-fat
              AND it-nota-fisc.it-codigo    = tt-devol.it-codigo  NO-ERROR.
        IF  AVAIL it-nota-fisc THEN DO:
            ASSIGN gr-it-nota-fisc = ROWID(it-nota-fisc).
            RUN ftp/ft0904c.w.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-consulta-nota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-consulta-nota w-cadsim
ON CHOOSE OF bt-consulta-nota IN FRAME fPage1
DO:
  
  IF NOT AVAIL tt-nota THEN
      RETURN.

  FIND FIRST nota-fiscal NO-LOCK
      WHERE nota-fiscal.cod-estabel = tt-nota.cod-estabel
        AND nota-fiscal.serie       = tt-nota.serie
        AND nota-fiscal.nr-nota-fis = tt-nota.nr-nota-fis NO-ERROR.

  IF  AVAIL nota-fiscal THEN DO:
  
      ASSIGN gr-nota-fiscal = ROWID(nota-fiscal).
      RUN ftp/ft0904.w.

  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-excel-fat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-excel-fat w-cadsim
ON CHOOSE OF bt-excel-fat IN FRAME fPage1
DO:

    RUN pi-gera-excel-fat.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-cad
&Scoped-define SELF-NAME bt-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-exit w-cadsim
ON CHOOSE OF bt-exit IN FRAME f-cad
DO:
  APPLY "close" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage4
&Scoped-define SELF-NAME bt-exporta-dev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-exporta-dev w-cadsim
ON CHOOSE OF bt-exporta-dev IN FRAME fpage4
DO:

    RUN pi-gera-excel-dev.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-cad
&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-cadsim
ON CHOOSE OF bt-ok IN FRAME f-cad /* Fechar */
DO:
  RUN notify ('update-record':U).
  if return-value <> "adm-error":U then
     apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-refresh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-refresh w-cadsim
ON CHOOSE OF bt-refresh IN FRAME f-cad
DO:

  ASSIGN tt-param.canal-ini  = int(fi-canal-ini:SCREEN-VALUE IN FRAME f-cad)
         tt-param.unid-ini   = fi-unidade-ini:SCREEN-VALUE IN FRAME f-cad
         tt-param.unid-fim   = fi-unidade-fim:SCREEN-VALUE IN FRAME f-cad.

  
  IF  NOT VALID-HANDLE(h-acomp) THEN                                  
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.                      

  RUN pi-inicializar IN h-acomp (INPUT "Carregando Apuraá∆o").
  RUN pi-Acompanhar  IN h-acomp (INPUT "Buscando faturamentos do per°odo...").

  /*FATURAMENTOS*/
  EMPTY TEMP-TABLE tt-central.
  EMPTY TEMP-TABLE tt-erro.
  RUN pi-carrega-central.
  IF  RETURN-VALUE <> "OK" THEN DO:
      RUN pi-finalizar IN h-acomp.
      RETURN "NOK".
  END.

  RUN pi-carrega-tt-nota.
  RUN pi-busca-detalhes-nota.
  
  /*DEVOLUÄÂES*/
  RUN pi-carrega-tt-devol.

  RUN pi-busca-totais.

  APPLY "VALUE-CHANGED" TO br-devol IN FRAME fpage4.
  APPLY "VALUE-CHANGED" TO br-nota  IN FRAME fpage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-trimestre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-trimestre w-cadsim
ON VALUE-CHANGED OF cb-trimestre IN FRAME f-cad
DO:
  
    CASE cb-trimestre:SCREEN-VALUE IN FRAME f-cad.
        WHEN "Primeiro" THEN ASSIGN i-mes-tri-ini = 1
                                    i-mes-tri-fim = 3.
        WHEN "Segundo"  THEN ASSIGN i-mes-tri-ini = 4
                                    i-mes-tri-fim = 6.
        WHEN "Terceiro" THEN ASSIGN i-mes-tri-ini = 7
                                    i-mes-tri-fim = 9.
        WHEN "quarto"   THEN ASSIGN i-mes-tri-ini = 10
                                    i-mes-tri-fim = 12.
    END CASE.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-canal-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-canal-ini w-cadsim
ON F5 OF fi-canal-ini IN FRAME f-cad /* Canal */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad098.w"
                     &campo="fi-canal-ini"
                     &campozoom="cod-emitente"
                     &frame="f-cad"
                     &campo2="fi-nome"
                     &campozoom2="nome-emit"
                     &frame2="f-cad"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-canal-ini w-cadsim
ON LEAVE OF fi-canal-ini IN FRAME f-cad /* Canal */
DO:

    RUN pi-carrega-central.

    FIND FIRST tt-central NO-ERROR.

    IF  AVAIL tt-central THEN DO:
        ASSIGN fi-canal-ini:SCREEN-VALUE IN FRAME f-cad = string(tt-central.canal-central).

        FIND FIRST emitente NO-LOCK
            WHERE emitente.cod-emitente = tt-central.canal-central NO-ERROR.
        IF  AVAIL emitente THEN 
            ASSIGN fi-nome:SCREEN-VALUE IN FRAME f-cad = emitente.nome-emit.
        ELSE
            ASSIGN fi-nome:SCREEN-VALUE IN FRAME f-cad = "".
    END.
    ELSE
        ASSIGN fi-canal-ini:SCREEN-VALUE IN FRAME f-cad = "0"
               fi-nome:SCREEN-VALUE IN FRAME f-cad = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-canal-ini w-cadsim
ON MOUSE-SELECT-DBLCLICK OF fi-canal-ini IN FRAME f-cad /* Canal */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME fi-search
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-search w-cadsim
ON ANY-KEY OF fi-search IN FRAME fPage1 /* Procurar por */
DO:

  ASSIGN c-fat = fi-search:SCREEN-VALUE IN FRAME fpage1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-search w-cadsim
ON VALUE-CHANGED OF fi-search IN FRAME fPage1 /* Procurar por */
DO:

  APPLY "ANY-KEY" TO SELF.

  DEF BUFFER b-tt-nota FOR tt-nota.
  DEF VAR i AS INTEGER NO-UNDO.
  DEF VAR l-string AS LOG NO-UNDO.  
    
  IF  c-fat = "" THEN DO:
      FIND FIRST b-tt-nota NO-ERROR.
    
      IF  AVAIL b-tt-nota THEN
          REPOSITION br-nota TO ROWID b-tt-nota.r-rowid.

      APPLY "VALUE-CHANGED" TO br-nota IN FRAME fpage1.
      RETURN "OK".
  END.

  c-fat = "*" + c-fat + "*".

  FIND FIRST b-tt-nota
      WHERE b-tt-nota.c-search MATCHES c-fat NO-ERROR.

  IF  AVAIL b-tt-nota THEN
      REPOSITION br-nota TO ROWID b-tt-nota.r-rowid.

  APPLY "VALUE-CHANGED" TO br-nota IN FRAME fpage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage4
&Scoped-define SELF-NAME fi-search-dev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-search-dev w-cadsim
ON ANY-KEY OF fi-search-dev IN FRAME fpage4 /* Procurar por */
DO:

    ASSIGN c-dev = fi-search-dev:SCREEN-VALUE IN FRAME fpage4.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-search-dev w-cadsim
ON VALUE-CHANGED OF fi-search-dev IN FRAME fpage4 /* Procurar por */
DO:

  APPLY "ANY-KEY" TO SELF.

  DEF BUFFER b-tt-devol FOR tt-devol.
  DEF VAR i AS INTEGER NO-UNDO.
  DEF VAR l-string AS LOG NO-UNDO.  

  IF  c-dev = "" THEN DO:
      FIND LAST b-tt-devol NO-ERROR.
    
      IF  AVAIL b-tt-devol THEN
          REPOSITION br-devol TO ROWID b-tt-devol.r-rowid.

      APPLY "VALUE-CHANGED" TO br-devol IN FRAME fpage4.

      RETURN "OK".
  END.

    
  c-dev = "*" + c-dev + "*".

  FIND FIRST b-tt-devol
      WHERE b-tt-devol.c-search MATCHES c-dev NO-ERROR.

  IF  AVAIL b-tt-devol THEN
      REPOSITION br-devol TO ROWID b-tt-devol.r-rowid.

    APPLY "VALUE-CHANGED" TO br-devol IN FRAME fpage4.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-cad
&Scoped-define SELF-NAME folder-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL folder-1 w-cadsim
ON MOUSE-SELECT-CLICK OF folder-1 IN FRAME f-cad
DO:
  folder-1:LOAD-IMAGE("image/ts-up110.bmp").
  folder-4:LOAD-IMAGE("image/ts-dn110.bmp").
  
  VIEW FRAME fPage1.
  HIDE FRAME fPage4.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME folder-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL folder-4 w-cadsim
ON MOUSE-SELECT-CLICK OF folder-4 IN FRAME f-cad
DO:
  folder-1:LOAD-IMAGE("image/ts-dn110.bmp").
  folder-4:LOAD-IMAGE("image/ts-up110.bmp").
  
  HIDE FRAME fPage1.
  VIEW FRAME fPage4.
  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-apuracao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-apuracao w-cadsim
ON VALUE-CHANGED OF rs-apuracao IN FRAME f-cad
DO:
  DO WITH FRAME f-cad:
  
      IF  rs-apuracao:SCREEN-VALUE = "2" THEN 
          ASSIGN cb-mes:VISIBLE       = YES
                 cb-trimestre:VISIBLE = NO.
      ELSE
          ASSIGN cb-mes:VISIBLE       = NO
                 cb-trimestre:VISIBLE = YES.

  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-devol
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
  DISPLAY fi-periodo fi-nome fi-texto cb-Ano rs-apuracao cb-mes cb-trimestre 
          fi-canal-ini fi-unidade-ini fi-unidade-fim fi-faturado fi-devolvido 
          fi-total fi-faturado-rebate fi-devolvido-rebate fi-total-rebate 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  ENABLE fi-periodo fi-texto cb-Ano cb-mes cb-trimestre fi-canal-ini 
         fi-unidade-ini fi-unidade-fim bt-refresh fi-faturado fi-devolvido 
         fi-total rt-button bt-exit folder-1 bt-ok folder-4 Rect-Main RECT-133 
         IMAGE-27 IMAGE-28 RECT-135 rt-button-3 RECT-137 fi-faturado-rebate 
         fi-devolvido-rebate fi-total-rebate 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  DISPLAY fi-emitente-1 fi-search 
      WITH FRAME fPage1 IN WINDOW w-cadsim.
  ENABLE fi-emitente-1 fi-search br-fat bt-consulta-nota bt-excel-fat br-nota 
      WITH FRAME fPage1 IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-fPage1}
  DISPLAY fi-emitente fi-search-dev rs-nota 
      WITH FRAME fpage4 IN WINDOW w-cadsim.
  ENABLE fi-emitente fi-search-dev br-devol rs-nota bt-consulta-doctos 
         bt-exporta-dev RECT-136 
      WITH FRAME fpage4 IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-fpage4}
  VIEW FRAME fpage5 IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-fpage5}
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
  IF VALID-HANDLE(h-acomp) THEN 
    RUN pi-finalizar IN h-acomp. 

  r-row-canal = ?. 
  r-row-cc    = ?. 

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

  {utp/ut9000.i "ESESB008f" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  RUN dispatch  IN this-procedure ('enable-fields':U).

  APPLY "mouse-select-dbclick" TO folder-1 IN FRAME f-cad.

  folder-1:LOAD-IMAGE("image/ts-up110.bmp").
  folder-4:LOAD-IMAGE("image/ts-dn110.bmp").
  
  VIEW FRAME fPage1.
  HIDE FRAME fPage4.
  HIDE FRAME fPage5.


  FIND FIRST int-cc-benef NO-LOCK
      WHERE rowid(int-cc-benef) = r-row-cc NO-ERROR.

  FIND FIRST int-emitente NO-LOCK
      WHERE rowid(int-emitente) = r-row-canal NO-ERROR.
  
  FIND FIRST tt-param NO-ERROR.

  IF  NOT AVAIL tt-param THEN
      CREATE tt-param.

  IF  AVAIL int-cc-benef THEN DO:

      ASSIGN tt-param.ano       = YEAR (int-cc-benef.dt-periodo-fim)
             tt-param.mes       = MONTH(int-cc-benef.dt-periodo-fim)
             tt-param.canal-ini = int-cc-benef.canal
             tt-param.unid-ini  = int-cc-benef.unid-neg
             tt-param.unid-fim  = int-cc-benef.unid-neg.
             
      DO WITH FRAME f-cad:

          ASSIGN fi-canal-ini:SCREEN-VALUE   = string(tt-param.canal-ini)
                 fi-unidade-ini:SCREEN-VALUE = tt-param.unid-ini
                 fi-unidade-fim:SCREEN-VALUE = tt-param.unid-fim.


          ASSIGN cb-ano:SCREEN-VALUE       = STRING(YEAR (int-cc-benef.dt-periodo-fim))
                 cb-trimestre:SCREEN-VALUE = fnTrimestre(INT( month(int-cc-benef.dt-periodo-fim) ))
                 cb-mes:VISIBLE            = NO
                 cb-trimestre:VISIBLE      = YES
                 cb-trimestre:SCREEN-VALUE = fnTrimestre(INT( month(int-cc-benef.dt-periodo-fim) ))
                 rs-apuracao:SCREEN-VALUE  = IF int-cc-benef.tp-movto = 2 THEN "1" ELSE '2'
                 fi-periodo:SCREEN-VALUE   = IF int-cc-benef.tp-movto = 2 THEN "Trimestre:" ELSE '     Màs:'.

      END.
      APPLY "LEAVE" TO fi-canal-ini IN FRAME f-cad.
      APPLY "VALUE-CHANGED" TO cb-trimestre.
      APPLY "CHOOSE" TO bt-refresh IN FRAME f-cad.
  END.
  ELSE DO:
       
/*       IF  AVAIL int-emitente THEN DO:                                             */
/*           ASSIGN tt-param.ano       = YEAR (TODAY)                                */
/*                  tt-param.mes       = MONTH(TODAY)                                */
/*                  tt-param.canal-ini = int-emitente.cod-emitente                   */
/*                  tt-param.unid-ini  = ""                                          */
/*                  tt-param.unid-fim  = "ZZZ".                                      */
/*                                                                                   */
/*           DO WITH FRAME f-cad:                                                    */
/*               ASSIGN cb-ano:SCREEN-VALUE       = STRING(YEAR (TODAY))             */
/*                      cb-mes:SCREEN-VALUE       = fnMesExt(int(MONTH(TODAY)))      */
/*                      cb-mes:VISIBLE            = YES                              */
/*                      cb-trimestre:SCREEN-VALUE = fnTrimestre(INT( month(TODAY) )) */
/*                      cb-trimestre:VISIBLE      = NO                               */
/*                      rs-apuracao:SCREEN-VALUE  = "2".                             */
/*                                                                                   */
/*           END.                                                                    */
/* /*           APPLY "LEAVE" TO fi-canal-ini IN FRAME f-cad.  */                    */
/* /*           APPLY "CHOOSE" TO bt-refresh IN FRAME f-cad.   */                    */
/*           APPLY "LEAVE" TO fi-canal-ini IN FRAME f-cad.                           */
/*           APPLY "VALUE-CHANGED" TO cb-trimestre.                                  */
/*           APPLY "CHOOSE" TO bt-refresh IN FRAME f-cad.                            */
/*       END.                                                                        */
/*       ELSE DO:                                                                    */
          ASSIGN tt-param.ano       = YEAR (TODAY)
                 tt-param.mes       = MONTH(TODAY)
                 tt-param.canal-ini = 0
                 tt-param.unid-ini  = ""
                 tt-param.unid-fim  = "ZZZ".
                 
          DO WITH FRAME f-cad:
              ASSIGN cb-ano:SCREEN-VALUE       = STRING(YEAR (TODAY))
                     cb-mes:SCREEN-VALUE       = fnMesExt(int(MONTH(TODAY)))
                     cb-mes:VISIBLE            = NO
                     cb-trimestre:SCREEN-VALUE = fnTrimestre(INT( month(TODAY) ))
                     cb-trimestre:VISIBLE      = YES
                     rs-apuracao:SCREEN-VALUE  = "1"
                     fi-periodo:SCREEN-VALUE   = "Trimestre:" .
          END.
          APPLY "VALUE-CHANGED" TO cb-trimestre.
/*       END. */


  END.
/*                                                    */
/*                                                    */
/*   {&open-query-br-fat}                             */
/*                                                    */
/*   APPLY "value-changed" TO br-fat IN FRAME fpage1. */
/*                                                    */

  {include/i-inifld.i}

  RUN pi_aplica_facelift_thin IN h-facelift (INPUT FRAME fpage1:HANDLE ).
  /*RUN pi_aplica_facelift_thin IN h-facelift (INPUT FRAME fpage4:HANDLE ).*/

  ASSIGN fi-texto:FONT IN FRAME f-cad = 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-detalhes-nota w-cadsim 
PROCEDURE pi-busca-detalhes-nota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  EMPTY TEMP-TABLE tt-nota-det.

  IF  tt-param.unid-ini = "" AND tt-param.unid-fim = "ZZZ" THEN DO:
      FOR EACH int-fat-mensal-det NO-LOCK
         WHERE int-fat-mensal-det.tp-movto    = tt-nota.tp-movto   
           AND int-fat-mensal-det.ano         = tt-nota.ano        
           AND int-fat-mensal-det.mes         = tt-nota.mes            
           AND int-fat-mensal-det.canal       = tt-nota.central                           
           AND int-fat-mensal-det.cod-estabel = tt-nota.cod-estabel                                           
           AND int-fat-mensal-det.serie       = tt-nota.serie                                                            
           AND int-fat-mensal-det.nr-nota-fis = tt-nota.nr-nota-fis  :
    
         CREATE tt-nota-det.
         BUFFER-COPY int-fat-mensal-det TO tt-nota-det.
      END.                                                                                                          
  END.
  ELSE DO:
      FOR EACH int-fat-mensal-det NO-LOCK
         WHERE int-fat-mensal-det.tp-movto    = tt-nota.tp-movto   
           AND int-fat-mensal-det.ano         = tt-nota.ano        
           AND int-fat-mensal-det.mes         = tt-nota.mes                  
           AND int-fat-mensal-det.canal       = tt-nota.central    
           AND int-fat-mensal-det.unid-neg    = tt-nota.unid-neg
           AND int-fat-mensal-det.cod-estabel = tt-nota.cod-estabel                                           
           AND int-fat-mensal-det.serie       = tt-nota.serie                                                            
           AND int-fat-mensal-det.nr-nota-fis = tt-nota.nr-nota-fis  :
    
         CREATE tt-nota-det.
         BUFFER-COPY int-fat-mensal-det TO tt-nota-det.
      END.                                                                                                          
                                                                                                    
  END.
  {&open-query-br-fat}    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-totais w-cadsim 
PROCEDURE pi-busca-totais :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR de-tot-faturado         AS DEC NO-UNDO.
    DEF VAR de-tot-devolvido        AS DEC NO-UNDO.
    DEF VAR de-tot-faturado-rebate  AS DEC NO-UNDO.
    DEF VAR de-tot-devolvido-rebate AS DEC NO-UNDO.
    
    DEF VAR c-tipo AS CHAR NO-UNDO.
    
    IF  INT(rs-apuracao:SCREEN-VALUE IN FRAME f-cad) = 1 THEN
        c-tipo = "C".
    ELSE 
        c-tipo = "P".

    RUN pi-acompanhar IN h-acomp ("Gerando totais Fat/Devol no per°odo...").

    FOR EACH int-fat-mensal NO-LOCK
       WHERE int-fat-mensal.ano = INT(cb-ano:SCREEN-VALUE IN FRAME f-cad)
         AND (IF  c-tipo = "P" THEN
                   int-fat-mensal.mes = fnMes(cb-mes:SCREEN-VALUE IN FRAME f-cad)
              ELSE
                  (int-fat-mensal.mes >= i-mes-tri-ini AND int-fat-mensal.mes <= i-mes-tri-fim)
              )
         AND int-fat-mensal.canal     = tt-param.canal-ini
         AND int-fat-mensal.unid-neg >= tt-param.unid-ini
         AND int-fat-mensal.unid-neg <= tt-param.unid-fim:

         ASSIGN de-tot-faturado  = de-tot-faturado  + int-fat-mensal.vl-faturado
                de-tot-devolvido = de-tot-devolvido + int-fat-mensal.vl-devolvido.

         /* S¢ considerando o que n∆o foi vendido/devolvido com rebate antecipado */
         ASSIGN de-tot-faturado-rebate  = de-tot-faturado-rebate  + int-fat-mensal.vl-faturado-rebate
                de-tot-devolvido-rebate = de-tot-devolvido-rebate + int-fat-mensal.vl-devolvido-rebate.         
    END.

    DO WITH FRAME f-cad:
        ASSIGN fi-faturado:SCREEN-VALUE  = string(de-tot-faturado)
               fi-devolvido:SCREEN-VALUE = string(de-tot-devolvido)
               fi-total:SCREEN-VALUE     = STRING(de-tot-faturado - de-tot-devolvido).
            
        ASSIGN fi-faturado-rebate:SCREEN-VALUE  = string(de-tot-faturado-rebate)                                       
               fi-devolvido-rebate:SCREEN-VALUE = string(de-tot-devolvido-rebate)                                      
               fi-total-rebate:SCREEN-VALUE     = STRING(de-tot-faturado-rebate - de-tot-devolvido-rebate).  

    END.
    
    RUN pi-finalizar IN h-acomp.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-central w-cadsim 
PROCEDURE pi-carrega-central :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* CANAIS ESTRUTURA CENTRAL - FILIAL COM BASE NA DIGITAÄ«O DO USUµRIO*/
    IF  fi-canal-ini:SCREEN-VALUE IN FRAME f-cad <> "0" THEN DO:
    
        RUN esp/esb/esesbapi005.p (INPUT fi-canal-ini:SCREEN-VALUE IN FRAME f-cad,
                                   OUTPUT TABLE tt-central,
                                   OUTPUT TABLE tt-erro).
    
        IF  RETURN-VALUE <> "OK" 
        OR  CAN-FIND (FIRST tt-erro) THEN DO:
            FOR EACH tt-erro:
                RUN utp/ut-msgs.p(INPUT "show",
                                  INPUT 17006,
                                  INPUT tt-erro.mensagem + "~~" + 
                                        tt-erro.ajuda).
            END.
            RETURN "NOK".
        END.

/*         /*Cria a lista com todos as filiais*/                                                        */
/*         DEF BUFFER b-emitente-aux FOR emitente.                                                      */
/*                                                                                                      */
/*         FIND FIRST tt-central.                                                                       */
/*                                                                                                      */
/*         FIND FIRST emitente NO-LOCK                                                                  */
/*             WHERE emitente.cod-emitente = tt-central.canal-central NO-ERROR.                         */
/*                                                                                                      */
/*         EMPTY TEMP-TABLE tt-central-lista.                                                           */
/*                                                                                                      */
/*         FOR EACH b-emitente-aux NO-LOCK                                                              */
/*             WHERE b-emitente-aux.nome-matriz = emitente.nome-abrev                                   */
/*             ,FIRST int-emitente NO-LOCK                                                              */
/*                 WHERE int-emitente.cod-emitente = b-emitente-aux.cod-emitente                        */
/*                   AND int-emitente.ind-apuracao-beneficio = 993520000: /*filial apura centralizada*/ */
/*                                                                                                      */
/*                 CREATE tt-central-lista.                                                             */
/*                 ASSIGN tt-central-lista.canal-central = tt-central.canal-central                     */
/*                        tt-central-lista.canal-filial  = int-emitente.cod-emitente.                   */
/*                                                                                                      */
/*                 MESSAGE "tt-central-lista.canal-central: " tt-central-lista.canal-central SKIP       */
/*                         "tt-central-lista.canal-filial : " tt-central-lista.canal-filial             */
/*                     VIEW-AS ALERT-BOX INFO BUTTONS OK.                                               */
/*                                                                                                      */
/*                                                                                                      */
/*             END.                                                                                     */
/*                                                                                                      */

    END.
    ELSE
        RETURN "OK".

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-tt-devol w-cadsim 
PROCEDURE pi-carrega-tt-devol :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-devol.

    RUN pi-acompanhar IN h-acomp ("Buscado Devoluá‰es no per°odo...").

    DEF VAR c-tipo AS CHAR NO-UNDO.

    IF  INT(rs-apuracao:SCREEN-VALUE IN FRAME f-cad) = 1 THEN
        c-tipo = "C".
    ELSE 
        c-tipo = "P".
    
    FOR EACH tt-central
       ,EACH int-fat-mensal-det NO-LOCK
       WHERE int-fat-mensal-det.ano = INT(cb-ano:SCREEN-VALUE IN FRAME f-cad)
         AND (IF  c-tipo = "P" THEN
                   int-fat-mensal-det.mes = fnMes(cb-mes:SCREEN-VALUE IN FRAME f-cad)
              ELSE
                  (int-fat-mensal-det.mes >= i-mes-tri-ini AND int-fat-mensal-det.mes <= i-mes-tri-fim)
              )
         AND int-fat-mensal-det.tp-movto  = 2 /*Faturamento*/
         AND int-fat-mensal-det.canal     = tt-central.canal-filial
         AND int-fat-mensal-det.unid-neg >= tt-param.unid-ini
         AND int-fat-mensal-det.unid-neg <= tt-param.unid-fim
         AND int-fat-mensal-det.tipo      = c-tipo
        ,FIRST emitente FIELDS (cgc nome-abrev nome-emit) NO-LOCK
            WHERE emitente.cod-emitente = int-fat-mensal-det.canal:
             
             CREATE tt-devol.
             BUFFER-COPY int-fat-mensal-det TO tt-devol.

             ASSIGN tt-devol.central    = tt-central.canal-central
                    tt-devol.filial     = int-fat-mensal-det.cod-emitente
                    tt-devol.cgc        = emitente.cgc
                    tt-devol.nome-abrev = emitente.nome-abrev
                    tt-devol.nome-emit  = emitente.nome-emit
                    tt-devol.c-search   = tt-devol.cgc                  + "|" +  
                                          tt-devol.nome-abrev           + "|" + 
                                          tt-devol.nome-emit            + "|" + 
                                          string(tt-devol.ano)          + "|" +
                                          string(tt-devol.mes)          + "|" +
                                          string(tt-devol.canal)        + "|" +
                                          tt-devol.unid-neg             + "|" +
                                          string(tt-devol.data)         + "|" +
                                          tt-devol.serie-docto          + "|" +
                                          tt-devol.nro-docto            + "|" +
                                          tt-devol.nat-operacao         + "|" +
                                          string(tt-devol.qt-devolvida) + "|" +
                                          string(tt-devol.vl-devolvido) + "|" +
                                          tt-devol.cod-estabel          + "|" +
                                          tt-devol.serie                + "|" +
                                          tt-devol.nr-nota-fis          + "|" +
                                          tt-devol.it-codigo            
                    tt-devol.r-rowid   = ROWID(tt-devol).

    END.

    {&open-query-br-devol}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-tt-nota w-cadsim 
PROCEDURE pi-carrega-tt-nota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR de-tot-nota LIKE it-nota-fisc.vl-merc-liq NO-UNDO.  
    DEF VAR c-tipo AS CHAR NO-UNDO.

    EMPTY TEMP-TABLE tt-nota.

    IF  INT(rs-apuracao:SCREEN-VALUE IN FRAME f-cad) = 1 THEN
        c-tipo = "C".
    ELSE 
        c-tipo = "P".

    FOR EACH tt-central
     , EACH int-fat-mensal-det NO-LOCK
       WHERE int-fat-mensal-det.ano = INT(cb-ano:SCREEN-VALUE IN FRAME f-cad)
         AND (IF c-tipo = "P" THEN
                   int-fat-mensal-det.mes = fnMes(cb-mes:SCREEN-VALUE IN FRAME f-cad)
              ELSE
                  (int-fat-mensal-det.mes >= i-mes-tri-ini AND int-fat-mensal-det.mes <= i-mes-tri-fim)
              )
         AND int-fat-mensal-det.tp-movto  = 1 /*Faturamento*/
         AND int-fat-mensal-det.canal     = tt-central.canal-filial
         AND int-fat-mensal-det.unid-neg >= tt-param.unid-ini
         AND int-fat-mensal-det.unid-neg <= tt-param.unid-fim
         AND int-fat-mensal-det.tipo      = c-tipo
        , FIRST emitente FIELDS ( cgc nome-abrev nome-emit) NO-LOCK
            WHERE emitente.cod-emitente = int-fat-mensal-det.canal
         BREAK BY int-fat-mensal-det.cod-estab
               BY int-fat-mensal-det.serie
               BY int-fat-mensal-det.nr-nota-fis:

         IF  FIRST-OF(int-fat-mensal-det.nr-nota-fis) THEN
             ASSIGN de-tot-nota = 0.

         ASSIGN de-tot-nota = de-tot-nota + int-fat-mensal-det.vl-faturado.

         FOR FIRST nota-fiscal FIELDS (cod-emitente) NO-LOCK
             WHERE nota-fiscal.cod-estabel = int-fat-mensal-det.cod-estabel
               AND nota-fiscal.serie       = int-fat-mensal-det.serie
               AND nota-fiscal.nr-nota-fis = int-fat-mensal-det.nr-nota-fis:
         END.

         IF  LAST-OF(int-fat-mensal-det.nr-nota-fis) THEN DO:
             CREATE tt-nota.
             ASSIGN tt-nota.tp-movto      = 1
                    tt-nota.ano           = int-fat-mensal-det.ano
                    tt-nota.mes           = int-fat-mensal-det.mes
                    tt-nota.central       = tt-central.canal-central
                    tt-nota.filial        = IF  AVAIL nota-fiscal THEN nota-fiscal.cod-emitente ELSE ?
                    tt-nota.unid-neg      = int-fat-mensal-det.unid-neg
                    tt-nota.cod-estabel   = int-fat-mensal-det.cod-estabel 
                    tt-nota.serie         = int-fat-mensal-det.serie       
                    tt-nota.nr-nota-fis   = int-fat-mensal-det.nr-nota-fis 
                    tt-nota.dt-emis-nota  = int-fat-mensal-det.data
                    tt-nota.vl-tot-nota   = de-tot-nota
                    tt-nota.r-rowid       = ROWID(tt-nota)
                    tt-nota.cgc           = emitente.cgc                           
                    tt-nota.nome-abrev    = emitente.nome-abrev                    
                    tt-nota.nome-emit     = emitente.nome-emit                     
                    tt-nota.c-search      = tt-nota.cgc                      + "|" +  
                                            tt-nota.nome-abrev               + "|" +  
                                            tt-nota.nome-emit                + "|" +  
                                            string(int-fat-mensal-det.ano)   + "|" +
                                            string(int-fat-mensal-det.mes)   + "|" +
                                            string(int-fat-mensal-det.canal) + "|" +
                                            int-fat-mensal-det.unid-neg      + "|" +
                                            int-fat-mensal-det.cod-estabel   + "|" +
                                            int-fat-mensal-det.serie         + "|" +
                                            int-fat-mensal-det.nr-nota-fis   + "|" +
                                            string(int-fat-mensal-det.data)  + "|" + 
                                            STRING(de-tot-nota).
         END.

    END.

    {&open-query-br-nota}

    {&open-query-br-fat}



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-excel-dev w-cadsim 
PROCEDURE pi-gera-excel-dev :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
      DEF VAR c-arquivo AS CHAR NO-UNDO.
      DEF VAR c-tipo AS CHAR NO-UNDO.
      
      IF  INT(rs-apuracao:SCREEN-VALUE IN FRAME f-cad) = 1 THEN
          c-tipo = "C".
      ELSE 
          c-tipo = "P".

      ASSIGN c-arquivo = STRING(SESSION:TEMP-DIRECTORY) + "Detalhes_Devol_Canais_" + STRING(TODAY, "99-99-9999") + "_"+ STRING(TIME) + ".csv".
      
      OUTPUT STREAM s-1 TO value(c-arquivo).
                      
      PUT STREAM s-1 "Ano;Mes;Canal Central;Filial;Unidade;Data Devol;Cliente;Serie Rec;Nota Rec;Natureza;Sequencia;Qtde;Val Devol;Estab;Serie;NF-e;Seq Fat;Item" SKIP.
      
      FOR EACH tt-central
         , EACH int-fat-mensal-det NO-LOCK
         WHERE int-fat-mensal-det.ano = INT(cb-ano:SCREEN-VALUE IN FRAME f-cad)
           AND (IF  c-tipo = "P" THEN
                     int-fat-mensal-det.mes = fnMes(cb-mes:SCREEN-VALUE IN FRAME f-cad)
                ELSE
                    (int-fat-mensal-det.mes >= i-mes-tri-ini AND int-fat-mensal-det.mes <= i-mes-tri-fim)
                )
           AND int-fat-mensal-det.tp-movto  = 2 /*Faturamento*/
           AND int-fat-mensal-det.canal    >= tt-central.canal-filial
           AND int-fat-mensal-det.unid-neg >= tt-param.unid-ini
           AND int-fat-mensal-det.unid-neg <= tt-param.unid-fim
           AND int-fat-mensal-det.tipo      = c-tipo
           BREAK BY int-fat-mensal-det.data:

            EXPORT STREAM s-1 DELIMITER ";" int-fat-mensal-det.ano
                                            int-fat-mensal-det.mes
                                            tt-central.canal-central
                                            int-fat-mensal-det.cod-emitente
                                            int-fat-mensal-det.unid-neg
                                            int-fat-mensal-det.data
                                            int-fat-mensal-det.cod-emitente 
                                            int-fat-mensal-det.serie-docto
                                            int-fat-mensal-det.nro-docto
                                            int-fat-mensal-det.nat-operacao
                                            int-fat-mensal-det.sequencia
                                            int-fat-mensal-det.vl-devolvido
                                            int-fat-mensal-det.qt-devolvida
                                            int-fat-mensal-det.cod-estabel
                                            int-fat-mensal-det.serie
                                            int-fat-mensal-det.nr-nota-fis
                                            int-fat-mensal-det.nr-seq-fat
                                            int-fat-mensal-det.it-codigo.

      END.

      OUTPUT STREAM s-1 CLOSE.

      DOS SILENT START excel VALUE(c-arquivo).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-excel-fat w-cadsim 
PROCEDURE pi-gera-excel-fat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
      DEF VAR c-arquivo AS CHAR NO-UNDO.
      DEF VAR c-tipo AS CHAR NO-UNDO.

      IF  INT(rs-apuracao:SCREEN-VALUE IN FRAME f-cad) = 1 THEN
          c-tipo = "C".
      ELSE 
          c-tipo = "P".

      ASSIGN c-arquivo = STRING(SESSION:TEMP-DIRECTORY) + "Detalhes_Fat_Canais_" + STRING(TODAY, "99-99-9999") + "_"+ STRING(TIME) + ".csv".
      
      OUTPUT STREAM s-1 TO value(c-arquivo).
                      
      PUT STREAM s-1 "Ano;Mes;Canal Central;Filial;Unidade;Estabel;Serie;Nota;Data Emissao;Sequencia;Item;Valor Fat;Qtde" SKIP.
      
      FOR FIRST tt-central
         , EACH int-fat-mensal-det NO-LOCK
         WHERE int-fat-mensal-det.ano = INT(cb-ano:SCREEN-VALUE IN FRAME f-cad)
           AND (IF  c-tipo = "P" THEN
                     int-fat-mensal-det.mes = fnMes(cb-mes:SCREEN-VALUE IN FRAME f-cad)
                ELSE
                    (int-fat-mensal-det.mes >= i-mes-tri-ini AND int-fat-mensal-det.mes <= i-mes-tri-fim)
                )
           AND int-fat-mensal-det.tp-movto  = 1 /*Faturamento*/
           AND int-fat-mensal-det.canal     = tt-central.canal-filial
           AND int-fat-mensal-det.unid-neg >= tt-param.unid-ini
           AND int-fat-mensal-det.unid-neg <= tt-param.unid-fim
           AND int-fat-mensal-det.tipo      = c-tipo
           BREAK BY int-fat-mensal-det.data
                 BY int-fat-mensal-det.cod-estab:

            FOR FIRST nota-fiscal FIELDS (cod-emitente) NO-LOCK
                WHERE nota-fiscal.cod-estabel = int-fat-mensal-det.cod-estabel
                  AND nota-fiscal.serie       = int-fat-mensal-det.serie
                  AND nota-fiscal.nr-nota-fis = int-fat-mensal-det.nr-nota-fis:
            END.
    
            EXPORT STREAM s-1 DELIMITER ";" int-fat-mensal-det.ano
                                            int-fat-mensal-det.mes
                                            tt-central.canal-central
                                            (IF AVAIL nota-fiscal THEN nota-fiscal.cod-emitente ELSE ?)
                                            int-fat-mensal-det.unid-neg
                                            int-fat-mensal-det.cod-estabel
                                            int-fat-mensal-det.serie
                                            int-fat-mensal-det.nr-nota-fis
                                            int-fat-mensal-det.data
                                            int-fat-mensal-det.nr-seq-fat
                                            int-fat-mensal-det.it-codigo
                                            int-fat-mensal-det.vl-faturado
                                            int-fat-mensal-det.qt-faturada.

      END.

      OUTPUT STREAM s-1 CLOSE.

      DOS SILENT START excel VALUE(c-arquivo).
      

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
  {src/adm/template/snd-list.i "tt-nota"}
  {src/adm/template/snd-list.i "tt-nota-det"}
  {src/adm/template/snd-list.i "tt-devol"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnbeneficio w-cadsim 
FUNCTION fnbeneficio RETURNS CHARACTER
  (INPUT p-tipo AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  CASE p-tipo:
      WHEN 21 THEN RETURN "V M C".
      WHEN 37 THEN RETURN "Rebate".
      WHEN 22 THEN RETURN "Stock Rotation".
      WHEN 66 THEN RETURN "Rebate P¢s-Venda".
  END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnMes w-cadsim 
FUNCTION fnMes RETURNS INTEGER
  ( INPUT p-mes AS CHAR /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  CASE p-mes:
      WHEN "janeiro"   THEN RETURN 01.
      WHEN "fevereiro" THEN RETURN 02.
      WHEN "maráo"     THEN RETURN 03.
      WHEN "abril"     THEN RETURN 04.
      WHEN "maio"      THEN RETURN 05.
      WHEN "junho"     THEN RETURN 06.
      WHEN "julho"     THEN RETURN 07.
      WHEN "agosto"    THEN RETURN 08.
      WHEN "setembro"  THEN RETURN 09.
      WHEN "outubro"   THEN RETURN 10.
      WHEN "novembro"  THEN RETURN 11.
      WHEN "dezembro"  THEN RETURN 12.
  END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnMesExt w-cadsim 
FUNCTION fnMesExt RETURNS CHARACTER
  (INPUT p-mes AS INT /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  CASE p-mes:
      WHEN 01 then return "Janeiro"   .
      WHEN 02 then return "Fevereiro" .
      WHEN 03 then return "Maráo"     .
      WHEN 04 then return "Abril"     .
      WHEN 05 then return "Maio"      .
      WHEN 06 then return "Junho"     .
      WHEN 07 then return "Julho"     .
      WHEN 08 then return "Agosto"    .
      WHEN 09 then return "Setembro"  .
      WHEN 10 then return "Outubro"   .
      WHEN 11 then return "Novembro"  .
      WHEN 12 then return "Dezembro"  .
  END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnMovto w-cadsim 
FUNCTION fnMovto RETURNS CHARACTER
  ( p-movto AS INTEGER /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  CASE p-movto:
      WHEN 1 THEN RETURN "PROV".
      WHEN 2 THEN RETURN "DESP".
  END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnStatus w-cadsim 
FUNCTION fnStatus RETURNS CHARACTER
  ( p-status AS INTEGER /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  CASE p-status:
      WHEN 2 THEN RETURN "Bloqueado".
      WHEN 1 THEN RETURN "Ativo".
      WHEN 4 THEN RETURN "Finalizado".
      WHEN 3 THEN RETURN "Suspenso".
  END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnTransacao w-cadsim 
FUNCTION fnTransacao RETURNS CHARACTER
  (INPUT p-tipo AS INT /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  CASE p-tipo:
      WHEN 1 THEN RETURN "Sa°da Transferància".
      WHEN 2 THEN RETURN "Entrada Transferància".
      WHEN 3 THEN RETURN "Ajuste".
      WHEN 4 THEN RETURN "Solicitaá∆o".
  END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnTrimestre w-cadsim 
FUNCTION fnTrimestre RETURNS CHARACTER
  ( INPUT p-mes AS INT /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  CASE p-mes:
      WHEN 1  OR WHEN 2  OR WHEN  3 THEN RETURN "Primeiro".
      WHEN 4  OR WHEN 5  OR WHEN  6 THEN RETURN "Segundo".
      WHEN 7  OR WHEN 8  OR WHEN  9 THEN RETURN "Terceiro".
      WHEN 10 OR WHEN 11 OR WHEN 12 THEN RETURN "Quarto".
  END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

