&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-canhoto NO-UNDO LIKE canhoto
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-canhoto-nf NO-UNDO LIKE canhoto-nf
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wZoom 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i Z01ES560 2.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           Z01ES560
&GLOBAL-DEFINE Version           2.00.00.001

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      Canhoto,Nota Fiscal

&GLOBAL-DEFINE Range             YES

&GLOBAL-DEFINE FieldsRangePage1  mgesp.canhoto.cod-transp,mgesp.canhoto.cod-caixa,mgesp.canhoto.cod-envelope
&GLOBAL-DEFINE FieldsRangePage2  mgesp.canhoto-nf.cod-estabel,mgesp.canhoto-nf.serie,mgesp.canhoto-nf.nr-nota-fis
&GLOBAL-DEFINE FieldsAnyKeyPage1 NO,NO,NO
&GLOBAL-DEFINE FieldsAnyKeyPage2 NO,NO,NO

&GLOBAL-DEFINE ttTable1          tt-canhoto
&GLOBAL-DEFINE hDBOTable1        h-boes560
&GLOBAL-DEFINE DBOTable1         canhoto

&GLOBAL-DEFINE ttTable2          tt-canhoto-nf
&GLOBAL-DEFINE hDBOTable2        h-boes561
&GLOBAL-DEFINE DBOTable2         canhoto-nf

&GLOBAL-DEFINE page1Browse       brTable1
&GLOBAL-DEFINE page2Browse       brTable2

&GLOBAL-DEFINE numRowsReturned   ?

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable1} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTable2} AS HANDLE NO-UNDO.

DEFINE VARIABLE c-nome-transp AS CHARACTER   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Zoom
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brTable1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-canhoto tt-canhoto-nf

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 tt-canhoto.cod-transp ~
fnNmTransp(tt-canhoto.cod-transp) @ c-nome-transp tt-canhoto.cod-caixa ~
tt-canhoto.cod-envelope tt-canhoto.dt-recebimento 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH tt-canhoto NO-LOCK
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH tt-canhoto NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTable1 tt-canhoto
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 tt-canhoto


/* Definitions for BROWSE brTable2                                      */
&Scoped-define FIELDS-IN-QUERY-brTable2 tt-canhoto-nf.cod-estabel ~
tt-canhoto-nf.serie tt-canhoto-nf.nr-nota-fis tt-canhoto-nf.cod-transp ~
fnNmTransp(tt-canhoto-nf.cod-transp) @ c-nome-transp ~
tt-canhoto-nf.cod-envelope tt-canhoto-nf.cod-caixa 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable2 
&Scoped-define QUERY-STRING-brTable2 FOR EACH tt-canhoto-nf NO-LOCK
&Scoped-define OPEN-QUERY-brTable2 OPEN QUERY brTable2 FOR EACH tt-canhoto-nf NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTable2 tt-canhoto-nf
&Scoped-define FIRST-TABLE-IN-QUERY-brTable2 tt-canhoto-nf


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brTable1}

/* Definitions for FRAME fpage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage2 ~
    ~{&OPEN-QUERY-brTable2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnNmTransp wZoom 
FUNCTION fnNmTransp RETURNS CHARACTER
  ( pCod-transp AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wZoom AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON btImplant1 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE BUTTON btImplant2 
     LABEL "Implantar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      tt-canhoto SCROLLING.

DEFINE QUERY brTable2 FOR 
      tt-canhoto-nf SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      tt-canhoto.cod-transp FORMAT ">>,>>9":U
      fnNmTransp(tt-canhoto.cod-transp) @ c-nome-transp COLUMN-LABEL "Nome Transp" FORMAT "x(100)":U
            WIDTH 33.14
      tt-canhoto.cod-caixa FORMAT "x(10)":U WIDTH 10.43
      tt-canhoto.cod-envelope FORMAT "x(10)":U WIDTH 13.43
      tt-canhoto.dt-recebimento FORMAT "99/99/9999":U WIDTH 14.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 8.5
         FONT 2.

DEFINE BROWSE brTable2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable2 wZoom _STRUCTURED
  QUERY brTable2 NO-LOCK DISPLAY
      tt-canhoto-nf.cod-estabel FORMAT "x(3)":U WIDTH 4.43
      tt-canhoto-nf.serie FORMAT "x(5)":U WIDTH 6.43
      tt-canhoto-nf.nr-nota-fis FORMAT "x(16)":U
      tt-canhoto-nf.cod-transp FORMAT ">>,>>9":U
      fnNmTransp(tt-canhoto-nf.cod-transp) @ c-nome-transp COLUMN-LABEL "Nome Transp" FORMAT "x(100)":U
            WIDTH 33.14
      tt-canhoto-nf.cod-envelope FORMAT "x(10)":U
      tt-canhoto-nf.cod-caixa FORMAT "x(10)":U WIDTH 7.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 84 BY 8.25
         FONT 1 ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btOK AT ROW 16.71 COL 2
     btCancel AT ROW 16.71 COL 13
     btHelp AT ROW 16.71 COL 80
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.98
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fpage2
     brTable2 AT ROW 4.5 COL 1 WIDGET-ID 300
     btImplant2 AT ROW 13 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1 WIDGET-ID 200.

DEFINE FRAME fPage1
     brTable1 AT ROW 4.5 COL 2
     btImplant1 AT ROW 13 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Zoom
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-canhoto T "?" NO-UNDO mgesp canhoto
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-canhoto-nf T "?" NO-UNDO mgesp canhoto-nf
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
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
         HEIGHT             = 17
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wZoom 
/* ************************* Included-Libraries *********************** */

{zoom/zoom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wZoom
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE
       FRAME fpage2:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brTable1 1 fPage1 */
ASSIGN 
       brTable1:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE.

/* SETTINGS FOR FRAME fpage2
                                                                        */
/* BROWSE-TAB brTable2 1 fpage2 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.tt-canhoto"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.tt-canhoto.cod-transp
     _FldNameList[2]   > "_<CALC>"
"fnNmTransp(tt-canhoto.cod-transp) @ c-nome-transp" "Nome Transp" "x(100)" ? ? ? ? ? ? ? no ? no no "33.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-canhoto.cod-caixa
"tt-canhoto.cod-caixa" ? ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-canhoto.cod-envelope
"tt-canhoto.cod-envelope" ? ? "character" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-canhoto.dt-recebimento
"tt-canhoto.dt-recebimento" ? ? "date" ? ? ? ? ? ? no ? no no "14.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brTable1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable2
/* Query rebuild information for BROWSE brTable2
     _TblList          = "Temp-Tables.tt-canhoto-nf"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.tt-canhoto-nf.cod-estabel
"tt-canhoto-nf.cod-estabel" ? ? "character" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-canhoto-nf.serie
"tt-canhoto-nf.serie" ? ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.tt-canhoto-nf.nr-nota-fis
     _FldNameList[4]   = Temp-Tables.tt-canhoto-nf.cod-transp
     _FldNameList[5]   > "_<CALC>"
"fnNmTransp(tt-canhoto-nf.cod-transp) @ c-nome-transp" "Nome Transp" "x(100)" ? ? ? ? ? ? ? no ? no no "33.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = Temp-Tables.tt-canhoto-nf.cod-envelope
     _FldNameList[7]   > Temp-Tables.tt-canhoto-nf.cod-caixa
"tt-canhoto-nf.cod-caixa" ? ? "character" ? ? ? ? ? ? no ? no no "7.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brTable2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage2
/* Query rebuild information for FRAME fpage2
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage2 */
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


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wZoom
ON CHOOSE OF btHelp IN FRAME fPage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btImplant1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant1 wZoom
ON CHOOSE OF btImplant1 IN FRAME fPage1 /* Implantar */
DO:
    {zoom/implant.i &ProgramImplant="esp/ftp/esftp077.w"
                    &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage2
&Scoped-define SELF-NAME btImplant2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant2 wZoom
ON CHOOSE OF btImplant2 IN FRAME fpage2 /* Implantar */
DO:
    {zoom/implant.i &ProgramImplant="esp/ftp/esftp077.w"
                    &PageNumber="2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wZoom
ON CHOOSE OF btOK IN FRAME fPage0 /* OK */
DO:
    RUN returnValues IN THIS-PROCEDURE.
    
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brTable1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wZoom 


/* ***************************  Main Block  *************************** */

/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{zoom/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wZoom 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable1}) OR
       {&hDBOTable1}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable1}:FILE-NAME <> "esbo/boes560.p>":U THEN DO:
        {btb/btb008za.i1 esbo/boes560.p> YES}
        {btb/btb008za.i2 esbo/boes560.p> '' {&hDBOTable1}} 
    END.
    
    RUN setConstraintCanhoto IN {&hDBOTable1} (INPUT 0,
                                               INPUT 99999,
                                               INPUT "",
                                               INPUT "ZZZZZZZZZZ",
                                               INPUT "",
                                               INPUT "ZZZZZZZZZZ") NO-ERROR.

    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable2}) OR
       {&hDBOTable2}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable2}:FILE-NAME <> "esbo/boes561.p>":U THEN DO:
        {btb/btb008za.i1 esbo/boes561.p> YES}
        {btb/btb008za.i2 esbo/boes561.p> '' {&hDBOTable2}} 
    END.
                                                     
    RUN setConstraintnota IN {&hDBOTable2}    (INPUT "",
                                               INPUT "ZZZ",
                                               INPUT "",
                                               INPUT "ZZZZZ",
                                               INPUT "",
                                               INPUT "ZZZZZZZZZZZZZZZZ") NO-ERROR.

    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueries wZoom 
PROCEDURE openQueries :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualiza browsers
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.
    {zoom/openqueries.i &Query="Canhoto"
                        &PageNumber="1"}
                        
    {zoom/openqueries.i &Query="nota"
                        &PageNumber="2"}
                        
    FOR EACH tt-canhoto-nf,
        FIRST canhoto NO-LOCK
        WHERE canhoto.cod-transp = tt-canhoto-nf.cod-transp
          AND canhoto.cod-caixa  = tt-canhoto-nf.cod-caixa
          AND canhoto.cod-envelope = tt-canhoto-nf.cod-envelope:
        ASSIGN tt-canhoto-nf.r-rowid = ROWID(canhoto).
    END.

    {&open-query-brtable2}

    APPLY "value-changed" TO BROWSE brtable2.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFieldsPage1 wZoom 
PROCEDURE returnFieldsPage1 :
/*:T------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos da p gina 1
  Parameters:  recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE  INPUT PARAMETER pcField      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFieldValue AS CHARACTER NO-UNDO.
    
    IF AVAILABLE {&ttTable1} THEN DO:
        CASE pcField:
            WHEN "cod-transp":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-transp).
            WHEN "cod-caixa":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-caixa).
            WHEN "cod-envelope":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-envelope).
            WHEN "dt-recebimento":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.dt-recebimento).
        END CASE.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFieldsPage2 wZoom 
PROCEDURE returnFieldsPage2 :
/*:T------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos da p gina 1
  Parameters:  recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE  INPUT PARAMETER pcField      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFieldValue AS CHARACTER NO-UNDO.
    
    IF AVAILABLE {&ttTable2} THEN DO:
        CASE pcField:
            WHEN "cod-transp":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.cod-transp).
            WHEN "cod-caixa":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.cod-caixa).
            WHEN "cod-envelope":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.cod-envelope).
            WHEN "dt-recebimento":U THEN DO:
                FIND FIRST canhoto 
                    WHERE canhoto.cod-transp = {&tttable2}.cod-transp
                      AND canhoto.cod-caixa  = {&tttable2}.cod-caixa
                      AND canhoto.cod-envelope = {&tttable2}.cod-envelope NO-LOCK NO-ERROR.
                    IF AVAIL canhoto THEN
                        ASSIGN pcfieldvalue = STRING(canhoto.dt-recebimento).
                    ELSE ASSIGN pcfieldvalue = "".
                        
            END.
            
        END CASE.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraints wZoom 
PROCEDURE setConstraints :
/*:T------------------------------------------------------------------------------
  Purpose:     Seta constraints e atualiza o browse, conforme n£mero da p gina
               passado como parƒmetro
  Parameters:  recebe n£mero da p gina
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.
    
    /*:T--- Seta constraints conforme n£mero da p gina ---*/
    CASE pPageNumber:
        WHEN 1 THEN
            /*:T--- Seta Constraints para o DBO Table1 ---*/
            RUN setConstraintCanhoto IN {&hDBOTable1} (INPUT fnIniRangeIntPage(1,1),
                                                       INPUT fnEndRangeIntPage(1,1),
                                                       INPUT fnIniRangeCharPage(1,2),
                                                       INPUT fnEndRangeCharPage(1,2),
                                                       INPUT fnIniRangeCharPage(1,3),
                                                       INPUT fnEndRangeCharPage(1,3)).
            WHEN 2 THEN
            /*:T--- Seta Constraints para o DBO Table1 ---*/
            RUN setConstraintnota IN {&hDBOTable2} (   INPUT fnIniRangeCharPage(2,1),
                                                       INPUT fnEndRangeCharPage(2,1),
                                                       INPUT fnIniRangeCharPage(2,2),
                                                       INPUT fnEndRangeCharPage(2,2),
                                                       INPUT fnIniRangeCharPage(2,3),
                                                       INPUT fnEndRangeCharPage(2,3)).
    END CASE.


    
    /*:T--- Seta vari vel iConstraintPageNumber com o n£mero da p gina atual 
          Esta vari vel ‚ utilizada no m‚todo openQueries ---*/
    ASSIGN iConstraintPageNumber = pPageNumber.
    
    /*:T--- Atualiza browse ---*/
    RUN openQueries IN THIS-PROCEDURE.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnNmTransp wZoom 
FUNCTION fnNmTransp RETURNS CHARACTER
  ( pCod-transp AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FIND FIRST transporte NO-LOCK
        WHERE  transporte.cod-transp = pCod-transp NO-ERROR.

    ASSIGN c-nome-transp = IF AVAIL transporte THEN transporte.nome ELSE "".

    RETURN c-nome-transp.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

