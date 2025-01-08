&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME esfgl007a
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS esfgl007a 
{include/i-prgvrs.i esesb008C 2.00.00.000}


CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define variable wh-imprime as handle no-undo.


DEFINE INPUT  PARAM p-rowid AS ROWID NO-UNDO.
DEFINE INPUT  PARAM p-novo  AS LOG   NO-UNDO.
DEFINE OUTPUT PARAM p-ok    AS LOGICAL INIT NO NO-UNDO.

IF  NOT p-novo THEN DO:

    FIND int-operacao NO-LOCK
        WHERE ROWID(int-operacao) = p-rowid NO-ERROR.

    IF  NOT AVAIL int-operacao THEN DO:
    
        RUN utp/ut-msgs.p(INPUT "show",                                                      
                          INPUT 17006,                                                       
                          INPUT "N∆o Encontrada operacao de Hedge para alteraá∆o").
        APPLY "CLOSE":U TO THIS-PROCEDURE.
        
        RETURN.
    
    END.
END.

DEF VAR h-acomp AS HANDLE NO-UNDO.

{utp/ut-glob.i}

DEF NEW GLOBAL SHARED VAR v_rec_portador AS RECID NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_indic_econ AS RECID NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS bt-ok bt-cancelar bt-fechar rt-button ~
RECT-119 RECT-159 
&Scoped-Define DISPLAYED-OBJECTS fi-operacao fi-Banco fi-nome-banco ~
fi-dt-fechamento fi-dt-vencimento fi-Moeda fi-nome-moeda fi-cotacao ~
fi-val-operacao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnBeneficio esfgl007a 
FUNCTION fnBeneficio RETURNS CHARACTER
  ( INPUT p-tipo AS INTEGER /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnMovto esfgl007a 
FUNCTION fnMovto RETURNS CHARACTER
  (INPUT p-movto AS INT /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnStatus esfgl007a 
FUNCTION fnStatus RETURNS CHARACTER
  (INPUT p-status AS INT /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR esfgl007a AS WIDGET-HANDLE NO-UNDO.

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

DEFINE VARIABLE fi-Banco AS CHARACTER FORMAT "X(8)":U 
     LABEL "Banco" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 TOOLTIP "Banco" NO-UNDO.

DEFINE VARIABLE fi-cotacao AS DECIMAL FORMAT "->>>,>>>,>>9.9999999999":U INITIAL 0 
     LABEL "Cotaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 TOOLTIP "Vencimento" NO-UNDO.

DEFINE VARIABLE fi-dt-fechamento AS DATE FORMAT "99/99/9999":U 
     LABEL "Contrataá∆o" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 TOOLTIP "Fechamento" NO-UNDO.

DEFINE VARIABLE fi-dt-vencimento AS DATE FORMAT "99/99/9999":U 
     LABEL "Vencto Hedge" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 TOOLTIP "Vencimento" NO-UNDO.

DEFINE VARIABLE fi-Moeda AS CHARACTER FORMAT "X(8)":U INITIAL "0" 
     LABEL "Moeda" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 TOOLTIP "Moeda" NO-UNDO.

DEFINE VARIABLE fi-nome-banco AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 TOOLTIP "Nome Banco" NO-UNDO.

DEFINE VARIABLE fi-nome-moeda AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 TOOLTIP "Nome Moeda" NO-UNDO.

DEFINE VARIABLE fi-operacao AS CHARACTER FORMAT "X(15)":U 
     LABEL "Operaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 TOOLTIP "Operaá∆o" NO-UNDO.

DEFINE VARIABLE fi-val-operacao AS DECIMAL FORMAT ">>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Operaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 TOOLTIP "Valor da Operaá∆o" NO-UNDO.

DEFINE RECTANGLE RECT-119
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 67.86 BY 6.13.

DEFINE RECTANGLE RECT-159
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 67.72 BY 2.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 68.57 BY 1.38
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     fi-operacao AT ROW 1.75 COL 13 COLON-ALIGNED WIDGET-ID 2
     fi-Banco AT ROW 2.75 COL 13 COLON-ALIGNED WIDGET-ID 76
     fi-nome-banco AT ROW 2.75 COL 25.14 COLON-ALIGNED NO-LABEL WIDGET-ID 78
     fi-dt-fechamento AT ROW 3.75 COL 13 COLON-ALIGNED WIDGET-ID 80
     fi-dt-vencimento AT ROW 4.75 COL 13 COLON-ALIGNED WIDGET-ID 82
     fi-Moeda AT ROW 5.75 COL 13 COLON-ALIGNED WIDGET-ID 72
     fi-nome-moeda AT ROW 5.75 COL 25.14 COLON-ALIGNED NO-LABEL WIDGET-ID 74
     fi-cotacao AT ROW 8.33 COL 12 COLON-ALIGNED WIDGET-ID 84
     fi-val-operacao AT ROW 8.33 COL 43 COLON-ALIGNED WIDGET-ID 88
     bt-ok AT ROW 10.21 COL 1.86
     bt-cancelar AT ROW 10.21 COL 12.72 WIDGET-ID 58
     bt-fechar AT ROW 10.21 COL 59
     "Valores" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 7.5 COL 32 WIDGET-ID 90
     rt-button AT ROW 10 COL 1
     RECT-119 AT ROW 1.13 COL 1.57 WIDGET-ID 30
     RECT-159 AT ROW 7.75 COL 1.72 WIDGET-ID 86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1.04
         SIZE 68.72 BY 10.42
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
  CREATE WINDOW esfgl007a ASSIGN
         HIDDEN             = YES
         TITLE              = "Ajuste de Movimento"
         HEIGHT             = 10.5
         WIDTH              = 68.86
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB esfgl007a 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-incsim.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW esfgl007a
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME Custom                                                    */
ASSIGN 
       bt-cancelar:HIDDEN IN FRAME f-cad           = TRUE.

ASSIGN 
       bt-fechar:HIDDEN IN FRAME f-cad           = TRUE.

/* SETTINGS FOR FILL-IN fi-Banco IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cotacao IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-dt-fechamento IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-dt-vencimento IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-Moeda IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-nome-banco IN FRAME f-cad
   NO-ENABLE                                                            */
ASSIGN 
       fi-nome-banco:READ-ONLY IN FRAME f-cad        = TRUE.

/* SETTINGS FOR FILL-IN fi-nome-moeda IN FRAME f-cad
   NO-ENABLE                                                            */
ASSIGN 
       fi-nome-moeda:READ-ONLY IN FRAME f-cad        = TRUE.

/* SETTINGS FOR FILL-IN fi-operacao IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-val-operacao IN FRAME f-cad
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(esfgl007a)
THEN esfgl007a:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME esfgl007a
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL esfgl007a esfgl007a
ON END-ERROR OF esfgl007a /* Ajuste de Movimento */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL esfgl007a esfgl007a
ON WINDOW-CLOSE OF esfgl007a /* Ajuste de Movimento */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar esfgl007a
ON CHOOSE OF bt-cancelar IN FRAME f-cad /* Cancelar */
DO:
  
  RUN notify ('cancel-record':U).
  APPLY "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-fechar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-fechar esfgl007a
ON CHOOSE OF bt-fechar IN FRAME f-cad /* Fechar */
DO:
  
  RUN notify ('cancel-record':U).
  APPLY "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok esfgl007a
ON CHOOSE OF bt-ok IN FRAME f-cad /* Salvar */
DO:

    /*------------------------------------ VALIDAÄÂES GERAIS ------------------------------------*/
    IF fi-operacao:SCREEN-VALUE IN FRAME f-cad  = "" THEN DO:
    
         RUN utp/ut-msgs.p(INPUT "show",
                           INPUT 17006,
                           INPUT "Operaá∆o deve ser informada").

         RETURN NO-APPLY.
    END.

    FIND indic_econ NO-LOCK
        WHERE indic_econ.cod_indic_econ = fi-moeda:SCREEN-VALUE IN FRAME f-cad NO-ERROR.
    IF NOT AVAIL indic_econ THEN DO:
    
         RUN utp/ut-msgs.p(INPUT "show",
                           INPUT 17006,
                           INPUT "Moeda Ç inv†lida. Informe uma moeda v†lida").

         fi-nome-moeda:SCREEN-VALUE IN FRAME f-cad = "".
         RETURN NO-APPLY.
    END.
    FIND emscad.portador NO-LOCK
        WHERE emscad.portador.cod_portador = fi-banco:SCREEN-VALUE IN FRAME f-cad NO-ERROR.
    IF NOT AVAIL emscad.portador THEN DO:
    
         RUN utp/ut-msgs.p(INPUT "show",
                           INPUT 17006,
                           INPUT "Portador inv†lido. Informe um c¢digo de portador v†lido").

         fi-banco:SCREEN-VALUE IN FRAME f-cad = "".
         RETURN NO-APPLY.
    END.

    IF  NOT dec(fi-val-operacao:SCREEN-VALUE IN FRAME f-cad) > 0 THEN DO:
        RUN utp/ut-msgs.p(INPUT "show",
                          INPUT 17006,
                          INPUT "Valor da Operaá∆o N∆o informado").
        RETURN NO-APPLY.
    END.

    RUN utp/ut-msgs.p(INPUT "show":U,
                      INPUT 27100,
                      INPUT "Confirma " + (IF p-novo THEN "Inclus∆o" ELSE "Alteraá∆o")).
    IF  RETURN-VALUE = "no" THEN 
        RETURN NO-APPLY.

    /*----------------------------------------- GRAVAÄ«O-----------------------------------------*/
    IF  p-novo THEN DO:
        FIND int-operacao NO-LOCK
            WHERE int-operacao.operacao = fi-operacao:SCREEN-VALUE IN FRAME f-cad NO-ERROR.
        IF  AVAIL int-operacao THEN DO:
            RUN utp/ut-msgs.p(INPUT "show",                                                      
                              INPUT 17006,                                                       
                              INPUT "C¢digo de Operaá∆o de Hedge j† existente").
             RETURN NO-APPLY.                                                                    
        END.

        DO TRANS WITH FRAME f-cad:

            CREATE int-operacao.
            ASSIGN int-operacao.operacao       = fi-operacao:SCREEN-VALUE
                   int-operacao.cod-banco      = fi-banco:SCREEN-VALUE
                   int-operacao.dt-fechamento  = date(fi-dt-fechamento:SCREEN-VALUE)
                   int-operacao.dt-vencimento  = date(fi-dt-vencimento:SCREEN-VALUE)
                   int-operacao.cod-moeda      = fi-moeda:SCREEN-VALUE
                   int-operacao.cotacao        = dec(fi-cotacao:SCREEN-VALUE)
                   int-operacao.val-operacao   = dec(fi-val-operacao:SCREEN-VALUE).
        END.
    END.
    ELSE DO:

        DO TRANS WITH FRAME f-cad:
            FIND CURRENT int-operacao EXCLUSIVE-LOCK NO-ERROR.

            IF  AVAIL int-operacao THEN
                ASSIGN int-operacao.cod-banco      = fi-banco:SCREEN-VALUE                
                       int-operacao.dt-fechamento  = date(fi-dt-fechamento:SCREEN-VALUE)  
                       int-operacao.dt-vencimento  = date(fi-dt-vencimento:SCREEN-VALUE)  
                       int-operacao.cod-moeda      = fi-moeda:SCREEN-VALUE
                       int-operacao.cotacao        = dec(fi-cotacao:SCREEN-VALUE)         
                       int-operacao.val-operacao   = dec(fi-val-operacao:SCREEN-VALUE).               
        END.

    END.

    FIND CURRENT int-operacao NO-LOCK NO-ERROR.
    RELEASE int-operacao NO-ERROR.

    apply "close":U to this-procedure.
    
    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-Banco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Banco esfgl007a
ON F5 OF fi-Banco IN FRAME f-cad /* Banco */
DO:
  
    RUN prgint/ufn/ufn008ka.p.

    IF  v_rec_portador <> ? THEN
        FIND emscad.portador NO-LOCK
            WHERE recid(emscad.portador) = v_rec_portador NO-ERROR.

    IF  AVAIL emscad.portador THEN
        ASSIGN fi-banco:SCREEN-VALUE      = emscad.portador.cod_portador
               fi-nome-banco:SCREEN-VALUE = emscad.portador.nom_abrev.
    ELSE
        ASSIGN fi-banco:SCREEN-VALUE      = ""
               fi-nome-banco:SCREEN-VALUE = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Banco esfgl007a
ON LEAVE OF fi-Banco IN FRAME f-cad /* Banco */
DO:
  
    FIND emscad.portador NO-LOCK
        WHERE emscad.portador.cod_portador = fi-banco:SCREEN-VALUE IN FRAME f-cad NO-ERROR.
    IF NOT AVAIL emscad.portador THEN DO:
    
         RUN utp/ut-msgs.p(INPUT "show",
                           INPUT 17006,
                           INPUT "Portador inv†lido. Informe um c¢digo de portador v†lido").

         
         ASSIGN fi-nome-banco:SCREEN-VALUE IN FRAME f-cad = "".
         
    END.
    ELSE
        ASSIGN fi-nome-banco:SCREEN-VALUE IN FRAME f-cad = emscad.portador.nom_abrev  .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Banco esfgl007a
ON MOUSE-SELECT-DBLCLICK OF fi-Banco IN FRAME f-cad /* Banco */
DO:
  
    APPLY "F5" TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-Moeda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Moeda esfgl007a
ON F5 OF fi-Moeda IN FRAME f-cad /* Moeda */
DO:
    RUN prgint/utb/utb013ka.p.

    IF  v_rec_indic_econ <> ? THEN
        FIND indic_econ no-lock
             WHERE recid(indic_econ) = v_rec_indic_econ NO-ERROR.

    IF  AVAIL indic_econ THEN
        ASSIGN fi-moeda:SCREEN-VALUE IN FRAME f-cad = indic_econ.cod_indic_econ
               fi-nome-moeda:SCREEN-VALUE IN FRAME f-cad = indic_econ.des_indic_econ.
    ELSE 
        ASSIGN fi-moeda:SCREEN-VALUE IN FRAME f-cad = ""
               fi-nome-moeda:SCREEN-VALUE IN FRAME f-cad = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Moeda esfgl007a
ON LEAVE OF fi-Moeda IN FRAME f-cad /* Moeda */
DO:
    FIND indic_econ NO-LOCK
        WHERE indic_econ.cod_indic_econ = fi-moeda:SCREEN-VALUE IN FRAME f-cad NO-ERROR.
    IF NOT AVAIL indic_econ THEN DO:
    
         RUN utp/ut-msgs.p(INPUT "show",
                           INPUT 17006,
                           INPUT "Moeda Ç inv†lida. Informe um c¢digo de moeda v†lida").

         ASSIGN fi-nome-moeda:SCREEN-VALUE IN FRAME f-cad = "".
         
    END.
    ELSE
        ASSIGN fi-nome-moeda:SCREEN-VALUE IN FRAME f-cad = indic_econ.des_indic_econ.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Moeda esfgl007a
ON MOUSE-SELECT-DBLCLICK OF fi-Moeda IN FRAME f-cad /* Moeda */
DO:
  
    APPLY "F5" TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK esfgl007a 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects esfgl007a  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available esfgl007a  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI esfgl007a  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(esfgl007a)
  THEN DELETE WIDGET esfgl007a.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI esfgl007a  _DEFAULT-ENABLE
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
  DISPLAY fi-operacao fi-Banco fi-nome-banco fi-dt-fechamento fi-dt-vencimento 
          fi-Moeda fi-nome-moeda fi-cotacao fi-val-operacao 
      WITH FRAME f-cad IN WINDOW esfgl007a.
  ENABLE bt-ok bt-cancelar bt-fechar rt-button RECT-119 RECT-159 
      WITH FRAME f-cad IN WINDOW esfgl007a.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW esfgl007a.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy esfgl007a 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display esfgl007a 
PROCEDURE local-display :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        
     
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit esfgl007a 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize esfgl007a 
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

    FIND FIRST int-operacao NO-LOCK
        WHERE ROWID(int-operacao) = p-rowid NO-ERROR.
    IF  AVAIL int-operacao THEN
        DO WITH FRAME f-cad:
        
            ASSIGN fi-operacao:SCREEN-VALUE        = int-operacao.operacao
                   fi-banco:SCREEN-VALUE           = int-operacao.cod-banco
                   fi-dt-fechamento:SCREEN-VALUE   = string(int-operacao.dt-fechamento)
                   fi-dt-vencimento:SCREEN-VALUE   = string(int-operacao.dt-vencimento)
                   fi-cotacao:SCREEN-VALUE         = string(int-operacao.cotacao)
                   fi-moeda:SCREEN-VALUE           = string(int-operacao.cod-moeda)
                   fi-val-operacao:SCREEN-VALUE    = STRING(int-operacao.val-operacao).
            APPLY "leave" TO fi-banco.       
            APPLY "leave" TO fi-moeda.
        END.


    RUN dispatch  IN this-procedure ('enable-fields':U).
    
    RUN dispatch  IN this-procedure ('display-fields':U).
    

    IF  NOT p-novo THEN DO WITH FRAME f-cad:

        /* Verifica se tem lanáamentos, neste caso n∆o deixa alterar */
        IF NOT CAN-FIND (FIRST int-operacao-lancto 
                           WHERE int-operacao-lancto.operacao = int-operacao.operacao
                             AND int-operacao-lancto.num_lote_ctbl > 0 ) 
        THEN DO:
            ASSIGN  fi-operacao:SENSITIVE       = NO
                    fi-banco:SENSITIVE          = YES         
                    fi-dt-fechamento:SENSITIVE  = YES
                    fi-dt-vencimento:SENSITIVE  = YES
                    fi-cotacao:SENSITIVE        = YES
                    fi-moeda:SENSITIVE          = YES
                    fi-val-operacao:SENSITIVE   = YES.
        END.
        ELSE
            ASSIGN  fi-operacao:SENSITIVE       = NO
                    fi-banco:SENSITIVE          = NO         
                    fi-dt-fechamento:SENSITIVE  = NO
                    fi-dt-vencimento:SENSITIVE  = NO
                    fi-cotacao:SENSITIVE        = NO
                    fi-moeda:SENSITIVE          = NO
                    fi-val-operacao:SENSITIVE   = NO.

    END.
    ELSE DO WITH FRAME f-cad:
         ASSIGN fi-operacao:SENSITIVE       = YES
                fi-banco:SENSITIVE          = YES         
                fi-dt-fechamento:SENSITIVE  = YES
                fi-dt-vencimento:SENSITIVE  = YES
                fi-cotacao:SENSITIVE        = YES
                fi-moeda:SENSITIVE          = YES
                fi-val-operacao:SENSITIVE   = YES.
    END.

    {include/i-inifld.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records esfgl007a  _ADM-SEND-RECORDS
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed esfgl007a 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnBeneficio esfgl007a 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnMovto esfgl007a 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnStatus esfgl007a 
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

