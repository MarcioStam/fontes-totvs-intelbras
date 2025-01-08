{include/i-prgvrs.i ESFTP027 2.04.00.000}
/***********************************************************************
**  Programa..: esftp027
**  Autor.....: Giovane Alves
**  Data......: Marco/2006 - Desenvolvimento
**  Descricao.: Relatorio de Debito/Credtio Comissao
**  VersÆo....: 001 30/03/2006
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/
{esp/ftp/esftp027tt.i}
{include/i-rpvar.i}
{upc/btb910za-upc.i} /* Defini‡Æo da vari vel New Global Shared "v_cod_estab_usuar_intelbras" */
{utp/ut-glob.i}

def temp-table tt-raw-digita
   field raw-digita      as raw.

/****************************  Temp-Tables  ****************************/
/****************************  Variaveis    ****************************/
/****************************  Frames       ****************************/
/*     WITH FRAME fDetalhe NO-ATTR-SPACE STREAM-IO WIDTH 132 DOWN.-*/

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

def var h-acomp      as handle no-undo.

DEFINE BUFFER b-repres FOR repres.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK
    WHERE mgcad.empresa.ep-codigo = param-global.empresa-pri: END.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Relat¢rio de D‚bito/Cr‚dito ComissÆo"
       c-empresa      = if avail mgcad.empresa then mgcad.empresa.razao-social else ''
       c-programa     = "ESFTP027"
       c-versao       = "2.04"
       c-revisao      = "000".

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    {include/i-rpcab.i}
    {include/i-rpout.i}
    
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.


   run utp/ut-acomp.p persistent set h-acomp.  

   run piImprimeRelat.

   {include/i-rpclo.i}
   RETURN "OK".
end.


/*****************************************************************************************
**
** PROCEDURES INTERNAS
**
*****************************************************************************************/
PROCEDURE piImprimeRelat:

    run pi-inicializar in h-acomp (input "Imprimindo").

    FIND FIRST tt-param NO-ERROR.

    run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.

    for each comis-deb-cre NO-LOCK 
       WHERE comis-deb-cre.dt-movto >= tt-param.dt-ini 
         AND comis-deb-cre.dt-movto <= tt-param.dt-fim 
         AND comis-deb-cre.cod-rep >= tt-param.cod-rep-ini 
         AND comis-deb-cre.cod-rep <= tt-param.cod-rep-fim 
         AND comis-deb-cre.cod-mov >= tt-param.cod-mov-ini 
         AND comis-deb-cre.cod-mov <= tt-param.cod-mov-fim,
       first mov-comis NO-LOCK 
       where mov-comis.cod-mov = comis-deb-cre.cod-mov,
       first repres NO-LOCK 
       where repres.cod-rep = comis-deb-cre.cod-rep:

        RUN pi-acompanhar IN h-acomp (INPUT STRING(comis-deb-cred.cod-rep)).

        ASSIGN v_cod_conta = string(comis-deb-cre.ct-codigo).
        
        EMPTY TEMP-TABLE tt_log_erro.
        run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-ep-codigo-usuario, /* EMPRESA EMS2 */
                                                       input        "",                  /* PLANO DE CONTAS */
                                                       input-output v_cod_conta,         /* CONTA */
                                                       input        TODAY,               /* DATA TRANSACAO */   
                                                       output       v_des_titulo_conta,   /* DESCRICAO CONTA */
                                                       output       v_num_tip_cta_ctbl,  /* TIPO DA CONTA */
                                                       output       v_num_sit_cta_ctbl,  /* SITUA›øO DA CONTA */
                                                       output       v_ind_finalid_cta,   /* FINALIDADES DA CONTA */
                                                       output table tt_log_erro).        /* ERROS */

        FIND FIRST emitente NO-LOCK
             WHERE emitente.cgc = repres.cgc NO-ERROR.

        disp comis-deb-cred.cod-rep
             repres.nome-abrev
             comis-deb-cred.cod-mov
             mov-comis.descricao format "X(20)"
             comis-deb-cred.dt-movto 
             comis-deb-cred.base-final format "Bas/Fin"
             comis-deb-cred.deb-cred format "Deb/Cre"
             comis-deb-cred.valor
             comis-deb-cred.ct-codigo 
             comis-deb-cred.sc-codigo FORMAT "9999999"
             v_des_titulo_conta format "X(15)"
             comis-deb-cred.historico  
             comis-deb-cred.cod-estabel COLUMN-LABEL "Estab"
             comis-deb-cred.unid-neg    COLUMN-LABEL "Unid. Neg"
             emitente.cod-emitente WHEN AVAIL emitente COLUMN-LABEL "Fornecedor" with width 300 STREAM-IO. 
     end.

     IF VALID-HANDLE(h_api_cta_ctbl) 
     THEN
         DELETE OBJECT h_api_cta_ctbl.

    run pi-finalizar in h-acomp.
END.

