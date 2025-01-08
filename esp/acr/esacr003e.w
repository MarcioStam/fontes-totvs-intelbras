&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
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

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER p-raiz-cnpj AS CHARACTER   NO-UNDO.
/*DEFINE VARIABLE p-raiz-cnpj AS CHARACTER   NO-UNDO.

ASSIGN p-raiz-cnpj = "05866905".*/

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-tipo-reg  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-atualizou AS LOGICAL     NO-UNDO.

DEFINE TEMP-TABLE tt-detalhes NO-UNDO
    FIELD raiz-cnpj     AS CHARACTER
    FIELD dat-movto     AS DATE
    FIELD ind-tipo-reg  AS INTEGER
    FIELD nome-abrev    LIKE ped-venda.nome-abrev
    FIELD nr-pedcli     LIKE ped-venda.nr-pedcli
    FIELD cod-estabel   LIKE nota-fiscal.cod-estabel
    FIELD serie         LIKE nota-fiscal.serie
    FIELD nr-nota-fis   LIKE nota-fiscal.nr-nota-fis
    FIELD vl-total      AS DECIMAL.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME brMovtos

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-detalhes

/* Definitions for BROWSE brMovtos                                      */
&Scoped-define FIELDS-IN-QUERY-brMovtos tt-detalhes.raiz-cnpj tt-detalhes.dat-movto fnTipoRegistro(tt-detalhes.ind-tipo-reg) @ c-tipo-reg tt-detalhes.nome-abrev tt-detalhes.nr-pedcli tt-detalhes.cod-estabel tt-detalhes.serie tt-detalhes.nr-nota-fis tt-detalhes.vl-total   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brMovtos   
&Scoped-define SELF-NAME brMovtos
&Scoped-define QUERY-STRING-brMovtos FOR EACH tt-detalhes NO-LOCK                             BY   tt-detalhes.dat-movto                             BY   tt-detalhes.ind-tipo-reg INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brMovtos OPEN QUERY {&SELF-NAME} FOR EACH tt-detalhes NO-LOCK                             BY   tt-detalhes.dat-movto                             BY   tt-detalhes.ind-tipo-reg INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brMovtos tt-detalhes
&Scoped-define FIRST-TABLE-IN-QUERY-brMovtos tt-detalhes


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-brMovtos}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar brMovtos btOK 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnTipoRegistro C-Win 
FUNCTION fnTipoRegistro RETURNS CHARACTER
  ( pTipo AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btOK 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 91 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brMovtos FOR 
      tt-detalhes SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brMovtos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brMovtos C-Win _FREEFORM
  QUERY brMovtos NO-LOCK DISPLAY
      tt-detalhes.raiz-cnpj                                 FORMAT "x(10)":U            WIDTH 10  COLUMN-LABEL "Raiz CNPJ"
      tt-detalhes.dat-movto                                 FORMAT "99/99/9999":U       WIDTH 10  COLUMN-LABEL "Data Movto"
      fnTipoRegistro(tt-detalhes.ind-tipo-reg) @ c-tipo-reg FORMAT "x(15)":U            WIDTH 10  COLUMN-LABEL "Tipo Registro"
      tt-detalhes.nome-abrev                                                            WIDTH 13
      tt-detalhes.nr-pedcli                                                             WIDTH 8
      tt-detalhes.cod-estabel                                                           WIDTH 5
      tt-detalhes.serie                                                                 WIDTH 5
      tt-detalhes.nr-nota-fis                                                           WIDTH 8
      tt-detalhes.vl-total                                  FORMAT "->>>,>>>,>>9.99":U  WIDTH 11  COLUMN-LABEL "Valor Total"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 89 BY 14.96
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     brMovtos AT ROW 1.25 COL 2 WIDGET-ID 200
     btOK AT ROW 16.67 COL 2 WIDGET-ID 8
     rtToolBar AT ROW 16.46 COL 1 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 91.43 BY 17.25
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
         TITLE              = "Movimenta‡äes do Cliente - SupplierCard"
         HEIGHT             = 16.92
         WIDTH              = 91
         MAX-HEIGHT         = 30.58
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 30.58
         VIRTUAL-WIDTH      = 182.86
         MAX-BUTTON         = no
         RESIZE             = no
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
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
/* BROWSE-TAB brMovtos rtToolBar DEFAULT-FRAME */
ASSIGN 
       brMovtos:COLUMN-RESIZABLE IN FRAME DEFAULT-FRAME       = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brMovtos
/* Query rebuild information for BROWSE brMovtos
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-detalhes NO-LOCK
                            BY   tt-detalhes.dat-movto
                            BY   tt-detalhes.ind-tipo-reg INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brMovtos */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Movimenta‡äes do Cliente - SupplierCard */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Movimenta‡äes do Cliente - SupplierCard */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brMovtos
&Scoped-define SELF-NAME brMovtos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brMovtos C-Win
ON ROW-DISPLAY OF brMovtos IN FRAME DEFAULT-FRAME
DO:
    /* Linha do limite do cliente */
    IF  AVAIL tt-detalhes            AND
        tt-detalhes.ind-tipo-reg = 0 THEN DO:
        ASSIGN tt-detalhes.raiz-cnpj:BGCOLOR     IN BROWSE brMovtos = 10
               tt-detalhes.dat-movto:BGCOLOR     IN BROWSE brMovtos = 10
               c-tipo-reg:BGCOLOR                IN BROWSE brMovtos = 10
               tt-detalhes.nome-abrev:BGCOLOR    IN BROWSE brMovtos = 10
               tt-detalhes.nr-pedcli:BGCOLOR     IN BROWSE brMovtos = 10
               tt-detalhes.cod-estabel:BGCOLOR   IN BROWSE brMovtos = 10
               tt-detalhes.serie:BGCOLOR         IN BROWSE brMovtos = 10
               tt-detalhes.nr-nota-fis:BGCOLOR   IN BROWSE brMovtos = 10
               tt-detalhes.vl-total:BGCOLOR      IN BROWSE brMovtos = 10.

    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK C-Win
ON CHOOSE OF btOK IN FRAME DEFAULT-FRAME /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
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
    RUN initializeObjects.
    RUN enable_UI.
    IF  NOT THIS-PROCEDURE:PERSISTENT THEN
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
  ENABLE rtToolBar brMovtos btOK 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObjects C-Win 
PROCEDURE initializeObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ENABLE brMovtos
        WITH FRAME default-frame.

    EMPTY TEMP-TABLE tt-detalhes.

    /* Pedidos */
    FOR EACH  int-ped-aloc-supcard NO-LOCK
        WHERE int-ped-aloc-supcard.raiz-cnpj = p-raiz-cnpj
        BREAK BY int-ped-aloc-supcard.dat-movto:

        IF  FIRST-OF(int-ped-aloc-supcard.dat-movto) THEN DO:
            FIND FIRST int-emitente-supcard NO-LOCK
                WHERE  int-emitente-supcard.raiz-cnpj     = int-ped-aloc-supcard.raiz-cnpj
                AND    int-emitente-supcard.dat-avaliacao = int-ped-aloc-supcard.dat-movto NO-ERROR.

            CREATE tt-detalhes.
            ASSIGN tt-detalhes.raiz-cnpj     = int-ped-aloc-supcard.raiz-cnpj
                   tt-detalhes.dat-movto     = int-ped-aloc-supcard.dat-movto
                   tt-detalhes.ind-tipo-reg  = 0
                   tt-detalhes.vl-total      = IF AVAIL int-emitente-supcard THEN int-emitente-supcard.val-limite ELSE 0.
        END.

        FIND FIRST tt-detalhes EXCLUSIVE-LOCK
            WHERE  tt-detalhes.nome-abrev = int-ped-aloc-supcard.nome-abrev
            AND    tt-detalhes.nr-pedcli  = int-ped-aloc-supcard.nr-pedcli NO-ERROR.
        IF  NOT AVAIL tt-detalhes THEN DO:
            CREATE tt-detalhes.
            ASSIGN tt-detalhes.raiz-cnpj    = int-ped-aloc-supcard.raiz-cnpj
                   tt-detalhes.dat-movto    = int-ped-aloc-supcard.dat-movto
                   tt-detalhes.ind-tipo-reg = 1 /* Pedido */
                   tt-detalhes.nome-abrev   = int-ped-aloc-supcard.nome-abrev
                   tt-detalhes.nr-pedcli    = int-ped-aloc-supcard.nr-pedcli.
        END.

        ASSIGN tt-detalhes.vl-total = tt-detalhes.vl-total + int-ped-aloc-supcard.val-item-alocado.
    END.


    /* Notas Fiscais */
    FOR EACH  int-nfs-supcard NO-LOCK
        WHERE int-nfs-supcard.raiz-cnpj = p-raiz-cnpj
        BREAK BY int-nfs-supcard.dat-movto:

        IF  FIRST-OF(int-nfs-supcard.dat-movto) THEN DO:
            FIND FIRST tt-detalhes NO-LOCK
                WHERE  tt-detalhes.raiz-cnpj    = int-nfs-supcard.raiz-cnpj
                AND    tt-detalhes.dat-movto    = int-nfs-supcard.dat-movto
                AND    tt-detalhes.ind-tipo-reg = 0 NO-ERROR.
            IF  NOT AVAIL tt-detalhes THEN DO:
                FIND FIRST int-emitente-supcard NO-LOCK
                    WHERE  int-emitente-supcard.raiz-cnpj     = int-nfs-supcard.raiz-cnpj
                    AND    int-emitente-supcard.dat-avaliacao = int-nfs-supcard.dat-movto NO-ERROR.
    
                CREATE tt-detalhes.
                ASSIGN tt-detalhes.raiz-cnpj     = int-nfs-supcard.raiz-cnpj
                       tt-detalhes.dat-movto     = int-nfs-supcard.dat-movto
                       tt-detalhes.ind-tipo-reg  = 0
                       tt-detalhes.vl-total      = IF AVAIL int-emitente-supcard THEN int-emitente-supcard.val-limite ELSE 0.
            END.
        END.

        FIND FIRST tt-detalhes EXCLUSIVE-LOCK
            WHERE  tt-detalhes.cod-estabel = int-nfs-supcard.cod-estabel
            AND    tt-detalhes.serie       = int-nfs-supcard.serie
            AND    tt-detalhes.nr-nota-fis = int-nfs-supcard.nr-nota-fis NO-ERROR.
        IF  NOT AVAIL tt-detalhes THEN DO:
            CREATE tt-detalhes.
            ASSIGN tt-detalhes.raiz-cnpj    = int-nfs-supcard.raiz-cnpj
                   tt-detalhes.dat-movto    = int-nfs-supcard.dat-movto
                   tt-detalhes.ind-tipo-reg = 2 /* Nota Fiscal */
                   tt-detalhes.cod-estabel  = int-nfs-supcard.cod-estabel
                   tt-detalhes.serie        = int-nfs-supcard.serie
                   tt-detalhes.nr-nota-fis  = int-nfs-supcard.nr-nota-fis.
        END.

        ASSIGN tt-detalhes.vl-total = tt-detalhes.vl-total + int-nfs-supcard.val-faturado.
    END.

    {&OPEN-QUERY-brMovtos}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnTipoRegistro C-Win 
FUNCTION fnTipoRegistro RETURNS CHARACTER
  ( pTipo AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    CASE pTipo:
        WHEN 1 /* Pedido Alocado */ THEN
            RETURN "Pedido".
        WHEN 2 /* Nota Fiscal */ THEN
            RETURN "Nota Fiscal".
        OTHERWISE
            RETURN "Limite Cliente".
    END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

