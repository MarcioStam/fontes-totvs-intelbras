/******************************************************************************
*      Programa .....: EN0507-UPC02.P                                         *
*      Data .........: 27 de Abril de 2022                                    *
*      Sistema ......: EN - ENGENHARIA                                        *
*      Empresa ......: iDBA                                                   *
*      Cliente ......: Intelbras                                              *
*      Programador ..: Mauricio                                               *
*      Objetivo .....: Chamado pela UPC no EN0507                             *
*******************************************************************************
*      VERSAO      DATA        RESPONSAVEL   MOTIVO                           *
*      1.00.00.000 27/04/2022  Mauricio      Desenvolvimento                  *
******************************************************************************/  
def input parameter p-qry     as handle no-undo.
def input parameter p-hom-aps as handle no-undo.

def var h-bf as handle no-undo.

def buffer b-operacao for operacao.

assign p-hom-aps:screen-value = ""
       h-bf                   = p-qry:get-buffer-handle(1).

for first b-operacao fields(num-id-operacao)
    where rowid(b-operacao) = h-bf:rowid
          no-lock: end.

if not avail b-operacao
then return.

for first int-ext-operacao
    where int-ext-operacao.num-id-operacao = b-operacao.num-id-operacao
          no-lock: end.

if not avail int-ext-operacao
then return.

assign p-hom-aps:screen-value = string(int-ext-operacao.nro-homem-aps).

return.
