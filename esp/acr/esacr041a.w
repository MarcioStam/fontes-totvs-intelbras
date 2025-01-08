&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE INPUT  PARAMETER rInt-ocor AS ROWID       NO-UNDO.


DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER FORMAT "x(12)" NO-UNDO.

DEFINE VARIABLE i-identific AS INTEGER FORMAT "99" NO-UNDO.

DEF BUFFER bf-emitente                 FOR emitente.
DEF BUFFER b-int-emitente-supcard-ocor FOR int-emitente-supcard-ocor.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 rtToolBar c-cod-parcela ~
rs-titulo rs-cliente de-val-origin-tit-acr tg-emergencial ~
rs-motivo-bloqueio de-val-limite-sugerido de-val-lancamento dt-novo-vencto ~
i-dias-prorrog ed-obs btSalvar btCancelar text-acao text-complemento ~
text-obs 
&Scoped-Define DISPLAYED-OBJECTS c-cod-estab c-cgc-cliente ~
c-cod-espec-docto c-nome-cliente c-cod-ser-docto c-cod-tit-acr ~
c-cod-parcela de-val-sdo-tit-acr rs-titulo rs-cliente de-val-origin-tit-acr ~
de-vl-tot-nota dat-vencto-origin-tit-acr dat-vencto-tit-acr tg-emergencial ~
rs-motivo-bloqueio de-val-limite-sugerido de-val-lancamento dt-novo-vencto ~
i-dias-prorrog ed-obs text-acao text-complemento text-obs 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancelar 
     LABEL "&Cancelar" 
     SIZE 10 BY 1 TOOLTIP "Cancelar".

DEFINE BUTTON btSalvar 
     LABEL "&Salvar" 
     SIZE 10 BY 1 TOOLTIP "Salvar".

DEFINE VARIABLE ed-obs AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 76.86 BY 3.54 NO-UNDO.

DEFINE VARIABLE c-cgc-cliente AS CHARACTER FORMAT "x(16)" 
     LABEL "Cliente":R9 
     VIEW-AS FILL-IN 
     SIZE 16.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-espec-docto AS CHARACTER FORMAT "x(3)" 
     LABEL "EspÇcie" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-estab AS CHARACTER FORMAT "x(3)" 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-parcela AS CHARACTER FORMAT "x(2)" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-ser-docto AS CHARACTER FORMAT "x(3)" 
     LABEL "SÇrie" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-tit-acr AS CHARACTER FORMAT "x(10)" 
     LABEL "T°tulo" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-cliente AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 54.72 BY .88 NO-UNDO.

DEFINE VARIABLE dat-vencto-origin-tit-acr AS DATE FORMAT "99/99/9999" 
     LABEL "Vencto Original" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE dat-vencto-tit-acr AS DATE FORMAT "99/99/9999" 
     LABEL "Vencimento" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-lancamento AS DECIMAL FORMAT "->>>,>>>,>>9.99" INITIAL 0 
     LABEL "Valor Bonificaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-limite-sugerido AS DECIMAL FORMAT ">>>,>>>,>>9.99" INITIAL 0 
     LABEL "Limite Sugerido" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-origin-tit-acr AS DECIMAL FORMAT ">>>,>>>,>>9.99" INITIAL 0 
     LABEL "Val Orig" 
     VIEW-AS FILL-IN 
     SIZE 14.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-sdo-tit-acr AS DECIMAL FORMAT ">>>,>>>,>>9.99" INITIAL 0 
     LABEL "Saldo" 
     VIEW-AS FILL-IN 
     SIZE 14.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-tot-nota AS DECIMAL FORMAT ">>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Val Total NF" 
     VIEW-AS FILL-IN 
     SIZE 14.86 BY .88 NO-UNDO.

DEFINE VARIABLE dt-novo-vencto AS DATE FORMAT "99/99/9999":U 
     LABEL "Nova Data Vencimento" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 TOOLTIP "Nova data de vencimento" NO-UNDO.

DEFINE VARIABLE i-dias-prorrog AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Dias Prorrogaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 6.57 BY .88 NO-UNDO.

DEFINE VARIABLE text-acao AS CHARACTER FORMAT "X(10)":U INITIAL "Aá∆o" 
      VIEW-AS TEXT 
     SIZE 4 BY .67 NO-UNDO.

DEFINE VARIABLE text-complemento AS CHARACTER FORMAT "X(15)":U INITIAL "Complemento" 
      VIEW-AS TEXT 
     SIZE 9.72 BY .67 NO-UNDO.

DEFINE VARIABLE text-obs AS CHARACTER FORMAT "X(10)":U INITIAL "Observaá∆o" 
      VIEW-AS TEXT 
     SIZE 9.72 BY .67 NO-UNDO.

DEFINE VARIABLE rs-cliente AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Alterar Limite de CrÇdito", 1,
"Bloquear Cliente", 2
     SIZE 38 BY .71 NO-UNDO.

DEFINE VARIABLE rs-motivo-bloqueio AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Inatividade", 1,
"Sem Foráa de Venda", 2,
"Exclus∆o Inatividade", 3
     SIZE 56.43 BY .71 NO-UNDO.

DEFINE VARIABLE rs-titulo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Prorrogar Vencimento do T°tulo", 1,
"Bonificar T°tulo", 2,
"Devoluá∆o", 3
     SIZE 50 BY .71 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79.72 BY 3.75.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79.72 BY 7.46.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 81 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tg-emergencial AS LOGICAL INITIAL no 
     LABEL "Emergàncial?" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .71 TOOLTIP "ê uma situaá∆o emergencial?" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     c-cod-estab AT ROW 1.79 COL 5.72 COLON-ALIGNED HELP
          "Estabelecimento do T°tulo do EMS 5" WIDGET-ID 106
     c-cgc-cliente AT ROW 1.79 COL 6.29 COLON-ALIGNED HELP
          "CGC ou CIC do cliente/fornecedor" WIDGET-ID 120
     c-cod-espec-docto AT ROW 1.79 COL 18.86 COLON-ALIGNED HELP
          "EspÇcio do T°tulo do EMS 5" WIDGET-ID 104
     c-nome-cliente AT ROW 1.79 COL 23.14 COLON-ALIGNED HELP
          "Nome Completo do Emitente" NO-LABEL WIDGET-ID 122
     c-cod-ser-docto AT ROW 1.79 COL 28.14 COLON-ALIGNED HELP
          "SÇrie do T°tulo do EMS 5" WIDGET-ID 110
     c-cod-tit-acr AT ROW 1.79 COL 38.14 COLON-ALIGNED HELP
          "N£mero do T°tulo do EMS 5" WIDGET-ID 112
     c-cod-parcela AT ROW 1.79 COL 53.72 COLON-ALIGNED HELP
          "N£mero da Parcela do T°tulo do EMS 5" NO-LABEL WIDGET-ID 108
     de-val-sdo-tit-acr AT ROW 1.79 COL 62.86 COLON-ALIGNED HELP
          "Valor Saldo Contas a Receber" WIDGET-ID 114
     rs-titulo AT ROW 3.04 COL 6.86 NO-LABEL WIDGET-ID 116
     rs-cliente AT ROW 3.04 COL 12.86 NO-LABEL WIDGET-ID 2
     de-val-origin-tit-acr AT ROW 3.04 COL 62.86 COLON-ALIGNED HELP
          "Valor Original Contas a Receber" WIDGET-ID 114
     de-vl-tot-nota AT ROW 4.04 COL 62.86 COLON-ALIGNED WIDGET-ID 156
     dat-vencto-origin-tit-acr AT ROW 6.04 COL 43.43 COLON-ALIGNED HELP
          "Data de Vencimento Original do T°tulo" WIDGET-ID 152
     dat-vencto-tit-acr AT ROW 6.04 COL 66 COLON-ALIGNED HELP
          "Data Vencimento T°tulo" WIDGET-ID 154
     tg-emergencial AT ROW 6.46 COL 3.43 HELP
          "ê necess†rio que o arquivo seja enviado de forma emergencial?" WIDGET-ID 136
     rs-motivo-bloqueio AT ROW 7.5 COL 11.14 NO-LABEL WIDGET-ID 148
     de-val-limite-sugerido AT ROW 7.5 COL 12.29 COLON-ALIGNED WIDGET-ID 96
     de-val-lancamento AT ROW 7.5 COL 13.72 COLON-ALIGNED HELP
          "Valor do Lanáamento" WIDGET-ID 146
     dt-novo-vencto AT ROW 7.5 COL 18 COLON-ALIGNED HELP
          "Nova data de vencto, para calculo dos dias de prorrogaá∆o." WIDGET-ID 138
     i-dias-prorrog AT ROW 7.5 COL 51.29 COLON-ALIGNED HELP
          "Dias de prorrogaá∆o do T°tulo do EMS 5" WIDGET-ID 78
     ed-obs AT ROW 9.42 COL 3.14 NO-LABEL WIDGET-ID 72
     btSalvar AT ROW 13.58 COL 2 WIDGET-ID 26
     btCancelar AT ROW 13.58 COL 12.29 WIDGET-ID 94
     text-acao AT ROW 1 COL 2.43 NO-LABEL WIDGET-ID 66
     text-complemento AT ROW 5.46 COL 2.43 NO-LABEL WIDGET-ID 70
     text-obs AT ROW 8.75 COL 3.14 NO-LABEL WIDGET-ID 74
     RECT-1 AT ROW 1.33 COL 1.57 WIDGET-ID 64
     RECT-2 AT ROW 5.79 COL 1.57 WIDGET-ID 68
     rtToolBar AT ROW 13.38 COL 1 WIDGET-ID 34
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81 BY 13.83
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Incluir Pendàncias"
         HEIGHT             = 13.83
         WIDTH              = 81
         MAX-HEIGHT         = 13.83
         MAX-WIDTH          = 81.86
         VIRTUAL-HEIGHT     = 13.83
         VIRTUAL-WIDTH      = 81.86
         MAX-BUTTON         = no
         RESIZE             = no
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



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN c-cgc-cliente IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cod-espec-docto IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cod-estab IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cod-ser-docto IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cod-tit-acr IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-cliente IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dat-vencto-origin-tit-acr IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dat-vencto-tit-acr IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-val-sdo-tit-acr IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-tot-nota IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN text-acao IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN text-complemento IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN text-obs IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Incluir Pendàncias */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Incluir Pendàncias */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancelar C-Win
ON CHOOSE OF btCancelar IN FRAME DEFAULT-FRAME /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSalvar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSalvar C-Win
ON CHOOSE OF btSalvar IN FRAME DEFAULT-FRAME /* Salvar */
DO:
    RUN pi-salvar IN THIS-PROCEDURE.
    IF  RETURN-VALUE = "OK":U THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-parcela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-parcela C-Win
ON LEAVE OF c-cod-parcela IN FRAME DEFAULT-FRAME
DO:
    /* Busca o t°tulo de acordo com a transaá∆o (Estab NF + SÇrie NF + Num NF) */
    IF  INPUT FRAME default-frame c-cod-estab   <> "" AND
        INPUT FRAME default-frame c-cod-tit-acr <> "" THEN DO:
        FIND FIRST tit_acr NO-LOCK
            WHERE  tit_acr.cod_estab       = INPUT FRAME default-frame c-cod-estab
            AND    tit_acr.cod_espec_docto = INPUT FRAME default-frame c-cod-espec-docto
            AND    tit_acr.cod_ser_docto   = INPUT FRAME default-frame c-cod-ser-docto
            AND    tit_acr.cod_tit_acr     = INPUT FRAME default-frame c-cod-tit-acr
            AND    tit_acr.cod_parcela     = INPUT FRAME default-frame c-cod-parcela NO-ERROR.
        IF  AVAIL  tit_acr THEN
            ASSIGN de-val-sdo-tit-acr        = tit_acr.val_sdo_tit_acr
                   de-val-origin-tit-acr     = tit_acr.val_origin_tit_acr
                   dat-vencto-origin-tit-acr = tit_acr.dat_vencto_origin_tit_ac
                   dat-vencto-tit-acr        = tit_acr.dat_vencto_tit_acr.
        ELSE DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Parcela do t°tulo n∆o localizada.":U).
    
            ASSIGN de-val-sdo-tit-acr    = 0
                   de-val-origin-tit-acr = 0.
        END.
    
        DISP dat-vencto-origin-tit-acr
             dat-vencto-tit-acr
             de-val-sdo-tit-acr
             de-val-origin-tit-acr
            WITH FRAME default-frame.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dt-novo-vencto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dt-novo-vencto C-Win
ON LEAVE OF dt-novo-vencto IN FRAME DEFAULT-FRAME /* Nova Data Vencimento */
DO:
    ASSIGN INPUT FRAME default-frame dat-vencto-tit-acr
           INPUT FRAME default-frame dt-novo-vencto.

    IF  dt-novo-vencto <> ? THEN DO:
        ASSIGN i-dias-prorrog = dt-novo-vencto - dat-vencto-tit-acr.

        DISP i-dias-prorrog WITH FRAME default-frame.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-cliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-cliente C-Win
ON VALUE-CHANGED OF rs-cliente IN FRAME DEFAULT-FRAME
DO:
    IF  INPUT FRAME default-frame rs-cliente = 1 THEN
        ASSIGN de-val-limite-sugerido:VISIBLE IN FRAME default-frame = YES
               rs-motivo-bloqueio:VISIBLE     IN FRAME default-frame = NO.
    ELSE
        ASSIGN de-val-limite-sugerido:VISIBLE IN FRAME default-frame = NO
               rs-motivo-bloqueio:VISIBLE     IN FRAME default-frame = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-titulo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-titulo C-Win
ON VALUE-CHANGED OF rs-titulo IN FRAME DEFAULT-FRAME
DO:
    CASE INPUT FRAME default-frame rs-titulo:
        WHEN 1 THEN
            ASSIGN dt-novo-vencto:VISIBLE    IN FRAME default-frame = YES
                   i-dias-prorrog:VISIBLE    IN FRAME default-frame = YES
                   de-val-lancamento:VISIBLE IN FRAME default-frame = NO
                   de-val-lancamento:LABEL   IN FRAME default-frame = "Valor":U.
        WHEN 2 THEN
            ASSIGN dt-novo-vencto:VISIBLE         IN FRAME default-frame = NO
                   i-dias-prorrog:VISIBLE         IN FRAME default-frame = NO
                   de-val-lancamento:VISIBLE      IN FRAME default-frame = YES
                   de-val-lancamento:LABEL        IN FRAME default-frame = "Valor Bonificaá∆o":U
                   de-val-lancamento:SCREEN-VALUE IN FRAME default-frame = "0,00":U.
        WHEN 3 THEN
            ASSIGN dt-novo-vencto:VISIBLE         IN FRAME default-frame = NO
                   i-dias-prorrog:VISIBLE         IN FRAME default-frame = NO
                   de-val-lancamento:VISIBLE      IN FRAME default-frame = YES
                   de-val-lancamento:LABEL        IN FRAME default-frame = "Valor Devoluá∆o":U
                   de-val-lancamento:SCREEN-VALUE IN FRAME default-frame = de-val-sdo-tit-acr:SCREEN-VALUE IN FRAME default-frame.
    END CASE.
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
    RUN afterInitializeInterface.
    IF NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface C-Win 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST int-emitente-supcard-ocor NO-LOCK
        WHERE ROWID(int-emitente-supcard-ocor) = rInt-ocor NO-ERROR.
    IF  NOT AVAIL int-emitente-supcard-ocor THEN
        RETURN "NOK":U.

    IF  int-emitente-supcard-ocor.ind-ocor = "8.1" THEN DO:
        blk_emit:
        FOR EACH  emitente NO-LOCK
            WHERE emitente.cgc BEGINS int-emitente-supcard-ocor.raiz-cnpj:
            FIND FIRST int-emitente NO-LOCK
                WHERE  int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
            IF  AVAIL  int-emitente AND int-emitente.id-ativo THEN DO:
                ASSIGN c-cgc-cliente  = emitente.cgc
                       c-nome-cliente = emitente.nome-emit.

                LEAVE blk_emit.
            END.
        END.

        /* Se n∆o encontrou cliente ativo, apresenta mensagem */
        IF  c-cgc-cliente = "" THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Clientes inativos para a raiz de CNPJ.~~N∆o existe cliente ativo para esta raiz de CNPJ.").
        END.

        DISP c-cgc-cliente
             c-nome-cliente
            WITH FRAME default-frame.

        ASSIGN rs-titulo:VISIBLE                 IN FRAME default-frame = NO
               dt-novo-vencto:VISIBLE            IN FRAME default-frame = NO
               i-dias-prorrog:VISIBLE            IN FRAME default-frame = NO
               de-val-lancamento:VISIBLE         IN FRAME default-frame = NO
               c-cod-estab:VISIBLE               IN FRAME default-frame = NO
               c-cod-espec-docto:VISIBLE         IN FRAME default-frame = NO
               c-cod-ser-docto:VISIBLE           IN FRAME default-frame = NO
               c-cod-tit-acr:VISIBLE             IN FRAME default-frame = NO
               c-cod-parcela:VISIBLE             IN FRAME default-frame = NO
               de-val-sdo-tit-acr:VISIBLE        IN FRAME default-frame = NO
               de-val-origin-tit-acr:VISIBLE     IN FRAME default-frame = NO
               dat-vencto-origin-tit-acr:VISIBLE IN FRAME default-frame = NO
               dat-vencto-tit-acr:VISIBLE        IN FRAME default-frame = NO
               de-vl-tot-nota:VISIBLE            IN FRAME default-frame = NO.

        APPLY "value-changed":U TO rs-cliente IN FRAME default-frame.
    END.

    IF  int-emitente-supcard-ocor.ind-ocor = "8.2" THEN DO:
        /* Busca o cliente da nota fiscal em quest∆o */
        FIND FIRST nota-fiscal NO-LOCK
            WHERE  nota-fiscal.cod-estabel = STRING(INT(SUBSTRING(int-emitente-supcard-ocor.num-transac,1,4)))
            AND    nota-fiscal.serie       = STRING(INT(SUBSTRING(int-emitente-supcard-ocor.num-transac,5,3)))
            AND    nota-fiscal.nr-nota-fis = SUBSTRING(int-emitente-supcard-ocor.num-transac,8,7) NO-ERROR.
        IF  AVAIL  nota-fiscal THEN DO:
            FIND FIRST emitente NO-LOCK
                WHERE  emitente.nome-abrev = nota-fiscal.nome-ab-cli NO-ERROR.
            IF  AVAIL  emitente THEN
                ASSIGN c-cgc-cliente  = emitente.cgc
                       c-nome-cliente = emitente.nome-emit
                       de-vl-tot-nota = nota-fiscal.vl-tot-nota.

            DISP c-cgc-cliente
                 c-nome-cliente
                 de-vl-tot-nota
                WITH FRAME default-frame.
        END.
        ELSE DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "Nota Fiscal n∆o localizada!~~A nota fiscal n∆o foi localizada para a transaá∆o: ":U + int-emitente-supcard-ocor.num-transac + ".").
        END.

        /* Busca o t°tulo de acordo com a transaá∆o (Estab NF + SÇrie NF + Num NF) */
        FIND FIRST tit_acr NO-LOCK
            WHERE  tit_acr.cod_estab     = STRING(INT(SUBSTRING(int-emitente-supcard-ocor.num-transac,1,4)))
            AND    tit_acr.cod_ser_docto = STRING(INT(SUBSTRING(int-emitente-supcard-ocor.num-transac,5,3)))
            AND    tit_acr.cod_tit_acr   = SUBSTRING(int-emitente-supcard-ocor.num-transac,8,7) 
            AND    tit_acr.ind_tip_espec_docto = "Normal" NO-ERROR.
        IF  AVAIL  tit_acr THEN DO:
            ASSIGN c-cod-estab               = tit_acr.cod_estab
                   c-cod-espec-docto         = tit_acr.cod_espec_docto
                   c-cod-ser-docto           = tit_acr.cod_ser_docto
                   c-cod-tit-acr             = tit_acr.cod_tit_acr
                   c-cod-parcela             = tit_acr.cod_parcela
                   de-val-sdo-tit-acr        = tit_acr.val_sdo_tit_acr
                   de-val-origin-tit-acr     = tit_acr.val_origin_tit_acr
                   dat-vencto-origin-tit-acr = tit_acr.dat_vencto_origin_tit_ac
                   dat-vencto-tit-acr        = tit_acr.dat_vencto_tit_acr.
        END.
        ELSE DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 17006,
                               INPUT "T°tulo n∆o localizado!~~O t°tulo n∆o foi localizado para a transaá∆o: ":U + int-emitente-supcard-ocor.num-transac + ".").
        END.

        DISP c-cod-estab
             c-cod-espec-docto
             c-cod-ser-docto
             c-cod-tit-acr
             c-cod-parcela
             de-val-sdo-tit-acr
             de-val-origin-tit-acr
             dat-vencto-origin-tit-acr
             dat-vencto-tit-acr
            WITH FRAME default-frame.

        ASSIGN rs-cliente:VISIBLE             IN FRAME default-frame = NO
               de-val-limite-sugerido:VISIBLE IN FRAME default-frame = NO
               rs-motivo-bloqueio:VISIBLE     IN FRAME default-frame = NO
               c-cgc-cliente:VISIBLE          IN FRAME default-frame = NO
               c-nome-cliente:VISIBLE         IN FRAME default-frame = NO.

        APPLY "value-changed":U TO rs-titulo IN FRAME default-frame.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  DISPLAY c-cod-estab c-cgc-cliente c-cod-espec-docto c-nome-cliente 
          c-cod-ser-docto c-cod-tit-acr c-cod-parcela de-val-sdo-tit-acr 
          rs-titulo rs-cliente de-val-origin-tit-acr de-vl-tot-nota 
          dat-vencto-origin-tit-acr dat-vencto-tit-acr tg-emergencial 
          rs-motivo-bloqueio de-val-limite-sugerido de-val-lancamento 
          dt-novo-vencto i-dias-prorrog ed-obs text-acao text-complemento 
          text-obs 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE RECT-1 RECT-2 rtToolBar c-cod-parcela rs-titulo rs-cliente 
         de-val-origin-tit-acr tg-emergencial rs-motivo-bloqueio 
         de-val-limite-sugerido de-val-lancamento dt-novo-vencto i-dias-prorrog 
         ed-obs btSalvar btCancelar text-acao text-complemento text-obs 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salvar C-Win 
PROCEDURE pi-salvar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Valida se a observaá∆o foi informada */
    IF  LENGTH(INPUT FRAME default-frame ed-obs) < 4 THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Observaá∆o n∆o informada.~~A observaá∆o deve ser informada.":U).

        APPLY "ENTRY":U TO ed-obs IN FRAME default-frame.
        RETURN NO-APPLY.
    END.

    
    IF  int-emitente-supcard-ocor.ind-ocor = "8.1" THEN DO:
        
        IF  INPUT FRAME default-frame rs-cliente = 1 THEN DO:

            FIND FIRST b-int-emitente-supcard-ocor
                WHERE b-int-emitente-supcard-ocor.raiz-cnpj = int-emitente-supcard-ocor.raiz-cnpj
                AND   b-int-emitente-supcard-ocor.ind-ocor  = "8.5" 
                AND   b-int-emitente-supcard-ocor.obs MATCHES "*Atendid*" NO-LOCK NO-ERROR.
            
            IF  AVAIL b-int-emitente-supcard-ocor THEN                        
                ASSIGN i-identific = 99 /* Solicitaá∆o de Limite de CrÇdito */.
            ELSE DO:
                FIND FIRST b-int-emitente-supcard-ocor
                    WHERE b-int-emitente-supcard-ocor.raiz-cnpj = int-emitente-supcard-ocor.raiz-cnpj
                    AND   b-int-emitente-supcard-ocor.ind-ocor  = "8.3" 
                    AND   b-int-emitente-supcard-ocor.obs MATCHES "*Aprovad*" NO-LOCK NO-ERROR.

                IF  AVAIL b-int-emitente-supcard-ocor THEN
                    ASSIGN i-identific = 99 /* Solicitaá∆o de Limite de CrÇdito */.
                ELSE DO:
                    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                       INPUT 27100,
                                       INPUT "O cliente n∆o possui cart∆o cadastrado, confirma geraá∆o de pendància de envio de novo cliente ?":U).
    
                    IF RETURN-VALUE = "YES":U THEN
                        ASSIGN i-identific = 98 /* Solicitaá∆o de Novo Cliente */.
                    ELSE
                        RETURN NO-APPLY.
                END.
            END.
        END.
        ELSE
            ASSIGN i-identific = 19. /* Bloqueio de Cliente */
    END.
    
    IF  int-emitente-supcard-ocor.ind-ocor = "8.2" THEN DO:
        CASE INPUT FRAME default-frame rs-titulo:
            WHEN 1 THEN
                ASSIGN i-identific = 02.
            WHEN 2 THEN
                ASSIGN i-identific = 11.
            WHEN 3 THEN DO:
                IF INPUT FRAME default-frame de-val-lancamento = INPUT FRAME default-frame de-vl-tot-nota THEN DO:
                    ASSIGN i-identific = 03.
                END.
                ELSE DO:
                    IF INPUT FRAME default-frame de-val-lancamento > INPUT FRAME default-frame de-val-origin-tit-acr THEN DO:
                        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                           INPUT 17006,
                                           INPUT "Valor Devoluá∆o maior que o Valor Original do T°tulo!~~Informe o Valor Devoluá∆o corretamente!":U).
    
                        APPLY "ENTRY":U TO de-val-lancamento IN FRAME default-frame.

                        RETURN NO-APPLY.
                    END.
                    ELSE
                        ASSIGN i-identific = 10.
                END.
            END.
        END CASE.
    END.

    
    /* Quando Ç Bloqueio de Cliente, deve criar uma pendància para a Matriz e Filiais do cliente, que tenham a mesma raiz de CNPJ */
    IF  i-identific = 19 /* Bloqueio de Cliente */ THEN DO:
        FIND FIRST emitente NO-LOCK
            WHERE  emitente.cgc = INPUT FRAME default-frame c-cgc-cliente NO-ERROR.
        IF  AVAIL  emitente THEN DO:
            FOR EACH bf-emitente NO-LOCK
                WHERE bf-emitente.nome-matriz = emitente.nome-matriz:
                IF  SUBSTRING(emitente.cgc,1,8) <> SUBSTRING(bf-emitente.cgc,1,8) THEN
                    NEXT.

                CREATE int-pendencias-supcard.
                ASSIGN int-pendencias-supcard.cod-usuar           = c-seg-usuario
                       int-pendencias-supcard.cnpj-cliente        = bf-emitente.cgc
                       int-pendencias-supcard.dat-criacao         = TODAY
                       int-pendencias-supcard.identific           = i-identific
                       int-pendencias-supcard.log-manual          = YES
                       int-pendencias-supcard.log-emergencial     = INPUT FRAME default-frame tg-emergencial
                       int-pendencias-supcard.tipo-bloqueio       = INPUT FRAME default-frame rs-motivo-bloqueio - 1
                       int-pendencias-supcard.dat-bloqueio        = TODAY
                       int-pendencias-supcard.val-lancamento      = INPUT FRAME default-frame de-val-lancamento
                       int-pendencias-supcard.val-limite-sugerido = INPUT FRAME default-frame de-val-limite-sugerido
                       int-pendencias-supcard.obs                 = INPUT FRAME default-frame ed-obs.
            END.
        END.
    END.
    ELSE DO:
        CREATE int-pendencias-supcard.
        ASSIGN int-pendencias-supcard.cod-usuar           = c-seg-usuario
               int-pendencias-supcard.cnpj-cliente        = INPUT FRAME default-frame c-cgc-cliente
               int-pendencias-supcard.cod-estab           = INPUT FRAME default-frame c-cod-estab
               int-pendencias-supcard.cod-espec-docto     = INPUT FRAME default-frame c-cod-espec-docto
               int-pendencias-supcard.cod-parcela         = INPUT FRAME default-frame c-cod-parcela
               int-pendencias-supcard.cod-ser-docto       = INPUT FRAME default-frame c-cod-ser-docto
               int-pendencias-supcard.cod-tit-acr         = INPUT FRAME default-frame c-cod-tit-acr
               int-pendencias-supcard.dat-criacao         = TODAY
               int-pendencias-supcard.identific           = i-identific
               int-pendencias-supcard.log-manual          = YES
               int-pendencias-supcard.log-emergencial     = INPUT FRAME default-frame tg-emergencial
               int-pendencias-supcard.tipo-bloqueio       = ?
               int-pendencias-supcard.dias-prorrog        = INPUT FRAME default-frame i-dias-prorrog
               int-pendencias-supcard.val-lancamento      = INPUT FRAME default-frame de-val-lancamento
               int-pendencias-supcard.val-limite-sugerido = INPUT FRAME default-frame de-val-limite-sugerido
               int-pendencias-supcard.obs                 = INPUT FRAME default-frame ed-obs.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

