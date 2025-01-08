&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
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
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF TEMP-TABLE tt_item NO-UNDO /*LIKE item*/
    FIELD it-codigo        LIKE item.it-codigo                                          
    FIELD desc-item        LIKE item.desc-item                                          
    FIELD desc-inter       LIKE item.desc-inter                                         
    FIELD fm-codigo        LIKE item.fm-codigo                                          
    FIELD peso-liquido     LIKE item.peso-liquido                                       
    FIELD peso-bruto       LIKE item.peso-bruto                                         
    FIELD comprim          LIKE item.comprim                                            
    FIELD largura          LIKE item.largura                                            
    FIELD altura           LIKE item.altura                                             
    FIELD cod-estabel      LIKE item.cod-estabel                                        
    FIELD cod-unid-negoc   LIKE item.cod-unid-negoc                                     
    FIELD un               LIKE item.un                                                 
    FIELD fm-cod-com       LIKE item.fm-cod-com                                         
    FIELD class-fiscal     LIKE item.class-fiscal                                       
    FIELD log-necessita-li LIKE item.log-necessita-li                                   
    FIELD narrativa        AS CHAR
    FIELD codigo-orig      LIKE item.codigo-orig                                        
    FIELD ind-item-fat     LIKE item.ind-item-fat                                       
    FIELD situacao         AS CHAR FORMAT "x(20)"
    FIELD nve              AS CHAR FORMAT "x(200)"
    FIELD ex-tarifario     LIKE int-item.ex-tarifario
    FIELD part-number      LIKE item-fabric.it-fabric
    FIELD fabricante       LIKE fabricante.nome-abrev
    FIELD cod-ean13        LIKE item-mat.cod-ean
    FIELD destaque         LIKE int-item.destaque
    FIELD ex-ipi           LIKE int-item.exipi
    FIELD antidumping      LIKE int-item.log-antidumping
    FIELD log-gatt         LIKE int-item.log-gatt
    FIELD perc-gatt        LIKE int-item.perc-gatt
    FIELD seq-suframa      LIKE int-item.seq-suframa
    FIELD aliq-ii          AS DEC
    FIELD aliquota-ipi     AS DEC
    FIELD tipo-contr       LIKE item.tipo-contr
    FIELD criticidade      LIKE item.criticidade
    FIELD char-2           LIKE item.char-2
    FIELD ge-codigo        LIKE item.ge-codigo
    FIELD nr-projeto       LIKE item-proj-suframa.nr-projeto
    FIELD controlado       LIKE item-proj-suframa.controlado.

DEF VAR h-cdapi995         AS HANDLE                         NO-UNDO.
DEF VAR de-ali-cofins      AS DEC FORMAT ">9.9999":U INIT 0  NO-UNDO.
DEF VAR de-ali-pis         AS DEC FORMAT ">9.9999":U INIT 0  NO-UNDO.
DEF VAR c-tipo-contrato    AS CHAR                           NO-UNDO.
DEF VAR c-arq-excel        AS CHAR                           NO-UNDO.
DEF VAR h-acomp            AS HANDLE                         NO-UNDO.
DEF VAR l-confirma         AS LOG                            NO-UNDO.
DEF VAR v_contr_qualid     AS LOG FORMAT "Sim/NÆo"           NO-UNDO.
DEF VAR v_cest             AS INT                            NO-UNDO.
DEF VAR v_nve              AS CHAR FORMAT "x(200)"           NO-UNDO.
DEF VAR v_narrativa        AS CHAR                           NO-UNDO.
DEF VAR v_pis_majorado     AS CHAR                           NO-UNDO.
DEF VAR v_cofins_majorado  AS CHAR                           NO-UNDO.
DEF VAR v_observacao       AS CHAR                           NO-UNDO.
DEF VAR v_acond            AS CHAR                           NO-UNDO.
DEF VAR v_homologacao      AS CHAR                           NO-UNDO.
DEF VAR v_aux1             AS CHAR                           NO-UNDO.
DEF VAR v_aux2             AS CHAR                           NO-UNDO.
DEF VAR v_venc_homolog     AS CHAR                           NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren
    AS CHARACTER
    FORMAT "x(12)"
    LABEL "Usuÿrio Corrente"
    COLUMN-LABEL "Usuÿrio Corrente"
    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME br_itens

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt_item

/* Definitions for BROWSE br_itens                                      */
&Scoped-define FIELDS-IN-QUERY-br_itens tt_item.it-codigo tt_item.desc-item tt_item.situacao tt_item.fm-codigo tt_item.fm-cod-com tt_item.class-fiscal tt_item.nve tt_item.ex-tarifario tt_item.aliquota-ipi tt_item.part-number tt_item.fabricante tt_item.nr-projeto tt_item.controlado tt_item.log-necessita-li tt_item.cod-ean13   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_itens   
&Scoped-define SELF-NAME br_itens
&Scoped-define QUERY-STRING-br_itens FOR EACH tt_item
&Scoped-define OPEN-QUERY-br_itens OPEN QUERY {&SELF-NAME} FOR EACH tt_item.
&Scoped-define TABLES-IN-QUERY-br_itens tt_item
&Scoped-define FIRST-TABLE-IN-QUERY-br_itens tt_item


/* Definitions for FRAME fResult                                        */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-164 bt_carrega bt_excel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE ed_narrat_item AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 134 BY 2.25 NO-UNDO.

DEFINE VARIABLE ed_narrat_manaus AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 134 BY 2.25 NO-UNDO.

DEFINE VARIABLE ed_observacao AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 134 BY 1.5 NO-UNDO.

DEFINE VARIABLE fi-acond AS CHARACTER FORMAT "X(256)":U 
     LABEL "Acond" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE fi-aliq-ii AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     LABEL "Aliq II" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-aliq-ipi AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     LABEL "Aliq IPI" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-altura AS CHARACTER FORMAT "X(256)":U 
     LABEL "Altura" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 TOOLTIP "Em mm" NO-UNDO.

DEFINE VARIABLE fi-cest AS CHARACTER FORMAT "X(256)":U 
     LABEL "CEST" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cofins AS CHARACTER FORMAT "X(256)":U 
     LABEL "COFINS" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-comprimento AS CHARACTER FORMAT "X(256)":U 
     LABEL "Comprimento" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 TOOLTIP "Em mm" NO-UNDO.

DEFINE VARIABLE fi-criticidade AS CHARACTER FORMAT "X(256)":U 
     LABEL "Criticidade" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-ingles AS CHARACTER FORMAT "X(36)":U 
     LABEL "Desc Inglˆs" 
     VIEW-AS FILL-IN 
     SIZE 37 BY .88 NO-UNDO.

DEFINE VARIABLE fi-destaque AS CHARACTER FORMAT "X(256)":U 
     LABEL "Destaque" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estab AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ex-ii AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     LABEL "EX-II" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ex-ipi AS CHARACTER FORMAT "X(256)":U 
     LABEL "EX-IPI" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ext-pis AS CHARACTER FORMAT "X(256)":U 
     LABEL "PIS Ext" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-gr-estoque AS CHARACTER FORMAT "X(256)":U 
     LABEL "Grupo Estoque" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE fi-homolog AS CHARACTER FORMAT "X(60)":U 
     LABEL "Homologa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE fi-largura AS CHARACTER FORMAT "X(256)":U 
     LABEL "Largura" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 TOOLTIP "Em mm" NO-UNDO.

DEFINE VARIABLE fi-nqa AS DECIMAL FORMAT ">>>>9.99":U INITIAL 0 
     LABEL "NQA" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-origem AS CHARACTER FORMAT "X(256)":U 
     LABEL "Origem" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-perc-gatt AS DECIMAL FORMAT ">>>>9.99":U INITIAL 0 
     LABEL "% GATT" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-peso-bruto AS DECIMAL FORMAT ">>,>>9.99999":U INITIAL 0 
     LABEL "Peso Bruto" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 TOOLTIP "Em Kg" NO-UNDO.

DEFINE VARIABLE fi-peso-liq AS DECIMAL FORMAT ">>,>>9.99999":U INITIAL 0 
     LABEL "Peso Liq" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 TOOLTIP "Em Kg" NO-UNDO.

DEFINE VARIABLE fi-pis AS CHARACTER FORMAT "X(256)":U 
     LABEL "PIS" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-seq-suframa AS CHARACTER FORMAT "X(8)":U 
     LABEL "Seq Suframa" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tipo-contr AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo Controle" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-unid-medida AS CHARACTER FORMAT "X(256)":U 
     LABEL "Unid Medida" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE fi-unid-negoc AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unid Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-venc-homolog AS DATE FORMAT "99/99/9999":U 
     LABEL "Venc Homolog" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE RECTANGLE RECT-165
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 15 BY 8.5.

DEFINE RECTANGLE RECT-166
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 134 BY 8.5.

DEFINE VARIABLE tg-antidumping AS LOGICAL INITIAL no 
     LABEL "Antidumping" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .88 NO-UNDO.

DEFINE VARIABLE tg-faturavel AS LOGICAL INITIAL no 
     LABEL "Fatur vel" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .88 NO-UNDO.

DEFINE VARIABLE tg-gatt AS LOGICAL INITIAL no 
     LABEL "GATT" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .88 NO-UNDO.

DEFINE VARIABLE tg-qualidade AS LOGICAL INITIAL no 
     LABEL "Controle Qualidade" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi_fim AS CHARACTER FORMAT "X(256)":U 
     LABEL "At‚" 
     VIEW-AS FILL-IN 
     SIZE 24 BY .79 NO-UNDO.

DEFINE VARIABLE fi_ini AS CHARACTER FORMAT "X(256)":U 
     LABEL "De" 
     VIEW-AS FILL-IN 
     SIZE 24 BY .79 NO-UNDO.

DEFINE VARIABLE cb_filtro AS CHARACTER FORMAT "X(256)":U INITIAL "C¢digo" 
     LABEL "Filtro" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "C¢digo","Descri‡Æo","Fam¡lia","Fam¡lia Comercial","NCM","IPI","NVE","Ex. Tarif rio","Part Number","Fabricante","C¢digo EAN-13","Homologa‡Æo" 
     DROP-DOWN-LIST
     SIZE 21 BY 1
     FONT 1 NO-UNDO.

DEFINE VARIABLE tg-ativos AS LOGICAL INITIAL yes 
     LABEL "Ativos" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .88 NO-UNDO.

DEFINE VARIABLE tg-obso-automatic AS LOGICAL INITIAL no 
     LABEL "Obsoleto Ordens Autom ticas" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .88 TOOLTIP "Obsoleto Ordens Autom ticas" NO-UNDO.

DEFINE VARIABLE tg-obso-ordem AS LOGICAL INITIAL no 
     LABEL "Obsoleto Todas Ordens" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .88 TOOLTIP "Obsoleto Todas Ordens" NO-UNDO.

DEFINE VARIABLE tg-todos AS LOGICAL INITIAL no 
     LABEL "Todos" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .88 TOOLTIP "Todos" NO-UNDO.

DEFINE VARIABLE tg-tot-obsoleto AS LOGICAL INITIAL no 
     LABEL "Totalmente Obsoletos" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .88 TOOLTIP "Totalmente Obsoletos" NO-UNDO.

DEFINE BUTTON bt_carrega 
     IMAGE-UP FILE "IMAGE/im-ok.bmp":U
     LABEL "Carregar Itens" 
     SIZE 4.43 BY 1.13 TOOLTIP "Carregar Itens".

DEFINE BUTTON bt_excel 
     IMAGE-UP FILE "IMAGE/im-exel.bmp":U
     LABEL "Exportar para Excel" 
     SIZE 4.57 BY 1.13 TOOLTIP "Gera relat¢rio Excel (CSV)".

DEFINE RECTANGLE RECT-164
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 10 BY 4.25.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_itens FOR 
      tt_item SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_itens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_itens wWindow _FREEFORM
  QUERY br_itens DISPLAY
      tt_item.it-codigo        COLUMN-LABEL "Item"    FORMAT "x(10)"
    tt_item.desc-item        COLUMN-LABEL "Descri‡Æo"
    tt_item.situacao         COLUMN-LABEL "Situa‡Æo"  FORMAT "x(10)"
    tt_item.fm-codigo        COLUMN-LABEL "Fam¡lia"
    tt_item.fm-cod-com       COLUMN-LABEL "Fm.Comercial"
    tt_item.class-fiscal     COLUMN-LABEL "NCM" FORMAT "9999.99.99"
    tt_item.nve              COLUMN-LABEL "NVE" WIDTH 20
    tt_item.ex-tarifario     COLUMN-LABEL "Ex.Tarif rio II"
    tt_item.aliquota-ipi     COLUMN-LABEL "IPI"
    tt_item.part-number      COLUMN-LABEL "Part-Number" FORMAT "x(36)"
    tt_item.fabricante       COLUMN-LABEL "Fabricante"  FORMAT "x(20)"
    tt_item.nr-projeto       COLUMN-LABEL "Nr Projeto" /* FORMAT "x(20)"*/
    tt_item.controlado       COLUMN-LABEL "Controlado"
    tt_item.log-necessita-li COLUMN-LABEL "Necessita LI"
    tt_item.cod-ean13        COLUMN-LABEL "EAN-13"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 135 BY 5.25
         FONT 1 ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     bt_carrega AT ROW 2 COL 131 WIDGET-ID 28
     bt_excel AT ROW 3.75 COL 131 WIDGET-ID 30
     RECT-164 AT ROW 1.25 COL 128 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 137.57 BY 29.67
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fFaixas
     fi_ini AT ROW 2.25 COL 6 COLON-ALIGNED WIDGET-ID 20
     fi_fim AT ROW 2.25 COL 34 COLON-ALIGNED WIDGET-ID 22
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 65 ROW 1.25
         SIZE 62 BY 4.25
         FONT 1
         TITLE "Faixas de Sele‡Æo" WIDGET-ID 600.

DEFINE FRAME fFiltro
     cb_filtro AT ROW 1.25 COL 6 WIDGET-ID 4
     tg-ativos AT ROW 1.25 COL 37 WIDGET-ID 6
     tg-tot-obsoleto AT ROW 2.25 COL 10 WIDGET-ID 8
     tg-obso-ordem AT ROW 2.25 COL 37 WIDGET-ID 12
     tg-obso-automatic AT ROW 3.25 COL 10 WIDGET-ID 10
     tg-todos AT ROW 3.25 COL 37 WIDGET-ID 14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 1.25
         SIZE 62 BY 4.25
         FONT 1
         TITLE "Op‡äes de Busca" WIDGET-ID 700.

DEFINE FRAME fResult
     br_itens AT ROW 1 COL 1 WIDGET-ID 300
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 5.75
         SIZE 136 BY 6.25
         FONT 1
         TITLE "Itens" WIDGET-ID 800.

DEFINE FRAME fDetail
     fi-desc-ingles   AT ROW 1.5  COL 11 COLON-ALIGNED WIDGET-ID 14
     tg-gatt          AT ROW 1.5  COL 54 WIDGET-ID 106
     fi-perc-gatt     AT ROW 1.5  COL 80 COLON-ALIGNED WIDGET-ID 52
     fi-ex-ipi        AT ROW 1.5  COL 107 COLON-ALIGNED WIDGET-ID 48
     fi-estab         AT ROW 2.5  COL 11 COLON-ALIGNED WIDGET-ID 26
     fi-gr-estoque    AT ROW 2.5  COL 32 COLON-ALIGNED WIDGET-ID 42
     tg-antidumping   AT ROW 2.5  COL 54 WIDGET-ID 102
     fi-pis           AT ROW 2.5  COL 80 COLON-ALIGNED WIDGET-ID 54
     fi-ex-ii         AT ROW 2.5  COL 107 COLON-ALIGNED WIDGET-ID 46
     fi-unid-negoc    AT ROW 3.5  COL 11 COLON-ALIGNED WIDGET-ID 28
     fi-criticidade   AT ROW 3.5  COL 32 COLON-ALIGNED WIDGET-ID 38
     fi-peso-liq      AT ROW 3.5  COL 52 COLON-ALIGNED WIDGET-ID 16
     fi-cofins        AT ROW 3.5  COL 80 COLON-ALIGNED WIDGET-ID 56
     fi-seq-suframa   AT ROW 3.5  COL 107 COLON-ALIGNED WIDGET-ID 60
     fi-tipo-contr    AT ROW 4.5  COL 11 COLON-ALIGNED WIDGET-ID 30
     fi-peso-bruto    AT ROW 4.5  COL 52 COLON-ALIGNED WIDGET-ID 18
     fi-ext-pis       AT ROW 4.5  COL 80 COLON-ALIGNED WIDGET-ID 70
     fi-origem        AT ROW 4.5  COL 107 COLON-ALIGNED WIDGET-ID 64
     fi-unid-medida   AT ROW 5.5  COL 11 COLON-ALIGNED WIDGET-ID 32
     fi-comprimento   AT ROW 5.5  COL 52 COLON-ALIGNED WIDGET-ID 20
     fi-aliq-ii       AT ROW 5.5  COL 80 COLON-ALIGNED WIDGET-ID 72
     fi-destaque      AT ROW 5.5  COL 107 COLON-ALIGNED WIDGET-ID 44
     fi-acond         AT ROW 6.5  COL 11 COLON-ALIGNED WIDGET-ID 34
     fi-largura       AT ROW 6.5  COL 52 COLON-ALIGNED WIDGET-ID 22
     fi-aliq-ipi      AT ROW 6.5  COL 80 COLON-ALIGNED WIDGET-ID 74
     tg-qualidade     AT ROW 6.5  COL 110 WIDGET-ID 114
     fi-nqa           AT ROW 7.5  COL 11 COLON-ALIGNED WIDGET-ID 36
     fi-altura        AT ROW 7.5  COL 52 COLON-ALIGNED WIDGET-ID 24
     fi-cest          AT ROW 7.5  COL 80 COLON-ALIGNED WIDGET-ID 76
     tg-faturavel     AT ROW 7.5  COL 110 WIDGET-ID 104
     fi-homolog       AT ROW 8.5  COL 11 COLON-ALIGNED WIDGET-ID 124
     fi-venc-homolog  AT ROW 8.5  COL 52 COLON-ALIGNED WIDGET-ID 126
     ed_narrat_item   AT ROW 10.5 COL 2 NO-LABEL WIDGET-ID 92
     ed_narrat_manaus AT ROW 13.5 COL 2 NO-LABEL WIDGET-ID 94
     ed_observacao    AT ROW 16.5 COL 2 NO-LABEL WIDGET-ID 120
     "Observa‡Æo" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 16 COL 7 WIDGET-ID 122
     "Narrativa Manaus" VIEW-AS TEXT
          SIZE 13 BY .54 AT ROW 13 COL 7 WIDGET-ID 100
     "Narrativa" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 10 COL 7 WIDGET-ID 98
     /*RECT-165 AT ROW 1.25 COL 121 WIDGET-ID 110*/
     RECT-166 AT ROW 1.25 COL 2 WIDGET-ID 112
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 12.25
         SIZE 136 BY 18.25
         FONT 1
         TITLE "Detalhe Itens" WIDGET-ID 900.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "Consulta de Itens"
         HEIGHT             = 29.67
         WIDTH              = 137.57
         MAX-HEIGHT         = 31.5
         MAX-WIDTH          = 170
         VIRTUAL-HEIGHT     = 31.5
         VIRTUAL-WIDTH      = 170
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  VISIBLE,,RUN-PERSISTENT                                               */
/* REPARENT FRAME */
ASSIGN FRAME fDetail:FRAME = FRAME fPage0:HANDLE
       FRAME fFaixas:FRAME = FRAME fPage0:HANDLE
       FRAME fFiltro:FRAME = FRAME fPage0:HANDLE
       FRAME fResult:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fDetail
                                                                        */
ASSIGN 
       ed_narrat_item:READ-ONLY IN FRAME fDetail        = TRUE.

ASSIGN 
       ed_narrat_manaus:READ-ONLY IN FRAME fDetail        = TRUE.

ASSIGN 
       ed_observacao:READ-ONLY IN FRAME fDetail        = TRUE.

/* SETTINGS FOR FILL-IN fi-acond IN FRAME fDetail
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-aliq-ii IN FRAME fDetail
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-aliq-ipi IN FRAME fDetail
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-altura IN FRAME fDetail
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cest IN FRAME fDetail
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cofins IN FRAME fDetail
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-comprimento IN FRAME fDetail
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-criticidade IN FRAME fDetail
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-desc-ingles IN FRAME fDetail
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-destaque IN FRAME fDetail
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-estab IN FRAME fDetail
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-ex-ii IN FRAME fDetail
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-ex-ipi IN FRAME fDetail
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-ext-pis IN FRAME fDetail
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-gr-estoque IN FRAME fDetail
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-homolog IN FRAME fDetail
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-largura IN FRAME fDetail
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-nqa IN FRAME fDetail
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-origem IN FRAME fDetail
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-perc-gatt IN FRAME fDetail
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-peso-bruto IN FRAME fDetail
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-peso-liq IN FRAME fDetail
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-pis IN FRAME fDetail
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-seq-suframa IN FRAME fDetail
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-tipo-contr IN FRAME fDetail
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-unid-medida IN FRAME fDetail
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-unid-negoc IN FRAME fDetail
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-venc-homolog IN FRAME fDetail
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-antidumping IN FRAME fDetail
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-faturavel IN FRAME fDetail
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-gatt IN FRAME fDetail
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-qualidade IN FRAME fDetail
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fFaixas
                                                                        */
/* SETTINGS FOR FRAME fFiltro
                                                                        */
/* SETTINGS FOR COMBO-BOX cb_filtro IN FRAME fFiltro
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fResult
                                                                        */
/* BROWSE-TAB br_itens 1 fResult */
ASSIGN 
       br_itens:COLUMN-RESIZABLE IN FRAME fResult       = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_itens
/* Query rebuild information for BROWSE br_itens
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt_item.
     _END_FREEFORM
     _Query            is NOT OPENED
*/  /* BROWSE br_itens */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow /* Consulta de Itens */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Consulta de Itens */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br_itens
&Scoped-define FRAME-NAME fResult
&Scoped-define SELF-NAME br_itens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_itens wWindow
ON MOUSE-SELECT-CLICK OF br_itens IN FRAME fResult
DO:
    define variable i as integer no-undo.
    define variable c as character no-undo.

    IF  NOT VALID-HANDLE (h-cdapi995)  THEN
        RUN cdp\cdapi995.p PERSISTENT SET h-cdapi995.

    FIND FIRST int-item
        WHERE int-item.it-codigo = tt_item.it-codigo NO-LOCK NO-ERROR.

    IF  AVAIL int-item THEN
        FIND FIRST item-ean 
            WHERE item-ean.it-codigo = int-item.it-codigo NO-LOCK NO-ERROR.

    FIND FIRST int-familia
        WHERE int-familia.fm-codigo = tt_item.fm-codigo NO-LOCK NO-ERROR.

    IF  AVAIL int-familia THEN
        FIND FIRST c-tab-res
            WHERE c-tab-res.nr-tabela = 4
            AND   c-tab-res.sequencia = int-familia.acond NO-LOCK NO-ERROR.

    FIND FIRST familia
        WHERE familia.fm-codigo = tt_item.fm-codigo NO-LOCK NO-ERROR.

    ASSIGN v_contr_qualid = IF AVAIL familia THEN familia.contr-qualid ELSE NO.

    FIND FIRST classif-fisc
        WHERE classif-fisc.class-fiscal = tt_item.class-fiscal NO-LOCK NO-ERROR.

    FIND FIRST item-uni-estab 
        WHERE item-uni-estab.it-codigo   = tt_item.it-codigo
        /*AND   item-uni-estab.ind-item-fa*/ NO-LOCK NO-ERROR.
    
    IF  AVAIL item-uni-estab
    /*AND item-uni-estab.ind-item-fat*/ THEN DO:
        ASSIGN v_cest = 0.
    
        FOR EACH sit-tribut-relacto
            WHERE sit-tribut-relacto.cdn-tribut       = 11
            AND   sit-tribut-relacto.cod-estab        = "*"
            AND   sit-tribut-relacto.cod-natur-operac = "*"
            AND   sit-tribut-relacto.cod-ncm          = "*"
            AND   sit-tribut-relacto.cod-item         = tt_item.it-codigo
            AND   sit-tribut-relacto.cdn-emitente     = 0 NO-LOCK:
            ASSIGN v_cest = sit-tribut-relacto.cdn-sit-tribut.      
        END. 
    END.

    assign fi-desc-ingles:screen-value  in frame fDetail = tt_item.desc-inter
           fi-peso-liq:screen-value     in frame fDetail = string(tt_item.peso-liquido)
           fi-peso-bruto:screen-value   in frame fDetail = string(tt_item.peso-bruto)
           fi-comprimento:screen-value  in frame fDetail = string(tt_item.comprim)
           fi-largura:screen-value      in frame fDetail = string(tt_item.largura)
           fi-altura:screen-value       in frame fDetail = string(tt_item.altura)
           fi-estab:screen-value        in frame fDetail = tt_item.cod-estab
           fi-unid-negoc:screen-value   in frame fDetail = tt_item.cod-unid-negoc
           fi-tipo-contr:screen-value   in frame fDetail = {ininc/i09in122.i 04 tt_item.tipo-contr}
         /*fi-acond:screen-value        in frame fDetail = IF AVAIL int-familia AND AVAIL c-tab-res THEN string(int-familia.acond) + " - " + c-tab-res.descricao ELSE ""*/
           fi-nqa:screen-value          in frame fDetail = IF AVAIL familia THEN string(familia.perc-nqa) ELSE ""
           tg-qualidade:screen-value    in frame fDetail = STRING(v_contr_qualid)
           fi-gr-estoque:screen-value   in frame fDetail = string(tt_item.ge-codigo)
           fi-destaque:screen-value     in frame fDetail = string(tt_item.destaque)
           fi-ex-ii:screen-value        in frame fDetail = string(tt_item.ex-tarifario)
           fi-ex-ipi:screen-value       in frame fDetail = string(tt_item.ex-ipi)
           fi-unid-medida:screen-value  in frame fDetail = string(tt_item.un)
           tg-gatt:SCREEN-VALUE         IN FRAME fDetail = string(tt_item.log-gatt)
           fi-perc-gatt:SCREEN-VALUE    IN FRAME fDetail = string(tt_item.perc-gatt)
           fi-seq-suframa:SCREEN-VALUE  IN FRAME fDetail = string(tt_item.seq-suframa)
           fi-criticidade:SCREEN-VALUE  IN FRAME fDetail = {ininc/i06in095.i 04 tt_item.criticidade}
           fi-homolog:SCREEN-VALUE      IN FRAME fDetail = IF AVAIL item-ean THEN item-ean.homolog ELSE ""
           fi-venc-homolog:SCREEN-VALUE IN FRAME fDetail = IF AVAIL int-item AND int-item.dt-venc-homologacao = ? THEN "" ELSE string(int-item.dt-venc-homologacao).

    RUN recupera-aliquotas IN h-cdapi995 (INPUT  "item",
                                          INPUT  tt_item.it-codigo,
                                          OUTPUT de-ali-pis,
                                          OUTPUT de-ali-cofins).

    ASSIGN fi-pis:SCREEN-VALUE          IN FRAME fDetail = IF de-ali-pis    = 0 THEN STRING(DEC(SUBSTR(tt_item.char-2,31,5))) ELSE STRING(de-ali-pis)
           fi-cofins:SCREEN-VALUE       IN FRAME fDetail = IF de-ali-cofins = 0 THEN STRING(DEC(SUBSTR(tt_item.char-2,36,5))) ELSE STRING(de-ali-cofins)
           tg-antidumping:SCREEN-VALUE  IN FRAME fDetail = string(tt_item.antidumping)
           fi-origem:SCREEN-VALUE       IN FRAME fDetail = string(tt_item.codigo-orig)
           tg-faturavel:SCREEN-VALUE    IN FRAME fDetail = string(tt_item.ind-item-fat)
           ed_narrat_item:SCREEN-VALUE  IN FRAME fDetail = string(tt_item.narrativa)
           fi-ext-pis:SCREEN-VALUE      IN FRAME fDetail = STRING(DEC(SUBSTR(tt_item.char-2,74,5)))
           fi-aliq-ii:SCREEN-VALUE      IN FRAME fDetail = STRING(tt_item.aliq-ii)
           /*fi-pis-maj:SCREEN-VALUE      IN FRAME fDetail = IF AVAIL classif-fisc THEN string(dec(substring(classif-fisc.char-1,65,9))) ELSE "0"*/
           fi-aliq-ipi:SCREEN-VALUE     IN FRAME fDetail = string(tt_item.aliquota-ipi)
           /*fi-cofins-maj:SCREEN-VALUE   IN FRAME fDetail = IF AVAIL classif-fisc THEN string(dec(substring(classif-fisc.char-1,56,9))) ELSE "0".*/
           fi-cest:SCREEN-VALUE         IN FRAME fDetail = STRING(v_cest).

    IF INDEX(tt_item.narrativa,"#MANAUS#") <> 0 THEN DO:
        ASSIGN ed_narrat_item:SCREEN-VALUE   IN FRAME fDetail = TRIM(SUBSTRING(tt_item.narrativa,1,INDEX(tt_item.narrativa,"#MANAUS#") - 1))
               ed_narrat_manaus:SCREEN-VALUE IN FRAME fDetail = TRIM(SUBSTRING(tt_item.narrativa,INDEX(tt_item.narrativa,"#MANAUS#") + 8,LENGTH(tt_item.narrativa))).
    END.
    ELSE DO:
        ASSIGN ed_narrat_manaus:SCREEN-VALUE IN FRAME fDetail = "".
    END.

    ASSIGN ed_observacao:SCREEN-VALUE IN FRAME fDetail = "".

    FOR EACH it-carac-tec
        WHERE it-carac-tec.it-codigo = tt_item.it-codigo NO-LOCK,
        EACH comp-folh OF it-carac-tec
            WHERE comp-folh.log-estado = TRUE NO-LOCK :
        
        IF  comp-folh.abreviatura = "Inf. Adicionais" THEN
            ASSIGN ed_observacao:SCREEN-VALUE IN FRAME fDetail = TRIM(it-carac-tec.observacao).

        IF  comp-folh.abreviatura = "Acondicionamento" THEN
            ASSIGN fi-acond:screen-value in frame fDetail = TRIM(it-carac-tec.observacao).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_itens wWindow
ON VALUE-CHANGED OF br_itens IN FRAME fResult
DO:
   define variable i as integer no-undo.
   define variable c as character no-undo.

   IF  NOT VALID-HANDLE (h-cdapi995)  THEN
       RUN cdp\cdapi995.p PERSISTENT SET h-cdapi995.

   FIND FIRST int-item
       WHERE int-item.it-codigo = tt_item.it-codigo NO-LOCK NO-ERROR.

   IF  AVAIL int-item THEN
       FIND FIRST item-ean 
           WHERE item-ean.it-codigo = int-item.it-codigo NO-LOCK NO-ERROR.

   FIND FIRST int-familia
       WHERE int-familia.fm-codigo = tt_item.fm-codigo NO-LOCK NO-ERROR.

   IF  AVAIL int-familia THEN
       FIND FIRST c-tab-res
           WHERE c-tab-res.nr-tabela = 4
           AND   c-tab-res.sequencia = int-familia.acond NO-LOCK NO-ERROR.

   FIND FIRST familia
       WHERE familia.fm-codigo = tt_item.fm-codigo NO-LOCK NO-ERROR.

   ASSIGN v_contr_qualid = IF AVAIL familia THEN familia.contr-qualid ELSE NO.

   FIND FIRST classif-fisc
       WHERE classif-fisc.class-fiscal = tt_item.class-fiscal NO-LOCK NO-ERROR.

   FIND FIRST item-uni-estab 
       WHERE item-uni-estab.it-codigo   = tt_item.it-codigo
       /*AND   item-uni-estab.ind-item-fa*/ NO-LOCK NO-ERROR.
   
   IF  AVAIL item-uni-estab
   /*AND item-uni-estab.ind-item-fat*/ THEN DO:
       ASSIGN v_cest = 0.

       FOR EACH sit-tribut-relacto
           WHERE sit-tribut-relacto.cdn-tribut       = 11
           AND   sit-tribut-relacto.cod-estab        = "*"
           AND   sit-tribut-relacto.cod-natur-operac = "*"
           AND   sit-tribut-relacto.cod-ncm          = "*"
           AND   sit-tribut-relacto.cod-item         = tt_item.it-codigo
           AND   sit-tribut-relacto.cdn-emitente     = 0 NO-LOCK:
           ASSIGN v_cest = sit-tribut-relacto.cdn-sit-tribut.      
       END. 
   END.

   assign fi-desc-ingles:screen-value  in frame fDetail = tt_item.desc-inter
          fi-peso-liq:screen-value     in frame fDetail = string(tt_item.peso-liquido)
          fi-peso-bruto:screen-value   in frame fDetail = string(tt_item.peso-bruto)
          fi-comprimento:screen-value  in frame fDetail = string(tt_item.comprim)
          fi-largura:screen-value      in frame fDetail = string(tt_item.largura)
          fi-altura:screen-value       in frame fDetail = string(tt_item.altura)
          fi-estab:screen-value        in frame fDetail = tt_item.cod-estab
          fi-unid-negoc:screen-value   in frame fDetail = tt_item.cod-unid-negoc
          fi-tipo-contr:screen-value   in frame fDetail = {ininc/i09in122.i 04 tt_item.tipo-contr}
        /*fi-acond:screen-value        in frame fDetail = IF AVAIL int-familia AND AVAIL c-tab-res THEN string(int-familia.acond) + " - " + c-tab-res.descricao ELSE ""*/
          fi-nqa:screen-value          in frame fDetail = IF AVAIL familia THEN string(familia.perc-nqa) ELSE ""
          tg-qualidade:screen-value    in frame fDetail = STRING(v_contr_qualid)
          fi-gr-estoque:screen-value   in frame fDetail = string(tt_item.ge-codigo)
          fi-destaque:screen-value     in frame fDetail = string(tt_item.destaque)
          fi-ex-ii:screen-value        in frame fDetail = string(tt_item.ex-tarifario)
          fi-ex-ipi:screen-value       in frame fDetail = string(tt_item.ex-ipi)
          fi-unid-medida:screen-value  in frame fDetail = string(tt_item.un)
          tg-gatt:SCREEN-VALUE         IN FRAME fDetail = string(tt_item.log-gatt)
          fi-perc-gatt:SCREEN-VALUE    IN FRAME fDetail = string(tt_item.perc-gatt)
          fi-seq-suframa:SCREEN-VALUE  IN FRAME fDetail = string(tt_item.seq-suframa)
          fi-criticidade:SCREEN-VALUE  IN FRAME fDetail = {ininc/i06in095.i 04 tt_item.criticidade}
          fi-homolog:SCREEN-VALUE      IN FRAME fDetail = IF AVAIL item-ean THEN item-ean.homolog ELSE ""
          fi-venc-homolog:SCREEN-VALUE IN FRAME fDetail = IF AVAIL int-item AND int-item.dt-venc-homologacao = ? THEN "" ELSE string(int-item.dt-venc-homologacao).
          
   RUN recupera-aliquotas IN h-cdapi995 (INPUT  "item",
                                         INPUT  tt_item.it-codigo,
                                         OUTPUT de-ali-pis,
                                         OUTPUT de-ali-cofins).

   ASSIGN fi-pis:SCREEN-VALUE          IN FRAME fDetail = IF de-ali-pis    = 0 THEN STRING(DEC(SUBSTR(tt_item.char-2,31,5))) ELSE STRING(de-ali-pis)
          fi-cofins:SCREEN-VALUE       IN FRAME fDetail = IF de-ali-cofins = 0 THEN STRING(DEC(SUBSTR(tt_item.char-2,36,5))) ELSE STRING(de-ali-cofins)
          tg-antidumping:SCREEN-VALUE  IN FRAME fDetail = string(tt_item.antidumping)
          fi-origem:SCREEN-VALUE       IN FRAME fDetail = string(tt_item.codigo-orig)
          tg-faturavel:SCREEN-VALUE    IN FRAME fDetail = string(tt_item.ind-item-fat)
          ed_narrat_item:SCREEN-VALUE  IN FRAME fDetail = string(tt_item.narrativa)
          fi-ext-pis:SCREEN-VALUE      IN FRAME fDetail = STRING(DEC(SUBSTR(tt_item.char-2,74,5)))
          fi-aliq-ii:SCREEN-VALUE      IN FRAME fDetail = STRING(tt_item.aliq-ii)
          /*fi-pis-maj:SCREEN-VALUE      IN FRAME fDetail = IF AVAIL classif-fisc THEN string(dec(substring(classif-fisc.char-1,65,9))) ELSE "0"*/
          fi-aliq-ipi:SCREEN-VALUE     IN FRAME fDetail = string(tt_item.aliquota-ipi)
          /*fi-cofins-maj:SCREEN-VALUE   IN FRAME fDetail = IF AVAIL classif-fisc THEN string(dec(substring(classif-fisc.char-1,56,9))) ELSE "0".*/
          fi-cest:SCREEN-VALUE         IN FRAME fDetail = STRING(v_cest).

   IF INDEX(tt_item.narrativa,"#MANAUS#") <> 0 THEN DO:
       ASSIGN ed_narrat_item:SCREEN-VALUE   IN FRAME fDetail = TRIM(SUBSTRING(tt_item.narrativa,1,INDEX(tt_item.narrativa,"#MANAUS#") - 1))
              ed_narrat_manaus:SCREEN-VALUE IN FRAME fDetail = TRIM(SUBSTRING(tt_item.narrativa,INDEX(tt_item.narrativa,"#MANAUS#") + 8,LENGTH(tt_item.narrativa))).
   END.
   ELSE DO:
       ASSIGN ed_narrat_manaus:SCREEN-VALUE IN FRAME fDetail = "".
   END.

    ASSIGN ed_observacao:SCREEN-VALUE IN FRAME fDetail = "".

    FOR EACH it-carac-tec
        WHERE it-carac-tec.it-codigo = tt_item.it-codigo NO-LOCK,
        EACH comp-folh OF it-carac-tec
            WHERE comp-folh.log-estado = TRUE NO-LOCK :
        
        IF  comp-folh.abreviatura = "Inf. Adicionais" THEN
            ASSIGN ed_observacao:SCREEN-VALUE IN FRAME fDetail = TRIM(it-carac-tec.observacao).

        IF  comp-folh.abreviatura = "Acondicionamento" THEN
            ASSIGN fi-acond:screen-value in frame fDetail = TRIM(it-carac-tec.observacao).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME bt_carrega
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_carrega wWindow
ON CHOOSE OF bt_carrega IN FRAME fPage0 /* Carregar Itens */
DO:
  run openQueryitens.

  APPLY "VALUE-CHANGED" TO br_itens IN FRAME fResult.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_excel wWindow
ON CHOOSE OF bt_excel IN FRAME fPage0 /* Exportar para Excel */
DO:

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Gerando relat¢rio de itens").

    IF  NOT VALID-HANDLE (h-cdapi995)  THEN
        RUN cdp\cdapi995.p PERSISTENT SET h-cdapi995.

    FIND FIRST usuar_mestre NO-LOCK 
        WHERE  usuar_mestre.cod_usuario = v_cod_usuar_corren USE-INDEX srmstr_id NO-ERROR.
        
    ASSIGN v_aux1 = STRING(time,"HH:MM:SS":U).
    ASSIGN v_aux2 = SUBSTR(v_aux1,1,2) + SUBSTR(v_aux1,4,2) + SUBSTR(v_aux1,7,2).

    ASSIGN c-arq-excel = usuar_mestre.nom_dir_spool + "~\" + usuar_mestre.nom_subdir_spool + "~\" + "es5800_" + string(day(today)) + string(month(today)) + string(YEAR(today)) + "_" + v_aux2 + ".csv".

    OUTPUT TO value(c-arq-excel) NO-CONVERT.

    PUT UNFORMATTED "Item;Desci‡Æo;Situa‡Æo;Fam¡lia;Fam¡lia Coml;Class.Fiscal;NVE;EX Tarif rio II;Al¡quota IPI;Al¡quota II;Part-Number;Fabricante;Necessita LI;EAN-13;Descri‡Æo Internacional;Peso L¡quido;Peso Bruto;Comprimento;Largura;Altura;Estabelecimento;Unid.Negoc;Tipo Contrato;Acondicionamento;Perc NQA;Grupo Estoque;Destaque;EX IPI;Unidade Medida;GATT;Perc GATT;Aliq PIS;Aliq COFINS;PIS Majorado;COFINS Majorado;Homologa‡Æo;Venc Homologa‡Æo;Antidumping;Origem;Controle Qualidade;Fatur vel;CEST;PIS Ext;COFINS Ext;Seq SUFRAMA;Nr Projeto Suframa;Controlado;Narrativa;Narrativa Manaus;Observa‡Æo" SKIP.

    FOR EACH tt_item:
        
        RUN pi-acompanhar in h-acomp (INPUT "Item: " + STRING(tt_item.it-codigo)).

        ASSIGN c-tipo-contrato    = ""
               de-ali-pis         = 0
               de-ali-cofins      = 0
               v_observacao       = ""
               v_acond            = ""
               v_cest             = 0
               v_venc_homolog     = "". 

        FIND FIRST int-item
            WHERE int-item.it-codigo = tt_item.it-codigo NO-LOCK NO-ERROR.

        IF  AVAIL int-item
        AND int-item.dt-venc-homologacao = ? THEN
            ASSIGN v_venc_homolog = "". 
        ELSE 
            ASSIGN v_venc_homolog = string(int-item.dt-venc-homologacao).

        FIND FIRST int-familia NO-LOCK
             WHERE int-familia.fm-codigo = tt_item.fm-codigo NO-ERROR.
        
        IF  AVAIL int-familia THEN
            FIND FIRST c-tab-res
                WHERE c-tab-res.nr-tabela = 4
                AND   c-tab-res.sequencia = int-familia.acond NO-LOCK NO-ERROR.
        
        FIND FIRST familia
            WHERE familia.fm-codigo = tt_item.fm-codigo NO-LOCK NO-ERROR.
        
        ASSIGN v_contr_qualid = IF AVAIL familia THEN familia.contr-qualid ELSE NO.

        RUN recupera-aliquotas IN h-cdapi995 (INPUT  "item",
                                              INPUT  tt_item.it-codigo,
                                              OUTPUT de-ali-pis,
                                              OUTPUT de-ali-cofins).

        ASSIGN c-tipo-contrato = {ininc/i09in122.i 04 tt_item.tipo-contr}.

        FOR EACH it-carac-tec
            WHERE it-carac-tec.it-codigo = tt_item.it-codigo NO-LOCK,
            EACH comp-folh OF it-carac-tec
                WHERE comp-folh.log-estado = TRUE NO-LOCK :

            IF  comp-folh.abreviatura = "Inf. Adicionais" THEN
                ASSIGN v_observacao = TRIM(it-carac-tec.observacao).

            IF  comp-folh.abreviatura = "Acondicionamento" THEN
                ASSIGN v_acond = TRIM(it-carac-tec.observacao).
        END.

        IF  de-ali-pis    = 0 THEN
            ASSIGN de-ali-pis = DEC(SUBSTR(tt_item.char-2,31,5)).

        IF  de-ali-cofins = 0 THEN 
            ASSIGN de-ali-cofins = DEC(SUBSTR(tt_item.char-2,36,5)).

        FIND FIRST classif-fisc
            WHERE classif-fisc.class-fiscal = tt_item.class-fiscal NO-LOCK NO-ERROR.

        IF  AVAIL classif-fisc THEN
            ASSIGN v_pis_majorado    = string(dec(substring(classif-fisc.char-1,65,9)))
                   v_cofins_majorado = string(dec(substring(classif-fisc.char-1,56,9))).
        ELSE
            ASSIGN v_pis_majorado    = ""
                   v_cofins_majorado = "".

        FIND FIRST item-ean 
            WHERE item-ean.it-codigo = int-item.it-codigo NO-LOCK NO-ERROR.

        ASSIGN v_homologacao = IF AVAIL item-ean THEN item-ean.homolog ELSE "".

        FIND FIRST item-uni-estab 
            WHERE item-uni-estab.it-codigo   = tt_item.it-codigo
            /*AND   item-uni-estab.ind-item-fa*/ NO-LOCK NO-ERROR.

        IF  AVAIL item-uni-estab
        /*AND item-uni-estab.ind-item-fat*/ THEN DO:
            ASSIGN v_cest = 0.

            FOR EACH sit-tribut-relacto
                WHERE sit-tribut-relacto.cdn-tribut       = 11
                AND   sit-tribut-relacto.cod-estab        = "*"
                AND   sit-tribut-relacto.cod-natur-operac = "*"
                AND   sit-tribut-relacto.cod-ncm          = "*"
                AND   sit-tribut-relacto.cod-item         = tt_item.it-codigo
                AND   sit-tribut-relacto.cdn-emitente     = 0 NO-LOCK:
                ASSIGN v_cest = sit-tribut-relacto.cdn-sit-tribut.      
            END. 
        END.

        PUT UNFORMATTED tt_item.it-codigo                                + ";"
                        tt_item.desc-item                                + ";"
                        tt_item.situacao                                 + ";"
                        tt_item.fm-codigo                                + ";"
                        tt_item.fm-cod-com                               + ";"
                        tt_item.class-fiscal                             + ";"
                        trim(string(tt_item.nve))                        + ";"
                        string(tt_item.ex-tarifario)                     + ";"
                        string(tt_item.aliquota-ipi)                     + ";"
                        string(tt_item.aliq-ii)                          + ";"
                        tt_item.part-number                              + ";"
                        string(tt_item.fabricante)                       + ";"
                        string(tt_item.log-necessita-li,"Sim/NÆo")       + ";"
                        string(tt_item.cod-ean13)                        + ";"
                        tt_item.desc-inter                               + ";"
                        string(tt_item.peso-liquido)                     + ";"
                        string(tt_item.peso-bruto)                       + ";"
                        string(tt_item.comprim)                          + ";"
                        string(tt_item.largura)                          + ";"
                        string(tt_item.altura)                           + ";"
                        tt_item.cod-estab                                + ";"
                        tt_item.cod-unid-negoc                           + ";"
                        c-tipo-contrato                                  + ";"
                        v_acond                                          + ";"
                        string(familia.perc-nqa)                         + ";"
                        string(tt_item.ge-codigo)                        + ";"
                        string(tt_item.destaque)                         + ";"
                        string(tt_item.ex-ipi)                           + ";"
                        tt_item.un                                       + ";"
                        string(tt_item.log-gatt,"Sim/NÆo")               + ";"
                        string(tt_item.perc-gatt)                        + ";"
                        string(de-ali-pis)                               + ";"
                        string(de-ali-cofins)                            + ";"
                        v_pis_majorado                                   + ";"
                        v_cofins_majorado                                + ";"
                        v_homologacao                                    + ";"
                        string(v_venc_homolog)                           + ";"
                        string(tt_item.antidumping,"Sim/NÆo")            + ";"
                        string(tt_item.codigo-orig)                      + ";"
                        STRING(v_contr_qualid,"Sim/NÆo")                 + ";"
                        string(tt_item.ind-item-fat,"Sim/NÆo")           + ";"
                        STRING(v_cest)                                   + ";"
                        string(DEC(SUBSTR(tt_item.char-2,74,5)))         + ";"
                        string(DEC(SUBSTR(tt_item.char-2,79,5)))         + ";"
                        string(tt_item.seq-suframa)                      + ";"
                        STRING(tt_item.nr-projeto)                       + ";"
                        STRING(tt_item.controlado,"Sim/NÆo")             + ";".
        
        IF  INDEX(tt_item.narrativa,"#MANAUS#") <> 0 THEN DO:
            PUT UNFORMATTED TRIM(SUBSTRING(tt_item.narrativa,1,INDEX(tt_item.narrativa,"#MANAUS#") - 1)) + ";"
                                             TRIM(SUBSTRING(tt_item.narrativa,INDEX(tt_item.narrativa,"#MANAUS#") + 8,LENGTH(tt_item.narrativa))) + ";".
        END.
        ELSE DO:
            PUT UNFORMATTED TRIM(SUBSTRING(tt_item.narrativa,1,INDEX(tt_item.narrativa,"#MANAUS#") - 1)) + ";;".
        END.

        PUT UNFORMATTED TRIM(v_observacao) SKIP.
    END.

    OUTPUT CLOSE.

    RUN pi-finalizar in h-acomp.

    MESSAGE "Relat¢rio gerado ! Arquivo: " c-arq-excel SKIP
            "Deseja abrir o arquivo ?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL UPDATE l-confirma.

    IF  l-confirma = YES THEN
        DOS SILENT START excel VALUE(c-arq-excel).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWindow  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
  THEN DELETE WIDGET wWindow.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWindow  _DEFAULT-ENABLE
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
  ENABLE RECT-164 bt_carrega bt_excel 
      WITH FRAME fPage0 IN WINDOW wWindow.
  {&OPEN-BROWSERS-IN-QUERY-fPage0}
  DISPLAY cb_filtro tg-ativos tg-tot-obsoleto tg-obso-ordem tg-obso-automatic 
          tg-todos 
      WITH FRAME fFiltro IN WINDOW wWindow.
  ENABLE cb_filtro tg-ativos tg-tot-obsoleto tg-obso-ordem tg-obso-automatic 
         tg-todos 
      WITH FRAME fFiltro IN WINDOW wWindow.
  {&OPEN-BROWSERS-IN-QUERY-fFiltro}
  DISPLAY fi_ini fi_fim 
      WITH FRAME fFaixas IN WINDOW wWindow.
  ENABLE fi_ini fi_fim 
      WITH FRAME fFaixas IN WINDOW wWindow.
  {&OPEN-BROWSERS-IN-QUERY-fFaixas}
  ENABLE br_itens 
      WITH FRAME fResult IN WINDOW wWindow.
  {&OPEN-BROWSERS-IN-QUERY-fResult}
  DISPLAY fi-desc-ingles tg-gatt fi-perc-gatt fi-ex-ipi fi-estab fi-gr-estoque 
          tg-antidumping fi-pis fi-ex-ii fi-unid-negoc fi-criticidade 
          fi-peso-liq fi-cofins fi-seq-suframa fi-tipo-contr fi-peso-bruto 
          fi-ext-pis fi-origem fi-unid-medida fi-comprimento fi-aliq-ii 
          fi-destaque fi-acond fi-largura fi-aliq-ipi tg-qualidade fi-nqa 
          fi-altura fi-cest tg-faturavel fi-homolog fi-venc-homolog 
          ed_narrat_item ed_narrat_manaus ed_observacao 
      WITH FRAME fDetail IN WINDOW wWindow.
  ENABLE /*RECT-165*/ RECT-166 ed_narrat_item ed_narrat_manaus 
         ed_observacao 
      WITH FRAME fDetail IN WINDOW wWindow.
  {&OPEN-BROWSERS-IN-QUERY-fDetail}
  VIEW wWindow.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryitens wWindow 
PROCEDURE openQueryitens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   def var hQuery  as handle       no-undo.
   def var v_where as char init '' no-undo.
   def var v_sort  as char init '' no-undo.
   
   RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
   RUN pi-inicializar in h-acomp (input "Carregando Itens").

   IF  INPUT FRAME fFiltro cb_filtro:SCREEN-VALUE <> ?
   AND INPUT FRAME fFiltro cb_filtro:SCREEN-VALUE <> "" THEN DO:
       RUN pi-acompanhar in h-acomp (INPUT "Lendo itens.").

       CREATE QUERY hQuery.
   
       IF  INPUT FRAME fFiltro cb_filtro:SCREEN-VALUE = "C¢digo"
       OR  INPUT FRAME fFiltro cb_filtro:SCREEN-VALUE = "Descri‡Æo"
       OR  INPUT FRAME fFiltro cb_filtro:SCREEN-VALUE = "NCM"
       OR  INPUT FRAME fFiltro cb_filtro:SCREEN-VALUE = "Fam¡lia"
       OR  INPUT FRAME fFiltro cb_filtro:SCREEN-VALUE = "Fam¡lia Comercial"
       OR  INPUT FRAME fFiltro cb_filtro:SCREEN-VALUE = "IPI" THEN DO:
           ASSIGN v_where = "EACH item FIELDS (it-codigo desc-item aliquota-ipi cod-obsoleto desc-inter fm-codigo peso-liquido peso-bruto comprim largura altura cod-estabel un fm-cod-com class-fiscal log-necessita-li narrativa codigo-orig ind-item-fat char-2 cod-unid-negoc tipo-contr ge-codigo criticidade) no-lock ".
   
           IF  INPUT FRAME fFiltro cb_filtro:SCREEN-VALUE = "C¢digo" THEN DO:
               IF  INPUT FRAME fFaixas fi_fim:SCREEN-VALUE = "" THEN
                   ASSIGN v_where = v_where + "WHERE item.it-codigo = '" + INPUT FRAME fFaixas fi_ini:SCREEN-VALUE + "' ".
               ELSE
                   ASSIGN v_where = v_where + "WHERE item.it-codigo >= '" + INPUT FRAME fFaixas fi_ini:SCREEN-VALUE + "'
                                               AND   item.it-codigo <= '" + INPUT FRAME fFaixas fi_fim:SCREEN-VALUE + "' ".
               ASSIGN v_sort  = " BY item.it-codigo ".
           END.
           ELSE IF  INPUT FRAME fFiltro cb_filtro:SCREEN-VALUE = "Descri‡Æo" THEN DO:
               IF  INPUT FRAME fFaixas fi_fim:SCREEN-VALUE = "" THEN
                   ASSIGN v_where = v_where + "WHERE item.desc-item MATCHES '*" + INPUT FRAME fFaixas fi_ini:SCREEN-VALUE + "*' ".
               ELSE
                   ASSIGN v_where = v_where + "WHERE item.desc-item >= '" + INPUT FRAME fFaixas fi_ini:SCREEN-VALUE + "'
                                               AND   item.desc-item <= '" + INPUT FRAME fFaixas fi_fim:SCREEN-VALUE + "' ".
               ASSIGN v_sort  = " BY item.desc-item BY item.it-codigo ".
           END.
           ELSE IF  INPUT FRAME fFiltro cb_filtro:SCREEN-VALUE = "NCM" THEN DO:
               IF  INPUT FRAME fFaixas fi_fim:SCREEN-VALUE = "" THEN
                   ASSIGN v_where = v_where + "WHERE item.class-fiscal = '" + replace(INPUT FRAME fFaixas fi_ini:SCREEN-VALUE, ".", "") + "' ".
               ELSE
                   ASSIGN v_where = v_where + "WHERE item.class-fiscal >= '" + replace(INPUT FRAME fFaixas fi_ini:SCREEN-VALUE, ".", "") + "'
                                               AND   item.class-fiscal <= '" + replace(INPUT FRAME fFaixas fi_fim:SCREEN-VALUE, ".", "") + "' ".
               ASSIGN v_sort  = " BY item.class-fiscal BY item.it-codigo ".
           END.
           ELSE IF  INPUT FRAME fFiltro cb_filtro:SCREEN-VALUE = "Fam¡lia" THEN DO:
               IF  INPUT FRAME fFaixas fi_fim:SCREEN-VALUE = "" THEN
                   ASSIGN v_where = v_where + "WHERE item.fm-codigo = '" + INPUT FRAME fFaixas fi_ini:SCREEN-VALUE + "' ".
               ELSE
                   ASSIGN v_where = v_where + "WHERE item.fm-codigo >= '" + INPUT FRAME fFaixas fi_ini:SCREEN-VALUE + "'
                                               AND   item.fm-codigo <= '" + INPUT FRAME fFaixas fi_fim:SCREEN-VALUE + "' ".
               ASSIGN v_sort  = " BY item.fm-codigo BY item.it-codigo ".
           END.
           ELSE IF  INPUT FRAME fFiltro cb_filtro:SCREEN-VALUE = "Fam¡lia Comercial" THEN DO:
               IF  INPUT FRAME fFaixas fi_fim:SCREEN-VALUE = "" THEN
                   ASSIGN v_where = v_where + "WHERE item.fm-cod-com = '" + INPUT FRAME fFaixas fi_ini:SCREEN-VALUE + "' ".
               ELSE
                   ASSIGN v_where = v_where + "WHERE item.fm-cod-com >= '" + INPUT FRAME fFaixas fi_ini:SCREEN-VALUE + "'
                                               AND   item.fm-cod-com <= '" + INPUT FRAME fFaixas fi_fim:SCREEN-VALUE + "' ".
               ASSIGN v_sort  = " BY item.fm-cod-com BY item.it-codigo ".
           END.
           ELSE IF  INPUT FRAME fFiltro cb_filtro:SCREEN-VALUE = "IPI" THEN DO:
               IF  INPUT FRAME fFaixas fi_fim:SCREEN-VALUE = ""  THEN
                   ASSIGN v_where = v_where + "WHERE item.aliquota-ipi = " + INPUT FRAME fFaixas fi_ini:SCREEN-VALUE + " ".
               ELSE
               ASSIGN v_where = v_where + "WHERE item.aliquota-ipi >= " + INPUT FRAME fFaixas fi_ini:SCREEN-VALUE + "
                                           AND   item.aliquota-ipi <= " + INPUT FRAME fFaixas fi_fim:SCREEN-VALUE + " ".
               ASSIGN v_sort  = " BY item.aliquota-ipi BY item.it-codigo ".
           END.
   
           ASSIGN v_where = v_where + ", EACH int-item NO-LOCK
                                            WHERE int-item.it-codigo = item.it-codigo,
                                         EACH item-fabric FIELDS (it-fabric) NO-LOCK
                                            WHERE item-fabric.it-codigo = item.it-codigo OUTER-JOIN,
                                         EACH fabricante FIELDS (nome-abrev) NO-LOCK
                                            WHERE fabricante.cod-fabric = item-fabric.cod-fabric OUTER-JOIN,
                                         EACH item-proj-suframa FIELDS (nr-projeto controlado) NO-LOCK
                                            WHERE item-proj-suframa.it-codigo = item.it-codigo OUTER-JOIN,
                                         FIRST item-ean /*FIELDS (cod-ean13)*/ NO-LOCK
                                            WHERE item-ean.it-codigo = item.it-codigo OUTER-JOIN,
                                         FIRST item-mat FIELDS (it-codigo cod-ean) no-lock
                                            WHERE item-mat.it-codigo = item.it-codigo OUTER-JOIN ".
   
           hQuery:SET-BUFFERS(BUFFER item:Handle, BUFFER int-item:Handle, BUFFER item-fabric:Handle, BUFFER fabricante:Handle, BUFFER item-proj-suframa:HANDLE, BUFFER item-ean:Handle, BUFFER item-mat:handle).
       END.
       ELSE IF  INPUT FRAME fFiltro cb_filtro:SCREEN-VALUE = "NVE"
            OR  INPUT FRAME fFiltro cb_filtro:SCREEN-VALUE = "Ex. Tarif rio" THEN DO:
           ASSIGN v_where = "EACH int-item NO-LOCK ".
           
           IF  INPUT FRAME fFiltro cb_filtro:SCREEN-VALUE = "NVE"  THEN DO:
               IF  INPUT FRAME fFaixas fi_fim:SCREEN-VALUE = "" THEN
                   ASSIGN v_where = v_where + "WHERE int-item.nve = '" + INPUT FRAME fFaixas fi_ini:SCREEN-VALUE + "' ".
               ELSE
                   ASSIGN v_where = v_where + "WHERE int-item.nve >= '" + INPUT FRAME fFaixas fi_ini:SCREEN-VALUE + "'
                                               AND   int-item.nve <= '" + INPUT FRAME fFaixas fi_fim:SCREEN-VALUE + "' ".
               ASSIGN v_sort  = " BY int-item.it-codigo BY item.it-codigo ".
           END.
           ELSE IF  INPUT FRAME fFiltro cb_filtro:SCREEN-VALUE = "Ex. Tarif rio" THEN DO:
               IF  INPUT FRAME fFaixas fi_fim:SCREEN-VALUE = "" THEN
                   ASSIGN v_where = v_where + "WHERE int-item.ex-tarifario = '" + INPUT FRAME fFaixas fi_ini:SCREEN-VALUE + "' ".
               ELSE
                   ASSIGN v_where = v_where + "WHERE int-item.ex-tarifario >= '" + INPUT FRAME fFaixas fi_ini:SCREEN-VALUE + "'
                                               AND   int-item.ex-tarifario <= '" + INPUT FRAME fFaixas fi_fim:SCREEN-VALUE + "' ".
               ASSIGN v_sort  = " BY int-item.it-codigo BY item.it-codigo ".
           END.
   
           ASSIGN v_where = v_where + ", EACH item FIELDS (it-codigo desc-item aliquota-ipi cod-obsoleto desc-inter fm-codigo peso-liquido peso-bruto comprim largura altura cod-estabel un fm-cod-com class-fiscal log-necessita-li narrativa codigo-orig ind-item-fat char-2 cod-unid-negoc tipo-contr ge-codigo criticidade) no-lock
                                            WHERE item.it-codigo = int-item.it-codigo,
                                         EACH item-fabric FIELDS (it-fabric) NO-LOCK
                                            WHERE item-fabric.it-codigo = item.it-codigo OUTER-JOIN,
                                         EACH fabricante FIELDS (nome-abrev) NO-LOCK
                                            WHERE fabricante.cod-fabric = item-fabric.cod-fabric OUTER-JOIN,
                                         EACH item-proj-suframa FIELDS (nr-projeto controlado) NO-LOCK
                                            WHERE item-proj-suframa.it-codigo = item.it-codigo OUTER-JOIN,
                                         FIRST item-ean /*FIELDS (cod-ean13)*/ NO-LOCK
                                            WHERE item-ean.it-codigo = item.it-codigo OUTER-JOIN,
                                         FIRST item-mat FIELDS (it-codigo cod-ean) NO-LOCK
                                            WHERE item-mat.it-codigo = item.it-codigo OUTER-JOIN ".
   
           hQuery:SET-BUFFERS(BUFFER int-item:Handle, BUFFER item:Handle, BUFFER item-fabric:Handle, BUFFER fabricante:Handle, BUFFER item-proj-suframa:HANDLE, BUFFER item-ean:Handle, BUFFER item-mat:handle).
       END.
       ELSE IF  INPUT FRAME fFiltro cb_filtro:SCREEN-VALUE = "Part Number" THEN DO:
           ASSIGN v_where = "EACH item-fabric FIELDS (it-fabric it-codigo) NO-LOCK ".
         
           IF  INPUT FRAME fFiltro cb_filtro:SCREEN-VALUE = "Part Number" THEN DO:
               IF  INPUT FRAME fFaixas fi_fim:SCREEN-VALUE = "" THEN
                   ASSIGN v_where = v_where + "WHERE item-fabric.it-fabric MATCHES '*" + INPUT FRAME fFaixas fi_ini:SCREEN-VALUE + "*' ".
               ELSE
                   ASSIGN v_where = v_where + "WHERE item-fabric.it-fabric >= '" + INPUT FRAME fFaixas fi_ini:SCREEN-VALUE + "'
                                               AND   item-fabric.it-fabric <= '" + INPUT FRAME fFaixas fi_fim:SCREEN-VALUE + "' ".
               ASSIGN v_sort  = " BY item-fabric.it-fabric BY item.it-codigo ".
           END.
   
           ASSIGN v_where = v_where + ", EACH fabricante FIELDS (nome-abrev) NO-LOCK
                                            WHERE fabricante.cod-fabric = item-fabric.cod-fabric OUTER-JOIN,
                                         EACH item FIELDS (it-codigo desc-item aliquota-ipi cod-obsoleto desc-inter fm-codigo peso-liquido peso-bruto comprim largura altura cod-estabel un fm-cod-com class-fiscal log-necessita-li narrativa codigo-orig ind-item-fat char-2 cod-unid-negoc tipo-contr ge-codigo criticidade) no-lock
                                            WHERE item.it-codigo = item-fabric.it-codigo,
                                         EACH int-item NO-LOCK
                                            WHERE int-item.it-codigo = item.it-codigo,
                                         EACH item-proj-suframa FIELDS (nr-projeto controlado) NO-LOCK
                                            WHERE item-proj-suframa.it-codigo = item.it-codigo OUTER-JOIN,
                                         FIRST item-ean /*FIELDS (cod-ean13)*/ NO-LOCK
                                            WHERE item-ean.it-codigo = item.it-codigo OUTER-JOIN,
                                         FIRST item-mat FIELDS (it-codigo cod-ean) no-lock
                                            WHERE item-mat.it-codigo = item.it-codigo OUTER-JOIN ".
   
           hQuery:SET-BUFFERS(BUFFER item-fabric:Handle, BUFFER fabricante:Handle, BUFFER item:Handle, BUFFER int-item:Handle, BUFFER item-proj-suframa:HANDLE, BUFFER item-ean:Handle, BUFFER item-mat:handle).
       END.
       ELSE IF  INPUT FRAME fFiltro cb_filtro:SCREEN-VALUE = "Fabricante" THEN DO:
           ASSIGN v_where = "EACH fabricante FIELDS (nome-abrev) NO-LOCK ".
         
           IF  INPUT FRAME fFiltro cb_filtro:SCREEN-VALUE = "Fabricante" THEN DO:
               IF  INPUT FRAME fFaixas fi_fim:SCREEN-VALUE = "" THEN
                   ASSIGN v_where = v_where + "WHERE fabricante.nome-abrev MATCHES '*" + INPUT FRAME fFaixas fi_ini:SCREEN-VALUE + "*' ".
               ELSE
                   ASSIGN v_where = v_where + "WHERE fabricante.nome-abrev >= '" + INPUT FRAME fFaixas fi_ini:SCREEN-VALUE + "'
                                               AND   fabricante.nome-abrev <= '" + INPUT FRAME fFaixas fi_fim:SCREEN-VALUE + "' ".
               ASSIGN v_sort  = " BY fabricante.nome-abrev BY item.it-codigo BY item-fabric.it-fabric ".
           END.
   
           ASSIGN v_where = v_where + ", EACH item-fabric FIELDS (it-fabric it-codigo) NO-LOCK
                                            WHERE item-fabric.cod-fabric = fabricante.cod-fabric,
                                         EACH item FIELDS (it-codigo desc-item aliquota-ipi cod-obsoleto desc-inter fm-codigo peso-liquido peso-bruto comprim largura altura cod-estabel un fm-cod-com class-fiscal log-necessita-li narrativa codigo-orig ind-item-fat char-2 cod-unid-negoc tipo-contr ge-codigo criticidade) no-lock
                                            WHERE item.it-codigo = item-fabric.it-codigo,
                                         EACH int-item NO-LOCK
                                            WHERE int-item.it-codigo = item.it-codigo,
                                         EACH item-proj-suframa FIELDS (nr-projeto controlado) NO-LOCK
                                            WHERE item-proj-suframa.it-codigo = item.it-codigo OUTER-JOIN,
                                         FIRST item-ean /*FIELDS (cod-ean13)*/ NO-LOCK
                                            WHERE item-ean.it-codigo = item.it-codigo OUTER-JOIN,
                                         FIRST item-mat FIELDS (it-codigo cod-ean) no-lock
                                            WHERE item-mat.it-codigo = item.it-codigo OUTER-JOIN ".
   
           hQuery:SET-BUFFERS(BUFFER fabricante:Handle, BUFFER item-fabric:Handle, BUFFER item:Handle, BUFFER int-item:Handle, BUFFER item-proj-suframa:HANDLE, BUFFER item-ean:Handle, BUFFER item-mat:handle).
       END.
       ELSE IF  INPUT FRAME fFiltro cb_filtro:SCREEN-VALUE = "C¢digo EAN-13"  THEN DO:
           ASSIGN v_where = "EACH item-mat FIELDS (it-codigo cod-ean) NO-LOCK ".
         
           IF  INPUT FRAME fFiltro cb_filtro:SCREEN-VALUE = "C¢digo EAN-13" THEN DO:
               IF  INPUT FRAME fFaixas fi_fim:SCREEN-VALUE = "" THEN
                   ASSIGN v_where = v_where + "WHERE item-mat.cod-ean MATCHES '*" + INPUT FRAME fFaixas fi_ini:SCREEN-VALUE + "*' ".
               ELSE
                   ASSIGN v_where = v_where + "WHERE item-mat.cod-ean >= '" + INPUT FRAME fFaixas fi_ini:SCREEN-VALUE + "'
                                               AND   item-mat.cod-ean <= '" + INPUT FRAME fFaixas fi_fim:SCREEN-VALUE + "' ".
               ASSIGN v_sort  = " BY item-mat.cod-ean BY item.it-codigo ".
           END.
   
           ASSIGN v_where = v_where + ", EACH item FIELDS (it-codigo desc-item aliquota-ipi cod-obsoleto desc-inter fm-codigo peso-liquido peso-bruto comprim largura altura cod-estabel un fm-cod-com class-fiscal log-necessita-li narrativa codigo-orig ind-item-fat char-2 cod-unid-negoc tipo-contr ge-codigo criticidade) no-lock
                                            WHERE item.it-codigo = item-mat.it-codigo,
                                         EACH int-item NO-LOCK
                                            WHERE int-item.it-codigo = item.it-codigo,
                                         EACH item-fabric FIELDS (it-fabric) NO-LOCK
                                            WHERE item-fabric.it-codigo = item.it-codigo OUTER-JOIN,
                                         EACH fabricante FIELDS (nome-abrev) NO-LOCK
                                            WHERE fabricante.cod-fabric = item-fabric.cod-fabric OUTER-JOIN,
                                         EACH item-proj-suframa FIELDS (nr-projeto controlado) NO-LOCK
                                            WHERE item-proj-suframa.it-codigo = item.it-codigo OUTER-JOIN,
                                         EACH item-ean FIELDS /*(it-codigo cod-ean13)*/ NO-LOCK
                                            WHERE item-ean.it-codigo = item.it-codigo OUTER-JOIN ".
   
           hQuery:SET-BUFFERS(BUFFER item-MAT:Handle, BUFFER item:Handle, BUFFER int-item:Handle, BUFFER item-fabric:Handle, BUFFER fabricante:Handle, BUFFER item-proj-suframa:HANDLE, BUFFER item-ean:handle).
       END.
       ELSE IF  INPUT FRAME fFiltro cb_filtro:SCREEN-VALUE = "Homologa‡Æo"  THEN DO:
           ASSIGN v_where = "EACH item-ean NO-LOCK ".
         
           IF  INPUT FRAME fFaixas fi_fim:SCREEN-VALUE = "" THEN
               ASSIGN v_where = v_where + "WHERE item-ean.homolog MATCHES '*" + INPUT FRAME fFaixas fi_ini:SCREEN-VALUE + "*' ".
           ELSE
               ASSIGN v_where = v_where + "WHERE item-ean.homolog >= '" + INPUT FRAME fFaixas fi_ini:SCREEN-VALUE + "'
                                           AND   item-ean.homolog <= '" + INPUT FRAME fFaixas fi_fim:SCREEN-VALUE + "' ".
           ASSIGN v_sort  = " BY item-ean.homolog BY item-ean.it-codigo ".
   
           ASSIGN v_where = v_where + ", EACH item FIELDS (it-codigo desc-item aliquota-ipi cod-obsoleto desc-inter fm-codigo peso-liquido peso-bruto comprim largura altura cod-estabel un fm-cod-com class-fiscal log-necessita-li narrativa codigo-orig ind-item-fat char-2 cod-unid-negoc tipo-contr ge-codigo criticidade) no-lock
                                            WHERE item.it-codigo = item-ean.it-codigo,
                                         EACH int-item NO-LOCK
                                            WHERE int-item.it-codigo = item.it-codigo,
                                         EACH item-fabric FIELDS (it-fabric) NO-LOCK
                                            WHERE item-fabric.it-codigo = item.it-codigo OUTER-JOIN,
                                         EACH fabricante FIELDS (nome-abrev) NO-LOCK
                                            WHERE fabricante.cod-fabric = item-fabric.cod-fabric OUTER-JOIN,
                                         EACH item-proj-suframa FIELDS (nr-projeto controlado) NO-LOCK
                                            WHERE item-proj-suframa.it-codigo = item.it-codigo OUTER-JOIN,
                                         FIRST item-mat FIELDS (it-codigo cod-ean) no-lock
                                            WHERE item-mat.it-codigo = item.it-codigo OUTER-JOIN ".
   
           hQuery:SET-BUFFERS(BUFFER item-ean:handle, BUFFER item:Handle, BUFFER int-item:Handle, BUFFER item-fabric:Handle, BUFFER fabricante:Handle, BUFFER item-proj-suframa:HANDLE, BUFFER item-mat:Handle).

       END.

       if (hQuery:query-prepare("preselect " + v_where + v_sort) = FALSE) then
           message "Erro ao carregar o browse !" view-as alert-box.
       else
           hQuery:query-open.
   END.

   empty temp-table tt_item.

   if  hQuery:num-results <> 0 then do:
       repeat:
           hQuery:get-next().
        
           if  hQuery:query-off-end then
               leave.

           RUN pi-acompanhar in h-acomp (INPUT "Item: " + STRING(item.it-codigo)).

           IF   INPUT FRAME fFiltro tg-todos:CHECKED          = YES
           OR  (INPUT FRAME fFiltro tg-ativos:CHECKED         = YES
           AND  item.cod-obsoleto                             = 1)
           OR  (INPUT FRAME fFiltro tg-obso-automatic:CHECKED = YES
           AND  item.cod-obsoleto                             = 2)
           OR  (INPUT FRAME fFiltro tg-obso-ordem:CHECKED     = YES
           AND  item.cod-obsoleto                             = 3)
           OR  (INPUT FRAME fFiltro tg-tot-obsoleto:CHECKED   = YES
           AND  item.cod-obsoleto                             = 4) THEN DO:

               ASSIGN v_nve = int-item.nve
                      v_nve = REPLACE(v_nve,CHR(10)," ")
                      v_nve = REPLACE(v_nve,CHR(13)," ")
                      v_nve = REPLACE(v_nve,";",",").

               ASSIGN v_narrativa = item.narrativa
                      v_narrativa = REPLACE(v_narrativa,CHR(10)," ")
                      v_narrativa = REPLACE(v_narrativa,CHR(13)," ")
                      v_narrativa = REPLACE(v_narrativa,";",",").

               create tt_item.
               ASSIGN tt_item.it-codigo        = item.it-codigo
                      tt_item.desc-item        = item.desc-item
                      tt_item.desc-inter       = item.desc-inter
                      tt_item.fm-codigo        = item.fm-codigo
                      tt_item.peso-liquido     = item.peso-liquido
                      tt_item.peso-bruto       = item.peso-bruto
                      tt_item.comprim          = item.comprim
                      tt_item.largura          = item.largura
                      tt_item.altura           = item.altura
                      tt_item.cod-estabel      = item.cod-estabel
                      tt_item.cod-unid-negoc   = item.cod-unid-negoc
                      tt_item.un               = item.un
                      tt_item.fm-cod-com       = item.fm-cod-com
                      tt_item.class-fiscal     = item.class-fiscal
                      tt_item.log-necessita-li = item.log-necessita-li
                      tt_item.narrativa        = v_narrativa
                      tt_item.codigo-orig      = item.codigo-orig
                      tt_item.ind-item-fat     = item.ind-item-fat
                      tt_item.situacao         = {ininc/i17in172.i 04 item.cod-obsoleto}
                      tt_item.nve              = v_nve
                      tt_item.ex-tarifario     = int-item.ex-tarifario
                      tt_item.part-number      = IF AVAIL item-fabric THEN item-fabric.it-fabric ELSE ''
                      tt_item.fabricante       = IF AVAIL fabricante THEN fabricante.nome-abrev ELSE ''
                      tt_item.cod-ean13        = IF AVAIL item-mat THEN item-mat.cod-ean      ELSE ''
                      tt_item.aliquota-ipi     = item.aliquota-ipi
                      tt_item.destaque         = IF  AVAIL int-item THEN int-item.destaque ELSE 0
                      tt_item.ex-ipi           = int-item.exipi
                      tt_item.antidumping      = int-item.log-antidumping
                      tt_item.log-gatt         = int-item.log-gatt
                      tt_item.perc-gatt        = int-item.perc-gatt
                      tt_item.char-2           = item.char-2
                      tt_item.seq-suframa      = int-item.seq-suframa
                      tt_item.aliq-ii          = dec(SUBSTR(item.char-2,22,6))
                      tt_item.tipo-contr       = item.tipo-contr
                      tt_item.ge-codigo        = item.ge-codigo
                      tt_item.criticidade      = ITEM.criticidade
                      tt_item.nr-projeto       = IF AVAIL item-proj-suframa THEN item-proj-suframa.nr-projeto ELSE 0
                      tt_item.controlado       = IF AVAIL item-proj-suframa THEN item-proj-suframa.controlado ELSE NO.
           END.           
       END.
   END.

   {&open-query-br_itens}

   RUN pi-finalizar in h-acomp.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

