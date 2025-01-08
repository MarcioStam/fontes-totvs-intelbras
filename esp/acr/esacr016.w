&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*****************************************************************************
**     Programa.........: esp/esacr005
**     Descricao .......: Relat¢rio de T¡tulos em Aberto Pelo Portador
**     Versao...........: 1.00.000
**     Autor............: Joel Ricardo Geisler
**     Criado...........: 31/12/2004
**     Atualiza‡Æo......: 18/05/2010 
**     Autor............: Gustavo Eduardo Tamanini - SQL WORKS
*******************************************************************************/

CREATE WIDGET-POOL.

DEF VAR c-ant                 AS CHAR.
DEF VAR v_num_ped_exec_rpw    AS INTE.
DEF VAR v_log_det             AS logi INIT NO.
DEF VAR v_cod_exessao         AS CHAR.
DEF VAR c-impressora          AS CHAR.
DEF VAR c-layout              AS CHAR.
DEF VAR wh-exessao            AS HANDLE.
DEF VAR h-acomp               AS HANDLE  NO-UNDO.    
DEF VAR l-ok                  AS LOGICAL NO-UNDO.

DEFINE TEMP-TABLE tt_tit_acr NO-UNDO LIKE tit_acr
    FIELD l-marcado AS LOGICAL FORMAT "*/ "
    INDEX id IS PRIMARY cod_estab cod_espec_docto cod_ser_docto cod_tit_acr cod_parcela.

DEFINE TEMP-TABLE tt_cliente                    
    FIELD cdn_cliente      LIKE tit_acr.cdn_cliente 
    INDEX tt_cliente IS PRIMARY cdn_cliente.

DEF BUFFER b_pessoa_jurid FOR pessoa_jurid.
DEF BUFFER b_cliente      FOR emscad.cliente.

 /* Vari veis utilizadas na integra‡Æo com o EMS5 */
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
    label "Grupo Usu rios"
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
    label "Pa¡s Empresa Usu rio"
    column-label "Pa¡s"
    no-undo.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu rio Corrente"
    column-label "Usu rio Corrente"
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
    label 'Grupo Usu rios' 
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
    label 'Pa¡s Empresa Usu rio'
    column-label 'Pa¡s'
    no-undo.
def new global shared var v5_cod_usuar_corren
    as character
    format 'x(12)'
    label 'Usu rio Corrente'
    column-label 'Usu rio Corrente'
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

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-relat

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c_cod_estab_ini c_cod_estab_fim ~
c_cod_espec_docto_ini c_cod_espec_docto_fim c_cod_ser_docto_ini ~
c_cod_ser_docto_fim c_cod_tit_acr_ini c_cod_tit_acr_fim c_cod_parcela_ini ~
c_cod_parcela_fim i_cdn_cliente_ini i_cdn_cliente_fim l_log_matriz ~
dt_vencto_ini dt_vencto_fim i-corresp i-chefe l-protesto l-especie ~
rs-destino bt-cfimp c-arquivo bt-arquivo rs-execucao bt-imprime bt-salva ~
RECT-2 RECT-29 RECT-7 RECT-8 RECT-9 
&Scoped-Define DISPLAYED-OBJECTS c_cod_estab_ini c_cod_estab_fim ~
c_cod_espec_docto_ini c_cod_espec_docto_fim c_cod_ser_docto_ini ~
c_cod_ser_docto_fim c_cod_tit_acr_ini c_cod_tit_acr_fim c_cod_parcela_ini ~
c_cod_parcela_fim i_cdn_cliente_ini i_cdn_cliente_fim l_log_matriz ~
dt_vencto_ini dt_vencto_fim i-corresp i-chefe l-protesto l-especie ~
rs-destino c-arquivo rs-execucao 

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
     SIZE 3.86 BY 1.08 TOOLTIP "Layout ImpressÆo".

DEFINE BUTTON bt-imprime 
     LABEL "Imprimir" 
     SIZE 11.14 BY 1 TOOLTIP "Imprimir"
     FONT 1.

DEFINE BUTTON bt-salva 
     LABEL "Fechar" 
     SIZE 11.14 BY 1 TOOLTIP "Fechar/Salvar"
     FONT 1.

DEFINE VARIABLE c-arquivo AS CHARACTER FORMAT "X(40)":U INITIAL "esacr016.lst" 
     VIEW-AS FILL-IN 
     SIZE 44.29 BY .88 TOOLTIP "Destino"
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE c_cod_espec_docto_fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 4.14 BY .88
     FONT 2 NO-UNDO.

DEFINE VARIABLE c_cod_espec_docto_ini AS CHARACTER FORMAT "x(3)" 
     LABEL "Esp‚cie Documento" 
     VIEW-AS FILL-IN 
     SIZE 4.14 BY .88
     FONT 2.

DEFINE VARIABLE c_cod_estab_fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 4.14 BY .88
     FONT 2 NO-UNDO.

DEFINE VARIABLE c_cod_estab_ini AS CHARACTER FORMAT "x(3)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 4.14 BY .88
     FONT 2.

DEFINE VARIABLE c_cod_parcela_fim AS CHARACTER FORMAT "X(2)":U INITIAL "ZZ" 
     VIEW-AS FILL-IN 
     SIZE 3.14 BY .88
     FONT 2 NO-UNDO.

DEFINE VARIABLE c_cod_parcela_ini AS CHARACTER FORMAT "x(02)" 
     LABEL "Parcela" 
     VIEW-AS FILL-IN 
     SIZE 3.14 BY .88
     FONT 2.

DEFINE VARIABLE c_cod_ser_docto_fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 4.14 BY .88
     FONT 2 NO-UNDO.

DEFINE VARIABLE c_cod_ser_docto_ini AS CHARACTER FORMAT "x(3)" 
     LABEL "S‚rie Documento" 
     VIEW-AS FILL-IN 
     SIZE 4.14 BY .88
     FONT 2.

DEFINE VARIABLE c_cod_tit_acr_fim AS CHARACTER FORMAT "X(10)":U INITIAL "ZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 11.14 BY .88
     FONT 2 NO-UNDO.

DEFINE VARIABLE c_cod_tit_acr_ini AS CHARACTER FORMAT "x(10)" 
     LABEL "T¡tulo" 
     VIEW-AS FILL-IN 
     SIZE 11.14 BY .88
     FONT 2.

DEFINE VARIABLE dt_vencto_fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88
     FONT 2 NO-UNDO.

DEFINE VARIABLE dt_vencto_ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/1900 
     LABEL "Data Vencimento" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88
     FONT 2 NO-UNDO.

DEFINE VARIABLE i_cdn_cliente_fim AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88
     FONT 2 NO-UNDO.

DEFINE VARIABLE i_cdn_cliente_ini AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88
     FONT 2 NO-UNDO.

DEFINE VARIABLE i-chefe AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Fernando", 1,
"Jair", 2
     SIZE 19 BY .75
     FONT 1 NO-UNDO.

DEFINE VARIABLE i-corresp AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Sedex", 1,
"Normal", 2
     SIZE 23 BY .75
     FONT 1 NO-UNDO.

DEFINE VARIABLE rs-destino AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 43.57 BY .83 TOOLTIP "Destino da ImpressÆo"
     FONT 1 NO-UNDO.

DEFINE VARIABLE rs-execucao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On Line", 1,
"Batch", 2
     SIZE 19 BY .92 TOOLTIP "Execu‡Æo On Line ou Batch"
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 91 BY 1.54
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 37.43 BY 2.83.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 52.29 BY 2.83.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 52.29 BY 7.58.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 37.43 BY 7.58.

DEFINE VARIABLE l-especie AS LOGICAL INITIAL no 
     LABEL "Imprime Esp‚cie" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .83
     FONT 1 NO-UNDO.

DEFINE VARIABLE l-protesto AS LOGICAL INITIAL no 
     LABEL "Protesto" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83
     FONT 1 NO-UNDO.

DEFINE VARIABLE l_log_matriz AS LOGICAL INITIAL no 
     LABEL "Matriz" 
     VIEW-AS TOGGLE-BOX
     SIZE 7.57 BY .88
     FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-relat
     c_cod_estab_ini AT ROW 1.75 COL 14.86 COLON-ALIGNED HELP
          "C¢digo Estabelecimento Inicial" WIDGET-ID 2
     c_cod_estab_fim AT ROW 1.75 COL 30.14 COLON-ALIGNED HELP
          "C¢digo Estabelecimento Final" NO-LABEL
     c_cod_espec_docto_ini AT ROW 2.75 COL 14.86 COLON-ALIGNED HELP
          "C¢digo Esp‚cie Documento Inicial"
     c_cod_espec_docto_fim AT ROW 2.75 COL 30.14 COLON-ALIGNED HELP
          "C¢digo Esp‚cie Documento Final" NO-LABEL
     c_cod_ser_docto_ini AT ROW 3.75 COL 14.86 COLON-ALIGNED HELP
          "C¢digo S‚rie Documento Inicial"
     c_cod_ser_docto_fim AT ROW 3.75 COL 30.14 COLON-ALIGNED HELP
          "C¢digo S‚rie Documento Final" NO-LABEL
     c_cod_tit_acr_ini AT ROW 4.75 COL 14.86 COLON-ALIGNED HELP
          "C¢digo T¡tulo Contas a Receber Inicial"
     c_cod_tit_acr_fim AT ROW 4.75 COL 30.14 COLON-ALIGNED HELP
          "C¢digo T¡tulo Contas a Receber Final" NO-LABEL
     c_cod_parcela_ini AT ROW 5.75 COL 14.86 COLON-ALIGNED HELP
          "Parcela Inicial"
     c_cod_parcela_fim AT ROW 5.75 COL 30.14 COLON-ALIGNED HELP
          "Parcela Final" NO-LABEL
     i_cdn_cliente_ini AT ROW 6.75 COL 14.86 COLON-ALIGNED HELP
          "C¢digo Cliente Inicial"
     i_cdn_cliente_fim AT ROW 6.75 COL 30.14 COLON-ALIGNED HELP
          "C¢digo Cliente Final" NO-LABEL
     l_log_matriz AT ROW 6.75 COL 44.72
     dt_vencto_ini AT ROW 7.75 COL 15 COLON-ALIGNED HELP
          "Data Vencimento Inicial"
     dt_vencto_fim AT ROW 7.75 COL 30.29 COLON-ALIGNED HELP
          "Data Vencimento Final" NO-LABEL
     i-corresp AT ROW 2.25 COL 68 NO-LABEL
     i-chefe AT ROW 3.21 COL 68 NO-LABEL
     l-protesto AT ROW 4.75 COL 67
     l-especie AT ROW 5.75 COL 67 HELP
          "A esp‚cie ser  impressa antes do n£mero do titulo"
     rs-destino AT ROW 9.96 COL 5.43 HELP
          "Destino da ImpressÆo" NO-LABEL
     bt-cfimp AT ROW 9.96 COL 49.43 HELP
          "Layout ImpressÆo"
     c-arquivo AT ROW 10.96 COL 4.86 HELP
          "Destino" NO-LABEL
     bt-arquivo AT ROW 10.96 COL 49.43 HELP
          "Localiza Arquivo"
     rs-execucao AT ROW 10.29 COL 56.14 HELP
          "Execu‡Æo On Line ou Batch" NO-LABEL
     bt-imprime AT ROW 12.88 COL 2.29
     bt-salva AT ROW 12.88 COL 14
     "ImpressÆo" VIEW-AS TEXT
          SIZE 10.57 BY .54 AT ROW 9.04 COL 3.43
          FONT 6
     "At‚" VIEW-AS TEXT
          SIZE 2.29 BY .79 AT ROW 6.75 COL 29.14 WIDGET-ID 14
     "Respons vel:" VIEW-AS TEXT
          SIZE 10.29 BY .54 AT ROW 3.25 COL 57.29
          FONT 1
     "Correspondˆncia:" VIEW-AS TEXT
          SIZE 12.29 BY .54 AT ROW 2.29 COL 54.72
          FONT 1
     "At‚" VIEW-AS TEXT
          SIZE 3 BY .54 AT ROW 7.88 COL 29.14
     "Parƒmetros" VIEW-AS TEXT
          SIZE 10.86 BY .54 AT ROW 1.21 COL 55.72
          FONT 6
     "Sele‡Æo" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 1.17 COL 3.14
          FONT 6
     "Execu‡Æo" VIEW-AS TEXT
          SIZE 9.43 BY .54 AT ROW 9.04 COL 55.57
          FONT 6
     "At‚" VIEW-AS TEXT
          SIZE 2.29 BY .79 AT ROW 1.75 COL 29.14 WIDGET-ID 4
     "At‚" VIEW-AS TEXT
          SIZE 2.29 BY .79 AT ROW 2.75 COL 29.14 WIDGET-ID 6
     "At‚" VIEW-AS TEXT
          SIZE 2.29 BY .79 AT ROW 3.75 COL 29.14 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 91.29 BY 13.17
         FONT 1
         DEFAULT-BUTTON bt-imprime.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME f-relat
     "At‚" VIEW-AS TEXT
          SIZE 2.29 BY .79 AT ROW 4.75 COL 29.14 WIDGET-ID 10
     "At‚" VIEW-AS TEXT
          SIZE 2.29 BY .79 AT ROW 5.75 COL 29.14 WIDGET-ID 12
     RECT-2 AT ROW 12.54 COL 1
     RECT-29 AT ROW 9.29 COL 54
     RECT-7 AT ROW 9.29 COL 1.72
     RECT-8 AT ROW 1.42 COL 1.72
     RECT-9 AT ROW 1.42 COL 54
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 91.29 BY 13.17
         FONT 1
         DEFAULT-BUTTON bt-imprime.


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
         TITLE              = "Carta de Anuˆncia - ESACR016"
         COLUMN             = 14.57
         ROW                = 8.63
         HEIGHT             = 13.17
         WIDTH              = 91.14
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
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN c-arquivo IN FRAME f-relat
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-relat
/* Query rebuild information for FRAME f-relat
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME f-relat */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Carta de Anuˆncia - ESACR016 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Carta de Anuˆncia - ESACR016 */
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
  IF RETURN-VALUE = "NO":U THEN 
      RETURN NO-APPLY.

  /*
  RUN pi-valida.
  */

  IF SESSION:SET-WAIT-STATE("general") THEN.
  RUN pi-busca-dados.
  IF SESSION:SET-WAIT-STATE("") THEN.

  IF NOT CAN-FIND (FIRST tt_tit_acr) THEN
      RETURN NO-APPLY.

  IF SESSION:SET-WAIT-STATE("general") THEN.
  RUN esp/acr/esacr016a.w (INPUT-OUTPUT TABLE tt_tit_acr,
                           OUTPUT l-ok).
  IF SESSION:SET-WAIT-STATE("") THEN.

  RUN pi_salva_param.
  IF NOT(l-ok) OR NOT CAN-FIND (FIRST tt_tit_acr WHERE 
                                      tt_tit_acr.l-marcado) THEN
      RETURN NO-APPLY.
  
  IF rs-execucao:SCREEN-VALUE IN FRAME f-relat = "2" THEN DO.
      RUN prgtec/btb/btb911za.p (INPUT  "esacr016",
                                 INPUT  "1.00.000",
                                 INPUT  0,
                                 INPUT  RECID(dwb_set_list_param),
                                 OUTPUT v_num_ped_exec_rpw).
      
      IF v_num_ped_exec_rpw <> 0 THEN DO.
          RUN pi_message  (INPUT "show",
                           INPUT 3556,
                           INPUT SUBSTITUTE("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9",
                                            v_num_ped_exec_rpw)).
      END.
  END.
  ELSE DO.
      IF SESSION:SET-WAIT-STATE("general") THEN.
      RUN esp/acr/esacr016rp.p (INPUT TABLE tt_tit_acr).
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


&Scoped-define SELF-NAME i_cdn_cliente_fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i_cdn_cliente_fim C-Win
ON LEAVE OF i_cdn_cliente_fim IN FRAME f-relat
DO:
    APPLY "VALUE-CHANGED" TO l_log_matriz IN FRAME f-relat.
    IF l_log_matriz:SENSITIVE IN FRAME f-relat THEN DO:
        APPLY "ENTRY" TO l_log_matriz IN FRAME f-relat.
        RETURN NO-APPLY.
    END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i_cdn_cliente_ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i_cdn_cliente_ini C-Win
ON LEAVE OF i_cdn_cliente_ini IN FRAME f-relat /* Cliente */
DO:
    APPLY "VALUE-CHANGED" TO l_log_matriz IN FRAME f-relat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l_log_matriz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l_log_matriz C-Win
ON VALUE-CHANGED OF l_log_matriz IN FRAME f-relat /* Matriz */
DO:
     ASSIGN INPUT FRAME f-relat i_cdn_cliente_ini i_cdn_cliente_fim.                         
                                                                                             
     ASSIGN l_log_matriz:SENSITIVE IN FRAME f-relat = i_cdn_cliente_ini = i_cdn_cliente_fim.

     IF i_cdn_cliente_ini <> i_cdn_cliente_fim THEN
         ASSIGN l_log_matriz:CHECKED IN FRAME f-relat = NO.
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
          assign c-arquivo:screen-value in frame f-relat = session:temp-directory + "esacr016.lst"
                 c-impressora                          = ""
                 c-layout                              = "".
      else
          assign c-arquivo:screen-value in frame f-relat = "esacr016.lst"
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

  /** 17/05/10 - Fixo, pois teve altera‡Æo no RP (preparado somente para Online),
                 j  que a op‡Æo batch nÆo ‚ utilizada. **/
  ASSIGN rs-execucao:SCREEN-VALUE   IN FRAME f-relat = "1":U 
         rs-execucao:SENSITIVE      IN FRAME f-relat = NO
         dt_vencto_ini:SCREEN-VALUE IN FRAME f-relat = STRING(TODAY,"99/99/9999")
         dt_vencto_fim:SCREEN-VALUE IN FRAME f-relat = STRING(TODAY,"99/99/9999").

  APPLY "value-changed" TO rs-destino IN FRAME {&FRAME-NAME}.

  RUN pi-recupera-param.

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
  DISPLAY c_cod_estab_ini c_cod_estab_fim c_cod_espec_docto_ini 
          c_cod_espec_docto_fim c_cod_ser_docto_ini c_cod_ser_docto_fim 
          c_cod_tit_acr_ini c_cod_tit_acr_fim c_cod_parcela_ini 
          c_cod_parcela_fim i_cdn_cliente_ini i_cdn_cliente_fim l_log_matriz 
          dt_vencto_ini dt_vencto_fim i-corresp i-chefe l-protesto l-especie 
          rs-destino c-arquivo rs-execucao 
      WITH FRAME f-relat IN WINDOW C-Win.
  ENABLE c_cod_estab_ini c_cod_estab_fim c_cod_espec_docto_ini 
         c_cod_espec_docto_fim c_cod_ser_docto_ini c_cod_ser_docto_fim 
         c_cod_tit_acr_ini c_cod_tit_acr_fim c_cod_parcela_ini 
         c_cod_parcela_fim i_cdn_cliente_ini i_cdn_cliente_fim l_log_matriz 
         dt_vencto_ini dt_vencto_fim i-corresp i-chefe l-protesto l-especie 
         rs-destino bt-cfimp c-arquivo bt-arquivo rs-execucao bt-imprime 
         bt-salva RECT-2 RECT-29 RECT-7 RECT-8 RECT-9 
      WITH FRAME f-relat IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-dados C-Win 
PROCEDURE pi-busca-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Buscando titulos..":U).

    DO ON STOP UNDO, LEAVE:
        ASSIGN INPUT FRAME f-relat
            c-arquivo
            rs-destino
            rs-execucao
            c_cod_estab_ini
            c_cod_estab_fim
            c_cod_tit_acr_ini
            c_cod_tit_acr_fim
            c_cod_ser_docto_ini
            c_cod_ser_docto_fim
            c_cod_parcela_ini
            c_cod_parcela_fim
            c_cod_espec_docto_ini
            c_cod_espec_docto_fim
            i_cdn_cliente_ini
            i_cdn_cliente_fim            
            l_log_matriz
            dt_vencto_ini
            dt_vencto_fim
            i-corresp
            i-chefe
            l-protesto
            l-especie.
    
        EMPTY TEMP-TABLE tt_cliente.
    
        IF i_cdn_cliente_ini <> i_cdn_cliente_fim THEN DO:
            FOR EACH emscad.cliente NO-LOCK
               WHERE emscad.cliente.cod_empresa  = v_cod_empres_usuar
                 AND emscad.cliente.cdn_cliente >= i_cdn_cliente_ini
                 AND emscad.cliente.cdn_cliente <= i_cdn_cliente_fim:
                 CREATE tt_cliente.
                 ASSIGN tt_cliente.cdn_cliente = cliente.cdn_cliente.
             END.
        END.
        ELSE DO:
            IF l_log_matriz = NO THEN DO:
                  CREATE tt_cliente.
                  ASSIGN tt_cliente.cdn_cliente = i_cdn_cliente_ini.
             END.
             ELSE DO:
                  FIND FIRST emscad.cliente NO-LOCK
                       WHERE emscad.cliente.cod_empresa = v_cod_empres_usuar
                         AND emscad.cliente.cdn_cliente = i_cdn_cliente_ini NO-ERROR.
                  IF AVAIL emscad.cliente THEN DO:
                      FIND FIRST pessoa_jurid NO-LOCK
                           WHERE pessoa_jurid.num_pessoa_jurid = emscad.cliente.num_pessoa NO-ERROR.
                      IF AVAIL pessoa_jurid THEN DO:
                          FOR EACH b_pessoa_jurid
                             WHERE b_pessoa_jurid.num_pessoa_jurid_matriz = pessoa_jurid.num_pessoa_jurid_matriz:
                              FIND FIRST b_cliente NO-LOCK 
                                   WHERE b_cliente.cod_empresa = v_cod_empres_usuar
                                     AND b_cliente.num_pessoa  = b_pessoa_jurid.num_pessoa_jurid NO-ERROR.
                              IF AVAIL b_cliente THEN DO:
                                  CREATE tt_cliente.
                                  ASSIGN tt_cliente.cdn_cliente = b_cliente.cdn_cliente.
                              END.
                          END.
                      END.
                  END.
             END.
        END.
    
        EMPTY TEMP-TABLE tt_tit_acr.
    
        FOR EACH tt_cliente:
            FOR EACH   tit_acr 
                 WHERE tit_acr.cod_empresa         = v_cod_empres_usuar
                   AND tit_acr.cdn_cliente         = tt_cliente.cdn_cliente
                   AND tit_acr.ind_tip_espec_docto = "Normal":U
                   AND tit_acr.cod_estab          >= c_cod_estab_ini
                   AND tit_acr.cod_estab          <= c_cod_estab_fim
                   AND tit_acr.cod_espec_docto    >= c_cod_espec_docto_ini
                   AND tit_acr.cod_espec_docto    <= c_cod_espec_docto_fim
                   AND tit_acr.cod_ser_docto      >= c_cod_ser_docto_ini
                   AND tit_acr.cod_ser_docto      <= c_cod_ser_docto_fim
                   AND tit_acr.cod_tit_acr        >= c_cod_tit_acr_ini
                   AND tit_acr.cod_tit_acr        <= c_cod_tit_acr_fim
                   AND tit_acr.cod_parcela        >= c_cod_parcela_ini 
                   AND tit_acr.cod_parcela        <= c_cod_parcela_fim 
                   AND tit_acr.dat_vencto_tit_acr >= dt_vencto_ini                
                   AND tit_acr.dat_vencto_tit_acr <= dt_vencto_fim NO-LOCK:

                IF VALID-HANDLE(h-acomp) THEN
                    RUN pi-acompanhar IN h-acomp (INPUT tit_acr.cod_tit_acr + "-":U + tit_acr.cod_parcela).
    
                CREATE tt_tit_acr.
                BUFFER-COPY tit_acr TO tt_tit_acr.
                ASSIGN tt_tit_acr.l-marcado = NO.
            END.
        END.

        IF NOT CAN-FIND(FIRST tt_tit_acr) THEN
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Nenhum registro encontrado para o filtro informado.":U).
    END.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recupera-param C-Win 
PROCEDURE pi-recupera-param :
/* */
    FIND dwb_set_list_param NO-LOCk
        WHERE dwb_set_list_param.cod_dwb_program = "esacr016"
          AND dwb_set_list_param.cod_dwb_user    = v_cod_usuar_corren NO-ERROR.

    IF AVAILABLE dwb_set_list_param THEN DO:

        ASSIGN rs-destino            = LOOKUP(dwb_set_list_param.Cod_dwb_output, 'Impressora,Arquivo,Terminal')
               rs-execucao           = INTEGER(entry(1,dwb_set_list_param.cod_dwb_parameters,chr(10)))
               c_cod_tit_acr_ini     = entry(2,dwb_set_list_param.cod_dwb_parameters,chr(10))
               c_cod_tit_acr_fim     = entry(3,dwb_set_list_param.cod_dwb_parameters,chr(10))
               c_cod_ser_docto_ini   = entry(4,dwb_set_list_param.cod_dwb_parameters,chr(10))    
               c_cod_ser_docto_fim   = entry(5,dwb_set_list_param.cod_dwb_parameters,chr(10))    
               c_cod_parcela_ini     = entry(6,dwb_set_list_param.cod_dwb_parameters,chr(10))
               c_cod_parcela_fim     = entry(7,dwb_set_list_param.cod_dwb_parameters,chr(10))
               c_cod_espec_docto_ini = entry(8,dwb_set_list_param.cod_dwb_parameters,chr(10))         
               c_cod_espec_docto_fim = entry(9,dwb_set_list_param.cod_dwb_parameters,chr(10))         
               i-corresp             = INTEGER(entry(10,dwb_set_list_param.cod_dwb_parameters,chr(10)))
               i-chefe               = INTEGER(entry(11,dwb_set_list_param.cod_dwb_parameters,chr(10))) 
               l-protesto            = LOGICAL(entry(12,dwb_set_list_param.cod_dwb_parameters,chr(10)))
               l-especie             = LOGICAL(entry(13,dwb_set_list_param.cod_dwb_parameters,chr(10))) 
               c_cod_estab_ini       = entry(14,dwb_set_list_param.cod_dwb_parameters,chr(10)) 
               c_cod_estab_fim       = entry(15,dwb_set_list_param.cod_dwb_parameters,chr(10)) 
               i_cdn_cliente_ini     = INTEGER(entry(16,dwb_set_list_param.cod_dwb_parameters,chr(10))) 
               i_cdn_cliente_fim     = INTEGER(entry(17,dwb_set_list_param.cod_dwb_parameters,chr(10)))
               l_log_matriz          = LOGICAL(entry(18,dwb_set_list_param.cod_dwb_parameters,chr(10))) 
               dt_vencto_ini         = DATE(entry(19,dwb_set_list_param.cod_dwb_parameters,chr(10))) 
               dt_vencto_fim         = DATE(entry(20,dwb_set_list_param.cod_dwb_parameters,chr(10))) NO-ERROR.
    END.

    DISPLAY
        rs-destino
        rs-execucao
        c_cod_estab_ini
        c_cod_estab_fim
        c_cod_tit_acr_ini
        c_cod_tit_acr_fim
        c_cod_ser_docto_ini
        c_cod_ser_docto_fim
        c_cod_parcela_ini 
        c_cod_parcela_fim 
        c_cod_espec_docto_ini
        c_cod_espec_docto_fim
        i_cdn_cliente_ini
        i_cdn_cliente_fim
        l_log_matriz
        dt_vencto_ini
        dt_vencto_fim
        i-corresp
        i-chefe
        l-protesto
        l-especie
       WITH FRAME {&FRAME-NAME}.

    APPLY "value-changed" TO rs-destino   IN FRAME f-relat.  
    APPLY "value-changed" TO l_log_matriz IN FRAME f-relat.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida C-Win 
PROCEDURE pi-valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
    FIND FIRST tit_acr NO-LOCK 
         WHERE tit_acr.cod_estab        = INPUT FRAME {&FRAME-NAME} c_cod_estab
           AND tit_acr.cod_espec_docto  = INPUT FRAME {&FRAME-NAME} c_cod_espec_docto
           AND tit_acr.cod_ser          = INPUT FRAME {&FRAME-NAME} c_cod_ser_docto
           AND tit_acr.cod_tit_acr      = INPUT FRAME {&FRAME-NAME} c_cod_tit_acr
           AND tit_acr.cod_parcela      = INPUT FRAME {&FRAME-NAME} c_cod_parcela NO-ERROR.
    IF NOT AVAIL tit_acr THEN DO:
      MESSAGE "Titulo nÆo cadastrado. Verifique..." 
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      RETURN ERROR.
    END.
       
    IF tit_acr.cod_espec_docto = "VE" 
    OR tit_acr.cod_espec_docto = "VD" 
    THEN DO:
        FIND FIRST relacto_tit_acr OF tit_acr NO-LOCK NO-ERROR.
    
        FIND FIRST parc_vendor NO-LOCK
            WHERE parc_vendor.cod_estab_tit_acr = relacto_tit_acr.cod_estab
              AND parc_vendor.num_id_tit_acr    = relacto_tit_acr.num_id_tit_acr_pai NO-ERROR.
    END.
    
    IF AVAIL parc_vendor THEN 
      ASSIGN de-valor = parc_vendor.val_parc_vendor_clien.
    ELSE
      ASSIGN de-valor = tit_acr.val_origin_tit_acr.
    
    ASSIGN dt-vencimen = tit_acr.dat_vencto_tit_acr.
    
    DEFINE BUTTON Btn_OK AUTO-GO 
         LABEL "OK" 
         SIZE 12 BY 1
         BGCOLOR 8 .

    DEFINE VARIABLE de-valor-tit AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0.00 
         LABEL "Valor" 
         VIEW-AS FILL-IN 
         SIZE 14 BY .88 NO-UNDO.

    DEFINE VARIABLE dt-vencimento AS DATE FORMAT "99/99/9999":U INITIAL ? 
         LABEL "Data Vencimento" 
         VIEW-AS FILL-IN 
         SIZE 14 BY .88 TOOLTIP "Digite ? para data de vencimento A VISTA" NO-UNDO.

    DEFINE RECTANGLE RECT-2
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 40 BY 1.54
         BGCOLOR 7 .

    DEFINE RECTANGLE RECT-31
         EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
         SIZE 40 BY 3.25.

    DEFINE FRAME Dialog-Frame
         dt-vencimento  AT ROW 1.75 COL 15 COLON-ALIGNED
         de-valor-tit   AT ROW 2.75 COL 15 COLON-ALIGNED
         Btn_OK         AT ROW 4.5 COL 2
         RECT-2         AT ROW 4.25 COL 1
         RECT-31        AT ROW 1 COL 1
         SPACE(0.13) SKIP(1.53)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
             SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
             FONT 1
             TITLE "Confirma‡Æo Valores"
             DEFAULT-BUTTON Btn_OK.

    ASSIGN dt-vencimento = dt-vencimen
           de-valor-tit  = de-valor.

    DISPLAY dt-vencimento de-valor-tit 
      WITH FRAME Dialog-Frame.
    ENABLE dt-vencimento de-valor-tit Btn_OK RECT-2 RECT-31 
      WITH FRAME Dialog-Frame.


    ON 'choose':U OF btn_ok DO:
        ASSIGN dt-vencimen = INPUT FRAME Dialog-Frame dt-vencimento
               de-valor    = INPUT FRAME Dialog-Frame de-valor-tit.
    END.

    WAIT-FOR "GO":U OF FRAME Dialog-Frame.
*/
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-vld-param C-Win 
PROCEDURE pi-vld-param :
/* */
if input frame f-relat rs-destino = 2 then 
do:
  for each ped_exec no-lock
      where ped_exec.cod_prog_dtsul = "esacr016"
        and ped_exec.ind_sit_ped    = "NÆo executado" :
          
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
    WHERE prog_dtsul.cod_prog_dtsul = "esacr016" NO-ERROR.

IF AVAIL prog_dtsul THEN 
DO:
  FOR EACH usuar_grp_usuar NO-LOCK
      WHERE usuar_grp_usuar.cod_usuar = v_cod_usuar_corren:
    IF NOT CAN-FIND(FIRST prog_dtsul_segur NO-LOCK
                    WHERE  prog_dtsul_segur.cod_prog_dtsul = "esacr016"
                      AND (prog_dtsul_segur.cod_grp_usuar  = usuar_grp_usuar.cod_grp_usuar
                       OR  prog_dtsul_segur.cod_grp_usuar  = "*")) THEN 
    DO:
      MESSAGE "Usu rio nÆo tem PermissÆo" SKIP
              "Verifique com o Administrador as permissäes para acessar este programa!" VIEW-AS ALERT-BOX ERROR.
      RETURN 'nok'.
    END.
  END.
END.
ELSE 
DO:
  MESSAGE "Programa nÆo Cadastrado no Menu!" VIEW-AS ALERT-BOX ERROR.
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
          "Programa Mensagem" c_prg_msg "nÆo encontrado."
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
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN INPUT FRAME f-relat
        c-arquivo
        rs-destino
        rs-execucao
        c_cod_estab_ini
        c_cod_estab_fim
        c_cod_tit_acr_ini
        c_cod_tit_acr_fim
        c_cod_ser_docto_ini
        c_cod_ser_docto_fim
        c_cod_parcela_ini
        c_cod_parcela_fim
        c_cod_espec_docto_ini
        c_cod_espec_docto_fim
        i_cdn_cliente_ini
        i_cdn_cliente_fim        
        l_log_matriz
        dt_vencto_ini
        dt_vencto_fim
        i-corresp
        i-chefe
        l-protesto
        l-especie.

    /*RUN prgtec/btb/btb906za.p.    */
    IF rs-destino  = 2 AND rs-execucao = 2 THEN DO:
        DO WHILE INDEX(c-arquivo,"~/") <> 0.
            ASSIGN c-arquivo = SUBSTR(c-arquivo,(INDEX(c-arquivo,"~/" ) + 1)).
        END.
    END.

    /* Recuperar parƒmetros da £ltima execu‡Æo */
    FIND dwb_set_list_param EXCLUSIVE-LOCK
        WHERE dwb_set_list_param.Cod_dwb_program = "esacr016"
          AND dwb_set_list_param.Cod_dwb_user    = v_Cod_usuar_corren 
        NO-ERROR.

    IF NOT AVAIL dwb_set_list_param THEN
        CREATE dwb_set_list_param.

    ASSIGN dwb_set_list_param.Cod_dwb_program          = "esacr016"
           dwb_set_list_param.Cod_dwb_user             = v_Cod_usuar_corren
           dwb_set_list_param.Cod_dwb_file             = c-arquivo
           dwb_set_list_param.nom_dwb_printer          = c-impressora
           dwb_set_list_param.Cod_dwb_print_layout     = c-layout
           dwb_set_list_param.qtd_dwb_line             = 60
           dwb_set_list_param.Cod_dwb_output           = IF rs-destino = 1 THEN "Impressora"
                                                                ELSE IF rs-destino = 2 THEN "Arquivo"
                                                                ELSE IF rs-destino = 3 THEN "Terminal"
                                                                ELSE "Arquivo".

    ASSIGN dwb_set_list_param.Cod_dwb_parameters       = STRING(rs-execucao)           + chr(10) + 
                                                                STRING(c_cod_tit_acr_ini)     + chr(10) + 
                                                                STRING(c_cod_tit_acr_fim)     + chr(10) + 
                                                                STRING(c_cod_ser_docto_ini)   + chr(10) +
                                                                STRING(c_cod_ser_docto_fim)   + chr(10) +
                                                                STRING(c_cod_parcela_ini)     + chr(10) +
                                                                STRING(c_cod_parcela_fim)     + chr(10) +
                                                                STRING(c_cod_espec_docto_ini) + chr(10) + 
                                                                STRING(c_cod_espec_docto_fim) + chr(10) + 
                                                                STRING(i-corresp)             + chr(10) +         
                                                                STRING(i-chefe)               + chr(10) +
                                                                STRING(l-protesto)            + chr(10) +
                                                                STRING(l-especie)             + chr(10) +
                                                                STRING(c_cod_estab_ini)       + chr(10) +
                                                                STRING(c_cod_estab_fim)       + chr(10) +
                                                                STRING(i_cdn_cliente_ini)     + chr(10) +    
                                                                STRING(i_cdn_cliente_fim)     + chr(10) +
                                                                STRING(l_log_matriz)          + chr(10) +
                                                                STRING(dt_vencto_ini,"99/99/9999") + chr(10) +
                                                                STRING(dt_vencto_fim,"99/99/9999").
    FIND FIRST dwb_set_list_param NO-LOCK
         WHERE dwb_set_list_param.Cod_dwb_program = "esacr016"
           AND dwb_set_list_param.Cod_dwb_user    = v_Cod_usuar_corren NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

