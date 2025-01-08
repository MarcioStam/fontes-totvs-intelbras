&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-cc-equipamentos NO-UNDO LIKE cc-equipamentos
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-equipamentos NO-UNDO LIKE equipamentos
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
{include/i-prgvrs.i ESUTP002C 1.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           ESUTO002C
&GLOBAL-DEFINE Version           1.00.00.001

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           tt-cc-equipamentos
&GLOBAL-DEFINE hDBOTable         h-boes410
&GLOBAL-DEFINE DBOTable          cc-equipamentos

&GLOBAL-DEFINE ttParent          tt-equipamentos
&GLOBAL-DEFINE DBOParentTable    h-boes407

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       tt-cc-equipamentos.cod-estabel-rateio tt-cc-equipamentos.cc-codigo tt-cc-equipamentos.per-rateio tt-cc-equipamentos.cod-unid-negoc
&GLOBAL-DEFINE page0ParentFields tt-equipamentos.cod-estabel tt-equipamentos.equipamento tt-equipamentos.descricao 
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

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
{upc/btb910za-upc.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-equipamentos.cod-estabel ~
tt-equipamentos.equipamento tt-equipamentos.descricao ~
tt-cc-equipamentos.cod-estabel-rateio tt-cc-equipamentos.cc-codigo ~
tt-cc-equipamentos.cod-unid-negoc tt-cc-equipamentos.per-rateio 
&Scoped-define ENABLED-TABLES tt-equipamentos tt-cc-equipamentos
&Scoped-define FIRST-ENABLED-TABLE tt-equipamentos
&Scoped-define SECOND-ENABLED-TABLE tt-cc-equipamentos
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar rtKeys-2 fi-desc-estabel ~
fi-desc-estab-rateio fi-desc-centrocusto v-des-unid-neg btOK btSave ~
btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-equipamentos.cod-estabel ~
tt-equipamentos.equipamento tt-equipamentos.descricao ~
tt-cc-equipamentos.cod-estabel-rateio tt-cc-equipamentos.cc-codigo ~
tt-cc-equipamentos.cod-unid-negoc tt-cc-equipamentos.per-rateio 
&Scoped-define DISPLAYED-TABLES tt-equipamentos tt-cc-equipamentos
&Scoped-define FIRST-DISPLAYED-TABLE tt-equipamentos
&Scoped-define SECOND-DISPLAYED-TABLE tt-cc-equipamentos
&Scoped-Define DISPLAYED-OBJECTS fi-desc-estabel fi-desc-estab-rateio ~
fi-desc-centrocusto v-des-unid-neg 

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
     SIZE 52 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-estab-rateio AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 52 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 59.72 BY .88 NO-UNDO.

DEFINE VARIABLE v-des-unid-neg AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 52 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.5.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-equipamentos.cod-estabel AT ROW 1.25 COL 16 COLON-ALIGNED WIDGET-ID 24
          LABEL "Estabelecimento"
          VIEW-AS FILL-IN 
          SIZE 4.72 BY .88
     fi-desc-estabel AT ROW 1.25 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     tt-equipamentos.equipamento AT ROW 2.25 COL 5.71 WIDGET-ID 26
          VIEW-AS FILL-IN 
          SIZE 22.57 BY .88
     tt-equipamentos.descricao AT ROW 2.25 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 41.72 BY .88
     tt-cc-equipamentos.cod-estabel-rateio AT ROW 4.08 COL 16 COLON-ALIGNED WIDGET-ID 42
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     fi-desc-estab-rateio AT ROW 4.08 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     tt-cc-equipamentos.cc-codigo AT ROW 5.08 COL 16 COLON-ALIGNED WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     fi-desc-centrocusto AT ROW 5.08 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     tt-cc-equipamentos.cod-unid-negoc AT ROW 6.08 COL 16 COLON-ALIGNED WIDGET-ID 38
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     v-des-unid-neg AT ROW 6.08 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     tt-cc-equipamentos.per-rateio AT ROW 7.08 COL 16 COLON-ALIGNED WIDGET-ID 36
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     btOK AT ROW 9 COL 2
     btSave AT ROW 9 COL 13
     btCancel AT ROW 9 COL 24
     btHelp AT ROW 9 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 8.75 COL 1
     rtKeys-2 AT ROW 3.75 COL 1 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 9.25
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-cc-equipamentos T "?" NO-UNDO mgesp cc-equipamentos
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-equipamentos T "?" NO-UNDO mgesp equipamentos
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
         HEIGHT             = 9.25
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
/* SETTINGS FOR FILL-IN tt-equipamentos.cod-estabel IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-equipamentos.equipamento IN FRAME fpage0
   ALIGN-L                                                              */
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


&Scoped-define SELF-NAME tt-cc-equipamentos.cc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-cc-equipamentos.cc-codigo wMaintenanceNoNavigation
ON F5 OF tt-cc-equipamentos.cc-codigo IN FRAME fpage0 /* Centro Custo */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in042.w
                        &campo=tt-cc-equipamentos.cc-codigo
                        &campozoom=cc-codigo
                        &campo2=fi-desc-centrocusto
                        &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-cc-equipamentos.cc-codigo wMaintenanceNoNavigation
ON LEAVE OF tt-cc-equipamentos.cc-codigo IN FRAME fpage0 /* Centro Custo */
DO:
    assign input frame fPage0 tt-cc-equipamentos.cc-codigo.

    EMPTY TEMP-TABLE tt_log_erro.
    run prgint\utb\utb742za.py persistent set h_api_ccusto.
        
    run pi_busca_dados_ccusto in h_api_ccusto (input  i-ep-codigo-usuario,          /* EMPRESA EMS2 */
                                               input  "",                           /* CODIGO DO PLANO CCUSTO */
                                               input  tt-cc-equipamentos.cc-codigo, /* CCUSTO */
                                               input  today,                        /* DATA DE TRANSACAO */
                                               output v_des_titulo_ccusto,          /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro).           /* ERROS */
    delete object h_api_ccusto.

    DISP v_des_titulo_ccusto @ fi-desc-centrocusto WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-cc-equipamentos.cc-codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-cc-equipamentos.cc-codigo IN FRAME fpage0 /* Centro Custo */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-equipamentos.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-equipamentos.cod-estabel wMaintenanceNoNavigation
ON LEAVE OF tt-equipamentos.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:

    assign input frame fPage0 tt-equipamentos.cod-estabel.

    {include/leave.i &tabela=estabelec
                    &atributo-ref=nome
                    &variavel-ref=fi-desc-estabel
                    &where="estabelec.cod-estabel = tt-equipamentos.cod-estabel"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-cc-equipamentos.cod-estabel-rateio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-cc-equipamentos.cod-estabel-rateio wMaintenanceNoNavigation
ON LEAVE OF tt-cc-equipamentos.cod-estabel-rateio IN FRAME fpage0 /* Estab Rateio */
DO:
  assign input frame fPage0 tt-cc-equipamentos.cod-estabel-rateio.

    {include/leave.i &tabela=estabelec
                     &atributo-ref=nome
                     &variavel-ref=fi-desc-estab-rateio
                     &where="estabelec.cod-estabel = tt-cc-equipamentos.cod-estabel-rateio"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-cc-equipamentos.cod-unid-negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-cc-equipamentos.cod-unid-negoc wMaintenanceNoNavigation
ON F5 OF tt-cc-equipamentos.cod-unid-negoc IN FRAME fpage0 /* Unidade Neg¢cio */
DO:
    {method/ZoomFields.i &ProgramZoom="inzoom/z01in745.w"
                         &FieldZoom1="cod-unid-negoc"
                         &FieldScreen1="tt-cc-equipamentos.cod-unid-negoc"
                         &Frame1="fPage0"
                         &FieldZoom2="des-unid-negoc"
                         &FieldScreen2="v-des-unid-neg"
                         &Frame2="fPage0"
                         &EnableImplant="no"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-cc-equipamentos.cod-unid-negoc wMaintenanceNoNavigation
ON LEAVE OF tt-cc-equipamentos.cod-unid-negoc IN FRAME fpage0 /* Unidade Neg¢cio */
DO:
    FIND FIRST unid_negoc NO-LOCK
         WHERE unid_negoc.cod_unid_negoc = INPUT FRAME {&FRAME-NAME} {&SELF-NAME} NO-ERROR.
    ASSIGN v-des-unid-neg = IF AVAILABLE unid_negoc THEN unid_negoc.des_unid_negoc ELSE ''.
    DISPLAY v-des-unid-neg WITH FRAME {&FRAME-NAME}.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-cc-equipamentos.cod-unid-negoc wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-cc-equipamentos.cod-unid-negoc IN FRAME fpage0 /* Unidade Neg¢cio */
DO:
    APPLY "F5" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
tt-cc-equipamentos.cc-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U)      IN FRAME fPage0.
tt-cc-equipamentos.cod-unid-negoc:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0. 
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
    DEFINE VARIABLE dePerRateioTotal AS DECIMAL     NO-UNDO.

    if avail tt-equipamentos then do:
        apply 'leave' to tt-equipamentos.cod-estabel in frame fPage0.
        apply 'leave' to tt-cc-equipamentos.cc-codigo in frame fPage0.
    end.

    IF pcAction = "ADD":U  OR
       pcAction = "COPY":U THEN DO:
        ASSIGN dePerRateioTotal = 0.

        FOR EACH cc-equipamentos NO-LOCK
            WHERE cc-equipamentos.cod-estabel = tt-equipamentos.cod-estabel
              AND cc-equipamentos.equipamento = tt-equipamentos.equipamento:
            ASSIGN dePerRateioTotal = dePerRateioTotal + cc-equipamentos.per-rateio.
        END.

        IF dePerRateioTotal < 100 THEN
            ASSIGN tt-cc-equipamentos.per-rateio = 100 - dePerRateioTotal.
        ELSE
            ASSIGN tt-cc-equipamentos.per-rateio = 0.

        ASSIGN tt-cc-equipamentos.cod-estabel-rateio = tt-equipamentos.cod-estabel.

        DISPLAY tt-cc-equipamentos.per-rateio
                tt-cc-equipamentos.cod-estabel-rateio
            WITH FRAME fPage0.

        APPLY "leave" TO tt-cc-equipamentos.cod-estabel-rateio IN FRAME fPage0.
    END.

    RETURN "OK":U.

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
    IF pcAction = "ADD":U  OR
       pcAction = "COPY":U THEN
        ASSIGN tt-cc-equipamentos.cod-estabel = tt-equipamentos.cod-estabel
               tt-cc-equipamentos.equipamento = tt-equipamentos.equipamento.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

