&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*****************************************************************************
** Programa: esp/ftp/esftp096.w
** VersÆo..: 1.00
** Data....: 20/11/2013
** Autor...: Estevan Krger - Sensus
** Obs.....: Cadastro de Sal rio Vari vel do Colaborador
*****************************************************************************/
{include/i-prgvrs.i ESFTP096 2.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESFTP096
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-nome-colab  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-registro    AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-erro        AS LOGICAL     NO-UNDO.

/* Vari veis utilizadas no filtro de sele‡Æo de registros */
DEFINE VARIABLE c-cod-colab-ini      AS CHARACTER FORMAT "x(8)"   NO-UNDO.
DEFINE VARIABLE c-cod-colab-fim      AS CHARACTER FORMAT "x(8)"   NO-UNDO.
DEFINE VARIABLE c-nome-colab-ini     AS CHARACTER FORMAT "x(50)"  NO-UNDO.
DEFINE VARIABLE c-nome-colab-fim     AS CHARACTER FORMAT "x(50)"  NO-UNDO.
DEFINE VARIABLE i-cod-rep-ini        AS INTEGER   FORMAT ">>>>9"  NO-UNDO.
DEFINE VARIABLE i-cod-rep-fim        AS INTEGER   FORMAT ">>>>9"  NO-UNDO.
DEFINE VARIABLE c-fm-cod-com-ini-ini AS CHARACTER FORMAT "x(8)"   NO-UNDO.
DEFINE VARIABLE c-fm-cod-com-ini-fim AS CHARACTER FORMAT "x(8)"   NO-UNDO.
DEFINE VARIABLE c-fm-cod-com-fim-ini AS CHARACTER FORMAT "x(8)"   NO-UNDO.
DEFINE VARIABLE c-fm-cod-com-fim-fim AS CHARACTER FORMAT "x(8)"   NO-UNDO.

DEFINE TEMP-TABLE tt-colab-salario-var-imp NO-UNDO
    FIELD cod-colab       LIKE colab-salario-var.cod-colab
    FIELD vl-teto         LIKE colab-salario-var.vl-teto
    FIELD vl-fixo         LIKE colab-salario-var.vl-fixo
    FIELD cod-rep         LIKE colab-salario-var.cod-rep
    FIELD fm-cod-com-ini  LIKE colab-salario-var.fm-cod-com-ini
    FIELD fm-cod-com-fim  LIKE colab-salario-var.fm-cod-com-fim
    FIELD pc-variavel     LIKE colab-salario-var.pc-variavel
    FIELD dt-vigencia-ini LIKE colab-salario-var.dt-vigencia-ini
    FIELD dt-vigencia-fim LIKE colab-salario-var.dt-vigencia-fim
    FIELD obs             LIKE colab-salario-var.obs
    FIELD linha           AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brColab

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES colab-salario-var

/* Definitions for BROWSE brColab                                       */
&Scoped-define FIELDS-IN-QUERY-brColab colab-salario-var.cod-colab ~
fnNomeColab(colab-salario-var.cod-colab) @ c-nome-colab ~
colab-salario-var.vl-teto colab-salario-var.vl-fixo ~
colab-salario-var.cod-rep colab-salario-var.fm-cod-com-ini ~
colab-salario-var.fm-cod-com-fim colab-salario-var.pc-variavel ~
colab-salario-var.dt-vigencia-ini colab-salario-var.dt-vigencia-fim ~
colab-salario-var.obs 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brColab 
&Scoped-define QUERY-STRING-brColab FOR EACH colab-salario-var ~
      WHERE colab-salario-var.cod-colab      >= c-cod-colab-ini ~
      AND   colab-salario-var.cod-colab      <= c-cod-colab-fim ~
      AND   colab-salario-var.cod-rep        >= i-cod-rep-ini ~
      AND   colab-salario-var.cod-rep        <= i-cod-rep-fim ~
      AND   colab-salario-var.fm-cod-com-ini >= c-fm-cod-com-ini-ini ~
      AND   colab-salario-var.fm-cod-com-ini <= c-fm-cod-com-ini-fim ~
      AND   colab-salario-var.fm-cod-com-fim >= c-fm-cod-com-fim-ini ~
      AND   colab-salario-var.fm-cod-com-fim <= c-fm-cod-com-fim-fim NO-LOCK ~
    BY colab-salario-var.cod-colab ~
       BY colab-salario-var.dt-vigencia-ini INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brColab OPEN QUERY brColab FOR EACH colab-salario-var ~
      WHERE colab-salario-var.cod-colab      >= c-cod-colab-ini ~
      AND   colab-salario-var.cod-colab      <= c-cod-colab-fim ~
      AND   colab-salario-var.cod-rep        >= i-cod-rep-ini ~
      AND   colab-salario-var.cod-rep        <= i-cod-rep-fim ~
      AND   colab-salario-var.fm-cod-com-ini >= c-fm-cod-com-ini-ini ~
      AND   colab-salario-var.fm-cod-com-ini <= c-fm-cod-com-ini-fim ~
      AND   colab-salario-var.fm-cod-com-fim >= c-fm-cod-com-fim-ini ~
      AND   colab-salario-var.fm-cod-com-fim <= c-fm-cod-com-fim-fim NO-LOCK ~
    BY colab-salario-var.cod-colab ~
       BY colab-salario-var.dt-vigencia-ini INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brColab colab-salario-var
&Scoped-define FIRST-TABLE-IN-QUERY-brColab colab-salario-var


/* Definitions for FRAME fPage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage0 ~
    ~{&OPEN-QUERY-brColab}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 btQueryJoins btReportsJoins ~
btExit btHelp btImportar btLayout brColab btIncluir btCopiar btAlterar ~
btEliminar btFiltro 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnNomeColab wWindow 
FUNCTION fnNomeColab RETURNS CHARACTER
  (pColab AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
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
DEFINE BUTTON btAlterar 
     LABEL "Alterar" 
     SIZE 10 BY 1.

DEFINE BUTTON btCopiar 
     LABEL "Copiar" 
     SIZE 10 BY 1.

DEFINE BUTTON btEliminar 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.27
     FONT 4.

DEFINE BUTTON btFiltro 
     LABEL "Filtro" 
     SIZE 10 BY 1 TOOLTIP "Filtrar informa‡äes".

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.27
     FONT 4.

DEFINE BUTTON btImportar 
     LABEL "Importar" 
     SIZE 8 BY 1 TOOLTIP "Importar dados do Excel".

DEFINE BUTTON btIncluir 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btLayout 
     LABEL "Layout" 
     SIZE 8 BY 1 TOOLTIP "Exemplo de Layout para Importa‡Æo".

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.27
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.27
     FONT 4.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 134 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brColab FOR 
      colab-salario-var SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brColab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brColab wWindow _STRUCTURED
  QUERY brColab NO-LOCK DISPLAY
      colab-salario-var.cod-colab FORMAT "x(8)":U WIDTH 8.89
      fnNomeColab(colab-salario-var.cod-colab) @ c-nome-colab COLUMN-LABEL "Nome" FORMAT "x(50)":U
            WIDTH 20.56
      colab-salario-var.vl-teto FORMAT ">>>,>>9.99":U WIDTH 9
      colab-salario-var.vl-fixo FORMAT ">>>,>>9.99":U WIDTH 9
      colab-salario-var.cod-rep FORMAT ">>>>9":U WIDTH 8
      colab-salario-var.fm-cod-com-ini COLUMN-LABEL "Fam Inicial" FORMAT "x(8)":U
            WIDTH 9.56
      colab-salario-var.fm-cod-com-fim COLUMN-LABEL "Fam Final" FORMAT "x(8)":U
            WIDTH 9.56
      colab-salario-var.pc-variavel FORMAT ">>9.99":U WIDTH 6
      colab-salario-var.dt-vigencia-ini FORMAT "99/99/9999":U WIDTH 10
      colab-salario-var.dt-vigencia-fim FORMAT "99/99/9999":U WIDTH 10
      colab-salario-var.obs FORMAT "x(250)":U WIDTH 24.67
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 132.78 BY 13.77
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btQueryJoins AT ROW 1.13 COL 118.33 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 122.33 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 126.33 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 130.33 HELP
          "Ajuda"
     btImportar AT ROW 1.27 COL 97.11 HELP
          "Importar os dados de uma Planilha Excel" WIDGET-ID 28
     btLayout AT ROW 1.27 COL 105.22 HELP
          "Exemplo de Layout para Importa‡Æo" WIDGET-ID 30
     brColab AT ROW 2.77 COL 1.67 WIDGET-ID 200
     btIncluir AT ROW 16.63 COL 1.78 WIDGET-ID 2
     btCopiar AT ROW 16.63 COL 11.78 WIDGET-ID 4
     btAlterar AT ROW 16.63 COL 21.78 WIDGET-ID 8
     btEliminar AT ROW 16.63 COL 31.78 WIDGET-ID 6
     btFiltro AT ROW 16.63 COL 41.78 WIDGET-ID 10
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 134 BY 16.73
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "Cadastro Sal rio Vari vel"
         HEIGHT             = 16.73
         WIDTH              = 134
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 134.33
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 134.33
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
/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* BROWSE-TAB brColab btLayout fPage0 */
ASSIGN 
       brColab:COLUMN-RESIZABLE IN FRAME fPage0       = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brColab
/* Query rebuild information for BROWSE brColab
     _TblList          = "mgesp.colab-salario-var"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "mgesp.colab-salario-var.cod-colab|yes,mgesp.colab-salario-var.dt-vigencia-ini|yes"
     _Where[1]         = "mgesp.colab-salario-var.cod-colab      >= c-cod-colab-ini
      AND   mgesp.colab-salario-var.cod-colab      <= c-cod-colab-fim
      AND   mgesp.colab-salario-var.cod-rep        >= i-cod-rep-ini
      AND   mgesp.colab-salario-var.cod-rep        <= i-cod-rep-fim
      AND   mgesp.colab-salario-var.fm-cod-com-ini >= c-fm-cod-com-ini-ini
      AND   mgesp.colab-salario-var.fm-cod-com-ini <= c-fm-cod-com-ini-fim
      AND   mgesp.colab-salario-var.fm-cod-com-fim >= c-fm-cod-com-fim-ini
      AND   mgesp.colab-salario-var.fm-cod-com-fim <= c-fm-cod-com-fim-fim"
     _FldNameList[1]   > mgesp.colab-salario-var.cod-colab
"colab-salario-var.cod-colab" ? ? "character" ? ? ? ? ? ? no ? no no "8.89" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fnNomeColab(colab-salario-var.cod-colab) @ c-nome-colab" "Nome" "x(50)" ? ? ? ? ? ? ? no ? no no "20.56" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > mgesp.colab-salario-var.vl-teto
"colab-salario-var.vl-teto" ? ? "decimal" ? ? ? ? ? ? no ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > mgesp.colab-salario-var.vl-fixo
"colab-salario-var.vl-fixo" ? ? "decimal" ? ? ? ? ? ? no ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > mgesp.colab-salario-var.cod-rep
"colab-salario-var.cod-rep" ? ? "integer" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > mgesp.colab-salario-var.fm-cod-com-ini
"colab-salario-var.fm-cod-com-ini" "Fam Inicial" ? "character" ? ? ? ? ? ? no ? no no "9.56" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > mgesp.colab-salario-var.fm-cod-com-fim
"colab-salario-var.fm-cod-com-fim" "Fam Final" ? "character" ? ? ? ? ? ? no ? no no "9.56" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > mgesp.colab-salario-var.pc-variavel
"colab-salario-var.pc-variavel" ? ? "decimal" ? ? ? ? ? ? no ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > mgesp.colab-salario-var.dt-vigencia-ini
"colab-salario-var.dt-vigencia-ini" ? ? "date" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > mgesp.colab-salario-var.dt-vigencia-fim
"colab-salario-var.dt-vigencia-fim" ? ? "date" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > mgesp.colab-salario-var.obs
"colab-salario-var.obs" ? ? "character" ? ? ? ? ? ? no ? no no "24.67" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brColab */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow /* Cadastro Sal rio Vari vel */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Cadastro Sal rio Vari vel */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brColab
&Scoped-define SELF-NAME brColab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brColab wWindow
ON ROW-DISPLAY OF brColab IN FRAME fPage0
DO:
    ASSIGN l-registro = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAlterar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAlterar wWindow
ON CHOOSE OF btAlterar IN FRAME fPage0 /* Alterar */
DO:
    RUN esp/ftp/esftp096a.w (INPUT "Modifica":U,
                             INPUT ROWID(colab-salario-var)).

    RUN pi-controla-browse.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCopiar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopiar wWindow
ON CHOOSE OF btCopiar IN FRAME fPage0 /* Copiar */
DO:
    RUN esp/ftp/esftp096a.w (INPUT "Copia":U,
                             INPUT ROWID(colab-salario-var)).

    RUN pi-controla-browse.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btEliminar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btEliminar wWindow
ON CHOOSE OF btEliminar IN FRAME fPage0 /* Eliminar */
DO:
    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 550,
                       INPUT "":U).
    IF  RETURN-VALUE = "YES" THEN DO:
        FIND CURRENT colab-salario-var EXCLUSIVE-LOCK NO-ERROR.
        DELETE colab-salario-var.

        RUN pi-controla-browse.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFiltro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFiltro wWindow
ON CHOOSE OF btFiltro IN FRAME fPage0 /* Filtro */
DO:
    RUN pi-filtro.
    RUN pi-controla-browse.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btImportar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImportar wWindow
ON CHOOSE OF btImportar IN FRAME fPage0 /* Importar */
DO:
    DEFINE VARIABLE h-acomp   AS HANDLE      NO-UNDO.
    DEFINE VARIABLE c-arquivo AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-ok      AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE i-cont    AS INTEGER     NO-UNDO.

    EMPTY TEMP-TABLE rowErrors.
    EMPTY TEMP-TABLE tt-colab-salario-var-imp.
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


    IF  NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    RUN pi-inicializar IN h-acomp (INPUT "Importando Dados").

    /* Importa as Notas de um arquivo */
    INPUT FROM VALUE(c-arquivo) NO-ECHO NO-CONVERT.
    REPEAT:
        ASSIGN i-cont = i-cont + 1.

        RUN pi-acompanhar IN h-acomp (INPUT "Importando linha " + STRING(i-cont)).

        CREATE tt-colab-salario-var-imp.
        ASSIGN tt-colab-salario-var-imp.linha = i-cont.
        IMPORT DELIMITER ";" tt-colab-salario-var-imp.
    END.
    INPUT CLOSE.

    IF  VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.


    /* Efetiva‡Æo dos dados */
    /* NÆo busca o £ltimo registro criado, com as informa‡äes em branco! */
    FOR EACH  tt-colab-salario-var-imp EXCLUSIVE-LOCK
        WHERE tt-colab-salario-var-imp.linha < i-cont
        BY    tt-colab-salario-var-imp.linha:

        RUN pi-validar-imp IN THIS-PROCEDURE.
        IF  RETURN-VALUE = "NOK":U THEN
            NEXT.

        CREATE colab-salario-var.
        BUFFER-COPY tt-colab-salario-var-imp TO colab-salario-var.
    END.

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

    RUN pi-controla-browse IN THIS-PROCEDURE.

    RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btIncluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btIncluir wWindow
ON CHOOSE OF btIncluir IN FRAME fPage0 /* Incluir */
DO:
    RUN esp/ftp/esftp096a.w (INPUT "Inclui":U,
                             INPUT ?).

    RUN pi-controla-browse.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLayout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLayout wWindow
ON CHOOSE OF btLayout IN FRAME fPage0 /* Layout */
DO:
    DEFINE BUTTON btLayoutFechar AUTO-END-KEY 
         LABEL "&Fechar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rect01
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE c-editor AS CHARACTER   NO-UNDO.

    ASSIGN c-editor = FILL("-",124)                         + CHR(13) +
                      FILL(" ",46) + "Layout de Importa‡Æo" + CHR(13) +
                      FILL("-",124)                         + CHR(13) + CHR(13) +
                      "O arquivo com os dados do cadastro de Sal rio Vari vel do Colaborador deve seguir o padrÆo abaixo:" + CHR(13) +
                      "C¢d Colaborador;Valor Teto;Valor Fixo;C¢d Repres;Fam Comerc Inicial; Fam Comerc Final;Perc Vari vel;Dt Vigˆncia Inicial;Dt Vigˆncia Final;Obs;" + CHR(13) + CHR(13) +
                      "AN046325;10000;6500;2100;13000000;13999999;1;01/01/2012;31/12/2013;exemplo de importacao;" + CHR(13) +
                      "AN046325;10000;6500;2100;34000000;34999999;1,5;01/01/2012/31/12/2013;novo exemplo;" + CHR(13).
    
    DEFINE FRAME fLayout
        c-editor        AT ROW 1.21 COL 1 COLON-ALIGNED VIEW-AS EDITOR SIZE 54 BY 7 NO-LABEL
        btLayoutFechar  AT ROW 8.53 COL 2
        rect01          AT ROW 8.28 COL 1
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


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fPage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fPage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

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

    ASSIGN c-cod-colab-ini      = ""
           c-cod-colab-fim      = "ZZZZZZZZ"
           c-nome-colab-ini     = ""
           c-nome-colab-fim     = "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
           i-cod-rep-ini        = 0
           i-cod-rep-fim        = 99999
           c-fm-cod-com-ini-ini = ""
           c-fm-cod-com-ini-fim = "ZZZZZZZZ"
           c-fm-cod-com-fim-ini = ""
           c-fm-cod-com-fim-fim = "ZZZZZZZZ".

    ENABLE btImportar
           btLayout
           brColab
           btIncluir
           btFiltro
        WITH FRAME fPage0.

    RUN pi-controla-browse.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-controla-browse wWindow 
PROCEDURE pi-controla-browse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN l-registro = NO.

    {&OPEN-QUERY-brColab}

    IF  l-registro THEN
        ENABLE btCopiar
               btAlterar
               btEliminar
            WITH FRAME fPage0.
    ELSE
        DISABLE btCopiar
                btAlterar
                btEliminar
            WITH FRAME fPage0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-filtro wWindow 
PROCEDURE pi-filtro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE BUTTON btFiltroCancelar AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 11 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btFiltroOK AUTO-GO 
         LABEL "&OK" 
         SIZE 11 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rect01
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
         
    DEFINE IMAGE im-first-1 FILENAME "image/im-fir.bmp":U
        SIZE 3 BY 1.

    DEFINE IMAGE im-last-1  FILENAME "image/im-las.bmp":U
        SIZE 3 BY 1.

    DEFINE IMAGE im-first-2 FILENAME "image/im-fir.bmp":U
        SIZE 3 BY 1.

    DEFINE IMAGE im-last-2  FILENAME "image/im-las.bmp":U
        SIZE 3 BY 1.

    DEFINE IMAGE im-first-3 FILENAME "image/im-fir.bmp":U
        SIZE 3 BY 1.

    DEFINE IMAGE im-last-3  FILENAME "image/im-las.bmp":U
        SIZE 3 BY 1.

    DEFINE IMAGE im-first-4 FILENAME "image/im-fir.bmp":U
        SIZE 3 BY 1.

    DEFINE IMAGE im-last-4  FILENAME "image/im-las.bmp":U
        SIZE 3 BY 1.

    DEFINE IMAGE im-first-5 FILENAME "image/im-fir.bmp":U
        SIZE 3 BY 1.

    DEFINE IMAGE im-last-5  FILENAME "image/im-las.bmp":U
        SIZE 3 BY 1.

    DEFINE FRAME fSelec
        c-cod-colab-ini      AT ROW 1.21 COL 15 COLON-ALIGNED VIEW-AS FILL-IN SIZE 9  BY .88 LABEL "C¢d Colab"
        im-first-1           AT ROW 1.25 COL 31 COLON-ALIGNED
        im-last-1            AT ROW 1.25 COL 36 COLON-ALIGNED
        c-cod-colab-fim      AT ROW 1.21 COL 41 COLON-ALIGNED VIEW-AS FILL-IN SIZE 9  BY .88 NO-LABEL

        c-nome-colab-ini     AT ROW 2.21 COL 15 COLON-ALIGNED VIEW-AS FILL-IN SIZE 14 BY .88 LABEL "Nome Colab"
        im-first-2           AT ROW 2.25 COL 31 COLON-ALIGNED
        im-last-2            AT ROW 2.25 COL 36 COLON-ALIGNED
        c-nome-colab-fim     AT ROW 2.21 COL 41 COLON-ALIGNED VIEW-AS FILL-IN SIZE 14 BY .88 NO-LABEL

        i-cod-rep-ini        AT ROW 3.21 COL 15 COLON-ALIGNED VIEW-AS FILL-IN SIZE 6  BY .88 LABEL "C¢d Repres"
        im-first-3           AT ROW 3.25 COL 31 COLON-ALIGNED
        im-last-3            AT ROW 3.25 COL 36 COLON-ALIGNED
        i-cod-rep-fim        AT ROW 3.21 COL 41 COLON-ALIGNED VIEW-AS FILL-IN SIZE 6  BY .88 NO-LABEL

        c-fm-cod-com-ini-ini AT ROW 4.21 COL 15 COLON-ALIGNED VIEW-AS FILL-IN SIZE 9  BY .88 LABEL "Fam Comerc Inicial"
        im-first-4           AT ROW 4.25 COL 31 COLON-ALIGNED
        im-last-4            AT ROW 4.25 COL 36 COLON-ALIGNED
        c-fm-cod-com-ini-fim AT ROW 4.21 COL 41 COLON-ALIGNED VIEW-AS FILL-IN SIZE 9  BY .88 NO-LABEL

        c-fm-cod-com-fim-ini AT ROW 5.21 COL 15 COLON-ALIGNED VIEW-AS FILL-IN SIZE 9  BY .88 LABEL "Fam Comerc Final"
        im-first-5           AT ROW 5.25 COL 31 COLON-ALIGNED
        im-last-5            AT ROW 5.25 COL 36 COLON-ALIGNED
        c-fm-cod-com-fim-fim AT ROW 5.21 COL 41 COLON-ALIGNED VIEW-AS FILL-IN SIZE 9  BY .88 NO-LABEL

        btFiltroOK           AT ROW 6.63 COL 2.14
        btFiltroCancelar     AT ROW 6.63 COL 13
        rect01               AT ROW 6.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Sele‡Æo Colaboradores" FONT 1
             DEFAULT-BUTTON btFiltroOK CANCEL-BUTTON btFiltroCancelar.

    ON "CHOOSE":U OF btFiltroOK IN FRAME fSelec DO:
        ASSIGN c-cod-colab-ini
               c-cod-colab-fim
               c-nome-colab-ini
               c-nome-colab-fim
               i-cod-rep-ini
               i-cod-rep-fim
               c-fm-cod-com-ini-ini
               c-fm-cod-com-ini-fim
               c-fm-cod-com-fim-ini
               c-fm-cod-com-fim-fim.

        APPLY "GO":U TO FRAME fSelec.
    END.

    ENABLE c-cod-colab-ini
           c-cod-colab-fim
           c-nome-colab-ini
           c-nome-colab-fim
           i-cod-rep-ini
           i-cod-rep-fim
           c-fm-cod-com-ini-ini
           c-fm-cod-com-ini-fim
           c-fm-cod-com-fim-ini
           c-fm-cod-com-fim-fim
           btFiltroOK
           btFiltroCancelar
        WITH FRAME fSelec.

    DISPLAY c-cod-colab-ini
            c-cod-colab-fim
            c-nome-colab-ini
            c-nome-colab-fim
            i-cod-rep-ini
            i-cod-rep-fim
            c-fm-cod-com-ini-ini
            c-fm-cod-com-ini-fim
            c-fm-cod-com-fim-ini
            c-fm-cod-com-fim-fim
        WITH FRAME fSelec.

    WAIT-FOR "GO":U OF FRAME fSelec.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validar-imp wWindow 
PROCEDURE pi-validar-imp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN l-erro = NO.

    IF  tt-colab-salario-var-imp.cod-colab = "" THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Colaborador nÆo informado!"
               rowErrors.ErrorHelp        = "C¢digo do colaborador deve ser informado. Linha: " + STRING(tt-colab-salario-var-imp.linha).

        ASSIGN l-erro = YES.
    END.
    ELSE DO:
        IF  NOT CAN-FIND(FIRST emsfnd.usuar_mestre NO-LOCK
                         WHERE usuar_mestre.cod_usuar = tt-colab-salario-var-imp.cod-colab) THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Colaborador nÆo encontrado!"
                   rowErrors.ErrorHelp        = "NÆo foi poss¡vel encontrar uma ocorrˆncia de colaborador para o c¢digo informado. Linha: " + STRING(tt-colab-salario-var-imp.linha).
        END.
    END.

    IF  tt-colab-salario-var-imp.cod-rep = 0 THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Representante nÆo informado!"
               rowErrors.ErrorHelp        = "C¢digo do representante deve ser informado. Linha: " + STRING(tt-colab-salario-var-imp.linha).

        ASSIGN l-erro = YES.
    END.
    ELSE DO:
        IF  NOT CAN-FIND(FIRST repres NO-LOCK
                         WHERE repres.cod-rep = tt-colab-salario-var-imp.cod-rep) THEN DO:
            CREATE rowErrors.
            ASSIGN rowErrors.ErrorNumber      = 17006
                   rowErrors.ErrorType        = "EMS":U
                   rowErrors.ErrorSubType     = "Error"
                   rowErrors.ErrorDescription = "Representante nÆo encontrado!"
                   rowErrors.ErrorHelp        = "NÆo foi poss¡vel encontrar uma ocorrˆncia de representante para o c¢digo informado. Linha: " + STRING(tt-colab-salario-var-imp.linha).

            ASSIGN l-erro = YES.
        END.
    END.

    IF  tt-colab-salario-var-imp.dt-vigencia-ini = ? THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Data de vigˆncia inicial inv lida!"
               rowErrors.ErrorHelp        = "Data de vigˆncia inicial deve ser uma data v lida. Linha: " + STRING(tt-colab-salario-var-imp.linha).
    END.

    IF  tt-colab-salario-var-imp.dt-vigencia-ini > tt-colab-salario-var-imp.dt-vigencia-fim THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Faixa de vigˆncia incorreta!"
               rowErrors.ErrorHelp        = "Data inicial da vigˆncia deve ser menor ou igual a data de vigˆncia final. Linha: " + STRING(tt-colab-salario-var-imp.linha).

        ASSIGN l-erro = YES.
    END.

    IF  CAN-FIND(FIRST colab-salario-var NO-LOCK
                 WHERE colab-salario-var.cod-colab       = tt-colab-salario-var-imp.cod-colab
                 AND   colab-salario-var.dt-vigencia-fim = ?) THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Faixa de vigˆncia em aberto para o colaborador!"
               rowErrors.ErrorHelp        = "Existe uma faixa de vigˆncia em aberto para este colaborador. Linha: " + STRING(tt-colab-salario-var-imp.linha).

        ASSIGN l-erro = YES.
    END.

    IF  tt-colab-salario-var-imp.pc-variavel <= 0   OR
        tt-colab-salario-var-imp.pc-variavel > 100 THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Percentual vari vel ‚ inv lido!"
               rowErrors.ErrorHelp        = "O percentual vari vel dever ser maior que 0 (zero) e menor ou igual a 100. Linha: " + STRING(tt-colab-salario-var-imp.linha).
    END.

    IF  tt-colab-salario-var-imp.vl-teto = 0 THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Valor de teto nÆo informado!"
               rowErrors.ErrorHelp        = "O valor de teto deve ser informado e diferente de 0 (zero). Linha: " + STRING(tt-colab-salario-var-imp.linha).
    END.

    IF  tt-colab-salario-var-imp.vl-fixo = 0 THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Valor fixo nÆo informado!"
               rowErrors.ErrorHelp        = "O valor fixo deve ser informado e diferente de 0 (zero). Linha: " + STRING(tt-colab-salario-var-imp.linha).
    END.

    IF  CAN-FIND(FIRST colab-salario-var NO-LOCK
                 WHERE colab-salario-var.cod-colab         = tt-colab-salario-var-imp.cod-colab
                 AND  ((colab-salario-var.fm-cod-com-ini  >= tt-colab-salario-var-imp.fm-cod-com-ini OR
                        colab-salario-var.fm-cod-com-fim  >= tt-colab-salario-var-imp.fm-cod-com-ini)
                        OR
                       (colab-salario-var.fm-cod-com-ini  >= tt-colab-salario-var-imp.fm-cod-com-fim OR
                        colab-salario-var.fm-cod-com-fim  >= tt-colab-salario-var-imp.fm-cod-com-fim))
                 AND  ((colab-salario-var.dt-vigencia-ini >= tt-colab-salario-var-imp.dt-vigencia-ini OR
                        colab-salario-var.dt-vigencia-fim >= tt-colab-salario-var-imp.dt-vigencia-ini)
                        OR
                       (colab-salario-var.dt-vigencia-ini >= tt-colab-salario-var-imp.dt-vigencia-fim OR
                        colab-salario-var.dt-vigencia-fim >= tt-colab-salario-var-imp.dt-vigencia-fim))) THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "Faixas de vigˆncia e/ou Fam Comerc em conflito com outro registro do colaborador!"
               rowErrors.ErrorHelp        = "A faixa de vigˆncia e/ou fam¡lia comercial informada est  em conflito com outro cadastro j  feito para este colaborador. Linha: " + STRING(tt-colab-salario-var-imp.linha).

        ASSIGN l-erro = YES.
    END.

    IF  CAN-FIND(FIRST colab-salario-var NO-LOCK
                 WHERE colab-salario-var.cod-colab       = tt-colab-salario-var-imp.cod-colab
                 AND   colab-salario-var.cod-rep         = tt-colab-salario-var-imp.cod-rep
                 AND   colab-salario-var.fm-cod-com-ini  = tt-colab-salario-var-imp.fm-cod-com-ini
                 AND   colab-salario-var.dt-vigencia-ini = tt-colab-salario-var-imp.dt-vigencia-ini) THEN DO:
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorNumber      = 17006
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = "Error"
               rowErrors.ErrorDescription = "J  existe uma ocorrˆncia de Sal rio Vari vel cadastrada para o Colaborador!"
               rowErrors.ErrorHelp        = "Sal rio vari vel do colaborado j  est  cadastrado para o representante, fam¡lia comercial e vigˆncia. Linha: " + STRING(tt-colab-salario-var-imp.linha).

        ASSIGN l-erro = YES.
    END.

    IF  l-erro THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnNomeColab wWindow 
FUNCTION fnNomeColab RETURNS CHARACTER
  (pColab AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FIND FIRST emsfnd.usuar_mestre NO-LOCK
        WHERE  usuar_mestre.cod_usuario = pColab NO-ERROR.

    ASSIGN c-nome-colab = IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE "".

    RETURN c-nome-colab.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

