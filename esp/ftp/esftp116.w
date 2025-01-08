&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          emscad             PROGRESS
          emsmov             PROGRESS
*/
&Scoped-define WINDOW-NAME w-cadsim


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-razao-consolidado NO-UNDO LIKE acionista
       field id-master    as char
       field i-unid-neg   as int
       field id-co        as char
       field id-classif   as int
       field id-cc        as char
       field id-prj       as char
       field nr-ano       as int
       field nr-mes       as int
       field vl-realizado as dec
       field tx-moeda    as char
       field tx-co       as char
       field tx-cc       as char
       field tx-prj      as char
       field i-seq       as int
       index id-seq as primary unique i-seq.
DEFINE TEMP-TABLE tt-razao-detalhado NO-UNDO LIKE acionista
       field id-master    as char
       field i-unid-neg   as int
       field id-co        as char
       field id-classif   as int
       field id-cc        as char
       field id-prj       as char
       field nr-ano       as int
       field nr-mes       as int
       field vl-realizado as dec
       field id-lote      as int
       field id-lancto    as int
       field vl-lancto    as dec
       field dt-lancto    as date format "99/99/9999"
       field tx-moeda    as char
       field tx-co       as char
       field tx-cc       as char
       field tx-prj      as char
       field tx-lancto   as char
       field i-seq       as int
       index id-seq as primary unique i-seq.
DEFINE TEMP-TABLE tt-realizado NO-UNDO LIKE acionista
       FIELD id-master   AS CHAR
       FIELD i-ano       AS INT
       FIELD i-mes       AS INT
       FIELD c-empresa   AS CHAR
       FIELD c-estabe    AS CHAR
       FIELD c-mercado   AS CHAR
       FIELD c-origem    AS CHAR
       FIELD c-vertical  AS CHAR
       FIELD c-unid-neg  AS CHAR
       FIELD c-segmento  AS CHAR
       FIELD c-fm-coml   AS CHAR
       FIELD c-ncm       AS CHAR
       FIELD c-nivel-10  AS CHAR
       FIELD c-it-codigo AS CHAR
       FIELD c-attr      AS CHAR
       FIELD de-movto    AS DEC
       field tx-item     as char
       field c-moeda     as char
       field c-un-med    as char
       field tx-familia  as char
       field tx-mercado  as char
       field tx-empresa  as char
       field i-seq       as int
       index id-seq as primary unique i-seq.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadsim 
{include/i-prgvrs.i esftp116 2.00.00.000}

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

DEFINE VARIABLE c-linha-imp AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-seq       AS INTEGER     NO-UNDO.

{include/i-freeac.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME br-razao-consolidado

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-razao-consolidado tt-razao-detalhado ~
tt-realizado

/* Definitions for BROWSE br-razao-consolidado                          */
&Scoped-define FIELDS-IN-QUERY-br-razao-consolidado ~
tt-razao-consolidado.i-seq  @ tt-razao-consolidado.i-seq ~
tt-razao-consolidado.id-master  @ tt-razao-consolidado.id-master ~
tt-razao-consolidado.tx-moeda  @ tt-razao-consolidado.tx-moeda ~
tt-razao-consolidado.i-unid-neg  @ tt-razao-consolidado.i-unid-neg ~
tt-razao-consolidado.id-co @ tt-razao-consolidado.id-co ~
tt-razao-consolidado.tx-co  @ tt-razao-consolidado.tx-co ~
tt-razao-consolidado.id-classif  @ tt-razao-consolidado.id-classif ~
tt-razao-consolidado.id-cc  @ tt-razao-consolidado.id-cc ~
tt-razao-consolidado.tx-cc @ tt-razao-consolidado.tx-cc ~
tt-razao-consolidado.id-prj  @ tt-razao-consolidado.id-prj ~
tt-razao-consolidado.tx-prj @ tt-razao-consolidado.tx-prj ~
tt-razao-consolidado.nr-ano @ tt-razao-consolidado.nr-ano ~
tt-razao-consolidado.nr-mes @ tt-razao-consolidado.nr-mes ~
tt-razao-consolidado.vl-realizado  @ tt-razao-consolidado.vl-realizado 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-razao-consolidado 
&Scoped-define QUERY-STRING-br-razao-consolidado FOR EACH tt-razao-consolidado NO-LOCK
&Scoped-define OPEN-QUERY-br-razao-consolidado OPEN QUERY br-razao-consolidado FOR EACH tt-razao-consolidado NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br-razao-consolidado tt-razao-consolidado
&Scoped-define FIRST-TABLE-IN-QUERY-br-razao-consolidado tt-razao-consolidado


/* Definitions for BROWSE br-razao-detalhado                            */
&Scoped-define FIELDS-IN-QUERY-br-razao-detalhado ~
tt-razao-detalhado.i-seq   @ tt-razao-detalhado.i-seq ~
tt-razao-detalhado.id-master @ tt-razao-detalhado.id-master ~
tt-razao-detalhado.tx-moeda  @ tt-razao-detalhado.tx-moeda ~
tt-razao-detalhado.i-unid-neg   @ tt-razao-detalhado.i-unid-neg ~
tt-razao-detalhado.id-co  @ tt-razao-detalhado.id-co ~
tt-razao-detalhado.tx-co  @ tt-razao-detalhado.tx-co ~
tt-razao-detalhado.id-classif  @ tt-razao-detalhado.id-classif ~
tt-razao-detalhado.id-cc  @ tt-razao-detalhado.id-cc ~
tt-razao-detalhado.tx-cc @ tt-razao-detalhado.tx-cc ~
tt-razao-detalhado.id-prj  @ tt-razao-detalhado.id-prj ~
tt-razao-detalhado.tx-prj @ tt-razao-detalhado.tx-prj ~
tt-razao-detalhado.nr-ano @ tt-razao-detalhado.nr-ano ~
tt-razao-detalhado.nr-mes @ tt-razao-detalhado.nr-mes ~
tt-razao-detalhado.vl-realizado  @ tt-razao-detalhado.vl-realizado ~
tt-razao-detalhado.id-lote  @ tt-razao-detalhado.id-lote ~
tt-razao-detalhado.id-lancto  @ tt-razao-detalhado.id-lancto ~
tt-razao-detalhado.tx-lancto  @ tt-razao-detalhado.tx-lancto ~
tt-razao-detalhado.vl-lancto  @ tt-razao-detalhado.vl-lancto ~
tt-razao-detalhado.dt-lancto  @ tt-razao-detalhado.dt-lancto 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-razao-detalhado 
&Scoped-define QUERY-STRING-br-razao-detalhado FOR EACH tt-razao-detalhado NO-LOCK
&Scoped-define OPEN-QUERY-br-razao-detalhado OPEN QUERY br-razao-detalhado FOR EACH tt-razao-detalhado NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br-razao-detalhado tt-razao-detalhado
&Scoped-define FIRST-TABLE-IN-QUERY-br-razao-detalhado tt-razao-detalhado


/* Definitions for BROWSE br-realizado                                  */
&Scoped-define FIELDS-IN-QUERY-br-realizado ~
tt-realizado.i-seq  @ tt-realizado.i-seq ~
tt-realizado.id-master  @ tt-realizado.id-master ~
tt-realizado.i-ano       @ tt-realizado.i-ano ~
tt-realizado.i-mes       @ tt-realizado.i-mes ~
tt-realizado.c-empresa   @ tt-realizado.c-empresa ~
tt-realizado.tx-empresa  @ tt-realizado.tx-empresa ~
tt-realizado.c-estabe    @ tt-realizado.c-estabe ~
tt-realizado.c-mercado   @ tt-realizado.c-mercado ~
tt-realizado.tx-mercado  @ tt-realizado.tx-mercado ~
tt-realizado.c-origem    @ tt-realizado.c-origem ~
tt-realizado.c-vertical  @ tt-realizado.c-vertical ~
tt-realizado.c-unid-neg  @ tt-realizado.c-unid-neg ~
tt-realizado.c-segmento  @ tt-realizado.c-segmento ~
tt-realizado.c-fm-coml   @ tt-realizado.c-fm-coml ~
tt-realizado.tx-familia @ tt-realizado.tx-familia ~
tt-realizado.c-ncm       @ tt-realizado.c-ncm ~
tt-realizado.c-it-codigo @ tt-realizado.c-it-codigo ~
tt-realizado.tx-item @ tt-realizado.tx-item ~
tt-realizado.c-attr @ tt-realizado.c-attr ~
tt-realizado.de-movto    @ tt-realizado.de-movto ~
tt-realizado.c-moeda    @ tt-realizado.c-moeda ~
tt-realizado.c-un-med @ tt-realizado.c-un-med 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-realizado 
&Scoped-define QUERY-STRING-br-realizado FOR EACH tt-realizado NO-LOCK
&Scoped-define OPEN-QUERY-br-realizado OPEN QUERY br-realizado FOR EACH tt-realizado NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br-realizado tt-realizado
&Scoped-define FIRST-TABLE-IN-QUERY-br-realizado tt-realizado


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-br-razao-consolidado}~
    ~{&OPEN-QUERY-br-razao-detalhado}~
    ~{&OPEN-QUERY-br-realizado}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br-realizado c-arq-origem cb-tipo-arquivo ~
bt-ok c-arq-destino bt-arq-origem bt-arq-destino bt-imp bt-exp ~
br-razao-consolidado br-razao-detalhado RECT-159 
&Scoped-Define DISPLAYED-OBJECTS c-arq-origem cb-tipo-arquivo c-arq-destino 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-cadsim AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-arq-destino 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Arquivo destino da informaá∆o".

DEFINE BUTTON bt-arq-origem 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Arquivo origem da informaá∆o".

DEFINE BUTTON bt-exp 
     IMAGE-UP FILE "image\im-plout":U
     IMAGE-INSENSITIVE FILE "image\im-plout":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Exportar arquivo destino da informaá∆o".

DEFINE BUTTON bt-imp 
     IMAGE-UP FILE "image\im-plin":U
     IMAGE-INSENSITIVE FILE "image\ii-plin":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Importar arquivo origem da informaá∆o".

DEFINE BUTTON bt-ok AUTO-GO 
     IMAGE-UP FILE "image/im-exi.bmp":U
     LABEL "&Fechar" 
     SIZE 4 BY 1.13 TOOLTIP "Sair do programa"
     BGCOLOR 8 .

DEFINE VARIABLE cb-tipo-arquivo AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 1 
     LABEL "Tipo Arquivo" 
     VIEW-AS COMBO-BOX INNER-LINES 7
     LIST-ITEM-PAIRS "Volume",1,
                     "Receita",2,
                     "Deduá‰es",3,
                     "Despesas",4,
                     "Hierarquia",5,
                     "Raz∆o Detalhado",6,
                     "Raz∆o Consolidado",7
     DROP-DOWN-LIST
     SIZE 21 BY 1 NO-UNDO.

DEFINE VARIABLE c-arq-destino AS CHARACTER FORMAT "X(60)":U 
     LABEL "Destino" 
     VIEW-AS FILL-IN 
     SIZE 53 BY .88 NO-UNDO.

DEFINE VARIABLE c-arq-origem AS CHARACTER FORMAT "X(60)":U 
     LABEL "Origem" 
     VIEW-AS FILL-IN 
     SIZE 53 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-159
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 109 BY 2.75.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-razao-consolidado FOR 
      tt-razao-consolidado SCROLLING.

DEFINE QUERY br-razao-detalhado FOR 
      tt-razao-detalhado SCROLLING.

DEFINE QUERY br-realizado FOR 
      tt-realizado SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-razao-consolidado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-razao-consolidado w-cadsim _STRUCTURED
  QUERY br-razao-consolidado NO-LOCK DISPLAY
      tt-razao-consolidado.i-seq  @ tt-razao-consolidado.i-seq COLUMN-LABEL "Linha" FORMAT ">>>>>>9":U
            WIDTH 5.43
      tt-razao-consolidado.id-master  @ tt-razao-consolidado.id-master COLUMN-LABEL "Master" FORMAT "x(2)":U
            WIDTH 5.43
      tt-razao-consolidado.tx-moeda  @ tt-razao-consolidado.tx-moeda COLUMN-LABEL "Moeda" FORMAT "x(4)":U
            WIDTH 5.43
      tt-razao-consolidado.i-unid-neg  @ tt-razao-consolidado.i-unid-neg COLUMN-LABEL "Un" FORMAT "9999":U
      tt-razao-consolidado.id-co @ tt-razao-consolidado.id-co COLUMN-LABEL "Conta" FORMAT "x(9)":U
            WIDTH 9.29
      tt-razao-consolidado.tx-co  @ tt-razao-consolidado.tx-co COLUMN-LABEL "Desc Conta" FORMAT "x(100)":U
            WIDTH 20
      tt-razao-consolidado.id-classif  @ tt-razao-consolidado.id-classif COLUMN-LABEL "Class" FORMAT ">9":U
            WIDTH 4
      tt-razao-consolidado.id-cc  @ tt-razao-consolidado.id-cc COLUMN-LABEL "CCusto" FORMAT "x(9)":U
            WIDTH 9.29
      tt-razao-consolidado.tx-cc @ tt-razao-consolidado.tx-cc COLUMN-LABEL "Desc CCusto" FORMAT "x(100)":U
            WIDTH 20
      tt-razao-consolidado.id-prj  @ tt-razao-consolidado.id-prj COLUMN-LABEL "Prj" FORMAT "x(20)":U
            WIDTH 6
      tt-razao-consolidado.tx-prj @ tt-razao-consolidado.tx-prj COLUMN-LABEL "Desc Prj" FORMAT "x(40)":U
            WIDTH 9.14
      tt-razao-consolidado.nr-ano @ tt-razao-consolidado.nr-ano COLUMN-LABEL "Ano" FORMAT "9999":U
            WIDTH 4
      tt-razao-consolidado.nr-mes @ tt-razao-consolidado.nr-mes COLUMN-LABEL "Màs" FORMAT "99":U
            WIDTH 3
      tt-razao-consolidado.vl-realizado  @ tt-razao-consolidado.vl-realizado COLUMN-LABEL "Valor" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 8
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 108 BY 17.25
         FONT 1 ROW-HEIGHT-CHARS .54.

DEFINE BROWSE br-razao-detalhado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-razao-detalhado w-cadsim _STRUCTURED
  QUERY br-razao-detalhado NO-LOCK DISPLAY
      tt-razao-detalhado.i-seq   @ tt-razao-detalhado.i-seq COLUMN-LABEL "Linha" FORMAT ">>>>>>9":U
            WIDTH 5.43
      tt-razao-detalhado.id-master @ tt-razao-detalhado.id-master COLUMN-LABEL "Master" FORMAT "x(2)":U
            WIDTH 5.43
      tt-razao-detalhado.tx-moeda  @ tt-razao-detalhado.tx-moeda COLUMN-LABEL "Moeda" FORMAT "x(4)":U
            WIDTH 5.43
      tt-razao-detalhado.i-unid-neg   @ tt-razao-detalhado.i-unid-neg COLUMN-LABEL "Un" FORMAT "9999":U
      tt-razao-detalhado.id-co  @ tt-razao-detalhado.id-co COLUMN-LABEL "Conta" FORMAT "x(9)":U
            WIDTH 9.29
      tt-razao-detalhado.tx-co  @ tt-razao-detalhado.tx-co COLUMN-LABEL "Desc Conta" FORMAT "x(100)":U
            WIDTH 20
      tt-razao-detalhado.id-classif  @ tt-razao-detalhado.id-classif COLUMN-LABEL "Class" FORMAT ">9":U
            WIDTH 4
      tt-razao-detalhado.id-cc  @ tt-razao-detalhado.id-cc COLUMN-LABEL "CCusto" FORMAT "x(9)":U
            WIDTH 9.29
      tt-razao-detalhado.tx-cc @ tt-razao-detalhado.tx-cc COLUMN-LABEL "Desc CCusto" FORMAT "x(100)":U
            WIDTH 20
      tt-razao-detalhado.id-prj  @ tt-razao-detalhado.id-prj COLUMN-LABEL "Prj" FORMAT "x(20)":U
            WIDTH 6
      tt-razao-detalhado.tx-prj @ tt-razao-detalhado.tx-prj COLUMN-LABEL "Desc Prj" FORMAT "x(40)":U
            WIDTH 9.14
      tt-razao-detalhado.nr-ano @ tt-razao-detalhado.nr-ano COLUMN-LABEL "Ano" FORMAT "9999":U
            WIDTH 4
      tt-razao-detalhado.nr-mes @ tt-razao-detalhado.nr-mes COLUMN-LABEL "Màs" FORMAT "99":U
            WIDTH 3
      tt-razao-detalhado.vl-realizado  @ tt-razao-detalhado.vl-realizado COLUMN-LABEL "Valor" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 8
      tt-razao-detalhado.id-lote  @ tt-razao-detalhado.id-lote COLUMN-LABEL "Lote" FORMAT ">9":U
      tt-razao-detalhado.id-lancto  @ tt-razao-detalhado.id-lancto COLUMN-LABEL "Lancto" FORMAT ">>>>>>>9":U
            WIDTH 6
      tt-razao-detalhado.tx-lancto  @ tt-razao-detalhado.tx-lancto COLUMN-LABEL "Desc Lancto" FORMAT "x(40)":U
      tt-razao-detalhado.vl-lancto  @ tt-razao-detalhado.vl-lancto COLUMN-LABEL "Vl Lancto" FORMAT "->>>,>>>,>>9.99":U
      tt-razao-detalhado.dt-lancto  @ tt-razao-detalhado.dt-lancto COLUMN-LABEL "Dt Lancto" FORMAT "99/99/9999":U
            WIDTH 8
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 108 BY 17.25
         FONT 1 ROW-HEIGHT-CHARS .54.

DEFINE BROWSE br-realizado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-realizado w-cadsim _STRUCTURED
  QUERY br-realizado NO-LOCK DISPLAY
      tt-realizado.i-seq  @ tt-realizado.i-seq COLUMN-LABEL "Linha" FORMAT ">>>>>>9":U
            WIDTH 5.43
      tt-realizado.id-master  @ tt-realizado.id-master COLUMN-LABEL "Master" FORMAT "x(2)":U
            WIDTH 5.43
      tt-realizado.i-ano       @ tt-realizado.i-ano COLUMN-LABEL "Ano" FORMAT "9999":U
      tt-realizado.i-mes       @ tt-realizado.i-mes COLUMN-LABEL "Màs" FORMAT "99":U
      tt-realizado.c-empresa   @ tt-realizado.c-empresa COLUMN-LABEL "Emp" FORMAT "x(2)":U
      tt-realizado.tx-empresa  @ tt-realizado.tx-empresa COLUMN-LABEL "Empresa" FORMAT "x(100)":U
            WIDTH 9
      tt-realizado.c-estabe    @ tt-realizado.c-estabe COLUMN-LABEL "Est" FORMAT "x(3)":U
      tt-realizado.c-mercado   @ tt-realizado.c-mercado COLUMN-LABEL "Merc" FORMAT "x(2)":U
      tt-realizado.tx-mercado  @ tt-realizado.tx-mercado COLUMN-LABEL "Mercado" FORMAT "x(100)":U
            WIDTH 9
      tt-realizado.c-origem    @ tt-realizado.c-origem COLUMN-LABEL "Origem" FORMAT "x(20)":U
            WIDTH 5.72
      tt-realizado.c-vertical  @ tt-realizado.c-vertical COLUMN-LABEL "Vertical" FORMAT "x(40)":U
            WIDTH 9.14
      tt-realizado.c-unid-neg  @ tt-realizado.c-unid-neg COLUMN-LABEL "Unid Neg" FORMAT "x(10)":U
      tt-realizado.c-segmento  @ tt-realizado.c-segmento COLUMN-LABEL "Segmento" FORMAT "x(40)":U
            WIDTH 14.29
      tt-realizado.c-fm-coml   @ tt-realizado.c-fm-coml COLUMN-LABEL "Fam Coml" FORMAT "x(12)":U
      tt-realizado.tx-familia @ tt-realizado.tx-familia COLUMN-LABEL "Fam°lia" FORMAT "x(100)":U
            WIDTH 17.57
      tt-realizado.c-ncm       @ tt-realizado.c-ncm COLUMN-LABEL "NCM" FORMAT "x(12)":U
      tt-realizado.c-it-codigo @ tt-realizado.c-it-codigo COLUMN-LABEL "Item" FORMAT "x(10)":U
      tt-realizado.tx-item @ tt-realizado.tx-item COLUMN-LABEL "Desc Item" FORMAT "x(100)":U
            WIDTH 30
      tt-realizado.c-attr @ tt-realizado.c-attr COLUMN-LABEL "Atributo" FORMAT "x(10)":U
      tt-realizado.de-movto    @ tt-realizado.de-movto COLUMN-LABEL "Qtd" FORMAT "->>>,>>>,>>9.99":U
      tt-realizado.c-moeda    @ tt-realizado.c-moeda COLUMN-LABEL "Moeda" FORMAT "x(03)":U
      tt-realizado.c-un-med @ tt-realizado.c-un-med COLUMN-LABEL "Un Med" FORMAT "x(4)":U
            WIDTH 5
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 108 BY 17.25
         FONT 1 ROW-HEIGHT-CHARS .54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     br-realizado AT ROW 4.25 COL 2 WIDGET-ID 100
     c-arq-origem AT ROW 1.58 COL 40 COLON-ALIGNED WIDGET-ID 314
     cb-tipo-arquivo AT ROW 1.5 COL 10 COLON-ALIGNED WIDGET-ID 312
     bt-ok AT ROW 1.5 COL 105 WIDGET-ID 242
     c-arq-destino AT ROW 2.63 COL 40 COLON-ALIGNED WIDGET-ID 316
     bt-arq-origem AT ROW 1.5 COL 95 WIDGET-ID 318
     bt-arq-destino AT ROW 2.5 COL 95 WIDGET-ID 320
     bt-imp AT ROW 1.5 COL 99 WIDGET-ID 322
     bt-exp AT ROW 2.5 COL 99 WIDGET-ID 324
     br-razao-consolidado AT ROW 4.25 COL 2 WIDGET-ID 200
     br-razao-detalhado AT ROW 4.25 COL 2 WIDGET-ID 300
     RECT-159 AT ROW 1.25 COL 1 WIDGET-ID 302
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 134 BY 24.5
         BGCOLOR 15 FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Temp-Tables and Buffers:
      TABLE: tt-razao-consolidado T "?" NO-UNDO ems5 acionista
      ADDITIONAL-FIELDS:
          field id-master    as char
          field i-unid-neg   as int
          field id-co        as char
          field id-classif   as int
          field id-cc        as char
          field id-prj       as char
          field nr-ano       as int
          field nr-mes       as int
          field vl-realizado as dec
          field tx-moeda    as char
          field tx-co       as char
          field tx-cc       as char
          field tx-prj      as char
          field i-seq       as int
          index id-seq as primary unique i-seq
      END-FIELDS.
      TABLE: tt-razao-detalhado T "?" NO-UNDO ems5 acionista
      ADDITIONAL-FIELDS:
          field id-master    as char
          field i-unid-neg   as int
          field id-co        as char
          field id-classif   as int
          field id-cc        as char
          field id-prj       as char
          field nr-ano       as int
          field nr-mes       as int
          field vl-realizado as dec
          field id-lote      as int
          field id-lancto    as int
          field vl-lancto    as dec
          field dt-lancto    as date format "99/99/9999"
          field tx-moeda    as char
          field tx-co       as char
          field tx-cc       as char
          field tx-prj      as char
          field tx-lancto   as char
          field i-seq       as int
          index id-seq as primary unique i-seq
      END-FIELDS.
      TABLE: tt-realizado T "?" NO-UNDO ems5 acionista
      ADDITIONAL-FIELDS:
          FIELD id-master   AS CHAR
          FIELD i-ano       AS INT
          FIELD i-mes       AS INT
          FIELD c-empresa   AS CHAR
          FIELD c-estabe    AS CHAR
          FIELD c-mercado   AS CHAR
          FIELD c-origem    AS CHAR
          FIELD c-vertical  AS CHAR
          FIELD c-unid-neg  AS CHAR
          FIELD c-segmento  AS CHAR
          FIELD c-fm-coml   AS CHAR
          FIELD c-ncm       AS CHAR
          FIELD c-nivel-10  AS CHAR
          FIELD c-it-codigo AS CHAR
          FIELD c-attr      AS CHAR
          FIELD de-movto    AS DEC
          field tx-item     as char
          field c-moeda     as char
          field c-un-med    as char
          field tx-familia  as char
          field tx-mercado  as char
          field tx-empresa  as char
          field i-seq       as int
          index id-seq as primary unique i-seq
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-cadsim ASSIGN
         HIDDEN             = YES
         TITLE              = "Variaá∆o Cambial Conta Corrente"
         HEIGHT             = 20.71
         WIDTH              = 109.57
         MAX-HEIGHT         = 28.67
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28.67
         VIRTUAL-WIDTH      = 195.14
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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB br-realizado 1 f-cad */
/* BROWSE-TAB br-razao-consolidado bt-exp f-cad */
/* BROWSE-TAB br-razao-detalhado br-razao-consolidado f-cad */
ASSIGN 
       br-razao-consolidado:COLUMN-RESIZABLE IN FRAME f-cad       = TRUE
       br-razao-consolidado:COLUMN-MOVABLE IN FRAME f-cad         = TRUE.

ASSIGN 
       br-razao-detalhado:COLUMN-RESIZABLE IN FRAME f-cad       = TRUE
       br-razao-detalhado:COLUMN-MOVABLE IN FRAME f-cad         = TRUE.

ASSIGN 
       br-realizado:COLUMN-RESIZABLE IN FRAME f-cad       = TRUE
       br-realizado:COLUMN-MOVABLE IN FRAME f-cad         = TRUE.

ASSIGN 
       tt-realizado.tx-empresa:VISIBLE IN BROWSE br-realizado = FALSE
       tt-realizado.tx-mercado:VISIBLE IN BROWSE br-realizado = FALSE
       tt-realizado.tx-familia:VISIBLE IN BROWSE br-realizado = FALSE
       tt-realizado.tx-item:VISIBLE IN BROWSE br-realizado = FALSE
       tt-realizado.c-attr:VISIBLE IN BROWSE br-realizado = FALSE
       tt-realizado.c-moeda:VISIBLE IN BROWSE br-realizado = FALSE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-razao-consolidado
/* Query rebuild information for BROWSE br-razao-consolidado
     _TblList          = "Temp-Tables.tt-razao-consolidado"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > "_<CALC>"
"tt-razao-consolidado.i-seq  @ tt-razao-consolidado.i-seq" "Linha" ">>>>>>9" ? ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"tt-razao-consolidado.id-master  @ tt-razao-consolidado.id-master" "Master" "x(2)" ? ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"tt-razao-consolidado.tx-moeda  @ tt-razao-consolidado.tx-moeda" "Moeda" "x(4)" ? ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"tt-razao-consolidado.i-unid-neg  @ tt-razao-consolidado.i-unid-neg" "Un" "9999" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"tt-razao-consolidado.id-co @ tt-razao-consolidado.id-co" "Conta" "x(9)" ? ? ? ? ? ? ? no ? no no "9.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"tt-razao-consolidado.tx-co  @ tt-razao-consolidado.tx-co" "Desc Conta" "x(100)" ? ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"tt-razao-consolidado.id-classif  @ tt-razao-consolidado.id-classif" "Class" ">9" ? ? ? ? ? ? ? no ? no no "4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"tt-razao-consolidado.id-cc  @ tt-razao-consolidado.id-cc" "CCusto" "x(9)" ? ? ? ? ? ? ? no ? no no "9.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"tt-razao-consolidado.tx-cc @ tt-razao-consolidado.tx-cc" "Desc CCusto" "x(100)" ? ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"tt-razao-consolidado.id-prj  @ tt-razao-consolidado.id-prj" "Prj" "x(20)" ? ? ? ? ? ? ? no ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"tt-razao-consolidado.tx-prj @ tt-razao-consolidado.tx-prj" "Desc Prj" "x(40)" ? ? ? ? ? ? ? no ? no no "9.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"tt-razao-consolidado.nr-ano @ tt-razao-consolidado.nr-ano" "Ano" "9999" ? ? ? ? ? ? ? no ? no no "4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"tt-razao-consolidado.nr-mes @ tt-razao-consolidado.nr-mes" "Màs" "99" ? ? ? ? ? ? ? no ? no no "3" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"tt-razao-consolidado.vl-realizado  @ tt-razao-consolidado.vl-realizado" "Valor" "->>>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-razao-consolidado */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-razao-detalhado
/* Query rebuild information for BROWSE br-razao-detalhado
     _TblList          = "Temp-Tables.tt-razao-detalhado"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > "_<CALC>"
"tt-razao-detalhado.i-seq   @ tt-razao-detalhado.i-seq" "Linha" ">>>>>>9" ? ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"tt-razao-detalhado.id-master @ tt-razao-detalhado.id-master" "Master" "x(2)" ? ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"tt-razao-detalhado.tx-moeda  @ tt-razao-detalhado.tx-moeda" "Moeda" "x(4)" ? ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"tt-razao-detalhado.i-unid-neg   @ tt-razao-detalhado.i-unid-neg" "Un" "9999" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"tt-razao-detalhado.id-co  @ tt-razao-detalhado.id-co" "Conta" "x(9)" ? ? ? ? ? ? ? no ? no no "9.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"tt-razao-detalhado.tx-co  @ tt-razao-detalhado.tx-co" "Desc Conta" "x(100)" ? ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"tt-razao-detalhado.id-classif  @ tt-razao-detalhado.id-classif" "Class" ">9" ? ? ? ? ? ? ? no ? no no "4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"tt-razao-detalhado.id-cc  @ tt-razao-detalhado.id-cc" "CCusto" "x(9)" ? ? ? ? ? ? ? no ? no no "9.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"tt-razao-detalhado.tx-cc @ tt-razao-detalhado.tx-cc" "Desc CCusto" "x(100)" ? ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"tt-razao-detalhado.id-prj  @ tt-razao-detalhado.id-prj" "Prj" "x(20)" ? ? ? ? ? ? ? no ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"tt-razao-detalhado.tx-prj @ tt-razao-detalhado.tx-prj" "Desc Prj" "x(40)" ? ? ? ? ? ? ? no ? no no "9.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"tt-razao-detalhado.nr-ano @ tt-razao-detalhado.nr-ano" "Ano" "9999" ? ? ? ? ? ? ? no ? no no "4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"tt-razao-detalhado.nr-mes @ tt-razao-detalhado.nr-mes" "Màs" "99" ? ? ? ? ? ? ? no ? no no "3" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"tt-razao-detalhado.vl-realizado  @ tt-razao-detalhado.vl-realizado" "Valor" "->>>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > "_<CALC>"
"tt-razao-detalhado.id-lote  @ tt-razao-detalhado.id-lote" "Lote" ">9" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > "_<CALC>"
"tt-razao-detalhado.id-lancto  @ tt-razao-detalhado.id-lancto" "Lancto" ">>>>>>>9" ? ? ? ? ? ? ? no ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > "_<CALC>"
"tt-razao-detalhado.tx-lancto  @ tt-razao-detalhado.tx-lancto" "Desc Lancto" "x(40)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > "_<CALC>"
"tt-razao-detalhado.vl-lancto  @ tt-razao-detalhado.vl-lancto" "Vl Lancto" "->>>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > "_<CALC>"
"tt-razao-detalhado.dt-lancto  @ tt-razao-detalhado.dt-lancto" "Dt Lancto" "99/99/9999" ? ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-razao-detalhado */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-realizado
/* Query rebuild information for BROWSE br-realizado
     _TblList          = "Temp-Tables.tt-realizado"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > "_<CALC>"
"tt-realizado.i-seq  @ tt-realizado.i-seq" "Linha" ">>>>>>9" ? ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"tt-realizado.id-master  @ tt-realizado.id-master" "Master" "x(2)" ? ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"tt-realizado.i-ano       @ tt-realizado.i-ano" "Ano" "9999" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"tt-realizado.i-mes       @ tt-realizado.i-mes" "Màs" "99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"tt-realizado.c-empresa   @ tt-realizado.c-empresa" "Emp" "x(2)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"tt-realizado.tx-empresa  @ tt-realizado.tx-empresa" "Empresa" "x(100)" ? ? ? ? ? ? ? no ? no no "9" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"tt-realizado.c-estabe    @ tt-realizado.c-estabe" "Est" "x(3)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"tt-realizado.c-mercado   @ tt-realizado.c-mercado" "Merc" "x(2)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"tt-realizado.tx-mercado  @ tt-realizado.tx-mercado" "Mercado" "x(100)" ? ? ? ? ? ? ? no ? no no "9" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"tt-realizado.c-origem    @ tt-realizado.c-origem" "Origem" "x(20)" ? ? ? ? ? ? ? no ? no no "5.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"tt-realizado.c-vertical  @ tt-realizado.c-vertical" "Vertical" "x(40)" ? ? ? ? ? ? ? no ? no no "9.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"tt-realizado.c-unid-neg  @ tt-realizado.c-unid-neg" "Unid Neg" "x(10)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"tt-realizado.c-segmento  @ tt-realizado.c-segmento" "Segmento" "x(40)" ? ? ? ? ? ? ? no ? no no "14.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"tt-realizado.c-fm-coml   @ tt-realizado.c-fm-coml" "Fam Coml" "x(12)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > "_<CALC>"
"tt-realizado.tx-familia @ tt-realizado.tx-familia" "Fam°lia" "x(100)" ? ? ? ? ? ? ? no ? no no "17.57" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > "_<CALC>"
"tt-realizado.c-ncm       @ tt-realizado.c-ncm" "NCM" "x(12)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > "_<CALC>"
"tt-realizado.c-it-codigo @ tt-realizado.c-it-codigo" "Item" "x(10)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > "_<CALC>"
"tt-realizado.tx-item @ tt-realizado.tx-item" "Desc Item" "x(100)" ? ? ? ? ? ? ? no ? no no "30" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > "_<CALC>"
"tt-realizado.c-attr @ tt-realizado.c-attr" "Atributo" "x(10)" ? ? ? ? ? ? ? no ? no no ? no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > "_<CALC>"
"tt-realizado.de-movto    @ tt-realizado.de-movto" "Qtd" "->>>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > "_<CALC>"
"tt-realizado.c-moeda    @ tt-realizado.c-moeda" "Moeda" "x(03)" ? ? ? ? ? ? ? no ? no no ? no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[22]   > "_<CALC>"
"tt-realizado.c-un-med @ tt-realizado.c-un-med" "Un Med" "x(4)" ? ? ? ? ? ? ? no ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-realizado */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON END-ERROR OF w-cadsim /* Variaá∆o Cambial Conta Corrente */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON WINDOW-CLOSE OF w-cadsim /* Variaá∆o Cambial Conta Corrente */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-arq-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arq-destino w-cadsim
ON CHOOSE OF bt-arq-destino IN FRAME f-cad
DO:
   def var c-arq-conv  as char no-undo.
    def var l-ok as logical no-undo.

    assign c-arq-destino = replace(input frame {&frame-name} c-arq-destino, "/", "~\").
    SYSTEM-DIALOG GET-FILE c-arq-conv
       FILTERS "*.txt" "*.txt"
       DEFAULT-EXTENSION "txt"
       MUST-EXIST
       USE-FILENAME
       UPDATE l-ok.
    if  l-ok = yes then
        assign c-arq-destino:screen-value in frame {&frame-name}  = replace(c-arq-conv, "~\", "/"). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-arq-origem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arq-origem w-cadsim
ON CHOOSE OF bt-arq-origem IN FRAME f-cad
DO:
    def var c-arq-conv  as char no-undo.
    def var l-ok as logical no-undo.

    assign c-arq-origem = replace(input frame {&frame-name} c-arq-origem, "/", "~\").
    SYSTEM-DIALOG GET-FILE c-arq-conv
       FILTERS "*.txt" "*.txt"
       DEFAULT-EXTENSION "txt"
       MUST-EXIST
       USE-FILENAME
       UPDATE l-ok.
    if  l-ok = yes then
        assign c-arq-origem:screen-value in frame {&frame-name}  = replace(c-arq-conv, "~\", "/"). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-exp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-exp w-cadsim
ON CHOOSE OF bt-exp IN FRAME f-cad
DO:
    IF SESSION:SET-WAIT-STATE("general") THEN.
 
    ASSIGN c-arq-origem    = INPUT FRAME {&FRAME-NAME} c-arq-origem
           c-arq-destino   = INPUT FRAME {&FRAME-NAME} c-arq-destino
           cb-tipo-arquivo = INPUT FRAME {&FRAME-NAME} cb-tipo-arquivo.

    IF  c-arq-destino = c-arq-origem
    THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Arquivo de destino n∆o pode ser igual ao arquivo origem.").
        RETURN NO-APPLY.
    END.

    IF  c-arq-destino = ""
    THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Arquivo de destino n∆o informado.").
        RETURN NO-APPLY.
    END.

    IF  cb-tipo-arquivo < 6
    THEN DO:
        FIND FIRST tt-realizado NO-LOCK NO-ERROR.
    
        IF  NOT AVAIL tt-realizado
        THEN DO:
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "N∆o foram encontradas informaá‰es para exportaá∆o.").
            RETURN NO-APPLY.
        END.
    END.
    ELSE DO:
        IF  cb-tipo-arquivo = 7
        THEN DO:
            FIND FIRST tt-razao-consolidado NO-LOCK NO-ERROR.
        
            IF  NOT AVAIL tt-razao-consolidado
            THEN DO:
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "N∆o foram encontradas informaá‰es para exportaá∆o.").
                RETURN NO-APPLY.
            END.
        END.
    END.


    RUN pi-exporta.

    IF SESSION:SET-WAIT-STATE("") THEN.

    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 15825,
                       INPUT "Exportaá∆o Finalizada.").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-imp w-cadsim
ON CHOOSE OF bt-imp IN FRAME f-cad
DO:
    IF SESSION:SET-WAIT-STATE("general") THEN.

    EMPTY TEMP-TABLE tt-realizado.
    EMPTY TEMP-TABLE tt-razao-detalhado.
    EMPTY TEMP-TABLE tt-razao-consolidado.

    OPEN QUERY br-razao-detalhado   FOR EACH tt-razao-detalhado.
    OPEN QUERY br-razao-consolidado FOR EACH tt-razao-consolidado.
    OPEN QUERY br-realizado         FOR EACH tt-realizado.

    ASSIGN cb-tipo-arquivo = INPUT FRAME {&FRAME-NAME} cb-tipo-arquivo
           c-arq-origem    = INPUT FRAME {&FRAME-NAME} c-arq-origem.

    IF  SEARCH(c-arq-origem) = ?
    THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Arquivo de origem n∆o encontrado.").
        RETURN NO-APPLY.
    END.

    RUN pi-importa.

    OPEN QUERY br-realizado         FOR EACH tt-realizado.
    OPEN QUERY br-razao-detalhado   FOR EACH tt-razao-detalhado.
    OPEN QUERY br-razao-consolidado FOR EACH tt-razao-consolidado.

    IF SESSION:SET-WAIT-STATE("") THEN.

    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 15825,
                       INPUT "Importaá∆o Finalizada.").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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


&Scoped-define SELF-NAME cb-tipo-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tipo-arquivo w-cadsim
ON VALUE-CHANGED OF cb-tipo-arquivo IN FRAME f-cad /* Tipo Arquivo */
DO:
    ASSIGN cb-tipo-arquivo = INPUT FRAME {&FRAME-NAME} cb-tipo-arquivo.

    IF  cb-tipo-arquivo < 6
    THEN DO:
        HIDE br-razao-detalhado   IN FRAME {&FRAME-NAME}.
        HIDE br-razao-consolidado IN FRAME {&FRAME-NAME}.
        VIEW br-realizado         IN FRAME {&FRAME-NAME}.

        ASSIGN tt-realizado.c-attr    :VISIBLE IN BROWSE br-realizado = NO
               tt-realizado.c-moeda   :VISIBLE IN BROWSE br-realizado = NO
               tt-realizado.c-un-med  :VISIBLE IN BROWSE br-realizado = NO
               tt-realizado.tx-empresa:VISIBLE IN BROWSE br-realizado = NO
               tt-realizado.tx-mercado:VISIBLE IN BROWSE br-realizado = NO
               tt-realizado.tx-familia:VISIBLE IN BROWSE br-realizado = NO
               tt-realizado.tx-item   :VISIBLE IN BROWSE br-realizado = NO
               tt-realizado.de-movto  :VISIBLE IN BROWSE br-realizado = YES.
    
        IF  cb-tipo-arquivo = 3 OR
            cb-tipo-arquivo = 4
        THEN
            ASSIGN tt-realizado.c-attr :VISIBLE IN BROWSE br-realizado = YES.
    
        IF  INPUT FRAME {&FRAME-NAME} cb-tipo-arquivo = 5
        THEN
            ASSIGN tt-realizado.de-movto  :VISIBLE IN BROWSE br-realizado = NO
                   tt-realizado.c-moeda   :VISIBLE IN BROWSE br-realizado = YES
                   tt-realizado.c-un-med  :VISIBLE IN BROWSE br-realizado = YES
                   tt-realizado.tx-empresa:VISIBLE IN BROWSE br-realizado = YES
                   tt-realizado.tx-mercado:VISIBLE IN BROWSE br-realizado = YES
                   tt-realizado.tx-familia:VISIBLE IN BROWSE br-realizado = YES
                   tt-realizado.tx-item   :VISIBLE IN BROWSE br-realizado = YES.
    
        br-realizado:REFRESH() NO-ERROR.
    END.
    ELSE DO:
        IF  cb-tipo-arquivo = 6 
        THEN DO:
            VIEW br-razao-detalhado   IN FRAME {&FRAME-NAME}.
            HIDE br-razao-consolidado IN FRAME {&FRAME-NAME}.
            HIDE br-realizado         IN FRAME {&FRAME-NAME}.
        END.

        IF  cb-tipo-arquivo = 7 
        THEN DO:
            HIDE br-razao-detalhado   IN FRAME {&FRAME-NAME}.
            VIEW br-razao-consolidado IN FRAME {&FRAME-NAME}.
            HIDE br-realizado         IN FRAME {&FRAME-NAME}.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-razao-consolidado
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
  DISPLAY c-arq-origem cb-tipo-arquivo c-arq-destino 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  ENABLE br-realizado c-arq-origem cb-tipo-arquivo bt-ok c-arq-destino 
         bt-arq-origem bt-arq-destino bt-imp bt-exp br-razao-consolidado 
         br-razao-detalhado RECT-159 
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

  {utp/ut9000.i "ESFTP116" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch  IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  RUN dispatch  IN this-procedure ('enable-fields':U).

  APPLY "value-changed" TO cb-tipo-arquivo IN FRAME {&FRAME-NAME}.
  
  {include/i-inifld.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exporta w-cadsim 
PROCEDURE pi-exporta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OUTPUT TO value(c-arq-destino) CONVERT TARGET "iso8859-1".

    IF  cb-tipo-arquivo < 5
    THEN DO:   
        FOR EACH tt-realizado:
            PUT UNFORMATTED tt-realizado.i-mes       ";"
                            tt-realizado.c-empresa   ";"
                            tt-realizado.c-estabe    ";"
                            tt-realizado.c-mercado   ";"
                            tt-realizado.c-origem    ";"
                            tt-realizado.c-vertical  ";"
                            tt-realizado.c-unid-neg  ";"
                            tt-realizado.c-segmento  ";"
                            tt-realizado.c-fm-coml   ";"
                            tt-realizado.c-ncm       ";"
                            tt-realizado.c-nivel-10  ";"
                            tt-realizado.c-it-codigo ";".

            IF  cb-tipo-arquivo < 3 
            THEN
                PUT UNFORMATTED tt-realizado.de-movto SKIP.
            ELSE
                PUT UNFORMATTED tt-realizado.c-attr ";"
                                tt-realizado.de-movto SKIP.
        END. /* FOR EACH tt-realizado: */
    END. /* IF  cb-tipo-arquivo < 5 */
    ELSE DO:
        IF  cb-tipo-arquivo = 5 
        THEN DO:
            FOR EACH tt-realizado:
                PUT UNFORMATTED tt-realizado.tx-empresa       ";"
                                tt-realizado.c-empresa        ";"
                                tt-realizado.c-estabe         ";"
                                tt-realizado.c-estabe         ";"
                                tt-realizado.tx-mercado       ";"
                                tt-realizado.c-mercado        ";"
                                tt-realizado.c-origem         ";"
                                tt-realizado.c-origem         ";"
                                tt-realizado.c-vertical       ";"
                                tt-realizado.c-vertical       ";"
                                tt-realizado.c-unid-neg       ";"
                                tt-realizado.c-unid-neg       ";"
                                tt-realizado.c-segmento       ";"
                                tt-realizado.c-segmento       ";"
                                tt-realizado.tx-familia       ";"
                                tt-realizado.c-fm-coml        ";"
                                tt-realizado.c-ncm            ";"
                                tt-realizado.c-ncm            ";"
                                tt-realizado.c-nivel-10       ";"
                                tt-realizado.c-nivel-10       ";"
                                tt-realizado.tx-item          ";"
                                tt-realizado.c-it-codigo      ";"
                                tt-realizado.c-moeda          ";"
                                tt-realizado.c-un-med         ";"
                                tt-realizado.c-un-med         ";"
                                "0"                           SKIP.
            END.
        END. /* IF  cb-tipo-arquivo = 5 */


        IF  cb-tipo-arquivo = 6
        THEN DO:
            FOR EACH tt-razao-detalhado:
                PUT UNFORMATTED tt-razao-detalhado.i-unid-neg   ";"
                                tt-razao-detalhado.id-cc        ";"
                                tt-razao-detalhado.id-co        ";"
                                tt-razao-detalhado.id-prj       ";"
                                tt-razao-detalhado.id-lote      ";"
                                tt-razao-detalhado.id-lancto    ";"
                                tt-razao-detalhado.tx-lancto    ";"
                                tt-razao-detalhado.vl-lancto    ";"
                                tt-razao-detalhado.dt-lancto    FORMAT "99/99/9999" SKIP.
            END.
        END.

        IF  cb-tipo-arquivo = 7
        THEN DO:
            FOR EACH tt-razao-consolidado:
                PUT UNFORMATTED tt-razao-consolidado.id-master    ";"
                                tt-razao-consolidado.tx-moeda     ";"
                                tt-razao-consolidado.i-unid-neg   ";"
                                tt-razao-consolidado.id-co        ";"
                                tt-razao-consolidado.tx-co        ";"
                                tt-razao-consolidado.id-classif   ";"
                                tt-razao-consolidado.id-cc        ";"
                                tt-razao-consolidado.tx-cc        ";"
                                tt-razao-consolidado.id-prj       ";"
                                tt-razao-consolidado.tx-prj       ";"
                                tt-razao-consolidado.nr-ano       ";"
                                tt-razao-consolidado.nr-mes       ";"
                                tt-razao-consolidado.vl-realizado SKIP.
            END.
        END.
    END.

    OUTPUT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-importa w-cadsim 
PROCEDURE pi-importa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN i-seq = 0.

    INPUT FROM VALUE(c-arq-origem) CONVERT SOURCE "iso8859-1".
    
    REPEAT:
        IMPORT UNFORMATTED c-linha-imp.
    
        IF  c-linha-imp BEGINS "cd"
        THEN 
            NEXT.

        IF  cb-tipo-arquivo < 6
        THEN DO:
            IF  NUM-ENTRIES(c-linha-imp,CHR(9)) >= 14
            THEN DO:
                CREATE tt-realizado.
                ASSIGN i-seq                    = i-seq + 1
                       tt-realizado.i-seq       = i-seq
                       tt-realizado.id-master   = ENTRY(1 ,c-linha-imp,CHR(9))
                       tt-realizado.c-empresa   = ENTRY(2 ,c-linha-imp,CHR(9))
                       tt-realizado.c-estabe    = ENTRY(3 ,c-linha-imp,CHR(9))
                       tt-realizado.c-mercado   = ENTRY(4 ,c-linha-imp,CHR(9))
                       tt-realizado.c-origem    = ENTRY(5 ,c-linha-imp,CHR(9))
                       tt-realizado.c-vertical  = ENTRY(6 ,c-linha-imp,CHR(9))
                       tt-realizado.c-unid-neg  = ENTRY(7 ,c-linha-imp,CHR(9))
                       tt-realizado.c-segmento  = ENTRY(8 ,c-linha-imp,CHR(9))
                       tt-realizado.c-fm-coml   = ENTRY(9 ,c-linha-imp,CHR(9))
                       tt-realizado.c-ncm       = ENTRY(10,c-linha-imp,CHR(9))
                       tt-realizado.c-it-codigo = ENTRY(11,c-linha-imp,CHR(9)).

                IF  cb-tipo-arquivo < 3 
                THEN
                    ASSIGN tt-realizado.i-ano    = INT(ENTRY(12,c-linha-imp,CHR(9)))
                           tt-realizado.i-mes    = INT(ENTRY(13,c-linha-imp,CHR(9)))
                           tt-realizado.de-movto = DEC(ENTRY(14,c-linha-imp,CHR(9))).
                ELSE DO:
                    IF  cb-tipo-arquivo < 5 
                    THEN
                        ASSIGN tt-realizado.c-attr   =     ENTRY(12,c-linha-imp,CHR(9))
                               tt-realizado.i-ano    = INT(ENTRY(13,c-linha-imp,CHR(9)))
                               tt-realizado.i-mes    = INT(ENTRY(14,c-linha-imp,CHR(9)))
                               tt-realizado.de-movto = DEC(ENTRY(15,c-linha-imp,CHR(9))).
                    ELSE DO:
                        IF  cb-tipo-arquivo = 5 
                        THEN
                            ASSIGN tt-realizado.i-ano      = INT(ENTRY(13,c-linha-imp,CHR(9)))
                                   tt-realizado.tx-item    =     ENTRY(14,c-linha-imp,CHR(9))
                                   tt-realizado.c-moeda    =     ENTRY(15,c-linha-imp,CHR(9))
                                   tt-realizado.c-un-med   =     ENTRY(16,c-linha-imp,CHR(9))
                                   tt-realizado.tx-familia =     ENTRY(17,c-linha-imp,CHR(9))
                                   tt-realizado.tx-mercado =     ENTRY(18,c-linha-imp,CHR(9))
                                   tt-realizado.tx-empresa =     ENTRY(19,c-linha-imp,CHR(9)).
                    END.
                END.
            END. /* IF  NUM-ENTRIES(c-linha-imp,CHR(9)) >= 14 */
        END. /* IF  cb-tipo-arquivo < 6 */

        IF  cb-tipo-arquivo = 6 /* Raz∆o Detalhado */
        THEN DO:
            IF  NUM-ENTRIES(c-linha-imp,CHR(9)) >= 18
            THEN DO:
                CREATE tt-razao-detalhado.
                ASSIGN i-seq                           = i-seq + 1
                       tt-razao-detalhado.i-seq        = i-seq
                       tt-razao-detalhado.id-master    =     ENTRY(1 ,c-linha-imp,CHR(9)) 
                       tt-razao-detalhado.i-unid-neg   = INT(ENTRY(2 ,c-linha-imp,CHR(9)))
                       tt-razao-detalhado.id-co        =     ENTRY(3 ,c-linha-imp,CHR(9)) 
                       tt-razao-detalhado.id-classif   = INT(ENTRY(4 ,c-linha-imp,CHR(9))) 
                       tt-razao-detalhado.id-cc        =     ENTRY(5 ,c-linha-imp,CHR(9)) 
                       tt-razao-detalhado.id-prj       =     ENTRY(6 ,c-linha-imp,CHR(9)) 
                       tt-razao-detalhado.id-lote      = INT(ENTRY(7 ,c-linha-imp,CHR(9)))
                       tt-razao-detalhado.id-lancto    = INT(ENTRY(8 ,c-linha-imp,CHR(9)))
                       tt-razao-detalhado.nr-ano       = INT(ENTRY(9 ,c-linha-imp,CHR(9))) 
                       tt-razao-detalhado.nr-mes       = INT(ENTRY(10,c-linha-imp,CHR(9))) 
                       tt-razao-detalhado.vl-lancto    = DEC(ENTRY(11,c-linha-imp,CHR(9)))
                       tt-razao-detalhado.vl-realizado = DEC(ENTRY(12,c-linha-imp,CHR(9)))
                       tt-razao-detalhado.dt-lancto    = DATE(ENTRY(13,c-linha-imp,CHR(9)))
                       tt-razao-detalhado.tx-moeda     =     ENTRY(14,c-linha-imp,CHR(9)) 
                       tt-razao-detalhado.tx-co        =     ENTRY(15,c-linha-imp,CHR(9))
                       tt-razao-detalhado.tx-cc        =     ENTRY(16,c-linha-imp,CHR(9))
                       tt-razao-detalhado.tx-prj       =     ENTRY(17,c-linha-imp,CHR(9))
                       tt-razao-detalhado.tx-lancto    =     ENTRY(18,c-linha-imp,CHR(9)). 
            END.
        END. /* IF  cb-tipo-arquivo = 6 */

        IF  cb-tipo-arquivo = 7 /* Raz∆o Consolidado */
        THEN DO:
            IF  NUM-ENTRIES(c-linha-imp,CHR(9)) >= 13
            THEN DO:
                CREATE tt-razao-consolidado.
                ASSIGN i-seq                             = i-seq + 1
                       tt-razao-consolidado.i-seq        = i-seq
                       tt-razao-consolidado.id-master    =     ENTRY(1 ,c-linha-imp,CHR(9)) 
                       tt-razao-consolidado.i-unid-neg   = INT(ENTRY(2 ,c-linha-imp,CHR(9)))
                       tt-razao-consolidado.id-co        =     ENTRY(3 ,c-linha-imp,CHR(9)) 
                       tt-razao-consolidado.id-classif   = INT(ENTRY(4 ,c-linha-imp,CHR(9))) 
                       tt-razao-consolidado.id-cc        =     ENTRY(5 ,c-linha-imp,CHR(9)) 
                       tt-razao-consolidado.id-prj       =     ENTRY(6 ,c-linha-imp,CHR(9)) 
                       tt-razao-consolidado.nr-ano       = INT(ENTRY(7 ,c-linha-imp,CHR(9))) 
                       tt-razao-consolidado.nr-mes       = INT(ENTRY(8 ,c-linha-imp,CHR(9))) 
                       tt-razao-consolidado.vl-realizado = DEC(ENTRY(9 ,c-linha-imp,CHR(9)))
                       tt-razao-consolidado.tx-moeda     =     ENTRY(10,c-linha-imp,CHR(9)) 
                       tt-razao-consolidado.tx-co        =     ENTRY(11,c-linha-imp,CHR(9))
                       tt-razao-consolidado.tx-cc        =     ENTRY(12,c-linha-imp,CHR(9))
                       tt-razao-consolidado.tx-prj       =     ENTRY(13,c-linha-imp,CHR(9)).
            END.
        END. /* IF  cb-tipo-arquivo = 7 */
    END. /* REPEAT: */
    
    INPUT CLOSE.
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
  {src/adm/template/snd-list.i "tt-realizado"}
  {src/adm/template/snd-list.i "tt-razao-detalhado"}
  {src/adm/template/snd-list.i "tt-razao-consolidado"}

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

