
DEFINE BUFFER b-item FOR ITEM.
DEFINE BUFFER familia FOR familia.
    
def temp-table tt-estabel no-undo
    field cod-estabel as char
    field log-exporta as log format "*/ "
    index codigo is primary unique cod-estabel
    index exporta log-exporta.  

def temp-table tt-old-item no-undo like item
    use-index codigo.  


OUTPUT TO c:\temp\testeBacaEstab106.txt.


FOR EACH ITEM NO-LOCK
    /*WHERE ITEM.it-codigo = "4980002":*/
    WHERE ITEM.it-codigo >= "4980000"
    AND   ITEM.it-codigo <= "4980100":

    PUT UNFORMATTED SKIP(2) "--------> Item pai: " ITEM.it-codigo SKIP(1).

    RUN pi-desce-estrut (INPUT ITEM.it-codigo).

END.


OUTPUT CLOSE.


PROCEDURE pi-desce-estrut:

    DEFINE INPUT PARAMETER p-it-codigo AS CHAR NO-UNDO.


    RUN pi-verifica-estab (INPUT p-it-codigo).

    FOR EACH estrutura NO-LOCK
        WHERE estrutura.it-codigo = p-it-codigo:

        PUT UNFORMATTED SKIP(2) "---> Item filho: " estrutura.es-codigo SKIP(1).

        RUN pi-desce-estrut (INPUT estrutura.es-codigo).

    END.

END PROCEDURE.



PROCEDURE pi-verifica-estab:

    DEFINE INPUT PARAMETER p-it-codigo AS CHAR NO-UNDO.


    /* Fam¡lia x Estabelecimento */

    FOR FIRST b-item NO-LOCK
        WHERE b-item.it-codigo = p-it-codigo:

        FOR FIRST familia NO-LOCK
            WHERE familia.fm-codigo = b-item.fm-codigo:

            PUT UNFORMATTED "Item: " b-item.it-codigo SKIP
                            "Familia: " familia.fm-codigo SKIP
                            "Existe fam-uni-estab: " can-find(first fam-uni-estab
                                                              where fam-uni-estab.fm-codigo   = familia.fm-codigo
                                                              and   fam-uni-estab.cod-estabel = "106") SKIP.

    
            IF NOT can-find(first fam-uni-estab
                            where fam-uni-estab.fm-codigo   = familia.fm-codigo
                            and   fam-uni-estab.cod-estabel = "106") THEN DO:

                create fam-uni-estab.
                buffer-copy familia except char-1 char-2 to fam-uni-estab
                assign fam-uni-estab.cod-estabel         = "106"
                       fam-uni-estab.tp-ressup           = if int(substr(familia.char-1,10,1)) <> 0 AND
                                                              INT(SUBSTR(familia.char-1,10,1)) <> ? 
                                                              then int(substr(familia.char-1,10,1))
                                                           else 1
                       fam-uni-estab.qt-min-res-fabr     = dec(substr(familia.char-1,20,12))
                       fam-uni-estab.var-tempo-res-fabr  = int(substr(familia.char-1,15,4))
                       fam-uni-estab.var-qtd-res-fabr    = dec(substr(familia.char-1,35,12)).
                
                find first lin-prod where
                           lin-prod.cod-estabel = fam-uni-estab.cod-estabel no-lock no-error.
                if avail lin-prod then
                    assign fam-uni-estab.nr-linha = lin-prod.nr-linha.
                
                /*--- Replica‡Æo dos dados da familia-mat para o fam-uni-estab ---*/
                /*****************************************************************
                **
                **      CD0202.I - Replica»’o familia-mat para fam-uni-estab 
                **                 Deve ser executado somente EMS 2.03 em Diante
                **
                ******************************************************************/
                
                if  avail fam-uni-estab then do:
                    find familia-mat where 
                         familia-mat.fm-codigo = fam-uni-estab.fm-codigo no-lock no-error.
                    
                    if  avail familia-mat then 
                        assign fam-uni-estab.variacao-perm    = familia-mat.variacao-perm
                               fam-uni-estab.prioridade-aprov = if familia-mat.prioridade-aprov < 1 then 1 else familia-mat.prioridade-aprov
                               fam-uni-estab.deposito-cq      = familia-mat.deposito-cq
                               fam-uni-estab.cod-estab-gestor = familia-mat.cod-estab-gestor
                               fam-uni-estab.altera-conta     = familia-mat.altera-conta
                               fam-uni-estab.cd-freq          = familia-mat.cd-freq
                               fam-uni-estab.cod-fat-ponder   = familia-mat.cod-fat-ponder                                 
                               fam-uni-estab.cod-grp-compra   = familia-mat.cod-grp-compra                                 
                               fam-uni-estab.crit-cc          = familia-mat.crit-cc                               
                               fam-uni-estab.crit-ce          = familia-mat.crit-ce
                               fam-uni-estab.lote-per-max     = familia-mat.lote-per-max
                               fam-uni-estab.ponto-encomenda  = familia-mat.ponto-encomenda                 
                               fam-uni-estab.tp-ressup        = familia-mat.tp-ressup
                               fam-uni-estab.var-qtd-re       = familia-mat.var-qtd-re                      
                               fam-uni-estab.var-val-re-maior = familia-mat.var-val-re-maior
                               fam-uni-estab.var-val-re-menor = familia-mat.var-val-re-menor
                               fam-uni-estab.dep-rej-cq       = familia-mat.dep-rej-cq      
                               fam-uni-estab.lim-var-qtd      = familia-mat.lim-var-qtd     
                               fam-uni-estab.lim-var-valor    = familia-mat.lim-var-valor
                               fam-uni-estab.nat-despesa      = familia-mat.nat-despesa
                               fam-uni-estab.classif-abc      = familia-mat.classif-abc.
                end.  
                    
                /*--- fim do include ---*/    

            END.
                

                
            /* Item x Estabelecimento */

            EMPTY TEMP-TABLE tt-estabel.
            EMPTY TEMP-TABLE tt-old-item.

            create tt-old-item.
            buffer-copy item to tt-old-item.


            PUT UNFORMATTED "Tem item-uni-estab ANTES: " CAN-FIND(FIRST item-uni-estab
                                                                  WHERE item-uni-estab.it-codigo = b-item.it-codigo
                                                                  AND   item-uni-estab.cod-estabel = "106") SKIP.

            run cdp/cd0204k.p (input b-item.it-codigo,
                               input "I", /* InclusÆo */
                               INPUT no,
                               input no,
                               input TRUE,
                               input table tt-estabel,
                               input table tt-old-item).

            FOR FIRST item-uni-estab EXCLUSIVE-LOCK
                WHERE item-uni-estab.it-codigo = b-item.it-codigo
                AND   item-uni-estab.cod-estabel = "106":

                IF substring(b-item.it-codigo,1,1) = "1" THEN
                    ASSIGN item-uni-estab.deposito-pad = "ALM".

                IF substring(b-item.it-codigo,1,1) = "2" THEN
                    ASSIGN item-uni-estab.deposito-pad = "PRO".

                ASSIGN item-uni-estab.cod-unid-negoc = "FIR"
                       item-uni-estab.nr-linha       = 1.

            END.

            PUT UNFORMATTED "Tem item-uni-estab DEPOIS: " CAN-FIND(FIRST item-uni-estab
                                                                   WHERE item-uni-estab.it-codigo = b-item.it-codigo
                                                                   AND   item-uni-estab.cod-estabel = "106") SKIP.
            

        END.

    END.

END PROCEDURE.
