&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgmov            PROGRESS
*/
&Scoped-define WINDOW-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadsim 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCCP034A 2.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> <m¢dulo>}
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
define variable wh-imprime as handle no-undo.

DEFINE INPUT PARAM p-action      AS CHAR.
DEFINE INPUT PARAM p-num-ordem   LIKE ordem-compra.numero-ordem.
DEFINE INPUT PARAM p-row-matriz  AS ROWID.
DEFINE INPUT PARAM p-ct-codigo   LIKE ordem-compra.ct-codigo.
DEFINE INPUT PARAM p-sc-codigo   LIKE ordem-compra.sc-codigo.
DEFINE INPUT PARAM p-perc-rateio LIKE matriz-rat-ordem.perc-rateio.
DEFINE INPUT PARAM p-narrativa   AS CHAR FORMAT "X(500)".
DEFINE INPUT PARAM p-cod-unid-negoc AS CHAR FORMAT "X(3)".

DEFINE VARIABLE de-percentual AS DECIMAL.

{upc/btb910za-upc.i}
IF NOT VALID-HANDLE (h_api_cta_ctbl) THEN
    run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
IF NOT VALID-HANDLE (h_api_ccusto) THEN
    run prgint/utb/utb742za.py persistent set h_api_ccusto.

def new global shared var v_rec_unid_negoc
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button c-ct-codigo c-sc-codigo ~
c-cod-unid-negoc d-perc-rateio c-narrativa bt-ok bt-cancela bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS i-num-ordem c-ct-codigo c-desc-ct-codigo ~
c-sc-codigo c-desc-sc-codigo c-cod-unid-negoc d-perc-rateio c-narrativa 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-cadsim AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-bt-ajuda 
       MENU-ITEM mi-sobre       LABEL "Sobre..."      .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "&Ajuda" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-imprime 
     LABEL "&Imprimir" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE c-narrativa AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 62.86 BY 4 NO-UNDO.

DEFINE VARIABLE c-cod-unid-negoc AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unid. Negoc." 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-ct-codigo LIKE ordem-compra.ct-codigo
     VIEW-AS FILL-IN 
     SIZE 21.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-ct-codigo AS CHARACTER FORMAT "X(80)":U 
     VIEW-AS FILL-IN 
     SIZE 41.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-sc-codigo AS CHARACTER FORMAT "X(80)":U 
     VIEW-AS FILL-IN 
     SIZE 41.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-sc-codigo LIKE ordem-compra.sc-codigo
     LABEL "Centro Custo" 
     VIEW-AS FILL-IN 
     SIZE 21.14 BY .88 NO-UNDO.

DEFINE VARIABLE d-perc-rateio LIKE matriz-rat-ordem.perc-rateio
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE i-num-ordem LIKE ordem-compra.numero-ordem
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 78 BY 1.38
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     i-num-ordem AT ROW 1.75 COL 12 COLON-ALIGNED HELP
          "" WIDGET-ID 2
     c-ct-codigo AT ROW 2.75 COL 12 COLON-ALIGNED HELP
          "" WIDGET-ID 4
     c-desc-ct-codigo AT ROW 2.75 COL 33.29 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     c-sc-codigo AT ROW 3.75 COL 12 COLON-ALIGNED HELP
          "" WIDGET-ID 6
          LABEL "Centro Custo"
     c-desc-sc-codigo AT ROW 3.75 COL 33.29 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     c-cod-unid-negoc AT ROW 4.75 COL 12 COLON-ALIGNED WIDGET-ID 20
     d-perc-rateio AT ROW 5.75 COL 12 COLON-ALIGNED HELP
          "Percentual de Rateio" WIDGET-ID 10
     c-narrativa AT ROW 6.75 COL 14.14 NO-LABEL WIDGET-ID 12
     bt-ok AT ROW 12.21 COL 3
     bt-cancela AT ROW 12.21 COL 14
     bt-imprime AT ROW 12.21 COL 25
     bt-ajuda AT ROW 12.21 COL 69
     "Narrativa:" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 6.83 COL 7 WIDGET-ID 14
     rt-button AT ROW 12 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 12.58
         FONT 7 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-cadsim ASSIGN
         HIDDEN             = YES
         TITLE              = "Manuten‡Æo <Insira o complemento>"
         HEIGHT             = 12.54
         WIDTH              = 80
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 114.29
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-cadsim 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-incsim.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-cadsim
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME L-To-R                                                    */
ASSIGN 
       bt-ajuda:POPUP-MENU IN FRAME f-cad       = MENU POPUP-MENU-bt-ajuda:HANDLE.

/* SETTINGS FOR BUTTON bt-imprime IN FRAME f-cad
   NO-ENABLE                                                            */
ASSIGN 
       bt-imprime:HIDDEN IN FRAME f-cad           = TRUE.

/* SETTINGS FOR FILL-IN c-ct-codigo IN FRAME f-cad
   LIKE = mgmov.ordem-compra.ct-codigo EXP-SIZE                         */
/* SETTINGS FOR FILL-IN c-desc-ct-codigo IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-sc-codigo IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-sc-codigo IN FRAME f-cad
   LIKE = mgmov.ordem-compra.sc-codigo EXP-LABEL                        */
/* SETTINGS FOR FILL-IN d-perc-rateio IN FRAME f-cad
   LIKE = mgmov.matriz-rat-ordem.perc-rateio EXP-SIZE                   */
/* SETTINGS FOR FILL-IN i-num-ordem IN FRAME f-cad
   NO-ENABLE LIKE = mgmov.ordem-compra.numero-ordem EXP-SIZE            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON END-ERROR OF w-cadsim /* Manuten‡Æo <Insira o complemento> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON WINDOW-CLOSE OF w-cadsim /* Manuten‡Æo <Insira o complemento> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-cadsim
ON CHOOSE OF bt-ajuda IN FRAME f-cad /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela w-cadsim
ON CHOOSE OF bt-cancela IN FRAME f-cad /* Cancelar */
DO:
  RUN notify ('cancel-record':U).
  APPLY "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-imprime
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-imprime w-cadsim
ON CHOOSE OF bt-imprime IN FRAME f-cad /* Imprimir */
DO:
run utp/ut-relat.w persistent set wh-imprime (input c-programa-mg97).
if valid-handle(wh-imprime) then
  run dispatch in wh-imprime ('initialize':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-cadsim
ON CHOOSE OF bt-ok IN FRAME f-cad /* OK */
DO:
    RUN pi-valida.
    IF RETURN-VALUE = "NOK" THEN
        RETURN NO-APPLY.

    IF p-action = "add" THEN DO:
        CREATE matriz-rat-ordem.
        ASSIGN matriz-rat-ordem.numero-ordem = i-num-ordem
               matriz-rat-ordem.sc-codigo    = c-sc-codigo
               matriz-rat-ordem.ct-codigo    = c-ct-codigo
               matriz-rat-ordem.perc-rateio  = d-perc-rateio
               matriz-rat-ordem.char-1       = c-narrativa
               overlay(matriz-rat-ordem.char-2,1,3) = c-cod-unid-negoc.
    END.
    ELSE DO:
        FIND FIRST matriz-rat-ordem EXCLUSIVE-LOCK
            WHERE ROWID(matriz-rat-ordem) = p-row-matriz NO-ERROR.

        IF AVAIL matriz-rat-ordem THEN DO:
            ASSIGN matriz-rat-ordem.numero-ordem = i-num-ordem  
                   matriz-rat-ordem.sc-codigo    = c-sc-codigo  
                   matriz-rat-ordem.ct-codigo    = c-ct-codigo  
                   matriz-rat-ordem.perc-rateio  = d-perc-rateio
                   matriz-rat-ordem.char-1       = c-narrativa
                   overlay(matriz-rat-ordem.char-2,1,3) = c-cod-unid-negoc. 
        END.
    END.

    apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-unid-negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-unid-negoc w-cadsim
ON F5 OF c-cod-unid-negoc IN FRAME f-cad /* Unid. Negoc. */
DO:
    run prgint/utb/utb011ka.p.
    if v_rec_unid_negoc <> ?
    then do:
        find first unid_negoc where recid(unid_negoc) = v_rec_unid_negoc no-lock no-error.
        assign c-cod-unid-negoc:SCREEN-VALUE IN FRAME f-cad = string(unid_negoc.cod_unid_negoc).
    end /* if */.
    apply "entry" to c-cod-unid-negoc in frame f-cad.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-unid-negoc w-cadsim
ON MOUSE-SELECT-DBLCLICK OF c-cod-unid-negoc IN FRAME f-cad /* Unid. Negoc. */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-ct-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-codigo w-cadsim
ON F5 OF c-ct-codigo IN FRAME f-cad /* Conta */
DO:
  assign v_ind_finalid_cta = "(nenhum)".
  run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (INPUT "",
                                                 INPUT "CEP",
                                                 INPUT "",
                                                 INPUT v_ind_finalid_cta,
                                                 INPUT TODAY,
                                                 OUTPUT v_cod_conta,
                                                 OUTPUT v_des_titulo_conta,
                                                 OUTPUT v_ind_finalid_cta,
                                                 OUTPUT TABLE tt_log_erro).    
      
      IF v_cod_conta <> "" THEN
          ASSIGN c-ct-codigo:SCREEN-VALUE IN FRAME f-cad = v_cod_conta.
                 c-desc-ct-codigo:SCREEN-VALUE IN FRAME f-cad = v_des_titulo_conta.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-codigo w-cadsim
ON LEAVE OF c-ct-codigo IN FRAME f-cad /* Conta */
DO:
  run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  "",                 /* EMPRESA EMS 2 */
                                                     input  "",                 /* ESTABELECIMENTO EMS2 */
                                                     input  "",                 /* PLANO CONTAS */
                                                     input  c-ct-codigo:SCREEN-VALUE IN FRAME f-cad,          /* CONTA */
                                                     input  today,              /* DT TRANSACAO */
                                                     output p_log_ccusto,    /* UTILIZA CCUSTO ? */
                                                     output table tt_log_erro). /* ERROS */

  IF NOT p_log_ccusto THEN DO:
      ASSIGN c-sc-codigo:SENSITIVE IN FRAME f-cad = NO
             c-desc-sc-codigo:SCREEN-VALUE IN FRAME f-cad = ""
             c-sc-codigo:SCREEN-VALUE IN FRAME f-cad = "".
  END.
  ELSE DO:
      ASSIGN c-sc-codigo:SENSITIVE IN FRAME f-cad = YES.
  END.

  RUN piDescConta IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-codigo w-cadsim
ON MOUSE-SELECT-DBLCLICK OF c-ct-codigo IN FRAME f-cad /* Conta */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-sc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-codigo w-cadsim
ON F5 OF c-sc-codigo IN FRAME f-cad /* Centro Custo */
DO:
  run pi_zoom_ccusto in h_api_ccusto (INPUT "",
                                      INPUT "",
                                      INPUT "",
                                      INPUT today,
                                      OUTPUT v_cod_ccusto,
                                      OUTPUT v_des_titulo_ccusto,
                                      OUTPUT TABLE tt_log_erro).
  
  if v_cod_ccusto <> "" then
      ASSIGN c-sc-codigo:SCREEN-VALUE IN FRAME f-cad = v_cod_ccusto
             c-desc-sc-codigo:SCREEN-VALUE IN FRAME f-cad = v_des_titulo_ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-codigo w-cadsim
ON LEAVE OF c-sc-codigo IN FRAME f-cad /* Centro Custo */
DO:
    RUN piDescCcusto IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-sc-codigo w-cadsim
ON MOUSE-SELECT-DBLCLICK OF c-sc-codigo IN FRAME f-cad /* Centro Custo */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-cadsim
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-cadsim 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-cadsim  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-cadsim  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-cadsim  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
  THEN DELETE WIDGET w-cadsim.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-cadsim  _DEFAULT-ENABLE
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
  DISPLAY i-num-ordem c-ct-codigo c-desc-ct-codigo c-sc-codigo c-desc-sc-codigo 
          c-cod-unid-negoc d-perc-rateio c-narrativa 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  ENABLE rt-button c-ct-codigo c-sc-codigo c-cod-unid-negoc d-perc-rateio 
         c-narrativa bt-ok bt-cancela bt-ajuda 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW w-cadsim.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-cadsim 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-cadsim 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-cadsim 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}

  {utp/ut9000.i "ESCCP034A" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  c-ct-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-cad.
  c-sc-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-cad.
  c-cod-unid-negoc:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME f-cad.
  
  ASSIGN i-num-ordem:SCREEN-VALUE IN FRAME f-cad = string(p-num-ordem)
         i-num-ordem = p-num-ordem.

  IF p-action = "mod" THEN DO:
      ASSIGN c-ct-codigo  :screen-value in frame f-cad = string(p-ct-codigo  )
             c-sc-codigo  :screen-value in frame f-cad = string(p-sc-codigo  )
             d-perc-rateio:screen-value in frame f-cad = string(p-perc-rateio)
             c-narrativa  :screen-value in frame f-cad = string(p-narrativa  )
             c-cod-unid-negoc:screen-value in frame f-cad = string(p-cod-unid-negoc  ).
  END.

  APPLY "leave" TO c-ct-codigo IN FRAME f-cad.
  APPLY "leave" TO c-sc-codigo IN FRAME f-cad.
  /* Code placed here will execute AFTER standard behavior.    */
 
  RUN dispatch  IN this-procedure ('enable-fields':U).

  {include/i-inifld.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida w-cadsim 
PROCEDURE pi-valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN INPUT FRAME f-cad i-num-ordem.    
ASSIGN INPUT FRAME f-cad c-sc-codigo.      
ASSIGN INPUT FRAME f-cad c-ct-codigo.      
ASSIGN INPUT FRAME f-cad d-perc-rateio.    
ASSIGN INPUT FRAME f-cad c-narrativa.   
ASSIGN INPUT FRAME f-cad c-cod-unid-negoc.   

FIND FIRST ordem-compra NO-LOCK
    WHERE ordem-compra.numero-ordem = i-num-ordem NO-ERROR.

/* IF NOT CAN-FIND (FIRST matriz-rat-ordem                                                                    */
/*                  WHERE matriz-rat-ordem.numero-ordem = ordem-compra.numero-ordem                           */
/*                    AND matriz-rat-ordem.ct-codigo    = ordem-compra.ct-codigo                              */
/*                    AND matriz-rat-ordem.sc-codigo    = ordem-compra.sc-codigo                              */
/*                    AND substring(matriz-rat-ordem.char-2,1,3)    = ordem-compra.cod-unid-negoc)            */
/*    AND (ordem-compra.ct-codigo <> c-ct-codigo                                                              */
/*      OR ordem-compra.sc-codigo <> c-sc-codigo                                                              */
/*      OR ordem-compra.cod-unid-negoc <> c-cod-unid-negoc) THEN DO:                                          */
/*                                                                                                            */
/*     RUN utp/ut-msgs.p (INPUT "show",                                                                       */
/*                        INPUT 17006,                                                                        */
/*                        INPUT "Conta e Centro de custo da matriz nao correspondem com a ordem de compra."). */
/*     RETURN "NOK".                                                                                          */
/* END.                                                                                                       */

IF p-action = "add" THEN DO:
    FIND FIRST matriz-rat-ordem NO-LOCK
        WHERE matriz-rat-ordem.numero-ordem = i-num-ordem 
          AND matriz-rat-ordem.ct-codigo = c-ct-codigo
          AND matriz-rat-ordem.sc-codigo = c-sc-codigo NO-ERROR.
    
    IF AVAIL matriz-rat-ordem THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT "8",
                           INPUT "Matriz de Rateio").
        RETURN "NOK".
    END.

    ASSIGN de-percentual = d-perc-rateio.
    FOR EACH matriz-rat-ordem NO-LOCK
        WHERE matriz-rat-ordem.numero-ordem = i-num-ordem:
        ASSIGN de-percentual =  de-percentual + matriz-rat-ordem.perc-rateio.
    END.

    IF de-percentual > 100 THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT "26997",
                           INPUT "").
        RETURN "NOK".
    END.
END.
ELSE DO:
    FIND FIRST matriz-rat-ordem NO-LOCK
         WHERE matriz-rat-ordem.numero-ordem = i-num-ordem 
           AND matriz-rat-ordem.ct-codigo = c-ct-codigo
           AND matriz-rat-ordem.sc-codigo = c-sc-codigo 
           AND ROWID(matriz-rat-ordem) <> p-row-matriz NO-ERROR.

    IF AVAIL matriz-rat-ordem THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT "8",
                           INPUT "Matriz de Rateio").
        RETURN "NOK".
    END.
END.

RUN pi_valida_conta_contabil in h_api_cta_ctbl (INPUT  "",                 /* EMPRESA EMS2 */
                                                INPUT  ordem-compra.cod-estabel,       /* ESTABELECIMENTO EMS2 */
                                                INPUT  c-cod-unid-negoc,   /* UNIDADE NEG…CIO */
                                                INPUT  "",                 /* PLANO CONTAS */ 
                                                INPUT  c-ct-codigo,        /* CONTA */
                                                INPUT  "",                 /* PLANO CCUSTO */ 
                                                INPUT  c-sc-codigo,        /* CCUSTO */
                                                INPUT  TODAY,              /* DATA TRANSACAO */
                                                OUTPUT TABLE tt_log_erro). /* ERROS */
FOR EACH tt_log_erro:
    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 17006,
                       INPUT tt_log_erro.ttv_des_msg_ajuda  + "~~" + tt_log_erro.ttv_des_msg_erro).
    RETURN "NOK".
END.

IF d-perc-rateio <= 0 THEN DO:
    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT "1470",
                       INPUT "").
    RETURN "NOK".
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDescCcusto w-cadsim 
PROCEDURE piDescCcusto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 run pi_busca_dados_ccusto in h_api_ccusto (input  i-ep-codigo-usuario, /* EMPRESA EMS2 */
                                            input  "",                  /* CODIGO DO PLANO CCUSTO */
                                            input  c-sc-codigo:SCREEN-VALUE IN FRAME f-cad,   /* CCUSTO */
                                            input  today,               /* DATA DE TRANSACAO */
                                            output v_des_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                            output table tt_log_erro).  /* ERROS */
    
    ASSIGN c-desc-sc-codigo:SCREEN-VALUE IN FRAME f-cad = v_des_titulo_ccusto.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDescConta w-cadsim 
PROCEDURE piDescConta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN v_cod_conta = c-ct-codigo:SCREEN-VALUE IN FRAME f-cad.

    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-ep-codigo-usuario,      /* EMPRESA EMS2 */
                                                   input        "",                       /* PLANO DE CONTAS */
                                                   input-output v_cod_conta,              /* CONTA */
                                                   input        TODAY,                    /* DATA TRANSACAO */   
                                                   output       v_des_titulo_conta,       /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl,       /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl,       /* SITUA°€O DA CONTA */
                                                   output       v_ind_finalid_cta,        /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).             /* ERROS */

    ASSIGN c-desc-ct-codigo:SCREEN-VALUE IN FRAME f-cad = v_des_titulo_conta.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-cadsim  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-cadsim 
PROCEDURE state-changed :
/*:T -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

