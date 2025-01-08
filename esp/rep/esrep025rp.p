/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i esrep025rp 2.00.00.001}  /*** 010001 ***/

/******************************************************************************
**
**       Programa: esrep025rp
**
**       Objetivo: Listagem Ficha Inspeção
**
**       Versao..: 1.00.000
**
******************************************************************************/
{include/i_fnctrad.i}
{cdp/cd0666.i}
{cdp/cdcfgdis.i}
{utp/ut-glob.i}
{esp/rep/esrep025tt.i}

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

def var h-acomp as handle no-undo.
def var l-erro  as log    no-undo.

def var i-empresa like param-global.empresa-prin no-undo.
def var c-emitente as char no-undo.
DEF VAR dt-data AS DATE NO-UNDO.
DEF VAR l-gerado AS LOGICAL NO-UNDO.
DEF VAR c-diretorio AS CHAR NO-UNDO.

find first param-global no-lock no-error.
find first param-estoq  no-lock no-error.

{esp/es0006a.i}
{esp/es0006.i}
{include/i-rpvar.i}
run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp ("ImpressÆo Ficha Inspe‡Æo").

assign i-empresa = param-global.empresa-prin.

&if defined (bf_dis_consiste_conta) &then

    find estabelec where
         estabelec.cod-estabel = param-estoq.estabel-pad no-lock no-error.

    run cdp/cd9970.p (input rowid(estabelec),
                      output i-empresa).
&endif

find empresa where
     empresa.ep-codigo = i-empresa no-lock no-error.

create tt-param.
raw-transfer raw-param to tt-param.

assign c-empresa  = (if avail param-global then param-global.grupo else "")
        c-titulo-relat = "Ficha Inspe‡Æo"
       c-programa = "esrep025"
       c-versao   = "1.00"
       c-revisao  = "000".

def frame f-docto
    docum-est.nro-docto
    docum-est.serie-docto
    docum-est.cod-emitente
    docum-est.nat-operacao
    tt-erro.cd-erro                  column-label "Erro"
    tt-erro.mensagem format "x(77)"  column-label "Mensagem"
    with stream-io width 132 down frame f-docto.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.

    IF tt-digita.cod-depos = "" THEN
        DELETE tt-digita.
end.

run utp/ut-trfrrp.p (input frame f-docto:handle).

IF OPSYS = "UNIX" THEN
    ASSIGN c-diretorio = session:temp-directory + c-seg-usuario + "/".
ELSE
    ASSIGN c-diretorio = session:temp-directory.

{include/i-rpcab.i}

{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.

/* Leitura dos documentos */
IF tt-param.dt-trans-ini = tt-param.dt-trans-fim THEN DO:
    FOR EACH docum-est
       WHERE docum-est.dt-trans = tt-param.dt-trans-ini NO-LOCK:
        IF docum-est.ce-atual = NO THEN NEXT.
        IF docum-est.cod-estabel <> tt-param.cod-estabel-ini THEN NEXT.

        RUN pi-gera-texto.

        IF RETURN-VALUE = "NOK" THEN NEXT.

        IF tt-param.gera-html THEN
            run pi-gera-html. /* Ficha de inspe‡Æo da ASTEC */
    END.
END.
ELSE IF tt-param.cod-emitente-ini = tt-param.cod-emitente-fim THEN DO:
    FOR EACH docum-est
       WHERE docum-est.cod-emitente = tt-param.cod-emitente-ini
         AND docum-est.nro-docto    = tt-param.nro-docto-ini NO-LOCK:
        IF docum-est.ce-atual = NO THEN NEXT.
        IF docum-est.cod-estabel <> tt-param.cod-estabel-ini THEN NEXT.

        IF RETURN-VALUE = "NOK" THEN NEXT.

        RUN pi-gera-texto.
        IF tt-param.gera-html THEN
            run pi-gera-html. /* Ficha de inspe‡Æo da ASTEC */

    END.
END.
ELSE IF tt-param.serie-docto-ini = tt-param.serie-docto-fim AND
        tt-param.nro-docto-ini = tt-param.nro-docto-fim AND
        tt-param.cod-emitente-ini = tt-param.cod-emitente-fim AND
        tt-param.nat-operacao-ini  = tt-param.nat-operacao-fim THEN DO:

    FIND docum-est WHERE
         docum-est.serie-docto = tt-param.serie-docto-ini AND
         docum-est.nro-docto   = tt-param.nro-docto-ini AND
         docum-est.cod-emitente = tt-param.cod-emitente-ini AND
         docum-est.nat-operacao = tt-param.nat-operacao-ini NO-LOCK NO-ERROR.
    IF NOT AVAIL docum-est THEN NEXT.
    IF docum-est.ce-atual = NO THEN NEXT.
    IF docum-est.cod-estabel <> tt-param.cod-estabel-ini THEN NEXT.

    RUN pi-gera-texto.

    IF RETURN-VALUE = "NOK" THEN NEXT.

    IF tt-param.gera-html THEN
        run pi-gera-html. /* Ficha de inspe‡Æo da ASTEC */

END.
ELSE DO:
    DO dt-data = tt-param.dt-trans-ini TO tt-param.dt-trans-fim:
        FOR EACH docum-est
           WHERE docum-est.dt-trans = dt-data NO-LOCK:
            IF docum-est.ce-atual = NO THEN NEXT.
            IF docum-est.cod-estabel <> tt-param.cod-estabel-ini THEN NEXT.

            RUN pi-gera-texto.
            IF RETURN-VALUE = "NOK" THEN NEXT.

            IF tt-param.gera-html THEN
                run pi-gera-html. /* Ficha de inspe‡Æo da ASTEC */

        END.
    END.
END.

IF l-gerado THEN
    PUT "Arquivos html gerados em " c-diretorio FORMAT "x(100)" SKIP(2).

PUT "SELECAO"               at 1 SKIP
    "Estabelecimento"       at 8 format "x(15)"
    ":"                     at 23
    tt-param.cod-estabel-ini at 25 format "x(3)" SKIP
    "Serie"                 at 8  format "x(5)"      
    ":"                     at 23
    tt-param.serie-docto-ini      at 25  
    " |<  >|"               at 42
    tt-param.serie-docto-fim      at 52 skip
    "Documento"             at 8 format "x(9)"
    ":"                     at 23
    tt-param.nro-docto-ini      at 25 format "x(16)"
    " |<  >|"               at 42 
    tt-param.nro-docto-fim      at 52 format "x(16)" SKIP
    "Emitente "             at 8 format "x(8)"
    ":"                     at 23
    tt-param.cod-emitente-ini     at 25 format ">>>>>>>>9"
    " |<  >|"               at 42 
    tt-param.cod-emitente-fim     at 52 format ">>>>>>>>9" SKIP
    "Natureza"              at 8 format "x(8)"
    ":"                    at 23
    tt-param.nat-operacao-ini     at 25 format "x(5)"
    " |<  >|"              at 42 
    tt-param.nat-operacao-fim     at 52 format "x(5)" SKIP
    "Data Transacao"       at 8 format "x(14)"
    ":"                    at 23
    tt-param.dt-trans-ini  at 25 format "99/99/9999"
    " |<  >|"              at 42 
    tt-param.dt-trans-fim  at 52 format "99/99/9999"
    "Item"                 at 8 format "x(7)"
    ":"                    at 23
    tt-param.it-codigo-ini at 25 format "x(10)"
    " |<  >|"              at 42 
    tt-param.it-codigo-fim   at 52 format "x(10)".

run pi-finalizar in h-acomp.

{include/i-rpclo.i}

return "OK".

/* --------------------------  Procedure Interna ----------------------------- */

procedure pi-gera-texto.
    DEF VAR c-nro-comp AS CHAR NO-UNDO.
    DEF VAR c-conta-contabil AS CHAR NO-UNDO.
    DEF VAR c-nro-docto AS CHAR NO-UNDO.
    DEF VAR c-nat-operacao AS CHAR NO-UNDO.

    IF docum-est.dt-trans < tt-param.dt-trans-ini OR 
       docum-est.dt-trans > tt-param.dt-trans-fim OR
       docum-est.cod-emitente < tt-param.cod-emitente-ini OR
       docum-est.cod-emitente > tt-param.cod-emitente-fim OR
/*        docum-est.nat-operacao < tt-param.nat-operacao-ini OR  */
/*        docum-est.nat-operacao > tt-param.nat-operacao-fim OR  */
       docum-est.nro-docto < tt-param.nro-docto-ini OR
       docum-est.nro-docto > tt-param.nro-docto-fim OR
       docum-est.serie-docto < tt-param.serie-docto-ini OR
       docum-est.serie-docto > tt-param.serie-docto-fim THEN RETURN "NOK".

    run pi-acompanhar in h-acomp (INPUT "Documento " + docum-est.nro-docto).

    FIND FIRST item-doc-est OF docum-est NO-LOCK NO-ERROR.
    IF NOT AVAIL item-doc-est THEN NEXT.

    IF tt-param.it-codigo-ini <> "" THEN DO:
        FIND FIRST item-doc-est OF docum-est NO-LOCK
             WHERE item-doc-est.it-codigo >= tt-param.it-codigo-ini
               AND item-doc-est.it-codigo <= tt-param.it-codigo-fim NO-ERROR.
        IF NOT AVAIL item-doc-est THEN NEXT.
    END.

    FIND FIRST item-doc-est OF docum-est NO-LOCK
        WHERE  item-doc-est.it-codigo >= tt-param.it-codigo-ini
           AND item-doc-est.it-codigo <= tt-param.it-codigo-fim
           AND item-doc-est.nat-of    >= tt-param.nat-operacao-ini 
           AND item-doc-est.nat-of    <= tt-param.nat-operacao-fim NO-ERROR.
    IF NOT AVAIL item-doc-est THEN NEXT.

    FIND FIRST tt-digita
         WHERE tt-digita.cod-depos = item-doc-est.cod-depos NO-ERROR.
    IF NOT AVAIL tt-digita THEN NEXT.

    FIND natur-oper WHERE
         natur-oper.nat-operacao = docum-est.nat-operacao NO-LOCK NO-ERROR.
    IF NOT AVAIL natur-oper THEN NEXT.

    FIND emitente WHERE
         emitente.cod-emitente = docum-est.cod-emitente NO-LOCK NO-ERROR.
    if avail emitente then
        assign c-emitente = string(docum-est.cod-emitente) + " - " + emitente.nome-emit.

    IF AVAIL item-doc-est THEN DO:
        if item-doc-est.nro-comp <> "" then
            assign c-nro-comp = item-doc-est.nro-comp.

        FOR first movto-estoq
            where movto-estoq.serie-docto  = item-doc-est.serie-docto
              and movto-estoq.nro-docto    = item-doc-est.nro-docto
              and movto-estoq.cod-emitente = item-doc-est.cod-emitente
              and movto-estoq.nat-operacao = item-doc-est.nat-operacao
              and movto-estoq.it-codigo    = item-doc-est.it-codigo
              and movto-estoq.sequen-nf    = item-doc-est.sequencia NO-LOCK:
            if movto-estoq.tipo-trans = 1 then do:
                assign c-conta-contabil = movto-estoq.ct-codigo + movto-estoq.sc-codigo.
            end.
        end.        
    end.            

    assign c-nro-docto = c-nro-comp + "  NFE: " + docum-est.nro-docto.

    PUT SKIP(1)
        "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "Emitente: " docum-est.cod-emitente " - " emitente.nome-emit SKIP
        "Documento: " c-nro-docto FORMAT "x(20)" " S‚rie: " docum-est.serie-docto SKIP
        "CFOP: " docum-est.nat-operacao " - " natur-oper.denominacao " Conta Cont bil: " c-conta-contabil FORMAT "x(20)" SKIP
        "Vlr Total NF: " docum-est.tot-valor " - Data Transa‡Æo: " docum-est.dt-trans SKIP(2).

    PUT "Item" AT 1
        "Descri‡Æo" AT 17
        "Dep" AT 57
        "Quantidade" AT 64
        "Vlr Unitario" AT 79
        "Vlr Total" AT 97
        "% ICMS" AT 107
        "Vlr ICMS" AT 119
        "% IPI" AT 128
        "Vlr IPI" AT 141 SKIP.
    PUT "---------------------------------------------------------------------------------------------------------------------------------------------------" SKIP(1).

    for each item-doc-est of docum-est no-lock
       WHERE item-doc-est.it-codigo >= tt-param.it-codigo-ini
         AND item-doc-est.it-codigo <= tt-param.it-codigo-fim
         AND item-doc-est.nat-of    >= tt-param.nat-operacao-ini  
         AND item-doc-est.nat-of    <= tt-param.nat-operacao-fim :
        
        /*FOR EACH movto-estoq
             where movto-estoq.serie-docto  = item-doc-est.serie-docto
               and movto-estoq.nro-docto    = item-doc-est.nro-docto
               and movto-estoq.cod-emitente = item-doc-est.cod-emitente
               and movto-estoq.nat-operacao = item-doc-est.nat-operacao
               and movto-estoq.it-codigo    = item-doc-est.it-codigo
               and movto-estoq.sequen-nf    = item-doc-est.sequencia NO-LOCK:
            if movto-estoq.tipo-trans = 1 then do:*/
                find item where
                     item.it-codigo = item-doc-est.it-codigo /*movto-estoq.it-codigo*/ no-lock no-error.
                PUT item-doc-est.it-codigo FORMAT "x(16)" 
                    substring(item.desc-item,1,40) FORMAT "x(40)"
                    item-doc-est.cod-depos
                    item-doc-est.quantidade
                    item-doc-est.preco-unit[1]
                    item-doc-est.preco-total[1]
                    item-doc-est.aliquota-icm
                    item-doc-est.valor-icm[1]
                    item-doc-est.aliquota-ipi
                    item-doc-est.valor-ipi[1] SKIP.
       /*     end.
        end.        */
    end.
    RETURN "ok".
end procedure.


procedure pi-gera-html.
    DEF VAR c-nro-comp AS CHAR NO-UNDO.
    DEF VAR c-conta-contabil AS CHAR NO-UNDO.
    DEF VAR c-nro-docto AS CHAR NO-UNDO.
    DEF VAR c-nat-operacao AS CHAR NO-UNDO.
    DEF VAR c-serie AS CHAR NO-UNDO.

    run pi-acompanhar in h-acomp (INPUT "Gerando html " + docum-est.nro-docto).

    FIND FIRST item-doc-est OF docum-est NO-LOCK NO-ERROR.
    IF NOT AVAIL item-doc-est THEN NEXT.

    IF tt-param.it-codigo-ini <> "" THEN DO:
        FIND FIRST item-doc-est OF docum-est NO-LOCK
             WHERE item-doc-est.it-codigo >= tt-param.it-codigo-ini
               AND item-doc-est.it-codigo <= tt-param.it-codigo-fim NO-ERROR.
        IF NOT AVAIL item-doc-est THEN NEXT.
    END.

    FIND FIRST item-doc-est OF docum-est NO-LOCK
         WHERE item-doc-est.it-codigo >= tt-param.it-codigo-ini
           AND item-doc-est.it-codigo <= tt-param.it-codigo-fim 
           AND item-doc-est.nat-of    >= tt-param.nat-operacao-ini 
           AND item-doc-est.nat-of    <= tt-param.nat-operacao-fim NO-ERROR.
    IF NOT AVAIL item-doc-est THEN NEXT.

    FIND FIRST tt-digita
         WHERE tt-digita.cod-depos = item-doc-est.cod-depos NO-ERROR.
    IF NOT AVAIL tt-digita THEN NEXT.

    ASSIGN l-gerado = YES.

    assign c-arquivo = c-diretorio + "re1005_" + trim(docum-est.nro-docto) + ".html".

    output to value(c-arquivo) CONVERT TARGET SESSION:CHARSET.

    run html-inicio("Ficha de Inspe‡Æo Fiscal").                                
    run html-titulo("Ficha de Inspe‡Æo Fiscal").
    run html-ini-tab.
    run html-ini-lin-tab.

    run html-cab-tab("Emitente").
    if avail emitente then
        assign c-emitente = string(docum-est.cod-emitente) + " - " + emitente.nome-emit.

    run html-con-tab-colspan(c-emitente, "left", 3).
    run html-fim-lin-tab.

    run html-ini-lin-tab.    
    run html-cab-tab("Documento").

    IF AVAIL item-doc-est THEN DO:
        if item-doc-est.nro-comp <> "" then
            assign c-nro-comp = item-doc-est.nro-comp.

        FOR first movto-estoq
            where movto-estoq.serie-docto  = item-doc-est.serie-docto
              and movto-estoq.nro-docto    = item-doc-est.nro-docto
              and movto-estoq.cod-emitente = item-doc-est.cod-emitente
              and movto-estoq.nat-operacao = item-doc-est.nat-operacao
              and movto-estoq.it-codigo    = item-doc-est.it-codigo
              and movto-estoq.sequen-nf    = item-doc-est.sequencia NO-LOCK:
            if movto-estoq.tipo-trans = 1 then do:
                assign c-conta-contabil = movto-estoq.ct-codigo + movto-estoq.sc-codigo.
            end.
        end.        
    end.            

    assign c-nro-docto = c-nro-comp + "  NFE: " + docum-est.nro-docto.

    run html-con-tab(c-nro-docto, "left").    
    run html-cab-tab("S‚rie").
    run html-con-tab(docum-est.serie-docto, "left").
    run html-fim-lin-tab.

    run html-ini-lin-tab.            
    run html-cab-tab("CFOP").        

    if avail natur-oper then
        assign c-nat-operacao = docum-est.nat-operacao + " - " + natur-oper.denominacao.

    run html-con-tab(c-nat-operacao, "left").        
    run html-cab-tab("Conta Cont bil").
    run html-con-tab(c-conta-contabil, "left").    

    run html-ini-lin-tab.            
    run html-cab-tab("Vlr Total NF").        
    RUN html-con-tab(string(docum-est.tot-valor,">>>>>,>>9.99"), "left").        
    run html-cab-tab("Data Transa‡Æo").
    run html-con-tab(string(docum-est.dt-trans,"99/99/9999"), "left").  

    run html-fim-lin-tab.    
    run html-fim-tab.    

    run html-ini-tab.
    run html-ini-lin-tab.
    run html-cab-tab("Item").
    run html-cab-tab("Descri‡Æo").
    run html-cab-tab("Dep").
    run html-cab-tab("Quantidade").
    run html-cab-tab("Vlr Unitario").    
    run html-cab-tab("Vlr Total").
    run html-cab-tab("% ICMS").
    run html-cab-tab("Vlr ICMS").        
    run html-cab-tab("% IPI").        
    run html-cab-tab("Vlr IPI").        
    run html-fim-lin-tab.

    for each item-doc-est of docum-est no-lock
       WHERE item-doc-est.it-codigo >= tt-param.it-codigo-ini
         AND item-doc-est.it-codigo <= tt-param.it-codigo-fim
         AND item-doc-est.nat-of    >= tt-param.nat-operacao-ini
         AND item-doc-est.nat-of    <= tt-param.nat-operacao-fim:
        /*FOR EACH movto-estoq
             where movto-estoq.serie-docto  = item-doc-est.serie-docto
               and movto-estoq.nro-docto    = item-doc-est.nro-docto
               and movto-estoq.cod-emitente = item-doc-est.cod-emitente
               and movto-estoq.nat-operacao = item-doc-est.nat-operacao
               and movto-estoq.it-codigo    = item-doc-est.it-codigo
               and movto-estoq.sequen-nf    = item-doc-est.sequencia NO-LOCK:
            if movto-estoq.tipo-trans = 1 then do:*/
                run html-ini-lin-tab.
                run html-con-tab(item-doc-est.it-codigo, "left").

                find item where
                     item.it-codigo = item-doc-est.it-codigo /*movto-estoq.it-codigo*/  no-lock no-error.

                run html-con-tab(substring(item.desc-item,1,40), "left").
                run html-con-tab(item-doc-est.cod-depos, "center").    
                run html-con-tab(string(item-doc-est.quantidade,">>>>>,>>9.9999"), "right").        
                run html-con-tab(string(item-doc-est.preco-unit[1],">>>>>,>>9.99"), "right").        
                run html-con-tab(string(item-doc-est.preco-total[1],">>>>>,>>9.99"), "right").
                run html-con-tab(string(item-doc-est.aliquota-icm,">>9.99"), "right").
                run html-con-tab(string(item-doc-est.valor-icm[1],">>>,>>9.99"), "right").
                run html-con-tab(string(item-doc-est.aliquota-ipi,">>9.99"), "right").
                run html-con-tab(string(item-doc-est.valor-ipi[1],">>>,>>9.99"), "right").
                run html-fim-lin-tab.                
            /*end.
        end.      */  
    end.    
    run html-fim-tab.
    output close.
end procedure.


procedure pi-lista-erros:

    disp docum-est.nro-docto
        docum-est.serie-docto
        docum-est.cod-emitente
        docum-est.nat-operacao
        with frame f-docto.

    for each tt-erro:
        disp tt-erro.cd-erro
             tt-erro.mensagem with frame f-docto.
        down with frame f-docto.
        delete tt-erro.
    end.

    down with frame f-docto.
    put " " skip.

end.


