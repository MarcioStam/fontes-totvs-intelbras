&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
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
/*DEF VAR hproc AS HANDLE NO-UNDO.*/
DEF VAR hprog AS HANDLE NO-UNDO.

DEFINE INPUT PARAMETER hproc AS HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-id AS CHAR NO-UNDO.

/*&SCOPED-DEFINE TESTE 1
&SCOPED-DEFINE SERVIDOR-PRODUCAO rpc22pr   */

{esp/utp/esutp001.i}

DEF BUFFER b-tt-agenda-tarifador FOR tt-agenda-tarifador.

DEFINE VARIABLE c-erro AS CHARACTER   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BROWSE-9

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-agenda-tarifador

/* Definitions for BROWSE BROWSE-9                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-9 tt-agenda-tarifador.ramal tt-agenda-tarifador.numero tt-agenda-tarifador.finalidade tt-agenda-tarifador.descricao tt-agenda-tarifador.observacoes   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-9   
&Scoped-define SELF-NAME BROWSE-9
&Scoped-define QUERY-STRING-BROWSE-9 FOR EACH tt-agenda-tarifador      by tt-agenda-tarifador.ramal BY tt-agenda-tarifador.numero
&Scoped-define OPEN-QUERY-BROWSE-9 OPEN QUERY BROWSE-9 FOR EACH tt-agenda-tarifador      by tt-agenda-tarifador.ramal BY tt-agenda-tarifador.numero.
&Scoped-define TABLES-IN-QUERY-BROWSE-9 tt-agenda-tarifador
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-9 tt-agenda-tarifador


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btExit btHelp BROWSE-9 btIncluir ~
btModificar btExcluir 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btExcluir 
     LABEL "Excluir" 
     SIZE 8 BY 1 TOOLTIP "Excluir".

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25 TOOLTIP "Sair"
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25 TOOLTIP "Ajuda"
     FONT 4.

DEFINE BUTTON btIncluir 
     LABEL "&Incluir" 
     SIZE 8 BY 1 TOOLTIP "Incluir".

DEFINE BUTTON btModificar 
     LABEL "&Modificar" 
     SIZE 8 BY 1 TOOLTIP "Modificar".

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 99 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-9 FOR 
      tt-agenda-tarifador SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-9 C-Win _FREEFORM
  QUERY BROWSE-9 DISPLAY
      tt-agenda-tarifador.ramal      LABEL "Ramal"       FORMAT "x(20)"
     tt-agenda-tarifador.numero      LABEL "Numero"      FORMAT "x(20)"
     tt-agenda-tarifador.finalidade  LABEL "Finalidade"  FORMAT "Particular/Serviáo"
     tt-agenda-tarifador.descricao   LABEL "Descriá∆o"   FORMAT "x(30)"
     tt-agenda-tarifador.observacoes LABEL "Observaá‰es" FORMAT "x(45)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 96 BY 11.83
         FONT 1
         TITLE "Agenda".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     btExit AT ROW 1.13 COL 91.57 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 95.57 HELP
          "Ajuda"
     BROWSE-9 AT ROW 3 COL 2.86
     btIncluir AT ROW 14.92 COL 10 RIGHT-ALIGNED HELP
          "Incluir"
     btModificar AT ROW 14.92 COL 18.14 RIGHT-ALIGNED HELP
          "Modificar"
     btExcluir AT ROW 14.92 COL 26.29 RIGHT-ALIGNED HELP
          "Excluir"
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 99.14 BY 15.13
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Agenda Telefìnica Tarifador - ESUTP001A - 2.04.00.000"
         HEIGHT             = 15.13
         WIDTH              = 99.14
         MAX-HEIGHT         = 18.54
         MAX-WIDTH          = 99.43
         VIRTUAL-HEIGHT     = 18.54
         VIRTUAL-WIDTH      = 99.43
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         FONT               = 1
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT C-Win:LOAD-ICON("image\monitor.ico":U) THEN
    MESSAGE "Unable to load icon: image\monitor.ico"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB C-Win 
/* ************************* Included-Libraries *********************** */

{esp/es0018.i}
{esp/utp/acesso-rpc.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-9 btHelp DEFAULT-FRAME */
/* SETTINGS FOR BUTTON btExcluir IN FRAME DEFAULT-FRAME
   ALIGN-R                                                              */
/* SETTINGS FOR BUTTON btIncluir IN FRAME DEFAULT-FRAME
   ALIGN-R                                                              */
/* SETTINGS FOR BUTTON btModificar IN FRAME DEFAULT-FRAME
   ALIGN-R                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-9
/* Query rebuild information for BROWSE BROWSE-9
     _START_FREEFORM
OPEN QUERY BROWSE-9 FOR EACH tt-agenda-tarifador
     by tt-agenda-tarifador.ramal BY tt-agenda-tarifador.numero.
     _END_FREEFORM
     _Query            is NOT OPENED
*/  /* BROWSE BROWSE-9 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Agenda Telefìnica Tarifador - ESUTP001A - 2.04.00.000 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Agenda Telefìnica Tarifador - ESUTP001A - 2.04.00.000 */
DO:
  /* This event will close the window and terminate the procedure.  */
  /*RUN desconecta-rpc IN THIS-PROCEDURE (INPUT hproc).
  hproc = ?.*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-9
&Scoped-define SELF-NAME BROWSE-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-9 C-Win
ON ROW-DISPLAY OF BROWSE-9 IN FRAME DEFAULT-FRAME /* Agenda */
DO:
    RUN pi-muda-cor.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExcluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExcluir C-Win
ON CHOOSE OF btExcluir IN FRAME DEFAULT-FRAME /* Excluir */
DO:
    IF AVAIL tt-agenda-tarifador THEN DO:
        RUN esp/utp/esutp001rpc.p PERSISTENT SET hprog ON SERVER hproc.
        IF VALID-HANDLE(hprog) THEN DO:
            SESSION:SET-WAIT-STATE("GENERAL":U).
            RUN excluirAgendaUsuario IN hprog (INPUT tt-agenda-tarifador.r-rowid).
            EMPTY TEMP-TABLE tt-agenda-tarifador.
            RUN obtemAgendaUsuario  IN hprog (INPUT p-id, OUTPUT TABLE tt-agenda-tarifador).
            SESSION:SET-WAIT-STATE("":U).
            OPEN QUERY BROWSE-9 FOR EACH tt-agenda-tarifador 
                by tt-agenda-tarifador.ramal by tt-agenda-tarifador.numero.
            DELETE PROCEDURE hprog.
            hprog = ?.
        END.
    END.
    ELSE DO:
        MESSAGE "Selecione o registro que deseja excluir!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit C-Win
ON CHOOSE OF btExit IN FRAME DEFAULT-FRAME /* Exit */
DO:
/*    RUN desconecta-rpc IN THIS-PROCEDURE (INPUT hproc).
    hproc = ?.*/
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btIncluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btIncluir C-Win
ON CHOOSE OF btIncluir IN FRAME DEFAULT-FRAME /* Incluir */
DO:
    DEF VAR v-ramal      AS CHARACTER FORMAT "x(12)" LABEL "Ramal" VIEW-AS FILL-IN SIZE 13 BY 0.88.
    DEF VAR v-numero     AS CHARACTER FORMAT "x(40)" LABEL "N£mero" VIEW-AS FILL-IN SIZE 41 BY 0.88.
    /*DEF VAR v-finalidade AS LOGICAL   FORMAT "Particular/Serviáo" LABEL "Finalidade" VIEW-AS RADIO-SET .*/
    DEF VAR v-descricao  AS CHARACTER FORMAT "x(40)" LABEL "Descriá∆o" VIEW-AS FILL-IN SIZE 41 BY 0.88.
    DEF VAR v-observ     AS CHARACTER FORMAT "x(60)" LABEL "Observaá‰es" VIEW-AS FILL-IN SIZE 61 BY 0.88.

    DEFINE BUTTON btCancelar AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 80 BY 1.42
         BGCOLOR 7.

    DEFINE VARIABLE v-finalidade AS LOGICAL
         LABEL "Finalidade"
         VIEW-AS RADIO-SET HORIZONTAL
         RADIO-BUTTONS 
        "Particular", YES,
        "Serviáo", NO
         SIZE 30 BY 1 NO-UNDO.

    DEFINE FRAME fIncluir
        v-ramal         AT ROW 1.21 COL 11.0 COLON-ALIGNED 
        v-numero        AT ROW 2.21 COL 11.0 COLON-ALIGNED 
        v-finalidade    AT ROW 3.21 COL 11.0 COLON-ALIGNED 
        v-descricao     AT ROW 4.21 COL 11.0 COLON-ALIGNED 
        v-observ        AT ROW 5.21 COL 11.0 COLON-ALIGNED 
        btOK          AT ROW 10.63 COL 2.14
        btCancelar    AT ROW 10.63 COL 13
        rtButton      AT ROW 10.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Incluir Telefone" FONT 1
             DEFAULT-BUTTON btOK CANCEL-BUTTON btCancelar.
    
    ON "CHOOSE":U OF btOK IN FRAME fIncluir DO:
        ASSIGN INPUT FRAME fIncluir v-ramal v-numero v-finalidade v-descricao v-observ.

        RUN esp/utp/esutp001rpc.p PERSISTENT SET hprog ON SERVER hproc.
        IF VALID-HANDLE(hprog) THEN DO:
            EMPTY TEMP-TABLE tt-agenda-tarifador.
            SESSION:SET-WAIT-STATE("GENERAL":U).
            ASSIGN c-erro = "".
            RUN incluirAgendaUsuario IN hprog (INPUT p-id, INPUT v-ramal, INPUT v-numero, INPUT v-finalidade, INPUT v-descricao, INPUT v-observ, OUTPUT c-erro).
            SESSION:SET-WAIT-STATE("":U).
            IF c-erro = "" THEN DO:
                SESSION:SET-WAIT-STATE("GENERAL":U).
                RUN obtemAgendaUsuario  IN hprog (INPUT p-id, OUTPUT TABLE tt-agenda-tarifador).
                SESSION:SET-WAIT-STATE("":U).
                OPEN QUERY BROWSE-9 FOR EACH tt-agenda-tarifador 
                    by tt-agenda-tarifador.ramal by tt-agenda-tarifador.numero.
                APPLY "GO":U TO FRAME fIncluir.
            END.
            ELSE DO:
                MESSAGE c-erro
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.
            DELETE PROCEDURE hprog.
            hprog = ?.
        END.
        ELSE DO:
            MESSAGE "N∆o foi poss°vel conectar ao servidor RPC. Favor fazer login novamente."
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            APPLY "GO":U TO FRAME fIncluir.
        END.
    END.

    ENABLE v-ramal v-numero v-finalidade v-descricao v-observ
           btOK btCancelar 
        WITH FRAME fIncluir. 

    /*ASSIGN v-numero:SCREEN-VALUE IN FRAME fIncluir = v-numero.        */
    
    WAIT-FOR "GO":U OF FRAME fIncluir.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btModificar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btModificar C-Win
ON CHOOSE OF btModificar IN FRAME DEFAULT-FRAME /* Modificar */
DO:
    IF AVAIL tt-agenda-tarifador THEN DO:

        DEF VAR v-ramal      AS CHARACTER FORMAT "x(12)" LABEL "Ramal" VIEW-AS FILL-IN SIZE 13 BY 0.88.
        DEF VAR v-numero     AS CHARACTER FORMAT "x(40)" LABEL "N£mero" VIEW-AS FILL-IN SIZE 41 BY 0.88.
        /*DEF VAR v-finalidade AS LOGICAL   FORMAT "Particular/Serviáo" LABEL "Finalidade" VIEW-AS RADIO-SET .*/
        DEF VAR v-descricao  AS CHARACTER FORMAT "x(40)" LABEL "Descriá∆o" VIEW-AS FILL-IN SIZE 41 BY 0.88.
        DEF VAR v-observ     AS CHARACTER FORMAT "x(60)" LABEL "Observaá‰es" VIEW-AS FILL-IN SIZE 61 BY 0.88.

        DEFINE BUTTON btCancelar AUTO-END-KEY 
             LABEL "&Cancelar" 
             SIZE 10 BY 1
             BGCOLOR 8.

        DEFINE BUTTON btOK AUTO-GO 
             LABEL "&OK" 
             SIZE 10 BY 1
             BGCOLOR 8.

        DEFINE RECTANGLE rtButton
             EDGE-PIXELS 2 GRAPHIC-EDGE  
             SIZE 80 BY 1.42
             BGCOLOR 7.

        DEFINE VARIABLE v-finalidade AS LOGICAL
             LABEL "Finalidade"
             VIEW-AS RADIO-SET HORIZONTAL
             RADIO-BUTTONS 
            "Particular", YES,
            "Serviáo", NO
             SIZE 30 BY 1 NO-UNDO.

        DEFINE FRAME fModificar
            v-ramal         AT ROW 1.21 COL 11.0 COLON-ALIGNED 
            v-numero        AT ROW 2.21 COL 11.0 COLON-ALIGNED 
            v-finalidade    AT ROW 3.21 COL 11.0 COLON-ALIGNED 
            v-descricao     AT ROW 4.21 COL 11.0 COLON-ALIGNED 
            v-observ        AT ROW 5.21 COL 11.0 COLON-ALIGNED 
            btOK          AT ROW 10.63 COL 2.14
            btCancelar    AT ROW 10.63 COL 13
            rtButton      AT ROW 10.38 COL 1
            SPACE(0.28)
            WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
                 THREE-D SCROLLABLE TITLE "Modificar" FONT 1
                 DEFAULT-BUTTON btOK CANCEL-BUTTON btCancelar.

        ASSIGN v-ramal:SCREEN-VALUE IN FRAME fModificar       = tt-agenda-tarifador.ramal
               v-numero:SCREEN-VALUE IN FRAME fModificar      = tt-agenda-tarifador.numero
               v-finalidade:SCREEN-VALUE IN FRAME fModificar  = STRING(tt-agenda-tarifador.finalidade)
               v-descricao:SCREEN-VALUE IN FRAME fModificar   = tt-agenda-tarifador.descricao
               v-observ:SCREEN-VALUE IN FRAME fModificar      = tt-agenda-tarifador.observacoes.

        ON "CHOOSE":U OF btOK IN FRAME fModificar DO:
            ASSIGN INPUT FRAME fModificar v-ramal v-numero v-finalidade v-descricao v-observ.

            RUN esp/utp/esutp001rpc.p PERSISTENT SET hprog ON SERVER hproc.
            IF VALID-HANDLE(hprog) THEN DO:
                SESSION:SET-WAIT-STATE("GENERAL":U).
                ASSIGN c-erro = "".
                RUN modificarAgendaUsuario IN hprog (INPUT p-id, INPUT v-ramal, INPUT v-numero, INPUT v-finalidade, INPUT v-descricao, INPUT v-observ, OUTPUT c-erro).
                SESSION:SET-WAIT-STATE("":U).
                IF c-erro = "" THEN DO:
                    SESSION:SET-WAIT-STATE("GENERAL":U).
                    EMPTY TEMP-TABLE tt-agenda-tarifador.
                    RUN obtemAgendaUsuario  IN hprog (INPUT p-id, OUTPUT TABLE tt-agenda-tarifador).
                    SESSION:SET-WAIT-STATE("":U).
                    OPEN QUERY BROWSE-9 FOR EACH tt-agenda-tarifador 
                        by tt-agenda-tarifador.ramal by tt-agenda-tarifador.numero.
                    APPLY "GO":U TO FRAME fModificar.
                END.
                ELSE DO:
                    MESSAGE c-erro
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                END.
                DELETE PROCEDURE hprog.
                hprog = ?.
            END.
            ELSE DO:
                MESSAGE "N∆o foi poss°vel conectar ao servidor RPC. Favor fazer login novamente."
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                APPLY "GO":U TO FRAME fModificar.
            END.
        END.

        ENABLE v-finalidade v-descricao v-observ
               btOK btCancelar 
            WITH FRAME fModificar. 

        /*ASSIGN v-numero:SCREEN-VALUE IN FRAME fModificar = v-numero.        */

        WAIT-FOR "GO":U OF FRAME fModificar.
    END.
    ELSE DO:
        MESSAGE "Selecione o registro que deseja alterar!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */
/*RUN conecta-rpc IN THIS-PROCEDURE (output hproc).
IF RETURN-VALUE = "NOK" THEN DO:
  RUN pi-message(1, "Erro na conex∆o com o servidor RPC",
                 "N∆o foi poss°vel conectar o servidor RPC. Entre em contato com o respons†vel em TI").
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.*/

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

  BROWSE browse-9:TITLE = "Agenda Telefìnica: " + STRING(p-id).
  RUN pi-carrega-dados.

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  ENABLE rtToolBar btExit btHelp BROWSE-9 btIncluir btModificar btExcluir 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-dados C-Win 
PROCEDURE pi-carrega-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN esp/utp/esutp001rpc.p PERSISTENT SET hprog ON SERVER hproc.
    IF VALID-HANDLE(hprog) THEN DO:
        EMPTY TEMP-TABLE tt-agenda-tarifador.
        SESSION:SET-WAIT-STATE("GENERAL":U).
        RUN obtemAgendaUsuario IN hprog (INPUT p-id, OUTPUT TABLE tt-agenda-tarifador).
        SESSION:SET-WAIT-STATE("":U).
        OPEN QUERY BROWSE-9 FOR EACH tt-agenda-tarifador 
            by tt-agenda-tarifador.ramal by tt-agenda-tarifador.numero.
        DELETE PROCEDURE hprog.
        hprog = ?.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-message C-Win 
PROCEDURE pi-message :
def input param p-tipo AS INT no-undo.
    DEF INPUT PARAM p-texto-msg AS CHAR NO-UNDO.
    DEF INPUT PARAM p-help-msg AS CHAR NO-UNDO.

    def var v_msg_val           as char     no-undo 
        view-as editor size-char 61 by 1.7 
        scrollbar-vertical.
    def var v_msg_hlp           as char     no-undo 
        view-as editor size-char 50 by 3
        scrollbar-vertical font 2.
    def var c-ajuda             as char format "x(7)" no-undo view-as text size 7 by 1 INIT "Ajuda".

    def image im_msg_ico     file "image/im-mqerr".
    def rectangle rt_help    size-char 52 by 4 edge-pixels 2 bgcolor 8.
    def rectangle rt_button  size-char 61 by 1.42 edge-pixels 1 bgcolor 7.
    def button bt_yes        label "&OK" size-char 10 by 1 auto-go.
    def button bt_no         label "&N∆o" size-char 10 by 1 auto-go.
    
    def frame f_msg_help
        v_msg_val    at row 1.5 col 2
        im_msg_ico   at row 4.5 col  4
        v_msg_hlp    at row 4.5 col 12
        rt_help      at row 4.0 col 11
        c-ajuda      at row 3.5 col 14 
        rt_button    at row 8.5 col 2 space(1)
        bt_yes        at row 8.71 col 3
        bt_no        at row 8.71 col 14
        skip(0.5)
        with three-d no-label view-as DIALOG-BOX TITLE "Pergunta" DEFAULT-BUTTON bt_yes.

    on cursor-right of 
        bt_yes, bt_no    apply "TAB" to self.
    on cursor-left of
        bt_yes, bt_no    apply "SHIFT-TAB" to self.
     
    on choose of bt_yes
        return "yes".
    on choose of bt_no 
        return "no".
    on end-error of frame f_msg_help do:
        if bt_no:HIDDEN in frame f_msg_help = no then 
            return "no".
        else return "yes".
    end.
    CASE p-tipo:
        WHEN 1 THEN do:
            im_msg_ico:load-image("image/im-mqerr").
            frame f_msg_help:TITLE = "Erro".
            assign bt_no:hidden in frame f_msg_help = YES
                   bt_no:sensitive in frame f_msg_help = NO
                   bt_yes:hidden in frame f_msg_help = NO     
                   bt_yes:sensitive in frame f_msg_help = YES. 
        END.
        WHEN 2 THEN do:
            im_msg_ico:load-image("image/im-mqwar").
            frame f_msg_help:TITLE = "Advertància".
            assign bt_no:hidden in frame f_msg_help = YES
                   bt_no:sensitive in frame f_msg_help = NO
                   bt_yes:hidden in frame f_msg_help = NO     
                   bt_yes:sensitive in frame f_msg_help = YES. 
        END.
        WHEN 3 THEN do:
            im_msg_ico:load-image("image/im-mqqst").
            frame f_msg_help:TITLE = "Pergunta".
            assign bt_no:hidden in frame f_msg_help = no
                   bt_no:sensitive in frame f_msg_help = yes
                   bt_yes:hidden in frame f_msg_help = no     
                   bt_yes:sensitive in frame f_msg_help = yes.
            bt_yes:label in frame f_msg_help = "&Sim".
        END.
        WHEN 4 THEN do:
            im_msg_ico:load-image("image/im-mqinf").
            frame f_msg_help:TITLE = "Informaá∆o".
            assign bt_no:hidden in frame f_msg_help = YES
                   bt_no:sensitive in frame f_msg_help = NO
                   bt_yes:hidden in frame f_msg_help = NO     
                   bt_yes:sensitive in frame f_msg_help = YES. 
        END.
    END CASE.
 
    assign v_msg_val = p-texto-msg.
    assign v_msg_hlp = p-help-msg + chr(10) + "".

    assign v_msg_val:read-only in frame f_msg_help = yes
           v_msg_hlp:read-only in frame f_msg_help = yes.

    VIEW FRAME f_msg_help.
    DISP c-ajuda v_msg_val v_msg_hlp WITH FRAME f_msg_help.
    ENABLE v_msg_val v_msg_hlp WITH FRAME f_msg_help.
    apply "entry" to bt_no.
    wait-for choose of bt_yes or choose of bt_no.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-muda-cor C-Win 
PROCEDURE pi-muda-cor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF AVAIL tt-agenda-tarifador THEN DO:
        IF tt-agenda-tarifador.finalidade THEN DO:
            /*Particular*/
            ASSIGN tt-agenda-tarifador.ramal:BGCOLOR IN BROWSE BROWSE-9       = 14
                   tt-agenda-tarifador.numero:BGCOLOR IN BROWSE BROWSE-9      = 14
                   tt-agenda-tarifador.finalidade:BGCOLOR IN BROWSE BROWSE-9  = 14
                   tt-agenda-tarifador.descricao:BGCOLOR IN BROWSE BROWSE-9   = 14
                   tt-agenda-tarifador.observacoes:BGCOLOR IN BROWSE BROWSE-9 = 14.
        END.
        ELSE DO:
            /*Servico*/
            ASSIGN tt-agenda-tarifador.ramal:BGCOLOR IN BROWSE BROWSE-9       = 11
                   tt-agenda-tarifador.numero:BGCOLOR IN BROWSE BROWSE-9      = 11
                   tt-agenda-tarifador.finalidade:BGCOLOR IN BROWSE BROWSE-9  = 11
                   tt-agenda-tarifador.descricao:BGCOLOR IN BROWSE BROWSE-9   = 11
                   tt-agenda-tarifador.observacoes:BGCOLOR IN BROWSE BROWSE-9 = 11.
        END.
    END.
    ELSE DO:
        /*Sem registros*/
        ASSIGN tt-agenda-tarifador.ramal:BGCOLOR IN BROWSE BROWSE-9       = ?
               tt-agenda-tarifador.numero:BGCOLOR IN BROWSE BROWSE-9      = ?
               tt-agenda-tarifador.finalidade:BGCOLOR IN BROWSE BROWSE-9  = ?
               tt-agenda-tarifador.descricao:BGCOLOR IN BROWSE BROWSE-9   = ?
               tt-agenda-tarifador.observacoes:BGCOLOR IN BROWSE BROWSE-9 = ?.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-numero C-Win 
PROCEDURE pi-numero :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*DEFINE BUTTON btCancelar AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.

    DEFINE FRAME fSelecao
        v-numero           AT ROW 1.21 COL 15.0 COLON-ALIGNED 
        btOK     AT ROW 2.63 COL 2.14
        btCancelar AT ROW 2.63 COL 13
        rtButton      AT ROW 2.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Seleá∆o" FONT 1
             DEFAULT-BUTTON btOK CANCEL-BUTTON btCancelar.
    
    ON "CHOOSE":U OF btOK IN FRAME fSelecao DO:
        RUN esp/utp/esutp001rpc.p PERSISTENT SET hprog ON SERVER hproc.
        IF VALID-HANDLE(hprog) THEN DO:
            ASSIGN INPUT FRAME fSelecao v-numero.        
            EMPTY TEMP-TABLE tt-agenda-tarifador.
            SESSION:SET-WAIT-STATE("GENERAL":U).
/*            RUN obtemLigacoesPorNumero IN hprog (INPUT v-numero, OUTPUT TABLE tt-agenda-tarifador).
            fi-valor-total = DEC(fi-valor-total:PRIVATE-DATA IN FRAME {&FRAME-NAME}).
            DISP fi-valor-total WITH FRAME {&FRAME-NAME}.*/
            SESSION:SET-WAIT-STATE("":U).
            BROWSE browse-9:TITLE = SUBSTITUTE("Agenda Telefones: &1 ", STRING(p-id)).
            OPEN QUERY BROWSE-9 FOR EACH tt-agenda-tarifador 
                by tt-agenda-tarifador.ramal by tt-agenda-tarifador.numero.
            DELETE PROCEDURE hprog.
            hprog = ?.
        END.
        APPLY "GO":U TO FRAME fSelecao.
    END.

    ENABLE v-numero         btOK btCancelar 
        WITH FRAME fSelecao. 

    ASSIGN v-numero:SCREEN-VALUE IN FRAME fSelecao          = v-numero.        
    
    WAIT-FOR "GO":U OF FRAME fSelecao.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

