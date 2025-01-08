&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-cond-pagto-1 NO-UNDO LIKE cond-pagto
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-cond-pagto-2 NO-UNDO LIKE cond-pagto
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-cond-pagto-aux NO-UNDO LIKE cond-pagto
       FIELD r-Rowid AS ROWID.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wZoom 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Preprocessors Definitions ---                                        */

&GLOBAL-DEFINE Titulo       Pesquisa Condi‡Æo Pagamento SupplierCard
&GLOBAL-DEFINE Programa     ESACR036B1
&GLOBAL-DEFINE Versao       2.06.00.000

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER pWindowParent AS HANDLE      NO-UNDO.
DEFINE INPUT  PARAMETER pCodCondPag   AS HANDLE      NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE iCodCondPagIni LIKE tt-cond-pagto-1.cod-cond-pag NO-UNDO VIEW-AS FILL-IN SIZE  8.00 BY 0.88.
DEFINE VARIABLE iCodCondPagFin LIKE tt-cond-pagto-1.cod-cond-pag NO-UNDO VIEW-AS FILL-IN SIZE  8.00 BY 0.88.
DEFINE VARIABLE cDescricaoIni  LIKE tt-cond-pagto-2.descricao    NO-UNDO VIEW-AS FILL-IN SIZE 32.00 BY 0.88.
DEFINE VARIABLE cDescricaoFin  LIKE tt-cond-pagto-2.descricao    NO-UNDO VIEW-AS FILL-IN SIZE 32.00 BY 0.88.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brTable1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-cond-pagto-1 tt-cond-pagto-2

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 tt-cond-pagto-1.cod-cond-pag ~
tt-cond-pagto-1.descricao 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH tt-cond-pagto-1 ~
      WHERE tt-cond-pagto-1.cod-cond-pag >= iCodCondPagIni ~
 AND tt-cond-pagto-1.cod-cond-pag <= iCodCondPagFin NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH tt-cond-pagto-1 ~
      WHERE tt-cond-pagto-1.cod-cond-pag >= iCodCondPagIni ~
 AND tt-cond-pagto-1.cod-cond-pag <= iCodCondPagFin NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brTable1 tt-cond-pagto-1
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 tt-cond-pagto-1


/* Definitions for BROWSE brTable2                                      */
&Scoped-define FIELDS-IN-QUERY-brTable2 tt-cond-pagto-2.descricao ~
tt-cond-pagto-2.cod-cond-pag 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable2 
&Scoped-define QUERY-STRING-brTable2 FOR EACH tt-cond-pagto-2 ~
      WHERE tt-cond-pagto-2.descricao >= cDescricaoIni ~
 AND tt-cond-pagto-2.descricao <= cDescricaoFin NO-LOCK ~
    BY tt-cond-pagto-2.descricao INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brTable2 OPEN QUERY brTable2 FOR EACH tt-cond-pagto-2 ~
      WHERE tt-cond-pagto-2.descricao >= cDescricaoIni ~
 AND tt-cond-pagto-2.descricao <= cDescricaoFin NO-LOCK ~
    BY tt-cond-pagto-2.descricao INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brTable2 tt-cond-pagto-2
&Scoped-define FIRST-TABLE-IN-QUERY-brTable2 tt-cond-pagto-2


/* Definitions for FRAME fPage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage0 ~
    ~{&OPEN-QUERY-brTable1}~
    ~{&OPEN-QUERY-brTable2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar rsSearchCondPagto brTable2 ~
brTable1 btRange btOK btCancel 
&Scoped-Define DISPLAYED-OBJECTS rsSearchCondPagto 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wZoom AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btRange 
     LABEL "&Faixa" 
     SIZE 10 BY 1.

DEFINE VARIABLE rsSearchCondPagto AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Condi‡Æo Pagamento", 1,
"Descri‡Æo", 2
     SIZE 30 BY .63 NO-UNDO.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 68 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      tt-cond-pagto-1 SCROLLING.

DEFINE QUERY brTable2 FOR 
      tt-cond-pagto-2 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      tt-cond-pagto-1.cod-cond-pag FORMAT ">>>9":U WIDTH 11.43
      tt-cond-pagto-1.descricao FORMAT "x(30)":U WIDTH 53.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 69.57 BY 7.21
         FONT 1.

DEFINE BROWSE brTable2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable2 wZoom _STRUCTURED
  QUERY brTable2 NO-LOCK DISPLAY
      tt-cond-pagto-2.descricao FORMAT "x(30)":U WIDTH 53.43
      tt-cond-pagto-2.cod-cond-pag FORMAT ">>>9":U WIDTH 11.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 69.57 BY 7.21
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     rsSearchCondPagto AT ROW 1.25 COL 2 NO-LABEL
     brTable2 AT ROW 2.17 COL 1
     brTable1 AT ROW 2.17 COL 1
     btRange AT ROW 9.75 COL 60 HELP
          "Faixa"
     btOK AT ROW 11.54 COL 3 HELP
          "OK"
     btCancel AT ROW 11.54 COL 14 HELP
          "Cancelar"
     rtToolBar AT ROW 11.33 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 70 BY 12
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Temp-Tables and Buffers:
      TABLE: tt-cond-pagto-1 T "?" NO-UNDO mgcad cond-pagto
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-cond-pagto-2 T "?" NO-UNDO mgcad cond-pagto
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-cond-pagto-aux T "?" NO-UNDO mgcad cond-pagto
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wZoom ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 12
         WIDTH              = 70
         MAX-HEIGHT         = 12
         MAX-WIDTH          = 70
         VIRTUAL-HEIGHT     = 12
         VIRTUAL-WIDTH      = 70
         MIN-BUTTON         = no
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         FONT               = 1
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wZoom
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* BROWSE-TAB brTable2 rsSearchCondPagto fPage0 */
/* BROWSE-TAB brTable1 brTable2 fPage0 */
ASSIGN 
       brTable1:COLUMN-RESIZABLE IN FRAME fPage0       = TRUE.

ASSIGN 
       brTable2:COLUMN-RESIZABLE IN FRAME fPage0       = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.tt-cond-pagto-1"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "Temp-Tables.tt-cond-pagto-1.cod-cond-pag >= iCodCondPagIni
 AND Temp-Tables.tt-cond-pagto-1.cod-cond-pag <= iCodCondPagFin"
     _FldNameList[1]   > Temp-Tables.tt-cond-pagto-1.cod-cond-pag
"tt-cond-pagto-1.cod-cond-pag" ? ? "integer" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-cond-pagto-1.descricao
"tt-cond-pagto-1.descricao" ? ? "character" ? ? ? ? ? ? no ? no no "53.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brTable1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable2
/* Query rebuild information for BROWSE brTable2
     _TblList          = "Temp-Tables.tt-cond-pagto-2"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.tt-cond-pagto-2.descricao|yes"
     _Where[1]         = "Temp-Tables.tt-cond-pagto-2.descricao >= cDescricaoIni
 AND Temp-Tables.tt-cond-pagto-2.descricao <= cDescricaoFin"
     _FldNameList[1]   > Temp-Tables.tt-cond-pagto-2.descricao
"tt-cond-pagto-2.descricao" ? ? "character" ? ? ? ? ? ? no ? no no "53.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-cond-pagto-2.cod-cond-pag
"tt-cond-pagto-2.cod-cond-pag" ? ? "integer" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brTable2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wZoom
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wZoom wZoom
ON END-ERROR OF wZoom
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wZoom wZoom
ON WINDOW-CLOSE OF wZoom
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wZoom
ON CHOOSE OF btCancel IN FRAME fPage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wZoom
ON CHOOSE OF btOK IN FRAME fPage0 /* OK */
DO:
    RUN returnValues IN THIS-PROCEDURE.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btRange
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRange wZoom
ON CHOOSE OF btRange IN FRAME fPage0 /* Faixa */
DO:
    ASSIGN INPUT FRAME fPage0 rsSearchCondPagto.

    RUN rangeFilter IN THIS-PROCEDURE (INPUT rsSearchCondPagto).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsSearchCondPagto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsSearchCondPagto wZoom
ON VALUE-CHANGED OF rsSearchCondPagto IN FRAME fPage0
DO:
    ASSIGN INPUT FRAME fPage0 rsSearchCondPagto.

    DO WITH FRAME fPage0:
        CASE rsSearchCondPagto:
            WHEN 1 THEN DO:
                ASSIGN brTable1:SENSITIVE = YES
                       brTable1:HIDDEN    = NO
                       brTable2:SENSITIVE = NO
                       brTable2:HIDDEN    = YES.
            END.
            WHEN 2 THEN DO:
                ASSIGN brTable1:SENSITIVE = NO
                       brTable1:HIDDEN    = YES
                       brTable2:SENSITIVE = YES
                       brTable2:HIDDEN    = NO.
            END.
            OTHERWISE DO:
                ASSIGN rsSearchCondPagto = 1.

                DISPLAY rsSearchCondPagto.

                APPLY "VALUE-CHANGED":U TO rsSearchCondPagto.
            END.
        END CASE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brTable1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wZoom 


/* ***************************  Main Block  *************************** */

SESSION:SET-WAIT-STATE("GENERAL":U).

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE
    RUN destroyInterface IN THIS-PROCEDURE.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

RUN initializeInterface IN THIS-PROCEDURE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    SESSION:SET-WAIT-STATE("":U).

    IF NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyInterface wZoom 
PROCEDURE destroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(pWindowParent) THEN
        ASSIGN pWindowParent:SENSITIVE = YES.

    IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom) THEN
        DELETE WIDGET wZoom.

    IF THIS-PROCEDURE:PERSISTENT THEN
        DELETE PROCEDURE THIS-PROCEDURE.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wZoom  _DEFAULT-ENABLE
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
  DISPLAY rsSearchCondPagto 
      WITH FRAME fPage0 IN WINDOW wZoom.
  ENABLE rtToolBar rsSearchCondPagto brTable2 brTable1 btRange btOK btCancel 
      WITH FRAME fPage0 IN WINDOW wZoom.
  {&OPEN-BROWSERS-IN-QUERY-fPage0}
  VIEW wZoom.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeInterface wZoom 
PROCEDURE initializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN rsSearchCondPagto = 1
           iCodCondPagIni    = 0
           iCodCondPagFin    = 9999
           cDescricaoIni     = "":U
           cDescricaoFin     = FILL("Z":U, 30).

    EMPTY TEMP-TABLE tt-cond-pagto-1.
    EMPTY TEMP-TABLE tt-cond-pagto-2.

    FOR EACH cond-pagto NO-LOCK,
        EACH int-cond-pagto OF cond-pagto NO-LOCK
        WHERE SUBSTRING(int-cond-pagto.char-1, 4, 1) = "S":U:

        CREATE tt-cond-pagto-1.
        BUFFER-COPY cond-pagto TO tt-cond-pagto-1.
        ASSIGN tt-cond-pagto-1.r-Rowid = ROWID(cond-pagto).

        CREATE tt-cond-pagto-2.
        BUFFER-COPY cond-pagto TO tt-cond-pagto-2.
        ASSIGN tt-cond-pagto-2.r-Rowid = ROWID(cond-pagto).
    END.

    RUN enable_UI IN THIS-PROCEDURE.

    ASSIGN {&WINDOW-NAME}:TITLE = "{&Titulo} - {&Programa} - {&Versao}":U.

    {&OPEN-QUERY-brTable1}
    {&OPEN-QUERY-brTable2}

    DISPLAY rsSearchCondPagto
        WITH FRAME fPage0.

    APPLY "VALUE-CHANGED":U TO rsSearchCondPagto IN FRAME fPage0.

    IF VALID-HANDLE(pWindowParent) THEN
        ASSIGN pWindowParent:SENSITIVE = NO.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rangeFilter wZoom 
PROCEDURE rangeFilter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pSearchCondPagto AS INTEGER     NO-UNDO.

    DEFINE BUTTON btSearchCondPagtoOK AUTO-GO
        LABEL "&OK":U
        SIZE 10 BY 1
        BGCOLOR 8.

    DEFINE BUTTON btSearchCondPagtoCancel AUTO-END-KEY
        LABEL "&Cancelar":U
        SIZE 10 BY 1
        BGCOLOR 8.

    DEFINE RECTANGLE rtSearchCondPagtoButton
        EDGE-PIXELS 2 GRAPHIC-EDGE
        SIZE 58 BY 1.42
        BGCOLOR 7.

    DEFINE FRAME fSearchCondPagtoRecord
        iCodCondPagIni          AT ROW 1.21 COL 24.72 COLON-ALIGNED LABEL "Inicial":U
        iCodCondPagFin          AT ROW 2.21 COL 24.72 COLON-ALIGNED LABEL "Final":U
        cDescricaoIni           AT ROW 1.21 COL 15.22 COLON-ALIGNED LABEL "Inicial":U
        cDescricaoFin           AT ROW 2.21 COL 15.22 COLON-ALIGNED LABEL "Final":U
        btSearchCondPagtoOK     AT ROW 3.63 COL 2.14
        btSearchCondPagtoCancel AT ROW 3.63 COL 13
        rtSearchCondPagtoButton AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE
        THREE-D SCROLLABLE TITLE "Faixa Cond Pagto":U FONT 1
        DEFAULT-BUTTON btSearchCondPagtoOK CANCEL-BUTTON btSearchCondPagtoCancel.

    ON "CHOOSE":U OF btSearchCondPagtoOK IN FRAME fSearchCondPagtoRecord DO:
        ASSIGN INPUT FRAME fSearchCondPagtoRecord iCodCondPagIni
                                                  iCodCondPagFin
                                                  cDescricaoIni
                                                  cDescricaoFin.

        {&OPEN-QUERY-brTable1}
        {&OPEN-QUERY-brTable2}

        APPLY "GO":U TO FRAME fSearchCondPagtoRecord.
    END.

    DO WITH FRAME fSearchCondPagtoRecord:
        CASE pSearchCondPagto:
            WHEN 1 THEN DO:
                ASSIGN iCodCondPagIni:SENSITIVE = YES
                       iCodCondPagIni:HIDDEN    = NO
                       iCodCondPagFin:SENSITIVE = YES
                       iCodCondPagFin:HIDDEN    = NO
                       cDescricaoIni:SENSITIVE  = NO
                       cDescricaoIni:HIDDEN     = YES
                       cDescricaoFin:SENSITIVE  = NO
                       cDescricaoFin:HIDDEN     = YES.

                DISPLAY iCodCondPagIni
                        iCodCondPagFin.
            END.
            WHEN 2 THEN DO:
                ASSIGN iCodCondPagIni:SENSITIVE = NO
                       iCodCondPagIni:HIDDEN    = YES
                       iCodCondPagFin:SENSITIVE = NO
                       iCodCondPagFin:HIDDEN    = YES
                       cDescricaoIni:SENSITIVE  = YES
                       cDescricaoIni:HIDDEN     = NO
                       cDescricaoFin:SENSITIVE  = YES
                       cDescricaoFin:HIDDEN     = NO.

                DISPLAY cDescricaoIni
                        cDescricaoFin.
            END.
        END CASE.

        ENABLE btSearchCondPagtoOK
               btSearchCondPagtoCancel.
    END.

    CASE pSearchCondPagto:
        WHEN 1 THEN
            ASSIGN FRAME fSearchCondPagtoRecord:TITLE = "Faixa Condi‡Æo Pagamento":U.
        WHEN 2 THEN
            ASSIGN FRAME fSearchCondPagtoRecord:TITLE = "Faixa Descri‡Æo":U.
    END CASE.

    WAIT-FOR "GO":U OF FRAME fSearchCondPagtoRecord.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnValues wZoom 
PROCEDURE returnValues :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hBrowse     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE iCont       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cCodCondPag AS CHARACTER   NO-UNDO.

    ASSIGN INPUT FRAME fPage0 rsSearchCondPagto.

    CASE rsSearchCondPagto :
        WHEN 1 THEN
            ASSIGN hBrowse = brTable1:HANDLE IN FRAME fPage0.
        WHEN 2 THEN
            ASSIGN hBrowse = brTable2:HANDLE IN FRAME fPage0.
        OTHERWISE
            RETURN "NOK":U.
    END CASE.

    EMPTY TEMP-TABLE tt-cond-pagto-aux.

    IF hBrowse:NUM-SELECTED-ROWS > 0 THEN DO:
        DO iCont = 1 TO hBrowse:NUM-SELECTED-ROWS:
            hBrowse:FETCH-SELECTED-ROW(iCont).

            FIND FIRST tt-cond-pagto-aux
                WHERE tt-cond-pagto-aux.cod-cond-pag = hBrowse:QUERY:GET-BUFFER-HANDLE(1):BUFFER-FIELD("cod-cond-pag":U):BUFFER-VALUE NO-ERROR.

            IF NOT AVAILABLE tt-cond-pagto-aux THEN DO:
                FIND FIRST cond-pagto
                    WHERE ROWID(cond-pagto) = hBrowse:QUERY:GET-BUFFER-HANDLE(1):BUFFER-FIELD("r-Rowid":U):BUFFER-VALUE NO-LOCK NO-ERROR.

                IF AVAILABLE cond-pagto THEN DO:
                    CREATE tt-cond-pagto-aux.
                    BUFFER-COPY cond-pagto TO tt-cond-pagto-aux.
                    ASSIGN tt-cond-pagto-aux.r-Rowid = ROWID(cond-pagto).
                END.
            END.
        END.
    END.

    ASSIGN hBrowse = ?.

    FOR EACH tt-cond-pagto-aux:
        ASSIGN cCodCondPag = (IF cCodCondPag <> "":U THEN (cCodCondPag + ",":U) ELSE "":U) + TRIM(STRING(tt-cond-pagto-aux.cod-cond-pag, ">>>9":U)).
    END.

    EMPTY TEMP-TABLE tt-cond-pagto-aux.

    ASSIGN pCodCondPag:SCREEN-VALUE = cCodCondPag.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

