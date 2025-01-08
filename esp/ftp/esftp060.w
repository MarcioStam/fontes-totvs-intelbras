&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESFTP060 1.12.00.001}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ESFTP060 MFT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE TEMP-TABLE ttped-fiscal LIKE ped-fiscal
    FIELD desc-situacao AS CHAR
    FIELD user-calc     LIKE nota-fiscal.user-calc
    FIELD vl-tot-nota   LIKE nota-fiscal.vl-tot-nota
    FIELD dt-emis-nota  AS DATE
    FIELD r-rowid       AS ROWID.

DEFINE NEW GLOBAL SHARED VAR I-NumPedidoEsftp060  AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-esftp012      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-esftp054      AS HANDLE NO-UNDO.
DEFINE VARIABLE gr-ped-fiscal   AS ROWID  NO-UNDO.

DEFINE BUTTON    btGoToOK     AUTO-GO LABEL "&OK" SIZE 10 BY 1 BGCOLOR 8.
DEFINE BUTTON    btGoToCancel AUTO-GO LABEL "&Cancela" SIZE 10 BY 1 BGCOLOR 8.

DEFINE RECTANGLE rtGoToFields  EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 65 BY 8.3 BGCOLOR 8.
DEFINE RECTANGLE rtGoToButton  EDGE-PIXELS 2 GRAPHIC-EDGE SIZE 72 BY 4.5 BGCOLOR 7.
DEFINE VARIABLE  c-observacao      LIKE ped-fiscal.observacao[1]   LABEL "Observacao"  VIEW-AS EDITOR  SIZE 60 BY 4 NO-UNDO.

DEFINE VARIABLE h-esftp060a AS HANDLE      NO-UNDO.

{utp/ut-glob.i}

procedure LockWindowUpdate external {&user} :
   def input  parameter hWndLock as long.
end procedure.

procedure GetWindowLongA external "user32.dll":
   def input  parameter hwnd   as long.
   def input  parameter nIndex as long.
   def return parameter returnValue as long.
end procedure.

procedure SetWindowLongA external "user32.dll":
   def input  parameter hwnd        as long.
   def input  parameter nIndex      as long.
   def input  parameter dwNewlong   as long.
   def return parameter returnValue as long.
end procedure.

procedure Bit_Remove external "PROEXTRA.DLL" :
   def input-output parameter Flags   as long.
   def input        parameter OldFlag as long.
end procedure.

procedure GetMenu external "user32.dll":
   def input  parameter iHwnd as long.
   def return parameter hMenu as long.
end procedure.

procedure SetMenu external "user32.dll":
   def input parameter iHwnd as long.
   def input parameter hMenu as long.
end procedure.

def var iStyle                           as integer   no-undo init ?.
def var iOldMenu                         as integer   no-undo.
def var dColWin                          as decimal   no-undo.
def var dRowWin                          as decimal   no-undo.
def var dHeiWin                          as decimal   no-undo.
def var dWidWin                          as decimal   no-undo.

DEF VAR de-dif-largura AS DEC NO-UNDO.
DEF VAR de-dif-altura AS DEC NO-UNDO.


DEF VAR h_f-main AS HANDLE NO-UNDO.
DEF VAR h_f1     AS HANDLE NO-UNDO.

DEF VAR f-main_altura_ini      AS DEC NO-UNDO.
DEF VAR f-main_largura_ini     AS DEC NO-UNDO.
DEF VAR br-pedidos_largura_ini AS DEC NO-UNDO.
DEF VAR br-pedidos_altura_ini  AS DEC NO-UNDO.
DEF VAR window_largura_ini     AS DEC NO-UNDO.
DEF VAR window_altura_ini      AS DEC NO-UNDO.
DEF VAR rect-1_largura_ini     AS DEC NO-UNDO.
DEF VAR rect-1_altura_ini      AS DEC NO-UNDO.



DEF VAR l-ampliou AS LOG INIT NO NO-UNDO.

DEF VAR l-primeiro AS LOG INIT YES.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE JanelaDetalhe
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br-Pedidos

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttped-fiscal emitente

/* Definitions for BROWSE br-Pedidos                                    */
&Scoped-define FIELDS-IN-QUERY-br-Pedidos ttped-fiscal.cod-estabel ttped-fiscal.nr-pedido ttped-fiscal.dt-aprovacao ttped-fiscal.cod-emitente emitente.nome-emit ttped-fiscal.nat-oper ttped-fiscal.usuario-magnus ttped-fiscal.desc-situacao ttped-fiscal.motivo-urg ttped-fiscal.serie ttped-fiscal.nr-nota-fis ttped-fiscal.user-calc ttped-fiscal.dt-emis-nota ttped-fiscal.vl-tot-nota   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-Pedidos   
&Scoped-define SELF-NAME br-Pedidos
&Scoped-define QUERY-STRING-br-Pedidos FOR EACH ttped-fiscal NO-LOCK, ~
           EACH emitente WHERE emitente.cod-emitente = ttped-fiscal.cod-emitente     BY ttped-fiscal.dt-aprovacao
&Scoped-define OPEN-QUERY-br-Pedidos OPEN QUERY {&SELF-NAME} FOR EACH ttped-fiscal NO-LOCK, ~
           EACH emitente WHERE emitente.cod-emitente = ttped-fiscal.cod-emitente     BY ttped-fiscal.dt-aprovacao.
&Scoped-define TABLES-IN-QUERY-br-Pedidos ttped-fiscal emitente
&Scoped-define FIRST-TABLE-IN-QUERY-br-Pedidos ttped-fiscal
&Scoped-define SECOND-TABLE-IN-QUERY-br-Pedidos emitente


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-br-Pedidos}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br-Pedidos bt-ok bt-detalhe bt-aprova ~
bt-relat bt-full-screen cod-estab-ini cod-estab-fim nr-pedido-ini ~
nr-pedido-fim ini-dt-pedido fim-dt-pedido cod-emitente-ini cod-emitente-fim ~
nat-oper-ini nat-oper-fim bt-confirma rs-situacao RECT-1 IMAGE-1 IMAGE-2 ~
IMAGE-19 IMAGE-20 IMAGE-21 IMAGE-22 IMAGE-33 IMAGE-34 IMAGE-37 IMAGE-38 ~
RECT-2 
&Scoped-Define DISPLAYED-OBJECTS cod-estab-ini cod-estab-fim nr-pedido-ini ~
nr-pedido-fim ini-dt-pedido fim-dt-pedido cod-emitente-ini cod-emitente-fim ~
nat-oper-ini nat-oper-fim rs-situacao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-aprova 
     LABEL "Aprova" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-confirma 
     IMAGE-UP FILE "image\im-sav":U
     LABEL "Button 1" 
     SIZE 5.29 BY 1.33.

DEFINE BUTTON bt-detalhe 
     LABEL "Detalhe" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-full-screen 
     IMAGE-UP FILE "image/tela-inteira.bmp":U
     LABEL "Maximizar" 
     SIZE 5.29 BY 1.33 TOOLTIP "Maximizar/Restaurar tela".

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-relat 
     LABEL "Relatorio" 
     SIZE 10 BY 1.

DEFINE VARIABLE cod-emitente-fim AS INTEGER FORMAT ">>>>>9" INITIAL 999999 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE cod-emitente-ini AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE cod-estab-fim AS CHARACTER FORMAT "X(3)" INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE cod-estab-ini AS CHARACTER FORMAT "X(3)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE fim-dt-pedido AS DATE FORMAT "99/99/9999" INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE ini-dt-pedido AS DATE FORMAT "99/99/9999" INITIAL 01/01/001 
     LABEL "Data do Pedido" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE nat-oper-fim AS INTEGER FORMAT "99" INITIAL 99 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE nat-oper-ini AS INTEGER FORMAT "99" INITIAL 0 
     LABEL "Natureza" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE nr-pedido-fim AS INTEGER FORMAT ">>>,>>9" INITIAL 999999 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE nr-pedido-ini AS INTEGER FORMAT ">>>,>>9" INITIAL 0 
     LABEL "Pedido" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-19
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-2
     FILENAME "image\ii-las":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-20
     FILENAME "image\ii-las":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-21
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-22
     FILENAME "image\ii-las":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-33
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-34
     FILENAME "image\ii-las":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-37
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-38
     FILENAME "image\ii-las":U
     SIZE 2.86 BY 1.

DEFINE VARIABLE rs-situacao AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "0 - Digitado", 0,
"1 - A Liberar", 1,
"2 - A Relacionar", 2,
"3 - A Faturar", 3,
"5 - Atendido", 5,
"6 - Todos", 6
     SIZE 93.43 BY .79 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 52 BY 1.38
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 104 BY 6.5.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-Pedidos FOR 
      ttped-fiscal, 
      emitente SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-Pedidos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-Pedidos wWindow _FREEFORM
  QUERY br-Pedidos NO-LOCK DISPLAY
      ttped-fiscal.cod-estabel   FORMAT "x(3)":U
      ttped-fiscal.nr-pedido     FORMAT ">>>,>>9":U
      ttped-fiscal.dt-aprovacao  FORMAT "99/99/9999"
      ttped-fiscal.cod-emitente  FORMAT ">>>>>9":U  COLUMN-LABEL "Cliente"
      emitente.nome-emit         FORMAT "x(30)":U
      ttped-fiscal.nat-oper      FORMAT "99":U      COLUMN-LABEL "Natureza"
      ttped-fiscal.usuario-magnus  FORMAT "x(12)":U  COLUMN-LABEL "Solicitante"
      ttped-fiscal.desc-situacao FORMAT "x(25)":U   COLUMN-LABEL "Situacao"
      ttped-fiscal.motivo-urg    FORMAT "x(1500)":U    COLUMN-LABEL "Motivo Urgencia"
      ttped-fiscal.serie         FORMAT "x(3)":U
      ttped-fiscal.nr-nota-fis   FORMAT "x(9)":U
      ttped-fiscal.user-calc     FORMAT "x(10)":U
      ttped-fiscal.dt-emis-nota  FORMAT "99/99/9999" COLUMN-LABEL "Dt Emiss∆o"
      ttped-fiscal.vl-tot-nota
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 104 BY 10.75
         FONT 4 ROW-HEIGHT-CHARS .46 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br-Pedidos AT ROW 8.5 COL 3 HELP
          "Duplo-clique sobre a linha abre o C†lculo de Notas Fiscais" WIDGET-ID 200
     bt-ok AT ROW 19.67 COL 3.72
     bt-detalhe AT ROW 19.67 COL 18.86 WIDGET-ID 74
     bt-aprova AT ROW 19.67 COL 29.14 WIDGET-ID 76
     bt-relat AT ROW 19.67 COL 44.29 WIDGET-ID 78
     bt-full-screen AT ROW 1.92 COL 101.14 WIDGET-ID 88
     cod-estab-ini AT ROW 2 COL 42 COLON-ALIGNED HELP
          "C¢digo do Estabelecimento" WIDGET-ID 96
     cod-estab-fim AT ROW 2.04 COL 61.29 COLON-ALIGNED HELP
          "C¢digo do Estabelecimento" NO-LABEL WIDGET-ID 94
     nr-pedido-ini AT ROW 3 COL 39 COLON-ALIGNED HELP
          "N£mero do Pedido" WIDGET-ID 128
     nr-pedido-fim AT ROW 3 COL 61.29 COLON-ALIGNED HELP
          "N£mero do Pedido" NO-LABEL WIDGET-ID 126
     ini-dt-pedido AT ROW 4 COL 33.43 COLON-ALIGNED WIDGET-ID 120
     fim-dt-pedido AT ROW 4 COL 61.29 COLON-ALIGNED NO-LABEL WIDGET-ID 98
     cod-emitente-ini AT ROW 5 COL 39 COLON-ALIGNED HELP
          "C¢digo do Cliente" WIDGET-ID 92
     cod-emitente-fim AT ROW 5 COL 61.29 COLON-ALIGNED HELP
          "C¢digo do Cliente" NO-LABEL WIDGET-ID 90
     nat-oper-ini AT ROW 6 COL 43 COLON-ALIGNED HELP
          "Natureza" WIDGET-ID 124
     nat-oper-fim AT ROW 6 COL 61.29 COLON-ALIGNED HELP
          "Natureza" NO-LABEL WIDGET-ID 122
     bt-confirma AT ROW 6.71 COL 101.14 WIDGET-ID 86
     rs-situacao AT ROW 7.13 COL 6.57 NO-LABEL WIDGET-ID 132
     RECT-1 AT ROW 19.46 COL 3
     IMAGE-1 AT ROW 2.04 COL 48.43 WIDGET-ID 100
     IMAGE-2 AT ROW 2.04 COL 59.86 WIDGET-ID 104
     IMAGE-19 AT ROW 3.04 COL 48.43 WIDGET-ID 102
     IMAGE-20 AT ROW 3.04 COL 59.86 WIDGET-ID 106
     IMAGE-21 AT ROW 5.04 COL 48.43 WIDGET-ID 108
     IMAGE-22 AT ROW 5.04 COL 59.86 WIDGET-ID 110
     IMAGE-33 AT ROW 6.04 COL 48.43 WIDGET-ID 112
     IMAGE-34 AT ROW 6.04 COL 59.86 WIDGET-ID 114
     IMAGE-37 AT ROW 4.04 COL 48.43 WIDGET-ID 116
     IMAGE-38 AT ROW 4.04 COL 59.86 WIDGET-ID 118
     RECT-2 AT ROW 1.75 COL 3.14 WIDGET-ID 130
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 107.14 BY 20.08
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: JanelaDetalhe
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert Custom SmartWindow title>"
         HEIGHT             = 20.08
         WIDTH              = 107.72
         MAX-HEIGHT         = 28.33
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28.33
         VIRTUAL-WIDTH      = 195.14
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-window.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB br-Pedidos 1 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-Pedidos
/* Query rebuild information for BROWSE br-Pedidos
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttped-fiscal NO-LOCK,
    EACH emitente WHERE emitente.cod-emitente = ttped-fiscal.cod-emitente
    BY ttped-fiscal.dt-aprovacao
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE br-Pedidos */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow /* <insert Custom SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* <insert Custom SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-Pedidos
&Scoped-define SELF-NAME br-Pedidos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-Pedidos wWindow
ON MOUSE-SELECT-CLICK OF br-Pedidos IN FRAME F-Main
DO:
    APPLY 'value-changed':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-Pedidos wWindow
ON MOUSE-SELECT-DBLCLICK OF br-Pedidos IN FRAME F-Main
DO:
    DEF VAR h-ft4003 AS handle NO-UNDO.

    ASSIGN I-NumPedidoEsftp060  = 0.


    IF  ttped-fiscal.situacao = 2 OR ttped-fiscal.situacao = 3 THEN DO:
        ASSIGN I-NumPedidoEsftp060  = ttped-fiscal.nr-pedido.
        
        /* Posiciona na sequencia do wt-docto j† gravada, no ft4003 */
        IF  ttped-fiscal.seq-wt-docto <> 0 THEN DO:
            FOR FIRST wt-docto
                WHERE wt-docto.seq-wt-docto = ttped-fiscal.seq-wt-docto NO-LOCK:
            
                RUN ftp/ft4003.w PERSISTENT SET h-ft4003.
                RUN initializeinterface IN h-ft4003.
                RUN initializeDBOs IN h-ft4003.     
                RUN repositionRecord IN h-ft4003 (INPUT ROWID(wt-docto)).
                RUN afterControlToolBar IN h-ft4003.
                WAIT-FOR CLOSE OF h-ft4003.
            END.
        END.
        ELSE
            RUN ftp/ft4003.w.

    END. /* IF  ttped-fiscal.situacao = 2 THEN ... */
    ELSE DO:
        run utp/ut-msgs.p ('show', 17006, 'Pedido nao disponivel para faturamento.~~Pedido deve estar na situacao "A Relacionar".').
    END. /* ELSE DO: */

    BROWSE br-Pedidos:REFRESH().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-Pedidos wWindow
ON ROW-DISPLAY OF br-Pedidos IN FRAME F-Main
DO:
  
    IF AVAIL ttped-fiscal AND ttped-fiscal.prioridade = 2 THEN
        ASSIGN  ttped-fiscal.cod-estabel :FGCOLOR   IN BROWSE br-Pedidos = 12
                ttped-fiscal.nr-pedido   :FGCOLOR   IN BROWSE br-Pedidos = 12
                ttped-fiscal.cod-emitente:FGCOLOR   IN BROWSE br-Pedidos = 12
                emitente.nome-emit       :FGCOLOR   IN BROWSE br-Pedidos = 12
                ttped-fiscal.nat-oper    :FGCOLOR   IN BROWSE br-Pedidos = 12
                ttped-fiscal.desc-situaca:FGCOLOR   IN BROWSE br-Pedidos = 12
                ttped-fiscal.motivo-urg  :FGCOLOR   IN BROWSE br-Pedidos = 12.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-Pedidos wWindow
ON VALUE-CHANGED OF br-Pedidos IN FRAME F-Main
DO:
    IF  AVAIL ttped-fiscal THEN
        ASSIGN gr-ped-fiscal = ttped-fiscal.r-rowid.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-aprova
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-aprova wWindow
ON CHOOSE OF bt-aprova IN FRAME F-Main /* Aprova */
DO:
    IF  AVAIL ttPed-fiscal THEN DO:
        
        ASSIGN gr-ped-fiscal = ttPed-fiscal.r-rowid.

        IF  NOT VALID-HANDLE(h-esftp054) THEN DO:
            RUN esp/ftp/esftp054.w PERSISTENT SET h-esftp054.
            RUN dispatch         IN h-esftp054 ('initialize') no-error.
            RUN repositionRecord IN h-esftp054 (INPUT gr-ped-fiscal).
        END.
        ELSE RUN repositionRecord IN h-esftp054 (INPUT gr-ped-fiscal).
    
    END. /* IF  AVAIL ttPed-fiscal THEN DO: */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-confirma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-confirma wWindow
ON CHOOSE OF bt-confirma IN FRAME F-Main /* Button 1 */
DO:

    EMPTY TEMP-TABLE ttped-fiscal.

    FOR EACH mgesp.ped-fiscal NO-LOCK WHERE
             ped-fiscal.cod-estabel    >= INPUT FRAME {&FRAME-NAME} cod-estab-ini AND 
             ped-fiscal.cod-estabel    <= INPUT FRAME {&FRAME-NAME} cod-estab-fim AND 
             ped-fiscal.dt-emissao     >= INPUT FRAME {&FRAME-NAME} ini-dt-pedido AND
             ped-fiscal.dt-emissao     <= INPUT FRAME {&FRAME-NAME} fim-dt-pedido AND
             ped-fiscal.nat-oper       >= INPUT FRAME {&FRAME-NAME} nat-oper-ini  AND
             ped-fiscal.nat-oper       <= INPUT FRAME {&FRAME-NAME} nat-oper-fim  :

        IF ped-fiscal.nr-pedido < INPUT FRAME {&FRAME-NAME} nr-pedido-ini
        OR ped-fiscal.nr-pedido > INPUT FRAME {&FRAME-NAME} nr-pedido-fim  THEN NEXT.

        IF INPUT FRAME {&FRAME-NAME} rs-situacao <> 6 THEN
            IF ped-fiscal.situacao <> INPUT FRAME {&FRAME-NAME} rs-situacao THEN NEXT.

        FIND FIRST natureza-ped-fiscal WHERE natureza-ped-fiscal.natureza = ped-fiscal.nat-oper NO-LOCK NO-ERROR.
        IF AVAIL natureza-ped-fiscal THEN DO:

            IF natureza-ped-fiscal.lib-monitor = NO THEN NEXT.

            CREATE ttped-fiscal.
            BUFFER-COPY ped-fiscal TO ttped-fiscal
                ASSIGN ttped-fiscal.r-rowid = ROWID(ped-fiscal).

            /***
            "0 - Digitado", 0,
            "1 - A Liberar", 1,
            "2 - A Relacionar", 2,
            "3 - A Faturar", 3,
            "4 - Atendido Parcialmente", 4,
            "5 - Atendido", 5,
            "6 - Todos", 6
            ***/
            CASE ped-fiscal.situacao:
                WHEN 0 THEN ASSIGN ttped-fiscal.desc-situacao = "Digitado".
                WHEN 1 THEN ASSIGN ttped-fiscal.desc-situacao = "A Liberar".
                WHEN 2 THEN ASSIGN ttped-fiscal.desc-situacao = "A Relacionar".
                WHEN 3 THEN ASSIGN ttped-fiscal.desc-situacao = "A Faturar".
                WHEN 4 THEN ASSIGN ttped-fiscal.desc-situacao = "Atendido Parcialmente".
                WHEN 5 THEN ASSIGN ttped-fiscal.desc-situacao = "Atendido".
            END CASE.

            FOR FIRST nota-fiscal NO-LOCK
                WHERE nota-fiscal.cod-estabel = ttped-fiscal.cod-estabel
                  AND nota-fiscal.serie       = ttped-fiscal.serie      
                  AND nota-fiscal.nr-nota-fis = ttped-fiscal.nr-nota-fis:

                ASSIGN ttped-fiscal.user-calc    = nota-fiscal.user-calc   
                       ttped-fiscal.vl-tot-nota  = nota-fiscal.vl-tot-nota 
                       ttped-fiscal.dt-emis-nota = nota-fiscal.dt-emis-nota.

            END.


        END. /* IF AVAIL natureza-ped-fiscal THEN DO: */

    END.

  {&OPEN-QUERY-br-Pedidos}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-detalhe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-detalhe wWindow
ON CHOOSE OF bt-detalhe IN FRAME F-Main /* Detalhe */
DO:
    IF  AVAIL ttped-fiscal THEN DO:

/*         RUN pi-bloq-abert-prog (INPUT "esftp060a").          */
/*         IF  RETURN-VALUE = "NOK" THEN RETURN "NOK".          */
/*                                                              */
/*         ASSIGN I-NumPedidoEsftp060 = ttped-fiscal.nr-pedido. */
/*                                                              */
/*         RUN esp/ftp/esftp060a.w.                             */


        ASSIGN I-NumPedidoEsftp060 = ttped-fiscal.nr-pedido.

        IF  NOT VALID-HANDLE(h-esftp060a) THEN DO:
            RUN esp/ftp/esftp060a.w PERSISTENT SET h-esftp060a.
            RUN dispatch IN h-esftp060a ('initialize':U) NO-ERROR.
            RUN dispatch IN h-esftp060a ('display-fields':U) NO-ERROR.
        END.
        ELSE RUN dispatch IN h-esftp060a ('display-fields':U) NO-ERROR.



    END. /* IF  AVAIL ttped-fiscal */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-full-screen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-full-screen wWindow
ON CHOOSE OF bt-full-screen IN FRAME F-Main /* Maximizar */
DO:
    IF  l-ampliou = NO THEN 
        l-ampliou = YES.
    ELSE
        l-ampliou = NO.
    
    IF  l-primeiro THEN DO:
        RUN pi-fullscreen.
        RUN pi-fullscreen.
        l-primeiro = NO.
    END.

    RUN pi-fullscreen.

    /*Maximizou*/
    IF  l-ampliou THEN DO:
        ASSIGN de-dif-largura                      = {&WINDOW-NAME}:WIDTH  - window_largura_ini 
               de-dif-altura                       = {&WINDOW-NAME}:HEIGHT - window_altura_ini 
               h_f-main:WIDTH                      = f-main_largura_ini    + de-dif-largura
               h_f-main:HEIGHT                     = f-main_altura_ini     + de-dif-altura
               br-pedidos:WIDTH  IN FRAME f-main   = br-pedidos_largura_ini + de-dif-largura
               br-pedidos:HEIGHT IN FRAME f-main   = br-pedidos_altura_ini  + de-dif-altura.

    END.
    ELSE DO: /* Voltou ao tamanho original */
        ASSIGN de-dif-largura  = 0   
               de-dif-altura   = 0 
               {&WINDOW-NAME}:WIDTH                = window_largura_ini            
               {&WINDOW-NAME}:HEIGHT               = window_altura_ini
               br-pedidos:WIDTH  IN FRAME f-main   = br-pedidos_largura_ini              
               br-pedidos:HEIGHT IN FRAME f-main   = br-pedidos_altura_ini 
               /*
               rtParent:WIDTH IN FRAME fpage0  = rtParent_largura_ini
               rtToolBar:WIDTH IN FRAME fpage0 = rtToolBar_largura_ini*/.    
    END.              
 
    
    ASSIGN rect-1:ROW IN FRAME f-main      = br-pedidos:ROW IN FRAME f-main + br-pedidos:HEIGHT IN FRAME f-main + .07
           bt-ok:ROW IN FRAME f-main       = br-pedidos:ROW IN FRAME f-main + br-pedidos:HEIGHT IN FRAME f-main + .25
           bt-detalhe:ROW IN FRAME f-main  = br-pedidos:ROW IN FRAME f-main + br-pedidos:HEIGHT IN FRAME f-main + .25
           bt-aprova:ROW IN FRAME f-main   = br-pedidos:ROW IN FRAME f-main + br-pedidos:HEIGHT IN FRAME f-main + .25
           bt-relat:ROW IN FRAME f-main    = br-pedidos:ROW IN FRAME f-main + br-pedidos:HEIGHT IN FRAME f-main + .25.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok wWindow
ON CHOOSE OF bt-ok IN FRAME F-Main /* Fechar */
DO:
  apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-relat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-relat wWindow
ON CHOOSE OF bt-relat IN FRAME F-Main /* Relatorio */
DO:
    RUN esp/rep/esrep004.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

ASSIGN h_f-main  = frame f-main:HANDLE.
       

ASSIGN  window_largura_ini     = {&WINDOW-NAME}:WIDTH  
        window_altura_ini      = {&WINDOW-NAME}:HEIGHT 
        f-main_largura_ini     = h_f-main:WIDTH
        f-main_altura_ini      = h_f-main:HEIGHT
        br-pedidos_largura_ini = br-pedidos:WIDTH  IN FRAME f-main
        br-pedidos_altura_ini  = br-pedidos:HEIGHT IN FRAME f-main .


/*{window/mainblock.i}*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWindow  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available wWindow  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterViewWindow wWindow 
PROCEDURE afterViewWindow :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
    wWindow:window-state = 1.
    MESSAGE 1
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    run setWindowState (input "maximized":U).
    MESSAGE 2
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
        */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeinitializeinterface wWindow 
PROCEDURE beforeinitializeinterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   /* run getWindowState.*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWindow  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
  THEN DELETE WIDGET wWindow.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWindow  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY cod-estab-ini cod-estab-fim nr-pedido-ini nr-pedido-fim ini-dt-pedido 
          fim-dt-pedido cod-emitente-ini cod-emitente-fim nat-oper-ini 
          nat-oper-fim rs-situacao 
      WITH FRAME F-Main IN WINDOW wWindow.
  ENABLE br-Pedidos bt-ok bt-detalhe bt-aprova bt-relat bt-full-screen 
         cod-estab-ini cod-estab-fim nr-pedido-ini nr-pedido-fim ini-dt-pedido 
         fim-dt-pedido cod-emitente-ini cod-emitente-fim nat-oper-ini 
         nat-oper-fim bt-confirma rs-situacao RECT-1 IMAGE-1 IMAGE-2 IMAGE-19 
         IMAGE-20 IMAGE-21 IMAGE-22 IMAGE-33 IMAGE-34 IMAGE-37 IMAGE-38 RECT-2 
      WITH FRAME F-Main IN WINDOW wWindow.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW wWindow.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy wWindow 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display wWindow 
PROCEDURE local-display :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit wWindow 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize wWindow 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}
  
  {utp/ut9000.i "ESFTP060" "1.12.00.001"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /*
  run getWindowState.
  */
  /* Code placed here will execute AFTER standard behavior.    */

  FIND FIRST usuar_univ 
      WHERE usuar_univ.cod_usuario = c-seg-usuario NO-LOCK NO-ERROR.

  IF  AVAIL usuar_univ THEN
      ASSIGN cod-estab-ini:SCREEN-VALUE IN FRAME f-main = usuar_univ.cod_estab
             cod-estab-fim:SCREEN-VALUE IN FRAME f-main = usuar_univ.cod_estab.

  ASSIGN bt-full-screen:SENSITIVE IN FRAME f-main = YES.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-fullscreen wWindow 
PROCEDURE pi-fullscreen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def var hWinParent as int no-undo.
   def var iCurStyle  as int no-undo.
   def var iOldStyle  as int no-undo.

   assign hWinParent = GetParent({&window-name}:hwnd).

   run LockWindowUpdate (input {&window-name}:hwnd).

   if iStyle = ? then do:
      run GetMenu (input  hWinParent,
                   output iOldMenu).
      run SetMenu (hWinParent,0).
      run GetWindowLongA (input  hWinParent,
                          input  -16,
                          output iCurStyle).
      run Bit_Remove     (input-output iCurStyle,
                          input        12582912).
      run Bit_Remove     (input-output iCurStyle,
                          input        262144).
      run SetWindowLongA (input  hWinParent,
                          input  -16,
                          input  iCurStyle,
                          output iOldStyle).
      assign dColWin               = {&window-name}:col
             dRowWin               = {&window-name}:row
             dHeiWin               = {&window-name}:height
             dWidWin               = {&window-name}:width
             {&window-name}:width  = session:width  - 4
             {&window-name}:height = session:height - 1
             {&window-name}:col    = 1
             {&window-name}:row    = 1
             iStyle                = iOldStyle.
   end.
   else do:
      run SetMenu (hWinParent,iOldMenu).
      run SetWindowLongA (hWinParent, -16, istyle, output iOldStyle).
      assign {&window-name}:col    = dColWin
             {&window-name}:row    = dRowWin
             {&window-name}:height = dHeiWin
             {&window-name}:width  = dWidWin
             iStyle                = ?.
   end.

   apply "window-resized" to {&window-name}.

   run LockWindowUpdate (input 0).
   return "ok".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records wWindow  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "ttped-fiscal"}
  {src/adm/template/snd-list.i "emitente"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed wWindow 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

