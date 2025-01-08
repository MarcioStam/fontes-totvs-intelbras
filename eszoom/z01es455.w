&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-vpc NO-UNDO LIKE vpc
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
{include/i-prgvrs.i z01es455 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           z01es455
&GLOBAL-DEFINE Version           2.04.00.001

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      Verbas

&GLOBAL-DEFINE Range             NO
&GLOBAL-DEFINE ttTable1          tt-vpc
&GLOBAL-DEFINE hDBOTable1        h-boes455
&GLOBAL-DEFINE DBOTable1         tt-vpc
&GLOBAL-DEFINE FieldsAnyKeyPage1 NO

&GLOBAL-DEFINE page1Browse       brTable1

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable1} AS HANDLE NO-UNDO.

DEFINE VARIABLE c-situacao AS CHARACTER   NO-UNDO.

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
&Scoped-define INTERNAL-TABLES tt-vpc emitente tipo-verba

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 tt-vpc.nr-vpc tt-vpc.cod-emitente ~
emitente.nome-emit tt-vpc.valor tt-vpc.cod-estabel tt-vpc.data-evento ~
tt-vpc.data-vencto tipo-verba.descricao tt-vpc.usuario-trans ~
tt-vpc.data-trans tt-vpc.usuario-liberacao tt-vpc.data-liberacao ~
fn-situacao(tt-vpc.situacao) @ c-situacao 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH tt-vpc NO-LOCK, ~
      FIRST emitente WHERE emitente.cod-emitente = tt-vpc.cod-emitente NO-LOCK, ~
      FIRST tipo-verba WHERE tipo-verba.codigo = tt-vpc.tipo-verba NO-LOCK
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH tt-vpc NO-LOCK, ~
      FIRST emitente WHERE emitente.cod-emitente = tt-vpc.cod-emitente NO-LOCK, ~
      FIRST tipo-verba WHERE tipo-verba.codigo = tt-vpc.tipo-verba NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTable1 tt-vpc emitente tipo-verba
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 tt-vpc
&Scoped-define SECOND-TABLE-IN-QUERY-brTable1 emitente
&Scoped-define THIRD-TABLE-IN-QUERY-brTable1 tipo-verba


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-situacao wZoom 
FUNCTION fn-situacao RETURNS CHARACTER (INPUT p-situacao AS INTEGER) FORWARD.

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

DEFINE VARIABLE cb-tipo-verba AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Tipo Verba" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "0",0
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE fi-data-trans-fim AS DATE FORMAT "99/99/9999" INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 9.72 BY .88.

DEFINE VARIABLE fi-data-trans-ini AS DATE FORMAT "99/99/9999" INITIAL 01/01/08 
     LABEL "Data Transa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 9.72 BY .88.

DEFINE VARIABLE fi-vencto-fim AS DATE FORMAT "99/99/9999" INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 9.72 BY .88.

DEFINE VARIABLE fi-vencto-ini AS DATE FORMAT "99/99/9999" INITIAL 01/01/08 
     LABEL "Data Vencimento" 
     VIEW-AS FILL-IN 
     SIZE 9.72 BY .88.

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

DEFINE VARIABLE rs-situacao AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Bloqueado", 0,
"Liberado", 1,
"Finalizado", 2,
"Cancelado", 3,
"Todos", 4
     SIZE 55.72 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 72 BY 1.42.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      tt-vpc, 
      emitente
    FIELDS(emitente.nome-emit), 
      tipo-verba SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      tt-vpc.nr-vpc FORMAT ">>>>>>>9":U
      tt-vpc.cod-emitente FORMAT ">>>>>9":U WIDTH 8
      emitente.nome-emit FORMAT "x(80)":U WIDTH 39.43
      tt-vpc.valor FORMAT "->>>,>>9.99":U WIDTH 11.43
      tt-vpc.cod-estabel FORMAT "X(3)":U WIDTH 4.43
      tt-vpc.data-evento FORMAT "99/99/9999":U WIDTH 10.43
      tt-vpc.data-vencto FORMAT "99/99/9999":U WIDTH 10.43
      tipo-verba.descricao COLUMN-LABEL "Tipo Verba" FORMAT "x(30)":U
      tt-vpc.usuario-trans FORMAT "x(12)":U
      tt-vpc.data-trans FORMAT "99/99/9999":U
      tt-vpc.usuario-liberacao FORMAT "x(12)":U
      tt-vpc.data-liberacao FORMAT "99/99/9999":U WIDTH 13.43
      fn-situacao(tt-vpc.situacao) @ c-situacao COLUMN-LABEL "Situa‡Æo" FORMAT "x(12)":U
            WIDTH 10
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 8.83
         FONT 2 ROW-HEIGHT-CHARS .55 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 17.04 COL 2
     btCancel AT ROW 17.04 COL 13
     btHelp AT ROW 17.04 COL 80
     rtToolBar AT ROW 16.83 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.33
         FONT 1.

DEFINE FRAME fPage1
     fi-data-trans-ini AT ROW 1.25 COL 17 COLON-ALIGNED WIDGET-ID 16
     fi-data-trans-fim AT ROW 1.25 COL 37.14 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     fi-vencto-ini AT ROW 2.25 COL 17.14 COLON-ALIGNED WIDGET-ID 26
     fi-vencto-fim AT ROW 2.25 COL 37.29 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     cb-tipo-verba AT ROW 2.25 COL 57 COLON-ALIGNED WIDGET-ID 34
     rs-situacao AT ROW 3.42 COL 15.29 NO-LABEL WIDGET-ID 2
     btCheck AT ROW 3.67 COL 83 RIGHT-ALIGNED
     brTable1 AT ROW 4.92 COL 2
     btImplant1 AT ROW 13.88 COL 2
     "Situa‡Æo:" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 3.63 COL 7.72 WIDGET-ID 8
     RECT-1 AT ROW 3.25 COL 5 WIDGET-ID 10
     IMAGE-1 AT ROW 1.25 COL 29.29 WIDGET-ID 18
     IMAGE-2 AT ROW 1.25 COL 35.86 WIDGET-ID 20
     IMAGE-3 AT ROW 2.25 COL 29.43 WIDGET-ID 28
     IMAGE-4 AT ROW 2.25 COL 36 WIDGET-ID 30
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.29
         SIZE 84.43 BY 14.04
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Zoom Template
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-vpc T "?" NO-UNDO mgesp vpc
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
         HEIGHT             = 17.33
         WIDTH              = 90
         MAX-HEIGHT         = 17.33
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17.33
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
     _TblList          = "Temp-Tables.tt-vpc,mgcad.emitente WHERE Temp-Tables.tt-vpc ...,mgesp.tipo-verba WHERE Temp-Tables.tt-vpc ..."
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST USED, FIRST"
     _JoinCode[2]      = "mgcad.emitente.cod-emitente = Temp-Tables.tt-vpc.cod-emitente"
     _JoinCode[3]      = "mgesp.tipo-verba.codigo = Temp-Tables.tt-vpc.tipo-verba"
     _FldNameList[1]   = Temp-Tables.tt-vpc.nr-vpc
     _FldNameList[2]   > Temp-Tables.tt-vpc.cod-emitente
"tt-vpc.cod-emitente" ? ? "integer" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > mgcad.emitente.nome-emit
"emitente.nome-emit" ? ? "character" ? ? ? ? ? ? no ? no no "39.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-vpc.valor
"tt-vpc.valor" ? ? "decimal" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-vpc.cod-estabel
"tt-vpc.cod-estabel" ? ? "character" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-vpc.data-evento
"tt-vpc.data-evento" ? ? "date" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-vpc.data-vencto
"tt-vpc.data-vencto" ? ? "date" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > mgesp.tipo-verba.descricao
"tipo-verba.descricao" "Tipo Verba" "x(30)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   = Temp-Tables.tt-vpc.usuario-trans
     _FldNameList[10]   = Temp-Tables.tt-vpc.data-trans
     _FldNameList[11]   = Temp-Tables.tt-vpc.usuario-liberacao
     _FldNameList[12]   > Temp-Tables.tt-vpc.data-liberacao
"tt-vpc.data-liberacao" ? ? "date" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"fn-situacao(tt-vpc.situacao) @ c-situacao" "Situa‡Æo" "x(12)" ? ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define BROWSE-NAME brTable1
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brTable1 wZoom
ON ROW-DISPLAY OF brTable1 IN FRAME fPage1
DO:
    IF AVAIL tt-vpc THEN DO:
         CASE tt-vpc.situacao:
             WHEN 0 THEN RUN pi-muda-cor(INPUT ? , INPUT ?).
             WHEN 1 THEN RUN pi-muda-cor(INPUT 3 , INPUT 15).
             WHEN 2 THEN RUN pi-muda-cor(INPUT 9 , INPUT 15).
             WHEN 3 THEN RUN pi-muda-cor(INPUT 12, INPUT ?).
             OTHERWISE RUN pi-muda-cor(INPUT ?, INPUT ?).
         END CASE.
     END.
     ELSE DO:
        RUN pi-muda-cor(INPUT ?, INPUT ?).
     END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
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
  ASSIGN INPUT FRAME fpage1 fi-data-trans-ini
         INPUT FRAME fpage1 fi-data-trans-fim
         INPUT FRAME fpage1 fi-vencto-ini
         INPUT FRAME fpage1 fi-vencto-fim
         INPUT FRAME fpage1 rs-situacao
         INPUT FRAME fPage1 cb-tipo-verba.

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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME cb-tipo-verba
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tipo-verba wZoom
ON VALUE-CHANGED OF cb-tipo-verba IN FRAME fPage1 /* Tipo Verba */
DO:
    APPLY "choose" TO btCheck IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-situacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-situacao wZoom
ON VALUE-CHANGED OF rs-situacao IN FRAME fPage1
DO:
    APPLY "choose" TO btCheck IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
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

    RUN pi-carrega-verbas.

    ASSIGN fi-data-trans-ini:SENSITIVE IN FRAME fPage1 = YES
           fi-data-trans-fim:SENSITIVE IN FRAME fPage1 = YES
           fi-data-trans-ini:SCREEN-VALUE IN FRAME fPage1 = STRING(DATE(MONTH(TODAY),01,YEAR(TODAY)),"99/99/9999")
           fi-data-trans-fim:SCREEN-VALUE IN FRAME fPage1 = STRING(DATE(TODAY),"99/99/9999")
           fi-vencto-ini:SENSITIVE IN FRAME fPage1 = YES
           fi-vencto-fim:SENSITIVE IN FRAME fPage1 = YES
           fi-vencto-ini:SCREEN-VALUE IN FRAME fPage1 = "01/01/2008"
           fi-vencto-fim:SCREEN-VALUE IN FRAME fPage1 = "31/12/9999"
           cb-tipo-verba:SENSITIVE IN FRAME fPage1     = YES
           rs-situacao:SENSITIVE IN FRAME fPage1       = YES
           rs-situacao:SCREEN-VALUE IN FRAME fPage1    = "0"
           btCheck:SENSITIVE IN FRAME fPage1           = YES. 

    APPLY "choose" TO btCheck IN FRAME fPage1.

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
       {&hDBOTable1}:FILE-NAME <> "esbo/boes455.p":U THEN DO:
       
        {btb/btb008za.i1 esbo/boes455.p YES}
        {btb/btb008za.i2 esbo/boes455.p '' {&hDBOTable1}} 
    END.
    
    RUN setConstraintVpcSit IN {&hDBOTable1} (INPUT 01/01/2008,
                                              INPUT 12/31/9999,
                                              INPUT 01/01/2008,
                                              INPUT 12/31/9999,
                                              INPUT 0,
                                              INPUT ?).
    
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
    
    {zoom/OpenQueries.i &Query="VpcSit"
                        &PageNumber="1"}
    
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-verbas wZoom 
PROCEDURE pi-carrega-verbas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-desc AS CHARACTER   NO-UNDO.
    
    ASSIGN cb-tipo-verba:LIST-ITEM-PAIRS IN FRAME fPage1 = ",".

    FOR EACH tipo-verba BY tipo-verba.codigo:
        ASSIGN c-desc = STRING(tipo-verba.codigo) + "-" + tipo-verba.descricao.

        cb-tipo-verba:add-last(c-desc, tipo-verba.codigo) IN FRAME fPage1 NO-ERROR.
    END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-muda-cor wZoom 
PROCEDURE pi-muda-cor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-bgcolor AS INTEGER     NO-UNDO.
    DEFINE INPUT PARAMETER p-fgcolor AS INTEGER     NO-UNDO.

    /*cor de fundo*/
    ASSIGN tt-vpc.nr-vpc:BGCOLOR             IN BROWSE brTable1 = p-bgcolor
           tt-vpc.cod-emitente:BGCOLOR       IN BROWSE brTable1 = p-bgcolor
           emitente.nome-emit:BGCOLOR        IN BROWSE brTable1 = p-bgcolor
           tt-vpc.valor:BGCOLOR              IN BROWSE brTable1 = p-bgcolor
           tt-vpc.cod-estabel:BGCOLOR        IN BROWSE brTable1 = p-bgcolor
           tt-vpc.data-evento:BGCOLOR        IN BROWSE brTable1 = p-bgcolor
           tt-vpc.data-vencto:BGCOLOR        IN BROWSE brTable1 = p-bgcolor
           tt-vpc.usuario-trans:BGCOLOR      IN BROWSE brTable1 = p-bgcolor
           tt-vpc.data-trans:BGCOLOR         IN BROWSE brTable1 = p-bgcolor
           tt-vpc.usuario-liberacao:BGCOLOR  IN BROWSE brTable1 = p-bgcolor
           tt-vpc.data-liberacao:BGCOLOR     IN BROWSE brTable1 = p-bgcolor
           c-situacao:BGCOLOR                IN BROWSE brTable1 = p-bgcolor
           tipo-verba.descricao:BGCOLOR      IN BROWSE brTable1 = p-bgcolor.

    /*cor da letra*/
    ASSIGN tt-vpc.nr-vpc:FGCOLOR              IN BROWSE brTable1 = p-fgcolor
           tt-vpc.cod-emitente:FGCOLOR        IN BROWSE brTable1 = p-fgcolor
           emitente.nome-emit:FGCOLOR         IN BROWSE brTable1 = p-fgcolor
           tt-vpc.valor:FGCOLOR               IN BROWSE brTable1 = p-fgcolor
           tt-vpc.cod-estabel:FGCOLOR         IN BROWSE brTable1 = p-fgcolor
           tt-vpc.data-evento:FGCOLOR         IN BROWSE brTable1 = p-fgcolor
           tt-vpc.data-vencto:FGCOLOR         IN BROWSE brTable1 = p-fgcolor
           tt-vpc.usuario-trans:FGCOLOR       IN BROWSE brTable1 = p-fgcolor
           tt-vpc.data-trans:FGCOLOR          IN BROWSE brTable1 = p-fgcolor
           tt-vpc.usuario-liberacao:FGCOLOR   IN BROWSE brTable1 = p-fgcolor
           tt-vpc.data-liberacao:FGCOLOR      IN BROWSE brTable1 = p-fgcolor
           tipo-verba.descricao:FGCOLOR       IN BROWSE brTable1 = p-fgcolor
           c-situacao:FGCOLOR                 IN BROWSE brTable1 = p-fgcolor.

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
            WHEN "nr-vpc":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nr-vpc).
            WHEN "cod-emitente":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-emitente).
            WHEN "situacao":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.situacao).
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
            RUN setConstraintVpcSit IN {&hDBOTable1} (INPUT fi-data-trans-ini,
                                                      INPUT fi-data-trans-fim,
                                                      INPUT fi-vencto-ini,
                                                      INPUT fi-vencto-fim,
                                                      INPUT rs-situacao,
                                                      INPUT cb-tipo-verba).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-situacao wZoom 
FUNCTION fn-situacao RETURNS CHARACTER (INPUT p-situacao AS INTEGER):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-retorno AS CHARACTER   NO-UNDO.

    ASSIGN c-retorno = "".
    CASE p-situacao:
        WHEN 0 THEN ASSIGN c-retorno = "Bloqueado".
        WHEN 1 THEN ASSIGN c-retorno = "Liberado".
        WHEN 2 THEN ASSIGN c-retorno = "Finalizado".
        WHEN 3 THEN ASSIGN c-retorno = "Cancelado".
    END CASE.

  RETURN c-retorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

