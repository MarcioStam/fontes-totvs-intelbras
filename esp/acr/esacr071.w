&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME esesb071
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS esesb071 
{include/i-prgvrs.i esacr071 2.00.00.000}


CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* GLOBAIS */
DEFINE NEW GLOBAL SHARED VARIABLE hBrowser           AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_rec_tit_acr      AS RECID NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_empres_usuar AS CHAR NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_empres_usuar AS CHARACTER format "x(3)":U label "Empresa" column-label "Empresa" no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario      AS CHARACTER   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_rec_tit_acr      AS RECID format ">>>>>>9" INITIAL ? NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-implanta         AS LOGICAL.
DEFINE NEW GLOBAL SHARED VARIABLE h-facelift         AS HANDLE NO-UNDO.

/* Local Variable Definitions --- */
DEFINE VARIABLE h-api                   AS HANDLE    NO-UNDO.
define variable wh-imprime              AS HANDLE    NO-UNDO.
DEFINE VARIABLE cTransacao              AS CHARACTER FORMAT "X(15)"  NO-UNDO.
DEFINE VARIABLE hprogramzoom            AS HANDLE    NO-UNDO.
DEFINE VARIABLE wh-pesquisa             AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-acomp                 AS HANDLE    NO-UNDO.
DEFINE VARIABLE i-cor                   AS INT       NO-UNDO.
DEFINE VARIABLE v_win_original_width    AS DECIMAL   NO-UNDO.
DEFINE VARIABLE v_win_original_height   AS DECIMAL   NO-UNDO.
DEFINE VARIABLE v_column                AS CHARACTER NO-UNDO.
DEFINE VARIABLE v_asc                   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE i-nr-total-titulos      AS INTEGER   NO-UNDO.

DEFINE VARIABLE v_dat_return            AS DATE        NO-UNDO.
DEFINE VARIABLE v_cod_return            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cod_finalid_econ      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_dat_fluxo             AS DATE        NO-UNDO.
DEFINE VARIABLE v_cod_pais_fornec_clien AS CHARACTER   NO-UNDO.

DEFINE STREAM s.
DEFINE STREAM r.

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(200)"
    FIELD ajuda    AS CHAR FORMAT "X(250)".

DEFINE TEMP-TABLE tt-int-pendencias-supcard LIKE int-pendencias-supcard.

DEFINE TEMP-TABLE tt-titulo
    FIELD flegado                   AS  LOG        COLUMN-LABEL "Marca" FORMAT "SIM/N«O"
    FIELD cdn_cliente               LIKE tit_acr.cdn_cliente  
    FIELD nom_abrev                 LIKE tit_acr.nom_abrev 
    FIELD cdn_clien_matriz          LIKE tit_acr.cdn_clien_matriz  
    FIELD cod_estab                 AS CHAR FORMAT "x(5)"      COLUMN-LABEL "Est"       
    FIELD cod_espec_docto           AS CHAR FORMAT "x(3)" COLUMN-LABEL "Esp"
    FIELD cod_ser_docto             AS CHAR FORMAT "x(5)" COLUMN-LABEL "Ser"
    FIELD cod_tit_acr               LIKE tit_acr.cod_tit_acr             
    FIELD cod_parcela               AS CHAR FORMAT "x(2)"  COLUMN-LABEL "Par"           
    FIELD dat_emis_docto            LIKE tit_acr.dat_emis_docto          
    FIELD dat_venco_origin_tit_acr  LIKE tit_acr.dat_vencto_origin_tit_acr 
    FIELD prazo-original            AS INTEGER COLUMN-LABEL "PrazoOrig"
    FIELD dat_vencto_tit_acr        LIKE tit_acr.dat_vencto_tit_acr      
    FIELD prazo_atual               AS INTEGER COLUMN-LABEL  "Prazo Atual"
    FIELD dt-entr-cli               LIKE nota-fiscal.dt-entr-cli             
    FIELD cod_indic_econ            LIKE tit_acr.cod_indic_econ          
    FIELD val_origin_tit_acr        LIKE tit_acr.val_origin_tit_acr      
    FIELD val_sdo_tit_acr           LIKE tit_acr.val_sdo_tit_acr         
    FIELD VENCTO-CALCULADO          AS DATE FORMAT "99/99/9999"  COLUMN-LABEL "VENCTO CALCULADO"
    FIELD PRAZO-CALCULADO           AS INTEGER                   COLUMN-LABEL "PRAZO CALCULADO"
    FIELD DIAS-PRORROGACAO          AS INTEGER                   COLUMN-LABEL "DIAS PRORROG"
    FIELD GRUPO-DDE                 AS LOG    FORMAT "SIM/N∆O"   COLUMN-LABEL "GRUPO DDE"
    FIELD DIA-SEMANA                AS CHAR                      COLUMN-LABEL "DIA SEMANA"
    FIELD DIA-MES                   AS INTEGER                   COLUMN-LABEL "DIA M“S"
    FIELD cod_portador              AS CHAR COLUMN-LABEL "Portador" FORMAT "x(5)"
    FIELD cod_cart_bcia             LIKE tit_acr.cod_cart_bcia 
    FIELD log_tit_acr_cobr_bcia     LIKE tit_acr.log_tit_acr_cobr_bcia 
    FIELD cod_tit_acr_bco           LIKE tit_acr.cod_tit_acr_bco 
    FIELD cod_grp_clien             LIKE tit_acr.cod_grp_clien
    FIELD cod-gr-cob                AS INTEGER                COLUMN-LABEL "Grupo Cobranáa"
    FIELD cor-linha                 AS INTEGER INIT 15 /*BRANCA*/
    FIELD vencto-fixo               AS INTEGER
    FIELD r-tit-acr                 AS RECID
    FIELD num_id_tit_acr            LIKE tit_acr.num_id_tit_acr
    FIELD cgc                       AS CHAR
    FIELD dat_prev_liquidac         LIKE tit_acr.dat_prev_liquidac
    FIELD dat_fluxo_tit_acr         LIKE tit_acr.dat_fluxo_tit_acr.

DEFINE TEMP-TABLE tt-cliente
    FIELD cod-emitente      AS INTEGER
    FIELD cgc-oito-posicoes AS CHAR
    FIELD cgc               AS CHAR
    FIELD prazo-DDE         LIKE int-cond-pag-cli.prazo-dde
    FIELD vencto-fixo       LIKE int-cond-pag-cli.vencto-fixo
    FIELD semana            LIKE int-cond-pag-cli.semana
    FIELD mes               LIKE int-cond-pag-cli.mes
    FIELD cod-gr-cli        AS INTEGER
    FIELD cod-gr-cob        AS INTEGER
    FIELD pais              AS CHAR.

DEFINE TEMP-TABLE tt-portador
    FIELD codigo   AS CHAR FORMAT "x(5)"
    FIELD nome     AS CHAR FORMAT "x(40)"
    FIELD carteira AS CHAR FORMAT "x(3)".

IF NOT VALID-HANDLE(h-facelift) THEN
    RUN btb/btb901zo.p PERSISTENT SET h-facelift.

{utp/ut-glob.i}
{esp\acr\esacr003tt.i}
{esp\acr\acr711zo.i}
{esp\acr\esacrapi002.i}
{esp\acr\esacr071.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME br-portador

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-portador tt-titulo

/* Definitions for BROWSE br-portador                                   */
&Scoped-define FIELDS-IN-QUERY-br-portador tt-portador.codigo tt-portador.carteira tt-portador.nome   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-portador   
&Scoped-define SELF-NAME br-portador
&Scoped-define QUERY-STRING-br-portador FOR EACH tt-portador
&Scoped-define OPEN-QUERY-br-portador OPEN QUERY {&SELF-NAME} FOR EACH tt-portador.
&Scoped-define TABLES-IN-QUERY-br-portador tt-portador
&Scoped-define FIRST-TABLE-IN-QUERY-br-portador tt-portador


/* Definitions for BROWSE br-titulo                                     */
&Scoped-define FIELDS-IN-QUERY-br-titulo tt-titulo.flegado tt-titulo.cdn_cliente tt-titulo.nom_abrev tt-titulo.cdn_clien_matriz tt-titulo.cod_estab tt-titulo.cod_espec_docto tt-titulo.cod_ser_docto tt-titulo.cod_tit_acr tt-titulo.cod_parcela tt-titulo.dat_emis_docto tt-titulo.dat_venco_origin_tit_acr tt-titulo.prazo-original tt-titulo.dat_vencto_tit_acr tt-titulo.prazo_atual tt-titulo.dt-entr-cli tt-titulo.cod_indic_econ tt-titulo.val_origin_tit_acr tt-titulo.val_sdo_tit_acr tt-titulo.VENCTO-CALCULADO tt-titulo.DIAS-PRORROGACAO tt-titulo.PRAZO-CALCULADO tt-titulo.GRUPO-DDE tt-titulo.DIA-SEMANA tt-titulo.DIA-MES tt-titulo.cod_portador tt-titulo.cod_cart_bcia tt-titulo.log_tit_acr_cobr_bcia tt-titulo.cod_tit_acr_bco tt-titulo.cod_grp_clien tt-titulo.cod-gr-cob tt-titulo.dat_prev_liquidac tt-titulo.dat_fluxo_tit_acr   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-titulo tt-titulo.flegado   
&Scoped-define ENABLED-TABLES-IN-QUERY-br-titulo tt-titulo
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br-titulo tt-titulo
&Scoped-define SELF-NAME br-titulo
&Scoped-define QUERY-STRING-br-titulo FOR EACH tt-titulo
&Scoped-define OPEN-QUERY-br-titulo OPEN QUERY {&SELF-NAME} FOR EACH tt-titulo.
&Scoped-define TABLES-IN-QUERY-br-titulo tt-titulo
&Scoped-define FIRST-TABLE-IN-QUERY-br-titulo tt-titulo


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-br-portador}~
    ~{&OPEN-QUERY-br-titulo}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tg-alt-prorrog tg-n-prorrog tg-prorrog ~
fi-portador fi-carteira bt-inclui br-portador bt-elimina rs-tipo fi-cliente ~
fi-nome BUTTON-1 fi-estab-ini fi-estab-fim fi-nf-ini fi-nf-fim fi-data-ini ~
fi-data-fim fi-vencto-ini fi-vencto-fim fi-gr-cob-ini fi-gr-cob-fim ~
fi-dias-prorrog-ini fi-dias-prorrog-fim bt-filtrar br-titulo bt-todos ~
bt-nenhum br-processa bt-ok bt-titutlo bt-cliente rt-button IMAGE-27 ~
IMAGE-28 IMAGE-33 IMAGE-34 IMAGE-39 IMAGE-40 IMAGE-41 IMAGE-42 IMAGE-43 ~
IMAGE-44 rt-button-2 RECT-2 RECT-4 RECT-5 RECT-7 RECT-8 RECT-9 RECT-10 ~
IMAGE-45 IMAGE-46 
&Scoped-Define DISPLAYED-OBJECTS tg-alt-prorrog tg-n-prorrog tg-prorrog ~
fi-portador fi-carteira rs-tipo fi-cliente fi-nome fil-1 fi-estab-ini ~
fi-estab-fim fi-nf-ini fi-nf-fim fi-data-ini fi-data-fim fi-vencto-ini ~
fi-vencto-fim fi-gr-cob-ini fi-gr-cob-fim fi-dias-prorrog-ini ~
fi-dias-prorrog-fim fil-2 fil-3 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDataProrrogadaDiaMES-bkp esesb071 
FUNCTION fnDataProrrogadaDiaMES-bkp RETURNS DATE
  ( INPUT p-vencto-orig AS DATE,
    INPUT p-dia-mes LIKE int-cond-pag-cli.mes)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDataProrrogadaDiaSEMANA-bkp esesb071 
FUNCTION fnDataProrrogadaDiaSEMANA-bkp RETURNS DATE
  ( INPUT p-vencto-orig AS DATE,
    INPUT p-dia-semana LIKE int-cond-pag-cli.semana)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnNomeDiaSemana esesb071 
FUNCTION fnNomeDiaSemana RETURNS CHARACTER
  ( INPUT p-dia AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn_ultimo_dia_util_mes esesb071 
FUNCTION fn_ultimo_dia_util_mes RETURNS LOG
  ( INPUT p-data AS DATE /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR esesb071 AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON br-processa 
     LABEL " Processar" 
     SIZE 15.57 BY 1.13
     FONT 0.

DEFINE BUTTON bt-cliente 
     IMAGE-UP FILE "adeicon/dog.bmp":U
     LABEL "Consulta Regras Cliente" 
     SIZE 6 BY 1.5 TOOLTIP "Consulta Regras Cliente".

DEFINE BUTTON bt-elimina 
     IMAGE-UP FILE "adeicon/cross.bmp":U
     LABEL "" 
     SIZE 3.86 BY .92.

DEFINE BUTTON bt-filtrar 
     IMAGE-UP FILE "adeicon/check.bmp":U
     LABEL "" 
     SIZE 7 BY 1.92 TOOLTIP "Buscar T°tulos".

DEFINE BUTTON bt-inclui 
     IMAGE-UP FILE "adeicon/check.bmp":U
     LABEL "INCLUI" 
     SIZE 3.86 BY .92.

DEFINE BUTTON bt-nenhum 
     LABEL "Nenhum" 
     SIZE 10 BY 1.13.

DEFINE BUTTON bt-ok AUTO-GO 
     IMAGE-UP FILE "adeicon/cueexit.bmp":U
     LABEL "&Fechar" 
     SIZE 4.29 BY 1.25 TOOLTIP "Sair do programa"
     BGCOLOR 8 .

DEFINE BUTTON bt-titutlo 
     IMAGE-UP FILE "adeicon/cue.ico":U
     LABEL "Consulta T°tulo" 
     SIZE 6 BY 1.5 TOOLTIP "Consultar T°tulo".

DEFINE BUTTON bt-todos 
     LABEL "Todos" 
     SIZE 10 BY 1.13.

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "image/excel.jpg":U
     LABEL "" 
     SIZE 6 BY 1.5 TOOLTIP "Exportar para arquivo".

DEFINE VARIABLE fi-carteira AS CHARACTER FORMAT "X(3)":U 
     LABEL "Carteira" 
     VIEW-AS FILL-IN 
     SIZE 8.72 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cliente AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10.43 BY .79 NO-UNDO.

DEFINE VARIABLE fi-data-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 12.72 BY .79 TOOLTIP "Data de Entrada da Solicitaá∆o (fim)" NO-UNDO.

DEFINE VARIABLE fi-data-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Emiss∆o" 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .79 TOOLTIP "Data de Entrada da Solicitaá∆o" NO-UNDO.

DEFINE VARIABLE fi-dias-prorrog-fim AS INTEGER FORMAT ">>9":U INITIAL 999 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79 NO-UNDO.

DEFINE VARIABLE fi-dias-prorrog-ini AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Dias Prorrog" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79 NO-UNDO.

DEFINE VARIABLE fi-estab-fim AS CHARACTER FORMAT "X(5)":U INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 7.72 BY .79 NO-UNDO.

DEFINE VARIABLE fi-estab-ini AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 8.43 BY .79 NO-UNDO.

DEFINE VARIABLE fi-gr-cob-fim AS INTEGER FORMAT ">>9":U INITIAL 999 
     VIEW-AS FILL-IN 
     SIZE 7.86 BY .79 NO-UNDO.

DEFINE VARIABLE fi-gr-cob-ini AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Grp. Cobr" 
     VIEW-AS FILL-IN 
     SIZE 8.43 BY .79 NO-UNDO.

DEFINE VARIABLE fi-nf-fim AS CHARACTER FORMAT "X(9)":U INITIAL "999999999" 
     VIEW-AS FILL-IN 
     SIZE 12.72 BY .79 NO-UNDO.

DEFINE VARIABLE fi-nf-ini AS CHARACTER FORMAT "X(9)":U 
     LABEL "Nota Fiscal" 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .79 NO-UNDO.

DEFINE VARIABLE fi-nome AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .79 NO-UNDO.

DEFINE VARIABLE fi-portador AS CHARACTER FORMAT "X(256)":U 
     LABEL "Portador" 
     VIEW-AS FILL-IN 
     SIZE 8.72 BY .79 NO-UNDO.

DEFINE VARIABLE fi-vencto-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/2050 
     VIEW-AS FILL-IN 
     SIZE 12.72 BY .79 TOOLTIP "Data de Entrada da Solicitaá∆o (fim)" NO-UNDO.

DEFINE VARIABLE fi-vencto-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Vencimento" 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .79 TOOLTIP "Data de Entrada da Solicitaá∆o" NO-UNDO.

DEFINE VARIABLE fil-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY .79
     BGCOLOR 7 FGCOLOR 7  NO-UNDO.

DEFINE VARIABLE fil-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY .79
     BGCOLOR 14 FGCOLOR 14  NO-UNDO.

DEFINE VARIABLE fil-3 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY .79
     BGCOLOR 15 FGCOLOR 15  NO-UNDO.

DEFINE IMAGE IMAGE-27
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-28
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-33
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-34
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-39
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-40
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-41
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-42
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-43
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-44
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-45
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-46
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE VARIABLE rs-tipo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Cliente", 1,
"Raiz CNPJ", 2
     SIZE 19 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 57 BY 6.75.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 25 BY 2.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 6.75.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 10.72 BY 6.83.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59 BY 2.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41.57 BY 6.75.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 20 BY 2.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 159 BY 1.46
     BGCOLOR 7 .

DEFINE RECTANGLE rt-button-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 159 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tg-alt-prorrog AS LOGICAL INITIAL yes 
     LABEL "Prorrogados com alteraá∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.

DEFINE VARIABLE tg-n-prorrog AS LOGICAL INITIAL yes 
     LABEL "N∆o prorrog†veis" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

DEFINE VARIABLE tg-prorrog AS LOGICAL INITIAL yes 
     LABEL "Prorrog†veis" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-portador FOR 
      tt-portador SCROLLING.

DEFINE QUERY br-titulo FOR 
      tt-titulo SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-portador
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-portador esesb071 _FREEFORM
  QUERY br-portador DISPLAY
      tt-portador.codigo            COLUMN-LABEL "C¢digo"  WIDTH 6
      tt-portador.carteira          COLUMN-LABEL "Carteira" 
      tt-portador.nome              COLUMN-LABEL "nome"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 34 BY 4.92
         FONT 1
         TITLE "Portador" ROW-HEIGHT-CHARS .5 FIT-LAST-COLUMN TOOLTIP "Portador".

DEFINE BROWSE br-titulo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-titulo esesb071 _FREEFORM
  QUERY br-titulo DISPLAY
      tt-titulo.flegado                  COLUMN-LABEL "Marcar"  WIDTH 5 VIEW-AS TOGGLE-BOX 
    tt-titulo.cdn_cliente                COLUMN-LABEL "Cliente" WIDTH 6 
    tt-titulo.nom_abrev                  COLUMN-LABEL "Nome"         
    tt-titulo.cdn_clien_matriz           COLUMN-LABEL "Matriz"  WIDTH 6                          
    tt-titulo.cod_estab                  COLUMN-LABEL "Est" WIDTH 3.5
    tt-titulo.cod_espec_docto            COLUMN-LABEL "Esp" WIDTH 4    
    tt-titulo.cod_ser_docto              COLUMN-LABEL "SÇr"   WIDTH 3.5
    tt-titulo.cod_tit_acr                COLUMN-LABEL "T°tulo"   
    tt-titulo.cod_parcela                COLUMN-LABEL "Par" WIDTH 3.5  
    tt-titulo.dat_emis_docto             COLUMN-LABEL "Emiss∆o"   
    tt-titulo.dat_venco_origin_tit_acr   COLUMN-LABEL "VenctoOrig" 
    tt-titulo.prazo-original             COLUMN-LABEL "PrazoOrig"    
    tt-titulo.dat_vencto_tit_acr         COLUMN-LABEL "VenctoAtual"  
    tt-titulo.prazo_atual                COLUMN-LABEL "PrazoAtual"   
    tt-titulo.dt-entr-cli                COLUMN-LABEL "Entrega"   
    tt-titulo.cod_indic_econ             COLUMN-LABEL "Moeda"  
    tt-titulo.val_origin_tit_acr         COLUMN-LABEL "Vl Orig" WIDTH 7
    tt-titulo.val_sdo_tit_acr            COLUMN-LABEL "Saldo" WIDTH 7.5
    tt-titulo.VENCTO-CALCULADO           COLUMN-LABEL "Vencto Calculado"
    tt-titulo.DIAS-PRORROGACAO           COLUMN-LABEL "Dias Prorrogaá∆o"        
    tt-titulo.PRAZO-CALCULADO            COLUMN-LABEL "Prazo Calculado" 
    tt-titulo.GRUPO-DDE                  COLUMN-LABEL "DDE"        
    tt-titulo.DIA-SEMANA                 COLUMN-LABEL "Dia Semana"        
    tt-titulo.DIA-MES                    COLUMN-LABEL "Dia Màs"        
    tt-titulo.cod_portador               COLUMN-LABEL "Portador" WIDTH 9 FORMAT "x(5)"            
    tt-titulo.cod_cart_bcia              COLUMN-LABEL "Carteira"              
    tt-titulo.log_tit_acr_cobr_bcia      COLUMN-LABEL "Escritural"              
    tt-titulo.cod_tit_acr_bco            COLUMN-LABEL "Nro.Banc†rio"              
    tt-titulo.cod_grp_clien              COLUMN-LABEL "Grupo Cliente"              
    tt-titulo.cod-gr-cob                 COLUMN-LABEL "Grupo Cobranáa"
    tt-titulo.dat_prev_liquidac          COLUMN-LABEL "Dt PrÇvia liq" 
    tt-titulo.dat_fluxo_tit_acr           COLUMN-LABEL "Dt Fluxo"

    ENABLE tt-titulo.flegado
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 159 BY 11.5
         FONT 1
         TITLE "T°tulos" ROW-HEIGHT-CHARS .67 FIT-LAST-COLUMN TOOLTIP "T°tulos".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     tg-alt-prorrog AT ROW 8 COL 47 WIDGET-ID 374
     tg-n-prorrog AT ROW 6.5 COL 47 WIDGET-ID 370
     tg-prorrog AT ROW 7.25 COL 47 WIDGET-ID 372
     fi-portador AT ROW 3.42 COL 9.14 COLON-ALIGNED WIDGET-ID 346
     fi-carteira AT ROW 3.42 COL 26.86 COLON-ALIGNED WIDGET-ID 362
     bt-inclui AT ROW 3.38 COL 38.72 WIDGET-ID 348
     br-portador AT ROW 4.33 COL 3.57 WIDGET-ID 300
     bt-elimina AT ROW 8.25 COL 38.57 WIDGET-ID 350
     rs-tipo AT ROW 3.25 COL 46.43 NO-LABEL WIDGET-ID 354
     fi-cliente AT ROW 4.25 COL 44 COLON-ALIGNED NO-LABEL WIDGET-ID 126
     fi-nome AT ROW 4.25 COL 54.86 COLON-ALIGNED NO-LABEL WIDGET-ID 360
     fil-1 AT ROW 22.67 COL 57.43 COLON-ALIGNED NO-LABEL WIDGET-ID 334
     BUTTON-1 AT ROW 22.08 COL 147.86 WIDGET-ID 310
     fi-estab-ini AT ROW 3.38 COL 116.72 COLON-ALIGNED WIDGET-ID 262
     fi-estab-fim AT ROW 3.38 COL 133 COLON-ALIGNED NO-LABEL WIDGET-ID 260
     fi-nf-ini AT ROW 4.38 COL 112.72 COLON-ALIGNED WIDGET-ID 270
     fi-nf-fim AT ROW 4.38 COL 133 COLON-ALIGNED NO-LABEL WIDGET-ID 278
     fi-data-ini AT ROW 5.38 COL 112.72 COLON-ALIGNED WIDGET-ID 190
     fi-data-fim AT ROW 5.38 COL 133 COLON-ALIGNED NO-LABEL WIDGET-ID 192
     fi-vencto-ini AT ROW 6.38 COL 112.72 COLON-ALIGNED WIDGET-ID 282
     fi-vencto-fim AT ROW 6.38 COL 133 COLON-ALIGNED NO-LABEL WIDGET-ID 280
     fi-gr-cob-ini AT ROW 7.38 COL 116.72 COLON-ALIGNED WIDGET-ID 160
     fi-gr-cob-fim AT ROW 7.38 COL 132.86 COLON-ALIGNED NO-LABEL WIDGET-ID 162
     fi-dias-prorrog-ini AT ROW 8.38 COL 113.43 COLON-ALIGNED WIDGET-ID 376
     fi-dias-prorrog-fim AT ROW 8.38 COL 133 COLON-ALIGNED NO-LABEL WIDGET-ID 378
     bt-filtrar AT ROW 5.5 COL 152 HELP
          "Buscar T°tulos" WIDGET-ID 132
     br-titulo AT ROW 10 COL 2 WIDGET-ID 200
     bt-todos AT ROW 22.42 COL 3.29 WIDGET-ID 292
     bt-nenhum AT ROW 22.42 COL 15.29 WIDGET-ID 294
     br-processa AT ROW 24.21 COL 74.57 WIDGET-ID 244
     bt-ok AT ROW 1.13 COL 156.14 HELP
          "Sair do programa" WIDGET-ID 242
     bt-titutlo AT ROW 22.08 COL 141.57 WIDGET-ID 312
     fil-2 AT ROW 22.67 COL 89.43 COLON-ALIGNED NO-LABEL WIDGET-ID 336
     fil-3 AT ROW 22.67 COL 74.86 COLON-ALIGNED NO-LABEL WIDGET-ID 338
     bt-cliente AT ROW 22.08 COL 154.14 HELP
          "Consulta Regras Cliente" WIDGET-ID 368
     "Prorrogaá∆o Vencimentos" VIEW-AS TEXT
          SIZE 17.86 BY .67 AT ROW 1.42 COL 73.43 WIDGET-ID 122
          BGCOLOR 15 FGCOLOR 0 FONT 1
     "Seleá∆o:" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 2.75 COL 104 WIDGET-ID 364
     "Legenda linhas (t°tulos):" VIEW-AS TEXT
          SIZE 17.14 BY .54 AT ROW 21.67 COL 58.14 WIDGET-ID 324
     "Exceá‰es FLOAT:" VIEW-AS TEXT
          SIZE 13 BY .54 AT ROW 2.75 COL 3 WIDGET-ID 344
     "Prorrogados com Alteraá∆o" VIEW-AS TEXT
          SIZE 20.14 BY .54 AT ROW 22.79 COL 95.29 WIDGET-ID 326
     "Prorrog†veis" VIEW-AS TEXT
          SIZE 9.14 BY .54 AT ROW 22.79 COL 80.72 WIDGET-ID 340
     "Selecionar T°tulos:" VIEW-AS TEXT
          SIZE 13 BY .54 AT ROW 21.63 COL 3 WIDGET-ID 298
     "ParÉmetros:" VIEW-AS TEXT
          SIZE 8.57 BY .54 AT ROW 2.75 COL 48 WIDGET-ID 304
     "Obs: N∆o informando Cliente ou CNPJ, todos os emitentes ser∆o considerados." VIEW-AS TEXT
          SIZE 53.29 BY 1 AT ROW 5.25 COL 46 WIDGET-ID 366
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 160.57 BY 24.58
         BGCOLOR 15 FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME f-cad
     "N∆o Prorrog†veis" VIEW-AS TEXT
          SIZE 13 BY .54 AT ROW 22.79 COL 63.14 WIDGET-ID 322
     rt-button AT ROW 1 COL 2
     IMAGE-27 AT ROW 7.33 COL 127.57 WIDGET-ID 164
     IMAGE-28 AT ROW 7.33 COL 131.57 WIDGET-ID 166
     IMAGE-33 AT ROW 5.33 COL 127.57 WIDGET-ID 196
     IMAGE-34 AT ROW 5.33 COL 131.72 WIDGET-ID 198
     IMAGE-39 AT ROW 3.33 COL 127.57 WIDGET-ID 264
     IMAGE-40 AT ROW 3.33 COL 131.72 WIDGET-ID 266
     IMAGE-41 AT ROW 4.33 COL 127.57 WIDGET-ID 274
     IMAGE-42 AT ROW 4.33 COL 131.72 WIDGET-ID 276
     IMAGE-43 AT ROW 6.33 COL 127.57 WIDGET-ID 284
     IMAGE-44 AT ROW 6.33 COL 131.72 WIDGET-ID 286
     rt-button-2 AT ROW 24.04 COL 2 WIDGET-ID 290
     RECT-2 AT ROW 21.88 COL 2 WIDGET-ID 296
     RECT-4 AT ROW 3 COL 103 WIDGET-ID 302
     RECT-5 AT ROW 2.92 COL 150.14 WIDGET-ID 306
     RECT-7 AT ROW 21.83 COL 56.86 WIDGET-ID 320
     RECT-8 AT ROW 3 COL 2 WIDGET-ID 342
     RECT-9 AT ROW 21.83 COL 140.86 WIDGET-ID 352
     RECT-10 AT ROW 3 COL 44.86 WIDGET-ID 358
     IMAGE-45 AT ROW 8.33 COL 131.57 WIDGET-ID 380
     IMAGE-46 AT ROW 8.33 COL 127.57 WIDGET-ID 382
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 160.57 BY 24.58
         BGCOLOR 15 FONT 1.


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
  CREATE WINDOW esesb071 ASSIGN
         HIDDEN             = YES
         TITLE              = "Prorrogaá∆o Vencimentos"
         HEIGHT             = 24.71
         WIDTH              = 160.57
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB esesb071 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-incsim.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW esesb071
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB br-portador bt-inclui f-cad */
/* BROWSE-TAB br-titulo bt-filtrar f-cad */
ASSIGN 
       br-portador:COLUMN-RESIZABLE IN FRAME f-cad       = TRUE.

ASSIGN 
       br-titulo:NUM-LOCKED-COLUMNS IN FRAME f-cad     = 15
       br-titulo:COLUMN-RESIZABLE IN FRAME f-cad       = TRUE.

ASSIGN 
       fi-nome:READ-ONLY IN FRAME f-cad        = TRUE.

/* SETTINGS FOR FILL-IN fil-1 IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fil-2 IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fil-3 IN FRAME f-cad
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(esesb071)
THEN esesb071:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-portador
/* Query rebuild information for BROWSE br-portador
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-portador
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-portador */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-titulo
/* Query rebuild information for BROWSE br-titulo
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-titulo
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-titulo */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME esesb071
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL esesb071 esesb071
ON END-ERROR OF esesb071 /* Prorrogaá∆o Vencimentos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL esesb071 esesb071
ON WINDOW-CLOSE OF esesb071 /* Prorrogaá∆o Vencimentos */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-portador
&Scoped-define SELF-NAME br-portador
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-portador esesb071
ON START-SEARCH OF br-portador IN FRAME f-cad /* Portador */
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


&Scoped-define SELF-NAME br-processa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-processa esesb071
ON CHOOSE OF br-processa IN FRAME f-cad /*  Processar */
DO:
     RUN pi-processar.

     RUN pi-resultado-processo.

     APPLY "choose" TO bt-filtrar IN FRAME f-cad.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-titulo
&Scoped-define SELF-NAME br-titulo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-titulo esesb071
ON MOUSE-SELECT-DBLCLICK OF br-titulo IN FRAME f-cad /* T°tulos */
DO:

    IF  NOT AVAIL tt-titulo 
    OR  AVAIL tt-titulo AND tt-titulo.cor-linha = 8 THEN
        RETURN NO-APPLY.

    IF  tt-titulo.flegado THEN 
        ASSIGN tt-titulo.flegado         = NO
               tt-titulo.flegado:CHECKED IN BROWSE br-titulo = NO.
    ELSE
        ASSIGN tt-titulo.flegado         = YES
               tt-titulo.flegado:CHECKED IN BROWSE br-titulo = YES.

    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-titulo esesb071
ON ROW-DISPLAY OF br-titulo IN FRAME f-cad /* T°tulos */
DO:

    IF  NOT AVAIL tt-titulo THEN
        RETURN "OK".

    ASSIGN tt-titulo.vencto-calculado:BGCOLOR IN BROWSE br-titulo = 11
           tt-titulo.vencto-calculado:FGCOLOR IN BROWSE br-titulo = 0     
           tt-titulo.DIAS-PRORROGACAO:BGCOLOR IN BROWSE br-titulo = 11.
           tt-titulo.DIAS-PRORROGACAO:FGCOLOR IN BROWSE br-titulo = 0.

    /* Vencimento proposto igual ao atual*/
    RUN pi-muda-cor-linha (tt-titulo.cor-linha).

    DISABLE tt-titulo.flegado.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-titulo esesb071
ON ROW-ENTRY OF br-titulo IN FRAME f-cad /* T°tulos */
DO:
    /* Vencimento proposto igual ao atual*/
    
    IF  AVAIL tt-titulo AND tt-titulo.cor-linha = 8 THEN DO:
        ASSIGN tt-titulo.flegado = NO.
        RETURN NO-APPLY.
    END.

     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-titulo esesb071
ON START-SEARCH OF br-titulo IN FRAME f-cad /* T°tulos */
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


&Scoped-define SELF-NAME bt-cliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cliente esesb071
ON CHOOSE OF bt-cliente IN FRAME f-cad /* Consulta Regras Cliente */
DO:
    RUN esp/acr/esacr070.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-elimina
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-elimina esesb071
ON CHOOSE OF bt-elimina IN FRAME f-cad
DO:
  IF  AVAIL tt-portador THEN DO:

      FIND ponto-programa NO-LOCK
          WHERE ponto-programa.nome-programa = "esacr071"
            AND ponto-programa.ponto         = 1 NO-ERROR.

      IF  AVAIL ponto-programa THEN DO TRANS:
          FIND conteudo-programa EXCLUSIVE-LOCK
               WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa 
                 AND entry(1,conteudo-programa.conteudo,";") = tt-portador.codigo
                 AND entry(2,conteudo-programa.conteudo,";") = tt-portador.carteira NO-ERROR.

          IF  AVAIL conteudo-programa THEN
              DELETE conteudo-programa.

          DELETE tt-portador.
          FOR EACH conteudo-programa EXCLUSIVE-LOCK
               WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
              DELETE conteudo-programa.
          END.
          DEF  VAR i AS INTEGER INIT 10 NO-UNDO.
          FOR EACH tt-portador:
              CREATE conteudo-programa.
              ASSIGN conteudo-programa.cod-programa = ponto-programa.cod-programa
                     conteudo-programa.sequencia    = i
                     conteudo-programa.conteudo     = tt-portador.codigo + ";" + tt-portador.carteira
                     i                              = i + 10.
          END.

          {&OPEN-QUERY-br-portador}
      END.
      
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-filtrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-filtrar esesb071
ON CHOOSE OF bt-filtrar IN FRAME f-cad
DO:
    RUN pi-carrega-titulos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-inclui
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-inclui esesb071
ON CHOOSE OF bt-inclui IN FRAME f-cad /* INCLUI */
DO:
  
    DEF VAR i-seq AS INTEGER NO-UNDO.

    FIND emscad.portador NO-LOCK
        WHERE emscad.portador.cod_portador = fi-portador:SCREEN-VALUE IN FRAME f-cad NO-ERROR.
    IF  NOT AVAIL emscad.portador THEN DO:
        RUN utp/ut-msgs.p ("SHOW",
                           17006,
                           "Portador inexistente.").
        RETURN NO-APPLY.
    END.

    FIND cart_bcia
        WHERE cart_bcia.cod_cart_bcia = fi-carteira:SCREEN-VALUE IN FRAME f-cad NO-ERROR.
    IF  NOT AVAIL cart_bcia THEN DO:
        RUN utp/ut-msgs.p ("SHOW",
                           17006,
                           "Carteira Banc†ria inv†lida.").
        RETURN NO-APPLY.
    END.


    FIND tt-portador
        WHERE tt-portador.codigo   = fi-portador:SCREEN-VALUE IN FRAME f-cad 
          AND tt-portador.carteira = fi-carteira:SCREEN-VALUE IN FRAME f-cad NO-ERROR.
    
    IF  AVAIL tt-portador THEN DO:
        RUN utp/ut-msgs.p ("SHOW",
                           17006,
                           "Portador/Carteira j† cadastrados como exceá∆o Float.").
        RETURN NO-APPLY.
    END.
    ELSE DO TRANS:
        CREATE tt-portador.
        ASSIGN tt-portador.codigo   = fi-portador:SCREEN-VALUE IN FRAME f-cad
               tt-portador.nome     = emscad.portador.nom_pessoa
               tt-portador.carteira = fi-carteira:SCREEN-VALUE IN FRAME f-cad.

        FIND FIRST ponto-programa NO-LOCK
            WHERE ponto-programa.nome-programa = "esacr071"
              AND ponto-programa.ponto         = 1 NO-ERROR.

        FOR LAST conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa 
               BY conteudo-programa.sequencia:
        END.
        IF  AVAIL conteudo-programa THEN
            ASSIGN i-seq = conteudo-programa.sequencia + 10.
        ELSE
            ASSIGN i-seq = 10.

        FIND conteudo-programa EXCLUSIVE-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa 
              AND ENTRY(1,conteudo-programa.conteudo,";") = fi-portador:SCREEN-VALUE IN FRAME f-cad 
              AND ENTRY(2,conteudo-programa.conteudo,";") = fi-carteira:SCREEN-VALUE IN FRAME f-cad NO-ERROR.

        IF  NOT AVAILABLE conteudo-programa THEN DO:
            CREATE conteudo-programa.
            ASSIGN conteudo-programa.cod-programa = ponto-programa.cod-programa
                   conteudo-programa.sequencia    = i-seq.
        END.

        ASSIGN conteudo-programa.conteudo = tt-portador.codigo + ";" + tt-portador.carteira.

        {&OPEN-QUERY-br-portador}

    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-nenhum
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-nenhum esesb071
ON CHOOSE OF bt-nenhum IN FRAME f-cad /* Nenhum */
DO:
  FOR EACH tt-titulo:
      ASSIGN tt-titulo.flegado = NO.
  END.

  {&open-query-br-titulo}

  APPLY "value-changed" TO br-titulo IN FRAME f-cad.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok esesb071
ON CHOOSE OF bt-ok IN FRAME f-cad /* Fechar */
DO:
  RUN notify ('update-record':U).
  if return-value <> "adm-error":U then
     apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-titutlo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-titutlo esesb071
ON CHOOSE OF bt-titutlo IN FRAME f-cad /* Consulta T°tulo */
DO:

     IF  NOT AVAIL tt-titulo THEN
         RETURN "OK".

     ASSIGN v_rec_tit_acr = tt-titulo.r-tit-acr.
      
     RUN prgfin/acr/acr212aa.p.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-todos esesb071
ON CHOOSE OF bt-todos IN FRAME f-cad /* Todos */
DO:
  
  FOR EACH tt-titulo
      WHERE tt-titulo.cor-linha <> 8 :
      ASSIGN tt-titulo.flegado = YES.
  END.

  {&open-query-br-titulo}

  APPLY "value-changed" TO br-titulo IN FRAME f-cad.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 esesb071
ON CHOOSE OF BUTTON-1 IN FRAME f-cad
DO:
    DEF VAR c-arquivo AS CHAR NO-UNDO.

    ASSIGN c-arquivo = SESSION:TEMP-DIR + 'listarcampos_' + STRING(DAY(TODAY)) 
                       + '_' + STRING(MONTH(TODAY)) + '_' + STRING(YEAR(TODAY)) 
                       + STRING(TIME) + '.csv'.

    RUN pi-exporta-excel (INPUT c-arquivo, br-titulo:HANDLE).   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cliente esesb071
ON F5 OF fi-cliente IN FRAME f-cad
DO:

      {include/zoomvar.i &prog-zoom="adzoom/z01ad098"
                       &campo="fi-cliente"
                       &campozoom="cod-emitente"
                       &campo2="fi-nome"
                       &campozoom2="nome-emit"
                       &frame="f-cad"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cliente esesb071
ON LEAVE OF fi-cliente IN FRAME f-cad
DO:


     IF  rs-tipo:SCREEN-VALUE IN FRAME f-cad = "1" THEN DO:
        IF  int(fi-cliente:SCREEN-VALUE IN FRAME f-cad) <> 0  THEN DO:
        
            FIND emitente NO-LOCK
                WHERE emitente.cod-emitente = int(fi-cliente:SCREEN-VALUE IN FRAME f-cad) NO-ERROR.
            IF  NOT AVAIL emitente THEN DO:
                RUN utp\ut-msgs.p ("show",
                                   17006,
                                   "Emitente n∆o cadastrado com este c¢digo").
                RETURN "OK".
            END.
            ASSIGN fi-nome:SCREEN-VALUE IN FRAME f-cad = emitente.nome-emit.
        END.
        ELSE
            ASSIGN fi-nome:SCREEN-VALUE IN FRAME f-cad = "Todos".
    END.

    
    IF  rs-tipo:SCREEN-VALUE IN FRAME f-cad = "2" THEN DO:
        IF  int(fi-cliente:SCREEN-VALUE IN FRAME f-cad) <> 0  THEN DO:
            FIND emitente NO-LOCK
                WHERE substr(emitente.cgc,1,8) = fi-cliente:SCREEN-VALUE IN FRAME f-cad NO-ERROR.
            IF  NOT AVAIL emitente THEN DO:
                RUN utp\ut-msgs.p ("show",
                                   17006,
                                   "Emitente n∆o cadastrado para esse CNPJ").
                RETURN "OK".
            END.
            ASSIGN fi-nome:SCREEN-VALUE IN FRAME f-cad = emitente.nome-emit.
        END.
        ELSE
            ASSIGN fi-nome:SCREEN-VALUE IN FRAME f-cad = "Todos".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cliente esesb071
ON MOUSE-SELECT-DBLCLICK OF fi-cliente IN FRAME f-cad
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-estab-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-estab-fim esesb071
ON MOUSE-SELECT-DBLCLICK OF fi-estab-fim IN FRAME f-cad
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-estab-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-estab-ini esesb071
ON MOUSE-SELECT-DBLCLICK OF fi-estab-ini IN FRAME f-cad /* Estabelecimento */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-nf-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nf-fim esesb071
ON MOUSE-SELECT-DBLCLICK OF fi-nf-fim IN FRAME f-cad
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-nf-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nf-ini esesb071
ON MOUSE-SELECT-DBLCLICK OF fi-nf-ini IN FRAME f-cad /* Nota Fiscal */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-portador
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK esesb071 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects esesb071  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available esesb071  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI esesb071  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(esesb071)
  THEN DELETE WIDGET esesb071.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI esesb071  _DEFAULT-ENABLE
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
  DISPLAY tg-alt-prorrog tg-n-prorrog tg-prorrog fi-portador fi-carteira rs-tipo 
          fi-cliente fi-nome fil-1 fi-estab-ini fi-estab-fim fi-nf-ini fi-nf-fim 
          fi-data-ini fi-data-fim fi-vencto-ini fi-vencto-fim fi-gr-cob-ini 
          fi-gr-cob-fim fi-dias-prorrog-ini fi-dias-prorrog-fim fil-2 fil-3 
      WITH FRAME f-cad IN WINDOW esesb071.
  ENABLE tg-alt-prorrog tg-n-prorrog tg-prorrog fi-portador fi-carteira 
         bt-inclui br-portador bt-elimina rs-tipo fi-cliente fi-nome BUTTON-1 
         fi-estab-ini fi-estab-fim fi-nf-ini fi-nf-fim fi-data-ini fi-data-fim 
         fi-vencto-ini fi-vencto-fim fi-gr-cob-ini fi-gr-cob-fim 
         fi-dias-prorrog-ini fi-dias-prorrog-fim bt-filtrar br-titulo bt-todos 
         bt-nenhum br-processa bt-ok bt-titutlo bt-cliente rt-button IMAGE-27 
         IMAGE-28 IMAGE-33 IMAGE-34 IMAGE-39 IMAGE-40 IMAGE-41 IMAGE-42 
         IMAGE-43 IMAGE-44 rt-button-2 RECT-2 RECT-4 RECT-5 RECT-7 RECT-8 
         RECT-9 RECT-10 IMAGE-45 IMAGE-46 
      WITH FRAME f-cad IN WINDOW esesb071.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW esesb071.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy esesb071 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  IF  VALID-HANDLE(h-api) THEN
      RUN pi-destroy IN h-api.


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit esesb071 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize esesb071 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  
  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}

  {utp/ut9000.i "ESACR071" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  RUN dispatch  IN this-procedure ('enable-fields':U).

/*   APPLY 'value-changed'      TO br-canais IN FRAME f-cad.  */
  
  ASSIGN fi-data-ini:SCREEN-VALUE IN FRAME f-cad   = STRING(TODAY)
         fi-data-fim:SCREEN-VALUE IN FRAME f-cad   = STRING(TODAY)
         fi-vencto-ini:SCREEN-VALUE IN FRAME f-cad = STRING(DATE(month(today),01, YEAR(TODAY))).

  FIND FIRST ponto-programa NO-LOCK                                                  
      WHERE ponto-programa.nome-programa = "esacr071"                                
        AND ponto-programa.ponto         = 1 NO-ERROR.                               
                                                                                     
  IF  AVAIL ponto-programa THEN DO:
      FOR EACH conteudo-programa NO-LOCK
          WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

          FIND emscad.portador NO-LOCK
              WHERE emscad.portador.cod_portador = entry(1,conteudo-programa.conteudo, ";") NO-ERROR.

          IF  AVAIL emscad.portador THEN DO:
              CREATE tt-portador.
              ASSIGN tt-portador.codigo   = entry(1,conteudo-programa.conteudo, ";")
                     tt-portador.nome     = IF AVAIL portador THEN portador.nom_pessoa ELSE ""
                     tt-portador.carteira = ENTRY(2,conteudo-programa.conteudo, ";").
          END.

      END.
      
  END.

  ASSIGN fi-nome:SCREEN-VALUE IN FRAME f-cad = "Todos".

  {&OPEN-QUERY-br-portador}
 
  {include/i-inifld.i}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-Altera-Titulo esesb071 
PROCEDURE pi-Altera-Titulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF OUTPUT PARAM p-ok AS LOG NO-UNDO.

    run prgfin/acr/acr711zo.py (Input 4,
                                Input  table tt_alter_tit_acr_base_2,
                                Input  table tt_alter_tit_acr_rateio,
                                Input  table tt_alter_tit_acr_ped_vda,
                                Input  table tt_alter_tit_acr_comis,
                                Input  table tt_alter_tit_acr_cheq,
                                Input  table tt_alter_tit_acr_iva,
                                Input  table tt_alter_tit_acr_impto_retid_2,
                                Input  table tt_alter_tit_acr_cobr_espec_2,
                                Input  table tt_alter_tit_acr_rat_desp_rec,
                                output table tt_log_erros_alter_tit_acr,
                                Input no).

    EMPTY TEMP-TABLE  tt_alter_tit_acr_base_2. 

    ASSIGN p-ok = YES.
    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-titulos esesb071 
PROCEDURE pi-carrega-titulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR i-tipo-benef        AS INTEGER NO-UNDO.
    DEF VAR i-canal             AS INTEGER NO-UNDO.
    DEF VAR c-forma-pagto       AS CHAR    NO-UNDO.
    DEF VAR de-vl-aprovado      AS DEC     NO-UNDO.
    DEF VAR l-tipo              AS LOG     NO-UNDO.
    DEF VAR l-enviada           AS LOG     NO-UNDO.
    DEF VAR da-vencto-calculado AS DATE    NO-UNDO.
    DEF VAR l-todos             AS LOG     INIT YES NO-UNDO.
    DEF VAR i-emitente          AS INTEGER NO-UNDO.
    DEF VAR h-acomp             AS HANDLE  NO-UNDO.
    DEF VAR da-prev-liquid      AS DATE    NO-UNDO.
    DEF VAR da-fluxo            AS DATE    NO-UNDO.
    DEF VAR l-ultimo-dia-mes    AS LOG     NO-UNDO.
    DEF VAR i-atraso            AS INT     NO-UNDO.
    DEF VAR da-ent-prev         AS DATE    NO-UNDO.

    DEF BUFFER b-matriz       FOR emitente.
    DEF BUFFER b-emit         FOR emitente.
    DEF BUFFER b-int-emitente FOR int-emitente.
    DEF BUFFER b-tt-portador  FOR tt-portador.

    EMPTY TEMP-TABLE tt-titulo.
    EMPTY TEMP-TABLE tt-cliente.

    IF  rs-tipo:SCREEN-VALUE IN FRAME f-cad = "1" THEN DO:
        IF  int(fi-cliente:SCREEN-VALUE IN FRAME f-cad) <> 0  THEN DO:
        
            FIND emitente NO-LOCK
                WHERE emitente.cod-emitente = int(fi-cliente:SCREEN-VALUE IN FRAME f-cad) NO-ERROR.
            IF  NOT AVAIL emitente THEN DO:
                RUN utp\ut-msgs.p ("show",
                                   17006,
                                   "Emitente n∆o cadastrado com este c¢digo").
                RETURN "OK".
            END.
            ASSIGN fi-nome:SCREEN-VALUE IN FRAME f-cad = emitente.nome-emit
                   i-emitente = emitente.cod-emitente
                   l-todos = NO.
        END.
    END.

    IF  rs-tipo:SCREEN-VALUE IN FRAME f-cad = "2" THEN DO:
        IF  int(fi-cliente:SCREEN-VALUE IN FRAME f-cad) <> 0  THEN DO:
            FIND emitente NO-LOCK
                WHERE substr(emitente.cgc,1,8) = fi-cliente:SCREEN-VALUE IN FRAME f-cad NO-ERROR.
            IF  NOT AVAIL emitente THEN DO:
                RUN utp\ut-msgs.p ("show",
                                   17006,
                                   "Emitente n∆o cadastrado para esse CNPJ").
                RETURN "OK".
            END.
            ASSIGN fi-nome:SCREEN-VALUE IN FRAME f-cad = emitente.nome-emit
                   i-emitente = emitente.cod-emitente
                   l-todos = NO.
        END.
    END.

    IF  NOT VALID-HANDLE(h-acomp) THEN DO:
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.                      
        RUN pi-inicializar IN h-acomp (INPUT "Filtrando...").
        RUN pi-acompanhar IN h-acomp (INPUT "Selecionando Clientes...").
    END.

    IF  l-todos THEN DO:

        FOR EACH int-cond-pag-cli NO-LOCK:
            FIND emitente NO-LOCK
                WHERE emitente.cod-emitente = int-cond-pag-cli.cod-emitente NO-ERROR.
    
            IF  NOT AVAIL emitente THEN
                NEXT.

            IF  int-cond-pag-cli.grupo-econ THEN DO:
                FIND b-matriz NO-LOCK
                    WHERE b-matriz.nome-abrev = emitente.nome-matriz NO-ERROR.
                FOR EACH emitente NO-LOCK
                    WHERE emitente.nome-matriz = b-matriz.nome-abrev.
                    FIND tt-cliente
                        WHERE tt-cliente.cod-emitente = emitente.cod-emitente NO-ERROR.
                    IF  NOT AVAIL tt-cliente THEN DO:
                        CREATE tt-cliente.
                        ASSIGN tt-cliente.cod-emitente      = emitente.cod-emitente
                               tt-cliente.cgc               = emitente.cgc
                               tt-cliente.cgc-oito-posicoes = SUBSTR(emitente.cgc,1,8)
                               tt-cliente.prazo-DDE         = int-cond-pag-cli.prazo-DDE
                               tt-cliente.vencto-fixo       = int-cond-pag-cli.vencto-fixo
                               tt-cliente.semana            = int-cond-pag-cli.semana
                               tt-cliente.mes               = int-cond-pag-cli.mes
                               tt-cliente.cod-gr-cli        = emitente.cod-gr-cli
                               tt-cliente.pais              = emitente.pais.
                    END.
                END.
            END.
            ELSE DO:
                FIND tt-cliente
                    WHERE tt-cliente.cod-emitente = emitente.cod-emitente NO-ERROR.
                IF  NOT AVAIL tt-cliente THEN DO:
                    CREATE tt-cliente.
                    ASSIGN tt-cliente.cod-emitente      = emitente.cod-emitente
                           tt-cliente.cgc               = emitente.cgc
                           tt-cliente.cgc-oito-posicoes = SUBSTR(emitente.cgc,1,8)
                           tt-cliente.prazo-DDE         = int-cond-pag-cli.prazo-DDE
                           tt-cliente.vencto-fixo       = int-cond-pag-cli.vencto-fixo
                           tt-cliente.semana            = int-cond-pag-cli.semana
                           tt-cliente.mes               = int-cond-pag-cli.mes
                           tt-cliente.cod-gr-cli        = emitente.cod-gr-cli
                           tt-cliente.pais              = emitente.pais.
                END.
            END.
        END.
    END.
    ELSE DO:

        /* INFORMOU EMITENTE OU CNPJ */
        FIND emitente NO-LOCK
            WHERE emitente.cod-emitente = i-emitente NO-ERROR.

        FIND int-cond-pag-cli NO-LOCK
            WHERE int-cond-pag-cli.cod-emitente = emitente.cod-emitente NO-ERROR.

        IF  AVAIL int-cond-pag-cli THEN DO:
            IF  int-cond-pag-cli.grupo-econ THEN DO:
                FOR EACH b-emit NO-LOCK
                    WHERE b-emit.nome-matriz = emitente.nome-matriz:
                    CREATE tt-cliente.
                    ASSIGN tt-cliente.cod-emitente      = b-emit.cod-emitente
                           tt-cliente.cgc               = b-emit.cgc
                           tt-cliente.cgc-oito-posicoes = SUBSTR(b-emit.cgc,1,8)
                           tt-cliente.prazo-DDE         = int-cond-pag-cli.prazo-DDE
                           tt-cliente.vencto-fixo       = int-cond-pag-cli.vencto-fixo
                           tt-cliente.semana            = int-cond-pag-cli.semana
                           tt-cliente.mes               = int-cond-pag-cli.mes
                           tt-cliente.cod-gr-cli        = b-emit.cod-gr-cli
                           tt-cliente.pais              = b-emit.pais.
                END.
            END.
            ELSE DO:
                CREATE tt-cliente.
                ASSIGN tt-cliente.cod-emitente      = emitente.cod-emitente
                       tt-cliente.cgc               = emitente.cgc
                       tt-cliente.cgc-oito-posicoes = SUBSTR(emitente.cgc,1,8)
                       tt-cliente.prazo-DDE         = int-cond-pag-cli.prazo-DDE
                       tt-cliente.vencto-fixo       = int-cond-pag-cli.vencto-fixo
                       tt-cliente.semana            = int-cond-pag-cli.semana
                       tt-cliente.mes               = int-cond-pag-cli.mes
                       tt-cliente.cod-gr-cli        = emitente.cod-gr-cli
                       tt-cliente.pais              = emitente.pais.
            END.
        END.
        ELSE DO: 
            
            FIND b-matriz NO-LOCK
                WHERE b-matriz.nome-abrev = emitente.nome-matriz NO-ERROR.

            IF  AVAIL b-matriz THEN DO:
                FIND int-cond-pag-cli NO-LOCK
                    WHERE int-cond-pag-cli.cod-emitente = b-matriz.cod-emitente NO-ERROR.
                IF  AVAIL int-cond-pag-cli AND int-cond-pag-cli.grupo-econ THEN DO:
                    FOR EACH b-emit NO-LOCK
                        WHERE b-emit.nome-matriz = b-matriz.nome-abrev:
                        CREATE tt-cliente.
                        ASSIGN tt-cliente.cod-emitente      = b-emit.cod-emitente
                               tt-cliente.cgc               = b-emit.cgc
                               tt-cliente.cgc-oito-posicoes = SUBSTR(b-emit.cgc,1,8)
                               tt-cliente.prazo-DDE         = int-cond-pag-cli.prazo-DDE
                               tt-cliente.vencto-fixo       = int-cond-pag-cli.vencto-fixo
                               tt-cliente.semana            = int-cond-pag-cli.semana
                               tt-cliente.mes               = int-cond-pag-cli.mes
                               tt-cliente.cod-gr-cli        = b-emit.cod-gr-cli
                               tt-cliente.pais              = b-emit.pais.
                    END.
                END.
            END.
        END.

    END.

    ASSIGN i-nr-total-titulos = 0.

    RUN pi-acompanhar IN h-acomp (INPUT "Selecionando T°tulos...").

    FOR EACH estabelecimento NO-LOCK
        WHERE estabelecimento.cod_empresa = v_cod_empres_usuar
         AND estabelecimento.cod_estab   >= fi-estab-ini:SCREEN-VALUE IN FRAME f-cad 
         AND estabelecimento.cod_estab   <= fi-estab-fim:SCREEN-VALUE IN FRAME f-cad :
    
        FOR EACH tt-cliente
            ,FIRST int-emitente NO-LOCK
                WHERE int-emitente.cod-emitente  = tt-cliente.cod-emitente 
                  AND int-emitente.cod-gr-cob  >= int(fi-gr-cob-ini:SCREEN-VALUE IN FRAME f-cad)
                  AND int-emitente.cod-gr-cob  <= INT(fi-gr-cob-fim:SCREEN-VALUE IN FRAME f-cad)
            , FIRST emscad.cliente NO-LOCK
                WHERE emscad.cliente.cod_empresa = v_cod_empres_usuar
                  AND emscad.cliente.cdn_cliente = int-emitente.cod-emitente 
            ,EACH tit_acr NO-LOCK
               WHERE tit_acr.cdn_cliente         = tt-cliente.cod-emitente
                 AND tit_acr.cod_estab           = estabelecimento.cod_estab
                 AND tit_acr.cod_tit_acr        >= fi-nf-ini:SCREEN-VALUE IN FRAME f-cad
                 AND tit_acr.cod_tit_acr        <= fi-nf-fim:SCREEN-VALUE IN FRAME f-cad
                 AND tit_acr.dat_emis_docto     >= date(fi-data-ini:SCREEN-VALUE IN FRAME f-cad)
                 AND tit_acr.dat_emis_docto     <= date(fi-data-fim:SCREEN-VALUE IN FRAME f-cad)
                 AND tit_acr.dat_vencto_tit_acr >= date(fi-vencto-ini:SCREEN-VALUE IN FRAME f-cad)
                 AND tit_acr.dat_vencto_tit_acr <= date(fi-vencto-fim:SCREEN-VALUE IN FRAME f-cad)
                 AND tit_acr.ind_tip_cobr_acr    = "Normal"
                 AND tit_acr.ind_tip_espec_docto = "Normal"
                 AND tit_acr.log_tit_acr_estordo = NO:

                IF  (NOT tit_acr.log_sdo_tit_acr AND tit_acr.cod_portador <> "9915") THEN 
                    NEXT.

                FIND FIRST nota-fiscal NO-LOCK
                    WHERE nota-fiscal.cod-estabel = tit_acr.cod_estab 
                      AND nota-fiscal.serie       = tit_acr.cod_ser_docto
                      AND nota-fiscal.nr-nota-fis = tit_acr.cod_tit_acr NO-ERROR.

                IF  tt-cliente.prazo-DDE THEN DO:
                    IF  NOT AVAIL nota-fiscal 
                    OR  AVAIL nota-fiscal AND nota-fiscal.dt-entr-cli = ? THEN
                        NEXT.
                END.
    
                IF  AVAIL nota-fiscal THEN DO:
                    IF  nota-fiscal.dt-entr-cli = ? THEN
                        NEXT.
                END.
                ELSE
                    NEXT.

                /*---------------------------------------------------------------------------------------------------*/
                /*                               V E N C I M E N T O   C A L C U L A D O                             */
                /*---------------------------------------------------------------------------------------------------*/
                IF  tt-cliente.prazo-DDE THEN /* ê CONTRA-ENTREGA */
                    ASSIGN da-vencto-calculado = nota-fiscal.dt-entr-cli + 
                                                 (tit_acr.dat_vencto_origin_tit_acr - tit_acr.dat_emis_docto).
                ELSE 
                    ASSIGN da-vencto-calculado = tit_acr.dat_vencto_origin_tit_acr.

                /* SEMANA OU DIA M“S FIXO */
                IF  tt-cliente.vencto-fixo = 1 THEN /* SEMANA */
                    ASSIGN da-vencto-calculado = fnDataProrrogadaDiaSEMANA(INPUT da-vencto-calculado,
                                                                           INPUT tt-cliente.semana).
                ELSE 
                    IF  tt-cliente.vencto-fixo = 2 THEN /*DIA M“S FIXO */
                        ASSIGN da-vencto-calculado = fnDataProrrogadaDiaMES(INPUT da-vencto-calculado,
                                                                            INPUT tt-cliente.mes).
                
                /* Tratamento para clientes que n∆o utilizam DDE e vencimento fixo */
                IF  tt-cliente.prazo-DDE   = NO
                AND tt-cliente.vencto-fixo = 3 THEN DO:
                    
                    ASSIGN i-atraso    = 0
                           da-ent-prev = ?.

                    FIND FIRST int-nota-fiscal NO-LOCK
                        WHERE int-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
                        AND   int-nota-fiscal.serie       = nota-fiscal.serie
                        AND   int-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR. 
    
                    IF  AVAIL int-nota-fiscal THEN DO:
                        ASSIGN da-ent-prev = date(SUBSTRING(int-nota-fiscal.char-1,50,10)).

                        ASSIGN i-atraso = nota-fiscal.dt-entr-cli - da-ent-prev.

                        IF  i-atraso > 0 THEN
                            ASSIGN da-vencto-calculado = tit_acr.dat_vencto_origin_tit_acr + i-atraso.
                    END.
                END.

                /* Nota de exportaá∆o */
                IF  nota-fiscal.nat-operacao BEGINS "7" THEN
                    ASSIGN da-vencto-calculado = nota-fiscal.dt-entr-cli + (tit_acr.dat_vencto_origin_tit_acr - tit_acr.dat_emis_docto).
                
                IF  da-vencto-calculado = tit_acr.dat_vencto_tit_acr THEN DO:
                    IF  INPUT FRAME f-cad tg-n-prorrog = NO THEN
                        NEXT.
                END.
                ELSE DO:
                    /* Verificar se o t°tulo j† sofreu alguma prorrogaá∆o de vencimento */
                    FIND FIRST movto_tit_acr OF tit_acr NO-LOCK
                        WHERE movto_tit_acr.ind_trans_acr_abrev = "ADVN" NO-ERROR.
                    
                    IF  NOT AVAIL movto_tit_acr THEN DO:
                        IF  INPUT FRAME f-cad tg-prorrog = NO THEN
                            NEXT.
                    END.
                    ELSE DO:
                        IF  INPUT FRAME f-cad tg-alt-prorrog = NO THEN
                            NEXT.
                    END.
                END.

                ASSIGN i-nr-total-titulos = i-nr-total-titulos + 1.    

                CREATE tt-titulo.
                ASSIGN tt-titulo.cod_estab                = tit_acr.cod_estab 
                       tt-titulo.cod_espec_docto          = tit_acr.cod_espec_docto 
                       tt-titulo.cod_ser_docto            = tit_acr.cod_ser_docto 
                       tt-titulo.cod_tit_acr              = tit_acr.cod_tit_acr 
                       tt-titulo.cod_parcela              = tit_acr.cod_parcela 
                       tt-titulo.cgc                      = tt-cliente.cgc
                       tt-titulo.cdn_cliente              = tit_acr.cdn_cliente 
                       tt-titulo.nom_abrev                = tit_acr.nom_abrev
                       tt-titulo.cdn_clien_matriz         = tit_acr.cdn_clien_matriz 
                       tt-titulo.dat_emis_docto           = tit_acr.dat_emis_docto 
                       tt-titulo.dat_venco_origin_tit_acr = tit_acr.dat_vencto_origin_tit_acr 
                       tt-titulo.prazo-original           = (tit_acr.dat_vencto_origin_tit_acr - tit_acr.dat_emis_docto)
                       tt-titulo.dat_vencto_tit_acr       = tit_acr.dat_vencto_tit_acr
                       tt-titulo.prazo_atual              = (tit_acr.dat_vencto_tit_acr - tit_acr.dat_emis_docto)   
                       tt-titulo.dt-entr-cli              = IF AVAIL nota-fiscal THEN nota-fiscal.dt-entr-cli ELSE ?
                       tt-titulo.cod_indic_econ           = tit_acr.cod_indic_econ      
                       tt-titulo.val_origin_tit_acr       = tit_acr.val_origin_tit_acr  
                       tt-titulo.val_sdo_tit_acr          = tit_acr.val_sdo_tit_acr.

                /* Prorrogar data vencto para pr¢ximo dia util */
                RUN pi_retornar_dia_util (INPUT cliente.cod_pais,
                                          INPUT tit_acr.cod_estab,
                                          INPUT "Respons†vel Financeiro",
                                          INPUT 0,
                                          INPUT da-vencto-calculado,
                                          OUTPUT da-prev-liquid,
                                          OUTPUT v_cod_return).

                IF  ENTRY(1, v_cod_return) = "OK" THEN
                    ASSIGN da-vencto-calculado = da-prev-liquid.

                ASSIGN tt-titulo.VENCTO-CALCULADO     = da-vencto-calculado.

                IF  tt-titulo.VENCTO-CALCULADO = tit_acr.dat_vencto_tit_ac THEN
                    ASSIGN tt-titulo.cor-linha = 8. /* CINZA n∆o deixar selecionar, pois n∆o vai alterar nada mesmo */
                ELSE DO:
                    /* Verificar se o t°tulo j† sofreu alguma prorrogaá∆o de vencimento */
                    FIND FIRST movto_tit_acr OF tit_acr NO-LOCK
                        WHERE movto_tit_acr.ind_trans_acr_abrev = "ADVN" NO-ERROR.
                    IF  AVAIL movto_tit_acr THEN
                       ASSIGN tt-titulo.cor-linha = 14. /* Cor VERDE, j† houve uma prorrogaá∆o em algum momento */
                    ELSE
                       ASSIGN tt-titulo.cor-linha = 15. /* Normal cor BRANCA */
                END.
                /*--------------------------------------FIM VECNTO-CALCULAOD-----------------------------------------*/                

                ASSIGN tt-titulo.PRAZO-CALCULADO          = tt-titulo.VENCTO-CALCULADO - tt-titulo.dat_emis_docto
                       tt-titulo.DIAS-PRORROGACAO         = tt-titulo.VENCTO-CALCULADO - tt-titulo.dat_venco_origin_tit_acr
                       tt-titulo.GRUPO-DDE                = tt-cliente.prazo-DDE.

                IF  tt-cliente.vencto-fixo = 1 THEN /*SEMANA*/
                    ASSIGN tt-titulo.DIA-SEMANA = fnNomeDiaSemana(WEEKDAY(tt-titulo.VENCTO-CALCULADO)).
                ELSE
                    IF  tt-cliente.vencto-fixo = 2 THEN /*M“S*/
                        ASSIGN tt-titulo.DIA-MES = DAY(tt-titulo.VENCTO-CALCULADO).
                
                ASSIGN tt-titulo.cod_portador             = tit_acr.cod_portador 
                       tt-titulo.cod_cart_bcia            = tit_acr.cod_cart_bcia 
                       tt-titulo.log_tit_acr_cobr_bcia    = tit_acr.log_tit_acr_cobr_bcia 
                       tt-titulo.cod_tit_acr_bco          = tit_acr.cod_tit_acr_bco 
                       tt-titulo.cod_grp_clien            = string(tt-cliente.cod-gr-cli)
                       tt-titulo.cod-gr-cob               = int-emitente.cod-gr-cob
                       tt-titulo.vencto-fixo              = tt-cliente.vencto-fixo
                       tt-titulo.r-tit-acr                = RECID(tit_acr)
                       tt-titulo.num_id_tit_acr           = tit_acr.num_id_tit_acr.

                /*---------------------------------------------------------------------------------*/
                /*                    DATA PREVIS«O LIQUIDAÄ«O E DATA FLUXO                        */
                /*---------------------------------------------------------------------------------*/
                /* C†lculo da data de previs∆o de liquidaá∆o */
                RUN pi_retornar_dia_util (INPUT cliente.cod_pais,
                                          INPUT tit_acr.cod_estab,
                                          INPUT "Respons†vel Financeiro",
                                          INPUT 0,
                                          INPUT tt-titulo.VENCTO-CALCULADO,
                                          OUTPUT da-prev-liquid,
                                          OUTPUT v_cod_return).

                IF  ENTRY(1, v_cod_return) <> "OK" THEN 
                    ASSIGN da-prev-liquid = tt-titulo.VENCTO-CALCULADO.

                /* EXISTEM EXCEÄÂES FLOAT INFORMADAS */
                FIND b-tt-portador
                    WHERE b-tt-portador.codigo   = tt-titulo.cod_portador
                      AND b-tt-portador.carteira = tt-titulo.cod_cart_bcia NO-ERROR.

                ASSIGN da-fluxo = da-prev-liquid.

                /* VERIFICA SE CAIU NO ÈLTIMO DIA ÈTIL DO M“S E POSSUI EXCEÄ«O FLOAT CADASTRADA */
                ASSIGN l-ultimo-dia-mes = NO.
                IF  fn_ultimo_dia_util_mes (da-prev-liquid) AND AVAIL b-tt-portador THEN 
                    ASSIGN l-ultimo-dia-mes = YES.

                IF  NOT l-ultimo-dia-mes THEN DO:
                    run pi_retornar_finalid_indic_econ (INPUT tit_acr.cod_indic_econ,
                                                        INPUT tit_acr.dat_transacao,
                                                        OUTPUT v_cod_finalid_econ).

                    FIND portad_bco NO-LOCK
                        WHERE portad_bco.cod_modul_dtsul   = "ACR"
                          AND portad_bco.cod_estab         = tit_acr.cod_estab
                          AND portad_bco.cod_portador      = tit_acr.cod_portador
                          AND portad_bco.cod_cart_bcia     = tit_acr.cod_cart_bcia
                          and portad_bco.cod_finalid_econ  = v_cod_finalid_econ NO-ERROR.

                    IF  AVAIL portad_bco THEN DO:        
                        IF  portad_bco.qtd_dias_float_cobr > 0 THEN DO:
                             RUN prgfin/acr/acr792za.py (INPUT tit_acr.cod_estab,
                                                         INPUT-OUTPUT da-fluxo,
                                                         INPUT portad_bco.qtd_dias_float_cobr).
                        END.
                     END.
                END.

                ASSIGN tt-titulo.dat_prev_liquidac = da-prev-liquid
                       tt-titulo.dat_fluxo_tit_acr = da-fluxo.

                /* Verifica tratamento para ocorràncias de prorrogaá∆o supcard */
                IF  tit_acr.cod_portador = "9915" THEN
                    IF  CAN-FIND (FIRST int-pendencias-supcard 
                                      WHERE int-pendencias-supcard.cod-estab       = tt-titulo.cod_estab
                                        AND int-pendencias-supcard.cod-espec-docto = tt-titulo.cod_espec_docto
                                        AND int-pendencias-supcard.cod-ser-docto   = tt-titulo.cod_ser_docto
                                        AND int-pendencias-supcard.cod-tit-acr     = tt-titulo.cod_tit_acr
                                        AND int-pendencias-supcard.cod-parcela     = tt-titulo.cod_parcela
                                        AND int-pendencias-supcard.dias-prorrog    = tt-titulo.dias-prorrog ) THEN 
                        ASSIGN tt-titulo.cor-linha = 8. /*CINZA*/
                    ELSE DO:
                        IF  CAN-FIND (FIRST int-pendencias-supcard 
                                  WHERE int-pendencias-supcard.cod-estab       = tt-titulo.cod_estab
                                    AND int-pendencias-supcard.cod-espec-docto = tt-titulo.cod_espec_docto
                                    AND int-pendencias-supcard.cod-ser-docto   = tt-titulo.cod_ser_docto
                                    AND int-pendencias-supcard.cod-tit-acr     = tt-titulo.cod_tit_acr
                                    AND int-pendencias-supcard.cod-parcela     = tt-titulo.cod_parcela ) THEN 
                        ASSIGN tt-titulo.cor-linha = 14. /* J† sofreu algum tipo de prorrogaá∆o VERDE */
                    ELSE
                        ASSIGN tt-titulo.cor-linha = 15. /* Normal cor BRANCA */
                END.

                /* filtro dias prorrogaá∆o */
                IF  tt-titulo.DIAS-PRORROGACAO < int(fi-dias-prorrog-ini:SCREEN-VALUE IN FRAME f-cad)
                OR  tt-titulo.DIAS-PRORROGACAO > int(fi-dias-prorrog-fim:SCREEN-VALUE IN FRAME f-cad) THEN
                    DELETE tt-titulo.        
        END.
    END.

    {&open-query-br-titulo}

    APPLY "value-changed" TO br-titulo IN FRAME f-cad.

    RUN pi-finalizar IN h-acomp.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-temp-table-alt-titulo esesb071 
PROCEDURE pi-cria-temp-table-alt-titulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE v_num_aux_2      AS INTEGER    NO-UNDO.
    DEFINE VARIABLE v_num_cont       AS INTEGER    NO-UNDO.
    DEFINE VARIABLE v_num_aux        AS INTEGER    NO-UNDO.
    DEFINE VARIABLE v_cod_refer_impl AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-historico      AS CHAR       NO-UNDO.

    /*Calcula referencia automatica*/
    repeat:       
      ASSIGN v_num_aux_2 = integer(this-procedure:handle).
             v_cod_refer_impl = 'PR' + SUBSTR(STRING(YEAR (TODAY), '9999'), 3,2)
                                     + STRING(MONTH(TODAY), '99')
                                     + STRING(DAY  (TODAY), '99').
      do v_num_cont = 1 to 3:
        assign v_num_aux   = (random(0,v_num_aux_2) mod 26) + 97
               v_cod_refer_impl = v_cod_refer_impl + chr(v_num_aux).
      end.

      find first movto_tit_acr 
           where movto_tit_acr.cod_estab   = tit_acr.cod_estab
             and movto_tit_acr.cod_refer = v_cod_refer_impl no-lock no-error.
      if not avail movto_tit_acr then LEAVE.
    end.

    c-historico = (IF tt-titulo.vencto-fixo = 1 THEN 
                       (". Dia Semana: " + tt-titulo.DIA-SEMANA )
                     ELSE IF tt-titulo.vencto-fixo = 2 THEN 
                             (". Dia Màs: " + string(tt-titulo.DIA-MES))
                          ELSE 
                             ". Sem vencimento fixo.").

    CREATE tt_alter_tit_acr_base_2.
    ASSIGN tt_alter_tit_acr_base_2.tta_cod_estab                   = tit_acr.cod_estab                     
           tt_alter_tit_acr_base_2.tta_num_id_tit_acr              = tit_acr.num_id_tit_acr

           tt_alter_tit_acr_base_2.tta_dat_transacao               = TODAY /*tit_acr.dat_transacao*/
           tt_alter_tit_acr_base_2.tta_cod_refer                   = v_cod_refer_impl
           tt_alter_tit_acr_base_2.ttv_cod_motiv_movto_tit_acr_imp = ?
           tt_alter_tit_acr_base_2.tta_val_sdo_tit_acr             = ? /*tit_acr.val_sdo_tit_acr*/
           tt_alter_tit_acr_base_2.ttv_cod_motiv_movto_tit_acr_alt = ?
           tt_alter_tit_acr_base_2.ttv_ind_motiv_acerto_val        = ?
           tt_alter_tit_acr_base_2.tta_cod_portador                = ? /*tit_acr.cod_portador                   */
           tt_alter_tit_acr_base_2.tta_cod_cart_bcia               = ? /*tit_acr.cod_cart_bcia                  */
           tt_alter_tit_acr_base_2.tta_val_despes_bcia             = ? /*tit_acr.val_despes_bcia                */
           tt_alter_tit_acr_base_2.tta_cod_agenc_cobr_bcia         = ? /*tit_acr.cod_agenc_cobr_bcia            */
           tt_alter_tit_acr_base_2.tta_cod_tit_acr_bco             = ? /*tit_acr.cod_tit_acr_bco                */
           tt_alter_tit_acr_base_2.tta_dat_emis_docto              = ? /*tit_acr.dat_emis_docto                 */
           tt_alter_tit_acr_base_2.tta_dat_vencto_tit_acr          = tt-titulo.VENCTO-CALCULADO
           tt_alter_tit_acr_base_2.tta_dat_prev_liquidac           = tt-titulo.dat_prev_liquidac
           tt_alter_tit_acr_base_2.tta_dat_fluxo_tit_acr           = tt-titulo.dat_fluxo_tit_acr
           tt_alter_tit_acr_base_2.tta_ind_sit_tit_acr             = ? /*tit_acr.ind_sit_tit_acr                */
           tt_alter_tit_acr_base_2.tta_cod_cond_cobr               = ? /*tit_acr.cod_cond_cobr                  */
           tt_alter_tit_acr_base_2.tta_log_tip_cr_perda_dedut_tit  = ? /*tit_acr.log_tip_cr_perda_dedut_tit     */
           tt_alter_tit_acr_base_2.tta_dat_abat_tit_acr            = ? /*tit_acr.dat_abat_tit_acr               */
           tt_alter_tit_acr_base_2.tta_val_perc_abat_acr           = ? /*tit_acr.val_perc_abat_acr              */
           tt_alter_tit_acr_base_2.tta_val_abat_tit_acr            = ? /*tit_acr.val_abat_tit_acr               */
           tt_alter_tit_acr_base_2.tta_dat_desconto                = ? /*tit_acr.dat_desconto                   */
           tt_alter_tit_acr_base_2.tta_val_perc_desc               = ? /*tit_acr.val_perc_desc                  */
           tt_alter_tit_acr_base_2.tta_val_desc_tit_acr            = ? /*tit_acr.val_desc_tit_acr               */
           tt_alter_tit_acr_base_2.tta_qtd_dias_carenc_juros_acr   = ? /*tit_acr.qtd_dias_carenc_juros_acr      */
           tt_alter_tit_acr_base_2.tta_val_perc_juros_dia_atraso   = ? /*tit_acr.val_perc_juros_dia_atraso      */
           tt_alter_tit_acr_base_2.tta_qtd_dias_carenc_multa_acr   = ? /*tit_acr.qtd_dias_carenc_multa_acr      */
           tt_alter_tit_acr_base_2.tta_val_perc_multa_atraso       = ? /*tit_acr.val_perc_multa_atraso          */
           tt_alter_tit_acr_base_2.ttv_cod_portador_mov            = ?                                        
           tt_alter_tit_acr_base_2.tta_ind_tip_cobr_acr            = ? /*tit_acr.ind_tip_cobr_acr               */
           tt_alter_tit_acr_base_2.tta_ind_ender_cobr              = ? /*tit_acr.ind_ender_cobr                 */
           tt_alter_tit_acr_base_2.tta_nom_abrev_contat            = ? /*tit_acr.nom_abrev_contat               */
           tt_alter_tit_acr_base_2.tta_val_liq_tit_acr             = ? /*tit_acr.val_liq_tit_acr                */
           tt_alter_tit_acr_base_2.tta_cod_instruc_bcia_1_movto    = ?                                         
           tt_alter_tit_acr_base_2.tta_cod_instruc_bcia_2_movto    = ?                                        
           tt_alter_tit_acr_base_2.tta_log_tit_acr_destndo         = ? /*tit_acr.log_tit_acr_destndo            */
           tt_alter_tit_acr_base_2.tta_cod_histor_padr             = ?                                        
           tt_alter_tit_acr_base_2.ttv_des_text_histor             =  "Prorrogaá∆o Vencto (rotina esesb071). Executado em " + 
                                                                      STRING(TODAY,"99/99/9999") + " Ös " + STRING(TIME, "HH:MM:SS") + 
                                                                      "; Vencimento alterado de " + string(tt-titulo.dat_vencto_tit_acr, "99/99/9999") +
                                                                      " para " + STRING(tt-titulo.VENCTO-CALCULADO) +
                                                                      "; Prazo Calculado: "      + STRING(tt-titulo.PRAZO-CALCULADO)  +
                                                                      "; Dias Prorrogaá∆o:  "    + strinG(tt-titulo.DIAS-PRORROGACAO) + 
                                                                      "; DDE: " + string(tt-titulo.GRUPO-DDE, "SIM/N«O") + c-historico
                                                                      
           tt_alter_tit_acr_base_2.tta_des_obs_cobr                = ? /*tit_acr.des_obs_cobr                     */
           tt_alter_tit_acr_base_2.tta_num_seq_tit_acr             = ? /*tit_acr.num_seq_tit_acr*/              
           tt_alter_tit_acr_base_2.ttv_cod_estab_planilha          = ? /*tit_acr.cod_estab */
           tt_alter_tit_acr_base_2.tta_cod_tit_acr_bco             = ? 
           tt_alter_tit_acr_base_2.tta_cod_portador                = ?
           tt_alter_tit_acr_base_2.tta_cod_cart_bcia               = ?.
                                                                                                                    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exporta-excel esesb071 
PROCEDURE pi-exporta-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-arquivo-csv     AS CHAR NO-UNDO.
    DEF INPUT PARAM ph-handle-browser AS HANDLE NO-UNDO.
    
    DEFINE VARIABLE hquery AS HANDLE NO-UNDO.
    DEFINE VARIABLE hbuffer AS HANDLE NO-UNDO.
    DEFINE VARIABLE contar AS INTEGER NO-UNDO.
    
    hBrowser = ph-handle-browser.

    /* se o handle nao for valido, cai fora */
    IF NOT VALID-HANDLE(hBrowser) THEN
       RETURN.
    
    hquery = hBrowser:QUERY. /* capturar a query do browser */
    hbuffer = hquery:GET-BUFFER-HANDLE(1). /* capturar o buffer da query */
    
    OUTPUT STREAM s TO VALUE( p-arquivo-csv ) CONVERT TARGET 'ISO8859-1'.
    
    /* primeiro registro da query */
    hquery:GET-FIRST().
    DEF VAR c-dados     AS CHAR FORMAT "x(500)" NO-UNDO.
    DEF VAR c-cabecalho AS CHAR FORMAT "x(500)" NO-UNDO.
    DEF VAR l-cab       AS LOG  INIT YES        NO-UNDO.
    DEF VAR c-valor     AS CHAR NO-UNDO.
    
    DO WHILE hbuffer:AVAIL:
        
        REPEAT contar = 1 TO hbuffer:NUM-FIELDS: /* listar todos os campos do buffer */

            /* Caso n∆o queira mostrar algum campo da tabela no arquivo csv*/
            IF  hbuffer:BUFFER-FIELD(contar):NAME = "flegado"  
            OR  hbuffer:BUFFER-FIELD(contar):NAME = "cor-linha" 
            OR  hbuffer:BUFFER-FIELD(contar):NAME = "r-tit-acr"
            OR  hbuffer:BUFFER-FIELD(contar):NAME = "vencto-fixo"  
            OR  hbuffer:BUFFER-FIELD(contar):NAME = "num_id_tit_acr" 
            OR  hbuffer:BUFFER-FIELD(contar):NAME = "cgc"       THEN 
                NEXT.

            IF  hbuffer:BUFFER-FIELD(contar):BUFFER-VALUE = ? THEN
                ASSIGN c-valor = "".
            ELSE
                ASSIGN c-valor = hbuffer:BUFFER-FIELD(contar):BUFFER-VALUE.

            IF  hbuffer:BUFFER-FIELD(contar):DATA-TYPE = "logical" THEN DO:
                IF  hbuffer:BUFFER-FIELD(contar):BUFFER-VALUE = "NO" THEN
                   ASSIGN c-valor = "N«O".
                ELSE
                    IF  hbuffer:BUFFER-FIELD(contar):BUFFER-VALUE = YES THEN
                        ASSIGN c-valor = "SIM".
                    ELSE
                        ASSIGN c-valor = hbuffer:BUFFER-FIELD(contar):BUFFER-VALUE.
            END.

            ASSIGN c-dados = c-dados + c-valor + ";".

            IF  l-cab  THEN DO:
                ASSIGN c-cabecalho = c-cabecalho + hbuffer:BUFFER-FIELD(contar):COLUMN-LABEL  + ";".
            END.
                
        END.
        
        IF  l-cab THEN
            PUT STREAM s c-cabecalho SKIP.
        
        PUT STREAM s c-dados SKIP.

        ASSIGN c-dados = ""
               l-cab = NO.

        hquery:GET-NEXT().
    END.
    
    OUTPUT STREAM s CLOSE.
     
    DOS SILENT START excel VALUE(p-arquivo-csv).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-excel-ped-venda esesb071 
PROCEDURE pi-gera-excel-ped-venda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*       IF  NOT AVAIL tt-titulo THEN                                                                                                                                      */
/*           RETURN "OK".                                                                                                                                                  */
/*                                                                                                                                                                         */
/*       DEF VAR c-arquivo AS CHAR NO-UNDO.                                                                                                                                */
/*                                                                                                                                                                         */
/*       DEF BUFFER b-tt-pedido FOR tt-pedido.                                                                                                                             */
/*                                                                                                                                                                         */
/*       ASSIGN c-arquivo = STRING(SESSION:TEMP-DIRECTORY) + "Pedidos_" + STRING(tt-titulo.cod-emitente) + "_" + STRING(TODAY, "99-99-9999") + "_"+ STRING(TIME) + ".csv". */
/*                                                                                                                                                                         */
/*       OUTPUT STREAM s-1 TO value(c-arquivo) CONVERT TARGET "iso8859-1".                                                                                                 */
/*                                                                                                                                                                         */
/*       PUT STREAM s-1 "Cliente;Pedido;Implantaá∆o;Cancelamento;Situaá∆o Pedido;Val L°quido; Val Total" SKIP.                                                             */
/*                                                                                                                                                                         */
/*       FOR EACH b-tt-pedido                                                                                                                                              */
/*            BY  b-tt-pedido.nr-pedcli:                                                                                                                                   */
/*            EXPORT STREAM s-1 DELIMITER ";" b-tt-pedido.nome-abrev                                                                                                       */
/*                                            b-tt-pedido.nr-pedcli                                                                                                        */
/*                                            b-tt-pedido.dt-implantacao                                                                                                   */
/*                                            b-tt-pedido.dt-cancela                                                                                                       */
/*                                            b-tt-pedido.desc-sit-ped                                                                                                     */
/*                                            b-tt-pedido.vl-liq-ped                                                                                                       */
/*                                            b-tt-pedido.vl-tot-ped.                                                                                                      */
/*       END.                                                                                                                                                              */
/*                                                                                                                                                                         */
/*       OUTPUT STREAM s-1 CLOSE.                                                                                                                                          */
/*                                                                                                                                                                         */
/*       DOS SILENT START excel VALUE(c-arquivo).                                                                                                                          */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-ocorrencia-sup-card esesb071 
PROCEDURE pi-gera-ocorrencia-sup-card :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF  CAN-FIND (FIRST int-pendencias-supcard 
                      WHERE int-pendencias-supcard.cod-estab       = tt-titulo.cod_estab
                        AND int-pendencias-supcard.cod-espec-docto = tt-titulo.cod_espec_docto
                        AND int-pendencias-supcard.cod-ser-docto   = tt-titulo.cod_ser_docto
                        AND int-pendencias-supcard.cod-tit-acr     = tt-titulo.cod_tit_acr
                        AND int-pendencias-supcard.cod-parcela     = tt-titulo.cod_parcela
                        AND int-pendencias-supcard.dias-prorrog    = tt-titulo.dias-prorrog ) THEN 
        NEXT.
    
    CREATE int-pendencias-supcard.
    ASSIGN int-pendencias-supcard.cod-usuar           = c-seg-usuario
           int-pendencias-supcard.cnpj-cliente        = tt-titulo.cgc
           int-pendencias-supcard.cod-estab           = tt-titulo.cod_estab
           int-pendencias-supcard.cod-espec-docto     = tt-titulo.cod_espec_docto
           int-pendencias-supcard.cod-parcela         = tt-titulo.cod_parcela
           int-pendencias-supcard.cod-ser-docto       = tt-titulo.cod_ser_docto
           int-pendencias-supcard.cod-tit-acr         = tt-titulo.cod_tit_acr
           int-pendencias-supcard.dat-criacao         = TODAY
           int-pendencias-supcard.identific           = 2
           int-pendencias-supcard.log-manual          = YES
           int-pendencias-supcard.log-emergencial     = NO
           int-pendencias-supcard.tipo-bloqueio       = ?
           int-pendencias-supcard.dias-prorrog        = tt-titulo.dias-prorrog
           int-pendencias-supcard.val-lancamento      = 0
           int-pendencias-supcard.val-limite-sugerido = 0
           int-pendencias-supcard.obs                 = "".

    CREATE tt-int-pendencias-supcard.
    BUFFER-COPY int-pendencias-supcard TO tt-int-pendencias-supcard.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-muda-cor-linha esesb071 
PROCEDURE pi-muda-cor-linha :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM  p-cor   AS INTEGER NO-UNDO.

    ASSIGN  tt-titulo.flegado                    :bgCOLOR IN BROWSE br-titulo  = p-cor       
            tt-titulo.cdn_cliente                :bgCOLOR IN BROWSE br-titulo  = p-cor                                             
            tt-titulo.nom_abrev                  :bgCOLOR IN BROWSE br-titulo  = p-cor                                             
            tt-titulo.cdn_clien_matriz           :bgCOLOR IN BROWSE br-titulo  = p-cor                                             
            tt-titulo.cod_estab                  :bgCOLOR IN BROWSE br-titulo  = p-cor                                              
            tt-titulo.cod_espec_docto            :bgCOLOR IN BROWSE br-titulo  = p-cor                                              
            tt-titulo.cod_ser_docto              :bgCOLOR IN BROWSE br-titulo  = p-cor                                              
            tt-titulo.cod_tit_acr                :bgCOLOR IN BROWSE br-titulo  = p-cor                                              
            tt-titulo.cod_parcela                :bgCOLOR IN BROWSE br-titulo  = p-cor                                              
            tt-titulo.dat_emis_docto             :bgCOLOR IN BROWSE br-titulo  = p-cor                                              
            tt-titulo.dat_venco_origin_tit_acr   :bgCOLOR IN BROWSE br-titulo  = p-cor                                              
            tt-titulo.prazo-original             :bgCOLOR IN BROWSE br-titulo  = p-cor                                              
            tt-titulo.dat_vencto_tit_acr         :bgCOLOR IN BROWSE br-titulo  = p-cor                                              
            tt-titulo.prazo_atual                :bgCOLOR IN BROWSE br-titulo  = p-cor                                              
            tt-titulo.dt-entr-cli                :bgCOLOR IN BROWSE br-titulo  = p-cor                                              
            tt-titulo.cod_indic_econ             :bgCOLOR IN BROWSE br-titulo  = p-cor                                              
            tt-titulo.val_origin_tit_acr         :bgCOLOR IN BROWSE br-titulo  = p-cor                                         
            tt-titulo.val_sdo_tit_acr            :bgCOLOR IN BROWSE br-titulo  = p-cor                                         
            tt-titulo.VENCTO-CALCULADO           :bgCOLOR IN BROWSE br-titulo  = p-cor                                         
            tt-titulo.PRAZO-CALCULADO            :bgCOLOR IN BROWSE br-titulo  = p-cor                                         
            tt-titulo.DIAS-PRORROGACAO           :bgCOLOR IN BROWSE br-titulo  = p-cor                                         
            tt-titulo.GRUPO-DDE                  :bgCOLOR IN BROWSE br-titulo  = p-cor                                         
            tt-titulo.DIA-SEMANA                 :bgCOLOR IN BROWSE br-titulo  = p-cor                                         
            tt-titulo.DIA-MES                    :bgCOLOR IN BROWSE br-titulo  = p-cor                                         
            tt-titulo.cod_portador               :bgCOLOR IN BROWSE br-titulo  = p-cor                                        
            tt-titulo.cod_cart_bcia              :bgCOLOR IN BROWSE br-titulo  = p-cor                                        
            tt-titulo.log_tit_acr_cobr_bcia      :bgCOLOR IN BROWSE br-titulo  = p-cor                                        
            tt-titulo.cod_tit_acr_bco            :bgCOLOR IN BROWSE br-titulo  = p-cor                                        
            tt-titulo.cod_grp_clien              :bgCOLOR IN BROWSE br-titulo  = p-cor                                        
            tt-titulo.cod-gr-cob                 :bgCOLOR IN BROWSE br-titulo  = p-cor
            tt-titulo.dat_prev_liquidac          :bgCOLOR IN BROWSE br-titulo  = p-cor
            tt-titulo.dat_fluxo_tit_acr          :bgCOLOR IN BROWSE br-titulo  = p-cor.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-negrito esesb071 
PROCEDURE pi-negrito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM  p-cor   AS INTEGER NO-UNDO.
    DEF INPUT PARAM  p-fonte AS INTEGER NO-UNDO.
    
    ASSIGN  tt-titulo.flegado                    :FGCOLOR IN BROWSE br-titulo  = p-cor       
            tt-titulo.flegado                    :FONT    IN BROWSE br-titulo  = p-fonte    
            tt-titulo.cdn_cliente                :FGCOLOR IN BROWSE br-titulo  = p-cor                                             
            tt-titulo.cdn_cliente                :FONT    IN BROWSE br-titulo  = p-fonte                                           
            tt-titulo.nom_abrev                  :FGCOLOR IN BROWSE br-titulo  = p-cor                                             
            tt-titulo.nom_abrev                  :FONT    IN BROWSE br-titulo  = p-fonte                                           
            tt-titulo.cdn_clien_matriz           :FGCOLOR IN BROWSE br-titulo  = p-cor                                             
            tt-titulo.cdn_clien_matriz           :FONT    IN BROWSE br-titulo  = p-fonte                                           
            tt-titulo.cod_estab                  :FGCOLOR IN BROWSE br-titulo  = p-cor                                              
            tt-titulo.cod_estab                  :FONT    IN BROWSE br-titulo  = p-fonte                                            
            tt-titulo.cod_espec_docto            :FGCOLOR IN BROWSE br-titulo  = p-cor                                              
            tt-titulo.cod_espec_docto            :FONT    IN BROWSE br-titulo  = p-fonte                                            
            tt-titulo.cod_ser_docto              :FGCOLOR IN BROWSE br-titulo  = p-cor                                              
            tt-titulo.cod_ser_docto              :FONT    IN BROWSE br-titulo  = p-fonte                                            
            tt-titulo.cod_tit_acr                :FGCOLOR IN BROWSE br-titulo  = p-cor                                              
            tt-titulo.cod_tit_acr                :FONT    IN BROWSE br-titulo  = p-fonte                                            
            tt-titulo.cod_parcela                :FGCOLOR IN BROWSE br-titulo  = p-cor                                              
            tt-titulo.cod_parcela                :FONT    IN BROWSE br-titulo  = p-fonte                                            
            tt-titulo.dat_emis_docto             :FGCOLOR IN BROWSE br-titulo  = p-cor                                              
            tt-titulo.dat_emis_docto             :FONT    IN BROWSE br-titulo  = p-fonte                                            
            tt-titulo.dat_venco_origin_tit_acr   :FGCOLOR IN BROWSE br-titulo  = p-cor                                              
            tt-titulo.dat_venco_origin_tit_acr   :FONT    IN BROWSE br-titulo  = p-fonte                                            
            tt-titulo.prazo-original             :FGCOLOR IN BROWSE br-titulo  = p-cor                                              
            tt-titulo.prazo-original             :FONT    IN BROWSE br-titulo  = p-fonte                                            
            tt-titulo.dat_vencto_tit_acr         :FGCOLOR IN BROWSE br-titulo  = p-cor                                              
            tt-titulo.dat_vencto_tit_acr         :FONT    IN BROWSE br-titulo  = p-fonte                                            
            tt-titulo.prazo_atual                :FGCOLOR IN BROWSE br-titulo  = p-cor                                              
            tt-titulo.prazo_atual                :FONT    IN BROWSE br-titulo  = p-fonte                                            
            tt-titulo.dt-entr-cli                :FGCOLOR IN BROWSE br-titulo  = p-cor                                              
            tt-titulo.dt-entr-cli                :FONT    IN BROWSE br-titulo  = p-fonte                                            
            tt-titulo.cod_indic_econ             :FGCOLOR IN BROWSE br-titulo  = p-cor                                              
            tt-titulo.cod_indic_econ             :FONT    IN BROWSE br-titulo  = p-fonte                                            
            tt-titulo.val_origin_tit_acr         :FGCOLOR IN BROWSE br-titulo  = p-cor                                         
            tt-titulo.val_origin_tit_acr         :FONT    IN BROWSE br-titulo  = p-fonte                                       
            tt-titulo.val_sdo_tit_acr            :FGCOLOR IN BROWSE br-titulo  = p-cor                                         
            tt-titulo.val_sdo_tit_acr            :FONT    IN BROWSE br-titulo  = p-fonte                                       
            tt-titulo.VENCTO-CALCULADO           :FGCOLOR IN BROWSE br-titulo  = p-cor                                         
            tt-titulo.VENCTO-CALCULADO           :FONT    IN BROWSE br-titulo  = p-fonte                                       
            tt-titulo.PRAZO-CALCULADO            :FGCOLOR IN BROWSE br-titulo  = p-cor                                         
            tt-titulo.PRAZO-CALCULADO            :FONT    IN BROWSE br-titulo  = p-fonte                                       
            tt-titulo.DIAS-PRORROGACAO           :FGCOLOR IN BROWSE br-titulo  = p-cor                                         
            tt-titulo.DIAS-PRORROGACAO           :FONT    IN BROWSE br-titulo  = p-fonte                                       
            tt-titulo.GRUPO-DDE                  :FGCOLOR IN BROWSE br-titulo  = p-cor                                         
            tt-titulo.GRUPO-DDE                  :FONT    IN BROWSE br-titulo  = p-fonte                                       
            tt-titulo.DIA-SEMANA                 :FGCOLOR IN BROWSE br-titulo  = p-cor                                         
            tt-titulo.DIA-SEMANA                 :FONT    IN BROWSE br-titulo  = p-fonte                                       
            tt-titulo.DIA-MES                    :FGCOLOR IN BROWSE br-titulo  = p-cor                                         
            tt-titulo.DIA-MES                    :FONT    IN BROWSE br-titulo  = p-fonte                                       
            tt-titulo.cod_portador               :FGCOLOR IN BROWSE br-titulo  = p-cor                                        
            tt-titulo.cod_portador               :FONT    IN BROWSE br-titulo  = p-fonte                                      
            tt-titulo.cod_cart_bcia              :FGCOLOR IN BROWSE br-titulo  = p-cor                                        
            tt-titulo.cod_cart_bcia              :FONT    IN BROWSE br-titulo  = p-fonte                                      
            tt-titulo.log_tit_acr_cobr_bcia      :FGCOLOR IN BROWSE br-titulo  = p-cor                                        
            tt-titulo.log_tit_acr_cobr_bcia      :FONT    IN BROWSE br-titulo  = p-fonte                                      
            tt-titulo.cod_tit_acr_bco            :FGCOLOR IN BROWSE br-titulo  = p-cor                                        
            tt-titulo.cod_tit_acr_bco            :FONT    IN BROWSE br-titulo  = p-fonte                                      
            tt-titulo.cod_grp_clien              :FGCOLOR IN BROWSE br-titulo  = p-cor                                        
            tt-titulo.cod_grp_clien              :FONT    IN BROWSE br-titulo  = p-fonte                                      
            tt-titulo.cod-gr-cob                 :FGCOLOR IN BROWSE br-titulo  = p-cor                                        
            tt-titulo.cod-gr-cob                 :FONT    IN BROWSE br-titulo  = p-fonte  
            tt-titulo.dat_prev_liquidac          :FGCOLOR IN BROWSE br-titulo  = p-cor       
            tt-titulo.dat_fluxo_tit_acr          :FONT    IN BROWSE br-titulo  = p-fonte     .                                

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-processar esesb071 
PROCEDURE pi-processar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEF VAR l-ok    AS LOG NO-UNDO.
    DEF VAR h-acomp AS HANDLE  NO-UNDO.
    DEF VAR i       AS INTEGER NO-UNDO.
                            
    EMPTY TEMP-TABLE tt-int-pendencias-supcard.

    IF  NOT VALID-HANDLE(h-acomp) THEN DO:
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.                      
        RUN pi-inicializar IN h-acomp (INPUT "Prorrogaá∆o de vencimentos").
    END.

    FOR EACH tt-titulo
        WHERE tt-titulo.flegado:
        
        RUN pi-acompanhar IN h-acomp ("Alterando vencimento t°tulo " + string(i) + "/" + STRING(i-nr-total-titulos)).

        FIND FIRST tit_acr NO-LOCK
            WHERE RECID(tit_acr) = tt-titulo.r-tit-acr NO-ERROR.

         /* CRIAR OCORR“NCIA PARA O SUPLY CARD */
        IF  tit_acr.cod_portador = "9915"  THEN
            RUN pi-gera-ocorrencia-sup-card.
        ELSE 
            RUN pi-cria-temp-table-alt-titulo.     

    END.

    /* ALTERAÄ«O DO VENCIMENTO DOS T÷TULOS */

    IF  CAN-FIND (FIRST tt-titulo
                      WHERE tt-titulo.flegado
                        AND tt-titulo.cod_portador <> "9915") THEN  DO:

        RUN pi-acompanhar IN h-acomp ("Gravando alteraá‰es...").
        RUN pi-Altera-titulo (OUTPUT l-ok).

        RUN utp/ut-msgs.p ("SHOW",
                           15825,
                           "Processamento Conclu°do.").
    END.

    RUN pi-finalizar IN h-acomp.

   

                        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-resultado-processo esesb071 
PROCEDURE pi-resultado-processo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR c-arquivo   AS CHAR NO-UNDO.
    DEF VAR l-cabecalho AS LOG  NO-UNDO.

    ASSIGN c-arquivo = SESSION:TEMP-DIR + 'resultado_' + STRING(DAY(TODAY)) 
                       + '_' + STRING(MONTH(TODAY)) + '_' + STRING(YEAR(TODAY)) 
                       + STRING(TIME) + '.txt'.
    
    OUTPUT STREAM r TO VALUE( c-arquivo ) CONVERT TARGET 'ISO8859-1'.

    PUT STREAM r "--------------------------------------------------------------------------------" SKIP.
    PUT STREAM r "                    ESACR071 - Prorrogaá∆o Vencimento t°tulos" SKIP(2).
    PUT STREAM r "                                R E S U L T A D O" SKIP(2).
    PUT STREAM r "                      Processamento em: " STRING(TODAY, "99/99/9999") " Ös " STRING(TIME, "HH:MM:SS") SKIP(2).
    PUT STREAM r "--------------------------------------------------------------------------------" SKIP(2).

    FOR EACH tt-titulo
        WHERE tt-titulo.flegado
          AND tt-titulo.cod_portador <> "9915":

         IF  CAN-FIND (FIRST tt_log_erros_alter_tit_acr
                        WHERE tt_log_erros_alter_tit_acr.tta_cod_estab       = tt-titulo.cod_estab
                          AND tt_log_erros_alter_tit_acr.tta_num_id_tit_acr  = tt-titulo.num_id_tit_acr ) THEN
             NEXT.

         IF  NOT l-cabecalho THEN DO:
             PUT STREAM r "                         < T÷TULOS PRORROGADOS COM SUCESSO >" SKIP.
             PUT STREAM r "                         -----------------------------------" SKIP(2).
             PUT STREAM r "Estab  EspÇcie  SÇrie  T°tulo     Parcela Vencto Anterior  Prorrogado " SKIP
                          "-----  -------  -----  ---------- ------- ---------------  ---------- " SKIP.
             l-cabecalho = YES.
         END.
         
         PUT STREAM r tt-titulo.cod_estab
                      tt-titulo.cod_espec_docto    AT 08
                      tt-titulo.cod_ser_docto      AT 17
                      tt-titulo.cod_tit_acr        AT 24
                      tt-titulo.cod_parcela        AT 35
                      tt-titulo.dat_vencto_tit_acr AT 43
                      tt-titulo.VENCTO-CALCULADO   AT 60 SKIP.
    END.

    /* COM ERRORS */
    IF  l-cabecalho THEN DO:
        ASSIGN l-cabecalho = NO.
        PUT STREAM r SKIP(2).
    END.
    FOR EACH tt-titulo
        WHERE tt-titulo.flegado
          AND tt-titulo.cod_portador <> "9915":

         FIND tt_log_erros_alter_tit_acr
            WHERE tt_log_erros_alter_tit_acr.tta_cod_estab       = tt-titulo.cod_estab
              AND tt_log_erros_alter_tit_acr.tta_num_id_tit_acr  = tt-titulo.num_id_tit_acr NO-ERROR.
         
         IF  NOT AVAIL tt_log_erros_alter_tit_acr THEN
             NEXT.

         IF  NOT l-cabecalho THEN DO:
             PUT STREAM r "                       < T÷TULOS COM ERRO - N«O PRORROGADOS >" SKIP.
             PUT STREAM r "                       --------------------------------------" SKIP(2).

             PUT STREAM r "Estab  EspÇcie  SÇrie  T°tulo     Parcela  Num Erro Descriá∆o" SKIP
                          "-----  -------  -----  ---------- -------  -------- -----------------------------------------------------------" SKIP.
             l-cabecalho = YES.
         END.
        
         PUT STREAM r tt-titulo.cod_estab
                      tt-titulo.cod_espec_docto                      AT 08
                      tt-titulo.cod_ser_docto                        AT 17
                      tt-titulo.cod_tit_acr                          AT 24
                      tt-titulo.cod_parcela                          AT 35
                      tt_log_erros_alter_tit_acr.ttv_num_mensagem    AT 42
                      tt_log_erros_alter_tit_acr.ttv_des_msg_erro    AT 53 SKIP
                      tt_log_erros_alter_tit_acr.ttv_des_msg_ajuda   AT 53 SKIP(2).
    END.

    /* SUPCARD */
    IF  l-cabecalho THEN DO:
        ASSIGN l-cabecalho = NO.
        PUT STREAM r SKIP(2).
    END.

    FOR EACH tt-int-pendencias-supcard:

        IF  NOT l-cabecalho THEN DO:
            PUT STREAM r "                         < OCORRENCIAS SUPCARD GERADAS >" SKIP.   
            PUT STREAM r "                         -------------------------------" SKIP(2).

            PUT STREAM r "Estab  EspÇcie  SÇrie  T°tulo     Parcela Dias Prorrogaá∆o CGC Cliente     " SKIP
                         "-----  -------  -----  ---------- ------- ---------------- ----------------" SKIP.
            l-cabecalho = YES.
        END.

        PUT STREAM r tt-int-pendencias-supcard.cod-estab
                     tt-int-pendencias-supcard.cod-espec-docto                      AT 08
                     tt-int-pendencias-supcard.cod-ser-docto                        AT 17
                     tt-int-pendencias-supcard.cod-tit-acr                          AT 24
                     tt-int-pendencias-supcard.cod-parcela                          AT 35 
                     tt-int-pendencias-supcard.dias-prorrog                         AT 44
                     tt-int-pendencias-supcard.cnpj-cliente                         AT 61 SKIP.
    END.

    OUTPUT STREAM r CLOSE.

    DOS SILENT START notepad VALUE(c-arquivo).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_retornar_finalid_indic_econ esesb071 
PROCEDURE pi_retornar_finalid_indic_econ :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def Input param p_cod_indic_econ
        as character
        format "x(8)"
        no-undo.
    def Input param p_dat_transacao
        as date
        format "99/99/9999"
        no-undo.
    def output param p_cod_finalid_econ
        as character
        format "x(10)"
        no-undo.


    /************************* Parameter Definition End *************************/

     find first histor_finalid_econ no-lock
        where histor_finalid_econ.cod_indic_econ          = p_cod_indic_econ
        and   histor_finalid_econ.dat_inic_valid_finalid <= p_dat_transacao
        and   histor_finalid_econ.dat_fim_valid_finalid  > p_dat_transacao no-error.

        if avail histor_finalid_econ then
           assign p_cod_finalid_econ = histor_finalid_econ.cod_finalid_econ.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records esesb071  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-titulo"}
  {src/adm/template/snd-list.i "tt-portador"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed esesb071 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDataProrrogadaDiaMES-bkp esesb071 
FUNCTION fnDataProrrogadaDiaMES-bkp RETURNS DATE
  ( INPUT p-vencto-orig AS DATE,
    INPUT p-dia-mes LIKE int-cond-pag-cli.mes) :
    /*------------------------------------------------------------------------------
      Purpose:  Retornar nova data de vencimento de acordo com o dia do màs fixo
                parametrizado no esesb071
    ------------------------------------------------------------------------------*/
    DEF VAR i                AS INTEGER NO-UNDO.
    DEF VAR l-mudou-mes      AS LOG     NO-UNDO.
    DEF VAR da-new-vencto    AS DATE    NO-UNDO.
    DEF VAR i-ultimo-dia-mes AS INTEGER NO-UNDO.
    DEF VAR l-ja-encontrou-data AS LOG INIT NO NO-UNDO.
        
    /* Verifica qual Ç o £ltimo dia do màs da data de vencimento */
    ASSIGN da-new-vencto = date(month(p-vencto-orig), 28, YEAR(p-vencto-orig)) + 5.
           da-new-vencto = date(month(da-new-vencto), 01, YEAR(da-new-vencto)) - 1.
           i-ultimo-dia-mes = DAY(da-new-vencto).
    
    /* Verifica se encontra dia de vencimento cadastrado dentro do mesmo màs */
    DO  i = DAY(p-vencto-orig) TO i-ultimo-dia-mes:
    
        IF  p-dia-mes[i] = YES AND i >= DAY(p-vencto-orig) THEN DO:
            ASSIGN l-ja-encontrou-data = YES.
            LEAVE.
        END.
    END.
    
    /* Busca o pr¢ximo dia v†lido no màs subsequente */
    IF  NOT l-ja-encontrou-data THEN DO:
        DO  i = 1 TO DAY(p-vencto-orig) - 1:
            IF  p-dia-mes[i] = YES THEN 
                LEAVE.    
        END.
        ASSIGN da-new-vencto = date(month(p-vencto-orig), 28, YEAR(p-vencto-orig)) + 5.
               da-new-vencto = DATE(month(da-new-vencto), i, YEAR(da-new-vencto)).
    END.
    ELSE /* no mesmo màs */
        ASSIGN da-new-vencto =  DATE(MONTH(p-vencto-orig), i, YEAR(p-vencto-orig)).
    
    RETURN da-new-vencto.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDataProrrogadaDiaSEMANA-bkp esesb071 
FUNCTION fnDataProrrogadaDiaSEMANA-bkp RETURNS DATE
  ( INPUT p-vencto-orig AS DATE,
    INPUT p-dia-semana LIKE int-cond-pag-cli.semana) :
    /*------------------------------------------------------------------------------
      Purpose:  Retornar nova data de vencimento de acordo com o dia da semana
                parametrizado no esesb071
    ------------------------------------------------------------------------------*/
    DEF VAR i              AS INTEGER NO-UNDO.
    DEF VAR i-soma         AS INTEGER NO-UNDO.
    DEF VAR l-mudou-semana AS LOG     NO-UNDO.

    CASE WEEKDAY(p-vencto-orig):
        /* Domingo */
        WHEN 1 THEN DO: 
            DO  i = 1 TO 5:
                IF p-dia-semana
                    [i] = YES THEN DO:
                    i-soma = i.
                    LEAVE.
                END.
            END.
        END.
        
        /* Segunda */
        WHEN 2 THEN DO: 
            DO  i = 1 TO 5:
                IF p-dia-semana[i] = YES
                AND i >= 1 THEN
                    LEAVE.
                ELSE
                    i-soma = i-soma + 1.
            END.
        END.
    
        /* Teráa */
        WHEN 3 THEN DO: 
            l-mudou-semana = YES.
            DO  i = 2 TO 5:
                IF p-dia-semana[i] = YES THEN DO:
                    l-mudou-semana = NO.
                    LEAVE.
                END.
                ASSIGN i-soma = i-soma + 1.
            END.
            IF  l-mudou-semana THEN
                i-soma = 6.
        END.
    
        /* Quarta */
        WHEN 4 THEN DO: 
            l-mudou-semana = YES.
            DO  i = 3 TO 5:
                IF p-dia-semana[i] = YES THEN DO:
                    l-mudou-semana = NO.
                    LEAVE.
                END.
                ASSIGN i-soma = i-soma + 1.
            END.
            IF  l-mudou-semana THEN DO:
                i-soma = 5.
                DO  i = 1 TO 2:
                    IF p-dia-semana[i] = YES THEN DO:
                        LEAVE.
                    END.
                    ASSIGN i-soma = i-soma + 1.
                END.
            END.
        END.
    
        /* Quinta */
        WHEN 5 THEN DO: 
            l-mudou-semana = YES.
            DO  i = 4 TO 5:
                IF p-dia-semana[i] = YES THEN DO:
                    l-mudou-semana = NO.
                    LEAVE.
                END.
                ASSIGN i-soma = i-soma + 1.
            END.
            
            IF  l-mudou-semana THEN DO:
                i-soma = 4.
                DO  i = 1 TO 3:
                    IF p-dia-semana[i] = YES THEN DO:
                        LEAVE.
                    END.
                    ASSIGN i-soma = i-soma + 1.
                END.
            END.
        END.
    
        /* Sexta */
        WHEN 6 THEN DO: 
            l-mudou-semana = YES.
            IF p-dia-semana[5] = YES THEN DO:
                l-mudou-semana = NO.
            END.
            IF  l-mudou-semana THEN DO:
                i-soma = 3.
                DO  i = 1 TO 4:
                    IF p-dia-semana[i] = YES THEN DO:
                        LEAVE.
                    END.
                    ASSIGN i-soma = i-soma + 1.
                END.
            END.
        END.
        WHEN 7 THEN DO: /* Sabado */
            DO  i = 1 TO 5:
                i-soma = 1.
                IF p-dia-semana[i] = YES THEN DO:
                    i-soma = i-soma + i.
                    LEAVE.
                END.
            END.
        END.
    
    END CASE.
    
    RETURN  p-vencto-orig + i-soma.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnNomeDiaSemana esesb071 
FUNCTION fnNomeDiaSemana RETURNS CHARACTER
  ( INPUT p-dia AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  CASE p-dia:
      WHEN 1 THEN RETURN "Domingo".
      WHEN 2 THEN RETURN "Segunda".
      WHEN 3 THEN RETURN "Teráa"  .
      WHEN 4 THEN RETURN "Quarta" .
      WHEN 5 THEN RETURN "Quinta" .
      WHEN 6 THEN RETURN "Sexta"  .
      WHEN 7 THEN RETURN "S†bado" .
      OTHERWISE  RETURN "".
  END CASE.
  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn_ultimo_dia_util_mes esesb071 
FUNCTION fn_ultimo_dia_util_mes RETURNS LOG
  ( INPUT p-data AS DATE /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
   DEF VAR da-proxima AS DATE NO-UNDO.
   DEF VAR da-nova    AS DATE NO-UNDO.
   
   ASSIGN da-proxima = p-data + 1.
   IF  MONTH(p-data) <> MONTH(da-proxima) THEN
       RETURN YES.
   ELSE DO:
        RUN pi_retornar_dia_util (INPUT emscad.cliente.cod_pais,
                                  INPUT tit_acr.cod_estab,
                                  INPUT "Respons†vel Financeiro",
                                  INPUT 0,
                                  INPUT da-proxima,
                                  OUTPUT da-nova,
                                  OUTPUT v_cod_return).
       IF  MONTH(da-proxima) <> MONTH(da-nova) THEN
           RETURN YES.

   END.
   
   RETURN NO.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

