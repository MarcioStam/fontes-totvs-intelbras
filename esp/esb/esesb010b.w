&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadsim 
{include/i-prgvrs.i esesb008a 2.00.00.000}


CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define variable wh-imprime as handle no-undo.


DEF NEW GLOBAL SHARED VAR r-row-canal    AS ROWID  NO-UNDO.

/*Estrutura Canais centralizados*/
{esp/esb/esesbapi005.i}

DEF STREAM s-1.

DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-implanta  AS LOGICAL.

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(200)"
    FIELD ajuda    AS CHAR FORMAT "X(250)".

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
&Scoped-Define ENABLED-OBJECTS rt-button RECT-120 IMAGE-25 IMAGE-26 ~
IMAGE-35 IMAGE-36 rs-selecao fi-canal fi-nome fi-unidade-ini fi-unidade-fim ~
fi-da-ini fi-da-fim bt-ok bt-cancela 
&Scoped-Define DISPLAYED-OBJECTS rs-selecao fi-canal fi-nome fi-unidade-ini ~
fi-unidade-fim fi-da-ini fi-da-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-cadsim AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Fechar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "Listar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE fi-canal AS CHARACTER FORMAT "X(256)":U 
     LABEL "Canal" 
     VIEW-AS FILL-IN 
     SIZE 14.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-da-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 11.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-da-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Data" 
     VIEW-AS FILL-IN 
     SIZE 11.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE fi-unidade-fim AS CHARACTER FORMAT "x(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 6.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-unidade-ini AS CHARACTER FORMAT "x(3)":U 
     LABEL "Unidade" 
     VIEW-AS FILL-IN 
     SIZE 6.57 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-25
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-26
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-35
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-36
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE rs-selecao AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos os Canais", 1,
"Informar Canal", 2
     SIZE 30 BY .79 NO-UNDO.

DEFINE RECTANGLE RECT-120
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 70 BY 4.25.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 70.14 BY 1.38
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     rs-selecao AT ROW 1.58 COL 28.29 NO-LABEL WIDGET-ID 208
     fi-canal AT ROW 3.25 COL 16.43 COLON-ALIGNED WIDGET-ID 126
     fi-nome AT ROW 3.25 COL 31.29 COLON-ALIGNED NO-LABEL WIDGET-ID 128 NO-TAB-STOP 
     fi-unidade-ini AT ROW 4.38 COL 24 COLON-ALIGNED WIDGET-ID 110
     fi-unidade-fim AT ROW 4.38 COL 38.57 COLON-ALIGNED NO-LABEL WIDGET-ID 206
     fi-da-ini AT ROW 5.5 COL 19.43 COLON-ALIGNED WIDGET-ID 212
     fi-da-fim AT ROW 5.5 COL 38.86 COLON-ALIGNED NO-LABEL WIDGET-ID 214
     bt-ok AT ROW 7.54 COL 2.43
     bt-cancela AT ROW 7.54 COL 61.43
     "Pedidos das Solicitaá‰es:" VIEW-AS TEXT
          SIZE 18.14 BY .54 AT ROW 1.71 COL 9.72 WIDGET-ID 42
     rt-button AT ROW 7.33 COL 1.86
     RECT-120 AT ROW 2.75 COL 2 WIDGET-ID 40
     IMAGE-25 AT ROW 4.38 COL 33.14 WIDGET-ID 112
     IMAGE-26 AT ROW 4.38 COL 37 WIDGET-ID 114
     IMAGE-35 AT ROW 5.5 COL 33.14 WIDGET-ID 216
     IMAGE-36 AT ROW 5.5 COL 37 WIDGET-ID 218
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1.04
         SIZE 71.72 BY 7.88
         FONT 7.


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
  CREATE WINDOW w-cadsim ASSIGN
         HIDDEN             = YES
         TITLE              = "Manutená∆o <Insira o complemento>"
         HEIGHT             = 7.96
         WIDTH              = 71.72
         MAX-HEIGHT         = 28.38
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28.38
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-cadsim 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-incsim.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-cadsim
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME L-To-R                                                    */
ASSIGN 
       fi-nome:READ-ONLY IN FRAME f-cad        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON END-ERROR OF w-cadsim /* Manutená∆o <Insira o complemento> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON WINDOW-CLOSE OF w-cadsim /* Manutená∆o <Insira o complemento> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela w-cadsim
ON CHOOSE OF bt-cancela IN FRAME f-cad /* Fechar */
DO:
  RUN notify ('cancel-record':U).
  APPLY "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-cadsim
ON CHOOSE OF bt-ok IN FRAME f-cad /* Listar */
DO:
    
    DEF VAR r-row AS ROWID NO-UNDO.          
    EMPTY TEMP-TABLE tt-central.

    IF  rs-selecao:SCREEN-VALUE = "2" THEN DO:
    
        RUN pi-busca-canal (OUTPUT r-row).
        IF  RETURN-VALUE <> "OK" THEN
            RETURN "NOK".

    END.

/*                                                                                                                                                                                                     */
/*     IF  tg-email:CHECKED IN FRAME f-cad THEN DO:                                                                                                                                                    */
/*         run utp/ut-msgs.p (input "show", input 27100, input "Atená∆o! Selecionada a opá∆o de envio de email para os canais " + "~~" +                                                               */
/*                            "Nesta opá∆o, todos os clientes receber∆o um arquivo contento o detalhamento de c†lculo das suas contas correntes referente aos benef°cios." + CHR(10) + " CONFIRMA?").  */
/*                                                                                                                                                                                                     */
/*                                                                                                                                                                                                     */
/*         IF  RETURN-VALUE <> "YES" THEN                                                                                                                                                              */
/*             RETURN NO-APPLY.                                                                                                                                                                        */
/*     END.                                                                                                                                                                                            */

    EMPTY TEMP-TABLE tt-erro.

    DEF VAR c-label   AS CHAR FORMAT "X(300)" NO-UNDO.
    DEF VAR c-sit     AS CHAR FORMAT "X(15)"  NO-UNDO.
    DEF VAR c-sit-sol AS CHAR FORMAT "X(15)"  NO-UNDO.
    DEF VAR c-benef   AS CHAR FORMAT "X(15)"  NO-UNDO.
    DEF VAR i-canal   AS INTEGER              NO-UNDO.
    DEF VAR h-acomp   AS HANDLE               NO-UNDO.

    IF  NOT VALID-HANDLE(h-acomp) THEN                                  
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.                      
    
    IF  VALID-HANDLE(h-acomp) THEN                                      
        RUN pi-inicializar IN h-acomp (INPUT "Listando Pedidos.").

    
    DO WITH FRAME f-cad:
    
        IF  rs-selecao:SCREEN-VALUE = "1" THEN
            ASSIGN i-canal = ?.
        ELSE DO:
            ASSIGN i-canal = INT(fi-canal:SCREEN-VALUE IN FRAME f-cad).
         
            FIND FIRST emitente NO-LOCK
                WHERE emitente.cod-emitente = i-canal NO-ERROR.
    
            IF NOT AVAIL emitente THEN DO:
                RUN utp/ut-msgs.p(input "show":U, 
                                  input 17006,
                                  input  "Cliente inexistente").
                RETURN NO-APPLY.
            END.
        END.
    END.
    
    DEF VAR c-arquivo AS CHAR NO-UNDO.

    ASSIGN c-label = "Nome Abrev;Pedido Cliente;Dt Implantaá∆o;Dt Cancelado;Liq. Pedido;Tot. Ped;Val Solicitacao;Atendimento;Enviado CRM;Unidade;Benef°cio;Sit Solicitaá∆o;Descricao".
    
    ASSIGN c-arquivo = STRING(SESSION:TEMP-DIRECTORY) + "Pedidos" + "_" + STRING(TODAY, "99-99-9999") + "_" + STRING(TIME) + ".csv".

    OUTPUT STREAM s-1 TO value(c-arquivo) CONVERT TARGET "iso8859-1".

    PUT STREAM s-1 c-label SKIP.

    FOR EACH int-solicitacao NO-LOCK
         WHERE int-solicitacao.CodigoUnidadeNegocio >= fi-unidade-ini:SCREEN-VALUE IN FRAME f-cad
           AND int-solicitacao.CodigoUnidadeNegocio <= fi-unidade-fim:SCREEN-VALUE IN FRAME f-cad
           AND int-solicitacao.DataCriacao          >= date(fi-da-ini:SCREEN-VALUE)
           AND int-solicitacao.DataCriacao          <= date(fi-da-fim:SCREEN-VALUE)
           AND int-solicitacao.log-historica         = NO
        , EACH int-solicitacao-item NO-LOCK
               WHERE int-solicitacao-item.CodigoSolicitacaoBeneficio = int-solicitacao.CodigoSolicitacaoBeneficio
                  AND (IF i-canal = ? THEN YES ELSE int-solicitacao-item.nome-abrev = emitente.nome-abrev)
            BREAK BY int-solicitacao.DataCriacao
                  BY int-solicitacao-item.nome-abrev  
                  BY int-solicitacao-item.nr-pedcli:

          IF  VALID-HANDLE(h-acomp) THEN                                      
              RUN pi-acompanhar IN h-acomp (INPUT "Buscando pedidos em " + STRING( int-solicitacao.dt-trans)).

          IF  FIRST-OF(int-solicitacao-item.nr-pedcli) THEN DO:


              FIND FIRST ped-venda NO-LOCK
                WHERE ped-venda.nome-abrev = int-solicitacao-item.nome-abrev 
                  AND ped-venda.nr-pedcli  = int-solicitacao-item.nr-pedcli NO-ERROR.

              IF  NOT AVAIL ped-venda THEN
                  NEXT.
              
              CASE ped-venda.cod-sit-ped:
                  WHEN 1 THEN c-sit = "Aberto".
                  WHEN 2 THEN c-sit = "Atendido Parcial".
                  WHEN 3 THEN c-sit = "Atendido Total".         
                  WHEN 4 THEN c-sit = "Pendente".
                  WHEN 5 THEN c-sit = "Suspenso".               
                  WHEN 6 THEN c-sit = "Cancelado".              
                  WHEN 7 THEN c-sit = "Fatur Balc∆o".
                  OTHERWISE c-sit = "".
              END CASE.
            
              CASE int-solicitacao.tipo-beneficio:
                  WHEN 21 THEN c-benef = "V M C".
                  WHEN 37 THEN c-benef = "Rebate".
                  WHEN 22 THEN c-benef = "Stock Rotation".
                  WHEN 66 THEN c-benef = "Rebate P¢s-Venda".
              END CASE.
    
              CASE int-solicitacao.SituacaoSolicitacaoBeneficio:
                  WHEN 993520008 THEN c-sit-sol = "Aprovada".
                  WHEN 993520003 THEN c-sit-sol = "Pagamento Pendente".
                  WHEN 993520004 THEN c-sit-sol = "Pagamento Efetuado".
                  WHEN 993520006 THEN c-sit-sol = "Cancelada".
                  OTHERWISE c-sit-sol = "N∆o identificada".
              END CASE.
    
              EXPORT STREAM s-1 DELIMITER ";" ped-venda.nome-abrev    
                                              ped-venda.nr-pedcli     
                                              ped-venda.dt-implant
                                              ped-venda.dt-cancela    
                                              ped-venda.vl-liq-ped    
                                              ped-venda.vl-tot-ped
                                              int-solicitacao.ValorSolicitado
                                              c-sit
                                              string(int-solicitacao.log-enviada, "SIM/N«O")
                                              Upper(int-solicitacao.CodigoUnidadeNegocio)
                                              c-benef
                                              c-sit-sol
                                              int-solicitacao.NomeSolicitacaoBeneficio.
         
          END.
    END.

    OUTPUT STREAM s-1 CLOSE.

    DOS SILENT START excel VALUE(c-arquivo).

    IF  VALID-HANDLE(h-acomp) THEN 
        RUN pi-finalizar IN h-acomp.
/*     apply "close":U to this-procedure. */
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-canal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-canal w-cadsim
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-canal w-cadsim
ON LEAVE OF fi-canal IN FRAME f-cad /* Canal */
DO:

    EMPTY TEMP-TABLE tt-central.

    DEF VAR r-row AS ROWID NO-UNDO.

    RUN pi-busca-canal (OUTPUT r-row).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-canal w-cadsim
ON MOUSE-SELECT-DBLCLICK OF fi-canal IN FRAME f-cad /* Canal */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-selecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-selecao w-cadsim
ON VALUE-CHANGED OF rs-selecao IN FRAME f-cad
DO:

  IF  SELF:SCREEN-VALUE = "2" THEN
      ASSIGN fi-canal:SENSITIVE = YES.
  ELSE
      ASSIGN fi-canal:SENSITIVE = NO.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-cadsim 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-cadsim  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-cadsim  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-cadsim  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
  THEN DELETE WIDGET w-cadsim.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-cadsim  _DEFAULT-ENABLE
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
  DISPLAY rs-selecao fi-canal fi-nome fi-unidade-ini fi-unidade-fim fi-da-ini 
          fi-da-fim 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  ENABLE rt-button RECT-120 IMAGE-25 IMAGE-26 IMAGE-35 IMAGE-36 rs-selecao 
         fi-canal fi-nome fi-unidade-ini fi-unidade-fim fi-da-ini fi-da-fim 
         bt-ok bt-cancela 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW w-cadsim.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-cadsim 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display w-cadsim 
PROCEDURE local-display :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-cadsim 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-cadsim 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}

  {utp/ut9000.i "esesb010B" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  DO WITH FRAME f-cad:                 

     ASSIGN fi-da-ini:SCREEN-VALUE = STRING(TODAY - 180)
            fi-da-fim:SCREEN-VALUE = STRING(TODAY).
            fi-canal:SENSITIVE     = YES.
            
  END. 


  RUN dispatch  IN this-procedure ('enable-fields':U).
  
  RUN dispatch  IN this-procedure ('display-fields':U).

  {include/i-inifld.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-canal w-cadsim 
PROCEDURE pi-busca-canal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF OUTPUT PARAM p-row AS ROWID NO-UNDO.

    IF  fi-canal:SCREEN-VALUE IN FRAME f-cad = "" 
    OR  fi-canal:SCREEN-VALUE IN FRAME f-cad = "0" THEN
        RETURN "NOK".
    
    /* valida emitente canal */
    EMPTY TEMP-TABLE tt-central.
    RUN esp/esb/esesbapi005.p (INPUT  fi-canal:SCREEN-VALUE IN FRAME f-cad,
                               OUTPUT TABLE tt-central,
                               OUTPUT TABLE tt-erro).

    FIND FIRST tt-erro NO-ERROR.

    IF  RETURN-VALUE <> "OK"
    OR AVAIL tt-erro THEN DO:
        RUN utp/ut-msgs.p(input "show":U, 
                          input 17006,
                          input tt-erro.mensagem + "~~" + tt-erro.ajuda).
        APPLY "entry" TO fi-canal IN FRAME f-cad.
        RETURN "NOK".
    END.
        
    FIND FIRST tt-central 
        WHERE tt-central.canal-central = int(fi-canal:SCREEN-VALUE) NO-ERROR.

    /* VERIFICA SE O CANAL ê CENTRALIZADO, LOGO, N«O PERMITE INCLU÷LO NO BROWSER*/
    IF  NOT AVAIL tt-central THEN DO:
        RUN utp/ut-msgs.p(input "show":U, 
                          input 17006,
                          input "Este canal apura benef°cios de forma centralizada." + "~~" +
                                "A geraá∆o dos benef°cios s¢ pode ser processada para a Matriz.").
        APPLY "entry" TO fi-canal IN FRAME f-cad.
        RETURN "NOK".
    END.

    ASSIGN fi-nome:SCREEN-VALUE IN FRAME f-cad = tt-central.nome-emit-central.

    ASSIGN p-row = tt-central.r-row-central.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-cadsim  _ADM-SEND-RECORDS
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-cadsim 
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

