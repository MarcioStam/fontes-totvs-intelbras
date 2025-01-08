&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCPP084 2.00.00.000}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */



CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCPP084  
&GLOBAL-DEFINE Version        2.00.00.000
&GLOBAL-DEFINE VersionLayout  

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
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page4Widgets   btInputFile
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution
&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page4Text      text-entrada
&GLOBAL-DEFINE page6Text      text-destino text-modo 

&GLOBAL-DEFINE page2Fields    fi-cod-estabel fi-cod-prod fi-data-ini fi-data-fim fi-componente fi-cod-falha fi-origem-falha
&GLOBAL-DEFINE page4Fields    cInputFile tg-produ
&GLOBAL-DEFINE page6Fields    cFile 

/* Parameters Definitions ---                                           */

{esp/cpp/escpp084.i}

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
DEF VAR c-modelo-default   AS CHAR    NO-UNDO.

def stream s-imp.

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est† rodando no WebEnabler*/
DEFINE SHARED VARIABLE hWenController AS HANDLE NO-UNDO.

{esp/es0018.i}

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE      NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE l-implanta     AS LOGICAL.

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
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&Executar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE fi-cod-estabel AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-cod-falha AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Falha" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE fi-cod-prod AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Produto" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-componente AS CHARACTER FORMAT "x(16)" 
     LABEL "Componente" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-data-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/2999 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-data-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/14 
     LABEL "Per°odo" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-desc-componente AS CHARACTER FORMAT "x(50)" 
     VIEW-AS FILL-IN 
     SIZE 46.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-estabel AS CHARACTER FORMAT "x(50)" 
     VIEW-AS FILL-IN 
     SIZE 53.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-falha AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-origem AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-prod AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-origem-falha AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Origem" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE BUTTON btInputFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cInputFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE text-entrada AS CHARACTER FORMAT "X(256)":U INITIAL "Arquivo de Sa°da" 
      VIEW-AS TEXT 
     SIZE 12.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-produ AS CHARACTER FORMAT "X(256)":U INITIAL "Produá∆o" 
      VIEW-AS TEXT 
     SIZE 12.86 BY .63
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 2.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 2.

DEFINE VARIABLE tg-produ AS LOGICAL INITIAL no 
     LABEL "Acompanhamento Defeitos X Componentes" 
     VIEW-AS TOGGLE-BOX
     SIZE 31.86 BY .83 NO-UNDO.

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

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.14 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execuá∆o" 
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
     SIZE 27.86 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 1.71.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.14 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     cFile AT ROW 3.63 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btFile AT ROW 3.5 COL 43 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.5 COL 43 HELP
          "Configuraá∆o da impressora"
     rsExecution AT ROW 6 COL 2.86 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5.25 COL 1.14 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.5 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     fi-cod-estabel AT ROW 2 COL 9 WIDGET-ID 10
     fi-cod-prod AT ROW 3 COL 14.86
     fi-componente AT ROW 4 COL 19 COLON-ALIGNED WIDGET-ID 14
     fi-desc-componente AT ROW 4 COL 34.43 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     fi-cod-falha AT ROW 5 COL 19 COLON-ALIGNED WIDGET-ID 22
     fi-desc-falha AT ROW 5 COL 25.43 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     fi-data-ini AT ROW 7 COL 14.71 WIDGET-ID 4
     fi-data-fim AT ROW 7 COL 43.14 NO-LABEL WIDGET-ID 2
     fi-desc-estabel AT ROW 2 COL 27.43 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     fi-desc-prod AT ROW 3 COL 34.43 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     fi-origem-falha AT ROW 6 COL 19 COLON-ALIGNED WIDGET-ID 64
     fi-desc-origem AT ROW 6 COL 25.43 COLON-ALIGNED NO-LABEL WIDGET-ID 66
     IMAGE-3 AT ROW 7 COL 36.43 WIDGET-ID 6
     IMAGE-4 AT ROW 7 COL 39.86 WIDGET-ID 8
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage4
     tg-produ AT ROW 3 COL 4.14 WIDGET-ID 6
     cInputFile AT ROW 5.54 COL 4.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btInputFile AT ROW 5.54 COL 44.14 HELP
          "Escolha do nome do arquivo"
     text-produ AT ROW 2.13 COL 5.14 NO-LABEL WIDGET-ID 4
     text-entrada AT ROW 4.5 COL 5.14 NO-LABEL
     RECT-12 AT ROW 4.75 COL 3
     RECT-13 AT ROW 2.42 COL 3 WIDGET-ID 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1 WIDGET-ID 100.


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

{report/report.i}

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
   Custom                                                               */
/* SETTINGS FOR FILL-IN fi-cod-estabel IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-cod-prod IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-data-fim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-data-ini IN FRAME fPage2
   ALIGN-L                                                              */
ASSIGN 
       fi-desc-componente:READ-ONLY IN FRAME fPage2        = TRUE.

ASSIGN 
       fi-desc-estabel:READ-ONLY IN FRAME fPage2        = TRUE.

ASSIGN 
       fi-desc-falha:READ-ONLY IN FRAME fPage2        = TRUE.

ASSIGN 
       fi-desc-origem:READ-ONLY IN FRAME fPage2        = TRUE.

/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FILL-IN text-entrada IN FRAME fPage4
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-entrada:PRIVATE-DATA IN FRAME fPage4     = 
                "Arquivo de Entrada".

/* SETTINGS FOR FILL-IN text-produ IN FRAME fPage4
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-produ:PRIVATE-DATA IN FRAME fPage4     = 
                "Produá∆o".

/* SETTINGS FOR FRAME fPage6
   Custom                                                               */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execuá∆o".

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


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btInputFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btInputFile wReport
ON CHOOSE OF btInputFile IN FRAME fPage4
DO:
    /*{report/imarq.i cInputFile fPage4}*/

    /*****************************************************************/

    def var cConvFile  as char no-undo.

    assign cConvFile = replace(input frame fPage4 cInputFile, "/":U, "~\":U).

    SYSTEM-DIALOG GET-FILE cConvFile
       FILTERS "*.xlsx":U "*.xlsx":U
       &IF 'cInputFile' <> 'cInputFile' &THEN
           ASK-OVERWRITE
           SAVE-AS
       &ENDIF
       DEFAULT-EXTENSION "xlsx":U
       INITIAL-DIR "spool":U 
       USE-FILENAME
       UPDATE l-ok.
    if  l-ok = yes then do:
        assign cInputFile = replace(cConvFile, "~\":U, "/":U).
        display cInputFile with frame fPage4.
    end.
     
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


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME fi-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel wReport
ON F5 OF fi-cod-estabel IN FRAME fPage2 /* Estabelecimento */
DO:
      {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                      &campo="fi-cod-estabel"
                      &campozoom="cod-estabel"
                      &campo2="fi-desc-estabel"
                      &campozoom2="nome"
                      &frame="fPage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel wReport
ON LEAVE OF fi-cod-estabel IN FRAME fPage2 /* Estabelecimento */
DO:
  
  FIND estabelec NO-LOCK
      WHERE estabelec.cod-estabel = fi-cod-estabel:SCREEN-VALUE IN FRAME fpage2 NO-ERROR.

  IF  AVAIL estabelec THEN
      ASSIGN fi-desc-estabel:SCREEN-VALUE IN FRAME fpage2 = estabele.nome.
  ELSE
      ASSIGN fi-desc-estabel:SCREEN-VALUE IN FRAME fpage2 = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cod-estabel IN FRAME fPage2 /* Estabelecimento */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-falha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-falha wReport
ON F5 OF fi-cod-falha IN FRAME fPage2 /* Falha */
DO:
    /*
   {include/zoomvar.i &prog-zoom="eszoom/z01es654.w"
                      &campo="fi-cod-falha"
                      &campozoom="cod-falha"
                      &frame="fPage2"
                      &campo2="fi-desc-falha"
                      &campozoom2="descricao"
                      &frame2="fPage2"}
    */                  

   {method/ZoomFields.i
          &ProgramZoom="eszoom/z01es654.w"
          &FieldZoom1="cod-falha"
          &FieldScreen1="fi-cod-falha"
          &Frame1="fPage2"
          &FieldZoom2="descricao"
          &FieldScreen2="fi-desc-falha"
          &Frame2="fPage2"
          &EnableImplant="no"}








END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-falha wReport
ON LEAVE OF fi-cod-falha IN FRAME fPage2 /* Falha */
DO:
  FIND FIRST falha-mqa NO-LOCK
      WHERE falha-mqa.cod-falha = INT(fi-cod-falha:SCREEN-VALUE IN FRAME fpage2) NO-ERROR.
  IF  AVAIL falha-mqa THEN
      ASSIGN fi-desc-falha:SCREEN-VALUE IN FRAME fpage2 = falha-mqa.descricao.
  ELSE
      ASSIGN fi-desc-falha:SCREEN-VALUE IN FRAME fpage2 = "".

  IF  int(fi-cod-falha:SCREEN-VALUE IN FRAME fpage2) = 0 THEN
      ASSIGN fi-desc-falha:SCREEN-VALUE IN FRAME fpage2 = "Todas".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-falha wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cod-falha IN FRAME fPage2 /* Falha */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-prod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-prod wReport
ON LEAVE OF fi-cod-prod IN FRAME fPage2 /* Produto */
DO:
    FOR FIRST item-mqa NO-LOCK              
        WHERE item-mqa.cod-prod    = int(fi-cod-prod:SCREEN-VALUE IN FRAME fpage2)
          AND item-mqa.cod-estabel = fi-cod-estabel:SCREEN-VALUE IN FRAME fpage2:

        ASSIGN fi-desc-prod:SCREEN-VALUE IN FRAME fPage2 = item-mqa.descricao.

    END.  

    IF INPUT fi-cod-prod:SCREEN-VALUE IN FRAME fpage2 = "0"
    THEN ASSIGN tg-produ:SENSITIVE IN FRAME fpage4   = YES. 
    ELSE ASSIGN tg-produ:SENSITIVE IN FRAME fpage4   = NO
                tg-produ:SCREEN-VALUE IN FRAME fpage4 = "no". 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-componente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-componente wReport
ON F5 OF fi-componente IN FRAME fPage2 /* Componente */
DO:
        {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                       &campo="fi-componente"
                       &campozoom="it-codigo"
                       &campo2="fi-desc-componente"
                       &campozoom2="desc-item"
                       &frame="fPage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-componente wReport
ON LEAVE OF fi-componente IN FRAME fPage2 /* Componente */
DO:
  FIND ITEM NO-LOCK
      WHERE ITEM.it-codigo = fi-componente:SCREEN-VALUE IN FRAME fpage2 NO-ERROR.

  IF  AVAIL ITEM THEN
      ASSIGN fi-desc-componente:SCREEN-VALUE IN FRAME fpage2 = ITEM.desc-item.
  ELSE
      ASSIGN fi-desc-componente:SCREEN-VALUE IN FRAME fpage2 = "".

  IF  fi-componente:SCREEN-VALUE IN FRAME fpage2 = "" THEN
      ASSIGN fi-desc-componente:SCREEN-VALUE IN FRAME fpage2 = "Todos".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-componente wReport
ON MOUSE-SELECT-DBLCLICK OF fi-componente IN FRAME fPage2 /* Componente */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-origem-falha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-origem-falha wReport
ON F5 OF fi-origem-falha IN FRAME fPage2 /* Origem */
DO:
    /*
   {include/zoomvar.i &prog-zoom="eszoom/z01es654.w"
                      &campo="fi-cod-falha"
                      &campozoom="cod-falha"
                      &frame="fPage2"
                      &campo2="fi-desc-falha"
                      &campozoom2="descricao"
                      &frame2="fPage2"}
    */                  

   {method/ZoomFields.i
          &ProgramZoom="eszoom/z01es659.w"
          &FieldZoom1="origem-falha"
          &FieldScreen1="fi-origem-falha"
          &Frame1="fPage2"
          &FieldZoom2="descricao"
          &FieldScreen2="fi-desc-origem"
          &Frame2="fPage2"
          &EnableImplant="no"}



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-origem-falha wReport
ON LEAVE OF fi-origem-falha IN FRAME fPage2 /* Origem */
DO:

    ASSIGN fi-desc-origem:SCREEN-VALUE IN FRAME fPage2 = "".

    FOR FIRST origem-mqa NO-LOCK
        WHERE origem-mqa.origem-falha = INT(fi-origem-falha:SCREEN-VALUE IN FRAME fpage2):

        ASSIGN fi-desc-origem:SCREEN-VALUE IN FRAME fPage2 = origem-mqa.descricao.

    END.

    IF  int(fi-origem-falha:SCREEN-VALUE IN FRAME fpage2) = 0 THEN
        ASSIGN fi-desc-origem:SCREEN-VALUE IN FRAME fpage2 = "Todas".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-origem-falha wReport
ON MOUSE-SELECT-DBLCLICK OF fi-origem-falha IN FRAME fPage2 /* Origem */
DO:
  APPLY "f5" TO SELF.
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
{report/mainblock.i}

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
&IF "{&RTF}":U = "YES":U &THEN
IF VALID-HANDLE(hWenController) THEN DO:
    ASSIGN l-habilitaRtf:sensitive IN FRAME fPage6 = NO
           l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "No"
           l-habilitaRtf = NO.
           
END.
RUN pi-habilitaRtf.
&endif
/*Fim alteracao 17/02/2005*/


EMPTY TEMP-TABLE tt-prog-ponto.
        
RUN esp/es0018p.p (INPUT "spool-win":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

FOR FIRST tt-prog-ponto:

    IF SUBSTRING(tt-prog-ponto.conteudo,LENGTH(tt-prog-ponto.conteudo),1) <> "\" THEN
        ASSIGN tt-prog-ponto.conteudo = tt-prog-ponto.conteudo + "\" + v_cod_usuar_corren + "\".

    OS-CREATE-DIR value(tt-prog-ponto.conteudo).

    ASSIGN tt-prog-ponto.conteudo = tt-prog-ponto.conteudo + "escpp084-" + string(TIME) + ".xlsx".

    ASSIGN cInputFile:SCREEN-VALUE IN FRAME fPage4 = tt-prog-ponto.conteudo.

END.

DO WITH FRAME fPage2:

    ASSIGN fi-data-ini:SCREEN-VALUE = string(TODAY)
           fi-data-fim:SCREEN-VALUE = string(TODAY).

END.

DO WITH FRAME fPage4:

    ASSIGN tg-produ:SENSITIVE    = NO
           tg-produ:SCREEN-VALUE = "no".
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-checa-dir wReport 
PROCEDURE pi-checa-dir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE i-aux AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-dir AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-erro AS LOGICAL     NO-UNDO.
    
    
    IF AVAIL tt-param THEN DO:
    
        ASSIGN c-dir = ""
               tt-param.saida-excel = REPLACE(tt-param.saida-excel, "/", "\").
        
        DO i-aux = 1 TO LENGTH(tt-param.saida-excel):
        
            IF SUBSTRING(tt-param.saida-excel, i-aux, 1) <> "\" THEN
                ASSIGN c-dir = c-dir + SUBSTRING(tt-param.saida-excel, i-aux, 1).
        
            IF SUBSTRING(tt-param.saida-excel, i-aux, 1) = "\" THEN DO:
        
                IF c-dir <> "" AND
                   index(c-dir, ":") = 0 THEN DO:
        
                    OS-CREATE-DIR VALUE(SUBSTRING(tt-param.saida-excel, 1, i-aux)).
        
                    ASSIGN l-erro = (OS-ERROR <> 0).
        
                END.
        
                ASSIGN c-dir = "".
        
            END.
        
        END.
        
        IF l-erro THEN DO:
        
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "N∆o foi poss°vel gerar os diret¢rios do caminho da sa°da excel.~~Verifique o caminho informado na sa°da excel e a permiss∆o dos diret¢rios precedentes.").

            RETURN "NOK":U.
        
        END.

    END.

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
    
    
    /*:T Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p†gina com 
       problemas e colocar o focus no campo com problemas */
    
    FIND estabelec NO-LOCK
        WHERE estabelec.cod-estabel = fi-cod-estabel:SCREEN-VALUE IN FRAME fpage2 NO-ERROR.
    IF  NOT AVAIL estabelec THEN DO:
        run utp/ut-msgs.p (input "show":U, input 17006, input "Estabelecimento informado n∆o existe":U).
        apply "ENTRY":U to fi-cod-estabel in frame fPage2.
        return NO-APPLY.
    END.

    FIND ITEM NO-LOCK
        WHERE ITEM.it-codigo = fi-componente:SCREEN-VALUE IN FRAME fpage2 NO-ERROR.
    IF  NOT AVAIL ITEM 
    AND fi-componente:SCREEN-VALUE IN FRAME fpage2 <> "" THEN DO:
        run utp/ut-msgs.p (input "show":U, input 17006, input "Componente informado n∆o existe":U).
        apply "ENTRY":U to fi-componente in frame fPage2.
        return NO-APPLY.
    END.
    
    FIND falha-mqa NO-LOCK
        WHERE falha-mqa.cod-falha = int(fi-cod-falha:SCREEN-VALUE IN FRAME fpage2) NO-ERROR.
    IF  NOT AVAIL falha-mqa 
    AND INT(fi-cod-falha:SCREEN-VALUE IN FRAME fpage2) <> 0 THEN DO:
        run utp/ut-msgs.p (input "show":U, input 17006, input "C¢digo de Falha informado n∆o existe":U).
        apply "ENTRY":U to fi-cod-falha in frame fPage2.
        return NO-APPLY.
    END.

    /*:T Aqui s∆o gravados os campos da temp-table que ser† passada como parÉmetro
       para o programa RP.P */
    
    create tt-param.
    assign tt-param.usuario          = c-seg-usuario
           tt-param.destino          = input frame fPage6 rsDestiny
           tt-param.data-exec        = today
           tt-param.hora-exec        = time
           tt-param.cod-estabel      = INPUT FRAME fpage2 fi-cod-estabel
           tt-param.cod-prod         = INPUT FRAME fpage2 fi-cod-prod
           tt-param.cod-componente   = INPUT FRAME fpage2 fi-componente
           tt-param.cod-falha        = INPUT FRAME fpage2 fi-cod-falha
           tt-param.origem-falha     = INPUT FRAME fpage2 fi-origem-falha
           tt-param.data-ini         = INPUT FRAME fPage2 fi-data-ini
           tt-param.data-fim         = INPUT FRAME fPage2 fi-data-fim
           tt-param.saida-excel      = INPUT FRAME fpage4 cInputFile
           tt-param.tg-produ         = INPUT FRAME fpage4 tg-produ.
    
    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "":U.
    else if  tt-param.destino = 2 
        then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
    /*:T Coloque aqui a l¢gica de gravaá∆o dos demais campos que devem ser passados
       como parÉmetros para o programa RP.P, atravÇs da temp-table tt-param */

    RUN pi-checa-dir.
    IF RETURN-VALUE = "NOK" THEN
        RETURN "NOK":U.
    
    /*:T Executar do programa RP.P que ir† criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i esp/cpp/escpp084rp.p}
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
end.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

