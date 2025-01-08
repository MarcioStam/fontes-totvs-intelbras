&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
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
{include/i-prgvrs.i V99XX999 9.99.99.999}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */
/*                                                                                */
/* OBS: Para os smartobjects o parametro m¢dulo dever† ser MUT                    */

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

DEFINE VARIABLE hProgramZoom AS HANDLE      NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES int-comissao-adc
&Scoped-define FIRST-EXTERNAL-TABLE int-comissao-adc


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR int-comissao-adc.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS int-comissao-adc.idi-lancto ~
int-comissao-adc.vl-base int-comissao-adc.historico 
&Scoped-define ENABLED-TABLES int-comissao-adc
&Scoped-define FIRST-ENABLED-TABLE int-comissao-adc
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS int-comissao-adc.cod-estabel ~
int-comissao-adc.cod-unid-negoc int-comissao-adc.cod-segmento ~
int-comissao-adc.it-codigo int-comissao-adc.codigo ~
int-comissao-adc.periodo-mes int-comissao-adc.periodo-ano ~
int-comissao-adc.dt-transacao int-comissao-adc.cod-usuario ~
int-comissao-adc.idi-lancto int-comissao-adc.vl-base ~
int-comissao-adc.historico 
&Scoped-define DISPLAYED-TABLES int-comissao-adc
&Scoped-define FIRST-DISPLAYED-TABLE int-comissao-adc
&Scoped-Define DISPLAYED-OBJECTS c-desc-estab c-desc-unid-negoc ~
c-desc-segmento c-desc-item c-desc-repres 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS int-comissao-adc.cod-estabel ~
int-comissao-adc.cod-unid-negoc int-comissao-adc.cod-segmento ~
int-comissao-adc.it-codigo int-comissao-adc.dt-transacao ~
int-comissao-adc.idi-lancto 

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
DEFINE VARIABLE c-desc-estab AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-repres AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-segmento AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-unid-negoc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 6.75.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 9.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     int-comissao-adc.cod-estabel AT ROW 1.5 COL 14 COLON-ALIGNED WIDGET-ID 2
          LABEL "Estabelecimento"
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-desc-estab AT ROW 1.5 COL 22.43 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     int-comissao-adc.cod-unid-negoc AT ROW 2.5 COL 14 COLON-ALIGNED WIDGET-ID 6
          LABEL "Unidade Neg¢cio"
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-desc-unid-negoc AT ROW 2.5 COL 22.43 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     int-comissao-adc.cod-segmento AT ROW 3.5 COL 14 COLON-ALIGNED WIDGET-ID 4 FORMAT ">>>9"
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-desc-segmento AT ROW 3.5 COL 22.43 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     int-comissao-adc.it-codigo AT ROW 4.5 COL 14 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 11.57 BY .88
     c-desc-item AT ROW 4.5 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     int-comissao-adc.codigo AT ROW 5.5 COL 14 COLON-ALIGNED WIDGET-ID 10
          LABEL "Representante"
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-desc-repres AT ROW 5.5 COL 22.43 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     int-comissao-adc.periodo-mes AT ROW 6.5 COL 14 COLON-ALIGNED WIDGET-ID 20
          LABEL "Per°odo"
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     int-comissao-adc.periodo-ano AT ROW 6.5 COL 18.72 COLON-ALIGNED NO-LABEL WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     int-comissao-adc.dt-transacao AT ROW 8.5 COL 17 COLON-ALIGNED WIDGET-ID 12
          LABEL "Data Transaá∆o"
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     int-comissao-adc.cod-usuario AT ROW 9.5 COL 17 COLON-ALIGNED WIDGET-ID 8
          LABEL "Usu†rio"
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     int-comissao-adc.idi-lancto AT ROW 10.58 COL 18.86 NO-LABEL WIDGET-ID 34
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "DÇbito", 1,
"CrÇdito", 2
          SIZE 24 BY .75
     int-comissao-adc.vl-base AT ROW 11.5 COL 17 COLON-ALIGNED WIDGET-ID 22
          LABEL "Valor"
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     int-comissao-adc.historico AT ROW 12.5 COL 19 NO-LABEL WIDGET-ID 40
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 69 BY 4
     "/" VIEW-AS TEXT
          SIZE 1 BY .54 AT ROW 6.67 COL 19.72 WIDGET-ID 24
     "Hist¢rico:" VIEW-AS TEXT
          SIZE 6.72 BY .54 AT ROW 12.67 COL 12.29 WIDGET-ID 42
     "Lanáamento:" VIEW-AS TEXT
          SIZE 8.72 BY .54 AT ROW 10.63 COL 9.72 WIDGET-ID 38
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 7.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 7 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgesp.int-comissao-adc
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
         HEIGHT             = 16.33
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-estab IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-repres IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-segmento IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-unid-negoc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int-comissao-adc.cod-estabel IN FRAME f-main
   NO-ENABLE 1 EXP-LABEL                                                */
/* SETTINGS FOR FILL-IN int-comissao-adc.cod-segmento IN FRAME f-main
   NO-ENABLE 1 EXP-FORMAT                                               */
/* SETTINGS FOR FILL-IN int-comissao-adc.cod-unid-negoc IN FRAME f-main
   NO-ENABLE 1 EXP-LABEL                                                */
/* SETTINGS FOR FILL-IN int-comissao-adc.cod-usuario IN FRAME f-main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN int-comissao-adc.codigo IN FRAME f-main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN int-comissao-adc.dt-transacao IN FRAME f-main
   NO-ENABLE 1 EXP-LABEL                                                */
/* SETTINGS FOR RADIO-SET int-comissao-adc.idi-lancto IN FRAME f-main
   1                                                                    */
/* SETTINGS FOR FILL-IN int-comissao-adc.it-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN int-comissao-adc.periodo-ano IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int-comissao-adc.periodo-mes IN FRAME f-main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN int-comissao-adc.vl-base IN FRAME f-main
   EXP-LABEL                                                            */
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

&Scoped-define SELF-NAME int-comissao-adc.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-comissao-adc.cod-estabel V-table-Win
ON F5 OF int-comissao-adc.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
      {method/ZoomFields.i &ProgramZoom="adzoom/z06ad107.w"
                           &FieldZoom1="cod-estabel"
                           &FieldScreen1="int-comissao-adc.cod-estabel"
                           &FieldZoom2="nome"
                           &FieldScreen2="c-desc-estab"
                           &Frame1="f-main"
                           &Frame2="f-main"
                           &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-comissao-adc.cod-estabel V-table-Win
ON LEAVE OF int-comissao-adc.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
    FIND FIRST estabelec NO-LOCK
         WHERE estabelec.cod-estabel = INPUT FRAME f-main int-comissao-adc.cod-estabel NO-ERROR.

    IF AVAIL estabelec THEN
        ASSIGN c-desc-estab:SCREEN-VALUE IN FRAME f-main = estabelec.nome.
    ELSE
        ASSIGN c-desc-estab:SCREEN-VALUE IN FRAME f-main = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-comissao-adc.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF int-comissao-adc.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
   APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME int-comissao-adc.cod-segmento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-comissao-adc.cod-segmento V-table-Win
ON F5 OF int-comissao-adc.cod-segmento IN FRAME f-main /* Segmento */
DO:
    {method/ZoomFields.i &ProgramZoom="eszoom/z03es513.w"
                         &FieldZoom1="segmento"
                         &FieldScreen1="int-comissao-adc.cod-segmento"
                         &Frame1="f-main"
                         &FieldZoom2="descricao"
                         &FieldScreen2="c-desc-segmento"
                         &Frame2="f-main"
                         &EnableImplant="NO"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-comissao-adc.cod-segmento V-table-Win
ON LEAVE OF int-comissao-adc.cod-segmento IN FRAME f-main /* Segmento */
DO:
    FIND FIRST fam-comerc NO-LOCK
         WHERE SUBSTRING(fam-comerc.fm-cod-com,1,4) = string(INPUT FRAME f-main int-comissao-adc.cod-segmento) NO-ERROR.

    IF AVAIL fam-comerc THEN
        ASSIGN c-desc-segmento:SCREEN-VALUE IN FRAME f-main = fam-comerc.descricao.
    ELSE
        ASSIGN c-desc-segmento:SCREEN-VALUE IN FRAME f-main =  "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-comissao-adc.cod-segmento V-table-Win
ON MOUSE-SELECT-DBLCLICK OF int-comissao-adc.cod-segmento IN FRAME f-main /* Segmento */
DO:
    APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME int-comissao-adc.cod-unid-negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-comissao-adc.cod-unid-negoc V-table-Win
ON F5 OF int-comissao-adc.cod-unid-negoc IN FRAME f-main /* Unidade Neg¢cio */
DO:
    {method/ZoomFields.i &ProgramZoom="inzoom/z01in745.w"
                         &FieldZoom1="cod-unid-negoc"
                         &FieldScreen1="int-comissao-adc.cod-unid-negoc"
                         &FieldZoom2="des-unid-negoc"
                         &FieldScreen2="c-desc-unid-negoc"
                         &Frame1="f-main"
                         &Frame2="f-main"
                         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-comissao-adc.cod-unid-negoc V-table-Win
ON LEAVE OF int-comissao-adc.cod-unid-negoc IN FRAME f-main /* Unidade Neg¢cio */
DO:
    FIND FIRST unid-negoc NO-LOCK
         WHERE unid-negoc.cod-unid-negoc = INPUT FRAME f-main int-comissao-adc.cod-unid-negoc NO-ERROR.

    IF AVAIL unid-negoc THEN
        ASSIGN c-desc-unid-negoc:SCREEN-VALUE IN FRAME f-main = unid-negoc.des-unid-negoc.
    ELSE
        ASSIGN c-desc-unid-negoc:SCREEN-VALUE IN FRAME f-main = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-comissao-adc.cod-unid-negoc V-table-Win
ON MOUSE-SELECT-DBLCLICK OF int-comissao-adc.cod-unid-negoc IN FRAME f-main /* Unidade Neg¢cio */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME int-comissao-adc.codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-comissao-adc.codigo V-table-Win
ON LEAVE OF int-comissao-adc.codigo IN FRAME f-main /* Representante */
DO:
    FIND FIRST int-execsuperv-calc NO-LOCK
         WHERE rowid(int-execsuperv-calc) = v-row-parent NO-ERROR.

    IF int-execsuperv-calc.idi-tipo = 1 THEN DO:
        FIND FIRST repres NO-LOCK
             WHERE repres.cod-rep = INPUT FRAME f-main int-comissao-adc.codigo NO-ERROR.
    
        IF AVAIL repres THEN
            ASSIGN c-desc-repres:SCREEN-VALUE IN FRAME f-main = repres.nome-abrev.
        ELSE
            ASSIGN c-desc-repres:SCREEN-VALUE IN FRAME f-main =  "".
    END.
    ELSE DO:
        FIND FIRST int-supervisor NO-LOCK
             WHERE int-supervisor.cod-supervisor = int-execsuperv-calc.cod-sup-exec NO-ERROR.

        IF AVAIL int-supervisor THEN
            ASSIGN c-desc-repres:SCREEN-VALUE IN FRAME f-main = int-supervisor.nome.
        ELSE 
            ASSIGN c-desc-repres:SCREEN-VALUE IN FRAME f-main =  "".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME int-comissao-adc.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-comissao-adc.it-codigo V-table-Win
ON F5 OF int-comissao-adc.it-codigo IN FRAME f-main /* Produto */
DO:
     {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                        &campo="int-comissao-adc.it-codigo"    
                        &campo2="c-desc-item"
                        &campozoom="it-codigo"
                        &campozoom2="desc-item"
                        &frame="f-main"
                        &frame2="f-main"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-comissao-adc.it-codigo V-table-Win
ON LEAVE OF int-comissao-adc.it-codigo IN FRAME f-main /* Produto */
DO:
    IF INPUT FRAME f-main int-comissao-adc.it-codigo = "*" THEN DO:
        ASSIGN c-desc-item:SCREEN-VALUE IN FRAME f-main =  "Todos".
    END.
    ELSE DO:
        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = INPUT FRAME f-main int-comissao-adc.it-codigo NO-ERROR.
    
        IF AVAIL ITEM THEN
            ASSIGN c-desc-item:SCREEN-VALUE IN FRAME f-main = ITEM.desc-item.
        ELSE
            ASSIGN c-desc-item:SCREEN-VALUE IN FRAME f-main =  "".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-comissao-adc.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF int-comissao-adc.it-codigo IN FRAME f-main /* Produto */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF   
        
  if int-comissao-adc.cod-estabel:load-mouse-pointer ("image/lupa.cur") then.
  if int-comissao-adc.cod-unid-negoc:load-mouse-pointer ("image/lupa.cur") then.
  if int-comissao-adc.cod-segmento:load-mouse-pointer ("image/lupa.cur") then.
  if int-comissao-adc.it-codigo:load-mouse-pointer ("image/lupa.cur") then.
  
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
  {src/adm/template/row-list.i "int-comissao-adc"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "int-comissao-adc"}

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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ).

    FIND FIRST int-execsuperv-calc NO-LOCK
         WHERE rowid(int-execsuperv-calc) = v-row-parent NO-ERROR.

    IF int-execsuperv-calc.idi-tipo = 1 THEN DO:
        FIND FIRST repres NO-LOCK
             WHERE repres.cod-rep = INPUT FRAME f-main int-comissao-adc.codigo NO-ERROR.
    
        IF AVAIL repres THEN
            ASSIGN c-desc-repres:SCREEN-VALUE IN FRAME f-main = repres.nome-abrev.
        ELSE
            ASSIGN c-desc-repres:SCREEN-VALUE IN FRAME f-main =  "".
    END.
    ELSE DO:
        FIND FIRST int-supervisor NO-LOCK
             WHERE int-supervisor.cod-supervisor = int-execsuperv-calc.cod-sup-exec NO-ERROR.

        IF AVAIL int-supervisor THEN
            ASSIGN c-desc-repres:SCREEN-VALUE IN FRAME f-main = int-supervisor.nome.
        ELSE 
            ASSIGN c-desc-repres:SCREEN-VALUE IN FRAME f-main =  "".
    END.  

    ASSIGN int-comissao-adc.codigo:SCREEN-VALUE IN FRAME f-main = STRING(int-execsuperv-calc.cod-sup-exec).

    ASSIGN int-comissao-adc.periodo-mes:SCREEN-VALUE IN FRAME f-main = STRING(int-execsuperv-calc.periodo-mes)
           int-comissao-adc.periodo-ano:SCREEN-VALUE IN FRAME f-main = STRING(int-execsuperv-calc.periodo-ano)
           int-comissao-adc.cod-usuario:SCREEN-VALUE IN FRAME f-main = c-seg-usuario.
        


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
    
    /*:T Ponha na pi-validate todas as validaá‰es */
    /*:T N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    RUN pi-validate.
    IF RETURN-VALUE <> "OK" THEN
        RETURN 'ADM-ERROR'.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    IF adm-new-record THEN DO:
        FIND FIRST int-execsuperv-calc NO-LOCK
             WHERE rowid(int-execsuperv-calc) = v-row-parent NO-ERROR.
    
        ASSIGN int-comissao-adc.codigo      = int-execsuperv-calc.cod-sup-exec
               int-comissao-adc.periodo-mes = int-execsuperv-calc.periodo-mes
               int-comissao-adc.periodo-ano = int-execsuperv-calc.periodo-ano
               int-comissao-adc.idi-tipo    = int-execsuperv-calc.idi-tipo.
    END.
        
    
    /*:T Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    APPLY "leave" TO int-comissao-adc.cod-estabel IN FRAME f-main.
    APPLY "leave" TO int-comissao-adc.cod-unid-negoc IN FRAME f-main.
    APPLY "leave" TO int-comissao-adc.cod-segmento IN FRAME f-main.
    APPLY "leave" TO int-comissao-adc.it-codigo IN FRAME f-main.
    APPLY "leave" TO int-comissao-adc.codigo IN FRAME f-main.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
    
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
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /*:T Validaá∆o de dicion†rio */

    IF NOT CAN-FIND (FIRST estabelec
                     WHERE estabelec.cod-estabel = INPUT FRAME f-main int-comissao-adc.cod-estabel) THEN DO:

        RUN utp/ut-msgs.p ("show",
                           17006,
                           "Estabelecimento n∆o cadastrado!").

        RETURN "ADM-ERROR".
    END.

     IF NOT CAN-FIND (FIRST unid-negoc
                      WHERE unid-negoc.cod-unid-negoc = INPUT FRAME f-main int-comissao-adc.cod-unid-negoc) THEN DO:

        RUN utp/ut-msgs.p ("show",
                           17006,
                           "Unidade de neg¢cios n∆o cadastrada!").

        RETURN "ADM-ERROR".
    END.

    IF  INPUT FRAME f-main int-comissao-adc.it-codigo <> "*"
    AND NOT CAN-FIND (FIRST ITEM
                      WHERE ITEM.it-codigo = INPUT FRAME f-main int-comissao-adc.it-codigo) THEN DO:

        RUN utp/ut-msgs.p ("show",
                           17006,
                           "Item n∆o cadastrado!").

        RETURN "ADM-ERROR".
    END.

    FIND FIRST int-param-comis NO-LOCK
         WHERE int-param-comis.periodo-mes = INPUT FRAME f-main int-comissao-adc.periodo-mes 
           AND int-param-comis.periodo-ano = INPUT FRAME f-main int-comissao-adc.periodo-ano NO-ERROR.

    IF  AVAIL int-param-comis 
    AND int-param-comis.idi-status <> 1 THEN DO:
        RUN utp/ut-msgs.p ("show",
                           17006,
                           "Status do per°odo n∆o permite lanáamento!").

        RETURN "ADM-ERROR".
    END.

    IF INPUT FRAME f-main int-comissao-adc.dt-transacao = ? THEN DO:
        RUN utp/ut-msgs.p ("show",
                           17006,
                           "Data de transaá∆o n∆o informada!").

        RETURN "ADM-ERROR".
    END.

    
    IF NOT CAN-FIND (FIRST fam-comerc
                     WHERE SUBSTRING(fam-comerc.fm-cod-com,1,4) = string(INPUT FRAME f-main int-comissao-adc.cod-segmento)) THEN DO:

        RUN utp/ut-msgs.p ("show",
                           17006,
                           "Segmento n∆o cadastrado!").

        RETURN "ADM-ERROR".

    END.

    FIND FIRST int-param-comis NO-LOCK
         WHERE int-param-comis.dt-periodo-ini >= INPUT FRAME f-main int-comissao-adc.dt-transacao 
           AND int-param-comis.dt-periodo-fim <= INPUT FRAME f-main int-comissao-adc.dt-transacao NO-ERROR.

    IF  AVAIL int-param-comis 
    AND int-param-comis.idi-status <> 1 THEN DO:
        RUN utp/ut-msgs.p ("show",
                           17006,
                           "Status da data de transaá∆o n∆o permite lanáamento!").

        RETURN "ADM-ERROR".
    END.

    IF INPUT FRAME f-main int-comissao-adc.vl-base = 0 THEN DO:
        RUN utp/ut-msgs.p ("show",
                           17006,
                           "Valor base n∆o pode ser 0!").

        RETURN "ADM-ERROR".
    END.

    
    IF LENGTH(INPUT FRAME f-main int-comissao-adc.historico) < 15 THEN DO:
        RUN utp/ut-msgs.p ("show",
                           17006,
                           "Hist¢rico deve conter mais de 15 caracteres!").

        RETURN "ADM-ERROR".
    END.


    
/*:T    Segue um exemplo de validaá∆o de programa */
/*       find tabela where tabela.campo1 = c-variavel and               */
/*                         tabela.campo2 > i-variavel no-lock no-error. */
      
      /*:T Este include deve ser colocado sempre antes do ut-msgs.p */
/*       {include/i-vldprg.i}                                             */
/*       run utp/ut-msgs.p (input "show":U, input 7, input return-value). */
/*       return 'ADM-ERROR':U.                                            */

    RETURN "OK".
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
  {src/adm/template/snd-list.i "int-comissao-adc"}

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
      WHEN "repres" THEN
          RUN pi-atualiza-repres.
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

