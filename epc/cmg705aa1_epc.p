/*****************************************************************************
** Programa..............: cmg705aa1_epc.p
** Autor.................: Fabiano Zarpe Henke
** Criado em.............: 17/11/2008
*****************************************************************************/

/**************************************************** Initialize **********************************************************/
DEF TEMP-TABLE tt_erros_conexao NO-UNDO 
    FIELD ttv_cdn_erro                     AS INTEGER FORMAT ">>>,>>9"
    FIELD ttv_des_erro                     AS CHARACTER FORMAT "x(50)" LABEL "Inconsistància" COLUMN-LABEL "Inconsistància".

DEF TEMP-TABLE tt-ped-venda NO-UNDO 
    FIELD nr-ped-ikeda                     AS INTEGER.

DEF VAR v_hdl_btb_connect AS HANDLE NO-UNDO.
DEF VAR v_log_sucesso     AS LOG    NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar
    AS CHARACTER 
    FORMAT "x(3)":U
    LABEL "Empresa"
    COLUMN-LABEL "Empresa"
    NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_rec_extrat_cta_corren
    AS RECID 
    FORMAT ">>>>>>9"
    INITIAL ?
    NO-UNDO.

DEF VAR v_log_answer AS LOG NO-UNDO INITIAL NO.

FIND extrat_cta_corren NO-LOCK
    WHERE RECID(extrat_cta_corren) = v_rec_extrat_cta_corren NO-ERROR.
IF NOT AVAIL extrat_cta_corren 
THEN DO:
     MESSAGE "Extrato n∆o Localizado !"
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
     RETURN "OK".
END.

IF extrat_cta_corren.cod_cta_corren <> "67464-8"
THEN DO:
     MESSAGE "Opá∆o v†lida somente para a conta corrente B2C - 67464-8"
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
     RETURN "OK".
END.

MESSAGE "Confirma a Aprovaá∆o dos Pedidos listados no Extrato " num_extrat_cta_corren " da Conta Corrente " cod_cta_corren " ?"
       VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE v_log_answer.

IF v_log_answer = YES 
THEN DO:
    delete_block:
    DO ON ERROR UNDO delete_block, LEAVE delete_block TRANSACTION:

        FOR EACH lin_extrat_cta_corren NO-LOCK OF extrat_cta_corren:

            MESSAGE lin_extrat_cta_corren.des_histor_movto_cta_corren VIEW-AS ALERT-BOX.

            IF "INT posicao xxxx lin_extrat_cta_corren.des_histor_movto_cta_corren" <> "de algo "
               THEN NEXT.

            CREATE tt-ped-venda.
            ASSIGN tt-ped-venda.nr-ped-ikeda  = /*INT posicao xxxx lin_extrat_cta_corren.des_histor_movto_cta_corren.*/ 0.
  
        END.
        
        IF CAN-FIND(FIRST tt-ped-venda) 
        THEN DO:
             
             RUN epc/cmg705aa2_epc.p (INPUT TABLE tt-ped-venda).

        END.

    END.
    MESSAGE "Pedidos Aprovados !" VIEW-AS ALERT-BOX.
    RETURN "OK".
END.
ELSE RETURN "OK".
