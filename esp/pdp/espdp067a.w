&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-int-licenca-softphone NO-UNDO LIKE int-licenca-softphone
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-int-licenca-softphone-aux NO-UNDO LIKE int-licenca-softphone
       FIELD r-Rowid AS ROWID.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESPDP067A 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESPDP067A
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    2
&GLOBAL-DEFINE FolderLabels   Layout,Importa‡Æo

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   edLayout
&GLOBAL-DEFINE page2Widgets   brLicencaImport fiArquivo btPesquisar btVisualizar btLimpar tgLabelColuna

/* Include Definitions ---                                              */

/*{method/dbotterr.i} /* Defini‡Æo da RowErrors */*/

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER pHandleParent AS HANDLE      NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE v-desc-item LIKE item.desc-item NO-UNDO.
DEFINE VARIABLE v-coluna    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-asc       AS LOGICAL     NO-UNDO.
DEFINE VARIABLE h-acomp     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boes601   AS HANDLE      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brLicencaImport

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-int-licenca-softphone

/* Definitions for BROWSE brLicencaImport                               */
&Scoped-define FIELDS-IN-QUERY-brLicencaImport ~
tt-int-licenca-softphone.it-codigo ~
fn-desc-item(tt-int-licenca-softphone.it-codigo) @ v-desc-item ~
tt-int-licenca-softphone.it-fornec tt-int-licenca-softphone.licenca 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brLicencaImport 
&Scoped-define QUERY-STRING-brLicencaImport FOR EACH tt-int-licenca-softphone NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brLicencaImport OPEN QUERY brLicencaImport FOR EACH tt-int-licenca-softphone NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brLicencaImport tt-int-licenca-softphone
&Scoped-define FIRST-TABLE-IN-QUERY-brLicencaImport tt-int-licenca-softphone


/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brLicencaImport}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-desc-item wWindow 
FUNCTION fn-desc-item RETURNS CHARACTER
  ( p-it-codigo AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&Efetivar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE edLayout AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL LARGE
     SIZE 82 BY 11
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE BUTTON btLimpar 
     LABEL "&Limpar" 
     SIZE 10 BY 1.

DEFINE BUTTON btPesquisar 
     IMAGE-UP FILE "image/im-sea.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-sea.bmp":U
     LABEL "Pesquisar" 
     SIZE 4 BY 1.

DEFINE BUTTON btVisualizar 
     LABEL "&Visualizar" 
     SIZE 10 BY 1 TOOLTIP "Visualizar Informa‡äes do Arquivo".

DEFINE VARIABLE fiArquivo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Arquivo CSV" 
     VIEW-AS FILL-IN 
     SIZE 47.29 BY .88 NO-UNDO.

DEFINE VARIABLE tgLabelColuna AS LOGICAL INITIAL yes 
     LABEL "Primeira linha do arquivo com label?" 
     VIEW-AS TOGGLE-BOX
     SIZE 30.29 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brLicencaImport FOR 
      tt-int-licenca-softphone SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brLicencaImport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brLicencaImport wWindow _STRUCTURED
  QUERY brLicencaImport NO-LOCK DISPLAY
      tt-int-licenca-softphone.it-codigo FORMAT "x(16)":U WIDTH 13.43
      fn-desc-item(tt-int-licenca-softphone.it-codigo) @ v-desc-item COLUMN-LABEL "Descri‡Æo" FORMAT "x(60)":U
            WIDTH 33.43
      tt-int-licenca-softphone.it-fornec FORMAT "x(16)":U WIDTH 13.43
      tt-int-licenca-softphone.licenca FORMAT "x(40)":U WIDTH 28.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.33
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 15.25 COL 2 HELP
          "Efetivar Importa‡Æo"
     btCancel AT ROW 15.25 COL 13 HELP
          "Cancelar"
     btHelp2 AT ROW 15.25 COL 80 HELP
          "Ajuda"
     rtToolBar AT ROW 15.04 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 15.5
         FONT 1.

DEFINE FRAME fPage2
     brLicencaImport AT ROW 1.17 COL 2
     btPesquisar AT ROW 10.71 COL 59.14 HELP
          "Pesquisar"
     btVisualizar AT ROW 10.71 COL 64.14 HELP
          "Visualizar"
     btLimpar AT ROW 10.71 COL 74 HELP
          "Limpar pr‚vias das informa‡äes do Arquivo"
     fiArquivo AT ROW 10.75 COL 9.72 COLON-ALIGNED HELP
          "Arquivo CSV"
     tgLabelColuna AT ROW 11.79 COL 11.72
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.5
         SIZE 84.43 BY 11.83
         FONT 1.

DEFINE FRAME fPage1
     edLayout AT ROW 1.38 COL 2 NO-LABEL
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.5
         SIZE 84.43 BY 11.83
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-int-licenca-softphone T "?" NO-UNDO mgesp int-licenca-softphone
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-int-licenca-softphone-aux T "?" NO-UNDO mgesp int-licenca-softphone
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
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
         HEIGHT             = 15.5
         WIDTH              = 90
         MAX-HEIGHT         = 15.5
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 15.5
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
ASSIGN 
       edLayout:RETURN-INSERTED IN FRAME fPage1  = TRUE
       edLayout:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brLicencaImport 1 fPage2 */
ASSIGN 
       brLicencaImport:ALLOW-COLUMN-SEARCHING IN FRAME fPage2 = TRUE
       brLicencaImport:COLUMN-RESIZABLE IN FRAME fPage2       = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brLicencaImport
/* Query rebuild information for BROWSE brLicencaImport
     _TblList          = "Temp-Tables.tt-int-licenca-softphone"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-int-licenca-softphone.it-codigo
"Temp-Tables.tt-int-licenca-softphone.it-codigo" ? ? "character" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fn-desc-item(tt-int-licenca-softphone.it-codigo) @ v-desc-item" "Descri‡Æo" "x(60)" ? ? ? ? ? ? ? no "Descri‡Æo do Item" no no "33.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-int-licenca-softphone.it-fornec
"Temp-Tables.tt-int-licenca-softphone.it-fornec" ? ? "character" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-int-licenca-softphone.licenca
"Temp-Tables.tt-int-licenca-softphone.licenca" ? ? "character" ? ? ? ? ? ? no ? no no "28.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brLicencaImport */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
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


&Scoped-define BROWSE-NAME brLicencaImport
&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME brLicencaImport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brLicencaImport wWindow
ON DELETE-CHARACTER OF brLicencaImport IN FRAME fPage2
DO:
    IF AVAILABLE tt-int-licenca-softphone THEN DO:
        DELETE tt-int-licenca-softphone.

        {&OPEN-QUERY-brLicencaImport}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brLicencaImport wWindow
ON START-SEARCH OF brLicencaImport IN FRAME fPage2
DO:
    DEFINE VARIABLE i-cont  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-index AS INTEGER     NO-UNDO.

    IF v-coluna <> SELF:CURRENT-COLUMN:NAME THEN
        ASSIGN v-coluna = SELF:CURRENT-COLUMN:NAME
               l-asc    = YES.
    ELSE
        ASSIGN l-asc = NOT l-asc.

    SELF:CLEAR-SORT-ARROWS().

    IF SELF:CURRENT-COLUMN:TABLE <> "":U AND SELF:CURRENT-COLUMN:TABLE <> ? THEN DO:
        IF l-asc THEN
            SELF:QUERY:QUERY-PREPARE("FOR EACH tt-int-licenca-softphone ":U +
                                     "    OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME).
        ELSE
            SELF:QUERY:QUERY-PREPARE("FOR EACH tt-int-licenca-softphone ":U +
                                     "    OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME + " DESC":U).

        DO i-cont = 1 TO SELF:NUM-COLUMNS:
            IF SELF:CURRENT-COLUMN = SELF:GET-BROWSE-COLUMN(i-cont) THEN
                ASSIGN i-index = i-cont.
        END.

        SELF:SET-SORT-ARROW(i-index, l-asc).

        SELF:QUERY:QUERY-OPEN().
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
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


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btLimpar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLimpar wWindow
ON CHOOSE OF btLimpar IN FRAME fPage2 /* Limpar */
DO:
    EMPTY TEMP-TABLE tt-int-licenca-softphone.
    EMPTY TEMP-TABLE RowErrors.

    {&OPEN-QUERY-brLicencaImport}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* Efetivar */
DO:
    RUN piExecutar.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btPesquisar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPesquisar wWindow
ON CHOOSE OF btPesquisar IN FRAME fPage2 /* Pesquisar */
DO:
    DEFINE VARIABLE cConvFile AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE lOk       AS LOGICAL     NO-UNDO INITIAL NO.

    ASSIGN cConvFile = REPLACE(INPUT FRAME fPage2 fiArquivo, "/":U, "~\":U).

    SYSTEM-DIALOG GET-FILE cConvFile
        FILTERS "CSV (separado por ponto e v¡rgula) (*.csv)":U "*.csv":U,
                "Todos os arquivos (*.*)":U                    "*.*":U
        DEFAULT-EXTENSION "csv":U
        INITIAL-DIR "spool":U 
        USE-FILENAME
        UPDATE lOk.

    IF lOk then do:
        ASSIGN fiArquivo = REPLACE(cConvFile, "~\":U, "/":U).

        DISPLAY fiArquivo
            WITH FRAME fPage2.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btVisualizar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btVisualizar wWindow
ON CHOOSE OF btVisualizar IN FRAME fPage2 /* Visualizar */
DO:
    RUN piVisualizarInfo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiArquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiArquivo wWindow
ON \ OF fiArquivo IN FRAME fPage2 /* Arquivo CSV */
DO:
    APPLY "/":U TO SELF.

    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

DEFINE TEMP-TABLE RowErrorsAux NO-UNDO LIKE RowErrors.

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
    ASSIGN edLayout = "+------------------------------------------------------------------------------+":U + CHR(10) +
                      "|            Layout do Arquivo de Importa‡Æo da Licen‡a do Softphone           |":U + CHR(10) +
                      "|------------------------------------------------------------------------------|":U + CHR(10) +
                      "|               Formato: Arquivo CSV (separado por ponto e v¡rgula)            |":U + CHR(10) +
                      "|------------------------------------------------------------------------------|":U + CHR(10) +
                      "|     Coluna    |  Descri‡Æo                                                   |":U + CHR(10) +
                      "|---------------+--------------------------------------------------------------|":U + CHR(10) +
                      "|       01      |  C¢digo do Item                                              |":U + CHR(10) +
                      "|       02      |  C¢digo do Item Fornecedor                                   |":U + CHR(10) +
                      "|       03      |  Licen‡a de Software                                         |":U + CHR(10) +
                      "|               |                                                              |":U + CHR(10) +
                      "|               |                                                              |":U + CHR(10) +
                      "|               |                                                              |":U + CHR(10) +
                      "|               |                                                              |":U + CHR(10) +
                      "|               |                                                              |":U + CHR(10) +
                      "|               |                                                              |":U + CHR(10) +
                      "|               |                                                              |":U + CHR(10) +
                      "+------------------------------------------------------------------------------+":U.

    DISPLAY edLayout
        WITH FRAME fPage1.

    ASSIGN v-coluna = "it-codigo":U
           l-asc    = YES.

    brLicencaImport:CLEAR-SORT-ARROWS() IN FRAME fPage2.
    brLicencaImport:SET-SORT-ARROW(1, l-asc) IN FRAME fPage2.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDestroyInterface wWindow 
PROCEDURE beforeDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-acomp) THEN
        DELETE PROCEDURE h-acomp.

    IF VALID-HANDLE(h-boes601) THEN
        DELETE PROCEDURE h-boes601.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCreateRowErrors wWindow 
PROCEDURE piCreateRowErrors :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pCodigo    AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER pParametro AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE iSequencia AS INTEGER     NO-UNDO.

    FIND LAST RowErrors NO-ERROR.

    ASSIGN iSequencia = IF AVAILABLE RowErrors THEN RowErrors.ErrorSequence + 1 ELSE 1.

    CREATE RowErrors.
    ASSIGN RowErrors.ErrorSequence   = iSequencia
           RowErrors.ErrorType       = "EMS":U
           RowErrors.ErrorNumber     = pCodigo
           RowErrors.ErrorParameters = pParametro.

    RUN utp/ut-msgs.p (INPUT "CODTYPE":U,
                       INPUT RowErrors.ErrorNumber,
                       INPUT RowErrors.ErrorParameters).

    CASE RETURN-VALUE:
        WHEN "2":U THEN
            ASSIGN RowErrors.ErrorSubType = "Warning":U.
        WHEN "3":U THEN
            ASSIGN RowErrors.ErrorSubType = "Question":U.
        WHEN "4":U THEN
            ASSIGN RowErrors.ErrorSubType = "Information":U.
        OTHERWISE
            ASSIGN RowErrors.ErrorSubType = "Error":U.
    END CASE.

    RUN utp/ut-msgs.p (INPUT "MSG":U,
                       INPUT RowErrors.ErrorNumber,
                       INPUT RowErrors.ErrorParameters).

    ASSIGN RowErrors.ErrorDescription = RETURN-VALUE.

    RUN utp/ut-msgs.p (INPUT "HELP":U,
                       INPUT RowErrors.ErrorNumber,
                       INPUT RowErrors.ErrorParameters).

    ASSIGN RowErrors.ErrorHelp = RETURN-VALUE.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecutar wWindow 
PROCEDURE piExecutar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE rRowidUltimoCadastro AS ROWID       NO-UNDO.

    ASSIGN rRowidUltimoCadastro = ?.

    IF NOT VALID-HANDLE(h-boes601) THEN
        RUN esbo/boes601.p PERSISTENT SET h-boes601.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Lendo arquivo para visualiza‡Æo...":U).

    EMPTY TEMP-TABLE tt-int-licenca-softphone-aux.
    EMPTY TEMP-TABLE RowErrors.

    FOR EACH tt-int-licenca-softphone:
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Licen‡a: ":U + tt-int-licenca-softphone.licenca).

        EMPTY TEMP-TABLE tt-int-licenca-softphone-aux.

        CREATE tt-int-licenca-softphone-aux.
        BUFFER-COPY tt-int-licenca-softphone TO tt-int-licenca-softphone-aux.

        RUN openQueryStatic IN h-boes601 (INPUT "Main":U).
        RUN emptyRowErrors IN h-boes601.
        RUN setRecord IN h-boes601 (INPUT TABLE tt-int-licenca-softphone-aux).
        RUN createRecord IN h-boes601.

        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN getRowErrors IN h-boes601 (OUTPUT TABLE RowErrorsAux).

            CREATE RowErrors.
            BUFFER-COPY RowErrorsAux TO RowErrors.
        END.
        ELSE
            RUN getRowid IN h-boes601 (OUTPUT rRowidUltimoCadastro).

        RUN emptyRowErrors IN h-boes601.
    END.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    IF CAN-FIND(FIRST RowErrors) THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2 &Modal="YES"}
        {method/showmessage.i3}

        RETURN NO-APPLY.
    END.

    IF rRowidUltimoCadastro <> ? THEN
        RUN piOpenQueryBrLicenca IN pHandleParent (INPUT rRowidUltimoCadastro).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVisualizarInfo wWindow 
PROCEDURE piVisualizarInfo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cLinha AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iLinha AS INTEGER     NO-UNDO.

    DEFINE VARIABLE v-it-codigo LIKE int-licenca-softphone.it-codigo NO-UNDO.
    DEFINE VARIABLE v-it-fornec LIKE int-licenca-softphone.it-fornec NO-UNDO.
    DEFINE VARIABLE v-licenca   LIKE int-licenca-softphone.licenca   NO-UNDO.

    EMPTY TEMP-TABLE RowErrors.

    ASSIGN INPUT FRAME fPage2 fiArquivo
                              tgLabelColuna.

    IF fiArquivo = "":U THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Favor informar um arquivo!":U).

        APPLY "ENTRY":U TO fiArquivo IN FRAME fPage2.

        RETURN NO-APPLY.
    END.

    FILE-INFO:FILE-NAME = fiArquivo.

    IF FILE-INFO:FULL-PATHNAME           = ?    OR
       FILE-INFO:FULL-PATHNAME           = "":U OR
       INDEX(FILE-INFO:FILE-TYPE, "F":U) = 0    THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Arquivo informado ‚ inv lido!":U).

        APPLY "ENTRY":U TO fiArquivo IN FRAME fPage2.

        RETURN NO-APPLY.
    END.

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Lendo arquivo para visualiza‡Æo...":U).

    EMPTY TEMP-TABLE tt-int-licenca-softphone.

    ASSIGN iLinha = 0.

    INPUT FROM VALUE(fiArquivo) NO-CONVERT.
    REPEAT:
        IMPORT UNFORMATTED cLinha.

        ASSIGN iLinha = iLinha + 1.

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Linha: ":U + TRIM(STRING(iLinha)) + " - ":U + cLinha).

        IF tgLabelColuna AND iLinha = 1 THEN
            NEXT.

        IF NUM-ENTRIES(cLinha, ";":U) < 3 THEN DO:
            RUN piCreateRowErrors (INPUT 17006,
                                   INPUT "Linha com quantidades de colunas inferior a solicitada":U +
                                         "~~":U +
                                         "Linha com quantidades de colunas inferior a solicitada. (Linha ":U + TRIM(STRING(iLinha)) + ")":U).

            NEXT.
        END.

        ASSIGN v-it-codigo = TRIM(ENTRY(1, cLinha, ";":U)).

        FIND FIRST item
            WHERE item.it-codigo = v-it-codigo NO-LOCK NO-ERROR.

        IF NOT AVAILABLE item THEN DO:
            RUN piCreateRowErrors (INPUT 17006,
                                   INPUT "Item nÆo cadastrado":U +
                                         "~~":U +
                                         "Item ~"":U + v-it-codigo + "~" nÆo cadastrado no sistema. (Linha ":U + TRIM(STRING(iLinha)) + ")":U).

            NEXT.
        END.

        ASSIGN v-it-fornec = TRIM(ENTRY(2, cLinha, ";":U)).

        ASSIGN v-licenca = TRIM(ENTRY(3, cLinha, ";":U)).

        FIND FIRST int-licenca-softphone
            WHERE int-licenca-softphone.licenca = v-licenca NO-LOCK NO-ERROR.

        IF AVAILABLE int-licenca-softphone THEN DO:
            RUN piCreateRowErrors (INPUT 17006,
                                   INPUT "Licen‡a j  cadastrada":U +
                                         "~~":U +
                                         "Licen‡a ~"":U + v-licenca + "~" j  cadastrada. (Linha ":U + TRIM(STRING(iLinha)) + ")":U).

            NEXT.
        END.

        FIND FIRST tt-int-licenca-softphone
            WHERE tt-int-licenca-softphone.it-codigo = v-it-codigo
              AND tt-int-licenca-softphone.it-fornec = v-it-fornec
              AND tt-int-licenca-softphone.licenca   = v-licenca NO-ERROR.

        IF AVAILABLE tt-int-licenca-softphone THEN DO:
            RUN piCreateRowErrors (INPUT 17006,
                                   INPUT "Registro duplicado no arquivo":U +
                                         "~~":U +
                                         "Registro duplicado no arquivo. (Linha ":U + TRIM(STRING(iLinha)) + ")":U).

            NEXT.
        END.

        FIND FIRST tt-int-licenca-softphone
            WHERE tt-int-licenca-softphone.licenca = v-licenca NO-ERROR.

        IF AVAILABLE tt-int-licenca-softphone THEN DO:
            RUN piCreateRowErrors (INPUT 17006,
                                   INPUT "Licen‡a duplicada no arquivo":U +
                                         "~~":U +
                                         "Licen‡a duplicada no arquivo. (Linha ":U + TRIM(STRING(iLinha)) + ")":U).

            NEXT.
        END.

        CREATE tt-int-licenca-softphone.
        ASSIGN tt-int-licenca-softphone.it-codigo = v-it-codigo
               tt-int-licenca-softphone.it-fornec = v-it-fornec
               tt-int-licenca-softphone.licenca   = v-licenca.
    END.
    INPUT CLOSE.

    IF NOT CAN-FIND(FIRST tt-int-licenca-softphone) THEN DO:
        RUN piCreateRowErrors (INPUT 17006,
                               INPUT "Nenhum novo registro encontrado no arquivo":U +
                                     "~~":U +
                                     "Nenhum novo registro encontrado no arquivo.":U).
    END.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    {&OPEN-QUERY-brLicencaImport}

    ASSIGN v-coluna = "it-codigo":U
           l-asc    = YES.

    brLicencaImport:CLEAR-SORT-ARROWS() IN FRAME fPage2.
    brLicencaImport:SET-SORT-ARROW(1, l-asc) IN FRAME fPage2.

    IF CAN-FIND(FIRST RowErrors) THEN DO:
        {method/showmessage.i1}
        {method/showmessage.i2 &Modal="YES"}
        EMPTY TEMP-TABLE RowErrors.
        {method/showmessage.i3}
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-desc-item wWindow 
FUNCTION fn-desc-item RETURNS CHARACTER
  ( p-it-codigo AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    FIND FIRST item
        WHERE item.it-codigo = p-it-codigo NO-LOCK NO-ERROR.

    IF AVAILABLE item THEN
        RETURN item.desc-item.
    ELSE
        RETURN "":U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

