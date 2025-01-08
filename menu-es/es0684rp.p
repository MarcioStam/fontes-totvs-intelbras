{include/i-prgvrs.i ESCEP046 1.00.00.000}
/***********************************************************************
**  Programa..: ESP\REP\ES0684RP.P
**  Autor.....: Emerson Colla
**  Data......: Junho/2008 - Desenvolvimento
**  Descricao.: listagem de itens por estrutura
**  VersÆo....: 001 25/06/2008
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/
{utp/ut-glob.i}
{include/i-rpvar.i}

DEF var h-acomp      as handle                  no-undo.
DEF VAR de-outr-desp AS DEC.
DEF VAR de-pis      AS DEC.
DEF VAR de-cofins   AS DEC.
def var c-data-ini  like ns-data.data.
def var c-data-fim  like ns-data.data.

/****************************  Temp-Tables  ****************************/
{menu-es\es0684tt.i}

/****************************  Frames       ****************************/

/* ******************************************************************** */

DEF input parameter raw-param as raw no-undo.
DEF input parameter table for tt-raw-digita.

def var de-cotacao as dec.
def var de-tot-geral as dec.

def temp-table tt-item
    field it-codigo      like estrutura.it-codigo
    field es-codigo      like estrutura.es-codigo
    field quant-usada    like estrutura.quant-usada initial 0
    field ncm            like classif-fisc.class-fiscal
    field valor          as dec format ">>,>>>,>>9.9999" label "Preco Medio"
    field pais           like emitente.pais
    index tt-item is primary it-codigo es-codigo.

def temp-table tt-pais
    field pais like emitente.pais
    field ncm  like tt-item.ncm
    field valor like tt-item.valor
    field perc  as dec
    index tt-pais is primary pais ncm.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK WHERE
          empresa.ep-codigo = param-global.empresa-pri: END.

FIND FIRST tt-param NO-ERROR.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Listagem de itens por estrutura"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "ES0684"
       c-versao       = "1.00"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */

DO ON STOP UNDO, LEAVE:
    {include/i-rpcab.i}
    {include/i-rpout.i}

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  

    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
    
    run piRelat.

    RUN pi-finalizar in h-acomp.
    {include/i-rpclo.i}
    RETURN "OK".
END.

PROCEDURE piRelat:  

    RUN pi-inicializar in h-acomp (input "Imprimindo...").
    
    for each tt-item:
        delete tt-item.
    end.
    for each tt-pais:
        delete tt-pais.
    end.
    
    for each estrutura no-lock
        where estrutura.it-codigo = tt-param.it-codigo
          and estrutura.data-inicio <= today
          and estrutura.data-termino > today: 
        find item where item.it-codigo = estrutura.es-codigo no-lock.
        if item.compr-fabr = 2 then do:
            run pi-estrutura(estrutura.es-codigo, 1).
        end.
        else do:
            find tt-item
                 where tt-item.it-codigo = tt-param.it-codigo
                   and tt-item.es-codigo = estrutura.es-codigo no-error.
            if not avail tt-item then  create tt-item.
    
            assign tt-item.it-codigo    = tt-param.it-codigo
                   tt-item.es-codigo    = estrutura.es-codigo
                   tt-item.quant-usada  = estrutura.quant-usada.
        end.
    end.

    for each tt-item:
        find item where item.it-codigo = tt-item.es-codigo no-lock.
/*         {esp/es0012.i} */
        assign tt-item.ncm = item.class-fiscal.
            
        run pi-busca-cotacao( input item.data-ult-ent).
            
        assign tt-item.valor = item.preco-ul-ent / de-cotacao.
                   
        FIND FIRST item-fornec-estab NO-LOCK
             WHERE item-fornec-estab.it-codigo   = ITEM.it-codigo
               AND item-fornec-estab.cod-estabel = ITEM.cod-estabel
               AND item-fornec-estab.ativo       = YES
               AND item-fornec-estab.perc-compra > 0 NO-ERROR.
        IF NOT AVAIL item-fornec-estab THEN
           FIND FIRST item-fornec-estab NO-LOCK
                WHERE item-fornec-estab.it-codigo   = ITEM.it-codigo
                  AND item-fornec-estab.cod-estabel = ITEM.cod-estabel NO-ERROR.
           IF NOT AVAIL item-fornec-estab THEN
              FIND FIRST item-fornec-estab NO-LOCK
                   WHERE item-fornec-estab.it-codigo   = ITEM.it-codigo NO-ERROR.

        if avail item-fornec-estab then do:
            find emitente where emitente.cod-emitente = item-fornec-estab.cod-emitente no-lock.
            assign tt-item.pais = emitente.pais.
        end.
    end.
    assign de-tot-geral = 0.

    for each tt-item where tt-item.pais = "Brasil":
        find first tt-pais where tt-pais.pais = tt-item.pais no-error.
        if not avail tt-pais then do:
            create tt-pais.
            assign tt-pais.pais = "Brasil".
        end.
        assign tt-pais.valor = tt-pais.valor + 
                               (tt-item.valor * tt-item.quant-usada).
        assign de-tot-geral = de-tot-geral +                       
                               (tt-item.valor * tt-item.quant-usada).
    end.
        
    for each tt-item where tt-item.pais <> "Brasil":
        find first tt-pais where tt-pais.pais = tt-item.pais 
               and tt-pais.ncm  = tt-item.ncm no-error.
        if not avail tt-pais then do:
            create tt-pais.
            assign tt-pais.pais = tt-item.pais
                   tt-pais.ncm  = tt-item.ncm.
        end.
        assign tt-pais.valor = tt-pais.valor + 
                               (tt-item.valor * tt-item.quant-usada).
        assign de-tot-geral = de-tot-geral +                       
                               (tt-item.valor * tt-item.quant-usada).
    end.

    for each tt-pais:
        assign tt-pais.perc = tt-pais.valor / de-tot-geral * 100.
    end.

    find item where item.it-codigo = tt-param.it-codigo no-lock.    
    PUT item.it-codigo 
        item.descricao-1
        item.descricao-2 
        space(20)
        "Data: " today format "99/99/9999"
        skip(2).
            
    if tt-param.tipo = 1 then do:
       for each tt-pais:
           disp tt-pais.pais
                tt-pais.ncm
                tt-pais.valor (total)
                tt-pais.perc (total) WITH stream-io.
       end.
    end.
    else do:
       for each tt-item,
           first item no-lock where item.it-codigo = tt-item.es-codigo:
           disp tt-item.es-codigo format "X(7)"
                item.descricao-1 + item.descricao-2 format "X(36)" label "Descricao"
                tt-item.quant-usada
                tt-item.ncm
                tt-item.valor
                tt-item.pais with stream-io width 132.
       end.
    end.
 
END.
procedure pi-busca-cotacao.
    def input parameter da-data as date.

    find cotacao no-lock where cotacao.mo-codigo   = 1 
                           and cotacao.ano-periodo =
                           string(year(da-data),"9999") +
                           string(month(da-data),"99") no-error.

    if avail cotacao and 
            cotacao.cotacao[day(da-data)] <> 0 then  
       assign de-cotacao = cotacao.cotacao[day(da-data)].
    else
       assign de-cotacao = 1.

end.

PROCEDURE pi-estrutura.
    def input parameter c-it like item.it-codigo.
    def input parameter de-qtd like estrutura.quant-usada.
    
    for each estrutura no-lock
        where estrutura.it-codigo = c-it
          and estrutura.data-inicio <= today
          and estrutura.data-termino > today:
       find item where item.it-codigo = estrutura.es-codigo no-lock.
       if item.compr-fabr = 2 then do:
           run pi-estrutura(estrutura.es-codigo, de-qtd * estrutura.quant-usada).
        end.
        else do:
            find tt-item
                 where tt-item.it-codigo = tt-param.it-codigo
                   and tt-item.es-codigo = estrutura.es-codigo no-error.
            if not avail tt-item then  create tt-item.
    
            assign tt-item.it-codigo    = tt-param.it-codigo
                   tt-item.es-codigo    = estrutura.es-codigo
                   tt-item.quant-usada  = tt-item.quant-usada + estrutura.quant-usada * de-qtd.
        end.
    end.
END.
