{include/i-prgvrs.i ESCDP052 2.00.00.000 } /*** 010000 ***/

{esp/cdp/escdp052.i} 
{esp/es0018.i}
{upc/btb910za-upc.i}

def temp-table tt-raw-digita
   field raw-digita as raw.

DEFINE TEMP-TABLE tt-xml-familia
    FIELD fm-codigo     LIKE familia.fm-codigo
    FIELD descricao     LIKE familia.descricao.

DEFINE TEMP-TABLE tt-xml-item
    FIELD it-codigo     LIKE ITEM.it-codigo
    FIELD desc-item     LIKE ITEM.desc-item
    FIELD fm-codigo     LIKE ITEM.fm-codigo
    FIELD pn1           AS CHAR
    FIELD pn2           AS CHAR
    FIELD fab1          AS CHAR
    FIELD fab2          AS CHAR
    FIELD num-fab       AS INTEGER
    FIELD saldo         AS DECIMAL  FORMAT "->>>,>>>,>>9.99"
    FIELD valor1        AS DECIMAL  FORMAT "->>>,>>>,>>9.99"
    FIELD valor2        AS DECIMAL  FORMAT "->>>,>>>,>>9.99"
    FIELD un1           AS CHAR
    FIELD un2           AS CHAR
    FIELD num-for       AS INTEGER
    FIELD situacao      AS INTEGER.

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

DEFINE VARIABLE h-acomp AS HANDLE      NO-UNDO.
DEFINE VARIABLE i-cont AS DECIMAL      NO-UNDO.
DEFINE VARIABLE i-aux AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-unid-med-for AS CHARACTER   NO-UNDO.
DEFINE VARIABLE d-valor AS DECIMAL     NO-UNDO.
DEFINE VARIABLE d-saldo AS DECIMAL     NO-UNDO.
DEFINE VARIABLE i-moeda-real AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-cod-estabel AS CHARACTER   NO-UNDO.

create tt-param.
raw-transfer raw-param to tt-param.
find first tt-param no-lock no-error.


/** Defini¯´es de vari˜veis e frames padr´es **/
{include/i-rpvar.i}

assign c-programa     = "ESCDP052":U
       c-versao       = "00"
       c-revisao      = "000"
       c-titulo-relat = "Gera‡Æo XMLs Altium"
       i-cont         = 0
       i-moeda-real   = 0.  /* REAL */

FIND FIRST param-global NO-LOCK NO-ERROR.
    IF AVAIL param-global THEN
        ASSIGN c-empresa = param-global.grupo.


{include/i-rpcab.i}         
{include/i-rpout.i}

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Gera‡Æo de XMLs").

ASSIGN c-cod-estabel = v_cod_estab_usuar.
IF c-cod-estabel = "" OR
   c-cod-estabel = ? THEN
    ASSIGN c-cod-estabel = "101".

RUN pi-exporta-familias.

RUN pi-exporta-itens.


DISP "Arquivos XML gerados com sucesso no diret¢rio: " tt-param.dir-xml FORMAT "X(50)" NO-LABELS.


{include/i-rpclo.i}

RUN pi-finalizar IN h-acomp.

RETURN "OK":U.



PROCEDURE pi-exporta-familias:

    ASSIGN i-cont = 0.

    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT "ESCDP052":U, /* Nome do programa */
                       INPUT 1,            /* Ponto do programa */
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR EACH tt-prog-ponto:

        RUN pi-acompanhar IN h-acomp (INPUT "Fam¡lia " + ENTRY(1, tt-prog-ponto.conteudo, ";") ).

        FOR EACH familia FIELDS(fm-codigo descricao) NO-LOCK
            WHERE familia.fm-codigo BEGINS ENTRY(1, tt-prog-ponto.conteudo, ";"):

            ASSIGN i-cont = i-cont + 1.

            EMPTY TEMP-TABLE tt-xml-familia.

            CREATE tt-xml-familia.
            ASSIGN tt-xml-familia.fm-codigo = familia.fm-codigo
                   tt-xml-familia.descricao = ENTRY(2, tt-prog-ponto.conteudo, ";").

            RUN esp/es0040.p (INPUT BUFFER tt-xml-familia:HANDLE,
                              INPUT "familia",
                              INPUT TRUE,
                              INPUT tt-param.dir-xml).

        END.

    END.

    

END PROCEDURE.




PROCEDURE pi-exporta-itens:

    ASSIGN i-cont = 0.

    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT "ESCDP052":U, /* Nome do programa */
                       INPUT 1,            /* Ponto do programa */
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR EACH tt-prog-ponto:

        FOR EACH familia FIELDS(fm-codigo descricao) NO-LOCK
            WHERE familia.fm-codigo BEGINS ENTRY(1, tt-prog-ponto.conteudo, ";"):

            FOR EACH ITEM FIELDS(it-codigo desc-item fm-codigo un) 
                WHERE ITEM.fm-codigo = familia.fm-codigo NO-LOCK:
        
                EMPTY TEMP-TABLE tt-xml-item.
        
                FOR FIRST item-uni-estab fields(cod-estabel it-codigo cod-obsoleto) NO-LOCK
                    WHERE item-uni-estab.it-codigo = ITEM.it-codigo
                    AND   item-uni-estab.cod-estabel = c-cod-estabel:
                END.

                IF NOT AVAIL item-uni-estab THEN DO:

                    FOR FIRST item-uni-estab fields(cod-estabel it-codigo cod-obsoleto) NO-LOCK
                        WHERE item-uni-estab.it-codigo = ITEM.it-codigo
                        AND   item-uni-estab.cod-estabel = "101":
                    END.

                END.

        
                IF NOT AVAIL item-uni-estab THEN
                    NEXT.
        
                ASSIGN i-cont = i-cont + 1.
        
                IF i-cont MOD 100 = 0 THEN
                    RUN pi-acompanhar IN h-acomp (INPUT "Item: " + ITEM.it-codigo).
        
        
                ASSIGN d-saldo = 0.
        
                FOR EACH saldo-estoq FIELDS(it-codigo cod-depos qtidade-atu) NO-LOCK
                    WHERE saldo-estoq.it-codigo = ITEM.it-codigo:
        
                    FOR FIRST deposito NO-LOCK
                        WHERE deposito.cod-depos = saldo-estoq.cod-depos
                        AND   deposito.cons-saldo:
        
                        ASSIGN d-saldo = d-saldo + saldo-estoq.qtidade-atu.
        
                    END.
        
                END.
        
                
        
                CREATE tt-xml-item.
                ASSIGN tt-xml-item.it-codigo = ITEM.it-codigo
                       tt-xml-item.desc-item = ITEM.desc-item
                       tt-xml-item.fm-codigo = ITEM.fm-codigo
                       tt-xml-item.saldo     = d-saldo
                       tt-xml-item.situacao  = item-uni-estab.cod-obsoleto.
                              
        
        
                /* Fabricantes */
        
                ASSIGN i-aux = 0.
        
                bl-fabric:
                FOR EACH item-fabric FIELDS(it-codigo it-fabric cod-fabric) USE-INDEX item-fab  NO-LOCK
                    WHERE item-fabric.it-codigo = ITEM.it-codigo:
                    
                    ASSIGN i-aux = i-aux + 1.

                    IF i-aux < 3 THEN DO:

                        FOR FIRST fabricante NO-LOCK
                            WHERE fabricante.cod-fabric = item-fabric.cod-fabric:
                        END.

                    END.
        
                    IF i-aux = 1 THEN DO:
        
                        ASSIGN tt-xml-item.pn1  = item-fabric.it-fabric
                               tt-xml-item.fab1 = IF AVAIL fabricante THEN fabricante.nome ELSE "" /*item-fabric.cod-fabric*/.
        
                    END.
        
                    IF i-aux = 2 THEN DO:
        
                        ASSIGN tt-xml-item.pn2  = item-fabric.it-fabric
                               tt-xml-item.fab2 = IF AVAIL fabricante THEN fabricante.nome ELSE "" /*item-fabric.cod-fabric*/.
        
                    END.
        
                END.
        
                ASSIGN tt-xml-item.num-fab = i-aux.
        
        
        
                /* Fornecedores */
        
                ASSIGN i-aux = 0.
        
                FOR EACH item-fornec-estab fields(it-codigo cod-estabel cod-emitente cod-cond-pag)  USE-INDEX item-estab NO-LOCK
                    WHERE item-fornec-estab.it-codigo = ITEM.it-codigo
                    AND   item-fornec-estab.cod-estabel = c-cod-estabel:
        
                    ASSIGN i-aux = i-aux + 1.
        
                    IF i-aux < 3 THEN DO:
        
                        FOR FIRST item-fornec FIELDS(it-codigo cod-emitente unid-med-for) NO-LOCK
                            where item-fornec.it-codigo    = item-fornec-estab.it-codigo
                            AND   item-fornec.cod-emitente = item-fornec-estab.cod-emitente:
                        END.
        
                        if avail item-fornec then
                            assign c-unid-med-for = item-fornec.unid-med-for.   
                        else
                            assign c-unid-med-for = ITEM.un.
        
                        IF i-aux = 1 THEN
                            ASSIGN tt-xml-item.un1 = c-unid-med-for.
        
                        IF i-aux = 2 THEN
                            ASSIGN tt-xml-item.un2 = c-unid-med-for.
        
        
        
                        /*FOR FIRST emitente FIELDS(cod-emitente nome-abrev) NO-LOCK
                            WHERE emitente.cod-emitente = item-fornec-estab.cod-emitente: */
            
                            /*FOR FIRST tb-pr-cc NO-LOCK
                                WHERE tb-pr-cc.nome-abrev   = emitente.nome-abrev      
                                AND   tb-pr-cc.dt-inicio   <= TODAY                    
                                AND   tb-pr-cc.dt-termino  >= TODAY                    
                                AND   tb-pr-cc.situacao     = 1                        
                                AND   tb-pr-cc.cod-cond-pag = item-fornec-estab.cod-cond-pag:*/
        
                            FOR FIRST tb-pr-cc fields(cod-emitente cdn-fabrican cod-cond-pag dt-inicio dt-termino nr-tab mo-codigo) NO-LOCK
                                WHERE tb-pr-cc.cod-emitente = item-fornec-estab.cod-emitente
                                AND   tb-pr-cc.cdn-fabrican = 0
                                AND   tb-pr-cc.cod-cond-pag = item-fornec-estab.cod-cond-pag
                                AND   tb-pr-cc.dt-inicio   <= TODAY                    
                                AND   tb-pr-cc.dt-termino  >= TODAY:
            
                                FOR FIRST item-tab USE-INDEX item-tab NO-LOCK
                                    WHERE item-tab.it-codigo    = ITEM.it-codigo
                                    AND   item-tab.cod-emitente = item-fornec-estab.cod-emitente
                                    AND   item-tab.cdn-fabrican = 0
                                    AND   item-tab.cod-cond-pag = tb-pr-cc.cod-cond-pag 
                                    AND   item-tab.nr-tab       = tb-pr-cc.nr-tab:
            
                                    if tb-pr-cc.mo-codigo = i-moeda-real then
                                        assign d-valor = item-tab.pr-item.
                                    else do:
                                        run "cdp/cd0812.p" (input tb-pr-cc.mo-codigo,
                                                            input i-moeda-real,
                                                            input item-tab.pr-item,
                                                            input TODAY,
                                                            output d-valor).
                                        
                                        if d-valor = ? then d-valor = 0. 
                                    end.
                                    
        
                                    IF i-aux = 1 THEN DO:
                                        ASSIGN tt-xml-item.valor1 = d-valor.
                                    END.
        
        
                                    IF i-aux = 2 THEN DO:
                                        ASSIGN tt-xml-item.valor2 = d-valor.
                                    END.
            
                                END.
            
                            END.
            
                        /*END.*/
        
                    END.
        
                END.  /* FOR EACH item-fornec-estab */
        
                ASSIGN tt-xml-item.num-for = i-aux.
        
                RUN esp/es0040.p (INPUT BUFFER tt-xml-item:HANDLE,
                              INPUT "item",
                              INPUT TRUE,
                              INPUT tt-param.dir-xml).
        
            END.

        END.

    END.

END PROCEDURE.
