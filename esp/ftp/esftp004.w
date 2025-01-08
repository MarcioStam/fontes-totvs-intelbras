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
{include/i-prgvrs.i ESFTP004 2.04.00.002}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESFTP004
&GLOBAL-DEFINE Version        2.04.00.002
&GLOBAL-DEFINE VersionLayout  1

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Seleá∆o,ParÉmetros,Digitaá∆o,Impress∆o

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          YES
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page4Widgets   rsImprimeEtiqueta rsTipoImpressora rsTipoNota 
&GLOBAL-DEFINE page5Widgets   brDigita ~
                              btAdd ~
                              btUpdate ~
                              btDelete ~
                              btSave ~
                              btOpen
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page4Text      text-entrada text-entrada-2
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo

&GLOBAL-DEFINE page2Fields    fiItCodigoFim fiItCodigoIni fiNrNotaFisFim ~
                              fiNrNotaFisIni fiNrVolumeFim fiNrVolumeIni ~
                              fiNrEmbarqueIni fiNrEmbarqueFim ed-notas-desconsiderar ~
                              rsRastreabilidade rsTpVolume cb-reimpressao
&GLOBAL-DEFINE page4Fields    fiNome-transp-ini list-estado fi-uf-origem 
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile

/* Parameters Definitions ---                                           */

{esp\ftp\esftp004tt.i}
{upc\btb910za-upc.i}
{esp/es0018.i}
/* Transfer Definitions */

define buffer b-tt-digita for tt-digita.

def var raw-param        as raw no-undo.

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.

def stream s-imp.

DEF VAR c-lista AS CHAR NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

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
&Scoped-define FIELDS-IN-QUERY-brDigita tt-digita.nr-embarque tt-digita.dt-embarque tt-digita.identific   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDigita tt-digita.nr-embarque   
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

DEFINE VARIABLE ed-notas-desconsiderar AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 58 BY 3.96 NO-UNDO.

DEFINE VARIABLE fiItCodigoFim AS CHARACTER FORMAT "X(16)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiItCodigoIni AS CHARACTER FORMAT "X(16)":U 
     LABEL "Produto" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiNrEmbarqueFim AS INTEGER FORMAT ">>>>,>>9" INITIAL 999999 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiNrEmbarqueIni AS INTEGER FORMAT ">>>>,>>9" INITIAL 0 
     LABEL "Embarque":R10 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiNrNotaFisFim AS CHARACTER FORMAT "X(16)":U 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiNrNotaFisIni AS CHARACTER FORMAT "X(16)":U 
     LABEL "Nota Fiscal" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiNrVolumeFim AS INTEGER FORMAT ">>>>>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiNrVolumeIni AS INTEGER FORMAT ">>>>>>9":U INITIAL 0 
     LABEL "Volume" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88
     FONT 1 NO-UNDO.

DEFINE IMAGE IMAGE-19
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-20
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-21
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-23
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-24
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-25
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-26
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE rsRastreabilidade AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Com Rastreabilidade", 1,
"Sem Rastreabilidade", 2,
"Ambos", 3
     SIZE 43.72 BY .88 NO-UNDO.

DEFINE VARIABLE rsTpVolume AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Fracionada", 1,
"Fechada", 2,
"Ambos", 3
     SIZE 33.14 BY .88 NO-UNDO.

DEFINE VARIABLE cb-reimpressao AS LOGICAL INITIAL no 
     LABEL "Reimpress∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.

DEFINE VARIABLE fiNome-transp-ini AS CHARACTER FORMAT "X(256)":U 
     LABEL "Transportador" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE fi-uf-origem AS CHARACTER FORMAT "x(4)" 
     LABEL "UF Origem" 
     VIEW-AS FILL-IN 
     SIZE 8.14 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-entrada AS CHARACTER FORMAT "X(256)":U INITIAL "Imprimir etiquetas" 
      VIEW-AS TEXT 
     SIZE 14.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-entrada-2 AS CHARACTER FORMAT "X(256)":U INITIAL "Tipo Impressora" 
      VIEW-AS TEXT 
     SIZE 14.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsImprimeEtiqueta AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Com Endereáo", 1,
"Sem Endereáo", 2
     SIZE 19 BY 1.75 NO-UNDO.

DEFINE VARIABLE rsTipoImpressora AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Zebra 600", 1,
"Zebra 300", 2
     SIZE 19 BY 1.75 NO-UNDO.

DEFINE VARIABLE rsTipoNota AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Notas Com Embarque", 1,
"Notas Sem Embarque", 2
     SIZE 34 BY 1.75 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 28 BY 2.75.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 34 BY 2.75.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 63 BY 2.67.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 63 BY 1.58.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 63 BY 3.5.

DEFINE VARIABLE list-estado AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE SCROLLBAR-VERTICAL 
     SIZE 30 BY 3 TOOLTIP "Para selecionar mais de um estado deixe o CTRL pressionado" NO-UNDO.

DEFINE BUTTON btAdd 
     LABEL "Inserir" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btDelete 
     LABEL "Retirar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btOpen 
     LABEL "Recuperar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 15 BY 1
     FONT 1.

DEFINE BUTTON btUpdate 
     LABEL "Alterar" 
     SIZE 15 BY 1
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
          "Impressora", 1
     SIZE 44 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsExecution AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1
     SIZE 27.72 BY .92
     FONT 1 NO-UNDO.

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
      tt-digita.nr-embarque
      tt-digita.dt-embarque 
      tt-digita.identific
ENABLE
      tt-digita.nr-embarque
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 82 BY 8.75
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
         SIZE 91 BY 17
         FONT 1.

DEFINE FRAME fPage5
     brDigita AT ROW 1.25 COL 1
     btAdd AT ROW 10 COL 1
     btUpdate AT ROW 10 COL 16
     btDelete AT ROW 10 COL 31
     btSave AT ROW 10 COL 46
     btOpen AT ROW 10 COL 61
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.71
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.29 HELP
          "Destino de Impress∆o do Relat¢rio" NO-LABEL
     btFile AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.58 COL 43.29 HELP
          "Configuraá∆o da impressora"
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
         SIZE 84.43 BY 12.71
         FONT 1.

DEFINE FRAME fPage2
     fiNrEmbarqueIni AT ROW 1.5 COL 14.72 HELP
          "Embarque"
     fiNrEmbarqueFim AT ROW 1.5 COL 52.43 HELP
          "Embarque" NO-LABEL
     fiNrNotaFisIni AT ROW 2.5 COL 14.86
     fiNrNotaFisFim AT ROW 2.5 COL 52.43 NO-LABEL
     fiItCodigoIni AT ROW 3.5 COL 17.15
     fiItCodigoFim AT ROW 3.5 COL 52.43 NO-LABEL
     fiNrVolumeIni AT ROW 4.5 COL 17.43
     fiNrVolumeFim AT ROW 4.5 COL 52.43 NO-LABEL
     rsRastreabilidade AT ROW 5.5 COL 23.29 NO-LABEL
     rsTpVolume AT ROW 6.5 COL 23.29 NO-LABEL
     ed-notas-desconsiderar AT ROW 7.54 COL 23 NO-LABEL
     cb-reimpressao AT ROW 12.75 COL 33 WIDGET-ID 2
     "Itens:" VIEW-AS TEXT
          SIZE 4 BY .54 AT ROW 5.67 COL 19
     "Informe as notas separadas por virgula  ou por ifens quando for uma faixa." VIEW-AS TEXT
          SIZE 50 BY 1.25 AT ROW 11.5 COL 5
     "Volumes:" VIEW-AS TEXT
          SIZE 6.57 BY .54 AT ROW 6.67 COL 16.57
     "Notas a Desconsiderar:" VIEW-AS TEXT
          SIZE 16 BY 1 AT ROW 7.54 COL 7
     "Ex: 5300-5400,5725,5800,6000-6100" VIEW-AS TEXT
          SIZE 28 BY 1.25 AT ROW 11.5 COL 56
     IMAGE-19 AT ROW 2.5 COL 41
     IMAGE-20 AT ROW 2.5 COL 48.43
     IMAGE-21 AT ROW 3.5 COL 41
     IMAGE-22 AT ROW 3.5 COL 48.43
     IMAGE-23 AT ROW 4.5 COL 41
     IMAGE-24 AT ROW 4.5 COL 48.43
     IMAGE-25 AT ROW 1.5 COL 41
     IMAGE-26 AT ROW 1.5 COL 48.43
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.75
         SIZE 84.29 BY 13
         FONT 1.

DEFINE FRAME fPage4
     rsImprimeEtiqueta AT ROW 2.25 COL 21 NO-LABEL
     rsTipoImpressora AT ROW 2.25 COL 50.57 NO-LABEL
     rsTipoNota AT ROW 5 COL 21 NO-LABEL
     list-estado AT ROW 7.75 COL 29 HELP
          "Para selecionar mais de um estado deixe o CTRL pressionado" NO-LABEL
     fi-uf-origem AT ROW 11.42 COL 21 COLON-ALIGNED HELP
          "Unidade da Federaá∆o" WIDGET-ID 2
     fiNome-transp-ini AT ROW 11.42 COL 44 COLON-ALIGNED
     text-entrada AT ROW 1.25 COL 15.14 NO-LABEL
     text-entrada-2 AT ROW 1.25 COL 44.72 NO-LABEL
     "Seleá∆o de Estados" VIEW-AS TEXT
          SIZE 14 BY .54 AT ROW 7.25 COL 14.72
     RECT-12 AT ROW 1.5 COL 13
     RECT-13 AT ROW 1.5 COL 42
     RECT-14 AT ROW 4.46 COL 13
     RECT-15 AT ROW 11.08 COL 13
     RECT-16 AT ROW 7.33 COL 13
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.71
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
       FRAME fPage5:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN fiItCodigoFim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiItCodigoIni IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiNrEmbarqueFim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiNrEmbarqueIni IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiNrNotaFisFim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiNrNotaFisIni IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiNrVolumeFim IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fiNrVolumeIni IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FILL-IN text-entrada IN FRAME fPage4
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-entrada:PRIVATE-DATA IN FRAME fPage4     = 
                "Imprimir etiquetas".

/* SETTINGS FOR FILL-IN text-entrada-2 IN FRAME fPage4
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       text-entrada-2:PRIVATE-DATA IN FRAME fPage4     = 
                "Tipo Impressora".

/* SETTINGS FOR FRAME fPage5
                                                                        */
/* BROWSE-TAB brDigita 1 fPage5 */
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
        display tt-digita.nr-embarque
                tt-digita.dt-embarque
                tt-digita.identific
                with browse brDigita. 
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
ON ROW-ENTRY OF brDigita IN FRAME fPage5
DO:
   /*:T trigger para inicializar campos da temp table de digitaá∆o */
   if  brDigita:new-row in frame fPage5 then do:
       /*assign tt-digita.exemplo:screen-value in browse brDigita = string(today, "99/99/9999":U).*/
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ROW-LEAVE OF brDigita IN FRAME fPage5
DO:
    /*:T ê aqui que a gravaá∆o da linha da temp-table Ç efetivada.
       PorÇm as validaá‰es dos registros devem ser feitas na procedure pi-executar,
       no local indicado pelo coment†rio */
    
    if brDigita:NEW-ROW in frame fPage5 then 
    do transaction on error undo, return no-apply:
        CREATE tt-digita.
        ASSIGN INPUT BROWSE brDigita tt-digita.nr-embarque.
        FOR FIRST embarque NO-LOCK
            WHERE embarque.cdd-embarq = tt-digita.nr-embarque.
            ASSIGN tt-digita.dt-embarque:SCREEN-VALUE IN BROWSE brdigita = string(embarque.dt-embarque)
                   tt-digita.identific:SCREEN-VALUE   IN BROWSE brdigita = embarque.identific.
        END.
        ASSIGN INPUT BROWSE brDigita tt-digita.dt-embarque 
               INPUT BROWSE brDigita tt-digita.identific.  
        brDigita:CREATE-RESULT-LIST-ENTRY() in frame fPage5.
    end.
    else do transaction on error undo, return no-apply:
        if avail tt-digita then
        DO:
            ASSIGN INPUT BROWSE brDigita tt-digita.nr-embarque.
            FOR FIRST embarque NO-LOCK
                WHERE embarque.cdd-embarq = tt-digita.nr-embarque.
                ASSIGN tt-digita.dt-embarque:SCREEN-VALUE IN BROWSE brdigita = string(embarque.dt-embarque)
                       tt-digita.identific:SCREEN-VALUE   IN BROWSE brdigita = embarque.identific.
            END.
            ASSIGN INPUT BROWSE brDigita tt-digita.dt-embarque 
                   INPUT BROWSE brDigita tt-digita.identific.  
        END.
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
        
        apply "entry":U to tt-digita.nr-embarque in browse brDigita. 
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


&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wReport
ON CHOOSE OF btUpdate IN FRAME fPage5 /* Alterar */
DO:
   apply 'entry' to tt-digita.nr-embarque in browse brDigita. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME fi-uf-origem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-uf-origem wReport
ON ENTRY OF fi-uf-origem IN FRAME fPage4 /* UF Origem */
DO:
  self:private-data = self:screen-value.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-uf-origem wReport
ON F5 OF fi-uf-origem IN FRAME fPage4 /* UF Origem */
DO:
  {include/zoomvar.i &prog-zoom="unzoom/z01un007.w"
                     &campo=fi-uf-origem
                     &campozoom=estado}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-uf-origem wReport
ON LEAVE OF fi-uf-origem IN FRAME fPage4 /* UF Origem */
DO:
  if self:private-data ne self:screen-value then do:
    assign fi-uf-origem = input fi-uf-origem
           c-lista      = "".
    FOR EACH transporte NO-LOCK
        where transporte.estado = fi-uf-origem:
        ASSIGN c-lista = c-lista + transporte.nome-abrev + "," + transporte.nome-abrev + ",".
    END.
    
    ASSIGN c-lista = SUBSTRING(c-lista,1,LENGTH(c-lista) - 1)
           fiNome-transp-ini:LIST-ITEM-PAIRS IN FRAME fPage4 = c-lista.  
           
    self:screen-value = fi-uf-origem.       
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-uf-origem wReport
ON MOUSE-SELECT-DBLCLICK OF fi-uf-origem IN FRAME fPage4 /* UF Origem */
DO:
  apply "f5" to self.
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
fi-uf-origem:load-mouse-pointer ("image\lupa.cur") in frame fPage4.
find first estabelec no-lock 
    where estabelec.cod-estabel = v_cod_estab_usuar no-error.
fi-uf-origem = estabelec.estado.    
FOR EACH transporte NO-LOCK
    where transporte.estado = estabelec.estado:
    ASSIGN c-lista = c-lista + transporte.nome-abrev + "," + transporte.nome-abrev + ",".
END.

ASSIGN c-lista = SUBSTRING(c-lista,1,LENGTH(c-lista) - 1)
       fiNome-transp-ini:LIST-ITEM-PAIRS IN FRAME fPage4 = c-lista. 

RUN esp/es0018p.p (INPUT "esftp004", /* Nome do programa */
               INPUT 5,              /* Ponto do programa */
               INPUT 0,
               INPUT "",
               OUTPUT TABLE tt-prog-ponto) NO-ERROR.

IF CAN-FIND(FIRST tt-prog-ponto WHERE
                  tt-prog-ponto.conteudo = v_cod_estab_usuar) 
THEN ASSIGN rsImprimeEtiqueta = 2.
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


DO WITH FRAME fPage4:
    FOR EACH unid-feder
        WHERE unid-feder.pais = "brasil":
      list-estado:ADD-LAST(unid-feder.estado + " - " + unid-feder.no-estado).
    END.
END.
    
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
    ASSIGN rsDestiny         = 1
           cFile             = "exp-zebra:Sem Layout"
           /* fiNrEmbarqueFim   = 9999999 */
           fiNrNotaFisFim    = "ZZZZZZZZZZZZZZZZ"
           fiItCodigoFim     = "ZZZZZZZZZZZZZZZZ"
           fiNrVolumeFim     = 9999999
           rsRastreabilidade = 1
           rsTpVolume        = 1.

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

DEFINE var r-tt-digita as rowid no-undo.

/*:T** Relatorio ***/
DO on error undo, return error on stop  undo, return error:
    {report/rpexa.i}
    
   IF input frame fPage6 rsDestiny   = 2 AND
      input frame fPage6 rsExecution = 1 THEN DO:
      RUN utp/ut-vlarq.p (input input frame fPage6 cFile).
        
      IF return-value = "NOK":U THEN DO:
         RUN utp/ut-msgs.p (input "show":U, input 73, input "":U).
         APPLY "ENTRY":U to cFile in frame fPage6.
         RETURN error.
      END.
   END.
    

    /*:T Coloque aqui as validaá‰es da p†gina de Digitaá∆o, lembrando que elas devem
       apresentar uma mensagem de erro cadastrada, posicionar nesta p†gina e colocar
       o focus no campo com problemas */
   IF INPUT FRAME fPage4 fiNome-transp-ini = "" THEN DO:
      RUN utp/ut-msgs.p (INPUT "show":U, 
                         INPUT 17006, 
                         INPUT "Nenhum transportador foi selecionado!~~" + 
                               "Deve ser selecionado um transportador para continuar com a execuá∆o deste relat¢rio!").
      APPLY "ENTRY" TO fiNome-transp-ini IN FRAME fPage4.
      RETURN ERROR.
   END.

    
   
   /*browse brDigita:SET-REPOSITIONED-ROW (browse brDigita:DOWN, "ALWAYS":U).*/
    
   FOR EACH tt-digita no-lock:
       ASSIGN r-tt-digita = rowid(tt-digita).
        
       /*:T Validaá∆o de duplicidade de registro na temp-table tt-digita */
       FIND FIRST b-tt-digita                                     WHERE
                  b-tt-digita.nr-embarque = tt-digita.nr-embarque AND 
                  rowid(b-tt-digita) <> rowid(tt-digita)          NO-LOCK NO-ERROR.
       IF AVAIL b-tt-digita THEN DO:
          REPOSITION brDigita to rowid rowid(b-tt-digita).            
          RUN utp/ut-msgs.p (input "SHOW":U, input 108, input "":U).
          APPLY "ENTRY":U to tt-digita.nr-embarque in browse brDigita.          
          RETURN error.
       END.
        
       /*:T As demais validaá‰es devem ser feitas aqui */
       FIND FIRST embarque NO-LOCK WHERE
                  embarque.cdd-embarq = tt-digita.nr-embarque NO-ERROR.
       IF NOT AVAIL embarque THEN
       DO:
          ASSIGN browse brDigita:CURRENT-COLUMN = tt-digita.nr-embarque:HANDLE in browse brDigita.            
          REPOSITION brDigita to rowid r-tt-digita.           
          RUN utp/ut-msgs.p (input "SHOW":U, 
                             input 17567, 
                             input "N£mero do embarque informado n∆o cadastrado.":U).
          APPLY "ENTRY":U to tt-digita.nr-embarque in browse brDigita.           
          RETURN error.
       END.

        /*
        if  tt-digita.nr-embarque <= 0 then do:
            assign browse brDigita:CURRENT-COLUMN = tt-digita.nr-embarque:HANDLE in browse brDigita.
            
            reposition brDigita to rowid r-tt-digita.
           
            run utp/ut-msgs.p (input "SHOW":U, input 99999, input "":U).
            apply "ENTRY":U to tt-digita.nr-embarque in browse brDigita.
            
            return error.
        end.
        */
   END.
    
    
   /*:T Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas devem 
      apresentar uma mensagem de erro cadastrada, posicionar na p†gina com 
      problemas e colocar o focus no campo com problemas */
    
    
    
    /*:T Aqui s∆o gravados os campos da temp-table que ser† passada como parÉmetro
       para o programa RP.P */
    

   CREATE tt-param.
   ASSIGN tt-param.usuario         = c-seg-usuario
          tt-param.destino         = input frame fPage6 rsDestiny
          tt-param.data-exec       = today
          tt-param.hora-exec       = time
          tt-param.ImprimeEtiqueta = INPUT FRAME fPage4 rsImprimeEtiqueta
          tt-param.i-impressora    = INPUT FRAME fPage4 rsTipoImpressora
          tt-param.iTipoNota       = INPUT FRAME fPage4 rsTipoNota
          tt-param.c-estado        = list-estado:SCREEN-VALUE IN FRAME fPage4
          tt-param.cod-estabel     = v_cod_estab_usuar.

   IF list-estado:SCREEN-VALUE IN FRAME fPage4 = ? THEN
      ASSIGN tt-param.l-estado = NO.
   ELSE 
      ASSIGN tt-param.l-estado = YES.

   DO  WITH FRAME fPage2:
       ASSIGN tt-param.ItCodigoIni         = INPUT FRAME fPage2 fiItCodigoIni 
              tt-param.ItCodigoFim         = INPUT FRAME fPage2 fiItCodigoFim 
              tt-param.NrEmbarqueIni       = INPUT FRAME fPage2 fiNrEmbarqueIni  
              tt-param.NrEmbarqueFim       = INPUT FRAME fPage2 fiNrEmbarqueFim
              tt-param.NrNotaFisIni        = INPUT FRAME fPage2 fiNrNotaFisIni 
              tt-param.NrNotaFisFim        = INPUT FRAME fPage2 fiNrNotaFisFim 
              tt-param.NrVolumeIni         = INPUT FRAME fPage2 fiNrVolumeIni
              tt-param.NrVolumeFim         = INPUT FRAME fPage2 fiNrVolumeFim
              tt-param.Rastreabilidade     = INPUT FRAME fPage2 rsRastreabilidade
              tt-param.tipo-volume         = INPUT FRAME fPage2 rsTpVolume
              tt-param.nome-transp-ini     = INPUT FRAME fPage4 fiNome-transp-ini
              tt-param.notas-desconsiderar = INPUT FRAME fpage2 ed-notas-desconsiderar
              tt-param.reimpressao         = INPUT FRAME fpage2 cb-reimpressao
              tt-param.l-imprime-barra     = YES.
   END.


   IF tt-param.destino = 1 then 
      ASSIGN tt-param.arquivo = "":U.
   ELSE 
      IF tt-param.destino = 2 THEN
         ASSIGN tt-param.arquivo = input frame fPage6 cFile.
      ELSE
         ASSIGN tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    


    /*:T Coloque aqui a l¢gica de gravaá∆o dos demais campos que devem ser passados
       como parÉmetros para o programa RP.P, atravÇs da temp-table tt-param */
    
    
    
    /*:T Executar do programa RP.P que ir† criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).

    {report/rprun.i esp\ftp\esftp004rp.p}

    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

