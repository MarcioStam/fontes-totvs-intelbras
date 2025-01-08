/*****************************************************************************
** Programa..............: fas701cada_epc_1.p - add_bem_pat
** Autor.................: Andrey M Oliveira
** Criado em.............: 06/08/2019
*****************************************************************************/

DEF INPUT PARAM p_ind_event       AS CHAR           NO-UNDO.
DEF INPUT PARAM p_ind_object      AS CHAR           NO-UNDO.
DEF INPUT PARAM p_wgh_object      AS HANDLE         NO-UNDO.
DEF INPUT PARAM p_wgh_frame       AS WIDGET-HANDLE  NO-UNDO.
DEF INPUT PARAM p_cod_table       AS CHAR           NO-UNDO.
DEF INPUT PARAM p_rec_table       AS RECID          NO-UNDO.

DEF NEW GLOBAL SHARED VAR h_des_bem_pat     AS WIDGET-HANDLE NO-UNDO.

DEF VAR v_des_bem_pat     LIKE bem_pat.des_bem_pat NO-UNDO.
DEF VAR v_aux_des_bem_pat LIKE bem_pat.des_bem_pat NO-UNDO.
DEF VAR i_cont            AS INT                   NO-UNDO.


PROCEDURE pi_trata_leave_des_bem_pat:

    IF  VALID-HANDLE(h_des_bem_pat) THEN DO:
        
        ASSIGN v_des_bem_pat = h_des_bem_pat:SCREEN-VALUE.

        run pi_retira_caracteres_nao_alfa (Input v_des_bem_pat,
                                           Input "3", /* somente numeros, letras e espa‡os em branco */
                                           output v_aux_des_bem_pat).

        IF  v_des_bem_pat <> v_aux_des_bem_pat THEN DO:
            MESSAGE "Descri‡Æo do bem nÆo pode conter caracteres especiais !" VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN "NOK".
        END.
    END.

END PROCEDURE.

PROCEDURE pi_retira_caracteres_nao_alfa:
    def Input param p_cod_text
        as character
        format "x(8)"
        no-undo.
    def Input param p_ind_tipo
        as character
        format "X(10)"
        no-undo.
    def output param p_cod_string
        as character
        format "x(8)"
        no-undo.

    def var v_cod_aux   as character no-undo.
    def var v_cod_faixa as character no-undo.
    def var v_num_cont  as integer   no-undo.

    /***************************************************************
    *  p_ind_tipo = "1"  Somente n£meros
    *               "2"  Somente letras e espa‡os em branco
    *               "3"  Somente n£meros, letras e espa‡os em branco
    ***************************************************************/
    assign p_cod_string = "".

    /*** DEFINE A FAIXA DE CARACTERES VµLIDOS ***/
    if  p_ind_tipo = "1" then
        assign v_cod_faixa = '0123456789'.
    else if p_ind_tipo = "2" then
        assign v_cod_faixa = '()-abcdefghijklmnopqrstuvwxyz '.
    else
        assign v_cod_faixa = '()-abcdefghijklmnopqrstuvwxyz0123456789 '.

    /*** VERIFICA E RETORNA SOMENTE OS CARACTERES VµLIDOS  ***/
    do  v_num_cont = 1 to length( p_cod_text ):
        if  index( v_cod_faixa, substring(p_cod_text,v_num_cont,1) ) > 0 then
            assign p_cod_string = p_cod_string + substring(p_cod_text,v_num_cont,1).
    end.

END PROCEDURE.
