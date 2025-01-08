&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          emscad             PROGRESS
          emsmov             PROGRESS
*/
&Scoped-define WINDOW-NAME w-cadsim


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt_cta_corren_cta_ctbl NO-UNDO LIKE cta_corren_cta_ctbl
       field de_saldo_cta_corren  as dec
       field de_saldo_cta_ctbl    as dec
       field de_saldo_moeda_orig  as dec
       field cod_finalid_econ     as char
       field nom_abrev_cta_corren as char
       field val_cotac_indic_econ as dec decimals 10.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadsim 
{include/i-prgvrs.i esacr003g 2.00.00.000}

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

def temp-table tt-matriz no-undo
    field cod-emitente LIKE emitente.cod-emitente.

DEF TEMP-TABLE tt_histor_clien LIKE histor_clien.

/* Parameters Definitions ---                                           */
DEF INPUT PARAM p_cod_empresa LIKE emscad.cliente.cod_empresa NO-UNDO.
DEF INPUT PARAM TABLE FOR tt-matriz.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-api AS HANDLE NO-UNDO.
define variable wh-imprime as handle no-undo.
DEFINE VARIABLE cTransacao AS CHARACTER FORMAT "X(15)"  NO-UNDO.
DEFINE VARIABLE hprogramzoom AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE l-implanta        AS LOGICAL.
def new global shared var h-facelift as handle no-undo.

IF NOT VALID-HANDLE(h-facelift) THEN
    RUN btb/btb901zo.p PERSISTENT SET h-facelift.

{utp/ut-glob.i}
{esp/es0018.i}


DEFINE VARIABLE v_win_original_width  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_win_original_height AS DECIMAL     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME br-hist

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt_histor_clien

/* Definitions for BROWSE br-hist                                       */
&Scoped-define FIELDS-IN-QUERY-br-hist tt_histor_clien.cdn_clien tt_histor_clien.dat_gerac_histor tt_histor_clien.hra_gerac_histor tt_histor_clien.cod_usuario tt_histor_clien.des_abrev_histor_clien   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-hist   
&Scoped-define SELF-NAME br-hist
&Scoped-define QUERY-STRING-br-hist FOR EACH tt_histor_clien     BY tt_histor_clien.cod_empresa      BY tt_histor_clien.cdn_cliente       BY tt_histor_clien.num_seq_histor_clien DESCENDING
&Scoped-define OPEN-QUERY-br-hist OPEN QUERY {&SELF-NAME} FOR EACH tt_histor_clien     BY tt_histor_clien.cod_empresa      BY tt_histor_clien.cdn_cliente       BY tt_histor_clien.num_seq_histor_clien DESCENDING.
&Scoped-define TABLES-IN-QUERY-br-hist tt_histor_clien
&Scoped-define FIRST-TABLE-IN-QUERY-br-hist tt_histor_clien


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-br-hist}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br-hist ed-det-hist RECT-157 RECT-158 
&Scoped-Define DISPLAYED-OBJECTS ed-det-hist 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-cadsim AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ok AUTO-GO 
     IMAGE-UP FILE "image/im-exi.bmp":U
     LABEL "&Fechar" 
     SIZE 4 BY 1.13 TOOLTIP "Sair do programa"
     BGCOLOR 8 .

DEFINE VARIABLE ed-det-hist AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 82 BY 4.5 NO-UNDO.

DEFINE RECTANGLE RECT-157
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 11.25.

DEFINE RECTANGLE RECT-158
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 5.25.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-hist FOR 
      tt_histor_clien SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-hist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-hist w-cadsim _FREEFORM
  QUERY br-hist NO-LOCK DISPLAY
      tt_histor_clien.cdn_clien
      tt_histor_clien.dat_gerac_histor COLUMN-LABEL "Data" FORMAT "99/99/9999":U WIDTH 10.43
      tt_histor_clien.hra_gerac_histor COLUMN-LABEL "Hora" FORMAT "x(08)":U WIDTH 9.43
      tt_histor_clien.cod_usuario FORMAT "x(12)":U WIDTH 10.43
      tt_histor_clien.des_abrev_histor_clien COLUMN-LABEL "Hist¢rico" FORMAT "x(40)":U WIDTH 46.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.75
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     br-hist AT ROW 1.5 COL 2 WIDGET-ID 100
     ed-det-hist AT ROW 13.5 COL 2 NO-LABEL WIDGET-ID 272
     bt-ok AT ROW 12.5 COL 81 WIDGET-ID 242
     "  DETALHE HIST‡RICO" VIEW-AS TEXT
          SIZE 17 BY .54 AT ROW 12.75 COL 35 WIDGET-ID 276
     RECT-157 AT ROW 1.25 COL 1 WIDGET-ID 270
     RECT-158 AT ROW 13 COL 1 WIDGET-ID 274
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 134 BY 24.5
         BGCOLOR 15 FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt_cta_corren_cta_ctbl T "?" NO-UNDO ems5 cta_corren_cta_ctbl
      ADDITIONAL-FIELDS:
          field de_saldo_cta_corren  as dec
          field de_saldo_cta_ctbl    as dec
          field de_saldo_moeda_orig  as dec
          field cod_finalid_econ     as char
          field nom_abrev_cta_corren as char
          field val_cotac_indic_econ as dec decimals 10
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-cadsim ASSIGN
         HIDDEN             = YES
         TITLE              = "Variaá∆o Cambial Conta Corrente"
         HEIGHT             = 17.33
         WIDTH              = 84.43
         MAX-HEIGHT         = 28.67
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 28.67
         VIRTUAL-WIDTH      = 195.14
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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB br-hist 1 f-cad */
/* SETTINGS FOR BUTTON bt-ok IN FRAME f-cad
   NO-ENABLE                                                            */
ASSIGN 
       bt-ok:HIDDEN IN FRAME f-cad           = TRUE.

ASSIGN 
       ed-det-hist:READ-ONLY IN FRAME f-cad        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-hist
/* Query rebuild information for BROWSE br-hist
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt_histor_clien
    BY tt_histor_clien.cod_empresa
     BY tt_histor_clien.cdn_cliente
      BY tt_histor_clien.num_seq_histor_clien DESCENDING.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _OrdList          = "histor_clien.cod_empresa|yes,histor_clien.cdn_cliente|yes,histor_clien.num_seq_histor_clien|no"
     _Where[1]         = "histor_clien.cod_empresa = p_cod_empresa
 AND histor_clien.cdn_cliente = p_cdn_cliente"
     _Query            is OPENED
*/  /* BROWSE br-hist */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON END-ERROR OF w-cadsim /* Variaá∆o Cambial Conta Corrente */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON WINDOW-CLOSE OF w-cadsim /* Variaá∆o Cambial Conta Corrente */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-hist
&Scoped-define SELF-NAME br-hist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-hist w-cadsim
ON VALUE-CHANGED OF br-hist IN FRAME f-cad
DO:
    ASSIGN ed-det-hist:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

    IF  AVAIL tt_histor_clien
    THEN
        ASSIGN ed-det-hist:SCREEN-VALUE IN FRAME {&FRAME-NAME} = tt_histor_clien.des_histor_clien.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-cadsim
ON CHOOSE OF bt-ok IN FRAME f-cad /* Fechar */
DO:
     apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  DISPLAY ed-det-hist 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  ENABLE br-hist ed-det-hist RECT-157 RECT-158 
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

  IF  VALID-HANDLE(h-api) THEN
      RUN pi-destroy IN h-api.


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

  {utp/ut9000.i "esacr003g" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch  IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  RUN dispatch  IN this-procedure ('enable-fields':U).

  {include/i-inifld.i}

      RUN pi-query.

  APPLY "value-changed" TO br-hist IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-query w-cadsim 
PROCEDURE pi-query :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
EMPTY TEMP-TABLE tt_histor_clien.

FOR EACH tt-matriz,
    EACH histor_clien
   WHERE histor_clien.cod_empresa = p_cod_empresa
     AND histor_clien.cdn_cliente = tt-matriz.cod-emitente NO-LOCK
      BY histor_clien.cod_empresa
      BY histor_clien.cdn_cliente
      BY histor_clien.num_seq_histor_clien DESCENDING.

    CREATE tt_histor_clien.
    BUFFER-COPY histor_clien TO tt_histor_clien.
END.
{&OPEN-query-br-hist}

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
  {src/adm/template/snd-list.i "tt_histor_clien"}

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

