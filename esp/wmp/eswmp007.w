&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
{utp/ut-glob.i}
{include/i_dbvers.i}
{cdp/cdcfgmat.i}

DEFINE VARIABLE cCdTrans        AS CHARACTER INITIAL "WMOUT004" NO-UNDO. /*Guarda o c¢digo da transacao */
DEF TEMP-TABLE ttWm-Etiqueta  NO-UNDO LIKE wm-etiqueta. /*Utilizado na bo de geracao da wm-etiqueta*/

{include/i_dbvers.i}
{cdp/cdcfgwms.i}      
{bcp/bcapi002.i}    /*** Definicao da temp-table para a API de criacao de etiquetas tt-etiqueta ***/
{bcp/bcapi001.i}    /* Definicao da temp-table tt-trans ---                     */
{bcp/bc9102.i}      /* Definicao da temp-table de erros do coleta de dados          */
{bcp/bc9107.i}      /* Campos de comunicacao com o adapter                          */
{method/dbotterr.i} /* Temp Table RowErros */

DEFINE TEMP-TABLE ttSerial NO-UNDO
       FIELD de-serial AS DECIMAL.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frame01

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-13 i-id-inicial ~
i-qtd-etiqueta btHelp2 btExecutar btFechar c-texto-2 
&Scoped-Define DISPLAYED-OBJECTS i-id-inicial i-qtd-etiqueta c-texto-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btExecutar 
     LABEL "Executar" 
     SIZE 10 BY 1.

DEFINE BUTTON btFechar 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-texto-2 AS CHARACTER FORMAT "X(256)":U INITIAL " Etiqueta" 
      VIEW-AS TEXT 
     SIZE 8 BY .67 NO-UNDO.

DEFINE VARIABLE i-id-inicial AS INTEGER FORMAT "9999999":U INITIAL 0 
     LABEL "ID Inicial" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE i-qtd-etiqueta AS INTEGER FORMAT ">>>,>>9":U INITIAL 0 
     LABEL "Quantidade Etiquetas" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 5.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frame01
     i-id-inicial AT ROW 4.5 COL 27 COLON-ALIGNED WIDGET-ID 44
     i-qtd-etiqueta AT ROW 5.5 COL 27 COLON-ALIGNED WIDGET-ID 30
     btHelp2 AT ROW 9.21 COL 80 WIDGET-ID 16
     btExecutar AT ROW 9.25 COL 2 WIDGET-ID 12
     btFechar AT ROW 9.25 COL 13 WIDGET-ID 14
     c-texto-2 AT ROW 2.5 COL 40 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     rtToolBar AT ROW 9 COL 1 WIDGET-ID 18
     RECT-13 AT ROW 2.75 COL 6 WIDGET-ID 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 9.46
         FONT 1 WIDGET-ID 100.


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
         TITLE              = "<insert window title>"
         HEIGHT             = 9.46
         WIDTH              = 90
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 108.43
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 108.43
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



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frame01
   FRAME-NAME                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* <insert window title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* <insert window title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExecutar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExecutar C-Win
ON CHOOSE OF btExecutar IN FRAME frame01 /* Executar */
DO:
   do  on error undo, return no-apply:
       run pi-executar.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFechar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFechar C-Win
ON CHOOSE OF btFechar IN FRAME frame01 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 C-Win
ON CHOOSE OF btHelp2 IN FRAME frame01 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-qtd-etiqueta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-qtd-etiqueta C-Win
ON F5 OF i-qtd-etiqueta IN FRAME frame01 /* Quantidade Etiquetas */
DO:
    run BTB/btb036ka.w /*prg_sea_layout_impres*/.
    /* if  v_rec_layout_impres <> ? then do with frame {&frame-name}:
        find first layout_impres
             where recid(layout_impres) = v_rec_layout_impres
             no-lock no-error.
        
    end. */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-qtd-etiqueta C-Win
ON MOUSE-SELECT-DBLCLICK OF i-qtd-etiqueta IN FRAME frame01 /* Quantidade Etiquetas */
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


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
  RUN pi-initialize.
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
  DISPLAY i-id-inicial i-qtd-etiqueta c-texto-2 
      WITH FRAME frame01 IN WINDOW C-Win.
  ENABLE rtToolBar RECT-13 i-id-inicial i-qtd-etiqueta btHelp2 btExecutar 
         btFechar c-texto-2 
      WITH FRAME frame01 IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-frame01}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar C-Win 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE i-cont   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-monta-serial AS CHAR FORMAT "x(15)" NO-UNDO.
    DEFINE VARIABLE iContId AS INTEGER     NO-UNDO.
    DEFINE VARIABLE l-erro AS LOGICAL     NO-UNDO.

    DEF VAR v-dt-carga-atual LIKE wm-param.dt-etiqueta-atual NO-UNDO.

    ASSIGN INPUT FRAME frame01 i-id-inicial i-qtd-etiqueta .

    IF i-id-inicial > (INT(SUBSTRING(wm-param.char-2,150,7)) + 1) + i-qtd-etiqueta THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 56,
                           INPUT "ID inicial").
        FIND FIRST wm-param NO-LOCK NO-ERROR.
        IF AVAIL wm-param AND SUBSTRING(wm-param.char-2,150,7) <> "" THEN
            ASSIGN i-id-inicial:SCREEN-VALUE IN FRAME frame01 = STRING((INT(SUBSTRING(wm-param.char-2,150,7)) + 1),"9999999").
        ELSE
            ASSIGN i-id-inicial:SCREEN-VALUE IN FRAME frame01 = "0000000".
        APPLY "ENTRY" TO i-id-inicial IN FRAME Frame01.
        RETURN "NOK":U.
    END.

    ASSIGN i-qtd-etiqueta = i-qtd-etiqueta - 1. /* diminui para considerar o id inicial */
    ASSIGN iContId = i-id-inicial.

    FOR EACH tt-etiqueta:
        DELETE tt-etiqueta.
    END.

    DO i-cont = i-id-inicial TO (i-id-inicial + i-qtd-etiqueta):

        ASSIGN c-monta-serial = SUBSTRING(STRING(YEAR(v-dt-carga-atual)),3,2) + 
                                STRING(iContId, '999999999999'). 

        IF NOT CAN-FIND(FIRST es-wm-box-movto-etiq WHERE
            es-wm-box-movto-etiq.val-etiq-separacao = DECIMAL(c-monta-serial) NO-LOCK) THEN DO:
            CREATE es-wm-box-movto-etiq.
            ASSIGN es-wm-box-movto-etiq.val-etiq-separacao = DECIMAL(c-monta-serial).
        END.

        CREATE tt-etiqueta.
        ASSIGN tt-etiqueta.cod-versao-integracao = 1
               tt-etiqueta.i-sequen              = i-cont
               tt-etiqueta.qt-etiqueta           = 0
               tt-etiqueta.cd-trans              = cCdTrans
               tt-etiqueta.tipo-etiq             = 105
               tt-etiqueta.auxiliar-11           = c-monta-serial
               tt-etiqueta.quantidade            = 1.

        ASSIGN iContId = iContId + 1.

        RUN pi-gera-impressao (INPUT TABLE tt-etiqueta,
                               INPUT tt-etiqueta.auxiliar-11,
                               OUTPUT l-erro).

        IF RETURN-VALUE = "OK":U THEN DO:
            FIND FIRST es-wm-box-movto-etiq WHERE
                es-wm-box-movto-etiq.val-etiq-separacao = DECIMAL(c-monta-serial) EXCLUSIVE-LOCK NO-ERROR. 
            IF AVAIL es-wm-box-movto-etiq THEN DO:
                ASSIGN es-wm-box-movto-etiq.int-1                                                       = es-wm-box-movto-etiq.int-1 + 1
                       SUBSTRING(es-wm-box-movto-etiq.char-1,1  + (es-wm-box-movto-etiq.int-1 *  30), 10) = c-seg-usuario
                       SUBSTRING(es-wm-box-movto-etiq.char-1,11 + (es-wm-box-movto-etiq.int-1 *  30), 10) = STRING(TODAY,"99/99/9999")
                       SUBSTRING(es-wm-box-movto-etiq.char-1,21 + (es-wm-box-movto-etiq.int-1 *  30), 10) = STRING(TIME,"HH:MM:SS").
                                 
            END.
        END.
    END.
    
    FIND FIRST wm-param EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL wm-param AND 
       INT(SUBSTRING(wm-param.char-2,150,7)) < INT(i-id-inicial + i-qtd-etiqueta) THEN DO:
        ASSIGN SUBSTRING(wm-param.char-2,150,7) = STRING(INT(i-id-inicial + i-qtd-etiqueta),"9999999").
    END.
    FIND CURRENT wm-param NO-LOCK NO-ERROR.

    IF l-erro = YES THEN
        MESSAGE "Impress∆o nao realizada." VIEW-AS ALERT-BOX INFORMATION.
    ELSE 
        MESSAGE "Impress∆o realizada com Sucesso" VIEW-AS ALERT-BOX INFORMATION.

    FIND FIRST wm-param NO-LOCK NO-ERROR.
    IF AVAIL wm-param AND SUBSTRING(wm-param.char-2,150,7) <> "" THEN
        ASSIGN i-id-inicial:SCREEN-VALUE IN FRAME frame01 = STRING((INT(SUBSTRING(wm-param.char-2,150,7)) + 1),"9999999").
    ELSE
        ASSIGN i-id-inicial:SCREEN-VALUE IN FRAME frame01 = "0000000".

    ASSIGN i-qtd-etiqueta:SCREEN-VALUE IN FRAME frame01 = "0".

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-impressao C-Win 
PROCEDURE pi-gera-impressao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAM TABLE FOR TT-ETIQUETA.
    DEFINE INPUT PARAM pidEtiq AS CHAR FORMAT "x(15)".
    DEFINE OUTPUT PARAM l-erro AS LOG INIT NO.
    
    EMPTY TEMP-TABLE TT-TRANS.

    /* Se estiver configurado, imprime  */
    CREATE tt-trans.
    ASSIGN tt-trans.cod-versao-integracao = 1
           tt-trans.i-sequen              = 1
           tt-trans.cd-trans              = tt-etiqueta.cd-trans
           tt-trans.usuario               = c-seg-usuario
           tt-trans.atualizada            = NO
           tt-trans.etiqueta              = YES
           tt-trans.detalhe               = " ID:"     + string(pidEtiq).
    RAW-TRANSFER tt-etiqueta TO tt-trans.conteudo-trans.

    RUN bcp/bcapi001.p (INPUT-OUTPUT TABLE tt-trans,
                        INPUT-OUTPUT TABLE tt-erro).
    FIND FIRST tt-erro NO-ERROR.
    IF AVAIL tt-erro THEN DO:
        RUN cdp/cd0666.w (INPUT TABLE tt-erro).
        ASSIGN l-erro = YES.
    END.
    
    RETURN 'OK':u.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-initialize C-Win 
PROCEDURE pi-initialize :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN CURRENT-WINDOW:TITLE = "SCM - Impress∆o de Etiquetas Volumes Transporte".

    FIND FIRST wm-param NO-LOCK NO-ERROR.
    IF AVAIL wm-param AND SUBSTRING(wm-param.char-2,150,7) <> "" THEN
        ASSIGN i-id-inicial:SCREEN-VALUE IN FRAME frame01 = STRING((INT(SUBSTRING(wm-param.char-2,150,7)) + 1),"9999999").
    ELSE
        ASSIGN i-id-inicial:SCREEN-VALUE IN FRAME frame01 = "0000000".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

