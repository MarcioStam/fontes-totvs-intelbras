&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def input-output parameter l-abertos        as logical no-undo.
def input-output parameter l-atend-total    as logical no-undo.
def input-output parameter l-atend-parcial  as logical no-undo.
def input-output parameter l-suspensos      as logical no-undo.
def input-output parameter l-cancelados     as logical no-undo.
def input-output parameter l-ok             as logical no-undo.
def input-output parameter l-avaliado       as logical no-undo.
def input-output parameter l-nao-avaliado   as logical no-undo.
def input-output parameter l-aprovado       as logical no-undo.
def input-output parameter l-reprovado      as logical no-undo.
def input-output parameter l-ped-a-vista    as logical no-undo.
def input-output parameter l-bndes          as logical no-undo.
def input-output parameter l-cond-ic        as logical no-undo.
def input-output parameter l-cond-intelbras as logical no-undo.
def input-output parameter dt-implant-ini   as date    no-undo.
def input-output parameter dt-implant-fim   as date    no-undo.
def input-output parameter dt-entrega-ini   as date    no-undo.
def input-output parameter dt-entrega-fim   as date    no-undo.

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
&Scoped-Define ENABLED-OBJECTS IMAGE-3 RECT-12 RECT-13 rt-buttom IMAGE-4 ~
RECT-11 IMAGE-1 IMAGE-2 RECT-14 tg-Abertos tg-avaliado tg-atend-parcial ~
tg-Nao-avaliado tg-atend-total tg-aprovado tg-reprovado tg-suspensos ~
tg-cancelados tg-ped-a-vista tg-bndes tg-cond-ic tg-cond-intelbras ~
fi-dt-implant-ini fi-dt-implant-fim fi-dt-entrega-ini fi-dt-entrega-fim ~
bt-ok bt-cancela bt-ajuda selecao-datas 
&Scoped-Define DISPLAYED-OBJECTS tg-Abertos tg-avaliado tg-atend-parcial ~
tg-Nao-avaliado tg-atend-total tg-aprovado tg-reprovado tg-suspensos ~
tg-cancelados tg-ped-a-vista tg-bndes tg-cond-ic tg-cond-intelbras ~
fi-dt-implant-ini fi-dt-implant-fim fi-dt-entrega-ini fi-dt-entrega-fim ~
selecao-datas 

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

DEFINE VARIABLE avaliacao AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 10.14 BY .67 NO-UNDO.

DEFINE VARIABLE cobranca AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 18 BY .67 NO-UNDO.

DEFINE VARIABLE fi-dt-entrega-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dt-entrega-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dt-implant-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dt-implant-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE selecao-datas AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE Situacao AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 11 BY .67 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 22.14 BY 5.75.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 24 BY 5.75.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47 BY 3.25.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47 BY 4.5.

DEFINE RECTANGLE rt-buttom
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 47 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tg-Abertos AS LOGICAL INITIAL no 
     LABEL "Abertos" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .75 NO-UNDO.

DEFINE VARIABLE tg-aprovado AS LOGICAL INITIAL no 
     LABEL "Aprovado" 
     VIEW-AS TOGGLE-BOX
     SIZE 12 BY .75 NO-UNDO.

DEFINE VARIABLE tg-atend-parcial AS LOGICAL INITIAL no 
     LABEL "Atendido Parcial" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .75 NO-UNDO.

DEFINE VARIABLE tg-atend-total AS LOGICAL INITIAL no 
     LABEL "Atendido Total" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .75 NO-UNDO.

DEFINE VARIABLE tg-avaliado AS LOGICAL INITIAL no 
     LABEL "Avaliado" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .75 NO-UNDO.

DEFINE VARIABLE tg-bndes AS LOGICAL INITIAL no 
     LABEL "BNDES" 
     VIEW-AS TOGGLE-BOX
     SIZE 10.43 BY .75 NO-UNDO.

DEFINE VARIABLE tg-cancelados AS LOGICAL INITIAL no 
     LABEL "Cancelado" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .75 NO-UNDO.

DEFINE VARIABLE tg-cond-ic AS LOGICAL INITIAL no 
     LABEL "CONDI€åES IC" 
     VIEW-AS TOGGLE-BOX
     SIZE 18.43 BY .75 NO-UNDO.

DEFINE VARIABLE tg-cond-intelbras AS LOGICAL INITIAL no 
     LABEL "CONDI€åES INTELBRAS" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.43 BY .75 NO-UNDO.

DEFINE VARIABLE tg-Nao-avaliado AS LOGICAL INITIAL no 
     LABEL "NÆo Avaliado" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .75 NO-UNDO.

DEFINE VARIABLE tg-ped-a-vista AS LOGICAL INITIAL no 
     LABEL "PEDIDOS · VISTA" 
     VIEW-AS TOGGLE-BOX
     SIZE 20.43 BY .75 NO-UNDO.

DEFINE VARIABLE tg-reprovado AS LOGICAL INITIAL no 
     LABEL "NÆo Aprovado" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .75 NO-UNDO.

DEFINE VARIABLE tg-suspensos AS LOGICAL INITIAL no 
     LABEL "Suspenso" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .75 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     tg-Abertos AT ROW 2.5 COL 5.14
     tg-avaliado AT ROW 2.5 COL 30
     tg-atend-parcial AT ROW 3.29 COL 5.14
     tg-Nao-avaliado AT ROW 3.29 COL 30
     tg-atend-total AT ROW 4.13 COL 5.14
     tg-aprovado AT ROW 4.13 COL 30
     tg-reprovado AT ROW 4.92 COL 30
     tg-suspensos AT ROW 5 COL 5.14
     tg-cancelados AT ROW 5.83 COL 5.14
     tg-ped-a-vista AT ROW 8.75 COL 11 WIDGET-ID 6
     tg-bndes AT ROW 9.5 COL 11 WIDGET-ID 8
     tg-cond-ic AT ROW 10.25 COL 11 WIDGET-ID 10
     tg-cond-intelbras AT ROW 11 COL 11 WIDGET-ID 12
     fi-dt-implant-ini AT ROW 13.88 COL 13.57 COLON-ALIGNED
     fi-dt-implant-fim AT ROW 13.88 COL 33.43 COLON-ALIGNED NO-LABEL
     fi-dt-entrega-ini AT ROW 14.88 COL 13.57 COLON-ALIGNED
     fi-dt-entrega-fim AT ROW 14.88 COL 33.43 COLON-ALIGNED NO-LABEL
     bt-ok AT ROW 16.63 COL 2.86
     bt-cancela AT ROW 16.63 COL 13.57
     bt-ajuda AT ROW 16.63 COL 38.43
     Situacao AT ROW 1.25 COL 3 NO-LABEL
     avaliacao AT ROW 1.25 COL 27.86 NO-LABEL
     cobranca AT ROW 7.5 COL 3 NO-LABEL WIDGET-ID 4
     selecao-datas AT ROW 12.63 COL 3 NO-LABEL
     IMAGE-3 AT ROW 14.88 COL 25.43
     RECT-12 AT ROW 1.5 COL 2
     RECT-13 AT ROW 12.88 COL 2
     rt-buttom AT ROW 16.38 COL 2
     IMAGE-4 AT ROW 14.88 COL 32.43
     RECT-11 AT ROW 1.5 COL 26.86
     IMAGE-1 AT ROW 13.88 COL 25.43
     IMAGE-2 AT ROW 13.88 COL 32.43
     RECT-14 AT ROW 7.75 COL 2 WIDGET-ID 2
     SPACE(0.71) SKIP(5.66)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Parƒmetros Pedido".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/d-dialog.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   NOT-VISIBLE FRAME-NAME L-To-R                                        */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN avaliacao IN FRAME D-Dialog
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN cobranca IN FRAME D-Dialog
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN selecao-datas IN FRAME D-Dialog
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN Situacao IN FRAME D-Dialog
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Parƒmetros Pedido */
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
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela D-Dialog
ON CHOOSE OF bt-cancela IN FRAME D-Dialog /* Cancelar */
DO:
    Assign l-ok = no.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok D-Dialog
ON CHOOSE OF bt-ok IN FRAME D-Dialog /* OK */
DO:
    Assign l-abertos        = tg-abertos:checked in frame {&frame-name}
           l-atend-total    = tg-atend-total:checked in frame {&frame-name}
           l-atend-parcial  = tg-atend-parcial:checked in frame {&frame-name}
           l-suspensos      = tg-suspensos:checked in frame {&frame-name}
           l-cancelados     = tg-cancelados:checked in frame {&frame-name}
           l-ok             = yes
           l-avaliado       = tg-avaliado:checked in frame {&frame-name}
           l-nao-avaliado   = tg-nao-avaliado:checked in frame {&frame-name}
           l-aprovado       = tg-aprovado:checked in frame {&frame-name}
           l-reprovado      = tg-reprovado:checked in frame {&frame-name}
           l-ped-a-vista    = tg-ped-a-vista:checked in frame {&frame-name}
           l-bndes          = tg-bndes:checked in frame {&frame-name}
           l-cond-ic        = tg-cond-ic:checked in frame {&frame-name}
           l-cond-intelbras = tg-cond-intelbras:checked in frame {&frame-name}
           dt-implant-ini  = date(fi-dt-implant-ini:screen-value in frame {&frame-name})
           dt-implant-fim  = date(fi-dt-implant-fim:screen-value in frame {&frame-name})
           dt-entrega-ini  = date(fi-dt-entrega-ini:screen-value in frame {&frame-name})
           dt-entrega-fim  = date(fi-dt-entrega-fim:screen-value in frame {&frame-name}).

    If  not l-abertos and
        not l-atend-total and
        not l-atend-parcial and
        not l-suspensos and
        not l-cancelados then do:
        run utp/ut-msgs.p (input "SHOW", input 676, input "").
        apply 'entry' to tg-abertos in frame {&frame-name}.
        return no-apply.
    End.

    if  not l-avaliado and
        not l-nao-avaliado and
        not l-aprovado and
        not l-reprovado then do:
        run utp/ut-msgs.p (input "SHOW", input 676, input "").
        apply 'entry' to tg-avaliado in frame {&frame-name}.
        return no-apply.
    End.

    if  not l-ped-a-vista and   
        not l-bndes and   
        not l-cond-ic and   
        not l-cond-intelbras THEN DO:
        run utp/ut-msgs.p (input "SHOW", input 676, input "").
        apply 'entry' to tg-ped-a-vista in frame {&frame-name}.
        return no-apply.
    End.

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
  DISPLAY tg-Abertos tg-avaliado tg-atend-parcial tg-Nao-avaliado tg-atend-total 
          tg-aprovado tg-reprovado tg-suspensos tg-cancelados tg-ped-a-vista 
          tg-bndes tg-cond-ic tg-cond-intelbras fi-dt-implant-ini 
          fi-dt-implant-fim fi-dt-entrega-ini fi-dt-entrega-fim selecao-datas 
      WITH FRAME D-Dialog.
  ENABLE IMAGE-3 RECT-12 RECT-13 rt-buttom IMAGE-4 RECT-11 IMAGE-1 IMAGE-2 
         RECT-14 tg-Abertos tg-avaliado tg-atend-parcial tg-Nao-avaliado 
         tg-atend-total tg-aprovado tg-reprovado tg-suspensos tg-cancelados 
         tg-ped-a-vista tg-bndes tg-cond-ic tg-cond-intelbras fi-dt-implant-ini 
         fi-dt-implant-fim fi-dt-entrega-ini fi-dt-entrega-fim bt-ok bt-cancela 
         bt-ajuda selecao-datas 
      WITH FRAME D-Dialog.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
 do with frame {&frame-name} :
     {utp/ut-liter.i Situa‡Æo * R}
     assign situacao:screen-value = " " + return-value.
     {utp/ut-liter.i Avalia‡Æo * R}
     assign avaliacao:screen-value = " " + return-value.
     {utp/ut-liter.i Modalidade_Cobran‡a * R}
     assign cobranca:screen-value = " " + return-value.
     {utp/ut-liter.i Sele‡Æo_de_Datas * R}
     assign selecao-datas:screen-value = " " + return-value.
     {utp/ut-liter.i Abertos * R}
     assign tg-abertos:label = trim(return-value).  
     {utp/ut-liter.i Atendido_Parcial * R}
     assign tg-atend-parcial:label = trim(return-value).     
     {utp/ut-liter.i Atendido_Total * R}
     assign tg-atend-total:label = trim(return-value).     
     {utp/ut-liter.i Suspenso * R}
     assign tg-suspensos:label = trim(return-value).
     {utp/ut-liter.i Cancelado * R}
     assign tg-cancelados:label = trim(return-value).
     {utp/ut-liter.i Avaliado * R}
     assign tg-avaliado:label = trim(return-value).
     {utp/ut-liter.i NÆo_Avaliado * R}
     assign tg-nao-avaliado:label = trim(return-value).
     {utp/ut-liter.i Aprovado * R}
     assign tg-aprovado:label = trim(return-value).
     {utp/ut-liter.i NÆo_Aprovado * R}
     assign tg-reprovado:label = trim(return-value)
            tg-abertos:checked = l-abertos
            tg-atend-total:checked = l-atend-total
            tg-atend-parcial:checked = l-atend-parcial
            tg-suspensos:checked = l-suspensos
            tg-cancelados:checked = l-cancelados
            tg-avaliado:checked   = l-avaliado
            tg-nao-avaliado:checked = l-nao-avaliado
            tg-aprovado:checked  = l-aprovado
            tg-reprovado:checked = l-reprovado
            tg-ped-a-vista:checked = l-ped-a-vista   
            tg-bndes:checked = l-bndes         
            tg-cond-ic:checked = l-cond-ic       
            tg-cond-intelbras:checked = l-cond-intelbras.

     {utp/ut-liter.i Dt_Implanta‡Æo * R}
     assign fi-dt-implant-ini:label        = return-value
            fi-dt-implant-ini:screen-value = string(dt-implant-ini)
            fi-dt-implant-fim:screen-value = string(dt-implant-fim).
     {utp/ut-liter.i Dt_Entrega * R}
     assign fi-dt-entrega-ini:label        = return-value
            fi-dt-entrega-ini:screen-value = string(dt-entrega-ini)
            fi-dt-entrega-fim:screen-value = string(dt-entrega-fim).

 end. 
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

