CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/* DEFINE VAR iXML AS LONGCHAR NO-UNDO.                                            */
/* DEFINE VAR oXML AS LONGCHAR NO-UNDO.                                            */
/*                                                                                 */
/* ASSIGN iXML = "<?xml version='1.0' encoding='utf-8'?>                           */
/* <MENSAGEM>                                                                      */
/*   <CABECALHO>                                                                   */
/*     <IdentidadeEmissor>AA309D5D-211A-4C2B-B685-7CE1A25469ED</IdentidadeEmissor> */
/*     <NumeroOperacao>Leandro-04304522922</NumeroOperacao>                        */
/*     <CodigoMensagem>MSG0307</CodigoMensagem>                                    */
/*   </CABECALHO>                                                                  */
/*   <CONTEUDO>                                                                    */
/*     <MSG0307>                                                                   */
/*       <CpfCnpjCodEstrangeiro>93690800900</CpfCnpjCodEstrangeiro>                */
/*       <CodigoProduto>9910013</CodigoProduto>                                    */
/*       <PrecoItem>10</PrecoItem>                                                 */
/*       <ValorOperadora>15</ValorOperadora>                                       */
/*       <DataPagamento>2018-05-02</DataPagamento>                                 */
/*       <IDPagamento>993520008</IDPagamento>                                      */
/*       <Observacoes>observa</Observacoes>                                        */
/*     </MSG0307>                                                                  */
/*   </CONTEUDO>                                                                   */
/* </MENSAGEM>".                                                                   */

{esp/esb/in/msg0307.i}
{method/dbotterr.i}

DEFINE TEMP-TABLE ttWt-docto NO-UNDO LIKE wt-docto
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE ttWt-it-docto NO-UNDO LIKE wt-it-docto
    FIELD r-rowid AS ROWID.

DEF TEMP-TABLE tt-notas-geradas NO-UNDO
    FIELD rw-nota-fiscal AS   ROWID
    FIELD nr-nota        LIKE nota-fiscal.nr-nota-fis
    FIELD seq-wt-docto   LIKE wt-docto.seq-wt-docto.

DEFINE VARIABLE l-procedimento-ok           AS LOGICAL       NO-UNDO.
DEFINE VARIABLE ultprocesso                 AS CHARACTER     NO-UNDO.
DEFINE VARIABLE c-ultimo-metodo-exec        AS CHARACTER     NO-UNDO.
DEFINE VARIABLE l-proc-ok-aux               AS LOGICAL       NO-UNDO.
DEFINE VARIABLE h-bodi317                   AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-bodi317in                 AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-bodi317pr                 AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-bodi317sd                 AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-bodi317im1bra             AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-bodi317va                 AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-bodi321                   AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-bodi317ef                 AS HANDLE        NO-UNDO.
DEFINE VARIABLE l-fifo                      AS LOG INIT NO   NO-UNDO.
DEFINE VARIABLE c-modelo                    AS CHARACTER     NO-UNDO.
DEFINE VARIABLE cSerie                      LIKE serie.serie                NO-UNDO VIEW-AS FILL-IN SIZE 08 BY 0.88.
DEFINE VARIABLE cNatOper                    LIKE natur-oper.nat-operacao    NO-UNDO VIEW-AS FILL-IN SIZE 10 BY 0.88.
DEFINE VARIABLE c-char-aux                  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE i-seq-wt-docto              AS INTEGER      NO-UNDO.
DEFINE VARIABLE iSeqWtDocto                 AS INTEGER      NO-UNDO.
DEFINE VARIABLE iSeqWtItDocto               AS INTEGER      NO-UNDO.
DEFINE VARIABLE l-erro                      AS LOGICAL      NO-UNDO.
DEFINE VARIABLE i-seq                       AS INTEGER      NO-UNDO INITIAL 0.
DEFINE VARIABLE h-acomp                     AS HANDLE       NO-UNDO.
DEFINE VARIABLE i-nr-pedcli-venda           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c-nome-abrev-venda          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE c-estab AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-serie AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-natur AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-nf-man-dev-terc-dif AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-recal-apenas-totais AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-transp-branco AS LOGICAL     NO-UNDO.

DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE DATASET mensagem xml-node-name 'MENSAGEM' FOR cabecalho, conteudo, msg0307
   DATA-RELATION FOR conteudo, msg0307                      RELATION-FIELDS (idm, idm) NESTED.


DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0307r, resultado
   DATA-RELATION FOR conteudor, msg0307r                      RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0307r, resultado                      RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0307R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST msg0307 NO-ERROR.

CREATE conteudor.
CREATE resultado.
CREATE msg0307r.
ASSIGN msg0307r.CpfCnpjCodEstrangeiro = msg0307.CpfCnpjCodEstrangeiro.

FOR FIRST msg0307:
    cria-nf:
    DO TRANS ON ENDKEY UNDO cria-nf, LEAVE cria-nf 
             ON ERROR  UNDO cria-nf, LEAVE cria-nf:
        RUN pi-wt-docto.

        IF RETURN-VALUE <> "OK" THEN DO:
            UNDO cria-nf, LEAVE cria-nf.
        END.
    END.

    RUN pi-limpa-handle.
END.

IF  RETURN-VALUE <> "OK" THEN DO:
    ASSIGN resultado.sucesso    = no
           resultado.CodigoErro = 17006
           resultado.Mensagem    = "".

    FOR EACH tt-erro
        BREAK BY Mensagem:
        ASSIGN resultado.Mensagem =  resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.

DATASET mensagemr:WRITE-XML('longchar', oXML, NO).

/* define variable hDoc    as handle   no-undo.                                            */
/* create x-document hDoc.                                                                 */
/* hDoc:LOAD("longchar", oXML, NO).                                                        */
/* hDoc:SAVE("file","C:/temp/oXML" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */

RETURN.

PROCEDURE pi-wt-docto:
    EMPTY TEMP-TABLE tt-erro.

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cgc = msg0307.CpfCnpjCodEstrangeiro NO-ERROR.

    IF NOT AVAIL emitente THEN DO:
        RUN pi-erro(INPUT "Emitente n∆o cadastrado.").
    END.

    FIND FIRST int-emitente NO-LOCK
         WHERE int-emitente.cod-emitente = emitente.cod-emitente
           AND int-emitente.id-ativo NO-ERROR.

    IF NOT AVAIL int-emitente THEN DO:
        RUN pi-erro(INPUT "Emitente inativo.").
    END.

    IF CAN-FIND(FIRST tt-erro) THEN DO:
        RETURN "NOK".
    END.
    
    RUN dibo/bodi317in.p PERSISTENT SET h-bodi317in.
    RUN inicializaBOS IN h-bodi317in(OUTPUT h-bodi317pr,
                                     OUTPUT h-bodi317sd,     
                                     OUTPUT h-bodi317im1bra,
                                     OUTPUT h-bodi317va).
    
    /* VERIFICA CLIENTE SUSPENSO */
    IF  AVAIL emitente 
    AND emitente.ind-cre-cli = 4 THEN DO:

        FIND FIRST int-emitente EXCLUSIVE-LOCK
             WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.

        FIND CURRENT emitente EXCLUSIVE-LOCK NO-ERROR.

        IF  AVAIL int-emitente THEN DO:
            ASSIGN emitente.ind-cre-cli = 5    /* pagamento a vista */.
        END.

        FIND CURRENT emitente NO-LOCK NO-ERROR.
        FIND CURRENT int-emitente NO-LOCK NO-ERROR.
    END.

    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT "msg0307":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR EACH tt-prog-ponto:
        /*estab*/
        IF tt-prog-ponto.sequencia = 1 THEN
            ASSIGN c-estab = tt-prog-ponto.conteudo.
        /*serie*/
        IF tt-prog-ponto.sequencia = 2 THEN
            ASSIGN c-serie = tt-prog-ponto.conteudo.
        /*natur*/
        IF tt-prog-ponto.sequencia = 3 THEN
            ASSIGN c-natur = tt-prog-ponto.conteudo.
    END.

    RUN criaWtDocto IN h-bodi317sd (INPUT  "integra",
                                    INPUT  c-estab,
                                    INPUT  c-serie,
                                    INPUT  "1",                 /* nr nota fiscal */
                                    INPUT  emitente.nome-abrev,
                                    INPUT  ?,                   /* nr pedido venda */
                                    INPUT  4,                   /* nf complementar */
                                    INPUT  4003,                /* programa emissor */
                                    INPUT  TODAY,               /* dt emissao */
                                    INPUT  0,                   /* embarque */
                                    INPUT  c-natur,
                                    INPUT  8,                   /* canal vendas */
                                    OUTPUT i-seq-wt-docto,
                                    OUTPUT l-proc-ok-aux).

    RUN devolveErrosbodi317sd IN h-bodi317sd(OUTPUT c-ultimo-metodo-exec, 
                                             OUTPUT TABLE RowErrors).

    FIND FIRST RowErrors 
         WHERE RowErrors.ErrorSubType = 'Error' NO-ERROR.

    IF  AVAIL RowErrors THEN DO:
        FOR EACH RowErrors
            WHERE RowErrors.ErrorSubType = 'Error':
            RUN pi-erro (INPUT RowErrors.ErrorDescription + " - " +  string(RowErrors.ErrorNum)).
        END.
        RETURN "NOK".
    END.

    IF  NOT VALID-HANDLE(h-acomp) THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    RUN pi-inicializar IN h-acomp (INPUT "Criando Itens").

    RUN piCriaWt-itens (INPUT i-seq-wt-docto).

    IF RETURN-VALUE = "NOK" THEN DO:
        RETURN "NOK".
    END.

    RUN pi-atualiza-nota.

    IF RETURN-VALUE = "NOK" THEN DO:
        RETURN "NOK".
    END.

    RETURN "OK".
END.


PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

END PROCEDURE.


PROCEDURE piCriaWt-itens.
    DEF INPUT PARAM iSeqWtDocto AS INTEGER.
    
    FIND FIRST wt-docto NO-LOCK
         WHERE wt-docto.seq-wt-docto = iSeqWtDocto NO-ERROR.

    FIND CURRENT wt-docto EXCLUSIVE-LOCK.
    ASSIGN wt-docto.observ-nota = msg0307.Observacoes + " ".
    FIND CURRENT wt-docto NO-LOCK.

    ASSIGN l-erro = NO.

    RUN pi-acompanhar IN h-acomp (INPUT "Atualizando Documento").

    ASSIGN i-seq = i-seq + 10.

    RUN localizaWtDocto IN h-bodi317sd (INPUT iSeqWtDocto, 
                                        OUTPUT l-procedimento-ok).

    RUN criaWtItDocto IN h-bodi317sd (?,
                                      '',
                                      i-seq,
                                      msg0307.CodigoProduto,
                                      '',
                                      wt-docto.nat-oper,
                                      OUTPUT iSeqWtItDocto,
                                      OUTPUT l-procedimento-ok).

    IF NOT l-procedimento-ok THEN DO:
       RUN devolveErrosBodi317sd IN h-bodi317sd (OUTPUT ultprocesso, 
                                                 OUTPUT TABLE RowErrors).

       IF CAN-FIND(FIRST RowErrors 
                   WHERE RowErrors.ErrorSubType = 'Error') THEN DO:

           FOR EACH RowErrors
              WHERE RowErrors.ErrorSubType = 'Error':
               RUN pi-erro (INPUT RowErrors.ErrorDescription + " - " +  string(RowErrors.ErrorNum)).
           END.

           RETURN "NOK".
       END.
    END.
    
    FIND FIRST ITEM NO-LOCK 
         WHERE ITEM.it-codigo = msg0307.CodigoProdut NO-ERROR.

     /* Grava informaá‰es gerais para o item da nota */
    RUN gravaInfGeraisWtItDocto in h-bodi317sd (INPUT iSeqWtDocto,
                                                INPUT iSeqWtItDocto,
                                                INPUT 1,
                                                INPUT msg0307.PrecoItem,
                                                INPUT 0,
                                                INPUT 0).                    

    RUN dibo/bodi321.p PERSISTENT SET h-bodi321.       

    RUN openQueryStatic IN h-bodi321 ('default').
    RUN gotoKey         IN h-bodi321 (iSeqWtDocto, iSeqWtItDocto).
    RUN getRecord       IN h-bodi321 (OUTPUT TABLE ttWt-It-docto).

    FIND FIRST ttWt-it-docto NO-LOCK NO-ERROR.
    
    ASSIGN ttWt-It-docto.narrativa = 'Faturamento recorrente - narrativa'. 

    ASSIGN ttwt-it-docto.quantidade[2]   = 1
           ttwt-it-docto.un[2]           = ITEM.un
           ttwt-it-docto.peso-bru-it-inf = 0
           ttwt-it-docto.vl-preuni       = msg0307.PrecoItem
           ttwt-it-docto.vl-merc-ori     = msg0307.PrecoItem
           ttwt-it-docto.vl-merc-liq     = msg0307.PrecoItem
           ttwt-it-docto.vl-tot-item     = msg0307.PrecoItem
           ttwt-it-docto.cod-unid-negoc  = "ADM".
           ttwt-it-docto.class-fiscal    = ITEM.class-fiscal.  
     
    RUN setRecord    IN h-bodi321 (TABLE ttWt-It-docto).
    RUN updateRecord IN h-bodi321.
    
    IF RETURN-VALUE = 'NOK' THEN DO:
       RUN getRowErrors IN h-bodi321 (OUTPUT TABLE RowErrors).

       IF CAN-FIND(FIRST RowErrors 
                   WHERE RowErrors.ErrorSubType = 'Error') THEN DO:

           FOR EACH RowErrors
              WHERE RowErrors.ErrorSubType = 'Error':
               RUN pi-erro (INPUT RowErrors.ErrorDescription + " - " +  string(RowErrors.ErrorNum)).
           END.

           RETURN "NOK".
       END.
    END.
    
    RUN emptyRowErrors IN h-bodi317in.

    CREATE wt-fat-duplic.
    ASSIGN wt-fat-duplic.seq-wt-docto        = iseqwtdocto
           wt-fat-duplic.parcela             = '1'
           wt-fat-duplic.dt-venciment        = TODAY + 2
           wt-fat-duplic.vl-parcela          = msg0307.PrecoItem.

    IF  VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    RETURN "OK".
END.

PROCEDURE pi-atualiza-nota:

    FIND FIRST wt-docto NO-LOCK
         WHERE wt-docto.seq-wt-docto = i-seq-wt-docto NO-ERROR. 

    FOR FIRST wt-fat-duplic
        FIELDS () NO-LOCK
        WHERE wt-fat-duplic.seq-wt-docto = wt-docto.seq-wt-docto:
    END.
        
    RUN inicializaAcompanhamento IN h-bodi317pr.
    RUN retornaVariaveisParaCalculoImpostos IN h-bodi317sd (INPUT  wt-docto.seq-wt-docto,
                                                            OUTPUT l-nf-man-dev-terc-dif,
                                                            OUTPUT l-recal-apenas-totais,
                                                            OUTPUT l-proc-ok-aux).

    RUN recebeVariavelTipoCalculoImpostos IN h-bodi317im1bra (INPUT IF l-recal-apenas-totais then 
                                                                        1
                                                                    ELSE 
                                                                        0,
                                                              OUTPUT l-proc-ok-aux).

    RUN setaValidaExp   IN h-bodi317va(INPUT YES).
    RUN confirmaCalculo IN h-bodi317pr(INPUT wt-docto.seq-wt-docto,
                                       OUTPUT l-proc-ok-aux).

    RUN finalizaAcompanhamento   IN h-bodi317pr.
    RUN devolveErrosbodi317pr    IN h-bodi317pr(OUTPUT c-ultimo-metodo-exec,
                                                OUTPUT TABLE RowErrors).

    FIND FIRST RowErrors
         WHERE RowErrors.ErrorSubType = 'Error' NO-ERROR.

    IF AVAIL RowErrors THEN DO:
        FOR EACH RowErrors
           WHERE RowErrors.ErrorSubType = 'Error':
            RUN pi-erro (INPUT RowErrors.ErrorDescription + " - " +  string(RowErrors.ErrorNum)).
        END.
        RETURN "NOK".
    END.
    
    RUN dibo/bodi317ef.p PERSISTENT SET h-bodi317ef.
    RUN emptyRowErrors           IN h-bodi317in.
    RUN inicializaAcompanhamento IN h-bodi317ef.
    RUN setaHandlesBOS           IN h-bodi317ef(h-bodi317pr,     h-bodi317sd, 
                                                h-bodi317im1bra, h-bodi317va).

    RUN efetivaNota IN h-bodi317ef(INPUT wt-docto.seq-wt-docto,
                                   INPUT IF wt-docto.ind-tip-nota = 2  
                                         OR (wt-docto.ind-tip-nota = 5 /* Nota de Entrada */ 
                                             AND INT(wt-docto.nr-nota) > 1)THEN 
                                                NO 
                                         ELSE 
                                             YES,
                                   OUTPUT l-proc-ok-aux).
                                             
    RUN finalizaAcompanhamento IN h-bodi317ef.
    RUN devolveErrosbodi317ef  IN h-bodi317ef(OUTPUT c-ultimo-metodo-exec,
                                              OUTPUT TABLE RowErrors).
    
    FIND FIRST RowErrors 
         WHERE RowErrors.ErrorSubType = 'Error' NO-ERROR.

    IF AVAIL RowErrors THEN DO:
        FOR EACH RowErrors
           WHERE RowErrors.ErrorSubType = 'Error':
            RUN pi-erro (INPUT RowErrors.ErrorDescription + " - " +  string(RowErrors.ErrorNum)).
        END.
        RETURN "NOK".
    END.
    
    IF NOT l-proc-ok-aux THEN DO:
        RUN pi-erro(INPUT "Erro na efetivaá∆o da nota.").
        RETURN "NOK".
    END.
    
    RUN buscaTTNotasGeradas IN h-bodi317ef(OUTPUT l-proc-ok-aux,
                                           OUTPUT TABLE tt-notas-geradas).

    FIND FIRST tt-notas-geradas.

    FIND FIRST nota-fiscal NO-LOCK
         WHERE ROWID(nota-fiscal) = tt-notas-geradas.rw-nota-fiscal NO-ERROR.

    FIND FIRST int-nota-fiscal EXCLUSIVE-LOCK                          
         WHERE int-nota-fiscal.cod-estab   = nota-fiscal.cod-estabel
           AND int-nota-fiscal.serie       = nota-fiscal.serie       
           AND int-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.

    IF NOT AVAILABLE int-nota-fiscal THEN DO:
       CREATE int-nota-fiscal.
       ASSIGN int-nota-fiscal.cod-estab   = nota-fiscal.cod-estabel
              int-nota-fiscal.serie       = nota-fiscal.serie
              int-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis.
    END.
    
    ASSIGN int-nota-fiscal.id-pagto-cartao = msg0307.IDPagamento.
    RELEASE int-nota-fiscal.

    /*Imprime log*/
    OUTPUT TO VALUE (SESSION:TEMP-DIRECTORY + REPLACE(STRING(TODAY),"/","-") + "-msg0307.csv") APPEND.
    
    IF SEARCH(SESSION:TEMP-DIRECTORY + REPLACE(STRING(TODAY),"/","-") + "-msg0307.csv") = ? THEN DO:
        PUT UNFORMATTED "Estabelecimento;Serie;Nr Nota;Data Emiss∆o;Nome Abrev;Nome Cliente;Valor Total NF;Hora Geraá∆o;ID Pagamento;" SKIP.
    END.

    PUT UNFORMATTED nota-fiscal.cod-estabel     + ";" +
                    nota-fiscal.serie           + ";" +
                    nota-fiscal.nr-nota-fis     + ";" +
                    string(nota-fiscal.dt-emis) + ";" +
                    emitente.nome-abrev         + ";" +
                    emitente.nome-emit          + ";" +
                    string(nota-fiscal.vl-tot-nota) + ";" +
                    STRING(TIME, "HH:MM:SS":U) + ";" +
                    msg0307.IDPagamento SKIP.


    OUTPUT CLOSE.

    /*Gera retorno*/
    ASSIGN msg0307r.CodigoEstabelecimento = nota-fiscal.cod-estabel
           msg0307r.NumeroSerie           = nota-fiscal.serie
           msg0307r.NumeroNotaFiscal      = nota-fiscal.nr-nota-fis
           msg0307r.Observacoes           = nota-fiscal.observ-nota.

    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-limpa-handle:
    IF VALID-HANDLE(h-bodi317) THEN DO:
        DELETE PROCEDURE h-bodi317.
        ASSIGN h-bodi317 = ?.
    END.

    IF VALID-HANDLE(h-bodi317in) THEN DO:
        DELETE PROCEDURE h-bodi317in.
        ASSIGN h-bodi317in = ?.
    END.

    IF VALID-HANDLE(h-bodi317pr) THEN DO:
        DELETE PROCEDURE h-bodi317pr.
        ASSIGN h-bodi317pr = ?.
    END.

    IF VALID-HANDLE(h-bodi317sd) THEN DO:
        DELETE PROCEDURE h-bodi317sd.
        ASSIGN h-bodi317sd = ?.
    END.

    IF VALID-HANDLE(h-bodi317im1bra) THEN DO:
        DELETE PROCEDURE h-bodi317im1bra.
        ASSIGN h-bodi317im1bra = ?.
    END.

    IF VALID-HANDLE(h-bodi317va) THEN DO:
        DELETE PROCEDURE h-bodi317va.
        ASSIGN h-bodi317va = ?.
    END.

    IF VALID-HANDLE(h-bodi317ef) THEN DO:
        DELETE PROCEDURE h-bodi317ef.
        ASSIGN h-bodi317ef = ?.
    END.

    IF VALID-HANDLE(h-bodi321) THEN DO:
        DELETE PROCEDURE h-bodi321.
        ASSIGN h-bodi321 = ?.
    END.
END.
