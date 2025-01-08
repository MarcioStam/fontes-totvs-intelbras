/*************************************************************************************************************************************************************************
** Copyright PRIME Consultoria (2014)                                                                                                                                   **
** Todos os Direitos Reservados.                                                                                                                                        **
**                                                                                                                                                                      **
** Este fonte Ç de propriedade exclusiva da PRIME Consultoria, sua reproduá∆o parcial ou total por qualquer meio, s¢ poder† ser feita mediante autorizaá∆o expressa     **
**                                                                                                                                                                      **
**************************************************************************************************************************************************************************
** Programa .....: prmapi-nota-fiscal                                                                                                                                   **
** Data .........: Agosto de 2016                                                                                                                                       **
** Autor ........: Prime Consultoria                                                                                                                                    **
** Objetivo .....: Api para criar nota fiscal                                                                                                                           **
** Revis‰es **************************************************************************************************************************************************************
** Autor                Ver.    Data      Cliente      Solicitante    Descriá∆o                                                                                         **
** Alexandro Carvalho   00.001  22/08/16  CRS          CRS            1) Desenvolvimento inicial do programa                                                            **
**                                                                                                                                                                      **
*************************************************************************************************************************************************************************/

BLOCK-LEVEL ON ERROR UNDO,THROW.

DEFINE NEW GLOBAL SHARED VAR i-num-ped-exec-rpw AS INTEGER NO-UNDO.

/*Vari†veis do c†lculo da nota fiscal*/
DEFINE VARIABLE h-bodi317in             AS HANDLE       NO-UNDO.
DEFINE VARIABLE h-bodi317pr             AS HANDLE       NO-UNDO.
DEFINE VARIABLE h-bodi317sd             AS HANDLE       NO-UNDO.
DEFINE VARIABLE h-bodi317im1bra         AS HANDLE       NO-UNDO.
DEFINE VARIABLE h-bodi317va             AS HANDLE       NO-UNDO.
DEFINE VARIABLE h-bodi317ef             AS HANDLE       NO-UNDO.
DEFINE VARIABLE i-seq-wt-docto          AS INTEGER      NO-UNDO.
DEFINE VARIABLE i-seq-wt-it-docto       AS INTEGER      NO-UNDO.
DEFINE VARIABLE l-proc-ok-aux           AS LOGICAL      NO-UNDO.
DEFINE VARIABLE c-ultimo-metodo-exec    AS CHARACTER    NO-UNDO.
/*------------------------------------*/

DEFINE VARIABLE d-qt-volume                     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-quantidade                   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vl-preori-ped                AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-val-pct-desconto-tab-preco   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-per-des-item                 AS DECIMAL     NO-UNDO.
DEFINE VARIABLE i-seq-item                      AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-sigla-emb                     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-un                            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de-quantidade-aux               AS DECIMAL     NO-UNDO.

{utp/ut-glob.i}
{cdp/cdcfgdis.i}
{prmapi/prmapi-nota-fiscal.i}

/* Def temp-table de erros */
DEFINE TEMP-TABLE RowErrors NO-UNDO
    FIELD errorsequence    AS INTEGER
    FIELD errornumber      AS INTEGER
    FIELD errordescription AS CHARACTER
    FIELD errorparameters  AS CHARACTER
    FIELD errortype        AS CHARACTER
    FIELD errorhelp        AS CHARACTER
    FIELD errorsubtype     AS CHARACTER.

DEFINE TEMP-TABLE tt-notas-geradas NO-UNDO
    FIELD rw-nota-fiscal AS   ROWID
    FIELD nr-nota        LIKE nota-fiscal.nr-nota-fis
    FIELD seq-wt-docto   LIKE wt-docto.seq-wt-docto.

DEFINE TEMP-TABLE tt-param-ft2015
    FIELD destino          AS INTEGER
    FIELD arq-destino      AS CHARACTER
    FIELD arq-entrada      AS CHARACTER
    FIELD todos            AS INTEGER
    FIELD usuario          AS CHARACTER
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD l-importa        AS LOGICAL.
    
DEFINE TEMP-TABLE tt-raw-digita-ft2015
    FIELD raw-digita  AS RAW.  

/* ************************  Function Prototypes ********************** */
FUNCTION formatarDecimal RETURNS CHARACTER 
    (INPUT p-valor AS DECIMAL,
     INPUT p-qtde-decimal AS INTEGER) FORWARD.

PROCEDURE gerarNotaFiscal:
    DEFINE PARAMETER BUFFER b-tt-nota-fiscal FOR TEMP-TABLE tt-nota-fiscal.
    DEFINE INPUT PARAMETER TABLE FOR item-nota-fiscal.    
    DEFINE OUTPUT PARAMETER p-rw-nota-fiscal AS ROWID.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.
    
    EMPTY TEMP-TABLE tt-erro.
    EMPTY TEMP-TABLE RowErrors.
    
    /* Inicializaá∆o das BOS para C†lculo */
    RUN dibo/bodi317in.p PERSISTENT SET h-bodi317in.
    RUN inicializaBOS IN h-bodi317in (OUTPUT h-bodi317pr,
                                      OUTPUT h-bodi317sd,     
                                      OUTPUT h-bodi317im1bra,
                                      OUTPUT h-bodi317va).
    
    blocoExec:
    DO TRANSACTION ON ERROR UNDO,LEAVE:        
        FIND FIRST emitente WHERE emitente.cod-emitente = b-tt-nota-fiscal.cod-emitente NO-LOCK NO-ERROR.
        IF NOT AVAILABLE emitente THEN
            UNDO blocoExec, THROW NEW Progress.Lang.AppError("Cliente " + STRING(b-tt-nota-fiscal.cod-emitente) + " n∆o cadastrado.",0).                   
    
        IF NOT CAN-FIND(FIRST natur-oper WHERE natur-oper.nat-operacao = b-tt-nota-fiscal.nat-operacao) THEN 
            UNDO blocoExec, THROW NEW Progress.Lang.AppError("Natureza de Operaá∆o " + b-tt-nota-fiscal.nat-operacao + " n∆o cadastrada.",0).
    
        /* Limpar a tabela de erros em todas as BOS */
        RUN emptyRowErrors IN h-bodi317in.
        RUN criaWtDocto IN h-bodi317sd (INPUT  c-seg-usuario,           /* Usu†rio do sistema*/
                                        INPUT  b-tt-nota-fiscal.cod-estabel,           /* C¢digo do estabelecimento da nota */
                                        INPUT  b-tt-nota-fiscal.serie,                 /* SÇrie da nota fiscal */ 
                                        INPUT  b-tt-nota-fiscal.nr-nota-fis,           /* N£mero da nota fiscal, para notas manuais */
                                        INPUT  emitente.cod-emitente,   /* C¢digo, nome abreviado ou CGC do cliente */
                                        INPUT  ?,                       /* N£mero do pedido de venda, quando existir */
                                        INPUT  b-tt-nota-fiscal.tipo-nf,               /* Tipo da nota fiscal */
                                        INPUT  4003,                    /* C¢digo do programa que gerou a nota */
                                        INPUT  b-tt-nota-fiscal.dt-emis-nota,            /* Data de emiss∆o da nota fiscal */
                                        INPUT  0,                       /* N£mero do embarque, quando existir */   
                                        INPUT  b-tt-nota-fiscal.nat-operacao,          /* C¢digo da natureza de operaá∆o */
                                        INPUT  b-tt-nota-fiscal.cod-canal-venda,       /* C¢digo do canal de venda do cliente, quando existir */   
                                        OUTPUT i-seq-wt-docto,          /* SeqÅància do documento (chave £nica) */
                                        OUTPUT l-proc-ok-aux).          /* Execuá∆o do mÇtodo com sucesso ou n∆o */
        RUN pi-gera-erro.

        /* Caso ocorreu problema nas validaá‰es, n∆o continua o processo */
        IF NOT l-proc-ok-aux THEN
            UNDO blocoExec, LEAVE blocoExec.
    
        /* atualiza volume da NF */
        ASSIGN d-qt-volume = 0.
        FIND FIRST wt-docto 
             WHERE wt-docto.seq-wt-docto = i-seq-wt-docto NO-ERROR.
        IF AVAILABLE wt-docto THEN DO:
            ASSIGN wt-docto.observ-nota = b-tt-nota-fiscal.observacao.
    
            IF b-tt-nota-fiscal.nr-nota-fis <> "" AND 
               b-tt-nota-fiscal.nr-nota-fis <> "0" THEN
                ASSIGN wt-docto.nr-nota = b-tt-nota-fiscal.nr-nota-fis.
    
            IF b-tt-nota-fiscal.cod-transp <> ? THEN DO:
                FIND FIRST transporte WHERE transporte.cod-transp = b-tt-nota-fiscal.cod-transp NO-LOCK NO-ERROR.
                IF AVAILABLE transporte THEN
                    ASSIGN wt-docto.nome-transp = transporte.nome-abrev.
                ELSE
                    ASSIGN wt-docto.nome-transp = ?.
            END.
    
            IF b-tt-nota-fiscal.cod-entrega <> ? THEN 
                ASSIGN wt-docto.cod-entrega = b-tt-nota-fiscal.cod-entrega.
    
            IF b-tt-nota-fiscal.nr-tabpre <> ? THEN
                ASSIGN wt-docto.nr-tabpre = b-tt-nota-fiscal.nr-tabpre.
    
            IF b-tt-nota-fiscal.cod-cond-pag <> ? THEN
                ASSIGN wt-docto.cod-cond-pag = b-tt-nota-fiscal.cod-cond-pag.

            IF b-tt-nota-fiscal.cod-portador <> ? THEN DO:
                ASSIGN wt-docto.cod-portador = b-tt-nota-fiscal.cod-portador.
            END.
        END.

        FIND mgadm.repres NO-LOCK WHERE repres.cod-rep = b-tt-nota-fiscal.cod-rep NO-ERROR.
        IF AVAILABLE repres THEN
            ASSIGN wt-docto.no-ab-reppri = repres.nome-abrev .
    
        ASSIGN c-sigla-emb = 'CX'.    
    
        /* Bloco a ser repetido para cada item da nota */
        FOR EACH item-nota-fiscal NO-LOCK BREAK BY item-nota-fiscal.it-codigo:
            &IF DEFINED(bf_dis_preco_un_med_mult) &THEN
                RUN searchDefaultUOM IN h-bodi317sd(INPUT item-nota-fiscal.it-codigo,
                                                    INPUT i-seq-wt-docto,
                                                    OUTPUT c-un,
                                                    OUTPUT l-proc-ok-aux).
            &ELSE    
                RUN retornaUnidadeDeMedidaDoItem IN h-bodi317sd(INPUT item-nota-fiscal.it-codigo,
                                                                OUTPUT c-un).
            &ENDIF
    
            ASSIGN de-val-pct-desconto-tab-preco = 0 /* Desconto de tabela */
                   de-per-des-item               = 0
                   de-quantidade                 = item-nota-fiscal.qt-faturada
                   de-vl-preori-ped              = item-nota-fiscal.vl-preori-ped.        
    
            IF de-vl-preori-ped = 0 THEN DO:
                preco-item:
                FOR EACH preco-item WHERE preco-item.nr-tabpre = b-tt-nota-fiscal.nr-tabpre
                                    AND   preco-item.it-codigo = item-nota-fiscal.it-codigo
                                    AND   preco-item.situacao  = 1 /*Ativo*/
                                    NO-LOCK BY preco-item.dt-inival DESCENDING:
                    IF b-tt-nota-fiscal.dt-emis-nota >= preco-item.dt-inival THEN DO:
                        ASSIGN de-vl-preori-ped  = preco-item.preco-venda.
                        LEAVE preco-item.
                    END.
                END.
            END.
    
            FIND FIRST item NO-LOCK WHERE item.it-codigo = item-nota-fiscal.it-codigo NO-ERROR.
            FIND FIRST item-caixa NO-LOCK
                 WHERE (item-caixa.fm-codigo  = item.fm-codigo  OR
                        item-caixa.fm-codigo  = ?)
                   AND (item-caixa.fm-cod-com = item.fm-cod-com OR
                        item-caixa.fm-cod-com = ?)
                   AND (item-caixa.it-codigo  = item.it-codigo  OR
                        item-caixa.it-codigo  = ?) NO-ERROR.
            IF AVAILABLE item-caixa THEN
                ASSIGN c-sigla-emb = item-caixa.sigla-emb .
    
            IF AVAILABLE ITEM AND ITEM.ind-inf-qtf = TRUE THEN
                ASSIGN de-quantidade = (ITEM.ft-conversao / EXP(10,ITEM.dec-ftcon)) * de-quantidade.
    
            /* Limpar a tabela de erros em todas as BOS */
            RUN emptyRowErrors IN h-bodi317in.
    
            /* Disponibilizar o registro WT-DOCTO na bodi317sd */
            RUN localizaWtDocto IN h-bodi317sd(INPUT  i-seq-wt-docto,
                                               OUTPUT l-proc-ok-aux). 
            /*ASSIGN i-seq-item = i-seq-item + 10.*/
    
            /* Cria um item para nota fiscal. */
            RUN criaWtItDocto IN h-bodi317sd  (INPUT  ?,
                                               INPUT  "",
                                               INPUT  item-nota-fiscal.nr-seq-fat /*i-seq-item*/,
                                               INPUT  item-nota-fiscal.it-codigo,
                                               INPUT  item-nota-fiscal.cod-refer,
                                               INPUT  item-nota-fiscal.nat-operacao,
                                               OUTPUT i-seq-wt-it-docto,
                                               OUTPUT l-proc-ok-aux).
            RUN pi-gera-erro.
    
            /* Caso ocorreu problema nas validaá‰es, n∆o continua o processo */
            IF NOT l-proc-ok-aux THEN
                UNDO blocoExec, LEAVE blocoExec.
    
            &IF DEFINED(bf_dis_preco_un_med_mult) &THEN
                RUN emptyRowErrors IN h-bodi317in.
                RUN WriteUomQuantity IN h-bodi317sd(INPUT i-seq-wt-docto,
                                                    INPUT i-seq-wt-it-docto,
                                                    INPUT (IF de-quantidade = 0 THEN 1 ELSE de-quantidade),
                                                    INPUT  c-un,
                                                    OUTPUT de-quantidade,
                                                    OUTPUT l-proc-ok-aux).
                RUN pi-gera-erro.
                IF NOT l-proc-ok-aux THEN
                    UNDO blocoexec,LEAVE blocoexec.
            &ELSE
                RUN atualizaUnMedida1 IN h-bodi317sd(INPUT i-seq-wt-docto,
                                                     INPUT i-seq-wt-it-docto,
                                                     INPUT c-un,
                                                     OUTPUT l-proc-ok-aux).
            &ENDIF    
            
            /* Cria registro Fat-ser-lote para baixar do Parametro */
            RUN criaAlteraWtFatSerLote IN h-bodi317sd (INPUT YES,                   /* Inclusao */
                                                       INPUT i-seq-wt-docto,
                                                       INPUT i-seq-wt-it-docto,
                                                       INPUT item-nota-fiscal.it-codigo,
                                                       INPUT item-nota-fiscal.cod-depos, /*Dep¢sito*/
                                                       INPUT item-nota-fiscal.cod-localiz, /*Localizaá∆o*/
                                                       INPUT item-nota-fiscal.nr-serlote,  /* Lote */
                                                       INPUT de-quantidade,                     /* de-quantidade */
                                                       INPUT 0,                     /* Qtd Contada */
                                                       INPUT item-nota-fiscal.dt-vali-lote, /* Dt Validade Lote */
                                                       OUTPUT l-proc-ok-aux).
            RUN pi-gera-erro.
    
            /* Caso ocorreu problema nas validaá‰es, n∆o continua o processo */
            IF NOT l-proc-ok-aux THEN
                UNDO, LEAVE blocoExec.            
    
            /* Grava informaá‰es gerais para o item da nota */
            RUN gravaInfGeraisWtItDocto IN h-bodi317sd (INPUT i-seq-wt-docto,
                                                        INPUT i-seq-wt-it-docto,
                                                        INPUT de-quantidade,
                                                        INPUT de-vl-preori-ped,
                                                        INPUT de-val-pct-desconto-tab-preco,
                                                        INPUT de-per-des-item).
    
            /* Limpar a tabela de erros em todas as BOS */
            RUN emptyRowErrors        IN h-bodi317in.
            /* Disp. registro WT-DOCTO, WT-IT-DOCTO e WT-IT-IMPOSTO na bodi317pr */
            RUN localizaWtDocto       IN h-bodi317pr(INPUT  i-seq-wt-docto,
                                                     OUTPUT l-proc-ok-aux).
            RUN localizaWtItDocto     IN h-bodi317pr(INPUT  i-seq-wt-docto,
                                                     INPUT  i-seq-wt-it-docto,
                                                     OUTPUT l-proc-ok-aux).
            RUN localizaWtItImposto   IN h-bodi317pr(INPUT  i-seq-wt-docto,
                                                     INPUT  i-seq-wt-it-docto,
                                                     OUTPUT l-proc-ok-aux).
    
            /* Atualiza dados c†lculados do item */
            RUN atualizaDadosItemNota IN h-bodi317pr(OUTPUT l-proc-ok-aux).
            RUN pi-gera-erro.
    
            /* Caso ocorreu problema nas validaá‰es, n∆o continua o processo */
            IF NOT l-proc-ok-aux THEN
                UNDO blocoExec, LEAVE blocoExec.
    
            /* Limpar a tabela de erros em todas as BOS */
            RUN emptyRowErrors        IN h-bodi317in.
            /* Valida informaá‰es do item */
            RUN validaItemDaNota      IN h-bodi317va(INPUT  i-seq-wt-docto,
                                                     INPUT  i-seq-wt-it-docto,
                                                     OUTPUT l-proc-ok-aux).
            RUN pi-gera-erro.
    
            /* Caso ocorreu problema nas validaá‰es, n∆o continua o processo */
            IF NOT l-proc-ok-aux THEN
                UNDO blocoExec,LEAVE blocoExec.
        END.
        /*--------------------------------*/
    
        /* Finalizaá∆o das BOS utilizada no c†lculo */
        RUN finalizaBOS IN h-bodi317in.
        
        /* Reinicializaá∆o das BOS para C†lculo */
        RUN dibo/bodi317in.p PERSISTENT SET h-bodi317in.
        RUN inicializaBOS IN h-bodi317in(OUTPUT h-bodi317pr,
                                         OUTPUT h-bodi317sd,     
                                         OUTPUT h-bodi317im1bra,
                                         OUTPUT h-bodi317va).
        /* Limpar a tabela de erros em todas as BOS */
        RUN emptyRowErrors        IN h-bodi317in.
        /* Calcula o pedido, com acompanhamento */
        //RUN inicializaAcompanhamento IN h-bodi317pr.
        RUN confirmaCalculo          IN h-bodi317pr(INPUT  i-seq-wt-docto,
                                                    OUTPUT l-proc-ok-aux).
        //RUN finalizaAcompanhamento   IN h-bodi317pr.
        RUN pi-gera-erro.        
        /* Caso ocorreu problema nas validaá‰es, n∆o continua o processo */
        IF NOT l-proc-ok-aux THEN DO:        
            UNDO blocoExec, LEAVE blocoExec.
        END.
    
        /* Efetiva os pedidos e cria a nota */
        RUN dibo/bodi317ef.p PERSISTENT SET h-bodi317ef.
        RUN emptyRowErrors           IN h-bodi317in.
        //RUN inicializaAcompanhamento IN h-bodi317ef.
        RUN setaHandlesBOS           IN h-bodi317ef(h-bodi317pr,    
                                                    h-bodi317sd,
                                                    h-bodi317im1bra,
                                                    h-bodi317va).
        RUN efetivaNota              IN h-bodi317ef(INPUT  i-seq-wt-docto,
                                                    INPUT  YES,
                                                    OUTPUT l-proc-ok-aux).
        //RUN finalizaAcompanhamento   IN h-bodi317ef.
    
        RUN pi-gera-erro.
    
        /* Caso ocorreu problema nas validacoes, nao continua o processo */
        IF NOT l-proc-ok-aux THEN DO:        
            DELETE PROCEDURE h-bodi317ef.
            UNDO blocoExec, LEAVE blocoExec.
        END.
    
        /* Busca as notas fiscais geradas */
        RUN buscaTTNotasGeradas IN h-bodi317ef(OUTPUT l-proc-ok-aux,
                                               OUTPUT table tt-notas-geradas).
    
        FIND FIRST tt-notas-geradas NO-LOCK NO-ERROR.
        IF AVAILABLE tt-notas-geradas THEN DO:
            ASSIGN p-rw-nota-fiscal = tt-notas-geradas.rw-nota-fiscal.
        END.
        
        /* Fim do programa que calcula uma nota complementar */
        /* Elimina o handle do programa bodi317ef */
        RUN finalizaBOS IN h-bodi317in.
        
        CATCH erro AS Progress.Lang.Error :
            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = 0
                   tt-erro.cd-erro  = erro:GetMessageNum(1)
                   tt-erro.mensagem = erro:GetMessage(1).                
        END CATCH.          
    END.        
    
    RUN pi-finaliza-handle.
END PROCEDURE.


/* **********************  Internal Procedures  *********************** */
PROCEDURE pi-gera-erro:
    IF VALID-HANDLE(h-bodi317sd) THEN
    DO:
        /* Busca poss°veis erros que ocorreram nas validaá‰es */
        RUN devolveErrosbodi317sd IN h-bodi317sd(OUTPUT c-ultimo-metodo-exec,
                                                 OUTPUT table RowErrors).

        /* Pesquisa algum erro ou advertància que tenha ocorrido */
        FIND FIRST RowErrors NO-LOCK NO-ERROR.

        /* Caso tenha achado algum erro ou advertància, mostra em tela */
        IF AVAILABLE RowErrors THEN
            FOR EACH RowErrors WHERE RowErrors.ErrorSubtype = "ERROR":
                CREATE tt-erro.
                ASSIGN tt-erro.i-sequen = 1
                       tt-erro.cd-erro  = RowErrors.errornumber
                       tt-erro.mensagem = RIGHT-TRIM(RowErrors.errordescription + "-" + TRIM(RowErrors.ErrorHelp),"-").
            END.
    END.

    IF VALID-HANDLE(h-bodi317pr) THEN
    DO:
        /* Busca poss°veis erros que ocorreram nas validaá‰es */
        RUN devolveErrosbodi317pr IN h-bodi317pr(OUTPUT c-ultimo-metodo-exec,
                                                 OUTPUT table RowErrors).

        /* Pesquisa algum erro ou advertància que tenha ocorrido */
        FIND FIRST RowErrors NO-LOCK NO-ERROR.

        /* Caso tenha achado algum erro ou advertància, mostra em tela */
        IF AVAILABLE RowErrors THEN
            FOR EACH RowErrors WHERE RowErrors.ErrorSubtype = "ERROR":
                CREATE tt-erro.
                ASSIGN tt-erro.i-sequen = 1
                       tt-erro.cd-erro  = RowErrors.errornumber
                       tt-erro.mensagem = RIGHT-TRIM(RowErrors.errordescription + "-" + TRIM(RowErrors.ErrorHelp),"-").
            END.
    END.

    IF VALID-HANDLE(h-bodi317va) THEN
    DO:
        /* Busca poss°veis erros que ocorreram nas validaá‰es */
        RUN devolveErrosbodi317va IN h-bodi317va(OUTPUT c-ultimo-metodo-exec,
                                                 OUTPUT table RowErrors).

        /* Pesquisa algum erro ou advertància que tenha ocorrido */
        FIND FIRST RowErrors NO-LOCK NO-ERROR.

        /* Caso tenha achado algum erro ou advertància, mostra em tela */
        IF AVAILABLE RowErrors THEN
           FOR EACH RowErrors WHERE RowErrors.ErrorSubtype = "ERROR":
               CREATE tt-erro.
               ASSIGN tt-erro.i-sequen = 1
                      tt-erro.cd-erro  = RowErrors.errornumber
                      tt-erro.mensagem = RIGHT-TRIM(RowErrors.errordescription + "-" + TRIM(RowErrors.ErrorHelp),"-").
           END.
    END.

    IF VALID-HANDLE(h-bodi317ef) THEN
    DO:
        /* Busca poss°veis erros que ocorreram nas validaá‰es */
        RUN devolveErrosbodi317ef IN h-bodi317ef(OUTPUT c-ultimo-metodo-exec,
                                                    OUTPUT table RowErrors).

        /* Pesquisa algum erro ou advertància que tenha ocorrido */
        FIND FIRST RowErrors
             WHERE RowErrors.ErrorSubType = "ERROR":U NO-ERROR.

        /* Caso tenha achado algum erro ou advertància, mostra em tela */
        IF  AVAILABLE RowErrors THEN
            FOR EACH RowErrors WHERE RowErrors.ErrorSubtype = "ERROR":
                CREATE tt-erro.
                ASSIGN tt-erro.i-sequen = 1
                       tt-erro.cd-erro  = RowErrors.errornumber
                       tt-erro.mensagem = RIGHT-TRIM(RowErrors.errordescription + "-" + TRIM(RowErrors.ErrorHelp),"-").
            END.
    END.
END PROCEDURE.


PROCEDURE pi-finaliza-handle:
    IF VALID-HANDLE(h-bodi317in) THEN DO:
        RUN finalizaBOS IN h-bodi317in.
        DELETE PROCEDURE h-bodi317in NO-ERROR.
    END.

    IF VALID-HANDLE(h-bodi317pr) THEN DO:
        //RUN finalizaAcompanhamento IN h-bodi317pr.
        DELETE PROCEDURE h-bodi317pr NO-ERROR.
    END.

    IF VALID-HANDLE(h-bodi317sd) THEN
        DELETE PROCEDURE h-bodi317sd.

    IF VALID-HANDLE(h-bodi317im1bra) THEN
        DELETE PROCEDURE h-bodi317im1bra.

    IF VALID-HANDLE(h-bodi317va) THEN
        DELETE PROCEDURE h-bodi317va.

    IF VALID-HANDLE(h-bodi317ef) THEN DO:
        //RUN finalizaAcompanhamento   IN h-bodi317ef.
        DELETE PROCEDURE h-bodi317ef NO-ERROR.
    END.
END PROCEDURE.

PROCEDURE importarNFFT2015:
    DEFINE PARAMETER BUFFER b-tt-nota-fiscal FOR TEMP-TABLE tt-nota-fiscal.
    DEFINE INPUT PARAMETER TABLE FOR item-nota-fiscal.    
    DEFINE INPUT PARAMETER TABLE FOR tt-fat-duplic.    
    DEFINE OUTPUT PARAMETER p-rw-nota-fiscal AS ROWID.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.
    
    DEFINE VARIABLE c-arquivo AS CHARACTER NO-UNDO.       
    
    EMPTY TEMP-TABLE tt-erro.

    ASSIGN c-arquivo = RIGHT-TRIM(RIGHT-TRIM(SESSION:TEMP-DIRECTORY,"/"),"\") + "/NFFT2015.txt".
    IF i-num-ped-exec-rpw > 0 THEN DO:
        FIND FIRST ped_exec NO-LOCK
             WHERE ped_exec.num_ped_exec = i-num-ped-exec-rpw NO-ERROR.
        FIND FIRST servid_exec NO-LOCK
             WHERE servid_exec.cod_servid_exec = ped_exec.cod_servid_exec NO-ERROR.
        ASSIGN c-arquivo = servid_exec.nom_dir_spool + "\" + ped_exec.cod_usuario + "\NFFT2015.txt".
    END.
   
    OS-DELETE VALUE(c-arquivo). 
    OUTPUT TO VALUE(c-arquivo) NO-CONVERT.
    
    PUT UNFORMATTED 
        "1" AT 1
        b-tt-nota-fiscal.cod-des-merc AT 2                       
        SUBSTRING(b-tt-nota-fiscal.estado,1,4) AT 21
        SUBSTRING(b-tt-nota-fiscal.nat-operacao,1,8) AT 25
        b-tt-nota-fiscal.cod-emitente AT 33
        SUBSTRING(b-tt-nota-fiscal.nr-nota-fis,1,16) AT 45
        SUBSTRING(b-tt-nota-fiscal.pais,1,20) AT 61
        formatarDecimal(INPUT b-tt-nota-fiscal.peso-bru-tot,INPUT 3) AT 106
        formatarDecimal(INPUT b-tt-nota-fiscal.peso-liq-tot,INPUT 3) AT 118
        b-tt-nota-fiscal.serie AT 130
        formatarDecimal(INPUT b-tt-nota-fiscal.vl-embalagem,INPUT 2) AT 135
        formatarDecimal(INPUT b-tt-nota-fiscal.vl-frete,INPUT 2) AT 148
        formatarDecimal(INPUT b-tt-nota-fiscal.vl-mercad,INPUT 2) AT 161
        SUBSTRING(b-tt-nota-fiscal.bairro,1,30) AT 204
        b-tt-nota-fiscal.cep AT 234
        SUBSTRING(b-tt-nota-fiscal.cidade,1,25) AT 265
        IF b-tt-nota-fiscal.dt-emis-nota <> ? THEN STRING(b-tt-nota-fiscal.dt-emis-nota,"99999999") ELSE "" AT 338
        SUBSTRING(b-tt-nota-fiscal.endereco,1,40) AT 346
        b-tt-nota-fiscal.ins-estadual AT 386
        b-tt-nota-fiscal.moeda AT 425.
        
    FIND FIRST mgadm.repres NO-LOCK WHERE repres.cod-rep = b-tt-nota-fiscal.cod-rep NO-ERROR.
    IF AVAILABLE repres THEN
        PUT UNFORMATTED
            repres.nome-abrev AT 427.                                   

    PUT UNFORMATTED                            
        b-tt-nota-fiscal.nome-tr-red AT 439
        b-tt-nota-fiscal.nome-transp AT 451
        SUBSTRING(b-tt-nota-fiscal.nr-fatura,1,16) AT 464
        b-tt-nota-fiscal.nr-tabpre AT 480
        b-tt-nota-fiscal.nr-volumes AT 486
        STRING(b-tt-nota-fiscal.ind-lib-nota,"Sim/N∆o") AT 543
		formatarDecimal(INPUT 1,INPUT 8) AT 561.		
        /* DAC - 18/12/2020 - INCLUSAO DE CAMPOS OBRIGATORIOS QUE ESTAO FALTANDO */
        IF b-tt-nota-fiscal.nr-tab-finan <> 0 THEN            
        PUT UNFORMATTED b-tt-nota-fiscal.nr-tab-finan AT 594.
	 
    IF b-tt-nota-fiscal.nr-ind-finan <> 0 THEN 
        PUT UNFORMATTED b-tt-nota-fiscal.nr-ind-finan AT 597.
        
    PUT UNFORMATTED   
        b-tt-nota-fiscal.cod-portador AT 599
        b-tt-nota-fiscal.modalidade AT 604
        formatarDecimal(INPUT b-tt-nota-fiscal.vl-desc-tot,input 2) AT 6762
        b-tt-nota-fiscal.chave-acesso-nfe AT 8780
        b-tt-nota-fiscal.situacao-nfe AT 8840
        1 AT 8842
        b-tt-nota-fiscal.cod-estabel AT 8843                       
        b-tt-nota-fiscal.cod-cond-pag AT 8883 
        SKIP.                  
        
    FOR EACH item-nota-fiscal:                   
        PUT UNFORMATTED 
            "2" AT 1
            STRING(item-nota-fiscal.baixa-estoq,"Sim/N∆o") AT 2
            SUBSTRING(item-nota-fiscal.class-fiscal,1,12) AT 5
            SUBSTRING(item-nota-fiscal.it-codigo,1,16) AT 36
            SUBSTRING(item-nota-fiscal.nat-operacao,1,8) AT 60
            SUBSTRING(b-tt-nota-fiscal.nr-nota-fis,1,16) AT 68
            item-nota-fiscal.nr-seq-fat AT 84
            formatarDecimal(INPUT item-nota-fiscal.qt-faturada,INPUT 4) AT 135
            b-tt-nota-fiscal.serie AT 160
            item-nota-fiscal.un-fatur AT 170
            formatarDecimal(INPUT item-nota-fiscal.vl-frete,INPUT 2) AT 174
            formatarDecimal(INPUT item-nota-fiscal.vl-frete,INPUT 2) AT 198            
            formatarDecimal(INPUT item-nota-fiscal.vl-merc-liq,INPUT 2) AT 210
            formatarDecimal(INPUT item-nota-fiscal.vl-merc-ori,INPUT 2) AT 222
            formatarDecimal(INPUT item-nota-fiscal.vl-merc-tab,INPUT 2) AT 234            
            formatarDecimal(INPUT item-nota-fiscal.vl-preori-ped,INPUT 5) AT 246
            formatarDecimal(INPUT item-nota-fiscal.vl-pretab,INPUT 5) AT 260
            formatarDecimal(INPUT item-nota-fiscal.vl-preuni,INPUT 5) AT 274
            formatarDecimal(INPUT item-nota-fiscal.vl-tot-item,INPUT 2) AT 300
			formatarDecimal(INPUT 1,INPUT 8) AT 394			
            formatarDecimal(INPUT item-nota-fiscal.vl-desconto,input 2) AT 409
            formatarDecimal(INPUT item-nota-fiscal.aliquota-icm,INPUT 2) AT 423
            formatarDecimal(INPUT item-nota-fiscal.aliquota-ipi,INPUT 2) AT 433
            STRING(item-nota-fiscal.cd-trib-icm,"99") AT 443            
            item-nota-fiscal.cd-trib-ipi AT 445
            item-nota-fiscal.cd-trib-iss AT 447
            formatarDecimal(INPUT item-nota-fiscal.perc-red-icms,INPUT 4) AT 463
            formatarDecimal(INPUT item-nota-fiscal.vl-bicms-it,INPUT 2) AT 492
            formatarDecimal(INPUT item-nota-fiscal.vl-bipi-it,INPUT 2) AT 516
            formatarDecimal(INPUT item-nota-fiscal.vl-bsubs-it,INPUT 2) AT 552
            formatarDecimal(INPUT item-nota-fiscal.vl-icms-it,INPUT 2) AT 588
            formatarDecimal(INPUT item-nota-fiscal.vl-icms-nt,INPUT 2) AT 612
            formatarDecimal(INPUT item-nota-fiscal.vICMSST,INPUT 2) AT 636
            formatarDecimal(INPUT item-nota-fiscal.vl-ipi-it,INPUT 2) AT 660            
            formatarDecimal(INPUT item-nota-fiscal.vl-ipi-outros,INPUT 2) AT 672            
            formatarDecimal(INPUT item-nota-fiscal.vl-desconto,input 2) AT 2842
            b-tt-nota-fiscal.cod-estabel AT 2965            
            formatarDecimal(INPUT item-nota-fiscal.vBCUFDest     ,INPUT 2) AT 3218
            formatarDecimal(INPUT item-nota-fiscal.vBCFCPUFDest  ,INPUT 2) AT 3233
            formatarDecimal(INPUT item-nota-fiscal.pFCPUFDest    ,INPUT 4) AT 3248
            formatarDecimal(INPUT item-nota-fiscal.pICMSUFDest   ,INPUT 4) AT 3255
            formatarDecimal(INPUT item-nota-fiscal.pICMSInter    ,INPUT 4) AT 3262
            formatarDecimal(INPUT item-nota-fiscal.pICMSInterPart,INPUT 4) AT 3269
            formatarDecimal(INPUT item-nota-fiscal.vFCPUFDest    ,INPUT 2) AT 3276
            formatarDecimal(INPUT item-nota-fiscal.vICMSUFDest   ,INPUT 2) AT 3291
            formatarDecimal(INPUT item-nota-fiscal.vICMSUFRemet  ,INPUT 2) AT 3306            
            formatarDecimal(INPUT item-nota-fiscal.vl-pis  ,INPUT 2) AT 3419                      
            formatarDecimal(INPUT item-nota-fiscal.vl-base-pis  ,INPUT 2) AT 3431
            formatarDecimal(INPUT item-nota-fiscal.perc-pis  ,INPUT 4) AT 3443            
            formatarDecimal(INPUT item-nota-fiscal.vl-cofins  ,INPUT 2) AT 3464                      
            formatarDecimal(INPUT item-nota-fiscal.vl-base-cofins  ,INPUT 2) AT 3476
            formatarDecimal(INPUT item-nota-fiscal.perc-cofins  ,INPUT 4) AT 3488
            formatarDecimal(INPUT item-nota-fiscal.vBCFCPST  ,INPUT 2) AT 3495
            formatarDecimal(INPUT item-nota-fiscal.pFCPST    ,INPUT 4) AT 3510   
            formatarDecimal(INPUT item-nota-fiscal.vFCPST    ,INPUT 2) AT 3517
            SKIP.
            
        PUT UNFORMATTED 
            "8" AT 1
            item-nota-fiscal.it-codigo AT 2
            item-nota-fiscal.cod-depos AT 18
            IF item-nota-fiscal.dt-vali-lote <> ? THEN STRING(item-nota-fiscal.dt-vali-lote,"99999999") ELSE "" AT 41
            formatarDecimal(INPUT item-nota-fiscal.qt-faturada,input 4) AT 49
            item-nota-fiscal.nr-serlote AT 63
            item-nota-fiscal.cod-localiz AT 111
            SKIP. 
    END. 
    
    FOR EACH tt-fat-duplic:
        PUT UNFORMATTED 
            "4" AT 1
            1 AT 2 /* C‡DIGO DO VENCIMENTO */
            IF tt-fat-duplic.dt-venciment <> ? THEN STRING(tt-fat-duplic.dt-venciment,"99999999") ELSE "" AT 4
            SUBSTRING(tt-fat-duplic.parcela,1,2) AT 33
            formatarDecimal(INPUT tt-fat-duplic.vl-parcela,INPUT 2) AT 35
            formatarDecimal(INPUT tt-fat-duplic.vl-acum-dup,INPUT 2) AT 61
            tt-fat-duplic.cod-esp AT 74
            SKIP.        
    END.        

    PUT UNFORMATTED 
        "6" AT 1
        b-tt-nota-fiscal.serie AT 5
        SUBSTRING(b-tt-nota-fiscal.nr-nota-fis,1,16) AT 11
        "CX" AT 27
        b-tt-nota-fiscal.nr-volumes AT 30
        b-tt-nota-fiscal.cod-estabel AT 2112
        SKIP.
    
    PUT UNFORMATTED 
        "9" AT 1
        b-tt-nota-fiscal.cod-estabel AT 2
        b-tt-nota-fiscal.serie AT 7
        SUBSTRING(b-tt-nota-fiscal.nr-nota-fis,1,16) AT 12
        1 AT 28
        SKIP.   
                
    OUTPUT CLOSE.    
       
    RUN executarFT2015(INPUT c-arquivo,
                       OUTPUT p-rw-nota-fiscal).    
                       
    CATCH erro AS Progress.Lang.Error :
        CREATE tt-erro.
        ASSIGN tt-erro.i-sequen = 0
               tt-erro.cd-erro  = erro:GetMessageNum(1)
               tt-erro.mensagem = erro:GetMessage(1).                
    END CATCH. 
END PROCEDURE.

PROCEDURE executarFT2015 PRIVATE:
    
    DEFINE INPUT PARAMETER p-arquivo-nf AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-rw-nota-fiscal AS ROWID NO-UNDO.
    
    DEFINE VARIABLE raw-param AS RAW NO-UNDO.
    DEFINE VARIABLE c-arquivo-destino AS CHARACTER NO-UNDO.    
    
    EMPTY TEMP-TABLE tt-param-ft2015.
    EMPTY TEMP-TABLE tt-raw-digita-ft2015.    
    
    /*ASSIGN c-arquivo-destino = RIGHT-TRIM(RIGHT-TRIM(SESSION:TEMP-DIRECTORY,"/"),"\") + "/importacaoFT2015.txt".
    IF i-num-ped-exec-rpw > 0 THEN DO:
        FIND FIRST ped_exec NO-LOCK
             WHERE ped_exec.num_ped_exec = i-num-ped-exec-rpw NO-ERROR.
        FIND FIRST servid_exec NO-LOCK
             WHERE servid_exec.cod_servid_exec = ped_exec.cod_servid_exec NO-ERROR.
        ASSIGN c-arquivo-destino = /*(IF servid_exec.nom_dir_spool_url <> "" THEN servid_exec.nom_dir_spool_url ELSE RIGHT-TRIM(RIGHT-TRIM(SESSION:TEMP-DIRECTORY,"/"),"\")) +*/ "\\192.168.7.27\AreaGeral\RPW\importacaoFT2015.txt".
    END.*/
    
    ASSIGN c-arquivo-destino = RIGHT-TRIM(RIGHT-TRIM(SESSION:TEMP-DIRECTORY,"/"),"\") + "/importacaoFT2015.txt".
    IF i-num-ped-exec-rpw > 0 THEN DO:
        FIND FIRST ped_exec NO-LOCK
             WHERE ped_exec.num_ped_exec = i-num-ped-exec-rpw NO-ERROR.
        FIND FIRST servid_exec NO-LOCK
             WHERE servid_exec.cod_servid_exec = ped_exec.cod_servid_exec NO-ERROR.
        ASSIGN c-arquivo-destino = servid_exec.nom_dir_spool + "\" + ped_exec.cod_usuario + "\importacaoFT2015.txt".
    END.

    OS-DELETE VALUE(c-arquivo-destino). 

    CREATE tt-param-ft2015.
    ASSIGN tt-param-ft2015.destino     = 2
           tt-param-ft2015.arq-destino = IF i-num-ped-exec-rpw = 0 THEN c-arquivo-destino ELSE "\importacaoFT2015.txt" //c-arquivo-destino
           tt-param-ft2015.arq-entrada = p-arquivo-nf           
           tt-param-ft2015.usuario     = v_cod_usuar_corren
           tt-param-ft2015.data-exec   = TODAY 
           tt-param-ft2015.hora-exec   = TIME
           tt-param-ft2015.l-importa   = FALSE.
    
    RAW-TRANSFER tt-param-ft2015 TO raw-param.  
    
    RUN ftp/ft2015rp.p(INPUT raw-param,
                       INPUT TABLE tt-raw-digita-ft2015).

                       
    RUN lerLogImportacao(INPUT c-arquivo-destino,
                         OUTPUT p-rw-nota-fiscal).

END PROCEDURE.

PROCEDURE lerLogImportacao:
    
    DEFINE INPUT PARAMETER c-arquivo AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-rw-nota-fiscal AS ROWID NO-UNDO.
    
    DEFINE VARIABLE c-linha AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i-linha AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-linha-erro AS INTEGER NO-UNDO. 
    DEFINE VARIABLE i-linha-nf AS INTEGER NO-UNDO. 
    DEFINE VARIABLE c-cod-estabel AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-serie AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-nr-nota-fis AS CHARACTER NO-UNDO.        
    
    INPUT FROM VALUE(c-arquivo) NO-CONVERT.
    REPEAT:
        IMPORT UNFORMATTED c-linha.
        ASSIGN i-linha = i-linha + 1.
        
        IF c-linha MATCHES "*NOTAS REJEITADAS*" THEN 
            ASSIGN i-linha-erro = i-linha + 5.                        
        
        IF c-linha MATCHES "*NOTAS IMPORTADAS*" THEN
            ASSIGN i-linha-nf = i-linha + 5.
        
        IF i-linha = i-linha-erro THEN DO:                        
            IF TRIM(c-linha) /*SUBSTRING(c-linha,1,1)*/ = "" THEN DO:                   
                ASSIGN i-linha-erro = 0.
            END.
            ELSE DO:     
                CREATE tt-erro.
                ASSIGN tt-erro.cd-erro  = INTEGER(SUBSTRING(c-linha,52,5)) NO-ERROR.
                ASSIGN tt-erro.mensagem = SUBSTRING(c-linha,58).
            END.            
            ASSIGN i-linha-erro = i-linha-erro + 1.                                          
        END.   
        
        IF i-linha = i-linha-nf THEN DO:            
            IF TRIM(c-linha) /*SUBSTRING(c-linha,1,1)*/ = "" THEN DO:                   
                ASSIGN i-linha-nf = 0.
            END.
            ELSE DO:                                                         
                ASSIGN c-cod-estabel = SUBSTRING(c-linha,1,5)
                       c-serie       = SUBSTRING(c-linha,7,5)
                       c-nr-nota-fis = SUBSTRING(c-linha,13,16).                                                   
                       
                FIND FIRST nota-fiscal WHERE nota-fiscal.cod-estabel = c-cod-estabel
                                       AND   nota-fiscal.serie       = c-serie
                                       AND   nota-fiscal.nr-nota-fis = c-nr-nota-fis
                                       NO-LOCK NO-ERROR.
                IF AVAILABLE(nota-fiscal) THEN
                    ASSIGN p-rw-nota-fiscal = ROWID(nota-fiscal).        
            END.            
            ASSIGN i-linha-nf = i-linha-nf + 1.                                          
        END.                                                 
    END.    
    INPUT CLOSE.                       
END PROCEDURE.


/* ************************  Function Implementations ***************** */

FUNCTION formatarDecimal RETURNS CHARACTER(INPUT p-valor AS DECIMAL,
                                           INPUT p-qtde-decimal AS INTEGER):

    DEFINE VARIABLE c-valor-formatado AS CHARACTER NO-UNDO.

    ASSIGN c-valor-formatado = STRING(p-valor,"->>>>>>>>>>>>>>9." + FILL("9",p-qtde-decimal)) 
           c-valor-formatado = REPLACE(c-valor-formatado,",","")
           c-valor-formatado = TRIM(c-valor-formatado) NO-ERROR.                    
    
    RETURN c-valor-formatado.        
END FUNCTION.
