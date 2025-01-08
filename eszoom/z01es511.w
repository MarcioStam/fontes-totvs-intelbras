&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttint-unid-neg-natur NO-UNDO LIKE int-unid-neg-natur
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
{include/i-prgvrs.i z01es511 1.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           z01es511
&GLOBAL-DEFINE Version           1.00.00.000

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      Nat Opera‡Æo

&GLOBAL-DEFINE Range             NO

&GLOBAL-DEFINE FieldsRangePage1  /*mgesp.int-unid-neg-natur.cod-estabel mgesp.int-unid-neg-natur.nat-operacao mgesp.int-unid-neg-natur.cod-unid-negoc*/
&GLOBAL-DEFINE FieldsAnyKeyPage1 NO

&GLOBAL-DEFINE ttTable1          TTint-unid-neg-natur
&GLOBAL-DEFINE hDBOTable1        HDBOTTint-unid-neg-natur
&GLOBAL-DEFINE DBOTable1         int-unid-neg-natur

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
&Scoped-define INTERNAL-TABLES ttint-unid-neg-natur

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 ttint-unid-neg-natur.cod-estabel ~
ttint-unid-neg-natur.cod-unid-negoc ttint-unid-neg-natur.nat-operacao 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH ttint-unid-neg-natur NO-LOCK
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH ttint-unid-neg-natur NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTable1 ttint-unid-neg-natur
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 ttint-unid-neg-natur


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brTable1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btOK btCancel btHelp rtToolBar 

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

DEFINE BUTTON btCheck 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON btImplant1 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-fim-cod-estabel AS CHARACTER FORMAT "X(3)" INITIAL "zzz" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE fi-fim-cod-unid-negoc AS CHARACTER FORMAT "X(3)" INITIAL "zzz" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88.

DEFINE VARIABLE fi-fim-nat-operacao AS CHARACTER FORMAT "X(6)" INITIAL "zzzzzz" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88.

DEFINE VARIABLE fi-ini-cod-estabel AS CHARACTER FORMAT "X(3)" 
     LABEL "Estabelecimento":R17 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE fi-ini-cod-unid-negoc AS CHARACTER FORMAT "X(3)" 
     LABEL "Unid Neg¢cio":R17 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88.

DEFINE VARIABLE fi-ini-nat-operacao AS CHARACTER FORMAT "X(6)" 
     LABEL "Nat Opera‡Æo":R17 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-5
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-6
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-7
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-8
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      ttint-unid-neg-natur SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      ttint-unid-neg-natur.cod-estabel FORMAT "x(3)":U
      ttint-unid-neg-natur.cod-unid-negoc FORMAT "x(3)":U
      ttint-unid-neg-natur.nat-operacao FORMAT "x(6)":U
      ttint-unid-neg-natur.ct-codigo FORMAT "x(18)":U
      ttint-unid-neg-natur.sc-codigo FORMAT "x(18)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 7.25
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.71 COL 2
     btCancel AT ROW 16.71 COL 13
     btHelp AT ROW 16.71 COL 80
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.67
         FONT 1.

DEFINE FRAME fPage1
     fi-ini-cod-estabel AT ROW 1.5 COL 25 COLON-ALIGNED
     fi-fim-cod-estabel AT ROW 1.5 COL 45 COLON-ALIGNED NO-LABEL
     btCheck AT ROW 1.5 COL 77
     fi-ini-cod-unid-negoc AT ROW 2.5 COL 11.86
     fi-fim-cod-unid-negoc AT ROW 2.5 COL 47 NO-LABEL
    fi-ini-nat-operacao AT ROW 3.5 COL 19 COLON-ALIGNED
    fi-fim-nat-operacao AT ROW 3.5 COL 47 NO-LABEL
     brTable1 AT ROW 5.75 COL 2
     btImplant1 AT ROW 13 COL 2
     IMAGE-1 AT ROW 1.5 COL 32
     IMAGE-2 AT ROW 1.5 COL 44
     IMAGE-5 AT ROW 2.5 COL 32
     IMAGE-6 AT ROW 2.5 COL 44
     IMAGE-7 AT ROW 3.5 COL 32
     IMAGE-8 AT ROW 3.5 COL 44
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Zoom
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttint-unid-neg-natur T "?" NO-UNDO mgesp int-unid-neg-natur
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
         HEIGHT             = 17.46
         WIDTH              = 90
         MAX-HEIGHT         = 20.54
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 20.54
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brTable1 fi-saida fPage1 */
/* SETTINGS FOR FILL-IN fi-fim-cod-unid-negoc IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-fim-nat-operacao IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-ini-cod-unid-negoc IN FRAME fPage1
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.ttint-unid-neg-natur"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.ttint-unid-neg-natur.cod-estabel
     _FldNameList[2]   = Temp-Tables.ttint-unid-neg-natur.nat-operacao
     _FldNameList[3]   = Temp-Tables.ttint-unid-neg-natur.cod-unid-negoc
     _FldNameList[4]   = Temp-Tables.ttint-unid-neg-natur.conta-contabil
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
  ASSIGN INPUT FRAME fpage1
         fi-ini-cod-estabel fi-fim-cod-estabel fi-ini-nat-operacao fi-fim-nat-operacao fi-ini-cod-unid-negoc fi-fim-cod-unid-negoc.
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btImplant1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant1 wZoom
ON CHOOSE OF btImplant1 IN FRAME fPage1 /* Implantar */
DO:
   /* {zoom/Implant.i &ProgramImplant="<ProgramName>"
                    &PageNumber="1"}*/
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

/*:T--- L¢gica para inicializa‡Æo do cod-unid-negocm ---*/
{Zoom/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wZoom 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DISP fi-ini-cod-estabel fi-fim-cod-estabel fi-ini-nat-operacao fi-fim-nat-operacao fi-ini-cod-unid-negoc fi-fim-cod-unid-negoc WITH FRAME fPage1.
    ENABLE fi-ini-cod-estabel fi-fim-cod-estabel fi-ini-nat-operacao fi-fim-nat-operacao fi-ini-cod-unid-negoc fi-fim-cod-unid-negoc btCheck WITH FRAME fPage1.
    APPLY "choose" TO btCheck IN FRAME fPage1.
    APPLY "entry" TO fi-ini-cod-estabel IN FRAME fPage1.
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
       {&hDBOTable1}:FILE-NAME <> "esbo/boes511.p":U THEN DO:
       
        {btb/btb008za.i1 esbo/boes511.p YES}
        {btb/btb008za.i2 esbo/boes511.p '' {&hDBOTable1}} 
    END.

    /* A linha abaixo ‚ utilizada para trazer o browse carregado com uma faixa inicial
       pr‚-definida na primeira chamada do cod-unid-negoc*/

    RUN setConstraintByCod IN {&hDBOTable1} (INPUT "", INPUT "zzz", INPUT "", INPUT "zzz", INPUT "", INPUT "zzzzzz").
    
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
    
    {zoom/OpenQueries.i &Query="ByCod"
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
            WHEN "nat-operacao":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nat-operacao).
            WHEN "cod-unid-negoc":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-unid-negoc).
            WHEN "ct-codigo":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.ct-codigo).
            WHEN "sc-codigo":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.sc-codigo).

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
            RUN setConstraintByCod IN {&hDBOTable1} 
                (INPUT fi-ini-cod-estabel,
                 INPUT fi-fim-cod-estabel,
                 INPUT fi-ini-cod-unid-negoc,
                 INPUT fi-fim-cod-unid-negoc,
                 INPUT fi-ini-nat-operacao,
                 INPUT fi-fim-nat-operacao).
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

