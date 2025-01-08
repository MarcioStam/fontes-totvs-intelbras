&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME f_dlg_03_login
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS f_dlg_03_login 
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
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
    DEF INPUT PARAM p-proc AS HANDLE NO-UNDO.
    DEF INPUT PARAM p-prog-vers AS CHAR NO-UNDO.
/* Local Variable Definitions ---                                       */

{cdp/cd0666.i}
def new global shared var v_cod_usuar_corren as char no-undo.
DEF NEW GLOBAL SHARED VAR v_impres_layout AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_nom_disposit_so AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_tit_prog_dtsul AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rotina_intelbras AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f_dlg_03_login

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS v_cod_usuario v_cod_senha bt_ok bt_can ~
bt_hel2 rt_001 rt_cxcf 
&Scoped-Define DISPLAYED-OBJECTS v_cod_usuario v_cod_senha 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt_can AUTO-END-KEY 
     LABEL "Cancela" 
     SIZE 10 BY 1.

DEFINE BUTTON bt_hel2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt_ok AUTO-GO 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE v_cod_senha AS CHARACTER FORMAT "X(256)":U 
     LABEL "Senha" 
     VIEW-AS FILL-IN 
     SIZE 13.14 BY .88
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE v_cod_usuario AS CHARACTER FORMAT "X(256)":U 
     LABEL "Usu†rio" 
     VIEW-AS FILL-IN 
     SIZE 13.14 BY .88
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE RECTANGLE rt_001
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 42.43 BY 2.46.

DEFINE RECTANGLE rt_cxcf
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 42.29 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f_dlg_03_login
     v_cod_usuario AT ROW 1.42 COL 16.29 COLON-ALIGNED HELP
          "C¢digo Usu†rio"
     v_cod_senha AT ROW 2.42 COL 16.29 COLON-ALIGNED HELP
          "Senha do Usu†rio" BLANK 
     bt_ok AT ROW 4.08 COL 3 HELP
          "OK"
     bt_can AT ROW 4.08 COL 14 HELP
          "Cancela"
     bt_hel2 AT ROW 4.08 COL 33.29 HELP
          "Ajuda"
     rt_001 AT ROW 1.21 COL 2
     rt_cxcf AT ROW 3.88 COL 2
     SPACE(2.42) SKIP(0.15)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D NO-AUTO-VALIDATE  SCROLLABLE 
         BGCOLOR 8 FONT 1
         TITLE "Verifica Permiss∆o de Acesso"
         DEFAULT-BUTTON bt_ok.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB f_dlg_03_login 
/* ************************* Included-Libraries *********************** */

{esp/showmsg.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX f_dlg_03_login
                                                                        */
ASSIGN 
       FRAME f_dlg_03_login:SCROLLABLE       = FALSE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX f_dlg_03_login
/* Query rebuild information for DIALOG-BOX f_dlg_03_login
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX f_dlg_03_login */
&ANALYZE-RESUME

 
Define Temp-table tt-erros
    Field cod-erro  As Integer
    Field desc-erro As Character Format "x(256)":U
    Field desc-arq  As Character.



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME f_dlg_03_login
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f_dlg_03_login f_dlg_03_login
ON WINDOW-CLOSE OF FRAME f_dlg_03_login /* Verifica Permiss∆o de Acesso */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_can
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_can f_dlg_03_login
ON CHOOSE OF bt_can IN FRAME f_dlg_03_login /* Cancela */
or END-ERROR of frame f_dlg_03_login DO:
    RETURN "NOK".
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_ok f_dlg_03_login
ON CHOOSE OF bt_ok IN FRAME f_dlg_03_login /* OK */
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME} v_cod_senha v_cod_usuario.

    EMPTY TEMP-TABLE tt-erros.
    RUN btb/btapi910za.p (INPUT v_cod_usuario, 
                          INPUT v_cod_senha, 
                          OUTPUT TABLE tt-erros) NO-ERROR.
    IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4753) THEN DO:
        MESSAGE "Usu†rio n∆o encontrado!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        
        RETURN NO-APPLY.
    END.
    ELSE DO:
        IF can-FIND (FIRST tt-erros where tt-erros.cod-erro = 4758) THEN DO:
            MESSAGE "Senha para o usu†rio n∆o est†ˇcorreta!"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            
            RETURN NO-APPLY.
        END.
    END.

  RUN esp/utp/esbtb910zz-rpc.p ON SERVER p-proc TRANSACTION DISTINCT 
      (INPUT v_cod_usuario,
       INPUT v_cod_senha,
       INPUT p-prog-vers,
       INPUT v_rotina_intelbras,
       OUTPUT v_impres_layout,
       OUTPUT v_nom_disposit_so,
       OUTPUT v_tit_prog_dtsul,
       OUTPUT TABLE tt-erro)
      NO-ERROR.
  FOR FIRST tt-erro:
      RUN ShowMessage (IF ENTRY(3, tt-erro.mensagem, "|") = "NOK" THEN 1 ELSE 2, 
                       ENTRY(1, tt-erro.mensagem, "|"),
                       ENTRY(2, tt-erro.mensagem, "|")).
      IF ENTRY(3, tt-erro.mensagem, "|") = "NOK" THEN do:
          APPLY "entry" TO v_cod_usuario IN FRAME {&FRAME-NAME}.
          RETURN NO-APPLY.
      END.
  END.
  v_cod_usuar_corren = v_cod_usuario.  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK f_dlg_03_login 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  v_cod_usuario:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_usuar_corren.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI f_dlg_03_login  _DEFAULT-DISABLE
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
  HIDE FRAME f_dlg_03_login.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI f_dlg_03_login  _DEFAULT-ENABLE
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
  DISPLAY v_cod_usuario v_cod_senha 
      WITH FRAME f_dlg_03_login.
  ENABLE v_cod_usuario v_cod_senha bt_ok bt_can bt_hel2 rt_001 rt_cxcf 
      WITH FRAME f_dlg_03_login.
  {&OPEN-BROWSERS-IN-QUERY-f_dlg_03_login}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

