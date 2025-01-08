&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esrep001 2.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esrep001
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   iCod-mensagem cTexto-mensag btOK cnarrativa 
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER p-rowid         AS ROWID                     NO-UNDO.
DEFINE OUTPUT PARAMETER piCod-mensagem  LIKE mensagem.cod-mensagem   NO-UNDO INITIAL -1.
DEFINE OUTPUT PARAMETER p-ct-transit    LIKE docum-est.ct-transit    NO-UNDO.
DEFINE OUTPUT PARAMETER p-sc-transit    LIKE docum-est.sc-transit    NO-UNDO.
DEFINE OUTPUT PARAMETER pinarrativa     LIKE docum-est.observacao    NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE VARIABLE v-num-entr-param AS INTEGER     NO-UNDO.


DEF TEMP-TABLE tt-msg NO-UNDO
    FIELD num-msg AS INT.

DEF TEMP-TABLE tt-conta-transit NO-UNDO
    FIELD conta-transit LIKE docum-est.conta-transit
    FIELD ct-transit    LIKE docum-est.ct-transit
    FIELD sc-transit    LIKE docum-est.sc-transit.

{upc/btb910za-upc.i} /* Definiá∆o da vari†vel New Global Shared "v_cod_estab_usuar" */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtKeys rtKeys-2 rtKeys-3 rtToolBar ~
iCod-mensagem cDescricao cTexto-mensag cconta-transit c-sc-codigo ~
cnarrativa btOK 
&Scoped-Define DISPLAYED-OBJECTS iCod-mensagem cDescricao cTexto-mensag ~
cconta-transit c-desc-conta c-sc-codigo c-desc-sub-conta cnarrativa 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE cnarrativa AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 57 BY 2.75 NO-UNDO.

DEFINE VARIABLE cTexto-mensag AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 57.14 BY 2.5 NO-UNDO.

DEFINE VARIABLE c-desc-conta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-sub-conta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .88 NO-UNDO.

DEFINE VARIABLE c-sc-codigo AS CHARACTER FORMAT "x(8)" 
     LABEL "Sub-Conta":R16 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE cconta-transit AS CHARACTER FORMAT "x(8)" 
     LABEL "Conta":R16 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE cDescricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31.43 BY .88 NO-UNDO.

DEFINE VARIABLE iCod-mensagem AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Mensagem devoluá∆o" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 63 BY 4.25.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 63 BY 3.75.

DEFINE RECTANGLE rtKeys-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 63 BY 2.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 63 BY 1.33
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     iCod-mensagem AT ROW 1.25 COL 19.14 COLON-ALIGNED
     cDescricao AT ROW 1.25 COL 28 COLON-ALIGNED NO-LABEL
     cTexto-mensag AT ROW 2.5 COL 5 NO-LABEL
     cconta-transit AT ROW 6 COL 12.43 COLON-ALIGNED HELP
          "Conta Transitoria"
     c-desc-conta AT ROW 6 COL 23 COLON-ALIGNED NO-LABEL
     c-sc-codigo AT ROW 7 COL 12.43 COLON-ALIGNED HELP
          "Conta Transitoria" WIDGET-ID 4
     c-desc-sub-conta AT ROW 7 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     cnarrativa AT ROW 9.42 COL 5 NO-LABEL
     btOK AT ROW 12.96 COL 2.14
     "Observaá∆o" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 8.5 COL 2
     rtKeys AT ROW 1 COL 1
     rtKeys-2 AT ROW 8.67 COL 1
     rtKeys-3 AT ROW 5.5 COL 1
     rtToolBar AT ROW 12.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 63 BY 13.08
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "Mensagem Motivo Devoluá∆o"
         HEIGHT             = 13.08
         WIDTH              = 63
         MAX-HEIGHT         = 39.67
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 39.67
         VIRTUAL-WIDTH      = 182.86
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN c-desc-conta IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-sub-conta IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       cTexto-mensag:READ-ONLY IN FRAME fpage0        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow /* Mensagem Motivo Devoluá∆o */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Mensagem Motivo Devoluá∆o */
DO:
  /* This event will close the window and terminate the procedure.  */
    IF VALID-HANDLE(h_api_cta_ctbl) 
    THEN
        DELETE OBJECT h_api_cta_ctbl.

    IF VALID-HANDLE(h_api_ccusto) 
    THEN
        DELETE OBJECT h_api_ccusto.

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    FIND FIRST tt-conta-transit NO-LOCK
        WHERE  tt-conta-transit.ct-transit = cconta-transit:SCREEN-VALUE 
          AND  tt-conta-transit.sc-transit = c-sc-codigo:SCREEN-VALUE NO-ERROR.
    IF  AVAIL tt-conta-transit THEN DO:
        FIND FIRST tt-msg NO-LOCK
            WHERE  tt-msg.num-msg = INT(iCod-mensagem:SCREEN-VALUE) NO-ERROR.
        IF  NOT AVAIL tt-msg THEN DO:
            RUN utp\ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "Mensagem inv†lida para devoluá∆o. ~~ê necess†rio preencher a mensagem de devoluá∆o correta. Em caso de d£vidas, contate o departamento TIC para avaliar as parametrizaá‰es no programa ES0018.").
            LEAVE.
        END.
    END.


    IF INPUT FRAME {&FRAME-NAME} iCod-mensagem <> 0 then do:
        FIND mensagem NO-LOCK WHERE
             mensagem.cod-mensagem = INPUT FRAME {&FRAME-NAME} iCod-mensagem NO-ERROR.
        IF NOT AVAILABLE mensagem THEN DO:
            RUN utp/ut-msgs.p ('show', 2, 'Mensagem').
            RETURN NO-APPLY.
        END.
    END.
    ELSE DO:
        RUN utp/ut-msgs.p ('show', 17006, 'Informe uma Mensagem v†lida.~~A Mensagem de Devoluá∆o deve ser diferente de ZERO.').
        RETURN NO-APPLY.
    END.

    EMPTY TEMP-TABLE tt_log_erro.
    RUN pi_valida_conta_contabil IN h_api_cta_ctbl (INPUT  i-ep-codigo-usuario,                      /* EMPRESA EMS2 */
                                                    INPUT  v_cod_estab_usuar,                        /* ESTABELECIMENTO EMS2 */
                                                    INPUT  "",                                       /* UNIDADE NEG‡CIO */
                                                    INPUT  "",                                       /* PLANO CONTAS */ 
                                                    INPUT  INPUT FRAME {&FRAME-NAME} cconta-transit, /* CONTA */
                                                    INPUT  "",                                       /* PLANO CCUSTO */ 
                                                    INPUT  INPUT FRAME {&FRAME-NAME} c-sc-codigo,    /* CCUSTO */
                                                    INPUT  TODAY,                                    /* DATA TRANSACAO */
                                                    OUTPUT TABLE tt_log_erro).                       /* ERROS */
    FOR EACH tt_log_erro:
        RUN utp/ut-msgs.p (INPUT 'show':U,
                           INPUT 17006,
                           INPUT tt_log_erro.ttv_des_msg_erro + "~~" + tt_log_erro.ttv_des_msg_ajuda).
    END.
    IF  CAN-FIND(FIRST tt_log_erro) THEN
        RETURN NO-APPLY.

    ASSIGN piCod-mensagem  = INPUT FRAME {&FRAME-NAME} iCod-mensagem
           p-ct-transit    = INPUT FRAME {&FRAME-NAME} cconta-transit
           p-sc-transit    = INPUT FRAME {&FRAME-NAME} c-sc-codigo
           pinarrativa     = INPUT FRAME {&FRAME-NAME} cnarrativa.


    IF  VALID-HANDLE(h_api_cta_ctbl) THEN DO:
        DELETE OBJECT h_api_cta_ctbl.
        ASSIGN h_api_cta_ctbl = ?.
    END.

    IF  VALID-HANDLE(h_api_ccusto) THEN DO:
        DELETE OBJECT h_api_ccusto.
        ASSIGN h_api_ccusto = ?.
    END.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-sc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-codigo wWindow
ON F5 OF c-sc-codigo IN FRAME fpage0 /* Sub-Conta */
DO:
     ASSIGN c-sc-codigo:SCREEN-VALUE      = ""
            c-desc-sub-conta:SCREEN-VALUE = "".

     EMPTY TEMP-TABLE tt_log_erro.
     run pi_zoom_ccusto in h_api_ccusto (INPUT  "",
                                         INPUT  "",
                                         INPUT  "",
                                         INPUT  TODAY,
                                         OUTPUT v_cod_ccusto,
                                         OUTPUT v_des_titulo_ccusto,
                                         OUTPUT TABLE tt_log_erro).
     IF  v_cod_ccusto <> "" THEN
         ASSIGN c-sc-codigo:SCREEN-VALUE      = v_cod_ccusto
                c-desc-sub-conta:SCREEN-VALUE = v_des_titulo_ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-codigo wWindow
ON LEAVE OF c-sc-codigo IN FRAME fpage0 /* Sub-Conta */
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME} c-sc-codigo
           c-desc-sub-conta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".  

    EMPTY TEMP-TABLE tt_log_erro.
    RUN pi_busca_dados_ccusto IN h_api_ccusto (INPUT  i-ep-codigo-usuario, /* EMPRESA EMS2 */
                                               INPUT  "",                  /* CODIGO DO PLANO CCUSTO */
                                               INPUT  c-sc-codigo,         /* CCUSTO */
                                               INPUT  TODAY,               /* DATA DE TRANSACAO */
                                               OUTPUT v_des_titulo_ccusto, /* DESCRICAO DO CCUSTO */
                                               OUTPUT TABLE tt_log_erro).  /* ERROS */

    ASSIGN c-desc-sub-conta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_des_titulo_ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-codigo wWindow
ON MOUSE-SELECT-DBLCLICK OF c-sc-codigo IN FRAME fpage0 /* Sub-Conta */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cconta-transit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cconta-transit wWindow
ON F5 OF cconta-transit IN FRAME fpage0 /* Conta */
DO:
    ASSIGN v_ind_finalid_cta = "(nenhum)".
    
    EMPTY TEMP-TABLE tt_log_erro.
    run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (INPUT  i-ep-codigo-usuario,
                                                   INPUT  "CEP",
                                                   INPUT  "",
                                                   INPUT  v_ind_finalid_cta,
                                                   INPUT  TODAY,
                                                   OUTPUT v_cod_conta,
                                                   OUTPUT v_des_titulo_conta,
                                                   OUTPUT v_ind_finalid_cta,
                                                   OUTPUT TABLE tt_log_erro).

    IF  NOT CAN-FIND(FIRST tt_log_erro) AND v_cod_conta <> "" THEN
        ASSIGN SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_conta
               c-desc-conta:SCREEN-VALUE                = v_des_titulo_conta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cconta-transit wWindow
ON LEAVE OF cconta-transit IN FRAME fpage0 /* Conta */
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME} cconta-transit
           c-desc-conta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".  
   
    ASSIGN v_cod_conta = INPUT FRAME {&FRAME-NAME} cconta-transit.

    RUN pi_verifica_utilizacao_ccusto IN h_api_ccusto (INPUT  "",                 /* EMPRESA EMS 2 */
                                                       INPUT  "",                 /* ESTABELECIMENTO EMS2 */
                                                       INPUT  "",                 /* PLANO CONTAS */
                                                       INPUT  v_cod_conta,        /* CONTA */
                                                       INPUT  TODAY,              /* DT TRANSACAO */
                                                       OUTPUT p_log_ccusto,       /* UTILIZA CCUSTO ? */
                                                       OUTPUT table tt_log_erro). /* ERROS */

    IF  NOT p_log_ccusto THEN DO:
        ASSIGN c-sc-codigo:SCREEN-VALUE IN FRAME fPage0 = ""
               c-sc-codigo:SENSITIVE    IN FRAME fPage0 = NO.
    END.
    ELSE DO:
        ASSIGN c-sc-codigo:SENSITIVE IN FRAME fPage0 = YES.
    END.

    RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT        i-ep-codigo-usuario, /* EMPRESA EMS2 */
                                                   INPUT        "",                  /* PLANO DE CONTAS */
                                                   INPUT-OUTPUT v_cod_conta,         /* CONTA */
                                                   INPUT        TODAY,               /* DATA TRANSACAO */   
                                                   OUTPUT       v_des_titulo_conta,  /* DESCRICAO CONTA */
                                                   OUTPUT       v_num_tip_cta_ctbl,  /* TIPO DA CONTA */
                                                   OUTPUT       v_num_sit_cta_ctbl,  /* SITUA∞ÄO DA CONTA */
                                                   OUTPUT       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                   OUTPUT TABLE tt_log_erro).        /* ERROS */

    ASSIGN cconta-transit:SCREEN-VALUE IN FRAME fPage0 = v_cod_conta
           c-desc-conta:SCREEN-VALUE   IN FRAME fPage0 = v_des_titulo_conta.

    APPLY "LEAVE":U TO c-sc-codigo IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cconta-transit wWindow
ON MOUSE-SELECT-DBLCLICK OF cconta-transit IN FRAME fpage0 /* Conta */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME iCod-mensagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL iCod-mensagem wWindow
ON LEAVE OF iCod-mensagem IN FRAME fpage0 /* Mensagem devoluá∆o */
DO:
    FIND mensagem NO-LOCK WHERE mensagem.cod-mensagem = INPUT FRAME {&FRAME-NAME} iCod-mensagem NO-ERROR.
    ASSIGN cDescricao    = (IF AVAILABLE mensagem THEN mensagem.descricao    ELSE '')
           cTexto-mensag = (IF AVAILABLE mensagem THEN mensagem.texto-mensag ELSE '').

    DISPLAY cDescricao cTexto-mensag WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/

cconta-transit:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME {&FRAME-NAME}.
c-sc-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME {&FRAME-NAME}.

RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.
RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

FIND FIRST docum-est NO-LOCK WHERE
     ROWID(docum-est) = p-rowid NO-ERROR.
IF AVAIL docum-est 
THEN
   ASSIGN cconta-transit:SCREEN-VALUE IN FRAME {&FRAME-NAME} = docum-est.ct-transit    
          cconta-transit:SENSITIVE    IN FRAME {&FRAME-NAME} = YES
          c-sc-codigo:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = docum-est.sc-transit    
          c-sc-codigo:SENSITIVE       IN FRAME {&FRAME-NAME} = YES.                    

APPLY "LEAVE" TO cconta-transit IN FRAME {&FRAME-NAME}.
APPLY "LEAVE" TO c-sc-codigo    IN FRAME {&FRAME-NAME}.

/* Identificar mensagens v†lidas */
EMPTY TEMP-TABLE tt-msg.
EMPTY TEMP-TABLE tt-conta-transit.
FOR FIRST mgesp.ponto-programa
    WHERE ponto-programa.nome-programa = "esrep001"
      AND ponto-programa.ponto         = 1,
     EACH mgesp.conteudo-programa NO-LOCK
    WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
        
    IF  conteudo-programa.conteudo                  <> "" AND
        NUM-ENTRIES(conteudo-programa.conteudo,";")  > 1
    THEN DO:
        IF  ENTRY(1,conteudo-programa.conteudo,";") = "Conta_Transit"
        THEN DO:
            DO v-num-entr-param = 2 TO NUM-ENTRIES(conteudo-programa.conteudo,";"):
                CREATE tt-conta-transit.
                ASSIGN tt-conta-transit.conta-transit = TRIM(ENTRY(v-num-entr-param,conteudo-programa.conteudo,";"))
                       tt-conta-transit.ct-transit    = SUBSTR(tt-conta-transit.conta-transit,1,8)
                       tt-conta-transit.sc-transit    = SUBSTR(tt-conta-transit.conta-transit,9,8).
            END.
        END.
        IF  ENTRY(1,conteudo-programa.conteudo,";") = "MSG"
        THEN DO:
            DO v-num-entr-param = 2 TO NUM-ENTRIES(conteudo-programa.conteudo,";"):
                CREATE tt-msg.
                ASSIGN tt-msg.num-msg = INT(ENTRY(v-num-entr-param,conteudo-programa.conteudo,";")).
            END.
        END.
    END.
END.

{window/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-conta wWindow 
PROCEDURE pi-conta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

