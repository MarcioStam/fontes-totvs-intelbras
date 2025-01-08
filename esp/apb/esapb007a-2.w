&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME frame-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS frame-2 
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

/* Local Variable Definitions ---                                       */
&SCOPED-DEFINE NomProg   ESAPB007A
&SCOPED-DEFINE DescProg  Novo T¡tulo APB Representante

/* Temporary Tables Definitions - variÿveis utilizadas na API*/
{esp/cms/apb767zc.i}

{esp/cms/apb768za.i}

{esp/cms/apb900zd.i}

def temp-table tt_imp
    FIELD cod_estab      LIKE tit_ap.cod_estab
    FIELD cdn_fornecedor LIKE fornecedor.cdn_fornecedor
    FIELD nom_abrev      LIKE fornecedor.nom_abrev
    field cdn_repres     LIKE representante.cdn_repres
    field nom_abrev_r    LIKE representante.nom_abrev
    field cod_ser_docto  LIKE tit_ap.cod_ser_docto column-label "Sr" format "X(03)"
    FIELD cod_espec_docto LIKE tit_ap.cod_espec_docto
    field cod_tit_ap     LIKE tit_ap.cod_tit_ap  column-label "Docto" format "X(10)"
    field num_id_tit_ap  LIKE tit_ap.num_id_tit_ap  
    field cod_parcela    AS CHAR FORMAT "x(5)" column-label "Parc"
    field dat_vencto_tit_ap LIKE tit_ap.dat_vencto_tit_ap format "99/99/9999" column-label "Dt Vcto"
    field dat_liquidac_tit_ap LIKE tit_ap.dat_liquidac_tit_ap   format "99/99/9999" column-label "Dt Baixa"
    field dat_pedido            as date format "99/99/9999" column-label "Dt Pedido"
    field cdn_cliente           LIKE emscad.cliente.cdn_cliente column-label "Cliente"
    field nom_abrev_c           LIKE emscad.cliente.nom_abrev
    field nom_cidade_c          LIKE pessoa_fisic.nom_cidade
    field cod_unid_federac_c    LIKE  pessoa_fisic.cod_unid_federac
    field val_origin_tit_ap     LIKE tit_ap.val_origin_tit_ap format ">>,>>>,>>9.99" 
    FIELD val_sdo_tit_ap        LIKE tit_ap.val_sdo_tit_ap format ">>,>>>,>>9.99" COLUMN-LABEL "Valor s/IR"
    field val_perc_comis_repres LIKE repres_tit_acr.val_perc_comis_repres format ">>9.99" 
    field val_base              as dec format ">>,>>>,>>9.99" column-label "Valor Base"
    field cod_e_mail            LIKE pessoa_fisic.cod_e_mail
    index tt-imprime is primary cdn_fornecedor
                                cod_espec_docto
                                cod_ser_docto   
                                cod_tit_ap      
                                cod_parcela.    
    
def temp-table tt-comis-deb-cred LIKE mgesp.comis-deb-cred
    FIELD descricao   LIKE mov-comis.descricao
    FIELD selecao     AS CHAR FORMAT 'x(1)' LABEL '' COLUMN-LABEL 'Sele‡Æo'.

DEF TEMP-TABLE tt_antecip NO-UNDO
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"                                               
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"                                           
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"                                               
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"                                
    field tta_cod_tit_ap                   as character format "x(10)" label "T¡tulo" column-label "T¡tulo"                                                      
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"                                                       
    field tta_dat_transacao                AS DATE format "99/99/9999" label "Dt Transa‡Æo" column-label "Dt Transa‡Æo"
    field tta_val_abat_tit_ap              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatimento" column-label "Vl Abatimento"
    field tta_val_tit_ap                   as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor T¡tulo" column-label "Vl T¡tulo"
    FIELD tta_selecao                      AS CHAR FORMAT 'x(1)' LABEL '' COLUMN-LABEL 'Sele‡Æo'.

DEF TEMP-TABLE tt_log_erro_atualiz_rpc NO-UNDO 
    FIELD tta_cod_estab                    AS CHARACTER FORMAT "x(3)"     LABEL "Estabelecimento" column-label "Estab" 
    FIELD tta_cod_refer                    AS CHARACTER FORMAT "x(10)"    LABEL "Refer¼ncia" column-label "Refer¼ncia" 
    FIELD tta_num_seq_refer                AS INTEGER   FORMAT ">>>9"     INITIAL 0 label "Sequ¼ncia" column-label "Seq" 
    FIELD ttv_num_mensagem                 AS INTEGER   FORMAT ">>>>,>>9" LABEL "Nœmero" column-label "Nœmero Mensagem" 
    FIELD ttv_des_msg_erro                 AS CHARACTER FORMAT "x(60)"    LABEL "Mensagem Erro" column-label "Inconsist¼ncia" 
    FIELD ttv_des_msg_ajuda                AS CHARACTER FORMAT "x(40)"    LABEL "Mensagem Ajuda" column-label "Mensagem Ajuda" 
    FIELD ttv_ind_tip_relacto              AS CHARACTER FORMAT "X(15)"    LABEL "Tipo Relacionamento" column-label "Tipo Relac" 
    FIELD ttv_num_relacto                  AS INTEGER   FORMAT ">>>>,>>9" LABEL  "Relacionamento" column-label "Relacionamento". 


/* parƒmetros */

DEF INPUT PARAM TABLE FOR tt_imp.
DEF INPUT PARAM p_repres         AS INTEGER NO-UNDO.
DEF INPUT PARAM p_data_ini       AS DATE NO-UNDO.
DEF INPUT PARAM p_data_fim       AS DATE NO-UNDO.
DEF INPUT PARAM p_data_bxa       AS DATE NO-UNDO.
DEF INPUT PARAM p_fornec         AS INTEGER NO-UNDO.
DEF INPUT PARAM p_vl_bruto_comis AS DECIMAL NO-UNDO.
DEF INPUT PARAM p_vl_total_ir    AS DECIMAL NO-UNDO.
DEF INPUT PARAM p_vl_cred        AS DECIMAL NO-UNDO.
DEF INPUT PARAM p_vl_deb         AS DECIMAL NO-UNDO.
DEF INPUT PARAM TABLE FOR tt-comis-deb-cred.
DEF INPUT PARAM TABLE FOR tt_antecip.

def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
def new global shared var v_cod_grp_usuar_lst
    as character
    format "x(3)":U
    label "Grupo Usuÿrios"
    column-label "Grupo"
    no-undo.
def new global shared var v_cod_idiom_usuar
    as character
    format "x(8)":U
    label "Idioma"
    column-label "Idioma"
    no-undo.
def new global shared var v_cod_pais_empres_usuar
    as character
    format "x(3)":U
    label "Pa­s Empresa Usuÿrio"
    column-label "Pa­s"
    no-undo.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usuÿrio Corrente"
    column-label "Usuÿrio Corrente"
    no-undo.
def new global shared var v_cod_usuar_corren_criptog
    as character
    format "x(16)":U
    no-undo.


DEF VAR v_cod_espec_docto    LIKE tit_ap.cod_espec_docto NO-UNDO.
DEF VAR v_cod_ser_docto      LIKE tit_ap.cod_ser_docto   NO-UNDO.
DEF VAR v_cod_tit_ap         LIKE tit_ap.cod_tit_ap      NO-UNDO.
DEF VAR v_cod_parcela        LIKE tit_ap.cod_parcela     NO-UNDO.

DEF VAR v_cod_estab          LIKE tit_ap.cod_estab        NO-UNDO.
DEF VAR v_cdn_fornec         LIKE tit_ap.cdn_fornecedor   NO-UNDO.
DEF VAR v_cod_refer          LIKE tit_ap.cod_refer        NO-UNDO.
DEF VAR v_dat_vencto         LIKE tit_ap.dat_vencto       NO-UNDO.
DEF VAR v_val_baixa          LIKE tit_ap.val_pagto_tit_ap NO-UNDO.
DEF VAR v_val_desc           LIKE tit_ap.val_desconto     NO-UNDO.
DEF VAR v_cod_portador       LIKE tit_ap.cod_portador     NO-UNDO.
DEF VAR v_val_ir             LIKE tit_ap.val_pagto_tit_ap NO-UNDO.
DEF VAR v_dat_vencto_ir      LIKE tit_ap.dat_vencto       NO-UNDO.
DEF VAR v_data_refer         AS DATE NO-UNDO.
DEF VAR vl_total_ir_aux      LIKE tit_ap.val_pagto_tit_ap NO-UNDO.
DEF VAR v_cod_refer_alt      LIKE tit_ap.cod_refer        NO-UNDO.
DEF VAR v_cod_refer_alt_ma   LIKE tit_ap.cod_refer        NO-UNDO.
DEF VAR v_cod_refer_alt_me   LIKE tit_ap.cod_refer        NO-UNDO.
DEF VAR v_log_erro           AS LOG INITIAL NO.
DEF VAR l_erro_alt_ava_maior AS LOGICAL                     NO-UNDO.
DEF VAR l_erro_alt_ava_menor AS LOGICAL                     NO-UNDO.
DEF VAR  v_val_ava_aux       LIKE tit_ap.val_pagto_tit_ap NO-UNDO.

DEF VAR v_sdo_tit_ap_aux     LIKE tit_ap.val_sdo_tit_ap NO-UNDO.
DEF VAR v_ct_codigo          LIKE conta-programa.ct-codigo NO-UNDO.
DEF VAR v_ct_codigo_ava_maior LIKE conta-programa.ct-codigo NO-UNDO.
DEF VAR v_sc_codigo_ava_maior LIKE conta-programa.sc-codigo NO-UNDO.
DEF VAR v_ct_codigo_ava_menor LIKE conta-programa.ct-codigo NO-UNDO.
DEF VAR v_sc_codigo_ava_menor LIKE conta-programa.sc-codigo NO-UNDO.

DEF VAR v_num_seq_alt    AS INTEGER INITIAL 0 NO-UNDO.
DEF VAR v_des_histor     AS CHAR FORMAT 'x(2000)' NO-UNDO.
DEF VAR v_cod_tip_fluxo_financ AS CHAR FORMAT 'x(05)' NO-UNDO.

DEF VAR l_erro_pi_impl AS LOGICAL INITIAL NO NO-UNDO.
DEF VAR l_erro_pi_alt  AS LOGICAL INITIAL NO NO-UNDO.

DEF VAR v_nom_arquivo  AS CHAR FORMAT "x(35)"  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frame-2

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS estab serie titulo parcela fornec refer ~
data-venc vl-baixa desconto portador histor despesa vl-ir data-venc-ir ~
bt-confirma bt-cancel RECT-31 RECT-34 RECT-35 
&Scoped-Define DISPLAYED-OBJECTS estab especie serie titulo parcela fornec ~
refer data-venc vl-baixa desconto portador histor despesa vl-ir ~
data-venc-ir 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-cancel AUTO-END-KEY 
     LABEL "Cancela" 
     SIZE 12 BY 1.13
     BGCOLOR 8 .

DEFINE BUTTON bt-confirma AUTO-GO 
     LABEL "Confirma" 
     SIZE 12 BY 1.13
     BGCOLOR 8 .

DEFINE VARIABLE histor AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP MAX-CHARS 2000 SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 30 BY 2.5 NO-UNDO.

DEFINE VARIABLE data-venc AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Venc" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE data-venc-ir AS DATE FORMAT "99/99/9999":U 
     LABEL "Dt Venc IR" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE desconto AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Desconto" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE despesa AS CHARACTER FORMAT "X(5)":U INITIAL "204" 
     LABEL "Tipo Despesa" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE especie AS CHARACTER FORMAT "X(3)":U INITIAL "NF" 
     LABEL "Esp‚cie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE estab AS CHARACTER FORMAT "X(03)":U INITIAL "101" 
     LABEL "Estab" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fornec AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 10.43 BY .88 NO-UNDO.

DEFINE VARIABLE parcela AS CHARACTER FORMAT "X(02)":U 
     LABEL "Parcela" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE portador AS CHARACTER FORMAT "X(5)":U INITIAL "999" 
     LABEL "Portador" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE refer AS CHARACTER FORMAT "X(10)":U 
     LABEL "Referˆncia" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE serie AS CHARACTER FORMAT "X(3)":U 
     LABEL "S‚rie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE titulo AS CHARACTER FORMAT "X(10)":U 
     LABEL "T¡tulo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE vl-baixa AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Vl Baixas" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE vl-ir AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Vl IR" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 34 BY 14.75.

DEFINE RECTANGLE RECT-34
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 25 BY 9.5.

DEFINE RECTANGLE RECT-35
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 25 BY 3.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frame-2
     estab AT ROW 1.75 COL 14 COLON-ALIGNED
     especie AT ROW 2.71 COL 14 COLON-ALIGNED
     serie AT ROW 3.67 COL 14 COLON-ALIGNED
     titulo AT ROW 4.67 COL 14 COLON-ALIGNED
     parcela AT ROW 5.63 COL 14 COLON-ALIGNED
     fornec AT ROW 6.63 COL 14 COLON-ALIGNED
     refer AT ROW 7.63 COL 14 COLON-ALIGNED
     data-venc AT ROW 8.63 COL 14 COLON-ALIGNED
     vl-baixa AT ROW 9.58 COL 14 COLON-ALIGNED
     desconto AT ROW 10.58 COL 14 COLON-ALIGNED
     portador AT ROW 11.58 COL 14 COLON-ALIGNED
     histor AT ROW 13.04 COL 5 NO-LABEL
     despesa AT ROW 1.79 COL 46 COLON-ALIGNED
     vl-ir AT ROW 5.33 COL 44 COLON-ALIGNED
     data-venc-ir AT ROW 6.33 COL 44 COLON-ALIGNED
     bt-confirma AT ROW 14.58 COL 37
     bt-cancel AT ROW 14.58 COL 49.43
     "Novo t¡tulo" VIEW-AS TEXT
          SIZE 9 BY .67 AT ROW 1 COL 3
     "T¡tulo IR" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 4.5 COL 38
     "Hist¢rico" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 12.38 COL 5.29
     RECT-31 AT ROW 1.25 COL 2
     RECT-34 AT ROW 4.75 COL 37
     RECT-35 AT ROW 1.25 COL 37
     SPACE(0.56) SKIP(11.66)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 1
         TITLE "NF no APB - ESAPB007A-2"
         DEFAULT-BUTTON bt-confirma CANCEL-BUTTON bt-cancel.


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
/* SETTINGS FOR DIALOG-BOX frame-2
   Custom                                                               */
ASSIGN 
       FRAME frame-2:SCROLLABLE       = FALSE
       FRAME frame-2:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN especie IN FRAME frame-2
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME frame-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL frame-2 frame-2
ON WINDOW-CLOSE OF FRAME frame-2 /* T¡t APB Repres - ESAPB007A */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-confirma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-confirma frame-2
ON CHOOSE OF bt-confirma IN FRAME frame-2 /* Confirma */
DO:

    ASSIGN l_erro_pi_impl = NO
           l_erro_pi_alt  = NO
           l_erro_alt_ava_maior = NO
           l_erro_alt_ava_menor = NO.

    RUN pi-valida.

    IF RETURN-VALUE = 'NOK' THEN 
        RETURN NO-APPLY.

    IF RETURN-VALUE = 'OK' THEN  DO:
        
        ASSIGN v_cod_estab            = estab:SCREEN-VALUE IN FRAME frame-2          
               v_cod_espec_docto      = especie:SCREEN-VALUE IN FRAME frame-2        
               v_cod_ser_docto        = serie:SCREEN-VALUE IN FRAME frame-2          
               v_cod_tit_ap           = titulo:SCREEN-VALUE IN FRAME frame-2         
               v_cod_parcela          = parcela:SCREEN-VALUE IN FRAME frame-2        
               v_cdn_fornec           = int(fornec:SCREEN-VALUE IN FRAME frame-2)    
               v_cod_refer            = refer:SCREEN-VALUE IN FRAME frame-2          
               v_dat_vencto           = date(data-venc:SCREEN-VALUE IN FRAME frame-2)
               v_val_baixa            = dec(vl-baixa:SCREEN-VALUE IN FRAME frame-2)  
               v_val_desc             = dec(desconto:SCREEN-VALUE IN FRAME frame-2)  
               v_cod_portador         = portador:SCREEN-VALUE IN FRAME frame-2       
               v_cod_tip_fluxo_financ = despesa:SCREEN-VALUE IN FRAME frame-2
               v_des_histor           = histor:SCREEN-VALUE IN FRAME frame-2                 
               v_val_ir               = dec(vl-ir:SCREEN-VALUE IN FRAME frame-2)
               v_dat_vencto_ir        = date(data-venc-ir:SCREEN-VALUE IN FRAME frame-2).

        
        FOR EACH tt_tit_ap_alteracao_base_1:
            DELETE tt_tit_ap_alteracao_base_1.
        END.
        FOR EACH tt_tit_ap_alteracao_rateio:
            DELETE tt_tit_ap_alteracao_rateio.
        END.
        FOR EACH tt_log_erros_tit_ap_alteracao:
            DELETE tt_log_erros_tit_ap_alteracao.
        END.

        FOR EACH tt_integr_apb_lote_impl:
            DELETE tt_integr_apb_lote_impl.
        END.
        
        FOR EACH tt_integr_apb_item_lote_impl_2:
            DELETE tt_integr_apb_item_lote_impl_2.
        END.
        
        FOR EACH tt_integr_apb_aprop_ctbl_pend:
            DELETE tt_integr_apb_aprop_ctbl_pend.
        END.
        
        FOR EACH tt_integr_apb_impto_impl_pend:
            DELETE tt_integr_apb_impto_impl_pend.
        END.
        
        FOR EACH tt_integr_apb_abat_prev_provis:
            DELETE tt_integr_apb_abat_prev_provis.
        END.
        
        FOR EACH tt_integr_apb_abat_antecip_vouc:
            DELETE tt_integr_apb_abat_antecip_vouc.
        END.
            
        ASSIGN v_nom_arquivo = ''.
        
        /* ** Implanta NF no contas a pagar e faz AVAs conforme DB/CR ***/
        RUN pi-impl-tit-apb.

        IF l_erro_pi_impl 
        OR l_erro_pi_alt 
        THEN DO:
    
             RUN esp/apb/esapb007b.p (INPUT TABLE tt_log_erros_atualiz,
                                      INPUT TABLE tt_log_erros_tit_ap_alteracao,
                                      INPUT TABLE tt_log_erro_atualiz_rpc,
                                      OUTPUT v_nom_arquivo).
                                   
        END.

    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK frame-2 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  RUN pi-alimenta-tela.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI frame-2  _DEFAULT-DISABLE
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
  HIDE FRAME frame-2.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI frame-2  _DEFAULT-ENABLE
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
  ASSIGN estab        = "104".
  DISPLAY estab especie serie titulo parcela fornec refer data-venc vl-baixa 
          desconto portador histor despesa vl-ir data-venc-ir 
      WITH FRAME frame-2.
  ENABLE serie titulo especie parcela fornec refer data-venc /*vl-baixa*/ desconto 
         portador histor despesa /*vl-ir*/ data-venc-ir bt-confirma bt-cancel 
         RECT-31 RECT-34 RECT-35 
      WITH FRAME frame-2.
  VIEW FRAME frame-2.
  {&OPEN-BROWSERS-IN-QUERY-frame-2}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-alimenta-tela frame-2 
PROCEDURE pi-alimenta-tela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR v_data_aux_impl  AS CHAR    NO-UNDO.
    DEF VAR v_num_aux_impl   AS INTEGER NO-UNDO.
    DEF VAR v_num_aux_2_impl AS INTEGER NO-UNDO.
    DEF VAR v_num_cont_impl  AS INTEGER NO-UNDO.

    /*
    /**Calculo da data de vencimento do IR - Regra: Sempre a primeira quarta-feira da semana seguinte**/
    IF WEEKDAY(p_data_bxa) = 2 THEN
       ASSIGN data-venc-ir:SCREEN-VALUE IN FRAME frame-2 = STRING(p_data_bxa + 9).
    ELSE DO:
       IF WEEKDAY(p_data_bxa) = 3 THEN
          ASSIGN data-venc-ir:SCREEN-VALUE IN FRAME frame-2 = STRING(p_data_bxa + 8).
       ELSE DO:
          IF WEEKDAY(p_data_bxa) = 4 THEN
             ASSIGN data-venc-ir:SCREEN-VALUE IN FRAME frame-2 = STRING(p_data_bxa + 7).
          ELSE DO:
             IF WEEKDAY(p_data_bxa) = 5 THEN
                ASSIGN data-venc-ir:SCREEN-VALUE IN FRAME frame-2 = STRING(p_data_bxa + 6).
             ELSE DO:
                IF WEEKDAY(p_data_bxa) = 6 OR  
                   WEEKDAY(p_data_bxa) = 7 OR
                   WEEKDAY(p_data_bxa) = 1 THEN
                   ASSIGN data-venc-ir:SCREEN-VALUE IN FRAME frame-2 = STRING(p_data_bxa + 5).
                ELSE DO:
                   ASSIGN data-venc-ir:SCREEN-VALUE IN FRAME frame-2 = STRING(p_data_bxa).
                END.
             END.
          END.
       END.    
    END.
    */

    /**Calculo da data de vencimento do IR - Regra: Sempre no dia 20 do pr¢ximo mˆs, se for final de semana, antecipa**/
    DEFINE VARIABLE v_mes AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_ano AS INTEGER     NO-UNDO.
    ASSIGN v_mes = MONTH(p_data_bxa) + 1
           v_ano = YEAR(p_data_bxa).
    IF v_mes = 13 
       THEN ASSIGN v_mes = 1
                   v_ano = v_ano + 1.
    ASSIGN data-venc-ir:SCREEN-VALUE IN FRAME frame-2 = STRING("20/" + STRING(v_mes, "99") + "/" + STRING(v_ano, "9999")).
    IF WEEKDAY(DATE(data-venc-ir:SCREEN-VALUE IN FRAME frame-2)) = 7  
       THEN ASSIGN data-venc-ir:SCREEN-VALUE IN FRAME frame-2 = STRING("19/" + STRING(v_mes, "99") + "/" + STRING(v_ano, "9999")).
    IF WEEKDAY(DATE(data-venc-ir:SCREEN-VALUE IN FRAME frame-2)) = 1
       THEN ASSIGN data-venc-ir:SCREEN-VALUE IN FRAME frame-2 = STRING("18/" + STRING(v_mes, "99") + "/" + STRING(v_ano, "9999")).

    /*C lculo da referencia*/
    REPEAT:
      ASSIGN refer = 'CMS' + STRING(MONTH(TODAY),'99').
      DO v_num_cont_impl = 1 TO 5:
         ASSIGN v_num_aux_2_impl = integer(this-procedure:handle)
                v_num_aux_impl   = (random(0,v_num_aux_2_impl) mod 26) + 97
                refer            = refer + chr(v_num_aux_impl).    
      END.
      
      FIND FIRST tt_tit_ap_alteracao_base_1 NO-LOCK
           WHERE tt_tit_ap_alteracao_base_1.tta_cod_estab_ext = estab
             AND tt_tit_ap_alteracao_base_1.ttv_cod_refer     = refer NO-ERROR.
      FIND FIRST tt_integr_apb_lote_impl NO-LOCK
          WHERE tt_integr_apb_lote_impl.tta_cod_estab         = estab
          AND   tt_integr_apb_lote_impl.tta_cod_refer         = refer       NO-ERROR.
      FIND FIRST movto_tit_ap NO-LOCK
           WHERE movto_tit_ap.cod_estab                       = estab
             AND movto_tit_ap.cod_refer                       = refer NO-ERROR.
      IF NOT AVAIL movto_tit_ap               AND 
         NOT AVAIL tt_tit_ap_alteracao_base_1 AND 
         NOT AVAIL tt_integr_apb_lote_impl    THEN
        LEAVE.
    END.
    
    ASSIGN fornec:SCREEN-VALUE IN FRAME frame-2       = STRING(p_fornec)
           data-venc:SCREEN-VALUE IN FRAME frame-2    = STRING(p_data_bxa)
           vl-baixa:SCREEN-VALUE IN FRAME frame-2     = STRING(p_vl_bruto_comis)
           vl-ir:SCREEN-VALUE IN FRAME frame-2        = STRING(p_vl_total_ir)
           refer:SCREEN-VALUE IN FRAME frame-2        = STRING(refer).
        
                           
    ASSIGN vl_total_ir_aux = p_vl_total_ir.

     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-impl-tit-apb frame-2 
PROCEDURE pi-impl-tit-apb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR serv_rpc_intelbras_apb900zd AS HANDLE NO-UNDO.

    ASSIGN v_log_erro = NO.

    FIND FIRST servid_rpc NO-LOCK
        WHERE servid_rpc.log_servid_rpc_dispon = YES NO-ERROR.
    
    IF AVAIL servid_rpc THEN DO:
       
       CREATE SERVER serv_rpc_intelbras_apb900zd.
       serv_rpc_intelbras_apb900zd:CONNECT(servid_rpc.des_carg_rpc).

        
       IF serv_rpc_intelbras_apb900zd:CONNECTED() = YES THEN DO:
           
          RUN esp/apb/esapb007e-2.p ON serv_rpc_intelbras_apb900zd TRANSACTION DISTINCT 
                                   (INPUT TABLE tt_imp,
                                    INPUT TABLE tt-comis-deb-cred,
                                    INPUT TABLE tt_antecip,
                                    INPUT v_cod_refer,
                                    INPUT p_data_bxa,
                                    INPUT estab,                      
                                    INPUT v_cod_empres_usuar,
                                    INPUT v_cdn_fornec,
                                    INPUT v_cod_espec_docto,
                                    INPUT v_cod_ser_docto,
                                    INPUT v_cod_tit_ap,
                                    INPUT v_cod_parcela,
                                    INPUT v_dat_vencto,
                                    INPUT v_val_desc,
                                    INPUT v_des_histor,
                                    INPUT v_cod_tip_fluxo_financ,
                                    INPUT v_val_baixa /*p_vl_bruto_comis*/,
                                    INPUT v_val_ir,
                                    INPUT v_dat_vencto_ir,
                                    INPUT v_cod_usuar_corren,
                                    INPUT v_cod_grp_usuar_lst,
                                    INPUT v_cod_idiom_usuar,
                                    INPUT v_cod_pais_empres_usuar,
                                    INPUT v_cod_usuar_corren_criptog,
                                    OUTPUT TABLE tt_log_erro_atualiz_rpc,
                                    OUTPUT l_erro_pi_impl,
                                    OUTPUT l_erro_pi_alt).
          serv_rpc_intelbras_apb900zd:DISCONNECT().
          /***** delete incluso POR CLAUDINEY EM 27/09/2005 ******/
         /* DELETE PROCEDURE serv_rpc_intelbras_apb900zd. */
       END.
       ELSE DO:
          MESSAGE "ON-LINE" VIEW-AS ALERT-BOX.
          RUN esp/apb/esapb007e-2.p 
                           (INPUT TABLE tt_imp,
                            INPUT TABLE tt-comis-deb-cred,
                            INPUT TABLE tt_antecip,
                            INPUT v_cod_refer,
                            INPUT p_data_bxa,
                            INPUT estab,                      
                            INPUT v_cod_empres_usuar,
                            INPUT v_cdn_fornec,
                            INPUT v_cod_espec_docto,
                            INPUT v_cod_ser_docto,
                            INPUT v_cod_tit_ap,
                            INPUT v_cod_parcela,
                            INPUT v_dat_vencto,
                            INPUT v_val_desc,
                            INPUT v_des_histor,
                            INPUT v_cod_tip_fluxo_financ,
                            INPUT v_val_baixa /*p_vl_bruto_comis*/,
                            INPUT v_val_ir,
                            INPUT v_dat_vencto_ir,
                            INPUT v_cod_usuar_corren,
                            INPUT v_cod_grp_usuar_lst,
                            INPUT v_cod_idiom_usuar,
                            INPUT v_cod_pais_empres_usuar,
                            INPUT v_cod_usuar_corren_criptog,
                            OUTPUT TABLE tt_log_erro_atualiz_rpc,
                            OUTPUT l_erro_pi_impl,
                            OUTPUT l_erro_pi_alt).
       END.
    END.
    ELSE DO:
       MESSAGE 'ON-LINE 2' VIEW-AS ALERT-BOX.
       RUN esp/apb/esapb007e-2.p 
                        (INPUT TABLE tt_imp,
                         INPUT TABLE tt-comis-deb-cred,
                         INPUT TABLE tt_antecip,
                         INPUT v_cod_refer,
                         INPUT p_data_bxa,
                         INPUT estab,                      
                         INPUT v_cod_empres_usuar,
                         INPUT v_cdn_fornec,
                         INPUT v_cod_espec_docto,
                         INPUT v_cod_ser_docto,
                         INPUT v_cod_tit_ap,
                         INPUT v_cod_parcela,
                         INPUT v_dat_vencto,
                         INPUT v_val_desc,
                         INPUT v_des_histor,
                         INPUT v_cod_tip_fluxo_financ,
                         INPUT v_val_baixa /*p_vl_bruto_comis*/,
                         INPUT v_val_ir,
                         INPUT v_dat_vencto_ir,
                         INPUT v_cod_usuar_corren,
                         INPUT v_cod_grp_usuar_lst,
                         INPUT v_cod_idiom_usuar,
                         INPUT v_cod_pais_empres_usuar,
                         INPUT v_cod_usuar_corren_criptog,
                         OUTPUT TABLE tt_log_erro_atualiz_rpc,
                         OUTPUT l_erro_pi_impl,
                         OUTPUT l_erro_pi_alt).

    END.

    IF v_log_erro = YES THEN
       RETURN 'NOK'.
    ELSE
       RETURN 'OK'.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-referencia frame-2 
PROCEDURE pi-referencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM p_data AS DATE NO-UNDO.
DEF INPUT  PARAM p_tipo AS CHAR NO-UNDO.
DEF OUTPUT PARAM p_cod_refer AS CHAR NO-UNDO.


DEF VAR v_data_aux  AS CHAR            NO-UNDO.
def var v_num_aux   as integer         no-undo. 
def var v_num_aux_2 as integer         no-undo. 
def var v_num_cont  as integer         no-undo. 
DEF VAR v_log_repeat AS LOGICAL INITIAL yes NO-UNDO.

REPEAT WHILE v_log_repeat:
    assign v_data_aux  = string(p_data,"999999")
           p_cod_refer = substring(v_data_aux,7,2)
                       + substring(v_data_aux,3,2)
                       + substring(v_data_aux,1,2)
                       + substring(p_tipo,1,3)
           v_num_aux_2 = integer(this-procedure:handle).

    do  v_num_cont = 1 to 3:
        assign v_num_aux   = (random(0,v_num_aux_2) mod 26) + 97
               p_cod_refer = p_cod_refer + chr(v_num_aux).
    end.

    FIND FIRST movto_tit_ap NO-LOCK
        WHERE movto_tit_ap.cod_estab = estab
          AND movto_tit_ap.cod_refer = p_cod_refer NO-ERROR.
    IF NOT AVAIL movto_tit_ap THEN DO:
       ASSIGN v_log_repeat = NO.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida frame-2 
PROCEDURE pi-valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF estab:SCREEN-VALUE IN FRAME frame-2 = '' THEN DO:
   MESSAGE 'Estabelecimento nÆo informado!' VIEW-AS ALERT-BOX INFO BUTTONS OK.
   RETURN 'NOK'.
END.

IF especie:SCREEN-VALUE IN FRAME frame-2 = ''  THEN DO:
   MESSAGE 'Esp‚cie nÆo informada!' VIEW-AS ALERT-BOX INFO BUTTONS OK.
   RETURN 'NOK'.
END.

IF serie:SCREEN-VALUE IN FRAME frame-2 = ''  THEN DO:
   MESSAGE 'S‚rie nÆo informada!' VIEW-AS ALERT-BOX INFO BUTTONS OK.
   RETURN 'NOK'.
END.

IF titulo:SCREEN-VALUE IN FRAME frame-2 = '' THEN DO:
   MESSAGE 'T¡tulo nÆo informado!' VIEW-AS ALERT-BOX INFO BUTTONS OK.
   RETURN 'NOK'.
END.

IF parcela:SCREEN-VALUE IN FRAME frame-2 = '' THEN DO:
   MESSAGE 'Parcela nÆo informada!' VIEW-AS ALERT-BOX INFO BUTTONS OK.
   RETURN 'NOK'.
END.

IF int(fornec:SCREEN-VALUE IN FRAME frame-2) = 0 THEN DO:
   MESSAGE 'Fornecedor nÆo informado!' VIEW-AS ALERT-BOX INFO BUTTONS OK.
   RETURN 'NOK'.
END.

IF refer:SCREEN-VALUE IN FRAME frame-2 = '' THEN DO:
   MESSAGE 'Referˆncia nÆo informada!' VIEW-AS ALERT-BOX INFO BUTTONS OK.
   RETURN 'NOK'.
END.

IF dec(vl-baixa:SCREEN-VALUE IN FRAME frame-2) = 0 THEN DO:
   MESSAGE 'Valor Baixa nÆo informada!' VIEW-AS ALERT-BOX INFO BUTTONS OK.
   RETURN 'NOK'.
END.

IF portador:SCREEN-VALUE IN FRAME frame-2 = ''  THEN DO:
   MESSAGE 'Portador nÆo informado!' VIEW-AS ALERT-BOX INFO BUTTONS OK.
   RETURN 'NOK'.
END.

/*
IF dec(vl-ir:SCREEN-VALUE IN FRAME frame-2) = 0 THEN DO:
   MESSAGE 'Valor IR nÆo informado!' VIEW-AS ALERT-BOX INFO BUTTONS OK.
   RETURN 'NOK'.
END.
*/
/*Mario Fleith - em 06/06/2005
IF dec(vl-ir:SCREEN-VALUE IN FRAME frame-2) > vl_total_ir_aux THEN DO:
    MESSAGE 'Valor IR informado ‚ maior que o valor calculado do IR!' VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN 'NOK'.
END.
*/

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

