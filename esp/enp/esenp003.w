&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
*/
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i XX9999 9.99.99.999}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESENP003
&GLOBAL-DEFINE Version        1
&GLOBAL-DEFINE VersionLayout  1

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Parƒmetro,Digita‡Æo,ImpressÆo

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          NO
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          YES
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE RTF            NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page3Widgets   
&GLOBAL-DEFINE page4Widgets   l-rodape c-endereco c-html-contato c-html-fornec i-fabric l-html i-lingua
&GLOBAL-DEFINE page5Widgets   brDigita ~
                              btSelec ~
                              btAdd ~
                              btUpdate ~
                              btDelete ~
                              btSave ~
                              btOpen
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution
&GLOBAL-DEFINE page7Widgets   
&GLOBAL-DEFINE page8Widgets   

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo
&GLOBAL-DEFINE page7Text      
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields    
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile
&GLOBAL-DEFINE page7Fields    
&GLOBAL-DEFINE page8Fields    

/* Parameters Definitions ---                                           */

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    FIELD l-rodape         AS LOG 
    FIELD i-fabric         AS INTEGER
    FIELD l-imp-obsoleto   AS LOG
    FIELD c-endereco       AS CHAR FORMAT "x(60)"
    FIELD c-html-contato   AS CHAR FORMAT "x(60)"
    FIELD c-html-fornec    AS CHAR FORMAT "x(60)"
    FIELD l-html           AS LOG
    FIELD i-lingua         AS INTEGER. 

define temp-table tt-digita no-undo
    field it-codigo    like item.it-codigo
    field cod-emitente like emitente.cod-emitente
    index id it-codigo.

define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-rtf              as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.

def stream s-imp.

DEFINE VARIABLE c-fm-codigo-fim AS CHARACTER FORMAT "x(8)" INITIAL "ZZZZZZZZ".
DEFINE VARIABLE c-fm-codigo-ini AS CHARACTER FORMAT "x(8)".
DEFINE VARIABLE c-it-codigo-est AS CHARACTER FORMAT "x(16)".
DEFINE VARIABLE c-it-codigo-fim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ".
DEFINE VARIABLE c-it-codigo-ini AS CHARACTER FORMAT "x(16)".
DEFINE VARIABLE l-imp-obsoleto  AS LOGICAL INITIAL NO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brDigita

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-digita

/* Definitions for BROWSE brDigita                                      */
&Scoped-define FIELDS-IN-QUERY-brDigita tt-digita.it-codigo tt-digita.cod-emitente   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDigita tt-digita.it-codigo tt-digita.cod-emitente   
&Scoped-define ENABLED-TABLES-IN-QUERY-brDigita tt-digita
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brDigita tt-digita
&Scoped-define SELF-NAME brDigita
&Scoped-define QUERY-STRING-brDigita FOR EACH tt-digita
&Scoped-define OPEN-QUERY-brDigita OPEN QUERY brDigita FOR EACH tt-digita.
&Scoped-define TABLES-IN-QUERY-brDigita tt-digita
&Scoped-define FIRST-TABLE-IN-QUERY-brDigita tt-digita


/* Definitions for FRAME fPage5                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage5 ~
    ~{&OPEN-QUERY-brDigita}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btOK btCancel btHelp2 rtToolBar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wReport AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "Executar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE c-endereco AS CHARACTER FORMAT "X(40)":U 
     LABEL "E-mail" 
     VIEW-AS FILL-IN 
     SIZE 37 BY .88 NO-UNDO.

DEFINE VARIABLE c-html-contato AS CHARACTER FORMAT "X(40)":U 
     LABEL "Contato" 
     VIEW-AS FILL-IN 
     SIZE 37 BY .88 NO-UNDO.

DEFINE VARIABLE c-html-fornec AS CHARACTER FORMAT "X(40)":U 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 37 BY .88 NO-UNDO.

DEFINE VARIABLE i-fabric AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Imprime C¢digo/Nome do Fabricante", 1,
"Imprime C¢digo do Fabricante", 2
     SIZE 30 BY 4 NO-UNDO.

DEFINE VARIABLE i-lingua AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Portuguˆs", 1,
"Inglˆs", 2
     SIZE 29 BY 4 NO-UNDO.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 49 BY 3.5.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 34 BY 5.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 49 BY 6.25.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 34 BY 4.75.

DEFINE VARIABLE l-html AS LOGICAL INITIAL no 
     LABEL "Gera HTML" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.72 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE l-rodape AS LOGICAL INITIAL no 
     LABEL "Imprime Rodap‚" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.72 BY .88
     FONT 1 NO-UNDO.

DEFINE BUTTON btAdd 
     LABEL "Inserir" 
     SIZE 14 BY 1
     FONT 1.

DEFINE BUTTON btDelete 
     LABEL "Retirar" 
     SIZE 14 BY 1
     FONT 1.

DEFINE BUTTON btOpen 
     LABEL "Recuperar" 
     SIZE 14 BY 1
     FONT 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 14 BY 1
     FONT 1.

DEFINE BUTTON btSelec 
     LABEL "Sele‡Æo" 
     SIZE 14 BY 1
     FONT 1.

DEFINE BUTTON btUpdate 
     LABEL "Alterar" 
     SIZE 14 BY 1
     FONT 1.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btModel 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE cModel AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.14 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-modelo AS CHARACTER FORMAT "X(256)":U INITIAL "Modelo" 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execu‡Æo" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsDestiny AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 44 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsExecution AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.72 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 1.71.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 1.71.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brDigita FOR 
      tt-digita SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brDigita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDigita wReport _FREEFORM
  QUERY brDigita DISPLAY
      tt-digita.it-codigo
tt-digita.cod-emitente
ENABLE
tt-digita.it-codigo
tt-digita.cod-emitente
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 82 BY 9
         BGCOLOR 15 FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage4
     i-lingua AT ROW 6.67 COL 53 NO-LABEL
     l-rodape AT ROW 2.5 COL 15
     i-fabric AT ROW 1.5 COL 53 NO-LABEL
     l-html AT ROW 5.75 COL 12
     c-html-fornec AT ROW 6.75 COL 10 COLON-ALIGNED
     c-html-contato AT ROW 7.75 COL 10 COLON-ALIGNED
     c-endereco AT ROW 8.75 COL 10 COLON-ALIGNED
     RECT-14 AT ROW 1 COL 1
     RECT-15 AT ROW 1 COL 51
     RECT-16 AT ROW 4.75 COL 1
     RECT-17 AT ROW 6.25 COL 51
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1.

DEFINE FRAME fPage5
     brDigita AT ROW 1 COL 1
     btSelec AT ROW 10 COL 1
     btAdd AT ROW 10 COL 15
     btUpdate AT ROW 10 COL 29
     btDelete AT ROW 10 COL 43
     btSave AT ROW 10 COL 57
     btOpen AT ROW 10 COL 71
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.29 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     btConfigImpr AT ROW 3.5 COL 43 HELP
          "Configura‡Æo da impressora"
     btFile AT ROW 3.5 COL 43 HELP
          "Escolha do nome do arquivo"
     cFile AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     cModel AT ROW 5.75 COL 3 HELP
          "Nome do arquivo de modelo" NO-LABEL
     btModel AT ROW 5.75 COL 43 HELP
          "Escolha o arquivo de modelo"
     rsExecution AT ROW 8 COL 2.86 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modelo AT ROW 5 COL 2 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 7.25 COL 1.14 COLON-ALIGNED NO-LABEL
     RECT-13 AT ROW 5.29 COL 2
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 7.54 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wReport ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 114.29
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wReport 
/* ************************* Included-Libraries *********************** */

{Report\Report.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wReport
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage5:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage4
   Custom                                                               */
/* SETTINGS FOR FRAME fPage5
                                                                        */
/* BROWSE-TAB brDigita 1 fPage5 */
/* SETTINGS FOR FRAME fPage6
                                                                        */
ASSIGN 
       btModel:HIDDEN IN FRAME fPage6           = TRUE.

ASSIGN 
       cModel:HIDDEN IN FRAME fPage6           = TRUE.

ASSIGN 
       RECT-13:HIDDEN IN FRAME fPage6           = TRUE.

ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-modelo:HIDDEN IN FRAME fPage6           = TRUE
       text-modelo:PRIVATE-DATA IN FRAME fPage6     = 
                "Modelo".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execu‡Æo".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDigita
/* Query rebuild information for BROWSE brDigita
     _START_FREEFORM
OPEN QUERY brDigita FOR EACH tt-digita.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brDigita */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage6
/* Query rebuild information for FRAME fPage6
     _Query            is NOT OPENED
*/  /* FRAME fPage6 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON END-ERROR OF wReport
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON WINDOW-CLOSE OF wReport
DO:
  /* This event will close the window and terminate the procedure.  */
  {report/logfin.i}  
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brDigita
&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME brDigita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON DEL OF brDigita IN FRAME fPage5
DO:
   apply 'choose' to btDelete in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON END-ERROR OF brDigita IN FRAME fPage5
ANYWHERE 
DO:
    if  brDigita:new-row in frame fPage5 then do:
        if  avail tt-digita then
            delete tt-digita.
        if  brDigita:delete-current-row() in frame fPage5 then. 
    end.                                                               
    else do:
        get current brDigita.
        display tt-digita.it-codigo
                tt-digita.cod-emitente with browse brDigita. 
    end.
    return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ENTER OF brDigita IN FRAME fPage5
ANYWHERE
DO:
  apply 'tab' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON INS OF brDigita IN FRAME fPage5
DO:
   apply 'choose' to btAdd in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON OFF-END OF brDigita IN FRAME fPage5
DO:
   apply 'entry' to btAdd in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON OFF-HOME OF brDigita IN FRAME fPage5
DO:
  apply 'entry' to btOpen in frame fPage5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ROW-LEAVE OF brDigita IN FRAME fPage5
DO:
    /*:T  aqui que a grava‡Æo da linha da temp-table ‚ efetivada.
       Por‚m as valida‡äes dos registros devem ser feitas na procedure pi-executar,
       no local indicado pelo coment rio */
    
    if brDigita:NEW-ROW in frame fPage5 then 
    do transaction on error undo, return no-apply:
        create tt-digita.
        assign input browse brDigita tt-digita.it-codigo
               input browse brDigita tt-digita.cod-emitente.

        brDigita:CREATE-RESULT-LIST-ENTRY() in frame fPage5.
    end.
    else do transaction on error undo, return no-apply:
        if avail tt-digita then
            assign input browse brDigita tt-digita.it-codigo
                   input browse brDigita tt-digita.cod-emitente.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wReport
ON CHOOSE OF btAdd IN FRAME fPage5 /* Inserir */
DO:
    assign btUpdate:SENSITIVE in frame fPage5 = yes
           btDelete:SENSITIVE in frame fPage5 = yes
           btSave:SENSITIVE   in frame fPage5 = yes.
    
    if num-results("brDigita":U) > 0 then
        brDigita:INSERT-ROW("after":U) in frame fPage5.
    else do transaction:
        create tt-digita.
        
        open query brDigita for each tt-digita.
        
        apply "entry":U to tt-digita.it-codigo in browse brDigita. 
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wReport
ON CHOOSE OF btCancel IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btConfigImpr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfigImpr wReport
ON CHOOSE OF btConfigImpr IN FRAME fPage6
DO:
   {report/rpimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wReport
ON CHOOSE OF btDelete IN FRAME fPage5 /* Retirar */
DO:
    if  brDigita:num-selected-rows > 0 then do on error undo, return no-apply:
        get current brDigita.
        delete tt-digita.
        if  brDigita:delete-current-row() in frame fPage5 then.
    end.
    
    if num-results("brDigita":U) = 0 then
        assign btUpdate:SENSITIVE in frame fPage5 = no
               btDelete:SENSITIVE in frame fPage5 = no
               btSave:SENSITIVE   in frame fPage5 = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFile wReport
ON CHOOSE OF btFile IN FRAME fPage6
DO:
    {report/rparq.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wReport
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btModel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btModel wReport
ON CHOOSE OF btModel IN FRAME fPage6
DO:
    def var cFile as char no-undo.
    def var l-ok  as logical no-undo.

    assign cModel = replace(input frame {&frame-name} cModel, "/", "\").
    SYSTEM-DIALOG GET-FILE cFile
       FILTERS "*.rtf" "*.rtf",
               "*.*" "*.*"
       DEFAULT-EXTENSION "rtf"
       INITIAL-DIR "modelos" 
       MUST-EXIST
       USE-FILENAME
       UPDATE l-ok.
    if  l-ok = yes then
        assign cModel:screen-value in frame {&frame-name}  = replace(cFile, "\", "/"). 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wReport
ON CHOOSE OF btOK IN FRAME fpage0 /* Executar */
DO:
   do  on error undo, return no-apply:
       run piExecute.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btOpen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOpen wReport
ON CHOOSE OF btOpen IN FRAME fPage5 /* Recuperar */
DO:
    {report/rprcd.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wReport
ON CHOOSE OF btSave IN FRAME fPage5 /* Salvar */
DO:
   {report/rpsvd.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSelec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSelec wReport
ON CHOOSE OF btSelec IN FRAME fPage5 /* Sele‡Æo */
DO:

    DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
         LABEL "Fechar" 
         SIZE 10 BY 1
         BGCOLOR 8 .
    
    DEFINE BUTTON Btn_OK AUTO-GO 
         LABEL "OK" 
         SIZE 10 BY 1
         BGCOLOR 8 .
    
    DEFINE VARIABLE fi-fm-codigo-fim AS CHARACTER FORMAT "x(8)" INITIAL "ZZZZZZZZ" 
         VIEW-AS FILL-IN 
         SIZE 12.14 BY .88.
    
    DEFINE VARIABLE fi-fm-codigo-ini AS CHARACTER FORMAT "x(8)" 
         LABEL "Fam¡lia":R9 
         VIEW-AS FILL-IN 
         SIZE 12.14 BY .88.
    
    DEFINE VARIABLE fi-it-codigo-est AS CHARACTER FORMAT "x(16)" 
         LABEL "Item Estrutura" 
         VIEW-AS FILL-IN 
         SIZE 17.14 BY .88.
    
    DEFINE VARIABLE fi-it-codigo-fim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
         VIEW-AS FILL-IN 
         SIZE 17.14 BY .88.
    
    DEFINE VARIABLE fi-it-codigo-ini AS CHARACTER FORMAT "x(16)" 
         LABEL "Item":R5 
         VIEW-AS FILL-IN 
         SIZE 17.14 BY .88.
    
    DEFINE IMAGE IMAGE-3
         FILENAME "image/im-fir.bmp":U
         SIZE 3 BY 1.
    
    DEFINE IMAGE IMAGE-4
         FILENAME "image/im-fir.bmp":U
         SIZE 3 BY 1.
    
    DEFINE IMAGE IMAGE-5
         FILENAME "image/im-las.bmp":U
         SIZE 3 BY 1.
    
    DEFINE IMAGE IMAGE-6
         FILENAME "image/im-las.bmp":U
         SIZE 3 BY 1.
    
    DEFINE RECTANGLE RECT-14
         EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
         SIZE 64.14 BY 4.67.
    
    DEFINE RECTANGLE rtToolBar
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 64.14 BY 1.42
         BGCOLOR 7 .
    
    DEFINE VARIABLE fi-imp-obsoleto AS LOGICAL INITIAL no 
         LABEL "Imprime Item Obsoleto" 
         VIEW-AS TOGGLE-BOX
         SIZE 18 BY .83 NO-UNDO.
    
    
    /* ************************  Frame Definitions  *********************** */
    
    DEFINE FRAME fSelec
         fi-it-codigo-ini AT ROW 1.46 COL 11 COLON-ALIGNED HELP
              "C¢digo do Item"
         fi-it-codigo-fim AT ROW 1.46 COL 40.14 COLON-ALIGNED HELP
              "C¢digo do Item" NO-LABEL
         fi-fm-codigo-ini AT ROW 2.46 COL 11 COLON-ALIGNED HELP
              "Fam¡lia de material a que pertence o item"
         fi-fm-codigo-fim AT ROW 2.46 COL 40.14 COLON-ALIGNED HELP
              "Fam¡lia de material a que pertence o item" NO-LABEL
         fi-it-codigo-est AT ROW 3.46 COL 11 COLON-ALIGNED HELP
              "C¢digo do Item"
         fi-imp-obsoleto AT ROW 4.5 COL 13
         Btn_OK AT ROW 6.25 COL 2
         Btn_Cancel AT ROW 6.25 COL 12
         IMAGE-3 AT ROW 1.46 COL 30
         IMAGE-4 AT ROW 2.46 COL 30
         IMAGE-5 AT ROW 1.46 COL 39
         IMAGE-6 AT ROW 2.46 COL 39
         RECT-14 AT ROW 1.08 COL 1
         rtToolBar AT ROW 6 COL 1
         SPACE(0.00) SKIP(0.03)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
             SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE FONT 1 TITLE "Sele‡Æo"
             DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.

    ASSIGN fi-it-codigo-ini = c-it-codigo-ini
           fi-it-codigo-fim = c-it-codigo-fim
           fi-fm-codigo-ini = c-fm-codigo-ini
           fi-fm-codigo-fim = c-fm-codigo-fim
           fi-it-codigo-est = c-it-codigo-est
           fi-imp-obsoleto  = l-imp-obsoleto.
    
    DISPLAY fi-it-codigo-ini fi-it-codigo-fim fi-fm-codigo-ini fi-fm-codigo-fim 
            fi-it-codigo-est fi-imp-obsoleto 
            WITH FRAME fSelec.
    ENABLE fi-it-codigo-ini fi-it-codigo-fim fi-fm-codigo-ini fi-fm-codigo-fim 
           fi-it-codigo-est fi-imp-obsoleto Btn_OK Btn_Cancel IMAGE-3 IMAGE-4 
           IMAGE-5 IMAGE-6 RECT-14 rtToolBar 
           WITH FRAME fSelec.

    ON 'CHOOSE':U OF Btn_OK IN FRAME fSelec DO:
        
        ASSIGN c-it-codigo-est = INPUT FRAME fSelec fi-it-codigo-est
               c-it-codigo-ini = INPUT FRAME fSelec fi-it-codigo-ini
               c-it-codigo-fim = INPUT FRAME fSelec fi-it-codigo-fim
               c-fm-codigo-ini = INPUT FRAME fSelec fi-fm-codigo-ini
               c-fm-codigo-fim = INPUT FRAME fSelec fi-fm-codigo-fim
               l-imp-obsoleto  = INPUT FRAME fSelec fi-imp-obsoleto.

        IF c-it-codigo-est <> "" then do:
           for each estrutura no-lock 
               where estrutura.it-codigo     = c-it-codigo-est
                 and estrutura.data-inicio  <= today
                 and estrutura.data-termino  > today
                 and estrutura.es-codigo    >= c-it-codigo-ini
                 and estrutura.es-codigo    <= c-it-codigo-fim,
                 first item no-lock where item.it-codigo = estrutura.it-codigo:
               
               if item.it-codigo= "3991695" then next. /* frete interno */
               if not l-imp-obsoleto 
               and item.cod-obsoleto > 1 then next.
               if not l-imp-obsoleto 
               and item.cod-obsoleto > 1 then next.
    
               find tt-digita
                    where tt-digita.it-codigo    = estrutura.es-codigo
                      and tt-digita.cod-emitente = 0 no-error.
               if not avail tt-digita then do:       
                   create tt-digita.
                   assign tt-digita.it-codigo    = estrutura.es-codigo
                          tt-digita.cod-emitente = 0.
               end.
               run pi-estrutura (INPUT estrutura.es-codigo).
           end.
        END.
        else
           for each item no-lock
              where item.fm-codigo >= c-fm-codigo-ini
                and item.fm-codigo <= c-fm-codigo-fim
                and item.it-codigo >= c-it-codigo-ini
                and item.it-codigo <= c-it-codigo-fim:
                if item.it-codigo= "3991695" then next. /* frete interno */
                if not l-imp-obsoleto 
                and item.cod-obsoleto > 1 then next.
                    create tt-digita.
                    assign tt-digita.it-codigo   = item.it-codigo
                           tt-digita.cod-emitent = 0.
           end.

        open query brDigita for each tt-digita.
    END.

    WAIT-FOR "GO" OF FRAME fSelec.

    /*
    assign btUpdate:SENSITIVE in frame fPage5 = yes
           btDelete:SENSITIVE in frame fPage5 = yes
           btSave:SENSITIVE   in frame fPage5 = yes.
    
    if num-results("brDigita":U) > 0 then
        brDigita:INSERT-ROW("after":U) in frame fPage5.
    else do transaction:
        create tt-digita.
        
        open query brDigita for each tt-digita.
        
        apply "entry":U to tt-digita.ordem in browse brDigita. 
    end.
    
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wReport
ON CHOOSE OF btUpdate IN FRAME fPage5 /* Alterar */
DO:
   apply 'entry' to tt-digita.it-codigo in browse brDigita. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME rsDestiny
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDestiny wReport
ON VALUE-CHANGED OF rsDestiny IN FRAME fPage6
DO:
do  with frame fPage6:
    case self:screen-value:
        when "1":U then do:
            assign cFile:sensitive       = no
                   cFile:visible         = yes
                   btFile:visible        = no
                   btConfigImpr:visible  = yes.
        end.
        when "2":U then do:
            assign cFile:sensitive       = yes
                   cFile:visible         = yes
                   btFile:visible        = yes
                   btConfigImpr:visible  = no.
        end.
        when "3":U then do:
            assign cFile:visible         = no
                   cFile:sensitive       = no
                   btFile:visible        = no
                   btConfigImpr:visible  = no.
        end.
        when "4":U then do:
            assign cFile:sensitive       = no
                   cFile:visible         = yes
                   btFile:visible        = no
                   btConfigImpr:visible  = yes
                   text-modelo:VISIBLE   = YES
                   rect-13:VISIBLE       = YES
                   btModel:VISIBLE       = yes.
        end.
    end case.
end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsExecution
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsExecution wReport
ON VALUE-CHANGED OF rsExecution IN FRAME fPage6
DO:
   {report/rprse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{report/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-estrutura wReport 
PROCEDURE pi-estrutura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER p-it-codigo  LIKE item.it-codigo.

    FOR EACH estrutura no-lock 
        WHERE estrutura.it-codigo     = p-it-codigo
          AND estrutura.data-inicio  <= today
          AND estrutura.data-termino  > today
          AND estrutura.es-codigo    >= c-it-codigo-ini
          AND estrutura.es-codigo    <= c-it-codigo-fim,
        FIRST ITEM NO-LOCK 
        WHERE item.it-codigo = estrutura.it-codigo:
        IF ITEM.it-codigo= "3991695" THEN NEXT. /* frete interno */
        IF NOT l-imp-obsoleto 
        AND item.cod-obsoleto > 1 THEN NEXT.
        IF NOT l-imp-obsoleto 
        AND ITEM.cod-obsoleto > 1 THEN NEXT.
             FIND tt-digita
                  WHERE tt-digita.it-codigo = estrutura.es-codigo
                    AND tt-digita.cod-emitente = 0 NO-ERROR.
             IF NOT AVAIL tt-digita THEN DO:       
                 CREATE tt-digita.
                 ASSIGN tt-digita.it-codigo = estrutura.es-codigo
                        tt-digita.cod-emitent = 0.
             END.
           
        RUN pi-estrutura (INPUT estrutura.es-codigo).
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wReport 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

define var r-tt-digita as rowid no-undo.

&IF DEFINED(PGIMP) <> 0 AND "{&PGIMP}":U = "YES":U &THEN
/*:T** Relatorio ***/
do on error undo, return error on stop  undo, return error:
    {report/rpexa.i}

    /*29/12/2004 - tech1007 - Teste alterado para validar o arquivo informado quando for RTF*/
    if ( input frame fPage6 rsDestiny = 2 or
         input frame fPage6 rsDestiny = 4 ) and
         input frame fPage6 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage6 cFile).
        
        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show":U, input 73, input "":U).
            apply "ENTRY":U to cFile in frame fPage6.
            return error.
        end.
    end.
    
    /*29/12/2004 - tech1007 - Teste criado para validar o modelo informado quando for RTF*/
    IF input frame fPage6 cModel = "" AND
       input frame fPage6 rsDestiny = 4 THEN DO:
        run utp/ut-msgs.p (input "show":U, input 73, input "":U).
        /*30/12/2004 - tech1007 - Evento removido pois causa problemas no WebEnabler*/
        /*apply "CHOOSE":U to btModel in frame fPage6.*/
        return error.
    END.

    /*:T Coloque aqui as valida‡äes da p gina de Digita‡Æo, lembrando que elas devem
       apresentar uma mensagem de erro cadastrada, posicionar nesta p gina e colocar
       o focus no campo com problemas */
    /*browse brDigita:SET-REPOSITIONED-ROW (browse brDigita:DOWN, "ALWAYS":U).*/
    
    for each tt-digita no-lock:
        assign r-tt-digita = rowid(tt-digita).
        
        /*:T Valida‡Æo de duplicidade de registro na temp-table tt-digita */
        find first b-tt-digita 
            where b-tt-digita.it-codigo    = tt-digita.it-codigo
            AND   b-tt-digita.cod-emitente = tt-digita.cod-emitente
              and rowid(b-tt-digita) <> rowid(tt-digita) 
            no-lock no-error.
        if  avail b-tt-digita then do:
            reposition brDigita to rowid rowid(b-tt-digita).
            
            run utp/ut-msgs.p (input "SHOW":U, input 108, input "":U).
            apply "ENTRY":U to tt-digita.it-codigo in browse brDigita.
            
            return error.
        end.
        
        /*:T As demais valida‡äes devem ser feitas aqui */
        FIND FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = tt-digita.it-codigo NO-ERROR.
        IF NOT AVAIL ITEM THEN DO:
            assign browse brDigita:CURRENT-COLUMN = tt-digita.it-codigo:HANDLE in browse brDigita.
            
            reposition brDigita to rowid r-tt-digita.
           
            run utp/ut-msgs.p (input "SHOW":U, input 2, input "Item":U).
            apply "ENTRY":U to tt-digita.it-codigo in browse brDigita.
            
            return error.
        END.
        
        FIND FIRST emitente NO-LOCK
            WHERE emitente.cod-emitente = tt-digita.cod-emitente NO-ERROR.
        IF NOT AVAIL emitente THEN DO:
            assign browse brDigita:CURRENT-COLUMN = tt-digita.cod-emitente:HANDLE in browse brDigita.
            
            reposition brDigita to rowid r-tt-digita.
           
            run utp/ut-msgs.p (input "SHOW":U, input 2, input "Fornecedor":U).
            apply "ENTRY":U to tt-digita.cod-emitente in browse brDigita.
            
            return error.
        END.
        
        IF tt-digita.cod-emitente <> 0 THEN DO:
            FIND FIRST item-fornec NO-LOCK
                WHERE item-fornec.it-codigo    = tt-digita.it-codigo
                AND   item-fornec.cod-emitente = tt-digita.cod-emitente NO-ERROR.
            IF NOT AVAIL item-fornec THEN DO:
                assign browse brDigita:CURRENT-COLUMN = tt-digita.it-codigo:HANDLE in browse brDigita.

                reposition brDigita to rowid r-tt-digita.

                run utp/ut-msgs.p (input "SHOW":U, input 2, input "Rela‡Æo Item x Fornecedor":U).
                apply "ENTRY":U to tt-digita.it-codigo in browse brDigita.

                return error.
            END.
        END.
    END.

    /*:T Coloque aqui as valida‡äes das outras p ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p gina com 
       problemas e colocar o focus no campo com problemas */
    
    /*:T Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
       para o programa RP.P */
    
    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame fPage6 rsDestiny
           tt-param.data-exec       = today
           tt-param.hora-exec       = TIME
           tt-param.l-rodape        = INPUT FRAME fPage4 l-rodape
           tt-param.i-fabric        = INPUT FRAME fPage4 i-fabric
           tt-param.l-imp-obsoleto  = l-imp-obsoleto
           tt-param.c-endereco      = INPUT FRAME fPage4 c-endereco
           tt-param.c-html-contato  = INPUT FRAME fPage4 c-html-contato
           tt-param.c-html-fornec   = INPUT FRAME fPage4 c-html-fornec
           tt-param.l-html          = INPUT FRAME fPage4 l-html
           tt-param.i-lingua        = INPUT FRAME fPage4 i-lingua. 
    
    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "":U.
    else if  tt-param.destino = 2 OR tt-param.destino = 4 
        then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
    /*:T Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */
    
    
    
    /*:T Executar do programa RP.P que ir  criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i esp/enp/esenp003rp.p}
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
end.
&ELSE
/*:T** Importacao/Exportacao ***/
do  on error undo, return error
    on stop  undo, return error:     

    {report/rpexa.i}

    if  input frame fPage7 rsDestiny = 2 and
        input frame fPage7 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage7 cDestinyFile).
        if  return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "SHOW":U,
                               input 73,
                               input "":U).
            apply "ENTRY":U to cDestinyFile in frame fPage7.                   
            return error.
        end.
    end.
    
    assign file-info:file-name = input frame fPage4 cInputFile.
    if  file-info:pathname = ? and
        input frame fPage7 rsExecution = 1 then do:
        run utp/ut-msgs.p (input "SHOW":U,
                           input 326,
                           input cInputFile).                               
        apply "ENTRY":U to cInputFile in frame fPage4.                
        return error.
    end. 
            
    /*:T Coloque aqui as valida‡äes das outras p ginas, lembrando que elas
       devem apresentar uma mensagem de erro cadastrada, posicionar na p gina 
       com problemas e colocar o focus no campo com problemas             */    
         
    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame fPage7 rsDestiny
           tt-param.todos           = input frame fPage7 rsAll
           tt-param.arq-entrada     = input frame fPage4 cInputFile
           tt-param.data-exec       = today
           tt-param.hora-exec       = time.

    if  tt-param.destino = 1 then
        assign tt-param.arq-destino = "":U.
    else
    if  tt-param.destino = 2 THEN
        assign tt-param.arq-destino = input frame fPage7 cDestinyFile.
    else
        assign tt-param.arq-destino = session:temp-directory + c-programa-mg97 + ".tmp":U.

    /*:T Coloque aqui a l¢gica de grava‡Æo dos parƒmtros e sele‡Æo na temp-table
       tt-param */ 

    {report/imexb.i}

    if  session:set-wait-state("GENERAL":U) then.

    {report/imrun.i xxp/xx9999rp.p}

    {report/imexc.i}

    if  session:set-wait-state("":U) then.
    
    {report/imtrm.i tt-param.arq-destino tt-param.destino}
    
end.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

