&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttcat NO-UNDO LIKE mgesp.cat
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttcat-item NO-UNDO LIKE cat-item
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esftp044 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          esftp044
&GLOBAL-DEFINE Version          2.00.00.000

&GLOBAL-DEFINE Folder           no
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     CAT

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE AddParent        YES
&GLOBAL-DEFINE CopyParent       YES
&GLOBAL-DEFINE UpdateParent     YES
&GLOBAL-DEFINE SaveParent       YES
&GLOBAL-DEFINE DeleteParent     YES

&GLOBAL-DEFINE AddSon1          YES
&GLOBAL-DEFINE CopySon1         YES
&GLOBAL-DEFINE UpdateSon1       YES
&GLOBAL-DEFINE DeleteSon1       YES
/*
&GLOBAL-DEFINE AddSon2          YES
&GLOBAL-DEFINE CopySon2         YES
&GLOBAL-DEFINE UpdateSon2       YES
&GLOBAL-DEFINE DeleteSon2       YES
*/
&GLOBAL-DEFINE ttParent         ttcat
&GLOBAL-DEFINE hDBOParent       h-boes400
&GLOBAL-DEFINE DBOParentTable   cat
&GLOBAL-DEFINE DBOParentDestroy yes

&GLOBAL-DEFINE ttSon1           ttcat-item
&GLOBAL-DEFINE hDBOSon1         h-boes401
&GLOBAL-DEFINE DBOSon1Table     cat-item
&GLOBAL-DEFINE DBOSon1Destroy   yes
/*
&GLOBAL-DEFINE ttSon2           <Temp-Table Name>
&GLOBAL-DEFINE hDBOSon2         <Handle DBO Variable Name>
&GLOBAL-DEFINE DBOSon2Table     <DBOSon2 Table Name>
&GLOBAL-DEFINE DBOSon2Destroy   <DBOSon2 Destroy Flag>
*/
&GLOBAL-DEFINE page0Fields      ttcat.nr-cat ttcat.sequencia ttcat.cod-emitente ttcat.dt-cat ttcat.dt-validade ~
                                ttcat.cod-emitente ttcat.cod-transp ttcat.nro-docto dt-dt-entrada ttcat.cod-cond-pagto c-desc-cond-pagto ~
                                c-desc-transp c-nome-emitente c-endereco-cliente c-cidade c-cep ~
                                ttcat.observacao ttcat.vl-cat ttcat.vl-desconto ttcat.vl-acrescimo ttcat.vl-mao-obra ~
                                ttcat.vl-a-pagar ttcat.consertado-por ttcat.dt-conserto ttcat.testado-por ~
                                ttcat.dt-teste ttcat.defeito-reclamado ttcat.defeito-constatado ttcat.solucao c-situacao ~
                                ttcat.nr-pedcli-retorno ttcat.nr-pedcli-venda ttcat.nr-pedcli-revenda ttcat.dt-encerramento

&GLOBAL-DEFINE page1Browse       brSon1  
/*    
&GLOBAL-DEFINE page2Browse      
*/
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa     AS HANDLE       NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl  AS HANDLE       NO-UNDO.
DEF BUFFER b-cat FOR mgesp.cat.
/*
DEFINE VARIABLE {&hDBOSon2}   AS HANDLE NO-UNDO.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MasterDetail
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSon1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttcat-item item

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 ttcat-item.ind-tipo-faturamento ~
ttcat-item.it-codigo item.desc-item ttcat-item.tabela-mo ~
ttcat-item.quantidade ttcat-item.vl-unitario ttcat-item.perc-desconto ~
ttcat-item.vl-tot-item 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH ttcat-item NO-LOCK, ~
      EACH item OF ttcat-item NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH ttcat-item NO-LOCK, ~
      EACH item OF ttcat-item NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 ttcat-item item
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 ttcat-item
&Scoped-define SECOND-TABLE-IN-QUERY-brSon1 item


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttcat.nr-cat ttcat.sequencia ttcat.dt-cat ~
ttcat.dt-validade ttcat.cod-emitente ttcat.cod-cond-pagto ttcat.cod-transp ~
ttcat.nro-docto ttcat.nr-pedcli-retorno ttcat.nr-pedcli-venda ~
ttcat.nr-pedcli-revenda ttcat.dt-encerramento ttcat.observacao ttcat.vl-cat ~
ttcat.vl-desconto ttcat.vl-acrescimo ttcat.consertado-por ttcat.dt-conserto ~
ttcat.vl-mao-obra ttcat.testado-por ttcat.dt-teste ttcat.vl-a-pagar ~
ttcat.defeito-reclamado ttcat.defeito-constatado ttcat.solucao 
&Scoped-define ENABLED-TABLES ttcat
&Scoped-define FIRST-ENABLED-TABLE ttcat
&Scoped-Define ENABLED-OBJECTS rtToolBar rtParent RECT-1 btFirst btPrev ~
btNext btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btCancel ~
btSave bt-rel3 bt-rel2 btQueryJoins btReportsJoins btExit btHelp ~
bt-confirmacao c-nome-emitente c-desc-cond-pagto c-desc-transp ~
dt-dt-entrada c-endereco-cliente c-cidade c-cep 
&Scoped-Define DISPLAYED-FIELDS ttcat.nr-cat ttcat.sequencia ttcat.dt-cat ~
ttcat.dt-validade ttcat.cod-emitente ttcat.cod-cond-pagto ttcat.cod-transp ~
ttcat.nro-docto ttcat.nr-pedcli-retorno ttcat.nr-pedcli-venda ~
ttcat.nr-pedcli-revenda ttcat.dt-encerramento ttcat.observacao ttcat.vl-cat ~
ttcat.vl-desconto ttcat.vl-acrescimo ttcat.consertado-por ttcat.dt-conserto ~
ttcat.vl-mao-obra ttcat.testado-por ttcat.dt-teste ttcat.vl-a-pagar ~
ttcat.defeito-reclamado ttcat.defeito-constatado ttcat.solucao 
&Scoped-define DISPLAYED-TABLES ttcat
&Scoped-define FIRST-DISPLAYED-TABLE ttcat
&Scoped-Define DISPLAYED-OBJECTS c-situacao c-nome-emitente ~
c-desc-cond-pagto c-desc-transp dt-dt-entrada c-endereco-cliente c-cidade ~
c-cep 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMasterDetail AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&Èltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V† Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM miCopy         LABEL "&Copiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
       RULE
       MENU-ITEM miSave         LABEL "Salvar"         ACCELERATOR "CTRL-S"
       MENU-ITEM miCancel       LABEL "Cancelar"       ACCELERATOR "CTRL-F4"
       RULE
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
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
DEFINE BUTTON bt-confirmacao 
     IMAGE-UP FILE "adeicon/ard.bmp":U
     LABEL "Button 1" 
     SIZE 4 BY 1.13 TOOLTIP "Realizar CAT - Gerar Pedidos de Venda".

DEFINE BUTTON bt-rel2 
     IMAGE-UP FILE "image/ii-pri.bmp":U
     LABEL "Button 1" 
     SIZE 4 BY 1.25 TOOLTIP "Indice de Atraso em Manutená∆o".

DEFINE BUTTON bt-rel3 
     IMAGE-UP FILE "image/ii-pri.bmp":U
     LABEL "Button 1" 
     SIZE 4 BY 1.25 TOOLTIP "Pesquisa CAT".

DEFINE BUTTON btAdd 
     IMAGE-UP FILE "image\im-add":U
     IMAGE-INSENSITIVE FILE "image\ii-add":U
     LABEL "Add" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCancel 
     IMAGE-UP FILE "image\im-can":U
     IMAGE-INSENSITIVE FILE "image\ii-can":U
     LABEL "Cancel" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCopy 
     IMAGE-UP FILE "image\im-copy":U
     IMAGE-INSENSITIVE FILE "image\ii-copy":U
     LABEL "Copy" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btDelete 
     IMAGE-UP FILE "image\im-era":U
     IMAGE-INSENSITIVE FILE "image\ii-era":U
     LABEL "Delete" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image\im-fir":U
     IMAGE-INSENSITIVE FILE "image\ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image\im-las":U
     IMAGE-INSENSITIVE FILE "image\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image\im-nex":U
     IMAGE-INSENSITIVE FILE "image\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image\im-pre":U
     IMAGE-INSENSITIVE FILE "image\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

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
     SIZE 4 BY 1.25 TOOLTIP "Impress∆o do CAT"
     FONT 4.

DEFINE BUTTON btSave 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image\im-mod":U
     IMAGE-INSENSITIVE FILE "image\ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE c-cep AS CHARACTER FORMAT "X(256)":U 
     LABEL "CEP" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .79 NO-UNDO.

DEFINE VARIABLE c-cidade AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cidade:" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .79 NO-UNDO.

DEFINE VARIABLE c-desc-cond-pagto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 21 BY .79 NO-UNDO.

DEFINE VARIABLE c-desc-transp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .79 NO-UNDO.

DEFINE VARIABLE c-endereco-cliente AS CHARACTER FORMAT "X(256)":U 
     LABEL "Endereáo Cliente:" 
     VIEW-AS FILL-IN 
     SIZE 48 BY .79 NO-UNDO.

DEFINE VARIABLE c-nome-emitente AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .79 NO-UNDO.

DEFINE VARIABLE c-situacao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .79
     FGCOLOR 12  NO-UNDO.

DEFINE VARIABLE dt-dt-entrada AS CHARACTER FORMAT "X(256)":U 
     LABEL "Data NF.Entrada" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .79 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 108 BY 8.25.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 109 BY 5.33.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 109 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btAddSon1 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btCopySon1 
     LABEL "Copiar" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon1 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon1 
     LABEL "Alterar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      ttcat-item, 
      item SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 NO-LOCK DISPLAY
      ttcat-item.ind-tipo-faturamento COLUMN-LABEL "T" FORMAT "9":U
            WIDTH 2.43
      ttcat-item.it-codigo COLUMN-LABEL "Item" FORMAT "x(10)":U
            WIDTH 9.43
      item.desc-item FORMAT "x(60)":U WIDTH 36.43
      ttcat-item.tabela-mo COLUMN-LABEL "Tb M.Obra" FORMAT "x(8)":U
            WIDTH 9.43
      ttcat-item.quantidade COLUMN-LABEL "Quantid" FORMAT "->>>>>,>>9.99":U
            WIDTH 8.43
      ttcat-item.vl-unitario COLUMN-LABEL "Vlr.Unit." FORMAT "->>>>,>>9.99":U
            WIDTH 9.86
      ttcat-item.perc-desconto COLUMN-LABEL "Desc." FORMAT ">>9.99":U
            WIDTH 8
      ttcat-item.vl-tot-item FORMAT "->>>>>,>>9.99":U WIDTH 14.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 105 BY 4.75
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrància"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrància anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrància"
     btLast AT ROW 1.13 COL 13.57 HELP
          "Èltima ocorrància"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V† Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btAdd AT ROW 1.13 COL 31 HELP
          "Inclui nova ocorrància"
     btCopy AT ROW 1.13 COL 35 HELP
          "Cria uma c¢pia da ocorrància corrente"
     btUpdate AT ROW 1.13 COL 39 HELP
          "Altera ocorrància corrente"
     btDelete AT ROW 1.13 COL 43 HELP
          "Elimina ocorrància corrente"
     btCancel AT ROW 1.13 COL 47 HELP
          "Cancela alteraá‰es" WIDGET-ID 74
     btSave AT ROW 1.13 COL 51 HELP
          "Confirma alteraá‰es" WIDGET-ID 72
     bt-rel3 AT ROW 1.13 COL 85 WIDGET-ID 94
     bt-rel2 AT ROW 1.13 COL 89 WIDGET-ID 92
     btQueryJoins AT ROW 1.13 COL 92.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 96.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 100.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 104.86 HELP
          "Ajuda"
     bt-confirmacao AT ROW 1.25 COL 63 HELP
          "Realizar CAT" WIDGET-ID 78
     ttcat.nr-cat AT ROW 3 COL 14 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .79
     ttcat.sequencia AT ROW 3 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 68
          VIEW-AS FILL-IN 
          SIZE 4 BY .79
     ttcat.dt-cat AT ROW 3 COL 51 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 11 BY .79
     ttcat.dt-validade AT ROW 3 COL 79 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 11 BY .79
     c-situacao AT ROW 3 COL 92 COLON-ALIGNED NO-LABEL WIDGET-ID 80
     ttcat.cod-emitente AT ROW 4 COL 14 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .79
     c-nome-emitente AT ROW 4 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     ttcat.cod-cond-pagto AT ROW 4 COL 79 COLON-ALIGNED NO-LABEL WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 5 BY .79
     c-desc-cond-pagto AT ROW 4 COL 85 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     ttcat.cod-transp AT ROW 5 COL 14 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .79
     c-desc-transp AT ROW 5 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 76
     ttcat.nro-docto AT ROW 5 COL 69 COLON-ALIGNED NO-LABEL WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .79
     dt-dt-entrada AT ROW 5 COL 93 COLON-ALIGNED WIDGET-ID 22
     c-endereco-cliente AT ROW 6 COL 14 COLON-ALIGNED WIDGET-ID 26
     c-cidade AT ROW 6 COL 69 COLON-ALIGNED WIDGET-ID 28
     c-cep AT ROW 6 COL 93 COLON-ALIGNED WIDGET-ID 30
     ttcat.nr-pedcli-retorno AT ROW 7 COL 14 COLON-ALIGNED WIDGET-ID 82
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .79
     ttcat.nr-pedcli-venda AT ROW 7 COL 41 COLON-ALIGNED WIDGET-ID 86
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .79
     ttcat.nr-pedcli-revenda AT ROW 7 COL 69 COLON-ALIGNED WIDGET-ID 84
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .79
     ttcat.dt-encerramento AT ROW 7 COL 93 COLON-ALIGNED WIDGET-ID 90
          VIEW-AS FILL-IN 
          SIZE 12 BY .79
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 110.14 BY 24.58
         FONT 1 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fPage0
     ttcat.observacao AT ROW 15 COL 3 NO-LABEL WIDGET-ID 88
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 70 BY 2.5
     ttcat.vl-cat AT ROW 15 COL 91 COLON-ALIGNED WIDGET-ID 38
          VIEW-AS FILL-IN 
          SIZE 14 BY .79
     ttcat.vl-desconto AT ROW 16 COL 91 COLON-ALIGNED WIDGET-ID 40
          VIEW-AS FILL-IN 
          SIZE 14 BY .79
     ttcat.vl-acrescimo AT ROW 17 COL 91 COLON-ALIGNED WIDGET-ID 42
          VIEW-AS FILL-IN 
          SIZE 14 BY .79
     ttcat.consertado-por AT ROW 18 COL 14 COLON-ALIGNED NO-LABEL WIDGET-ID 48
          VIEW-AS FILL-IN 
          SIZE 18 BY .79
     ttcat.dt-conserto AT ROW 18 COL 50 COLON-ALIGNED WIDGET-ID 52
          VIEW-AS FILL-IN 
          SIZE 13 BY .79
     ttcat.vl-mao-obra AT ROW 18 COL 91 COLON-ALIGNED WIDGET-ID 44
          VIEW-AS FILL-IN 
          SIZE 14 BY .79
     ttcat.testado-por AT ROW 19 COL 14 COLON-ALIGNED NO-LABEL WIDGET-ID 54
          VIEW-AS FILL-IN 
          SIZE 18 BY .79
     ttcat.dt-teste AT ROW 19 COL 50 COLON-ALIGNED WIDGET-ID 58
          VIEW-AS FILL-IN 
          SIZE 13 BY .79
     ttcat.vl-a-pagar AT ROW 19 COL 91 COLON-ALIGNED WIDGET-ID 46
          VIEW-AS FILL-IN 
          SIZE 14 BY .79
     ttcat.defeito-reclamado AT ROW 20 COL 16 NO-LABEL WIDGET-ID 60
          VIEW-AS FILL-IN 
          SIZE 91 BY .79
     ttcat.defeito-constatado AT ROW 21 COL 14 COLON-ALIGNED WIDGET-ID 64
          VIEW-AS FILL-IN 
          SIZE 91 BY .79
     ttcat.solucao AT ROW 24.25 COL 14 COLON-ALIGNED NO-LABEL WIDGET-ID 66
          VIEW-AS FILL-IN 
          SIZE 91 BY .79
     "Nf.Entrada:" VIEW-AS TEXT
          SIZE 8 BY .75 AT ROW 5 COL 63 WIDGET-ID 20
     "Cond.Pagto.:" VIEW-AS TEXT
          SIZE 9 BY 1 AT ROW 4 COL 71 WIDGET-ID 14
     "Consertado por:" VIEW-AS TEXT
          SIZE 11 BY .75 AT ROW 18 COL 5 WIDGET-ID 50
     "Testado por:" VIEW-AS TEXT
          SIZE 9 BY .75 AT ROW 19 COL 7 WIDGET-ID 56
     "Soluá∆o:" VIEW-AS TEXT
          SIZE 6 BY .75 AT ROW 24.25 COL 9 WIDGET-ID 70
     "Def.Reclamado:" VIEW-AS TEXT
          SIZE 11 BY .54 AT ROW 20 COL 5 WIDGET-ID 62
     rtToolBar AT ROW 1 COL 1
     rtParent AT ROW 2.67 COL 1
     RECT-1 AT ROW 14.75 COL 2 WIDGET-ID 34
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 110.14 BY 24.58
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.25 COL 2
     btAddSon1 AT ROW 6.25 COL 2
     btCopySon1 AT ROW 6.25 COL 12
     btUpdateSon1 AT ROW 6.25 COL 22
     btDeleteSon1 AT ROW 6.25 COL 32
     "T=Tipo - 1 = Retorno, 2 = Venda, 3 = Revenda" VIEW-AS TEXT
          SIZE 51 BY .75 AT ROW 6.25 COL 46 WIDGET-ID 2
          FGCOLOR 3 
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.57 ROW 8.25
         SIZE 107.43 BY 6.5
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttcat T "?" NO-UNDO mgesp cat
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttcat-item T "?" NO-UNDO mgesp cat-item
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMasterDetail ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 21.42
         WIDTH              = 109.57
         MAX-HEIGHT         = 26.17
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 26.17
         VIRTUAL-WIDTH      = 114.29
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMasterDetail 
/* ************************* Included-Libraries *********************** */

{masterdetail/masterdetail.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMasterDetail
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN c-situacao IN FRAME fPage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ttcat.defeito-reclamado IN FRAME fPage0
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 TEXT-7 fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _TblList          = "Temp-Tables.ttcat-item,mgcad.item OF Temp-Tables.ttcat-item"
     _Options          = "NO-LOCK"
     _JoinCode[2]      = "Temp-Tables.ttcat-item.cod-estabel = Temp-Tables.ttcat.cod-estabel
  AND Temp-Tables.ttcat-item.nr-cat = Temp-Tables.ttcat.nr-cat
  AND Temp-Tables.ttcat-item.sequencia = Temp-Tables.ttcat.sequencia"
     _FldNameList[1]   > Temp-Tables.ttcat-item.ind-tipo-faturamento
"ttcat-item.ind-tipo-faturamento" "T" ? "integer" ? ? ? ? ? ? no ? no no "2.43" yes no no "U" "" ""
     _FldNameList[2]   > Temp-Tables.ttcat-item.it-codigo
"ttcat-item.it-codigo" "Item" "x(10)" "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" ""
     _FldNameList[3]   > mgcad.item.desc-item
"item.desc-item" ? ? "character" ? ? ? ? ? ? no ? no no "36.43" yes no no "U" "" ""
     _FldNameList[4]   > Temp-Tables.ttcat-item.tabela-mo
"ttcat-item.tabela-mo" "Tb M.Obra" ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" ""
     _FldNameList[5]   > Temp-Tables.ttcat-item.quantidade
"ttcat-item.quantidade" "Quantid" ? "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" ""
     _FldNameList[6]   > Temp-Tables.ttcat-item.vl-unitario
"ttcat-item.vl-unitario" "Vlr.Unit." ? "decimal" ? ? ? ? ? ? no ? no no "9.86" yes no no "U" "" ""
     _FldNameList[7]   > Temp-Tables.ttcat-item.perc-desconto
"ttcat-item.perc-desconto" "Desc." ? "decimal" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" ""
     _FldNameList[8]   > Temp-Tables.ttcat-item.vl-tot-item
"ttcat-item.vl-tot-item" ? ? "decimal" ? ? ? ? ? ? no ? no no "14.57" yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMasterDetail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON END-ERROR OF wMasterDetail
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON WINDOW-CLOSE OF wMasterDetail
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-confirmacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-confirmacao wMasterDetail
ON CHOOSE OF bt-confirmacao IN FRAME fPage0 /* Button 1 */
DO:
   def var c-pedido as char.
   if ttcat.ind-situacao = 2 then
        message "Encerramento do CAT n∆o permitida, CAT ja realizado" view-as alert-box.
   else do:
        RUN utp/ut-msgs.p (INPUT "show":U, 
                         INPUT 27100, 
                         INPUT "Confirma Encerramento do CAT":U + "~~" +
                               "Confirma Encerramento do CAT e geraá∆o dos Pedidos de Venda?":U).
        if  RETURN-VALUE = "yes" then do:
    
    
            run pi-cria-pedidos in {&hDBOParent} (input ttcat.cod-estabel,
                                                  input ttcat.nr-cat,
                                                  input ttcat.sequencia,
                                                  output c-pedido,
                                                  output table rowerrors).
            if c-pedido <> "" then                                      
               message "Numero de Pedidos Criados: " c-pedido view-as alert-box.                                                  
            if can-find (first rowerrors) then do:
               for each rowerrors:
                    if rowerrors.errornumber = 0 then
                        RUN utp/ut-msgs.p (INPUT "show":U, 
                                           INPUT 17567, 
                                           INPUT rowerrors.errordescription ).
                    else
                        RUN utp/ut-msgs.p (INPUT "show":U, 
                                           INPUT rowerrors.errornumber, 
                                           INPUT rowerrors.errordescription + "~~" + rowerrors.errorhelp)).
                    
                   
                   delete rowerrors.
               end.
               undo, return.
            end.
            RUN goToRecord2       in this-procedure (INPUT ttcat.cod-estabel, input ttcat.nr-cat, input ttcat.sequencia). 

        end.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-rel2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-rel2 wMasterDetail
ON CHOOSE OF bt-rel2 IN FRAME fPage0 /* Button 1 */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN esp/ftp/esftp044d.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-rel3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-rel3 wMasterDetail
ON CHOOSE OF bt-rel3 IN FRAME fPage0 /* Button 1 */
DO:
   RUN esp/ftp/esftp044e.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMasterDetail
ON CHOOSE OF btAdd IN FRAME fPage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd IN MENU mbMain DO:

    RUN addRecord IN THIS-PROCEDURE (INPUT "esp/ftp/esftp044a.w":U). 
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btAddSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon1 wMasterDetail
ON CHOOSE OF btAddSon1 IN FRAME fPage1 /* Incluir */
DO:
    {masterdetail/addson.i &ProgramSon="esp/ftp/esftp044b.w" &PageNumber="1"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMasterDetail
ON CHOOSE OF btCancel IN FRAME fPage0 /* Cancel */
OR  CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:
    RUN EnableDisableFields(no).

    if  avail ttcat then
        run goToRecord2 in this-procedure (input ttcat.cod-estabel, input ttcat.nr-cat, input ttcat.sequencia).



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMasterDetail
ON CHOOSE OF btCopy IN FRAME fPage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    DEF VAR i-ultimo-seq AS INTEGER.

    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.

      MESSAGE "Confirma Copia de Cat?" 
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
                    TITLE "" UPDATE choice AS LOGICAL.
      CASE choice:
         WHEN TRUE THEN /* Yes */
          DO:
                FOR EACH b-cat
                    WHERE b-cat.nr-cat = ttcat.nr-cat
                    BY b-cat.sequencia:
                    ASSIGN i-ultimo-seq = b-cat.sequencia.
                END.
                 
            
                 CREATE b-cat.
                 BUFFER-COPY ttcat EXCEPT sequencia TO b-cat.
                 ASSIGN b-cat.sequencia = i-ultimo-seq + 1.
            
                RUN goToKey IN {&hDBOParent} (input "103", INPUT ttcat.nr-cat, INPUT b-cat.sequencia).
                IF RETURN-VALUE = "NOK":U THEN DO:
                    RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "<TableName>":U).
                    
                    RETURN NO-APPLY.
                END.
                
                /*:T Retorna rowid do registro corrente do DBO */
                RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
                
                /*:T Reposiciona registro com base em um rowid */
                RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
         END.
      END.
    


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btCopySon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopySon1 wMasterDetail
ON CHOOSE OF btCopySon1 IN FRAME fPage1 /* Copiar */
DO:
    {masterdetail/copyson.i &ProgramSon="esp/ftp/esftp044b.w"
                            &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMasterDetail
ON CHOOSE OF btDelete IN FRAME fPage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    def var c-cod-estabel as char.
    def var i-nr-cat as integer.
    def var i-sequencia as integer.
    assign c-cod-estabel = ttcat.cod-estabel
           i-nr-cat      = ttcat.nr-cat
           i-sequencia   = ttcat.sequencia.
    if ttcat.ind-situacao = 1 then do:
        RUN deleteRecord IN THIS-PROCEDURE.
        for each cat-item
            where cat-item.cod-estabel = c-cod-estabel
              and cat-item.nr-cat      = i-nr-cat
              and cat-item.sequencia   = i-sequencia
              exclusive-lock:
            delete cat-item.
        end.
    end.
    else
        message "Eliminacao nao permitida, CAT ja realizado" view-as alert-box.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btDeleteSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon1 wMasterDetail
ON CHOOSE OF btDeleteSon1 IN FRAME fPage1 /* Eliminar */
DO:
    {masterdetail/DeleteSon.i &PageNumber="1"}
   find mgesp.cat where cat.cod-estabel  = ttcat.cod-estabel
               and cat.nr-cat      = ttcat.nr-cat
               and cat.sequencia   = ttcat.sequencia
               exclusive-lock no-error.
    if avail cat then  do:        
       assign cat.vl-cat      = 0
              cat.vl-a-pagar  = 0
              cat.vl-desconto = 0.
    
       for each cat-item 
           where cat-item.cod-estabel = cat.cod-estabel
             and cat-item.nr-cat      = cat.nr-cat
             and cat-item.sequencia   = cat.sequencia exclusive-lock:   
           assign cat.vl-cat          = cat.vl-cat + cat-item.quantidade * cat-item.vl-unitario
                  cat.vl-desconto     = cat.vl-desconto + (cat-item.quantidade * cat-item.vl-unitario - cat-item.vl-tot-item).
.


       end.
       assign cat.vl-a-pagar  = cat.vl-cat - cat.vl-desconto +
                                             cat.vl-acrescimo + 
                                             cat.vl-mao-obra.
    RUN goToRecord2       in this-procedure (INPUT ttcat.cod-estabel, input ttcat.nr-cat, input ttcat.sequencia). 
       
   end.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMasterDetail
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMasterDetail
ON CHOOSE OF btFirst IN FRAME fPage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMasterDetail
ON CHOOSE OF btGoTo IN FRAME fPage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMasterDetail
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMasterDetail
ON CHOOSE OF btLast IN FRAME fPage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMasterDetail
ON CHOOSE OF btNext IN FRAME fPage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMasterDetail
ON CHOOSE OF btPrev IN FRAME fPage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMasterDetail
ON CHOOSE OF btQueryJoins IN FRAME fPage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMasterDetail
ON CHOOSE OF btReportsJoins IN FRAME fPage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN esp/ftp/esftp044c.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMasterDetail
ON CHOOSE OF btSave IN FRAME fPage0 /* Save */
RUN pi-choose-bt-save.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMasterDetail
ON CHOOSE OF btSearch IN FRAME fPage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
  {method/zoomreposition.i &ProgramZoom="eszoom/z01es400.w"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMasterDetail
ON CHOOSE OF btUpdate IN FRAME fPage0 /* Update */
/* OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO: */
/*     RUN updateRecord IN THIS-PROCEDURE (INPUT "esp/ftp/esftp044b.w":U). */
/* END. */

OR  CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    if  avail ttcat  and ttcat.ind-situacao = 1 then
        RUN EnableDisableFields(yes).
    else
        message "Alteraá∆o n∆o permitida, CAT ja realizado" view-as alert-box.
 /*        run setFolder in hFolder(input 1). */
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btUpdateSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon1 wMasterDetail
ON CHOOSE OF btUpdateSon1 IN FRAME fPage1 /* Alterar */
DO:
    {masterdetail/updateson.i &ProgramSon="esp/ftp/esftp044b.w"
                              &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME ttcat.cod-cond-pagto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcat.cod-cond-pagto wMasterDetail
ON F5 OF ttcat.cod-cond-pagto IN FRAME fPage0 /* cod-cond-pagto */
DO:
      {include/zoomvar.i &prog-zoom=adzoom/z01ad039.w
                       &campo=ttcat.cod-cond-pag
                       &campozoom=cod-cond-pag
                       &frame=fpage0}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcat.cod-cond-pagto wMasterDetail
ON LEAVE OF ttcat.cod-cond-pagto IN FRAME fPage0 /* cod-cond-pagto */
DO:
      find cond-pagto 
         where cond-pagto.cod-cond-pag = input frame fPage0 ttcat.cod-cond-pag
         no-lock no-error.
    if avail cond-pagto then
       assign c-desc-cond-pagto:screen-value    = cond-pagto.descricao.
    else
       assign c-desc-cond-pagto:screen-value    = "N∆o Encontrado".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcat.cod-cond-pagto wMasterDetail
ON MOUSE-SELECT-DBLCLICK OF ttcat.cod-cond-pagto IN FRAME fPage0 /* cod-cond-pagto */
DO:
  APPLY "F5" TO SELF.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttcat.cod-transp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcat.cod-transp wMasterDetail
ON F5 OF ttcat.cod-transp IN FRAME fPage0 /* Cod.Transportadora */
DO:
        {method/ZoomFields.i &ProgramZoom="adzoom/z02ad268.w"
                             &FieldZoom1="cod-transp"
                             &FieldScreen1="ttcat.cod-transp"
                             &Frame1="fPage0"
                             &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcat.cod-transp wMasterDetail
ON LEAVE OF ttcat.cod-transp IN FRAME fPage0 /* Cod.Transportadora */
DO:
      find transporte
         where transporte.cod-transp = input frame fPage0 ttcat.cod-transp
         no-lock no-error.

    if avail transporte then
       assign c-desc-transp:screen-value    = transporte.nome.           
    else
       assign c-desc-transp:screen-value    = "N∆o Encontrado".   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcat.cod-transp wMasterDetail
ON MOUSE-SELECT-DBLCLICK OF ttcat.cod-transp IN FRAME fPage0 /* Cod.Transportadora */
DO:
  APPLY "F5" TO SELF.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttcat.vl-acrescimo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcat.vl-acrescimo wMasterDetail
ON LEAVE OF ttcat.vl-acrescimo IN FRAME fPage0 /* Valor Acrescimo do CAT */
DO:
  assign ttcat.vl-a-pagar:screen-value  = string(ttcat.vl-cat - ttcat.vl-desconto +
                                          input frame fPage0 ttcat.vl-acrescimo + 
                                          input frame fPage0 ttcat.vl-mao-obra).
                                          
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttcat.vl-mao-obra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttcat.vl-mao-obra wMasterDetail
ON LEAVE OF ttcat.vl-mao-obra IN FRAME fPage0 /* Valor da M∆o de Obra */
DO:
  assign ttcat.vl-a-pagar:screen-value  = string(ttcat.vl-cat - ttcat.vl-desconto +
                                          input frame fPage0 ttcat.vl-acrescimo + 
                                          input frame fPage0 ttcat.vl-mao-obra).
                                          
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
            
{masterdetail/mainblock.i}
 ttcat.cod-cond-pag:load-mouse-pointer("image/lupa.cur":U)  in frame fPage0.
 ttcat.cod-transp:load-mouse-pointer("image/lupa.cur":U)  in frame fPage0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMasterDetail 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    find docum-est
         where docum-est.cod-emitente = ttcat.cod-emitente
           and docum-est.nro-docto    = ttcat.nro-docto
           and docum-est.serie-docto  = ttcat.serie-docto
           and docum-est.nat-operacao = ttcat.nat-oper-entr
           no-lock no-error.
    if avail docum-est then
       assign dt-dt-entrada:screen-value in frame fpage0  = string(docum-est.dt-trans).
    find emitente 
         where emitente.cod-emitente = input frame fPage0 ttcat.cod-emitente
         no-lock no-error.
    assign c-nome-emitente:screen-value    = emitente.nome-emit
           c-endereco-cliente:screen-value = emitente.endereco
           c-cidade:screen-value           = emitente.cidade
           c-cidade:screen-value           = emitente.cidade
           c-cep:screen-value              = emitente.cep.
    find cond-pagto 
         where cond-pagto.cod-cond-pag = input frame fPage0 ttcat.cod-cond-pag
         no-lock no-error.
    if avail cond-pagto then
       assign c-desc-cond-pagto:screen-value    = cond-pagto.descricao.
    else
       assign c-desc-cond-pagto:screen-value    = "N∆o Encontrado".

    find transporte
         where transporte.cod-transp = input frame fPage0 ttcat.cod-transp
         no-lock no-error.

    if avail transporte then
       assign c-desc-transp:screen-value    = transporte.nome.           
    else
       assign c-desc-transp:screen-value    = "N∆o Encontrado".        
    if ttcat.ind-situacao = 1 then do:
       assign c-situacao:screen-value = "N∆o Realizado".
       run pi-habilita-comandos (input yes).
    end.   
    else do:
       assign c-situacao:screen-value = "Realizado".
       run pi-habilita-comandos (input no).
    end.       

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMasterDetail 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    find emitente 
         where emitente.cod-emitente = input frame fPage0 ttcat.cod-emitente
         no-lock no-error.
    assign c-nome-emitente:screen-value    = emitente.nome-emit
           c-endereco-cliente:screen-value = emitente.endereco
           c-cidade:screen-value           = emitente.cidade
           c-cidade:screen-value           = emitente.cidade
           c-cep:screen-value              = emitente.cep.

    bt-confirmacao:sensitive    in frame fPage0 = yes.
    bt-rel2:sensitive           in frame fPage0 = yes.
    bt-rel3:sensitive           in frame fPage0 = yes.    

    
/*     RUN returnEstabelecDefault IN h-bodi143(output i-cod-estabel). */
/*     if  i-cod-estabel <> ? then do: */
/*         assign tt-wt-docto.cod-estabel:screen-value in frame fPage0 = i-cod-estabel. */
/*         apply "LEAVE":U to tt-wt-docto.cod-estabel in frame fPage0. */
/*     end. */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EnableDisableFields wMasterDetail 
PROCEDURE EnableDisableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/  
def input parameter  p-l-habilita as logical.
assign ttcat.dt-validade:sensitive          in frame fPage0 = p-l-habilita
       ttcat.cod-cond-pagto:sensitive       in frame fPage0 = p-l-habilita
       ttcat.cod-transp:sensitive           in frame fPage0 = p-l-habilita       
       ttcat.observacao:sensitive           in frame fPage0 = p-l-habilita   
       ttcat.vl-acrescimo:sensitive         in frame fPage0 = p-l-habilita       
       ttcat.consertado-por:sensitive       in frame fPage0 = p-l-habilita       
       ttcat.dt-conserto:sensitive          in frame fPage0 = p-l-habilita       
       ttcat.testado-por:sensitive          in frame fPage0 = p-l-habilita       
       ttcat.dt-teste:sensitive             in frame fPage0 = p-l-habilita       
       ttcat.defeito-reclamado:sensitive    in frame fPage0 = p-l-habilita       
       ttcat.defeito-constatado:sensitive   in frame fPage0 = p-l-habilita       
       ttcat.solucao:sensitive              in frame fPage0 = p-l-habilita

           btFirst:sensitive            in frame fPage0 = not p-l-habilita
           menu-item miFirst:sensitive  in menu mbMain  = not p-l-habilita
           btPrev:sensitive             in frame fPage0 = not p-l-habilita
           menu-item miPrev:sensitive   in menu mbMain  = not p-l-habilita
           btNext:sensitive             in frame fPage0 = not p-l-habilita
           menu-item miNext:sensitive   in menu mbMain  = not p-l-habilita
           btLast:sensitive             in frame fPage0 = not p-l-habilita
           menu-item miLast:sensitive   in menu mbMain  = not p-l-habilita
           btGoTo:sensitive             in frame fPage0 = not p-l-habilita
           menu-item miGoTo:sensitive   in menu mbMain  = not p-l-habilita
           btSearch:sensitive           in frame fPage0 = not p-l-habilita
           menu-item miSearch:sensitive in menu mbMain  = not p-l-habilita

           btAdd:sensitive              in frame fPage0 = not p-l-habilita
           menu-item miAdd:sensitive    in menu mbMain  = not p-l-habilita
           btUpdate:sensitive           in frame fPage0 = not p-l-habilita
           menu-item miUpdate:sensitive in menu mbMain  = not p-l-habilita
           btDelete:sensitive           in frame fPage0 = not p-l-habilita
           menu-item miDelete:sensitive in menu mbMain  = not p-l-habilita
           btSave:sensitive             in frame fPage0 = p-l-habilita
           menu-item miSave:sensitive   in menu mbMain  = p-l-habilita
           btCancel:sensitive           in frame fPage0 = p-l-habilita
           menu-item miCancel:sensitive in menu mbMain  = p-l-habilita

           btAddSon1:sensitive    in frame fPage1 = not p-l-habilita
           btUpdateSon1:sensitive in frame fPage1 = not p-l-habilita
           btDeleteSon1:sensitive in frame fPage1 = not p-l-habilita.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMasterDetail 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V† Para
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUTTON btGoToCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btGoToOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE c-nr-cat LIKE {&ttParent}.nr-cat NO-UNDO.
    DEFINE VARIABLE c-sequencia LIKE {&ttParent}.sequencia NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        c-nr-cat          AT ROW 1.21 COL 17.72 COLON-ALIGNED
        c-sequencia       AT ROW 2.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para cat" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V†_Para_cat"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */
                                         
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-nr-cat c-sequencia .
        
        /*:T Posiciona query, do DBO, atravÇs dos valores do °ndice £nico */
        RUN goToKey IN {&hDBOParent} (input "103", INPUT c-nr-cat , INPUT c-sequencia ).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "<TableName>":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-nr-cat c-sequencia  btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GoToRecord2 wMasterDetail 
PROCEDURE GoToRecord2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-cod-estabel AS CHAR    NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-cat      AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-sequencia   AS INTEGER NO-UNDO.        

    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    RUN gotoKey IN {&hDBOParent} (INPUT p-cod-estabel, input p-nr-cat, input p-sequencia).

    IF  RETURN-VALUE = "NOK":U THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 2,
                           INPUT "CAT").
        RETURN NO-APPLY.
    END.
    ELSE DO:
        RUN getRowid         IN {&hDBOParent}  (OUTPUT rGoTo).
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        RETURN "OK":U.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMasterDetail 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "boes400":U THEN DO:
        {btb/btb008za.i1 esbo/boes400.p YES}
        {btb/btb008za.i2 esbo/boes400.p '' {&hDBOParent}} 
    END.
    
    RUN setConstraintMain IN {&hDBOParent}  NO-ERROR.
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) OR 
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "boes401":U THEN DO:
        {btb/btb008za.i1 esbo/boes401.p YES}
        {btb/btb008za.i2 esbo/boes401.p '' {&hDBOSon1}} 
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueriesSon wMasterDetail 
PROCEDURE openQueriesSon :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualiza browsers filhos
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    {masterdetail/openqueriesson.i &Parent="cat"
                                   &Query="NrCat"
                                   &PageNumber="1"}   
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-choose-bt-save wMasterDetail 
PROCEDURE pi-choose-bt-save :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    find cond-pagto 
         where cond-pagto.cod-cond-pag = input frame fPage0 ttcat.cod-cond-pag
         no-lock no-error.
    if not avail cond-pagto then do:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 2,
                           INPUT "Cond.Pagamento").
        RETURN NO-APPLY.    
    end.
    else assign c-desc-cond-pagto:screen-value    = cond-pagto.descricao.
       
    find transporte
         where transporte.cod-transp = input frame fPage0 ttcat.cod-transp
         no-lock no-error.

    if not avail transporte then do:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 2,
                           INPUT "Transportador").
        RETURN NO-APPLY.    
    end.
    else assign c-desc-transp:screen-value    = transporte.nome.

    run goToKey in {&hDBOParent}(input ttcat.cod-estabel, input ttcat.nr-cat, input ttcat.sequencia).

    if  return-value = "OK":U then do trans:
        run getRecord in {&hDBOParent}(output table ttcat).        
            
        find first ttcat.
        do  with frame fPage0:
            assign ttcat.dt-validade        
                   ttcat.cod-cond-pagto      
                   ttcat.cod-transp          
                   ttcat.observacao          
                   ttcat.vl-acrescimo        
                   ttcat.vl-mao-obra 
                   ttcat.vl-a-pagar        
                   ttcat.consertado-por      
                   ttcat.dt-conserto         
                   ttcat.testado-por         
                   ttcat.dt-teste            
                   ttcat.defeito-reclamado   
                   ttcat.defeito-constatado  
                   ttcat.solucao.             
            
        end.

        run setRecord in {&hDBOParent} (input table ttcat).
        run updateRecord in {&hDBOParent}.

        IF  return-value = "NOK" THEN
            undo, return no-apply.
    end.


    RUN EnableDisableFields(no).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-comandos wMasterDetail 
PROCEDURE pi-habilita-comandos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-l-habilita as logical.
assign     btUpdate:sensitive           in frame fPage0 = p-l-habilita
           menu-item miUpdate:sensitive in menu mbMain  = p-l-habilita
           btDelete:sensitive           in frame fPage0 = p-l-habilita
           menu-item miDelete:sensitive in menu mbMain  = p-l-habilita
           btSave:sensitive             in frame fPage0 = p-l-habilita
           menu-item miSave:sensitive   in menu mbMain  = p-l-habilita
           btCancel:sensitive           in frame fPage0 = p-l-habilita
           menu-item miCancel:sensitive in menu mbMain  = p-l-habilita

           btAddSon1:sensitive    in frame fPage1 = p-l-habilita
           btUpdateSon1:sensitive in frame fPage1 = p-l-habilita
           btDeleteSon1:sensitive in frame fPage1 = p-l-habilita.
           btCopySon1:sensitive in frame fPage1 = p-l-habilita.
           
           
           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

