&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
{include/i-prgvrs.i B01PRM1103 1.00.00.000}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */
/*                                                                                */
/* OBS: Para os smartobjects o parametro m¢dulo dever† ser MUT                    */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i MFT MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Global Variable Definitions ---                                      */
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren AS CHARACTER NO-UNDO.

/* Local Variable Definitions ---                                       */
{prmp/prm1103a.i}

DEFINE TEMP-TABLE tt-prm-nf-integrador NO-UNDO LIKE prm-nf-integrador 
    FIELD sel       AS LOGICAL
    FIELD desc-tipo AS CHARACTER.

DEFINE VARIABLE h-acomp AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br-prm-nf-integrador

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-prm-nf-integrador

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br-prm-nf-integrador                          */
&Scoped-define FIELDS-IN-QUERY-br-prm-nf-integrador tt-prm-nf-integrador.sel tt-prm-nf-integrador.cod-proj-int tt-prm-nf-integrador.desc-tipo tt-prm-nf-integrador.data-integracao tt-prm-nf-integrador.msg-erro tt-prm-nf-integrador.arquivo-xml   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-prm-nf-integrador   
&Scoped-define SELF-NAME br-prm-nf-integrador
&Scoped-define QUERY-STRING-br-prm-nf-integrador FOR EACH tt-prm-nf-integrador NO-LOCK                               BY tt-prm-nf-integrador.cod-proj-int                               BY tt-prm-nf-integrador.tipo                               BY tt-prm-nf-integrador.data-integracao
&Scoped-define OPEN-QUERY-br-prm-nf-integrador OPEN QUERY {&SELF-NAME} FOR EACH tt-prm-nf-integrador NO-LOCK                               BY tt-prm-nf-integrador.cod-proj-int                               BY tt-prm-nf-integrador.tipo                               BY tt-prm-nf-integrador.data-integracao.
&Scoped-define TABLES-IN-QUERY-br-prm-nf-integrador tt-prm-nf-integrador
&Scoped-define FIRST-TABLE-IN-QUERY-br-prm-nf-integrador tt-prm-nf-integrador


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bt-filtro bt-atualiza bt-filtro-2 ~
br-prm-nf-integrador ed-msg-erro bt-seleciona-todos bt-seleciona-nehum ~
bt-reprocessa 
&Scoped-Define DISPLAYED-OBJECTS ed-msg-erro 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
arquivo-xml||y|mgesp.prm-nf-integrador.arquivo-xml
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = "arquivo-xml"':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS>
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE>
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNomeArquivo B-table-Win 
FUNCTION getNomeArquivo RETURNS CHARACTER
    (INPUT c-arq AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-atualiza 
     LABEL "Atualiza" 
     SIZE 5 BY 1.13 TOOLTIP "Atualiza".

DEFINE BUTTON bt-filtro 
     IMAGE-UP FILE "image/im-fil.bmp":U
     LABEL "Filtro" 
     SIZE 5 BY 1.13 TOOLTIP "Filtro".

DEFINE BUTTON bt-filtro-2 
     IMAGE-UP FILE "adeicon/cross.bmp":U
     LABEL "Cancelar" 
     SIZE 5 BY 1.13 TOOLTIP "Cancelar".

DEFINE BUTTON bt-reprocessa 
     LABEL "Gerar Nota Fiscal" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-seleciona-nehum 
     LABEL "Nenhum" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-seleciona-todos 
     LABEL "Todos" 
     SIZE 15 BY 1.13.

DEFINE VARIABLE ed-msg-erro AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 113 BY 4 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-prm-nf-integrador FOR 
      tt-prm-nf-integrador SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-prm-nf-integrador
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-prm-nf-integrador B-table-Win _FREEFORM
  QUERY br-prm-nf-integrador NO-LOCK DISPLAY
      tt-prm-nf-integrador.sel              COLUMN-LABEL ""                                     VIEW-AS TOGGLE-BOX
      tt-prm-nf-integrador.cod-proj-int     COLUMN-LABEL "Integrador"   FORMAT "x(10)":U        WIDTH 8
      tt-prm-nf-integrador.desc-tipo        COLUMN-LABEL "Tipo"         FORMAT "x(15)":U        WIDTH 10
      tt-prm-nf-integrador.data-integracao                              FORMAT "99/99/9999":U
      tt-prm-nf-integrador.msg-erro                                     FORMAT "x(10000)":U     WIDTH 50
      tt-prm-nf-integrador.arquivo-xml                                  FORMAT "x(1000)":U      WIDTH 200
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 113 BY 10
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     bt-filtro AT ROW 1.25 COL 1 WIDGET-ID 2
     bt-atualiza AT ROW 1.25 COL 7 WIDGET-ID 4
     bt-filtro-2 AT ROW 1.25 COL 107 WIDGET-ID 14
     br-prm-nf-integrador AT ROW 2.75 COL 1
     ed-msg-erro AT ROW 13 COL 1 NO-LABEL WIDGET-ID 6
     bt-seleciona-todos AT ROW 17.25 COL 1 WIDGET-ID 10
     bt-seleciona-nehum AT ROW 17.25 COL 17 WIDGET-ID 12
     bt-reprocessa AT ROW 17.25 COL 99 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 17.92
         WIDTH              = 114.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}
{include/c-browse.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br-prm-nf-integrador bt-filtro-2 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       ed-msg-erro:READ-ONLY IN FRAME F-Main        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-prm-nf-integrador
/* Query rebuild information for BROWSE br-prm-nf-integrador
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-prm-nf-integrador NO-LOCK
                              BY tt-prm-nf-integrador.cod-proj-int
                              BY tt-prm-nf-integrador.tipo
                              BY tt-prm-nf-integrador.data-integracao.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Query            is NOT OPENED
*/  /* BROWSE br-prm-nf-integrador */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br-prm-nf-integrador
&Scoped-define SELF-NAME br-prm-nf-integrador
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-prm-nf-integrador B-table-Win
ON MOUSE-SELECT-DBLCLICK OF br-prm-nf-integrador IN FRAME F-Main
DO:
    IF AVAILABLE(tt-prm-nf-integrador) THEN DO:        
        ASSIGN tt-prm-nf-integrador.sel = NOT tt-prm-nf-integrador.sel.
               br-prm-nf-integrador:REFRESH().        
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-prm-nf-integrador B-table-Win
ON ROW-ENTRY OF br-prm-nf-integrador IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-prm-nf-integrador B-table-Win
ON ROW-LEAVE OF br-prm-nf-integrador IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-prm-nf-integrador B-table-Win
ON VALUE-CHANGED OF br-prm-nf-integrador IN FRAME F-Main
DO:
    /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
    {src/adm/template/brschnge.i}
    
    ASSIGN ed-msg-erro:SCREEN-VALUE = "".
    
    IF AVAILABLE(tt-prm-nf-integrador) THEN
        ASSIGN ed-msg-erro:SCREEN-VALUE = tt-prm-nf-integrador.msg-erro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-atualiza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-atualiza B-table-Win
ON CHOOSE OF bt-atualiza IN FRAME F-Main /* Atualiza */
DO:
    RUN carregarNFIntegrador.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-filtro B-table-Win
ON CHOOSE OF bt-filtro IN FRAME F-Main /* Filtro */
DO:
    DEFINE VARIABLE l-ok AS LOGICAL NO-UNDO.
    
    THIS-PROCEDURE:CURRENT-WINDOW:SENSITIVE = FALSE.
    RUN prmp/prm1103a.w(INPUT-OUTPUT TABLE tt-param-prm1103,
                        OUTPUT l-ok).  
    THIS-PROCEDURE:CURRENT-WINDOW:SENSITIVE = TRUE.
    
    IF l-ok = TRUE THEN
        RUN carregarNFIntegrador.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-filtro-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-filtro-2 B-table-Win
ON CHOOSE OF bt-filtro-2 IN FRAME F-Main /* Cancelar */
DO:
    IF CAN-FIND(FIRST tt-prm-nf-integrador WHERE tt-prm-nf-integrador.sel = TRUE) THEN DO:
        MESSAGE "Confirmar a exclus∆o dos registros selecionados"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
            TITLE "Excluir Integraá∆o" UPDATE lg-excluir AS LOGICAL.
        IF lg-excluir THEN DO:
            RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
            RUN pi-inicializar IN h-acomp(INPUT "Eliminando...").
            
            FOR EACH tt-prm-nf-integrador WHERE tt-prm-nf-integrador.sel = TRUE:
                RUN pi-acompanhar IN h-acomp(INPUT "Arquivo: " + getNomeArquivo(tt-prm-nf-integrador.arquivo-xml)).
    
                FIND FIRST prm-nf-integrador WHERE prm-nf-integrador.arquivo-xml = tt-prm-nf-integrador.arquivo-xml NO-ERROR.
                IF AVAIL prm-nf-integrador THEN
                    DELETE prm-nf-integrador.
                
                DELETE tt-prm-nf-integrador.
            END.
    
            RUN pi-finalizar IN h-acomp.

            RUN carregarNFIntegrador.  
        END.
    END.
    ELSE DO:
        MESSAGE "Nenhum registro foi selecionado para exclus∆o!"
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-reprocessa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-reprocessa B-table-Win
ON CHOOSE OF bt-reprocessa IN FRAME F-Main /* Gerar Nota Fiscal */
DO:
    RUN utp/ut-msgs.p (INPUT "show":U,INPUT 27100,INPUT "Deseja gerar as notas fiscais para os registros selecionados?").
    IF RETURN-VALUE = "yes" THEN DO:
        RUN gerarNotaFiscal.
        RUN carregarNFIntegrador.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-seleciona-nehum
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-seleciona-nehum B-table-Win
ON CHOOSE OF bt-seleciona-nehum IN FRAME F-Main /* Nenhum */
DO:
    IF TEMP-TABLE tt-prm-nf-integrador:HAS-RECORDS THEN DO:
        FOR EACH tt-prm-nf-integrador:
            ASSIGN tt-prm-nf-integrador.sel = FALSE.    
        END.    
        br-prm-nf-integrador:REFRESH().
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-seleciona-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-seleciona-todos B-table-Win
ON CHOOSE OF bt-seleciona-todos IN FRAME F-Main /* Todos */
DO:
    IF TEMP-TABLE tt-prm-nf-integrador:HAS-RECORDS THEN DO:
        FOR EACH tt-prm-nf-integrador:
            ASSIGN tt-prm-nf-integrador.sel = TRUE.    
        END.    
        br-prm-nf-integrador:REFRESH().
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */
CREATE tt-param-prm1103.
ASSIGN tt-param-prm1103.data-integracao-ini = TODAY - 30
       tt-param-prm1103.data-integracao-fim = TODAY.

bt-atualiza:LOAD-IMAGE-UP(SEARCH("image/im-relo.gif")).

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases B-table-Win  adm/support/_adm-opn.p
PROCEDURE adm-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Opens different cases of the query based on attributes
               such as the 'Key-Name', or 'SortBy-Case'
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

  {&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregarNFIntegrador B-table-Win 
PROCEDURE carregarNFIntegrador :
EMPTY TEMP-TABLE tt-prm-nf-integrador.
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp(INPUT "Carregando Notas...").
    
    FIND FIRST tt-param-prm1103.
    
    FOR EACH prm-nf-integrador NO-LOCK
       WHERE prm-nf-integrador.data-integracao      >= tt-param-prm1103.data-integracao-ini
         AND prm-nf-integrador.data-integracao      <= tt-param-prm1103.data-integracao-fim
         AND prm-nf-integrador.arquivo-xml     MATCHES "*" + tt-param-prm1103.arquivo + "*"
         AND prm-nf-integrador.situacao = 2:

        RUN pi-acompanhar IN h-acomp(INPUT "Arquivo: " + prm-nf-integrador.arquivo-xml).
        CREATE tt-prm-nf-integrador.
        BUFFER-COPY prm-nf-integrador TO tt-prm-nf-integrador.

        CASE tt-prm-nf-integrador.tipo:
            WHEN 1 THEN DO:
                ASSIGN tt-prm-nf-integrador.desc-tipo = "VENDA".
            END.
            WHEN 2 THEN DO:
                ASSIGN tt-prm-nf-integrador.desc-tipo = "CANCELADA".
            END.
            WHEN 3 THEN DO:
                ASSIGN tt-prm-nf-integrador.desc-tipo = "REMESSA".
            END.
            WHEN 4 THEN DO:
                ASSIGN tt-prm-nf-integrador.desc-tipo = "RETORNO".
            END.
            WHEN 5 THEN DO:
                ASSIGN tt-prm-nf-integrador.desc-tipo = "DEVOLUÄ«O".
            END.
            WHEN 6 THEN DO:
                ASSIGN tt-prm-nf-integrador.desc-tipo = "CT-E".
            END.
            OTHERWISE DO:
                ASSIGN tt-prm-nf-integrador.desc-tipo = "".
            END.
        END CASE.
    END.
    
    {&OPEN-QUERY-br-prm-nf-integrador}
    APPLY "VALUE-CHANGED" TO br-prm-nf-integrador IN FRAME F-Main.
    
    RUN pi-finalizar IN h-acomp. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gerarNotaFiscal B-table-Win 
PROCEDURE gerarNotaFiscal :
DEFINE VARIABLE nfv AS CLASS prmapi.NotaVendaIntegrador NO-UNDO.                  
DEFINE VARIABLE nfc AS CLASS prmapi.NotaCancIntegrador NO-UNDO.                  
DEFINE VARIABLE nfr AS CLASS prmapi.NotaRecebimentoIntegrador NO-UNDO.                  
        
    IF AVAILABLE(tt-prm-nf-integrador) THEN DO:
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
        RUN pi-inicializar IN h-acomp(INPUT "Gerando Notas...").
        
        FOR EACH tt-prm-nf-integrador WHERE tt-prm-nf-integrador.sel = TRUE:
            RUN pi-acompanhar IN h-acomp(INPUT "Arquivo: " + getNomeArquivo(tt-prm-nf-integrador.arquivo-xml)).

            CASE tt-prm-nf-integrador.tipo:
                WHEN 1 THEN DO: /*VENDA*/
                    nfv = NEW prmapi.NotaVendaIntegrador(INPUT tt-prm-nf-integrador.cod-proj-int). 
                    nfv:GerarNFPeloArquivoXML(INPUT tt-prm-nf-integrador.arquivo-xml, INPUT tt-prm-nf-integrador.tipo).
                END.
                WHEN 2 THEN DO: /*CANCELADA*/
                    nfc = NEW prmapi.NotaCancIntegrador(INPUT tt-prm-nf-integrador.cod-proj-int).                                        
                    nfc:GerarNFPeloArquivoXML(INPUT tt-prm-nf-integrador.arquivo-xml). 
                END.
                WHEN 3 THEN DO: /*REMESSA*/
                    nfv = NEW prmapi.NotaVendaIntegrador(INPUT tt-prm-nf-integrador.cod-proj-int). 
                    nfv:GerarNFPeloArquivoXML(INPUT tt-prm-nf-integrador.arquivo-xml, INPUT tt-prm-nf-integrador.tipo).
                END.
                WHEN 4 THEN DO: /*RETORNO*/
                    nfr = NEW prmapi.NotaRecebimentoIntegrador(INPUT tt-prm-nf-integrador.cod-proj-int).                                        
                    nfr:GerarNFPeloArquivoXML(INPUT tt-prm-nf-integrador.arquivo-xml, 
                                              INPUT v_cod_usuar_corren,
                                              INPUT tt-prm-nf-integrador.tipo).
                END.
                WHEN 5 THEN DO: /*DEVOLUÄ«O*/
                    nfr = NEW prmapi.NotaRecebimentoIntegrador(INPUT tt-prm-nf-integrador.cod-proj-int).                                        
                    nfr:GerarNFPeloArquivoXML(INPUT tt-prm-nf-integrador.arquivo-xml, 
                                              INPUT v_cod_usuar_corren,
                                              INPUT tt-prm-nf-integrador.tipo).
                END.
            END CASE.

            CATCH erro AS Progress.Lang.Error:
            END CATCH.    
        END.
        RUN pi-finalizar IN h-acomp.
    END. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key B-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "arquivo-xml" "prm-nf-integrador" "arquivo-xml"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-prm-nf-integrador"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNomeArquivo B-table-Win 
FUNCTION getNomeArquivo RETURNS CHARACTER
    (INPUT c-arq AS CHARACTER):
    
    DEFINE VARIABLE c-arq-aux AS CHARACTER NO-UNDO.
    
    ASSIGN c-arq-aux = REPLACE(c-arq, "\", "/")
           c-arq-aux = ENTRY(NUM-ENTRIES(c-arq-aux, "/"), c-arq-aux, "/").
           
    RETURN c-arq-aux.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

