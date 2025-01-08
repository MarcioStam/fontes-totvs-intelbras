&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenance


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttestrutura NO-UNDO LIKE estrutura
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttitem NO-UNDO LIKE item
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttmonta-estrutura NO-UNDO LIKE monta-estrutura
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESENP010 1.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESENP010
&GLOBAL-DEFINE Version        1.00.00.000

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   <Folder1 ,Folder 2 ,... , Folder8>

&GLOBAL-DEFINE First          YES
&GLOBAL-DEFINE Prev           YES
&GLOBAL-DEFINE Next           YES
&GLOBAL-DEFINE Last           YES
&GLOBAL-DEFINE GoTo           YES
&GLOBAL-DEFINE Search         YES

&GLOBAL-DEFINE Add            no
&GLOBAL-DEFINE Copy           no
&GLOBAL-DEFINE Update         no
&GLOBAL-DEFINE Delete         no
&GLOBAL-DEFINE Undo           no
&GLOBAL-DEFINE Cancel         no
&GLOBAL-DEFINE Save           no

&GLOBAL-DEFINE ttTable        ttitem
&GLOBAL-DEFINE hDBOTable      hboin172
&GLOBAL-DEFINE DBOTable       item

&GLOBAL-DEFINE ttTable2       ttestrutura
&GLOBAL-DEFINE hDBOTable2     hboin111
&GLOBAL-DEFINE DBOTable2      estrutura

&GLOBAL-DEFINE ttTable3       ttmonta-estrutura
&GLOBAL-DEFINE hDBOTable3     hboes128
&GLOBAL-DEFINE DBOTable3      monta-estrutura

&GLOBAL-DEFINE page0KeyFields ttitem.it-codigo
&GLOBAL-DEFINE page0Fields    ttitem.desc-item ttitem.it-codigo
&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTable2} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTable3} AS HANDLE NO-UNDO.
def var iRowsReturned as int no-undo.
def var hProgram as handle no-undo.    
    
def temp-table ttestrutura-aux like ttestrutura.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brEstrutura

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttestrutura ttmonta-estrutura

/* Definitions for BROWSE brEstrutura                                   */
&Scoped-define FIELDS-IN-QUERY-brEstrutura ttestrutura.es-codigo ~
fn-descricao() ttestrutura.quant-usada ttestrutura.data-termino 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brEstrutura 
&Scoped-define QUERY-STRING-brEstrutura FOR EACH ttestrutura ~
      WHERE ttestrutura.data-inicio  <= TODAY AND  ~
ttestrutura.data-termino >= TODAY NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brEstrutura OPEN QUERY brEstrutura FOR EACH ttestrutura ~
      WHERE ttestrutura.data-inicio  <= TODAY AND  ~
ttestrutura.data-termino >= TODAY NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brEstrutura ttestrutura
&Scoped-define FIRST-TABLE-IN-QUERY-brEstrutura ttestrutura


/* Definitions for BROWSE brPosicao                                     */
&Scoped-define FIELDS-IN-QUERY-brPosicao ttmonta-estrutura.montadora ~
ttmonta-estrutura.posicao 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brPosicao 
&Scoped-define QUERY-STRING-brPosicao FOR EACH ttmonta-estrutura NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brPosicao OPEN QUERY brPosicao FOR EACH ttmonta-estrutura NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brPosicao ttmonta-estrutura
&Scoped-define FIRST-TABLE-IN-QUERY-brPosicao ttmonta-estrutura


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brEstrutura}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttitem.it-codigo ttitem.desc-item ~
ttestrutura.local-montag 
&Scoped-define ENABLED-TABLES ttitem ttestrutura
&Scoped-define FIRST-ENABLED-TABLE ttitem
&Scoped-define SECOND-ENABLED-TABLE ttestrutura
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys rtKeys-2 btFirst btPrev ~
btNext btLast btGoTo btSearch btQueryJoins btReportsJoins btExit btHelp ~
brEstrutura brPosicao btAddSon1 btUpdateSon1 btDeleteSon1 
&Scoped-Define DISPLAYED-FIELDS ttitem.it-codigo ttitem.desc-item ~
ttestrutura.local-montag 
&Scoped-define DISPLAYED-TABLES ttitem ttestrutura
&Scoped-define FIRST-DISPLAYED-TABLE ttitem
&Scoped-define SECOND-DISPLAYED-TABLE ttestrutura


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-descricao wMaintenance 
FUNCTION fn-descricao RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&éltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V  Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btAddSon1 
     LABEL "Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON btDeleteSon1 
     LABEL "Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image\im-fir":U
     IMAGE-INSENSITIVE FILE "image\ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image\im-las":U
     IMAGE-INSENSITIVE FILE "image\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image\im-nex":U
     IMAGE-INSENSITIVE FILE "image\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image\im-pre":U
     IMAGE-INSENSITIVE FILE "image\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btUpdateSon1 
     LABEL "Alterar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 14.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brEstrutura FOR 
      ttestrutura SCROLLING.

DEFINE QUERY brPosicao FOR 
      ttmonta-estrutura SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brEstrutura
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brEstrutura wMaintenance _STRUCTURED
  QUERY brEstrutura NO-LOCK DISPLAY
      ttestrutura.es-codigo FORMAT "x(16)":U WIDTH 12
      fn-descricao() COLUMN-LABEL "Descri‡Æo" FORMAT "x(30)":U
            WIDTH 30
      ttestrutura.quant-usada COLUMN-LABEL "QTD" FORMAT ">>>9.99":U
      ttestrutura.data-termino FORMAT "99/99/9999":U WIDTH 10
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN NO-ROW-MARKERS SEPARATORS SIZE 63 BY 5.5
         FONT 1
         TITLE "Componentes".

DEFINE BROWSE brPosicao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brPosicao wMaintenance _STRUCTURED
  QUERY brPosicao NO-LOCK DISPLAY
      ttmonta-estrutura.montadora FORMAT ">>9":U
      ttmonta-estrutura.posicao FORMAT "x(68)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS NO-COLUMN-SCROLLING SEPARATORS SIZE 63 BY 5
         FONT 1
         TITLE "Posi‡äes de Montagem" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrˆncia"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrˆncia anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrˆncia"
     btLast AT ROW 1.13 COL 13.57 HELP
          "éltima ocorrˆncia"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V  Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     ttitem.it-codigo AT ROW 3.25 COL 5 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88 NO-TAB-STOP 
     ttitem.desc-item AT ROW 3.25 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 69.72 BY .88 NO-TAB-STOP 
     brEstrutura AT ROW 5.25 COL 17 WIDGET-ID 100
     ttestrutura.local-montag AT ROW 11 COL 15 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 64 BY .92
     brPosicao AT ROW 12.5 COL 17 WIDGET-ID 200
     btAddSon1 AT ROW 17.5 COL 17 WIDGET-ID 12
     btUpdateSon1 AT ROW 17.5 COL 27 WIDGET-ID 16
     btDeleteSon1 AT ROW 17.5 COL 37 WIDGET-ID 14
     rtToolBar AT ROW 1 COL 1
     rtKeys AT ROW 2.67 COL 1
     rtKeys-2 AT ROW 5 COL 1 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 18
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance Template
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttestrutura T "?" NO-UNDO mgcad estrutura
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttitem T "?" NO-UNDO mgcad item
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttmonta-estrutura T "?" NO-UNDO mgesp monta-estrutura
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenance ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 18
         WIDTH              = 90
         MAX-HEIGHT         = 28.21
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.21
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenance 
/* ************************* Included-Libraries *********************** */

{maintenance/maintenance.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenance
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB brEstrutura desc-item fpage0 */
/* BROWSE-TAB brPosicao local-montag fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brEstrutura
/* Query rebuild information for BROWSE brEstrutura
     _TblList          = "Temp-Tables.ttestrutura"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "ttestrutura.data-inicio  <= TODAY AND 
ttestrutura.data-termino >= TODAY"
     _FldNameList[1]   > Temp-Tables.ttestrutura.es-codigo
"ttestrutura.es-codigo" ? ? "character" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fn-descricao()" "Descri‡Æo" "x(30)" ? ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.ttestrutura.quant-usada
"ttestrutura.quant-usada" "QTD" ">>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.ttestrutura.data-termino
"ttestrutura.data-termino" ? ? "date" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE brEstrutura */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brPosicao
/* Query rebuild information for BROWSE brPosicao
     _TblList          = "Temp-Tables.ttmonta-estrutura"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   = Temp-Tables.ttmonta-estrutura.montadora
     _FldNameList[2]   = Temp-Tables.ttmonta-estrutura.posicao
     _Query            is NOT OPENED
*/  /* BROWSE brPosicao */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON END-ERROR OF wMaintenance
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON WINDOW-CLOSE OF wMaintenance
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brEstrutura
&Scoped-define SELF-NAME brEstrutura
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brEstrutura wMaintenance
ON VALUE-CHANGED OF brEstrutura IN FRAME fpage0 /* Componentes */
DO:
    if browse brEstrutura:num-selected-rows > 0 then do:
        browse brEstrutura:fetch-selected-row(1).
        disp ttestrutura.local-montag with frame {&FRAME-NAME}.
        
        run setConstraintByCodigo IN {&hDBOTable3} (input ttestrutura.it-codigo,
                                                    input ttestrutura.es-codigo).                               


        RUN openQueryStatic IN {&hDBOTable3} (INPUT "ByCodigo":U) NO-ERROR.
    
        RUN getBatchRecords IN {&hDBOTable3} (INPUT ?,
                                              INPUT ?,
                                              INPUT ?,
                                              OUTPUT iRowsReturned,
                                              OUTPUT TABLE ttmonta-estrutura).
                                              
        &scop BROWSE-NAME brPosicao                                          
                                              
        {&OPEN-QUERY-{&BROWSE-NAME}}        
        
        &undef BROWSE-NAME
                                              
        
    end.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAddSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAddSon1 wMaintenance
ON CHOOSE OF btAddSon1 IN FRAME fpage0 /* Incluir */
DO:
    
    /* if browse brPosicao:num-selected-rows = 1 then do: */
        
        /* browse brPosicao:fetch-selected-row(1). */
/*    */
        SESSION:SET-WAIT-STATE("GENERAL":U).
        
        run goToKey in {&hDBOTable2} (input ttestrutura.it-codigo,
                                      input ttestrutura.sequencia,
                                      input ttestrutura.es-codigo).
       
        
        run getRecord in {&hDBOTable2} (output table ttestrutura-aux).
        
       
        find first ttestrutura-aux no-error.        
        
        RUN esp/enp/esenp010a.w PERSISTENT SET hProgram (input ?,
                                                         INPUT ttestrutura-aux.r-rowid,
                                                         INPUT "ADD":U,
                                                         INPUT THIS-PROCEDURE,
                                                         INPUT 1,
                                                         INPUT ttestrutura.local-montag:SCREEN-VALUE IN FRAME fPage0).
                                                        
        IF VALID-HANDLE(hProgram) AND
           hProgram:TYPE = "PROCEDURE":U AND
           hProgram:FILE-NAME = "esp/enp/esenp010a.w":U THEN 
           RUN initializeInterface IN hProgram.
        
        SESSION:SET-WAIT-STATE("":U).
                                                        
    /* end.  */   
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDeleteSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDeleteSon1 wMaintenance
ON CHOOSE OF btDeleteSon1 IN FRAME fpage0 /* Eliminar */
DO:
          
        find monta-estrutura where monta-estrutura.it-codigo = ttmonta-estrutura.it-codigo and
                                   monta-estrutura.es-codigo = ttmonta-estrutura.es-codigo and
                                   monta-estrutura.montadora = ttmonta-estrutura.montadora and
                                   monta-estrutura.posicao   = ttmonta-estrutura.posicao no-error.
        if avail monta-estrutura then do: 
            delete monta-estrutura.
            delete ttmonta-estrutura.
        end.
           
        {&open-query-brPosicao}
  
       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMaintenance
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMaintenance
ON CHOOSE OF btFirst IN FRAME fpage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMaintenance
ON CHOOSE OF btGoTo IN FRAME fpage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenance
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMaintenance
ON CHOOSE OF btLast IN FRAME fpage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMaintenance
ON CHOOSE OF btNext IN FRAME fpage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMaintenance
ON CHOOSE OF btPrev IN FRAME fpage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMaintenance
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMaintenance
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMaintenance
ON CHOOSE OF btSearch IN FRAME fpage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="inzoom/z25in172.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdateSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdateSon1 wMaintenance
ON CHOOSE OF btUpdateSon1 IN FRAME fpage0 /* Alterar */
DO:
    if browse brPosicao:num-selected-rows = 1 then do:
        browse brPosicao:fetch-selected-row(1).
        
        SESSION:SET-WAIT-STATE("GENERAL":U).
        
        run goToKey in {&hDBOTable2} (input ttestrutura.it-codigo,
                                      input ttestrutura.sequencia,
                                      input ttestrutura.es-codigo).
        run getRecord in {&hDBOTable2} (output table ttestrutura-aux).
        
        find first ttestrutura-aux no-error.
        
        RUN esp/enp/esenp010a.w PERSISTENT SET hProgram (input ttmonta-estrutura.r-rowid,
                                                         INPUT ttestrutura-aux.r-rowid,
                                                         INPUT "UPDATE":U,
                                                         INPUT THIS-PROCEDURE,
                                                         INPUT 1,
                                                         INPUT ttestrutura.local-montag:SCREEN-VALUE IN FRAME fPage0).
                                                        
        IF VALID-HANDLE(hProgram) AND
           hProgram:TYPE = "PROCEDURE":U AND
           hProgram:FILE-NAME = "esp/enp/esenp010a.w":U THEN
           RUN initializeInterface IN hProgram.
        
        SESSION:SET-WAIT-STATE("":U).
                                                        
    end.    
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenance/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenance 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if valid-handle({&hDBOTable2}) then
        run Destroy in {&hDBOTable2}.
    if valid-handle({&hDBOTable3}) then
        run Destroy in {&hDBOTable3}.
    return "OK".    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenance 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    run setConstraintItCodigo in {&hDBOTable2} (input ttitem.it-codigo).
    
    RUN openQueryStatic IN {&hDBOTable2} (INPUT "ItCodigo":U) NO-ERROR.

    RUN getBatchRecords IN {&hDBOTable2} (INPUT ?,
                                          INPUT ?,
                                          INPUT ?,
                                          OUTPUT iRowsReturned,
                                          OUTPUT TABLE ttestrutura).
                                          
    &scop BROWSE-NAME brEstrutura                                          
                                          
    {&OPEN-QUERY-{&BROWSE-NAME}}        
    
    &undef BROWSE-NAME
    
    apply "VALUE-CHANGED":U to brEstrutura in frame {&FRAME-NAME}.    
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenance 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    enable brEstrutura brPosicao btAddSon1 btDeleteSon1 btUpdateSon1 with frame {&FRAME-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDBOSonHandle wMaintenance 
PROCEDURE getDBOSonHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.
    def output param pbohandle as handle no-undo.
    
    assign pbohandle = {&hDBOTable3}.
    
    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getParentRecord wMaintenance 
PROCEDURE getParentRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR ttestrutura-aux.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V  Para
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUTTON btGoToCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btGoToOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE c-it-codigo LIKE {&ttTable}.it-codigo NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        c-it-codigo  AT ROW 1.21 COL 22.72 COLON-ALIGNED
        btGoToOK          AT ROW 2.63 COL 2.14
        btGoToCancel      AT ROW 2.63 COL 13
        rtGoToButton      AT ROW 2.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para Item" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_Item"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN c-it-codigo.
        
        RUN goToKey IN {&hDBOTable} (INPUT c-it-codigo ).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Item":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE c-it-codigo btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenance 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "inbo/boin172.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin172.p YES}
        {btb/btb008za.i2 inbo/boin172.p '' {&hDBOTable}}
    END.
    
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE({&hDBOTable2}) OR
       {&hDBOTable2}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable2}:FILE-NAME <> "inbo/boin111.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin111.p YES}
        {btb/btb008za.i2 inbo/boin111.p '' {&hDBOTable2}}
    END.
    
    IF NOT VALID-HANDLE({&hDBOTable3}) OR
       {&hDBOTable3}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable3}:FILE-NAME <> "esbo/boes128.p":U THEN DO:
        {btb/btb008za.i1 esbo/boes128.p YES}
        {btb/btb008za.i2 esbo/boes128.p '' {&hDBOTable3}}
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionRecordSon wMaintenance 
PROCEDURE repositionRecordSon :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pRowid      AS ROWID   NO-UNDO.
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.
    
    /*--- Seta vari vel iRepositionPageNumber com o nœmero da pagina na qual
          o browse filho ser  reposicionado ---*/
    /*--- Seta vari vel rRepositionSon com o rowid a ser reposicionado no browse filho ---*/
   
        run setConstraintByCodigo IN {&hDBOTable3} (input ttestrutura.it-codigo,
                                                    input ttestrutura.es-codigo).                               


        RUN openQueryStatic IN {&hDBOTable3} (INPUT "ByCodigo":U) NO-ERROR.
    
        RUN getBatchRecords IN {&hDBOTable3} (INPUT ?,
                                              INPUT ?,
                                              INPUT ?,
                                              OUTPUT iRowsReturned,
                                              OUTPUT TABLE ttmonta-estrutura).

    /*--- Atualiza browse filho mas somente da p gina RepositionPageNumber ---*/
    
      
    
     &scop BROWSE-NAME brPosicao                                          
                                              
        {&OPEN-QUERY-{&BROWSE-NAME}}        
        
        &undef BROWSE-NAME

   
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-descricao wMaintenance 
FUNCTION fn-descricao RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    find first item no-lock
        where item.it-codigo = ttestrutura.es-codigo no-error.
        
  RETURN item.desc-item.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

