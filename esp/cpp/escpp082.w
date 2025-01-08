&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-aponta-mqa NO-UNDO LIKE aponta-mqa
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCPP082 1.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCPP082
&GLOBAL-DEFINE Version        1.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp ~
                              btOK btCancel btHelp2 bt-escpp080 bt-escpp077 bt-escpp084 
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE h-boes657     AS HANDLE      NO-UNDO.

def new global shared var v_cod_estab_usuar
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estab"
    no-undo.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.

def new global shared var gr-estabelec as rowid no-undo.

DEFINE NEW GLOBAL SHARED VAR i_cod_prod_escpp077  AS INTEGER NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR c_cod_estab_escpp077 AS CHAR NO-UNDO.

{esp/es0018.i}

DEFINE VARIABLE l-placa   AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-produto AS LOGICAL     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-aponta-mqa.cod-estabel tt-aponta-mqa.data ~
tt-aponta-mqa.nr-linha tt-aponta-mqa.cod-prod tt-aponta-mqa.origem-falha ~
tt-aponta-mqa.id-montagem tt-aponta-mqa.es-codigo ~
tt-aponta-mqa.log-possui-etiq-tec tt-aponta-mqa.observacao 
&Scoped-define ENABLED-TABLES tt-aponta-mqa
&Scoped-define FIRST-ENABLED-TABLE tt-aponta-mqa
&Scoped-Define ENABLED-OBJECTS bt-escpp077 bt-escpp080 bt-escpp084 ~
fi-desc-origem lb-prod-aval btQueryJoins btReportsJoins btExit btHelp ~
fi-desc-linha fi-desc-prod fi-local fi-desc-compon fi-perc-atencao ~
fi-perc-prob fi-abs-atencao fi-abs-prob cb-falha fi-qtd-falha fi-qtd-apont ~
fi-qtd-total btOK btCancel btHelp2 rtToolBar-2 rtToolBar rtKeys RECT-39 ~
RECT-40 rt-status RECT-41 
&Scoped-Define DISPLAYED-FIELDS tt-aponta-mqa.nr-placa-seq ~
tt-aponta-mqa.cod-estabel tt-aponta-mqa.data tt-aponta-mqa.nr-linha ~
tt-aponta-mqa.cod-prod tt-aponta-mqa.origem-falha tt-aponta-mqa.id-montagem ~
tt-aponta-mqa.es-codigo tt-aponta-mqa.log-possui-etiq-tec ~
tt-aponta-mqa.observacao 
&Scoped-define DISPLAYED-TABLES tt-aponta-mqa
&Scoped-define FIRST-DISPLAYED-TABLE tt-aponta-mqa
&Scoped-Define DISPLAYED-OBJECTS fi-desc-origem lb-prod-aval fi-desc-linha ~
fi-desc-prod fi-local fi-desc-compon fi-perc-atencao fi-perc-prob ~
fi-abs-atencao fi-abs-prob cb-falha fi-qtd-falha fi-qtd-apont fi-qtd-total 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
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


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-escpp077 
     IMAGE-UP FILE "IMAGE/toolbar/im-negoc.bmp":U
     LABEL "ESCPP077" 
     SIZE 4 BY 1.25 TOOLTIP "Cadastro de Estrutura - MQA".

DEFINE BUTTON bt-escpp080 
     IMAGE-UP FILE "IMAGE/toolbar/manutencao.bmp":U
     LABEL "ESCPP080" 
     SIZE 4 BY 1.25 TOOLTIP "Manuten‡Æo de ¡ndices de Qualidade - MQA".

DEFINE BUTTON bt-escpp084 
     IMAGE-UP FILE "IMAGE/toolbar/mip-csv.bmp":U
     LABEL "ESCPP084" 
     SIZE 4 BY 1.25 TOOLTIP "Relat¢rio de Apontamentos - MQA".

DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

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

DEFINE VARIABLE cb-falha AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Falha" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "",0
     DROP-DOWN-LIST
     SIZE 47 BY 1 NO-UNDO.

DEFINE VARIABLE fi-abs-atencao AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "Abs. Aten‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-abs-prob AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "Abs. Problema" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-compon AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-linha AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 24 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-origem AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 66 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-prod AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 58 BY .88 NO-UNDO.

DEFINE VARIABLE fi-local AS CHARACTER FORMAT "X(256)":U 
     LABEL "Local" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE fi-perc-atencao AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "% Aten‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-perc-prob AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "% Problema" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-qtd-apont AS DECIMAL FORMAT ">,>>>,>>9.9999":U INITIAL 0 
     LABEL "Qtd Apont" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-qtd-falha AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "Qtd Falha" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .79 NO-UNDO.

DEFINE VARIABLE fi-qtd-total AS DECIMAL FORMAT ">,>>>,>>9.9999":U INITIAL 0 
     LABEL "Qtd Total" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE lb-prod-aval AS CHARACTER FORMAT "X(256)":U INITIAL "Produto em Avalia‡Æo" 
      VIEW-AS TEXT 
     SIZE 16 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-39
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 12.25.

DEFINE RECTANGLE RECT-40
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 70 BY 2.5.

DEFINE RECTANGLE RECT-41
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.67.

DEFINE RECTANGLE rt-status
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 12 BY 1.5.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.21.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-aponta-mqa.nr-placa-seq AT ROW 5.5 COL 9 COLON-ALIGNED WIDGET-ID 84
          LABEL "Nr Placa"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     bt-escpp077 AT ROW 1.13 COL 55 HELP
          "Cadastro de Estrutura - MQA" WIDGET-ID 74
     bt-escpp080 AT ROW 1.13 COL 59 HELP
          "Manuten‡Æo de ¡ndices de Qualidade - MQA" WIDGET-ID 76
     bt-escpp084 AT ROW 1.13 COL 63 HELP
          "Relat¢rio de Apontamentos - MQA" WIDGET-ID 78
     fi-desc-origem AT ROW 7.25 COL 13.43 COLON-ALIGNED NO-LABEL WIDGET-ID 72
     lb-prod-aval AT ROW 3.75 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 68
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     tt-aponta-mqa.cod-estabel AT ROW 2.67 COL 15 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt-aponta-mqa.data AT ROW 2.67 COL 28 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-aponta-mqa.nr-linha AT ROW 2.67 COL 54.72 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     fi-desc-linha AT ROW 2.67 COL 60 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     tt-aponta-mqa.cod-prod AT ROW 4.5 COL 9 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     fi-desc-prod AT ROW 4.5 COL 21.86 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     tt-aponta-mqa.origem-falha AT ROW 7.25 COL 9 COLON-ALIGNED WIDGET-ID 70
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     fi-local AT ROW 8.25 COL 9 COLON-ALIGNED WIDGET-ID 60
     tt-aponta-mqa.id-montagem AT ROW 8.25 COL 59 COLON-ALIGNED WIDGET-ID 80
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     tt-aponta-mqa.es-codigo AT ROW 9.25 COL 9 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     fi-desc-compon AT ROW 9.25 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     fi-perc-atencao AT ROW 10.58 COL 22 COLON-ALIGNED WIDGET-ID 38
     fi-perc-prob AT ROW 10.58 COL 49 COLON-ALIGNED WIDGET-ID 44
     fi-abs-atencao AT ROW 11.58 COL 22 COLON-ALIGNED WIDGET-ID 42
     fi-abs-prob AT ROW 11.58 COL 49 COLON-ALIGNED WIDGET-ID 46
     cb-falha AT ROW 13.08 COL 9 COLON-ALIGNED WIDGET-ID 50
     tt-aponta-mqa.log-possui-etiq-tec AT ROW 13.08 COL 59 WIDGET-ID 82
          LABEL "Possui etiqueta de conserto t‚cnico ?"
          VIEW-AS TOGGLE-BOX
          SIZE 28 BY .83
     fi-qtd-falha AT ROW 14.33 COL 9 COLON-ALIGNED WIDGET-ID 54
     fi-qtd-apont AT ROW 15.33 COL 9 COLON-ALIGNED WIDGET-ID 56
     fi-qtd-total AT ROW 16.33 COL 9 COLON-ALIGNED WIDGET-ID 58
     tt-aponta-mqa.observacao AT ROW 14.33 COL 26 NO-LABEL WIDGET-ID 36
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 55 BY 4.5
     btOK AT ROW 19.67 COL 2
     btCancel AT ROW 19.67 COL 13
     btHelp2 AT ROW 19.67 COL 80
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 19.46 COL 1
     rtKeys AT ROW 2.54 COL 1.14 WIDGET-ID 48
     RECT-39 AT ROW 7 COL 1 WIDGET-ID 28
     RECT-40 AT ROW 10.33 COL 11 WIDGET-ID 34
     rt-status AT ROW 10.83 COL 66 WIDGET-ID 52
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.29 BY 19.92
         FONT 1 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fpage0
     RECT-41 AT ROW 4.08 COL 1.14 WIDGET-ID 64
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.29 BY 19.92
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-aponta-mqa T "?" NO-UNDO mgesp aponta-mqa
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 19.92
         WIDTH              = 90.29
         MAX-HEIGHT         = 39.83
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 39.83
         VIRTUAL-WIDTH      = 195.14
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
/* SETTINGS FOR TOGGLE-BOX tt-aponta-mqa.log-possui-etiq-tec IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-aponta-mqa.nr-placa-seq IN FRAME fpage0
   NO-ENABLE EXP-LABEL                                                  */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

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


&Scoped-define SELF-NAME bt-escpp077
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-escpp077 wWindow
ON CHOOSE OF bt-escpp077 IN FRAME fpage0 /* ESCPP077 */
DO:
    ASSIGN i_cod_prod_escpp077 = INPUT FRAME fpage0 tt-aponta-mqa.cod-prod
           c_cod_estab_escpp077 = INPUT FRAME fpage0 tt-aponta-mqa.cod-estabel.
    RUN esp/cpp/escpp077.w.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-escpp080
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-escpp080 wWindow
ON CHOOSE OF bt-escpp080 IN FRAME fpage0 /* ESCPP080 */
DO:
    RUN esp/cpp/escpp080.w.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-escpp084
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-escpp084 wWindow
ON CHOOSE OF bt-escpp084 IN FRAME fpage0 /* ESCPP084 */
DO:
    RUN esp/cpp/escpp084.w.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
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


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:

    DEFINE VARIABLE i-seq AS INTEGER     NO-UNDO.

    IF AVAIL tt-aponta-mqa THEN DO:
        
        RUN pi-salvar.

        IF RETURN-VALUE = "NOK" THEN
            RETURN NO-APPLY.
    END.

    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 27100,
                       INPUT "Deseja continuar os apontamentos na mesma Placa ?").

    IF RETURN-VALUE = "YES" THEN
        ASSIGN l-placa   = YES
               l-produto = NO.
    ELSE DO:
        ASSIGN l-placa = NO.

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 27100,
                           INPUT "Deseja continuar apontando no mesmo Produto ?").

        IF RETURN-VALUE = "YES" THEN
            ASSIGN l-produto = YES.
        ELSE
            ASSIGN l-produto = NO.
    END.    
    
    IF (l-placa OR l-produto) THEN
        RUN pi-limpa (INPUT YES).
    ELSE
        RUN pi-limpa (INPUT NO).    

    IF l-produto THEN DO:
        ASSIGN INPUT FRAME fpage0
            tt-aponta-mqa.cod-estabel
            tt-aponta-mqa.data
            tt-aponta-mqa.cod-prod.

        RUN buscaUltimaPlaca IN h-boes657 (INPUT tt-aponta-mqa.cod-estabel,
                                           INPUT tt-aponta-mqa.data,
                                           INPUT tt-aponta-mqa.cod-prod,
                                           OUTPUT i-seq).

        ASSIGN tt-aponta-mqa.nr-placa-seq:SCREEN-VALUE IN FRAME fpage0 = string(i-seq).
    END.

    IF l-placa THEN DO:
        ASSIGN tt-aponta-mqa.log-possui-etiq-tec:SENSITIVE IN FRAME fpage0 = NO
               tt-aponta-mqa.cod-prod           :SENSITIVE IN FRAME fpage0 = NO
               tt-aponta-mqa.data               :SENSITIVE IN FRAME fpage0 = NO.

        APPLY "entry" TO tt-aponta-mqa.origem-falha IN FRAME fPage0.
    END.
    ELSE DO:
        ASSIGN tt-aponta-mqa.log-possui-etiq-tec:SENSITIVE IN FRAME fpage0 = YES
               tt-aponta-mqa.cod-prod           :SENSITIVE IN FRAME fpage0 = YES
               tt-aponta-mqa.data               :SENSITIVE IN FRAME fpage0 = YES.

        IF l-produto THEN
            APPLY "entry" TO tt-aponta-mqa.origem-falha IN FRAME fPage0.
        ELSE
            APPLY "entry" TO tt-aponta-mqa.cod-prod IN FRAME fPage0.
    END.
    

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


&Scoped-define SELF-NAME cb-falha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-falha wWindow
ON VALUE-CHANGED OF cb-falha IN FRAME fpage0 /* Falha */
DO:

    RUN pi-carrega-apontamentos.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-aponta-mqa.cod-prod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aponta-mqa.cod-prod wWindow
ON F5 OF tt-aponta-mqa.cod-prod IN FRAME fpage0 /* Produto */
DO:

    {method/ZoomFields.i &ProgramZoom="eszoom/z01es652.w"
                         &FieldZoom1="cod-prod"
                         &FieldScreen1="tt-aponta-mqa.cod-prod"
                         &Frame1="fPage0"
                         &FieldZoom2="descricao"
                         &FieldScreen2="fi-desc-prod"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aponta-mqa.cod-prod wWindow
ON LEAVE OF tt-aponta-mqa.cod-prod IN FRAME fpage0 /* Produto */
DO:
    DEFINE VARIABLE i-seq AS INTEGER     NO-UNDO.

    /*RUN pi-carrega-local.*/

    FOR FIRST item-mqa NO-LOCK
        WHERE item-mqa.cod-prod = INPUT FRAME fPage0 tt-aponta-mqa.cod-prod
          AND item-mqa.cod-estabel = INPUT FRAME fPage0 tt-aponta-mqa.cod-estabel:

        ASSIGN fi-desc-prod:SCREEN-VALUE IN FRAME fPage0 = item-mqa.descricao.
    END.
    IF NOT AVAIL item-mqa THEN DO:
        ASSIGN fi-desc-prod:SCREEN-VALUE IN FRAME fPage0 = "".
    END.

    RUN pi-carrega-apontamentos.

    IF NOT l-placa THEN DO:

        ASSIGN INPUT FRAME fpage0
            tt-aponta-mqa.cod-estabel
            tt-aponta-mqa.data
            tt-aponta-mqa.cod-prod.

        RUN buscaUltimaPlaca IN h-boes657 (INPUT tt-aponta-mqa.cod-estabel,
                                           INPUT tt-aponta-mqa.data,
                                           INPUT tt-aponta-mqa.cod-prod,
                                           OUTPUT i-seq).

        ASSIGN tt-aponta-mqa.nr-placa-seq:SCREEN-VALUE IN FRAME fpage0 = string(i-seq).
    END.        
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aponta-mqa.cod-prod wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-aponta-mqa.cod-prod IN FRAME fpage0 /* Produto */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-aponta-mqa.data
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aponta-mqa.data wWindow
ON LEAVE OF tt-aponta-mqa.data IN FRAME fpage0 /* Data */
DO:

    RUN pi-carrega-apontamentos.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-aponta-mqa.es-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aponta-mqa.es-codigo wWindow
ON F5 OF tt-aponta-mqa.es-codigo IN FRAME fpage0 /* Componente */
DO:

    {method/ZoomFields.i &ProgramZoom="inzoom/z20in172.w"
                         &FieldZoom1="it-codigo"
                         &FieldScreen1="tt-aponta-mqa.es-codigo"
                         &Frame1="fPage0"
                         &FieldZoom2="desc-item"
                         &FieldScreen2="fi-desc-compon"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aponta-mqa.es-codigo wWindow
ON LEAVE OF tt-aponta-mqa.es-codigo IN FRAME fpage0 /* Componente */
DO:

    ASSIGN fi-desc-compon:SCREEN-VALUE IN FRAME fPage0 = "".

    FOR FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = INPUT FRAME fPage0 tt-aponta-mqa.es-codigo:

        ASSIGN fi-desc-compon:SCREEN-VALUE IN FRAME fPage0 = ITEM.desc-item.
    END.
    IF NOT AVAIL ITEM THEN
        ASSIGN fi-desc-compon:SCREEN-VALUE IN FRAME fPage0 = "".

    RUN pi-carrega-falha.

    IF RETURN-VALUE = "NOK" THEN
        RETURN.

    RUN pi-carrega-indices.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aponta-mqa.es-codigo wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-aponta-mqa.es-codigo IN FRAME fpage0 /* Componente */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-local
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-local wWindow
ON F5 OF fi-local IN FRAME fpage0 /* Local */
DO:

    {method/ZoomFields.i &ProgramZoom="eszoom/z01es653.w"
                         &FieldZoom1="local-montag"
                         &FieldScreen1="fi-local"
                         &Frame1="fPage0"
                         &RunMethod="RUN setaVariable IN hProgramZoom (INPUT INPUT FRAME fPage0 tt-aponta-mqa.cod-prod)."
                         &EnableImplant="NO"}

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-local wWindow
ON LEAVE OF fi-local IN FRAME fpage0 /* Local */
DO:

    FOR FIRST estrutura-mqa NO-LOCK
        WHERE estrutura-mqa.cod-prod     = INPUT FRAME fpage0 tt-aponta-mqa.cod-prod
        AND   estrutura-mqa.local-montag = fi-local:SCREEN-VALUE IN FRAME fPage0
        AND   estrutura-mqa.cod-estabel  = tt-aponta-mqa.cod-estabel:SCREEN-VALUE IN FRAME fPage0:
        
        ASSIGN tt-aponta-mqa.es-codigo:SCREEN-VALUE IN FRAME fPage0 = estrutura-mqa.es-codigo.
    END.
    IF NOT AVAIL estrutura-mqa THEN
        ASSIGN tt-aponta-mqa.es-codigo:SCREEN-VALUE IN FRAME fPage0 = "".

    APPLY "leave" TO tt-aponta-mqa.es-codigo IN FRAME fPage0.

    RUN pi-carrega-apontamentos.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-local wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-local IN FRAME fpage0 /* Local */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-qtd-falha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-qtd-falha wWindow
ON LEAVE OF fi-qtd-falha IN FRAME fpage0 /* Qtd Falha */
DO:

    RUN pi-valida-quantidade.
  
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


&Scoped-define SELF-NAME tt-aponta-mqa.nr-linha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aponta-mqa.nr-linha wWindow
ON F5 OF tt-aponta-mqa.nr-linha IN FRAME fpage0 /* Linha Produ‡Æo */
DO:

    /*
    {method/ZoomFields.i &ProgramZoom="inzoom/z03in186.w"
                         &FieldZoom1="nr-linha"
                         &FieldScreen1="tt-aponta-mqa.nr-linha"
                         &Frame1="fPage0"
                         &FieldZoom2="descricao"
                         &FieldScreen2="fi-desc-linha"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}
                         */

    {include/zoomvar.i &prog-zoom="inzoom/z01in186.w"
                       &campo="tt-aponta-mqa.nr-linha"
                       &campozoom="nr-linha"
                       &frame="fPage0"
                       &campo2="fi-desc-linha"
                       &campozoom2="descricao"
                       &frame2="fPage0"}

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aponta-mqa.nr-linha wWindow
ON LEAVE OF tt-aponta-mqa.nr-linha IN FRAME fpage0 /* Linha Produ‡Æo */
DO:    

    FOR FIRST lin-prod NO-LOCK
        WHERE lin-prod.nr-linha = INPUT FRAME fPage0 tt-aponta-mqa.nr-linha:

        ASSIGN fi-desc-linha:SCREEN-VALUE IN FRAME fPage0 = lin-prod.descricao.
    END.
    IF NOT AVAIL lin-prod THEN
        ASSIGN fi-desc-linha:SCREEN-VALUE IN FRAME fPage0 = "".

    APPLY "entry" TO tt-aponta-mqa.cod-prod IN FRAME fPage0.

    RETURN NO-APPLY.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aponta-mqa.nr-linha wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-aponta-mqa.nr-linha IN FRAME fpage0 /* Linha Produ‡Æo */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-aponta-mqa.origem-falha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aponta-mqa.origem-falha wWindow
ON F5 OF tt-aponta-mqa.origem-falha IN FRAME fpage0 /* Origem */
DO:

    {method/ZoomFields.i &ProgramZoom="eszoom/z01es659.w"
                         &FieldZoom1="origem-falha"
                         &FieldScreen1="tt-aponta-mqa.origem-falha"
                         &Frame1="fPage0"
                         &FieldZoom2="descricao"
                         &FieldScreen2="fi-desc-origem"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aponta-mqa.origem-falha wWindow
ON LEAVE OF tt-aponta-mqa.origem-falha IN FRAME fpage0 /* Origem */
DO:

    ASSIGN fi-desc-origem:SCREEN-VALUE IN FRAME fPage0 = "".

    FOR FIRST origem-mqa NO-LOCK
        WHERE origem-mqa.origem-falha = INPUT FRAME fPage0 tt-aponta-mqa.origem-falha:

        ASSIGN fi-desc-origem:SCREEN-VALUE IN FRAME fPage0 = origem-mqa.descricao.

    END.
    IF NOT AVAIL origem-mqa THEN
        ASSIGN fi-desc-origem:SCREEN-VALUE IN FRAME fPage0 = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-aponta-mqa.origem-falha wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-aponta-mqa.origem-falha IN FRAME fpage0 /* Origem */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

tt-aponta-mqa.nr-linha:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-aponta-mqa.cod-prod:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-aponta-mqa.origem-falha:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
fi-local:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDestroyInterface wWindow 
PROCEDURE AfterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE(h-boes657) THEN
        RUN destroy IN h-boes657.

    ASSIGN h-boes657 = ?.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wWindow 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN esbo/boes657.p PERSISTENT SET h-boes657.

    RUN openQueryStatic IN h-boes657 (INPUT "Main").

    RUN emptyRowObject IN h-boes657.

    RUN emptyRowErrors IN h-boes657.

    CREATE tt-aponta-mqa.

    DO WITH FRAME fPage0:

        ASSIGN lb-prod-aval:SCREEN-VALUE = "Produto em Avalia‡Æo".
    
        DISP tt-aponta-mqa.cod-estabel 
             tt-aponta-mqa.data
             tt-aponta-mqa.nr-linha
             tt-aponta-mqa.cod-prod
             tt-aponta-mqa.origem-falha
             lb-prod-aval
             tt-aponta-mqa.es-codigo
             tt-aponta-mqa.observacao
             fi-perc-atencao
             fi-perc-prob
             fi-abs-atencao
             fi-abs-prob
             fi-qtd-falha
             fi-qtd-apont
             fi-qtd-total
             tt-aponta-mqa.id-montagem
             tt-aponta-mqa.log-possui-etiq-tec.

        ENABLE ALL.

        ASSIGN tt-aponta-mqa.cod-estabel:SENSITIVE = FALSE
               fi-desc-linha:SENSITIVE = FALSE
               fi-desc-prod:SENSITIVE = FALSE
               fi-desc-origem:SENSITIVE = FALSE
               tt-aponta-mqa.es-codigo:SENSITIVE = FALSE
               fi-desc-compon:SENSITIVE = FALSE
               fi-perc-atencao:SENSITIVE = FALSE
               fi-abs-atencao:SENSITIVE = FALSE
               fi-perc-prob:SENSITIVE = FALSE
               fi-abs-prob:SENSITIVE = FALSE
               fi-qtd-apont:SENSITIVE = FALSE
               fi-qtd-total:SENSITIVE = FALSE
               tt-aponta-mqa.nr-placa-seq:SENSITIVE = FALSE.

        ASSIGN tt-aponta-mqa.cod-estabel:SCREEN-VALUE = v_cod_estab_usuar
               tt-aponta-mqa.data:SCREEN-VALUE = STRING(TODAY).

        FOR FIRST estabelec NO-LOCK
            WHERE estabelec.cod-estabel = v_cod_estab_usuar:

            ASSIGN gr-estabelec = ROWID(estabelec).

        END.
        
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-apontamentos wWindow 
PROCEDURE pi-carrega-apontamentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE d-qtd-apont AS DECIMAL     NO-UNDO.    

    DO WITH FRAME fPage0:

        ASSIGN d-qtd-apont = 0.

        ASSIGN INPUT 
            tt-aponta-mqa.cod-estabel
            tt-aponta-mqa.data
            tt-aponta-mqa.cod-prod
            tt-aponta-mqa.origem-falha
            fi-local
            cb-falha.           
        
        RUN calcularTotalApontamentos IN h-boes657 (INPUT tt-aponta-mqa.cod-estabel,
                                                    INPUT tt-aponta-mqa.data,
                                                    INPUT tt-aponta-mqa.cod-prod,
                                                    INPUT tt-aponta-mqa.origem-falha,
                                                    INPUT fi-local,
                                                    INPUT cb-falha,
                                                    OUTPUT d-qtd-apont).
                                                    
        ASSIGN fi-qtd-apont:SCREEN-VALUE = string(d-qtd-apont).

        APPLY "LEAVE" TO fi-qtd-falha.
    END.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-falha wWindow 
PROCEDURE pi-carrega-falha :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-LIP-falha AS CHARACTER   NO-UNDO.


    ASSIGN c-LIP-falha = "".    
    
    FOR EACH  item-falha NO-LOCK
        WHERE item-falha.it-codigo  = string(INPUT FRAME fpage0 tt-aponta-mqa.origem-falha):

        FOR FIRST falha-mqa NO-LOCK
            WHERE falha-mqa.cod-falha = item-falha.cod-falha:            

            ASSIGN c-LIP-falha = c-LIP-falha + falha-mqa.descricao + ',' + string(falha-mqa.cod-falha) + ','.
        END.
    END.    
   
    IF LENGTH(c-LIP-falha) > 0 THEN 
        ASSIGN c-LIP-falha = SUBSTRING(c-LIP-falha,1,LENGTH(c-LIP-falha) - 1)
               cb-falha:LIST-ITEM-PAIRS IN FRAME fPage0 = c-LIP-falha.
    ELSE DO:

        ASSIGN c-LIP-falha = ",0"
               cb-falha:LIST-ITEM-PAIRS IN FRAME fPage0 = c-LIP-falha.

        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Origem nÆo possui cadastro de falha. NÆo pode ser apontado.~~Solicitar o cadastro para Engenharia Industrial.").

        APPLY "entry" TO tt-aponta-mqa.origem-falha IN FRAME fPage0.

        RETURN "NOK":U.

    END.


    RETURN "OK":U.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-indices wWindow 
PROCEDURE pi-carrega-indices :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR FIRST indice-qualid NO-LOCK
        WHERE indice-qualid.cod-estabel = INPUT FRAME fPage0 tt-aponta-mqa.cod-estabel
        AND   indice-qualid.it-codigo   = INPUT FRAME fPage0 tt-aponta-mqa.es-codigo:

        DO WITH FRAME fPage0:

            ASSIGN fi-perc-atencao:SCREEN-VALUE = STRING(indice-qualid.relat-atencao)
                   fi-perc-prob:SCREEN-VALUE    = STRING(indice-qualid.relat-prob)
                   fi-abs-atencao:SCREEN-VALUE  = STRING(indice-qualid.absol-atencao)
                   fi-abs-prob:SCREEN-VALUE     = STRING(indice-qualid.absol-problema).

        END.

    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-local wWindow 
PROCEDURE pi-carrega-local :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-LIP-local AS CHARACTER   NO-UNDO.


    ASSIGN c-LIP-local = "".

    FOR FIRST item-mqa NO-LOCK
        WHERE item-mqa.cod-prod = INPUT FRAME fPage0 tt-aponta-mqa.cod-prod
          AND item-mqa.cod-estabel = INPUT FRAME fPage0 tt-aponta-mqa.cod-estabel:

        FOR EACH estrutura-mqa NO-LOCK
            WHERE estrutura-mqa.cod-prod = item-mqa.cod-prod
              AND estrutura-mqa.cod-estabel = item-mqa.cod-estabel:

            ASSIGN c-LIP-local = c-LIP-local + estrutura-mqa.local-monta + ",".

        END.

    END.

    IF LENGTH(c-LIP-local) > 0 THEN 
        ASSIGN c-LIP-local = SUBSTRING(c-LIP-local,1,LENGTH(c-LIP-local) - 1)
               fi-local:LIST-ITEMS IN FRAME fPage0 = c-LIP-local.


    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-limpa wWindow 
PROCEDURE pi-limpa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-congela AS LOGICAL NO-UNDO.

    RUN emptyRowObject IN h-boes657.

    RUN emptyRowErrors IN h-boes657.

    DO WITH FRAME fPage0:
        IF p-congela THEN DO:
            
            IF l-produto THEN
                ASSIGN tt-aponta-mqa.nr-placa-seq:SCREEN-VALUE = ""
                       tt-aponta-mqa.log-possui-etiq-tec:CHECKED = NO.
        END.
        ELSE DO:
            ASSIGN tt-aponta-mqa.cod-prod    :SCREEN-VALUE = ""
                   fi-desc-prod              :SCREEN-VALUE = ""
                   tt-aponta-mqa.nr-placa-seq:SCREEN-VALUE = ""
                   tt-aponta-mqa.log-possui-etiq-tec:CHECKED = NO.
        END.

        ASSIGN tt-aponta-mqa.origem-falha:SCREEN-VALUE = "0"
               fi-desc-origem:SCREEN-VALUE = ""
               tt-aponta-mqa.es-codigo:SCREEN-VALUE = ""
               fi-desc-compon:SCREEN-VALUE = ""
               fi-perc-atencao:SCREEN-VALUE = STRING(0)
               fi-perc-prob:SCREEN-VALUE = STRING(0)
               fi-abs-atencao:SCREEN-VALUE = STRING(0)
               fi-abs-prob:SCREEN-VALUE = STRING(0)
               fi-qtd-falha:SCREEN-VALUE = STRING(0)
               fi-qtd-apont:SCREEN-VALUE = STRING(0)
               fi-qtd-total:SCREEN-VALUE = STRING(0)
               tt-aponta-mqa.observacao:SCREEN-VALUE = ""
               tt-aponta-mqa.id-montagem:SCREEN-VALUE = "".

        ASSIGN rt-status:FILLED = FALSE.

        ASSIGN fi-local:SCREEN-VALUE = "".

        ASSIGN cb-falha:LIST-ITEM-PAIRS = ",0".

    END.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salvar wWindow 
PROCEDURE pi-salvar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN emptyRowErrors IN h-boes657.

    RUN pi-carrega-apontamentos.
    
    DO WITH FRAME fPage0:        

        ASSIGN INPUT 
               tt-aponta-mqa.cod-prod   
               tt-aponta-mqa.cod-estabel
               tt-aponta-mqa.data
               tt-aponta-mqa.nr-linha
               tt-aponta-mqa.origem-falha
               tt-aponta-mqa.es-codigo 
               tt-aponta-mqa.observacao
               tt-aponta-mqa.nr-placa-seq
               tt-aponta-mqa.id-montagem
               tt-aponta-mqa.log-possui-etiq-tec.

        ASSIGN tt-aponta-mqa.local-montag = INPUT fi-local
               tt-aponta-mqa.cod-falha    = INPUT cb-falha
               tt-aponta-mqa.qtd-falha    = INPUT fi-qtd-falha
               tt-aponta-mqa.dt-registro  = TODAY.

    END.           
    

    RUN buscaUltimaSeq IN h-boes657 (INPUT tt-aponta-mqa.cod-estabel,
                                     INPUT tt-aponta-mqa.data,
                                     INPUT tt-aponta-mqa.cod-prod,
                                     INPUT tt-aponta-mqa.local-montag,
                                     INPUT tt-aponta-mqa.cod-falha,
                                     OUTPUT tt-aponta-mqa.sequencia).

    ASSIGN tt-aponta-mqa.cod-usuario = v_cod_usuar_corren.           

    RUN setRecord IN h-boes657 (INPUT TABLE tt-aponta-mqa).

    RUN createRecord IN h-boes657.

    IF RETURN-VALUE <> "OK":U THEN DO:

        RUN getRowErrors IN h-boes657 (OUTPUT TABLE RowErrors).
            
        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorNumber <> 3 AND
                                          RowErrors.ErrorNumber <> 8 AND
                                          RowErrors.ErrorNumber <> 10 AND
                                          RowErrors.ErrorSubType = "ERROR":U) THEN DO:
           {method/showmessage.i1}
           {method/showmessage.i2}
           
           &IF "{&Modal}":U = "":U &THEN
               WAIT-FOR CLOSE OF hShowMsg.
           &ENDIF

           {method/showmessage.i3}            
            RETURN "NOK":U.
        END.
    END.      
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-quantidade wWindow 
PROCEDURE pi-valida-quantidade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE d-qtd-corte-indice AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE d-fator AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE d-problema AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE d-atencao AS DECIMAL     NO-UNDO.

    DEFINE VARIABLE p-cor AS INTEGER     NO-UNDO.
    

    ASSIGN rt-status:FILLED IN FRAME fpage0 = FALSE.    

    DO WITH FRAME fPage0:        

        ASSIGN fi-qtd-total:SCREEN-VALUE = STRING(INPUT fi-qtd-falha + INPUT fi-qtd-apont).

        ASSIGN INPUT
            tt-aponta-mqa.cod-estabel
            tt-aponta-mqa.data
            tt-aponta-mqa.cod-prod
            tt-aponta-mqa.origem-falha
            fi-local
            tt-aponta-mqa.es-codigo
            cb-falha
            fi-qtd-falha.
    END.
     
    RUN calcularMQA IN h-boes657 (INPUT tt-aponta-mqa.cod-estabel,
                                  INPUT tt-aponta-mqa.data,
                                  INPUT tt-aponta-mqa.cod-prod,
                                  INPUT tt-aponta-mqa.origem-falha,
                                  INPUT fi-local,
                                  INPUT tt-aponta-mqa.es-codigo,
                                  INPUT cb-falha,
                                  INPUT fi-qtd-falha,
                                  OUTPUT p-cor).

    IF p-cor > 0 THEN
        ASSIGN rt-status:FILLED  = TRUE
               rt-status:BGCOLOR = p-cor.                         

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

