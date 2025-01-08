&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
DEFINE BUFFER prog_dtsul   FOR emsfnd.prog_dtsul.
DEFINE BUFFER usuar_mestre FOR emsfnd.usuar_mestre.
DEFINE BUFFER procedimento FOR emsfnd.procedimento.
DEFINE BUFFER modul_dtsul  FOR emsfnd.modul_dtsul.

{include/i-prgvrs.i ESCCP031 2.06.00.002}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ESCCP031 MCC}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCCP031
&GLOBAL-DEFINE Version        2.06.00.002

&GLOBAL-DEFINE WindowType     

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              fi-cod-estabel-ini fi-cod-estabel-fin ~
                              fi-it-codigo-ini fi-it-codigo-fin ~
                              fi-data-emissao-ini fi-data-emissao-fin ~
                              fi-cod-emitente-ini fi-cod-emitente-fin ~
                              cb-cod-comprado ~
                              text-situacao text-demanda tg-nao-confirmada tg-cotada ~
                              tg-em-cotacao tg-todas tg-dependente tg-independente ~
                              btFiltrar ~
                              brOrdemCompra ~
                              btMarcarDesmarcar btAtualizar btDesfazer ~
                              btEliminar btAprovar btSelAnalisada btGerarPedido btGeraParc
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

&GLOBAL-DEFINE todosUsuarios  -- Todos --

/* Include Definitions ---                                              */

/* Definiá∆o da Temp-Table "tt-erros-geral" */
{cdp/cdapi300.i1}

/* Definiá∆o da Temp-Table "tt-ordem-compra-ped" */
{esp/ccp/esccp031.i}

/* Local Temp-Table Definitions ---                                     */
DEF NEW GLOBAL SHARED VAR v-row-cc0301              AS ROWID NO-UNDO.
DEFINE VARIABLE i AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE tt-ordem-compra NO-UNDO LIKE ordem-compra
    FIELD r-Rowid           AS ROWID
    FIELD l-selecionado     AS LOGICAL   FORMAT "Sim/N∆o":U INITIAL NO LABEL "Selecionado":U COLUMN-LABEL "Sel":U
    FIELD desc-item         LIKE item.desc-item
    FIELD nome-abrev-fornec LIKE emitente.nome-abrev
    FIELD desc-situacao     AS CHARACTER FORMAT "x(15)":U              LABEL "Situaá∆o":U COLUMN-LABEL "Situaá∆o":U
    FIELD log-analisada     LIKE int-analise-ordem-compra.log-analisada
    FIELD data-necessidade  LIKE int-prazo-compra.data-necessidade LABEL "Necessidade"
    FIELD data-entrega      LIKE prazo-compra.data-entrega
    FIELD quantidade        LIKE prazo-compra.quantidade
    FIELD un                LIKE prazo-compra.un
    FIELD qtd-for           LIKE prazo-compra.quantidade
    FIELD indice            AS DEC
    FIELD unid-med-for      LIKE item-fornec-estab.unid-med-for
    FIELD tempo-ressup      LIKE item-fornec-estab.tempo-ressup
    FIELD lote-minimo       LIKE item-fornec-estab.lote-minimo
    FIELD lote-mul-for      LIKE item-fornec-estab.lote-mul-for
    FIELD qt-disponivel     LIKE saldo-estoq.qtidade-atu
    FIELD qt-alocada        LIKE saldo-estoq.qtidade-atu 
    FIELD qt-pedido         LIKE saldo-estoq.qtidade-atu
    FIELD quant-segur       LIKE item-uni-estab.quant-segur
    FIELD ultimo-preco      AS DEC.
   

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE de-win-orig-width   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-win-orig-height  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-nome-coluna       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-asc               AS LOGICAL     NO-UNDO INITIAL YES.
DEFINE VARIABLE lista-handle-coluna AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-parcelas          AS INTEGER     NO-UNDO.

/* New Global Shared Variable Definitions ---                           */

DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER   NO-UNDO FORMAT "x(12)":U.

/* Buffer Definitions ---                                               */

DEFINE BUFFER b-prazo-compra FOR prazo-compra.
DEFINE BUFFER b-tt-ordem-compra FOR tt-ordem-compra.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brOrdemCompra

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ordem-compra

/* Definitions for BROWSE brOrdemCompra                                 */
&Scoped-define FIELDS-IN-QUERY-brOrdemCompra tt-ordem-compra.l-selecionado tt-ordem-compra.it-codigo tt-ordem-compra.desc-item tt-ordem-compra.cod-estabel tt-ordem-compra.cod-comprado tt-ordem-compra.cod-emitente tt-ordem-compra.nome-abrev-fornec tt-ordem-compra.numero-ordem fnParcelas(tt-ordem-compra.numero-ordem) @ i-parcelas COLUMN-LABE "Nr. Parcelas" tt-ordem-compra.desc-situacao tt-ordem-compra.log-analisada tt-ordem-compra.data-necessidade tt-ordem-compra.data-entrega tt-ordem-compra.quantidade tt-ordem-compra.un tt-ordem-compra.qtd-for tt-ordem-compra.unid-med-for tt-ordem-compra.tempo-ressup tt-ordem-compra.lote-minimo tt-ordem-compra.lote-mul-for tt-ordem-compra.preco-unit tt-ordem-compra.qt-disponivel tt-ordem-compra.qt-alocada tt-ordem-compra.qt-pedido tt-ordem-compra.quant-segur tt-ordem-compra.ultimo-preco   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brOrdemCompra tt-ordem-compra.l-selecionado ~
tt-ordem-compra.log-analisada ~
tt-ordem-compra.data-entrega ~
tt-ordem-compra.quantidade   
&Scoped-define ENABLED-TABLES-IN-QUERY-brOrdemCompra tt-ordem-compra
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brOrdemCompra tt-ordem-compra
&Scoped-define SELF-NAME brOrdemCompra
&Scoped-define QUERY-STRING-brOrdemCompra FOR EACH tt-ordem-compra
&Scoped-define OPEN-QUERY-brOrdemCompra OPEN QUERY {&SELF-NAME} FOR EACH tt-ordem-compra.
&Scoped-define TABLES-IN-QUERY-brOrdemCompra tt-ordem-compra
&Scoped-define FIRST-TABLE-IN-QUERY-brOrdemCompra tt-ordem-compra


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brOrdemCompra}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btQueryJoins btReportsJoins btExit btHelp ~
fi-cod-estabel-ini fi-cod-estabel-fin text-situacao fi-it-codigo-ini ~
fi-it-codigo-fin fi-data-emissao-ini fi-data-emissao-fin ~
fi-cod-emitente-ini fi-cod-emitente-fin cb-cod-comprado tg-dependente ~
tg-independente tg-nao-confirmada tg-cotada tg-em-cotacao tg-todas ~
btFiltrar btMarcarDesmarcar fi-nom_usuario btAtualizar btDesfazer ~
btEliminar btAprovar btGeraParc btSelAnalisada btGerarPedido brOrdemCompra ~
text-demanda rtToolBar-2 IMAGE-1 IMAGE-2 IMAGE-3 IMAGE-4 IMAGE-5 IMAGE-6 ~
IMAGE-7 IMAGE-8 rtSel rtSituacao rtDemanda 
&Scoped-Define DISPLAYED-OBJECTS fi-cod-estabel-ini fi-cod-estabel-fin ~
text-situacao fi-it-codigo-ini fi-it-codigo-fin fi-data-emissao-ini ~
fi-data-emissao-fin fi-cod-emitente-ini fi-cod-emitente-fin cb-cod-comprado ~
tg-dependente tg-independente tg-nao-confirmada tg-cotada tg-em-cotacao ~
tg-todas fi-nom_usuario text-demanda 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnParcelas wWindow 
FUNCTION fnParcelas RETURNS INTEGER
  ( p-numero-ordem AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miMarcarDesmarcar LABEL "&Marcar/Desmarcar"
       RULE
       MENU-ITEM miAtualizar    LABEL "&Atualizar"    
       MENU-ITEM miDesfazer     LABEL "&Desfazer"     
       RULE
       MENU-ITEM miEliminar     LABEL "&Eliminar"     
       RULE
       MENU-ITEM miAprovar      LABEL "&Aprovar OC"   
       RULE
       MENU-ITEM miSelAnalisada LABEL "Selecionar Analisada"
       RULE
       MENU-ITEM miGerarPedido  LABEL "Gerar Pedido"  
       RULE
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .

DEFINE MENU pmBrOrdemCompra 
       MENU-ITEM miOrdenarColuna LABEL "Ordenar Coluna"
              TOGGLE-BOX
       MENU-ITEM miMoverColuna  LABEL "Mover Coluna"  
              TOGGLE-BOX.


/* Definitions of the field level widgets                               */
DEFINE BUTTON btAprovar 
     LABEL "&Aprovar OC" 
     SIZE 10 BY 1 TOOLTIP "Aprovar Ordens de Compra".

DEFINE BUTTON btAtualizar 
     LABEL "&Atualizar" 
     SIZE 10 BY 1 TOOLTIP "Atualizar Todas as Alteraá‰es Efetuadas".

DEFINE BUTTON btDesfazer 
     LABEL "&Desfazer" 
     SIZE 10 BY 1 TOOLTIP "Desfazer as Alteraá‰es Efetuadas".

DEFINE BUTTON btEliminar 
     LABEL "&Eliminar" 
     SIZE 10 BY 1 TOOLTIP "Eliminar Ordens de Compra Selecionadas".

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFiltrar 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-chck1.bmp":U
     LABEL "&Filtrar" 
     SIZE 4 BY 1.13 TOOLTIP "Filtrar Seleá∆o".

DEFINE BUTTON btGeraParc 
     LABEL "Parcelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btGerarPedido 
     LABEL "Gerar Pedido" 
     SIZE 10 BY 1 TOOLTIP "Geraá∆o de Pedidos com as Ordens de Compra Selecionadas".

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btMarcarDesmarcar 
     LABEL "&Marcar/Desmarcar" 
     SIZE 14 BY 1 TOOLTIP "Marcar/Desmarcar Todas as Ordens de Compra".

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSelAnalisada 
     LABEL "Selecionar Analisada" 
     SIZE 15 BY 1 TOOLTIP "Selecionar TODAS as ordens de compra analisadas".

DEFINE VARIABLE cb-cod-comprado AS CHARACTER 
     LABEL "Comprador" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     DROP-DOWN AUTO-COMPLETION
     SIZE 17.43 BY 1 TOOLTIP "C¢digo do comprador" NO-UNDO.

DEFINE VARIABLE fi-cod-emitente-fin AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .88 TOOLTIP "C¢digo do fornecedor (Final)" NO-UNDO.

DEFINE VARIABLE fi-cod-emitente-ini AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 TOOLTIP "C¢digo do fornecedor (Inicial)" NO-UNDO.

DEFINE VARIABLE fi-cod-estabel-fin AS CHARACTER FORMAT "x(3)" INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 TOOLTIP "C¢digo do estabelecimento (Final)".

DEFINE VARIABLE fi-cod-estabel-ini AS CHARACTER FORMAT "x(3)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 TOOLTIP "C¢digo do estabelecimento (Inicial)".

DEFINE VARIABLE fi-data-emissao-fin AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 TOOLTIP "Data de emiss∆o (Final)" NO-UNDO.

DEFINE VARIABLE fi-data-emissao-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Emiss∆o" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 TOOLTIP "Data de emiss∆o (Inicial)" NO-UNDO.

DEFINE VARIABLE fi-it-codigo-fin AS CHARACTER FORMAT "x(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 TOOLTIP "C¢digo do item (Final)" NO-UNDO.

DEFINE VARIABLE fi-it-codigo-ini AS CHARACTER FORMAT "x(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 TOOLTIP "C¢digo do item (Inicial)" NO-UNDO.

DEFINE VARIABLE fi-nom_usuario AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 39.29 BY .88 TOOLTIP "Nome do usu†rio" NO-UNDO.

DEFINE VARIABLE text-demanda AS CHARACTER FORMAT "X(256)":U INITIAL "Demanda" 
      VIEW-AS TEXT 
     SIZE 6.86 BY .67 NO-UNDO.

DEFINE VARIABLE text-situacao AS CHARACTER FORMAT "X(256)":U INITIAL " Situaá∆o" 
      VIEW-AS TEXT 
     SIZE 6.86 BY .67 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .88.

DEFINE RECTANGLE rtDemanda
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26.29 BY 1.29.

DEFINE RECTANGLE rtSel
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 7.17.

DEFINE RECTANGLE rtSituacao
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43.86 BY 1.29.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE tg-cotada AS LOGICAL INITIAL no 
     LABEL "Cotada" 
     VIEW-AS TOGGLE-BOX
     SIZE 7.72 BY .58 TOOLTIP "Situaá∆o cotada" NO-UNDO.

DEFINE VARIABLE tg-dependente AS LOGICAL INITIAL no 
     LABEL "Dependente" 
     VIEW-AS TOGGLE-BOX
     SIZE 10.86 BY .58 TOOLTIP "Demanda" NO-UNDO.

DEFINE VARIABLE tg-em-cotacao AS LOGICAL INITIAL no 
     LABEL "Em cotaá∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 10.86 BY .58 TOOLTIP "Situaá∆o em cotaá∆o" NO-UNDO.

DEFINE VARIABLE tg-independente AS LOGICAL INITIAL no 
     LABEL "Independente" 
     VIEW-AS TOGGLE-BOX
     SIZE 12 BY .58 TOOLTIP "Demanda" NO-UNDO.

DEFINE VARIABLE tg-nao-confirmada AS LOGICAL INITIAL no 
     LABEL "N∆o confirmada" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.57 BY .58 TOOLTIP "Situaá∆o n∆o confirmada" NO-UNDO.

DEFINE VARIABLE tg-todas AS LOGICAL INITIAL no 
     LABEL "Todas" 
     VIEW-AS TOGGLE-BOX
     SIZE 7.14 BY .58 TOOLTIP "Todas as situaá‰es (N∆o confirmada, Cotada e Em cotaá∆o)" NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brOrdemCompra FOR 
      tt-ordem-compra SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brOrdemCompra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brOrdemCompra wWindow _FREEFORM
  QUERY brOrdemCompra DISPLAY
      tt-ordem-compra.l-selecionado     COLUMN-LABEL "":U VIEW-AS TOGGLE-BOX
      tt-ordem-compra.it-codigo         WIDTH 12.00
      tt-ordem-compra.desc-item         WIDTH 25.00
      tt-ordem-compra.cod-estabel       WIDTH  2.00
      tt-ordem-compra.cod-comprado      WIDTH  8.00
      tt-ordem-compra.cod-emitente      WIDTH  7.00
      tt-ordem-compra.nome-abrev-fornec
      tt-ordem-compra.numero-ordem
      fnParcelas(tt-ordem-compra.numero-ordem) @ i-parcelas COLUMN-LABE "Nr. Parcelas"
      tt-ordem-compra.desc-situacao
      tt-ordem-compra.log-analisada     COLUMN-LABEL "Analis":U VIEW-AS TOGGLE-BOX
      tt-ordem-compra.data-necessidade  COLUMN-LABEL "Necessidade"
      tt-ordem-compra.data-entrega
      tt-ordem-compra.quantidade        FORMAT ">>>>,>>>,>>9.9999":U
      tt-ordem-compra.un                COLUMN-LABEL "Un."
      tt-ordem-compra.qtd-for           COLUMN-LABEL "Qtde Forn" FORMAT ">>>>,>>>,>>9.9999":U
      tt-ordem-compra.unid-med-for      WIDTH 3.75 COLUMN-LABEL "Un Forn":U
      tt-ordem-compra.tempo-ressup
      tt-ordem-compra.lote-minimo
      tt-ordem-compra.lote-mul-for
      tt-ordem-compra.preco-unit 
      tt-ordem-compra.qt-disponivel COLUMN-LABEL "Saldo Disponivel"
      tt-ordem-compra.qt-alocada    COLUMN-LABEL "Saldo Alocado"
      tt-ordem-compra.qt-pedido     COLUMN-LABEL "Saldo Pedido"
      tt-ordem-compra.quant-segur   COLUMN-LABEL "Qt Segur"
      tt-ordem-compra.ultimo-preco  COLUMN-LABEL "Ult Preáo"
      ENABLE
      tt-ordem-compra.l-selecionado
      tt-ordem-compra.log-analisada
      tt-ordem-compra.data-entrega
      tt-ordem-compra.quantidade
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 89 BY 6.83
         FONT 1 ROW-HEIGHT-CHARS .46 TOOLTIP "Ordens de Compra".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     fi-cod-estabel-ini AT ROW 2.83 COL 38.86 RIGHT-ALIGNED HELP
          "C¢digo do estabelecimento (Inicial)"
     fi-cod-estabel-fin AT ROW 2.83 COL 52 HELP
          "C¢digo do estabelecimento (Final)" NO-LABEL
     text-situacao AT ROW 8 COL 40.86 NO-LABEL NO-TAB-STOP 
     fi-it-codigo-ini AT ROW 3.83 COL 38.86 RIGHT-ALIGNED HELP
          "C¢digo do item (Inicial)"
     fi-it-codigo-fin AT ROW 3.83 COL 52 HELP
          "C¢digo do item (Final)" NO-LABEL
     fi-data-emissao-ini AT ROW 4.83 COL 38.86 RIGHT-ALIGNED HELP
          "Data de emiss∆o (Inicial)"
     fi-data-emissao-fin AT ROW 4.83 COL 52 HELP
          "Data de emiss∆o (Final)" NO-LABEL
     fi-cod-emitente-ini AT ROW 5.83 COL 38.86 RIGHT-ALIGNED HELP
          "C¢digo do fornecedor (Inicial)"
     fi-cod-emitente-fin AT ROW 5.83 COL 52 HELP
          "C¢digo do fornecedor (Final)" NO-LABEL
     cb-cod-comprado AT ROW 6.83 COL 37.57 RIGHT-ALIGNED HELP
          "C¢digo do comprador"
     tg-dependente AT ROW 8.79 COL 14.43 HELP
          "Situaá∆o em cotaá∆o" WIDGET-ID 6
     tg-independente AT ROW 8.79 COL 26.29 HELP
          "Todas as situaá‰es (N∆o confirmada, Cotada e Em cotaá∆o)" WIDGET-ID 8
     tg-nao-confirmada AT ROW 8.79 COL 40.72 HELP
          "Situaá∆o n∆o confirmada"
     tg-cotada AT ROW 8.79 COL 55.29 HELP
          "Situaá∆o cotada"
     tg-em-cotacao AT ROW 8.79 COL 64 HELP
          "Situaá∆o em cotaá∆o"
     tg-todas AT ROW 8.79 COL 75.86 HELP
          "Todas as situaá‰es (N∆o confirmada, Cotada e Em cotaá∆o)"
     btFiltrar AT ROW 8.54 COL 89.43 RIGHT-ALIGNED HELP
          "Filtrar Seleá∆o"
     btMarcarDesmarcar AT ROW 16.83 COL 1.57 HELP
          "Marcar/Desmarcar Todas as Ordens de Compra"
     fi-nom_usuario AT ROW 6.83 COL 37 COLON-ALIGNED HELP
          "Nome do usu†rio" NO-LABEL NO-TAB-STOP 
     btAtualizar AT ROW 16.83 COL 15.57 HELP
          "Atualizar Todas as Alteraá‰es Efetuadas"
     btDesfazer AT ROW 16.83 COL 25.57 HELP
          "Desfazer as Alteraá‰es Efetuadas"
     btEliminar AT ROW 16.83 COL 35.57 HELP
          "Eliminar Ordens de Compra Selecionadas"
     btAprovar AT ROW 16.83 COL 45.57 HELP
          "Aprovar Ordens de Compra"
     btGeraParc AT ROW 16.83 COL 55.57 WIDGET-ID 10
     btSelAnalisada AT ROW 16.83 COL 65.57 HELP
          "Selecionar TODAS as ordens de compra analisadas"
     btGerarPedido AT ROW 16.83 COL 80.57 HELP
          "Geraá∆o de Pedidos com as Ordens de Compra Selecionadas"
     brOrdemCompra AT ROW 10 COL 1.57 HELP
          "Ordens de compra"
     text-demanda AT ROW 8 COL 14.14 NO-LABEL WIDGET-ID 4 NO-TAB-STOP 
     rtToolBar-2 AT ROW 1 COL 1
     IMAGE-1 AT ROW 2.83 COL 40.29
     IMAGE-2 AT ROW 2.83 COL 48.57
     IMAGE-3 AT ROW 3.83 COL 40.29
     IMAGE-4 AT ROW 3.83 COL 48.57
     IMAGE-5 AT ROW 4.83 COL 40.29
     IMAGE-6 AT ROW 4.83 COL 48.57
     IMAGE-7 AT ROW 5.83 COL 40.29
     IMAGE-8 AT ROW 5.83 COL 48.57
     rtSel AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fpage0
     rtSituacao AT ROW 8.33 COL 40
     rtDemanda AT ROW 8.33 COL 13 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 200
         MAX-WIDTH          = 300
         VIRTUAL-HEIGHT     = 200
         VIRTUAL-WIDTH      = 300
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
/* BROWSE-TAB brOrdemCompra btGerarPedido fpage0 */
ASSIGN 
       brOrdemCompra:POPUP-MENU IN FRAME fpage0             = MENU pmBrOrdemCompra:HANDLE
       brOrdemCompra:NUM-LOCKED-COLUMNS IN FRAME fpage0     = 1
       brOrdemCompra:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE
       brOrdemCompra:COLUMN-MOVABLE IN FRAME fpage0         = TRUE.

/* SETTINGS FOR BUTTON btFiltrar IN FRAME fpage0
   ALIGN-R                                                              */
/* SETTINGS FOR COMBO-BOX cb-cod-comprado IN FRAME fpage0
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fi-cod-emitente-fin IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-cod-emitente-ini IN FRAME fpage0
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fi-cod-estabel-fin IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-cod-estabel-ini IN FRAME fpage0
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fi-data-emissao-fin IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-data-emissao-ini IN FRAME fpage0
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fi-it-codigo-fin IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-it-codigo-ini IN FRAME fpage0
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN text-demanda IN FRAME fpage0
   ALIGN-L                                                              */
ASSIGN 
       text-demanda:READ-ONLY IN FRAME fpage0        = TRUE
       text-demanda:PRIVATE-DATA IN FRAME fpage0     = 
                "Demanda".

/* SETTINGS FOR FILL-IN text-situacao IN FRAME fpage0
   ALIGN-L                                                              */
ASSIGN 
       text-situacao:READ-ONLY IN FRAME fpage0        = TRUE
       text-situacao:PRIVATE-DATA IN FRAME fpage0     = 
                "Situaá∆o".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brOrdemCompra
/* Query rebuild information for BROWSE brOrdemCompra
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ordem-compra.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brOrdemCompra */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-RESIZED OF wWindow
DO:
    RUN piWindowResize IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brOrdemCompra
&Scoped-define SELF-NAME brOrdemCompra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brOrdemCompra wWindow
ON MOUSE-SELECT-DBLCLICK OF brOrdemCompra IN FRAME fpage0
DO:
    APPLY "RETURN":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brOrdemCompra wWindow
ON RETURN OF brOrdemCompra IN FRAME fpage0
DO:
    IF AVAILABLE tt-ordem-compra THEN DO:
        ASSIGN tt-ordem-compra.l-selecionado = NOT tt-ordem-compra.l-selecionado.

        brOrdemCompra:REFRESH() IN FRAME fPage0.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brOrdemCompra wWindow
ON ROW-DISPLAY OF brOrdemCompra IN FRAME fpage0
DO:
    DEFINE VARIABLE num-fonte AS INTEGER     NO-UNDO.

    ASSIGN num-fonte = IF tt-ordem-compra.l-selecionado THEN 6 ELSE 1.

    /* Meio utilizado para alterar fonte da coluna dinamicamente */
    RUN piTrocaFonteColuna IN THIS-PROCEDURE (INPUT num-fonte).

    ASSIGN tt-ordem-compra.quantidade:FGCOLOR   IN BROWSE brOrdemCompra = ?
           tt-ordem-compra.data-entrega:FGCOLOR IN BROWSE brOrdemCompra = ?.

    FIND FIRST prazo-compra
        WHERE prazo-compra.numero-ordem = tt-ordem-compra.numero-ordem NO-LOCK NO-ERROR.

    IF AVAILABLE prazo-compra THEN DO:
        IF tt-ordem-compra.quantidade <> prazo-compra.quantidade THEN
            ASSIGN tt-ordem-compra.quantidade:FGCOLOR IN BROWSE brOrdemCompra = 12
                   tt-ordem-compra.quantidade:FONT    IN BROWSE brOrdemCompra = 6.

        IF tt-ordem-compra.data-entrega <> prazo-compra.data-entrega THEN
            ASSIGN tt-ordem-compra.data-entrega:FGCOLOR IN BROWSE brOrdemCompra = 12
                   tt-ordem-compra.data-entrega:FONT    IN BROWSE brOrdemCompra = 6.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brOrdemCompra wWindow
ON START-SEARCH OF brOrdemCompra IN FRAME fpage0
DO:
    DEFINE VARIABLE i-cont       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-pos-coluna AS INTEGER     NO-UNDO.

    SELF:CLEAR-SORT-ARROWS().

    IF SELF:CURRENT-COLUMN:TABLE = "":U OR
       SELF:CURRENT-COLUMN:TABLE = ?    THEN
        RETURN NO-APPLY.

    IF c-nome-coluna <> SELF:CURRENT-COLUMN:NAME THEN
        ASSIGN c-nome-coluna = SELF:CURRENT-COLUMN:NAME
               l-asc         = YES.
    ELSE
        ASSIGN l-asc = NOT l-asc.

    IF l-asc THEN
        SELF:QUERY:QUERY-PREPARE("FOR EACH ":U + SELF:CURRENT-COLUMN:TABLE + " ":U +
                                 "    OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME).
    ELSE
        SELF:QUERY:QUERY-PREPARE("FOR EACH ":U + SELF:CURRENT-COLUMN:TABLE + " ":U +
                                 "    OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME + " DESC":U).
            
    DO i-cont = 1 TO SELF:NUM-COLUMNS:
        IF SELF:CURRENT-COLUMN = SELF:GET-BROWSE-COLUMN(i-cont) THEN
            ASSIGN i-pos-coluna = i-cont.
    END.

    SELF:SET-SORT-ARROW(i-pos-coluna, l-asc).

    SELF:QUERY:QUERY-OPEN().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brOrdemCompra wWindow
ON VALUE-CHANGED OF brOrdemCompra IN FRAME fpage0
DO:
/*     DISABLE btDesfazer                                                        */
/*         WITH FRAME fPage0.                                                    */
/*                                                                               */
/*     IF AVAILABLE tt-ordem-compra THEN DO:                                     */
/*         FIND FIRST prazo-compra                                               */
/*             WHERE prazo-compra.numero-ordem = tt-ordem-compra.numero-ordem    */
/*               AND prazo-compra.parcela      = 1 NO-LOCK NO-ERROR.             */
/*                                                                               */
/*         IF AVAILABLE prazo-compra THEN DO:                                    */
/*             IF tt-ordem-compra.quantidade <> prazo-compra.quantidade THEN     */
/*                 ENABLE btDesfazer                                             */
/*                     WITH FRAME fPage0.                                        */
/*                                                                               */
/*             IF tt-ordem-compra.data-entrega <> prazo-compra.data-entrega THEN */
/*                 ENABLE btDesfazer                                             */
/*                     WITH FRAME fPage0.                                        */
/*         END.                                                                  */
/*     END.                                                                      */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAprovar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAprovar wWindow
ON CHOOSE OF btAprovar IN FRAME fpage0 /* Aprovar OC */
OR CHOOSE OF MENU-ITEM miAprovar IN MENU mbMain DO:
    RUN piAprovarOrdensCompra IN THIS-PROCEDURE.
    
    IF RETURN-VALUE = "NOK":U THEN
        RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAtualizar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAtualizar wWindow
ON CHOOSE OF btAtualizar IN FRAME fpage0 /* Atualizar */
OR CHOOSE OF MENU-ITEM miAtualizar IN MENU mbMain DO:
    RUN piAtualizarRegistros IN THIS-PROCEDURE.

    IF RETURN-VALUE = "NOK":U THEN
        RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDesfazer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDesfazer wWindow
ON CHOOSE OF btDesfazer IN FRAME fpage0 /* Desfazer */
OR CHOOSE OF MENU-ITEM miDesfazer IN MENU mbMain DO:
    RUN piDesfazerAlteracao IN THIS-PROCEDURE.

    IF RETURN-VALUE = "NOK":U THEN
        RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btEliminar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btEliminar wWindow
ON CHOOSE OF btEliminar IN FRAME fpage0 /* Eliminar */
OR CHOOSE OF MENU-ITEM miEliminar IN MENU mbMain DO:
    RUN piEliminarOrdensCompra IN THIS-PROCEDURE.

    IF RETURN-VALUE = "NOK":U THEN
        RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFiltrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFiltrar wWindow
ON CHOOSE OF btFiltrar IN FRAME fpage0 /* Filtrar */
DO:
    RUN piFiltrarSelecao IN THIS-PROCEDURE.

    IF RETURN-VALUE = "NOK":U THEN
        RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGeraParc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGeraParc wWindow
ON CHOOSE OF btGeraParc IN FRAME fpage0 /* Parcelar */
DO: 
    
    IF AVAIL tt-ordem-compra THEN DO:
        ASSIGN v-row-cc0301 = tt-ordem-compra.r-rowid.
        RUN ccp/cc0301.w.
    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGerarPedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGerarPedido wWindow
ON CHOOSE OF btGerarPedido IN FRAME fpage0 /* Gerar Pedido */
OR CHOOSE OF MENU-ITEM miGerarPedido IN MENU mbMain DO:
    DO ON ERROR UNDO, RETURN NO-APPLY:
        RUN piGerarPedido IN THIS-PROCEDURE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btMarcarDesmarcar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btMarcarDesmarcar wWindow
ON CHOOSE OF btMarcarDesmarcar IN FRAME fpage0 /* Marcar/Desmarcar */
OR CHOOSE OF MENU-ITEM miMarcarDesmarcar IN MENU mbMain DO:
    RUN piMarcarDesmarcarTodos IN THIS-PROCEDURE.

    IF RETURN-VALUE = "NOK":U THEN
        RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSelAnalisada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSelAnalisada wWindow
ON CHOOSE OF btSelAnalisada IN FRAME fpage0 /* Selecionar Analisada */
OR CHOOSE OF MENU-ITEM miSelAnalisada IN MENU mbMain DO:
    RUN piSelecionarAnalisadas IN THIS-PROCEDURE.

    IF RETURN-VALUE = "NOK":U THEN
        RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cod-comprado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cod-comprado wWindow
ON VALUE-CHANGED OF cb-cod-comprado IN FRAME fpage0 /* Comprador */
DO:
    ASSIGN INPUT FRAME fPage0 cb-cod-comprado.

    IF cb-cod-comprado = "{&todosUsuarios}":U THEN DO:
        ASSIGN fi-nom_usuario = "Todos os usu†rios":U.
    END.
    ELSE DO:
        FIND FIRST emsfnd.usuar_mestre
            WHERE emsfnd.usuar_mestre.cod_usuario = cb-cod-comprado NO-LOCK NO-ERROR.

        ASSIGN fi-nom_usuario = IF AVAILABLE emsfnd.usuar_mestre THEN emsfnd.usuar_mestre.nom_usuario ELSE "":U.
    END.

    DISPLAY fi-nom_usuario
        WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wWindow
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
    {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miMoverColuna
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miMoverColuna wWindow
ON VALUE-CHANGED OF MENU-ITEM miMoverColuna /* Mover Coluna */
DO:
    IF SELF:CHECKED THEN DO:
        ASSIGN brOrdemCompra:ALLOW-COLUMN-SEARCHING IN FRAME fpage0 = NO
               brOrdemCompra:COLUMN-MOVABLE         IN FRAME fpage0 = YES.
    END.
    ELSE DO:
        ASSIGN brOrdemCompra:ALLOW-COLUMN-SEARCHING IN FRAME fpage0 = YES
               brOrdemCompra:COLUMN-MOVABLE         IN FRAME fpage0 = NO.
    END.

    brOrdemCompra:CLEAR-SORT-ARROWS() IN FRAME fPage0.

    ASSIGN MENU-ITEM miOrdenarColuna:CHECKED IN MENU pmBrOrdemCompra = NOT SELF:CHECKED.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miOrdenarColuna
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miOrdenarColuna wWindow
ON VALUE-CHANGED OF MENU-ITEM miOrdenarColuna /* Ordenar Coluna */
DO:
    IF SELF:CHECKED THEN DO:
        ASSIGN brOrdemCompra:ALLOW-COLUMN-SEARCHING IN FRAME fpage0 = YES
               brOrdemCompra:COLUMN-MOVABLE         IN FRAME fpage0 = NO.
    END.
    ELSE DO:
        ASSIGN brOrdemCompra:ALLOW-COLUMN-SEARCHING IN FRAME fpage0 = NO
               brOrdemCompra:COLUMN-MOVABLE         IN FRAME fpage0 = YES.
    END.

    brOrdemCompra:CLEAR-SORT-ARROWS() IN FRAME fPage0.

    ASSIGN MENU-ITEM miMoverColuna:CHECKED IN MENU pmBrOrdemCompra = NOT SELF:CHECKED.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-cotada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-cotada wWindow
ON VALUE-CHANGED OF tg-cotada IN FRAME fpage0 /* Cotada */
DO:
    ASSIGN INPUT FRAME fPage0 tg-nao-confirmada
                              tg-cotada
                              tg-em-cotacao.

    IF tg-nao-confirmada AND
       tg-cotada         AND
       tg-em-cotacao     THEN
        ASSIGN tg-todas = YES.
    ELSE
        ASSIGN tg-todas = NO.

    DISPLAY tg-todas
        WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-dependente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-dependente wWindow
ON VALUE-CHANGED OF tg-dependente IN FRAME fpage0 /* Dependente */
DO:
    ASSIGN INPUT FRAME fPage0 tg-nao-confirmada
                              tg-cotada
                              tg-em-cotacao.

    IF tg-nao-confirmada AND
       tg-cotada         AND
       tg-em-cotacao     THEN
        ASSIGN tg-todas = YES.
    ELSE
        ASSIGN tg-todas = NO.

    DISPLAY tg-todas
        WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-em-cotacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-em-cotacao wWindow
ON VALUE-CHANGED OF tg-em-cotacao IN FRAME fpage0 /* Em cotaá∆o */
DO:
    ASSIGN INPUT FRAME fPage0 tg-nao-confirmada
                              tg-cotada
                              tg-em-cotacao.

    IF tg-nao-confirmada AND
       tg-cotada         AND
       tg-em-cotacao     THEN
        ASSIGN tg-todas = YES.
    ELSE
        ASSIGN tg-todas = NO.

    DISPLAY tg-todas
        WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-independente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-independente wWindow
ON VALUE-CHANGED OF tg-independente IN FRAME fpage0 /* Independente */
DO:
    ASSIGN INPUT FRAME fPage0 tg-todas.

    ASSIGN tg-nao-confirmada = tg-todas
           tg-cotada         = tg-todas
           tg-em-cotacao     = tg-todas.

    DISPLAY tg-nao-confirmada
            tg-cotada
            tg-em-cotacao
        WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-nao-confirmada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-nao-confirmada wWindow
ON VALUE-CHANGED OF tg-nao-confirmada IN FRAME fpage0 /* N∆o confirmada */
DO:
    ASSIGN INPUT FRAME fPage0 tg-nao-confirmada
                              tg-cotada
                              tg-em-cotacao.

    IF tg-nao-confirmada AND
       tg-cotada         AND
       tg-em-cotacao     THEN
        ASSIGN tg-todas = YES.
    ELSE
        ASSIGN tg-todas = NO.

    DISPLAY tg-todas
        WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-todas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-todas wWindow
ON VALUE-CHANGED OF tg-todas IN FRAME fpage0 /* Todas */
DO:
    ASSIGN INPUT FRAME fPage0 tg-todas.

    ASSIGN tg-nao-confirmada = tg-todas
           tg-cotada         = tg-todas
           tg-em-cotacao     = tg-todas.

    DISPLAY tg-nao-confirmada
            tg-cotada
            tg-em-cotacao
        WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/

ON "VALUE-CHANGED":U OF tt-ordem-compra.l-selecionado IN BROWSE brOrdemCompra
DO:
    ASSIGN INPUT BROWSE brOrdemCompra tt-ordem-compra.l-selecionado.

    APPLY "LEAVE":U TO tt-ordem-compra.l-selecionado IN BROWSE brOrdemCompra.

    APPLY "ROW-DISPLAY":U TO brOrdemCompra IN FRAME fPage0.

    APPLY "VALUE-CHANGED":U TO brOrdemCompra IN FRAME fPage0.
END.

ON "VALUE-CHANGED":U OF tt-ordem-compra.log-analisada IN BROWSE brOrdemCompra
DO:
    IF INPUT BROWSE brOrdemCompra tt-ordem-compra.log-analisada THEN DO:
        IF tt-ordem-compra.situacao <> 3 AND
           tt-ordem-compra.situacao <> 5 THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Para a ordem de compra ser analisada, ela deve estar com situaá∆o ~"Em Cotaá∆o~" ou ~"Cotada~"":U).

            ASSIGN tt-ordem-compra.log-analisada = NO.

            ASSIGN tt-ordem-compra.log-analisada:CHECKED IN BROWSE brOrdemCompra = NO.

            APPLY "ENTRY":U TO tt-ordem-compra.log-analisada IN BROWSE brOrdemCompra.

            RETURN NO-APPLY.
        END.
    END.

    ASSIGN INPUT BROWSE brOrdemCompra tt-ordem-compra.log-analisada.

    FIND FIRST int-analise-ordem-compra
        WHERE int-analise-ordem-compra.numero-ordem = tt-ordem-compra.numero-ordem
          AND int-analise-ordem-compra.parcela      = 1 EXCLUSIVE-LOCK NO-ERROR.

    IF NOT AVAILABLE int-analise-ordem-compra THEN DO:
        CREATE int-analise-ordem-compra.
        ASSIGN int-analise-ordem-compra.numero-ordem = tt-ordem-compra.numero-ordem
               int-analise-ordem-compra.parcela      = 1.
    END.

    ASSIGN int-analise-ordem-compra.log-analisada = tt-ordem-compra.log-analisada.

    APPLY "LEAVE":U TO tt-ordem-compra.log-analisada IN BROWSE brOrdemCompra.
END.

ON "LEAVE":U OF tt-ordem-compra.quantidade IN BROWSE brOrdemCompra
DO: 
    IF INPUT BROWSE brOrdemCompra tt-ordem-compra.quantidade <> tt-ordem-compra.quantidade THEN DO:
        RUN pi-bloqueia-alteracao.
        IF RETURN-VALUE <> "OK" THEN
            RETURN NO-APPLY.

        RUN piValidaQuantidade IN THIS-PROCEDURE (INPUT tt-ordem-compra.numero-ordem,
                                                  INPUT INPUT BROWSE brOrdemCompra tt-ordem-compra.quantidade,
                                                  INPUT tt-ordem-compra.lote-minimo,
                                                  INPUT tt-ordem-compra.lote-mul-for).

        IF RETURN-VALUE = "NOK":U THEN DO:
            DISPLAY tt-ordem-compra.quantidade
                WITH BROWSE brOrdemCompra.

            APPLY "ENTRY":U TO tt-ordem-compra.quantidade IN BROWSE brOrdemCompra.
    
            RETURN NO-APPLY.
        END.
    END.

    ASSIGN INPUT BROWSE brOrdemCompra tt-ordem-compra.quantidade.

    ASSIGN tt-ordem-compra.qtd-for = tt-ordem-compra.quantidade * tt-ordem-compra.indice
           tt-ordem-compra.qtd-for:SCREEN-VALUE IN BROWSE brOrdemCompra = STRING(tt-ordem-compra.quantidade * tt-ordem-compra.indice).

    ASSIGN INPUT BROWSE brOrdemCompra tt-ordem-compra.qtd-for.
    APPLY "ROW-DISPLAY":U TO brOrdemCompra IN FRAME fPage0.
    APPLY "VALUE-CHANGED":U TO brOrdemCompra IN FRAME fPage0.
END.

ON "LEAVE":U OF tt-ordem-compra.data-entrega IN BROWSE brOrdemCompra
DO:
    IF INPUT BROWSE brOrdemCompra tt-ordem-compra.data-entrega <> tt-ordem-compra.data-entrega THEN DO:
        RUN pi-bloqueia-alteracao.
        IF RETURN-VALUE <> "OK" THEN
            RETURN NO-APPLY.

        RUN piValidaDataEntrega IN THIS-PROCEDURE (INPUT tt-ordem-compra.numero-ordem,
                                                   INPUT INPUT BROWSE brOrdemCompra tt-ordem-compra.data-entrega).

        IF RETURN-VALUE = "NOK":U THEN DO:
            DISPLAY tt-ordem-compra.data-entrega
                WITH BROWSE brOrdemCompra.

            APPLY "ENTRY":U TO tt-ordem-compra.data-entrega IN BROWSE brOrdemCompra.

            RETURN NO-APPLY.
        END.
    END.

    ASSIGN INPUT BROWSE brOrdemCompra tt-ordem-compra.data-entrega.

    APPLY "ROW-DISPLAY":U TO brOrdemCompra IN FRAME fPage0.

    APPLY "VALUE-CHANGED":U TO brOrdemCompra IN FRAME fPage0.
END.

/* Determinar o tamanho m°nimo da tela */
ASSIGN wWindow:MIN-WIDTH  = wWindow:WIDTH
       wWindow:MIN-HEIGHT = wWindow:HEIGHT.

/* Guardar valores originais da tela */
ASSIGN de-win-orig-width  = wWindow:WIDTH
       de-win-orig-height = wWindow:HEIGHT.

{window/mainblock.i}

wWindow:WINDOW-STATE = WINDOW-MAXIMIZED.
RUN piWindowResize IN THIS-PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE v-cod-comprado       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v-cod-comprado-atual AS CHARACTER   NO-UNDO.

    ASSIGN v-cod-comprado-atual = "{&todosUsuarios}":U.

    FOR EACH mgcad.usuar-mater USE-INDEX usuar-mater NO-LOCK
        WHERE mgcad.usuar-mater.usuar-comprador = YES:
        IF v-cod-comprado <> "":U THEN
            ASSIGN v-cod-comprado = v-cod-comprado + ",":U.

        ASSIGN v-cod-comprado = v-cod-comprado + mgcad.usuar-mater.cod-usuario.

        IF mgcad.usuar-mater.cod-usuario = c-seg-usuario THEN
            ASSIGN v-cod-comprado-atual = mgcad.usuar-mater.cod-usuario.
    END.

    ASSIGN v-cod-comprado = "{&todosUsuarios}":U + ",":U + v-cod-comprado.

    ASSIGN cb-cod-comprado:LIST-ITEMS IN FRAME fPage0 = v-cod-comprado.

    ASSIGN fi-cod-estabel-ini  = "":U
           fi-cod-estabel-fin  = FILL("Z":U, 3)
           fi-it-codigo-ini    = "":U
           fi-it-codigo-fin    = FILL("Z":U, 16)
           fi-data-emissao-ini = DATE(01, 01, 0001)
           fi-data-emissao-fin = DATE(12, 31, 9999)
           fi-cod-emitente-ini = 0
           fi-cod-emitente-fin = 999999999
           cb-cod-comprado     = v-cod-comprado-atual
           tg-todas            = YES
           tg-dependente       = YES
           tg-independente     = YES.

    DISPLAY fi-cod-estabel-ini
            fi-cod-estabel-fin
            fi-it-codigo-ini
            fi-it-codigo-fin
            fi-data-emissao-ini
            fi-data-emissao-fin
            fi-cod-emitente-ini
            fi-cod-emitente-fin
            cb-cod-comprado
            tg-todas
            tg-dependente   
            tg-independente 
        WITH FRAME fPage0.

    APPLY "VALUE-CHANGED":U TO tg-todas IN FRAME fPage0.

    APPLY "VALUE-CHANGED":U TO cb-cod-comprado IN FRAME fPage0.

    RUN piBuscaHandleColunaBrowse IN THIS-PROCEDURE.

    EMPTY TEMP-TABLE tt-ordem-compra.

    brOrdemCompra:CLEAR-SORT-ARROWS() IN FRAME fPage0.

    {&OPEN-QUERY-brOrdemCompra}

    IF CAN-FIND(FIRST tt-ordem-compra) THEN DO:
        brOrdemCompra:SELECT-ROW(1) IN FRAME fPage0.
        brOrdemCompra:SELECT-FOCUSED-ROW() IN FRAME fPage0.
    END.

    APPLY "VALUE-CHANGED":U TO brOrdemCompra IN FRAME fPage0.

    ASSIGN MENU-ITEM miOrdenarColuna:CHECKED IN MENU pmBrOrdemCompra = YES
           MENU-ITEM miMoverColuna:CHECKED   IN MENU pmBrOrdemCompra = NO.

    APPLY "VALUE-CHANGED":U TO MENU-ITEM miOrdenarColuna IN MENU pmBrOrdemCompra.

    APPLY "ENTRY":U TO fi-cod-estabel-ini IN FRAME fPage0.

    /* Maximizar a Window */
    VIEW wWindow.
    wWindow:WINDOW-STATE = WINDOW-MAXIMIZED.
    RUN piWindowResize IN THIS-PROCEDURE.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcula-indice wWindow 
PROCEDURE calcula-indice :
DEFINE INPUT  PARAM p-numero-ordem LIKE ordem-compra.numero-ordem.
    DEFINE INPUT  PARAM p-parcela      LIKE prazo-compra.parcela.
    DEFINE INPUT  PARAM p-it-codigo    LIKE ITEM.it-codigo.
    DEFINE INPUT  PARAM p-cod-emitente LIKE ordem-compra.cod-emitente.
    DEFINE OUTPUT PARAM p-indice       AS DEC.

    FIND FIRST b-prazo-compra NO-LOCK USE-INDEX ordem
         WHERE b-prazo-compra.numero-ordem = p-numero-ordem
           AND b-prazo-compra.parcela      = p-parcela NO-ERROR.

    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = p-it-codigo NO-ERROR.

    ASSIGN p-indice = 1.

    IF AVAILABLE ITEM THEN DO:
        FIND FIRST item-fornec NO-LOCK
             WHERE item-fornec.it-codigo    = ITEM.it-codigo
               AND item-fornec.cod-emitente = p-cod-emitente NO-ERROR.

        IF  (ITEM.tipo-contr = 4 
        AND NOT AVAILABLE item-fornec 
        OR  ITEM.it-codigo = "":U) THEN DO:

            IF  AVAILABLE cotacao-item            
            AND cotacao-item.un <> b-prazo-compra.un THEN DO:

                FIND FIRST tab-conv-un NO-LOCK
                     WHERE tab-conv-un.un           = b-prazo-compra.un
                       AND tab-conv-un.unid-med-for = cotacao-item.un NO-ERROR.

                IF AVAILABLE tab-conv-un THEN
                    ASSIGN p-indice = tab-conv-un.fator-conver / EXP(10, tab-conv-un.num-casa-dec).
            END.
        END.
        ELSE IF AVAILABLE item-fornec THEN
            ASSIGN p-indice = item-fornec.fator-conver / EXP(10, item-fornec.num-casa-dec).
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-bloqueia-alteracao wWindow 
PROCEDURE pi-bloqueia-alteracao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN i = 0.
FOR EACH prazo-compra NO-LOCK
   WHERE prazo-compra.numero-ordem = tt-ordem-compra.numero-ordem:
    ASSIGN i = i + 1.
END.

IF i > 1 THEN DO:
    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 17006,
                       INPUT "Atená∆o, esta ordem possui parcelas!" + "~~" + "Para alterar ordens com mais de uma parcela utilize o bot∆o Parcelar abaixo, sua alteraá∆o ser† desfeita.").
    DISPLAY tt-ordem-compra.quantidade WITH BROWSE brOrdemCompra.
    DISPLAY tt-ordem-compra.data-entrega WITH BROWSE brOrdemCompra.
    
    RETURN "NOK".
END.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-saldo wWindow 
PROCEDURE pi-calcula-saldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH saldo-estoq NO-LOCK
   WHERE saldo-estoq.cod-estabel = tt-ordem-compra.cod-estabel
     AND saldo-estoq.it-codigo   = tt-ordem-compra.it-codigo
     AND saldo-estoq.qtidade-atu > 0:

    ASSIGN tt-ordem-compra.qt-disponivel = tt-ordem-compra.qt-disponivel + saldo-estoq.qtidade-atu
           tt-ordem-compra.qt-alocada    = tt-ordem-compra.qt-alocada + saldo-estoq.qt-alocada.
           

END.

FOR EACH prazo-compra NO-LOCK
   WHERE prazo-compra.it-codigo   = tt-ordem-compra.it-codigo
     AND prazo-compra.situacao    = 2
     AND prazo-compra.quant-saldo > 0,
   FIRST ordem-compra no-lock
   WHERE ordem-compra.cod-estabel  = tt-ordem-compra.cod-estabel
     AND ordem-compra.numero-ordem = prazo-compra.numero-ordem:

    ASSIGN tt-ordem-compra.qt-pedido = tt-ordem-compra.qt-pedido + prazo-compra.quant-saldo.

    IF CAN-FIND(FIRST ordens-embarque NO-LOCK
                WHERE ordens-embarque.numero-ordem  = prazo-compra.numero-ordem
                  AND ordens-embarque.parcela       = prazo-compra.parcela) THEN DO:
       ASSIGN tt-ordem-compra.qt-pedido = 0.
       FOR EACH ordens-embarque NO-LOCK
          WHERE ordens-embarque.numero-ordem  = prazo-compra.numero-ordem
            AND ordens-embarque.parcela       = prazo-compra.parcela:
       
           ASSIGN tt-ordem-compra.qt-pedido = tt-ordem-compra.qt-pedido + ordens-embarque.quantidade.
       
       END.
    END.
END.

FOR LAST ordem-compra USE-INDEX compra-item NO-LOCK
   WHERE ordem-compra.it-codigo = tt-ordem-compra.it-codigo
     AND ordem-compra.data-pedido <> ?:
    ASSIGN tt-ordem-compra.ultimo-preco = ordem-compra.preco-unit.
END.

FIND FIRST item-uni-estab NO-LOCK
     WHERE item-uni-estab.cod-estabel = tt-ordem-compra.cod-estabel
       AND item-uni-estab.it-codigo   = tt-ordem-compra.it-codigo NO-ERROR.
IF AVAIL item-uni-estab THEN
    ASSIGN tt-ordem-compra.quant-segur = item-uni-estab.quant-segur.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAprovarOrdensCompra wWindow 
PROCEDURE piAprovarOrdensCompra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hAcomp   AS HANDLE      NO-UNDO.
    DEFINE VARIABLE iSeq     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE hShowMsg AS HANDLE      NO-UNDO.

    IF NOT CAN-FIND(FIRST tt-ordem-compra
                    WHERE tt-ordem-compra.l-selecionado = YES) THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "N∆o existe Ordem de Compra selecionada para aprovaá∆o!":U).

        RETURN "NOK":U.
    END.

    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 27100,
                       INPUT "Deseja aprovar TODAS as Ordens de Compra selecionadas?":U).

    IF RETURN-VALUE = "NO":U THEN
        RETURN "NOK":U.

    IF NOT VALID-HANDLE(hAcomp)                    OR
       hAcomp:TYPE <> "PROCEDURE":U                OR
       NOT hAcomp:FILE-NAME MATCHES "*ut-acomp*":U THEN
        RUN utp/ut-acomp.p PERSISTENT SET hAcomp.

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-inicializar IN hAcomp (INPUT "Aprovando Ordens Compra...":U).

    EMPTY TEMP-TABLE RowErrors.

    bk-ordem-compra:
    FOR EACH tt-ordem-compra
        WHERE tt-ordem-compra.l-selecionado = YES:

        IF VALID-HANDLE(hAcomp) THEN
            RUN pi-acompanhar IN hAcomp (INPUT "Ordem Compra: ":U + TRIM(STRING(tt-ordem-compra.numero-ordem, "zzzzz9,99":U))).

        IF tt-ordem-compra.situacao   = 5 /* Em Cotaá∆o */ THEN DO:
            /*Busca primeira cotaá∆o com fornecedor parametrizado no cc0531 (data <> 11/11/1111)*/
            FIND FIRST cotacao-item NO-LOCK 
                 WHERE cotacao-item.numero-ordem = tt-ordem-compra.numero-ordem 
                   AND cotacao-item.data-cotacao <> 11/11/1111 NO-ERROR.
        END.
        ELSE DO:
            FIND FIRST cotacao-item
                 WHERE cotacao-item.numero-ordem = tt-ordem-compra.numero-ordem NO-LOCK NO-ERROR.
        END.

        IF NOT AVAILABLE cotacao-item THEN DO:
            RUN piCriaRowErrors IN THIS-PROCEDURE (INPUT 2,
                                                   INPUT "Cotaá∆o Item":U +
                                                         "~~":U +
                                                         "Ordem Compra: ":U + TRIM(STRING(tt-ordem-compra.numero-ordem, "zzzzz9,99":U))).

            UNDO bk-ordem-compra, NEXT bk-ordem-compra.
        END.

        RUN ccp/ccapi340.p (INPUT  cotacao-item.cod-emitente,
                            INPUT  cotacao-item.numero-ordem,
                            INPUT  cotacao-item.it-codigo,
                            INPUT  cotacao-item.seq-cotac,
                            OUTPUT TABLE tt-erros-geral).

        IF CAN-FIND(FIRST tt-erros-geral) THEN DO:
            FOR EACH tt-erros-geral:
                RUN piCriaRowErrors IN THIS-PROCEDURE (INPUT 17006,
                                                       INPUT tt-erros-geral.des-erro + "(":U + TRIM(STRING(tt-erros-geral.cod-erro)) + ")":U +
                                                             "~~":U +
                                                             tt-erros-geral.des-erro + CHR(10) + tt-erros-geral.identif-msg).
            END.

            UNDO bk-ordem-compra, NEXT bk-ordem-compra.
        END.

        FIND FIRST ordem-compra
            WHERE ROWID(ordem-compra) = tt-ordem-compra.r-Rowid EXCLUSIVE-LOCK NO-ERROR.

        IF NOT AVAILABLE ordem-compra THEN DO:
            RUN piCriaRowErrors IN THIS-PROCEDURE (INPUT 2,
                                                   INPUT "Ordem Compra":U +
                                                         "~~":U +
                                                         "Ordem Compra: ":U + TRIM(STRING(tt-ordem-compra.numero-ordem, "zzzzz9,99":U))).

            UNDO bk-ordem-compra, NEXT bk-ordem-compra.
        END.
            
        IF  tt-ordem-compra.situacao   = 5 /* EM COTAÄ«O */
        AND tt-ordem-compra.preco-unit = 0 THEN DO:
            RUN piCriaRowErrors IN THIS-PROCEDURE (INPUT 17006,
                                                   INPUT "Ordem Compra com preáo 0 (zero).":U +
                                                         "~~":U +
                                                         "Ordem Compra: ":U + TRIM(STRING(tt-ordem-compra.numero-ordem, "zzzzz9,99":U)) + 
                                                         " com situaá∆o 'Em Cotaá∆o' possui preáo 0 (zero).").
    
            UNDO bk-ordem-compra, NEXT bk-ordem-compra.
        END. /* IF  tt-ordem-compra.situacao   = 5 */

        ASSIGN ordem-compra.situacao = 3. /* COTADA */

        FOR EACH prazo-compra EXCLUSIVE-LOCK
            WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem:
            ASSIGN prazo-compra.situacao = ordem-compra.situacao.
        END.

        BUFFER-COPY ordem-compra EXCEPT numero-ordem TO tt-ordem-compra.

        FIND FIRST item
            WHERE item.it-codigo = ordem-compra.it-codigo NO-LOCK NO-ERROR.

        ASSIGN tt-ordem-compra.desc-item = IF AVAILABLE item THEN item.desc-item ELSE "":U.

        FIND FIRST emitente
            WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK NO-ERROR.

        ASSIGN tt-ordem-compra.nome-abrev-fornec = IF AVAILABLE emitente THEN emitente.nome-abrev ELSE "":U.

        ASSIGN tt-ordem-compra.desc-situacao = {ininc/i02in274.i 04 ordem-compra.situacao}.

        FIND FIRST prazo-compra
            WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
              AND prazo-compra.parcela      = 1 NO-LOCK NO-ERROR.

        ASSIGN tt-ordem-compra.quantidade   = IF AVAILABLE prazo-compra THEN prazo-compra.quantidade   ELSE ?
               tt-ordem-compra.data-entrega = IF AVAILABLE prazo-compra THEN prazo-compra.data-entrega ELSE ?.

        FIND FIRST item-fornec-estab
            WHERE item-fornec-estab.it-codigo    = ordem-compra.it-codigo
              AND item-fornec-estab.cod-emitente = ordem-compra.cod-emitente
              AND item-fornec-estab.cod-estabel  = ordem-compra.cod-estabel NO-LOCK NO-ERROR.

        ASSIGN tt-ordem-compra.tempo-ressup = IF AVAILABLE item-fornec-estab THEN item-fornec-estab.tempo-ressup ELSE ?
               tt-ordem-compra.lote-minimo  = IF AVAILABLE item-fornec-estab THEN item-fornec-estab.lote-minimo  ELSE ?
               tt-ordem-compra.lote-mul-for = IF AVAILABLE item-fornec-estab THEN item-fornec-estab.lote-mul-for ELSE ?.

        ASSIGN tt-ordem-compra.qtd-for = tt-ordem-compra.quantidade * tt-ordem-compra.indice
               tt-ordem-compra.qtd-for:SCREEN-VALUE IN BROWSE brOrdemCompra = STRING(tt-ordem-compra.quantidade * tt-ordem-compra.indice).

        RELEASE prazo-compra.

        RELEASE ordem-compra.
    END.

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-finalizar IN hAcomp.

    IF VALID-HANDLE(hAcomp) THEN
        DELETE PROCEDURE hAcomp.

    ASSIGN hAcomp = ?.

    brOrdemCompra:REFRESH() IN FRAME fPage0.

    APPLY "VALUE-CHANGED":U TO brOrdemCompra IN FRAME fPage0.

    IF CAN-FIND(FIRST RowErrors) THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2 &Modal="YES"}
        {method/showmessage.i3}
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizarRegistros wWindow 
PROCEDURE piAtualizarRegistros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE l-encontrou AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE de-indice   AS DECIMAL     NO-UNDO.

    ASSIGN l-encontrou = NO.

    SESSION:SET-WAIT-STATE("GENERAL":U).

    FOR EACH tt-ordem-compra NO-LOCK:
        FIND FIRST prazo-compra
            WHERE prazo-compra.numero-ordem = tt-ordem-compra.numero-ordem
              AND prazo-compra.parcela      = 1 NO-LOCK NO-ERROR.

        IF AVAILABLE prazo-compra THEN DO:
            IF tt-ordem-compra.quantidade <> prazo-compra.quantidade THEN
                ASSIGN l-encontrou = YES.

            IF tt-ordem-compra.data-entrega <> prazo-compra.data-entrega THEN
                ASSIGN l-encontrou = YES.
        END.

        IF l-encontrou THEN
            LEAVE.
    END.

    SESSION:SET-WAIT-STATE("":U).

    IF NOT l-encontrou THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Nenhum registro foi encontrado para ser atualizado!":U).

        RETURN "NOK":U.
    END.

    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 27100,
                       INPUT "Todos os registros alterados ser∆o atualizados! Deseja continuar?":U).

    IF RETURN-VALUE = "NO":U THEN
        RETURN "NOK":U.

    SESSION:SET-WAIT-STATE("GENERAL":U).

    FOR EACH tt-ordem-compra NO-LOCK:
        FIND FIRST prazo-compra
            WHERE prazo-compra.numero-ordem = tt-ordem-compra.numero-ordem
              AND prazo-compra.parcela      = 1 EXCLUSIVE-LOCK NO-ERROR.

        IF AVAILABLE prazo-compra THEN DO:
            IF tt-ordem-compra.quantidade <> prazo-compra.quantidade THEN DO:
                ASSIGN prazo-compra.quantidade  = tt-ordem-compra.quantidade
                       prazo-compra.quant-saldo = prazo-compra.quantidade.

                FIND FIRST cotacao-item
                    WHERE cotacao-item.numero-ordem = prazo-compra.numero-ordem EXCLUSIVE-LOCK NO-ERROR.

                IF AVAILABLE cotacao-item THEN
                    ASSIGN cotacao-item.data-cotacao = TODAY
                           cotacao-item.usuario      = c-seg-usuario
                           cotacao-item.data-atualiz = TODAY
                           cotacao-item.hora-atualiz = TRIM(STRING(TIME, "hh:mm:ss":U)).

                FIND FIRST ordem-compra
                    WHERE ROWID(ordem-compra) = tt-ordem-compra.r-Rowid EXCLUSIVE-LOCK NO-ERROR.

                IF AVAILABLE ordem-compra THEN DO:
                    ASSIGN ordem-compra.qt-solic = 0.

                    FOR EACH b-prazo-compra NO-LOCK
                        WHERE b-prazo-compra.numero-ordem = ordem-compra.numero-ordem:
                        ASSIGN ordem-compra.qt-solic = ordem-compra.qt-solic + b-prazo-compra.quantidade.
                    END.

                    ASSIGN ordem-compra.usuario      = c-seg-usuario
                           ordem-compra.data-atualiz = TODAY
                           ordem-compra.hora-atualiz = STRING(TIME, "hh:mm:ss":U).
                END.

                ASSIGN de-indice = 1.

                FIND FIRST item
                    WHERE item.it-codigo = tt-ordem-compra.it-codigo NO-LOCK NO-ERROR.

                IF AVAILABLE item THEN DO:
                    FIND FIRST item-fornec
                        WHERE item-fornec.it-codigo    = item.it-codigo
                          AND item-fornec.cod-emitente = tt-ordem-compra.cod-emitente NO-LOCK NO-ERROR.

                    IF (item.tipo-contr = 4 AND NOT AVAILABLE item-fornec OR item.it-codigo = "":U) THEN DO:
                        IF AVAILABLE cotacao-item             AND
                           cotacao-item.un <> prazo-compra.un THEN DO:
                            FIND FIRST tab-conv-un
                                WHERE tab-conv-un.un           = prazo-compra.un
                                  AND tab-conv-un.unid-med-for = cotacao-item.un NO-LOCK NO-ERROR.

                            IF AVAILABLE tab-conv-un THEN
                                ASSIGN de-indice = tab-conv-un.fator-conver / EXP(10, tab-conv-un.num-casa-dec).
                        END.
                    END.
                    ELSE IF AVAILABLE item-fornec THEN
                        ASSIGN de-indice = item-fornec.fator-conver / EXP(10, item-fornec.num-casa-dec).
                END.

                ASSIGN prazo-compra.qtd-do-forn  = prazo-compra.quantidade * de-indice
                       prazo-compra.qtd-sal-forn = prazo-compra.qtd-do-forn.
            END.

            IF tt-ordem-compra.data-entrega <> prazo-compra.data-entrega THEN DO:
                ASSIGN prazo-compra.data-entrega-ant = prazo-compra.data-entrega
                       prazo-compra.data-entrega     = tt-ordem-compra.data-entrega.

                FOR EACH evento-ped EXCLUSIVE-LOCK
                    WHERE  evento-ped.numero-ordem = prazo-compra.numero-ordem
                      AND (evento-ped.seq-evento   = 1
                       OR  evento-ped.seq-evento   = 2):
                    FIND FIRST item
                        WHERE item.it-codigo = tt-ordem-compra.it-codigo NO-LOCK NO-ERROR.

                    IF NOT AVAILABLE item THEN
                        NEXT.

                    IF evento-ped.des-event = "Cotar Ordem n£mero ":U + STRING(prazo-compra.numero-ordem, "zzzzz9,99":U) THEN
                        ASSIGN evento-ped.dt-evento     = prazo-compra.data-entrega - (item.res-for-comp + item.res-cq-comp + item.res-int-comp)
                               evento-ped.ind-sit-event = 1
                               evento-ped.cod-comprado  = ordem-compra.cod-comprado.

                    IF evento-ped.des-event = "Fechar pedido para a Ordem n£mero ":U + STRING(prazo-compra.numero-ordem, "zzzzz9,99":U) THEN
                        ASSIGN evento-ped.dt-evento    = prazo-compra.data-entrega - (item.res-for-comp + item.res-cq-comp)
                               evento-ped.cod-comprado = ordem-compra.cod-comprado.
                END.

                FIND FIRST cotacao-item
                    WHERE cotacao-item.numero-ordem = prazo-compra.numero-ordem EXCLUSIVE-LOCK NO-ERROR.

                IF AVAILABLE cotacao-item THEN
                    ASSIGN cotacao-item.data-cotacao = TODAY
                           cotacao-item.usuario      = c-seg-usuario
                           cotacao-item.data-atualiz = TODAY
                           cotacao-item.hora-atualiz = TRIM(STRING(TIME, "hh:mm:ss":U)).

                FIND FIRST ordem-compra
                    WHERE ROWID(ordem-compra) = tt-ordem-compra.r-Rowid EXCLUSIVE-LOCK NO-ERROR.

                IF AVAILABLE ordem-compra THEN DO:
                    ASSIGN ordem-compra.usuario          = c-seg-usuario
                           ordem-compra.data-atualiz     = TODAY
                           ordem-compra.hora-atualiz     = STRING(TIME, "hh:mm:ss":U).
                END.
            END.
        END.

        RELEASE ordem-compra.
        RELEASE cotacao-item.
        RELEASE b-prazo-compra.
        RELEASE prazo-compra.
    END.

    SESSION:SET-WAIT-STATE("":U).

    brOrdemCompra:REFRESH() IN FRAME fPage0.

    APPLY "VALUE-CHANGED":U TO brOrdemCompra IN FRAME fPage0.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaHandleColunaBrowse wWindow 
PROCEDURE piBuscaHandleColunaBrowse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-coluna AS HANDLE      NO-UNDO.

    ASSIGN h-coluna            = BROWSE brOrdemCompra:FIRST-COLUMN
           lista-handle-coluna = "":U.

    DO WHILE VALID-HANDLE(h-coluna):
/*         IF h-coluna:NAME = "l-selecionado":U THEN DO:              */
/*             ASSIGN h-coluna:COLUMN-BGCOLOR = FRAME fPage0:BGCOLOR. */
/*                                                                    */
/*             ASSIGN h-coluna = h-coluna:NEXT-COLUMN.                */
/*                                                                    */
/*             NEXT.                                                  */
/*         END.                                                       */

        ASSIGN lista-handle-coluna = IF lista-handle-coluna = "":U THEN STRING(h-coluna) ELSE lista-handle-coluna + ",":U + STRING(h-coluna).

        ASSIGN h-coluna:WIDTH = h-coluna:WIDTH + 1.75.

        IF h-coluna:READ-ONLY OR h-coluna:TYPE = "TOGGLE-BOX":U THEN
            ASSIGN h-coluna:COLUMN-BGCOLOR = FRAME fPage0:BGCOLOR.

        ASSIGN h-coluna = h-coluna:NEXT-COLUMN.
    END.

    ASSIGN h-coluna = ?.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaRowErrors wWindow 
PROCEDURE piCriaRowErrors :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pNumMessage   AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER pParamMessage AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE iSequence AS INTEGER     NO-UNDO.

    FIND LAST RowErrors NO-ERROR.

    ASSIGN iSequence = IF AVAILABLE RowErrors THEN RowErrors.ErrorSequence + 1 ELSE 1.

    CREATE RowErrors.
    ASSIGN RowErrors.ErrorSequence = iSequence
           RowErrors.ErrorNumber   = pNumMessage
           RowErrors.ErrorType     = "EMS":U
           RowErrors.ErrorSubType  = "ERROR":U.

    RUN utp/ut-msgs.p (INPUT "MSG":U,
                       INPUT pNumMessage,
                       INPUT pParamMessage).

    ASSIGN RowErrors.ErrorDescription = RETURN-VALUE.

    RUN utp/ut-msgs.p (INPUT "HELP":U,
                       INPUT pNumMessage,
                       INPUT pParamMessage).

    ASSIGN RowErrors.ErrorHelp = RETURN-VALUE.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDesfazerAlteracao wWindow 
PROCEDURE piDesfazerAlteracao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE l-encontrado AS LOGICAL     NO-UNDO.

    IF brOrdemCompra:NUM-SELECTED-ROWS IN FRAME fPage0 = 0 THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Nenhuma Ordem de Compra foi selecionada para desfazer alteraá∆o!":U).

        RETURN "NOK":U.
    END.

    ASSIGN l-encontrado = NO.

    SESSION:SET-WAIT-STATE("GENERAL":U).

    IF AVAILABLE tt-ordem-compra THEN DO:
        FIND FIRST prazo-compra
            WHERE prazo-compra.numero-ordem = tt-ordem-compra.numero-ordem
              AND prazo-compra.parcela      = 1 NO-LOCK NO-ERROR.

        IF AVAILABLE prazo-compra THEN DO:
            IF tt-ordem-compra.quantidade <> prazo-compra.quantidade THEN
                ASSIGN l-encontrado = YES.

            IF tt-ordem-compra.data-entrega <> prazo-compra.data-entrega THEN
                ASSIGN l-encontrado = YES.
        END.
    END.

    SESSION:SET-WAIT-STATE("":U).

    IF NOT l-encontrado THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "O registro selecionado n∆o possui valor alterado para ser desfeito!":U).

        APPLY "VALUE-CHANGED":U TO brOrdemCompra IN FRAME fPage0.

        RETURN "NOK":U.
    END.

    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 27100,
                       INPUT "Deseja desfazer as alteraá‰es do registro selecionado?":U).

    IF RETURN-VALUE = "NO":U THEN
        RETURN "NOK":U.

    SESSION:SET-WAIT-STATE("GENERAL":U).

    IF AVAILABLE tt-ordem-compra THEN DO:
        FIND FIRST prazo-compra
            WHERE prazo-compra.numero-ordem = tt-ordem-compra.numero-ordem
              AND prazo-compra.parcela      = 1 NO-LOCK NO-ERROR.

        IF AVAILABLE prazo-compra THEN DO:
            IF tt-ordem-compra.quantidade <> prazo-compra.quantidade THEN DO:
                ASSIGN tt-ordem-compra.quantidade = prazo-compra.quantidade.

                DISPLAY tt-ordem-compra.quantidade
                    WITH BROWSE brOrdemCompra.

                APPLY "LEAVE":U TO tt-ordem-compra.quantidade IN BROWSE brOrdemCompra.

                APPLY "ENTRY":U TO brOrdemCompra IN FRAME fPage0.

                APPLY "VALUE-CHANGED":U TO brOrdemCompra IN FRAME fPage0.
            END.

            IF tt-ordem-compra.data-entrega <> prazo-compra.data-entrega THEN DO:
                ASSIGN tt-ordem-compra.data-entrega = prazo-compra.data-entrega.

                DISPLAY tt-ordem-compra.data-entrega
                    WITH BROWSE brOrdemCompra.

                APPLY "LEAVE":U TO tt-ordem-compra.data-entrega IN BROWSE brOrdemCompra.

                APPLY "ENTRY":U TO brOrdemCompra IN FRAME fPage0.

                APPLY "VALUE-CHANGED":U TO brOrdemCompra IN FRAME fPage0.
            END.
        END.
    END.

    SESSION:SET-WAIT-STATE("":U).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEliminarOrdensCompra wWindow 
PROCEDURE piEliminarOrdensCompra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hAcomp AS HANDLE      NO-UNDO.

    FIND FIRST tt-ordem-compra
        WHERE tt-ordem-compra.l-selecionado = YES NO-ERROR.

    IF NOT AVAILABLE tt-ordem-compra THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "N∆o existe Ordem de Compra selecionada para eliminaá∆o!":U).

        RETURN "NOK":U.
    END.

    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 27100,
                       INPUT "Deseja eliminar TODAS as Ordens de Compra selecionadas?":U).

    IF RETURN-VALUE = "NO":U THEN
        RETURN "NOK":U.

    IF NOT VALID-HANDLE(hAcomp)                    OR
       hAcomp:TYPE <> "PROCEDURE":U                OR
       NOT hAcomp:FILE-NAME MATCHES "*ut-acomp*":U THEN
        RUN utp/ut-acomp.p PERSISTENT SET hAcomp.

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-inicializar IN hAcomp (INPUT "Eliminando Ordens Compra...":U).

    DISABLE TRIGGERS FOR LOAD OF ordem-compra.
    DISABLE TRIGGERS FOR LOAD OF cotacao-item-cex.
    DISABLE TRIGGERS FOR LOAD OF cotacao-item.
    DISABLE TRIGGERS FOR LOAD OF prazo-compra.
    DISABLE TRIGGERS FOR LOAD OF texto-follow-up.
    DISABLE TRIGGERS FOR LOAD OF unid-neg-ordem.
    DISABLE TRIGGERS FOR LOAD OF ordem-compra.

    FOR EACH tt-ordem-compra
        WHERE tt-ordem-compra.l-selecionado,
        FIRST ordem-compra EXCLUSIVE-LOCK
        WHERE ROWID(ordem-compra) = tt-ordem-compra.r-Rowid:

        IF VALID-HANDLE(hAcomp) THEN
            RUN pi-acompanhar IN hAcomp (INPUT "Ordem Compra: ":U + TRIM(STRING(tt-ordem-compra.numero-ordem, "zzzzz9,99":U))).

        /** Eliminar Despesas Adicionais de Importaá∆o das Cotaá‰es do Item **/
        FOR EACH cotacao-item-cex EXCLUSIVE-LOCK
            WHERE cotacao-item-cex.numero-ordem = ordem-compra.numero-ordem:
            DELETE cotacao-item-cex.
        END.
    
        /** Eliminar Cotaá‰es do Item **/
        FOR EACH cotacao-item EXCLUSIVE-LOCK
            WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem:
            DELETE cotacao-item.
        END.

        /** Eliminar Parcelas da Ordem de Compra **/
        FOR EACH prazo-compra EXCLUSIVE-LOCK
            WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem:
            DELETE prazo-compra.
        END.

        /** Eliminar Texto Follow-Up **/
        FOR EACH texto-follow-up EXCLUSIVE-LOCK
            WHERE texto-follow-up.numero-ordem = ordem-compra.numero-ordem:
            DELETE texto-follow-up.
        END.

        /** Eliminar Integraá∆o Unidade de Neg¢cio **/
        FIND FIRST param-mat NO-LOCK NO-ERROR.

        IF AVAILABLE param-mat    AND
           param-mat.ind-unid-neg THEN DO:
            FOR EACH unid-neg-ordem EXCLUSIVE-LOCK
                where unid-neg-ordem.numero-ordem = ordem-compra.numero-ordem:
                DELETE unid-neg-ordem.
            END.
        END.

        DELETE ordem-compra.

        DELETE tt-ordem-compra.
    END.

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-finalizar IN hAcomp.

    IF VALID-HANDLE(hAcomp) THEN
        DELETE PROCEDURE hAcomp.

    ASSIGN hAcomp = ?.

    brOrdemCompra:CLEAR-SORT-ARROWS() IN FRAME fPage0.

    {&OPEN-QUERY-brOrdemCompra}

    IF CAN-FIND(FIRST tt-ordem-compra) THEN DO:
        brOrdemCompra:SELECT-ROW(1) IN FRAME fPage0.
        brOrdemCompra:SELECT-FOCUSED-ROW() IN FRAME fPage0.
    END.

    APPLY "VALUE-CHANGED":U TO brOrdemCompra IN FRAME fPage0.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piFiltrarSelecao wWindow 
PROCEDURE piFiltrarSelecao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hAcomp            AS HANDLE      NO-UNDO.
    DEFINE VARIABLE cWhereCodEstabel  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cWhereItCodigo    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cWhereDataEmissao AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cWhereCodEmitente AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cWhereCodComprado AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cWhereSituacao    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cQuery            AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE hQuery            AS HANDLE      NO-UNDO.
    DEFINE VARIABLE cDemanda          AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE de-indice         AS DECIMAL     NO-UNDO.

    brOrdemCompra:CLEAR-SORT-ARROWS() IN FRAME fPage0.

    EMPTY TEMP-TABLE tt-ordem-compra.

    {&OPEN-QUERY-brOrdemCompra}

    ASSIGN INPUT FRAME fPage0 fi-cod-estabel-ini
                              fi-cod-estabel-fin
                              fi-it-codigo-ini
                              fi-it-codigo-fin
                              fi-data-emissao-ini
                              fi-data-emissao-fin
                              fi-cod-emitente-ini
                              fi-cod-emitente-fin
                              cb-cod-comprado
                              tg-nao-confirmada
                              tg-cotada
                              tg-em-cotacao
                              tg-dependente
                              tg-independente.

    IF  tg-dependente  
    AND tg-independente THEN DO:
        ASSIGN cDemanda = "3". /*Ambos*/
    END.                    
    ELSE IF tg-dependente THEN DO:
        ASSIGN cDemanda = "1". /*Dependente*/
    END.
    ELSE IF tg-independente THEN DO:
        ASSIGN cDemanda = "2". /*Independente*/
    END.
    ELSE DO:
        ASSIGN cDemanda = "0". /*Nenhum*/
    END.

    IF fi-cod-estabel-ini > fi-cod-estabel-fin THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 285,
                           INPUT "":U).

        RETURN "NOK":U.
    END.

    IF fi-it-codigo-ini > fi-it-codigo-fin THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 15431,
                           INPUT "":U).

        RETURN "NOK":U.
    END.

    IF fi-data-emissao-ini > fi-data-emissao-fin THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 406,
                           INPUT "":U).

        RETURN "NOK":U.
    END.

    IF fi-cod-emitente-ini > fi-cod-emitente-fin THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 2713,
                           INPUT "":U).

        RETURN "NOK":U.
    END.

    IF NOT tg-nao-confirmada AND
       NOT tg-cotada         AND
       NOT tg-em-cotacao     THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Nenhuma ~"Situaá∆o~" foi selecionada!":U +
                                 "~~":U +
                                 "Selecione ao menos uma ~"Situaá∆o~" (N∆o Confirmada, Cotada e/ou Em Cotaá∆o).":U).

        RETURN "NOK":U.
    END.

    IF NOT VALID-HANDLE(hAcomp)                    OR
       hAcomp:TYPE <> "PROCEDURE":U                OR
       NOT hAcomp:FILE-NAME MATCHES "*ut-acomp*":U THEN
        RUN utp/ut-acomp.p PERSISTENT SET hAcomp.

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-inicializar IN hAcomp (INPUT "Filtrando Ordens Compra...":U).

    ASSIGN cWhereCodEstabel = "":U.

    IF fi-cod-estabel-ini = fi-cod-estabel-fin THEN
        ASSIGN cWhereCodEstabel = " ordem-compra.cod-estabel = ":U + QUOTER(TRIM(fi-cod-estabel-ini)) + " ":U.
    ELSE DO:
        IF fi-cod-estabel-ini > "":U THEN
            ASSIGN cWhereCodEstabel = " ordem-compra.cod-estabel >= ":U + QUOTER(TRIM(fi-cod-estabel-ini)) + " ":U.

        IF fi-cod-estabel-fin < FILL("Z":U, 3) THEN DO:
            IF cWhereCodEstabel <> "":U THEN
                ASSIGN cWhereCodEstabel = cWhereCodEstabel + " AND ":U.

            ASSIGN cWhereCodEstabel = cWhereCodEstabel + " ordem-compra.cod-estabel <= ":U + QUOTER(TRIM(fi-cod-estabel-fin)) + " ":U.
        END.
    END.

    ASSIGN cWhereItCodigo = "":U.

    IF fi-it-codigo-ini = fi-it-codigo-fin THEN
        ASSIGN cWhereItCodigo = " ordem-compra.it-codigo = ":U + QUOTER(TRIM(fi-it-codigo-ini)) + " ":U.
    ELSE DO:
        IF fi-it-codigo-ini > "":U THEN
            ASSIGN cWhereItCodigo = " ordem-compra.it-codigo >= ":U + QUOTER(TRIM(fi-it-codigo-ini)) + " ":U.

        IF fi-it-codigo-fin < FILL("Z":U, 16) THEN DO:
            IF cWhereItCodigo <> "":U THEN
                ASSIGN cWhereItCodigo = cWhereItCodigo + " AND ":U.

            ASSIGN cWhereItCodigo = cWhereItCodigo + " ordem-compra.it-codigo <= ":U + QUOTER(TRIM(fi-it-codigo-fin)) + " ":U.
        END.
    END.

    ASSIGN cWhereDataEmissao = "":U.

    IF fi-data-emissao-ini = fi-data-emissao-fin THEN
        ASSIGN cWhereDataEmissao = " ordem-compra.data-emissao = DATE(":U + TRIM(STRING(MONTH(fi-data-emissao-ini), "99":U)) + ", ":U + TRIM(STRING(DAY(fi-data-emissao-ini), "99":U)) + ", ":U + TRIM(STRING(YEAR(fi-data-emissao-ini), "9999":U)) + ") ":U.
    ELSE DO:
        IF fi-data-emissao-ini > DATE(01, 01, 0001) THEN
            ASSIGN cWhereDataEmissao = " ordem-compra.data-emissao >= DATE(":U + TRIM(STRING(MONTH(fi-data-emissao-ini), "99":U)) + ", ":U + TRIM(STRING(DAY(fi-data-emissao-ini), "99":U)) + ", ":U + TRIM(STRING(YEAR(fi-data-emissao-ini), "9999":U)) + ") ":U.

        IF fi-data-emissao-fin < DATE(12, 31, 9999) THEN DO:
            IF cWhereDataEmissao <> "":U THEN
                ASSIGN cWhereDataEmissao = cWhereDataEmissao + " AND ":U.

            ASSIGN cWhereDataEmissao = cWhereDataEmissao + " ordem-compra.data-emissao <= DATE(":U + TRIM(STRING(MONTH(fi-data-emissao-fin), "99":U)) + ", ":U + TRIM(STRING(DAY(fi-data-emissao-fin), "99":U)) + ", ":U + TRIM(STRING(YEAR(fi-data-emissao-fin), "9999":U)) + ") ":U.
        END.
    END.

    ASSIGN cWhereCodEmitente = "":U.

    IF fi-cod-emitente-ini = fi-cod-emitente-fin THEN
        ASSIGN cWhereCodEmitente = " ordem-compra.cod-emitente = ":U + TRIM(STRING(fi-cod-emitente-ini)) + " ":U.
    ELSE DO:
        IF fi-cod-emitente-ini > 0 THEN
            ASSIGN cWhereCodEmitente = " ordem-compra.cod-emitente >= ":U + TRIM(STRING(fi-cod-emitente-ini)) + " ":U.

        IF fi-cod-emitente-fin < 999999999 THEN DO:
            IF cWhereCodEmitente <> "":U THEN
                ASSIGN cWhereCodEmitente = cWhereCodEmitente + " AND ":U.

            ASSIGN cWhereCodEmitente = cWhereCodEmitente + " ordem-compra.cod-emitente <= ":U + TRIM(STRING(fi-cod-emitente-fin)) + " ":U.
        END.
    END.

    ASSIGN cWhereCodComprado = "":U.

    IF cb-cod-comprado <> "{&todosUsuarios}":U THEN
        ASSIGN cWhereCodComprado = " ordem-compra.cod-comprado = ":U + QUOTER(TRIM(cb-cod-comprado)) + " ":U.

    ASSIGN cWhereSituacao = "":U.

    IF tg-nao-confirmada THEN
        ASSIGN cWhereSituacao = cWhereSituacao + " ordem-compra.situacao = 1 ":U.

    IF tg-cotada THEN DO:
        IF cWhereSituacao <> "":U THEN
            ASSIGN cWhereSituacao = cWhereSituacao + " OR ":U.

        ASSIGN cWhereSituacao = cWhereSituacao + " ordem-compra.situacao = 3 ":U.
    END.

    IF tg-em-cotacao THEN DO:
        IF cWhereSituacao <> "":U THEN
            ASSIGN cWhereSituacao = cWhereSituacao + " OR ":U.

        ASSIGN cWhereSituacao = cWhereSituacao + " ordem-compra.situacao = 5 ":U.
    END.

    ASSIGN cWhereSituacao = " (":U + cWhereSituacao + ") ":U.

    IF cWhereCodEstabel <> "":U THEN DO:
        IF cWhereItCodigo <> "":U THEN
            ASSIGN cQuery = "FOR EACH ordem-compra USE-INDEX estab-item-sit WHERE ":U + cWhereCodEstabel + " AND ":U + cWhereItCodigo + " AND ":U + cWhereSituacao + " ":U.
        ELSE
            ASSIGN cQuery = "FOR EACH ordem-compra USE-INDEX estab-situa WHERE ":U + cWhereCodEstabel + " AND ":U + cWhereSituacao + " ":U.
    END.
    ELSE IF cWhereItCodigo <> "":U THEN
        ASSIGN cQuery = "FOR EACH ordem-compra USE-INDEX pedido-item WHERE ordem-compra.num-pedido = 0 AND ":U + cWhereItCodigo + " AND ":U + cWhereSituacao + " ":U.

    IF cWhereDataEmissao <> "":U THEN DO:
        IF cQuery <> "":U THEN
            ASSIGN cQuery = cQuery + " AND ":U + cWhereDataEmissao + " ":U.
        ELSE
            ASSIGN cQuery = "FOR EACH ordem-compra USE-INDEX data-emissao WHERE ":U + cWhereDataEmissao + " AND ":U + cWhereSituacao + " ":U.
    END.

    IF cWhereCodEmitente <> "":U THEN DO:
        IF cQuery <> "":U THEN
            ASSIGN cQuery = cQuery + " AND ":U + cWhereCodEmitente + " ":U.
        ELSE
            ASSIGN cQuery = "FOR EACH ordem-compra USE-INDEX emitente WHERE ":U + cWhereCodEmitente + " AND ":U + cWhereSituacao + " ":U.
    END.

    IF cWhereCodComprado <> "":U THEN DO:
        IF cQuery <> "":U THEN
            ASSIGN cQuery = cQuery + " AND ":U + cWhereCodComprado + " ":U.
        ELSE
            ASSIGN cQuery = "FOR EACH ordem-compra USE-INDEX compr-sit NO-LOCK WHERE ":U + cWhereCodComprado + " AND ":U + cWhereSituacao + " ":U.
    END.

    IF cQuery <> "":U THEN
        ASSIGN cQuery = cQuery + " AND ordem-compra.num-pedido = 0 ":U.
    ELSE
        ASSIGN cQuery = "FOR EACH ordem-compra NO-LOCK WHERE ":U + cWhereSituacao + " AND ordem-compra.num-pedido = 0 ":U.

    /*Query join item-uni-estab*/
    ASSIGN cQuery = cQuery + ", EACH item-uni-estab NO-LOCK WHERE item-uni-estab.cod-estabel = ordem-compra.cod-estabel AND item-uni-estab.it-codigo = ordem-compra.it-codigo ":U.

    /*Filtro demanda*/
    ASSIGN cQuery = cQuery + "AND (" + cDemanda + " = 3 OR item-uni-estab.demanda = " + cDemanda + ")":U.
    
    CREATE QUERY hQuery.

    hQuery:SET-BUFFERS(BUFFER ordem-compra:HANDLE, BUFFER item-uni-estab:HANDLE).
    hQuery:QUERY-PREPARE(cQuery).
    hQuery:QUERY-OPEN().
    hQuery:GET-FIRST().

    DO WHILE NOT hQuery:QUERY-OFF-END:
        IF VALID-HANDLE(hAcomp) THEN
            RUN pi-acompanhar IN hAcomp (INPUT "Ordem Compra: ":U + TRIM(STRING(ordem-compra.numero-ordem, "zzzzz9,99":U))).
        
        CREATE tt-ordem-compra.
        BUFFER-COPY ordem-compra TO tt-ordem-compra.
        ASSIGN tt-ordem-compra.r-Rowid = ROWID(ordem-compra).

        FIND FIRST item
            WHERE item.it-codigo = tt-ordem-compra.it-codigo NO-LOCK NO-ERROR.

        ASSIGN tt-ordem-compra.desc-item = IF AVAILABLE item THEN item.desc-item ELSE "":U.

        RELEASE emitente.

        IF tt-ordem-compra.situacao <> 3 THEN DO:

            /*Para ordens em cotaá∆o busca a primeira cotaá∆o com data */
            IF tt-ordem-compra.situacao   = 5 /* Em Cotaá∆o */  THEN DO:
                FIND FIRST cotacao-item NO-LOCK 
                     WHERE cotacao-item.numero-ordem = tt-ordem-compra.numero-ordem 
                       AND cotacao-item.data-cotacao <> 11/11/1111 NO-ERROR.
            END.
            ELSE DO: 
                FIND FIRST cotacao-item NO-LOCK 
                     WHERE cotacao-item.numero-ordem = tt-ordem-compra.numero-ordem NO-ERROR.
            END.

            IF AVAILABLE cotacao-item THEN DO:
                FIND FIRST emitente
                    WHERE emitente.cod-emitente = cotacao-item.cod-emitente NO-LOCK NO-ERROR.

                IF  tt-ordem-compra.situacao   = 5 /* Em Cotaá∆o */ 
                AND tt-ordem-compra.preco-unit = 0 THEN
                    ASSIGN tt-ordem-compra.preco-unit = cotacao-item.preco-unit.
            END.
            ELSE
                FIND FIRST emitente
                    WHERE emitente.cod-emitente = tt-ordem-compra.cod-emitente NO-LOCK NO-ERROR.
        END.
        ELSE
            FIND FIRST emitente
                WHERE emitente.cod-emitente = tt-ordem-compra.cod-emitente NO-LOCK NO-ERROR.

        ASSIGN tt-ordem-compra.cod-emitente      = IF AVAILABLE emitente THEN emitente.cod-emitente ELSE tt-ordem-compra.cod-emitente
               tt-ordem-compra.nome-abrev-fornec = IF AVAILABLE emitente THEN emitente.nome-abrev   ELSE "":U.

        ASSIGN tt-ordem-compra.desc-situacao = {ininc/i02in274.i 04 tt-ordem-compra.situacao}.

        FIND FIRST int-analise-ordem-compra
            WHERE int-analise-ordem-compra.numero-ordem = tt-ordem-compra.numero-ordem
              AND int-analise-ordem-compra.parcela      = 1 NO-LOCK NO-ERROR.

        ASSIGN tt-ordem-compra.log-analisada = IF AVAILABLE int-analise-ordem-compra THEN int-analise-ordem-compra.log-analisada ELSE NO.

        FIND FIRST int-prazo-compra
             WHERE int-prazo-compra.numero-ordem = tt-ordem-compra.numero-ordem
               AND int-prazo-compra.parcela      = 1 NO-LOCK NO-ERROR.

        ASSIGN tt-ordem-compra.data-necessidade = IF AVAILABLE int-prazo-compra THEN int-prazo-compra.data-necessidade ELSE ?.

        FIND FIRST prazo-compra
            WHERE prazo-compra.numero-ordem = tt-ordem-compra.numero-ordem
              AND prazo-compra.parcela      = 1 NO-LOCK NO-ERROR.

        ASSIGN tt-ordem-compra.quantidade   = IF AVAILABLE prazo-compra THEN prazo-compra.quantidade   ELSE ?
               tt-ordem-compra.data-entrega = IF AVAILABLE prazo-compra THEN prazo-compra.data-entrega ELSE ?.

        ASSIGN tt-ordem-compra.unid-med-for = ?
               tt-ordem-compra.tempo-ressup = ?
               tt-ordem-compra.lote-minimo  = ?
               tt-ordem-compra.lote-mul-for = ?.

        FIND FIRST item-fornec-estab
            WHERE item-fornec-estab.it-codigo    = tt-ordem-compra.it-codigo
              AND item-fornec-estab.cod-emitente = tt-ordem-compra.cod-emitente
              AND item-fornec-estab.cod-estabel  = tt-ordem-compra.cod-estabel NO-LOCK NO-ERROR.

        IF AVAILABLE item-fornec-estab THEN
            ASSIGN tt-ordem-compra.unid-med-for = item-fornec-estab.unid-med-for
                   tt-ordem-compra.tempo-ressup = item-fornec-estab.tempo-ressup
                   tt-ordem-compra.lote-minimo  = item-fornec-estab.lote-minimo
                   tt-ordem-compra.lote-mul-for = item-fornec-estab.lote-mul-for.
        ELSE DO:
            FIND FIRST item-uni-estab
                WHERE item-uni-estab.cod-estabel = tt-ordem-compra.cod-estabel
                  AND item-uni-estab.it-codigo   = tt-ordem-compra.it-codigo NO-LOCK NO-ERROR.

            IF AVAILABLE item-uni-estab THEN
                ASSIGN tt-ordem-compra.unid-med-for = IF AVAILABLE item THEN item.un ELSE "":U
                       tt-ordem-compra.tempo-ressup = item-uni-estab.tempo-segur
                       tt-ordem-compra.lote-minimo  = item-uni-estab.lote-minimo
                       tt-ordem-compra.lote-mul-for = item-uni-estab.lote-multipl.
        END.

        IF AVAIL prazo-compra THEN DO:
            RUN calcula-indice (INPUT  prazo-compra.numero-ordem,
                                INPUT  prazo-compra.parcela,     
                                INPUT  ordem-compra.it-codigo,   
                                INPUT  tt-ordem-compra.cod-emitente,
                                OUTPUT de-indice).

            ASSIGN tt-ordem-compra.indice  = de-indice
                   tt-ordem-compra.un      = prazo-compra.un
                   tt-ordem-compra.qtd-for = tt-ordem-compra.quantidade * tt-ordem-compra.indice.
        END.

        RUN pi-calcula-saldo.

        hQuery:GET-NEXT().
    END.

    hQuery:QUERY-CLOSE().

    DELETE WIDGET hQuery.

    ASSIGN hQuery = ?.

    IF VALID-HANDLE(hAcomp) THEN
        RUN pi-finalizar IN hAcomp.

    IF VALID-HANDLE(hAcomp) THEN
        DELETE PROCEDURE hAcomp.

    ASSIGN hAcomp = ?.

    {&OPEN-QUERY-brOrdemCompra}

    IF CAN-FIND(FIRST tt-ordem-compra) THEN DO:
        brOrdemCompra:SELECT-ROW(1) IN FRAME fPage0.
        brOrdemCompra:SELECT-FOCUSED-ROW() IN FRAME fPage0.
    END.

    APPLY "VALUE-CHANGED":U TO brOrdemCompra IN FRAME fPage0.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGerarPedido wWindow 
PROCEDURE piGerarPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-cod-estabel AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-importado-1 AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-importado-2 AS LOGICAL     NO-UNDO.

    FIND FIRST tt-ordem-compra
        WHERE tt-ordem-compra.l-selecionado = YES NO-LOCK NO-ERROR.

    IF NOT AVAILABLE tt-ordem-compra THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "N∆o foi encontrada ordem selecionada para geraá∆o do pedido.":U).

        RETURN NO-APPLY.
    END.
    ELSE DO:
        IF  tt-ordem-compra.situacao   = 3 /* COTADA */
        AND tt-ordem-compra.preco-unit = 0 THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Ordem Compra com preáo 0 (zero).":U +
                                     "~~":U +
                                     "Ordem Compra: ":U + TRIM(STRING(tt-ordem-compra.numero-ordem, "zzzzz9,99":U)) + 
                                     " com situaá∆o 'Cotada' possui preáo 0 (zero).":U).

            RETURN NO-APPLY.
        END. /* IF  tt-ordem-compra.situacao   = 5 */
    END.

    FIND FIRST tt-ordem-compra
        WHERE tt-ordem-compra.l-selecionado = YES
          AND tt-ordem-compra.situacao     <> 3 NO-LOCK NO-ERROR.

    IF AVAILABLE tt-ordem-compra THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Existem ordens de compra selecionadas para geraá∆o de pedido com situaá∆o diferente de ~"Cotada~"!":U).

        RETURN NO-APPLY.
    END.

    ASSIGN c-cod-estabel = "":U.

    FIND FIRST tt-ordem-compra
        WHERE tt-ordem-compra.l-selecionado = YES NO-ERROR.

    IF AVAILABLE tt-ordem-compra THEN
        ASSIGN c-cod-estabel = tt-ordem-compra.cod-estabel.

    IF CAN-FIND(FIRST tt-ordem-compra
                WHERE tt-ordem-compra.l-selecionado = YES
                  AND tt-ordem-compra.cod-estabel  <> c-cod-estabel) THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Existem ordens de compra selecionadas com estabelecimentos diferentes.":U).

        RETURN NO-APPLY.
    END.

    FIND FIRST tt-ordem-compra
        WHERE tt-ordem-compra.l-selecionado = YES NO-ERROR.

    IF AVAILABLE tt-ordem-compra THEN DO:
        FIND FIRST emitente
            WHERE emitente.cod-emitente = tt-ordem-compra.cod-emitente NO-LOCK NO-ERROR.

        ASSIGN l-importado-1 = IF AVAILABLE emitente AND emitente.natureza > 2 THEN YES ELSE NO.
    END.

    ASSIGN l-importado-2 = l-importado-1.

    FOR EACH tt-ordem-compra
        WHERE tt-ordem-compra.l-selecionado = YES,
        FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = tt-ordem-compra.cod-emitente:
        IF l-importado-1          AND
           emitente.natureza <= 2 THEN
            ASSIGN l-importado-2 = NO.

        IF NOT l-importado-1     AND
           emitente.natureza > 2 THEN
            ASSIGN l-importado-2 = YES.
    END.

    IF l-importado-1 <> l-importado-2 THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Existem ordens de compra selecionadas nacionais e importadas para a geraá∆o de pedido.":U).

        RETURN NO-APPLY.
    END.

    EMPTY TEMP-TABLE tt-ordem-compra-ped.

    FOR EACH tt-ordem-compra NO-LOCK
        WHERE tt-ordem-compra.l-selecionado = YES
          AND tt-ordem-compra.situacao      = 3
          AND tt-ordem-compra.num-pedido    = 0
          AND tt-ordem-compra.cod-cond-pag <> ?
          AND tt-ordem-compra.expectativa   = NO:
        CREATE tt-ordem-compra-ped.
        ASSIGN tt-ordem-compra-ped.numero-ordem = tt-ordem-compra.numero-ordem.
    END.
    
    RUN esp/ccp/esccp031a.w (INPUT THIS-PROCEDURE,
                             INPUT c-seg-usuario,
                             INPUT TABLE tt-ordem-compra-ped).

    FOR EACH tt-ordem-compra
        WHERE tt-ordem-compra.l-selecionado,
        FIRST ordem-compra NO-LOCK
        WHERE ordem-compra.num-pedido  <> 0
          AND ordem-compra.numero-ordem = tt-ordem-compra.numero-ordem:
        DELETE tt-ordem-compra.
    END.

    brOrdemCompra:CLEAR-SORT-ARROWS() IN FRAME fPage0.

    {&OPEN-QUERY-brOrdemCompra}

    IF CAN-FIND(FIRST tt-ordem-compra) THEN DO:
        brOrdemCompra:SELECT-ROW(1) IN FRAME fPage0.
        brOrdemCompra:SELECT-FOCUSED-ROW() IN FRAME fPage0.
    END.

    APPLY "VALUE-CHANGED":U TO brOrdemCompra IN FRAME fPage0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMarcarDesmarcarTodos wWindow 
PROCEDURE piMarcarDesmarcarTodos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF CAN-FIND(FIRST tt-ordem-compra
                WHERE tt-ordem-compra.l-selecionado = NO) THEN DO:
        FOR EACH tt-ordem-compra:
            ASSIGN tt-ordem-compra.l-selecionado = YES.
        END.
    END.
    ELSE DO:
        FOR EACH tt-ordem-compra:
            ASSIGN tt-ordem-compra.l-selecionado = NO.
        END.
    END.

    brOrdemCompra:REFRESH() IN FRAME fPage0 NO-ERROR.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSelecionarAnalisadas wWindow 
PROCEDURE piSelecionarAnalisadas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH tt-ordem-compra
        WHERE tt-ordem-compra.log-analisada = YES:
        ASSIGN tt-ordem-compra.l-selecionado = YES.
    END.

    brOrdemCompra:REFRESH() IN FRAME fPage0 NO-ERROR.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piTrocaFonteColuna wWindow 
PROCEDURE piTrocaFonteColuna :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-num-fonte AS INTEGER     NO-UNDO.

    DEFINE VARIABLE i-coluna AS INTEGER     NO-UNDO.
    DEFINE VARIABLE h-coluna AS HANDLE      NO-UNDO.

    DO i-coluna = 1 TO NUM-ENTRIES(lista-handle-coluna, ",":U):
        ASSIGN h-coluna      = WIDGET-HANDLE(ENTRY(i-coluna, lista-handle-coluna, ",":U))
               h-coluna:FONT = p-num-fonte NO-ERROR.
    END.

    ASSIGN h-coluna = ?.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaDataEntrega wWindow 
PROCEDURE piValidaDataEntrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-numero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.
    DEFINE INPUT  PARAMETER p-data-entrega LIKE prazo-compra.data-entrega NO-UNDO.

    FIND FIRST b-tt-ordem-compra
        WHERE b-tt-ordem-compra.numero-ordem = p-numero-ordem NO-LOCK NO-ERROR.

    IF NOT AVAILABLE b-tt-ordem-compra THEN
        RETURN "NOK":U.

/*     IF b-tt-ordem-compra.situacao <> 3 THEN DO:                                                                      */
/*         RUN utp/ut-msgs.p (INPUT "SHOW":U,                                                                           */
/*                            INPUT 17006,                                                                              */
/*                            INPUT "Para realizar a alteraá∆o, a situaá∆o da ordem de compra deve ser ~"Cotada~".":U). */
/*                                                                                                                      */
/*         RETURN "NOK":U.                                                                                              */
/*     END.                                                                                                             */

    IF p-data-entrega < b-tt-ordem-compra.data-emissao THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 6719,
                           INPUT "":U).

        RETURN "NOK":U.
    END.

    IF CAN-FIND(FIRST prazo-compra
                WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
                  AND prazo-compra.parcela      > 1
                  AND prazo-compra.data-entrega < p-data-entrega) THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 3996,
                           INPUT "":U).
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaQuantidade wWindow 
PROCEDURE piValidaQuantidade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-numero-ordem LIKE ordem-compra.numero-ordem      NO-UNDO.
    DEFINE INPUT  PARAMETER p-quantidade   LIKE prazo-compra.quantidade        NO-UNDO.
    DEFINE INPUT  PARAMETER p-lote-minimo  LIKE item-fornec-estab.lote-minimo  NO-UNDO.
    DEFINE INPUT  PARAMETER p-lote-mul-for LIKE item-fornec-estab.lote-mul-for NO-UNDO.

    DEFINE VARIABLE de-tot-parcela   AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-lote-minimo   AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-lote-multiplo AS DECIMAL     NO-UNDO.

    FIND FIRST b-tt-ordem-compra
        WHERE b-tt-ordem-compra.numero-ordem = p-numero-ordem NO-ERROR.

    IF NOT AVAILABLE b-tt-ordem-compra THEN
        RETURN "NOK":U.

/*     IF b-tt-ordem-compra.situacao <> 3 THEN DO:                                                                      */
/*         RUN utp/ut-msgs.p (INPUT "SHOW":U,                                                                           */
/*                            INPUT 17006,                                                                              */
/*                            INPUT "Para realizar a alteraá∆o, a situaá∆o da ordem de compra deve ser ~"Cotada~".":U). */
/*                                                                                                                      */
/*         RETURN "NOK":U.                                                                                              */
/*     END.                                                                                                             */

    IF p-quantidade = 0 THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 1368,
                           INPUT "":U).

        RETURN "NOK":U.
    END.

    ASSIGN de-tot-parcela = 0.

    FOR EACH prazo-compra FIELD(numero-ordem parcela quantidade situacao) NO-LOCK
        WHERE prazo-compra.numero-ordem = b-tt-ordem-compra.numero-ordem:
        IF prazo-compra.parcela = 1 THEN DO:
            ASSIGN de-tot-parcela = de-tot-parcela + p-quantidade.

            NEXT.
        END.

        IF prazo-compra.situacao = 4 THEN
            NEXT.

        ASSIGN de-tot-parcela = de-tot-parcela + prazo-compra.quantidade.
    END.

    ASSIGN de-lote-minimo   = p-lote-minimo
           de-lote-multiplo = p-lote-mul-for.

/*     ASSIGN de-lote-minimo   = 0                                                                */
/*            de-lote-multiplo = 0.                                                               */
/*                                                                                                */
/*     FIND FIRST item-fornec-estab                                                               */
/*         WHERE item-fornec-estab.it-codigo    = b-tt-ordem-compra.it-codigo                     */
/*           AND item-fornec-estab.cod-emitente = b-tt-ordem-compra.cod-emitente                  */
/*           AND item-fornec-estab.cod-estabel  = b-tt-ordem-compra.cod-estabel NO-LOCK NO-ERROR. */
/*                                                                                                */
/*     IF AVAILABLE item-fornec-estab THEN                                                        */
/*         ASSIGN de-lote-minimo   = item-fornec-estab.lote-minimo                                */
/*                de-lote-multiplo = item-fornec-estab.lote-mul-for.                              */
/*     ELSE DO:                                                                                   */
/*         FIND FIRST item-uni-estab                                                              */
/*             WHERE item-uni-estab.cod-estabel = b-tt-ordem-compra.cod-estabel                   */
/*               AND item-uni-estab.it-codigo   = b-tt-ordem-compra.it-codigo NO-LOCK NO-ERROR.   */
/*                                                                                                */
/*         IF AVAILABLE item-uni-estab THEN                                                       */
/*             ASSIGN de-lote-minimo   = item-uni-estab.lote-minimo                               */
/*                    de-lote-multiplo = item-uni-estab.lote-multipl.                             */
/*     END.                                                                                       */

    IF de-lote-minimo > de-tot-parcela THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 1558,
                           INPUT TRIM(STRING(de-tot-parcela)) + "~~":U + TRIM(STRING(de-lote-minimo))).

        IF RETURN-VALUE = "NO":U THEN
            RETURN "NOK":U.
    END.

    IF de-lote-multiplo                                                <> 0            AND
       ((INTEGER(p-quantidade / de-lote-multiplo)) * de-lote-multiplo) <> p-quantidade THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 6265,
                           INPUT TRIM(STRING(de-lote-multiplo))).

        IF RETURN-VALUE = "NO":U THEN
            RETURN "NOK":U.
    END.

    FIND FIRST item
        WHERE item.it-codigo = b-tt-ordem-compra.it-codigo NO-LOCK NO-ERROR.

    IF AVAILABLE item                             AND
       NOT item.fraciona                          AND
       (p-quantidade - INTEGER(p-quantidade)) > 0 THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 847,
                           INPUT "":U).

        RETURN "NOK":U.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piWindowResize wWindow 
PROCEDURE piWindowResize :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE de-win-dif-width  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-win-dif-height AS DECIMAL     NO-UNDO.

    ASSIGN de-win-dif-width   = wWindow:WIDTH  - de-win-orig-width
           de-win-dif-height  = wWindow:HEIGHT - de-win-orig-height
           de-win-orig-width  = wWindow:WIDTH
           de-win-orig-height = wWindow:HEIGHT.

    IF de-win-dif-width < 0 THEN DO:
        DO WITH FRAME fPage0:
            ASSIGN btQueryJoins:COLUMN                          = btQueryJoins:COLUMN                          +  de-win-dif-width
                   btReportsJoins:COLUMN                        = btReportsJoins:COLUMN                        +  de-win-dif-width
                   btExit:COLUMN                                = btExit:COLUMN                                +  de-win-dif-width
                   btHelp:COLUMN                                = btHelp:COLUMN                                +  de-win-dif-width
                   rtToolBar-2:WIDTH                            = rtToolBar-2:WIDTH                            +  de-win-dif-width
                   rtSituacao:COLUMN                            = rtSituacao:COLUMN                            + (de-win-dif-width / 2)
                   rtDemanda:COLUMN                             = rtDemanda:COLUMN                             + (de-win-dif-width / 2)
                   text-situacao:COLUMN                         = text-situacao:COLUMN                         + (de-win-dif-width / 2)
                   text-demanda:COLUMN                          = text-demanda:COLUMN                          + (de-win-dif-width / 2)
                   tg-nao-confirmada:COLUMN                     = tg-nao-confirmada:COLUMN                     + (de-win-dif-width / 2)
                   tg-cotada:COLUMN                             = tg-cotada:COLUMN                             + (de-win-dif-width / 2)
                   tg-dependente:COLUMN                         = tg-dependente:COLUMN                         + (de-win-dif-width / 2)
                   tg-independente:COLUMN                       = tg-independente:COLUMN                       + (de-win-dif-width / 2)
                   tg-em-cotacao:COLUMN                         = tg-em-cotacao:COLUMN                         + (de-win-dif-width / 2)
                   tg-todas:COLUMN                              = tg-todas:COLUMN                              + (de-win-dif-width / 2)
                   fi-cod-estabel-ini:SIDE-LABEL-HANDLE:COLUMN  = fi-cod-estabel-ini:SIDE-LABEL-HANDLE:COLUMN  + (de-win-dif-width / 2)
                   fi-cod-estabel-ini:COLUMN                    = fi-cod-estabel-ini:COLUMN                    + (de-win-dif-width / 2)
                   IMAGE-1:COLUMN                               = IMAGE-1:COLUMN                               + (de-win-dif-width / 2)
                   IMAGE-2:COLUMN                               = IMAGE-2:COLUMN                               + (de-win-dif-width / 2)
                   fi-cod-estabel-fin:COLUMN                    = fi-cod-estabel-fin:COLUMN                    + (de-win-dif-width / 2)
                   fi-it-codigo-ini:SIDE-LABEL-HANDLE:COLUMN    = fi-it-codigo-ini:SIDE-LABEL-HANDLE:COLUMN    + (de-win-dif-width / 2)
                   fi-it-codigo-ini:COLUMN                      = fi-it-codigo-ini:COLUMN                      + (de-win-dif-width / 2)
                   IMAGE-3:COLUMN                               = IMAGE-3:COLUMN                               + (de-win-dif-width / 2)
                   IMAGE-4:COLUMN                               = IMAGE-4:COLUMN                               + (de-win-dif-width / 2)
                   fi-it-codigo-fin:COLUMN                      = fi-it-codigo-fin:COLUMN                      + (de-win-dif-width / 2)
                   fi-data-emissao-ini:SIDE-LABEL-HANDLE:COLUMN = fi-data-emissao-ini:SIDE-LABEL-HANDLE:COLUMN + (de-win-dif-width / 2)
                   fi-data-emissao-ini:COLUMN                   = fi-data-emissao-ini:COLUMN                   + (de-win-dif-width / 2)
                   IMAGE-5:COLUMN                               = IMAGE-5:COLUMN                               + (de-win-dif-width / 2)
                   IMAGE-6:COLUMN                               = IMAGE-6:COLUMN                               + (de-win-dif-width / 2)
                   fi-data-emissao-fin:COLUMN                   = fi-data-emissao-fin:COLUMN                   + (de-win-dif-width / 2)
                   fi-cod-emitente-ini:SIDE-LABEL-HANDLE:COLUMN = fi-cod-emitente-ini:SIDE-LABEL-HANDLE:COLUMN + (de-win-dif-width / 2)
                   fi-cod-emitente-ini:COLUMN                   = fi-cod-emitente-ini:COLUMN                   + (de-win-dif-width / 2)
                   IMAGE-7:COLUMN                               = IMAGE-7:COLUMN                               + (de-win-dif-width / 2)
                   IMAGE-8:COLUMN                               = IMAGE-8:COLUMN                               + (de-win-dif-width / 2)
                   fi-cod-emitente-fin:COLUMN                   = fi-cod-emitente-fin:COLUMN                   + (de-win-dif-width / 2)
                   cb-cod-comprado:SIDE-LABEL-HANDLE:COLUMN     = cb-cod-comprado:SIDE-LABEL-HANDLE:COLUMN     + (de-win-dif-width / 2)
                   cb-cod-comprado:COLUMN                       = cb-cod-comprado:COLUMN                       + (de-win-dif-width / 2)
                   fi-nom_usuario:COLUMN                        = fi-nom_usuario:COLUMN                        + (de-win-dif-width / 2)
                   btFiltrar:COLUMN                             = btFiltrar:COLUMN                             +  de-win-dif-width
                   rtSel:WIDTH                                  = rtSel:WIDTH                                  +  de-win-dif-width
                   brOrdemCompra:WIDTH                          = brOrdemCompra:WIDTH                          +  de-win-dif-width.
        END.

        ASSIGN FRAME fPage0:WIDTH         = wWindow:WIDTH
               FRAME fPage0:WIDTH-CHARS   = wWindow:WIDTH-CHARS
               FRAME fPage0:VIRTUAL-WIDTH = FRAME fPage0:WIDTH.
    END.
    ELSE DO:
        ASSIGN FRAME fPage0:WIDTH         = wWindow:WIDTH
               FRAME fPage0:WIDTH-CHARS   = wWindow:WIDTH-CHARS
               FRAME fPage0:VIRTUAL-WIDTH = FRAME fPage0:WIDTH.

        DO WITH FRAME fPage0:
            ASSIGN btQueryJoins:COLUMN                          = btQueryJoins:COLUMN                          +  de-win-dif-width
                   btReportsJoins:COLUMN                        = btReportsJoins:COLUMN                        +  de-win-dif-width
                   btExit:COLUMN                                = btExit:COLUMN                                +  de-win-dif-width
                   btHelp:COLUMN                                = btHelp:COLUMN                                +  de-win-dif-width
                   rtToolBar-2:WIDTH                            = rtToolBar-2:WIDTH                            +  de-win-dif-width
                   rtSituacao:COLUMN                            = rtSituacao:COLUMN                            + (de-win-dif-width / 2)
                   rtDemanda:COLUMN                             = rtDemanda:COLUMN                             + (de-win-dif-width / 2)
                   text-situacao:COLUMN                         = text-situacao:COLUMN                         + (de-win-dif-width / 2)
                   text-demanda:COLUMN                          = text-demanda:COLUMN                          + (de-win-dif-width / 2)
                   tg-nao-confirmada:COLUMN                     = tg-nao-confirmada:COLUMN                     + (de-win-dif-width / 2)
                   tg-cotada:COLUMN                             = tg-cotada:COLUMN                             + (de-win-dif-width / 2)
                   tg-dependente:COLUMN                         = tg-dependente:COLUMN                         + (de-win-dif-width / 2)
                   tg-independente:COLUMN                       = tg-independente:COLUMN                       + (de-win-dif-width / 2)
                   tg-em-cotacao:COLUMN                         = tg-em-cotacao:COLUMN                         + (de-win-dif-width / 2)
                   tg-todas:COLUMN                              = tg-todas:COLUMN                              + (de-win-dif-width / 2)
                   fi-cod-estabel-ini:SIDE-LABEL-HANDLE:COLUMN  = fi-cod-estabel-ini:SIDE-LABEL-HANDLE:COLUMN  + (de-win-dif-width / 2)
                   fi-cod-estabel-ini:COLUMN                    = fi-cod-estabel-ini:COLUMN                    + (de-win-dif-width / 2)
                   IMAGE-1:COLUMN                               = IMAGE-1:COLUMN                               + (de-win-dif-width / 2)
                   IMAGE-2:COLUMN                               = IMAGE-2:COLUMN                               + (de-win-dif-width / 2)
                   fi-cod-estabel-fin:COLUMN                    = fi-cod-estabel-fin:COLUMN                    + (de-win-dif-width / 2)
                   fi-it-codigo-ini:SIDE-LABEL-HANDLE:COLUMN    = fi-it-codigo-ini:SIDE-LABEL-HANDLE:COLUMN    + (de-win-dif-width / 2)
                   fi-it-codigo-ini:COLUMN                      = fi-it-codigo-ini:COLUMN                      + (de-win-dif-width / 2)
                   IMAGE-3:COLUMN                               = IMAGE-3:COLUMN                               + (de-win-dif-width / 2)
                   IMAGE-4:COLUMN                               = IMAGE-4:COLUMN                               + (de-win-dif-width / 2)
                   fi-it-codigo-fin:COLUMN                      = fi-it-codigo-fin:COLUMN                      + (de-win-dif-width / 2)
                   fi-data-emissao-ini:SIDE-LABEL-HANDLE:COLUMN = fi-data-emissao-ini:SIDE-LABEL-HANDLE:COLUMN + (de-win-dif-width / 2)
                   fi-data-emissao-ini:COLUMN                   = fi-data-emissao-ini:COLUMN                   + (de-win-dif-width / 2)
                   IMAGE-5:COLUMN                               = IMAGE-5:COLUMN                               + (de-win-dif-width / 2)
                   IMAGE-6:COLUMN                               = IMAGE-6:COLUMN                               + (de-win-dif-width / 2)
                   fi-data-emissao-fin:COLUMN                   = fi-data-emissao-fin:COLUMN                   + (de-win-dif-width / 2)
                   fi-cod-emitente-ini:SIDE-LABEL-HANDLE:COLUMN = fi-cod-emitente-ini:SIDE-LABEL-HANDLE:COLUMN + (de-win-dif-width / 2)
                   fi-cod-emitente-ini:COLUMN                   = fi-cod-emitente-ini:COLUMN                   + (de-win-dif-width / 2)
                   IMAGE-7:COLUMN                               = IMAGE-7:COLUMN                               + (de-win-dif-width / 2)
                   IMAGE-8:COLUMN                               = IMAGE-8:COLUMN                               + (de-win-dif-width / 2)
                   fi-cod-emitente-fin:COLUMN                   = fi-cod-emitente-fin:COLUMN                   + (de-win-dif-width / 2)
                   cb-cod-comprado:SIDE-LABEL-HANDLE:COLUMN     = cb-cod-comprado:SIDE-LABEL-HANDLE:COLUMN     + (de-win-dif-width / 2)
                   cb-cod-comprado:COLUMN                       = cb-cod-comprado:COLUMN                       + (de-win-dif-width / 2)
                   fi-nom_usuario:COLUMN                        = fi-nom_usuario:COLUMN                        + (de-win-dif-width / 2)
                   btFiltrar:COLUMN                             = btFiltrar:COLUMN                             +  de-win-dif-width
                   rtSel:WIDTH                                  = rtSel:WIDTH                                  +  de-win-dif-width
                   brOrdemCompra:WIDTH                          = brOrdemCompra:WIDTH                          +  de-win-dif-width.
        END.
    END.

    IF de-win-dif-height < 0 THEN DO:
        DO WITH FRAME fPage0:
            ASSIGN brOrdemCompra:HEIGHT  = brOrdemCompra:HEIGHT  + de-win-dif-height
                   btMarcarDesmarcar:ROW = btMarcarDesmarcar:ROW + de-win-dif-height
                   btAtualizar:ROW       = btAtualizar:ROW       + de-win-dif-height
                   btDesfazer:ROW        = btDesfazer:ROW        + de-win-dif-height
                   btEliminar:ROW        = btEliminar:ROW        + de-win-dif-height
                   btAprovar:ROW         = btAprovar:ROW         + de-win-dif-height
                   btSelAnalisada:ROW    = btSelAnalisada:ROW    + de-win-dif-height
                   btGerarPedido:ROW     = btGerarPedido:ROW     + de-win-dif-height
                   btGeraParc:ROW        = btGeraParc:ROW        + de-win-dif-height.
        END.

        ASSIGN FRAME fPage0:HEIGHT         = wWindow:HEIGHT
               FRAME fPage0:HEIGHT-CHARS   = wWindow:HEIGHT-CHARS
               FRAME fPage0:VIRTUAL-HEIGHT = FRAME fPage0:HEIGHT.
    END.
    ELSE DO:
        ASSIGN FRAME fPage0:HEIGHT         = wWindow:HEIGHT
               FRAME fPage0:HEIGHT-CHARS   = wWindow:HEIGHT-CHARS
               FRAME fPage0:VIRTUAL-HEIGHT = FRAME fPage0:HEIGHT.

        DO WITH FRAME fPage0:
            ASSIGN brOrdemCompra:HEIGHT  = brOrdemCompra:HEIGHT  + de-win-dif-height
                   btMarcarDesmarcar:ROW = btMarcarDesmarcar:ROW + de-win-dif-height
                   btAtualizar:ROW       = btAtualizar:ROW       + de-win-dif-height
                   btDesfazer:ROW        = btDesfazer:ROW        + de-win-dif-height
                   btEliminar:ROW        = btEliminar:ROW        + de-win-dif-height
                   btAprovar:ROW         = btAprovar:ROW         + de-win-dif-height
                   btSelAnalisada:ROW    = btSelAnalisada:ROW    + de-win-dif-height
                   btGerarPedido:ROW     = btGerarPedido:ROW     + de-win-dif-height
                   btGeraParc:ROW        = btGeraParc:ROW        + de-win-dif-height.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnParcelas wWindow 
FUNCTION fnParcelas RETURNS INTEGER
  ( p-numero-ordem AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/


  ASSIGN i = 0.
  FOR EACH prazo-compra NO-LOCK
     WHERE prazo-compra.numero-ordem = p-numero-ordem:
      ASSIGN i = i + 1.
  END.

  RETURN i.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

