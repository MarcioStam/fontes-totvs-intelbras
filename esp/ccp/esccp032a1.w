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
{include/i-prgvrs.i ESCCP032A1 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i esccpa032a1 MCD}
&ENDIF


{cdp/cdcfgman.i}

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

def input-output param p-ci-estab-ini as char    no-undo.
def input-output param p-ci-estab-fim as char    no-undo.
def input-output param p-linha-ini    as int     no-undo.
def input-output param p-linha-fim    as int     no-undo.
def input-output param p-ci-item-ini  as char    no-undo.
def input-output param p-ci-item-fim  as char    no-undo.
def input-output param p-ci-fami-ini  as char    no-undo.
def input-output param p-ci-fami-fim  as char    no-undo.
def input-output param p-ci-plan-ini  as char    no-undo.
def input-output param p-ci-plan-fim  as char    no-undo.
def input-output param p-ci-ge-ini    as integer no-undo.
def input-output param p-ci-ge-fim    as integer no-undo.
def input-output param p-ci-comp-ini  as char    no-undo.
def input-output param p-ci-comp-fim  as char    no-undo.
&IF defined(bf_man_206b) &THEN
    def input-output param p-ci-cod-unid-negoc-ini  as char    no-undo.
    def input-output param p-ci-cod-unid-negoc-fim  as char    no-undo.
&ENDIF
/* Local Variable Definitions ---                                       */
&IF DEFINED(bf_man_206b) &THEN
    DEFINE VARIABLE l-usa-un-neg AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE h-cdapi024   AS HANDLE     NO-UNDO.
&endif

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
&Scoped-Define ENABLED-OBJECTS rt-componentes IMAGE-1 IMAGE-2 IMAGE-17 ~
IMAGE-18 IMAGE-3 IMAGE-8 IMAGE-4 IMAGE-9 IMAGE-5 IMAGE-10 IMAGE-6 IMAGE-11 ~
IMAGE-7 IMAGE-12 rt-buttom c-estab-ini c-estab-fim i-linha-ini i-linha-fim ~
c-item-ini c-item-fim c-fami-ini c-fami-fim c-plan-ini c-plan-fim i-ge-ini ~
i-ge-fim c-comp-ini c-comp-fim bt-ok bt-cancela bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS c-estab-ini c-estab-fim i-linha-ini ~
i-linha-fim c-item-ini c-item-fim c-fami-ini c-fami-fim c-plan-ini ~
c-plan-fim i-ge-ini i-ge-fim c-comp-ini c-comp-fim txt-componete 

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

DEFINE BUTTON bt-cancela AUTO-GO 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE c-cod-unid-negoc-fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-unid-negoc-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unid. Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-comp-fim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-comp-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Comprador" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-estab-fim AS CHARACTER FORMAT "X(3)":U INITIAL "104" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-estab-ini AS CHARACTER FORMAT "X(3)":U INITIAL "104" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-fami-fim AS CHARACTER FORMAT "X(8)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-fami-ini AS CHARACTER FORMAT "X(8)":U 
     LABEL "Fam¡lia" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-item-fim AS CHARACTER FORMAT "X(16)":U INITIAL "4999999" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE c-item-ini AS CHARACTER FORMAT "X(16)":U INITIAL "4000000" 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE c-plan-fim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-plan-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Planejador" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE i-ge-fim AS INTEGER FORMAT ">9":U INITIAL 99 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE i-ge-ini AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Grupo Estoque" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE i-linha-fim AS INTEGER FORMAT ">>9":U INITIAL 999 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE i-linha-ini AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Linha Produ‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE txt-componete AS CHARACTER FORMAT "X(256)":U INITIAL "Sele‡Æo dos Componentes do Item" 
      VIEW-AS TEXT 
     SIZE 35 BY .63 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-17
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-19
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-20
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE rt-buttom
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 72 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rt-componentes
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 71.86 BY 9.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     c-estab-ini AT ROW 2.5 COL 18 COLON-ALIGNED
     c-estab-fim AT ROW 2.5 COL 48 COLON-ALIGNED NO-LABEL
     i-linha-ini AT ROW 3.5 COL 18 COLON-ALIGNED
     i-linha-fim AT ROW 3.5 COL 48 COLON-ALIGNED NO-LABEL
     c-item-ini AT ROW 4.5 COL 18 COLON-ALIGNED
     c-item-fim AT ROW 4.5 COL 48 COLON-ALIGNED NO-LABEL
     c-fami-ini AT ROW 5.5 COL 18 COLON-ALIGNED
     c-fami-fim AT ROW 5.5 COL 48 COLON-ALIGNED NO-LABEL
     c-plan-ini AT ROW 6.5 COL 18 COLON-ALIGNED
     c-plan-fim AT ROW 6.5 COL 48 COLON-ALIGNED NO-LABEL
     i-ge-ini AT ROW 7.5 COL 18 COLON-ALIGNED
     i-ge-fim AT ROW 7.5 COL 48 COLON-ALIGNED NO-LABEL
     c-comp-ini AT ROW 8.5 COL 18 COLON-ALIGNED
     c-comp-fim AT ROW 8.5 COL 48 COLON-ALIGNED NO-LABEL
     c-cod-unid-negoc-ini AT ROW 9.5 COL 18 COLON-ALIGNED
     c-cod-unid-negoc-fim AT ROW 9.5 COL 48 COLON-ALIGNED NO-LABEL
     bt-ok AT ROW 11.25 COL 3
     bt-cancela AT ROW 11.25 COL 14
     bt-ajuda AT ROW 11.29 COL 63
     txt-componete AT ROW 1.25 COL 3 NO-LABEL
     rt-componentes AT ROW 1.58 COL 1.86
     IMAGE-1 AT ROW 2.5 COL 42
     IMAGE-2 AT ROW 2.5 COL 47
     IMAGE-17 AT ROW 3.5 COL 42
     IMAGE-18 AT ROW 3.5 COL 47
     IMAGE-3 AT ROW 4.5 COL 42
     IMAGE-8 AT ROW 4.5 COL 47
     IMAGE-4 AT ROW 5.5 COL 42
     IMAGE-9 AT ROW 5.5 COL 47
     IMAGE-5 AT ROW 6.5 COL 42
     IMAGE-10 AT ROW 6.5 COL 47
     IMAGE-6 AT ROW 7.5 COL 42
     IMAGE-11 AT ROW 7.5 COL 47
     IMAGE-7 AT ROW 8.5 COL 42
     IMAGE-12 AT ROW 8.5 COL 47
     rt-buttom AT ROW 11.04 COL 2
     IMAGE-19 AT ROW 9.5 COL 42
     IMAGE-20 AT ROW 9.5 COL 47
     SPACE(24.56) SKIP(2.08)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Componentes do Item"
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

/* SETTINGS FOR FILL-IN c-cod-unid-negoc-fim IN FRAME D-Dialog
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       c-cod-unid-negoc-fim:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-unid-negoc-ini IN FRAME D-Dialog
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       c-cod-unid-negoc-ini:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR IMAGE IMAGE-19 IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       IMAGE-19:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR IMAGE IMAGE-20 IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       IMAGE-20:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR FILL-IN txt-componete IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       txt-componete:PRIVATE-DATA IN FRAME D-Dialog     = 
                "Sele‡Æo dos Componentes do Item".

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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Componentes do Item */
DO:  
   /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.

  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  /*APPLY "END-ERROR":U TO SELF.*/
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


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela D-Dialog
ON CHOOSE OF bt-cancela IN FRAME D-Dialog /* Cancelar */
DO:
  apply "close" to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok D-Dialog
ON CHOOSE OF bt-ok IN FRAME D-Dialog /* OK */
DO:
  assign p-ci-estab-ini = input frame {&frame-name} c-estab-ini
         p-ci-estab-fim = input frame {&frame-name} c-estab-fim
         p-linha-ini    = input frame {&frame-name} i-linha-ini
         p-linha-fim    = input frame {&frame-name} i-linha-fim
         p-ci-item-ini  = input frame {&frame-name} c-item-ini
         p-ci-item-fim  = input frame {&frame-name} c-item-fim
         p-ci-fami-ini  = input frame {&frame-name} c-fami-ini
         p-ci-fami-fim  = input frame {&frame-name} c-fami-fim
         p-ci-plan-ini  = input frame {&frame-name} c-plan-ini
         p-ci-plan-fim  = input frame {&frame-name} c-plan-fim
         p-ci-ge-ini    = input frame {&frame-name} i-ge-ini
         p-ci-ge-fim    = input frame {&frame-name} i-ge-fim
         p-ci-comp-ini  = input frame {&frame-name} c-comp-ini
         p-ci-comp-fim  = input frame {&frame-name} c-comp-fim.
         &IF defined(bf_man_206b) &THEN
            IF l-usa-un-neg THEN
                ASSIGN p-ci-cod-unid-negoc-ini = c-cod-unid-negoc-ini:SCREEN-VALUE IN FRAME {&frame-name}
                       p-ci-cod-unid-negoc-fim = c-cod-unid-negoc-fim:SCREEN-VALUE IN FRAME {&frame-name}.
         &ENDIF
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
  DISPLAY c-estab-ini c-estab-fim i-linha-ini i-linha-fim c-item-ini c-item-fim 
          c-fami-ini c-fami-fim c-plan-ini c-plan-fim i-ge-ini i-ge-fim 
          c-comp-ini c-comp-fim txt-componete 
      WITH FRAME D-Dialog.
  ENABLE rt-componentes IMAGE-1 IMAGE-2 IMAGE-17 IMAGE-18 IMAGE-3 IMAGE-8 
         IMAGE-4 IMAGE-9 IMAGE-5 IMAGE-10 IMAGE-6 IMAGE-11 IMAGE-7 IMAGE-12 
         rt-buttom c-estab-ini c-estab-fim i-linha-ini i-linha-fim c-item-ini 
         c-item-fim c-fami-ini c-fami-fim c-plan-ini c-plan-fim i-ge-ini 
         i-ge-fim c-comp-ini c-comp-fim bt-ok bt-cancela bt-ajuda 
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
  &IF DEFINED(bf_man_206b) &THEN
      IF VALID-HANDLE(h-cdapi024) THEN DO:
          run pi-finalizar in h-cdapi024.
          ASSIGN h-cdapi024 = ?.
      END.
  &ENDIF
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
  assign c-estab-ini = p-ci-estab-ini
         c-estab-fim = p-ci-estab-fim
         i-linha-ini = p-linha-ini
         i-linha-fim = p-linha-fim
         c-item-ini  = p-ci-item-ini
         c-item-fim  = p-ci-item-fim
         c-fami-ini  = p-ci-fami-ini
         c-fami-fim  = p-ci-fami-fim
         c-plan-ini  = p-ci-plan-ini
         c-plan-fim  = p-ci-plan-fim
         i-ge-ini    = p-ci-ge-ini
         i-ge-fim    = p-ci-ge-fim
         c-comp-ini  = p-ci-comp-ini
         c-comp-fim  = p-ci-comp-fim.

  &IF defined(bf_man_206b) &THEN
  
      IF CAN-FIND (FIRST funcao WHERE funcao.cd-funcao = "EMS2-UNIDADE-NEGOCIO":U 
                                AND   funcao.ativo     = TRUE) THEN DO:
          RUN cdp/cdapi024.p PERSISTENT SET h-cdapi024.
          {utp/ut-field.i mgind unid-negoc cod-unid-negoc 1}
          assign c-cod-unid-negoc-ini:label in frame {&frame-name} = return-value
                 l-usa-un-neg                                      = YES.
      
          ASSIGN c-cod-unid-negoc-ini:VISIBLE   IN FRAME {&frame-name} = YES
                 c-cod-unid-negoc-fim:VISIBLE   IN FRAME {&frame-name} = YES
                 image-19:VISIBLE               IN FRAME {&frame-name} = YES
                 image-20:VISIBLE               IN FRAME {&frame-name} = YES
                 c-cod-unid-negoc-ini:SENSITIVE IN FRAME {&frame-name} = YES
                 c-cod-unid-negoc-fim:SENSITIVE IN FRAME {&frame-name} = YES
                 image-19:SENSITIVE             IN FRAME {&frame-name} = YES
                 image-20:SENSITIVE             IN FRAME {&frame-name} = YES.

          ASSIGN c-cod-unid-negoc-ini:SCREEN-VALUE IN FRAME {&frame-name} = p-ci-cod-unid-negoc-ini
                 c-cod-unid-negoc-fim:SCREEN-VALUE IN FRAME {&frame-name} = p-ci-cod-unid-negoc-fim.
      END.
  &ENDIF
  
  /* Dispatch standard ADM method.                             */
{utp/ut9000.i "ESCCP032A1" "2.00.00.006"}
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */


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

