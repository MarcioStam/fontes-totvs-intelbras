&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*****************************************************************************
**     Programa.........: esp/es0251
**     Descricao .......: Relat¢rio 
**     Versao...........: 1.00.000
**     Autor............: Medeiros
**     Criado...........: 21/01/2005
**     Desc. Atualizaá∆o: 
**     Autor............: 
*******************************************************************************/

CREATE WIDGET-POOL.

DEF VAR c-ant                 AS CHAR.
DEF VAR v_num_ped_exec_rpw    AS INTE.
DEF VAR v_log_det             AS logi INIT NO.
DEF VAR v_cod_exessao         AS CHAR.
DEF VAR c-impressora          AS CHAR.
DEF VAR c-layout              AS CHAR.
DEF VAR c-impressora-2        AS CHAR.
DEF VAR c-layout-2            AS CHAR.
DEF VAR wh-exessao            as HANDLE.

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
    
    
DEF temp-table tt-ap
    field cod-esp         like tit_ap.cod_espec_docto
    field cdn_fornec      like fornec_financ.cdn_fornec
    field cdn_fornec_orig like fornec_financ.cdn_fornec
    field ep-codigo       like tit_ap.cod_empresa
    field cod-estabel     like tit_ap.cod_estab
    field nome-abrev      like fornecedor.nom_abrev
    field nome-abrev_orig like fornecedor.nom_pessoa
    field nr-docto        like tit_ap.cod_tit_ap
    field parcela         like tit_ap.cod_parcela
    field dt-transacao    like tit_ap.dat_transacao
    field dt-vencimen     like tit_ap.dat_vencto_tit_ap
    field dt-liquidac     like tit_ap.dat_liquidac
    field valor-original  like tit_ap.val_origin_tit_ap
    field valor-saldo     like tit_ap.val_sdo_tit_ap
    field cod-retencao    LIKE classif_impto.cod_classif_impto
    field serie           like tit_ap.cod_ser_docto
    field l-ok            as char format "x(1)" LABEL " "
    FIELD valor-rendto    LIKE compl_impto_retid_ap.val_rendto_tribut
    index codigo is primary cod-retencao dt-transacao.

DEF BUFFER b_movto_tit_ap FOR movto_tit_ap.
DEF BUFFER b_tit_ap       FOR tit_ap.
DEF BUFFER b_fornecedor   FOR fornecedor.



DEFINE VARIABLE vcod_estab_ini         LIKE tit_ap.cod_estab          NO-UNDO.
DEFINE VARIABLE vcod_estab_fim         LIKE tit_ap.cod_estab          NO-UNDO.
DEFINE VARIABLE vcdn_fornecedor_ini    LIKE tit_ap.cdn_fornecedor     NO-UNDO.
DEFINE VARIABLE vcdn_fornecedor_fim    LIKE tit_ap.cdn_fornecedor     NO-UNDO.
DEFINE VARIABLE vdat_vencto_tit_ap_ini LIKE tit_ap.dat_vencto_tit_ap  NO-UNDO.
DEFINE VARIABLE vdat_vencto_tit_ap_fim LIKE tit_ap.dat_vencto_tit_ap  NO-UNDO.
DEFINE VARIABLE vcod_retencao_ini      LIKE compl_impto_retid_ap.cod_classif_impto NO-UNDO.
DEFINE VARIABLE vcod_retencao_fim      LIKE compl_impto_retid_ap.cod_classif_impto NO-UNDO.
DEFINE VARIABLE vtitulos-pagos         AS LOGICAL NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-relat
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ap

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tt-ap.l-ok tt-ap.cod-retencao tt-ap.cod-esp tt-ap.nome-abrev tt-ap.nr-docto tt-ap.parcela tt-ap.dt-transacao tt-ap.dt-vencimen tt-ap.valor-original tt-ap.valor-saldo   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2   
&Scoped-define SELF-NAME BROWSE-2
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tt-ap NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY {&SELF-NAME} FOR EACH tt-ap NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tt-ap
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tt-ap


/* Definitions for FRAME f-relat                                        */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-relat ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-10 RECT-2 RECT-3 RECT-7 RECT-8 RECT-9 ~
btFiltro BROWSE-2 btMarca btDesmarca dt-apura c-texto dt-vencto bt-cfimp-2 ~
bt-cfimp rs-destino rs-destino-2 bt-arquivo-2 bt-arquivo c-arquivo ~
c-arquivo-2 bt-imprime bt-salva 
&Scoped-Define DISPLAYED-OBJECTS dt-apura c-texto dt-vencto rs-destino ~
rs-destino-2 c-arquivo c-arquivo-2 

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

DEFINE BUTTON bt-arquivo-2 
     IMAGE-UP FILE "image/im-sea1.bmp":U
     LABEL "" 
     SIZE 3.86 BY 1.08 TOOLTIP "Localiza Arquivo".

DEFINE BUTTON bt-cfimp 
     IMAGE-UP FILE "image/im-pri.bmp":U
     LABEL "" 
     SIZE 3.86 BY 1.08 TOOLTIP "Layout Impress∆o".

DEFINE BUTTON bt-cfimp-2 
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

DEFINE BUTTON btDesmarca 
     IMAGE-UP FILE "image/im-ran_n.bmp":U
     LABEL "Desmarca" 
     SIZE 4 BY 1.25 TOOLTIP "Desmarca todos os registros do browse".

DEFINE BUTTON btFiltro 
     IMAGE-UP FILE "image\im-ran.bmp":U
     IMAGE-INSENSITIVE FILE "image\ii-ran.bmp":U
     LABEL "Mail" 
     SIZE 4 BY 1.25 TOOLTIP "Filtro".

DEFINE BUTTON btMarca 
     IMAGE-UP FILE "image/im-ran_a.bmp":U
     LABEL "Marca" 
     SIZE 4 BY 1.25 TOOLTIP "Marca todos os registros do browse".

DEFINE VARIABLE c-arquivo AS CHARACTER FORMAT "X(40)":U INITIAL "darf_rel.lst" 
     VIEW-AS FILL-IN 
     SIZE 39.29 BY .88 TOOLTIP "Destino"
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE c-arquivo-2 AS CHARACTER FORMAT "X(40)":U INITIAL "darf.lst" 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 TOOLTIP "Destino"
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE c-texto AS CHARACTER FORMAT "X(60)":U 
     LABEL "Texto" 
     VIEW-AS FILL-IN 
     SIZE 53 BY .88 TOOLTIP "Texto"
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE dt-apura AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     LABEL "Apuraá∆o" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .79 NO-UNDO.

DEFINE VARIABLE dt-vencto AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     LABEL "Vencimento" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .79 NO-UNDO.

DEFINE VARIABLE rs-destino AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 39 BY .83 TOOLTIP "Destino da Impress∆o"
     FONT 1 NO-UNDO.

DEFINE VARIABLE rs-destino-2 AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 38.14 BY .83 TOOLTIP "Destino da Impress∆o"
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 3.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 89.72 BY 1.54
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 89.72 BY 1.54
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 45.57 BY 2.92.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 3.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 44.14 BY 2.92.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tt-ap SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 C-Win _FREEFORM
  QUERY BROWSE-2 NO-LOCK DISPLAY
      tt-ap.l-ok
      tt-ap.cod-retencao
      tt-ap.cod-esp
      tt-ap.nome-abrev
      tt-ap.nr-docto
      tt-ap.parcela
      tt-ap.dt-transacao
      tt-ap.dt-vencimen
      tt-ap.valor-original format ">>,>>9.99"
      tt-ap.valor-saldo    format ">>,>>9.99"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 84 BY 7.75
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-relat
     btFiltro AT ROW 1.42 COL 3 HELP
          "Pesquisa"
     BROWSE-2 AT ROW 3.38 COL 2
     btMarca AT ROW 5.25 COL 86.72 HELP
          "Marca todos os registros do browse"
     btDesmarca AT ROW 6.75 COL 86.72 HELP
          "Desmarca todos os registros do browse"
     dt-apura AT ROW 12.13 COL 8.72 COLON-ALIGNED
     c-texto AT ROW 12.63 COL 26.28 HELP
          "Texto"
     dt-vencto AT ROW 13.13 COL 8.72 COLON-ALIGNED
     bt-cfimp-2 AT ROW 15.46 COL 86.29 HELP
          "Layout Impress∆o"
     bt-cfimp AT ROW 15.5 COL 41.57 HELP
          "Layout Impress∆o"
     rs-destino AT ROW 15.71 COL 2 HELP
          "Destino da Impress∆o" NO-LABEL
     rs-destino-2 AT ROW 15.71 COL 47.86 HELP
          "Destino da Impress∆o" NO-LABEL
     bt-arquivo-2 AT ROW 16.71 COL 86.29 HELP
          "Localiza Arquivo"
     bt-arquivo AT ROW 16.79 COL 41.57 HELP
          "Localiza Arquivo"
     c-arquivo AT ROW 16.88 COL 2.14 HELP
          "Destino" NO-LABEL
     c-arquivo-2 AT ROW 16.88 COL 48 HELP
          "Destino" NO-LABEL
     bt-imprime AT ROW 18.42 COL 2.29
     bt-salva AT ROW 18.42 COL 14
     " ParÉmetros" VIEW-AS TEXT
          SIZE 11 BY .54 AT ROW 11.38 COL 3
          FONT 6
     "  DARF" VIEW-AS TEXT
          SIZE 6.43 BY .54 AT ROW 15 COL 47
          FONT 6
     "  Relaá∆o de Documentos" VIEW-AS TEXT
          SIZE 21 BY .54 AT ROW 15 COL 1.57
          FONT 6
     " Seleá∆o" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 2.83 COL 3
          FONT 6
     RECT-10 AT ROW 11.63 COL 1
     RECT-2 AT ROW 18.13 COL 1.29
     RECT-3 AT ROW 1.25 COL 1
     RECT-7 AT ROW 15.17 COL 1
     RECT-8 AT ROW 1.25 COL 1
     RECT-9 AT ROW 15.17 COL 46.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 18.88
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
         TITLE              = "Emiss∆o de DARF - ESAPB001"
         COLUMN             = 61.43
         ROW                = 10.58
         HEIGHT             = 18.88
         WIDTH              = 90
         MAX-HEIGHT         = 18.88
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 18.88
         VIRTUAL-WIDTH      = 90
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
/* SETTINGS FOR FRAME f-relat
   L-To-R                                                               */
/* BROWSE-TAB BROWSE-2 btFiltro f-relat */
/* SETTINGS FOR FILL-IN c-arquivo IN FRAME f-relat
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-arquivo-2 IN FRAME f-relat
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN c-texto IN FRAME f-relat
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ap NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-relat
/* Query rebuild information for FRAME f-relat
     _Query            is NOT OPENED
*/  /* FRAME f-relat */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Emiss∆o de DARF - ESAPB001 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Emiss∆o de DARF - ESAPB001 */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&Scoped-define SELF-NAME BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 C-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-2 IN FRAME f-relat
DO:
    APPLY "return" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 C-Win
ON RETURN OF BROWSE-2 IN FRAME f-relat
DO:
    if tt-ap.l-ok = "*" then
        assign tt-ap.l-ok = "" .
    else
        assign tt-ap.l-ok = "*".

    self:refresh().   
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


&Scoped-define SELF-NAME bt-arquivo-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo-2 C-Win
ON CHOOSE OF bt-arquivo-2 IN FRAME f-relat
DO:
    def var c-arq-conv  as char no-undo.
    def var l-ok        as logical init no.

    assign c-arq-conv = replace(input frame f-relat c-arquivo-2, "/", "\").
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
        display c-arq-conv @ c-arquivo-2 with frame f-relat.
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


&Scoped-define SELF-NAME bt-cfimp-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cfimp-2 C-Win
ON CHOOSE OF bt-cfimp-2 IN FRAME f-relat
DO:
    assign c-ant = c-arquivo-2:screen-value in frame f-relat.
  
    run prgtec/btb/btb036nb.p (output c-impressora-2, output c-layout-2).
    
    if c-arquivo-2 <> ":" then
      assign c-arquivo-2 = c-impressora-2 + ":" + c-layout-2.
    else
      assign c-arquivo-2 = c-ant.
      
    disp c-arquivo-2 with frame f-relat.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-imprime
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-imprime C-Win
ON CHOOSE OF bt-imprime IN FRAME f-relat /* Imprimir */
DO:

  IF RETURN-VALUE = "no" 
    THEN RETURN NO-APPLY.
  
  ASSIGN dt-apura
         dt-vencto
         c-texto.    
    
  RUN pi_salva_param.
  
  IF SESSION:SET-WAIT-STATE("general") THEN.
  RUN esp/apb/esapb001rp.p (INPUT TABLE tt-ap,
                            INPUT dt-apura,
                            INPUT dt-vencto,
                            INPUT c-texto).
  IF SESSION:SET-WAIT-STATE("") THEN.
  
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


&Scoped-define SELF-NAME btDesmarca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDesmarca C-Win
ON CHOOSE OF btDesmarca IN FRAME f-relat /* Desmarca */
DO:
    FOR EACH tt-ap:
        ASSIGN tt-ap.l-ok = "".
    END.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFiltro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFiltro C-Win
ON CHOOSE OF btFiltro IN FRAME f-relat /* Mail */
DO:

    RUN esp/apb/esapb001a.w(INPUT-OUTPUT vcod_estab_ini,
                            INPUT-OUTPUT vcod_estab_fim,
                            INPUT-OUTPUT vcdn_fornecedor_ini, 
                            INPUT-OUTPUT vcdn_fornecedor_fim, 
                            INPUT-OUTPUT vdat_vencto_tit_ap_ini, 
                            INPUT-OUTPUT vdat_vencto_tit_ap_fim,
                            INPUT-OUTPUT vcod_retencao_ini,
                            INPUT-OUTPUT vcod_retencao_fim,
                            INPUT-OUTPUT vtitulos-pagos).
     RUN pi_monta_selecao.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btMarca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btMarca C-Win
ON CHOOSE OF btMarca IN FRAME f-relat /* Marca */
DO:
    FOR EACH tt-ap:
        ASSIGN tt-ap.l-ok = "*".
    END.
    {&OPEN-QUERY-{&BROWSE-NAME}}
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
  
      FIND dwb_set_list_param EXCLUSIVE-LOCK
               WHERE dwb_set_list_param.cod_dwb_program = "esapb001"
                 AND dwb_set_list_param.cod_dwb_user    = v_cod_usuar_corren 
               NO-ERROR.
                                
      assign bt-arquivo:visible  in frame f-relat = yes
             bt-cfimp:visible    in frame f-relat = no
             c-arquivo:visible   in frame f-relat = yes             
             c-arquivo:sensitive in frame f-relat = yes.
             
      IF AVAIL dwb_set_list_param THEN
            ASSIGN c-arquivo:SCREEN-VALUE IN FRAME f-relat =  dwb_set_list_param.Cod_dwb_file
                   c-layout  =  dwb_set_list_param.Cod_dwb_print_layout
                   c-impressora = dwb_set_list_param.nom_dwb_printer.
      ELSE             
        assign c-arquivo:screen-value in frame f-relat = "esapb001.lst"
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


&Scoped-define SELF-NAME rs-destino-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-destino-2 C-Win
ON VALUE-CHANGED OF rs-destino-2 IN FRAME f-relat
DO:
  if input frame f-relat rs-destino-2 = 1 then do:
      assign bt-arquivo-2:visible  in frame f-relat = no
             bt-cfimp-2:visible    in frame f-relat = yes
             c-arquivo-2:visible   in frame f-relat = yes
             c-arquivo-2:sensitive in frame f-relat = no.
      if c-impressora-2 = "" then do:
          find first imprsor_usuar no-lock
              where imprsor_usuar.cod_usuario = v_cod_usuar_corren
              use-index imprsrsr_id no-error.
          if avail imprsor_usuar then do:
              find first layout_impres no-lock
                  where layout_impres.nom_impressora  = imprsor_usuar.nom_impressora no-error.
              if avail layout_impres then
                  assign c-arquivo-2:screen-value in frame f-relat = imprsor_usuar.nom_impressora 
                                                               + ":" 
                                                               + layout_impres.cod_layout_impres
                         c-impressora-2                          = imprsor_usuar.nom_impressora
                         c-layout-2                              = layout_impres.cod_layout_impres.
          end.
      end.
      else
          assign c-arquivo-2:screen-value in frame f-relat = c-impressora-2 + ":" + c-layout-2.
          
  end.
             
  if input frame f-relat rs-destino-2 = 2 then do:
      assign bt-arquivo-2:visible  in frame f-relat = yes
             bt-cfimp-2:visible    in frame f-relat = no
             c-arquivo-2:visible   in frame f-relat = yes             
             c-arquivo-2:sensitive in frame f-relat = yes.
             
      FIND dwb_set_list_param EXCLUSIVE-LOCK
               WHERE dwb_set_list_param.cod_dwb_program = "esapb001"
                 AND dwb_set_list_param.cod_dwb_user    = v_cod_usuar_corren 
               NO-ERROR.
               
      IF AVAIL dwb_set_list_param THEN
          ASSIGN c-arquivo-2:SCREEN-VALUE IN FRAME f-relat =  ENTRY(2,dwb_set_list_param.Cod_dwb_parameters,CHR(10))
                 c-layout-2  =  ENTRY(4,dwb_set_list_param.Cod_dwb_parameters,CHR(10))
                 c-impressora-2 = ENTRY(3,dwb_set_list_param.Cod_dwb_parameters,CHR(10)).        
      ELSE
          assign c-arquivo-2:screen-value in frame f-relat = "esapb001.lst"
                 c-impressora-2                          = ""
                 c-layout-2                              = "".                    
  end.

  if input frame f-relat rs-destino-2 = 3 then
      assign bt-arquivo-2:visible  in frame f-relat = no
             bt-cfimp-2:visible    in frame f-relat = no
             c-arquivo-2:visible   in frame f-relat = no.
  
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
  
  RUN esp/apb/esapb001a.w(INPUT-OUTPUT vcod_estab_ini,
                          INPUT-OUTPUT vcod_estab_fim,
                          INPUT-OUTPUT vcdn_fornecedor_ini   , 
                          INPUT-OUTPUT vcdn_fornecedor_fim   , 
                          INPUT-OUTPUT vdat_vencto_tit_ap_ini, 
                          INPUT-OUTPUT vdat_vencto_tit_ap_fim,
                          INPUT-OUTPUT vcod_retencao_ini,
                          INPUT-OUTPUT vcod_retencao_fim,
                          INPUT-OUTPUT vtitulos-pagos).
  
  RUN pi_monta_selecao.
    
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
  DISPLAY dt-apura c-texto dt-vencto rs-destino rs-destino-2 c-arquivo 
          c-arquivo-2 
      WITH FRAME f-relat IN WINDOW C-Win.
  ENABLE RECT-10 RECT-2 RECT-3 RECT-7 RECT-8 RECT-9 btFiltro BROWSE-2 btMarca 
         btDesmarca dt-apura c-texto dt-vencto bt-cfimp-2 bt-cfimp rs-destino 
         rs-destino-2 bt-arquivo-2 bt-arquivo c-arquivo c-arquivo-2 bt-imprime 
         bt-salva 
      WITH FRAME f-relat IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recupera-param C-Win 
PROCEDURE pi-recupera-param :
FIND dwb_set_list_param EXCLUSIVE-LOCK
       WHERE dwb_set_list_param.cod_dwb_program = "esapb001"
         AND dwb_set_list_param.cod_dwb_user    = v_cod_usuar_corren 
       NO-ERROR.
  
  IF AVAIL dwb_set_list_param THEN 
  DO WITH FRAME f-relat:
    ASSIGN rs-destino:SCREEN-VALUE        IN FRAME f-relat = IF dwb_set_list_param.cod_dwb_output = "impressora" 
                                                               THEN "1"
                                                               ELSE IF dwb_set_list_param.cod_dwb_output = "arquivo" 
                                                                    THEN "2"
                                                                    ELSE "3".
    ASSIGN c-arquivo:SCREEN-VALUE IN FRAME f-relat =  dwb_set_list_param.Cod_dwb_file
           c-layout  =  dwb_set_list_param.Cod_dwb_print_layout
           c-impressora = dwb_set_list_param.nom_dwb_printer.
    ASSIGN rs-destino-2:SCREEN-VALUE        IN FRAME f-relat = ENTRY(1,dwb_set_list_param.Cod_dwb_parameters,CHR(10)).
    ASSIGN c-arquivo-2:SCREEN-VALUE IN FRAME f-relat =  ENTRY(2,dwb_set_list_param.Cod_dwb_parameters,CHR(10))
           c-layout-2  =  ENTRY(4,dwb_set_list_param.Cod_dwb_parameters,CHR(10))
           c-impressora-2 = ENTRY(3,dwb_set_list_param.Cod_dwb_parameters,CHR(10)).
           
    APPLY "value-changed" TO rs-destino     IN FRAME f-relat.  
    APPLY "value-changed" TO rs-destino-2   IN FRAME f-relat.
  END.   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-vld-usuario C-Win 
PROCEDURE pi-vld-usuario :
/* */
FIND prog_dtsul NO-LOCK
    WHERE prog_dtsul.cod_prog_dtsul = "esapb001" NO-ERROR.

IF AVAIL prog_dtsul THEN 
DO:
  FOR EACH usuar_grp_usuar NO-LOCK
      WHERE usuar_grp_usuar.cod_usuar = v_cod_usuar_corren:
    IF NOT CAN-FIND(FIRST prog_dtsul_segur NO-LOCK
                    WHERE  prog_dtsul_segur.cod_prog_dtsul = "esapb001"
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_monta_selecao C-Win 
PROCEDURE pi_monta_selecao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 IF SESSION:SET-WAIT-STATE("general") THEN.

 FOR EACH tt-ap:
    DELETE tt-ap.
 END.


 IF vtitulos-pagos = NO THEN DO:
     FOR EACH  estabelecimento NO-LOCK
         WHERE estabelecimento.cod_empresa = v_cod_empres_usuar
         AND   estabelecimento.cod_estab  >= vcod_estab_ini
         AND   estabelecimento.cod_estab  <= vcod_estab_fim,
         EACH tit_ap NO-LOCK WHERE
             (tit_ap.cod_estab          = estabelecimento.cod_estab AND
              tit_ap.cod_espec_docto    = "IR"                      AND
              tit_ap.log_sdo_tit_ap     = YES                       AND
              tit_ap.cdn_fornecedor    >= vcdn_fornecedor_ini       AND
              tit_ap.cdn_fornecedor    <= vcdn_fornecedor_fim       AND
              tit_ap.dat_vencto_tit_ap >= vdat_vencto_tit_ap_ini    AND
              tit_ap.dat_vencto_tit_ap <= vdat_vencto_tit_ap_fim)   
              OR
             (tit_ap.cod_estab          = estabelecimento.cod_estab AND
              tit_ap.cod_espec_docto    = "CB"                      AND
              tit_ap.log_sdo_tit_ap     = YES                       AND
              tit_ap.cdn_fornecedor    >= vcdn_fornecedor_ini       AND
              tit_ap.cdn_fornecedor    <= vcdn_fornecedor_fim       AND
              tit_ap.dat_vencto_tit_ap >= vdat_vencto_tit_ap_ini    AND
              tit_ap.dat_vencto_tit_ap <= vdat_vencto_tit_ap_fim)   
              OR
             (tit_ap.cod_estab          = estabelecimento.cod_estab AND
              tit_ap.cod_espec_docto    = "cl"                      AND
              tit_ap.log_sdo_tit_ap     = YES                       AND
              tit_ap.cdn_fornecedor    >= vcdn_fornecedor_ini       AND
              tit_ap.cdn_fornecedor    <= vcdn_fornecedor_fim       AND
              tit_ap.dat_vencto_tit_ap >= vdat_vencto_tit_ap_ini    AND
              tit_ap.dat_vencto_tit_ap <= vdat_vencto_tit_ap_fim)   
              OR
             (tit_ap.cod_estab          = estabelecimento.cod_estab AND
              tit_ap.cod_espec_docto    = "cp"                      AND
              tit_ap.log_sdo_tit_ap     = YES                       AND
              tit_ap.cdn_fornecedor    >= vcdn_fornecedor_ini       AND
              tit_ap.cdn_fornecedor    <= vcdn_fornecedor_fim       AND
              tit_ap.dat_vencto_tit_ap >= vdat_vencto_tit_ap_ini    AND
              tit_ap.dat_vencto_tit_ap <= vdat_vencto_tit_ap_fim)   
              OR
             (tit_ap.cod_estab          = estabelecimento.cod_estab AND
              tit_ap.cod_espec_docto    = "co"                      AND
              tit_ap.log_sdo_tit_ap     = YES                       AND
              tit_ap.cdn_fornecedor    >= vcdn_fornecedor_ini       AND
              tit_ap.cdn_fornecedor    <= vcdn_fornecedor_fim       AND
              tit_ap.dat_vencto_tit_ap >= vdat_vencto_tit_ap_ini    AND
              tit_ap.dat_vencto_tit_ap <= vdat_vencto_tit_ap_fim)   
              OR
             (tit_ap.cod_estab          = estabelecimento.cod_estab AND
              tit_ap.cod_espec_docto    = "ca"                      AND
              tit_ap.log_sdo_tit_ap     = YES                       AND
              tit_ap.cdn_fornecedor    >= vcdn_fornecedor_ini       AND
              tit_ap.cdn_fornecedor    <= vcdn_fornecedor_fim       AND
              tit_ap.dat_vencto_tit_ap >= vdat_vencto_tit_ap_ini    AND
              tit_ap.dat_vencto_tit_ap <= vdat_vencto_tit_ap_fim)   
              OR
             (tit_ap.cod_estab          = estabelecimento.cod_estab AND
              tit_ap.cod_espec_docto    = "cc"                      AND
              tit_ap.log_sdo_tit_ap     = YES                       AND
              tit_ap.cdn_fornecedor    >= vcdn_fornecedor_ini       AND
              tit_ap.cdn_fornecedor    <= vcdn_fornecedor_fim       AND
              tit_ap.dat_vencto_tit_ap >= vdat_vencto_tit_ap_ini    AND
              tit_ap.dat_vencto_tit_ap <= vdat_vencto_tit_ap_fim)   
              OR
             (tit_ap.cod_estab          = estabelecimento.cod_estab AND
              tit_ap.cod_espec_docto    = "cs"                      AND
              tit_ap.log_sdo_tit_ap     = YES                       AND
              tit_ap.cdn_fornecedor    >= vcdn_fornecedor_ini       AND
              tit_ap.cdn_fornecedor    <= vcdn_fornecedor_fim       AND
              tit_ap.dat_vencto_tit_ap >= vdat_vencto_tit_ap_ini    AND
              tit_ap.dat_vencto_tit_ap <= vdat_vencto_tit_ap_fim):
    
         IF tit_ap.cod_tit_ap = "0602741" THEN
             MESSAGE "achou"
                 VIEW-AS ALERT-BOX INFO BUTTONS OK.
    
         FOR EACH compl_impto_retid_ap NO-LOCK WHERE
                  compl_impto_retid_ap.num_id_tit_ap      = tit_ap.num_id_tit_ap  AND
                  compl_impto_retid_ap.cod_estab          = tit_ap.cod_estab      AND
                  compl_impto_retid_ap.cod_classif_impto >= vcod_retencao_ini     AND
                  compl_impto_retid_ap.cod_classif_impto <= vcod_retencao_fim:
    
             FIND FIRST b_movto_tit_ap NO-LOCK WHERE
                        b_movto_tit_ap.cod_estab           = compl_impto_retid_ap.cod_estab AND
                        b_movto_tit_ap.num_id_movto_tit_ap = compl_impto_retid_ap.num_id_movto_tit_ap_pai NO-ERROR.
             IF AVAIL b_movto_tit_ap THEN DO:
                FIND b_tit_ap NO-LOCK  WHERE
                     b_tit_ap.cod_estab     = b_movto_tit_ap.cod_estab     AND
                     b_tit_ap.num_id_tit_ap = b_movto_tit_ap.num_id_tit_ap NO-ERROR.
                IF AVAIL b_tit_ap THEN DO:
                   FIND FIRST b_fornecedor OF b_tit_ap NO-LOCK NO-ERROR.
                   FIND FIRST fornecedor OF tit_ap NO-LOCK NO-ERROR.
                   CREATE tt-ap.
                   ASSIGN TT-AP.cod-retencao    = compl_impto_retid_ap.cod_classif_impto
                          tt-ap.dt-transacao    = compl_impto_retid_ap.dat_vencto_tit_ap
                          tt-ap.cod-esp         = tit_ap.cod_espec_docto                   
                          tt-ap.cdn_fornec      = fornecedor.cdn_fornec
                          tt-ap.cdn_fornec_orig = b_fornecedor.cdn_fornec
                          tt-ap.cod-estabel     = tit_ap.cod_estab                         
                          tt-ap.ep-codigo       = tit_ap.cod_empresa                       
                          tt-ap.serie           = tit_ap.cod_ser_docto                     
                          tt-ap.nome-abrev      = fornecedor.nom_abrev
                          tt-ap.nome-abrev_orig = b_fornecedor.nom_pessoa
                          tt-ap.nr-docto        = tit_ap.cod_tit_ap                        
                          tt-ap.parcela         = tit_ap.cod_parcela                       
                          tt-ap.dt-vencimen     = tit_ap.dat_vencto_tit_ap
                          tt-ap.dt-liquidac     = IF b_tit_ap.dat_liquidac = 12/31/9999 THEN ? ELSE b_tit_ap.dat_liquidac
                          tt-ap.dt-transacao    = tit_ap.dat_transacao   
                          tt-ap.valor-original  = tit_ap.val_origin_tit_ap
                          tt-ap.valor-saldo     = tit_ap.val_sdo_tit_ap   
                          tt-ap.cod-retencao    = compl_impto_retid_ap.cod_classif_impto 
                          tt-ap.valor-rendto    = compl_impto_retid_ap.val_rendto_tribut.
                END.
             END.
         END.
     END.
 END.

 ELSE DO:
     FOR EACH  estabelecimento NO-LOCK
         WHERE estabelecimento.cod_empresa = v_cod_empres_usuar
         AND   estabelecimento.cod_estab  >= vcod_estab_ini
         AND   estabelecimento.cod_estab  <= vcod_estab_fim,
         EACH tit_ap NO-LOCK WHERE
             (tit_ap.cod_estab          = estabelecimento.cod_estab AND
              tit_ap.cod_espec_docto    = "IR"                      AND
              tit_ap.log_sdo_tit_ap     = NO                        AND
              tit_ap.cdn_fornecedor    >= vcdn_fornecedor_ini       AND
              tit_ap.cdn_fornecedor    <= vcdn_fornecedor_fim       AND
              tit_ap.dat_vencto_tit_ap >= vdat_vencto_tit_ap_ini    AND
              tit_ap.dat_vencto_tit_ap <= vdat_vencto_tit_ap_fim)   
              OR
             (tit_ap.cod_estab          = estabelecimento.cod_estab AND
              tit_ap.cod_espec_docto    = "CB"                      AND
              tit_ap.log_sdo_tit_ap     = NO                        AND
              tit_ap.cdn_fornecedor    >= vcdn_fornecedor_ini       AND
              tit_ap.cdn_fornecedor    <= vcdn_fornecedor_fim       AND
              tit_ap.dat_vencto_tit_ap >= vdat_vencto_tit_ap_ini    AND
              tit_ap.dat_vencto_tit_ap <= vdat_vencto_tit_ap_fim)   
              OR
             (tit_ap.cod_estab          = estabelecimento.cod_estab AND
              tit_ap.cod_espec_docto    = "cl"                      AND
              tit_ap.log_sdo_tit_ap     = NO                        AND
              tit_ap.cdn_fornecedor    >= vcdn_fornecedor_ini       AND
              tit_ap.cdn_fornecedor    <= vcdn_fornecedor_fim       AND
              tit_ap.dat_vencto_tit_ap >= vdat_vencto_tit_ap_ini    AND
              tit_ap.dat_vencto_tit_ap <= vdat_vencto_tit_ap_fim)   
              OR
             (tit_ap.cod_estab          = estabelecimento.cod_estab AND
              tit_ap.cod_espec_docto    = "cp"                      AND
              tit_ap.log_sdo_tit_ap     = NO                        AND
              tit_ap.cdn_fornecedor    >= vcdn_fornecedor_ini       AND
              tit_ap.cdn_fornecedor    <= vcdn_fornecedor_fim       AND
              tit_ap.dat_vencto_tit_ap >= vdat_vencto_tit_ap_ini    AND
              tit_ap.dat_vencto_tit_ap <= vdat_vencto_tit_ap_fim)   
              OR
             (tit_ap.cod_estab          = estabelecimento.cod_estab AND
              tit_ap.cod_espec_docto    = "co"                      AND
              tit_ap.log_sdo_tit_ap     = NO                        AND
              tit_ap.cdn_fornecedor    >= vcdn_fornecedor_ini       AND
              tit_ap.cdn_fornecedor    <= vcdn_fornecedor_fim       AND
              tit_ap.dat_vencto_tit_ap >= vdat_vencto_tit_ap_ini    AND
              tit_ap.dat_vencto_tit_ap <= vdat_vencto_tit_ap_fim)   
              OR
             (tit_ap.cod_estab          = estabelecimento.cod_estab AND
              tit_ap.cod_espec_docto    = "ca"                      AND
              tit_ap.log_sdo_tit_ap     = NO                        AND
              tit_ap.cdn_fornecedor    >= vcdn_fornecedor_ini       AND
              tit_ap.cdn_fornecedor    <= vcdn_fornecedor_fim       AND
              tit_ap.dat_vencto_tit_ap >= vdat_vencto_tit_ap_ini    AND
              tit_ap.dat_vencto_tit_ap <= vdat_vencto_tit_ap_fim)   
              OR
             (tit_ap.cod_estab          = estabelecimento.cod_estab AND
              tit_ap.cod_espec_docto    = "ca"                      AND
              tit_ap.log_sdo_tit_ap     = NO                        AND
              tit_ap.cdn_fornecedor    >= vcdn_fornecedor_ini       AND
              tit_ap.cdn_fornecedor    <= vcdn_fornecedor_fim       AND
              tit_ap.dat_vencto_tit_ap >= vdat_vencto_tit_ap_ini    AND
              tit_ap.dat_vencto_tit_ap <= vdat_vencto_tit_ap_fim)   
              OR
             (tit_ap.cod_estab          = estabelecimento.cod_estab AND
              tit_ap.cod_espec_docto    = "cs"                      AND
              tit_ap.log_sdo_tit_ap     = NO                        AND
              tit_ap.cdn_fornecedor    >= vcdn_fornecedor_ini       AND
              tit_ap.cdn_fornecedor    <= vcdn_fornecedor_fim       AND
              tit_ap.dat_vencto_tit_ap >= vdat_vencto_tit_ap_ini    AND
              tit_ap.dat_vencto_tit_ap <= vdat_vencto_tit_ap_fim):
    
         IF tit_ap.cod_tit_ap = "0602741" THEN
             MESSAGE "achou"
                 VIEW-AS ALERT-BOX INFO BUTTONS OK.
    
         FOR EACH compl_impto_retid_ap NO-LOCK WHERE
                  compl_impto_retid_ap.num_id_tit_ap      = tit_ap.num_id_tit_ap  AND
                  compl_impto_retid_ap.cod_estab          = tit_ap.cod_estab      AND
                  compl_impto_retid_ap.cod_classif_impto >= vcod_retencao_ini     AND
                  compl_impto_retid_ap.cod_classif_impto <= vcod_retencao_fim:
    
             FIND FIRST b_movto_tit_ap NO-LOCK WHERE
                        b_movto_tit_ap.cod_estab           = compl_impto_retid_ap.cod_estab AND
                        b_movto_tit_ap.num_id_movto_tit_ap = compl_impto_retid_ap.num_id_movto_tit_ap_pai NO-ERROR.
             IF AVAIL b_movto_tit_ap THEN DO:
                FIND b_tit_ap NO-LOCK  WHERE
                     b_tit_ap.cod_estab     = b_movto_tit_ap.cod_estab     AND
                     b_tit_ap.num_id_tit_ap = b_movto_tit_ap.num_id_tit_ap NO-ERROR.
                IF AVAIL b_tit_ap THEN DO:
                   FIND FIRST b_fornecedor OF b_tit_ap NO-LOCK NO-ERROR.
                   FIND FIRST fornecedor OF tit_ap NO-LOCK NO-ERROR.
                   CREATE tt-ap.
                   ASSIGN TT-AP.cod-retencao    = compl_impto_retid_ap.cod_classif_impto
                          tt-ap.dt-transacao    = compl_impto_retid_ap.dat_vencto_tit_ap
                          tt-ap.cod-esp         = tit_ap.cod_espec_docto                   
                          tt-ap.cdn_fornec      = fornecedor.cdn_fornec
                          tt-ap.cdn_fornec_orig = b_fornecedor.cdn_fornec
                          tt-ap.cod-estabel     = tit_ap.cod_estab                         
                          tt-ap.ep-codigo       = tit_ap.cod_empresa                       
                          tt-ap.serie           = tit_ap.cod_ser_docto                     
                          tt-ap.nome-abrev      = fornecedor.nom_abrev
                          tt-ap.nome-abrev_orig = b_fornecedor.nom_pessoa
                          tt-ap.nr-docto        = tit_ap.cod_tit_ap                        
                          tt-ap.parcela         = tit_ap.cod_parcela                       
                          tt-ap.dt-vencimen     = tit_ap.dat_vencto_tit_ap    
                          tt-ap.dt-liquidac     = IF b_tit_ap.dat_liquidac = 12/31/9999 THEN ? ELSE b_tit_ap.dat_liquidac
                          tt-ap.dt-transacao    = tit_ap.dat_transacao      
                          tt-ap.valor-original  = tit_ap.val_origin_tit_ap
                          tt-ap.valor-saldo     = tit_ap.val_sdo_tit_ap      
                          tt-ap.cod-retencao    = compl_impto_retid_ap.cod_classif_impto 
                          tt-ap.valor-rendto    = compl_impto_retid_ap.val_rendto_tribut.
                END.
             END.
         END.
     END.
 END.


  
{&OPEN-QUERY-{&BROWSE-NAME}}  
  
IF SESSION:SET-WAIT-STATE("") THEN.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_salva_param C-Win 
PROCEDURE pi_salva_param :
ASSIGN INPUT FRAME f-relat c-arquivo
                           rs-destino
                           c-arquivo-2
                           rs-destino-2.
  RUN prgtec/btb/btb906za.p.    
  IF rs-destino  = 2 THEN
  DO.
    DO WHILE INDEX(c-arquivo,"~/") <> 0.
      ASSIGN c-arquivo = SUBSTR(c-arquivo,(INDEX(c-arquivo,"~/" ) + 1)).
    END.
  END.
  
  IF rs-destino-2  = 2 THEN
  DO.
    DO WHILE INDEX(c-arquivo-2,"~/") <> 0.
      ASSIGN c-arquivo-2 = SUBSTR(c-arquivo-2,(INDEX(c-arquivo-2,"~/" ) + 1)).
    END.
  END.
  

        /* Recuperar parÉmetros da £ltima execuá∆o */
  FIND dwb_set_list_param EXCLUSIVE-LOCK
       WHERE dwb_set_list_param.Cod_dwb_program = "esapb001"
         AND dwb_set_list_param.Cod_dwb_user    = v_Cod_usuar_corren 
       NO-ERROR.
    
  IF NOT AVAIL dwb_set_list_param 
  THEN CREATE dwb_set_list_param.
    
  ASSIGN dwb_set_list_param.Cod_dwb_program          = "esapb001"
         dwb_set_list_param.Cod_dwb_user             = v_Cod_usuar_corren
         dwb_set_list_param.Cod_dwb_file             = INPUT FRAME f-relat c-arquivo
         dwb_set_list_param.nom_dwb_printer          = c-impressora
         dwb_set_list_param.Cod_dwb_print_layout     = c-layout
         dwb_set_list_param.qtd_dwb_line             = 60
         dwb_set_list_param.Cod_dwb_parameters       = STRING(rs-destino-2) + chr(10) +
                                                              INPUT FRAME f-relat c-arquivo-2 + CHR(10) + 
                                                              c-impressora-2 + CHR(10) +
                                                              c-layout-2 + CHR(10)
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

