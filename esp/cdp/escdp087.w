&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-int-portaria-item NO-UNDO LIKE int-portaria-item
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-int-portaria-movto-bem NO-UNDO LIKE int-portaria-movto
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-int-portaria-movto-def NO-UNDO LIKE int-portaria-movto
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-int-portaria-movto-ppb NO-UNDO LIKE int-portaria-movto
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-int-portaria-movto-prov NO-UNDO LIKE int-portaria-movto
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-int-portaria-perc NO-UNDO LIKE int-portaria-perc
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
{include/i-prgvrs.i ESCDP087 2.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          ESCDP087
&GLOBAL-DEFINE Version          2.00.00.000

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     PPB,HAB. PROV.,HAB. DEF.,BEM,PERC

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE AddParent        YES
&GLOBAL-DEFINE CopyParent       YES
&GLOBAL-DEFINE UpdateParent     YES
&GLOBAL-DEFINE DeleteParent     YES

&GLOBAL-DEFINE AddSon1          YES
&GLOBAL-DEFINE CopySon1         YES
&GLOBAL-DEFINE UpdateSon1       YES
&GLOBAL-DEFINE DeleteSon1       YES

&GLOBAL-DEFINE AddSon2          YES
&GLOBAL-DEFINE CopySon2         YES
&GLOBAL-DEFINE UpdateSon2       YES
&GLOBAL-DEFINE DeleteSon2       YES

&GLOBAL-DEFINE AddSon3          YES
&GLOBAL-DEFINE CopySon3         YES
&GLOBAL-DEFINE UpdateSon3       YES
&GLOBAL-DEFINE DeleteSon3       YES

&GLOBAL-DEFINE AddSon4          YES
&GLOBAL-DEFINE CopySon4         YES
&GLOBAL-DEFINE UpdateSon4       YES
&GLOBAL-DEFINE DeleteSon4       YES

&GLOBAL-DEFINE AddSon5          YES
&GLOBAL-DEFINE CopySon5         YES
&GLOBAL-DEFINE UpdateSon5       YES
&GLOBAL-DEFINE DeleteSon5       YES

&GLOBAL-DEFINE ttParent         tt-int-portaria-item
&GLOBAL-DEFINE hDBOParent       h-boes042
&GLOBAL-DEFINE DBOParentTable   int-portaria-item
&GLOBAL-DEFINE DBOParentDestroy YES

&GLOBAL-DEFINE ttSon1           tt-int-portaria-movto-ppb   
&GLOBAL-DEFINE hDBOSon1         h-boes0431              
&GLOBAL-DEFINE DBOSon1Table     int-portaria-movto      
&GLOBAL-DEFINE DBOSon1Destroy   YES

&GLOBAL-DEFINE ttSon2           tt-int-portaria-movto-prov   
&GLOBAL-DEFINE hDBOSon2         h-boes0432              
&GLOBAL-DEFINE DBOSon2Table     int-portaria-movto      
&GLOBAL-DEFINE DBOSon2Destroy   YES

&GLOBAL-DEFINE ttSon3           tt-int-portaria-movto-def   
&GLOBAL-DEFINE hDBOSon3         h-boes0433              
&GLOBAL-DEFINE DBOSon3Table     int-portaria-movto      
&GLOBAL-DEFINE DBOSon3Destroy   YES

&GLOBAL-DEFINE ttSon4           tt-int-portaria-movto-bem   
&GLOBAL-DEFINE hDBOSon4         h-boes0434              
&GLOBAL-DEFINE DBOSon4Table     int-portaria-movto      
&GLOBAL-DEFINE DBOSon4Destroy   YES

&GLOBAL-DEFINE ttSon5           tt-int-portaria-perc   
&GLOBAL-DEFINE hDBOSon5         h-boes044              
&GLOBAL-DEFINE DBOSon5Table     int-portaria-perc      
&GLOBAL-DEFINE DBOSon5Destroy   YES

&GLOBAL-DEFINE page0Fields      tt-int-portaria-item.it-codigo tt-int-portaria-item.cod-estabel tt-int-portaria-item.desc-mctic tt-int-portaria-item.produto-base  tt-int-portaria-item.ncm-base

&GLOBAL-DEFINE page1Browse      brSon1
&GLOBAL-DEFINE page2Browse      brSon2
&GLOBAL-DEFINE page3Browse      brSon3
&GLOBAL-DEFINE page4Browse      brSon4
&GLOBAL-DEFINE page5Browse      brSon5

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE NEW GLOBAL SHARED VARIABLE p-tipo-escdp087 AS CHAR NO-UNDO.

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
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
&Scoped-define BROWSE-NAME brSon1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-int-portaria-movto-ppb ~
tt-int-portaria-movto-prov tt-int-portaria-movto-def ~
tt-int-portaria-movto-bem tt-int-portaria-perc

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-int-portaria-movto-ppb.codigo ~
tt-int-portaria-movto-ppb.dt-publicacao tt-int-portaria-movto-ppb.dt-ini ~
tt-int-portaria-movto-ppb.dt-fim tt-int-portaria-movto-ppb.observacao 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH tt-int-portaria-movto-ppb NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH tt-int-portaria-movto-ppb NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-int-portaria-movto-ppb
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-int-portaria-movto-ppb


/* Definitions for BROWSE brSon2                                        */
&Scoped-define FIELDS-IN-QUERY-brSon2 tt-int-portaria-movto-prov.codigo ~
tt-int-portaria-movto-prov.dt-ini tt-int-portaria-movto-prov.dt-fim ~
tt-int-portaria-movto-prov.observacao 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon2 
&Scoped-define QUERY-STRING-brSon2 FOR EACH tt-int-portaria-movto-prov NO-LOCK
&Scoped-define OPEN-QUERY-brSon2 OPEN QUERY brSon2 FOR EACH tt-int-portaria-movto-prov NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon2 tt-int-portaria-movto-prov
&Scoped-define FIRST-TABLE-IN-QUERY-brSon2 tt-int-portaria-movto-prov


/* Definitions for BROWSE brSon3                                        */
&Scoped-define FIELDS-IN-QUERY-brSon3 tt-int-portaria-movto-def.codigo ~
tt-int-portaria-movto-def.dt-portaria tt-int-portaria-movto-def.dt-ini ~
tt-int-portaria-movto-def.dt-fim tt-int-portaria-movto-def.observacao 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon3 
&Scoped-define QUERY-STRING-brSon3 FOR EACH tt-int-portaria-movto-def NO-LOCK
&Scoped-define OPEN-QUERY-brSon3 OPEN QUERY brSon3 FOR EACH tt-int-portaria-movto-def NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon3 tt-int-portaria-movto-def
&Scoped-define FIRST-TABLE-IN-QUERY-brSon3 tt-int-portaria-movto-def


/* Definitions for BROWSE brSon4                                        */
&Scoped-define FIELDS-IN-QUERY-brSon4 tt-int-portaria-movto-bem.codigo ~
tt-int-portaria-movto-bem.dt-ini tt-int-portaria-movto-bem.dt-fim ~
tt-int-portaria-movto-bem.observacao 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon4 
&Scoped-define QUERY-STRING-brSon4 FOR EACH tt-int-portaria-movto-bem NO-LOCK
&Scoped-define OPEN-QUERY-brSon4 OPEN QUERY brSon4 FOR EACH tt-int-portaria-movto-bem NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon4 tt-int-portaria-movto-bem
&Scoped-define FIRST-TABLE-IN-QUERY-brSon4 tt-int-portaria-movto-bem


/* Definitions for BROWSE brSon5                                        */
&Scoped-define FIELDS-IN-QUERY-brSon5 tt-int-portaria-perc.seq-perc ~
tt-int-portaria-perc.dt-ini tt-int-portaria-perc.dt-fim ~
tt-int-portaria-perc.aliq-ext-conv1 tt-int-portaria-perc.aliq-ext-conv2a ~
tt-int-portaria-perc.aliq-ext-conv2b tt-int-portaria-perc.aliq-ext-fndct ~
tt-int-portaria-perc.aliq-int tt-int-portaria-perc.aliq-adic ~
tt-int-portaria-perc.aliq-cred-hab tt-int-portaria-perc.aliq-cred-bem 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon5 
&Scoped-define QUERY-STRING-brSon5 FOR EACH tt-int-portaria-perc NO-LOCK
&Scoped-define OPEN-QUERY-brSon5 OPEN QUERY brSon5 FOR EACH tt-int-portaria-perc NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon5 tt-int-portaria-perc
&Scoped-define FIRST-TABLE-IN-QUERY-brSon5 tt-int-portaria-perc


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brSon2}

/* Definitions for FRAME fPage3                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage3 ~
    ~{&OPEN-QUERY-brSon3}

/* Definitions for FRAME fPage4                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage4 ~
    ~{&OPEN-QUERY-brSon4}

/* Definitions for FRAME fPage5                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage5 ~
    ~{&OPEN-QUERY-brSon5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-int-portaria-item.it-codigo ~
tt-int-portaria-item.cod-estabel tt-int-portaria-item.ncm-base ~
tt-int-portaria-item.produto-base tt-int-portaria-item.desc-mctic 
&Scoped-define ENABLED-TABLES tt-int-portaria-item
&Scoped-define FIRST-ENABLED-TABLE tt-int-portaria-item
&Scoped-Define ENABLED-OBJECTS rtToolBar rtParent btFirst btPrev btNext ~
btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btQueryJoins ~
btReportsJoins btExit btHelp c-desc-item c-desc-estab c-familia ~
c-familia-com c-ncm c-cod-orig c-aliq-ipi c-cod-unid-negoc tg-ind-item-fat ~
rs-classificacao 
&Scoped-Define DISPLAYED-FIELDS tt-int-portaria-item.it-codigo ~
tt-int-portaria-item.cod-estabel tt-int-portaria-item.ncm-base ~
tt-int-portaria-item.produto-base tt-int-portaria-item.desc-mctic 
&Scoped-define DISPLAYED-TABLES tt-int-portaria-item
&Scoped-define FIRST-DISPLAYED-TABLE tt-int-portaria-item
&Scoped-Define DISPLAYED-OBJECTS c-desc-item c-desc-estab c-familia ~
c-familia-com c-ncm c-cod-orig c-aliq-ipi c-cod-unid-negoc tg-ind-item-fat ~
rs-classificacao 

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
       MENU-ITEM miLast         LABEL "&éltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V  Para"       ACCELERATOR "CTRL-T"
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

DEFINE VARIABLE c-aliq-ipi AS CHARACTER FORMAT "X(256)":U 
     LABEL "Aliq. IPI" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-orig AS CHARACTER FORMAT "X(2)":U 
     LABEL "Origem" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-unid-negoc AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unid. Neg¢c." 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estab AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 52.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-familia AS CHARACTER FORMAT "X(256)":U 
     LABEL "Fam¡lia" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-familia-com AS CHARACTER FORMAT "X(256)":U 
     LABEL "Fam¡lia Comercial" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-ncm AS CHARACTER FORMAT "X(256)":U 
     LABEL "NCM" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE rs-classificacao AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "PPB", 1,
"Habilita‡Æo Provis¢ria", 2,
"Habilita‡Æo Definitiva", 3,
"Bem Desenvolvido", 4
     SIZE 64 BY .88 NO-UNDO.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 135 BY 8.21.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 135 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE tg-ind-item-fat AS LOGICAL INITIAL no 
     LABEL "Item Fatur vel" 
     VIEW-AS TOGGLE-BOX
     SIZE 12.43 BY .88 NO-UNDO.

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

DEFINE BUTTON btCopySon4 
     LABEL "Copiar" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon4 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btUpdateSon4 
     LABEL "Alterar" 
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

DEFINE BUTTON btUpdateSon5 
     LABEL "Alterar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-int-portaria-movto-ppb SCROLLING.

DEFINE QUERY brSon2 FOR 
      tt-int-portaria-movto-prov SCROLLING.

DEFINE QUERY brSon3 FOR 
      tt-int-portaria-movto-def SCROLLING.

DEFINE QUERY brSon4 FOR 
      tt-int-portaria-movto-bem SCROLLING.

DEFINE QUERY brSon5 FOR 
      tt-int-portaria-perc SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 NO-LOCK DISPLAY
      tt-int-portaria-movto-ppb.codigo FORMAT "x(16)":U
      tt-int-portaria-movto-ppb.dt-publicacao FORMAT "99/99/9999":U
      tt-int-portaria-movto-ppb.dt-ini FORMAT "99/99/9999":U
      tt-int-portaria-movto-ppb.dt-fim FORMAT "99/99/9999":U
      tt-int-portaria-movto-ppb.observacao FORMAT "x(2000)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 128 BY 10.83
         FONT 2.

DEFINE BROWSE brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon2 wMasterDetail _STRUCTURED
  QUERY brSon2 NO-LOCK DISPLAY
      tt-int-portaria-movto-prov.codigo FORMAT "x(16)":U
      tt-int-portaria-movto-prov.dt-ini FORMAT "99/99/9999":U
      tt-int-portaria-movto-prov.dt-fim FORMAT "99/99/9999":U
      tt-int-portaria-movto-prov.observacao FORMAT "x(2000)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 128 BY 10.83
         FONT 2.

DEFINE BROWSE brSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon3 wMasterDetail _STRUCTURED
  QUERY brSon3 NO-LOCK DISPLAY
      tt-int-portaria-movto-def.codigo FORMAT "x(16)":U
      tt-int-portaria-movto-def.dt-portaria FORMAT "99/99/9999":U
            WIDTH 10.14
      tt-int-portaria-movto-def.dt-ini FORMAT "99/99/9999":U
      tt-int-portaria-movto-def.dt-fim FORMAT "99/99/9999":U
      tt-int-portaria-movto-def.observacao FORMAT "x(2000)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 128 BY 10.83
         FONT 2.

DEFINE BROWSE brSon4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon4 wMasterDetail _STRUCTURED
  QUERY brSon4 NO-LOCK DISPLAY
      tt-int-portaria-movto-bem.codigo FORMAT "x(16)":U
      tt-int-portaria-movto-bem.dt-ini FORMAT "99/99/9999":U
      tt-int-portaria-movto-bem.dt-fim FORMAT "99/99/9999":U
      tt-int-portaria-movto-bem.observacao FORMAT "x(2000)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 128 BY 10.83
         FONT 2.

DEFINE BROWSE brSon5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon5 wMasterDetail _STRUCTURED
  QUERY brSon5 NO-LOCK DISPLAY
      tt-int-portaria-perc.seq-perc COLUMN-LABEL "Seq" FORMAT ">>>>>>9":U
            WIDTH 5.43
      tt-int-portaria-perc.dt-ini COLUMN-LABEL "Valid. Inicial" FORMAT "99/99/9999":U
            WIDTH 13.86
      tt-int-portaria-perc.dt-fim COLUMN-LABEL "Valid. Final" FORMAT "99/99/9999":U
            WIDTH 12.43
      tt-int-portaria-perc.aliq-ext-conv1 FORMAT ">>9.99":U
      tt-int-portaria-perc.aliq-ext-conv2a FORMAT ">>9.99":U
      tt-int-portaria-perc.aliq-ext-conv2b FORMAT ">>9.99":U
      tt-int-portaria-perc.aliq-ext-fndct FORMAT ">>9.99":U WIDTH 8
      tt-int-portaria-perc.aliq-int FORMAT ">>9.99":U WIDTH 8.72
      tt-int-portaria-perc.aliq-adic FORMAT ">>9.99":U WIDTH 10.14
      tt-int-portaria-perc.aliq-cred-hab FORMAT ">>9.99":U
      tt-int-portaria-perc.aliq-cred-bem FORMAT ">>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 128 BY 10.83
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrˆncia"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrˆncia anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrˆncia"
     btLast AT ROW 1.13 COL 13.57 HELP
          "éltima ocorrˆncia"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V  Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btAdd AT ROW 1.13 COL 31 HELP
          "Inclui nova ocorrˆncia"
     btCopy AT ROW 1.13 COL 35 HELP
          "Cria uma c¢pia da ocorrˆncia corrente"
     btUpdate AT ROW 1.13 COL 39 HELP
          "Altera ocorrˆncia corrente"
     btDelete AT ROW 1.13 COL 43 HELP
          "Elimina ocorrˆncia corrente"
     btQueryJoins AT ROW 1.13 COL 119.29 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 123.29 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 127.29 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 131.29 HELP
          "Ajuda"
     tt-int-portaria-item.it-codigo AT ROW 3 COL 14 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-desc-item AT ROW 3 COL 22.29 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     tt-int-portaria-item.cod-estabel AT ROW 4 COL 14 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     c-desc-estab AT ROW 4 COL 18.29 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     c-familia AT ROW 5 COL 14 COLON-ALIGNED WIDGET-ID 26
     c-familia-com AT ROW 5 COL 36 COLON-ALIGNED WIDGET-ID 28
     c-ncm AT ROW 5 COL 50 COLON-ALIGNED WIDGET-ID 30
     c-cod-orig AT ROW 5 COL 65 COLON-ALIGNED WIDGET-ID 24
     c-aliq-ipi AT ROW 5 COL 76 COLON-ALIGNED WIDGET-ID 32
     c-cod-unid-negoc AT ROW 5 COL 93 COLON-ALIGNED WIDGET-ID 34
     tg-ind-item-fat AT ROW 5 COL 103 WIDGET-ID 22
     tt-int-portaria-item.ncm-base AT ROW 6 COL 14 COLON-ALIGNED WIDGET-ID 38
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-int-portaria-item.produto-base AT ROW 7 COL 14 COLON-ALIGNED WIDGET-ID 36
          VIEW-AS FILL-IN 
          SIZE 117 BY .88
     tt-int-portaria-item.desc-mctic AT ROW 8 COL 14 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 117 BY .88
     rs-classificacao AT ROW 10 COL 16 NO-LABEL WIDGET-ID 16
     rtToolBar AT ROW 1 COL 1
     rtParent AT ROW 2.79 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 135.57 BY 25.71
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage3
     brSon3 AT ROW 1.17 COL 1.72
     btAddSon3 AT ROW 12.25 COL 2
     btCopySon3 AT ROW 12.25 COL 12
     btUpdateSon3 AT ROW 12.25 COL 22
     btDeleteSon3 AT ROW 12.25 COL 32
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 13
         SIZE 132.43 BY 12.75
         FONT 1 DROP-TARGET WIDGET-ID 200.

DEFINE FRAME fPage4
     brSon4 AT ROW 1.17 COL 1.72
     btAddSon4 AT ROW 12.25 COL 2
     btCopySon4 AT ROW 12.25 COL 12
     btUpdateSon4 AT ROW 12.25 COL 22
     btDeleteSon4 AT ROW 12.25 COL 32
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 13
         SIZE 132.43 BY 12.75
         FONT 1 WIDGET-ID 300.

DEFINE FRAME fPage5
     brSon5 AT ROW 1.17 COL 1.72
     btAddSon5 AT ROW 12.25 COL 2
     btCopySon5 AT ROW 12.25 COL 12
     btUpdateSon5 AT ROW 12.25 COL 22
     btDeleteSon5 AT ROW 12.25 COL 32
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 13
         SIZE 132.43 BY 12.75
         FONT 1 WIDGET-ID 400.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.17 COL 1.72
     btAddSon1 AT ROW 12.25 COL 2
     btCopySon1 AT ROW 12.25 COL 12
     btUpdateSon1 AT ROW 12.25 COL 22
     btDeleteSon1 AT ROW 12.25 COL 32
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 13
         SIZE 132.43 BY 12.75
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     brSon2 AT ROW 1.17 COL 1.72
     btAddSon2 AT ROW 12.25 COL 2
     btCopySon2 AT ROW 12.25 COL 12
     btUpdateSon2 AT ROW 12.25 COL 22
     btDeleteSon2 AT ROW 12.25 COL 32
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 13
         SIZE 132.43 BY 12.75
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-int-portaria-item T "?" NO-UNDO mgesp int-portaria-item
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-int-portaria-movto-bem T "?" NO-UNDO mgesp int-portaria-movto
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-int-portaria-movto-def T "?" NO-UNDO mgesp int-portaria-movto
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-int-portaria-movto-ppb T "?" NO-UNDO mgesp int-portaria-movto
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-int-portaria-movto-prov T "?" NO-UNDO mgesp int-portaria-movto
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-int-portaria-perc T "?" NO-UNDO mgesp int-portaria-perc
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
         HEIGHT             = 25.71
         WIDTH              = 135.57
         MAX-HEIGHT         = 32.25
         MAX-WIDTH          = 177.72
         VIRTUAL-HEIGHT     = 32.25
         VIRTUAL-WIDTH      = 177.72
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
       FRAME fPage5:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brSon2 1 fPage2 */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* BROWSE-TAB brSon3 1 fPage3 */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* BROWSE-TAB brSon4 1 fPage4 */
/* SETTINGS FOR FRAME fPage5
                                                                        */
/* BROWSE-TAB brSon5 1 fPage5 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _TblList          = "Temp-Tables.tt-int-portaria-movto-ppb"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.tt-int-portaria-movto-ppb.codigo
     _FldNameList[2]   = Temp-Tables.tt-int-portaria-movto-ppb.dt-publicacao
     _FldNameList[3]   = Temp-Tables.tt-int-portaria-movto-ppb.dt-ini
     _FldNameList[4]   = Temp-Tables.tt-int-portaria-movto-ppb.dt-fim
     _FldNameList[5]   = Temp-Tables.tt-int-portaria-movto-ppb.observacao
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon2
/* Query rebuild information for BROWSE brSon2
     _TblList          = "Temp-Tables.tt-int-portaria-movto-prov"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.tt-int-portaria-movto-prov.codigo
     _FldNameList[2]   = Temp-Tables.tt-int-portaria-movto-prov.dt-ini
     _FldNameList[3]   = Temp-Tables.tt-int-portaria-movto-prov.dt-fim
     _FldNameList[4]   = Temp-Tables.tt-int-portaria-movto-prov.observacao
     _Query            is OPENED
*/  /* BROWSE brSon2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon3
/* Query rebuild information for BROWSE brSon3
     _TblList          = "Temp-Tables.tt-int-portaria-movto-def"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.tt-int-portaria-movto-def.codigo
     _FldNameList[2]   > Temp-Tables.tt-int-portaria-movto-def.dt-portaria
"dt-portaria" ? ? "date" ? ? ? ? ? ? no ? no no "10.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.tt-int-portaria-movto-def.dt-ini
     _FldNameList[4]   = Temp-Tables.tt-int-portaria-movto-def.dt-fim
     _FldNameList[5]   = Temp-Tables.tt-int-portaria-movto-def.observacao
     _Query            is OPENED
*/  /* BROWSE brSon3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon4
/* Query rebuild information for BROWSE brSon4
     _TblList          = "Temp-Tables.tt-int-portaria-movto-bem"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.tt-int-portaria-movto-bem.codigo
     _FldNameList[2]   = Temp-Tables.tt-int-portaria-movto-bem.dt-ini
     _FldNameList[3]   = Temp-Tables.tt-int-portaria-movto-bem.dt-fim
     _FldNameList[4]   = Temp-Tables.tt-int-portaria-movto-bem.observacao
     _Query            is OPENED
*/  /* BROWSE brSon4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon5
/* Query rebuild information for BROWSE brSon5
     _TblList          = "Temp-Tables.tt-int-portaria-perc"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.tt-int-portaria-perc.seq-perc
"tt-int-portaria-perc.seq-perc" "Seq" ? "integer" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-int-portaria-perc.dt-ini
"tt-int-portaria-perc.dt-ini" "Valid. Inicial" ? "date" ? ? ? ? ? ? no ? no no "13.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-int-portaria-perc.dt-fim
"tt-int-portaria-perc.dt-fim" "Valid. Final" ? "date" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = Temp-Tables.tt-int-portaria-perc.aliq-ext-conv1
     _FldNameList[5]   = Temp-Tables.tt-int-portaria-perc.aliq-ext-conv2a
     _FldNameList[6]   = Temp-Tables.tt-int-portaria-perc.aliq-ext-conv2b
     _FldNameList[7]   > Temp-Tables.tt-int-portaria-perc.aliq-ext-fndct
"tt-int-portaria-perc.aliq-ext-fndct" ? ? "decimal" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-int-portaria-perc.aliq-int
"tt-int-portaria-perc.aliq-int" ? ? "decimal" ? ? ? ? ? ? no ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-int-portaria-perc.aliq-adic
"tt-int-portaria-perc.aliq-adic" ? ? "decimal" ? ? ? ? ? ? no ? no no "10.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   = Temp-Tables.tt-int-portaria-perc.aliq-cred-hab
     _FldNameList[11]   = Temp-Tables.tt-int-portaria-perc.aliq-cred-bem
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage5
/* Query rebuild information for FRAME fPage5
     _Query            is NOT OPENED
*/  /* FRAME fPage5 */
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


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMasterDetail
ON CHOOSE OF btAdd IN FRAME fPage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd IN MENU mbMain DO:
    RUN addRecord IN THIS-PROCEDURE (INPUT "esp\cdp\escdp087a.w":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btAddSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon1 wMasterDetail
ON CHOOSE OF btAddSon1 IN FRAME fPage1 /* Incluir */
DO:
    {masterdetail/addson.i &ProgramSon="esp\cdp\escdp087b.w"
                           &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btAddSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon2 wMasterDetail
ON CHOOSE OF btAddSon2 IN FRAME fPage2 /* Incluir */
DO:
    {masterdetail/addson.i &ProgramSon="esp\cdp\escdp087c.w"
                           &PageNumber="2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btAddSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon3 wMasterDetail
ON CHOOSE OF btAddSon3 IN FRAME fPage3 /* Incluir */
DO:
    {masterdetail/addson.i &ProgramSon="esp\cdp\escdp087d.w"
                           &PageNumber="3"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btAddSon4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon4 wMasterDetail
ON CHOOSE OF btAddSon4 IN FRAME fPage4 /* Incluir */
DO:
    {masterdetail/addson.i &ProgramSon="esp\cdp\escdp087e.w"
                           &PageNumber="4"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btAddSon5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon5 wMasterDetail
ON CHOOSE OF btAddSon5 IN FRAME fPage5 /* Incluir */
DO:
    {masterdetail/addson.i &ProgramSon="esp\cdp\escdp087f.w"
                           &PageNumber="5"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMasterDetail
ON CHOOSE OF btCopy IN FRAME fPage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:

    ASSIGN p-tipo-escdp087 = "Copy;" +
                             tt-int-portaria-item.it-codigo   + ";" +
                             tt-int-portaria-item.cod-estabel + ";" +
                             STRING(tt-int-portaria-item.seq) + ";".

    RUN copyRecord (INPUT "esp\cdp\escdp087a.w":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btCopySon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopySon1 wMasterDetail
ON CHOOSE OF btCopySon1 IN FRAME fPage1 /* Copiar */
DO:
    {masterdetail/copyson.i &ProgramSon="esp\cdp\escdp087b.w"
                            &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btCopySon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopySon2 wMasterDetail
ON CHOOSE OF btCopySon2 IN FRAME fPage2 /* Copiar */
DO:
    {masterdetail/copyson.i &ProgramSon="esp\cdp\escdp087c.w"
                            &PageNumber="2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btCopySon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopySon3 wMasterDetail
ON CHOOSE OF btCopySon3 IN FRAME fPage3 /* Copiar */
DO:
    {masterdetail/copyson.i &ProgramSon="esp\cdp\escdp087d.w"
                            &PageNumber="3"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btCopySon4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopySon4 wMasterDetail
ON CHOOSE OF btCopySon4 IN FRAME fPage4 /* Copiar */
DO:
    {masterdetail/copyson.i &ProgramSon="esp\cdp\escdp087e.w"
                            &PageNumber="4"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btCopySon5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopySon5 wMasterDetail
ON CHOOSE OF btCopySon5 IN FRAME fPage5 /* Copiar */
DO:
    {masterdetail/copyson.i &ProgramSon="esp\cdp\escdp087f.w"
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btDeleteSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon1 wMasterDetail
ON CHOOSE OF btDeleteSon1 IN FRAME fPage1 /* Eliminar */
DO:
    {masterdetail/deleteson.i &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btDeleteSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon2 wMasterDetail
ON CHOOSE OF btDeleteSon2 IN FRAME fPage2 /* Eliminar */
DO:
    {masterdetail/deleteson.i &PageNumber="2"}
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
    {masterdetail/deleteson.i &PageNumber="4"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btDeleteSon5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon5 wMasterDetail
ON CHOOSE OF btDeleteSon5 IN FRAME fPage5 /* Eliminar */
DO:
    {masterdetail/deleteson.i &PageNumber="5"}
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
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMasterDetail
ON CHOOSE OF btSearch IN FRAME fPage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="esp\cdp\escdp087z.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMasterDetail
ON CHOOSE OF btUpdate IN FRAME fPage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    RUN updateRecord IN THIS-PROCEDURE (INPUT "esp\cdp\escdp087a.w":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btUpdateSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon1 wMasterDetail
ON CHOOSE OF btUpdateSon1 IN FRAME fPage1 /* Alterar */
DO:
    {masterdetail/updateson.i &ProgramSon="esp\cdp\escdp087b.w"
                              &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btUpdateSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon2 wMasterDetail
ON CHOOSE OF btUpdateSon2 IN FRAME fPage2 /* Alterar */
DO:
    {masterdetail/updateson.i &ProgramSon="esp\cdp\escdp087c.w"
                              &PageNumber="2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btUpdateSon3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon3 wMasterDetail
ON CHOOSE OF btUpdateSon3 IN FRAME fPage3 /* Alterar */
DO:
    {masterdetail/updateson.i &ProgramSon="esp\cdp\escdp087d.w"
                              &PageNumber="3"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btUpdateSon4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon4 wMasterDetail
ON CHOOSE OF btUpdateSon4 IN FRAME fPage4 /* Alterar */
DO:
    {masterdetail/updateson.i &ProgramSon="esp\cdp\escdp087e.w"
                              &PageNumber="4"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btUpdateSon5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon5 wMasterDetail
ON CHOOSE OF btUpdateSon5 IN FRAME fPage5 /* Alterar */
DO:
    {masterdetail/updateson.i &ProgramSon="esp\cdp\escdp087f.w"
                              &PageNumber="5"}
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


&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSon1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{masterdetail/mainblock.i}

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

    FIND FIRST item WHERE item.it-codigo = tt-int-portaria-item.it-codigo NO-LOCK NO-ERROR.
    IF AVAIL ITEM AND item.it-codigo <> "" THEN 
        ASSIGN c-desc-item      = item.desc-item
               c-familia        = item.fm-codigo
               c-familia-com    = item.fm-cod-com
               c-ncm            = item.class-fiscal
               c-cod-orig       = STRING(item.codigo-orig)
               c-aliq-ipi       = STRING(item.aliquota-ipi)
               c-cod-unid-negoc = item.cod-unid-negoc
               tg-ind-item-fat  = item.ind-item-fat.
               
    ELSE 
        ASSIGN c-desc-item      = "Produto Base Beneficiado"
               c-familia        = ""
               c-familia-com    = ""
               c-ncm            = ""
               c-cod-orig       = ""
               c-aliq-ipi       = ""
               c-cod-unid-negoc = ""
               tg-ind-item-fat  = NO.

    FIND FIRST estabelec WHERE estabelec.cod-estabel = tt-int-portaria-item.cod-estabel NO-LOCK NO-ERROR.
    IF AVAIL item THEN 
        ASSIGN c-desc-estab = estabelec.nome.
    ELSE 
        ASSIGN c-desc-estab = "".

    RUN pi-verifica-classificacao.
        
    DISP c-desc-item
         c-familia
         c-familia-com
         c-ncm
         c-cod-orig
         c-aliq-ipi
         c-cod-unid-negoc
         c-desc-estab
         tg-ind-item-fat
        WITH FRAME fPage0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMasterDetail 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V  Para
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
    
    DEFINE VARIABLE c-item  LIKE {&ttParent}.it-codigo   NO-UNDO.
    DEFINE VARIABLE c-estab LIKE {&ttParent}.cod-estabel NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        c-item            AT ROW 1.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 8   BY .88
        c-estab           AT ROW 2.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 4   BY .88
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Item / Estab" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_Item_Estab"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */
                                         
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-item c-estab.
        
        /*:T Posiciona query, do DBO, atrav‚s dos valores do ¡ndice £nico */
        RUN goToKey IN {&hDBOParent} (INPUT c-item , INPUT c-estab ).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Item / Estab":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).
        
        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-item c-estab btGoToOK btGoToCancel 
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
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) OR
       {&hDBOParent}:TYPE <> "PROCEDURE":U OR
       {&hDBOParent}:FILE-NAME <> "esbo/boes042.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes042.p YES}
        {btb/btb008za.i2 esbo/boes042.p '' {&hDBOParent}} 
    END.
    
    //RUN setConstraint<Description> IN {&hDBOParent} (<pamameters>) NO-ERROR.
    RUN openQueryStatic IN {&hDBOParent} (INPUT "main":U) NO-ERROR.
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) OR 
       {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon1}:FILE-NAME <> "esbo/boes043.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes043.p YES}
        {btb/btb008za.i2 esbo/boes043.p '' {&hDBOSon1}} 
    END.
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon2}) OR
       {&hDBOSon2}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon2}:FILE-NAME <> "esbo/boes043.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes043.p YES}
        {btb/btb008za.i2 esbo/boes043.p '' {&hDBOSon2}} 
    END.

    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon3}) OR
       {&hDBOSon3}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon3}:FILE-NAME <> "esbo/boes043.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes043.p YES}
        {btb/btb008za.i2 esbo/boes043.p '' {&hDBOSon3}} 
    END.

    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon4}) OR
       {&hDBOSon4}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon4}:FILE-NAME <> "esbo/boes043.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes043.p YES}
        {btb/btb008za.i2 esbo/boes043.p '' {&hDBOSon4}} 
    END.

    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon5}) OR
       {&hDBOSon5}:TYPE <> "PROCEDURE":U OR
       {&hDBOSon5}:FILE-NAME <> "esbo/boes044.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes044.p YES}
        {btb/btb008za.i2 esbo/boes044.p '' {&hDBOSon5}} 
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
    
    {masterdetail/openqueriesson.i &Parent="int-portaria-item"
                                   &Query="int-portaria-movto-ppb"
                                   &PageNumber="1"}
    
    {masterdetail/openqueriesson.i &Parent="int-portaria-item"
                                   &Query="int-portaria-movto-prov"
                                   &PageNumber="2"}
                                   
    {masterdetail/openqueriesson.i &Parent="int-portaria-item"
                                   &Query="int-portaria-movto-def"
                                   &PageNumber="3"}
        
    {masterdetail/openqueriesson.i &Parent="int-portaria-item"
                                   &Query="int-portaria-movto-bem"
                                   &PageNumber="4"}

    {masterdetail/openqueriesson.i &Parent="int-portaria-item"
                                   &Query="int-portaria-perc"
                                   &PageNumber="5"}
                                   
    RUN pi-verifica-classificacao.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-classificacao wMasterDetail 
PROCEDURE pi-verifica-classificacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN rs-classificacao = 1.

    FIND FIRST tt-int-portaria-movto-ppb NO-LOCK
         WHERE tt-int-portaria-movto-ppb.it-codigo   = tt-int-portaria-item.it-codigo
           AND tt-int-portaria-movto-ppb.cod-estabel = tt-int-portaria-item.cod-estabel
           AND tt-int-portaria-movto-ppb.seq         = tt-int-portaria-item.seq
           AND tt-int-portaria-movto-ppb.dt-fim      = ? NO-ERROR.
    IF AVAIL tt-int-portaria-movto-ppb THEN ASSIGN rs-classificacao = 1.

    FIND FIRST tt-int-portaria-movto-prov NO-LOCK
         WHERE tt-int-portaria-movto-prov.it-codigo   = tt-int-portaria-item.it-codigo
           AND tt-int-portaria-movto-prov.cod-estabel = tt-int-portaria-item.cod-estabel
           AND tt-int-portaria-movto-prov.seq         = tt-int-portaria-item.seq
           AND tt-int-portaria-movto-prov.dt-fim      = ? NO-ERROR.
    IF AVAIL tt-int-portaria-movto-prov THEN ASSIGN rs-classificacao = 2.

    FIND FIRST tt-int-portaria-movto-def NO-LOCK
         WHERE tt-int-portaria-movto-def.it-codigo   = tt-int-portaria-item.it-codigo
           AND tt-int-portaria-movto-def.cod-estabel = tt-int-portaria-item.cod-estabel
           AND tt-int-portaria-movto-def.seq         = tt-int-portaria-item.seq
           AND tt-int-portaria-movto-def.dt-fim      = ? NO-ERROR.
    IF AVAIL tt-int-portaria-movto-def THEN ASSIGN rs-classificacao = 3.

    FIND FIRST tt-int-portaria-movto-bem NO-LOCK
         WHERE tt-int-portaria-movto-bem.it-codigo   = tt-int-portaria-item.it-codigo
           AND tt-int-portaria-movto-bem.cod-estabel = tt-int-portaria-item.cod-estabel
           AND tt-int-portaria-movto-bem.seq         = tt-int-portaria-item.seq
           AND tt-int-portaria-movto-bem.dt-fim      = ? NO-ERROR.
    IF AVAIL tt-int-portaria-movto-bem THEN ASSIGN rs-classificacao = 4.
    
    DISP rs-classificacao
        WITH FRAME fPage0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

