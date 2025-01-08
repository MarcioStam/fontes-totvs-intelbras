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
{include/i-prgvrs.i esftp011 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esftp011
&GLOBAL-DEFINE Version        2.00.00.000
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Sele‡Æo,Parƒmetro,Digita‡Æo,ImpressÆo

&GLOBAL-DEFINE PGLAY          
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          YES
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          

&GLOBAL-DEFINE page0Widgets   btOk btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   bt-buscar
&GLOBAL-DEFINE page3Widgets   
&GLOBAL-DEFINE page4Widgets   
&GLOBAL-DEFINE page5Widgets   brDigita bt-marca bt-marca-todos bt-desmarca-todos
&GLOBAL-DEFINE page6Widgets   rsDestiny btConfigImpr btFile rsExecution
&GLOBAL-DEFINE page7Widgets   
&GLOBAL-DEFINE page8Widgets   

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo
&GLOBAL-DEFINE page7Text      
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    iNr-embarque-ini iNr-embarque-end dtEmbarque-ini dtEmbarque-end cEstado-ini cEstado-end cNome-transp-ini rs-romaneio
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields    iNr-copias tgParametros tgAtuNF fi-DataAtuNF
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile
&GLOBAL-DEFINE page7Fields    
&GLOBAL-DEFINE page8Fields    

/* Parameters Definitions ---                                           */
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino           AS INTEGER
    FIELD arquivo           AS CHARACTER FORMAT "x(35)":U
    FIELD usuario           AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec         AS DATE
    FIELD hora-exec         AS INTEGER
    FIELD nr-embarque-ini   LIKE pre-fatur.cdd-embarq
    FIELD nr-embarque-end   LIKE pre-fatur.cdd-embarq
    FIELD nome-transp-ini   LIKE pre-fatur.nome-transp
    FIELD dt-embarque-ini   LIKE embarque.dt-embarque
    FIELD dt-embarque-end   LIKE embarque.dt-embarque
    FIELD estado-ini        LIKE pre-fatur.estado
    FIELD estado-end        LIKE pre-fatur.estado
    FIELD dt-emis-nf-ini    LIKE nota-fiscal.dt-emis-nota
    FIELD dt-emis-nf-end    LIKE nota-fiscal.dt-emis-nota
    FIELD nr-copias         AS INTEGER
    FIELD parametros        AS LOGICAL
    FIELD notas-mg          AS INTEGER
    FIELD atu-nf            AS LOGICAL
    FIELD dt-atu-nf         AS DATE
    FIELD rs-romaneio       AS INT.

define temp-table tt-digita no-undo
    FIELD selecionado      AS LOGICAL LABEL 'Selecionado'
    FIELD cod-estab        LIKE nota-fiscal.cod-estabel
    FIELD serie            LIKE nota-fiscal.serie
    FIELD nr-nota-fis      LIKE nota-fiscal.nr-nota-fis
    FIELD nome-ab-cli      LIKE nota-fiscal.nome-ab-cli
    FIELD nome-transp      LIKE nota-fiscal.nome-transp
    FIELD vl-total-nota    LIKE nota-fiscal.vl-tot-nota
    FIELD nr-volume        LIKE nota-fiscal.nr-volume  
    FIELD nr-pedcli        LIKE nota-fiscal.nr-pedcli
    FIELD dt-emissao         AS DATE
    FIELD cd-atendente       AS CHAR
    FIELD cod-depos          AS CHAR
    FIELD estado             AS CHAR
    index id cod-estab serie nr-nota-fis.

DEF TEMP-TABLE tt-transporte
    FIELD nome-transp LIKE pre-fatur.nome-transp.


{esp/es0018.i}
       
DEF TEMP-TABLE tt-prog-ponto-tmp
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.   
DEF BUFFER b-ponto-programa FOR ponto-programa.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.
DEF VAR c-lista            AS CHAR    NO-UNDO.
DEFINE VARIABLE l-volta             AS LOGICAL      NO-UNDO.


def stream s-imp.

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
&Scoped-define FIELDS-IN-QUERY-brDigita tt-digita.selecionado tt-digita.cod-estab tt-digita.serie tt-digita.nr-nota-fis tt-digita.dt-emis tt-digita.nr-pedcli tt-digita.nome-ab-cli tt-digita.nome-transp   
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
     SIZE 13 BY 1.

DEFINE VARIABLE cNome-transp-ini AS CHARACTER FORMAT "X(256)":U 
     LABEL "Transportador" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE cEstado-end AS CHARACTER FORMAT "x(04)" INITIAL "ZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE cEstado-ini AS CHARACTER FORMAT "x(04)" 
     LABEL "UF":R2 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE dtEmbarque-end AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE dtEmbarque-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Data embarque" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE iNr-embarque-end AS INTEGER FORMAT ">>>>,>>9" INITIAL 9999999 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE iNr-embarque-ini AS INTEGER FORMAT ">>>>,>>9" INITIAL 0 
     LABEL "Embarque":R10 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE VARIABLE rs-romaneio AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Somente notas sem romaneio", 1,
"Somente notas com romaneio", 2,
"Ambos", 3
     SIZE 26 BY 3 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 76.86 BY 1.5.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77 BY 3.5.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77 BY 3.5.

DEFINE VARIABLE fi-DataAtuNF AS DATE FORMAT "99/99/9999":U 
     LABEL "Data de saida das notas fiscais" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 TOOLTIP "Digite ? para limpar o campo" NO-UNDO.

DEFINE VARIABLE iNr-copias AS INTEGER FORMAT ">9":U INITIAL 1 
     LABEL "N£mero de c¢pias" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77.72 BY 5.17.

DEFINE VARIABLE tgAtuNF AS LOGICAL INITIAL yes 
     LABEL "Atualiza data de saida nas notas fiscais" 
     VIEW-AS TOGGLE-BOX
     SIZE 30.72 BY .83 NO-UNDO.

DEFINE VARIABLE tgParametros AS LOGICAL INITIAL no 
     LABEL "Imprime sele‡Æo/parƒmetros" 
     VIEW-AS TOGGLE-BOX
     SIZE 25.72 BY .83 NO-UNDO.

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

DEFINE VARIABLE cFile AS CHARACTER INITIAL "c:~\temp~\esftp011.lst" 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.14 BY .63
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
      tt-digita.selecionado FORMAT 'Sim/NÆo'
    tt-digita.cod-estab
    tt-digita.serie
    tt-digita.nr-nota-fis
    tt-digita.dt-emis      COLUMN-LABEL "Dt Emis" FORMAT "99/99/9999" WIDTH 11
    tt-digita.nr-pedcli
    tt-digita.nome-ab-cli WIDTH 26
    tt-digita.nome-transp WIDTH 26
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 82 BY 8.75
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.13
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.29 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     btFile AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.58 COL 43.29 HELP
          "Configura‡Æo da impressora"
     cFile AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 5.75 COL 3 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.86 ROW 2.83
         SIZE 84 BY 12.67
         FONT 1.

DEFINE FRAME fPage5
     brDigita AT ROW 1.25 COL 1 WIDGET-ID 100
     bt-marca AT ROW 10 COL 1 WIDGET-ID 4
     bt-marca-todos AT ROW 10 COL 17 WIDGET-ID 6
     bt-desmarca-todos AT ROW 10 COL 32 WIDGET-ID 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.86 ROW 2.83
         SIZE 84 BY 12.67
         FONT 1.

DEFINE FRAME fPage4
     iNr-copias AT ROW 1.67 COL 20.72 COLON-ALIGNED
     fi-DataAtuNF AT ROW 3 COL 29.57 COLON-ALIGNED
     tgAtuNF AT ROW 4.33 COL 7.29
     tgParametros AT ROW 5.21 COL 7.29
     "V lido somente no envio para a impressora" VIEW-AS TEXT
          SIZE 36 BY .54 AT ROW 1.83 COL 29.57
          FGCOLOR 12 
     "V lido somente no envio para a impressora e arquivo" VIEW-AS TEXT
          SIZE 38 BY .54 AT ROW 4.5 COL 40
          FGCOLOR 12 
     RECT-11 AT ROW 1.33 COL 2.72
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.86 ROW 2.83
         SIZE 84 BY 12.67
         FONT 1.

DEFINE FRAME fPage2
     iNr-embarque-ini AT ROW 1.5 COL 25.86 COLON-ALIGNED HELP
          "Embarque"
     iNr-embarque-end AT ROW 1.5 COL 51 COLON-ALIGNED HELP
          "Embarque" NO-LABEL
     dtEmbarque-ini AT ROW 2.5 COL 25.86 COLON-ALIGNED
     dtEmbarque-end AT ROW 2.5 COL 51 COLON-ALIGNED NO-LABEL
     cEstado-ini AT ROW 3.54 COL 25.86 COLON-ALIGNED HELP
          "Unidade da federa‡Æo para entrega"
     cEstado-end AT ROW 3.54 COL 51 COLON-ALIGNED HELP
          "Unidade da federa‡Æo para entrega" NO-LABEL
     cNome-transp-ini AT ROW 5.25 COL 25.86 COLON-ALIGNED WIDGET-ID 8
     rs-romaneio AT ROW 7 COL 27.86 NO-LABEL WIDGET-ID 14
     bt-buscar AT ROW 10.5 COL 28 WIDGET-ID 2
     IMAGE-1 AT ROW 1.5 COL 40.43
     IMAGE-10 AT ROW 3.5 COL 49
     IMAGE-2 AT ROW 1.5 COL 49
     IMAGE-5 AT ROW 2.5 COL 40.43
     IMAGE-6 AT ROW 2.5 COL 49
     IMAGE-9 AT ROW 3.5 COL 40.43
     RECT-19 AT ROW 1.25 COL 6 WIDGET-ID 4
     RECT-13 AT ROW 5 COL 6 WIDGET-ID 10
     RECT-21 AT ROW 6.75 COL 6 WIDGET-ID 12
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.86 ROW 2.83
         SIZE 84 BY 12.67
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
         HEIGHT             = 17.13
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
ASSIGN FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage5:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FRAME fPage4
                                                                        */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage5
/* Query rebuild information for FRAME fPage5
     _Query            is NOT OPENED
*/  /* FRAME fPage5 */
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
    /*if  brDigita:new-row in frame fPage5 then do:
        if  avail tt-digita then
            delete tt-digita.
        if  brDigita:delete-current-row() in frame fPage5 then. 
    end.                                                               
    else do:
        get current brDigita.
        display tt-digita.cd-gr-com
                tt-digita.descricao with browse brDigita. 
    end.
    return no-apply.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ENTER OF brDigita IN FRAME fPage5
ANYWHERE
DO:
    APPLY 'Choose' TO bt-marca IN FRAME fPage5.
/*  apply 'tab' to self.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON INS OF brDigita IN FRAME fPage5
DO:
   /*apply 'choose' to btAdd in frame fPage5.*/
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
ON OFF-END OF brDigita IN FRAME fPage5
DO:
   /*apply 'entry' to btAdd in frame fPage5.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON OFF-HOME OF brDigita IN FRAME fPage5
DO:
  /*apply 'entry' to btOpen in frame fPage5.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ROW-ENTRY OF brDigita IN FRAME fPage5
DO:
   /*:T trigger para inicializar campos da temp table de digita‡Æo */
   if  brDigita:new-row in frame fPage5 then do:
       /*assign tt-digita.exemplo:screen-value in browse brDigita = string(today, "99/99/9999":U).*/
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brDigita wReport
ON ROW-LEAVE OF brDigita IN FRAME fPage5
DO:
    /*:T  aqui que a grava‡Æo da linha da temp-table ‚ efetivada.
       Por‚m as valida‡äes dos registros devem ser feitas na procedure pi-executar,
       no local indicado pelo coment rio 
    
    if brDigita:NEW-ROW in frame fPage5 then 
    do transaction on error undo, return no-apply:
        create tt-digita.
        assign input browse brDigita tt-digita.cd-gr-com.
        FOR FIRST fam-comerc NO-LOCK
            WHERE substring(fam-comerc.fm-cod-com,1,2) = string(tt-digita.cd-gr-com,'99').
            ASSIGN tt-digita.descricao:SCREEN-VALUE IN BROWSE brdigita = fam-comerc.descricao.
        END.
        ASSIGN input browse brDigita tt-digita.descricao.

        brDigita:CREATE-RESULT-LIST-ENTRY() in frame fPage5.
    end.
    else do transaction on error undo, return no-apply:
        if avail tt-digita then
        DO:
            assign input browse brDigita tt-digita.cd-gr-com.
            FOR FIRST fam-comerc NO-LOCK
                WHERE substring(fam-comerc.fm-cod-com,1,2) = string(tt-digita.cd-gr-com,'99').
                ASSIGN tt-digita.descricao:SCREEN-VALUE IN BROWSE brdigita = fam-comerc.descricao.
            END.
            ASSIGN input browse brDigita tt-digita.descricao.
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
    IF AVAILABLE tt-digita THEN DO WITH FRAME fPage5:
        ASSIGN tt-digita.selecionado = NOT tt-digita.selecionado.
        DISP tt-digita.selecionado WITH BROWSE brdigita.
        /*assign input browse brDigita tt-digita.selecionado.*/
    END.
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


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME fi-DataAtuNF
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-DataAtuNF wReport
ON LEAVE OF fi-DataAtuNF IN FRAME fPage4 /* Data de saida das notas fiscais */
DO:
  IF DATE(fi-DataAtuNF:SCREEN-VALUE) > TODAY THEN DO:
      MESSAGE "Data de atualiza‡Æo da nota fiscal nÆo pode ser maior que a corrente"
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      RETURN NO-APPLY.
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


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME tgAtuNF
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tgAtuNF wReport
ON VALUE-CHANGED OF tgAtuNF IN FRAME fPage4 /* Atualiza data de saida nas notas fiscais */
DO:
  IF tgAtuNF:CHECKED THEN
      ASSIGN fi-DataAtuNF:SENSITIVE = YES.
  ELSE
      ASSIGN fi-DataAtuNF:SENSITIVE = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
ASSIGN fi-dataAtuNF = TODAY.
{report/MainBlock.i}

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

DEF VAR i-sequencia AS INT NO-UNDO.
DEF VAR i-conteudo AS INT NO-UNDO.

FOR EACH pre-fatur NO-LOCK 
   WHERE pre-fatur.dt-embarque > TODAY - 90:
    IF NOT CAN-FIND(FIRST tt-transporte
                    WHERE tt-transporte.nome-transp = pre-fatur.nome-transp) THEN DO:
        CREATE tt-transporte.
        ASSIGN tt-transporte.nome-transp = pre-fatur.nome-transp.
    END.
END.

FOR EACH tt-transporte NO-LOCK:
    ASSIGN c-lista = c-lista + tt-transporte.nome-transp + "," + tt-transporte.nome-transp + ",".
END.

ASSIGN c-lista = SUBSTRING(c-lista,1,LENGTH(c-lista) - 1)
       cNome-transp-ini:LIST-ITEM-PAIRS IN FRAME fPage2 = c-lista. 

FOR EACH b-ponto-programa WHERE 
         b-ponto-programa.nome-programa = "esftp011":
    RUN esp/es0018p.p (INPUT b-ponto-programa.nome-programa,
                       INPUT b-ponto-programa.ponto,
                       INPUT i-sequencia,
                       INPUT i-conteudo,
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    FOR EACH TT-PROG-PONTO:
        CREATE tt-prog-ponto-tmp.
        BUFFER-COPY TT-PROG-PONTO TO tt-prog-ponto-tmp.
    END.
END.

ASSIGN fi-dataAtuNF = TODAY.

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

    FOR EACH tt-digita.
        DELETE tt-digita.
    END.

    FOR EACH pre-fatur NO-LOCK                                     
       WHERE pre-fatur.cdd-embarq     >= INPUT FRAME fPage2 iNr-embarque-ini
         AND pre-fatur.cdd-embarq     <= INPUT FRAME fPage2 iNr-embarque-end
         AND pre-fatur.estado         >= INPUT FRAME fPage2 cEstado-ini       
         AND pre-fatur.estado         <= INPUT FRAME fPage2 cEstado-end       
       /*AND pre-fatur.nr-pedcli      <> ''*/,
       FIRST embarque NO-LOCK OF pre-fatur                         
       WHERE embarque.dt-embarque     >= INPUT FRAME fPage2 dtEmbarque-ini  
         AND embarque.dt-embarque     <= INPUT FRAME fPage2 dtEmbarque-end,
       FIRST estabelec NO-LOCK 
       WHERE estabelec.cod-estabel     = embarque.cod-estabel,
        EACH nota-fiscal NO-LOCK 
       WHERE nota-fiscal.nome-transp   = INPUT FRAME fPage2 cNome-transp-ini   
         AND nota-fiscal.nome-ab-cli   = pre-fatur.nome-abrev      
         AND nota-fiscal.nr-pedcli     = pre-fatur.nr-pedcli       
         AND nota-fiscal.cdd-embarq    = pre-fatur.cdd-embarq     
         AND nota-fiscal.dt-cancela    = ?,
       FIRST natur-oper NO-LOCK 
       WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao   
       /*AND natur-oper.baixa-estoq*/:
        {esinc/es0004.i} /*ValidaNaturezasImpressÆoNFs*/

        /*Sem Romaneio*/
        IF INPUT FRAME fPage2 rs-romaneio = 1 
        AND CAN-FIND (FIRST int-romaneio-emb
                      WHERE int-romaneio-emb.cod-estabel = nota-fiscal.cod-estabel
                        AND int-romaneio-emb.serie       = nota-fiscal.serie      
                        AND int-romaneio-emb.nr-nota-fis = nota-fiscal.nr-nota-fis) THEN
            NEXT.

        /*Com Romaneio*/
        IF INPUT FRAME fPage2 rs-romaneio = 2 
        AND NOT CAN-FIND (FIRST int-romaneio-emb
                          WHERE int-romaneio-emb.cod-estabel = nota-fiscal.cod-estabel
                            AND int-romaneio-emb.serie       = nota-fiscal.serie      
                            AND int-romaneio-emb.nr-nota-fis = nota-fiscal.nr-nota-fis) THEN
            NEXT.

        IF nota-fiscal.idi-sit-nf-eletro = 3 THEN DO:
            FIND FIRST tt-digita
                 WHERE tt-digita.selecionado = YES                    
                   AND tt-digita.cod-estab   = nota-fiscal.cod-estabel
                   AND tt-digita.serie       = nota-fiscal.serie      
                   AND tt-digita.nr-nota-fis = nota-fiscal.nr-nota-fis
                   AND tt-digita.nome-ab-cli = nota-fiscal.nome-ab-cli
                   AND tt-digita.nome-transp = nota-fiscal.nome-transp NO-LOCK NO-ERROR.
            IF NOT AVAIL tt-digita THEN DO:
                CREATE tt-digita.
                ASSIGN tt-digita.selecionado   = YES
                       tt-digita.cod-estab     = nota-fiscal.cod-estabel
                       tt-digita.serie         = nota-fiscal.serie
                       tt-digita.nr-nota-fis   = nota-fiscal.nr-nota-fis
                       tt-digita.nome-ab-cli   = nota-fiscal.nome-ab-cli
                       tt-digita.nome-transp   = nota-fiscal.nome-transp
                       tt-digita.nr-pedcli     = nota-fiscal.nr-pedcli
                       tt-digita.dt-emissao    = nota-fiscal.dt-emis
                       tt-digita.estado        = nota-fiscal.estado.
            END.
        END.
    END.

    {&OPEN-QUERY-BrDigita}

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
    
    /*:T Coloque aqui as valida‡äes das outras p ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p gina com 
       problemas e colocar o focus no campo com problemas */
    IF INPUT FRAME fPage2 cNome-transp-ini = "" THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 17006, 
                           INPUT "Nenhum transportador foi selecionado!~~" + 
                                 "Deve ser selecionado um transportador para continuar com a execu‡Æo deste relat¢rio!").
        APPLY "ENTRY" TO cNome-transp-ini IN FRAME fPage2.
        RETURN ERROR.
    END.
    
    /*:T Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
       para o programa RP.P */
    
    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame fPage6 rsDestiny
           tt-param.data-exec       = today
           tt-param.hora-exec       = time.
    
    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "":U.
    else if  tt-param.destino = 2 
         then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
    /*:T Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */
    
    ASSIGN tt-param.nr-embarque-ini   = INPUT FRAME fPage2 iNr-embarque-ini
           tt-param.nr-embarque-end   = INPUT FRAME fPage2 iNr-embarque-end
           tt-param.dt-embarque-ini   = INPUT FRAME fPage2 dtEmbarque-ini
           tt-param.dt-embarque-end   = INPUT FRAME fPage2 dtEmbarque-end
           tt-param.nome-transp-ini   = INPUT FRAME fPage2 cNome-transp-ini
           tt-param.estado-ini        = INPUT FRAME fPage2 cEstado-ini
           tt-param.estado-end        = INPUT FRAME fPage2 cEstado-end
           tt-param.dt-emis-nf-ini    = TODAY
           tt-param.dt-emis-nf-end    = TODAY
           tt-param.nr-copias         = INPUT FRAME fPage4 iNr-copias
           tt-param.parametros        = INPUT FRAME fPage4 tgParametros
           tt-param.Atu-NF            = INPUT FRAME fPage4 tgAtuNF
           tt-param.dt-Atu-NF         = INPUT FRAME fPage4 fi-DataAtuNF
           tt-param.rs-romaneio       = INPUT FRAME fPage2 rs-romaneio.


    /*:T Executar do programa RP.P que ir  criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i esp/ftp/esftp011rp.p}
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

