&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttint-cond-pag-cli NO-UNDO LIKE int-cond-pag-cli
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttint-cond-pag-cli-det NO-UNDO LIKE int-cond-pag-cli-det
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
{include/i-prgvrs.i ESACR070B 2.04.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           ESACR070B
&GLOBAL-DEFINE Version           1

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           ttint-cond-pag-cli-det
&GLOBAL-DEFINE hDBOTable         HDBOint-cond-pag-cli-det
&GLOBAL-DEFINE DBOTable          int-cond-pag-cli-det

&GLOBAL-DEFINE ttParent          ttint-cond-pag-cli
&GLOBAL-DEFINE DBOParentTable    int-cond-pag-cli

&GLOBAL-DEFINE page0KeyFields    /* ttconteudo-programa.sequencia */ ttint-cond-pag-cli.cod-emitente ttint-cond-pag-cli-det.cod-cond-pag ttint-cond-pag-cli-det.dt-ini-valid
&GLOBAL-DEFINE page0Fields       /* ttconteudo-programa.sequencia */ c-descricao-cond c-descricao ttint-cond-pag-cli-det.dt-fim-valid ttint-cond-pag-cli-det.observacao
&GLOBAL-DEFINE page0ParentFields ttint-cond-pag-cli.cod-emitente

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.

DEFINE VARIABLE wh-pesquisa                       AS HANDLE       NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl  AS HANDLE       NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttint-cond-pag-cli-det.observacao ~
ttint-cond-pag-cli-det.cod-cond-pagto ttint-cond-pag-cli-det.dt-ini-valid ~
ttint-cond-pag-cli-det.dt-fim-valid ttint-cond-pag-cli.cod-emitente 
&Scoped-define ENABLED-TABLES ttint-cond-pag-cli-det ttint-cond-pag-cli
&Scoped-define FIRST-ENABLED-TABLE ttint-cond-pag-cli-det
&Scoped-define SECOND-ENABLED-TABLE ttint-cond-pag-cli
&Scoped-Define ENABLED-OBJECTS c-descricao-cond btSave btCancel btOK btHelp ~
c-descricao rtKeys rtKeys-2 rtToolBar 
&Scoped-Define DISPLAYED-FIELDS ttint-cond-pag-cli-det.observacao ~
ttint-cond-pag-cli-det.cod-cond-pagto ttint-cond-pag-cli-det.dt-ini-valid ~
ttint-cond-pag-cli-det.dt-fim-valid ttint-cond-pag-cli.cod-emitente 
&Scoped-define DISPLAYED-TABLES ttint-cond-pag-cli-det ttint-cond-pag-cli
&Scoped-define FIRST-DISPLAYED-TABLE ttint-cond-pag-cli-det
&Scoped-define SECOND-DISPLAYED-TABLE ttint-cond-pag-cli
&Scoped-Define DISPLAYED-OBJECTS c-descricao-cond c-descricao 

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

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao-cond AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 59.43 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.5.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 8.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEF BUFFER b_histor_clien FOR histor_clien.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ttint-cond-pag-cli-det.observacao AT ROW 5.25 COL 14 NO-LABEL WIDGET-ID 16
          VIEW-AS EDITOR MAX-CHARS 1000 SCROLLBAR-VERTICAL
          SIZE 68 BY 4
     ttint-cond-pag-cli-det.cod-cond-pagto AT ROW 3.25 COL 12 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-descricao-cond AT ROW 3.25 COL 20.57 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     ttint-cond-pag-cli-det.dt-ini-valid AT ROW 4.25 COL 12 COLON-ALIGNED WIDGET-ID 14
          LABEL "Validade"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     ttint-cond-pag-cli-det.dt-fim-valid AT ROW 4.25 COL 24.43 COLON-ALIGNED NO-LABEL WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     btSave AT ROW 11.29 COL 13
     btCancel AT ROW 11.29 COL 24
     btOK AT ROW 11.29 COL 2
     btHelp AT ROW 11.29 COL 80
     ttint-cond-pag-cli.cod-emitente AT ROW 1.42 COL 12 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     c-descricao AT ROW 1.42 COL 21.57 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     "Observa‡Æo:" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 5.25 COL 5 WIDGET-ID 18
     rtKeys AT ROW 1.08 COL 1
     rtKeys-2 AT ROW 2.75 COL 1
     rtToolBar AT ROW 11.04 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 11.75
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttint-cond-pag-cli T "?" NO-UNDO mgesp int-cond-pag-cli
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttint-cond-pag-cli-det T "?" NO-UNDO mgesp int-cond-pag-cli-det
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
         HEIGHT             = 11.75
         WIDTH              = 90.86
         MAX-HEIGHT         = 29
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 29
         VIRTUAL-WIDTH      = 146.29
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
   FRAME-NAME Custom                                                    */
ASSIGN 
       c-descricao:READ-ONLY IN FRAME fpage0        = TRUE.

ASSIGN 
       c-descricao-cond:READ-ONLY IN FRAME fpage0        = TRUE.

ASSIGN 
       ttint-cond-pag-cli.cod-emitente:READ-ONLY IN FRAME fpage0        = TRUE.

/* SETTINGS FOR FILL-IN ttint-cond-pag-cli-det.dt-ini-valid IN FRAME fpage0
   EXP-LABEL                                                            */
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
    
    IF  RETURN-VALUE = "OK":U THEN DO:
        
        IF  AVAIL ttint-cond-pag-cli-det THEN DO:
        
            FIND FIRST emscad.cliente
                WHERE emscad.cliente.cod_empresa = "1"
                AND   emscad.cliente.cdn_cliente = ttint-cond-pag-cli-det.cod-emitente NO-LOCK NO-ERROR.
    
            IF  AVAIL emscad.cliente THEN DO:
                CREATE histor_clien. 
                ASSIGN histor_clien.cod_empresa      = emscad.cliente.cod_empresa
                       histor_clien.cdn_cliente      = emscad.cliente.cdn_cliente
                       histor_clien.dat_gerac_histor = TODAY
                       histor_clien.hra_gerac_histor = STRING(TIME,"hh:mm:ss")
                       histor_clien.cod_usuario      = v_cod_usuar_corren. 
    
                FIND LAST b_histor_clien NO-LOCK 
                    WHERE b_histor_clien.cod_empresa = histor_clien.cod_empresa
                    AND   b_histor_clien.cdn_cliente = histor_clien.cdn_cliente NO-ERROR.
    
                IF  AVAIL b_histor_clien THEN 
                    ASSIGN histor_clien.num_seq_histor_clien = b_histor_clien.num_seq_histor_clien + 1.
                ELSE 
                    ASSIGN histor_clien.num_seq_histor_clien = 1.
    
                ASSIGN histor_clien.des_abrev_histor_clien = "Condi‡Æo de pagamento: " + string(ttint-cond-pag-cli-det.cod-cond-pagto) + " criada !".
                       histor_clien.des_histor_clien       = "Condi‡Æo de pagamento: " + string(ttint-cond-pag-cli-det.cod-cond-pagto) + " criada (ESACR070) em "
                                                           + STRING(TODAY, "99/99/9999") + " pelo usu rio "  + v_cod_usuar_corren + " ." .
            END.
        END.

        APPLY "CLOSE":U TO THIS-PROCEDURE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:

    RUN saveRecord IN THIS-PROCEDURE.

    IF  AVAIL ttint-cond-pag-cli-det THEN DO:

        FIND FIRST emscad.cliente
            WHERE emscad.cliente.cod_empresa = "1"
            AND   emscad.cliente.cdn_cliente = ttint-cond-pag-cli-det.cod-emitente NO-LOCK NO-ERROR.

        IF  AVAIL emscad.cliente THEN DO:
            CREATE histor_clien. 
            ASSIGN histor_clien.cod_empresa      = emscad.cliente.cod_empresa
                   histor_clien.cdn_cliente      = emscad.cliente.cdn_cliente
                   histor_clien.dat_gerac_histor = TODAY
                   histor_clien.hra_gerac_histor = STRING(TIME,"hh:mm:ss")
                   histor_clien.cod_usuario      = v_cod_usuar_corren. 

            FIND LAST b_histor_clien NO-LOCK 
                WHERE b_histor_clien.cod_empresa = histor_clien.cod_empresa
                AND   b_histor_clien.cdn_cliente = histor_clien.cdn_cliente NO-ERROR.

            IF  AVAIL b_histor_clien THEN 
                ASSIGN histor_clien.num_seq_histor_clien = b_histor_clien.num_seq_histor_clien + 1.
            ELSE 
                ASSIGN histor_clien.num_seq_histor_clien = 1.

            ASSIGN histor_clien.des_abrev_histor_clien = "Condi‡Æo de pagamento: " + string(ttint-cond-pag-cli-det.cod-cond-pagto) + " criada !".
                   histor_clien.des_histor_clien       = "Condi‡Æo de pagamento: " + string(ttint-cond-pag-cli-det.cod-cond-pagto) + " criada (ESACR070) em "
                                                       + STRING(TODAY, "99/99/9999") + " pelo usu rio "  + v_cod_usuar_corren + " ." .
        END.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttint-cond-pag-cli-det.cod-cond-pagto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttint-cond-pag-cli-det.cod-cond-pagto wMaintenanceNoNavigation
ON LEAVE OF ttint-cond-pag-cli-det.cod-cond-pagto IN FRAME fpage0 /* Cond. Pagto */
DO:
  
    FIND FIRST cond-pagto NO-LOCK 
        WHERE cond-pagto.cod-cond-pag = INPUT FRAME fPage0 ttint-cond-pag-cli-det.cod-cond-pag NO-ERROR.
    ASSIGN c-descricao-cond = IF AVAIL cond-pagto THEN cond-pagto.descricao ELSE "":U.

    DISP c-descricao-cond WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttint-cond-pag-cli-det.cod-cond-pagto wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttint-cond-pag-cli-det.cod-cond-pagto IN FRAME fpage0 /* Cond. Pagto */
DO:
      {include/zoomvar.i &prog-zoom=adzoom/z01ad039.w
                       &campo=ttint-cond-pag-cli-det.cod-cond-pag
                       &campozoom=cod-cond-pag
                       &frame=fPage0
                       &campo2=c-descricao-cond
                       &campozoom2=descricao
                       &frame2=fPage0}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDisplayFields wMaintenanceNoNavigation 
PROCEDURE AfterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
      FIND emitente NO-LOCK                                                                               
          WHERE emitente.cod-emitente = int(ttint-cond-pag-cli.cod-emitente:SCREEN-VALUE IN FRAME fpage0 )
             NO-ERROR.                                                                                   
                                                             
      IF  AVAIL emitente THEN                                                                             
          ASSIGN c-descricao:SCREEN-VALUE IN FRAME fpage0 = emitente.nome-emit.                           
      ELSE                                                                                                
          ASSIGN c-descricao:SCREEN-VALUE IN FRAME fpage0 = "NÆo encontrado...".   

     APPLY "leave" TO ttint-cond-pag-cli-det.cod-cond-pag .

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

    ASSIGN ttint-cond-pag-cli-det.cod-emitente = ttint-cond-pag-cli.cod-emitente.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

