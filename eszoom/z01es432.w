&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-cota-representante NO-UNDO LIKE cota-representante
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
{include/i-prgvrs.i Z01ES432 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           Z01ES432
&GLOBAL-DEFINE Version           2.04.00.001

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      Cota Representante

&GLOBAL-DEFINE Range             no

&GLOBAL-DEFINE FieldsRangePage1  /*mgesp.cota-representante.cod-estabel,mgesp.cota-representante.cod-rep,mgesp.cota-representante.fm-cod-com,mgesp.cota-representante.it-codigo,mgesp.cota-representante.periodo*/
&GLOBAL-DEFINE FieldsAnyKeyPage1 /*NO,NO,NO,no*/

&GLOBAL-DEFINE ttTable1          tt-cota-representante
&GLOBAL-DEFINE hDBOTable1        h-boes432
&GLOBAL-DEFINE DBOTable1         cota-representante

&GLOBAL-DEFINE page1Browse       brTable1

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable1} AS HANDLE NO-UNDO.

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
&Scoped-define INTERNAL-TABLES tt-cota-representante

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 tt-cota-representante.cod-estabel ~
tt-cota-representante.cod-rep tt-cota-representante.fm-cod-com ~
tt-cota-representante.cd-uf tt-cota-representante.it-codigo ~
tt-cota-representante.periodo tt-cota-representante.qt-orcamento ~
tt-cota-representante.qt-representante tt-cota-representante.valor 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH tt-cota-representante NO-LOCK
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH tt-cota-representante NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTable1 tt-cota-representante
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 tt-cota-representante


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brTable1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar IMAGE-10 btOK btCancel btHelp 

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

DEFINE IMAGE IMAGE-10
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 105 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON btCheck 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON btImplant1 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE fiCodEstabelFim AS CHARACTER FORMAT "x(3)" INITIAL "ZZZ" 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79 NO-UNDO.

DEFINE VARIABLE fiCodEstabelIni AS CHARACTER FORMAT "x(3)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79 NO-UNDO.

DEFINE VARIABLE fiCodRepFim AS INTEGER FORMAT ">>>>9" INITIAL 99999 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79 NO-UNDO.

DEFINE VARIABLE fiCodRepIni AS INTEGER FORMAT ">>>>9" INITIAL 0 
     LABEL "Representante" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79 NO-UNDO.

DEFINE VARIABLE fiFmCodComFim AS CHARACTER FORMAT "X(8)" INITIAL "ZZZZZZZZ" 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79 NO-UNDO.

DEFINE VARIABLE fiFmCodComIni AS CHARACTER FORMAT "X(8)" 
     LABEL "Fam¡lia Comercial" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79 NO-UNDO.

DEFINE VARIABLE fiItCodigoFim AS CHARACTER FORMAT "X(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79 NO-UNDO.

DEFINE VARIABLE fiItCodigoIni AS CHARACTER FORMAT "X(16)" 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79 NO-UNDO.

DEFINE VARIABLE fiPeriodoFim AS CHARACTER FORMAT "9999/99" INITIAL "999912" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79 NO-UNDO.

DEFINE VARIABLE fiPeriodoIni AS CHARACTER FORMAT "9999/99" INITIAL "000101" 
     LABEL "Per¡odo" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79 NO-UNDO.

DEFINE IMAGE IMAGE-12
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-13
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-14
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-15
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-16
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-17
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-18
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-19
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-20
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-21
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      tt-cota-representante SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      tt-cota-representante.cod-estabel FORMAT "x(3)":U WIDTH 4.43
      tt-cota-representante.cod-rep COLUMN-LABEL "Repres." FORMAT ">>>>9":U
      tt-cota-representante.fm-cod-com COLUMN-LABEL "Fam.Comercial" FORMAT "x(8)":U
      tt-cota-representante.cd-uf FORMAT "x(02)":U
      tt-cota-representante.it-codigo FORMAT "x(7)":U
      tt-cota-representante.periodo FORMAT "9999/99":U
      tt-cota-representante.qt-orcamento FORMAT "->>>>,>>9.99":U
      tt-cota-representante.qt-representante FORMAT "->>>>,>>9.99":U
      tt-cota-representante.valor FORMAT ">>>>>,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 99 BY 10.08
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 20.5 COL 2
     btCancel AT ROW 20.5 COL 13
     btHelp AT ROW 20.5 COL 95
     rtToolBar AT ROW 20.29 COL 1
     IMAGE-10 AT ROW 5.5 COL 32 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 107 BY 20.71
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     fiCodEstabelIni AT ROW 1.25 COL 31 COLON-ALIGNED HELP
          "Estabelecimento" WIDGET-ID 12
     fiCodEstabelFim AT ROW 1.25 COL 59 COLON-ALIGNED HELP
          "Estabelecimento" WIDGET-ID 14
     btCheck AT ROW 1.25 COL 95 WIDGET-ID 10
     fiCodRepIni AT ROW 2.25 COL 31 COLON-ALIGNED HELP
          "Representante" WIDGET-ID 16
     fiCodRepFim AT ROW 2.25 COL 59 COLON-ALIGNED HELP
          "Representante" WIDGET-ID 18
     fiFmCodComIni AT ROW 3.25 COL 31 COLON-ALIGNED HELP
          "Fam¡lia Comercial" WIDGET-ID 20
     fiFmCodComFim AT ROW 3.25 COL 59 COLON-ALIGNED HELP
          "Fam¡lia Comercial" WIDGET-ID 22
     fiItCodigoIni AT ROW 4.25 COL 31 COLON-ALIGNED HELP
          "Item" WIDGET-ID 26
     fiItCodigoFim AT ROW 4.25 COL 59 COLON-ALIGNED HELP
          "Item" WIDGET-ID 24
     fiPeriodoIni AT ROW 5.25 COL 31 COLON-ALIGNED HELP
          "Per¡odo" WIDGET-ID 2
     fiPeriodoFim AT ROW 5.25 COL 59 COLON-ALIGNED HELP
          "Per¡odo" NO-LABEL WIDGET-ID 4
     brTable1 AT ROW 6.5 COL 2
     btImplant1 AT ROW 16.63 COL 2
     IMAGE-13 AT ROW 5.25 COL 45 WIDGET-ID 6
     IMAGE-12 AT ROW 5.25 COL 58 WIDGET-ID 8
     IMAGE-14 AT ROW 4.25 COL 45 WIDGET-ID 30
     IMAGE-15 AT ROW 4.25 COL 58 WIDGET-ID 28
     IMAGE-16 AT ROW 3.25 COL 45 WIDGET-ID 34
     IMAGE-17 AT ROW 3.25 COL 58 WIDGET-ID 32
     IMAGE-18 AT ROW 2.25 COL 45 WIDGET-ID 38
     IMAGE-19 AT ROW 2.25 COL 58 WIDGET-ID 36
     IMAGE-20 AT ROW 1.25 COL 45 WIDGET-ID 42
     IMAGE-21 AT ROW 1.25 COL 58 WIDGET-ID 40
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.46
         SIZE 102.43 BY 17.04
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Zoom
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-cota-representante T "?" NO-UNDO mgesp cota-representante
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
         HEIGHT             = 20.71
         WIDTH              = 107
         MAX-HEIGHT         = 24.17
         MAX-WIDTH          = 107
         VIRTUAL-HEIGHT     = 24.17
         VIRTUAL-WIDTH      = 107
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brTable1 fiPeriodoFim fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.tt-cota-representante"
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST, FIRST"
     _FldNameList[1]   > Temp-Tables.tt-cota-representante.cod-estabel
"cod-estabel" ? ? "character" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-cota-representante.cod-rep
"cod-rep" "Repres." ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-cota-representante.fm-cod-com
"fm-cod-com" "Fam.Comercial" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = Temp-Tables.tt-cota-representante.cd-uf
     _FldNameList[5]   > Temp-Tables.tt-cota-representante.it-codigo
"it-codigo" ? "x(7)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = Temp-Tables.tt-cota-representante.periodo
     _FldNameList[7]   > Temp-Tables.tt-cota-representante.qt-orcamento
"qt-orcamento" ? "->>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-cota-representante.qt-representante
"qt-representante" ? "->>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-cota-representante.valor
"valor" ? ">>>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brTable1 */
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btCheck
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCheck wZoom
ON CHOOSE OF btCheck IN FRAME fPage1
DO:

  assign input frame fPage1
      fiCodEstabelIni
      fiCodEstabelFim
      fiCodRepIni
      fiCodRepFim
      fiFmCodComIni
      fiFmCodComFim
      fiItCodigoIni
      fiItCodigoFim
      fiPeriodoIni
      fiPeriodoFim.

  RUN setConstraints IN THIS-PROCEDURE (INPUT 1).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wZoom
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wZoom 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   display
      fiCodEstabelIni
      fiCodEstabelFim
      fiCodRepIni
      fiCodRepFim
      fiFmCodComIni
      fiFmCodComFim
      fiItCodigoIni
      fiItCodigoFim
      fiPeriodoIni
      fiPeriodoFim
      with frame fPage1.

   enable
      fiCodEstabelIni
      fiCodEstabelFim
      fiCodRepIni
      fiCodRepFim
      fiFmCodComIni
      fiFmCodComFim
      fiItCodigoIni
      fiItCodigoFim
      fiPeriodoIni
      fiPeriodoFim
      btCheck
      with frame fPage1.

   apply "choose" to btCheck in frame fPage1.
   apply "entry" to fiCodEstabelIni in frame fPage1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
       {&hDBOTable1}:FILE-NAME <> "esbo/boes432.p":U THEN DO:
       
        {btb/btb008za.i1 esbo/boes432.p YES}
        {btb/btb008za.i2 esbo/boes432.p '' {&hDBOTable1}} 
    END.
    
    RUN setConstraintZoom1 IN {&hDBOTable1} (input "", 
                                             input "ZZZ",
                                             input 0,
                                             input 99999,
                                             input "",
                                             input fill("Z", 8),
                                             input "",
                                             input fill("Z", 16),
                                             input "000101",
                                             input "999912") NO-ERROR.

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
            WHEN "cod-rep":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-rep).
            WHEN "fm-cod-com":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.fm-cod-com).
            WHEN "it-codigo":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.it-codigo).
            WHEN "periodo":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.periodo).
            WHEN "qt-orcamento":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.qt-orcamento).
            WHEN "qt-representante":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.qt-representante).
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
            RUN setConstraintZoom1 IN {&hDBOTable1} (INPUT fiCodEstabelIni:screen-value in frame fPage1,
                                                     INPUT fiCodEstabelFim:screen-value in frame fPage1,
                                                     INPUT fiCodRepIni:screen-value in frame fPage1,
                                                     INPUT fiCodRepFim:screen-value in frame fPage1,
                                                     INPUT fiFmCodComIni:screen-value in frame fPage1,
                                                     INPUT fiFmCodComFim:screen-value in frame fPage1,
                                                     INPUT fiItCodigoIni:screen-value in frame fPage1,
                                                     INPUT fiItCodigoFim:screen-value in frame fPage1,
                                                     INPUT fiPeriodoIni:screen-value in frame fPage1,
                                                     INPUT fiPeriodoFim:screen-value in frame fPage1).

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

