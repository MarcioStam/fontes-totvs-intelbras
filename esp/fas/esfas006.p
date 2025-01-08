/*****************************************************************************
** Nome Externo..........: esp/fas/esfas006.p
** Data Criaá∆o..........: 02/09/2009
** Criado por............: Fabiano Zarpe Henke
*****************************************************************************/

/************************* Variable Definition Begin ************************/

DEFINE VARIABLE v_dat_corte  AS DATE    FORMAT "99/99/9999"    NO-UNDO.
DEFINE VARIABLE v_log_method AS LOGICAL     NO-UNDO.

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
         at row 04.08 col 02.00 bgcolor 7 
    v_dat_corte
         at row 02.08 col 13.43 colon-aligned label "Data Corte"
         view-as fill-in
         size-chars 11.14 by .88
         fgcolor ? bgcolor 15 font 2
    bt_ok
         at row 04.33 col 03.00 font ?
         help "OK"
    bt_can
         at row 04.33 col 14.00 font ?
         help "Cancela"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 37.00 by 5.96
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Vincular Doctos Entrada - esfas006".
    assign bt_can:width-chars          in frame f_frame_1 = 10.00
           bt_can:height-chars         in frame f_frame_1 = 01.00
           bt_ok:width-chars           in frame f_frame_1 = 10.00
           bt_ok:height-chars          in frame f_frame_1 = 01.00
           rt_cxcf:width-chars         in frame f_frame_1 = 33.00
           rt_cxcf:height-chars        in frame f_frame_1 = 01.42
           rt_005:width-chars          in frame f_frame_1 = 33.00
           rt_005:height-chars         in frame f_frame_1 = 02.3.

/*************************** Frame Definition End ***************************/

/************************ User Interface Trigger End ************************/

ON CHOOSE OF bt_ok IN FRAME f_frame_1 /* Confirma */
DO:

     ASSIGN v_dat_corte.

     MESSAGE "Confirma Vinculo de TODOS os Doctos de Entrada emitidos atÇ " STRING(v_dat_corte, '99/99/9999') " ?" 
           VIEW-AS ALERT-BOX  QUESTION BUTTONS YES-NO TITLE "Alteraá∆o Docto Entrada" UPDATE choice AS LOGICAL.
  
     IF CHOICE = NO 
     THEN DO: 
          RETURN NO-APPLY.
     END.

     ASSIGN v_log_method = SESSION:SET-WAIT-STATE('general').

     FOR EACH item_docto_entr EXCLUSIVE-LOCK 
         WHERE item_docto_entr.log_classif_item_docto_entr = NO:
         FIND docto_entr NO-LOCK
            WHERE docto_entr.cod_estab      = item_docto_entr.cod_estab     
              AND docto_entr.cod_empresa    = item_docto_entr.cod_empresa   
              AND docto_entr.cdn_fornecedor = item_docto_entr.cdn_fornecedor
              AND docto_entr.cod_docto_entr = item_docto_entr.cod_docto_entr
              AND docto_entr.cod_ser_nota   = item_docto_entr.cod_ser_nota NO-ERROR.
         IF NOT AVAIL docto_entr
         OR docto_entr.dat_docto > v_dat_corte 
            THEN NEXT.
         ASSIGN item_docto_entr.log_classif_item_docto_entr = YES.
     END.

     ASSIGN v_log_method = SESSION:SET-WAIT-STATE("").

     MESSAGE "Processamento Conclu°do !"
       VIEW-AS ALERT-BOX INFO BUTTONS OK.

END.

ON WINDOW-CLOSE OF FRAME f_frame_1
DO:

    APPLY "end-error" TO SELF.
END. /* ON WINDOW-CLOSE OF FRAME f_frame_1 */


/***************************** Frame Trigger End ****************************/

/****************************** Main Code Begin *****************************/

/* tratamento do titulo e vers∆o */
ASSIGN FRAME f_frame_1:TITLE = FRAME f_frame_1:TITLE 
                            + CHR(32)
                            + CHR(40)
                            + TRIM(" 5.00.00.001":U)
                            + CHR(41).

ASSIGN v_dat_corte = TODAY.

PAUSE 0 BEFORE-HIDE.
VIEW FRAME f_frame_1.

ENABLE bt_ok
       bt_can
       v_dat_corte
       WITH FRAME f_frame_1.

DISPLAY v_dat_corte
        WITH FRAME f_frame_1.       

WAIT-FOR GO OF FRAME f_frame_1.

HIDE FRAME f_frame_1.

/******************************* Main Code End ******************************/
