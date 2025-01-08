&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME w-relat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-relat 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/******************************************************************************
**  Programa.: ESCRM001.W
**  Objetivo.: Programa de integraá∆o do Datasul EMS 2 com o Microsoft CRM
**             Dynamics.
**  Autor....: Gustavo Eduardo Tamanini - Exponencial TI - 27.07.2010
**             Fabiano Sakae Ribeiro    - Exponencial TI - 02.08.2010
*******************************************************************************/
{include/i-prgvrs.i ESCRM001 2.04.00.000}

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Preprocessadores do Template de Relat¢rio                            */
/* Obs: Retirar o valor do preprocessador para as p†ginas que n∆o existirem  */
&GLOBAL-DEFINE PGSEL f-pg-sel
&GLOBAL-DEFINE PGCLA 
&GLOBAL-DEFINE PGPAR 
&GLOBAL-DEFINE PGDIG 
&GLOBAL-DEFINE PGIMP f-pg-imp
  
/* Parameters Definitions ---                                           */

/* Temporary Table Definitions ---                                      */
{esp/crm/escrm001.i}

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem             AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo           AS CHARACTER FORMAT "x(30)":U
    INDEX id ordem.

DEFINE BUFFER b-tt-digita FOR tt-digita.

/* Transfer Definitions */
DEFINE VARIABLE raw-param AS RAW         NO-UNDO.

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita AS RAW.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE l-ok         AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-arq-digita AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-terminal   AS CHARACTER   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-relat
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-pg-imp

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-7 RECT-9 rs-destino bt-arquivo ~
bt-config-impr c-arquivo rs-execucao 
&Scoped-Define DISPLAYED-OBJECTS rs-destino c-arquivo rs-execucao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-firstDay w-relat 
FUNCTION fn-firstDay RETURNS DATE
  ( INPUT ipDAta AS DATE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-LastDay w-relat 
FUNCTION fn-LastDay RETURNS DATE
  ( INPUT data AS DATE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-mesComp w-relat 
FUNCTION fn-mesComp RETURNS CHARACTER
  ( INPUT data-comp AS DATE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-relat AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-arquivo 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-config-impr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE c-arquivo AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 6.14 BY .63 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL " Execuá∆o" 
      VIEW-AS TEXT 
     SIZE 8.14 BY .63 NO-UNDO.

DEFINE VARIABLE rs-destino AS INTEGER INITIAL 3 
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
     SIZE 46.29 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 1.71.

DEFINE VARIABLE dt-fim-nota AS DATE FORMAT "99/99/9999":U INITIAL 12/31/10 
     VIEW-AS FILL-IN 
     SIZE 9.57 BY .79 NO-UNDO.

DEFINE VARIABLE dt-fim-pedido AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 9.57 BY .79 NO-UNDO.

DEFINE VARIABLE dt-ini-nota AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 9.57 BY .79 NO-UNDO.

DEFINE VARIABLE dt-ini-pedido AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 9.57 BY .79 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75 BY 8.17.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73 BY 7.29.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73 BY 1.79.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75 BY 2.75.

DEFINE VARIABLE tg-automatico AS LOGICAL INITIAL no 
     LABEL "Execuá∆o Automatica (Pedidos e Notas)" 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .63 TOOLTIP "Execuá∆o Automatica (Pedidos e Notas)" NO-UNDO.

DEFINE VARIABLE tg-canal AS LOGICAL INITIAL yes 
     LABEL "Canal de Venda" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .63 TOOLTIP "Canal de Venda" NO-UNDO.

DEFINE VARIABLE tg-cidade AS LOGICAL INITIAL yes 
     LABEL "Cidade" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .63 TOOLTIP "Cidade" NO-UNDO.

DEFINE VARIABLE tg-cond AS LOGICAL INITIAL yes 
     LABEL "Condiá∆o de Pagamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .63 TOOLTIP "Condiá∆o de Pagamento" NO-UNDO.

DEFINE VARIABLE tg-crm-contato AS LOGICAL INITIAL no 
     LABEL "Contato" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .63 TOOLTIP "Contato" NO-UNDO.

DEFINE VARIABLE tg-crm-emitente AS LOGICAL INITIAL no 
     LABEL "Emitente" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .63 TOOLTIP "Emitente" NO-UNDO.

DEFINE VARIABLE tg-crm-local-entrega AS LOGICAL INITIAL no 
     LABEL "Local Entrega" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .63 TOOLTIP "Local Entrega" NO-UNDO.

DEFINE VARIABLE tg-crm-relac-cliente AS LOGICAL INITIAL no 
     LABEL "Relacionamento Cliente" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .63 TOOLTIP "Relacionamento Cliente" NO-UNDO.

DEFINE VARIABLE tg-emitente AS LOGICAL INITIAL yes 
     LABEL "Cliente" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .63 TOOLTIP "Cliente" NO-UNDO.

DEFINE VARIABLE tg-encerrar-programa AS LOGICAL INITIAL yes 
     LABEL "Encerrar Execuá∆o do Programa" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .63 TOOLTIP "Encerrar Execuá∆o do Programa" NO-UNDO.

DEFINE VARIABLE tg-estabelec AS LOGICAL INITIAL yes 
     LABEL "Estabelecimento" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .63 TOOLTIP "Estabelecimento" NO-UNDO.

DEFINE VARIABLE tg-estrut-prod AS LOGICAL INITIAL yes 
     LABEL "Estrutura Produto" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .63 TOOLTIP "Estrutura Produto" NO-UNDO.

DEFINE VARIABLE tg-fm-comercial AS LOGICAL INITIAL yes 
     LABEL "Fam°lia Comercial" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .63 TOOLTIP "Fam°lia Comercial" NO-UNDO.

DEFINE VARIABLE tg-fm-material AS LOGICAL INITIAL yes 
     LABEL "Fam°lia Material" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .63 TOOLTIP "Fam°lia Material" NO-UNDO.

DEFINE VARIABLE tg-gr-estoque AS LOGICAL INITIAL yes 
     LABEL "Grupo Estoque" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .63 TOOLTIP "Grupo Estoque" NO-UNDO.

DEFINE VARIABLE tg-grp-cli AS LOGICAL INITIAL yes 
     LABEL "Grupo Cliente" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .63 TOOLTIP "Grupo Cliente" NO-UNDO.

DEFINE VARIABLE tg-local AS LOGICAL INITIAL yes 
     LABEL "Local de Entrega" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .63 TOOLTIP "Local de Entrega" NO-UNDO.

DEFINE VARIABLE tg-marcar-desmarcar-crm-ems AS LOGICAL INITIAL no 
     LABEL "Marcar / Desmarcar Todos" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .63 TOOLTIP "Marcar / Desmarcar Todos" NO-UNDO.

DEFINE VARIABLE tg-marcar-desmarcar-ems-crm AS LOGICAL INITIAL yes 
     LABEL "Marcar / Desmarcar Todos" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .63 TOOLTIP "Marcar / Desmarcar Todos" NO-UNDO.

DEFINE VARIABLE tg-mensagem AS LOGICAL INITIAL yes 
     LABEL "Mensagem" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .63 TOOLTIP "Mensagem" NO-UNDO.

DEFINE VARIABLE tg-nat-oper AS LOGICAL INITIAL yes 
     LABEL "Natureza Operaá∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .63 TOOLTIP "Natureza Operaá∆o" NO-UNDO.

DEFINE VARIABLE tg-nf AS LOGICAL INITIAL yes 
     LABEL "Nota Fiscal" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .63 TOOLTIP "Nota Fiscal" NO-UNDO.

DEFINE VARIABLE tg-pedido AS LOGICAL INITIAL yes 
     LABEL "Pedido" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .63 TOOLTIP "Pedido" NO-UNDO.

DEFINE VARIABLE tg-portador AS LOGICAL INITIAL yes 
     LABEL "Portador" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .63 TOOLTIP "Portador" NO-UNDO.

DEFINE VARIABLE tg-produto AS LOGICAL INITIAL yes 
     LABEL "Produto" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .63 TOOLTIP "Produto" NO-UNDO.

DEFINE VARIABLE tg-receita AS LOGICAL INITIAL yes 
     LABEL "Receita Padr∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .63 TOOLTIP "Receita Padr∆o" NO-UNDO.

DEFINE VARIABLE tg-relac AS LOGICAL INITIAL yes 
     LABEL "Relacionamento Cliente" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .63 TOOLTIP "Relacionamento Cliente" NO-UNDO.

DEFINE VARIABLE tg-representante AS LOGICAL INITIAL yes 
     LABEL "Representante" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .63 TOOLTIP "Representante" NO-UNDO.

DEFINE VARIABLE tg-rota AS LOGICAL INITIAL yes 
     LABEL "Rota" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .63 TOOLTIP "Rota" NO-UNDO.

DEFINE VARIABLE tg-tb-finan AS LOGICAL INITIAL yes 
     LABEL "Tabela Financiamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .63 TOOLTIP "Tabela Financiamento" NO-UNDO.

DEFINE VARIABLE tg-tb-preco AS LOGICAL INITIAL yes 
     LABEL "Tabela Preáo" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .63 TOOLTIP "Tabela Preáo" NO-UNDO.

DEFINE VARIABLE tg-transp AS LOGICAL INITIAL yes 
     LABEL "Transportadora" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .63 TOOLTIP "Transportadora" NO-UNDO.

DEFINE VARIABLE tg-unid-feder AS LOGICAL INITIAL yes 
     LABEL "Unidade Federaá∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .63 TOOLTIP "Unidade Federaá∆o" NO-UNDO.

DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-executar 
     LABEL "Executar" 
     SIZE 10 BY 1.

DEFINE IMAGE im-pg-imp
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE IMAGE im-pg-sel
     FILENAME "image\im-fldup":U
     SIZE 15.72 BY 1.21.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 79 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 0    
     SIZE 78.72 BY .13
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder
     EDGE-PIXELS 1 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 12.25
     FGCOLOR 0 .

DEFINE RECTANGLE rt-folder-left
     EDGE-PIXELS 0    
     SIZE .43 BY 11.21
     BGCOLOR 15 .

DEFINE RECTANGLE rt-folder-right
     EDGE-PIXELS 0    
     SIZE .43 BY 11.17
     BGCOLOR 7 .

DEFINE RECTANGLE rt-folder-top
     EDGE-PIXELS 0    
     SIZE 78.72 BY .13
     BGCOLOR 15 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-relat
     bt-executar AT ROW 15.29 COL 3 HELP
          "Dispara a execuá∆o do relat¢rio"
     bt-cancelar AT ROW 15.29 COL 14 HELP
          "Fechar"
     bt-ajuda AT ROW 15.29 COL 70 HELP
          "Ajuda"
     im-pg-sel AT ROW 1.5 COL 2.14
     im-pg-imp AT ROW 1.5 COL 17.86
     rt-folder AT ROW 2.5 COL 2
     rt-folder-top AT ROW 2.54 COL 2.14
     rt-folder-left AT ROW 2.54 COL 2.14
     rt-folder-right AT ROW 2.67 COL 80.43
     RECT-6 AT ROW 14.54 COL 2.14
     RECT-1 AT ROW 15.04 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81.14 BY 15.67
         FONT 1
         DEFAULT-BUTTON bt-executar.

DEFINE FRAME f-pg-imp
     rs-destino AT ROW 2.38 COL 3.29 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     bt-arquivo AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
     bt-config-impr AT ROW 3.58 COL 43.29 HELP
          "Configuraá∆o da impressora"
     c-arquivo AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rs-execucao AT ROW 5.75 COL 3.29 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-destino AT ROW 1.63 COL 3.86 NO-LABEL
     text-modo AT ROW 5 COL 3.86 NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.85
         SIZE 76.86 BY 10.62
         FONT 1.

DEFINE FRAME f-pg-sel
     tg-cidade AT ROW 8.33 COL 5.29
     tg-unid-feder AT ROW 8.33 COL 29.43
     tg-marcar-desmarcar-ems-crm AT ROW 1.67 COL 5.29 HELP
          "Marcar / Desmarcar Todos"
     tg-canal AT ROW 2.33 COL 5.29 HELP
          "Canal de Venda"
     tg-cond AT ROW 3 COL 5.29 HELP
          "Condiá∆o de Pagamento"
     tg-grp-cli AT ROW 3.67 COL 5.29 HELP
          "Grupo Cliente"
     tg-portador AT ROW 4.33 COL 5.29 HELP
          "Portador"
     tg-receita AT ROW 5 COL 5.29 HELP
          "Receita Padr∆o"
     tg-representante AT ROW 5.67 COL 5.29 HELP
          "Representante"
     tg-transp AT ROW 6.33 COL 5.29 HELP
          "Transportadora"
     tg-fm-material AT ROW 7 COL 5.29 HELP
          "Fam°lia Material"
     tg-fm-comercial AT ROW 7.67 COL 5.29 HELP
          "Fam°lia Comercial"
     tg-gr-estoque AT ROW 2.33 COL 29.43 HELP
          "Grupo Estoque"
     tg-produto AT ROW 3 COL 29.43 HELP
          "Produto"
     tg-estrut-prod AT ROW 3.67 COL 29.43 HELP
          "Estrutura Produto"
     tg-tb-preco AT ROW 4.38 COL 29.43 HELP
          "Tabela Preáo"
     tg-rota AT ROW 5 COL 29.43 HELP
          "Rota"
     tg-estabelec AT ROW 5.67 COL 29.43 HELP
          "Estabelecimento"
     tg-tb-finan AT ROW 6.33 COL 29.43 HELP
          "Tabela Financiamento"
     tg-nat-oper AT ROW 7 COL 29.43 HELP
          "Natureza Operaá∆o"
     tg-mensagem AT ROW 7.67 COL 29.43 HELP
          "Mensagem"
     tg-emitente AT ROW 2.33 COL 52.43 HELP
          "Cliente"
     tg-local AT ROW 3 COL 52.43 HELP
          "Local de Entrega"
     tg-relac AT ROW 3.67 COL 52.43 HELP
          "Relacionamento Cliente"
     tg-pedido AT ROW 4.38 COL 52.43 HELP
          "Pedido"
     dt-ini-pedido AT ROW 5.08 COL 50.29 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     dt-fim-pedido AT ROW 5.08 COL 63.86 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     tg-nf AT ROW 5.96 COL 52.43 HELP
          "Nota Fiscal"
     tg-marcar-desmarcar-crm-ems AT ROW 10.13 COL 5.29 HELP
          "Marcar / Desmarcar Todos"
     tg-crm-emitente AT ROW 10.79 COL 5.29 HELP
          "Emitente"
     tg-crm-contato AT ROW 11.46 COL 5.29 HELP
          "Contato"
     tg-crm-local-entrega AT ROW 10.79 COL 29.43 HELP
          "Local Entrega"
     tg-crm-relac-cliente AT ROW 11.46 COL 29.43 HELP
          "Relacionamento Cliente"
     tg-encerrar-programa AT ROW 10.08 COL 50 WIDGET-ID 4
     dt-ini-nota AT ROW 6.67 COL 50.29 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     dt-fim-nota AT ROW 6.67 COL 63.86 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     tg-automatico AT ROW 1.5 COL 46 WIDGET-ID 22
     " Integrar Datasul EMS 2 para Microsoft CRM Dynamics" VIEW-AS TEXT
          SIZE 38.57 BY .54 AT ROW 1.04 COL 3.57
     " Integrar Microsoft CRM Dynamics para Datasul EMS 2" VIEW-AS TEXT
          SIZE 38.57 BY .54 AT ROW 9.5 COL 3.57
     RECT-10 AT ROW 1.33 COL 2
     RECT-11 AT ROW 1.96 COL 3
     RECT-14 AT ROW 9.75 COL 2
     RECT-12 AT ROW 10.42 COL 3
     IMAGE-1 AT ROW 5.08 COL 60.86 WIDGET-ID 10
     IMAGE-2 AT ROW 5.08 COL 63.43 WIDGET-ID 12
     IMAGE-3 AT ROW 6.67 COL 60.86 WIDGET-ID 18
     IMAGE-4 AT ROW 6.67 COL 63.43 WIDGET-ID 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3 ROW 2.83
         SIZE 76.86 BY 11.54
         FONT 1.


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
         TITLE              = "Integraá∆o Datasul EMS 2 com Microsoft CRM Dynamics"
         HEIGHT             = 15.67
         WIDTH              = 81.14
         MAX-HEIGHT         = 29.33
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 29.33
         VIRTUAL-WIDTH      = 182.86
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
/* SETTINGS FOR FRAME f-pg-imp
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN text-destino IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Destino".

/* SETTINGS FOR FILL-IN text-modo IN FRAME f-pg-imp
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME f-pg-imp     = 
                "Execuá∆o".

/* SETTINGS FOR FRAME f-pg-sel
   Custom                                                               */
/* SETTINGS FOR FRAME f-relat
                                                                        */
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
ON END-ERROR OF w-relat /* Integraá∆o Datasul EMS 2 com Microsoft CRM Dynamics */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-relat w-relat
ON WINDOW-CLOSE OF w-relat /* Integraá∆o Datasul EMS 2 com Microsoft CRM Dynamics */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
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
   apply "close" to this-procedure.
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


&Scoped-define SELF-NAME im-pg-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL im-pg-imp w-relat
ON MOUSE-SELECT-CLICK OF im-pg-imp IN FRAME f-relat
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
&Scoped-define SELF-NAME rs-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-destino w-relat
ON VALUE-CHANGED OF rs-destino IN FRAME f-pg-imp
DO:
do  with frame f-pg-imp:
    case self:screen-value:
        when "1" then do:
            assign c-arquivo:sensitive    = no
                   bt-arquivo:visible     = no
                   bt-config-impr:visible = yes.
        end.
        when "2" then do:
            assign c-arquivo:sensitive     = yes
                   bt-arquivo:visible      = yes
                   bt-config-impr:visible  = no.
        end.
        when "3" then do:
            assign c-arquivo:sensitive     = no
                   bt-arquivo:visible      = no
                   bt-config-impr:visible  = no.
        end.
    end case.
end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-execucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-execucao w-relat
ON VALUE-CHANGED OF rs-execucao IN FRAME f-pg-imp
DO:
   {include/i-rprse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-sel
&Scoped-define SELF-NAME tg-marcar-desmarcar-crm-ems
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-marcar-desmarcar-crm-ems w-relat
ON VALUE-CHANGED OF tg-marcar-desmarcar-crm-ems IN FRAME f-pg-sel /* Marcar / Desmarcar Todos */
DO:
    ASSIGN tg-crm-emitente:CHECKED      IN FRAME f-pg-sel = SELF:CHECKED IN FRAME f-pg-sel
           tg-crm-contato:CHECKED       IN FRAME f-pg-sel = SELF:CHECKED IN FRAME f-pg-sel
           tg-crm-local-entrega:CHECKED IN FRAME f-pg-sel = SELF:CHECKED IN FRAME f-pg-sel
           tg-crm-relac-cliente:CHECKED IN FRAME f-pg-sel = SELF:CHECKED IN FRAME f-pg-sel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-marcar-desmarcar-ems-crm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-marcar-desmarcar-ems-crm w-relat
ON VALUE-CHANGED OF tg-marcar-desmarcar-ems-crm IN FRAME f-pg-sel /* Marcar / Desmarcar Todos */
DO:
    ASSIGN tg-canal:CHECKED         IN FRAME f-pg-sel = SELF:CHECKED IN FRAME f-pg-sel
           tg-cond:CHECKED          IN FRAME f-pg-sel = SELF:CHECKED IN FRAME f-pg-sel
           tg-grp-cli:CHECKED       IN FRAME f-pg-sel = SELF:CHECKED IN FRAME f-pg-sel
           tg-portador:CHECKED      IN FRAME f-pg-sel = SELF:CHECKED IN FRAME f-pg-sel
           tg-receita:CHECKED       IN FRAME f-pg-sel = SELF:CHECKED IN FRAME f-pg-sel
           tg-representante:CHECKED IN FRAME f-pg-sel = SELF:CHECKED IN FRAME f-pg-sel
           tg-transp:CHECKED        IN FRAME f-pg-sel = SELF:CHECKED IN FRAME f-pg-sel
           tg-fm-material:CHECKED   IN FRAME f-pg-sel = SELF:CHECKED IN FRAME f-pg-sel
           tg-fm-comercial:CHECKED  IN FRAME f-pg-sel = SELF:CHECKED IN FRAME f-pg-sel
           tg-gr-estoque:CHECKED    IN FRAME f-pg-sel = SELF:CHECKED IN FRAME f-pg-sel
           tg-produto:CHECKED       IN FRAME f-pg-sel = SELF:CHECKED IN FRAME f-pg-sel
           tg-estrut-prod:CHECKED   IN FRAME f-pg-sel = SELF:CHECKED IN FRAME f-pg-sel
           tg-tb-preco:CHECKED      IN FRAME f-pg-sel = SELF:CHECKED IN FRAME f-pg-sel
           tg-rota:CHECKED          IN FRAME f-pg-sel = SELF:CHECKED IN FRAME f-pg-sel
           tg-estabelec:CHECKED     IN FRAME f-pg-sel = SELF:CHECKED IN FRAME f-pg-sel
           tg-tb-finan:CHECKED      IN FRAME f-pg-sel = SELF:CHECKED IN FRAME f-pg-sel
           tg-nat-oper:CHECKED      IN FRAME f-pg-sel = SELF:CHECKED IN FRAME f-pg-sel
           tg-mensagem:CHECKED      IN FRAME f-pg-sel = SELF:CHECKED IN FRAME f-pg-sel
           tg-emitente:CHECKED      IN FRAME f-pg-sel = SELF:CHECKED IN FRAME f-pg-sel
           tg-local:CHECKED         IN FRAME f-pg-sel = SELF:CHECKED IN FRAME f-pg-sel
           tg-relac:CHECKED         IN FRAME f-pg-sel = SELF:CHECKED IN FRAME f-pg-sel
           tg-pedido:CHECKED        IN FRAME f-pg-sel = SELF:CHECKED IN FRAME f-pg-sel
           tg-nf:CHECKED            IN FRAME f-pg-sel = SELF:CHECKED IN FRAME f-pg-sel
           tg-cidade:CHECKED        IN FRAME f-pg-sel = SELF:CHECKED IN FRAME f-pg-sel
           tg-unid-feder:CHECKED    IN FRAME f-pg-sel = SELF:CHECKED IN FRAME f-pg-sel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME f-pg-imp
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-relat 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

{utp/ut9000.i "ESCRM001" "2.04.00.000"}

/* inicializaá‰es do template de relat¢rio */
{include/i-rpini.i}

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

{include/i-rplbl.i}

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    RUN enable_UI.

    {include/i-rpmbl.i}

/*     IF rs-execucao:DISABLE(ENTRY(3, rs-execucao:RADIO-BUTTONS IN FRAME f-pg-imp)) IN FRAME f-pg-imp THEN. */
    IF rs-destino:DISABLE(ENTRY(1, rs-destino:RADIO-BUTTONS IN FRAME f-pg-imp)) IN FRAME f-pg-imp THEN.
   
    ASSIGN dt-ini-pedido:SCREEN-VALUE IN FRAME f-pg-sel = "01012010"
           dt-fim-pedido:SCREEN-VALUE IN FRAME f-pg-sel = "01012010"
           dt-ini-nota:SCREEN-VALUE   IN FRAME f-pg-sel = "01012010".

    IF NOT THIS-PROCEDURE:PERSISTENT THEN
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
  ENABLE im-pg-sel im-pg-imp bt-executar bt-cancelar bt-ajuda 
      WITH FRAME f-relat IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  DISPLAY tg-cidade tg-unid-feder tg-marcar-desmarcar-ems-crm tg-canal tg-cond 
          tg-grp-cli tg-portador tg-receita tg-representante tg-transp 
          tg-fm-material tg-fm-comercial tg-gr-estoque tg-produto tg-estrut-prod 
          tg-tb-preco tg-rota tg-estabelec tg-tb-finan tg-nat-oper tg-mensagem 
          tg-emitente tg-local tg-relac tg-pedido dt-ini-pedido dt-fim-pedido 
          tg-nf tg-marcar-desmarcar-crm-ems tg-crm-emitente tg-crm-contato 
          tg-crm-local-entrega tg-crm-relac-cliente tg-encerrar-programa 
          dt-ini-nota dt-fim-nota tg-automatico 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  ENABLE tg-cidade tg-unid-feder tg-marcar-desmarcar-ems-crm tg-canal tg-cond 
         tg-grp-cli tg-portador tg-receita tg-representante tg-transp 
         tg-fm-material tg-fm-comercial tg-gr-estoque tg-produto tg-estrut-prod 
         tg-tb-preco tg-rota tg-estabelec tg-tb-finan tg-nat-oper tg-mensagem 
         tg-emitente tg-local tg-relac tg-pedido dt-ini-pedido dt-fim-pedido 
         tg-nf tg-marcar-desmarcar-crm-ems tg-crm-emitente tg-crm-contato 
         tg-crm-local-entrega tg-crm-relac-cliente tg-encerrar-programa 
         dt-ini-nota dt-fim-nota tg-automatico RECT-10 RECT-11 RECT-14 RECT-12 
         IMAGE-1 IMAGE-2 IMAGE-3 IMAGE-4 
      WITH FRAME f-pg-sel IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-sel}
  DISPLAY rs-destino c-arquivo rs-execucao 
      WITH FRAME f-pg-imp IN WINDOW w-relat.
  ENABLE RECT-7 RECT-9 rs-destino bt-arquivo bt-config-impr c-arquivo 
         rs-execucao 
      WITH FRAME f-pg-imp IN WINDOW w-relat.
  {&OPEN-BROWSERS-IN-QUERY-f-pg-imp}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar w-relat 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE r-tt-digita AS ROWID       NO-UNDO.

    DO ON ERROR UNDO, RETURN ERROR
       ON STOP UNDO,  RETURN ERROR:
        {include/i-rpexa.i}

        IF INPUT FRAME f-pg-sel tg-pedido:CHECKED  
        THEN DO:
           IF INPUT FRAME f-pg-sel dt-ini-pedido < 01/01/2010 OR 
              INPUT FRAME f-pg-sel dt-fim-pedido < 01/01/2010 
           THEN DO:
              RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                 INPUT 17006,
                                 INPUT "Ano deve ser maior que 2010":U).

              APPLY "MOUSE-SELECT-CLICK":U TO im-pg-sel IN FRAME f-relat.
              APPLY "ENTRY":U TO dt-ini-pedido IN FRAME f-pg-sel.

              RETURN ERROR.

           END. 

        END.

        IF INPUT FRAME f-pg-imp rs-destino  = 2 AND
           INPUT FRAME f-pg-imp rs-execucao = 1 THEN DO:
            RUN utp/ut-vlarq.p (INPUT INPUT FRAME f-pg-imp c-arquivo).

            IF RETURN-VALUE = "NOK":U THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 73,
                                   INPUT "":U).

                APPLY "MOUSE-SELECT-CLICK":U TO im-pg-imp IN FRAME f-relat.
                APPLY "ENTRY":U TO c-arquivo IN FRAME f-pg-imp.

                RETURN ERROR.
            END.
        END.

        /* Coloque aqui as validaá‰es da p†gina de Digitaá∆o, lembrando que elas devem
           apresentar uma mensagem de erro cadastrada, posicionar nesta p†gina e colocar
           o focus no campo com problemas */

        /* Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas devem 
           apresentar uma mensagem de erro cadastrada, posicionar na p†gina com 
           problemas e colocar o focus no campo com problemas */

        /* Aqui s∆o gravados os campos da temp-table que ser† passada como parÉmetro
           para o programa RP.P */
        CREATE tt-param.
        ASSIGN tt-param.usuario   = c-seg-usuario
               tt-param.destino   = INPUT FRAME f-pg-imp rs-destino
               tt-param.data-exec = TODAY
               tt-param.hora-exec = TIME.

        IF tt-param.destino = 1 THEN
            ASSIGN tt-param.arquivo = "":U.
        ELSE
            IF tt-param.destino = 2 THEN
                ASSIGN tt-param.arquivo = INPUT FRAME f-pg-imp c-arquivo.
            ELSE
                ASSIGN tt-param.arquivo = SESSION:TEMP-DIRECTORY + c-programa-mg97 + ".tmp":U.
                
        /* Coloque aqui a l¢gica de gravaá∆o dos demais campos que devem ser passados
           como parÉmetros para o programa RP.P, atravÇs da temp-table tt-param */
        ASSIGN tt-param.l-canal-venda       = INPUT FRAME f-pg-sel tg-canal
               tt-param.l-cond-pagto        = INPUT FRAME f-pg-sel tg-cond
               tt-param.l-grp-cli           = INPUT FRAME f-pg-sel tg-grp-cli
               tt-param.l-portador          = INPUT FRAME f-pg-sel tg-portador
               tt-param.l-receita-padrao    = INPUT FRAME f-pg-sel tg-receita
               tt-param.l-representante     = INPUT FRAME f-pg-sel tg-representante
               tt-param.l-transportadora    = INPUT FRAME f-pg-sel tg-transp
               tt-param.l-familia-estoq     = INPUT FRAME f-pg-sel tg-fm-material
               tt-param.l-familia-comercial = INPUT FRAME f-pg-sel tg-fm-comercial
               tt-param.l-grupo-estoque     = INPUT FRAME f-pg-sel tg-gr-estoque
               tt-param.l-produto           = INPUT FRAME f-pg-sel tg-produto
               tt-param.l-estrut-prod       = INPUT FRAME f-pg-sel tg-estrut-prod
               tt-param.l-tb-preco          = INPUT FRAME f-pg-sel tg-tb-preco
               tt-param.l-rota              = INPUT FRAME f-pg-sel tg-rota
               tt-param.l-estabelec         = INPUT FRAME f-pg-sel tg-estabelec
               tt-param.l-tb-finan          = INPUT FRAME f-pg-sel tg-tb-finan
               tt-param.l-nat-oper          = INPUT FRAME f-pg-sel tg-nat-oper
               tt-param.l-mensagem          = INPUT FRAME f-pg-sel tg-mensagem
               tt-param.l-emitente          = INPUT FRAME f-pg-sel tg-emitente
               tt-param.l-contato           = NO /* Opá∆o desativada! */
               tt-param.l-cidade            = INPUT FRAME f-pg-sel tg-cidade
               tt-param.l-unid-feder        = INPUT FRAME f-pg-sel tg-unid-feder
               tt-param.l-local-entrega     = INPUT FRAME f-pg-sel tg-local
               tt-param.l-relac-cliente     = INPUT FRAME f-pg-sel tg-relac
               tt-param.l-pedido            = INPUT FRAME f-pg-sel tg-pedido
               tt-param.l-nf                = INPUT FRAME f-pg-sel tg-nf
               tt-param.l-titulo            = NO
               tt-param.l-crm-emitente      = INPUT FRAME f-pg-sel tg-crm-emitente
               tt-param.l-crm-contato       = INPUT FRAME f-pg-sel tg-crm-contato
               tt-param.l-crm-local-entrega = INPUT FRAME f-pg-sel tg-crm-local-entrega
               tt-param.l-crm-relac-cliente = INPUT FRAME f-pg-sel tg-crm-relac-cliente
               tt-param.l-encerrar-programa = input frame f-pg-sel tg-encerrar-programa
               tt-param.dt-ini-pedido       = INPUT FRAME f-pg-sel dt-ini-pedido
               tt-param.dt-fim-pedido       = input frame f-pg-sel dt-fim-pedido
               tt-param.dt-ini-nota         = INPUT FRAME f-pg-sel dt-ini-nota
               tt-param.dt-fim-nota         = input frame f-pg-sel dt-fim-nota
               tt-param.automatico          = input frame f-pg-sel tg-automatico.
              
               

        /* Executar do programa RP.P que ir† criar o relat¢rio */
        {include/i-rpexb.i}

        SESSION:SET-WAIT-STATE("general":U).

        {include/i-rprun.i esp/crm/escrm001rp.p}

        {include/i-rpexc.i}

        SESSION:SET-WAIT-STATE("":U).

        {include/i-rptrm.i}
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-pagina w-relat 
PROCEDURE pi-troca-pagina :
/*------------------------------------------------------------------------------
  Purpose: Gerencia a Troca de P†gina (folder)   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{include/i-rptrp.i}

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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this w-relat, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-firstDay w-relat 
FUNCTION fn-firstDay RETURNS DATE
  ( INPUT ipDAta AS DATE) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  if ipData = ? then return ( ? ). 
  else do:
      return date(month(ipData), 01, year(ipData)).
  end.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-LastDay w-relat 
FUNCTION fn-LastDay RETURNS DATE
  ( INPUT data AS DATE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    if data = ? then return ( ? ). 
    else do:
        data = date(month(data),28,year(data)). 
        data = data + 4 - day ( data + 4 ). 
        return ( data ). 
    end.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-mesComp w-relat 
FUNCTION fn-mesComp RETURNS CHARACTER
  ( INPUT data-comp AS DATE) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

define variable iMes as integer no-undo.
    define variable iAno as integer no-undo.
     
    assign iMes = month(data-comp)
           iAno = year(data-comp).
     
    return string(iMes, "99") + string(iAno, "9999").

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

