&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          emsfnd           PROGRESS
*/
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
def var v_cod_dwb_program
    as character
    format "x(32)":U
    label "Programa"
    column-label "Programa"
    no-undo.
def new global shared var v_cod_dwb_user
    as character
    format "x(21)":U
    label "Usu†rio"
    column-label "Usu†rio"
    no-undo.
def new global shared var v_cod_arq
    as char  
    format 'x(60)'
    no-undo.
def new global shared var v_cod_tip_prog
    as character
    format 'x(8)'
    no-undo.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
def var v_cod_dwb_file
    as character
    format "x(40)":U
    label "Arquivo"
    column-label "Arquivo"
    no-undo.
def var v_cod_release
    as character
    format "x(12)":U
    no-undo.
def var v_rpt_s_1_lines as integer initial 66.
def var v_rpt_s_1_columns as integer initial 255.
def var v_rpt_s_1_bottom as integer initial 65.
def var v_rpt_s_1_page as integer.
def var v_num_entry
    as integer
    format ">>>>,>>9":U
    label "Ordem"
    column-label "Ordem"
    no-undo.
def var v_cod_dwb_select
    as character
    format "x(32)":U
    no-undo.
def var v_nom_enterprise
    as character
    format "x(40)":U
    no-undo.
def var v_cod_dat_type
    as character
    format "x(8)":U
    no-undo.
def var v_cod_format
    as character
    format "x(8)":U
    label "Formato"
    column-label "Formato"
    no-undo.
def var v_cod_final
    as character
    format "x(8)":U
    initial ?
    label "Final"
    no-undo.
def var v_cod_initial
    as character
    format "x(8)":U
    initial ?
    label "Inicial"
    no-undo.

def stream s-arq.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var c-versao-prg as char initial " 1.00.01.001":U no-undo.
def var v_rec_log
    as recid
    format ">>>>>>9":U
    no-undo.
def var v_nom_dwb_printer
    as character
    format "x(30)":U
    no-undo.
def var v_cod_dwb_print_layout
    as character
    format "x(8)":U
    no-undo.
def var v_nom_dwb_print_file
    as character
    format "x(100)":U
    label "Arquivo Impressío"
    column-label "Arq Impr"
    no-undo.
def var v_qtd_line_ant
    as decimal
    format "->>>>,>>9.9999":U
    decimals 4
    no-undo.
def var v_cod_dwb_file_old
    as character
    format "x(50)":U
    label "Arquivo Externo"
    column-label "Arquivo Externo"
    no-undo.
def var v_cod_dwb_file_temp
    as character
    format "x(12)":U
    no-undo.
def var v_cod_dwb_proced
    as character
    format "x(8)":U
    no-undo.
def var v_cod_dwb_parameters
    as character
    format "x(8)":U
    no-undo.
def var v_cod_dwb_order
    as character
    format "x(32)":U
    label "Classificaá∆o"
    column-label "Classificador"
    no-undo.
def var v_cod_dwb_field
    as character
    format "x(32)":U
    no-undo.
def var v_log_method
    as logical
    format "Sim/N∆o"
    initial yes
    no-undo.
def var v_ind_dwb_run_mode
    as character
    no-undo.
def var v_qtd_bottom
    as decimal
    format ">>9":U
    decimals 0
    no-undo.
def var v_nom_title_aux
    as character
    format "x(60)":U
    no-undo.
def var v_nom_integer
    as character
    format "x(30)":U
    no-undo.
def var v_num_ped_exec
    as integer
    format ">>>>9":U
    label "Pedido"
    column-label "Pedido"
    no-undo.

{src/adm2/widgetprto.i}

def query qr_dwb_rpt_select
    for dwb_rpt_select
    scrolling.

{include/i_dbinst.i}
{include/i_dbtype.i}
{include/i_fcldef.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain
&Scoped-define BROWSE-NAME br_dwb_rpt_select

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES dwb_rpt_select

/* Definitions for BROWSE br_dwb_rpt_select                             */
&Scoped-define FIELDS-IN-QUERY-br_dwb_rpt_select if dwb_rpt_select.log_dwb_rule then "Regra" else "Exceá∆o" dwb_rpt_select.cod_dwb_field dwb_rpt_select.cod_dwb_initial dwb_rpt_select.cod_dwb_final   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_dwb_rpt_select   
&Scoped-define SELF-NAME br_dwb_rpt_select
&Scoped-define QUERY-STRING-br_dwb_rpt_select for         each dwb_rpt_select no-lock         where dwb_rpt_select.cod_dwb_program = v_cod_dwb_program           and dwb_rpt_select.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_select of dwb_rpt_select*/             by dwb_rpt_select.log_dwb_rule descending             by dwb_rpt_select.num_dwb_order
&Scoped-define OPEN-QUERY-br_dwb_rpt_select open query qr_dwb_rpt_select for         each dwb_rpt_select no-lock         where dwb_rpt_select.cod_dwb_program = v_cod_dwb_program           and dwb_rpt_select.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_select of dwb_rpt_select*/             by dwb_rpt_select.log_dwb_rule descending             by dwb_rpt_select.num_dwb_order.
&Scoped-define TABLES-IN-QUERY-br_dwb_rpt_select dwb_rpt_select
&Scoped-define FIRST-TABLE-IN-QUERY-br_dwb_rpt_select dwb_rpt_select


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-br_dwb_rpt_select}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS ls_order br_dwb_rpt_select bt_isl1 bt_up ~
bt_edl1 bt_down bt_rml1 v_log_lista_sem_nfe rs_cod_dwb_output ~
v_log_gera_csv ed_1x40 bt_set_printer bt_get_file rs_ind_run_mode ~
v_qtd_line v_log_print_par v_qtd_column bt_close bt_print bt_can bt_hel2 
&Scoped-Define DISPLAYED-OBJECTS ls_order v_log_lista_sem_nfe ~
rs_cod_dwb_output v_log_gera_csv ed_1x40 rs_ind_run_mode v_qtd_line ~
v_log_print_par v_qtd_column 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU m_help 
       MENU-ITEM mi_conteudo    LABEL "&Conte£do"     
       MENU-ITEM mi_sobre       LABEL "&Sobre"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt_can AUTO-END-KEY 
     LABEL "Cancela" 
     SIZE 10 BY 1 TOOLTIP "Cancela".

DEFINE BUTTON bt_close AUTO-GO 
     LABEL "&Fecha" 
     SIZE 10 BY 1 TOOLTIP "Fecha".

DEFINE BUTTON bt_down 
     IMAGE-UP FILE "image/im-dw":U
     IMAGE-INSENSITIVE FILE "image/ii-dw":U
     LABEL "V" 
     SIZE 4 BY 1.13 TOOLTIP "Desce".

DEFINE BUTTON bt_edl1 
     IMAGE-UP FILE "image/im-edl":U
     IMAGE-INSENSITIVE FILE "image/ii-edl":U
     LABEL "Alt" 
     SIZE 4 BY 1.13 TOOLTIP "Edita Linha".

DEFINE BUTTON bt_get_file 
     IMAGE-UP FILE "image/im-sea1":U
     IMAGE-INSENSITIVE FILE "image/ii-sea1":U
     LABEL "Pesquisa Arquivo" 
     SIZE 4 BY 1.08 TOOLTIP "Pesquisa Arquivo".

DEFINE BUTTON bt_hel2 
     LABEL "Ajuda" 
     SIZE 10 BY 1 TOOLTIP "Ajuda".

DEFINE BUTTON bt_isl1 
     IMAGE-UP FILE "image/im-inl":U
     IMAGE-INSENSITIVE FILE "image/ii-inl":U
     LABEL "Ins" 
     SIZE 4 BY 1.13 TOOLTIP "Insere Linha".

DEFINE BUTTON bt_print AUTO-GO 
     LABEL "&Imprime" 
     SIZE 10 BY 1 TOOLTIP "Imprime".

DEFINE BUTTON bt_rml1 
     IMAGE-UP FILE "image/im-rml":U
     IMAGE-INSENSITIVE FILE "image/ii-rml":U
     LABEL "Ret" 
     SIZE 4 BY 1.13 TOOLTIP "Retira Linha".

DEFINE BUTTON bt_set_printer 
     IMAGE-UP FILE "image/im-setpr.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-setpr":U
     LABEL "Define Impressora e Layout" 
     SIZE 4 BY 1.08 TOOLTIP "Define Impressora e Layout de Impress∆o".

DEFINE BUTTON bt_up 
     IMAGE-UP FILE "image/im-up":U
     IMAGE-INSENSITIVE FILE "image/ii-up":U
     LABEL "A" 
     SIZE 4 BY 1.13 TOOLTIP "Sobe".

DEFINE VARIABLE ed_1x40 AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP
     SIZE 38 BY 1
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE v_qtd_column AS DECIMAL FORMAT ">>9":U INITIAL 0 
     LABEL "Colunas" 
     VIEW-AS FILL-IN 
     SIZE 4.14 BY .88
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE v_qtd_line AS DECIMAL FORMAT ">>9":U INITIAL 0 
     LABEL "Linhas" 
     VIEW-AS FILL-IN 
     SIZE 4.14 BY .88
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE rs_cod_dwb_output AS CHARACTER INITIAL "Terminal" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Terminal", "Terminal",
"Arquivo", "Arquivo",
"Impressora", "Impressora"
     SIZE 30 BY .88
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE rs_ind_run_mode AS CHARACTER INITIAL "On-Line" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", "On-Line",
"Batch", "Batch"
     SIZE 15.57 BY .88
     BGCOLOR 8  NO-UNDO.

DEFINE RECTANGLE rt_cxcf
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 86.57 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rt_dimensions
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 20.57 BY 3.

DEFINE RECTANGLE rt_order
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 39 BY 6.

DEFINE RECTANGLE rt_parameters_label
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 39 BY 6.5.

DEFINE RECTANGLE rt_run
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 25 BY 3.

DEFINE RECTANGLE rt_select
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.57 BY 6.

DEFINE RECTANGLE rt_target
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.57 BY 3.

DEFINE VARIABLE ls_order AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 30 BY 5
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE v_log_gera_csv AS LOGICAL INITIAL no 
     LABEL "Gera arquivo CSV (Excel)" 
     VIEW-AS TOGGLE-BOX
     SIZE 34 BY .83 NO-UNDO.

DEFINE VARIABLE v_log_lista_sem_nfe AS LOGICAL INITIAL no 
     LABEL "Lista bem sem nota fiscal informada?" 
     VIEW-AS TOGGLE-BOX
     SIZE 34 BY .83 NO-UNDO.

DEFINE VARIABLE v_log_print_par AS LOGICAL INITIAL no 
     LABEL "Imprime ParÉmetros" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_dwb_rpt_select FOR 
      dwb_rpt_select SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_dwb_rpt_select
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_dwb_rpt_select wWin _FREEFORM
  QUERY br_dwb_rpt_select NO-LOCK DISPLAY
      if dwb_rpt_select.log_dwb_rule then "Regra" else "Exceá∆o" format "x(9)" column-label "Tipo"
    dwb_rpt_select.cod_dwb_field
    width-chars 32.00
        column-label "Conjunto"
    dwb_rpt_select.cod_dwb_initial
    width-chars 40.00
        column-label "Inicial"
    dwb_rpt_select.cod_dwb_final
    width-chars 40.00
        column-label "Final"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-BOX NO-ROW-MARKERS SEPARATORS SIZE 38 BY 5
         BGCOLOR 15 FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     ls_order AT ROW 2 COL 4 NO-LABEL WIDGET-ID 42
     br_dwb_rpt_select AT ROW 2 COL 44 WIDGET-ID 200
     bt_isl1 AT ROW 2.79 COL 83 HELP
          "Insere Linha" WIDGET-ID 58
     bt_up AT ROW 3.42 COL 35 HELP
          "Sobe" WIDGET-ID 50
     bt_edl1 AT ROW 4 COL 83 HELP
          "Edita Linha" WIDGET-ID 54
     bt_down AT ROW 4.58 COL 35 HELP
          "Desce" WIDGET-ID 48
     bt_rml1 AT ROW 5.21 COL 83 HELP
          "Retira Linha" WIDGET-ID 56
     v_log_lista_sem_nfe AT ROW 8.5 COL 4 WIDGET-ID 68
     rs_cod_dwb_output AT ROW 8.5 COL 44 NO-LABEL WIDGET-ID 44
     v_log_gera_csv AT ROW 9.5 COL 4 WIDGET-ID 70
     ed_1x40 AT ROW 9.5 COL 44 NO-LABEL WIDGET-ID 66
     bt_set_printer AT ROW 9.5 COL 83 WIDGET-ID 52
     bt_get_file AT ROW 9.5 COL 83 HELP
          "Pesquisa Arquivo" WIDGET-ID 64
     rs_ind_run_mode AT ROW 12.21 COL 44 NO-LABEL WIDGET-ID 38
     v_qtd_line AT ROW 12.21 COL 79 COLON-ALIGNED WIDGET-ID 60
     v_log_print_par AT ROW 13.21 COL 44 WIDGET-ID 36
     v_qtd_column AT ROW 13.21 COL 79 COLON-ALIGNED WIDGET-ID 62
     bt_close AT ROW 15.25 COL 3 WIDGET-ID 32
     bt_print AT ROW 15.25 COL 14 WIDGET-ID 34
     bt_can AT ROW 15.25 COL 25 WIDGET-ID 28
     bt_hel2 AT ROW 15.25 COL 77.57 WIDGET-ID 30
     "Classificaá∆o" VIEW-AS TEXT
          SIZE 10 BY .67 AT ROW 1.21 COL 4 WIDGET-ID 20
          BGCOLOR 8 
     "ParÉmetros" VIEW-AS TEXT
          SIZE 8 BY .67 AT ROW 7.71 COL 4 WIDGET-ID 16
          BGCOLOR 8 
     "Execuá∆o" VIEW-AS TEXT
          SIZE 8 BY .67 AT ROW 11.21 COL 44 WIDGET-ID 24
          BGCOLOR 8 
     "Destino" VIEW-AS TEXT
          SIZE 8 BY .67 AT ROW 7.71 COL 44 WIDGET-ID 22
          BGCOLOR 8 
     "Dimens‰es" VIEW-AS TEXT
          SIZE 8 BY .67 AT ROW 11.21 COL 70 WIDGET-ID 26
          BGCOLOR 8 
     "Seleá∆o" VIEW-AS TEXT
          SIZE 8 BY .67 AT ROW 1.21 COL 44 WIDGET-ID 18
          BGCOLOR 8 
     rt_cxcf AT ROW 15 COL 2 WIDGET-ID 2
     rt_dimensions AT ROW 11.5 COL 68 WIDGET-ID 4
     rt_order AT ROW 1.5 COL 2 WIDGET-ID 6
     rt_parameters_label AT ROW 8 COL 2 WIDGET-ID 8
     rt_run AT ROW 11.5 COL 42 WIDGET-ID 10
     rt_select AT ROW 1.5 COL 42 WIDGET-ID 12
     rt_target AT ROW 8 COL 42 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 98 BY 17
         BGCOLOR 8 FONT 1
         CANCEL-BUTTON bt_can WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Relat¢rio Entrada de Bens"
         HEIGHT             = 15.96
         WIDTH              = 90
         MAX-HEIGHT         = 28.79
         MAX-WIDTH          = 146.14
         VIRTUAL-HEIGHT     = 28.79
         VIRTUAL-WIDTH      = 146.14
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = 8
         FGCOLOR            = ?
         THREE-D            = yes
         FONT               = 1
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* BROWSE-TAB br_dwb_rpt_select ls_order fMain */
ASSIGN 
       bt_hel2:POPUP-MENU IN FRAME fMain       = MENU m_help:HANDLE.

ASSIGN 
       ed_1x40:RETURN-INSERTED IN FRAME fMain  = TRUE.

/* SETTINGS FOR RECTANGLE rt_cxcf IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt_dimensions IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt_order IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt_parameters_label IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt_run IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt_select IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt_target IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_dwb_rpt_select
/* Query rebuild information for BROWSE br_dwb_rpt_select
     _START_FREEFORM
    open query qr_dwb_rpt_select for
        each dwb_rpt_select no-lock
        where dwb_rpt_select.cod_dwb_program = v_cod_dwb_program
          and dwb_rpt_select.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_select of dwb_rpt_select*/
            by dwb_rpt_select.log_dwb_rule descending
            by dwb_rpt_select.num_dwb_order.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE br_dwb_rpt_select */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Relat¢rio Entrada de Bens */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Relat¢rio Entrada de Bens */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_can
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_can wWin
ON CHOOSE OF bt_can IN FRAME fMain /* Cancela */
DO:
  apply "close" to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_close
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_close wWin
ON CHOOSE OF bt_close IN FRAME fMain /* Fecha */
DO:
  apply "close" to this-procedure.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_down
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_down wWin
ON CHOOSE OF bt_down IN FRAME fMain /* V */
DO:
      /************************* Variable Definition Begin ************************/

    def var v_cod_dwb_field
        as character
        format "x(32)":U
        no-undo.
    def var v_cod_dwb_order
        as character
        format "x(32)":U
        label "Classificaá∆o"
        column-label "Classificador"
        no-undo.
    def var v_num_entry
        as integer
        format ">>>>,>>9":U
        label "Ordem"
        column-label "Ordem"
        no-undo.


    /************************** Variable Definition End *************************/

    assign v_cod_dwb_field = ls_order:screen-value in frame {&frame-name}
           v_cod_dwb_order = ls_order:list-items in frame {&frame-name}
           v_num_entry = lookup(v_cod_dwb_field, v_cod_dwb_order).

    if  v_num_entry > 0 and v_num_entry < num-entries (v_cod_dwb_order)
    then do:
        assign entry(v_num_entry, v_cod_dwb_order) = entry(v_num_entry + 1, v_cod_dwb_order)
               entry(v_num_entry + 1, v_cod_dwb_order) = v_cod_dwb_field
               ls_order:list-items in frame {&frame-name} = v_cod_dwb_order
               ls_order:screen-value in frame {&frame-name} = v_cod_dwb_field.
    end /* if */.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_edl1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_edl1 wWin
ON CHOOSE OF bt_edl1 IN FRAME fMain /* Alt */
DO:
    /************************* Variable Definition Begin ************************/

    def var v_log_method
        as logical
        format "Sim/N∆o"
        initial yes
        no-undo.


    /************************** Variable Definition End *************************/

    if  br_dwb_rpt_select:num-selected-rows in frame {&frame-name} = 1
    then do:
        assign v_log_method = br_dwb_rpt_select:fetch-selected-row(1) in frame {&frame-name}.
        run pi_edl_dwb_rpt_select (Input recid(dwb_rpt_select)) /*pi_edl_dwb_rpt_select*/.
        run pi_open_dwb_rpt_select /*pi_open_dwb_rpt_select*/.
    end /* if */.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_get_file
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_get_file wWin
ON CHOOSE OF bt_get_file IN FRAME fMain /* Pesquisa Arquivo */
DO:
      system-dialog get-file v_cod_dwb_file
        title "Imprimir" /*l_imprimir*/ 
        filters '*.rpt' '*.rpt',
                "*.*"  "*.*"
        save-as
        create-test-file
        ask-overwrite.
        
        find dwb_rpt_param exclusive-lock
             where dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
               and dwb_rpt_param.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_param of dwb_rpt_param*/ no-error.

        
        assign dwb_rpt_param.cod_dwb_file              = v_cod_dwb_file
               ed_1x40:screen-value in frame {&frame-name} = v_cod_dwb_file.

        find dwb_rpt_param no-lock
             where dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
               and dwb_rpt_param.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_param of dwb_rpt_param*/ no-error.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_isl1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_isl1 wWin
ON CHOOSE OF bt_isl1 IN FRAME fMain /* Ins */
DO:
      /************************* Variable Definition Begin ************************/

    def var v_cod_dwb_field
        as character
        format "x(32)":U
        no-undo.


    /************************** Variable Definition End *************************/

    run pi_isl_dwb_rpt_select /*pi_isl_dwb_rpt_select*/.
    run pi_open_dwb_rpt_select /*pi_open_dwb_rpt_select*/.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_print
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_print wWin
ON CHOOSE OF bt_print IN FRAME fMain /* Imprime */
DO:
  run piExecute in this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_rml1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_rml1 wWin
ON CHOOSE OF bt_rml1 IN FRAME fMain /* Ret */
DO:
      /************************* Variable Definition Begin ************************/

    def var v_rec_dwb_rpt_select
        as recid
        format ">>>>>>9":U
        no-undo.


    /************************** Variable Definition End *************************/

    if  br_dwb_rpt_select:num-selected-rows = 1 and
        br_dwb_rpt_select:fetch-selected-row(1)
    then do:
        assign v_rec_dwb_rpt_select = recid(dwb_rpt_select).
        find dwb_rpt_select exclusive-lock
             where recid(dwb_rpt_select) = v_rec_dwb_rpt_select /*cl_dwb_rpt_select_recid of dwb_rpt_select*/.
        delete dwb_rpt_select.
        run pi_open_dwb_rpt_select /*pi_open_dwb_rpt_select*/.
    end /* if */.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_set_printer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_set_printer wWin
ON CHOOSE OF bt_set_printer IN FRAME fMain /* Define Impressora e Layout */
DO:
      assign v_nom_dwb_printer      = ""
           v_cod_dwb_print_layout = "".

    &if '{&emsbas_version}' <= '1.00' &then
    if  search("prgtec/btb/btb036nb.r") = ? and search("prgtec/btb/btb036nb.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/btb/btb036nb.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgtec/btb/btb036nb.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgtec/btb/btb036nb.p (output v_nom_dwb_printer,
                               output v_cod_dwb_print_layout) /*prg_see_layout_impres_imprsor*/.
    &else
    if  search("prgtec/btb/btb036zb.r") = ? and search("prgtec/btb/btb036zb.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/btb/btb036zb.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgtec/btb/btb036zb.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgtec/btb/btb036zb.p (input-output v_nom_dwb_printer,
                               input-output v_cod_dwb_print_layout,
                               input-output v_nom_dwb_print_file) /*prg_fnc_layout_impres_imprsor*/.
    &endif


    find dwb_rpt_param exclusive-lock
         where dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
           and dwb_rpt_param.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_param of dwb_rpt_param*/ no-error.

    if  v_nom_dwb_printer <> ""
    and  v_cod_dwb_print_layout <> ""
    then do:
        assign dwb_rpt_param.nom_dwb_printer      = v_nom_dwb_printer
               dwb_rpt_param.cod_dwb_print_layout = v_cod_dwb_print_layout
    &if '{&emsbas_version}' > '1.00' &then           
    &if '{&emsbas_version}' >= '5.03' &then           
               dwb_rpt_param.nom_dwb_print_file        = v_nom_dwb_print_file
    &else
               dwb_rpt_param.cod_livre_1               = v_nom_dwb_print_file
    &endif
    &endif
               ed_1x40:screen-value in frame {&frame-name} = v_nom_dwb_printer
                                                       + ":"
                                                       + v_cod_dwb_print_layout
    &if '{&emsbas_version}' > '1.00' &then
                                                       + (if v_nom_dwb_print_file <> "" then ":" + v_nom_dwb_print_file
                                                          else "")
    &endif
    .
        find layout_impres no-lock
             where layout_impres.nom_impressora = dwb_rpt_param.nom_dwb_printer
               and layout_impres.cod_layout_impres = dwb_rpt_param.cod_dwb_print_layout /*cl_get_layout of layout_impres*/ no-error.
        assign v_qtd_line               = layout_impres.num_lin_pag.
        display v_qtd_line
                with frame {&frame-name}.
    end /* if */.

    find dwb_rpt_param no-lock
         where dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
           and dwb_rpt_param.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_param of dwb_rpt_param*/ no-error.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_up
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_up wWin
ON CHOOSE OF bt_up IN FRAME fMain /* A */
DO:
      /************************* Variable Definition Begin ************************/

    def var v_cod_dwb_field
        as character
        format "x(32)":U
        no-undo.
    def var v_cod_dwb_order
        as character
        format "x(32)":U
        label "Classifica?ío"
        column-label "Classificador"
        no-undo.
    def var v_num_entry
        as integer
        format ">>>>,>>9":U
        label "Ordem"
        column-label "Ordem"
        no-undo.


    /************************** Variable Definition End *************************/

    assign v_cod_dwb_field = ls_order:screen-value in frame {&frame-name}
           v_cod_dwb_order = ls_order:list-items in frame {&frame-name}
           v_num_entry = lookup(v_cod_dwb_field, v_cod_dwb_order).

    if  v_num_entry > (1 + 0)
    then do:
        assign entry(v_num_entry, v_cod_dwb_order) = entry(v_num_entry - 1, v_cod_dwb_order)
               entry(v_num_entry - 1, v_cod_dwb_order) = v_cod_dwb_field
               ls_order:list-items in frame {&frame-name} = v_cod_dwb_order
               ls_order:screen-value in frame {&frame-name} = v_cod_dwb_field.
    end /* if */.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ed_1x40
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ed_1x40 wWin
ON LEAVE OF ed_1x40 IN FRAME fMain
DO:
      /************************* Variable Definition Begin ************************/

    def var v_cod_filename_final             as character       no-undo. /*local*/
    def var v_cod_filename_initial           as character       no-undo. /*local*/


    /************************** Variable Definition End *************************/

    block:
    do with frame {&frame-name}:
        if  rs_cod_dwb_output:screen-value = "Arquivo" /*l_file*/ 
        then do:
            if  rs_ind_run_mode:screen-value <> "Batch" /*l_batch*/ 
            then do:
                if  ed_1x40:screen-value  <> ""
                then do:
                    assign ed_1x40:screen-value   = replace(ed_1x40:screen-value, '~\', '/')
                           v_cod_filename_initial = entry(num-entries(ed_1x40:screen-value, '/'), ed_1x40:screen-value, '/')
                           v_cod_filename_final   = substring(ed_1x40:screen-value, 1,
                                                              length(ed_1x40:screen-value) - length(v_cod_filename_initial) - 1)
                           file-info:file-name    = v_cod_filename_final.
                    if  file-info:file-type = ?
                    then do:
                         /* O diretΩrio &1 nío existe ! */
                         run pi_messages (input "show",
                                          input 4354,
                                          input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                             v_cod_filename_final)) /*msg_4354*/.
                         return no-apply.
                    end /* if */.
                end /* if */.
            end /* if */.
            find dwb_rpt_param exclusive-lock
                 where dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
                   and dwb_rpt_param.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_param of dwb_rpt_param*/ no-error.
            
            assign dwb_rpt_param.cod_dwb_file = ed_1x40:screen-value.
            
            find dwb_rpt_param no-lock
                 where dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
                   and dwb_rpt_param.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_param of dwb_rpt_param*/ no-error.
            
        end /* if */.
    end /* do block */.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs_cod_dwb_output
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs_cod_dwb_output wWin
ON VALUE-CHANGED OF rs_cod_dwb_output IN FRAME fMain
DO:

    find dwb_rpt_param exclusive-lock
         where dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
           and dwb_rpt_param.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_param of dwb_rpt_param*/ no-error.

    assign dwb_rpt_param.cod_dwb_output   = rs_cod_dwb_output:screen-value
           dwb_rpt_param.ind_dwb_run_mode = rs_ind_run_mode:screen-value.

    do with frame {&frame-name}:
        /* block: */
        case self:screen-value:
            when "Terminal" /*l_terminal*/ then ter:
             do:
                enable v_log_gera_csv with frame {&frame-name}.
                if  rs_cod_dwb_output <> "Impressora" /*l_printer*/ 
                then do:
                    assign v_qtd_line_ant = input frame {&frame-name} v_qtd_line.
                end /* if */.
                if  v_qtd_line_ant > 0
                then do:
                    assign v_qtd_line = v_qtd_line_ant.
                end /* if */.
                else do:
                    assign v_qtd_line = (if  dwb_rpt_param.qtd_dwb_line > 0 then dwb_rpt_param.qtd_dwb_line
                                        else v_rpt_s_1_lines).
                end /* else */.
                display v_qtd_line
                        with frame {&frame-name}.

                assign ed_1x40:screen-value   = ""
                       ed_1x40:sensitive      = no
                       bt_get_file:visible    = no
                       bt_set_printer:visible = no.
                       
                       
            end /* do ter */.
            when "Arquivo" /*l_file*/ then fil:
             do:
                enable v_log_gera_csv with frame {&frame-name}.             
                if  rs_cod_dwb_output <> "Impressora" /*l_printer*/ 
                then do:
                    assign v_qtd_line_ant = input frame {&frame-name} v_qtd_line.
                end /* if */.
                if  v_qtd_line_ant > 0
                then do:
                    assign v_qtd_line = v_qtd_line_ant.
                end /* if */.
                else do:
                    assign v_qtd_line = (if  dwb_rpt_param.qtd_dwb_line > 0 then dwb_rpt_param.qtd_dwb_line
                                        else v_rpt_s_1_lines).
                end /* else */.
                display v_qtd_line
                        with frame {&frame-name}.

                assign ed_1x40:screen-value       = ""
                       ed_1x40:sensitive          = yes
                       bt_set_printer:visible     = no
                       bt_get_file:visible        = yes.

                if  dwb_rpt_param.cod_dwb_print_layout <> "" then
                    assign v_cod_dwb_file_old = dwb_rpt_param.cod_dwb_print_layout.
                    
                /* define arquivo default */
                find usuar_mestre no-lock
                     where usuar_mestre.cod_usuario = v_cod_dwb_user
    &if "{&emsbas_version}" >= "5.01" &then
                     use-index srmstr_id
    &endif
                      /*cl_current_user of usuar_mestre*/ no-error.
                    assign dwb_rpt_param.cod_dwb_file = "".

                if  rs_ind_run_mode:screen-value in frame {&frame-name} <> "Batch" /*l_batch*/ 
                then do:
                    if  usuar_mestre.nom_dir_spool <> ""
                    then do:
                        assign dwb_rpt_param.cod_dwb_file = usuar_mestre.nom_dir_spool
                                                          + "~/".
                    end /* if */.
                    if  usuar_mestre.nom_subdir_spool <> ""
                    then do:
                        assign dwb_rpt_param.cod_dwb_file = dwb_rpt_param.cod_dwb_file
                                                          + usuar_mestre.nom_subdir_spool
                                                          + "~/".
                    end /* if */.
                end /* if */.
                else do:
                    assign dwb_rpt_param.cod_dwb_file = dwb_rpt_param.cod_dwb_file.
                end /* else */.
                if  v_cod_dwb_file_temp = ""
                then do:
                    assign dwb_rpt_param.cod_dwb_file = dwb_rpt_param.cod_dwb_file
                                                      + caps("esfas002":U)
                                                      + '.rpt'.
                end /* if */.
                else do:
                    assign dwb_rpt_param.cod_dwb_file = dwb_rpt_param.cod_dwb_file
                                                      + v_cod_dwb_file_temp.
                end /* else */.
                assign ed_1x40:screen-value                = dwb_rpt_param.cod_dwb_file
                       dwb_rpt_param.cod_dwb_print_layout  = ""
                       v_qtd_line                          = (if v_qtd_line_ant > 0 then v_qtd_line_ant
                                                              else v_rpt_s_1_lines)
    &if '{&emsbas_version}' > '1.00' &then
                       v_nom_dwb_print_file                = ""
    &endif
    .
            end /* do fil */.
            when "Impressora" /*l_printer*/ then prn:
             do:
                disable v_log_gera_csv with frame {&frame-name}.             
                if  rs_cod_dwb_output <> "Impressora" /*l_printer*/  and rs_ind_run_mode <> "Batch" /*l_batch*/ 
                then do: 
                    assign v_qtd_line_ant = input frame {&frame-name} v_qtd_line.
                end /* if */.

                assign ed_1x40:sensitive        = no
                       bt_get_file:visible      = no
                       bt_set_printer:visible   = yes
                       bt_set_printer:sensitive = yes.

                /* define layout default */
                if   v_cod_dwb_file_old <> "" then
                     assign dwb_rpt_param.cod_dwb_print_layout = v_cod_dwb_file_old.

                if  dwb_rpt_param.nom_dwb_printer = ""
                or  dwb_rpt_param.cod_dwb_print_layout = ""
                then do:
                    run pi_set_print_layout_default /*pi_set_print_layout_default*/.
                end /* if */.
                else do:
                    assign ed_1x40:screen-value = dwb_rpt_param.nom_dwb_printer
                                                + ":"
                                                + dwb_rpt_param.cod_dwb_print_layout.
                end /* else */.

                if  dwb_rpt_param.cod_dwb_print_layout <> "" then
                    assign v_cod_dwb_file_old = dwb_rpt_param.cod_dwb_print_layout.

                find layout_impres no-lock
                     where layout_impres.nom_impressora = dwb_rpt_param.nom_dwb_printer
                       and layout_impres.cod_layout_impres = dwb_rpt_param.cod_dwb_print_layout /*cl_get_layout of layout_impres*/ no-error.
                if  avail layout_impres
                then do:
                    assign v_qtd_line               = layout_impres.num_lin_pag.
                end /* if */.
                display v_qtd_line
                        with frame {&frame-name}.

            end /* do prn */.
        end /* case block */.

        assign v_cod_dwb_file_temp = replace(dwb_rpt_param.cod_dwb_file, "~\", "~/").
        if  index(v_cod_dwb_file_temp, "~/") <> 0
        then do:
            assign v_cod_dwb_file_temp = substring(v_cod_dwb_file_temp, r-index(v_cod_dwb_file_temp, "~/") + 1).
        end /* if */.
        else do:
            assign v_cod_dwb_file_temp = dwb_rpt_param.cod_dwb_file.
        end /* else */.
    end /* do initout */.

    if  self:screen-value = "Impressora" /*l_printer*/ 
    then do:
        disable v_qtd_line
                with frame {&frame-name}.
    end /* if */.
    else do:
        enable v_qtd_line
               with frame {&frame-name}.
    end /* else */.

    assign rs_cod_dwb_output.
    
    find dwb_rpt_param no-lock
         where dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
           and dwb_rpt_param.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_param of dwb_rpt_param*/ no-error.



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs_ind_run_mode
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs_ind_run_mode wWin
ON VALUE-CHANGED OF rs_ind_run_mode IN FRAME fMain
DO:

    find dwb_rpt_param exclusive-lock
         where dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
           and dwb_rpt_param.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_param of dwb_rpt_param*/ no-error.

    assign dwb_rpt_param.cod_dwb_output   = rs_cod_dwb_output:screen-value
           dwb_rpt_param.ind_dwb_run_mode = rs_ind_run_mode:screen-value.

    if  dwb_rpt_param.ind_dwb_run_mode = "Batch" /*l_batch*/ 
    then do:
        if  rs_cod_dwb_output:disable("Terminal" /*l_terminal*/ ) in frame {&frame-name}
        then do:
        end /* if */.
    end /* if */.
    else do:
        if  rs_cod_dwb_output:enable("Terminal" /*l_terminal*/ ) in frame {&frame-name}
        then do:
        end /* if */.
    end /* else */.
    if  rs_ind_run_mode = "Batch" /*l_batch*/ 
    then do:
        assign v_qtd_line = v_qtd_line_ant.
        display v_qtd_line
                with frame {&frame-name}.
    end /* if */.
    assign rs_ind_run_mode.
    
    find dwb_rpt_param no-lock
         where dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
           and dwb_rpt_param.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_param of dwb_rpt_param*/ no-error.

    
    apply "value-changed" to rs_cod_dwb_output in frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br_dwb_rpt_select
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */
ON CHOOSE OF MENU-ITEM mi_sobre IN MENU m_help
DO:

    /************************* Variable Definition Begin ************************/

    def var v_cod_release
        as character
        format "x(12)":U
        no-undo.
    def var v_nom_prog
        as character
        format "x(8)":U
        no-undo.
    def var v_nom_prog_ext
        as character
        format "x(8)":U
        label "Nome Externo"
        no-undo.


    /************************** Variable Definition End *************************/


        assign v_nom_prog     = substring(wWin:title, 1, max(1, length(wWin:title) - 14)).
        if  v_nom_prog = ? then
            assign v_nom_prog = "".

        assign v_nom_prog     = v_nom_prog
                              + chr(10)
                              + "esfas002":U.


    assign v_nom_prog_ext = "esp/fas/esfas002.w":U
           v_cod_release  = trim(c-versao-prg).
    run prgtec/btb/btb901zb.p (Input v_nom_prog,
                               Input v_nom_prog_ext,
                               Input v_cod_release) /*prg_fnc_about*/.
END. /* ON CHOOSE OF MENU-ITEM mi_sobre IN MENU m_help */

run initializeInterface in this-procedure.
run pi_initialize_reports in this-procedure.
run pi_configure_dwb_param in this-procedure.
run pi_set_print_layout_default in this-procedure.
browse br_dwb_rpt_select:query = query qr_dwb_rpt_select:handle.
run pi_open_dwb_rpt_select.

/* {src/adm2/windowmn.i} */
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
    
/*     IF NOT THIS-PROCEDURE:PERSISTENT THEN */
        WAIT-FOR CLOSE OF CURRENT-WINDOW focus bt_print.
END.

bt_hel2:POPUP-MENU IN FRAME fMain       = MENU m_help:HANDLE.

/* Include custom  Main Block code for SmartWindows. */

find dwb_rpt_param no-lock
     where dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
       and dwb_rpt_param.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_param of dwb_rpt_param*/ no-error.

assign v_qtd_line = dwb_rpt_param.qtd_dwb_line.

init:
do with frame {&frame-name}:
    assign rs_cod_dwb_output:screen-value  = dwb_rpt_param.cod_dwb_output
           rs_ind_run_mode:screen-value    = dwb_rpt_param.ind_dwb_run_mode.
    if  dwb_rpt_param.cod_dwb_output = "Arquivo" /*l_file*/ 
    then do:
        ed_1x40:screen-value = dwb_rpt_param.cod_dwb_file.
    end /* if */.
    if  dwb_rpt_param.cod_dwb_output = "Impressora" /*l_printer*/ 
    then do:
        if  not can-find(imprsor_usuar
                where imprsor_usuar.nom_impressora = dwb_rpt_param.nom_dwb_printer
                  and imprsor_usuar.cod_usuario = dwb_rpt_param.cod_dwb_user
&if "{&emsbas_version}" >= "5.01" &then
                use-index imprsrsr_id
&endif
                 /*cl_get_printer of imprsor_usuar*/)
        or   not can-find(layout_impres
                        where layout_impres.nom_impressora = dwb_rpt_param.nom_dwb_printer
                          and layout_impres.cod_layout_impres = dwb_rpt_param.cod_dwb_print_layout /*cl_get_layout of layout_impres*/)
                        then do:
            run pi_set_print_layout_default /*pi_set_print_layout_default*/.
        end /* if */.
        assign ed_1x40:screen-value = dwb_rpt_param.nom_dwb_printer
                                    + ":"
                                    + dwb_rpt_param.cod_dwb_print_layout.
    end /* if */.
    assign v_log_print_par = dwb_rpt_param.log_dwb_print_parameters.
    display v_log_print_par
            with frame {&frame-name}.
end /* do init */.

assign v_qtd_column:screen-value in frame {&frame-name} = string(v_qtd_column)
       v_qtd_line:screen-value in frame {&frame-name} = string(v_qtd_line).

if  num-entries(v_cod_dwb_order) < 2
then do:
    assign bt_down:sensitive in frame {&frame-name} = no
           bt_up:sensitive in frame {&frame-name} = no.
  
end /* if */.

assign rs_cod_dwb_output:screen-value in frame {&frame-name} = "Arquivo".
apply "value-changed" to rs_cod_dwb_output in frame {&frame-name}.

if  dwb_rpt_param.ind_dwb_run_mode = "Batch" /*l_batch*/ 
then do:
    apply "value-changed" to rs_ind_run_mode in frame {&frame-name}.
end /* if */.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
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
  DISPLAY ls_order v_log_lista_sem_nfe rs_cod_dwb_output v_log_gera_csv ed_1x40 
          rs_ind_run_mode v_qtd_line v_log_print_par v_qtd_column 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE ls_order br_dwb_rpt_select bt_isl1 bt_up bt_edl1 bt_down bt_rml1 
         v_log_lista_sem_nfe rs_cod_dwb_output v_log_gera_csv ed_1x40 
         bt_set_printer bt_get_file rs_ind_run_mode v_qtd_line v_log_print_par 
         v_qtd_column bt_close bt_print bt_can bt_hel2 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeInterface wWin 
PROCEDURE initializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     Inicialize programa
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    if  v_cod_arq <> '' and v_cod_arq <> ?
    then do:
        run pi_version_extract ('rpt_bem_pat_sit_geral_pat':U, 'prgfin/fas/esfas002.py':U, c-versao-prg, 'pro':U).
    end /* if */.
    /* End_Include: i_version_extract */
    
    run pi_return_user (output v_cod_dwb_user) /*pi_return_user*/.
    
    if  search("prgtec/btb/btb906za.r") = ? and search("prgtec/btb/btb906za.py") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/btb/btb906za.py".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgtec/btb/btb906za.py"
                   view-as alert-box error buttons ok.
            stop.
        end.
    end.
    else
        run prgtec/btb/btb906za.py /*prg_fnc_verify_controls*/.
    if  v_cod_dwb_user = ""
    then do:
        assign v_cod_dwb_user = v_cod_usuar_corren.
    end /* if */.
    
    /* Begin_Include: i_verify_security */
    if  search("prgtec/men/men901za.r") = ? and search("prgtec/men/men901za.py") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/men/men901za.py".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgtec/men/men901za.py"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgtec/men/men901za.py (Input 'rpt_bem_pat_sit_geral_pat') /*prg_fnc_verify_security*/.
    if  return-value = "2014"
    then do:
        /* Programa a ser executado n∆o Ç um programa v†lido Datasul ! */
        run pi_messages (input "show",
                         input 2014,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                           'rpt_bem_pat_sit_geral_pat')) /*msg_2014*/.
        return.
    end /* if */.
    if  return-value = "2012"
    then do:
        /* Usu†rio sem permiss∆o para acessar o programa. */
        run pi_messages (input "show",
                         input 2012,
                         input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                           'rpt_bem_pat_sit_geral_pat')) /*msg_2012*/.
        return.
    end /* if */.
    /* End_Include: i_verify_security */
    
    
    
    /* Begin_Include: i_log_exec_prog_dtsul_ini */
    assign v_rec_log = ?.
    
    if can-find(prog_dtsul
           where prog_dtsul.cod_prog_dtsul = 'rpt_bem_pat_sit_geral_pat' 
             and prog_dtsul.log_gera_log_exec = yes) then do transaction:
        create log_exec_prog_dtsul.
        assign log_exec_prog_dtsul.cod_prog_dtsul           = 'rpt_bem_pat_sit_geral_pat'
               log_exec_prog_dtsul.cod_usuario              = v_cod_usuar_corren
               log_exec_prog_dtsul.dat_inic_exec_prog_dtsul = today
               log_exec_prog_dtsul.hra_inic_exec_prog_dtsul = replace(string(time,"hh:mm:ss" /*l_hh:mm:ss*/ ),":","").
        assign v_rec_log = recid(log_exec_prog_dtsul).
        release log_exec_prog_dtsul no-error.
    end.
    
    
    /* End_Include: i_log_exec_prog_dtsul_ini */
    
    
    
    
    
    /* Begin_Include: i_verify_program_epc */
    
    /* End_Include: i_verify_program_epc */
    
    
    /* redefiniá‰es do frame */
    
    /* Begin_Include: i_std_dialog_box */
    /* tratamento do titulo e vers∆o */
    assign wWin:title = wWin:title
                                + chr(32)
                                + chr(40)
                                + trim(c-versao-prg)
                                + chr(41).
    
    
    /* End_Include: i_std_dialog_box */
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wWin 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var c-arq-aux    as char no-undo.
    define variable v_cod_key_value as character no-undo.
    def buffer b_dwb_rpt_param  for dwb_rpt_param.
    DEF BUFFER b_dwb_rpt_select FOR dwb_rpt_select.

    find dwb_rpt_param no-lock
         where dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
           and dwb_rpt_param.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_param of dwb_rpt_param*/ no-error.
           
    if  dwb_rpt_param.cod_dwb_output = "Arquivo" 
    and dwb_rpt_param.ind_dwb_run_mode = "On-Line" then do:
        
        assign c-arq-aux = dwb_rpt_param.cod_dwb_file
               c-arq-aux = replace(c-arq-aux, "/":U, "~\":U).
        if  r-index(c-arq-aux, "~\":U) > 0 then do:
            assign file-info:file-name = substring(c-arq-aux,1,r-index(c-arq-aux, "~\":U)).
            if  file-info:full-pathname = ? or not file-info:file-type matches "*D*":U then do:
                run utp/ut-msgs.p (input "show":U, 
                                   input 5749, 
                                   input "").
                apply 'entry':U to ed_1x40 in frame {&frame-name}.
                return error.
            end.
        end.
        
        assign file-info:file-name = c-arq-aux.
        if file-info:file-type matches "*D*":U then do:
            run utp/ut-msgs.p (input "show":U, 
                               input 73, 
                               input "").
            apply 'entry':U to ed_1x40 in frame {&frame-name}.
            return error.
        end.
    end.    

    if dwb_rpt_param.cod_dwb_output = "Arquivo" and
       dwb_rpt_param.ind_dwb_run_mode = "On-Line" then do:
        run utp/ut-vlarq.p (input dwb_rpt_param.cod_dwb_file).
        
        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show":U, input 73, input "":U).
            apply "ENTRY":U to ed_1x40 in frame {&frame-name}.
            return error.
        end.
    end.

    assign v_cod_dwb_file = replace(dwb_rpt_param.cod_dwb_file, "~\", "~/")
           v_nom_integer = v_cod_dwb_file.


    run piExecute_1 in this-procedure.
    if return-value = "NOK" then return error.

    find dwb_rpt_param exclusive-lock
         where dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
           and dwb_rpt_param.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_param of dwb_rpt_param*/ no-error.

    assign dwb_rpt_param.cod_dwb_order            = ls_order:list-items
           dwb_rpt_param.ind_dwb_run_mode         = dwb_rpt_param.ind_dwb_run_mode
           v_cod_dwb_order                        = ls_order:list-items
           dwb_rpt_param.log_dwb_print_parameters = input frame {&frame-name} v_log_print_par
           input frame {&frame-name} v_qtd_line
           dwb_rpt_param.cod_dwb_parameters       = string(input frame {&frame-name} v_log_lista_sem_nfe) + chr(10) +
                                                    string(input frame {&frame-name} v_log_gera_csv and dwb_rpt_param.cod_dwb_output ne "Impressora").
                                                    
    assign dwb_rpt_param.cod_dwb_output     = rs_cod_dwb_output:screen-value in frame {&frame-name}
           dwb_rpt_param.qtd_dwb_line       = input frame {&frame-name} v_qtd_line
    &if '{&emsbas_version}' > '1.00' &then
    &if '{&emsbas_version}' >= '5.03' &then
           dwb_rpt_param.nom_dwb_print_file = v_nom_dwb_print_file
    &else
           dwb_rpt_param.cod_livre_1 = v_nom_dwb_print_file
    &endif
    &endif
    .
    
    release dwb_rpt_param.
    find dwb_rpt_param no-lock
         where dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
           and dwb_rpt_param.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_param of dwb_rpt_param*/ no-error.

    if dwb_rpt_param.ind_dwb_run_mode = "Batch" then do:
        assign v_cod_dwb_file = v_nom_integer.
        
        if  search("prgtec/btb/btb911za.r") = ? and search("prgtec/btb/btb911za.p") = ? then do:
            if  v_cod_dwb_user begins 'es_' then
                return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgtec/btb/btb911za.p".
            else do:
                message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgtec/btb/btb911za.p"
                       view-as alert-box error buttons ok.
                return.
            end.
        end.
        else do:
            run prgtec/btb/btb911za.p (Input "esfas002rp",
                                   Input v_cod_release,
                                   Input 40,
                                   Input recid(dwb_rpt_param),
                                   output v_num_ped_exec) /*prg_fnc_criac_ped_exec*/.
            if  v_num_ped_exec <> 0
            then do:
                create b_dwb_rpt_param.
                buffer-copy dwb_rpt_param except cod_dwb_user to b_dwb_rpt_param.
                b_dwb_rpt_param.cod_dwb_user = "es_" + dwb_rpt_param.cod_dwb_user + "_" + string(v_num_ped_exec,"999999999").
                release b_dwb_rpt_param.

                FOR EACH  dwb_rpt_select NO-LOCK 
                    WHERE dwb_rpt_select.cod_dwb_program = v_cod_dwb_program
                      AND dwb_rpt_select.cod_dwb_user    = dwb_rpt_param.cod_dwb_user:

                    CREATE b_dwb_rpt_select.
                    BUFFER-COPY dwb_rpt_select EXCEPT cod_dwb_user TO b_dwb_rpt_select.
                    ASSIGN b_dwb_rpt_select.cod_dwb_user = "es_" + dwb_rpt_select.cod_dwb_user + "_" + string(v_num_ped_exec,"999999999").
                END.
                RELEASE b_dwb_rpt_select.
        
                /* Criado pedido &1 para execuá∆o batch. */
                run pi_messages (input "show",
                                 input 3556,
                                 input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                                    v_num_ped_exec)) /*msg_3556*/.
                assign v_num_ped_exec = 0.
            end /* if */.
        end.    
    end.
    else do:
    
        SESSION:SET-WAIT-STATE("GENERAL":U).
        
        run esp/fas/esfas002rp.p.
        
        SESSION:SET-WAIT-STATE("":U).
        
        IF dwb_rpt_param.cod_dwb_output = "Terminal"
        THEN DO:
            get-key-value section 'EMS' key 'Show-Report-Program' value v_cod_key_value.
            if  v_cod_key_value = ""
            or   v_cod_key_value = ?
            then do:
                assign v_cod_key_value = 'notepad.exe'.
                put-key-value section 'EMS' key 'Show-Report-Program' value v_cod_key_value no-error.
            end /* if */.
            run winexec (input v_cod_key_value + chr(32) + dwb_rpt_param.cod_dwb_file, input 1).
        end.
    end.    
    
    END PROCEDURE.

    PROCEDURE WinExec EXTERNAL 'kernel32.dll':
      DEF INPUT  PARAM prg_name                          AS CHARACTER.
      DEF INPUT  PARAM prg_style                         AS SHORT.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute_1 wWin 
PROCEDURE piExecute_1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var cPrinter as char no-undo.
def var c-layout as char no-undo.

if  dwb_rpt_param.cod_dwb_output = "Impressora" then do:
  if num-entries(v_cod_dwb_file,":":U) = 2 then do:
    assign cPrinter = substring(ed_1x40:screen-value in frame {&frame-name},1,index(ed_1x40:screen-value in frame {&frame-name},":":U) - 1)
           c-layout = substring(ed_1x40:screen-value in frame {&frame-name},index(ed_1x40:screen-value in frame {&frame-name},":":U) + 1,length(ed_1x40:screen-value in frame {&frame-name}) - index(ed_1x40:screen-value in frame {&frame-name},":":U)). 
    find imprsor_usuar no-lock
         where imprsor_usuar.nom_impressora = cPrinter
         and imprsor_usuar.cod_usuario = v_cod_usuar_corren
         no-error.
    if not avail imprsor_usuar then do:
      run utp/ut-msgs.p (input "show":U, 
                         input 4306, 
                         input v_cod_usuar_corren).
      return "NOK".
    end.       
    find layout_impres no-lock
         where layout_impres.nom_impressora = cPrinter
         and layout_impres.cod_layout_impres = c-layout no-error.
    if not avail layout_impres then do:
      run utp/ut-msgs.p (input "show":U, 
                         input 4306, 
                         input v_cod_usuar_corren).
      return "NOK".
    end.       
  end.  
  else do:
    if num-entries(ed_1x40,":":U) < 2 then do:
      run utp/ut-msgs.p (input "show":U, 
                         input 4306, 
                         input v_cod_usuar_corren).
      return "NOK".
    end.
    assign v_cod_dwb_file = ed_1x40:screen-value in frame {&frame-name}.
    assign cPrinter = entry(1,ed_1x40,":":U)
           c-layout = entry(2,ed_1x40,":":U). 
    find imprsor_usuar no-lock
         where imprsor_usuar.nom_impressora = cPrinter
         and imprsor_usuar.cod_usuario = v_cod_usuar_corren
         use-index imprsrsr_id no-error.
    if not avail imprsor_usuar then do:
      run utp/ut-msgs.p (input "show":U, 
                         input 4306, 
                         input v_cod_usuar_corren).
      return "NOK".
    end.       
    find layout_impres no-lock
         where layout_impres.nom_impressora = cPrinter
         and layout_impres.cod_layout_impres = c-layout no-error.
    if not avail layout_impres then do:
      run utp/ut-msgs.p (input "show":U, 
                         input 4306, 
                         input v_cod_usuar_corren).
      return "NOK".
    end.       
  end.
end.  
return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_configure_dwb_param wWin 
PROCEDURE pi_configure_dwb_param :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        find dwb_rpt_param exclusive-lock
             where dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
               and dwb_rpt_param.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_param of dwb_rpt_param*/ no-error.
               
        if  not available dwb_rpt_param
        then do:
            create dwb_rpt_param.
            assign dwb_rpt_param.cod_dwb_program         = v_cod_dwb_program
                   dwb_rpt_param.cod_dwb_user            = v_cod_dwb_user
                   dwb_rpt_param.cod_dwb_parameters      = v_cod_dwb_parameters
                   dwb_rpt_param.cod_dwb_output          = "Terminal" /*l_terminal*/ 
                   dwb_rpt_param.cod_dwb_order           = v_cod_dwb_order
                   dwb_rpt_param.ind_dwb_run_mode        = "On-Line" /*l_online*/ 
                   dwb_rpt_param.cod_dwb_file            = ""
                   dwb_rpt_param.nom_dwb_printer         = ""
                   dwb_rpt_param.cod_dwb_print_layout    = ""
                   v_cod_dwb_file_temp                   = ""
                   ls_order:list-items in frame {&frame-name} = v_cod_dwb_order.
        end /* if */.
        else do:
            assign ls_order:list-items in frame {&frame-name} = "!".
            if  ls_order:delete(1) in frame {&frame-name}
            then do:
                order_1:
                repeat v_num_entry = 1 to num-entries (dwb_rpt_param.cod_dwb_order):
                    assign v_cod_dwb_field = entry (v_num_entry, dwb_rpt_param.cod_dwb_order).
                    if  lookup (v_cod_dwb_field, v_cod_dwb_order) > 0 and
                        ls_order:lookup (v_cod_dwb_field) = 0
                    then do:
                        assign v_log_method = ls_order:add-last(v_cod_dwb_field).
                    end /* if */.
                end /* repeat order_1 */.
                order_2:
                repeat v_num_entry = 1 to num-entries (v_cod_dwb_order):
                    assign v_cod_dwb_field = entry (v_num_entry, v_cod_dwb_order).
                    if  ls_order:lookup (v_cod_dwb_field) = 0
                    then do:
                       assign v_log_method = ls_order:add-last(v_cod_dwb_field).
                    end /* if */.
                end /* repeat order_2 */.
            end /* if */.

            assign v_cod_dwb_file_temp = replace(dwb_rpt_param.cod_dwb_file, "~\", "~/").
            if  index(v_cod_dwb_file_temp, "~/") <> 0
            then do:
                assign v_cod_dwb_file_temp = substring(v_cod_dwb_file_temp, r-index(v_cod_dwb_file_temp, "~/") + 1).
            end /* if */.
            else do:
                assign v_cod_dwb_file_temp = dwb_rpt_param.cod_dwb_file.
            end /* else */.
        end /* else */.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_edl_dwb_rpt_select wWin 
PROCEDURE pi_edl_dwb_rpt_select :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /************************ Parameter Definition Begin ************************/

    def Input param p_rec_dwb_rpt_select
        as recid
        format ">>>>>>9"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_num_dwb_order
        as integer
        format ">>>>,>>9":U
        no-undo.
    def var v_wgh_fill_in_fim
        as widget-handle
        format ">>>>>>9":U
        no-undo.
    def var v_wgh_fill_in_ini
        as widget-handle
        format ">>>>>>9":U
        no-undo.
    def var v_wgh_label_fim
        as widget-handle
        format ">>>>>>9":U
        no-undo.
    def var v_wgh_label_ini
        as widget-handle
        format ">>>>>>9":U
        no-undo.
    def var v_log_ok                         as logical         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    /************************ Rectangle Definition Begin ************************/

    def rectangle rt_001
        size 1 by 1
        edge-pixels 2.
    def rectangle rt_002
        size 1 by 1
        edge-pixels 2.
    def rectangle rt_cxcf
        size 1 by 1
        fgcolor 1 edge-pixels 2.


    /************************* Rectangle Definition End *************************/

    /************************** Button Definition Begin *************************/

    def button bt_can
        label "Cancela"
        tooltip "Cancela"
        size 1 by 1
        auto-endkey.
    def button bt_hel2
        label "Ajuda"
        tooltip "Ajuda"
        size 1 by 1.
    def button bt_ok
        label "OK"
        tooltip "OK"
        size 1 by 1
        auto-go.
    def button bt_sav
        label "Salva"
        tooltip "Salva"
        size 1 by 1
        auto-go.
    /****************************** Function Button *****************************/


    /*************************** Button Definition End **************************/

    /************************** Frame Definition Begin **************************/

    def frame f_dlg_04_dwb_rpt_select
        rt_001
             at row 01.25 col 02.00
        rt_002
             at row 02.75 col 03.00
        " Conjunto " view-as text
             at row 02.45 col 05.00
        rt_cxcf
             at row 08.17 col 02.00 bgcolor 7 
        dwb_rpt_select.log_dwb_rule
             at row 01.50 col 03.14 no-label
             view-as radio-set Horizontal
             radio-buttons "Regra", yes,"Exceá∆o", no
              /*l_rule*/ /*l_yes*/ /*l_exception*/ /*l_no*/
             bgcolor 8 
        dwb_rpt_select.cod_dwb_field
             at row 03.21 col 04.29 no-label
             view-as combo-box
             list-items "!"
              /*l_!*/
             inner-lines 5
             bgcolor 15 font 2
        bt_ok
             at row 08.38 col 03.00 font ?
             help "OK"
        bt_sav
             at row 08.38 col 14.00 font ?
             help "Salva"
        bt_can
             at row 08.38 col 25.00 font ?
             help "Cancela"
        bt_hel2
             at row 08.38 col 51.13 font ?
             help "Ajuda"
        with 1 down side-labels no-validate keep-tab-order three-d
             size-char 63.57 by 10.00 default-button bt_sav
             view-as dialog-box
             font 1 fgcolor ? bgcolor 8
             title "Conjunto de Seleá∆o".
        /* adjust size of objects in this frame */
        assign bt_can:width-chars   in frame f_dlg_04_dwb_rpt_select = 10.00
               bt_can:height-chars  in frame f_dlg_04_dwb_rpt_select = 01.00
               bt_hel2:width-chars  in frame f_dlg_04_dwb_rpt_select = 10.00
               bt_hel2:height-chars in frame f_dlg_04_dwb_rpt_select = 01.00
               bt_ok:width-chars    in frame f_dlg_04_dwb_rpt_select = 10.00
               bt_ok:height-chars   in frame f_dlg_04_dwb_rpt_select = 01.00
               bt_sav:width-chars   in frame f_dlg_04_dwb_rpt_select = 10.00
               bt_sav:height-chars  in frame f_dlg_04_dwb_rpt_select = 01.00
               rt_001:width-chars   in frame f_dlg_04_dwb_rpt_select = 60.00
               rt_001:height-chars  in frame f_dlg_04_dwb_rpt_select = 06.75
               rt_002:width-chars   in frame f_dlg_04_dwb_rpt_select = 58.00
               rt_002:height-chars  in frame f_dlg_04_dwb_rpt_select = 05.00
               rt_cxcf:width-chars  in frame f_dlg_04_dwb_rpt_select = 60.13
               rt_cxcf:height-chars in frame f_dlg_04_dwb_rpt_select = 01.42.


{include/i_fclfrm.i f_dlg_04_dwb_rpt_select }
    /*************************** Frame Definition End ***************************/

    /*********************** User Interface Trigger Begin ***********************/


    ON CHOOSE OF bt_hel2 IN FRAME f_dlg_04_dwb_rpt_select
    DO:


        /* Begin_Include: i_context_help_frame */
        run prgtec/men/men900za.py (Input self:frame,
                                    Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


        /* End_Include: i_context_help_frame */

    END. /* ON CHOOSE OF bt_hel2 IN FRAME f_dlg_04_dwb_rpt_select */

    ON CHOOSE OF bt_ok IN FRAME f_dlg_04_dwb_rpt_select
    DO:

        assign v_log_ok = yes.
    END. /* ON CHOOSE OF bt_ok IN FRAME f_dlg_04_dwb_rpt_select */

    ON VALUE-CHANGED OF dwb_rpt_select.cod_dwb_field IN FRAME f_dlg_04_dwb_rpt_select
    DO:

        assign v_cod_dwb_field = self:screen-value in frame f_dlg_04_dwb_rpt_select.

        run pi_isl_rpt_esfas002 /*pi_isl_rpt_bem_pat_sit_geral_pat*/.

        if  v_wgh_label_ini = ?
        then do:
            create text v_wgh_label_ini
                assign frame        = frame f_dlg_04_dwb_rpt_select:handle
                    screen-value = "Inicial:" /*l_Inicial:*/ 
                    visible      = no
                    row          = 5
                    col          = 12
                    width        = 7.
{include/i_fcldin.i v_wgh_label_ini }
        end /* if */.

        if  v_wgh_label_fim = ?
        then do:
            create text v_wgh_label_fim
                assign frame        = frame f_dlg_04_dwb_rpt_select:handle
                    screen-value = "  Final:" /*l_bbfinal:*/ 
                    visible      = no
                    row          = 6
                    col          = 12
                    width        = 7.
{include/i_fcldin.i v_wgh_label_fim }
        end /* if */.

        if  v_wgh_fill_in_ini <> ?
        then do:
            delete widget v_wgh_fill_in_ini.
        end /* if */.

        create fill-in v_wgh_fill_in_ini
            assign frame              = frame f_dlg_04_dwb_rpt_select:handle
                   font               = 2
                   data-type          = v_cod_dat_type
                   format             = v_cod_format
                   side-label-handle  = v_wgh_label_ini:handle
                   row                = 5
                   column             = 19
                   height             = 0.88
                   bgcolor            = 15
                   visible            = yes
                   sensitive          = yes
                   screen-value       = v_cod_initial.
{include/i_fcldin.i v_wgh_fill_in_ini }

        if  v_wgh_fill_in_fim <> ?
        then do:
            delete widget v_wgh_fill_in_fim.
        end /* if */.

        create fill-in v_wgh_fill_in_fim
            assign frame              = frame f_dlg_04_dwb_rpt_select:handle
                   font               = 2
                   data-type          = v_cod_dat_type
                   format             = v_cod_format
                   side-label-handle  = v_wgh_label_fim:handle
                   row                = 6
                   col                = 19
                   height             = 0.88
                   bgcolor            = 15
                   visible            = yes
                   sensitive          = yes
                   screen-value       = v_cod_final.
{include/i_fcldin.i v_wgh_fill_in_fim }

    END. /* ON VALUE-CHANGED OF dwb_rpt_select.cod_dwb_field IN FRAME f_dlg_04_dwb_rpt_select */

    ON VALUE-CHANGED OF dwb_rpt_select.log_dwb_rule IN FRAME f_dlg_04_dwb_rpt_select
    DO:

        /************************** Buffer Definition Begin *************************/

        &if "{&emsbas_version}" >= "1.00" &then
        def buffer b_dwb_rpt_select
            for dwb_rpt_select.
        &endif


        /*************************** Buffer Definition End **************************/

        find last b_dwb_rpt_select
            where b_dwb_rpt_select.cod_dwb_program = v_cod_dwb_program
            and   b_dwb_rpt_select.cod_dwb_user    = v_cod_dwb_user
            and   b_dwb_rpt_select.log_dwb_rule    = (dwb_rpt_select.log_dwb_rule:screen-value = 'yes')
            no-lock no-error.
        if  not available b_dwb_rpt_select
        then do:
            assign v_num_dwb_order = (if dwb_rpt_select.log_dwb_rule:screen-value = 'yes' then 10 else 500).
        end /* if */.
        else do:
            assign v_num_dwb_order = b_dwb_rpt_select.num_dwb_order + 10.
        end /* else */.
    END. /* ON VALUE-CHANGED OF dwb_rpt_select.log_dwb_rule IN FRAME f_dlg_04_dwb_rpt_select */


    /************************ User Interface Trigger End ************************/

    /**************************** Frame Trigger Begin ***************************/


    ON GO OF FRAME f_dlg_04_dwb_rpt_select
    DO:

        if  (v_wgh_fill_in_ini:data-type = 'character' and v_wgh_fill_in_ini:screen-value > v_wgh_fill_in_fim:screen-value) or
             (v_wgh_fill_in_ini:data-type = 'date'      and date(v_wgh_fill_in_ini:screen-value) > date(v_wgh_fill_in_fim:screen-value)) or
             (v_wgh_fill_in_ini:data-type = "integer" /*l_integer*/    and integer(v_wgh_fill_in_ini:screen-value) > integer(v_wgh_fill_in_fim:screen-value)) or
             (v_wgh_fill_in_ini:data-type = 'Decimal'   and decimal(v_wgh_fill_in_ini:screen-value) > decimal(v_wgh_fill_in_fim:screen-value))
        then do:
            /* Argumento Inicial maior que o Final ! */
            run pi_messages (input "show",
                             input 1085,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1085*/.
            return no-apply.
        end /* if */.

    END. /* ON GO OF FRAME f_dlg_04_dwb_rpt_select */

    ON HELP OF FRAME f_dlg_04_dwb_rpt_select ANYWHERE
    DO:


        /* Begin_Include: i_context_help */
        run prgtec/men/men900za.py (Input self:handle,
                                    Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
        /* End_Include: i_context_help */

    END. /* ON HELP OF FRAME f_dlg_04_dwb_rpt_select */

    ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_04_dwb_rpt_select ANYWHERE
    DO:

        /************************* Variable Definition Begin ************************/

        def var v_wgh_frame
            as widget-handle
            format ">>>>>>9":U
            no-undo.


        /************************** Variable Definition End *************************/


        /* Begin_Include: i_right_mouse_down_dialog_box */
        if  (self:type <> "DIALOG-BOX" /*l_dialog_box*/ )
        and (self:type <> "FRAME" /*l_frame*/      )
        and (self:type <> "text" /*l_text*/       )
        and (self:type <> "IMAGE" /*l_image*/      )
        and (self:type <> "RECTANGLE" /*l_rectangle*/  )
        then do:

            assign v_wgh_frame = self:parent.

            if  self:type        = "fill-in" /*l_fillin*/ 
            and v_wgh_frame:type = "Browse" /*l_browse*/  then
                return no-apply.

            if  valid-handle(self:popup-menu) = yes then
                return no-apply.

            assign v_wgh_frame = self:frame.

            if  (v_wgh_frame:type <> "DIALOG-BOX" /*l_dialog_box*/ ) and (v_wgh_frame:frame <> ?)
            then do:
                   assign v_wgh_frame     = v_wgh_frame:frame.
            end /* if */.
            assign v_nom_title_aux    = v_wgh_frame:title
                   v_wgh_frame:title  = self:help.
        end /* if */.
        /* End_Include: i_right_mouse_down_dialog_box */

    END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_04_dwb_rpt_select */

    ON RIGHT-MOUSE-UP OF FRAME f_dlg_04_dwb_rpt_select ANYWHERE
    DO:

        /************************* Variable Definition Begin ************************/

        def var v_wgh_frame
            as widget-handle
            format ">>>>>>9":U
            no-undo.


        /************************** Variable Definition End *************************/


        /* Begin_Include: i_right_mouse_up_dialog_box */
        if  (self:type <> "DIALOG-BOX" /*l_dialog_box*/ )
        and (self:type <> "FRAME" /*l_frame*/      )
        and (self:type <> "text" /*l_text*/       )
        and (self:type <> "IMAGE" /*l_image*/      )
        and (self:type <> "RECTANGLE" /*l_rectangle*/  )
        then do:

            assign v_wgh_frame = self:parent.

            if  self:type        = "fill-in" /*l_fillin*/ 
            and v_wgh_frame:type = "Browse" /*l_browse*/  then
                return no-apply.

            if  valid-handle(self:popup-menu) = yes then
                return no-apply.

            assign v_wgh_frame        = self:frame.
            if  (v_wgh_frame:type <> "DIALOG-BOX" /*l_dialog_box*/ ) and (v_wgh_frame:frame <> ?)
            then do:
                   assign v_wgh_frame     = v_wgh_frame:frame.
            end /* if */.
            assign v_wgh_frame:title  = v_nom_title_aux.
        end /* if */.

        /* End_Include: i_right_mouse_up_dialog_box */

    END. /* ON RIGHT-MOUSE-UP OF FRAME f_dlg_04_dwb_rpt_select */


    /***************************** Frame Trigger End ****************************/

    pause 0 before-hide.
    view frame f_dlg_04_dwb_rpt_select.

    assign v_log_ok = no
           frame f_dlg_04_dwb_rpt_select:title = "Edita" /*l_edita*/  + " Conjunto de Seleá∆o" /*l_conjunto_selecao*/ .

    main_block:
    repeat while v_log_ok = no
        on endkey undo main_block, leave main_block
        on error undo main_block, leave main_block:

        find dwb_rpt_select where recid(dwb_rpt_select) = p_rec_dwb_rpt_select exclusive-lock.

        assign dwb_rpt_select.cod_dwb_field:list-items in frame f_dlg_04_dwb_rpt_select = v_cod_dwb_select
               v_cod_dwb_field = dwb_rpt_select.cod_dwb_field.

        display dwb_rpt_select.log_dwb_rule
                dwb_rpt_select.cod_dwb_field
                with frame f_dlg_04_dwb_rpt_select.

        run pi_isl_rpt_esfas002 /*pi_isl_rpt_bem_pat_sit_geral_pat*/.

        create text v_wgh_label_ini
            assign frame        = frame f_dlg_04_dwb_rpt_select:handle
                screen-value = "Inicial:" /*l_Inicial:*/ 
                visible      = no
                row          = 5
                col          = 12
                width        = 7.
{include/i_fcldin.i v_wgh_label_ini }

        create text v_wgh_label_fim
            assign frame        = frame f_dlg_04_dwb_rpt_select:handle
                screen-value = "  Final:" /*l_bbfinal:*/ 
                visible      = no
                row          = 6
                col          = 12
                width        = 7.
{include/i_fcldin.i v_wgh_label_fim }

        create fill-in v_wgh_fill_in_ini
            assign frame          = frame f_dlg_04_dwb_rpt_select:handle
               font               = 2
               data-type          = v_cod_dat_type
               format             = v_cod_format
               side-label-handle  = v_wgh_label_ini:handle
               row                = 5
               column             = 19
               height             = 0.88
               bgcolor            = 15
               visible            = yes
               sensitive          = yes
               screen-value       = dwb_rpt_select.cod_dwb_initial.
{include/i_fcldin.i v_wgh_fill_in_ini }

        create fill-in v_wgh_fill_in_fim
            assign frame          = frame f_dlg_04_dwb_rpt_select:handle
               font               = 2
               data-type          = v_cod_dat_type
               format             = v_cod_format
               side-label-handle  = v_wgh_label_fim:handle
               row                = 6
               col                = 19
               height             = 0.88
               bgcolor            = 15
               visible            = yes
               sensitive          = yes
               screen-value       = dwb_rpt_select.cod_dwb_final.
{include/i_fcldin.i v_wgh_fill_in_fim }


        disable dwb_rpt_select.log_dwb_rule
                dwb_rpt_select.cod_dwb_field
                with frame f_dlg_04_dwb_rpt_select.

        enable bt_ok
               bt_can
               with frame f_dlg_04_dwb_rpt_select.

        wait-for go of frame f_dlg_04_dwb_rpt_select.

        assign dwb_rpt_select.cod_dwb_initial = v_wgh_fill_in_ini:screen-value
               dwb_rpt_select.cod_dwb_final   = v_wgh_fill_in_fim:screen-value.

    end /* repeat main_block */.

    hide frame f_dlg_04_dwb_rpt_select.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_initialize_reports wWin 
PROCEDURE pi_initialize_reports :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* inicializa vari†veis */
    find emscad.empresa no-lock
         where empresa.cod_empresa = v_cod_empres_usuar /*cl_empres_usuar of empresa*/ no-error.
    find dwb_rpt_param
         where dwb_rpt_param.cod_dwb_program = "esfas002":U
           and dwb_rpt_param.cod_dwb_user    = v_cod_dwb_user
           no-lock no-error.

    if  avail dwb_rpt_param then do:
    &if '{&emsbas_version}' > '1.00' &then
    &if '{&emsbas_version}' >= '5.03' &then
        assign v_nom_dwb_print_file = dwb_rpt_param.nom_dwb_print_file.
    &else
        assign v_nom_dwb_print_file = dwb_rpt_param.cod_livre_1.
    &endif
    &endif
        if  dwb_rpt_param.qtd_dwb_line <> 0 then
            assign v_qtd_line = dwb_rpt_param.qtd_dwb_line.
        else
            assign v_qtd_line = v_rpt_s_1_lines.
    end.

    assign v_cod_dwb_proced   = "esfas002":U
           v_cod_dwb_program  = "esfas002":U

           v_cod_dwb_order    = "Conta Patrimonial,Bem Patrimonial,Descriá∆o Bem Pat,Data Aquisiá∆o"

           v_cod_release      = trim(c-versao-prg)

           v_cod_dwb_select   = "Conta Patrimonial,Bem Patrimonial,Descriá∆o Bem Pat,Data Aquisiá∆o"

           v_ind_dwb_run_mode = "On-Line" /*l_online*/ 
           v_rpt_s_1_columns  = 255
           v_qtd_column       = v_rpt_s_1_columns
           v_qtd_bottom       = v_rpt_s_1_bottom.
    if  avail empresa
    then do:
        assign v_nom_enterprise   = empresa.nom_razao_social.
    end /* if */.
    else do:
        assign v_nom_enterprise   = 'DATASUL'.
    end /* else */.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_isl_dwb_rpt_select wWin 
PROCEDURE pi_isl_dwb_rpt_select :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /************************* Variable Definition Begin ************************/

    def var v_num_dwb_order
        as integer
        format ">>>>,>>9":U
        no-undo.
    def var v_wgh_fill_in_fim
        as widget-handle
        format ">>>>>>9":U
        no-undo.
    def var v_wgh_fill_in_ini
        as widget-handle
        format ">>>>>>9":U
        no-undo.
    def var v_wgh_label_fim
        as widget-handle
        format ">>>>>>9":U
        no-undo.
    def var v_wgh_label_ini
        as widget-handle
        format ">>>>>>9":U
        no-undo.
    def var v_log_ok                         as logical         no-undo. /*local*/


    /************************** Variable Definition End *************************/

    /************************ Rectangle Definition Begin ************************/

    def rectangle rt_001
        size 1 by 1
        edge-pixels 2.
    def rectangle rt_002
        size 1 by 1
        edge-pixels 2.
    def rectangle rt_cxcf
        size 1 by 1
        fgcolor 1 edge-pixels 2.


    /************************* Rectangle Definition End *************************/

    /************************** Button Definition Begin *************************/

    def button bt_can
        label "Cancela"
        tooltip "Cancela"
        size 1 by 1
        auto-endkey.
    def button bt_hel2
        label "Ajuda"
        tooltip "Ajuda"
        size 1 by 1.
    def button bt_ok
        label "OK"
        tooltip "OK"
        size 1 by 1
        auto-go.
    def button bt_sav
        label "Salva"
        tooltip "Salva"
        size 1 by 1
        auto-go.
    /****************************** Function Button *****************************/


    /*************************** Button Definition End **************************/

    /************************** Frame Definition Begin **************************/

    def frame f_dlg_04_dwb_rpt_select
        rt_001
             at row 01.25 col 02.00
        rt_002
             at row 02.75 col 03.00
        " Conjunto " view-as text
             at row 02.45 col 05.00
        rt_cxcf
             at row 08.17 col 02.00 bgcolor 7 
        dwb_rpt_select.log_dwb_rule
             at row 01.50 col 03.14 no-label
             view-as radio-set Horizontal
             radio-buttons "Regra", yes,"Exceá∆o", no
              /*l_rule*/ /*l_yes*/ /*l_exception*/ /*l_no*/
             bgcolor 8 
        dwb_rpt_select.cod_dwb_field
             at row 03.21 col 04.29 no-label
             view-as combo-box
             list-items "!"
              /*l_!*/
             inner-lines 5
             bgcolor 15 font 2
        bt_ok
             at row 08.38 col 03.00 font ?
             help "OK"
        bt_sav
             at row 08.38 col 14.00 font ?
             help "Salva"
        bt_can
             at row 08.38 col 25.00 font ?
             help "Cancela"
        bt_hel2
             at row 08.38 col 51.13 font ?
             help "Ajuda"
        with 1 down side-labels no-validate keep-tab-order three-d
             size-char 63.57 by 10.00 default-button bt_sav
             view-as dialog-box
             font 1 fgcolor ? bgcolor 8
             title "Conjunto de Seleá∆o".
        /* adjust size of objects in this frame */
        assign bt_can:width-chars   in frame f_dlg_04_dwb_rpt_select = 10.00
               bt_can:height-chars  in frame f_dlg_04_dwb_rpt_select = 01.00
               bt_hel2:width-chars  in frame f_dlg_04_dwb_rpt_select = 10.00
               bt_hel2:height-chars in frame f_dlg_04_dwb_rpt_select = 01.00
               bt_ok:width-chars    in frame f_dlg_04_dwb_rpt_select = 10.00
               bt_ok:height-chars   in frame f_dlg_04_dwb_rpt_select = 01.00
               bt_sav:width-chars   in frame f_dlg_04_dwb_rpt_select = 10.00
               bt_sav:height-chars  in frame f_dlg_04_dwb_rpt_select = 01.00
               rt_001:width-chars   in frame f_dlg_04_dwb_rpt_select = 60.00
               rt_001:height-chars  in frame f_dlg_04_dwb_rpt_select = 06.75
               rt_002:width-chars   in frame f_dlg_04_dwb_rpt_select = 58.00
               rt_002:height-chars  in frame f_dlg_04_dwb_rpt_select = 05.00
               rt_cxcf:width-chars  in frame f_dlg_04_dwb_rpt_select = 60.13
               rt_cxcf:height-chars in frame f_dlg_04_dwb_rpt_select = 01.42.


{include/i_fclfrm.i f_dlg_04_dwb_rpt_select }
    /*************************** Frame Definition End ***************************/

    /*********************** User Interface Trigger Begin ***********************/


    ON CHOOSE OF bt_hel2 IN FRAME f_dlg_04_dwb_rpt_select
    DO:


        /* Begin_Include: i_context_help_frame */
        run prgtec/men/men900za.py (Input self:frame,
                                    Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


        /* End_Include: i_context_help_frame */

    END. /* ON CHOOSE OF bt_hel2 IN FRAME f_dlg_04_dwb_rpt_select */

    ON CHOOSE OF bt_ok IN FRAME f_dlg_04_dwb_rpt_select
    DO:

        assign v_log_ok = yes.
    END. /* ON CHOOSE OF bt_ok IN FRAME f_dlg_04_dwb_rpt_select */

    ON VALUE-CHANGED OF dwb_rpt_select.cod_dwb_field IN FRAME f_dlg_04_dwb_rpt_select
    DO:

        assign v_cod_dwb_field = self:screen-value in frame f_dlg_04_dwb_rpt_select.

        run pi_isl_rpt_esfas002 /*pi_isl_rpt_bem_pat_sit_geral_pat*/.

        if  v_wgh_label_ini = ?
        then do:
            create text v_wgh_label_ini
                assign frame        = frame f_dlg_04_dwb_rpt_select:handle
                    screen-value = "Inicial:" /*l_Inicial:*/ 
                    visible      = no
                    row          = 5
                    col          = 12
                    width        = 7.
{include/i_fcldin.i v_wgh_label_ini }
        end /* if */.

        if  v_wgh_label_fim = ?
        then do:
            create text v_wgh_label_fim
                assign frame        = frame f_dlg_04_dwb_rpt_select:handle
                    screen-value = "  Final:" /*l_bbfinal:*/ 
                    visible      = no
                    row          = 6
                    col          = 12
                    width        = 7.
{include/i_fcldin.i v_wgh_label_fim }
        end /* if */.

        if  v_wgh_fill_in_ini <> ?
        then do:
            delete widget v_wgh_fill_in_ini.
        end /* if */.

        create fill-in v_wgh_fill_in_ini
            assign frame              = frame f_dlg_04_dwb_rpt_select:handle
                   font               = 2
                   data-type          = v_cod_dat_type
                   format             = v_cod_format
                   side-label-handle  = v_wgh_label_ini:handle
                   row                = 5
                   column             = 19
                   height             = 0.88
                   bgcolor            = 15
                   visible            = yes
                   sensitive          = yes
                   screen-value       = v_cod_initial.
{include/i_fcldin.i v_wgh_fill_in_ini }

        if  v_wgh_fill_in_fim <> ?
        then do:
            delete widget v_wgh_fill_in_fim.
        end /* if */.

        create fill-in v_wgh_fill_in_fim
            assign frame              = frame f_dlg_04_dwb_rpt_select:handle
                   font               = 2
                   data-type          = v_cod_dat_type
                   format             = v_cod_format
                   side-label-handle  = v_wgh_label_fim:handle
                   row                = 6
                   col                = 19
                   height             = 0.88
                   bgcolor            = 15
                   visible            = yes
                   sensitive          = yes
                   screen-value       = v_cod_final.
{include/i_fcldin.i v_wgh_fill_in_fim }

    END. /* ON VALUE-CHANGED OF dwb_rpt_select.cod_dwb_field IN FRAME f_dlg_04_dwb_rpt_select */

    ON VALUE-CHANGED OF dwb_rpt_select.log_dwb_rule IN FRAME f_dlg_04_dwb_rpt_select
    DO:

        /************************** Buffer Definition Begin *************************/

        &if "{&emsbas_version}" >= "1.00" &then
        def buffer b_dwb_rpt_select
            for dwb_rpt_select.
        &endif


        /*************************** Buffer Definition End **************************/

        find last b_dwb_rpt_select
            where b_dwb_rpt_select.cod_dwb_program = v_cod_dwb_program
            and   b_dwb_rpt_select.cod_dwb_user    = v_cod_dwb_user
            and   b_dwb_rpt_select.log_dwb_rule    = (dwb_rpt_select.log_dwb_rule:screen-value = 'yes')
            no-lock no-error.
        if  not available b_dwb_rpt_select
        then do:
            assign v_num_dwb_order = (if dwb_rpt_select.log_dwb_rule:screen-value = 'yes' then 10 else 500).
        end /* if */.
        else do:
            assign v_num_dwb_order = b_dwb_rpt_select.num_dwb_order + 10.
        end /* else */.
    END. /* ON VALUE-CHANGED OF dwb_rpt_select.log_dwb_rule IN FRAME f_dlg_04_dwb_rpt_select */


    /************************ User Interface Trigger End ************************/

    /**************************** Frame Trigger Begin ***************************/


    ON GO OF FRAME f_dlg_04_dwb_rpt_select
    DO:

        if  (v_wgh_fill_in_ini:data-type = 'character' and v_wgh_fill_in_ini:screen-value > v_wgh_fill_in_fim:screen-value) or
             (v_wgh_fill_in_ini:data-type = 'date'      and date(v_wgh_fill_in_ini:screen-value) > date(v_wgh_fill_in_fim:screen-value)) or
             (v_wgh_fill_in_ini:data-type = "integer" /*l_integer*/    and integer(v_wgh_fill_in_ini:screen-value) > integer(v_wgh_fill_in_fim:screen-value)) or
             (v_wgh_fill_in_ini:data-type = 'Decimal'   and decimal(v_wgh_fill_in_ini:screen-value) > decimal(v_wgh_fill_in_fim:screen-value))
        then do:
            /* Argumento Inicial maior que o Final ! */
            run pi_messages (input "show",
                             input 1085,
                             input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")) /*msg_1085*/.
            return no-apply.
        end /* if */.

    END. /* ON GO OF FRAME f_dlg_04_dwb_rpt_select */

    ON HELP OF FRAME f_dlg_04_dwb_rpt_select ANYWHERE
    DO:


        /* Begin_Include: i_context_help */
        run prgtec/men/men900za.py (Input self:handle,
                                    Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.
        /* End_Include: i_context_help */

    END. /* ON HELP OF FRAME f_dlg_04_dwb_rpt_select */

    ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_04_dwb_rpt_select ANYWHERE
    DO:

        /************************* Variable Definition Begin ************************/

        def var v_wgh_frame
            as widget-handle
            format ">>>>>>9":U
            no-undo.


        /************************** Variable Definition End *************************/


        /* Begin_Include: i_right_mouse_down_dialog_box */
        if  (self:type <> "DIALOG-BOX" /*l_dialog_box*/ )
        and (self:type <> "FRAME" /*l_frame*/      )
        and (self:type <> "text" /*l_text*/       )
        and (self:type <> "IMAGE" /*l_image*/      )
        and (self:type <> "RECTANGLE" /*l_rectangle*/  )
        then do:

            assign v_wgh_frame = self:parent.

            if  self:type        = "fill-in" /*l_fillin*/ 
            and v_wgh_frame:type = "Browse" /*l_browse*/  then
                return no-apply.

            if  valid-handle(self:popup-menu) = yes then
                return no-apply.

            assign v_wgh_frame = self:frame.

            if  (v_wgh_frame:type <> "DIALOG-BOX" /*l_dialog_box*/ ) and (v_wgh_frame:frame <> ?)
            then do:
                   assign v_wgh_frame     = v_wgh_frame:frame.
            end /* if */.
            assign v_nom_title_aux    = v_wgh_frame:title
                   v_wgh_frame:title  = self:help.
        end /* if */.
        /* End_Include: i_right_mouse_down_dialog_box */

    END. /* ON RIGHT-MOUSE-DOWN OF FRAME f_dlg_04_dwb_rpt_select */

    ON RIGHT-MOUSE-UP OF FRAME f_dlg_04_dwb_rpt_select ANYWHERE
    DO:

        /************************* Variable Definition Begin ************************/

        def var v_wgh_frame
            as widget-handle
            format ">>>>>>9":U
            no-undo.


        /************************** Variable Definition End *************************/


        /* Begin_Include: i_right_mouse_up_dialog_box */
        if  (self:type <> "DIALOG-BOX" /*l_dialog_box*/ )
        and (self:type <> "FRAME" /*l_frame*/      )
        and (self:type <> "text" /*l_text*/       )
        and (self:type <> "IMAGE" /*l_image*/      )
        and (self:type <> "RECTANGLE" /*l_rectangle*/  )
        then do:

            assign v_wgh_frame = self:parent.

            if  self:type        = "fill-in" /*l_fillin*/ 
            and v_wgh_frame:type = "Browse" /*l_browse*/  then
                return no-apply.

            if  valid-handle(self:popup-menu) = yes then
                return no-apply.

            assign v_wgh_frame        = self:frame.
            if  (v_wgh_frame:type <> "DIALOG-BOX" /*l_dialog_box*/ ) and (v_wgh_frame:frame <> ?)
            then do:
                   assign v_wgh_frame     = v_wgh_frame:frame.
            end /* if */.
            assign v_wgh_frame:title  = v_nom_title_aux.
        end /* if */.

        /* End_Include: i_right_mouse_up_dialog_box */

    END. /* ON RIGHT-MOUSE-UP OF FRAME f_dlg_04_dwb_rpt_select */


    /***************************** Frame Trigger End ****************************/

    pause 0 before-hide.
    view frame f_dlg_04_dwb_rpt_select.

    assign v_log_ok = no
           frame f_dlg_04_dwb_rpt_select:title = "Inclui" /*l_inclui*/  + " Conjunto de Seleá∆o" /*l_conjunto_selecao*/ .

    main_block:
    repeat while v_log_ok = no
        on endkey undo main_block, leave main_block
        on error undo main_block, leave main_block:

        find last dwb_rpt_select no-lock
             where dwb_rpt_select.cod_dwb_program = v_cod_dwb_program
               and dwb_rpt_select.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_select of dwb_rpt_select*/ no-error.
        if  not available dwb_rpt_select
        then do:
            assign v_num_dwb_order = 10.
        end /* if */.
        else do:
            assign v_num_dwb_order = dwb_rpt_select.num_dwb_order + 10.
        end /* else */.

        create dwb_rpt_select.
        assign dwb_rpt_select.log_dwb_rule = yes.

        assign dwb_rpt_select.cod_dwb_field:list-items in frame f_dlg_04_dwb_rpt_select = v_cod_dwb_select
               dwb_rpt_select.cod_dwb_field:screen-value = entry(1,v_cod_dwb_select).

        display dwb_rpt_select.log_dwb_rule
                with frame f_dlg_04_dwb_rpt_select.
        enable dwb_rpt_select.log_dwb_rule
               dwb_rpt_select.cod_dwb_field
               bt_ok
               bt_sav
               bt_can
               with frame f_dlg_04_dwb_rpt_select.
        apply "value-changed" to dwb_rpt_select.cod_dwb_field in frame f_dlg_04_dwb_rpt_select.
        apply "value-changed" to dwb_rpt_select.log_dwb_rule  in frame f_dlg_04_dwb_rpt_select.

        wait-for go of frame f_dlg_04_dwb_rpt_select.

        assign dwb_rpt_select.cod_dwb_program = v_cod_dwb_program
               dwb_rpt_select.cod_dwb_user    = v_cod_dwb_user
               dwb_rpt_select.num_dwb_order   = v_num_dwb_order
               dwb_rpt_select.cod_dwb_initial = v_wgh_fill_in_ini:screen-value
               dwb_rpt_select.cod_dwb_final   = v_wgh_fill_in_fim:screen-value
               dwb_rpt_select.log_dwb_rule
               dwb_rpt_select.cod_dwb_field.

    end /* repeat main_block */.

    hide frame f_dlg_04_dwb_rpt_select.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_isl_rpt_esfas002 wWin 
PROCEDURE pi_isl_rpt_esfas002 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* formato: */
    case v_cod_dwb_field:
        when "Conta Patrimonial" then
            assign v_cod_dat_type = "character"
                   v_cod_format   = "x(18)":U
                   v_cod_initial  = string("":U, v_cod_format)
                   v_cod_final    = string("ZZZZZZZZZZZZZZZZZZ":U, v_cod_format).
        when "Bem Patrimonial" then
            assign v_cod_dat_type = "integer"
                   v_cod_format   = ">>>>>>>>9":U
                   v_cod_initial  = string(0, v_cod_format)
                   v_cod_final    = string(999999999, v_cod_format).
        when "Descriá∆o Bem Pat" then
            assign v_cod_dat_type = "character"
                   v_cod_format   = "x(40)":U
                   v_cod_initial  = string("":U, v_cod_format)
                   v_cod_final    = string("ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ":U, v_cod_format).
        when "Data Aquisiá∆o" then
            assign v_cod_dat_type = "date"
                   v_cod_format   = "99/99/9999":U
                   v_cod_initial  = string(01/01/0001, v_cod_format)
                   v_cod_final    = string(12/31/9999, v_cod_format).
        when "Data C†lculo" then
            assign v_cod_dat_type = "date"
                   v_cod_format   = "99/99/9999":U
                   v_cod_initial  = string(01/01/0001, v_cod_format)
                   v_cod_final    = string(12/31/9999, v_cod_format).
        when "Estabelecimento" then
            assign v_cod_dat_type = "character"
                   v_cod_format   = "x(3)":U
                   v_cod_initial  = string("":U, v_cod_format)
                   v_cod_final    = string("ZZZ":U, v_cod_format).
        when "Unid Neg¢cio" then
            assign v_cod_dat_type = "character"
                   v_cod_format   = "x(3)":U
                   v_cod_initial  = string("":U, v_cod_format)
                   v_cod_final    = string("ZZZ":U, v_cod_format).
        when "Plano Centros Custo" then
            assign v_cod_dat_type = "character"
                   v_cod_format   = "x(8)":U
                   v_cod_initial  = string("":U, v_cod_format)
                   v_cod_final    = string("ZZZZZZZZ":U, v_cod_format).
        when "CCusto Responsab" then
            assign v_cod_dat_type = "Character"
                   v_cod_format   = "x(11)":U
                   v_cod_initial  = string("":U, v_cod_format)
                   v_cod_final    = string("ZZZZZZZZZZZ":U, v_cod_format).  
    end /* case formato */.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_messages wWin 
PROCEDURE pi_messages :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param c_action    as char    no-undo.
    def input param i_msg       as integer no-undo.
    def input param c_param     as char    no-undo.

    def var c_prg_msg           as char    no-undo.

    assign c_prg_msg = "messages/":U
                     + string(trunc(i_msg / 1000,0),"99":U)
                     + "/msg":U
                     + string(i_msg, "99999":U).

    if search(c_prg_msg + ".r":U) = ? and search(c_prg_msg + ".p":U) = ? then do:
        message "Mensagem nr. " i_msg "!!!":U skip
                "Programa Mensagem" c_prg_msg "n∆o encontrado."
                view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p":U) (input c_action, input c_param).
    return return-value.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_open_dwb_rpt_select wWin 
PROCEDURE pi_open_dwb_rpt_select :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query qr_dwb_rpt_select for
        each dwb_rpt_select no-lock
        where dwb_rpt_select.cod_dwb_program = v_cod_dwb_program
          and dwb_rpt_select.cod_dwb_user = v_cod_dwb_user /*cl_dwb_rpt_select of dwb_rpt_select*/
            by dwb_rpt_select.log_dwb_rule descending
            by dwb_rpt_select.num_dwb_order.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_return_user wWin 
PROCEDURE pi_return_user :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /************************ Parameter Definition Begin ************************/

    def output param p_nom_user
        as character
        format "x(32)"
        no-undo.


    /************************* Parameter Definition End *************************/

    assign p_nom_user = v_cod_usuar_corren.

    if  v_cod_usuar_corren begins 'es_'
    then do:
       assign v_cod_usuar_corren = entry(2,v_cod_usuar_corren,"_").
    end /* if */.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_set_print_layout_default wWin 
PROCEDURE pi_set_print_layout_default :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    dflt:
    do with frame {&frame-name}:

        find layout_impres_padr no-lock
             where layout_impres_padr.cod_usuario = v_cod_dwb_user
               and layout_impres_padr.cod_proced = v_cod_dwb_proced
    &if "{&emsbas_version}" >= "5.01" &then
             use-index lytmprsp_id
    &endif
              /*cl_default_procedure_user of layout_impres_padr*/ no-error.
        if  not avail layout_impres_padr
        then do:
            find layout_impres_padr no-lock
                 where layout_impres_padr.cod_usuario = "*"
                   and layout_impres_padr.cod_proced = v_cod_dwb_proced
    &if "{&emsbas_version}" >= "5.01" &then
                 use-index lytmprsp_id
    &endif
                  /*cl_default_procedure of layout_impres_padr*/ no-error.
            if  avail layout_impres_padr
            then do:
                find imprsor_usuar no-lock
                     where imprsor_usuar.nom_impressora = layout_impres_padr.nom_impressora
                       and imprsor_usuar.cod_usuario = v_cod_dwb_user
    &if "{&emsbas_version}" >= "5.01" &then
                     use-index imprsrsr_id
    &endif
                      /*cl_layout_current_user of imprsor_usuar*/ no-error.
            end /* if */.
            if  not avail imprsor_usuar
            then do:
                find layout_impres_padr no-lock
                     where layout_impres_padr.cod_usuario = v_cod_dwb_user
                       and layout_impres_padr.cod_proced = "*"
    &if "{&emsbas_version}" >= "5.01" &then
                     use-index lytmprsp_id
    &endif
                      /*cl_default_user of layout_impres_padr*/ no-error.
            end /* if */.
        end /* if */.
        do transaction:
            find dwb_rpt_param
                where dwb_rpt_param.cod_dwb_user = v_cod_usuar_corren
                and   dwb_rpt_param.cod_dwb_program = v_cod_dwb_program
                exclusive-lock no-error.
            if  avail layout_impres_padr
            then do:
                assign dwb_rpt_param.nom_dwb_printer      = layout_impres_padr.nom_impressora
                       dwb_rpt_param.cod_dwb_print_layout = layout_impres_padr.cod_layout_impres
                       ed_1x40:screen-value = dwb_rpt_param.nom_dwb_printer
                                            + ":"
                                            + dwb_rpt_param.cod_dwb_print_layout.
            end /* if */.
            else do:
                assign dwb_rpt_param.nom_dwb_printer       = ""
                       dwb_rpt_param.cod_dwb_print_layout  = ""
                       ed_1x40:screen-value = "".
            end /* else */.
        end.
    end /* do dflt */.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_version_extract wWin 
PROCEDURE pi_version_extract :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_program
        as character
        format "x(08)"
        no-undo.
    def Input param p_cod_program_ext
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_version
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_program_type
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_event_dic
        as character
        format "x(20)":U
        label "Evento"
        column-label "Evento"
        no-undo.
    def var v_cod_tabela
        as character
        format "x(28)":U
        label "Tabela"
        column-label "Tabela"
        no-undo.


    /************************** Variable Definition End *************************/

    if  can-do(v_cod_tip_prog, p_cod_program_type)
    then do:
        if p_cod_program_type = 'dic' then 
           assign p_cod_program_ext = replace(p_cod_program_ext, 'database/', '').

        output stream s-arq to value(v_cod_arq) append.

        put stream s-arq unformatted
            p_cod_program            at 1 
            p_cod_program_ext        at 43 
            p_cod_version            at 69 
            today                    at 84 
            string(time, 'HH:MM:SS') at 94 skip.

        if  p_cod_program_type = 'pro' then do:
            &if '{&emsbas_version}' > '1.00' &then
            find prog_dtsul 
                where prog_dtsul.cod_prog_dtsul = p_cod_program 
                no-lock no-error.
            if  avail prog_dtsul
            then do:
                &if '{&emsbas_version}' > '5.00' &then
                    if  prog_dtsul.nom_prog_dpc <> '' then
                        put stream s-arq 'DPC : ' at 5 prog_dtsul.nom_prog_dpc  at 15 skip.
                &endif
                if  prog_dtsul.nom_prog_appc <> '' then
                    put stream s-arq 'APPC: ' at 5 prog_dtsul.nom_prog_appc at 15 skip.
                if  prog_dtsul.nom_prog_upc <> '' then
                    put stream s-arq 'UPC : ' at 5 prog_dtsul.nom_prog_upc  at 15 skip.
            end /* if */.
            &endif
        end.

        if  p_cod_program_type = 'dic' then do:
            &if '{&emsbas_version}' > '1.00' &then
            assign v_cod_event_dic = ENTRY(1,p_cod_program ,'/':U)
                   v_cod_tabela    = ENTRY(2,p_cod_program ,'/':U). /* FO 1100.980 */
            find tab_dic_dtsul 
                where tab_dic_dtsul.cod_tab_dic_dtsul = v_cod_tabela 
                no-lock no-error.
            if  avail tab_dic_dtsul
            then do:
                &if '{&emsbas_version}' > '5.00' &then
                    if  tab_dic_dtsul.nom_prog_dpc_gat_delete <> '' and v_cod_event_dic = 'Delete':U then
                        put stream s-arq 'DPC-DELETE : ' at 5 tab_dic_dtsul.nom_prog_dpc_gat_delete  at 25 skip.
                &endif
                if  tab_dic_dtsul.nom_prog_appc_gat_delete <> '' and v_cod_event_dic = 'Delete':U then
                    put stream s-arq 'APPC-DELETE: ' at 5 tab_dic_dtsul.nom_prog_appc_gat_delete at 25 skip.
                if  tab_dic_dtsul.nom_prog_upc_gat_delete <> '' and v_cod_event_dic = 'Delete':U then
                    put stream s-arq 'UPC-DELETE : ' at 5 tab_dic_dtsul.nom_prog_upc_gat_delete  at 25 skip.
                &if '{&emsbas_version}' > '5.00' &then
                    if  tab_dic_dtsul.nom_prog_dpc_gat_write <> '' and v_cod_event_dic = 'Write':U then
                        put stream s-arq 'DPC-WRITE : ' at 5 tab_dic_dtsul.nom_prog_dpc_gat_write  at 25 skip.
                &endif
                if  tab_dic_dtsul.nom_prog_appc_gat_write <> '' and v_cod_event_dic = 'Write':U then
                    put stream s-arq 'APPC-WRITE: ' at 5 tab_dic_dtsul.nom_prog_appc_gat_write at 25 skip.
                if  tab_dic_dtsul.nom_prog_upc_gat_write <> '' and v_cod_event_dic = 'Write':U  then
                    put stream s-arq 'UPC-WRITE : ' at 5 tab_dic_dtsul.nom_prog_upc_gat_write  at 25 skip.
            end /* if */.
            &endif
        end.

        output stream s-arq close.
    end /* if */.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

