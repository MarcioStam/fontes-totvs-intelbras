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
{include/i-prgvrs.i ESFTP017 2.04.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESFTP017
&GLOBAL-DEFINE Version        1
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

&GLOBAL-DEFINE page0Widgets   btOk btCancel btHelp2
&GLOBAL-DEFINE page2Widgets   bt-buscar l-FatComercial
&GLOBAL-DEFINE page5Widgets   brDigita bt-marca bt-marca-todos bt-desmarca-todos
&GLOBAL-DEFINE page6Widgets   rsDestiny btConfigImpr btFile rsExecution

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo
&GLOBAL-DEFINE page2Fields    c-cod-estabel c-serie fiNrEmbarque dt-ini-emiss dt-fim-emiss c-atendente-ini c-atendente-fim ~
                              c-it-codigo-ini c-it-codigo-fim i-cod-transp-ini i-cod-transp-fim 
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile

/* Parameters Definitions ---                                           */
{esp\ftp\esftp017tt.i}
{esp/es0018.i}
{eqp/eqapi300.i}
{cdp/cd0667.i}

define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.

def stream s-imp.


DEFINE VARIABLE cNome-ab-cli LIKE nota-fiscal.nome-ab-cli  NO-UNDO.


DEF VAR i-nome-programa AS CHAR.
DEF VAR i-ponto AS INT.
DEF VAR i-sequencia AS INT.
DEF VAR i-conteudo AS CHAR.
DEF VAR l-volta                 AS LOG.

DEF TEMP-TABLE tt-prog-ponto-tmp
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.   


DEF BUFFER b-ponto-programa FOR ponto-programa.

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
&Scoped-define FIELDS-IN-QUERY-brDigita tt-digita.selecionado tt-digita.cod-estab tt-digita.serie tt-digita.nr-nota-fis tt-digita.estado tt-digita.dt-emis tt-digita.cod-depos tt-digita.cd-atendente tt-digita.nr-pedcli tt-digita.nome-ab-cli tt-digita.nome-transp tt-digita.vl-total-nota tt-digita.nr-volume   
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

DEFINE VARIABLE c-atendente-fim AS CHARACTER FORMAT "X(2)":U INITIAL "ZZ" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE c-atendente-ini AS CHARACTER FORMAT "X(2)" 
     LABEL "Atendente" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estabel AS CHARACTER FORMAT "X(256)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo-fim AS CHARACTER FORMAT "X(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo-ini AS CHARACTER FORMAT "X(16)" 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-serie AS CHARACTER FORMAT "X(256)" INITIAL "1" 
     LABEL "Serie" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE Dt-fim-Emiss AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE dt-ini-emiss AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Emiss∆o NF" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiNrEmbarque AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Embarque" 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-transp-fim AS INTEGER FORMAT "->,>>>,>>9" INITIAL 9999999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-transp-ini AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Transportador" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
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

DEFINE VARIABLE l-FatComercial AS LOGICAL INITIAL yes 
     LABEL "Faturamento Comercial" 
     VIEW-AS TOGGLE-BOX
     SIZE 18.72 BY .83 NO-UNDO.

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
      tt-digita.selecionado FORMAT 'Sim/N∆o'
    tt-digita.cod-estab
    tt-digita.serie
    tt-digita.nr-nota-fis
    tt-digita.estado      
    tt-digita.dt-emis      COLUMN-LABEL "Dt Emis" FORMAT "99/99/9999" WIDTH 11
    tt-digita.cod-depos    COLUMN-LABEL "Dep"
    tt-digita.cd-atendente COLUMN-LABEL "Atend"
    tt-digita.nr-pedcli
    tt-digita.nome-ab-cli WIDTH 26
    tt-digita.nome-transp WIDTH 26
    tt-digita.vl-total-nota
    tt-digita.nr-volume
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
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage2
     l-FatComercial AT ROW 1.75 COL 33.72 WIDGET-ID 6
     c-cod-estabel AT ROW 2.75 COL 28 COLON-ALIGNED HELP
          "Estabelecimento emissor do documento fiscal" WIDGET-ID 8
     c-serie AT ROW 3.75 COL 28 COLON-ALIGNED HELP
          "Serie do documento fiscal" WIDGET-ID 34
     fiNrEmbarque AT ROW 3.75 COL 53.72 COLON-ALIGNED
     c-atendente-ini AT ROW 4.75 COL 33 COLON-ALIGNED HELP
          "C¢digo Atendente" WIDGET-ID 28
     c-atendente-fim AT ROW 4.75 COL 44.86 COLON-ALIGNED HELP
          "C¢digo Atendente" NO-LABEL WIDGET-ID 26
     c-it-codigo-ini AT ROW 5.75 COL 19 COLON-ALIGNED HELP
          "C¢digo do item" WIDGET-ID 20
     c-it-codigo-fim AT ROW 5.75 COL 44.86 COLON-ALIGNED HELP
          "C¢digo do item" NO-LABEL WIDGET-ID 18
     i-cod-transp-ini AT ROW 6.75 COL 26 COLON-ALIGNED HELP
          "Digite o c¢digo do transportador" WIDGET-ID 12
     i-cod-transp-fim AT ROW 6.75 COL 44.86 COLON-ALIGNED HELP
          "Digite o c¢digo do transportador" NO-LABEL WIDGET-ID 10
     dt-ini-emiss AT ROW 7.75 COL 26 COLON-ALIGNED
     Dt-fim-Emiss AT ROW 7.75 COL 44.86 COLON-ALIGNED NO-LABEL
     bt-buscar AT ROW 7.75 COL 59.43
     IMAGE-1 AT ROW 7.75 COL 38.86
     IMAGE-2 AT ROW 7.75 COL 43.43
     IMAGE-23 AT ROW 6.75 COL 38.86 WIDGET-ID 14
     IMAGE-24 AT ROW 6.75 COL 43.43 WIDGET-ID 16
     IMAGE-25 AT ROW 5.75 COL 38.86 WIDGET-ID 22
     IMAGE-26 AT ROW 5.75 COL 43.43 WIDGET-ID 24
     IMAGE-27 AT ROW 4.75 COL 38.86 WIDGET-ID 30
     IMAGE-28 AT ROW 4.75 COL 43.43 WIDGET-ID 32
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
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
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1.

DEFINE FRAME fPage5
     brDigita AT ROW 1.25 COL 1
     bt-marca AT ROW 10 COL 1
     bt-marca-todos AT ROW 10 COL 17
     bt-desmarca-todos AT ROW 10 COL 32
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
   Other Settings: COMPILE
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
         MAX-HEIGHT         = 28.33
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28.33
         VIRTUAL-WIDTH      = 195.14
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
       FRAME fPage5:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN c-atendente-fim IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-atendente-ini IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-it-codigo-fim IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-it-codigo-ini IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-cod-transp-fim IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-cod-transp-ini IN FRAME fPage2
   NO-ENABLE                                                            */
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
       no local indicado pelo coment†rio 
    
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

       find last embarque no-lock no-error.
       IF AVAIL embarque AND embarque.cdd-embarq < 9999999999999999 THEN
           ASSIGN fiNrEmbarque:SCREEN-VALUE IN FRAME fPage2 = string(embarque.cdd-embarq + 1).
       ELSE DO:
            FIND LAST embarque WHERE embarque.cdd-embarq < 5000000000000000 NO-LOCK NO-ERROR.
            ASSIGN fiNrEmbarque:SCREEN-VALUE IN FRAME fPage2 = IF AVAIL embarque 
                                  THEN string(embarque.cdd-embarq + 1)
                                  ELSE '1'.
       END.

   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME c-atendente-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-atendente-fim wReport
ON LEAVE OF c-atendente-fim IN FRAME fPage2
DO:
    IF SELF:MODIFIED THEN DO:
        EMPTY TEMP-TABLE tt-digita.
        {&OPEN-QUERY-Br-digita}
        ASSIGN SELF:MODIFIED = NO.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-atendente-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-atendente-ini wReport
ON LEAVE OF c-atendente-ini IN FRAME fPage2 /* Atendente */
DO:
    IF SELF:MODIFIED THEN DO:
        EMPTY TEMP-TABLE tt-digita.
        {&OPEN-QUERY-Br-digita}
        ASSIGN SELF:MODIFIED = NO.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-it-codigo-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo-fim wReport
ON LEAVE OF c-it-codigo-fim IN FRAME fPage2
DO:
    IF SELF:MODIFIED THEN DO:
        EMPTY TEMP-TABLE tt-digita.
        {&OPEN-QUERY-Br-digita}
        ASSIGN SELF:MODIFIED = NO.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-it-codigo-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-codigo-ini wReport
ON LEAVE OF c-it-codigo-ini IN FRAME fPage2 /* Item */
DO:
    IF SELF:MODIFIED THEN DO:
        EMPTY TEMP-TABLE tt-digita.
        {&OPEN-QUERY-Br-digita}
        ASSIGN SELF:MODIFIED = NO.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Dt-fim-Emiss
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dt-fim-Emiss wReport
ON LEAVE OF Dt-fim-Emiss IN FRAME fPage2
DO:
    IF SELF:MODIFIED THEN DO:
        EMPTY TEMP-TABLE tt-digita.
        {&OPEN-QUERY-Br-digita}
        ASSIGN SELF:MODIFIED = NO.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dt-ini-emiss
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dt-ini-emiss wReport
ON LEAVE OF dt-ini-emiss IN FRAME fPage2 /* Data Emiss∆o NF */
DO:
    IF SELF:MODIFIED THEN DO:
        EMPTY TEMP-TABLE tt-digita.
        {&OPEN-QUERY-Br-digita}
        ASSIGN SELF:MODIFIED = NO.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-transp-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-transp-fim wReport
ON LEAVE OF i-cod-transp-fim IN FRAME fPage2
DO:
    IF SELF:MODIFIED THEN DO:
        EMPTY TEMP-TABLE tt-digita.
        {&OPEN-QUERY-Br-digita}
        ASSIGN SELF:MODIFIED = NO.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-transp-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-transp-ini wReport
ON LEAVE OF i-cod-transp-ini IN FRAME fPage2 /* Transportador */
DO:
    IF SELF:MODIFIED THEN DO:
        EMPTY TEMP-TABLE tt-digita.
        {&OPEN-QUERY-Br-digita}
        ASSIGN SELF:MODIFIED = NO.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-FatComercial
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-FatComercial wReport
ON VALUE-CHANGED OF l-FatComercial IN FRAME fPage2 /* Faturamento Comercial */
DO:

    IF INPUT FRAME fPage2 l-FatComercial THEN DO:

        ENABLE c-atendente-ini  WITH FRAME fPage2.
        ENABLE c-atendente-fim  WITH FRAME fPage2.
        ENABLE c-it-codigo-ini  WITH FRAME fPage2.
        ENABLE c-it-codigo-fim  WITH FRAME fPage2.
        ENABLE i-cod-transp-ini WITH FRAME fPage2.
        ENABLE i-cod-transp-fim WITH FRAME fPage2.

    END.
    ELSE DO:

        DISABLE c-atendente-ini  WITH FRAME fPage2.
        DISABLE c-atendente-fim  WITH FRAME fPage2.
        DISABLE c-it-codigo-ini  WITH FRAME fPage2.
        DISABLE c-it-codigo-fim  WITH FRAME fPage2.
        DISABLE i-cod-transp-ini WITH FRAME fPage2.
        DISABLE i-cod-transp-fim WITH FRAME fPage2.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterInitializeInterface wReport 
PROCEDURE AfterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ENABLE l-FatComercial WITH FRAME fPage2.
    ASSIGN l-FatComercial:SENSITIVE IN FRAME fPage2 = YES.

    /*ASSIGN btUpdate:SENSITIVE IN FRAME fPage5 = NO.*/
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
    ASSIGN dt-ini-emiss  = TODAY /*DATE(MONTH(TODAY),01,YEAR(TODAY))*/
           dt-fim-emiss  = TODAY.
        
    find last embarque no-lock no-error.
    IF AVAIL embarque AND embarque.cdd-embarq < 9999999999999999 THEN
        ASSIGN fiNrEmbarque = embarque.cdd-embarq + 1.
    ELSE DO:
         FIND LAST embarque WHERE embarque.cdd-embarq < 5000000000000000 NO-LOCK NO-ERROR.
         ASSIGN fiNrEmbarque = IF AVAIL embarque 
                               THEN embarque.cdd-embarq + 1
                               ELSE 1.
    END.
    
    find first para-ped no-lock no-error.
    assign c-cod-estabel = if avail para-ped then para-ped.estab-padrao
                                                         else ""
           c-serie = "1".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-embarques wReport 
PROCEDURE pi-cria-embarques :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-api AS HANDLE      NO-UNDO.
        
    run eqp/eqapi300.p persistent set h-api.

    create tt-embarque.
    assign tt-embarque.cdd-embarq  = INPUT FRAME fPage2 fiNrEmbarque
           tt-embarque.cod-estabel = INPUT FRAME fPage2 c-cod-estabel
           tt-embarque.dt-embarque = TODAY
           tt-embarque.identific   = c-seg-usuario
           tt-embarque.cod-rota    = ''
           tt-embarque.nome-transp = ''
           tt-embarque.placa       = ''

           tt-embarque.cod-tipo    = ''
           tt-embarque.usuario     = c-seg-usuario
           tt-embarque.i-sequen    = 1
           tt-embarque.ind-oper    = 1. /* Inclus∆o */

    run pi-recebe-tt-embarque in h-api (input table tt-embarque).
    run pi-trata-tt-embarque  in h-api (input 'MSG', input yes).
    run pi-devolve-tt-erro    in h-api (output table tt-erro).

    IF  NOT CAN-FIND(FIRST tt-erro) THEN
        RUN pi-trava-embarque IN h-api (INPUT INPUT FRAME fPage2 fiNrEmbarque).

    for each tt-erro:
        PUT 'Erro na criaá∆o embarque (cabeáalho): ' tt-erro.cd-erro SKIP
            tt-erro.mensagem SKIP.
    end.

end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaNotas wReport 
PROCEDURE piBuscaNotas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE da-data         AS DATE   NO-UNDO.
    DEFINE VARIABLE h-acomp         AS HANDLE NO-UNDO.
    DEFINE VARIABLE l-geraEmbarque  AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-criaTT        AS LOGICAL     NO-UNDO.

    FOR EACH tt-digita.
        DELETE tt-digita.
    END.

    FIND FIRST estabelec NO-LOCK WHERE
               estabelec.cod-estabel = INPUT FRAME fPage2 c-cod-estabel NO-ERROR.
    IF NOT AVAIL estabelec THEN DO:
        MESSAGE "Estabelecimento do Embarque n∆o cadastrado"
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN NO-APPLY.
    END.

     FOR EACH b-ponto-programa WHERE 
             b-ponto-programa.nome-programa = "esftp017":
        RUN esp\es0018p.p (INPUT b-ponto-programa.nome-programa,
                           INPUT b-ponto-programa.ponto,
                           INPUT i-sequencia,
                           INPUT i-conteudo,
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.
        FOR EACH TT-PROG-PONTO:
            CREATE tt-prog-ponto-tmp.
            BUFFER-COPY TT-PROG-PONTO TO tt-prog-ponto-tmp.
        END.
    END.

    SESSION:SET-WAIT-STATE("general":U).    
    DO da-data = INPUT FRAME fPage2 Dt-ini-emiss TO INPUT FRAME fPage2 Dt-fim-Emiss:

        FOR EACH  nota-fiscal USE-INDEX ch-distancia NO-LOCK         WHERE
                  nota-fiscal.cod-estabel    = estabelec.cod-estabel AND
                  nota-fiscal.serie          = INPUT FRAME fPage2 c-serie AND
                  nota-fiscal.dt-emis-nota   = da-data               AND
                  nota-fiscal.dt-cancela     = ?                     AND
                  nota-fiscal.cdd-embarq     = 0,
                  FIRST natur-oper NO-LOCK WHERE
                        natur-oper.nat-operacao = nota-fiscal.nat-operacao:

           // {esinc/es0004.i}   /*ValidaNaturezasImpress∆oNFs*/ 

            IF INPUT FRAME fPage2 l-FatComercial = YES THEN DO: /* Faturamento Comercial Autom†tico */

                FIND FIRST fat-comercial
                    WHERE fat-comercial.cod-estabel  = nota-fiscal.cod-estabel
                      AND fat-comercial.serie        = nota-fiscal.serie      
                      AND fat-comercial.nr-nota-fis  = nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.
                IF NOT AVAIL fat-comercial AND
                   nota-fiscal.nr-pedcli = "" THEN NEXT.

                FIND FIRST ped-venda
                    WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli 
                      AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli  NO-LOCK NO-ERROR.
                IF NOT AVAIL ped-venda THEN
                    FIND FIRST ped-venda
                        WHERE ped-venda.nome-abrev = fat-comercial.nome-abrev 
                          AND ped-venda.nr-pedcli  = fat-comercial.nr-pedcli  NO-LOCK NO-ERROR.

                IF AVAIL ped-venda THEN DO:

                    IF (ped-venda.tp-pedido < INPUT FRAME fPage2 c-atendente-ini
                    OR  ped-venda.tp-pedido > INPUT FRAME fPage2 c-atendente-fim) THEN NEXT.

                    FIND FIRST transporte WHERE transporte.nome-abrev = nota-fiscal.nome-transp NO-LOCK NO-ERROR.
                    IF AVAIL transporte THEN
                        IF (transporte.cod-transp < INPUT FRAME fPage2 i-cod-transp-ini
                        OR  transporte.cod-transp > INPUT FRAME fPage2 i-cod-transp-fim) THEN NEXT.

                    FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
                        IF (it-nota-fisc.it-codigo < INPUT FRAME fPage2 c-it-codigo-ini
                        OR  it-nota-fisc.it-codigo > INPUT FRAME fPage2 c-it-codigo-fim) THEN NEXT.

                        FIND FIRST pre-fatur /*USE-INDEX ch-embarque */                    WHERE
                                   pre-fatur.cdd-embarq = nota-fiscal.cdd-embarq           AND   
                                   pre-fatur.nr-resumo  = INTEGER(nota-fiscal.nr-nota-fis) AND
                                   pre-fatur.nome-abrev = fat-comercial.nome-abrev         AND
                                   pre-fatur.nr-pedcli  = fat-comercial.nr-pedcli          NO-ERROR.
                        IF NOT AVAIL pre-fatur THEN DO:

                            FIND FIRST fat-ser-lote NO-LOCK
                                 WHERE fat-ser-lote.cod-estabel = it-nota-fisc.cod-estabel
                                   AND fat-ser-lote.serie       = it-nota-fisc.serie
                                   AND fat-ser-lote.nr-nota-fis = it-nota-fisc.nr-nota-fis
                                   AND fat-ser-lote.it-codigo   = it-nota-fisc.it-codigo
                                   AND fat-ser-lote.nr-seq-fat   = it-nota-fisc.nr-seq-fat NO-ERROR.

                            FIND FIRST tt-digita
                                WHERE tt-digita.selecionado = NO                   
                                  AND tt-digita.cod-estab   = nota-fiscal.cod-estabel
                                  AND tt-digita.serie       = nota-fiscal.serie      
                                  AND tt-digita.nr-nota-fis = nota-fiscal.nr-nota-fis
                                  AND tt-digita.nome-ab-cli = nota-fiscal.nome-ab-cli
                                  AND tt-digita.nome-transp = nota-fiscal.nome-transp NO-LOCK NO-ERROR.
                            IF NOT AVAIL tt-digita THEN DO:
                                CREATE tt-digita.
                                ASSIGN tt-digita.selecionado   = NO
                                       tt-digita.cod-estab     = nota-fiscal.cod-estabel
                                       tt-digita.serie         = nota-fiscal.serie
                                       tt-digita.nr-nota-fis   = nota-fiscal.nr-nota-fis
                                       tt-digita.nome-ab-cli   = nota-fiscal.nome-ab-cli
                                       tt-digita.nome-transp   = nota-fiscal.nome-transp
                                       tt-digita.vl-total-nota = nota-fiscal.vl-tot-nota
                                       tt-digita.nr-volume     = nota-fiscal.nr-volume.
                                

                                ASSIGN tt-digita.selecionado = NO
                                       tt-digita.cod-estab   = nota-fiscal.cod-estabel
                                       tt-digita.serie       = nota-fiscal.serie
                                       tt-digita.nr-nota-fis = nota-fiscal.nr-nota-fis
                                       tt-digita.nome-ab-cli = nota-fiscal.nome-ab-cli
                                       tt-digita.nome-transp = nota-fiscal.nome-transp
                                       tt-digita.nr-pedcli   = nota-fiscal.nr-pedcli
                                       tt-digita.dt-emissao   = nota-fiscal.dt-emis
                                       tt-digita.cd-atendente = ped-venda.tp-pedido
                                       tt-digita.cod-depos    = IF AVAIL fat-ser-lote THEN fat-ser-lote.cod-depos ELSE ""
                                       tt-digita.estado       = nota-fiscal.estado.

                            END.

                        END.

                    END.

                END. /* FOR EACH ped-venda */


            END. /* IF INPUT FRAME fPage2 l-FatComercial = YES THEN DO: */
            ELSE DO:
                FIND FIRST fat-comercial
                    WHERE fat-comercial.cod-estabel  = nota-fiscal.cod-estabel
                      AND fat-comercial.serie        = nota-fiscal.serie      
                      AND fat-comercial.nr-nota-fis  = nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.
                IF AVAIL fat-comercial or
                   nota-fiscal.nr-pedcli <> "" THEN NEXT.

                FIND FIRST pre-fatur /*USE-INDEX ch-embarque */                    WHERE
                           pre-fatur.cdd-embarq = nota-fiscal.cdd-embarq           AND   
                           pre-fatur.nr-resumo  = INTEGER(nota-fiscal.nr-nota-fis) AND
                           pre-fatur.nome-abrev = nota-fiscal.nome-abrev           AND
                           pre-fatur.nr-pedcli  = nota-fiscal.nr-pedcli            NO-ERROR.
                IF NOT AVAIL pre-fatur THEN DO:



                   CREATE tt-digita.

                   ASSIGN tt-digita.selecionado   = NO
                          tt-digita.cod-estab     = nota-fiscal.cod-estabel
                          tt-digita.serie         = nota-fiscal.serie
                          tt-digita.nr-nota-fis   = nota-fiscal.nr-nota-fis
                          tt-digita.nome-ab-cli   = nota-fiscal.nome-ab-cli
                          tt-digita.nome-transp   = nota-fiscal.nome-transp
                          tt-digita.vl-total-nota = nota-fiscal.vl-tot-nota
                          tt-digita.nr-volume     = nota-fiscal.nr-volume.

                   ASSIGN tt-digita.selecionado = NO
                          tt-digita.cod-estab   = nota-fiscal.cod-estabel
                          tt-digita.serie       = nota-fiscal.serie
                          tt-digita.nr-nota-fis = nota-fiscal.nr-nota-fis
                          tt-digita.nome-ab-cli = nota-fiscal.nome-ab-cli
                          tt-digita.nome-transp = nota-fiscal.nome-transp
                          tt-digita.nr-pedcli   = nota-fiscal.nr-pedcli
                          tt-digita.estado      = nota-fiscal.estado.
                END.

            END. /* IF INPUT FRAME fPage2 l-FatComercial = NO THEN DO: */

        END.

    END.

    SESSION:SET-WAIT-STATE("":U).    
    IF CAN-FIND(FIRST tt-digita) THEN DO:
        IF INPUT FRAME fPage2 l-FatComercial = YES THEN
            MESSAGE "Geraá∆o de NFs Selecionada com sucesso. " SKIP
                    "   Listada apenas notas geradas pelo:   " SKIP 
                    "    FATURAMENTO COMERCIAL AUTOMµTICO    " VIEW-AS ALERT-BOX INFO BUTTONS OK.
        ELSE
            MESSAGE "Geraá∆o de NFs Selecionada com sucesso" VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    ELSE
        MESSAGE "N∆o foram selecionados NFs com a seleá∆o informada" VIEW-AS ALERT-BOX INFO BUTTONS OK.

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

DEFINE VARIABLE r-tt-digita         AS ROWID    NO-UNDO.
DEFINE VARIABLE fiNrEmbarque-aux    AS INTEGER  NO-UNDO.

&IF DEFINED(PGIMP) <> 0 AND "{&PGIMP}":U = "YES":U &THEN
/*:T** Relatorio ***/
do on error undo, return error on stop  undo, return error:
    {report/rpexa.i}
    
    FIND FIRST embarque NO-LOCK WHERE
               embarque.cdd-embarq = INPUT FRAME fPage2 fiNrEmbarque NO-ERROR.
    IF NOT AVAIL embarque THEN DO:
        RUN pi-cria-embarques.
    END.


    if input frame fPage6 rsDestiny = 2 and
       input frame fPage6 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage6 cFile).
        
        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show":U, input 73, input "":U).
            apply "ENTRY":U to cFile in frame fPage6.
            return error.
        end.
    end.
    
    /*:T Coloque aqui as validaá‰es da p†gina de Digitaá∆o, lembrando que elas devem
       apresentar uma mensagem de erro cadastrada, posicionar nesta p†gina e colocar
       o focus no campo com problemas */
    /*browse brDigita:SET-REPOSITIONED-ROW (browse brDigita:DOWN, "ALWAYS":U).*/
    
    IF NOT CAN-FIND(FIRST tt-digita) THEN
        MESSAGE "N∆o foram selecionados grupos na p†gina digitaá∆o" SKIP(1)
                "O sistema ir† considerar os grupos da p†gina Seleá∆o" 
                VIEW-AS ALERT-BOX WARNING BUTTONS OK.

    for each tt-digita no-lock:
        assign r-tt-digita = rowid(tt-digita).
        
        /*:T Validaá∆o de duplicidade de registro na temp-table tt-digita */
        /*
        find first b-tt-digita 
             where b-tt-digita.cd-gr-com = tt-digita.cd-gr-com
               and rowid(b-tt-digita) <> rowid(tt-digita) 
            no-lock no-error.
        if  avail b-tt-digita then do:
            reposition brDigita to rowid rowid(b-tt-digita).
            run utp/ut-msgs.p (input "SHOW":U, input 108, input "":U).
            apply "ENTRY":U to tt-digita.cd-gr-com in browse brDigita.
            return error.
        end.
        ELSE DO:
            /*
            FIND FIRST fam-comerc NO-LOCK
                 WHERE substring(fam-comerc.fm-cod-com,1,2) = string(tt-digita.cd-gr-com,'99') NO-ERROR.
            IF NOT AVAIL fam-comerc THEN
            DO:
                reposition brDigita to rowid rowid(tt-digita).
                run utp/ut-msgs.p (input "SHOW":U, 
                                   input 17567, 
                                   input "N∆o foi poss°vel encontrar Grupo Comercial":U).
                apply "ENTRY":U to tt-digita.cd-gr-com in browse brDigita.
                return error.
            END.*/
        END.
        */
    end.
    
    /*:T Coloque aqui as validaá‰es das outras p†ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p†gina com 
       problemas e colocar o focus no campo com problemas */
    
    
    
    /*:T Aqui s∆o gravados os campos da temp-table que ser† passada como parÉmetro
       para o programa RP.P */
    
    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame fPage6 rsDestiny
           tt-param.data-exec       = today
           tt-param.hora-exec       = time.
           /*
           tt-param.classifica      = input frame fPage3 rsClassif
           tt-param.desc-classifica = entry((tt-param.classifica - 1) * 2 + 1, 
                                            rsClassif:radio-buttons in frame fPage3).
                                            */
    DO  WITH FRAME fPage2:
        ASSIGN  tt-param.nr-embarque  = INPUT fiNrEmbarque  
                tt-param.dt-ini-emiss = INPUT dt-ini-emiss  
                tt-param.dt-fim-emiss = INPUT dt-fim-emiss.
    END.

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
    
    {report/rprun.i esp\ftp\esftp017rp.p}
    
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
    if  tt-param.destino = 2 then 
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

