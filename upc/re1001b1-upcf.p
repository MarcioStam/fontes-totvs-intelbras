/***********************************************************************
**  Programa..: upc\re1001b1-upcb.p
**  Autor.....: Anderson Silvano  - Gestech
**  Data......: JUNHO/2005 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 00/00/2002
**                  Desenvolvimento Programa
************************************************************************/

DEFINE NEW GLOBAL SHARED VARIABLE wh-conta  AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-ccusto AS WIDGET-HANDLE NO-UNDO.

DEF INPUT PARAM p-ind-zoom AS INT NO-UNDO.

{upc/btb910za-upc.i} /* Definiá∆o da vari†vel New Global Shared "v_cod_estab_usuar_intelbras" */
{utp/ut-glob.i}

IF  p-ind-zoom = 1 /* Conta */
THEN DO:
    if not valid-handle(h_api_cta_ctbl) 
    then 
        run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
    
    assign v_ind_finalid_cta = "(nenhum)".
    EMPTY TEMP-TABLE tt_log_erro.
    run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (INPUT i-ep-codigo-usuario,
                                                   INPUT "CEP",
                                                   INPUT "",
                                                   INPUT v_ind_finalid_cta,
                                                   INPUT TODAY,
                                                   OUTPUT v_cod_conta,
                                                   OUTPUT v_des_titulo_conta,
                                                   OUTPUT v_ind_finalid_cta,
                                                   OUTPUT TABLE tt_log_erro).
    if valid-handle(h_api_cta_ctbl) 
    then
        delete object h_api_cta_ctbl.  
    
    IF NOT CAN-FIND(FIRST tt_log_erro) AND 
       v_cod_conta <> ""
    THEN
        ASSIGN wh-conta:SCREEN-VALUE = v_cod_conta.
END.
ELSE DO:

    if not valid-handle(h_api_ccusto) 
    then 
        run prgint/utb/utb742za.py persistent set h_api_ccusto.

    assign v_ind_finalid_cta = "(nenhum)".

    EMPTY TEMP-TABLE tt_log_erro.
    run pi_zoom_ccusto in h_api_ccusto (INPUT "",
                                        INPUT "",
                                        INPUT "",
                                        INPUT today,
                                        OUTPUT v_cod_ccusto,
                                        OUTPUT v_des_titulo_ccusto,
                                        OUTPUT TABLE tt_log_erro).

    if valid-handle(h_api_ccusto) 
    then
        delete object h_api_ccusto.     
        
    IF NOT CAN-FIND(FIRST tt_log_erro) AND 
        v_cod_ccusto <> ""
    THEN
        ASSIGN wh-ccusto:SCREEN-VALUE = v_cod_ccusto.
END.

