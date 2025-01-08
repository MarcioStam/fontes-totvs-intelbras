&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
{include/i-prgvrs.i escpp045 1.00.00.000}

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        escpp045
&GLOBAL-DEFINE Version        1.00.00.000

DEFINE VARIABLE h-api023   AS HANDLE    NO-UNDO.
run btb/btb906za.p.
run men/men901za.p (Input 'escpp045').
if  return-value = "2014" then do:
    /* Programa a ser executado n’o ² um programa vÿlido Datasul ! */
    run utp/ut-msgs.p (input "show", input 3045, input 'escpp045').
    return.
end.
    
if  return-value = "2012" then do:
    /* Usuÿrio sem permiss’o para acessar o programa. */
    run utp/ut-msgs.p (input "show", input 2858, input 'escpp045').
    return.
end.    
    
{esapi/esapi023.i}      /* ttitem / ttarq / tt-mac-address */
{esapi/esapi016.i}
{cdp/cd0666.i}

/* Parameters Definitions ---                                           */
DEF NEW GLOBAL SHARED VAR adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE NEW SHARED VARIABLE h-acomp AS HANDLE NO-UNDO.
DEF VAR wh-pesquisa AS HANDLE NO-UNDO.
DEF VAR l-implanta AS LOGICAL.

DEF VAR v-remetente AS CHAR.

/* Local Variable Definitions ---                                       */

DEF VAR vqtd AS INT.
DEF VAR varquivo AS CHAR.

DEFINE VAR cRemetente    AS CHAR FORMAT 'x(60)' NO-UNDO.
DEFINE VAR CDestino      AS CHAR FORMAT 'x(60)' NO-UNDO.
DEFINE VAR CAssunto      AS CHAR FORMAT 'x(60)' NO-UNDO.
DEFINE VAR CDescEmail    AS CHAR FORMAT 'x(2000)' NO-UNDO.
DEFINE VAR CArqEmail     AS CHAR FORMAT 'x(60)' NO-UNDO.

DEF VAR i-ns-ini      AS INT NO-UNDO.
DEF VAR i-ns-fim      AS INT NO-UNDO.
DEF VAR c-msg-erro AS CHAR NO-UNDO.
DEF VAR c-data AS CHAR NO-UNDO.
DEF VAR p-ok AS LOGICAL NO-UNDO.
DEF VAR i-geracao AS INT NO-UNDO.
DEF VAR c-dt-po AS CHAR NO-UNDO.
DEF VAR c-caminho AS CHAR NO-UNDO.
DEF VAR l-teste AS LOGICAL NO-UNDO.

DEFINE VARIABLE copyfilename AS CHARACTER NO-UNDO.
DEFINE VARIABLE v-buffer-mac AS DECIMAL   NO-UNDO.
DEFINE TEMP-TABLE tt-erro-geral LIKE tt-erro.

{upc/btb910za-upc.i} /* Estabelecimento do usu rio corrente - v_cod_estab_usuar */

def new Global shared var c-seg-usuario  as char format "x(12)" no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttitem

/* Definitions for BROWSE br1                                           */
&Scoped-define FIELDS-IN-QUERY-br1 marcado it-codigo desc-item qt-pedido gerado-ns gerado-mac   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br1   
&Scoped-define SELF-NAME br1
&Scoped-define QUERY-STRING-br1 FOR EACH ttitem NO-LOCK
&Scoped-define OPEN-QUERY-br1 OPEN QUERY {&SELF-NAME} FOR EACH ttitem NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br1 ttitem
&Scoped-define FIRST-TABLE-IN-QUERY-br1 ttitem


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bt-email tg-mac tg-num-serie fi-num-pedido ~
fi-email btgera BUTTON-3 fbotoes RECT-32 br1 
&Scoped-Define DISPLAYED-OBJECTS tg-mac tg-num-serie fi-num-pedido ~
femitente fnome fi-email 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD conv-dec-to-hex C-Win 
FUNCTION conv-dec-to-hex RETURNS CHARACTER
  ( INPUT p-num-decimal AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD conv-hex-to-dec C-Win 
FUNCTION conv-hex-to-dec RETURNS INTEGER
  ( INPUT p-val-hexadecimal AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fator C-Win 
FUNCTION fator RETURNS INTEGER
  ( INPUT p-fator AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-email 
     LABEL "Reenviar Email" 
     SIZE 15 BY 1.13.

DEFINE BUTTON btgera 
     LABEL "Gerar" 
     SIZE 15 BY 1.13.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "image/im-exi.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-exi.bmp":U
     LABEL "Button 3" 
     SIZE 4.57 BY 1.25.

DEFINE VARIABLE femitente AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Fornecedor":R15 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-email AS CHARACTER FORMAT "X(256)":U 
     LABEL "email" 
     VIEW-AS FILL-IN 
     SIZE 74 BY .88 NO-UNDO.

DEFINE VARIABLE fi-num-pedido AS INTEGER FORMAT ">>>>>,>>9" INITIAL 0 
     LABEL "Pedido":R8 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fnome AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 61 BY .88 NO-UNDO.

DEFINE RECTANGLE fbotoes
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 92 BY 1.5.

DEFINE RECTANGLE RECT-32
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 92 BY 5.25.

DEFINE VARIABLE tg-mac AS LOGICAL INITIAL yes 
     LABEL "Gerar Mac Address" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.

DEFINE VARIABLE tg-num-serie AS LOGICAL INITIAL yes 
     LABEL "Gerar N£mero de S‚rie" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br1 FOR 
      ttitem SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br1 C-Win _FREEFORM
  QUERY br1 DISPLAY
      marcado     COLUMN-LABEL "*"         
 it-codigo   COLUMN-LABEL "Item"       FORMAT "x(7)"  WIDTH 9
 desc-item   COLUMN-LABEL "Descricao"  FORMAT "x(40)"
 qt-pedido   COLUMN-LABEL "Qt.Pedido"                    WIDTH 10   
 gerado-ns   COLUMN-LABEL "NS Gerados"  FORMAT ">>>,>>>,>>9"  WIDTH 10
 gerado-mac  COLUMN-LABEL "Mac Gerados" FORMAT ">>>,>>>,>>9"  WIDTH 10
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 92 BY 9.25
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     bt-email AT ROW 17.75 COL 18 WIDGET-ID 124
     tg-mac AT ROW 7 COL 15 WIDGET-ID 122
     tg-num-serie AT ROW 6 COL 15 WIDGET-ID 120
     fi-num-pedido AT ROW 3 COL 13 COLON-ALIGNED HELP
          "N£mero do Pedido de Compra" WIDGET-ID 110
     femitente AT ROW 4 COL 13 COLON-ALIGNED HELP
          "Fornecedor Inicial" WIDGET-ID 102
     fnome AT ROW 4 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 108
     fi-email AT ROW 5 COL 13 COLON-ALIGNED WIDGET-ID 118
     btgera AT ROW 17.75 COL 2 WIDGET-ID 104
     BUTTON-3 AT ROW 1.13 COL 88 WIDGET-ID 50
     br1 AT ROW 8.25 COL 1 WIDGET-ID 200
     fbotoes AT ROW 1 COL 1 WIDGET-ID 44
     RECT-32 AT ROW 2.75 COL 1 WIDGET-ID 52
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 92 BY 18.13
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Gera Num.Serie para Item OEM"
         HEIGHT             = 18.13
         WIDTH              = 92
         MAX-HEIGHT         = 19
         MAX-WIDTH          = 100
         VIRTUAL-HEIGHT     = 19
         VIRTUAL-WIDTH      = 100
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB C-Win 
/* ************************* Included-Libraries *********************** */

{esp/showmsg.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB br1 RECT-32 fpage0 */
/* SETTINGS FOR FILL-IN femitente IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fnome IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       fnome:READ-ONLY IN FRAME fpage0        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br1
/* Query rebuild information for BROWSE br1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttitem NO-LOCK.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Gera Num.Serie para Item OEM */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Gera Num.Serie para Item OEM */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br1
&Scoped-define SELF-NAME br1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br1 C-Win
ON MOUSE-SELECT-DBLCLICK OF br1 IN FRAME fpage0
DO:
    if ttitem.marcado = yes then
        ASSIGN ttitem.marcado = NO.    
    ELSE DO:

        FOR FIRST item-ean NO-LOCK
            WHERE ITEM-ean.it-codigo = ttitem.it-codigo:
        END.

        IF ttitem.qt-pedido - ttitem.gerado-ns  <= 0 AND
           ttitem.qt-pedido  + (ttitem.qt-pedido  * ttItem.buffer-mac / 100) - ttitem.gerado-mac <= 0 THEN DO:

            ASSIGN c-msg-erro = "Item nÆo pode ser selecionado|" +
                     SUBSTITUTE("Todos os Num.S‚rie e MACs para o Item &1 j  foram gerados",
                                TRIM(ttitem.it-codigo)).
            
            RUN ShowMessage (1, ENTRY(1, c-msg-erro, "|"), 
                                ENTRY(2, c-msg-erro, "|")).

            RETURN NO-APPLY.
        END.
        ASSIGN ttitem.marcado = yes.
    END.
    {&open-query-br1}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-email
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-email C-Win
ON CHOOSE OF bt-email IN FRAME fpage0 /* Reenviar Email */
DO:
    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar in h-acomp (input "Enviando email").
    RUN piEmail.
    RUN pi-finalizar IN h-acomp.
    ASSIGN h-acomp = ?.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btgera
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btgera C-Win
ON CHOOSE OF btgera IN FRAME fpage0 /* Gerar */
DO:
    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Gera‡Æo de Seriais"). 
    RUN pi-gera.
    RUN pi-finalizar IN h-acomp.
    ASSIGN h-acomp = ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 C-Win
ON CHOOSE OF BUTTON-3 IN FRAME fpage0 /* Button 3 */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME femitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL femitente C-Win
ON MOUSE-SELECT-DBLCLICK OF femitente IN FRAME fpage0 /* Fornecedor */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad098.w"
                       &campo="femitente"    
                       &campo2="fnome"
                       &campozoom="cod-emitente"
                       &campozoom2="nome-emit"
                       &frame="fpage0"
                       &frame2="fpage0"}
                       
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-num-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-num-pedido C-Win
ON LEAVE OF fi-num-pedido IN FRAME fpage0 /* Pedido */
DO:
    IF  INPUT FRAME {&FRAME-NAME} fi-num-pedido <> "0" THEN DO:
        ASSIGN fi-email:SCREEN-VALUE = "".
        RUN pi-carrega-ttitem.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
   
    RUN enable_UI.

   
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  DISPLAY tg-mac tg-num-serie fi-num-pedido femitente fnome fi-email 
      WITH FRAME fpage0 IN WINDOW C-Win.
  ENABLE bt-email tg-mac tg-num-serie fi-num-pedido fi-email btgera BUTTON-3 
         fbotoes RECT-32 br1 
      WITH FRAME fpage0 IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-fpage0}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geracaoMac C-Win 
PROCEDURE geracaoMac :
/*------------------------------------------------------------------------------
  Purpose: Executa rotina de efetiva‡Æo dos mac address    
  Notes:   Carlos Daniel - 22/09/2015
------------------------------------------------------------------------------*/
IF NOT VALID-HANDLE(h-api023) THEN
    RUN esapi/esapi023.p PERSISTENT SET h-api023.

RUN piGeraMac IN h-api023 (INPUT INTEGER(fi-num-pedido:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                           INPUT-OUTPUT TABLE tt-mac-address,
                           INPUT-OUTPUT TABLE tt-erro).

IF VALID-HANDLE(h-api023) THEN
    DELETE PROCEDURE h-api023.

IF RETURN-VALUE NE 'OK' THEN DO:
    RUN cdp/cd0666.w( INPUT TABLE tt-erro).
    RETURN "NOK".
END.
IF CAN-FIND(FIRST tt-erro) THEN
    RUN cdp/cd0666.w( INPUT TABLE tt-erro).

RETURN "OK".
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geracaoOEM C-Win 
PROCEDURE geracaoOEM :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE h-esapi016 AS HANDLE NO-UNDO.

RUN esapi/esapi016.p PERSISTENT SET h-esapi016.

EMPTY TEMP-TABLE tt-erro-geral NO-ERROR.

RUN pi-seta-titulo IN h-acomp (INPUT "Efetivando cria‡Æo dos Seriais":U).

FOR EACH ttItem 
    WHERE ttitem.marcado = YES
    AND   ttitem.qt-pedido - ttitem.gerado-ns > 0:

    RUN pi-acompanhar IN h-acomp (INPUT "Item: " + ttItem.it-codigo).

    EMPTY TEMP-TABLE tt-lista-ns NO-ERROR.

    RUN piGeraNS IN h-esapi016 (INPUT ttItem.it-codigo,
                                INPUT 1,  /* Colocado um modelo com tipo 1 - N£mero de S‚rie para gerar os N£meros de S‚rie */
                                INPUT "",
                                INPUT (ttitem.qt-pedido - ttitem.gerado-ns),
                                INPUT 0,
                                INPUT INPUT FRAME fPage0 fi-num-pedido,
                                INPUT "",
                                INPUT 3,
                                INPUT NO,  /* Tratamento ASTEC */
                                INPUT "",
                                INPUT "",
                                OUTPUT TABLE tt-lista-ns).

    IF  RETURN-VALUE <> "OK":U THEN DO:
        EMPTY TEMP-TABLE tt-erro NO-ERROR.
        RUN piRetornaErros IN h-esapi016 (OUTPUT TABLE tt-erro).
        
        FOR EACH tt-erro:
            CREATE tt-erro-geral.
            BUFFER-COPY tt-erro TO tt-erro-geral.
        END. /* FOR EACH tt-erro: */
    END. /* IF  RETURN-VALUE <> "OK":U THEN DO: */
    
END. /* FOR EACH ttItem WHERE ttitem.marcado */

IF  CAN-FIND(FIRST tt-erro-geral) THEN DO:
    RUN cdp/cd0666.w (INPUT TABLE tt-erro-geral).
    DELETE PROCEDURE h-esapi016.
    RETURN "NOK":U.
END. /* IF  CAN-FIND(FIRST tt-erro-geral) */

DELETE PROCEDURE h-esapi016.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mostraMensagemPanico C-Win 
PROCEDURE mostraMensagemPanico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN ShowMessage (1, "Erro na execu‡Æo", 
                  "Ocorreu um erro durante a execu‡Æo de um procedimento " +
                  "remoto que impede que esta opera‡Æo continue.~n" +
                  "Por favor repita esta opera‡Æo mais tarde").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-ttitem C-Win 
PROCEDURE pi-carrega-ttitem :
/*------------------------------------------------------------------------------
  Purpose: Chama de forma persistent a proc para criar a ttItem e demais TTs
    Notes: Carlos Daniel - 21/09/2015
------------------------------------------------------------------------------*/
DEFINE VARIABLE i-emitente AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-nome     AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-email    AS CHARACTER NO-UNDO.

RUN esapi/esapi023.p PERSISTENT SET h-api023.

RUN piValidaPedidoComp IN h-api023(INPUT INTEGER(fi-num-pedido:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                   OUTPUT i-emitente,
                                   OUTPUT c-nome,
                                   OUTPUT c-email,
                                   OUTPUT TABLE tt-erro).

IF RETURN-VALUE NE 'OK' THEN DO:
    RUN cdp/cd0666.w( INPUT TABLE tt-erro).

    ASSIGN femitente:SCREEN-VALUE = "0"
           fnome    :SCREEN-VALUE = ""
           fi-email :SCREEN-VALUE = "".

    RETURN 'NOK'.
END.

ASSIGN femitente:SCREEN-VALUE = STRING(i-emitente)
       fnome    :SCREEN-VALUE = c-nome
       fi-email :SCREEN-VALUE = c-email WHEN fi-email :SCREEN-VALUE = "".

RUN piCarrega_ttItem IN h-api023 (INPUT INTEGER(fi-num-pedido:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                  OUTPUT TABLE ttItem,
                                  OUTPUT TABLE tt-mac-address,
                                  OUTPUT TABLE ttArq).

IF VALID-HANDLE(h-api023) THEN
    DELETE PROCEDURE h-api023.

{&OPEN-QUERY-BR1}

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera C-Win 
PROCEDURE pi-gera :
/*------------------------------------------------------------------------------
  Purpose: Executa rotinas de acordo com o que foi selecionado em tela    
  Notes:   Adaptado por Carlos Daniel - 22/09/2015
------------------------------------------------------------------------------*/
DEFINE VARIABLE i-emitente AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-nome     AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-email    AS CHARACTER NO-UNDO.

EMPTY TEMP-TABLE ttarq.
EMPTY TEMP-TABLE tt-mac-address.

IF fi-email:SCREEN-VALUE IN FRAME fPage0 = "" THEN DO:
    MESSAGE "Email deve ser informado. Favor verificar."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN "NOK".
END.
ELSE
    ASSIGN c-email = fi-email:SCREEN-VALUE.

IF NOT VALID-HANDLE(h-api023) THEN
    RUN esapi/esapi023.p PERSISTENT SET h-api023.

RUN piValidaPedidoComp IN h-api023(INPUT INTEGER(fi-num-pedido:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                   OUTPUT i-emitente,
                                   OUTPUT c-nome,
                                   OUTPUT c-email,
                                   OUTPUT TABLE tt-erro).

IF RETURN-VALUE NE 'OK' THEN DO:
    RUN cdp/cd0666.w( INPUT TABLE tt-erro).

    ASSIGN femitente:SCREEN-VALUE = "0"
           fnome    :SCREEN-VALUE = ""
           fi-email :SCREEN-VALUE = "".

    RETURN 'NOK'.
END.

FIND FIRST ttitem WHERE ttitem.marcado = YES NO-LOCK NO-ERROR.
/*IF  NOT AVAIL ttitem AND NOT tg-mac:CHECKED THEN DO:
    RUN utp/ut-msgs.p (INPUT "SHOW",
                       INPUT 17006,
                       INPUT "NÆo h  item selecionado.").
    RETURN "NOK".
END. /* IF  NOT AVAIL ttitem */
*/

IF NOT tg-num-serie:CHECKED IN FRAME fPage0 AND NOT tg-mac:CHECKED IN FRAME fPage0 THEN
    RETURN "NOK".

IF SESSION:SET-WAIT-STATE('GENERAL') THEN.

IF tg-mac:CHECKED IN FRAME fPage0 THEN DO:
    RUN preMac.
    IF RETURN-VALUE = "NOK" THEN
        RETURN "NOK".
END.

/* Gera Mac Address */
IF tg-mac:CHECKED IN FRAME fPage0 THEN DO:
    RUN geracaoMac.
    IF RETURN-VALUE = "NOK" THEN
        RETURN "NOK".
END.

/* Gera‡Æo de Num.S‚rie */
IF tg-num-serie:CHECKED IN FRAME fPage0 THEN DO:
    RUN geracaoOEM.
    IF RETURN-VALUE = "NOK" THEN
        RETURN "NOK".
END.

/* atualiza browse */
RUN pi-carrega-ttitem.

IF tg-mac:CHECKED IN FRAME fPage0 THEN
    RUN piEmail.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEmail C-Win 
PROCEDURE piEmail :
/*------------------------------------------------------------------------------
  Purpose: Adaptado rotina para chamar api de envio de email esapi0022    
  Notes:   Carlos Daniel - 22/09/2015
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-arq1   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-arq2   AS CHARACTER NO-UNDO.
DEFINE VARIABLE h-api022 AS HANDLE    NO-UNDO.

RUN pi-seta-titulo in h-acomp (input "Envio de Email"). 

ASSIGN c-dt-po    = STRING(TODAY,"99/99/99")
       cDestino   = REPLACE(INPUT FRAME fPage0 fi-email,' ','') + "," + cRemetente + "," + "grupo.inspchina@intelbras.com.br"
       cDescEmail = "Dear" + '~r~n' +
                    "How are you?" + '~r~n' +
                    "Please check attached file with new Serial n§ list for this item and PO (e-mail's title), also confirm if you have received it properly." + '~r~n' +
                    "Let us know if any doubt remains." + '~r~n' +
                    "As you know, you have to use in every product(item: 4xxxxxx) a Serial Number and PO Date(DD/MM/YY)= " + c-dt-po + '~r~n' +
                    "For instance:" + '~r~n' +
                    "   Part n§;   Serial n§; PO Date" + '~r~n' +
                    "   4xxxxxx;CKVA5100001M9;dd/mm/yy" + '~r~n' +
                    "I look for your confirmation." + '~r~n' +
                    "Kind regards".

ASSIGN cArqEmail = "".

ASSIGN cAssunto = "Intelbras Serial Number file for PO: " + STRING(INPUT fi-num-pedido) + 
                  " Supplier : " + fnome:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

IF tg-num-serie:CHECKED IN FRAME fPage0 THEN DO:
    RUN pi-acompanhar IN h-acomp ("Criando arquivo de n£meros de s‚rie.").

    FOR EACH ttarq BREAK BY ttarq.it-codigo BY ttarq.num-serie:
        
        IF FIRST-OF(ttarq.it-codigo) THEN DO:
            assign varquivo =  SESSION:TEMP-DIRECTORY + 
                               STRING(INPUT fi-num-pedido) + '-' + 
                               ttarq.it-codigo             + '-' +
                               STRING(YEAR(TODAY),"9999")  +
                               STRING(MONTH(TODAY),"99")   +
                               STRING(DAY(TODAY),"99")     +
                               STRING(TIME)                + ".txt".

            OUTPUT TO VALUE(varquivo).
            ASSIGN c-arq1 = varquivo.
        END. /* IF  FIRST-OF(ttarq.it-codigo) */

        PUT UNFORMATTED
            ttarq.it-codigo ";"
            ttarq.num-serie ";"
            c-dt-po         SKIP.
        
        IF  LAST-OF(ttarq.it-codigo) THEN DO:
            OUTPUT CLOSE.
            /* Para relacionar apenas os arquivos do pedido informado em tela */
            IF  varquivo MATCHES string("*" + STRING(INPUT fi-num-pedido) + "*") THEN DO:
                IF  cArqEmail = "" 
                THEN ASSIGN cArqEmail = varquivo.
                ELSE ASSIGN cArqEmail = cArqEmail + ',' + varquivo.
            END.
        END. /* IF  LAST-OF(ttarq.it-codigo) */
    END. /* FOR EACH ttarq NO-LOCK */

END.

IF tg-mac:CHECKED IN FRAME fPage0 THEN DO:
    RUN pi-acompanhar IN h-acomp ("Criando arquivo de Macs.").

    FOR EACH tt-mac-address
        WHERE tt-mac-address.impresso = TRUE
        BREAK BY tt-mac-address.it-codigo
              BY tt-mac-address.mac:

        IF FIRST-OF(tt-mac-address.it-codigo) THEN DO:
            ASSIGN varquivo =  SESSION:TEMP-DIRECTORY + 
                               STRING(INPUT fi-num-pedido) + '-' + 
                               tt-mac-address.it-codigo    + '-' +
                               STRING(YEAR(TODAY),"9999")  +
                               STRING(MONTH(TODAY),"99")   +
                               STRING(DAY(TODAY),"99")     +
                               STRING(TIME)                + "-MACaddress-" + ".txt".

            OUTPUT TO VALUE(varquivo).
            ASSIGN c-arq2 = varquivo.
        END.

        PUT UNFORMATTED
            tt-mac-address.it-codigo ";"
            tt-mac-address.mac ";"
            tt-mac-address.senha-adm ";"
            tt-mac-address.senha-wifi  SKIP.

        IF LAST-OF(tt-mac-address.it-codigo) THEN DO:
            OUTPUT CLOSE.
            IF  cArqEmail = "" THEN
                ASSIGN cArqEmail = varquivo.
            ELSE
                ASSIGN cArqEmail = cArqEmail + ',' + varquivo.
        END.
    END.    
END.

/*Chama api para tratamento e envio de email - Carlos Daniel - 21/09/2015*/
RUN esapi/esapi022.p PERSISTENT SET h-api022.
RUN piTrataEmail IN h-api022 (INPUT cDestino,
                              INPUT cAssunto,
                              INPUT cDescEmail,
                              INPUT cArqEmail,
                              INPUT "").
IF VALID-HANDLE(h-api022) THEN
    DELETE PROCEDURE h-api022.

IF SESSION:SET-WAIT-STATE('') THEN.

RUN ShowMessage (4, "N£meros de S‚rie gerados com sucesso.", "").

IF c-arq1 <> "" THEN
    OS-DELETE value(c-arq1).

IF c-arq2 <> "" THEN
    OS-DELETE value(c-arq2).
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE preMac C-Win 
PROCEDURE preMac :
/*------------------------------------------------------------------------------
  Purpose:    Transferido rotina de premac para api esapi023.p  
  Notes:      Carlos Daniel - 22/09/2015
------------------------------------------------------------------------------*/
EMPTY TEMP-TABLE tt-mac-address.
EMPTY TEMP-TABLE tt-erro.

IF NOT VALID-HANDLE(h-api023) THEN
    RUN esapi/esapi023.p PERSISTENT SET h-api023.

RUN piPreMac IN h-api023 (INPUT TABLE ttItem,
                          OUTPUT TABLE tt-mac-address,
                          OUTPUT TABLE tt-erro).

IF VALID-HANDLE(h-api023) THEN
    DELETE PROCEDURE h-api023.

IF RETURN-VALUE NE 'OK' THEN DO:
    RUN cdp/cd0666.w( INPUT TABLE tt-erro).
    RETURN "NOK".
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION conv-dec-to-hex C-Win 
FUNCTION conv-dec-to-hex RETURNS CHARACTER
  ( INPUT p-num-decimal AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-simbolos        AS CHARACTER   NO-UNDO
        FORMAT "x(1)":U
        EXTENT 16
        INITIAL ["0":U, "1":U, "2":U, "3":U, "4":U, "5":U, "6":U, "7":U, "8":U, "9":U, "A":U, "B":U, "C":U, "D":U, "E":U, "F":U].

    DEFINE VARIABLE c-val-hexadecimal AS CHARACTER   NO-UNDO INITIAL "":U.

    DEFINE VARIABLE i-quociente       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-resto           AS INTEGER     NO-UNDO INITIAL 0.

    ASSIGN i-quociente = p-num-decimal.

    REPEAT:
        ASSIGN i-resto           = i-quociente MODULO 16
               i-quociente       = TRUNCATE((i-quociente / 16), 0)
               c-val-hexadecimal = c-simbolos[(i-resto + 1)] + c-val-hexadecimal.

        IF i-quociente <= 0 THEN
            LEAVE.
    END.

    RETURN c-val-hexadecimal. /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION conv-hex-to-dec C-Win 
FUNCTION conv-hex-to-dec RETURNS INTEGER
  ( INPUT p-val-hexadecimal AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-cont        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-valor       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-num-decimal AS INTEGER     NO-UNDO.

    DO i-cont = 1 TO LENGTH(p-val-hexadecimal):
        CASE SUBSTRING(p-val-hexadecimal, i-cont, 1):
            WHEN "A":U THEN
                ASSIGN i-valor = 10.
            WHEN "B":U THEN
                ASSIGN i-valor = 11.
            WHEN "C":U THEN
                ASSIGN i-valor = 12.
            WHEN "D":U THEN
                ASSIGN i-valor = 13.
            WHEN "E":U THEN
                ASSIGN i-valor = 14.
            WHEN "F":U THEN
                ASSIGN i-valor = 15.
            OTHERWISE DO:
                ASSIGN i-valor = INTEGER(SUBSTRING(p-val-hexadecimal, i-cont, 1)) NO-ERROR.

                IF ERROR-STATUS:ERROR THEN
                    RETURN 0. /* Function return value. */
            END.
        END CASE.

        ASSIGN i-num-decimal = i-num-decimal + (i-valor * fator(LENGTH(p-val-hexadecimal) - i-cont)).

    END.

    RETURN i-num-decimal. /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fator C-Win 
FUNCTION fator RETURNS INTEGER
  ( INPUT p-fator AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-cont  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-valor AS INTEGER     NO-UNDO.

    ASSIGN i-valor = 1.

    IF p-fator > 0 THEN DO:
        DO i-cont = 1 TO p-fator:
            ASSIGN i-valor = i-valor * 16.
        END.
    END.

    RETURN i-valor. /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

