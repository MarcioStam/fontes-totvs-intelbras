&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*****************************************************************************
**     Programa.........: esp/acr/esacr003a
**     Descricao .......: Relat¢rio 
**     Versao...........: 1.00.000
**     Autor............: Medeiros
**     Criado...........: 09/12/2004
**     Desc. Atualizaá∆o: 
**     Autor............: 
*******************************************************************************/

CREATE WIDGET-POOL.

DEF VAR c-ant                 AS CHAR.
DEF VAR v_num_ped_exec_rpw    AS INTE.
DEF VAR v_log_det             AS logi INIT NO.
DEF VAR v_cod_exessao         AS CHAR.
DEF VAR c-impressora          AS CHAR.
DEF VAR c-layout              AS CHAR.
DEF VAR wh-exessao            as HANDLE.

DEF VAR i-cont                AS INT.

DEF OUTPUT PARAM p-cod-mensagem-ini        LIKE msg_financ.cod_mensagem.
DEF OUTPUT PARAM p-c-narrativa-ini         AS CHAR FORMAT "x(2000)".
DEF OUTPUT PARAM p-cod-mensagem-fim        LIKE msg_financ.cod_mensagem.
DEF OUTPUT PARAM p-c-narrativa-fim         AS CHAR FORMAT "x(2000)".
DEF OUTPUT PARAM p-ok                      AS LOG.

DEFINE NEW GLOBAL SHARED VARIABLE v_rec_msg_financ AS RECID NO-UNDO.  

 /* Vari†veis utilizadas na integraá∆o com o EMS5 */
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
def new global shared var v_cod_estab_usuar
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estab"
    no-undo.
def new global shared var v_cod_grp_usuar_lst
    as character
    format "x(3)":U
    label "Grupo Usu†rios"
    column-label "Grupo"
    no-undo.
def new global shared var v_cod_idiom_usuar
    as character
    format "x(8)":U
    label "Idioma"
    column-label "Idioma"
    no-undo.
def new global shared var v_cod_pais_empres_usuar
    as character
    format "x(3)":U
    label "Pa°s Empresa Usu†rio"
    column-label "Pa°s"
    no-undo.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.
def new global shared var v_cod_usuar_corren_criptog
    as character
    format "x(16)":U
    no-undo.

def new global shared var v5_cod_empres_usuar
    as character
    format 'x(3)'
    label 'Empresa'
    column-label 'Empresa'
    no-undo.
def new global shared var v5_cod_estab_usuar
    as character
    format 'x(3)'
    label 'Estabelecimento'
    column-label 'Estab'
    no-undo.
def new global shared var v5_cod_grp_usuar_lst 
    as character 
    label 'Grupo Usu†rios' 
    column-label 'Grupo' 
    no-undo.
def new global shared var v5_cod_idiom_usuar
    as character
    format 'x(8)'
    label 'Idioma'
    column-label 'Idioma'
    no-undo.
def new global shared var v5_cod_pais_empres_usuar
    as character
    format 'x(3)'
    label 'Pa°s Empresa Usu†rio'
    column-label 'Pa°s'
    no-undo.
def new global shared var v5_cod_usuar_corren
    as character
    format 'x(12)'
    label 'Usu†rio Corrente'
    column-label 'Usu†rio Corrente'
    no-undo.
def new global shared var v5_cod_usuar_corren_criptog
    as character
    format 'x(16)'
    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-relat

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES mensagem

/* Definitions for FRAME f-relat                                        */
&Scoped-define QUERY-STRING-f-relat FOR EACH mensagem SHARE-LOCK
&Scoped-define OPEN-QUERY-f-relat OPEN QUERY f-relat FOR EACH mensagem SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-f-relat mensagem
&Scoped-define FIRST-TABLE-IN-QUERY-f-relat mensagem


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cod-mensagem-ini c-narrativa-ini ~
cod-mensagem-fim c-narrativa-fim bt-ok bt-salva RECT-2 RECT-31 RECT-32 ~
RECT-33 RECT-34 
&Scoped-Define DISPLAYED-OBJECTS cod-mensagem-ini texto-mensag-ini ~
c-narrativa-ini cod-mensagem-fim texto-mensag-fim c-narrativa-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ok 
     LABEL "OK" 
     SIZE 11.14 BY 1 TOOLTIP "OK"
     FONT 1.

DEFINE BUTTON bt-salva 
     LABEL "Fechar" 
     SIZE 11.14 BY 1 TOOLTIP "Fechar/Salvar"
     FONT 1.

DEFINE VARIABLE c-narrativa-fim AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 60 BY 3.21.

DEFINE VARIABLE c-narrativa-ini AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 60 BY 3.21.

DEFINE VARIABLE texto-mensag-fim AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 60 BY 3.25.

DEFINE VARIABLE texto-mensag-ini AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 60 BY 3.21
     FGCOLOR 0 .

DEFINE VARIABLE cod-mensagem-fim AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Mensagem Padr∆o Final" 
     VIEW-AS FILL-IN 
     SIZE 3.29 BY .88.

DEFINE VARIABLE cod-mensagem-ini AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Mensagem Padr∆o Inicial" 
     VIEW-AS FILL-IN 
     SIZE 3.29 BY .88.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 80 BY 1.54
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80.72 BY 5.25.

DEFINE RECTANGLE RECT-32
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80.72 BY 4.13.

DEFINE RECTANGLE RECT-33
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80.72 BY 5.25.

DEFINE RECTANGLE RECT-34
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80.72 BY 4.13.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY f-relat FOR 
      mensagem SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-relat
     cod-mensagem-ini AT ROW 1.75 COL 26 COLON-ALIGNED
     texto-mensag-ini AT ROW 2.79 COL 11 NO-LABEL
     c-narrativa-ini AT ROW 7.42 COL 11 NO-LABEL
     cod-mensagem-fim AT ROW 11.88 COL 26 COLON-ALIGNED
     texto-mensag-fim AT ROW 12.92 COL 11 NO-LABEL
     c-narrativa-fim AT ROW 17.54 COL 11 NO-LABEL
     bt-ok AT ROW 21.58 COL 2
     bt-salva AT ROW 21.58 COL 14
     RECT-2 AT ROW 21.29 COL 1
     RECT-31 AT ROW 1.25 COL 1
     RECT-32 AT ROW 6.88 COL 1
     RECT-33 AT ROW 11.38 COL 1
     RECT-34 AT ROW 16.96 COL 1
     " Mensagem Inicial" VIEW-AS TEXT
          SIZE 15 BY .54 AT ROW 1 COL 3
          FONT 6
     " Narrativa Inicial" VIEW-AS TEXT
          SIZE 17 BY .54 AT ROW 6.63 COL 3
          FONT 6
     " Mensagem Final" VIEW-AS TEXT
          SIZE 15 BY .54 AT ROW 11.13 COL 3
          FONT 6
     " Narrativa Final" VIEW-AS TEXT
          SIZE 17 BY .54 AT ROW 16.75 COL 3
          FONT 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.72 BY 23.21
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Narrativa E-mail - ESACR014C"
         COLUMN             = 36
         ROW                = 4.42
         HEIGHT             = 22.17
         WIDTH              = 80.57
         MAX-HEIGHT         = 29.13
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 29.13
         VIRTUAL-WIDTH      = 146.29
         MAX-BUTTON         = no
         RESIZE             = no
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-relat
   Custom                                                               */
/* SETTINGS FOR EDITOR texto-mensag-fim IN FRAME f-relat
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR texto-mensag-ini IN FRAME f-relat
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-relat
/* Query rebuild information for FRAME f-relat
     _TblList          = "mgcad.mensagem"
     _Query            is NOT OPENED
*/  /* FRAME f-relat */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Narrativa E-mail - ESACR014C */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Narrativa E-mail - ESACR014C */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok C-Win
ON CHOOSE OF bt-ok IN FRAME f-relat /* OK */
DO:

  FIND FIRST msg_financ NO-LOCK
      WHERE msg_financ.cod_mensagem = INPUT FRAME {&FRAME-NAME} cod-mensagem-ini NO-ERROR.
  IF NOT AVAIL msg_financ THEN DO:
      MESSAGE "Mensagem Padr∆o Inicial n∆o cadastrada"
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      RETURN NO-APPLY.
  END.
  FIND FIRST msg_financ NO-LOCK
      WHERE msg_financ.cod_mensagem = INPUT FRAME {&FRAME-NAME} cod-mensagem-fim NO-ERROR.
  IF NOT AVAIL msg_financ THEN DO:
      MESSAGE "Mensagem Padr∆o Final n∆o cadastrada"
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      RETURN NO-APPLY.
  END.

  ASSIGN p-cod-mensagem-ini = INPUT FRAME {&FRAME-NAME} cod-mensagem-ini
         p-c-narrativa-ini  = INPUT FRAME {&FRAME-NAME} c-narrativa-ini
         p-cod-mensagem-fim = INPUT FRAME {&FRAME-NAME} cod-mensagem-fim
         p-c-narrativa-fim  = INPUT FRAME {&FRAME-NAME} c-narrativa-fim
         p-ok               = YES.

  APPLY "close" TO THIS-PROCEDURE.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-salva
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-salva C-Win
ON CHOOSE OF bt-salva IN FRAME f-relat /* Fechar */
DO:
    
    ASSIGN p-ok = NO.
    
    APPLY "close" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cod-mensagem-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-mensagem-fim C-Win
ON F5 OF cod-mensagem-fim IN FRAME f-relat /* Mensagem Padr∆o Final */
DO:
  RUN prgint/ufn/ufn004ka.r.
  FIND msg_financ NO-LOCK 
      WHERE RECID(msg_financ) = v_rec_msg_financ NO-ERROR.
  IF AVAIL msg_financ THEN 
      ASSIGN cod-mensagem-fim:SCREEN-VALUE IN FRAME f-relat = STRING(msg_financ.cod_mensagem)
             texto-mensag-fim:SCREEN-VALUE IN FRAME f-relat = STRING(msg_financ.des_mensagem).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-mensagem-fim C-Win
ON LEAVE OF cod-mensagem-fim IN FRAME f-relat /* Mensagem Padr∆o Final */
DO:
    FIND FIRST msg_financ NO-LOCK
        WHERE msg_financ.cod_mensagem = INPUT FRAME {&FRAME-NAME} cod-mensagem-fim NO-ERROR.
    ASSIGN texto-mensag-fim:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF AVAIL msg_financ THEN msg_financ.des_mensagem ELSE "".
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-mensagem-fim C-Win
ON MOUSE-SELECT-DBLCLICK OF cod-mensagem-fim IN FRAME f-relat /* Mensagem Padr∆o Final */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cod-mensagem-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-mensagem-ini C-Win
ON F5 OF cod-mensagem-ini IN FRAME f-relat /* Mensagem Padr∆o Inicial */
DO:
  RUN prgint/ufn/ufn004ka.r.
  FIND msg_financ NO-LOCK 
      WHERE RECID(msg_financ) = v_rec_msg_financ NO-ERROR.
  IF AVAIL msg_financ THEN 
      ASSIGN cod-mensagem-ini:SCREEN-VALUE IN FRAME f-relat = STRING(msg_financ.cod_mensagem)
             texto-mensag-ini:SCREEN-VALUE IN FRAME f-relat = STRING(msg_financ.des_mensagem).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-mensagem-ini C-Win
ON LEAVE OF cod-mensagem-ini IN FRAME f-relat /* Mensagem Padr∆o Inicial */
DO:
    FIND FIRST msg_financ NO-LOCK
        WHERE msg_financ.cod_mensagem = INPUT FRAME {&FRAME-NAME} cod-mensagem-ini NO-ERROR.
    ASSIGN texto-mensag-ini:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF AVAIL msg_financ THEN msg_financ.des_mensagem ELSE "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-mensagem-ini C-Win
ON MOUSE-SELECT-DBLCLICK OF cod-mensagem-ini IN FRAME f-relat /* Mensagem Padr∆o Inicial */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

cod-mensagem-ini:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME f-relat.
cod-mensagem-fim:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME f-relat.

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
  DISPLAY cod-mensagem-ini texto-mensag-ini c-narrativa-ini cod-mensagem-fim 
          texto-mensag-fim c-narrativa-fim 
      WITH FRAME f-relat IN WINDOW C-Win.
  ENABLE cod-mensagem-ini c-narrativa-ini cod-mensagem-fim c-narrativa-fim 
         bt-ok bt-salva RECT-2 RECT-31 RECT-32 RECT-33 RECT-34 
      WITH FRAME f-relat IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-vld-usuario C-Win 
PROCEDURE pi-vld-usuario :
/* */
FIND prog_dtsul NO-LOCK
    WHERE prog_dtsul.cod_prog_dtsul = "esacr014a" NO-ERROR.

IF AVAIL prog_dtsul THEN 
DO:
  FOR EACH usuar_grp_usuar NO-LOCK
      WHERE usuar_grp_usuar.cod_usuar = v_cod_usuar_corren:
    IF NOT CAN-FIND(FIRST prog_dtsul_segur NO-LOCK
                    WHERE  prog_dtsul_segur.cod_prog_dtsul = "esacr014a"
                      AND (prog_dtsul_segur.cod_grp_usuar  = usuar_grp_usuar.cod_grp_usuar
                       OR  prog_dtsul_segur.cod_grp_usuar  = "*")) THEN 
    DO:
      MESSAGE "Usu†rio n∆o tem Permiss∆o" SKIP
              "Verifique com o Administrador as permiss‰es para acessar este programa!" VIEW-AS ALERT-BOX ERROR.
      RETURN 'nok'.
    END.
  END.
END.
ELSE 
DO:
  MESSAGE "Programa n∆o Cadastrado no Menu!" VIEW-AS ALERT-BOX ERROR.
  RETURN 'nok'.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_message C-Win 
PROCEDURE pi_message :
/* */
def input param c_action    as char    no-undo.
def input param i_msg       as integer no-undo.
def input param c_param     as char    no-undo.

def var c_prg_msg           as char    no-undo.

assign c_prg_msg = "messages/"
                 + string(trunc(i_msg / 1000,0),"99")
                 + "/msg"
                 + string(i_msg, "99999").

if search(c_prg_msg + ".r") = ? and search(c_prg_msg + ".p") = ? then 
do:
  message "Mensagem nr. " i_msg "!!!" skip
          "Programa Mensagem" c_prg_msg "n∆o encontrado."
          view-as alert-box error.
  return error.
end.
run value(c_prg_msg + ".p") (input c_action, input c_param).
return return-value.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

