/***********************************************************************
**  Programa..: UPC\BODI159CPY-EPC.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: EPC - BODI159-EPC ONDE:
**              001 - Limpar descontos na implantaá∆o do registro.  
**  Vers∆o....: 001 10/11/2004 - Marcio Chaves
**                  Desenvolvimento Programa
************************************************************************/
{include/i-epc200.i1}
{method/dbotterr.i}
def input param pIndEvent          as char no-undo.
def input-output param table for tt-epc.

DEFINE VARIABLE l-consumidor-final AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-return           AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-nat-oper         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-boes505          AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bodi159cpy       AS HANDLE      NO-UNDO.
                                   
DEFINE BUFFER b-upc-ped-venda FOR ped-venda.
DEFINE BUFFER b-upc-ped-item  FOR ped-item.

IF pIndEvent = "CopyOrder" THEN DO:
    
    FIND FIRST tt-epc
         WHERE tt-epc.cod-event     = pIndEvent
           AND tt-epc.cod-parameter = "PedidoGerado-rowid" NO-LOCK NO-ERROR.
    
    IF AVAIL tt-epc THEN DO:
        FIND FIRST b-upc-ped-venda WHERE 
             ROWID(b-upc-ped-venda) = TO-ROWID(tt-epc.val-parameter) EXCLUSIVE-LOCK NO-ERROR.

         IF  AVAIL b-upc-ped-venda THEN DO:

             FIND FIRST emitente WHERE
                     emitente.cod-emitente = b-upc-ped-venda.cod-emitente NO-LOCK NO-ERROR.
   
             IF  b-upc-ped-venda.cod-des-merc = 1 THEN
                 ASSIGN l-consumidor-final = NO.
             ELSE
                 ASSIGN l-consumidor-final = YES.
       
             RUN esbo/boes505.p PERSISTENT SET h-boes505.
             RUN defineNatOperacao IN h-boes505 (INPUT b-upc-ped-venda.cod-estabel,
                                                 INPUT emitente.cod-emitente,
                                                 INPUT b-upc-ped-venda.cod-entrega,
                                                 INPUT "",
                                                 INPUT l-consumidor-final,
                                                 OUTPUT c-nat-oper,
                                                 OUTPUT l-return).
            
             IF l-return = yes and
                 c-nat-oper <> "" THEN 
                 ASSIGN b-upc-ped-venda.nat-operacao = c-nat-oper.
             ELSE DO:
                  run utp/ut-msgs.p ('show', 17006, 'Natureza de operaá∆o n∆o encontrada para este Estabelecimento x Cliente x Comercio/Industria, Verifique com GRUPO.TRIBUTARIO - escdp015').

             END.


             /* altera data implantacao e emissao na copia de pedidos para data do dia 
                e a data de reativacao e o usuario de reativacao deixar em branco */
             ASSIGN b-upc-ped-venda.dt-implant     = TODAY
                    b-upc-ped-venda.dt-emissao     = TODAY
                    b-upc-ped-venda.user-reat      = ""
                    b-upc-ped-venda.dt-reativ      = ?
                    b-upc-ped-venda.dt-entrega     = TODAY
                    b-upc-ped-venda.dt-entorig     = TODAY.

             /* Identificador: 2010/00017496 */

             FIND FIRST estabelec WHERE
                        estabelec.cod-estabel = b-upc-ped-venda.cod-estabel NO-LOCK NO-ERROR.
             FIND FIRST natur-oper WHERE
                        natur-oper.nat-operacao = b-upc-ped-venda.nat-operacao NO-LOCK NO-ERROR.

             /* Busca Indicador Icms ret */
             FIND FIRST unid-feder WHERE
                        unid-feder.pais   = emitente.pais   AND
                        unid-feder.estado = emitente.estado NO-LOCK NO-ERROR.

             FOR EACH b-upc-ped-item OF b-upc-ped-venda EXCLUSIVE-LOCK:

                 ASSIGN b-upc-ped-item.ind-icm-ret = NO.

                 IF emitente.contrib-icms AND
                     AVAIL unid-feder AND unid-feder.ind-uf-subs THEN DO:
                     FIND FIRST item-uf WHERE
                                item-uf.it-codigo       = b-upc-ped-item.it-codigo AND
                                item-uf.cod-estado-orig = estabelec.estado         AND
                                item-uf.estado          = emitente.estado          NO-LOCK NO-ERROR.

                     FIND FIRST dist-emitente OF emitente NO-LOCK NO-ERROR.

                     IF natur-oper.subs-trib AND
                         AVAIL item-uf AND AVAIL dist-emitente AND dist-emitente.nr-tb-pauta = ""
                         AND emitente.insc-subs-trib = "" THEN DO:

                         ASSIGN b-upc-ped-item.ind-icm-ret = YES.
                     END.
                 END.

                 
                 RUN defineNatOperacao IN h-boes505 (INPUT b-upc-ped-venda.cod-estabel,
                                                     INPUT emitente.cod-emitente,
                                                     INPUT b-upc-ped-venda.cod-entrega,
                                                     INPUT b-upc-ped-item.it-codigo,
                                                     INPUT l-consumidor-final,
                                                     OUTPUT c-nat-oper,
                                                     OUTPUT l-return).
                 
                 IF l-return = yes and
                     c-nat-oper <> "" THEN 
                     ASSIGN b-upc-ped-item.nat-operacao = c-nat-oper.
                 ELSE DO:

                     run utp/ut-msgs.p ('show', 17006, 'Natureza de operaá∆o n∆o encontrada para este Estabelecimento x Cliente x Comercio/Industria, Verifique com GRUPO.TRIBUTARIO - escdp015').
                 END.
             END.
             DELETE PROCEDURE h-boes505.
         END.
     END.
END.
