&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-ctb-tipo-verba NO-UNDO LIKE ctb-tipo-verba
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-tipo-verba NO-UNDO LIKE tipo-verba
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESUTP021B 1.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           ESUT021B
&GLOBAL-DEFINE Version           1.00.00.000

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           tt-ctb-tipo-verba
&GLOBAL-DEFINE hDBOTable         h-boes410
&GLOBAL-DEFINE DBOTable          ctb-tipo-verba

&GLOBAL-DEFINE ttParent          tt-tipo-verba
&GLOBAL-DEFINE DBOParentTable    h-boes407

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       tt-ctb-tipo-verba.ct-codigo tt-ctb-tipo-verba.cod_ccusto tt-ctb-tipo-verba.cod-unid-negoc tt-ctb-tipo-verba.cod-estabel
&GLOBAL-DEFINE page0ParentFields tt-tipo-verba.codigo tt-tipo-verba.descricao
&GLOBAL-DEFINE page1Fields       
&GLOBAL-DEFINE page2Fields       

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.

DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.

DEF VAR v_des_cta         AS CHARACTER FORMAT "x(40)" NO-UNDO.
DEF VAR v_num_tip_cta     AS INTEGER FORMAT ">9" NO-UNDO.
DEF VAR v_num_sit_cta     AS INTEGER FORMAT ">9" NO-UNDO.


DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
{utp/ut-glob.i}
{upc/btb910za-upc.i}

if not valid-handle(h_api_cta_ctbl) then 
    run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
if not valid-handle(h_api_ccusto) then 
    run prgint/utb/utb742za.py persistent set h_api_ccusto.

DEFINE TEMP-TABLE tt-unid-negoc NO-UNDO
    FIELD cod-unid-negoc AS CHARACTER
    FIELD descricao      AS CHARACTER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-tipo-verba.codigo tt-tipo-verba.descricao ~
tt-ctb-tipo-verba.cod-estabel tt-ctb-tipo-verba.cod-unid-negoc ~
tt-ctb-tipo-verba.cod_ccusto tt-ctb-tipo-verba.ct-codigo 
&Scoped-define ENABLED-TABLES tt-tipo-verba tt-ctb-tipo-verba
&Scoped-define FIRST-ENABLED-TABLE tt-tipo-verba
&Scoped-define SECOND-ENABLED-TABLE tt-ctb-tipo-verba
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar rtKeys-2 fi-desc-estabel ~
fi-desc-centrocusto fi-desc-conta btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-tipo-verba.codigo ~
tt-tipo-verba.descricao tt-ctb-tipo-verba.cod-estabel ~
tt-ctb-tipo-verba.cod-unid-negoc tt-ctb-tipo-verba.cod_ccusto ~
tt-ctb-tipo-verba.ct-codigo 
&Scoped-define DISPLAYED-TABLES tt-tipo-verba tt-ctb-tipo-verba
&Scoped-define FIRST-DISPLAYED-TABLE tt-tipo-verba
&Scoped-define SECOND-DISPLAYED-TABLE tt-ctb-tipo-verba
&Scoped-Define DISPLAYED-OBJECTS fi-desc-estabel fi-desc-centrocusto ~
fi-desc-conta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-desc-centrocusto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-conta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 58.57 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.75.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 4.71.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-tipo-verba.codigo AT ROW 1.42 COL 16.57 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 6.43 BY .88
     tt-tipo-verba.descricao AT ROW 1.42 COL 23.29 COLON-ALIGNED NO-LABEL WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 57.14 BY .88
     tt-ctb-tipo-verba.cod-estabel AT ROW 3.33 COL 16.57 COLON-ALIGNED WIDGET-ID 60
          VIEW-AS FILL-IN 
          SIZE 4.72 BY .88
     fi-desc-estabel AT ROW 3.33 COL 21.72 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     tt-ctb-tipo-verba.cod-unid-negoc AT ROW 4.33 COL 16.57 COLON-ALIGNED WIDGET-ID 58
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Item 1","Item 1"
          DROP-DOWN-LIST
          SIZE 39 BY 1
     tt-ctb-tipo-verba.cod_ccusto AT ROW 5.38 COL 16.57 COLON-ALIGNED WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 8.43 BY .88
     fi-desc-centrocusto AT ROW 5.38 COL 25.43 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     tt-ctb-tipo-verba.ct-codigo AT ROW 6.42 COL 16.57 COLON-ALIGNED WIDGET-ID 64
          VIEW-AS FILL-IN 
          SIZE 8.43 BY .88
     fi-desc-conta AT ROW 6.42 COL 25.43 COLON-ALIGNED NO-LABEL WIDGET-ID 66
     btOK AT ROW 8.29 COL 2
     btSave AT ROW 8.29 COL 13
     btCancel AT ROW 8.29 COL 24
     btHelp AT ROW 8.29 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 8.04 COL 1
     rtKeys-2 AT ROW 3.04 COL 1 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 8.67
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-ctb-tipo-verba T "?" NO-UNDO mgesp ctb-tipo-verba
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-tipo-verba T "?" NO-UNDO mgesp tipo-verba
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenanceNoNavigation ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 8.67
         WIDTH              = 90
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenanceNoNavigation 
/* ************************* Included-Libraries *********************** */

{maintenancenonavigation/maintenancenonavigation.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenanceNoNavigation
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenanceNoNavigation)
THEN wMaintenanceNoNavigation:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenanceNoNavigation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON END-ERROR OF wMaintenanceNoNavigation
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenanceNoNavigation
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenanceNoNavigation
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wMaintenanceNoNavigation
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    RUN saveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-ctb-tipo-verba.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-ctb-tipo-verba.cod-estabel wMaintenanceNoNavigation
ON F5 OF tt-ctb-tipo-verba.cod-estabel IN FRAME fpage0 /* Estab */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                        &campo=tt-ctb-tipo-verba.cod-estabel
                        &campozoom=cod-estabel
                        &campo2=fi-desc-estabel
                        &campozoom2=nome}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-ctb-tipo-verba.cod-estabel wMaintenanceNoNavigation
ON LEAVE OF tt-ctb-tipo-verba.cod-estabel IN FRAME fpage0 /* Estab */
DO:

    assign input frame fPage0 tt-ctb-tipo-verba.cod-estabel.

    {include/leave.i &tabela=estabelec
                    &atributo-ref=nome
                    &variavel-ref=fi-desc-estabel
                    &where="estabelec.cod-estabel = tt-ctb-tipo-verba.cod-estabel"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-ctb-tipo-verba.cod-estabel wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-ctb-tipo-verba.cod-estabel IN FRAME fpage0 /* Estab */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-ctb-tipo-verba.cod_ccusto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-ctb-tipo-verba.cod_ccusto wMaintenanceNoNavigation
ON F5 OF tt-ctb-tipo-verba.cod_ccusto IN FRAME fpage0 /* Centro Custo */
DO:
    assign v_ind_finalid_cta = "(nenhum)".

    run pi_zoom_ccusto in h_api_ccusto (INPUT "",
                                        INPUT "",
                                        INPUT "",
                                        INPUT today,
                                        OUTPUT v_cod_ccusto,
                                        OUTPUT v_des_titulo_ccusto,
                                        OUTPUT TABLE tt_log_erro).
    
   if v_cod_ccusto <> "" then
        ASSIGN SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_ccusto
               fi-desc-centrocusto:SCREEN-VALUE         = v_des_titulo_ccusto.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-ctb-tipo-verba.cod_ccusto wMaintenanceNoNavigation
ON LEAVE OF tt-ctb-tipo-verba.cod_ccusto IN FRAME fpage0 /* Centro Custo */
DO:
    DEFINE VARIABLE h-esapi015 AS HANDLE      NO-UNDO.
    
    assign input frame fPage0 tt-ctb-tipo-verba.cod_ccusto.

    /*{include/leave.i &tabela=sub-conta
                    &atributo-ref=descricao
                    &variavel-ref=fi-desc-centrocusto
                    &where="sub-conta.cod_ccusto = tt-ctb-tipo-verba.cod_ccusto"}  */
                    
    RUN esapi/esapi015.p PERSISTENT SET h-esapi015.
    RUN pi-retorna-cc IN h-esapi015 (INPUT  tt-ctb-tipo-verba.cod_ccusto,
                                     OUTPUT fi-desc-centrocusto).
    DELETE PROCEDURE h-esapi015.
    
    ASSIGN fi-desc-centrocusto:SCREEN-VALUE IN FRAME fPage0 = fi-desc-centrocusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-ctb-tipo-verba.cod_ccusto wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-ctb-tipo-verba.cod_ccusto IN FRAME fpage0 /* Centro Custo */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-ctb-tipo-verba.ct-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-ctb-tipo-verba.ct-codigo wMaintenanceNoNavigation
ON F5 OF tt-ctb-tipo-verba.ct-codigo IN FRAME fpage0 /* Conta */
DO:
    assign v_ind_finalid_cta = "(nenhum)".
    
    run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (INPUT i-ep-codigo-usuario,
                                                   INPUT "CEP",
                                                   INPUT "",
                                                   INPUT v_ind_finalid_cta,
                                                   INPUT TODAY,
                                                   OUTPUT v_cod_conta,
                                                   OUTPUT v_des_titulo_conta,
                                                   OUTPUT v_ind_finalid_cta,
                                                   OUTPUT TABLE tt_log_erro).
    
    IF NOT CAN-FIND(FIRST tt_log_erro) THEN DO:
        IF v_cod_conta <> "" THEN
            ASSIGN SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_conta
                   fi-desc-conta:SCREEN-VALUE = v_des_titulo_conta.

    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-ctb-tipo-verba.ct-codigo wMaintenanceNoNavigation
ON LEAVE OF tt-ctb-tipo-verba.ct-codigo IN FRAME fpage0 /* Conta */
DO:
  ASSIGN INPUT FRAME fPage0 tt-ctb-tipo-verba.ct-codigo.
  
  if tt-ctb-tipo-verba.ct-codigo = "" then return.

  run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        "",                /* EMPRESA EMS 2 */
                                                 input        "",                /* PLANO DE CONTAS */
                                                 input-output tt-ctb-tipo-verba.ct-codigo, /* CONTA */
                                                 input        today,             /* DATA TRANSACAO */   
                                                 output       v_des_cta,         /* DESCRICAO CONTA */
                                                 output       v_num_tip_cta,     /* TIPO DA CONTA */
                                                 output       v_num_sit_cta,     /* SITUA°€O DA CONTA */
                                                 output       v_ind_finalid_cta, /* FINALIDADES DA CONTA */
                                                 output table tt_log_erro). 

  if return-value <> "OK" then return.

  ASSIGN fi-desc-conta:SCREEN-VALUE = v_des_cta.

/*  run pi_verifica_utilizacao_ccusto in h_api_ccusto (INPUT "",
                                                     INPUT "",
                                                     INPUT "",
                                                     INPUT tt-ctb-tipo-verba.ct-codigo,
                                                     INPUT today,
                                                     OUTPUT p_log_ccusto,
                                                     OUTPUT TABLE tt_log_erro).

  ASSIGN tt-ctb-tipo-verba.cod_ccusto:SENSITIVE IN FRAME {&frame-name} = p_log_ccusto. 
  IF NOT p_log_ccusto THEN
      ASSIGN tt-ctb-tipo-verba.cod_ccusto:SCREEN-VALUE = ""
             fi-desc-centrocusto:SCREEN-VALUE = "". */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-ctb-tipo-verba.ct-codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-ctb-tipo-verba.ct-codigo IN FRAME fpage0 /* Conta */
DO:
    APPLY "f5" TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
tt-ctb-tipo-verba.cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-ctb-tipo-verba.ct-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage0.
tt-ctb-tipo-verba.cod_ccusto:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage0.
{maintenancenonavigation/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if avail tt-tipo-verba then do:
        apply 'leave' to tt-ctb-tipo-verba.cod_ccusto in frame fPage0.
        apply 'leave' to tt-ctb-tipo-verba.ct-codigo  in frame fPage0.
    end.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDisplayFields wMaintenanceNoNavigation 
PROCEDURE beforeDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN pi-carrega-unidades.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-unidades wMaintenanceNoNavigation 
PROCEDURE pi-carrega-unidades :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-desc AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE h-esapi015 AS HANDLE      NO-UNDO.

    FOR EACH tt-unid-negoc:
        DELETE tt-unid-negoc.
    END.
    
    RUN esapi/esapi015.p PERSISTENT SET h-esapi015.
    RUN pi-retorna-unidade IN h-esapi015 (OUTPUT TABLE tt-unid-negoc).
    DELETE PROCEDURE h-esapi015.

    ASSIGN tt-ctb-tipo-verba.cod-unid-negoc:LIST-ITEM-PAIRS IN FRAME fPage0 = ",".

    FOR EACH tt-unid-negoc BY tt-unid-negoc.cod-unid-negoc:
        ASSIGN c-desc = tt-unid-negoc.cod-unid-negoc + "-" + tt-unid-negoc.descricao.

        tt-ctb-tipo-verba.cod-unid-negoc:add-last(c-desc, tt-unid-negoc.cod-unid-negoc) IN FRAME fPage0 NO-ERROR.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*:T------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela filho ({&ttTable}) com base 
               nos campos da tabela pai ({&ttParent})
  Parameters:  
  Notes:       Este m‚todo somente ‚ executado quando a vari vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/
    
    assign tt-ctb-tipo-verba.codigo = tt-tipo-verba.codigo.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

