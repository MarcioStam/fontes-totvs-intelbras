&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER cAction     AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pRwFedex    AS ROWID        NO-UNDO.
DEFINE OUTPUT PARAMETER plOk        AS LOGICAL      NO-UNDO INITIAL NO.

/* Local Variable Definitions ---                                       */

DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_cod_empres_usuar AS CHARACTER NO-UNDO.

def var cp-ct-codigo like conta-programa.ct-codigo extent 10.
def var cp-sc-codigo like conta-programa.sc-codigo extent 10.

DEFINE VARIABLE c-cod-usuario   AS CHARACTER      NO-UNDO.

def new global shared var v_rec_usuar_mestre
    as recid
    format ">>>>>>9":U
    initial ?
    no-undo.

DEFINE NEW GLOBAL SHARED VARIABLE v_cod_dwb_user AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_rec_cta_ctbl_integr AS RECID NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_rec_ccusto AS RECID NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_rec_plano_ccusto AS RECID  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_rec_estabelecimento AS RECID NO-UNDO.

DEF VAR cb-tipo AS CHAR FORMAT "X(10)":U INITIAL 'E' LABEL "Tipo" 
    VIEW-AS COMBO-BOX INNER-LINES 5 LIST-ITEM-PAIRS "Entrada","E","Sa°da","S" DROP-DOWN-LIST SIZE 16 BY 1 NO-UNDO.

DEF VAR cb-cond-pag AS CHAR FORMAT "X(10)":U INITIAL '1' LABEL "Cond Pagto" 
    VIEW-AS COMBO-BOX INNER-LINES 5 LIST-ITEM-PAIRS "Com pagamento","1","Sem pagamento","2","Cart∆o de crÇdito","3" DROP-DOWN-LIST SIZE 16 BY 1 NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_OK Btn_Cancel RECT-2 RECT-8 
&Scoped-Define DISPLAYED-FIELDS cb-tipo fedex.empresa fedex.material ~
fedex.cod-mensagem fedex.mp fedex.num-pedido fedex.cod_estab ~
fedex.ct-codigo fedex.cc-codigo fedex.duties fedex.freight ~
fedex.conhecimento fedex.cod-transp fedex.usuar-mat fedex.cod-cond-pag fedex.desc-sdcv
&Scoped-define DISPLAYED-TABLES fedex
&Scoped-define FIRST-DISPLAYED-TABLE fedex
&Scoped-Define DISPLAYED-OBJECTS cMensagem cNomeEstab cDesc_cta ~
cDesc_ccusto cNome-transp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE cDesc_ccusto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34.29 BY .88 NO-UNDO.

DEFINE VARIABLE cDesc_cta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34.29 BY .88 NO-UNDO.

DEFINE VARIABLE cDesc_usuar_mat AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 34.29 BY .88 NO-UNDO.

DEFINE VARIABLE cMensagem AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.72 BY .88 NO-UNDO.

DEFINE VARIABLE cNome-transp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE cNomeEstab AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42.16 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 83.43 BY 1.5
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83.43 BY 17.17.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     cb-tipo AT ROW 1.17 COL 24.72 COLON-ALIGNED
          /*VIEW-AS FILL-IN 
          SIZE 6.14 BY .88*/
     fedex.empresa AT ROW 2.17 COL 24.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 25.43 BY .88
     fedex.material AT ROW 3.17 COL 24.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 38.57 BY .88
     fedex.cod-mensagem AT ROW 4.17 COL 24.72 COLON-ALIGNED
          LABEL "Motivo"
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     cMensagem AT ROW 4.17 COL 30.43 COLON-ALIGNED NO-LABEL
     fedex.mp AT ROW 5.17 COL 24.72 COLON-ALIGNED
          LABEL "Gera NF ?"
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     fedex.num-pedido AT ROW 6.17 COL 24.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     fedex.cod_estab AT ROW 7.17 COL 24.72 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     cNomeEstab AT ROW 7.17 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     fedex.ct-codigo AT ROW 8.17 COL 24.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     cDesc_cta AT ROW 8.17 COL 37.86 COLON-ALIGNED NO-LABEL
     fedex.cc-codigo AT ROW 9.17 COL 24.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     cDesc_ccusto AT ROW 9.17 COL 37.86 COLON-ALIGNED NO-LABEL
     fedex.duties AT ROW 10.17 COL 24.72 COLON-ALIGNED
          LABEL "Impostos"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Sender","S",
                     "Receiver","R",
                     "3os","3"
          DROP-DOWN-LIST
          SIZE 16 BY 1
     fedex.freight AT ROW 11.17 COL 24.72 COLON-ALIGNED
          LABEL "Frete"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Sender","S",
                     "Receiver","R",
                     "3os","3"
          DROP-DOWN-LIST
          SIZE 16 BY 1
     fedex.conhecimento AT ROW 12.17 COL 24.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 24.29 BY .88
     fedex.cod-transp AT ROW 13.17 COL 24.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     cNome-transp AT ROW 13.17 COL 32.14 COLON-ALIGNED NO-LABEL
     fedex.usuar-mat AT ROW 14.17 COL 24.72 COLON-ALIGNED LABEL "Usu†rio Material"
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     cDesc_usuar_mat AT ROW 14.17 COL 40 COLON-ALIGNED NO-LABEL
     cb-cond-pag AT ROW 15.17 COL 24.72 COLON-ALIGNED LABEL "Cond Pagto"
     fedex.desc-sdcv AT ROW 16.17 COL 24.72 COLON-ALIGNED LABEL "Nr SDCVs"
          VIEW-AS FILL-IN 
          SIZE 50 BY .88
     Btn_OK AT ROW 18.58 COL 2
     Btn_Cancel AT ROW 18.58 COL 13
     "12267 - RAF / 5055 - FEDEX / 13 - UPS / 5145 - DHL / Outro Transportador" VIEW-AS TEXT
          SIZE 55.43 BY .54 AT ROW 17.33 COL 26.72
     RECT-2 AT ROW 18.33 COL 1
     RECT-8 AT ROW 1 COL 1
     SPACE(0.00) SKIP(1.74)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 1
         TITLE "Inclus∆o Solicitaá∆o COURRIER - ESACR004D"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
                                                                        */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

&ANALYZE-RESUME

if fedex.usuar-mat:load-mouse-pointer ("image/lupa.cur") then.
if fedex.cod_estab:load-mouse-pointer ("image/lupa.cur") then.
if fedex.cc-codigo:load-mouse-pointer ("image/lupa.cur") then.
if fedex.ct-codigo:load-mouse-pointer ("image/lupa.cur") then.


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON GO OF FRAME Dialog-Frame /* Inclus∆o Solicitaá∆o COURRIER - ESACR004D */
DO:
    IF cAction = 'Add' THEN DO:
        RUN piAddRecord IN THIS-PROCEDURE.
        IF RETURN-VALUE = 'NOK' THEN
            RETURN NO-APPLY.
        ASSIGN plOk = YES.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Inclus∆o Solicitaá∆o COURRIER - ESACR004D */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fedex.cc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fedex.cc-codigo Dialog-Frame
ON F5 OF fedex.cc-codigo IN FRAME Dialog-Frame /* Centro Custo */
DO:
    /* fn_generic_zoom */
    if search("prgint/utb/utb066ka.r") = ? and search("prgint/utb/utb066ka.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb066ka.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/utb/utb066ka.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/utb/utb066ka.p /*prg_sea_plano_ccusto*/.

    if v_rec_ccusto <> ?
    then do:
        assign cDesc_ccusto = ''.
        find emscad.ccusto where recid(ccusto) = v_rec_ccusto no-lock no-error.
        IF AVAILABLE ccusto THEN
            ASSIGN fedex.cc-codigo:screen-value in frame {&FRAME-NAME} = string(ccusto.cod_ccusto)
                   cDesc_ccusto = ccusto.des_tit_ctbl.

        display cDesc_ccusto with frame {&FRAME-NAME}.

    end /* if */.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fedex.cc-codigo Dialog-Frame
ON LEAVE OF fedex.cc-codigo IN FRAME Dialog-Frame /* Centro Custo */
DO:
    assign cDesc_ccusto = ''.
    find emscad.ccusto no-lock 
        where ccusto.cod_empresa = v_cod_empres_usuar
          AND ccusto.cod_plano_ccusto = 'Padr∆o'
          AND ccusto.cod_ccusto = INPUT FRAME {&FRAME-NAME} {&SELF-NAME}
        no-error.
    IF AVAILABLE ccusto THEN
        ASSIGN cDesc_ccusto = ccusto.des_tit_ctbl.

    display cDesc_ccusto with frame {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fedex.cc-codigo Dialog-Frame
ON MOUSE-SELECT-DBLCLICK OF fedex.cc-codigo IN FRAME Dialog-Frame /* Centro Custo */
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fedex.cod-mensagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fedex.cod-mensagem Dialog-Frame
ON LEAVE OF fedex.cod-mensagem IN FRAME Dialog-Frame /* Motivo */
DO:
    FIND mensagem NO-LOCK WHERE mensagem.cod-mensagem = INPUT FRAME {&FRAME-NAME} {&SELF-NAME} NO-ERROR.
    IF AVAILABLE mensagem THEN
        ASSIGN cMensagem = mensagem.descricao.
    ELSE
        ASSIGN cMensagem = ''.
    DISPLAY cMensagem WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fedex.cod-transp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fedex.cod-transp Dialog-Frame
ON LEAVE OF fedex.cod-transp IN FRAME Dialog-Frame /* Transportadora */
DO:
    ASSIGN cNome-transp = ''.

    FIND emscad.fornecedor NO-LOCK
        WHERE fornecedor.cod_empresa = v_cod_empres_usuar
          AND fornecedor.cdn_fornecedor = INPUT FRAME {&FRAME-NAME} {&SELF-NAME}
        NO-ERROR.
    IF AVAILABLE fornecedor THEN DO:
        FIND pessoa_jurid NO-LOCK WHERE pessoa_jurid.num_pessoa_jurid = fornecedor.num_pessoa NO-ERROR.
        IF AVAILABLE pessoa_jurid THEN
            ASSIGN cNome-transp = pessoa_jurid.nom_pessoa.
    END.
    DISPLAY cNome-transp WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fedex.ct-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fedex.ct-codigo Dialog-Frame
ON F5 OF fedex.ct-codigo IN FRAME Dialog-Frame /* Conta */
DO:
    if  search("prgint/utb/utb033na.r") = ? and search("prgint/utb/utb033na.p") = ? then do:
        if  v_cod_dwb_user begins 'es_' then
            return "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  + "prgint/utb/utb033na.p".
        else do:
            message "Programa execut†vel n∆o foi encontrado:" /*l_programa_nao_encontrado*/  "prgint/utb/utb033na.p"
                   view-as alert-box error buttons ok.
            return.
        end.
    end.
    else
        run prgint/utb/utb033na.p (Input "APB" /*l_apb*/,
                               Input 'Padr∆o',
                               Input "Conta Movimento" /*l_conta_movimento*/) /*prg_see_cta_ctbl_integr*/.
    if v_rec_cta_ctbl_integr <> ? then do:
        assign cDesc_cta  = ''.
        find cta_ctbl_integr where recid(cta_ctbl_integr) = v_rec_cta_ctbl_integr no-lock no-error.
        IF AVAILABLE cta_ctbl_integr THEN DO:
            FIND cta_ctbl NO-LOCK OF cta_ctbl_integr.
            ASSIGN {&self-name}:screen-value in frame {&FRAME-NAME} = string(cta_ctbl_integr.cod_cta_ctbl)
                   cDesc_cta = cta_ctbl.des_tit_ctbl.
        END.
        display cDesc_cta with frame {&FRAME-NAME}.
    end /* if */.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fedex.ct-codigo Dialog-Frame
ON LEAVE OF fedex.ct-codigo IN FRAME Dialog-Frame /* Conta */
DO:
    assign cDesc_cta  = ''.
    find cta_ctbl no-lock
        where cta_ctbl.cod_plano_cta_ctbl = 'Padr∆o'
          and cta_ctbl.cod_cta_ctbl = INPUT FRAME {&FRAME-NAME} {&SELF-NAME}
        no-error.

    IF AVAILABLE cta_ctbl THEN
        ASSIGN cDesc_cta = cta_ctbl.des_tit_ctbl.

    display cDesc_cta with frame {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fedex.ct-codigo Dialog-Frame
ON MOUSE-SELECT-DBLCLICK OF fedex.ct-codigo IN FRAME Dialog-Frame /* Conta */
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fedex.mp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fedex.mp Dialog-Frame
ON LEAVE OF fedex.mp IN FRAME Dialog-Frame /* Materia-Prima */
DO:
    IF INPUT FRAME {&FRAME-NAME} {&SELF-NAME} THEN DO:
        DISPLAY cp-ct-codigo[1] @ fedex.ct-codigo 
                cp-sc-codigo[1] @ fedex.cc-codigo
            WITH FRAME {&FRAME-NAME}.
        APPLY 'LEAVE' TO fedex.ct-codigo IN FRAME Dialog-Frame.
    END.
    ELSE DO:
         DISPLAY "" @ fedex.ct-codigo 
                 "" @ cDesc_cta
                 "" @ fedex.cc-codigo
                 "" @ cDesc_ccusto WITH FRAME {&FRAME-NAME}.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME fedex.cod_estab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fedex.cod_estab Dialog-Frame
ON F5 OF fedex.cod_estab IN FRAME Dialog-Frame /* Estabelecimento */
DO:
    run prgint/utb/utb071ka.p /*prg_sea_estabelecimento*/.
    if  v_rec_estabelecimento <> ?
    then do:
        find first estabelecimento no-lock
          where recid(estabelecimento) = v_rec_estabelecimento no-error.
          
        disp estabelecimento.cod_estab @ fedex.cod_estab
             estabelecimento.nom_pessoa @ cNomeEstab with frame {&frame-name}.
    end /* if */.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fedex.cod_estab Dialog-Frame
ON LEAVE OF fedex.cod_estab IN FRAME Dialog-Frame /* Conta */
DO:
    assign cNomeEstab  = ''.
    find estabelecimento no-lock
        where estabelecimento.cod_estab = INPUT FRAME {&FRAME-NAME} {&SELF-NAME}
        NO-ERROR.
    IF AVAIL estabelecimento THEN
        ASSIGN cNomeEstab = estabelecimento.nom_pessoa.

    DISPLAY cNomeEstab WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fedex.cod_estab Dialog-Frame
ON MOUSE-SELECT-DBLCLICK OF fedex.cod_estab IN FRAME Dialog-Frame /* Conta */
DO:
    APPLY 'F5' TO SELF.
END.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fedex.usuar-mat Dialog-Frame
ON F5 OF fedex.usuar-mat IN FRAME Dialog-Frame
DO:
    run prgtec/sec/sec000ka.p .

    if  v_rec_usuar_mestre <> ? then do:
        find usuar_mestre 
            where recid(usuar_mestre) = v_rec_usuar_mestre no-lock no-error.

        assign fedex.usuar-mat:screen-value in frame Dialog-Frame = string(usuar_mestre.cod_usuario)
               cDesc_usuar_mat:SCREEN-VALUE IN FRAME Dialog-Frame = usuar_mestre.nom_usuario.
    end.
    
    apply "entry" to fedex.usuar-mat in frame Dialog-Frame.
END.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fedex.usuar-mat Dialog-Frame
ON LEAVE OF fedex.usuar-mat IN FRAME Dialog-Frame
DO:
    FIND FIRST usuar_mestre NO-LOCK 
        WHERE usuar_mestre.cod_usuario = INPUT FRAME Dialog-Frame fedex.usuar-mat NO-ERROR.

    assign cDesc_usuar_mat:SCREEN-VALUE IN FRAME Dialog-Frame = usuar_mestre.nom_usuario.
END.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fedex.usuar-mat Dialog-Frame
ON MOUSE-SELECT-DBLCLICK OF fedex.usuar-mat IN FRAME Dialog-Frame
DO:
    APPLY 'F5' TO SELF.
END.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fedex.num-pedido Dialog-Frame
ON LEAVE OF fedex.num-pedido IN FRAME Dialog-Frame /* Conta */
DO:

    IF fedex.num-pedido:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" THEN DO:
        FIND pedido-compr NO-LOCK
            WHERE pedido-compr.num-pedido = INT(fedex.num-pedido:SCREEN-VALUE IN FRAME {&FRAME-NAME})
            NO-ERROR.
        IF AVAIL pedido-compr THEN DO:
            ASSIGN fedex.cod_estab:SCREEN-VALUE IN FRAME {&FRAME-NAME} = pedido-compr.cod-estabel.
        END.

    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:


    FIND FIRST usuar_mestre NO-LOCK 
        WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren NO-ERROR.

    IF NOT AVAILABLE usuar_mestre THEN DO:
        MESSAGE "Usuario nao encontrado. Verifique seu codigo" VIEW-AS ALERT-BOX ERROR.
        RETURN 'NOK'.
    END.
    ELSE
        ASSIGN c-cod-usuario = v_cod_usuar_corren.



    IF cAction <> 'Add' THEN DO:
        FIND fedex NO-LOCK WHERE ROWID(fedex) = pRwFedex NO-ERROR.
        IF NOT AVAILABLE fedex THEN
            MESSAGE 'Courrier n∆o foi encontrado' VIEW-AS ALERT-BOX WARNING.
    END.
    ELSE
        RUN piBuscaContas IN THIS-PROCEDURE.

    FIND plano_ccusto NO-LOCK
        WHERE plano_ccusto.cod_empresa = v_cod_empres_usuar
          AND plano_ccusto.cod_plano_ccusto = 'Padr∆o'
        NO-ERROR.
    IF AVAILABLE plano_ccusto THEN
        ASSIGN v_rec_plano_ccusto = RECID(plano_ccusto).


    RUN enable_UI.

    IF cAction <> 'Add' THEN
        DISABLE btn_ok WITH FRAME {&FRAME-NAME}.
    ELSE
        ENABLE mgesp.fedex.cod-mensagem mgesp.fedex.cod-transp mgesp.fedex.conhecimento mgesp.fedex.duties mgesp.fedex.empresa mgesp.fedex.freight mgesp.fedex.material mgesp.fedex.mp mgesp.fedex.num-pedido cb-tipo mgesp.fedex.cod_estab
            cb-cond-pag mgesp.fedex.desc-sdcv mgesp.fedex.usuar-mat
            WITH FRAME {&FRAME-NAME}.

    ASSIGN cb-tipo:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = "E"
           cb-cond-pag:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "1".

    WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
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
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
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
  DISPLAY cMensagem cDesc_cta cDesc_ccusto cNome-transp 
      WITH FRAME Dialog-Frame.
  IF AVAILABLE fedex THEN 
    DISPLAY cb-tipo fedex.empresa fedex.material fedex.cod-mensagem fedex.mp 
          fedex.num-pedido fedex.ct-codigo fedex.cc-codigo fedex.duties 
          fedex.freight fedex.conhecimento fedex.cod-transp fedex.cod_estab
          fedex.usuar-mat cb-cond-pag fedex.desc-sdcv
      WITH FRAME Dialog-Frame.
  ENABLE Btn_OK Btn_Cancel RECT-2 RECT-8 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAddRecord Dialog-Frame 
PROCEDURE piAddRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE i-fed AS INTEGER    NO-UNDO.

    IF CAN-FIND(fedex WHERE fedex.conhecimento = INPUT FRAME {&FRAME-NAME} fedex.conhecimento) OR
       INPUT FRAME {&FRAME-NAME} fedex.conhecimento = "" THEN DO:
        MESSAGE "Conhecimento inv†lido ou j† registrado." VIEW-AS ALERT-BOX ERROR.
        RETURN 'NOK'.
    END.


    IF NOT CAN-FIND(mensagem WHERE mensagem.cod-mensagem = INPUT FRAME {&FRAME-NAME} fedex.cod-mensagem) THEN DO:
        MESSAGE "Mensagem n∆o encontrada" VIEW-AS ALERT-BOX ERROR.
        RETURN 'NOK'.
    END.

    IF NOT CAN-FIND(estabelecimento NO-LOCK 
                    WHERE estabelecimento.cod_estab = INPUT FRAME {&FRAME-NAME} fedex.cod_estab) THEN DO:
        MESSAGE "Estabelecimento n∆o encontrado"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN "NOK".
    END.

    IF fedex.num-pedido:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" THEN DO:
        FIND pedido-compr NO-LOCK
            WHERE pedido-compr.num-pedido = INT(fedex.num-pedido:SCREEN-VALUE IN FRAME {&FRAME-NAME})
            NO-ERROR.
        IF NOT AVAIL pedido-compr THEN DO:
            MESSAGE "Pedido n∆o encontrado!"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN "NOK".
        END.
        IF AVAIL pedido-compr THEN DO:
            IF fedex.cod_estab:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> pedido-compr.cod-estabel THEN DO:
                MESSAGE "Estabelecimento informado diferente DO Pedido!"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                RETURN "NOK".
            END.
        END.
    END.

    IF  INPUT FRAME Dialog-Frame fedex.usuar-mat = "" THEN DO:
        MESSAGE "Usu†rio de material n∆o foi informado !" VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN "NOK".
    END.
    ELSE DO:
        IF NOT CAN-FIND (usuar_mestre NO-LOCK 
            WHERE usuar_mestre.cod_usuario = INPUT FRAME Dialog-Frame fedex.usuar-mat) THEN DO:
            MESSAGE "Usu†rio de material n∆o cadastrado !" VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN "NOK".
        END.
    END.

    IF INPUT FRAME {&FRAME-NAME} fedex.mp 
    THEN DO:
         FIND cta_ctbl NO-LOCK
             WHERE cta_ctbl.cod_plano_cta_ctbl = 'Padrao'
               AND cta_ctbl.cod_cta_ctbl       = INPUT FRAME {&FRAME-NAME} fedex.ct-codigo
             NO-ERROR.
         IF NOT AVAILABLE cta_ctbl THEN DO:
             MESSAGE "Conta Cont†bil n∆o encontrada" VIEW-AS ALERT-BOX ERROR.
             RETURN 'NOK'.
         END.
         IF INPUT FRAME {&FRAME-NAME} fedex.cc-codigo <> '' THEN DO:
             FIND emscad.ccusto NO-LOCK
                 WHERE ccusto.cod_empresa = v_cod_empres_usuar
                   AND ccusto.cod_plano_ccusto = 'Padr∆o'
                   AND ccusto.cod_ccusto       = INPUT FRAME {&FRAME-NAME} fedex.cc-codigo
                 NO-ERROR.
             IF NOT AVAILABLE ccusto THEN DO:
                 MESSAGE "Centro de custo n∆o encontrado" VIEW-AS ALERT-BOX ERROR.
                 RETURN 'NOK'.
             END.
         END.
    END.

    IF INPUT FRAME {&FRAME-NAME} fedex.duties <> 'S' AND
       INPUT FRAME {&FRAME-NAME} fedex.duties <> 'R' AND
       INPUT FRAME {&FRAME-NAME} fedex.duties <> '3' THEN DO:
        MESSAGE "Impostos deve ser Sender, Receiver ou 3os." VIEW-AS ALERT-BOX ERROR.
        RETURN 'NOK'.
    END.

    IF INPUT FRAME {&FRAME-NAME} fedex.freight <> 'S' AND
       INPUT FRAME {&FRAME-NAME} fedex.freight <> 'R' AND
       INPUT FRAME {&FRAME-NAME} fedex.freight <> '3' THEN DO:
        MESSAGE "Frete deve ser Sender, Receiver ou 3os." VIEW-AS ALERT-BOX ERROR.
        RETURN 'NOK'.
    END.

    FIND LAST fedex NO-LOCK NO-ERROR.
    IF NOT AVAILABLE fedex THEN
        ASSIGN i-fed = 1.
    ELSE
        ASSIGN i-fed = fedex.numero + 1.

    cria_fedex:
    DO TRANSACTION ON ERROR UNDO, RETURN 'NOK':
        CREATE fedex.
        ASSIGN fedex.numero      = i-fed
               fedex.cod_usuario = c-cod-usuario
               fedex.data-sol    = TODAY.

        IF  INPUT FRAME {&FRAME-NAME} cb-tipo = "E" THEN
            ASSIGN fedex.tipo = YES.
        ELSE
            ASSIGN fedex.tipo = NO.

        ASSIGN fedex.cod-cond-pag = INT(INPUT FRAME {&FRAME-NAME} cb-cond-pag).

        ASSIGN INPUT FRAME {&FRAME-NAME}
            mgesp.fedex.cod-mensagem 
            mgesp.fedex.cod-transp 
            mgesp.fedex.conhecimento 
            mgesp.fedex.ct-codigo 
            mgesp.fedex.duties 
            mgesp.fedex.empresa 
            mgesp.fedex.freight 
            mgesp.fedex.material 
            mgesp.fedex.mp 
            mgesp.fedex.num-pedido 
            mgesp.fedex.cc-codigo 
            /*mgesp.fedex.tipo*/
            mgesp.fedex.cod_estab
            mgesp.fedex.usuar-mat
            /*mgesp.fedex.cod-cond-pag*/
            mgesp.fedex.desc-sdcv.

        IF INPUT FRAME {&FRAME-NAME} fedex.mp = NO
        THEN DO:
             RUN esp/acr/esacr004f.p(fedex.numero,
                                     0).
             IF RETURN-VALUE = "NOK" 
             THEN DO:
                  APPLY "ERROR" TO SELF.
             END.
        END.
        ELSE DO:
             CREATE fedex-rateio.
             ASSIGN fedex-rateio.numero             = fedex.numero
                    fedex-rateio.cod_ccusto         = mgesp.fedex.cc-codigo
                    fedex-rateio.cod_cta_ctbl       = mgesp.fedex.ct-codigo
                    fedex-rateio.cod_plano_ccusto   = IF fedex-rateio.cod_ccusto <> "" THEN "PADRAO" ELSE ""
                    fedex-rateio.cod_plano_cta_ctbl = "PADRAO"
                    fedex-rateio.cod_unid_negoc     = "ADM"
                    fedex-rateio.perc_aprop_ctbl    = 100.
        END.

    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaContas Dialog-Frame 
PROCEDURE piBuscaContas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    DEFINE VARIABLE lAchou  AS LOGICAL      NO-UNDO INITIAL NO.

    /* es0008 - Include para busca das contas por programa
       19-12-2002 - Flavio Schoenell */

    FOR EACH conta-programa NO-LOCK
        WHERE conta-programa.programa = 'esacr004.w'
        BY conta-programa.indice:
        ASSIGN cp-ct-codigo[conta-programa.indice] = conta-programa.ct-codigo
               cp-sc-codigo[conta-programa.indice] = conta-programa.sc-codigo
               lAchou = YES.
    END.

    IF NOT lAchou THEN
        MESSAGE 'As contas para o programa ESACR004 n∆o est∆o cadastradas.'
            VIEW-AS ALERT-BOX ERROR TITLE 'Configuraá∆o de contas'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

