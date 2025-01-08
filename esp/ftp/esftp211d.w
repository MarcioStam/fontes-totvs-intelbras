&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgmov            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESFTP211D 1.00.00.001}

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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{esp/es0018.i}

DEF TEMP-TABLE tt-itens-docto LIKE wm-docto-itens.

DEF TEMP-TABLE tt-transfere-item
    FIELD cod-estabel AS CHAR
    FIELD cod-item    AS CHAR
    FIELD qtd-item    AS DEC.

DEF TEMP-TABLE tt-transfere-aloc
    FIELD cod-depos   AS CHAR
    FIELD it-codigo   AS CHAR
    FIELD cod-estabel AS CHAR.

DEF INPUT PARAM p-docto AS CHAR NO-UNDO.
DEF INPUT PARAM TABLE FOR tt-itens-docto.
DEF OUTPUT PARAM p-depos-entrada    AS CHAR NO-UNDO.
DEF OUTPUT PARAM p-retorno-cpapi001 AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME br-itens

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-itens-docto ord-prod

/* Definitions for BROWSE br-itens                                      */
&Scoped-define FIELDS-IN-QUERY-br-itens tt-itens-docto.num-seq-item tt-itens-docto.cod-item tt-itens-docto.cod-refer tt-itens-docto.dt-atualizacao tt-itens-docto.qtd-item   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-itens   
&Scoped-define SELF-NAME br-itens
&Scoped-define QUERY-STRING-br-itens FOR EACH tt-itens-docto INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-itens OPEN QUERY {&SELF-NAME} FOR EACH tt-itens-docto INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-itens tt-itens-docto
&Scoped-define FIRST-TABLE-IN-QUERY-br-itens tt-itens-docto


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-br-itens}
&Scoped-define QUERY-STRING-D-Dialog FOR EACH ord-prod SHARE-LOCK
&Scoped-define OPEN-QUERY-D-Dialog OPEN QUERY D-Dialog FOR EACH ord-prod SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-D-Dialog ord-prod
&Scoped-define FIRST-TABLE-IN-QUERY-D-Dialog ord-prod


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-buttom RECT-9 RECT-10 br-itens bt-ok ~
bt-cancela bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS fi-docto 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "&Ajuda" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE fi-docto AS CHARACTER FORMAT "X(16)" 
     LABEL "Numero Docto" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 68.72 BY 7.67.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 68.72 BY 1.42.

DEFINE RECTANGLE rt-buttom
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 68.57 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-itens FOR 
      tt-itens-docto SCROLLING.

DEFINE QUERY D-Dialog FOR 
      ord-prod SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-itens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-itens D-Dialog _FREEFORM
  QUERY br-itens NO-LOCK DISPLAY
      tt-itens-docto.num-seq-item FORMAT ">>>>>9":U
tt-itens-docto.cod-item FORMAT "X(16)":U
tt-itens-docto.cod-refer FORMAT "X(8)":U
tt-itens-docto.dt-atualizacao FORMAT "99/99/9999":U
tt-itens-docto.qtd-item FORMAT ">>>,>>>,>>9.9999":U WIDTH 14.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 67.14 BY 7.25
         TITLE "Itens do Documento" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     fi-docto AT ROW 1.29 COL 19.86 COLON-ALIGNED HELP
          "N£mero da Ordem de Produ‡Æo" WIDGET-ID 4
     br-itens AT ROW 2.75 COL 2 WIDGET-ID 200
     bt-ok AT ROW 10.63 COL 2.57
     bt-cancela AT ROW 10.63 COL 13.57
     bt-ajuda AT ROW 10.63 COL 58.57
     rt-buttom AT ROW 10.38 COL 1.43
     RECT-9 AT ROW 1.08 COL 1.29 WIDGET-ID 2
     RECT-10 AT ROW 2.58 COL 1.29 WIDGET-ID 6
     SPACE(0.00) SKIP(1.66)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "<insert SmartDialog title>"
         DEFAULT-BUTTON bt-ok WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/d-dialog.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME L-To-R                                                    */
/* BROWSE-TAB br-itens fi-docto D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fi-docto IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-itens
/* Query rebuild information for BROWSE br-itens
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-itens-docto INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE br-itens */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _TblList          = "mgmov.ord-prod"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* <insert SmartDialog title> */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda D-Dialog
ON CHOOSE OF bt-ajuda IN FRAME D-Dialog /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok D-Dialog
ON CHOOSE OF bt-ok IN FRAME D-Dialog /* OK */
DO:
    DEFINE VARIABLE h-acomp            AS HANDLE    NO-UNDO.
    DEFINE VARIABLE c-retorno-cpapi001 AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-depos-origem     AS CHARACTER NO-UNDO. 
    DEFINE VARIABLE c-depos-destino    AS CHARACTER NO-UNDO.

    FOR EACH tt-transfere-item: DELETE tt-transfere-item. END.
    FOR EACH tt-transfere-aloc: DELETE tt-transfere-aloc. END.

    ASSIGN fi-docto.

    run utp/ut-msgs.p (input "show":U,
                       input 27100,                                            
                       INPUT 'Realmente deseja transferir documento WMS ?').

    IF RETURN-VALUE <> 'yes' THEN
       RETURN NO-APPLY.

    FOR EACH tt-itens-docto:
        CREATE tt-transfere-item.
        BUFFER-COPY tt-itens-docto TO tt-transfere-item.
    END.


    RUN esp/es0018p.p (INPUT "esftp211":U,
                       INPUT 2,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).


    FIND FIRST tt-itens-docto NO-ERROR.

    IF AVAIL tt-itens-docto THEN DO:

       FIND FIRST wm-docto WHERE wm-docto.id-docto = tt-itens-docto.id-docto NO-LOCK NO-ERROR.
    
       IF AVAIL wm-docto THEN DO: 
          FOR EACH wm-docto-itens NO-LOCK
              WHERE wm-docto-itens.id-docto = wm-docto.id-docto,
              FIRST wm-local WHERE wm-local.cod-estabel = wm-docto-itens.cod-estabel
                               AND wm-local.cod-local   = wm-docto-itens.cod-local NO-LOCK: 

              IF wm-local.cod-deposito = 'PRO' THEN NEXT.

              FIND FIRST saldo-estoq 
                   WHERE saldo-estoq.cod-depos   = wm-local.cod-deposito
                     AND saldo-estoq.it-codigo   = wm-docto-itens.cod-item
                     AND saldo-estoq.cod-estabel = wm-docto-itens.cod-estabel
              EXCLUSIVE-LOCK NO-ERROR.
    
              IF AVAIL saldo-estoq THEN DO:
                 IF (saldo-estoq.qt-aloc-prod - wm-docto-itens.qtd-item) > 0 THEN DO:
                    ASSIGN saldo-estoq.qt-aloc-prod = saldo-estoq.qt-aloc-prod - wm-docto-itens.qtd-item.

                    CREATE tt-transfere-aloc.
                    ASSIGN tt-transfere-aloc.cod-depos   = saldo-estoq.cod-depos  
                           tt-transfere-aloc.it-codigo   = saldo-estoq.it-codigo  
                           tt-transfere-aloc.cod-estabel = saldo-estoq.cod-estabel.
                 END.
              END.
          END.                    
    
          FOR EACH tt-prog-ponto:
              IF entry(1,tt-prog-ponto.conteudo,';') = tt-itens-docto.cod-estabel THEN
                 ASSIGN c-depos-origem   = entry(2,tt-prog-ponto.conteudo,';')
                        c-depos-destino = entry(3,tt-prog-ponto.conteudo,';').
          END.                    

          RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
        
          RUN pi-inicializar IN h-acomp (INPUT "Transferindo").
        
          RUN pi-acompanhar IN h-acomp (INPUT "Fazendo Transferencia").
        
          RUN esp/ccp/esccp051.p (INPUT fi-docto,
                                  INPUT c-depos-origem,   //'WFT',
                                  INPUT c-depos-destino,  //'PRO',
                                  INPUT TABLE tt-transfere-item,
                                  OUTPUT c-retorno-cpapi001  ).
        
          RUN pi-acompanhar IN h-acomp (INPUT "Finalizada Transferencia").


          /* Erro de Transferencia */
          IF INDEX(c-retorno-cpapi001,'ERRO') <> 0 THEN DO:
             FOR EACH wm-docto-itens NO-LOCK
                 WHERE wm-docto-itens.id-docto = wm-docto.id-docto,
                 FIRST wm-local WHERE wm-local.cod-estabel = wm-docto-itens.cod-estabel
                                  AND wm-local.cod-local   = wm-docto-itens.cod-local NO-LOCK: 
                 FIND FIRST saldo-estoq 
                      WHERE saldo-estoq.cod-depos   = wm-local.cod-deposito
                        AND saldo-estoq.it-codigo   = wm-docto-itens.cod-item
                        AND saldo-estoq.cod-estabel = wm-docto-itens.cod-estabel
                 EXCLUSIVE-LOCK NO-ERROR.

                 IF AVAIL saldo-estoq THEN DO:

                    FIND FIRST tt-transfere-aloc
                         WHERE tt-transfere-aloc.cod-depos   = wm-local.cod-deposito
                           AND tt-transfere-aloc.it-codigo   = wm-docto-itens.cod-item
                           AND tt-transfere-aloc.cod-estabel = wm-docto-itens.cod-estabel
                    NO-ERROR.

                    IF AVAIL tt-transfere-aloc THEN
                       ASSIGN saldo-estoq.qt-aloc-prod = saldo-estoq.qt-aloc-prod + wm-docto-itens.qtd-item.
                 END.
             END.                    
          END.
        
          RUN pi-finalizar in h-acomp. 
                 
          ASSIGN p-depos-entrada    = c-depos-destino 
                 p-retorno-cpapi001 = c-retorno-cpapi001.
       END.
    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-itens
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY fi-docto 
      WITH FRAME D-Dialog.
  ENABLE rt-buttom RECT-9 RECT-10 br-itens bt-ok bt-cancela bt-ajuda 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy D-Dialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  {utp/ut9000.i "ESFTP211D" "1.00.00.001"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  ASSIGN fi-docto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = p-docto.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "ord-prod"}
  {src/adm/template/snd-list.i "tt-itens-docto"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
  
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

