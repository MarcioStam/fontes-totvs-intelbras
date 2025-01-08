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
 {include/i-prgvrs.i ESFTP020 2.04.00.000} 

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESFTP020
&GLOBAL-DEFINE Version        1
&GLOBAL-DEFINE VersionLayout  1

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Seleá∆o,ParÉmetros,Impress∆o

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page4Widgets   
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo

&GLOBAL-DEFINE page2Fields    ficod-estabel fiNotaFiscalIni ~
                              da-data-ini da-data-fim rs-opcao fiSerieIni fi-cod-emitente c-desc-cliente ~
                              fi-periodo-ini fi-periodo-fim fi-estab fi-serie fi-it-codigo-ini fi-it-codigo-fim
&GLOBAL-DEFINE page4Fields    fiIdioma tg-excel tg-solar
&GLOBAL-DEFINE page6Fields    cFile

/* Parameters Definitions ---                                           */

{esp\ftp\esftp020tt.i}
{upc\btb910za-upc.i}
/* Transfer Definitions */

define buffer b-tt-digita for tt-digita.

def var raw-param        as raw no-undo.

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.

def stream s-imp.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

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

DEFINE VARIABLE c-desc-cliente AS CHARACTER FORMAT "X(35)":U 
     VIEW-AS FILL-IN 
     SIZE 36.29 BY .88 NO-UNDO.

DEFINE VARIABLE da-data-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE da-data-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Data" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-emitente AS INTEGER FORMAT ">>>>>>9" INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88.

DEFINE VARIABLE fi-estab AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-it-codigo-fim AS CHARACTER FORMAT "X(15)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-it-codigo-ini AS CHARACTER FORMAT "X(15)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-periodo-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-periodo-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Data" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-serie AS CHARACTER FORMAT "X(256)":U 
     LABEL "Serie" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE ficod-estabel AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fiNotaFiscalIni AS CHARACTER FORMAT "X(16)" 
     LABEL "Nota Fiscal":R17 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiserieini AS CHARACTER FORMAT "x(5)" 
     LABEL "SÇrie":R7 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88
     FONT 1 NO-UNDO.

DEFINE IMAGE IMAGE-3
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
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

DEFINE VARIABLE rs-opcao AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Por Nota", 1,
"Por Cliente", 2,
"Por Periodo", 3
     SIZE 32.29 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 67 BY 3.58.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 67 BY 3.33.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 67 BY 4.42.

DEFINE VARIABLE fiIdioma AS CHARACTER FORMAT "X(256)":U INITIAL "Portuguàs" 
     LABEL "Idioma" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Portuguàs","Portuguàs",
                     "Espanhol","Espanhol"
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE tg-excel AS LOGICAL INITIAL no 
     LABEL "Gerar arquivo excel" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.

DEFINE VARIABLE tg-solar AS LOGICAL INITIAL no 
     LABEL "Busca NS Solar" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.

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
     SIZE 27.72 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 1.71.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 17.46 COL 2
     btCancel AT ROW 17.46 COL 13
     btHelp2 AT ROW 17.46 COL 80
     rtToolBar AT ROW 17.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 91 BY 17.79
         FONT 1.

DEFINE FRAME fPage2
     rs-opcao AT ROW 1.17 COL 30.72 NO-LABEL WIDGET-ID 4
     ficod-estabel AT ROW 2.75 COL 35.72 COLON-ALIGNED WIDGET-ID 2
     fiNotaFiscalIni AT ROW 3.75 COL 35.72 COLON-ALIGNED HELP
          "N£mero da nota fiscal"
     fiserieini AT ROW 4.75 COL 35.72 COLON-ALIGNED HELP
          "SÇrie da nota fiscal"
     fi-cod-emitente AT ROW 7 COL 24.72 COLON-ALIGNED WIDGET-ID 12
     c-desc-cliente AT ROW 7 COL 36.72 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     da-data-ini AT ROW 8.04 COL 24.72 COLON-ALIGNED WIDGET-ID 22
     da-data-fim AT ROW 8.04 COL 44.43 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     fi-periodo-ini AT ROW 10.5 COL 24.72 COLON-ALIGNED WIDGET-ID 60
     fi-periodo-fim AT ROW 10.5 COL 44.43 COLON-ALIGNED NO-LABEL WIDGET-ID 58
     fi-estab AT ROW 11.46 COL 24.72 COLON-ALIGNED WIDGET-ID 66
     fi-serie AT ROW 12.42 COL 24.72 COLON-ALIGNED WIDGET-ID 68
     fi-it-codigo-ini AT ROW 13.42 COL 24.72 COLON-ALIGNED WIDGET-ID 70
     fi-it-codigo-fim AT ROW 13.42 COL 44.57 COLON-ALIGNED NO-LABEL WIDGET-ID 76
     "Per°odo" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 10 COL 11 WIDGET-ID 56
     "Nota Fiscal:" VIEW-AS TEXT
          SIZE 9.86 BY .54 AT ROW 2.13 COL 10.86 WIDGET-ID 16
     "Cliente:" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 6.25 COL 10.72 WIDGET-ID 18
     RECT-10 AT ROW 2.42 COL 9.72 WIDGET-ID 8
     RECT-11 AT ROW 6.5 COL 9.72 WIDGET-ID 14
     IMAGE-3 AT ROW 8.04 COL 39.57 WIDGET-ID 50
     IMAGE-4 AT ROW 8.04 COL 43 WIDGET-ID 52
     RECT-12 AT ROW 10.21 COL 9.72 WIDGET-ID 54
     IMAGE-5 AT ROW 10.5 COL 39.57 WIDGET-ID 62
     IMAGE-6 AT ROW 10.5 COL 43 WIDGET-ID 64
     IMAGE-7 AT ROW 13.42 COL 39.57 WIDGET-ID 72
     IMAGE-8 AT ROW 13.42 COL 43 WIDGET-ID 74
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.29 BY 14.21
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.29 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     btConfigImpr AT ROW 3.58 COL 43.29 HELP
          "Configuraá∆o da impressora"
     btFile AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
     cFile AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 5.75 COL 3 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 14.21
         FONT 1.

DEFINE FRAME fPage4
     fiIdioma AT ROW 3.5 COL 32 COLON-ALIGNED
     tg-excel AT ROW 5 COL 34 WIDGET-ID 2
     tg-solar AT ROW 5.96 COL 34 WIDGET-ID 4
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 14.21
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
         HEIGHT             = 17.79
         WIDTH              = 91
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
ASSIGN FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
ASSIGN 
       c-desc-cliente:READ-ONLY IN FRAME fPage2        = TRUE.

/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FRAME fPage6
                                                                        */
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
&Scoped-define SELF-NAME fi-cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-emitente wReport
ON F5 OF fi-cod-emitente IN FRAME fPage2 /* Cliente */
DO:
   assign l-implanta = no.
    {include/zoomvar.i &prog-zoom="adzoom/z01ad098.w"
                     &campo=fi-cod-emitente
                     &campozoom=cod-emitente
                     &campo2=c-desc-cliente
                     &campozoom2=nome-emit}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-emitente wReport
ON LEAVE OF fi-cod-emitente IN FRAME fPage2 /* Cliente */
DO:
    
    FOR FIRST emitente 
        WHERE emitente.cod-emitente = int(fi-cod-emitente:SCREEN-VALUE IN FRAME FPage2) NO-LOCK:

        ASSIGN c-desc-cliente:screen-value in frame fPage2 = emitente.nome-emit.

    END.
    
    IF  NOT AVAIL emitente THEN 
        ASSIGN c-desc-cliente:screen-value in frame fPage2 = "".
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-emitente wReport
ON MOUSE-SELECT-DBLCLICK OF fi-cod-emitente IN FRAME fPage2 /* Cliente */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-opcao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-opcao wReport
ON VALUE-CHANGED OF rs-opcao IN FRAME fPage2
DO:

    DO WITH FRAME fpage2:
        IF  rs-opcao:SCREEN-VALUE = "1" THEN
            ASSIGN ficod-estabel:SENSITIVE    = YES
                   fiNotaFiscalIni:SENSITIVE  = YES
                   fiserieini:SENSITIVE       = YES
                   fi-cod-emitente:SENSITIVE  = NO
                   da-data-ini:SENSITIVE      = NO
                   da-data-fim:SENSITIVE      = NO
                   fi-periodo-ini:SENSITIVE   = NO
                   fi-periodo-fim:SENSITIVE   = NO
                   fi-estab:SENSITIVE         = NO
                   fi-serie:SENSITIVE         = NO
                   fi-it-codigo-ini:SENSITIVE = NO
                   fi-it-codigo-fim:SENSITIVE = NO.
        ELSE IF rs-opcao:SCREEN-VALUE = "2" THEN 
            ASSIGN ficod-estabel:SENSITIVE   = NO
                   fiNotaFiscalIni:SENSITIVE = NO
                   fiserieini:SENSITIVE      = NO
                   fi-cod-emitente:SENSITIVE = YES
                   da-data-ini:SENSITIVE     = YES
                   da-data-fim:SENSITIVE     = YES
                   fi-periodo-ini:SENSITIVE  = NO
                   fi-periodo-fim:SENSITIVE  = NO
                   fi-estab:SENSITIVE        = NO
                   fi-serie:SENSITIVE        = NO
                   fi-it-codigo-ini:SENSITIVE = NO
                   fi-it-codigo-fim:SENSITIVE = NO.
        ELSE
            ASSIGN ficod-estabel:SENSITIVE   = NO
                   fiNotaFiscalIni:SENSITIVE = NO
                   fiserieini:SENSITIVE      = NO
                   fi-cod-emitente:SENSITIVE = NO
                   da-data-ini:SENSITIVE     = NO
                   da-data-fim:SENSITIVE     = NO
                   fi-periodo-ini:SENSITIVE  = YES
                   fi-periodo-fim:SENSITIVE  = YES
                   fi-estab:SENSITIVE        = YES
                   fi-serie:SENSITIVE        = YES
                   fi-it-codigo-ini:SENSITIVE = YES
                   fi-it-codigo-fim:SENSITIVE = YES.

    END.

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


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{report/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterEnableFields wReport 
PROCEDURE AfterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
/*
DO WITH FRAME fPage6:
    APPLY 'value-changed' TO rsDestiny.
    ASSIGN rsDestiny:SENSITIVE = NO.
END.
*/    

APPLY "value-changed" TO rs-opcao IN FRAME fpage2.
ASSIGN da-data-ini:SCREEN-VALUE IN FRAME fpage2    = STRING(TODAY)
       da-data-fim:SCREEN-VALUE IN FRAME fpage2    = STRING("31/12/2099")
       fi-periodo-ini:SCREEN-VALUE IN FRAME fpage2 = STRING(TODAY)
       fi-periodo-fim:SCREEN-VALUE IN FRAME fpage2 = STRING("31/12/2099").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeInitializeInterface wReport 
PROCEDURE BeforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
    ASSIGN rsDestiny       = 1
           cFile           = "exp-zebra:Sem Layout"
           fiNrEmbarqueFim = 9999999
           fiNrNotaFisFim  = "ZZZZZZZZZZZZZZZZ"
           fiItCodigoFim   = "ZZZZZZZZZZZZZZZZ"
           fiNrVolumeFim   = 9999999.
*/
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

DEF VAR c-nom-arq-excel AS CHAR     NO-UNDO.

/*:T** Relatorio ***/
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
    IF  INPUT FRAME fPage2 da-data-fim < INPUT FRAME fPage2 da-data-ini 
    AND int(INPUT FRAME fPage2 rs-opcao) = 2   THEN DO:
        run utp/ut-msgs.p (input "show":U, input 17006, input "Data inicial maior que a final":U).
        apply "ENTRY":U to cFile in frame fPage6.
        return error.

    END.


    /*:T Aqui s∆o gravados os campos da temp-table que ser† passada como parÉmetro
       para o programa RP.P */
    
    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame fPage6 rsDestiny
           tt-param.data-exec       = today
           tt-param.hora-exec       = time
           tt-param.rs-opcao        = int(INPUT FRAME fPage2 rs-opcao)
           tt-param.fi-cod-emitente = INPUT FRAME fPage2 fi-cod-emitente
           tt-param.da-data-ini     = INPUT FRAME fPage2 da-data-ini
           tt-param.da-data-fim     = INPUT FRAME fPage2 da-data-fim
           tt-param.nr-nota-fis-ini = INPUT FRAME fPage2 fiNotaFiscalIni
           tt-param.serie-ini       = INPUT FRAME fPage2 fiSerieIni
           tt-param.i-idioma        = IF INPUT FRAME fpage4 fiIdioma = "Portuguàs" THEN 1 ELSE 2
           tt-param.cod-estabel     = INPUT FRAME fPage2 ficod-estabel
           tt-param.gera-excel      = INPUT FRAME fpage4 tg-excel
           tt-param.da-periodo-ini  = input frame fpage2 fi-periodo-ini
           tt-param.da-periodo-fim  = input frame fpage2 fi-periodo-fim
           tt-param.cod-estab-per   = input frame fpage2 fi-estab
           tt-param.serie-per       = input frame fpage2 fi-serie
           tt-param.it-codigo-ini   = input frame fpage2 fi-it-codigo-ini
           tt-param.it-codigo-fim   = input frame fpage2 fi-it-codigo-fim
           tt-param.busca-solar     = INPUT FRAME fpage4 tg-solar   
               
           .
          
    ASSIGN c-nom-arq-excel = "esftp020_" + string(REPLACE(STRING(TODAY, "99/99/9999"),"/","-")) + "_" + STRING(TIME) + ".xlsx".

    if tt-param.destino = 1 THEN
    
        assign tt-param.arquivo = "":U
               tt-param.arquivo-excel = "":u.
    
    else if  tt-param.destino = 2 then DO:
        assign tt-param.arquivo       = input frame fPage6 cFile.

        /* --------------------Arquivo excel------------------------ */
        DEF VAR i-pos           AS INTEGER  NO-UNDO.
        DEF VAR i               AS INTEGER NO-UNDO.

        DO  i = 1 TO LENGTH (tt-param.arquivo):
            IF  SUBSTR(tt-param.arquivo, i, 1) = "/" THEN
                i-pos = i.
        END.
        IF  i-pos = 0 THEN
            DO  i = 1 TO LENGTH (tt-param.arquivo):
            IF  SUBSTR(tt-param.arquivo, i, 1) = "\" THEN
                i-pos = i.
            END.

        ASSIGN tt-param.arquivo-excel = SUBSTR(tt-param.arquivo, 1, i-pos) + c-nom-arq-excel
               tt-param.arquivo-excel = REPLACE(tt-param.arquivo-excel, "/", "\").
        
    END.
    else 
        assign tt-param.arquivo       = session:temp-directory + c-programa-mg97 + ".tmp":U
               tt-param.arquivo-excel = session:temp-directory + c-nom-arq-excel.
    
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i esp\ftp\esftp020rp.p}
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

