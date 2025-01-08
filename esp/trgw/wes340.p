/********************************************************************************
 ** UPC........: upcw-es326p - UPC WRITE comp-famc-item
 ** Data.......: novembro / 2004
 ** Objetivo...: Repassa inclusäes e modifica‡äes de complementos da familia  dos itens para a Base Oracle
 ********************************************************************************/
trigger procedure for write of int-preco-item.                                
{esp/esb/esesb000.i}
{esp/esb/out/msg0195.i}

DEF VAR raw-param AS RAW NO-UNDO.

//M2109-096 - Melhoria na importa‡Æo da tabela de pre‡os - 10/09/21 - Comentado a pedido de Catia
/*
run esp/es0669.p (input "yes", 
                  "int-preco-item", 
                  int-preco-item.it-codigo, 
                  int-preco-item.cod-refer, 
                  int-preco-item.nr-tabpre,
                  STRING(int-preco-item.dt-inival,"99/99/9999"),
                  STRING(int-preco-item.quant-min,">>>>,>>9.9999"), 
                  "", "", "", "").
*/                  

DEF BUFFER b-preco-item FOR preco-item.


FIND b-preco-item NO-LOCK
    WHERE b-preco-item.it-codigo = int-preco-item.it-codigo
      AND b-preco-item.cod-refer = int-preco-item.cod-refer
      AND b-preco-item.nr-tabpre = int-preco-item.nr-tabpre
      AND b-preco-item.dt-inival = int-preco-item.dt-inival
      AND b-preco-item.quant-min = int-preco-item.quant-min NO-ERROR.

IF  AVAIL  b-preco-item THEN DO:
    /* 0 - Situa‡Æo da Tabela de pre‡o (manuten‡Æo , 0 - situa‡Æo do item da tabela (manute‡Æo)*/
    FIND FIRST tb-preco WHERE tb-preco.nr-tabpre = b-preco-item.nr-tabpre NO-LOCK NO-ERROR.

    IF AVAIL tb-preco THEN DO:
       IF tb-preco.cd-gr-preco = 0 THEN DO:
          {esp/trgw/wdi163.i "0" "0"}
       END.
    END.
END.
