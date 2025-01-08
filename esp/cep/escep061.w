&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
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
{include/i-prgvrs.i ESCEP061 2.00.00.000}
/*------------------------------------------------------------------------
    File        : ESCEP061.W
    Purpose     : Invent rio
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI / SQL Works)
    Created     : Novembro de 2011
    Notes       : <none>
----------------------------------------------------------------------*/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCEP061
&GLOBAL-DEFINE Version        2.00.00.000
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Sele‡Æo,Parƒmetro,Digita‡Æo,ImpressÆo

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
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
&GLOBAL-DEFINE page4Widgets   tgConsidSaldoNFS ~
                              tgConsidSaldoTransf ~
                              tgConsidSaldoAE ~
                              tgGerarDetalhesAE ~
                              tgConsidSaldoCST
&GLOBAL-DEFINE page5Widgets   brDigita ~
                              btAdd ~
                              btUpdate ~
                              btDelete ~
                              btSave ~
                              btOpen
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btFile ~
                              btConfigImpr ~
                              rsExecution ~
                              btFileCSV ~
                              btFileDetAE
&GLOBAL-DEFINE page7Widgets   
&GLOBAL-DEFINE page8Widgets   

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino ~
                              text-modo ~
                              text-csv ~
                              text-detalhes-ae
&GLOBAL-DEFINE page7Text      
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    fiCodEstab-1 ~
                              fiNomeEstab-1 ~
                              fiCodDepos-1 ~
                              fiNomeDepos-1 ~
                              fiCodEstab-2 ~
                              fiNomeEstab-2 ~
                              fiCodDepos-2 ~
                              fiNomeDepos-2 ~
                              fiItCodigoIni ~
                              fiItCodigoFin ~
                              fiCodLocalizIni ~
                              fiCodLocalizFin
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields    fiDataCorteNFS
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile ~
                              cFileCSV ~
                              cFileDetalhesAE
&GLOBAL-DEFINE page7Fields    
&GLOBAL-DEFINE page8Fields    


/* Include Definitions ---                                              */

{esp/cep/escep061.i} /* Defini‡Æo das temp-tables tt-param, tt-digita e
                        tt-raw-digita de uso comum aos programas
                        ESCEP061.W e ESCEP061RP.P */


/* Buffer Definitions ---                                               */

DEFINE BUFFER b-tt-digita FOR tt-digita.


/* Transfer Definitions ---                                             */

DEFINE VARIABLE raw-param AS RAW         NO-UNDO.


/* Local Variable Definitions ---                                       */

DEFINE VARIABLE l-ok             AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-arq-digita     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-terminal       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-rtf            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-layout     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-temp       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-modelo-default AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-desc-item      LIKE item.desc-item NO-UNDO.

DEFINE VARIABLE c-dt-hr-arq      AS CHARACTER   NO-UNDO.


/* Stream Definitions ---                                               */

DEFINE STREAM s-imp.


/*15/02/2005 - tech1007 - Variavel definida para tratar se o programa est  rodando no WebEnabler*/
DEFINE SHARED VARIABLE hWenController AS HANDLE NO-UNDO.
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
&Scoped-define FIELDS-IN-QUERY-brDigita tt-digita.it-codigo fnDescItem(tt-digita.it-codigo) @ c-desc-item   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDigita tt-digita.it-codigo   
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


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescItem wReport 
FUNCTION fnDescItem RETURNS CHARACTER
  ( p-it-codigo AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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

DEFINE VARIABLE fiCodDepos-1 LIKE deposito.cod-depos
     LABEL "Dep¢sito 1":R10 
     VIEW-AS FILL-IN 
     SIZE 7.29 BY .88 NO-UNDO.

DEFINE VARIABLE fiCodDepos-2 LIKE deposito.cod-depos
     LABEL "Dep¢sito 2":R10 
     VIEW-AS FILL-IN 
     SIZE 7.29 BY .88 NO-UNDO.

DEFINE VARIABLE fiCodEstab-1 LIKE estabelec.cod-estabel
     LABEL "Estabelecimento 1" 
     VIEW-AS FILL-IN 
     SIZE 7.29 BY .88 NO-UNDO.

DEFINE VARIABLE fiCodEstab-2 LIKE estabelec.cod-estabel
     LABEL "Estabelecimento 2" 
     VIEW-AS FILL-IN 
     SIZE 7.29 BY .88 NO-UNDO.

DEFINE VARIABLE fiCodLocalizFin LIKE mgcad.localizacao.cod-localiz
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fiCodLocalizIni LIKE mgcad.localizacao.cod-localiz
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fiItCodigoFin LIKE item.it-codigo
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fiItCodigoIni LIKE item.it-codigo
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fiNomeDepos-1 LIKE deposito.nome
     VIEW-AS FILL-IN 
     SIZE 39.29 BY .88 NO-UNDO.

DEFINE VARIABLE fiNomeDepos-2 LIKE deposito.nome
     VIEW-AS FILL-IN 
     SIZE 39.29 BY .88 NO-UNDO.

DEFINE VARIABLE fiNomeEstab-1 LIKE estabelec.nome
     VIEW-AS FILL-IN 
     SIZE 39.29 BY .88 NO-UNDO.

DEFINE VARIABLE fiNomeEstab-2 LIKE estabelec.nome
     VIEW-AS FILL-IN 
     SIZE 39.29 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE fiDataCorteNFS AS DATE FORMAT "99/99/9999":U 
     LABEL "Considerar NFS apartir de" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE tgConsidSaldoAE AS LOGICAL INITIAL no 
     LABEL "Considera Saldo AE" 
     VIEW-AS TOGGLE-BOX
     SIZE 25.86 BY 1.08 NO-UNDO.

DEFINE VARIABLE tgConsidSaldoCST AS LOGICAL INITIAL no 
     LABEL "Considera Saldo CST" 
     VIEW-AS TOGGLE-BOX
     SIZE 25.86 BY 1.08 NO-UNDO.

DEFINE VARIABLE tgConsidSaldoNFS AS LOGICAL INITIAL no 
     LABEL "Considera Saldo NFS" 
     VIEW-AS TOGGLE-BOX
     SIZE 25.86 BY 1.08 NO-UNDO.

DEFINE VARIABLE tgConsidSaldoTransf AS LOGICAL INITIAL no 
     LABEL "Considera Saldo Transferˆncia" 
     VIEW-AS TOGGLE-BOX
     SIZE 25.86 BY 1.08 NO-UNDO.

DEFINE VARIABLE tgGerarDetalhesAE AS LOGICAL INITIAL no 
     LABEL "Gerar Detalhes do AE" 
     VIEW-AS TOGGLE-BOX
     SIZE 19.43 BY 1.08 NO-UNDO.

DEFINE VARIABLE tgListarNFs AS LOGICAL INITIAL no 
     LABEL "Listar Notas Fiscais" 
     VIEW-AS TOGGLE-BOX
     SIZE 19.43 BY 1.08 TOOLTIP "Listas as notas fiscais que compäem o saldo do item?" NO-UNDO.

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

DEFINE BUTTON btFileCSV 
     IMAGE-UP FILE "image/im-sea.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-sea.bmp":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFileDetAE 
     IMAGE-UP FILE "image/im-sea.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-sea.bmp":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE cFileCSV AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE cFileDetalhesAE AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-csv AS CHARACTER FORMAT "X(256)":U INITIAL " Relat¢rio .CSV" 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.14 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-detalhes-ae AS CHARACTER FORMAT "X(256)":U INITIAL " Relat¢rio Detalhe AE" 
      VIEW-AS TEXT 
     SIZE 18 BY .63 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL " Execu‡Æo" 
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

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 2.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 2.92.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 1.71.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 2.

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
      fnDescItem(tt-digita.it-codigo) @ c-desc-item
      ENABLE
      tt-digita.it-codigo
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 82 BY 8.75
         BGCOLOR 15 FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2 HELP
          "Executar"
     btCancel AT ROW 16.75 COL 13 HELP
          "Fechar"
     btHelp2 AT ROW 16.75 COL 80 HELP
          "Ajuda"
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.14 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     cFile AT ROW 3.63 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     btFile AT ROW 3.5 COL 43 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.5 COL 43 HELP
          "Configura‡Æo da impressora"
     rsExecution AT ROW 5.58 COL 3.14 HELP
          "Modo de Execu‡Æo" NO-LABEL
     cFileCSV AT ROW 8.21 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio .CSV" NO-LABEL
     btFileCSV AT ROW 8.13 COL 43.14 HELP
          "Escolha do nome do arquivo"
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     cFileDetalhesAE AT ROW 10.67 COL 3.14 HELP
          "Nome do arquivo de destino do relat¢rio detalhe AE" NO-LABEL
     btFileDetAE AT ROW 10.58 COL 43.14 HELP
          "Escolha do nome do arquivo"
     text-modo AT ROW 5 COL 2 COLON-ALIGNED NO-LABEL
     text-csv AT ROW 7.17 COL 2 COLON-ALIGNED NO-LABEL
     text-detalhes-ae AT ROW 9.63 COL 2 COLON-ALIGNED NO-LABEL
     RECT-2 AT ROW 1.92 COL 2.14
     RECT-3 AT ROW 5.29 COL 2
     RECT-1 AT ROW 7.46 COL 2
     RECT-4 AT ROW 9.92 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 11.46
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
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 11.46
         FONT 1.

DEFINE FRAME fPage2
     fiCodEstab-1 AT ROW 1.5 COL 22.72 COLON-ALIGNED HELP
          "C¢digo do estabelecimento 1"
          LABEL "Estabelecimento 1"
     fiNomeEstab-1 AT ROW 1.5 COL 30.43 COLON-ALIGNED HELP
          "Nome Estabelecimento" NO-LABEL
     fiCodDepos-1 AT ROW 2.5 COL 22.72 COLON-ALIGNED HELP
          "C¢digo do dep¢sito 1"
          LABEL "Dep¢sito 1":R10
     fiNomeDepos-1 AT ROW 2.5 COL 30.43 COLON-ALIGNED HELP
          "Descri‡Æo do Dep¢sito" NO-LABEL
     fiCodEstab-2 AT ROW 4.5 COL 22.72 COLON-ALIGNED HELP
          "C¢digo do estabelecimento 2"
          LABEL "Estabelecimento 2"
     fiNomeEstab-2 AT ROW 4.5 COL 30.43 COLON-ALIGNED HELP
          "Nome Estabelecimento" NO-LABEL
     fiCodDepos-2 AT ROW 5.5 COL 22.72 COLON-ALIGNED HELP
          "C¢digo do dep¢sito 2"
          LABEL "Dep¢sito 2":R10
     fiNomeDepos-2 AT ROW 5.5 COL 30.43 COLON-ALIGNED HELP
          "Descri‡Æo do Dep¢sito" NO-LABEL
     fiItCodigoIni AT ROW 7.5 COL 35 RIGHT-ALIGNED HELP
          "C¢digo do item inicial"
     fiItCodigoFin AT ROW 7.5 COL 54.14 HELP
          "C¢digo do item final" NO-LABEL
     fiCodLocalizIni AT ROW 8.5 COL 35 RIGHT-ALIGNED HELP
          "C¢digo da localiza‡Æo inicial"
     fiCodLocalizFin AT ROW 8.5 COL 54.14 HELP
          "C¢digo da localiza‡Æo final" NO-LABEL
     IMAGE-1 AT ROW 7.5 COL 36.14
     IMAGE-2 AT ROW 7.5 COL 51.14
     IMAGE-3 AT ROW 8.5 COL 36.14
     IMAGE-4 AT ROW 8.5 COL 51.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 11.46
         FONT 1.

DEFINE FRAME fPage4
     tgConsidSaldoNFS AT ROW 1.29 COL 3.14 HELP
          "Considera Saldo NFS"
     fiDataCorteNFS AT ROW 2.38 COL 25.57 COLON-ALIGNED HELP
          "Considerar NFS apartir de"
     tgListarNFs AT ROW 3.29 COL 9.57 HELP
          "Listas as notas fiscais que compäem o saldo do item?" WIDGET-ID 2
     tgConsidSaldoTransf AT ROW 4.29 COL 3.14 HELP
          "Considera Saldo Transferˆncia"
     tgConsidSaldoAE AT ROW 5.29 COL 3.14 HELP
          "Considera Saldo AE"
     tgGerarDetalhesAE AT ROW 6.29 COL 9.57 HELP
          "Gerar Detalhes do AE"
     tgConsidSaldoCST AT ROW 7.29 COL 3.14 HELP
          "Considera Saldo CST"
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 11.46
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
       FRAME fPage5:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN fiCodDepos-1 IN FRAME fPage2
   LIKE = mgcad.deposito.cod-depos EXP-LABEL EXP-HELP EXP-SIZE         */
/* SETTINGS FOR FILL-IN fiCodDepos-2 IN FRAME fPage2
   LIKE = mgcad.deposito.cod-depos EXP-LABEL EXP-HELP EXP-SIZE         */
/* SETTINGS FOR FILL-IN fiCodEstab-1 IN FRAME fPage2
   LIKE = mgcad.estabelec.cod-estabel EXP-LABEL EXP-HELP EXP-SIZE      */
/* SETTINGS FOR FILL-IN fiCodEstab-2 IN FRAME fPage2
   LIKE = mgcad.estabelec.cod-estabel EXP-LABEL EXP-HELP EXP-SIZE      */
/* SETTINGS FOR FILL-IN fiCodLocalizFin IN FRAME fPage2
   ALIGN-L LIKE = mgcad.localizacao.cod-localiz EXP-HELP EXP-SIZE      */
/* SETTINGS FOR FILL-IN fiCodLocalizIni IN FRAME fPage2
   ALIGN-R LIKE = mgcad.localizacao.cod-localiz EXP-HELP EXP-SIZE      */
/* SETTINGS FOR FILL-IN fiItCodigoFin IN FRAME fPage2
   ALIGN-L LIKE = mgcad.item.it-codigo EXP-HELP EXP-SIZE               */
/* SETTINGS FOR FILL-IN fiItCodigoIni IN FRAME fPage2
   ALIGN-R LIKE = mgcad.item.it-codigo EXP-HELP EXP-SIZE               */
/* SETTINGS FOR FILL-IN fiNomeDepos-1 IN FRAME fPage2
   LIKE = mgcad.deposito.nome EXP-SIZE                                 */
/* SETTINGS FOR FILL-IN fiNomeDepos-2 IN FRAME fPage2
   LIKE = mgcad.deposito.nome EXP-SIZE                                 */
/* SETTINGS FOR FILL-IN fiNomeEstab-1 IN FRAME fPage2
   LIKE = mgcad.estabelec.nome EXP-SIZE                                */
/* SETTINGS FOR FILL-IN fiNomeEstab-2 IN FRAME fPage2
   LIKE = mgcad.estabelec.nome EXP-SIZE                                */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FRAME fPage5
                                                                        */
/* BROWSE-TAB brDigita 1 fPage5 */
/* SETTINGS FOR FRAME fPage6
   Custom                                                               */
/* SETTINGS FOR FILL-IN text-csv IN FRAME fPage6
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       text-csv:PRIVATE-DATA IN FRAME fPage6     = 
                "Relat¢rio .CSV".

ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

/* SETTINGS FOR FILL-IN text-detalhes-ae IN FRAME fPage6
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       text-detalhes-ae:PRIVATE-DATA IN FRAME fPage6     = 
                "Relat¢rio Detalhe AE".

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

        IF AVAILABLE tt-digita THEN
            display tt-digita.it-codigo
                    c-desc-item
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
   /*:T trigger para inicializar campos da temp table de digita‡Æo */
   if  brDigita:new-row in frame fPage5 then do:
       assign c-desc-item:screen-value in browse brDigita = '':U.
   end.
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
        assign input browse brDigita tt-digita.it-codigo.

        brDigita:CREATE-RESULT-LIST-ENTRY() in frame fPage5.
    end.
    else do transaction on error undo, return no-apply:
        if avail tt-digita then
            assign input browse brDigita tt-digita.it-codigo.
    end.

    IF AVAILABLE tt-digita THEN
        DISPLAY tt-digita.it-codigo
                fnDescItem(tt-digita.it-codigo) @ c-desc-item
            WITH BROWSE brDigita.
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


&Scoped-define SELF-NAME btFileCSV
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFileCSV wReport
ON CHOOSE OF btFileCSV IN FRAME fPage6
DO:
    DEFINE VARIABLE cConvFile AS CHARACTER   NO-UNDO.

    ASSIGN cConvFile = REPLACE(INPUT FRAME fPage6 cFileCSV, "/":U, "~\":U).

    SYSTEM-DIALOG GET-FILE cConvFile
        FILTERS "CSV (separado por ponto e v¡rgula)(*.csv)":U "*.csv":U,
                "Todos os arquivos (*.*)":U "*.*":U
        ASK-OVERWRITE
        SAVE-AS
        DEFAULT-EXTENSION "csv":U
        INITIAL-DIR "spool":U
        USE-FILENAME
        UPDATE l-ok.

    IF l-ok THEN DO:
        ASSIGN cFileCSV = REPLACE(cConvFile, "~\":U, "/":U).

        DISPLAY cFileCSV
            WITH FRAME fPage6.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFileDetAE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFileDetAE wReport
ON CHOOSE OF btFileDetAE IN FRAME fPage6
DO:
    DEFINE VARIABLE cConvFile AS CHARACTER   NO-UNDO.

    ASSIGN cConvFile = REPLACE(INPUT FRAME fPage6 cFileDetalhesAE, "/":U, "~\":U).

    SYSTEM-DIALOG GET-FILE cConvFile
        FILTERS "CSV (separado por ponto e v¡rgula)(*.csv)":U "*.csv":U,
                "Todos os arquivos (*.*)":U "*.*":U
        ASK-OVERWRITE
        SAVE-AS
        DEFAULT-EXTENSION "csv":U
        INITIAL-DIR "spool":U
        USE-FILENAME
        UPDATE l-ok.

    IF l-ok THEN DO:
        ASSIGN cFileDetalhesAE = REPLACE(cConvFile, "~\":U, "/":U).

        DISPLAY cFileDetalhesAE
            WITH FRAME fPage6.
    END.
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
   apply 'entry' to tt-digita.it-codigo in browse brDigita. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME fiCodDepos-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodDepos-1 wReport
ON F5 OF fiCodDepos-1 IN FRAME fPage2 /* Dep¢sito 1 */
DO:
    ASSIGN l-implanta = YES.

    {include/zoomvar.i &prog-zoom="inzoom/z01in084.w"
                       &campo="fiCodDepos-1"
                       &campozoom="cod-depos"
                       &frame="fPage2"
                       &campo2="fiNomeDepos-1"
                       &campozoom2="nome"
                       &frame2="fPage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodDepos-1 wReport
ON LEAVE OF fiCodDepos-1 IN FRAME fPage2 /* Dep¢sito 1 */
DO:
    ASSIGN INPUT FRAME fPage2 fiCodDepos-1.

    FIND FIRST deposito
        WHERE deposito.cod-depos = fiCodDepos-1 NO-LOCK NO-ERROR.

    IF AVAILABLE deposito THEN
        ASSIGN fiNomeDepos-1 = deposito.nome.
    ELSE
        ASSIGN fiNomeDepos-1 = "":U.

    DISPLAY fiNomeDepos-1
        WITH FRAME fPage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodDepos-1 wReport
ON MOUSE-SELECT-DBLCLICK OF fiCodDepos-1 IN FRAME fPage2 /* Dep¢sito 1 */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiCodDepos-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodDepos-2 wReport
ON F5 OF fiCodDepos-2 IN FRAME fPage2 /* Dep¢sito 2 */
DO:
    ASSIGN l-implanta = YES.

    {include/zoomvar.i &prog-zoom="inzoom/z01in084.w"
                       &campo="fiCodDepos-2"
                       &campozoom="cod-depos"
                       &frame="fPage2"
                       &campo2="fiNomeDepos-2"
                       &campozoom2="nome"
                       &frame2="fPage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodDepos-2 wReport
ON LEAVE OF fiCodDepos-2 IN FRAME fPage2 /* Dep¢sito 2 */
DO:
    ASSIGN INPUT FRAME fPage2 fiCodDepos-2.

    FIND FIRST deposito
        WHERE deposito.cod-depos = fiCodDepos-2 NO-LOCK NO-ERROR.

    IF AVAILABLE deposito THEN
        ASSIGN fiNomeDepos-2 = deposito.nome.
    ELSE
        ASSIGN fiNomeDepos-2 = "":U.

    DISPLAY fiNomeDepos-2
        WITH FRAME fPage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodDepos-2 wReport
ON MOUSE-SELECT-DBLCLICK OF fiCodDepos-2 IN FRAME fPage2 /* Dep¢sito 2 */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiCodEstab-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodEstab-1 wReport
ON F5 OF fiCodEstab-1 IN FRAME fPage2 /* Estabelecimento 1 */
DO:
    ASSIGN l-implanta = YES.

    {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                       &campo="fiCodEstab-1"
                       &campozoom="cod-estabel"
                       &frame="fPage2"
                       &campo2="fiNomeEstab-1"
                       &campozoom2="nome"
                       &frame2="fPage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodEstab-1 wReport
ON LEAVE OF fiCodEstab-1 IN FRAME fPage2 /* Estabelecimento 1 */
DO:
    ASSIGN INPUT FRAME fPage2 fiCodEstab-1.

    FIND FIRST estabelec
        WHERE estabelec.cod-estabel = fiCodEstab-1 NO-LOCK NO-ERROR.

    IF AVAILABLE estabelec THEN
        ASSIGN fiNomeEstab-1 = estabelec.nome.
    ELSE
        ASSIGN fiNomeEstab-1 = "":U.

    DISPLAY fiNomeEstab-1
        WITH FRAME fPage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodEstab-1 wReport
ON MOUSE-SELECT-DBLCLICK OF fiCodEstab-1 IN FRAME fPage2 /* Estabelecimento 1 */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiCodEstab-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodEstab-2 wReport
ON F5 OF fiCodEstab-2 IN FRAME fPage2 /* Estabelecimento 2 */
DO:
    ASSIGN l-implanta = YES.

    {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                       &campo="fiCodEstab-2"
                       &campozoom="cod-estabel"
                       &frame="fPage2"
                       &campo2="fiNomeEstab-2"
                       &campozoom2="nome"
                       &frame2="fPage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodEstab-2 wReport
ON LEAVE OF fiCodEstab-2 IN FRAME fPage2 /* Estabelecimento 2 */
DO:
    ASSIGN INPUT FRAME fPage2 fiCodEstab-2.

    FIND FIRST estabelec
        WHERE estabelec.cod-estabel = fiCodEstab-2 NO-LOCK NO-ERROR.

    IF AVAILABLE estabelec THEN
        ASSIGN fiNomeEstab-2 = estabelec.nome.
    ELSE
        ASSIGN fiNomeEstab-2 = "":U.

    DISPLAY fiNomeEstab-2
        WITH FRAME fPage2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCodEstab-2 wReport
ON MOUSE-SELECT-DBLCLICK OF fiCodEstab-2 IN FRAME fPage2 /* Estabelecimento 2 */
DO:
    APPLY "F5":U TO SELF.
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

   CASE SELF:SCREEN-VALUE:
       WHEN "1":U THEN DO:
           FIND FIRST usuar_mestre
               WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-LOCK NO-ERROR.

           IF AVAILABLE usuar_mestre THEN
               ASSIGN cFileCSV = IF LENGTH(usuar_mestre.nom_subdir_spool) <> 0 THEN
                                     CAPS(REPLACE(usuar_mestre.nom_dir_spool, "~\":U, "/":U) + "/":U + REPLACE(usuar_mestre.nom_subdir_spool, "~\":U, "/":U) + "/":U + c-programa-mg97 + c-dt-hr-arq + ".csv":U)
                                 ELSE
                                     CAPS(REPLACE(usuar_mestre.nom_dir_spool, "~\":U, "/":U) + "/":U + c-programa-mg97 + c-dt-hr-arq + ".csv":U).
           ELSE
               ASSIGN cFileCSV = CAPS(SESSION:TEMP-DIRECTORY + c-programa-mg97 + c-dt-hr-arq + ".csv":U).
       END.
       WHEN "2":U THEN
           ASSIGN cFileCSV = CAPS(c-programa-mg97 + c-dt-hr-arq + ".csv":U).
   END CASE.

   DISPLAY cFileCSV
       WITH FRAME fPage6.

   APPLY "VALUE-CHANGED":U TO tgGerarDetalhesAE IN FRAME fPage4.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME tgConsidSaldoAE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tgConsidSaldoAE wReport
ON VALUE-CHANGED OF tgConsidSaldoAE IN FRAME fPage4 /* Considera Saldo AE */
DO:
    IF SELF:CHECKED THEN DO:
        ENABLE tgGerarDetalhesAE
            WITH FRAME fPage4.
    END.
    ELSE DO:
       ASSIGN tgGerarDetalhesAE = NO.
        
       DISPLAY tgGerarDetalhesAE WITH FRAME fPage4.
       DISABLE tgGerarDetalhesAE WITH FRAME fPage4.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tgConsidSaldoNFS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tgConsidSaldoNFS wReport
ON VALUE-CHANGED OF tgConsidSaldoNFS IN FRAME fPage4 /* Considera Saldo NFS */
DO:
    IF  SELF:CHECKED THEN DO:
        ENABLE fiDataCorteNFS
               tgListarNFs
            WITH FRAME fPage4.

        ASSIGN fiDataCorteNFS = TODAY - 60.

        DISPLAY fiDataCorteNFS
            WITH FRAME fPage4.
    END.
    ELSE DO:
        DISABLE fiDataCorteNFS
                tgListarNFs
            WITH FRAME fPage4.

        ASSIGN fiDataCorteNFS      = ?
               tgListarNFs:CHECKED = NO.

        DISPLAY fiDataCorteNFS
            WITH FRAME fPage4.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tgGerarDetalhesAE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tgGerarDetalhesAE wReport
ON VALUE-CHANGED OF tgGerarDetalhesAE IN FRAME fPage4 /* Gerar Detalhes do AE */
DO:
    IF SELF:CHECKED THEN DO:
        CASE INPUT FRAME fPage6 rsExecution:
            WHEN 1 THEN DO:
                FIND FIRST usuar_mestre
                    WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-LOCK NO-ERROR.

                IF AVAILABLE usuar_mestre THEN
                    ASSIGN cFileDetalhesAE = IF LENGTH(usuar_mestre.nom_subdir_spool) <> 0 THEN
                                                 CAPS(REPLACE(usuar_mestre.nom_dir_spool, "~\":U, "/":U) + "/":U + REPLACE(usuar_mestre.nom_subdir_spool, "~\":U, "/":U) + "/":U + "detalhes-ae-":U + c-programa-mg97 + c-dt-hr-arq + ".csv":U)
                                             ELSE
                                                 CAPS(REPLACE(usuar_mestre.nom_dir_spool, "~\":U, "/":U) + "/":U + "detalhes-ae-":U + c-programa-mg97 + c-dt-hr-arq + ".csv":U).
                ELSE
                    ASSIGN cFileDetalhesAE = CAPS(SESSION:TEMP-DIRECTORY + "detalhes-ae-":U + c-programa-mg97 + c-dt-hr-arq + ".csv":U).
            END.
            WHEN 2 THEN
                ASSIGN cFileDetalhesAE = CAPS("detalhes-ae-":U + c-programa-mg97 + c-dt-hr-arq + ".csv":U).
        END CASE.

        ASSIGN cFileDetalhesAE:BGCOLOR IN FRAME fPage6 = 15.

        DISPLAY cFileDetalhesAE
            WITH FRAME fPage6.

        ENABLE text-detalhes-ae
               cFileDetalhesAE
               btFileDetAE
            WITH FRAME fPage6.
    END.
    ELSE DO:
        ASSIGN cFileDetalhesAE = "":U.

        ASSIGN cFileDetalhesAE:BGCOLOR IN FRAME fPage6 = ?.

        DISPLAY cFileDetalhesAE
            WITH FRAME fPage6.

        DISABLE text-detalhes-ae
                cFileDetalhesAE
                btFileDetAE
            WITH FRAME fPage6.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{report/mainblock.i}

IF fiCodEstab-1:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage2 THEN.
IF fiCodDepos-1:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage2 THEN.
IF fiCodEstab-2:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage2 THEN.
IF fiCodDepos-2:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage2 THEN.

ON 'F5':U OF tt-digita.it-codigo IN BROWSE brDigita
OR 'MOUSE-SELECT-DBLCLICK':U OF tt-digita.it-codigo IN BROWSE brDigita
DO:
    IF NOT AVAILABLE tt-digita              AND
       NOT brDigita:NEW-ROW IN FRAME fPage5 THEN
        RETURN NO-APPLY.

    {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                       &campo="tt-digita.it-codigo"
                       &campozoom="it-codigo"
                       &browse="brDigita"
                       &campo2="c-desc-item"
                       &campozoom2="desc-item"
                       &browse2="brDigita"}
END.

ON "ENTER":U      OF cFileCSV IN FRAME fPage6
OR "RETURN":U     OF cFileCSV IN FRAME fPage6
OR "CTRL-ENTER":U OF cFileCSV IN FRAME fPage6
OR "CTRL-J":U     OF cFileCSV IN FRAME fPage6
OR "CTRL-Z":U     OF cFileCSV IN FRAME fPage6
DO:
    RETURN NO-APPLY.
END.

ON "ENTER":U      OF cFileDetalhesAE IN FRAME fPage6
OR "RETURN":U     OF cFileDetalhesAE IN FRAME fPage6
OR "CTRL-ENTER":U OF cFileDetalhesAE IN FRAME fPage6
OR "CTRL-J":U     OF cFileDetalhesAE IN FRAME fPage6
OR "CTRL-Z":U     OF cFileDetalhesAE IN FRAME fPage6
DO:
    RETURN NO-APPLY.
END.

ON "~\":U OF cFileCSV IN FRAME fPage6
DO:
    APPLY "/":U TO cFileCSV IN FRAME fPage6.
    RETURN NO-APPLY.
END.

ON "~\":U OF cFileDetalhesAE IN FRAME fPage6
DO:
    APPLY "/":U TO cFileDetalhesAE IN FRAME fPage6.
    RETURN NO-APPLY.
END.

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
    DISABLE fiNomeEstab-1
            fiNomeDepos-1
            fiNomeEstab-2
            fiNomeDepos-2
        WITH FRAME fPage2.

    FIND FIRST estabelec
        WHERE estabelec.cod-estabel = "104":U NO-LOCK NO-ERROR.

    ASSIGN fiCodEstab-1 = IF AVAILABLE estabelec THEN estabelec.cod-estabel ELSE "":U.

    FIND FIRST estabelec
        WHERE estabelec.cod-estabel = "101":U NO-LOCK NO-ERROR.

    ASSIGN fiCodEstab-2 = IF AVAILABLE estabelec THEN estabelec.cod-estabel ELSE "":U.

    FIND FIRST deposito
        WHERE deposito.cod-depos = "EXP":U NO-LOCK NO-ERROR.

    ASSIGN fiCodDepos-1 = IF AVAILABLE deposito  THEN deposito.cod-depos ELSE "":U
           fiCodDepos-2 = IF AVAILABLE deposito  THEN deposito.cod-depos ELSE "":U.

    DISPLAY fiCodEstab-1
            fiCodDepos-1
            fiCodEstab-2
            fiCodDepos-2
        WITH FRAME fPage2.

    APPLY "LEAVE":U TO fiCodEstab-1 IN FRAME fPage2.
    APPLY "LEAVE":U TO fiCodDepos-1 IN FRAME fPage2.
    APPLY "LEAVE":U TO fiCodEstab-2 IN FRAME fPage2.
    APPLY "LEAVE":U TO fiCodDepos-2 IN FRAME fPage2.

    RUN utp/ut-limit.p (INPUT "MIN":U,
                        INPUT BUFFER item:HANDLE:BUFFER-FIELD("it-codigo":U):FORMAT).

    ASSIGN fiItCodigoIni = RETURN-VALUE.

    RUN utp/ut-limit.p (INPUT "MAX":U,
                        INPUT BUFFER item:HANDLE:BUFFER-FIELD("it-codigo":U):FORMAT).

    ASSIGN fiItCodigoFin = RETURN-VALUE.

    RUN utp/ut-limit.p (INPUT "MIN":U,
                        INPUT BUFFER mgcad.localizacao:HANDLE:BUFFER-FIELD("cod-localiz":U):FORMAT).

    ASSIGN fiCodLocalizIni = RETURN-VALUE.

    RUN utp/ut-limit.p (INPUT "MAX":U,
                        INPUT BUFFER mgcad.localizacao:HANDLE:BUFFER-FIELD("cod-localiz":U):FORMAT).

    ASSIGN fiCodLocalizFin = RETURN-VALUE.

    DISPLAY fiItCodigoIni
            fiItCodigoFin
            fiCodLocalizIni
            fiCodLocalizFin
        WITH FRAME fPage2.

    ASSIGN tgConsidSaldoNFS    = YES
           tgConsidSaldoTransf = YES
           tgConsidSaldoAE     = YES
           tgConsidSaldoCST    = YES
           tgGerarDetalhesAE   = NO.

    DISPLAY tgConsidSaldoNFS
            tgConsidSaldoTransf
            tgConsidSaldoAE
            tgConsidSaldoCST
            tgGerarDetalhesAE
        WITH FRAME fPage4.

    ASSIGN c-dt-hr-arq = "-":U + TRIM(REPLACE(STRING(TODAY, "99/99/9999":U), "/":U, "":U)) + TRIM(REPLACE(STRING(TIME, "hh:mm:ss":U), ":":U, "":U)).

    APPLY "VALUE-CHANGED":U TO tgConsidSaldoNFS IN FRAME fPage4.
    APPLY "VALUE-CHANGED":U TO rsExecution IN FRAME fPage6.

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

    DO ON ERROR UNDO, RETURN ERROR
       ON STOP  UNDO, RETURN ERROR:
        {report/rpexa.i}

        IF INPUT FRAME fPage6 rsDestiny   = 2 AND
           INPUT FRAME fPage6 rsExecution = 1 THEN DO:
            RUN utp/ut-vlarq.p (INPUT INPUT FRAME fPage6 cFile).

            IF RETURN-VALUE = "NOK":U THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 73,
                                   INPUT "":U).

                RUN setFolder IN hFolder (INPUT 4).

                APPLY "ENTRY":U TO cFile IN FRAME fPage6.

                RETURN ERROR.
            END.
        END.

        /*:T Coloque aqui as valida‡äes da p gina de Digita‡Æo, lembrando que elas devem
           apresentar uma mensagem de erro cadastrada, posicionar nesta p gina e colocar
           o focus no campo com problemas */
        /*browse brDigita:SET-REPOSITIONED-ROW (browse brDigita:DOWN, "ALWAYS":U).*/

        for each tt-digita no-lock:
            assign r-tt-digita = rowid(tt-digita).

            /*:T Valida‡Æo de duplicidade de registro na temp-table tt-digita */
            find first b-tt-digita 
                where b-tt-digita.it-codigo = tt-digita.it-codigo 
                  and rowid(b-tt-digita) <> rowid(tt-digita) 
                no-lock no-error.
            if  avail b-tt-digita then do:
                reposition brDigita to rowid rowid(b-tt-digita).

                run utp/ut-msgs.p (input "SHOW":U, input 108, input "":U).
                RUN setFolder IN hFolder (INPUT 3).
                apply "ENTRY":U to tt-digita.it-codigo in browse brDigita.

                return error.
            end.

            /*:T As demais valida‡äes devem ser feitas aqui */
            find first item
                where item.it-codigo = tt-digita.it-codigo no-lock no-error.

            if  not available item then do:
                assign browse brDigita:CURRENT-COLUMN = tt-digita.it-codigo:HANDLE in browse brDigita.

                reposition brDigita to rowid r-tt-digita.

                run utp/ut-msgs.p (input "SHOW":U, input 2, input "Item":U).
                RUN setFolder IN hFolder (INPUT 3).
                apply "ENTRY":U to tt-digita.it-codigo in browse brDigita.

                return error.
            end.

        end.

        /*:T Coloque aqui as valida‡äes das outras p ginas, lembrando que elas devem 
           apresentar uma mensagem de erro cadastrada, posicionar na p gina com 
           problemas e colocar o focus no campo com problemas */

        FIND FIRST estabelec
            WHERE estabelec.cod-estabel = INPUT FRAME fPage2 fiCodEstab-1 NO-LOCK NO-ERROR.

        IF NOT AVAILABLE estabelec THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 2,
                               INPUT "Estabelecimento":U).

            RUN setFolder IN hFolder (INPUT 1).

            APPLY "ENTRY":U TO fiCodEstab-1 IN FRAME fPage2.

            RETURN ERROR.
        END.

        FIND FIRST deposito
            WHERE deposito.cod-depos = INPUT FRAME fPage2 fiCodDepos-1 NO-LOCK NO-ERROR.

        IF NOT AVAILABLE deposito THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 2,
                               INPUT "Dep¢sito":U).

            RUN setFolder IN hFolder (INPUT 1).

            APPLY "ENTRY":U TO fiCodDepos-1 IN FRAME fPage2.

            RETURN ERROR.
        END.

        FIND FIRST estabelec
            WHERE estabelec.cod-estabel = INPUT FRAME fPage2 fiCodEstab-2 NO-LOCK NO-ERROR.

        IF NOT AVAILABLE estabelec THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 2,
                               INPUT "Estabelecimento":U).

            RUN setFolder IN hFolder (INPUT 1).

            APPLY "ENTRY":U TO fiCodEstab-2 IN FRAME fPage2.

            RETURN ERROR.
        END.

        FIND FIRST deposito
            WHERE deposito.cod-depos = INPUT FRAME fPage2 fiCodDepos-2 NO-LOCK NO-ERROR.

        IF NOT AVAILABLE deposito THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 2,
                               INPUT "Dep¢sito":U).

            RUN setFolder IN hFolder (INPUT 1).

            APPLY "ENTRY":U TO fiCodDepos-2 IN FRAME fPage2.

            RETURN ERROR.
        END.

        IF INPUT FRAME fPage6 rsExecution = 1 THEN DO:
            ASSIGN c-arq-aux = input frame fPage6 cFileCSV
                   c-arq-aux = REPLACE(c-arq-aux, "/":U, "~\":U).

            IF R-INDEX(c-arq-aux, "~\":U) > 0 THEN DO:
                ASSIGN FILE-INFO:FILE-NAME = SUBSTRING(c-arq-aux, 1, R-INDEX(c-arq-aux, "~\":U)).

                IF FILE-INFO:FULL-PATHNAME = ?             OR
                   NOT FILE-INFO:FILE-TYPE MATCHES "*D*":U THEN DO:
                    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                       INPUT 5749,
                                       INPUT "":U).

                    RUN setFolder IN hFolder (INPUT 4).

                    APPLY "ENTRY":U TO cFileCSV IN FRAME fPage6.

                    RETURN ERROR.
                END.
            END.

            ASSIGN FILE-INFO:FILE-NAME = c-arq-aux.

            IF FILE-INFO:FILE-TYPE MATCHES "*D*":U THEN DO:
                run utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 73,
                                   INPUT "":U).

                RUN setFolder IN hFolder (INPUT 4).

                APPLY "ENTRY":U TO cFileCSV IN FRAME fPage6.

                RETURN ERROR.
            END.

            RUN utp/ut-vlarq.p (INPUT INPUT FRAME fPage6 cFileCSV).

            IF RETURN-VALUE = "NOK":U THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 73,
                                   INPUT "":U).

                RUN setFolder IN hFolder (INPUT 4).

                APPLY "ENTRY":U TO cFileCSV IN FRAME fPage6.

                RETURN ERROR.
            END.

            IF INPUT FRAME fPage4 tgGerarDetalhesAE THEN DO:
                ASSIGN c-arq-aux = input frame fPage6 cFileDetalhesAE
                       c-arq-aux = REPLACE(c-arq-aux, "/":U, "~\":U).

                IF R-INDEX(c-arq-aux, "~\":U) > 0 THEN DO:
                    ASSIGN FILE-INFO:FILE-NAME = SUBSTRING(c-arq-aux, 1, R-INDEX(c-arq-aux, "~\":U)).

                    IF FILE-INFO:FULL-PATHNAME = ?             OR
                       NOT FILE-INFO:FILE-TYPE MATCHES "*D*":U THEN DO:
                        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                           INPUT 5749,
                                           INPUT "":U).

                        RUN setFolder IN hFolder (INPUT 4).

                        APPLY "ENTRY":U TO cFileDetalhesAE IN FRAME fPage6.

                        RETURN ERROR.
                    END.
                END.

                ASSIGN FILE-INFO:FILE-NAME = c-arq-aux.

                IF FILE-INFO:FILE-TYPE MATCHES "*D*":U THEN DO:
                    run utp/ut-msgs.p (INPUT "SHOW":U,
                                       INPUT 73,
                                       INPUT "":U).

                    RUN setFolder IN hFolder (INPUT 4).

                    APPLY "ENTRY":U TO cFileDetalhesAE IN FRAME fPage6.

                    RETURN ERROR.
                END.

                RUN utp/ut-vlarq.p (INPUT INPUT FRAME fPage6 cFileDetalhesAE).

                IF RETURN-VALUE = "NOK":U THEN DO:
                    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                       INPUT 73,
                                       INPUT "":U).

                    RUN setFolder IN hFolder (INPUT 4).

                    APPLY "ENTRY":U TO cFileDetalhesAE IN FRAME fPage6.

                    RETURN ERROR.
                END.
            END.
        END.


        /*:T Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
           para o programa RP.P */

        CREATE tt-param.
        ASSIGN tt-param.usuario   = c-seg-usuario
               tt-param.destino   = INPUT FRAME fPage6 rsDestiny
               tt-param.data-exec = TODAY
               tt-param.hora-exec = TIME.

        IF tt-param.destino = 1 THEN
            ASSIGN tt-param.arquivo = "":U.
        ELSE IF tt-param.destino = 2 THEN
            ASSIGN tt-param.arquivo = INPUT FRAME fPage6 cFile.
        ELSE
            ASSIGN tt-param.arquivo = SESSION:TEMP-DIRECTORY + c-programa-mg97 + ".tmp":U.


        /*:T Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
           como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */

        ASSIGN tt-param.cod-estabel-1   = INPUT FRAME fPage2 fiCodEstab-1
               tt-param.cod-depos-1     = INPUT FRAME fPage2 fiCodDepos-1
               tt-param.cod-estabel-2   = INPUT FRAME fPage2 fiCodEstab-2
               tt-param.cod-depos-2     = INPUT FRAME fPage2 fiCodDepos-2
               tt-param.it-codigo-ini   = INPUT FRAME fPage2 fiItCodigoIni
               tt-param.it-codigo-fin   = INPUT FRAME fPage2 fiItCodigoFin
               tt-param.cod-localiz-ini = INPUT FRAME fPage2 fiCodLocalizIni
               tt-param.cod-localiz-fin = INPUT FRAME fPage2 fiCodLocalizFin.

        ASSIGN tt-param.cons-saldo-nfs    = INPUT FRAME fPage4 tgConsidSaldoNFS
               tt-param.dt-corte-nfs      = INPUT FRAME fPage4 fiDataCorteNFS
               tt-param.cons-saldo-transf = INPUT FRAME fPage4 tgConsidSaldoTransf
               tt-param.cons-saldo-ae     = INPUT FRAME fPage4 tgConsidSaldoAE
               tt-param.gerar-detalhes-ae = INPUT FRAME fPage4 tgGerarDetalhesAE
               tt-param.cons-saldo-cst    = INPUT FRAME fPage4 tgConsidSaldoCST
               tt-param.listar-nfs        = INPUT FRAME fPage4 tgListarNFs.
    
        ASSIGN tt-param.arquivo-csv = REPLACE(INPUT FRAME fPage6 cFileCSV, "~\":U, "/":U)
               tt-param.arquivo-ae  = REPLACE(INPUT FRAME fPage6 cFileDetalhesAE, "~\":U, "/":U).


        /*:T Executar do programa RP.P que ir  criar o relat¢rio */

        {report/rpexb.i}

        SESSION:SET-WAIT-STATE("GENERAL":U).

        {report/rprun.i esp/cep/escep061rp.p}

        {report/rpexc.i}

        SESSION:SET-WAIT-STATE("":U).

        {report/rptrm.i}
    END.

    ASSIGN c-dt-hr-arq = "-":U + TRIM(REPLACE(STRING(TODAY, "99/99/9999":U), "/":U, "":U)) + TRIM(REPLACE(STRING(TIME, "hh:mm:ss":U), ":":U, "":U)).

    APPLY "VALUE-CHANGED":U TO rsExecution IN FRAME fPage6.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescItem wReport 
FUNCTION fnDescItem RETURNS CHARACTER
  ( p-it-codigo AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    FIND FIRST item
        WHERE item.it-codigo = p-it-codigo NO-LOCK NO-ERROR.

    IF AVAILABLE item THEN
        RETURN item.desc-item.
    ELSE
        RETURN "":U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

