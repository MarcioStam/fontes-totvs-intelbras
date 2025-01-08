{esp\acr\acr711zo.i}

&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM2 SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
define NEW global shared var whBrDigita         as widget-handle no-undo.

def new global shared var v_cod_empres_usuar
    as character
    format "x(3)"
    label "Empresa"
    column-label "Empresa"
    no-undo.


/* Local Variable Definitions ---                                       */
DEF VAR hquery        AS HANDLE NO-UNDO.
DEF VAR hbuffer       AS HANDLE NO-UNDO.
DEF VAR hCodEstab     AS HANDLE NO-UNDO.
DEF VAR hCodEspec     AS HANDLE NO-UNDO.
DEF VAR hCodSer       AS HANDLE NO-UNDO.
DEF VAR hCodTit       AS HANDLE NO-UNDO.
DEF VAR hParcela      AS HANDLE NO-UNDO.
DEF VAR icount        AS INT NO-UNDO.
DEF VAR vRetorno      AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME gDialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-5 RECT-7 c-cod-port c-carteira Btn_OK ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS c-cod-port c-desc-portador c-carteira ~
c-desc-carteira 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartDialogCues" gDialog _INLINE
/* Actions: adecomm/_so-cue.w ? adecomm/_so-cued.p ? adecomm/_so-cuew.p */
/* SmartDialog,ab,49267
Destroy on next read */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.13.

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.13.

DEFINE VARIABLE c-cod-port AS CHARACTER FORMAT "X(5)":U INITIAL "0" 
     LABEL "Portador" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-carteira AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 51 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-portador AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 51 BY .88 NO-UNDO.

DEFINE VARIABLE c-carteira AS CHARACTER FORMAT "x(8)":U 
     LABEL "Carteira" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 74 BY 3.25.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 74 BY 1.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     c-cod-port AT ROW 2.46 COL 14 COLON-ALIGNED
     c-desc-portador AT ROW 2.5 COL 22 COLON-ALIGNED NO-LABEL
     c-carteira AT ROW 3.46 COL 14 COLON-ALIGNED
     c-desc-carteira AT ROW 3.5 COL 22 COLON-ALIGNED NO-LABEL
     Btn_OK AT ROW 5.75 COL 3
     Btn_Cancel AT ROW 5.75 COL 19
     RECT-5 AT ROW 1.71 COL 2
     RECT-7 AT ROW 5.5 COL 2
     SPACE(1.13) SKIP(0.41)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Destinaá∆o titulos vendor"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB gDialog 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX gDialog
                                                                        */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-carteira IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-portador IN FRAME gDialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* Destinaá∆o titulos vendor */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btN_ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_ok gDialog
ON CHOOSE OF btn_ok IN FRAME gDialog /* Portador */
DO:
    
    FIND FIRST portad_finalid_econ
        WHERE portad_finalid_econ.cod_estab = "101"
        AND   portad_finalid_econ.cod_portador = INPUT c-cod-port
        AND   portad_finalid_econ.cod_cart_bcia = INPUT c-carteira
        AND   portad_finalid_econ.cod_finalid_econ = "corrente" NO-ERROR.
    IF NOT AVAIL portad_finalid_econ THEN DO:
       MESSAGE "Finalidade economica do portador n∆o cadastrado para: " skip
               "Estabelecimento: 101" SKIP
               "Portador: " INPUT c-cod-port SKIP
               "Carteira: " INPUT c-carteira SKIP
               "Finalidade: Corrente" SKIP
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
       RETURN NO-APPLY.
    END.
    
    /* SETA O HANDLE DE DO BROWSE DE CADA CAMPO QUE VOU PRECISAR ***/

    ASSIGN hquery = whbrdigita:QUERY
           hbuffer = hquery:GET-BUFFER-HANDLE(1)
           hCodEstab = hbuffer:BUFFER-FIELD("tta_cod_estab")
           hCodEspec = hbuffer:BUFFER-FIELD("tta_cod_espec_docto")
           hCodSer   = hbuffer:BUFFER-FIELD("tta_cod_ser_docto")
           hCodTit   = hbuffer:BUFFER-FIELD("tta_cod_tit_acr")
           hParcela  = hbuffer:BUFFER-FIELD("tta_cod_parcela").

    /*** BUSCA O CONTEUDO DOS CAMPOS DE TODAS AS LINHAS SELECIONADAS DO BROWSE **/
    DO iCount = 1 TO whbrdigita:NUM-SELECTED-ROWS:
       whbrdigita:FETCH-SELECTED-ROW(icount).

       FIND FIRST tit_acr NO-LOCK
           WHERE tit_acr.cod_estab = hCodEstab:BUFFER-VALUE
           AND   tit_acr.cod_espec_docto = hCodEspec:BUFFER-VALUE
           AND   tit_acr.cod_ser_docto = hCodSer:BUFFER-VALUE
           AND   tit_acr.cod_tit_acr = hCodTit:BUFFER-VALUE
           AND   tit_acr.cod_parcela = hParcela:BUFFER-VALUE NO-ERROR.
       
       IF AVAIL tit_acr THEN
          RUN piAlteraTitulo (INPUT  INPUT c-cod-port,
                              INPUT  INPUT c-carteira,
                              OUTPUT vRetorno).  
       
    END.
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME c-cod-port
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-port gDialog
ON LEAVE OF c-cod-port IN FRAME gDialog /* Portador */
DO:
  FIND FIRST emscad.portador NO-LOCK
      WHERE emscad.portador.cod_portad = INPUT c-cod-port NO-ERROR.
  IF NOT AVAIL emscad.portador THEN DO:
      DISP "Portador n∆o cadastrado" @ c-desc-portador WITH FRAME {&FRAME-NAME}.
  END.
  IF AVAIL emscad.portador THEN DO:
      FIND FIRST pessoa_jurid NO-LOCK 
         WHERE pessoa_jurid.num_pessoa_jurid  = portador.num_pessoa_jurid NO-ERROR.
      IF NOT AVAIL pessoa_jurid THEN DO:
         DISP "Pessoa juridica do portador n∆o cadastrada" @ c-desc-portador WITH FRAME {&FRAME-NAME}.
      END.
      ELSE
         DISP pessoa_jurid.nom_pessoa @ c-desc-portador WITH FRAME {&FRAME-NAME}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME c-carteira
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-carteira gDialog
ON LEAVE OF c-carteira IN FRAME gDialog /* Portador */
DO:
  FIND FIRST cart_bcia NO-LOCK
      WHERE cart_bcia.cod_cart_bcia = INPUT c-carteira NO-ERROR.
  IF NOT AVAIL cart_bcia THEN DO:
     DISP "Carteira n∆o cadastrada" @ c-desc-carteira WITH FRAME {&FRAME-NAME}.
  END.
  ELSE
     DISP cart_bcia.des_cart_bcia @ c-desc-carteira WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK gDialog 


/* ***************************  Main Block  *************************** */

{src/adm2/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects gDialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI gDialog  _DEFAULT-DISABLE
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
  HIDE FRAME gDialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI gDialog  _DEFAULT-ENABLE
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
  DISPLAY c-cod-port c-desc-portador c-carteira c-desc-carteira 
      WITH FRAME gDialog.
  ENABLE RECT-5 RECT-7 c-cod-port c-carteira Btn_OK Btn_Cancel 
      WITH FRAME gDialog.
  VIEW FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


  PROCEDURE piAlteraTitulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM pCodPortador  LIKE tit_acr.cod_portador  NO-UNDO.
    DEFINE INPUT  PARAM pCodCartBcia  LIKE tit_acr.cod_cart_bcia NO-UNDO.
    DEFINE OUTPUT PARAM pReturn       AS   CHAR                  NO-UNDO.

    DEFINE VARIABLE v_num_aux_2      AS INTEGER    NO-UNDO.
    DEFINE VARIABLE v_num_cont       AS INTEGER    NO-UNDO.
    DEFINE VARIABLE v_num_aux        AS INTEGER    NO-UNDO.
    DEFINE VARIABLE v_cod_refer_impl AS CHARACTER  NO-UNDO.

    /*Calcula referencia automatica*/

    repeat:       

      ASSIGN v_num_aux_2 = integer(this-procedure:handle).
             v_cod_refer_impl = 'NOSSNR' + STRING(YEAR (TODAY), '9999')
                                         + STRING(MONTH(TODAY), '99')
                                         + STRING(DAY  (TODAY), '99').
      do v_num_cont = 1 to 3:
        assign v_num_aux   = (random(0,v_num_aux_2) mod 26) + 97
               v_cod_refer_impl = v_cod_refer_impl + chr(v_num_aux).
      end.

      find first movto_tit_acr 
           where movto_tit_acr.cod_estab   = tit_acr.cod_estab
             and movto_tit_acr.cod_refer = v_cod_refer_impl no-lock no-error.
      if not avail movto_tit_acr then LEAVE.
    end.

    CREATE tt_alter_tit_acr_base_2.
    ASSIGN tt_alter_tit_acr_base_2.tta_cod_estab                   = tit_acr.cod_estab                     
           tt_alter_tit_acr_base_2.tta_num_id_tit_acr              = tit_acr.num_id_tit_acr

           tt_alter_tit_acr_base_2.tta_dat_transacao               = TODAY /*tit_acr.dat_transacao*/
           tt_alter_tit_acr_base_2.tta_cod_refer                   = v_cod_refer_impl
           tt_alter_tit_acr_base_2.ttv_cod_motiv_movto_tit_acr_imp = ?
           tt_alter_tit_acr_base_2.tta_val_sdo_tit_acr             = ? /*tit_acr.val_sdo_tit_acr*/
           tt_alter_tit_acr_base_2.ttv_cod_motiv_movto_tit_acr_alt = ?
           tt_alter_tit_acr_base_2.ttv_ind_motiv_acerto_val        = ?
           tt_alter_tit_acr_base_2.tta_cod_portador                = ? /*tit_acr.cod_portador                   */
           tt_alter_tit_acr_base_2.tta_cod_cart_bcia               = ? /*tit_acr.cod_cart_bcia                  */
           tt_alter_tit_acr_base_2.tta_val_despes_bcia             = ? /*tit_acr.val_despes_bcia                */
           tt_alter_tit_acr_base_2.tta_cod_agenc_cobr_bcia         = ? /*tit_acr.cod_agenc_cobr_bcia            */
           tt_alter_tit_acr_base_2.tta_cod_tit_acr_bco             = ? /*tit_acr.cod_tit_acr_bco                */
           tt_alter_tit_acr_base_2.tta_dat_emis_docto              = ? /*tit_acr.dat_emis_docto                 */
           tt_alter_tit_acr_base_2.tta_dat_vencto_tit_acr          = tit_acr.dat_vencto_tit_acr
           tt_alter_tit_acr_base_2.tta_dat_prev_liquidac           = tit_acr.dat_prev_liquidac 
           tt_alter_tit_acr_base_2.tta_dat_fluxo_tit_acr           = ? /*tit_acr.dat_fluxo_tit_acr              */
           tt_alter_tit_acr_base_2.tta_ind_sit_tit_acr             = ? /*tit_acr.ind_sit_tit_acr                */
           tt_alter_tit_acr_base_2.tta_cod_cond_cobr               = ? /*tit_acr.cod_cond_cobr                  */
           tt_alter_tit_acr_base_2.tta_log_tip_cr_perda_dedut_tit  = ? /*tit_acr.log_tip_cr_perda_dedut_tit     */
           tt_alter_tit_acr_base_2.tta_dat_abat_tit_acr            = ? /*tit_acr.dat_abat_tit_acr               */
           tt_alter_tit_acr_base_2.tta_val_perc_abat_acr           = ? /*tit_acr.val_perc_abat_acr              */
           tt_alter_tit_acr_base_2.tta_val_abat_tit_acr            = ? /*tit_acr.val_abat_tit_acr               */
           tt_alter_tit_acr_base_2.tta_dat_desconto                = ? /*tit_acr.dat_desconto                   */
           tt_alter_tit_acr_base_2.tta_val_perc_desc               = ? /*tit_acr.val_perc_desc                  */
           tt_alter_tit_acr_base_2.tta_val_desc_tit_acr            = ? /*tit_acr.val_desc_tit_acr               */
           tt_alter_tit_acr_base_2.tta_qtd_dias_carenc_juros_acr   = ? /*tit_acr.qtd_dias_carenc_juros_acr      */
           tt_alter_tit_acr_base_2.tta_val_perc_juros_dia_atraso   = ? /*tit_acr.val_perc_juros_dia_atraso      */
           tt_alter_tit_acr_base_2.tta_qtd_dias_carenc_multa_acr   = ? /*tit_acr.qtd_dias_carenc_multa_acr      */
           tt_alter_tit_acr_base_2.tta_val_perc_multa_atraso       = ? /*tit_acr.val_perc_multa_atraso          */
           tt_alter_tit_acr_base_2.ttv_cod_portador_mov            = ?
           tt_alter_tit_acr_base_2.tta_ind_tip_cobr_acr            = ? /*tit_acr.ind_tip_cobr_acr               */
           tt_alter_tit_acr_base_2.tta_ind_ender_cobr              = ? /*tit_acr.ind_ender_cobr                 */
           tt_alter_tit_acr_base_2.tta_nom_abrev_contat            = ? /*tit_acr.nom_abrev_contat               */
           tt_alter_tit_acr_base_2.tta_val_liq_tit_acr             = ? /*tit_acr.val_liq_tit_acr                */
           tt_alter_tit_acr_base_2.tta_cod_instruc_bcia_1_movto    = ?                                         
           tt_alter_tit_acr_base_2.tta_cod_instruc_bcia_2_movto    = ?                                        
           tt_alter_tit_acr_base_2.tta_log_tit_acr_destndo         = ? /*tit_acr.log_tit_acr_destndo            */
           tt_alter_tit_acr_base_2.tta_cod_histor_padr             = ?                                        
           tt_alter_tit_acr_base_2.ttv_des_text_histor             = ?
                        /* "Alteraá∆o de portador para fechamento de vendor em " + STRING(TODAY,"99/99/9999") */

           tt_alter_tit_acr_base_2.tta_des_obs_cobr                = ? /*tit_acr.des_obs_cobr                     */
           /*tt_alter_tit_acr_base_2.ttv_wgh_lista                   = tit_acr.wgh_lista                      */
           tt_alter_tit_acr_base_2.tta_num_seq_tit_acr             = ? /*tit_acr.num_seq_tit_acr*/               
           tt_alter_tit_acr_base_2.ttv_cod_estab_planilha          = ? /*tit_acr.cod_estab */
           tt_alter_tit_acr_base_2.tta_cod_tit_acr_bco             = ? 
           
           tt_alter_tit_acr_base_2.ttv_num_planilha_vendor         = ?  /* tit_acr.num_planilha_vendor           */
           tt_alter_tit_acr_base_2.ttv_cod_cond_pagto_vendor       = ? /* tit_acr.cod_cond_pagto_vendor            */
           tt_alter_tit_acr_base_2.ttv_val_cotac_tax_vendor_clien  = ? /* tit_acr.val_cotac_tax_vendor_clien       */
           tt_alter_tit_acr_base_2.ttv_dat_base_fechto_vendor      = ? /* tit_acr.dat_base_fechto_vendor           */
           tt_alter_tit_acr_base_2.ttv_qti_dias_carenc_fechto      = ? /* tit_acr.qti_dias_carenc_fechto           */
           tt_alter_tit_acr_base_2.ttv_log_assume_tax_bco          = ? /* tit_acr.log_assume_tax_bco               */
           tt_alter_tit_acr_base_2.ttv_log_vendor                  = ? /* tit_acr.log_vendor                   */
             
           tt_alter_tit_acr_base_2.tta_cod_portador                = pCodPortador
           tt_alter_tit_acr_base_2.tta_cod_cart_bcia               = pCodCartBcia
        .

    run prgfin/acr/acr711zo.py (Input 4,
                                Input  table tt_alter_tit_acr_base_2,
                                Input  table tt_alter_tit_acr_rateio,
                                Input  table tt_alter_tit_acr_ped_vda,
                                Input  table tt_alter_tit_acr_comis,
                                Input  table tt_alter_tit_acr_cheq,
                                Input  table tt_alter_tit_acr_iva,
                                Input  table tt_alter_tit_acr_impto_retid_2,
                                Input  table tt_alter_tit_acr_cobr_espec_2,
                                Input  table tt_alter_tit_acr_rat_desp_rec,
                                output table tt_log_erros_alter_tit_acr,
                                Input no).

    IF CAN-FIND(FIRST tt_log_erros_alter_tit_acr) THEN DO:
        FOR FIRST  tt_log_erros_alter_tit_acr:
            MESSAGE 
                  "Estab: "              tt_log_erros_alter_tit_acr.tta_cod_estab                    SKIP
                  "Token Cta Receber: "  tt_log_erros_alter_tit_acr.tta_num_id_tit_acr               SKIP
                  "N£mero Mensagem: "    tt_log_erros_alter_tit_acr.ttv_num_mensagem                 SKIP
                  "Tipo Mensagem: "      tt_log_erros_alter_tit_acr.ttv_cod_tip_msg_dwb              SKIP
                  "Inconsistància: "     tt_log_erros_alter_tit_acr.ttv_des_msg_erro                 SKIP
                  "Mensagem Ajuda: "     tt_log_erros_alter_tit_acr.ttv_des_msg_ajuda                SKIP
                  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        END.
    END.
    ELSE do:
        FOR EACH tt_alter_tit_acr_base_2: DELETE tt_alter_tit_acr_base_2. END.
        pReturn = "OK".
    END.

END PROCEDURE.
