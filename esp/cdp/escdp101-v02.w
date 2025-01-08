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
{include/i-prgvrs.i ESCPD101-V02 1.00.00.001}

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
def var v-row-parent  as rowid  no-undo.
def var c-lista-campo as char   no-undo.
DEF VAR hProgramZoom  AS handle NO-UNDO.

def buffer b-int-emitente-desc for int-emitente-desc.

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
&Scoped-define EXTERNAL-TABLES int-emitente-desc
&Scoped-define FIRST-EXTERNAL-TABLE int-emitente-desc


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR int-emitente-desc.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS int-emitente-desc.fator ~
int-emitente-desc.dt-ini-val 
&Scoped-define ENABLED-TABLES int-emitente-desc
&Scoped-define FIRST-ENABLED-TABLE int-emitente-desc
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS int-emitente-desc.cod-emitente ~
int-emitente-desc.nr-tabpre int-emitente-desc.it-codigo ~
int-emitente-desc.cod-unid-negoc int-emitente-desc.segmento ~
int-emitente-desc.fator int-emitente-desc.dt-ini-val 
&Scoped-define DISPLAYED-TABLES int-emitente-desc
&Scoped-define FIRST-DISPLAYED-TABLE int-emitente-desc
&Scoped-Define DISPLAYED-OBJECTS fi-des-unid-negoc fi-nome-emit ~
fi-descricao fi-desc-seg fi-desc-item 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS int-emitente-desc.nr-tabpre ~
int-emitente-desc.it-codigo int-emitente-desc.cod-unid-negoc ~
int-emitente-desc.segmento 

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
DEFINE VARIABLE fi-des-unid-negoc AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-seg AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE fi-descricao AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-emit AS CHARACTER FORMAT "X(80)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79.29 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79.29 BY 6.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     int-emitente-desc.cod-emitente AT ROW 1.17 COL 16 COLON-ALIGNED WIDGET-ID 2
          LABEL "Cliente"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     int-emitente-desc.nr-tabpre AT ROW 2.67 COL 16 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     int-emitente-desc.it-codigo AT ROW 3.67 COL 16 COLON-ALIGNED WIDGET-ID 10
          LABEL "Produto"
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     int-emitente-desc.cod-unid-negoc AT ROW 4.67 COL 16 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     int-emitente-desc.segmento AT ROW 5.67 COL 16 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     int-emitente-desc.fator AT ROW 6.67 COL 16 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     int-emitente-desc.dt-ini-val AT ROW 7.67 COL 16 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fi-des-unid-negoc AT ROW 4.67 COL 20.29 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     fi-nome-emit AT ROW 1.17 COL 26.29 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     fi-descricao AT ROW 2.67 COL 25.29 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     fi-desc-seg AT ROW 5.67 COL 25.29 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     fi-desc-item AT ROW 3.67 COL 33.29 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgesp.int-emitente-desc
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
         HEIGHT             = 7.79
         WIDTH              = 79.86.
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

/* SETTINGS FOR FILL-IN int-emitente-desc.cod-emitente IN FRAME f-main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN int-emitente-desc.cod-unid-negoc IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN fi-des-unid-negoc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-desc-seg IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-nome-emit IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN int-emitente-desc.it-codigo IN FRAME f-main
   NO-ENABLE 1 EXP-LABEL                                                */
/* SETTINGS FOR FILL-IN int-emitente-desc.nr-tabpre IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN int-emitente-desc.segmento IN FRAME f-main
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

&Scoped-define SELF-NAME int-emitente-desc.cod-unid-negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-emitente-desc.cod-unid-negoc V-table-Win
ON F5 OF int-emitente-desc.cod-unid-negoc IN FRAME f-main /* Unid Neg */
DO:
  {include/zoomvar.i &prog-zoom  = eszoom/z03es513.w
                     &campo      = int-emitente-desc.cod-unid-negoc
                     &campozoom  = fm-cod-com
                     &campo2     = fi-des-unid-negoc
                     &campozoom2 = descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-emitente-desc.cod-unid-negoc V-table-Win
ON LEAVE OF int-emitente-desc.cod-unid-negoc IN FRAME f-main /* Unid Neg */
DO:
  do with frame {&frame-name}:
      assign fi-des-unid-negoc:screen-value = "".

      if input int-emitente-desc.cod-unid-negoc = "*"
      then assign fi-des-unid-negoc:screen-value = "Todas".
      else for first fam-com-item no-lock
               where fam-com-item.fm-cod-com = input int-emitente-desc.cod-unid-negoc:
               assign fi-des-unid-negoc:screen-value = trim(fam-com-item.descricao).
           end.
  end.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-emitente-desc.cod-unid-negoc V-table-Win
ON MOUSE-SELECT-DBLCLICK OF int-emitente-desc.cod-unid-negoc IN FRAME f-main /* Unid Neg */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME int-emitente-desc.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-emitente-desc.it-codigo V-table-Win
ON F5 OF int-emitente-desc.it-codigo IN FRAME f-main /* Produto */
DO:
    {method/zoomfields.i &ProgramZoom="dizoom/z03di292.w"
                         &FieldZoom1="it-codigo"
                         &FieldScreen1="int-emitente-desc.it-codigo"
                         &Frame1={&FRAME-NAME}
                         &FieldZoom2="desc-item"
                         &FieldScreen2="fi-desc-item"
                         &Frame2={&FRAME-NAME}
                         &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-emitente-desc.it-codigo V-table-Win
ON LEAVE OF int-emitente-desc.it-codigo IN FRAME f-main /* Produto */
DO:
  do with frame {&frame-name}:
      assign fi-desc-item:screen-value = "".

      if input int-emitente-desc.it-codigo = "*"
      then assign fi-desc-item:screen-value = "Todos".
      else for first item no-lock
               where item.it-codigo = input int-emitente-desc.it-codigo:
               assign fi-desc-item:screen-value = trim(item.desc-item).
           end.

      if adm-new-record
      then if  input int-emitente-desc.it-codigo <> ""
           and input int-emitente-desc.it-codigo <> "*"
           then assign int-emitente-desc.cod-unid-negoc:screen-value = ""
                       int-emitente-desc.segmento:screen-value       = ""
                       int-emitente-desc.cod-unid-negoc:sensitive    = no
                       int-emitente-desc.segmento:sensitive          = no.
           else assign int-emitente-desc.cod-unid-negoc:sensitive    = int-emitente-desc.it-codigo:sensitive
                       int-emitente-desc.segmento:sensitive          = int-emitente-desc.it-codigo:sensitive.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-emitente-desc.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF int-emitente-desc.it-codigo IN FRAME f-main /* Produto */
DO:
  apply 'F5' to self.       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME int-emitente-desc.nr-tabpre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-emitente-desc.nr-tabpre V-table-Win
ON F5 OF int-emitente-desc.nr-tabpre IN FRAME f-main /* Tab Preáo */
DO:
    {method/zoomfields.i &ProgramZoom="dizoom/z02di189.w"
                         &FieldZoom1="nr-tabpre"
                         &FieldScreen1="int-emitente-desc.nr-tabpre"
                         &Frame1={&FRAME-NAME}
                         &FieldZoom2="descricao"
                         &FieldScreen2="fi-descricao"
                         &Frame2={&FRAME-NAME}
                         &EnableImplant="NO"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-emitente-desc.nr-tabpre V-table-Win
ON LEAVE OF int-emitente-desc.nr-tabpre IN FRAME f-main /* Tab Preáo */
DO:
  do with frame {&frame-name}:
      assign fi-descricao:screen-value = "".

      for first tb-preco no-lock
          where tb-preco.nr-tabpre = input int-emitente-desc.nr-tabpre:
          assign fi-descricao:screen-value = trim(tb-preco.descricao).
      end.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-emitente-desc.nr-tabpre V-table-Win
ON MOUSE-SELECT-DBLCLICK OF int-emitente-desc.nr-tabpre IN FRAME f-main /* Tab Preáo */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME int-emitente-desc.segmento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-emitente-desc.segmento V-table-Win
ON F5 OF int-emitente-desc.segmento IN FRAME f-main /* Segmento */
DO:
  {include/zoomvar.i &prog-zoom  = eszoom/z03es513.w
                     &campo      = int-emitente-desc.segmento
                     &campozoom  = segmento
                     &campo2     = fi-desc-seg
                     &campozoom2 = descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-emitente-desc.segmento V-table-Win
ON LEAVE OF int-emitente-desc.segmento IN FRAME f-main /* Segmento */
DO:
  do with frame {&frame-name}:
      assign fi-desc-seg:screen-value = "".

      if input int-emitente-desc.segmento = "*"
      then assign fi-desc-seg:screen-value = "Todos".
      else for first fam-com-item no-lock
               where fam-com-item.fm-cod-com = input int-emitente-desc.segmento:
               assign fi-desc-seg:screen-value = trim(fam-com-item.descricao).
           end.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-emitente-desc.segmento V-table-Win
ON MOUSE-SELECT-DBLCLICK OF int-emitente-desc.segmento IN FRAME f-main /* Segmento */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
int-emitente-desc.nr-tabpre:load-mouse-pointer("image/lupa.cur")      in frame {&frame-name}.
int-emitente-desc.it-codigo:load-mouse-pointer("image/lupa.cur")      in frame {&frame-name}.
int-emitente-desc.cod-unid-negoc:load-mouse-pointer("image/lupa.cur") in frame {&frame-name}.
int-emitente-desc.segmento:load-mouse-pointer("image/lupa.cur")       in frame {&frame-name}.
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
  {src/adm/template/row-list.i "int-emitente-desc"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "int-emitente-desc"}

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
  find emitente where 
       rowid (emitente) = v-row-parent 
       no-lock no-error.

  if available emitente 
  then do with frame {&frame-name}:
           assign int-emitente-desc.cod-emitente:screen-value = string(emitente.cod-emitente)
                  fi-nome-emit:screen-value                   = trim(emitente.nome-emit).
       end.

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
    if not frame {&frame-name}:validate() then
                return 'ADM-ERROR':U.
    
    /*:T Ponha na pi-validate todas as validaá‰es */
    /*:T N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    run pi-validate.
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /*:T Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
/*   find emitente where rowid (emitente) = v-row-parent no-lock no-error. */
  if available emitente 
  then assign int-emitente-desc.cod-emitente = emitente.cod-emitente.


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
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  find emitente where
       rowid (emitente) = v-row-parent
       no-lock no-error.

  do with frame {&frame-name}:
      if avail emitente
      then assign fi-nome-emit:screen-value = trim(emitente.nome-emit).
    
      if avail int-emitente-desc
      then do:
           apply 'leave' to int-emitente-desc.nr-tabpre.
           apply 'leave' to int-emitente-desc.it-codigo.
           apply 'leave' to int-emitente-desc.cod-unid-negoc.
           apply 'leave' to int-emitente-desc.segmento.
      end.    
  end.

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
    /*if adm-new-record = yes then*/
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
    do with frame {&frame-name}:
        if adm-new-record
        then do:
             apply 'leave' to int-emitente-desc.nr-tabpre.
             apply 'leave' to int-emitente-desc.it-codigo.
             apply 'leave' to int-emitente-desc.cod-unid-negoc.
             apply 'leave' to int-emitente-desc.segmento.

             if can-find(first b-int-emitente-desc where
                               b-int-emitente-desc.cod-emitente   = input int-emitente-desc.cod-emitente
                           and b-int-emitente-desc.nr-tabpre      = input int-emitente-desc.nr-tabpre
                           and b-int-emitente-desc.cod-unid-negoc = input int-emitente-desc.cod-unid-negoc
                           and b-int-emitente-desc.segmento       = input int-emitente-desc.segmento
                           and b-int-emitente-desc.it-codigo      = input int-emitente-desc.it-codigo
                               no-lock)
             then do:
                  run utp/ut-msgs.p (input "show":U, input 17567, input "Registro j† existente!").
                  apply 'entry' to int-emitente-desc.nr-tabpre.
                  return 'ADM-ERROR':U.
             end.

             if input int-emitente-desc.nr-tabpre = ""
             or input int-emitente-desc.nr-tabpre = "*"
             then do:
                  run utp/ut-msgs.p (input "show":U, input 17567, input "Tab Preáo deve ser especificada!").
                  apply 'entry' to int-emitente-desc.nr-tabpre.
                  return 'ADM-ERROR':U.
             end.

             if not can-find(first tb-preco where
                                   tb-preco.nr-tabpre = input int-emitente-desc.nr-tabpre
                                   no-lock)
             then do:
                  run utp/ut-msgs.p (input "show":U, input 17567, input "Tab Preáo n∆o cadastrada!").
                  apply 'entry' to int-emitente-desc.nr-tabpre.
                  return 'ADM-ERROR':U.                  
             end.

             if input int-emitente-desc.it-codigo = ""
             then do:
                  run utp/ut-msgs.p (input "show":U, input 17567, input "Produto n∆o pode estar em branco!").
                  apply 'entry' to int-emitente-desc.it-codigo.
                  return 'ADM-ERROR':U.   
             end.

             if input int-emitente-desc.it-codigo <> "*"
             then if not can-find(first item where
                                        item.it-codigo = input int-emitente-desc.it-codigo
                                        no-lock)
                  then do:
                       run utp/ut-msgs.p (input "show":U, input 17567, input "Produto n∆o cadastrado!").
                       apply 'entry' to int-emitente-desc.it-codigo.
                       return 'ADM-ERROR':U.  
                  end.
                  else.
             else do:
                  if input int-emitente-desc.cod-unid-negoc = ""
                  then do:
                       run utp/ut-msgs.p (input "show":U, input 17567, input "Unid Neg deve ser informada!").
                       apply 'entry' to int-emitente-desc.cod-unid-negoc.
                       return 'ADM-ERROR':U.                        
                  end.

                  if input int-emitente-desc.segmento = ""
                  then do:
                       run utp/ut-msgs.p (input "show":U, input 17567, input "Segmento deve ser informado!").
                       apply 'entry' to int-emitente-desc.segmento.
                       return 'ADM-ERROR':U.                        
                  end.

                  if input int-emitente-desc.cod-unid-negoc <> "*"
                  then do:
                       if length(input int-emitente-desc.cod-unid-negoc) <> 2
                       then do:
                            run utp/ut-msgs.p (input "show":U, input 17567, input "Unidade Neg¢cio deve ter dois caracteres!").
                            apply 'entry' to int-emitente-desc.cod-unid-negoc.
                            return 'ADM-ERROR':U. 
                       end.

                       if not can-find(first fam-com-item where                                     
                                             fam-com-item.fm-cod-com = input int-emitente-desc.cod-unid-negoc
                                             no-lock)
                       then do:
                            run utp/ut-msgs.p (input "show":U, input 17567, input "Fam Com Item n∆o cadastrada!").
                            apply 'entry' to int-emitente-desc.cod-unid-negoc.
                            return 'ADM-ERROR':U.  
                       end.
                  end.

                  if input int-emitente-desc.segmento <> "*"
                  then do:
                       if length(input int-emitente-desc.segmento) <> 4
                       then do:
                            run utp/ut-msgs.p (input "show":U, input 17567, input "Segmento deve ter quatro caracteres!").
                            apply 'entry' to int-emitente-desc.segmento.
                            return 'ADM-ERROR':U. 
                       end.

                       if not can-find(first fam-com-item where                                     
                                             fam-com-item.fm-cod-com = input int-emitente-desc.segmento
                                             no-lock)
                       then do:
                            run utp/ut-msgs.p (input "show":U, input 17567, input "Fam Com Item n∆o cadastrada!").
                            apply 'entry' to int-emitente-desc.segmento.
                            return 'ADM-ERROR':U.  
                       end.
                  end.
             end. /* else do */
        end. /* if adm-new-record */

        if input int-emitente-desc.fator = 0
        then do:
             run utp/ut-msgs.p (input "show":U, input 17567, input "Fator deve ser informado!").
             apply 'entry' to int-emitente-desc.fator.
             return 'ADM-ERROR':U.              
        end.

        if input int-emitente-desc.dt-ini-val = ?
        then do:
             run utp/ut-msgs.p (input "show":U, input 17567, input "Dt Ini Validade deve ser informada!").
             apply 'entry' to int-emitente-desc.dt-ini-val.
             return 'ADM-ERROR':U.              
        end.

        if input int-emitente-desc.dt-ini-val < today
        then do:
             run utp/ut-msgs.p (input "show":U, input 17567, input "Dt Ini Validade n∆o deve ser anterior Ö data corrente!").
             apply 'entry' to int-emitente-desc.dt-ini-val.
             return 'ADM-ERROR':U.              
        end.

    end.

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
  {src/adm/template/snd-list.i "int-emitente-desc"}

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

