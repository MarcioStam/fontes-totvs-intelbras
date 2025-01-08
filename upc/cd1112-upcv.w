&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i V53AD098 2.00.00.005}  /*** 010005 ***/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

def var rw-item-uni-estab  as rowid                  no-undo.
def var c-texto            as char extent 2          no-undo.
def var h-window           as handle                 no-undo.
def var c-handle           as char                   no-undo.
def var hProgramZoom as handle no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES item-uni-estab
&Scoped-define FIRST-EXTERNAL-TABLE item-uni-estab


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item-uni-estab.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-28 RECT-29 v-log-comp-spot ~
v-log-phase-in v-num-dias-transf v-log-item-rest v-log-requer-aval ~
v-log-mod-aereo v-log-phase-out v-num-dias-antec v-log-bloq-prod ~
v-cod-modelo v-qtd-min-comp v-qtd-max-comp v-qtd-min-fab v-qtd-max-fab ~
v-num-dias-cob-mp v-num-dias-min v-num-dias-alvo-mp v-num-dias-alvo 
&Scoped-Define DISPLAYED-OBJECTS v-log-comp-spot v-log-phase-in ~
v-num-dias-transf v-log-item-rest v-log-requer-aval v-log-mod-aereo ~
v-log-phase-out v-num-dias-antec v-log-bloq-prod v-cod-modelo des-modelo ~
v-qtd-min-comp v-qtd-max-comp v-qtd-min-fab v-qtd-max-fab v-num-dias-cob-mp ~
v-num-dias-min v-num-dias-alvo-mp v-num-dias-alvo 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE des-modelo AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 36.43 BY .79 NO-UNDO.

DEFINE VARIABLE v-cod-modelo AS CHARACTER FORMAT "x(16)" 
     LABEL "Modelo" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79.

DEFINE VARIABLE v-num-dias-alvo AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Dias Cobertura Alvo" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79.

DEFINE VARIABLE v-num-dias-alvo-mp AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Dias Cobertura Alvo MP Kit CKD/SKD" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79.

DEFINE VARIABLE v-num-dias-antec AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Dias Antec." 
     VIEW-AS FILL-IN 
     SIZE 6 BY .79.

DEFINE VARIABLE v-num-dias-cob-mp AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Dias Cobertura Min. MP Kit CKD/SKD" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79.

DEFINE VARIABLE v-num-dias-min AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Dias Cobertura M°nimo" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79.

DEFINE VARIABLE v-num-dias-transf AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Dias Transf." 
     VIEW-AS FILL-IN 
     SIZE 6 BY .79.

DEFINE VARIABLE v-qtd-max-comp AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Qtd Max.Compra" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79.

DEFINE VARIABLE v-qtd-max-fab AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Qtd Max.Fab" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79.

DEFINE VARIABLE v-qtd-min-comp AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Qtd Min. Compras CKD/SKD" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79.

DEFINE VARIABLE v-qtd-min-fab AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Qtd Min. Fabric. CKD/SKD" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .79.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 3.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 6.08.

DEFINE VARIABLE v-log-bloq-prod AS LOGICAL INITIAL no 
     LABEL "Bloqueado Produá∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.43 BY .83.

DEFINE VARIABLE v-log-comp-spot AS LOGICAL INITIAL no 
     LABEL "Permite Compra Spot" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.57 BY .83.

DEFINE VARIABLE v-log-item-rest AS LOGICAL INITIAL no 
     LABEL "Item Restritivo" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .83.

DEFINE VARIABLE v-log-mod-aereo AS LOGICAL INITIAL no 
     LABEL "Permite Modal A√Çreo" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.57 BY .83.

DEFINE VARIABLE v-log-phase-in AS LOGICAL INITIAL no 
     LABEL "Item Phase-in" 
     VIEW-AS TOGGLE-BOX
     SIZE 14.43 BY .83.

DEFINE VARIABLE v-log-phase-out AS LOGICAL INITIAL no 
     LABEL "Item Phase-out" 
     VIEW-AS TOGGLE-BOX
     SIZE 14.43 BY .83.

DEFINE VARIABLE v-log-requer-aval AS LOGICAL INITIAL no 
     LABEL "Requer Avaliaá∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     v-log-comp-spot AT ROW 1.5 COL 3 WIDGET-ID 2
     v-log-phase-in AT ROW 1.5 COL 21.43 WIDGET-ID 6
     v-num-dias-transf AT ROW 1.5 COL 42.86 COLON-ALIGNED WIDGET-ID 18
     v-log-item-rest AT ROW 1.5 COL 53.14 WIDGET-ID 36
     v-log-requer-aval AT ROW 1.5 COL 71 WIDGET-ID 40
     v-log-mod-aereo AT ROW 2.75 COL 3 WIDGET-ID 4
     v-log-phase-out AT ROW 2.75 COL 21.43 WIDGET-ID 8
     v-num-dias-antec AT ROW 2.75 COL 42.86 COLON-ALIGNED WIDGET-ID 34
     v-log-bloq-prod AT ROW 2.75 COL 53.14 WIDGET-ID 38
     v-cod-modelo AT ROW 4.33 COL 27.57 COLON-ALIGNED WIDGET-ID 10
     des-modelo AT ROW 4.33 COL 39.43 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     v-qtd-min-comp AT ROW 5.42 COL 27.57 COLON-ALIGNED WIDGET-ID 26
     v-qtd-max-comp AT ROW 5.42 COL 64.14 COLON-ALIGNED WIDGET-ID 16
     v-qtd-min-fab AT ROW 6.54 COL 27.57 COLON-ALIGNED WIDGET-ID 28
     v-qtd-max-fab AT ROW 6.54 COL 64.14 COLON-ALIGNED WIDGET-ID 20
     v-num-dias-cob-mp AT ROW 7.67 COL 27.57 COLON-ALIGNED WIDGET-ID 32
     v-num-dias-min AT ROW 7.67 COL 64 COLON-ALIGNED WIDGET-ID 22
     v-num-dias-alvo-mp AT ROW 8.79 COL 27.72 COLON-ALIGNED WIDGET-ID 30
     v-num-dias-alvo AT ROW 8.79 COL 64 COLON-ALIGNED WIDGET-ID 24
     RECT-28 AT ROW 1 COL 1
     RECT-29 AT ROW 3.92 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgcad.item-uni-estab
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 9.79
         WIDTH              = 89.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN des-modelo IN FRAME f-main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME v-cod-modelo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-modelo V-table-Win
ON LEAVE OF v-cod-modelo IN FRAME f-main /* Modelo */
DO:
    assign des-modelo:screen-value in frame {&frame-name} = "".

    for first int-modelo
        where int-modelo.cod-modelo = input frame {&frame-name} v-cod-modelo
              no-lock: end.

    if avail int-modelo
    then assign v-cod-modelo:screen-value in frame {&frame-name} = int-modelo.cod-modelo
                des-modelo:screen-value   in frame {&frame-name} = int-modelo.desc-modelo.

    IF  avail int-modelo
    and int-modelo.log-aps THEN DO:
        ENABLE v-qtd-min-comp     
               v-qtd-min-fab
               v-num-dias-cob-mp
               v-num-dias-alvo-mp WITH FRAME {&FRAME-NAME}.
    END.
    ELSE DO:
        DISABLE v-qtd-min-comp     
                v-qtd-min-fab
                v-num-dias-cob-mp
                v-num-dias-alvo-mp WITH FRAME {&FRAME-NAME}.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-modelo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF v-cod-modelo IN FRAME f-main /* Modelo */
DO:
    {method/ZoomFields.i &ProgramZoom="esp\cdp\escdp104z1.w"
                         &FieldZoom1="cod-modelo"
                         &FieldScreen1="v-cod-modelo"
                         &Frame1="f-main"
                         &EnableImplant="NO"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-log-phase-in
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-log-phase-in V-table-Win
ON VALUE-CHANGED OF v-log-phase-in IN FRAME f-main /* Item Phase-in */
DO:
    IF v-log-phase-in:CHECKED = YES THEN
        ASSIGN v-log-phase-out:SENSITIVE = NO.
    ELSE
        ASSIGN v-log-phase-out:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-log-phase-out
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-log-phase-out V-table-Win
ON VALUE-CHANGED OF v-log-phase-out IN FRAME f-main /* Item Phase-out */
DO:
    IF v-log-phase-out:CHECKED = YES THEN
        ASSIGN v-log-phase-in:SENSITIVE = NO.
    ELSE
        ASSIGN v-log-phase-in:SENSITIVE = YES.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  
  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "item-uni-estab"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item-uni-estab"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
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
  HIDE FRAME f-main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}
    
    /* Ponha na pi-validate todas as validaá‰es */
    /* N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */

    /* Dispatch standard ADM method.                             
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) . */
    RUN pi-validate.
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */
    IF  AVAIL item-uni-estab THEN DO:
        FOR FIRST int-item-uni-estab 
            WHERE int-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel
              AND int-item-uni-estab.it-codigo   = item-uni-estab.it-codigo 
                  EXCLUSIVE-LOCK: end.

        if not avail int-item-uni-estab
        then do:
             create int-item-uni-estab.
             assign int-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel
                    int-item-uni-estab.it-codigo   = item-uni-estab.it-codigo.
        end.

        ASSIGN int-item-uni-estab.log-comp-spot    = v-log-comp-spot:CHECKED             IN FRAME {&FRAME-NAME} 
               int-item-uni-estab.log-mod-aereo    = v-log-mod-aereo:CHECKED             IN FRAME {&FRAME-NAME} 
               int-item-uni-estab.log-phase-in     = v-log-phase-in:CHECKED              IN FRAME {&FRAME-NAME} 
               int-item-uni-estab.log-phase-out    = v-log-phase-out:CHECKED             IN FRAME {&FRAME-NAME} 
               int-item-uni-estab.num-dias-transf  = INT(v-num-dias-transf:SCREEN-VALUE  IN FRAME {&FRAME-NAME})
               int-item-uni-estab.cod-modelo       = v-cod-modelo:SCREEN-VALUE           IN FRAME {&FRAME-NAME}
               int-item-uni-estab.qtd-min-comp     = DEC(v-qtd-min-comp:SCREEN-VALUE     IN FRAME {&FRAME-NAME})
               int-item-uni-estab.qtd-min-fab      = DEC(v-qtd-min-fab:SCREEN-VALUE      IN FRAME {&FRAME-NAME})
               int-item-uni-estab.qtd-max-comp     = DEC(v-qtd-max-comp:SCREEN-VALUE     IN FRAME {&FRAME-NAME})
               int-item-uni-estab.qtd-max-fab      = DEC(v-qtd-max-fab:SCREEN-VALUE      IN FRAME {&FRAME-NAME})
               int-item-uni-estab.num-dias-min     = INT(v-num-dias-min:SCREEN-VALUE     IN FRAME {&FRAME-NAME})
               int-item-uni-estab.num-dias-alvo    = INT(v-num-dias-alvo:SCREEN-VALUE    IN FRAME {&FRAME-NAME})
               int-item-uni-estab.num-dias-cob-mp  = INT(v-num-dias-cob-mp:SCREEN-VALUE  IN FRAME {&FRAME-NAME})
               int-item-uni-estab.num-dias-alvo-mp = INT(v-num-dias-alvo-mp:SCREEN-VALUE IN FRAME {&FRAME-NAME})
               int-item-uni-estab.num-dias-antec   = INT(v-num-dias-antec:SCREEN-VALUE   IN FRAME {&FRAME-NAME})
               int-item-uni-estab.log-item-rest    = v-log-item-rest:CHECKED             IN FRAME {&FRAME-NAME} 
               int-item-uni-estab.log-bloq-prod    = v-log-bloq-prod:checked             in frame {&frame-name}
               int-item-uni-estab.log-requer-aval  = v-log-requer-aval:checked           in frame {&frame-name}.
        find current int-item-uni-estab no-lock no-error.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Code placed here will execute PRIOR to standard behavior. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    disable v-log-comp-spot   
            v-log-mod-aereo      
            v-log-phase-in
            v-log-phase-out
            v-num-dias-transf
            v-cod-modelo
            des-modelo
            v-qtd-min-comp
            v-qtd-min-fab
            v-qtd-max-comp
            v-qtd-max-fab
            v-num-dias-min
            v-num-dias-alvo 
            v-num-dias-cob-mp
            v-num-dias-alvo-mp 
            v-num-dias-antec 
            v-log-item-rest
            v-log-bloq-prod
            v-log-requer-aval with frame {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  ASSIGN v-log-comp-spot:CHECKED           IN FRAME {&FRAME-NAME} = no
         v-log-mod-aereo:CHECKED           IN FRAME {&FRAME-NAME} = no
         v-log-phase-in:CHECKED            IN FRAME {&FRAME-NAME} = no
         v-log-phase-out:CHECKED           IN FRAME {&FRAME-NAME} = no
         v-num-dias-transf:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = ""
         v-cod-modelo:SCREEN-VALUE         IN FRAME {&FRAME-NAME} = ""
         v-qtd-min-comp:SCREEN-VALUE       IN FRAME {&FRAME-NAME} = ""
         v-qtd-min-fab:SCREEN-VALUE        IN FRAME {&FRAME-NAME} = ""
         v-qtd-max-comp:SCREEN-VALUE       IN FRAME {&FRAME-NAME} = ""
         v-qtd-max-fab:SCREEN-VALUE        IN FRAME {&FRAME-NAME} = ""
         v-num-dias-min:SCREEN-VALUE       IN FRAME {&FRAME-NAME} = ""
         v-num-dias-alvo:SCREEN-VALUE      IN FRAME {&FRAME-NAME} = ""
         v-num-dias-cob-mp:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = ""   
         v-num-dias-alvo-mp:SCREEN-VALUE   IN FRAME {&FRAME-NAME} = ""
         v-log-item-rest:CHECKED           IN FRAME {&FRAME-NAME} = no
         v-log-bloq-prod:checked           in frame {&frame-name} = no
         v-log-requer-aval:checked         in frame {&frame-name} = no
         v-num-dias-antec:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = "".

  IF AVAIL item-uni-estab THEN DO:
      FIND FIRST int-item-uni-estab
           WHERE int-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel
             AND int-item-uni-estab.it-codigo   = item-uni-estab.it-codigo NO-LOCK NO-ERROR.
      IF AVAIL int-item-uni-estab THEN DO:
          ASSIGN v-log-comp-spot:CHECKED           IN FRAME {&FRAME-NAME} = int-item-uni-estab.log-comp-spot
                 v-log-mod-aereo:CHECKED           IN FRAME {&FRAME-NAME} = int-item-uni-estab.log-mod-aereo
                 v-log-phase-in:CHECKED            IN FRAME {&FRAME-NAME} = int-item-uni-estab.log-phase-in 
                 v-log-phase-out:CHECKED           IN FRAME {&FRAME-NAME} = int-item-uni-estab.log-phase-out
                 v-num-dias-transf:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = STRING(int-item-uni-estab.num-dias-transf)
                 v-cod-modelo:SCREEN-VALUE         IN FRAME {&FRAME-NAME} = int-item-uni-estab.cod-modelo      
                 v-qtd-min-comp:SCREEN-VALUE       IN FRAME {&FRAME-NAME} = STRING(int-item-uni-estab.qtd-min-comp)    
                 v-qtd-min-fab:SCREEN-VALUE        IN FRAME {&FRAME-NAME} = STRING(int-item-uni-estab.qtd-min-fab)     
                 v-qtd-max-comp:SCREEN-VALUE       IN FRAME {&FRAME-NAME} = STRING(int-item-uni-estab.qtd-max-comp)    
                 v-qtd-max-fab:SCREEN-VALUE        IN FRAME {&FRAME-NAME} = STRING(int-item-uni-estab.qtd-max-fab)     
                 v-num-dias-min:SCREEN-VALUE       IN FRAME {&FRAME-NAME} = STRING(int-item-uni-estab.num-dias-min)    
                 v-num-dias-alvo:SCREEN-VALUE      IN FRAME {&FRAME-NAME} = STRING(int-item-uni-estab.num-dias-alvo)
                 v-num-dias-cob-mp:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = STRING(int-item-uni-estab.num-dias-cob-mp)    
                 v-num-dias-alvo-mp:SCREEN-VALUE   IN FRAME {&FRAME-NAME} = STRING(int-item-uni-estab.num-dias-alvo-mp)
                 v-log-item-rest:CHECKED           IN FRAME {&FRAME-NAME} = int-item-uni-estab.log-item-rest
                 v-log-bloq-prod:checked           in frame {&frame-name} = int-item-uni-estab.log-bloq-prod
                 v-log-requer-aval:checked         in frame {&frame-name} = int-item-uni-estab.log-requer-aval
                 v-num-dias-antec:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = STRING(int-item-uni-estab.num-dias-antec).
    
          APPLY "leave":U TO v-cod-modelo IN FRAME {&FRAME-NAME}.
          RUN dispatch IN THIS-PROCEDURE ( INPUT 'local-disable-fields':U ) .
      END.
  END.
  
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Code placed here will execute PRIOR to standard behavior. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */

    &if  defined(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif 
    
    IF v-log-phase-in:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "no" THEN
        ENABLE v-log-phase-out WITH FRAME {&FRAME-NAME}.
    ELSE 
        DISABLE v-log-phase-out WITH FRAME {&FRAME-NAME}.

    IF v-log-phase-out:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "no" THEN
        ENABLE v-log-phase-in WITH FRAME {&FRAME-NAME}.
    ELSE 
        DISABLE v-log-phase-in WITH FRAME {&FRAME-NAME}.

    if can-find(first int-modelo where
                      int-modelo.cod-modelo = input frame {&frame-name} v-cod-modelo
                  and int-modelo.log-aps
                      no-lock)
    then do:
        ENABLE v-qtd-min-comp
               v-qtd-min-fab 
               v-num-dias-cob-mp
               v-num-dias-alvo-mp WITH FRAME {&FRAME-NAME}.
    end.
    else do:
        DISABLE v-qtd-min-comp
                v-qtd-min-fab 
                v-num-dias-cob-mp
                v-num-dias-alvo-mp WITH FRAME {&FRAME-NAME}.
    end.
    
    ENABLE v-log-comp-spot   
           v-log-mod-aereo   
           v-num-dias-transf
           v-cod-modelo
           v-qtd-max-comp
           v-qtd-max-fab
           v-num-dias-min
           v-num-dias-alvo
           v-num-dias-antec
           v-log-item-rest
           v-log-bloq-prod
           v-log-requer-aval
           WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
    
    RUN who-is-the-container IN adm-broker-hdl (INPUT this-procedure,
                                                OUTPUT c-handle).
    ASSIGN h-window = WIDGET-HANDLE(c-handle).

    v-cod-modelo:LOAD-MOUSE-POINTER ("image\lupa.cur") IN FRAME {&FRAME-NAME}.

    /* Dispatch standard ADM method.                             */

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    disable v-log-comp-spot   
            v-log-mod-aereo      
            v-log-phase-in
            v-log-phase-out
            v-num-dias-transf
            v-cod-modelo
            des-modelo
            v-qtd-min-comp
            v-qtd-min-fab
            v-qtd-max-comp
            v-qtd-max-fab
            v-num-dias-min
            v-num-dias-alvo 
            v-num-dias-cob-mp
            v-num-dias-alvo-mp 
            v-num-dias-antec
            v-log-item-rest
            v-log-bloq-prod
            v-log-requer-aval with frame {&FRAME-NAME}.
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter v-row-parent-externo as rowid no-undo.
    
    assign v-row-parent = v-row-parent-externo.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

    apply 'leave' to v-cod-modelo in frame {&frame-name}.

    IF  input frame {&frame-name} v-cod-modelo <> ""
    and not can-find(first int-modelo where
                          int-modelo.cod-modelo = input frame {&frame-name} v-cod-modelo
                          no-lock) THEN DO:
         run utp/ut-msgs.p (input "show":U, input 17567, input "Modelo n∆o cadastrado!").
         apply 'entry' to v-cod-modelo in frame {&frame-name}.
         return 'ADM-ERROR':U.
    END.

    IF not can-find(first int-modelo where
                          int-modelo.cod-modelo = input frame {&frame-name} v-cod-modelo
                      and int-modelo.log-aps
                          no-lock) THEN DO:
        IF v-qtd-min-comp:SCREEN-VALUE     <> "0,00" OR 
           v-qtd-min-fab:SCREEN-VALUE      <> "0,00" OR 
           v-num-dias-cob-mp:SCREEN-VALUE  <> "0"    OR 
           v-num-dias-alvo-mp:SCREEN-VALUE <> "0"    THEN DO:

            MESSAGE "Modelo n∆o Ç CKD/SKD. Os campos " SKIP(1) 
                    " - Qtd Minima Compras CKD/SKD " SKIP
                    " - Qtd Minima Fabricaá∆o CKD/SKD " SKIP
                    " - Dias Cobertura Minima MP Kit CKD/SKD " SKIP
                    " - Dias Cobertura MP Kit CKD/SKD " SKIP(1)
                    "ser∆o zerados."
                VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

            IF  AVAIL item-uni-estab THEN DO:
                FOR FIRST int-item-uni-estab 
                    WHERE int-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel
                      AND int-item-uni-estab.it-codigo   = item-uni-estab.it-codigo EXCLUSIVE-LOCK:
        
                    ASSIGN int-item-uni-estab.qtd-min-comp     = 0
                           int-item-uni-estab.qtd-min-fab      = 0
                           int-item-uni-estab.num-dias-cob-mp  = 0
                           int-item-uni-estab.num-dias-alvo-mp = 0.

                END.
            END.

            ASSIGN v-qtd-min-comp:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = ""
                   v-qtd-min-fab:SCREEN-VALUE      IN FRAME {&FRAME-NAME} = ""
                   v-num-dias-cob-mp:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = ""   
                   v-num-dias-alvo-mp:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "item-uni-estab"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).

  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

