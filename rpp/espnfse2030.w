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
{include/i-prgvrs.i espnfse2030 3.00.00.000}
/**ATUALIZACAO: 06/01/2011**/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        espnfse2030
&GLOBAL-DEFINE Version        3.00.00.000
&GLOBAL-DEFINE VersionLayout  1

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   ParÉmetro,Impress∆o

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          NO
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
&GLOBAL-DEFINE page4Widgets    fn-arq-importacao fn-dir-importacao btDir btarquivo-imp
                              
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
&GLOBAL-DEFINE page2Fields
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields   fn-cod-estab-ini fn-cod-estab-fim
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    
&GLOBAL-DEFINE page8Fields    

DEF NEW GLOBAL SHARED VAR h-espnfse2006a AS HANDLE NO-UNDO.                                 
/* Parameters Definitions ---                                           */

DEF TEMP-TABLE tt-param NO-UNDO
    FIELD destino            AS INT
    FIELD arquivo            AS CHAR FORMAT "x(35)":U
    FIELD usuario            AS CHAR FORMAT "x(12)":U
    FIELD data-exec          AS DATE
    FIELD hora-exec          AS INT
    FIELD classifica         AS INT
    FIELD desc-classifica    AS CHAR FORMAT "x(40)":U
    FIELD modelo             AS CHAR FORMAT "x(35)":U
    FIELD l-habilitaRtf      AS LOG
    FIELD cod-estabel-ini    AS CHAR FORMAT "x(03)":U
    FIELD cod-estabel-fim    AS CHAR FORMAT "x(03)":U
    FIELD lista-movto        AS LOG 
    FIELD arquivo-imp        AS CHAR
    FIELD diretorio-imp      AS CHAR.

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
DEF NEW GLOBAL SHARED VAR adm-broker-hdl AS HANDLE NO-UNDO.

/* TRATAMENTO CLIENTES ORACLE */
{include\i_dbtype.i}
&IF "{&ems_dbType}":U = "ORACLE":U &THEN
    DEF NEW GLOBAL SHARED VAR h-rsocial    AS HANDLE  NO-UNDO.
    DEF NEW GLOBAL SHARED VAR l-achou-prog AS LOGICAL NO-UNDO.
&ENDIF

/*def stream s-imp.*/

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est† rodando no WebEnabler*/
DEFINE SHARED VARIABLE hWenController AS HANDLE NO-UNDO.

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

DEFINE BUTTON btarquivo-imp 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btDir 
     IMAGE-UP FILE "image/im-open.gif":U
     LABEL "btdirweb 2" 
     SIZE 4.29 BY 1.

DEFINE VARIABLE fn-arq-importacao AS CHARACTER FORMAT "X(256)":U 
     LABEL "Arquivo" 
     VIEW-AS FILL-IN 
     SIZE 62 BY .88 NO-UNDO.

DEFINE VARIABLE fn-cod-estab-fim AS CHARACTER FORMAT "x(3)" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE fn-cod-estab-ini AS CHARACTER FORMAT "x(3)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE fn-dir-importacao AS CHARACTER FORMAT "X(256)":U 
     LABEL "Diret¢rio" 
     VIEW-AS FILL-IN 
     SIZE 62 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83 BY 3.46.

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
         SIZE 90 BY 16.92
         FONT 1.

DEFINE FRAME fPage4
     fn-cod-estab-ini AT ROW 4.13 COL 28.29 COLON-ALIGNED WIDGET-ID 10
     fn-cod-estab-fim AT ROW 4.13 COL 47.29 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     fn-arq-importacao AT ROW 9.63 COL 10.43 COLON-ALIGNED
     btarquivo-imp AT ROW 9.54 COL 74.43 HELP
          "Escolha o arquivo de modelo"
     fn-dir-importacao AT ROW 10.75 COL 10.43 COLON-ALIGNED WIDGET-ID 124
     btDir AT ROW 10.67 COL 74.43 WIDGET-ID 122
     "Importaá∆o NFS-e" VIEW-AS TEXT
          SIZE 13 BY .54 AT ROW 8.5 COL 4
     RECT-16 AT ROW 8.75 COL 2
     IMAGE-9 AT ROW 4.13 COL 38.14 WIDGET-ID 12
     IMAGE-10 AT ROW 4.13 COL 46.29 WIDGET-ID 6
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
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.46
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
         HEIGHT             = 16.92
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
ASSIGN FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage4
   Custom                                                               */
ASSIGN 
       btarquivo-imp:HIDDEN IN FRAME fPage4           = TRUE.

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

  IF  VALID-HANDLE(h-espnfse2006a) THEN DO:
      DELETE PROCEDURE h-espnfse2006a.
      ASSIGN h-espnfse2006a = ?.
  END.

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


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btarquivo-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btarquivo-imp wReport
ON CHOOSE OF btarquivo-imp IN FRAME fPage4
DO:
    def var cFile as char no-undo.
    def var l-ok  as logical no-undo.

    assign fn-arq-importacao = replace(input frame {&frame-name} fn-arq-importacao, "/", "\").
    SYSTEM-DIALOG GET-FILE cFile
       FILTERS "*.txt" "*.txt",
               "*.*" "*.*"
       DEFAULT-EXTENSION "txt"
       INITIAL-DIR "modelos" 
       MUST-EXIST
       USE-FILENAME
       UPDATE l-ok.
    if  l-ok = yes then
        assign fn-arq-importacao:screen-value in frame {&frame-name}  = replace(cFile, "\", "/"). 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wReport
ON CHOOSE OF btCancel IN FRAME fpage0 /* Fechar */
DO:
    IF  VALID-HANDLE(h-espnfse2006a) THEN DO:
        DELETE PROCEDURE h-espnfse2006a.
        ASSIGN h-espnfse2006a = ?.
    END.

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
        ASSIGN fn-dir-importacao:SCREEN-VALUE IN FRAME fPage4 = c-nom-dir.
        APPLY 'leave' TO fn-dir-importacao IN FRAME fPage4.
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
&Scoped-define SELF-NAME fn-arq-importacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fn-arq-importacao wReport
ON LEAVE OF fn-arq-importacao IN FRAME fPage4 /* Arquivo */
DO:
    IF  SELF:SCREEN-VALUE <> "" THEN
        ASSIGN fn-dir-importacao:SCREEN-VALUE IN FRAME fPage4 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fn-dir-importacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fn-dir-importacao wReport
ON LEAVE OF fn-dir-importacao IN FRAME fPage4 /* Diret¢rio */
DO:
    ASSIGN INPUT FRAME fPage4 fn-dir-importacao.

    IF  fn-dir-importacao <> "" THEN DO:

        IF  NOT SUBSTRING(fn-dir-importacao,LENGTH(fn-dir-importacao),1) = "\" AND
            NOT SUBSTRING(fn-dir-importacao,LENGTH(fn-dir-importacao),1) = "/" THEN
            ASSIGN SUBSTRING(fn-dir-importacao,LENGTH(fn-dir-importacao) + 1,1) = "\".
    END.

    DISP fn-dir-importacao WITH FRAME fPage4.

    IF  SELF:SCREEN-VALUE <> "" THEN
        ASSIGN fn-arq-importacao:SCREEN-VALUE IN FRAME fPage4 = "".
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

&IF DEFINED(PGIMP) <> 0 AND "{&PGIMP}":U = "YES":U &THEN
/*:T** Relatorio ***/
do on error undo, return error on stop  undo, return error:
    {report/rpexa.i}

    /*15/02/2005 - tech1007 - Teste alterado pois RTF n∆o Ç mais opá∆o de Destino*/
    if input frame fPage6 rsDestiny = 2 and
       input frame fPage6 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage6 cFile).
        
        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show":U, input 73, input "":U).
            apply "ENTRY":U to cFile in frame fPage6.
            return error.
        end.
    end.
    
    /*16/02/2005 - tech1007 - Teste alterado para validar o modelo informado quando for RTF*/
    
    /*:T Coloque aqui as validaá‰es da p†gina de Digitaá∆o, lembrando que elas devem
       apresentar uma mensagem de erro cadastrada, posicionar nesta p†gina e colocar
       o focus no campo com problemas */
    /*browse brDigita:SET-REPOSITIONED-ROW (browse brDigita:DOWN, "ALWAYS":U).*/
    
    
    /*:T Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p†gina com 
       problemas e colocar o focus no campo com problemas */
    ASSIGN INPUT FRAME fPage4 fn-dir-importacao.
    ASSIGN INPUT FRAME fPage4 fn-arq-importacao.

    IF  fn-dir-importacao <> "" AND
        fn-arq-importacao <> "" THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 17006,
                           INPUT "Apenas um campo deve ser informado: Arquivo ou Diret¢rio!" + "~~" + "Apenas uma informaá∆o deve ser informada para a importaá∆o, um Arquivo ou um Diret¢rio. Se os campos permanecerem em branco, ser† utilizado o diret¢rio padr∆o de importaá∆o conforme ESPNFSE2040.").
        RETURN ERROR.
    END.

    IF  fn-dir-importacao <> "" THEN DO:
        
        OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "espnfse2010.001").
        OUTPUT CLOSE.
        OS-COPY VALUE(SESSION:TEMP-DIRECTORY + "espnfse2010.001") VALUE(fn-dir-importacao + "espnfse2010.001").

        IF  OS-ERROR <> 0 THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "Diret¢rio de importaá∆o inv†lido!" + "~~" + "Favor, informar um diret¢rio v†lido (existente e com permiss∆o de leitura). Se este campo permanecer em branco, ser† utilizado o diret¢rio padr∆o de importaá∆o conforme ESPNFSE2040.").
            RETURN ERROR.
        END.
    END.

    IF  fn-arq-importacao <> "" THEN DO:

        IF  R-INDEX(fn-arq-importacao,".") <> 0 THEN DO:
            IF  SEARCH(INPUT FRAME fPage4 fn-arq-importacao) = ? THEN DO:
                RUN utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 17006,
                                   INPUT "Arquivo de importaá∆o n∆o encontrado!":U + "~~" + "Favor, informar um arquivo v†lido. Se n∆o informar um arquivo espec°fico, ser∆o importados todos os arquivos do diret¢rio padr∆o de importaá∆o conforme ESPNFSE2040":U).
                RETURN ERROR.
            END.
        END.
    END.

    /*:T Aqui s∆o gravados os campos da temp-table que ser† passada como parÉmetro
       para o programa RP.P */
    
    CREATE tt-param.
    ASSIGN tt-param.usuario         = c-seg-usuario
           tt-param.destino         = INPUT FRAME fPage6 rsDestiny
           tt-param.data-exec       = TODAY
           tt-param.hora-exec       = TIME
           tt-param.arquivo-imp     = INPUT FRAME fpage4 fn-arq-importacao
           tt-param.diretorio-imp   = INPUT FRAME fPage4 fn-dir-importacao
           tt-param.cod-estabel-ini = INPUT FRAME fPage4 fn-cod-estab-ini
           tt-param.cod-estabel-fim = INPUT FRAME fPage4 fn-cod-estab-fim.
    
    if tt-param.destino = 1
    then
        assign tt-param.arquivo = "":U.
    else if  tt-param.destino = 2
        then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
    /*:T Coloque aqui a l¢gica de gravaá∆o dos demais campos que devem ser passados
       como parÉmetros para o programa RP.P, atravÇs da temp-table tt-param */
    
    /*:T Executar do programa RP.P que ir† criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i rpp/espnfse2030rp.p}
    
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
            
    /*:T Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas
       devem apresentar uma mensagem de erro cadastrada, posicionar na p†gina 
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

    /*:T Coloque aqui a l¢gica de gravaá∆o dos parÉmtros e seleá∆o na temp-table
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

