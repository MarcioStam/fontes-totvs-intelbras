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
{include/i-prgvrs.i ESFTP075 2.04.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESFTP075
&GLOBAL-DEFINE Version        2.04.00.000
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
&GLOBAL-DEFINE page4Widgets   lNotasNaoGeradas ~
                              lNotasGerad ~
                              lExportaEstab ~
                              lCancelamento ~
                              lInutilizacao
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution                              

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page4Text      text-sit-nfe-envio ~
                              text-trans-manual ~
                              text-gera-xml-simul ~
                              text-motivo
&GLOBAL-DEFINE page6Text      text-destino ~
                              text-modo

&GLOBAL-DEFINE page2Fields    cCodEstabel ~
                              cSerie ~
                              cNotaFiscalIni ~
                              cNotaFiscalFim ~
                              cNomeAbrevIni ~
                              cNomeAbrevFim ~
                              dtEmissaoIni ~
                              dtEmissaoFim
&GLOBAL-DEFINE page4Fields    edMotivo 
&GLOBAL-DEFINE page6Fields    cFile 

/* Parameters Definitions ---                                           */
{esp/ftp/esftp075.i} /* Definiá∆o das temp-tables tt-param e tt-raw-digita */

/* Transfer Definitions */
DEFINE VARIABLE raw-param    AS RAW         NO-UNDO.

DEFINE VARIABLE l-ok         AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-arq-digita AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-terminal   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-layout AS CHARACTER   NO-UNDO.      
DEFINE VARIABLE c-arq-temp   AS CHARACTER   NO-UNDO.

/* Est† sendo usado na chamada dos zooms dos campos 'Estabelecimento' e 'SÇrie' */
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

DEFINE VARIABLE cCodEstabel AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 TOOLTIP "Estabelecimento".

DEFINE VARIABLE cNomeAbrevFim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 TOOLTIP "Cliente Final" NO-UNDO.

DEFINE VARIABLE cNomeAbrevIni AS CHARACTER FORMAT "X(12)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 TOOLTIP "Cliente Inicial".

DEFINE VARIABLE cNotaFiscalFim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 TOOLTIP "Nota Fiscal Final".

DEFINE VARIABLE cNotaFiscalIni AS CHARACTER FORMAT "X(16)":U 
     LABEL "Nota Fiscal" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 TOOLTIP "Nota Fiscal Inicial".

DEFINE VARIABLE cSerie AS CHARACTER FORMAT "X(5)":U 
     LABEL "SÇrie" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 TOOLTIP "SÇrie".

DEFINE VARIABLE dtEmissaoFim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 TOOLTIP "Data Emiss∆o Final".

DEFINE VARIABLE dtEmissaoIni AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Dt Emiss∆o" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 TOOLTIP "Data Emiss∆o Inicial".

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

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

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 71 BY 5.75.

DEFINE VARIABLE edMotivo AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 55 BY 4 NO-UNDO.

DEFINE VARIABLE text-gera-xml-simul AS CHARACTER FORMAT "X(256)":U INITIAL " Geraá∆o de XML para Simulaá‰es" 
      VIEW-AS TEXT 
     SIZE 24.86 BY .63 NO-UNDO.

DEFINE VARIABLE text-motivo AS CHARACTER FORMAT "X(256)":U INITIAL "Motivo" 
      VIEW-AS TEXT 
     SIZE 6 BY .54 NO-UNDO.

DEFINE VARIABLE text-sit-nfe-envio AS CHARACTER FORMAT "X(256)":U INITIAL " Situaá‰es NF-e para Envio [XML e TXT]" 
      VIEW-AS TEXT 
     SIZE 28.14 BY .63 NO-UNDO.

DEFINE VARIABLE text-trans-manual AS CHARACTER FORMAT "X(256)":U INITIAL " Transmiss∆o Manual [TXT]" 
      VIEW-AS TEXT 
     SIZE 19 BY .63 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59.86 BY 6.54.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 29.57 BY 3.96.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 29.57 BY 3.96.

DEFINE VARIABLE lCancelamento AS LOGICAL INITIAL no 
     LABEL "Cancelamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 15.86 BY .83 NO-UNDO.

DEFINE VARIABLE lExportaEstab AS LOGICAL INITIAL no 
     LABEL "Exporta Emissor (Estabelec)" 
     VIEW-AS TOGGLE-BOX
     SIZE 22.72 BY .83 NO-UNDO.

DEFINE VARIABLE lInutilizacao AS LOGICAL INITIAL no 
     LABEL "Inutilizaá∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.57 BY .83 NO-UNDO.

DEFINE VARIABLE lNotasGerad AS LOGICAL INITIAL yes 
     LABEL "NF-e Gerada" 
     VIEW-AS TOGGLE-BOX
     SIZE 20.86 BY .83 TOOLTIP "NF-e em Processamento" NO-UNDO.

DEFINE VARIABLE lNotasNaoGeradas AS LOGICAL INITIAL yes 
     LABEL "NF-e n∆o Gerada" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .83 TOOLTIP "NF-e n∆o Gerada" NO-UNDO.

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
     rsExecution AT ROW 5.71 COL 3.14 HELP
          "Modo de Execuá∆o" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 4.88 COL 1.14 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.17 COL 2.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7 ROW 2.25
         SIZE 76.86 BY 13
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     cCodEstabel AT ROW 1.92 COL 16 COLON-ALIGNED HELP
          "Estabelecimento"
     cSerie AT ROW 2.92 COL 16 COLON-ALIGNED HELP
          "SÇrie"
     cNotaFiscalIni AT ROW 3.92 COL 16 COLON-ALIGNED HELP
          "Nota Fiscal Inicial"
     cNotaFiscalFim AT ROW 3.92 COL 41.29 COLON-ALIGNED HELP
          "Nota Fiscal Final" NO-LABEL
     cNomeAbrevIni AT ROW 4.92 COL 16 COLON-ALIGNED HELP
          "Cliente Inicial"
     cNomeAbrevFim AT ROW 4.92 COL 41.29 COLON-ALIGNED HELP
          "Cliente Final" NO-LABEL
     dtEmissaoIni AT ROW 5.92 COL 16 COLON-ALIGNED HELP
          "Data Emiss∆o Inicial"
     dtEmissaoFim AT ROW 5.92 COL 41.29 COLON-ALIGNED HELP
          "Data Emiss∆o Final" NO-LABEL
     IMAGE-1 AT ROW 3.92 COL 35.57
     IMAGE-2 AT ROW 3.92 COL 39.72
     IMAGE-3 AT ROW 4.92 COL 35.57
     IMAGE-4 AT ROW 4.92 COL 39.72
     IMAGE-5 AT ROW 5.92 COL 35.57
     IMAGE-6 AT ROW 5.92 COL 39.72
     RECT-13 AT ROW 1.5 COL 3.86
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7 ROW 2.25
         SIZE 76.86 BY 13
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage4
     lNotasNaoGeradas AT ROW 2.83 COL 12.29 HELP
          "NF-e n∆o Gerada"
     lNotasGerad AT ROW 3.92 COL 12.29
     lExportaEstab AT ROW 2.83 COL 42.43
     lCancelamento AT ROW 7.21 COL 11.14
     lInutilizacao AT ROW 7.21 COL 30.43
     edMotivo AT ROW 8.79 COL 10.72 NO-LABEL
     text-sit-nfe-envio AT ROW 1.54 COL 9.86 NO-LABEL
     text-trans-manual AT ROW 1.54 COL 41 NO-LABEL
     text-gera-xml-simul AT ROW 6.25 COL 11 NO-LABEL
     text-motivo AT ROW 8.21 COL 10.86 NO-LABEL
     RECT-14 AT ROW 1.79 COL 9.29
     RECT-15 AT ROW 1.79 COL 39.57
     RECT-10 AT ROW 6.5 COL 9.29
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 7 ROW 2.25
         SIZE 76.86 BY 13
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
         MAX-HEIGHT         = 33.17
         MAX-WIDTH          = 114.14
         VIRTUAL-HEIGHT     = 33.17
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
                                                                        */
/* SETTINGS FOR FRAME fPage4
   Custom                                                               */
/* SETTINGS FOR EDITOR edMotivo IN FRAME fPage4
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN text-gera-xml-simul IN FRAME fPage4
   ALIGN-L                                                              */
ASSIGN 
       text-gera-xml-simul:PRIVATE-DATA IN FRAME fPage4     = 
                "Geraá∆o de XML para Simulaá‰es".

/* SETTINGS FOR FILL-IN text-motivo IN FRAME fPage4
   ALIGN-L                                                              */
ASSIGN 
       text-motivo:PRIVATE-DATA IN FRAME fPage4     = 
                "Motivo".

/* SETTINGS FOR FILL-IN text-sit-nfe-envio IN FRAME fPage4
   ALIGN-L                                                              */
ASSIGN 
       text-sit-nfe-envio:PRIVATE-DATA IN FRAME fPage4     = 
                "Situaá‰es NF-e para Envio [XML e TXT]".

/* SETTINGS FOR FILL-IN text-trans-manual IN FRAME fPage4
   ALIGN-L                                                              */
ASSIGN 
       text-trans-manual:PRIVATE-DATA IN FRAME fPage4     = 
                "Transmiss∆o Manual [TXT]".

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
&Scoped-define SELF-NAME cCodEstabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cCodEstabel wReport
ON F5 OF cCodEstabel IN FRAME fPage2 /* Estabelecimento */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                       &campo="cCodEstabel"
                       &campozoom="cod-estabel"
                       &frame="fPage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cCodEstabel wReport
ON LEAVE OF cCodEstabel IN FRAME fPage2 /* Estabelecimento */
DO:
    RUN piTrataCampos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cCodEstabel wReport
ON MOUSE-SELECT-DBLCLICK OF cCodEstabel IN FRAME fPage2 /* Estabelecimento */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cSerie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cSerie wReport
ON F5 OF cSerie IN FRAME fPage2 /* SÇrie */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z03in407.w"
                       &campo="cSerie"
                       &campozoom="serie"
                       &frame="fPage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cSerie wReport
ON MOUSE-SELECT-DBLCLICK OF cSerie IN FRAME fPage2 /* SÇrie */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME lCancelamento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lCancelamento wReport
ON VALUE-CHANGED OF lCancelamento IN FRAME fPage4 /* Cancelamento */
DO:
    IF NOT INPUT FRAME fPage4 lCancelamento AND
       NOT INPUT FRAME fPage4 lInutilizacao AND
       NOT INPUT FRAME fPage4 lExportaEstab THEN
        ASSIGN lNotasNaoGeradas:SENSITIVE IN FRAME fPage4 = YES
               lNotasGerad:SENSITIVE      IN FRAME fPage4 = YES
               edMotivo:SENSITIVE         IN FRAME fPage4 = NO
               edMotivo:SCREEN-VALUE      IN FRAME fPage4 = "":U.
    ELSE
        ASSIGN lNotasNaoGeradas:CHECKED   IN FRAME fPage4 = NO
               lNotasNaoGeradas:SENSITIVE IN FRAME fPage4 = NO
               lNotasGerad    :CHECKED    IN FRAME fPage4 = NO
               lNotasGerad    :SENSITIVE  IN FRAME fPage4 = NO
               edMotivo:SENSITIVE         IN FRAME fPage4 = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lExportaEstab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lExportaEstab wReport
ON ENTRY OF lExportaEstab IN FRAME fPage4 /* Exporta Emissor (Estabelec) */
DO:
    ASSIGN lExportaEstab:HELP IN FRAME fPage4 = "Exporta Emissor (Estabelec)":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lExportaEstab wReport
ON VALUE-CHANGED OF lExportaEstab IN FRAME fPage4 /* Exporta Emissor (Estabelec) */
DO:
    IF NOT INPUT FRAME fPage4 lExportaEstab THEN
        ASSIGN lNotasNaoGeradas :SENSITIVE IN FRAME fPage4 = YES
               lNotasNaoGeradas :CHECKED   IN FRAME fPage4 = YES
               lNotasGerad:SENSITIVE       IN FRAME fPage4 = YES
               lNotasGerad:CHECKED         IN FRAME fPage4 = YES
               lCancelamento:SENSITIVE     IN FRAME fPage4 = NO
               lInutilizacao:SENSITIVE     IN FRAME fPage4 = NO
               edMotivo:SENSITIVE          IN FRAME fPage4 = NO
               edMotivo:SCREEN-VALUE       IN FRAME fPage4 = "":U
               lExportaEstab:SENSITIVE     IN FRAME fPage4 = YES
               cSerie:SCREEN-VALUE         IN FRAME fPage2 = "":U
               cSerie:SENSITIVE            IN FRAME fPage2 = YES
               cNotaFiscalIni:SCREEN-VALUE IN FRAME fPage2 = "":U
               cNotaFiscalIni:SENSITIVE    IN FRAME fPage2 = YES
               cNotaFiscalFim:SCREEN-VALUE IN FRAME fPage2 = "ZZZZZZZZZZZZZZZZ":U
               cNotaFiscalFim:SENSITIVE    IN FRAME fPage2 = YES
               cNomeAbrevIni:SCREEN-VALUE  IN FRAME fPage2 = "":U
               cNomeAbrevIni:SENSITIVE     IN FRAME fPage2 = YES
               cNomeAbrevFim:SCREEN-VALUE  IN FRAME fPage2 = "ZZZZZZZZZZZZ":U
               cNomeAbrevFim:SENSITIVE     IN FRAME fPage2 = YES
               dtEmissaoIni:SCREEN-VALUE   IN FRAME fPage2 = &IF "{&ems_dbtype}":U = "MSS":U &THEN "01/01/1800":U &ELSE "01/01/0001":U &ENDIF 
               dtEmissaoIni:SENSITIVE      IN FRAME fPage2 = YES
               dtEmissaoFim:SCREEN-VALUE   IN FRAME fPage2 = "31/12/9999":U
               dtEmissaoFim:SENSITIVE      IN FRAME fPage2 = YES.
    ELSE
        ASSIGN lNotasNaoGeradas:CHECKED    IN FRAME fPage4 = NO
               lNotasNaoGeradas:SENSITIVE  IN FRAME fPage4 = NO
               lNotasGerad:CHECKED         IN FRAME fPage4 = NO
               lNotasGerad:SENSITIVE       IN FRAME fPage4 = NO
               lCancelamento:CHECKED       IN FRAME fPage4 = NO
               lCancelamento:SENSITIVE     IN FRAME fPage4 = NO
               lInutilizacao:CHECKED       IN FRAME fPage4 = NO
               lInutilizacao:SENSITIVE     IN FRAME fPage4 = NO
               edMotivo:SENSITIVE          IN FRAME fPage4 = NO
               edMotivo:SCREEN-VALUE       IN FRAME fPage4 = "":U
               cSerie:SCREEN-VALUE         IN FRAME fPage2 = "":U
               cSerie:SENSITIVE            IN FRAME fPage2 = NO
               cNotaFiscalIni:SCREEN-VALUE IN FRAME fPage2 = "":U
               cNotaFiscalIni:SENSITIVE    IN FRAME fPage2 = NO
               cNotaFiscalFim:SCREEN-VALUE IN FRAME fPage2 = "":U
               cNotaFiscalFim:SENSITIVE    IN FRAME fPage2 = NO
               cNomeAbrevIni:SCREEN-VALUE  IN FRAME fPage2 = "":U
               cNomeAbrevIni:SENSITIVE     IN FRAME fPage2 = NO
               cNomeAbrevFim:SCREEN-VALUE  IN FRAME fPage2 = "":U
               cNomeAbrevFim:SENSITIVE     IN FRAME fPage2 = NO
               dtEmissaoIni:SCREEN-VALUE   IN FRAME fPage2 = "":U
               dtEmissaoIni:SENSITIVE      IN FRAME fPage2 = NO
               dtEmissaoFim:SCREEN-VALUE   IN FRAME fPage2 = "":U
               dtEmissaoFim:SENSITIVE      IN FRAME fPage2 = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lInutilizacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lInutilizacao wReport
ON VALUE-CHANGED OF lInutilizacao IN FRAME fPage4 /* Inutilizaá∆o */
DO:
    IF NOT INPUT FRAME fPage4 lCancelamento AND
       NOT INPUT FRAME fPage4 lInutilizacao AND
       NOT INPUT FRAME fPage4 lExportaEstab THEN
        ASSIGN lNotasNaoGeradas:SENSITIVE IN FRAME fPage4 = YES
               lNotasGerad:SENSITIVE      IN FRAME fPage4 = YES
               edMotivo:SENSITIVE         IN FRAME fPage4 = NO
               edMotivo:SCREEN-VALUE      IN FRAME fPage4 = "":U.
    ELSE
        ASSIGN lNotasNaoGeradas:CHECKED   IN FRAME fPage4 = NO
               lNotasNaoGeradas:SENSITIVE IN FRAME fPage4 = NO
               lNotasGerad:CHECKED        IN FRAME fPage4 = NO
               lNotasGerad:SENSITIVE      IN FRAME fPage4 = NO
               edMotivo:SENSITIVE         IN FRAME fPage4 = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lNotasGerad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lNotasGerad wReport
ON ENTRY OF lNotasGerad IN FRAME fPage4 /* NF-e Gerada */
DO:
    ASSIGN lNotasGerad:HELP IN FRAME fPage4 = "NF-e Gerada":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lNotasGerad wReport
ON VALUE-CHANGED OF lNotasGerad IN FRAME fPage4 /* NF-e Gerada */
DO:
    RUN piTrataCampos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lNotasNaoGeradas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lNotasNaoGeradas wReport
ON ENTRY OF lNotasNaoGeradas IN FRAME fPage4 /* NF-e n∆o Gerada */
DO:
    ASSIGN lNotasNaoGeradas:HELP IN FRAME fPage4 = "NF-e n∆o Gerada":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lNotasNaoGeradas wReport
ON VALUE-CHANGED OF lNotasNaoGeradas IN FRAME fPage4 /* NF-e n∆o Gerada */
DO:
    RUN piTrataCampos.
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
    ASSIGN dtEmissaoIni:SCREEN-VALUE IN FRAME fPage2 = &IF "{&ems_dbtype}":U = "MSS":U
                                                       &THEN "01/01/1800":U
                                                       &ELSE "01/01/0001":U &ENDIF
           rsDestiny:SCREEN-VALUE    IN FRAME fPage6 = '3':U.

    cCodEstabel:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage2.
    cSerie:LOAD-MOUSE-POINTER("image/lupa.cur":U)      IN FRAME fPage2.

    APPLY "VALUE-CHANGED" TO rsDestiny IN FRAME fPage6.

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
    DEFINE VARIABLE r-tt-digita AS ROWID       NO-UNDO.
    
    DO ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
        {report/rpexa.i}
    
        /*15/02/2005 - tech1007 - Teste alterado pois RTF n∆o Ç mais opá∆o de Destino*/
        IF INPUT FRAME fPage6 rsDestiny   = 2 AND
           INPUT FRAME fPage6 rsExecution = 1 THEN DO:
            RUN utp/ut-vlarq.p (INPUT INPUT FRAME fPage6 cFile).
    
            IF RETURN-VALUE = "NOK":U THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 73,
                                   INPUT "":U).
    
                APPLY "ENTRY":U TO cFile IN FRAME fPage6.
                RETURN ERROR.
            END.
        END.
        
        /*:T Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas devem 
           apresentar uma mensagem de erro cadastrada, posicionar na p†gina com 
           problemas e colocar o focus no campo com problemas */
        IF INPUT FRAME fPage4 lInutilizacao THEN DO:
            FOR EACH  nota-fiscal
                WHERE nota-fiscal.serie         = INPUT FRAME fPage2 cSerie
                  AND nota-fiscal.cod-estabel   = INPUT FRAME fPage2 cCodEstabel
                  AND nota-fiscal.nr-nota-fis  >= INPUT FRAME fPage2 cNotaFiscalIni
                  AND nota-fiscal.nr-nota-fis  <= INPUT FRAME fPage2 cNotaFiscalFim
                  AND nota-fiscal.nome-ab-cli  >= INPUT FRAME fPage2 cNomeAbrevIni
                  AND nota-fiscal.nome-ab-cli  <= INPUT FRAME fPage2 cNomeAbrevFim
                  AND nota-fiscal.dt-emis-nota >= INPUT FRAME fPage2 dtEmissaoIni
                  AND nota-fiscal.dt-emis-nota <= INPUT FRAME fPage2 dtEmissaoFim
                  AND nota-fiscal.dt-cancela    = ? NO-LOCK:
    
                IF  nota-fiscal.idi-sit-nf-eletro <> 1  AND
                    nota-fiscal.idi-sit-nf-eletro <> 5 THEN DO:
    
                    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                       INPUT 33441,
                                       INPUT STRING(nota-fiscal.nr-nota-fis)).
    
                    APPLY "ENTRY":U TO cNotaFiscalIni IN FRAME fPage2.
                    RETURN ERROR.
                END.
            END.
        END.
    
        IF (INPUT FRAME fPage4 lCancelamento   OR
            INPUT FRAME fPage4 lInutilizacao)  AND
            INPUT FRAME fPage4 edMotivo = "":U THEN DO:
    
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 8099,
                               INPUT "Motivo":U).
    
            APPLY "ENTRY":U TO cNotaFiscalIni IN FRAME fPage2.
            RETURN ERROR.
        END.
    
        IF NOT CAN-FIND(FIRST estabelec
                        WHERE estabelec.cod-estabel = INPUT FRAME fPage2 cCodEstabel) THEN DO:
    
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 56,
                               INPUT "Estabelecimento":U).
    
            APPLY "ENTRY":U TO cCodEstabel IN FRAME fPage2.
            RETURN ERROR.
        END.
        
        /*:T Aqui s∆o gravados os campos da temp-table que ser† passada como parÉmetro
           para o programa RP.P */
        CREATE tt-param.
        ASSIGN tt-param.usuario           = c-seg-usuario
               tt-param.destino           = INPUT FRAME fPage6 rsDestiny
               tt-param.data-exec         = TODAY
               tt-param.hora-exec         = TIME
               tt-param.cod-estabel       = INPUT FRAME fPage2 cCodEstabel
               tt-param.serie             = INPUT FRAME fPage2 cSerie
               tt-param.nr-nota-fis-ini   = INPUT FRAME fPage2 cNotaFiscalIni
               tt-param.nr-nota-fis-fim   = INPUT FRAME fPage2 cNotaFiscalFim
               tt-param.nome-ab-cli-ini   = INPUT FRAME fPage2 cNomeAbrevIni
               tt-param.nome-ab-cli-fim   = INPUT FRAME fPage2 cNomeAbrevFim
               tt-param.dt-emis-nota-ini  = INPUT FRAME fPage2 dtEmissaoIni
               tt-param.dt-emis-nota-fim  = INPUT FRAME fPage2 dtEmissaoFim
               tt-param.gera-nfe-n-gerada = INPUT FRAME fPage4 lNotasNaoGeradas
               tt-param.gera-nfe-gerada   = INPUT FRAME fPage4 lNotasGerad
               tt-param.exporta-est-txt   = INPUT FRAME fPage4 lExportaEstab
               tt-param.gera-nfe-cancel   = INPUT FRAME fPage4 lCancelamento
               tt-param.gera-nfe-inut     = INPUT FRAME fPage4 lInutilizacao
               tt-param.c-motivo          = INPUT FRAME fPage4 edMotivo.
    
        IF tt-param.destino = 1 THEN
            ASSIGN tt-param.arquivo = "":U.
        ELSE DO:
            IF tt-param.destino = 2 THEN
                ASSIGN tt-param.arquivo = INPUT FRAME fPage6 cFile.
            ELSE
                ASSIGN tt-param.arquivo = SESSION:TEMP-DIRECTORY + c-programa-mg97 + ".tmp":U.
        END.
        
        /*:T Coloque aqui a l¢gica de gravaá∆o dos demais campos que devem ser passados
           como parÉmetros para o programa RP.P, atravÇs da temp-table tt-param */
        
        
        
        /*:T Executar do programa RP.P que ir† criar o relat¢rio */
        {report/rpexb.i}
        
        SESSION:SET-WAIT-STATE("GENERAL":U).
        
        {report/rprun.i esp/ftp/esftp075rp.p}
        
        {report/rpexc.i}
        
        SESSION:SET-WAIT-STATE("":U).
        
        {report/rptrm.i}
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piTrataCampos wReport 
PROCEDURE piTrataCampos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR FIRST estabelec
        WHERE estabelec.cod-estabel = INPUT FRAME fPage2 cCodEstabel NO-LOCK:

        IF /* &IF '{&bf_dis_versao_ems}' >= '2.071':U &THEN */ estabelec.idi-tip-transm /* &ELSE INT(SUBSTRING(estabelec.char-1,172,1)) &ENDIF */ = 2 THEN DO: /*Transmiss∆o Manual - TXT*/
            
            /* Na Transmiss∆o Manual, somente opá∆o de Envio e de Exportaá∆o do Estabelec */
            ASSIGN lCancelamento:CHECKED   IN FRAME fPage4 = IF lCancelamento:CHECKED IN FRAME fPage4 = YES THEN YES ELSE NO
                   lCancelamento:SENSITIVE IN FRAME fPage4 = NO
                   lInutilizacao:CHECKED   IN FRAME fPage4 = IF lInutilizacao:CHECKED IN FRAME fPage4 = YES THEN YES ELSE NO
                   lInutilizacao:SENSITIVE IN FRAME fPage4 = NO
                   lExportaEstab:SENSITIVE IN FRAME fPage4 = YES
                   edMotivo:SCREEN-VALUE   IN FRAME fPage4 = "":U.
        END.
        ELSE DO:
            ASSIGN lNotasNaoGeradas :SENSITIVE IN FRAME fPage4 = YES
                   lNotasGerad:SENSITIVE       IN FRAME fPage4 = YES
                   lCancelamento:SENSITIVE     IN FRAME fPage4 = YES
                   lInutilizacao:SENSITIVE     IN FRAME fPage4 = YES
                   lExportaEstab:CHECKED       IN FRAME fPage4 = NO
                   lExportaEstab:SENSITIVE     IN FRAME fPage4 = NO
                   cCodEstabel:SENSITIVE       IN FRAME fPage2 = YES
                   cSerie:SENSITIVE            IN FRAME fPage2 = YES
                   cNotaFiscalIni:SENSITIVE    IN FRAME fPage2 = YES
                   cNotaFiscalFim:SENSITIVE    IN FRAME fPage2 = YES
                   cNomeAbrevIni:SENSITIVE     IN FRAME fPage2 = YES
                   cNomeAbrevFim:SENSITIVE     IN FRAME fPage2 = YES
                   dtEmissaoIni:SENSITIVE      IN FRAME fPage2 = YES
                   dtEmissaoFim:SENSITIVE      IN FRAME fPage2 = YES.
        END.
    END.

    IF NOT INPUT FRAME fPage4 lNotasNaoGeradas AND
       NOT INPUT FRAME fPage4 lNotasGerad      AND
       NOT INPUT FRAME fPage4 lExportaEstab    THEN
        ASSIGN lCancelamento:SENSITIVE IN FRAME fPage4 = YES
               lInutilizacao:SENSITIVE IN FRAME fPage4 = YES.
    ELSE
        ASSIGN lCancelamento:CHECKED   IN FRAME fPage4 = IF lCancelamento:CHECKED IN FRAME fPage4 = YES THEN YES ELSE NO
               lCancelamento:SENSITIVE IN FRAME fPage4 = NO
               lInutilizacao:CHECKED   IN FRAME fPage4 = IF lInutilizacao:CHECKED IN FRAME fPage4 = YES THEN YES ELSE NO
               lInutilizacao:SENSITIVE IN FRAME fPage4 = NO.

    IF NOT lInutilizacao:CHECKED IN FRAME fPage4 AND
       NOT lCancelamento:CHECKED IN FRAME fPage4 THEN
        ASSIGN edMotivo:SENSITIVE    IN FRAME fPage4 = NO
               edMotivo:SCREEN-VALUE IN FRAME fPage4 = "":U.
    ELSE
        ASSIGN edMotivo:SENSITIVE IN FRAME fPage4 = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

