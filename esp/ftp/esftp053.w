&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-int-nota-conhec NO-UNDO LIKE int-nota-conhec
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESFTP053 2.04.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESFTP053
&GLOBAL-DEFINE Version        2.04.00.000

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    0

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            YES
&GLOBAL-DEFINE Copy           YES
&GLOBAL-DEFINE Update         yes
&GLOBAL-DEFINE Delete         YES
&GLOBAL-DEFINE Undo           YES
&GLOBAL-DEFINE Cancel         YES
&GLOBAL-DEFINE Save           YES

&GLOBAL-DEFINE ttTable        tt-int-nota-conhec
&GLOBAL-DEFINE hDBOTable      h-boes434
&GLOBAL-DEFINE DBOTable       int-nota-conhec

&GLOBAL-DEFINE page0KeyFields tt-int-nota-conhec.cod-estabel tt-int-nota-conhec.serie tt-int-nota-conhec.nr-nota-fis tt-int-nota-conhec.nr-volume tt-int-nota-conhec.nr-conhec 
&GLOBAL-DEFINE page0Fields    tt-int-nota-conhec.centro-custo-frete tt-int-nota-conhec.peso-bruto tt-int-nota-conhec.largura tt-int-nota-conhec.altura tt-int-nota-conhec.comprimento 



/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE hWebService     AS HANDLE   NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

DEFINE VARIABLE v-cod-cc-frete AS CHARACTER   NO-UNDO.

DEFINE VARIABLE i-cont-aux      AS INTEGER                  NO-UNDO.

{utp/utapi019.i}
{esapi/esapi010tt.i}
    
{esp/es0006a.i}
{esp/es0006.i}
{cdp/cd0666.i}
{upc/btb910za-upc.i}
{esp/es0018.i}
{btb/btb912zb.i}
{utp/ut-glob.i}

DEFINE stream arq-email.

DEF BUFFER bf_nota-fiscal FOR nota-fiscal.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-int-nota-conhec.cod-estabel ~
tt-int-nota-conhec.serie tt-int-nota-conhec.nr-nota-fis ~
tt-int-nota-conhec.nr-volume tt-int-nota-conhec.nr-conhec ~
tt-int-nota-conhec.peso-bruto tt-int-nota-conhec.centro-custo-frete ~
tt-int-nota-conhec.largura tt-int-nota-conhec.altura ~
tt-int-nota-conhec.comprimento 
&Scoped-define ENABLED-TABLES tt-int-nota-conhec
&Scoped-define FIRST-ENABLED-TABLE tt-int-nota-conhec
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-11 RECT-12 btFirst btPrev ~
btNext btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo ~
btCancel btSave btCancelCorreios btQueryJoins btReportsJoins btExit btHelp ~
BUTTON-1 c-chave fi-desc-estabel 
&Scoped-Define DISPLAYED-FIELDS tt-int-nota-conhec.cod-estabel ~
tt-int-nota-conhec.serie tt-int-nota-conhec.nr-nota-fis ~
tt-int-nota-conhec.nr-volume tt-int-nota-conhec.nr-conhec ~
tt-int-nota-conhec.peso-bruto tt-int-nota-conhec.centro-custo-frete ~
tt-int-nota-conhec.nr-cartao tt-int-nota-conhec.largura ~
tt-int-nota-conhec.altura tt-int-nota-conhec.comprimento 
&Scoped-define DISPLAYED-TABLES tt-int-nota-conhec
&Scoped-define FIRST-DISPLAYED-TABLE tt-int-nota-conhec
&Scoped-Define DISPLAYED-OBJECTS c-chave fi-desc-estabel v-des-cc-frete 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

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
       MENU-ITEM miUndo         LABEL "&Desfazer"      ACCELERATOR "CTRL-U"
       MENU-ITEM miCancel       LABEL "&Cancelar"      ACCELERATOR "CTRL-F4"
       RULE
       MENU-ITEM miSave         LABEL "&Salvar"        ACCELERATOR "CTRL-S"
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

DEFINE BUTTON btCancel 
     IMAGE-UP FILE "image\im-can":U
     IMAGE-INSENSITIVE FILE "image\im-can":U
     LABEL "Cancel" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCancelCorreios 
     IMAGE-UP FILE "adeicon/del-au.bmp":U
     IMAGE-DOWN FILE "adeicon/del-ad.bmp":U
     IMAGE-INSENSITIVE FILE "adeicon/del-ai.bmp":U
     LABEL "Cancelamento Correios" 
     SIZE 4 BY 1.25 TOOLTIP "Cancelamento Correios".

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

DEFINE BUTTON btUndo 
     IMAGE-UP FILE "image\im-undo":U
     IMAGE-INSENSITIVE FILE "image\ii-undo":U
     LABEL "Undo" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image\im-mod":U
     IMAGE-INSENSITIVE FILE "image\ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "adeicon/check.bmp":U
     LABEL "Button 1" 
     SIZE 6 BY 2 TOOLTIP "Localizar nota fiscal a partir do DANFE informado".

DEFINE VARIABLE c-chave AS CHARACTER FORMAT "X(256)":U 
     LABEL "Chave acesso NFe" 
     VIEW-AS FILL-IN 
     SIZE 66 BY .79 NO-UNDO.

DEFINE VARIABLE fi-desc-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 61 BY .88 NO-UNDO.

DEFINE VARIABLE v-des-cc-frete AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 51.29 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 2.5.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 9.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 92 BY 1.5
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
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
     btUndo AT ROW 1.13 COL 47 HELP
          "Desfaz alteraá‰es"
     btCancel AT ROW 1.13 COL 51 HELP
          "Cancela alteraá‰es"
     btSave AT ROW 1.13 COL 55 HELP
          "Confirma alteraá‰es"
     btCancelCorreios AT ROW 1.13 COL 72.14 WIDGET-ID 104
     btQueryJoins AT ROW 1.13 COL 76.29 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 80.29 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 84.29 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 88.29 HELP
          "Ajuda"
     BUTTON-1 AT ROW 3.21 COL 86.43 WIDGET-ID 86
     c-chave AT ROW 3.25 COL 18 COLON-ALIGNED WIDGET-ID 84
     tt-int-nota-conhec.cod-estabel AT ROW 4.25 COL 18 COLON-ALIGNED WIDGET-ID 74
          LABEL "Estabelecimento"
          VIEW-AS FILL-IN 
          SIZE 4.72 BY .88
     fi-desc-estabel AT ROW 4.25 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     tt-int-nota-conhec.serie AT ROW 5.25 COL 18 COLON-ALIGNED WIDGET-ID 76
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-int-nota-conhec.nr-nota-fis AT ROW 6.25 COL 18 COLON-ALIGNED WIDGET-ID 62
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-int-nota-conhec.nr-volume AT ROW 7.25 COL 18 COLON-ALIGNED WIDGET-ID 80
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .79
     tt-int-nota-conhec.nr-conhec AT ROW 8.25 COL 18 COLON-ALIGNED WIDGET-ID 64
          LABEL "Nr Objeto" FORMAT "x(16)"
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     tt-int-nota-conhec.peso-bruto AT ROW 9.25 COL 18 COLON-ALIGNED WIDGET-ID 82
          LABEL "Peso Bruto (kg)"
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
          BGCOLOR 14 
     tt-int-nota-conhec.centro-custo-frete AT ROW 10.25 COL 18 COLON-ALIGNED WIDGET-ID 98
          LABEL "C.C. Frete" FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
          BGCOLOR 14 
     v-des-cc-frete AT ROW 10.25 COL 27.72 COLON-ALIGNED NO-LABEL WIDGET-ID 100
     tt-int-nota-conhec.nr-cartao AT ROW 11.25 COL 18 COLON-ALIGNED WIDGET-ID 78
          LABEL "Cart∆o"
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     tt-int-nota-conhec.largura AT ROW 13.75 COL 17 COLON-ALIGNED WIDGET-ID 88
          VIEW-AS FILL-IN 
          SIZE 17 BY .79
     tt-int-nota-conhec.altura AT ROW 13.75 COL 42 COLON-ALIGNED WIDGET-ID 90
          VIEW-AS FILL-IN 
          SIZE 17 BY .79
     tt-int-nota-conhec.comprimento AT ROW 13.75 COL 70 COLON-ALIGNED WIDGET-ID 92
          VIEW-AS FILL-IN 
          SIZE 17 BY .79
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 92.14 BY 15.04
         FONT 1 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fpage0
     " Dimens‰es da Caixa" VIEW-AS TEXT
          SIZE 16 BY 1 AT ROW 12.54 COL 8 WIDGET-ID 96
     rtToolBar AT ROW 1 COL 1
     RECT-11 AT ROW 13 COL 6 WIDGET-ID 94
     RECT-12 AT ROW 3 COL 6 WIDGET-ID 102
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 92.14 BY 15.04
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-int-nota-conhec T "?" NO-UNDO mgesp int-nota-conhec
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenance ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 15.17
         WIDTH              = 92.57
         MAX-HEIGHT         = 30.71
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 30.71
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenance 
/* ************************* Included-Libraries *********************** */

{maintenance/maintenance.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenance
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN tt-int-nota-conhec.centro-custo-frete IN FRAME fpage0
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN tt-int-nota-conhec.cod-estabel IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-int-nota-conhec.nr-cartao IN FRAME fpage0
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN tt-int-nota-conhec.nr-conhec IN FRAME fpage0
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN tt-int-nota-conhec.peso-bruto IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN v-des-cc-frete IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

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

&Scoped-define SELF-NAME wMaintenance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON END-ERROR OF wMaintenance
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON WINDOW-CLOSE OF wMaintenance
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMaintenance
ON CHOOSE OF btAdd IN FRAME fpage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd in MENU mbMain DO:
    RUN addRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenance
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:
    RUN cancelRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancelCorreios
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancelCorreios wMaintenance
ON CHOOSE OF btCancelCorreios IN FRAME fpage0 /* Cancelamento Correios */
DO:
  
    DEFINE VARIABLE iStatus   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cStatus   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cXMLin    AS LONGCHAR    NO-UNDO.
    DEFINE VARIABLE cXMLout   AS LONGCHAR    NO-UNDO.
    
    /* SIGEP WEB */
    /* Envia, via webservice, a lista de objetos que ser∆o postados e recebe a lista de objetos atualizados */
    /** Execuá∆o do WS para atualizar inforamá‰es na Ikeda **/
    run esp/ftp/esftp024-ws.p persistent set hWebService.
    run conectaLogReversa in hWebService (output iStatus, output cStatus).
    
    IF iStatus = 1 THEN DO:
    
        FIND FIRST int-nota-conhec
            WHERE int-nota-conhec.cod-estabel = INPUT FRAME fPage0 tt-int-nota-conhec.cod-estabel
              AND int-nota-conhec.serie       = INPUT FRAME fPage0 tt-int-nota-conhec.serie      
              AND int-nota-conhec.nr-nota-fis = INPUT FRAME fPage0 tt-int-nota-conhec.nr-nota-fis
              AND int-nota-conhec.nr-volume   = INPUT FRAME fPage0 tt-int-nota-conhec.nr-volume  
              AND int-nota-conhec.nr-conhec   = INPUT FRAME fPage0 tt-int-nota-conhec.nr-conhec  NO-LOCK NO-ERROR.
        IF AVAIL int-nota-conhec THEN DO:
            RUN cancelarPedidoParam in hWebService (INPUT ROWID(int-nota-conhec),
                                                    OUTPUT iStatus,
                                                    OUTPUT cStatus).

        END. /* IF AVAIL int-nota-conhec THEN DO: */
              
        IF iStatus <> 1 THEN DO:
            /* Mensagem de Erro */
        END.
    
    END.
    ELSE DO:
        /* Mensagem de Erro */
    END.
    
    IF VALID-HANDLE(hWebService) THEN DO:
        run desconecta in hWebService.
        delete object hWebService.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMaintenance
ON CHOOSE OF btCopy IN FRAME fpage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
    RUN copyRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMaintenance
ON CHOOSE OF btDelete IN FRAME fpage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
    RUN deleteRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMaintenance
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMaintenance
ON CHOOSE OF btFirst IN FRAME fpage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMaintenance
ON CHOOSE OF btGoTo IN FRAME fpage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenance
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMaintenance
ON CHOOSE OF btLast IN FRAME fpage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMaintenance
ON CHOOSE OF btNext IN FRAME fpage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMaintenance
ON CHOOSE OF btPrev IN FRAME fpage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMaintenance
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMaintenance
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenance
ON CHOOSE OF btSave IN FRAME fpage0 /* Save */
OR CHOOSE OF MENU-ITEM miSave IN MENU mbMain DO:

    IF  INPUT FRAME fpage0 tt-int-nota-conhec.centro-custo-frete <> ""
    THEN DO:
        ASSIGN v-cod-cc-frete = STRING(INT(INPUT FRAME fpage0 tt-int-nota-conhec.centro-custo-frete),"99999").

        EMPTY TEMP-TABLE tt_log_erro.
        run prgint\utb\utb742za.py persistent set h_api_ccusto.
            
        run pi_busca_dados_ccusto in h_api_ccusto (input  i-ep-codigo-usuario,   /* EMPRESA EMS2 */
                                                   input  "",                    /* CODIGO DO PLANO CCUSTO */
                                                   input  v-cod-cc-frete,        /* CCUSTO */
                                                   input  today,                 /* DATA DE TRANSACAO */
                                                   output v_des_titulo_ccusto,   /* DESCRICAO DO CCUSTO */
                                                   output table tt_log_erro).    /* ERROS */
        DELETE PROCEDURE h_api_ccusto.

        FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
        IF  AVAIL tt_log_erro THEN DO:
            RUN utp\ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "Centro de custos informado n∆o existe.").
            RETURN NO-APPLY.
        END.
        DISP v-cod-cc-frete @ tt-int-nota-conhec.centro-custo-frete WITH FRAME fpage0.
    END.

    IF  INPUT FRAME fpage0 tt-int-nota-conhec.centro-custo-frete <> ""  
    THEN DO:
        FIND correios-cartao NO-LOCK
            WHERE correios-cartao.nr-cartao = INPUT FRAME {&FRAME-NAME} tt-int-nota-conhec.nr-cartao NO-ERROR.

        IF  NOT AVAIL correios-cartao
        THEN DO:
            RUN utp\ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "N£mero do cart∆o informado n∆o existe.~~Verifique no cadastro de cart‰es se existe algum relacionamento com o centro de custos informado. Programa ESUTP053.").
            RETURN NO-APPLY.
        END.
    END.


    FIND  nota-fiscal  NO-LOCK
        WHERE nota-fiscal.cod-estabel    = tt-int-nota-conhec.cod-estabel:SCREEN-VALUE in frame fpage0
          AND nota-fiscal.serie          = tt-int-nota-conhec.serie:SCREEN-VALUE in frame fpage0
          AND nota-fiscal.nr-nota-fis    = tt-int-nota-conhec.nr-nota-fis:SCREEN-VALUE in frame fpage0  NO-ERROR.
    IF nota-fiscal.dt-cancel <> ? THEN DO:
        MESSAGE "Nota Cancelada nao Ç possivel informar nro documento"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    ELSE DO:
 /*        RUN EnviaEmail. */

        RUN saveRecord IN THIS-PROCEDURE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="eszoom/z01es434.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUndo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUndo wMaintenance
ON CHOOSE OF btUndo IN FRAME fpage0 /* Undo */
OR CHOOSE OF MENU-ITEM miUndo IN MENU mbMain DO:
    RUN undoRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMaintenance
ON CHOOSE OF btUpdate IN FRAME fpage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
    RUN updateRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 wMaintenance
ON CHOOSE OF BUTTON-1 IN FRAME fpage0 /* Button 1 */
DO:
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    DEFINE VARIABLE c-danfe AS CHARACTER   NO-UNDO.

    ASSIGN c-danfe = input frame fpage0 c-chave.

    FIND FIRST estabelec 
         WHERE estabelec.cgc = SUBSTRING(c-danfe,7,14) NO-LOCK NO-ERROR.
    IF NOT AVAIL estabelec  THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17006, INPUT "Estabelecimento n∆o encontrado!":U).
        RETURN NO-APPLY.
    END.

    FIND FIRST nota-fiscal 
         WHERE nota-fiscal.cod-estabel = estabelec.cod-estabel
           AND nota-fiscal.serie       = STRING(INTEGER(SUBSTRING(c-danfe,23,3)))
           AND nota-fiscal.nr-nota-fis = SUBSTRING(c-danfe,28,7) NO-LOCK NO-ERROR.
    IF NOT AVAIL  nota-fiscal  THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17006, INPUT "Nota Fiscal n∆o encontrada!":U).
        RETURN NO-APPLY.
    END.
    ELSE DO:

        IF c-danfe <> nota-fiscal.cod-chave-aces-nf-eletro THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17006, INPUT "Nota n∆o encontrada com a Chave de acesso!":U).
            RETURN NO-APPLY.
        END.
        
        RUN goToKey IN {&hDBOTable}  (input nota-fiscal.cod-estabel, 
                                      INPUT nota-fiscal.serie,
                                      INPUT nota-fiscal.nr-nota-fis,
                                      input 1).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Nota Fiscal":U).
            RETURN NO-APPLY.
        END.
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).

        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo). 

        RUN trataNF.

    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-chave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-chave wMaintenance
ON RETURN OF c-chave IN FRAME fpage0 /* Chave acesso NFe */
DO:
    APPLY "ENTRY":U TO BUTTON-1 IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-int-nota-conhec.centro-custo-frete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-nota-conhec.centro-custo-frete wMaintenance
ON LEAVE OF tt-int-nota-conhec.centro-custo-frete IN FRAME fpage0 /* C.C. Frete */
DO:
    ASSIGN v-cod-cc-frete = STRING(INT(INPUT FRAME fpage0 tt-int-nota-conhec.centro-custo-frete),"99999").

    EMPTY TEMP-TABLE tt_log_erro.
    run prgint\utb\utb742za.py persistent set h_api_ccusto.

    run pi_busca_dados_ccusto in h_api_ccusto (input  i-ep-codigo-usuario,   /* EMPRESA EMS2 */
                                               input  "",                    /* CODIGO DO PLANO CCUSTO */
                                               input  v-cod-cc-frete,        /* CCUSTO */
                                               input  today,                 /* DATA DE TRANSACAO */
                                               output v_des_titulo_ccusto,   /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro).    /* ERROS */
    DELETE PROCEDURE h_api_ccusto.

    FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
    IF  NOT AVAIL tt_log_erro
    THEN DO:
        DISPLAY v_des_titulo_ccusto @ v-des-cc-frete WITH FRAME fpage0.

        FIND FIRST correios-cartao NO-LOCK
            WHERE  correios-cartao.cc-codigo[1] = v-cod-cc-frete NO-ERROR.
    
        IF  AVAIL correios-cartao
        THEN
            IF tt-int-nota-conhec.nr-cartao = "" THEN
                DISPLAY correios-cartao.nr-cartao @ tt-int-nota-conhec.nr-cartao WITH FRAME fpage0.
            ELSE
                DISPLAY tt-int-nota-conhec.nr-cartao @ tt-int-nota-conhec.nr-cartao WITH FRAME fpage0.
        ELSE
            DISPLAY "" @ tt-int-nota-conhec.nr-cartao WITH FRAME fpage0.
    END.
    ELSE
        DISPLAY "" @ v-des-cc-frete 
                "" @ tt-int-nota-conhec.nr-cartao WITH FRAME fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-int-nota-conhec.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-nota-conhec.cod-estabel wMaintenance
ON F5 OF tt-int-nota-conhec.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                        &campo=tt-int-nota-conhec.cod-estabel
                        &campozoom=cod-estabel
                        &campo2=fi-desc-estabel
                        &campozoom2=nome}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-nota-conhec.cod-estabel wMaintenance
ON LEAVE OF tt-int-nota-conhec.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:

    assign input frame fPage0 tt-int-nota-conhec.cod-estabel.

    {include/leave.i &tabela=estabelec
                    &atributo-ref=nome
                    &variavel-ref=fi-desc-estabel
                    &where="estabelec.cod-estabel = tt-int-nota-conhec.cod-estabel"}
                    
    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT "ESFTP053":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).
    
    FIND FIRST tt-prog-ponto
         WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = INPUT FRAME fPage0 tt-int-nota-conhec.cod-estabel NO-ERROR.

    IF AVAIL tt-prog-ponto THEN DO:
        ASSIGN tt-int-nota-conhec.nr-cartao:SCREEN-VALUE IN FRAME fPage0 =  ENTRY(2,tt-prog-ponto.conteudo,";")
               tt-int-nota-conhec.centro-custo-frete:SCREEN-VALUE IN FRAME fPage0 =  ""
               tt-int-nota-conhec.centro-custo-frete:SENSITIVE IN FRAME fPage0 = NO.
    END.
    ELSE DO:
        ASSIGN tt-int-nota-conhec.nr-cartao:SCREEN-VALUE IN FRAME fPage0 =  ""
               tt-int-nota-conhec.centro-custo-frete:SENSITIVE IN FRAME fPage0 = YES.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-nota-conhec.cod-estabel wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-int-nota-conhec.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-int-nota-conhec.nr-nota-fis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-nota-conhec.nr-nota-fis wMaintenance
ON F5 OF tt-int-nota-conhec.nr-nota-fis IN FRAME fpage0 /* Nota Fiscal */
DO:
    {include/zoomvar.i &prog-zoom="dizoom/z03di135.w"
                     &campo=tt-int-nota-conhec.cod-estabel
                     &campozoom=cod-estabel
                     &campo2=tt-int-nota-conhec.serie
                     &campozoom2=serie
                     &campo3=tt-int-nota-conhec.nr-nota-fis
                     &campozoom3=nr-nota-fis}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-nota-conhec.nr-nota-fis wMaintenance
ON LEFT-MOUSE-DBLCLICK OF tt-int-nota-conhec.nr-nota-fis IN FRAME fpage0 /* Nota Fiscal */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-int-nota-conhec.serie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-nota-conhec.serie wMaintenance
ON F5 OF tt-int-nota-conhec.serie IN FRAME fpage0 /* SÇrie */
DO:
    /*{method/ZoomFields.i &ProgramZoom="eszoom/z01es407.w"
                         &FieldZoom1="equipamento"
                         &FieldScreen1="tt-int-nota-conhec.equipamento"
                         &Frame1="fPage0"
                         &FieldZoom2="cod-estabel"
                         &FieldScreen2="tt-int-nota-conhec.cod-estabel"
                         &Frame2="fPage0"
                         &EnableImplant="NO"}
     APPLY "LEAVE" TO tt-int-nota-conhec.cod-estabel IN FRAME fPage0.
     APPLY "LEAVE" TO tt-int-nota-conhec.equipamento IN FRAME fPage0.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-int-nota-conhec.serie wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-int-nota-conhec.serie IN FRAME fpage0 /* SÇrie */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializaá∆o do programam ---*/

tt-int-nota-conhec.cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-int-nota-conhec.nr-nota-fis:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

{maintenance/mainblock.i}
apply 'entry' to c-chave in frame fpage0.


/**** External Procedures ****/
PROCEDURE OpenDocument:

    def input param c-doc as char  no-undo.
    def var c-exec as char  no-undo.
    def var h-Inst as int  no-undo.

    assign c-exec = fill("x",255).
    run FindExecutableA (input c-doc,
                         input "",
                         input-output c-exec,
                         output h-inst).

    if h-inst >= 0 and h-inst <=32 then
      run ShellExecuteA (input 0,
                         input "open",
                         input "rundll32.exe",
                         input "shell32.dll,OpenAs_RunDLL " + c-doc,
                         input "",
                         input 1,
                         output h-inst).

    run ShellExecuteA (input 0,
                       input "open",
                       input c-doc,
                       input "",
                       input "",
                       input 1,
                       output h-inst).

    if h-inst < 0 or h-inst > 32 then return "OK".
    else return "NOK".

END PROCEDURE.

PROCEDURE FindExecutableA EXTERNAL "Shell32.dll" persistent:

    define input parameter lpFile as char  no-undo.
    define input parameter lpDirectory as char  no-undo.
    define input-output parameter lpResult as char  no-undo.
    define return parameter hInstance as long.

END.

PROCEDURE ShellExecuteA EXTERNAL "Shell32.dll" persistent:

    define input parameter hwnd as long.
    define input parameter lpOperation as char  no-undo.
    define input parameter lpFile as char  no-undo.
    define input parameter lpParameters as char  no-undo.
    define input parameter lpDirectory as char  no-undo.
    define input parameter nShowCmd as long.
    define return parameter hInstance as long.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenance 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF AVAIL tt-int-nota-conhec THEN DO:
        APPLY "LEAVE":U TO tt-int-nota-conhec.cod-estabel IN FRAME fPage0.
        APPLY "LEAVE":U TO tt-int-nota-conhec.centro-custo-frete IN FRAME fPage0.
    END.
    ELSE DO:
        ASSIGN fi-desc-estabel:SCREEN-VALUE IN FRAME fPage0 = "".
        DISPLAY "" @ v-des-cc-frete 
                0  @ tt-int-nota-conhec.nr-cartao WITH FRAME fpage0.
    END.

    assign c-chave:screen-value in frame fpage0 = "".
          
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterEnableFields wMaintenance 
PROCEDURE AfterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
APPLY "LEAVE" TO tt-int-nota-conhec.cod-estabel IN FRAME fPage0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterSaveFields wMaintenance 
PROCEDURE afterSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeSaveFields wMaintenance 
PROCEDURE beforeSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* if  tt-int-nota-conhec.cod-estabel <> "102" and                                                                                                                                                       */
/*     dec(tt-int-nota-conhec.peso-bruto:screen-value IN FRAME fPage0) = 0 then do:                                                                                                                      */
/*     RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17006, INPUT "ê obrigat¢rio a informaá∆o do Peso~~Por exigencia do correio Ç obrigat¢rio a informaá∆o correta do peso bruto da caixa":U).                */
/*     return "NOK":U.                                                                                                                                                                                   */
/* end.                                                                                                                                                                                                  */
/* if  tt-int-nota-conhec.cod-estabel <> "102" and                                                                                                                                                       */
/*     (dec(tt-int-nota-conhec.comprimento:screen-value IN FRAME fPage0) = 0 or                                                                                                                          */
/*      dec(tt-int-nota-conhec.altura:screen-value IN FRAME fPage0) = 0 or                                                                                                                               */
/*      dec(tt-int-nota-conhec.largura:screen-value IN FRAME fPage0) = 0) then do:                                                                                                                       */
/*     RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 17006, INPUT "ê obrigat¢rio a informaá∆o das dimens‰es da caixa~~Por exigencia do correio Ç obrigat¢rio a informaá∆o correta das dimens‰es da Caixa":U). */
/*     return "NOK":U.                                                                                                                                                                                   */
/* end.                                                                                                                                                                                                  */
 if c-chave:screen-value in frame fpage0 <> "" then return "OK".

 ASSIGN tt-int-nota-conhec.nr-cartao = INPUT FRAME {&FRAME-NAME} tt-int-nota-conhec.nr-cartao.

 IF  tt-int-nota-conhec.nr-conhec:SENSITIVE IN FRAME {&FRAME-NAME} = YES
 THEN
     ASSIGN tt-int-nota-conhec.dat-1 = TODAY.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EnviaEmail wMaintenance 
PROCEDURE EnviaEmail :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cMensagem            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE vArqMail             AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lErro       AS LOGICAL      NO-UNDO INITIAL NO.
    DEFINE VARIABLE c-nr-pedido AS CHARACTER   NO-UNDO.

FOR EACH nota-fiscal  EXCLUSIVE-LOCK
    WHERE nota-fiscal.cod-estabel    = tt-int-nota-conhec.cod-estabel:SCREEN-VALUE in frame fpage0
      AND nota-fiscal.serie          = tt-int-nota-conhec.serie:SCREEN-VALUE in frame fpage0
      AND nota-fiscal.nr-nota-fis   = tt-int-nota-conhec.nr-nota-fis:SCREEN-VALUE in frame fpage0
      AND (nota-fiscal.nome-transp    = "SEDEX" OR
           nota-fiscal.nome-transp    = "SEDEX MG"),

    FIRST emitente NO-LOCK
    WHERE emitente.nome-abrev = nota-fiscal.nome-ab-cli:

    ASSIGN nota-fiscal.dt-saida = TODAY.

    FOR EACH tt-mail.
        DELETE tt-mail.
    END.

    ASSIGN cMensagem = "Confirmaá∆o de Emiss∆o de Nota Fiscal" + CHR(10) + CHR(10) + 
                       "Foi emitida a nota fiscal de numero " + STRING(nota-fiscal.nr-nota-fis) + 
                       ", referente o pedido numero " + nota-fiscal.nr-pedcli  + "." +  CHR(10) + CHR(10) + 
                       "A mesma enviada por SEDEX Nro: " + tt-int-nota-conhec.nr-conhec:SCREEN-VALUE in frame fpage0  + CHR(10) + CHR(10) + 
                       "     Para acompanhar a entrega acesse o site do correios atravÇs do link: " + CHR(10) + CHR(10) + 

                       "     http://websro.correios.com.br/sro_bin/txect01$.QueryList?P_LINGUA=001&P_TIPO=001&P_COD_UNI=" + trim(tt-int-nota-conhec.nr-conhec:SCREEN-VALUE in frame fpage0) + CHR(10) + CHR(10) + 


                       "Setor Fiscal" + CHR(10) + CHR(10) .

    ASSIGN c-nr-pedido = "".
    for each it-nota-fisc of nota-fiscal,
        first item fields(it-codigo desc-item) no-lock 
        where item.it-codigo = it-nota-fisc.it-codigo:
        IF  c-nr-pedido = "" THEN
            ASSIGN c-nr-pedido = "99" 
                   cMensagem   = cMensagem + 
                                 "Item    Descricao                                       Qt" + CHR(10) +
                                 "------- ------------------------------------ -------------" + CHR(10).
        ASSIGN cMensagem = cMensagem +
                           string(it-nota-fisc.it-codigo,"x(07)")  + ' ' +
                           string(item.desc-item,"X(36)")          + ' ' +
                           string(it-nota-fisc.qt-faturada[1],">>>>,>>9.9999") + CHR(10).
    end.
    ASSIGN vArqMail = SESSION:TEMP-DIRECTORY + "EnvMailNF.txt".
    OUTPUT STREAM arq-email TO VALUE(vArqMail).
    PUT STREAM arq-email cMensagem FORMAT 'x(2000)'.
    OUTPUT STREAM arq-email CLOSE.
    CREATE tt-mail.
    ASSIGN tt-mail.Destinatario  = emitente.e-mail
           tt-mail.Assunto       = "Emissao Nota Fiscal Venda"
           tt-mail.Mensagem      = cMensagem
           tt-mail.Arquivo       = vArqMail.
        /*CHR(10) + CHR(10) + */

    MESSAGE "Nota atualizada e E-mail enviado para " emitente.e-mail
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

    FOR FIRST usuar_mestre NO-LOCK 
        WHERE usuar_mestre.cod_usuario = c-seg-usuario:
        ASSIGN tt-mail.Remetente = usuar_mestre.cod_e_mail_local.
    END.
    IF tt-mail.Remetente = "" THEN
        ASSIGN tt-mail.Remetente = "ems@intelbras.com.br".

    RUN esapi/esapi010.p (INPUT-OUTPUT TABLE tt-mail,
                          OUTPUT TABLE tt-erro).
    /*
    FOR EACH tt-erro:
        MESSAGE tt-erro.mensagem
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
      */
    FOR EACH tt-mail:
        DELETE tt-mail.
    END.

END.






END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
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
    
    DEFINE VARIABLE c-cod-estabel LIKE {&ttTable}.cod-estabel NO-UNDO.
    DEFINE VARIABLE c-serie       LIKE {&ttTable}.serie       NO-UNDO.
    DEFINE VARIABLE c-nr-nota-fis LIKE {&ttTable}.nr-nota-fis NO-UNDO.
    DEFINE VARIABLE i-nr-volume   LIKE {&ttTable}.nr-volume   NO-UNDO.
    
    
    DEFINE FRAME fGoToRecord
        c-cod-estabel     AT ROW 1.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 4   BY .88
        c-serie           AT ROW 2.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 6   BY .88
        c-nr-nota-fis     AT ROW 3.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 8   BY .88
        i-nr-volume       AT ROW 4.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 5   BY .88        

        btGoToOK          AT ROW 7.63 COL 2.14
        btGoToCancel      AT ROW 7.63 COL 13
        rtGoToButton      AT ROW 7.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Nota/Conhecimentos" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V†_Para_Nota/Conhecimentos"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-cod-estabel c-serie c-nr-nota-fis i-nr-volume .
        
        RUN goToKey IN {&hDBOTable} (INPUT c-cod-estabel, 
                                     INPUT c-serie,
                                     INPUT c-nr-nota-fis,
                                     input i-nr-volume).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Fatura":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-cod-estabel c-serie c-nr-nota-fis i-nr-volume  btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenance 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    enable  button-1  c-chave with frame fpage0.
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "esbo\boes434.p":U THEN DO:
        {btb/btb008za.i1 esbo\boes434.p YES}
        {btb/btb008za.i2 esbo\boes434.p '' {&hDBOTable}}
    END.
    
    RUN setConstraintMain IN {&hDBOTable} NO-ERROR.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trataNF wMaintenance 
PROCEDURE trataNF :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR c-arquivo AS CHAR NO-UNDO.
    DEFINE VARIABLE c-file     AS CHAR NO-UNDO.
    DEFINE VARIABLE c-command  AS CHAR NO-UNDO.

    FIND FIRST int-pedido-vtex NO-LOCK
         WHERE int-pedido-vtex.nr-pedcli = nota-fiscal.nr-pedcli NO-ERROR.
    IF AVAIL int-pedido-vtex 
         AND int-pedido-vtex.marketplace = "BWW" 
          OR int-pedido-vtex.marketplace = "MLP"
          OR int-pedido-vtex.marketplace = "MGZ"
          OR int-pedido-vtex.marketplace = "SHP" THEN DO:

        RUN utp/ut-msgs.p (INPUT "show", INPUT 27100, INPUT "Pedido do Marketplace, deseja imprimir a etiqueta?").
        IF  RETURN-VALUE <> "YES" THEN 
            RETURN NO-APPLY.
    
        IF int-pedido-vtex.marketplace = "BWW" THEN DO:
            RUN pi-imprime-etiqueta (INPUT nota-fiscal.cod-chave-aces-nf-eletro).
        END.
        IF int-pedido-vtex.marketplace = "MLP" THEN DO:
            RUN pi-imprime-etiqueta (INPUT int-pedido-vtex.nr-pedido).
        END.
        IF int-pedido-vtex.marketplace = "MGZ" THEN DO:
            RUN pi-imprime-etiqueta (INPUT int-pedido-vtex.nr-pedido).
        END.
        IF int-pedido-vtex.marketplace = "SHP" THEN DO:
            RUN pi-imprime-etiqueta (INPUT int-pedido-vtex.nr-pedido).
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-imprime-etiqueta wMaintenance 
PROCEDURE pi-imprime-etiqueta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER p-chave AS CHAR NO-UNDO.

    DEFINE VARIABLE c-impressora AS CHAR NO-UNDO.
    DEFINE VARIABLE c-arquivo    AS CHAR NO-UNDO.
    DEFINE VARIABLE c-file       AS CHAR NO-UNDO.
    DEFINE VARIABLE c-etiqueta   AS LONGCHAR NO-UNDO.

    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp\es0018p.p (INPUT "ESFTP128",
                       INPUT 1,
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto).
    FOR FIRST tt-prog-ponto:
        ASSIGN c-impressora = tt-prog-ponto.conteudo.
    END.
    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT  "WSO0003":U,
                       INPUT  8,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).
    IF OPSYS = "UNIX":U THEN
        FOR FIRST tt-prog-ponto
            WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = "UNIX":
            ASSIGN c-file = REPLACE(ENTRY(2,tt-prog-ponto.conteudo,";"), "~\":U, "/":U).
        END.
    ELSE
        FOR FIRST tt-prog-ponto
            WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = "WIN":
            ASSIGN c-file = REPLACE(ENTRY(2,tt-prog-ponto.conteudo,";"), "~\":U, "/":U).
        END.

    ASSIGN c-arquivo = c-file + p-chave + ".zpl".

    IF SEARCH(c-arquivo) <> ? THEN DO:

        COPY-LOB FROM FILE c-arquivo TO c-etiqueta NO-ERROR.

        FOR LAST imprsor_usuar FIELDS (nom_impressora nom_disposit_so) no-lock
           WHERE imprsor_usuar.nom_impressora = c-impressora
             //AND imprsor_usuar.cod_usuario    = c-seg-usuario
            use-index imprsrsr_id,
            FIRST impressora FIELDS () NO-LOCK OF imprsor_usuar,
            FIRST tip_imprsor FIELDS (cod_pag_carac_conver) NO-LOCK of impressora:

            OUTPUT TO VALUE(imprsor_usuar.nom_disposit_so)
                   PAGE-SIZE 0
                   CONVERT TARGET tip_imprsor.cod_pag_carac_conver. 

            PUT UNFORMATTED STRING(c-etiqueta).

            OUTPUT CLOSE.
        END.
    END.

END PROCEDURE.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

