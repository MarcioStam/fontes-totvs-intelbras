&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-relat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-relat 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCDP114 1.00.00.008}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ESCDP114 ESP}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/*:T Preprocessadores do Template de Relat¢rio                            */
/*:T Obs: Retirar o valor do preprocessador para as p ginas que nÆo existirem  */

&GLOBAL-DEFINE PGSEL f-pg-sel
&GLOBAL-DEFINE PGCLA f-pg-cla
&GLOBAL-DEFINE PGPAR f-pg-par
&GLOBAL-DEFINE PGDIG f-pg-dig
&GLOBAL-DEFINE PGIMP f-pg-imp

&GLOBAL-DEFINE RTF   YES
  
/* Parameters Definitions ---                                           */

/* Temporary Table Definitions ---                                      */

define temp-table tt-param no-undo
    field destino         as integer
    field arquivo         as char format "x(35)"
    field usuario         as char format "x(12)"
    field data-exec       as date
    field hora-exec       as integer
    field classifica      as integer
    field desc-classifica as char format "x(40)"
    field modelo-rtf      as char format "x(35)"
    field l-habilitaRtf   as LOG
    field execucao        as inte
    field diretorio       as char
    field checks          as char.

define temp-table tt-digita no-undo
    field cod-estabel as character format "x(5)"
    field id-brw      as inte
    field nome        as character format "x(40)"
    index id cod-estabel
             id-brw
    index id2 id-brw
              cod-estabel.

define temp-table tt-digita-2 no-undo
    field cod-estabel as character format "x(5)"
    field nome        as character format "x(40)"
    index id cod-estabel.

define buffer b-tt-digita   for tt-digita.
define buffer b-tt-digita-2 for tt-digita-2.

/* Transfer Definitions */

def var raw-param as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.
                    
/* Local Variable Definitions ---                                       */

def var l-ok               as logical no-undo.
def var c-diretorio        as char    no-undo.
def var c-arq-digita       as char    no-undo.
def var c-arq-digita-2     as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-rtf              as char    no-undo.
def var c-modelo-default   as char    no-undo.
def var c-checks           as char    no-undo.

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est  rodando no WebEnabler*/
DEFINE SHARED VARIABLE hWenController AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-relat
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-pg-cla
&Scoped-define BROWSE-NAME br-digita

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-digita tt-digita-2

/* Definitions for BROWSE br-digita                                     */
&Scoped-define FIELDS-IN-QUERY-br-digita tt-digita.cod-estabel tt-digita.nome   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-digita tt-digita.cod-estabel   
&Scoped-define ENABLED-TABLES-IN-QUERY-br-digita tt-digita
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br-digita tt-digita
&Scoped-define SELF-NAME br-digita
&Scoped-define QUERY-STRING-br-digita FOR EACH tt-digita where tt-digita.id-brw = 0
&Scoped-define OPEN-QUERY-br-digita OPEN QUERY br-digita FOR EACH tt-digita where tt-digita.id-brw = 0.
&Scoped-define TABLES-IN-QUERY-br-digita tt-digita
&Scoped-define FIRST-TABLE-IN-QUERY-br-digita tt-digita


/* Definitions for BROWSE br-digita-2                                   */
&Scoped-define FIELDS-IN-QUERY-br-digita-2 tt-digita-2.cod-estabel tt-digita-2.nome   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-digita-2 tt-digita-2.cod-estabel   
&Scoped-define ENABLED-TABLES-IN-QUERY-br-digita-2 tt-digita-2
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br-digita-2 tt-digita-2
&Scoped-define SELF-NAME br-digita-2
&Scoped-define QUERY-STRING-br-digita-2 FOR EACH tt-digita-2
&Scoped-define OPEN-QUERY-br-digita-2 OPEN QUERY br-digita-2 FOR EACH tt-digita-2.
&Scoped-define TABLES-IN-QUERY-br-digita-2 tt-digita-2
&Scoped-define FIRST-TABLE-IN-QUERY-br-digita-2 tt-digita-2


/* Definitions for FRAME f-pg-dig                                       */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-pg-dig ~
    ~{&OPEN-QUERY-br-digita}~
    ~{&OPEN-QUERY-br-digita-2}

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-relat AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-alterar 
     LABEL "Alterar" 
     SIZE 14 BY 1.

DEFINE BUTTON bt-alterar-2 
     LABEL "Alterar" 
     SIZE 14 BY 1.

DEFINE BUTTON bt-inserir 
     LABEL "Inserir" 
     SIZE 14 BY 1.

DEFINE BUTTON bt-inserir-2 
     LABEL "Inserir" 
     SIZE 14 BY 1.

DEFINE BUTTON bt-recuperar 
     LABEL "Recuperar" 
     SIZE 14 BY 1.

DEFINE BUTTON bt-recuperar-2 
     LABEL "Recuperar" 
     SIZE 14 BY 1.

DEFINE BUTTON bt-retirar 
     LABEL "Retirar" 
     SIZE 14 BY 1.

DEFINE BUTTON bt-retirar-2 
     LABEL "Retirar" 
     SIZE 14 BY 1.

DEFINE BUTTON bt-salvar 
     LABEL "Salvar" 
     SIZE 14 BY 1.

DEFINE BUTTON bt-salvar-2 
     LABEL "Salvar" 
     SIZE 14 BY 1.

DEFINE BUTTON bt-arquivo 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-config-impr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-modelo-rtf 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE c-arquivo AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE c-modelo-rtf AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.57 BY .63 NO-UNDO.

DEFINE VARIABLE text-modelo-rtf AS CHARACTER FORMAT "X(256)":U INITIAL "Modelo:" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execu‡Æo" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63 NO-UNDO.

DEFINE VARIABLE text-rtf AS CHARACTER FORMAT "X(256)":U INITIAL "Rich Text Format(RTF)" 
      VIEW-AS TEXT 
     SIZE 20.86 BY .63 NO-UNDO.

DEFINE VARIABLE rs-destino AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 44 BY 1.08 NO-UNDO.

DEFINE VARIABLE rs-execucao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.72 BY .92 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 2.79.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 1.71.

DEFINE RECTANGLE rect-rtf
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 3.54.

DEFINE VARIABLE l-habilitaRtf AS LOGICAL INITIAL no 
     LABEL "RTF" 
     VIEW-AS TOGGLE-BOX
     SIZE 44 BY 1.08 NO-UNDO.

DEFINE BUTTON bt-dir-2 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Escolha o diret¢rio".

DEFINE VARIABLE fi-diretorio AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 124 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 134 BY 2.17.

DEFINE VARIABLE tg-ckd-skd AS LOGICAL INITIAL no 
     LABEL "01 - Analisa Item CKD-SKD pendente de informa‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE tg-div-HomAps-op AS LOGICAL INITIAL no 
     LABEL "24 - Divergˆncias Homens APS Roteiro x Ordem de Produ‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 47 BY .88 NO-UNDO.

DEFINE VARIABLE tg-duplic-ferr-oper AS LOGICAL INITIAL no 
     LABEL "19 - Mais de um mesmo tipo de Recurso na mesma Opera‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 46 BY .88 NO-UNDO.

DEFINE VARIABLE tg-fantasma-x-roteiro AS LOGICAL INITIAL no 
     LABEL "04 - Itens fantasma com Roteiro" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE tg-ferramenta-gm-dif AS LOGICAL INITIAL no 
     LABEL "12 - Mesma Ferramenta em Grupos de M quina diferentes" 
     VIEW-AS TOGGLE-BOX
     SIZE 43 BY .88 NO-UNDO.

DEFINE VARIABLE tg-gm-x-area-prod AS LOGICAL INITIAL no 
     LABEL "16 - Grupos de M quina ativos sem relacionamento com µrea de Produ‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 55 BY .88 NO-UNDO.

DEFINE VARIABLE tg-gm-x-ctrab AS LOGICAL INITIAL no 
     LABEL "02 - Grupos de M quinas ativos sem Centro de Trabalho ou desativados" 
     VIEW-AS TOGGLE-BOX
     SIZE 53 BY .88 NO-UNDO.

DEFINE VARIABLE tg-hom-aps-zerado AS LOGICAL INITIAL no 
     LABEL "18 - Cadastro de Homens APS zerados" 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .88 NO-UNDO.

DEFINE VARIABLE tg-it-oper-x-gm AS LOGICAL INITIAL no 
     LABEL "03 - Itens ativos com Opera‡äes ativas em Grupos de M quina desativados" 
     VIEW-AS TOGGLE-BOX
     SIZE 55 BY .88 NO-UNDO.

DEFINE VARIABLE tg-itens-ativ-sem-oper AS LOGICAL INITIAL no 
     LABEL "17 - Itens ativos sem Opera‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE tg-itens-obsol-dias-cob AS LOGICAL INITIAL no 
     LABEL "11 - Itens obsoletos com dias de cobertura" 
     VIEW-AS TOGGLE-BOX
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE tg-op-abertas-saldo-zero AS LOGICAL INITIAL no 
     LABEL "14 - Ordens de Produ‡Æo abertas com saldo zerado" 
     VIEW-AS TOGGLE-BOX
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE tg-op-x-estrutura-ativ AS LOGICAL INITIAL no 
     LABEL "20 - Ordens de Produ‡Æo de semiacabados sem relacionamento com estrutura ativa" 
     VIEW-AS TOGGLE-BOX
     SIZE 60 BY .88 NO-UNDO.

DEFINE VARIABLE tg-op-x-oper-rot AS LOGICAL INITIAL no 
     LABEL "06 - Ordens de Produ‡Æo abertas sem Opera‡Æo-Roteiro de Fabrica‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 52 BY .88 NO-UNDO.

DEFINE VARIABLE tg-op-x-reservas AS LOGICAL INITIAL no 
     LABEL "07 - Ordens de Produ‡Æo sem Reservas" 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .88 NO-UNDO.

DEFINE VARIABLE tg-oper-mao-obra-gm-incor AS LOGICAL INITIAL no 
     LABEL "22 - Opera‡äes com MÆo de Obra em Grupo de M quina incorreto" 
     VIEW-AS TOGGLE-BOX
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE tg-oper-sem-atributos-smd AS LOGICAL INITIAL no 
     LABEL "13 - Opera‡äes sem atributos no SMD/Injetoras" 
     VIEW-AS TOGGLE-BOX
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE tg-oper-tempo-zerado AS LOGICAL INITIAL no 
     LABEL "10 - Opera‡äes com tempo zerado" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE tg-oper-un-dif AS LOGICAL INITIAL no 
     LABEL "15 - Opera‡äes com Unidade diferente de 1 ou diferente de Minutos" 
     VIEW-AS TOGGLE-BOX
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE tg-oper-x-recurso AS LOGICAL INITIAL no 
     LABEL "05 - Opera‡äes sem cadastro de Recurso Secund rio" 
     VIEW-AS TOGGLE-BOX
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE tg-ordens-compra-ant AS LOGICAL INITIAL no 
     LABEL "08 - Ordens de Compra anteriores … data de hoje" 
     VIEW-AS TOGGLE-BOX
     SIZE 37 BY .88 NO-UNDO.

DEFINE VARIABLE tg-ped-venda-obsol AS LOGICAL INITIAL no 
     LABEL "09 - Pedidos de Venda de Itens obsoletos" 
     VIEW-AS TOGGLE-BOX
     SIZE 33 BY .88 NO-UNDO.

DEFINE VARIABLE tg-reserva-x-estr-ativ AS LOGICAL INITIAL no 
     LABEL "23 - Reservas de Ordens de Produ‡Æo abertas sem relacto com estrutura ativa" 
     VIEW-AS TOGGLE-BOX
     SIZE 57 BY .88 NO-UNDO.

DEFINE VARIABLE tg-uma-oper-gm-infinitos AS LOGICAL INITIAL no 
     LABEL "21 - Itens com apenas 1 Opera‡Æo em Grupos de M quinas infinitos" 
     VIEW-AS TOGGLE-BOX
     SIZE 50 BY .88 NO-UNDO.

DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-executar 
     LABEL "Executar" 
     SIZE 10 BY 1.

DEFINE IMAGE im-pg-cla
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-dig
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-imp
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-par
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-sel
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 145.57 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 0    
     SIZE 143.72 BY .13
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder
     EDGE-PIXELS 1 GRAPHIC-EDGE  NO-FILL   
     SIZE 145.57 BY 23.75
     FGCOLOR 0 .

DEFINE RECTANGLE rt-folder-left
     EDGE-PIXELS 0    
     SIZE .43 BY 23.42
     BGCOLOR 15 .

DEFINE RECTANGLE rt-folder-right
     EDGE-PIXELS 0    
     SIZE .43 BY 23.5
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder-top
     EDGE-PIXELS 0    
     SIZE 143 BY .13
     BGCOLOR 15 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-digita FOR 
      tt-digita SCROLLING.

DEFINE QUERY br-digita-2 FOR 
      tt-digita-2 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-digita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-digita w-relat _FREEFORM
  QUERY br-digita DISPLAY
      tt-digita.cod-estabel format "x(5)"  width 7  column-label "Estab"
tt-digita.nome        format "x(40)" width 42 column-label "Nome"
ENABLE
tt-digita.cod-estabel
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 70 BY 10
         BGCOLOR 15 FONT 1
         TITLE BGCOLOR 15 "Relat¢rios 01, 13, 17 e 18".

DEFINE BROWSE br-digita-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-digita-2 w-relat _FREEFORM
  QUERY br-digita-2 DISPLAY
      tt-digita-2.cod-estabel format "x(5)"  width 7  column-label "Estab"
tt-digita-2.nome        format "x(40)" width 42 column-label "Nome"
ENABLE
tt-digita-2.cod-estabel
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 70 BY 10
         BGCOLOR 15 FONT 1
         TITLE BGCOLOR 15 "09 - Estabelecimentos dos Pedidos de Venda de Itens Obsoletos".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-pg-cla
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 141.72 BY 22.75
         FONT 1 WIDGET-ID 100.

DEFINE FRAME f-pg-par
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 141.72 BY 22.75
         FONT 1 WIDGET-ID 100.

DEFINE FRAME f-relat
     bt-executar AT ROW 26.5 COL 2.14 HELP
          "Dispara a execu‡Æo do relat¢rio"
     bt-cancelar AT ROW 26.5 COL 13.14 HELP
          "Fechar"
     bt-ajuda AT ROW 26.5 COL 135.72 HELP
          "Ajuda"
     RECT-1 AT ROW 26.25 COL 1.14
     RECT-6 AT ROW 25.96 COL 2.14
     rt-folder-top AT ROW 2.54 COL 2.14
     rt-folder-right AT ROW 2.58 COL 145.72
     rt-folder-left AT ROW 2.54 COL 2.14
     rt-folder AT ROW 2.5 COL 1.14
     im-pg-cla AT ROW 1.5 COL 49.29
     im-pg-dig AT ROW 1.5 COL 17.86
     im-pg-imp AT ROW 1.5 COL 33.57
     im-pg-par AT ROW 1.5 COL 65
     im-pg-sel AT ROW 1.5 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 146.14 BY 26.79
         FONT 1
         DEFAULT-BUTTON bt-executar WIDGET-ID 100.

DEFINE FRAME f-pg-dig
     br-digita AT ROW 1 COL 1
     br-digita-2 AT ROW 1 COL 72 WIDGET-ID 200
     bt-inserir AT ROW 11 COL 1
     bt-alterar AT ROW 11 COL 15
     bt-retirar AT ROW 11 COL 29
     bt-salvar AT ROW 11 COL 43
     bt-recuperar AT ROW 11 COL 57
     bt-inserir-2 AT ROW 11 COL 72 WIDGET-ID 4
     bt-alterar-2 AT ROW 11 COL 86 WIDGET-ID 2
     bt-retirar-2 AT ROW 11 COL 100 WIDGET-ID 8
     bt-salvar-2 AT ROW 11 COL 114 WIDGET-ID 10
     bt-recuperar-2 AT ROW 11 COL 128 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 141.72 BY 22.75
         FONT 1 WIDGET-ID 100.

DEFINE FRAME f-pg-imp
     rs-destino AT ROW 1.63 COL 3.29 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     bt-config-impr AT ROW 2.71 COL 43.29 HELP
          "Configura‡Æo da impressora"
     bt-arquivo AT ROW 2.71 COL 43.29 HELP
          "Escolha do nome do arquivo"
     c-arquivo AT ROW 2.75 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     l-habilitaRtf AT ROW 4.83 COL 3.29
     c-modelo-rtf AT ROW 6.63 COL 3 HELP
          "Nome do arquivo de modelo do relat¢rio" NO-LABEL
     bt-modelo-rtf AT ROW 6.63 COL 43 HELP
          "Escolha do nome do arquivo"
     rs-execucao AT ROW 8.88 COL 2.86 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-destino AT ROW 1.04 COL 3.86 NO-LABEL
     text-rtf AT ROW 4.17 COL 1.14 COLON-ALIGNED NO-LABEL
     text-modelo-rtf AT ROW 5.96 COL 1.14 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 8.13 COL 1.14 COLON-ALIGNED NO-LABEL
     rect-rtf AT ROW 4.46 COL 2
     RECT-7 AT ROW 1.33 COL 2.14
     RECT-9 AT ROW 8.33 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 141.72 BY 22.75
         FONT 1 WIDGET-ID 100.

DEFINE FRAME f-pg-sel
     fi-diretorio AT ROW 2 COL 6 COLON-ALIGNED HELP
          "Diret¢rio em que os arquivos serÆo salvos" NO-LABEL WIDGET-ID 28
     bt-dir-2 AT ROW 1.92 COL 131.86 HELP
          "Escolha o diret¢rio" WIDGET-ID 26
     tg-ckd-skd AT ROW 3.75 COL 5 WIDGET-ID 2
     tg-gm-x-ctrab AT ROW 4.75 COL 5 WIDGET-ID 4
     tg-it-oper-x-gm AT ROW 5.75 COL 5 WIDGET-ID 6
     tg-fantasma-x-roteiro AT ROW 6.75 COL 5 WIDGET-ID 8
     tg-oper-x-recurso AT ROW 7.75 COL 5 WIDGET-ID 10
     tg-op-x-oper-rot AT ROW 8.75 COL 5 WIDGET-ID 12
     tg-op-x-reservas AT ROW 9.75 COL 5 WIDGET-ID 14
     tg-ordens-compra-ant AT ROW 10.75 COL 5 WIDGET-ID 52
     tg-ped-venda-obsol AT ROW 11.75 COL 5 WIDGET-ID 54
     tg-oper-tempo-zerado AT ROW 12.75 COL 5 WIDGET-ID 56
     tg-itens-obsol-dias-cob AT ROW 13.75 COL 5 WIDGET-ID 58
     tg-ferramenta-gm-dif AT ROW 14.75 COL 5 WIDGET-ID 60
     tg-oper-sem-atributos-smd AT ROW 15.75 COL 5 WIDGET-ID 62
     tg-op-abertas-saldo-zero AT ROW 16.75 COL 5 WIDGET-ID 64
     tg-oper-un-dif AT ROW 17.75 COL 5 WIDGET-ID 66
     tg-gm-x-area-prod AT ROW 18.75 COL 5 WIDGET-ID 68
     tg-itens-ativ-sem-oper AT ROW 19.75 COL 5 WIDGET-ID 70
     tg-hom-aps-zerado AT ROW 20.75 COL 5 WIDGET-ID 72
     tg-duplic-ferr-oper AT ROW 21.75 COL 5 WIDGET-ID 74
     tg-op-x-estrutura-ativ AT ROW 22.75 COL 5 WIDGET-ID 76
     tg-uma-oper-gm-infinitos AT ROW 3.75 COL 77 WIDGET-ID 78
     tg-oper-mao-obra-gm-incor AT ROW 4.75 COL 77 WIDGET-ID 80
     tg-reserva-x-estr-ativ AT ROW 5.75 COL 77 WIDGET-ID 82
     tg-div-HomAps-op AT ROW 6.75 COL 77 WIDGET-ID 84
     "Diret¢rio" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 1.13 COL 9 WIDGET-ID 50
     RECT-11 AT ROW 1.38 COL 5 WIDGET-ID 48
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 3
         SIZE 141.72 BY 22.75
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-relat
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-relat ASSIGN
         HIDDEN             = YES
         TITLE              = "Consistˆncia de Dados APS"
         HEIGHT             = 26.79
         WIDTH              = 146.14
         MAX-HEIGHT         = 41.33
         MAX-WIDTH          = 274.29
         VIRTUAL-HEIGHT     = 41.33
         VIRTUAL-WIDTH      = 274.29
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-relat 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-relat.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-relat
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-pg-cla
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME f-pg-dig
                                                                        */
/* BROWSE-TAB br-digita 1 f-pg-dig */
/* BROWSE-TAB br-digita-2 br-digita f-pg-dig */
/* SETTINGS FOR BUTTON bt-alterar IN FRAME f-pg-dig
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-alterar-2 IN FRAME f-pg-dig
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-retirar IN FRAME f-pg-dig
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-retirar-2 IN FRAME f-pg-dig
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-salvar IN FRAME f-pg-dig
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-salvar-2 IN FRAME f-pg-dig
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME f-pg-imp
                                                                        */
/* SETTINGS FOR EDITOR c-modelo-rtf IN FRAME f-pg-imp
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN text-destino IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Destino".

ASSIGN 
       text-modelo-rtf:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Modelo:".

/* SETTINGS FOR FILL-IN text-modo IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Execu‡Æo".

ASSIGN 
       text-rtf:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Rich Text Format(RTF)".

/* SETTINGS FOR FRAME f-pg-par
                                                                        */
/* SETTINGS FOR FRAME f-pg-sel
   Custom                                                               */
/* SETTINGS FOR FRAME f-relat
                                                                        */
/* SETTINGS FOR IMAGE im-pg-cla IN FRAME f-relat
   NO-ENABLE                                                            */
ASSIGN 
       im-pg-cla:HIDDEN IN FRAME f-relat           = TRUE.

/* SETTINGS FOR IMAGE im-pg-par IN FRAME f-relat
   NO-ENABLE                                                            */
ASSIGN 
       im-pg-par:HIDDEN IN FRAME f-relat           = TRUE.

/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-6 IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-left IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-right IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rt-folder-top IN FRAME f-relat
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-relat)
THEN w-relat:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-digita
/* Query rebuild information for BROWSE br-digita
     _START_FREEFORM
OPEN QUERY br-digita FOR EACH tt-digita where tt-digita.id-brw = 0.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-digita */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-digita-2
/* Query rebuild information for BROWSE br-digita-2
     _START_FREEFORM
OPEN QUERY br-digita-2 FOR EACH tt-digita-2.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-digita-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-imp
/* Query rebuild information for FRAME f-pg-imp
     _Query            is NOT OPENED
*/  /* FRAME f-pg-imp */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-pg-sel
/* Query rebuild information for FRAME f-pg-sel
     _Query            is NOT OPENED
*/  /* FRAME f-pg-sel */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-relat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-relat w-relat
ON END-ERROR OF w-relat /* Consistˆncia de Dados APS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-relat w-relat
ON WINDOW-CLOSE OF w-relat /* Consistˆncia de Dados APS */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-digita
&Scoped-define FRAME-NAME f-pg-dig
&Scoped-define SELF-NAME br-digita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita w-relat
ON DEL OF br-digita IN FRAME f-pg-dig /* Relat¢rios 01, 13, 17 e 18 */
DO:
   apply 'choose':U to bt-retirar in frame f-pg-dig.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita w-relat
ON END-ERROR OF br-digita IN FRAME f-pg-dig /* Relat¢rios 01, 13, 17 e 18 */
ANYWHERE 
DO:
    if  br-digita:new-row in frame f-pg-dig then do:
        if  avail tt-digita then
            delete tt-digita.
        if  br-digita:delete-current-row() in frame f-pg-dig then. 
    end.                                                               
    else do:
        get current br-digita.
        display tt-digita.cod-estabel
                tt-digita.nome with browse br-digita. 
    end.
    return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita w-relat
ON ENTER OF br-digita IN FRAME f-pg-dig /* Relat¢rios 01, 13, 17 e 18 */
ANYWHERE
DO:
  apply 'tab':U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita w-relat
ON INS OF br-digita IN FRAME f-pg-dig /* Relat¢rios 01, 13, 17 e 18 */
DO:
   apply 'choose':U to bt-inserir in frame f-pg-dig.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita w-relat
ON OFF-END OF br-digita IN FRAME f-pg-dig /* Relat¢rios 01, 13, 17 e 18 */
DO:
   apply 'entry':U to bt-inserir in frame f-pg-dig.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita w-relat
ON OFF-HOME OF br-digita IN FRAME f-pg-dig /* Relat¢rios 01, 13, 17 e 18 */
DO:
  apply 'entry':U to bt-recuperar in frame f-pg-dig.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita w-relat
ON ROW-ENTRY OF br-digita IN FRAME f-pg-dig /* Relat¢rios 01, 13, 17 e 18 */
DO:
   /*:T trigger para inicializar campos da temp table de digita‡Æo */
   if  br-digita:new-row in frame f-pg-dig then do:
/*        assign tt-digita.nome:screen-value in browse br-digita = "". */
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita w-relat
ON ROW-LEAVE OF br-digita IN FRAME f-pg-dig /* Relat¢rios 01, 13, 17 e 18 */
DO:
    /*:T  aqui que a grava‡Æo da linha da temp-table ‚ efetivada.
       Por‚m as valida‡äes dos registros devem ser feitas na procedure pi-executar,
       no local indicado pelo coment rio */
    
    if br-digita:NEW-ROW in frame f-pg-dig then 
    do transaction on error undo, return no-apply:
        create tt-digita.
        assign input browse br-digita tt-digita.cod-estabel
               input browse br-digita tt-digita.nome.
    
        br-digita:CREATE-RESULT-LIST-ENTRY() in frame f-pg-dig.
    end.
    else do transaction on error undo, return no-apply:
        assign input browse br-digita tt-digita.cod-estabel
               input browse br-digita tt-digita.nome.
    end.

    if avail tt-digita
    then for first estabelec fields (nome) no-lock
             where estabelec.cod-estabel = tt-digita.cod-estabel:
             assign tt-digita.nome:screen-value in browse br-digita = trim(estabelec.nome).
             assign input browse br-digita tt-digita.nome.
         end. /* for first estabelec */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-digita-2
&Scoped-define SELF-NAME br-digita-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita-2 w-relat
ON DEL OF br-digita-2 IN FRAME f-pg-dig /* 09 - Estabelecimentos dos Pedidos de Venda de Itens Obsoletos */
DO:
   apply 'choose':U to bt-retirar-2 in frame f-pg-dig.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita-2 w-relat
ON END-ERROR OF br-digita-2 IN FRAME f-pg-dig /* 09 - Estabelecimentos dos Pedidos de Venda de Itens Obsoletos */
ANYWHERE 
DO:
    if  br-digita-2:new-row in frame f-pg-dig then do:
        if  avail tt-digita-2 then
            delete tt-digita-2.
        if  br-digita-2:delete-current-row() in frame f-pg-dig then. 
    end.                                                               
    else do:
        get current br-digita-2.
        display tt-digita-2.cod-estabel
                tt-digita-2.nome with browse br-digita-2. 
    end.
    return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita-2 w-relat
ON ENTER OF br-digita-2 IN FRAME f-pg-dig /* 09 - Estabelecimentos dos Pedidos de Venda de Itens Obsoletos */
ANYWHERE
DO:
  apply 'tab':U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita-2 w-relat
ON INS OF br-digita-2 IN FRAME f-pg-dig /* 09 - Estabelecimentos dos Pedidos de Venda de Itens Obsoletos */
DO:
   apply 'choose':U to bt-inserir-2 in frame f-pg-dig.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita-2 w-relat
ON OFF-END OF br-digita-2 IN FRAME f-pg-dig /* 09 - Estabelecimentos dos Pedidos de Venda de Itens Obsoletos */
DO:
   apply 'entry':U to bt-inserir-2 in frame f-pg-dig.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita-2 w-relat
ON OFF-HOME OF br-digita-2 IN FRAME f-pg-dig /* 09 - Estabelecimentos dos Pedidos de Venda de Itens Obsoletos */
DO:
  apply 'entry':U to bt-recuperar-2 in frame f-pg-dig.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita-2 w-relat
ON ROW-ENTRY OF br-digita-2 IN FRAME f-pg-dig /* 09 - Estabelecimentos dos Pedidos de Venda de Itens Obsoletos */
DO:
   /*:T trigger para inicializar campos da temp table de digita‡Æo */
   if  br-digita-2:new-row in frame f-pg-dig then do:
/*        assign tt-digita-2.nome:screen-value in browse br-digita-2 = "". */
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-digita-2 w-relat
ON ROW-LEAVE OF br-digita-2 IN FRAME f-pg-dig /* 09 - Estabelecimentos dos Pedidos de Venda de Itens Obsoletos */
DO:
    /*:T  aqui que a grava‡Æo da linha da temp-table ‚ efetivada.
       Por‚m as valida‡äes dos registros devem ser feitas na procedure pi-executar,
       no local indicado pelo coment rio */
    
    if br-digita-2:NEW-ROW in frame f-pg-dig then 
    do transaction on error undo, return no-apply:
        create tt-digita-2.
        assign input browse br-digita-2 tt-digita-2.cod-estabel
               input browse br-digita-2 tt-digita-2.nome.
    
        br-digita-2:CREATE-RESULT-LIST-ENTRY() in frame f-pg-dig.
    end.
    else do transaction on error undo, return no-apply:
        assign input browse br-digita-2 tt-digita-2.cod-estabel
               input browse br-digita-2 tt-digita-2.nome.
    end.

    if avail tt-digita-2
    then for first estabelec fields (nome) no-lock
             where estabelec.cod-estabel = tt-digita-2.cod-estabel:
             assign tt-digita-2.nome:screen-value in browse br-digita-2 = trim(estabelec.nome).
             assign input browse br-digita-2 tt-digita-2.nome.
         end. /* for first estabelec */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-relat
ON CHOOSE OF bt-ajuda IN FRAME f-relat /* Ajuda */
DO:
   {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-dig
&Scoped-define SELF-NAME bt-alterar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-alterar w-relat
ON CHOOSE OF bt-alterar IN FRAME f-pg-dig /* Alterar */
DO:
   apply 'entry':U to tt-digita.cod-estabel in browse br-digita. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-alterar-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-alterar-2 w-relat
ON CHOOSE OF bt-alterar-2 IN FRAME f-pg-dig /* Alterar */
DO:
   apply 'entry':U to tt-digita-2.cod-estabel in browse br-digita-2. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo w-relat
ON CHOOSE OF bt-arquivo IN FRAME f-pg-imp
DO:
    {include/i-rparq.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar w-relat
ON CHOOSE OF bt-cancelar IN FRAME f-relat /* Fechar */
DO:
   apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-config-impr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-config-impr w-relat
ON CHOOSE OF bt-config-impr IN FRAME f-pg-imp
DO:
   {include/i-rpimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-sel
&Scoped-define SELF-NAME bt-dir-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-dir-2 w-relat
ON CHOOSE OF bt-dir-2 IN FRAME f-pg-sel
DO:
    def var l-cancel  as logi no-undo.
    def var c-dir-aux as char no-undo format "x(50)".

    run utp/ut-dir.p (input "Escolha um diret¢rio",
                      output c-dir-aux,
                      output l-cancel ).

    if not l-cancel
    then do:
         assign fi-diretorio = c-dir-aux.
         disp fi-diretorio with frame f-pg-sel.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME bt-executar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executar w-relat
ON CHOOSE OF bt-executar IN FRAME f-relat /* Executar */
DO:
   do  on error undo, return no-apply:
       run pi-executar.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-dig
&Scoped-define SELF-NAME bt-inserir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-inserir w-relat
ON CHOOSE OF bt-inserir IN FRAME f-pg-dig /* Inserir */
DO:
    assign bt-alterar:SENSITIVE in frame f-pg-dig = yes
           bt-retirar:SENSITIVE in frame f-pg-dig = yes
           bt-salvar:SENSITIVE in frame f-pg-dig  = yes.

    if avail tt-digita
    then apply 'leave' to tt-digita.cod-estabel in browse br-digita.
    
    if num-results("br-digita":U) > 0 then
        br-digita:INSERT-ROW("after":U) in frame f-pg-dig.
    else do transaction:
        create tt-digita.
        
        open query br-digita for each tt-digita where tt-digita.id-brw = 0.
        
        apply "entry":U to tt-digita.cod-estabel in browse br-digita. 
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-inserir-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-inserir-2 w-relat
ON CHOOSE OF bt-inserir-2 IN FRAME f-pg-dig /* Inserir */
DO:
    assign bt-alterar-2:SENSITIVE in frame f-pg-dig = yes
           bt-retirar-2:SENSITIVE in frame f-pg-dig = yes
           bt-salvar-2:SENSITIVE  in frame f-pg-dig  = yes.

    if avail tt-digita-2
    then apply 'leave' to tt-digita-2.cod-estabel in browse br-digita-2.
    
    if num-results("br-digita-2":U) > 0 then
        br-digita-2:INSERT-ROW("after":U) in frame f-pg-dig.
    else do transaction:
        create tt-digita-2.
        
        open query br-digita-2 for each tt-digita-2.
        
        apply "entry":U to tt-digita-2.cod-estabel in browse br-digita-2. 
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME bt-modelo-rtf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-modelo-rtf w-relat
ON CHOOSE OF bt-modelo-rtf IN FRAME f-pg-imp
DO:
    def var c-arq-conv  as char no-undo.
    def var l-ok as logical no-undo.

    assign c-modelo-rtf = replace(input frame {&frame-name} c-modelo-rtf, "/", "~\").
    SYSTEM-DIALOG GET-FILE c-arq-conv
       FILTERS "*.rtf" "*.rtf",
               "*.*" "*.*"
       DEFAULT-EXTENSION "rtf"
       INITIAL-DIR "modelos" 
       MUST-EXIST
       USE-FILENAME
       UPDATE l-ok.
    if  l-ok = yes then
        assign c-modelo-rtf:screen-value in frame {&frame-name}  = replace(c-arq-conv, "~\", "/"). 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-dig
&Scoped-define SELF-NAME bt-recuperar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-recuperar w-relat
ON CHOOSE OF bt-recuperar IN FRAME f-pg-dig /* Recuperar */
DO:
    {include/i-rprcd.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-recuperar-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-recuperar-2 w-relat
ON CHOOSE OF bt-recuperar-2 IN FRAME f-pg-dig /* Recuperar */
DO:
    system-dialog get-file c-arq-digita-2
        filters "*.dig" "*.dig",
                "*.*" "*.*"
        default-extension "*.dig"
        must-exist
        use-filename
        update l-ok.

    if l-ok 
    then do:
         empty temp-table tt-digita-2.

         input from value(c-arq-digita-2) no-echo.

         create tt-digita-2.
         import tt-digita-2.

         input close.

         delete tt-digita-2.

         open query br-digita-2 for each tt-digita-2.

         do with frame f-pg-dig:
             if num-results("br-digita-2":U) > 0 
             then assign bt-alterar-2:sensitive = yes
                         bt-retirar-2:sensitive = yes
                         bt-salvar-2:sensitive  = yes.
             else assign bt-alterar-2:sensitive = no
                         bt-retirar-2:sensitive = no
                         bt-salvar-2:sensitive  = no.
         end. /* do with frame f-pg-dig */
    end. /* if l-ok */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-retirar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-retirar w-relat
ON CHOOSE OF bt-retirar IN FRAME f-pg-dig /* Retirar */
DO:
    if  br-digita:num-selected-rows > 0 then do on error undo, return no-apply:
        get current br-digita.
        delete tt-digita.
        if  br-digita:delete-current-row() in frame f-pg-dig then.
    end.
    
    if num-results("br-digita":U) = 0 then
        assign bt-alterar:SENSITIVE in frame f-pg-dig = no
               bt-retirar:SENSITIVE in frame f-pg-dig = no
               bt-salvar:SENSITIVE in frame f-pg-dig  = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-retirar-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-retirar-2 w-relat
ON CHOOSE OF bt-retirar-2 IN FRAME f-pg-dig /* Retirar */
DO:
    if  br-digita-2:num-selected-rows > 0 then do on error undo, return no-apply:
        get current br-digita-2.
        delete tt-digita-2.
        if  br-digita-2:delete-current-row() in frame f-pg-dig then.
    end.
    
    if num-results("br-digita-2":U) = 0 then
        assign bt-alterar-2:SENSITIVE in frame f-pg-dig = no
               bt-retirar-2:SENSITIVE in frame f-pg-dig = no
               bt-salvar-2:SENSITIVE in frame f-pg-dig  = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-salvar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-salvar w-relat
ON CHOOSE OF bt-salvar IN FRAME f-pg-dig /* Salvar */
DO:
   {include/i-rpsvd.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-salvar-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-salvar-2 w-relat
ON CHOOSE OF bt-salvar-2 IN FRAME f-pg-dig /* Salvar */
DO:
    def var r-tt-digita-2 as rowid no-undo.

    if avail tt-digita-2
    then assign r-tt-digita-2 = rowid(tt-digita-2).

    system-dialog get-file c-arq-digita-2
        filters "*.dig" "*.dig",
                "*.*" "*.*"
        ask-overwrite
        default-extension "*.dig"
        save-as
        create-test-file
        use-filename
        update l-ok.

    if l-ok
    then do:
         output to value(c-arq-digita-2).
         for each tt-digita-2:
             export tt-digita-2.
         end.
         output close.

         reposition br-digita-2 to rowid(r-tt-digita-2) no-error.
    end. /* if l-ok */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-relat
&Scoped-define SELF-NAME im-pg-cla
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-cla w-relat
ON MOUSE-SELECT-CLICK OF im-pg-cla IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-dig
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-dig w-relat
ON MOUSE-SELECT-CLICK OF im-pg-dig IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-imp w-relat
ON MOUSE-SELECT-CLICK OF im-pg-imp IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-par
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-par w-relat
ON MOUSE-SELECT-CLICK OF im-pg-par IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME im-pg-sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-sel w-relat
ON MOUSE-SELECT-CLICK OF im-pg-sel IN FRAME f-relat
DO:
    run pi-troca-pagina.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&Scoped-define SELF-NAME l-habilitaRtf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-habilitaRtf w-relat
ON VALUE-CHANGED OF l-habilitaRtf IN FRAME f-pg-imp /* RTF */
DO:
    &IF "{&RTF}":U = "YES":U &THEN
    RUN pi-habilitaRtf.
    &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-destino w-relat
ON VALUE-CHANGED OF rs-destino IN FRAME f-pg-imp
DO:
/*Alterado 15/02/2005 - tech1007 - Evento alterado para correto funcionamento dos novos widgets
  utilizados para a funcionalidade de RTF*/
do  with frame f-pg-imp:
    case self:screen-value:
        when "1" then do:
            assign c-arquivo:sensitive    = no
                   bt-arquivo:visible     = no
                   bt-config-impr:visible = YES
                   /*Alterado 17/02/2005 - tech1007 - Realizado teste de preprocessador para
                     verificar se o RTF est  ativo*/
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = NO
                   l-habilitaRtf:SCREEN-VALUE IN FRAME f-pg-imp = "No"
                   l-habilitaRtf = NO
                   &endif
                   /*Fim alteracao 17/02/2005*/
                   .
        end.
        when "2" then do:
            assign c-arquivo:sensitive     = yes
                   bt-arquivo:visible      = yes
                   bt-config-impr:visible  = NO
                   /*Alterado 17/02/2005 - tech1007 - Realizado teste de preprocessador para
                     verificar se o RTF est  ativo*/
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = YES
                   &endif
                   /*Fim alteracao 17/02/2005*/
                   .
        end.
        when "3" then do:
            assign c-arquivo:sensitive     = no
                   bt-arquivo:visible      = no
                   bt-config-impr:visible  = no
                   /*Alterado 17/02/2005 - tech1007 - Realizado teste de preprocessador para
                     verificar se o RTF est  ativo*/
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = YES
                   &endif
                   /*Fim alteracao 17/02/2005*/
                   .
            /*Alterado 15/02/2005 - tech1007 - Teste para funcionar corretamente no WebEnabler*/
            &IF "{&RTF}":U = "YES":U &THEN
            IF VALID-HANDLE(hWenController) THEN DO:
                ASSIGN l-habilitaRtf:sensitive  = NO
                       l-habilitaRtf:SCREEN-VALUE IN FRAME f-pg-imp = "No"
                       l-habilitaRtf = NO.
            END.
            &endif
            /*Fim alteracao 15/02/2005*/
        end.
    end case.
end.
&IF "{&RTF}":U = "YES":U &THEN
RUN pi-habilitaRtf.
&endif
/*Fim alteracao 15/02/2005*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-execucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-execucao w-relat
ON VALUE-CHANGED OF rs-execucao IN FRAME f-pg-imp
DO:
   {include/i-rprse.i}

   if  input frame f-pg-imp rs-destino  = 2
   and input frame f-pg-imp rs-execucao = 2
   then assign bt-dir-2:sensitive        in frame f-pg-sel = no
               fi-diretorio                                = input frame f-pg-sel fi-diretorio
               fi-diretorio:sensitive    in frame f-pg-sel = no
               fi-diretorio:screen-value in frame f-pg-sel = "".
   else assign bt-dir-2:sensitive        in frame f-pg-sel = yes
               fi-diretorio:sensitive    in frame f-pg-sel = yes
               fi-diretorio:screen-value in frame f-pg-sel = fi-diretorio.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-cla
&Scoped-define BROWSE-NAME br-digita
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-relat 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

{utp/ut9000.i "ESCDP114" "1.00.00.008"}

/*:T inicializa‡äes do template de relat¢rio */
{include/i-rpini.i}

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

&GLOBAL-DEFINE mguni_version 2.06A

{include/i-rplbl.i}

{include/i_dbvers.i}

on 'leave':U of tt-digita.cod-estabel in browse br-digita
do:
    if not avail tt-digita
    then return.

    assign tt-digita.nome = "".
    assign input browse br-digita tt-digita.cod-estabel.

    for first estabelec fields (nome) no-lock
        where estabelec.cod-estabel = tt-digita.cod-estabel:
        assign tt-digita.nome = trim(estabelec.nome).
    end. /* for first estabelec */

    disp tt-digita.nome with browse br-digita.

    return.
end.

on 'leave':U of tt-digita-2.cod-estabel in browse br-digita-2
do:
    if not avail tt-digita-2
    then return.

    assign tt-digita-2.nome = "".
    assign input browse br-digita-2 tt-digita-2.cod-estabel.

    for first estabelec fields (nome) no-lock
        where estabelec.cod-estabel = tt-digita-2.cod-estabel:
        assign tt-digita-2.nome = trim(estabelec.nome).
    end. /* for first estabelec */

    disp tt-digita-2.nome with browse br-digita-2.

    return.
end.

assign wh-label-sel:format       = "x(13)"
       wh-label-sel:width        = 13
       wh-label-sel:screen-value = "Parƒmetros1".
/* assign wh-label-cla:screen-value = "Parƒmetros2". */
assign wh-label-cla:screen-value = ""
       wh-label-cla:hidden       = yes.
/* assign wh-label-par:format       = "x(13)"        */
/*        wh-label-par:width        = 13             */
/*        wh-label-par:screen-value = "Parƒmetros3". */
assign wh-label-par:screen-value = ""
       wh-label-par:hidden       = yes.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO  ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    RUN enable_UI.

    empty temp-table tt-digita-2.
    
    if avail usuar_mestre
    then do:
         assign c-diretorio = if length(usuar_mestre.nom_subdir_spool) <> 0
                              then caps(replace(usuar_mestre.nom_dir_spool, " ", "~/") +
                                   "~/"                                                +
                                   replace(usuar_mestre.nom_subdir_spool, " ", "~/")   +
                                   "~/")
                              else "".

         assign file-info:file-name = c-diretorio.
        
         if file-info:full-pathname = ?
         or not file-info:file-type matches "*D*"
         then do:
              assign c-diretorio = caps(replace(usuar_mestre.nom_dir_spool, " ", "~/")).

              assign file-info:file-name = c-diretorio.
              
              if file-info:full-pathname = ?
              or not file-info:file-type matches "*D*"
              then assign c-diretorio = "".
         end.
    end.

    if c-diretorio = ""
    then assign c-diretorio = session:temp-directory.

    assign fi-diretorio:screen-value in frame f-pg-sel = c-diretorio.

    run pi-cria-estab (input 1,
                       input "103").
    run pi-cria-estab (input 1,
                       input "104").

    {&open-query-br-digita}

    run pi-cria-estab (input 2,
                       input "103").
    run pi-cria-estab (input 2,
                       input "104").
    run pi-cria-estab (input 2,
                       input "110").

    {&open-query-br-digita-2}

    if temp-table tt-digita:has-records
    then assign bt-alterar:sensitive in frame f-pg-dig = yes
                bt-retirar:sensitive in frame f-pg-dig = yes
                bt-salvar:sensitive  in frame f-pg-dig = yes.

    if temp-table tt-digita-2:has-records
    then assign bt-alterar-2:sensitive in frame f-pg-dig = yes
                bt-retirar-2:sensitive in frame f-pg-dig = yes
                bt-salvar-2:sensitive  in frame f-pg-dig = yes.

    rs-destino:disable("Impressora") in frame f-pg-imp.
    
    {include/i-rpmbl.i}
  
    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-relat  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-relat  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-relat  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-relat)
  THEN DELETE WIDGET w-relat.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-relat  _DEFAULT-ENABLE
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
  ENABLE im-pg-dig im-pg-imp im-pg-sel bt-executar bt-cancelar bt-ajuda 
      WITH FRAME f-relat IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  VIEW FRAME f-pg-cla IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-cla}
  ENABLE br-digita br-digita-2 bt-inserir bt-recuperar bt-inserir-2 
         bt-recuperar-2 
      WITH FRAME f-pg-dig IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-dig}
  DISPLAY rs-destino c-arquivo l-habilitaRtf c-modelo-rtf rs-execucao text-rtf 
          text-modelo-rtf 
      WITH FRAME f-pg-imp IN WINDOW w-relat.
  ENABLE rect-rtf RECT-7 RECT-9 rs-destino bt-config-impr bt-arquivo c-arquivo 
         l-habilitaRtf bt-modelo-rtf rs-execucao text-rtf text-modelo-rtf 
      WITH FRAME f-pg-imp IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-imp}
  VIEW FRAME f-pg-par IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-par}
  DISPLAY fi-diretorio tg-ckd-skd tg-gm-x-ctrab tg-it-oper-x-gm 
          tg-fantasma-x-roteiro tg-oper-x-recurso tg-op-x-oper-rot 
          tg-op-x-reservas tg-ordens-compra-ant tg-ped-venda-obsol 
          tg-oper-tempo-zerado tg-itens-obsol-dias-cob tg-ferramenta-gm-dif 
          tg-oper-sem-atributos-smd tg-op-abertas-saldo-zero tg-oper-un-dif 
          tg-gm-x-area-prod tg-itens-ativ-sem-oper tg-hom-aps-zerado 
          tg-duplic-ferr-oper tg-op-x-estrutura-ativ tg-uma-oper-gm-infinitos 
          tg-oper-mao-obra-gm-incor tg-reserva-x-estr-ativ tg-div-HomAps-op 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  ENABLE fi-diretorio bt-dir-2 tg-ckd-skd tg-gm-x-ctrab tg-it-oper-x-gm 
         tg-fantasma-x-roteiro tg-oper-x-recurso tg-op-x-oper-rot 
         tg-op-x-reservas tg-ordens-compra-ant tg-ped-venda-obsol 
         tg-oper-tempo-zerado tg-itens-obsol-dias-cob tg-ferramenta-gm-dif 
         tg-oper-sem-atributos-smd tg-op-abertas-saldo-zero tg-oper-un-dif 
         tg-gm-x-area-prod tg-itens-ativ-sem-oper tg-hom-aps-zerado 
         tg-duplic-ferr-oper tg-op-x-estrutura-ativ tg-uma-oper-gm-infinitos 
         tg-oper-mao-obra-gm-incor tg-reserva-x-estr-ativ RECT-11 
         tg-div-HomAps-op 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
  VIEW w-relat.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-relat 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-estab w-relat 
PROCEDURE pi-cria-estab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-cod-brw     as inte                    no-undo.
def input parameter p-cod-estabel like estabelec.cod-estabel no-undo.

if (p-cod-brw = 1
and can-find(first tt-digita where
                   tt-digita.cod-estabel = p-cod-estabel
               and tt-digita.id-brw      = 0))
or (p-cod-brw = 2
and can-find(first tt-digita-2 where
                   tt-digita-2.cod-estabel = p-cod-estabel))
then return "OK".

for first estabelec field (cod-estabel nome) no-lock
    where estabelec.cod-estabel = p-cod-estabel:
    case p-cod-brw:
        when 1
        then do:
             create tt-digita.
             assign tt-digita.cod-estabel = estabelec.cod-estabel
                    tt-digita.nome        = trim(estabelec.nome).
             find current tt-digita no-error.
        end. /* when 1 */
        when 2
        then do:
             create tt-digita-2.
             assign tt-digita-2.cod-estabel = estabelec.cod-estabel
                    tt-digita-2.nome        = trim(estabelec.nome).
             find current tt-digita-2 no-error.
        end. /* when 2 */
    end case. /* case p-cod-brw */
end. /* for first estabelec */

return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar w-relat 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
for each tt-digita use-index id2
   where tt-digita.id-brw = 1:
    delete tt-digita.
end.

do on error undo, return error on stop  undo, return error:
    {include/i-rpexa.i}
    /*14/02/2005 - tech1007 - Alterada condicao para nÆo considerar mais o RTF como destino*/
    if input frame f-pg-imp rs-destino = 2 and
       input frame f-pg-imp rs-execucao = 1 then do:
        run utp/ut-vlarq.p (input input frame f-pg-imp c-arquivo).
        
        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show":U, input 73, input "").
            
            apply "MOUSE-SELECT-CLICK":U to im-pg-imp in frame f-relat.
            apply "ENTRY":U to c-arquivo in frame f-pg-imp.
            return error.
        end.
    end.

    /*14/02/2005 - tech1007 - Teste efetuado para nao permitir modelo em branco*/
    &IF "{&RTF}":U = "YES":U &THEN
    IF ( INPUT FRAME f-pg-imp c-modelo-rtf = "" AND
         INPUT FRAME f-pg-imp l-habilitaRtf = "Yes" ) OR
       ( SEARCH(INPUT FRAME f-pg-imp c-modelo-rtf) = ? AND
         input frame f-pg-imp rs-execucao = 1 AND
         INPUT FRAME f-pg-imp l-habilitaRtf = "Yes" )
         THEN DO:
        run utp/ut-msgs.p (input "show":U, input 73, input "").        
        apply "MOUSE-SELECT-CLICK":U to im-pg-imp in frame f-relat.
        /*30/12/2004 - tech1007 - Evento removido pois causa problemas no WebEnabler*/
        /*apply "CHOOSE":U to bt-modelo-rtf in frame f-pg-imp.*/
        return error.
    END.
    &endif
    /*Fim teste Modelo*/
    
    /*:T Coloque aqui as valida‡äes da p gina de Digita‡Æo, lembrando que elas devem
       apresentar uma mensagem de erro cadastrada, posicionar nesta p gina e colocar
       o focus no campo com problemas */
    /*browse br-digita:SET-REPOSITIONED-ROW (browse br-digita:DOWN, "ALWAYS":U).*/
    if tg-ckd-skd:checked                in frame f-pg-sel
    or tg-oper-sem-atributos-smd:checked in frame f-pg-sel
    or tg-itens-ativ-sem-oper:checked    in frame f-pg-sel
    or tg-hom-aps-zerado:checked         in frame f-pg-sel
    then do:
         run pi-valida-brw1.
         if return-value <> "OK"
         then return error.
    end. /* if tg-ckd-skd-x-po:checked in frame f-pg-sel */

    if tg-ped-venda-obsol:checked in frame f-pg-sel
    then do:
         run pi-valida-brw2.
         if return-value <> "OK"
         then return error.
    end. /* if tg-ped-venda-obsol:checked in frame f-pg-sel */
    
    /*:T Coloque aqui as valida‡äes das outras p ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p gina com 
       problemas e colocar o focus no campo com problemas */
    run pi-trata-dir.
    if return-value = "NOK"
    then return 'ADM-ERROR'.

    do with frame f-pg-sel:
        assign c-checks = string(tg-ckd-skd:checked,"S/N")
               c-checks = c-checks + "," + string(tg-gm-x-ctrab:checked            ,"S/N")
               c-checks = c-checks + "," + string(tg-it-oper-x-gm:checked          ,"S/N")
               c-checks = c-checks + "," + string(tg-fantasma-x-roteiro:checked    ,"S/N")
               c-checks = c-checks + "," + string(tg-oper-x-recurso:checked        ,"S/N")
               c-checks = c-checks + "," + string(tg-op-x-oper-rot:checked         ,"S/N")
               c-checks = c-checks + "," + string(tg-op-x-reservas:checked         ,"S/N")
               c-checks = c-checks + "," + string(tg-ordens-compra-ant:checked     ,"S/N")
               c-checks = c-checks + "," + string(tg-ped-venda-obsol:checked       ,"S/N")
               c-checks = c-checks + "," + string(tg-oper-tempo-zerado:checked     ,"S/N")
               c-checks = c-checks + "," + string(tg-itens-obsol-dias-cob:checked  ,"S/N")
               c-checks = c-checks + "," + string(tg-ferramenta-gm-dif:checked     ,"S/N")
               c-checks = c-checks + "," + string(tg-oper-sem-atributos-smd:checked,"S/N")
               c-checks = c-checks + "," + string(tg-op-abertas-saldo-zero:checked ,"S/N")
               c-checks = c-checks + "," + string(tg-oper-un-dif:checked           ,"S/N")
               c-checks = c-checks + "," + string(tg-gm-x-area-prod:checked        ,"S/N")
               c-checks = c-checks + "," + string(tg-itens-ativ-sem-oper:checked   ,"S/N")
               c-checks = c-checks + "," + string(tg-hom-aps-zerado:checked        ,"S/N")
               c-checks = c-checks + "," + string(tg-duplic-ferr-oper:checked      ,"S/N")
               c-checks = c-checks + "," + string(tg-op-x-estrutura-ativ:checked   ,"S/N")
               c-checks = c-checks + "," + string(tg-uma-oper-gm-infinitos:checked ,"S/N")
               c-checks = c-checks + "," + string(tg-oper-mao-obra-gm-incor:checked,"S/N")
               c-checks = c-checks + "," + string(tg-reserva-x-estr-ativ:checked   ,"S/N")
               c-checks = c-checks + "," + string(tg-div-HomAps-op:checked         ,"S/N").

        if lookup("S",c-checks) = 0 
        then do:
             apply "MOUSE-SELECT-CLICK":U to im-pg-sel in frame f-relat.
             run utp/ut-msgs.p (input "show", input 17567, input "Ao menos um parƒmetro deve ser marcado").
             return 'ADM-ERROR'.
        end.
    end. /* do with frame f-pg-sel */

    for each tt-digita-2:
        create tt-digita.
        assign tt-digita.cod-estabel = tt-digita-2.cod-estabel
               tt-digita.id-brw      = 1
               tt-digita.nome        = tt-digita-2.nome.       
    end.
    find current tt-digita no-error.
    
    /*:T Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
       para o programa RP.P */
    
    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame f-pg-imp rs-destino
           tt-param.data-exec       = today
           tt-param.hora-exec       = time
/*            tt-param.classifica      = input frame f-pg-cla rs-classif                   */
/*            tt-param.desc-classifica = entry((tt-param.classifica - 1) * 2 + 1,          */
/*                                             rs-classif:radio-buttons in frame f-pg-cla) */
           &IF "{&RTF}":U = "YES":U &THEN
           tt-param.modelo-rtf      = INPUT FRAME f-pg-imp c-modelo-rtf
           /*Alterado 14/02/2005 - tech1007 - Armazena a informa‡Æo se o RTF est  habilitado ou nÆo*/
           tt-param.l-habilitaRtf     = INPUT FRAME f-pg-imp l-habilitaRtf
           /*Fim alteracao 14/02/2005*/ 
           &endif
           .
    
    /*Alterado 14/02/2005 - tech1007 - Alterado o teste para verificar se a op‡Æo de RTF est  selecionada*/
    if tt-param.destino = 1 
    then assign tt-param.arquivo = "".
    else if  tt-param.destino = 2
         then assign tt-param.arquivo = input frame f-pg-imp c-arquivo.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    /*Fim alteracao 14/02/2005*/

    /*:T Coloque aqui a/l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */
    assign tt-param.execucao  = input frame f-pg-imp rs-execucao
           tt-param.diretorio = input frame f-pg-sel fi-diretorio
           tt-param.checks    = c-checks. 
    
    /*:T Executar do programa RP.P que ir  criar o relat¢rio */
    {include/i-rpexb.i}
    
    SESSION:SET-WAIT-STATE("general":U).
    
    {include/i-rprun.i esp/cdp/escdp114rp.p}
    
    {include/i-rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
/*     {include/i-rptrm.i} */
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-dir w-relat 
PROCEDURE pi-trata-dir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
assign c-diretorio = trim(input frame f-pg-sel fi-diretorio).

if c-diretorio = ""
then do:
     if  input frame f-pg-imp rs-execucao = 2
     and input frame f-pg-imp rs-destino  = 2
     then return "OK".

     apply "MOUSE-SELECT-CLICK":U to im-pg-sel in frame f-relat.
     run utp/ut-msgs.p (input "show", input 17567, input "Diret¢rio deve ser informado!").
     apply 'entry' to fi-diretorio in frame f-pg-sel.
     return "NOK".
end.

if  substr(c-diretorio,length(c-diretorio),1) <> "/"
and substr(c-diretorio,length(c-diretorio),1) <> "\"
then assign c-diretorio = c-diretorio + "/".

if c-diretorio begins "\\"
then assign c-diretorio = replace(c-diretorio,"/","\").
else assign c-diretorio = replace(c-diretorio,"\","/").

assign fi-diretorio:screen-value in frame f-pg-sel = c-diretorio.

assign file-info:file-name = c-diretorio.

if file-info:full-pathname = ?
or not file-info:file-type matches "*D*"
then do:
     apply "MOUSE-SELECT-CLICK":U to im-pg-sel in frame f-relat.
     run utp/ut-msgs.p (input "show":U, input 5749, input "").
     apply 'entry' to fi-diretorio in frame f-pg-sel.
     return "NOK".
end.

return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-pagina w-relat 
PROCEDURE pi-troca-pagina :
/*:T------------------------------------------------------------------------------
  Purpose: Gerencia a Troca de P gina (folder)   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{include/i-rptrp.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-brw1 w-relat 
PROCEDURE pi-valida-brw1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define var r-tt-digita as rowid no-undo.

if can-find(first tt-digita where
                  tt-digita.cod-estabel = ""
              and tt-digita.id-brw      = 0)
then do:
     for each tt-digita
        where tt-digita.cod-estabel = ""
          and tt-digita.id-brw      = 0:
         delete tt-digita.
     end.

     {&open-query-br-digita}

     if num-results("br-digita":U) = 0 
     then assign bt-alterar:sensitive in frame f-pg-dig = no
                 bt-retirar:sensitive in frame f-pg-dig = no
                 bt-salvar:sensitive  in frame f-pg-dig = no.
     else assign bt-alterar:sensitive in frame f-pg-dig = yes
                 bt-retirar:sensitive in frame f-pg-dig = yes
                 bt-salvar:sensitive  in frame f-pg-dig = yes.
end.


for each tt-digita no-lock:
    if tt-digita.id-brw <> 0
    then next.

    assign r-tt-digita = rowid(tt-digita).
    
    /*:T Valida‡Æo de duplicidade de registro na temp-table tt-digita */
    find first b-tt-digita where b-tt-digita.cod-estabel = tt-digita.cod-estabel and
                                 b-tt-digita.id-brw      = tt-digita.id-brw      and
                                 rowid(b-tt-digita) <> rowid(tt-digita) no-lock no-error.
    if avail b-tt-digita then do:
        apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.
        reposition br-digita to rowid rowid(b-tt-digita).
        
        run utp/ut-msgs.p (input "show":U, input 108, input "").
        apply "ENTRY":U to tt-digita.cod-estabel in browse br-digita.
        
        return "NOK".
    end.
    
    /*:T As demais valida‡äes devem ser feitas aqui */
    if not can-find(first estabelec where
                          estabelec.cod-estabel = tt-digita.cod-estabel
                          no-lock)
    then do:
        assign browse br-digita:CURRENT-COLUMN = tt-digita.cod-estabel:HANDLE in browse br-digita.
        
        apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.
        reposition br-digita to rowid r-tt-digita.
        
        run utp/ut-msgs.p (input "show", input 17567, input "Estabelecimento nÆo cadastrado").
        apply "ENTRY":U to tt-digita.cod-estabel in browse br-digita.
        
        return "NOK".             
    end.       
end. /* for each tt-digita */

if not temp-table tt-digita:has-records
then do:
     apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.
     run utp/ut-msgs.p (input "show", input 17567, input "Deve ser informado ao menos um estabelecimento para essa(s) an lise(s)!").
     return "NOK".  
end. /* if not temp-table tt-digita:has-records */

return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-brw2 w-relat 
PROCEDURE pi-valida-brw2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define var r-tt-digita-2 as rowid no-undo.

/* if input frame f-pg-imp rs-execucao = 2                                                                                                   */
/* then do:                                                                                                                                  */
/*      apply "MOUSE-SELECT-CLICK":U to im-pg-sel in frame f-relat.                                                                          */
/*      run utp/ut-msgs.p (input "show", input 17567, input "Pedidos de Venda de Itens obsoletos ‚ disfuncional quando da execu‡Æo Batch!"). */
/*      apply "ENTRY":U to tg-ped-venda-obsol in frame f-pg-sel.                                                                             */
/*      return "NOK".                                                                                                                        */
/* end.                                                                                                                                      */

if can-find(first tt-digita-2 where
                  tt-digita-2.cod-estabel = "")
then do:
     for each tt-digita-2
        where tt-digita-2.cod-estabel = "".
         delete tt-digita-2.
     end.

     {&open-query-br-digita-2}

     if num-results("br-digita-2":U) = 0 
     then assign bt-alterar-2:sensitive in frame f-pg-dig = no
                 bt-retirar-2:sensitive in frame f-pg-dig = no
                 bt-salvar-2:sensitive  in frame f-pg-dig = no.
     else assign bt-alterar-2:sensitive in frame f-pg-dig = yes
                 bt-retirar-2:sensitive in frame f-pg-dig = yes
                 bt-salvar-2:sensitive  in frame f-pg-dig = yes.
end.


for each tt-digita-2 no-lock:
    assign r-tt-digita-2 = rowid(tt-digita-2).
    
    /*:T Valida‡Æo de duplicidade de registro na temp-table tt-digita */
    find first b-tt-digita-2 where b-tt-digita-2.cod-estabel = tt-digita-2.cod-estabel and 
                                 rowid(b-tt-digita-2) <> rowid(tt-digita-2) no-lock no-error.
    if avail b-tt-digita-2 then do:
        apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.
        reposition br-digita-2 to rowid rowid(b-tt-digita-2).
        
        run utp/ut-msgs.p (input "show":U, input 108, input "").
        apply "ENTRY":U to tt-digita-2.cod-estabel in browse br-digita-2.
        
        return "NOK".
    end.
    
    /*:T As demais valida‡äes devem ser feitas aqui */
    if not can-find(first estabelec where
                          estabelec.cod-estabel = tt-digita-2.cod-estabel
                          no-lock)
    then do:
        assign browse br-digita-2:CURRENT-COLUMN = tt-digita-2.cod-estabel:HANDLE in browse br-digita-2.
        
        apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.
        reposition br-digita-2 to rowid r-tt-digita-2.
        
        run utp/ut-msgs.p (input "show", input 17567, input "Estabelecimento nÆo cadastrado").
        apply "ENTRY":U to tt-digita-2.cod-estabel in browse br-digita-2.
        
        return "NOK".             
    end.       
end. /* for each tt-digita */

if not temp-table tt-digita-2:has-records
then do:
     apply "MOUSE-SELECT-CLICK":U to im-pg-dig in frame f-relat.
     run utp/ut-msgs.p (input "show", input 17567, input "Deve ser informado ao menos um estabelecimento para an lise de Pedidos Venda!").
     return "NOK".  
end. /* if not temp-table tt-digita:has-records */

return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-relat  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-digita-2"}
  {src/adm/template/snd-list.i "tt-digita"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-relat 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
  
  run pi-trata-state (p-issuer-hdl, p-state).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

