&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadsim 
/*:T *******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESPDP068 2.00.00.000}

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define variable wh-imprime as handle no-undo.

DEF BUFFER b-parcela-st FOR parcela-st.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES parcela-st

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 parcela-st.cod-emitente ~
parcela-st.prazo-st 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 parcela-st.prazo-st 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-2 parcela-st
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-2 parcela-st
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH parcela-st NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH parcela-st NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 parcela-st
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 parcela-st


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button c-cod-cliente i-prazo-st ~
bt-incluir bt-localizar bt-excluir bt-exporta Bt-importa BROWSE-2 bt-ok ~
bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS c-cod-cliente c-desc-cliente i-prazo-st 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-cadsim AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-bt-ajuda 
       MENU-ITEM mi-sobre       LABEL "Sobre..."      .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "&Ajuda" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-excluir 
     IMAGE-UP FILE "adeicon/del-ad.bmp":U
     LABEL "Button 1" 
     SIZE 7 BY 1.5.

DEFINE BUTTON bt-exporta 
     IMAGE-UP FILE "adeicon/export-d.bmp":U
     LABEL "Button 2" 
     SIZE 7 BY 1.5.

DEFINE BUTTON Bt-importa 
     IMAGE-UP FILE "adeicon/import-u.bmp":U
     LABEL "" 
     SIZE 7 BY 1.5.

DEFINE BUTTON bt-incluir 
     IMAGE-UP FILE "adeicon/editor.ico":U
     LABEL "Incluir" 
     SIZE 6 BY 1.5 TOOLTIP "Incluir novo Registro".

DEFINE BUTTON bt-localizar 
     IMAGE-UP FILE "adeicon/asproc-u.bmp":U
     IMAGE-DOWN FILE "adeicon/asproc-d.bmp":U
     LABEL "Localizar" 
     SIZE 6 BY 1.5 TOOLTIP "Incluir novo Registro".

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&Sair" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE c-cod-cliente AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Cod.Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-cliente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY 1 NO-UNDO.

DEFINE VARIABLE i-prazo-st AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Prazo ST" 
     VIEW-AS FILL-IN 
     SIZE 11 BY 1 NO-UNDO.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 78 BY 1.38
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      parcela-st SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 w-cadsim _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      parcela-st.cod-emitente FORMAT ">>>>>>9":U WIDTH 9.43
      parcela-st.prazo-st FORMAT ">>>>9":U WIDTH 19.72
  ENABLE
      parcela-st.prazo-st
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 33 BY 9 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     c-cod-cliente AT ROW 1.25 COL 20 COLON-ALIGNED WIDGET-ID 2
     c-desc-cliente AT ROW 1.25 COL 35 NO-LABEL WIDGET-ID 10
     i-prazo-st AT ROW 2.5 COL 13.14 WIDGET-ID 8
     bt-incluir AT ROW 3.75 COL 22 HELP
          "Incluir Novo Registro" WIDGET-ID 12
     bt-localizar AT ROW 3.75 COL 29 HELP
          "Localizar Registro" WIDGET-ID 14
     bt-excluir AT ROW 3.75 COL 36 HELP
          "Excluir Registro Corrente" WIDGET-ID 16
     bt-exporta AT ROW 3.75 COL 44 HELP
          "Exporta para Planilha .csv" WIDGET-ID 18
     Bt-importa AT ROW 3.75 COL 52 HELP
          "Importa‡Æo de  Planilha .csv" WIDGET-ID 20
     BROWSE-2 AT ROW 6 COL 22 WIDGET-ID 200
     bt-ok AT ROW 15.71 COL 3
     bt-ajuda AT ROW 15.71 COL 69
     rt-button AT ROW 15.5 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 16.38 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-cadsim ASSIGN
         HIDDEN             = YES
         TITLE              = "ESPDP068 - Clientes com Parcela Separada ST"
         HEIGHT             = 16.38
         WIDTH              = 79.43
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 114.29
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-cadsim 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-incsim.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-cadsim
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME L-To-R                                                    */
/* BROWSE-TAB BROWSE-2 Bt-importa f-cad */
ASSIGN 
       bt-ajuda:POPUP-MENU IN FRAME f-cad       = MENU POPUP-MENU-bt-ajuda:HANDLE.

/* SETTINGS FOR FILL-IN c-desc-cliente IN FRAME f-cad
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN i-prazo-st IN FRAME f-cad
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "mgesp.parcela-st"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > mgesp.parcela-st.cod-emitente
"parcela-st.cod-emitente" ? ? "integer" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > mgesp.parcela-st.prazo-st
"parcela-st.prazo-st" ? ? "integer" ? ? ? ? ? ? yes ? no no "19.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON END-ERROR OF w-cadsim /* ESPDP068 - Clientes com Parcela Separada ST */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON WINDOW-CLOSE OF w-cadsim /* ESPDP068 - Clientes com Parcela Separada ST */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-cadsim
ON CHOOSE OF bt-ajuda IN FRAME f-cad /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-excluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-excluir w-cadsim
ON CHOOSE OF bt-excluir IN FRAME f-cad /* Button 1 */
DO:
  MESSAGE "Confirma Elimina‡Æo do Registro? "
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
                         TITLE "" UPDATE l-resposta AS LOGICAL.
  IF l-resposta = YES THEN do:
      FIND b-parcela-st
          WHERE ROWID(b-parcela-st) = ROWID(parcela-st)
          EXCLUSIVE-LOCK NO-ERROR.
      IF AVAIL b-parcela-st THEN DO:
          DELETE parcela-st.
          MESSAGE "Registro Eliminado"
              VIEW-AS ALERT-BOX INFO BUTTONS OK.
              {&OPEN-BROWSERS-IN-QUERY-f-cad}
              VIEW w-cadsim.

      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-exporta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-exporta w-cadsim
ON CHOOSE OF bt-exporta IN FRAME f-cad /* Button 2 */
DO:
   OUTPUT TO c:\temp\espdp068.csv.
   FOR EACH parcela-st NO-LOCK:
       PUT parcela-st.cod-emitente   ";"
           parcela-st.prazo-st SKIP.
   END.
   OUTPUT CLOSE.
   MESSAGE "Arquivo Exportado para : c:\temp\espdp068.csv" 
       VIEW-AS ALERT-BOX INFO BUTTONS OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Bt-importa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Bt-importa w-cadsim
ON CHOOSE OF Bt-importa IN FRAME f-cad
DO:
  RUN esp/pdp/espdp068a.w.
 {&OPEN-BROWSERS-IN-QUERY-f-cad}
      VIEW w-cadsim.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-incluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-incluir w-cadsim
ON CHOOSE OF bt-incluir IN FRAME f-cad /* Incluir */
DO:
  FIND EMITENTE
      WHERE emitente.cod-emitente = int(c-cod-cliente:SCREEN-VALUE )
      NO-LOCK NO-ERROR.
  IF NOT AVAIL emitente THEN DO:
     RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Cliente":U).
     ASSIGN c-cod-cliente:SCREEN-VALUE = "0".
     RETURN NO-APPLY.
  END.
  ELSE DO:
      FIND parcela-st
           WHERE parcela-st.cod-emitente = int(c-cod-cliente:SCREEN-VALUE )
           NO-LOCK NO-ERROR.
      IF NOT AVAIL parcela-st THEN DO:
          CREATE parcela-st.
          ASSIGN parcela-st.cod-emitente = int(c-cod-cliente:SCREEN-VALUE )
                 parcela-st.prazo-st     = INT(i-prazo-st:SCREEN-VALUE).
          {&OPEN-BROWSERS-IN-QUERY-f-cad}
          VIEW w-cadsim.
      END.
      ELSE DO:
            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17006, 
                               INPUT "Registro ja cadastrado com este codigo ").

             RETURN NO-APPLY.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-localizar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-localizar w-cadsim
ON CHOOSE OF bt-localizar IN FRAME f-cad /* Localizar */
DO:
      FIND FIRST b-parcela-st
           WHERE b-parcela-st.cod-emitente = int(c-cod-cliente:SCREEN-VALUE )
           NO-LOCK NO-ERROR.
      IF NOT AVAIL b-parcela-st THEN DO:
        
            RUN utp/ut-msgs.p (INPUT "show":U, 
                               INPUT 17006, 
                               INPUT "Registro NÆo Cadastrado Com Este C¢digo " + c-cod-cliente:SCREEN-VALUE).

             RETURN NO-APPLY.

      END.
      ELSE DO:
          REPOSITION browse-2 TO ROWID(rowid(b-parcela-st)).
          
      END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-cadsim
ON CHOOSE OF bt-ok IN FRAME f-cad /* Sair */
DO:
  RUN notify ('update-record':U).
  if return-value <> "adm-error":U then
     apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-cliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cliente w-cadsim
ON LEAVE OF c-cod-cliente IN FRAME f-cad /* Cod.Cliente */
DO:
  FIND EMITENTE
      WHERE emitente.cod-emitente = int(c-cod-cliente:SCREEN-VALUE )
      NO-LOCK NO-ERROR.
  IF NOT AVAIL emitente THEN DO:
     RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "Cliente":U).
     ASSIGN c-cod-cliente:SCREEN-VALUE = "0".
     RETURN NO-APPLY.
  END.
  ELSE DO:
      ASSIGN c-desc-cliente:SCREEN-VALUE = emitente.nome-emit.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-cadsim
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-cadsim 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-cadsim  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-cadsim  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-cadsim  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
  THEN DELETE WIDGET w-cadsim.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-cadsim  _DEFAULT-ENABLE
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
  DISPLAY c-cod-cliente c-desc-cliente i-prazo-st 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  ENABLE rt-button c-cod-cliente i-prazo-st bt-incluir bt-localizar bt-excluir 
         bt-exporta Bt-importa BROWSE-2 bt-ok bt-ajuda 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW w-cadsim.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-cadsim 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-cadsim 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-cadsim 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}

  {utp/ut9000.i "ESPDP068" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  find first parcela-st no-lock no-error. 
  if not avail parcela-st
  then RUN notify IN THIS-PROCEDURE ('add-record':U).
  else RUN new-state ('update-begin':U).

  RUN dispatch  IN this-procedure ('enable-fields':U).

  {include/i-inifld.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-cadsim  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "parcela-st"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-cadsim 
PROCEDURE state-changed :
/*:T -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

