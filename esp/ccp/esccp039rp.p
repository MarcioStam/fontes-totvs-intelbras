/******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esccp039rp 1.00.00.000}
/******************************************************************************
** Programa: esp/ccp/esccp039rp.p
** Data....: Abril/2014.
** Autor...: SENSUS Tecnologia
** Objetivo: Listagem - Alteraá‰es Pedidos de Compra.
*******************************************************************************/

{include/i-rpvar.i}    
{utp/ut-glob.i}
{esp/es0018.i}

define variable h-acomp as handle no-undo.

DEFINE STREAM st-csv.
DEFINE VARIABLE c-arquivo as character NO-UNDO.

define variable c-numero-ordem   as character format "X(9)" no-undo.
define variable c-parcela        as character format "X(5)" no-undo.

define variable c-quantidade     as character format "X(14)" no-undo. /* origem */
define variable c-preco          as character format "X(21)" no-undo. /* origem */
define variable c-data-entrega   as character format "X(10)" no-undo. /* origem */
define variable c-cod-cond-pag   as character format "X(03)" no-undo. /* origem */

define variable c-qtd-sal-forn   as character format "X(14)" no-undo. /* novo */
define variable c-pre-unit-for   as character format "X(21)" no-undo. /* novo */
define variable c-data-entrega-2 as character format "X(10)" no-undo. /* novo */
define variable c-cod-cond-pag-2 as character format "X(03)" no-undo. /* novo */

define variable c-comentarios    like ordem-compra.comentarios no-undo.

run utp/ut-acomp.p persistent set h-acomp.                            

{esp/ccp/esccp039tt.i}

DEFINE temp-table tt-raw-digita
    field raw-digita as raw.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

define temp-table tt-arquivo-csv no-undo
    field data           like alt-ped.data
    field num-pedido     like alt-ped.num-pedido
    field usuario        like alt-ped.usuario
    field cod-emitente   like emitente.cod-emitente
    field nome-emit      like emitente.nome-emit   
    field numero-nota    like recebimento.numero-nota
    field serie-nota     like recebimento.serie-nota
    field data-movto     like recebimento.data-movto
    field it-codigo      like ordem-compra.it-codigo
    field preco          like c-preco
    field pre-unit-for   like c-pre-unit-for
    field cod-cond-pag   like c-cod-cond-pag
    field cod-cond-pag-2 like c-cod-cond-pag-2
    field observacao     like alt-ped.observacao
    field comentarios    like c-comentarios.

create tt-param.
raw-transfer raw-param to tt-param.

find emscad.empresa no-lock where
     empresa.cod_empresa = V_Cod_Empres_Usuar no-error.

assign c-empresa      = empresa.nom_razao_social
       c-sistema      = "ESP":U
       c-titulo-relat = "Listagem - Alteraá‰es Pedidos de Compra":U.

{include/i-rpcab.i}
/*{include/i-rpout.i}*/
{include/i-rpout.i &pagesize="80"}
view frame f-cabec.

IF VALID-HANDLE(h-acomp) THEN run pi-inicializar in h-acomp (input c-sistema).

IF  OPSYS = "UNIX":U THEN DO:
    RUN esp/es0018p.p (INPUT  "SPOOL-UNIX":U, INPUT  1, INPUT  0, INPUT  "":U, OUTPUT TABLE tt-prog-ponto).

    FOR FIRST tt-prog-ponto:
        ASSIGN c-arquivo = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
    END. /* FOR FIRST tt-prog-ponto: */

    IF SUBSTRING(c-arquivo, LENGTH(c-arquivo), 1) <> "/":U THEN ASSIGN c-arquivo = c-arquivo + "/":U.

    ASSIGN c-arquivo = c-arquivo + TRIM(STRING(c-seg-usuario)) + "/esccp039.csv".
END. /* IF  OPSYS = "UNIX":U THEN DO: */ 
ELSE DO:
    RUN esp/es0018p.p (INPUT  "SPOOL-WIN":U, INPUT  1, INPUT  0, INPUT  "":U, OUTPUT TABLE tt-prog-ponto).

    FOR FIRST tt-prog-ponto:
        ASSIGN c-arquivo = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
    END. /* FOR FIRST tt-prog-ponto: */

    IF SUBSTRING(c-arquivo, LENGTH(c-arquivo), 1) <> "~\":U THEN ASSIGN c-arquivo = c-arquivo + "~\":U.

    ASSIGN c-arquivo = c-arquivo + TRIM(STRING(c-seg-usuario)) + "\esccp039.csv".
END. /* ELSE DO: */

OUTPUT STREAM st-csv TO VALUE(c-arquivo) NO-CONVERT.

put STREAM st-csv UNFORMATTED "DT.ALTER;PEDIDO COMPRA;USUAR.ALTER;COD.FORNEC;NOME FORNECEDOR;NF ENTRADA;SêRIE;DATA MOVTO;ITEM;VALOR ATUAL;NOVO VALOR;COD.PAGTO.ATUAL;NOVO COD.PAGTO;OBSERVAÄÂES;COMENTµRIOS":U SKIP.

EMPTY TEMP-TABLE tt-arquivo-csv NO-ERROR.

IF  tt-param.tipo-relat = 2 /* Alteraá‰es diversas */ THEN DO:
    RUN pi-busca-campos-diversas.
    RUN pi-imprime-temp-table.
END. /* IF  tt-param.tipo-relat = 2 */
ELSE DO:
    RUN pi-busca-campos-notas.
    RUN pi-imprime-temp-table.
END.

IF VALID-HANDLE(h-acomp) THEN RUN pi-finalizar IN h-acomp.


OUTPUT STREAM st-csv CLOSE.
view frame f-rodape.

FIND FIRST tt-param NO-ERROR.
IF  AVAIL tt-param THEN DO:
    
    IF  tt-param.tipo-relat = 2 /* Alteraá‰es diversas */ THEN DO:
        PUT UNFORMATTED
            "Pedido de Compra: " AT 16 
            tt-param.num-pedido-inicial TO 44 "|< >|" AT 46
            tt-param.num-pedido-final   AT 52 SKIP
            "         Periodo: " AT 16 
            tt-param.data-inicial FORMAT "99/99/9999":U TO 44 "|< >|" AT 46
            tt-param.data-final   FORMAT "99/99/9999":U AT 52 SKIP.
    END. /* IF  tt-param.tipo-relat... */
    ELSE DO:
        PUT UNFORMATTED
            "         Periodo: " AT 16 
            tt-param.data-inicial       FORMAT "99/99/9999":U TO 44 "|< >|" AT 46
            tt-param.data-final         FORMAT "99/99/9999":U AT 52 SKIP 
            "       Movimento: " AT 16 
            tt-param.data-trans-inicial FORMAT "99/99/9999":U TO 44 "|< >|" AT 46
            tt-param.data-trans-final   FORMAT "99/99/9999":U AT 52 SKIP.
    END. /* ELSE DO: */
    
    PUT UNFORMATTED SKIP(1) "Planilha gerada no caminho: " + c-arquivo AT 08 SKIP.
END. /* FOR FIRST tt-param: */

{include/i-rpclo.i}
RETURN "OK".

/*---[ PROCEDURES INTERNAS ]--------------------------------------------------------------------------*/
PROCEDURE pi-busca-campos-notas:
    FOR EACH  alt-ped NO-LOCK
        WHERE alt-ped.data >= tt-param.data-inicial
        AND   alt-ped.data <= tt-param.data-final,
        EACH  recebimento NO-LOCK
        WHERE recebimento.num-pedido   = alt-ped.num-pedido
        AND   recebimento.numero-ordem = alt-ped.numero-ordem
        AND   recebimento.parcela      = alt-ped.parcela 
        AND   recebimento.dat-trans   >= tt-param.data-trans-inicial
        AND   recebimento.dat-trans   <= tt-param.data-trans-final,
        FIRST pedido-compr NO-LOCK
        WHERE pedido-compr.num-pedido = alt-ped.num-pedido
        BREAK BY alt-ped.data:
    
        RUN pi-acompanhar IN h-acomp (INPUT "Pedido : " + STRING(alt-ped.num-pedido)).

        if  alt-ped.parcela <> 0 then 
            find prazo-compra where prazo-compra.numero-ordem = alt-ped.numero-ordem 
                              and   prazo-compra.parcela      = alt-ped.parcela no-lock no-error.
        if  alt-ped.parcela <> ? AND avail prazo-compra  then do:
    
            assign c-parcela = string(alt-ped.parcela).
            if  not alt-ped.observacao begins "#" then do:
                /* Quantidade */
                if  alt-ped.quantidade <> ? AND alt-ped.quantidade <> prazo-compra.qtd-sal-forn then do:
                    if  alt-ped.char-1 <> "" 
                    then assign c-qtd-sal-forn = string(dec(entry(2,alt-ped.char-1,"|")),">>>>,>>9.9999").
                    else assign c-qtd-sal-forn = string(prazo-compra.qtd-sal-forn,">>>>,>>9.9999").
                end.
                else assign c-qtd-sal-forn = "".
    
                /* Data Entrega */
                if  alt-ped.data-entrega <> ? AND alt-ped.data-entrega <> prazo-compra.data-entrega then do:
                    if  alt-ped.char-1 <> "" 
                    then assign c-data-entrega-2 = entry(3,alt-ped.char-1,"|").
                    else assign c-data-entrega-2 = string(prazo-compra.data-entrega,"99/99/9999").
                end.
                else assign c-data-entrega-2 = "".
             end.        
             else assign c-qtd-sal-forn   = ""
                         c-data-entrega-2 = ""
                         c-parcela        = "".
        end.
        else assign c-qtd-sal-forn   = ""
                    c-data-entrega-2 = ""
                    c-parcela        = "".
    
        assign c-comentarios = "".
        if   alt-ped.numero-ordem <> 0 then
             find ordem-compra where ordem-compra.numero-ordem = alt-ped.numero-ordem no-lock no-error.        
        if  avail ordem-compra        
        and alt-ped.numero-ordem <> 0 
        and not alt-ped.observacao begins "#" then do:

        &if  "{&bf_mat_versao_ems}" >= "2.04" &then
        &else
            assign c-comentarios = ordem-compra.comentarios.
        &endif

            /* Preco */
            if  alt-ped.preco <> 0 AND alt-ped.preco <> ? AND alt-ped.preco <> ordem-compra.pre-unit-for then do:
                if alt-ped.char-1 <> "" 
                then assign c-pre-unit-for = string(dec(entry(1,alt-ped.char-1,"|")),">>>>>,>>>,>>9.99999").
                else assign c-pre-unit-for = string(ordem-compra.pre-unit-for,">>>>>,>>>,>>9.99999").
            end.
            else assign c-pre-unit-for   = "".
    
            /* Cond. Pagamento */
            if  alt-ped.cod-cond-pag <> 0 AND alt-ped.cod-cond-pag <> ? AND alt-ped.cod-cond-pag <> ordem-compra.cod-cond-pag then do:
                if alt-ped.char-1 <> "" 
                then assign c-cod-cond-pag-2 = string(dec(entry(4,alt-ped.char-1,"|")),">>9").
                else assign c-cod-cond-pag-2 = string(ordem-compra.cod-cond-pag).
            end.
            else assign c-cod-cond-pag-2 = "".
         end.
         else assign c-pre-unit-for   = ""
                     c-cod-cond-pag-2 = "".           
    
         /* Quantidade */
         if  avail prazo-compra      
         and alt-ped.quantidade <> ? 
         and not alt-ped.observacao begins "#" 
         then assign c-quantidade   = string(alt-ped.quantidade,">>>>,>>9.9999").
         else assign c-quantidade   = "".
    
         /* Preco */
         if  alt-ped.preco <> ? 
         and alt-ped.preco <> 0 
         and not alt-ped.observacao begins "#" 
         then assign c-preco = string(alt-ped.preco,">>>>>,>>>,>>9.99999").
         else assign c-preco = "".
    
         /* Cond. Pagamento */    
         if  alt-ped.cod-cond-pag <> ? 
         and alt-ped.cod-cond-pag <> 0 
         and not alt-ped.observacao begins "#" 
         then assign c-cod-cond-pag = string(alt-ped.cod-cond-pag).
         else assign c-cod-cond-pag = "".
    
         if  alt-ped.numero-ordem <> ? 
         and alt-ped.numero-ordem <> 0 
         then assign c-numero-ordem = string(alt-ped.numero-ordem,"999999,99").
         else assign c-numero-ordem = "".
    
         if  alt-ped.parcela <> ? 
         and alt-ped.parcela <> 0 
         then assign c-parcela = string(alt-ped.parcela).
         else assign c-parcela = "".
    
         /* Data Entrega */
         if  alt-ped.data-entrega <> ? 
         and not alt-ped.observacao begins "#" 
         then assign c-data-entrega = string(alt-ped.data-entrega,"99/99/9999").
         else assign c-data-entrega = "".
    
         &if  "{&bf_mat_versao_ems}" >= "2.04" &then
             /* Montar c-comentarios */
             if  c-comentarios = "" then do:
                 if  c-pre-unit-for <> "" then do:
                     {utp/ut-liter.i Alterado(s):_Preáo_Unit†rio}
                     assign c-comentarios = trim(return-value).
                 end.
                 if  c-qtd-sal-forn <> "" then do:
                     if  c-comentarios = "" then do:
                         {utp/ut-liter.i Alterado(s):_Quantidade_Saldo}
                         assign c-comentarios = trim(return-value).
                     end.
                     else do:
                         {utp/ut-liter.i Quantidade_Saldo}
                         assign c-comentarios = c-comentarios + ", " + trim(return-value).
                     end.
                 end.
                 if  c-data-entrega-2 <> "" then do:
                     if  c-comentarios = "" then do:
                         {utp/ut-liter.i Alterado(s):_Data_Entrega}
                         assign c-comentarios = trim(return-value).
                     end.
                     else do:
                         {utp/ut-liter.i Data_Entrega}
                         assign c-comentarios = c-comentarios + ", " + trim(return-value).
                     end.
                 end.
                 if  c-cod-cond-pag-2 <> "" then do:
                     if  c-comentarios = "" then do:
                         {utp/ut-liter.i Alterado(s):_Condiá∆o_Pagamento}
                         assign c-comentarios = trim(return-value).
                     end.
                     else do:
                         {utp/ut-liter.i Condiá∆o_Pagamento}
                         assign c-comentarios = c-comentarios + ", " + trim(return-value).
                     end.
                 end.
             end.
         &else
         &endif
         
        CREATE tt-arquivo-csv.
        ASSIGN tt-arquivo-csv.data       = alt-ped.data
               tt-arquivo-csv.num-pedido = alt-ped.num-pedido
               tt-arquivo-csv.usuario    = alt-ped.usuario.

        FIND FIRST emitente NO-LOCK
            WHERE emitente.cod-emitente = pedido-compr.cod-emitente NO-ERROR.
        IF  AVAIL emitente 
        THEN ASSIGN tt-arquivo-csv.cod-emitente = emitente.cod-emitente
                    tt-arquivo-csv.nome-emit    = emitente.nome-emit.
        ELSE ASSIGN tt-arquivo-csv.cod-emitente = 0
                    tt-arquivo-csv.nome-emit    = "".
        
        
        ASSIGN tt-arquivo-csv.numero-nota = recebimento.numero-nota
                    tt-arquivo-csv.serie-nota  = recebimento.serie-nota
                    tt-arquivo-csv.data-movto  = recebimento.data-movto.
        
        if  alt-ped.numero-ordem <> 0 then do: 
            find ordem-compra where ordem-compra.numero-ordem = alt-ped.numero-ordem no-lock no-error.        
            if  avail ordem-compra
            THEN ASSIGN tt-arquivo-csv.it-codigo = ordem-compra.it-codigo.
            ELSE ASSIGN tt-arquivo-csv.it-codigo = "".
        end.
        ELSE ASSIGN tt-arquivo-csv.it-codigo = "".
        
        ASSIGN tt-arquivo-csv.preco          = c-preco
               tt-arquivo-csv.pre-unit-for   = c-pre-unit-for
               tt-arquivo-csv.cod-cond-pag   = c-cod-cond-pag
               tt-arquivo-csv.cod-cond-pag-2 = c-cod-cond-pag-2
               tt-arquivo-csv.observacao     = alt-ped.observacao
               tt-arquivo-csv.comentarios    = c-comentarios.
    END. /* FOR EACH alt-ped NO-LOCK */
END PROCEDURE. /* PROCEDURE pi-busca-campos-notas: */

PROCEDURE pi-busca-campos-diversas:
    FOR EACH  alt-ped NO-LOCK
        WHERE alt-ped.num-pedido >= tt-param.num-pedido-inicial
        AND   alt-ped.num-pedido <= tt-param.num-pedido-final
        AND   alt-ped.data       >= tt-param.data-inicial
        AND   alt-ped.data       <= tt-param.data-final,
        FIRST pedido-compr NO-LOCK
        WHERE pedido-compr.num-pedido = alt-ped.num-pedido
        BREAK BY alt-ped.data:
    
        RUN pi-acompanhar IN h-acomp (INPUT "Pedido : " + STRING(alt-ped.num-pedido)).

        if  alt-ped.parcela <> 0 then 
            find prazo-compra where prazo-compra.numero-ordem = alt-ped.numero-ordem 
                              and   prazo-compra.parcela      = alt-ped.parcela no-lock no-error.
        if  alt-ped.parcela <> ? AND avail prazo-compra  then do:
    
            assign c-parcela = string(alt-ped.parcela).
            if  not alt-ped.observacao begins "#" then do:
                /* Quantidade */
                if  alt-ped.quantidade <> ? AND alt-ped.quantidade <> prazo-compra.qtd-sal-forn then do:
                    if  alt-ped.char-1 <> "" 
                    then assign c-qtd-sal-forn = string(dec(entry(2,alt-ped.char-1,"|")),">>>>,>>9.9999").
                    else assign c-qtd-sal-forn = string(prazo-compra.qtd-sal-forn,">>>>,>>9.9999").
                end.
                else assign c-qtd-sal-forn = "".
    
                /* Data Entrega */
                if  alt-ped.data-entrega <> ? AND alt-ped.data-entrega <> prazo-compra.data-entrega then do:
                    if  alt-ped.char-1 <> "" 
                    then assign c-data-entrega-2 = entry(3,alt-ped.char-1,"|").
                    else assign c-data-entrega-2 = string(prazo-compra.data-entrega,"99/99/9999").
                end.
                else assign c-data-entrega-2 = "".
             end.        
             else assign c-qtd-sal-forn   = ""
                         c-data-entrega-2 = ""
                         c-parcela        = "".
        end.
        else assign c-qtd-sal-forn   = ""
                    c-data-entrega-2 = ""
                    c-parcela        = "".
    
        assign c-comentarios = "".
        if   alt-ped.numero-ordem <> 0 then
             find ordem-compra where ordem-compra.numero-ordem = alt-ped.numero-ordem no-lock no-error.        
        if  avail ordem-compra        
        and alt-ped.numero-ordem <> 0 
        and not alt-ped.observacao begins "#" then do:

        &if  "{&bf_mat_versao_ems}" >= "2.04" &then
        &else
            assign c-comentarios = ordem-compra.comentarios.
        &endif

            /* Preco */
            if  alt-ped.preco <> 0 AND alt-ped.preco <> ? AND alt-ped.preco <> ordem-compra.pre-unit-for then do:
                if alt-ped.char-1 <> "" 
                then assign c-pre-unit-for = string(dec(entry(1,alt-ped.char-1,"|")),">>>>>,>>>,>>9.99999").
                else assign c-pre-unit-for = string(ordem-compra.pre-unit-for,">>>>>,>>>,>>9.99999").
            end.
            else assign c-pre-unit-for   = "".
    
            /* Cond. Pagamento */
            if  alt-ped.cod-cond-pag <> 0 AND alt-ped.cod-cond-pag <> ? AND alt-ped.cod-cond-pag <> ordem-compra.cod-cond-pag then do:
                if alt-ped.char-1 <> "" 
                then assign c-cod-cond-pag-2 = string(dec(entry(4,alt-ped.char-1,"|")),">>9").
                else assign c-cod-cond-pag-2 = string(ordem-compra.cod-cond-pag).
            end.
            else assign c-cod-cond-pag-2 = "".
         end.
         else assign c-pre-unit-for   = ""
                     c-cod-cond-pag-2 = "".           
    
         /* Quantidade */
         if  avail prazo-compra      
         and alt-ped.quantidade <> ? 
         and not alt-ped.observacao begins "#" 
         then assign c-quantidade   = string(alt-ped.quantidade,">>>>,>>9.9999").
         else assign c-quantidade   = "".
    
         /* Preco */
         if  alt-ped.preco <> ? 
         and alt-ped.preco <> 0 
         and not alt-ped.observacao begins "#" 
         then assign c-preco = string(alt-ped.preco,">>>>>,>>>,>>9.99999").
         else assign c-preco = "".
    
         /* Cond. Pagamento */    
         if  alt-ped.cod-cond-pag <> ? 
         and alt-ped.cod-cond-pag <> 0 
         and not alt-ped.observacao begins "#" 
         then assign c-cod-cond-pag = string(alt-ped.cod-cond-pag).
         else assign c-cod-cond-pag = "".
    
         if  alt-ped.numero-ordem <> ? 
         and alt-ped.numero-ordem <> 0 
         then assign c-numero-ordem = string(alt-ped.numero-ordem,"999999,99").
         else assign c-numero-ordem = "".
    
         if  alt-ped.parcela <> ? 
         and alt-ped.parcela <> 0 
         then assign c-parcela = string(alt-ped.parcela).
         else assign c-parcela = "".
    
         /* Data Entrega */
         if  alt-ped.data-entrega <> ? 
         and not alt-ped.observacao begins "#" 
         then assign c-data-entrega = string(alt-ped.data-entrega,"99/99/9999").
         else assign c-data-entrega = "".
    
         &if  "{&bf_mat_versao_ems}" >= "2.04" &then
             /* Montar c-comentarios */
             if  c-comentarios = "" then do:
                 if  c-pre-unit-for <> "" then do:
                     {utp/ut-liter.i Alterado(s):_Preáo_Unit†rio}
                     assign c-comentarios = trim(return-value).
                 end.
                 if  c-qtd-sal-forn <> "" then do:
                     if  c-comentarios = "" then do:
                         {utp/ut-liter.i Alterado(s):_Quantidade_Saldo}
                         assign c-comentarios = trim(return-value).
                     end.
                     else do:
                         {utp/ut-liter.i Quantidade_Saldo}
                         assign c-comentarios = c-comentarios + ", " + trim(return-value).
                     end.
                 end.
                 if  c-data-entrega-2 <> "" then do:
                     if  c-comentarios = "" then do:
                         {utp/ut-liter.i Alterado(s):_Data_Entrega}
                         assign c-comentarios = trim(return-value).
                     end.
                     else do:
                         {utp/ut-liter.i Data_Entrega}
                         assign c-comentarios = c-comentarios + ", " + trim(return-value).
                     end.
                 end.
                 if  c-cod-cond-pag-2 <> "" then do:
                     if  c-comentarios = "" then do:
                         {utp/ut-liter.i Alterado(s):_Condiá∆o_Pagamento}
                         assign c-comentarios = trim(return-value).
                     end.
                     else do:
                         {utp/ut-liter.i Condiá∆o_Pagamento}
                         assign c-comentarios = c-comentarios + ", " + trim(return-value).
                     end.
                 end.
             end.
         &else
         &endif
         
         CREATE tt-arquivo-csv.
         ASSIGN tt-arquivo-csv.data       = alt-ped.data
                tt-arquivo-csv.num-pedido = alt-ped.num-pedido
                tt-arquivo-csv.usuario    = alt-ped.usuario.
         
         FIND FIRST emitente NO-LOCK
             WHERE emitente.cod-emitente = pedido-compr.cod-emitente NO-ERROR.
         IF  AVAIL emitente 
         THEN ASSIGN tt-arquivo-csv.cod-emitente = emitente.cod-emitente
                     tt-arquivo-csv.nome-emit    = emitente.nome-emit.
         ELSE ASSIGN tt-arquivo-csv.cod-emitente = 0
                     tt-arquivo-csv.nome-emit    = "".
         
         FIND LAST recebimento NO-LOCK
             WHERE recebimento.num-pedido   = alt-ped.num-pedido
             AND   recebimento.numero-ordem = alt-ped.numero-ordem
             AND   recebimento.parcela      = alt-ped.parcela NO-ERROR.
         IF  AVAIL recebimento 
         THEN ASSIGN tt-arquivo-csv.numero-nota = recebimento.numero-nota
                     tt-arquivo-csv.serie-nota  = recebimento.serie-nota
                     tt-arquivo-csv.data-movto  = recebimento.data-movto.
         ELSE ASSIGN tt-arquivo-csv.numero-nota = ""
                     tt-arquivo-csv.serie-nota  = ""
                     tt-arquivo-csv.data-movto  = ?.
                  
         if  alt-ped.numero-ordem <> 0 then do: 
             find ordem-compra where ordem-compra.numero-ordem = alt-ped.numero-ordem no-lock no-error.        
             if  avail ordem-compra
             THEN ASSIGN tt-arquivo-csv.it-codigo = ordem-compra.it-codigo.
             ELSE ASSIGN tt-arquivo-csv.it-codigo = "".
         end.
         ELSE ASSIGN tt-arquivo-csv.it-codigo = "".
         
         ASSIGN tt-arquivo-csv.preco          = c-preco
                tt-arquivo-csv.pre-unit-for   = c-pre-unit-for
                tt-arquivo-csv.cod-cond-pag   = c-cod-cond-pag
                tt-arquivo-csv.cod-cond-pag-2 = c-cod-cond-pag-2
                tt-arquivo-csv.observacao     = alt-ped.observacao
                tt-arquivo-csv.comentarios    = c-comentarios.
    END. /* FOR EACH alt-ped NO-LOCK */
END PROCEDURE. /* PROCEDURE pi-busca-campos-diversas: */

PROCEDURE pi-imprime-temp-table:
    FOR EACH  tt-arquivo-csv:

        RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo lista - Pedido : " + STRING(tt-arquivo-csv.num-pedido)).

        put STREAM st-csv UNFORMATTED
            tt-arquivo-csv.data FORMAT "99/99/9999":U ";"
            tt-arquivo-csv.num-pedido ";"
            tt-arquivo-csv.usuario    ";".

        IF  tt-arquivo-csv.nome-emit = "" 
        THEN put STREAM st-csv UNFORMATTED ";;".
        ELSE put STREAM st-csv UNFORMATTED string(tt-arquivo-csv.cod-emitente) ";"
                                           tt-arquivo-csv.nome-emit            ";".

        IF  tt-arquivo-csv.data-movto = ?
        THEN put STREAM st-csv UNFORMATTED ";;;".    
        ELSE put STREAM st-csv UNFORMATTED string(tt-arquivo-csv.numero-nota) ";"
                                           tt-arquivo-csv.serie-nota          ";"
                                           tt-arquivo-csv.data-movto FORMAT "99/99/9999":U ";".    

        put STREAM st-csv UNFORMATTED
            tt-arquivo-csv.it-codigo      ";"
            tt-arquivo-csv.preco          ";"
            tt-arquivo-csv.pre-unit-for   ";"
            tt-arquivo-csv.cod-cond-pag   ";"
            tt-arquivo-csv.cod-cond-pag-2 ";"
            REPLACE(REPLACE(tt-arquivo-csv.observacao, CHR(10), " "), CHR(13), " ") ";"
            REPLACE(REPLACE(tt-arquivo-csv.comentarios, CHR(10), " "), CHR(13), " ") SKIP.
    END. /* FOR EACH tt-arquivo-csv: */
    
    IF VALID-HANDLE(h-acomp) THEN RUN pi-finalizar IN h-acomp.

END PROCEDURE. /* PROCEDURE pi-imprime-temp-table: */

