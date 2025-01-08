&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttparam-correios-contrato NO-UNDO LIKE param-correios
       FIELD r-rowid AS ROWID.
DEFINE TEMP-TABLE ttparam-correios-est-tp NO-UNDO LIKE param-correios
       FIELD r-rowid AS ROWID.
DEFINE TEMP-TABLE ttparam-correios-un-post NO-UNDO LIKE param-correios
       FIELD r-rowid AS ROWID.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wZoom 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i Z01ES544 2.04.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           Z01ES544
&GLOBAL-DEFINE Version           2.04.00.000

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      Est Tipo,Contrato,Un. Post

&GLOBAL-DEFINE Range             YES

&GLOBAL-DEFINE FieldsRangePage1  mgesp.param-correios.cod-estabel,mgesp.param-correios.tp-servico
&GLOBAL-DEFINE FieldsRangePage2  mgesp.param-correios.nr-contrato
&GLOBAL-DEFINE FieldsRangePage3  mgesp.param-correios.cod-un-postagem
&GLOBAL-DEFINE FieldsAnyKeyPage1 NO,NO
&GLOBAL-DEFINE FieldsAnyKeyPage2 NO
&GLOBAL-DEFINE FieldsAnyKeyPage3 NO

&GLOBAL-DEFINE ttTable1          ttparam-correios-est-tp
&GLOBAL-DEFINE hDBOTable1        hDBOParam-correios-est-tp
&GLOBAL-DEFINE DBOTable1         param-correios

&GLOBAL-DEFINE ttTable2          ttparam-correios-contrato
&GLOBAL-DEFINE hDBOTable2        hDBOParam-correios-contrato
&GLOBAL-DEFINE DBOTable2         param-correios

&GLOBAL-DEFINE ttTable3          ttparam-correios-un-post
&GLOBAL-DEFINE hDBOTable3        hDBOParam-correios-un-post
&GLOBAL-DEFINE DBOTable3         param-correios

&GLOBAL-DEFINE page1Browse       brTable1
&GLOBAL-DEFINE page2Browse       brTable2
&GLOBAL-DEFINE page3Browse       brTable3

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable1} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTable2} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTable3} AS HANDLE NO-UNDO.

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
&Scoped-define INTERNAL-TABLES ttparam-correios-est-tp ~
ttparam-correios-contrato ttparam-correios-un-post

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 ttparam-correios-est-tp.cod-estabel ~
ttparam-correios-est-tp.tp-servico ~
ttparam-correios-est-tp.prefix-tp-servico ~
ttparam-correios-est-tp.nr-contrato ttparam-correios-est-tp.cod-admin ~
ttparam-correios-est-tp.cod-un-postagem ~
ttparam-correios-est-tp.des-un-postagem 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH ttparam-correios-est-tp NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH ttparam-correios-est-tp NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brTable1 ttparam-correios-est-tp
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 ttparam-correios-est-tp


/* Definitions for BROWSE brTable2                                      */
&Scoped-define FIELDS-IN-QUERY-brTable2 ~
ttparam-correios-contrato.nr-contrato ttparam-correios-contrato.cod-estabel ~
ttparam-correios-contrato.tp-servico ~
ttparam-correios-contrato.prefix-tp-servico ~
ttparam-correios-contrato.cod-un-postagem ~
ttparam-correios-contrato.des-un-postagem 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable2 
&Scoped-define QUERY-STRING-brTable2 FOR EACH ttparam-correios-contrato NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brTable2 OPEN QUERY brTable2 FOR EACH ttparam-correios-contrato NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brTable2 ttparam-correios-contrato
&Scoped-define FIRST-TABLE-IN-QUERY-brTable2 ttparam-correios-contrato


/* Definitions for BROWSE brTable3                                      */
&Scoped-define FIELDS-IN-QUERY-brTable3 ~
ttparam-correios-un-post.cod-un-postagem ~
ttparam-correios-un-post.des-un-postagem ~
ttparam-correios-un-post.cod-estabel ttparam-correios-un-post.tp-servico ~
ttparam-correios-un-post.prefix-tp-servico ~
ttparam-correios-un-post.nr-contrato ttparam-correios-un-post.cod-admin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable3 
&Scoped-define QUERY-STRING-brTable3 FOR EACH ttparam-correios-un-post NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brTable3 OPEN QUERY brTable3 FOR EACH ttparam-correios-un-post NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brTable3 ttparam-correios-un-post
&Scoped-define FIRST-TABLE-IN-QUERY-brTable3 ttparam-correios-un-post


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brTable1}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brTable2}

/* Definitions for FRAME fPage3                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage3 ~
    ~{&OPEN-QUERY-brTable3}

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

DEFINE BUTTON btImplant3 
     LABEL "Implantar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      ttparam-correios-est-tp SCROLLING.

DEFINE QUERY brTable2 FOR 
      ttparam-correios-contrato SCROLLING.

DEFINE QUERY brTable3 FOR 
      ttparam-correios-un-post SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      ttparam-correios-est-tp.cod-estabel FORMAT "x(3)":U
      ttparam-correios-est-tp.tp-servico FORMAT "x(10)":U
      ttparam-correios-est-tp.prefix-tp-servico FORMAT "x(5)":U
      ttparam-correios-est-tp.nr-contrato FORMAT "x(20)":U
      ttparam-correios-est-tp.cod-admin FORMAT ">>>>>>>>>>>9":U
      ttparam-correios-est-tp.cod-un-postagem FORMAT "x(10)":U
      ttparam-correios-est-tp.des-un-postagem FORMAT "x(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.5
         FONT 2.

DEFINE BROWSE brTable2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable2 wZoom _STRUCTURED
  QUERY brTable2 NO-LOCK DISPLAY
      ttparam-correios-contrato.nr-contrato FORMAT "x(20)":U
      ttparam-correios-contrato.cod-estabel FORMAT "x(3)":U
      ttparam-correios-contrato.tp-servico FORMAT "x(10)":U
      ttparam-correios-contrato.prefix-tp-servico FORMAT "x(5)":U
      ttparam-correios-contrato.cod-un-postagem FORMAT "x(10)":U
      ttparam-correios-contrato.des-un-postagem FORMAT "x(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.67
         FONT 2.

DEFINE BROWSE brTable3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable3 wZoom _STRUCTURED
  QUERY brTable3 NO-LOCK DISPLAY
      ttparam-correios-un-post.cod-un-postagem FORMAT "x(10)":U
      ttparam-correios-un-post.des-un-postagem FORMAT "x(40)":U
      ttparam-correios-un-post.cod-estabel FORMAT "x(3)":U
      ttparam-correios-un-post.tp-servico FORMAT "x(10)":U
      ttparam-correios-un-post.prefix-tp-servico FORMAT "x(5)":U
      ttparam-correios-un-post.nr-contrato FORMAT "x(20)":U
      ttparam-correios-un-post.cod-admin FORMAT ">>>>>>>>>>>9":U
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
         SIZE 90 BY 16.98
         FONT 1.

DEFINE FRAME fPage1
     brTable1 AT ROW 3.5 COL 2
     btImplant1 AT ROW 13 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1.

DEFINE FRAME fPage3
     brTable3 AT ROW 2.33 COL 2
     btImplant3 AT ROW 13 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1.

DEFINE FRAME fPage2
     brTable2 AT ROW 2.33 COL 2
     btImplant2 AT ROW 13 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Zoom
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttparam-correios-contrato T "?" NO-UNDO mgesp param-correios
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
      END-FIELDS.
      TABLE: ttparam-correios-est-tp T "?" NO-UNDO mgesp param-correios
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
      END-FIELDS.
      TABLE: ttparam-correios-un-post T "?" NO-UNDO mgesp param-correios
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
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
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brTable1 1 fPage1 */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brTable2 1 fPage2 */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* BROWSE-TAB brTable3 1 fPage3 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.ttparam-correios-est-tp"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   = Temp-Tables.ttparam-correios-est-tp.cod-estabel
     _FldNameList[2]   = Temp-Tables.ttparam-correios-est-tp.tp-servico
     _FldNameList[3]   = Temp-Tables.ttparam-correios-est-tp.prefix-tp-servico
     _FldNameList[4]   = Temp-Tables.ttparam-correios-est-tp.nr-contrato
     _FldNameList[5]   = Temp-Tables.ttparam-correios-est-tp.cod-admin
     _FldNameList[6]   = Temp-Tables.ttparam-correios-est-tp.cod-un-postagem
     _FldNameList[7]   = Temp-Tables.ttparam-correios-est-tp.des-un-postagem
     _Query            is OPENED
*/  /* BROWSE brTable1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable2
/* Query rebuild information for BROWSE brTable2
     _TblList          = "Temp-Tables.ttparam-correios-contrato"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   = Temp-Tables.ttparam-correios-contrato.nr-contrato
     _FldNameList[2]   = Temp-Tables.ttparam-correios-contrato.cod-estabel
     _FldNameList[3]   = Temp-Tables.ttparam-correios-contrato.tp-servico
     _FldNameList[4]   = Temp-Tables.ttparam-correios-contrato.prefix-tp-servico
     _FldNameList[5]   = Temp-Tables.ttparam-correios-contrato.cod-un-postagem
     _FldNameList[6]   = Temp-Tables.ttparam-correios-contrato.des-un-postagem
     _Query            is OPENED
*/  /* BROWSE brTable2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable3
/* Query rebuild information for BROWSE brTable3
     _TblList          = "Temp-Tables.ttparam-correios-un-post"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   = Temp-Tables.ttparam-correios-un-post.cod-un-postagem
     _FldNameList[2]   = Temp-Tables.ttparam-correios-un-post.des-un-postagem
     _FldNameList[3]   = Temp-Tables.ttparam-correios-un-post.cod-estabel
     _FldNameList[4]   = Temp-Tables.ttparam-correios-un-post.tp-servico
     _FldNameList[5]   = Temp-Tables.ttparam-correios-un-post.prefix-tp-servico
     _FldNameList[6]   = Temp-Tables.ttparam-correios-un-post.nr-contrato
     _FldNameList[7]   = Temp-Tables.ttparam-correios-un-post.cod-admin
     _Query            is OPENED
*/  /* BROWSE brTable3 */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage3
/* Query rebuild information for FRAME fPage3
     _Query            is NOT OPENED
*/  /* FRAME fPage3 */
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
    {zoom/implant.i &ProgramImplant="esp/ftp/esftp076.w"
                    &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btImplant2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant2 wZoom
ON CHOOSE OF btImplant2 IN FRAME fPage2 /* Implantar */
DO:
    {zoom/implant.i &ProgramImplant="esp/ftp/esftp076.w"
                    &PageNumber="2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btImplant3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant3 wZoom
ON CHOOSE OF btImplant3 IN FRAME fPage3 /* Implantar */
DO:
    {zoom/implant.i &ProgramImplant="esp/ftp/esftp076.w"
                    &PageNumber="2"}
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
       {&hDBOTable1}:FILE-NAME <> "esbo/boes544.p":U THEN DO:
       
        {btb/btb008za.i1 esbo/boes544.p YES}
        {btb/btb008za.i2 esbo/boes544.p '' {&hDBOTable1}} 
    END.
    
    RUN setConstraintEstTpServ IN {&hDBOTable1} (INPUT "":U,
                                                 INPUT "ZZZ":U,
                                                 INPUT "":U,
                                                 INPUT "ZZZZZZZZZZ":U) NO-ERROR.
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable2}) OR
       {&hDBOTable2}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable2}:FILE-NAME <> "esbo/boes544.p":U THEN DO:
       
        {btb/btb008za.i1 esbo/boes544.p YES}
        {btb/btb008za.i2 esbo/boes544.p '' {&hDBOTable2}} 
    END.
    
    RUN setConstraintContrato IN {&hDBOTable2} (INPUT "":U,
                                                INPUT FILL("Z":U, 20)) NO-ERROR.

    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable3}) OR
       {&hDBOTable2}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable2}:FILE-NAME <> "esbo/boes544.p":U THEN DO:
       
        {btb/btb008za.i1 esbo/boes544.p YES}
        {btb/btb008za.i2 esbo/boes544.p '' {&hDBOTable3}} 
    END.
    
    RUN setConstraintUnPost IN {&hDBOTable3} (INPUT "":U,
                                              INPUT FILL("Z":U, 10)) NO-ERROR.
    
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
    
    {zoom/openqueries.i &Query="EstTpServ"
                        &PageNumber="1"}
    
    {zoom/openqueries.i &Query="Contrato"
                        &PageNumber="2"}
                        
    {zoom/openqueries.i &Query="UnPost"
                        &PageNumber="3"}
    
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
            WHEN "tp-servico":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.tp-servico).
            WHEN "prefix-tp-servico":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.prefix-tp-servico).
            WHEN "nr-contrato":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nr-contrato).
            WHEN "cod-admin":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-admin).
            WHEN "cod-un-postagem":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-un-postagem).
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
            WHEN "cod-estabel":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.cod-estabel).
            WHEN "tp-servico":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.tp-servico).
            WHEN "prefix-tp-servico":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.prefix-tp-servico).
            WHEN "nr-contrato":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.nr-contrato).
            WHEN "cod-admin":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.cod-admin).
            WHEN "cod-un-postagem":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.cod-un-postagem).
        END CASE.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFieldsPage3 wZoom 
PROCEDURE returnFieldsPage3 :
/*:T------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos da p gina 3
  Parameters:  recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE  INPUT PARAMETER pcField      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFieldValue AS CHARACTER NO-UNDO.
    
    IF AVAILABLE {&ttTable3} THEN DO:
        CASE pcField:
            WHEN "cod-estabel":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable3}.cod-estabel).
            WHEN "tp-servico":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable3}.tp-servico).
            WHEN "prefix-tp-servico":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable3}.prefix-tp-servico).
            WHEN "nr-contrato":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable3}.nr-contrato).
            WHEN "cod-admin":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable3}.cod-admin).
            WHEN "cod-un-postagem":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable3}.cod-un-postagem).
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
            RUN setConstraintEstTpServ IN {&hDBOTable1} (INPUT fnIniRangeCharPage(INPUT 1, INPUT 1),
                                                         INPUT fnEndRangeCharPage(INPUT 1, INPUT 1),
                                                         INPUT fnIniRangeCharPage(INPUT 1, INPUT 2),
                                                         INPUT fnEndRangeCharPage(INPUT 1, INPUT 2)).
        
        WHEN 2 THEN
            /*:T--- Seta Constraints para o DBO Table2 ---*/
            RUN setConstraintContrato IN {&hDBOTable2} (INPUT fnIniRangeCharPage(INPUT 2, INPUT 1),
                                                        INPUT fnEndRangeCharPage(INPUT 2, INPUT 1)).

        WHEN 3 THEN
            /*:T--- Seta Constraints para o DBO Table3 ---*/
            RUN setConstraintUnPost IN {&hDBOTable3} (INPUT fnIniRangeCharPage(INPUT 3, INPUT 1),
                                                      INPUT fnEndRangeCharPage(INPUT 3, INPUT 1)).
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

