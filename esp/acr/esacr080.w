&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esacr080 1.00.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esacr080
&GLOBAL-DEFINE Version        1.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         no
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define new global shared variable adm-broker-hdl as handle       no-undo.
define variable wh-pesquisa as handle       no-undo.

def new global shared var v_rec_espec_docto_financ_acr
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-concil-financ.dir-arq-recebidos-an ~
param-concil-financ.dir-arq-importados-an ~
param-concil-financ.dir-arq-log-an ~
param-concil-financ.dir-arq-recebidos-liq ~
param-concil-financ.dir-arq-importados-liq ~
param-concil-financ.dir-arq-log-liq param-concil-financ.cod-espec-docto ~
param-concil-financ.cod-ser-docto param-concil-financ.cod-parcela 
&Scoped-define ENABLED-TABLES param-concil-financ
&Scoped-define FIRST-ENABLED-TABLE param-concil-financ
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-1 RECT-2 RECT-3 ~
tg-efetiva-liquidacao btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-FIELDS param-concil-financ.dir-arq-recebidos-an ~
param-concil-financ.dir-arq-importados-an ~
param-concil-financ.dir-arq-log-an ~
param-concil-financ.dir-arq-recebidos-liq ~
param-concil-financ.dir-arq-importados-liq ~
param-concil-financ.dir-arq-log-liq param-concil-financ.cod-espec-docto ~
param-concil-financ.cod-ser-docto param-concil-financ.cod-parcela 
&Scoped-define DISPLAYED-TABLES param-concil-financ
&Scoped-define FIRST-DISPLAYED-TABLE param-concil-financ
&Scoped-Define DISPLAYED-OBJECTS fi-desc-especie tg-efetiva-liquidacao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-desc-especie AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.72 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 4.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 4.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 4.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tg-efetiva-liquidacao AS LOGICAL INITIAL no 
     LABEL "Efetiva Liquida‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     param-concil-financ.dir-arq-recebidos-an AT ROW 2.25 COL 3.57 WIDGET-ID 68
          VIEW-AS FILL-IN 
          SIZE 68 BY .88
     param-concil-financ.dir-arq-importados-an AT ROW 3.25 COL 3.43 WIDGET-ID 60
          VIEW-AS FILL-IN 
          SIZE 68 BY .88
     param-concil-financ.dir-arq-log-an AT ROW 4.25 COL 8.28 WIDGET-ID 64
          VIEW-AS FILL-IN 
          SIZE 68 BY .88
     param-concil-financ.dir-arq-recebidos-liq AT ROW 6.75 COL 3.57 WIDGET-ID 70
          VIEW-AS FILL-IN 
          SIZE 68 BY .88
     param-concil-financ.dir-arq-importados-liq AT ROW 7.75 COL 3.43 WIDGET-ID 62
          VIEW-AS FILL-IN 
          SIZE 68 BY .88
     param-concil-financ.dir-arq-log-liq AT ROW 8.75 COL 8.28 WIDGET-ID 66
          VIEW-AS FILL-IN 
          SIZE 68 BY .88
     param-concil-financ.cod-espec-docto AT ROW 11.25 COL 16 COLON-ALIGNED WIDGET-ID 54
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     fi-desc-especie AT ROW 11.25 COL 21.29 COLON-ALIGNED NO-LABEL WIDGET-ID 84
     tg-efetiva-liquidacao AT ROW 11.25 COL 71 WIDGET-ID 90
     param-concil-financ.cod-ser-docto AT ROW 12.25 COL 16 COLON-ALIGNED WIDGET-ID 58
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     param-concil-financ.cod-parcela AT ROW 13.25 COL 16 COLON-ALIGNED WIDGET-ID 56
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     btOK AT ROW 17.25 COL 2
     btCancel AT ROW 17.25 COL 13
     btHelp2 AT ROW 17.25 COL 80
     "Parƒmetros Gerais:" VIEW-AS TEXT
          SIZE 13 BY .54 AT ROW 10.25 COL 7 WIDGET-ID 82
     "Diret¢rios Importa‡Æo Antecipa‡Æo:" VIEW-AS TEXT
          SIZE 24 BY .54 AT ROW 1.25 COL 7 WIDGET-ID 74
     "Diret¢rios Importa‡Æo Liquida‡Æo:" VIEW-AS TEXT
          SIZE 24 BY .54 AT ROW 5.75 COL 7 WIDGET-ID 78
     rtToolBar AT ROW 17 COL 1
     RECT-1 AT ROW 1.5 COL 2 WIDGET-ID 72
     RECT-2 AT ROW 6 COL 2 WIDGET-ID 76
     RECT-3 AT ROW 10.5 COL 2 WIDGET-ID 80
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.29 BY 17.63
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "Parƒmetros Concilia‡Æo Financeira"
         HEIGHT             = 17.63
         WIDTH              = 90.29
         MAX-HEIGHT         = 17.63
         MAX-WIDTH          = 90.29
         VIRTUAL-HEIGHT     = 17.63
         VIRTUAL-WIDTH      = 90.29
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN param-concil-financ.dir-arq-importados-an IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN param-concil-financ.dir-arq-importados-liq IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN param-concil-financ.dir-arq-log-an IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN param-concil-financ.dir-arq-log-liq IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN param-concil-financ.dir-arq-recebidos-an IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN param-concil-financ.dir-arq-recebidos-liq IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-desc-especie IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

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

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow /* Parƒmetros Concilia‡Æo Financeira */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Parƒmetros Concilia‡Æo Financeira */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    
    run saveRecord in this-procedure.
    if return-value = 'NOK' then do:
        {method/showmessage.i1}
        {method/showmessage.i2 &modal="yes"}
        {method/showmessage.i3}

        return no-apply.
    end.
    else
        apply "CLOSE":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-concil-financ.cod-espec-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-concil-financ.cod-espec-docto wWindow
ON F5 OF param-concil-financ.cod-espec-docto IN FRAME fpage0 /* Esp‚cie */
DO:
  
    run prgfin/acr/acr030ka.p /*prg_sea_espec_docto_financ_acr*/.

    if  v_rec_espec_docto_financ_acr <> ?
    then do:
        find espec_docto_financ_acr where recid(espec_docto_financ_acr) = v_rec_espec_docto_financ_acr no-lock no-error.
        assign param-concil-financ.cod-espec-docto:screen-value in frame fpage0 = string(espec_docto_financ_acr.cod_espec_docto).
        
        FIND FIRST espec_docto NO-LOCK
             WHERE espec_docto.cod_espec_docto = espec_docto_financ_acr.cod_espec_docto NO-ERROR.
        IF AVAIL espec_docto THEN
            ASSIGN fi-desc-especie:screen-value in frame fpage0 = string(espec_docto.des_espec_docto).

    end /* if */.
    apply "entry" to param-concil-financ.cod-espec-docto in frame fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-concil-financ.cod-espec-docto wWindow
ON LEAVE OF param-concil-financ.cod-espec-docto IN FRAME fpage0 /* Esp‚cie */
DO:
  FIND FIRST espec_docto NO-LOCK
       WHERE espec_docto.cod_espec_docto = INPUT FRAME fPage0 param-concil-financ.cod-espec-docto NO-ERROR.
  IF AVAIL espec_docto THEN
      ASSIGN fi-desc-especie:SCREEN-VALUE IN FRAME fPage0 = espec_docto.des_espec_docto.
  ELSE
      ASSIGN fi-desc-especie:SCREEN-VALUE IN FRAME fPage0 = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-concil-financ.cod-espec-docto wWindow
ON MOUSE-SELECT-DBLCLICK OF param-concil-financ.cod-espec-docto IN FRAME fpage0 /* Esp‚cie */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    param-concil-financ.cod-espec-docto:load-mouse-pointer('image/lupa.cur') in frame fPage0.
    
    ASSIGN tg-efetiva-liquidacao = param-concil-financ.log-efetiva-lote-liquidacao.
    display 
        param-concil-financ.dir-arq-recebidos-an
        param-concil-financ.dir-arq-importados-an
        param-concil-financ.dir-arq-log-an
        param-concil-financ.dir-arq-recebidos-liq
        param-concil-financ.dir-arq-importados-liq
        param-concil-financ.dir-arq-log-liq
        param-concil-financ.cod-espec-docto
        fi-desc-especie
        tg-efetiva-liquidacao
        param-concil-financ.cod-ser-docto
        param-concil-financ.cod-parcela                
       with frame fPage0.

    enable
        param-concil-financ.dir-arq-recebidos-an  
        param-concil-financ.dir-arq-importados-an 
        param-concil-financ.dir-arq-log-an        
        param-concil-financ.dir-arq-recebidos-liq 
        param-concil-financ.dir-arq-importados-liq
        param-concil-financ.dir-arq-log-liq       
        param-concil-financ.cod-espec-docto                                 
        tg-efetiva-liquidacao                     
        param-concil-financ.cod-ser-docto         
        param-concil-financ.cod-parcela
       with frame fPage0.

    apply 'leave' to param-concil-financ.cod-espec-docto in frame fPage0.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wWindow 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    find first param-concil-financ no-lock no-error.
    if not available param-concil-financ then do: 
        do transaction:
            create param-concil-financ.
        end.
        find first param-concil-financ no-lock no-error.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE insertError wWindow 
PROCEDURE insertError :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pErrorNumber      AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pErrorType        AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pErrorSubType     AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pErrorParameters  AS CHARACTER NO-UNDO.

    DEFINE VARIABLE iErrorSequence AS INTEGER NO-UNDO.

    find last RowErrors no-lock no-error.

    if available RowErrors then
        assign iErrorSequence = RowErrors.ErrorSequence + 1.
    else
        assign iErrorSequence = iErrorSequence + 1.

    create RowErrors.
    assign RowErrors.ErrorSequence    = iErrorSequence
           RowErrors.ErrorNumber      = pErrorNumber
           RowErrors.ErrorType        = pErrorType
           RowErrors.ErrorSubType     = pErrorSubType
           RowErrors.ErrorParameters  = pErrorParameters.

    run utp/ut-msgs.p ('msg', pErrorNumber, pErrorParameters).
    assign RowErrors.ErrorDescription = return-value.

    run utp/ut-msgs.p ('help', pErrorNumber, pErrorParameters).
    assign RowErrors.ErrorHelp = return-value.



    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveRecord wWindow 
PROCEDURE saveRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    run validateRecord in this-procedure.
    if return-value = 'NOK' then
        return 'NOK'.


    do transaction on error undo, return 'nok':
        find current param-concil-financ exclusive-lock.
        assign param-concil-financ.dir-arq-recebidos-an          = input frame fPage0 param-concil-financ.dir-arq-recebidos-an        
               param-concil-financ.dir-arq-importados-an         = input frame fPage0 param-concil-financ.dir-arq-importados-an        
               param-concil-financ.dir-arq-log-an                = input frame fPage0 param-concil-financ.dir-arq-log-an        
               param-concil-financ.dir-arq-recebidos-liq         = input frame fPage0 param-concil-financ.dir-arq-recebidos-liq        
               param-concil-financ.dir-arq-importados-liq        = input frame fPage0 param-concil-financ.dir-arq-importados-liq           
               param-concil-financ.dir-arq-log-liq               = input frame fPage0 param-concil-financ.dir-arq-log-liq        
               param-concil-financ.cod-espec-docto               = input frame fPage0 param-concil-financ.cod-espec-docto
               param-concil-financ.log-efetiva-lote-liquidacao   = input frame fPage0 tg-efetiva-liquidacao
               param-concil-financ.cod-ser-docto                 = input frame fPage0 param-concil-financ.cod-ser-docto
               param-concil-financ.cod-parcela                   = input frame fPage0 param-concil-financ.cod-parcela.
    end.

    return 'OK'.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord wWindow 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    empty temp-table RowErrors.

    if not can-find(espec_docto where espec_docto.cod_espec_docto = input frame fPage0 param-concil-financ.cod-espec-docto) then
        run insertError in this-procedure (2, 'EMS', 'ERROR', 'Esp‚cie Docto~~' + input frame fPage0 param-concil-financ.cod-espec-docto).
    
    
    /*if input FRAME fpage0 param-concil-financ.dir-arq-recebidos-an = '' then
        run insertError in this-procedure (54, 'EMS', 'ERROR', 'Diret¢rio Arquivos Recebidos An').*/

    if can-find(first RowErrors) then
        return 'NOK'.

    return 'OK'.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

