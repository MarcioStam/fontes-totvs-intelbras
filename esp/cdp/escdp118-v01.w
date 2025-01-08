&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCDP118-V01 1.00.00.001}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */
/*                                                                                */
/* OBS: Para os smartobjects o parametro m¢dulo dever† ser MUT                    */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ESCDP118-V01 ESP}
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
def var v-row-parent as rowid         no-undo.
def var h-container  as widget-handle no-undo.
def var h-escdp118b  as handle        no-undo.
def var c-aux        as char          no-undo.
def var c-equipto    as char          no-undo.
def var c-mensagem   as char          no-undo.

def var dt-corte as date init 12/5/2022 no-undo.

def buffer b_bem_pat           for bem_pat.
def buffer b_int_bem_pat       for int_bem_pat.
def buffer b_int_param_cta_uep for int_param_cta_uep.

def new global shared var gr_int_bem_pat     as rowid     no-undo.
def new global shared var v_cod_empres_usuar as character no-undo.

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
&Scoped-define EXTERNAL-TABLES int_bem_pat
&Scoped-define FIRST-EXTERNAL-TABLE int_bem_pat


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR int_bem_pat.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS int_bem_pat.hr_manut int_bem_pat.potencia ~
int_bem_pat.molde int_bem_pat.equipamento 
&Scoped-define ENABLED-TABLES int_bem_pat
&Scoped-define FIRST-ENABLED-TABLE int_bem_pat
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS int_bem_pat.num_bem_pat ~
int_bem_pat.num_seq_bem_pat int_bem_pat.cod_cta_pat int_bem_pat.hr_manut ~
int_bem_pat.potencia int_bem_pat.molde int_bem_pat.equipamento 
&Scoped-define DISPLAYED-TABLES int_bem_pat
&Scoped-define FIRST-DISPLAYED-TABLE int_bem_pat
&Scoped-Define DISPLAYED-OBJECTS fi_cod_estab fi_cod_plano_ccusto ~
fi_des_bem_pat fi_nom_pessoa fi_des_cta_pat fi_cod_ccusto_respons ~
fi-des-ferr-prod fi_dat_aquis_bem_pat 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS int_bem_pat.num_bem_pat ~
int_bem_pat.num_seq_bem_pat int_bem_pat.cod_cta_pat 

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
DEFINE VARIABLE fi-des-ferr-prod AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 31.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi_cod_ccusto_respons AS CHARACTER FORMAT "x(11)" 
     LABEL "CCusto Responsab" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi_cod_estab AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fi_cod_plano_ccusto AS CHARACTER FORMAT "x(8)" 
     LABEL "Plano CCusto" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE fi_dat_aquis_bem_pat AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Aquisiá∆o" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fi_des_bem_pat AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE fi_des_cta_pat AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE fi_nom_pessoa AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 3.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 4.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     int_bem_pat.num_bem_pat AT ROW 1.17 COL 13.57 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     int_bem_pat.num_seq_bem_pat AT ROW 2.17 COL 13.57 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     int_bem_pat.cod_cta_pat AT ROW 3.17 COL 13.57 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 19 BY .88
     fi_cod_estab AT ROW 4.67 COL 13.57 COLON-ALIGNED WIDGET-ID 18
     fi_cod_plano_ccusto AT ROW 5.67 COL 13.57 COLON-ALIGNED HELP
          "C¢digo Plano Centros Custo" WIDGET-ID 26
     int_bem_pat.hr_manut AT ROW 6.67 COL 13.57 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 13.72 BY .88
     int_bem_pat.potencia AT ROW 7.67 COL 13.57 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 13.72 BY .88
     fi_des_bem_pat AT ROW 2.17 COL 19.86 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     fi_nom_pessoa AT ROW 4.67 COL 19.86 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     fi_des_cta_pat AT ROW 3.17 COL 32.86 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     fi_cod_ccusto_respons AT ROW 5.67 COL 37.86 COLON-ALIGNED HELP
          "C¢digo Centro Custo Responsabilidade" WIDGET-ID 28
     int_bem_pat.molde AT ROW 6.67 COL 39.86 WIDGET-ID 24
          VIEW-AS TOGGLE-BOX
          SIZE 9 BY .88
     int_bem_pat.equipamento AT ROW 7.67 COL 37.86 COLON-ALIGNED WIDGET-ID 32
          LABEL "Equipto"
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     fi-des-ferr-prod AT ROW 7.67 COL 54.14 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     fi_dat_aquis_bem_pat AT ROW 4.67 COL 75 COLON-ALIGNED WIDGET-ID 30
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 4.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgesp.int_bem_pat
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
         HEIGHT             = 7.83
         WIDTH              = 88.57.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R,COLUMNS                    */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN int_bem_pat.cod_cta_pat IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN int_bem_pat.equipamento IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN fi-des-ferr-prod IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi_cod_ccusto_respons IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi_cod_estab IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi_cod_plano_ccusto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi_dat_aquis_bem_pat IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi_des_bem_pat IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi_des_cta_pat IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi_nom_pessoa IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int_bem_pat.num_bem_pat IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN int_bem_pat.num_seq_bem_pat IN FRAME f-main
   NO-ENABLE 1                                                          */
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

&Scoped-define SELF-NAME int_bem_pat.cod_cta_pat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_bem_pat.cod_cta_pat V-table-Win
ON LEAVE OF int_bem_pat.cod_cta_pat IN FRAME f-main /* Conta Patrimonial */
DO:
    assign fi_des_cta_pat:screen-value in frame {&frame-name} = "".

    run pi-leave.

    for first cta_pat no-lock
        where cta_pat.cod_empresa = v_cod_empres_usuar
          and cta_pat.cod_cta_pat = input frame {&frame-name} int_bem_pat.cod_cta_pat:
        assign fi_des_cta_pat:screen-value in frame {&frame-name} = cta_pat.des_cta_pat.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME int_bem_pat.equipamento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_bem_pat.equipamento V-table-Win
ON F5 OF int_bem_pat.equipamento IN FRAME f-main /* Equipto */
DO:
  {include/zoomvar.i &prog-zoom  = inzoom/z01in465.w
                     &campo      = int_bem_pat.equipamento
                     &campozoom  = cod-ferr-prod
                     &campo2     = fi-des-ferr-prod
                     &campozoom2 = des-ferr-prod}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_bem_pat.equipamento V-table-Win
ON LEAVE OF int_bem_pat.equipamento IN FRAME f-main /* Equipto */
DO:
     {include/leave.i &tabela=ferr-prod
                      &atributo-ref=des-ferr-prod
                      &variavel-ref=fi-des-ferr-prod
                      &where="ferr-prod.cod-ferr-prod = input frame {&frame-name} int_bem_pat.equipamento"}                         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_bem_pat.equipamento V-table-Win
ON MOUSE-SELECT-DBLCLICK OF int_bem_pat.equipamento IN FRAME f-main /* Equipto */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi_cod_estab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi_cod_estab V-table-Win
ON LEAVE OF fi_cod_estab IN FRAME f-main /* Estabelecimento */
DO:
     {include/leave.i &tabela=estabelecimento
                      &atributo-ref=nom_pessoa
                      &variavel-ref=fi_nom_pessoa
                      &where="estabelecimento.cod_estab = input frame {&frame-name} fi_cod_estab"}
                      
    if int_bem_pat.molde:sensitive in frame {&frame-name}
    then apply 'value-changed' to int_bem_pat.molde in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME int_bem_pat.molde
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_bem_pat.molde V-table-Win
ON VALUE-CHANGED OF int_bem_pat.molde IN FRAME f-main /* Molde */
DO:
  apply 'leave' to int_bem_pat.cod_cta_pat in frame {&frame-name}.

  assign fi-des-ferr-prod:screen-value     in frame {&frame-name} = ""
         int_bem_pat.equipamento:sensitive in frame {&frame-name} = self:checked.

  if not self:checked
  then do:
       assign c-aux                                                       = input frame {&frame-name} int_bem_pat.equipamento
              int_bem_pat.equipamento:screen-value in frame {&frame-name} = "".

       return no-apply.
  end.

  assign int_bem_pat.equipamento:sensitive in frame {&frame-name} = input frame {&frame-name} fi_dat_aquis_bem_pat <> ? and 
                                                                    input frame {&frame-name} fi_dat_aquis_bem_pat  < dt-corte.

  if int_bem_pat.equipamento:sensitive in frame {&frame-name}
  then do:
       assign int_bem_pat.equipamento:screen-value in frame {&frame-name} = c-aux.
       apply 'leave' to int_bem_pat.equipamento in frame {&frame-name}.
       return no-apply.
  end.

  if  avail b_bem_pat
  and b_bem_pat.num_bem_pat     < 1000000
  and b_bem_pat.num_seq_bem_pat < 1000
  then assign int_bem_pat.equipamento:screen-value in frame {&frame-name} = string(b_bem_pat.num_bem_pat,"999999")
                                                                          + "-"
                                                                          + string(b_bem_pat.num_seq_bem_pat,"999")
              fi-des-ferr-prod:screen-value        in frame {&frame-name} = b_bem_pat.des_bem_pat.
  else assign int_bem_pat.equipamento:screen-value in frame {&frame-name} = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME int_bem_pat.num_bem_pat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_bem_pat.num_bem_pat V-table-Win
ON F5 OF int_bem_pat.num_bem_pat IN FRAME f-main /* Bem Patrimonial */
DO:
   assign fi_des_bem_pat:screen-value        in frame {&frame-name} = ""
          fi_des_cta_pat:screen-value        in frame {&frame-name} = ""
          fi_cod_estab:screen-value          in frame {&frame-name} = ""
          fi_nom_pessoa:screen-value         in frame {&frame-name} = ""
          fi_cod_plano_ccusto:screen-value   in frame {&frame-name} = ""
          fi_cod_ccusto_respons:screen-value in frame {&frame-name} = ""
          fi_dat_aquis_bem_pat:screen-value  in frame {&frame-name} = "".

  {include/zoomvar.i &prog-zoom  = esp/cdp/escdp118-z01.w
                     &campo      = int_bem_pat.num_bem_pat
                     &campozoom  = num_bem_pat
                     &campo2     = int_bem_pat.num_seq_bem_pat
                     &campozoom2 = num_seq_bem_pat
                     &campo3     = int_bem_pat.cod_cta_pat
                     &campozoom3 = cod_cta_pat
                     &campo4     = fi_des_bem_pat
                     &campozoom4 = des_bem_pat
                     &campo5     = fi_cod_estab
                     &campozoom5 = cod_estab
                     &campo6     = fi_cod_plano_ccusto
                     &campozoom6 = cod_plano_ccusto
                     &campo7     = fi_cod_ccusto_respons
                     &campozoom7 = cod_ccusto_respons
                     &campo8     = fi_dat_aquis_bem_pat
                     &campozoom8 = dat_aquis_bem_pat}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_bem_pat.num_bem_pat V-table-Win
ON LEAVE OF int_bem_pat.num_bem_pat IN FRAME f-main /* Bem Patrimonial */
DO:
    run pi-leave.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_bem_pat.num_bem_pat V-table-Win
ON MOUSE-SELECT-DBLCLICK OF int_bem_pat.num_bem_pat IN FRAME f-main /* Bem Patrimonial */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME int_bem_pat.num_seq_bem_pat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int_bem_pat.num_seq_bem_pat V-table-Win
ON LEAVE OF int_bem_pat.num_seq_bem_pat IN FRAME f-main /* Sequància Bem */
DO:
    run pi-leave.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  int_bem_pat.num_bem_pat:load-mouse-pointer("image/lupa.cur") in frame {&frame-name}.
  int_bem_pat.equipamento:load-mouse-pointer("image/lupa.cur") in frame {&frame-name}.
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
  {src/adm/template/row-list.i "int_bem_pat"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "int_bem_pat"}

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
    def var lg-ferram as logi no-undo.
    def var p-mes-pad as logi no-undo.
   //def var p-mes-esp as logi no-undo.
    def var c-retorno as char no-undo.

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}

    /*:T Ponha na pi-validate todas as validaá‰es */
    /*:T N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    run pi-validate.
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    /* Dispatch standard ADM method.                             */
    do transaction:
        RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
        if RETURN-VALUE = 'ADM-ERROR':U then 
            return 'ADM-ERROR':U.
        
        /*:T Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
        /* Code placed here will execute AFTER standard behavior.    */
        assign int_bem_pat.cod_empresa    = b_bem_pat.cod_empresa
               int_bem_pat.num_id_bem_pat = b_bem_pat.num_id_bem_pat.

        if  int_bem_pat.molde
        and b_bem_pat.dat_aquis_bem_pat >= dt-corte
        and not can-find(first ferr-prod where
                               ferr-prod.cod-ferr-prod = input frame {&frame-name} int_bem_pat.equipamento
                               no-lock)
        then do:
             run esp/cdp/escdp118b.p persistent set h-escdp118b.
             run pi-executa in h-escdp118b (input  input frame {&frame-name} int_bem_pat.equipamento,
                                            input  b_bem_pat.des_bem_pat,
                                            output p-mes-pad /*,
                                            output p-mes-esp*/ ).

             if return-value <> "OK":U
             then do:
                  run utp/ut-msgs.p (input "show", input 17567, input "Erro integraá∆o MES Padr∆o. Cadastro equipto n∆o pode ser realizado").
                  undo, return 'ADM-ERROR':U.
             end.

             assign lg-ferram = yes.
        end.
    end. /* do transaction */

    if lg-ferram
    then do:
         assign c-retorno = "Equipto " + input frame {&frame-name} int_bem_pat.equipamento + " cadastrado".

        /*if  not p-mes-pad
         and not p-mes-esp
         then assign c-retorno = c-retorno 
                               + ", porÇm, com pendància na integraá∆o MES padr∆o e com erro na espec°fica".
         else*/ if not p-mes-pad
              then assign c-retorno = c-retorno
                                    + ", porÇm, com pendància na integraá∆o MES (padr∆o)".
/*               else if not p-mes-esp                                                            */
/*                    then assign c-retorno = c-retorno                                           */
/*                                          + ", porÇm, com erro na integraá∆o MES (espec°fica)". */
             
             
         run utp/ut-msgs.p (input "show", input 19085, input c-retorno).
    end. /* if lg-ferram */

    finally:
        release b_bem_pat.

        if valid-handle(h-escdp118b)
        then do:
             run pi-finaliza in h-escdp118b.
             delete procedure h-escdp118b no-error.
        end. /* if valid-handle(h-escdp118b) */
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  release b_bem_pat.

  if int_bem_pat.molde
  then for first b_bem_pat
           where b_bem_pat.cod_empresa     = int_bem_pat.cod_empresa
             and b_bem_pat.cod_cta_pat     = int_bem_pat.cod_cta_pat
             and b_bem_pat.num_bem_pat     = int_bem_pat.num_bem_pat
             and b_bem_pat.num_seq_bem_pat = int_bem_pat.num_seq_bem_pat
                 no-lock: end.

  if  avail b_bem_pat
  and b_bem_pat.dat_aquis_bem_pat >= dt-corte
  and can-find(first ferr-prod where
                     ferr-prod.cod-ferr-prod = int_bem_pat.equipamento
                     no-lock)
  then do:
       run utp/ut-msgs.p (input "show":U, input 17567, input "Eliminaá∆o impossibilitada, pois h† Ferramenta vinculada ao Bem via Equipamento (CD0124)!").
       return 'ADM-ERROR':U.
  end.
  
  for each int_bem_pat_gm exclusive-lock
     where int_bem_pat_gm.num_id_bem_pat = int_bem_pat.num_id_bem_pat:
      delete int_bem_pat_gm.
  end.

  if avail b_bem_pat
  then for each int_bem_pat_gm exclusive-lock
          where int_bem_pat_gm.num_id_bem_pat = b_bem_pat.num_id_bem_pat:
           delete int_bem_pat_gm.
       end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  finally:
      release b_bem_pat.
  end.

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
    
    if not valid-handle(h-container)
    then run pi-busca-pai.
    
    if  valid-handle(h-container)
/*     and avail int_bem_pat                                                             */
/*     and not can-find(first int_bem_pat_gm where                                       */
/*                            int_bem_pat_gm.num_id_bem_pat = int_bem_pat.num_id_bem_pat */
/*                            no-lock)                                                   */
    then run pi-controle in h-container (input "disable",
                                         input adm-new-record).
    
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
    
    /* Code placed here will execute AFTER standard behavior.    */
    release bem_pat.

    if avail int_bem_pat
    then do:
         assign gr_int_bem_pat = rowid(int_bem_pat).

         for first bem_pat
             where bem_pat.num_id_bem_pat = int_bem_pat.num_id_bem_pat
                   no-lock: end.
    end.

    assign fi_cod_estab:screen-value          in frame {&frame-name} = ""
           fi_cod_plano_ccusto:screen-value   in frame {&frame-name} = ""
           fi_cod_ccusto_respons:screen-value in frame {&frame-name} = ""
           fi_dat_aquis_bem_pat:screen-value  in frame {&frame-name} = ""
           c-aux                                                     = input frame {&frame-name} int_bem_pat.equipamento.

    if avail bem_pat
    then assign fi_cod_estab:screen-value          in frame {&frame-name} = bem_pat.cod_estab
                fi_cod_plano_ccusto:screen-value   in frame {&frame-name} = bem_pat.cod_plano_ccusto
                fi_cod_ccusto_respons:screen-value in frame {&frame-name} = bem_pat.cod_ccusto_respons
                fi_dat_aquis_bem_pat:screen-value  in frame {&frame-name} = string(bem_pat.dat_aquis_bem_pat).

    apply 'leave' to int_bem_pat.cod_cta_pat in frame {&frame-name}.
    apply 'leave' to fi_cod_estab            in frame {&frame-name}.
    apply 'leave' to int_bem_pat.equipamento in frame {&frame-name}.
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
/*     if adm-new-record = yes then */
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    if not valid-handle(h-container)
    then run pi-busca-pai.
    
    if valid-handle(h-container)
    then run pi-controle in h-container (input "enable",
                                         input adm-new-record).

    if adm-new-record
    then assign c-aux = "".

    if  not adm-new-record
    and can-find (first int_bem_pat_gm where
                        int_bem_pat_gm.num_id_bem_pat = int_bem_pat.num_id_bem_pat
                        no-lock)
    then assign int_bem_pat.molde:sensitive in frame {&frame-name} = no.

    apply 'value-changed' to int_bem_pat.molde in frame {&frame-name}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-pai V-table-Win 
PROCEDURE pi-busca-pai :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var c-container as char no-undo.

run who-is-the-container in adm-broker-hdl(input this-procedure,
                                           output c-container).

assign h-container = widget-handle(c-container).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leave V-table-Win 
PROCEDURE pi-leave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
assign fi_des_bem_pat:screen-value        in frame {&frame-name} = ""
       fi_cod_estab:screen-value          in frame {&frame-name} = ""
       fi_cod_plano_ccusto:screen-value   in frame {&frame-name} = ""
       fi_cod_ccusto_respons:screen-value in frame {&frame-name} = ""
       fi_dat_aquis_bem_pat:screen-value  in frame {&frame-name} = "".

for first b_bem_pat
    where b_bem_pat.cod_empresa     = v_cod_empres_usuar
      and b_bem_pat.cod_cta_pat     = input frame {&frame-name} int_bem_pat.cod_cta_pat
      and b_bem_pat.num_bem_pat     = input frame {&frame-name} int_bem_pat.num_bem_pat
      and b_bem_pat.num_seq_bem_pat = input frame {&frame-name} int_bem_pat.num_seq_bem_pat
          no-lock: end.

if avail b_bem_pat
then assign fi_des_bem_pat:screen-value        in frame {&frame-name} = b_bem_pat.des_bem_pat
            fi_cod_estab:screen-value          in frame {&frame-name} = b_bem_pat.cod_estab
            fi_cod_plano_ccusto:screen-value   in frame {&frame-name} = b_bem_pat.cod_plano_ccusto
            fi_cod_ccusto_respons:screen-value in frame {&frame-name} = b_bem_pat.cod_ccusto_respons
            fi_dat_aquis_bem_pat:screen-value  in frame {&frame-name} = string(b_bem_pat.dat_aquis_bem_pat).

apply 'leave' to fi_cod_estab in frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*:T------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /*:T Validaá∆o de dicion†rio */
    
/*:T    Segue um exemplo de validaá∆o de programa */
/*       find tabela where tabela.campo1 = c-variavel and               */
/*                         tabela.campo2 > i-variavel no-lock no-error. */
      
      /*:T Este include deve ser colocado sempre antes do ut-msgs.p */
/*       {include/i-vldprg.i}                                             */
/*       run utp/ut-msgs.p (input "show":U, input 7, input return-value). */
/*       return 'ADM-ERROR':U.                                            */
    for first int_param_uep 
        where int_param_uep.cod_empresa = v_cod_empres_usuar
              no-lock: end.

    if not avail int_param_uep
    then do:
         run utp/ut-msgs.p (input "show", input 17567, input "ParÉmetros UEP n∆o informados (escdp122).").
         return 'ADM-ERROR'.
    end.

    FOR first b_bem_pat
        where b_bem_pat.cod_empresa     = v_cod_empres_usuar
          and b_bem_pat.cod_cta_pat     = input frame {&frame-name} int_bem_pat.cod_cta_pat
          and b_bem_pat.num_bem_pat     = input frame {&frame-name} int_bem_pat.num_bem_pat
          and b_bem_pat.num_seq_bem_pat = input frame {&frame-name} int_bem_pat.num_seq_bem_pat
              no-lock: end.

    IF adm-new-record
    THEN do:
         IF not avail b_bem_pat
         THEN do:
              run utp/ut-msgs.p (input "show":U, input 17567, input "Bem Patrimonial inexistente!").
              apply 'entry' to int_bem_pat.num_seq_bem_pat in frame {&frame-name}.
              return 'ADM-ERROR':U.
         END.

         IF can-find(first b_int_bem_pat where
                           b_int_bem_pat.cod_empresa     = b_bem_pat.cod_empresa
                       and b_int_bem_pat.num_bem_pat     = b_bem_pat.num_bem_pat
                       and b_int_bem_pat.num_seq_bem_pat = b_bem_pat.num_seq_bem_pat
                       and b_int_bem_pat.cod_cta_pat     = b_bem_pat.cod_cta_pat
                           no-lock)
         then do:
              run utp/ut-msgs.p (input "show":U, input 17567, input "Extens∆o Bem Patrimonial j† cadastrada!").
              apply 'entry' to int_bem_pat.num_seq_bem_pat in frame {&frame-name}.
              return 'ADM-ERROR':U.
         END.

         if b_bem_pat.val_perc_bxa >= 100
         then do:
              run utp/ut-msgs.p (input "show":U, input 17567, input "Bem j† foi baixado!").
              apply 'entry' to int_bem_pat.num_seq_bem_pat in frame {&frame-name}.
              return 'ADM-ERROR':U.
         end.

         if not can-find(first b_int_param_cta_uep where
                               b_int_param_cta_uep.cod_empresa = b_bem_pat.cod_empresa
                           and b_int_param_cta_uep.cod_cta_pat = b_bem_pat.cod_cta_pat
                               no-lock)
         then do:
              run utp/ut-msgs.p (input "show":U, input 17567, input "Conta Patrimonial n∆o prevista nos ParÉmetros UEP (escdp122)").
              apply 'entry' to int_bem_pat.cod_cta_pat in frame {&frame-name}.
              return 'ADM-ERROR':U.
         end.
        
         if b_bem_pat.num_bem_pat > 999999
         then do:
              run utp/ut-msgs.p (input "show":U, input 17567, input "N£mero Bem Patrimonial muito extenso para arquivo UEP!").
              apply 'entry' to int_bem_pat.num_bem_pat in frame {&frame-name}.
              return 'ADM-ERROR':U.
         end.
        
         if b_bem_pat.num_seq_bem_pat > 999
         then do:
              run utp/ut-msgs.p (input "show":U, input 17567, input "Sequància Bem Patrimonial muito extensa para arquivo UEP!").
              apply 'entry' to int_bem_pat.num_seq_bem_pat in frame {&frame-name}.
              return 'ADM-ERROR':U.
         end.
    END.

    IF not avail b_bem_pat
    then do:
         run utp/ut-msgs.p (input "show":U, input 17567, input "Bem Patrimonial inexistente. Elimine extens∆o e a crie novamente!").
         return 'ADM-ERROR':U.
    end.

    if can-find(first aloc_bem where
                      aloc_bem.num_id_bem_pat   = b_bem_pat.num_id_bem_pat
                  and aloc_bem.cod_empresa      = b_bem_pat.cod_empresa
                  and aloc_bem.cod_plano_ccusto = int_param_uep.cod_plano_ccusto
                  and aloc_bem.cod_ccusto      >= int_param_uep.cod_ccusto_ini
                  and aloc_bem.cod_ccusto      <= int_param_uep.cod_ccusto_fim
                      no-lock)
    or (not can-find (first aloc_bem where
                            aloc_bem.num_id_bem_pat = b_bem_pat.num_id_bem_pat
                            no-lock)
    and b_bem_pat.cod_plano_ccusto    = int_param_uep.cod_plano_ccusto
    and b_bem_pat.cod_ccusto_respons >= int_param_uep.cod_ccusto_ini
    and b_bem_pat.cod_ccusto_respons <= int_param_uep.cod_ccusto_fim)
    then.
    else do:
         run utp/ut-msgs.p (input "show":U, input 17567, input "CCusto do Bem n∆o se encaixa no intervalo: " + int_param_uep.cod_ccusto_ini + "-" + int_param_uep.cod_ccusto_fim + "!").
         IF adm-new-record
         then apply 'entry' to int_bem_pat.num_bem_pat in frame {&frame-name}.
         return 'ADM-ERROR':U.
    end.

    if input frame {&frame-name} int_bem_pat.hr_manut > 528
    then do:
         run utp/ut-msgs.p (input "show":U, input 17567, input "Horas Manutená∆o n∆o pode exceder o limite de 528!").
         apply 'entry' to int_bem_pat.hr_manut in frame {&frame-name}.
         return 'ADM-ERROR':U.
    end.

    if  b_bem_pat.num_bem_pat     < 1000000
    and b_bem_pat.num_seq_bem_pat < 1000
    then assign c-equipto = string(b_bem_pat.num_bem_pat,"999999") 
                          + "-"                                    
                          + string(b_bem_pat.num_seq_bem_pat,"999").
    else assign c-equipto = "".

    if int_bem_pat.molde:checked in frame {&frame-name}
    then do:
         if  not adm-new-record
         and can-find(first int_bem_pat_gm where
                            int_bem_pat_gm.num_id_bem_pat = b_bem_pat.num_id_bem_pat
                            no-lock)
         then do:
              run utp/ut-msgs.p (input "show":U, input 17567, input "H† Gr M†q vinculado(s). Elimine-os antes de marcar o Molde!").
              apply 'entry' to int_bem_pat.molde in frame {&frame-name}.
              return 'ADM-ERROR':U.
         end.

         if input frame {&frame-name} int_bem_pat.equipamento = ""
         then do:
              run utp/ut-msgs.p (input "show":U, input 17567, input "Equipamento deve ser informado!").
              apply 'entry' to int_bem_pat.equipamento in frame {&frame-name}.
              return 'ADM-ERROR':U.
         end.

         if length(input frame {&frame-name} int_bem_pat.equipamento) > 10
         then do:
              run utp/ut-msgs.p (input "show":U, input 17567, input "Equipamento muito extenso para arquivo UEP").
              apply 'entry' to int_bem_pat.equipamento in frame {&frame-name}.
              return 'ADM-ERROR':U.
         end.

         if b_bem_pat.dat_aquis_bem_pat < dt-corte
         then do:  
              for first ferr-prod
                  where ferr-prod.cod-ferr-prod = input frame {&frame-name} int_bem_pat.equipamento
                        no-lock: end.

              if not avail ferr-prod
              then do:
                   run utp/ut-msgs.p (input "show":U, input 17567, input "Equipamento n∆o cadastrado!").
                   apply 'entry' to int_bem_pat.equipamento in frame {&frame-name}.
                   return 'ADM-ERROR':U.
              end.
        
              if ferr-prod.char-1 <> "Ferramenta"
              then do:
                   run utp/ut-msgs.p (input "show":U, input 17567, input "Equipamento n∆o est† cadastrado como Ferramenta!").
                   apply 'entry' to int_bem_pat.equipamento in frame {&frame-name}.
                   return 'ADM-ERROR':U.
              end.              
         end. /* if b_bem_pat.dat-aquis_bem_pat < dt-corte */
         else do:
              for first ferr-prod
                  where ferr-prod.cod-ferr-prod = c-equipto
                        no-lock: end.

              if adm-new-record
              then do:
                   if c-equipto <> ""
                   then assign int_bem_pat.equipamento:screen-value in frame {&frame-name} = c-equipto
                               fi-des-ferr-prod:screen-value in frame {&frame-name}        = b_bem_pat.des_bem_pat.
                   else do:
                        run utp/ut-msgs.p (input "show":U, input 17567, input "Inconsistància relacionada ao formato do Nro. do Bem e/ou Sequància!").
                        return 'ADM-ERROR':U.
                   end. /* else do */

                   if avail ferr-prod
                   then do:
                        run utp/ut-msgs.p (input "show":U, input 17567, input "Equipamento j† cadastrado, e portanto n∆o poder† ser inclu°do automaticamente!").
                        return 'ADM-ERROR':U.
                   end.
              end.
              else do:
                   if input frame {&frame-name} int_bem_pat.equipamento = ""
                   or input frame {&frame-name} int_bem_pat.equipamento <> c-equipto
                   then do:
                        run utp/ut-msgs.p (input "show":U, input 17567, input "Equipamento inconsistente!").
                        return 'ADM-ERROR':U.
                   end.

                   if  avail ferr-prod
                   and ferr-prod.char-1 <> "Ferramenta"
                   then do:
                        run utp/ut-msgs.p (input "show":U, input 17567, input "Equipamento n∆o est† cadastrado como Ferramenta (CD0124)!").
                        return 'ADM-ERROR':U.
                   end.
              end. /* else do */

              if  not avail ferr-prod
              and b_bem_pat.des_bem_pat = ""
              then do:
                   run utp/ut-msgs.p (input "show":U, input 17567, input "Bem n∆o possui descriá∆o (necess†ria para o cadastro autom†tico do Equipamento)!").
                   return 'ADM-ERROR':U.                   
              end.
         end. /* else do */

         IF (adm-new-record
         and can-find(first b_int_bem_pat use-index ch-equipto where
                            b_int_bem_pat.equipamento = input frame {&frame-name} int_bem_pat.equipamento
                            no-lock))
         or (not adm-new-record
         and can-find(first b_int_bem_pat use-index ch-equipto where
                            b_int_bem_pat.equipamento = input frame {&frame-name} int_bem_pat.equipamento
                        and rowid(b_int_bem_pat)     <> rowid(int_bem_pat)
                            no-lock))
         then do:
              run utp/ut-msgs.p (input "show":U, input 17567, input "Equipamento j† informado para outro Bem!").
              apply 'entry' to int_bem_pat.equipamento in frame {&frame-name}.
              return 'ADM-ERROR':U.
         END.
    end. /* if int_bem_pat.molde:checked in frame {&frame-name} */
    else do:
         if input frame {&frame-name} int_bem_pat.equipamento <> ""
         then do:
              run utp/ut-msgs.p (input "show":U, input 17567, input "Molde est† desmarcado. Equipamento deve estar em branco!").
              return 'ADM-ERROR':U.
         end.

         if can-find(first ferr-prod where
                           ferr-prod.cod-ferr-prod = c-equipto
                           no-lock)
         then do:
              assign c-mensagem = "Molde desmarcado, porÇm, vinculou-se este Bem a uma Ferramenta (CD0124)! Deseja prosseguir?~~Deseja prosseguir?".
              
              run utp/ut-msgs(input 'show',
                              input 27100,
                              input c-mensagem).
              
              if return-value <> 'yes'
              then return 'ADM-ERROR':U.
         end.
    end. /* else do */
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
  {src/adm/template/snd-list.i "int_bem_pat"}

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

