&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-int-classe-cli-supcard NO-UNDO LIKE int-classe-cli-supcard
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE l-erro    AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-usuario AS CHARACTER   NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER FORMAT "x(12)" NO-UNDO.

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu rio Corrente"
    column-label "Usu rio Corrente"
    no-undo.

DEFINE VARIABLE r-rowid AS ROWID       NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME brClasses

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-int-classe-cli-supcard int-contas-supcard

/* Definitions for BROWSE brClasses                                     */
&Scoped-define FIELDS-IN-QUERY-brClasses ~
tt-int-classe-cli-supcard.cod-classe tt-int-classe-cli-supcard.des-classe ~
tt-int-classe-cli-supcard.val-limite-ini ~
tt-int-classe-cli-supcard.val-limite-fin ~
tt-int-classe-cli-supcard.val-taxa-adm ~
tt-int-classe-cli-supcard.val-taxa-canc-devol ~
tt-int-classe-cli-supcard.val-taxa-prorrog ~
tt-int-classe-cli-supcard.cod-cond-pag 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brClasses 
&Scoped-define QUERY-STRING-brClasses FOR EACH tt-int-classe-cli-supcard NO-LOCK ~
    BY tt-int-classe-cli-supcard.des-classe INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brClasses OPEN QUERY brClasses FOR EACH tt-int-classe-cli-supcard NO-LOCK ~
    BY tt-int-classe-cli-supcard.des-classe INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brClasses tt-int-classe-cli-supcard
&Scoped-define FIRST-TABLE-IN-QUERY-brClasses tt-int-classe-cli-supcard


/* Definitions for BROWSE brContas                                      */
&Scoped-define FIELDS-IN-QUERY-brContas int-contas-supcard.cod-conta ~
int-contas-supcard.tipo-despesa 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brContas 
&Scoped-define QUERY-STRING-brContas FOR EACH int-contas-supcard NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brContas OPEN QUERY brContas FOR EACH int-contas-supcard NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brContas int-contas-supcard
&Scoped-define FIRST-TABLE-IN-QUERY-brContas int-contas-supcard


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-brClasses}~
    ~{&OPEN-QUERY-brContas}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-1 RECT-2 RECT-3 ~
c-diretorio-remessa c-diretorio-retorno de-val-min-trans btHistoricoParam ~
de-val-min-parc i-qtd-dias-atraso brClasses btIncluirClasse ~
btModificarClasse btExcluirClasse btHistoricoClasse brContas btIncluirConta ~
btExcluirContas btOK btCancel text-param text-classe text-contas 
&Scoped-Define DISPLAYED-OBJECTS c-diretorio-remessa c-diretorio-retorno ~
de-val-min-trans de-val-min-parc i-qtd-dias-atraso text-param text-classe ~
text-contas 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btExcluirClasse 
     LABEL "&Excluir" 
     SIZE 10 BY 1 TOOLTIP "Excluir classe selecionada".

DEFINE BUTTON btExcluirContas 
     LABEL "E&xcluir" 
     SIZE 10 BY 1 TOOLTIP "Excluir classe selecionada".

DEFINE BUTTON btHistoricoClasse 
     LABEL "His&t¢rico" 
     SIZE 10 BY 1 TOOLTIP "Hist¢rico das altera‡äes".

DEFINE BUTTON btHistoricoParam 
     LABEL "&Hist¢rico" 
     SIZE 12 BY 1 TOOLTIP "Hist¢rico das altera‡äes".

DEFINE BUTTON btIncluirClasse 
     LABEL "&Incluir" 
     SIZE 10 BY 1 TOOLTIP "Incluir nova classe".

DEFINE BUTTON btIncluirConta 
     LABEL "I&ncluir" 
     SIZE 10 BY 1 TOOLTIP "Incluir nova classe".

DEFINE BUTTON btModificarClasse 
     LABEL "&Modificar" 
     SIZE 10 BY 1 TOOLTIP "Modificar classe selecionada".

DEFINE BUTTON btOK 
     LABEL "&Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-diretorio-remessa AS CHARACTER FORMAT "X(200)":U 
     LABEL "Diret¢rio Remessa" 
     VIEW-AS FILL-IN 
     SIZE 44.14 BY .88 TOOLTIP "Diret¢rio para os arquivos de remessa da SupplierCard" NO-UNDO.

DEFINE VARIABLE c-diretorio-retorno AS CHARACTER FORMAT "X(200)":U 
     LABEL "Diret¢rio Retorno" 
     VIEW-AS FILL-IN 
     SIZE 44.14 BY .88 TOOLTIP "Diret¢rio para os arquivos de retorno da SupplierCard" NO-UNDO.

DEFINE VARIABLE de-val-min-parc AS DECIMAL FORMAT ">>>,>>>,>>9.99" INITIAL 0 
     LABEL "Valor M¡nimo Parcela" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-min-trans AS DECIMAL FORMAT ">>>,>>>,>>9.99" INITIAL 0 
     LABEL "Valor M¡nimo Transa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE i-qtd-dias-atraso AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Dias de Atraso" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE text-classe AS CHARACTER FORMAT "X(50)":U INITIAL "Classe de Clientes" 
      VIEW-AS TEXT 
     SIZE 12.86 BY .67 NO-UNDO.

DEFINE VARIABLE text-contas AS CHARACTER FORMAT "X(50)":U INITIAL "Contas de Despesas" 
      VIEW-AS TEXT 
     SIZE 14.57 BY .67 NO-UNDO.

DEFINE VARIABLE text-param AS CHARACTER FORMAT "X(50)":U INITIAL "Parƒmetros do SupplierCard" 
      VIEW-AS TEXT 
     SIZE 19.14 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 5.67.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 6.67.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 6.67.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 89.72 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brClasses FOR 
      tt-int-classe-cli-supcard SCROLLING.

DEFINE QUERY brContas FOR 
      int-contas-supcard SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brClasses
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brClasses C-Win _STRUCTURED
  QUERY brClasses NO-LOCK DISPLAY
      tt-int-classe-cli-supcard.cod-classe COLUMN-LABEL "C¢d" FORMAT ">>9":U
            WIDTH 3.14
      tt-int-classe-cli-supcard.des-classe FORMAT "x(10)":U WIDTH 6.43
      tt-int-classe-cli-supcard.val-limite-ini COLUMN-LABEL "Limite Inicial" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 10
      tt-int-classe-cli-supcard.val-limite-fin COLUMN-LABEL "Limite Final" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 11.86
      tt-int-classe-cli-supcard.val-taxa-adm FORMAT ">>9.99":U
            WIDTH 7.43
      tt-int-classe-cli-supcard.val-taxa-canc-devol FORMAT ">>9.99":U
            WIDTH 11.43
      tt-int-classe-cli-supcard.val-taxa-prorrog FORMAT ">>9.99":U
      tt-int-classe-cli-supcard.cod-cond-pag FORMAT "x(200)":U
            WIDTH 50
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 65.72 BY 5.92
         FONT 1.

DEFINE BROWSE brContas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brContas C-Win _STRUCTURED
  QUERY brContas NO-LOCK DISPLAY
      int-contas-supcard.cod-conta FORMAT "9.9.9.99.999":U WIDTH 16.14
      int-contas-supcard.tipo-despesa FORMAT "x(100)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 65.72 BY 5.92
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     c-diretorio-remessa AT ROW 1.92 COL 25.86 COLON-ALIGNED HELP
          "Diret¢rio para os arquivos de remessa da SupplierCard" WIDGET-ID 48
     c-diretorio-retorno AT ROW 2.92 COL 25.86 COLON-ALIGNED HELP
          "Diret¢rio para os arquivos de retorno da SupplierCard" WIDGET-ID 60
     de-val-min-trans AT ROW 3.92 COL 25.86 COLON-ALIGNED WIDGET-ID 30
     btHistoricoParam AT ROW 3.92 COL 60 WIDGET-ID 24
     de-val-min-parc AT ROW 4.92 COL 25.86 COLON-ALIGNED WIDGET-ID 28
     i-qtd-dias-atraso AT ROW 5.92 COL 25.86 COLON-ALIGNED HELP
          "Dias de Atraso" WIDGET-ID 38
     brClasses AT ROW 8.21 COL 8.29
     btIncluirClasse AT ROW 8.21 COL 74.86 WIDGET-ID 44
     btModificarClasse AT ROW 9.33 COL 74.86 WIDGET-ID 46
     btExcluirClasse AT ROW 10.46 COL 74.86 WIDGET-ID 62
     btHistoricoClasse AT ROW 13.13 COL 74.86 WIDGET-ID 64
     brContas AT ROW 15.63 COL 8.29 WIDGET-ID 300
     btIncluirConta AT ROW 15.63 COL 74.86 WIDGET-ID 52
     btExcluirContas AT ROW 16.75 COL 74.86 WIDGET-ID 50
     btOK AT ROW 22.42 COL 2 WIDGET-ID 26
     btCancel AT ROW 22.42 COL 12.29 WIDGET-ID 22
     text-param AT ROW 1.08 COL 36.29 NO-LABEL WIDGET-ID 36
     text-classe AT ROW 7.42 COL 39.43 NO-LABEL WIDGET-ID 42
     text-contas AT ROW 14.83 COL 38.57 NO-LABEL WIDGET-ID 56
     rtToolBar AT ROW 22.21 COL 1 WIDGET-ID 34
     RECT-1 AT ROW 1.5 COL 2 WIDGET-ID 32
     RECT-2 AT ROW 7.83 COL 2 WIDGET-ID 40
     RECT-3 AT ROW 15.25 COL 2 WIDGET-ID 54
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 89.72 BY 22.67
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Temp-Tables and Buffers:
      TABLE: tt-int-classe-cli-supcard T "?" NO-UNDO mgesp int-classe-cli-supcard
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Parƒmetros SupplierCard"
         HEIGHT             = 22.67
         WIDTH              = 89.72
         MAX-HEIGHT         = 30.58
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 30.58
         VIRTUAL-WIDTH      = 182.86
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
/* BROWSE-TAB brClasses i-qtd-dias-atraso DEFAULT-FRAME */
/* BROWSE-TAB brContas btHistoricoClasse DEFAULT-FRAME */
ASSIGN 
       brClasses:COLUMN-RESIZABLE IN FRAME DEFAULT-FRAME       = TRUE
       brClasses:COLUMN-MOVABLE IN FRAME DEFAULT-FRAME         = TRUE.

/* SETTINGS FOR FILL-IN text-classe IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN text-contas IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN text-param IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brClasses
/* Query rebuild information for BROWSE brClasses
     _TblList          = "Temp-Tables.tt-int-classe-cli-supcard"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.tt-int-classe-cli-supcard.des-classe|yes"
     _FldNameList[1]   > Temp-Tables.tt-int-classe-cli-supcard.cod-classe
"tt-int-classe-cli-supcard.cod-classe" "C¢d" ? "integer" ? ? ? ? ? ? no ? no no "3.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-int-classe-cli-supcard.des-classe
"tt-int-classe-cli-supcard.des-classe" ? ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-int-classe-cli-supcard.val-limite-ini
"tt-int-classe-cli-supcard.val-limite-ini" "Limite Inicial" ? "decimal" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-int-classe-cli-supcard.val-limite-fin
"tt-int-classe-cli-supcard.val-limite-fin" "Limite Final" ? "decimal" ? ? ? ? ? ? no ? no no "11.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-int-classe-cli-supcard.val-taxa-adm
"tt-int-classe-cli-supcard.val-taxa-adm" ? ? "decimal" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-int-classe-cli-supcard.val-taxa-canc-devol
"tt-int-classe-cli-supcard.val-taxa-canc-devol" ? ? "decimal" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = Temp-Tables.tt-int-classe-cli-supcard.val-taxa-prorrog
     _FldNameList[8]   > Temp-Tables.tt-int-classe-cli-supcard.cod-cond-pag
"tt-int-classe-cli-supcard.cod-cond-pag" ? ? "character" ? ? ? ? ? ? no ? no no "50" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brClasses */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brContas
/* Query rebuild information for BROWSE brContas
     _TblList          = "mgesp.int-contas-supcard"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > mgesp.int-contas-supcard.cod-conta
"int-contas-supcard.cod-conta" ? "9.9.9.99.999" "character" ? ? ? ? ? ? no ? no no "16.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = mgesp.int-contas-supcard.tipo-despesa
     _Query            is OPENED
*/  /* BROWSE brContas */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME DEFAULT-FRAME
/* Query rebuild information for FRAME DEFAULT-FRAME
     _Query            is NOT OPENED
*/  /* FRAME DEFAULT-FRAME */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Parƒmetros SupplierCard */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Parƒmetros SupplierCard */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brClasses
&Scoped-define SELF-NAME brClasses
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brClasses C-Win
ON MOUSE-SELECT-DBLCLICK OF brClasses IN FRAME DEFAULT-FRAME
DO:
    IF AVAILABLE tt-int-classe-cli-supcard THEN
        APPLY "CHOOSE":U TO btModificarClasse IN FRAME DEFAULT-FRAME.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel C-Win
ON CHOOSE OF btCancel IN FRAME DEFAULT-FRAME /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExcluirClasse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExcluirClasse C-Win
ON CHOOSE OF btExcluirClasse IN FRAME DEFAULT-FRAME /* Excluir */
DO:
    IF  AVAIL tt-int-classe-cli-supcard THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 550,
                           INPUT "":U).
        IF  RETURN-VALUE = "YES" THEN DO:
            FIND CURRENT tt-int-classe-cli-supcard EXCLUSIVE-LOCK NO-ERROR.
            IF  AVAIL tt-int-classe-cli-supcard THEN DO:
                FIND FIRST int-classe-cli-supcard EXCLUSIVE-LOCK
                    WHERE  ROWID(int-classe-cli-supcard) = tt-int-classe-cli-supcard.r-rowid NO-ERROR.
                IF  AVAIL int-classe-cli-supcard THEN
                    DELETE int-classe-cli-supcard.
                
                DELETE tt-int-classe-cli-supcard.
            END.
          
            RUN pi-controla IN THIS-PROCEDURE.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExcluirContas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExcluirContas C-Win
ON CHOOSE OF btExcluirContas IN FRAME DEFAULT-FRAME /* Excluir */
DO:
    IF  AVAIL int-contas-supcard THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 550,
                           INPUT "":U).
        IF  RETURN-VALUE = "YES" THEN DO:
            FIND CURRENT int-contas-supcard EXCLUSIVE-LOCK NO-ERROR.
            IF  AVAIL int-contas-supcard THEN
                DELETE int-contas-supcard.
          
            RUN pi-controla-conta IN THIS-PROCEDURE.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHistoricoClasse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHistoricoClasse C-Win
ON CHOOSE OF btHistoricoClasse IN FRAME DEFAULT-FRAME /* Hist¢rico */
DO:
    RUN esp/acr/esacr036a.w (INPUT 2 /* Classe Cliente */).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHistoricoParam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHistoricoParam C-Win
ON CHOOSE OF btHistoricoParam IN FRAME DEFAULT-FRAME /* Hist¢rico */
DO:
    RUN esp/acr/esacr036a.w (INPUT 1 /* Parƒmetros SupplierCard */).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btIncluirClasse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btIncluirClasse C-Win
ON CHOOSE OF btIncluirClasse IN FRAME DEFAULT-FRAME /* Incluir */
DO:
    RUN esp/acr/esacr036b.w (INPUT {&WINDOW-NAME},
                             INPUT ?).

    RUN pi-controla IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btIncluirConta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btIncluirConta C-Win
ON CHOOSE OF btIncluirConta IN FRAME DEFAULT-FRAME /* Incluir */
DO:
    RUN esp/acr/esacr036c.w.

    RUN pi-controla-conta IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btModificarClasse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btModificarClasse C-Win
ON CHOOSE OF btModificarClasse IN FRAME DEFAULT-FRAME /* Modificar */
DO:
    ASSIGN r-rowid = IF AVAILABLE tt-int-classe-cli-supcard THEN ROWID(tt-int-classe-cli-supcard) ELSE ?.

    RUN esp/acr/esacr036b.w (INPUT {&WINDOW-NAME},
                             INPUT IF AVAIL tt-int-classe-cli-supcard THEN tt-int-classe-cli-supcard.r-rowid ELSE ?).

    RUN pi-controla IN THIS-PROCEDURE.

    REPOSITION brClasses TO ROWID r-rowid NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK C-Win
ON CHOOSE OF btOK IN FRAME DEFAULT-FRAME /* Salvar */
DO:
    RUN pi-salvar IN THIS-PROCEDURE.
    IF  RETURN-VALUE = "OK":U THEN DO:
        APPLY "CLOSE":U TO THIS-PROCEDURE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    RUN initializeObjects.
    RUN enable_UI.
    RUN afterInitializeInterface.
    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface C-Win 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN pi-controla.
    RUN pi-controla-conta.

    IF  c-seg-usuario = "" THEN
        ASSIGN c-usuario = v_cod_usuar_corren.
    ELSE
        ASSIGN c-usuario = c-seg-usuario.

    /* Valida se o usu rio que est  acessando a tela tem permissÆo para isto. */
    ASSIGN l-erro = YES.
    FIND FIRST ponto-programa NO-LOCK
        WHERE  ponto-programa.nome-programa = "supplierCard"
        AND    ponto-programa.ponto         = 1 NO-ERROR.
    IF  AVAIL  ponto-programa THEN DO:
        IF  CAN-FIND(FIRST conteudo-programa NO-LOCK
                     WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                     AND   conteudo-programa.conteudo     = c-usuario) THEN
            ASSIGN l-erro = NO.
    END.

    IF  l-erro THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Usu rio sem permissÆo para acessar esse programa.~~Favor entrar em contato com o Financeiro.":U).

        APPLY "CLOSE":U TO THIS-PROCEDURE.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  DISPLAY c-diretorio-remessa c-diretorio-retorno de-val-min-trans 
          de-val-min-parc i-qtd-dias-atraso text-param text-classe text-contas 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE rtToolBar RECT-1 RECT-2 RECT-3 c-diretorio-remessa c-diretorio-retorno 
         de-val-min-trans btHistoricoParam de-val-min-parc i-qtd-dias-atraso 
         brClasses btIncluirClasse btModificarClasse btExcluirClasse 
         btHistoricoClasse brContas btIncluirConta btExcluirContas btOK 
         btCancel text-param text-classe text-contas 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObjects C-Win 
PROCEDURE initializeObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND LAST int-param-supcard NO-LOCK NO-ERROR.
    IF  AVAIL int-param-supcard THEN
        ASSIGN c-diretorio-remessa = int-param-supcard.diretorio-remessa
               c-diretorio-retorno = int-param-supcard.diretorio-retorno
               de-val-min-trans    = int-param-supcard.val-min-trans
               de-val-min-parc     = int-param-supcard.val-min-parc
               i-qtd-dias-atraso   = int-param-supcard.qtd-dias-atraso.
    ELSE
        ASSIGN c-diretorio-remessa = ""
               c-diretorio-retorno = ""
               de-val-min-trans    = 0
               de-val-min-parc     = 0
               i-qtd-dias-atraso   = 0.

    DISP text-param
         c-diretorio-remessa
         c-diretorio-retorno
         de-val-min-trans
         de-val-min-parc
         i-qtd-dias-atraso
        WITH FRAME fPage0.

    IF  CAN-FIND(FIRST int-param-supcard) THEN
        ENABLE btHistoricoParam WITH FRAME default-frame.
    ELSE
        DISABLE btHistoricoParam WITH FRAME default-frame.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-controla C-Win 
PROCEDURE pi-controla :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-int-classe-cli-supcard.

    FOR EACH  int-classe-cli-supcard NO-LOCK
        BREAK BY int-classe-cli-supcard.des-classe
              BY int-classe-cli-supcard.dat-alteracao:

        IF  LAST-OF(int-classe-cli-supcard.des-classe)    AND
            LAST-OF(int-classe-cli-supcard.dat-alteracao) THEN DO:
            CREATE tt-int-classe-cli-supcard.
            BUFFER-COPY int-classe-cli-supcard TO tt-int-classe-cli-supcard.
            ASSIGN tt-int-classe-cli-supcard.r-rowid = ROWID(int-classe-cli-supcard).
        END.
    END.

    {&OPEN-QUERY-brClasses}

    IF  CAN-FIND(FIRST tt-int-classe-cli-supcard) THEN
        ENABLE btModificarClasse
               btExcluirClasse
               btHistoricoClasse
            WITH FRAME default-frame.
    ELSE
        DISABLE btModificarClasse
                btExcluirClasse
                btHistoricoClasse
            WITH FRAME default-frame.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-controla-conta C-Win 
PROCEDURE pi-controla-conta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {&OPEN-QUERY-brContas}

    IF  CAN-FIND(FIRST int-contas-supcard) THEN
        ENABLE btExcluirContas WITH FRAME default-frame.
    ELSE
        DISABLE btExcluirContas WITH FRAME default-frame.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salvar C-Win 
PROCEDURE pi-salvar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-seq AS INTEGER     NO-UNDO.

    ASSIGN INPUT FRAME default-frame c-diretorio-remessa
           INPUT FRAME default-frame c-diretorio-retorno
           INPUT FRAME default-frame de-val-min-trans
           INPUT FRAME default-frame de-val-min-parc
           INPUT FRAME default-frame i-qtd-dias-atraso.

    FIND LAST int-param-supcard NO-LOCK NO-ERROR.
    IF  AVAIL int-param-supcard THEN
        ASSIGN i-seq = int-param-supcard.sequencia + 1.
    ELSE
        ASSIGN i-seq = 1.

    CREATE int-param-supcard.
    ASSIGN int-param-supcard.sequencia         = i-seq
           int-param-supcard.dat-alteracao     = TODAY
           int-param-supcard.cod-usuar         = c-usuario
           int-param-supcard.diretorio-remessa = REPLACE(c-diretorio-remessa, "\", "/")
           int-param-supcard.diretorio-retorno = REPLACE(c-diretorio-retorno, "\", "/")
           int-param-supcard.val-min-trans     = de-val-min-trans
           int-param-supcard.val-min-parc      = de-val-min-parc
           int-param-supcard.qtd-dias-atraso   = i-qtd-dias-atraso.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

