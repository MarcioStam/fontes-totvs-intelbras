&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-int-def-sigla-transp NO-UNDO LIKE int-def-sigla-transp
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
{include/i-prgvrs.i Z01ES905 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           Z01ES905
&GLOBAL-DEFINE Version           2.00.00.000

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      Transport.

&GLOBAL-DEFINE Range             NO

&GLOBAL-DEFINE FieldsRangePage1  /*mgesp.def-transportes.cod-trans,mgesp.def-transportes.cod-estabel,mgesp.def-transportes.cod-cliente,mgesp.def-transportes.cod-cidade,mgesp.def-transportes.cod-uf*/
&GLOBAL-DEFINE FieldsAnyKeyPage1 NO,NO,NO,NO,NO,NO,NO,NO,NO,NO

&GLOBAL-DEFINE ttTable1          tt-int-def-sigla-transp
&GLOBAL-DEFINE hDBOTable1        hDBODefTransp
&GLOBAL-DEFINE DBOTable1         int-def-sigla-transp

&GLOBAL-DEFINE page1Browse      brTable1

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
&Scoped-define INTERNAL-TABLES tt-int-def-sigla-transp

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 tt-int-def-sigla-transp.cod-transp ~
tt-int-def-sigla-transp.cod-estabel tt-int-def-sigla-transp.Estado ~
tt-int-def-sigla-transp.cidade tt-int-def-sigla-transp.cod-emitente ~
tt-int-def-sigla-transp.sigla-transp tt-int-def-sigla-transp.cep-inicial ~
tt-int-def-sigla-transp.cep-final 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH tt-int-def-sigla-transp NO-LOCK
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH tt-int-def-sigla-transp NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTable1 tt-int-def-sigla-transp
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 tt-int-def-sigla-transp


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

DEFINE VARIABLE fi-cep-final AS CHARACTER FORMAT "x(12)" INITIAL "99999999" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88.

DEFINE VARIABLE fi-cep-inicial AS CHARACTER FORMAT "x(12)" 
     LABEL "CEP Inicial" 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .88.

DEFINE VARIABLE fi-cidade-fim AS CHARACTER FORMAT "X(25)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 24 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cidade-ini AS CHARACTER FORMAT "x(25)" 
     LABEL "Cidade Destino" 
     VIEW-AS FILL-IN 
     SIZE 24 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-cliente-fim AS INTEGER FORMAT "999999999":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-cliente-ini AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Cliente Destino" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-estab-fim AS CHARACTER FORMAT "x(3)" INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-estab-ini AS CHARACTER FORMAT "x(3)" 
     LABEL "Estabelecimento Origem" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-trans-fim AS INTEGER FORMAT ">>,>>9" INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-trans-ini AS INTEGER FORMAT ">>,>>9" INITIAL 0 
     LABEL "Transportadora" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-uf-fim AS CHARACTER FORMAT "X(2)":U INITIAL "ZZ" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE fi-uf-ini AS CHARACTER FORMAT "x(2)" 
     LABEL "UF Destino" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-11
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-12
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-13
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-14
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-15
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-16
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-19
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-20
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-9
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      tt-int-def-sigla-transp SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      tt-int-def-sigla-transp.cod-transp FORMAT ">>>>>>>>9":U WIDTH 9.43
      tt-int-def-sigla-transp.cod-estabel COLUMN-LABEL "Estab" FORMAT "x(3)":U
            WIDTH 5
      tt-int-def-sigla-transp.Estado FORMAT "x(04)":U WIDTH 3
      tt-int-def-sigla-transp.cidade FORMAT "x(25)":U WIDTH 11.86
      tt-int-def-sigla-transp.cod-emitente FORMAT ">>>>>9":U WIDTH 9.72
      tt-int-def-sigla-transp.sigla-transp FORMAT "x(12)":U WIDTH 8.72
      tt-int-def-sigla-transp.cep-inicial FORMAT "x(12)":U WIDTH 11.43
      tt-int-def-sigla-transp.cep-final FORMAT "x(12)":U WIDTH 14.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 8.25
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 20.17 COL 2
     btCancel AT ROW 20.17 COL 13
     btHelp AT ROW 20.17 COL 80
     rtToolBar AT ROW 19.96 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 20.5
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     fi-cod-estab-ini AT ROW 1.21 COL 31 COLON-ALIGNED HELP
          "Estabelecimento Origem" WIDGET-ID 6
     fi-cod-estab-fim AT ROW 1.21 COL 45 COLON-ALIGNED HELP
          "Estabelecimento Origem" NO-LABEL WIDGET-ID 8
     fi-uf-ini AT ROW 2.21 COL 32 COLON-ALIGNED HELP
          "UF Destino" WIDGET-ID 18
     fi-uf-fim AT ROW 2.21 COL 45 COLON-ALIGNED NO-LABEL
     fi-cidade-ini AT ROW 3.21 COL 12 COLON-ALIGNED HELP
          "Cidade Destino"
     fi-cidade-fim AT ROW 3.21 COL 45 COLON-ALIGNED NO-LABEL
     fi-cod-cliente-ini AT ROW 4.21 COL 19 COLON-ALIGNED HELP
          "Cliente Destino" WIDGET-ID 10
     fi-cod-cliente-fim AT ROW 4.21 COL 45 COLON-ALIGNED NO-LABEL
     fi-cod-trans-ini AT ROW 5.21 COL 24.29 COLON-ALIGNED HELP
          "Transportadora" WIDGET-ID 44
     fi-cod-trans-fim AT ROW 5.21 COL 45 COLON-ALIGNED HELP
          "Transportadora" NO-LABEL WIDGET-ID 42
     btCheck AT ROW 6.17 COL 78.86 WIDGET-ID 20
     fi-cep-inicial AT ROW 6.21 COL 25.14 COLON-ALIGNED WIDGET-ID 52
     fi-cep-final AT ROW 6.21 COL 45 COLON-ALIGNED NO-LABEL WIDGET-ID 50
     brTable1 AT ROW 8 COL 2 WIDGET-ID 200
     btImplant1 AT ROW 16.67 COL 2
     IMAGE-9 AT ROW 4.21 COL 38.72 WIDGET-ID 24
     IMAGE-10 AT ROW 4.21 COL 43.29 WIDGET-ID 22
     IMAGE-11 AT ROW 1.21 COL 38.72 WIDGET-ID 28
     IMAGE-12 AT ROW 1.21 COL 43.29 WIDGET-ID 26
     IMAGE-13 AT ROW 2.21 COL 38.72 WIDGET-ID 32
     IMAGE-14 AT ROW 2.21 COL 43.29 WIDGET-ID 30
     IMAGE-15 AT ROW 3.21 COL 38.72 WIDGET-ID 36
     IMAGE-16 AT ROW 3.21 COL 43.29 WIDGET-ID 34
     IMAGE-19 AT ROW 5.21 COL 38.72 WIDGET-ID 46
     IMAGE-20 AT ROW 5.21 COL 43.29 WIDGET-ID 48
     IMAGE-1 AT ROW 6.21 COL 38.72 WIDGET-ID 54
     IMAGE-2 AT ROW 6.21 COL 43.29 WIDGET-ID 56
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.46
         SIZE 84.43 BY 16.79
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Zoom
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-int-def-sigla-transp T "?" NO-UNDO mgesp int-def-sigla-transp
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
         HEIGHT             = 20.5
         WIDTH              = 90
         MAX-HEIGHT         = 28.33
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28.33
         VIRTUAL-WIDTH      = 195.14
         MAX-BUTTON         = no
         RESIZE             = no
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
/* BROWSE-TAB brTable1 fi-cep-final fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.tt-int-def-sigla-transp"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.tt-int-def-sigla-transp.cod-transp
"cod-transp" ? ? "integer" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-int-def-sigla-transp.cod-estabel
"cod-estabel" "Estab" ? "character" ? ? ? ? ? ? no ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-int-def-sigla-transp.Estado
"Estado" ? ? "character" ? ? ? ? ? ? no ? no no "3" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-int-def-sigla-transp.cidade
"cidade" ? ? "character" ? ? ? ? ? ? no ? no no "11.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-int-def-sigla-transp.cod-emitente
"cod-emitente" ? ? "integer" ? ? ? ? ? ? no ? no no "9.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-int-def-sigla-transp.sigla-transp
"sigla-transp" ? "x(12)" "character" ? ? ? ? ? ? no ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-int-def-sigla-transp.cep-inicial
"cep-inicial" ? ? "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-int-def-sigla-transp.cep-final
"cep-final" ? ? "character" ? ? ? ? ? ? no ? no no "14.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
    DEF VAR wh-pesquisa AS HANDLE.

    ASSIGN INPUT FRAME fpage1
           fi-cod-trans-ini fi-cod-trans-fim fi-cod-estab-ini fi-cod-estab-fim fi-cod-cliente-ini fi-cod-cliente-fim fi-cidade-ini fi-cidade-fim fi-uf-ini fi-uf-fim fi-cep-inicial fi-cep-final.

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
/*     {zoom/implant.i &ProgramImplant="<ProgramName>" */
/*                     &PageNumber="1"}                */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wZoom 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DISP fi-cod-trans-ini
         fi-cod-trans-fim  
         fi-cod-estab-ini  
         fi-cod-estab-fim  
         fi-cod-cliente-ini
         fi-cod-cliente-fim
         fi-cidade-ini     
         fi-cidade-fim     
         fi-uf-ini         
         fi-uf-fim
         fi-cep-inicial
         fi-cep-final  
         btCheck
         WITH FRAME fPage1.

    ENABLE fi-cod-trans-ini
           fi-cod-trans-fim  
           fi-cod-estab-ini  
           fi-cod-estab-fim  
           fi-cod-cliente-ini
           fi-cod-cliente-fim
           fi-cidade-ini     
           fi-cidade-fim     
           fi-uf-ini         
           fi-uf-fim
           fi-cep-inicial
           fi-cep-final
           btCheck
           WITH FRAME fPage1.

    APPLY "entry" TO fi-cod-trans-ini IN FRAME fPage1.

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
       {&hDBOTable1}:FILE-NAME <> "esbo/boes920.p":U THEN DO:
       
        {btb/btb008za.i1 esbo/boes920.p YES}
        {btb/btb008za.i2 esbo/boes920.p '' {&hDBOTable1}} 
    END.
    
    RUN setConstraintZoom IN {&hDBOTable1} (INPUT 0,
                                            INPUT 0,
                                            INPUT "",
                                            INPUT "",
                                            INPUT "",
                                            INPUT "",
                                            INPUT "",
                                            INPUT "",
                                            INPUT "",
                                            INPUT "",
                                            INPUT 0,
                                            INPUT 0) NO-ERROR.
    
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
    
    {zoom/openqueries.i &Query="Zoom"
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
            WHEN "cod-trans":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-trans).
            WHEN "cod-estabel":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-estabel).
            WHEN "cod-cliente":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-emitente).
            WHEN "cod-uf":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.estado).
            WHEN "cod-cidade":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cidade).
            WHEN "cep-inicial" THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cep-inicial).
            WHEN "cep-final" THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cep-final).
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
            RUN setConstraintZoom IN {&hDBOTable1} (INPUT fi-cod-trans-ini,
                                                    INPUT fi-cod-trans-fim,
                                                    INPUT fi-cod-estab-ini,
                                                    INPUT fi-cod-estab-fim,
                                                    INPUT fi-cep-inicial,
                                                    INPUT fi-cep-final  ,
                                                    INPUT fi-uf-ini,
                                                    INPUT fi-uf-fim,
                                                    INPUT fi-cidade-ini,  
                                                    INPUT fi-cidade-fim,  
                                                    INPUT fi-cod-cliente-ini,
                                                    INPUT fi-cod-cliente-fim).
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

