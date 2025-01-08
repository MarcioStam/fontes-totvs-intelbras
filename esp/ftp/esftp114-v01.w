&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          emscad             PROGRESS
          emsmov             PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt_cta_ctbl_disp NO-UNDO LIKE cta_ctbl
       index id-conta cod_cta_ctbl.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i V99XX999 9.99.99.999}

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
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

DEFINE VARIABLE wh-imprime       AS HANDLE      NO-UNDO.
DEFINE VARIABLE v_des_tit_ctbl   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_num_linhas_sel AS INTEGER     NO-UNDO.

DEF BUFFER b_int_agrupa_movto_cta_gesplan FOR int_agrupa_movto_cta_gesplan.
DEF BUFFER b_cta_ctbl                     FOR cta_ctbl.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main
&Scoped-define BROWSE-NAME br-cta-agrup

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES int_agrupa_movto_cta_gesplan ~
tt_cta_ctbl_disp

/* Definitions for BROWSE br-cta-agrup                                  */
&Scoped-define FIELDS-IN-QUERY-br-cta-agrup ~
int_agrupa_movto_cta_gesplan.cod_cta_ctbl fn-titulo-ctbl() @ v_des_tit_ctbl 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-cta-agrup 
&Scoped-define QUERY-STRING-br-cta-agrup FOR EACH int_agrupa_movto_cta_gesplan NO-LOCK
&Scoped-define OPEN-QUERY-br-cta-agrup OPEN QUERY br-cta-agrup FOR EACH int_agrupa_movto_cta_gesplan NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br-cta-agrup int_agrupa_movto_cta_gesplan
&Scoped-define FIRST-TABLE-IN-QUERY-br-cta-agrup int_agrupa_movto_cta_gesplan


/* Definitions for BROWSE br-cta-disp                                   */
&Scoped-define FIELDS-IN-QUERY-br-cta-disp tt_cta_ctbl_disp.cod_cta_ctbl ~
tt_cta_ctbl_disp.des_tit_ctbl 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-cta-disp 
&Scoped-define QUERY-STRING-br-cta-disp FOR EACH tt_cta_ctbl_disp NO-LOCK
&Scoped-define OPEN-QUERY-br-cta-disp OPEN QUERY br-cta-disp FOR EACH tt_cta_ctbl_disp NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br-cta-disp tt_cta_ctbl_disp
&Scoped-define FIRST-TABLE-IN-QUERY-br-cta-disp tt_cta_ctbl_disp


/* Definitions for FRAME f-main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-main ~
    ~{&OPEN-QUERY-br-cta-agrup}~
    ~{&OPEN-QUERY-br-cta-disp}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-mold IMAGE-1 IMAGE-2 br-cta-disp ~
br-cta-agrup bt-add bt-del c-cta-disp-ini c-cta-disp-fim bt-fil 
&Scoped-Define DISPLAYED-OBJECTS c-cta-disp-ini c-cta-disp-fim 

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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-titulo-ctbl V-table-Win 
FUNCTION fn-titulo-ctbl RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-br-cta-disp 
       MENU-ITEM m_Todos        LABEL "Todos"         .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-add 
     IMAGE-UP FILE "adeicon\next-au":U
     IMAGE-INSENSITIVE FILE "adeicon\next-ai":U
     LABEL "Incluir" 
     SIZE 5 BY 1 TOOLTIP "Incluir".

DEFINE BUTTON bt-del 
     IMAGE-UP FILE "adeicon\prev-au":U
     IMAGE-INSENSITIVE FILE "adeicon\prev-ai":U
     LABEL "Eliminar" 
     SIZE 5 BY 1 TOOLTIP "Eliminar".

DEFINE BUTTON bt-fil 
     IMAGE-UP FILE "image/im-enter.bmp":U
     LABEL "Filtrar Contas Dispon¡veis" 
     SIZE 5 BY 1 TOOLTIP "Filtrar Contas Dispon¡veis".

DEFINE VARIABLE c-cta-disp-fim AS CHARACTER FORMAT "X(20)":U INITIAL "49999999" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE c-cta-disp-ini AS CHARACTER FORMAT "X(20)":U INITIAL "40000000" 
     LABEL "Conta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY 1.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY 1.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 104 BY 19.25.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-cta-agrup FOR 
      int_agrupa_movto_cta_gesplan SCROLLING.

DEFINE QUERY br-cta-disp FOR 
      tt_cta_ctbl_disp SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-cta-agrup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-cta-agrup V-table-Win _STRUCTURED
  QUERY br-cta-agrup NO-LOCK DISPLAY
      int_agrupa_movto_cta_gesplan.cod_cta_ctbl COLUMN-LABEL "Conta Cont bil"
            WIDTH 13.43
      fn-titulo-ctbl() @ v_des_tit_ctbl COLUMN-LABEL "T¡tulo Cont bil" FORMAT "x(40)":U
            WIDTH 29.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 47 BY 17.25
         FONT 1
         TITLE "Contas Integram Sem Detalhamento" FIT-LAST-COLUMN.

DEFINE BROWSE br-cta-disp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-cta-disp V-table-Win _STRUCTURED
  QUERY br-cta-disp NO-LOCK DISPLAY
      tt_cta_ctbl_disp.cod_cta_ctbl FORMAT "x(20)":U WIDTH 14.43
      tt_cta_ctbl_disp.des_tit_ctbl FORMAT "x(40)":U WIDTH 30.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 49 BY 17.25
         FONT 1
         TITLE "Contas Dispon¡veis" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     br-cta-disp AT ROW 1.75 COL 3 WIDGET-ID 400
     br-cta-agrup AT ROW 1.75 COL 58 WIDGET-ID 300
     bt-add AT ROW 8.75 COL 52.57 WIDGET-ID 8
     bt-del AT ROW 10.38 COL 52.57 WIDGET-ID 10
     c-cta-disp-ini AT ROW 19.25 COL 6 COLON-ALIGNED WIDGET-ID 2
     c-cta-disp-fim AT ROW 19.25 COL 27.29 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     bt-fil AT ROW 19.25 COL 43.43 WIDGET-ID 6
     rt-mold AT ROW 1.25 COL 2
     IMAGE-1 AT ROW 19.33 COL 22.14 WIDGET-ID 12
     IMAGE-2 AT ROW 19.33 COL 26.14 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
   Temp-Tables and Buffers:
      TABLE: tt_cta_ctbl_disp T "?" NO-UNDO ems5 cta_ctbl
      ADDITIONAL-FIELDS:
          index id-conta cod_cta_ctbl
      END-FIELDS.
   END-TABLES.
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
         HEIGHT             = 19.5
         WIDTH              = 105.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}
{include/i_dbtype.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br-cta-disp IMAGE-2 f-main */
/* BROWSE-TAB br-cta-agrup br-cta-disp f-main */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

ASSIGN 
       br-cta-disp:POPUP-MENU IN FRAME f-main             = MENU POPUP-MENU-br-cta-disp:HANDLE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-cta-agrup
/* Query rebuild information for BROWSE br-cta-agrup
     _TblList          = "int_agrupa_movto_cta_gesplan"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > "_<CALC>"
"int_agrupa_movto_cta_gesplan.cod_cta_ctbl" "Conta Cont bil" ? "character" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fn-titulo-ctbl() @ v_des_tit_ctbl" "T¡tulo Cont bil" "x(40)" ? ? ? ? ? ? ? no ? no no "29.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-cta-agrup */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-cta-disp
/* Query rebuild information for BROWSE br-cta-disp
     _TblList          = "Temp-Tables.tt_cta_ctbl_disp"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.tt_cta_ctbl_disp.cod_cta_ctbl
"tt_cta_ctbl_disp.cod_cta_ctbl" ? ? "character" ? ? ? ? ? ? no ? no no "14.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt_cta_ctbl_disp.des_tit_ctbl
"tt_cta_ctbl_disp.des_tit_ctbl" ? ? "character" ? ? ? ? ? ? no ? no no "30.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-cta-disp */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br-cta-agrup
&Scoped-define SELF-NAME br-cta-agrup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-cta-agrup V-table-Win
ON MOUSE-SELECT-DBLCLICK OF br-cta-agrup IN FRAME f-main /* Contas Integram Sem Detalhamento */
DO:
    APPLY "choose" TO bt-del IN FRAME {&FRAME-NAME}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-cta-disp
&Scoped-define SELF-NAME br-cta-disp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-cta-disp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF br-cta-disp IN FRAME f-main /* Contas Dispon¡veis */
DO:
    APPLY "choose" TO bt-add IN FRAME {&FRAME-NAME}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-add V-table-Win
ON CHOOSE OF bt-add IN FRAME f-main /* Incluir */
DO:
    IF  SESSION:SET-WAIT-STATE("general") THEN.

    DO  v_num_linhas_sel = 1 TO br-cta-disp:NUM-SELECTED-ROWS:
        br-cta-disp:FETCH-SELECTED-ROW(v_num_linhas_sel).

        CREATE int_agrupa_movto_cta_gesplan.
        ASSIGN int_agrupa_movto_cta_gesplan.cod_cta_ctbl = tt_cta_ctbl_disp.cod_cta_ctbl.
    END.

    OPEN QUERY br-cta-agrup FOR EACH int_agrupa_movto_cta_gesplan NO-LOCK.

    APPLY "choose" TO bt-fil IN FRAME {&FRAME-NAME}.

    IF  SESSION:SET-WAIT-STATE("") THEN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-del V-table-Win
ON CHOOSE OF bt-del IN FRAME f-main /* Eliminar */
DO:
    IF  SESSION:SET-WAIT-STATE("general") THEN.

    DO  v_num_linhas_sel = 1 TO br-cta-agrup:NUM-SELECTED-ROWS:
        br-cta-agrup:FETCH-SELECTED-ROW(v_num_linhas_sel).

        FIND CURRENT int_agrupa_movto_cta_gesplan EXCLUSIVE-LOCK.
        DELETE int_agrupa_movto_cta_gesplan.
    END.

    OPEN QUERY br-cta-agrup FOR EACH int_agrupa_movto_cta_gesplan NO-LOCK.

    APPLY "choose" TO bt-fil IN FRAME {&FRAME-NAME}.

    IF  SESSION:SET-WAIT-STATE("") THEN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-fil
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-fil V-table-Win
ON CHOOSE OF bt-fil IN FRAME f-main /* Filtrar Contas Dispon¡veis */
DO:
    ASSIGN c-cta-disp-ini = INPUT FRAME {&FRAME-NAME} c-cta-disp-ini
           c-cta-disp-fim = INPUT FRAME {&FRAME-NAME} c-cta-disp-fim.

    IF  SESSION:SET-WAIT-STATE("general") THEN.

    EMPTY TEMP-TABLE tt_cta_ctbl_disp.

    FOR EACH  cta_ctbl NO-LOCK
        WHERE cta_ctbl.cod_plano_cta_ctbl  = "PADRAO"
          AND cta_ctbl.cod_cta_ctbl       >= c-cta-disp-ini
          AND cta_ctbl.cod_cta_ctbl       <= c-cta-disp-fim:

        IF  CAN-FIND (FIRST b_int_agrupa_movto_cta_gesplan NO-LOCK
                           WHERE b_int_agrupa_movto_cta_gesplan.cod_cta_ctbl = cta_ctbl.cod_cta_ctbl)
        THEN
            NEXT.

        FIND FIRST tt_cta_ctbl_disp NO-LOCK
            WHERE  tt_cta_ctbl_disp.cod_cta_ctbl = cta_ctbl.cod_cta_ctbl NO-ERROR.

        IF  NOT AVAIL tt_cta_ctbl_disp
        THEN DO:
            CREATE tt_cta_ctbl_disp.
            ASSIGN tt_cta_ctbl_disp.cod_cta_ctbl = cta_ctbl.cod_cta_ctbl
                   tt_cta_ctbl_disp.des_tit_ctbl = cta_ctbl.des_tit_ctbl.
        END.
    END.

    OPEN QUERY br-cta-disp FOR EACH tt_cta_ctbl_disp NO-LOCK.

    IF  SESSION:SET-WAIT-STATE("") THEN.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Todos V-table-Win
ON CHOOSE OF MENU-ITEM m_Todos /* Todos */
DO:
    br-cta-disp:SELECT-ALL() IN FRAME {&FRAME-NAME}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-cta-agrup
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/
    DISPLAY c-cta-disp-ini
            c-cta-disp-fim
            WITH FRAME {&FRAME-NAME}.

    APPLY "choose" TO bt-fil IN FRAME {&FRAME-NAME}.
    OPEN QUERY br-cta-agrup FOR EACH int_agrupa_movto_cta_gesplan NO-LOCK.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}
    
    /*:T Ponha na pi-validate todas as valida‡äes */
    /*:T NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /*:T Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*:T------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /*:T Valida‡Æo de dicion rio */
    
/*:T    Segue um exemplo de valida‡Æo de programa */
/*       find tabela where tabela.campo1 = c-variavel and               */
/*                         tabela.campo2 > i-variavel no-lock no-error. */
      
      /*:T Este include deve ser colocado sempre antes do ut-msgs.p */
/*       {include/i-vldprg.i}                                             */
/*       run utp/ut-msgs.p (input "show":U, input 7, input return-value). */
/*       return 'ADM-ERROR':U.                                            */

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
  {src/adm/template/snd-list.i "tt_cta_ctbl_disp"}
  {src/adm/template/snd-list.i "int_agrupa_movto_cta_gesplan"}

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-titulo-ctbl V-table-Win 
FUNCTION fn-titulo-ctbl RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FOR FIRST b_cta_ctbl NO-LOCK
        WHERE b_cta_ctbl.cod_plano_cta_ctbl = "PADRAO"
          AND b_cta_ctbl.cod_cta_ctbl       = int_agrupa_movto_cta_gesplan.cod_cta_ctbl:
        RETURN b_cta_ctbl.des_tit_ctbl.
    END.

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

