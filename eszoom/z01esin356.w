&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgmov           PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttprazo-compra NO-UNDO LIKE prazo-compra
       field num-pedido like ordem-compra.num-pedido
       field r-rowid    as rowid.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wZoom 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i z01esin356 9.99.99.999}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           z01esin356
&GLOBAL-DEFINE Version           2.00.00.000

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      Ped/Ord/Parc

&GLOBAL-DEFINE Range             YES

&GLOBAL-DEFINE FieldsRangePage1  
&GLOBAL-DEFINE FieldsRangePage2  
&GLOBAL-DEFINE FieldsRangePage3  
&GLOBAL-DEFINE FieldsRangePage4  
&GLOBAL-DEFINE FieldsRangePage5  
&GLOBAL-DEFINE FieldsRangePage6  
&GLOBAL-DEFINE FieldsRangePage7  
&GLOBAL-DEFINE FieldsRangePage8  
&GLOBAL-DEFINE FieldsAnyKeyPage1 
&GLOBAL-DEFINE FieldsAnyKeyPage2 
&GLOBAL-DEFINE FieldsAnyKeyPage3 
&GLOBAL-DEFINE FieldsAnyKeyPage4 
&GLOBAL-DEFINE FieldsAnyKeyPage5 
&GLOBAL-DEFINE FieldsAnyKeyPage6 
&GLOBAL-DEFINE FieldsAnyKeyPage7 
&GLOBAL-DEFINE FieldsAnyKeyPage8 

&GLOBAL-DEFINE ttTable1          ttprazo-compra
&GLOBAL-DEFINE hDBOTable1        hdboprazo-compra
&GLOBAL-DEFINE DBOTable1         prazo-compra

&GLOBAL-DEFINE ttTable2          
&GLOBAL-DEFINE hDBOTable2        
&GLOBAL-DEFINE DBOTable2         

&GLOBAL-DEFINE page1Browse       brTable1
&GLOBAL-DEFINE page2Browse      

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable1} AS HANDLE NO-UNDO.

DEF VAR i-num-pedido   LIKE pedido-compr.num-pedido.
DEF VAR i-numero-ordem LIKE ordem-compra.numero-ordem.

DEF VAR i-cod-emitente LIKE pedido-compr.cod-emitente.
DEF VAR c-it-codigo    LIKE ordem-compra.it-codigo.
DEF VAR c-desc-item    LIKE ITEM.desc-item.
DEF VAR c-nome-abrev   LIKE emitente.nome-abrev.

DEF VAR de-valor       AS DEC FORMAT ">>>,>>>,>>9.99" LABEL "Valor Pedido".

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
&Scoped-define INTERNAL-TABLES ttprazo-compra

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 ~
fn-pedido(ttprazo-compra.numero-ordem) @ i-num-pedido ~
ttprazo-compra.numero-ordem ttprazo-compra.parcela ttprazo-compra.it-codigo ~
ttprazo-compra.data-entrega ttprazo-compra.quant-saldo ~
fn-emitente(ttprazo-compra.numero-ordem) @ c-nome-abrev ~
fn-valor(ttprazo-compra.numero-ordem) @ de-valor ~
fn-desc-item(ttprazo-compra.it-codigo) @ c-desc-item 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH ttprazo-compra NO-LOCK
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH ttprazo-compra NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTable1 ttprazo-compra
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 ttprazo-compra


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brTable1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btOK btCancel btHelp rtToolBar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-desc-item wZoom 
FUNCTION fn-desc-item RETURNS CHARACTER
  (INPUT c-it-codigo AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-emitente wZoom 
FUNCTION fn-emitente RETURNS CHARACTER
  (INPUT i-numero-ordem AS INT)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-pedido wZoom 
FUNCTION fn-pedido RETURNS INTEGER
  (INPUT i-numero-ordem AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-valor wZoom 
FUNCTION fn-valor RETURNS DECIMAL
  (INPUT i-numero-ordem AS INT)  FORWARD.

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

DEFINE VARIABLE i-num-pedido-fim AS INTEGER FORMAT ">>>>>>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE i-num-pedido-ini AS INTEGER FORMAT ">>>>>>>9":U INITIAL 0 
     LABEL "Pedido" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      ttprazo-compra SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      fn-pedido(ttprazo-compra.numero-ordem) @ i-num-pedido
      ttprazo-compra.numero-ordem FORMAT "zzzzz9,99":U
      ttprazo-compra.parcela FORMAT ">>>>9":U
      ttprazo-compra.it-codigo FORMAT "X(16)":U
      ttprazo-compra.data-entrega FORMAT "99/99/9999":U
      ttprazo-compra.quant-saldo FORMAT ">>>>,>>9.9999":U
      fn-emitente(ttprazo-compra.numero-ordem) @ c-nome-abrev
      fn-valor(ttprazo-compra.numero-ordem) @ de-valor
      fn-desc-item(ttprazo-compra.it-codigo) @ c-desc-item
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.67
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
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage1
     i-num-pedido-ini AT ROW 1 COL 22 COLON-ALIGNED
     i-num-pedido-fim AT ROW 1 COL 46 COLON-ALIGNED NO-LABEL
     btCheck AT ROW 1 COL 79
     brTable1 AT ROW 2.33 COL 2
     btImplant1 AT ROW 13 COL 2
     IMAGE-1 AT ROW 1 COL 33
     IMAGE-2 AT ROW 1 COL 45
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
      TABLE: ttprazo-compra T "?" NO-UNDO mgmov prazo-compra
      ADDITIONAL-FIELDS:
          field num-pedido like ordem-compra.num-pedido
          field r-rowid    as rowid
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
         MAX-HEIGHT         = 29
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 29
         VIRTUAL-WIDTH      = 146.29
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.ttprazo-compra"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > "_<CALC>"
"fn-pedido(ttprazo-compra.numero-ordem) @ i-num-pedido" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[2]   = Temp-Tables.ttprazo-compra.numero-ordem
     _FldNameList[3]   = Temp-Tables.ttprazo-compra.parcela
     _FldNameList[4]   = Temp-Tables.ttprazo-compra.it-codigo
     _FldNameList[5]   = Temp-Tables.ttprazo-compra.data-entrega
     _FldNameList[6]   = Temp-Tables.ttprazo-compra.quant-saldo
     _FldNameList[7]   > "_<CALC>"
"fn-emitente(ttprazo-compra.numero-ordem) @ c-nome-abrev" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[8]   > "_<CALC>"
"fn-valor(ttprazo-compra.numero-ordem) @ de-valor" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[9]   > "_<CALC>"
"fn-desc-item(ttprazo-compra.it-codigo) @ c-desc-item" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
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
    DISPLAY
        i-num-pedido-ini
        i-num-pedido-fim
       WITH FRAME fPage1.

    ENABLE
        i-num-pedido-ini
        i-num-pedido-fim
        btCheck
       WITH FRAME fPage1.

    IF i-num-pedido-ini = 0 THEN
        ASSIGN i-num-pedido-ini = 0
               i-num-pedido-fim = 999999999.

    RUN setConstraintByCod IN {&hDBOTable1} (INPUT i-num-pedido-ini,
                                             INPUT i-num-pedido-fim,
                                             INPUT i-cod-emitente,
                                             INPUT c-it-codigo) NO-ERROR.
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
       {&hDBOTable1}:FILE-NAME <> "esbo/boesin356.p":U THEN DO:
       
        {btb/btb008za.i1 esbo/boesin356.p YES}
        {btb/btb008za.i2 esbo/boesin356.p '' {&hDBOTable1}} 
    END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-inicial wZoom 
PROCEDURE pi-seta-inicial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-emitente          LIKE pedido-compr.cod-emitente.
DEF INPUT PARAM p-it-codigo         LIKE ordem-compra.it-codigo.
DEF INPUT PARAM p-num-pedido-ini    LIKE pedido-compr.num-pedido.
DEF INPUT PARAM p-num-pedido-fim    LIKE pedido-compr.num-pedido.

ASSIGN i-cod-emitente   = p-emitente
       c-it-codigo      = p-it-codigo
       i-num-pedido-ini = p-num-pedido-ini
       i-num-pedido-fim = p-num-pedido-fim.

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
            WHEN "num-pedido":U THEN
                ASSIGN pcFieldValue = STRING(fn-pedido({&ttTable1}.numero-ordem)).
            WHEN "numero-ordem":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.numero-ordem).
            WHEN "parcela":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.parcela).
            WHEN "it-codigo":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.it-codigo).
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
            RUN setConstraintByCod IN {&hDBOTable1} (INPUT FRAME fPage1 i-num-pedido-ini,
                                                     INPUT FRAME fPage1 i-num-pedido-fim,
                                                     INPUT i-cod-emitente,
                                                     INPUT c-it-codigo).
       
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-desc-item wZoom 
FUNCTION fn-desc-item RETURNS CHARACTER
  (INPUT c-it-codigo AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FOR FIRST ITEM NO-LOCK
      WHERE ITEM.it-codigo = c-it-codigo:
      ASSIGN c-desc-item = ITEM.desc-item.
  END.

  RETURN c-desc-item.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-emitente wZoom 
FUNCTION fn-emitente RETURNS CHARACTER
  (INPUT i-numero-ordem AS INT) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FOR FIRST ordem-compra NO-LOCK
      WHERE ordem-compra.numero-ordem = i-numero-ordem,
      FIRST emitente NO-LOCK
      WHERE emitente.cod-emitente = ordem-compra.cod-emitente:
      ASSIGN c-nome-abrev = emitente.nome-abrev.
  END.

  RETURN c-nome-abrev.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-pedido wZoom 
FUNCTION fn-pedido RETURNS INTEGER
  (INPUT i-numero-ordem AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  ASSIGN i-num-pedido = 0.

  IF AVAIL ttprazo-compra THEN DO:
      FOR FIRST ordem-compra NO-LOCK
          WHERE ordem-compra.numero-ordem = i-numero-ordem:
          ASSIGN i-num-pedido = ordem-compra.num-pedido.
      END.
  END.

  RETURN i-num-pedido.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-valor wZoom 
FUNCTION fn-valor RETURNS DECIMAL
  (INPUT i-numero-ordem AS INT) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FOR FIRST ordem-compra NO-LOCK
      WHERE ordem-compra.num-pedido = i-num-pedido,
      EACH prazo-compra OF ordem-compra:
      
      ASSIGN de-valor = de-valor + (prazo-compra.quantidade * ordem-compra.pre-unit-for).
  END.

  RETURN de-valor.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

