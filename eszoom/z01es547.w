&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-crm-categ-un NO-UNDO LIKE crm-categ-un
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
{include/i-prgvrs.i Z01ES547 2.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           Z01ES547
&GLOBAL-DEFINE Version           2.00.00.001

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      Categ x UN

&GLOBAL-DEFINE Range             NO

&GLOBAL-DEFINE FieldsRangePage1  
&GLOBAL-DEFINE FieldsAnyKeyPage1 

&GLOBAL-DEFINE ttTable1          tt-crm-categ-un
&GLOBAL-DEFINE hDBOTable1        h-boes547
&GLOBAL-DEFINE DBOTable1         crm-categ-un

&GLOBAL-DEFINE page1Browse       brTable1

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable1}   AS HANDLE      NO-UNDO.

DEFINE VARIABLE c-ds-categoria   AS CHARACTER FORMAT "x(30)"  NO-UNDO.
DEFINE VARIABLE c-ds-unid-comerc AS CHARACTER FORMAT "x(40)"  NO-UNDO.

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
&Scoped-define INTERNAL-TABLES tt-crm-categ-un

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 tt-crm-categ-un.cd-unid-negoc ~
fnDsUnidNegoc (tt-crm-categ-un.cd-unid-negoc) @ c-ds-unid-comerc ~
tt-crm-categ-un.cd-categoria ~
fnDsCategoria(tt-crm-categ-un.cd-categoria) @ c-ds-categoria 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH tt-crm-categ-un NO-LOCK ~
    BY tt-crm-categ-un.cd-unid-negoc
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH tt-crm-categ-un NO-LOCK ~
    BY tt-crm-categ-un.cd-unid-negoc.
&Scoped-define TABLES-IN-QUERY-brTable1 tt-crm-categ-un
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 tt-crm-categ-un


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDsCategoria wZoom 
FUNCTION fnDsCategoria RETURNS CHARACTER
  ( pCd-categoria AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDsUnidNegoc wZoom 
FUNCTION fnDsUnidNegoc RETURNS CHARACTER
  ( pCd-unid-comerc AS CHARACTER )  FORWARD.

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

DEFINE BUTTON btImplant1 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE BUTTON btSet1 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "Set" 
     SIZE 5 BY 1.

DEFINE VARIABLE i-cd-categoria-fim AS INTEGER FORMAT ">>9" INITIAL 999 
     VIEW-AS FILL-IN 
     SIZE 5.86 BY .88 NO-UNDO.

DEFINE VARIABLE i-cd-categoria-ini AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Categoria" 
     VIEW-AS FILL-IN 
     SIZE 5.86 BY .88 NO-UNDO.

DEFINE VARIABLE i-cd-unid-comerc-fim AS INTEGER FORMAT ">>9" INITIAL 999 
     VIEW-AS FILL-IN 
     SIZE 5.86 BY .88 NO-UNDO.

DEFINE VARIABLE i-cd-unid-comerc-ini AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Unid Comercial" 
     VIEW-AS FILL-IN 
     SIZE 5.86 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .92.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .92.

DEFINE IMAGE IMAGE-3
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .92.

DEFINE IMAGE IMAGE-4
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .92.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      tt-crm-categ-un SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      tt-crm-categ-un.cd-unid-negoc FORMAT "x(3)":U WIDTH 15.86
      fnDsUnidNegoc (tt-crm-categ-un.cd-unid-negoc) @ c-ds-unid-comerc COLUMN-LABEL "Descri‡Æo"
            WIDTH 25
      tt-crm-categ-un.cd-categoria FORMAT ">>9":U WIDTH 14.43
      fnDsCategoria(tt-crm-categ-un.cd-categoria) @ c-ds-categoria COLUMN-LABEL "Descri‡Æo"
            WIDTH 21.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.25
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
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     i-cd-unid-comerc-ini AT ROW 1.25 COL 25 COLON-ALIGNED HELP
          "C¢digo da Unidade Comercial" WIDGET-ID 24
     i-cd-unid-comerc-fim AT ROW 1.25 COL 46.86 COLON-ALIGNED HELP
          "C¢digo da Unidade Comercial" NO-LABEL WIDGET-ID 26
     i-cd-categoria-ini AT ROW 2.25 COL 25 COLON-ALIGNED HELP
          "C¢digo da categoria" WIDGET-ID 20
     i-cd-categoria-fim AT ROW 2.25 COL 46.86 COLON-ALIGNED HELP
          "C¢digo da categoria" NO-LABEL WIDGET-ID 22
     btSet1 AT ROW 2.25 COL 79 WIDGET-ID 28
     brTable1 AT ROW 3.75 COL 2
     btImplant1 AT ROW 13 COL 2
     IMAGE-3 AT ROW 2.33 COL 33.72 WIDGET-ID 12
     IMAGE-4 AT ROW 2.33 COL 45 WIDGET-ID 14
     IMAGE-1 AT ROW 1.25 COL 33.72 WIDGET-ID 16
     IMAGE-2 AT ROW 1.25 COL 45 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Zoom
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-crm-categ-un T "?" NO-UNDO mgesp crm-categ-un
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
/* BROWSE-TAB brTable1 btSet1 fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.tt-crm-categ-un"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.tt-crm-categ-un.cd-unid-negoc|yes"
     _FldNameList[1]   > Temp-Tables.tt-crm-categ-un.cd-unid-negoc
"tt-crm-categ-un.cd-unid-negoc" ? ? "character" ? ? ? ? ? ? no ? no no "15.86" yes no no "U" "" ""
     _FldNameList[2]   > "_<CALC>"
"fnDsUnidNegoc (tt-crm-categ-un.cd-unid-negoc) @ c-ds-unid-comerc" "Descri‡Æo" ? ? ? ? ? ? ? ? no ? no no "25" yes no no "U" "" ""
     _FldNameList[3]   > Temp-Tables.tt-crm-categ-un.cd-categoria
"tt-crm-categ-un.cd-categoria" ? ? "integer" ? ? ? ? ? ? no ? no no "14.43" yes no no "U" "" ""
     _FldNameList[4]   > "_<CALC>"
"fnDsCategoria(tt-crm-categ-un.cd-categoria) @ c-ds-categoria" "Descri‡Æo" ? ? ? ? ? ? ? ? no ? no no "21.43" yes no no "U" "" ""
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
    {zoom/implant.i &ProgramImplant="esp/cdp/escdp025.w"
                    &PageNumber="1"}
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
&Scoped-define SELF-NAME btSet1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSet1 wZoom
ON CHOOSE OF btSet1 IN FRAME fPage1 /* Set */
DO:
    RUN setConstraints (INPUT 1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
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

    ENABLE i-cd-categoria-ini
           i-cd-categoria-fim
           i-cd-unid-comerc-ini
           i-cd-unid-comerc-fim
           btSet1
        WITH FRAME fPage1.

    DISPLAY i-cd-categoria-ini
            i-cd-categoria-fim
            i-cd-unid-comerc-ini
            i-cd-unid-comerc-fim
        WITH FRAME fPage1.

    APPLY "CHOOSE" TO btSet1 IN FRAME fPage1.

    RETURN "OK":U.
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
       {&hDBOTable1}:FILE-NAME <> "esbo/boes547.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes547.p YES}
        {btb/btb008za.i2 esbo/boes547.p '' {&hDBOTable1}} 
    END.
    
    RUN setConstraintRangeCatUnid IN {&hDBOTable1} (INPUT 0,
                                                    INPUT 999,
                                                    INPUT "",
                                                    INPUT "ZZZ") NO-ERROR.

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
    
    {zoom/openqueries.i &Query="RangeCatUnid"
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
            WHEN "cd-categoria":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cd-categoria).
            WHEN "ds-categoria":U THEN
                ASSIGN pcFieldValue = STRING(INPUT BROWSE brTable1 c-ds-categoria).
            WHEN "cd-unid-negoc":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cd-unid-negoc).
            WHEN "ds-unid-negoc" THEN
                ASSIGN pcFieldValue = STRING(INPUT BROWSE brTable1 c-ds-unid-comerc).
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
            RUN setConstraintRangeCatUnid IN {&hDBOTable1} (INPUT INPUT FRAME fPage1 i-cd-categoria-ini,
                                                            INPUT INPUT FRAME fPage1 i-cd-categoria-fim,
                                                            INPUT INPUT FRAME fPage1 i-cd-unid-comerc-ini,
                                                            INPUT INPUT FRAME fPage1 i-cd-unid-comerc-fim).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setUnidNegoc wZoom 
PROCEDURE setUnidNegoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pCod-unid-negoc AS INTEGER   NO-UNDO.

    ASSIGN i-cd-unid-comerc-ini = INT(pCod-unid-negoc)
           i-cd-unid-comerc-fim = INT(pCod-unid-negoc).

    DISPLAY i-cd-unid-comerc-ini
            i-cd-unid-comerc-fim
        WITH FRAME fPage1.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDsCategoria wZoom 
FUNCTION fnDsCategoria RETURNS CHARACTER
  ( pCd-categoria AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    
    FIND FIRST crm-categoria NO-LOCK
        WHERE  crm-categoria.cd-categoria = pCd-categoria NO-ERROR.

    ASSIGN c-ds-categoria = IF AVAIL crm-categoria THEN crm-categoria.ds-categoria ELSE "".

    RETURN c-ds-categoria.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDsUnidNegoc wZoom 
FUNCTION fnDsUnidNegoc RETURNS CHARACTER
  ( pCd-unid-comerc AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FIND FIRST unid-comerc NO-LOCK
        WHERE  unid-comerc.cd-unid-comerc = INT(pCd-unid-comerc) NO-ERROR.
    ASSIGN c-ds-unid-comerc = IF AVAIL unid-comerc THEN unid-comerc.ds-unid-comerc ELSE "".

    RETURN c-ds-unid-comerc.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

