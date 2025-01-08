&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-window 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESSDCV005a 2.06.00.000}

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
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

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-acomp AS HANDLE NO-UNDO.

/* Temp-table Definitions ---                                           */
DEFINE TEMP-TABLE tt-ccusto NO-UNDO
    FIELD cod_plano_ccusto   LIKE plano_ccusto.cod_plano_ccusto 
    FIELD cod_ccusto         LIKE emscad.ccusto_unid_negoc.cod_ccusto
    FIELD des_ccusto         LIKE emscad.ccusto.des_tit_ctbl
    FIELD cod_unid_negoc     LIKE emscad.ccusto_unid_negoc.cod_unid_negoc.

DEFINE TEMP-TABLE tt-ccusto-aux NO-UNDO LIKE tt-ccusto.

/* Parameters Definitions ---                                           */
define input parameter pcod_plano_cta_ctbl LIKE cta_ctbl.cod_plano_cta_ctbl no-undo.
define input parameter pcod_cta_ctbl       LIKE cta_ctbl.cod_cta_ctbl       no-undo.
define input parameter pdes_cta_ctbl       LIKE cta_ctbl.des_tit_ctbl       no-undo.
define input parameter table for tt-ccusto.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE JanelaDetalhe
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br-ccusto

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-ccusto-aux

/* Definitions for BROWSE br-ccusto                                     */
&Scoped-define FIELDS-IN-QUERY-br-ccusto tt-ccusto-aux.cod_ccusto tt-ccusto-aux.des_ccusto   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-ccusto   
&Scoped-define SELF-NAME br-ccusto
&Scoped-define QUERY-STRING-br-ccusto FOR EACH tt-ccusto-aux
&Scoped-define OPEN-QUERY-br-ccusto OPEN QUERY {&SELF-NAME} FOR EACH tt-ccusto-aux.
&Scoped-define TABLES-IN-QUERY-br-ccusto tt-ccusto-aux
&Scoped-define FIRST-TABLE-IN-QUERY-br-ccusto tt-ccusto-aux


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-br-ccusto}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 br-ccusto bt-ok 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-window AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 52 BY 1.38
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-ccusto FOR 
      tt-ccusto-aux SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-ccusto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-ccusto w-window _FREEFORM
  QUERY br-ccusto DISPLAY
      tt-ccusto-aux.cod_ccusto     COLUMN-LABEL "Centro Custo   " WIDTH 5
    tt-ccusto-aux.des_ccusto     COLUMN-LABEL "T°tulo CC"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 52 BY 12.25
         FONT 1
         TITLE "Centro Custo" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br-ccusto AT ROW 1.25 COL 53 RIGHT-ALIGNED WIDGET-ID 200
     bt-ok AT ROW 13.88 COL 2.86
     RECT-1 AT ROW 13.67 COL 53 RIGHT-ALIGNED
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 53.43 BY 14.17
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: JanelaDetalhe
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-window ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 14.25
         WIDTH              = 53.86
         MAX-HEIGHT         = 22.5
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22.5
         VIRTUAL-WIDTH      = 114.29
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-window 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-window.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-window
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB br-ccusto RECT-1 F-Main */
/* SETTINGS FOR BROWSE br-ccusto IN FRAME F-Main
   ALIGN-R                                                              */
ASSIGN 
       br-ccusto:COLUMN-RESIZABLE IN FRAME F-Main       = TRUE
       br-ccusto:COLUMN-MOVABLE IN FRAME F-Main         = TRUE.

/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME F-Main
   ALIGN-R                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
THEN w-window:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-ccusto
/* Query rebuild information for BROWSE br-ccusto
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ccusto-aux
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-ccusto */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON END-ERROR OF w-window
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON WINDOW-CLOSE OF w-window
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-ccusto
&Scoped-define SELF-NAME br-ccusto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-ccusto w-window
ON MOUSE-SELECT-DBLCLICK OF br-ccusto IN FRAME F-Main /* Centro Custo */
DO:
  APPLY "return" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-window
ON CHOOSE OF bt-ok IN FRAME F-Main /* Fechar */
DO:
  apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-window 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-window  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-window  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-window  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
  THEN DELETE WIDGET w-window.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-window  _DEFAULT-ENABLE
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
  ENABLE RECT-1 br-ccusto bt-ok 
      WITH FRAME F-Main IN WINDOW w-window.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW w-window.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-window 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-window 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-window 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}
  
  {utp/ut9000.i "ESSDCV005a" "2.06.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  IF  can-find(FIRST tt-ccusto) THEN do:
      RUN pi-carrega-ccusto.
      {&OPEN-QUERY-br-ccusto}
  END. /* IF  can-find(FIRST tt-ccusto) THEN do: */

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-ccusto w-window 
PROCEDURE pi-carrega-ccusto :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT 'Carregando centro custo ...').

FOR EACH  criter_distrib_cta_ctbl NO-LOCK           
    WHERE criter_distrib_cta_ctbl.cod_plano_cta_ctbl = pcod_plano_cta_ctbl
    AND   criter_distrib_cta_ctbl.cod_cta_ctbl       = pcod_cta_ctbl:

    IF   criter_distrib_cta_ctbl.cod_estab = '102' /* Estabelecimento descontinuado */                           
    OR   criter_distrib_cta_ctbl.cod_estab > '106' /* Estabelecimentos n∆o considerados no momento */ THEN NEXT. 

    IF   criter_distrib_cta_ctbl.dat_inic_valid > TODAY
    OR   criter_distrib_cta_ctbl.dat_fim_valid  < TODAY THEN NEXT.

    CASE criter_distrib_cta_ctbl.ind_criter_distrib_ccusto:
        WHEN "N∆o Utiliza":U THEN EMPTY TEMP-TABLE tt-ccusto-aux NO-ERROR.
        WHEN "Utiliza Todos":U THEN DO:
            EMPTY TEMP-TABLE tt-ccusto-aux NO-ERROR.

            FOR EACH tt-ccusto:

                IF  VALID-HANDLE(h-acomp) 
                THEN RUN pi-acompanhar IN h-acomp (INPUT string(tt-ccusto.cod_ccusto) + "/" + STRING(tt-ccusto.des_ccusto)).

                FIND FIRST tt-ccusto-aux 
                    WHERE  tt-ccusto-aux.cod_ccusto = tt-ccusto.cod_ccusto NO-ERROR.
                IF  NOT AVAIL tt-ccusto-aux THEN DO:
                    CREATE tt-ccusto-aux.                  
                    BUFFER-COPY tt-ccusto TO tt-ccusto-aux.
                END. /* IF  NOT AVAIL tt-ccusto-aux THEN DO: */
            END. /* FOR EACH tt-ccusto: */

        END. /* WHEN "Utiliza Todos":U THEN DO: */
        WHEN "Definidos":U THEN DO:
            EMPTY TEMP-TABLE tt-ccusto-aux NO-ERROR.

            FOR EACH  item_lista_ccusto NO-LOCK                                                                  
                WHERE item_lista_ccusto.cod_empresa             = v_cod_empres_usuar                             
                AND   item_lista_ccusto.cod_estab               = criter_distrib_cta_ctbl.cod_estab              
                AND   item_lista_ccusto.cod_mapa_distrib_ccusto = criter_distrib_cta_ctbl.cod_mapa_distrib_ccusto,
                FIRST cc_uni_estab NO-LOCK
                WHERE cc_uni_estab.cod_ccusto = item_lista_ccusto.cod_ccusto
                AND   cc_uni_estab.cod_estab  = item_lista_ccusto.cod_estab,
                FIRST tt-ccusto NO-LOCK 
                WHERE tt-ccusto.cod_ccusto       = cc_uni_estab.cod_ccusto:

                IF  item_lista_ccusto.cod_estab = "102" /* Estabelecimento descontinuado */                           
                OR  item_lista_ccusto.cod_estab > "106" /* Estabelecimentos n∆o considerados no momento */ THEN NEXT. 

                IF  VALID-HANDLE(h-acomp) 
                THEN RUN pi-acompanhar IN h-acomp (INPUT string(tt-ccusto.cod_ccusto) + "/" + STRING(tt-ccusto.des_ccusto)).
                
                FIND FIRST tt-ccusto-aux 
                    WHERE  tt-ccusto-aux.cod_ccusto = tt-ccusto.cod_ccusto NO-ERROR.
                IF  NOT AVAIL tt-ccusto-aux THEN DO:
                    CREATE tt-ccusto-aux.                  
                    BUFFER-COPY tt-ccusto TO tt-ccusto-aux.
                END. /* IF  NOT AVAIL tt-ccusto-aux THEN DO: */
            END. /* FOR FIRST mapa_distrib_ccusto NO-LOCK */
        END. /* WHEN "Definidos":U THEN DO: */
    END CASE.
END. /* FOR EACH  plano_cta_ctbl NO-LOCK */

RUN pi-finalizar IN h-acomp.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-window  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-ccusto-aux"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-window 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

