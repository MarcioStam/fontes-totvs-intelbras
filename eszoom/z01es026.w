&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttcar-familia-item NO-UNDO LIKE car-familia-item
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
{include/i-prgvrs.i Z01ES026 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           Z01ES026
&GLOBAL-DEFINE Version           2.04.00.001

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      Caract,Descri‡Æo

&GLOBAL-DEFINE Range             YES

&GLOBAL-DEFINE FieldsRangePage1  mgesp.car-familia-item.cod-familia,mgesp.car-familia-item.cod-sub-familia,mgesp.car-familia-item.cod-car-familia
&GLOBAL-DEFINE FieldsRangePage2  mgesp.car-familia-item.cod-familia,mgesp.car-familia-item.cod-sub-familia,mgesp.car-familia-item.Descricao
&GLOBAL-DEFINE FieldsAnyKeyPage1 no,no,no
&GLOBAL-DEFINE FieldsAnyKeyPage2 no,no,yes

&GLOBAL-DEFINE ttTable1          ttcar-familia-item
&GLOBAL-DEFINE hDBOTable1        hboes026
&GLOBAL-DEFINE DBOTable1         car-familia-item

&GLOBAL-DEFINE ttTable2          ttcar-familia-item
&GLOBAL-DEFINE hDBOTable2        hboes026-1
&GLOBAL-DEFINE DBOTable2         car-familia-item

&GLOBAL-DEFINE page1Browse       brTable1
&GLOBAL-DEFINE page2Browse       brTable2

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable1} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTable2} AS HANDLE NO-UNDO.
define variable v-cod-familia as integer no-undo.

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
&Scoped-define INTERNAL-TABLES ttcar-familia-item

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 ttcar-familia-item.cod-familia ~
ttcar-familia-item.cod-sub-familia ttcar-familia-item.cod-car-familia ~
ttcar-familia-item.Descricao ttcar-familia-item.abreviatura 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH ttcar-familia-item NO-LOCK
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH ttcar-familia-item NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTable1 ttcar-familia-item
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 ttcar-familia-item


/* Definitions for BROWSE brTable2                                      */
&Scoped-define FIELDS-IN-QUERY-brTable2 ttcar-familia-item.cod-familia ~
ttcar-familia-item.cod-sub-familia ttcar-familia-item.Descricao ~
ttcar-familia-item.cod-car-familia ttcar-familia-item.abreviatura 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable2 
&Scoped-define QUERY-STRING-brTable2 FOR EACH ttcar-familia-item NO-LOCK ~
    BY ttcar-familia-item.cod-familia ~
       BY ttcar-familia-item.cod-sub-familia ~
        BY ttcar-familia-item.Descricao
&Scoped-define OPEN-QUERY-brTable2 OPEN QUERY brTable2 FOR EACH ttcar-familia-item NO-LOCK ~
    BY ttcar-familia-item.cod-familia ~
       BY ttcar-familia-item.cod-sub-familia ~
        BY ttcar-familia-item.Descricao.
&Scoped-define TABLES-IN-QUERY-brTable2 ttcar-familia-item
&Scoped-define FIRST-TABLE-IN-QUERY-brTable2 ttcar-familia-item


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

DEFINE BUTTON btImplant1 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE BUTTON btImplant2 
     LABEL "Implantar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      ttcar-familia-item SCROLLING.

DEFINE QUERY brTable2 FOR 
      ttcar-familia-item SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      ttcar-familia-item.cod-familia FORMAT ">>9":U
      ttcar-familia-item.cod-sub-familia FORMAT ">9":U
      ttcar-familia-item.cod-car-familia FORMAT ">9":U
      ttcar-familia-item.Descricao FORMAT "x(35)":U
      ttcar-familia-item.abreviatura FORMAT "x(15)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 8.67
         FONT 2.

DEFINE BROWSE brTable2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable2 wZoom _STRUCTURED
  QUERY brTable2 NO-LOCK DISPLAY
      ttcar-familia-item.cod-familia FORMAT ">>9":U
      ttcar-familia-item.cod-sub-familia FORMAT ">9":U
      ttcar-familia-item.Descricao FORMAT "x(35)":U
      ttcar-familia-item.cod-car-familia FORMAT ">9":U
      ttcar-familia-item.abreviatura FORMAT "x(15)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 8.67
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
     brTable1 AT ROW 4.33 COL 2
     btImplant1 AT ROW 13 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     brTable2 AT ROW 4.33 COL 2
     btImplant2 AT ROW 13 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Zoom
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttcar-familia-item T "?" NO-UNDO mgesp car-familia-item
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brTable1 1 fPage1 */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brTable2 1 fPage2 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.ttcar-familia-item"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.ttcar-familia-item.cod-familia
     _FldNameList[2]   = Temp-Tables.ttcar-familia-item.cod-sub-familia
     _FldNameList[3]   = Temp-Tables.ttcar-familia-item.cod-car-familia
     _FldNameList[4]   = Temp-Tables.ttcar-familia-item.Descricao
     _FldNameList[5]   = Temp-Tables.ttcar-familia-item.abreviatura
     _Query            is OPENED
*/  /* BROWSE brTable1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable2
/* Query rebuild information for BROWSE brTable2
     _TblList          = "Temp-Tables.ttcar-familia-item"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.ttcar-familia-item.cod-familia|yes,Temp-Tables.ttcar-familia-item.cod-sub-familia|yes,Temp-Tables.ttcar-familia-item.Descricao|yes"
     _FldNameList[1]   = Temp-Tables.ttcar-familia-item.cod-familia
     _FldNameList[2]   = Temp-Tables.ttcar-familia-item.cod-sub-familia
     _FldNameList[3]   = Temp-Tables.ttcar-familia-item.Descricao
     _FldNameList[4]   = Temp-Tables.ttcar-familia-item.cod-car-familia
     _FldNameList[5]   = Temp-Tables.ttcar-familia-item.abreviatura
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
    def var wh-object as widget-handle no-undo.
    
    if v-cod-familia > 0 then do:
        ASSIGN wh-object = frame fPage1:handle
               wh-object = wh-object:FIRST-CHILD
               wh-object = wh-object:FIRST-CHILD.
    
        DO WHILE VALID-HANDLE(wh-object):
            IF wh-object:TYPE <> "field-group" THEN DO:
            
                if wh-object:type = "fill-in" and wh-object:row = 1.17 then
                    assign wh-object:screen-value = string(v-cod-familia)
                           wh-object:sensitive = no.
            
                ASSIGN wh-object = wh-object:NEXT-SIBLING NO-ERROR.
            END.
            ELSE leave.
    
        END.

        ASSIGN wh-object = frame fPage2:handle
               wh-object = wh-object:FIRST-CHILD
               wh-object = wh-object:FIRST-CHILD.
    
        DO WHILE VALID-HANDLE(wh-object):
            IF wh-object:TYPE <> "field-group" THEN DO:
            
                if wh-object:type = "fill-in" and wh-object:row = 1.17 then
                    assign wh-object:screen-value = string(v-cod-familia)
                           wh-object:sensitive = no.
            
                ASSIGN wh-object = wh-object:NEXT-SIBLING NO-ERROR.
            END.
            ELSE leave.
    
        END.
    
    end.

                                                 
    
    
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
       {&hDBOTable1}:FILE-NAME <> "esbo/boes026.p":U THEN DO:
       
        {btb/btb008za.i1 esbo/boes026.p YES}
        {btb/btb008za.i2 esbo/boes026.p '' {&hDBOTable1}} 
    END.
    
    RUN setConstraintZoom1 IN {&hDBOTable1} (input v-cod-familia, 
                                             input if v-cod-familia = 0 then 999 else v-cod-familia,
                                             input 0,
                                             input 99,
                                             input 0,
                                             input 99) NO-ERROR.
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable2}) OR
       {&hDBOTable2}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable2}:FILE-NAME <> "esbo/boes026.p":U THEN DO:
       
        {btb/btb008za.i1 esbo/boes026.p YES}
        {btb/btb008za.i2 esbo/boes026.p '' {&hDBOTable2}} 
    END.
    
    RUN setConstraintZoom2 IN {&hDBOTable2} (input v-cod-familia, 
                                             input if v-cod-familia = 0 then 999 else v-cod-familia,
                                             input 0,
                                             input 99,
                                             input "",
                                             input fill("Z", 35)) NO-ERROR.
                                             

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
    
    {zoom/openqueries.i &Query="Zoom2"
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
            WHEN "abreviatura":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.abreviatura).
            WHEN "cod-familia":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-familia).
            WHEN "cod-sub-familia":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-sub-familia).
            WHEN "cod-car-familia":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-car-familia).
            WHEN "Descricao":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.Descricao).
        END CASE.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFieldsPage2 wZoom 
PROCEDURE returnFieldsPage2 :
/*:T------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos da p gina 2
  Parameters:  recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE  INPUT PARAMETER pcField      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFieldValue AS CHARACTER NO-UNDO.
    
    IF AVAILABLE {&ttTable2} THEN DO:
        CASE pcField:
            WHEN "abreviatura":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.abreviatura).
            WHEN "cod-familia":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.cod-familia).
            WHEN "cod-sub-familia":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.cod-sub-familia).
            WHEN "cod-car-familia":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.cod-car-familia).
            WHEN "Descricao":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.Descricao).
        END CASE.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaVariable wZoom 
PROCEDURE setaVariable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-familia AS integer NO-UNDO.                                                                        

    v-cod-familia = p-cod-familia.

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
            RUN setConstraintZoom1 IN {&hDBOTable1} (INPUT if v-cod-familia = 0 then fnIniRangeIntPage(INPUT 1, INPUT 1) else v-cod-familia,
                                                     INPUT if v-cod-familia = 0 then fnEndRangeIntPage(INPUT 1, INPUT 1) else v-cod-familia,
                                                     INPUT fnIniRangeIntPage(INPUT 1, INPUT 2),
                                                     INPUT fnEndRangeIntPage(INPUT 1, INPUT 2),
                                                     INPUT fnIniRangeIntPage(INPUT 1, INPUT 3),
                                                     INPUT fnEndRangeIntPage(INPUT 1, INPUT 3)).
        WHEN 2 THEN
            /*:T--- Seta Constraints para o DBO Table2 ---*/
            RUN setConstraintZoom2 IN {&hDBOTable2} (INPUT if v-cod-familia = 0 then fnIniRangeIntPage(INPUT 2, INPUT 1) else v-cod-familia,
                                                     INPUT if v-cod-familia = 0 then fnEndRangeIntPage(INPUT 2, INPUT 1) else v-cod-familia,
                                                     INPUT fnIniRangeIntPage(INPUT 2, INPUT 2),
                                                     INPUT fnEndRangeIntPage(INPUT 2, INPUT 2),
                                                     INPUT fnIniRangeCharPage(INPUT 2, INPUT 3),
                                                     INPUT fnEndRangeCharPage(INPUT 2, INPUT 3)).

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

