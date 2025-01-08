/*:T*******************************************************************************
**
**  Programa.: ESPDP075
**  Objetivo.: Relat¢rio de aprova‡äes especiais realizadas no financeiro.
**  Cria‡Æo..: 21/02/2013
**  VersÆo...: 
**
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESpaulo3 2.00.00.000}

/* include padrÆo para vari veis de relat¢rio  */
{include/i-rpvar.i}
{esp/pdp/espdp075.i}

/* recebimento de parƒmetros */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

DEFINE VARIABLE h-acomp     AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-unid-neg  AS CHARACTER   NO-UNDO.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.

FIND FIRST param-global NO-LOCK NO-ERROR.

FIND FIRST empresa
    WHERE empresa.ep-codigo = param-global.empresa-pri NO-LOCK.

/* bloco principal do programa */

ASSIGN  c-empresa      = IF AVAILABLE mgcad.empresa THEN mgcad.empresa.razao-social ELSE "":U
	    c-sistema	   = "Espec¡fico Intelbras"
	    c-titulo-relat = "Relat¢rio".

/* include padrÆo para output de relat¢rios */
{include/i-rpout.i}

/* include com a defini‡Æo da frame de cabe‡alho e rodap‚ */
{include/i-rpcab.i}

/* L¢gica de neg¢cio - In¡cio*/

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "Criando Relat¢rio..":U).

PUT "C¢digo" ";" "Nome" ";" "Nr. Pedido" ";" "Unidade de Negocio" ";" "Valor do Pedido" ";" "Condi‡Æo de Pagamento" ";" "Data de implanta‡Æo do Pedido" ";" "Data de Entrega do Pedido" ";" "Data da aprova‡Æo" ";" "Usu rio" ";" "Observa‡Æo na aprova‡Æo".

FOR EACH ped-venda NO-LOCK 
        WHERE ped-venda.quem-aprovou    >= tt-param.ini-campo   AND
                ped-venda.quem-aprovou  <= tt-param.fim-campo   AND
                ped-venda.dt-implant    >= tt-param.impl-ini    AND
                ped-venda.dt-implant    <= tt-param.impl-fin    AND
                ped-venda.dt-apr-cred   >= tt-param.aprov-ini   AND
                ped-venda.dt-apr-cred   <= tt-param.aprov-fin:

    ASSIGN c-unid-neg = "".

    FOR EACH ped-item NO-LOCK
        WHERE ped-item.nome-abrev = ped-venda.nome-abrev
          AND ped-item.nr-pedcli  = ped-venda.nr-pedcli:


         FIND item-uni-estab NO-LOCK
            WHERE item-uni-estab.cod-estabel = ped-venda.cod-estabel
               AND item-uni-estab.it-codigo   = ped-item.it-codigo  NO-ERROR.
         IF AVAIL item-uni-estab THEN
               IF INDEX(c-unid-neg,item-uni-estab.cod-unid-negoc) = 0 THEN
                   IF c-unid-neg = "" THEN

                    ASSIGN c-unid-neg = item-uni-estab.cod-unid-negoc.

                   ELSE
                       ASSIGN c-unid-neg = c-unid-neg + "," + item-uni-estab.cod-unid-negoc.
            

         FIND FIRST emitente NO-LOCK
            WHERE  emitente.nome-abrev = ped-venda.nome-abrev NO-ERROR.

         FIND FIRST cond-pagto NO-LOCK
             WHERE ped-venda.cod-cond-pag = cond-pagto.cod-cond-pag NO-ERROR.

         RUN pi-acompanhar in h-acomp (input "Lendo Produto... "  + emitente.nome-abrev).

         PUT SKIP
              ped-venda.cod-emitente ";"
              emitente.nome-emit ";"
              ped-venda.nr-pedcli ";"
              c-unid-neg ";"
              ped-venda.vl-tot-ped ";"
              ped-venda.cod-cond-pag " " IF AVAIL cond-pagto THEN cond-pagto.descricao ELSE "" FORMAT "x(30)" ";" 
              ped-venda.dt-implant ";"
              ped-venda.dt-entrega ";"
              ped-venda.dt-apr-cred ";"
              ped-venda.quem-aprovou ";"
              ped-venda.desc-forc-cr.

    END.
END.

IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

/*fechamento do output do relat¢rio*/
{include/i-rpclo.i}

RETURN "OK".
