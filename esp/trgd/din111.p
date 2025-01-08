/********************************************************************************
 ** UPC........: din111.p - UPC DELETE estrutura
 ** Data.......: Novembro / 2004
 ** Objetivo...: Repassa inclus‰es e modificaá‰es de estruturas para a Base Oracle
 ********************************************************************************/

DEF PARAM BUFFER b-estrutura      FOR estrutura.

{esp/crm/escrm001.i}
{esp/crm/escrm001a.i1}


/*****  Integracao com CRM *******/
/* Em coment†rio pois n∆o precisa Integrar com o CRM. O CRM n∆o precisa desta informaá∆o - 12-01-2011
create tt-estrutura-atu.
buffer-copy b-estrutura to tt-estrutura-atu.
create tt-raw-transfer.

raw-transfer tt-estrutura-atu to tt-raw-transfer.record.

RUN esp/crm/escrm001a.p (input "Estrutura",
                         input "D",
                         input rowid(b-estrutura),
                         input table tt-raw-transfer).
*/

        
RUN pi-elimina-int-estrutura.


/* if not b-estrutura.it-codigo begins "7" and
   not b-estrutura.it-codigo begins "8" then
   run esp/es0669.p (input "no",
                     "estrutura",
                     b-estrutura.it-codigo,
                     string(b-estrutura.sequencia,"99999"),
                     b-estrutura.es-codigo,
                     "", "", "", "", "", "").
   */


/*************************** P R O C E D U R E S *************************/

/*Inicio Integraá∆o*/
/* DEFINE TEMP-TABLE tt-estrutura-integra NO-UNDO                     */
/*     FIELD CodigoProduto LIKE estrutura.it-codigo.                  */
/* DEF VAR raw-param   AS RAW  NO-UNDO.                               */
/*                                                                    */
/* CREATE tt-estrutura-integra.                                       */
/* ASSIGN tt-estrutura-integra.CodigoProduto = b-estrutura.it-codigo. */
/*                                                                    */
/* RAW-TRANSFER tt-estrutura-integra TO raw-param.                    */
/*                                                                    */
/* RUN esp/trgw/wes727a.p (INPUT raw-param,                           */
/*                         INPUT 'msg0301').                          */

PROCEDURE pi-elimina-int-estrutura.
    find first int-estrutura
         where int-estrutura.it-codigo = b-estrutura.it-codigo
           and int-estrutura.es-codigo = b-estrutura.es-codigo
           and int-estrutura.sequencia = b-estrutura.sequencia no-error.
    if avail int-estrutura then do:
       DELETE int-estrutura.
    end.
END.
