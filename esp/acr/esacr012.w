&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE NEW GLOBAL SHARED VARIABLE v_cod_empres_usuar    AS CHARACTER    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_estab_usuar     AS CHARACTER    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren    AS CHARACTER    NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE v_rec_tit_acr         AS RECID        NO-UNDO.
DEFINE VAR v_regra_visualiz       AS INT INITIAL 1.
DEFINE VAR num_seq_hist           LIKE histor_movto_tit_acr.num_seq_histor_movto_acr.
DEFINE VAR v_num_id_movto_tit_acr LIKE movto_tit_acr.num_id_movto_tit_acr.
DEFINE VAR v_hra_indcao           AS CHARACTER FORMAT "99:99:99":U      NO-UNDO.

DEFINE VARIABLE v_cod_estab_ini AS CHARACTER FORMAT "x(03)" LABEL "Estab" VIEW-AS FILL-IN  SIZE 4 BY .88 BGCOLOR 15  NO-UNDO.
DEFINE VARIABLE v_cod_estab_fim AS CHARACTER FORMAT "x(03)" LABEL "atÇ"   VIEW-AS FILL-IN  SIZE 4 BY .88 BGCOLOR 15  NO-UNDO.



DEF BUFFER b_histor_movto_tit_acr FOR histor_movto_tit_acr.

{esp/acr/esacr012tt.i}

RUN pi_deleta_temp-table.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt_tit_acr

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 tt_tit_acr.selecionado tt_tit_acr.vcod_grp_clien tt_tit_acr.vcdn_cliente tt_tit_acr.vnom_abrev tt_tit_acr.vcod_estab tt_tit_acr.vcod_espec tt_tit_acr.vcod_ser tt_tit_acr.vcod_tit_acr tt_tit_acr.vval_sdo_tit_acr tt_tit_acr.vdat_emis_tit_acr tt_tit_acr.vdat_vencto_tit_acr tt_tit_acr.vnum_atras tt_tit_acr.vcont_parcelas tt_tit_acr.vsit_tit_acr   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1   
&Scoped-define SELF-NAME BROWSE-1
&Scoped-define OPEN-QUERY-BROWSE-1  IF v_regra_visualiz = 1 THEN DO:    IF rs-opcao = 1 THEN DO:       IF l_apenas_selec THEN          OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vcod_tit_acr WHERE tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.       ELSE          OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vcod_tit_acr NO-LOCK INDEXED-REPOSITION.    END.     ELSE       IF rs-opcao = 2 THEN DO:          IF l_apenas_selec THEN             OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vcdn_clien WHERE tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.          ELSE             OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vcdn_clien NO-LOCK INDEXED-REPOSITION.       END.        ELSE          IF rs-opcao = 3 THEN DO:             IF l_apenas_selec THEN                OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vnum_atras WHERE tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.             ELSE                OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vnum_atras NO-LOCK INDEXED-REPOSITION.          END.          ELSE DO:             IF l_apenas_selec THEN                OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vdat_vencto_tit_acr WHERE tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.             ELSE                OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vdat_vencto_tit_acr NO-LOCK INDEXED-REPOSITION.          END.  END.  ELSE DO:    IF v_regra_visualiz = 2 THEN DO:       IF rs-opcao = 1 THEN DO:          IF l_apenas_selec THEN             OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vcod_tit_acr WHERE tt_tit_acr.vregra = 2 AND tt_tit_acr.selecionado = l_apenas_selec AND tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.          ELSE             OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vcod_tit_acr WHERE tt_tit_acr.vregra = 2 AND tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.       END.       ELSE          IF rs-opcao = 2 THEN DO:             IF l_apenas_selec THEN                OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vcdn_clien WHERE tt_tit_acr.vregra = 2 AND tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.             ELSE                OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vcdn_clien WHERE tt_tit_acr.vregra = 2 NO-LOCK INDEXED-REPOSITION.          END.          ELSE             IF rs-opcao = 3 THEN DO:                IF l_apenas_selec THEN                   OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vnum_atras WHERE tt_tit_acr.vregra = 2 AND tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.                ELSE                   OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vnum_atras WHERE tt_tit_acr.vregra = 2 NO-LOCK INDEXED-REPOSITION.             END.             ELSE DO:                IF l_apenas_selec THEN                   OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vdat_vencto_tit_acr WHERE tt_tit_acr.vregra = 2 AND tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.                ELSE                   OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vdat_vencto_tit_acr WHERE tt_tit_acr.vregra = 2 NO-LOCK INDEXED-REPOSITION.             END.    END.    ELSE       IF v_regra_visualiz = 3 THEN DO:          IF rs-opcao = 1 THEN DO:             IF l_apenas_selec THEN                OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vcod_tit_acr WHERE tt_tit_acr.vregra = 3 AND tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.             ELSE                OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vcod_tit_acr WHERE tt_tit_acr.vregra = 3 AND tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.          END.          ELSE             IF rs-opcao = 2 THEN DO:                IF l_apenas_selec THEN                   OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vcdn_clien WHERE tt_tit_acr.vregra = 3 AND tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.                 ELSE                   OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vcdn_clien WHERE tt_tit_acr.vregra = 3 NO-LOCK INDEXED-REPOSITION.             END.             ELSE                IF rs-opcao = 3 THEN DO:                   IF l_apenas_selec THEN                      OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vnum_atras WHERE tt_tit_acr.vregra = 3 AND tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.                   ELSE                      OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vnum_atras WHERE tt_tit_acr.vregra = 3 NO-LOCK INDEXED-REPOSITION.                END.                ELSE DO:                   IF l_apenas_selec THEN                      OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vdat_vencto_tit_acr WHERE tt_tit_acr.vregra = 3 AND tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.                   ELSE                      OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vdat_vencto_tit_acr WHERE tt_tit_acr.vregra = 3 NO-LOCK INDEXED-REPOSITION.                END.        END.       ELSE DO:          IF rs-opcao = 1 THEN DO:             IF l_apenas_selec THEN                OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vcod_tit_acr WHERE tt_tit_acr.vregra = 4 AND tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.             ELSE                OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vcod_tit_acr WHERE tt_tit_acr.vregra = 4 NO-LOCK INDEXED-REPOSITION.          END.          ELSE             IF rs-opcao = 2 THEN DO:                IF l_apenas_selec THEN                   OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vcdn_clien WHERE tt_tit_acr.vregra = 4 AND tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.                ELSE                   OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vcdn_clien WHERE tt_tit_acr.vregra = 4 NO-LOCK INDEXED-REPOSITION.             END.             ELSE                IF rs-opcao = 3 THEN DO:                   IF l_apenas_selec THEN                      OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vnum_atras WHERE tt_tit_acr.vregra = 4 AND tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.                   ELSE                      OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vnum_atras WHERE tt_tit_acr.vregra = 4 NO-LOCK INDEXED-REPOSITION.                END.                ELSE DO:                   IF l_apenas_selec THEN                      OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vdat_vencto_tit_acr WHERE tt_tit_acr.vregra = 4 AND tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.                   ELSE                      OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vdat_vencto_tit_acr WHERE tt_tit_acr.vregra = 4 NO-LOCK INDEXED-REPOSITION.                END.        END. END.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 tt_tit_acr
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 tt_tit_acr


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-4 rtParent rtParent-2 ~
rtToolBar btExec bt_sel_all bt_sel_nall btPrint btExit btHelp ~
v_dat_indic_perd v_cod_estab_ini v_cod_estab_fim btGoTo cb_regra l_apenas_selec rs-opcao BROWSE-1 
&Scoped-Define DISPLAYED-OBJECTS v_dat_indic_perd v_cod_estab_ini v_cod_estab_fim cb_regra l_apenas_selec ~
rs-opcao v_qtdade_tit_acr_sel v_qtdade_tit_acr v_val_sdo_tit_acr_sel ~
v_val_sdo_tit_acr 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miDetalhe      LABEL "Detalhe"        ACCELERATOR "ALT-D"
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btExec 
     IMAGE-UP FILE "image/ii-run.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-rnl.bmp":U
     LABEL "Detalhe" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY .88.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btPrint 
     IMAGE-UP FILE "image\im-pri.bmp":U
     IMAGE-INSENSITIVE FILE "image\ii-pri.bmp":U
     LABEL "Mail" 
     SIZE 4 BY 1.25.

DEFINE BUTTON bt_sel_all 
     IMAGE-UP FILE "image/im-ran_a.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-rnl.bmp":U
     LABEL "Seleciona Tudo" 
     SIZE 4 BY 1.25.

DEFINE BUTTON bt_sel_nall 
     IMAGE-UP FILE "image/im-ran_n.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-rnl.bmp":U
     LABEL "Seleciona Nada" 
     SIZE 4 BY 1.25.

DEFINE VARIABLE cb_regra AS CHARACTER FORMAT "X(45)":U INITIAL "Todas" 
     LABEL "Visualiza Regra" 
     VIEW-AS COMBO-BOX INNER-LINES 4
     LIST-ITEMS "Todas","+ de 180 dias ate R$ 15.000,00","+ de 365 dias de R$ 15.001,00 ate R$ 100.000,00","+ de 365 dias > R$ 100.000,00" 
     DROP-DOWN-LIST
     SIZE 37.57 BY 1 NO-UNDO.

DEFINE VARIABLE v_dat_indic_perd AS DATE FORMAT "99/99/9999":U 
     LABEL "Data de vencimento do t°tulo atÇ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE v_qtdade_tit_acr AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Quantidade" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .79
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE v_qtdade_tit_acr_sel AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Quantidade" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .79
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE v_val_sdo_tit_acr AS DECIMAL FORMAT "->,>>>,>>9.99":U INITIAL 0 
     LABEL "Saldo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE v_val_sdo_tit_acr_sel AS DECIMAL FORMAT "->,>>>,>>9.99":U INITIAL 0 
     LABEL "Saldo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE rs-opcao AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Titulo", 1,
"Cliente", 2,
"Num Atras", 3,
"Dat Vencto", 4,
"Dat Emis", 5
     SIZE 117.57 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 34 BY 2.75.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 119 BY 1.25
     BGCOLOR 15 .

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 34 BY 2.75.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 119 BY 1.33.

DEFINE RECTANGLE rtParent-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 119 BY 1.33.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 119 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE l_apenas_selec AS LOGICAL INITIAL no 
     LABEL "Lista Apenas Selecionados" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      tt_tit_acr SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 C-Win _FREEFORM
  QUERY BROWSE-1 NO-LOCK DISPLAY
      tt_tit_acr.selecionado          COLUMN-LABEL 'Sel  '
      tt_tit_acr.vcod_grp_clien       COLUMN-LABEL 'GrpClie'
      tt_tit_acr.vcdn_cliente
      tt_tit_acr.vnom_abrev  
      tt_tit_acr.vcod_estab
      tt_tit_acr.vcod_espec
      tt_tit_acr.vcod_ser
      tt_tit_acr.vcod_tit_acr         FORMAT 'x(12)'
      tt_tit_acr.vval_sdo_tit_acr
      tt_tit_acr.vdat_emis_tit_acr    COLUMN-LABEL 'Dat.Emiss'
      tt_tit_acr.vdat_vencto_tit_acr  COLUMN-LABEL 'Dat.Vencto'
      tt_tit_acr.vnum_atras           
      tt_tit_acr.vcont_parcelas       COLUMN-LABEL 'Nr. Parc' FORMAT 'Z9'
      tt_tit_acr.vsit_tit_acr         FORMAT 'x(45)'
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 119 BY 11.29
         FONT 1
         TITLE "T°tulos ACR" ROW-HEIGHT-CHARS .46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     btExec AT ROW 1.13 COL 2.14 HELP
          "Pesquisa"
     bt_sel_all AT ROW 1.13 COL 6.29 HELP
          "Pesquisa"
     bt_sel_nall AT ROW 1.13 COL 10.72 HELP
          "Pesquisa"
     btPrint AT ROW 1.13 COL 17 HELP
          "Pesquisa"
     btExit AT ROW 1.13 COL 111 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 115 HELP
          "Ajuda"
     v_cod_estab_ini  AT ROW 2.83 COL 05 COLON-ALIGNED
     v_cod_estab_fim  AT ROW 2.83 COL 13 COLON-ALIGNED
     v_dat_indic_perd AT ROW 2.83 COL 43 COLON-ALIGNED
     btGoTo AT ROW 2.83 COL 55.43 HELP
          "V† Para"
     cb_regra AT ROW 4.25 COL 1.85
     l_apenas_selec AT ROW 4.29 COL 52
     rs-opcao AT ROW 5.75 COL 1.72 NO-LABEL
     BROWSE-1 AT ROW 7 COL 1.14
     v_qtdade_tit_acr_sel AT ROW 19.25 COL 45.72 COLON-ALIGNED
     v_qtdade_tit_acr AT ROW 19.29 COL 11 COLON-ALIGNED
     v_val_sdo_tit_acr_sel AT ROW 20.25 COL 45.72 COLON-ALIGNED
     v_val_sdo_tit_acr AT ROW 20.29 COL 11 COLON-ALIGNED
     "Titulos Selecionados" VIEW-AS TEXT
          SIZE 15.29 BY .75 AT ROW 18.42 COL 37.72
     "Total de Titulos" VIEW-AS TEXT
          SIZE 11 BY .75 AT ROW 18.46 COL 3
     RECT-1 AT ROW 18.75 COL 1.57
     RECT-2 AT ROW 5.63 COL 1
     RECT-4 AT ROW 18.75 COL 36.29
     rtParent AT ROW 2.67 COL 1
     rtParent-2 AT ROW 4.13 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 130.29 BY 20.63
         FONT 1.


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
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Indicaá∆o para Perdas - ESACR012(1.00.00.001)"
         HEIGHT             = 20.79
         WIDTH              = 120
         MAX-HEIGHT         = 38.88
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 38.88
         VIRTUAL-WIDTH      = 182.86
         MAX-BUTTON         = no
         RESIZE             = no
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



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-1 rs-opcao DEFAULT-FRAME */
/* SETTINGS FOR COMBO-BOX cb_regra IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN v_qtdade_tit_acr IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v_qtdade_tit_acr_sel IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v_val_sdo_tit_acr IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v_val_sdo_tit_acr_sel IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _START_FREEFORM

IF v_regra_visualiz = 1 THEN DO:
   IF rs-opcao = 1 THEN DO:
      IF l_apenas_selec THEN
         OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vcod_tit_acr WHERE tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.
      ELSE
         OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vcod_tit_acr NO-LOCK INDEXED-REPOSITION.
   END.

   ELSE
      IF rs-opcao = 2 THEN DO:
         IF l_apenas_selec THEN
            OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vcdn_clien WHERE tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.
         ELSE
            OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vcdn_clien NO-LOCK INDEXED-REPOSITION.
      END.

      ELSE
         IF rs-opcao = 3 THEN DO:
            IF l_apenas_selec THEN
               OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vnum_atras WHERE tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.
            ELSE
               OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vnum_atras NO-LOCK INDEXED-REPOSITION.
         END.
         ELSE DO:
            IF l_apenas_selec THEN
               OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vdat_vencto_tit_acr WHERE tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.
            ELSE
               OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vdat_vencto_tit_acr NO-LOCK INDEXED-REPOSITION.
         END.

END.

ELSE DO:
   IF v_regra_visualiz = 2 THEN DO:
      IF rs-opcao = 1 THEN DO:
         IF l_apenas_selec THEN
            OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vcod_tit_acr WHERE tt_tit_acr.vregra = 2 AND tt_tit_acr.selecionado = l_apenas_selec AND tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.
         ELSE
            OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vcod_tit_acr WHERE tt_tit_acr.vregra = 2 AND tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.
      END.
      ELSE
         IF rs-opcao = 2 THEN DO:
            IF l_apenas_selec THEN
               OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vcdn_clien WHERE tt_tit_acr.vregra = 2 AND tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.
            ELSE
               OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vcdn_clien WHERE tt_tit_acr.vregra = 2 NO-LOCK INDEXED-REPOSITION.
         END.
         ELSE
            IF rs-opcao = 3 THEN DO:
               IF l_apenas_selec THEN
                  OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vnum_atras WHERE tt_tit_acr.vregra = 2 AND tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.
               ELSE
                  OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vnum_atras WHERE tt_tit_acr.vregra = 2 NO-LOCK INDEXED-REPOSITION.
            END.
            ELSE DO:
               IF l_apenas_selec THEN
                  OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vdat_vencto_tit_acr WHERE tt_tit_acr.vregra = 2 AND tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.
               ELSE
                  OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vdat_vencto_tit_acr WHERE tt_tit_acr.vregra = 2 NO-LOCK INDEXED-REPOSITION.
            END.
   END.
   ELSE
      IF v_regra_visualiz = 3 THEN DO:
         IF rs-opcao = 1 THEN DO:
            IF l_apenas_selec THEN
               OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vcod_tit_acr WHERE tt_tit_acr.vregra = 3 AND tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.
            ELSE
               OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vcod_tit_acr WHERE tt_tit_acr.vregra = 3 AND tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.
         END.
         ELSE
            IF rs-opcao = 2 THEN DO:
               IF l_apenas_selec THEN
                  OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vcdn_clien WHERE tt_tit_acr.vregra = 3 AND tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.
                ELSE
                  OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vcdn_clien WHERE tt_tit_acr.vregra = 3 NO-LOCK INDEXED-REPOSITION.
            END.
            ELSE
               IF rs-opcao = 3 THEN DO:
                  IF l_apenas_selec THEN
                     OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vnum_atras WHERE tt_tit_acr.vregra = 3 AND tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.
                  ELSE
                     OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vnum_atras WHERE tt_tit_acr.vregra = 3 NO-LOCK INDEXED-REPOSITION.
               END.
               ELSE DO:
                  IF l_apenas_selec THEN
                     OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vdat_vencto_tit_acr WHERE tt_tit_acr.vregra = 3 AND tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.
                  ELSE
                     OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vdat_vencto_tit_acr WHERE tt_tit_acr.vregra = 3 NO-LOCK INDEXED-REPOSITION.
               END.

      END.
      ELSE DO:
         IF rs-opcao = 1 THEN DO:
            IF l_apenas_selec THEN
               OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vcod_tit_acr WHERE tt_tit_acr.vregra = 4 AND tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.
            ELSE
               OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vcod_tit_acr WHERE tt_tit_acr.vregra = 4 NO-LOCK INDEXED-REPOSITION.
         END.
         ELSE
            IF rs-opcao = 2 THEN DO:
               IF l_apenas_selec THEN
                  OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vcdn_clien WHERE tt_tit_acr.vregra = 4 AND tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.
               ELSE
                  OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vcdn_clien WHERE tt_tit_acr.vregra = 4 NO-LOCK INDEXED-REPOSITION.
            END.
            ELSE
               IF rs-opcao = 3 THEN DO:
                  IF l_apenas_selec THEN
                     OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vnum_atras WHERE tt_tit_acr.vregra = 4 AND tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.
                  ELSE
                     OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vnum_atras WHERE tt_tit_acr.vregra = 4 NO-LOCK INDEXED-REPOSITION.
               END.
               ELSE DO:
                  IF l_apenas_selec THEN
                     OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vdat_vencto_tit_acr WHERE tt_tit_acr.vregra = 4 AND tt_tit_acr.selecionado = l_apenas_selec NO-LOCK INDEXED-REPOSITION.
                  ELSE
                     OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr USE-INDEX vdat_vencto_tit_acr WHERE tt_tit_acr.vregra = 4 NO-LOCK INDEXED-REPOSITION.
               END.

      END.
END.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "movto_tit_acr.cdn_cliente = INTEGER(cod-cliente)
 AND movto_tit_acr.dat_transacao >= fi_dat_transacao
 AND movto_tit_acr.dat_transacao <= i-movto_tit_acredfim"
     _Query            is NOT OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Indicaá∆o para Perdas - ESACR012(1.00.00.001) */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Indicaá∆o para Perdas - ESACR012(1.00.00.001) */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&Scoped-define SELF-NAME BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 C-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-1 IN FRAME DEFAULT-FRAME /* T°tulos ACR */
OR RETURN OF {&BROWSE-NAME} IN FRAME {&FRAME-NAME} DO:
    RUN pi-seleciona IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExec C-Win
ON CHOOSE OF btExec IN FRAME DEFAULT-FRAME /* Detalhe */
DO:
   RUN pi_valid_selec.

   IF RETURN-VALUE <> 'NOK' THEN DO:
      FOR EACH tt_tit_acr EXCLUSIVE-LOCK
        WHERE tt_tit_acr.selecionado = YES: 
        FOR EACH tit_acr EXCLUSIVE-LOCK
          WHERE tit_acr.cod_estab       = tt_tit_acr.vcod_estab
          AND   tit_acr.cod_espec_docto = tt_tit_acr.vcod_espec
          AND   tit_acr.cod_ser_docto   = tt_tit_acr.vcod_ser
          AND   tit_acr.cod_tit_acr     = tt_tit_acr.vcod_tit_acr:
    
          ASSIGN v_hra_indcao = STRING(TIME, "hh:mm:ss")
                 tit_acr.dat_indcao_perda_dedut = v_dat_indic_perd
                 tit_acr.hra_indcao_perda_dedut = substring(v_hra_indcao,1,2) + substring(v_hra_indcao,4,2) + substring(v_hra_indcao,7,2)
                 tit_acr.cod_usuar_indcao_perda = v_cod_usuar_corren.
    
          RUN pi_cria_histor. /*cria historico*/
        END.
        
      END. /*FOR EACH tt_tit_acr EXCLUSIVE-LOCK*/

      RUN pi_deleta_temp-table.

      {&OPEN-QUERY-{&BROWSE-NAME}}

   END. /*IF RETURN-VALUE <> 'NOK' THEN DO:*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit C-Win
ON CHOOSE OF btExit IN FRAME DEFAULT-FRAME /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo C-Win
ON CHOOSE OF btGoTo IN FRAME DEFAULT-FRAME /* Go To */
DO:
    RUN pi_deleta_temp-table.

    ASSIGN INPUT FRAME {&FRAME-NAME} v_dat_indic_perd
           INPUT FRAME {&FRAME-NAME} v_cod_estab_ini 
           INPUT FRAME {&FRAME-NAME} v_cod_estab_fim
           INPUT FRAME {&FRAME-NAME} cb_regra
           v_qtdade_tit_acr_sel  = 0   
           v_val_sdo_tit_acr_sel = 0.

    DISP v_qtdade_tit_acr_sel     
         v_val_sdo_tit_acr_sel WITH FRAME {&FRAME-NAME}.

    IF cb_regra  = 'Todas' THEN
       ASSIGN v_regra_visualiz = 1.
    IF cb_regra  = '+ de 180 dias ate R$ 5.000,00' THEN
       ASSIGN v_regra_visualiz = 2.
    IF cb_regra  = '+ de 365 dias de R$ 5.001,00 ate R$ 30.000,00' THEN
       ASSIGN v_regra_visualiz = 3.
    IF cb_regra  = '+ de 365 dias > R$ 30.000,00' THEN
       ASSIGN v_regra_visualiz = 4.
  
    RUN pi-gera-tt IN THIS-PROCEDURE.
    
    {&OPEN-QUERY-{&BROWSE-NAME}}
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrint
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrint C-Win
ON CHOOSE OF btPrint IN FRAME DEFAULT-FRAME /* Mail */
DO:
  RUN pi-print.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_sel_all
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_sel_all C-Win
ON CHOOSE OF bt_sel_all IN FRAME DEFAULT-FRAME /* Seleciona Tudo */
DO:
  ASSIGN INPUT FRAME {&FRAME-NAME} v_dat_indic_perd
         INPUT FRAME {&FRAME-NAME} v_cod_estab_ini 
         INPUT FRAME {&FRAME-NAME} v_cod_estab_fim
         INPUT FRAME {&FRAME-NAME} cb_regra. 

  IF v_regra_visualiz = 1 THEN DO:
     IF rs-opcao = 1 THEN
        FOR EACH tt_tit_acr USE-INDEX vcod_tit_acr WHERE tt_tit_acr.selecionado = NO EXCLUSIVE-LOCK:
            ASSIGN tt_tit_acr.selecionado = YES
                   v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  + 1
                   v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel + vval_sdo_tit_acr.
        END.
      ELSE
        IF rs-opcao = 2 THEN
           FOR EACH tt_tit_acr USE-INDEX vcdn_clien WHERE tt_tit_acr.selecionado = NO exclusive-LOCK:
               ASSIGN tt_tit_acr.selecionado = YES
                      v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  + 1               
                      v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel + vval_sdo_tit_acr.
           END.
        ELSE
           IF rs-opcao = 3 THEN
              FOR EACH tt_tit_acr USE-INDEX vnum_atras WHERE tt_tit_acr.selecionado = NO EXCLUSIVE-LOCK:
                  ASSIGN tt_tit_acr.selecionado = YES
                         v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  + 1               
                         v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel + vval_sdo_tit_acr.
              END.
           ELSE
              FOR EACH tt_tit_acr USE-INDEX vdat_vencto_tit_acr WHERE tt_tit_acr.selecionado = NO EXCLUSIVE-LOCK: 
                  ASSIGN tt_tit_acr.selecionado = YES
                         v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  + 1               
                         v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel + vval_sdo_tit_acr.
              END.
  END.
  
  ELSE DO:
     IF v_regra_visualiz = 2 THEN DO:
        IF rs-opcao = 1 THEN
           FOR EACH tt_tit_acr USE-INDEX vcod_tit_acr WHERE tt_tit_acr.vregra = 2 AND tt_tit_acr.selecionado = NO EXCLUSIVE-LOCK:
               ASSIGN tt_tit_acr.selecionado = YES
                      v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  + 1               
                      v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel + vval_sdo_tit_acr.
           END.
        ELSE
           IF rs-opcao = 2 THEN
              FOR EACH tt_tit_acr USE-INDEX vcdn_clien WHERE tt_tit_acr.vregra = 2 AND tt_tit_acr.selecionado = NO EXCLUSIVE-LOCK:
                  ASSIGN tt_tit_acr.selecionado = YES
                         v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  + 1               
                         v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel + vval_sdo_tit_acr.
              END.
           ELSE
              IF rs-opcao = 3 THEN
                 FOR EACH tt_tit_acr USE-INDEX vnum_atras WHERE tt_tit_acr.vregra = 2 AND tt_tit_acr.selecionado = NO EXCLUSIVE-LOCK:
                     ASSIGN tt_tit_acr.selecionado = YES
                            v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  + 1               
                            v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel + vval_sdo_tit_acr.
                 END.
              ELSE
                  FOR EACH tt_tit_acr USE-INDEX vdat_vencto_tit_acr WHERE tt_tit_acr.vregra = 2 AND tt_tit_acr.selecionado = NO EXCLUSIVE-LOCK:
                       ASSIGN tt_tit_acr.selecionado = YES
                              v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  + 1               
                              v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel + vval_sdo_tit_acr.
                  END.
  
     END.
     ELSE
        IF v_regra_visualiz = 3 THEN DO:
           IF rs-opcao = 1 THEN
               FOR EACH tt_tit_acr USE-INDEX vcod_tit_acr WHERE tt_tit_acr.vregra = 3 AND tt_tit_acr.selecionado = NO EXCLUSIVE-LOCK:
                   ASSIGN tt_tit_acr.selecionado = YES
                          v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  + 1               
                          v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel + vval_sdo_tit_acr.
               END.
           ELSE
              IF rs-opcao = 2 THEN
                  FOR EACH tt_tit_acr USE-INDEX vcdn_clien WHERE tt_tit_acr.vregra = 3 AND tt_tit_acr.selecionado = NO EXCLUSIVE-LOCK:
                      ASSIGN tt_tit_acr.selecionado = YES 
                             v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  + 1               
                             v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel + vval_sdo_tit_acr.
                  END.
              ELSE
                 IF rs-opcao = 3 THEN
                    FOR EACH tt_tit_acr USE-INDEX vnum_atras WHERE tt_tit_acr.vregra = 3 AND tt_tit_acr.selecionado = NO EXCLUSIVE-LOCK:
                        ASSIGN tt_tit_acr.selecionado = YES
                               v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  + 1               
                               v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel + vval_sdo_tit_acr.
                    END.
                 ELSE
                     FOR EACH tt_tit_acr USE-INDEX vdat_vencto_tit_acr WHERE tt_tit_acr.vregra = 3 AND tt_tit_acr.selecionado = NO EXCLUSIVE-LOCK:
                         ASSIGN tt_tit_acr.selecionado = YES
                                v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  + 1               
                                v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel + vval_sdo_tit_acr.
                     END.
        END.
        ELSE DO:
           IF rs-opcao = 1 THEN
               FOR EACH tt_tit_acr USE-INDEX vcod_tit_acr WHERE tt_tit_acr.vregra = 4 AND tt_tit_acr.selecionado = NO EXCLUSIVE-LOCK:
                   ASSIGN tt_tit_acr.selecionado = YES
                          v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  + 1               
                          v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel + vval_sdo_tit_acr.
               END.
           ELSE
              IF rs-opcao = 2 THEN
                  FOR EACH tt_tit_acr USE-INDEX vcdn_clien WHERE tt_tit_acr.vregra = 4 AND tt_tit_acr.selecionado = NO EXCLUSIVE-LOCK:
                      ASSIGN tt_tit_acr.selecionado = YES
                             v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  + 1               
                             v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel + vval_sdo_tit_acr.
                  END.
              ELSE
                 IF rs-opcao = 3 THEN
                    FOR EACH tt_tit_acr USE-INDEX vnum_atras WHERE tt_tit_acr.vregra = 4 AND tt_tit_acr.selecionado = NO EXCLUSIVE-LOCK:
                        ASSIGN tt_tit_acr.selecionado = YES
                               v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  + 1               
                               v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel + vval_sdo_tit_acr.
                    END.  
                 ELSE
                     FOR EACH tt_tit_acr USE-INDEX vdat_vencto_tit_acr WHERE tt_tit_acr.vregra = 4 AND tt_tit_acr.selecionado = NO EXCLUSIVE-LOCK:
                         ASSIGN tt_tit_acr.selecionado = YES
                                v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  + 1               
                                v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel + vval_sdo_tit_acr.
                     END.
  
        END.
  END.

  DISP v_qtdade_tit_acr_sel 
       v_val_sdo_tit_acr_sel WITH FRAME {&FRAME-NAME}.
  {&OPEN-QUERY-{&BROWSE-NAME}}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_sel_nall
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_sel_nall C-Win
ON CHOOSE OF bt_sel_nall IN FRAME DEFAULT-FRAME /* Seleciona Nada */
DO:
  
  ASSIGN INPUT FRAME {&FRAME-NAME} v_dat_indic_perd
         INPUT FRAME {&FRAME-NAME} v_cod_estab_ini 
         INPUT FRAME {&FRAME-NAME} v_cod_estab_fim
         INPUT FRAME {&FRAME-NAME} cb_regra.  
      
  IF v_regra_visualiz = 1 THEN DO:
     IF rs-opcao = 1 THEN
        FOR EACH tt_tit_acr USE-INDEX vcod_tit_acr  WHERE tt_tit_acr.selecionado = YES EXCLUSIVE-LOCK:
            ASSIGN tt_tit_acr.selecionado = NO
                   v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  - 1               
                   v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel - vval_sdo_tit_acr.
        END.
      ELSE
        IF rs-opcao = 2 THEN
           FOR EACH tt_tit_acr USE-INDEX vcdn_clien WHERE tt_tit_acr.selecionado = YES EXCLUSIVE-LOCK:
               ASSIGN tt_tit_acr.selecionado = NO
                      v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  - 1               
                      v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel - vval_sdo_tit_acr.
           END.
        ELSE
           IF rs-opcao = 3 THEN
              FOR EACH tt_tit_acr USE-INDEX vnum_atras WHERE tt_tit_acr.selecionado = YES EXCLUSIVE-LOCK:
                  ASSIGN tt_tit_acr.selecionado = NO
                         v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  - 1               
                         v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel - vval_sdo_tit_acr.
              END.
           ELSE
              FOR EACH tt_tit_acr USE-INDEX vdat_vencto_tit_acr WHERE tt_tit_acr.selecionado = YES EXCLUSIVE-LOCK: 
                  ASSIGN tt_tit_acr.selecionado = NO
                         v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  - 1               
                         v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel - vval_sdo_tit_acr.
              END.
  END.
  
  ELSE DO:
     IF v_regra_visualiz = 2 THEN DO:
        IF rs-opcao = 1 THEN
           FOR EACH tt_tit_acr USE-INDEX vcod_tit_acr WHERE tt_tit_acr.vregra = 2 AND tt_tit_acr.selecionado = YES EXCLUSIVE-LOCK:
               ASSIGN tt_tit_acr.selecionado = NO
                      v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  - 1               
                      v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel - vval_sdo_tit_acr.
           END.
        ELSE
           IF rs-opcao = 2 THEN
              FOR EACH tt_tit_acr USE-INDEX vcdn_clien WHERE tt_tit_acr.vregra = 2 AND tt_tit_acr.selecionado = YES EXCLUSIVE-LOCK:
                  ASSIGN tt_tit_acr.selecionado = NO
                         v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  - 1               
                         v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel - vval_sdo_tit_acr.
              END.
           ELSE
              IF rs-opcao = 3 THEN
                 FOR EACH tt_tit_acr USE-INDEX vnum_atras WHERE tt_tit_acr.vregra = 2 AND tt_tit_acr.selecionado = YES EXCLUSIVE-LOCK:
                     ASSIGN tt_tit_acr.selecionado = NO
                            v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  - 1               
                            v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel - vval_sdo_tit_acr.
                 END.
              ELSE
                  FOR EACH tt_tit_acr USE-INDEX vdat_vencto_tit_acr WHERE tt_tit_acr.vregra = 2 AND tt_tit_acr.selecionado = YES EXCLUSIVE-LOCK:
                       ASSIGN tt_tit_acr.selecionado = NO
                              v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  - 1               
                              v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel - vval_sdo_tit_acr.
                  END.
  
     END.
     ELSE
        IF v_regra_visualiz = 3 THEN DO:
           IF rs-opcao = 1 THEN
               FOR EACH tt_tit_acr USE-INDEX vcod_tit_acr WHERE tt_tit_acr.vregra = 3 AND tt_tit_acr.selecionado = YES EXCLUSIVE-LOCK:
                   ASSIGN tt_tit_acr.selecionado = NO
                          v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  - 1               
                          v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel - vval_sdo_tit_acr.
               END.
           ELSE
              IF rs-opcao = 2 THEN
                  FOR EACH tt_tit_acr USE-INDEX vcdn_clien WHERE tt_tit_acr.vregra = 3 AND tt_tit_acr.selecionado = YES EXCLUSIVE-LOCK:
                      ASSIGN tt_tit_acr.selecionado = NO
                             v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  - 1               
                             v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel - vval_sdo_tit_acr.
                  END.
              ELSE
                 IF rs-opcao = 3 THEN
                    FOR EACH tt_tit_acr USE-INDEX vnum_atras WHERE tt_tit_acr.vregra = 3 AND tt_tit_acr.selecionado = YES EXCLUSIVE-LOCK:
                        ASSIGN tt_tit_acr.selecionado = NO
                               v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  - 1               
                               v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel - vval_sdo_tit_acr.
                    END.
                 ELSE
                     FOR EACH tt_tit_acr USE-INDEX vdat_vencto_tit_acr WHERE tt_tit_acr.vregra = 3 AND tt_tit_acr.selecionado = YES EXCLUSIVE-LOCK:
                         ASSIGN tt_tit_acr.selecionado = NO 
                                v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  - 1               
                                v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel - vval_sdo_tit_acr.
                     END.
        END.
        ELSE DO:
           IF rs-opcao = 1 THEN
               FOR EACH tt_tit_acr USE-INDEX vcod_tit_acr WHERE tt_tit_acr.vregra = 4 AND tt_tit_acr.selecionado = YES EXCLUSIVE-LOCK:
                   ASSIGN tt_tit_acr.selecionado = NO 
                          v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  - 1               
                          v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel - vval_sdo_tit_acr.
               END.
           ELSE
              IF rs-opcao = 2 THEN
                  FOR EACH tt_tit_acr USE-INDEX vcdn_clien WHERE tt_tit_acr.vregra = 4 AND tt_tit_acr.selecionado = YES EXCLUSIVE-LOCK:
                      ASSIGN tt_tit_acr.selecionado = NO
                             v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  - 1               
                             v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel - vval_sdo_tit_acr.
                  END.
              ELSE
                 IF rs-opcao = 3 THEN
                    FOR EACH tt_tit_acr USE-INDEX vnum_atras WHERE tt_tit_acr.vregra = 4 AND tt_tit_acr.selecionado = YES EXCLUSIVE-LOCK:
                        ASSIGN tt_tit_acr.selecionado = NO
                               v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  - 1               
                               v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel - vval_sdo_tit_acr.
                    END.  
                 ELSE
                     FOR EACH tt_tit_acr USE-INDEX vdat_vencto_tit_acr WHERE tt_tit_acr.vregra = 4 AND tt_tit_acr.selecionado = YES EXCLUSIVE-LOCK:
                         ASSIGN tt_tit_acr.selecionado = NO
                                v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  - 1               
                                v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel - vval_sdo_tit_acr.
                     END.
  
        END.
  END.
  
  DISP v_qtdade_tit_acr_sel  
       v_val_sdo_tit_acr_sel WITH FRAME {&FRAME-NAME}.
  

{&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb_regra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb_regra C-Win
ON VALUE-CHANGED OF cb_regra IN FRAME DEFAULT-FRAME /* Visualiza Regra */
DO:
  ASSIGN INPUT FRAME {&FRAME-NAME} cb_regra.

  IF cb_regra  = 'Todas' THEN
     ASSIGN v_regra_visualiz = 1.
  IF cb_regra  = '+ de 180 dias ate R$ 5.000,00' THEN
     ASSIGN v_regra_visualiz = 2.
  IF cb_regra  = '+ de 365 dias de R$ 5.001,00 ate R$ 30.000,00' THEN
     ASSIGN v_regra_visualiz = 3.
  IF cb_regra  = '+ de 365 dias > R$ 30.000,00' THEN
     ASSIGN v_regra_visualiz = 4.
  
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l_apenas_selec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l_apenas_selec C-Win
ON VALUE-CHANGED OF l_apenas_selec IN FRAME DEFAULT-FRAME /* Lista Apenas Selecionados */
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME} l_apenas_selec.

    {&OPEN-QUERY-{&BROWSE-NAME}}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miDetalhe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miDetalhe C-Win
ON CHOOSE OF MENU-ITEM miDetalhe /* Detalhe */
DO:
    RUN pi-detalhe IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-opcao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-opcao C-Win
ON VALUE-CHANGED OF rs-opcao IN FRAME DEFAULT-FRAME
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME} rs-opcao.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


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

    ASSIGN v_dat_indic_perd = TODAY
           v_cod_estab_ini  = v_cod_estab_usuar
           v_cod_estab_fim  = v_cod_estab_usuar.

    RUN enable_UI.

    IF NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
  DISPLAY v_dat_indic_perd v_cod_estab_ini v_cod_estab_fim cb_regra l_apenas_selec rs-opcao v_qtdade_tit_acr_sel 
          v_qtdade_tit_acr v_val_sdo_tit_acr_sel v_val_sdo_tit_acr 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE RECT-1 RECT-2 RECT-4 rtParent rtParent-2 rtToolBar btExec bt_sel_all 
         bt_sel_nall btPrint btExit btHelp v_dat_indic_perd v_cod_estab_ini v_cod_estab_fim btGoTo cb_regra 
         l_apenas_selec rs-opcao BROWSE-1 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-tt C-Win 
PROCEDURE pi-gera-tt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN v_qtdade_tit_acr  = 0
           v_val_sdo_tit_acr = 0.

    FOR EACH estabelecimento NO-LOCK
        WHERE estabelecimento.cod_empresa  = v_cod_empres_usuar
          AND estabelecimento.cod_estab   >= v_cod_estab_ini
          AND estabelecimento.cod_estab   <= v_cod_estab_fim:

        FOR EACH tit_acr USE-INDEX titacr_sdo_perdas
            WHERE tit_acr.cod_estab        =  estabelecimento.cod_estab
              AND tit_acr.log_sdo_tit_acr  = YES
              AND dat_indcao_perda_dedut          = 12/31/9999:

              IF tit_acr.dat_vencto_tit_acr > v_dat_indic_perd THEN NEXT.

              IF tit_acr.cod_espec_docto <> "DP" AND
                 tit_acr.cod_espec_docto <> "DM" AND 
                 tit_acr.cod_espec_docto <> "VD" AND  
                 tit_acr.cod_espec_docto <> "VC" and
                 tit_acr.cod_espec_docto <> "IN" THEN NEXT.

              FIND FIRST tt_tit_acr NO-LOCK
                 WHERE tt_tit_acr.vcod_estab   = tit_acr.cod_estab
                 AND   tt_tit_acr.vcod_espec   = tit_acr.cod_espec_docto
                 AND   tt_tit_acr.vcod_ser     = tit_acr.cod_ser_docto
                 AND   tt_tit_acr.vcod_tit_acr = tit_acr.cod_tit_acr 
                 NO-ERROR.
              IF NOT AVAIL tt_tit_acr THEN DO:
                 CREATE tt_tit_acr.
                 ASSIGN tt_tit_acr.vdat_vencto_tit_acr = 01/01/0001
                        tt_tit_acr.vdat_emis_tit_acr   = 12/31/9999
                        tt_tit_acr.vcod_estab       = tit_acr.cod_estab      
                        tt_tit_acr.vcod_espec       = tit_acr.cod_espec_docto
                        tt_tit_acr.vcod_ser         = tit_acr.cod_ser_docto  
                        tt_tit_acr.vcod_tit_acr     = tit_acr.cod_tit_acr
                        tt_tit_acr.cod_portad       = tit_acr.cod_portad
                        v_qtdade_tit_acr            = v_qtdade_tit_acr + 1.
              END.
              FIND FIRST emsuni.cliente NO-LOCK 
                  WHERE emsuni.cliente.cod_empresa = tit_acr.cod_empresa
                  AND   emsuni.cliente.cdn_cliente = tit_acr.cdn_cliente NO-ERROR.

              ASSIGN tt_tit_acr.vval_sdo_tit_acr = tt_tit_acr.vval_sdo_tit_acr + tit_acr.val_sdo_tit_acr 
                     tt_tit_acr.vcod_parcela     = tit_acr.cod_parcela
                     tt_tit_acr.vcont_parcelas   = vcont_parcelas + 1
                     tt_tit_acr.vcdn_cliente     = tit_acr.cdn_cliente
                     tt_tit_acr.vcod_grp_clien   = IF AVAIL cliente THEN emsuni.cliente.cod_grp_clien ELSE ''
                     tt_tit_acr.vnom_abrev       = tit_acr.nom_abrev
                     tt_tit_acr.selecionado      = NO
                     v_val_sdo_tit_acr           = v_val_sdo_tit_acr + tit_acr.val_sdo_tit_acr.


              IF tit_acr.dat_vencto_tit_acr > tt_tit_acr.vdat_vencto_tit_acr THEN
                ASSIGN tt_tit_acr.vdat_vencto_tit_acr = tit_acr.dat_vencto_tit_acr.

              IF tit_acr.dat_emis_docto < tt_tit_acr.vdat_emis_tit_acr THEN
                ASSIGN tt_tit_acr.vdat_emis_tit_acr = tit_acr.dat_emis_docto.

        END. /*FOR EACH tit_acr USE-INDEX titacr_sdo_perdas*/

    END.

    /*PUT "Titulos vencidos a + de 180 dias ate R$ 5.000,00" skip.*/
    FOR EACH tt_tit_acr
       WHERE tt_tit_acr.vdat_vencto_tit_acr <= v_dat_indic_perd - 180
       AND   tt_tit_acr.vval_sdo_tit_acr <= 15000:
       ASSIGN tt_tit_acr.vsit_tit_acr = '+ 180 atÇ R$15.000,00'
              tt_tit_acr.vnum_atras   = v_dat_indic_perd - tt_tit_acr.vdat_vencto_tit_acr
              tt_tit_acr.vregra       = 2.
    END.

    /*PUT "Titulos vencidos a + de 365 dias de R$ 5.001,00 ate R$ 30.000,00".*/
    FOR EACH tt_tit_acr
      WHERE tt_tit_acr.vdat_vencto_tit_acr <= v_dat_indic_perd - 365
      AND   tt_tit_acr.vval_sdo_tit_acr > 15000
      AND   tt_tit_acr.vval_sdo_tit_acr <= 100000:
      ASSIGN tt_tit_acr.vsit_tit_acr = '+ 365 de R$ 15.001,00 atÇ R$100.000,00'
             tt_tit_acr.vnum_atras   = v_dat_indic_perd - tt_tit_acr.vdat_vencto_tit_acr
             tt_tit_acr.vregra       = 3.
    END.

    /*put "Titulos vencidos a + de 365 dias > R$ 30.000,00".*/
    FOR EACH tt_tit_acr
      WHERE tt_tit_acr.vdat_vencto_tit_acr <= v_dat_indic_perd - 365
      AND   tt_tit_acr.vval_sdo_tit_acr > 100000:

      IF  tt_tit_acr.cod_portad <> "9947" THEN
          NEXT.

      ASSIGN tt_tit_acr.vsit_tit_acr = '+ 365 > R$100.000,00'
             tt_tit_acr.vnum_atras   = v_dat_indic_perd - tt_tit_acr.vdat_vencto_tit_acr
             tt_tit_acr.vregra       = 4.
    END.

    /*Elimina t°tulos que n∆o entraram nas regras*/
    FOR EACH tt_tit_acr EXCLUSIVE-LOCK
        WHERE tt_tit_acr.vsit_tit_acr = '':
        ASSIGN v_qtdade_tit_acr  = v_qtdade_tit_acr  - 1
               v_val_sdo_tit_acr = v_val_sdo_tit_acr - tt_tit_acr.vval_sdo_tit_acr.
        DELETE tt_tit_acr.
    END.

    DISP v_qtdade_tit_acr
         v_val_sdo_tit_acr WITH FRAME {&FRAME-NAME}.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-print C-Win 
PROCEDURE pi-print :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hWindow AS HANDLE     NO-UNDO.
    ASSIGN hWindow = CURRENT-WINDOW.

    ASSIGN hWindow:SENSITIVE = NO.
    ASSIGN INPUT FRAME {&FRAME-NAME} rs-opcao.
    
    RUN esp\acr\esacr012a.w(INPUT TABLE tt_tit_acr,
                            INPUT rs-opcao ).

    ASSIGN hWindow:SENSITIVE = YES.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seleciona C-Win 
PROCEDURE pi-seleciona :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF tt_tit_acr.selecionado = NO THEN DO:
     ASSIGN tt_tit_acr.selecionado = YES
            v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  + 1               
            v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel + vval_sdo_tit_acr.
  END.
  ELSE DO: 
     ASSIGN tt_tit_acr.selecionado = NO
            v_qtdade_tit_acr_sel   = v_qtdade_tit_acr_sel  - 1               
            v_val_sdo_tit_acr_sel  = v_val_sdo_tit_acr_sel - vval_sdo_tit_acr.
  END.

  DISP  v_qtdade_tit_acr_sel   
        v_val_sdo_tit_acr_sel WITH FRAME {&FRAME-NAME}.

  SELF:REFRESH().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_cria_histor C-Win 
PROCEDURE pi_cria_histor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND LAST movto_tit_acr NO-LOCK
        WHERE movto_tit_acr.cod_estab         = tit_acr.cod_estab
        AND   movto_tit_acr.num_id_tit_acr    = tit_acr.num_id_tit_acr
        AND  (movto_tit_acr.ind_trans_acr     = "Implantaá∆o" 
        OR    movto_tit_acr.ind_trans_acr     = "Renegociaá∆o")
        AND   movto_tit_acr.log_movto_estordo = NO NO-ERROR.

    IF AVAIL movto_tit_acr THEN DO:
       FIND LAST b_histor_movto_tit_acr NO-LOCK
           WHERE b_histor_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab
           AND   b_histor_movto_tit_acr.num_id_tit_acr       = movto_tit_acr.num_id_tit_acr
           AND   b_histor_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr NO-ERROR.

       CREATE histor_movto_tit_acr.
       ASSIGN histor_movto_tit_acr.cod_estab                   = movto_tit_acr.cod_estab
              histor_movto_tit_acr.num_id_tit_acr              = movto_tit_acr.num_id_tit_acr
              histor_movto_tit_acr.num_id_movto_tit_acr        = movto_tit_acr.num_id_movto_tit_acr
              histor_movto_tit_acr.num_seq_histor_movto_acr    = IF AVAIL b_histor_movto_tit_acr THEN (b_histor_movto_tit_acr.num_seq_histor_movto_acr + 1) ELSE 1
              histor_movto_tit_acr.ind_orig_histor_acr         = "Sistema"
              histor_movto_tit_acr.des_text_histor = "O T°tulo foi indicado para Perda Dedut°vel na data "    + 
                                                      STRING(v_dat_indic_perd) + " " + LC("Pelo Usu†rio")     + 
                                                      " " + CAPS(v_cod_usuar_corren) + " em " + STRING(TODAY) + 
                                                      " as " + STRING(TIME,'hh:mm:ss') +
                                                      ".".
       
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_deleta_temp-table C-Win 
PROCEDURE pi_deleta_temp-table :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH tt_tit_acr EXCLUSIVE-LOCK:
    DELETE tt_tit_acr.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_valid_selec C-Win 
PROCEDURE pi_valid_selec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN INPUT FRAME {&FRAME-NAME} v_dat_indic_perd
           INPUT FRAME {&FRAME-NAME} v_cod_estab_ini 
           INPUT FRAME {&FRAME-NAME} v_cod_estab_fim.

    IF NOT CAN-FIND(FIRST tt_tit_acr WHERE tt_tit_acr.selecionado) THEN DO:
        MESSAGE 'Deve haver ao menos um t°tulo selecionado para a alteraá∆o.'
            VIEW-AS ALERT-BOX ERROR TITLE 'Erro alteraá∆o t°tulos'.
        RETURN 'NOK'.
    END.

    RETURN 'OK'.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

