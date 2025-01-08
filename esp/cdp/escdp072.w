&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
*/
&Scoped-define WINDOW-NAME w-livre


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-ext-natur-oper NO-UNDO LIKE ext-natur-oper
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-natur-oper NO-UNDO LIKE natur-oper
       field r-Rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-livre 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i escdp072 1.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-descTipoNatur LIKE natur-oper.denominacao NO-UNDO.
DEFINE VARIABLE v_num_row_a AS INTEGER NO-UNDO.

/* Global Variable Definitions ---                                      */
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-livre
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME brnat-oper

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-natur-oper tt-ext-natur-oper

/* Definitions for BROWSE brnat-oper                                    */
&Scoped-define FIELDS-IN-QUERY-brnat-oper tt-natur-oper.nat-operacao tt-natur-oper.denominacao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brnat-oper   
&Scoped-define SELF-NAME brnat-oper
&Scoped-define QUERY-STRING-brnat-oper FOR EACH tt-natur-oper NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brnat-oper OPEN QUERY {&SELF-NAME} FOR EACH tt-natur-oper NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brnat-oper tt-natur-oper
&Scoped-define FIRST-TABLE-IN-QUERY-brnat-oper tt-natur-oper


/* Definitions for BROWSE brNatur-Devol                                 */
&Scoped-define FIELDS-IN-QUERY-brNatur-Devol tt-ext-natur-oper.nat-operacao fnDescricao(tt-ext-natur-oper.nat-operacao) @ c-descTipoNatur   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brNatur-Devol   
&Scoped-define SELF-NAME brNatur-Devol
&Scoped-define QUERY-STRING-brNatur-Devol FOR EACH tt-ext-natur-oper NO-LOCK                            WHERE tt-ext-natur-oper.tipo = 1 /* Devolu‡Æo */ INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brNatur-Devol OPEN QUERY {&SELF-NAME} FOR EACH tt-ext-natur-oper NO-LOCK                            WHERE tt-ext-natur-oper.tipo = 1 /* Devolu‡Æo */ INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brNatur-Devol tt-ext-natur-oper
&Scoped-define FIRST-TABLE-IN-QUERY-brNatur-Devol tt-ext-natur-oper


/* Definitions for BROWSE brNatur-OEs                                   */
&Scoped-define FIELDS-IN-QUERY-brNatur-OEs tt-ext-natur-oper.nat-operacao fnDescricao(tt-ext-natur-oper.nat-operacao) @ c-descTipoNatur   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brNatur-OEs   
&Scoped-define SELF-NAME brNatur-OEs
&Scoped-define QUERY-STRING-brNatur-OEs FOR EACH tt-ext-natur-oper NO-LOCK                            WHERE tt-ext-natur-oper.tipo = 2 /* Outras Entradas */ INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brNatur-OEs OPEN QUERY {&SELF-NAME} FOR EACH tt-ext-natur-oper NO-LOCK                            WHERE tt-ext-natur-oper.tipo = 2 /* Outras Entradas */ INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brNatur-OEs tt-ext-natur-oper
&Scoped-define FIRST-TABLE-IN-QUERY-brNatur-OEs tt-ext-natur-oper


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-brnat-oper}~
    ~{&OPEN-QUERY-brNatur-Devol}~
    ~{&OPEN-QUERY-brNatur-OEs}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button IMAGE-6 IMAGE-7 RECT-10 brnat-oper ~
brNatur-Devol bt-add-all bt-add bt-del bt-del-all brNatur-OEs bt-add-all-2 ~
bt-add-2 bt-del-2 bt-del-all-2 bt-seleciona cnat-oper-ini cnat-oper-fim 
&Scoped-Define DISPLAYED-OBJECTS cnat-oper-ini cnat-oper-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescricao w-livre 
FUNCTION fnDescricao RETURNS CHARACTER
  ( c-codigo as CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-livre AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU mi-programa 
       MENU-ITEM mi-consultas   LABEL "Co&nsultas"     ACCELERATOR "CTRL-L"
              DISABLED
       MENU-ITEM mi-imprimir    LABEL "&Relat¢rios"    ACCELERATOR "CTRL-P"
              DISABLED
       RULE
       MENU-ITEM mi-sair        LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU m_Ajuda 
       MENU-ITEM mi-conteudo    LABEL "&Conteudo"     
       MENU-ITEM mi-sobre       LABEL "&Sobre..."     .

DEFINE MENU m-livre MENUBAR
       SUB-MENU  mi-programa    LABEL "ESCDP072"      
       SUB-MENU  m_Ajuda        LABEL "&Ajuda"        .


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_p-exihel AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-add 
     IMAGE-UP FILE "image/toolbar/im-nex.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-nex.bmp":U
     LABEL "" 
     SIZE 5 BY 1.5.

DEFINE BUTTON bt-add-2 
     IMAGE-UP FILE "image/toolbar/im-nex.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-nex.bmp":U
     LABEL "" 
     SIZE 5 BY 1.5.

DEFINE BUTTON bt-add-all 
     IMAGE-UP FILE "image/toolbar/im-las.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-las.bmp":U
     LABEL "" 
     SIZE 5 BY 1.5.

DEFINE BUTTON bt-add-all-2 
     IMAGE-UP FILE "image/toolbar/im-las.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-las.bmp":U
     LABEL "" 
     SIZE 5 BY 1.5.

DEFINE BUTTON bt-del 
     IMAGE-UP FILE "image/toolbar/im-pre.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-pre.bmp":U
     LABEL "" 
     SIZE 5 BY 1.5.

DEFINE BUTTON bt-del-2 
     IMAGE-UP FILE "image/toolbar/im-pre.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-pre.bmp":U
     LABEL "" 
     SIZE 5 BY 1.5.

DEFINE BUTTON bt-del-all 
     IMAGE-UP FILE "image/toolbar/im-fir.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-fir.bmp":U
     LABEL "" 
     SIZE 5 BY 1.5.

DEFINE BUTTON bt-del-all-2 
     IMAGE-UP FILE "image/toolbar/im-fir.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-fir.bmp":U
     LABEL "" 
     SIZE 5 BY 1.5.

DEFINE BUTTON bt-seleciona 
     IMAGE-UP FILE "image/toolbar/im-enter.bmp":U
     LABEL "" 
     SIZE 5 BY 1.42.

DEFINE VARIABLE cnat-oper-fim AS CHARACTER FORMAT "x(06)":U INITIAL "ZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE cnat-oper-ini AS CHARACTER FORMAT "x(6)":U 
     LABEL "Natureza" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-6
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46 BY 1.75.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 96 BY 1.46
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brnat-oper FOR 
      tt-natur-oper SCROLLING.

DEFINE QUERY brNatur-Devol FOR 
      tt-ext-natur-oper SCROLLING.

DEFINE QUERY brNatur-OEs FOR 
      tt-ext-natur-oper SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brnat-oper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brnat-oper w-livre _FREEFORM
  QUERY brnat-oper NO-LOCK DISPLAY
      tt-natur-oper.nat-operacao FORMAT "X(06)":U
      tt-natur-oper.denominacao FORMAT "x(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 46 BY 15.75
         FONT 1
         TITLE "Naturezas de Opera‡Æo" FIT-LAST-COLUMN TOOLTIP "Naturezas de Opera‡Æo".

DEFINE BROWSE brNatur-Devol
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brNatur-Devol w-livre _FREEFORM
  QUERY brNatur-Devol NO-LOCK DISPLAY
      tt-ext-natur-oper.nat-operacao FORMAT "X(06)":U
      fnDescricao(tt-ext-natur-oper.nat-operacao) @ c-descTipoNatur COLUMN-LABEL "Descri‡Æo" FORMAT "x(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 43 BY 7.25
         FONT 1
         TITLE "Naturezas ~"Devolu‡Æo~"" FIT-LAST-COLUMN TOOLTIP "Naturezas ~"Devolu‡Æo~"".

DEFINE BROWSE brNatur-OEs
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brNatur-OEs w-livre _FREEFORM
  QUERY brNatur-OEs NO-LOCK DISPLAY
      tt-ext-natur-oper.nat-operacao FORMAT "X(06)":U
      fnDescricao(tt-ext-natur-oper.nat-operacao) @ c-descTipoNatur COLUMN-LABEL "Descri‡Æo" FORMAT "x(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 43 BY 7.25
         FONT 1
         TITLE "Naturezas ~"Outras Entradas~"" FIT-LAST-COLUMN TOOLTIP "Naturezas ~"Outras Entradas~"".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     brnat-oper AT ROW 2.58 COL 1 WIDGET-ID 300
     brNatur-Devol AT ROW 2.58 COL 54 WIDGET-ID 200
     bt-add-all AT ROW 3 COL 48 WIDGET-ID 6
     bt-add AT ROW 4.58 COL 48 WIDGET-ID 2
     bt-del AT ROW 6.21 COL 48 WIDGET-ID 4
     bt-del-all AT ROW 7.79 COL 48 WIDGET-ID 8
     brNatur-OEs AT ROW 11.08 COL 54 WIDGET-ID 400
     bt-add-all-2 AT ROW 11.5 COL 48 WIDGET-ID 12
     bt-add-2 AT ROW 13.08 COL 48 WIDGET-ID 10
     bt-del-2 AT ROW 14.71 COL 48 WIDGET-ID 14
     bt-del-all-2 AT ROW 16.29 COL 48 WIDGET-ID 16
     bt-seleciona AT ROW 18.67 COL 41.43 WIDGET-ID 104
     cnat-oper-ini AT ROW 18.96 COL 15.86 COLON-ALIGNED HELP
          "Natureza de Opera‡Æo" WIDGET-ID 46
     cnat-oper-fim AT ROW 18.96 COL 30.86 COLON-ALIGNED HELP
          "Natureza de Opera‡Æo" NO-LABEL WIDGET-ID 48
     rt-button AT ROW 1 COL 1
     IMAGE-6 AT ROW 18.96 COL 26 WIDGET-ID 42
     IMAGE-7 AT ROW 18.96 COL 29.86 WIDGET-ID 44
     RECT-10 AT ROW 18.5 COL 1 WIDGET-ID 114
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 96.43 BY 19.38
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-livre
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-ext-natur-oper T "?" NO-UNDO tempHeronLB ext-natur-oper
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-natur-oper T "?" NO-UNDO mgcad natur-oper
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-livre ASSIGN
         HIDDEN             = YES
         TITLE              = "ESCDP072"
         HEIGHT             = 19.46
         WIDTH              = 96.43
         MAX-HEIGHT         = 23.96
         MAX-WIDTH          = 144.14
         VIRTUAL-HEIGHT     = 23.96
         VIRTUAL-WIDTH      = 144.14
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU m-livre:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-livre 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-livre.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-livre
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME L-To-R                                                    */
/* BROWSE-TAB brnat-oper RECT-10 f-cad */
/* BROWSE-TAB brNatur-Devol brnat-oper f-cad */
/* BROWSE-TAB brNatur-OEs bt-del-all f-cad */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
THEN w-livre:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brnat-oper
/* Query rebuild information for BROWSE brnat-oper
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-natur-oper NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brnat-oper */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brNatur-Devol
/* Query rebuild information for BROWSE brNatur-Devol
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ext-natur-oper NO-LOCK
                           WHERE tt-ext-natur-oper.tipo = 1 /* Devolu‡Æo */ INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brNatur-Devol */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brNatur-OEs
/* Query rebuild information for BROWSE brNatur-OEs
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ext-natur-oper NO-LOCK
                           WHERE tt-ext-natur-oper.tipo = 2 /* Outras Entradas */ INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brNatur-OEs */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON END-ERROR OF w-livre /* ESCDP072 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON WINDOW-CLOSE OF w-livre /* ESCDP072 */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-add w-livre
ON CHOOSE OF bt-add IN FRAME f-cad
DO:
    DO  v_num_row_a = 1 TO brnat-oper:num-selected-rows IN FRAME {&FRAME-NAME}:
        if  brnat-oper:fetch-selected-row(v_num_row_a) IN FRAME {&FRAME-NAME} then do:       
    
            IF  NOT CAN-FIND(FIRST ext-natur-oper
                             WHERE ext-natur-oper.nat-operacao = tt-natur-oper.nat-operacao
                             AND   ext-natur-oper.tipo = 1) THEN DO:
                CREATE ext-natur-oper.
                ASSIGN ext-natur-oper.nat-operacao          = tt-natur-oper.nat-operacao
                       ext-natur-oper.cod_usuar_ult_atualiz = v_cod_usuar_corren
                       ext-natur-oper.dat_ult_atualiz       = TODAY
                       ext-natur-oper.hra_ult_atualiz       = replace(STRING(TIME, "HH:MM:SS":U), ":", "")
                       ext-natur-oper.tipo                  = 1 /* Devolu‡Æo */.

                DELETE tt-natur-oper.

                CREATE tt-ext-natur-oper.
                BUFFER-COPY ext-natur-oper TO tt-ext-natur-oper.
            END. /* IF  NOT CAN-FIND(FIRST ext-natur-oper */
        END. /* if  brnat-oper:fetch-selected-row(v_num_row_a) ... */
    END. /* do  v_num_row_a = 1 to browse brnat-oper:num-selected-rows: ... */

    {&OPEN-QUERY-brnat-oper}
    {&OPEN-QUERY-brNatur-Devol}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-add-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-add-2 w-livre
ON CHOOSE OF bt-add-2 IN FRAME f-cad
DO:
    DO  v_num_row_a = 1 TO brnat-oper:num-selected-rows IN FRAME {&FRAME-NAME}:
        if  brnat-oper:fetch-selected-row(v_num_row_a) IN FRAME {&FRAME-NAME} then do:       
    
            IF  NOT CAN-FIND(FIRST ext-natur-oper
                             WHERE ext-natur-oper.nat-operacao = tt-natur-oper.nat-operacao
                             AND   ext-natur-oper.tipo = 2) THEN DO:
                CREATE ext-natur-oper.
                ASSIGN ext-natur-oper.nat-operacao           = tt-natur-oper.nat-operacao
                       ext-natur-oper.cod_usuar_ult_atualiz = v_cod_usuar_corren
                       ext-natur-oper.dat_ult_atualiz       = TODAY
                       ext-natur-oper.hra_ult_atualiz       = replace(STRING(TIME, "HH:MM:SS":U), ":", "")
                       ext-natur-oper.tipo                  = 2 /* Outras Entradas */.

                DELETE tt-natur-oper.

                CREATE tt-ext-natur-oper.
                BUFFER-COPY ext-natur-oper TO tt-ext-natur-oper.
            END. /* IF  NOT CAN-FIND(FIRST ext-natur-oper */
        END. /* if  brnat-oper:fetch-selected-row(v_num_row_a) ... */
    END. /* do  v_num_row_a = 1 to browse brnat-oper:num-selected-rows: ... */

    {&OPEN-QUERY-brnat-oper}
    {&OPEN-QUERY-brNatur-OEs}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-add-all
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-add-all w-livre
ON CHOOSE OF bt-add-all IN FRAME f-cad
DO:
    FOR EACH tt-natur-oper:
        CREATE ext-natur-oper.
        ASSIGN ext-natur-oper.nat-operacao          = tt-natur-oper.nat-operacao
               ext-natur-oper.cod_usuar_ult_atualiz = v_cod_usuar_corren
               ext-natur-oper.dat_ult_atualiz       = TODAY
               ext-natur-oper.hra_ult_atualiz       = replace(STRING(TIME, "HH:MM:SS":U), ":", "")
               ext-natur-oper.tipo                  = 1 /* Devolu‡Æo */.

        DELETE tt-natur-oper.

        CREATE tt-ext-natur-oper.
        BUFFER-COPY ext-natur-oper TO tt-ext-natur-oper.
    END. /* FOR EACH tt-natur-oper: */

    {&OPEN-QUERY-brnat-oper}
    {&OPEN-QUERY-brNatur-Devol}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-add-all-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-add-all-2 w-livre
ON CHOOSE OF bt-add-all-2 IN FRAME f-cad
DO:
    FOR EACH tt-natur-oper:
        CREATE ext-natur-oper.
        ASSIGN ext-natur-oper.nat-operacao          = tt-natur-oper.nat-operacao
               ext-natur-oper.cod_usuar_ult_atualiz = v_cod_usuar_corren
               ext-natur-oper.dat_ult_atualiz       = TODAY
               ext-natur-oper.hra_ult_atualiz       = replace(STRING(TIME, "HH:MM:SS":U), ":", "")
               ext-natur-oper.tipo                  = 2 /* Outras Entradas */ .

        DELETE tt-natur-oper.

        CREATE tt-ext-natur-oper.
        BUFFER-COPY ext-natur-oper TO tt-ext-natur-oper.
    END. /* FOR EACH tt-natur-oper: */

    {&OPEN-QUERY-brnat-oper}
    {&OPEN-QUERY-brNatur-OEs}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-del w-livre
ON CHOOSE OF bt-del IN FRAME f-cad
DO:
    DO  v_num_row_a = 1 TO brNatur-Devol:num-selected-rows IN FRAME {&FRAME-NAME}:
        if  brNatur-Devol:fetch-selected-row(v_num_row_a) IN FRAME {&FRAME-NAME} then do: 
            
            IF  AVAIL tt-ext-natur-oper THEN do:
                 
                FIND FIRST ext-natur-oper EXCLUSIVE-LOCK
                    WHERE  ext-natur-oper.nat-operacao = tt-ext-natur-oper.nat-operacao NO-ERROR.
                IF  AVAIL  ext-natur-oper 
                AND ext-natur-oper.tipo = 1 /* Devolu‡Æo */ THEN DELETE ext-natur-oper.

                DELETE tt-ext-natur-oper.
            END.

            {&OPEN-QUERY-brNatur-Devol}

            RUN pi-carregaTTsource.
            {&OPEN-QUERY-brnat-oper}
        
        END. /* if  brnat-oper ...*/
    END. /* DO  v_num_row_a ... */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-del-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-del-2 w-livre
ON CHOOSE OF bt-del-2 IN FRAME f-cad
DO:
    DO  v_num_row_a = 1 TO brNatur-OEs:num-selected-rows IN FRAME {&FRAME-NAME}:
        if  brNatur-OEs:fetch-selected-row(v_num_row_a) IN FRAME {&FRAME-NAME} then do: 
            
            IF  AVAIL tt-ext-natur-oper THEN do:
                 
                FIND FIRST ext-natur-oper EXCLUSIVE-LOCK
                    WHERE  ext-natur-oper.nat-operacao = tt-ext-natur-oper.nat-operacao NO-ERROR.
                IF  AVAIL  ext-natur-oper 
                AND ext-natur-oper.tipo = 2 /* Outras Entradas */ THEN DELETE ext-natur-oper.

                DELETE tt-ext-natur-oper.
            END.

            {&OPEN-QUERY-brNatur-OEs}

            RUN pi-carregaTTsource.
            {&OPEN-QUERY-brnat-oper}
        
        END. /* if  brnat-oper ...*/
    END. /* DO  v_num_row_a ... */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-del-all
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-del-all w-livre
ON CHOOSE OF bt-del-all IN FRAME f-cad
DO:
    FOR EACH tt-ext-natur-oper:
                 
        FIND FIRST ext-natur-oper EXCLUSIVE-LOCK
            WHERE  ext-natur-oper.nat-operacao = tt-ext-natur-oper.nat-operacao NO-ERROR.
        IF  AVAIL  ext-natur-oper 
        AND ext-natur-oper.tipo = 1 /* Devolu‡Æo */THEN DELETE ext-natur-oper.

        DELETE tt-ext-natur-oper.
    
    END. /* FOR EACH tt-ext-natur-oper: */

    {&OPEN-QUERY-brNatur-Devol}

    RUN pi-carregaTTsource.
    {&OPEN-QUERY-brnat-oper}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-del-all-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-del-all-2 w-livre
ON CHOOSE OF bt-del-all-2 IN FRAME f-cad
DO:
    FOR EACH tt-ext-natur-oper:
                 
        FIND FIRST ext-natur-oper EXCLUSIVE-LOCK
            WHERE  ext-natur-oper.nat-operacao = tt-ext-natur-oper.nat-operacao NO-ERROR.
        IF  AVAIL  ext-natur-oper 
        AND ext-natur-oper.tipo = 2 /* Outras Entradas */ THEN DELETE ext-natur-oper.

        DELETE tt-ext-natur-oper.
    
    END. /* FOR EACH tt-ext-natur-oper: */

    {&OPEN-QUERY-brNatur-OEs}

    RUN pi-carregaTTsource.
    {&OPEN-QUERY-brnat-oper}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-seleciona
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-seleciona w-livre
ON CHOOSE OF bt-seleciona IN FRAME f-cad
DO:
    IF  CAN-FIND(FIRST tt-natur-oper) THEN DO:
        ASSIGN INPUT FRAME {&FRAME-NAME} cnat-oper-ini cnat-oper-fim.
    
        OPEN QUERY brnat-oper FOR EACH tt-natur-oper
                                    WHERE tt-natur-oper.nat-operacao >= cnat-oper-ini
                                    AND   tt-natur-oper.nat-operacao <= cnat-oper-fim
                                    BY    tt-natur-oper.nat-operacao.

    END. /* IF  CAN-FIND(FIRST tt-natur-oper) THEN DO: */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-consultas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-consultas w-livre
ON CHOOSE OF MENU-ITEM mi-consultas /* Consultas */
DO:
  RUN pi-consulta IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-conteudo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-conteudo w-livre
ON CHOOSE OF MENU-ITEM mi-conteudo /* Conteudo */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  RUN pi-ajuda IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-imprimir w-livre
ON CHOOSE OF MENU-ITEM mi-imprimir /* Relat¢rios */
DO:
  RUN pi-imprimir IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-programa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-programa w-livre
ON MENU-DROP OF MENU mi-programa /* ESCDP072 */
DO:
  run pi-disable-menu.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sair w-livre
ON CHOOSE OF MENU-ITEM mi-sair /* Sair */
DO:
  RUN pi-sair IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-livre
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brnat-oper
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-livre 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-livre  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'panel/p-exihel.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-exihel ).
       RUN set-position IN h_p-exihel ( 1.17 , 80.43 ) NO-ERROR.
       /* Size in UIB:  ( 1.25 , 16.00 ) */

       /* Links to SmartPanel h_p-exihel. */
       RUN add-link IN adm-broker-hdl ( h_p-exihel , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-exihel ,
             brnat-oper:HANDLE IN FRAME f-cad , 'BEFORE':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-livre  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-livre  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
  THEN DELETE WIDGET w-livre.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-livre  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY cnat-oper-ini cnat-oper-fim 
      WITH FRAME f-cad IN WINDOW w-livre.
  ENABLE rt-button IMAGE-6 IMAGE-7 RECT-10 brnat-oper brNatur-Devol bt-add-all 
         bt-add bt-del bt-del-all brNatur-OEs bt-add-all-2 bt-add-2 bt-del-2 
         bt-del-all-2 bt-seleciona cnat-oper-ini cnat-oper-fim 
      WITH FRAME f-cad IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW w-livre.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-livre 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-livre 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-livre 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  run pi-before-initialize.

  {include/win-size.i}

  {utp/ut9000.i "escdp072" "1.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  RUN pi-carregaTTsource.
  RUN pi-carregaTTtarget.

  /* Code placed here will execute AFTER standard behavior.    */

  run pi-after-initialize.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carregaTTsource w-livre 
PROCEDURE pi-carregaTTsource :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
   
    EMPTY TEMP-TABLE tt-natur-oper NO-ERROR.

    FOR EACH natur-oper NO-LOCK:
        IF  NOT CAN-FIND(FIRST ext-natur-oper
                         WHERE ext-natur-oper.nat-operacao = natur-oper.nat-operacao) THEN DO:
            CREATE tt-natur-oper.
            BUFFER-COPY natur-oper TO tt-natur-oper NO-ERROR.
        END. /* IF  NOT CAN-FIND(FIRST tt-ext-natur-oper */
    END. /* FOR EACH natur-oper NO-LOCK: */

    {&OPEN-QUERY-brnat-oper}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carregaTTtarget w-livre 
PROCEDURE pi-carregaTTtarget :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-ext-natur-oper NO-ERROR.

    FOR EACH ext-natur-oper NO-LOCK:
        IF  NOT CAN-FIND(FIRST tt-ext-natur-oper
                         WHERE tt-ext-natur-oper.nat-operacao = ext-natur-oper.nat-operacao) THEN DO:
            CREATE tt-ext-natur-oper.
            BUFFER-COPY ext-natur-oper TO tt-ext-natur-oper.
        END.
    END.

    {&OPEN-QUERY-brNatur-Devol}
    {&OPEN-QUERY-brNatur-OEs}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-livre  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-ext-natur-oper"}
  {src/adm/template/snd-list.i "tt-natur-oper"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-livre 
PROCEDURE state-changed :
/*:T -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescricao w-livre 
FUNCTION fnDescricao RETURNS CHARACTER
  ( c-codigo as CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FIND FIRST natur-oper NO-LOCK
        WHERE  natur-oper.nat-operacao = c-codigo NO-ERROR.
    IF  AVAIL  natur-oper
    THEN RETURN natur-oper.denominacao.
    ELSE RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

