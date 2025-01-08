/********************************************************************************
 ** UPC........: ddi163.p - UPC DELETE preco-item
 ** Data.......: Novembro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes de precos dos itens comerciais para a Base Oracle
 ********************************************************************************/

DEF PARAM BUFFER b-preco-item      FOR preco-item.
{esp/es0018.i}    
{esp/esb/out/msg0195.i}
{esp/esb/esesb000.i}
{esp/wso/out/wso0001.i}

DEF VAR raw-param AS RAW NO-UNDO.

/* 0 - Situa‡Æo da Tabela de pre‡o (manuten‡Æo , 0 - situa‡Æo do item da tabela (manute‡Æo)*/
{esp/trgw/wdi163.i "0" "1"}

/*
{esp/crm/escrm001.i}
{esp/crm/escrm001a.i1}

create tt-preco-item-atu.
buffer-copy b-preco-item to tt-preco-item-atu.
create tt-raw-transfer.

raw-transfer tt-preco-item-atu to tt-raw-transfer.record.

run esp/crm/escrm001a.p (input "Preco-item",
                         input "D",
                         input rowid(b-preco-item),
                         input table tt-raw-transfer).

*/

if b-preco-item.nr-tabpre <> "00101" and
   b-preco-item.nr-tabpre <> "lai02" and
   not b-preco-item.nr-tabpre begins "MSG" and
   not b-preco-item.nr-tabpre begins "EXP" and
   not b-preco-item.nr-tabpre begins "BRT" then next.

/*
run esp/es0669.p (input "no",
                  "preco-item",
                  b-preco-item.it-codigo,
                  b-preco-item.nr-tabpre,
                  "", "", "", "", "", "", "").
*/

FIND FIRST int-preco-item OF b-preco-item NO-ERROR.
IF AVAIL int-preco-item THEN DO:
    DELETE int-preco-item.
END.


EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p (INPUT "Vtex-preco":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

/*integra wso2*/
IF  CAN-FIND (FIRST tt-prog-ponto
                   WHERE entry(1, tt-prog-ponto.conteudo, ";") = b-preco-item.nr-tabpre) THEN DO:

    CREATE ttPreco.
    ASSIGN ttPreco.CodigoProduto = b-preco-item.it-codigo.

    FIND FIRST tb-preco NO-LOCK
         WHERE tb-preco.nr-tabpre =  b-preco-item.nr-tabpre NO-ERROR.

    CREATE ItemTabelaPreco.
    ASSIGN ItemTabelaPreco.Quantidade           = b-preco-item.quant-min
           ItemTabelaPreco.ValorUnitario        = 0
           ItemTabelaPreco.ValorTotalSemImposto = 0
           ItemTabelaPreco.PercentualDesconto   = b-preco-item.desco-quant.    

    RUN esp/wso/out/wso0001.p (INPUT "v1/produto/preco",
                               INPUT TABLE ttPreco,
                               INPUT TABLE ItemTabelaPreco).

END.
