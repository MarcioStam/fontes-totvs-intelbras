/***********************************************************************
**  Programa..: ESP\CSP\ESREP039RP.P
************************************************************************/
{include/i-prgvrs.i ESREP039RP 2.04.00.000}

/****************************  Definitions  ****************************/
{esp/rep/esREP039tt.i}
{esp/es0018.i}
{include/i-rpvar.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

def var h-acomp      as handle no-undo.

DEF NEW GLOBAL SHARED VAR c-seg-usuario AS CHAR NO-UNDO.

DEFINE VARIABLE dt-data AS DATE  NO-UNDO.
DEFINE VARIABLE c-arquivo-item AS CHAR NO-UNDO.
DEFINE VARIABLE c-arquivo-nota AS CHAR NO-UNDO.
DEFINE VARIABLE c-destino AS CHAR FORMAT "x(10)" NO-UNDO.
DEFINE VARIABLE c-tipo    AS CHAR FORMAT "x(60)" NO-UNDO.
DEFINE VARIABLE de-tot-nota LIKE item-doc-est.preco-total[1] NO-UNDO.
                                          
DEFINE STREAM s1.
DEFINE STREAM s2.

DEF TEMP-TABLE tt-parcela
    FIELD cod-emitente like docum-est.cod-emitente 
    FIELD nro-docto    like docum-est.nro-docto    
    FIELD serie-docto  like docum-est.serie-docto  
    FIELD nat-operacao like docum-est.nat-operacao 
    FIELD parcela    AS CHAR
    FIELD dt-vencto  AS DATE
    FIELD valor      LIKE dupli-apagar.vl-a-pagar.

DEF TEMP-TABLE tt-docto
    FIELD dt-trans                 LIKE docum-est.dt-trans
    FIELD dt-emissao               LIKE docum-est.dt-emissao
    FIELD nat-operacao             LIKE docum-est.nat-operacao
    FIELD serie-docto              LIKE docum-est.serie-docto
    FIELD nro-docto                LIKE docum-est.nro-docto
    FIELD cod-estabel              LIKE docum-est.cod-estabel
    FIELD cod-emitente             LIKE docum-est.cod-emitente
    FIELD nome-emit                AS CHAR FORMAT "x(60)"
    FIELD unid-neg                 AS CHAR FORMAT "x(8)"
    FIELD descricao-unid-neg       AS CHAR FORMAT "x(40)" 
    FIELD valor-nota               LIKE item-doc-est.preco-total[1]
    FIELD prazo-medio-vencto       LIKE dupli-apagar.vl-a-pagar
    FIELD media-ponderada-vencto   LIKE dupli-apagar.vl-a-pagar.


find mgcad.empresa
    where empresa.ep-codigo = "1" no-lock no-error.

find first param-global no-lock no-error.

{utp/ut-liter.i Espec°ficos Intelbras * }
assign c-sistema = return-value.
{utp/ut-liter.i Relat¢rio de Compras - Condiá∆o de pagamento * }

assign c-titulo-relat = RETURN-VALUE.
assign c-empresa     = param-global.grupo
       c-programa    = "esrep039":U
       c-versao      = "1.00":U
       c-revisao     = "000"
       c-destino     = {varinc/var00002.i 04 tt-param.destino}.

form
/*form-selecao-ini*/
    skip(1)
    "                                                    SELEÄ«O"         
    skip(1) 
    /*form-selecao-usuario*/
    tt-param.cod-estabel-ini colon 41 label "Estab" 
    "<|   |>" at 53 tt-param.cod-estabel-fim no-label skip
    tt-param.data-ini colon 41 label "Data" 
    "<|   |>" at 53 tt-param.data-fim no-label skip
    skip(1)
    "                                                   PAR∂METRO"                                                       
    skip(1) 

    skip(1)
    "                                                    ARQUIVO"         
    skip(1)
    "Caminho arquivo Itens '.CSV' em: " at 26  c-arquivo-item NO-LABEL FORMAT "x(80)" SKIP
    "            Caminho arquivo Notas e Duplicatas '.CSV' em: " at 1 c-arquivo-nota NO-LABEL FORMAT "x(80)"
    skip(1) 
    "                                                   IMPRESS«O"
    skip(1) 
    c-destino           label "Destino" colon 41 "-"
    tt-param.arquivo    no-label
    tt-param.usuario    label "Usu†rio" colon 41
    skip(1)
/*form-impressao-fim*/
    with stream-io side-labels no-attr-space no-box width 200 frame f-impressao.

/* ***************************  Main Block  *************************** */
{include/i-rpcab.i}
{include/i-rpout.i} 

view frame f-cabec.
view frame f-rodape.    
run utp/ut-acomp.p persistent set h-acomp.  

run pi-inicializar in h-acomp (input "Imprimindo":U). 

IF  OPSYS = "UNIX" THEN 
    ASSIGN c-arquivo-item = c-dir-arquivo-session + c-seg-usuario + "/" + "ESREP039_ITEM_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv"
           c-arquivo-nota = c-dir-arquivo-session + c-seg-usuario + "/" + "ESREP039_NOTA_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".
           
ELSE                                                                                   
    ASSIGN c-arquivo-nota = SESSION:TEMP-DIRECTORY + "ESREP039_NOTA_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv"
           c-arquivo-item = SESSION:TEMP-DIRECTORY + "ESREP039_ITEM_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".

CASE tt-param.rs-tipo:
    WHEN 1 THEN DO:
        ASSIGN c-arquivo-nota = ""
               c-tipo = "Item".
        RUN piImprimeRelat-ITEM.
    END.
    WHEN 2 THEN DO:
        ASSIGN c-arquivo-item = ""
               c-tipo = "Nota e Duplicata".
        RUN piImprimeRelat-NOTA.
    END.
    WHEN 3 THEN DO:
        ASSIGN c-tipo = "Ambos".
        RUN piImprimeRelat-ITEM.
        RUN piImprimeRelat-NOTA.
    END.
END CASE.



disp tt-param.cod-estabel-ini
    tt-param.cod-estabel-fim
    tt-param.data-ini 
    tt-param.data-fim 
    c-arquivo-item
    c-arquivo-nota
    c-destino           
    tt-param.arquivo    
    tt-param.usuario 
    with frame f-impressao.   

run pi-finalizar in h-acomp.
{include/i-rpclo.i}

RETURN "OK".

/*****************************************************************************************
**
** PROCEDURES INTERNAS
**
*****************************************************************************************/
PROCEDURE piImprimeRelat-ITEM:
    DEFINE VARIABLE c-unid-neg      AS CHAR  FORMAT "!!!!"         NO-UNDO.
    DEFINE VARIABLE c-desc-unid-neg AS CHAR                        NO-UNDO.
    DEFINE VARIABLE i-num-pedido    AS INTEGER                     NO-UNDO.
    DEFINE VARIABLE i-ordem         AS INTEGER                     NO-UNDO.
    DEFINE VARIABLE i-parcela       AS INTEGER                     NO-UNDO.
    DEFINE VARIABLE i-cond-pagto    AS INTEGER                     NO-UNDO.
    DEFINE VARIABLE c-desc-cond-pag AS CHAR                        NO-UNDO.
    DEFINE VARIABLE c-cod-comprado  AS CHAR                        NO-UNDO.
    DEFINE VARIABLE de-pre-unit-for LIKE ordem-compra.pre-unit-for NO-UNDO.
    
    OUTPUT STREAM s1 TO VALUE(c-arquivo-item) CONVERT TARGET "iso8859-1".

    FIND FIRST tt-param.

    PUT stream s1 "DT.Trans;DT.Emiss∆o;SÇr;N£mero;Est;Emitente;Nome;Un Neg.;Desc.Unid.Neg;Item;Descriá∆o;Qtde Fornec;Un Med Fornec;Preáo Unit Fornec;Qtde Nossa;Un Med Nossa;Vlr Mercad;Total;Comprador da Ordem;Pedido;Ordem;Parcela;Cod.Cond.Pagto;Descriá∆o;Usu†rio;" SKIP.

    FOR EACH docum-est no-lock  
       WHERE docum-est.cod-estabel >= tt-param.cod-estabel-ini
         AND docum-est.cod-estabel <= tt-param.cod-estabel-fim
         AND docum-est.dt-trans    >= tt-param.data-ini
         AND docum-est.dt-trans    <= tt-param.data-fim
       , FIRST natur-oper NO-LOCK 
            WHERE natur-oper.nat-operacao = docum-est.nat-operacao
              AND natur-oper.emite-duplic 
       , FIRST emitente NO-LOCK 
            WHERE emitente.cod-emitente = docum-est.cod-emitente
       , EACH item-doc-est of docum-est NO-LOCK 
       , FIRST item no-lock
            WHERE item.it-codigo = item-doc-est.it-codigo:

        RUN pi-acompanhar IN h-acomp ("Data: " + STRING(docum-est.dt-trans,"99/99/99") + " - NF: " + trim(docum-est.nro-docto) + " - Item: " + TRIM(item-doc-est.it-codigo)).

        FIND FIRST item-uni-estab
            WHERE item-uni-estab.it-codigo   = item-doc-est.it-codigo
              AND item-uni-estab.cod-estabel = docum-est.cod-estabel NO-LOCK NO-ERROR.
        
        IF  AVAILABLE item-uni-estab THEN DO:
            ASSIGN c-unid-neg = item-uni-estab.cod-unid-negoc.
            RUN esp/rep/esrep007rp-uneg-ems5.p (INPUT  c-unid-neg,
                                                OUTPUT c-desc-unid-neg).
        END.
        ELSE
            ASSIGN c-unid-neg      = ""
                   c-desc-unid-neg = "".

       FIND item-fornec NO-LOCK
           WHERE item-fornec.cod-emitente = emitente.cod-emitente
             AND item-fornec.it-codigo    = ITEM.it-codigo NO-ERROR.
        
       /* OREDEM DE COMPRA */
       ASSIGN i-ordem         = item-doc-est.numero-ordem
              i-num-pedido    = item-doc-est.num-pedido
              i-parcela       = item-doc-est.parcela
              i-cond-pagto    = ?
              c-desc-cond-pag = ""
              de-pre-unit-for = 0
              i-parcela       = item-doc-est.parcela
              c-cod-comprado  = "".
              
       FOR FIRST ordem-compra NO-LOCK
            WHERE ordem-compra.numero-ordem = item-doc-est.numero-ordem:
               FIND FIRST cond-pagto NO-LOCK
                    WHERE cond-pagto.cod-cond-pag = ordem-compra.cod-cond-pag NO-ERROR.
               ASSIGN i-cond-pagto    = ordem-compra.cod-cond-pag
                      c-desc-cond-pag = IF AVAIL cond-pagto THEN cond-pagto.descricao ELSE ""
                      de-pre-unit-for = /* ordem-compra.pre-unit-for */ ordem-compra.preco-forn
                      c-cod-comprado  = ordem-compra.cod-comprado.
       END.

       /* Se os dados do pedido est∆o em branco tenta buscar do FIFO */
       IF  item-doc-est.num-pedido = 0 THEN DO:
           FOR FIRST rat-ordem OF item-doc-est NO-LOCK:
               ASSIGN i-ordem      = rat-ordem.numero-ordem
                      i-num-pedido = rat-ordem.num-pedido       
                      i-parcela    = rat-ordem.parcela.

               FOR FIRST ordem-compra NO-LOCK
                    WHERE ordem-compra.numero-ordem =  rat-ordem.numero-ordem:

                   FIND FIRST cond-pagto NO-LOCK
                        WHERE cond-pagto.cod-cond-pag = ordem-compra.cod-cond-pag NO-ERROR.
                   ASSIGN i-cond-pagto    = ordem-compra.cod-cond-pag
                          c-desc-cond-pag = IF AVAIL cond-pagto THEN cond-pagto.descricao ELSE ""
                          de-pre-unit-for = /*ordem-compra.pre-unit-for*/ ordem-compra.preco-forn
                          c-cod-comprado  = ordem-compra.cod-comprado.
               END.
           END.
       END.

       IF  i-num-pedido = 0 THEN
           NEXT.

       PUT STREAM s1 UNFORMATTED docum-est.dt-trans          ";"
                                 docum-est.dt-emissao        ";"
                                 docum-est.serie-docto       ";"
                                 docum-est.nro-docto         ";"
                                 docum-est.cod-estabel       ";"
                                 docum-est.cod-emitente      ";"
                                 emitente.nome-emit          ";"
                                 c-unid-neg  FORMAT "!!!!"   ";" 
                                 c-desc-unid-neg             ";" 
                                 item.it-codigo              ";"
                                 ITEM.desc-item              ";"
                                 item-doc-est.qt-do-forn     ";"
                                 (IF  AVAIL item-fornec THEN item-fornec.unid-med-for ELSE "")   ";"
                                 de-pre-unit-for             ";"
                                 item-doc-est.quantidade     ";"
                                 item-doc-est.un             ";"   
                                 item-doc-est.preco-unit[1]  ";"
                                 item-doc-est.preco-total[1] ";"
                                 c-cod-comprado              ";"
                                 i-num-pedido                ";"
                                 i-ordem                     ";"
                                 i-parcela                   ";"
                                 i-cond-pagto                ";"
                                 c-desc-cond-pag             ";"  
                                 docum-est.usuario           ";"
             SKIP.

    END. 

    OUTPUT STREAM s1 CLOSE.

END PROCEDURE.



PROCEDURE piImprimeRelat-NOTA:
    DEFINE VARIABLE c-unid-neg      AS CHAR   FORMAT "!!!!"        NO-UNDO.
    DEFINE VARIABLE c-desc-unid-neg AS CHAR                        NO-UNDO.
    DEFINE VARIABLE i-num-pedido    AS INTEGER                     NO-UNDO.
    DEFINE VARIABLE i-ordem         AS INTEGER                     NO-UNDO.
    DEFINE VARIABLE i-parcela       AS INTEGER                     NO-UNDO.
    DEFINE VARIABLE i-cond-pagto    AS INTEGER                     NO-UNDO.
    DEFINE VARIABLE c-desc-cond-pag AS CHAR                        NO-UNDO.
    DEFINE VARIABLE c-cod-comprado  AS CHAR                        NO-UNDO.
    DEFINE VARIABLE de-pre-unit-for LIKE ordem-compra.pre-unit-for NO-UNDO.
    DEFINE VARIABLE de-total        LIKE dupli-apagar.vl-a-pagar   NO-UNDO.
    DEFINE VARIABLE de-ponderada    LIKE dupli-apagar.vl-a-pagar   NO-UNDO.
    DEFINE VARIABLE de-prazo-medio  LIKE dupli-apagar.vl-a-pagar   NO-UNDO.
    DEFINE VARIABLE i-parcelas      AS INTEGER                     NO-UNDO.
    DEFINE VARIABLE i-max-parcelas  AS INTEGER                     NO-UNDO.
    DEFINE VARIABLE i               AS INTEGER                     NO-UNDO.
    DEFINE VARIABLE c-label-venctos AS CHAR FORMAT "x(5000)"       NO-UNDO.

    OUTPUT STREAM s2 TO VALUE(c-arquivo-nota) CONVERT TARGET "iso8859-1".

    FIND FIRST tt-param.

    FOR EACH docum-est no-lock  
       WHERE docum-est.cod-estabel >= tt-param.cod-estabel-ini
         AND docum-est.cod-estabel <= tt-param.cod-estabel-fim
         AND docum-est.dt-trans    >= tt-param.data-ini
         AND docum-est.dt-trans    <= tt-param.data-fim
       , FIRST natur-oper NO-LOCK 
            WHERE natur-oper.nat-operacao = docum-est.nat-operacao
              AND natur-oper.emite-duplic 
       , FIRST emitente NO-LOCK 
            WHERE emitente.cod-emitente = docum-est.cod-emitente
       , EACH item-doc-est of docum-est NO-LOCK 
       , FIRST item no-lock
            WHERE item.it-codigo = item-doc-est.it-codigo
        BREAK BY docum-est.cod-emitente
              BY docum-est.nat-operacao
              BY docum-est.cod-emitente
              BY docum-est.nro-docto:

        RUN pi-acompanhar IN h-acomp ("Data: " + STRING(docum-est.dt-trans,"99/99/99") + " - NF: " + trim(docum-est.nro-docto) + " - Item: " + TRIM(item-doc-est.it-codigo)).

        IF  FIRST-OF (docum-est.nro-docto) THEN DO:
            ASSIGN c-unid-neg      = ""
                   c-desc-unid-neg = ""
                   i-num-pedido    = 0
                   i-parcelas      = 0 
                   de-total        = 0 
                   de-ponderada    = 0
                   de-prazo-medio  = 0
                   de-tot-nota     = 0.
        END.

        ASSIGN de-tot-nota = de-tot-nota + item-doc-est.preco-total[1].

        FIND FIRST item-uni-estab
            WHERE item-uni-estab.it-codigo   = item-doc-est.it-codigo
              AND item-uni-estab.cod-estabel = docum-est.cod-estabel NO-LOCK NO-ERROR.
        
        IF  AVAILABLE item-uni-estab THEN DO:
            ASSIGN c-unid-neg = item-uni-estab.cod-unid-negoc.
            RUN esp/rep/esrep007rp-uneg-ems5.p (INPUT  c-unid-neg,
                                                OUTPUT c-desc-unid-neg).
        END.

       IF  i-num-pedido = 0 THEN
           ASSIGN i-num-pedido    = item-doc-est.num-pedido.

       /* Se os dados do pedido est∆o em branco tenta buscar do FIFO */
       IF  i-num-pedido = 0 THEN DO:
           FOR FIRST rat-ordem OF item-doc-est NO-LOCK:
               ASSIGN i-num-pedido = rat-ordem.num-pedido.
           END.
       END.

       IF  LAST-OF (docum-est.nro-docto) THEN DO:
           IF  i-num-pedido = 0 THEN
               NEXT.
    
           FOR EACH dupli-apagar NO-LOCK
               WHERE dupli-apagar.cod-emitente  = docum-est.cod-emitente
                 AND dupli-apagar.nro-docto     = docum-est.nro-docto
                 AND dupli-apagar.serie-docto   = docum-est.serie-docto
                 AND dupli-apagar.nat-operacao  = docum-est.nat-operacao:
    
               CREATE tt-parcela.
               ASSIGN tt-parcela.cod-emitente = docum-est.cod-emitente 
                      tt-parcela.nro-docto    = docum-est.nro-docto    
                      tt-parcela.serie-docto  = docum-est.serie-docto  
                      tt-parcela.nat-operacao = docum-est.nat-operacao
                      tt-parcela.parcela      = dupli-apagar.parcela
                      tt-parcela.dt-vencto    = dupli-apagar.dt-vencim
                      tt-parcela.valor        = dupli-apagar.vl-a-pagar.
    
               ASSIGN i-parcelas      = i-parcelas     + 1
                      de-total        = de-total       +  dupli-apagar.vl-a-pagar
                      de-ponderada    = de-ponderada   + (dupli-apagar.vl-a-pagar * (dupli-apagar.dt-vencim - docum-est.dt-emissao))
                      de-prazo-medio  = de-prazo-medio + (dupli-apagar.dt-vencim - docum-est.dt-emissao).
                      
                IF  i-parcelas > i-max-parcelas  THEN
                    ASSIGN i-max-parcelas = i-parcelas.
           END.
    
           ASSIGN de-prazo-medio = de-prazo-medio / i-parcelas
                  de-ponderada   = de-ponderada / de-total.
    
           CREATE tt-docto.
           ASSIGN tt-docto.dt-trans               = docum-est.dt-trans    
                  tt-docto.dt-emissao             = docum-est.dt-emissao 
                  tt-docto.nat-operacao           = docum-est.nat-operacao
                  tt-docto.serie-docto            = docum-est.serie-docto 
                  tt-docto.nro-docto              = docum-est.nro-docto   
                  tt-docto.cod-estabel            = docum-est.cod-estabel 
                  tt-docto.cod-emitente           = docum-est.cod-emitente
                  tt-docto.nome-emit              = emitente.nome-emit
                  tt-docto.unid-neg               = c-unid-neg
                  tt-docto.descricao-unid-neg     = c-desc-unid-neg
                  tt-docto.valor-nota             = de-tot-nota
                  tt-docto.prazo-medio-vencto     = de-prazo-medio
                  tt-docto.media-ponderada-vencto = de-ponderada.
       END.
    END. 


    /* IMPRESSÄ«O NOTAS / PARCELAS */
    ASSIGN c-label-venctos = "DT.Trans;DT.Emiss∆o;Nat Operaá∆o;SÇr;N£mero;Est;Emitente;Nome;Un Neg.;Desc.Unid.Neg;Valor Nota;Prazo MÇdio Vencto;MÇdia Ponderada Vencto".

    DEF VAR c-label-parc AS CHAR FORMAT "x(2)" NO-UNDO.
    DO  i = 1 TO i-max-parcelas:
        ASSIGN c-label-parc = c-label-parc + ";Dt Vencto " + STRING(i,"99") + "; Vl Vencto " + STRING(i,"99").       
    END.

    ASSIGN c-label-venctos = c-label-venctos + TRIM(c-label-parc).

    PUT STREAM s2 UNFORMATTED trim(c-label-venctos) SKIP.

    FOR EACH tt-docto
        BY tt-docto.dt-trans
        BY tt-docto.dt-emissao
        BY tt-docto.serie-docto 
        BY tt-docto.nro-docto:
                                                                   
        PUT STREAM s2 UNFORMATTED tt-docto.dt-trans                       ";"
                                  tt-docto.dt-emissao                     ";"
                                  tt-docto.nat-operacao                   ";"
                                  tt-docto.serie-docto                    ";"
                                  tt-docto.nro-docto                      ";"
                                  tt-docto.cod-estabel                    ";"
                                  tt-docto.cod-emitente                   ";"
                                  tt-docto.nome-emit                      ";"
                                  tt-docto.unid-neg        FORMAT "!!!!"  ";" 
                                  tt-docto.descricao-unid-neg             ";"
                                  tt-docto.valor-nota                     ";"
                                  tt-docto.prazo-medio-vencto             ";"
                                  tt-docto.media-ponderada-vencto         ";".
      
        FOR EACH tt-parcela
            WHERE tt-parcela.cod-emitente = tt-docto.cod-emitente
              AND tt-parcela.nro-docto    = tt-docto.nro-docto   
              AND tt-parcela.serie-docto  = tt-docto.serie-docto 
              AND tt-parcela.nat-operacao = tt-docto.nat-operacao:
              PUT STREAM s2 UNFORMATTED tt-parcela.dt-vencto  ";"
                                        tt-parcela.valor      ";".
        END.

        PUT STREAM s2 SKIP.

    END.

    OUTPUT STREAM s2 CLOSE.

END PROCEDURE.
/**** Fim do programa ****/
