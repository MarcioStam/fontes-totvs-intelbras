&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenace
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenace 
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

create widget-pool.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
define parameter buffer resgate-premios for resgate-premios.
define output parameter l-ok as logical no-undo.

/* Local Variable Definitions ---                                       */
{esp/utp/esutp044a.i}
{esp/utp/esutp044a.i _aux}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brUnidadeResgate

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES unid-neg-resgate tt_unid_negoc_aux ~
tt_unid_negoc

/* Definitions for BROWSE brUnidadeResgate                              */
&Scoped-define FIELDS-IN-QUERY-brUnidadeResgate unid-neg-resgate.cod_unid_negoc tt_unid_negoc_aux.des_unid_negoc unid-neg-resgate.perc-unid-neg   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brUnidadeResgate unid-neg-resgate.perc-unid-neg   
&Scoped-define ENABLED-TABLES-IN-QUERY-brUnidadeResgate unid-neg-resgate
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brUnidadeResgate unid-neg-resgate
&Scoped-define SELF-NAME brUnidadeResgate
&Scoped-define QUERY-STRING-brUnidadeResgate for each unid-neg-resgate    where unid-neg-resgate.cpf-cnpj   = resgate-premios.cpf-cnpj      and unid-neg-resgate.data-movto = resgate-premios.data-movto      and unid-neg-resgate.sequencia  = resgate-premios.sequencia, ~
          first tt_unid_negoc_aux       where tt_unid_negoc_aux.cod_unid_negoc = unid-neg-resgate.cod_unid_negoc
&Scoped-define OPEN-QUERY-brUnidadeResgate open query {&SELF-NAME} for each unid-neg-resgate    where unid-neg-resgate.cpf-cnpj   = resgate-premios.cpf-cnpj      and unid-neg-resgate.data-movto = resgate-premios.data-movto      and unid-neg-resgate.sequencia  = resgate-premios.sequencia, ~
          first tt_unid_negoc_aux       where tt_unid_negoc_aux.cod_unid_negoc = unid-neg-resgate.cod_unid_negoc.
&Scoped-define TABLES-IN-QUERY-brUnidadeResgate unid-neg-resgate ~
tt_unid_negoc_aux
&Scoped-define FIRST-TABLE-IN-QUERY-brUnidadeResgate unid-neg-resgate
&Scoped-define SECOND-TABLE-IN-QUERY-brUnidadeResgate tt_unid_negoc_aux


/* Definitions for BROWSE brUnidades                                    */
&Scoped-define FIELDS-IN-QUERY-brUnidades tt_unid_negoc.cod_unid_negoc tt_unid_negoc.des_unid_negoc   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brUnidades   
&Scoped-define SELF-NAME brUnidades
&Scoped-define QUERY-STRING-brUnidades for each tt_unid_negoc
&Scoped-define OPEN-QUERY-brUnidades open query {&SELF-NAME} for each tt_unid_negoc.
&Scoped-define TABLES-IN-QUERY-brUnidades tt_unid_negoc
&Scoped-define FIRST-TABLE-IN-QUERY-brUnidades tt_unid_negoc


/* Definitions for FRAME fPage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage0 ~
    ~{&OPEN-QUERY-brUnidadeResgate}~
    ~{&OPEN-QUERY-brUnidades}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS brUnidades btDesce btSobe brUnidadeResgate ~
btOk btCancela 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenace AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancela 
     LABEL "Cancelar" 
     SIZE 11 BY 1.13.

DEFINE BUTTON btDesce 
     IMAGE-UP FILE "image/im-abx1.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-abx1.bmp":U
     LABEL "" 
     SIZE 3.43 BY 1.

DEFINE BUTTON btOk 
     LABEL "OK" 
     SIZE 11 BY 1.13
     FONT 1.

DEFINE BUTTON btSobe 
     IMAGE-UP FILE "image/im-acm1.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-acm1.bmp":U
     LABEL "" 
     SIZE 3.43 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brUnidadeResgate FOR 
      unid-neg-resgate, 
      tt_unid_negoc_aux SCROLLING.

DEFINE QUERY brUnidades FOR 
      tt_unid_negoc SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brUnidadeResgate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brUnidadeResgate wMaintenace _FREEFORM
  QUERY brUnidadeResgate DISPLAY
      unid-neg-resgate.cod_unid_negoc
   tt_unid_negoc_aux.des_unid_negoc
   unid-neg-resgate.perc-unid-neg
enable
   unid-neg-resgate.perc-unid-neg
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 59 BY 4.5
         FONT 1.

DEFINE BROWSE brUnidades
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brUnidades wMaintenace _FREEFORM
  QUERY brUnidades DISPLAY
      tt_unid_negoc.cod_unid_negoc
   tt_unid_negoc.des_unid_negoc
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 59 BY 4.5
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     brUnidades AT ROW 1.25 COL 2 WIDGET-ID 200
     btDesce AT ROW 5.92 COL 17.72 WIDGET-ID 6
     btSobe AT ROW 5.92 COL 38 WIDGET-ID 8
     brUnidadeResgate AT ROW 7 COL 2 WIDGET-ID 300
     btOk AT ROW 11.75 COL 38 WIDGET-ID 2
     btCancela AT ROW 11.75 COL 50 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 60.72 BY 11.92
         FONT 1 WIDGET-ID 100.


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
  CREATE WINDOW wMaintenace ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 11.92
         WIDTH              = 60.72
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 80
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
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
/* SETTINGS FOR WINDOW wMaintenace
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* BROWSE-TAB brUnidades 1 fPage0 */
/* BROWSE-TAB brUnidadeResgate btSobe fPage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenace)
THEN wMaintenace:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brUnidadeResgate
/* Query rebuild information for BROWSE brUnidadeResgate
     _START_FREEFORM
open query {&SELF-NAME} for each unid-neg-resgate
   where unid-neg-resgate.cpf-cnpj   = resgate-premios.cpf-cnpj
     and unid-neg-resgate.data-movto = resgate-premios.data-movto
     and unid-neg-resgate.sequencia  = resgate-premios.sequencia,
   first tt_unid_negoc_aux
      where tt_unid_negoc_aux.cod_unid_negoc = unid-neg-resgate.cod_unid_negoc.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brUnidadeResgate */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brUnidades
/* Query rebuild information for BROWSE brUnidades
     _START_FREEFORM
open query {&SELF-NAME} for each tt_unid_negoc.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brUnidades */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenace
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenace wMaintenace
ON END-ERROR OF wMaintenace
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenace wMaintenace
ON WINDOW-CLOSE OF wMaintenace
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancela wMaintenace
ON CHOOSE OF btCancela IN FRAME fPage0 /* Cancelar */
do:
   apply "CLOSE":U to this-procedure.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDesce
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDesce wMaintenace
ON CHOOSE OF btDesce IN FRAME fPage0
do:
   if not available tt_unid_negoc then
      return no-apply.

   define variable r-unidade as rowid no-undo.

   create unid-neg-resgate.
   assign unid-neg-resgate.cpf-cnpj       = resgate-premios.cpf-cnpj
          unid-neg-resgate.data-movto     = resgate-premios.data-movto
          unid-neg-resgate.sequencia      = resgate-premios.sequencia
          unid-neg-resgate.cod_unid_negoc = tt_unid_negoc.cod_unid_negoc
          unid-neg-resgate.perc-unid-neg  = 0
          r-unidade                       = rowid(unid-neg-resgate).

   create tt_unid_negoc_aux.
   buffer-copy tt_unid_negoc to tt_unid_negoc_aux.

   delete tt_unid_negoc.

   {&open-query-brUnidadeResgate}
   reposition brUnidadeResgate to rowid r-unidade.

   {&open-query-brUnidades}
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOk wMaintenace
ON CHOOSE OF btOk IN FRAME fPage0 /* OK */
do:
   define variable d-perc as decimal no-undo.
   define buffer b-unid for unid-neg-resgate.

   for each b-unid no-lock
      where b-unid.cpf-cnpj   = resgate-premios.cpf-cnpj
        and b-unid.data-movto = resgate-premios.data-movto
        and b-unid.sequencia  = resgate-premios.sequencia:

      if b-unid.perc-unid-neg = 0 then do:
         run utp/ut-msgs.p ('show', 17680, '0').
         reposition brUnidadeResgate to rowid rowid(b-unid).
         return no-apply.
      end.

      assign d-perc = d-perc + b-unid.perc-unid-neg.
   end.

   if d-perc <> 0 then do:
      if d-perc < 100 then do:
         {utp/ut-liter.i menor * r}
         run utp/ut-msgs.p ('show', 17068, return-value).
         return no-apply.
      end.

      if d-perc > 100 then do:
         {utp/ut-liter.i maior * r}
         run utp/ut-msgs.p ('show', 17068, return-value).
         return no-apply.
      end.
   end.

   assign l-ok = yes.

   apply 'close' to this-procedure.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSobe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSobe wMaintenace
ON CHOOSE OF btSobe IN FRAME fPage0
do:
   if not available unid-neg-resgate then
      return no-apply.

   define variable r-unidade as rowid no-undo.

   create tt_unid_negoc.
   buffer-copy tt_unid_negoc_aux to tt_unid_negoc.
   assign r-unidade = rowid(tt_unid_negoc).

   find current unid-neg-resgate exclusive-lock.
   delete unid-neg-resgate.
   delete tt_unid_negoc_aux.

   {&open-query-brUnidades}
   reposition brUnidades to rowid r-unidade.

   {&open-query-brUnidadeResgate}
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brUnidadeResgate
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenace 


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
  
   /** Carrega browses **/
   run prgint/utb/utb907za.py ( input 1,
                                input-output table tt_unid_negoc ).

   for each unid-neg-resgate no-lock
      where unid-neg-resgate.cpf-cnpj   = resgate-premios.cpf-cnpj
        and unid-neg-resgate.data-movto = resgate-premios.data-movto
        and unid-neg-resgate.sequencia  = resgate-premios.sequencia:
      find tt_unid_negoc
         where tt_unid_negoc.cod_unid_negoc = unid-neg-resgate.cod_unid_negoc no-error.
      if available tt_unid_negoc then do:
         create tt_unid_negoc_aux.
         buffer-copy tt_unid_negoc to tt_unid_negoc_aux.
         delete tt_unid_negoc.
      end.
   end.
   
  RUN enable_UI.

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wMaintenace  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenace)
  THEN DELETE WIDGET wMaintenace.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wMaintenace  _DEFAULT-ENABLE
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
  ENABLE brUnidades btDesce btSobe brUnidadeResgate btOk btCancela 
      WITH FRAME fPage0 IN WINDOW wMaintenace.
  {&OPEN-BROWSERS-IN-QUERY-fPage0}
  VIEW wMaintenace.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

