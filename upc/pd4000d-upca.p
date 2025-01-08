
/* ----------------------------------------------------------------------------
   Programa..: upc/pd4000d-upc.p
   Data......: 13/04/2015
   Autor.....: Rubia Oliveira 
   Objetivo..: 
---------------------------------------------------------------------------- */
DEFINE NEW GLOBAL SHARED VAR gr-ped-venda       AS ROWID         NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whBtOkPD4000d      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR whBtOkPD4000dLocal AS WIDGET-HANDLE NO-UNDO.
{utp/ut-glob.i}

/* FIND FIRST ponto-programa                                                                    */
/*     WHERE ponto-programa.nome-programa = "pd4000":U                                          */
/*       AND ponto-programa.ponto         = 5 NO-LOCK NO-ERROR.                                 */
/* IF AVAILABLE ponto-programa THEN DO:                                                         */
/*     IF NOT CAN-FIND(conteudo-programa                                                        */
/*         WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa                   */
/*           AND conteudo-programa.conteudo     = c-seg-usuario) THEN DO:                       */
/*                                                                                              */
/*         RUN utp/ut-msgs.p (INPUT "SHOW":U,                                                   */
/*                    INPUT 17006,                                                              */
/*                    INPUT "Op‡Æo de c¢pia indispon¡vel.~~ " +                                 */
/*                          "Por gentileza, entrar em contato com PCI - Programa de Canais.")). */
/*         RETURN 'NOK'.                                                                        */
/*     END.                                                                                     */
/* END.                                                                                         */

FIND FIRST ped-venda NO-LOCK
     WHERE ROWID(ped-venda) = gr-ped-venda NO-ERROR.

FOR EACH ped-item OF ped-venda NO-LOCK:
    FIND FIRST item-uni-estab NO-LOCK
         WHERE item-uni-estab.cod-estabel = ped-venda.cod-estabel
           AND item-uni-estab.it-codigo   = ped-item.it-codigo NO-ERROR.
    
    IF AVAIL item-uni-estab
    AND item-uni-estab.cod-unid-negoc <> ped-item.cod-unid-negoc THEN DO:
        FIND CURRENT ped-item EXCLUSIVE-LOCK.
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 15825,
                           INPUT "Unidade de neg¢cio " + ped-item.cod-unid-negoc + " do item " +  ped-item.it-codigo + " diferente de " + item-uni-estab.cod-unid-negoc + " cadastrada Item x Estabelecimento" + 
                                 "~~Unidade do item alterada automaticamente.").
        ASSIGN ped-item.cod-unid-negoc = item-uni-estab.cod-unid-negoc.
        FIND CURRENT ped-item NO-LOCK.
    END.
END.


APPLY "CHOOSE" TO whBtOkPD4000d.
