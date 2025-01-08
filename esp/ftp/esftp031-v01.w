&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
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

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */
/*                                                                                */
/* OBS: Para os smartobjects o parametro m¢dulo dever  ser MUT                    */

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

/* global variable definitions */
DEFINE NEW GLOBAL SHARED VAR h-browserCamposLib AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR h-browserEstabsLib AS HANDLE NO-UNDO.
{utp/utapi019.i} 
{esp\es0018.i}
/* Parameters Definitions ---                                           */
DEFINE BUFFER b-estabelec        FOR estabelec.

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.
DEFINE VARIABLE l-retorna       AS LOGICAL INIT YES    NO-UNDO.
DEFINE VARIABLE l-desabilitaBt  AS LOGICAL INIT  NO    NO-UNDO.
DEFINE VARIABLE c-texto AS CHARACTER FORMAT 'X(256)' NO-UNDO.
DEFINE VARIABLE c-email AS CHARACTER                 NO-UNDO.
DEFINE BUFFER b-usuar_mestre FOR usuar_mestre.


DEFINE TEMP-TABLE tt-estabelecIN LIKE estabelec
    FIELD l-seleciona AS LOGICAL FORMAT 'SIM/NAO'.

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
&Scoped-define EXTERNAL-TABLES lib-item-fat
&Scoped-define FIRST-EXTERNAL-TABLE lib-item-fat


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR lib-item-fat.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS lib-item-fat.cod-solicitacao ~
lib-item-fat.usuario lib-item-fat.hr-solicitacao ~
lib-item-fat.dt-solicitacao lib-item-fat.c-status 
&Scoped-define ENABLED-TABLES lib-item-fat
&Scoped-define FIRST-ENABLED-TABLE lib-item-fat
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold RECT-1 
&Scoped-Define DISPLAYED-FIELDS lib-item-fat.it-codigo ~
lib-item-fat.cod-estab-pad lib-item-fat.cod-solicitacao ~
lib-item-fat.cod-estab-trans-orig lib-item-fat.cod-estab-trans-dest ~
lib-item-fat.usuario lib-item-fat.hr-solicitacao ~
lib-item-fat.dt-solicitacao lib-item-fat.c-status 
&Scoped-define DISPLAYED-TABLES lib-item-fat
&Scoped-define FIRST-DISPLAYED-TABLE lib-item-fat
&Scoped-Define DISPLAYED-OBJECTS c-desc-item rs-tipo c-nome 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS lib-item-fat.it-codigo ~
lib-item-fat.cod-estab-pad lib-item-fat.cod-solicitacao rs-tipo ~
lib-item-fat.cod-estab-trans-orig lib-item-fat.cod-estab-trans-dest 
&Scoped-define ADM-MODIFY-FIELDS lib-item-fat.usuario ~
lib-item-fat.hr-solicitacao lib-item-fat.dt-solicitacao ~
lib-item-fat.c-status 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
it-codigo||y|mgesp.lib-item-fat.it-codigo
usuario||y|mgesp.lib-item-fat.usuario
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = "it-codigo,usuario"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_ApLib AUTO-GO DEFAULT 
     LABEL "Aprova / Libera" 
     SIZE 13 BY 1
     BGCOLOR 8 .

DEFINE BUTTON Btn_Cancel AUTO-GO DEFAULT 
     LABEL "Cancela" 
     SIZE 13 BY 1
     BGCOLOR 8 .

DEFINE BUTTON Btn_Pendente AUTO-GO DEFAULT 
     LABEL "Pendente" 
     SIZE 13 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 82.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 83.57 BY .88 NO-UNDO.

DEFINE VARIABLE rs-tipo AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Faturamento", 1,
"Transferˆncia", 2
     SIZE 52.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 100.29 BY 1.5.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 155 BY 4.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 155 BY 2.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     lib-item-fat.it-codigo AT ROW 1.21 COL 24.57 WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-desc-item AT ROW 1.21 COL 43.72 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     Btn_Cancel AT ROW 1.54 COL 135 WIDGET-ID 22
     lib-item-fat.cod-estab-pad AT ROW 2.21 COL 26.29 COLON-ALIGNED WIDGET-ID 18
          LABEL "Estab Pad"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     lib-item-fat.cod-solicitacao AT ROW 2.21 COL 107.43 WIDGET-ID 4
          LABEL "Solicitacao"
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     rs-tipo AT ROW 3.79 COL 28.72 NO-LABEL WIDGET-ID 24
     lib-item-fat.cod-estab-trans-orig AT ROW 3.79 COL 88.86 COLON-ALIGNED WIDGET-ID 30
          LABEL "Estab Orig"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY 1
     lib-item-fat.cod-estab-trans-dest AT ROW 3.79 COL 118.57 COLON-ALIGNED WIDGET-ID 28
          LABEL "Estab Dest"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY 1
     lib-item-fat.usuario AT ROW 5.54 COL 26.29 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     c-nome AT ROW 5.54 COL 42.72 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     lib-item-fat.hr-solicitacao AT ROW 6.54 COL 26.29 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     lib-item-fat.dt-solicitacao AT ROW 6.54 COL 62.72 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     lib-item-fat.c-status AT ROW 6.54 COL 90.15 WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 33 BY .88
     Btn_Pendente AT ROW 2.63 COL 135 WIDGET-ID 36
     Btn_ApLib AT ROW 3.71 COL 135 WIDGET-ID 38
     "&Tipo de Solicita‡Æo" VIEW-AS TEXT
          SIZE 14 BY .54 AT ROW 3.25 COL 29 WIDGET-ID 34
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 5.33 COL 1
     RECT-1 AT ROW 3.54 COL 28 WIDGET-ID 32
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgesp.lib-item-fat
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
         HEIGHT             = 6.75
         WIDTH              = 155.14.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON Btn_ApLib IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON Btn_Cancel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON Btn_Pendente IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN lib-item-fat.c-status IN FRAME f-main
   ALIGN-L 3                                                            */
/* SETTINGS FOR FILL-IN lib-item-fat.cod-estab-pad IN FRAME f-main
   NO-ENABLE 1 EXP-LABEL                                                */
/* SETTINGS FOR FILL-IN lib-item-fat.cod-estab-trans-dest IN FRAME f-main
   NO-ENABLE 1 EXP-LABEL                                                */
/* SETTINGS FOR FILL-IN lib-item-fat.cod-estab-trans-orig IN FRAME f-main
   NO-ENABLE 1 EXP-LABEL                                                */
/* SETTINGS FOR FILL-IN lib-item-fat.cod-solicitacao IN FRAME f-main
   ALIGN-L 1 EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN lib-item-fat.dt-solicitacao IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN lib-item-fat.hr-solicitacao IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN lib-item-fat.it-codigo IN FRAME f-main
   NO-ENABLE ALIGN-L 1                                                  */
/* SETTINGS FOR RADIO-SET rs-tipo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN lib-item-fat.usuario IN FRAME f-main
   3                                                                    */
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

&Scoped-define SELF-NAME Btn_ApLib
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_ApLib V-table-Win
ON CHOOSE OF Btn_ApLib IN FRAME f-main /* Aprova / Libera */
DO:
  

    FIND FIRST lib-item-fat
        WHERE lib-item-fat.cod-solicitacao = INTEGER(lib-item-fat.cod-solicitacao:SCREEN-VALUE IN FRAME {&FRAME-NAME}) EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL lib-item-fat THEN DO: 
        IF lib-item-fat.c-status = "Pendente"               AND rs-tipo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '1' THEN
            ASSIGN lib-item-fat.c-status = "Pendencia Liberada".
        IF  lib-item-fat.c-status = "Aguardando Liberacao"  AND rs-tipo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '2' THEN
            ASSIGN lib-item-fat.c-status = "Transf. Aprovada".
    END. /* IF AVAIL lib-item-fat THEN DO:  */

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN Btn_ApLib:SENSITIVE = NO.
    END. /* DO WITH FRAME {&FRAME-NAME}: */

    RUN pi-atualizaStatus.

    IF lib-item-fat.c-status = 'Pendencia Liberada' THEN DO:
        IF VALID-HANDLE(h-browserEstabsLib) THEN
            RUN pi-CriaTT IN h-browserEstabsLib  (INPUT lib-item-fat.it-codigo   :SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                                  INPUT NO).

        FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren NO-LOCK NO-ERROR.
        IF AVAIL usuar_mestre THEN DO:
            FIND FIRST ITEM WHERE ITEM.it-codigo = INPUT FRAME {&FRAME-NAME} lib-item-fat.it-codigo NO-LOCK NO-ERROR.
            IF AVAIL ITEM THEN DO:

                FIND FIRST int-unid-negoc WHERE int-unid-negoc.cod-unid-negoc = ITEM.cod-unid-negoc NO-LOCK NO-ERROR.
                IF AVAIL int-unid-negoc THEN DO:

                    FIND FIRST b-usuar_mestre WHERE b-usuar_mestre.cod_usuario = lib-item-fat.usuario NO-LOCK NO-ERROR.
                    IF AVAIL b-usuar_mestre THEN
                        ASSIGN c-email = int-unid-negoc.email + ';' + b-usuar_mestre.cod_e_mail_local.
                    ELSE
                        ASSIGN c-email = int-unid-negoc.email.

                    ASSIGN c-texto = "Pendencia liberada".
                    RUN  piEnviaEmail (INPUT usuar_mestre.cod_e_mail_local,
                                       INPUT c-email,
                                       INPUT 'Pendencia Liberada: Solicitacao ' + string(lib-item-fat.cod-solicitacao) + ' - ITEM ' + ITEM.it-codigo,
                                       INPUT c-texto,
                                       INPUT "").
                END. /* IF AVAIL int-unid-negoc THEN DO: */

            END. /* IF AVAIL ITEM THEN DO: */
        END. /* IF AVAIL usuar_mestre THEN DO: */

    END.
    ELSE DO:

        FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren NO-LOCK NO-ERROR.
        IF AVAIL usuar_mestre THEN DO:
            FIND FIRST ITEM WHERE ITEM.it-codigo = INPUT FRAME {&FRAME-NAME} lib-item-fat.it-codigo NO-LOCK NO-ERROR.
            IF AVAIL ITEM THEN DO:

                FIND FIRST int-unid-negoc WHERE int-unid-negoc.cod-unid-negoc = ITEM.cod-unid-negoc NO-LOCK NO-ERROR.
                IF AVAIL int-unid-negoc THEN DO:

                    FIND FIRST b-usuar_mestre WHERE b-usuar_mestre.cod_usuario = lib-item-fat.usuario NO-LOCK NO-ERROR.
                    IF AVAIL b-usuar_mestre THEN
                        ASSIGN c-email = int-unid-negoc.email + ';' + b-usuar_mestre.cod_e_mail_local.
                    ELSE
                        ASSIGN c-email = int-unid-negoc.email.

                    ASSIGN c-texto = "Transferˆncia Aprovada".
                    RUN  piEnviaEmail (INPUT usuar_mestre.cod_e_mail_local,
                                       INPUT c-email,
                                       INPUT 'Transferˆncia Aprovada: Solicitacao ' + string(lib-item-fat.cod-solicitacao) + ' - ITEM ' + ITEM.it-codigo,
                                       INPUT c-texto,
                                       INPUT "").
                END. /* IF AVAIL int-unid-negoc THEN DO: */

            END. /* IF AVAIL ITEM THEN DO: */
        END. /* IF AVAIL usuar_mestre THEN DO: */
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel V-table-Win
ON CHOOSE OF Btn_Cancel IN FRAME f-main /* Cancela */
DO:
  
    DEFINE VARIABLE c-textoC AS CHARACTER FORMAT 'X(256)' NO-UNDO.
    DEFINE VARIABLE c-emailC AS CHARACTER                 NO-UNDO.
    DEFINE BUFFER b-usuar_mestreC FOR usuar_mestre.
    
    FIND FIRST lib-item-fat 
        WHERE lib-item-fat.cod-solicitacao = INPUT FRAME {&FRAME-NAME} lib-item-fat.cod-solicitacao NO-LOCK NO-ERROR.
    IF AVAIL lib-item-fat THEN
        RUN esp/ftp/esftp031c.w (INPUT lib-item-fat.cod-solicitacao).

    IF lib-item-fat.c-status:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Cancelado' THEN DO:
        DO WITH FRAME {&FRAME-NAME}:
            ASSIGN Btn_Cancel:SENSITIVE = NO.
        END. /* DO WITH FRAME {&FRAME-NAME}: */
    
    
        FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren NO-LOCK NO-ERROR.
        IF AVAIL usuar_mestre THEN DO:
            FIND FIRST ITEM WHERE ITEM.it-codigo = INPUT FRAME {&FRAME-NAME} lib-item-fat.it-codigo NO-LOCK NO-ERROR.
            IF AVAIL ITEM THEN DO:

                IF lib-item-fat.char-1 = "Sem preco de venda cadastrado" THEN DO:
                    
                    RUN esp/es0018p.p (INPUT "esftp031", /* Nome do programa  */
                                       INPUT 2,          /* Ponto do programa */
                                       INPUT 0,
                                       INPUT "",
                                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
                
                    FOR EACH tt-prog-ponto:
                         IF c-emailC = "" THEN
                            ASSIGN c-emailC = tt-prog-ponto.conteudo.
                         ELSE
                            ASSIGN c-emailC = c-emailC + ";" + tt-prog-ponto.conteudo.       
                    END.
                END.
                ELSE
                    c-emailC = "".
                                        
                FIND FIRST b-usuar_mestreC WHERE b-usuar_mestreC.cod_usuario = lib-item-fat.usuario NO-LOCK NO-ERROR.
                IF AVAIL b-usuar_mestreC THEN DO:
                        ASSIGN c-emailC = c-emailC + ";" + b-usuar_mestreC.cod_e_mail_local.        
                        ASSIGN c-textoC = "Solicitacao " + lib-item-fat.cod-solicitacao:SCREEN-VALUE IN FRAME {&FRAME-NAME} + " de ITEM Faturavel - ITEM " + ITEM.it-codigo + " cancelada. Motivo: " + lib-item-fat.char-1.

                     RUN  piEnviaEmail (INPUT usuar_mestre.cod_e_mail_local,
                                       INPUT c-emailC,
                                       INPUT "Cancelado - Solicita‡Æo ITEM Fatur vel",
                                       INPUT c-textoC,
                                       INPUT "").       
                    
                END. /* IF AVAIL int-unid-negoc THEN DO: */
    
            END. /* IF AVAIL ITEM THEN DO: */
        END. /* IF AVAIL usuar_mestre THEN DO: */
    END.
    ELSE ASSIGN l-retorna = NO.

    APPLY "CLOSE":U TO THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Pendente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Pendente V-table-Win
ON CHOOSE OF Btn_Pendente IN FRAME f-main /* Pendente */
DO:

    FIND FIRST lib-item-fat
        WHERE lib-item-fat.cod-solicitacao = INTEGER(lib-item-fat.cod-solicitacao:SCREEN-VALUE IN FRAME {&FRAME-NAME}) EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL lib-item-fat THEN DO:

/*         IF NOT CAN-FIND(preco-item WHERE preco-item.it-codigo = lib-item-fat.it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}) THEN DO: */
/*             ASSIGN lib-item-fat.c-status                                     = "Pendente"                                            */
/*                    lib-item-fat.c-status:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Pendente"                                            */
/*                    lib-item-fat.dt-liberacao                                 = TODAY .                                               */
/*                                                                                                                                      */
/*             run utp/ut-msgs.p (INPUT "show":U,                                                                                                      */
/*                                INPUT 17006,                                                                                                         */
/*                                INPUT "Tabela de Pre‡o Inv lida. ~~ " +                                                                              */
/*                                      "Tabela de Pre‡o nÆo existe para o ITEM " + lib-item-fat.it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} + "."). */
/*             APPLY 'ENTRY' TO lib-item-fat.it-codigo.                                                                                                */
/*             RETURN 'ADM-ERROR':U.                                                                                                                   */
/*         END.     */
/*         ELSE DO: */
            ASSIGN lib-item-fat.c-status                                     = "Pendente"
                   lib-item-fat.c-status:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Pendente"
                   lib-item-fat.dt-liberacao                                 = TODAY .
/*         END. */

    END.

    FIND FIRST ITEM WHERE ITEM.it-codigo = lib-item-fat.it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL ITEM AND ITEM.ind-item-fat = NO THEN DO:
        ASSIGN ITEM.ind-item-fat = YES.
    END.

    RUN pi-atualizaStatus.

    FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren NO-LOCK NO-ERROR.
    IF AVAIL usuar_mestre THEN DO:

        FIND FIRST ITEM WHERE ITEM.it-codigo = lib-item-fat.it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK NO-ERROR.
        IF AVAIL ITEM THEN DO:

            FIND FIRST int-unid-negoc WHERE int-unid-negoc.cod-unid-negoc = ITEM.cod-unid-negoc NO-LOCK NO-ERROR.
            IF AVAIL int-unid-negoc THEN DO:

                FIND FIRST b-usuar_mestre WHERE b-usuar_mestre.cod_usuario = lib-item-fat.usuario NO-LOCK NO-ERROR.
                IF AVAIL b-usuar_mestre THEN
                    ASSIGN c-email = int-unid-negoc.email + ';' + b-usuar_mestre.cod_e_mail_local.
                ELSE
                    ASSIGN c-email = int-unid-negoc.email.

                ASSIGN c-texto = "Item " + ITEM.it-codigo + " sem pre‡o de venda cadastrado. Um e-mail ser  enviado ao comercial da unidade para atendimento dessa pendˆncia. Sem retorno desta atividade em at‚ 3 dias £teis, sua solicita‡Æo ser  cancelada.".

                RUN  piEnviaEmail (INPUT usuar_mestre.cod_e_mail_local,
                                   INPUT c-email,
                                   INPUT "PENDENTE! Solicita‡Æo " + lib-item-fat.cod-solicitacao:SCREEN-VALUE IN FRAME {&FRAME-NAME} + " de ITEM Fatur vel." ,
                                   INPUT c-texto,
                                   INPUT "").
            END. /* IF AVAIL int-unid-negoc THEN DO: */

        END. /* IF AVAIL ITEM THEN DO: */
    END. /* IF AVAIL usuar_mestre THEN DO: */

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN Btn_Pendente:SENSITIVE = NO.
    END. /* DO WITH FRAME {&FRAME-NAME}: */

    RUN local-row-available IN THIS-PROCEDURE.
    FIND CURRENT ITEM NO-LOCK NO-ERROR.
    RELEASE ITEM.

    APPLY "CLOSE":U TO THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lib-item-fat.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lib-item-fat.it-codigo V-table-Win
ON ENTRY OF lib-item-fat.it-codigo IN FRAME f-main /* Item */
DO:
  
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN lib-item-fat.cod-solicitacao     :SENSITIVE = NO
               lib-item-fat.cod-estab-pad       :SENSITIVE = NO
               Btn_Cancel                       :SENSITIVE = NO
            
               lib-item-fat.cod-estab-trans-orig:SENSITIVE    = NO
               lib-item-fat.cod-estab-trans-dest:SENSITIVE    = NO
               lib-item-fat.cod-estab-trans-orig:SCREEN-VALUE = ''
               lib-item-fat.cod-estab-trans-dest:SCREEN-VALUE = ''.
        
    END.

    IF VALID-HANDLE(h-browserEstabsLib) THEN
        RUN pi-desabilitaLibera IN h-browserEstabsLib.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lib-item-fat.it-codigo V-table-Win
ON F5 OF lib-item-fat.it-codigo IN FRAME f-main /* Item */
DO:
  
    {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                       &campo="lib-item-fat.it-codigo"
                       &campozoom="it-codigo"
                       &frame="f-main"
                       &campo2="c-desc-item"
                       &campozoom2="desc-item"
                       &frame2="f-main"}
                       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lib-item-fat.it-codigo V-table-Win
ON LEAVE OF lib-item-fat.it-codigo IN FRAME f-main /* Item */
DO:
  
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN lib-item-fat.cod-solicitacao:SENSITIVE = NO
               lib-item-fat.cod-estab-pad  :SENSITIVE = NO
               Btn_Cancel                  :SENSITIVE = NO
               Btn_Pendente                :SENSITIVE = NO.

        /* Code placed here will execute AFTER standard behavior.    */
        FIND FIRST ITEM WHERE ITEM.it-codigo = lib-item-fat.it-codigo:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF AVAIL ITEM THEN
            ASSIGN c-desc-item                :SCREEN-VALUE = ITEM.desc-item
                   lib-item-fat.cod-estab-pad :SCREEN-VALUE = ITEM.cod-estabel
                   rs-tipo                    :SCREEN-VALUE = '1'
                   lib-item-fat.usuario       :SCREEN-VALUE = c-seg-usuario
                   lib-item-fat.dt-solicitacao:SCREEN-VALUE = string(TODAY)
                   lib-item-fat.hr-solicitacao:SCREEN-VALUE = STRING(TIME,'HH:MM')
                   lib-item-fat.c-status      :SCREEN-VALUE = 'Solicitacao Gerada'.
        ELSE DO:
            run utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "ITEM inv lido. ~~ " +
                                     "ITEM NÆo cadastrado NO EMS.").
            ASSIGN lib-item-fat.it-codigo:SCREEN-VALUE = ''.
            APPLY 'ENTRY' TO lib-item-fat.it-codigo.
            RETURN 'ADM-ERROR':U.
        END.

/*         IF  SUBSTRING(lib-item-fat.it-codigo:SCREEN-VALUE,1,1) <> '2'                                                     */
/*         AND SUBSTRING(lib-item-fat.it-codigo:SCREEN-VALUE,1,1) <> '4' THEN DO:                                            */
/*                                                                                                                           */
/*             IF NOT CAN-FIND(FIRST movto-estoq WHERE movto-estoq.it-codigo = lib-item-fat.it-codigo:SCREEN-VALUE) THEN DO: */
/*                 run utp/ut-msgs.p (INPUT "show":U,                                                                        */
/*                                    INPUT 17006,                                                                           */
/*                                    INPUT "ITEM inv lido. ~~ " +                                                           */
/*                                          "ITEM sem movimento de estoque.").                                               */
/*                 ASSIGN lib-item-fat.it-codigo:SCREEN-VALUE = ''.                                                          */
/*                 APPLY 'ENTRY' TO lib-item-fat.it-codigo.                                                                  */
/*                 RETURN 'ADM-ERROR':U.                                                                                     */
/*             END.                                                                                                          */
/*                                                                                                                           */
/*         END.                                                                                                              */

    END.

    FIND LAST lib-item-fat NO-LOCK NO-ERROR.
    IF AVAIL lib-item-fat THEN
        ASSIGN lib-item-fat.cod-solicitacao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(lib-item-fat.cod-solicitacao + 1).
    ELSE 
        ASSIGN lib-item-fat.cod-solicitacao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '1'.

    FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-LOCK NO-ERROR.
    ASSIGN c-nome:SCREEN-VALUE = usuar_mestre.nom_usuar.

    IF lib-item-fat.it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> '' THEN DO:
        IF VALID-HANDLE(h-browserCamposLib) THEN
            RUN pi-CriaTT IN h-browserCamposLib (INPUT lib-item-fat.cod-estab-pad:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                                 INPUT lib-item-fat.it-codigo    :SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                                 OUTPUT l-desabilitaBt).

        IF VALID-HANDLE(h-browserEstabsLib) THEN
            RUN pi-CriaTT IN h-browserEstabsLib  (INPUT lib-item-fat.it-codigo   :SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                                  INPUT l-desabilitaBt).
    END. /* IF lib-item-fat.it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> '' THEN DO: */
    IF VALID-HANDLE(h-browserEstabsLib) THEN
        RUN pi-desabilitaLibera IN h-browserEstabsLib.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lib-item-fat.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF lib-item-fat.it-codigo IN FRAME f-main /* Item */
DO:
  
    APPLY 'f5' TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-tipo V-table-Win
ON LEAVE OF rs-tipo IN FRAME f-main
DO:
  
    DO WITH FRAME {&FRAME-NAME}:
        IF INPUT rs-tipo = 1 THEN
            ASSIGN lib-item-fat.cod-estab-trans-orig:SENSITIVE    = NO
                   lib-item-fat.cod-estab-trans-dest:SENSITIVE    = NO
                   lib-item-fat.cod-estab-trans-orig:SCREEN-VALUE = ''
                   lib-item-fat.cod-estab-trans-dest:SCREEN-VALUE = ''.
        ELSE
            ASSIGN lib-item-fat.cod-estab-trans-orig:SENSITIVE = YES
                   lib-item-fat.cod-estab-trans-dest:SENSITIVE = YES.


    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-tipo V-table-Win
ON VALUE-CHANGED OF rs-tipo IN FRAME f-main
DO:
  
    DO WITH FRAME {&FRAME-NAME}:
        IF INPUT rs-tipo = 1 THEN
            ASSIGN lib-item-fat.cod-estab-trans-orig:SENSITIVE    = NO
                   lib-item-fat.cod-estab-trans-dest:SENSITIVE    = NO
                   lib-item-fat.cod-estab-trans-orig:SCREEN-VALUE = ''
                   lib-item-fat.cod-estab-trans-dest:SCREEN-VALUE = ''.
        ELSE
            ASSIGN lib-item-fat.cod-estab-trans-orig:SENSITIVE = YES
                   lib-item-fat.cod-estab-trans-dest:SENSITIVE = YES.


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
  
    if lib-item-fat.it-codigo   :load-mouse-pointer ("image/lupa.cur") then.

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win  adm/support/_key-fnd.p
PROCEDURE adm-find-using-key :
/*------------------------------------------------------------------------------
  Purpose:     Finds the current record using the contents of
               the 'Key-Name' and 'Key-Value' attributes.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-new-record V-table-Win 
PROCEDURE adm-new-record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*     IF VALID-HANDLE(h-browserCamposLib) THEN                                                                       */
/*         RUN pi-CriaTT IN h-browserCamposLib (INPUT lib-item-fat.cod-estab-pad:SCREEN-VALUE IN FRAME {&FRAME-NAME}, */
/*                                              INPUT lib-item-fat.it-codigo  :SCREEN-VALUE IN FRAME {&FRAME-NAME}).  */
/*                                                                                                                    */
/*     IF VALID-HANDLE(h-browserEstabsLib) THEN                                                                       */
/*         RUN pi-CriaTT IN h-browserEstabsLib  (INPUT 'NEW').                                                        */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  {src/adm/template/row-list.i "lib-item-fat"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "lib-item-fat"}

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


    IF  lib-item-fat.c-status:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> 'Pendente'
    AND lib-item-fat.c-status:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> 'Transf. Aprovada' 
    AND lib-item-fat.c-status:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> 'Cancelado'THEN
        RUN pi-validate.

    /* Code placed here will execute PRIOR to standard behavior. */
    /*   if  not frame {&frame-name}:validate() then */
    /*       return 'ADM-ERROR':U.                   */
    /*:T Ponha na pi-validate todas as valida‡äes */
    /*:T NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    DO TRANSACTION:
        /* Dispatch standard ADM method.                             */
        RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
        if RETURN-VALUE = 'ADM-ERROR':U then 
            return 'ADM-ERROR':U.

        IF  rs-tipo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '1' 
        AND adm-new-record = YES THEN
            RUN pi-estabs.

        IF l-retorna = NO THEN
            UNDO,LEAVE. 
    END.
    /*:T Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
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
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    DISABLE lib-item-fat.usuario        WITH FRAME {&FRAME-NAME}.
    DISABLE lib-item-fat.dt-solicitacao WITH FRAME {&FRAME-NAME}.
    DISABLE lib-item-fat.hr-solicitacao WITH FRAME {&FRAME-NAME}.
    DISABLE lib-item-fat.c-status       WITH FRAME {&FRAME-NAME}.

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
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    DISABLE lib-item-fat.usuario        WITH FRAME {&FRAME-NAME}.
    DISABLE lib-item-fat.dt-solicitacao WITH FRAME {&FRAME-NAME}.
    DISABLE lib-item-fat.hr-solicitacao WITH FRAME {&FRAME-NAME}.
    DISABLE lib-item-fat.c-status       WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .


  IF lib-item-fat.c-status:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = 'Cancelado' THEN
      ASSIGN Btn_Cancel:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  ELSE DO:
      FIND FIRST lib-item-fat 
          WHERE lib-item-fat.cod-solicitacao = integer(lib-item-fat.cod-solicitacao:SCREEN-VALUE IN FRAME {&FRAME-NAME}) NO-LOCK NO-ERROR.
      IF AVAIL lib-item-fat THEN
          ASSIGN Btn_Cancel  :SENSITIVE IN FRAME {&FRAME-NAME}    = YES
                 rs-tipo     :SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF lib-item-fat.log-1 = YES THEN '1' ELSE '2'
                 lib-item-fat.cod-estab-trans-orig:SCREEN-VALUE IN FRAME {&FRAME-NAME} = lib-item-fat.cod-estab-trans-orig
                 lib-item-fat.cod-estab-trans-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME} = lib-item-fat.cod-estab-trans-dest
                 .
      ELSE
          ASSIGN Btn_Cancel  :SENSITIVE IN FRAME {&FRAME-NAME}    = NO.
  END.

  /* Code placed here will execute AFTER standard behavior.    */
  FIND FIRST ITEM WHERE ITEM.it-codigo = lib-item-fat.it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK NO-ERROR.
  IF AVAIL ITEM THEN
      ASSIGN c-desc-item               :SCREEN-VALUE IN FRAME {&FRAME-NAME}  = ITEM.desc-item
             lib-item-fat.cod-estab-pad:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = ITEM.cod-estabel.

  FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = lib-item-fat.usuario:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK NO-ERROR.
  IF AVAIL usuar_mestre THEN
    ASSIGN c-nome:SCREEN-VALUE IN FRAME {&FRAME-NAME} = usuar_mestre.nom_usuar.

  IF (lib-item-fat.c-status:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = 'Liberado' 
  OR  lib-item-fat.c-status:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = 'Cancelado' 
  OR  lib-item-fat.c-status:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = 'Transf. Aprovada') THEN
      ASSIGN Btn_Cancel:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

  ASSIGN Btn_Pendente:SENSITIVE IN FRAME {&FRAME-NAME} = NO
         Btn_ApLib:SENSITIVE IN FRAME {&FRAME-NAME}    = NO.  

  IF  lib-item-fat.c-status:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Aguardando Liberacao" 
  AND rs-tipo:SCREEN-VALUE IN FRAME {&FRAME-NAME}               = '1' THEN DO:

    FIND FIRST usu-lib-item-fat WHERE usu-lib-item-fat.cod-usuario = c-seg-usuario NO-LOCK NO-ERROR.
    IF AVAIL usu-lib-item-fat THEN DO:
        IF usu-lib-item-fat.gerencial THEN 
            ASSIGN Btn_Pendente:SENSITIVE IN FRAME {&FRAME-NAME}    = YES.
    END. /* IF AVAIL usu-lib-item-fat THEN DO: */

  END.

/*   IF lib-item-fat.c-status:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Pendente"                            */
/*   AND rs-tipo:SCREEN-VALUE IN FRAME {&FRAME-NAME}              = '1'  THEN DO:                         */
/*       FIND FIRST usu-lib-item-fat WHERE usu-lib-item-fat.cod-usuario = c-seg-usuario NO-LOCK NO-ERROR. */
/*       IF AVAIL usu-lib-item-fat THEN DO:                                                               */
/*           IF usu-lib-item-fat.gerencial THEN                                                           */
/*               ASSIGN Btn_ApLib:SENSITIVE IN FRAME {&FRAME-NAME}    = YES.                              */
/*       END. /* IF AVAIL usu-lib-item-fat THEN DO: */                                                    */
/*   END.                                                                                                 */

  IF  lib-item-fat.c-status:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Aguardando Liberacao" 
  AND rs-tipo:SCREEN-VALUE IN FRAME {&FRAME-NAME}               = '2' THEN DO:
      FIND FIRST usu-lib-item-fat WHERE usu-lib-item-fat.cod-usuario = c-seg-usuario NO-LOCK NO-ERROR.
      IF AVAIL usu-lib-item-fat THEN DO:
          IF usu-lib-item-fat.gerencial THEN 
              ASSIGN Btn_ApLib:SENSITIVE IN FRAME {&FRAME-NAME}    = YES.
      END. /* IF AVAIL usu-lib-item-fat THEN DO: */
  END.

  IF lib-item-fat.it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> '' THEN DO:
      IF VALID-HANDLE(h-browserCamposLib) THEN DO:
          RUN pi-CriaTT IN h-browserCamposLib (INPUT lib-item-fat.cod-estab-pad:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                               INPUT lib-item-fat.it-codigo    :SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                               OUTPUT l-desabilitaBt).
      END.

      IF VALID-HANDLE(h-browserEstabsLib) THEN DO:
          RUN pi-CriaTT IN h-browserEstabsLib  (INPUT lib-item-fat.it-codigo   :SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                                INPUT l-desabilitaBt).
      END.
  END. /* IF lib-item-fat.it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> '' THEN DO: */

  IF  /*lib-item-fat.c-status:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "Pendˆncia Liberada" 
  AND lib-item-fat.c-status:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "Transf. Aprovada" 
  AND*/ lib-item-fat.c-status:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "Solicitacao Gerada" THEN DO:
      IF VALID-HANDLE(h-browserEstabsLib) THEN
          RUN pi-desabilitaLibera IN h-browserEstabsLib.
  END.

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
    define input parameter v-row-parent-externo as rowid no-undo.
    
    assign v-row-parent = v-row-parent-externo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualizaStatus V-table-Win 
PROCEDURE pi-atualizaStatus :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FIND CURRENT lib-item-fat NO-LOCK NO-ERROR.
IF AVAIL lib-item-fat THEN 
    ASSIGN lib-item-fat.c-status:SCREEN-VALUE IN FRAME {&FRAME-NAME} = lib-item-fat.c-status.

IF lib-item-fat.c-status:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Aguardando Liberacao' THEN DO:
    FIND FIRST usu-lib-item-fat WHERE usu-lib-item-fat.cod-usuario = c-seg-usuario NO-LOCK NO-ERROR.
    IF AVAIL usu-lib-item-fat THEN DO:
        IF usu-lib-item-fat.gerencial THEN 
            ASSIGN Btn_Pendente:SENSITIVE IN FRAME {&FRAME-NAME}    = YES.
    END. /* IF AVAIL usu-lib-item-fat THEN DO: */
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-criaVariosEstabs V-table-Win 
PROCEDURE pi-criaVariosEstabs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE i-solicitacao LIKE lib-item-fat.cod-solicitacao  NO-UNDO.

DEFINE INPUT PARAMETER c-estabVinculados LIKE lib-item-fat.cod-estab-vinculado   NO-UNDO.

    FIND FIRST lib-item-fat EXCLUSIVE-LOCK 
        WHERE lib-item-fat.cod-solicitacao = INPUT FRAME {&FRAME-NAME} lib-item-fat.cod-solicitacao NO-ERROR.
    IF AVAIL lib-item-fat THEN DO:
        ASSIGN lib-item-fat.cod-estab-vinculado = c-estabVinculados
               lib-item-fat.log-1               = IF INPUT FRAME {&FRAME-NAME} rs-tipo = 1 THEN YES ELSE NO.
    END. /* IF AVAIL lib-item-fat THEN DO: */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-Estabs V-table-Win 
PROCEDURE pi-Estabs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN esp/ftp/esftp031b.w (INPUT lib-item-fat.it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                             OUTPUT l-retorna).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*:T------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE l-fatura AS LOGICAL  INIT NO   NO-UNDO.
    {include/i-vldfrm.i} /*:T Valida‡Æo de dicion rio */

    IF l-retorna = YES THEN DO:
        
        FOR EACH estabelec NO-LOCK:

            IF (estabelec.cod-estabel = '102'
            OR  estabelec.cod-estabel = '201'
            OR  estabelec.cod-estabel = '301') THEN NEXT.

            FIND FIRST item-uni-estab
                WHERE item-uni-estab.it-codigo    = lib-item-fat.it-codigo:SCREEN-VALUE IN FRAME f-main
                  AND item-uni-estab.cod-estabel  = estabelec.cod-estabel NO-LOCK NO-ERROR.
            IF AVAIL item-uni-estab THEN DO:

                IF item-uni-estab.ind-item-fat = NO THEN
                    ASSIGN l-fatura = YES.

            END.

        END.

        IF l-fatura = NO THEN DO:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "ITEM Faturavel. ~~ " +
                                     "Nao e permitido solicitacao para itens faturaveis em todos os estabelecimentos.").
            APPLY 'ENTRY' TO lib-item-fat.it-codigo.
            RETURN 'ADM-ERROR':U.
        END.

        IF SUBSTRING(lib-item-fat.it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME},1,3) = '187' THEN DO:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "ITEM inv lido. ~~ " +
                                     "Nao e permitido solicitacao para itens iniciados com 187. Solicitar para itens iniciados com 4.").
            APPLY 'ENTRY' TO lib-item-fat.it-codigo.
            RETURN 'ADM-ERROR':U.
        END. /* IF substring(lib-item-fat.it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = '187' THEN DO: */


        FIND FIRST ITEM WHERE ITEM.it-codigo = lib-item-fat.it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK NO-ERROR.
        IF NOT AVAIL ITEM THEN DO:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "ITEM inv lido. ~~ " +
                                     "ITEM NÆo cadastrado no EMS.").
            APPLY 'ENTRY' TO lib-item-fat.it-codigo.
            RETURN 'ADM-ERROR':U.
        END.

        IF rs-tipo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '2' THEN DO:


            FIND FIRST lib-item-fat
                WHERE  lib-item-fat.it-codigo             =  lib-item-fat.it-codigo           :SCREEN-VALUE IN FRAME {&FRAME-NAME}
                  AND  lib-item-fat.cod-estab-trans-orig  =  lib-item-fat.cod-estab-trans-orig:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                  AND  lib-item-fat.cod-estab-trans-dest  =  lib-item-fat.cod-estab-trans-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                  AND  lib-item-fat.c-status             <> "Transf. Aprovada"
                  AND  lib-item-fat.c-status             <> "Cancelado"   NO-LOCK NO-ERROR.
            IF AVAIL lib-item-fat THEN DO:
                {include/i-vldprg.i}
                run utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 17006,
                                   INPUT "Transferˆncia Inv lida. ~~ " +
                                         "Transferˆncia j  existe. Solicita‡Æo : " + STRING(lib-item-fat.cod-solicitacao) + ".").
                APPLY 'ENTRY' TO lib-item-fat.it-codigo.
                RETURN 'ADM-ERROR':U.
            END. /* IF AVAIL lib-item-fat THEN DO: */


            FOR FIRST reg-inf-compl NO-LOCK
                WHERE reg-inf-compl.cod-tab-inform   = "FCI":U
                AND   reg-inf-compl.cod-campo-inform = "FCI":U:

                IF CAN-FIND(FIRST  inf-compl NO-LOCK
                            WHERE  inf-compl.cdn-identif                           = reg-inf-compl.cdn-identif /*6*/
                              AND (NUM-ENTRIES(TRIM(inf-compl.cod-indice),CHR(2)) >= 2
                              AND  ENTRY(2,TRIM(inf-compl.cod-indice),CHR(2))      = lib-item-fat.it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME})) THEN DO:
                    {include/i-vldprg.i}
                    run utp/ut-msgs.p (INPUT "show":U,
                                       INPUT 17006,
                                       INPUT "ITEM inv lido. ~~ " +
                                             "ITEM possui FCI.").
                    APPLY 'ENTRY' TO lib-item-fat.it-codigo.
                    RETURN 'ADM-ERROR':U.
                END. /* IF CAN-FIND(FIRST  inf-compl NO-LOCK */

            END. /* FOR FIRST reg-inf-compl NO-LOCK */

            FIND FIRST estabelec WHERE estabelec.cod-estabel = lib-item-fat.cod-estab-trans-orig:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK NO-ERROR.
            IF NOT AVAIL estabelec THEN DO: 
                run utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 17006,
                                   INPUT "Estabelecimento Origem inv lido. ~~ " +
                                         "Estabelecimento NÆo cadastrado NO EMS.").
                APPLY 'ENTRY' TO lib-item-fat.cod-estab-trans-orig.
                RETURN 'ADM-ERROR':U.
            END.


            FIND FIRST estabelec WHERE estabelec.cod-estabel = lib-item-fat.cod-estab-trans-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK NO-ERROR.
            IF NOT AVAIL estabelec THEN DO: 
                run utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 17006,
                                   INPUT "Estabelecimento Destino inv lido. ~~ " +
                                         "Estabelecimento NÆo cadastrado NO EMS.").
                APPLY 'ENTRY' TO lib-item-fat.cod-estab-trans-dest.
                RETURN 'ADM-ERROR':U.
            END.

            FIND FIRST estabele
                WHERE estabelec.cod-estabel = lib-item-fat.cod-estab-trans-orig:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK NO-ERROR.
            IF AVAIL estabelec THEN DO:

                FIND FIRST b-estabelec WHERE b-estabelec.cod-estabel = lib-item-fat.cod-estab-trans-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK NO-ERROR.
                IF AVAIL b-estabelec THEN DO:

                    IF estabelec.estado = b-estabelec.estado THEN DO:

                        run utp/ut-msgs.p (INPUT "show":U,
                                           INPUT 17006,
                                           INPUT "Estabelecimentos divergentes. ~~ " +
                                                 "Entrega de mercadoria dentro do Estado de Origem.").
                        APPLY 'ENTRY' TO lib-item-fat.cod-estab-trans-dest.
                        RETURN 'ADM-ERROR':U.

                    END. /* IF estabelec.estado = b-estabelec.estado THEN DO: */

                END. /* IF AVAIL b-estabelec THEN DO: */

            END. /* IF AVAIL estabelec THEN DO: */

            IF CAN-FIND (FIRST lib-item-fat
                WHERE lib-item-fat.it-codigo             = lib-item-fat.it-codigo           :SCREEN-VALUE IN FRAME {&FRAME-NAME}
                  AND lib-item-fat.cod-estab-trans-orig  = lib-item-fat.cod-estab-trans-orig:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                  AND lib-item-fat.cod-estab-trans-dest  = lib-item-fat.cod-estab-trans-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                  AND lib-item-fat.c-status              = 'Solicitacao Gerada') THEN DO:
                run utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 17006,
                                   INPUT "Registro j  existe. ~~ " +
                                         "Solicita‡Æo " + string(lib-item-fat.cod-solicitacao) + " - STATUS " + lib-item-fat.c-status + ".").
                ASSIGN lib-item-fat.it-codigo  :SCREEN-VALUE = ''
                       lib-item-fat.cod-estab-pad:SCREEN-VALUE = ''.
                APPLY 'ENTRY' TO lib-item-fat.it-codigo.
                RETURN 'ADM-ERROR':U.
            END. /* IF AVAIL lib-item-fat THEN DO: */

            IF lib-item-fat.cod-estab-trans-orig:SCREEN-VALUE IN FRAME {&FRAME-NAME} = lib-item-fat.cod-estab-trans-dest:SCREEN-VALUE IN FRAME {&FRAME-NAME} THEN DO:
                run utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 17006,
                                   INPUT "Estabelecimento Origem / Destino inv lidos. ~~ " +
                                         "Estabelecimento NÆo podem ser iguais.").
                APPLY 'ENTRY' TO lib-item-fat.cod-estab-trans-dest.
                RETURN 'ADM-ERROR':U.
            END.
            ASSIGN l-retorna= YES.

        END. /* IF rs-tipo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '2' THEN DO: */

    END.


/*     RUN pi-Estabs. */


/*:T    Segue um exemplo de valida‡Æo de programa */
/*       find tabela where tabela.campo1 = c-variavel and               */
/*                         tabela.campo2 > i-variavel no-lock no-error. */
      
      /*:T Este include deve ser colocado sempre antes do ut-msgs.p */
/*       {include/i-vldprg.i}                                             */
/*       run utp/ut-msgs.p (input "show":U, input 7, input return-value). */
/*       return 'ADM-ERROR':U.                                            */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEnviaEmail V-table-Win 
PROCEDURE piEnviaEmail :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAM premetente AS CHAR FORMAT 'x(60)'  NO-UNDO.
    DEFINE INPUT  PARAM pDestino   AS CHAR FORMAT 'x(60)'  NO-UNDO.
    DEFINE INPUT  PARAM pAssunto   AS CHAR FORMAT 'x(60)'  NO-UNDO.
    DEFINE INPUT  PARAM pDescEmail AS CHAR FORMAT 'x(250)' NO-UNDO.
    DEFINE INPUT  PARAM pArquivo   AS CHAR FORMAT 'x(60)'  NO-UNDO.

    DEF VAR icont AS INT. 
    FOR FIRST param-global NO-LOCK: END.    

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    FOR EACH tt-envio2.   DELETE tt-envio2.   END.
    FOR EACH tt-mensagem. DELETE tt-mensagem. END.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
           tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
           tt-envio2.destino           = pdestino                 /* Destinatÿrio       */ 
           tt-envio2.remetente         = pRemetente               /* Remetente          */ 
           tt-envio2.assunto           = pAssunto                 /* Assunto            */
           tt-envio2.arq-anexo         = pArquivo                 /* Arquivo Temporÿrio */
           tt-envio2.formato           = "TEXTO".
    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = pDescEmail.          /* Mensagem           */


    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).
    FIND FIRST tt-erros NO-LOCK NO-ERROR.
    /*
    for each tt-erros:
        put tt-erros.desc-erro.
    end.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "it-codigo" "lib-item-fat" "it-codigo"}
  {src/adm/template/sndkycas.i "usuario" "lib-item-fat" "usuario"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

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
  {src/adm/template/snd-list.i "lib-item-fat"}

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
  run pi-trata-state (p-issuer-hdl, p-state).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

