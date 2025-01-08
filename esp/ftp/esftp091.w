&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESFTP091 2.00.06.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESFTP091
&GLOBAL-DEFINE Version        2.00.06.000

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Folder1

&GLOBAL-DEFINE page0Widgets   v-dat-nf-ini v-dat-nf-fim v-num-emb-ini v-num-emb-fim rs-rastreabilidade ~
                              rs-tipo-volume bt-fil btexit v-cod-estab-ini v-cod-estab-fim br-notas br-itens-nota v-unid-negoc ~
                              fi-uf-ini fi-uf-fim fi-cod-transp-ini fi-cod-transp-fim v-dat-emb-ini v-dat-emb-fim rs-filtro-data tg-itens bt-relat

&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF NEW GLOBAL SHARED VAR adm-broker-hdl AS HANDLE NO-UNDO.

DEFINE VARIABLE h-acomp         AS HANDLE      NO-UNDO.
DEFINE VARIABLE v-dat-tmp       AS DATE        NO-UNDO.
DEFINE VARIABLE v-log-item-ok   AS LOGICAL     NO-UNDO.
/* Temp Table Definitions ---                                          */

DEF TEMP-TABLE tt-notas NO-UNDO
    FIELD cod-estabel  LIKE nota-fiscal.cod-estabel
    FIELD serie        LIKE nota-fiscal.serie
    FIELD nr-nota-fis  LIKE nota-fiscal.nr-nota-fis
    FIELD nome-emit    LIKE emitente.nome-emit
    FIELD nat-operacao LIKE natur-oper.nat-operacao
    FIELD dt-emis-nota LIKE nota-fiscal.dt-emis-nota
    FIELD dt-saida     LIKE nota-fiscal.dt-saida
    FIELD cli-difer    AS CHAR FORMAT "x(12)"
    FIELD nome-transp  AS CHAR FORMAT "x(12)"
    FIELD estado       LIKE nota-fiscal.estado
    FIELD nm-oper      AS CHAR FORMAT "x(12)"
    FIELD dt-cancel    LIKE nota-fiscal.dt-cancel
    FIELD dt-devol     AS DATE FORMAT "99/99/9999"
    FIELD nr-embarque  LIKE nota-fiscal.cdd-embarq
    FIELD it-codigo    LIKE it-nota-fisc.it-codigo
    FIELD desc-item    LIKE ITEM.desc-item
    FIELD sigla-emb    LIKE embalag.sigla-emb
    FIELD desc-emb     LIKE embalag.descricao
    FIELD des-unid-neg   AS CHAR
    FIELD qtd-volume     AS DEC FORMAT "->>>,>>>,>>9.99"
    FIELD vol-padr       AS INT
    FIELD vol-frac       AS INT
    FIELD qtd-peso-liq   AS DEC FORMAT "->>>,>>>,>>9.999"
    FIELD qtd-peso-bru   AS DEC FORMAT "->>>,>>>,>>9.999"
    FIELD cubagem        AS DEC FORMAT "->>>,>>>,>>9.99"
    FIELD qtd-faturada   AS DEC FORMAT "->>>,>>>,>>9.99"
    FIELD val-faturado   AS DEC FORMAT "->>>,>>>,>>9.99" 
    FIELD cod-depos      AS CHAR
    FIELD integrado-wms  AS LOG FORMAT "Sim/N∆o"
    FIELD hr-embarque    AS CHAR
    FIELD qtd-items-nf   AS INT
    FIELD cod-unid-negoc AS CHAR
    INDEX id-nota
            cod-estabel
            serie
            nr-nota-fis.

DEFINE TEMP-TABLE tt-itens-nota NO-UNDO LIKE tt-notas.

DEFINE TEMP-TABLE tt-item-rast NO-UNDO
    FIELD it-codigo LIKE item.it-codigo
    INDEX id-item
            it-codigo.

DEFINE TEMP-TABLE tt-transportadora NO-UNDO
       FIELD cod-transp LIKE transporte.cod-transp
       FIELD nome-trans LIKE transporte.nome-abrev.

DEFINE BUFFER bf-volume-nf FOR volume-nf.

DEFINE VAR l-avail   AS LOG NO-UNDO.
DEFINE VAR c-retorno AS CHAR NO-UNDO.
def new Global shared var c-seg-usuario as char format "x(12)" no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-itens-nota

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-itens-nota tt-notas

/* Definitions for BROWSE br-itens-nota                                 */
&Scoped-define FIELDS-IN-QUERY-br-itens-nota tt-itens-nota.cod-estabel tt-itens-nota.serie tt-itens-nota.nr-nota-fis tt-itens-nota.nome-emit tt-itens-nota.nat-operacao tt-itens-nota.dt-emis-nota tt-itens-nota.dt-saida tt-itens-nota.dt-saida - tt-itens-nota.dt-emis-nota tt-itens-nota.it-codigo tt-itens-nota.cod-unid-negoc tt-itens-nota.cli-difer tt-itens-nota.nome-transp tt-itens-nota.estado tt-itens-nota.nm-oper tt-itens-nota.dt-cancel tt-itens-nota.dt-devol tt-itens-nota.nr-embarque tt-itens-nota.qtd-faturada tt-itens-nota.val-faturado tt-itens-nota.qtd-volume tt-itens-nota.vol-padr tt-itens-nota.vol-frac tt-itens-nota.qtd-peso-liq tt-itens-nota.qtd-peso-bru tt-itens-nota.cubagem tt-itens-nota.cod-depos tt-itens-nota.integrado-wms tt-itens-nota.hr-embarque tt-itens-nota.qtd-items-nf   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-itens-nota   
&Scoped-define SELF-NAME br-itens-nota
&Scoped-define QUERY-STRING-br-itens-nota FOR EACH tt-itens-nota
&Scoped-define OPEN-QUERY-br-itens-nota OPEN QUERY {&SELF-NAME} FOR EACH tt-itens-nota.
&Scoped-define TABLES-IN-QUERY-br-itens-nota tt-itens-nota
&Scoped-define FIRST-TABLE-IN-QUERY-br-itens-nota tt-itens-nota


/* Definitions for BROWSE br-notas                                      */
&Scoped-define FIELDS-IN-QUERY-br-notas tt-notas.cod-estabel tt-notas.serie tt-notas.nr-nota-fis tt-notas.nome-emit tt-notas.nat-operacao tt-notas.dt-emis-nota tt-notas.dt-saida tt-notas.dt-saida - tt-notas.dt-emis-nota tt-notas.cli-difer tt-notas.nome-transp tt-notas.estado tt-notas.nm-oper tt-notas.dt-cancel tt-notas.dt-devol tt-notas.nr-embarque tt-notas.qtd-faturada tt-notas.val-faturado tt-notas.qtd-volume tt-notas.vol-padr tt-notas.vol-frac tt-notas.qtd-peso-liq tt-notas.qtd-peso-bru tt-notas.cubagem tt-notas.cod-depos tt-notas.integrado-wms tt-notas.hr-embarque tt-notas.qtd-items-nf   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-notas   
&Scoped-define SELF-NAME br-notas
&Scoped-define QUERY-STRING-br-notas FOR EACH tt-notas
&Scoped-define OPEN-QUERY-br-notas OPEN QUERY {&SELF-NAME} FOR EACH tt-notas.
&Scoped-define TABLES-IN-QUERY-br-notas tt-notas
&Scoped-define FIRST-TABLE-IN-QUERY-br-notas tt-notas


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-itens-nota}~
    ~{&OPEN-QUERY-br-notas}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bt-relat tg-itens rs-filtro-data ~
v-cod-estab-ini v-cod-estab-fim v-dat-nf-ini v-dat-nf-fim v-dat-emb-ini ~
v-dat-emb-fim v-num-emb-ini v-num-emb-fim fi-uf-ini fi-uf-fim ~
fi-cod-transp-ini fi-cod-transp-fim rs-rastreabilidade rs-tipo-volume ~
bt-fil btExit RECT-2 IMAGE-7 IMAGE-8 IMAGE-1 br-notas IMAGE-2 IMAGE-9 ~
IMAGE-10 IMAGE-11 IMAGE-12 IMAGE-13 IMAGE-14 RECT-3 RECT-4 IMAGE-15 ~
IMAGE-16 br-itens-nota 
&Scoped-Define DISPLAYED-OBJECTS v-unid-negoc tg-itens rs-filtro-data ~
v-cod-estab-ini v-cod-estab-fim v-dat-nf-ini v-dat-nf-fim v-dat-emb-ini ~
v-dat-emb-fim v-num-emb-ini v-num-emb-fim fi-uf-ini fi-uf-fim ~
fi-cod-transp-ini fi-cod-transp-fim rs-rastreabilidade rs-tipo-volume 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-fil 
     IMAGE-UP FILE "image/im-enter.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-enter.bmp":U
     LABEL "Filtrar" 
     SIZE 4 BY 1.13 TOOLTIP "Filtrar notas fiscais"
     FONT 4.

DEFINE BUTTON bt-relat 
     IMAGE-UP FILE "adeicon/report%.ico":U
     LABEL "Relatorio CSV" 
     SIZE 4 BY 1.13.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image/im-exi":U
     IMAGE-INSENSITIVE FILE "image/ii-exi":U
     LABEL "Sair" 
     SIZE 4 BY 1.13 TOOLTIP "Sair do programa"
     FONT 4.

DEFINE VARIABLE fi-cod-transp-fim AS INTEGER FORMAT ">>>>>9":U INITIAL 999999 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-transp-ini AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Cod Transp" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-uf-fim AS CHARACTER FORMAT "X(2)":U INITIAL "ZZ" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-uf-ini AS CHARACTER FORMAT "X(2)":U 
     LABEL "UF" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-estab-fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-estab-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estalecimento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE v-dat-emb-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE v-dat-emb-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Dt Embarque" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE v-dat-nf-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE v-dat-nf-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Dt Emiss∆o NF" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE v-num-emb-fim AS INTEGER FORMAT ">>>>,>>9" INITIAL 9999999 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE v-num-emb-ini AS INTEGER FORMAT ">>>>,>>9" INITIAL 0 
     LABEL "Embarque":R10 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE v-unid-negoc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Unid Negoc" 
     VIEW-AS FILL-IN 
     SIZE 7.29 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image\im-las":U
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

DEFINE VARIABLE rs-filtro-data AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Emiss∆o NF", 1,
"Embarque", 2
     SIZE 30 BY 1 NO-UNDO.

DEFINE VARIABLE rs-rastreabilidade AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Com Rastreabilidade", 1,
"Sem Rastreabilidade", 2,
"Ambos", 3
     SIZE 18 BY 2.75 NO-UNDO.

DEFINE VARIABLE rs-tipo-volume AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Fracionada", 1,
"Fechada", 2,
"Ambos", 3
     SIZE 12 BY 2.75 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 7.83.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 34 BY 3.25.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 34 BY 1.42.

DEFINE VARIABLE tg-itens AS LOGICAL INITIAL no 
     LABEL "Listar Itens Nota" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-itens-nota FOR 
      tt-itens-nota SCROLLING.

DEFINE QUERY br-notas FOR 
      tt-notas SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-itens-nota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-itens-nota wWindow _FREEFORM
  QUERY br-itens-nota DISPLAY
      tt-itens-nota.cod-estabel    LABEL "Est"
tt-itens-nota.serie          LABEL "Ser"          FORMAT "x(03)"
tt-itens-nota.nr-nota-fis    LABEL "Nota"         FORMAT "x(07)" WIDTH 8 
tt-itens-nota.nome-emit      LABEL "Raz∆o Social" FORMAT "x(40)"
tt-itens-nota.nat-operacao   LABEL "Nat. Operaá∆o"
tt-itens-nota.dt-emis-nota   LABEL "Emiss∆o"
tt-itens-nota.dt-saida       LABEL "Sa°da"
tt-itens-nota.dt-saida - tt-itens-nota.dt-emis-nota LABEL "Dias"  
tt-itens-nota.it-codigo      LABEL "Item"
tt-itens-nota.cod-unid-negoc LABEL "Unid Negoc"
tt-itens-nota.cli-difer      LABEL "Cliente Diferenciado"     
tt-itens-nota.nome-transp    LABEL "Transportadora"   WIDTH 11   
tt-itens-nota.estado         LABEL "Estado"   WIDTH 11   
tt-itens-nota.nm-oper        LABEL "Atendente"      
tt-itens-nota.dt-cancel      LABEL "Cancelamento"      
tt-itens-nota.dt-devol       LABEL "Devoluá∆o"

tt-itens-nota.nr-embarque    LABEL "Embarque"
tt-itens-nota.qtd-faturada   LABEL "Quantidade"
tt-itens-nota.val-faturado   FORMAT "->>>,>>>,>>9.99" LABEL "R$ Faturado"
tt-itens-nota.qtd-volume     LABEL "Volumes"
tt-itens-nota.vol-padr       LABEL "Q.Padr"
tt-itens-nota.vol-frac       LABEL "Q.Frac"
tt-itens-nota.qtd-peso-liq   LABEL "Peso Liq"
tt-itens-nota.qtd-peso-bru   LABEL "Peso Bruto"
tt-itens-nota.cubagem        FORMAT ">>>,>>>,>>>,>>9.99" LABEL "Cubagem"
tt-itens-nota.cod-depos      LABEL "Depositos"
tt-itens-nota.integrado-wms  LABEL "WMS"
tt-itens-nota.hr-embarque    LABEL "Hr Embarq" FORMAT "x(10)"
tt-itens-nota.qtd-items-nf   LABEL "Qtd Itens NF"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 89 BY 15.75
         FONT 1
         TITLE "Itens Notas Fiscais" ROW-HEIGHT-CHARS .67.

DEFINE BROWSE br-notas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-notas wWindow _FREEFORM
  QUERY br-notas DISPLAY
      tt-notas.cod-estabel    LABEL "Est"
tt-notas.serie          LABEL "Ser"          FORMAT "x(03)"
tt-notas.nr-nota-fis    LABEL "Nota"         FORMAT "x(07)" WIDTH 8 
tt-notas.nome-emit      LABEL "Raz∆o Social" FORMAT "x(40)"
tt-notas.nat-operacao   LABEL "Nat. Operaá∆o"
tt-notas.dt-emis-nota   LABEL "Emiss∆o"
tt-notas.dt-saida       LABEL "Sa°da"
tt-notas.dt-saida - tt-notas.dt-emis-nota LABEL "Dias"       
tt-notas.cli-difer      LABEL "Cliente Diferenciado"     
tt-notas.nome-transp    LABEL "Transportadora"   WIDTH 11   
tt-notas.estado         LABEL "Estado"   WIDTH 11   
tt-notas.nm-oper        LABEL "Atendente"      
tt-notas.dt-cancel      LABEL "Cancelamento"      
tt-notas.dt-devol       LABEL "Devoluá∆o"

tt-notas.nr-embarque    LABEL "Embarque"
tt-notas.qtd-faturada   LABEL "Quantidade"
tt-notas.val-faturado   FORMAT "->>>,>>>,>>9.99" LABEL "R$ Faturado"
tt-notas.qtd-volume     LABEL "Volumes"
tt-notas.vol-padr       LABEL "Q.Padr"
tt-notas.vol-frac       LABEL "Q.Frac"
tt-notas.qtd-peso-liq   LABEL "Peso Liq"
tt-notas.qtd-peso-bru   LABEL "Peso Bruto"
tt-notas.cubagem        FORMAT ">>>,>>>,>>>,>>9.99" LABEL "Cubagem"
tt-notas.cod-depos      LABEL "Depositos"
tt-notas.integrado-wms  LABEL "WMS"
tt-notas.hr-embarque    LABEL "Hr Embarq" FORMAT "x(10)"
tt-notas.qtd-items-nf   LABEL "Qtd Itens NF"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 89 BY 15.75
         FONT 1
         TITLE "Notas Fiscais" ROW-HEIGHT-CHARS .67.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     bt-relat AT ROW 4.42 COL 86 WIDGET-ID 162
     v-unid-negoc AT ROW 7.96 COL 14.14 COLON-ALIGNED WIDGET-ID 160
     tg-itens AT ROW 6.79 COL 51.29 WIDGET-ID 158
     rs-filtro-data AT ROW 5.58 COL 52.14 NO-LABEL WIDGET-ID 142
     v-cod-estab-ini AT ROW 1.75 COL 16.72 COLON-ALIGNED WIDGET-ID 122
     v-cod-estab-fim AT ROW 1.75 COL 32.72 COLON-ALIGNED NO-LABEL WIDGET-ID 120
     v-dat-nf-ini AT ROW 2.75 COL 11.72 COLON-ALIGNED WIDGET-ID 90
     v-dat-nf-fim AT ROW 2.75 COL 32.72 COLON-ALIGNED NO-LABEL WIDGET-ID 88
     v-dat-emb-ini AT ROW 3.79 COL 11.72 COLON-ALIGNED WIDGET-ID 156
     v-dat-emb-fim AT ROW 3.79 COL 32.72 COLON-ALIGNED NO-LABEL WIDGET-ID 154
     v-num-emb-ini AT ROW 4.83 COL 13.72 COLON-ALIGNED HELP
          "Embarque" WIDGET-ID 102
     v-num-emb-fim AT ROW 4.83 COL 32.72 COLON-ALIGNED HELP
          "Embarque" NO-LABEL WIDGET-ID 100
     fi-uf-ini AT ROW 5.88 COL 16.57 COLON-ALIGNED WIDGET-ID 134
     fi-uf-fim AT ROW 5.88 COL 32.72 COLON-ALIGNED NO-LABEL WIDGET-ID 132
     fi-cod-transp-ini AT ROW 6.92 COL 9.57 COLON-ALIGNED WIDGET-ID 138
     fi-cod-transp-fim AT ROW 6.92 COL 32.72 COLON-ALIGNED NO-LABEL WIDGET-ID 136
     rs-rastreabilidade AT ROW 1.96 COL 52.14 NO-LABEL WIDGET-ID 104
     rs-tipo-volume AT ROW 1.96 COL 72 NO-LABEL WIDGET-ID 108
     bt-fil AT ROW 1.75 COL 86 HELP
          "Filtrar objetos expedidos pelos Correios" WIDGET-ID 112
     btExit AT ROW 3 COL 86 HELP
          "Sair do programa" WIDGET-ID 114
     br-notas AT ROW 9.92 COL 2 WIDGET-ID 200
     br-itens-nota AT ROW 9.88 COL 2 WIDGET-ID 300
     "Filtro por data:" VIEW-AS TEXT
          SIZE 11 BY .54 AT ROW 5.04 COL 53 WIDGET-ID 148
     RECT-2 AT ROW 1.42 COL 2 WIDGET-ID 74
     IMAGE-7 AT ROW 2.75 COL 24.72 WIDGET-ID 92
     IMAGE-8 AT ROW 2.75 COL 30.72 WIDGET-ID 94
     IMAGE-1 AT ROW 4.83 COL 24.72 WIDGET-ID 96
     IMAGE-2 AT ROW 4.92 COL 30.72 WIDGET-ID 98
     IMAGE-9 AT ROW 1.75 COL 24.72 WIDGET-ID 116
     IMAGE-10 AT ROW 1.75 COL 30.72 WIDGET-ID 118
     IMAGE-11 AT ROW 5.88 COL 24.72 WIDGET-ID 124
     IMAGE-12 AT ROW 5.96 COL 30.72 WIDGET-ID 126
     IMAGE-13 AT ROW 6.92 COL 24.72 WIDGET-ID 128
     IMAGE-14 AT ROW 7 COL 30.72 WIDGET-ID 130
     RECT-3 AT ROW 1.75 COL 51 WIDGET-ID 140
     RECT-4 AT ROW 5.29 COL 51 WIDGET-ID 146
     IMAGE-15 AT ROW 3.79 COL 24.72 WIDGET-ID 150
     IMAGE-16 AT ROW 3.79 COL 30.72 WIDGET-ID 152
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 91.29 BY 24.88
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
         HEIGHT             = 24.88
         WIDTH              = 91.29
         MAX-HEIGHT         = 34
         MAX-WIDTH          = 219.43
         VIRTUAL-HEIGHT     = 34
         VIRTUAL-WIDTH      = 219.43
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
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB br-notas IMAGE-1 fpage0 */
/* BROWSE-TAB br-itens-nota IMAGE-16 fpage0 */
ASSIGN 
       br-itens-nota:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE
       br-itens-nota:COLUMN-MOVABLE IN FRAME fpage0         = TRUE.

ASSIGN 
       br-notas:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE
       br-notas:COLUMN-MOVABLE IN FRAME fpage0         = TRUE.

/* SETTINGS FOR FILL-IN v-unid-negoc IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-itens-nota
/* Query rebuild information for BROWSE br-itens-nota
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-itens-nota.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-itens-nota */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-notas
/* Query rebuild information for BROWSE br-notas
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-notas.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-notas */
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


&Scoped-define SELF-NAME bt-fil
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-fil wWindow
ON CHOOSE OF bt-fil IN FRAME fpage0 /* Filtrar */
DO:
    DEFINE VARIABLE i-vol-padr AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-vol-frac AS INTEGER     NO-UNDO.

    ASSIGN v-cod-estab-ini    = INPUT FRAME {&FRAME-NAME} v-cod-estab-ini
           v-cod-estab-fim    = INPUT FRAME {&FRAME-NAME} v-cod-estab-fim
           v-dat-nf-ini       = INPUT FRAME {&FRAME-NAME} v-dat-nf-ini      
           v-dat-nf-fim       = INPUT FRAME {&FRAME-NAME} v-dat-nf-fim      
           v-dat-emb-ini      = INPUT FRAME {&FRAME-NAME} v-dat-emb-ini      
           v-dat-emb-fim      = INPUT FRAME {&FRAME-NAME} v-dat-emb-fim  
           v-num-emb-ini      = INPUT FRAME {&FRAME-NAME} v-num-emb-ini     
           v-num-emb-fim      = INPUT FRAME {&FRAME-NAME} v-num-emb-fim  
           fi-uf-ini          = INPUT FRAME {&FRAME-NAME} fi-uf-ini     
           fi-uf-fim          = INPUT FRAME {&FRAME-NAME} fi-uf-fim
           fi-cod-transp-ini  = INPUT FRAME {&FRAME-NAME} fi-cod-transp-ini     
           fi-cod-transp-fim  = INPUT FRAME {&FRAME-NAME} fi-cod-transp-fim
           rs-rastreabilidade = INPUT FRAME {&FRAME-NAME} rs-rastreabilidade
           rs-tipo-volume     = INPUT FRAME {&FRAME-NAME} rs-tipo-volume
           rs-filtro-data     = INPUT FRAME {&FRAME-NAME} rs-filtro-data
           tg-itens           = INPUT FRAME {&FRAME-NAME} tg-itens
           v-unid-negoc       = INPUT FRAME {&FRAME-NAME} v-unid-negoc.    

    IF  NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    RUN pi-inicializar IN h-acomp (INPUT "Buscando dados...").

    EMPTY TEMP-TABLE tt-notas.
    EMPTY TEMP-TABLE tt-itens-nota.
    EMPTY TEMP-TABLE tt-item-rast.
    EMPTY TEMP-TABLE tt-transportadora.

    IF tg-itens:CHECKED THEN DO:
        br-itens-nota:MOVE-TO-TOP().
       {&OPEN-QUERY-br-itens-nota}
    END.
    ELSE DO:
        br-notas:MOVE-TO-TOP().
       {&OPEN-QUERY-br-notas}
    END.

    RUN pi-busca-transportadora.

    IF  rs-rastreabilidade <> 3 THEN DO:
         RUN pi-rast.
        /*FIND FIRST ponto-programa NO-LOCK 
            WHERE  ponto-programa.nome-programa = "esftp082":U
              AND  ponto-programa.ponto         = 1 NO-ERROR.
    
        IF AVAILABLE ponto-programa 
        THEN DO:
            FOR EACH  conteudo-programa NO-LOCK 
                WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
                CREATE tt-item-rast.
                ASSIGN tt-item-rast.it-codigo = TRIM(conteudo-programa.conteudo).
            END.
        END. */
    END.

    IF  v-num-emb-ini <> 0 OR
        v-num-emb-fim <> 9999999
    THEN DO:
        bloco-nota:
        FOR EACH  nota-fiscal NO-LOCK
            WHERE nota-fiscal.cdd-embarq >= v-num-emb-ini
              AND nota-fiscal.cdd-embarq <= v-num-emb-fim:


              run pi-acompanhar in h-acomp (input "Embarque: " + STRING(nota-fiscal.cdd-embarq) + " - Nota: " + nota-fiscal.nr-nota-fis).
              
              IF rs-filtro-data = 1 THEN DO:              
                  IF  nota-fiscal.dt-emis-nota < v-dat-nf-ini OR nota-fiscal.dt-emis-nota > v-dat-nf-fim
                  THEN NEXT bloco-nota.
              END.
              ELSE DO:
                  FIND FIRST embarque 
                       WHERE embarque.cdd-embarq = nota-fiscal.cdd-embarq NO-LOCK NO-ERROR.
                  IF AVAIL embarque THEN DO:
                      RUN pi-ve-int-embarque(OUTPUT l-avail).
                      IF  embarque.dt-embarque < v-dat-emb-ini OR
                          embarque.dt-embarque > v-dat-emb-fim
                      THEN NEXT bloco-nota.
                  END.
              END.

              IF  nota-fiscal.cod-estabel < v-cod-estab-ini OR
                  nota-fiscal.cod-estabel > v-cod-estab-fim
              THEN NEXT bloco-nota.

              //Filtra UF
              IF  nota-fiscal.estado < fi-uf-ini OR nota-fiscal.estado > fi-uf-fim THEN NEXT bloco-nota.

              //Filtra Transportadora
              RUN pi-valida-transp(INPUT nota-fiscal.nome-transp,
                                   OUTPUT c-retorno).
              IF c-retorno = "N" THEN NEXT bloco-nota.

              FIND emitente NO-LOCK
                  WHERE emitente.nome-abrev = nota-fiscal.nome-ab-cli NO-ERROR.

              FIND FIRST cli-difer NO-LOCK 
                  WHERE cli-difer.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.

              FIND ped-venda NO-LOCK
                  WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                    AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-ERROR.

              IF  AVAIL ped-venda THEN 
                  FIND FIRST atendente NO-LOCK
                      WHERE atendente.cd-oper = int(ped-venda.tp-pedido) NO-ERROR.

              RUN pi-le-item-nota.

              IF NOT tg-itens:CHECKED IN FRAME {&FRAME-NAME} THEN DO: //Desmembrar itens
                 IF  AVAIL tt-notas THEN DO:                  
                     ASSIGN tt-notas.val-faturado = nota-fiscal.vl-tot-nota
                            tt-notas.qtd-volume   = int(nota-fiscal.nr-volumes) .
                           /* tt-notas.qtd-peso-bru = nota-fiscal.peso-bru-tot
                            tt-notas.qtd-peso-liq = nota-fiscal.peso-liq-tot. */
                
                     ASSIGN tt-notas.nome-emit     = emitente.nome-emit    
                            tt-notas.nat-operacao  = nota-fiscal.nat-operacao
                            tt-notas.cli-difer     = IF  AVAIL cli-difer THEN string(cli-difer.cod-emitente) ELSE ""
                            tt-notas.nome-transp   = nota-fiscal.nome-trans
                            tt-notas.estado        = nota-fiscal.estado
                            tt-notas.nm-oper       = IF  AVAIL atendente THEN atendente.nm-oper ELSE ""
                            tt-notas.dt-cancel     = nota-fiscal.dt-cancela
                            tt-notas.integrado-wms = CAN-FIND (FIRST integra-mft-wms-notas 
                                                               WHERE integra-mft-wms-notas.cod-estabel = tt-notas.cod-estabel 
                                                                 AND integra-mft-wms-notas.serie       = tt-notas.serie       
                                                                 AND integra-mft-wms-notas.nr-nota-fis = tt-notas.nr-nota-fis).
                
                     FOR EACH it-nota-fisc OF nota-fisca NO-LOCK:
                         FIND FIRST ITEM NO-LOCK
                              WHERE ITEM.it-codigo = it-nota-fisc.it-codigo NO-ERROR.
                         
                         IF AVAIL ITEM THEN DO:
                             FIND FIRST fat-ser-lote OF it-nota-fisc NO-ERROR.
                
                             IF ITEM.cod-unid-negoc = "ENS" AND AVAIL fat-ser-lote AND fat-ser-lote.cod-depos = "FAT" THEN DO:
                                 for each bf-volume-nf of nota-fiscal no-lock:
                                    FIND FIRST embalag NO-LOCK
                                         WHERE embalag.sigla-emb = bf-volume-nf.sigla-emb NO-ERROR.
                                    if avail embalag then 
                                       assign tt-notas.cubagem = tt-notas.cubagem + (embalag.volume) . 
                                 end. 
                             END.
                             ELSE
                                 ASSIGN tt-notas.cubagem = tt-notas.cubagem + ( ((item.altura / 1000) * (item.largura / 1000) * (item.comprim / 1000)) * it-nota-fisc.qt-faturada[1]).
                         END.
                     END.
                   
                     FOR EACH fat-ser-lote OF nota-fiscal NO-LOCK:
                         IF INDEX(tt-notas.cod-depos, fat-ser-lote.cod-depos) = 0 THEN DO:
                             IF tt-notas.cod-depos = "" THEN
                                ASSIGN tt-notas.cod-depos = fat-ser-lote.cod-depos.
                             ELSE
                                ASSIGN tt-notas.cod-depos = tt-notas.cod-depos + "," + fat-ser-lote.cod-depos.
                         END.
                     END.
                     ASSIGN i-vol-frac = 0
                            i-vol-padr = 0.
                
                     FOR EACH volume-nf NO-LOCK
                        WHERE volume-nf.cod-estabel = tt-notas.cod-estabel
                          AND volume-nf.serie       = tt-notas.serie
                          AND volume-nf.nr-nota-fis = tt-notas.nr-nota-fis
                        BREAK BY volume-nf.nr-volume:
                
                         IF LAST-OF(volume-nf.nr-volume) THEN DO:
                             IF volume-nf.varios-itens THEN
                                 ASSIGN i-vol-frac = i-vol-frac + 1.
                             ELSE 
                                 ASSIGN i-vol-padr = i-vol-padr + 1.
                         END.
                     END.
                      ASSIGN tt-notas.vol-frac = i-vol-frac
                            tt-notas.vol-padr = i-vol-padr.
                      
                      ASSIGN tt-notas.hr-embarque = IF l-avail THEN STRING(int-embarque.hora-embarque,"HH:MM") ELSE "".
                 END.
              END.
        END.
    END.
    ELSE DO:
        IF rs-filtro-data = 1
        THEN DO:
            DO v-dat-tmp = v-dat-nf-ini TO v-dat-nf-fim:
                bloco-nota:
                FOR EACH nota-fiscal NO-LOCK USE-INDEX ch-sit-nota
                   WHERE nota-fiscal.dt-emis-nota      = v-dat-tmp
                     AND nota-fiscal.idi-sit-nf-eletro = 3
                     AND nota-fiscal.dt-confirma      <> ?:
    
                    run pi-acompanhar in h-acomp (input "Emiss∆o: " + STRING(nota-fiscal.dt-emis-nota,"99/99/9999") + " - Nota: " + nota-fiscal.nr-nota-fis).
    
                    IF  nota-fiscal.cod-estabel < v-cod-estab-ini OR
                        nota-fiscal.cod-estabel > v-cod-estab-fim
                    THEN
                        NEXT bloco-nota.
    
                  //Filtra UF
                  IF  nota-fiscal.estado < fi-uf-ini OR
                      nota-fiscal.estado > fi-uf-fim
                  THEN
                      NEXT bloco-nota.
    
                   //Filtra Transportadora
                    RUN pi-valida-transp(INPUT nota-fiscal.nome-transp,
                                         OUTPUT c-retorno).
                    IF c-retorno = "N" THEN NEXT bloco-nota.
    
                    FIND emitente NO-LOCK
                        WHERE emitente.nome-abrev = nota-fiscal.nome-ab-cli NO-ERROR.
    
                    FIND FIRST cli-difer NO-LOCK 
                         WHERE cli-difer.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.
    
                    FIND ped-venda NO-LOCK
                        WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                          AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-ERROR.
    
                    IF  AVAIL ped-venda THEN 
                        FIND FIRST atendente NO-LOCK
                             WHERE atendente.cd-oper = int(ped-venda.tp-pedido) NO-ERROR.
    
                    RUN pi-le-item-nota.
    
                    IF NOT tg-itens:CHECKED IN FRAME {&FRAME-NAME} THEN DO: //Desmembrar itens
                       IF  AVAIL tt-notas
                       THEN DO:
                           ASSIGN tt-notas.val-faturado = nota-fiscal.vl-tot-nota
                                  tt-notas.qtd-volume   = int(nota-fiscal.nr-volumes)
                                  tt-notas.qtd-peso-bru = nota-fiscal.peso-bru-tot
                                  tt-notas.qtd-peso-liq = nota-fiscal.peso-liq-tot.
                     
                           ASSIGN tt-notas.nome-emit    = emitente.nome-emit    
                                  tt-notas.nat-operacao = nota-fiscal.nat-operacao
                                  tt-notas.cli-difer    = IF  AVAIL cli-difer THEN string(cli-difer.cod-emitente) ELSE ""
                                  tt-notas.nome-transp  = nota-fiscal.nome-trans
                                  tt-notas.estado       = nota-fiscal.estado
                                  tt-notas.nm-oper      = IF  AVAIL atendente THEN atendente.nm-oper ELSE ""
                                  tt-notas.dt-cancel    = nota-fiscal.dt-cancel
                                  tt-notas.integrado-wms = CAN-FIND (FIRST integra-mft-wms-notas 
                                                                     WHERE integra-mft-wms-notas.cod-estabel = tt-notas.cod-estabel 
                                                                       AND integra-mft-wms-notas.serie       = tt-notas.serie       
                                                                       AND integra-mft-wms-notas.nr-nota-fis = tt-notas.nr-nota-fis).
                     
                           FOR EACH it-nota-fisc OF nota-fisca NO-LOCK:
                               FIND FIRST ITEM NO-LOCK
                                    WHERE ITEM.it-codigo = it-nota-fisc.it-codigo NO-ERROR.
                           
                               IF AVAIL ITEM THEN DO:
                                   FIND FIRST fat-ser-lote OF it-nota-fisc NO-LOCK NO-ERROR.
                     
                                   IF ITEM.cod-unid-negoc = "ENS" AND AVAIL fat-ser-lote AND fat-ser-lote.cod-depos = "FAT" THEN DO: /*solar*/
                                      for each bf-volume-nf of nota-fiscal no-lock:
                                          FIND FIRST embalag NO-LOCK
                                               WHERE embalag.sigla-emb = bf-volume-nf.sigla-emb NO-ERROR.
                                          if avail embalag then 
                                             assign tt-notas.cubagem = tt-notas.cubagem + (embalag.volume) . 
                                       end. 
                                   END.
                                   ELSE DO:
                                      ASSIGN tt-notas.cubagem = tt-notas.cubagem + ( ((item.altura / 1000) * (item.largura / 1000) * (item.comprim / 1000)) * it-nota-fisc.qt-faturada[1]).
                                   END.
                               END.
                           END.                                                                                                                
                     
                           FOR EACH fat-ser-lote OF nota-fiscal NO-LOCK:
                               IF INDEX(tt-notas.cod-depos, fat-ser-lote.cod-depos) = 0 THEN DO:
                                   IF tt-notas.cod-depos = "" THEN
                                      ASSIGN tt-notas.cod-depos = fat-ser-lote.cod-depos.
                                   ELSE
                                      ASSIGN tt-notas.cod-depos = tt-notas.cod-depos + "," + fat-ser-lote.cod-depos.
                               END.
                           END.
                           ASSIGN i-vol-frac = 0
                                  i-vol-padr = 0.
                     
                           FOR EACH volume-nf NO-LOCK
                              WHERE volume-nf.cod-estabel = tt-notas.cod-estabel
                                AND volume-nf.serie       = tt-notas.serie
                                AND volume-nf.nr-nota-fis = tt-notas.nr-nota-fis
                              BREAK BY volume-nf.nr-volume:
                     
                               IF LAST-OF(volume-nf.nr-volume) THEN DO:
                                   IF volume-nf.varios-itens THEN
                                       ASSIGN i-vol-frac = i-vol-frac + 1.
                                   ELSE 
                                       ASSIGN i-vol-padr = i-vol-padr + 1.
                               END.
                           END.
                     
                           ASSIGN tt-notas.vol-frac = i-vol-frac
                                  tt-notas.vol-padr = i-vol-padr.
                     
                       END.
                    END.
                END.
            END.
        END.
        ELSE DO:
            DO v-dat-tmp = v-dat-emb-ini TO v-dat-emb-fim:
                bloco-nota:
                FOR EACH embarque WHERE
                         embarque.dt-embarque = v-dat-tmp
                         NO-LOCK,
                    EACH nota-fiscal WHERE
                         nota-fiscal.cdd-embarq = embarque.cdd-embarq
                         NO-LOCK.

                    RUN pi-ve-int-embarque(OUTPUT l-avail).

                    run pi-acompanhar in h-acomp (input "Emiss∆o: " + STRING(nota-fiscal.dt-emis-nota,"99/99/9999") + " - Nota: " + nota-fiscal.nr-nota-fis).
    
                    IF  nota-fiscal.cod-estabel < v-cod-estab-ini OR
                        nota-fiscal.cod-estabel > v-cod-estab-fim
                    THEN
                        NEXT bloco-nota.
    
                  //Filtra UF
                  IF  nota-fiscal.estado < fi-uf-ini OR
                      nota-fiscal.estado > fi-uf-fim
                  THEN
                      NEXT bloco-nota.
    
                  
                   //Filtra Transportadora
                    RUN pi-valida-transp(INPUT nota-fiscal.nome-transp,
                                         OUTPUT c-retorno).
                    IF c-retorno = "N" THEN NEXT bloco-nota.
    
                    FIND emitente NO-LOCK
                        WHERE emitente.nome-abrev = nota-fiscal.nome-ab-cli NO-ERROR.
    
                    FIND FIRST cli-difer NO-LOCK 
                        WHERE cli-difer.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.
    
                    FIND ped-venda NO-LOCK
                        WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                          AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-ERROR.
    
                    IF  AVAIL ped-venda THEN 
                        FIND FIRST atendente NO-LOCK
                            WHERE atendente.cd-oper = int(ped-venda.tp-pedido) NO-ERROR.
    
                    RUN pi-le-item-nota.
    
                    IF NOT tg-itens:CHECKED IN FRAME {&FRAME-NAME} THEN DO: //Desmembrar itens

                       IF  AVAIL tt-notas
                       THEN DO:
                           ASSIGN tt-notas.val-faturado = nota-fiscal.vl-tot-nota
                                  tt-notas.qtd-volume   = int(nota-fiscal.nr-volumes)
                                  tt-notas.qtd-peso-bru = nota-fiscal.peso-bru-tot
                                  tt-notas.qtd-peso-liq = nota-fiscal.peso-liq-tot.
                    
                           ASSIGN tt-notas.nome-emit    = emitente.nome-emit    
                                  tt-notas.nat-operacao = nota-fiscal.nat-operacao
                                  tt-notas.cli-difer    = IF  AVAIL cli-difer THEN string(cli-difer.cod-emitente) ELSE ""
                                  tt-notas.nome-transp  = nota-fiscal.nome-trans
                                  tt-notas.estado       = nota-fiscal.estado
                                  tt-notas.nm-oper      = IF  AVAIL atendente THEN atendente.nm-oper ELSE ""
                                  tt-notas.dt-cancel    = nota-fiscal.dt-cancel
                                  tt-notas.integrado-wms = CAN-FIND (FIRST integra-mft-wms-notas 
                                                                     WHERE integra-mft-wms-notas.cod-estabel = tt-notas.cod-estabel 
                                                                       AND integra-mft-wms-notas.serie       = tt-notas.serie       
                                                                       AND integra-mft-wms-notas.nr-nota-fis = tt-notas.nr-nota-fis).
                    
                           FOR EACH it-nota-fisc OF nota-fisca NO-LOCK:
                               FIND FIRST ITEM NO-LOCK
                                    WHERE ITEM.it-codigo = it-nota-fisc.it-codigo NO-ERROR.
                           
                               IF AVAIL ITEM THEN DO:
                    
                                   FIND FIRST fat-ser-lote OF it-nota-fisc NO-LOCK NO-ERROR.
                    
                                   IF ITEM.cod-unid-negoc = "ENS" AND AVAIL fat-ser-lote AND fat-ser-lote.cod-depos = "FAT" THEN DO: /*solar*/
                                      for each bf-volume-nf of nota-fiscal no-lock:
                                          FIND FIRST embalag NO-LOCK
                                               WHERE embalag.sigla-emb = bf-volume-nf.sigla-emb NO-ERROR.
                                          if avail embalag then 
                                             assign tt-notas.cubagem = tt-notas.cubagem + (embalag.volume) . 
                                       end. 
                                   END.
                                   ELSE DO:
                                       ASSIGN tt-notas.cubagem = tt-notas.cubagem + ( ((item.altura / 1000) * (item.largura / 1000) * (item.comprim / 1000)) * it-nota-fisc.qt-faturada[1]).
                                   END.
                               END.
                           END.                                                                                                                
                    
                           FOR EACH fat-ser-lote OF nota-fiscal NO-LOCK:
                               IF INDEX(tt-notas.cod-depos, fat-ser-lote.cod-depos) = 0 THEN DO:
                                   IF tt-notas.cod-depos = "" THEN
                                      ASSIGN tt-notas.cod-depos = fat-ser-lote.cod-depos.
                                   ELSE
                                      ASSIGN tt-notas.cod-depos = tt-notas.cod-depos + "," + fat-ser-lote.cod-depos.
                               END.
                           END.
                           ASSIGN i-vol-frac = 0
                                  i-vol-padr = 0.
                    
                           FOR EACH volume-nf NO-LOCK
                              WHERE volume-nf.cod-estabel = tt-notas.cod-estabel
                                AND volume-nf.serie       = tt-notas.serie
                                AND volume-nf.nr-nota-fis = tt-notas.nr-nota-fis
                              BREAK BY volume-nf.nr-volume:
                    
                               IF LAST-OF(volume-nf.nr-volume) THEN DO:
                                   IF volume-nf.varios-itens THEN
                                       ASSIGN i-vol-frac = i-vol-frac + 1.
                                   ELSE 
                                       ASSIGN i-vol-padr = i-vol-padr + 1.
                               END.
                           END.
                    
                           ASSIGN tt-notas.vol-frac = i-vol-frac
                                  tt-notas.vol-padr = i-vol-padr.
                    
                           ASSIGN tt-notas.hr-embarque = IF l-avail THEN string(int-embarque.hora-embarque,"HH:MM") ELSE "".
                       END.
                    END. //not tg-itens
                    ELSE DO:

                    END.
                END.
            END.
        END.
    END.

    run pi-acompanhar in h-acomp (input "Apresentando dados...").

    IF tg-itens:CHECKED THEN DO:
        {&OPEN-QUERY-br-itens-nota}
    END.
    ELSE DO:
        {&OPEN-QUERY-br-notas}
    END.

    //{&OPEN-QUERY-br-notas}

    RUN pi-finalizar IN h-acomp.
    ASSIGN h-acomp = ?.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-relat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-relat wWindow
ON CHOOSE OF bt-relat IN FRAME fpage0 /* Relatorio CSV */
DO:
  DEFINE VAR c-dir-saida AS CHAR.

  IF NOT AVAIL tt-notas THEN
      APPLY "choose" TO bt-fil.

  IF  NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

  RUN pi-inicializar IN h-acomp (INPUT "Buscando dados...").

  ASSIGN c-dir-saida = '\\erpapp\spool\'+ c-seg-usuario + '\' + 'esftp091.csv'.


  OUTPUT TO VALUE (c-dir-saida). //+ '\' + '.csv'.
  PUT UNFORMATTED "Est;Ser;Nota;Raz∆o Social;Nat. Oper;Emiss∆o;Sa°da;Dias;Cliente Diferenciado;Transportadora;Estado;Atendente;Cancelamento;Devoluá∆o;Embarque;Qtde;R$ Faturado;Volumes;Q.Padr;Q.Frac;Peso Liq;Peso Bruto;Cubagem;Depositos;WMS;Hr Embarq;Qtd Itens NF" SKIP.


  FOR EACH tt-notas
        BY tt-notas.nr-embarque:

      run pi-acompanhar in h-acomp (input "Gerando relatorio: " + STRING(tt-notas.nr-embarq) + " - Nota: " + tt-notas.nr-nota-fis).

      PUT UNFORMATTED tt-notas.cod-estabel                      ";"
                      tt-notas.serie                            ";"
                      tt-notas.nr-nota-fis                      ";"
                      tt-notas.nome-emit                        ";"
                      tt-notas.nat-operacao                     ";"
                      tt-notas.dt-emis-nota                     ";"
                      tt-notas.dt-saida                         ";"
                      tt-notas.dt-saida - tt-notas.dt-emis-nota ";"     
                      tt-notas.cli-difer                        ";"
                      tt-notas.nome-transp                      ";"
                      tt-notas.estado                           ";"
                      tt-notas.nm-oper                          ";"
                      tt-notas.dt-cancel                        ";"
                      tt-notas.dt-devol                         ";"
                      tt-notas.nr-embarque                      ";"
                      tt-notas.qtd-faturada                     ";"
                      tt-notas.val-faturado                     ";"
                      tt-notas.qtd-volume                       ";"
                      tt-notas.vol-padr                         ";"
                      tt-notas.vol-frac                         ";"
                      tt-notas.qtd-peso-liq                     ";"
                      tt-notas.qtd-peso-bru                     ";"
                      tt-notas.cubagem                          ";"
                      tt-notas.cod-depos                        ";"
                      tt-notas.integrado-wms                    ";"
                      tt-notas.hr-embarque                      ";" 
                      tt-notas.qtd-items-nf                     SKIP.

  END.

  OUTPUT CLOSE.


 RUN pi-finalizar IN h-acomp.
    ASSIGN h-acomp = ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Sair */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-filtro-data
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-filtro-data wWindow
ON VALUE-CHANGED OF rs-filtro-data IN FRAME fpage0
DO:
  IF INPUT FRAME {&FRAME-NAME} rs-filtro-data = 1 
  THEN DO:
      ASSIGN v-dat-emb-ini:SENSITIVE IN FRAME {&FRAME-NAME} = NO
             v-dat-emb-fim:SENSITIVE IN FRAME {&FRAME-NAME} = NO
             v-dat-nf-ini:SENSITIVE IN FRAME {&FRAME-NAME}  = YES
             v-dat-nf-fim:SENSITIVE IN FRAME {&FRAME-NAME}  = YES.
  END.
  ELSE DO:
      ASSIGN v-dat-nf-ini:SENSITIVE IN FRAME {&FRAME-NAME}  = NO
             v-dat-nf-fim:SENSITIVE IN FRAME {&FRAME-NAME}  = NO
             v-dat-emb-ini:SENSITIVE IN FRAME {&FRAME-NAME} = YES
             v-dat-emb-fim:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-itens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-itens wWindow
ON VALUE-CHANGED OF tg-itens IN FRAME fpage0 /* Listar Itens Nota */
DO:
  IF tg-itens:CHECKED IN FRAME {&FRAME-NAME} THEN
      ASSIGN v-unid-negoc:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
  ELSE DO:
      ASSIGN v-unid-negoc:SENSITIVE IN FRAME {&FRAME-NAME} = NO
             v-unid-negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-itens-nota
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/

ASSIGN v-dat-nf-ini  = DATE("01/" + STRING(MONTH(TODAY)) + "/" + STRING(YEAR(TODAY)))
       v-dat-nf-fim  = TODAY
       v-dat-emb-ini = DATE("01/" + STRING(MONTH(TODAY)) + "/" + STRING(YEAR(TODAY)))
       v-dat-emb-fim = TODAY.

//APPLY "Value-changed"  TO v-cod-estab-ini IN FRAME fpage0.

ASSIGN v-dat-emb-ini:SENSITIVE IN FRAME {&FRAME-NAME} = NO
       v-dat-emb-fim:SENSITIVE IN FRAME {&FRAME-NAME} = NO
       v-dat-nf-ini:SENSITIVE IN FRAME {&FRAME-NAME}  = YES
       v-dat-nf-fim:SENSITIVE IN FRAME {&FRAME-NAME}  = YES.

ASSIGN v-dat-emb-ini:SENSITIVE  = NO
       v-dat-emb-fim:SENSITIVE  = NO
       v-dat-nf-ini:SENSITIVE   = YES
       v-dat-nf-fim:SENSITIVE   = YES.

{window/mainblock.i}

ASSIGN v-unid-negoc:SENSITIVE IN FRAME {&FRAME-NAME}  = NO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-transportadora wWindow 
PROCEDURE pi-busca-transportadora :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH transporte NO-LOCK:
   CREATE tt-transportadora.
   ASSIGN tt-transportadora.cod-transp = transporte.cod-transp
          tt-transportadora.nome-trans = transporte.nome-abrev.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-le-item-nota wWindow 
PROCEDURE pi-le-item-nota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR nf      AS INT NO-UNDO.
    ASSIGN v-log-item-ok = YES
           nf            = 0.
    bloco-volume:
    FOR EACH it-nota-fisc NO-LOCK
       WHERE it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel
         AND it-nota-fisc.serie       = nota-fiscal.serie
         AND it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis
       BREAK BY it-nota-fisc.cod-estabel
             BY it-nota-fisc.serie      
             BY it-nota-fisc.nr-nota-fis
             BY it-nota-fisc.it-codigo:

            ASSIGN nf = nf + 1.
            
        IF  rs-tipo-volume     <> 3 OR
            rs-rastreabilidade <> 3

        THEN DO:
            IF  FIRST-OF(it-nota-fisc.it-codigo)
            THEN DO:
                FIND FIRST item-caixa NO-LOCK
                     WHERE item-caixa.it-codigo  = it-nota-fisc.it-codigo
                       AND item-caixa.fm-codigo  = ?
                       AND item-caixa.fm-cod-com = ?
                       AND item-caixa.sigla-emb  >= "N" NO-ERROR.
                IF NOT AVAILABLE item-caixa THEN
                    FIND FIRST item-caixa NO-LOCK
                         WHERE item-caixa.it-codigo  = it-nota-fisc.it-codigo
                           AND item-caixa.fm-codigo  = ?
                           AND item-caixa.fm-cod-com = ?
                           AND item-caixa.sigla-emb BEGINS "E":U NO-ERROR.
    
                IF AVAILABLE item-caixa AND
                             item-caixa.qt-item >= 1
                THEN DO:
                    IF  rs-tipo-volume                                         = 1 AND
                        it-nota-fisc.qt-faturada[1] MODULO item-caixa.qt-item  = 0
                    THEN 
                        ASSIGN v-log-item-ok = NO.

                    IF  rs-tipo-volume                                         = 2 AND
                        it-nota-fisc.qt-faturada[1] MODULO item-caixa.qt-item <> 0 AND
                        it-nota-fisc.qt-faturada[1]                            < item-caixa.qt-item
                    THEN 
                        ASSIGN v-log-item-ok = NO.
                END.
    
                IF  rs-tipo-volume = 2 AND
                    NOT AVAIL item-caixa
                THEN 
                    ASSIGN v-log-item-ok = NO.
    
    
                IF rs-rastreabilidade = 1 
                THEN DO:
                    FIND FIRST tt-item-rast NO-LOCK
                        WHERE  tt-item-rast.it-codigo = it-nota-fisc.it-codigo NO-ERROR.
        
                    IF NOT AVAILABLE tt-item-rast 
                    THEN
                        ASSIGN v-log-item-ok = NO.
                END.
                ELSE DO:
                    IF rs-rastreabilidade = 2 
                    THEN DO:
                        FIND FIRST tt-item-rast NO-LOCK
                            WHERE  tt-item-rast.it-codigo = it-nota-fisc.it-codigo NO-ERROR.
            
                        IF AVAILABLE tt-item-rast 
                        THEN
                            ASSIGN v-log-item-ok = NO.
                    END.
                END. /* ELSE IF rs-rastreabilidade = 1 */
            END. /* IF  FIRST-OF(it-nota-fisc.it-codigo) */
        END. /* IF  rs-tipo-volume     <> 3 OR */

        IF  v-log-item-ok = YES THEN DO:

            IF tg-itens:CHECKED IN FRAME {&FRAME-NAME} THEN DO: //Desmembrar itens

                IF v-unid-negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" THEN
                    IF it-nota-fisc.cod-unid-negoc <> v-unid-negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} THEN NEXT.

                FIND FIRST tt-itens-nota 
                     WHERE tt-itens-nota.cod-estabel = nota-fiscal.cod-estabel
                       AND tt-itens-nota.serie       = nota-fiscal.serie
                       AND tt-itens-nota.nr-nota-fis = nota-fiscal.nr-nota-fis
                       AND tt-itens-nota.it-codigo   = it-nota-fisc.it-codigo NO-ERROR.
               IF  NOT AVAIL tt-itens-nota THEN DO:
                   FIND FIRST devol-cli NO-LOCK
                        WHERE devol-cli.cod-estabel  = nota-fiscal.cod-estabel   
                          AND devol-cli.serie        = nota-fiscal.serie         
                          AND devol-cli.nr-nota-fis  = nota-fiscal.nr-nota-fis
                          AND devol-cli.it-codigo    = it-nota-fisc.it-codigo NO-ERROR.
               
                   CREATE tt-itens-nota.
                   ASSIGN tt-itens-nota.cod-estabel    = nota-fiscal.cod-estabel 
                          tt-itens-nota.serie          = nota-fiscal.serie       
                          tt-itens-nota.nr-nota-fis    = nota-fiscal.nr-nota-fis 
                          tt-itens-nota.it-codigo      = it-nota-fisc.it-codigo
                          tt-itens-nota.dt-emis-nota   = nota-fiscal.dt-emis-nota
                          tt-itens-nota.dt-saida       = nota-fiscal.dt-saida
                          tt-itens-nota.nr-embarque    = nota-fiscal.cdd-embarq
                          tt-itens-nota.cod-unid-negoc = it-nota-fisc.cod-unid-negoc
                          tt-itens-nota.nome-emit      = emitente.nome-emit    
                          tt-itens-nota.nat-operacao   = nota-fiscal.nat-operacao
                          tt-itens-nota.qtd-peso-bru   = it-nota-fisc.peso-bruto
                          tt-itens-nota.qtd-peso-liq   = it-nota-fisc.peso-liq
                          tt-itens-nota.cli-difer      = IF  AVAIL cli-difer THEN string(cli-difer.cod-emitente) ELSE ""
                          tt-itens-nota.nome-transp    = nota-fiscal.nome-trans
                          tt-itens-nota.estado         = nota-fiscal.estado
                          tt-itens-nota.nm-oper        = IF  AVAIL atendente THEN atendente.nm-oper ELSE ""
                          tt-itens-nota.dt-cancel      = nota-fiscal.dt-cancela
                          tt-itens-nota.hr-embarque    = IF l-avail THEN STRING(int-embarque.hora-embarque,"HH:MM") ELSE ""
                          tt-itens-nota.integrado-wms  = CAN-FIND (FIRST integra-mft-wms-notas 
                                                                   WHERE integra-mft-wms-notas.cod-estabel = tt-itens-nota.cod-estabel 
                                                                     AND integra-mft-wms-notas.serie       = tt-itens-nota.serie       
                                                                     AND integra-mft-wms-notas.nr-nota-fis = tt-itens-nota.nr-nota-fis).
                    FIND FIRST ITEM NO-LOCK
                         WHERE ITEM.it-codigo = it-nota-fisc.it-codigo NO-ERROR.
                    
                    IF AVAIL ITEM THEN DO:
                        FIND FIRST fat-ser-lote OF it-nota-fisc NO-ERROR.
                
                        IF ITEM.cod-unid-negoc = "ENS" AND AVAIL fat-ser-lote AND fat-ser-lote.cod-depos = "FAT" THEN DO:
                            for each bf-volume-nf of nota-fiscal no-lock:
                               FIND FIRST embalag NO-LOCK
                                    WHERE embalag.sigla-emb = bf-volume-nf.sigla-emb NO-ERROR.
                               if avail embalag then 
                                  assign tt-itens-nota.cubagem = tt-itens-nota.cubagem + (embalag.volume) . 
                            end. 
                        END.
                        ELSE DO:
                            ASSIGN tt-itens-nota.cubagem = tt-itens-nota.cubagem + ( ((item.altura / 1000) * (item.largura / 1000) * (item.comprim / 1000)) * it-nota-fisc.qt-faturada[1]).
                        END.
                        IF AVAIL fat-ser-lote THEN
                           ASSIGN tt-itens-nota.cod-depos = fat-ser-lote.cod-depos.
                        ELSE
                           ASSIGN tt-itens-nota.cod-depos = "".
                    END.

                   IF  AVAIL devol-cli THEN
                       ASSIGN tt-itens-nota.dt-devol     = devol-cli.dt-devol.

                   FOR EACH volume-nf NO-LOCK
                      WHERE volume-nf.cod-estabel = tt-itens-nota.cod-estabel
                        AND volume-nf.serie       = tt-itens-nota.serie
                        AND volume-nf.nr-nota-fis = tt-itens-nota.nr-nota-fis
                        AND volume-nf.it-codigo   = tt-itens-nota.it-codigo
                      BREAK BY volume-nf.it-codigo:
                        IF volume-nf.varios-itens THEN
                            ASSIGN tt-itens-nota.vol-frac = tt-itens-nota.vol-frac + 1.
                        ELSE 
                            ASSIGN tt-itens-nota.vol-padr = tt-itens-nota.vol-padr + 1.

                        ASSIGN tt-itens-nota.qtd-volume   = tt-itens-nota.qtd-volume + 1.
                   END.
               
               END. /* IF  NOT AVAIL tt-notas */
               ASSIGN tt-itens-nota.qtd-faturada = tt-itens-nota.qtd-faturada + it-nota-fisc.qt-faturada[1]
                      tt-itens-nota.qtd-items-nf = tt-itens-nota.qtd-items-nf + 1
                      tt-itens-nota.val-faturado = tt-itens-nota.val-faturado + (it-nota-fisc.qt-faturada[1] * it-nota-fisc.vl-preuni).  
               
              /*  ASSIGN tt-itens-nota.vol-frac = i-vol-frac
                      tt-itens-nota.vol-padr = i-vol-padr. */
            END.
            ELSE DO: //Sem desmembrar notas
               FIND FIRST tt-notas 
                    WHERE tt-notas.cod-estabel = nota-fiscal.cod-estabel
                      AND tt-notas.serie       = nota-fiscal.serie
                      AND tt-notas.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.
               IF  NOT AVAIL tt-notas THEN DO:
                   FIND FIRST devol-cli NO-LOCK
                        WHERE devol-cli.cod-estabel  = nota-fiscal.cod-estabel   
                          AND devol-cli.serie       = nota-fiscal.serie         
                          AND devol-cli.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.
               
                   CREATE tt-notas.
                   ASSIGN tt-notas.cod-estabel  = nota-fiscal.cod-estabel 
                          tt-notas.serie        = nota-fiscal.serie       
                          tt-notas.nr-nota-fis  = nota-fiscal.nr-nota-fis 
                          tt-notas.dt-emis-nota = nota-fiscal.dt-emis-nota
                          tt-notas.dt-saida     = nota-fiscal.dt-saida
                          tt-notas.nr-embarque  = nota-fiscal.cdd-embarq
                          tt-notas.qtd-peso-bru = nota-fiscal.peso-bru-tot
                          tt-notas.qtd-peso-liq = nota-fiscal.peso-liq-tot.
                   IF  AVAIL devol-cli THEN
                       ASSIGN tt-notas.dt-devol     = devol-cli.dt-devol.
               
               END. /* IF  NOT AVAIL tt-notas */
               ASSIGN tt-notas.qtd-faturada = tt-notas.qtd-faturada + it-nota-fisc.qt-faturada[1].    
            END.
        END.
        ELSE DO:
            IF NOT tg-itens:CHECKED IN FRAME {&FRAME-NAME} THEN
               RELEASE tt-notas. /* IF  v-log-item-ok = YES */
        END.
    END. /* FOR EACH  it-nota-fisc NO-LOCK */
    
    IF NOT tg-itens:CHECKED IN FRAME {&FRAME-NAME} THEN DO: //Desmembrar itens
       ASSIGN tt-notas.qtd-items-nf = tt-notas.qtd-items-nf + nf.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-rast wWindow 
PROCEDURE pi-rast :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH item-rast NO-LOCK
   WHERE item-rast.data-ini < TODAY
     AND item-rast.data-fim > TODAY:

    run pi-acompanhar in h-acomp (input "Itens Rastreabilidade: " + STRING(item-rast.it-codigo)).

    CREATE tt-item-rast.
    ASSIGN tt-item-rast.it-codigo = item-rast.it-codigo.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-transp wWindow 
PROCEDURE pi-valida-transp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAM pTransp  AS CHAR NO-UNDO.
DEFINE OUTPUT PARAM pRetorno AS CHAR NO-UNDO.

FIND FIRST tt-transportadora 
     WHERE tt-transportadora.nome-trans = pTransp NO-ERROR.
IF AVAIL tt-transportadora THEN DO:
    IF tt-transportadora.cod-transp < fi-cod-transp-ini OR
       tt-transportadora.cod-transp > fi-cod-transp-fim THEN 
        ASSIGN pRetorno = "N".
    ELSE
        ASSIGN pRetorno = "S".
END.
ELSE
    ASSIGN pRetorno = "N".

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ve-int-embarque wWindow 
PROCEDURE pi-ve-int-embarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAM pAvail AS LOG NO-UNDO.

FIND FIRST int-embarque OF embarque NO-LOCK NO-ERROR.
IF AVAIL int-embarque THEN
    ASSIGN pAvail = YES.
ELSE
    ASSIGN pAvail = NO.

RETURN "OK" .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

