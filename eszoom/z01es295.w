&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttVolume-nf NO-UNDO LIKE volume-nf
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
{include/i-prgvrs.i z01es295 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           z01es295
&GLOBAL-DEFINE Version           2.00.00.000

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      Volumes

&GLOBAL-DEFINE Range             NO

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

&GLOBAL-DEFINE ttTable1          ttVolume-nf
&GLOBAL-DEFINE hDBOTable1        hDBOVolume-nf
&GLOBAL-DEFINE DBOTable1         volume-nf

&GLOBAL-DEFINE ttTable2          
&GLOBAL-DEFINE hDBOTable2        
&GLOBAL-DEFINE DBOTable2         

&GLOBAL-DEFINE page1Browse       brTable1
&GLOBAL-DEFINE page2Browse      

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable1} AS HANDLE NO-UNDO.
/*DEFINE VARIABLE {&hDBOTable2} AS HANDLE NO-UNDO.*/

DEFINE VARIABLE cEstabIni   AS CHARACTER    NO-UNDO INITIAL ''.
/*
DEFINE VARIABLE cEstabEnd   AS CHARACTER    NO-UNDO INITIAL 'ZZZ'.
*/
DEFINE VARIABLE cSerieIni   AS CHARACTER    NO-UNDO INITIAL ''.
/*
DEFINE VARIABLE cSerieEnd   AS CHARACTER    NO-UNDO INITIAL 'Z'.
*/
DEFINE VARIABLE cNFIni      AS CHARACTER    NO-UNDO INITIAL ''.
/*
DEFINE VARIABLE cNFEnd      AS CHARACTER    NO-UNDO INITIAL 'ZZZZZZZZZZZZ'.
*/
DEFINE VARIABLE lFixaNotaFiscal AS LOGICAL      NO-UNDO INITIAL NO.

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
&Scoped-define INTERNAL-TABLES ttVolume-nf

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 ttVolume-nf.cod-estabel ~
ttVolume-nf.serie ttVolume-nf.nr-nota-fis ttVolume-nf.nr-volume ~
ttVolume-nf.it-codigo ttVolume-nf.qtde ttVolume-nf.varios-itens 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH ttVolume-nf NO-LOCK
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH ttVolume-nf NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTable1 ttVolume-nf
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 ttVolume-nf


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

DEFINE BUTTON btImplant1 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "Button 1" 
     SIZE 4 BY 1.

DEFINE VARIABLE cCod-estabel-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE cIt-codigo-end AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE cIt-codigo-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE cNr-nota-fis-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Nota Fiscal" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE cSerie-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "S‚rie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE iNr-volume-end AS INTEGER FORMAT ">>>,>>9":U INITIAL 999999 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE iNr-volume-ini AS INTEGER FORMAT ">>>,>>9":U INITIAL 0 
     LABEL "Volume" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      ttVolume-nf SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      ttVolume-nf.cod-estabel FORMAT "x(3)":U
      ttVolume-nf.serie FORMAT "x(3)":U
      ttVolume-nf.nr-nota-fis FORMAT "X(16)":U
      ttVolume-nf.nr-volume FORMAT ">>,>>9":U
      ttVolume-nf.it-codigo FORMAT "x(16)":U
      ttVolume-nf.qtde FORMAT ">>>>,>>9":U
      ttVolume-nf.varios-itens FORMAT "Sim/Nao":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 6.67
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
     cCod-estabel-ini AT ROW 1.17 COL 22.43 COLON-ALIGNED
     cSerie-ini AT ROW 2.17 COL 22.43 COLON-ALIGNED
     cNr-nota-fis-ini AT ROW 3.17 COL 22.43 COLON-ALIGNED
     iNr-volume-ini AT ROW 4.17 COL 22.43 COLON-ALIGNED
     iNr-volume-end AT ROW 4.17 COL 48.72 COLON-ALIGNED NO-LABEL
     cIt-codigo-ini AT ROW 5.17 COL 22.43 COLON-ALIGNED
     cIt-codigo-end AT ROW 5.17 COL 48.72 COLON-ALIGNED NO-LABEL
     btSearch AT ROW 5.17 COL 73
     brTable1 AT ROW 6.33 COL 2
     btImplant1 AT ROW 13 COL 2
     IMAGE-10 AT ROW 5.17 COL 46.72
     IMAGE-7 AT ROW 4.17 COL 40.43
     IMAGE-8 AT ROW 4.17 COL 46.72
     IMAGE-9 AT ROW 5.17 COL 40.43
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
      TABLE: ttVolume-nf T "?" NO-UNDO mgesp volume-nf
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
/* BROWSE-TAB brTable1 btSearch fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.ttVolume-nf"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.ttVolume-nf.cod-estabel
     _FldNameList[2]   = Temp-Tables.ttVolume-nf.serie
     _FldNameList[3]   = Temp-Tables.ttVolume-nf.nr-nota-fis
     _FldNameList[4]   = Temp-Tables.ttVolume-nf.nr-volume
     _FldNameList[5]   = Temp-Tables.ttVolume-nf.it-codigo
     _FldNameList[6]   = Temp-Tables.ttVolume-nf.qtde
     _FldNameList[7]   = Temp-Tables.ttVolume-nf.varios-itens
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
    {zoom/Implant.i &ProgramImplant="esp/ftp/esftp008.w" &PageNumber="1"}
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
&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wZoom
ON CHOOSE OF btSearch IN FRAME fPage1 /* Button 1 */
DO:

    ASSIGN INPUT FRAME fpage1
           cCod-estabel-ini 
           cSerie-ini       
           cNr-nota-fis-ini 
           iNr-volume-ini   iNr-volume-end
           cIt-codigo-ini   cIt-codigo-end.

    RUN setConstraints IN THIS-PROCEDURE (INPUT 1).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brTable1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wZoom 


/* ***************************  Main Block  *************************** */

/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{Zoom/MainBlock.i}

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

    DISPLAY
        cCod-estabel-ini        
        cSerie-ini
        cNr-nota-fis-ini
        iNr-volume-ini
        iNr-volume-end
        cIt-codigo-ini
        cIt-codigo-end
       WITH FRAME fPage1.

    IF NOT lFixaNotaFiscal THEN
        ENABLE
            cCod-estabel-ini
            cSerie-ini
            cNr-nota-fis-ini
           WITH FRAME fPage1.

    ENABLE
        iNr-volume-ini
        iNr-volume-end
        cIt-codigo-ini
        cIt-codigo-end
        btSearch
       WITH FRAME fPage1.

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
       {&hDBOTable1}:FILE-NAME <> "esbo/boes295.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes295.p YES}
        {btb/btb008za.i2 esbo/boes295.p '' {&hDBOTable1}} 
    END.


    RUN setConstraintRangeVolume IN {&hDBOTable1} (INPUT "", /*INPUT "ZZZ",*/
                                                   INPUT "", /*INPUT "ZZZ",*/
                                                   INPUT "", /*INPUT "ZZZZZZZZZZZZZZZZ",*/
                                                   INPUT 0,  INPUT  99999,
                                                   INPUT "", INPUT "ZZZZZZZZZZZZZZZZ").



/*
    RUN setConstraintRangeVolume IN {&hDBOTable1} (cCod-estabel-ini, cCod-estabel-end,
                                                   cSerie-ini,       cSerie-end,
                                                   cNr-nota-fis-ini, cNr-nota-fis-end,
                                                   iNr-volume-ini,   iNr-volume-end,
                                                   cIt-codigo-ini,   cIt-codigo-end).
*/                                                   


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


    {zoom/OpenQueries.i &Query="RangeVolume" &PageNumber="1"}
    /*{zoom/OpenQueries.i &Query="<QueryName>" &PageNumber="2"}*/

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRecebeNotaFiscal wZoom 
PROCEDURE piRecebeNotaFiscal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pCod-estabel LIKE volume-nf.Cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pSerie       LIKE volume-nf.Serie       NO-UNDO.
    DEFINE INPUT PARAMETER pNr-nota-fis LIKE volume-nf.Nr-nota-fis NO-UNDO.

    ASSIGN cCod-estabel-ini = pCod-estabel
           cSerie-ini       = pSerie
           cNr-nota-fis-ini = pNr-nota-fis.

    ASSIGN lFixaNotaFiscal = YES.

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
            WHEN "cod-estabel":U THEN ASSIGN pcFieldValue = STRING({&ttTable1}.cod-estabel).
            WHEN "serie":U       THEN ASSIGN pcFieldValue = STRING({&ttTable1}.serie).
            WHEN "nr-nota-fis":U THEN ASSIGN pcFieldValue = STRING({&ttTable1}.nr-nota-fis).
            WHEN "nr-volume":U   THEN ASSIGN pcFieldValue = STRING({&ttTable1}.nr-volume).
            WHEN "it-codigo":U   THEN ASSIGN pcFieldValue = STRING({&ttTable1}.it-codigo).
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

            RUN setConstraintRangeVolume IN {&hDBOTable1} (INPUT INPUT FRAME fPage1 cCod-estabel-ini,
                                                           INPUT INPUT FRAME fPage1 cSerie-ini,
                                                           INPUT INPUT FRAME fPage1 cNr-nota-fis-ini,
                                                           INPUT INPUT FRAME fPage1 iNr-volume-ini,
                                                           INPUT INPUT FRAME fPage1 iNr-volume-end,
                                                           INPUT INPUT FRAME fPage1 cIt-codigo-ini,
                                                           INPUT INPUT FRAME fPage1 cIt-codigo-end).


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

