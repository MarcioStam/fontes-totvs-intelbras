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
{include/i-prgvrs.i ESFTP037 1.12.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESFTP037
&GLOBAL-DEFINE Version        1.12.00.001
&GLOBAL-DEFINE VersionLayout  1

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Seleá∆o,Digitaá∆o,Impress∆o

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          NO
&GLOBAL-DEFINE PGDIG          YES
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page4Widgets   
&GLOBAL-DEFINE page5Widgets   brDigita ~
                              bt-marca ~
                              bt-marca-todos ~
                              bt-desmarca-todos 
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo

&GLOBAL-DEFINE page2Fields    fiItCodigoFim fiItCodigoIni fiNrNotaFisFim  ~
                              fiNrNotaFisIni fiNrVolumeFim fiNrVolumeIni  ~
                              fiNrEmbarqueIni fiNrEmbarqueFim  ~
                              rsTpVolume cb-reimpressao bt-buscar ~
                              fiNome-transp-ini list-estado fi-uf-origem ~
                              dt-periodo-inicial dt-periodo-final
&GLOBAL-DEFINE page4Fields    
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile

/* Parameters Definitions ---                                           */

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U

    FIELD ItCodigoIni      LIKE ITEM.it-codigo
    FIELD ItCodigoFim      LIKE ITEM.it-codigo 
    FIELD NrEmbarqueIni    LIKE integra-mft-wms-notas.cdd-embarq
    FIELD NrEmbarqueFim    LIKE integra-mft-wms-notas.cdd-embarq
    FIELD NrNotaFisIni     LIKE nota-fiscal.nr-nota-fis
    FIELD NrNotaFisFim     LIKE nota-fiscal.nr-nota-fis
    FIELD NrVolumeIni      AS INT /*LIKE volume-nf.nr-volume*/
    FIELD NrVolumeFim      AS INT /*LIKE volume-nf.nr-volume*/ 
    FIELD DtPeriodoIni     LIKE integra-mft-wms.dt-integra
    FIELD DtPeriodoFim     LIKE integra-mft-wms.dt-integra

    FIELD iTipoNota        AS INT
    FIELD ImprimeEtiqueta  AS INT
    FIELD i-impressora     AS INT

    FIELD Rastreabilidade  AS INTEGER
    FIELD tipo-volume      AS INTEGER
    FIELD nome-transp-ini  LIKE embarque.nome-transp
    FIELD l-estado         AS LOG
    FIELD c-estado         AS CHAR
    field cod-estabel      as char
    FIELD reimpressao      AS LOGICAL.

define temp-table tt-digita no-undo
    FIELD selecionado   AS LOGICAL LABEL 'Sel'
    FIELD cdd-embarq    LIKE integra-mft-wms-notas.cdd-embarq
    FIELD cod-estabel   LIKE integra-mft-wms-notas.cod-estabel
    FIELD serie         LIKE integra-mft-wms-notas.serie      
    FIELD nr-nota-fis   LIKE integra-mft-wms-notas.nr-nota-fis
    FIELD nr-volume     LIKE volume-nf.nr-volume
    FIELD it-codigo     LIKE integra-mft-wms-notas.it-codigo 
    index id 
    cdd-embarq 
    cod-estabel
    serie      
    nr-nota-fis.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
    
{upc\btb910za-upc.i}
/* Transfer Definitions */

DEFINE TEMP-TABLE tt-estado
    FIELD estado            AS CHAR FORMAT "x(02)".
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
&Scoped-define FIELDS-IN-QUERY-brDigita tt-digita.selecionado tt-digita.cdd-embarq tt-digita.cod-estabel tt-digita.serie tt-digita.nr-nota-fis tt-digita.nr-volume tt-digita.it-codigo   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDigita   
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

DEFINE BUTTON bt-buscar 
     LABEL "Buscar Notas" 
     SIZE 15 BY 1.

DEFINE VARIABLE fiNome-transp-ini AS CHARACTER FORMAT "X(256)":U 
     LABEL "Transportador" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE dt-periodo-final AS DATE FORMAT "99/99/9999":U INITIAL 12/31/16 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE dt-periodo-inicial AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Periodo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-uf-origem AS CHARACTER FORMAT "x(4)" 
     LABEL "UF Origem" 
     VIEW-AS FILL-IN 
     SIZE 8.14 BY .88
     FONT 1 NO-UNDO.

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

DEFINE IMAGE IMAGE-27
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-28
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE rsTpVolume AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Fracionada", 1,
"Fechada", 2,
"Ambos", 3
     SIZE 33.14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 63 BY 1.58.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 63 BY 3.5.

DEFINE VARIABLE list-estado AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE SCROLLBAR-VERTICAL 
     SIZE 30 BY 3 TOOLTIP "Para selecionar mais de um estado deixe o CTRL pressionado" NO-UNDO.

DEFINE VARIABLE cb-reimpressao AS LOGICAL INITIAL no 
     LABEL "Reimpress∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.

DEFINE BUTTON bt-desmarca-todos 
     LABEL "Desmarca Todos" 
     SIZE 15 BY 1.

DEFINE BUTTON bt-marca 
     LABEL "Marca/Desmarca" 
     SIZE 14.29 BY 1.

DEFINE BUTTON bt-marca-todos 
     LABEL "Marca Todos" 
     SIZE 15 BY 1.

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
      tt-digita.selecionado FORMAT 'S/N'
      tt-digita.cdd-embarq
      tt-digita.cod-estabel
      tt-digita.serie
      tt-digita.nr-nota-fis
      tt-digita.nr-volume 
      tt-digita.it-codigo
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 82 BY 8.75
         BGCOLOR 15 FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.96 COL 2
     btCancel AT ROW 16.96 COL 13
     btHelp2 AT ROW 16.96 COL 80
     rtToolBar AT ROW 16.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1.04
         SIZE 91 BY 17.42
         FONT 1.

DEFINE FRAME fPage5
     brDigita AT ROW 1.25 COL 1
     bt-marca AT ROW 10.08 COL 2.14 WIDGET-ID 4
     bt-marca-todos AT ROW 10.08 COL 16.43 WIDGET-ID 6
     bt-desmarca-todos AT ROW 10.08 COL 31.57 WIDGET-ID 2
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
     fiNrEmbarqueIni AT ROW 1.17 COL 14.72 HELP
          "Embarque"
     fiNrEmbarqueFim AT ROW 1.17 COL 52.43 HELP
          "Embarque" NO-LABEL
     fiNrNotaFisIni AT ROW 2.17 COL 14.86
     fiNrNotaFisFim AT ROW 2.17 COL 52.43 NO-LABEL
     fiItCodigoIni AT ROW 3.17 COL 17.15
     fiItCodigoFim AT ROW 3.17 COL 52.43 NO-LABEL
     fiNrVolumeIni AT ROW 4.17 COL 17.43
     fiNrVolumeFim AT ROW 4.17 COL 52.43 NO-LABEL
     dt-periodo-inicial AT ROW 5.17 COL 17.29 WIDGET-ID 18
     dt-periodo-final AT ROW 5.17 COL 52.43 NO-LABEL WIDGET-ID 16
     rsTpVolume AT ROW 6.17 COL 23.29 NO-LABEL
     list-estado AT ROW 7.71 COL 29 HELP
          "Para selecionar mais de um estado deixe o CTRL pressionado" NO-LABEL WIDGET-ID 8
     fi-uf-origem AT ROW 11.38 COL 21 COLON-ALIGNED HELP
          "Unidade da Federaá∆o" WIDGET-ID 4
     fiNome-transp-ini AT ROW 11.38 COL 44 COLON-ALIGNED WIDGET-ID 6
     cb-reimpressao AT ROW 12.75 COL 33 WIDGET-ID 2
     bt-buscar AT ROW 12.75 COL 69 WIDGET-ID 28
     "Volumes:" VIEW-AS TEXT
          SIZE 6.57 BY .54 AT ROW 6.42 COL 16.57
     "Seleá∆o de Estados" VIEW-AS TEXT
          SIZE 14 BY .54 AT ROW 7.21 COL 14.72 WIDGET-ID 14
     IMAGE-19 AT ROW 2.17 COL 41
     IMAGE-20 AT ROW 2.17 COL 48.43
     IMAGE-21 AT ROW 3.17 COL 41
     IMAGE-22 AT ROW 3.17 COL 48.43
     IMAGE-23 AT ROW 4.17 COL 41
     IMAGE-24 AT ROW 4.17 COL 48.43
     IMAGE-25 AT ROW 1.17 COL 41
     IMAGE-26 AT ROW 1.17 COL 48.43
     RECT-15 AT ROW 11.04 COL 13 WIDGET-ID 10
     RECT-16 AT ROW 7.29 COL 13 WIDGET-ID 12
     IMAGE-27 AT ROW 5.17 COL 41 WIDGET-ID 20
     IMAGE-28 AT ROW 5.17 COL 48.43 WIDGET-ID 22
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.75
         SIZE 84.29 BY 13.5
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
         HEIGHT             = 17.46
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
  NOT-VISIBLE,                                                          */
/* REPARENT FRAME */
ASSIGN FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage5:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN dt-periodo-final IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN dt-periodo-inicial IN FRAME fPage2
   ALIGN-L                                                              */
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
        display tt-digita.cdd-embarq
                tt-digita.cod-estabel
                tt-digita.serie
                tt-digita.nr-nota-fis
                tt-digita.nr-volume
                tt-digita.it-codigo
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
ON MOUSE-SELECT-DBLCLICK OF brDigita IN FRAME fPage5
DO:
    APPLY 'Choose' TO bt-marca IN FRAME fPage5.
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
    /*
    if brDigita:NEW-ROW in frame fPage5 then 
    do transaction on error undo, return no-apply:
        CREATE tt-digita.
        ASSIGN INPUT BROWSE brDigita tt-digita.cdd-embarq.
        FOR FIRST embarque NO-LOCK
            WHERE embarque.cdd-embarq = tt-digita.cdd-embarq.
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
            ASSIGN INPUT BROWSE brDigita tt-digita.cdd-embarq.
            FOR FIRST embarque NO-LOCK
                WHERE embarque.cdd-embarq = tt-digita.cdd-embarq.
                ASSIGN tt-digita.dt-embarque:SCREEN-VALUE IN BROWSE brdigita = string(embarque.dt-embarque)
                       tt-digita.identific:SCREEN-VALUE   IN BROWSE brdigita = embarque.identific.
            END.
            ASSIGN INPUT BROWSE brDigita tt-digita.dt-embarque 
                   INPUT BROWSE brDigita tt-digita.identific.  
        END.
    end.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME bt-buscar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-buscar wReport
ON CHOOSE OF bt-buscar IN FRAME fPage2 /* Buscar Notas */
DO:
    RUN piBuscaNotas        IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME bt-desmarca-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-desmarca-todos wReport
ON CHOOSE OF bt-desmarca-todos IN FRAME fPage5 /* Desmarca Todos */
DO:
    FOR EACH tt-digita:
        ASSIGN tt-digita.selecionado = NO.
    END.
    {&OPEN-QUERY-BrDigita}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-marca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-marca wReport
ON CHOOSE OF bt-marca IN FRAME fPage5 /* Marca/Desmarca */
DO:
    def var r-tt-digita      as rowid   no-undo.

    FOR EACH tt-digita 
        WHERE tt-digita.cdd-embarq  = input browse brDigita tt-digita.cdd-embarq 
          AND tt-digita.cod-estabel = input browse brDigita tt-digita.cod-estabel
          AND tt-digita.serie       = input browse brDigita tt-digita.serie      
          AND tt-digita.nr-nota-fis = input browse brDigita tt-digita.nr-nota-fis
          AND tt-digita.nr-volume   = input browse brDigita tt-digita.nr-volume   EXCLUSIVE-LOCK:

        IF tt-digita.selecionado = NO THEN
            ASSIGN tt-digita.selecionado = YES.
        ELSE
            ASSIGN tt-digita.selecionado = NO.

        ASSIGN r-tt-digita = ROWID(tt-digita).
    END.
    {&open-query-brDigita}
    reposition brDigita to rowid r-tt-digita.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-marca-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-marca-todos wReport
ON CHOOSE OF bt-marca-todos IN FRAME fPage5 /* Marca Todos */
DO:
    FOR EACH tt-digita:
        ASSIGN tt-digita.selecionado = YES.
    END.
    {&OPEN-QUERY-BrDigita}
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
&Scoped-define SELF-NAME fi-uf-origem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-uf-origem wReport
ON ENTRY OF fi-uf-origem IN FRAME fPage2 /* UF Origem */
DO:
  self:private-data = self:screen-value.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-uf-origem wReport
ON F5 OF fi-uf-origem IN FRAME fPage2 /* UF Origem */
DO:
  {include/zoomvar.i &prog-zoom="unzoom/z01un007.w"
                     &campo=fi-uf-origem
                     &campozoom=estado}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-uf-origem wReport
ON LEAVE OF fi-uf-origem IN FRAME fPage2 /* UF Origem */
DO:
  if self:private-data ne self:screen-value then do:
    assign fi-uf-origem = input fi-uf-origem
           c-lista      = "".
    FOR EACH transporte NO-LOCK
        where transporte.estado = fi-uf-origem:
        ASSIGN c-lista = c-lista + transporte.nome-abrev + "," + transporte.nome-abrev + ",".
    END.
    
    ASSIGN c-lista = SUBSTRING(c-lista,1,LENGTH(c-lista) - 1)
           fiNome-transp-ini:LIST-ITEM-PAIRS IN FRAME fPage2 = c-lista.  
           
    self:screen-value = fi-uf-origem.       
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-uf-origem wReport
ON MOUSE-SELECT-DBLCLICK OF fi-uf-origem IN FRAME fPage2 /* UF Origem */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiNrEmbarqueIni
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiNrEmbarqueIni wReport
ON ENTRY OF fiNrEmbarqueIni IN FRAME fPage2 /* Embarque */
DO:
  
    IF dt-periodo-inicial:SCREEN-VALUE IN FRAME fPage2 = '01/01/0001'  THEN
        ASSIGN dt-periodo-inicial:SCREEN-VALUE IN FRAME fPage2 = STRING(TODAY - 3)
               dt-periodo-final  :SCREEN-VALUE IN FRAME fPage2 = STRING(TODAY).

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
fi-uf-origem:load-mouse-pointer ("image\lupa.cur") in frame fPage2.
find first estabelec no-lock 
    where estabelec.cod-estabel = v_cod_estab_usuar no-error.
fi-uf-origem = estabelec.estado.    
FOR EACH transporte NO-LOCK
    where transporte.estado = estabelec.estado:
    ASSIGN c-lista = c-lista + transporte.nome-abrev + "," + transporte.nome-abrev + ",".
END.

ASSIGN c-lista = SUBSTRING(c-lista,1,LENGTH(c-lista) - 1)
       fiNome-transp-ini:LIST-ITEM-PAIRS IN FRAME fPage2 = c-lista. 

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


DO WITH FRAME fPage2:
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
           rsTpVolume        = 1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaNotas wReport 
PROCEDURE piBuscaNotas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE dt-periodo AS DATE    NO-UNDO.
DEF VAR i-cont          AS INT.
DEF VAR c-est           AS CHAR.

/*
INPUT FRAME fPage2 fiItCodigoIni     
INPUT FRAME fPage2 fiItCodigoFim     
INPUT FRAME fPage2 fiNrEmbarqueIni   
INPUT FRAME fPage2 fiNrEmbarqueFim   
INPUT FRAME fPage2 fiNrNotaFisIni    
INPUT FRAME fPage2 fiNrNotaFisFim    
INPUT FRAME fPage2 fiNrVolumeIni     
INPUT FRAME fPage2 fiNrVolumeFim     
INPUT FRAME fPage2 dt-periodo-inicial
INPUT FRAME fPage2 dt-periodo-final  
INPUT FRAME fPage2 rsTpVolume        
INPUT FRAME fPage2 fiNome-transp-ini 
INPUT FRAME fpage2 cb-reimpressao.   
*/
FOR EACH tt-digita. 
    DELETE tt-digita.
END.

FOR EACH tt-estado. 
    DELETE tt-estado.
END.

    IF INPUT FRAME fPage2 list-estado <> "" THEN DO:
       DO i-cont = 1 TO 30:
          ASSIGN c-est = ENTRY(i-cont,INPUT FRAME fPage2 list-estado) NO-ERROR.
          IF c-est <> "" THEN DO:
             CREATE tt-estado.
             ASSIGN tt-estado.estado = SUBSTRING(c-est,1,2)
                    c-est            = "".
          END.
       END.
    END.

    DO dt-periodo = date(dt-periodo-inicial:SCREEN-VALUE IN FRAME fPage2) TO date(dt-periodo-final:SCREEN-VALUE IN FRAME fPage2):

        FOR EACH integra-mft-wms
            WHERE integra-mft-wms.dt-integra = dt-periodo NO-LOCK,
            EACH integra-mft-wms-notas 
            WHERE integra-mft-wms-notas.cod-integra = integra-mft-wms.cod-integra :

            IF (integra-mft-wms-notas.cdd-embarq  < int(fiNrEmbarqueIni:SCREEN-VALUE IN FRAME fPage2)
            OR  integra-mft-wms-notas.cdd-embarq  > int(fiNrEmbarqueFim:SCREEN-VALUE IN FRAME fPage2)) THEN NEXT.

            IF (integra-mft-wms-notas.nr-nota-fis < fiNrNotaFisIni:SCREEN-VALUE IN FRAME fPage2 
            OR  integra-mft-wms-notas.nr-nota-fis > fiNrNotaFisFim:SCREEN-VALUE IN FRAME fPage2) THEN NEXT.
             
            IF  integra-mft-wms-notas.l-fracionado = YES
            AND INPUT FRAME fPage2 rsTpVolume      = 2   THEN NEXT.

            FIND FIRST nota-fiscal NO-LOCK                                  
                WHERE nota-fiscal.cod-estabel = integra-mft-wms-notas.cod-estabel   
                  AND nota-fiscal.serie       = integra-mft-wms-notas.serie         
                  AND nota-fiscal.nr-nota-fis = integra-mft-wms-notas.nr-nota-fis NO-ERROR.
            IF AVAIL nota-fiscal THEN DO:

                IF nota-fiscal.nome-transp <> fiNome-transp-ini:SCREEN-VALUE IN FRAME fPage2 THEN NEXT.
                IF nota-fiscal.dt-cancela  <> ?                                              THEN NEXT.

                FOR EACH mgesp.volume-nf NO-LOCK                               
                    WHERE volume-nf.cod-estabel = nota-fiscal.cod-estabel 
                      AND volume-nf.serie       = nota-fiscal.serie       
                      AND volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis 
                      AND volume-nf.it-codigo >= fiitCodigoIni:SCREEN-VALUE IN FRAME fPage2     
                      AND volume-nf.it-codigo <= fiitCodigoFim:SCREEN-VALUE IN FRAME fPage2     
                      AND volume-nf.nr-volume >= int(finrVolumeIni:SCREEN-VALUE IN FRAME fPage2)     
                      AND volume-nf.nr-volume <= int(finrVolumeFim:SCREEN-VALUE IN FRAME fPage2) :

                    IF NOT CAN-FIND(tt-estado WHERE tt-estado.estado = nota-fiscal.estado) THEN NEXT.

                    IF cb-reimpressao:SCREEN-VALUE IN FRAME fPage2 = 'YES' THEN DO:
                        IF volume-nf.impresso = YES THEN DO: /* JA IMPRESSO */
                            IF  NOT CAN-FIND(FIRST usuar_grp_usuar
                            WHERE usuar_grp_usuar.cod_grp_usuar  >= "X03"
                              AND  usuar_grp_usuar.cod_grp_usuar <= "X04"
                              AND usuar_grp_usuar.cod_usuar     = c-seg-usuario)  THEN NEXT.
                        /* CASO EXISTA NO GRUPO X04 ESTA AUTORIZADO A REIMPRIMIR */
                        END.
                        ELSE NEXT. /* AINDA NAO FOI IMPRESSA */
                        
                    END.
                    ELSE DO:
                      IF volume-nf.impresso = YES THEN NEXT. /* JA IMPRESSO */
                    END.

                    FIND FIRST tt-digita
                        WHERE tt-digita.cdd-embarq  = integra-mft-wms-notas.cdd-embarq 
                          AND tt-digita.cod-estabel = volume-nf.cod-estabel
                          AND tt-digita.serie       = volume-nf.serie      
                          AND tt-digita.nr-nota-fis = volume-nf.nr-nota-fis
                          AND tt-digita.nr-volume   = volume-nf.nr-volume              
                          AND tt-digita.it-codigo   = volume-nf.it-codigo               NO-LOCK NO-ERROR.
                    IF NOT AVAIL tt-digita THEN DO:

                        CREATE tt-digita.
                        ASSIGN tt-digita.selecionado = NO
                               tt-digita.cdd-embarq  = integra-mft-wms-notas.cdd-embarq  
                               tt-digita.cod-estabel = volume-nf.cod-estabel             
                               tt-digita.serie       = volume-nf.serie                   
                               tt-digita.nr-nota-fis = volume-nf.nr-nota-fis             
                               tt-digita.nr-volume   = volume-nf.nr-volume               
                               tt-digita.it-codigo   = volume-nf.it-codigo             .

                    END. /* IF NOT AVAIL tt-digita THEN DO: */

                END. /* FOR EACH mgesp.volume-nf NO-LOCK */

            END. /* IF AVAIL nota-fiscal THEN DO: */

        END. /* FOR EACH integra-mft-wms */

    END. /* DO dt-periodo = INPUT FRAME fPage2 dt-periodo-inicial TO INPUT FRAME fPage2 dt-periodo-final: */

    {&open-query-brDigita}

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
   IF INPUT FRAME fPage2 fiNome-transp-ini = "" THEN DO:
      RUN utp/ut-msgs.p (INPUT "show":U, 
                         INPUT 17006, 
                         INPUT "Nenhum transportador foi selecionado!~~" + 
                               "Deve ser selecionado um transportador para continuar com a execuá∆o deste relat¢rio!").
      APPLY "ENTRY" TO fiNome-transp-ini IN FRAME fPage2.
      RETURN ERROR.
   END.

    
   
   /*browse brDigita:SET-REPOSITIONED-ROW (browse brDigita:DOWN, "ALWAYS":U).*/
    
   FOR EACH tt-digita no-lock:
       ASSIGN r-tt-digita = rowid(tt-digita).
        
       /*:T Validaá∆o de duplicidade de registro na temp-table tt-digita 
       FIND FIRST b-tt-digita                                     WHERE
                  b-tt-digita.cdd-embarq = tt-digita.cdd-embarq AND 
                  rowid(b-tt-digita) <> rowid(tt-digita)          NO-LOCK NO-ERROR.
       IF AVAIL b-tt-digita THEN DO:
          REPOSITION brDigita to rowid rowid(b-tt-digita).            
          RUN utp/ut-msgs.p (input "SHOW":U, input 108, input "":U).
          APPLY "ENTRY":U to tt-digita.cdd-embarq in browse brDigita.          
          RETURN error.
       END.
       */ 
       /*:T As demais validaá‰es devem ser feitas aqui */
       FIND FIRST embarque NO-LOCK WHERE
                  embarque.cdd-embarq = tt-digita.cdd-embarq NO-ERROR.
       IF NOT AVAIL embarque THEN
       DO:
          ASSIGN browse brDigita:CURRENT-COLUMN = tt-digita.cdd-embarq:HANDLE in browse brDigita.            
          REPOSITION brDigita to rowid r-tt-digita.           
          RUN utp/ut-msgs.p (input "SHOW":U, 
                             input 17567, 
                             input "N£mero do embarque informado n∆o cadastrado.":U).
          APPLY "ENTRY":U to tt-digita.cdd-embarq in browse brDigita.           
          RETURN error.
       END.

        /*
        if  tt-digita.cdd-embarq <= 0 then do:
            assign browse brDigita:CURRENT-COLUMN = tt-digita.cdd-embarq:HANDLE in browse brDigita.
            
            reposition brDigita to rowid r-tt-digita.
           
            run utp/ut-msgs.p (input "SHOW":U, input 99999, input "":U).
            apply "ENTRY":U to tt-digita.cdd-embarq in browse brDigita.
            
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
          tt-param.c-estado        = list-estado:SCREEN-VALUE IN FRAME fPage2
          tt-param.cod-estabel     = v_cod_estab_usuar
       
          tt-param.iTipoNota       = 1
          tt-param.ImprimeEtiqueta = 1
          tt-param.i-impressora    = 1.

   IF list-estado:SCREEN-VALUE IN FRAME fPage2 = ? THEN
      ASSIGN tt-param.l-estado = NO.
   ELSE 
      ASSIGN tt-param.l-estado = YES.

   DO  WITH FRAME fPage2:
       ASSIGN tt-param.ItCodigoIni     = INPUT FRAME fPage2 fiItCodigoIni 
              tt-param.ItCodigoFim     = INPUT FRAME fPage2 fiItCodigoFim 
              tt-param.NrEmbarqueIni   = INPUT FRAME fPage2 fiNrEmbarqueIni  
              tt-param.NrEmbarqueFim   = INPUT FRAME fPage2 fiNrEmbarqueFim
              tt-param.NrNotaFisIni    = INPUT FRAME fPage2 fiNrNotaFisIni 
              tt-param.NrNotaFisFim    = INPUT FRAME fPage2 fiNrNotaFisFim 
              tt-param.NrVolumeIni     = INPUT FRAME fPage2 fiNrVolumeIni
              tt-param.NrVolumeFim     = INPUT FRAME fPage2 fiNrVolumeFim
              tt-param.DtPeriodoIni    = INPUT FRAME fPage2 dt-periodo-inicial
              tt-param.DtPeriodoFim    = INPUT FRAME fPage2 dt-periodo-final
              tt-param.Rastreabilidade = 3
              tt-param.tipo-volume     = INPUT FRAME fPage2 rsTpVolume
              tt-param.nome-transp-ini = INPUT FRAME fPage2 fiNome-transp-ini
              tt-param.reimpressao     = INPUT FRAME fpage2 cb-reimpressao.
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

    {report/rprun.i esp\ftp\esftp037rp.p}

    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

