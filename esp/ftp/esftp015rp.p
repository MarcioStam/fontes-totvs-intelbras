{include/i-prgvrs.i ESFTP015 2.04.00.001}
/*****************************************************************************
**     Programa.........: esp/acr/esftp015rp.p
**     Descricao .......: Comparativo de Custo X Total da Nota
**     Versao...........: 1.00.000
**     Autor............: Marcio Chaves - Gestech
**     Criado...........: 29/01/2004
**     Desc. Atualiza‡Æo: 
**     Autor............: 
*******************************************************************************/

/****************************  Definitions  ****************************/
{esp/ftp/esftp015tt.i}
{include/i-rpvar.i}


/****************************  Temp-Tables  ****************************/
def temp-table tt-nf
    field nr-nota-fis    like nota-fiscal.nr-nota-fis
    field cod-emitente   like emitente.cod-emitente
    field nome-ab-cli    like nota-fiscal.nome-ab-cli
    field dt-emis-nota   like nota-fiscal.dt-emis-nota
    field nat-operacao   like nota-fiscal.nat-operacao
    field vl-icms-it     like it-nota-fisc.vl-icms-it
    field vl-ipi-it      like it-nota-fisc.vl-ipi-it
    field vl-merc-liq    like it-nota-fisc.vl-merc-liq
    field vl-tot-item    like it-nota-fisc.vl-tot-item
    field valor-mat-mob  like movto-estoq.valor-mat-m[1]
    field ct-codigo      like movto-estoq.ct-codigo
    field sc-codigo      like movto-estoq.sc-codigo
    field nr-pedcli      like it-nota-fisc.nr-pedcli COLUMN-LABEL "Pedidos"
    index tt-nf is primary unique nr-nota-fis
    index tt-ct ct-codigo sc-codigo.

def temp-table tt-ct
    field ct-codigo      like movto-estoq.ct-codigo
    field sc-codigo      like movto-estoq.sc-codigo
    field valor-nota     like it-nota-fisc.vl-merc-liq
    field valor-custo    like it-nota-fisc.vl-merc-liq
    index tt-ct is primary unique ct-codigo sc-codigo.

/****************************  Variaveis    ****************************/
def var dt-data          as date.
def buffer b-movto-estoq for movto-estoq.

/****************************  Frames       ****************************/


def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

/*
 * for each tt-raw-digita:
 *     create tt-digita.
 *     raw-transfer tt-raw-digita.raw-digita to tt-digita.
 * end. 
 */

def var h-acomp      as handle no-undo.
find first mgcad.empresa NO-LOCK
     where empresa.ep-codigo = tt-param.ep-codigo no-error.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Comparativo de Custo X Total da Nota"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESFTP015"
       c-versao       = "2.04"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    {include/i-rpcab.i}
    {include/i-rpout.i}
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

   run utp/ut-acomp.p persistent set h-acomp.  
   run pi-inicializar in h-acomp (input "Montando Relat¢rio...").
   run pi-relat.
   run pi-inicializar in h-acomp (input "Imprimindo...").
   run pi-imprime.

   run pi-finalizar in h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".
end.
/* fim do programa */

PROCEDURE pi-relat:
        for each tt-nf:
            delete tt-nf.
        end.
        
        do dt-data = tt-param.da-emis-ini to tt-param.da-emis-fim:
           for each nota-fiscal no-lock 
               where nota-fiscal.dt-emis-nota = dt-data
                 and nota-fiscal.nat-operacao >= tt-param.nat-oper-ini
                 and nota-fiscal.nat-operacao <= tt-param.nat-oper-fim
                 and nota-fiscal.cod-estabel  >= tt-param.cod-estabel-ini
                 and nota-fiscal.cod-estabel  <= tt-param.cod-estabel-fim
                 AND nota-fiscal.cod-emitente >= tt-param.cod-emit-ini
                 AND nota-fiscal.cod-emitente <= tt-param.cod-emit-fim,
               first emitente no-lock where
                     emitente.nome-abrev = nota-fiscal.nome-ab-cli,
               each it-nota-fisc of nota-fiscal,
               first movto-estoq no-lock 
                     where movto-estoq.nro-docto = nota-fiscal.nr-nota-fis 
                       and movto-estoq.serie = nota-fiscal.serie 
                       and movto-estoq.esp-docto = 22 /*"nfs" */
                       and movto-estoq.dt-trans = nota-fiscal.dt-emis-nota 
                       and movto-estoq.it-codigo = it-nota-fisc.it-codigo 
                       and movto-estoq.sequen-nf = it-nota-fisc.nr-seq-fat
                       and movto-estoq.ct-codigo >= tt-param.ct-cod-ini 
                       and movto-estoq.ct-codigo <= tt-param.ct-cod-fim
                       and movto-estoq.sc-codigo >= tt-param.sc-cod-ini
                       and movto-estoq.sc-codigo <= tt-param.sc-cod-fim:
               
               RUN pi-acompanhar IN h-acomp (INPUT "Data Nota: " + string(nota-fiscal.dt-emis-nota)).
               
               find first b-movto-estoq no-lock 
                    where b-movto-estoq.nro-docto = nota-fiscal.nr-nota-fis 
                      and b-movto-estoq.esp-docto = 5 /*"dev"*/
                      and b-movto-estoq.serie = "RNF"
                      and b-movto-estoq.dt-trans = nota-fiscal.dt-emis-nota 
                      and b-movto-estoq.it-codigo = it-nota-fisc.it-codigo 
                    no-error.
               if avail b-movto-estoq and
                  b-movto-estoq.quantidade = movto-estoq.quantidade then
                  next.
                  
               find first tt-nf 
                    where tt-nf.nr-nota-fis = nota-fiscal.nr-nota-fis no-error.
               if not avail tt-nf then do:
                  create tt-nf.
                  assign tt-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
                         tt-nf.nome-ab-cli = nota-fiscal.nome-ab-cli
                         tt-nf.cod-emitente = emitente.cod-emitente
                         tt-nf.dt-emis-nota = nota-fiscal.dt-emis-nota
                         tt-nf.nat-operacao = nota-fiscal.nat-operacao
                         tt-nf.ct-codigo    = movto-estoq.ct-codigo
                         tt-nf.sc-codigo    = movto-estoq.sc-codigo.
               end.
               assign tt-nf.vl-icms-it    = tt-nf.vl-icms-it +
                                            it-nota-fisc.vl-icms-it.
                      tt-nf.vl-ipi-it     = tt-nf.vl-ipi-it  +
                                            it-nota-fisc.vl-ipi-it.
                      tt-nf.vl-merc-liq   = tt-nf.vl-merc-liq +
                                            it-nota-fisc.vl-merc-liq.
                      tt-nf.vl-tot-item   = tt-nf.vl-tot-item +
                                            it-nota-fisc.vl-tot-item.
                      tt-nf.valor-mat-mob = tt-nf.valor-mat-mob +
                                            movto-estoq.valor-mat-m[1] +
                                            movto-estoq.valor-mob-m[1] +
                                            it-nota-fisc.vl-icms-it +
                                            it-nota-fisc.vl-ipi-it.

               IF LOOKUP(it-nota-fisc.nr-pedcli,tt-nf.nr-pedcli,",") = 0 THEN DO:
                   IF tt-nf.nr-pedcli = "" THEN
                       ASSIGN tt-nf.nr-pedcli = it-nota-fisc.nr-pedcli.
                   ELSE 
                       ASSIGN tt-nf.nr-pedcli = tt-nf.nr-pedcli + "," + it-nota-fisc.nr-pedcli.
               END.
           end.
        end.

        
END PROCEDURE.

PROCEDURE pi-imprime:
    for each tt-ct:
        delete tt-ct.
    end.

    for each tt-nf:
        disp tt-nf.nr-nota-fis
             tt-nf.cod-emitente
             tt-nf.nome-ab-cli
             tt-nf.dt-emis-nota
             tt-nf.nat-operacao 
             tt-nf.vl-icms-it(total) 
             tt-nf.vl-ipi-it(total)  
/*                 tt-nf.vl-merc-liq(total) */
             tt-nf.vl-tot-item(total)
             tt-nf.valor-mat-mob(total)  
             tt-nf.ct-codigo      
             tt-nf.sc-codigo
             tt-nf.nr-pedcli with width 255 STREAM-IO.
        find first tt-ct 
             where tt-ct.ct-codigo = tt-nf.ct-codigo
               and tt-ct.sc-codigo = tt-nf.sc-codigo no-error.
        if not avail tt-ct then do:
           create tt-ct.
           assign tt-ct.ct-codigo = tt-nf.ct-codigo
                  tt-ct.sc-codigo = tt-nf.sc-codigo.
        end.
        assign tt-ct.valor-nota = tt-ct.valor-nota + tt-nf.vl-tot-item
               tt-ct.valor-custo = tt-ct.valor-custo + tt-nf.valor-mat-mob.
    end.

   put  " " skip(2)
        "RESUMO" skip(1)
        "Conta    Sub Conta       Valor Nota      Valor Custo    Diferenca"
        skip.
        
    for each tt-ct:
        put tt-ct.ct-codigo " "
            tt-ct.sc-codigo "     "
            tt-ct.valor-nota " "
            tt-ct.valor-custo " "
            tt-ct.valor-nota - tt-ct.valor-custo format "->>>>,>>9.99"
            skip.
    end.
END PROCEDURE.

