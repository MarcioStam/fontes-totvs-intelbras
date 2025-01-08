&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-int-nota-conhec NO-UNDO LIKE int-nota-conhec
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
{include/i-prgvrs.i XX9999 9.99.99.999}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           z01es434
&GLOBAL-DEFINE Version           2.0.00.000

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      Notas,Conhecimento

&GLOBAL-DEFINE Range             YES

&GLOBAL-DEFINE FieldsRangePage1  mgesp.int-nota-conhec.cod-estabel,mgesp.int-nota-conhec.serie,mgesp.int-nota-conhec.nr-nota-fis,mgesp.int-nota-conhec.nr-volume,mgesp.int-nota-conhec.nr-conhec
&GLOBAL-DEFINE FieldsRangePage2  mgesp.int-nota-conhec.cod-estabel,mgesp.int-nota-conhec.serie,mgesp.int-nota-conhec.nr-nota-fis,mgesp.int-nota-conhec.nr-volume,mgesp.int-nota-conhec.nr-conhec
&GLOBAL-DEFINE FieldsAnyKeyPage1 no,no,NO,NO,NO
&GLOBAL-DEFINE FieldsAnyKeyPage2 no,no,NO,NO,NO


&GLOBAL-DEFINE ttTable1          tt-int-nota-conhec
&GLOBAL-DEFINE hDBOTable1        h-boes434
&GLOBAL-DEFINE DBOTable1         int-nota-conhec

&GLOBAL-DEFINE ttTable2          tt-int-nota-conhec
&GLOBAL-DEFINE hDBOTable2        h-boes434a
&GLOBAL-DEFINE DBOTable2         int-nota-conhec

&GLOBAL-DEFINE page1Browse       brtable1
&GLOBAL-DEFINE page2Browse       brtable2

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable1} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTable2} AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Zoom
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brTable1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-int-nota-conhec

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 tt-int-nota-conhec.cod-estabel ~
tt-int-nota-conhec.serie tt-int-nota-conhec.nr-nota-fis ~
tt-int-nota-conhec.nr-conhec tt-int-nota-conhec.nr-volume ~
tt-int-nota-conhec.xml-enviado 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH tt-int-nota-conhec NO-LOCK
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH tt-int-nota-conhec NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTable1 tt-int-nota-conhec
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 tt-int-nota-conhec


/* Definitions for BROWSE brTable2                                      */
&Scoped-define FIELDS-IN-QUERY-brTable2 tt-int-nota-conhec.nr-conhec ~
tt-int-nota-conhec.cod-estabel tt-int-nota-conhec.serie ~
tt-int-nota-conhec.nr-nota-fis tt-int-nota-conhec.nr-volume ~
tt-int-nota-conhec.xml-enviado 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable2 
&Scoped-define QUERY-STRING-brTable2 FOR EACH tt-int-nota-conhec NO-LOCK ~
    BY tt-int-nota-conhec.nr-conhec
&Scoped-define OPEN-QUERY-brTable2 OPEN QUERY brTable2 FOR EACH tt-int-nota-conhec NO-LOCK ~
    BY tt-int-nota-conhec.nr-conhec.
&Scoped-define TABLES-IN-QUERY-brTable2 tt-int-nota-conhec
&Scoped-define FIRST-TABLE-IN-QUERY-brTable2 tt-int-nota-conhec


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brTable1}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brTable2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
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
      tt-int-nota-conhec SCROLLING.

DEFINE QUERY brTable2 FOR 
      tt-int-nota-conhec SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      tt-int-nota-conhec.cod-estabel FORMAT "X(3)":U
      tt-int-nota-conhec.serie FORMAT "X(5)":U
      tt-int-nota-conhec.nr-nota-fis FORMAT "X(12)":U
      tt-int-nota-conhec.nr-conhec FORMAT "x(20)":U
      tt-int-nota-conhec.nr-volume FORMAT ">>>>>>>9":U
      tt-int-nota-conhec.xml-enviado FORMAT "yes/no":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 8.75
         FONT 2.

DEFINE BROWSE brTable2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable2 wZoom _STRUCTURED
  QUERY brTable2 NO-LOCK DISPLAY
      tt-int-nota-conhec.nr-conhec FORMAT "x(20)":U
      tt-int-nota-conhec.cod-estabel FORMAT "X(3)":U
      tt-int-nota-conhec.serie FORMAT "X(5)":U
      tt-int-nota-conhec.nr-nota-fis FORMAT "X(12)":U
      tt-int-nota-conhec.nr-volume FORMAT ">>>>>>>9":U
      tt-int-nota-conhec.xml-enviado FORMAT "yes/no":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 18.96 COL 2
     btCancel AT ROW 18.96 COL 13
     btHelp AT ROW 18.96 COL 80
     rtToolBar AT ROW 18.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 19.63
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     brTable1 AT ROW 6.25 COL 2
     btImplant1 AT ROW 15.25 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.46
         SIZE 84.43 BY 15.79
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     brTable2 AT ROW 6.25 COL 2
     btImplant2 AT ROW 15.5 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.46
         SIZE 84.43 BY 15.79
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Zoom
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
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
  CREATE WINDOW wZoom ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 19.63
         WIDTH              = 90
         MAX-HEIGHT         = 19.63
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 19.63
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brTable1 1 fPage1 */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brTable2 1 fPage2 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.tt-int-nota-conhec"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.tt-int-nota-conhec.cod-estabel
     _FldNameList[2]   = Temp-Tables.tt-int-nota-conhec.serie
     _FldNameList[3]   = Temp-Tables.tt-int-nota-conhec.nr-nota-fis
     _FldNameList[4]   = Temp-Tables.tt-int-nota-conhec.nr-conhec
     _FldNameList[5]   = Temp-Tables.tt-int-nota-conhec.nr-volume
     _FldNameList[6]   = Temp-Tables.tt-int-nota-conhec.xml-enviado
     _Query            is OPENED
*/  /* BROWSE brTable1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable2
/* Query rebuild information for BROWSE brTable2
     _TblList          = "Temp-Tables.tt-int-nota-conhec"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.tt-int-nota-conhec.nr-conhec|yes"
     _FldNameList[1]   = Temp-Tables.tt-int-nota-conhec.nr-conhec
     _FldNameList[2]   = Temp-Tables.tt-int-nota-conhec.cod-estabel
     _FldNameList[3]   = Temp-Tables.tt-int-nota-conhec.serie
     _FldNameList[4]   = Temp-Tables.tt-int-nota-conhec.nr-nota-fis
     _FldNameList[5]   = Temp-Tables.tt-int-nota-conhec.nr-volume
     _FldNameList[6]   = Temp-Tables.tt-int-nota-conhec.xml-enviado
     _Query            is OPENED
*/  /* BROWSE brTable2 */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
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
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wZoom
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
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
/*     {zoom/implant.i &ProgramImplant="<ProgramName>" */
/*                     &PageNumber="1"}                */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btImplant2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant2 wZoom
ON CHOOSE OF btImplant2 IN FRAME fPage2 /* Implantar */
DO:
/*     {zoom/implant.i &ProgramImplant="<ProgramName>" */
/*                     &PageNumber="2"}                */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wZoom
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
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
       {&hDBOTable1}:FILE-NAME <> "esbo/boes434.p":U THEN DO:
       
        {btb/btb008za.i1 esbo/boes434.p YES}
        {btb/btb008za.i2 esbo/boes434.p '' {&hDBOTable1}} 
    END.
    
    RUN setConstraintZoom1 IN {&hDBOTable1} (input "", 
                                             input "ZZZ",
                                             input "",
                                             input fill("Z", 30),
                                             input 0,
                                             input 999,
                                             input "000101",
                                             input "999999",
                                             input "",
                                             input "zzzzz") NO-ERROR.

                                             

    
    IF NOT VALID-HANDLE({&hDBOTable2}) OR
       {&hDBOTable2}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable2}:FILE-NAME <> "esbo/boes434.p":U THEN DO:
       
        {btb/btb008za.i1 esbo/boes434.p YES}
        {btb/btb008za.i2 esbo/boes434.p '' {&hDBOTable2}} 
    END.
    
    RUN setConstraintZoom1 IN {&hDBOTable2} (input "", 
                                             input "ZZZ",
                                             input "",
                                             input fill("Z", 30),
                                             input 0,
                                             input 999,
                                             input "000101",
                                             input "999999",
                                             input "",
                                             input "zzzzz") NO-ERROR.

                                             

    
    
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
    {zoom/openqueries.i &Query="Zoom1"
                        &PageNumber="1"}
    
    {zoom/openqueries.i &Query="Zoom2"
                        &PageNumber="2"}
    
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
            WHEN "cod-estabel":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-estabel).
            WHEN "serie":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.serie).
            WHEN "nr-nota-fis":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nr-nota-fis).
            WHEN "nr-volume":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nr-volume).
            WHEN "nr-conhec":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nr-conhec).
        END CASE.
    END.

    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFieldsPage2 wZoom 
PROCEDURE returnFieldsPage2 :
/*:T------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos da p gina 2
  Parameters:  recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE  INPUT PARAMETER pcField      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFieldValue AS CHARACTER NO-UNDO.
    
    IF AVAILABLE {&tttable2} THEN DO:
        CASE pcField:
            WHEN "cod-estabel":U THEN
                ASSIGN pcFieldValue = STRING({&tttable2}.cod-estabel).
            WHEN "serie":U THEN
                ASSIGN pcFieldValue = STRING({&tttable2}.serie).
            WHEN "nr-nota-fis":U THEN
                ASSIGN pcFieldValue = STRING({&tttable2}.nr-nota-fis).
            WHEN "nr-volume":U THEN
                ASSIGN pcFieldValue = STRING({&tttable2}.nr-volume).
            WHEN "nr-conhec":U THEN
                ASSIGN pcFieldValue = STRING({&tttable2}.nr-conhec).
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
    IF pPageNumber = 1 THEN DO:
        /*:T--- Seta Constraints para o DBO Table1 ---*/
        RUN setConstraintZoom1 IN {&hDBOTable1} (INPUT fnIniRangeCharPage(INPUT 1, INPUT 1),
                                                 INPUT fnEndRangeCharPage(INPUT 1, INPUT 1),
                                                 INPUT fnIniRangeCharPage(INPUT 1, INPUT 2),
                                                 INPUT fnEndRangeCharPage(INPUT 1, INPUT 2),
                                                 INPUT fnIniRangeCharPage(INPUT 1, INPUT 3),
                                                 INPUT fnEndRangeCharPage(INPUT 1, INPUT 3),
                                                 INPUT fnIniRangeCharPage(INPUT 1, INPUT 4),
                                                 INPUT fnEndRangeCharPage(INPUT 1, INPUT 4),
                                                 INPUT fnIniRangeCharPage(INPUT 1, INPUT 5),
                                                 INPUT fnEndRangeCharPage(INPUT 1, INPUT 5)).

    END.
    ELSE DO:
        /*:T--- Seta Constraints para o DBO Table1 ---*/
        RUN setConstraintZoom1 IN {&hDBOTable2} (INPUT fnIniRangeCharPage(INPUT 1, INPUT 1),
                                                 INPUT fnEndRangeCharPage(INPUT 1, INPUT 1),
                                                 INPUT fnIniRangeCharPage(INPUT 1, INPUT 2),
                                                 INPUT fnEndRangeCharPage(INPUT 1, INPUT 2),
                                                 INPUT fnIniRangeCharPage(INPUT 1, INPUT 3),
                                                 INPUT fnEndRangeCharPage(INPUT 1, INPUT 3),
                                                 INPUT fnIniRangeCharPage(INPUT 1, INPUT 4),
                                                 INPUT fnEndRangeCharPage(INPUT 1, INPUT 4),
                                                 INPUT fnIniRangeCharPage(INPUT 1, INPUT 5),
                                                 INPUT fnEndRangeCharPage(INPUT 1, INPUT 5)).

    END.



    
    /*:T--- Seta vari vel iConstraintPageNumber com o n£mero da p gina atual 
          Esta vari vel ‚ utilizada no m‚todo openQueries ---*/
    ASSIGN iConstraintPageNumber = pPageNumber.
    
    /*:T--- Atualiza browse ---*/
    RUN openQueries IN THIS-PROCEDURE.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

