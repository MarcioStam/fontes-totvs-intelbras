&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
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

&GLOBAL-DEFINE Program        esacr084
&GLOBAL-DEFINE Version        2.00.000.001
&SCOPED-DEFINE RPC-CALL       esp/cpp/escpp058rpc.r

/* &SCOPED-DEFINE SERVIDOR-TESTE rpc21te */


/* Local Variable Definitions ---    */
DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar AS CHAR NO-UNDO.
def new global shared var v_cod_usuar_corren as char no-undo.

DEF VAR raw-tit-acr     AS RAW                        NO-UNDO.
DEF VAR v_dat_ult_envio LIKE tit_acr_deps.dat_gerac   NO-UNDO.
DEF VAR v_log_integra   LIKE tit_acr_deps.log_integra NO-UNDO.
DEF VAR h-acomp         AS HANDLE                     NO-UNDO.
DEF VAR v_nom_abrev     LIKE emitente.nome-abrev      NO-UNDO.

{esp/es0018.i}
{esp/cpp/escpp058.i}
{esp/esb/esesb000.i}

DEFINE TEMP-TABLE tt-dados-csv NO-UNDO
    FIELD i-linha    AS INTEGER
    FIELD i-coluna   AS INTEGER
    FIELD c-conteudo AS CHARACTER
    INDEX ch-primaria IS PRIMARY UNIQUE
        i-linha
        i-coluna.

DEF TEMP-TABLE tt_tit_acr NO-UNDO
    FIELD cod_estab          LIKE tit_acr.cod_estab
    FIELD cod_espec_docto    LIKE tit_acr.cod_espec_docto 
    FIELD cod_ser_docto      LIKE tit_acr.cod_ser_docto  
    FIELD cod_tit_acr        LIKE tit_acr.cod_tit_acr  
    FIELD cod_parcela        LIKE tit_acr.cod_parcela 
    FIELD cdn_cliente        LIKE tit_acr.cdn_cliente 
    FIELD cod_portador       LIKE tit_acr.cod_portador 
    FIELD cod_cart_bcia      LIKE tit_acr.cod_cart_bcia   
    FIELD dat_emis_docto     LIKE tit_acr.dat_emis_docto 
    FIELD dat_transacao      LIKE tit_acr.dat_transacao 
    FIELD dat_vencto_tit_acr LIKE tit_acr.dat_vencto_tit_acr 
    FIELD nom_abrev          LIKE tit_acr.nom_abrev 
    FIELD val_origin_tit_acr LIKE tit_acr.val_origin_tit_acr 
    FIELD val_sdo_tit_acr    LIKE tit_acr.val_sdo_tit_acr
    FIELD dat_ult_envio      LIKE tit_acr_deps.dat_gerac
    FIELD selecionado        AS CHAR
    FIELD log_integra        AS LOG FORMAT "Sim/N∆o"
    FIELD num_id_tit_acr     LIKE tit_acr.num_id_tit_acr.

DEF TEMP-TABLE tt_tit_acr_deps NO-UNDO
    FIELD cod_estab      LIKE tit_acr_deps.cod_estab
    FIELD num_id_tit_acr LIKE tit_acr_deps.num_id_tit_acr.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-saldo

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt_tit_acr

/* Definitions for BROWSE br-saldo                                      */
&Scoped-define FIELDS-IN-QUERY-br-saldo tt_tit_acr.selecionado tt_tit_acr.cod_estab tt_tit_acr.cod_espec_docto tt_tit_acr.cod_ser_docto tt_tit_acr.cod_tit_acr tt_tit_acr.cod_parcela tt_tit_acr.cod_portador tt_tit_acr.cod_cart_bcia tt_tit_acr.dat_emis_docto tt_tit_acr.dat_transacao tt_tit_acr.dat_vencto_tit_acr tt_tit_acr.val_origin_tit_acr tt_tit_acr.val_sdo_tit_acr tt_tit_acr.dat_ult_envio tt_tit_acr.log_integra   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-saldo   
&Scoped-define SELF-NAME br-saldo
&Scoped-define QUERY-STRING-br-saldo FOR EACH tt_tit_acr
&Scoped-define OPEN-QUERY-br-saldo OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr.
&Scoped-define TABLES-IN-QUERY-br-saldo tt_tit_acr
&Scoped-define FIRST-TABLE-IN-QUERY-br-saldo tt_tit_acr


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-saldo}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tg_cancelados rs_enviados v_estab_ini ~
v_estab_fim v_cli_ini v_cli_fim v_dat_emis_ini v_dat_emis_fim ~
v_dat_venc_ini v_dat_venc_fim tg_normal tg_antecip btCarrega bt_envia ~
btExit bt_envio_csv bt_dias_negoc bt_data_negoc RECT-1 RECT-2 IMAGE-34 ~
IMAGE-47 IMAGE-48 IMAGE-33 IMAGE-50 IMAGE-51 RECT-3 RECT-4 IMAGE-52 ~
br-saldo IMAGE-53 
&Scoped-Define DISPLAYED-OBJECTS tg_cancelados rs_enviados v_estab_ini ~
v_estab_fim v_cli_ini v_cli_fim v_dat_emis_ini v_dat_emis_fim ~
v_dat_venc_ini v_dat_venc_fim tg_normal tg_antecip 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btCarrega 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Carregar t°tulos" 
     SIZE 4 BY 1.25 TOOLTIP "Carregar t°tulos".

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25 TOOLTIP "Sair"
     FONT 4.

DEFINE BUTTON bt_data_negoc 
     IMAGE-UP FILE "image/im-calend.bmp":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Ajusta data negociaá∆o pedidos DEPS" 
     SIZE 4 BY 1.25 TOOLTIP "Ajusta data negociaá∆o pedidos DEPS"
     FONT 4.

DEFINE BUTTON bt_dias_negoc 
     IMAGE-UP FILE "image/im-calen.bmp":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Ajusta dias negociaá∆o pedidos DEPS" 
     SIZE 4 BY 1.25 TOOLTIP "Ajusta dias negociaá∆o pedidos DEPS"
     FONT 4.

DEFINE BUTTON bt_envia 
     IMAGE-UP FILE "IMAGE/im-send.bmp":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Envia t°tulo ao DEPS" 
     SIZE 4 BY 1.25 TOOLTIP "Envia apenas o t°tulo selecionado ao DEPS"
     FONT 4.

DEFINE BUTTON bt_envio_csv 
     IMAGE-UP FILE "image/im-send.bmp":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Envia t°tulo ao DEPS" 
     SIZE 4 BY 1.25 TOOLTIP "Envia t°tulos ao DEPS com base em planilha CSV"
     FONT 4.

DEFINE VARIABLE v_cli_fim AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79 NO-UNDO.

DEFINE VARIABLE v_cli_ini AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE v_dat_emis_fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE v_dat_emis_ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Dt Emiss∆o" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79 NO-UNDO.

DEFINE VARIABLE v_dat_venc_fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .79 NO-UNDO.

DEFINE VARIABLE v_dat_venc_ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Dt Vencimento" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79 NO-UNDO.

DEFINE VARIABLE v_estab_fim AS CHARACTER FORMAT "x(5)" INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE v_estab_ini AS CHARACTER FORMAT "x(5)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE IMAGE IMAGE-33
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-34
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-47
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-48
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-50
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-51
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-52
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-53
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE VARIABLE rs_enviados AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Enviados", 1,
"N∆o Enviados", 2,
"Ambos", 3
     SIZE 13 BY 2.75 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 66 BY 5.25.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 24 BY 5.25.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 6 BY 19.25.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 23 BY 5.25.

DEFINE VARIABLE tg_antecip AS LOGICAL INITIAL yes 
     LABEL "Antecipaá‰es" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .83 NO-UNDO.

DEFINE VARIABLE tg_cancelados AS LOGICAL INITIAL yes 
     LABEL "Cancelados" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg_normal AS LOGICAL INITIAL yes 
     LABEL "Normais" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-saldo FOR 
      tt_tit_acr SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-saldo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-saldo wWindow _FREEFORM
  QUERY br-saldo DISPLAY
      tt_tit_acr.selecionado COLUMN-LABEL "Sel" FORMAT "x(3)"
tt_tit_acr.cod_estab      
tt_tit_acr.cod_espec_docto      
tt_tit_acr.cod_ser_docto FORMAT "x(05)"
tt_tit_acr.cod_tit_acr 
tt_tit_acr.cod_parcela
tt_tit_acr.cod_portador
tt_tit_acr.cod_cart_bcia
tt_tit_acr.dat_emis_docto
tt_tit_acr.dat_transacao  
tt_tit_acr.dat_vencto_tit_acr  
tt_tit_acr.val_origin_tit_acr  
tt_tit_acr.val_sdo_tit_acr
tt_tit_acr.dat_ult_envio COLUMN-LABEL "Dt Èlt Envio"
tt_tit_acr.log_integra COLUMN-LABEL "Integrado" FORMAT "Sim/N∆o"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 115 BY 13.75
         FONT 1
         TITLE "T÷TULOS DEPS" ROW-HEIGHT-CHARS .5 TOOLTIP "Duplo clique para marcar/desmarcar t°tulo a ser enviado ao DEPS".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tg_cancelados AT ROW 5 COL 74 WIDGET-ID 428
     rs_enviados AT ROW 2.5 COL 99 NO-LABEL WIDGET-ID 408
     v_estab_ini AT ROW 2.25 COL 27 COLON-ALIGNED WIDGET-ID 32
     v_estab_fim AT ROW 2.25 COL 41 COLON-ALIGNED NO-LABEL
     v_cli_ini AT ROW 3.25 COL 20 COLON-ALIGNED WIDGET-ID 70
     v_cli_fim AT ROW 3.25 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 72
     v_dat_emis_ini AT ROW 4.25 COL 20.29 COLON-ALIGNED WIDGET-ID 74
     v_dat_emis_fim AT ROW 4.25 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 76
     v_dat_venc_ini AT ROW 5.25 COL 20.29 COLON-ALIGNED WIDGET-ID 418
     v_dat_venc_fim AT ROW 5.25 COL 41 COLON-ALIGNED NO-LABEL WIDGET-ID 416
     tg_normal AT ROW 2.5 COL 74 WIDGET-ID 64
     tg_antecip AT ROW 3.75 COL 74 WIDGET-ID 62
     btCarrega AT ROW 2 COL 119 HELP
          "Carregar t°tulos" WIDGET-ID 26
     bt_envia AT ROW 3.5 COL 119 HELP
          "Confirma alteraá‰es" WIDGET-ID 56
     btExit AT ROW 19 COL 119 HELP
          "Sair"
     bt_envio_csv AT ROW 8.75 COL 119 HELP
          "Confirma alteraá‰es" WIDGET-ID 390
     bt_dias_negoc AT ROW 13.25 COL 119 HELP
          "Confirma alteraá‰es" WIDGET-ID 420
     bt_data_negoc AT ROW 14.75 COL 119 HELP
          "Confirma alteraá‰es" WIDGET-ID 422
     br-saldo AT ROW 7 COL 2 WIDGET-ID 200
     "Seleá∆o" VIEW-AS TEXT
          SIZE 7 BY .67 AT ROW 1.25 COL 4 WIDGET-ID 30
     "T°tulos" VIEW-AS TEXT
          SIZE 10 BY .67 AT ROW 1.25 COL 71 WIDGET-ID 38
     "Filtro" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 1.25 COL 96 WIDGET-ID 402
     RECT-1 AT ROW 1.5 COL 2 WIDGET-ID 44
     RECT-2 AT ROW 1.5 COL 69 WIDGET-ID 46
     IMAGE-34 AT ROW 2.25 COL 39 WIDGET-ID 198
     IMAGE-47 AT ROW 3.25 COL 39 WIDGET-ID 200
     IMAGE-48 AT ROW 4.25 COL 39 WIDGET-ID 202
     IMAGE-33 AT ROW 2.25 COL 35 WIDGET-ID 196
     IMAGE-50 AT ROW 3.25 COL 35 WIDGET-ID 386
     IMAGE-51 AT ROW 4.25 COL 35 WIDGET-ID 388
     RECT-3 AT ROW 1.5 COL 118 WIDGET-ID 396
     RECT-4 AT ROW 1.5 COL 94 WIDGET-ID 400
     IMAGE-52 AT ROW 5.25 COL 39 WIDGET-ID 412
     IMAGE-53 AT ROW 5.25 COL 35 WIDGET-ID 414
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 123.57 BY 19.92
         FONT 1 WIDGET-ID 100.


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
         TITLE              = "ESACR084 - Gerais DEPS"
         HEIGHT             = 19.92
         WIDTH              = 123.57
         MAX-HEIGHT         = 27.96
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 27.96
         VIRTUAL-WIDTH      = 195.14
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB br-saldo IMAGE-52 fpage0 */
ASSIGN 
       br-saldo:NUM-LOCKED-COLUMNS IN FRAME fpage0     = 2
       br-saldo:ALLOW-COLUMN-SEARCHING IN FRAME fpage0 = TRUE
       br-saldo:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-saldo
/* Query rebuild information for BROWSE br-saldo
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt_tit_acr.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-saldo */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow /* ESACR084 - Gerais DEPS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.

  RUN piDesconecta.
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  QUIT.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* ESACR084 - Gerais DEPS */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-saldo
&Scoped-define SELF-NAME br-saldo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-saldo wWindow
ON MOUSE-SELECT-DBLCLICK OF br-saldo IN FRAME fpage0 /* T÷TULOS DEPS */
DO:
   /*APPLY "return" TO SELF. */

   IF  AVAIL tt_tit_acr THEN DO:
       FIND CURRENT tt_tit_acr EXCLUSIVE-LOCK NO-ERROR.

       IF  tt_tit_acr.selecionado = "" THEN
           ASSIGN tt_tit_acr.selecionado = "X".
       ELSE
           ASSIGN tt_tit_acr.selecionado = "".

       FIND CURRENT tt_tit_acr NO-LOCK NO-ERROR. 
              
       br-saldo:REFRESH().
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-saldo wWindow
ON ROW-DISPLAY OF br-saldo IN FRAME fpage0 /* T÷TULOS DEPS */
DO:
    /*
    ASSIGN tt_tit_acr.qtd-produzir:BGCOLOR  IN BROWSE br-saldo = 12
           tt_tit_acr.qtd-cartao:BGCOLOR    IN BROWSE br-saldo = 12
           tt_tit_acr.qtd-dispon:BGCOLOR    IN BROWSE br-saldo = 10
           tt_tit_acr.qtd-alocada:BGCOLOR   IN BROWSE br-saldo = 14.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCarrega
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCarrega wWindow
ON CHOOSE OF btCarrega IN FRAME fpage0 /* Carregar t°tulos */
DO:
    RUN pi-carrega-dados IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_data_negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_data_negoc wWindow
ON CHOOSE OF bt_data_negoc IN FRAME fpage0 /* Ajusta data negociaá∆o pedidos DEPS */
DO:
  
    RUN esp/acr/esacr084c.r . /* ajusta data negociaá∆o es0018 */  
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_dias_negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_dias_negoc wWindow
ON CHOOSE OF bt_dias_negoc IN FRAME fpage0 /* Ajusta dias negociaá∆o pedidos DEPS */
DO:
  
    RUN esp/acr/esacr084b.r . /* ajusta dias negociaá∆o es0018 */
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_envia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_envia wWindow
ON CHOOSE OF bt_envia IN FRAME fpage0 /* Envia t°tulo ao DEPS */
DO:
    
    FIND FIRST tt_tit_acr NO-LOCK 
        WHERE  tt_tit_acr.selecionado = "X" NO-ERROR.
    
    IF  AVAIL tt_tit_acr THEN DO:
        MESSAGE "Confirma envio ao DEPS dos t°tulos selecionados ?"
                VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                TITLE "CONFIRMAR ATUALIZAÄ«O" UPDATE v-log-confirma AS LOGICAL.

        IF  v-log-confirma = YES THEN
            RUN pi_envio_msg_deps. 
    
        IF  RETURN-VALUE = "ok" THEN DO:
            MESSAGE "Atualizaá∆o realizada com sucesso !" VIEW-AS ALERT-BOX INFORMATION.
            APPLY "choose" TO btcarrega.
        END.
    END.
    ELSE DO:
        MESSAGE "Nenhum t°tulo foi selecionado para envio a DEPS." VIEW-AS ALERT-BOX ERROR TITLE "N∆o h† t°tulos selecionados.".
        RETURN NO-APPLY.
    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_envio_csv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_envio_csv wWindow
ON CHOOSE OF bt_envio_csv IN FRAME fpage0 /* Envia t°tulo ao DEPS */
DO:
    
    RUN esp/acr/esacr084a.r (INPUT 1).    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


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

  ASSIGN v_dat_emis_ini:SCREEN-VALUE IN FRAME fPage0 = string(TODAY)
         v_dat_emis_fim:SCREEN-VALUE IN FRAME fPage0 = string(TODAY)
         v_dat_venc_ini:SCREEN-VALUE IN FRAME fPage0 = string(TODAY)
         v_dat_venc_fim:SCREEN-VALUE IN FRAME fPage0 = string(TODAY).

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWindow 
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
  THEN DELETE WIDGET wWindow.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWindow 
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
  VIEW FRAME fPage0 IN WINDOW wWindow.

  ENABLE {&ENABLED-OBJECTS} WITH FRAME fPage0.

  DISP {&DISPLAYED-OBJECTS} WITH FRAME fPage0.

  {&OPEN-BROWSERS-IN-QUERY-fPage0}
  VIEW wWindow.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-dados wWindow 
PROCEDURE pi-carrega-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    run pi-inicializar in h-acomp (input "Carregando").

    EMPTY TEMP-TABLE tt_tit_acr.

    FOR EACH estabelecimento NO-LOCK
        WHERE estabelecimento.cod_empresa = v_cod_empres_usuar
        AND   estabelecimento.cod_estab  >= INPUT FRAME fPage0 v_estab_ini
        AND   estabelecimento.cod_estab  <= INPUT FRAME fPage0 v_estab_fim:
        
        FOR EACH emscad.cliente NO-LOCK
            WHERE emscad.cliente.cod_empresa  = estabelecimento.cod_empresa
            AND   emscad.cliente.cdn_cliente >= INPUT FRAME fPage0 v_cli_ini
            AND   emscad.cliente.cdn_cliente <= INPUT FRAME fPage0 v_cli_fim:
    
            FIND FIRST int-emitente NO-LOCK
                WHERE int-emitente.cod-emitente = emscad.cliente.cdn_cliente NO-ERROR.

            IF  AVAIL int-emitente THEN DO:
                RUN esp/es0018p.p (INPUT "dps-canal-cr",
                                   INPUT 1,
                                   INPUT 0,
                                   INPUT "",
                                   OUTPUT TABLE tt-prog-ponto) NO-ERROR.
        
                IF  NOT CAN-FIND (FIRST tt-prog-ponto
                                 WHERE tt-prog-ponto.conteudo = string(int-emitente.cod-gr-cob)) THEN
                    NEXT.
            END.

            FOR EACH tit_acr NO-LOCK
                WHERE tit_acr.cod_estab           = estabelecimento.cod_estab
                AND   tit_acr.cdn_cliente         = emscad.cliente.cdn_cliente:

                run pi-acompanhar in h-acomp (input "Carregando t°tulos - Cliente: " + string(emscad.cliente.cdn_cliente)).

                IF  tit_acr.dat_emis_docto     < INPUT FRAME fPage0 v_dat_emis_ini
                OR  tit_acr.dat_emis_docto     > INPUT FRAME fPage0 v_dat_emis_fim
                OR  tit_acr.dat_vencto_tit_acr < INPUT FRAME fPage0 v_dat_venc_ini
                OR  tit_acr.dat_vencto_tit_acr > INPUT FRAME fPage0 v_dat_venc_fim THEN
                    NEXT.

                ASSIGN v_dat_ult_envio = ?.

                IF  tit_acr.ind_tip_espec_docto <> "Normal"
                AND tit_acr.ind_tip_espec_docto <> "Antecipaá∆o" THEN
                    NEXT.

                IF  tit_acr.ind_tip_espec_docto  = "Normal"
                AND INPUT FRAME fPage0 tg_normal = NO THEN
                    NEXT.

                IF  tit_acr.ind_tip_espec_docto   = "Antecipaá∆o"
                AND INPUT FRAME fPage0 tg_antecip = NO THEN
                    NEXT.

                FOR FIRST tit_acr_deps
                    WHERE tit_acr_deps.cod_estab      = tit_acr.cod_estab      
                    AND   tit_acr_deps.num_id_tit_acr = tit_acr.num_id_tit_acr NO-LOCK:
            
                    ASSIGN v_dat_ult_envio = tit_acr_deps.dat_gerac
                           v_log_integra   = tit_acr_deps.log_integra.
                END.

                IF  INPUT FRAME fPage0 rs_enviados = 1 /* enviados */
                AND v_log_integra                  = NO THEN
                    NEXT.

                IF  INPUT FRAME fPage0 rs_enviados = 2 /* n∆o enviados */
                AND v_log_integra                  = YES THEN
                    NEXT.

                CREATE tt_tit_acr.
                ASSIGN tt_tit_acr.cod_estab          = tit_acr.cod_estab
                       tt_tit_acr.cod_espec_docto    = tit_acr.cod_espec_docto 
                       tt_tit_acr.cod_ser_docto      = tit_acr.cod_ser_docto  
                       tt_tit_acr.cod_tit_acr        = tit_acr.cod_tit_acr  
                       tt_tit_acr.cod_parcela        = tit_acr.cod_parcela 
                       tt_tit_acr.cdn_cliente        = tit_acr.cdn_cliente 
                       tt_tit_acr.cod_portador       = tit_acr.cod_portador 
                       tt_tit_acr.cod_cart_bcia      = tit_acr.cod_cart_bcia   
                       tt_tit_acr.dat_emis_docto     = tit_acr.dat_emis_docto 
                       tt_tit_acr.dat_transacao      = tit_acr.dat_transacao 
                       tt_tit_acr.dat_vencto_tit_acr = tit_acr.dat_vencto_tit_acr 
                       tt_tit_acr.nom_abrev          = tit_acr.nom_abrev 
                       tt_tit_acr.val_origin_tit_acr = tit_acr.val_origin_tit_acr 
                       tt_tit_acr.val_sdo_tit_acr    = tit_acr.val_sdo_tit_acr
                       tt_tit_acr.dat_ult_envio      = v_dat_ult_envio
                       tt_tit_acr.log_integra        = v_log_integra.
            END.
        END.

        /* Busca titulos cancelados */
        IF  INPUT FRAME fPage0 tg_cancelados = yes THEN DO:
            
            FOR EACH tit_acr_deps
                WHERE tit_acr_deps.cod_estab     = estabelecimento.cod_estab
                AND   tit_acr_deps.dados_cancel <> "" NO-LOCK:
    
                IF  int(entry(1,tit_acr_deps.dados_cancel,";")) < INPUT FRAME fPage0 v_cli_ini
                OR  int(entry(1,tit_acr_deps.dados_cancel,";")) > INPUT FRAME fPage0 v_cli_fim THEN
                    NEXT.
    
                IF  date(entry(3,tit_acr_deps.dados_cancel,";")) < INPUT FRAME fPage0 v_dat_emis_ini
                OR  date(entry(3,tit_acr_deps.dados_cancel,";")) > INPUT FRAME fPage0 v_dat_emis_fim
                OR  date(entry(4,tit_acr_deps.dados_cancel,";")) < INPUT FRAME fPage0 v_dat_venc_ini
                OR  date(entry(4,tit_acr_deps.dados_cancel,";")) > INPUT FRAME fPage0 v_dat_venc_fim THEN
                    NEXT.
    
                ASSIGN v_dat_ult_envio = tit_acr_deps.dat_gerac
                       v_log_integra   = tit_acr_deps.log_integra.
    
                IF  INPUT FRAME fPage0 rs_enviados = 1 /* enviados */
                AND v_log_integra                  = NO THEN
                    NEXT.
    
                IF  INPUT FRAME fPage0 rs_enviados = 2 /* nao enviados */
                AND v_log_integra                  = YES THEN
                    NEXT.
    
                ASSIGN v_nom_abrev = "".
    
                FOR FIRST emitente
                    WHERE emitente.cod-emit = int(entry(1,tit_acr_deps.dados_cancel,";")) NO-LOCK:
                    ASSIGN v_nom_abrev = emitente.nome-abrev.
                END.
    
                CREATE tt_tit_acr.
                ASSIGN tt_tit_acr.cod_estab          = tit_acr_deps.cod_estab
                       tt_tit_acr.cod_espec_docto    = entry(10,tit_acr_deps.dados_cancel,";")
                       tt_tit_acr.cod_ser_docto      = entry(11,tit_acr_deps.dados_cancel,";") 
                       tt_tit_acr.cod_tit_acr        = entry(2,tit_acr_deps.dados_cancel,";") 
                       tt_tit_acr.cod_parcela        = entry(6,tit_acr_deps.dados_cancel,";")
                       tt_tit_acr.cdn_cliente        = int(entry(1,tit_acr_deps.dados_cancel,";"))
                       tt_tit_acr.cod_portador       = entry(12,tit_acr_deps.dados_cancel,";") 
                       tt_tit_acr.cod_cart_bcia      = entry(13,tit_acr_deps.dados_cancel,";") 
                       tt_tit_acr.dat_emis_docto     = date(entry(3,tit_acr_deps.dados_cancel,";"))
                       tt_tit_acr.dat_transacao      = date(entry(3,tit_acr_deps.dados_cancel,";"))
                       tt_tit_acr.dat_vencto_tit_acr = date(entry(4,tit_acr_deps.dados_cancel,";"))
                       tt_tit_acr.nom_abrev          = v_nom_abrev
                       tt_tit_acr.val_origin_tit_acr = DEC(entry(7,tit_acr_deps.dados_cancel,";"))
                       tt_tit_acr.val_sdo_tit_acr    = 0
                       tt_tit_acr.dat_ult_envio      = v_dat_ult_envio
                       tt_tit_acr.log_integra        = v_log_integra
                       tt_tit_acr.num_id_tit_acr     = tit_acr_deps.num_id_tit_acr.
            END.
        END.
    END.

    run pi-finalizar in h-acomp.

    {&OPEN-QUERY-br-saldo}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_envio_msg_deps wWindow 
PROCEDURE pi_envio_msg_deps :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    RUN pi-inicializar IN h-acomp (INPUT "Inicializando...").

    FOR EACH tt_tit_acr
        WHERE tt_tit_acr.selecionado = "X" NO-LOCK:
    
        IF  VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Buscando t°tulos: " + tt_tit_acr.cod_tit_acr).

        FIND FIRST tit_acr
            WHERE tit_acr.cod_estab       = tt_tit_acr.cod_estab      
            AND   tit_acr.cod_espec_docto = tt_tit_acr.cod_espec_docto
            AND   tit_acr.cod_ser_docto   = tt_tit_acr.cod_ser_docto  
            AND   tit_acr.cod_tit_acr     = tt_tit_acr.cod_tit_acr    
            AND   tit_acr.cod_parcela     = tt_tit_acr.cod_parcela NO-LOCK NO-ERROR.
    
        IF  AVAIL tit_acr THEN DO:
    
            FIND FIRST tit_acr_deps
                WHERE tit_acr_deps.cod_estab      = tit_acr.cod_estab      
                AND   tit_acr_deps.num_id_tit_acr = tit_acr.num_id_tit_acr EXCLUSIVE-LOCK NO-ERROR.
        
            IF  NOT AVAIL tit_acr_deps THEN DO:
                CREATE tit_acr_deps.
                
                ASSIGN tit_acr_deps.cod_estab      = tit_acr.cod_estab
                       tit_acr_deps.num_id_tit_acr = tit_acr.num_id_tit_acr
                       tit_acr_deps.dat_gerac      = TODAY.
            END.
        
            ASSIGN tit_acr_deps.log_integra = NO
                   tit_acr_deps.dat_gerac   = TODAY.
        
            FIND FIRST tt_tit_acr_deps
                WHERE tt_tit_acr_deps.cod_estab      = tit_acr_deps.cod_estab      
                AND   tt_tit_acr_deps.num_id_tit_acr = tit_acr_deps.num_id_tit_acr NO-LOCK NO-ERROR.
        
            IF  NOT AVAIL tt_tit_acr_deps THEN DO:
                CREATE tt_tit_acr_deps.
                ASSIGN tt_tit_acr_deps.cod_estab      = tit_acr_deps.cod_estab
                       tt_tit_acr_deps.num_id_tit_acr = tit_acr_deps.num_id_tit_acr.
            END.
        END.
        ELSE DO:
            /* cancelados */
            FIND FIRST tt_tit_acr_deps
                WHERE tt_tit_acr_deps.cod_estab      = tt_tit_acr.cod_estab       
                AND   tt_tit_acr_deps.num_id_tit_acr = tt_tit_acr.num_id_tit_acr NO-LOCK NO-ERROR.
        
            IF  NOT AVAIL tt_tit_acr_deps THEN DO:
                CREATE tt_tit_acr_deps.
                ASSIGN tt_tit_acr_deps.cod_estab      = tt_tit_acr.cod_estab     
                       tt_tit_acr_deps.num_id_tit_acr = tt_tit_acr.num_id_tit_acr.
            END.
        END.
    END.
    
    FOR EACH tt_tit_acr_deps:

        IF  VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Enviando t°tulos.").

        FIND FIRST tit_acr
            WHERE  tit_acr.cod_estab      = tt_tit_acr_deps.cod_estab     
            AND    tit_acr.num_id_tit_acr = tt_tit_acr_deps.num_id_tit_acr NO-LOCK NO-ERROR.

        RAW-TRANSFER tt_tit_acr_deps TO raw-tit-acr.
    
        IF  AVAIL tit_acr THEN DO:

            IF  tit_acr.ind_tip_espec_docto = "Normal" THEN DO:
                RUN esp/esb/esesb003.p (INPUT        "msg0097",
                                        INPUT        raw-tit-acr,
                                        OUTPUT TABLE resultado) NO-ERROR.
            END.
        
            IF  tit_acr.ind_tip_espec_docto = "Antecipaá∆o" THEN DO:
                RUN esp/esb/esesb003.p (INPUT        "msg0311",
                                        INPUT        raw-tit-acr,
                                        OUTPUT TABLE resultado) NO-ERROR.
            END.
            
            FIND FIRST tit_acr_deps
                WHERE tit_acr_deps.cod_estab      = tt_tit_acr_deps.cod_estab      
                AND   tit_acr_deps.num_id_tit_acr = tt_tit_acr_deps.num_id_tit_acr EXCLUSIVE-LOCK NO-ERROR.
        
            IF  AVAIL tit_acr_deps THEN
                ASSIGN tit_acr_deps.log_integra = YES.
        END.
        ELSE DO:
            /* cancelados ser∆o integrados pelo esacr076 */
            FIND FIRST tit_acr_deps
                WHERE tit_acr_deps.cod_estab      = tt_tit_acr_deps.cod_estab      
                AND   tit_acr_deps.num_id_tit_acr = tt_tit_acr_deps.num_id_tit_acr EXCLUSIVE-LOCK NO-ERROR.
        
            IF  AVAIL tit_acr_deps THEN
                ASSIGN tit_acr_deps.log_integra = NO
                       tit_acr_deps.dat_gerac   = TODAY.
        END.
    END.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        DELETE PROCEDURE h-acomp.

    ASSIGN h-acomp = ?.

    IF  NOT CAN-FIND(resultado WHERE resultado.sucesso = NO) THEN
        RETURN "OK".
    ELSE
        RETURN "NOK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

