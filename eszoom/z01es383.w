&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttcota-rep NO-UNDO LIKE cota-rep
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
{include/i-prgvrs.i z01es383 1.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           z01es383
&GLOBAL-DEFINE Version           1.00.00.000

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      Cota

&GLOBAL-DEFINE Range             NO

&GLOBAL-DEFINE FieldsRangePage1  /*mgesp.local.cod-tipo mgesp.local.localizacao mgesp.local.cod-depos*/

&GLOBAL-DEFINE FieldsAnyKeyPage1 NO

&GLOBAL-DEFINE ttTable1          ttcota-rep
&GLOBAL-DEFINE hDBOTable1        HDBOTTcota-rep
&GLOBAL-DEFINE DBOTable1         cota-rep

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
&Scoped-define INTERNAL-TABLES ttcota-rep repres

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 ttcota-rep.cod-diretoria ~
ttcota-rep.cod-gerente ttcota-rep.cod-rep repres.nome ttcota-rep.periodo ~
ttcota-rep.qtde 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH ttcota-rep NO-LOCK, ~
      EACH repres OF ttcota-rep NO-LOCK
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH ttcota-rep NO-LOCK, ~
      EACH repres OF ttcota-rep NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTable1 ttcota-rep repres
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 ttcota-rep
&Scoped-define SECOND-TABLE-IN-QUERY-brTable1 repres


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brTable1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-nome-rep wZoom 
FUNCTION fn-nome-rep RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

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

DEFINE BUTTON btCheck 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON btImplant1 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-fim-cod-diretoria AS CHARACTER FORMAT "X(3)" INITIAL "zzz" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88.

DEFINE VARIABLE fi-fim-cod-familia AS INTEGER FORMAT ">9":U INITIAL 99 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .79 NO-UNDO.

DEFINE VARIABLE fi-fim-cod-gerente AS INTEGER FORMAT ">>9" INITIAL 999 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88.

DEFINE VARIABLE fi-fim-cod-rep AS INTEGER FORMAT ">>>>9" INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88.

DEFINE VARIABLE fi-fim-cod-sub-familia AS INTEGER FORMAT ">9":U INITIAL 99 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .79 NO-UNDO.

DEFINE VARIABLE fi-ini-cod-diretoria AS CHARACTER FORMAT "x(8)" INITIAL "0" 
     LABEL "C¢d. diretoria":R17 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88.

DEFINE VARIABLE fi-ini-cod-familia AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Familia" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .79 NO-UNDO.

DEFINE VARIABLE fi-ini-cod-gerente AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "C¢d. gerente":R17 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88.

DEFINE VARIABLE fi-ini-cod-rep AS INTEGER FORMAT ">>>>9" INITIAL 0 
     LABEL "Representante":R17 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88.

DEFINE VARIABLE fi-ini-cod-sub-familia AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Sub Familia" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .79 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-10
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-11
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-12
     FILENAME "image/im-las.bmp":U
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

DEFINE IMAGE IMAGE-9
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      ttcota-rep, 
      repres SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      ttcota-rep.cod-diretoria COLUMN-LABEL "Diretoria" FORMAT "X(3)":U
            WIDTH 6.43
      ttcota-rep.cod-gerente COLUMN-LABEL "Gerente" FORMAT ">>9":U
            WIDTH 6.43
      ttcota-rep.cod-rep FORMAT ">>>>9":U WIDTH 6.43
      repres.nome FORMAT "x(40)":U WIDTH 34.43
      ttcota-rep.periodo FORMAT "9999/99":U WIDTH 8.43
      ttcota-rep.qtde FORMAT ">>>,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 5
         FONT 1 ROW-HEIGHT-CHARS .54 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.71 COL 2
     btCancel AT ROW 16.71 COL 13
     btHelp AT ROW 16.71 COL 80
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.98
         FONT 1.

DEFINE FRAME fPage1
     fi-ini-cod-diretoria AT ROW 1.5 COL 21 COLON-ALIGNED HELP
          "C¢digo de diretoria"
     fi-fim-cod-diretoria AT ROW 1.5 COL 45 COLON-ALIGNED NO-LABEL
     btCheck AT ROW 1.75 COL 77
     fi-ini-cod-gerente AT ROW 2.5 COL 11.28
     fi-fim-cod-gerente AT ROW 2.5 COL 47 NO-LABEL
     fi-ini-cod-rep AT ROW 3.5 COL 21 COLON-ALIGNED
     fi-fim-cod-rep AT ROW 3.5 COL 47 NO-LABEL
     fi-ini-cod-familia AT ROW 4.5 COL 21 COLON-ALIGNED
     fi-fim-cod-familia AT ROW 4.5 COL 45 COLON-ALIGNED NO-LABEL
     fi-ini-cod-sub-familia AT ROW 5.5 COL 21 COLON-ALIGNED
     fi-fim-cod-sub-familia AT ROW 5.5 COL 45 COLON-ALIGNED NO-LABEL
     brTable1 AT ROW 7.25 COL 2
     btImplant1 AT ROW 13 COL 2
     IMAGE-1 AT ROW 1.5 COL 32
     IMAGE-2 AT ROW 1.5 COL 44
     IMAGE-5 AT ROW 3.5 COL 32
     IMAGE-6 AT ROW 3.5 COL 44
     IMAGE-7 AT ROW 2.5 COL 32
     IMAGE-8 AT ROW 2.5 COL 44
     IMAGE-9 AT ROW 4.5 COL 32
     IMAGE-10 AT ROW 5.5 COL 32
     IMAGE-11 AT ROW 4.5 COL 44
     IMAGE-12 AT ROW 5.5 COL 44
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.5
         SIZE 84.43 BY 13.25
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Zoom
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttcota-rep T "?" NO-UNDO mgesp cota-rep
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brTable1 fi-fim-cod-sub-familia fPage1 */
/* SETTINGS FOR FILL-IN fi-fim-cod-gerente IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-fim-cod-rep IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-ini-cod-gerente IN FRAME fPage1
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.ttcota-rep,mgcad.repres OF Temp-Tables.ttcota-rep"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.ttcota-rep.cod-diretoria
"ttcota-rep.cod-diretoria" "Diretoria" ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" ""
     _FldNameList[2]   > Temp-Tables.ttcota-rep.cod-gerente
"ttcota-rep.cod-gerente" "Gerente" ? "integer" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" ""
     _FldNameList[3]   > Temp-Tables.ttcota-rep.cod-rep
"ttcota-rep.cod-rep" ? ? "integer" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" ""
     _FldNameList[4]   > mgcad.repres.nome
"repres.nome" ? ? "character" ? ? ? ? ? ? no ? no no "34.43" yes no no "U" "" ""
     _FldNameList[5]   > Temp-Tables.ttcota-rep.periodo
"ttcota-rep.periodo" ? ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" ""
     _FldNameList[6]   = Temp-Tables.ttcota-rep.qtde
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


    DEF VAR wh-pesquisa AS HANDLE.


  ASSIGN INPUT FRAME fpage1
         fi-ini-cod-diretoria   fi-fim-cod-diretoria 
         fi-ini-cod-gerente     fi-fim-cod-gerente 
         fi-ini-cod-rep         fi-fim-cod-rep 
         fi-ini-cod-familia     fi-fim-cod-familia
         fi-ini-cod-sub-familia fi-fim-cod-sub-familia.


  RUN setConstraints IN THIS-PROCEDURE (INPUT 1).

/*

  {include/zoomvar.i &prog-zoom="eszoom/z01es383.w"
                   &campo=ttcota-rep.cod-rep
                   &campozoom=cod-rep
                   &FRAME = fpage1
                   &campo2=c-Desc-Representante                     
                   &campozoom2=nome
                   &FRAME2 = fpage1}.

  */
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
    /*
    {zoom/Implant.i &ProgramImplant="<ProgramName>"
                    &PageNumber="1"}
    */                    
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

    DISP fi-ini-cod-diretoria   fi-fim-cod-diretoria 
         fi-ini-cod-gerente     fi-fim-cod-gerente 
         fi-ini-cod-rep         fi-fim-cod-rep
         fi-ini-cod-familia     fi-fim-cod-familia
         fi-ini-cod-sub-familia fi-fim-cod-sub-familia WITH FRAME fPage1.

    ENABLE fi-ini-cod-diretoria     fi-fim-cod-diretoria
           fi-ini-cod-gerente       fi-fim-cod-gerente 
           fi-ini-cod-rep           fi-fim-cod-rep 
           fi-ini-cod-familia       fi-fim-cod-familia
           fi-ini-cod-sub-familia   fi-fim-cod-sub-familia btCheck WITH FRAME fPage1.

    APPLY "choose" TO btCheck IN FRAME fPage1.
    APPLY "entry" TO fi-ini-cod-diretoria IN FRAME fPage1.

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
       {&hDBOTable1}:FILE-NAME <> "esbo/boes383.p":U THEN DO:
       
        {btb/btb008za.i1 esbo/boes383.p YES}
        {btb/btb008za.i2 esbo/boes383.p '' {&hDBOTable1}} 
    END.

    /* A linha abaixo ‚ utilizada para trazer o browse carregado com uma faixa inicial
       pr‚-definida na primeira chamada do programa*/

    RUN setConstraintByCod IN {&hDBOTable1} (INPUT 0, INPUT 999, INPUT 0, INPUT 999, INPUT 0, INPUT 99999, INPUT 0, INPUT 99, INPUT 0, INPUT 99).

    /* A linha abaixo, original da Template pode ser comentada 
    
    RUN openQueryStatic IN {&hDBOTable1} (INPUT "Main":U) NO-ERROR.
     
    */
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    
    /* A linha abaixo ‚ utilizada para trazer o browse carregado com uma faixa inicial
       pr‚-definida na primeira chamada do programa*/

   
    /* A linha abaixo, original da Template pode ser comentada 
    
    RUN openQueryStatic IN {&hDBOTable2} (INPUT "ByNameSel":U) NO-ERROR.
    */  
    
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
            WHEN "Diretoria":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-diretoria).
            WHEN "Gerente":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-gerente).
            WHEN "Repres.":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-rep).
            WHEN "Per¡odo":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.periodo).
            WHEN "Qtde":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.qtde).
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
                (INPUT fi-ini-cod-diretoria,
                 INPUT fi-fim-cod-diretoria,
                 INPUT fi-ini-cod-gerente,
                 INPUT fi-fim-cod-gerente,
                 INPUT fi-ini-cod-rep,
                 INPUT fi-fim-cod-rep,
                 INPUT fi-ini-cod-familia,
                 INPUT fi-fim-cod-familia,
                 INPUT fi-ini-cod-sub-familia,
                 INPUT fi-fim-cod-sub-familia).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-nome-rep wZoom 
FUNCTION fn-nome-rep RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FIND repres NO-LOCK WHERE 
       repres.cod-rep = ttcota-rep.cod-rep NO-ERROR.


  IF AVAIL repres THEN
     RETURN repres.nome.   /* Function return value. */
  ELSE
     RETURN " ".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

