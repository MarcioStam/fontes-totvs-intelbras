/*****************************************************************************
** Nome Externo..........: esp/fas/esfas008.p
** Data Criaá∆o..........: 02/09/2009
** Criado por............: Fabiano Zarpe Henke
*****************************************************************************/

/************************* Variable Definition Begin ************************/

DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar
    AS CHARACTER FORMAT "x(3)":U
    LABEL "Empresa" COLUMN-LABEL "Empresa" NO-UNDO.
DEFINE VARIABLE v_cod_ccusto_antigo AS CHARACTER FORMAT "99999" LABEL "CCusto Antigo" INITIAL "00000" NO-UNDO.
DEFINE VARIABLE v_cod_ccusto_novo   AS CHARACTER FORMAT "99999" LABEL "CCusto Novo"   INITIAL "00000" NO-UNDO.
DEFINE VARIABLE v_cod_unid_novo     AS CHARACTER FORMAT "x(03)" LABEL "UN Nova"       NO-UNDO.
DEFINE VARIABLE v_log_answer        AS LOGICAL INITIAL NO                             NO-UNDO.
DEFINE VARIABLE v_cod_estab         AS CHARACTER FORMAT "x(03)" LABEL "Estab"         NO-UNDO.
DEFINE VARIABLE v_log_method AS LOGICAL     NO-UNDO.
DEFINE VARIABLE v_val_percentual    AS DECIMAL     NO-UNDO.

DEF BUFFER b_aloc_bem FOR aloc_bem.


/************************** Variable Definition End *************************/

/************************ Rectangle Definition Begin ************************/

def rectangle rt_005
    size 1 by 1
    edge-pixels 2.
def rectangle rt_cxcf
    size 1 by 1
    fgcolor 1 edge-pixels 2.

/************************* Rectangle Definition End *************************/

/************************** Button Definition Begin *************************/

def button bt_can
    label "Cancela"
    tooltip "Cancela"
    size 1 by 1
    auto-endkey.
def button bt_ok
    label "OK"
    tooltip "OK"
    size 1 by 1
    auto-go.

/*************************** Button Definition End **************************/

/************************** Editor Definition Begin *************************/

def var ed_1x40
    as character
    view-as editor no-word-wrap
    size 40 by 1
    bgcolor 15 font 2
    no-undo.

/*************************** Editor Definition End **************************/

/************************** Frame Definition Begin **************************/

def frame f_frame_1
    rt_005
         at row 01.42 col 02.14
    " Seleá∆o " view-as text
         at row 01.12 col 04.14 bgcolor 8 
    rt_cxcf
         at row 07.08 col 02.00 bgcolor 7 
    v_cod_estab
         at row 02.08 col 15.43 colon-aligned
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_ccusto_antigo
         at row 03.08 col 15.43 colon-aligned
         view-as fill-in
         size-chars 6.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_ccusto_novo  
         at row 04.08 col 15.43 colon-aligned
         view-as fill-in
         size-chars 6.14 by .88
         fgcolor ? bgcolor 15 font 2
    v_cod_unid_novo    
         at row 05.08 col 15.43 colon-aligned
         view-as fill-in
         size-chars 4.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_ok
         at row 07.33 col 03.00 font ?
         help "OK"
    bt_can
         at row 07.33 col 14.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 37.00 by 8.96
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Transferir Alocaá‰es - esfas008".
    assign bt_can:width-chars          in frame f_frame_1 = 10.00
           bt_can:height-chars         in frame f_frame_1 = 01.00
           bt_ok:width-chars           in frame f_frame_1 = 10.00
           bt_ok:height-chars          in frame f_frame_1 = 01.00
           rt_cxcf:width-chars         in frame f_frame_1 = 33.00
           rt_cxcf:height-chars        in frame f_frame_1 = 01.42
           rt_005:width-chars          in frame f_frame_1 = 33.00
           rt_005:height-chars         in frame f_frame_1 = 05.30.

/*************************** Frame Definition End ***************************/

/************************ User Interface Trigger End ************************/

ON CHOOSE OF bt_ok IN FRAME f_frame_1 /* Confirma */
DO:

     ASSIGN INPUT FRAME f_frame_1 v_cod_estab v_cod_ccusto_antigo v_cod_ccusto_novo v_cod_unid_novo.

     FIND ccusto_unid_negoc NO-LOCK 
        WHERE ccusto_unid_negoc.cod_empresa      = v_cod_empres_usuar
          AND ccusto_unid_negoc.cod_plano_ccusto = "PADRAO"
          AND ccusto_unid_negoc.cod_ccusto       = v_cod_ccusto_novo
          AND ccusto_unid_negoc.cod_unid_negoc   = v_cod_unid_novo NO-ERROR.
     IF NOT AVAIL ccusto_unid_negoc 
     THEN DO:
          MESSAGE "Centro de custo informado n∆o est† habilitado para a UN informada!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
          RETURN NO-APPLY.
     END.

     FIND cc_uni_estab NO-LOCK
         WHERE cc_uni_estab.cod_ccusto     = v_cod_ccusto_novo
           AND cc_uni_estab.cod_unid_negoc = v_cod_unid_novo
           AND cc_uni_estab.cod_estab      = v_cod_estab NO-ERROR.
     IF NOT AVAIL cc_uni_estab 
     THEN DO:
          MESSAGE "Centro de custo informado n∆o est† habilitado para a UN e Estabelecimento informado (ESFGL001)!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
          RETURN NO-APPLY.
     END.

     FIND estabelecimento NO-LOCK
         WHERE estabelecimento.cod_empresa = v_cod_empres_usuar
           AND estabelecimento.cod_estab   = v_cod_estab NO-ERROR.
     IF NOT AVAIL estabelecimento 
     THEN DO:
          MESSAGE "Estabelecimento inexistente !"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
          RETURN NO-APPLY.
     END.

     MESSAGE "Confirma a alteraá∆o do CCusto " v_cod_ccusto_antigo " para o CCusto " v_cod_ccusto_novo " ?" 
             VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE v_log_answer.

     IF v_log_answer = yes
     THEN DO:

          ASSIGN v_log_method = SESSION:SET-WAIT-STATE('general').
 
          main_block:
          DO TRANSACTION ON ENDKEY UNDO main_block, LEAVE main_block ON ERROR UNDO main_block, LEAVE main_block.

              FOR EACH aloc_bem EXCLUSIVE-LOCK
                  WHERE aloc_bem.cod_empresa      = v_cod_empres_usuar
                    AND aloc_bem.cod_plano_ccusto = "PADRAO"
                    AND aloc_bem.cod_ccusto       = v_cod_ccusto_antigo
                    /*AND aloc_bem.cod_unid_negoc  <> v_cod_unid_novo*/:
    
                  FIND bem_pat NO-LOCK OF aloc_bem NO-ERROR.
    
                  IF NOT AVAIL bem_pat
                  OR bem_pat.cod_estab <> v_cod_estab 
                     THEN NEXT.
    
                  FIND b_aloc_bem EXCLUSIVE-LOCK
                     WHERE b_aloc_bem.num_id_bem_pat   = aloc_bem.num_id_bem_pat
                       AND b_aloc_bem.cod_empresa      = aloc_bem.cod_empresa
                       AND b_aloc_bem.cod_plano_ccusto = aloc_bem.cod_plano_ccusto
                       AND b_aloc_bem.cod_ccusto       = v_cod_ccusto_novo
                       AND b_aloc_bem.cod_unid_negoc   = v_cod_unid_novo NO-ERROR.
                  IF NOT AVAIL b_aloc_bem
                  THEN DO: 
                       CREATE b_aloc_bem.
                       ASSIGN b_aloc_bem.num_id_bem_pat   = aloc_bem.num_id_bem_pat
                              b_aloc_bem.cod_empresa      = aloc_bem.cod_empresa
                              b_aloc_bem.cod_plano_ccusto = aloc_bem.cod_plano_ccusto
                              b_aloc_bem.dat_inic_valid   = aloc_bem.dat_inic_valid
                              b_aloc_bem.dat_fim_valid    = date(12,31,9999)
                              b_aloc_bem.val_perc_aprop   = aloc_bem.val_perc_aprop
                              b_aloc_bem.cod_ccusto       = v_cod_ccusto_novo
                              b_aloc_bem.cod_unid_negoc   = v_cod_unid_novo.
                  END.
                  ELSE DO:
                       IF RECID(aloc_bem) <> RECID(b_aloc_bem)
                          THEN  ASSIGN b_aloc_bem.val_perc_aprop = b_aloc_bem.val_perc_aprop + aloc_bem.val_perc_aprop.
                  END.
    
                  /* ** Alterou somente a Unidade de Neg¢cio ***/
                  IF  v_cod_ccusto_novo        = v_cod_ccusto_antigo
                  AND aloc_bem.cod_unid_negoc <> v_cod_unid_novo
                      THEN ASSIGN aloc_bem.val_perc_aprop   = 0.
                  
                  /* ** Alterou somente o Centro de Custo ***/
                  IF  v_cod_ccusto_novo       <> v_cod_ccusto_antigo
                  AND aloc_bem.cod_unid_negoc  = v_cod_unid_novo
                      THEN ASSIGN aloc_bem.val_perc_aprop   = 0.
    
                  /* ** Alterou Centro de Custo e Unidade de Neg¢cio ***/
                  IF  v_cod_ccusto_novo       <> v_cod_ccusto_antigo
                  AND aloc_bem.cod_unid_negoc <> v_cod_unid_novo
                      THEN ASSIGN aloc_bem.val_perc_aprop   = 0.
    
              END.

    
              FOR EACH bem_pat NO-LOCK:
                  ASSIGN v_val_percentual = 0.
                  FOR EACH aloc_bem OF bem_pat NO-LOCK:
                      ASSIGN v_val_percentual = v_val_percentual + aloc_bem.val_perc_aprop.
                  END.
                  IF  v_val_percentual <> 0 
                  AND v_val_percentual <> 100 
                  THEN DO:
                       ASSIGN v_log_method = SESSION:SET-WAIT-STATE("").
                       MESSAGE "Ocorreu divergància na distribuiá∆o dos percentuais entre as alocaá‰es, alteraá∆o N«O efetivada!" SKIP
                               v_val_percentual (100 - v_val_percentual) bem_pat.cod_empresa bem_pat.cod_cta_pat bem_pat.num_bem_pat bem_pat.num_seq
                           VIEW-AS ALERT-BOX INFO BUTTONS OK.
                       UNDO main_block, LEAVE main_block.
                  END.
              END.
            
              ASSIGN v_log_method = SESSION:SET-WAIT-STATE("").

              MESSAGE "Processamento Conclu°do !"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.

          END.

     END.
     ELSE MESSAGE "Alteraá∆o Cancelada !" VIEW-AS ALERT-BOX.

END.

ON WINDOW-CLOSE OF FRAME f_frame_1
DO:

    APPLY "end-error" TO SELF.
END.


/***************************** Frame Trigger End ****************************/

/****************************** Main Code Begin *****************************/

/* tratamento do titulo e vers∆o */
ASSIGN FRAME f_frame_1:TITLE = FRAME f_frame_1:TITLE 
                            + CHR(32)
                            + CHR(40)
                            + TRIM(" 5.00.00.001":U)
                            + CHR(41).

PAUSE 0 BEFORE-HIDE.
VIEW FRAME f_frame_1.

ENABLE bt_ok
       bt_can
       v_cod_estab               
       v_cod_ccusto_antigo    
       v_cod_ccusto_novo      
       v_cod_unid_novo        
       WITH FRAME f_frame_1.

DISPLAY v_cod_estab        
        v_cod_ccusto_antigo
        v_cod_ccusto_novo  
        v_cod_unid_novo    
        WITH FRAME f_frame_1.       

WAIT-FOR GO OF FRAME f_frame_1.

HIDE FRAME f_frame_1.

/******************************* Main Code End ******************************/
