&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
          mgmov            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCCP053 1.00.00.000}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ESCCP053 ESP}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esccp053
&GLOBAL-DEFINE Version        1.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins ~
                              btExit btHelp btOK btCancel btHelp2

&GLOBAL-DEFINE page1widgets   brTable1 brTable2
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
DEFINE var iPedido    AS INTEGER NO-UNDO.
define var iPedidoAux as integer no-undo.

/* Local Variable Definitions ---                                       */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl     AS HANDLE NO-UNDO.
define new global shared variable iPedido-cc0300-upc as inte   no-undo.

DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
define variable c-modal     as char   no-undo.
define variable c-situacao  as char init "Impresso,Nao Impresso,Eliminado" no-undo.

/* Local Variable Definitions (DBOs Handles) --- */
def var c-transp as char init "Rodovi†rio,Aerovi†rio,Mar°timo,Ferrovi†rio,Rodoferrovi†rio,Rodofluvial,Rodoaerovi†rio,Outros"
    no-undo.

def buffer b-pedido-compr for pedido-compr.
DEF BUFFER b-ordem-compra FOR ordem-compra.
DEF BUFFER b-prazo-compra FOR prazo-compra.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brTable1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES int-rel-ped-import ordem-compra prazo-compra ~
b-ordem-compra b-pedido-compr b-prazo-compra

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 int-rel-ped-import.num-pedido-orig int-rel-ped-import.numero-ordem-orig ordem-compra.it-codigo int-rel-ped-import.parcela-orig ordem-compra.cod-cond-pag c-modal prazo-compra.quant-saldo ordem-compra.preco-fornec int-rel-ped-import.num-pedido-dest int-rel-ped-import.numero-ordem-dest int-rel-ped-import.parcela-dest b-ordem-compra.cod-cond-pag fn-transp(b-pedido-compr.via-transp) b-prazo-compra.quant-saldo b-ordem-compra.preco-fornec int-rel-ped-import.comentarios   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1   
&Scoped-define SELF-NAME brTable1
&Scoped-define QUERY-STRING-brTable1 FOR EACH int-rel-ped-import NO-LOCK        WHERE int-rel-ped-import.num-pedido-orig = iPedido, ~
              first ordem-compra no-lock        where ordem-compra.numero-ordem = int-rel-ped-import.numero-ordem-orig, ~
              first prazo-compra no-lock        where prazo-compra.numero-ordem = int-rel-ped-import.numero-ordem-orig          and prazo-compra.parcela      = int-rel-ped-import.parcela-orig, ~
              first b-ordem-compra no-lock        where b-ordem-compra.numero-ordem = int-rel-ped-import.numero-ordem-dest, ~
              first b-pedido-compr no-lock        where b-pedido-compr.num-pedido = b-ordem-compra.num-pedido, ~
              first b-prazo-compra no-lock        where b-prazo-compra.numero-ordem = b-ordem-compra.numero-ordem          and b-prazo-compra.parcela      = int-rel-ped-import.parcela-dest
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY {&SELF-NAME}     FOR EACH int-rel-ped-import NO-LOCK        WHERE int-rel-ped-import.num-pedido-orig = iPedido, ~
              first ordem-compra no-lock        where ordem-compra.numero-ordem = int-rel-ped-import.numero-ordem-orig, ~
              first prazo-compra no-lock        where prazo-compra.numero-ordem = int-rel-ped-import.numero-ordem-orig          and prazo-compra.parcela      = int-rel-ped-import.parcela-orig, ~
              first b-ordem-compra no-lock        where b-ordem-compra.numero-ordem = int-rel-ped-import.numero-ordem-dest, ~
              first b-pedido-compr no-lock        where b-pedido-compr.num-pedido = b-ordem-compra.num-pedido, ~
              first b-prazo-compra no-lock        where b-prazo-compra.numero-ordem = b-ordem-compra.numero-ordem          and b-prazo-compra.parcela      = int-rel-ped-import.parcela-dest.
&Scoped-define TABLES-IN-QUERY-brTable1 int-rel-ped-import ordem-compra ~
prazo-compra b-ordem-compra b-pedido-compr b-prazo-compra
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 int-rel-ped-import
&Scoped-define SECOND-TABLE-IN-QUERY-brTable1 ordem-compra
&Scoped-define THIRD-TABLE-IN-QUERY-brTable1 prazo-compra
&Scoped-define FOURTH-TABLE-IN-QUERY-brTable1 b-ordem-compra
&Scoped-define FIFTH-TABLE-IN-QUERY-brTable1 b-pedido-compr
&Scoped-define SIXTH-TABLE-IN-QUERY-brTable1 b-prazo-compra


/* Definitions for BROWSE brTable2                                      */
&Scoped-define FIELDS-IN-QUERY-brTable2 int-rel-ped-import.num-pedido-dest int-rel-ped-import.numero-ordem-dest ordem-compra.it-codigo int-rel-ped-import.parcela-dest ordem-compra.cod-cond-pag c-modal prazo-compra.quant-saldo ordem-compra.preco-fornec int-rel-ped-import.comentarios int-rel-ped-import.num-pedido-orig int-rel-ped-import.numero-ordem-orig int-rel-ped-import.parcela-orig b-ordem-compra.cod-cond-pag fn-transp(b-pedido-compr.via-transp) b-prazo-compra.quant-saldo b-ordem-compra.preco-fornec   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable2   
&Scoped-define SELF-NAME brTable2
&Scoped-define QUERY-STRING-brTable2 FOR EACH int-rel-ped-import use-index index3 NO-LOCK        WHERE int-rel-ped-import.num-pedido-dest = iPedido, ~
              first ordem-compra no-lock        where ordem-compra.numero-ordem = int-rel-ped-import.numero-ordem-dest, ~
              first prazo-compra no-lock        where prazo-compra.numero-ordem = int-rel-ped-import.numero-ordem-dest          and prazo-compra.parcela      = int-rel-ped-import.parcela-dest, ~
              first b-ordem-compra no-lock        where b-ordem-compra.numero-ordem = int-rel-ped-import.numero-ordem-orig, ~
              first b-pedido-compr no-lock        where b-pedido-compr.num-pedido = b-ordem-compra.num-pedido, ~
              first b-prazo-compra no-lock        where b-prazo-compra.numero-ordem = b-ordem-compra.numero-ordem          and b-prazo-compra.parcela      = int-rel-ped-import.parcela-orig
&Scoped-define OPEN-QUERY-brTable2 OPEN QUERY {&SELF-NAME}     FOR EACH int-rel-ped-import use-index index3 NO-LOCK        WHERE int-rel-ped-import.num-pedido-dest = iPedido, ~
              first ordem-compra no-lock        where ordem-compra.numero-ordem = int-rel-ped-import.numero-ordem-dest, ~
              first prazo-compra no-lock        where prazo-compra.numero-ordem = int-rel-ped-import.numero-ordem-dest          and prazo-compra.parcela      = int-rel-ped-import.parcela-dest, ~
              first b-ordem-compra no-lock        where b-ordem-compra.numero-ordem = int-rel-ped-import.numero-ordem-orig, ~
              first b-pedido-compr no-lock        where b-pedido-compr.num-pedido = b-ordem-compra.num-pedido, ~
              first b-prazo-compra no-lock        where b-prazo-compra.numero-ordem = b-ordem-compra.numero-ordem          and b-prazo-compra.parcela      = int-rel-ped-import.parcela-orig.
&Scoped-define TABLES-IN-QUERY-brTable2 int-rel-ped-import ordem-compra ~
prazo-compra b-ordem-compra b-pedido-compr b-prazo-compra
&Scoped-define FIRST-TABLE-IN-QUERY-brTable2 int-rel-ped-import
&Scoped-define SECOND-TABLE-IN-QUERY-brTable2 ordem-compra
&Scoped-define THIRD-TABLE-IN-QUERY-brTable2 prazo-compra
&Scoped-define FOURTH-TABLE-IN-QUERY-brTable2 b-ordem-compra
&Scoped-define FIFTH-TABLE-IN-QUERY-brTable2 b-pedido-compr
&Scoped-define SIXTH-TABLE-IN-QUERY-brTable2 b-prazo-compra


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brTable1}~
    ~{&OPEN-QUERY-brTable2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 rtToolBar RECT-3 btExit btOK ~
btHelp2 
&Scoped-Define DISPLAYED-OBJECTS fi-num-pedido fi-cod-emitente ~
fi-nome-abrev fi-nome-emit fi-cod-estabel fi-data-pedido fi-situacao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-transp wWindow 
FUNCTION fn-transp RETURNS CHARACTER
  ( input i-via-transp as inte )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "Sair" 
     SIZE 10 BY 1.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE fi-cod-emitente AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-estabel AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fi-data-pedido AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Pedido" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-abrev AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-emit AS CHARACTER FORMAT "x(80)" 
     VIEW-AS FILL-IN 
     SIZE 81 BY .88 NO-UNDO.

DEFINE VARIABLE fi-num-pedido AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Pedido" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-situacao AS CHARACTER FORMAT "X(12)":U 
     LABEL "Situaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 142 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 142 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 142.72 BY 1.5
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 140 BY 7.25.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 140 BY 7.25.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      int-rel-ped-import, 
      ordem-compra, 
      prazo-compra, 
      b-ordem-compra, 
      b-pedido-compr, 
      b-prazo-compra SCROLLING.

DEFINE QUERY brTable2 FOR 
      int-rel-ped-import, 
      ordem-compra, 
      prazo-compra, 
      b-ordem-compra, 
      b-pedido-compr, 
      b-prazo-compra SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wWindow _FREEFORM
  QUERY brTable1 NO-LOCK DISPLAY
      int-rel-ped-import.num-pedido-orig   format ">>>>>,>>9"    column-label "Ped Orig"   width 9 
int-rel-ped-import.numero-ordem-orig format "zzzzz9,99"    column-label "Ord Orig"   width 9
ordem-compra.it-codigo               FORMAT "x(16)"        column-label "Item"       width 11
int-rel-ped-import.parcela-orig      format ">>>>9"        column-label "Par O"      width 5
ordem-compra.cod-cond-pag            format ">>>9"         column-label "Pag O"      width 7
c-modal                              format "x(15)"        column-label "Modal Orig" width 11
prazo-compra.quant-saldo             format "->>>>,>>9"    column-label "Qtde Orig"  width 11
ordem-compra.preco-fornec            format ">>>>,>>9.999" column-label "Preáo Orig" width 12
int-rel-ped-import.num-pedido-dest   format ">>>>>,>>9"    column-label "Ped Dest"   width 9
int-rel-ped-import.numero-ordem-dest format "zzzzz9,99"    column-label "Ord Dest"   width 9
int-rel-ped-import.parcela-dest      format ">>>>9"        column-label "Par D"      width 5
b-ordem-compra.cod-cond-pag          format ">>>9"         column-label "Pag D"      width 7
fn-transp(b-pedido-compr.via-transp) format "x(15)"        column-label "Modal Dest" width 11
b-prazo-compra.quant-saldo           format "->>>>,>>9"    column-label "Qtde Dest"  width 11
b-ordem-compra.preco-fornec          format ">>>>,>>9.999" column-label "Preáo Dest" width 12
int-rel-ped-import.comentarios                                                       width 30
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 136.57 BY 6
         FONT 1
         TITLE "Pedido Origem" ROW-HEIGHT-CHARS .5 FIT-LAST-COLUMN.

DEFINE BROWSE brTable2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable2 wWindow _FREEFORM
  QUERY brTable2 NO-LOCK DISPLAY
      int-rel-ped-import.num-pedido-dest   format ">>>>>,>>9"    column-label "Ped Dest"   width 9
int-rel-ped-import.numero-ordem-dest format "zzzzz9,99"    column-label "Ord Dest"   width 9
ordem-compra.it-codigo               format "x(16)"        column-label "Item"       width 11
int-rel-ped-import.parcela-dest      format ">>>>9"        column-label "Par D"      width 5
ordem-compra.cod-cond-pag            format ">>>9"         column-label "Pag D"      width 7
c-modal                              format "x(15)"        column-label "Modal Dest" width 11
prazo-compra.quant-saldo             format "->>>>,>>9"    column-label "Qtde Dest"  width 11
ordem-compra.preco-fornec            format ">>>>,>>9.999" column-label "Preáo Dest" width 12
int-rel-ped-import.comentarios                                                       width 30
int-rel-ped-import.num-pedido-orig   format ">>>>>,>>9"    column-label "Ped Orig"   width 9 
int-rel-ped-import.numero-ordem-orig format "zzzzz9,99"    column-label "Ord Orig"   width 9 
int-rel-ped-import.parcela-orig      format ">>>>9"        column-label "Par O"      width 5
b-ordem-compra.cod-cond-pag          format ">>>9"         column-label "Pag O"      width 7
fn-transp(b-pedido-compr.via-transp) format "x(15)"        column-label "Modal Orig" width 11
b-prazo-compra.quant-saldo           format "->>>>,>>9"    column-label "Qtde Orig"  width 11
b-ordem-compra.preco-fornec          format ">>>>,>>9.999" column-label "Preáo Orig" width 12
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 136.57 BY 6
         FONT 1
         TITLE "Pedido Destino" ROW-HEIGHT-CHARS .5 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 126.14 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 130.14 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 134.14 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 138.14 HELP
          "Ajuda"
     fi-num-pedido AT ROW 2.75 COL 13.29 COLON-ALIGNED WIDGET-ID 20
     fi-cod-emitente AT ROW 2.75 COL 34.72 COLON-ALIGNED WIDGET-ID 22
     fi-nome-abrev AT ROW 2.75 COL 46 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     fi-nome-emit AT ROW 2.75 COL 59.29 COLON-ALIGNED HELP
          "Nome Completo do Emitente" NO-LABEL WIDGET-ID 30
     fi-cod-estabel AT ROW 3.75 COL 13.29 COLON-ALIGNED WIDGET-ID 28
     fi-data-pedido AT ROW 3.75 COL 34.72 COLON-ALIGNED WIDGET-ID 26
     fi-situacao AT ROW 3.75 COL 127.29 COLON-ALIGNED WIDGET-ID 24
     btOK AT ROW 21.08 COL 3
     btCancel AT ROW 21.08 COL 13.72 WIDGET-ID 16
     btHelp2 AT ROW 21.08 COL 133
     rtToolBar-2 AT ROW 1 COL 1.29
     rtToolBar AT ROW 20.88 COL 2
     RECT-3 AT ROW 2.58 COL 1.86 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 143.72 BY 21.79
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     brTable1 AT ROW 2.17 COL 3.43 WIDGET-ID 200
     brTable2 AT ROW 9.75 COL 3.43 WIDGET-ID 300
     RECT-1 AT ROW 9 COL 2 WIDGET-ID 2
     RECT-2 AT ROW 1.5 COL 2 WIDGET-ID 4
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 4.96
         SIZE 142 BY 15.75
         FONT 1 WIDGET-ID 100.


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
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "Troca de Pedidos DE-PARA"
         HEIGHT             = 21.38
         WIDTH              = 143.72
         MAX-HEIGHT         = 40.5
         MAX-WIDTH          = 274.29
         VIRTUAL-HEIGHT     = 40.5
         VIRTUAL-WIDTH      = 274.29
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON btCancel IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       btCancel:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR BUTTON btHelp IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btQueryJoins IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btReportsJoins IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cod-emitente IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cod-estabel IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-data-pedido IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-nome-abrev IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-nome-emit IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-num-pedido IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-situacao IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brTable1 RECT-2 fPage1 */
/* BROWSE-TAB brTable2 brTable1 fPage1 */
ASSIGN 
       brTable1:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE
       brTable1:COLUMN-MOVABLE IN FRAME fPage1         = TRUE.

ASSIGN 
       brTable2:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE
       brTable2:COLUMN-MOVABLE IN FRAME fPage1         = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME}
    FOR EACH int-rel-ped-import NO-LOCK
       WHERE int-rel-ped-import.num-pedido-orig = iPedido,
       first ordem-compra no-lock
       where ordem-compra.numero-ordem = int-rel-ped-import.numero-ordem-orig,
       first prazo-compra no-lock
       where prazo-compra.numero-ordem = int-rel-ped-import.numero-ordem-orig
         and prazo-compra.parcela      = int-rel-ped-import.parcela-orig,
       first b-ordem-compra no-lock
       where b-ordem-compra.numero-ordem = int-rel-ped-import.numero-ordem-dest,
       first b-pedido-compr no-lock
       where b-pedido-compr.num-pedido = b-ordem-compra.num-pedido,
       first b-prazo-compra no-lock
       where b-prazo-compra.numero-ordem = b-ordem-compra.numero-ordem
         and b-prazo-compra.parcela      = int-rel-ped-import.parcela-dest.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brTable1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable2
/* Query rebuild information for BROWSE brTable2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME}
    FOR EACH int-rel-ped-import use-index index3 NO-LOCK
       WHERE int-rel-ped-import.num-pedido-dest = iPedido,
       first ordem-compra no-lock
       where ordem-compra.numero-ordem = int-rel-ped-import.numero-ordem-dest,
       first prazo-compra no-lock
       where prazo-compra.numero-ordem = int-rel-ped-import.numero-ordem-dest
         and prazo-compra.parcela      = int-rel-ped-import.parcela-dest,
       first b-ordem-compra no-lock
       where b-ordem-compra.numero-ordem = int-rel-ped-import.numero-ordem-orig,
       first b-pedido-compr no-lock
       where b-pedido-compr.num-pedido = b-ordem-compra.num-pedido,
       first b-prazo-compra no-lock
       where b-prazo-compra.numero-ordem = b-ordem-compra.numero-ordem
         and b-prazo-compra.parcela      = int-rel-ped-import.parcela-orig.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brTable2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow /* Troca de Pedidos DE-PARA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Troca de Pedidos DE-PARA */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* Sair */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON TAB OF btOK IN FRAME fpage0 /* Sair */
DO:
  apply 'entry' to fi-num-pedido in frame fPage0.
  return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-emitente wWindow
ON LEAVE OF fi-cod-emitente IN FRAME fpage0 /* Fornecedor */
DO:
  assign fi-nome-abrev:screen-value in frame fpage0 = ""
         fi-nome-emit:screen-value  in frame fpage0 = "".

  for first emitente fields(cod-emitente nome-abrev nome-emit)
      where emitente.cod-emitente = input frame fpage0 fi-cod-emitente:
      assign fi-nome-abrev:screen-value in frame fpage0 = emitente.nome-abrev
             fi-nome-emit:screen-value  in frame fpage0 = trim(emitente.nome-emit).
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-num-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-num-pedido wWindow
ON F5 OF fi-num-pedido IN FRAME fpage0 /* Pedido */
DO:
  {include/zoomvar.i &prog-zoom  = inzoom/z01in295.w
                     &campo      = fi-num-pedido
                     &campozoom  = num-pedido}  
                       
   wait-for close of wh-pesquisa.

   apply 'leave' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-num-pedido wWindow
ON LEAVE OF fi-num-pedido IN FRAME fpage0 /* Pedido */
DO:
    assign iPedido = input frame fPage0 fi-num-pedido.

    if iPedido <> iPedidoAux
    then do:
         assign iPedidoAux = iPedido.
        
         for first pedido-compr
             where pedido-compr.num-pedido = iPedido
                   no-lock: end.

         do with frame fPage0:
             run pi-limpa.
        
             if avail pedido-compr
             then do:
                  assign fi-cod-emitente:screen-value = string(pedido-compr.cod-emitente)
                         fi-cod-estabel:screen-value  = pedido-compr.cod-estabel
                         fi-data-pedido:screen-value  = string(pedido-compr.data-pedido)
                         fi-situacao:screen-value     = entry(pedido-compr.situacao,c-situacao)
                         c-modal                      = fn-transp(pedido-compr.via-transp).

                  apply 'leave' to fi-cod-emitente.
             end. /* if avail pedido-compr */
         end. /* do with frame fPage0 */
        
         {&open-query-brTable1}     
         {&open-query-brTable2}
        
         if  not avail pedido-compr
         and iPedido <> 0
         then run utp/ut-msgs.p (input "show", input 17567, input "Pedido " + string(iPedido) + " n∆o foi encontrado!").
    end. /* if iPedido <> iPedidoAux */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-num-pedido wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-num-pedido IN FRAME fpage0 /* Pedido */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-num-pedido wWindow
ON RETURN OF fi-num-pedido IN FRAME fpage0 /* Pedido */
DO:
  assign iPedidoAux = ?.

  apply 'leave' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-num-pedido wWindow
ON VALUE-CHANGED OF fi-num-pedido IN FRAME fpage0 /* Pedido */
DO:
  run pi-limpa.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wWindow
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brTable1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
fi-num-pedido:load-mouse-pointer("image/lupa.cur") in frame {&frame-name}.
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    find current pedido-compr no-lock no-error.
    find current ordem-compra no-lock no-error.
    find current prazo-compra no-lock no-error.
    release pedido-compr.
    release ordem-compra.
    release prazo-compra.
 
    if iPedido-cc0300-upc <> 0
    then do:
         assign fi-num-pedido:screen-value in frame fPage0 = string(iPedido-cc0300-upc).
         assign iPedido-cc0300-upc = 0.
         apply 'leave' to fi-num-pedido in frame fPage0.
    end.
    else assign fi-num-pedido:sensitive in frame fPage0 = yes.

    assign btCancel:hidden in frame fPage0 = yes
           btHelp2:hidden  in frame fPage0 = yes
           btQueryJoins:sensitive   in frame fPage0 = no
           btReportsJoins:sensitive in frame fPage0 = no
           btHelp:sensitive         in frame fPage0 = no.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-limpa wWindow 
PROCEDURE pi-limpa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if num-results("brTable1":U) > 0 
    then close query brTable1.
    if num-results("brTable2":U) > 0 
    then close query brTable2.

    do with frame fpage0:
        assign fi-cod-emitente:screen-value = ""
               fi-nome-abrev:screen-value   = ""
               fi-nome-emit:screen-value    = ""
               fi-cod-estabel:screen-value  = ""
               fi-data-pedido:screen-value  = ""
               fi-situacao:screen-value     = ""
               c-modal                      = "".
    end.

    return "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-transp wWindow 
FUNCTION fn-transp RETURNS CHARACTER
  ( input i-via-transp as inte ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  if  i-via-transp > 0 
  and i-via-transp < 9 
  then return entry(i-via-transp,c-transp,",").

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

