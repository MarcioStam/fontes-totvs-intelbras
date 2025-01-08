&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          emscad             PROGRESS
          emsmov             PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME frame-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS frame-2 
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

def temp-table tt-comis-deb-cred LIKE comis-deb-cred
    FIELD descricao   LIKE mov-comis.descricao
    FIELD selecao     AS CHAR FORMAT 'x(1)' LABEL '' COLUMN-LABEL 'Sele‡Æo'.

def temp-table tt_repres
    field cdn_repres     LIKE representante.cdn_repres.

/* Parameters Definitions ---                                           */
DEF INPUT PARAM p_cdn_fornec AS INTEGER NO-UNDO.
DEF INPUT PARAM p_data_ini   AS DATE NO-UNDO.   
DEF INPUT PARAM p_data_fim   AS DATE NO-UNDO.   
DEF INPUT-OUTPUT PARAM TABLE FOR tt-comis-deb-cred.
DEF INPUT PARAM p_abre_query AS LOGICAL NO-UNDO.

/* Local Variable Definitions ---                                       */

DEF VAR ct_codigo_aux LIKE mgesp.comis-deb-cred.ct-codigo NO-UNDO.
DEF VAR sc_codigo_aux LIKE mgesp.comis-deb-cred.sc-codigo NO-UNDO.

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frame-2
&Scoped-define BROWSE-NAME br-comis-deb-cred

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-comis-deb-cred

/* Definitions for BROWSE br-comis-deb-cred                             */
&Scoped-define FIELDS-IN-QUERY-br-comis-deb-cred tt-comis-deb-cred.selecao tt-comis-deb-cred.base-final tt-comis-deb-cred.deb-cred tt-comis-deb-cred.descricao tt-comis-deb-cred.ct-codigo tt-comis-deb-cred.unid-neg tt-comis-deb-cred.sc-codigo tt-comis-deb-cred.valor tt-comis-deb-cred.historico   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-comis-deb-cred tt-comis-deb-cred.ct-codigo ~
tt-comis-deb-cred.sc-codigo   
&Scoped-define ENABLED-TABLES-IN-QUERY-br-comis-deb-cred tt-comis-deb-cred
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br-comis-deb-cred tt-comis-deb-cred
&Scoped-define SELF-NAME br-comis-deb-cred
&Scoped-define QUERY-STRING-br-comis-deb-cred FOR EACH tt-comis-deb-cred
&Scoped-define OPEN-QUERY-br-comis-deb-cred OPEN QUERY {&SELF-NAME} FOR EACH tt-comis-deb-cred.
&Scoped-define TABLES-IN-QUERY-br-comis-deb-cred tt-comis-deb-cred
&Scoped-define FIRST-TABLE-IN-QUERY-br-comis-deb-cred tt-comis-deb-cred


/* Definitions for DIALOG-BOX frame-2                                   */
&Scoped-define OPEN-BROWSERS-IN-QUERY-frame-2 ~
    ~{&OPEN-QUERY-br-comis-deb-cred}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br-comis-deb-cred BT-OK bt-cancela RECT-33 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "Cancela" 
     SIZE 14 BY 1.13
     BGCOLOR 8 .

DEFINE BUTTON BT-OK AUTO-GO 
     LABEL "Confirma" 
     SIZE 13 BY 1.13
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-33
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 105 BY 9.75.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-comis-deb-cred FOR 
      tt-comis-deb-cred SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-comis-deb-cred
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-comis-deb-cred frame-2 _FREEFORM
  QUERY br-comis-deb-cred NO-LOCK DISPLAY
      tt-comis-deb-cred.selecao 
      tt-comis-deb-cred.base-final FORMAT "Base/Final":U
      tt-comis-deb-cred.deb-cred   FORMAT "Deb/Cre":U
      tt-comis-deb-cred.descricao
      tt-comis-deb-cred.ct-codigo FORMAT "99999999":U
      tt-comis-deb-cred.unid-neg  FORMAT "x(03)"
      tt-comis-deb-cred.sc-codigo FORMAT "99999":U WIDTH 10
      tt-comis-deb-cred.valor     FORMAT ">>>>,>>9.99":U WIDTH 10.29
      tt-comis-deb-cred.historico FORMAT "x(70)":U WIDTH 34.72
  ENABLE
      tt-comis-deb-cred.ct-codigo
      tt-comis-deb-cred.unid-neg
      tt-comis-deb-cred.sc-codigo
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS NO-COLUMN-SCROLLING SEPARATORS SIZE 103 BY 7.75
         FONT 1 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frame-2
     br-comis-deb-cred AT ROW 1.75 COL 3
     BT-OK AT ROW 9.75 COL 78.14
     bt-cancela AT ROW 9.75 COL 91.72
     RECT-33 AT ROW 1.5 COL 2
     SPACE(0.56) SKIP(0.16)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 1
         TITLE "Detalhes Outros"
         DEFAULT-BUTTON BT-OK CANCEL-BUTTON bt-cancela.


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
/* SETTINGS FOR DIALOG-BOX frame-2
                                                                        */
/* BROWSE-TAB br-comis-deb-cred 1 frame-2 */
ASSIGN 
       FRAME frame-2:SCROLLABLE       = FALSE
       FRAME frame-2:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-comis-deb-cred
&ANALYZE-RESUME

/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME frame-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL frame-2 frame-2
ON WINDOW-CLOSE OF FRAME frame-2 /* Detalhes Outros */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-comis-deb-cred
&Scoped-define SELF-NAME br-comis-deb-cred
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-comis-deb-cred frame-2
ON MOUSE-MOVE-DBLCLICK OF br-comis-deb-cred IN FRAME frame-2
DO:
   APPLY "return" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-comis-deb-cred frame-2
ON RETURN OF br-comis-deb-cred IN FRAME frame-2
DO:

  IF AVAIL tt-comis-deb-cred 
  THEN DO:
       if tt-comis-deb-cred.selecao = "*" then
          assign tt-comis-deb-cred.selecao = "" .
       else
          assign tt-comis-deb-cred.selecao = "*".
    
       self:refresh().   
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-comis-deb-cred frame-2
ON ROW-ENTRY OF br-comis-deb-cred IN FRAME frame-2
DO:
     ASSIGN ct_codigo_aux = INPUT BROWSE br-comis-deb-cred tt-comis-deb-cred.ct-codigo
            sc_codigo_aux = INPUT BROWSE br-comis-deb-cred tt-comis-deb-cred.sc-codigo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-comis-deb-cred frame-2
ON ROW-LEAVE OF br-comis-deb-cred IN FRAME frame-2
DO:

  IF CAN-FIND(FIRST tt-comis-deb-cred) 
  THEN DO:

    /* valida conta cont bil e centro de custo */
    IF INPUT BROWSE br-comis-deb-cred tt-comis-deb-cred.ct-codigo <> tt-comis-deb-cred.ct-codigo  THEN DO:
        FIND FIRST cta_ctbl NO-LOCK
            WHERE cta_ctbl.cod_cta_ctbl = INPUT BROWSE br-comis-deb-cred tt-comis-deb-cred.ct-codigo NO-ERROR.
        IF NOT AVAIL cta_ctbl THEN DO:
            MESSAGE 'Conta Cont bil ' INPUT BROWSE br-comis-deb-cred tt-comis-deb-cred.ct-codigo + ' inv lida!' 
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            ASSIGN tt-comis-deb-cred.ct-codigo:SCREEN-VALUE IN BROWSE br-comis-deb-cred = string(ct_codigo_aux).
        END.
        ASSIGN tt-comis-deb-cred.ct-codigo = int(tt-comis-deb-cred.ct-codigo:SCREEN-VALUE IN BROWSE br-comis-deb-cred).

    END.

    /* moser habilitado conforme o claudiney */

    FIND FIRST criter_distrib_cta_ctbl 
         WHERE criter_distrib_cta_ctbl.cod_cta_ctbl       = tt-comis-deb-cred.ct-codigo:SCREEN-VALUE IN BROWSE br-comis-deb-cred
         AND   criter_distrib_cta_ctbl.cod_estab          = v_cod_estab_usuar
         AND   criter_distrib_cta_ctbl.cod_plano_cta_ctbl = "padrao" 
         AND   criter_distrib_cta_ctbl.dat_inic_valid     <= TODAY
         AND   criter_distrib_cta_ctbl.dat_fim_valid      >= TODAY NO-ERROR.
    IF AVAIL criter_distrib_cta_ctbl THEN DO:
        IF criter_distrib_cta_ctbl.ind_criter_distrib_ccusto = "definidos" THEN DO:
           FIND FIRST ITEM_lista_ccusto NO-LOCK
               WHERE ITEM_lista_ccusto.cod_estab               = criter_distrib_cta_ctbl.cod_estab
               AND   ITEM_lista_ccusto.cod_mapa_distrib_ccusto = criter_distrib_cta_ctbl.cod_mapa_distrib_ccusto
               AND   ITEM_lista_ccusto.cod_empresa             = v_cod_empres_usuar
               AND   ITEM_lista_ccusto.cod_plano_ccusto        = criter_distrib_cta_ctbl.cod_plano_cta_ctbl
               AND   ITEM_lista_ccusto.cod_ccusto              = tt-comis-deb-cred.sc-codigo:SCREEN-VALUE IN BROWSE br-comis-deb-cred NO-ERROR.
           IF NOT AVAIL ITEM_lista_ccusto THEN
               MESSAGE 'Centro de Custo' INPUT BROWSE br-comis-deb-cred tt-comis-deb-cred.sc-codigo + ' inv lido para o crit‚rio de distribui‡Æo!' 
                   VIEW-AS ALERT-BOX INFO BUTTONS OK.
           ELSE DO:
               FIND FIRST emscad.ccusto no-lock
                   WHERE emscad.ccusto.cod_ccusto = INPUT BROWSE br-comis-deb-cred tt-comis-deb-cred.sc-codigo NO-ERROR.
               IF NOT AVAIL emscad.ccusto THEN DO:
                   MESSAGE 'Centro de Custo ' INPUT BROWSE br-comis-deb-cred tt-comis-deb-cred.sc-codigo + ' inv lido!'
                       VIEW-AS ALERT-BOX INFO BUTTONS OK.
                   ASSIGN tt-comis-deb-cred.sc-codigo:SCREEN-VALUE IN BROWSE br-comis-deb-cred = STRING(sc_codigo_aux).
               END.
               ASSIGN tt-comis-deb-cred.sc-codigo = int(tt-comis-deb-cred.sc-codigo:SCREEN-VALUE IN BROWSE br-comis-deb-cred).
           END.
        END.


        IF criter_distrib_cta_ctbl.ind_criter_distrib_ccusto = "utiliza todos" THEN DO:
            FIND FIRST emscad.ccusto no-lock
                WHERE emscad.ccusto.cod_ccusto = INPUT BROWSE br-comis-deb-cred tt-comis-deb-cred.sc-codigo NO-ERROR.
            IF NOT AVAIL emscad.ccusto THEN DO:
                MESSAGE 'Centro de Custo ' INPUT BROWSE br-comis-deb-cred tt-comis-deb-cred.sc-codigo + ' inv lido!'
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                ASSIGN tt-comis-deb-cred.sc-codigo:SCREEN-VALUE IN BROWSE br-comis-deb-cred = STRING(sc_codigo_aux).
            END.
            ASSIGN tt-comis-deb-cred.sc-codigo = int(tt-comis-deb-cred.sc-codigo:SCREEN-VALUE IN BROWSE br-comis-deb-cred).
        END.
        
        IF criter_distrib_cta_ctbl.ind_criter_distrib_ccusto = "nao utiliza" THEN DO:
           ASSIGN tt-comis-deb-cred.sc-codigo:SCREEN-VALUE IN BROWSE br-comis-deb-cred = '00000'
                  tt-comis-deb-cred.sc-codigo = int(tt-comis-deb-cred.sc-codigo:SCREEN-VALUE IN BROWSE br-comis-deb-cred).
        END.
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BT-OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BT-OK frame-2
ON CHOOSE OF BT-OK IN FRAME frame-2 /* Confirma */
DO:

    FOR EACH tt-comis-deb-cred NO-LOCK:
        FIND FIRST comis-deb-cred EXCLUSIVE-LOCK 
             WHERE comis-deb-cred.cod-estabel = tt-comis-deb-cred.cod-estabel
               AND comis-deb-cred.unid-neg    = tt-comis-deb-cred.unid-neg
               AND comis-deb-cred.cod-rep     = tt-comis-deb-cred.cod-rep
               AND comis-deb-cred.dt-movto    = tt-comis-deb-cred.dt-movto NO-ERROR.
        IF AVAIL comis-deb-cred THEN
           ASSIGN comis-deb-cred.ct-codigo = tt-comis-deb-cred.ct-codigo
                  comis-deb-cred.sc-codigo = tt-comis-deb-cred.sc-codigo
                  comis-deb-cred.unid-neg  = tt-comis-deb-cred.unid-neg.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK frame-2 


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
  RUN pi-atualiza-browse.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI frame-2  _DEFAULT-DISABLE
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
  HIDE FRAME frame-2.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI frame-2  _DEFAULT-ENABLE
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
  ENABLE br-comis-deb-cred BT-OK bt-cancela RECT-33 
      WITH FRAME frame-2.
  VIEW FRAME frame-2.
  {&OPEN-BROWSERS-IN-QUERY-frame-2}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-browse frame-2 
PROCEDURE pi-atualiza-browse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF p_abre_query = YES 
    THEN DO:

         FOR EACH tt_repres:
             DELETE tt_repres.
         END.
         FIND FIRST fornecedor NO-LOCK
             WHERE fornecedor.cod_empresa = v_cod_empres_usuar
             AND   fornecedor.cdn_fornec  = p_cdn_fornec NO-ERROR.
         IF AVAIL fornecedor THEN DO:
            FOR EACH representante NO-LOCK
                WHERE representante.cod_empresa = fornecedor.cod_empresa
                  AND representante.num_pessoa  = fornecedor.num_pessoa:
                CREATE tt_repres.
                ASSIGN tt_repres.cdn_repres = representante.cdn_repres.
            END.
         END.

         FOR EACH tt_repres:
             
             FOR EACH comis-deb-cred
                 WHERE comis-deb-cred.cod-rep     = tt_repres.cdn_repres
                   AND comis-deb-cred.dt-movto   >= p_data_ini
                   AND comis-deb-cred.dt-movto   <= p_data_fim
                   AND comis-deb-cred.base-final  = NO,
                 FIRST mov-comis NO-LOCK 
                 WHERE mov-comis.cod-mov = comis-deb-cred.cod-mov
                    BY comis-deb-cred.base-final DESCENDING 
                    BY comis-deb-cred.deb-cred.
                  
                  IF mov-comis.cod-mov = 4  /* EMPRESTIMO */
                  OR mov-comis.cod-mov = 10  /*ADIANTAMENTO*/ 
                     THEN NEXT.                    
                  
                  CREATE tt-comis-deb-cred.
                  BUFFER-COPY comis-deb-cred TO tt-comis-deb-cred.
                  ASSIGN tt-comis-deb-cred.descricao = mov-comis.descricao
                         tt-comis-deb-cred.selecao   = "*".
                  IF tt-comis-deb-cred.sc-codigo <> 0 THEN
                     ASSIGN tt-comis-deb-cred.sc-codigo = INT(SUBSTRING(STRING(tt-comis-deb-cred.sc-codigo),2,5)).

             END.
         END.
    END.
    {&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

