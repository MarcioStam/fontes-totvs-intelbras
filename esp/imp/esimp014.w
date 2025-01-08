&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-historico-embarque NO-UNDO LIKE historico-embarque
       field desc-itinerario      as char
       FIELD cod-pto-contr-base   LIKE cotacao-item.cod-pto-contr-base
       FIELD cod-cond-pag         LIKE pedido-compr.cod-cond-pag
       FIELD descricao-cond-pag   LIKE cond-pagto.descricao
       FIELD modal                AS CHAR
       FIELD dt-entrega-proforma  LIKE historico-embarque.dt-efetiva
       FIELD declaracao-import    LIKE embarque-imp.declaracao-import
       field de-valor-embarque    as dec
       field c-moeda              as char
       field dt-prev-pto-68       as date
       field dt-real-pto-68       as date
       field dt-prev-pto-34       as date
       field dt-real-pto-34       as date
       field dt-prev-pto-36       as date
       field dt-real-pto-36       as date
       field dt-prev-pto-44       as date
       field dt-real-pto-44       as date
       field c-ult-pto            as char
       field dt-ult-pto           as date
       field c-nota-fiscal        as char
       field c-serie              as char
       field cod-emitente         as int
       field nome-emit            as char
       field dt-emb-efetivo       as date
       field dt-eadi-efetivo      as date
       FIELD conteiner            AS CHAR
       FIELD qtd-conteiner        LIKE ext-embarque-imp.qtd-conteiner
       FIELD qtd2-conteiner       LIKE ext-embarque-imp.qtd2-conteiner
       FIELD cod-conhecto-master  LIKE embarque-imp.cod-conhecto-master
       FIELD cod-conhecto-house   LIKE embarque-imp.cod-conhecto-house
       FIELD MatriculaResponsavel AS CHAR
       FIELD transportador        AS CHAR
       FIELD cod-incoterm         LIKE embarque-imp.cod-incoterm
       FIELD via-transp           AS CHAR
       FIELD itiner               AS CHAR
       FIELD entrega-invoice      AS DATE
       FIELD dt-chegada           AS DATE
       FIELD vl-fob               AS DEC
       FIELD cis                  AS CHAR
       index id-embarque cod-estabel embarque
       index id-despacho cod-estabel dt-prev-pto-68.

{esp/es0018.i}

DEFINE BUFFER b2-historico-embarque FOR historico-embarque.
DEFINE BUFFER b-historico-embarque FOR historico-embarque.
DEFINE VARIABLE c-pagamento AS CHARACTER   NO-UNDO.
    


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESIMP014 2.06.00.000}


CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESIMP014
&GLOBAL-DEFINE Version        2.06.00.000

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define variable wh-imprime as handle no-undo.

DEFINE VARIABLE h-bocx220 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-acomp   AS HANDLE      NO-UNDO.
DEFINE VARIABLE i-linhas  AS INTEGER     NO-UNDO.
DEFINE VARIABLE r-tt-hist AS ROWID       NO-UNDO.

DEF NEW GLOBAL SHARED VAR h-facelift AS HANDLE NO-UNDO.

DEF TEMP-TABLE tt-embarque-registro-di
    FIELD cod-estab AS CHAR
    FIELD embarque LIKE embarque-imp.embarque

INDEX idx-unique IS PRIMARY UNIQUE cod-estab embarque.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-embarques

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-historico-embarque

/* Definitions for BROWSE br-embarques                                  */
&Scoped-define FIELDS-IN-QUERY-br-embarques ~
tt-historico-embarque.cod-estabel ~
tt-historico-embarque.cod-emitente @ tt-historico-embarque.cod-emitente ~
tt-historico-embarque.nome-emit @ tt-historico-embarque.nome-emit ~
tt-historico-embarque.embarque ~
tt-historico-embarque.de-valor-embarque @ tt-historico-embarque.de-valor-embarque ~
tt-historico-embarque.c-moeda @ tt-historico-embarque.c-moeda ~
tt-historico-embarque.cod-itiner ~
tt-historico-embarque.desc-itinerario @ tt-historico-embarque.desc-itinerario ~
tt-historico-embarque.dt-real-pto-68 @ tt-historico-embarque.dt-real-pto-68 ~
tt-historico-embarque.dt-emb-efetivo @ tt-historico-embarque.dt-emb-efetivo ~
tt-historico-embarque.dt-eadi-efetivo @ tt-historico-embarque.dt-eadi-efetivo ~
tt-historico-embarque.dt-prev-pto-34 @ tt-historico-embarque.dt-prev-pto-34 ~
tt-historico-embarque.dt-real-pto-34 @ tt-historico-embarque.dt-real-pto-34 ~
tt-historico-embarque.dt-prev-pto-36 @ tt-historico-embarque.dt-prev-pto-36 ~
tt-historico-embarque.dt-real-pto-36 @ tt-historico-embarque.dt-real-pto-36 ~
tt-historico-embarque.dt-real-pto-44 @ tt-historico-embarque.dt-real-pto-44 ~
tt-historico-embarque.c-ult-pto @ tt-historico-embarque.c-ult-pto ~
tt-historico-embarque.dt-ult-pto @ tt-historico-embarque.dt-ult-pto ~
tt-historico-embarque.c-nota-fiscal @ tt-historico-embarque.c-nota-fiscal ~
tt-historico-embarque.c-serie @ tt-historico-embarque.c-serie 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-embarques 
&Scoped-define QUERY-STRING-br-embarques FOR EACH tt-historico-embarque NO-LOCK
&Scoped-define OPEN-QUERY-br-embarques OPEN QUERY br-embarques FOR EACH tt-historico-embarque NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br-embarques tt-historico-embarque
&Scoped-define FIRST-TABLE-IN-QUERY-br-embarques tt-historico-embarque


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-embarques}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-di tg-faixa c-estab-ini c-estab-fim ~
c-embarque-ini c-embarque-fim da-registro-di-ini da-registro-di-fim tg-di ~
rs-efetivado bt-fil br-embarques bt-excel bt-ok rs-embarque RECT-13 ~
IMAGE-27 IMAGE-28 IMAGE-29 IMAGE-30 RECT-15 IMAGE-31 IMAGE-32 RECT-16 ~
RECT-17 RECT-18 RECT-19 
&Scoped-Define DISPLAYED-OBJECTS c-di tg-faixa c-estab-ini c-estab-fim ~
c-embarque-ini c-embarque-fim da-registro-di-ini da-registro-di-fim tg-di ~
rs-efetivado rs-embarque 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-celula wWindow 
FUNCTION fn-celula RETURNS CHARACTER
  (INPUT fni-c-coluna AS CHARACTER, 
   INPUT fni-i-linha  AS INTEGER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-excel 
     IMAGE-UP FILE "image/excel.bmp":U
     LABEL "Excel" 
     SIZE 5 BY 1.5 TOOLTIP "Enviar requisi‡äes encontradas para planilha Excel".

DEFINE BUTTON bt-fil 
     IMAGE-UP FILE "image\im-enter.bmp":U
     LABEL "Filtrar" 
     SIZE 6 BY 1.38 TOOLTIP "Filtrar embarques conforme faixas informadas".

DEFINE BUTTON bt-ok AUTO-END-KEY 
     IMAGE-UP FILE "image/im-exi.bmp":U
     LABEL "&Sair" 
     SIZE 5 BY 1.5 TOOLTIP "Sair do programa"
     BGCOLOR 8 .

DEFINE VARIABLE c-di AS CHARACTER FORMAT "X(20)":U 
     LABEL "N£mero DI" 
     VIEW-AS FILL-IN 
     SIZE 25 BY .79 NO-UNDO.

DEFINE VARIABLE c-embarque-fim AS CHARACTER FORMAT "X(12)":U INITIAL "999999999998" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-embarque-ini AS CHARACTER FORMAT "X(12)":U INITIAL "0" 
     LABEL "Embarque" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-estab-fim AS CHARACTER FORMAT "X(5)":U INITIAL "99999" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-estab-ini AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE da-registro-di-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE da-registro-di-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/15 
     LABEL "Registro DI" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-27
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-28
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-29
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-30
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-31
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-32
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE rs-efetivado AS INTEGER INITIAL 5 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Despacho Efetivado", 1,
"DI Efetivada", 2,
"Entrada Efetivada", 3,
"NF Efetivada", 4,
"Todos", 5
     SIZE 24.57 BY 3.71 NO-UNDO.

DEFINE VARIABLE rs-embarque AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", 1,
"NÆo Encerrados", 2
     SIZE 26.43 BY 1.25 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89.57 BY 7.75.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 30 BY 1.88.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 30 BY 4.63.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 48 BY 1.88.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 48 BY 4.63.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 8 BY 4.

DEFINE VARIABLE tg-di AS LOGICAL INITIAL no 
     LABEL "Filtra por DI" 
     VIEW-AS TOGGLE-BOX
     SIZE 11 BY .83 NO-UNDO.

DEFINE VARIABLE tg-faixa AS LOGICAL INITIAL yes 
     LABEL "Filtra Embarques por Faixa" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-embarques FOR 
      tt-historico-embarque SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-embarques
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-embarques wWindow _STRUCTURED
  QUERY br-embarques NO-LOCK DISPLAY
      tt-historico-embarque.cod-estabel COLUMN-LABEL "Est" FORMAT "x(5)":U
            WIDTH 4
      tt-historico-embarque.cod-emitente @ tt-historico-embarque.cod-emitente COLUMN-LABEL "Emitente" FORMAT ">>>,>>>,>>9":U
            WIDTH 8.86
      tt-historico-embarque.nome-emit @ tt-historico-embarque.nome-emit COLUMN-LABEL "Nome" FORMAT "x(40)":U
            WIDTH 24.43
      tt-historico-embarque.embarque FORMAT "X(16)":U WIDTH 9.86
      tt-historico-embarque.de-valor-embarque @ tt-historico-embarque.de-valor-embarque COLUMN-LABEL "Valor" FORMAT ">>>,>>>,>>9.99":U
      tt-historico-embarque.c-moeda @ tt-historico-embarque.c-moeda COLUMN-LABEL "Moeda" FORMAT "x(20)":U
            WIDTH 8.14
      tt-historico-embarque.cod-itiner FORMAT ">>,>>9":U
      tt-historico-embarque.desc-itinerario @ tt-historico-embarque.desc-itinerario COLUMN-LABEL "Descri‡Æo" FORMAT "x(40)":U
            WIDTH 20
      tt-historico-embarque.dt-real-pto-68 @ tt-historico-embarque.dt-real-pto-68 COLUMN-LABEL "Despacho!Efetivo" FORMAT "99/99/9999":U
            WIDTH 11.43
      tt-historico-embarque.dt-emb-efetivo @ tt-historico-embarque.dt-emb-efetivo COLUMN-LABEL "Embarque!Efetivo" FORMAT "99/99/9999":U
            WIDTH 12.43
      tt-historico-embarque.dt-eadi-efetivo @ tt-historico-embarque.dt-eadi-efetivo COLUMN-LABEL "EADI!Efetivo" FORMAT "99/99/9999":U
            WIDTH 12.43
      tt-historico-embarque.dt-prev-pto-34 @ tt-historico-embarque.dt-prev-pto-34 COLUMN-LABEL "Registro DI!PrevisÆo" FORMAT "99/99/9999":U
            WIDTH 12.43
      tt-historico-embarque.dt-real-pto-34 @ tt-historico-embarque.dt-real-pto-34 COLUMN-LABEL "Registro DI!Efetivo" FORMAT "99/99/9999":U
            WIDTH 12.43
      tt-historico-embarque.dt-prev-pto-36 @ tt-historico-embarque.dt-prev-pto-36 COLUMN-LABEL "Entr Intelbras!PrevisÆo" FORMAT "99/99/9999":U
            WIDTH 13.43
      tt-historico-embarque.dt-real-pto-36 @ tt-historico-embarque.dt-real-pto-36 COLUMN-LABEL "Entr Intelbras!Efetivo" FORMAT "99/99/9999":U
            WIDTH 13.43
      tt-historico-embarque.dt-real-pto-44 @ tt-historico-embarque.dt-real-pto-44 COLUMN-LABEL "44-EmissÆo NF!Efetivo" FORMAT "99/99/9999":U
            WIDTH 13.43
      tt-historico-embarque.c-ult-pto @ tt-historico-embarque.c-ult-pto COLUMN-LABEL "élt Ponto Contr" FORMAT "x(40)":U
            WIDTH 20
      tt-historico-embarque.dt-ult-pto @ tt-historico-embarque.dt-ult-pto COLUMN-LABEL "Data" FORMAT "99/99/9999":U
            WIDTH 11.14
      tt-historico-embarque.c-nota-fiscal @ tt-historico-embarque.c-nota-fiscal COLUMN-LABEL "NF" FORMAT "x(7)":U
            WIDTH 7.29
      tt-historico-embarque.c-serie @ tt-historico-embarque.c-serie COLUMN-LABEL "Ser" FORMAT "x(02)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 117 BY 15.38
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     c-di AT ROW 7.5 COL 24.43 COLON-ALIGNED WIDGET-ID 180
     tg-faixa AT ROW 1.38 COL 17 WIDGET-ID 184
     c-estab-ini AT ROW 2.33 COL 24 COLON-ALIGNED WIDGET-ID 130
     c-estab-fim AT ROW 2.33 COL 47.29 COLON-ALIGNED NO-LABEL WIDGET-ID 132
     c-embarque-ini AT ROW 3.33 COL 24 COLON-ALIGNED WIDGET-ID 140
     c-embarque-fim AT ROW 3.33 COL 47.29 COLON-ALIGNED NO-LABEL WIDGET-ID 138
     da-registro-di-ini AT ROW 4.33 COL 24 COLON-ALIGNED WIDGET-ID 172
     da-registro-di-fim AT ROW 4.33 COL 47.29 COLON-ALIGNED NO-LABEL WIDGET-ID 170
     tg-di AT ROW 6.5 COL 17.29 WIDGET-ID 188
     rs-efetivado AT ROW 2.42 COL 67.72 NO-LABEL WIDGET-ID 152
     bt-fil AT ROW 7.21 COL 96.43 WIDGET-ID 64
     br-embarques AT ROW 9.5 COL 1 WIDGET-ID 200
     bt-excel AT ROW 3.42 COL 111.57 WIDGET-ID 66
     bt-ok AT ROW 1.5 COL 111.57 WIDGET-ID 68
     rs-embarque AT ROW 7.29 COL 67.86 NO-LABEL WIDGET-ID 190
     "Op‡äes:" VIEW-AS TEXT
          SIZE 6.72 BY .54 AT ROW 1.58 COL 67.57 WIDGET-ID 196
     "Embarques:" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 6.63 COL 67.14 WIDGET-ID 198
     RECT-13 AT ROW 1.33 COL 14.43 WIDGET-ID 108
     IMAGE-27 AT ROW 2.29 COL 40.43 WIDGET-ID 12
     IMAGE-28 AT ROW 2.29 COL 46 WIDGET-ID 14
     IMAGE-29 AT ROW 3.29 COL 40.43 WIDGET-ID 134
     IMAGE-30 AT ROW 3.29 COL 46 WIDGET-ID 136
     RECT-15 AT ROW 6.96 COL 65.29 WIDGET-ID 168
     IMAGE-31 AT ROW 4.33 COL 40.43 WIDGET-ID 174
     IMAGE-32 AT ROW 4.33 COL 46 WIDGET-ID 176
     RECT-16 AT ROW 1.88 COL 65.29 WIDGET-ID 178
     RECT-17 AT ROW 6.96 COL 16 WIDGET-ID 182
     RECT-18 AT ROW 1.88 COL 16 WIDGET-ID 186
     RECT-19 AT ROW 1.25 COL 110 WIDGET-ID 194
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 320 BY 320
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-historico-embarque T "?" NO-UNDO mgcad historico-embarque
      ADDITIONAL-FIELDS:
          field desc-itinerario   as char
          field de-valor-embarque as dec
          field c-moeda           as char
          field dt-prev-pto-68    as date
          field dt-real-pto-68    as date
          field dt-prev-pto-34    as date
          field dt-real-pto-34    as date
          field dt-prev-pto-36    as date
          field dt-real-pto-36    as date
          field dt-prev-pto-44    as date
          field dt-real-pto-44    as date
          field c-ult-pto         as char
          field dt-ult-pto        as date
          field c-nota-fiscal     as char
          field c-serie           as char
          field cod-emitente      as int
          field nome-emit         as char
          field dt-emb-efetivo    as date
          field dt-eadi-efetivo   as date
          index id-embarque cod-estabel embarque
          index id-despacho cod-estabel dt-prev-pto-68
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "ESIMP014 - Acompanhamento de Embarques"
         HEIGHT             = 24.04
         WIDTH              = 117.57
         MAX-HEIGHT         = 320
         MAX-WIDTH          = 320
         VIRTUAL-HEIGHT     = 320
         VIRTUAL-WIDTH      = 320
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB br-embarques bt-fil fpage0 */
ASSIGN 
       br-embarques:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE
       br-embarques:COLUMN-MOVABLE IN FRAME fpage0         = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-embarques
/* Query rebuild information for BROWSE br-embarques
     _TblList          = "Temp-Tables.tt-historico-embarque"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.tt-historico-embarque.cod-estabel
"tt-historico-embarque.cod-estabel" "Est" ? "character" ? ? ? ? ? ? no ? no no "4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"tt-historico-embarque.cod-emitente @ tt-historico-embarque.cod-emitente" "Emitente" ">>>,>>>,>>9" ? ? ? ? ? ? ? no ? no no "8.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"tt-historico-embarque.nome-emit @ tt-historico-embarque.nome-emit" "Nome" "x(40)" ? ? ? ? ? ? ? no ? no no "24.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-historico-embarque.embarque
"tt-historico-embarque.embarque" ? ? "character" ? ? ? ? ? ? no ? no no "9.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"tt-historico-embarque.de-valor-embarque @ tt-historico-embarque.de-valor-embarque" "Valor" ">>>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"tt-historico-embarque.c-moeda @ tt-historico-embarque.c-moeda" "Moeda" "x(20)" ? ? ? ? ? ? ? no ? no no "8.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = Temp-Tables.tt-historico-embarque.cod-itiner
     _FldNameList[8]   > "_<CALC>"
"tt-historico-embarque.desc-itinerario @ tt-historico-embarque.desc-itinerario" "Descri‡Æo" "x(40)" ? ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"tt-historico-embarque.dt-real-pto-68 @ tt-historico-embarque.dt-real-pto-68" "Despacho!Efetivo" "99/99/9999" ? ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"tt-historico-embarque.dt-emb-efetivo @ tt-historico-embarque.dt-emb-efetivo" "Embarque!Efetivo" "99/99/9999" ? ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"tt-historico-embarque.dt-eadi-efetivo @ tt-historico-embarque.dt-eadi-efetivo" "EADI!Efetivo" "99/99/9999" ? ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"tt-historico-embarque.dt-prev-pto-34 @ tt-historico-embarque.dt-prev-pto-34" "Registro DI!PrevisÆo" "99/99/9999" ? ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"tt-historico-embarque.dt-real-pto-34 @ tt-historico-embarque.dt-real-pto-34" "Registro DI!Efetivo" "99/99/9999" ? ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"tt-historico-embarque.dt-prev-pto-36 @ tt-historico-embarque.dt-prev-pto-36" "Entr Intelbras!PrevisÆo" "99/99/9999" ? ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > "_<CALC>"
"tt-historico-embarque.dt-real-pto-36 @ tt-historico-embarque.dt-real-pto-36" "Entr Intelbras!Efetivo" "99/99/9999" ? ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > "_<CALC>"
"tt-historico-embarque.dt-real-pto-44 @ tt-historico-embarque.dt-real-pto-44" "44-EmissÆo NF!Efetivo" "99/99/9999" ? ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > "_<CALC>"
"tt-historico-embarque.c-ult-pto @ tt-historico-embarque.c-ult-pto" "élt Ponto Contr" "x(40)" ? ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > "_<CALC>"
"tt-historico-embarque.dt-ult-pto @ tt-historico-embarque.dt-ult-pto" "Data" "99/99/9999" ? ? ? ? ? ? ? no ? no no "11.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > "_<CALC>"
"tt-historico-embarque.c-nota-fiscal @ tt-historico-embarque.c-nota-fiscal" "NF" "x(7)" ? ? ? ? ? ? ? no ? no no "7.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > "_<CALC>"
"tt-historico-embarque.c-serie @ tt-historico-embarque.c-serie" "Ser" "x(02)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-embarques */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow /* ESIMP014 - Acompanhamento de Embarques */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* ESIMP014 - Acompanhamento de Embarques */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-RESIZED OF wWindow /* ESIMP014 - Acompanhamento de Embarques */
DO:
    RUN resizeWindow.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-excel wWindow
ON CHOOSE OF bt-excel IN FRAME fpage0 /* Excel */
DO:
    FIND FIRST tt-historico-embarque NO-LOCK NO-ERROR.

    IF  NOT AVAIL tt-historico-embarque
    THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "NÆo foram encontrados embarques para gerar planilha.").
        RETURN NO-APPLY.
    END.

    IF  SESSION:SET-WAIT-STATE("general") THEN.
    RUN pi-gera-excel.  
    IF  SESSION:SET-WAIT-STATE("") THEN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-fil
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-fil wWindow
ON CHOOSE OF bt-fil IN FRAME fpage0 /* Filtrar */
DO:
    DEFINE VARIABLE de-valor-embarque AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE i-mo-codigo       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE dt-ult-pto        AS DATE        NO-UNDO.


    ASSIGN c-estab-ini        = INPUT FRAME {&FRAME-NAME} c-estab-ini
           c-estab-fim        = INPUT FRAME {&FRAME-NAME} c-estab-fim
           c-embarque-ini     = INPUT FRAME {&FRAME-NAME} c-embarque-ini
           c-embarque-fim     = INPUT FRAME {&FRAME-NAME} c-embarque-fim
           da-registro-di-ini = INPUT FRAME {&FRAME-NAME} da-registro-di-ini
           da-registro-di-fim = INPUT FRAME {&FRAME-NAME} da-registro-di-fim
           rs-efetivado       = INPUT FRAME {&FRAME-NAME} rs-efetivado
           i-linhas           = 0.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    
    RUN pi-inicializar IN h-acomp (INPUT "Lendo Embarques") .

    EMPTY TEMP-TABLE tt-historico-embarque.
    EMPTY TEMP-TABLE tt-embarque-registro-di.

    /*Verifica filtro por data dos embarques com o ponto de controle Registro da DI efetivado */
    IF  tg-faixa:CHECKED IN FRAME fpage0 THEN
        FOR EACH  embarque-imp NO-LOCK
            WHERE (IF INPUT FRAME fpage0 rs-embarque = 1 THEN YES /*Todos*/ ELSE embarque-imp.situacao = 1) /* NÆo Encerrado */
              AND embarque-imp.cod-estabel >= c-estab-ini
              AND embarque-imp.cod-estabel <= c-estab-fim
              AND embarque-imp.embarque    >= c-embarque-ini
              AND embarque-imp.embarque    <= c-embarque-fim 
              AND (IF  da-registro-di-ini:SCREEN-VALUE IN FRAME fpage0 = "" 
                   AND da-registro-di-fim:SCREEN-VALUE IN FRAME fpage0 = "31/12/9999" THEN
                      ((embarque-imp.data-DI >= da-registro-di-ini AND embarque-imp.data-DI  <= da-registro-di-fim) OR embarque-imp.data-DI = ?)
                   ELSE
                       (embarque-imp.data-DI >= da-registro-di-ini AND embarque-imp.data-DI  <= da-registro-di-fim)
                   ) :
              
              CREATE tt-embarque-registro-di.
              ASSIGN tt-embarque-registro-di.cod-estab = embarque-imp.cod-estab
                     tt-embarque-registro-di.embarque  = embarque-imp.embarque.
        END.
    ELSE /* Pelo N£mero da DI */
        FOR EACH  embarque-imp NO-LOCK
            WHERE (IF INPUT FRAME fpage0 rs-embarque = 1 THEN YES /*Todos*/ ELSE embarque-imp.situacao = 1) /* NÆo Encerrado */
              AND  embarque-imp.declaracao-import = INPUT FRAME fpage0 c-di:
                
              CREATE tt-embarque-registro-di.
              ASSIGN tt-embarque-registro-di.cod-estab = embarque-imp.cod-estab
                     tt-embarque-registro-di.embarque = embarque-imp.embarque.
              LEAVE.
        END.
 
    bloco-embarque:
    FOR EACH tt-embarque-registro-di
       ,EACH  embarque-imp NO-LOCK
        WHERE embarque-imp.cod-estabel = tt-embarque-registro-di.cod-estab
          AND embarque-imp.embarque = tt-embarque-registro-di.embarque
         ,EACH historico-embarque OF embarque-imp NO-LOCK,
        FIRST itinerario OF historico-embarque
        BREAK BY embarque-imp.embarque:

        IF  FIRST-OF(embarque-imp.embarque)
        THEN DO:
             RUN pi-acompanhar  IN h-acomp (INPUT "Embarque: " + STRING(embarque-imp.embarque)).

            RUN retornaMoedaValor IN h-bocx220 (input  embarque-imp.embarque,
                                                input  embarque-imp.cod-estabel,
                                                OUTPUT de-valor-embarque,
                                                OUTPUT i-mo-codigo).

            FIND FIRST ext-embarque-imp NO-LOCK
                 WHERE ext-embarque-imp.cod-estabel = embarque-imp.cod-estabel
                   AND ext-embarque-imp.embarque    = embarque-imp.embarque NO-ERROR.

            FIND FIRST usuar_mestre NO-LOCK
                 WHERE usuar_mestre.cod_usuar = ext-embarque-imp.MatriculaResponsavel NO-ERROR.

            FIND FIRST transporte NO-LOCK
                 WHERE transporte.cod-transp = embarque-imp.cod-transportador NO-ERROR.

            FIND FIRST b2-historico-embarque OF embarque-imp NO-LOCK
                 WHERE b2-historico-embarque.cod-pto-contr = 1 NO-ERROR.

            FIND FIRST docum-est NO-LOCK
                 WHERE docum-est.cod-estabel = embarque-imp.cod-estabel
                   AND docum-est.embarque    = embarque-imp.embarque NO-ERROR.

            CREATE tt-historico-embarque.
            ASSIGN tt-historico-embarque.embarque            = embarque-imp.embarque
                   tt-historico-embarque.cod-estabel         = embarque-imp.cod-estabel
                   tt-historico-embarque.cod-itiner          = historico-embarque.cod-itiner
                   tt-historico-embarque.desc-itinerario     = itinerario.descricao
                   tt-historico-embarque.modal               = {adinc/i01ad268.i 04 embarque-imp.cod-via-transp}
                   tt-historico-embarque.de-valor-embarque = de-valor-embarque
                   dt-ult-pto                              = 01/01/0001
                   i-linhas                                = i-linhas + 1.

            ASSIGN tt-historico-embarque.qtd-conteiner  = IF AVAIL ext-embarque-imp THEN ext-embarque-imp.qtd-conteiner  ELSE 0           
                   tt-historico-embarque.qtd2-conteiner = IF AVAIL ext-embarque-imp THEN ext-embarque-imp.qtd2-conteiner ELSE 0
                   tt-historico-embarque.cod-conhecto-master  = embarque-imp.cod-conhecto-master          
                   tt-historico-embarque.cod-conhecto-house   = embarque-imp.cod-conhecto-house           
                   tt-historico-embarque.transportador        = string(embarque-imp.cod-transportador) + " - " + transporte.nome-abrev
                   tt-historico-embarque.cod-incoterm         = embarque-imp.cod-incoterm                
                   tt-historico-embarque.via-transp           = {adinc/i01ad268.i 04 embarque-imp.cod-via-transp}
                   tt-historico-embarque.itiner               = string(historico-embarque.cod-itiner) + " - " + itinerario.descricao
                   tt-historico-embarque.vl-fob               = IF AVAIL docum-est THEN docum-est.valor-mercad ELSE 0.

            IF AVAIL b2-historico-embarque THEN
                ASSIGN tt-historico-embarque.entrega-invoice = IF b2-historico-embarque.dt-efetiva <> ? THEN b2-historico-embarque.dt-efetiva ELSE b2-historico-embarque.dt-prev.
            ELSE
                ASSIGN tt-historico-embarque.entrega-invoice = ?.

            IF AVAIL usuar_mestre THEN
                ASSIGN tt-historico-embarque.MatriculaResponsavel = IF AVAIL ext-embarque-imp THEN ext-embarque-imp.MatriculaResponsavel + " - " + usuar_mestre.nom_usuario ELSE "".

            IF AVAIL ext-embarque-imp THEN DO:
                CASE ext-embarque-imp.conteiner:
                    WHEN 1 THEN tt-historico-embarque.conteiner = "Contˆiner de 20":U.
                    WHEN 2 THEN tt-historico-embarque.conteiner = "Contˆiner de 40":U.
                    WHEN 3 THEN tt-historico-embarque.conteiner = "Contˆiner de 20/40":U.
                    WHEN 4 THEN tt-historico-embarque.conteiner = "NOR 20":U.
                    WHEN 5 THEN tt-historico-embarque.conteiner = "NOR 40":U.
                    WHEN 6 THEN tt-historico-embarque.conteiner = "Carga Solta":U.
                    OTHERWISE tt-historico-embarque.conteiner = "":U.
                END CASE.
            END.

            RUN esp/es0018p.p (INPUT "esimp014", /* Nome do programa */
                               INPUT 1,          /* Ponto do programa */
                               INPUT 0,
                               INPUT "",
                               OUTPUT TABLE tt-prog-ponto) NO-ERROR.

            FOR EACH tt-prog-ponto:
                FIND FIRST b2-historico-embarque OF embarque-imp NO-LOCK
                     WHERE b2-historico-embarque.cod-pto-contr = INT(tt-prog-ponto.conteudo) NO-ERROR. 

                IF AVAIL b2-historico-embarque THEN
                    LEAVE.
            END.

            IF AVAIL b2-historico-embarque THEN
                ASSIGN tt-historico-embarque.dt-chegada = IF b2-historico-embarque.dt-efetiva <> ? THEN b2-historico-embarque.dt-efetiva ELSE b2-historico-embarque.dt-prev.

            FOR EACH invoice-emb-imp OF embarque-imp NO-LOCK:
                FIND FIRST pagamento-invoice NO-LOCK
                     WHERE pagamento-invoice.embarque   = embarque-imp.embarque
                       AND pagamento-invoice.nr-invoice = invoice-emb-imp.nr-invoice 
                       AND pagamento-invoice.parcela    = invoice-emb-imp.parcela NO-ERROR.
    
                ASSIGN c-pagamento = "".
                IF AVAIL pagamento-invoice THEN DO:
                   IF c-pagamento = "" THEN
                      ASSIGN c-pagamento = STRING(pagamento-invoice.nr-pagamento).
                   ELSE
                      ASSIGN c-pagamento = c-pagamento + "," + string(pagamento-invoice.nr-pagamento). 
                END. 
            END.

            ASSIGN tt-historico-embarque.cis = c-pagamento.

            FOR FIRST ordens-embarque OF embarque-imp NO-LOCK,
                FIRST ordem-compra    OF ordens-embarque NO-LOCK,
                FIRST emitente        OF ordem-compra NO-LOCK,
                FIRST cotacao-item    OF ordem-compra NO-LOCK,
                FIRST pedido-compr    OF ordem-compra NO-LOCK,
                FIRST cond-pagto      OF pedido-compr NO-LOCK:

                ASSIGN tt-historico-embarque.cod-emitente        = emitente.cod-emitente
                       tt-historico-embarque.nome-emit           = emitente.nome-emit
                       tt-historico-embarque.cod-pto-contr-base  = int(SUBSTRING(cotacao-item.char-1,41,5))
                       tt-historico-embarque.cod-cond-pag        = pedido-compr.cod-cond-pag
                       tt-historico-embarque.descricao-cond-pag  = cond-pagto.descricao
                       tt-historico-embarque.declaracao-import   = embarque-imp.declaracao-import.

                FOR FIRST b-historico-embarque OF embarque-imp NO-LOCK
                   WHERE b-historico-embarque.cod-pto-contr = int(SUBSTRING(cotacao-item.char-1,41,5))
                     AND b-historico-embarque.dt-efetiva <> ?:
                    ASSIGN tt-historico-embarque.dt-entrega-proforma = b-historico-embarque.dt-efetiva.
                END.
            END.

            FOR FIRST moeda NO-LOCK
                WHERE moeda.mo-codigo = i-mo-codigo:
                ASSIGN tt-historico-embarque.c-moeda = STRING(i-mo-codigo) + " - " + moeda.descricao.
            END.

            FOR FIRST docum-est NO-LOCK
                WHERE docum-est.cod-emitente = tt-historico-embarque.cod-emitente
                  AND TRIM(SUBSTRING(docum-est.char-1,1,20)) = tt-historico-embarque.embarque:
            
                ASSIGN tt-historico-embarque.c-nota-fiscal = docum-est.nro-docto
                       tt-historico-embarque.c-serie       = docum-est.serie-docto.
            END.
        END.
        
        IF  historico-embarque.dt-efetiva <> ?
        THEN DO:
            ASSIGN dt-ult-pto = MAX(dt-ult-pto,historico-embarque.dt-efetiva).

            IF  dt-ult-pto = historico-embarque.dt-efetiva 
            THEN DO:
                ASSIGN tt-historico-embarque.dt-ult-pto = dt-ult-pto.

                FOR FIRST pto-contr NO-LOCK
                    WHERE pto-contr.cod-pto-contr = historico-embarque.cod-pto-contr:
                    ASSIGN tt-historico-embarque.c-ult-pto = STRING(historico-embarque.cod-pto-contr) + " - " + pto-contr.descricao.
                END.
            END.
        END.

        /* EADI Efetivo */
        FIND FIRST pto-itiner NO-LOCK
             WHERE pto-itiner.cod-itiner    = historico-embarque.cod-itiner
               AND pto-itiner.cod-pto-contr = historico-embarque.cod-pto-contr NO-ERROR.

        IF  AVAIL pto-itiner AND itinerario.int-1 = pto-itiner.cod-pto-contr THEN 
            ASSIGN tt-historico-embarque.dt-eadi-efetivo = historico-embarque.dt-efetiva.
        
        /* Embarque Efetivo */
        IF  AVAIL pto-itiner 
        AND itinerario.pto-embarque  = pto-itiner.cod-pto-contr 
        AND itinerario.pto-despacho <> pto-itiner.cod-pto-contr THEN
            ASSIGN tt-historico-embarque.dt-emb-efetivo = historico-embarque.dt-efetiva.

        /* Despacho */ 
        IF  AVAIL pto-itiner 
        AND itinerario.pto-despacho = pto-itiner.cod-pto-contr 
        AND itinerario.pto-embarque <> pto-itiner.cod-pto-contr THEN 
            ASSIGN tt-historico-embarque.dt-prev-pto-68 = historico-embarque.dt-ult-previsa
                   tt-historico-embarque.dt-real-pto-68 = historico-embarque.dt-efetiva.   

        IF  historico-embarque.cod-pto-contr = itinerario.pto-desembarque
        THEN 
            ASSIGN tt-historico-embarque.dt-prev-pto-34 = historico-embarque.dt-ult-previsao
                   tt-historico-embarque.dt-real-pto-34 = historico-embarque.dt-efetiva.

        IF  historico-embarque.cod-pto-contr = itinerario.pto-chegada
        THEN 
            ASSIGN tt-historico-embarque.dt-prev-pto-36 = historico-embarque.dt-ult-previsao
                   tt-historico-embarque.dt-real-pto-36 = historico-embarque.dt-efetiva.

        IF  historico-embarque.cod-pto-contr = 44
        THEN 
            ASSIGN tt-historico-embarque.dt-prev-pto-44 = historico-embarque.dt-ult-previsao
                   tt-historico-embarque.dt-real-pto-44 = historico-embarque.dt-efetiva.

        IF  LAST-OF(embarque-imp.embarque)
        THEN DO:
            IF  AVAIL tt-historico-embarque              AND 
                rs-efetivado                         = 1 AND
                tt-historico-embarque.dt-real-pto-68 = ?
            THEN 
                DELETE tt-historico-embarque.

            IF  AVAIL tt-historico-embarque              AND 
                rs-efetivado                         = 2 AND
                tt-historico-embarque.dt-real-pto-34 = ?
            THEN 
                DELETE tt-historico-embarque.

            IF  AVAIL tt-historico-embarque              AND 
                rs-efetivado                         = 3 AND
                tt-historico-embarque.dt-real-pto-36 = ?
            THEN 
                DELETE tt-historico-embarque.

            IF  AVAIL tt-historico-embarque              AND 
                rs-efetivado                         = 4 AND
                tt-historico-embarque.dt-real-pto-44 = ?
            THEN 
                DELETE tt-historico-embarque.
        END.
    END.

    RUN pi-finalizar IN h-acomp.

    {&OPEN-QUERY-br-embarques}
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok wWindow
ON CHOOSE OF bt-ok IN FRAME fpage0 /* Sair */
DO:

     apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-di
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-di wWindow
ON VALUE-CHANGED OF tg-di IN FRAME fpage0 /* Filtra por DI */
DO:
    
    IF  tg-di:CHECKED THEN
        ASSIGN tg-faixa:CHECKED                = NO
               c-estab-ini:SENSITIVE           = NO
               c-estab-fim:SENSITIVE           = NO
               c-embarque-ini:SENSITIVE        = NO
               c-embarque-fim:SENSITIVE        = NO
               da-registro-di-ini:SENSITIVE    = NO
               da-registro-di-fim:SENSITIVE    = NO
               c-estab-ini:SCREEN-VALUE        = ""              
               c-estab-fim:SCREEN-VALUE        = "99999"         
               c-embarque-ini:SCREEN-VALUE     = "0"             
               c-embarque-fim:SCREEN-VALUE     = "999999999999"  
               da-registro-di-ini:SCREEN-VALUE = "01/01/2015"              
               da-registro-di-fim:SCREEN-VALUE = "31/12/9999"    
               c-di:SENSITIVE               = YES. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-faixa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-faixa wWindow
ON VALUE-CHANGED OF tg-faixa IN FRAME fpage0 /* Filtra Embarques por Faixa */
DO:
    IF  tg-faixa:CHECKED THEN
        ASSIGN tg-faixa:CHECKED               = yes
               tg-di:CHECKED                  = NO
               c-estab-ini:SENSITIVE          = yes
               c-estab-fim:SENSITIVE          = yes
               c-embarque-ini:SENSITIVE       = yes
               c-embarque-fim:SENSITIVE       = yes
               da-registro-di-ini:SENSITIVE   = yes
               da-registro-di-fim:SENSITIVE   = yes
               c-di:SENSITIVE                 = NO
               c-di:SCREEN-VALUE              = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-embarques
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/

ASSIGN wWindow:MIN-WIDTH    = 90
       wWindow:MIN-HEIGHT   = 17.


{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/

    IF NOT VALID-HANDLE(h-facelift) 
    THEN
        RUN btb/btb901zo.p PERSISTENT SET h-facelift.
 
    RUN pi_aplica_facelift_thin IN h-facelift (INPUT FRAME fpage0:HANDLE ).


  ENABLE c-estab-ini c-estab-fim c-embarque-ini c-embarque-fim da-registro-di-ini da-registro-di-fim rs-efetivado  br-embarques bt-fil bt-excel bt-ok tg-faixa tg-di rs-embarque WITH FRAME fpage0 IN WINDOW wwindow.

  DISPLAY tg-faixa tg-di c-estab-ini c-estab-fim c-embarque-ini c-embarque-fim da-registro-di-ini da-registro-di-fim rs-efetivado rs-embarque WITH FRAME {&FRAME-NAME}.

  RUN cxbo/bocx220.p PERSISTENT SET h-bocx220.

  {&OPEN-BROWSERS-IN-QUERY-fpage0}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDestroyInterface wWindow 
PROCEDURE beforeDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DELETE PROCEDURE h-bocx220.
    ASSIGN h-bocx220 = ?.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-excel wWindow 
PROCEDURE pi-gera-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR chExcel         AS   COM-HANDLE NO-UNDO. 
    DEF VAR chArquivo       AS   COM-HANDLE NO-UNDO. 
    DEF VAR chPlanilha      AS   COM-HANDLE NO-UNDO. 
    DEF VAR c-arq-modelo    AS         CHAR NO-UNDO.
    DEF VAR v-arq-dest      AS         CHAR NO-UNDO.
    DEF VAR v-num-seq-linha AS          INT NO-UNDO.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    
    RUN pi-inicializar IN h-acomp (INPUT "Gerando Planilha").

    ASSIGN c-arq-modelo = SEARCH ('esp\imp\ESIMP014.xlsx').
        
    CREATE 'Excel.Application':U chExcel.
        
    chExcel:VISIBLE        = NO.
    chExcel:ScreenUpdating = NO.  

    ASSIGN v-arq-dest = SESSION:TEMP-DIRECTORY + "ESIMP014.xlsx".

    OS-DELETE VALUE(v-arq-dest) NO-ERROR.
    OS-COPY VALUE (c-arq-modelo) VALUE(v-arq-dest). 

    chArquivo  = chExcel:WorkBooks:OPEN (REPLACE(v-arq-dest,"/","\")).
    chArquivo:Activate().
    chPlanilha = chExcel:Sheets:Item(1). 
    
    ASSIGN v-num-seq-linha = 02. 

    FOR EACH tt-historico-embarque NO-LOCK:

        RUN pi-acompanhar IN h-acomp (INPUT "Linha " + STRING(v-num-seq-linha - 2) + " de " + STRING(i-linhas)).

        ASSIGN v-num-seq-linha = v-num-seq-linha + 1.

        chPlanilha:Range(Fn-Celula("A",v-num-seq-linha)) = tt-historico-embarque.cod-estabel.       
        chPlanilha:Range(Fn-Celula("B",v-num-seq-linha)) = tt-historico-embarque.cod-emitente.      
        chPlanilha:Range(Fn-Celula("C",v-num-seq-linha)) = tt-historico-embarque.nome-emit.         
        chPlanilha:Range(Fn-Celula("D",v-num-seq-linha)) = tt-historico-embarque.embarque.          
        chPlanilha:Range(Fn-Celula("E",v-num-seq-linha)) = tt-historico-embarque.de-valor-embarque. 
        chPlanilha:Range(Fn-Celula("F",v-num-seq-linha)) = tt-historico-embarque.c-moeda.           
        chPlanilha:Range(Fn-Celula("G",v-num-seq-linha)) = tt-historico-embarque.cod-itiner.        
        chPlanilha:Range(Fn-Celula("H",v-num-seq-linha)) = tt-historico-embarque.desc-itinerario.   

        chPlanilha:Range(Fn-Celula("I",v-num-seq-linha)) = tt-historico-embarque.cod-pto-contr-base.   
        chPlanilha:Range(Fn-Celula("J",v-num-seq-linha)) = tt-historico-embarque.cod-cond-pag.   
        chPlanilha:Range(Fn-Celula("K",v-num-seq-linha)) = tt-historico-embarque.descricao-cond-pag.   
        chPlanilha:Range(Fn-Celula("L",v-num-seq-linha)) = tt-historico-embarque.modal.   
        chPlanilha:Range(Fn-Celula("M",v-num-seq-linha)) = tt-historico-embarque.dt-entrega-proforma.   

        chPlanilha:Range(Fn-Celula("N",v-num-seq-linha)) = tt-historico-embarque.dt-real-pto-68.    
        chPlanilha:Range(Fn-Celula("O",v-num-seq-linha)) = tt-historico-embarque.dt-emb-efetivo.    
        chPlanilha:Range(Fn-Celula("P",v-num-seq-linha)) = tt-historico-embarque.dt-eadi-efetivo.    
        chPlanilha:Range(Fn-Celula("Q",v-num-seq-linha)) = tt-historico-embarque.dt-prev-pto-34.    
        chPlanilha:Range(Fn-Celula("R",v-num-seq-linha)) = tt-historico-embarque.dt-real-pto-34.    

        chPlanilha:Range(Fn-Celula("S",v-num-seq-linha)) = tt-historico-embarque.declaracao-import. 

        chPlanilha:Range(Fn-Celula("T",v-num-seq-linha)) = tt-historico-embarque.dt-prev-pto-36.    
        chPlanilha:Range(Fn-Celula("U",v-num-seq-linha)) = tt-historico-embarque.dt-real-pto-36.    
        chPlanilha:Range(Fn-Celula("V",v-num-seq-linha)) = tt-historico-embarque.dt-real-pto-44.    
        chPlanilha:Range(Fn-Celula("W",v-num-seq-linha)) = tt-historico-embarque.c-ult-pto.         
        chPlanilha:Range(Fn-Celula("X",v-num-seq-linha)) = tt-historico-embarque.dt-ult-pto.        
        chPlanilha:Range(Fn-Celula("Y",v-num-seq-linha)) = tt-historico-embarque.c-nota-fiscal.     
        chPlanilha:Range(Fn-Celula("Z",v-num-seq-linha)) = tt-historico-embarque.c-serie.           

        chPlanilha:Range(Fn-Celula("AA",v-num-seq-linha)) = tt-historico-embarque.conteiner.           
        chPlanilha:Range(Fn-Celula("AB",v-num-seq-linha)) = tt-historico-embarque.qtd-conteiner.           
        chPlanilha:Range(Fn-Celula("AC",v-num-seq-linha)) = tt-historico-embarque.qtd2-conteiner.           
        chPlanilha:Range(Fn-Celula("AD",v-num-seq-linha)) = tt-historico-embarque.cod-conhecto-master.           
        chPlanilha:Range(Fn-Celula("AE",v-num-seq-linha)) = tt-historico-embarque.cod-conhecto-house.           
        chPlanilha:Range(Fn-Celula("AF",v-num-seq-linha)) = tt-historico-embarque.MatriculaResponsavel.
        chPlanilha:Range(Fn-Celula("AG",v-num-seq-linha)) = tt-historico-embarque.transportador.
        chPlanilha:Range(Fn-Celula("AH",v-num-seq-linha)) = tt-historico-embarque.cod-incoterm.
        chPlanilha:Range(Fn-Celula("AI",v-num-seq-linha)) = tt-historico-embarque.via-transp.
        chPlanilha:Range(Fn-Celula("AJ",v-num-seq-linha)) = tt-historico-embarque.itiner.
        chPlanilha:Range(Fn-Celula("AK",v-num-seq-linha)) = tt-historico-embarque.entrega-invoice.
        chPlanilha:Range(Fn-Celula("AL",v-num-seq-linha)) = tt-historico-embarque.dt-chegada.
        chPlanilha:Range(Fn-Celula("AM",v-num-seq-linha)) = tt-historico-embarque.vl-fob.
        chPlanilha:Range(Fn-Celula("AN",v-num-seq-linha)) = tt-historico-embarque.cis.
    END.                            

    RUN pi-finalizar IN h-acomp.

    chPlanilha = chExcel:Sheets:Item(1).
    chexcel:Columns("B:T"):EntireColumn:AutoFit.
    chPlanilha = chExcel:Range('A3'):SELECT.
    chExcel:VISIBLE        = YES.
    chExcel:ScreenUpdating = TRUE.
    chexcel:WindowState    = 3.
    chArquivo:SAVE.

    RELEASE OBJECT chArquivo  NO-ERROR.
    RELEASE OBJECT chPlanilha NO-ERROR.
    RELEASE OBJECT chExcel    NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeWindow wWindow 
PROCEDURE resizeWindow :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN br-embarques :WIDTH IN FRAME {&FRAME-NAME} = wWindow:WIDTH.
    ASSIGN br-embarques :HEIGHT = wWindow:HEIGHT -  3.50.
    
/*     ASSIGN rect-13      :WIDTH IN FRAME {&FRAME-NAME} = wWindow:WIDTH. */
/*     ASSIGN bt-fil       :COLUMN = wWindow:WIDTH  -  8.00. */
/*     ASSIGN bt-excel     :COLUMN = wWindow:WIDTH  -  3.50. */
/*     ASSIGN bt-ok        :COLUMN = wWindow:WIDTH  -  3.50. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-celula wWindow 
FUNCTION fn-celula RETURNS CHARACTER
  (INPUT fni-c-coluna AS CHARACTER, 
   INPUT fni-i-linha  AS INTEGER):

    DEFINE VARIABLE fno-c-celula AS CHARACTER NO-UNDO. 

    ASSIGN fno-c-celula = TRIM (fni-c-coluna) + TRIM (STRING (fni-i-linha)) .

    RETURN fno-c-celula. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

