&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*****************************************************************************
**     Programa.........: esp/esapb022
**     Descricao .......: Relat¢rio Courrier
**     Versao...........: 1.00.000
**     Autor............: Fabiano Zarpe Henke
**     Criado...........: 09/03/2010
*******************************************************************************/

CREATE WIDGET-POOL.

DEF VAR c-ant                 AS CHAR.
DEF VAR v_num_ped_exec_rpw    AS INTE.
DEF VAR v_log_det             AS logi INIT NO.
DEF VAR v_cod_exessao         AS CHAR.
DEF VAR c-impressora          AS CHAR.
DEF VAR c-layout              AS CHAR.
DEF VAR wh-exessao            as HANDLE.

def new global shared var v_log_gerac_planilha
    as logical
    format "Sim/N∆o"
    initial no
    view-as toggle-box
    label "Gera Planilha"
    no-undo.
def new shared var v_cod_arq_modul
    as character
    format "x(8)":U
    no-undo.
def new shared var v_cod_arq_planilha
    as character
    format "x(40)":U
    label "Arq Planilha"
    column-label "Arq Planilha"
    no-undo.
def new shared var v_cod_carac_lim
    as character
    format "x(1)":U
    initial ";"
    label "Caracter Delimitador"
    no-undo.
def new shared var v_ind_run_mode
    as character
    format "X(08)":U
    initial "On-Line" /*l_online*/
    no-undo.


 /* Vari†veis utilizadas na integraá∆o com o EMS5 */
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
def new global shared var v_cod_estab_usuar
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estab"
    no-undo.
def new global shared var v_cod_grp_usuar_lst
    as character
    format "x(3)":U
    label "Grupo Usu†rios"
    column-label "Grupo"
    no-undo.
def new global shared var v_cod_idiom_usuar
    as character
    format "x(8)":U
    label "Idioma"
    column-label "Idioma"
    no-undo.
def new global shared var v_cod_pais_empres_usuar
    as character
    format "x(3)":U
    label "Pa°s Empresa Usu†rio"
    column-label "Pa°s"
    no-undo.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.
def new global shared var v_cod_usuar_corren_criptog
    as character
    format "x(16)":U
    no-undo.

def new global shared var v5_cod_empres_usuar
    as character
    format 'x(3)'
    label 'Empresa'
    column-label 'Empresa'
    no-undo.
def new global shared var v5_cod_estab_usuar
    as character
    format 'x(3)'
    label 'Estabelecimento'
    column-label 'Estab'
    no-undo.
def new global shared var v5_cod_grp_usuar_lst 
    as character 
    label 'Grupo Usu†rios' 
    column-label 'Grupo' 
    no-undo.
def new global shared var v5_cod_idiom_usuar
    as character
    format 'x(8)'
    label 'Idioma'
    column-label 'Idioma'
    no-undo.
def new global shared var v5_cod_pais_empres_usuar
    as character
    format 'x(3)'
    label 'Pa°s Empresa Usu†rio'
    column-label 'Pa°s'
    no-undo.
def new global shared var v5_cod_usuar_corren
    as character
    format 'x(12)'
    label 'Usu†rio Corrente'
    column-label 'Usu†rio Corrente'
    no-undo.
def new global shared var v5_cod_usuar_corren_criptog
    as character
    format 'x(16)'
    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-relat

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi-cdn-fornec-ini fi-cdn-fornec-fin ~
fi-cod-grp-ini fi-cod-grp-fin fi-dat-ini fi-dat-fin bt_planilha_excel rs-destino bt-cfimp ~
bt-arquivo c-arquivo rs-execucao bt-imprime bt-salva IMAGE-1 IMAGE-2 ~
IMAGE-3 IMAGE-4 IMAGE-5 IMAGE-6 RECT-2 RECT-29 RECT-7 RECT-8 
&Scoped-Define DISPLAYED-OBJECTS fi-cdn-fornec-ini fi-cdn-fornec-fin ~
fi-cod-grp-ini fi-cod-grp-fin fi-dat-ini fi-dat-fin rs-destino c-arquivo ~
rs-execucao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-arquivo 
     IMAGE-UP FILE "image/im-sea1.bmp":U
     LABEL "" 
     SIZE 3.86 BY 1.08 TOOLTIP "Localiza Arquivo".

DEFINE BUTTON bt-cfimp 
     IMAGE-UP FILE "image/im-pri.bmp":U
     LABEL "" 
     SIZE 3.86 BY 1.08 TOOLTIP "Layout Impress∆o".

DEFINE BUTTON bt-imprime 
     LABEL "Imprimir" 
     SIZE 11.14 BY 1 TOOLTIP "Imprimir"
     FONT 1.

DEFINE BUTTON bt-salva 
     LABEL "Fechar" 
     SIZE 11.14 BY 1 TOOLTIP "Fechar/Salvar"
     FONT 1.

DEF BUTTON bt_planilha_excel
    LABEL "Planilha"
    TOOLTIP "Planilha do Excel"
    IMAGE FILE "image/im-exel.bmp"
    SIZE 4 BY 1.3.

DEFINE VARIABLE c-arquivo AS CHARACTER FORMAT "X(40)":U INITIAL "esapb022.lst" 
     VIEW-AS FILL-IN 
     SIZE 44.29 BY .88 TOOLTIP "Destino"
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE v_dat_rec_ini    LIKE fedex.dt-rec        NO-UNDO.
DEFINE VARIABLE v_dat_rec_fim    LIKE fedex.dt-rec        NO-UNDO.
DEFINE VARIABLE v_dat_ini        LIKE fedex.data-sol      NO-UNDO.
DEFINE VARIABLE v_dat_fim        LIKE fedex.data-sol      NO-UNDO.
DEFINE VARIABLE v_cod_msg_ini    LIKE fedex.cod-mensagem  NO-UNDO.
DEFINE VARIABLE v_cod_msg_fim    LIKE fedex.cod-mensagem  NO-UNDO.
DEFINE VARIABLE v_cod_usuar_ini  LIKE fedex.cod_usuario   NO-UNDO.
DEFINE VARIABLE v_cod_usuar_fim  LIKE fedex.cod_usuario   NO-UNDO.
DEFINE VARIABLE v_cod_conhec_ini LIKE fedex.conhecimento  NO-UNDO.
DEFINE VARIABLE v_cod_conhec_fim LIKE fedex.conhecimento  NO-UNDO.
DEFINE VARIABLE v_cod_transp_ini LIKE fedex.cod-transp    NO-UNDO.
DEFINE VARIABLE v_cod_transp_fim LIKE fedex.cod-transp    NO-UNDO.
DEFINE VARIABLE v_cod_emp_ini    LIKE fedex.empresa       NO-UNDO.
DEFINE VARIABLE v_cod_emp_fim    LIKE fedex.empresa       NO-UNDO.
DEFINE VARIABLE v_cod_estab_ini  LIKE fedex.cod_estab     NO-UNDO.
DEFINE VARIABLE v_cod_estab_fim  LIKE fedex.cod_estab     NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-3
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-4
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-5
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-6
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-7
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-8
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-9
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-10
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-11
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-12
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-13
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-14
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-15
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-16
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.


DEFINE VARIABLE rs-destino AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 43.57 BY .83 TOOLTIP "Destino da Impress∆o"
     FONT 1 NO-UNDO.

DEFINE VARIABLE rs-execucao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "On Line", 1,
"Batch", 2
     SIZE 8.86 BY 1.83 TOOLTIP "Execuá∆o On Line ou Batch"
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 83 BY 1.54
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 12 BY 3.17.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 71 BY 3.17.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83 BY 10.25.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 10 BY 2.5.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-relat
     v_dat_ini         AT ROW 2.25 COL 13.14 COLON-ALIGNED LABEL "Data Courrier"  VIEW-AS FILL-IN SIZE-CHARS 11.14 BY .88 FGCOLOR ? BGCOLOR 15 FONT 2
     v_dat_fim         AT ROW 2.25 COL 32    COLON-ALIGNED NO-LABEL               VIEW-AS FILL-IN SIZE-CHARS 11.14 BY .88 FGCOLOR ? BGCOLOR 15 FONT 2
     v_dat_rec_ini     AT ROW 3.25 COL 13.14 COLON-ALIGNED LABEL "Data Rec"       VIEW-AS FILL-IN SIZE-CHARS 11.14 BY .88 FGCOLOR ? BGCOLOR 15 FONT 2
     v_dat_rec_fim     AT ROW 3.25 COL 32    COLON-ALIGNED NO-LABEL               VIEW-AS FILL-IN SIZE-CHARS 11.14 BY .88 FGCOLOR ? BGCOLOR 15 FONT 2
     v_cod_msg_ini     AT ROW 4.25 COL 13.14 COLON-ALIGNED LABEL "Motivo"         VIEW-AS FILL-IN SIZE-CHARS  4.14 BY .88 FGCOLOR ? BGCOLOR 15 FONT 2
     v_cod_msg_fim     AT ROW 4.25 COL 32    COLON-ALIGNED NO-LABEL               VIEW-AS FILL-IN SIZE-CHARS  4.14 BY .88 FGCOLOR ? BGCOLOR 15 FONT 2
     v_cod_usuar_ini   AT ROW 5.25 COL 13.14 COLON-ALIGNED LABEL "Usu†rio"        VIEW-AS FILL-IN SIZE-CHARS  7.14 BY .88 FGCOLOR ? BGCOLOR 15 FONT 2
     v_cod_usuar_fim   AT ROW 5.25 COL 32    COLON-ALIGNED NO-LABEL               VIEW-AS FILL-IN SIZE-CHARS  7.14 BY .88 FGCOLOR ? BGCOLOR 15 FONT 2
     v_cod_transp_ini  AT ROW 6.25 COL 13.14 COLON-ALIGNED LABEL "Transportadora" VIEW-AS FILL-IN SIZE-CHARS  7.14 BY .88 FGCOLOR ? BGCOLOR 15 FONT 2
     v_cod_transp_fim  AT ROW 6.25 COL 32    COLON-ALIGNED NO-LABEL               VIEW-AS FILL-IN SIZE-CHARS  7.14 BY .88 FGCOLOR ? BGCOLOR 15 FONT 2
     v_cod_conhec_ini  AT ROW 7.75 COL 13.14 COLON-ALIGNED LABEL "Conhecimento"   VIEW-AS FILL-IN SIZE-CHARS  31.14 BY .88 FGCOLOR ? BGCOLOR 15 FONT 2
     v_cod_conhec_fim  AT ROW 7.75 COL 50.14 COLON-ALIGNED NO-LABEL               VIEW-AS FILL-IN SIZE-CHARS  31.14 BY .88 FGCOLOR ? BGCOLOR 15 FONT 2
     v_cod_emp_ini     AT ROW 8.75 COL 13.14 COLON-ALIGNED LABEL "Empresa"        VIEW-AS FILL-IN SIZE-CHARS  31.14 BY .88 FGCOLOR ? BGCOLOR 15 FONT 2
     v_cod_emp_fim     AT ROW 8.75 COL 50.14 COLON-ALIGNED NO-LABEL               VIEW-AS FILL-IN SIZE-CHARS  31.14 BY .88 FGCOLOR ? BGCOLOR 15 FONT 2
     v_cod_estab_ini   AT ROW 9.85 COL 13.14 COLON-ALIGNED LABEL "Establecimento" VIEW-AS FILL-IN SIZE-CHARS  31.14 BY .88 FGCOLOR ? BGCOLOR 15 FONT 2
     v_cod_estab_fim   AT ROW 9.85 COL 50.14 COLON-ALIGNED NO-LABEL               VIEW-AS FILL-IN SIZE-CHARS  31.14 BY .88 FGCOLOR ? BGCOLOR 15 FONT 2 
     bt_planilha_excel AT ROW 3 COL 70
     rs-destino AT ROW 12.5 COL 2.5 HELP
          "Destino da Impress∆o" NO-LABEL
     bt-cfimp AT ROW 13.5 COL 46.57 HELP
          "Layout Impress∆o"
     bt-arquivo AT ROW 13.5 COL 46.57 HELP
          "Localiza Arquivo"
     c-arquivo AT ROW 13.58 COL 2.14 HELP
          "Destino" NO-LABEL
     rs-execucao AT ROW 12.5 COL 74.14 HELP
          "Execuá∆o On Line ou Batch" NO-LABEL
     bt-imprime AT ROW 15.46 COL 2.29
     bt-salva AT ROW 15.46 COL 14
     " Excel" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 2 COL 69
          FONT 6
     RECT-10  AT ROW 2.3   COL 67
     IMAGE-1  AT ROW 2.3   COL 27
     IMAGE-2  AT ROW 2.3   COL 30.4
     IMAGE-3  AT ROW 3.3   COL 27
     IMAGE-4  AT ROW 3.3   COL 30.4
     IMAGE-5  AT ROW 4.3   COL 27
     IMAGE-6  AT ROW 4.3   COL 30.4
     IMAGE-7  AT ROW 5.3   COL 27
     IMAGE-8  AT ROW 5.3   COL 30.4
     IMAGE-15 AT ROW 6.3   COL 27
     IMAGE-16 AT ROW 6.3   COL 30.4
     IMAGE-9  AT ROW 7.8   COL 46.29
     IMAGE-10 AT ROW 7.8   COL 49
     IMAGE-11 AT ROW 8.8   COL 46.29
     IMAGE-12 AT ROW 8.8   COL 49
     IMAGE-13 AT ROW 9.8   COL 46.29
     IMAGE-14 AT ROW 9.8   COL 49
     RECT-2   AT ROW 15.17 COL 1.29
     RECT-29  AT ROW 11.79 COL 72.5
     RECT-7   AT ROW 11.79 COL 1.5
     RECT-8   AT ROW 1.25  COL 1.5
     "  Impress∆o" VIEW-AS TEXT
          SIZE 10.57 BY .54 AT ROW 11.63 COL 2.86
          FONT 6
     " Execuá∆o" VIEW-AS TEXT
          SIZE 9.43 BY .54 AT ROW 11.58 COL 72.86
          FONT 6
     " Seleá∆o" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 1 COL 3.43
          FONT 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 83.5 BY 17
         FONT 1
         DEFAULT-BUTTON bt-imprime.


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
         TITLE              = "Relat¢rio Courrier - ESAPB022"
         COLUMN             = 14.29
         ROW                = 6.54
         HEIGHT             = 16
         WIDTH              = 84.00
         MAX-HEIGHT         = 33.04
         MAX-WIDTH          = 164.57
         VIRTUAL-HEIGHT     = 33.04
         VIRTUAL-WIDTH      = 164.57
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         FONT               = 1
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-relat
   Custom                                                               */
/* SETTINGS FOR FILL-IN c-arquivo IN FRAME f-relat
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-cdn-fornec-fin IN FRAME f-relat
   LIKE = tit_ap.cdn_fornecedor EXP-SIZE                           */
/* SETTINGS FOR FILL-IN fi-cdn-fornec-ini IN FRAME f-relat
   LIKE = tit_ap.cdn_fornecedor EXP-SIZE                           */
/* SETTINGS FOR FILL-IN fi-cod-grp-fin IN FRAME f-relat
   LIKE = tit_ap.cod_grp_fornec EXP-SIZE                           */
/* SETTINGS FOR FILL-IN fi-cod-grp-ini IN FRAME f-relat
   LIKE = tit_ap.cod_grp_fornec EXP-SIZE                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-relat
/* Query rebuild information for FRAME f-relat
     _Query            is NOT OPENED
*/  /* FRAME f-relat */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

ON CHOOSE OF bt_planilha_excel IN FRAME f-relat
DO:

    assign v_cod_arq_modul = "plan" /*l_plan*/  + "-" + lc("ACR" /*l_acr*/ ) + '.txt'. 

    run esp/acr/esacr028c.p.

END.


&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Relat¢rio Prazo MÇdio Fornecedor - esapb022 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Relat¢rio Prazo MÇdio Fornecedor - esapb022 */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo C-Win
ON CHOOSE OF bt-arquivo IN FRAME f-relat
DO:
    def var c-arq-conv  as char no-undo.
    def var l-ok        as logical init no.

    assign c-arq-conv = replace(input frame f-relat c-arquivo, "/", "\").
    SYSTEM-DIALOG GET-FILE c-arq-conv
       FILTERS "*.lst" "*.lst",
               "*.*" "*.*"
       ASK-OVERWRITE 
       DEFAULT-EXTENSION "lst"
       INITIAL-DIR "spool" 
       SAVE-AS
       USE-FILENAME
       UPDATE l-ok.

    if  l-ok = yes then do:
        assign c-arq-conv = replace(c-arq-conv, "\", "/"). 
        display c-arq-conv @ c-arquivo with frame f-relat.
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cfimp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cfimp C-Win
ON CHOOSE OF bt-cfimp IN FRAME f-relat
DO:
    assign c-ant = c-arquivo:screen-value in frame f-relat.
  
    run prgtec/btb/btb036nb.p (output c-impressora, output c-layout).
    
    if c-arquivo <> ":" then
      assign c-arquivo = c-impressora + ":" + c-layout.
    else
      assign c-arquivo = c-ant.
      
    disp c-arquivo with frame f-relat.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-imprime
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-imprime C-Win
ON CHOOSE OF bt-imprime IN FRAME f-relat /* Imprimir */
DO:
  RUN pi-vld-param.
  IF RETURN-VALUE = "no" 
  THEN RETURN NO-APPLY.
  RUN pi_salva_param.
  IF rs-execucao:SCREEN-VALUE IN FRAME f-relat = "2" THEN
  DO.
    RUN prgtec/btb/btb911za.p (INPUT  "esapb022rp",
                               INPUT  "1.00.000",
                               INPUT  0,
                               INPUT  RECID(dwb_set_list_param),
                               OUTPUT v_num_ped_exec_rpw).

    IF v_num_ped_exec_rpw <> 0 THEN
    DO.
      RUN pi_message  (INPUT "show",
                       INPUT 3556,
                       INPUT SUBSTITUTE("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                             v_num_ped_exec_rpw)).
    END.
  END.
  ELSE 
  DO.
    IF SESSION:SET-WAIT-STATE("general") THEN.
    RUN esp/apb/esapb022rp.p.
    IF SESSION:SET-WAIT-STATE("") THEN.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-salva
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-salva C-Win
ON CHOOSE OF bt-salva IN FRAME f-relat /* Fechar */
DO:
  RUN pi_salva_param.
  APPLY "close" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-destino C-Win
ON VALUE-CHANGED OF rs-destino IN FRAME f-relat
DO:
  if input frame f-relat rs-destino = 1 then do:
      assign bt-arquivo:visible  in frame f-relat = no
             bt-cfimp:visible    in frame f-relat = yes
             c-arquivo:visible   in frame f-relat = yes
             c-arquivo:sensitive in frame f-relat = no.
      if c-impressora = "" then do:
          find first imprsor_usuar no-lock
              where imprsor_usuar.cod_usuario = v_cod_usuar_corren
              use-index imprsrsr_id no-error.
          if avail imprsor_usuar then do:
              find first layout_impres no-lock
                  where layout_impres.nom_impressora  = imprsor_usuar.nom_impressora no-error.
              if avail layout_impres then
                  assign c-arquivo:screen-value in frame f-relat = imprsor_usuar.nom_impressora 
                                                               + ":" 
                                                               + layout_impres.cod_layout_impres
                         c-impressora                          = imprsor_usuar.nom_impressora
                         c-layout                              = layout_impres.cod_layout_impres.
          end.
      end.
      else
          assign c-arquivo:screen-value in frame f-relat = c-impressora + ":" + c-layout.
          
  end.
             
  if input frame f-relat rs-destino = 2 then do:
      assign bt-arquivo:visible  in frame f-relat = yes
             bt-cfimp:visible    in frame f-relat = no
             c-arquivo:visible   in frame f-relat = yes             
             c-arquivo:sensitive in frame f-relat = yes.
      if input frame f-relat rs-execucao = 1 then
          assign c-arquivo:screen-value in frame f-relat = session:temp-directory + "esacr005.lst"
                 c-impressora                          = ""
                 c-layout                              = "".
      else
          assign c-arquivo:screen-value in frame f-relat = "esacr005.lst"
                 c-impressora                          = ""
                 c-layout                              = "".
          
          
  end.

  if input frame f-relat rs-destino = 3 then
      assign bt-arquivo:visible  in frame f-relat = no
             bt-cfimp:visible    in frame f-relat = no
             c-arquivo:visible   in frame f-relat = no.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-execucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-execucao C-Win
ON VALUE-CHANGED OF rs-execucao IN FRAME f-relat
DO:
  if input frame f-relat rs-execucao = 2 then do:
     if rs-destino:disable("Terminal") in frame f-relat then.
  end.
  else do:
      if rs-destino:enable("Terminal") in frame f-relat then.
  end.
  
  apply "value-changed" to rs-destino in frame f-relat.
     
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

  RUN enable_UI.

  APPLY "value-changed" TO rs-destino IN FRAME {&FRAME-NAME}.
  
  run pi-recupera-param.
  
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
  DISPLAY v_dat_ini v_dat_fim v_dat_rec_ini v_dat_rec_fim v_cod_msg_ini v_cod_msg_fim v_cod_usuar_ini v_cod_usuar_fim v_cod_conhec_ini v_cod_conhec_fim 
          v_cod_transp_ini v_cod_transp_fim v_cod_emp_ini v_cod_emp_fim v_cod_estab_ini v_cod_estab_fim
          rs-destino c-arquivo rs-execucao 
      WITH FRAME f-relat IN WINDOW C-Win.
  ENABLE v_dat_ini v_dat_fim v_dat_rec_ini v_dat_rec_fim v_cod_msg_ini v_cod_msg_fim v_cod_usuar_ini v_cod_usuar_fim v_cod_conhec_ini v_cod_conhec_fim 
         v_cod_transp_ini v_cod_transp_fim v_cod_emp_ini v_cod_emp_fim v_cod_estab_ini v_cod_estab_fim
         bt_planilha_excel rs-destino bt-cfimp bt-arquivo c-arquivo 
         rs-execucao bt-imprime bt-salva IMAGE-1 IMAGE-2 IMAGE-3 IMAGE-4 
         IMAGE-5 IMAGE-6 RECT-2 RECT-29 RECT-7 RECT-8 
      WITH FRAME f-relat IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recupera-param C-Win 
PROCEDURE pi-recupera-param :
/* */
  FIND dwb_set_list_param EXCLUSIVE-LOCK
       WHERE dwb_set_list_param.cod_dwb_program = "esapb022rp"
         AND dwb_set_list_param.cod_dwb_user    = v_cod_usuar_corren 
       NO-ERROR.
  
  IF AVAIL dwb_set_list_param THEN 
  DO WITH FRAME f-relat:
    ASSIGN rs-execucao:SCREEN-VALUE      IN FRAME f-relat =  ENTRY( 1,dwb_set_list_param.cod_dwb_parameters,chr(10))
           v_dat_ini:screen-value        in frame f-relat =  ENTRY( 2,dwb_set_list_param.cod_dwb_parameters,chr(10))
           v_dat_fim:screen-value        in frame f-relat =  ENTRY( 3,dwb_set_list_param.cod_dwb_parameters,chr(10))
           v_cod_msg_ini:screen-value    in frame f-relat =  ENTRY( 4,dwb_set_list_param.cod_dwb_parameters,chr(10))
           v_cod_msg_fim:screen-value    in frame f-relat =  ENTRY( 5,dwb_set_list_param.cod_dwb_parameters,chr(10))
           v_cod_usuar_ini:screen-value  in frame f-relat =  ENTRY( 6,dwb_set_list_param.cod_dwb_parameters,chr(10))
           v_cod_usuar_fim:screen-value  in frame f-relat =  ENTRY( 7,dwb_set_list_param.cod_dwb_parameters,chr(10))
           v_cod_conhec_ini:screen-value in frame f-relat =  ENTRY( 8,dwb_set_list_param.cod_dwb_parameters,chr(10)) 
           v_cod_conhec_fim:screen-value in frame f-relat =  ENTRY( 9,dwb_set_list_param.cod_dwb_parameters,chr(10)) 
           v_cod_transp_ini:screen-value in frame f-relat =  ENTRY(10,dwb_set_list_param.cod_dwb_parameters,chr(10))
           v_cod_transp_fim:screen-value in frame f-relat =  ENTRY(11,dwb_set_list_param.cod_dwb_parameters,chr(10))
           v_cod_emp_ini:screen-value    in frame f-relat =  ENTRY(12,dwb_set_list_param.cod_dwb_parameters,chr(10))
           v_cod_emp_fim:screen-value    in frame f-relat =  ENTRY(13,dwb_set_list_param.cod_dwb_parameters,chr(10))
           v_log_gerac_planilha                           = (ENTRY(14,dwb_set_list_param.cod_dwb_parameters,chr(10)) = 'yes')
           v_cod_arq_planilha                             =  ENTRY(15,dwb_set_list_param.cod_dwb_parameters,chr(10))
           v_cod_carac_lim                                =  ENTRY(16,dwb_set_list_param.cod_dwb_parameters,chr(10))
           v_cod_estab_ini:SCREEN-VALUE  IN FRAME f-relat =  ENTRY(17,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           v_cod_estab_fim:SCREEN-VALUE  IN FRAME f-relat =  ENTRY(18,dwb_set_list_param.cod_dwb_parameters,CHR(10))
           v_dat_ini:screen-value        in frame f-relat =  ENTRY(19,dwb_set_list_param.cod_dwb_parameters,chr(10))
           v_dat_fim:screen-value        in frame f-relat =  ENTRY(20,dwb_set_list_param.cod_dwb_parameters,chr(10))
           rs-destino:SCREEN-VALUE        IN FRAME f-relat = IF dwb_set_list_param.cod_dwb_output = "impressora" 
                                                               THEN "1"
                                                               ELSE IF dwb_set_list_param.cod_dwb_output = "arquivo" 
                                                                    THEN "2"
                                                                    ELSE "3" NO-ERROR.
    APPLY "value-changed" TO rs-destino      IN FRAME f-relat.  
  END.   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-vld-param C-Win 
PROCEDURE pi-vld-param :
/* */

IF  input frame f-relat v_dat_ini = ""
OR  input frame f-relat v_dat_ini = ? THEN DO:
    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 17006,
                       INPUT "Data inicial deve ser informada !").
    RETURN ERROR.
END.

IF  input frame f-relat v_dat_fim = ""
OR  input frame f-relat v_dat_fim = ? THEN DO:
    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 17006,
                       INPUT "Data final deve ser informada !").
    RETURN ERROR.
END.

IF  input frame f-relat v_dat_rec_ini = ""
OR  input frame f-relat v_dat_rec_ini = ? THEN DO:
    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 17006,
                       INPUT "Data recebimento inicial deve ser informada !").
    RETURN ERROR.
END.

IF  input frame f-relat v_dat_rec_fim = ""
OR  input frame f-relat v_dat_rec_fim = ? THEN DO:
    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 17006,
                       INPUT "Data recebimento final deve ser informada !").
    RETURN ERROR.
END.

if input frame f-relat rs-destino = 2 then 
do:

  for each ped_exec no-lock
      where ped_exec.cod_prog_dtsul = "esapb022rp"
        and ped_exec.ind_sit_ped    = "N∆o executado" :
          
    find ped_exec_param  of ped_exec no-lock no-error.
    if avail ped_exec_param then 
    do:
      if ped_exec_param.cod_dwb_file = input frame f-relat c-arquivo then 
      do:
        run utp/message2.p (input "Nome do Arquivo encontrado em outro pedido,Deseja continuar ? ",
                            input  "Foi encontrado um pedido com o mesmo nome a ser criado."      + chr(10) +
                                   "Arquivo....: " + ped_exec_param.cod_dwb_file + chr(10) +
                                   "Usuario....: " + ped_exec.cod_usuar   + chr(10) +
                                   "Num Pedido.: " + string(ped_exec_param.num_ped_exec)).
        leave.
      end.  
    end.
  end.    
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-vld-usuario C-Win 
PROCEDURE pi-vld-usuario :
/* */
FIND prog_dtsul NO-LOCK
    WHERE prog_dtsul.cod_prog_dtsul = "esapb022" NO-ERROR.

IF AVAIL prog_dtsul THEN 
DO:
  FOR EACH usuar_grp_usuar NO-LOCK
      WHERE usuar_grp_usuar.cod_usuar = v_cod_usuar_corren:
    IF NOT CAN-FIND(FIRST prog_dtsul_segur NO-LOCK
                    WHERE  prog_dtsul_segur.cod_prog_dtsul = "esapb022"
                      AND (prog_dtsul_segur.cod_grp_usuar  = usuar_grp_usuar.cod_grp_usuar
                       OR  prog_dtsul_segur.cod_grp_usuar  = "*")) THEN 
    DO:
      MESSAGE "Usu†rio n∆o tem Permiss∆o" SKIP
              "Verifique com o Administrador as permiss‰es para acessar este programa!" VIEW-AS ALERT-BOX ERROR.
      RETURN 'nok'.
    END.
  END.
END.
ELSE 
DO:
  MESSAGE "Programa n∆o Cadastrado no Menu!" VIEW-AS ALERT-BOX ERROR.
  RETURN 'nok'.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_message C-Win 
PROCEDURE pi_message :
/* */
def input param c_action    as char    no-undo.
def input param i_msg       as integer no-undo.
def input param c_param     as char    no-undo.

def var c_prg_msg           as char    no-undo.

assign c_prg_msg = "messages/"
                 + string(trunc(i_msg / 1000,0),"99")
                 + "/msg"
                 + string(i_msg, "99999").

if search(c_prg_msg + ".r") = ? and search(c_prg_msg + ".p") = ? then 
do:
  message "Mensagem nr. " i_msg "!!!" skip
          "Programa Mensagem" c_prg_msg "n∆o encontrado."
          view-as alert-box error.
  return error.
end.
run value(c_prg_msg + ".p") (input c_action, input c_param).
return return-value.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_salva_param C-Win 
PROCEDURE pi_salva_param :
/* */
  ASSIGN INPUT FRAME f-relat c-arquivo
                             rs-destino
                             rs-execucao
                             v_dat_ini             
                             v_dat_fim
                             v_dat_rec_ini
                             v_dat_rec_fim
                             v_cod_msg_ini         
                             v_cod_msg_fim         
                             v_cod_usuar_ini       
                             v_cod_usuar_fim       
                             v_cod_conhec_ini      
                             v_cod_conhec_fim      
                             v_cod_transp_ini      
                             v_cod_transp_fim      
                             v_cod_emp_ini         
                             v_cod_emp_fim
                             v_cod_estab_ini
                             v_cod_estab_fim.

  RUN prgtec/btb/btb906za.p.    
  IF rs-destino  = 2 AND 
     rs-execucao = 2 THEN
  DO.
    DO WHILE INDEX(c-arquivo,"~/") <> 0.
      ASSIGN c-arquivo = SUBSTR(c-arquivo,(INDEX(c-arquivo,"~/" ) + 1)).
    END.

    DO WHILE INDEX(v_cod_arq_planilha,"~/") <> 0.
        ASSIGN v_cod_arq_planilha = SUBSTR(v_cod_arq_planilha,(INDEX(v_cod_arq_planilha,"~/" ) + 1)).
    END.

    FIND usuar_mestre NO-LOCK 
       WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren USE-INDEX srmstr_id NO-ERROR.
    IF usuar_mestre.nom_subdir_spool <> ""
       THEN ASSIGN c-arquivo          = usuar_mestre.nom_subdir_spool + "~/" + c-arquivo
                   v_cod_arq_planilha = usuar_mestre.nom_subdir_spool + "~/" + v_cod_arq_planilha.
  
  END.

        /* Recuperar parÉmetros da £ltima execuá∆o */
  FIND dwb_set_list_param EXCLUSIVE-LOCK
       WHERE dwb_set_list_param.Cod_dwb_program = "esapb022rp"
         AND dwb_set_list_param.Cod_dwb_user    = v_Cod_usuar_corren 
       NO-ERROR.
    
  IF NOT AVAIL dwb_set_list_param 
  THEN CREATE dwb_set_list_param.
    
  ASSIGN dwb_set_list_param.Cod_dwb_program          = "esapb022rp"
         dwb_set_list_param.Cod_dwb_user             = v_Cod_usuar_corren
         dwb_set_list_param.Cod_dwb_file             = INPUT FRAME f-relat c-arquivo
         dwb_set_list_param.nom_dwb_printer          = c-impressora
         dwb_set_list_param.Cod_dwb_print_layout     = c-layout
         dwb_set_list_param.qtd_dwb_line             = 60
         dwb_set_list_param.Cod_dwb_parameters       = STRING(rs-execucao)          + chr(10) + 
                                                              string(v_dat_ini)            + chr(10) +
                                                              string(v_dat_fim)            + chr(10) +
                                                              string(v_cod_msg_ini)        + chr(10) +
                                                              string(v_cod_msg_fim)        + chr(10) +
                                                              string(v_cod_usuar_ini)      + chr(10) +
                                                              string(v_cod_usuar_fim)      + chr(10) +
                                                              string(v_cod_conhec_ini)     + chr(10) +
                                                              string(v_cod_conhec_fim)     + chr(10) +
                                                              string(v_cod_transp_ini)     + chr(10) +
                                                              string(v_cod_transp_fim)     + chr(10) +
                                                              string(v_cod_emp_ini)        + chr(10) +
                                                              string(v_cod_emp_fim)        + chr(10) +
                                                              STRING(v_log_gerac_planilha) + chr(10) +
                                                              STRING(v_cod_arq_planilha)   + chr(10) +
                                                              STRING(v_cod_carac_lim)      + CHR(10) + 
                                                              STRING(v_cod_estab_ini)      + CHR(10) +
                                                              STRING(v_cod_estab_fim)      + CHR(10) +
                                                              string(v_dat_rec_ini)        + chr(10) +
                                                              string(v_dat_rec_fim)
         dwb_set_list_param.Cod_dwb_output           = IF rs-destino = 1 
                                                              THEN "Impressora"
                                                              ELSE IF rs-destino = 2 
                                                                   THEN "Arquivo"
                                                                   ELSE IF rs-destino = 3 
                                                                        THEN "Terminal"
                                                                        ELSE "arquivo".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

