&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-auditoria-adicional NO-UNDO LIKE auditoria-adicional
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-auditoria-anexo NO-UNDO LIKE auditoria-anexo
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-auditoria-geral NO-UNDO LIKE auditoria-geral
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-auditoria-observacao NO-UNDO LIKE auditoria-observacao
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-auditoria-visual NO-UNDO LIKE auditoria-visual
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESAQP010 2.00.00.000}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */



CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          ESAQP010
&GLOBAL-DEFINE Version          2.00.00.000

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Gerais,Visual/Func,Adicional,Observaá∆o,Anexos

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE AddParent        YES
&GLOBAL-DEFINE CopyParent       NO
&GLOBAL-DEFINE UpdateParent     YES
&GLOBAL-DEFINE DeleteParent     YES

&GLOBAL-DEFINE AddSon1          NO
&GLOBAL-DEFINE CopySon1         NO
&GLOBAL-DEFINE UpdateSon1       NO
&GLOBAL-DEFINE DeleteSon1       NO

&GLOBAL-DEFINE AddSon2          YES
&GLOBAL-DEFINE CopySon2         YES
&GLOBAL-DEFINE UpdateSon2       YES
&GLOBAL-DEFINE DeleteSon2       YES

&GLOBAL-DEFINE AddSon3          YES
&GLOBAL-DEFINE CopySon3         YES
&GLOBAL-DEFINE UpdateSon3       YES
&GLOBAL-DEFINE DeleteSon3       YES

&GLOBAL-DEFINE AddSon4          yes
&GLOBAL-DEFINE CopySon4         no
&GLOBAL-DEFINE UpdateSon4       no
&GLOBAL-DEFINE DeleteSon4       YES

&GLOBAL-DEFINE AddSon5          YES
&GLOBAL-DEFINE CopySon5         YES
&GLOBAL-DEFINE UpdateSon5       YES
&GLOBAL-DEFINE DeleteSon5       YES

&GLOBAL-DEFINE ttParent         tt-auditoria-geral
&GLOBAL-DEFINE hDBOParent       h-boes671
&GLOBAL-DEFINE DBOParentTable   auditoria-geral
&GLOBAL-DEFINE DBOParentDestroy TRUE

&global-define VALUE-CHANGED5    yes

/*
&GLOBAL-DEFINE ttSon1           <Temp-Table Name>
&GLOBAL-DEFINE hDBOSon1         <Handle DBO Variable Name>
&GLOBAL-DEFINE DBOSon1Table     <DBOSon1 Table Name>
&GLOBAL-DEFINE DBOSon1Destroy   <DBOSon1 Destroy Flag>
*/

/*
&GLOBAL-DEFINE page0KeyFields tt-auditoria-geral.nr-seq-auditoria
&GLOBAL-DEFINE page0Fields    tt-auditoria-geral.cod-estabel tt-auditoria-geral.it-codigo
&GLOBAL-DEFINE page1Fields    rs-ind-amostragem tt-auditoria-geral.des-auditor tt-auditoria-geral.cod-unid-negoc fi-ge-codigo fi-nr-linha tt-auditoria-geral.dt-amostragem tt-auditoria-geral.nr-seq-tipo-lote tt-auditoria-geral.qt-prod-lote tt-auditoria-geral.cod-audit-origem tt-auditoria-geral.cont-reinspecao tt-auditoria-geral.qt-apar-test tt-auditoria-geral.log-revisado tt-auditoria-geral.qtd-prod-revis tt-auditoria-geral.log-bloqueio tt-auditoria-geral.qtd-prod-bloq tt-auditoria-geral.descricao
*/


&GLOBAL-DEFINE ttSon2           tt-auditoria-visual
&GLOBAL-DEFINE hDBOSon2         h-boes672
&GLOBAL-DEFINE DBOSon2Table     auditoria-visual
&GLOBAL-DEFINE DBOSon2Destroy   TRUE

&GLOBAL-DEFINE ttSon3           tt-auditoria-adicional
&GLOBAL-DEFINE hDBOSon3         h-boes673
&GLOBAL-DEFINE DBOSon3Table     auditoria-adicional
&GLOBAL-DEFINE DBOSon3Destroy   TRUE

&GLOBAL-DEFINE ttSon4           tt-auditoria-observacao
&GLOBAL-DEFINE hDBOSon4         h-boes674
&GLOBAL-DEFINE DBOSon4Table     auditoria-observacao
&GLOBAL-DEFINE DBOSon4Destroy   TRUE

&GLOBAL-DEFINE ttSon5           tt-auditoria-anexo
&GLOBAL-DEFINE hDBOSon5         h-boes675
&GLOBAL-DEFINE DBOSon5Table     auditoria-anexo
&GLOBAL-DEFINE DBOSon5Destroy   TRUE


&GLOBAL-DEFINE page0Fields      tt-auditoria-geral.nr-seq-auditoria tt-auditoria-geral.cod-estabel tt-auditoria-geral.it-codigo
&GLOBAL-DEFINE page1Fields      cb-turno rs-ind-amostragem tt-auditoria-geral.des-auditor tt-auditoria-geral.cod-unid-negoc fi-ge-codigo fi-nr-linha tt-auditoria-geral.dt-amostragem tt-auditoria-geral.nr-seq-tipo-lote tt-auditoria-geral.qt-prod-lote tt-auditoria-geral.cod-audit-origem tt-auditoria-geral.cont-reinspecao tt-auditoria-geral.qt-apar-test tt-auditoria-geral.log-revisado tt-auditoria-geral.qtd-prod-revis tt-auditoria-geral.log-bloqueio tt-auditoria-geral.qtd-prod-bloq tt-auditoria-geral.descricao tt-auditoria-geral.log-double-sample tt-auditoria-geral.qt-problema
&global-define page4Fields      tt-auditoria-observacao.observacao btAddSon4 btDeleteSon4 cb-turno

/*
&GLOBAL-DEFINE page1Browse      
&GLOBAL-DEFINE page2Browse      
*/ 

&GLOBAL-DEFINE page2Browse      brSon2
&GLOBAL-DEFINE page3Browse      brSon3
&GLOBAL-DEFINE page5Browse      brSon5

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define variable v_obs as char no-undo.
define variable v_sit as char no-undo.
DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.

define buffer bf-auditoria-geral for auditoria-geral.

{esp/es0018.i}

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
/*DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.*/
DEFINE VARIABLE {&hDBOSon2}   AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon3}   AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon4}   AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon5}   AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MasterDetail
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSon2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-auditoria-visual aq-origem-prob ~
aq-comp-prod aq-categoria aq-problema tt-auditoria-adicional aq-teste ~
tt-auditoria-anexo

/* Definitions for BROWSE brSon2                                        */
&Scoped-define FIELDS-IN-QUERY-brSon2 aq-origem-prob.des-orig-prob ~
aq-problema.des-problema tt-auditoria-visual.ind-problema ~
tt-auditoria-visual.des-serie tt-auditoria-visual.qt-problema ~
aq-comp-prod.des-componente aq-categoria.des-categoria ~
tt-auditoria-visual.nr-cartao tt-auditoria-visual.log-revisao ~
tt-auditoria-visual.log-bloqueio tt-auditoria-visual.obs-causa 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon2 
&Scoped-define QUERY-STRING-brSon2 FOR EACH tt-auditoria-visual NO-LOCK, ~
      FIRST aq-origem-prob WHERE aq-origem-prob.nr-seq-orig-prob = tt-auditoria-visual.nr-seq-orig-prob NO-LOCK, ~
      FIRST aq-comp-prod OF tt-auditoria-visual NO-LOCK, ~
      FIRST aq-categoria OF tt-auditoria-visual NO-LOCK, ~
      FIRST aq-problema WHERE aq-problema.nr-seq-problema = tt-auditoria-visual.nr-seq-problema NO-LOCK
&Scoped-define OPEN-QUERY-brSon2 OPEN QUERY brSon2 FOR EACH tt-auditoria-visual NO-LOCK, ~
      FIRST aq-origem-prob WHERE aq-origem-prob.nr-seq-orig-prob = tt-auditoria-visual.nr-seq-orig-prob NO-LOCK, ~
      FIRST aq-comp-prod OF tt-auditoria-visual NO-LOCK, ~
      FIRST aq-categoria OF tt-auditoria-visual NO-LOCK, ~
      FIRST aq-problema WHERE aq-problema.nr-seq-problema = tt-auditoria-visual.nr-seq-problema NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon2 tt-auditoria-visual aq-origem-prob ~
aq-comp-prod aq-categoria aq-problema
&Scoped-define FIRST-TABLE-IN-QUERY-brSon2 tt-auditoria-visual
&Scoped-define SECOND-TABLE-IN-QUERY-brSon2 aq-origem-prob
&Scoped-define THIRD-TABLE-IN-QUERY-brSon2 aq-comp-prod
&Scoped-define FOURTH-TABLE-IN-QUERY-brSon2 aq-categoria
&Scoped-define FIFTH-TABLE-IN-QUERY-brSon2 aq-problema


/* Definitions for BROWSE brSon3                                        */
&Scoped-define FIELDS-IN-QUERY-brSon3 aq-teste.des-teste ~
fn-sit(tt-auditoria-adicional.ind-sit-teste) @ v_sit ~
tt-auditoria-adicional.log-habilita-ns tt-auditoria-adicional.nr-serie ~
tt-auditoria-adicional.narrativa[1] tt-auditoria-adicional.narrativa[2] ~
tt-auditoria-adicional.narrativa[3] tt-auditoria-adicional.narrativa[4] ~
tt-auditoria-adicional.narrativa[5] tt-auditoria-adicional.narrativa[6] ~
tt-auditoria-adicional.narrativa[7] tt-auditoria-adicional.narrativa[8] ~
tt-auditoria-adicional.narrativa[9] tt-auditoria-adicional.narrativa[10] ~
tt-auditoria-adicional.narrativa[11] tt-auditoria-adicional.narrativa[12] ~
tt-auditoria-adicional.narrativa[13] tt-auditoria-adicional.narrativa[14] ~
tt-auditoria-adicional.narrativa[15] tt-auditoria-adicional.narrativa[16] ~
tt-auditoria-adicional.narrativa[17] tt-auditoria-adicional.narrativa[18] ~
tt-auditoria-adicional.narrativa[19] tt-auditoria-adicional.narrativa[20] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon3 
&Scoped-define QUERY-STRING-brSon3 FOR EACH tt-auditoria-adicional NO-LOCK, ~
      FIRST aq-teste WHERE aq-teste.nr-seq-teste = tt-auditoria-adicional.nr-seq-teste NO-LOCK
&Scoped-define OPEN-QUERY-brSon3 OPEN QUERY brSon3 FOR EACH tt-auditoria-adicional NO-LOCK, ~
      FIRST aq-teste WHERE aq-teste.nr-seq-teste = tt-auditoria-adicional.nr-seq-teste NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon3 tt-auditoria-adicional aq-teste
&Scoped-define FIRST-TABLE-IN-QUERY-brSon3 tt-auditoria-adicional
&Scoped-define SECOND-TABLE-IN-QUERY-brSon3 aq-teste


/* Definitions for BROWSE brSon5                                        */
&Scoped-define FIELDS-IN-QUERY-brSon5 tt-auditoria-anexo.nr-seq-auditoria ~
tt-auditoria-anexo.nr-seq-anexo tt-auditoria-anexo.det-anexo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon5 
&Scoped-define QUERY-STRING-brSon5 FOR EACH tt-auditoria-anexo NO-LOCK
&Scoped-define OPEN-QUERY-brSon5 OPEN QUERY brSon5 FOR EACH tt-auditoria-anexo NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon5 tt-auditoria-anexo
&Scoped-define FIRST-TABLE-IN-QUERY-brSon5 tt-auditoria-anexo


/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brSon2}

/* Definitions for FRAME fPage3                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage3 ~
    ~{&OPEN-QUERY-brSon3}

/* Definitions for FRAME fpage5                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage5 ~
    ~{&OPEN-QUERY-brSon5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-auditoria-geral.nr-seq-auditoria ~
tt-auditoria-geral.cod-estabel tt-auditoria-geral.it-codigo 
&Scoped-define ENABLED-TABLES tt-auditoria-geral
&Scoped-define FIRST-ENABLED-TABLE tt-auditoria-geral
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys RECT-1 btFirst btPrev ~
btNext btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btQueryJoins ~
btReportsJoins btExit btHelp fi-desc-estabel fi-desc-produto 
&Scoped-Define DISPLAYED-FIELDS tt-auditoria-geral.nr-seq-auditoria ~
tt-auditoria-geral.cod-estabel tt-auditoria-geral.it-codigo 
&Scoped-define DISPLAYED-TABLES tt-auditoria-geral
&Scoped-define FIRST-DISPLAYED-TABLE tt-auditoria-geral
&Scoped-Define DISPLAYED-OBJECTS fi-desc-estabel fi-desc-produto 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-sit wMasterDetail 
FUNCTION fn-sit RETURNS CHARACTER
  ( pSit as int )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-turno wMasterDetail 
FUNCTION fn-turno RETURNS CHARACTER
  ( pTurno as int )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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
DEFINE BUTTON btAdd 
     IMAGE-UP FILE "image\im-add":U
     IMAGE-INSENSITIVE FILE "image\ii-add":U
     LABEL "Add" 
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

DEFINE VARIABLE fi-desc-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-produto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.5.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.58.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE cb-turno AS CHARACTER FORMAT "X(20)" INITIAL "0" 
     LABEL "Turno" 
     VIEW-AS COMBO-BOX INNER-LINES 4
     LIST-ITEMS "Geral","1ß Turno","2ß Turno","3ß Turno" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE fi-desc-ge AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-linha AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-tipo-lote AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-unid-negoc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ge-codigo AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Grupo Estoque" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE rs-ind-amostragem AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Di†ria", 1,
"Reinspeá∆o", 2,
"Acompanhamento", 3
     SIZE 38 BY .75 NO-UNDO.

DEFINE VARIABLE tg-lei-informatica AS LOGICAL INITIAL no 
     LABEL "Lei Inform†tica" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .83 NO-UNDO.

DEFINE BUTTON btAddSon2 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btCopySon2 
     LABEL "Copiar" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon2 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon2 
     LABEL "Alterar" 
     SIZE 10 BY 1.

DEFINE BUTTON btAddSon3 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btCopySon3 
     LABEL "Copiar" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon3 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon3 
     LABEL "Alterar" 
     SIZE 10 BY 1.

DEFINE BUTTON btAddSon4 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon4 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btAddSon5 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btCopySon5 
     LABEL "Copiar" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon5 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btUpdateSon5 
     LABEL "Alterar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon2 FOR 
      tt-auditoria-visual, 
      aq-origem-prob, 
      aq-comp-prod, 
      aq-categoria, 
      aq-problema SCROLLING.

DEFINE QUERY brSon3 FOR 
      tt-auditoria-adicional, 
      aq-teste SCROLLING.

DEFINE QUERY brSon5 FOR 
      tt-auditoria-anexo SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon2 wMasterDetail _STRUCTURED
  QUERY brSon2 NO-LOCK DISPLAY
      aq-origem-prob.des-orig-prob COLUMN-LABEL "Origem" FORMAT "x(50)":U
            WIDTH 20
      aq-problema.des-problema COLUMN-LABEL "Problema" FORMAT "x(50)":U
            WIDTH 20
      tt-auditoria-visual.ind-problema FORMAT "9":U
      tt-auditoria-visual.des-serie FORMAT "x(40)":U WIDTH 20
      tt-auditoria-visual.qt-problema FORMAT ">>>,>>>,>>9.9999":U
      aq-comp-prod.des-componente COLUMN-LABEL "Compon" FORMAT "x(50)":U
            WIDTH 20
      aq-categoria.des-categoria COLUMN-LABEL "Categoria" FORMAT "x(50)":U
            WIDTH 20
      tt-auditoria-visual.nr-cartao FORMAT "x(30)":U
      tt-auditoria-visual.log-revisao FORMAT "yes/no":U
      tt-auditoria-visual.log-bloqueio FORMAT "Sim/N∆o":U WIDTH 7.86
      tt-auditoria-visual.obs-causa FORMAT "x(2000)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.83
         FONT 2.

DEFINE BROWSE brSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon3 wMasterDetail _STRUCTURED
  QUERY brSon3 NO-LOCK DISPLAY
      aq-teste.des-teste COLUMN-LABEL "Teste" FORMAT "x(40)":U
            WIDTH 20
      fn-sit(tt-auditoria-adicional.ind-sit-teste) @ v_sit COLUMN-LABEL "Sit Teste" FORMAT "x(12)":U
            WIDTH 12.86
      tt-auditoria-adicional.log-habilita-ns FORMAT "Sim/N∆o":U
      tt-auditoria-adicional.nr-serie COLUMN-LABEL "Rastreabilidade" FORMAT "x(300)":U
      tt-auditoria-adicional.narrativa[1] FORMAT "x(2000)":U
      tt-auditoria-adicional.narrativa[2] FORMAT "x(2000)":U
      tt-auditoria-adicional.narrativa[3] FORMAT "x(2000)":U
      tt-auditoria-adicional.narrativa[4] FORMAT "x(2000)":U
      tt-auditoria-adicional.narrativa[5] FORMAT "x(2000)":U
      tt-auditoria-adicional.narrativa[6] FORMAT "x(2000)":U
      tt-auditoria-adicional.narrativa[7] FORMAT "x(2000)":U
      tt-auditoria-adicional.narrativa[8] FORMAT "x(2000)":U
      tt-auditoria-adicional.narrativa[9] FORMAT "x(2000)":U
      tt-auditoria-adicional.narrativa[10] FORMAT "x(2000)":U
      tt-auditoria-adicional.narrativa[11] FORMAT "x(2000)":U
      tt-auditoria-adicional.narrativa[12] FORMAT "x(2000)":U
      tt-auditoria-adicional.narrativa[13] FORMAT "x(2000)":U
      tt-auditoria-adicional.narrativa[14] FORMAT "x(2000)":U
      tt-auditoria-adicional.narrativa[15] FORMAT "x(2000)":U
      tt-auditoria-adicional.narrativa[16] FORMAT "x(2000)":U
      tt-auditoria-adicional.narrativa[17] FORMAT "x(2000)":U
      tt-auditoria-adicional.narrativa[18] FORMAT "x(2000)":U
      tt-auditoria-adicional.narrativa[19] FORMAT "x(2000)":U
      tt-auditoria-adicional.narrativa[20] FORMAT "x(2000)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.83
         FONT 2.

DEFINE BROWSE brSon5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon5 wMasterDetail _STRUCTURED
  QUERY brSon5 NO-LOCK DISPLAY
      tt-auditoria-anexo.nr-seq-auditoria FORMAT ">>>>>9":U
      tt-auditoria-anexo.nr-seq-anexo FORMAT ">>>>>9":U
      tt-auditoria-anexo.det-anexo FORMAT "x(200)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.83
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
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     tt-auditoria-geral.nr-seq-auditoria AT ROW 3 COL 39 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-auditoria-geral.cod-estabel AT ROW 4.75 COL 19 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     fi-desc-estabel AT ROW 4.75 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     tt-auditoria-geral.it-codigo AT ROW 5.75 COL 19 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     fi-desc-produto AT ROW 5.75 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1 WIDGET-ID 14
     RECT-1 AT ROW 4.5 COL 1 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 21.29
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     tt-auditoria-geral.qt-problema AT ROW 9.5 COL 41.57 COLON-ALIGNED WIDGET-ID 62
          VIEW-AS FILL-IN 
          SIZE 13.43 BY .88
     tt-auditoria-geral.sigla AT ROW 4.92 COL 74 COLON-ALIGNED WIDGET-ID 58
          LABEL "CÇlula"
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     cb-turno AT ROW 7.58 COL 65 COLON-ALIGNED WIDGET-ID 54
     tt-auditoria-geral.log-double-sample AT ROW 6.83 COL 45.57 WIDGET-ID 52
          VIEW-AS TOGGLE-BOX
          SIZE 19 BY .83
     tg-lei-informatica AT ROW 6.75 COL 30.86 WIDGET-ID 48
     rs-ind-amostragem AT ROW 1.25 COL 17 NO-LABEL WIDGET-ID 28
     tt-auditoria-geral.cod-audit-origem AT ROW 1.25 COL 71 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     tt-auditoria-geral.des-auditor AT ROW 2.17 COL 15 COLON-ALIGNED WIDGET-ID 8
          LABEL "Auditor"
          VIEW-AS FILL-IN 
          SIZE 22.57 BY .88
     tt-auditoria-geral.cont-reinspecao AT ROW 2.17 COL 71 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     tt-auditoria-geral.cod-unid-negoc AT ROW 3.08 COL 15 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     fi-desc-unid-negoc AT ROW 3.08 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     fi-ge-codigo AT ROW 4 COL 15 COLON-ALIGNED WIDGET-ID 32
     fi-desc-ge AT ROW 4 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     tt-auditoria-geral.nr-linha AT ROW 4.92 COL 15 COLON-ALIGNED WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     fi-desc-linha AT ROW 4.92 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     tt-auditoria-geral.nr-seq-tipo-lote AT ROW 5.83 COL 15 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     fi-desc-tipo-lote AT ROW 5.83 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     tt-auditoria-geral.qt-apar-test AT ROW 6.75 COL 15 COLON-ALIGNED WIDGET-ID 16
          LABEL "Qtd Aparelhos Test"
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-auditoria-geral.dt-amostragem AT ROW 7.67 COL 15 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-auditoria-geral.qt-prod-lote AT ROW 8.58 COL 15 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-auditoria-geral.log-revisado AT ROW 7.67 COL 30.86 WIDGET-ID 22
          VIEW-AS TOGGLE-BOX
          SIZE 13 BY .83
     tt-auditoria-geral.qtd-prod-revis AT ROW 8.58 COL 41.57 COLON-ALIGNED WIDGET-ID 20
          LABEL "Qtde Revisada"
          VIEW-AS FILL-IN 
          SIZE 13.43 BY .88
     tt-auditoria-geral.log-bloqueio AT ROW 7.67 COL 45.57 WIDGET-ID 46
          LABEL "Lote Bloqueado"
          VIEW-AS TOGGLE-BOX
          SIZE 13 BY .83
     tt-auditoria-geral.qtd-prod-bloq AT ROW 9.5 COL 15 COLON-ALIGNED WIDGET-ID 44
          LABEL "Qtde Bloqueada"
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-auditoria-geral.descricao AT ROW 10.75 COL 3 NO-LABEL WIDGET-ID 24
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 80 BY 2.17
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 8.92
         SIZE 84.43 BY 12.33
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage3
     brSon3 AT ROW 1.17 COL 2
     btAddSon3 AT ROW 12 COL 2
     btCopySon3 AT ROW 12 COL 12
     btUpdateSon3 AT ROW 12 COL 22
     btDeleteSon3 AT ROW 12 COL 32
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 8.92
         SIZE 84.43 BY 12.33
         FONT 1 WIDGET-ID 200.

DEFINE FRAME fpage5
     brSon5 AT ROW 1.17 COL 2
     btAddSon5 AT ROW 12 COL 2
     btCopySon5 AT ROW 12 COL 12
     btUpdateSon5 AT ROW 12 COL 22
     btDeleteSon5 AT ROW 12 COL 32
     btFile AT ROW 12 COL 42 HELP
          "Escolha do nome do arquivo" WIDGET-ID 6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 8.92
         SIZE 84.43 BY 12.33
         FONT 1 WIDGET-ID 400.

DEFINE FRAME fPage4
     tt-auditoria-observacao.observacao AT ROW 1 COL 1 NO-LABEL WIDGET-ID 2
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 84 BY 11
     btAddSon4 AT ROW 12.04 COL 1
     btDeleteSon4 AT ROW 12.04 COL 11
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 8.92
         SIZE 84.43 BY 12.33
         FONT 1 WIDGET-ID 300.

DEFINE FRAME fPage2
     brSon2 AT ROW 1.17 COL 2
     btAddSon2 AT ROW 12 COL 2
     btCopySon2 AT ROW 12 COL 12
     btUpdateSon2 AT ROW 12 COL 22
     btDeleteSon2 AT ROW 12 COL 32
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 8.92
         SIZE 84.43 BY 12.33
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-auditoria-adicional T "?" NO-UNDO mgesp auditoria-adicional
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-auditoria-anexo T "?" NO-UNDO mgesp auditoria-anexo
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-auditoria-geral T "?" NO-UNDO mgesp auditoria-geral
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-auditoria-observacao T "?" NO-UNDO mgesp auditoria-observacao
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-auditoria-visual T "?" NO-UNDO mgesp auditoria-visual
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
         HEIGHT             = 21.29
         WIDTH              = 90
         MAX-HEIGHT         = 21.29
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 21.29
         VIRTUAL-WIDTH      = 90
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
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE
       FRAME fPage2:FRAME = FRAME fPage0:HANDLE
       FRAME fPage3:FRAME = FRAME fPage0:HANDLE
       FRAME fPage4:FRAME = FRAME fPage0:HANDLE
       FRAME fpage5:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
/* SETTINGS FOR FILL-IN tt-auditoria-geral.des-auditor IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX tt-auditoria-geral.log-bloqueio IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-auditoria-geral.qt-apar-test IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-auditoria-geral.qtd-prod-bloq IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-auditoria-geral.qtd-prod-revis IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-auditoria-geral.sigla IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brSon2 1 fPage2 */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* BROWSE-TAB brSon3 1 fPage3 */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR EDITOR tt-auditoria-observacao.observacao IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fpage5
                                                                        */
/* BROWSE-TAB brSon5 1 fpage5 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon2
/* Query rebuild information for BROWSE brSon2
     _TblList          = "Temp-Tables.tt-auditoria-visual,mgesp.aq-origem-prob WHERE Temp-Tables.tt-auditoria-visual ...,mgesp.aq-comp-prod OF Temp-Tables.tt-auditoria-visual,mgesp.aq-categoria OF Temp-Tables.tt-auditoria-visual,mgesp.aq-problema WHERE Temp-Tables.tt-auditoria-visual ..."
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST, FIRST, FIRST, FIRST"
     _JoinCode[2]      = "mgesp.aq-origem-prob.nr-seq-orig-prob = Temp-Tables.tt-auditoria-visual.nr-seq-orig-prob"
     _JoinCode[3]      = "mgesp.aq-comp-prod.nr-seq-comp = Temp-Tables.tt-auditoria-visual.nr-seq-comp"
     _JoinCode[4]      = "mgesp.aq-categoria.nr-seq-categoria = Temp-Tables.tt-auditoria-visual.nr-seq-categoria"
     _JoinCode[5]      = "mgesp.aq-problema.nr-seq-problema = Temp-Tables.tt-auditoria-visual.nr-seq-problema"
     _FldNameList[1]   > mgesp.aq-origem-prob.des-orig-prob
"aq-origem-prob.des-orig-prob" "Origem" ? "character" ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > mgesp.aq-problema.des-problema
"aq-problema.des-problema" "Problema" ? "character" ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.tt-auditoria-visual.ind-problema
     _FldNameList[4]   > Temp-Tables.tt-auditoria-visual.des-serie
"tt-auditoria-visual.des-serie" ? ? "character" ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = Temp-Tables.tt-auditoria-visual.qt-problema
     _FldNameList[6]   > mgesp.aq-comp-prod.des-componente
"aq-comp-prod.des-componente" "Compon" ? "character" ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > mgesp.aq-categoria.des-categoria
"aq-categoria.des-categoria" "Categoria" ? "character" ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   = Temp-Tables.tt-auditoria-visual.nr-cartao
     _FldNameList[9]   = Temp-Tables.tt-auditoria-visual.log-revisao
     _FldNameList[10]   > Temp-Tables.tt-auditoria-visual.log-bloqueio
"tt-auditoria-visual.log-bloqueio" ? ? "logical" ? ? ? ? ? ? no ? no no "7.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   = Temp-Tables.tt-auditoria-visual.obs-causa
     _Query            is OPENED
*/  /* BROWSE brSon2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon3
/* Query rebuild information for BROWSE brSon3
     _TblList          = "Temp-Tables.tt-auditoria-adicional,mgesp.aq-teste WHERE Temp-Tables.tt-auditoria-adicional ..."
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST"
     _JoinCode[2]      = "mgesp.aq-teste.nr-seq-teste = Temp-Tables.tt-auditoria-adicional.nr-seq-teste"
     _FldNameList[1]   > mgesp.aq-teste.des-teste
"aq-teste.des-teste" "Teste" ? "character" ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fn-sit(tt-auditoria-adicional.ind-sit-teste) @ v_sit" "Sit Teste" "x(12)" ? ? ? ? ? ? ? no ? no no "12.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-auditoria-adicional.log-habilita-ns
"tt-auditoria-adicional.log-habilita-ns" ? "Sim/N∆o" "logical" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-auditoria-adicional.nr-serie
"tt-auditoria-adicional.nr-serie" "Rastreabilidade" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = Temp-Tables.tt-auditoria-adicional.narrativa[1]
     _FldNameList[6]   = Temp-Tables.tt-auditoria-adicional.narrativa[2]
     _FldNameList[7]   = Temp-Tables.tt-auditoria-adicional.narrativa[3]
     _FldNameList[8]   = Temp-Tables.tt-auditoria-adicional.narrativa[4]
     _FldNameList[9]   = Temp-Tables.tt-auditoria-adicional.narrativa[5]
     _FldNameList[10]   = Temp-Tables.tt-auditoria-adicional.narrativa[6]
     _FldNameList[11]   = Temp-Tables.tt-auditoria-adicional.narrativa[7]
     _FldNameList[12]   = Temp-Tables.tt-auditoria-adicional.narrativa[8]
     _FldNameList[13]   = Temp-Tables.tt-auditoria-adicional.narrativa[9]
     _FldNameList[14]   = Temp-Tables.tt-auditoria-adicional.narrativa[10]
     _FldNameList[15]   = Temp-Tables.tt-auditoria-adicional.narrativa[11]
     _FldNameList[16]   = Temp-Tables.tt-auditoria-adicional.narrativa[12]
     _FldNameList[17]   = Temp-Tables.tt-auditoria-adicional.narrativa[13]
     _FldNameList[18]   = Temp-Tables.tt-auditoria-adicional.narrativa[14]
     _FldNameList[19]   = Temp-Tables.tt-auditoria-adicional.narrativa[15]
     _FldNameList[20]   = Temp-Tables.tt-auditoria-adicional.narrativa[16]
     _FldNameList[21]   = Temp-Tables.tt-auditoria-adicional.narrativa[17]
     _FldNameList[22]   = Temp-Tables.tt-auditoria-adicional.narrativa[18]
     _FldNameList[23]   = Temp-Tables.tt-auditoria-adicional.narrativa[19]
     _FldNameList[24]   = Temp-Tables.tt-auditoria-adicional.narrativa[20]
     _Query            is OPENED
*/  /* BROWSE brSon3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon5
/* Query rebuild information for BROWSE brSon5
     _TblList          = "Temp-Tables.tt-auditoria-anexo"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.tt-auditoria-anexo.nr-seq-auditoria
     _FldNameList[2]   = Temp-Tables.tt-auditoria-anexo.nr-seq-anexo
     _FldNameList[3]   > Temp-Tables.tt-auditoria-anexo.det-anexo
"tt-auditoria-anexo.det-anexo" ? "x(200)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brSon5 */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage3
/* Query rebuild information for FRAME fPage3
     _Query            is NOT OPENED
*/  /* FRAME fPage3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage4
/* Query rebuild information for FRAME fPage4
     _Query            is NOT OPENED
*/  /* FRAME fPage4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage5
/* Query rebuild information for FRAME fpage5
     _Query            is NOT OPENED
*/  /* FRAME fpage5 */
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


&Scoped-define BROWSE-NAME brSon5
&Scoped-define FRAME-NAME fpage5
&Scoped-define SELF-NAME brSon5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon5 wMasterDetail
ON VALUE-CHANGED OF brSon5 IN FRAME fpage5
DO:
    {masterdetail/ValueChanged.i &PageNumber="5"}

    
    define variable vQuery    as handle no-undo.

    assign vQuery = brSon5:query.
    
    if vQuery:get-first then
        assign btFile:sensitive in frame fPage5 = yes.
    else
        assign btFile:sensitive in frame fPage5 = no.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMasterDetail
ON CHOOSE OF btAdd IN FRAME fPage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd IN MENU mbMain DO:
    RUN addRecord IN THIS-PROCEDURE (INPUT "esp/aqp/esaqp010a.w":U). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btAddSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon2 wMasterDetail
ON CHOOSE OF btAddSon2 IN FRAME fPage2 /* Incluir */
DO:
    {masterdetail/addson.i &ProgramSon="esp/aqp/esaqp010b.w"
                           &PageNumber="2"}
                          
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btAddSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon3 wMasterDetail
ON CHOOSE OF btAddSon3 IN FRAME fPage3 /* Incluir */
DO:
    {masterdetail/addson.i &ProgramSon="esp/aqp/esaqp010c.w"
                           &PageNumber="3"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btAddSon4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon4 wMasterDetail
ON CHOOSE OF btAddSon4 IN FRAME fPage4 /* Incluir */
DO:
   ASSIGN wMasterDetail:SENSITIVE = no.

   RUN esp/aqp/esaqp010d.w (INPUT rowid(tt-auditoria-observacao),
                            input {&hDBOParent},
                            INPUT "ADD",
                            INPUT THIS-PROCEDURE,
                            INPUT 4,
                            output v_obs).

   IF v_obs <> "" THEN DO:
        find first auditoria-observacao exclusive-lock
             where auditoria-observacao.nr-seq-auditoria = tt-auditoria-geral.nr-seq-auditoria no-error.
        IF not avail auditoria-observacao then do:
            create auditoria-observacao.
            assign auditoria-observacao.nr-seq-auditoria = tt-auditoria-geral.nr-seq-auditoria.
        end.

        assign auditoria-observacao.observacao = v_obs.

        RUN repositionRecord IN h-boes671 (INPUT tt-auditoria-geral.r-rowid).
        RUN getRecord IN h-boes671 (OUTPUT TABLE tt-auditoria-geral).
        FIND FIRST tt-auditoria-geral NO-ERROR.
        run afterDisplayFields.

    END.

    ASSIGN wMasterDetail:SENSITIVE = yes.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage5
&Scoped-define SELF-NAME btAddSon5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon5 wMasterDetail
ON CHOOSE OF btAddSon5 IN FRAME fpage5 /* Incluir */
DO:
    {masterdetail/addson.i &ProgramSon="esp/aqp/esaqp010e.w"
                           &PageNumber="5"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMasterDetail
ON CHOOSE OF btCopy IN FRAME fPage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    RUN copyRecord (INPUT "esp/aqp/esaqp010a.w":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btCopySon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopySon2 wMasterDetail
ON CHOOSE OF btCopySon2 IN FRAME fPage2 /* Copiar */
DO:
    {masterdetail/copyson.i &ProgramSon="esp/aqp/esaqp010b.w"
                            &PageNumber="2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btCopySon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopySon3 wMasterDetail
ON CHOOSE OF btCopySon3 IN FRAME fPage3 /* Copiar */
DO:
    {masterdetail/copyson.i &ProgramSon="esp/aqp/esaqp010c.w"
                            &PageNumber="3"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage5
&Scoped-define SELF-NAME btCopySon5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopySon5 wMasterDetail
ON CHOOSE OF btCopySon5 IN FRAME fpage5 /* Copiar */
DO:
    {masterdetail/copyson.i &ProgramSon="esp/aqp/esaqp010e.w"
                            &PageNumber="5"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMasterDetail
ON CHOOSE OF btDelete IN FRAME fPage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    RUN deleteRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btDeleteSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon2 wMasterDetail
ON CHOOSE OF btDeleteSon2 IN FRAME fPage2 /* Eliminar */
DO:
    {masterdetail/deleteson.i &PageNumber="2"}

    if return-value = "OK":U then do:
        find first auditoria-geral exclusive-lock
             where auditoria-geral.nr-seq-auditoria = tt-auditoria-geral.nr-seq-auditoria no-error.
        if avail auditoria-geral then do:
            find last auditoria-visual no-lock
                where auditoria-visual.nr-seq-auditoria = auditoria-geral.nr-seq-auditoria no-error.
            if avail auditoria-visual then
                assign auditoria-geral.log-revisado   = auditoria-visual.log-revisao
                       auditoria-geral.qtd-prod-revis = tt-auditoria-geral.qt-prod-lote
                       auditoria-geral.log-bloqueio   = auditoria-visual.log-bloqueio
                       auditoria-geral.qtd-prod-bloq  = tt-auditoria-geral.qt-prod-lote.
            else
                assign auditoria-geral.log-revisado   = no
                       auditoria-geral.qtd-prod-revis = 0
                       auditoria-geral.log-bloqueio   = no
                       auditoria-geral.qtd-prod-bloq  = 0.
                
            assign tt-auditoria-geral.log-revisado:checked in frame fPage1        = auditoria-geral.log-revisado   
                   tt-auditoria-geral.qtd-prod-revis:screen-value in frame fPage1 = string(auditoria-geral.qtd-prod-revis)
                   tt-auditoria-geral.log-bloqueio:checked in frame fPage1        = auditoria-geral.log-bloqueio
                   tt-auditoria-geral.qtd-prod-bloq:screen-value in frame fPage1  = string(auditoria-geral.qtd-prod-bloq).

        end.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btDeleteSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon3 wMasterDetail
ON CHOOSE OF btDeleteSon3 IN FRAME fPage3 /* Eliminar */
DO:
    {masterdetail/deleteson.i &PageNumber="3"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btDeleteSon4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon4 wMasterDetail
ON CHOOSE OF btDeleteSon4 IN FRAME fPage4 /* Eliminar */
DO:
    RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 27100, INPUT "Eliminar observaá∆o?" + "~~" + "Deseja eliminar observaá∆o?":U).
    IF RETURN-VALUE = "YES" THEN DO:
        FIND FIRST auditoria-observacao EXCLUSIVE-LOCK
             WHERE auditoria-observacao.nr-seq-auditoria = tt-auditoria-geral.nr-seq-auditoria NO-ERROR.
        IF AVAIL auditoria-observacao THEN
            delete auditoria-observacao.

        RUN repositionRecord IN h-boes671 (INPUT tt-auditoria-geral.r-rowid).
        RUN getRecord IN h-boes671 (OUTPUT TABLE tt-auditoria-geral).
        FIND FIRST tt-auditoria-geral NO-ERROR.
        run afterDisplayFields.

    END.                                       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage5
&Scoped-define SELF-NAME btDeleteSon5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon5 wMasterDetail
ON CHOOSE OF btDeleteSon5 IN FRAME fpage5 /* Eliminar */
DO:
    assign btFile:sensitive in frame fPage5 = no.
    {masterdetail/deleteson.i &PageNumber="5"}

    if return-value = "no" then
        assign btFile:sensitive in frame fPage5 = yes.

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


&Scoped-define FRAME-NAME fpage5
&Scoped-define SELF-NAME btFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFile wMasterDetail
ON CHOOSE OF btFile IN FRAME fpage5
DO:
    define variable hColuna   as handle no-undo.
    define variable c_arquivo as char format "x(200)" no-undo.
    DEFINE VARIABLE c-comando AS CHARACTER   NO-UNDO.


    

    assign hColuna   = brSon5:get-browse-column(3):buffer-field
           c_arquivo = string(hColuna:buffer-value, "x(200)").

    ASSIGN c-comando = 'START "Progress" "' + c_arquivo + '"'.

    if search(c_arquivo) = ? then do:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17006, INPUT "Arquivo inexistente." + "~~" + "Arquivo n∆o encontrado.":U).
        RETURN "NOK":U.
    end.
    else do:
        /*os-command silent value("START ") '"Progress" "' value(c_arquivo) '"'.*/
        OS-COMMAND SILENT VALUE(c-comando).
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
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
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMasterDetail
ON CHOOSE OF btSearch IN FRAME fPage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="eszoom\z01es671.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMasterDetail
ON CHOOSE OF btUpdate IN FRAME fPage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    DEFINE VARIABLE d-dt-limite-alt AS DATE        NO-UNDO.
    IF AVAIL tt-auditoria-geral THEN DO:
       IF DAY(TODAY) < 8 THEN
          ASSIGN d-dt-limite-alt = TODAY - DAY(TODAY)
                 d-dt-limite-alt = d-dt-limite-alt - DAY(d-dt-limite-alt).
       ELSE
          ASSIGN d-dt-limite-alt = TODAY - DAY(TODAY).

       IF tt-auditoria-geral.dt-amostragem <= d-dt-limite-alt THEN DO:
          EMPTY TEMP-TABLE tt-prog-ponto.
          RUN esp/es0018p.p (INPUT "esaqp010":U,
                             INPUT 1,
                             INPUT 0,
                             INPUT "":U,
                             OUTPUT TABLE tt-prog-ponto).
          FIND FIRST tt-prog-ponto 
               WHERE tt-prog-ponto.conteudo = c-seg-usuario NO-ERROR.
          IF NOT AVAIL tt-prog-ponto THEN DO:
             MESSAGE "J† ultrapassou a data limite para alteraá∆o. "
                 VIEW-AS ALERT-BOX ERROR BUTTONS OK.
             RETURN NO-APPLY.
          END.
       END.
    END.
    RUN updateRecord IN THIS-PROCEDURE (INPUT "esp/aqp/esaqp010a.w":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btUpdateSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon2 wMasterDetail
ON CHOOSE OF btUpdateSon2 IN FRAME fPage2 /* Alterar */
DO:
    {masterdetail/updateson.i &ProgramSon="esp/aqp/esaqp010b.w"
                              &PageNumber="2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btUpdateSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon3 wMasterDetail
ON CHOOSE OF btUpdateSon3 IN FRAME fPage3 /* Alterar */
DO:
    {masterdetail/updateson.i &ProgramSon="esp/aqp/esaqp010c.w"
                              &PageNumber="3"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage5
&Scoped-define SELF-NAME btUpdateSon5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon5 wMasterDetail
ON CHOOSE OF btUpdateSon5 IN FRAME fpage5 /* Alterar */
DO:
    {masterdetail/updateson.i &ProgramSon="esp/aqp/esaqp010e.w"
                              &PageNumber="5"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME tt-auditoria-geral.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-geral.cod-estabel wMasterDetail
ON LEAVE OF tt-auditoria-geral.cod-estabel IN FRAME fPage0 /* Estabelecimento */
DO:

    ASSIGN fi-desc-estabel:SCREEN-VALUE IN FRAME fPage0 = "".

    FOR FIRST estabelec NO-LOCK
        WHERE estabelec.cod-estabel = INPUT FRAME fPage0 tt-auditoria-geral.cod-estabel:

        ASSIGN fi-desc-estabel:SCREEN-VALUE IN FRAME fPage0 = estabelec.nome.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-auditoria-geral.cod-unid-negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-geral.cod-unid-negoc wMasterDetail
ON LEAVE OF tt-auditoria-geral.cod-unid-negoc IN FRAME fPage1 /* Unidade Neg¢cio */
DO:

    ASSIGN fi-desc-unid-negoc:SCREEN-VALUE IN FRAME fPage1 = "".

    FOR FIRST unid-negoc NO-LOCK
        WHERE unid-negoc.cod-unid-negoc = INPUT FRAME fPage1 tt-auditoria-geral.cod-unid-negoc:

        ASSIGN fi-desc-unid-negoc:SCREEN-VALUE IN FRAME fPage1 = unid-negoc.des-unid-negoc.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-ge-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ge-codigo wMasterDetail
ON LEAVE OF fi-ge-codigo IN FRAME fPage1 /* Grupo Estoque */
DO:

    ASSIGN fi-desc-ge:SCREEN-VALUE IN FRAME fpage1 = "".

    FOR FIRST grup-estoque NO-LOCK
        WHERE grup-estoque.ge-codigo = INPUT FRAME fpage1 fi-ge-codigo:

        ASSIGN fi-desc-ge:SCREEN-VALUE IN FRAME fpage1 = grup-estoque.descricao.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME tt-auditoria-geral.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-geral.it-codigo wMasterDetail
ON LEAVE OF tt-auditoria-geral.it-codigo IN FRAME fPage0 /* Produto */
DO:

    ASSIGN fi-desc-produto:SCREEN-VALUE IN FRAME fPage0 = "".

    FOR FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = INPUT FRAME fPage0 tt-auditoria-geral.it-codigo:

        ASSIGN fi-desc-produto:SCREEN-VALUE IN FRAME fPage0 = ITEM.desc-item.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wMasterDetail
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-auditoria-geral.nr-linha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-geral.nr-linha wMasterDetail
ON LEAVE OF tt-auditoria-geral.nr-linha IN FRAME fPage1 /* Linha Produá∆o */
DO:

    ASSIGN fi-desc-linha:SCREEN-VALUE IN FRAME fPage1 = "".

    FOR FIRST lin-prod NO-LOCK
        WHERE lin-prod.cod-estabel = INPUT FRAME fPage0 tt-auditoria-geral.cod-estabel
          AND lin-prod.nr-linha    = INPUT FRAME fPage1 tt-auditoria-geral.nr-linha:

        ASSIGN fi-desc-linha:SCREEN-VALUE IN FRAME fPage1 = lin-prod.descricao.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-auditoria-geral.nr-seq-tipo-lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-auditoria-geral.nr-seq-tipo-lote wMasterDetail
ON LEAVE OF tt-auditoria-geral.nr-seq-tipo-lote IN FRAME fPage1 /* Tipo de Lote */
DO:

    ASSIGN fi-desc-tipo-lote:SCREEN-VALUE IN FRAME fpage1 = "".

    FOR FIRST aq-tipo-lote NO-LOCK
        WHERE aq-tipo-lote.nr-seq-tipo-lote = INPUT FRAME fPage1 tt-auditoria-geral.nr-seq-tipo-lote:

        ASSIGN fi-desc-tipo-lote:SCREEN-VALUE IN FRAME fpage1 = aq-tipo-lote.des-lote.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSon2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{masterdetail/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterChangePage wMasterDetail 
PROCEDURE AfterChangePage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    find first auditoria-geral no-lock
         where auditoria-geral.nr-seq-auditoria = tt-auditoria-geral.nr-seq-auditoria no-error.
    if avail auditoria-geral then
        assign  tt-auditoria-geral.log-revisado:checked in frame fPage1        = auditoria-geral.log-revisado
                tt-auditoria-geral.qtd-prod-revis:screen-value in frame fPage1 = string(auditoria-geral.qtd-prod-revis)
                tt-auditoria-geral.log-bloqueio:checked in frame fPage1        = auditoria-geral.log-bloqueio
                tt-auditoria-geral.qtd-prod-bloq:screen-value in frame fPage1  = string(auditoria-geral.qtd-prod-bloq)
                tt-auditoria-geral.qt-problema:screen-value in frame fPage1    = string(auditoria-geral.qt-problema)
                tt-auditoria-geral.log-double-sample:checked in frame fPage1   = auditoria-geral.log-double-sample
                tt-auditoria-geral.des-auditor:screen-value in frame fPage1    = string(auditoria-geral.des-auditor).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDisplayFields wMasterDetail 
PROCEDURE AfterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME fPage0:
    APPLY "LEAVE" TO tt-auditoria-geral.cod-estabel.
    APPLY "LEAVE" TO tt-auditoria-geral.it-codigo.
END.

DO WITH FRAME fPage1:

    IF AVAIL tt-auditoria-geral THEN
        ASSIGN rs-ind-amostragem = tt-auditoria-geral.ind-amostragem
               cb-turno:SCREEN-VALUE = fn-turno(tt-auditoria-geral.cod-turno).

    DISP rs-ind-amostragem.

    ASSIGN fi-ge-codigo               = 0
           tg-lei-informatica         = NO
           tg-lei-informatica:BGCOLOR = ?.

    FOR FIRST item NO-LOCK
        WHERE item.it-codigo = INPUT FRAME fPage0 tt-auditoria-geral.it-codigo:

        ASSIGN fi-ge-codigo = item.ge-codigo.
    
        FIND FIRST int-portaria-movto NO-LOCK
             WHERE int-portaria-movto.it-codigo = item.it-codigo
               AND int-portaria-movto.dt-fim = ?
               AND int-portaria-movto.classificacao <> "BEM" NO-ERROR.
        ASSIGN tg-lei-informatica         = AVAIL int-portaria-movto
               tg-lei-informatica:BGCOLOR = IF AVAIL int-portaria-movto 
                                            THEN 12
                                            ELSE ?.
        
    END.

    IF AVAIL tt-auditoria-geral THEN
        DISP rs-ind-amostragem
             tt-auditoria-geral.cod-audit-origem
             tt-auditoria-geral.des-auditor
             tt-auditoria-geral.cont-reinspecao
             tt-auditoria-geral.cod-unid-negoc
             fi-ge-codigo
             tg-lei-informatica
             tt-auditoria-geral.nr-linha
             tt-auditoria-geral.sigla
             tt-auditoria-geral.dt-amostragem
             tt-auditoria-geral.qt-apar-test
             tt-auditoria-geral.nr-seq-tipo-lote
             tt-auditoria-geral.log-revisado
             tt-auditoria-geral.qt-prod-lote
             tt-auditoria-geral.qt-problema
             tt-auditoria-geral.qtd-prod-revis
             tt-auditoria-geral.descricao
             tt-auditoria-geral.log-bloqueio
             tt-auditoria-geral.qtd-prod-bloq
             tt-auditoria-geral.log-double-sample.

    APPLY "LEAVE" TO tt-auditoria-geral.cod-unid-negoc.
    APPLY "LEAVE" TO fi-ge-codigo.
    APPLY "LEAVE" TO tt-auditoria-geral.nr-linha.
    APPLY "LEAVE" TO tt-auditoria-geral.nr-seq-tipo-lote.
END.

DO WITH FRAME fPage4:
    RUN linkToAuditoria-geral IN {&hDBOSon4} (INPUT {&hDBOParent}).
    RUN openQueryStatic       IN {&hDBOSon4} (INPUT "Geral":U) NO-ERROR.
    RUN getCharField          IN {&hDBOSon4} (INPUT "observacao",
                                              OUTPUT v_obs).

    ASSIGN tt-auditoria-observacao.observacao:SCREEN-VALUE IN FRAME fPage4 = v_obs.
    ASSIGN btAddSon4:SENSITIVE IN FRAME fPage4 = YES
           btDeleteSon4:SENSITIVE IN FRAME fPage4 = YES.
END.

DO WITH FRAME fPage5:
    DEFINE VARIABLE vQuery AS HANDLE NO-UNDO.

    ASSIGN vQuery = brSon5:QUERY.

    IF vQuery:GET-FIRST THEN
        ASSIGN btFile:SENSITIVE IN FRAME fPage5 = YES.
    ELSE
        ASSIGN btFile:SENSITIVE IN FRAME fPage5 = NO.
END.

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
    
/*     DEFINE VARIABLE rGoTo AS ROWID NO-UNDO. */
    
    DEFINE VARIABLE i-nr-seq-auditoria LIKE {&ttParent}.nr-seq-auditoria NO-UNDO  VIEW-AS FILL-IN SIZE 12 BY .88.
    
    DEFINE FRAME fGoToRecord
        i-nr-seq-auditoria AT ROW 1.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para <Tabela>" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V†_Para_Auditoria"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN i-nr-seq-auditoria.
        
        RUN goToKey IN {&hDBOParent} (INPUT i-nr-seq-auditoria).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Auditoria":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE i-nr-seq-auditoria btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
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
       {&hDBOParent}:FILE-NAME <> "esbo/boes671.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes671.p YES}
        {btb/btb008za.i2 esbo/boes671.p '' {&hDBOParent}} 
    END.
    
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon2}) OR
       {&hDBOSon2}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon2}:FILE-NAME <> "esbo/boes672.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes672.p YES}
        {btb/btb008za.i2 esbo/boes672.p '' {&hDBOSon2}} 
    END.

    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon3}) OR
       {&hDBOSon3}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon3}:FILE-NAME <> "esbo/boes673.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes673.p YES}
        {btb/btb008za.i2 esbo/boes673.p '' {&hDBOSon3}} 
    END.

    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon4}) OR
       {&hDBOSon4}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon4}:FILE-NAME <> "esbo/boes674.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes674.p YES}
        {btb/btb008za.i2 esbo/boes674.p '' {&hDBOSon4}} 
    END.
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon5}) OR
       {&hDBOSon5}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon5}:FILE-NAME <> "esbo/boes675.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes675.p YES}
        {btb/btb008za.i2 esbo/boes675.p '' {&hDBOSon5}} 
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
    
    {masterdetail/openqueriesson.i &Parent="auditoria-geral"
                                   &Query="geral"
                                   &PageNumber="2"}
                                   
        {masterdetail/openqueriesson.i &Parent="auditoria-geral"
                                   &Query="geral"
                                   &PageNumber="3"}
                                   
        {masterdetail/openqueriesson.i &Parent="auditoria-geral"
                                   &Query="geral"
                                   &PageNumber="5"}
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-posiciona-audit wMasterDetail 
PROCEDURE pi-posiciona-audit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input param p-rowid-audit as rowid no-undo.

RUN repositionRecord IN THIS-PROCEDURE (INPUT p-rowid-audit).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-sit wMasterDetail 
FUNCTION fn-sit RETURNS CHARACTER
  ( pSit as int ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    
    if pSit = 1 then
        assign v_sit = "OK".
    ELSE IF  pSit = 2 THEN
        assign v_sit = "N«O OK".
    ELSE 
        assign v_sit = "AGUARDANDO".
  
  RETURN v_sit.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-turno wMasterDetail 
FUNCTION fn-turno RETURNS CHARACTER
  ( pTurno as int ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    
    CASE pTurno:
        WHEN 0 THEN RETURN "Geral".
        WHEN 1 THEN RETURN "1ß Turno".
        WHEN 2 THEN RETURN "2ß Turno".
        WHEN 3 THEN RETURN "3ß Turno".
    END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

