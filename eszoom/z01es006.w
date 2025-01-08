&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttae-bloqueado NO-UNDO LIKE ae-bloqueado
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
{include/i-prgvrs.i z01es006 1.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           z01es006
&GLOBAL-DEFINE Version           1.00.00.000

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      AE Bloqueado

&GLOBAL-DEFINE Range             NO

&GLOBAL-DEFINE FieldsRangePage1  /*mgesp.usu-dep.cod-depos mgesp.usu-dep.usuario mgesp.usu-dep.programa*/
&GLOBAL-DEFINE FieldsAnyKeyPage1 NO

&GLOBAL-DEFINE ttTable1          TTAe-Bloqueado
&GLOBAL-DEFINE hDBOTable1        HDBOTTAe-Bloqueado
&GLOBAL-DEFINE DBOTable1         Ae-Bloqueado

&GLOBAL-DEFINE page1Browse       brTable1

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable1} AS HANDLE NO-UNDO.
{upc\btb910za-upc.i}

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
&Scoped-define INTERNAL-TABLES ttae-bloqueado

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 ttae-bloqueado.nr-ae ~
ttae-bloqueado.it-codigo ttae-bloqueado.sequencia ~
ttae-bloqueado.narrativa[1] ttae-bloqueado.narrativa[2] ~
ttae-bloqueado.narrativa[3] ttae-bloqueado.narrativa[4] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH ttae-bloqueado NO-LOCK
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH ttae-bloqueado NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTable1 ttae-bloqueado
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 ttae-bloqueado


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brTable1}

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

DEFINE BUTTON btCheck 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON btImplant1 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-cod-estabel AS CHARACTER FORMAT "X(16)" 
     LABEL "Estabelecimento":R17 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE fi-fim-it-codigo AS CHARACTER FORMAT "X(16)" INITIAL "zzzzzzzzzzzzzzzz" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-fim-nr-ae AS INTEGER FORMAT ">>>>>>9" INITIAL 9999999 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88.

DEFINE VARIABLE fi-fim-sequencia AS INTEGER FORMAT ">>9" INITIAL 999 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE fi-ini-it-codigo AS CHARACTER FORMAT "X(16)" 
     LABEL "Item":R17 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-ini-nr-ae AS INTEGER FORMAT ">>>>>>9" INITIAL 0 
     LABEL "Nr AE":R17 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88.

DEFINE VARIABLE fi-ini-sequencia AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Sequˆncia":R17 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-10
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-7
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-8
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-9
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      ttae-bloqueado SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      ttae-bloqueado.nr-ae FORMAT "9999999":U
      ttae-bloqueado.it-codigo FORMAT "x(16)":U
      ttae-bloqueado.sequencia FORMAT "999":U
      ttae-bloqueado.narrativa[1] COLUMN-LABEL "Narrativa 1" FORMAT "x(70)":U
      ttae-bloqueado.narrativa[2] COLUMN-LABEL "Narrativa 2" FORMAT "x(70)":U
      ttae-bloqueado.narrativa[3] COLUMN-LABEL "Narrativa 3" FORMAT "x(70)":U
      ttae-bloqueado.narrativa[4] COLUMN-LABEL "Narrativa 4" FORMAT "x(70)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 8.25
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 18 COL 2
     btCancel AT ROW 18 COL 13
     btHelp AT ROW 18 COL 80
     rtToolBar AT ROW 17.79 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 18.75
         FONT 1.

DEFINE FRAME fPage1
     fi-cod-estabel AT ROW 1.5 COL 22 COLON-ALIGNED WIDGET-ID 4
     fi-ini-nr-ae AT ROW 2.5 COL 21 COLON-ALIGNED
     fi-fim-nr-ae AT ROW 2.5 COL 45 COLON-ALIGNED NO-LABEL
     btCheck AT ROW 2.5 COL 77
     fi-ini-sequencia AT ROW 3.5 COL 15.43 WIDGET-ID 12
     fi-fim-sequencia AT ROW 3.5 COL 47 NO-LABEL WIDGET-ID 10
     fi-ini-it-codigo AT ROW 4.5 COL 14 COLON-ALIGNED
     fi-fim-it-codigo AT ROW 4.5 COL 45 COLON-ALIGNED NO-LABEL
     brTable1 AT ROW 5.75 COL 2.43
     btImplant1 AT ROW 14 COL 2
     IMAGE-1 AT ROW 2.5 COL 32
     IMAGE-10 AT ROW 4.5 COL 44
     IMAGE-2 AT ROW 2.5 COL 44
     IMAGE-9 AT ROW 4.5 COL 32
     IMAGE-7 AT ROW 3.5 COL 32 WIDGET-ID 14
     IMAGE-8 AT ROW 3.5 COL 44 WIDGET-ID 16
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.75
         SIZE 84.43 BY 14.29
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Zoom
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttae-bloqueado T "?" NO-UNDO mgesp ae-bloqueado
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
         HEIGHT             = 18.75
         WIDTH              = 90
         MAX-HEIGHT         = 18.75
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 18.75
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
/* BROWSE-TAB brTable1 fi-fim-it-codigo fPage1 */
/* SETTINGS FOR FILL-IN fi-fim-sequencia IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-ini-sequencia IN FRAME fPage1
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.ttae-bloqueado"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.ttae-bloqueado.nr-ae
     _FldNameList[2]   = Temp-Tables.ttae-bloqueado.it-codigo
     _FldNameList[3]   = Temp-Tables.ttae-bloqueado.sequencia
     _FldNameList[4]   > Temp-Tables.ttae-bloqueado.narrativa[1]
"ttae-bloqueado.narrativa[1]" "Narrativa 1" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.ttae-bloqueado.narrativa[2]
"ttae-bloqueado.narrativa[2]" "Narrativa 2" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ttae-bloqueado.narrativa[3]
"ttae-bloqueado.narrativa[3]" "Narrativa 3" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.ttae-bloqueado.narrativa[4]
"ttae-bloqueado.narrativa[4]" "Narrativa 4" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
         fi-cod-estabel fi-ini-nr-ae fi-fim-nr-ae fi-ini-it-codigo fi-fim-it-codigo fi-ini-sequencia fi-fim-sequencia.
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
  /*  {zoom/Implant.i &ProgramImplant="<ProgramName>"
                    &PageNumber="1"}                 */
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

    ASSIGN fi-cod-estabel:SCREEN-VALUE IN FRAME fPage1 = v_cod_estab_usuar.

    DISP fi-ini-nr-ae fi-fim-nr-ae fi-ini-it-codigo fi-fim-it-codigo fi-ini-sequencia fi-fim-sequencia WITH FRAME fPage1.
    ENABLE fi-ini-nr-ae fi-fim-nr-ae fi-ini-it-codigo fi-fim-it-codigo fi-ini-sequencia fi-fim-sequencia btCheck WITH FRAME fPage1.
    APPLY "choose" TO btCheck IN FRAME fPage1.
    APPLY "entry" TO fi-ini-nr-ae IN FRAME fPage1.
 
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
       {&hDBOTable1}:FILE-NAME <> "esbo/boes006.p":U THEN DO:
       
        {btb/btb008za.i1 esbo/boes006.p YES}
        {btb/btb008za.i2 esbo/boes006.p '' {&hDBOTable1}} 
    END.

    /* A linha abaixo ‚ utilizada para trazer o browse carregado com uma faixa inicial
       pr‚-definida na primeira chamada do programa*/

    RUN setConstraintByCod IN {&hDBOTable1} (input v_cod_estab_usuar,
                                             INPUT 0, 
                                             INPUT 9999999, 
                                             INPUT 0, 
                                             INPUT 999,
                                             INPUT "", 
                                             INPUT "zzzzzzzzzzzzzzzz").
                                             
    
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
            WHEN "nr-ae":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nr-ae).
            WHEN "it-codigo":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.it-codigo).
            WHEN "sequencia":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.sequencia).
            WHEN "narrativa[1]":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.narrativa[1]).
            WHEN "narrativa[2]":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.narrativa[2]).
            WHEN "narrativa[3]":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.narrativa[3]).
            WHEN "narrativa[4]":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.narrativa[4]).
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
                (input fi-cod-estabel,
                 INPUT fi-ini-nr-ae,
                 INPUT fi-fim-nr-ae,
                 INPUT fi-ini-sequencia,
                 INPUT fi-fim-sequencia,
                 INPUT fi-ini-it-codigo,
                 INPUT fi-fim-it-codigo).
                 
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

