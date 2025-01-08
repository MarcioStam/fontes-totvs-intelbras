/******************************************************************************
*      Programa .....: EN0503-UPCB.P                                          *
*      Data .........: 07 de Abril de 2022                                    *
*      Sistema ......: EN - ENGENHARIA                                        *
*      Empresa ......: iDBA                                                   *
*      Cliente ......: Intelbras                                              *
*      Programador ..: Mauricio                                               *
*      Objetivo .....: Chamado pela UPC no EN0503                             *
*******************************************************************************
*      VERSAO      DATA        RESPONSAVEL   MOTIVO                           *
*      1.00.00.000 07/04/2022  Mauricio      Desenvolvimento                  *
*      1.00.00.000 20/05/2022  Mauricio      Qtd Cons                         *
******************************************************************************/  
def input parameter p-qry       as handle no-undo.
def input parameter p-desc-item as handle no-undo.
def input parameter p-qtd-cons as handle no-undo.

def buffer b-op-ferram for op-ferram.

RUN pi-tipo.
RUN pi-cons.

return.

PROCEDURE pi-tipo:
    def var h-bf as handle no-undo.
    
    def buffer b-ferr-prod for ferr-prod.

    if not valid-handle(p-desc-item)
    then return "NOK".
    
    assign p-desc-item:screen-value = ""
           h-bf                     = p-qry:get-buffer-handle(1).
    
    for first b-op-ferram fields(ferramenta)
        where rowid(b-op-ferram) = h-bf:rowid
              no-lock: end.
    
    if not avail b-op-ferram
    then RETURN "NOK".
    
    for first b-ferr-prod fields(char-1)
        where b-ferr-prod.cod-ferr-prod = b-op-ferram.ferramenta
              no-lock: end.
    
    if not avail b-ferr-prod
    then RETURN "NOK".
    
    assign p-desc-item:screen-value = trim(b-ferr-prod.char-1).

    RETURN "OK".
END PROCEDURE. /* procedure pi-tipo */

PROCEDURE pi-cons:
    def var h-bf as handle no-undo.

    if not valid-handle(p-qtd-cons)
    then return "NOK".  
    
    assign p-qtd-cons:screen-value = ""
           h-bf                    = p-qry:get-buffer-handle(1).

    for first b-op-ferram fields(int-1)
        where rowid(b-op-ferram) = h-bf:rowid
              no-lock: end.
    
    if not avail b-op-ferram
    then RETURN "NOK".

    assign p-qtd-cons:screen-value = string(b-op-ferram.int-1).

    RETURN "OK".
END PROCEDURE. /* procedure pi-cons */

