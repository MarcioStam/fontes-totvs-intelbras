/******************************************************************************
*      Programa .....: CC0300B-UPCA.P                                         *
*      Data .........: 28 de Junho de 2022                                    *
*      Sistema ......: CC - COMPRAS                                           *
*      Empresa ......: iDBA                                                   *
*      Cliente ......: Intelbras                                              *
*      Programador ..: Mauricio                                               *
*      Objetivo .....: Chamado pela UPC no CC0300B                            *
*******************************************************************************
*      VERSAO      DATA        RESPONSAVEL   MOTIVO                           *
*      1.00.00.000 28/06/2022  Mauricio      Desenvolvimento                  *
******************************************************************************/  
def input parameter p-qry            as handle no-undo.
def input parameter p-numero-ordem   as handle no-undo.
def input parameter p-dt-necessidade as handle no-undo.

def var h-bf as handle no-undo.

def buffer b-int-prazo-compra for int-prazo-compra.

if not valid-handle(p-dt-necessidade)
then return.

assign p-dt-necessidade:screen-value = ""
       h-bf                          = p-qry:get-buffer-handle(1).

for first b-int-prazo-compra
    where b-int-prazo-compra.numero-ordem = integer(p-numero-ordem:screen-value)
      and b-int-prazo-compra.parcela      = integer(h-bf:buffer-field("parcela"):buffer-value)
          no-lock: end.

if not avail b-int-prazo-compra
then return.

assign p-dt-necessidade:screen-value = string(b-int-prazo-compra.data-necessidade).

return.
