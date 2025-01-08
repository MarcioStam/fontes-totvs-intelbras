&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-correios NO-UNDO LIKE correios
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
{include/i-prgvrs.i Z01es563 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           Z01es563
&GLOBAL-DEFINE Version            2.04.00.001

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      Correios

&GLOBAL-DEFINE Range             NO

&GLOBAL-DEFINE FieldsRangePage1  tt-correios.cod-estabel,tt-correios.mes-ref,tt-correios.nr-contrato,tt-correios.nr-fatura,tt-correios.nr-cartao,tt-correios.cc-codigo,tt-correios.dt-postagem,tt-correios.nr-docto 
&GLOBAL-DEFINE FieldsAnyKeyPage1 no,no,NO,no,no,NO,no,NO

&GLOBAL-DEFINE ttTable1          tt-correios
&GLOBAL-DEFINE hDBOTable1        h-boes563
&GLOBAL-DEFINE DBOTable1         correios

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
&Scoped-define INTERNAL-TABLES tt-correios

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 tt-correios.cod-estabel ~
tt-correios.mes-ref tt-correios.nr-contrato tt-correios.nr-fatura ~
tt-correios.cod-cliente tt-correios.nr-cartao tt-correios.cc-codigo ~
tt-correios.servico tt-correios.dt-postagem tt-correios.nr-docto ~
tt-correios.qtde tt-correios.valor tt-correios.peso ~
tt-correios.origem-postagem 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH tt-correios NO-LOCK
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH tt-correios NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTable1 tt-correios
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 tt-correios


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

DEFINE VARIABLE c-cartao-fim AS CHARACTER FORMAT "X(10)":U INITIAL "9999999999" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE c-cartao-ini AS CHARACTER FORMAT "X(10)":U 
     LABEL "Nr CartÆo" 
     VIEW-AS FILL-IN 
     SIZE 18.72 BY .79 NO-UNDO.

DEFINE VARIABLE c-estabel-fim AS CHARACTER FORMAT "X(03)":U INITIAL "zzz" 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-estabel-ini AS CHARACTER FORMAT "X(03)":U 
     LABEL "Estebelecimento" 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-periodo AS CHARACTER FORMAT "9999/99":U INITIAL "201011" 
     LABEL "Per¡odo" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .79 NO-UNDO.

DEFINE VARIABLE c-servico AS CHARACTER FORMAT "X(256)":U 
     LABEL "Servi‡o" 
     VIEW-AS FILL-IN 
     SIZE 21.72 BY .79 NO-UNDO.

DEFINE VARIABLE dt-postagem-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .88 NO-UNDO.

DEFINE VARIABLE dt-postagem-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Postagem" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

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
      tt-correios SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      tt-correios.cod-estabel FORMAT "x(03)":U
      tt-correios.mes-ref FORMAT "9999/99":U
      tt-correios.nr-contrato FORMAT "x(20)":U WIDTH 11.14
      tt-correios.nr-fatura FORMAT "x(20)":U WIDTH 10
      tt-correios.cod-cliente FORMAT ">>>>>>>>9":U WIDTH 7.43
      tt-correios.nr-cartao FORMAT "x(20)":U WIDTH 10.43
      tt-correios.cc-codigo FORMAT "x(8)":U
      tt-correios.servico FORMAT "x(40)":U WIDTH 20
      tt-correios.dt-postagem FORMAT "99/99/9999":U
      tt-correios.nr-docto FORMAT "x(10)":U
      tt-correios.qtde FORMAT ">>>>>>9":U
      tt-correios.valor FORMAT ">>>,>>>,>>>,>>>,>>9.99":U
      tt-correios.peso FORMAT ">>>>>>>>>9":U
      tt-correios.origem-postagem FORMAT "x(30)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 7.42
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
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     c-periodo AT ROW 1.17 COL 11.29 COLON-ALIGNED WIDGET-ID 4
     c-estabel-ini AT ROW 2 COL 11.29 COLON-ALIGNED WIDGET-ID 2
     c-estabel-fim AT ROW 1.88 COL 39.57 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     c-cartao-ini AT ROW 2.92 COL 11.29 COLON-ALIGNED WIDGET-ID 14
     c-cartao-fim AT ROW 2.88 COL 39.57 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     dt-postagem-ini AT ROW 3.83 COL 11.29 COLON-ALIGNED WIDGET-ID 22
     dt-postagem-fim AT ROW 3.83 COL 39.57 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     c-servico AT ROW 4.88 COL 11.29 COLON-ALIGNED WIDGET-ID 30
     btCheck AT ROW 4.5 COL 83 RIGHT-ALIGNED WIDGET-ID 8
     brTable1 AT ROW 6 COL 2
     btImplant1 AT ROW 13.54 COL 2
     IMAGE-1 AT ROW 1.92 COL 35 WIDGET-ID 10
     IMAGE-2 AT ROW 1.88 COL 38.43 WIDGET-ID 12
     IMAGE-5 AT ROW 2.88 COL 35 WIDGET-ID 18
     IMAGE-6 AT ROW 2.83 COL 38.43 WIDGET-ID 20
     IMAGE-7 AT ROW 3.83 COL 35 WIDGET-ID 26
     IMAGE-8 AT ROW 3.79 COL 38.43 WIDGET-ID 28
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS TOP-ONLY NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.25
         SIZE 84.43 BY 13.75
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Zoom
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-correios T "?" NO-UNDO mgesp correios
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
         MAX-HEIGHT         = 29.33
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 29.33
         VIRTUAL-WIDTH      = 182.86
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
   Custom                                                               */
/* BROWSE-TAB brTable1 btCheck fPage1 */
/* SETTINGS FOR BUTTON btCheck IN FRAME fPage1
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN c-cartao-fim IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cartao-ini IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-estabel-fim IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-estabel-ini IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-periodo IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage2
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.tt-correios"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.tt-correios.cod-estabel
     _FldNameList[2]   > Temp-Tables.tt-correios.mes-ref
"tt-correios.mes-ref" ? "9999/99" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[3]   > Temp-Tables.tt-correios.nr-contrato
"tt-correios.nr-contrato" ? ? "character" ? ? ? ? ? ? no ? no no "11.14" yes no no "U" "" ""
     _FldNameList[4]   > Temp-Tables.tt-correios.nr-fatura
"tt-correios.nr-fatura" ? ? "character" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" ""
     _FldNameList[5]   > Temp-Tables.tt-correios.cod-cliente
"tt-correios.cod-cliente" ? ? "integer" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" ""
     _FldNameList[6]   > Temp-Tables.tt-correios.nr-cartao
"tt-correios.nr-cartao" ? ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" ""
     _FldNameList[7]   = Temp-Tables.tt-correios.cc-codigo
     _FldNameList[8]   > Temp-Tables.tt-correios.servico
"tt-correios.servico" ? ? "character" ? ? ? ? ? ? no ? no no "20" yes no no "U" "" ""
     _FldNameList[9]   = Temp-Tables.tt-correios.dt-postagem
     _FldNameList[10]   = Temp-Tables.tt-correios.nr-docto
     _FldNameList[11]   = Temp-Tables.tt-correios.qtde
     _FldNameList[12]   = Temp-Tables.tt-correios.valor
     _FldNameList[13]   = Temp-Tables.tt-correios.peso
     _FldNameList[14]   = Temp-Tables.tt-correios.origem-postagem
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
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
         c-estabel-ini c-estabel-fim 
         c-periodo 
         c-cartao-ini c-cartao-fim
         dt-postagem-ini dt-postagem-fim
         c-servico.
  
  RUN setConstraints IN THIS-PROCEDURE (1).
                                        
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


    ASSIGN c-periodo:SCREEN-VALUE IN FRAME fpage1       = STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99")
           c-estabel-fim:SCREEN-VALUE IN FRAME fpage1   = STRING("ZZZ")
           c-cartao-fim:SCREEN-VALUE IN FRAME fpage1    = STRING("9999999999")
           dt-postagem-ini:SCREEN-VALUE IN FRAME fpage1 = STRING(TODAY)
           dt-postagem-fim:SCREEN-VALUE IN FRAME fpage1 = STRING(TODAY).

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

ENABLE c-periodo
       c-estabel-ini c-estabel-fim 
       c-cartao-ini c-cartao-fim 
       dt-postagem-ini dt-postagem-fim
       c-servico
       btCheck WITH FRAME fPage1.

ASSIGN c-periodo:SCREEN-VALUE IN FRAME fpage1       = STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99")
       c-estabel-fim:SCREEN-VALUE IN FRAME fpage1   = STRING("ZZZ")
       c-cartao-fim:SCREEN-VALUE IN FRAME fpage1    = STRING("9999999999")
       dt-postagem-ini:SCREEN-VALUE IN FRAME fpage1 = STRING(TODAY)
       dt-postagem-fim:SCREEN-VALUE IN FRAME fpage1 = STRING(TODAY).                                                                                  
       
APPLY "choose" TO btCheck IN FRAME fpage1. 

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
       {&hDBOTable1}:FILE-NAME <> "esbo/boes563.p"  THEN DO:
       
        {btb/btb008za.i1 esbo/boes563.p YES}
        {btb/btb008za.i2 esbo/boes563.p '' {&hDBOTable1}} 
    END.
    
    RUN setConstraintZoom1 IN {&hDBOTable1} (input "", 
                                             input "ZZZ",
                                             INPUT STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99"),
                                             input TODAY,
                                             INPUT TODAY,
                                             input "") NO-ERROR.
    
          
   run SetFolder IN hFolder (INPUT 1). 

   ASSIGN FRAME fpage1:PAGE-TOP = YES. 
    
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
            WHEN "mes-ref":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.mes-ref).  
            WHEN "nr-contrato":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nr-contrato).  
            WHEN "nr-fatura":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nr-fatura).
            WHEN "cod-cli":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-cli).
            WHEN "nr-cartao":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nr-cartao).
            WHEN "cc-codigo":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cc-codigo).
            WHEN "servico":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.servico).
            WHEN "dt-postagem":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.dt-postagem).
            WHEN "nr-docto":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nr-docto).

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

          RUN setConstraintZoom1 IN {&hDBOTable1} (INPUT INPUT FRAME fpage1 c-estabel-ini , 
                                                   INPUT INPUT FRAME fpage1 c-estabel-fim ,
                                                   INPUT INPUT FRAME fpage1 c-periodo, 
                                                   INPUT INPUT FRAME fpage1 c-cartao-ini,
                                                   INPUT INPUT FRAME fpage1 c-cartao-fim,
                                                   INPUT INPUT FRAME fpage1 dt-postagem-ini,
                                                   INPUT INPUT FRAME fpage1 dt-postagem-fim,
                                                   INPUT INPUT FRAME fpage1 c-servico).

         
        END.
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

