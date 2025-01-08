&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME esesb008c
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS esesb008c 
{include/i-prgvrs.i esesb008C 2.00.00.000}


CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define variable wh-imprime as handle no-undo.


DEFINE INPUT  PARAM p-rowid AS ROWID NO-UNDO.
DEFINE OUTPUT PARAM p-ok    AS LOGICAL INIT NO NO-UNDO.

DEF VAR h-acomp AS HANDLE NO-UNDO.

def temp-table tt-erro-aux no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(200)"
    FIELD ajuda    AS CHAR FORMAT "X(250)".

DEF VAR h-api-movto AS HANDLE NO-UNDO.

DEF TEMP-TABLE tt-nova-cc LIKE int-cc-benef.

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
&Scoped-Define ENABLED-OBJECTS fi-dt-transacao-AP fi-novo-saldo EDITOR-1 ~
bt-ok bt-cancelar bt-fechar rt-button RECT-10 RECT-119 RECT-124 
&Scoped-Define DISPLAYED-OBJECTS fi-tp-movto fi-dt-transacao fi-beneficio ~
fi-dt-vencimento fi-periodo-fim fi-periodo-ini fi-vl-saldo fi-unidade ~
fi-vl-empenhado fi-classificacao fi-vl-saldo-ant fi-categoria ~
fi-vl-saldo-transp fi-dt-transacao-AP fi-novo-saldo EDITOR-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnBeneficio esesb008c 
FUNCTION fnBeneficio RETURNS CHARACTER
  ( INPUT p-tipo AS INTEGER /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnMovto esesb008c 
FUNCTION fnMovto RETURNS CHARACTER
  (INPUT p-movto AS INT /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnStatus esesb008c 
FUNCTION fnStatus RETURNS CHARACTER
  (INPUT p-status AS INT /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR esesb008c AS WIDGET-HANDLE NO-UNDO.

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

DEFINE VARIABLE EDITOR-1 AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 65 BY 4.21 NO-UNDO.

DEFINE VARIABLE fi-beneficio AS CHARACTER FORMAT "X(256)":U 
     LABEL "Benef¡cio" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-categoria AS CHARACTER FORMAT "X(256)":U 
     LABEL "Categoria" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE fi-classificacao AS CHARACTER FORMAT "X(256)":U 
     LABEL "Classifica‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 24 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dt-transacao AS DATE FORMAT "99/99/9999":U 
     LABEL "Transa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dt-transacao-AP AS DATE FORMAT "99/99/9999":U 
     LABEL "Transa‡Æo AP" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dt-vencimento AS DATE FORMAT "99/99/9999":U 
     LABEL "Vencimento" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-novo-saldo AS DECIMAL DECIMALS 4 FORMAT ">>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Ajustar saldo para" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fi-periodo-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-periodo-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Per¡odo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tp-movto AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo Movto" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-unidade AS CHARACTER FORMAT "X(256)":U 
     LABEL "Unid. Neg¢cio:" 
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

DEFINE VARIABLE fi-vl-saldo-ant AS DECIMAL DECIMALS 4 FORMAT "->>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Saldo Anterior" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vl-saldo-transp AS DECIMAL DECIMALS 4 FORMAT "->>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Saldo Transp VMC" 
     VIEW-AS FILL-IN 
     SIZE 11.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 67.29 BY 6.5.

DEFINE RECTANGLE RECT-119
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 67.29 BY 5.13.

DEFINE RECTANGLE RECT-124
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 67 BY 2.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 68.57 BY 1.38
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     fi-tp-movto AT ROW 1.83 COL 12 COLON-ALIGNED WIDGET-ID 20
     fi-dt-transacao AT ROW 1.83 COL 53.72 COLON-ALIGNED WIDGET-ID 40
     fi-beneficio AT ROW 2.83 COL 12 COLON-ALIGNED WIDGET-ID 6
     fi-dt-vencimento AT ROW 2.83 COL 53.72 COLON-ALIGNED WIDGET-ID 42
     fi-periodo-fim AT ROW 3.79 COL 24.29 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     fi-periodo-ini AT ROW 3.83 COL 12 COLON-ALIGNED WIDGET-ID 12
     fi-vl-saldo AT ROW 3.83 COL 53.72 COLON-ALIGNED WIDGET-ID 28
     fi-unidade AT ROW 4.83 COL 12 COLON-ALIGNED WIDGET-ID 2
     fi-vl-empenhado AT ROW 4.83 COL 53.72 COLON-ALIGNED WIDGET-ID 60
     fi-classificacao AT ROW 5.83 COL 12 COLON-ALIGNED WIDGET-ID 8
     fi-vl-saldo-ant AT ROW 5.83 COL 53.72 COLON-ALIGNED WIDGET-ID 32
     fi-categoria AT ROW 6.83 COL 12 COLON-ALIGNED WIDGET-ID 10
     fi-vl-saldo-transp AT ROW 6.83 COL 53.86 COLON-ALIGNED WIDGET-ID 34
     fi-dt-transacao-AP AT ROW 9.04 COL 13 COLON-ALIGNED HELP
          "Data de transa‡Æo para movimenta‡Æo do t¡tulo" WIDGET-ID 68
     fi-novo-saldo AT ROW 9.04 COL 48.57 COLON-ALIGNED HELP
          "Valor do novo saldo da conta corrente" WIDGET-ID 62
     EDITOR-1 AT ROW 11.5 COL 3 NO-LABEL WIDGET-ID 56
     bt-ok AT ROW 16.58 COL 1.86
     bt-cancelar AT ROW 16.58 COL 12.72 WIDGET-ID 58
     bt-fechar AT ROW 16.54 COL 58.14
     "Detalhes Conta Corrente:" VIEW-AS TEXT
          SIZE 18 BY .54 AT ROW 1.13 COL 3 WIDGET-ID 66
     " Hist¢rico/Motivo Opera‡Æo:" VIEW-AS TEXT
          SIZE 20 BY .54 AT ROW 10.75 COL 3 WIDGET-ID 54
     "Dados para Integra‡Æo" VIEW-AS TEXT
          SIZE 16 BY .54 AT ROW 8.17 COL 3.86 WIDGET-ID 70
     rt-button AT ROW 16.38 COL 1
     RECT-10 AT ROW 1.5 COL 1.72
     RECT-119 AT ROW 10.96 COL 1.72 WIDGET-ID 30
     RECT-124 AT ROW 8.5 COL 2 WIDGET-ID 64
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1.04
         SIZE 68.72 BY 16.96
         FONT 1
         DEFAULT-BUTTON bt-cancelar.


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
  CREATE WINDOW esesb008c ASSIGN
         HIDDEN             = YES
         TITLE              = "Ajuste de Movimento"
         HEIGHT             = 17
         WIDTH              = 68.43
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB esesb008c 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-incsim.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW esesb008c
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME Custom                                                    */
ASSIGN 
       bt-cancelar:HIDDEN IN FRAME f-cad           = TRUE.

ASSIGN 
       bt-fechar:HIDDEN IN FRAME f-cad           = TRUE.

/* SETTINGS FOR FILL-IN fi-beneficio IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-categoria IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-classificacao IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-dt-transacao IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-dt-vencimento IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-periodo-fim IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-periodo-ini IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-tp-movto IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-unidade IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-vl-empenhado IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-vl-saldo IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-vl-saldo-ant IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-vl-saldo-transp IN FRAME f-cad
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(esesb008c)
THEN esesb008c:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME esesb008c
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL esesb008c esesb008c
ON END-ERROR OF esesb008c /* Ajuste de Movimento */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL esesb008c esesb008c
ON WINDOW-CLOSE OF esesb008c /* Ajuste de Movimento */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar esesb008c
ON CHOOSE OF bt-cancelar IN FRAME f-cad /* Cancelar */
DO:
  
  RUN notify ('cancel-record':U).
  APPLY "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-fechar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-fechar esesb008c
ON CHOOSE OF bt-fechar IN FRAME f-cad /* Fechar */
DO:
  
  RUN notify ('cancel-record':U).
  APPLY "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok esesb008c
ON CHOOSE OF bt-ok IN FRAME f-cad /* Salvar */
DO:

    DEF VAR i      AS INTEGER NO-UNDO.
    DEF VAR l-erro AS LOG     NO-UNDO.
    
    IF  trim(editor-1:SCREEN-VALUE IN FRAME f-cad) = "" THEN DO:
        RUN utp/ut-msgs.p(INPUT "show",
                          INPUT 17006,
                          INPUT "Deve ser informado um descritivo hist¢rico para registrar a opera‡Æo.").
         RETURN NO-APPLY.
    END.

    IF  NOT DATE(fi-dt-transacao-AP:SCREEN-VALUE IN FRAME f-cad) > 01/01/2014
    OR  DATE(fi-dt-transacao-AP:SCREEN-VALUE IN FRAME f-cad) = ? THEN DO:
        RUN utp/ut-msgs.p(INPUT "show",
                          INPUT 17006,
                          INPUT "Data de transa‡Æo APB ‚ inv lida. Informe uma data v lida").
         RETURN NO-APPLY.
    END.

    RUN utp/ut-msgs.p(INPUT "show":U,
                      INPUT 27100,
                      INPUT "Confirma Ajuste para a conta corrente?" + "~~" + 
                            "Ser  alterado o saldo de R$ " + trim(fi-vl-saldo:SCREEN-VALUE IN FRAME f-cad) + 
                            " para R$ " +  trim(fi-novo-saldo:SCREEN-VALUE IN FRAME f-cad) ).
    IF  RETURN-VALUE = "no" THEN 
        RETURN NO-APPLY.

    /* CHAMA API DE TRANSFERÒNCIA */
    EMPTY TEMP-TABLE tt-erro.
    EMPTY TEMP-TABLE tt-erro-aux.
    
    IF  NOT VALID-HANDLE(h-acomp) THEN                                  
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.                      
                                                                    
    IF  VALID-HANDLE(h-acomp) THEN                                      
        RUN pi-inicializar IN h-acomp (INPUT "Ajuste Manual de saldo").

    RUN pi-acompanhar IN h-acomp ("Atualizando Ajuste de saldo no Contas a Pagar..").
    RUN pi-ajuste IN h-api-movto  (INPUT rowid(int-cc-benef),
                                   INPUT DEC(fi-novo-saldo:SCREEN-VALUE IN FRAME f-cad),
                                   INPUT c-seg-usuario,
                                   INPUT editor-1:SCREEN-VALUE IN FRAME f-cad,
                                   INPUT date(fi-dt-transacao-AP:SCREEN-VALUE IN FRAME f-cad),
                                   OUTPUT TABLE tt-erro).
    
    IF  RETURN-VALUE <> "OK" THEN l-erro = YES.
            
    FOR EACH tt-erro:
        ASSIGN i = i + 10.
        CREATE tt-erro-aux.   
        ASSIGN tt-erro-aux.i-sequen = i
               tt-erro-aux.cd-erro  = tt-erro.codigo
               tt-erro-aux.mensagem = tt-erro.mensagem + CHR(13) + "Detalhes: " + tt-erro.ajuda.
    END.
    
    IF  CAN-FIND (FIRST tt-erro) THEN DO:
        IF VALID-HANDLE(h-acomp) THEN 
            RUN pi-finalizar IN h-acomp. 

        RUN cdp/cd0666.w (INPUT TABLE tt-erro-aux).
        RETURN NO-APPLY.
    END.

    IF  l-erro THEN DO:
        RUN utp/ut-msgs.p(INPUT "show",
                          INPUT 17006,
                          INPUT "Erro na execu‡Æo da integra‡Æo com APB." + "~~" + 
                                "NÆo foi poss¡vel efetuar o ajuste.").
        IF  VALID-HANDLE(h-acomp) THEN 
            RUN pi-finalizar IN h-acomp. 
        RETURN NO-APPLY.
    END.

    IF VALID-HANDLE(h-acomp) THEN RUN pi-finalizar IN h-acomp. 

    RUN utp/ut-msgs.p(INPUT "show",
                      INPUT 15825,
                      INPUT "Ajuste de saldo realizado com sucesso!" + "~~" +
                            "Novo saldo j  est  atualizado em tela." + CHR(10) +
                            "Para consultar movimenta‡äes, basta acessar a pasta <Movimenta‡Æo>." ).

    ASSIGN p-ok = YES.

    apply "close":U to this-procedure.
    
    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK esesb008c 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects esesb008c  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available esesb008c  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI esesb008c  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(esesb008c)
  THEN DELETE WIDGET esesb008c.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI esesb008c  _DEFAULT-ENABLE
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
  DISPLAY fi-tp-movto fi-dt-transacao fi-beneficio fi-dt-vencimento 
          fi-periodo-fim fi-periodo-ini fi-vl-saldo fi-unidade fi-vl-empenhado 
          fi-classificacao fi-vl-saldo-ant fi-categoria fi-vl-saldo-transp 
          fi-dt-transacao-AP fi-novo-saldo EDITOR-1 
      WITH FRAME f-cad IN WINDOW esesb008c.
  ENABLE fi-dt-transacao-AP fi-novo-saldo EDITOR-1 bt-ok bt-cancelar bt-fechar 
         rt-button RECT-10 RECT-119 RECT-124 
      WITH FRAME f-cad IN WINDOW esesb008c.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW esesb008c.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy esesb008c 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  
  IF  valid-handle(h-api-movto) THEN
      RUN pi-destroy IN h-api-movto.
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display esesb008c 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit esesb008c 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize esesb008c 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/win-size.i}
    
    {utp/ut9000.i "ESESB008C" "2.00.00.000"}
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    IF  NOT VALID-HANDLE(h-api-movto) THEN
        RUN esp/esb/esesbapi003-movtos.p PERSISTENT SET h-api-movto.

    FIND FIRST int-cc-benef NO-LOCK
        WHERE ROWID(int-cc-benef) = p-rowid NO-ERROR.
    
    DO WITH FRAME f-cad:
    
        FIND FIRST int-class-canal
            WHERE int-class-canal.codigo-classificacao = int-cc-benef.classificacao NO-LOCK NO-ERROR.
        ASSIGN fi-tp-movto:SCREEN-VALUE        = fnMovto(int-cc-benef.tp-movto)
               fi-beneficio:SCREEN-VALUE       = fnBeneficio(int-cc-benef.tipo-beneficio)
               fi-periodo-ini:SCREEN-VALUE     = string(int-cc-benef.dt-periodo-ini)
               fi-periodo-fim:SCREEN-VALUE     = string(int-cc-benef.dt-periodo-fim)
               fi-unidade:SCREEN-VALUE         = int-cc-benef.unid-neg
               fi-classificacao:SCREEN-VALUE   = IF  AVAIL int-class-canal THEN int-class-canal.nome ELSE ""
               fi-categoria:SCREEN-VALUE       = int-cc-benef.categoria
               fi-vl-saldo:SCREEN-VALUE        = string(int-cc-benef.vl-saldo)
               fi-vl-empenhado:SCREEN-VALUE    = string(int-cc-benef.vl-empenhado)
               fi-vl-saldo-ant:SCREEN-VALUE    = string(int-cc-benef.vl-saldo-ant)
               fi-vl-saldo-transp:SCREEN-VALUE = string(int-cc-benef.vl-saldo-transp-vmc-ouro)
               fi-dt-transacao:SCREEN-VALUE    = string(int-cc-benef.dt-transacao)
               fi-dt-vencimento:SCREEN-VALUE   = string(int-cc-benef.dt-vencimento).               
    END.

    RUN dispatch  IN this-procedure ('enable-fields':U).
    
    RUN dispatch  IN this-procedure ('display-fields':U).
    
    {include/i-inifld.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records esesb008c  _ADM-SEND-RECORDS
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed esesb008c 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnBeneficio esesb008c 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnMovto esesb008c 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnStatus esesb008c 
FUNCTION fnStatus RETURNS CHARACTER
  (INPUT p-status AS INT /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  CASE p-status:
      WHEN 1 THEN RETURN "Ativo".
      WHEN 2 THEN RETURN "Bloqueado".
      WHEN 3 THEN RETURN "Cancelado".
      WHEN 4 THEN RETURN "Finalizado".
  END CASE.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

