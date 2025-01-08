&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i ESCQP003 2.04.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCQP003
&GLOBAL-DEFINE Version        1
&GLOBAL-DEFINE VersionLayout  1

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Parƒmetros,ImpressÆo

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          NO
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE RTF            no

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page1Widgets   
                              
&GLOBAL-DEFINE Page4Widgets   fi-cod-estabel fi-cod-emitente fi-nat-operacao fi-nro-docto fi-serie-docto rs-urgencia browse-1
&GLOBAL-DEFINE page3Widgets  
                              
&GLOBAL-DEFINE page5Widgets   
                              
                              
                              
                              
                              
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              cmodel ~
                              rsExecution
&GLOBAL-DEFINE page7Widgets   
&GLOBAL-DEFINE page8Widgets   

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE Page4Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo text-modelo
&GLOBAL-DEFINE page7Text      
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE Page4Fields    fi-cod-estabel fi-cod-emitente fi-nat-operacao fi-nro-docto fi-serie-docto rs-urgencia
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile cmodel
&GLOBAL-DEFINE page7Fields    
&GLOBAL-DEFINE page8Fields    

/* Parameters Definitions ---                                           */

{esp/cqp/ESCQP003tt.i}
{upc/btb910za-upc.i}

{esp/es0018.i}


define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-rtf              as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.

def stream s-imp.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

def new global shared var gr-documento  as rowid no-undo.


DEF VAR c-volume AS CHAR.
DEF VAR c-localizacao1 AS CHAR.
DEF VAR c-localizacao2 AS CHAR.
DEF VAR c-localizacao3 AS CHAR.
DEF VAR c-localizacao4 AS CHAR.
DEF VAR c-localizacao5 AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-digita

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 tt-digita.it-codigo   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1   
&Scoped-define SELF-NAME BROWSE-1
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH tt-digita
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY {&SELF-NAME} FOR EACH tt-digita.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 tt-digita
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 tt-digita


/* Definitions for FRAME fPage4                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage4 ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp2 

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

DEFINE VARIABLE fi-cod-emitente AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Emitente":R10 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88.

DEFINE VARIABLE fi-cod-estabel AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estab." 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fi-denominacao AS CHARACTER FORMAT "x(35)" 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nat-operacao AS CHARACTER FORMAT "x(06)" 
     LABEL "Nat Opera‡Æo":R15 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE fi-nome-emit AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nro-docto AS CHARACTER FORMAT "x(16)" 
     LABEL "Documento":R11 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88.

DEFINE VARIABLE fi-serie-docto AS CHARACTER FORMAT "x(5)" 
     LABEL "S‚rie":R7 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE rs-urgencia AS LOGICAL 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Urgente", yes,
"Normal", no
     SIZE 25 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38 BY 2.25.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btmodel 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U NO-FOCUS
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.14 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-modelo AS CHARACTER FORMAT "X(256)":U INITIAL "Parƒmetros de ImpressÆo" 
      VIEW-AS TEXT 
     SIZE 20 BY .63
     FONT 1 NO-UNDO.

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

DEFINE VARIABLE cmodel AS LOGICAL INITIAL no 
     LABEL "Imprimir p gina de parƒmetros" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      tt-digita SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 wReport _FREEFORM
  QUERY BROWSE-1 DISPLAY
      tt-digita.it-codigo COLUMN-LABEL "Item"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 37 BY 6
         FONT 1
         TITLE "Itens sem Roteiro" FIT-LAST-COLUMN.


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

DEFINE FRAME fPage6
     btmodel AT ROW 7.75 COL 43 HELP
          "Escolha do nome do arquivo" NO-TAB-STOP 
     rsDestiny AT ROW 2.38 COL 3.29 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     btFile AT ROW 3.5 COL 43 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.5 COL 43 HELP
          "Configura‡Æo da impressora"
     cFile AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 5.75 COL 2.86 HELP
          "Modo de Execu‡Æo" NO-LABEL
     cmodel AT ROW 8 COL 2.86
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5 COL 1.14 COLON-ALIGNED NO-LABEL
     text-modelo AT ROW 7.25 COL 1.14 COLON-ALIGNED NO-LABEL AUTO-RETURN 
     RECT-13 AT ROW 5.29 COL 2
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 7.54 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1.

DEFINE FRAME fPage4
     fi-cod-estabel AT ROW 1.75 COL 10.72 COLON-ALIGNED WIDGET-ID 2
     fi-cod-emitente AT ROW 2.79 COL 10.72 COLON-ALIGNED
     fi-nome-emit AT ROW 2.79 COL 22 COLON-ALIGNED HELP
          "Nome Completo do Emitente" NO-LABEL NO-TAB-STOP 
     fi-serie-docto AT ROW 3.79 COL 10.72 COLON-ALIGNED
     fi-nro-docto AT ROW 4.79 COL 10.72 COLON-ALIGNED
     fi-nat-operacao AT ROW 5.79 COL 10.72 COLON-ALIGNED
     fi-denominacao AT ROW 5.79 COL 18 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     BROWSE-1 AT ROW 7.58 COL 44
     rs-urgencia AT ROW 8.04 COL 13 NO-LABEL
     "Urgˆncia:" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 7.29 COL 5.72
     RECT-14 AT ROW 7.54 COL 3
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.75
         SIZE 84.43 BY 13
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window Template
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
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
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* BROWSE-TAB BROWSE-1 fi-denominacao fPage4 */
/* SETTINGS FOR FILL-IN fi-denominacao IN FRAME fPage4
   NO-ENABLE                                                            */
ASSIGN 
       fi-denominacao:READ-ONLY IN FRAME fPage4        = TRUE.

/* SETTINGS FOR FILL-IN fi-nome-emit IN FRAME fPage4
   NO-ENABLE                                                            */
ASSIGN 
       fi-nome-emit:READ-ONLY IN FRAME fPage4        = TRUE.

/* SETTINGS FOR FRAME fPage6
                                                                        */
/* SETTINGS FOR BUTTON btmodel IN FRAME fPage6
   NO-ENABLE                                                            */
ASSIGN 
       btmodel:HIDDEN IN FRAME fPage6           = TRUE.

ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execu‡Æo".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-digita.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage4
/* Query rebuild information for FRAME fPage4
     _Query            is NOT OPENED
*/  /* FRAME fPage4 */
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


&Scoped-define BROWSE-NAME BROWSE-1
&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 wReport
ON MOUSE-SELECT-DBLCLICK OF BROWSE-1 IN FRAME fPage4 /* Itens sem Roteiro */
DO:
  /*
  IF BROWSE browse-1:NUM-ITERATIONS > 0 AND BROWSE browse-1:NUM-SELECTED-ROWS > 0 THEN DO:
      BROWSE browse-1:FETCH-SELECTED-ROW(1).
      tt-digita.selecionado = NOT tt-digita.selecionado.
      DISP tt-digita.selecionado WITH BROWSE browse-1.
  END.
  */
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
&Scoped-define SELF-NAME btmodel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btmodel wReport
ON CHOOSE OF btmodel IN FRAME fPage6
DO:
    {report/rparq.i}
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


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME fi-cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-emitente wReport
ON LEAVE OF fi-cod-emitente IN FRAME fPage4 /* Emitente */
DO:
    {include/leave.i &tabela=emitente
                     &atributo-ref=nome-emit
                     &variavel-ref=fi-nome-emit
                     &where="emitente.cod-emitente = int(fi-cod-emitente:screen-value in frame fPAge4)"}
                     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-emitente wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cod-emitente IN FRAME fPage4 /* Emitente */
OR F5 OF fi-cod-emitente IN FRAME fPage4 DO:
    APPLY "f5" TO fi-nro-docto IN FRAME fPage4.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-nat-operacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nat-operacao wReport
ON LEAVE OF fi-nat-operacao IN FRAME fPage4 /* Nat Opera‡Æo */
DO:
    {include/leave.i &tabela=natur-oper
                     &atributo-ref=denominacao
                     &variavel-ref=fi-denominacao
                     &where="natur-oper.nat-operacao = fi-nat-operacao:screen-value in frame fPAge4"}
                     
    RUN buscaItensSemRoteiro.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nat-operacao wReport
ON MOUSE-SELECT-DBLCLICK OF fi-nat-operacao IN FRAME fPage4 /* Nat Opera‡Æo */
OR F5 OF fi-nat-operacao IN FRAME fPage4 DO:
    APPLY "f5" TO fi-nro-docto IN FRAME fPage4.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-nro-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nro-docto wReport
ON MOUSE-SELECT-DBLCLICK OF fi-nro-docto IN FRAME fPage4 /* Documento */
OR F5 OF fi-nro-docto IN FRAME fPage4 DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in090"
                       &campo="fi-cod-emitente"
                       &campozoom="cod-emitente"
                       &frame="fPage4"
                       &campo2="fi-nat-operacao"
                       &campozoom2="nat-operacao"
                       &frame2="fPage4"
                       &campo3="fi-nro-docto"
                       &campozoom3="nro-docto"
                       &frame3="fPage4"
                       &campo4="fi-serie-docto"
                       &campozoom4="serie-docto"
                       &frame4="fPage4"}

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-serie-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-serie-docto wReport
ON MOUSE-SELECT-DBLCLICK OF fi-serie-docto IN FRAME fPage4 /* S‚rie */
OR F5 OF fi-serie-docto IN FRAME fPage4 DO:
    APPLY "f5" TO fi-nro-docto IN FRAME fPage4.
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
                   rect-13:VISIBLE       = YES.
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


fi-cod-emitente:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage4.
fi-nat-operacao:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage4. 
fi-nro-docto:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage4. 
fi-serie-docto:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage4.

/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{report/MainBlock.i}


{esp/es0020.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    for first docum-est no-lock
        where rowid(docum-est) = gr-documento:
        
        disp docum-est.cod-estabel  @ fi-cod-estabel
             docum-est.cod-emitente @ fi-cod-emitente
             docum-est.nat-operacao @ fi-nat-operacao
             docum-est.nro-docto    @ fi-nro-docto
             docum-est.serie-docto  @ fi-serie-docto with frame fPage4.
             
        apply "leave" to fi-nat-operacao in frame fPage4.      
        
    end.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaItensSemRoteiro wReport 
PROCEDURE buscaItensSemRoteiro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-digita.
    
    FOR EACH item-doc-est NO-LOCK
        WHERE item-doc-est.cod-emitente = INPUT FRAME fPage4 fi-cod-emitente
        AND   item-doc-est.serie-docto  = INPUT FRAME fPage4 fi-serie-docto 
        AND   item-doc-est.nro-docto    = INPUT FRAME fPage4 fi-nro-docto   
        AND   item-doc-est.nat-operacao = INPUT FRAME fPage4 fi-nat-operacao
        AND   item-doc-est.nr-ficha     = 0
        BREAK BY item-doc-est.it-codigo:
        IF FIRST-OF(item-doc-est.it-codigo) THEN DO:
            CREATE tt-digita.
            ASSIGN tt-digita.it-codigo   = item-doc-est.it-codigo
                   tt-digita.selecionado = NO.
        END.
    END.
    OPEN QUERY BROWSE-1 FOR EACH tt-digita.
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
DEFINE VARIABLE d-volume AS DECIMAL     NO-UNDO.


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

    
    IF NOT CAN-FIND( FIRST docum-est NO-LOCK 
                     WHERE docum-est.serie        = INPUT FRAME fPage4 fi-serie-docto        
                       AND docum-est.nro-docto    = INPUT FRAME fPage4 fi-nro-docto    
                       AND docum-est.cod-emitente = INPUT FRAME fPage4 fi-cod-emitente
                       AND docum-est.nat-operacao = INPUT FRAME fPage4 fi-nat-operacao 
                       AND docum-est.cod-estabel  = INPUT FRAME fPage4 fi-cod-estabel) THEN DO:
        
        RUN piMessage (INPUT 1,
                       "Documento informado nÆo exite",
                       "Roteiro nÆo pode ser impresso").
        apply "ENTRY":U to fi-cod-emitente in frame fPage4.
        RETURN error.
    END.

    FIND FIRST ae-entrada WHERE
         ae-entrada.cod-estabel = INPUT FRAME fPage4 fi-cod-estabel and
         ae-entrada.cod-emitente = INT(fi-cod-emitente:SCREEN-VALUE IN FRAME fpage4) AND
         ae-entrada.nro-docto = int(fi-nro-docto:SCREEN-VALUE IN FRAME fpage4) NO-LOCK NO-ERROR. /* FALTA COMPILAR */
    IF AVAIL ae-entrada THEN DO:
       ASSIGN c-volume       = ae-entrada.estrado[1]
              c-localizacao1 = ae-entrada.localizacao[1]
              c-localizacao2 = ae-entrada.localizacao[2]
              c-localizacao3 = ae-entrada.localizacao[3]
              c-localizacao4 = ae-entrada.localizacao[4]
              c-localizacao5 = ae-entrada.localizacao[5].
    END.
    ELSE DO:
        ASSIGN c-volume       = ""
               c-localizacao1 = ""
               c-localizacao2 = ""
               c-localizacao3 = ""
               c-localizacao4 = ""
               c-localizacao5 = "".
    END.

    IF c-volume = "" THEN
        ASSIGN c-volume = "0".

    ASSIGN d-volume = DEC(c-volume) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN
        ASSIGN c-volume = "0".

    CREATE tt-param.
    ASSIGN tt-param.usuario         = c-seg-usuario                                    .
           tt-param.destino         = input frame fPage6 rsDestiny                     .
           tt-param.data-exec       = today                                            .
           tt-param.hora-exec       = time                                             .
           tt-param.cod-emitente    = INPUT FRAME fPage4 fi-cod-emitente               .
           tt-param.serie-docto     = INPUT FRAME fPage4 fi-serie-docto                .
           tt-param.nro-docto       = INPUT FRAME fPage4 fi-nro-docto                  .
           tt-param.nat-operacao    = INPUT FRAME fPage4 fi-nat-operacao               .
           tt-param.urgencia        = INPUT FRAME fPage4 rs-urgencia                   .
           tt-param.imprime-param   = INPUT FRAME fPage6 cmodel                        .
           tt-param.volume          = dec(c-volume)                                    .
           tt-param.localizacao1    = c-localizacao1                                   .
           tt-param.localizacao2    = c-localizacao2                                   .
           tt-param.localizacao3    = c-localizacao3                                   .
           tt-param.localizacao4    = c-localizacao4                                   .
           tt-param.localizacao5    = c-localizacao5                                   .
           tt-param.cod-estabel     = INPUT FRAME fPage4 fi-cod-estabel.
    
    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "":U.
    else if  tt-param.destino = 2 OR tt-param.destino = 4 
        then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
    /*:T Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */
    
    for each tt-raw-digita:
        delete tt-raw-digita.
    end.
    for each tt-digita:
        create tt-raw-digita.
        raw-transfer tt-digita to tt-raw-digita.raw-digita.
    end.  

    /*:T Executar do programa RP.P que ir  criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i esp/cqp/escqp003rp.p}
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
end.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMessage wReport 
PROCEDURE piMessage :
def input param p-tipo AS INT no-undo.
    DEF INPUT PARAM p-texto-msg AS CHAR NO-UNDO.
    DEF INPUT PARAM p-help-msg AS CHAR NO-UNDO.

    def var v_msg_val           as char     no-undo 
        view-as editor size-char 61 by 1.7 
        scrollbar-vertical.
    def var v_msg_hlp           as char     no-undo 
        view-as editor size-char 50 by 3
        scrollbar-vertical font 2.
    def var c-ajuda             as char format "x(7)" no-undo view-as text size 7 by 1 INIT "Ajuda".

    def image im_msg_ico     file "image/im-mqerr".
    def rectangle rt_help    size-char 52 by 4 edge-pixels 2 bgcolor 8.
    def rectangle rt_button  size-char 61 by 1.42 edge-pixels 1 bgcolor 7.
    def button bt_yes        label "&OK" size-char 10 by 1 auto-go.
    def button bt_no         label "&NÆo" size-char 10 by 1 auto-go.
    
    def frame f_msg_help
        v_msg_val    at row 1.5 col 2
        im_msg_ico   at row 4.5 col  4
        v_msg_hlp    at row 4.5 col 12
        rt_help      at row 4.0 col 11
        c-ajuda      at row 3.5 col 14 
        rt_button    at row 8.5 col 2 space(1)
        bt_yes        at row 8.71 col 3
        bt_no        at row 8.71 col 14
        skip(0.5)
        with three-d no-label view-as DIALOG-BOX TITLE "Pergunta" DEFAULT-BUTTON bt_yes.

    on cursor-right of 
        bt_yes, bt_no    apply "TAB" to self.
    on cursor-left of
        bt_yes, bt_no    apply "SHIFT-TAB" to self.
     
    on choose of bt_yes
        return "yes".
    on choose of bt_no 
        return "no".
    on end-error of frame f_msg_help do:
        if bt_no:HIDDEN in frame f_msg_help = no then 
            return "no".
        else return "yes".
    end.
    CASE p-tipo:
        WHEN 1 THEN do:
            im_msg_ico:load-image("image/im-mqerr").
            frame f_msg_help:TITLE = "Erro".
            assign bt_no:hidden in frame f_msg_help = YES
                   bt_no:sensitive in frame f_msg_help = NO
                   bt_yes:hidden in frame f_msg_help = NO     
                   bt_yes:sensitive in frame f_msg_help = YES. 
        END.
        WHEN 2 THEN do:
            im_msg_ico:load-image("image/im-mqwar").
            frame f_msg_help:TITLE = "Advertˆncia".
            assign bt_no:hidden in frame f_msg_help = YES
                   bt_no:sensitive in frame f_msg_help = NO
                   bt_yes:hidden in frame f_msg_help = NO     
                   bt_yes:sensitive in frame f_msg_help = YES. 
        END.
        WHEN 3 THEN do:
            im_msg_ico:load-image("image/im-mqqst").
            frame f_msg_help:TITLE = "Pergunta".
            assign bt_no:hidden in frame f_msg_help = no
                   bt_no:sensitive in frame f_msg_help = yes
                   bt_yes:hidden in frame f_msg_help = no     
                   bt_yes:sensitive in frame f_msg_help = yes.
            bt_yes:label in frame f_msg_help = "&Sim".
        END.
        WHEN 4 THEN do:
            im_msg_ico:load-image("image/im-mqinf").
            frame f_msg_help:TITLE = "Informa‡Æo".
            assign bt_no:hidden in frame f_msg_help = YES
                   bt_no:sensitive in frame f_msg_help = NO
                   bt_yes:hidden in frame f_msg_help = NO     
                   bt_yes:sensitive in frame f_msg_help = YES. 
        END.
    END CASE.
 
    assign v_msg_val = p-texto-msg.
    assign v_msg_hlp = p-help-msg + chr(10) + "".

    assign v_msg_val:read-only in frame f_msg_help = yes
           v_msg_hlp:read-only in frame f_msg_help = yes.

    VIEW FRAME f_msg_help.
    DISP c-ajuda v_msg_val v_msg_hlp WITH FRAME f_msg_help.
    ENABLE v_msg_val v_msg_hlp WITH FRAME f_msg_help.
    apply "entry" to bt_no.
    wait-for choose of bt_yes or choose of bt_no.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

