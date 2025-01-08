&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-def-transportes NO-UNDO LIKE def-transportes
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
{include/i-prgvrs.i ESCDP042 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCDP042
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            YES
&GLOBAL-DEFINE Copy           YES
&GLOBAL-DEFINE Update         YES
&GLOBAL-DEFINE Delete         YES
&GLOBAL-DEFINE Undo           YES
&GLOBAL-DEFINE Cancel         YES
&GLOBAL-DEFINE Save           YES

&GLOBAL-DEFINE ttTable        tt-def-transportes    
&GLOBAL-DEFINE hDBOTable      hDBODefTransp
&GLOBAL-DEFINE DBOTable       def-transportes

&GLOBAL-DEFINE page0KeyFields tt-def-transportes.cod-estabel tt-def-transportes.cod-uf ~
                              tt-def-transportes.cod-cidade tt-def-transportes.cod-cliente ~
                              tt-def-transportes.cd-unid-comerc
&GLOBAL-DEFINE page0Fields    
&GLOBAL-DEFINE page1Fields    tt-def-transportes.cod-trans tt-def-transportes.sigla-trans
&GLOBAL-DEFINE page2Fields    

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE BUFFER bf-emitente FOR emitente.

DEFINE TEMP-TABLE tt-def-transportes-import
    FIELD cod-estabel    LIKE def-transportes.cod-estabel
    FIELD cod-uf         LIKE def-transportes.cod-uf
    FIELD cod-cidade     LIKE def-transportes.cod-cidade
    FIELD cod-cliente    LIKE def-transportes.cod-cliente
    FIELD cd-unid-comerc LIKE def-transportes.cd-unid-comerc
    FIELD cod-trans      LIKE def-transportes.cod-trans
    FIELD sigla-trans    LIKE def-transportes.sigla-trans
    FIELD linha AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-def-transportes.cod-estabel ~
tt-def-transportes.cod-uf tt-def-transportes.cod-cidade ~
tt-def-transportes.cod-cliente tt-def-transportes.cd-unid-comerc 
&Scoped-define ENABLED-TABLES tt-def-transportes
&Scoped-define FIRST-ENABLED-TABLE tt-def-transportes
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys btFirst btPrev btNext ~
btLast btGoTo btSearch btAdd btCopy btUpdate btDelete btUndo btCancel ~
btSave btElimina btQueryJoins btReportsJoins btExit btHelp btImportar ~
btLayout c-desc-estabel c-desc-uf c-desc-cliente ds-unid-comerc 
&Scoped-Define DISPLAYED-FIELDS tt-def-transportes.cod-estabel ~
tt-def-transportes.cod-uf tt-def-transportes.cod-cidade ~
tt-def-transportes.cod-cliente tt-def-transportes.cd-unid-comerc 
&Scoped-define DISPLAYED-TABLES tt-def-transportes
&Scoped-define FIRST-DISPLAYED-TABLE tt-def-transportes
&Scoped-Define DISPLAYED-OBJECTS c-desc-estabel c-desc-uf c-desc-cliente ~
ds-unid-comerc 

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

DEFINE BUTTON btElimina 
     IMAGE-UP FILE "adeicon/remote-u.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Elimina Faixa".

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

DEFINE BUTTON btImportar 
     LABEL "Importar" 
     SIZE 8 BY 1.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image\im-las":U
     IMAGE-INSENSITIVE FILE "image\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btLayout 
     LABEL "Layout" 
     SIZE 8 BY 1.

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

DEFINE VARIABLE c-desc-cliente AS CHARACTER FORMAT "X(35)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estabel AS CHARACTER FORMAT "X(35)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-uf AS CHARACTER FORMAT "X(35)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE ds-unid-comerc AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 5.83.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE c-desc-trans AS CHARACTER FORMAT "X(35)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.


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
     btElimina AT ROW 1.13 COL 61.14
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     btImportar AT ROW 1.25 COL 67.43 WIDGET-ID 10
     btLayout AT ROW 1.25 COL 75.43 WIDGET-ID 12
     tt-def-transportes.cod-estabel AT ROW 3.29 COL 26.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
     c-desc-estabel AT ROW 3.29 COL 38.72 COLON-ALIGNED NO-LABEL
     tt-def-transportes.cod-uf AT ROW 4.29 COL 26.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
     c-desc-uf AT ROW 4.29 COL 38.72 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     tt-def-transportes.cod-cidade AT ROW 5.29 COL 26.72 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 30 BY .88
     tt-def-transportes.cod-cliente AT ROW 6.29 COL 26.72 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
     c-desc-cliente AT ROW 6.29 COL 38.72 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     tt-def-transportes.cd-unid-comerc AT ROW 7.29 COL 26.72 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
     ds-unid-comerc AT ROW 7.29 COL 38.72 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 12.58
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     tt-def-transportes.cod-trans AT ROW 2 COL 23.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
     c-desc-trans AT ROW 2 COL 35.86 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     tt-def-transportes.sigla-trans AT ROW 3 COL 23.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 8.88
         SIZE 84.43 BY 4
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-def-transportes T "?" NO-UNDO mgesp def-transportes
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
         HEIGHT             = 12.21
         WIDTH              = 90
         MAX-HEIGHT         = 27.21
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.21
         VIRTUAL-WIDTH      = 146.29
         MAX-BUTTON         = no
         RESIZE             = no
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN tt-def-transportes.sigla-trans IN FRAME fPage1
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
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


&Scoped-define SELF-NAME btElimina
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btElimina wMaintenance
ON CHOOSE OF btElimina IN FRAME fpage0
DO:
    ASSIGN CURRENT-WINDOW:SENSITIVE = NO.

    RUN esp/cdp/escdp042a.w.

    RUN displayFields.

    ASSIGN CURRENT-WINDOW:SENSITIVE = YES.
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


&Scoped-define SELF-NAME btImportar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImportar wMaintenance
ON CHOOSE OF btImportar IN FRAME fpage0 /* Importar */
DO:
    DEFINE VARIABLE h-acomp     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE c-arquivo   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-ok        AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE i-cont      AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-sequencia AS INTEGER     NO-UNDO.

    EMPTY TEMP-TABLE tt-def-transportes-import.
    EMPTY TEMP-TABLE rowErrors.
    ASSIGN i-cont = 0.


    /* Solicita arquivo que ser† importado */
    SYSTEM-DIALOG GET-FILE c-arquivo
            TITLE      "Importar Dados"
            FILTERS    "Arquivos de texto (*.csv)" "*.csv"
            INITIAL-DIR SESSION:TEMP-DIRECTORY
            MUST-EXIST
            USE-FILENAME
            UPDATE l-ok.

    IF  NOT l-ok THEN RETURN "NOK":U.

    IF  NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    RUN pi-inicializar IN h-acomp (INPUT "Importando Dados").

    /* Importa as Notas de um arquivo */
    INPUT FROM VALUE(c-arquivo) NO-ECHO.
    REPEAT:
        ASSIGN i-cont = i-cont + 1.

        RUN pi-acompanhar IN h-acomp (INPUT "Importando linha " + STRING(i-cont)).

        CREATE tt-def-transportes-import.
        ASSIGN tt-def-transportes-import.linha = i-cont.
        IMPORT DELIMITER ";" tt-def-transportes-import.
    END.
    INPUT CLOSE.
    
    RUN pi-inicializar IN h-acomp (INPUT "Efetivando Dados").

    /* N∆o busca o £ltimo registro criado, com as informaá‰es em branco! */
    FOR EACH  tt-def-transportes-import EXCLUSIVE-LOCK
        WHERE tt-def-transportes-import.linha < i-cont
         AND  tt-def-transportes-import.cod-estabel <> "":

        RUN pi-acompanhar IN h-acomp (INPUT "Transportadora: " + STRING(tt-def-transportes-import.cod-trans)).

        RUN pi-validar-imp IN THIS-PROCEDURE.
        IF  RETURN-VALUE = "NOK":U THEN
            NEXT.

        CREATE def-transportes.
        BUFFER-COPY tt-def-transportes-import TO def-transportes.
    END.

    IF  VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    IF  CAN-FIND(FIRST rowErrors) THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2 &Modal="YES"}
        {method/showmessage.i3}
    END.
    ELSE DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 15825,
                           INPUT "Importaá∆o conclu°da!":U).
    END.

    RUN displayFields IN THIS-PROCEDURE.

    RETURN "OK":U.
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


&Scoped-define SELF-NAME btLayout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLayout wMaintenance
ON CHOOSE OF btLayout IN FRAME fpage0 /* Layout */
DO:
  DEFINE BUTTON btLayoutFechar AUTO-END-KEY 
         LABEL "&Fechar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE c-editor AS CHARACTER   NO-UNDO.

    ASSIGN c-editor = FILL("-",124)                         + CHR(13) +
                      FILL(" ",46) + "Layout de Importaá∆o" + CHR(13) +
                      FILL("-",124)                         + CHR(13) + CHR(13) +
                      "O arquivo com os dados da Transportadora deve seguir o padr∆o abaixo:" + CHR(13) +
                      "Estabelecimento Origem;UF Destino;Cidade Destino;Cliente Destino;Unid Comercial;Transportadora;Sigla" + CHR(13) + CHR(13) +
                      "101;SC;JOINVILLE;CLIENTE1;70;TRANSPORTADORA1;SCJO"  + CHR(13) +
                      "101;SP;SAO PAULO;CLIENTE2;40;TRANSPORTADORA2;SPSP"  + CHR(13) +
                      "101;MG;BELO HORIZONTE;CLIENTE3;45;TRANSPORTADORA3;MGBH" + CHR(13).
    
    DEFINE FRAME fLayout
        c-editor        AT ROW 1.21 COL 1 COLON-ALIGNED VIEW-AS EDITOR SIZE 54 BY 7 NO-LABEL
        btLayoutFechar  AT ROW 8.53 COL 2
        rtGoToButton    AT ROW 8.28 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Layout de Importaá∆o" FONT 1
              DEFAULT-BUTTON btLayoutFechar.

    DISPLAY c-editor
        WITH FRAME fLayout.

    ENABLE btLayoutFechar
        WITH FRAME fLayout. 
    
    WAIT-FOR "GO":U OF FRAME fLayout.

    RETURN "OK":U.
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
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
     {method/zoomreposition.i &ProgramZoom="eszoom/z01es575.w"}
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


&Scoped-define SELF-NAME tt-def-transportes.cd-unid-comerc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-def-transportes.cd-unid-comerc wMaintenance
ON F5 OF tt-def-transportes.cd-unid-comerc IN FRAME fpage0 /* Unidade Comercial */
DO:
    {method/zoomfields.i &ProgramZoom="eszoom/z01es568.w"
                         &FieldZoom1="cd-unid-comerc"
                         &FieldScreen1="{&ttTable}.cd-unid-comerc"
                         &Frame1="fPage0"
                         &FieldZoom2="ds-unid-comerc"
                         &FieldScreen2="ds-unid-comerc"
                         &Frame2="fPage0"
                         &EnableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-def-transportes.cd-unid-comerc wMaintenance
ON LEAVE OF tt-def-transportes.cd-unid-comerc IN FRAME fpage0 /* Unidade Comercial */
DO:
    ASSIGN INPUT FRAME fPage0 tt-def-transportes.cd-unid-comerc.

    FIND FIRST unid-comerc NO-LOCK
        WHERE  unid-comerc.cd-unid-comerc = tt-def-transportes.cd-unid-comerc NO-ERROR.

    ASSIGN ds-unid-comerc = IF AVAIL unid-comerc THEN unid-comerc.ds-unid-comerc ELSE "".

    DISPLAY ds-unid-comerc WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-def-transportes.cd-unid-comerc wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-def-transportes.cd-unid-comerc IN FRAME fpage0 /* Unidade Comercial */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-def-transportes.cod-cidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-def-transportes.cod-cidade wMaintenance
ON F5 OF tt-def-transportes.cod-cidade IN FRAME fpage0 /* Cidade Destino */
DO:
    {method/zoomfields.i &ProgramZoom="dizoom/z01di341.w"
                                 &FieldZoom1="cidade"
                                 &FieldScreen1="{&ttTable}.cod-cidade"
                                 &Frame1="fPage0"
                                 &EnableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-def-transportes.cod-cidade wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-def-transportes.cod-cidade IN FRAME fpage0 /* Cidade Destino */
DO:
   APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-def-transportes.cod-cliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-def-transportes.cod-cliente wMaintenance
ON F5 OF tt-def-transportes.cod-cliente IN FRAME fpage0 /* Cliente Destino */
DO:
   assign l-implanta = no.
    {include/zoomvar.i &prog-zoom="adzoom/z01ad098.w"
                     &campo=tt-def-transportes.cod-cliente
                     &campozoom=cod-emitente
                     &campo2=c-desc-cliente
                     &campozoom2=nome-emit}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-def-transportes.cod-cliente wMaintenance
ON LEAVE OF tt-def-transportes.cod-cliente IN FRAME fpage0 /* Cliente Destino */
DO:
    IF tt-def-transportes.cod-cliente:screen-value in frame fPage0 <> "" THEN DO:
    
        FOR FIRST bf-emitente WHERE bf-emitente.cod-emitente = int(tt-def-transportes.cod-cliente:SCREEN-VALUE IN FRAME FPage0) NO-LOCK:
    
            ASSIGN c-desc-cliente:screen-value in frame fPage0 = bf-emitente.nome-emit.
    
        END.
        
        IF NOT AVAIL bf-emitente THEN ASSIGN c-desc-cliente:screen-value in frame fPage0 = "".
    END.
    ELSE ASSIGN c-desc-cliente:screen-value in frame fPage0 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-def-transportes.cod-cliente wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-def-transportes.cod-cliente IN FRAME fpage0 /* Cliente Destino */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-def-transportes.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-def-transportes.cod-estabel wMaintenance
ON F5 OF tt-def-transportes.cod-estabel IN FRAME fpage0 /* Estabelecimento Origem */
DO:
{include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                 &campo={&ttTable}.cod-estabel
                 &campozoom=cod-estabel
                 &frame=fPage0
                 &campo2=c-desc-estabel
                 &campozoom2=nome
                 &frame2=fPage0}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-def-transportes.cod-estabel wMaintenance
ON LEAVE OF tt-def-transportes.cod-estabel IN FRAME fpage0 /* Estabelecimento Origem */
DO:
 {include/leave.i &tabela=estabelec
               &atributo-ref=nome
               &variavel-ref=c-desc-estabel
                &where="estabelec.cod-estabel = input frame fPage0 {&ttTable}.cod-estabel"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-def-transportes.cod-estabel wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-def-transportes.cod-estabel IN FRAME fpage0 /* Estabelecimento Origem */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-def-transportes.cod-trans
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-def-transportes.cod-trans wMaintenance
ON F5 OF tt-def-transportes.cod-trans IN FRAME fPage1 /* Transportadora */
DO:
   {include/zoomvar.i &prog-zoom=adzoom/z01ad268.w
         &campo=tt-def-transportes.cod-trans
         &campozoom=cod-transp
         &campo2=c-desc-trans
         &campozoom2=nome-abrev}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-def-transportes.cod-trans wMaintenance
ON LEAVE OF tt-def-transportes.cod-trans IN FRAME fPage1 /* Transportadora */
DO:
    {include/leave.i &tabela=transporte
                    &atributo-ref=nome-abrev
                    &variavel-ref=c-desc-trans
                    &where="transporte.cod-trans = input frame fPage1 {&ttTable}.cod-trans"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-def-transportes.cod-trans wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-def-transportes.cod-trans IN FRAME fPage1 /* Transportadora */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME tt-def-transportes.cod-uf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-def-transportes.cod-uf wMaintenance
ON F5 OF tt-def-transportes.cod-uf IN FRAME fpage0 /* UF Destino */
DO:
   {include/zoomvar.i &prog-zoom="unzoom/z01un007.w"
                     &campo2={&ttTable}.cod-uf
                     &campozoom2=estado
                     &campo=c-desc-uf
                     &campozoom=no-estado}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-def-transportes.cod-uf wMaintenance
ON LEAVE OF tt-def-transportes.cod-uf IN FRAME fpage0 /* UF Destino */
DO:
  {include/leave.i
             &tabela=unid-feder
             &atributo-ref=no-estado
             &variavel-ref=c-desc-uf
             &where="unid-feder.estado = input frame fPage0 tt-def-transportes.cod-uf"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-def-transportes.cod-uf wMaintenance
ON MOUSE-SELECT-DBLCLICK OF tt-def-transportes.cod-uf IN FRAME fpage0 /* UF Destino */
DO:
    APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenance/mainblock.i}

tt-def-transportes.cod-trans:LOAD-MOUSE-POINTER("image/lupa.cur":U)  in frame fPage1.
tt-def-transportes.cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U)  in frame fPage0.
tt-def-transportes.cod-cliente:LOAD-MOUSE-POINTER("image/lupa.cur":U)  in frame fPage0.
tt-def-transportes.cod-uf:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage0.
tt-def-transportes.cod-cidade:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage0.
tt-def-transportes.cd-unid-comerc:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage0.

ASSIGN btQueryJoins:VISIBLE   IN FRAME fPage0 = NO
       btReportsJoins:VISIBLE IN FRAME fPage0 = NO
       btHelp:VISIBLE         IN FRAME fPage0 = NO
       btexit:COL             IN FRAME fpage0 = 86.72.

ENABLE btImportar btLayout btElimina WITH FRAME fPage0.

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

    APPLY 'leave' TO {&ttTable}.cod-trans       IN FRAME Fpage1.
    APPLY 'leave' TO {&ttTable}.cod-estabel     IN FRAME Fpage0.
    APPLY 'leave' TO {&ttTable}.cod-cliente     IN FRAME Fpage0.
    APPLY 'leave' TO {&ttTable}.cod-cidade      IN FRAME Fpage0.
    APPLY 'leave' TO {&ttTable}.cod-uf          IN FRAME Fpage0.
    APPLY 'leave' TO {&ttTable}.cd-unid-comerc   IN FRAME Fpage0.
    
    RETURN "OK":U.

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
    
    DEFINE VARIABLE pcod-estabel    LIKE {&ttTable}.cod-estabel NO-UNDO.
    DEFINE VARIABLE pcod-uf         LIKE {&ttTable}.cod-uf NO-UNDO.
    DEFINE VARIABLE pcod-cidade     LIKE {&ttTable}.cod-cidade NO-UNDO.
    DEFINE VARIABLE pcod-cliente    LIKE {&ttTable}.cod-cliente NO-UNDO.
    DEFINE VARIABLE pcd-unid-comerc LIKE {&ttTable}.cd-unid-comerc NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        pcod-estabel    AT ROW 1.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 04 BY .88
        pcod-uf         AT ROW 2.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 04 BY .88
        pcod-cidade     AT ROW 3.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 12 BY .88
        pcod-cliente    AT ROW 4.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 12 BY .88
        pcd-unid-comerc AT ROW 5.21 COL 17.72 COLON-ALIGNED VIEW-AS FILL-IN SIZE 06 BY .88
        btGoToOK          AT ROW 6.63 COL 2.14
        btGoToCancel      AT ROW 6.63 COL 13
        rtGoToButton      AT ROW 6.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Definiá∆o Transportadoras" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN pcod-estabel pcod-uf pcod-cidade pcod-cliente pcd-unid-comerc.
        
        RUN goToKey IN {&hDBOTable} (INPUT pcod-estabel,
                                     INPUT pcod-uf,
                                     INPUT pcod-cidade,
                                     INPUT pcod-cliente,
                                     INPUT pcd-unid-comerc).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Definiá∆o Transportadoras":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE pcod-estabel pcod-uf pcod-cidade pcod-cliente pcd-unid-comerc btGoToOK btGoToCancel 
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
    
    /*:T--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "esbo/boes575.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes575.p YES}
        {btb/btb008za.i2 esbo/boes575.p '' {&hDBOTable}}
    END.
    
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validar-imp wMaintenance 
PROCEDURE pi-validar-imp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF CAN-FIND(FIRST def-transportes WHERE 
                def-transportes.cod-estabel    = tt-def-transportes-import.cod-estabel AND
                def-transportes.cod-uf         = tt-def-transportes-import.cod-uf      AND
                def-transportes.cod-cidade     = tt-def-transportes-import.cod-cidade  AND
                def-transportes.cod-cliente    = tt-def-transportes-import.cod-cliente AND
                def-transportes.cd-unid-comerc = tt-def-transportes-import.cd-unid-comerc) THEN DO:

        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Definiá∆o de Transportadora j† existente."
               rowErrors.ErrorHelp        = "Definiá∆o de Transportadora j† existente! Linha: " + STRING(tt-def-transportes-import.linha).
        RETURN "NOK":U.
    END.

    IF NOT CAN-FIND(FIRST estabelec WHERE estabelec.cod-estabel = tt-def-transportes-import.cod-estabel) THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Estabelecimento inv†lido."
               rowErrors.ErrorHelp        = "C¢digo do Estabelecimento deve ser informado corretamente! Linha: " + STRING(tt-def-transportes-import.linha).
        RETURN "NOK":U.
    END.

    IF NOT CAN-FIND(FIRST transporte WHERE transporte.cod-transp = tt-def-transportes-import.cod-trans) THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Transportadora inv†lida."
               rowErrors.ErrorHelp        = "C¢digo da Transportadora deve ser informado corretamente! Linha: " + STRING(tt-def-transportes-import.linha).
        RETURN "NOK":U.
    END.

    IF tt-def-transportes-import.cod-cidade <> "":U THEN DO:
        IF NOT CAN-FIND(FIRST mgcad.cidade 
                  WHERE cidade.cidade = tt-def-transportes-import.cod-cidade 
                    AND cidade.estado = tt-def-transportes-import.cod-uf) THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Cidade Destino inv†lida."
                   rowErrors.ErrorHelp        = "Cidade Destino deve ser informado corretamente! Linha: " + STRING(tt-def-transportes-import.linha).
            RETURN "NOK":U.
        END.

        IF NOT CAN-FIND(FIRST unid-feder WHERE unid-feder.estado = tt-def-transportes-import.cod-uf) THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "UF Destino inv†lido."
                   rowErrors.ErrorHelp        = "UF Destino deve ser informado corretamente! Linha: " + STRING(tt-def-transportes-import.linha).
            RETURN "NOK":U.
        END.
    END.
    ELSE DO:

        IF tt-def-transportes-import.cod-uf <> "":U THEN DO:
            IF NOT CAN-FIND(FIRST unid-feder WHERE unid-feder.estado = tt-def-transportes-import.cod-uf) THEN DO:
                CREATE rowErrors.
                ASSIGN rowErrors.ErrorNumber      = 17006
                       rowErrors.ErrorType        = "EMS":U
                       rowErrors.ErrorSubType     = "Error"
                       rowErrors.ErrorDescription = "UF Destino inv†lido."
                       rowErrors.ErrorHelp        = "UF Destino deve ser informado corretamente! Linha: " + STRING(tt-def-transportes-import.linha).
                RETURN "NOK":U.
            END.
        END.
    END.

    IF tt-def-transportes-import.cod-cliente <> "" THEN DO:
        IF NOT CAN-FIND(FIRST emitente WHERE emitente.cod-emitente = INT(tt-def-transportes-import.cod-cliente)) THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Cliente Destino inv†lido."
                   rowErrors.ErrorHelp        = "Cliente Destino deve ser informado corretamente! Linha: " + STRING(tt-def-transportes-import.linha).
            RETURN "NOK":U.
        END.
    END.

    IF  tt-def-transportes-import.cd-unid-comerc <> 0 THEN DO:
        IF  NOT CAN-FIND(FIRST unid-comerc NO-LOCK
                         WHERE unid-comerc.cd-unid-comerc = tt-def-transportes-import.cd-unid-comerc) THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Unidade Comercial inv†lida."
                   rowErrors.ErrorHelp        = "Unidade Comercial deve ser informada corretamente! Linha: " + STRING(tt-def-transportes-import.linha).
            RETURN "NOK":U.
        END.
    END.

    IF tt-def-transportes-import.cod-cliente = "":U AND tt-def-transportes-import.cod-uf = "":U AND tt-def-transportes-import.cod-cidade = "":U THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Arquivo inv†lido."
               rowErrors.ErrorHelp        = "ê Necess†rio Informar ao menos um dos campos (Cliente Destino, Cidade Destino ou UF Destino).".
        RETURN "NOK":U.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

