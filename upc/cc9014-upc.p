/***********************************************************************
**  Programa..: UPC\CC0312-UPC.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: Impedir cadastramento de itens na tabela para itens nao 
**              relacionados com o fornecedor ou que nao estejam ativos
**  Vers∆o....: 001 23/12/2004
**                  Desenvolvimento Programa
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEF VAR c-objeto  AS CHAR            NO-UNDO.
DEF VAR l-ok      AS LOGICAL         NO-UNDO.
DEF VAR h-frame   AS HANDLE          NO-UNDO.
DEF VAR h-frame-1 AS HANDLE          NO-UNDO.
DEF VAR cReturn   AS CHAR            NO-UNDO.
DEF VAR h-buffer  AS HANDLE          NO-UNDO.
DEF VAR ponteiro  AS WIDGET-HANDLE   NO-UNDO.
def var i-num-casa-dec as dec.
def var de-fator-conver as dec.

{upc/btb910za-upc.i}
{utp/ut-glob.i}

DEFINE VARIABLE vDtLimite  AS DATE    FORMAT "99/99/9999":U NO-UNDO.

DEF NEW GLOBAL SHARED VAR whItCodigo AS WIDGET-HANDLE NO-UNDO.

def buffer b-prazo-compra for prazo-compra.

DEFINE VARIABLE c-motivo AS CHARACTER   NO-UNDO.

DEF NEW GLOBAL SHARED VAR gr-item-tab  AS ROWID NO-UNDO.

DEF NEW GLOBAL SHARED VAR g-dt-limite-cc9014-upc AS DATE NO-UNDO.
DEF NEW GLOBAL SHARED VAR g-justif-cc9014-upc    AS CHARACTER FORMAT "X(500)":U NO-UNDO.

DEFINE TEMP-TABLE tt-prazo-compra LIKE prazo-compra
    FIELD num-pedido   LIKE ordem-compra.num-pedido
    FIELD embarque     LIKE ordens-embarque.embarque
    FIELD preco-fornec LIKE cotacao-item.preco-fornec
    FIELD mo-codigo    LIKE cotacao-item.mo-codigo
    FIELD situacao-emb   AS INT
    FIELD l-selecionado  AS LOG FORMAT "*/"
    FIELD l-pode-alterar AS LOG
    FIELD r-rowid        AS ROWID
    FIELD cod-estabel    LIKE ordens-embarque.cod-estabel.

{esp/imp/esimp000.i1} /*tt-emb*/

assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                        p-wgh-object:file-name,"~/").

/****************************  Variaveis    ****************************/
CASE p-ind-event:
    WHEN "AFTER-INITIALIZE" THEN DO:
        IF p-ind-object = "VIEWER"     AND
           c-objeto     = "v01in185.w" THEN DO:
            ASSIGN h-frame = p-wgh-frame:FIRST-CHILD.
            ASSIGN h-frame = h-frame:FIRST-CHILD.
            DO  WHILE VALID-HANDLE(h-frame):
                IF  h-frame:TYPE <> "field-group" THEN DO:
                    CASE h-frame:NAME:
                        WHEN "it-codigo" THEN ASSIGN whItCodigo = h-frame.
                    END.
                    ASSIGN h-frame = h-frame:NEXT-SIBLING.
                END.
                ELSE LEAVE.
            END.
        END.
    END.
    WHEN "ASSIGN" THEN DO:
        IF p-ind-object = "VIEWER"     AND
           c-objeto     = "v01in185.w" THEN DO:
            FOR FIRST item-tab no-LOCK
                WHERE ROWID(item-tab) = p-row-table:

                find emitente where emitente.nome-abrev = item-tab.nome-abrev NO-LOCK NO-ERROR.
                IF  AVAIL emitente THEN DO:
                    if emitente.natureza = 3 /*"E"*/ then do:
    
                        if item-tab.aliquota-ipi <> 0 then do:
                           RUN utp/ut-msgs.p (input "SHOW",
                                              input 17567,
                                              input "A aliquota de IPI deve ser zero, pois o fornecedor e estrangeiro.").
                          RETURN "NOK".
                       end.
                    end.
    
                    find item-fornec 
                         where item-fornec.it-codigo = item-tab.it-codigo
                           and item-fornec.cod-emitente = emitente.cod-emitente 
                           no-lock no-error.
                    if not avail item-fornec then do:
                        RUN utp/ut-msgs.p (input "SHOW",
                                           input 17567,
                                           input "Relacao do item com o fornecedor nao esta cadastrada.").
                        RETURN "NOK".
                    end.
                    else do:
                        if item-fornec.ativo = no then do:
                            RUN utp/ut-msgs.p (input "SHOW",
                                               input 17567,
                                               input "Relacao do item com o fornecedor esta desativada.").
                            RETURN "NOK".
                        end.
                    end.
                END. /* IF  AVAIL emitente THEN DO: */
            END.
        END.
    END.
    WHEN "END-UPDATE" THEN DO:
        IF p-ind-object = "VIEWER"     AND
           c-objeto     = "v01in185.w" THEN DO:
            FOR FIRST item-tab no-LOCK
                WHERE ROWID(item-tab) = p-row-table:

                RUN p-atualiza-pedido.
            END.
        END.
    END.
END CASE.

return "OK".

PROCEDURE p-atualiza-pedido.
    /*
    RUN piPedeTela.
    */
/*
    FOR FIRST item-tab 
        WHERE ROWID(item-tab) = p-row-table,
        FIRST tb-pr-cc NO-LOCK
        WHERE /*tb-pr-cc.cod-emitente = item-tab.cod-emitente
        AND   */ 
              tb-pr-cc.cod-cond-pag = item-tab.cod-cond-pag
        AND   tb-pr-cc.nr-tab       = item-tab.nr-tab      
        AND   tb-pr-cc.nome-abrev   = item-tab.nome-abrev:
        
        /*of tb-pr-cc no-lock:*/
*/
    FOR FIRST item-tab NO-LOCK
        WHERE ROWID(item-tab) = p-row-table,
        /*FIRST tb-pr-cc NO-LOCK OF ITEM-tab*/
        FIRST tb-pr-cc NO-LOCK 
        WHERE tb-pr-cc.cod-emitente  = item-tab.cod-emitente  
        AND   tb-pr-cc.cod-cond-pag  = item-tab.cod-cond-pag  
        AND   tb-pr-cc.nr-tab        = item-tab.nr-tab        
        AND   tb-pr-cc.nome-abrev    = item-tab.nome-abrev:
        /*find emitente where emitente.nome-abrev = tb-pr-cc.nome-abrev no-lock.

        for each ordem-compra 
           where ordem-compra.cod-estabel = v_cod_estab_usuar
             and ordem-compra.it-codigo    = item-tab.it-codigo
             and ordem-compra.cod-emitente = emitente.cod-emitente
             and ordem-compra.situacao = 2 /*"C"*/ EXCLUSIVE-LOCK,
             each prazo-compra no-lock
            where prazo-compra.numero-ordem = ordem-compra.numero-ordem
              and prazo-compra.data-entrega > vDtLimite
              and prazo-compra.quant-saldo > 0:
            find first b-prazo-compra
                 where b-prazo-compra.numero-ordem = ordem-compra.numero-ordem
                   and b-prazo-compra.parcela > 1 no-lock no-error.
                     
            if  avail b-prazo-compra then do:
                RUN utp/ut-msgs.p (input "SHOW",
                                   input 17567,
                                   input "A ordem " + string(ordem-compra.numero-ordem) + " do pedido " + string(ordem-compra.num-pedido) +  " tem mais de uma parcela. Nao sera alterada.").
                next.          
            end.    
            
            find first ordens-embarque NO-LOCK
                 WHERE ordens-embarque.numero-ordem  = prazo-compra.numero-ordem
                   AND ordens-embarque.parcela       = prazo-compra.parcela no-error.
            if avail ordens-embarque then do:
                RUN pi-busca-posicao. 
                FIND FIRST tt-emb NO-ERROR.
                IF AVAIL tt-emb
                     and tt-emb.situacao >= 2
                     and tt-emb.situacao <= 4 then
                     next.
            end.         
            
            RUN utp/ut-msgs.p (input "SHOW",
                               input 27100,
                               input "Altera a ordem " + string(ordem-compra.numero-ordem) + " do pedido " +
                                                       string(ordem-compra.num-pedido) + " de " + 
                                                       string(prazo-compra.data-entrega) + "." 
                                                                  + "~~" + 
                                     "Altera a ordem " + string(ordem-compra.numero-ordem) + " do pedido " +
                                                       string(ordem-compra.num-pedido) + " de " + 
                                                       string(prazo-compra.data-entrega) + ".").
  
            IF RETURN-VALUE = "NO" THEN next.

            find cotacao-item 
                 where cotacao-item.numero-ordem = ordem-compra.numero-ordem
                   and cotacao-item.cod-emitente = ordem-compra.cod-emitente
                   and cotacao-item.cot-aprovada EXCLUSIVE-LOCK NO-ERROR.

            IF NOT AVAIL cotacao-item THEN NEXT.*/


        ASSIGN vDtLimite = g-dt-limite-cc9014-upc
               c-motivo  = g-justif-cc9014-upc
               gr-item-tab = ROWID(item-tab).
        /*
        RUN esp/ccp/esccp047.w (INPUT v_cod_estab_usuar,
                                INPUT vDtLimite,
                                INPUT-OUTPUT c-motivo,
                                OUTPUT TABLE tt-prazo-compra).*/

        IF g-justif-cc9014-upc <> ? THEN
            RUN esp/ccp/esccp047.w.

        ASSIGN g-dt-limite-cc9014-upc = ?
               g-justif-cc9014-upc    = ?
               gr-item-tab            = ?.
        /*
        FOR EACH tt-prazo-compra
           WHERE tt-prazo-compra.l-selecionado
        BREAK BY tt-prazo-compra.numero-ordem:

            IF FIRST-OF(tt-prazo-compra.numero-ordem) THEN DO:

                FIND FIRST ordem-compra EXCLUSIVE-LOCK
                     WHERE ordem-compra.numero-ordem = tt-prazo-compra.numero-ordem NO-ERROR.

                FIND FIRST cotacao-item EXCLUSIVE-LOCK 
                     WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                       AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
                       AND cotacao-item.cot-aprovada NO-ERROR.
            
                find item-fornec
                     where item-fornec.it-codigo = item-tab.it-codigo
                       and item-fornec.cod-emitente = tb-pr-cc.cod-emitente no-lock.

                CREATE alt-ped.
                ASSIGN alt-ped.num-pedido   = ordem-compra.num-pedido
                       alt-ped.numero-ordem = ordem-compra.numero-ordem
                       alt-ped.parcela      = tt-prazo-compra.parcela
                       alt-ped.preco        = ordem-compra.preco-unit.
                
                assign i-num-casa-dec = exp(10,item-fornec.num-casa-dec).
                            
                assign de-fator-conver = item-fornec.fator-conver / i-num-casa-dec.    
        
                assign ordem-compra.preco-unit = item-tab.pr-item * de-fator-conver 
                       + if not tb-pr-cc.codigo-ipi then 
                       ((item-tab.pr-item * de-fator-conver) * item-tab.aliquota-ipi / 100)
                       else 0 
        
                       cotacao-item.preco-unit = item-tab.pr-item * de-fator-conver  
                       + if not tb-pr-cc.codigo-ipi then 
                       ((item-tab.pr-item * de-fator-conver) * item-tab.aliquota-ipi / 100)
                       else 0 
                       ordem-compra.pre-unit-for = item-tab.pr-item
                       + if not tb-pr-cc.codigo-ipi then 
                       ((item-tab.pr-item) * item-tab.aliquota-ipi / 100)
                       else 0 
                       ordem-compra.preco-fornec = item-tab.pr-item
                       cotacao-item.pre-unit-for = item-tab.pr-item
                       + if not tb-pr-cc.codigo-ipi then 
                       ((item-tab.pr-item) * item-tab.aliquota-ipi / 100)
                       else 0 
                       cotacao-item.preco-fornec = item-tab.pr-item
                       ordem-compra.aliquota-icm = item-tab.aliquota-icm
                       cotacao-item.aliquota-icm = item-tab.aliquota-icm
                       ordem-compra.aliquota-ipi = item-tab.aliquota-ipi
                       cotacao-item.aliquota-ipi = item-tab.aliquota-ipi.

             
             ASSIGN alt-ped.data         = today
                    alt-ped.char-1       = STRING(ordem-compra.preco-unit)
                    alt-ped.hora         = string(time,"hh:mm:ss")
                    alt-ped.usuario      = c-seg-usuario
                    alt-ped.data-entrega = tt-prazo-compra.data-entrega
                    alt-ped.observacao   = c-motivo
                    alt-ped.quantidade   = ?
                    alt-ped.cod-cond-pag = ?. 
            END.
         END.
        */
    END.
END. 

/*
PROCEDURE piPedeTela:
    DEFINE VARIABLE fiDtLimite AS DATE FORMAT "99/99/9999":U 
         LABEL "A Partir de" 
         VIEW-AS FILL-IN 
         SIZE 12 BY .88 NO-UNDO.
        
    DEFINE BUTTON btGoToOK AUTO-GO /*AUTO-END-KEY */
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 65 BY 1.5
         BGCOLOR 7.

    DEFINE RECTANGLE rtGoToFields
         EDGE-PIXELS 2 GRAPHIC-EDGE
         SIZE 65 BY 1.3
         BGCOLOR 8.

    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE FRAME fAtu
           fiDtLimite        AT ROW 1.17 COL 18 COLON-ALIGN
           rtGoToFields      AT ROW 1    COL 1
           btGoToOK          AT ROW 2.7  COL 2.14
           rtGoToButton      AT ROW 2.5  COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Informaá‰es Cotaá∆o" FONT 1
             DEFAULT-BUTTON btGoToOK.


    ON  "CHOOSE":U OF btGoToOK IN FRAME fAtu DO:
        SESSION:SET-WAIT-STATE("general":U).
        SESSION:SET-WAIT-STATE("":U).
        ASSIGN fiDtLimite.
        ASSIGN vDtLimite  = fiDtLimite
               g-dt-limite-cc9014-upc = vDtLimite.
        APPLY "GO":U TO FRAME fAtu.
    END.

    ENABLE fiDtLimite btGoToOK 
           WITH FRAME fAtu.
    
    WAIT-FOR "GO":U OF FRAME fAtu.
    

END PROCEDURE.
*/

PROCEDURE pi-busca-posicao :
    
    FOR EACH embarque-imp NO-LOCK
       WHERE embarque-imp.situacao = 1
         AND embarque-imp.cod-estabel = v_cod_estab_usuar
         AND embarque-imp.embarque    = ordens-embarque.embarque:
       
        {esp/imp/esimp000.i}
    END.
END PROCEDURE.
