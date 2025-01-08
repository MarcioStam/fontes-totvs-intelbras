&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          tempheronlb      PROGRESS
*/
&Scoped-define WINDOW-NAME w-livre


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-ext-grupo NO-UNDO LIKE ext-grupo
       field r-Rowid as rowid.
DEFINE TEMP-TABLE tt-grup-estoque NO-UNDO LIKE grup-estoque
       field r-Rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-livre 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esrep038 1.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-descGrupo LIKE grup-estoque.descricao NO-UNDO.
DEFINE VARIABLE v_num_row_a AS INTEGER NO-UNDO.

/* Global Variable Definitions ---                                      */
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-livre
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad
&Scoped-define BROWSE-NAME brGrupoEstoque

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-grup-estoque tt-ext-grupo

/* Definitions for BROWSE brGrupoEstoque                                */
&Scoped-define FIELDS-IN-QUERY-brGrupoEstoque tt-grup-estoque.ge-codigo tt-grup-estoque.descricao   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brGrupoEstoque   
&Scoped-define SELF-NAME brGrupoEstoque
&Scoped-define QUERY-STRING-brGrupoEstoque FOR EACH tt-grup-estoque NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brGrupoEstoque OPEN QUERY {&SELF-NAME} FOR EACH tt-grup-estoque NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brGrupoEstoque tt-grup-estoque
&Scoped-define FIRST-TABLE-IN-QUERY-brGrupoEstoque tt-grup-estoque


/* Definitions for BROWSE brGrupoRE                                     */
&Scoped-define FIELDS-IN-QUERY-brGrupoRE tt-ext-grupo.ge-codigo fnDescricao(tt-ext-grupo.ge-codigo) @ c-descGrupo   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brGrupoRE   
&Scoped-define SELF-NAME brGrupoRE
&Scoped-define QUERY-STRING-brGrupoRE FOR EACH tt-ext-grupo NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brGrupoRE OPEN QUERY {&SELF-NAME} FOR EACH tt-ext-grupo NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brGrupoRE tt-ext-grupo
&Scoped-define FIRST-TABLE-IN-QUERY-brGrupoRE tt-ext-grupo


/* Definitions for FRAME f-cad                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-cad ~
    ~{&OPEN-QUERY-brGrupoEstoque}~
    ~{&OPEN-QUERY-brGrupoRE}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button brGrupoEstoque brGrupoRE ~
bt-add-all bt-add bt-del bt-del-all 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescricao w-livre 
FUNCTION fnDescricao RETURNS CHARACTER
  ( c-codigo AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-livre AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU mi-programa 
       MENU-ITEM mi-consultas   LABEL "Co&nsultas"     ACCELERATOR "CTRL-L"
              DISABLED
       MENU-ITEM mi-imprimir    LABEL "&Relat¢rios"    ACCELERATOR "CTRL-P"
              DISABLED
       RULE
       MENU-ITEM mi-sair        LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU m_Ajuda 
       MENU-ITEM mi-conteudo    LABEL "&Conteudo"     
       MENU-ITEM mi-sobre       LABEL "&Sobre..."     .

DEFINE MENU m-livre MENUBAR
       SUB-MENU  mi-programa    LABEL "ESREP038"      
       SUB-MENU  m_Ajuda        LABEL "&Ajuda"        .


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_p-exihel AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-add 
     IMAGE-UP FILE "image/toolbar/im-nex.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-nex.bmp":U
     LABEL "" 
     SIZE 5 BY 1.5.

DEFINE BUTTON bt-add-all 
     IMAGE-UP FILE "image/toolbar/im-las.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-las.bmp":U
     LABEL "" 
     SIZE 5 BY 1.5.

DEFINE BUTTON bt-del 
     IMAGE-UP FILE "image/toolbar/im-pre.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-pre.bmp":U
     LABEL "" 
     SIZE 5 BY 1.5.

DEFINE BUTTON bt-del-all 
     IMAGE-UP FILE "image/toolbar/im-fir.bmp":U
     IMAGE-INSENSITIVE FILE "image/toolbar/ii-fir.bmp":U
     LABEL "" 
     SIZE 5 BY 1.5.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 96 BY 1.46
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brGrupoEstoque FOR 
      tt-grup-estoque SCROLLING.

DEFINE QUERY brGrupoRE FOR 
      tt-ext-grupo SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brGrupoEstoque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brGrupoEstoque w-livre _FREEFORM
  QUERY brGrupoEstoque NO-LOCK DISPLAY
      tt-grup-estoque.ge-codigo FORMAT "99":U
      tt-grup-estoque.descricao FORMAT "x(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 46 BY 14.25
         FONT 1
         TITLE "Grupo Estoque" FIT-LAST-COLUMN.

DEFINE BROWSE brGrupoRE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brGrupoRE w-livre _FREEFORM
  QUERY brGrupoRE NO-LOCK DISPLAY
      tt-ext-grupo.ge-codigo FORMAT "99":U
      fnDescricao(tt-ext-grupo.ge-codigo) @ c-descGrupo COLUMN-LABEL "Descri‡Æo" FORMAT "x(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 43 BY 14.25
         FONT 1
         TITLE "Grupo Selecionado" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     brGrupoEstoque AT ROW 2.5 COL 1 WIDGET-ID 300
     brGrupoRE AT ROW 2.5 COL 54 WIDGET-ID 200
     bt-add-all AT ROW 6.08 COL 48 WIDGET-ID 6
     bt-add AT ROW 7.67 COL 48 WIDGET-ID 2
     bt-del AT ROW 9.29 COL 48 WIDGET-ID 4
     bt-del-all AT ROW 10.88 COL 48 WIDGET-ID 8
     rt-button AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 96.43 BY 15.92
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-livre
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-ext-grupo T "?" NO-UNDO tempHeronLB ext-grupo
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
      TABLE: tt-grup-estoque T "?" NO-UNDO mgcad grup-estoque
      ADDITIONAL-FIELDS:
          field r-Rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-livre ASSIGN
         HIDDEN             = YES
         TITLE              = "ESREP038"
         HEIGHT             = 15.96
         WIDTH              = 96.57
         MAX-HEIGHT         = 23.21
         MAX-WIDTH          = 110.57
         VIRTUAL-HEIGHT     = 23.21
         VIRTUAL-WIDTH      = 110.57
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU m-livre:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-livre 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-livre.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-livre
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME L-To-R                                                    */
/* BROWSE-TAB brGrupoEstoque rt-button f-cad */
/* BROWSE-TAB brGrupoRE brGrupoEstoque f-cad */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
THEN w-livre:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brGrupoEstoque
/* Query rebuild information for BROWSE brGrupoEstoque
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-grup-estoque NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brGrupoEstoque */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brGrupoRE
/* Query rebuild information for BROWSE brGrupoRE
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ext-grupo NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brGrupoRE */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON END-ERROR OF w-livre /* ESREP038 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON WINDOW-CLOSE OF w-livre /* ESREP038 */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-add w-livre
ON CHOOSE OF bt-add IN FRAME f-cad
DO:
    DO  v_num_row_a = 1 TO brGrupoEstoque:num-selected-rows IN FRAME {&FRAME-NAME}:
        if  brGrupoEstoque:fetch-selected-row(v_num_row_a) IN FRAME {&FRAME-NAME} then do:       
    
            IF  NOT CAN-FIND(FIRST ext-grupo
                             WHERE ext-grupo.ge-codigo = tt-grup-estoque.ge-codigo) THEN DO:
                CREATE ext-grupo.
                ASSIGN ext-grupo.ge-codigo             = tt-grup-estoque.ge-codigo
                       ext-grupo.cod_usuar_ult_atualiz = v_cod_usuar_corren
                       ext-grupo.dat_ult_atualiz       = TODAY
                       ext-grupo.hra_ult_atualiz       = replace(STRING(TIME, "HH:MM:SS":U), ":", "").

                DELETE tt-grup-estoque.

                CREATE tt-ext-grupo.
                BUFFER-COPY ext-grupo TO tt-ext-grupo.
            END. /* IF  NOT CAN-FIND(FIRST ext-grupo */
        END. /* if  brGrupoEstoque:fetch-selected-row(v_num_row_a) ... */
    END. /* do  v_num_row_a = 1 to browse brGrupoEstoque:num-selected-rows: ... */

    {&OPEN-QUERY-brGrupoEstoque}
    {&OPEN-QUERY-brGrupoRE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-add-all
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-add-all w-livre
ON CHOOSE OF bt-add-all IN FRAME f-cad
DO:
    FOR EACH tt-grup-estoque:
        CREATE ext-grupo.
        ASSIGN ext-grupo.ge-codigo             = tt-grup-estoque.ge-codigo
               ext-grupo.cod_usuar_ult_atualiz = v_cod_usuar_corren
               ext-grupo.dat_ult_atualiz       = TODAY
               ext-grupo.hra_ult_atualiz       = replace(STRING(TIME, "HH:MM:SS":U), ":", "").

        DELETE tt-grup-estoque.

        CREATE tt-ext-grupo.
        BUFFER-COPY ext-grupo TO tt-ext-grupo.
    END. /* FOR EACH tt-grup-estoque: */

    {&OPEN-QUERY-brGrupoEstoque}
    {&OPEN-QUERY-brGrupoRE}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-del w-livre
ON CHOOSE OF bt-del IN FRAME f-cad
DO:
    DO  v_num_row_a = 1 TO brGrupoRE:num-selected-rows IN FRAME {&FRAME-NAME}:
        if  brGrupoRE:fetch-selected-row(v_num_row_a) IN FRAME {&FRAME-NAME} then do: 
            
            IF  AVAIL tt-ext-grupo THEN do:
                 
                FIND FIRST ext-grupo EXCLUSIVE-LOCK
                    WHERE  ext-grupo.ge-codigo = tt-ext-grupo.ge-codigo NO-ERROR.
                IF  AVAIL  ext-grupo THEN DELETE ext-grupo.

                DELETE tt-ext-grupo.
            END.

            {&OPEN-QUERY-brGrupoRE}

            RUN pi-carregaTTsource.
            {&OPEN-QUERY-brGrupoEstoque}
        
        END. /* if  brGrupoEstoque ...*/
    END. /* DO  v_num_row_a ... */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-del-all
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-del-all w-livre
ON CHOOSE OF bt-del-all IN FRAME f-cad
DO:
    FOR EACH tt-ext-grupo:
                 
        FIND FIRST ext-grupo EXCLUSIVE-LOCK
            WHERE  ext-grupo.ge-codigo = tt-ext-grupo.ge-codigo NO-ERROR.
        IF  AVAIL  ext-grupo THEN DELETE ext-grupo.

        DELETE tt-ext-grupo.
    
    END. /* FOR EACH tt-ext-grupo: */

    {&OPEN-QUERY-brGrupoRE}

    RUN pi-carregaTTsource.
    {&OPEN-QUERY-brGrupoEstoque}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-consultas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-consultas w-livre
ON CHOOSE OF MENU-ITEM mi-consultas /* Consultas */
DO:
  RUN pi-consulta IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-conteudo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-conteudo w-livre
ON CHOOSE OF MENU-ITEM mi-conteudo /* Conteudo */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  RUN pi-ajuda IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-imprimir w-livre
ON CHOOSE OF MENU-ITEM mi-imprimir /* Relat¢rios */
DO:
  RUN pi-imprimir IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-programa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-programa w-livre
ON MENU-DROP OF MENU mi-programa /* ESREP038 */
DO:
  run pi-disable-menu.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sair w-livre
ON CHOOSE OF MENU-ITEM mi-sair /* Sair */
DO:
  RUN pi-sair IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-livre
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brGrupoEstoque
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-livre 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-livre  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'panel/p-exihel.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-exihel ).
       RUN set-position IN h_p-exihel ( 1.17 , 80.43 ) NO-ERROR.
       /* Size in UIB:  ( 1.25 , 16.00 ) */

       /* Links to SmartPanel h_p-exihel. */
       RUN add-link IN adm-broker-hdl ( h_p-exihel , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-exihel ,
             brGrupoEstoque:HANDLE IN FRAME f-cad , 'BEFORE':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-livre  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-livre  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
  THEN DELETE WIDGET w-livre.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-livre  _DEFAULT-ENABLE
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
  ENABLE rt-button brGrupoEstoque brGrupoRE bt-add-all bt-add bt-del bt-del-all 
      WITH FRAME f-cad IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW w-livre.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-livre 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-livre 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-livre 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  run pi-before-initialize.

  {include/win-size.i}

  {utp/ut9000.i "esrep038" "1.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  RUN pi-carregaTTsource.
  RUN pi-carregaTTtarget.

  /* Code placed here will execute AFTER standard behavior.    */

  run pi-after-initialize.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carregaTTsource w-livre 
PROCEDURE pi-carregaTTsource :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
   
    EMPTY TEMP-TABLE tt-grup-estoque NO-ERROR.

    FOR EACH grup-estoque NO-LOCK:
        IF  NOT CAN-FIND(FIRST ext-grupo
                         WHERE ext-grupo.ge-codigo = grup-estoque.ge-codigo) THEN DO:
            CREATE tt-grup-estoque.
            BUFFER-COPY grup-estoque TO tt-grup-estoque NO-ERROR.
        END. /* IF  NOT CAN-FIND(FIRST tt-ext-grupo */
    END. /* FOR EACH grup-estoque NO-LOCK: */

    {&OPEN-QUERY-brGrupoEstoque}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carregaTTtarget w-livre 
PROCEDURE pi-carregaTTtarget :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-ext-grupo NO-ERROR.
    FOR EACH ext-grupo NO-LOCK:
        IF  NOT CAN-FIND(FIRST tt-ext-grupo
                         WHERE tt-ext-grupo.ge-codigo = ext-grupo.ge-codigo) THEN DO:
            CREATE tt-ext-grupo.
            BUFFER-COPY ext-grupo TO tt-ext-grupo.
        END.
    END.

    {&OPEN-QUERY-brGrupoRE}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-livre  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-ext-grupo"}
  {src/adm/template/snd-list.i "tt-grup-estoque"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-livre 
PROCEDURE state-changed :
/*:T -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescricao w-livre 
FUNCTION fnDescricao RETURNS CHARACTER
  ( c-codigo AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FIND FIRST grup-estoque NO-LOCK
        WHERE  grup-estoque.ge-codigo = c-codigo NO-ERROR.
    IF  AVAIL  grup-estoque
    THEN RETURN grup-estoque.descricao.
    ELSE RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

