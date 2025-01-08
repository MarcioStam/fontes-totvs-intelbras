&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME esesb008e
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS esesb008e 
{include/i-prgvrs.i esesb008a 2.00.00.000}

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define variable wh-imprime as handle no-undo.

DEFINE INPUT  PARAM p-canal AS INTEGER NO-UNDO. 
DEFINE OUTPUT PARAM p-rowid AS ROWID NO-UNDO.           
DEFINE OUTPUT PARAM p-ok    AS LOGICAL INIT NO NO-UNDO. 

DEF VAR h-api-movto AS HANDLE NO-UNDO.

DEF VAR hprogramzoom AS HANDLE NO-UNDO.

DEF TEMP-TABLE tt-canal-categoria NO-UNDO
    FIELD canal               AS INTEGER
    FIELD unid-neg            AS CHAR FORMAT "!!!!"
    FIELD classificacao  AS CHAR FORMAT "X(15)"
    FIELD categoria      AS CHAR FORMAT "X(16)"
    FIELD guid-canal          AS CHAR FORMAT "X(15)"
        INDEX idx-canal-categoria IS PRIMARY UNIQUE
                canal     
                unid-neg         
                classificacao 
                categoria  
        INDEX idx-categoria-1
                unid-neg         
                classificacao 
                categoria .   

define temp-table resultado no-undo xml-node-name 'Resultado'
   field idm as int xml-node-type 'hidden'
   field Sucesso as log initial yes
   field CodigoErro as int
   field Mensagem as CHAR INITIAL "".


DEF VAR h-acomp AS HANDLE NO-UNDO.

def temp-table tt-erro-aux no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(200)"
    FIELD ajuda    AS CHAR FORMAT "X(250)".


DEF TEMP-TABLE tt-nova-cc LIKE int-cc-benef.

DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-implanta  AS LOGICAL.

DEF VAR c-unidade-antes AS CHAR NO-UNDO.
DEF VAR c-ano-antes AS CHAR NO-UNDO.
DEF VAR c-categoria-antes AS CHAR NO-UNDO.
DEF VAR c-apuracao-antes AS CHAR NO-UNDO.
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi-canal rs-tp-movto fi-unidade Cb-ano ~
cb-apuracao fi-vl-saldo fi-vl-empenhado fi-vl-saldo-transp ~
fi-dt-transacao-AP EDITOR-1 bt-ok bt-cancelar bt-fechar rt-button RECT-119 ~
RECT-124 RECT-125 RECT-126 RECT-127 
&Scoped-Define DISPLAYED-OBJECTS fi-canal fi-nome rs-tp-movto fi-unidade ~
Cb-ano cb-categoria cb-apuracao fi-dt-transacao fi-vl-saldo fi-vl-empenhado ~
fi-vl-saldo-transp fi-dt-transacao-AP EDITOR-1 fi-beneficio ~
fi-dt-vencimento fi-periodo-fim fi-periodo-ini fi-classificacao ~
fi-desc-unidade 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnBeneficio esesb008e 
FUNCTION fnBeneficio RETURNS CHARACTER
  ( INPUT p-tipo AS INTEGER /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnMovto esesb008e 
FUNCTION fnMovto RETURNS CHARACTER
  (INPUT p-movto AS INT /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnStatus esesb008e 
FUNCTION fnStatus RETURNS CHARACTER
  (INPUT p-status AS INT /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR esesb008e AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-cancelar 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-fechar AUTO-END-KEY 
     LABEL "&Fechar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&Salvar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE Cb-ano AS CHARACTER FORMAT "X(256)":U 
     LABEL "Ano Referància" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "2014","2015","2016","2017","2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030" 
     DROP-DOWN-LIST
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE cb-apuracao AS CHARACTER FORMAT "X(256)":U 
     LABEL "Per°odo apuraá∆o" 
     VIEW-AS COMBO-BOX INNER-LINES 4
     DROP-DOWN-LIST
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE cb-categoria AS CHARACTER FORMAT "X(256)":U INITIAL "OURO" 
     LABEL "Categoria" 
     VIEW-AS COMBO-BOX INNER-LINES 4
     LIST-ITEMS "Ouro","Prata","Bronze","Distribuidor,Revenda Solucoes,Provedores" 
     DROP-DOWN-LIST
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE EDITOR-1 AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 65 BY 2.46 NO-UNDO.

DEFINE VARIABLE fi-beneficio AS CHARACTER FORMAT "X(256)":U INITIAL "VMC" 
     LABEL "Benef°cio" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE fi-canal AS CHARACTER FORMAT "X(256)":U 
     LABEL "Canal" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fi-classificacao AS CHARACTER FORMAT "X(256)":U 
     LABEL "Classificaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-unidade AS CHARACTER FORMAT "X(6)":U 
     VIEW-AS FILL-IN 
     SIZE 37.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dt-transacao AS DATE FORMAT "99/99/9999":U 
     LABEL "Transaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dt-transacao-AP AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Transaá∆o Contas a Pagar" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dt-vencimento AS DATE FORMAT "99/99/9999":U 
     LABEL "Vencimento" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-periodo-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-periodo-ini AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-unidade AS CHARACTER FORMAT "X(6)":U 
     LABEL "Unid. Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vl-empenhado AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Vl Empenhado" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vl-saldo AS DECIMAL DECIMALS 4 FORMAT "->>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Saldo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vl-saldo-transp AS DECIMAL DECIMALS 4 FORMAT "->>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Saldo Transp VMC" 
     VIEW-AS FILL-IN 
     SIZE 11.86 BY .88 NO-UNDO.

DEFINE VARIABLE rs-tp-movto AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Despesa", 1,
"Provis∆o", 2
     SIZE 22 BY .75 TOOLTIP "Tipo de Movimento" NO-UNDO.

DEFINE RECTANGLE RECT-119
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 67 BY 3.33.

DEFINE RECTANGLE RECT-124
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 67 BY 1.67.

DEFINE RECTANGLE RECT-125
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 67 BY 2.83.

DEFINE RECTANGLE RECT-126
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 67 BY 5.

DEFINE RECTANGLE RECT-127
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 67 BY 3.46.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 67 BY 1.38
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     fi-canal AT ROW 2 COL 10 COLON-ALIGNED WIDGET-ID 96
     fi-nome AT ROW 2 COL 27.57 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     rs-tp-movto AT ROW 3.13 COL 45 NO-LABEL WIDGET-ID 98
     fi-unidade AT ROW 4.88 COL 19 COLON-ALIGNED WIDGET-ID 2
     Cb-ano AT ROW 6 COL 19 COLON-ALIGNED WIDGET-ID 94
     cb-categoria AT ROW 7.08 COL 19 COLON-ALIGNED HELP
          "Categoria do Canal na Unidade de Neg¢cio" WIDGET-ID 72
     cb-apuracao AT ROW 8.17 COL 19 COLON-ALIGNED WIDGET-ID 86
     fi-dt-transacao AT ROW 11.13 COL 12 COLON-ALIGNED WIDGET-ID 40
     fi-vl-saldo AT ROW 10.13 COL 54 COLON-ALIGNED WIDGET-ID 28
     fi-vl-empenhado AT ROW 11.13 COL 54 COLON-ALIGNED WIDGET-ID 60
     fi-vl-saldo-transp AT ROW 12.13 COL 54 COLON-ALIGNED HELP
          "Saldo transferido trimestre anterior" WIDGET-ID 34
     fi-dt-transacao-AP AT ROW 14.21 COL 26.14 COLON-ALIGNED HELP
          "Data de transaá∆o para movimentaá∆o do t°tulo" WIDGET-ID 68
     EDITOR-1 AT ROW 16.42 COL 2.86 NO-LABEL WIDGET-ID 56
     bt-ok AT ROW 19.63 COL 2.86
     bt-cancelar AT ROW 19.63 COL 13.72 WIDGET-ID 58
     bt-fechar AT ROW 19.58 COL 58.14
     fi-beneficio AT ROW 3 COL 18 COLON-ALIGNED WIDGET-ID 6
     fi-dt-vencimento AT ROW 12.13 COL 12 COLON-ALIGNED WIDGET-ID 42
     fi-periodo-fim AT ROW 8.25 COL 52.72 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     fi-periodo-ini AT ROW 8.25 COL 36 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     fi-classificacao AT ROW 10.13 COL 12 COLON-ALIGNED WIDGET-ID 8
     fi-desc-unidade AT ROW 4.88 COL 28.57 COLON-ALIGNED NO-LABEL WIDGET-ID 92
     "   Criaá∆o de Conta Corrente para o Canal" VIEW-AS TEXT
          SIZE 30 BY .54 AT ROW 1.17 COL 20.57 WIDGET-ID 66
     "  Hist¢rico/Motivo Operaá∆o:" VIEW-AS TEXT
          SIZE 20 BY .54 AT ROW 15.58 COL 3.29 WIDGET-ID 54
     "  Integraá∆o APB:" VIEW-AS TEXT
          SIZE 12.57 BY .54 AT ROW 13.42 COL 4.43 WIDGET-ID 70
     "atÇ" VIEW-AS TEXT
          SIZE 2.86 BY .54 AT ROW 8.38 COL 51.29 WIDGET-ID 76
     "Movimento:" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 3.17 COL 35.14 WIDGET-ID 102
     rt-button AT ROW 19.42 COL 2
     RECT-119 AT ROW 15.88 COL 2 WIDGET-ID 30
     RECT-124 AT ROW 13.75 COL 2 WIDGET-ID 64
     RECT-125 AT ROW 1.42 COL 2 WIDGET-ID 74
     RECT-126 AT ROW 4.58 COL 2 WIDGET-ID 78
     RECT-127 AT ROW 9.92 COL 2 WIDGET-ID 88
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1.04
         SIZE 69 BY 19.88
         FONT 1
         DEFAULT-BUTTON bt-ok.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW esesb008e ASSIGN
         HIDDEN             = YES
         TITLE              = "Novo registro de Conta Corrente para o Canal/Benef°cio"
         HEIGHT             = 19.92
         WIDTH              = 69
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 114.29
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB esesb008e 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-incsim.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW esesb008e
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME Custom                                                    */
ASSIGN 
       bt-cancelar:HIDDEN IN FRAME f-cad           = TRUE.

ASSIGN 
       bt-fechar:HIDDEN IN FRAME f-cad           = TRUE.

/* SETTINGS FOR COMBO-BOX cb-categoria IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-beneficio IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-classificacao IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-desc-unidade IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-dt-transacao IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-dt-vencimento IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-nome IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-periodo-fim IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-periodo-ini IN FRAME f-cad
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(esesb008e)
THEN esesb008e:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME esesb008e
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL esesb008e esesb008e
ON END-ERROR OF esesb008e /* Novo registro de Conta Corrente para o Canal/Benef°cio */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL esesb008e esesb008e
ON WINDOW-CLOSE OF esesb008e /* Novo registro de Conta Corrente para o Canal/Benef°cio */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar esesb008e
ON CHOOSE OF bt-cancelar IN FRAME f-cad /* Cancelar */
DO:
  
  RUN notify ('cancel-record':U).
  APPLY "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-fechar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-fechar esesb008e
ON CHOOSE OF bt-fechar IN FRAME f-cad /* Fechar */
DO:
  
  RUN notify ('cancel-record':U).
  APPLY "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok esesb008e
ON CHOOSE OF bt-ok IN FRAME f-cad /* Salvar */
DO:
    DEF VAR l-erro AS LOG NO-UNDO.

    EMPTY TEMP-TABLE tt-nova-cc.

    RUN pi-busca-canal.

    IF  RETURN-VALUE <> "OK" THEN
        RETURN NO-APPLY.

    FIND FIRST unid-negoc NO-LOCK
        WHERE unid-negoc.cod-unid-negoc = fi-unidade:SCREEN-VALUE IN FRAME f-cad NO-ERROR.
    
    IF  NOT AVAIL unid-negoc THEN DO:
        RUN utp/ut-msgs.p(INPUT "show",                                                                  
                          INPUT 17006,                                                                   
                          INPUT "Unidade de neg¢cio inv†lida.").
         RETURN NO-APPLY.                                                                                
    END.
   
   FIND FIRST int-emitente NO-LOCK
       WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.

   FIND FIRST int-class-canal NO-LOCK
       WHERE int-class-canal.codigo-classificacao = int-emitente.guid-class NO-ERROR.

   IF  NOT AVAIL int-class-canal THEN DO:
       RUN utp/ut-msgs.p(INPUT "show",                                                   
                         INPUT 17006,                                                    
                         INPUT "Classificacao do Canal Ç inv†lida.").
       RETURN NO-APPLY.                                                                 
   END.
   
    IF  NOT DATE(fi-dt-transacao-AP:SCREEN-VALUE IN FRAME f-cad) > 01/01/2014                
    OR  DATE(fi-dt-transacao-AP:SCREEN-VALUE IN FRAME f-cad) = ? THEN DO:                    
        RUN utp/ut-msgs.p(INPUT "show",                                                      
                          INPUT 17006,                                                       
                          INPUT "Data de transaá∆o APB Ç inv†lida. Informe uma data v†lida").
         RETURN NO-APPLY.                                                                    
    END.       

    IF  NOT DATE(fi-periodo-fim:SCREEN-VALUE IN FRAME f-cad) > 01/01/2014                
    OR  DATE(fi-periodo-fim:SCREEN-VALUE IN FRAME f-cad) = ? THEN DO:                    
        RUN utp/ut-msgs.p(INPUT "show",                                                      
                          INPUT 17006,                                                       
                          INPUT "Per°odo Inv†lido. Informe uma data v†lida").
         RETURN NO-APPLY.                                                                    
    END.       
    IF  NOT DATE(fi-dt-vencimento:SCREEN-VALUE IN FRAME f-cad) > 01/01/2014                
    OR  DATE(fi-dt-vencimento:SCREEN-VALUE IN FRAME f-cad) = ? THEN DO:                    
        RUN utp/ut-msgs.p(INPUT "show",                                                      
                          INPUT 17006,                                                       
                          INPUT "Data de Vencimento inv†lida.").
         RETURN NO-APPLY.                                                                    
    END.   

    /* Carrega a temp-table para efetuar a criaá∆o da nova conta corrente para o canal */
    CREATE tt-nova-cc.
    ASSIGN tt-nova-cc.tp-movto        = IF  rs-tp-movto:SCREEN-VALUE IN FRAME f-cad = "1" 
                                        THEN 2 /*DESPESA*/
                                        ELSE 1 /*PROVIS«O*/
           tt-nova-cc.tipo-beneficio  = 21 /*VMC*/
           tt-nova-cc.canal           = int(fi-canal:SCREEN-VALUE IN FRAME f-cad)
           tt-nova-cc.unid-neg        = fi-unidade:SCREEN-VALUE IN FRAME f-cad
           tt-nova-cc.dt-periodo-ini  = date(fi-periodo-ini:SCREEN-VALUE IN FRAME f-cad)
           tt-nova-cc.dt-periodo-fim  = date(fi-periodo-fim:SCREEN-VALUE IN FRAME f-cad)
           tt-nova-cc.categoria       = cb-categoria:SCREEN-VALUE IN FRAME f-cad
           tt-nova-cc.classificacao   = int-emitente.guid-class
           tt-nova-cc.dt-transacao    = TODAY
           tt-nova-cc.dt-vencimento   = date(fi-dt-vencimento:SCREEN-VALUE IN FRAME f-cad)
           tt-nova-cc.vl-saldo-ori    = dec(fi-vl-saldo:SCREEN-VALUE IN FRAME f-cad)
           tt-nova-cc.vl-saldo        = dec(fi-vl-saldo:SCREEN-VALUE IN FRAME f-cad)
           tt-nova-cc.vl-empenhado    = dec(fi-vl-empenhado:SCREEN-VALUE IN FRAME f-cad)
           /*tt-nova-cc.vl-saldo-transp = dec(fi-vl-saldo-transp:SCREEN-VALUE IN FRAME f-cad)*/
           tt-nova-cc.usuario         = c-seg-usuario
           tt-nova-cc.id-status       = 1. /* ATIVA */

    DEF VAR i    AS INTEGER NO-UNDO.

    IF  trim(editor-1:SCREEN-VALUE IN FRAME f-cad) = "" THEN DO:
        RUN utp/ut-msgs.p(INPUT "show",
                          INPUT 17006,
                          INPUT "Deve ser informado um descritivo hist¢rico para registrar a operaá∆o.").
         RETURN NO-APPLY.
    END.

    RUN utp/ut-msgs.p(INPUT "show":U,
                      INPUT 27100,
                      INPUT "Confirma criaá∆o da conta corrente de " + 
                            (IF  rs-tp-movto:SCREEN-VALUE IN FRAME f-cad = "1" THEN 
                                 "DESPESA"
                             ELSE
                                 "PROVIS«O") + " para o Canal?" + "~~" +
                            "Ser† Criado registro de conta corrente com saldo de R$ " + trim(fi-vl-saldo:SCREEN-VALUE IN FRAME f-cad) +
                            " atualizando Contas a Pagar. " ).
    IF  RETURN-VALUE = "no" THEN
        RETURN NO-APPLY.

    /* CHAMA API DE CRIAÄ«O DA SOLICITAÄ«O MANUAL  */
    EMPTY TEMP-TABLE tt-erro.
    EMPTY TEMP-TABLE tt-erro-aux.

    IF  NOT VALID-HANDLE(h-acomp) THEN RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    IF  VALID-HANDLE    (h-acomp) THEN RUN pi-inicializar IN h-acomp (INPUT "Solicitaá∆o Manual").
    RUN pi-acompanhar IN h-acomp ("Criando a conta corrente e atualizando contas a Pagar...").
    
    RUN pi-conta-corrente-manual IN h-api-movto (INPUT TABLE tt-nova-cc,
                                                 INPUT c-seg-usuario,
                                                 INPUT fi-dt-transacao-AP:SCREEN-VALUE IN FRAME f-cad,
                                                 INPUT editor-1:SCREEN-VALUE IN FRAME f-cad,
                                                 OUTPUT TABLE tt-erro).

    IF  RETURN-VALUE <> "OK" THEN l-erro = YES.

    FOR EACH tt-erro:
        ASSIGN i = i + 10.
        CREATE tt-erro-aux.
        ASSIGN tt-erro-aux.i-sequen = i
               tt-erro-aux.cd-erro  = tt-erro.codigo
               tt-erro-aux.mensagem = tt-erro.mensagem + CHR(10) + "Detalhe: " + tt-erro.ajuda.
    END.

    IF  CAN-FIND (FIRST tt-erro) THEN DO:
        RUN cdp/cd0666.w (INPUT TABLE tt-erro-aux).
        IF VALID-HANDLE(h-acomp) THEN RUN pi-finalizar IN h-acomp.

       RETURN NO-APPLY.
    END.
    IF  l-erro THEN DO:
        RUN utp/ut-msgs.p(INPUT "show",
                          INPUT 17006,
                          INPUT "Erro ao processar a criaá∆o da conta corrente." + "~~" +
                                "N∆o foi poss°vel efetuar a solicitaá∆o.").
        IF VALID-HANDLE(h-acomp) THEN RUN pi-finalizar IN h-acomp.
        RETURN NO-APPLY.
    END.

    /* RETORNAR O ROWID DA CONTA CORRENTE CRIADA PARA REPOSICIONAR NO BROWSER DO ESESB008 */
    FIND FIRST int-cc-benef NO-LOCK
        WHERE int-cc-benef.tp-movto       =  tt-nova-cc.tp-movto      
          AND int-cc-benef.tipo-beneficio =  tt-nova-cc.tipo-beneficio
          AND int-cc-benef.canal          =  tt-nova-cc.canal         
          AND int-cc-benef.unid-neg       =  tt-nova-cc.unid-neg      
          AND int-cc-benef.dt-periodo-ini =  tt-nova-cc.dt-periodo-ini
          AND int-cc-benef.dt-periodo-fim =  tt-nova-cc.dt-periodo-fim NO-ERROR.
    IF  AVAIL int-cc-benef THEN 
        ASSIGN p-rowid = rowid(int-cc-benef).
    ELSE DO:
        RUN utp/ut-msgs.p(INPUT "show",
                          INPUT 17006,
                          INPUT "N∆o foi poss°vel completar a inclus∆o da conta corrente" + "~~" +
                                "N∆o foi poss°vel efetuar a solicitaá∆o").
        RETURN NO-APPLY.
    END.

    IF VALID-HANDLE(h-acomp) THEN RUN pi-finalizar IN h-acomp.

    RUN utp/ut-msgs.p(INPUT "show",
                      INPUT 15825,
                      INPUT "Criaá∆o da conta corrente realizado com sucesso!" + "~~" +
                            "Saldo j† atualizado em tela." + CHR(10) +
                            "Para consultar movimentaá‰es, basta acessar a pasta <Movimentaá∆o>." ).

    ASSIGN p-ok = YES.

    apply "close":U to this-procedure.



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Cb-ano
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Cb-ano esesb008e
ON ENTRY OF Cb-ano IN FRAME f-cad /* Ano Referància */
DO:
   c-ano-antes = SELF:SCREEN-VALUE.
   /*APPLY "LEAVE" TO fi-unidade IN FRAME f-cad.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Cb-ano esesb008e
ON LEAVE OF Cb-ano IN FRAME f-cad /* Ano Referància */
DO:
    IF  self:SCREEN-VALUE <> c-ano-antes THEN DO:
    
        RUN pi-limpa-campos-data.
        c-ano-antes = self:SCREEN-VALUE.

        RUN pi-limpa-campos-data.

        RUN pi-carrega-cb-apuracao.
        ASSIGN cb-apuracao:SCREEN-VALUE = "".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-apuracao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-apuracao esesb008e
ON ENTRY OF cb-apuracao IN FRAME f-cad /* Per°odo apuraá∆o */
DO:
   c-apuracao-antes = SELF:SCREEN-VALUE.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-apuracao esesb008e
ON VALUE-CHANGED OF cb-apuracao IN FRAME f-cad /* Per°odo apuraá∆o */
DO:

  IF  c-apuracao-antes <> SELF:SCREEN-VALUE  THEN DO:
      DEF VAR c-combo AS CHAR NO-UNDO.
      DEF VAR c-ano   AS CHAR NO-UNDO.
    
      ASSIGN c-ano = cb-ano:SCREEN-VALUE IN FRAME f-cad.
    
      CASE substr(SELF:SCREEN-VALUE, 1,5):
    
          WHEN "30/09" THEN DO:
    
              IF  cb-categoria:SCREEN-VALUE = "PRATA"
              OR  cb-categoria:SCREEN-VALUE = "BRONZE" THEN
                  ASSIGN fi-periodo-ini:SCREEN-VALUE   IN FRAME f-cad = "01/01/" + c-ano
                         fi-periodo-FIM:SCREEN-VALUE   IN FRAME f-cad = "30/09/" + c-ano
                         fi-dt-vencimento:SCREEN-VALUE IN FRAME f-cad = "31/12/" + c-ano.
              ELSE
                  ASSIGN fi-periodo-ini:SCREEN-VALUE   IN FRAME f-cad = "01/07/" + c-ano
                         fi-periodo-FIM:SCREEN-VALUE   IN FRAME f-cad = "30/09/" + c-ano
                         fi-dt-vencimento:SCREEN-VALUE IN FRAME f-cad = STRING((DATE(fi-periodo-FIM:SCREEN-VALUE IN FRAME f-cad) + 20)).
          END.
    
          WHEN  "31/03" THEN
              ASSIGN fi-periodo-ini:SCREEN-VALUE   IN FRAME f-cad = "01/01/" + c-ano
                     fi-periodo-FIM:SCREEN-VALUE   IN FRAME f-cad = SELF:SCREEN-VALUE 
                     fi-dt-vencimento:SCREEN-VALUE IN FRAME f-cad = STRING((DATE(fi-periodo-FIM:SCREEN-VALUE IN FRAME f-cad) + 20)).
          
          WHEN  "30/06" THEN
              ASSIGN fi-periodo-ini:SCREEN-VALUE   IN FRAME f-cad = "01/04/" + c-ano
                     fi-periodo-FIM:SCREEN-VALUE   IN FRAME f-cad = "30/06/" + c-ano
                     fi-dt-vencimento:SCREEN-VALUE IN FRAME f-cad = STRING((DATE(fi-periodo-FIM:SCREEN-VALUE IN FRAME f-cad) + 20)).
          
          WHEN  "31/12" THEN DO:
              IF  cb-categoria:SCREEN-VALUE = "PRATA"
              OR  cb-categoria:SCREEN-VALUE = "BRONZE" THEN
                  ASSIGN fi-periodo-ini:SCREEN-VALUE   IN FRAME f-cad = "01/10/" + c-ano
                         fi-periodo-FIM:SCREEN-VALUE   IN FRAME f-cad = "31/12/" + c-ano
                         fi-dt-vencimento:SCREEN-VALUE IN FRAME f-cad = "31/03/" + STRING(INT(c-ano) + 1).
              ELSE
                  ASSIGN fi-periodo-ini:SCREEN-VALUE   IN FRAME f-cad = "01/10/" + c-ano
                         fi-periodo-FIM:SCREEN-VALUE   IN FRAME f-cad = "31/12/" + c-ano
                         fi-dt-vencimento:SCREEN-VALUE IN FRAME f-cad = STRING((DATE(fi-periodo-FIM:SCREEN-VALUE IN FRAME f-cad) + 20)).
          END.
      END.
    
       fi-dt-transacao:SCREEN-VALUE IN FRAME f-cad = STRING(TODAY).  
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-categoria
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-categoria esesb008e
ON ENTRY OF cb-categoria IN FRAME f-cad /* Categoria */
DO:
  ASSIGN c-categoria-antes = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-categoria esesb008e
ON LEAVE OF cb-categoria IN FRAME f-cad /* Categoria */
DO:
      IF  self:SCREEN-VALUE <> c-categoria-antes THEN DO WITH FRAME f-cad:
          
          c-categoria-antes = self:SCREEN-VALUE.
          RUN pi-limpa-campos-data.

          RUN pi-carrega-cb-apuracao.
          ASSIGN cb-apuracao:SCREEN-VALUE = "".

      END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-categoria esesb008e
ON VALUE-CHANGED OF cb-categoria IN FRAME f-cad /* Categoria */
DO:


/*     DEF VAR c-combo AS CHAR NO-UNDO.                                    */
/*     DEF VAR c-ano   AS CHAR NO-UNDO.                                    */
/*                                                                         */
/*     ASSIGN c-ano = cb-ano:SCREEN-VALUE IN FRAME f-cad.                  */
/*                                                                         */
/*     CASE SELF:SCREEN-VALUE:                                             */
/*                                                                         */
/*         WHEN "PRATA" OR WHEN "BRONZE" THEN DO:                          */
/*             ASSIGN c-combo = "30/09/" + c-ano + "," + "31/12/" + c-ano  */
/*                    cb-apuracao:LIST-ITEMS = c-combo.                    */
/*         END.                                                            */
/*                                                                         */
/*         OTHERWISE DO:                                                   */
/*             ASSIGN c-combo = "31/03/" + c-ano + "," +                   */
/*                              "30/06/" + c-ano + "," +                   */
/*                              "30/09/" + c-ano + "," +                   */
/*                              "31/12/" + c-ano                           */
/*                    cb-apuracao:LIST-ITEMS = c-combo.                    */
/*         END.                                                            */
/*                                                                         */
/*     END.                                                                */
/*                                                                         */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-canal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-canal esesb008e
ON F5 OF fi-canal IN FRAME f-cad /* Canal */
DO:
      {include/zoomvar.i &prog-zoom="adzoom/z01ad098.w"
                         &campo="fi-canal"
                         &campozoom="cod-emitente"
                         &frame="f-cad"
                         &campo2="fi-nome"
                         &campozoom2="nome-emit"
                         &frame2="f-cad"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-canal esesb008e
ON LEAVE OF fi-canal IN FRAME f-cad /* Canal */
DO:
    RUN pi-busca-canal.

/*     IF  RETURN-VALUE = "OK" THEN DO:                                                        */
/*         EMPTY TEMP-TABLE tt-canal-categoria.                                                */
/*         RUN esp/esb/importa-csv-categorias.p (INPUT INT(SELF:SCREEN-VALUE IN FRAME F-CAD),  */
/*                                               INPUT /*p-guid-canal*/ "",                    */
/*                                               OUTPUT TABLE resultado,                       */
/*                                               OUTPUT TABLE tt-canal-categoria).             */
/*     END.                                                                                    */

    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-canal esesb008e
ON MOUSE-SELECT-DBLCLICK OF fi-canal IN FRAME f-cad /* Canal */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-canal esesb008e
ON RETURN OF fi-canal IN FRAME f-cad /* Canal */
DO:
    RUN pi-busca-canal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-unidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-unidade esesb008e
ON ENTRY OF fi-unidade IN FRAME f-cad /* Unid. Neg¢cio */
DO:
  ASSIGN c-unidade-antes = self:SCREEN-VALUE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-unidade esesb008e
ON F5 OF fi-unidade IN FRAME f-cad /* Unid. Neg¢cio */
DO:
     {method/ZoomFields.i
          &ProgramZoom="inzoom/z01in745.w"
          &FieldZoom1="cod-unid-negoc"
          &FieldScreen1="fi-unidade"
          &Frame1="f-cad"
          &FieldZoom2="des-unid-negoc"
          &FieldScreen2="fi-desc-unidade"
          &Frame2="f-cad"
          &EnableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-unidade esesb008e
ON LEAVE OF fi-unidade IN FRAME f-cad /* Unid. Neg¢cio */
DO:
  
    FIND FIRST unid-negoc NO-LOCK
        WHERE unid-negoc.cod-unid-negoc = SELF:SCREEN-VALUE NO-ERROR.

    IF  AVAIL unid-negoc THEN
        ASSIGN fi-desc-unidade:SCREEN-VALUE = unid-negoc.des-unid-negoc.
    ELSE
        ASSIGN fi-desc-unidade:SCREEN-VALUE = "".
/*                                                                                              */
/*     FIND FIRST tt-canal-categoria                                                            */
/*         WHERE tt-canal-categoria.unid-neg = unid-negoc.cod-unid-negoc NO-ERROR.              */
/*                                                                                              */
/*     IF  AVAIL tt-canal-categoria THEN DO WITH FRAME f-cad:                                   */
/*         ASSIGN cb-categoria:SCREEN-VALUE = tt-canal-categoria.categoria.                     */
/*         ASSIGN fi-classificacao:SCREEN-VALUE = tt-canal-categoria.classificacao.             */
/*         APPLY "VALUE-CHANGED" TO cb-categoria.                                               */
/*         cb-categoria:SENSITIVE = NO.                                                         */
/*         ASSIGN SELF:SCREEN-VALUE = UPPER(SELF:SCREEN-VALUE).                                 */
/*     END.                                                                                     */
/*     ELSE DO:                                                                                 */
/*         RUN utp/ut-msgs.p(INPUT "show",                                                      */
/*                           INPUT 17006,                                                       */
/*                           INPUT "N∆o foi poss°vel localizar a Categoria do canal no CRM.").  */
/*     END.                                                                                     */

    IF  SELF:SCREEN-VALUE <> c-unidade-antes THEN DO:
    
        RUN pi-limpa-campos-data.
        RUN pi-carrega-cb-apuracao.

    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-unidade esesb008e
ON MOUSE-SELECT-DBLCLICK OF fi-unidade IN FRAME f-cad /* Unid. Neg¢cio */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-tp-movto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-tp-movto esesb008e
ON VALUE-CHANGED OF rs-tp-movto IN FRAME f-cad
DO:
  IF  SELF:SCREEN-VALUE = "1" THEN
      ASSIGN fi-vl-empenhado:SENSITIVE    = YES
             fi-vl-saldo-transp:SENSITIVE = YES.
  ELSE 
      ASSIGN fi-vl-empenhado:SENSITIVE    = NO
             fi-vl-saldo-transp:SENSITIVE = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK esesb008e 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects esesb008e  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available esesb008e  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI esesb008e  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(esesb008e)
  THEN DELETE WIDGET esesb008e.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI esesb008e  _DEFAULT-ENABLE
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
  DISPLAY fi-canal fi-nome rs-tp-movto fi-unidade Cb-ano cb-categoria 
          cb-apuracao fi-dt-transacao fi-vl-saldo fi-vl-empenhado 
          fi-vl-saldo-transp fi-dt-transacao-AP EDITOR-1 fi-beneficio 
          fi-dt-vencimento fi-periodo-fim fi-periodo-ini fi-classificacao 
          fi-desc-unidade 
      WITH FRAME f-cad IN WINDOW esesb008e.
  ENABLE fi-canal rs-tp-movto fi-unidade Cb-ano cb-apuracao fi-vl-saldo 
         fi-vl-empenhado fi-vl-saldo-transp fi-dt-transacao-AP EDITOR-1 bt-ok 
         bt-cancelar bt-fechar rt-button RECT-119 RECT-124 RECT-125 RECT-126 
         RECT-127 
      WITH FRAME f-cad IN WINDOW esesb008e.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW esesb008e.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy esesb008e 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF  VALID-HANDLE(h-api-movto) THEN
      RUN pi-destroy IN h-api-movto.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display esesb008e 
PROCEDURE local-display :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        
      DISP editor-1 WITH FRAME f-cad.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit esesb008e 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize esesb008e 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/win-size.i}
    
    {utp/ut9000.i "esesb008e" "2.00.00.000"}
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    IF  NOT VALID-HANDLE(h-api-movto) THEN
        RUN esp/esb/esesbapi003-movtos.p PERSISTENT SET h-api-movto.

    DEF VAR p-guid-canal AS CHAR NO-UNDO.

    IF  p-canal <> 0 THEN DO WITH FRAME f-cad:
        ASSIGN fi-canal:SENSITIVE     = NO
               fi-canal:SCREEN-VALUE  = STRING(p-canal).
        APPLY "LEAVE" TO fi-canal.
    END.
        
    ASSIGN cb-ano:SCREEN-VALUE IN FRAME f-cad = STRING(YEAR(TODAY))
           fi-dt-transacao-AP:SCREEN-VALUE IN FRAME f-cad = STRING(TODAY).

    RUN dispatch  IN this-procedure ('enable-fields':U).
    
    RUN dispatch  IN this-procedure ('display-fields':U).
    
    {include/i-inifld.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-canal esesb008e 
PROCEDURE pi-busca-canal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   FIND FIRST emitente 
       WHERE emitente.cod-emitente = int(fi-canal:SCREEN-VALUE IN FRAME f-cad) NO-LOCK NO-ERROR.

   IF  NOT AVAIL emitente THEN DO:
       FIND FIRST emitente
           WHERE emitente.nome-abrev = fi-canal:SCREEN-VALUE IN FRAME f-cad NO-LOCK NO-ERROR.

       IF  NOT AVAIL emitente THEN DO:
           FIND FIRST emitente
               WHERE emitente.cgc = fi-canal:SCREEN-VALUE IN FRAME f-cad NO-LOCK NO-ERROR.
           IF  NOT AVAIL emitente  THEN DO:
               RUN utp/ut-msgs.p(input "show":U, 
                                 input 17006,
                                 input "Cliente inv†lido/inexistente..").
               RETURN "NOK".
           END.
       END.
   END.

   FIND FIRST int-emitente NO-LOCK
       WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.

   FIND FIRST int-class-canal NO-LOCK
       WHERE int-class-canal.codigo-classificacao = int-emitente.guid-class NO-ERROR.

   IF  AVAIL int-class-canal THEN
      ASSIGN fi-classificacao:SCREEN-VALUE = int-class-canal.nome.

   ASSIGN fi-nome:SCREEN-VALUE IN FRAME f-cad = emitente.nome-emit.
            
   RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-cb-apuracao esesb008e 
PROCEDURE pi-carrega-cb-apuracao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR c-combo AS CHAR NO-UNDO.
    DEF VAR c-ano   AS CHAR NO-UNDO.

    ASSIGN c-ano = cb-ano:SCREEN-VALUE IN FRAME f-cad.

    DO WITH FRAME f-cad:
        CASE cb-categoria:SCREEN-VALUE:
    
            WHEN "PRATA" OR WHEN "BRONZE" THEN DO:
                ASSIGN c-combo = "30/09/" + c-ano + "," + "31/12/" + c-ano
                       cb-apuracao:LIST-ITEMS = c-combo.
            END.
    
            OTHERWISE DO:
                ASSIGN c-combo = "31/03/" + c-ano + "," +
                                 "30/06/" + c-ano + "," +
                                 "30/09/" + c-ano + "," +
                                 "31/12/" + c-ano
                       cb-apuracao:LIST-ITEMS = c-combo.
            END.
    
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-limpa-campos-data esesb008e 
PROCEDURE pi-limpa-campos-data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME f-cad:
        ASSIGN fi-periodo-ini:SCREEN-VALUE   = ""
               fi-periodo-fim:SCREEN-VALUE   = ""
               fi-dt-vencimento:SCREEN-VALUE = "".
    END.
           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records esesb008e  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed esesb008e 
PROCEDURE state-changed :
/*:T -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnBeneficio esesb008e 
FUNCTION fnBeneficio RETURNS CHARACTER
  ( INPUT p-tipo AS INTEGER /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  CASE p-tipo:
      WHEN 21 THEN RETURN "V M C".
      WHEN 37 THEN RETURN "Rebate".
      WHEN 22 THEN RETURN "Stock Rotation".
      WHEN 66 THEN RETURN "Rebate P¢s-Venda".
  END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnMovto esesb008e 
FUNCTION fnMovto RETURNS CHARACTER
  (INPUT p-movto AS INT /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  CASE p-movto:
      WHEN 1 THEN RETURN "PROV".
      WHEN 2 THEN RETURN "DESP".
  END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnStatus esesb008e 
FUNCTION fnStatus RETURNS CHARACTER
  (INPUT p-status AS INT /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  CASE p-status:
      WHEN 1 THEN RETURN "Bloqueado".
      WHEN 2 THEN RETURN "Liberado".
      WHEN 3 THEN RETURN "Finalizado".
      WHEN 4 THEN RETURN "Cancelado".
  END CASE.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

