&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME esesb010c
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS esesb010c 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i D99XX999 9.99.99.999}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */
/*                                                                                */
/* OBS: Para os smartobjects o parametro m¢dulo dever† ser MUT                    */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

def temp-table tt-erro-aux no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(200)"
    FIELD ajuda    AS CHAR FORMAT "X(250)".

DEF TEMP-TABLE tt-erro-apb LIKE tt-erro.

/* Temp-table tt-beneficio */
{esp/esb/esesbapi004-benef.i}

DEF INPUT  PARAM p-row-cc              AS ROWID NO-UNDO.
DEF INPUT  PARAM p-vl-verba-solicitada AS DEC NO-UNDO.
DEF OUTPUT PARAM p-ok                  AS LOG INIT NO NO-UNDO.
                                 
{utp/ut-glob.i}
/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME esesb010c

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-buttom RECT-157 fi-verba fi-vl-titulo ~
bt-ok bt-cancela 
&Scoped-Define DISPLAYED-OBJECTS fi-verba fi-vl-titulo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE fi-verba AS DECIMAL FORMAT ">>,>>>,>>9.99":U INITIAL 0 
     LABEL "Verba Requerida" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE fi-vl-titulo AS DECIMAL FORMAT ">>,>>>,>>9.99":U INITIAL 0 
     LABEL "Ajustar Saldo T°tulo para" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-157
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50 BY 5.5.

DEFINE RECTANGLE rt-buttom
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 50 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME esesb010c
     fi-verba AT ROW 3.04 COL 23 COLON-ALIGNED WIDGET-ID 6
     fi-vl-titulo AT ROW 4.25 COL 23 COLON-ALIGNED WIDGET-ID 8
     bt-ok AT ROW 7.88 COL 2.72
     bt-cancela AT ROW 7.88 COL 41.43
     "Ajustar saldo t°tulo APB para comportar a verba requerida" VIEW-AS TEXT
          SIZE 42 BY .67 AT ROW 1.25 COL 3 WIDGET-ID 4
     rt-buttom AT ROW 7.67 COL 2
     RECT-157 AT ROW 1.67 COL 2 WIDGET-ID 2
     SPACE(0.56) SKIP(2.28)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Ajuste de saldo T°tulo APB"
         DEFAULT-BUTTON bt-ok WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB esesb010c 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/d-dialog.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX esesb010c
   FRAME-NAME L-To-R                                                    */
ASSIGN 
       FRAME esesb010c:SCROLLABLE       = FALSE
       FRAME esesb010c:HIDDEN           = TRUE.

ASSIGN 
       fi-verba:READ-ONLY IN FRAME esesb010c        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX esesb010c
/* Query rebuild information for DIALOG-BOX esesb010c
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX esesb010c */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME esesb010c
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL esesb010c esesb010c
ON WINDOW-CLOSE OF FRAME esesb010c /* Ajuste de saldo T°tulo APB */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok esesb010c
ON CHOOSE OF bt-ok IN FRAME esesb010c /* OK */
DO:
  
    run utp/ut-msgs.p (input "show", input 27100, input "Confirma Ajuste de Saldo do T°tulo no APB?" + "~~" +
                   "Ser† realizado um acerto no saldo do t°tulo. Confirma?").

    IF  RETURN-VALUE <> "YES" THEN 
        APPLY "CHOOSE" TO bt-cancela.

    DEF VAR i              AS INTEGER NO-UNDO.
    DEF VAR de-ajuste      AS DEC     NO-UNDO.
    DEF VAR h-esesb003-apb AS HANDLE  NO-UNDO.

    DEFINE VARIABLE h-acomp AS HANDLE     NO-UNDO.
    IF  NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT "Integraá∆o APB").
    RUN pi-acompanhar IN h-acomp  (INPUT "Processando Ajuste de Saldo T°tulo APB...").

    EMPTY TEMP-TABLE tt-erro.
    EMPTY TEMP-TABLE tt-erro-aux.
    EMPTY TEMP-TABLE tt-erro-apb.
    EMPTY TEMP-TABLE tt-beneficio.

    ASSIGN de-ajuste = DEC(fi-vl-titulo:SCREEN-VALUE IN FRAME esesb010c).

    /* INTEGRA O T÷TULO */                                                                                       
    IF  NOT VALID-HANDLE(h-esesb003-apb) THEN                                                                    
        RUN esp/esb/esesbapi003-apb.p PERSISTENT SET h-esesb003-apb.                                             
                                                                                                                 
    FOR FIRST int-cc-benef NO-LOCK
        WHERE ROWID(int-cc-benef) = p-row-cc:

        CREATE tt-beneficio.
        ASSIGN tt-beneficio.tipo-beneficio = int-cc-benef.tipo-beneficio
               tt-beneficio.unid-neg       = int-cc-benef.unid-neg
               tt-beneficio.cod-estabel    = int-cc-benef.cod_estab
               tt-beneficio.perc-custo     = int-cc-benef.perc-custo.
    END.

    RUN pi-seta-usuario IN h-esesb003-apb (INPUT c-seg-usuario).
    RUN pi-Integra-Despesas-APB IN h-esesb003-apb (INPUT p-row-cc,                                    
                                                   INPUT de-ajuste ,                                             
                                                   INPUT YES,  /*valor integral, n∆o deve ser aplicado o fator de custo*/
                                                   INPUT TODAY,                                                  
                                                   INPUT int-cc-benef.dt-periodo-fim,     
                                                   INPUT YES,
                                                   INPUT TABLE tt-beneficio,                                     
                                                   OUTPUT TABLE tt-erro-apb).                                    
                                                                                                                 
    IF  VALID-HANDLE(h-esesb003-apb) THEN                                                                        
        DELETE PROCEDURE h-esesb003-apb.                                                                         
                                                                                                                 
    IF  CAN-FIND (FIRST tt-erro-apb)                                                                             
    OR  RETURN-VALUE <> "OK" THEN DO:                                                                            
        DEF VAR l-erro AS LOG NO-UNDO.                                                                           
        FOR EACH tt-erro-apb:                                                                                    
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */                                          
                                                INPUT "Erro ao tentar ajustar o saldo do t°tulo no APB",        
                                                INPUT tt-erro-apb.mensagem + " - HELP: " + tt-erro-apb.ajuda ).  
            l-erro = YES.                                                                                        
        END.                                                                                                     
                                                                                                                 
        IF  NOT l-erro THEN                                                                                      
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */                                          
                                                INPUT "Erro ao tentar ajustar o saldo do t°tulo no APB",        
                                                INPUT "Retorno com erro, mas n∆o retornou descriá∆o do mesmo."). 

        
        FOR EACH tt-erro:
            ASSIGN i = i + 10.
            CREATE tt-erro-aux.
            ASSIGN tt-erro-aux.i-sequen = i
                   tt-erro-aux.cd-erro  = tt-erro.codigo
                   tt-erro-aux.mensagem = tt-erro.mensagem + CHR(10) + "Detalhe: " + tt-erro.ajuda.
        END.

        IF  CAN-FIND (FIRST tt-erro) THEN
            RUN cdp/cd0666.w (INPUT TABLE tt-erro-aux).

        IF VALID-HANDLE(h-acomp) THEN RUN pi-finalizar IN h-acomp.

        RETURN NO-APPLY.                                                                                  
    END.                                                                                                         
    
    IF VALID-HANDLE(h-acomp) THEN RUN pi-finalizar IN h-acomp.

    RUN utp/ut-msgs.p(INPUT "show",
                      INPUT 15825,
                      INPUT "Ajuste de saldo realizado com sucesso!" + "~~" +
                            "Saldo j† atualizado em tela." ).

    ASSIGN p-ok = YES.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK esesb010c 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects esesb010c  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available esesb010c  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI esesb010c  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME esesb010c.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI esesb010c  _DEFAULT-ENABLE
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
  DISPLAY fi-verba fi-vl-titulo 
      WITH FRAME esesb010c.
  ENABLE rt-buttom RECT-157 fi-verba fi-vl-titulo bt-ok bt-cancela 
      WITH FRAME esesb010c.
  VIEW FRAME esesb010c.
  {&OPEN-BROWSERS-IN-QUERY-esesb010c}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy esesb010c 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize esesb010c 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  {utp/ut9000.i "D99XX999" "9.99.99.999"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  ASSIGN fi-verba:SCREEN-VALUE     IN FRAME esesb010c = STRING(p-vl-verba-solicitada).
         fi-vl-titulo:SCREEN-VALUE IN FRAME esesb010c = STRING(p-vl-verba-solicitada).


/*   FIND FIRST int-cc-benef NO-LOCK                                    */
/*       WHERE rowid(int-cc-benef) = p-row-cc NO-ERROR.                 */
/*                                                                      */
/*   IF  AVAIL int-cc-benef                                             */
/*   AND int-cc-benef.tipo-beneficio = 08 THEN  /* Price Protection */  */
/*       ASSIGN fi-vl-titulo:SENSITIVE IN FRAME esesb010c =  NO.        */

  
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-erro esesb010c 
PROCEDURE pi-cria-erro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAM p-erro     AS INTEGER NO-UNDO.
    DEFINE INPUT PARAM p-mensagem AS CHAR NO-UNDO.
    DEFINE INPUT PARAM p-ajuda    AS CHAR NO-UNDO.

    CREATE tt-erro.
    ASSIGN tt-erro.codigo   = p-erro
           tt-erro.mensagem = p-mensagem
           tt-erro.ajuda    = p-ajuda.                    
                    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records esesb010c  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed esesb010c 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
  
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

