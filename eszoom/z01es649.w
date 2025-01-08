&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          emsfnd           PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-usuar_mestre-1 NO-UNDO LIKE usuar_mestre
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-usuar_mestre-2 NO-UNDO LIKE usuar_mestre
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wZoom 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i z01es649 2.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           z01es649
&GLOBAL-DEFINE Version           2.00.00.000

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      Usuario,Nome

&GLOBAL-DEFINE Range             NO

&GLOBAL-DEFINE ttTable1          tt-usuar_mestre-1
&GLOBAL-DEFINE hDBOTable1        h-boes913-1
&GLOBAL-DEFINE DBOTable1         usuar_mestre

&GLOBAL-DEFINE ttTable2          tt-usuar_mestre-2
&GLOBAL-DEFINE hDBOTable2        h-boes913-2      
&GLOBAL-DEFINE DBOTable2         usuar_mestre   

&GLOBAL-DEFINE page1Browse       brTable1
&GLOBAL-DEFINE page2Browse       brTable2

&GLOBAL-DEFINE numRowsReturned   999999

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
&Scoped-define INTERNAL-TABLES tt-usuar_mestre-1 tt-usuar_mestre-2

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 tt-usuar_mestre-1.cod_usuario ~
tt-usuar_mestre-1.nom_usuario tt-usuar_mestre-1.idi_dtsul 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH tt-usuar_mestre-1 NO-LOCK ~
    BY tt-usuar_mestre-1.cod_usuario
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH tt-usuar_mestre-1 NO-LOCK ~
    BY tt-usuar_mestre-1.cod_usuario.
&Scoped-define TABLES-IN-QUERY-brTable1 tt-usuar_mestre-1
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 tt-usuar_mestre-1


/* Definitions for BROWSE brTable2                                      */
&Scoped-define FIELDS-IN-QUERY-brTable2 tt-usuar_mestre-2.nom_usuario ~
tt-usuar_mestre-2.cod_usuario tt-usuar_mestre-2.idi_dtsul 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable2 
&Scoped-define QUERY-STRING-brTable2 FOR EACH tt-usuar_mestre-2 NO-LOCK ~
    BY tt-usuar_mestre-2.nom_usuario
&Scoped-define OPEN-QUERY-brTable2 OPEN QUERY brTable2 FOR EACH tt-usuar_mestre-2 NO-LOCK ~
    BY tt-usuar_mestre-2.nom_usuario.
&Scoped-define TABLES-IN-QUERY-brTable2 tt-usuar_mestre-2
&Scoped-define FIRST-TABLE-IN-QUERY-brTable2 tt-usuar_mestre-2


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

DEFINE BUTTON btCheck 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "btcheck" 
     SIZE 5 BY 1.

DEFINE BUTTON btImplant1 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-usuar-fim AS CHARACTER FORMAT "X(40)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fi-usuar-ini AS CHARACTER FORMAT "X(40)":U INITIAL "0" 
     LABEL "C¢digo Usu rio" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE BUTTON btCheck-2 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "btcheck" 
     SIZE 5 BY 1.

DEFINE BUTTON btImplant2 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-nome-fim AS CHARACTER FORMAT "X(40)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 25.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-ini AS CHARACTER FORMAT "X(40)":U 
     LABEL "Nome Usu rio" 
     VIEW-AS FILL-IN 
     SIZE 25.29 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-15
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-16
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      tt-usuar_mestre-1 SCROLLING.

DEFINE QUERY brTable2 FOR 
      tt-usuar_mestre-2 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      tt-usuar_mestre-1.cod_usuario FORMAT "x(12)":U
      tt-usuar_mestre-1.nom_usuario FORMAT "x(32)":U
      tt-usuar_mestre-1.idi_dtsul COLUMN-LABEL "ID Datasul" FORMAT ">>>>>9":U
            WIDTH 10.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.5
         FONT 2.

DEFINE BROWSE brTable2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable2 wZoom _STRUCTURED
  QUERY brTable2 NO-LOCK DISPLAY
      tt-usuar_mestre-2.nom_usuario FORMAT "x(32)":U
      tt-usuar_mestre-2.cod_usuario FORMAT "x(12)":U
      tt-usuar_mestre-2.idi_dtsul COLUMN-LABEL "ID Datasul" FORMAT ">>>>>9":U
            WIDTH 9.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 79.72 BY 9.5
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
         SIZE 90 BY 16.96
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     fi-usuar-ini AT ROW 1.25 COL 20 COLON-ALIGNED WIDGET-ID 6
     fi-usuar-fim AT ROW 1.25 COL 51 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     btCheck AT ROW 2.25 COL 74 WIDGET-ID 2
     brTable1 AT ROW 3.5 COL 2 WIDGET-ID 200
     btImplant1 AT ROW 13 COL 2 WIDGET-ID 4
     IMAGE-1 AT ROW 1.25 COL 33 WIDGET-ID 10
     IMAGE-2 AT ROW 1.25 COL 50 WIDGET-ID 12
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     fi-nome-ini AT ROW 1.5 COL 11 COLON-ALIGNED WIDGET-ID 6
     fi-nome-fim AT ROW 1.5 COL 48 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     btCheck-2 AT ROW 2.25 COL 76 WIDGET-ID 2
     brTable2 AT ROW 3.5 COL 2 WIDGET-ID 200
     btImplant2 AT ROW 13 COL 2 WIDGET-ID 4
     IMAGE-15 AT ROW 1.5 COL 38 WIDGET-ID 10
     IMAGE-16 AT ROW 1.5 COL 47 WIDGET-ID 12
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1 WIDGET-ID 300.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Zoom
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-usuar_mestre-1 T "?" NO-UNDO emsfnd usuar_mestre
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-usuar_mestre-2 T "?" NO-UNDO emsfnd usuar_mestre
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
         HEIGHT             = 16.96
         WIDTH              = 90
         MAX-HEIGHT         = 28.21
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28.21
         VIRTUAL-WIDTH      = 195.14
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
/* BROWSE-TAB brTable1 btCheck fPage1 */
/* SETTINGS FOR BUTTON btCheck IN FRAME fPage1
   NO-ENABLE                                                            */
ASSIGN 
       btCheck:HIDDEN IN FRAME fPage1           = TRUE.

/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brTable2 btCheck-2 fPage2 */
ASSIGN 
       tt-usuar_mestre-2.nom_usuario:AUTO-RESIZE IN BROWSE brTable2 = TRUE
       tt-usuar_mestre-2.cod_usuario:AUTO-RESIZE IN BROWSE brTable2 = TRUE
       tt-usuar_mestre-2.idi_dtsul:AUTO-RESIZE IN BROWSE brTable2 = TRUE.

/* SETTINGS FOR BUTTON btCheck-2 IN FRAME fPage2
   NO-ENABLE                                                            */
ASSIGN 
       btCheck-2:HIDDEN IN FRAME fPage2           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.tt-usuar_mestre-1"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.tt-usuar_mestre-1.cod_usuario|yes"
     _FldNameList[1]   = Temp-Tables.tt-usuar_mestre-1.cod_usuario
     _FldNameList[2]   = Temp-Tables.tt-usuar_mestre-1.nom_usuario
     _FldNameList[3]   > Temp-Tables.tt-usuar_mestre-1.idi_dtsul
"tt-usuar_mestre-1.idi_dtsul" "ID Datasul" ? "integer" ? ? ? ? ? ? no ? no no "10.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brTable1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable2
/* Query rebuild information for BROWSE brTable2
     _TblList          = "Temp-Tables.tt-usuar_mestre-2"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.tt-usuar_mestre-2.nom_usuario|yes"
     _FldNameList[1]   > Temp-Tables.tt-usuar_mestre-2.nom_usuario
"tt-usuar_mestre-2.nom_usuario" ? ? "character" ? ? ? ? ? ? no ? no no ? yes yes no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-usuar_mestre-2.cod_usuario
"tt-usuar_mestre-2.cod_usuario" ? ? "character" ? ? ? ? ? ? no ? no no ? yes yes no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-usuar_mestre-2.idi_dtsul
"tt-usuar_mestre-2.idi_dtsul" "ID Datasul" ? "integer" ? ? ? ? ? ? no ? no no "9.86" yes yes no "U" "" "" "" "" "" "" 0 no 0 no no
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
     _Options          = "SHARE-LOCK KEEP-EMPTY"
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btCheck
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCheck wZoom
ON CHOOSE OF btCheck IN FRAME fPage1 /* btcheck */
DO:
    ASSIGN INPUT FRAME fpage1
        fi-usuar-ini fi-usuar-fim.
    
    RUN setConstraints IN THIS-PROCEDURE (INPUT 1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btCheck-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCheck-2 wZoom
ON CHOOSE OF btCheck-2 IN FRAME fPage2 /* btcheck */
DO:
    ASSIGN INPUT FRAME fpage2
        fi-nome-ini fi-nome-fim.
    
    RUN setConstraints IN THIS-PROCEDURE (INPUT 2).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wZoom
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
   /* {include/ajuda.i} */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btImplant1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant1 wZoom
ON CHOOSE OF btImplant1 IN FRAME fPage1 /* Implantar */
DO:
  /*  {zoom/implant.i &ProgramImplant="esp\aqp\esaqp006.w"
                    &PageNumber="1"} */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btImplant2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant2 wZoom
ON CHOOSE OF btImplant2 IN FRAME fPage2 /* Implantar */
DO:
  /*  {zoom/implant.i &ProgramImplant="esp\aqp\esaqp006.w"
                    &PageNumber="1"} */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wZoom 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DISP fi-usuar-ini
         fi-usuar-fim
         WITH FRAME fPage1.

    ENABLE fi-usuar-ini  
           fi-usuar-fim  
           btCheck 
           WITH FRAME fPage1.

    DISP fi-nome-ini
         fi-nome-fim
         WITH FRAME fPage2.

    ENABLE fi-nome-ini  
           fi-nome-fim  
           btCheck-2 
           WITH FRAME fPage2.

    APPLY "choose" TO btCheck IN FRAME fPage1.
    APPLY "entry" TO fi-usuar-ini IN FRAME fPage1.
   
    APPLY "choose" TO btCheck-2 IN FRAME fPage2.
    APPLY "entry" TO fi-nome-ini IN FRAME fPage2.

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
       {&hDBOTable1}:FILE-NAME <> "esbo/boes913.p":U THEN DO:
       
        {btb/btb008za.i1 esbo/boes913.p YES}
        {btb/btb008za.i2 esbo/boes913.p '' {&hDBOTable1}} 
    END.
    
    RUN setConstraintMain IN {&hDBOTable1} NO-ERROR. 
    RUN openQueryStatic IN {&hDBOTable1} ("Main") NO-ERROR. 

    /*:T--- Verifica se o DBO j  est  inicializado ---*/   
    IF NOT VALID-HANDLE({&hDBOTable2}) OR
       {&hDBOTable2}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable2}:FILE-NAME <> "esbo/boes913.p":U THEN DO:
       
       {btb/btb008za.i1 esbo/boes913.p YES}
       {btb/btb008za.i2 esbo/boes913.p '' {&hDBOTable2}} 
    END.
    
    RUN setConstraintMain IN {&hDBOTable2} NO-ERROR. 
    RUN openQueryStatic IN {&hDBOTable2} ("Main") NO-ERROR. 

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
    
    {zoom/openqueries.i &Query="Usu"
                        &PageNumber="1"}
                        
    {zoom/openqueries.i &Query="UsuNome"
                        &PageNumber="2"}                    

    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFieldsPage1 wZoom 
PROCEDURE returnFieldsPage1 PRIVATE :
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
            WHEN "cod-usuario":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod_usuario).
            WHEN "desc-usuario":U THEN
                ASSIGN pcfieldValue = STRING({&ttTable1}.nom_usuario).
        END CASE.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFieldsPage2 wZoom 
PROCEDURE returnFieldsPage2 PRIVATE :
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
            WHEN "cod-usuario":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.cod_usuario).
            WHEN "desc-usuario":U THEN
                ASSIGN pcfieldValue = STRING({&ttTable2}.nom_usuario).
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
            RUN setConstraintByUsu IN {&hDBOTable1}(INPUT fi-usuar-ini,
                                                    INPUT fi-usuar-fim).
        WHEN 2 THEN
            /*:T--- Seta Constraints para o DBO Table2 ---*/
            RUN setConstraintUsuNome IN {&hDBOTable2} (INPUT fi-nome-ini,
                                                       INPUT fi-nome-fim).
    
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

