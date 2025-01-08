&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-faturamento NO-UNDO LIKE faturamento
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-faturamento-segmento-ordem NO-UNDO LIKE faturamento-segmento-ordem
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
{include/i-prgvrs.i esftp110 1.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESFTP110
&GLOBAL-DEFINE Version        1

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   <Folder1 ,Folder 2 ,... , Folder8>

&GLOBAL-DEFINE First          NO
&GLOBAL-DEFINE Prev           NO
&GLOBAL-DEFINE Next           NO
&GLOBAL-DEFINE Last           NO
&GLOBAL-DEFINE GoTo           NO
&GLOBAL-DEFINE Search         NO

&GLOBAL-DEFINE Add            NO
&GLOBAL-DEFINE Copy           NO
&GLOBAL-DEFINE Update         NO
&GLOBAL-DEFINE Delete         NO
&GLOBAL-DEFINE Undo           NO
&GLOBAL-DEFINE Cancel         NO
&GLOBAL-DEFINE Save           NO

&GLOBAL-DEFINE ttTable        tt-faturamento-segmento-ordem
&GLOBAL-DEFINE hDBOTable      bofaturamento-segmento-ordem
&GLOBAL-DEFINE DBOTable       faturamento-segmento-ordem

&GLOBAL-DEFINE page0KeyFields 
&GLOBAL-DEFINE page0Fields    
&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    

&GLOBAL-DEFINE BrowseName brMain
&GLOBAL-DEFINE FRAME-NAME fpage0
&GLOBAL-DEFINE onDblClick onDblClick
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE v-unid-neg-ini AS CHARACTER NO-UNDO VIEW-AS FILL-IN SIZE 17 BY 0.88 FORMAT "X(20)".
DEFINE VARIABLE v-unid-neg-fim AS CHARACTER init "ZZZZZZZZZZZZZZZZZZZ" NO-UNDO  VIEW-AS FILL-IN SIZE 20 BY 0.88 FORMAT "X(20)".
DEFINE VARIABLE v-segmento-ini AS CHARACTER NO-UNDO  VIEW-AS FILL-IN SIZE 20 BY 0.88 FORMAT "X(30)".
DEFINE VARIABLE v-segmento-fim AS CHARACTER init "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" NO-UNDO  VIEW-AS FILL-IN SIZE 20 BY 0.88 FORMAT "X(30)".

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.

DEFINE VARIABLE iqtd         AS INTEGER NO-UNDO.
DEFINE VARIABLE c-acao       AS CHARACTER NO-UNDO.
DEFINE VARIABLE v-sel        AS LOGICAL NO-UNDO.

{upc/btb910za-upc.i} /* Defini‡Æo do estabelecimento do usu rio */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brMain

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-faturamento-segmento-ordem

/* Definitions for BROWSE brMain                                        */
&Scoped-define FIELDS-IN-QUERY-brMain tt-faturamento-segmento-ordem.ordem ~
tt-faturamento-segmento-ordem.segmento ~
tt-faturamento-segmento-ordem.unid-neg ~
tt-faturamento-segmento-ordem.mercado 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brMain 
&Scoped-define QUERY-STRING-brMain FOR EACH tt-faturamento-segmento-ordem NO-LOCK ~
    BY tt-faturamento-segmento-ordem.ordem
&Scoped-define OPEN-QUERY-brMain OPEN QUERY brMain FOR EACH tt-faturamento-segmento-ordem NO-LOCK ~
    BY tt-faturamento-segmento-ordem.ordem.
&Scoped-define TABLES-IN-QUERY-brMain tt-faturamento-segmento-ordem
&Scoped-define FIRST-TABLE-IN-QUERY-brMain tt-faturamento-segmento-ordem


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brMain}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 rtToolBar btFiltro btQueryJoins ~
btReportsJoins btExit btHelp bt-importar bt-layout brMain btIncluir ~
btAlterar btCopiar btEliminar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
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
DEFINE BUTTON bt-importar 
     LABEL "Importar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-layout 
     LABEL "Layout" 
     SIZE 10 BY 1.

DEFINE BUTTON btAlterar 
     LABEL "&Alterar" 
     SIZE 10 BY 1.

DEFINE BUTTON btCopiar 
     LABEL "&Copiar" 
     SIZE 10 BY 1.

DEFINE BUTTON btEliminar 
     LABEL "&Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFiltro 
     IMAGE-UP FILE "image/im-fil.bmp":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25 TOOLTIP "Filtro"
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btIncluir 
     LABEL "&Incluir" 
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

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brMain FOR 
      tt-faturamento-segmento-ordem SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brMain
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brMain wMaintenance _STRUCTURED
  QUERY brMain NO-LOCK DISPLAY
      tt-faturamento-segmento-ordem.ordem COLUMN-LABEL "Ordem" FORMAT ">>>>9":U
      tt-faturamento-segmento-ordem.segmento COLUMN-LABEL "Segmento" FORMAT "x(30)":U
      tt-faturamento-segmento-ordem.unid-neg FORMAT "x(20)":U
      tt-faturamento-segmento-ordem.mercado COLUMN-LABEL "Mercado" FORMAT "x(15)":U
            WIDTH 58
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 88.57 BY 8.83
         FONT 1 FIT-LAST-COLUMN TOOLTIP "Duplo-clique para alterar linha".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btFiltro AT ROW 1.13 COL 2 HELP
          "Consultas relacionadas" WIDGET-ID 14
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     bt-importar AT ROW 1.25 COL 53 WIDGET-ID 10
     bt-layout AT ROW 1.25 COL 63 WIDGET-ID 12
     brMain AT ROW 2.5 COL 1.57
     btIncluir AT ROW 11.75 COL 2
     btAlterar AT ROW 11.75 COL 12
     btCopiar AT ROW 11.75 COL 22
     btEliminar AT ROW 11.75 COL 32
     RECT-1 AT ROW 11.5 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 13
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance Template
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-faturamento T "?" NO-UNDO mgesp faturamento
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-faturamento-segmento-ordem T "?" NO-UNDO mgesp faturamento-segmento-ordem
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
         HEIGHT             = 12.88
         WIDTH              = 90
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenance 
/* ************************* Included-Libraries *********************** */

{maintenance/maintenance.i}
{esp/BrowseMgnt.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenance
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB brMain bt-layout fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brMain
/* Query rebuild information for BROWSE brMain
     _TblList          = "Temp-Tables.tt-faturamento-segmento-ordem"
     _Options          = "NO-LOCK"
     _TblOptList       = ","
     _OrdList          = "Temp-Tables.tt-faturamento-segmento-ordem.ordem|yes"
     _FldNameList[1]   > Temp-Tables.tt-faturamento-segmento-ordem.ordem
"tt-faturamento-segmento-ordem.ordem" "Ordem" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-faturamento-segmento-ordem.segmento
"tt-faturamento-segmento-ordem.segmento" "Segmento" "x(30)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-faturamento-segmento-ordem.unid-neg
"tt-faturamento-segmento-ordem.unid-neg" ? "x(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-faturamento-segmento-ordem.mercado
"tt-faturamento-segmento-ordem.mercado" "Mercado" "x(15)" "character" ? ? ? ? ? ? no ? no no "58" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brMain */
&ANALYZE-RESUME

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


&Scoped-define SELF-NAME bt-importar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-importar wMaintenance
ON CHOOSE OF bt-importar IN FRAME fpage0 /* Importar */
DO:
    DEFINE VARIABLE h-acomp   AS HANDLE      NO-UNDO.
    DEFINE VARIABLE c-arquivo AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-ok      AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE i-cont    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-linha   AS CHARACTER   FORMAT "X(200)" NO-UNDO.

    EMPTY TEMP-TABLE tt-faturamento-segmento-ordem.
    ASSIGN i-cont = 0.
    
    /* Solicita arquivo que ser  importado */
    SYSTEM-DIALOG GET-FILE c-arquivo
            TITLE      "Importar Dados"
            FILTERS    "Arquivos de texto (*.csv)" "*.csv"
            INITIAL-DIR SESSION:TEMP-DIRECTORY
            MUST-EXIST
            USE-FILENAME
            UPDATE l-ok.

    IF  NOT l-ok THEN
        RETURN "NOK":U.
    
    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    RUN pi-inicializar IN h-acomp (INPUT "Importando Dados").

    /* Importa as Notas de um arquivo */
    INPUT FROM VALUE(c-arquivo) NO-ECHO.
    REPEAT:

        IMPORT UNFORMATTED c-linha.

        FIND FIRST faturamento-segmento-ordem EXCLUSIVE-LOCK
            WHERE faturamento-segmento-ordem.ordem    = INT(ENTRY(2, c-linha, ";"))
              AND faturamento-segmento-ordem.segmento = ENTRY(3, c-linha, ";")
              AND faturamento-segmento-ordem.unid-neg = ENTRY(4, c-linha, ";")
              AND faturamento-segmento-ordem.mercado  = ENTRY(5, c-linha, ";") NO-ERROR.

        ASSIGN c-acao = ENTRY(1, c-linha, ";").

        IF c-acao BEGINS "i" THEN DO:

            IF AVAIL faturamento-segmento-ordem THEN DO:
                
                ASSIGN faturamento-segmento-ordem.ordem     = INT(ENTRY(2, c-linha, ";"))
                       faturamento-segmento-ordem.segmento  = ENTRY(3, c-linha, ";")
                       faturamento-segmento-ordem.unid-neg  = ENTRY(4, c-linha, ";")
                       faturamento-segmento-ordem.mercado   = ENTRY(5, c-linha, ";").
            END.

            ELSE DO:
                CREATE faturamento-segmento-ordem.
                ASSIGN faturamento-segmento-ordem.ordem     = INT(ENTRY(2, c-linha, ";"))
                       faturamento-segmento-ordem.segmento  = ENTRY(3, c-linha, ";")
                       faturamento-segmento-ordem.unid-neg  = ENTRY(4, c-linha, ";")
                       faturamento-segmento-ordem.mercado   = ENTRY(5, c-linha, ";").
            END.
        END.

        IF c-acao BEGINS "e" THEN DO:
            IF AVAIL faturamento-segmento-ordem THEN
                DELETE faturamento-segmento-ordem.
        END.
    END.

    INPUT CLOSE.
    IF  VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    /* Efetiva‡Æo dos dados */
    /* NÆo busca o £ltimo registro criado, com as informa‡äes em branco! */
    
    IF  CAN-FIND(FIRST rowErrors) THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2 &Modal="YES"}
        {method/showmessage.i3}
    END.
    ELSE DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 15825,
                           INPUT "Importa‡Æo conclu¡da!":U).
    END.
    
    RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-layout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-layout wMaintenance
ON CHOOSE OF bt-layout IN FRAME fpage0 /* Layout */
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
                      FILL(" ",46) + "Layout de Importa‡Æo" + CHR(13) +
                      FILL("-",124)                         + CHR(13) + CHR(13) +
                      "O arquivo com os dados de faturamento deve seguir o padrÆo abaixo:" + CHR(13) +
                      "A‡Æo;Ordem;Segmento;Unidade de negocio;Mercado;" + CHR(13) + CHR(13) +
                      "i;201;Telefone sem fio;ICO;Interno;"  + CHR(13) +
                      "e;201;Telefone sem fio;ICO;Interno;"  + CHR(13).
    
    DEFINE FRAME fLayout
        c-editor        AT ROW 1.21 COL 1 COLON-ALIGNED VIEW-AS EDITOR SIZE 54 BY 7 NO-LABEL
        btLayoutFechar  AT ROW 8.53 COL 2
        rtGoToButton    AT ROW 8.28 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Layout de Importa‡Æo" FONT 1
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


&Scoped-define SELF-NAME btAlterar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAlterar wMaintenance
ON CHOOSE OF btAlterar IN FRAME fpage0 /* Alterar */
DO:
    IF BROWSE brMain:NUM-ITERATIONS > 0
        AND BROWSE brMain:NUM-SELECTED-ROWS > 0 THEN DO:
        BROWSE brMain:FETCH-SELECTED-ROW(1).
    
        wMaintenance:SENSITIVE = NO.
        RUN esp/ftp/esftp110a.w (INPUT THIS-PROCEDURE, 
                                 INPUT {&hDBOTable},
                                 INPUT "update",
                                 INPUT tt-faturamento-segmento-ordem.r-rowid).
        wMaintenance:SENSITIVE = YES.    
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCopiar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopiar wMaintenance
ON CHOOSE OF btCopiar IN FRAME fpage0 /* Copiar */
DO:
    IF BROWSE brMain:NUM-ITERATIONS > 0 
    AND BROWSE brMain:NUM-SELECTED-ROWS > 0 THEN DO:
        BROWSE brMain:FETCH-SELECTED-ROW(1).
    
        wMaintenance:SENSITIVE = NO.
        RUN esp/ftp/esftp110a.w (INPUT THIS-PROCEDURE, 
                                 INPUT {&hDBOTable}, 
                                 INPUT "copy",
                                 INPUT tt-faturamento-segmento-ordem.r-rowid).
        wMaintenance:SENSITIVE = YES.    
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btEliminar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btEliminar wMaintenance
ON CHOOSE OF btEliminar IN FRAME fpage0 /* Eliminar */
DO:
    IF BROWSE brMain:NUM-ITERATIONS > 0 
    AND BROWSE brMain:NUM-SELECTED-ROWS > 0    
        THEN DO:
        BROWSE brMain:FETCH-SELECTED-ROW(1).
        run utp/ut-msgs.p (input "show",
                           input 550,
                           input "").
        IF RETURN-VALUE = "yes" THEN DO:
            RUN repositionRecord IN {&hDBOTable} (INPUT tt-faturamento-segmento-ordem.r-rowid).
            RUN emptyRowErrors IN {&hDBOTable}.
            RUN deleteRecord IN {&hDBOTable}.
            RUN getRowErrors IN {&hDBOTable} (OUTPUT TABLE RowErrors).
            IF CAN-FIND(FIRST RowErrors) THEN DO:
                {method/ShowMessage.i1}.
                {method/ShowMessage.i2 &Modal="YES"}.
                {method/ShowMessage.i3}. 
                RETURN NO-APPLY.
            END.
            DELETE tt-faturamento-segmento-ordem.
            {&OPEN-QUERY-brMain}  
        END.

    END.
  
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


&Scoped-define SELF-NAME btFiltro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFiltro wMaintenance
ON CHOOSE OF btFiltro IN FRAME fpage0 /* Query Joins */
DO:
  RUN pi-pesquisa.
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


&Scoped-define SELF-NAME btIncluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btIncluir wMaintenance
ON CHOOSE OF btIncluir IN FRAME fpage0 /* Incluir */
DO:
   wMaintenance:SENSITIVE = NO.
   RUN esp/ftp/esftp110a.w (INPUT THIS-PROCEDURE, 
                            INPUT {&hDBOTable}, 
                            INPUT "add",
                            INPUT ?).
   wMaintenance:SENSITIVE = YES.    
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


&Scoped-define BROWSE-NAME brMain
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenance/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDisplayFields wMaintenance 
PROCEDURE AfterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN initializeDBOs IN THIS-PROCEDURE.

    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    RUN getBatchRecords IN {&hDBOTable} (INPUT ?,
                                         INPUT ?,
                                         INPUT 0,
                                         OUTPUT iqtd,
                                         OUTPUT TABLE tt-faturamento-segmento-ordem).
    
    {&OPEN-QUERY-brMain}
    
    ENABLE ALL WITH FRAME fPage0.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitializeDBOS wMaintenance 
PROCEDURE InitializeDBOS :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "esbo/boes914.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes917.p YES}
        {btb/btb008za.i2 esbo/boes917.p '' {&hDBOTable}}
    END.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE onDblClick wMaintenance 
PROCEDURE onDblClick :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    APPLY "choose" TO btAlterar IN FRAME fPage0.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-pesquisa wMaintenance 
PROCEDURE pi-pesquisa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR iqtd AS INT NO-UNDO.

    DEFINE BUTTON btBuscaCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btBuscaOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtBuscaButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 65 BY 1.42
         BGCOLOR 7.
    
    DEFINE FRAME fBusca
        v-unid-neg-ini AT ROW 1.21 COL 15.0 COLON-ALIGNED LABEL "Unidade de Negocio"
        v-unid-neg-fim AT ROW 1.21 COL 36.0 COLON-ALIGNED NO-LABEL
        v-segmento-ini AT ROW 2.21 COL 15.0 COLON-ALIGNED LABEL "Segmento"
        v-segmento-fim AT ROW 2.21 COL 36.0 COLON-ALIGNED NO-LABEL 
        btBuscaOK      AT ROW 7.63 COL 2.14
        btBuscaCancel  AT ROW 7.63 COL 13
        rtBuscaButton  AT ROW 7.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Faixa" FONT 1
             DEFAULT-BUTTON btBuscaOK CANCEL-BUTTON btBuscaCancel.
    
    ON "CHOOSE":U OF btBuscaOK IN FRAME fBusca DO:
        ASSIGN INPUT FRAME fBusca v-unid-neg-ini      
               INPUT FRAME fBusca v-unid-neg-fim
               INPUT FRAME fBusca v-segmento-ini 
               INPUT FRAME fBusca v-segmento-fim. 

        RUN setConstraintSequencia IN {&hDBOTable} (INPUT v-unid-neg-ini,
                                                    INPUT v-unid-neg-fim,
                                                    INPUT v-segmento-ini,
                                                    INPUT v-segmento-fim).  

        RUN openQueryStatic IN {&hDBOTable} (INPUT "Sequencia":U) NO-ERROR.

        IF  v-unid-neg-ini = "" 
        AND v-unid-neg-fim = "ZZZZZZZZZZZZZZZ"
        AND v-segmento-ini = ""
        AND v-segmento-fim = "ZZZZZZZZZZZZZZZ"
        THEN iqtd = 40.
        ELSE iqtd = ?.

        SESSION:SET-WAIT-STATE("GENERAL":U).
        STATUS DEFAULT "Lendo registros, aguarde...".

        RUN getBatchRecords IN {&hDBOTable} (INPUT ?,
                                             INPUT ?,
                                             INPUT iqtd,
                                             OUTPUT iqtd,
                                             OUTPUT TABLE tt-faturamento-segmento-ordem).

        SESSION:SET-WAIT-STATE("":U).
        STATUS DEFAULT "".
        {&OPEN-QUERY-brMain}

        v-sel = YES.
        APPLY "GO":U TO FRAME fBusca.
    END.

    ON 'choose':U OF btBuscaCancel IN FRAME fBusca DO:
        APPLY "GO":U TO FRAME fBusca.
        RETURN NO-APPLY.
    END.

    ENABLE  v-unid-neg-ini
            v-unid-neg-fim
            v-segmento-ini
            v-segmento-fim
        btBuscaOK btBuscaCancel 
        WITH FRAME fBusca. 

    ASSIGN  v-unid-neg-ini:SCREEN-VALUE IN FRAME fBusca  = STRING(v-unid-neg-ini)        
            v-unid-neg-fim:SCREEN-VALUE IN FRAME fBusca = STRING(v-unid-neg-fim)
            v-segmento-ini:SCREEN-VALUE IN FRAME fBusca  = STRING(v-segmento-ini) 
            v-segmento-fim:SCREEN-VALUE IN FRAME fBusca  = STRING(v-segmento-fim). 
    
    WAIT-FOR "GO":U OF FRAME fBusca.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

