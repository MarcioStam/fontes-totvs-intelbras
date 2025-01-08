
{esp/es0018.i}
DEFINE STREAM str-excel.

DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-arq-excel   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-linha       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de-preco-conv AS DECIMAL     NO-UNDO.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    FIELD cod-estab-ini    AS CHAR
    FIELD cod-estab-fim    AS CHAR
    FIELD dt-emis-ini      AS DATE
    FIELD dt-emis-fim      AS DATE
    FIELD dt-entrega-ini   AS DATE
    FIELD dt-entrega-fim   AS DATE
    FIELD cod-emitente-ini AS INT
    FIELD cod-emitente-fim AS INT
    FIELD num-pedido-ini   AS INT
    FIELD num-pedido-fim   AS INT.

DEFINE VARIABLE c-dir-saida AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

{utp/ut-glob.i}
{include/pdf_inc.i "THIS-PROCEDURE"}

DEFINE VARIABLE c-arquivo-pdf AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-pdf     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-endereco     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-rua          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nro          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-comp         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-cdapi704     AS HANDLE      NO-UNDO.
DEFINE VARIABLE d-ultima-data  AS DATE        NO-UNDO.
DEFINE VARIABLE i-linha        AS INTEGER     NO-UNDO.
DEFINE VARIABLE d-tot-ipi      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE d-tot-frete    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE d-tot-desconto AS DECIMAL     NO-UNDO.
DEFINE VARIABLE d-tot-produto  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE d-tot-pedido   AS DECIMAL     NO-UNDO.

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "ESCCP003_" + STRING(TIME) + ".csv":U.

    IF  OPSYS = "unix" THEN DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
        END. 

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END. 
    ELSE DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
        END. 

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END.
END.


DO ON STOP UNDO, LEAVE:
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Buscando ...").

    //OUTPUT STREAM str-excel TO value(c-arq-excel) NO-CONVERT.

    //PUT  STREAM str-excel UNFORMATTED  "Pedidos alterados" SKIP.
    
    RUN pi-gera-pdf.

    RUN pi-finalizar in h-acomp.
END.

PROCEDURE pi-gera-pdf:
    ASSIGN c-arquivo-pdf = "ESCCP003_" + STRING(TIME) + ".pdf":U.
    
    ASSIGN c-arq-pdf = c-dir-saida + TRIM(c-arquivo-pdf).
    
    ASSIGN c-arq-pdf = REPLACE(c-arq-pdf, "/":U, "~\":U).

    RUN pdf_new ("Spdf",c-arq-pdf).
    
    RUN pdf_set_PaperType("Spdf","A4").

    /*Carrega imagens para o documento, ap¢s carregadas usa funcao pdf_place_image*/
    RUN pdf_load_image  IN h_PDFinc ("Spdf","marca-decio","image/logo_decio.jpg").

    FOR EACH pedido-compr 
       WHERE pedido-compr.num-pedido   >= tt-param.num-pedido-ini
         AND pedido-compr.num-pedido   <= tt-param.num-pedido-fim
         AND pedido-compr.cod-estabel  >= tt-param.cod-estab-ini 
         AND pedido-compr.cod-estabel  <= tt-param.cod-estab-fim
         AND pedido-compr.data-pedido  >= tt-param.dt-emis-ini
         AND pedido-compr.data-pedido  <= tt-param.dt-emis-fim
         AND pedido-compr.cod-emitente >= tt-param.cod-emitente-ini 
         AND pedido-compr.cod-emitente <= tt-param.cod-emitente-fim NO-LOCK:

        RUN pi-acompanhar IN h-acomp (INPUT "Pedido: " + STRING(pedido-compr.num-pedido)).

        RUN pdf_new_page("Spdf").
        
        RUN pi-cabecalho.
    
        ASSIGN i-linha = 656.
    
        RUN pi-fornec.
    
        RUN pi-fatura.
    
        RUN pi-produto.
    
        RUN pi-transporte.
    
        RUN pi-totais.
    
        RUN pi-observacao.

    END.

    IF i-linha <> 0 THEN DO:
        RUN pdf_close ("Spdf").  
        OS-COMMAND NO-WAIT VALUE(c-arq-pdf) NO-ERROR.
    END.
END PROCEDURE.

PROCEDURE pi-observacao:

    FIND FIRST mensagem NO-LOCK
         WHERE mensagem.cod-mensagem = pedido-compr.cod-mensagem NO-ERROR.

    ASSIGN i-linha = i-linha - 10.

    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               i-linha /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               0.2, /* Height */
                               1  /* Weight */).

    ASSIGN i-linha = i-linha - 12.
    RUN pdf_set_font("Spdf","Helvetica-Bold", 11).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","OBSERVAÄÂES",  5,  i-linha).

    ASSIGN i-linha = i-linha - 10.
    RUN pdf_set_font("Spdf","Helvetica", 8).
    RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(pedido-compr.comentarios,1,150),  5,  i-linha).
    ASSIGN i-linha = i-linha - 10.
    RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(pedido-compr.comentarios,151,150),  5,  i-linha).
    ASSIGN i-linha = i-linha - 10.
    RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(pedido-compr.comentarios,301,150),  5,  i-linha).
    ASSIGN i-linha = i-linha - 10.
    RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(pedido-compr.comentarios,451,150),  5,  i-linha).

    ASSIGN i-linha = i-linha - 20.

    RUN pdf_set_font("Spdf","Helvetica", 8).
    
    DO  i = 1 TO NUM-ENTRIES(mensagem.texto-mensag, CHR(10)):
        ASSIGN c-linha = ENTRY(i,mensagem.texto-mensag,CHR(10)).

        IF LENGTH(ENTRY(i,mensagem.texto-mensag,CHR(10))) > 150 THEN DO:
            RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(c-linha,1,150),  5,  i-linha). 
            ASSIGN i-linha = i-linha - 10.
            RUN pdf_text_xy IN h_PDFinc ("Spdf",SUBSTRING(c-linha,151,150),  5,  i-linha). 
            ASSIGN i-linha = i-linha - 10.
        END.
        ELSE DO:
            RUN pdf_text_xy IN h_PDFinc ("Spdf",c-linha,  5,  i-linha). 
            ASSIGN i-linha = i-linha - 10.
        END.
    END.
    


END PROCEDURE.

PROCEDURE pi-totais:

    ASSIGN i-linha = i-linha - 10.

    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               i-linha /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               0.2, /* Height */ 
                               1  /* Weight */).

    ASSIGN i-linha = i-linha - 12.
    RUN pdf_set_font("Spdf","Helvetica-Bold", 11).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","TOTAIS",  5,  i-linha). 

    ASSIGN i-linha = i-linha - 10.

    RUN pdf_set_font("Spdf","Helvetica-bold", 8).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Valor total IPI",  5,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Valor do frete",  150,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Valor total dos descontos",  250,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Valor total dos produtos",  400,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Valor total do pedido",  510,  i-linha). 

    ASSIGN i-linha = i-linha - 10.
    RUN pdf_set_font("Spdf","Helvetica", 8).
    RUN pdf_text_align("Spdf",string(d-tot-ipi, ">>>>>>>,>>9.99"), "right", 57,  i-linha). 
    RUN pdf_text_align("Spdf",string(d-tot-frete, ">>>>>>>,>>9.99"), "right", 200,  i-linha). 
    RUN pdf_text_align("Spdf",string(d-tot-desconto, ">>>>>>>,>>9.99"), "right", 347,  i-linha). 
    RUN pdf_text_align("Spdf",string(d-tot-produto, ">>>>>>>,>>9.99"), "right", 492,  i-linha). 
    RUN pdf_text_align("Spdf",string(d-tot-pedido, ">>>>>>>,>>9.99"), "right", 590,  i-linha). 

END PROCEDURE.

PROCEDURE pi-transporte:

    FIND FIRST transporte NO-LOCK
         WHERE transporte.cod-transp = pedido-compr.cod-transp NO-ERROR.

    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               i-linha /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               0.2, /* Height */ 
                               1  /* Weight */).

    ASSIGN i-linha = i-linha - 12.
    RUN pdf_set_font("Spdf","Helvetica-Bold", 11).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","TRANSPORTE",  5,  i-linha). 

    ASSIGN i-linha = i-linha - 10.

    RUN pdf_set_font("Spdf","Helvetica-bold", 8).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Nome / Raz∆o",  5,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","CNPJ / CPF",  270,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Incriá∆o Estadual",  400,  i-linha). 

    ASSIGN i-linha = i-linha - 10.
    RUN pdf_set_font("Spdf","Helvetica", 8).
    RUN pdf_text_xy IN h_PDFinc ("Spdf",transporte.nome-abrev,  5,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",transporte.cgc,  270,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",transporte.ins-estadual,  400,  i-linha). 

    ASSIGN i-linha = i-linha - 10.
    RUN pdf_set_font("Spdf","Helvetica-bold", 8).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Endereáo",  5,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Bairro / Distrito",  270,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Munic°pio",  400,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","UF",  490,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Frete",  520,  i-linha). 


    ASSIGN i-linha = i-linha - 10.
    RUN pdf_set_font("Spdf","Helvetica", 8).
    RUN pdf_text_xy IN h_PDFinc ("Spdf",transporte.endereco,  5,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",transporte.bairro,  270,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",transporte.cidade,  400,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",transporte.estado,  490,  i-linha). 

    IF pedido-compr.frete = 1 THEN
        RUN pdf_text_xy IN h_PDFinc ("Spdf","Pago",  520,  i-linha). 
    ELSE 
        RUN pdf_text_xy IN h_PDFinc ("Spdf","A Pagar",  520,  i-linha). 

END PROCEDURE.

PROCEDURE pi-produto:
    DEFINE VARIABLE de-ipi AS DECIMAL     NO-UNDO.
    ASSIGN i-linha = i-linha - 5.

    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               i-linha /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               0.2, /* Height */ 
                               1  /* Weight */).

    ASSIGN i-linha = i-linha - 12.
    RUN pdf_set_font("Spdf","Helvetica-Bold", 11).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","PRODUTOS",  5,  i-linha). 

    RUN pdf_set_font("Spdf","Helvetica-Bold", 8).

    ASSIGN i-linha = i-linha - 12.

    RUN pdf_text_xy IN h_PDFinc ("Spdf","Item",  5,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Descriá∆o",  40,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","NCM",  205,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Und.",  230,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Qtde",  260,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Vlr. Unit.",  285,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Vlr. Descto.",  325,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","% IPI",  375,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Vlr. IPI",  406,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Vlr. Total",  445,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Vlr. Tot. + IPI",  485,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Data",  540,  i-linha). 

    ASSIGN i-linha = i-linha - 10.
    RUN pdf_set_font("Spdf","Helvetica", 8).

    ASSIGN d-tot-ipi = 0
           d-tot-frete = 0
           d-tot-desconto = 0
           d-tot-produto = 0
           d-tot-pedido = 0. 

    FOR EACH ordem-compra OF pedido-compr NO-LOCK
       WHERE ordem-compra.situacao <> 4, /*eliminada*/
        EACH prazo-compra OF ordem-compra NO-LOCK:

        FIND FIRST cotacao-item NO-LOCK
             WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
               AND cotacao-item.cod-emitente = ordem-compra.cod-emitente NO-ERROR.

        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-ERROR.

        //ASSIGN de-ipi = ((cotacao-item.preco-unit * prazo-compra.quantidade) * cotacao-item.aliquota-ipi) / 100.

        RUN cdp/cd0812.p (INPUT ordem-compra.mo-codigo,
                          INPUT 0,
                          INPUT ordem-compra.preco-unit,
                          INPUT ordem-compra.data-cotacao,
                          OUTPUT de-preco-conv).

        IF  de-preco-conv = ? THEN DO:
            ASSIGN de-preco-conv = ordem-compra.preco-unit.
        END.

        assign de-ipi = round((de-preco-conv * ordem-compra.aliquota-ipi) / (100 + ordem-compra.aliquota-ipi),5).
        assign de-ipi = round((prazo-compra.quantidade * de-ipi),5).
    
        RUN pdf_text_xy IN h_PDFinc ("Spdf",ITEM.it-codigo,  5,  i-linha). 
        RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(ITEM.class-fiscal,"9999.99.99"),  185,  i-linha). 
        RUN pdf_text_xy IN h_PDFinc ("Spdf",cotacao-item.un,  230,  i-linha). 
        RUN pdf_text_align("Spdf",string(prazo-compra.qtd-do-forn, ">>>>>>>,>>9.99"), "right", 278,  i-linha). 
        RUN pdf_text_align("Spdf",string(cotacao-item.preco-fornec, ">>>>>>>,>>9.99"), "right", 318,  i-linha). 
        RUN pdf_text_align("Spdf",string(cotacao-item.valor-descto, ">>>>>>>,>>9.99"), "right", 368,  i-linha). 
        RUN pdf_text_align("Spdf",string(cotacao-item.aliquota-ipi, ">9.99"), "right", 395,  i-linha). 
        RUN pdf_text_align("Spdf",string(de-ipi, ">>>,>>9.99"), "right", 432,  i-linha). 
        RUN pdf_text_align("Spdf",string(cotacao-item.preco-unit * prazo-compra.quantidade - de-ipi, ">>>>>>>,>>9.99"), "right", 478,  i-linha). 
        RUN pdf_text_align("Spdf",string(ordem-compra.preco-unit * prazo-compra.quantidade, ">>>>>>>,>>9.99"), "right", 535,  i-linha). 
        RUN pdf_text_xy IN h_PDFinc ("Spdf",STRING(prazo-compra.data-entrega,"99/99/9999"),  540,  i-linha). 

/*         MESSAGE cotacao-item.preco-fornec SKIP        */
/*             cotacao-item.preco-unit SKIP              */
/*             ordem-compra.preco-unit SKIP              */
/*             cotacao-item.pre-unit-for SKIP            */
/*             cotacao-item.preco-fornec                 */
/*             VIEW-AS ALERT-BOX INFORMATION BUTTONS OK. */

        ASSIGN d-tot-ipi =  d-tot-ipi + de-ipi
               d-tot-frete = d-tot-frete + cotacao-item.valor-frete
               d-tot-desconto = d-tot-desconto + cotacao-item.valor-descto
               d-tot-produto  = d-tot-produto + (cotacao-item.preco-unit * prazo-compra.quantidade - de-ipi)
               d-tot-pedido  = d-tot-pedido + (ordem-compra.preco-unit * prazo-compra.quantidade).
        
        IF ITEM.it-codigo = "" THEN DO:
            IF LENGTH(ordem-compra.narrativa) > 25 THEN DO:
                RUN pdf_text_xy IN h_PDFinc ("Spdf",substring(ordem-compra.narrativa,1,25),  40,  i-linha).
                ASSIGN i-linha = i-linha - 10.
                RUN pdf_text_xy IN h_PDFinc ("Spdf",substring(ordem-compra.narrativa,26,25),  40,  i-linha).
            END.
            ELSE 
                RUN pdf_text_xy IN h_PDFinc ("Spdf",ordem-compra.narrativa,  40,  i-linha). 
        END.
        ELSE DO:
            IF LENGTH(ITEM.desc-item) > 25 THEN DO:
                RUN pdf_text_xy IN h_PDFinc ("Spdf",substring(ITEM.desc-item,1,25),  40,  i-linha).
                ASSIGN i-linha = i-linha - 10.
                RUN pdf_text_xy IN h_PDFinc ("Spdf",substring(ITEM.desc-item,26,25),  40,  i-linha).
            END.
            ELSE 
                RUN pdf_text_xy IN h_PDFinc ("Spdf",ITEM.desc-item,  40,  i-linha). 
        END.

        ASSIGN i-linha = i-linha - 10.

        IF i-linha <= 250 THEN DO:

            RUN pi-transporte.
        
            RUN pi-totais.
        
            RUN pi-observacao.
            
            RUN pdf_new_page("Spdf").
            
            RUN pi-cabecalho.
        
            ASSIGN i-linha = 656.
        
            RUN pi-fornec.
        
            RUN pi-fatura.
        END.
    END.

END PROCEDURE.

PROCEDURE pi-fatura:
    DEFINE VARIABLE i-col AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-ind AS INTEGER     NO-UNDO.

    FIND FIRST cond-pagto NO-LOCK
         WHERE cond-pagto.cod-cond-pag = pedido-compr.cod-cond-pag NO-ERROR.

    ASSIGN d-tot-pedido = 0.
    FOR EACH ordem-compra OF pedido-compr,
        EACH prazo-compra OF ordem-compra NO-LOCK:

        FIND FIRST cotacao-item NO-LOCK
             WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
               AND cotacao-item.cod-emitente = ordem-compra.cod-emitente NO-ERROR.

        ASSIGN d-tot-pedido  = d-tot-pedido + (cotacao-item.pre-unit-for * prazo-compra.quantidade).
    END.

    ASSIGN i-linha = i-linha - 10.

    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               i-linha /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               0.2, /* Height */
                               1  /* Weight */).

    ASSIGN i-linha = i-linha - 12.
    RUN pdf_set_font("Spdf","Helvetica-Bold", 11).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","CONDIÄ«O DE PAGAMENTO",  5,  i-linha). 

    ASSIGN i-linha = i-linha - 15
           i-col = 1.

    RUN pdf_set_font("Spdf","Helvetica", 10).

    IF AVAIL cond-pagto THEN
        RUN pdf_text_xy IN h_PDFinc ("Spdf",cond-pagto.descricao,  5,  i-linha).
    


END PROCEDURE.

PROCEDURE pi-fornec:
    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = pedido-compr.cod-emitente NO-ERROR.

    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               pdf_PageHeight("Spdf") - 175 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               0.2, /* Height */ 
                               1  /* Weight */).

    
    RUN pdf_set_font("Spdf","Helvetica-Bold", 11).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","FORNECEDOR",  5,  i-linha). 

    ASSIGN i-linha = i-linha - 10.

    RUN pdf_set_font("Spdf","Helvetica-bold", 8).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Nome / Raz∆o",  5,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","CNPJ / CPF",  270,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Fone",  380,  i-linha). 

    ASSIGN i-linha = i-linha - 10.
    RUN pdf_set_font("Spdf","Helvetica", 8).
    RUN pdf_text_xy IN h_PDFinc ("Spdf",emitente.nome-emit,  5,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",emitente.cgc,  270,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",emitente.telefone[1],  380,  i-linha). 

    ASSIGN i-linha = i-linha - 10.
    RUN pdf_set_font("Spdf","Helvetica-bold", 8).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Endereáo",  5,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Bairro / Distrito",  270,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Munic°pio",  380,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","UF",  490,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","CEP",  520,  i-linha). 


    ASSIGN i-linha = i-linha - 10.
    RUN pdf_set_font("Spdf","Helvetica", 8).
    RUN pdf_text_xy IN h_PDFinc ("Spdf",emitente.endereco,  5,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",emitente.bairro,  270,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",emitente.cidade,  380,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",emitente.estado,  490,  i-linha). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",emitente.cep,  520,  i-linha). 

END PROCEDURE.

PROCEDURE pi-cabecalho:
    FIND FIRST estabelec NO-LOCK
         WHERE estabelec.cod-estabel = pedido-compr.cod-estabel NO-ERROR.

    /*primeira linha*/
    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               pdf_PageHeight("Spdf") - 50 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               45, /* Height */ 
                               1  /* Weight */).

       /*primeira linha*/
    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               pdf_PageHeight("Spdf") - 50 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 100 /*Width*/,
                               45, /* Height */ 
                               1  /* Weight */).

    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               170,    /*From Column*/
                               pdf_PageHeight("Spdf") - 50 /*From  Row*/,
                               420 /*Width*/,
                               45, /* Height */
                               1  /* Weight */).

    RUN pdf_place_image IN h_PDFinc ("Spdf",
                                     "marca-decio",
                                     pdf_LeftMargin("Spdf") + 20, /*LEFT*/
                                     pdf_PageHeight("Spdf") - 800, /*top*/
                                     pdf_LeftMargin("Spdf") + 100, 
                                     35).


    RUN pdf_set_font("Spdf","Helvetica-Bold", 19).
    
    RUN pdf_text_xy IN h_PDFinc ("Spdf","PEDIDO DE COMPRA",  230,  pdf_PageHeight("Spdf") - 35). 

    RUN pdf_set_font("Spdf","Helvetica-Bold", 14).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","RQ-013",  520,  pdf_PageHeight("Spdf") - 20). 
    RUN pdf_set_font("Spdf","Helvetica-Bold", 10).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Rev.: 02",  505,  pdf_PageHeight("Spdf") - 35). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","06/11/2019",  505,  pdf_PageHeight("Spdf") - 45). 
    
    /*segunda linha*/
    RUN pdf_rect2 IN h_PDFinc ("Spdf",/*Stream Name as Character*/
                               5,    /*From Column*/
                               pdf_PageHeight("Spdf") - 170 /*From  Row*/,
                               pdf_PageWidth("Spdf") - 10 /*Width*/,
                               120, /* Height */ 
                               1  /* Weight */).

    RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.
    RUN pi-trata-endereco IN h-cdapi704 (INPUT  estabelec.endereco,
                                         OUTPUT c-rua, 
                                         OUTPUT c-nro, 
                                         OUTPUT c-comp).
    DELETE PROCEDURE h-cdapi704.

    
    RUN pdf_set_font("Spdf","Helvetica-Bold", 12).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Endereáo",  15,  pdf_PageHeight("Spdf") - 65). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Complemento",  170,  pdf_PageHeight("Spdf") - 65). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","N£mero",  300,  pdf_PageHeight("Spdf") - 65). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Bairro ",  15,  pdf_PageHeight("Spdf") - 95). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","CEP ",  170,  pdf_PageHeight("Spdf") - 95). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Munic°pio",  15,  pdf_PageHeight("Spdf") - 123). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","UF",  170,  pdf_PageHeight("Spdf") - 123). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","CNPJ",  15,  pdf_PageHeight("Spdf") - 151). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf","I.E.",  170,  pdf_PageHeight("Spdf") - 151). 

    RUN pdf_set_font("Spdf","Helvetica", 12).
    RUN pdf_text_xy IN h_PDFinc ("Spdf",c-rua,  15,  pdf_PageHeight("Spdf") - 78). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",c-comp,  170,  pdf_PageHeight("Spdf") - 78). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",c-nro,  300,  pdf_PageHeight("Spdf") - 78). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",estabelec.bairro,  15,  pdf_PageHeight("Spdf") - 108). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",estabelec.cep,  170,  pdf_PageHeight("Spdf") - 108). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",estabelec.cidade,  15,  pdf_PageHeight("Spdf") - 136). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",estabelec.estado,  170,  pdf_PageHeight("Spdf") - 136). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",estabelec.cgc,  15,  pdf_PageHeight("Spdf") - 164). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",estabelec.ins-estadual,  170,  pdf_PageHeight("Spdf") - 164). 
    
    RUN pdf_set_font("Spdf","Helvetica-Bold", 16).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","PEDIDO: ",  440,  pdf_PageHeight("Spdf") - 70). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",pedido-compr.num-pedido,  515,  pdf_PageHeight("Spdf") - 70). 
    RUN pdf_set_font("Spdf","Helvetica-Bold", 12).
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Data emiss∆o: ",  420,  pdf_PageHeight("Spdf") - 100). 
    RUN pdf_text_xy IN h_PDFinc ("Spdf",string(pedido-compr.data-pedido,"99/99/9999"),  510,  pdf_PageHeight("Spdf") - 100). 

    /*Busca ultima entrega do pedido para impressao no cabeáalho*/
    ASSIGN d-ultima-data = 01/01/0001.
    FOR EACH ordem-compra OF pedido-compr NO-LOCK:
        FOR EACH prazo-compra OF ordem-compra NO-LOCK:
            IF prazo-compra.data-entrega > d-ultima-data THEN DO:
                ASSIGN d-ultima-data = prazo-compra.data-entrega.
            END.
        END.
    END.
    
    RUN pdf_text_xy IN h_PDFinc ("Spdf","Data entrega: ",  425,  pdf_PageHeight("Spdf") - 115). 

    IF d-ultima-data <> 01/01/0001 THEN
        RUN pdf_text_xy IN h_PDFinc ("Spdf",string(d-ultima-data,"99/99/9999"),  510,  pdf_PageHeight("Spdf") - 115). 
    
END PROCEDURE.
