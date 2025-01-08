&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgdes            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i V99XX999 9.99.99.999}

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

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* Global Variable Definitions */
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_empres_usuar AS CHARACTER NO-UNDO.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE v-row-parent       AS ROWID      NO-UNDO.
DEFINE VARIABLE h_api_cta_ctbl     AS HANDLE     NO-UNDO.
DEFINE VARIABLE c-zoom-cod-conta   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-zoom-desc-conta  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE v_cod_cta_ctbl     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE v_des_cta_ctbl     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE v_ind_finalid_cta  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE v_num_tip_cta_ctbl AS CHARACTER  NO-UNDO.
DEFINE VARIABLE v_num_sit_cta_ctbl AS CHARACTER  NO-UNDO.
DEFINE VARIABLE v_cod_formato      AS CHARACTER  NO-UNDO.

/* Temp-tables ---                                                      */
DEFINE TEMP-TABLE tt_log_erro NO-UNDO
    FIELD ttv_num_cod_erro   AS INTEGER   FORMAT ">>>>,>>9" LABEL "N£mero"          COLUMN-LABEL "N£mero"
    FIELD ttv_des_msg_ajuda  AS CHARACTER FORMAT "x(40)"    LABEL "Mensagem Ajuda"  COLUMN-LABEL "Mensagem Ajuda"
    FIELD ttv_des_msg_erro   AS CHARACTER FORMAT "x(60)"    LABEL "Mensagem Erro"   COLUMN-LABEL "Inconsistància".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES prm-projeto-integrador
&Scoped-define FIRST-EXTERNAL-TABLE prm-projeto-integrador


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR prm-projeto-integrador.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS prm-projeto-integrador.url-token ~
prm-projeto-integrador.app-id prm-projeto-integrador.client-secret ~
prm-projeto-integrador.cod-depos prm-projeto-integrador.cod-depos-saida ~
prm-projeto-integrador.cod-emitente prm-projeto-integrador.serie ~
prm-projeto-integrador.qt-dias prm-projeto-integrador.ct-codigo ~
prm-projeto-integrador.prog-download prm-projeto-integrador.log-at-auto-re 
&Scoped-define ENABLED-TABLES prm-projeto-integrador
&Scoped-define FIRST-ENABLED-TABLE prm-projeto-integrador
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold bt-prog-download 
&Scoped-Define DISPLAYED-FIELDS prm-projeto-integrador.url-token ~
prm-projeto-integrador.app-id prm-projeto-integrador.client-secret ~
prm-projeto-integrador.cod-depos prm-projeto-integrador.cod-depos-saida ~
prm-projeto-integrador.cod-emitente prm-projeto-integrador.serie ~
prm-projeto-integrador.qt-dias prm-projeto-integrador.ct-codigo ~
prm-projeto-integrador.prog-download prm-projeto-integrador.log-at-auto-re 
&Scoped-define DISPLAYED-TABLES prm-projeto-integrador
&Scoped-define FIRST-DISPLAYED-TABLE prm-projeto-integrador
&Scoped-Define DISPLAYED-OBJECTS c-depos c-depos-saida c-emitente ~
c-ct-codigo 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-prog-download 
     IMAGE-UP FILE "adeicon/open.bmp":U
     LABEL "" 
     SIZE 4.43 BY .96.

DEFINE VARIABLE c-ct-codigo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-depos AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-depos-saida AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-emitente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41.57 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 3.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 9.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     prm-projeto-integrador.url-token AT ROW 1.17 COL 35.29 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 52 BY .88
     prm-projeto-integrador.app-id AT ROW 2.17 COL 35.29 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 42 BY .88
     prm-projeto-integrador.client-secret AT ROW 3.17 COL 35.29 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 42 BY .88
     prm-projeto-integrador.cod-depos AT ROW 4.67 COL 35.29 COLON-ALIGNED WIDGET-ID 8
          LABEL "Dep¢sito Entrada"
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .88
     c-depos AT ROW 4.67 COL 45.72 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     prm-projeto-integrador.cod-depos-saida AT ROW 5.67 COL 35.29 COLON-ALIGNED WIDGET-ID 46
          LABEL "Dep¢sito Saida"
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .88
     c-depos-saida AT ROW 5.67 COL 45.72 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     prm-projeto-integrador.cod-emitente AT ROW 6.67 COL 35.29 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .88
     c-emitente AT ROW 6.67 COL 45.72 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     prm-projeto-integrador.serie AT ROW 7.67 COL 35.29 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     prm-projeto-integrador.qt-dias AT ROW 8.67 COL 35.29 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     prm-projeto-integrador.ct-codigo AT ROW 9.67 COL 35.29 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     c-ct-codigo AT ROW 9.67 COL 49.43 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     bt-prog-download AT ROW 10.63 COL 84.86 WIDGET-ID 36
     prm-projeto-integrador.prog-download AT ROW 10.67 COL 35.29 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 47.43 BY .88
     prm-projeto-integrador.log-at-auto-re AT ROW 11.67 COL 37.29 WIDGET-ID 16
          VIEW-AS TOGGLE-BOX
          SIZE 40 BY .83
     rt-key AT ROW 1 COL 2.14
     rt-mold AT ROW 4.5 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgdes.prm-projeto-integrador
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
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
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 12.63
         WIDTH              = 90.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}
{include/i_dbtype.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-ct-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-depos IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-depos-saida IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-emitente IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN prm-projeto-integrador.cod-depos IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN prm-projeto-integrador.cod-depos-saida IN FRAME f-main
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME bt-prog-download
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-prog-download V-table-Win
ON CHOOSE OF bt-prog-download IN FRAME f-main
DO:
    DEFINE VARIABLE c-file AS CHARACTER NO-UNDO.
    
    SYSTEM-DIALOG GET-FILE c-file.
                  
    IF c-file <> "" THEN
        ASSIGN prm-projeto-integrador.prog-download:SCREEN-VALUE = c-file.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME prm-projeto-integrador.cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL prm-projeto-integrador.cod-depos V-table-Win
ON F5 OF prm-projeto-integrador.cod-depos IN FRAME f-main /* Dep¢sito Entrada */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in084.w"
                       &campo=prm-projeto-integrador.cod-depos
                       &campozoom=cod-depos
                       &campo2=c-depos
                       &campozoom2=nome}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL prm-projeto-integrador.cod-depos V-table-Win
ON LEAVE OF prm-projeto-integrador.cod-depos IN FRAME f-main /* Dep¢sito Entrada */
DO:
    
    {include/leave.i &tabela=deposito
                     &atributo-ref=nome
                     &variavel-ref=c-depos
                     &where="deposito.cod-depos = input frame {&frame-name} prm-projeto-integrador.cod-depos"}
    
    IF TRIM(c-depos:INPUT-VALUE IN FRAME {&FRAME-NAME}) = "" THEN DO:
        ASSIGN prm-projeto-integrador.cod-depos:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL prm-projeto-integrador.cod-depos V-table-Win
ON MOUSE-SELECT-DBLCLICK OF prm-projeto-integrador.cod-depos IN FRAME f-main /* Dep¢sito Entrada */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME prm-projeto-integrador.cod-depos-saida
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL prm-projeto-integrador.cod-depos-saida V-table-Win
ON F5 OF prm-projeto-integrador.cod-depos-saida IN FRAME f-main /* Dep¢sito Saida */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in084.w"
                       &campo=prm-projeto-integrador.cod-depos-saida
                       &campozoom=cod-depos
                       &campo2=c-depos-saida
                       &campozoom2=nome}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL prm-projeto-integrador.cod-depos-saida V-table-Win
ON LEAVE OF prm-projeto-integrador.cod-depos-saida IN FRAME f-main /* Dep¢sito Saida */
DO:
    
    {include/leave.i &tabela=deposito
                     &atributo-ref=nome
                     &variavel-ref=c-depos-saida
                     &where="deposito.cod-depos = input frame {&frame-name} prm-projeto-integrador.cod-depos-saida"}
    
    IF TRIM(c-depos-saida:INPUT-VALUE IN FRAME {&FRAME-NAME}) = "" THEN DO:
        ASSIGN prm-projeto-integrador.cod-depos-saida:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL prm-projeto-integrador.cod-depos-saida V-table-Win
ON MOUSE-SELECT-DBLCLICK OF prm-projeto-integrador.cod-depos-saida IN FRAME f-main /* Dep¢sito Saida */
DO:
    APPLY "F5":U TO SELF. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME prm-projeto-integrador.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL prm-projeto-integrador.cod-emitente V-table-Win
ON F5 OF prm-projeto-integrador.cod-emitente IN FRAME f-main /* Emitente Integrador */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z03ad098.w"
                       &campo=prm-projeto-integrador.cod-emitente
                       &campozoom=cod-emitente
                       &campo2=c-emitente
                       &campozoom2=nome-abrev}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL prm-projeto-integrador.cod-emitente V-table-Win
ON LEAVE OF prm-projeto-integrador.cod-emitente IN FRAME f-main /* Emitente Integrador */
DO:
    
    {include/leave.i &tabela=emitente
                     &atributo-ref=nome-abrev
                     &variavel-ref=c-emitente
                     &where="emitente.cod-emitente = input frame {&frame-name} prm-projeto-integrador.cod-emitente"}
    
    IF TRIM(c-emitente:INPUT-VALUE IN FRAME {&FRAME-NAME}) = "" THEN DO:
        ASSIGN prm-projeto-integrador.cod-emitente:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL prm-projeto-integrador.cod-emitente V-table-Win
ON MOUSE-SELECT-DBLCLICK OF prm-projeto-integrador.cod-emitente IN FRAME f-main /* Emitente Integrador */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME prm-projeto-integrador.ct-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL prm-projeto-integrador.ct-codigo V-table-Win
ON ENTRY OF prm-projeto-integrador.ct-codigo IN FRAME f-main /* Conta Cont†bil Aplicaá∆o */
DO:
    ASSIGN prm-projeto-integrador.ct-codigo:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL prm-projeto-integrador.ct-codigo V-table-Win
ON F5 OF prm-projeto-integrador.ct-codigo IN FRAME f-main /* Conta Cont†bil Aplicaá∆o */
DO:
    RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.
    
    EMPTY TEMP-TABLE tt_log_erro.

    RUN pi_zoom_cta_ctbl_integr IN h_api_cta_ctbl (INPUT  v_cod_empres_usuar, /* EMPRESA EMS2 */
                                                   INPUT  "CEP",              /* M‡DULO */
                                                   INPUT  "",                 /* PLANO DE CONTAS */
                                                   INPUT  "(nenhum)",         /* FINALIDADES */
                                                   INPUT  TODAY,              /* DATA TRANSACAO */
                                                   OUTPUT v_cod_cta_ctbl,     /* CODIGO CONTA */
                                                   OUTPUT v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                   OUTPUT v_ind_finalid_cta,  /* FINALIDADE DA CONTA */
                                                   OUTPUT TABLE tt_log_erro). /* ERROS */

     IF NOT CAN-FIND(tt_log_erro) AND v_cod_cta_ctbl <> "" THEN
        ASSIGN prm-projeto-integrador.ct-codigo :SCREEN-VALUE IN FRAME {&FRAME-NAME} =  v_cod_cta_ctbl 
               c-ct-codigo                      :SCREEN-VALUE IN FRAME {&FRAME-NAME} =  v_des_cta_ctbl.
     ELSE /* Quando clicado no botao cancela do zoom v_cod_cta_ctbl volta com valor branco */
         IF v_cod_cta_ctbl = "" THEN
             ASSIGN v_cod_cta_ctbl = prm-projeto-integrador.ct-codigo:INPUT-VALUE IN FRAME {&FRAME-NAME}.
    
    FOR FIRST tt_log_erro:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           STRING(tt_log_erro.ttv_des_msg_erro) + ' (' + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
        RETURN NO-APPLY.
    END.

    IF VALID-HANDLE(h_api_cta_ctbl) THEN DO:
        DELETE PROCEDURE h_api_cta_ctbl.
        ASSIGN h_api_cta_ctbl = ?.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL prm-projeto-integrador.ct-codigo V-table-Win
ON LEAVE OF prm-projeto-integrador.ct-codigo IN FRAME f-main /* Conta Cont†bil Aplicaá∆o */
DO:
    RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.

    ASSIGN v_cod_cta_ctbl = prm-projeto-integrador.ct-codigo:INPUT-VALUE IN FRAME {&FRAME-NAME}.

    IF TRIM(v_cod_cta_ctbl) <> "" THEN DO:
        
        EMPTY TEMP-TABLE tt_log_erro.

        /*#### BUSCA DADOS #####*/
        RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT        v_cod_empres_usuar, /* EMPRESA EMS2 */
                                                       INPUT        "",                 /* PLANO DE CONTAS */
                                                       INPUT-OUTPUT v_cod_cta_ctbl,     /* CONTA */
                                                       INPUT        TODAY,              /* DATA TRANSACAO */   
                                                       OUTPUT       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                       OUTPUT       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                       OUTPUT       v_num_sit_cta_ctbl, /* SITUACAO DA CONTA */
                                                       OUTPUT       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                       OUTPUT TABLE tt_log_erro).       /* ERROS */
        
        ASSIGN prm-projeto-integrador.ct-codigo :SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF CAN-FIND(tt_log_erro) THEN "" ELSE v_cod_cta_ctbl
               c-ct-codigo                      :SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF CAN-FIND(tt_log_erro) THEN "" ELSE v_des_cta_ctbl.
        
        EMPTY TEMP-TABLE tt_log_erro.

        /*#### FORMATO #####*/
        RUN pi_retorna_formato_cta_ctbl IN h_api_cta_ctbl (INPUT  v_cod_empres_usuar,   /* EMPRESA EMS2 */
                                                           INPUT  "",                   /* PLANO CONTAS */
                                                           INPUT  TODAY,                /* DATA DE TRANSACAO */
                                                           OUTPUT v_cod_formato,        /* FORMATO CONTA */
                                                           OUTPUT table tt_log_erro).   /* ERROS */
        
        ASSIGN prm-projeto-integrador.ct-codigo:FORMAT IN FRAME {&FRAME-NAME} = IF CAN-FIND(tt_log_erro) THEN "x(20)" ELSE v_cod_formato.
    END.

    IF VALID-HANDLE(h_api_cta_ctbl) THEN DO:
        DELETE PROCEDURE h_api_cta_ctbl.
        ASSIGN h_api_cta_ctbl = ?.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL prm-projeto-integrador.ct-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF prm-projeto-integrador.ct-codigo IN FRAME f-main /* Conta Cont†bil Aplicaá∆o */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME prm-projeto-integrador.qt-dias
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL prm-projeto-integrador.qt-dias V-table-Win
ON LEAVE OF prm-projeto-integrador.qt-dias IN FRAME f-main /* Quantidade de Dias p/ Download XML */
DO:
    IF prm-projeto-integrador.qt-dias:INPUT-VALUE IN FRAME {&FRAME-NAME} > 30 THEN DO:

        RUN utp/ut-msgs.p(INPUT "SHOW":U,
                          INPUT 17006, /* erro */
                          INPUT "Quantidade de dias para download do XML n∆o deve ultrapassar 30 dias":U).
        
        APPLY "ENTRY":U TO SELF.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
/************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "prm-projeto-integrador"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "prm-projeto-integrador"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
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
  HIDE FRAME f-main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}
    
    /*:T Ponha na pi-validate todas as validaá‰es */
    /*:T N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    IF RETURN-VALUE = 'ADM-ERROR':U THEN 
        RETURN 'ADM-ERROR':U.
    
    /*:T Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Code placed here will execute PRIOR to standard behavior. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    DISABLE {&ADM-MODIFY-FIELDS} WITH FRAME {&frame-name}.
    &endif
    
    ASSIGN bt-prog-download:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* Code placed here will execute PRIOR to standard behavior. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    IF prm-projeto-integrador.cod-depos:INPUT-VALUE    IN FRAME {&FRAME-NAME} <> "" THEN
        APPLY "LEAVE":U TO prm-projeto-integrador.cod-depos    IN FRAME {&FRAME-NAME}.
        
    IF prm-projeto-integrador.cod-depos-saida:INPUT-VALUE    IN FRAME {&FRAME-NAME} <> "" THEN
        APPLY "LEAVE":U TO prm-projeto-integrador.cod-depos-saida    IN FRAME {&FRAME-NAME}.    

    IF prm-projeto-integrador.cod-emitente:INPUT-VALUE IN FRAME {&FRAME-NAME} <> 0  THEN
        APPLY "LEAVE":U TO prm-projeto-integrador.cod-emitente IN FRAME {&FRAME-NAME}.

    IF prm-projeto-integrador.ct-codigo:INPUT-VALUE    IN FRAME {&FRAME-NAME} <> "" THEN
        APPLY "LEAVE":U TO prm-projeto-integrador.ct-codigo    IN FRAME {&FRAME-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Code placed here will execute PRIOR to standard behavior. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    IF adm-new-record = YES THEN
        ENABLE {&ADM-MODIFY-FIELDS} WITH FRAME {&frame-name}.
    &endif
    
    ASSIGN bt-prog-download:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Code placed here will execute PRIOR to standard behavior. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    ASSIGN bt-prog-download:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.

    prm-projeto-integrador.cod-depos        :LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME {&FRAME-NAME}.
    prm-projeto-integrador.cod-depos-saida  :LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME {&FRAME-NAME}.
    prm-projeto-integrador.cod-emitente     :LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME {&FRAME-NAME}.
    prm-projeto-integrador.ct-codigo        :LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME {&FRAME-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER v-row-parent-externo AS ROWID NO-UNDO.
    
    ASSIGN v-row-parent = v-row-parent-externo.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*:T------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /*:T Validaá∆o de dicion†rio */
    
/*:T    Segue um exemplo de validaá∆o de programa */
/*       find tabela where tabela.campo1 = c-variavel and               */
/*                         tabela.campo2 > i-variavel no-lock no-error. */
      
      /*:T Este include deve ser colocado sempre antes do ut-msgs.p */
/*       {include/i-vldprg.i}                                             */
/*       run utp/ut-msgs.p (input "show":U, input 7, input return-value). */
/*       return 'ADM-ERROR':U.                                            */
    
    IF TRIM(prm-projeto-integrador.url-token:INPUT-VALUE IN FRAME {&FRAME-NAME}) = "" THEN DO:

        RUN utp/ut-msgs.p(INPUT "SHOW":U,
                          INPUT 17006, /* erro */
                          INPUT "URL Token inv†lida":U).
        
        APPLY "ENTRY":U TO prm-projeto-integrador.url-token IN FRAME {&FRAME-NAME}.
        RETURN "ADM-ERROR":U.
    END.

    IF TRIM(prm-projeto-integrador.app-id:INPUT-VALUE IN FRAME {&FRAME-NAME}) = "" THEN DO:

        RUN utp/ut-msgs.p(INPUT "SHOW":U,
                          INPUT 17006, /* erro */
                          INPUT "App ID inv†lido":U).
        
        APPLY "ENTRY":U TO prm-projeto-integrador.app-id IN FRAME {&FRAME-NAME}.
        RETURN "ADM-ERROR":U.
    END.

    IF TRIM(prm-projeto-integrador.client-secret:INPUT-VALUE IN FRAME {&FRAME-NAME}) = "" THEN DO:

        RUN utp/ut-msgs.p(INPUT "SHOW":U,
                          INPUT 17006, /* erro */
                          INPUT "Client Secret inv†lido":U).
        
        APPLY "ENTRY":U TO prm-projeto-integrador.client-secret IN FRAME {&FRAME-NAME}.
        RETURN "ADM-ERROR":U.
    END.

    IF TRIM(prm-projeto-integrador.cod-depos:INPUT-VALUE IN FRAME {&FRAME-NAME}) = "" THEN DO:

        RUN utp/ut-msgs.p(INPUT "SHOW":U,
                          INPUT 17006, /* erro */
                          INPUT "Dep¢sito Entrada inv†lido":U).
        
        APPLY "ENTRY":U TO prm-projeto-integrador.cod-depos IN FRAME {&FRAME-NAME}.
        RETURN "ADM-ERROR":U.
    END.
    
    IF TRIM(prm-projeto-integrador.cod-depos-saida:INPUT-VALUE IN FRAME {&FRAME-NAME}) = "" THEN DO:

        RUN utp/ut-msgs.p(INPUT "SHOW":U,
                          INPUT 17006, /* erro */
                          INPUT "Dep¢sito Saida inv†lido":U).
        
        APPLY "ENTRY":U TO prm-projeto-integrador.cod-depos-saida IN FRAME {&FRAME-NAME}.
        RETURN "ADM-ERROR":U.
    END.

    IF prm-projeto-integrador.cod-emitente:INPUT-VALUE IN FRAME {&FRAME-NAME} = 0 THEN DO:

        RUN utp/ut-msgs.p(INPUT "SHOW":U,
                          INPUT 17006, /* erro */
                          INPUT "Emitente Integrador inv†lido":U).
        
        APPLY "ENTRY":U TO prm-projeto-integrador.cod-emitente IN FRAME {&FRAME-NAME}.
        RETURN "ADM-ERROR":U.
    END.
    
    IF TRIM(prm-projeto-integrador.serie:INPUT-VALUE IN FRAME {&FRAME-NAME}) = "" THEN DO:

        RUN utp/ut-msgs.p(INPUT "SHOW":U,
                          INPUT 17006, /* erro */
                          INPUT "SÇrie Faturamento inv†lida":U).
        
        APPLY "ENTRY":U TO prm-projeto-integrador.serie IN FRAME {&FRAME-NAME}.
        RETURN "ADM-ERROR":U.
    END.
    
    IF prm-projeto-integrador.qt-dias:INPUT-VALUE IN FRAME {&FRAME-NAME} > 30 THEN DO:

        RUN utp/ut-msgs.p(INPUT "SHOW":U,
                          INPUT 17006, /* erro */
                          INPUT "Quantidade de dias para download do XML n∆o deve ultrapassar 30 dias":U).
        
        APPLY "ENTRY":U TO prm-projeto-integrador.qt-dias IN FRAME {&FRAME-NAME}.
        RETURN "ADM-ERROR":U.
    END.

    IF TRIM(prm-projeto-integrador.ct-codigo:INPUT-VALUE IN FRAME {&FRAME-NAME}) = "" THEN DO:

        RUN utp/ut-msgs.p(INPUT "SHOW":U,
                          INPUT 17006, /* erro */
                          INPUT "Conta Cont†bil inv†lida":U).
        
        APPLY "ENTRY":U TO prm-projeto-integrador.ct-codigo IN FRAME {&FRAME-NAME}.
        RETURN "ADM-ERROR":U.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "prm-projeto-integrador"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
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
      {src/adm/template/vstates.i}
  END CASE.
  RUN pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

