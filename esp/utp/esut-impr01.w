&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/



/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
DEF TEMP-TABLE ttimprsor_usuar NO-UNDO LIKE imprsor_usuar. 
DEF TEMP-TABLE ttimpressora NO-UNDO LIKE impressora. 
DEF TEMP-TABLE ttlayout_impres NO-UNDO LIKE layout_impres. 

/* Parameters Definitions ---                                           */

def input-output param c-impres as char no-undo.
def input-output param c-lay as char no-undo.
def input-output param c-arq-impres as char no-undo.
def INPUT        param p-proc as HANDLE no-undo.

/* Local Variable Definitions ---                                       */

def new global shared var v_cod_usuar_corren as char no-undo.
DEF NEW GLOBAL SHARED VAR v_nom_disposit_so AS CHAR NO-UNDO.
def var c-lista as char no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME br-impres

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttimprsor_usuar ttimpressora

/* Definitions for BROWSE br-impres                                     */
&Scoped-define FIELDS-IN-QUERY-br-impres ttimprsor_usuar.nom_impressora ttimpressora.des_impressora   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-impres   
&Scoped-define SELF-NAME br-impres
&Scoped-define QUERY-STRING-br-impres FOR EACH ttimprsor_usuar NO-LOCK, ~
           FIRST ttimpressora OF ttimprsor_usuar NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-impres OPEN QUERY {&SELF-NAME} FOR EACH ttimprsor_usuar NO-LOCK, ~
           FIRST ttimpressora OF ttimprsor_usuar NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-impres ttimprsor_usuar ttimpressora
&Scoped-define FIRST-TABLE-IN-QUERY-br-impres ttimprsor_usuar
&Scoped-define SECOND-TABLE-IN-QUERY-br-impres ttimpressora


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-br-impres}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-16 rt-buttom br-impres sl-layout l-arq ~
bt-ok bt-cancela bt-windows bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS sl-layout l-arq c-arq c-label1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "&Ajuda" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-arquivo 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-windows 
     LABEL "&Windows" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE c-arq AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-label1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 15.43 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44.14 BY 1.96.

DEFINE RECTANGLE rt-buttom
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 44.14 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE sl-layout AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 43.86 BY 2.42 NO-UNDO.

DEFINE VARIABLE l-arq AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.43 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-impres FOR 
      ttimprsor_usuar, 
      ttimpressora SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-impres
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-impres D-Dialog _FREEFORM
  QUERY br-impres NO-LOCK DISPLAY
      ttimprsor_usuar.nom_impressora FORMAT "x(12)":U
      ttimpressora.des_impressora FORMAT "x(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SIZE 43.86 BY 4.42
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     br-impres AT ROW 1.13 COL 1.72
     sl-layout AT ROW 6.29 COL 1.72 NO-LABEL
     l-arq AT ROW 8.79 COL 3.14
     bt-arquivo AT ROW 9.67 COL 39.86 HELP
          "Escolha do nome do arquivo"
     c-arq AT ROW 9.75 COL 3 NO-LABEL
     bt-ok AT ROW 11.42 COL 2.43
     bt-cancela AT ROW 11.42 COL 13.14
     bt-windows AT ROW 11.42 COL 23.72
     bt-ajuda AT ROW 11.42 COL 34.43
     c-label1 AT ROW 5.58 COL 1.86 NO-LABEL
     RECT-16 AT ROW 9.13 COL 1.43
     rt-buttom AT ROW 11.17 COL 1.43
     SPACE(0.01) SKIP(0.00)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 1
         TITLE "Imprimir..".


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
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME                                                           */
/* BROWSE-TAB br-impres rt-buttom D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON bt-arquivo IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-arq IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-label1 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-impres
/* Query rebuild information for BROWSE br-impres
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttimprsor_usuar NO-LOCK,
    FIRST ttimpressora OF ttimprsor_usuar NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST"
     _Query            is OPENED
*/  /* BROWSE br-impres */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Imprimir.. */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-impres
&Scoped-define SELF-NAME br-impres
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-impres D-Dialog
ON VALUE-CHANGED OF br-impres IN FRAME D-Dialog
DO:
  assign c-lista = "".
  for each ttlayout_impres no-lock where ttlayout_impres.nom_impressora = ttimprsor_usuar.nom_impressora:
    assign c-lista = c-lista + ttlayout_impres.cod_layout_impres + ",".
  end.
    
    if avail ttimprsor_usuar then do:
      reposition {&browse-name} to rowid rowid(ttimprsor_usuar).
      if ttimprsor_usuar.nom_disposit_so = "printer" then 
         enable bt-windows with frame {&frame-name}.
      else
         disable bt-windows with frame {&frame-name}.
    end.
  assign c-lista = substring(c-lista,1,length(c-lista) - 1)
         sl-layout:list-items = c-lista
         sl-layout:screen-value in frame {&frame-name} = entry(1,c-lista).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda D-Dialog
ON CHOOSE OF bt-ajuda IN FRAME D-Dialog /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-arquivo D-Dialog
ON CHOOSE OF bt-arquivo IN FRAME D-Dialog
DO:
    def var c-arq-conv  as char no-undo.
    def var l-ok as logical no-undo.

    assign c-arq-conv = replace(input frame {&frame-name} c-arq, "/", "\").
    SYSTEM-DIALOG GET-FILE c-arq-conv
       FILTERS "*.lst" "*.lst",
               "*.*" "*.*"
       ASK-OVERWRITE 
       DEFAULT-EXTENSION "lst"
       INITIAL-DIR "spool" 
       SAVE-AS
       USE-FILENAME
       UPDATE l-ok.
    if  l-ok = yes then
        assign c-arq:screen-value in frame {&frame-name}  = replace(c-arq-conv, "\", "/"). 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok D-Dialog
ON CHOOSE OF bt-ok IN FRAME D-Dialog /* OK */
DO:
    
    def var c-arq-aux as char no-undo.

/*     Retirado por Nakamura, Nao deve ser validado, devido a execuá∆o Batch
 *     if l-arq:screen-value in frame {&frame-name} = "yes" then do:
 *       assign c-arq-aux = c-arq:screen-value in frame {&frame-name}
 *              c-arq-aux = replace(c-arq-aux, "/", "\").
 *       if r-index(c-arq-aux, "\") > 0 then do:       
 *           assign file-info:file-name = substring(c-arq-aux,1,r-index(c-arq-aux, "\")).
 *           if file-info:full-pathname = ?  then do:
 *               run utp/ut-msgs.p (input "show", 
 *                                  input 5749, 
 *                                  input "").
 *               apply 'entry' to c-arq in frame {&frame-name}.                   
 *               return no-apply.
 *           end.
 *       end.
 * 
 *       run utp/ut-vlarq.p (input c-arq:screen-value in frame {&frame-name}).
 *         if  return-value = "nok" then do:
 *             run utp/ut-msgs.p (input "show",
 *                                input 73,
 *                                input "").
 *             apply 'entry' to c-arq in frame {&frame-name}.                   
 *             return no-apply.
 *         end.
 *     end.     */
    
    if available ttimprsor_usuar then do:
        assign c-impres          = ttimprsor_usuar.nom_impressora
               c-lay             = sl-layout:screen-value in frame {&frame-name}
               v_nom_disposit_so = ttimprsor_usuar.nom_disposit_so.


        IF c-lay = ? THEN
            ASSIGN c-lay = "".
    end.
    if l-arq:screen-value in frame {&frame-name} = "yes" then           
      assign c-arq-impres = replace(c-arq:screen-value in frame {&frame-name},"\","/").
    else
      assign c-arq-impres = "".  

  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-windows
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-windows D-Dialog
ON CHOOSE OF bt-windows IN FRAME D-Dialog /* Windows */
DO:
   SYSTEM-DIALOG PRINTER-SETUP.       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-arq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-arq D-Dialog
ON VALUE-CHANGED OF l-arq IN FRAME D-Dialog
DO:
  if l-arq:screen-value in frame {&frame-name} = "yes" then
    enable c-arq bt-arquivo with frame {&frame-name}.
  else 
    disable c-arq bt-arquivo with frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


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
  RUN local-initialize.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY sl-layout l-arq c-arq c-label1 
      WITH FRAME D-Dialog.
  ENABLE RECT-16 rt-buttom br-impres sl-layout l-arq bt-ok bt-cancela 
         bt-windows bt-ajuda 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */
  RUN pi-carrega-tt.
  {&OPEN-QUERY-br-impres}
  assign c-label1 = "Layouts de impress∆o":R + ":".
  
  assign l-arq:label in frame {&frame-name} = "Imprimir em arquivo":R.

  /* Code placed here will execute AFTER standard behavior.    */
  
  if c-impres = "" then do:
    apply "value-changed" to {&browse-name} in frame {&frame-name}.
  end.  
  else do:
    find first ttimprsor_usuar where ttimprsor_usuar.log_imprsor_princ and 
         ttimprsor_usuar.cod_usuario = v_cod_usuar_corren no-lock no-error.
    if avail ttimprsor_usuar then do:
      reposition {&browse-name} to rowid rowid(ttimprsor_usuar).
      if ttimprsor_usuar.nom_disposit_so = "printer" then 
         enable bt-windows with frame {&frame-name}.
      else
         disable bt-windows with frame {&frame-name}.
    end.
    else apply "value-changed" to {&browse-name} in frame {&frame-name}.
    assign c-lista = "".
    for each ttlayout_impres no-lock where ttlayout_impres.nom_impressora = ttimprsor_usuar.nom_impressora
      AND ttlayout_impres.log_layout_impres_princ:
      assign c-lista = c-lista + ttlayout_impres.cod_layout_impres + ",".
    end.
    assign c-lista = substring(c-lista,1,length(c-lista) - 1)
           sl-layout:list-items = c-lista.
    find first ttlayout_impres where ttlayout_impres.cod_layout_impres = c-lay and
         ttlayout_impres.nom_impressora = ttimprsor_usuar.nom_impressora no-lock no-error.
    if avail ttlayout_impres then do:
      assign sl-layout:screen-value in frame {&frame-name} = c-lay.
    end.  
    else assign sl-layout:screen-value in frame {&frame-name} = entry(1,c-lista).
    if c-arq-impres <> "" then do:
      enable c-arq bt-arquivo with frame {&frame-name}.
      assign l-arq:screen-value in frame {&frame-name} = "yes"
             c-arq:screen-value in frame {&frame-name} = c-arq-impres.
    end.
  end.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-tt D-Dialog 
PROCEDURE pi-carrega-tt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH imprsor_usuar NO-LOCK
        WHERE imprsor_usuar.cod_usuario = v_cod_usuar_corren:
        CREATE ttimprsor_usuar.
        BUFFER-COPY imprsor_usuar TO ttimprsor_usuar.
        IF NOT CAN-FIND(FIRST ttimpressora OF ttimprsor_usuar) THEN DO:
            FOR FIRST impressora OF ttimprsor_usuar NO-LOCK:
                CREATE ttimpressora.
                BUFFER-COPY impressora TO ttimpressora.
                FOR EACH layout_impres OF ttimpressora NO-LOCK:
                    CREATE ttlayout_impres.
                    BUFFER-COPY layout_impres TO ttlayout_impres.
                END.
            END.
        END.
    END.
    
    FOR EACH ttimprsor_usuar:
        FIND FIRST ttimpressora 
            WHERE ttimpressora.nom_impressora = ttimprsor_usuar.nom_impressora NO-LOCK NO-ERROR.
        IF NOT ttimpressora.des_impressora MATCHES "*barra*"
        AND NOT ttimpressora.des_impressora MATCHES "*zebra*" THEN
        DELETE ttimprsor_usuar.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

