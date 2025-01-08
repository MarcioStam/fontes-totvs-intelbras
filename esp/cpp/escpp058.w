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

&GLOBAL-DEFINE Program        escpp058
&GLOBAL-DEFINE Version        2.04.000.001
&SCOPED-DEFINE RPC-CALL       esp/cpp/escpp058rpc.r

/* &SCOPED-DEFINE SERVIDOR-TESTE rpc21te */


/* Local Variable Definitions ---                                       */
def new global shared var v_cod_usuar_corren as char no-undo.
DEF NEW GLOBAL SHARED VAR v_rotina_intelbras AS CHAR NO-UNDO.

DEF VAR hprog AS HANDLE NO-UNDO.
DEF VAR hproc AS HANDLE NO-UNDO.


DEF VAR c-by            AS CHAR NO-UNDO.

{esp/es0018.i}
{esp/utp/acesso-rpc.i}
{esp/cpp/escpp058.i}

DEFINE TEMP-TABLE tt-dados-csv NO-UNDO
    FIELD i-linha    AS INTEGER
    FIELD i-coluna   AS INTEGER
    FIELD c-conteudo AS CHARACTER
    INDEX ch-primaria IS PRIMARY UNIQUE
        i-linha
        i-coluna.

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
&Scoped-define INTERNAL-TABLES tt-produzir

/* Definitions for BROWSE br-saldo                                      */
&Scoped-define FIELDS-IN-QUERY-br-saldo tt-produzir.log-liberar tt-produzir.cod_unid_neg tt-produzir.it-codigo tt-produzir.desc-item tt-produzir.qtd-produzir tt-produzir.qtd-cartao tt-produzir.qtd-lote-mult tt-produzir.qtd-estoq-max tt-produzir.qtd-aca-101 tt-produzir.qtd-aca-104 tt-produzir.qtd-exp-104 tt-produzir.qtd-transito tt-produzir.qtd-blo-104 tt-produzir.qtd-dispon tt-produzir.qtd-alocada tt-produzir.qtd-sdo-total tt-produzir.dat-liberac tt-produzir.cod-usuar tt-produzir.dat-estorno tt-produzir.cod-usuar-est   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-saldo   
&Scoped-define SELF-NAME br-saldo
&Scoped-define QUERY-STRING-br-saldo FOR EACH tt-produzir
&Scoped-define OPEN-QUERY-br-saldo OPEN QUERY {&SELF-NAME} FOR EACH tt-produzir.
&Scoped-define TABLES-IN-QUERY-br-saldo tt-produzir
&Scoped-define FIRST-TABLE-IN-QUERY-br-saldo tt-produzir


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-saldo}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tg-icon tg-isec tg-inet tg-lib v-dat-corte ~
tg-estoque btCarrega bt-atu bt-csv btExit br-saldo RECT-1 RECT-2 RECT-3 ~
tg-aut tg-fir tg-ace 
&Scoped-Define DISPLAYED-OBJECTS tg-icon tg-isec tg-inet tg-lib v-dat-corte ~
tg-estoque tg-aut tg-fir tg-ace 

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
DEFINE BUTTON bt-atu 
     IMAGE-UP FILE "image\im-sav":U
     IMAGE-INSENSITIVE FILE "image\ii-sav":U
     LABEL "Atualizar" 
     SIZE 4 BY 1.25 TOOLTIP "Atualizar pendˆncias de produ‡Æo para Kanban Eletr“nico"
     FONT 4.

DEFINE BUTTON bt-csv 
     IMAGE-UP FILE "image/excel.bmp":U
     LABEL "CSV" 
     SIZE 4 BY 1.25 TOOLTIP "Exportar informa‡äes para arquivo CSV".

DEFINE BUTTON bt-estornar 
     IMAGE-UP FILE "image\im-undo2":U
     IMAGE-INSENSITIVE FILE "image\ii-undo":U
     LABEL "Estornar" 
     SIZE 4 BY 1.25 TOOLTIP "Estornar libera‡Æo de produ‡Æo para Kanban Eletr“nico".

DEFINE BUTTON btCarrega 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Apresentar" 
     SIZE 4 BY 1.25 TOOLTIP "Apresentar pendˆncias de produ‡Æo para Kanban Eletr“nico".

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE v-dat-corte AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .79 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 58 BY 3.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 22 BY 3.5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 19 BY 3.5.

DEFINE VARIABLE tg-ace AS LOGICAL INITIAL no 
     LABEL "ACESSORIOS" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .83 NO-UNDO.

DEFINE VARIABLE tg-aut AS LOGICAL INITIAL no 
     LABEL "CONTROLE DE ACESSO" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.

DEFINE VARIABLE tg-estoque AS LOGICAL INITIAL no 
     LABEL "Lista Estoque" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .83 NO-UNDO.

DEFINE VARIABLE tg-fir AS LOGICAL INITIAL no 
     LABEL "INCENDIO" 
     VIEW-AS TOGGLE-BOX
     SIZE 11 BY .83 NO-UNDO.

DEFINE VARIABLE tg-icon AS LOGICAL INITIAL no 
     LABEL "TELECOM" 
     VIEW-AS TOGGLE-BOX
     SIZE 11 BY .83 NO-UNDO.

DEFINE VARIABLE tg-inet AS LOGICAL INITIAL no 
     LABEL "REDES" 
     VIEW-AS TOGGLE-BOX
     SIZE 9 BY .83 NO-UNDO.

DEFINE VARIABLE tg-isec AS LOGICAL INITIAL yes 
     LABEL "SEGURANCA ELETRONICA" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE tg-lib AS LOGICAL INITIAL no 
     LABEL "Liberado" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-saldo FOR 
      tt-produzir SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-saldo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-saldo wWindow _FREEFORM
  QUERY br-saldo DISPLAY
      tt-produzir.log-liberar      
tt-produzir.cod_unid_neg      
tt-produzir.it-codigo     FORMAT "x(08)"
tt-produzir.desc-item     FORMAT "x(20)"
tt-produzir.qtd-produzir
tt-produzir.qtd-cartao
tt-produzir.qtd-lote-mult
tt-produzir.qtd-estoq-max
tt-produzir.qtd-aca-101  
tt-produzir.qtd-aca-104  
tt-produzir.qtd-exp-104  
tt-produzir.qtd-transito
tt-produzir.qtd-blo-104  
tt-produzir.qtd-dispon
tt-produzir.qtd-alocada
tt-produzir.qtd-sdo-total
tt-produzir.dat-liberac 
tt-produzir.cod-usuar
tt-produzir.dat-estorno 
tt-produzir.cod-usuar-est
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 122.43 BY 15.75
         FONT 1
         TITLE "ITENS A PRODUZIR" TOOLTIP "Duplo clique para marcar/desmarcar kanban a ser atualizado".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tg-icon AT ROW 4 COL 3 WIDGET-ID 62
     tg-isec AT ROW 2 COL 3 WIDGET-ID 32
     tg-inet AT ROW 4 COL 27 WIDGET-ID 36
     tg-lib AT ROW 2.33 COL 67.57 WIDGET-ID 40
     v-dat-corte AT ROW 3.33 COL 65.57 COLON-ALIGNED WIDGET-ID 42
     tg-estoque AT ROW 2.75 COL 86.86 WIDGET-ID 48
     btCarrega AT ROW 1.5 COL 104.14 HELP
          "V  Para" WIDGET-ID 26
     bt-atu AT ROW 2.75 COL 104.14 HELP
          "Confirma altera‡äes" WIDGET-ID 56
     bt-estornar AT ROW 2.75 COL 108.14 HELP
          "V  Para" WIDGET-ID 54
     bt-csv AT ROW 1.5 COL 108.14 HELP
          "Exportar informa‡äes para arquivo CSV" WIDGET-ID 60
     btExit AT ROW 1.13 COL 119.57 HELP
          "Sair"
     br-saldo AT ROW 5.25 COL 1.57 WIDGET-ID 200
     tg-aut AT ROW 3 COL 3 WIDGET-ID 64
     tg-fir AT ROW 2 COL 27 WIDGET-ID 66
     tg-ace AT ROW 3 COL 27 WIDGET-ID 68
     " Unid. Neg" VIEW-AS TEXT
          SIZE 9 BY .67 AT ROW 1.13 COL 3 WIDGET-ID 30
     " Estoque" VIEW-AS TEXT
          SIZE 9 BY .67 AT ROW 1.13 COL 85.14 WIDGET-ID 52
     " Liberados" VIEW-AS TEXT
          SIZE 9 BY .67 AT ROW 1.13 COL 62.14 WIDGET-ID 38
     RECT-1 AT ROW 1.5 COL 2 WIDGET-ID 44
     RECT-2 AT ROW 1.5 COL 61.14 WIDGET-ID 46
     RECT-3 AT ROW 1.5 COL 84.14 WIDGET-ID 50
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 123.43 BY 20
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
         TITLE              = "Monitora Ficha Produ‡Æo - escpp058 - Sem Bancos"
         HEIGHT             = 20
         WIDTH              = 123.43
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB br-saldo btExit fpage0 */
ASSIGN 
       br-saldo:NUM-LOCKED-COLUMNS IN FRAME fpage0     = 2
       br-saldo:ALLOW-COLUMN-SEARCHING IN FRAME fpage0 = TRUE
       br-saldo:COLUMN-RESIZABLE IN FRAME fpage0       = TRUE.

/* SETTINGS FOR BUTTON bt-estornar IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-saldo
/* Query rebuild information for BROWSE br-saldo
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-produzir.
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
ON END-ERROR OF wWindow /* Monitora Ficha Produ‡Æo - escpp058 - Sem Bancos */
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
ON WINDOW-CLOSE OF wWindow /* Monitora Ficha Produ‡Æo - escpp058 - Sem Bancos */
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
ON MOUSE-SELECT-DBLCLICK OF br-saldo IN FRAME fpage0 /* ITENS A PRODUZIR */
DO:
   /*APPLY "return" TO SELF. */

   IF  AVAIL tt-produzir
   THEN DO:
       FIND CURRENT tt-produzir EXCLUSIVE-LOCK NO-ERROR.

       IF  tt-produzir.log-liberar = ""
       THEN
           ASSIGN tt-produzir.log-liberar = "X".
       ELSE
           ASSIGN tt-produzir.log-liberar = "".

       FIND CURRENT tt-produzir NO-LOCK NO-ERROR.           
       br-saldo:REFRESH().
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-saldo wWindow
ON ROW-DISPLAY OF br-saldo IN FRAME fpage0 /* ITENS A PRODUZIR */
DO:
    ASSIGN tt-produzir.qtd-produzir:BGCOLOR  IN BROWSE br-saldo = 12
           tt-produzir.qtd-cartao:BGCOLOR    IN BROWSE br-saldo = 12
           tt-produzir.qtd-dispon:BGCOLOR    IN BROWSE br-saldo = 10
           tt-produzir.qtd-alocada:BGCOLOR   IN BROWSE br-saldo = 14.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-saldo wWindow
ON START-SEARCH OF br-saldo IN FRAME fpage0 /* ITENS A PRODUZIR */
DO:
    ASSIGN c-by = br-saldo:CURRENT-COLUMN:NAME.
    br-saldo:HANDLE:QUERY:QUERY-PREPARE("FOR EACH tt-produzir NO-LOCK " +
                                        "BY    tt-produzir." + c-by).
    br-saldo:HANDLE:QUERY:QUERY-OPEN().
/*     {&OPEN-QUERY-br-saldo} */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-atu
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-atu wWindow
ON CHOOSE OF bt-atu IN FRAME fpage0 /* Atualizar */
DO:
    FIND FIRST tt-produzir NO-LOCK 
        WHERE  tt-produzir.log-liberar = "X" NO-ERROR.
    
    IF  AVAIL tt-produzir
    THEN DO:
        MESSAGE "Confirma atualiza‡Æo das pendˆncias de kanban selecionadas?"
                VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                TITLE "CONFIRMAR ATUALIZA€ÇO" UPDATE v-log-confirma AS LOGICAL.

        IF  v-log-confirma = YES
        THEN
            RUN pi-atualizar-kanban (INPUT NO). /* no para atualiza‡Æo normal, yes para estorno */
    
        IF  RETURN-VALUE = "ok"
        THEN DO:
            MESSAGE "Atualiza‡Æo realizada com sucesso."
                    VIEW-AS ALERT-BOX INFORMATION
                    TITLE "".
            APPLY "choose" TO btcarrega.
        END.
    END.
    ELSE DO:
        MESSAGE "Deve ser marcada pelo menos uma pendˆncia de kanban para atualiza‡Æo. " SKIP 
                "Utilize o duplo clique sobre a linha."
                VIEW-AS ALERT-BOX ERROR
                TITLE "NÆo h  itens de kanban selecionados.".
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-csv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-csv wWindow
ON CHOOSE OF bt-csv IN FRAME fpage0 /* CSV */
DO:
    RUN pi-exporta-dados IN THIS-PROCEDURE (INPUT br-saldo:HANDLE IN FRAME fPage0).

    IF RETURN-VALUE = "NOK":U THEN
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 17006,
                           INPUT "Foram encontrados erros na gera‡Æo do arquivo CSV de dados.":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-estornar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-estornar wWindow
ON CHOOSE OF bt-estornar IN FRAME fpage0 /* Estornar */
DO:
    FIND FIRST tt-produzir NO-LOCK 
        WHERE  tt-produzir.log-liberar = "X" NO-ERROR.
    
    IF  AVAIL tt-produzir
    THEN DO:
        MESSAGE "Confirma atualiza‡Æo das pendˆncias de kanban selecionadas?"
                VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                TITLE "CONFIRMAR ATUALIZA€ÇO" UPDATE v-log-confirma AS LOGICAL.
    
        IF  v-log-confirma = YES
        THEN
            RUN pi-atualizar-kanban (INPUT YES). /* no para atualiza‡Æo normal, yes para estorno */
    
        IF  RETURN-VALUE = "ok"
        THEN DO:
            MESSAGE "Atualiza‡Æo realizada com sucesso."
                    VIEW-AS ALERT-BOX INFORMATION
                    TITLE "".
            APPLY "choose" TO btcarrega.
        END.
    END.
    ELSE DO:
        MESSAGE "Deve ser marcada pelo menos uma pendˆncia de kanban para atualiza‡Æo. " SKIP 
                "Utilize o duplo clique sobre a linha."
                VIEW-AS ALERT-BOX ERROR
                TITLE "NÆo h  itens de kanban selecionados.".
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCarrega
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCarrega wWindow
ON CHOOSE OF btCarrega IN FRAME fpage0 /* Apresentar */
DO:
    RUN pi-carrega-dados IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    RUN piDesconecta.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    QUIT.
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

  ASSIGN v-dat-corte = TODAY - 7.

  RUN enable_UI.

  RUN conecta-rpc IN THIS-PROCEDURE (output hproc).
  IF RETURN-VALUE = "NOK" 
  THEN DO:
      MESSAGE "NÆo foi poss¡vel conectar o servidor RPC." SKIP 
              "Entre em contato com o respons vel em TI"
              VIEW-AS ALERT-BOX ERROR
              TITLE "ERRO CONEXÇO SERVIDOR RPC".

      APPLY "CLOSE":U TO THIS-PROCEDURE.
      QUIT.
  END.

  ASSIGN v_rotina_intelbras = "escpp058".

  RUN esp/utp/esbtb910zz.w (INPUT hproc, INPUT "{&Program}|{&Version}").

  IF RETURN-VALUE = "NOK" THEN DO:
      RUN piDesconecta.
      APPLY "CLOSE":U TO THIS-PROCEDURE.
      QUIT.
  END.

  RUN pi-inicia.

  IF VALID-HANDLE(hprog) THEN DO:
      SESSION:SET-WAIT-STATE("GENERAL":U).
      RUN pi-busca-usuar-estorno IN hprog (OUTPUT TABLE tt-usuar-estorno).

      FIND FIRST tt-usuar-estorno NO-LOCK
          WHERE  tt-usuar-estorno.cod-usuario = v_cod_usuar_corren NO-ERROR.

      IF  AVAIL tt-usuar-estorno
      THEN
          ENABLE bt-estornar WITH FRAME {&FRAME-NAME}.
      ELSE
          DISABLE bt-estornar WITH FRAME {&FRAME-NAME}.

      SESSION:SET-WAIT-STATE("":U).
      DELETE PROCEDURE hprog.
      hprog = ?.
  END.
  ELSE
      MESSAGE "NÆo foi poss¡vel conectar ao servidor RPC." SKIP 
              "Favor fazer login novamente."
              VIEW-AS ALERT-BOX ERROR
              TITLE "".

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualizar-kanban wWindow 
PROCEDURE pi-atualizar-kanban :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-log-estorno AS LOG NO-UNDO.

    RUN pi-inicia.
    IF VALID-HANDLE(hprog) THEN DO:
        SESSION:SET-WAIT-STATE("GENERAL":U).
        RUN pi-atualizar-kanban IN hprog (INPUT p-log-estorno,
                                          INPUT v_cod_usuar_corren,
                                          INPUT-OUTPUT TABLE tt-produzir).

        SESSION:SET-WAIT-STATE("":U).
        DELETE PROCEDURE hprog.
        hprog = ?.
    END.
    ELSE
        MESSAGE "NÆo foi poss¡vel conectar ao servidor RPC." SKIP 
                "Favor fazer login novamente."
                VIEW-AS ALERT-BOX ERROR
                TITLE "".

    {&OPEN-QUERY-br-saldo}

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

    EMPTY TEMP-TABLE tt-produzir.
    EMPTY TEMP-TABLE tt-param.

    CREATE tt-param.
    ASSIGN tt-param.log-isec     = INPUT FRAME {&FRAME-NAME} tg-isec
           tt-param.log-inet     = INPUT FRAME {&FRAME-NAME} tg-inet
           tt-param.log-icon     = iNPUT FRAME {&FRAME-NAME} tg-icon
           tt-param.log-estoque  = INPUT FRAME {&FRAME-NAME} tg-estoque
           tt-param.log-liberado = INPUT FRAME {&FRAME-NAME} tg-lib
           tt-param.dat-corte    = INPUT FRAME {&FRAME-NAME} v-dat-corte
           tt-param.log-aut      = INPUT FRAME {&FRAME-NAME} tg-aut
           tt-param.log-fir      = INPUT FRAME {&FRAME-NAME} tg-fir
           tt-param.log-ace      = INPUT FRAME {&FRAME-NAME} tg-ace.

    {&OPEN-QUERY-br-saldo}

    RUN pi-inicia.
    IF VALID-HANDLE(hprog) THEN DO:
        SESSION:SET-WAIT-STATE("GENERAL":U).

        RUN pi-carrega-dados IN hprog (INPUT  TABLE tt-param,    
                                       OUTPUT TABLE tt-produzir).

        SESSION:SET-WAIT-STATE("":U).
        DELETE PROCEDURE hprog.
        hprog = ?.
    END.
    ELSE
        MESSAGE "NÆo foi poss¡vel conectar ao servidor RPC." SKIP 
                "Favor fazer login novamente."
                VIEW-AS ALERT-BOX ERROR
                TITLE "".

    {&OPEN-QUERY-br-saldo}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exporta-dados wWindow 
PROCEDURE pi-exporta-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-browse AS HANDLE      NO-UNDO.

    DEFINE VARIABLE h-acomp  AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-coluna AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-query  AS HANDLE      NO-UNDO.

    DEFINE VARIABLE i-linha  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-coluna AS INTEGER     NO-UNDO.

    DEFINE VARIABLE c-arquivo AS CHARACTER   NO-UNDO.

    IF NOT VALID-HANDLE(p-browse) THEN
        RETURN "NOK":U.

    ASSIGN h-query = p-browse:QUERY NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
        RETURN "NOK":U.

    EMPTY TEMP-TABLE tt-dados-csv.

    ASSIGN c-arquivo = REPLACE(SESSION:TEMP-DIRECTORY + "escpp058.csv":U, "~\":U, "/":U).

    IF NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Exportanto dados...":U).

    IF h-query:IS-OPEN AND h-query:GET-FIRST() THEN DO:

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Gerando label colunas...":U).

        DO i-coluna = 1 TO p-browse:NUM-COLUMNS:
            ASSIGN h-coluna = p-browse:GET-BROWSE-COLUMN(i-coluna).

            CREATE tt-dados-csv.
            ASSIGN tt-dados-csv.i-linha    = 1
                   tt-dados-csv.i-coluna   = i-coluna
                   tt-dados-csv.c-conteudo = TRIM(h-coluna:LABEL).
        END.

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Exportando dados...":U).

        DO i-linha = 1 TO p-browse:MAX-DATA-GUESS:
            h-query:REPOSITION-TO-ROW(i-linha) NO-ERROR.

            APPLY "VALUE-CHANGED":U TO p-browse.

            DO i-coluna = 1 TO p-browse:NUM-COLUMNS:
                ASSIGN h-coluna = p-browse:GET-BROWSE-COLUMN(i-coluna).

                CREATE tt-dados-csv.
                ASSIGN tt-dados-csv.i-linha    = i-linha + 1
                       tt-dados-csv.i-coluna   = i-coluna
                       tt-dados-csv.c-conteudo = TRIM(h-coluna:SCREEN-VALUE).
            END.

            IF NOT p-browse:SELECT-NEXT-ROW() THEN
                ASSIGN i-linha = p-browse:MAX-DATA-GUESS + 1.
        END.

        IF p-browse:MAX-DATA-GUESS > 12 THEN
            p-browse:REFRESH().
    END.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-acompanhar IN h-acomp (INPUT "Gerando arquivo CSV...":U).

    OUTPUT TO VALUE(c-arquivo) CONVERT TARGET "iso8859-1":U.
    FOR EACH tt-dados-csv
        BREAK BY tt-dados-csv.i-linha:
        IF FIRST-OF(tt-dados-csv.i-linha) THEN
            PUT UNFORMATTED tt-dados-csv.c-conteudo.
        ELSE
            PUT UNFORMATTED ";":U + tt-dados-csv.c-conteudo.

        IF LAST-OF(tt-dados-csv.i-linha) THEN
            PUT UNFORMATTED SKIP.
    END.
    OUTPUT CLOSE.

    IF OPSYS = "WIN32":U THEN
        OS-COMMAND NO-WAIT VALUE(c-arquivo) NO-ERROR.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        DELETE PROCEDURE h-acomp.

    ASSIGN h-acomp = ?.

    EMPTY TEMP-TABLE tt-dados-csv.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicia wWindow 
PROCEDURE pi-inicia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR first-time AS LOGICAL NO-UNDO INIT YES.  

  DO WHILE NOT VALID-HANDLE(hprog):
      RUN {&RPC-CALL} PERSISTENT SET hprog ON SERVER hproc TRANSACTION DISTINCT NO-ERROR.
      IF NOT VALID-HANDLE(hproc) THEN DO:
          IF first-time THEN
              RUN conecta-rpc IN THIS-PROCEDURE (output hproc).
          ELSE DO:
              MESSAGE "Ocorreu um erro durante a execu‡Æo de um procedimento remoto que impede que esta opera‡Æo continue." SKIP
                      "Por favor repita esta opera‡Æo mais tarde"
                      VIEW-AS ALERT-BOX ERROR
                      TITLE "ERRO NA EXECU€ÇO".
              QUIT.
          END.
      END.
      IF VALID-HANDLE(hprog) THEN RETURN.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDesconecta wWindow 
PROCEDURE piDesconecta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   IF VALID-HANDLE(hprog) THEN DO:
       DELETE PROCEDURE hprog.
       hprog = ?.
   END.
    
   RUN desconecta-rpc IN THIS-PROCEDURE (INPUT hproc).
   ASSIGN hproc = ?
          hprog = ?.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

