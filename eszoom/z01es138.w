&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttpagamento NO-UNDO LIKE pagamento
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttpagamento-invoice NO-UNDO LIKE pagamento-invoice
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
{include/i-prgvrs.i z01es138 1.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           z01es138
&GLOBAL-DEFINE Version           1.00.00.000

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      Pagamento,Embarque

&GLOBAL-DEFINE Range             NO

&GLOBAL-DEFINE FieldsRangePage1  /*mgesp.local.cod-tipo mgesp.local.localizacao mgesp.local.cod-depos*/

&GLOBAL-DEFINE FieldsAnyKeyPage1 NO

&GLOBAL-DEFINE ttTable1          TTPagamento
&GLOBAL-DEFINE hDBOTable1        HDBOTTPagamento
&GLOBAL-DEFINE DBOTable1         Pagamento

&GLOBAL-DEFINE ttTable2          TTPagamento-invoice
&GLOBAL-DEFINE hDBOTable2        Pagamento-invoice
&GLOBAL-DEFINE DBOTable2         Pagamento-invoice

&GLOBAL-DEFINE page1Browse       brTable1
&GLOBAL-DEFINE page2Browse       brTable2

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable1} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTable2} AS HANDLE NO-UNDO.

DEFINE VARIABLE valor  AS CHAR NO-UNDO.
DEFINE VARIABLE cEmitente LIKE emitente.nome-abrev            NO-UNDO.
DEFINE VARIABLE cSwift AS CHAR NO-UNDO.

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
&Scoped-define INTERNAL-TABLES ttpagamento ttpagamento-invoice

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 ttpagamento.nr-pagamento ~
ttpagamento.nr-cont-cambio 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH ttpagamento NO-LOCK
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH ttpagamento NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTable1 ttpagamento
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 ttpagamento


/* Definitions for BROWSE brTable2                                      */
&Scoped-define FIELDS-IN-QUERY-brTable2 ttpagamento-invoice.embarque ~
ttpagamento-invoice.nr-pagamento ~
fnValorPgto (ttpagamento-invoice.nr-pagamento)  @ valor ~
fnEmitente (ttpagamento-invoice.nr-pagamento)  @ cEmitente ~
fnSwift (ttpagamento-invoice.nr-pagamento) @ cSwift 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable2 
&Scoped-define QUERY-STRING-brTable2 FOR EACH ttpagamento-invoice NO-LOCK
&Scoped-define OPEN-QUERY-brTable2 OPEN QUERY brTable2 FOR EACH ttpagamento-invoice NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTable2 ttpagamento-invoice
&Scoped-define FIRST-TABLE-IN-QUERY-brTable2 ttpagamento-invoice


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


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnEmitente wZoom 
FUNCTION fnEmitente RETURNS CHARACTER
  ( pNrPgto AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnSwift wZoom 
FUNCTION fnSwift RETURNS CHARACTER
  ( pNrPgto AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnValorPgto wZoom 
FUNCTION fnValorPgto RETURNS CHAR
  ( pNrPgto AS INTEGER )  FORWARD.

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

DEFINE VARIABLE fi-fim-contrato AS CHARACTER FORMAT "X(15)":U INITIAL "ZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .79 NO-UNDO.

DEFINE VARIABLE fi-fim-nr-pagamento AS INTEGER FORMAT ">>>,>>9":U INITIAL 999999 
     VIEW-AS FILL-IN 
     SIZE 7 BY .79 NO-UNDO.

DEFINE VARIABLE fi-ini-contrato AS CHARACTER FORMAT "X(15)":U 
     LABEL "Contrato cƒmbio" 
     VIEW-AS FILL-IN 
     SIZE 16.86 BY .79 NO-UNDO.

DEFINE VARIABLE fi-ini-nr-pagamento AS INTEGER FORMAT ">>>,>>9":U INITIAL 0 
     LABEL "Nr. Pagamento" 
     VIEW-AS FILL-IN 
     SIZE 6.86 BY .79 NO-UNDO.

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

DEFINE BUTTON btCheck2 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON btImplant2 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-fim-embarque AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .79 NO-UNDO.

DEFINE VARIABLE fi-ini-embarque AS CHARACTER FORMAT "X(12)":U 
     LABEL "Embarque" 
     VIEW-AS FILL-IN 
     SIZE 16.86 BY .79 NO-UNDO.

DEFINE IMAGE IMAGE-10
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-9
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      ttpagamento SCROLLING.

DEFINE QUERY brTable2 FOR 
      ttpagamento-invoice SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      ttpagamento.nr-pagamento COLUMN-LABEL "Nr. Pagamento" FORMAT ">>>,>>9":U
      ttpagamento.nr-cont-cambio FORMAT "x(15)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 8.5
         FONT 2.

DEFINE BROWSE brTable2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable2 wZoom _STRUCTURED
  QUERY brTable2 NO-LOCK DISPLAY
      ttpagamento-invoice.embarque FORMAT "x(12)":U
      ttpagamento-invoice.nr-pagamento FORMAT ">>>,>>9":U
      fnValorPgto (ttpagamento-invoice.nr-pagamento)  @ valor COLUMN-LABEL "Valor Pagamento" FORMAT "X(30)":U
      fnEmitente (ttpagamento-invoice.nr-pagamento)  @ cEmitente COLUMN-LABEL "Emitente" FORMAT "X(30)":U
            WIDTH 23.86
      fnSwift (ttpagamento-invoice.nr-pagamento) @ cSwift COLUMN-LABEL "Swift" FORMAT "x(50)":U
            WIDTH 17.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 8.5
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
         SIZE 90 BY 16.98
         FONT 1.

DEFINE FRAME fPage1
     fi-ini-nr-pagamento AT ROW 1.5 COL 27 COLON-ALIGNED
     fi-fim-nr-pagamento AT ROW 1.5 COL 49 COLON-ALIGNED NO-LABEL
     btCheck AT ROW 1.5 COL 77
     fi-ini-contrato AT ROW 2.5 COL 17 COLON-ALIGNED
     fi-fim-contrato AT ROW 2.5 COL 49 COLON-ALIGNED NO-LABEL
     brTable1 AT ROW 4.5 COL 2
     btImplant1 AT ROW 13 COL 2
     IMAGE-5 AT ROW 1.5 COL 36
     IMAGE-6 AT ROW 1.5 COL 48
     IMAGE-7 AT ROW 2.5 COL 36
     IMAGE-8 AT ROW 2.5 COL 48
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1.

DEFINE FRAME fPage2
     fi-ini-embarque AT ROW 1.5 COL 17 COLON-ALIGNED
     fi-fim-embarque AT ROW 1.5 COL 43 COLON-ALIGNED NO-LABEL
     btCheck2 AT ROW 1.5 COL 77
     brTable2 AT ROW 4.5 COL 2
     btImplant2 AT ROW 13 COL 2
     IMAGE-9 AT ROW 1.5 COL 37
     IMAGE-10 AT ROW 1.5 COL 41
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
   Temp-Tables and Buffers:
      TABLE: ttpagamento T "?" NO-UNDO mgesp pagamento
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttpagamento-invoice T "?" NO-UNDO mgesp pagamento-invoice
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
  NOT-VISIBLE,                                                          */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brTable1 fi-fim-contrato fPage1 */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brTable2 btCheck2 fPage2 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.ttpagamento"
     _Options          = "NO-LOCK "
     _FldNameList[1]   > Temp-Tables.ttpagamento.nr-pagamento
"ttpagamento.nr-pagamento" "Nr. Pagamento" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = Temp-Tables.ttpagamento.nr-cont-cambio
     _Query            is OPENED
*/  /* BROWSE brTable1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable2
/* Query rebuild information for BROWSE brTable2
     _TblList          = "Temp-Tables.ttpagamento-invoice"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.ttpagamento-invoice.embarque
     _FldNameList[2]   = Temp-Tables.ttpagamento-invoice.nr-pagamento
     _FldNameList[3]   > "_<CALC>"
"fnValorPgto (ttpagamento-invoice.nr-pagamento)  @ valor" "Valor Pagamento" "X(30)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"fnEmitente (ttpagamento-invoice.nr-pagamento)  @ cEmitente" "Emitente" "X(30)" ? ? ? ? ? ? ? no ? no no "23.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fnSwift (ttpagamento-invoice.nr-pagamento) @ cSwift" "Swift" "x(50)" ? ? ? ? ? ? ? no ? no no "17.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON CHOOSE OF btCheck IN FRAME fPage1
DO:

  ASSIGN INPUT FRAME fpage1
         fi-ini-nr-pagamento
         fi-fim-nr-pagamento
         fi-ini-contrato
         fi-fim-contrato.

  RUN setConstraints IN THIS-PROCEDURE (INPUT 1).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btCheck2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCheck2 wZoom
ON CHOOSE OF btCheck2 IN FRAME fPage2
DO:

  ASSIGN INPUT FRAME fpage2
         fi-ini-embarque
         fi-fim-embarque.

  RUN setConstraints IN THIS-PROCEDURE (INPUT 2).
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
  /*  {zoom/implant.i &ProgramImplant="<ProgramName>"
                    &PageNumber="1"}
  */                    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btImplant2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant2 wZoom
ON CHOOSE OF btImplant2 IN FRAME fPage2 /* Implantar */
DO:
  /*  {zoom/implant.i &ProgramImplant="<ProgramName>"
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
    RUN returnValues1 IN THIS-PROCEDURE.
    
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

    DISP fi-ini-nr-pagamento
         fi-fim-nr-pagamento
         fi-ini-contrato
         fi-fim-contrato 
         WITH FRAME fPage1.

    DISP fi-ini-embarque
         fi-fim-embarque
         WITH FRAME fPage2.

    ENABLE  fi-ini-nr-pagamento
            fi-fim-nr-pagamento
            fi-ini-contrato
            fi-fim-contrato 
            btCheck
            WITH FRAME fPage1.

    ENABLE  fi-ini-embarque
            fi-fim-embarque
            btCheck2
            WITH FRAME fPage2.

    APPLY "choose" TO btCheck IN FRAME fPage1.
    APPLY "choose" TO btCheck2 IN FRAME fPage2.

    APPLY "entry" TO fi-ini-nr-pagamento IN FRAME fPage1.
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
       {&hDBOTable1}:FILE-NAME <> "esbo/boes138.p":U THEN DO:
       
        {btb/btb008za.i1 esbo/boes138.p YES}
        {btb/btb008za.i2 esbo/boes138.p '' {&hDBOTable1}} 
    END.

    RUN setConstraintByCod IN {&hDBOTable1} (INPUT 0, INPUT 999999, INPUT "", INPUT "zzzzzzzzzzzzzzz").

    IF NOT VALID-HANDLE({&hDBOTable2}) OR
       {&hDBOTable2}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable2}:FILE-NAME <> "esbo/boes271.p":U THEN DO:
       
        {btb/btb008za.i1 esbo/boes271.p YES}
        {btb/btb008za.i2 esbo/boes271.p '' {&hDBOTable2}} 
    END.

    RUN setConstraintByEmbarque IN {&hDBOTable2} (INPUT "", INPUT "ZZZZZZZZZZZZ").

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
    
    {zoom/OpenQueries.i &Query="ByEmbarque"
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
            WHEN "nr-pagamento":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nr-pagamento).
            WHEN "nr-cont-cambio":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nr-cont-cambio).
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
            WHEN "embarque":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.embarque).
            WHEN "nr-pagamento":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.nr-pagamento).
        END CASE.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnValues1 wZoom 
PROCEDURE returnValues1 :
/*------------------------------------------------------------------------------
  Purpose:     Executa m‚todo para retorna de campos conforme a p gina 
               selecionada
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE cFieldValueAux  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE hFieldHandleAux AS HANDLE    NO-UNDO.
    DEFINE VARIABLE iNumFieldAux    AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iNumPageAux     AS INTEGER   NO-UNDO.

    IF  VALID-HANDLE(hWindowParent) THEN
        ASSIGN hWindowParent:SENSITIVE = YES.
    
    /*--- Retorna o n£mero da p gina corrente ---*/
    &IF "{&Folder}":U = "YES":U &THEN
        RUN getCurrentFolder IN hFolder (OUTPUT iNumPageAux).
    &ENDIF

    /*--- Verifica se deve ser retornado o rowid do registro corrente, 
          neste caso ser  retornado o rowid da p gina corrente ---*/
    IF cFieldNames = "ROWID":U THEN DO:
        &IF NUM-ENTRIES("{&FolderLabels}":U) = 8 &THEN
            IF iNumPageAux = 8 THEN DO:
                IF AVAILABLE {&ttTable8} THEN
                    RUN repositionRecord IN WIDGET-HANDLE(cFieldHandles) (INPUT {&ttTable8}.r-Rowid).
                
                RETURN "OK":U.
            END.
        &ENDIF
        
        &IF NUM-ENTRIES("{&FolderLabels}":U) >= 7 &THEN
            IF iNumPageAux = 7 THEN DO:
                IF AVAILABLE {&ttTable7} THEN
                    RUN repositionRecord IN WIDGET-HANDLE(cFieldHandles) (INPUT {&ttTable7}.r-Rowid).
                
                RETURN "OK":U.
            END.
        &ENDIF
        
        &IF NUM-ENTRIES("{&FolderLabels}":U) >= 6 &THEN
            IF iNumPageAux = 6 THEN DO:
                IF AVAILABLE {&ttTable6} THEN
                    RUN repositionRecord IN WIDGET-HANDLE(cFieldHandles) (INPUT {&ttTable6}.r-Rowid).
                
                RETURN "OK":U.
            END.
        &ENDIF
        
        &IF NUM-ENTRIES("{&FolderLabels}":U) >= 5 &THEN
            IF iNumPageAux = 5 THEN DO:
                IF AVAILABLE {&ttTable5} THEN
                    RUN repositionRecord IN WIDGET-HANDLE(cFieldHandles) (INPUT {&ttTable5}.r-Rowid).
                
                RETURN "OK":U.
            END.
        &ENDIF
        
        &IF NUM-ENTRIES("{&FolderLabels}":U) >= 4 &THEN
            IF iNumPageAux = 4 THEN DO:
                IF AVAILABLE {&ttTable4} THEN
                    RUN repositionRecord IN WIDGET-HANDLE(cFieldHandles) (INPUT {&ttTable4}.r-Rowid).
                
                RETURN "OK":U.
            END.
        &ENDIF
        
        &IF NUM-ENTRIES("{&FolderLabels}":U) >= 3 &THEN
            IF iNumPageAux = 3 THEN DO:
                IF AVAILABLE {&ttTable3} THEN
                    RUN repositionRecord IN WIDGET-HANDLE(cFieldHandles) (INPUT {&ttTable3}.r-Rowid).
                
                RETURN "OK":U.
            END.
        &ENDIF
        
        &IF NUM-ENTRIES("{&FolderLabels}":U) >= 2 &THEN
            IF iNumPageAux = 2 THEN DO:
                IF AVAILABLE {&ttTable2} THEN DO:
                    FIND FIRST mgesp.pagamento
                         WHERE pagamento.nr-pagamento = {&ttTable2}.nr-pagamento NO-LOCK NO-ERROR.

                    IF AVAIL pagamento THEN
                        RUN repositionRecord IN WIDGET-HANDLE(cFieldHandles) (INPUT rowid(pagamento)). 
                END.
                
                RETURN "OK":U.
            END.
        &ENDIF
        
        &IF NUM-ENTRIES("{&FolderLabels}":U) >= 1 &THEN
            IF iNumPageAux = 1 THEN DO:
                IF AVAILABLE {&ttTable1} THEN
                    RUN repositionRecord IN WIDGET-HANDLE(cFieldHandles) (INPUT {&ttTable1}.r-Rowid).
                
                RETURN "OK":U.
            END.
        &ENDIF
    END.
    
    DO iNumFieldAux = 1 TO NUM-ENTRIES(cFieldNames):
        /*--- Executa m‚todo para retorna do valor do campo ---*/
        RUN VALUE("returnFieldsPage":U + STRING(iNumPageAux)) IN THIS-PROCEDURE ( INPUT ENTRY(iNumFieldAux, cFieldNames),
                                                                                 OUTPUT cFieldValueAux).
        
        /*--- Seta propriedade SCREEN-VALUE com os valores dos campos a 
              serem retornados ---*/
        ASSIGN hFieldHandleAux = WIDGET-HANDLE(ENTRY(iNumFieldAux, cFieldHandles))
               hFieldHandleAux:SCREEN-VALUE = cFieldValueAux.
    END.
    
    /*--- Aplica ENTRY para o primeiro campo a ser retornado ---*/
    ASSIGN hFieldHandleAux = WIDGET-HANDLE(ENTRY(1, cFieldHandles)).
    APPLY "ENTRY":U TO hFieldHandleAux.
    
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
                (INPUT fi-ini-nr-pagamento,
                 INPUT fi-fim-nr-pagamento,
                 INPUT fi-ini-contrato,
                 INPUT fi-fim-contrato).
        WHEN 2 THEN
            /*:T--- Seta Constraints para o DBO Table2 ---*/
            RUN setConstraintByEmbarque IN {&hDBOTable2}
                (INPUT fi-ini-embarque,
                 INPUT fi-fim-embarque).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnEmitente wZoom 
FUNCTION fnEmitente RETURNS CHARACTER
  ( pNrPgto AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  FOR FIRST pagamento
      WHERE pagamento.nr-pagamento = pNrPgto NO-LOCK:
      
      FOR FIRST emitente WHERE
          emitente.cod-emitente = pagamento.cod-emitente NO-LOCK:

          RETURN emitente.nome-abrev.

      END.
  END.

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnSwift wZoom 
FUNCTION fnSwift RETURNS CHARACTER
  ( pNrPgto AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  FOR FIRST pagamento
      WHERE pagamento.nr-pagamento = pNrPgto NO-LOCK:
      
      RETURN pagamento.swift.
  END.

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnValorPgto wZoom 
FUNCTION fnValorPgto RETURNS CHAR
  ( pNrPgto AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  FOR FIRST pagamento
      WHERE pagamento.nr-pagamento = pNrPgto NO-LOCK:
      
      RETURN STRING(pagamento.valor-pag).
  END.

  RETURN "0".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

