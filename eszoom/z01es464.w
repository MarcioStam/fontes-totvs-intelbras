&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-acordo-contrato NO-UNDO LIKE acordo-contrato
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
{include/i-prgvrs.i z01es464 2.04.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           z01es464
&GLOBAL-DEFINE Version           2.04.00.000

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      Acordo

&GLOBAL-DEFINE Range             NO
&GLOBAL-DEFINE ttTable1          tt-acordo-contrato
&GLOBAL-DEFINE hDBOTable1        hboes464
&GLOBAL-DEFINE DBOTable1         tt-acordo-contrato
&GLOBAL-DEFINE FieldsAnyKeyPage1 NO

&GLOBAL-DEFINE page1Browse       brTable1

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable1} AS HANDLE NO-UNDO.

DEFINE VARIABLE de-percentual AS DECIMAL     NO-UNDO.
/*define variable c-ini-descrcodigo as INT no-undo.
define variable c-fim-codigo as INT no-undo.*/

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
&Scoped-define INTERNAL-TABLES tt-acordo-contrato emitente

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 ~
tt-acordo-contrato.dt-vencto-contrato tt-acordo-contrato.data-vigencia ~
tt-acordo-contrato.cod-unid-negoc tt-acordo-contrato.fm-cod-com ~
tt-acordo-contrato.cod-estabel emitente.nome-emit ~
tt-acordo-contrato.raiz-cnpj tt-acordo-contrato.nr-acordo ~
fn-percentual() @ de-percentual 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH tt-acordo-contrato NO-LOCK, ~
      FIRST emitente WHERE emitente.cgc begins tt-acordo-contrato.raiz-cnpj NO-LOCK
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH tt-acordo-contrato NO-LOCK, ~
      FIRST emitente WHERE emitente.cgc begins tt-acordo-contrato.raiz-cnpj NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTable1 tt-acordo-contrato emitente
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 tt-acordo-contrato
&Scoped-define SECOND-TABLE-IN-QUERY-brTable1 emitente


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-percentual wZoom 
FUNCTION fn-percentual RETURNS DECIMAL
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
     SIZE 106 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON btCheck 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON btImplant1 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-acordo-fim AS INTEGER FORMAT ">>>>>>9" INITIAL 9999999 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE fi-acordo-ini AS INTEGER FORMAT ">>>>>>9" INITIAL 0 
     LABEL "Nr Acordo" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE fi-cliente-fim AS CHARACTER FORMAT "X(14)" INITIAL "ZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88.

DEFINE VARIABLE fi-cliente-ini AS CHARACTER FORMAT "X(14)" 
     LABEL "CNPJ" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-3
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-4
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      tt-acordo-contrato, 
      emitente
    FIELDS(emitente.nome-emit) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      tt-acordo-contrato.dt-vencto-contrato FORMAT "99/99/9999":U
            WIDTH 10.43
      tt-acordo-contrato.data-vigencia COLUMN-LABEL "Dt.Vigencia" FORMAT "99/99/9999":U
            WIDTH 11.43
      tt-acordo-contrato.cod-unid-negoc COLUMN-LABEL "UnidNeg" FORMAT "x(03)":U
            WIDTH 7.43
      tt-acordo-contrato.fm-cod-com FORMAT "x(8)":U WIDTH 7.43
      tt-acordo-contrato.cod-estabel COLUMN-LABEL "Est" FORMAT "x(3)":U
            WIDTH 4.14
      emitente.nome-emit FORMAT "X(40)":U WIDTH 25.72
      tt-acordo-contrato.raiz-cnpj COLUMN-LABEL "Cliente CNPJ" FORMAT "x(14)":U
            WIDTH 13.72
      tt-acordo-contrato.nr-acordo COLUMN-LABEL "Acordo" FORMAT ">>>>>>9":U
            WIDTH 6.14
      fn-percentual() @ de-percentual COLUMN-LABEL "Percent" FORMAT ">>9.99":U
            WIDTH 6.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 101 BY 10
         FONT 2 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.71 COL 2
     btCancel AT ROW 16.71 COL 13
     btHelp AT ROW 16.71 COL 96.43
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 106 BY 17
         FONT 1.

DEFINE FRAME fPage1
     fi-acordo-ini AT ROW 1.25 COL 33.72 COLON-ALIGNED
     fi-acordo-fim AT ROW 1.25 COL 54.43 COLON-ALIGNED NO-LABEL
     fi-cliente-ini AT ROW 2.25 COL 27.72 COLON-ALIGNED WIDGET-ID 4
     fi-cliente-fim AT ROW 2.25 COL 54.43 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     btCheck AT ROW 2.21 COL 90.14 RIGHT-ALIGNED
     brTable1 AT ROW 3.25 COL 2
     btImplant1 AT ROW 13.33 COL 2
     IMAGE-1 AT ROW 1.25 COL 44.29
     IMAGE-2 AT ROW 1.25 COL 53
     IMAGE-3 AT ROW 2.25 COL 44.29 WIDGET-ID 6
     IMAGE-4 AT ROW 2.25 COL 53 WIDGET-ID 8
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.43 ROW 2.21
         SIZE 103.57 BY 13.58
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Zoom Template
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-acordo-contrato T "?" NO-UNDO mgesp acordo-contrato
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
         WIDTH              = 106
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 106
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 106
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
/* SETTINGS FOR BUTTON btCheck IN FRAME fPage1
   ALIGN-R                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.tt-acordo-contrato,mgcad.emitente WHERE Temp-Tables.tt-acordo-contrato ..."
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST USED"
     _JoinCode[2]      = "mgcad.emitente.cgc begins Temp-Tables.tt-acordo-contrato.raiz-cnpj"
     _FldNameList[1]   > Temp-Tables.tt-acordo-contrato.dt-vencto-contrato
"Temp-Tables.tt-acordo-contrato.dt-vencto-contrato" ? ? "date" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" ""
     _FldNameList[2]   > Temp-Tables.tt-acordo-contrato.data-vigencia
"Temp-Tables.tt-acordo-contrato.data-vigencia" "Dt.Vigencia" ? "date" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" ""
     _FldNameList[3]   > Temp-Tables.tt-acordo-contrato.cod-unid-negoc
"Temp-Tables.tt-acordo-contrato.cod-unid-negoc" "UnidNeg" ? "character" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" ""
     _FldNameList[4]   > Temp-Tables.tt-acordo-contrato.fm-cod-com
"Temp-Tables.tt-acordo-contrato.fm-cod-com" ? ? "character" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" ""
     _FldNameList[5]   > Temp-Tables.tt-acordo-contrato.cod-estabel
"Temp-Tables.tt-acordo-contrato.cod-estabel" "Est" ? "character" ? ? ? ? ? ? no ? no no "4.14" yes no no "U" "" ""
     _FldNameList[6]   > mgcad.emitente.nome-emit
"mgcad.emitente.nome-emit" ? ? "character" ? ? ? ? ? ? no ? no no "25.72" yes no no "U" "" ""
     _FldNameList[7]   > Temp-Tables.tt-acordo-contrato.raiz-cnpj
"Temp-Tables.tt-acordo-contrato.raiz-cnpj" "Cliente CNPJ" "x(14)" "character" ? ? ? ? ? ? no "Cliente CNPJ" no no "13.72" yes no no "U" "" ""
     _FldNameList[8]   > Temp-Tables.tt-acordo-contrato.nr-acordo
"Temp-Tables.tt-acordo-contrato.nr-acordo" "Acordo" ? "integer" ? ? ? ? ? ? no ? no no "6.14" yes no no "U" "" ""
     _FldNameList[9]   > "_<CALC>"
"fn-percentual() @ de-percentual" "Percent" ">>9.99" ? ? ? ? ? ? ? no ? no no "6.86" yes no no "U" "" ""
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
         fi-acordo-ini fi-acordo-fim fi-cliente-ini fi-cliente-fim.
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

    DISP fi-acordo-ini fi-acordo-fim fi-cliente-ini fi-cliente-fim WITH FRAME fPage1.
    ENABLE fi-acordo-ini fi-acordo-fim fi-cliente-ini fi-cliente-fim btCheck WITH FRAME fPage1.
    APPLY "choose" TO btCheck IN FRAME fPage1.

    APPLY "entry" TO fi-acordo-ini IN FRAME fPage1.
 
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
       {&hDBOTable1}:FILE-NAME <> "esbo/boes464.p":U THEN DO:
       
        {btb/btb008za.i1 esbo/boes464.p YES}
        {btb/btb008za.i2 esbo/boes464.p '' {&hDBOTable1}} 
    END.
    
    RUN setConstraintZoom1 IN {&hDBOTable1} (INPUT 0,
                                             INPUT 9999999,
                                             INPUT "",
                                             INPUT "ZZZZZZZZ").

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
    
    {zoom/OpenQueries.i &Query="Zoom1"
                        &PageNumber="1"}
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-entry wZoom 
PROCEDURE pi-entry :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* rotina obsoleta */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-atributos-chave wZoom 
PROCEDURE pi-seta-atributos-chave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-lista-atributos-chave as character no-undo.
  DEF VAR i AS INTEGER NO-UNDO.
  DEF VAR c-pair AS CHAR NO-UNDO.
  
  ASSIGN cFieldHandles = ""
         cFieldNames   = "".
  DO i = 1 TO NUM-ENTRIES(p-lista-atributos-chave, chr(10)):
     ASSIGN c-pair        = ENTRY(i, p-lista-atributos-chave, chr(10))
            cFieldHandles = cFieldHandles + ENTRY(1, c-pair, "|") + ","
            cFieldNames   = cFieldNames + ENTRY(2, c-pair, "|") + "," .
  END.
  SUBSTRING(cFieldHandles, LENGTH(cFieldHandles), 1) = "".
  SUBSTRING(cFieldNames, LENGTH(cFieldNames), 1) = "".

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
            WHEN "nr-acordo":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nr-acordo).
            WHEN "raiz-cnpj":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.raiz-cnpj).
            WHEN "cod-estabel":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-estabel).
            WHEN "cod-familia":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.fm-cod-com).
            WHEN "cod-unid-negoc":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-unid-negoc).
            WHEN "data-vigencia":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.data-vigencia).
            WHEN "dt-vencto-contrato":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.dt-vencto-contrato).

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
        WHEN 1 THEN DO:
            RUN setConstraintZoom1 IN {&hDBOTable1} (INPUT fi-acordo-ini,
                                                     INPUT fi-acordo-fim,
                                                     INPUT fi-cliente-ini, 
                                                     INPUT fi-cliente-fim).
        END.
            /*:T--- Seta Constraints para o DBO Table1 ---*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-percentual wZoom 
FUNCTION fn-percentual RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE de-percent AS DECIMAL     NO-UNDO.

    FOR EACH acordo-tipo NO-LOCK
       WHERE acordo-tipo.nr-acordo = tt-acordo-contrato.nr-acordo:
        ASSIGN de-percent = de-percent  + acordo-tipo.percentual.
    END.
  RETURN de-percent.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

