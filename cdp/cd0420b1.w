&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
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
{include/i-prgvrs.i CD0420B1 2.00.00.007}  /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i CD0420B1 MCD}
&ENDIF




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

/* Parameters Definitions ---                                           */
def input-output parameter p-cod-obsoleto as integer no-undo.
def input-output parameter p-cod-formato  as integer no-undo.
def input-output parameter p-niveis       as integer no-undo.
def input-output parameter p-corte        as date    no-undo.
def input-output parameter p-op-corte     as date    no-undo.
def       output parameter p-obsoleto     as char    no-undo.
def INPUT-output parameter p-formato      as char    no-undo.
def input-output parameter p-remessa      as logical no-undo.
def input-output parameter p-entrada      as logical no-undo.
def input-output parameter p-transfer     as logical no-undo.
def input-output parameter p-re-con       as logical no-undo.
def input-output parameter p-en-con       as logical no-undo.
def input        parameter p-saldo        as logical no-undo.

/* Local Variable Definitions ---                                       */
def var c-formato as char no-undo extent 3.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-20 rt-buttom rt-formato rt-obsoleto ~
l-remessa rs-obsoleto l-entrada l-transfer l-re-con l-en-con rs-formato ~
i-niveis da-corte da-op-corte bt-ajuda bt-ok bt-cancela 
&Scoped-Define DISPLAYED-OBJECTS l-remessa rs-obsoleto l-entrada l-transfer ~
l-re-con l-en-con rs-formato i-niveis da-corte da-op-corte txt-saldo-terc ~
txt-obsoleto txt-formato 

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

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE da-corte AS DATE FORMAT "99/99/9999":U 
     LABEL "Data de Corte" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE da-op-corte AS DATE FORMAT "99/99/9999":U 
     LABEL "Data de Corte para Ordens Planejadas" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE i-niveis AS INTEGER FORMAT ">9":U INITIAL 19 
     LABEL "N£mero de N¡veis a Listar" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE txt-formato AS CHARACTER FORMAT "X(256)":U INITIAL "Formato" 
      VIEW-AS TEXT 
     SIZE 10 BY .63 NO-UNDO.

DEFINE VARIABLE txt-obsoleto AS CHARACTER FORMAT "X(256)":U INITIAL "Obsoleto" 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE txt-saldo-terc AS CHARACTER FORMAT "X(256)":U INITIAL "Considera Saldos em Terceiros" 
      VIEW-AS TEXT 
     SIZE 30 BY .67 NO-UNDO.

DEFINE VARIABLE rs-formato AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "->>>>,>>9.9999", 1,
"->>>>>>,>>9.99", 2,
"->>>>>>>>>,>>9", 3
     SIZE 64 BY 1.17 NO-UNDO.

DEFINE VARIABLE rs-obsoleto AS INTEGER INITIAL 4 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Ativo", 1,
"Obsoleto Ordens Autom ticas", 2,
"Obsoleto", 3,
"Todos", 4
     SIZE 31 BY 4.04 NO-UNDO.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 32.72 BY 5.21.

DEFINE RECTANGLE rt-buttom
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 68.57 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rt-formato
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65.43 BY 2.08.

DEFINE RECTANGLE rt-obsoleto
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 33 BY 5.17.

DEFINE VARIABLE l-en-con AS LOGICAL INITIAL no 
     LABEL "Entrada em Consigna‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 29.57 BY .83 NO-UNDO.

DEFINE VARIABLE l-entrada AS LOGICAL INITIAL no 
     LABEL "Entrada p/ Beneficiamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .83 NO-UNDO.

DEFINE VARIABLE l-re-con AS LOGICAL INITIAL yes 
     LABEL "Remessa em Consigna‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .83 NO-UNDO.

DEFINE VARIABLE l-remessa AS LOGICAL INITIAL yes 
     LABEL "Remessa p/ Beneficiamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 30.43 BY .83 NO-UNDO.

DEFINE VARIABLE l-transfer AS LOGICAL INITIAL yes 
     LABEL "Transferˆncia" 
     VIEW-AS TOGGLE-BOX
     SIZE 28.43 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     l-remessa AT ROW 2.17 COL 38
     rs-obsoleto AT ROW 2.25 COL 4 NO-LABEL
     l-entrada AT ROW 3.13 COL 38
     l-transfer AT ROW 4.08 COL 38
     l-re-con AT ROW 4.96 COL 38
     l-en-con AT ROW 5.92 COL 38
     rs-formato AT ROW 8.13 COL 3.86 NO-LABEL
     i-niveis AT ROW 9.92 COL 37 COLON-ALIGNED
     da-corte AT ROW 10.79 COL 37 COLON-ALIGNED
     da-op-corte AT ROW 11.75 COL 37 COLON-ALIGNED
     bt-ajuda AT ROW 13.58 COL 59
     bt-ok AT ROW 13.63 COL 2
     bt-cancela AT ROW 13.63 COL 13
     txt-saldo-terc AT ROW 1.25 COL 35.43 COLON-ALIGNED NO-LABEL
     txt-obsoleto AT ROW 1.5 COL 2 COLON-ALIGNED NO-LABEL
     txt-formato AT ROW 7.29 COL 2.72 COLON-ALIGNED NO-LABEL
     RECT-20 AT ROW 1.75 COL 36.72
     rt-buttom AT ROW 13.38 COL 1
     rt-formato AT ROW 7.38 COL 2.86
     rt-obsoleto AT ROW 1.75 COL 3
     SPACE(33.71) SKIP(7.90)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Parƒmetros"
         DEFAULT-BUTTON bt-ok.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/d-dialog.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME                                                           */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN txt-formato IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       txt-formato:PRIVATE-DATA IN FRAME D-Dialog     = 
                "Formato".

/* SETTINGS FOR FILL-IN txt-obsoleto IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       txt-obsoleto:PRIVATE-DATA IN FRAME D-Dialog     = 
                "Obsoleto".

/* SETTINGS FOR FILL-IN txt-saldo-terc IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       txt-saldo-terc:PRIVATE-DATA IN FRAME D-Dialog     = 
                "Obsoleto".

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Parƒmetros */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda D-Dialog
ON CHOOSE OF bt-ajuda IN FRAME D-Dialog /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok D-Dialog
ON CHOOSE OF bt-ok IN FRAME D-Dialog /* OK */
DO:
  
  assign p-cod-obsoleto = input frame {&frame-name} rs-obsoleto
         p-cod-formato  = input frame {&frame-name} rs-formato
         p-niveis       = input frame {&frame-name} i-niveis
         p-corte        = input frame {&frame-name} da-corte
         p-op-corte     = input frame {&frame-name} da-op-corte
         p-formato      = c-formato[input frame {&frame-name} rs-formato]
         p-obsoleto     = entry((p-cod-obsoleto - 1) * 2 + 1,
                                rs-obsoleto:radio-buttons in frame {&frame-name})
         p-remessa      = input frame {&frame-name} l-remessa
         p-entrada      = input frame {&frame-name} l-entrada
         p-transfer     = input frame {&frame-name} l-transfer
         p-re-con       = input frame {&frame-name} l-re-con
         p-en-con       = input frame {&frame-name} l-en-con.
         
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-niveis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-niveis D-Dialog
ON LEAVE OF i-niveis IN FRAME D-Dialog /* N£mero de N¡veis a Listar */
DO:
  if  input frame {&frame-name} i-niveis < 1
  or  input frame {&frame-name} i-niveis > 19 then do:
      /* N£mero de N¡veis deve estar entre 1 e 19 */
      run utp/ut-msgs.p (input "show", input 114, input "").
      return no-apply.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */
 
{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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
  DISPLAY l-remessa rs-obsoleto l-entrada l-transfer l-re-con l-en-con 
          rs-formato i-niveis da-corte da-op-corte txt-saldo-terc txt-obsoleto 
          txt-formato 
      WITH FRAME D-Dialog.
  ENABLE RECT-20 rt-buttom rt-formato rt-obsoleto l-remessa rs-obsoleto 
         l-entrada l-transfer l-re-con l-en-con rs-formato i-niveis da-corte 
         da-op-corte bt-ajuda bt-ok bt-cancela 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy D-Dialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
 
  assign c-formato[1] = "->>>>>>,>>9.9999"
         c-formato[2] = "->>>>>>,>>9.99"
         c-formato[3] = "->>>>>>>>>,>>9"
         da-corte     = p-corte
         da-op-corte  = p-op-corte
         rs-obsoleto  = p-cod-obsoleto
         rs-formato   = p-cod-formato
         i-niveis     = p-niveis
         l-remessa    = p-remessa
         l-entrada    = p-entrada
         l-transfer   = p-transfer
         l-re-con     = p-re-con
         l-en-con     = p-en-con.
 
  /* Dispatch standard ADM method.                             */
{utp/ut9000.i "CD0420B1" "2.00.00.007"}
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
 
 /* Code placed here will execute AFTER standard behavior.  */

IF p-saldo THEN
    
    assign l-remessa:sensitive  in frame {&frame-name} = p-saldo
           l-entrada:sensitive  in frame {&frame-name} = p-saldo 
           l-transfer:sensitive in frame {&frame-name} = p-saldo
           l-re-con:sensitive   in frame {&frame-name} = p-saldo
           l-en-con:sensitive   in frame {&frame-name} = p-saldo.
ELSE
    assign l-remessa:checked  in frame {&frame-name} = NO
           l-entrada:checked  in frame {&frame-name} = NO 
           l-transfer:checked in frame {&frame-name} = NO
           l-re-con:checked   in frame {&frame-name} = NO
           l-en-con:checked   in frame {&frame-name} = NO

           l-remessa:sensitive  in frame {&frame-name} = NO
           l-entrada:sensitive  in frame {&frame-name} = NO 
           l-transfer:sensitive in frame {&frame-name} = NO
           l-re-con:sensitive   in frame {&frame-name} = NO
           l-en-con:sensitive   in frame {&frame-name} = NO.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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

