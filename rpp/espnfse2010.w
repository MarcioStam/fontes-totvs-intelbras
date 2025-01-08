&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
{include/i-prgvrs.i espnfse2010 3.00.00.000}
/**ATUALIZACAO: 12/12/2011**/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        espnfse2010
&GLOBAL-DEFINE Version        3.00.00.000
&GLOBAL-DEFINE VersionLayout  1

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Seleá∆o,ParÉmetro,Impress∆o

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE RTF            NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page3Widgets   
&GLOBAL-DEFINE page4Widgets   l-rps-enviados l-rps-erros fn-dir-exportacao
                              
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              cFile ~
                              btFile ~
                              rsExecution
&GLOBAL-DEFINE page8Widgets   

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text     
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text  text-destino text-modo
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    fn-cod-estab-ini fn-cod-estab-fim  fn-rps-ini fn-rps-fim fn-dt-emis-ini fn-dt-emis-fim fn-nat-oper-ini fn-nat-oper-fim
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields   
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    
&GLOBAL-DEFINE page8Fields    

/* Parameters Definitions ---                                           */

{rpp/espnfse2010.i}

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
DEF VAR c-modelo-default   AS CHAR    NO-UNDO.
DEF VAR c-nom-dir          AS CHAR    NO-UNDO.
DEF VAR l-cancela          AS LOG     NO-UNDO.
def stream s-imp.

DEFINE SHARED VARIABLE hWenController AS HANDLE NO-UNDO.

/* TRATAMENTO CLIENTES ORACLE */
{include\i_dbtype.i}
&IF "{&ems_dbType}":U = "ORACLE":U &THEN
    DEF NEW GLOBAL SHARED VAR h-rsocial    AS HANDLE  NO-UNDO.
    DEF NEW GLOBAL SHARED VAR l-achou-prog AS LOGICAL NO-UNDO.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

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

DEFINE VARIABLE fn-cod-estab-fim AS CHARACTER FORMAT "x(3)" INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE fn-cod-estab-ini AS CHARACTER FORMAT "x(3)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE fn-dt-emis-fim AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fn-dt-emis-ini AS DATE FORMAT "99/99/9999" 
     LABEL "Data Emiss∆o" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fn-nat-oper-fim AS CHARACTER FORMAT "x(6)" INITIAL "ZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fn-nat-oper-ini AS CHARACTER FORMAT "X(6)" 
     LABEL "Natureza de Operaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fn-rps-fim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fn-rps-ini AS CHARACTER FORMAT "x(16)" 
     LABEL "Nr RPS" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
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

DEFINE BUTTON btDir 
     IMAGE-UP FILE "image/im-open.gif":U
     LABEL "btdirweb 2" 
     SIZE 4.29 BY 1.

DEFINE VARIABLE fn-dir-exportacao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 71 BY .79 NO-UNDO.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83 BY 6.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83 BY 4.21.

DEFINE VARIABLE l-rps-enviados AS LOGICAL INITIAL no 
     LABEL "Considera RPS j† Enviados" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .83 NO-UNDO.

DEFINE VARIABLE l-rps-erros AS LOGICAL INITIAL no 
     LABEL "Somente RPS com Erro" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE BUTTON blModelRtf 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE cModelRTF AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.14 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execuá∆o" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-rtf AS CHARACTER FORMAT "X(256)":U INITIAL "Rich Text Format(RTF)" 
      VIEW-AS TEXT 
     SIZE 16 BY .67 NO-UNDO.

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
     SIZE 27.86 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 1.71.

DEFINE RECTANGLE rect-rtf
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 3.21.

DEFINE VARIABLE l-habilitaRtf AS LOGICAL INITIAL no 
     LABEL "RTF" 
     VIEW-AS TOGGLE-BOX
     SIZE 44 BY 1.08
     FONT 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.96
         FONT 1.

DEFINE FRAME fPage2
     fn-cod-estab-ini AT ROW 3.5 COL 26 COLON-ALIGNED
     fn-cod-estab-fim AT ROW 3.5 COL 45 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     fn-rps-ini AT ROW 4.5 COL 18 COLON-ALIGNED
     fn-rps-fim AT ROW 4.5 COL 45 COLON-ALIGNED NO-LABEL
     fn-dt-emis-ini AT ROW 5.5 COL 18 COLON-ALIGNED
     fn-dt-emis-fim AT ROW 5.5 COL 45 COLON-ALIGNED NO-LABEL
     fn-nat-oper-ini AT ROW 6.5 COL 24 COLON-ALIGNED WIDGET-ID 12
     fn-nat-oper-fim AT ROW 6.5 COL 45 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     IMAGE-5 AT ROW 4.5 COL 35.86
     IMAGE-6 AT ROW 4.5 COL 44
     IMAGE-7 AT ROW 5.5 COL 35.86
     IMAGE-8 AT ROW 5.5 COL 44
     IMAGE-9 AT ROW 3.5 COL 35.86 WIDGET-ID 4
     IMAGE-10 AT ROW 3.5 COL 44 WIDGET-ID 6
     IMAGE-11 AT ROW 6.5 COL 35.86 WIDGET-ID 14
     IMAGE-12 AT ROW 6.5 COL 44 WIDGET-ID 16
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.46
         FONT 1.

DEFINE FRAME fPage4
     l-rps-enviados AT ROW 3.67 COL 29
     l-rps-erros AT ROW 4.75 COL 29 WIDGET-ID 124
     fn-dir-exportacao AT ROW 9.92 COL 3 COLON-ALIGNED NO-LABEL
     btDir AT ROW 9.75 COL 76 WIDGET-ID 122
     "Opá‰es" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 1.92 COL 4
     "Diret¢rio Exportaá∆o RPS" VIEW-AS TEXT
          SIZE 18 BY .54 AT ROW 8.67 COL 4
     RECT-14 AT ROW 2.17 COL 2
     RECT-16 AT ROW 8.92 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.46
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.14 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     btFile AT ROW 3.5 COL 43 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.5 COL 43 HELP
          "Configuraá∆o da impressora"
     cFile AT ROW 3.63 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 6 COL 2.86 HELP
          "Modo de Execuá∆o" NO-LABEL
     l-habilitaRtf AT ROW 7.83 COL 3.14
     cModelRTF AT ROW 9.54 COL 3 HELP
          "Nome do arquivo de modelo" NO-LABEL
     blModelRtf AT ROW 9.54 COL 43 HELP
          "Escolha o arquivo de modelo"
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5.25 COL 1.14 COLON-ALIGNED NO-LABEL
     text-rtf AT ROW 7.25 COL 2 COLON-ALIGNED NO-LABEL
     rect-rtf AT ROW 7.54 COL 2
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.5 COL 2
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
         HEIGHT             = 16.96
         WIDTH              = 90
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.14
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 114.14
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
ASSIGN FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FRAME fPage4
   Custom                                                               */
/* SETTINGS FOR FRAME fPage6
                                                                        */
ASSIGN 
       blModelRtf:HIDDEN IN FRAME fPage6           = TRUE.

ASSIGN 
       cModelRTF:HIDDEN IN FRAME fPage6           = TRUE.

/* SETTINGS FOR TOGGLE-BOX l-habilitaRtf IN FRAME fPage6
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       l-habilitaRtf:HIDDEN IN FRAME fPage6           = TRUE.

/* SETTINGS FOR RECTANGLE rect-rtf IN FRAME fPage6
   NO-ENABLE                                                            */
ASSIGN 
       rect-rtf:HIDDEN IN FRAME fPage6           = TRUE.

ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execuá∆o".

ASSIGN 
       text-rtf:HIDDEN IN FRAME fPage6           = TRUE
       text-rtf:PRIVATE-DATA IN FRAME fPage6     = 
                "Rich Text Format(RTF)".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
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


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME blModelRtf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL blModelRtf wReport
ON CHOOSE OF blModelRtf IN FRAME fPage6
DO:
    def var cFile as char no-undo.
    def var l-ok  as logical no-undo.

    assign cModelRTF = replace(input frame {&frame-name} cModelRTF, "/", "\").
    SYSTEM-DIALOG GET-FILE cFile
       FILTERS "*.rtf" "*.rtf",
               "*.*" "*.*"
       DEFAULT-EXTENSION "rtf"
       INITIAL-DIR "modelos" 
       MUST-EXIST
       USE-FILENAME
       UPDATE l-ok.
    if  l-ok = yes then
        assign cModelRTF:screen-value in frame {&frame-name}  = replace(cFile, "\", "/"). 

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


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btDir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDir wReport
ON CHOOSE OF btDir IN FRAME fPage4 /* btdirweb 2 */
DO:
    RUN pi-get-directory ('',
                          OUTPUT c-nom-dir,
                          OUTPUT l-cancela).

    IF  NOT l-cancela THEN DO:
        ASSIGN fn-dir-exportacao:SCREEN-VALUE IN FRAME fPage4 = c-nom-dir.
        APPLY 'leave' TO fn-dir-exportacao IN FRAME fPage4.
    END.
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
&Scoped-define SELF-NAME fn-dir-exportacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fn-dir-exportacao wReport
ON LEAVE OF fn-dir-exportacao IN FRAME fPage4
DO:
    ASSIGN INPUT FRAME fPage4 fn-dir-exportacao.

    IF  fn-dir-exportacao <> "" THEN DO:

        IF  NOT SUBSTRING(fn-dir-exportacao,LENGTH(fn-dir-exportacao),1) = "\" AND
            NOT SUBSTRING(fn-dir-exportacao,LENGTH(fn-dir-exportacao),1) = "/" THEN
            ASSIGN SUBSTRING(fn-dir-exportacao,LENGTH(fn-dir-exportacao) + 1,1) = "\".
    END.

    DISP fn-dir-exportacao WITH FRAME fPage4.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME l-habilitaRtf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-habilitaRtf wReport
ON VALUE-CHANGED OF l-habilitaRtf IN FRAME fPage6 /* RTF */
DO:
    &IF "{&RTF}":U = "YES":U &THEN
    RUN pi-habilitaRtf.  
    &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME l-rps-erros
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-rps-erros wReport
ON VALUE-CHANGED OF l-rps-erros IN FRAME fPage4 /* Somente RPS com Erro */
DO:
  
    ASSIGN l-rps-enviados:CHECKED IN FRAME fpage4 = l-rps-erros:CHECKED IN FRAME fPage4
           l-rps-enviados:SENSITIVE IN FRAME fPage4 = NOT l-rps-erros:CHECKED IN FRAME fPage4.

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
                   btConfigImpr:visible  = yes
                   /*Alterado 15/02/2005 - tech1007 - Alterado para suportar adequadamente com a 
                     funcionalidade de RTF*/
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = NO
                   l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "No"
                   l-habilitaRtf = NO
                   &endif
                   .
                   /*Fim alteracao 15/02/2005*/
        end.
        when "2":U then do:
            assign cFile:sensitive       = yes
                   cFile:visible         = yes
                   btFile:visible        = yes
                   btConfigImpr:visible  = no
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = YES
                   &endif
                   .
        end.
        when "3":U then do:
            assign cFile:visible         = no
                   cFile:sensitive       = no
                   btFile:visible        = no
                   btConfigImpr:visible  = no
                   &IF "{&RTF}":U = "YES":U &THEN
                   l-habilitaRtf:sensitive  = YES
                   &endif
                   .
            /*Alterado 15/02/2005 - tech1007 - Teste para funcionar corretamente no WebEnabler*/
            &IF "{&RTF}":U = "YES":U &THEN
            IF VALID-HANDLE(hWenController) THEN DO:
                ASSIGN l-habilitaRtf:sensitive  = NO
                       l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "No"
                       l-habilitaRtf = NO.
            END.
            &endif
            /*Fim alteracao 15/02/2005*/
        END.
        /*Alterado 15/02/2005 - tech1007 - Condiá∆o removida pois RTF n∆o Ç mais um destino
        when "4":U then do:
            assign cFile:sensitive       = no
                   cFile:visible         = yes
                   btFile:visible        = no
                   btConfigImpr:visible  = yes
                   text-ModelRtf:VISIBLE   = YES
                   rect-rtf:VISIBLE       = YES
                   blModelRtf:VISIBLE       = yes.
        end.
        Fim alteracao 15/02/2005*/
    end case.
end.
&IF "{&RTF}":U = "YES":U &THEN
RUN pi-habilitaRtf.  
&endif
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


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{report/MainBlock.i}

/***************************** Mostra diretÛrios ****************************/
PROCEDURE SHBrowseForFolder EXTERNAL "shell32.dll":
    DEF INPUT  PARAM lpbi                              AS LONG.
    DEF RETURN PARAM lpItemIDList                      AS LONG.
END PROCEDURE. /* SHBrowseForFolder */

/******************************** Busca Path ********************************/
PROCEDURE SHGetPathFromIDList EXTERNAL "shell32.dll":
    DEF INPUT  PARAM v_cdn_lista                       AS LONG.
    DEF OUTPUT PARAM pszPath                           AS CHARACTER.
END PROCEDURE. /* SHGetPathFromIDList */

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
/*Alterado 17/02/2005 - tech1007 - Foi criado essa procedure para que seja realizado a inicializaá∆o
  correta dos componentes do RTF quando executado em ambiente local e no WebEnabler.*/
/*Fim alteracao 17/02/2005*/

    ASSIGN fn-dt-emis-ini:SCREEN-VALUE IN FRAME fpage2 = string(today)
           fn-dt-emis-fim:SCREEN-VALUE IN FRAME fpage2 = string(today).

    ENABLE btDir WITH FRAME fPage4.
   
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-param wReport 
PROCEDURE pi-cria-tt-param :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    EMPTY TEMP-TABLE tt-param.

    CREATE tt-param.
    ASSIGN tt-param.usuario         = c-seg-usuario
           tt-param.destino         = INPUT FRAME fPage6 rsDestiny
           tt-param.data-exec       = TODAY
           tt-param.hora-exec       = TIME
           tt-param.cod-estabel-ini = INPUT FRAME fpage2 fn-cod-estab-ini
           tt-param.cod-estabel-fim = INPUT FRAME fpage2 fn-cod-estab-fim
           tt-param.serie-ini       = "R2"
           tt-param.serie-fim       = "R2"
           tt-param.nr-rps-ini      = INPUT FRAME fpage2 fn-rps-ini
           tt-param.nr-rps-fim      = INPUT FRAME fpage2 fn-rps-fim
           tt-param.dt-emis-ini     = INPUT FRAME fpage2 fn-dt-emis-ini
           tt-param.dt-emis-fim     = INPUT FRAME fpage2 fn-dt-emis-fim
           tt-param.enviados        = INPUT FRAME fpage4 l-rps-enviados
           tt-param.erros           = INPUT FRAME fPage4 l-rps-erros
           tt-param.arquivo-exp     = INPUT FRAME fpage4 fn-dir-exportacao
           tt-param.nat-oper-ini    = INPUT FRAME fPage2 fn-nat-oper-ini
           tt-param.nat-oper-fim    = INPUT FRAME fPage2 fn-nat-oper-fim.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-get-directory wReport 
PROCEDURE pi-get-directory :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    /************************ Parameter Definition Begin ************************/

    def Input param p_des_titulo
        as character
        format "x(40)":U
        no-undo.
    def output param p_nom_path
        as character
        format "x(50)":U
        no-undo.
    def output param p_log_cancdo
        as logical
        format "Sim/N„o"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cdn_lista_item
        as Integer
        format ">>>,>>9":U
        no-undo.
    def var v_mmp_browse
        as MemPtr
        no-undo.
    def var v_mmp_mostra_nom
        as MemPtr
        no-undo.
    def var v_mmp_title_pointer
        as MemPtr
        no-undo.


    /************************** Variable Definition End *************************/

    set-size(v_mmp_browse)        = 32.
    set-size(v_mmp_mostra_nom)    = 260.
    set-size(v_mmp_title_pointer) = length(p_des_titulo) + 1.

    put-string(v_mmp_title_pointer,1) = p_des_titulo.

    put-long(v_mmp_browse, 1) = 0.
    put-long(v_mmp_browse, 5) = 0.
    put-long(v_mmp_browse, 9) = get-pointer-value(v_mmp_mostra_nom).
    put-long(v_mmp_browse,13) = get-pointer-value(v_mmp_title_pointer).
    put-long(v_mmp_browse,17) = 1.
    put-long(v_mmp_browse,21) = 0.
    put-long(v_mmp_browse,25) = 0.
    put-long(v_mmp_browse,29) = 0.

    run SHBrowseForFolder( input  get-pointer-value(v_mmp_browse), 
                           output v_cdn_lista_item).

    /* parse the result: */
    if v_cdn_lista_item = 0 then do:
       p_log_cancdo   = yes.
       p_nom_path = "".
    end.
    else do:
       assign p_log_cancdo = No
              p_nom_path = fill(" ", 260).
       run SHGetPathFromIDList(v_cdn_lista_item, output p_nom_path).
       assign p_nom_path = trim(p_nom_path).
    end.   

    /* free memory: */
    set-size(v_mmp_browse) = 0.
    set-size(v_mmp_mostra_nom) = 0.
    set-size(v_mmp_title_pointer) = 0.

    RETURN "OK":U.
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

do on error undo, return error on stop  undo, return error:
    {report/rpexa.i}

    if input frame fPage6 rsDestiny = 2 and
       input frame fPage6 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage6 cFile).
        
        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show":U, input 73, input "":U).
            apply "ENTRY":U to cFile in frame fPage6.
            return error.
        end.
    end.

    IF  INPUT FRAME fPage4 fn-dir-exportacao <> "" THEN DO:
        
        OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "espnfse2010.001").
        OUTPUT CLOSE.
        OS-COPY VALUE(SESSION:TEMP-DIRECTORY + "espnfse2010.001") VALUE(INPUT FRAME fPage4 fn-dir-exportacao + "espnfse2010.001").

        IF  OS-ERROR <> 0 THEN DO:
            run utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "Diret¢rio de exportaá∆o inv†lido!" + "~~" + "Favor, informar um diret¢rio v†lido (existente e com permiss∆o de gravaá∆o). Este campo pode ficar em branco, neste caso ser† utilizado o diret¢rio padr∆o para exportaá∆o conforme FAT0177.").
            RETURN ERROR.
        END.

        OS-DELETE VALUE(SESSION:TEMP-DIRECTORY + "espnfse2010.001") NO-ERROR.
        OS-DELETE VALUE(INPUT FRAME fPage4 fn-dir-exportacao + "espnfse2010.001") NO-ERROR.
    END.
        
    RUN pi-cria-tt-param.
    
    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "":U.
    else if  tt-param.destino = 2 
        then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.

    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i rpp/espnfse2010rp.p}
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

