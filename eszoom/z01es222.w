&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttacomp-projeto NO-UNDO LIKE acomp-projeto
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
{include/i-prgvrs.i z01es222 1.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           z01es222
&GLOBAL-DEFINE Version           1.00.00.000

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      Projeto

&GLOBAL-DEFINE Range             NO

&GLOBAL-DEFINE FieldsRangePage1  /*mgesp.usu-dep.cod-depos mgesp.usu-dep.usuario mgesp.usu-dep.programa*/
&GLOBAL-DEFINE FieldsAnyKeyPage1 NO

&GLOBAL-DEFINE ttTable1          TTacomp-projeto
&GLOBAL-DEFINE hDBOTable1        HDBOTTacomp-projeto
&GLOBAL-DEFINE DBOTable1         acomp-projeto

&GLOBAL-DEFINE page1Browse       brTable1

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable1} AS HANDLE NO-UNDO.

DEFINE VARIABLE de-horas-normais AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-horas-comp    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-horas-outras  AS DECIMAL     NO-UNDO.

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
&Scoped-define INTERNAL-TABLES ttacomp-projeto

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 ttacomp-projeto.cod-unid-negoc ~
ttacomp-projeto.cod-ccusto ttacomp-projeto.cod-usuario ~
ttacomp-projeto.periodo ttacomp-projeto.congelado ~
ttacomp-projeto.horas-normais ttacomp-projeto.horas-comp ~
ttacomp-projeto.horas-outras 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH ttacomp-projeto NO-LOCK
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH ttacomp-projeto NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTable1 ttacomp-projeto
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 ttacomp-projeto


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
     SIZE 108 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON btCheck 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON btImplant1 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-fim-cod-ccusto AS INTEGER FORMAT ">>>>>9" INITIAL 999999 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88.

DEFINE VARIABLE fi-fim-cod-unid-negoc AS CHARACTER FORMAT "X(3)" INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88.

DEFINE VARIABLE fi-fim-cod-usuario AS CHARACTER FORMAT "X(12)" INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88.

DEFINE VARIABLE fi-fim-periodo AS CHARACTER FORMAT "99/9999" INITIAL "129999" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88.

DEFINE VARIABLE fi-horas-compl AS CHARACTER FORMAT "X(14)":U INITIAL "0,00" 
      VIEW-AS TEXT 
     SIZE 11 BY .67 NO-UNDO.

DEFINE VARIABLE fi-horas-normais AS CHARACTER FORMAT "X(256)":U INITIAL "0,00" 
      VIEW-AS TEXT 
     SIZE 11 BY .67 NO-UNDO.

DEFINE VARIABLE fi-horas-outras AS CHARACTER FORMAT "X(14)":U INITIAL "0,00" 
      VIEW-AS TEXT 
     SIZE 11 BY .67 NO-UNDO.

DEFINE VARIABLE fi-ini-cod-ccusto AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "CC/Projeto":R17 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88.

DEFINE VARIABLE fi-ini-cod-unid-negoc AS CHARACTER FORMAT "X(3)" 
     LABEL "Unid Negoc":R17 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88.

DEFINE VARIABLE fi-ini-cod-usuario AS CHARACTER FORMAT "X(12)" 
     LABEL "C¢digo usu rio":R17 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88.

DEFINE VARIABLE fi-ini-periodo AS CHARACTER FORMAT "99/9999" INITIAL "010001" 
     LABEL "Per¡odo" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-37
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-38
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
      ttacomp-projeto SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      ttacomp-projeto.cod-unid-negoc FORMAT "x(3)":U WIDTH 4.86
      ttacomp-projeto.cod-ccusto FORMAT "x(11)":U WIDTH 12.43
      ttacomp-projeto.cod-usuario FORMAT "x(12)":U
      ttacomp-projeto.periodo FORMAT "99/9999":U WIDTH 7.43
      ttacomp-projeto.congelado COLUMN-LABEL "Congelado" FORMAT "Sim/Nao":U
            WIDTH 9.43
      ttacomp-projeto.horas-normais COLUMN-LABEL "Hs Normais" FORMAT ">>9.99":U
            WIDTH 13
      ttacomp-projeto.horas-comp COLUMN-LABEL "Hs Complementares" FORMAT ">>9.99":U
            WIDTH 17.43
      ttacomp-projeto.horas-outras COLUMN-LABEL "Hs Outras" FORMAT ">>9.99":U
            WIDTH 15.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 100 BY 7.75
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 18.21 COL 2
     btCancel AT ROW 18.21 COL 13
     btHelp AT ROW 18.21 COL 98
     rtToolBar AT ROW 18 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 108 BY 18.46
         FONT 1.

DEFINE FRAME fPage1
     fi-ini-cod-ccusto AT ROW 2.5 COL 35 COLON-ALIGNED
     fi-fim-cod-ccusto AT ROW 2.5 COL 59 COLON-ALIGNED NO-LABEL
     fi-ini-cod-usuario AT ROW 3.5 COL 29 COLON-ALIGNED
     fi-fim-cod-usuario AT ROW 3.5 COL 61 NO-LABEL
     fi-ini-periodo AT ROW 4.5 COL 30.71
     fi-fim-periodo AT ROW 4.5 COL 61 NO-LABEL
     btCheck AT ROW 4.29 COL 89.29
     brTable1 AT ROW 6 COL 2
     btImplant1 AT ROW 14 COL 2
     fi-horas-normais AT ROW 13.75 COL 64 RIGHT-ALIGNED NO-LABEL WIDGET-ID 2 NO-TAB-STOP 
     fi-horas-compl AT ROW 13.75 COL 70 COLON-ALIGNED NO-LABEL WIDGET-ID 4 NO-TAB-STOP 
     fi-horas-outras AT ROW 13.75 COL 86 COLON-ALIGNED NO-LABEL WIDGET-ID 6 NO-TAB-STOP 
     fi-ini-cod-unid-negoc AT ROW 1.5 COL 35 COLON-ALIGNED WIDGET-ID 10
     fi-fim-cod-unid-negoc AT ROW 1.5 COL 59 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     IMAGE-1 AT ROW 2.5 COL 46
     IMAGE-2 AT ROW 2.5 COL 58
     IMAGE-5 AT ROW 3.5 COL 46
     IMAGE-6 AT ROW 3.5 COL 58
     IMAGE-7 AT ROW 4.5 COL 46
     IMAGE-8 AT ROW 4.5 COL 58
     IMAGE-37 AT ROW 1.5 COL 46 WIDGET-ID 12
     IMAGE-38 AT ROW 1.5 COL 58 WIDGET-ID 14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.46
         SIZE 102.43 BY 14.54
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Zoom
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttacomp-projeto T "?" NO-UNDO mgesp acomp-projeto
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
         HEIGHT             = 18.46
         WIDTH              = 108
         MAX-HEIGHT         = 18.46
         MAX-WIDTH          = 119
         VIRTUAL-HEIGHT     = 18.46
         VIRTUAL-WIDTH      = 119
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
   Custom                                                               */
/* BROWSE-TAB brTable1 btCheck fPage1 */
/* SETTINGS FOR FILL-IN fi-fim-cod-usuario IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-fim-periodo IN FRAME fPage1
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN fi-horas-normais IN FRAME fPage1
   ALIGN-R                                                              */
ASSIGN 
       fi-horas-normais:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FILL-IN fi-ini-periodo IN FRAME fPage1
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.ttacomp-projeto"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.ttacomp-projeto.cod-unid-negoc
"ttacomp-projeto.cod-unid-negoc" ? ? "character" ? ? ? ? ? ? no ? no no "4.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.ttacomp-projeto.cod-ccusto
"ttacomp-projeto.cod-ccusto" ? ? "character" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.ttacomp-projeto.cod-usuario
     _FldNameList[4]   > Temp-Tables.ttacomp-projeto.periodo
"ttacomp-projeto.periodo" ? ? "character" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.ttacomp-projeto.congelado
"ttacomp-projeto.congelado" "Congelado" ? "logical" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ttacomp-projeto.horas-normais
"ttacomp-projeto.horas-normais" "Hs Normais" ? "decimal" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.ttacomp-projeto.horas-comp
"ttacomp-projeto.horas-comp" "Hs Complementares" ? "decimal" ? ? ? ? ? ? no ? no no "17.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.ttacomp-projeto.horas-outras
"ttacomp-projeto.horas-outras" "Hs Outras" ? "decimal" ? ? ? ? ? ? no ? no no "15.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
         fi-ini-cod-ccusto fi-fim-cod-ccusto fi-ini-cod-unid-negoc fi-fim-cod-unid-negoc fi-ini-cod-usuario fi-fim-cod-usuario fi-ini-periodo fi-fim-periodo.
  RUN setConstraints IN THIS-PROCEDURE (INPUT 1).

  ASSIGN de-horas-normais = 0 
         de-horas-comp    = 0
         de-horas-outras  = 0.

  IF VALID-HANDLE({&hDBOTable1}) THEN DO:
      RUN retornaTotaisHoras IN {&hDBOTable1} (OUTPUT de-horas-normais,
                                               OUTPUT de-horas-comp   ,
                                               OUTPUT de-horas-outras ).

      ASSIGN fi-horas-normais:SCREEN-VALUE IN FRAME fPage1 = STRING(de-horas-normais,">>>,>>>,>>9.99")
             fi-horas-compl:SCREEN-VALUE IN FRAME fPage1   = STRING(de-horas-comp,">>>,>>>,>>9.99")
             fi-horas-outras:SCREEN-VALUE IN FRAME fPage1  = STRING(de-horas-outras,">>>,>>>,>>9.99").
    
  END.
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


/*fi-ini-periodo:VISIBLE IN FRAME fpage1 = FALSE.
fi-fim-periodo:VISIBLE IN FRAME fpage1 = FALSE.
image-7:VISIBLE = FALSE.
image-8:VISIBLE = FALSE.*/

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

    DISP fi-ini-cod-ccusto fi-fim-cod-ccusto fi-ini-cod-unid-negoc fi-fim-cod-unid-negoc fi-ini-cod-usuario fi-fim-cod-usuario fi-ini-periodo fi-fim-periodo WITH FRAME fPage1.
    ENABLE fi-ini-cod-ccusto fi-fim-cod-ccusto fi-ini-cod-unid-negoc fi-fim-cod-unid-negoc fi-ini-cod-usuario fi-fim-cod-usuario fi-ini-periodo fi-fim-periodo btCheck WITH FRAME fPage1.
    APPLY "choose" TO btCheck IN FRAME fPage1.
    APPLY "entry" TO fi-ini-cod-unid-negoc IN FRAME fPage1.
 
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
       {&hDBOTable1}:FILE-NAME <> "esbo/boes222.p":U THEN DO:
       
        {btb/btb008za.i1 esbo/boes222.p YES}
        {btb/btb008za.i2 esbo/boes222.p '' {&hDBOTable1}} 
    END.

    /* A linha abaixo ‚ utilizada para trazer o browse carregado com uma faixa inicial
       pr‚-definida na primeira chamada do programa*/

    /*RUN setConstraintByCod IN {&hDBOTable1} (INPUT 0, INPUT 999999, INPUT 0, INPUT 999999, INPUT "", INPUT "zzzzzzz").*/
    
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
            WHEN "ccusto":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-ccusto).
            WHEN "cod-unid-negoc":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-unid-negoc).
            WHEN "cod-usuario":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-usuario).
            WHEN "periodo":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.periodo).
            WHEN "horas-comp":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.horas-comp).
            WHEN "horas-normais":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.horas-normais).
            WHEN "horas-outras":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.horas-outras).            
            WHEN "congelado":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.congelado).
            WHEN "atividade":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.atividade).
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
    
    DEFINE VARIABLE per-ini AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE per-fim AS CHARACTER   NO-UNDO.

    FOR EACH ttacomp-projeto:
        DELETE ttacomp-projeto.
    END.

    /*:T--- Seta constraints conforme n£mero da p gina ---*/
    
    ASSIGN per-ini = REPLACE(fi-ini-periodo,"/","")
           per-fim = REPLACE(fi-fim-periodo,"/","").

    CASE pPageNumber:
        WHEN 1 THEN
            /*:T--- Seta Constraints para o DBO Table1 ---*/
            RUN setConstraintByCod IN {&hDBOTable1} 
                (INPUT fi-ini-cod-unid-negoc,
                 INPUT fi-fim-cod-unid-negoc,
                 INPUT fi-ini-cod-ccusto,
                 INPUT fi-fim-cod-ccusto,    
                 INPUT fi-ini-cod-usuario,
                 INPUT fi-fim-cod-usuario,
                 INPUT per-ini,
                 INPUT per-fim).
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

