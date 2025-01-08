/******************************************************************************
*      Programa .....: CPAPI301-UPC.P                                         *
*      Data .........: 31 de Outubro de 2022                                  *
*      Sistema ......: CP - Produ‡Æo                                          *
*      Empresa ......: iDBA                                                   *
*      Cliente ......: Intelbras                                              *
*      Programador ..: Mauricio                                               *
*      Objetivo .....: UPC para a CPAPI301                                    *
*******************************************************************************
*      VERSAO      DATA        RESPONSAVEL   MOTIVO                           *
*      1.00.00.000 31/10/2022  Mauricio      Desenvolvimento                  *
******************************************************************************/
{include/i-prgvrs.i "cpapi301-upc" 1.00.00.000}

/* ------------------- Parametros da DBO -------------------------*/
{include/i-epc200.i} /* Defini‡Æo tt-epc */

/* Parƒmetros */
define input        param p-ind-event as char no-undo.
define input-output param table for tt-epc.

def buffer b-oper-ord  for oper-ord.
def buffer b-ferr-prod for ferr-prod.

/* output to "c:\iDBA\cpapi301.txt" append.           */
/*                                                    */
/* put p-ind-event format "x(30)" skip.               */
/*                                                    */
/* for each tt-epc:                                   */
/*      put tt-epc.cod-event format "x(25)"           */
/*          tt-epc.cod-parameter format "x(30)"       */
/*          tt-epc.val-parameter format "x(60)" skip. */
/* end.                                               */
/*                                                    */
/* output close.                                      */

if p-ind-event <> "Fim-CriacaoOP"
then return.

for first tt-epc
    where tt-epc.cod-event     = "Cria-Ord-Prod"
      and tt-epc.cod-parameter = "rowid-ord-prod": end.

if not avail tt-epc
then return.

for first ord-prod 
    where rowid(ord-prod) = to-rowid(tt-epc.val-parameter)
          no-lock: end.

if not avail ord-prod
then return.

for each oper-ord fields(nr-ord-produ cod-recurso num-id-operacao      
                         ferramenta   estado      tipo-oper) no-lock
   where oper-ord.nr-ord-produ = ord-prod.nr-ord-produ
     and oper-ord.estado       = 1 /* NÆo Iniciada */
     and oper-ord.tipo-oper    = 1 /* Interna */
     and oper-ord.ferramenta  <> ""
     and oper-ord.cod-recurso  = "",
   first operacao fields(num-id-operacao data-inicio data-termino) no-lock
   where operacao.num-id-operacao = oper-ord.num-id-operacao
     and operacao.data-inicio    <= today
     and operacao.data-termino   >= today,
   first ferr-prod fields(cod-ferr-prod char-1) no-lock
   where ferr-prod.cod-ferr-prod = oper-ord.ferramenta
     and ferr-prod.char-1    <> "Ferramenta":
    for each op-ferram fields(num-id-operacao op-altern ferramenta) no-lock
       where op-ferram.num-id-operacao = operacao.num-id-operacao
         and op-ferram.op-altern       = 0
         and op-ferram.ferramenta     <> oper-ord.ferramenta,
       first b-ferr-prod fields(cod-ferr-prod char-1) no-lock
       where b-ferr-prod.cod-ferr-prod = op-ferram.ferramenta
         and b-ferr-prod.char-1        = "Ferramenta":
        for first b-oper-ord
            where rowid(b-oper-ord) = rowid(oper-ord)
                  exclusive-lock: end.

        assign b-oper-ord.ferramenta = op-ferram.ferramenta.
        find current b-oper-ord no-lock no-error.
        leave.
    end. /* for each op-ferram */
end. /* for each oper-ord */

