&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-juridico-andamentos NO-UNDO LIKE juridico-andamentos
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
{include/i-prgvrs.i z01es473 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           z01es473
&GLOBAL-DEFINE Version           2.04.00.001

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      Agenda

&GLOBAL-DEFINE Range             NO
&GLOBAL-DEFINE ttTable1          tt-juridico-andamentos
&GLOBAL-DEFINE hDBOTable1        h-boes473
&GLOBAL-DEFINE DBOTable1         tt-juridico-andamentos
&GLOBAL-DEFINE FieldsAnyKeyPage1 NO

&GLOBAL-DEFINE page1Browse       brTable1

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable1} AS HANDLE NO-UNDO.

&global-define VALUE-CHANGED1    yes

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
&Scoped-define INTERNAL-TABLES tt-juridico-andamentos juridico-acoes ~
juridico-processos

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 tt-juridico-andamentos.dt-prevista ~
tt-juridico-andamentos.hora tt-juridico-andamentos.processo ~
juridico-processos.autor tt-juridico-andamentos.cod-acao ~
juridico-acoes.descricao tt-juridico-andamentos.dt-efetiva 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH tt-juridico-andamentos NO-LOCK, ~
      FIRST juridico-acoes WHERE juridico-acoes.codigo = tt-juridico-andamentos.cod-acao NO-LOCK, ~
      FIRST juridico-processos WHERE juridico-processos.processo = tt-juridico-andamentos.processo NO-LOCK ~
    BY tt-juridico-andamentos.dt-prevista ~
       BY tt-juridico-andamentos.processo
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH tt-juridico-andamentos NO-LOCK, ~
      FIRST juridico-acoes WHERE juridico-acoes.codigo = tt-juridico-andamentos.cod-acao NO-LOCK, ~
      FIRST juridico-processos WHERE juridico-processos.processo = tt-juridico-andamentos.processo NO-LOCK ~
    BY tt-juridico-andamentos.dt-prevista ~
       BY tt-juridico-andamentos.processo.
&Scoped-define TABLES-IN-QUERY-brTable1 tt-juridico-andamentos ~
juridico-acoes juridico-processos
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 tt-juridico-andamentos
&Scoped-define SECOND-TABLE-IN-QUERY-brTable1 juridico-acoes
&Scoped-define THIRD-TABLE-IN-QUERY-brTable1 juridico-processos


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
     SIZE 98 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON btCheck 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON btImplant1 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE cb-acoes AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "A‡Æo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "teste",1
     DROP-DOWN-LIST
     SIZE 27.14 BY 1 NO-UNDO.

DEFINE VARIABLE fi-data-prev-fim AS DATE FORMAT "99/99/9999" INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 9.72 BY .88.

DEFINE VARIABLE fi-data-prev-ini AS DATE FORMAT "99/99/9999" INITIAL 01/01/08 
     LABEL "Data Prevista" 
     VIEW-AS FILL-IN 
     SIZE 9.72 BY .88.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      tt-juridico-andamentos, 
      juridico-acoes, 
      juridico-processos SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      tt-juridico-andamentos.dt-prevista COLUMN-LABEL "Dt.Prevista" FORMAT "99/99/9999":U
            WIDTH 11.14
      tt-juridico-andamentos.hora FORMAT "x(8)":U WIDTH 8.43
      tt-juridico-andamentos.processo FORMAT "x(30)":U WIDTH 20.43
      juridico-processos.autor FORMAT "x(60)":U WIDTH 24.43
      tt-juridico-andamentos.cod-acao COLUMN-LABEL "A‡Æo" FORMAT ">>>>>>9":U
            WIDTH 4.43
      juridico-acoes.descricao FORMAT "x(40)":U WIDTH 26.14
      tt-juridico-andamentos.dt-efetiva COLUMN-LABEL "Dt.Efetiva" FORMAT "99/99/9999":U
            WIDTH 10.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 89 BY 8.67
         FONT 2 ROW-HEIGHT-CHARS .55 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 17.96 COL 2
     btCancel AT ROW 17.96 COL 13
     btHelp AT ROW 17.96 COL 88.29
     rtToolBar AT ROW 17.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 98 BY 18.42
         FONT 1.

DEFINE FRAME fPage1
     btCheck AT ROW 1.17 COL 89.86 RIGHT-ALIGNED
     cb-acoes AT ROW 1.25 COL 9.86 COLON-ALIGNED WIDGET-ID 26
     fi-data-prev-ini AT ROW 1.25 COL 52.72 COLON-ALIGNED WIDGET-ID 16
     fi-data-prev-fim AT ROW 1.25 COL 72.86 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     brTable1 AT ROW 2.33 COL 2.29
     tt-juridico-andamentos.comentarios AT ROW 11.13 COL 2.29 NO-LABEL WIDGET-ID 24
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 89 BY 3
          BGCOLOR 15 
     btImplant1 AT ROW 14.17 COL 2.29
     IMAGE-1 AT ROW 1.25 COL 65 WIDGET-ID 18
     IMAGE-2 AT ROW 1.25 COL 71.57 WIDGET-ID 20
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.29
         SIZE 92.43 BY 14.71
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Zoom Template
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-juridico-andamentos T "?" NO-UNDO mgesp juridico-andamentos
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
         HEIGHT             = 18.42
         WIDTH              = 98
         MAX-HEIGHT         = 18.42
         MAX-WIDTH          = 98
         VIRTUAL-HEIGHT     = 18.42
         VIRTUAL-WIDTH      = 98
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
/* BROWSE-TAB brTable1 fi-data-prev-fim fPage1 */
/* SETTINGS FOR BUTTON btCheck IN FRAME fPage1
   ALIGN-R                                                              */
ASSIGN 
       tt-juridico-andamentos.comentarios:READ-ONLY IN FRAME fPage1        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.tt-juridico-andamentos,mgesp.juridico-acoes WHERE Temp-Tables.tt-juridico-andamentos ...,mgesp.juridico-processos WHERE Temp-Tables.tt-juridico-andamentos ..."
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST, FIRST"
     _OrdList          = "Temp-Tables.tt-juridico-andamentos.dt-prevista|yes,Temp-Tables.tt-juridico-andamentos.processo|yes"
     _JoinCode[2]      = "mgesp.juridico-acoes.codigo = Temp-Tables.tt-juridico-andamentos.cod-acao"
     _JoinCode[3]      = "mgesp.juridico-processos.processo = Temp-Tables.tt-juridico-andamentos.processo"
     _FldNameList[1]   > Temp-Tables.tt-juridico-andamentos.dt-prevista
"tt-juridico-andamentos.dt-prevista" "Dt.Prevista" ? "date" ? ? ? ? ? ? no ? no no "11.14" yes no no "U" "" ""
     _FldNameList[2]   > Temp-Tables.tt-juridico-andamentos.hora
"tt-juridico-andamentos.hora" ? ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" ""
     _FldNameList[3]   > Temp-Tables.tt-juridico-andamentos.processo
"tt-juridico-andamentos.processo" ? ? "character" ? ? ? ? ? ? no ? no no "20.43" yes no no "U" "" ""
     _FldNameList[4]   > mgesp.juridico-processos.autor
"juridico-processos.autor" ? ? "character" ? ? ? ? ? ? no ? no no "24.43" yes no no "U" "" ""
     _FldNameList[5]   > Temp-Tables.tt-juridico-andamentos.cod-acao
"tt-juridico-andamentos.cod-acao" "A‡Æo" ? "integer" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" ""
     _FldNameList[6]   > mgesp.juridico-acoes.descricao
"juridico-acoes.descricao" ? ? "character" ? ? ? ? ? ? no ? no no "26.14" yes no no "U" "" ""
     _FldNameList[7]   > Temp-Tables.tt-juridico-andamentos.dt-efetiva
"tt-juridico-andamentos.dt-efetiva" "Dt.Efetiva" ? "date" ? ? ? ? ? ? no ? no no "10.86" yes no no "U" "" ""
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
ON VALUE-CHANGED OF brTable1 IN FRAME fPage1
DO:
    IF AVAIL tt-juridico-andamentos THEN DO:
        ASSIGN tt-juridico-andamentos.comentarios:SCREEN-VALUE IN FRAME fPage1 = tt-juridico-andamentos.comentarios.
    END.
    ELSE DO:
        ASSIGN tt-juridico-andamentos.comentarios:SCREEN-VALUE IN FRAME fPage1 = "".
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
  ASSIGN INPUT FRAME fpage1 fi-data-prev-ini
         INPUT FRAME fpage1 fi-data-prev-fim
         INPUT FRAME fPage1 cb-acoes.

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
&Scoped-define SELF-NAME cb-acoes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-acoes wZoom
ON VALUE-CHANGED OF cb-acoes IN FRAME fPage1 /* A‡Æo */
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

    RUN pi-carrega-acoes.

    ASSIGN fi-data-prev-ini:SENSITIVE IN FRAME fPage1 = YES
           fi-data-prev-fim:SENSITIVE IN FRAME fPage1 = YES
           cb-acoes:SENSITIVE         IN FRAME fPage1 = YES
           btCheck:SENSITIVE IN FRAME fPage1          = YES
           tt-juridico-andamentos.comentarios:SENSITIVE IN FRAME fPage1 = YES
           cb-acoes:SCREEN-VALUE         IN FRAME fPage1 = "0"
           fi-data-prev-ini:SCREEN-VALUE IN FRAME fPage1 = STRING(TODAY,"99/99/9999")
           fi-data-prev-fim:SCREEN-VALUE IN FRAME fPage1 = STRING(TODAY + 5,"99/99/9999"). 

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
       {&hDBOTable1}:FILE-NAME <> "esbo/boes473.p":U THEN DO:
       
        {btb/btb008za.i1 esbo/boes473.p YES}
        {btb/btb008za.i2 esbo/boes473.p '' {&hDBOTable1}} 
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
    
    {zoom/OpenQueries.i &Query="Agenda"
                        &PageNumber="1"}
    
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-acoes wZoom 
PROCEDURE pi-carrega-acoes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN cb-acoes:LIST-ITEM-PAIRS IN FRAME fPage1 = ",0".

    FOR EACH juridico-acoes BY juridico-acoes.descricao:

        cb-acoes:add-last(juridico-acoes.descricao, juridico-acoes.codigo) IN FRAME fPage1 NO-ERROR.
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
            WHEN "processo":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.processo).
            WHEN "dt-prevista":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.dt-prevista).
            WHEN "cod-acao":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-acao).
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
            RUN setConstraintAgenda IN {&hDBOTable1} (INPUT fi-data-prev-ini,
                                                      INPUT fi-data-prev-fim,
                                                      INPUT cb-acoes).

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

