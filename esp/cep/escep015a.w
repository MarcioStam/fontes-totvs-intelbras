&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME flocal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS flocal 
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

/* Local Variable Definitions ---                                       */

    
DEF INPUT-OUTPUT PARAM p-local     like item.cod-localiz.
DEF INPUT-OUTPUT PARAM p-depos     like item.deposito-pad initial "alm".
DEF INPUT-OUTPUT PARAM p-it-codigo LIKE ITEM.it-codigo.
DEF INPUT-OUTPUT PARAM p-nr-ae-ini like ae-item.nr-ae.
DEF INPUT-OUTPUT PARAM p-seq-ini   like ae-item.sequencia.
DEF INPUT-OUTPUT PARAM p-seq-fim   like ae-item.sequencia initial 999.
DEF INPUT-OUTPUT PARAM p-nr-ae     like ae-item.nr-ae.

def temp-table tt-vago
    field localizacao   like local.localizacao
    field it-codigo     like item.it-codigo
    field saldo         like saldo-estoq.qtidade-atu
    index codigo is primary localizacao.

def var i-nr-ae     like ae-item.nr-ae.
{upc\btb910za-upc.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME flocal
&Scoped-define BROWSE-NAME br-local

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES saldo-estoq ae-item

/* Definitions for BROWSE br-local                                      */
&Scoped-define FIELDS-IN-QUERY-br-local ae-item.nr-ae ae-item.sequencia ae-item.localizacao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-local   
&Scoped-define SELF-NAME br-local
&Scoped-define OPEN-QUERY-br-local if INPUT FRAME flocal fi-nr-ae-ini <> 0 then    open query {&SELF-NAME}         for each saldo-estoq no-lock             where saldo-estoq.it-codigo     = p-it-codigo               and saldo-estoq.cod-estabel   = "v_cod_estab_usuar"               and saldo-estoq.cod-depos     = p-depos               and saldo-estoq.qtidade-atu   > 0, ~
                     each ae-item no-lock where ae-item.cod-estabel = saldo-estoq.cod-estabel and  ae-item.nr-ae      = INPUT FRAME flocal fi-nr-ae-ini                      and ae-item.sequencia >= INPUT FRAME flocal fi-seq-ini                      and ae-item.sequencia <= INPUT FRAME flocal fi-seq-fim                      and ae-item.it-codigo  = p-it-codigo                      and not ae-item.situacao                      and ae-item.localizacao = saldo-estoq.cod-localiz                      by ae-item.sequencia                      by ae-item.localizacao. else    open query {&SELF-NAME}         for each saldo-estoq no-lock             where saldo-estoq.it-codigo     = p-it-codigo               and saldo-estoq.cod-estabel   = v_cod_estab_usuar               and saldo-estoq.cod-depos     = p-depos               and saldo-estoq.qtidade-atu   > 0, ~
                     each ae-item no-lock where ae-item.cod-estabel = saldo-estoq.cod-estabel and  ae-item.it-codigo = p-it-codigo                      and ae-item.sequencia >= INPUT FRAME flocal fi-seq-ini                      and ae-item.sequencia <= INPUT FRAME flocal fi-seq-fim                      and not ae-item.situacao                      and ae-item.localizacao = saldo-estoq.cod-localiz                      by ae-item.nr-ae                      by ae-item.sequencia                      by ae-item.localizacao.
&Scoped-define TABLES-IN-QUERY-br-local saldo-estoq ae-item
&Scoped-define FIRST-TABLE-IN-QUERY-br-local saldo-estoq
&Scoped-define SECOND-TABLE-IN-QUERY-br-local ae-item


/* Definitions for DIALOG-BOX flocal                                    */
&Scoped-define OPEN-BROWSERS-IN-QUERY-flocal ~
    ~{&OPEN-QUERY-br-local}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi-nr-ae-ini fi-seq-ini fi-seq-fim bt-ok ~
br-local Btn_OK IMAGE-1 IMAGE-2 RECT-11 RECT-12 
&Scoped-Define DISPLAYED-OBJECTS fi-nr-ae-ini fi-seq-ini fi-seq-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ok 
     IMAGE-UP FILE "image/im-chck1.bmp":U
     LABEL "Ok" 
     SIZE 7 BY 1.13.

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 13 BY 1.13
     BGCOLOR 8 .

DEFINE VARIABLE fi-nr-ae-ini AS INTEGER FORMAT "9999999" INITIAL 0 
     LABEL "Nr AE" 
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88.

DEFINE VARIABLE fi-seq-fim AS INTEGER FORMAT "999" INITIAL 999 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88.

DEFINE VARIABLE fi-seq-ini AS INTEGER FORMAT "999" INITIAL 0 
     LABEL "Sequencia" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY 1.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 70 BY 1.63
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 70 BY 2.5.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-local FOR 
      saldo-estoq, 
      ae-item SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-local
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-local flocal _FREEFORM
  QUERY br-local DISPLAY
      ae-item.nr-ae
    ae-item.sequencia
    ae-item.localizacao
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 70 BY 9.25
         FONT 1 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME flocal
     fi-nr-ae-ini AT ROW 1.29 COL 21.57 COLON-ALIGNED
     fi-seq-ini AT ROW 2.29 COL 21.57 COLON-ALIGNED
     fi-seq-fim AT ROW 2.29 COL 38.57 COLON-ALIGNED NO-LABEL
     bt-ok AT ROW 2.25 COL 63
     br-local AT ROW 3.75 COL 1
     Btn_OK AT ROW 13.5 COL 2
     IMAGE-1 AT ROW 2.29 COL 28.57
     IMAGE-2 AT ROW 2.29 COL 37.43
     RECT-11 AT ROW 13.25 COL 1
     RECT-12 AT ROW 1 COL 1
     SPACE(0.56) SKIP(11.53)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 1
         TITLE "Localiza‡Æo"
         DEFAULT-BUTTON Btn_OK.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX flocal
   Custom                                                               */
/* BROWSE-TAB br-local bt-ok flocal */
ASSIGN 
       FRAME flocal:SCROLLABLE       = FALSE
       FRAME flocal:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-local
/* Query rebuild information for BROWSE br-local
     _START_FREEFORM
if INPUT FRAME flocal fi-nr-ae-ini <> 0 then
   open query {&SELF-NAME}
        for each saldo-estoq no-lock
            where saldo-estoq.it-codigo     = p-it-codigo
              and saldo-estoq.cod-estabel   = v_cod_estab_usuar
              and saldo-estoq.cod-depos     = p-depos
              and saldo-estoq.qtidade-atu   > 0,
              each ae-item no-lock
                   where ae-item.cod-estabel = saldo-estoq.cod-estabel
                     and ae-item.nr-ae      = INPUT FRAME flocal fi-nr-ae-ini
                     and ae-item.sequencia >= INPUT FRAME flocal fi-seq-ini
                     and ae-item.sequencia <= INPUT FRAME flocal fi-seq-fim
                     and ae-item.it-codigo  = p-it-codigo
                     and not ae-item.situacao
                     and ae-item.localizacao = saldo-estoq.cod-localiz
                     by ae-item.sequencia
                     by ae-item.localizacao.
else
   open query {&SELF-NAME}
        for each saldo-estoq no-lock
            where saldo-estoq.it-codigo     = p-it-codigo
              and saldo-estoq.cod-estabel   = v_cod_estab_usuar
              and saldo-estoq.cod-depos     = p-depos
              and saldo-estoq.qtidade-atu   > 0,
              each ae-item no-lock
                   where ae-item.cod-estabel = saldo-estoq.cod-estabel 
                     and ae-item.it-codigo = p-it-codigo
                     and ae-item.sequencia >= INPUT FRAME flocal fi-seq-ini
                     and ae-item.sequencia <= INPUT FRAME flocal fi-seq-fim
                     and not ae-item.situacao
                     and ae-item.localizacao = saldo-estoq.cod-localiz
                     by ae-item.nr-ae
                     by ae-item.sequencia
                     by ae-item.localizacao.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-local */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME flocal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL flocal flocal
ON WINDOW-CLOSE OF FRAME flocal /* Localiza‡Æo */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-local
&Scoped-define SELF-NAME br-local
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-local flocal
ON MOUSE-SELECT-DBLCLICK OF br-local IN FRAME flocal
DO:
  APPLY "return" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-local flocal
ON RETURN OF br-local IN FRAME flocal
DO:
  APPLY "choose" TO btn_ok.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok flocal
ON CHOOSE OF bt-ok IN FRAME flocal /* Ok */
DO:
  ASSIGN INPUT FRAME flocal fi-nr-ae-ini fi-seq-ini fi-seq-fim.

  {&OPEN-QUERY-br-local}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK flocal
ON CHOOSE OF Btn_OK IN FRAME flocal /* OK */
DO:
    ASSIGN p-nr-ae-ini = INPUT FRAME flocal fi-nr-ae-ini
           p-seq-ini   = INPUT FRAME flocal fi-seq-ini
           p-seq-fim   = INPUT FRAME flocal fi-seq-fim.
     
    IF AVAIL saldo-estoq THEN 
        ASSIGN p-local = saldo-estoq.cod-localiz.
    
    IF AVAIL ae-item THEN
        ASSIGN p-nr-ae = ae-item.nr-ae.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK flocal 


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
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI flocal  _DEFAULT-DISABLE
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
  HIDE FRAME flocal.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI flocal  _DEFAULT-ENABLE
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
  DISPLAY fi-nr-ae-ini fi-seq-ini fi-seq-fim 
      WITH FRAME flocal.
  ENABLE fi-nr-ae-ini fi-seq-ini fi-seq-fim bt-ok br-local Btn_OK IMAGE-1 
         IMAGE-2 RECT-11 RECT-12 
      WITH FRAME flocal.
  VIEW FRAME flocal.
  {&OPEN-BROWSERS-IN-QUERY-flocal}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

