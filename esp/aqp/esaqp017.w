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
{include/i-prgvrs.i ESAQP017 1.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */
/*
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> <m¢dulo>}
&ENDIF*/

CREATE WIDGET-POOL.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE      NO-UNDO.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESAQP017
&GLOBAL-DEFINE Version        1.00.00.000
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Sele‡Æo,ImpressÆo

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          NO
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE RTF            NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution ~
                              l-habilitaRtf ~
                              btModelRtf

&GLOBAL-DEFINE page0Text           
&GLOBAL-DEFINE page2Text                    
&GLOBAL-DEFINE page6Text      text-destino text-modo text-rtf text-ModelRtf   
  
&GLOBAL-DEFINE page2Fields    datIniAdicional datFimAdicional iNr-linha c-it-codigo c-unid-negoc i-nr-seq-orig-prob i-nr-seq-tipo-lote c-cod-estabel
&GLOBAL-DEFINE page6Fields    cFile  

/* Parameters Definitions ---                                           */

{esp/aqp/esaqp017tt.i}

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-rtf              as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.
DEF VAR c-modelo-default   AS CHAR    NO-UNDO.

define variable h-boin745  as handle  no-undo.

def stream s-imp.

/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est  rodando no WebEnabler*/
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

DEFINE VARIABLE c-cod-estabel AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "x(16)" 
     LABEL "Produto" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88.

DEFINE VARIABLE c-unid-negoc AS CHARACTER FORMAT "X(5)":U 
     LABEL "Unidade Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE cDesc-item AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88.

DEFINE VARIABLE cDescricaoLinProd AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88.

DEFINE VARIABLE datFimAdicional AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE datIniAdicional AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Data" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-desc-tipo-lote AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-seq-orig-prob AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "Origem" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-seq-tipo-lote AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "Lote" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE iNr-linha AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Linha Produ‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE v_des_origem_prob AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE v_des_unid_negoc AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 2.5.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 8.75.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btModelRtf 
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

DEFINE VARIABLE text-ModelRtf AS CHARACTER FORMAT "X(256)":U INITIAL "Modelo:" 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execu‡Æo" 
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
         SIZE 90 BY 17
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage2
     datIniAdicional AT ROW 2 COL 21.86 HELP
          "Data de amostragem adicional inicial"
     datFimAdicional AT ROW 2 COL 51 HELP
          "Data final de amostragem adicional" NO-LABEL
     c-cod-estabel AT ROW 4 COL 23 COLON-ALIGNED WIDGET-ID 46
     c-desc-estabel AT ROW 4 COL 29.43 COLON-ALIGNED NO-LABEL WIDGET-ID 48
     iNr-linha AT ROW 5 COL 24 COLON-ALIGNED HELP
          "Numero da Linha de Produ‡Æo" WIDGET-ID 8
     cDescricaoLinProd AT ROW 5 COL 29.43 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     c-it-codigo AT ROW 6 COL 11 COLON-ALIGNED HELP
          "C¢digo do Item" WIDGET-ID 2
     cDesc-item AT ROW 6 COL 29.43 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     c-unid-negoc AT ROW 7 COL 22 COLON-ALIGNED WIDGET-ID 24
     v_des_unid_negoc AT ROW 7 COL 29.43 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     i-nr-seq-orig-prob AT ROW 8 COL 21 COLON-ALIGNED WIDGET-ID 28
     v_des_origem_prob AT ROW 8 COL 29.43 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     i-nr-seq-tipo-lote AT ROW 9 COL 21 COLON-ALIGNED WIDGET-ID 44
     fi-desc-tipo-lote AT ROW 9 COL 29.43 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     IMAGE-1 AT ROW 2 COL 40.86
     IMAGE-2 AT ROW 2 COL 48
     RECT-13 AT ROW 1 COL 1 WIDGET-ID 12
     RECT-14 AT ROW 3.75 COL 1 WIDGET-ID 14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 12.96
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.25 COL 22.14 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     cFile AT ROW 3.5 COL 22.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btFile AT ROW 3.5 COL 62 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.38 COL 62 HELP
          "Configura‡Æo da impressora"
     l-habilitaRtf AT ROW 5.46 COL 22.14
     cModelRTF AT ROW 7.17 COL 22 HELP
          "Nome do arquivo de modelo" NO-LABEL
     btModelRtf AT ROW 7.17 COL 62 HELP
          "Escolha o arquivo de modelo"
     rsExecution AT ROW 9.38 COL 21.86 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-destino AT ROW 1.5 COL 20.86 COLON-ALIGNED NO-LABEL
     text-rtf AT ROW 4.88 COL 21 COLON-ALIGNED NO-LABEL
     text-ModelRtf AT ROW 6.42 COL 21 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 8.63 COL 20.14 COLON-ALIGNED NO-LABEL
     rect-rtf AT ROW 5.17 COL 21
     RECT-7 AT ROW 1.79 COL 21.14
     RECT-9 AT ROW 8.88 COL 21
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
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN cDesc-item IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cDescricaoLinProd IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN datFimAdicional IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN datIniAdicional IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN v_des_origem_prob IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v_des_unid_negoc IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage6
   Custom                                                               */
ASSIGN 
       btModelRtf:HIDDEN IN FRAME fPage6           = TRUE.

ASSIGN 
       cModelRTF:HIDDEN IN FRAME fPage6           = TRUE.

ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-ModelRtf:HIDDEN IN FRAME fPage6           = TRUE
       text-ModelRtf:PRIVATE-DATA IN FRAME fPage6     = 
                "Modelo:".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execu‡Æo".

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
&Scoped-define SELF-NAME btModelRtf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btModelRtf wReport
ON CHOOSE OF btModelRtf IN FRAME fPage6
DO:
    def var cFile as char no-undo.
    def var l-ok  as logical no-undo.

    assign cModelRTF = replace(input frame {&frame-name} cModelRTF, "/", "~\").
    SYSTEM-DIALOG GET-FILE cFile
       FILTERS "*.rtf" "*.rtf",
               "*.*" "*.*"
       DEFAULT-EXTENSION "rtf"
       INITIAL-DIR "modelos" 
       MUST-EXIST
       USE-FILENAME
       UPDATE l-ok.
    if  l-ok = yes then
        assign cModelRTF:screen-value in frame {&frame-name}  = replace(cFile, "~\", "/"). 

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
&Scoped-define SELF-NAME c-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wReport
ON F5 OF c-cod-estabel IN FRAME fPage2 /* Estabelecimento */
DO:

    {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                      &campo="c-cod-estabel"
                      &campozoom="cod-estabel"
                      &campo2="c-desc-estabel"
                      &campozoom2="nome"
                      &frame="fPage2"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wReport
ON LEAVE OF c-cod-estabel IN FRAME fPage2 /* Estabelecimento */
DO:

    ASSIGN c-desc-estabel:SCREEN-VALUE = "".

    FOR FIRST estabelec NO-LOCK
        WHERE estabelec.cod-estabel = SELF:SCREEN-VALUE:

        ASSIGN c-desc-estabel:SCREEN-VALUE = estabelec.nome.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel wReport
ON MOUSE-SELECT-DBLCLICK OF c-cod-estabel IN FRAME fPage2 /* Estabelecimento */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo wReport
ON F5 OF c-it-codigo IN FRAME fPage2 /* Produto */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                       &campo="c-it-codigo"
                       &campozoom="it-codigo"
                       &campo2="cDesc-item"
                       &campozoom2="desc-item"
                       &frame="fPage2"}
                       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo wReport
ON LEAVE OF c-it-codigo IN FRAME fPage2 /* Produto */
DO:
  FIND FIRST item NO-LOCK
       WHERE item.it-codigo = INPUT FRAME fPage2 c-it-codigo NO-ERROR.
  IF AVAIL item THEN
      ASSIGN cDesc-item:SCREEN-VALUE IN FRAME fPage2 = item.desc-item.
  ELSE
      ASSIGN cDesc-item:SCREEN-VALUE IN FRAME fPage2 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo wReport
ON MOUSE-SELECT-DBLCLICK OF c-it-codigo IN FRAME fPage2 /* Produto */
DO:
  APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-unid-negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-unid-negoc wReport
ON F5 OF c-unid-negoc IN FRAME fPage2 /* Unidade Neg¢cio */
DO:
  /*&if "{&bf_mat_versao_ems}" >= "2.062" &then   */
   {method/ZoomFields.i
          &ProgramZoom="inzoom/z01in745.w"
          &FieldZoom1="cod-unid-negoc"
          &FieldScreen1="c-unid-negoc"
          &Frame1="fPage2"
          &FieldZoom2="des-unid-negoc"
          &FieldScreen2="v_des_unid_negoc"
          &Frame2="fPage2"
          &EnableImplant="no"}
   /*&endif  */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-unid-negoc wReport
ON LEAVE OF c-unid-negoc IN FRAME fPage2 /* Unidade Neg¢cio */
DO:
  /*  MESSAGE 'oO'
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
  &if "{&bf_mat_versao_ems}" >= "2.062" &then*/
  define variable c-desc-uneg as character no-undo.
  
  run SetConstraintCodigo in h-boin745(input input frame fPage2 c-unid-negoc,
                                       input input frame fPage2 c-unid-negoc).
  run openQueryStatic     in h-boin745(input "Codigo":U).
  if return-value = "OK" then do:
      run getCharField in h-boin745(input "des-unid-negoc",
                                    output c-desc-uneg).
      assign v_des_unid_negoc:screen-value in frame fPage2 = c-desc-uneg. 
  end.
  else
      assign v_des_unid_negoc:screen-value in frame fPage2 = "". 
  /*&endif*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-unid-negoc wReport
ON MOUSE-SELECT-DBLCLICK OF c-unid-negoc IN FRAME fPage2 /* Unidade Neg¢cio */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-nr-seq-orig-prob
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nr-seq-orig-prob wReport
ON F5 OF i-nr-seq-orig-prob IN FRAME fPage2 /* Origem */
DO:
    {method/ZoomFields.i &ProgramZoom="eszoom/z01es679.w"
                       &FieldZoom1="nr-seq-orig-prob"
                       &FieldScreen1="i-nr-seq-orig-prob"
                       &Frame1="fPage2"
                       &FieldZoom2="des-orig-prob"
                       &FieldScreen2="v_des_origem_prob"
                       &Frame2="fPage2"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nr-seq-orig-prob wReport
ON LEAVE OF i-nr-seq-orig-prob IN FRAME fPage2 /* Origem */
DO:
    FOR FIRST aq-origem-prob NO-LOCK
        WHERE aq-origem-prob.nr-seq-orig-prob = INPUT FRAME fpage2 i-nr-seq-orig-prob:

        ASSIGN v_des_origem_prob:SCREEN-VALUE IN FRAME fPage2 = aq-origem-prob.des-orig-prob.

    END.

    IF NOT AVAIL aq-origem-prob THEN
        ASSIGN v_des_origem_prob:SCREEN-VALUE IN FRAME fPage2 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nr-seq-orig-prob wReport
ON MOUSE-SELECT-DBLCLICK OF i-nr-seq-orig-prob IN FRAME fPage2 /* Origem */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-nr-seq-tipo-lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nr-seq-tipo-lote wReport
ON F5 OF i-nr-seq-tipo-lote IN FRAME fPage2 /* Lote */
DO:

    {method/ZoomFields.i &ProgramZoom="eszoom/z01es678.w"
                         &FieldZoom1="nr-seq-tipo-lote"
                         &FieldScreen1="i-nr-seq-tipo-lote"
                         &Frame1="fPage2"
                         &FieldZoom2="des-lote"
                         &FieldScreen2="fi-desc-tipo-lote"
                         &Frame2="fPage2"
                         &EnableImplant="NO"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nr-seq-tipo-lote wReport
ON LEAVE OF i-nr-seq-tipo-lote IN FRAME fPage2 /* Lote */
DO:

    ASSIGN fi-desc-tipo-lote:SCREEN-VALUE IN FRAME fpage2 = "".

    FOR FIRST aq-tipo-lote NO-LOCK
        WHERE aq-tipo-lote.nr-seq-tipo-lote = INPUT FRAME fPage2 i-nr-seq-tipo-lote:

        ASSIGN fi-desc-tipo-lote:SCREEN-VALUE IN FRAME fpage2 = aq-tipo-lote.des-lote.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nr-seq-tipo-lote wReport
ON MOUSE-SELECT-DBLCLICK OF i-nr-seq-tipo-lote IN FRAME fPage2 /* Lote */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME iNr-linha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL iNr-linha wReport
ON F5 OF iNr-linha IN FRAME fPage2 /* Linha Produ‡Æo */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in186.w"
                      &campo="iNr-linha"
                      &campozoom="nr-linha"
                      &campo2="cDescricaoLinProd"
                      &campozoom2="descricao"
                      &frame="fPage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL iNr-linha wReport
ON LEAVE OF iNr-linha IN FRAME fPage2 /* Linha Produ‡Æo */
DO:
  FIND FIRST lin-prod NO-LOCK
       WHERE lin-prod.cod-estabel = INPUT FRAME fPage2 c-cod-estabel
         AND lin-prod.nr-linha = INPUT FRAME fPage2 iNr-linha NO-ERROR.
  IF AVAIL lin-prod THEN
      ASSIGN cDescricaoLinProd:SCREEN-VALUE IN FRAME fPage2 = lin-prod.descricao.
  ELSE
      ASSIGN cDescricaoLinProd:SCREEN-VALUE IN FRAME fPage2 = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL iNr-linha wReport
ON MOUSE-SELECT-DBLCLICK OF iNr-linha IN FRAME fPage2 /* Linha Produ‡Æo */
DO:
  APPLY 'F5' TO SELF.
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
        /*Alterado 15/02/2005 - tech1007 - Condi‡Æo removida pois RTF nÆo ‚ mais um destino
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


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{report/mainblock.i}

c-cod-estabel:load-mouse-pointer("image/lupa.cur") IN FRAME fPage2.
iNr-linha:load-mouse-pointer("image/lupa.cur") IN FRAME fPage2.
c-it-codigo:load-mouse-pointer("image/lupa.cur") IN FRAME fPage2.
c-unid-negoc:load-mouse-pointer("image/lupa.cur") IN FRAME fPage2.
i-nr-seq-orig-prob:load-mouse-pointer("image/lupa.cur") IN FRAME fPage2.
i-nr-seq-tipo-lote:load-mouse-pointer("image/lupa.cur") IN FRAME fPage2.

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
/*Alterado 17/02/2005 - tech1007 - Foi criado essa procedure para que seja realizado a inicializa‡Æo
  correta dos componentes do RTF quando executado em ambiente local e no WebEnabler.*/
&IF "{&RTF}":U = "YES":U &THEN
IF VALID-HANDLE(hWenController) THEN DO:
    ASSIGN l-habilitaRtf:sensitive IN FRAME fPage6 = NO
           l-habilitaRtf:SCREEN-VALUE IN FRAME fPage6 = "No"
           l-habilitaRtf = NO.
           
END.
RUN pi-habilitaRtf.
&endif

/*&if "{&bf_mat_versao_ems}" >= "2.062" &then*/
IF  NOT VALID-HANDLE(h-boin745) THEN
    run inbo/boin745.p persistent set h-boin745.
/*&endif*/

RETURN "OK":U.
/*Fim alteracao 17/02/2005*/
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

    /*15/02/2005 - tech1007 - Teste alterado pois RTF nÆo ‚ mais op‡Æo de Destino*/
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
    &IF "{&RTF}":U = "YES":U &THEN
    IF ( input frame fPage6 cModelRTF = "" AND
         input frame fPage6 l-habilitaRtf = YES ) OR
       ( SEARCH(INPUT FRAME fPage6 cModelRTF) = ? AND
         input frame fPage6 rsExecution = 1 AND
         input frame fPage6 l-habilitaRtf = YES )
         THEN DO:
        run utp/ut-msgs.p (input "show":U, input 73, input "":U).
        /*30/12/2004 - tech1007 - Evento removido pois causa problemas no WebEnabler*/
        /*apply "CHOOSE":U to blModelRtf in frame fPage6.*/
        return error.
    END.
    &endif
   
  
    
    /*:T Coloque aqui as valida‡äes das outras p ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p gina com 
       problemas e colocar o focus no campo com problemas */

    IF INPUT FRAME fPage2 datIniAdicional > INPUT FRAME fPage2 datFimAdicional THEN DO:
        run SetFolder IN hFolder (INPUT 2).
        run utp/ut-msgs.p (input "show":U, input 17006, input "Faixa incorreta." + "~~" + "Data final deve ser maior ou igual a data inicial.":U).
        apply "ENTRY":U to datFimAdicional in frame fPage2.
        return error.

    END.
    
    
    /*:T Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
       para o programa RP.P */
    
    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame fPage6 rsDestiny
           tt-param.data-exec       = today
           tt-param.hora-exec       = time
           tt-param.dat-adic-ini    = input frame fPage2 datIniAdicional
           tt-param.dat-adic-fim    = input frame fPage2 datFimAdicional
           tt-param.cod-estabel     = input frame fPage2 c-cod-estabel
           tt-param.nr-linha        = input frame fPage2 iNr-linha
           tt-param.it-codigo       = input frame fPage2 c-it-codigo
           tt-param.cod-uneg        = input frame fPage2 c-unid-negoc
           tt-param.nr-orig-prob    = input frame fPage2 i-nr-seq-orig-prob
           tt-param.tip-lote        = input frame fPage2 i-nr-seq-tipo-lote
           &if "{&RTF}":U = "YES":U &then
           tt-param.modelo          = input frame fPage6 cModelRTF
           tt-param.l-habilitaRtf    = input frame fPage6 ll-habilitaRtf
           &endif
           .
    
    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "":U.
    else if  tt-param.destino = 2 
        then assign tt-param.arquivo = replace(input frame fPage6 cFile, "LST", "CSV").
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".csv":U.
    
    /*:T Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */
    
    
    
    /*:T Executar do programa RP.P que ir  criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i esp/aqp/esaqp017rp.p}
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    /*{report/rptrm.i}*/
end.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

