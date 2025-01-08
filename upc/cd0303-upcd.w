&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME cd0303-upcd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS cd0303-upcd 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i D99XX999 9.99.99.999}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */
/*                                                                                */
/* OBS: Para os smartobjects o parametro m¢dulo dever  ser MUT                    */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def output param p-cod-estab        as CHAR    no-undo.
def output param p-cod-natur-operac AS CHAR    no-undo.
def output param p-cod-ncm          as CHAR    no-undo.
def output param p-cod-item         as CHAR    no-undo.
def output param p-cdn-grp-emit     as INTEGER no-undo.  
def output param p-cdn-emitente     as INTEGER no-undo.  
def output param p-dat-valid-inic   as DATE    no-undo.
def output param p-idi-tip-docto    AS INTEGER no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME cd0303-upcd

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-buttom rs-tipo fi-cod-estab ~
fi-nat-operacao fi-ncm fi-cod-item fi-data fi-grupo-emit fi-cod-emitente ~
bt-ok 
&Scoped-Define DISPLAYED-OBJECTS rs-tipo fi-cod-estab fi-nat-operacao ~
fi-ncm fi-cod-item fi-data fi-grupo-emit fi-cod-emitente 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE fi-cod-emitente AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Emitente" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-estab AS CHARACTER FORMAT "X(5)":U INITIAL "*" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 5.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-item AS CHARACTER FORMAT "x(16)" INITIAL "*" 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-data AS DATE FORMAT "99/99/9999" 
     LABEL "Dt Ini Validade" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-grupo-emit AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Grupo Emit" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nat-operacao AS CHARACTER FORMAT "X(6)":U INITIAL "*" 
     LABEL "Nat Operacao" 
     VIEW-AS FILL-IN 
     SIZE 7.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ncm AS CHARACTER FORMAT "x(08)" INITIAL "*" 
     LABEL "Classificacao Fiscal" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .88 NO-UNDO.

DEFINE VARIABLE rs-tipo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Entrada", 1,
"Sa¡da", 2
     SIZE 24 BY 1 NO-UNDO.

DEFINE RECTANGLE rt-buttom
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 48 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME cd0303-upcd
     rs-tipo AT ROW 1.25 COL 13.43 NO-LABEL WIDGET-ID 62
     fi-cod-estab AT ROW 2.75 COL 20 COLON-ALIGNED WIDGET-ID 2
     fi-nat-operacao AT ROW 3.75 COL 20 COLON-ALIGNED WIDGET-ID 12
     fi-ncm AT ROW 4.75 COL 20 COLON-ALIGNED HELP
          "C¢digo Nomenclatura Comum do Mercosul" WIDGET-ID 20
     fi-cod-item AT ROW 5.75 COL 20 COLON-ALIGNED HELP
          "C¢digo Nomenclatura Comum do Mercosul" WIDGET-ID 30
     fi-data AT ROW 6.75 COL 20 COLON-ALIGNED HELP
          "C¢digo Nomenclatura Comum do Mercosul" WIDGET-ID 68
     fi-grupo-emit AT ROW 7.75 COL 20 COLON-ALIGNED HELP
          "C¢digo Nomenclatura Comum do Mercosul" WIDGET-ID 58
     fi-cod-emitente AT ROW 8.75 COL 20 COLON-ALIGNED HELP
          "C¢digo Nomenclatura Comum do Mercosul" WIDGET-ID 60
     bt-ok AT ROW 10.88 COL 3
     rt-buttom AT ROW 10.67 COL 1.43
     SPACE(0.28) SKIP(0.11)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Pesquisar"
         DEFAULT-BUTTON bt-ok WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB cd0303-upcd 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/d-dialog.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX cd0303-upcd
   NOT-VISIBLE FRAME-NAME L-To-R                                        */
ASSIGN 
       FRAME cd0303-upcd:SCROLLABLE       = FALSE
       FRAME cd0303-upcd:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX cd0303-upcd
/* Query rebuild information for DIALOG-BOX cd0303-upcd
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX cd0303-upcd */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME cd0303-upcd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cd0303-upcd cd0303-upcd
ON WINDOW-CLOSE OF FRAME cd0303-upcd /* Pesquisar */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok cd0303-upcd
ON CHOOSE OF bt-ok IN FRAME cd0303-upcd /* OK */
DO:
     ASSIGN p-cod-estab         = input fi-cod-estab               
            p-cod-natur-operac  = input fi-nat-operacao                 
            p-cod-ncm           = input fi-ncm                 
            p-cod-item          = INPUT fi-cod-item                  
            p-cdn-grp-emit      = input fi-grupo-emit                 
            p-cdn-emitente      = input fi-cod-emitente                 
            p-dat-valid-inic    = INPUT fi-data                  
            p-idi-tip-docto     = INPUT rs-tipo   .             
                       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK cd0303-upcd 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects cd0303-upcd  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available cd0303-upcd  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI cd0303-upcd  _DEFAULT-DISABLE
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
  HIDE FRAME cd0303-upcd.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI cd0303-upcd  _DEFAULT-ENABLE
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
  DISPLAY rs-tipo fi-cod-estab fi-nat-operacao fi-ncm fi-cod-item fi-data 
          fi-grupo-emit fi-cod-emitente 
      WITH FRAME cd0303-upcd.
  ENABLE rt-buttom rs-tipo fi-cod-estab fi-nat-operacao fi-ncm fi-cod-item 
         fi-data fi-grupo-emit fi-cod-emitente bt-ok 
      WITH FRAME cd0303-upcd.
  {&OPEN-BROWSERS-IN-QUERY-cd0303-upcd}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy cd0303-upcd 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize cd0303-upcd 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  {utp/ut9000.i "D99XX999" "9.99.99.999"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records cd0303-upcd  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed cd0303-upcd 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
  
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

