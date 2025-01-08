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
DEFINE INPUT PARAMETER hproc AS HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-id AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER p-mestre AS LOGICAL NO-UNDO.

DEF VAR hprog AS HANDLE NO-UNDO.

{esp/utp/esutp001.i}

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
&Scoped-define INTERNAL-TABLES tt-tarifador

/* Definitions for BROWSE BROWSE-9                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-9 tt-tarifador.tipo tt-tarifador.data tt-tarifador.hora tt-tarifador.numero tt-tarifador.localidade tt-tarifador.uf tt-tarifador.finalidade tt-tarifador.avaliado tt-tarifador.valor tt-tarifador.duracao tt-tarifador.ramal tt-tarifador.cod_usuario   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-9   
&Scoped-define SELF-NAME BROWSE-9
&Scoped-define QUERY-STRING-BROWSE-9 FOR EACH tt-tarifador      by tt-tarifador.tipo by tt-tarifador.data by tt-tarifador.hora
&Scoped-define OPEN-QUERY-BROWSE-9 OPEN QUERY BROWSE-9 FOR EACH tt-tarifador      by tt-tarifador.tipo by tt-tarifador.data by tt-tarifador.hora.
&Scoped-define TABLES-IN-QUERY-BROWSE-9 tt-tarifador
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-9 tt-tarifador


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btExit btHelp BROWSE-9 btEstornar ~
rs-tipo 
&Scoped-Define DISPLAYED-OBJECTS rs-tipo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btEstornar 
     LABEL "&Estornar" 
     SIZE 8 BY 1 TOOLTIP "Ramal".

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

DEFINE VARIABLE rs-tipo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Minhas", 1,
"Outros", 2
     SIZE 19.86 BY 1 NO-UNDO.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 103 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-9 FOR 
      tt-tarifador SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-9 C-Win _FREEFORM
  QUERY BROWSE-9 DISPLAY
      tt-tarifador.tipo WIDTH 3.75 
     tt-tarifador.data       
     tt-tarifador.hora WIDTH 6
     tt-tarifador.numero WIDTH 13    
     tt-tarifador.localidade WIDTH 20
     tt-tarifador.uf WIDTH 2.5       
     tt-tarifador.finalidade 
     tt-tarifador.avaliado COLUMN-LABEL "Conf"  
     tt-tarifador.valor
     tt-tarifador.duracao
     tt-tarifador.ramal COLUMN-LABEL "Ramal" WIDTH 8.75
     tt-tarifador.cod_usuario COLUMN-LABEL "Matricula" WIDTH 12
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 102.57 BY 12.33
         FONT 1
         TITLE "Estorno de Ligaá‰es Avaliadas:" TOOLTIP "Ligaá‰es j† avaliadas".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     btExit AT ROW 1.13 COL 95.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 99.72 HELP
          "Ajuda"
     BROWSE-9 AT ROW 2.79 COL 1.43 HELP
          "Ligaá‰es j† avaliadas"
     btEstornar AT ROW 15.21 COL 8.57 RIGHT-ALIGNED
     rs-tipo AT ROW 15.25 COL 83.86 NO-LABEL WIDGET-ID 2
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 103.57 BY 15.54
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
         TITLE              = "Estorno Ligaá∆o Telefìnica - ESUTP001B - 2.04.00.000"
         HEIGHT             = 15.54
         WIDTH              = 103.57
         MAX-HEIGHT         = 39.79
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 39.79
         VIRTUAL-WIDTH      = 182.86
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
IF NOT C-Win:LOAD-ICON("image/monitor.ico":U) THEN
    MESSAGE "Unable to load icon: image/monitor.ico"
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
ASSIGN 
       BROWSE-9:COLUMN-RESIZABLE IN FRAME DEFAULT-FRAME       = TRUE.

/* SETTINGS FOR BUTTON btEstornar IN FRAME DEFAULT-FRAME
   ALIGN-R                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-9
/* Query rebuild information for BROWSE BROWSE-9
     _START_FREEFORM
OPEN QUERY BROWSE-9 FOR EACH tt-tarifador
     by tt-tarifador.tipo by tt-tarifador.data by tt-tarifador.hora.
     _END_FREEFORM
     _Query            is NOT OPENED
*/  /* BROWSE BROWSE-9 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Estorno Ligaá∆o Telefìnica - ESUTP001B - 2.04.00.000 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Estorno Ligaá∆o Telefìnica - ESUTP001B - 2.04.00.000 */
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
ON ROW-DISPLAY OF BROWSE-9 IN FRAME DEFAULT-FRAME /* Estorno de Ligaá‰es Avaliadas: */
DO:
  RUN pi-muda-cor.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btEstornar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btEstornar C-Win
ON CHOOSE OF btEstornar IN FRAME DEFAULT-FRAME /* Estornar */
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME} rs-tipo.

    IF AVAIL tt-tarifador THEN DO:
        RUN esp/utp/esutp001rpc.p PERSISTENT SET hprog ON SERVER hproc.
        IF VALID-HANDLE(hprog) THEN DO:
            SESSION:SET-WAIT-STATE("GENERAL":U).

            IF rs-tipo = 1 THEN DO:
                RUN estornarCobrancaUsuario IN hprog (INPUT p-id,INPUT tt-tarifador.r-rowid).
                EMPTY TEMP-TABLE tt-tarifador.
                RUN obtemLigacoesAvalUsuario IN hprog (INPUT p-id, OUTPUT TABLE tt-tarifador).
            END.
            ELSE DO:
                RUN estornarCobrancaOutros IN hprog (INPUT p-id,INPUT tt-tarifador.r-rowid).
                EMPTY TEMP-TABLE tt-tarifador.
                RUN obtemLigacoesAvalOutros IN hprog (INPUT p-id, OUTPUT TABLE tt-tarifador).
            END.
            SESSION:SET-WAIT-STATE("":U).
            OPEN QUERY BROWSE-9 FOR EACH tt-tarifador 
                by tt-tarifador.ramal by tt-tarifador.numero.
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
    /*RUN desconecta-rpc IN THIS-PROCEDURE (INPUT hproc).
    hproc = ?.*/

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-tipo C-Win
ON VALUE-CHANGED OF rs-tipo IN FRAME DEFAULT-FRAME
DO:
  RUN pi-carrega-dados.
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
    
    IF p-mestre THEN DO:
        ASSIGN rs-tipo:VISIBLE IN FRAME {&FRAME-NAME} = TRUE.
    END.
    ELSE DO:
        ASSIGN rs-tipo:VISIBLE IN FRAME {&FRAME-NAME} = FALSE
               rs-tipo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "1" .
    END.
    
    BROWSE browse-9:TITLE = "Estorno Cobranáa: " + STRING(p-id).
    
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
  DISPLAY rs-tipo 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE rtToolBar btExit btHelp BROWSE-9 btEstornar rs-tipo 
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
ASSIGN INPUT FRAME {&FRAME-NAME} rs-tipo.

RUN esp/utp/esutp001rpc.p PERSISTENT SET hprog ON SERVER hproc.
IF VALID-HANDLE(hprog) THEN DO:
    EMPTY TEMP-TABLE tt-tarifador.
    SESSION:SET-WAIT-STATE("GENERAL":U).

    IF rs-tipo = 1 THEN
        RUN obtemLigacoesAvalUsuario IN hprog (INPUT p-id, OUTPUT TABLE tt-tarifador).
    ELSE
        RUN obtemLigacoesAvalOutros IN hprog (INPUT p-id, OUTPUT TABLE tt-tarifador).

    SESSION:SET-WAIT-STATE("":U).
    OPEN QUERY BROWSE-9 FOR EACH tt-tarifador 
        by tt-tarifador.ramal by tt-tarifador.numero.
    DELETE PROCEDURE hprog.
    hprog = ?.
END.

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
    IF AVAIL tt-tarifador THEN DO:
        IF tt-tarifador.avaliado THEN DO:
            IF tt-tarifador.finalidade THEN DO:
                /*Particular*/
                ASSIGN tt-tarifador.tipo:BGCOLOR IN BROWSE BROWSE-9        = 14
                       tt-tarifador.data:BGCOLOR IN BROWSE BROWSE-9        = 14
                       tt-tarifador.hora:BGCOLOR IN BROWSE BROWSE-9        = 14
                       tt-tarifador.numero:BGCOLOR IN BROWSE BROWSE-9      = 14
                       tt-tarifador.localidade:BGCOLOR IN BROWSE BROWSE-9  = 14
                       tt-tarifador.uf:BGCOLOR IN BROWSE BROWSE-9          = 14
                       tt-tarifador.finalidade:BGCOLOR IN BROWSE BROWSE-9  = 14
                       tt-tarifador.avaliado:BGCOLOR IN BROWSE BROWSE-9    = 14
                       tt-tarifador.valor:BGCOLOR IN BROWSE BROWSE-9       = 14
                       tt-tarifador.duracao:BGCOLOR IN BROWSE BROWSE-9     = 14
                       tt-tarifador.ramal:BGCOLOR IN BROWSE BROWSE-9       = 14
                       tt-tarifador.cod_usuario:BGCOLOR IN BROWSE BROWSE-9 = 14.
            END.
            ELSE DO:
                /*Servico*/
                ASSIGN tt-tarifador.tipo:BGCOLOR IN BROWSE BROWSE-9        = 11
                       tt-tarifador.data:BGCOLOR IN BROWSE BROWSE-9        = 11
                       tt-tarifador.hora:BGCOLOR IN BROWSE BROWSE-9        = 11
                       tt-tarifador.numero:BGCOLOR IN BROWSE BROWSE-9      = 11
                       tt-tarifador.localidade:BGCOLOR IN BROWSE BROWSE-9  = 11
                       tt-tarifador.uf:BGCOLOR IN BROWSE BROWSE-9          = 11
                       tt-tarifador.finalidade:BGCOLOR IN BROWSE BROWSE-9  = 11
                       tt-tarifador.avaliado:BGCOLOR IN BROWSE BROWSE-9    = 11
                       tt-tarifador.valor:BGCOLOR IN BROWSE BROWSE-9       = 11
                       tt-tarifador.duracao:BGCOLOR IN BROWSE BROWSE-9     = 11
                       tt-tarifador.ramal:BGCOLOR IN BROWSE BROWSE-9       = 11
                       tt-tarifador.cod_usuario:BGCOLOR IN BROWSE BROWSE-9 = 11.
            END.
        END.
        ELSE DO:
            /*N∆o avaliado*/
            ASSIGN tt-tarifador.tipo:BGCOLOR IN BROWSE BROWSE-9        = ?
                   tt-tarifador.data:BGCOLOR IN BROWSE BROWSE-9        = ?
                   tt-tarifador.hora:BGCOLOR IN BROWSE BROWSE-9        = ?
                   tt-tarifador.numero:BGCOLOR IN BROWSE BROWSE-9      = ?
                   tt-tarifador.localidade:BGCOLOR IN BROWSE BROWSE-9  = ?
                   tt-tarifador.uf:BGCOLOR IN BROWSE BROWSE-9          = ?
                   tt-tarifador.finalidade:BGCOLOR IN BROWSE BROWSE-9  = ?
                   tt-tarifador.avaliado:BGCOLOR IN BROWSE BROWSE-9    = ?
                   tt-tarifador.valor:BGCOLOR IN BROWSE BROWSE-9       = ?
                   tt-tarifador.duracao:BGCOLOR IN BROWSE BROWSE-9     = ?
                   tt-tarifador.ramal:BGCOLOR IN BROWSE BROWSE-9       = ?
                   tt-tarifador.cod_usuario:BGCOLOR IN BROWSE BROWSE-9 = ?.
        END.
    END.
    ELSE DO:
        /*Sem registros*/
        ASSIGN tt-tarifador.tipo:BGCOLOR IN BROWSE BROWSE-9       = ?
               tt-tarifador.data:BGCOLOR IN BROWSE BROWSE-9       = ?
               tt-tarifador.hora:BGCOLOR IN BROWSE BROWSE-9       = ?
               tt-tarifador.numero:BGCOLOR IN BROWSE BROWSE-9     = ?
               tt-tarifador.localidade:BGCOLOR IN BROWSE BROWSE-9 = ?
               tt-tarifador.uf:BGCOLOR IN BROWSE BROWSE-9         = ?
               tt-tarifador.finalidade:BGCOLOR IN BROWSE BROWSE-9 = ?
               tt-tarifador.avaliado:BGCOLOR IN BROWSE BROWSE-9   = ?
               tt-tarifador.valor:BGCOLOR IN BROWSE BROWSE-9      = ?
               tt-tarifador.duracao:BGCOLOR IN BROWSE BROWSE-9    = ?
               tt-tarifador.ramal:BGCOLOR IN BROWSE BROWSE-9      = ?.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

