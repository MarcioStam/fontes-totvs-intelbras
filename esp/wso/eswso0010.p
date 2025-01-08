DEFINE TEMP-TABLE tt-item NO-UNDO
    field it-codigo            LIKE ped-item.it-codigo
    FIELD log-servico          AS LOG
    field cod-estabel          AS CHAR
    field nat-operacao         LIKE ped-item.nat-operacao
    field preco-unit           LIKE ped-item.vl-preuni
    field quant-min            LIKE ped-item.qt-pedida
    FIELD parentKit            LIKE ped-item.it-codigo
    FIELD segmento             LIKE int-segmento-portifolio.descricao
    FIELD nr-tabpre            LIKE preco-item.nr-tabpre
    FIELD kit-desconto         AS DECIMAL
    field perc-desconto        as DECIMAL
    field perc-desc-qt         as decimal
    FIELD desc-indice-finan    AS DECIMAL 
    FIELD val-desconto         AS DECIMAL 
    field vl-pis               AS DECIMAL
    FIELD perc-pis             AS DECIMAL
    field vl-iss               AS DECIMAL
    FIELD perc-iss             AS DECIMAL
    field vl-icms              AS DECIMAL
    FIELD perc-icms            AS DECIMAL
    field vl-icmsst            AS DECIMAL
    field vl-ipi               AS DECIMAL
    field perc-ipi             AS DECIMAL
    field vl-cofins            AS DECIMAL
    FIELD perc-cofins          AS DECIMAL
    field preco-total          AS DECIMAL
    FIELD fator-desconto       AS DECIMAL DECIMALS 4
    FIELD desconto-maisverde   AS decimal
    FIELD desconto-topmilhao   AS decimal
    FIELD desconto-focounid    AS decimal
    FIELD desconto-distrib20   AS decimal
    FIELD desconto-widecloud   AS DECIMAL.

DEFINE TEMP-TABLE tt-item-totvs LIKE tt-item
    FIELD i-tributacao    AS INTEGER // 1-NENHUM / 2-PARCIAL / 3-TOTAL / 4-DIGITADO-MAIOR
    FIELD val-inicial     AS DECIMAL
    FIELD preco-venda     AS DECIMAL
    FIELD fator-calc-desc AS DECIMAL
    FIELD val-desconto-comercial AS DECIMAL
    FIELD val-desconto-pci       AS DECIMAL
    FIELD de-rol          AS DECIMAL.

DEF TEMP-TABLE tt-log NO-UNDO
    FIELD seq AS INT
    FIELD cod-estabel LIKE estabelec.cod-estabel
    FIELD it-codigo   LIKE ITEM.it-codigo
    FIELD mensagem    AS CHAR.

DEFINE TEMP-TABLE tt-erro  NO-UNDO
       FIELD codigo     AS INT
       FIELD informacao AS CHAR
       FIELD mensagem   AS CHARACTER FORMAT "x(250)".

DEF TEMP-TABLE rowerrors   NO-UNDO    /* Temp-table dos erros */
    FIELD errorsequence    AS INT
    FIELD errornumber      AS INT
    FIELD errordescription AS CHAR FORMAT "x(150)"
    FIELD errorparameters  AS CHAR
    FIELD errortype        AS CHAR
    FIELD errorhelp        AS CHAR FORMAT "x(150)"
    FIELD errorsubtype     AS CHARACTER.

def temp-table tt-param-2 /* Utilizada no ft4015rp */
    field destino         as int
    field arquivo         as char
    field usuario         as char form "x(12)":U
    field data-exec       as date
    field hora-exec       as int
    field classifica      as int
    field desc-classifica as char form "x(40)":U.

DEFINE TEMP-TABLE ttWt-docto NO-UNDO LIKE wt-docto
           field r-rowid as rowid.
DEFINE TEMP-TABLE ttWt-it-docto NO-UNDO LIKE wt-it-docto
           field r-rowid as rowid.

DEFINE TEMP-TABLE tt-prog-ponto NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.

DEFINE TEMP-TABLE tt-prog-ponto2 NO-UNDO LIKE tt-prog-ponto.

DEF TEMP-TABLE tt-estabelec NO-UNDO
    FIELD cod-estabel LIKE estabelec.cod-estabel
    FIELD log-servico AS LOGICAL.

def temp-table tt-documentos no-undo
    field seq-wt-docto as int
    index codigo
          seq-wt-docto. 

DEFINE BUFFER b-unid-feder FOR unid-feder.
DEF BUFFER bf-wt-docto      FOR wt-docto.
DEF BUFFER bf-wt-it-docto   FOR wt-it-docto.
DEF BUFFER bf-wt-it-imposto FOR wt-it-imposto.

DEFINE INPUT PARAM c-tab-preco             AS CHARACTER   NO-UNDO.
DEFINE INPUT PARAM c-finalidade            AS CHARACTER   NO-UNDO.
DEFINE INPUT PARAM i-cond-pag              AS INTEGER     NO-UNDO. 
DEFINE INPUT PARAM c-natureza-cliente      AS CHAR        NO-UNDO.
DEFINE INPUT PARAM log-contribuinte-icms   AS CHAR        NO-UNDO.
DEFINE INPUT PARAM c-inscricao-estadual    AS CHAR        NO-UNDO.
DEFINE INPUT PARAM c-cod-suframa           AS CHARACTER   NO-UNDO.
DEFINE INPUT PARAM c-uf                    AS CHARACTER   NO-UNDO.
DEFINE INPUT PARAM c-cep                   AS CHARACTER   NO-UNDO.
DEFINE INPUT PARAM c-cliente-alc           AS CHAR        NO-UNDO.
DEFINE INPUT PARAM c-regime-especial       AS CHARACTER   NO-UNDO.
DEFINE INPUT PARAM c-tipo-tributacao       AS CHARACTER   NO-UNDO.
DEFINE INPUT PARAM i-cliente               AS INT         NO-UNDO.
DEFINE INPUT PARAM shippingHandling        AS DECIMAL     NO-UNDO.   
DEFINE INPUT PARAM typeOfTrading           AS CHAR        NO-UNDO.
DEF INPUT-OUTPUT PARAMETER TABLE FOR tt-item.
DEF OUTPUT PARAMETER TABLE FOR tt-erro .

/* Local Variable Definitions ---                                       */
DEF NEW GLOBAL SHARED VARIABLE adm-broker-hdl              AS HANDLE  NO-UNDO.
DEF NEW GLOBAL SHARED VARIABLE g-cod-emitente-bodi317im1br AS INTEGER.
DEF NEW GLOBAL SHARED VARIABLE g-codigo-orig-bodi317sd     AS INTEGER.

DEFINE VARIABLE i-seq-wt-it-docto AS INTEGER     NO-UNDO.

/* definiªío de variˇveis  */
DEFINE VARIABLE h-acomp as handle no-undo.
DEFINE VARIABLE i-anterior as integer no-undo.
DEFINE VARIABLE i-atual    as integer no-undo.
DEFINE VARIABLE c-indice   as CHAR    no-undo.
DEFINE VARIABLE i-cont-nota    AS INTEGER NO-UNDO.
DEFINE VARIABLE l-proc-ok-aux  AS LOGICAL NO-UNDO.
DEFINE VARIABLE h-bodi317in    AS HANDLE  NO-UNDO.
DEFINE VARIABLE de-desc-item    AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-perc-icmsred AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-indice-finan AS DECIMAL DECIMALS 5.
DEFINE VARIABLE de-fator-cli    AS DECIMAL NO-UNDO.
//DEFINE VARIABLE d-fator         AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-vl-preco     AS DECIMAL NO-UNDO.
//DEFINE VARIABLE tt-item-totvs.preco-venda  AS DECIMAL NO-UNDO. 
DEFINE VARIABLE de-preco-venda-ajust AS DEC NO-UNDO.
DEFINE VARIABLE c-serie                 AS CHARACTER NO-UNDO.
DEFINE VARIABLE de-icm                  AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-pis                  AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-aliq-zfm             AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-tot-ZFM              AS DECIMAL NO-UNDO.
DEFINE VARIABLE wh-pesquisa             AS WIDGET-HANDLE  NO-UNDO.
DEFINE VARIABLE h-bodi317               AS HANDLE         NO-UNDO.
DEFINE VARIABLE h-bodi317im1bra         AS HANDLE         NO-UNDO.
DEFINE VARIABLE h-boin404te             as handle         no-undo.
DEFINE VARIABLE h-bodi321               AS HANDLE         NO-UNDO.
DEFINE VARIABLE h-cdapi995              AS HANDLE         NO-UNDO.
DEFINE VARIABLE h-bodi159cal            as handle         no-undo.
DEFINE VARIABLE l-erro                  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-return                AS LOGICAL     NO-UNDO.
DEFINE VARIABLE h-boes505               AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-nat-oper              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-consumidor-final      AS LOGICAL     NO-UNDO.
DEFINE VARIABLE de-aliquota-ipi         AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-preco                AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-perc-icms            AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-perc-iss             AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-descto-zf            AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-desc-pis-zfm         AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-desc-cofins-zfm      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-per-des-icms         AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-fator                AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-fator-preco-total    AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-ipi-st-sem-desc-coml AS DECIMAL DECIMALS 4 NO-UNDO.
DEFINE VARIABLE c-estab                 LIKE estabelec.cod-estabel.
DEFINE VARIABLE de-aliq-pis             AS DECIMAL FORMAT ">>9.9999"     no-undo.
DEFINE VARIABLE de-val-base-pis         LIKE it-nota-fisc.vl-tot-item    no-undo.
DEFINE VARIABLE de-val-pis              LIKE it-nota-fisc.vl-tot-item    no-undo.
DEFINE VARIABLE c-trib-pis              AS CHAR                          no-undo.
DEFINE VARIABLE de-aliq-cofins          AS DECIMAL FORMAT ">>9.9999"     no-undo.
DEFINE VARIABLE de-val-base-cofins      LIKE it-nota-fisc.vl-tot-item    no-undo.
DEFINE VARIABLE de-val-cofins           LIKE it-nota-fisc.vl-tot-item    no-undo.
//DEFINE VARIABLE de-rol                  AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-aliq-difal           AS DECIMAL NO-UNDO.
DEFINE VARIABLE i-cont                  as INTEGER NO-UNDO.
DEFINE VARIABLE i-arred                 as INTEGER NO-UNDO.
DEFINE VARIABLE i-round                 as INTEGER NO-UNDO.
DEFINE VARIABLE c-char-aux              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iSeqWtDocto             AS INTEGER      NO-UNDO.
DEFINE VARIABLE iSeqWtItDocto           AS INTEGER      NO-UNDO.
DEFINE VARIABLE l-procedimento-ok       AS LOGICAL      NO-UNDO.
DEFINE VARIABLE l-criou-docto           AS LOGICAL      NO-UNDO.
DEFINE VARIABLE ultprocesso             AS CHARACTER    NO-UNDO.
DEFINE VARIABLE l-log                   AS LOG          NO-UNDO.
DEFINE VARIABLE l-log-ft4015            AS LOG          NO-UNDO.
DEFINE VARIABLE i-seq                   AS INTEGER      NO-UNDO INITIAL 0.
DEFINE VARIABLE c-arquivo-log1 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-producao   AS LOG NO-UNDO.
//DEFINE VARIABLE de-preco-venda-orig AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-preco-difal     AS DECIMAL NO-UNDO.
//{dibo/bodi317.i2 "bodi317"}
DEFINE VARIABLE c-ultimo-metodo-exec as char   no-undo.
DEFINE VARIABLE h-bodi317pr          as handle no-undo.
DEFINE VARIABLE h-bodi317sd          as handle no-undo.
DEFINE VARIABLE h-bodi317im1br       as handle no-undo.
DEFINE VARIABLE h-bodi317va          as handle no-undo.
DEFINE VARIABLE l-recalcular         AS LOG    NO-UNDO.
DEFINE VARIABLE i-seq-log            AS INTEGER NO-UNDO.

RUN pi-definicao-inicial.
RUN pi-gerar-dados-extrato("||======================================================"). 
RUN pi-gerar-dados-extrato("||INICIO"). 
RUN pi-validacao-inicial.             
//RUN pi-gerar-dados-extrato("||APOS VALIDACAO INICIAL").
RUN pi-gerar-dados-extrato("||TypeOfTrading   :" + typeOfTrading).
RUN pi-regras.
RUN pi-definicao-final.
RUN pi-gerar-dados-extrato("FINAL||"). 
RUN pi-grava-log.

PROCEDURE pi-regras:
    
    IF typeOfTrading <> 'SaleIndirect' THEN DO:
        
        // GERA PEDIDO POR ESTABELECIMENTO
        FOR EACH tt-estabelec:
        
            ASSIGN c-estab = tt-estabelec.cod-estabel.
        
            EMPTY TEMP-TABLE tt-param-2.
            EMPTY TEMP-TABLE tt-documentos.
            ASSIGN i-seq-wt-it-docto = 0.
    
            // INICIALIZA BOS para wt-docto, wt-it-docto e wt-it-imposto 
            RUN dibo/bodi317in.p PERSISTENT SET h-bodi317in.
           
            RUN inicializaBOS IN h-bodi317in(OUTPUT h-bodi317pr,
                                             OUTPUT h-bodi317sd,
                                             OUTPUT h-bodi317im1br,
                                             OUTPUT h-bodi317va).
            
            // CONSULTA SERIE DO ESTABELECIMENTO
            run leaveCodEstabel in h-bodi317sd (input c-estab, input no, output c-char-aux).
            RUN pi-gerar-dados-extrato(c-estab + "||Serie: " + c-char-aux). 
    	
        	find first emitente no-lock
                 where emitente.cod-emitente = i-cliente no-error.
            
            // BUSCA NATUREZA DA NOTA
            RUN esbo/boes505.p PERSISTENT SET h-boes505.
            RUN defineNatOperacao IN h-boes505 (INPUT c-estab,
                                             INPUT emitente.cod-emitente,
                                             INPUT emitente.cod-entrega,
                                             INPUT '',
                                             INPUT l-consumidor-final,
                                             OUTPUT c-nat-oper,
                                             OUTPUT l-return).
            DELETE PROCEDURE h-boes505.
    
            RUN pi-gerar-dados-extrato(c-estab + "||Natureza: " + c-nat-oper). 
            RUN pi-gerar-dados-extrato(c-estab + "||Cond Pgto: " + STRING(i-cond-pag)). 
            
            do trans:
                
                ASSIGN i-cont-nota = i-cont-nota + 1.
    
              /*  FOR EACH tt-item-totvs
                   WHERE tt-item-totvs.cod-estabel = c-estab:
                    IF  tt-item-totvs.log-servico = YES 
                    AND AVAIL tt-prog-ponto2 THEN 
                        ASSIGN c-char-aux = /*'R3'*/ ENTRY(1,tt-prog-ponto2.conteudo,";")
                               c-nat-oper = /*'500001'*/ ENTRY(2,tt-prog-ponto2.conteudo,";").
                END. */

                IF tt-estabelec.log-servico = YES AND AVAIL tt-prog-ponto2 THEN
                   ASSIGN c-char-aux = /*'R3'*/ ENTRY(1,tt-prog-ponto2.conteudo,";")
                          c-nat-oper = /*'500001'*/ ENTRY(2,tt-prog-ponto2.conteudo,";").
    
    
                // CRIACAO DA WT-DOCTO
                run criaWtDocto in h-bodi317sd (input  'adm',
                                                input  c-estab,
                                                input  c-char-aux,
                                                input  "1",
                                                input  emitente.nome-abrev,
                                                input  ?,
                                                input  4,
                                                input  4003,
                                                input  TODAY,
                                                input  0, //embarque
                                                input  c-nat-oper,
                                                input  '1', //canal de venda
                                                output iSeqWtDocto,
                                                output l-proc-ok-aux).
                                              
                assign l-criou-docto = l-proc-ok-aux.
                
    
                EMPTY TEMP-TABLE RowErrors.
                run devolveErrosbodi317sd in h-bodi317sd(output c-ultimo-metodo-exec, output table RowErrors).
                
                RUN pi-gerar-dados-extrato(c-estab + "||Seq Wt Docto: " + STRING(iSeqWtDocto)). 
        
                FOR EACH RowErrors
                    WHERE RowErrors.ErrorSubType = 'Error':
                    IF RowErrors.ErrorSubType = 'Error' THEN
                       RUN pi-erro (INPUT 412,
                                    INPUT "ERRO_DE_VALIDACAO criaWtDocto - nat: " + c-nat-oper, 
                                    INPUT RowErrors.errordescription + " ( " + STRING(RowErrors.errornumber) + " )" ).
                      
                    RUN pi-gerar-dados-extrato (c-estab + "||" + RowErrors.ErrorSubType + " - " + RowErrors.errordescription + " ( " + STRING(RowErrors.errornumber) + " )"). 
                END.
    
                FIND FIRST WT-DOCTO WHERE WT-DOCTO.seq-wt-docto = iSeqWtDocto EXCLUSIVE-LOCK NO-ERROR.
                ASSIGN wt-docto.cod-cond-pag = i-cond-pag
                       wt-docto.marca-volume = "CD0761,Det,chav,mem".
                       //Wt-docto.vl-frete-inf = shippingHandling.     
                FIND CURRENT WT-DOCTO NO-LOCK NO-ERROR.

                RUN pi-gerar-dados-extrato(c-estab + "||"). 
                
                FOR EACH tt-item-totvs
                   WHERE tt-item-totvs.cod-estabel = c-estab
                     AND tt-item-totvs.log-servico = tt-estabelec.log-servico:
    
                    ASSIGN tt-item-totvs.de-rol = 0
                           tt-item-totvs.fator-calc-desc = 0
                           tt-item-totvs.preco-venda     = 0.
    
                    //RUN pi-gerar-dados-extrato("||"). 
    
                    // BUSCA NATUREZA DE OPERAÄ«O DO ITEM
                    RUN esbo/boes505.p PERSISTENT SET h-boes505.
                    RUN defineNatOperacao IN h-boes505 (INPUT tt-item-totvs.cod-estabel,
                                                        INPUT emitente.cod-emitente,
                                                        INPUT emitente.cod-entrega,
                                                        INPUT tt-item-totvs.it-codigo,
                                                        INPUT l-consumidor-final,
                                                        OUTPUT c-nat-oper,
                                                        OUTPUT l-return).
                    DELETE PROCEDURE h-boes505.
    
                    IF tt-item-totvs.log-servico = YES THEN ASSIGN c-char-aux = 'R2'
                                                             c-nat-oper = '500001'.
    
                    IF c-nat-oper = '' THEN DO:
                       RUN esbo/boes505.p PERSISTENT SET h-boes505.
                       RUN defineNatOperacao IN h-boes505 (INPUT tt-item-totvs.cod-estabel,
                                                           INPUT emitente.cod-emitente,
                                                           INPUT emitente.cod-entrega,
                                                           INPUT '',
                                                           INPUT l-consumidor-final,
                                                           OUTPUT c-nat-oper,
                                                           OUTPUT l-return).
                       DELETE PROCEDURE h-boes505.
                    END.
    
                    IF c-nat-oper = '' THEN DO:
                       RUN pi-erro (INPUT 412,                 
                                    INPUT "ERRO_DE_VALIDACAO defineNatOperacao", 
                                    INPUT "Natureza de operacao do item " + tt-item-totvs.it-codigo + " - nao encontrada. Verificar com o grupo tributario.").
            
                       RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|" + "Natureza de operacao do item nao encontrada. Verificar com o grupo tributario."). 
                    END. 
    
                    //RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Natur Item: " + c-nat-oper). 
    
                    /* BUSCA TIPO DE TRIBUTACAO DO ITEM DE ACORDO COM A TABELA DE PREÄOS*/
                    FIND FIRST int-tb-preco
                         WHERE int-tb-preco.nr-tabpre = tt-item-totvs.nr-tabpre NO-LOCK NO-ERROR.
                    ASSIGN tt-item-totvs.i-tributacao = int-tb-preco.idi-tributacao.
                                                                              
                    IF tt-item-totvs.parentkit = '' THEN
                        FIND LAST preco-item 
                            WHERE preco-item.it-codigo  = tt-item-totvs.it-codigo
                              AND preco-item.nr-tabpre  = tt-item-totvs.nr-tabpre  //c-tab-preco 
                              AND preco-item.cod-refer  = tt-item-totvs.cod-estabel
                              and preco-item.dt-inival <= today    
                	          and preco-item.situacao   = 1 
                              AND preco-item.quant-min  <=  tt-item-totvs.quant-min NO-LOCK NO-ERROR.
                    ELSE
                        FIND LAST preco-item 
                            WHERE preco-item.it-codigo  = tt-item-totvs.it-codigo
                              AND preco-item.nr-tabpre  = tt-item-totvs.nr-tabpre  //c-tab-preco 
                              AND preco-item.cod-refer  = tt-item-totvs.cod-estabel
                              and preco-item.dt-inival <= today    
                              and preco-item.situacao   = 1  NO-LOCK NO-ERROR.
                                                                                                       
                    // CASO VALOR INFORMADO NO JSON SEJA MAIOR, NAO UTILIZA O VALOR DA TABELA DE PRECOS
                    IF AVAIL preco-item       AND 
                       tt-item-totvs.preco-unit > 0 AND 
                       tt-item-totvs.preco-unit > preco-item.preco-venda THEN DO:
                       ASSIGN tt-item-totvs.val-inicial = tt-item-totvs.preco-unit
                              tt-item-totvs.preco-venda      = tt-item-totvs.preco-unit
                              tt-item-totvs.i-tributacao = 4.
                    END.
                    ELSE
                        ASSIGN tt-item-totvs.val-inicial = IF AVAIL preco-item THEN preco-item.preco-venda ELSE 0
                               tt-item-totvs.preco-venda      = IF AVAIL preco-item THEN preco-item.preco-venda ELSE 0
                               tt-item-totvs.preco-unit  = IF AVAIL preco-item THEN preco-item.preco-venda ELSE 0.
    
                    // DESCONTO PELA QUANTIDADE DO ITEM
                    assign tt-item-totvs.perc-desc-qt = IF AVAIL preco-item THEN preco-item.desco-quant ELSE 0.
    
                    // DESCONTO PELO INDICE DE FINANCIMENTO DE ACORDO COM A CONDICAO DE PAGAMENTO
                    IF de-indice-finan <> 1 THEN DO:
                       ASSIGN tt-item-totvs.desc-indice-finan = de-indice-finan.
                    END.
        
                    // DESCONTO DO CLIENTE
                    ASSIGN de-fator-cli = 0.
                    RUN pi-busca-desconto-cliente (INPUT emitente.cod-emitente,
                                                   INPUT tt-item-totvs.nr-tabpre,
                                                   INPUT tt-item-totvs.it-codigo,
                                                   OUTPUT de-fator-cli).
                    IF de-fator-cli <> 0 THEN
                        ASSIGN tt-item-totvs.fator-desconto = (1 - de-fator-cli) * 100.
    
                    FIND FIRST ITEM WHERE ITEM.IT-CODIGO = tt-item-totvs.it-codigo NO-LOCK NO-ERROR.
                        
                    ASSIGN i-seq-wt-it-docto = i-seq-wt-it-docto + 1.
    
                    // CRIACAO DA WT-IT-DOCTO E WT-IT-IMPOSTO
                    RUN criaWtItDocto IN h-bodi317sd (?,
                                                      '', 
                                                      i-seq-wt-it-docto,
                                                      tt-item-totvs.it-codigo,
                                                      '',
                                                      c-nat-oper,
                                                      OUTPUT iSeqWtItDocto,
                                                      OUTPUT l-procedimento-ok).
    
                    run localizaWtItDocto   in h-bodi317pr (input  wt-docto.seq-wt-docto,
                                                            input  iSeqWtItDocto,
                                                            output l-proc-ok-aux).
    
                    FIND FIRST wt-it-docto
                         WHERE wt-it-docto.seq-wt-docto    = wt-docto.seq-wt-docto
                           AND wt-it-docto.seq-wt-it-docto = iSeqWtItDocto EXCLUSIVE-LOCK NO-ERROR.

                    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Seq Wt Docto   :" + STRING(wt-docto.seq-wt-docto)). 
                    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Seq Wt It Docto:" + string(iSeqWtItDocto)). 
                    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Nat oper       :" + wt-it-docto.nat-operacao). 
                    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Quantidade     : " + STRING(tt-item-totvs.quant-min)). 
                    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Servico        : " + STRING(tt-item-totvs.log-servico)). 
                    
                    // GRAVA OS CAMPOS DA WT-IT-DOCTO
                    ASSIGN wt-it-docto.quantidade[1]   = tt-item-totvs.quant-min
                           wt-it-docto.quantidade[2]   = tt-item-totvs.quant-min 
                           wt-it-docto.nr-sequencia    = i-seq-wt-it-docto * 10
                           wt-it-docto.calcula         = YES
                           wt-it-docto.nr-seq-nota     = 1
                           wt-it-docto.nat-operacao    = c-nat-oper
                           wt-it-docto.peso-bru-it-inf = tt-item-totvs.quant-min * ITEM.peso-bru
                           wt-it-docto.peso-liq-it-inf = tt-item-totvs.quant-min * ITEM.peso-liq
                           wt-it-docto.cod-unid-negoc  = ITEM.cod-unid-negoc
                           wt-it-docto.class-fiscal    = ITEM.class-fiscal.
                     
                    // CRIA A WT-IT-IMPOSTO SE AINDA N«O EXISTIR
                    FIND FIRST wt-it-imposto
                         WHERE wt-it-imposto.seq-wt-docto = wt-docto.seq-wt-docto
                           AND wt-it-imposto.seq-wt-it-docto = wt-it-docto.seq-wt-it-docto EXCLUSIVE-LOCK NO-ERROR.
                    IF NOT AVAIL wt-it-imposto THEN DO:
                        RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Criou o wt-it-imposto").  
                        create wt-it-imposto.
                        assign wt-it-imposto.seq-wt-docto    = wt-docto.seq-wt-docto
                               wt-it-imposto.seq-wt-it-docto = wt-it-docto.seq-wt-it-docto.
                    END.
                    //RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Criou o wt-it-imposto2").  
                    
                    run localizaWtItImposto in h-bodi317pr (input  wt-it-docto.seq-wt-docto,
                                                            input  wt-it-docto.seq-wt-it-docto, 
                                                            output l-proc-ok-aux). 
    
                    RUN pi-limpa.
                    
                    // ATUALIZA A ALIQUOTA DOS IMPOSTOS NA WT-IT-IMPOSTO DE ACORDO COM A NATUREZA DE OPERAÄ«O
                    run atualizaDadosWtItDoctoComNatureza in h-bodi317sd(input  wt-it-docto.seq-wt-docto,
                                                          input  wt-it-docto.seq-wt-it-docto,
                                                          input  no, /* indica que o campo baixa-estoque foi alterado */
                                                          output l-proc-ok-aux).
    
    
                    FIND CURRENT wt-it-docto EXCLUSIVE-LOCK NO-ERROR.
                    // VALOR DO PRECO UNITARIO E VALOR DA TABELA DE PREÄOS
                    ASSIGN wt-it-docto.vl-preori                   = TRUNC(tt-item-totvs.preco-venda,4)  
                           wt-it-docto.vl-pretab                   = TRUNC(tt-item-totvs.preco-venda,4)
                           wt-it-docto.vl-preuni                   = TRUNC(tt-item-totvs.preco-venda,4) 
                           wt-it-docto.vl-preori-ped               = TRUNC(tt-item-totvs.preco-venda,4)
                           wt-it-docto.vl-pretab-ped               = TRUNC(tt-item-totvs.val-inicial,4)
                           wt-it-docto.vl-merc-ori                 = TRUNC(tt-item-totvs.preco-venda * tt-item-totvs.quant-min,4)
                           wt-it-docto.vl-merc-tab                 = TRUNC(tt-item-totvs.preco-venda * tt-item-totvs.quant-min,4)
                           wt-it-docto.vl-merc-liq                 = ROUND(tt-item-totvs.preco-venda * tt-item-totvs.quant-min,2)
                           tt-item-totvs.preco-unit                = TRUNC(tt-item-totvs.preco-venda,4).
                    FIND CURRENT wt-it-docto NO-LOCK NO-ERROR.
    
                END.
    
                RUN pi-calcula-impostos.
                RUN pi-calcula-pis-cofins.
    
                FOR EACH wt-it-docto NO-LOCK
                   WHERE wt-it-docto.seq-wt-docto = wt-docto.seq-wt-docto:
                    FIND FIRST wt-it-imposto
                         WHERE wt-it-imposto.seq-wt-docto = wt-docto.seq-wt-docto
                           AND wt-it-imposto.seq-wt-it-docto = wt-it-docto.seq-wt-it-docto NO-LOCK NO-ERROR.
                    IF AVAIL wt-it-imposto THEN DO:
                        FOR EACH tt-item-totvs
                           WHERE tt-item-totvs.it-codigo   = wt-it-docto.it-codigo
                             AND tt-item-totvs.cod-estabel = wt-docto.cod-estabel
                             AND tt-item-totvs.quant-min   = wt-it-docto.quantidade[1]:
                                
                            ASSIGN tt-item-totvs.it-codigo = tt-item-totvs.it-codigo
                                   tt-item-totvs.preco-venda = TRUNC(tt-item-totvs.preco-unit,4)
                                   tt-item-totvs.fator-calc-desc       = 0
                                   tt-item-totvs.de-rol = 0.
                                             
                            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|============================================"). 
    
                            // CALCULA PRECO DE ACORDO COM TIPO DE TRIBUTACAO DA TABELA DE PRECOS (NENHUM/PARCIAL/TOTAL) E CALCULA PIS/COFINS
                            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|PRECO ANTES : " + STRING(tt-item-totvs.preco-venda)). 
                            RUN pi-regras-especificas.
                            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|PRECO DEPOIS: " + STRING(tt-item-totvs.preco-venda)). 
                            //RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|ROL         : " + STRING(tt-item-totvs.preco-venda)).
                            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|============================================"). 
            
                            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Desc Kit            : " + STRING(tt-item-totvs.kit-desconto       )).
                            //RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Desc Quantidade     : " + STRING(tt-item-totvs.perc-desc-qt       )).
                            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Desc Comercial      : " + STRING(tt-item-totvs.perc-desconto      )). 
                            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Desc Fator Cliente  : " + STRING(tt-item-totvs.fator-desconto )). 
                            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Desc Mais Verde     : " + STRING(tt-item-totvs.desconto-maisverde )). 
                            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Desc Foco Unid      : " + STRING(tt-item-totvs.desconto-focounid  )). 
                            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Desc Distrib 20     : " + STRING(tt-item-totvs.desconto-distrib20 )). 
                            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Desc Wide Cloud     : " + STRING(tt-item-totvs.desconto-widecloud )). 
                            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Desc Top Milhao     : " + STRING(tt-item-totvs.desconto-topmilhao )).
                            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Calculo fator -> (1 - (Desconto / 100)) * (1 - (Desconto / 100))..."). 
            
                            // FATOR DE DESCONTO DO ITEM MULTIPLICANDO TODOS OS DESCONTO EM CASCATA
                            IF tt-item-totvs.fator-calc-desc = 0 THEN ASSIGN tt-item-totvs.fator-calc-desc = (1 - (tt-item-totvs.kit-desconto       / 100)). ELSE ASSIGN tt-item-totvs.fator-calc-desc = tt-item-totvs.fator-calc-desc * (1 - (tt-item-totvs.kit-desconto       / 100)).
                            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Fator               : " + STRING(tt-item-totvs.fator-calc-desc)).
                            //IF tt-item-totvs.fator-calc-desc = 0 THEN ASSIGN tt-item-totvs.fator-calc-desc = (1 - (tt-item-totvs.perc-desc-qt       / 100)). ELSE ASSIGN tt-item-totvs.fator-calc-desc = tt-item-totvs.fator-calc-desc * (1 - (tt-item-totvs.perc-desc-qt       / 100)).
                            //RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Fator               : " + STRING(tt-item-totvs.fator-calc-desc)). 
                            IF tt-item-totvs.fator-calc-desc = 0 THEN ASSIGN tt-item-totvs.fator-calc-desc = (1 - (tt-item-totvs.perc-desconto      / 100)). ELSE ASSIGN tt-item-totvs.fator-calc-desc = tt-item-totvs.fator-calc-desc * (1 - (tt-item-totvs.perc-desconto / 100)).
                            //RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Fator              : " + STRING(tt-item-totvs.fator-calc-desc) + ' ' + STRING(tt-item-totvs.desc-indice-finan)). 
                            //IF tt-item-totvs.fator-calc-desc = 0 AND tt-item-totvs.desc-indice-finan <> 0 THEN ASSIGN tt-item-totvs.fator-calc-desc = tt-item-totvs.desc-indice-finan.                ELSE IF tt-item-totvs.desc-indice-finan <> 0 THEN ASSIGN tt-item-totvs.fator-calc-desc = tt-item-totvs.fator-calc-desc * tt-item-totvs.desc-indice-finan.
                            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Fator               : " + STRING(tt-item-totvs.fator-calc-desc)). 
                            //IF tt-item-totvs.fator-calc-desc = 0 THEN ASSIGN tt-item-totvs.fator-calc-desc = (1 - (tt-item-totvs.fator-desconto     / 100)). ELSE ASSIGN tt-item-totvs.fator-calc-desc = tt-item-totvs.fator-calc-desc * (1 - (tt-item-totvs.fator-desconto     / 100)).
                            //RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Fator               : " + STRING(tt-item-totvs.fator-calc-desc)). 
                            IF tt-item-totvs.fator-calc-desc = 0 THEN ASSIGN tt-item-totvs.fator-calc-desc = (1 - (tt-item-totvs.desconto-maisverde / 100)). ELSE ASSIGN tt-item-totvs.fator-calc-desc = tt-item-totvs.fator-calc-desc * (1 - (tt-item-totvs.desconto-maisverde / 100)).
                            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Fator               : " + STRING(tt-item-totvs.fator-calc-desc)). 
                            IF tt-item-totvs.fator-calc-desc = 0 THEN ASSIGN tt-item-totvs.fator-calc-desc = (1 - (tt-item-totvs.desconto-focounid  / 100)). ELSE ASSIGN tt-item-totvs.fator-calc-desc = tt-item-totvs.fator-calc-desc * (1 - (tt-item-totvs.desconto-focounid  / 100)).
                            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Fator               : " + STRING(tt-item-totvs.fator-calc-desc)). 
                            IF tt-item-totvs.fator-calc-desc = 0 THEN ASSIGN tt-item-totvs.fator-calc-desc = (1 - (tt-item-totvs.desconto-distrib20 / 100)). ELSE ASSIGN tt-item-totvs.fator-calc-desc = tt-item-totvs.fator-calc-desc * (1 - (tt-item-totvs.desconto-distrib20 / 100)).
                            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Fator               : " + STRING(tt-item-totvs.fator-calc-desc)). 
                            IF tt-item-totvs.fator-calc-desc = 0 THEN ASSIGN tt-item-totvs.fator-calc-desc = (1 - (tt-item-totvs.desconto-widecloud / 100)). ELSE ASSIGN tt-item-totvs.fator-calc-desc = tt-item-totvs.fator-calc-desc * (1 - (tt-item-totvs.desconto-widecloud / 100)).
                            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Fator               : " + STRING(tt-item-totvs.fator-calc-desc)). 
                            IF tt-item-totvs.fator-calc-desc = 0 THEN ASSIGN tt-item-totvs.fator-calc-desc = (1 - (tt-item-totvs.desconto-topmilhao / 100)). ELSE ASSIGN tt-item-totvs.fator-calc-desc = tt-item-totvs.fator-calc-desc * (1 - (tt-item-totvs.desconto-topmilhao / 100)).
            
                            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Fator desconto      : " + STRING(tt-item-totvs.fator-calc-desc,">>9.9999999999")). 
                            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Fator cond pagto    : " + STRING(tt-item-totvs.desc-indice-finan,">>9.9999999999")). 
                            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Preco de venda      : " + STRING(tt-item-totvs.preco-venda)).
                            
                            IF tt-item-totvs.desc-indice-finan <> 0
                            AND tt-item-totvs.desc-indice-finan <> 1 THEN
                                ASSIGN tt-item-totvs.preco-venda = TRUNC(tt-item-totvs.preco-venda * tt-item-totvs.desc-indice-finan,4).
    
                            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Preco de V*Cond Pgto: " + STRING(tt-item-totvs.preco-venda)).
    
                            IF tt-item-totvs.fator-desconto <> 0 THEN
                                ASSIGN tt-item-totvs.fator-desconto = (100 - tt-item-totvs.fator-desconto) / 100
                                       tt-item-totvs.preco-venda    = TRUNC(tt-item-totvs.preco-venda * tt-item-totvs.fator-desconto,4).
    
                            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Preco de V*Desc Cli : " + STRING(tt-item-totvs.preco-venda)).

                            // CALCULO DO PREÄO * FATOR
                            ASSIGN tt-item-totvs.preco-unit   = tt-item-totvs.preco-venda.
                            IF tt-item-totvs.fator-calc-desc > 0 THEN
                                ASSIGN tt-item-totvs.val-desconto-pci = TRUNC(tt-item-totvs.preco-venda * (100 - tt-item-totvs.fator-calc-desc * 100) / 100,4)
                                       tt-item-totvs.preco-venda      = TRUNC(tt-item-totvs.preco-venda * tt-item-totvs.fator-calc-desc,4)
                                       tt-item-totvs.fator-calc-desc  = 100 - tt-item-totvs.fator-calc-desc * 100.
                            ELSE
                                ASSIGN tt-item-totvs.val-desconto-pci = 0
                                       tt-item-totvs.fator-calc-desc = 0.

                            ASSIGN tt-item-totvs.val-desconto = TRUNC(tt-item-totvs.val-desconto-comercial + tt-item-totvs.val-desconto-pci,4).
    
                            RUN pi-gerar-dados-extrato(tt-item-totvs.cod-estabel + "|" + STRING(tt-item-totvs.it-codigo) + "|Val Desconto10         : " + STRING(tt-item-totvs.val-desconto)). 
    
                            ASSIGN tt-item-totvs.preco-venda = TRUNC(tt-item-totvs.preco-venda,4).
    
                            //RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Preco de venda      : " + STRING(tt-item-totvs.preco-unit)).
                            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Preco de V*Fator    : " + STRING(tt-item-totvs.preco-venda)).
                            //RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Calculo desconto -> Preco * Quantidade * (Fator - Fator Comercial)"). 
                            //RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|tt-item-totvs.preco-venda     : " + STRING(tt-item-totvs.preco-venda  )). 
                            
                            //RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|tt-item-totvs.fator-calc-desc            : " + STRING(tt-item-totvs.fator-calc-desc      )). 
                            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|% Desconto          : " + STRING(tt-item-totvs.fator-calc-desc      )). 
                            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Val Desconto        : " + STRING(tt-item-totvs.val-desconto)).
    
                            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|============================================").
                            
                            FIND CURRENT wt-it-docto EXCLUSIVE-LOCK NO-ERROR.
                            // ATUALIZA VALOR DO PRECO UNITARIO E VALOR DA TABELA DE PREÄOS
                            ASSIGN wt-it-docto.vl-preori                   = TRUNC(tt-item-totvs.preco-venda,4)  
                                   wt-it-docto.vl-pretab                   = TRUNC(tt-item-totvs.preco-venda,4)
                                   wt-it-docto.vl-preuni                   = TRUNC(tt-item-totvs.preco-venda,4) 
                                   wt-it-docto.vl-preori-ped               = TRUNC(tt-item-totvs.preco-venda,4)
                                   //wt-it-docto.vl-pretab-ped               TRUNC(= tt-item-totvs.val-inicial
                                   wt-it-docto.vl-merc-ori                 = TRUNC(tt-item-totvs.preco-venda * tt-item-totvs.quant-min,4)
                                   wt-it-docto.vl-merc-tab                 = TRUNC(tt-item-totvs.preco-venda * tt-item-totvs.quant-min,4)
                                   wt-it-docto.vl-merc-liq                 = ROUND(tt-item-totvs.preco-venda * tt-item-totvs.quant-min,2).
                            FIND CURRENT wt-it-docto NO-LOCK NO-ERROR.
        
                        END.
                    END.
                END.
    
                RUN pi-calcula-impostos.
                RUN pi-grava-tabela.
    
                IF l-recalcular THEN DO:
                    RUN pi-recalcular.
                END.
    
                /*
                FOR EACH tt-item-totvs:
                    IF tt-item-totvs.fator-calc-desc < 0 THEN
                        ASSIGN tt-item-totvs.fator-calc-desc = 0.
    
                    IF tt-item-totvs.val-desconto < 0 THEN
                        ASSIGN tt-item-totvs.val-desconto  = 0.
                END.
                */

                CREATE tt-documentos.
				ASSIGN tt-documentos.seq-wt-docto = wt-docto.seq-wt-docto.  

				// ABERTURA DO LOG FT4015
				IF l-log-ft4015 = YES THEN DO:

					// CRIA O REGISTRO PARA IMPRIMIR O RELAT‡RIO DO FT4015 COM O ESPELHO DO CALCULO DE TODOS OS IMPOSTOS
					CREATE tt-param-2.
					ASSIGN tt-param-2.destino         = 2
						   tt-param-2.arquivo         = '/mnt/spool/totvs/CALCULO-' + STRING(i-cliente) + '-' + STRING(c-estab) + '-' + STRING(wt-docto.seq-wt-docto) + '.txt'
						   tt-param-2.usuario         = "LE052412"
						   tt-param-2.data-exec       = TODAY
						   tt-param-2.hora-exec       = TIME
						   tt-param-2.classifica      = 1
						   tt-param-2.desc-classifica = "1".
		
					// IMPRIME O ESPELHO DOS IMPOSTOS
					run ftp/ft4015rp.p(input 1, /* Brasil */
									   input table tt-param-2,
									   input table tt-documentos).

				END.              
            END.
        END.

        // EXCLUI DADOS DA WT-DOCTO WT-IT-DOCTO E WT-IT-IMPOSTO
        FOR EACH tt-documentos:
            RUN eliminaRegistrosWorkTable IN h-bodi317sd (INPUT tt-documentos.seq-wt-docto,
                                                          INPUT NO,
                                                          OUTPUT l-proc-ok-aux).
            RUN pi-gerar-dados-extrato("||EliminaRegistrosWorkTable l-proc-ok-aux -  " + string(l-proc-ok-aux)).   
        END.
        
        // FINALIZA A BO E OS HANDLES DAS BOs
        RUN finalizaBOS IN h-bodi317in.
        
        IF VALID-HANDLE(h-bodi317in)        THEN RUN finalizaBOS IN h-bodi317in.
        IF VALID-HANDLE(h-bodi321)          THEN DELETE PROCEDURE h-bodi321.
        IF VALID-HANDLE(h-bodi317)          then delete procedure h-bodi317.       
        IF VALID-HANDLE(h-bodi317pr)        then delete procedure h-bodi317pr.     
        IF VALID-HANDLE(h-bodi317sd)        then delete procedure h-bodi317sd.     
        IF VALID-HANDLE(h-bodi317im1br)     then delete procedure h-bodi317im1br.  
        IF VALID-HANDLE(h-bodi317im1bra)    then delete procedure h-bodi317im1bra. 
        IF VALID-HANDLE(h-bodi317va)        then delete procedure h-bodi317va.     
        IF VALID-HANDLE(h-boin404te)        then delete procedure h-boin404te.      
        IF VALID-HANDLE(h-bodi321)          then delete procedure h-bodi321.       
        IF VALID-HANDLE(h-bodi159cal)       then delete procedure h-bodi159cal.    
        
        IF VALID-HANDLE(h-cdapi995) THEN DO:
           RUN pi-finalizar in h-cdapi995.
           ASSIGN h-cdapi995 = ?.
        END.
    END.
    ELSE DO:
        // SE FOR VENDA DIRETA CALCULA O PREÄO TOTAL MULTIPLICANDO PREÄO UNITARIO * QUANTIDADE
        FOR EACH tt-item-totvs:
            ASSIGN tt-item-totvs.preco-total  = tt-item-totvs.preco-unit * tt-item-totvs.quant-min.
            RUN pi-gerar-dados-extrato("|" + tt-item-totvs.it-codigo + "|preco total: " + STRING(tt-item-totvs.preco-total) + " preco-unit: " + STRING(tt-item-totvs.preco-unit) + " quant-min: " + STRING(tt-item-totvs.quant-min)).
        END.
    END.
    
    //OUTPUT CLOSE.

END PROCEDURE.

PROCEDURE pi-definicao-final:

    EMPTY TEMP-TABLE tt-item.

    FOR EACH tt-item-totvs:
        CREATE tt-item.
        BUFFER-COPY tt-item-totvs TO tt-item.

        RUN pi-gerar-dados-extrato(tt-item-totvs.cod-estabel + "|" + STRING(tt-item-totvs.it-codigo) + "|Val Desconto01        : " + STRING(tt-item-totvs.val-desconto)). 
        RUN pi-gerar-dados-extrato(tt-item-totvs.cod-estabel + "|" + STRING(tt-item-totvs.it-codigo) + "|Val Desconto02        : " + STRING(tt-item.val-desconto)). 

        IF TRUNC(tt-item-totvs.val-desconto,2) = 0 THEN
            ASSIGN tt-item.val-desconto = 0.

        RUN pi-gerar-dados-extrato(tt-item-totvs.cod-estabel + "|" + STRING(tt-item-totvs.it-codigo) + "|Val Desconto03        : " + STRING(tt-item-totvs.val-desconto)). 
    END.

END PROCEDURE.

PROCEDURE pi-limpa:

    FIND CURRENT wt-it-docto EXCLUSIVE-LOCK NO-ERROR.
    
    // LIMPA OS CAMPOS DA WT-IT-DOCTO PARA N«O AFETAR NO CALCULO
    ASSIGN wt-it-docto.qt-aloc-cc                  = 0
           wt-it-docto.qt-aloc-terc                = 0
           wt-it-docto.qt-devolvida                = 0
           wt-it-docto.quant-conf                  = 0
           wt-it-docto.val-desc-cofins-zfm         = 0
           wt-it-docto.val-desc-pis-zfm            = 0
           wt-it-docto.val-retenc-cofins           = 0
           wt-it-docto.val-retenc-csll             = 0
           wt-it-docto.val-retenc-pis              = 0
           wt-it-docto.vl-comp-acum                = 0
           wt-it-docto.vl-sub-emp                  = 0
           wt-it-docto.vl-tot-item                 = 0
           wt-it-docto.vl-totitem-e                = 0
           wt-it-docto.vl-tot-item-inf             = 0
           wt-it-docto.vl-tot-item-me              = 0
           //wt-it-docto.fat-qtfam                   = it-nota-fisc.ind-fat-qtfam
           wt-it-docto.selecionado                 = "*"
           wt-it-docto.baixa-estoq                 = NO
           wt-it-docto.un[1]                       = ITEM.un
           wt-it-docto.un[2]                       = ITEM.un 
           //wt-it-docto.ind-fat-qtfam               = item.ind-inf-qtf.
                    .

    FIND CURRENT wt-it-docto NO-LOCK NO-ERROR.
    FIND CURRENT wt-it-imposto EXCLUSIVE-LOCK NO-ERROR.

    // LIMPA OS CAMPOS DA WT-IT-IMPTO PARA N«O AFETAR NO CALCULO
    ASSIGN wt-it-imposto.icm-complem             = 0
           wt-it-imposto.icm-complem-e           = 0
           wt-it-imposto.val-base-cofins-substto = 0
           wt-it-imposto.val-base-pis-substto    = 0
           wt-it-imposto.val-diferim-icms-item   = 0
           wt-it-imposto.val-perc-icms-diferim   = 0
           wt-it-imposto.val-sat                 = 0
           wt-it-imposto.val-senar               = 0
           wt-it-imposto.vl-biss-it              = 0
           wt-it-imposto.vl-iss-it               = 0
           wt-it-imposto.vl-issnt-it             = 0
           wt-it-imposto.vl-bissit-e             = 0                   
           wt-it-imposto.vl-issit-e              = 0 
           wt-it-imposto.vl-issntit-e            = 0 
           wt-it-imposto.vl-issouit-e            = 0 
           wt-it-imposto.vl-issou-it             = 0 
           wt-it-imposto.vl-bicms-ent-fut        = 0
           wt-it-imposto.vl-bicms-it             = 0
           wt-it-imposto.vl-bicmsit-e            = 0
           wt-it-imposto.vl-bicms-it-merc        = 0
           wt-it-imposto.vl-bipi-ent-fut         = 0
           wt-it-imposto.vl-bipi-it              = 0
           wt-it-imposto.vl-bipiit-e             = 0
           wt-it-imposto.vl-biss-it              = 0
           wt-it-imposto.vl-bissit-e             = 0
           wt-it-imposto.vl-bsubs-ent-fut        = 0
           wt-it-imposto.vl-bsubs-it             = 0
           wt-it-imposto.vl-bsubsit-e            = 0
           wt-it-imposto.vl-cofins               = 0
           wt-it-imposto.vl-cofins-sub           = 0
           wt-it-imposto.vl-icms-ent-fut         = 0
           wt-it-imposto.vl-icms-it              = 0
           wt-it-imposto.vl-icmsit-e             = 0
           wt-it-imposto.vl-icms-it-merc         = 0
           wt-it-imposto.vl-icmsnt-it            = 0
           wt-it-imposto.vl-icmsntit-e           = 0
           wt-it-imposto.vl-icmsou-it            = 0
           wt-it-imposto.vl-icmsouit-e           = 0
           wt-it-imposto.vl-icms-outras          = 0
           wt-it-imposto.vl-icms-outras-me       = 0
           wt-it-imposto.vl-icmsub-ent-fut       = 0
           wt-it-imposto.vl-icmsub-it            = 0
           wt-it-imposto.vl-icmsubit-e           = 0
           wt-it-imposto.vl-inss-rf              = 0
           wt-it-imposto.vl-inss-rf-e            = 0
           wt-it-imposto.vl-ipi-ent-fut          = 0
           wt-it-imposto.vl-ipi-it               = 0
           wt-it-imposto.vl-ipiit-e              = 0
           wt-it-imposto.vl-ipint-it             = 0
           wt-it-imposto.vl-ipintit-e            = 0
           wt-it-imposto.vl-ipiou-it             = 0
           wt-it-imposto.vl-ipiouit-e            = 0
           wt-it-imposto.vl-ipi-outras           = 0
           wt-it-imposto.vl-ipi-outras-me        = 0
           wt-it-imposto.vl-irf-it               = 0
           wt-it-imposto.vl-irfit-e              = 0
           wt-it-imposto.vl-iss-it               = 0
           wt-it-imposto.vl-issit-e              = 0
           wt-it-imposto.vl-issnt-it             = 0
           wt-it-imposto.vl-issntit-e            = 0
           wt-it-imposto.vl-issou-it             = 0
           wt-it-imposto.vl-issouit-e            = 0
           wt-it-imposto.vl-pauta                = 0
           wt-it-imposto.vl-pis                  = 0
           wt-it-imposto.vl-pis-sub              = 0
           wt-it-imposto.vl-precon               = 0
           wt-it-imposto.vl-precon-e             = 0
           wt-it-imposto.vl-precon-me            = 0
           wt-it-imposto.aliquota-iss            = 0
           wt-it-imposto.vl-iss-it               = 100.
    FIND CURRENT wt-it-imposto NO-LOCK NO-ERROR.

END.

PROCEDURE pi-calcula-pis-cofins:

    IF NOT VALID-HANDLE (h-cdapi995)  THEN
                    RUN cdp/cdapi995.p PERSISTENT SET h-cdapi995. 

    RUN piBuscaPisCofins IN h-cdapi995 (INPUT  "wt-it-docto",
                                        INPUT  ROWID(wt-it-docto),
                                        INPUT  YES, /* sempre recalcular, para quando o usu“rio mudar a parametriza“ o, o c“lculo ser refeito na simula“ o*/
                                        INPUT  NO,
                                        OUTPUT de-aliq-pis,
                                        OUTPUT de-val-base-pis,
                                        OUTPUT de-val-pis,
                                        OUTPUT de-aliq-cofins,
                                        OUTPUT de-val-base-cofins,
                                        OUTPUT de-val-cofins).


    IF VALID-HANDLE(h-cdapi995) THEN DO:
        RUN pi-finalizar in h-cdapi995.
        ASSIGN h-cdapi995 = ?.
    END.

END PROCEDURE.

PROCEDURE pi-recalcular:

    FOR EACH wt-it-docto NO-LOCK
       WHERE wt-it-docto.seq-wt-docto = wt-docto.seq-wt-docto:
        FIND FIRST wt-it-imposto
             WHERE wt-it-imposto.seq-wt-docto = wt-docto.seq-wt-docto
               AND wt-it-imposto.seq-wt-it-docto = wt-it-docto.seq-wt-it-docto NO-LOCK NO-ERROR.
        IF AVAIL wt-it-imposto THEN DO:
            FOR EACH tt-item-totvs
               WHERE tt-item-totvs.it-codigo   = wt-it-docto.it-codigo
                 AND tt-item-totvs.cod-estabel = wt-docto.cod-estabel
                 AND tt-item-totvs.quant-min   = wt-it-docto.quantidade[1]:
                RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|==============RECALCULAR===================="). 
    
                // LIMPA OS CAMPOS DA WT-IT-DOCTO PARA NÄO AFETAR NO CALCULO
                ASSIGN wt-it-docto.qt-aloc-cc                  = 0
                       wt-it-docto.qt-aloc-terc                = 0
                       wt-it-docto.qt-devolvida                = 0
                       wt-it-docto.quant-conf                  = 0
                       wt-it-docto.val-desc-cofins-zfm         = 0
                       wt-it-docto.val-desc-pis-zfm            = 0
                       wt-it-docto.val-retenc-cofins           = 0
                       wt-it-docto.val-retenc-csll             = 0
                       wt-it-docto.val-retenc-pis              = 0
                       wt-it-docto.vl-comp-acum                = 0
                       wt-it-docto.vl-sub-emp                  = 0
                       wt-it-docto.vl-tot-item                 = 0
                       wt-it-docto.vl-totitem-e                = 0
                       wt-it-docto.vl-tot-item-inf             = 0
                       wt-it-docto.vl-tot-item-me              = 0
                       //wt-it-docto.fat-qtfam                   = it-nota-fisc.ind-fat-qtfam
                       wt-it-docto.selecionado                 = "*"
                       wt-it-docto.baixa-estoq                 = NO
                       wt-it-docto.un[1]                       = ITEM.un
                       wt-it-docto.un[2]                       = ITEM.un 
                       //wt-it-docto.ind-fat-qtfam               = item.ind-inf-qtf.
                    .
                
                // LIMPA OS CAMPOS DA WT-IT-IMPTO PARA NÄO AFETAR NO CALCULO
                ASSIGN wt-it-imposto.icm-complem             = 0
                       wt-it-imposto.icm-complem-e           = 0
                       wt-it-imposto.val-base-cofins-substto = 0
                       wt-it-imposto.val-base-pis-substto    = 0
                       wt-it-imposto.val-diferim-icms-item   = 0
                       wt-it-imposto.val-perc-icms-diferim   = 0
                       wt-it-imposto.val-sat                 = 0
                       wt-it-imposto.val-senar               = 0
                       wt-it-imposto.vl-biss-it              = 0
                       wt-it-imposto.vl-iss-it               = 0
                       wt-it-imposto.vl-issnt-it             = 0
                       wt-it-imposto.vl-bissit-e             = 0                   
                       wt-it-imposto.vl-issit-e              = 0 
                       wt-it-imposto.vl-issntit-e            = 0 
                       wt-it-imposto.vl-issouit-e            = 0 
                       wt-it-imposto.vl-issou-it             = 0 
                       wt-it-imposto.vl-bicms-ent-fut        = 0
                       wt-it-imposto.vl-bicms-it             = 0
                       wt-it-imposto.vl-bicmsit-e            = 0
                       wt-it-imposto.vl-bicms-it-merc        = 0
                       wt-it-imposto.vl-bipi-ent-fut         = 0
                       wt-it-imposto.vl-bipi-it              = 0
                       wt-it-imposto.vl-bipiit-e             = 0
                       wt-it-imposto.vl-biss-it              = 0
                       wt-it-imposto.vl-bissit-e             = 0
                       wt-it-imposto.vl-bsubs-ent-fut        = 0
                       wt-it-imposto.vl-bsubs-it             = 0
                       wt-it-imposto.vl-bsubsit-e            = 0
                       wt-it-imposto.vl-cofins               = 0
                       wt-it-imposto.vl-cofins-sub           = 0
                       wt-it-imposto.vl-icms-ent-fut         = 0
                       wt-it-imposto.vl-icms-it              = 0
                       wt-it-imposto.vl-icmsit-e             = 0
                       wt-it-imposto.vl-icms-it-merc         = 0
                       wt-it-imposto.vl-icmsnt-it            = 0
                       wt-it-imposto.vl-icmsntit-e           = 0
                       wt-it-imposto.vl-icmsou-it            = 0
                       wt-it-imposto.vl-icmsouit-e           = 0
                       wt-it-imposto.vl-icms-outras          = 0
                       wt-it-imposto.vl-icms-outras-me       = 0
                       wt-it-imposto.vl-icmsub-ent-fut       = 0
                       wt-it-imposto.vl-icmsub-it            = 0
                       wt-it-imposto.vl-icmsubit-e           = 0
                       wt-it-imposto.vl-inss-rf              = 0
                       wt-it-imposto.vl-inss-rf-e            = 0
                       wt-it-imposto.vl-ipi-ent-fut          = 0
                       wt-it-imposto.vl-ipi-it               = 0
                       wt-it-imposto.vl-ipiit-e              = 0
                       wt-it-imposto.vl-ipint-it             = 0
                       wt-it-imposto.vl-ipintit-e            = 0
                       wt-it-imposto.vl-ipiou-it             = 0
                       wt-it-imposto.vl-ipiouit-e            = 0
                       wt-it-imposto.vl-ipi-outras           = 0
                       wt-it-imposto.vl-ipi-outras-me        = 0
                       wt-it-imposto.vl-irf-it               = 0
                       wt-it-imposto.vl-irfit-e              = 0
                       wt-it-imposto.vl-iss-it               = 0
                       wt-it-imposto.vl-issit-e              = 0
                       wt-it-imposto.vl-issnt-it             = 0
                       wt-it-imposto.vl-issntit-e            = 0
                       wt-it-imposto.vl-issou-it             = 0
                       wt-it-imposto.vl-issouit-e            = 0
                       wt-it-imposto.vl-pauta                = 0
                       wt-it-imposto.vl-pis                  = 0
                       wt-it-imposto.vl-pis-sub              = 0
                       wt-it-imposto.vl-precon               = 0
                       wt-it-imposto.vl-precon-e             = 0
                       wt-it-imposto.vl-precon-me            = 0
                       wt-it-imposto.aliquota-iss            = 0
                       wt-it-imposto.vl-iss-it               = 100.
    
                    // ATUALIZA A ALIQUOTA DOS IMPOSTOS NA WT-IT-IMPOSTO DE ACORDO COM A NATUREZA DE OPERA∞ÄO
                    run atualizaDadosWtItDoctoComNatureza in h-bodi317sd(input  wt-it-docto.seq-wt-docto,
                                                          input  wt-it-docto.seq-wt-it-docto,
                                                          input  no, /* indica que o campo baixa-estoque foi alterado */
                                                          output l-proc-ok-aux).
    
                    FOR FIRST item-nf-adc NO-LOCK
                        WHERE item-nf-adc.cod-estab         = wt-docto.cod-estabel
                          AND item-nf-adc.cod-serie         = wt-docto.serie
                          AND item-nf-adc.cod-nota-fisc     = string(iSeqWtDocto)
                          AND item-nf-adc.cdn-emitente      = wt-docto.cod-emitente
                          AND item-nf-adc.cod-natur-operac  = wt-it-docto.nat-operacao
                          AND item-nf-adc.idi-tip-dado      = 24
                          //AND item-nf-adc.num-seq           = wt-it-docto.nr-entrega
                          //AND item-nf-adc.num-seq-item-nf   = wt-it-docto.nr-sequencia
                          AND item-nf-adc.cod-item          = wt-it-docto.it-codigo
                          AND item-nf-adc.val-livre-3      <> 0:
                        ASSIGN wt-it-docto.vl-preori                   = TRUNC(wt-it-docto.vl-preori-ped,4)  
                               wt-it-docto.vl-pretab                   = TRUNC(wt-it-docto.vl-preori-ped,4)
                               wt-it-docto.vl-preuni                   = TRUNC(wt-it-docto.vl-preori-ped,4)
                               wt-it-docto.vl-preori-ped               = TRUNC(wt-it-docto.vl-preori-ped,4)
                               //wt-it-docto.vl-pretab-ped               TRUNC(= tt-item-totvs.preco-venda
                               wt-it-docto.vl-merc-ori                 = TRUNC(wt-it-docto.vl-preori-ped * tt-item-totvs.quant-min,4)
                               wt-it-docto.vl-merc-tab                 = TRUNC(wt-it-docto.vl-preori-ped * tt-item-totvs.quant-min,4)
                               wt-it-docto.vl-merc-liq                 = ROUND(wt-it-docto.vl-preori-ped * tt-item-totvs.quant-min,2).
    
                        //RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "J|wt-it-docto.vl-preuni3:" + string(wt-it-docto.vl-preuni)).
                        //RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "J|wt-it-docto.vl-preori-ped3:" + string(wt-it-docto.vl-preori-ped)).
                        //RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "J|wt-it-docto.vl-pretab-ped3:" + string(wt-it-docto.vl-pretab-ped)).
                    END.
            END.
        END.
    END.

    // FAZ O CALCULO DOS IMPOSTOS
    //RUN pi-gerar-dados-extrato(c-estab + "||==============RECALCULAR===================="). 

    FOR EACH wt-it-docto NO-LOCK
       WHERE wt-it-docto.seq-wt-docto = wt-docto.seq-wt-docto:
        FIND FIRST wt-it-imposto
             WHERE wt-it-imposto.seq-wt-docto = wt-docto.seq-wt-docto
               AND wt-it-imposto.seq-wt-it-docto = wt-it-docto.seq-wt-it-docto NO-LOCK NO-ERROR.
        IF AVAIL wt-it-imposto THEN DO:  
            RUN pi-limpa.
        END.
    END.

    run inicializaAcompanhamento in h-bodi317im1br.
    run calculaImpostosBrasil in h-bodi317im1br(input  wt-docto.seq-wt-docto, output l-proc-ok-aux).
    run finalizaAcompanhamento in h-bodi317im1br.
    
    FOR EACH wt-it-docto NO-LOCK
       WHERE wt-it-docto.seq-wt-docto = wt-docto.seq-wt-docto:
        FIND FIRST wt-it-imposto
             WHERE wt-it-imposto.seq-wt-docto = wt-docto.seq-wt-docto
               AND wt-it-imposto.seq-wt-it-docto = wt-it-docto.seq-wt-it-docto NO-LOCK NO-ERROR.
        IF AVAIL wt-it-imposto THEN DO:                       
            FOR EACH tt-item-totvs
               WHERE tt-item-totvs.it-codigo   = wt-it-docto.it-codigo
                 AND tt-item-totvs.cod-estabel = wt-docto.cod-estabel
                 AND tt-item-totvs.quant-min   = wt-it-docto.quantidade[1]:
                RUN pi-calcula-pis-cofins.

                //verifica se pis e cofins sao tributados                                    
                assign tt-item-totvs.perc-pis     = de-aliq-pis
                       tt-item-totvs.vl-pis       = de-val-pis
                       tt-item-totvs.perc-cofins  = de-aliq-cofins
                       tt-item-totvs.vl-cofins    = de-val-cofins.

                IF VALID-HANDLE(h-cdapi995) THEN DO:
                    RUN pi-finalizar in h-cdapi995.
                    ASSIGN h-cdapi995 = ?.
                END.
                
                RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Aliq PIS    :" + string(de-aliq-pis       )). 
                RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Aliq COFINS :" + string(de-aliq-cofins    )).
                RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Aliq ICMS   :" + string(wt-it-imposto.aliquota-icm)).
                RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Base PIS    :" + string(de-val-base-pis   )). 
                RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Base COFINS :" + string(de-val-base-cofins)). 
                RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Vl PIS      :" + string(de-val-pis        )). 
                RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Vl COFINS   :" + string(de-val-cofins     )). 
                RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Vl ISS      :" + string(wt-it-imposto.vl-iss-it)). 
                RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Vl ICMS     :" + string(wt-it-imposto.vl-icms-it)). 
                RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Vl ICMS Sub :" + string(wt-it-imposto.vl-icmsub-it)). 
                RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Vl IPI      :" + string(wt-it-imposto.vl-ipi-it)).
                RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Vl Preco    :" + string(wt-it-docto.vl-preori)). 
                //RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Vl Preco Uni:" + string(wt-it-docto.vl-preuni)). 
                //RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Vl Preco Tab:" + string(wt-it-docto.vl-pretab-ped)). 
                RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Vl Tot Item :" + string(wt-it-docto.vl-tot-item)). 
                RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|============================================").
                                
                ASSIGN //tt-item-totvs.preco-unit           = wt-it-docto.vl-preuni
                       //tt-item-totvs.preco-total          = wt-it-docto.vl-tot-item
                       tt-item-totvs.vl-iss               = wt-it-imposto.vl-iss-it            
                       tt-item-totvs.perc-iss             = wt-it-imposto.aliquota-iss          
                       tt-item-totvs.vl-icms              = wt-it-imposto.vl-icms-it           
                       tt-item-totvs.perc-icms            = wt-it-imposto.aliquota-icm         
                       tt-item-totvs.vl-icmsst            = wt-it-imposto.vl-icmsub-it         
                       tt-item-totvs.vl-ipi               = wt-it-imposto.vl-ipi-it            
                       tt-item-totvs.perc-ipi             = wt-it-imposto.aliquota-ipi.          
                
            END.
        END.
    END.
     

END PROCEDURE.

PROCEDURE pi-regras-especificas:
    
    /*
    Nenhum - Preáo da Tabela - PIS/COFINS
    Parcial - Preáo da tabela - ICMS - PIS/COFINS
    Total - Preáo da tabela - ICMS - IPI - ST - PIS/COFINS
    */


    /*
    CASE tt-item-totvs.i-tributacao:
        WHEN 1 THEN RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Tributacao: 1 - Nenhum"). 
        WHEN 2 THEN RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Tributacao: 1 - Parcial"). 
        WHEN 3 THEN RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Tributacao: 1 - Total").
        WHEN 4 THEN RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Tributacao: 4 - Digitado maior").
    END CASE.
    */

    RUN pi-calcula-pis-cofins.
    
    ASSIGN de-preco-venda-ajust = tt-item-totvs.preco-venda.

    // AJUSTA PREÄO CONFORME TRIBUTAÄ«O DA TABELA - NENHUM/PARCIAL/TOTAL
    CASE tt-item-totvs.i-tributacao:
        WHEN 1 THEN DO:
            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|PRECO NENHUM").
            //RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|PRECO       : " + STRING(de-preco-venda-ajust)).

            // PIS/COFINS
            //RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|VAL PIS/COFINS: " + STRING(tt-item-totvs.preco-venda * (1 - ((de-aliq-pis + de-aliq-cofins) / 100)))).
            //ASSIGN de-preco-venda-ajust = tt-item-totvs.preco-venda * (1 - ((de-aliq-pis + de-aliq-cofins) / 100)).
            
            ASSIGN de-perc-icmsred = 0.
            RUN pi-config-tributo(OUTPUT de-perc-icmsred).

            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|PRECO NENHUM1").

            IF l-consumidor-final THEN DO:
                IF de-perc-icmsred <> 0 THEN DO:
                    ASSIGN de-preco-venda-ajust = de-preco-venda-ajust / (1 - (1 * ((wt-it-imposto.aliquota-icm / 100) *  (1 - (de-perc-icmsred / 100)) * (1 + (wt-it-imposto.aliquota-ipi / 100))))).
                    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|PRECO NENHUM2").
                END.
                ELSE DO:
                   IF wt-it-imposto.perc-red-icm > 0 AND 
                      wt-it-imposto.cd-trib-icm  = 4 AND 
                      tt-item-totvs.cod-estabel <> '110' THEN DO:
                      ASSIGN de-perc-icmsred = (wt-it-imposto.aliquota-icm - (wt-it-imposto.aliquota-icm * (wt-it-imposto.perc-red-icm / 100)))
                             de-preco-venda-ajust = de-preco-venda-ajust * ( 1 / ( 1 - ((de-perc-icmsred / 100) * ( 1 + (wt-it-imposto.aliquota-ipi / 100))))).
                             RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|PRECO NENHUM3").
                   END.
                   ELSE 
                       ASSIGN de-preco-venda-ajust = de-preco-venda-ajust * ( 1 / ( 1 - ((wt-it-imposto.aliquota-icm / 100) * ( 1 + (wt-it-imposto.aliquota-ipi / 100))))).
                       RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|PRECO NENHUM4").
                END.
            END.
            // REVENDA
            ELSE DO:
                IF de-perc-icmsred <> 0 THEN DO:
                    ASSIGN de-preco-venda-ajust = de-preco-venda-ajust / (1 - (1 * ((wt-it-imposto.aliquota-icm / 100) *  (1 - (de-perc-icmsred / 100))))).
                    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|PRECO NENHUM2").
                END.
                ELSE DO:
                   IF wt-it-imposto.perc-red-icm > 0 AND 
                      wt-it-imposto.cd-trib-icm  = 4 AND 
                      tt-item-totvs.cod-estabel <> '110' THEN DO:
                      ASSIGN de-perc-icmsred = (wt-it-imposto.aliquota-icm - (wt-it-imposto.aliquota-icm * (wt-it-imposto.perc-red-icm / 100)))
                             de-preco-venda-ajust = de-preco-venda-ajust * ( 1 / ( 1 - ((de-perc-icmsred / 100)))).
                             RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|PRECO NENHUM3").
                   END.
                   ELSE 
                       ASSIGN de-preco-venda-ajust = de-preco-venda-ajust * ( 1 / ( 1 - ((wt-it-imposto.aliquota-icm / 100)))).
                       RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|PRECO NENHUM4").
                END.
            END.    
            
            // ICMS
	        //ASSIGN de-preco-venda-ajust = de-preco-venda-ajust / (1 - (wt-it-imposto.aliquota-icm / 100)).
            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|% RED ICMS  : " + STRING(de-perc-icmsred)).
            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Perc Red ICM: " + STRING(wt-it-imposto.perc-red-icm)).
            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Cd Trib ICMS: " + STRING(wt-it-imposto.cd-trib-icm)).
            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Estab       : " + STRING(tt-item-totvs.cod-estabel)).
            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|VAL ICMS    : " + STRING(de-preco-venda-ajust * wt-it-imposto.aliquota-icm / 100)).

        END.
        WHEN 2 THEN DO:
            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|PRECO PARCIAL").

            // ICMS
            //RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|VAL ICMS    : " + STRING(wt-it-imposto.vl-icms-it / wt-it-docto.quantidade[1])).
            //ASSIGN de-preco-venda-ajust = de-preco-venda-ajust - (wt-it-imposto.vl-icms-it / wt-it-docto.quantidade[1]).

            //RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|PRECO       : " + STRING(de-preco-venda-ajust)).

            /*
            // PIS/COFINS
            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|VAL PIS/COFINS: " + STRING(tt-item-totvs.preco-venda * (1 - ((de-aliq-pis + de-aliq-cofins) / 100)))).
            ASSIGN de-preco-venda-ajust = de-preco-venda-ajust - (tt-item-totvs.preco-venda * ((de-aliq-pis + de-aliq-cofins) / 100)).
            */

        END.
        WHEN 3 THEN DO:
            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|PRECO TOTAL").
            ASSIGN de-fator-preco-total = (wt-it-docto.vl-tot-item / wt-it-docto.quantidade[1]) / de-preco-venda-ajust.
            ASSIGN de-preco-venda-ajust = de-preco-venda-ajust / de-fator-preco-total.
            //RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|PRECO         : " + STRING(de-preco-venda-ajust)).
        END.
        WHEN 4 THEN DO:
            RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|PRECO DIGITADO").
            ASSIGN de-fator-preco-total = (wt-it-docto.vl-tot-item / wt-it-docto.quantidade[1]) / de-preco-venda-ajust.
            ASSIGN de-preco-venda-ajust = de-preco-venda-ajust / de-fator-preco-total.
            //RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|PRECO       : " + STRING(de-preco-venda-ajust)).
        END.
    END.

    // GRAVA PRECO REAJUSTADO DA VARIAVEL DE PREÄO USADA POR TODO O PROGRAMA
    //RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|PV Anterior: " + STRING(tt-item-totvs.preco-venda)).
    ASSIGN tt-item-totvs.preco-venda = TRUNC(de-preco-venda-ajust,4)
           tt-item-totvs.de-rol      = TRUNC(de-preco-venda-ajust,4).
    //RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|PV Recalculado: " + STRING(tt-item-totvs.preco-venda)).

END.

PROCEDURE pi-calcula-impostos:

    FOR EACH wt-it-docto NO-LOCK
       WHERE wt-it-docto.seq-wt-docto = wt-docto.seq-wt-docto:
        FIND FIRST wt-it-imposto
             WHERE wt-it-imposto.seq-wt-docto = wt-docto.seq-wt-docto
               AND wt-it-imposto.seq-wt-it-docto = wt-it-docto.seq-wt-it-docto NO-LOCK NO-ERROR.
        IF AVAIL wt-it-imposto THEN DO:  
            RUN pi-limpa.
        END.
    END.

    /* CALCULA TODOS OS IMPOSTOS */
    /*run localizaWtItImposto in h-bodi317pr (input  wt-it-docto.seq-wt-docto,
                                            input  iSeqWtItDocto, 
                                            output l-proc-ok-aux). 
      */
    //RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Antes wt-it-docto.vl-tot-item: " + STRING(wt-it-docto.vl-tot-item)).

    /*
    FOR EACH wt-it-docto NO-LOCK
       WHERE wt-it-docto.seq-wt-docto = wt-docto.seq-wt-docto:
        RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(wt-it-docto.it-codigo) + "|A|" + STRING(wt-it-docto.seq-wt-it-docto) + "|" + STRING(wt-it-docto.nr-sequencia) + "|" + STRING(wt-it-docto.vl-preuni) + "|" + STRING(wt-it-docto.vl-tot-item)).
    END.
    */

    run inicializaAcompanhamento in h-bodi317im1br.
    run calculaImpostosBrasil in h-bodi317im1br(input  wt-docto.seq-wt-docto, output l-proc-ok-aux).
    run finalizaAcompanhamento in h-bodi317im1br.

    /*
    FOR EACH wt-it-docto NO-LOCK
       WHERE wt-it-docto.seq-wt-docto = wt-docto.seq-wt-docto:
        RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(wt-it-docto.it-codigo) + "|D|" + STRING(wt-it-docto.seq-wt-it-docto) + "|" + STRING(wt-it-docto.nr-sequencia) + "|" + STRING(wt-it-docto.vl-preuni) + "|" + STRING(wt-it-docto.vl-tot-item)).
    END.
    */


    //RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Depois wt-it-docto.vl-tot-item: " + STRING(wt-it-docto.vl-tot-item)).
        /*
    run localizaWtItImposto in h-bodi317pr (input  wt-it-docto.seq-wt-docto,
                                            input  iSeqWtItDocto, 
                                            output l-proc-ok-aux).*/
END PROCEDURE.

PROCEDURE pi-definicao-inicial:

    FOR EACH tt-item:
        CREATE tt-item-totvs.
        BUFFER-COPY tt-item TO tt-item-totvs.
    END.

    EMPTY TEMP-TABLE tt-prog-ponto.

    // AMBIENTE PRODUÄ«O OU HOMOLOGACAO
    RUN esp/es0018p.p (INPUT "ambiente":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FIND FIRST tt-prog-ponto NO-ERROR.
    IF AVAILABLE tt-prog-ponto               AND
       tt-prog-ponto.conteudo = "PRODUCAO":U THEN
        ASSIGN l-producao = YES.
    ELSE
        ASSIGN l-producao = NO.

    EMPTY TEMP-TABLE tt-prog-ponto2.

    // BUSCA NATUREZA E SERIE PARA USAR NOS ITENS DE SERVIÄO
    RUN esp/es0018p.p (INPUT "eswso010":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto2).

    FIND FIRST tt-prog-ponto2 NO-ERROR.

    // GRAVAR LOG NO DIRETORIO?
    RUN esp/es0018p.p (INPUT "log-wso2":U,
                       INPUT 2,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FIND FIRST tt-prog-ponto 
        WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = 'eswso0010' NO-ERROR.
    IF AVAILABLE tt-prog-ponto AND
       ENTRY(2,tt-prog-ponto.conteudo,";") = "yes":U THEN
        ASSIGN l-log = YES.
    ELSE
        ASSIGN l-log = NO.
		
	FIND FIRST tt-prog-ponto 
        WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = 'eswso0010e' NO-ERROR.
    IF AVAILABLE tt-prog-ponto AND
       ENTRY(2,tt-prog-ponto.conteudo,";") = "yes":U THEN
        ASSIGN l-log-ft4015 = YES.
    ELSE
        ASSIGN l-log-ft4015 = NO.	

    // ABERTURA DO LOG
    IF l-log = YES THEN DO:

        IF OPSYS = 'UNIX' THEN
            ASSIGN c-arquivo-log1 = '/usr/wrk/totvs/UNIX_eswso0010-' + STRING(i-cliente) + '-'.
           //ASSIGN c-arquivo-log1 = '/mnt/spool/totvs/UNIX_eswso0010-' + STRING(i-cliente) + '-'.
        ELSE
           ASSIGN c-arquivo-log1 = '\\erpapp\spool\totvs\WIN_eswso0010-' + STRING(i-cliente) + '-'.

        IF l-producao THEN
           ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'PROD.txt'.
        ELSE 
           ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'HOMOL.txt'.

    END.

END PROCEDURE.

PROCEDURE pi-validacao-inicial:

    /* BUSCA UM CLIENTE CASO N«O SEJA INFORMADO DE ACORDO COM OS MESMOS PARAMETROS */
    IF i-cliente = 0 THEN
       RUN pi-busca-cliente.
    
    FIND FIRST emitente 
         WHERE emitente.cod-emitente = i-cliente NO-LOCK NO-ERROR.
    
    IF NOT VALID-HANDLE (h-cdapi995)  THEN
        RUN cdp/cdapi995.p PERSISTENT SET h-cdapi995. 
    
    /* VERIFICA SE OS ITENS S«O DE SERVIÄO */
    FOR EACH tt-item-totvs,
        FIRST ITEM WHERE ITEM.it-codigo = tt-item-totvs.it-codigo NO-LOCK:
        IF item.cod-servico <> 0 THEN
            ASSIGN tt-item-totvs.log-servico = YES.
        //RUN pi-gerar-dados-extrato("|" + tt-item-totvs.it-codigo + "|" + "Serviáo: " + STRING(tt-item-totvs.log-servico)).
    END.
    
    /* VERIFICA SE ê CONSUMIDOR FINAL */
    if AVAIL emitente AND 
       c-natureza-cliente    <> 'EX'       and 
       log-contribuinte-icms  = "FALSE"    and 
      (c-inscricao-estadual   = ""         or 
       c-inscricao-estadual   = "ISENTO"   or
       c-inscricao-estadual   = "ISENTA")  THEN
       ASSIGN l-consumidor-final = YES.
       
    IF c-finalidade BEGINS 'Consumo' 
       AND AVAIL emitente          THEN
       ASSIGN l-consumidor-final = YES.

    IF AVAIL emitente THEN DO:

        // pagamento a vista
        FIND FIRST cond-pagto 
             WHERE cond-pagto.cod-cond-pag = i-cond-pag NO-LOCK NO-ERROR.
        IF emitente.ind-cre-cli = 5 AND 
            {diinc/i02di165.i 04 cond-pagto.cod-ven-par[1]} <> 'A Vista' THEN DO:
            RUN pi-erro (INPUT 412,
                        INPUT "CLIENTE_VENCIMENTO_A_VISTA",
                        INPUT "Cliente parametrizado para compras somente a vista. Favor entrar em contato com a equipe Comercial!" ).
        END.
      
        RUN pi-gerar-dados-extrato("||Emitente        : " + STRING(emitente.cod-emitente) + '- ' + emitente.nome-abrev). 
        RUN pi-gerar-dados-extrato("||Consumidor final: " + STRING(l-consumidor-final)).     
        RUN pi-gerar-dados-extrato("||Cod.entrega     : " + STRING(emitente.cod-entrega) ).
        
        //OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + 'wso0009.txt').
      
        IF NOT CAN-FIND (FIRST tt-item-totvs) THEN DO:
           RUN pi-erro (INPUT 412,
                        INPUT "COTACAO_SEM_PRODUTOS",
                        INPUT "Cotacao nao possui itens" ).
      
           RUN pi-gerar-dados-extrato("||Cotacao nao possui itens").
      
           //RUN pi-erro (INPUT 'Produto nao informado').
           //RETURN 'NOK'.
        END.
      
        FIND FIRST cond-pagto 
             WHERE cond-pagto.cod-cond-pag = i-cond-pag NO-LOCK NO-ERROR.
        IF NOT AVAIL cond-pagto AND 
           i-cond-pag > 0 THEN DO:
            RUN pi-erro (INPUT 412,
                         INPUT "CONDICAO_PAGAMENTO_INEXISTENTE",
                         INPUT "Condicao de pagamento inexistente: " + string(i-cond-pag)).
      
            RUN pi-gerar-dados-extrato("||Condiá∆o de pagamento inexistente: " + string(i-cond-pag)). 
            RETURN 'NOK'.
        END.
        ELSE DO:
            FIND FIRST tab-finan-indice NO-LOCK
                 WHERE tab-finan-indice.nr-tab-finan = cond-pagto.nr-tab-finan
                   AND tab-finan-indice.num-seq = cond-pagto.nr-ind-finan NO-ERROR.
      
            IF AVAIL tab-finan-indice THEN DO:
               ASSIGN de-indice-finan = tab-finan-indice.tab-ind-fin.
            END.
        END.   
      
        FOR EACH tt-item-totvs 
            BREAK BY tt-item-totvs.cod-estabel: 
            FIND FIRST item
                 WHERE item.it-codigo = tt-item-totvs.it-codigo NO-LOCK
            NO-ERROR.
      
            IF NOT AVAIL ITEM THEN DO:
                RUN pi-erro (INPUT 412,
                             INPUT "PRODUTO_NAO_CADASTRADO",
                             INPUT "Produto nao cadastrado: " + tt-item-totvs.it-codigo).
      
                RUN pi-gerar-dados-extrato("|" + tt-item-totvs.it-codigo + "|Produto nao cadastrado: " + tt-item-totvs.it-codigo). 
                //RUN pi-erro (INPUT 'Produto informado nao encontrado').
                //RETURN 'NOK'.
            END.    
            ELSE DO:
                IF ITEM.ind-item-fat = NO THEN DO:
                    FIND FIRST item-uni-estab
                         WHERE item-uni-estab.cod-estabel = tt-item-totvs.cod-estabel
                           AND item-uni-estab.it-codigo   = tt-item-totvs.it-codigo NO-LOCK NO-ERROR.
                    IF item-uni-estab.ind-item-fat = NO THEN DO:
                        RUN pi-erro (INPUT 413,
                                     INPUT "ITEM_NAO_FATURAVEL",
                                     INPUT "Item nao esta marcado como faturavel: " + tt-item-totvs.it-codigo + 
                                            " para o estabelecimento " + tt-item-totvs.cod-estabel + ". Favor entrar em contato com a equipe do Tributario para libera-lo.").
         
                        RUN pi-gerar-dados-extrato("|" + tt-item-totvs.it-codigo + "|Item nao esta marcado como faturavel: " + tt-item-totvs.it-codigo). 
                    END.
                END.
            END.
      
            FIND FIRST preco-item 
                  WHERE preco-item.it-codigo  = tt-item-totvs.it-codigo
                   AND preco-item.nr-tabpre  = tt-item-totvs.nr-tabpre  //c-tab-preco 
                   AND preco-item.cod-refer  = tt-item-totvs.cod-estabel
                   and preco-item.dt-inival <= today    
                   and preco-item.situacao   = 1 NO-LOCK NO-ERROR.
            IF NOT AVAIL preco-item THEN DO:
                RUN pi-erro (INPUT 412,
                              INPUT "Item sem preco ativo",
                              INPUT "Item " + tt-item-totvs.it-codigo + " sem preco ativo na tabela de precos: " + tt-item-totvs.nr-tabpre + " para estabelecimento: " + tt-item-totvs.cod-estabel).
                RUN pi-gerar-dados-extrato("|" + tt-item-totvs.it-codigo + "|Item sem preco ativo na tabela de precos: " + tt-item-totvs.nr-tabpre + " para estabelecimento: " + tt-item-totvs.cod-estabel).
            END.
        END.
    END.

    FOR EACH tt-item-totvs:
        IF NOT CAN-FIND(FIRST tt-estabelec
                        WHERE tt-estabelec.cod-estabel = tt-item-totvs.cod-estabel
                          AND tt-estabelec.log-servico = tt-item-totvs.log-servico) THEN DO:
            CREATE tt-estabelec.
            ASSIGN tt-estabelec.cod-estabel = tt-item-totvs.cod-estabel
                   tt-estabelec.log-servico = tt-item-totvs.log-servico.
        END.
    END.

END PROCEDURE.

PROCEDURE pi-grava-tabela:

    ASSIGN l-recalcular = NO.

    FOR EACH wt-it-docto NO-LOCK
       WHERE wt-it-docto.seq-wt-docto = wt-docto.seq-wt-docto:
        FIND FIRST wt-it-imposto
             WHERE wt-it-imposto.seq-wt-docto    = wt-docto.seq-wt-docto
               AND wt-it-imposto.seq-wt-it-docto = wt-it-docto.seq-wt-it-docto NO-LOCK NO-ERROR.
        IF AVAIL wt-it-imposto THEN DO:

            FOR EACH tt-item-totvs
               WHERE tt-item-totvs.it-codigo   = wt-it-docto.it-codigo
                 AND tt-item-totvs.cod-estabel = wt-docto.cod-estabel
                 AND tt-item-totvs.quant-min   = wt-it-docto.quantidade[1]:

                ASSIGN tt-item-totvs.de-rol = 0.

                //RUN pi-gerar-dados-extrato("||"). 

                RUN pi-calcula-pis-cofins.

                //verifica se pis e cofins sao tributados                                    
                assign tt-item-totvs.perc-pis     = de-aliq-pis
                       tt-item-totvs.vl-pis       = de-val-pis
                       tt-item-totvs.perc-cofins  = de-aliq-cofins
                       tt-item-totvs.vl-cofins    = de-val-cofins.

                //RUN pi-gerar-dados-extrato(tt-item-totvs.cod-estabel + "|" + STRING(tt-item-totvs.it-codigo) + "|tt-item-totvs.preco-unit   : " + STRING(tt-item-totvs.preco-unit     )). 
                //RUN pi-gerar-dados-extrato(tt-item-totvs.cod-estabel + "|" + STRING(tt-item-totvs.it-codigo) + "|wt-it-docto.vl-preori: " + STRING(wt-it-docto.vl-preori     )). 
                //RUN pi-gerar-dados-extrato(tt-item-totvs.cod-estabel + "|" + STRING(tt-item-totvs.it-codigo) + "|wt-it-docto.vl-pretab: " + STRING(wt-it-docto.vl-pretab-ped     )). 
                //RUN pi-gerar-dados-extrato(tt-item-totvs.cod-estabel + "|" + STRING(tt-item-totvs.it-codigo) + "|tt-item-totvs.perc-descont : " + STRING(tt-item-totvs.perc-descont       )). 
                //RUN pi-gerar-dados-extrato(tt-item-totvs.cod-estabel + "|" + STRING(tt-item-totvs.it-codigo) + "|tt-item-totvs.quant-min    : " + STRING(tt-item-totvs.quant-min  )).
                //RUN pi-gerar-dados-extrato(tt-item-totvs.cod-estabel + "|" + STRING(tt-item-totvs.it-codigo) + "|tt-item-totvs.val-desconto: " + STRING(tt-item-totvs.val-desconto * tt-item-totvs.quant-min  )).

                ASSIGN de-ipi-st-sem-desc-coml = wt-it-imposto.vl-ipi-it + wt-it-imposto.vl-icmsub-it.

                /*
                IF  tt-item-totvs.fator-calc-desc <> 1
                AND tt-item-totvs.fator-calc-desc <> 0 THEN
                    ASSIGN de-ipi-st-sem-desc-coml = (wt-it-imposto.vl-ipi-it + wt-it-imposto.vl-icmsub-it) / (1 - (tt-item-totvs.fator-calc-desc / 100)).
                ELSE
                    ASSIGN de-ipi-st-sem-desc-coml = wt-it-imposto.vl-ipi-it + wt-it-imposto.vl-icmsub-it.
                    */

                //RUN pi-gerar-dados-extrato(tt-item-totvs.cod-estabel + "|" + STRING(tt-item-totvs.it-codigo) + "|wt-it-docto.vl-tot-item: " + STRING(wt-it-docto.vl-tot-item)).

                ASSIGN tt-item-totvs.nat-operacao         = wt-it-docto.nat-operacao
                       //tt-item-totvs.preco-unit           = (wt-it-docto.vl-tot-item + (tt-item-totvs.val-desconto * tt-item-totvs.quant-min) - de-ipi-st-sem-desc-coml) / tt-item-totvs.quant-min
                       tt-item-totvs.vl-iss               = wt-it-imposto.vl-iss-it            
                       tt-item-totvs.perc-iss             = wt-it-imposto.aliquota-iss          
                       tt-item-totvs.vl-icms              = wt-it-imposto.vl-icms-it           
                       tt-item-totvs.perc-icms            = wt-it-imposto.aliquota-icm         
                       tt-item-totvs.vl-icmsst            = wt-it-imposto.vl-icmsub-it         
                       tt-item-totvs.vl-ipi               = wt-it-imposto.vl-ipi-it            
                       tt-item-totvs.perc-ipi             = wt-it-imposto.aliquota-ipi          
                       tt-item-totvs.preco-total          = wt-it-docto.vl-tot-item.

                FIND FIRST int-segmento-item
                     WHERE int-segmento-item.it-codigo = tt-item-totvs.it-codigo
                       AND int-segmento-item.cod-gr-cli = emitente.cod-gr-cli
                       AND int-segmento-item.dt-valid-ini <= TODAY
                       AND (int-segmento-item.dt-valid-fim = ?  
                        OR int-segmento-item.dt-valid-fim >= TODAY) NO-LOCK NO-ERROR.
                FIND FIRST int-segmento-portifolio
                     WHERE int-segmento-portifolio.cod-segmento = int-segmento-item.cod-segmento NO-LOCK NO-ERROR.
                IF AVAIL int-segmento-item THEN
                   ASSIGN tt-item-totvs.segmento = int-segmento-portifolio.descricao.

                RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|IPI+ST S/ Desc: " + STRING(de-ipi-st-sem-desc-coml   )). 
                //RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Preco Unit    : ( " + STRING(wt-it-docto.vl-tot-item) + " + " + STRING(tt-item-totvs.val-desconto * tt-item-totvs.quant-min ) + " - " + STRING(de-ipi-st-sem-desc-coml) + " ) / " + STRING(tt-item-totvs.quant-min)). 
                RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Preco Unit    : " + STRING(tt-item-totvs.preco-unit   )).
                RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Preco Total   : " + STRING(tt-item-totvs.preco-total  )).
                RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Segmento      : " + tt-item-totvs.segmento).

                ASSIGN //tt-item-totvs.val-desconto = tt-item-totvs.preco-unit - TRUNC(wt-it-docto.vl-preori,4)
                       tt-item-totvs.preco-unit   = TRUNC(tt-item-totvs.preco-unit,4)
                       tt-item-totvs.preco-total  = TRUNC(tt-item-totvs.preco-total,4).

                RUN pi-gerar-dados-extrato(tt-item-totvs.cod-estabel + "|" + STRING(tt-item-totvs.it-codigo) + "|Val Desconto11        : " + STRING(tt-item-totvs.val-desconto)). 

                // ITEM SEM DIFAL DESTACADO
                IF NOT CAN-FIND(FIRST item-nf-adc NO-LOCK
                   WHERE item-nf-adc.cod-estab         = wt-docto.cod-estabel
                     AND item-nf-adc.cod-serie         = wt-docto.serie
                     AND item-nf-adc.cod-nota-fisc     = string(iSeqWtDocto)
                     AND item-nf-adc.cdn-emitente      = wt-docto.cod-emitente
                     AND item-nf-adc.cod-natur-operac  = wt-it-docto.nat-operacao
                     AND item-nf-adc.idi-tip-dado      = 24
                     AND item-nf-adc.cod-item          = wt-it-docto.it-codigo
                     AND item-nf-adc.val-livre-3 <> 0) THEN
                    RUN pi-calc-sem-difal.

                // ITEM COM DIFAL DESTACADO
                FOR FIRST item-nf-adc NO-LOCK
                    WHERE item-nf-adc.cod-estab         = wt-docto.cod-estabel
                      AND item-nf-adc.cod-serie         = wt-docto.serie
                      AND item-nf-adc.cod-nota-fisc     = string(iSeqWtDocto)
                      AND item-nf-adc.cdn-emitente      = wt-docto.cod-emitente
                      AND item-nf-adc.cod-natur-operac  = wt-it-docto.nat-operacao
                      AND item-nf-adc.idi-tip-dado      = 24
                      //AND item-nf-adc.num-seq           = wt-it-docto.nr-entrega
                      //AND item-nf-adc.num-seq-item-nf   = wt-it-docto.nr-sequencia
                      AND item-nf-adc.cod-item          = wt-it-docto.it-codigo
                      AND item-nf-adc.val-livre-3      <> 0:
                        RUN pi-difal.
                END.

                IF de-preco-difal <> 0 THEN
                    ASSIGN l-recalcular = YES.
            END.
        END.
    END.
END PROCEDURE.

PROCEDURE pi-busca-desconto-cliente:
    {esp/wso/eswso0010.i1}
END PROCEDURE.
        
PROCEDURE pi-erro:
    DEFINE INPUT PARAM i-code AS INTEGER NO-UNDO.
    DEFINE INPUT PARAM c-info AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAM c-erro AS CHARACTER NO-UNDO.
    
    CREATE tt-erro.
    ASSIGN tt-erro.codigo     = i-code
           tt-erro.informacao = c-info
           tt-erro.mensagem   = c-erro.

END PROCEDURE.

PROCEDURE pi-config-tributo:

    DEFINE OUTPUT PARAM pPercReduc  AS DECIMAL  NO-UNDO.

    DEFINE VAR dPercReduc AS DECIMAL NO-UNDO.

    ASSIGN dPercReduc = 0.

    /*ESTADOS que devem ser desconsideradas*/
    FIND first ponto-programa
         WHERE ponto-programa.nome-programa = "msg0138":U
           AND ponto-programa.ponto         = 1 NO-LOCK NO-ERROR.
    IF AVAIL ponto-programa THEN DO:
        FIND FIRST conteudo-programa NO-LOCK
             WHERE conteudo-programa.cod-programa      = ponto-programa.cod-programa
               and ENTRY(1,conteudo-programa.conteudo) = tt-item-totvs.cod-estabel
               and ENTRY(2,conteudo-programa.conteudo) = emitente.estado NO-ERROR.
        IF AVAIL conteudo-programa THEN DO:
           FOR EACH ct-clas-item
              WHERE ct-clas-item.cod-item = tt-item-totvs.it-codigo
              BREAK BY ct-clas-item.cod-item 
                    BY ct-clas-item.num-livre-1:
               IF FIRST-OF(ct-clas-item.cod-item) THEN DO:
                   FIND FIRST ct-clas-fis
                        WHERE ct-clas-fis.cod-clas-fis = ct-clas-item.cod-clas-fis
                          and ct-clas-fis.idi-tip-clas = 1 no-error.
                   if avail ct-clas-fis then 
                      find first ct-trib-clas-fisc
                           where ct-trib-clas-fisc.cod-clas-fis = ct-clas-fis.cod-clas-fis no-error.
                   if avail ct-trib-clas-fisc then 
                      find first ct-configur-trib
                           where ct-configur-trib.cod-configur-trib = ct-trib-clas-fisc.cod-configur-trib no-error.
                      if avail ct-configur-trib then 
                         find first ct-formul
                              where ct-formul.cod-formul = ct-configur-trib.cod-formul-base-calc.
                 
                   if AVAIL ct-configur-trib AND ct-configur-trib.cod-tip-trib = 'ICMS' and avail ct-formul and ct-formul.val-perc-reduc > 0 then DO:
                         /*assign pPreco = round(pPrecoUnit / (1 - (1 * ((pPercIcms / 100) *  (1 - (ct-formul.val-perc-reduc / 100))))) * pIndice,4).*/
                       ASSIGN dPercReduc = ct-formul.val-perc-reduc.
                   END.
               END.
           END.
        END.
    END. 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Configurador de tributos - Perc Reduc ICMS: " + STRING(dPercReduc)). 
    
    ASSIGN pPercReduc = dPercReduc.
END PROCEDURE.
                               /*
PROCEDURE pi-atualiza-preco-zfm.
   /*** Retira impostos que sío deduzidos do preªo quando cliente possui SUFRAMA e estˇ na zona franca de Manaus ***/
   
   assign de-desc-pis-zfm    = 0
          de-desc-cofins-zfm = 0
          de-descto-zf       = 0
          de-tot-zfm         = 0.

   if  avail natur-oper then
       if  natur-oper.log-deduz-desc-zfm-tot-nf THEN DO:
           
           assign de-desc-pis-zfm    = natur-oper.val-perc-desc-pis-zfm
                  de-desc-cofins-zfm = natur-oper.val-perc-desc-cofins-zfm.

           IF natur-oper.log-deduz-desc-zfm-tot-nf THEN
              RUN pi-gerar-dados-extrato("|" + tt-item-totvs.it-codigo + "|" + "DEDUZ ZFM PIS/COFINS/ICMS: " + STRING(de-desc-pis-zfm) + ' ' + STRING(de-desc-cofins-zfm) + ' ' + substr(natur-oper.char-2,66,5)).
        
           // PIS / COFINS / ICMS 
           IF natur-oper.val-perc-desc-pis-zfm > 0    THEN  ASSIGN de-desc-pis-zfm = (tt-item-totvs.preco-venda * de-desc-pis-zfm / 100).
           IF natur-oper.val-perc-desc-cofins-zfm > 0 THEN  ASSIGN de-desc-cofins-zfm = (tt-item-totvs.preco-venda * de-desc-cofins-zfm / 100).
           IF DEC(substr(natur-oper.char-2,66,5)) > 0 THEN  ASSIGN de-descto-zf = (tt-item-totvs.preco-venda * DEC(substr(natur-oper.char-2,66,5)) / 100).

           ASSIGN tt-item-totvs.preco-venda = tt-item-totvs.preco-venda - de-desc-pis-zfm - de-desc-cofins-zfm - de-descto-zf.
        
           ASSIGN de-tot-zfm =  de-desc-pis-zfm + de-desc-cofins-zfm + de-descto-zf.
           RUN pi-gerar-dados-extrato("|" + tt-item-totvs.it-codigo + "|" + "   PRE∞O ZFM SEM PIS/COFINS/ICMS: " + STRING(tt-item-totvs.preco-venda - de-desc-pis-zfm - de-desc-cofins-zfm - de-descto-zf)).
           RUN pi-gerar-dados-extrato("|" + tt-item-totvs.it-codigo + "|" + "   PIS/COFINS/ICMS: " + STRING(de-desc-pis-zfm) + ' ' + STRING(de-desc-cofins-zfm) + ' ' + string(de-descto-zf)).
       END.

   RETURN "OK":U.

END.
*/
PROCEDURE pi-busca-cliente:
    RUN pi-gerar-dados-extrato("||BUSCA CLIENTE GENERICO ").

    DEFINE VARIABLE i-natureza AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-tributo  AS INTEGER NO-UNDO.

    IF c-natureza-cliente BEGINS 'Pessoa F'     THEN ASSIGN i-natureza = 1. ELSE
    IF c-natureza-cliente BEGINS 'Pessoa J'     THEN ASSIGN i-natureza = 2. ELSE
    IF c-natureza-cliente BEGINS 'Extrangeiro'  THEN ASSIGN i-natureza = 3. 

    RUN pi-gerar-dados-extrato("||Natureza Cliente: " + STRING(i-natureza) + ' ' + c-natureza-cliente ).

    CASE c-tipo-tributacao:
        WHEN 'Nao Cumulativo'               THEN ASSIGN i-tributo = 1. 
        WHEN 'Cumulativo todo ou em partes' THEN ASSIGN i-tributo = 2. 
        WHEN 'Simples'                      THEN ASSIGN i-tributo = 3. 
        WHEN 'Nenhum'                       THEN ASSIGN i-tributo = 4. 
        WHEN 'Isento'                       THEN ASSIGN i-tributo = 5.
    END CASE.

    RUN pi-gerar-dados-extrato("||Tributacao: " + string(i-tributo) + " " + c-tipo-tributacao ).
    RUN pi-gerar-dados-extrato("||Estado UF: " + c-uf ).
    RUN pi-gerar-dados-extrato("||Log Contrib : " + STRING(log-contribuinte-icms)).

    FOR EACH emitente NO-LOCK
        WHERE emitente.identific            <> 2
          AND emitente.natureza             = i-natureza
          AND emitente.estado               = c-uf
          AND emitente.contrib-icms         = IF log-contribuinte-icms = 'true' THEN YES ELSE NO,
        FIRST int-emitente OF emitente NO-LOCK
        WHERE int-emitente.id-ativo          = YES
          AND int-emitente.ind-forma-tributo = i-tributo:

       IF emitente.ind-cre-cli = 4 THEN NEXT.  //cliente suspenso

   IF (emitente.cod-suframa     <> ''   AND 
           c-cod-suframa             = '')  OR
          (emitente.cod-suframa      = ''   AND 
           c-cod-suframa            <> '')  THEN NEXT.

       DISP emitente.cod-emit '1' ind-vendas-alc. 

       IF (int-emitente.ind-vendas-alc  = 1    AND  //yes
           c-cliente-alc                = 'false')  OR 
          (int-emitente.ind-vendas-alc  = 0   AND   //no
           c-cliente-alc                = 'true') THEN NEXT.

       IF c-inscricao-estadual    = 'ISENTO'  AND 
          emitente.ins-estadual   = 'ISENTO'   
          THEN ASSIGN i-cliente = emitente.cod-emitente.

       IF c-inscricao-estadual    = ''        AND 
          emitente.ins-estadual   = ''  
          THEN ASSIGN i-cliente = emitente.cod-emitente.

       IF emitente.ins-estadual <> ''         AND 
          emitente.ins-estadual <> 'ISENTO'   THEN
          IF c-inscricao-estadual <> ''       AND
             c-inscricao-estadual <> 'ISENTO' 
             THEN ASSIGN i-cliente = emitente.cod-emitente.

       IF i-cliente <> 0 THEN LEAVE.
    END.


    IF i-cliente = 0 THEN DO:
       //RUN pi-erro (INPUT "Cliente genÏrico nao encontrado com o perfil informado para calculo de orcamento. Favor cadastrar o cliente.").
       RUN pi-erro (INPUT 412,
                    INPUT "ERRO_DE_VALIDACAO", 
                    INPUT "Cliente generico nao encontrado com o perfil informado para calculo de orcamento. Favor cadastrar o cliente.").
    END. 
    ELSE 
        RUN pi-gerar-dados-extrato("||Cliente Generico: " + string(i-cliente) ).


END PROCEDURE.

/*

PROCEDURE pi-preco-nenhum:

    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|PRECO NENHUM").

    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|PRECO SEM IMPOSTOS - CALCULAR O ICMS E ICMS-ST E SOMAR NO PRECO").

    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Antes ajuste total  IPI: " + STRING(de-preco-venda-ajust)).
    //ASSIGN de-preco-venda-ajust = de-preco-venda-ajust * (1 + (wt-it-imposto.aliquota-ipi / 100)).
    ASSIGN tt-item-totvs.val-inicial = tt-item-totvs.val-inicial * (1 + (wt-it-imposto.aliquota-ipi / 100)).
    ASSIGN de-preco-venda-ajust = de-preco-venda-ajust * (1 + (wt-it-imposto.aliquota-ipi / 100)).
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Depois ajuste total IPI: " + STRING(de-preco-venda-ajust)).



/*
    RUN pi-gerar-dados-extrato("|" + tt-item-totvs.it-codigo + "|" + ' PRECO SEM IMPOSTOS - SOMAR ICMS E ICMS-ST').         

    ASSIGN de-perc-icmsred = 0.
    RUN pi-config-tributo(OUTPUT de-perc-icmsred).

    IF de-perc-icmsred <> 0 THEN DO:
       ASSIGN de-vl-preco = (ttwt-it-docto.vl-preori) / (1 - (1 * ((wt-it-imposto.aliquota-icm / 100) *  (1 - (de-perc-icmsred / 100))))).
    END.
    ELSE DO:
       IF wt-it-imposto.perc-red-icm > 0 AND 
          wt-it-imposto.cd-trib-icm  = 4 AND 
          tt-item-totvs.cod-estabel <> '110'   THEN DO:
          ASSIGN de-perc-icmsred = (wt-it-imposto.aliquota-icm - (wt-it-imposto.aliquota-icm * (wt-it-imposto.perc-red-icm / 100))).
                 de-vl-preco = (ttwt-it-docto.vl-preori) * (1 / ((100 - (de-perc-icmsred)) / 100)).
       END.
       ELSE 
         /* IF wt-it-imposto.cd-trib-icm = 1  OR 
             emitente.cod-suframa <> ''     THEN   se cliente possuir suframa, calcula preco com icms mesmo q isento */
             ASSIGN de-vl-preco = (ttwt-it-docto.vl-preori) * (1 / ((100 - (wt-it-imposto.aliquota-icm)) / 100)).
         /* ELSE 
             ASSIGN de-vl-preco = (ttwt-it-docto.vl-preori).*/
    END.

    IF de-perc-icmsred <> 0 THEN 
       RUN pi-gerar-dados-extrato("|" + tt-item-totvs.it-codigo + "|" + " Percentual reduzido de ICMS: " + string(de-perc-icmsred)).
    ELSE 
       RUN pi-gerar-dados-extrato("|" + tt-item-totvs.it-codigo + "|" + " Percentual ICMS: " + string(wt-it-imposto.aliquota-icm)).

    RUN  pi-gerar-dados-extrato("|" + tt-item-totvs.it-codigo + "|" + " Tributacao ICMS: "  +  string(wt-it-imposto.cd-trib-icm)).
    RUN pi-gerar-dados-extrato("|" + tt-item-totvs.it-codigo + "|" + "     Preco + ICMS: "  + string(ttwt-it-docto.vl-preori) + ' + ' + STRING(de-vl-preco - ttwt-it-docto.vl-preori) + ' = ' + string(de-vl-preco)).

    ASSIGN tt-item-totvs.preco-venda = de-vl-preco.
    */


END PROCEDURE.
                           
PROCEDURE pi-preco-parcial:

    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|PRECO PARCIAL").

    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|PRECO PARCIAL - TIRAR O ICMS DO PRECO PARA CALCULAR NOVAMENTE COM A ALIQUOTA DO ICMS").
    //ASSIGN de-preco-venda-ajust = de-preco-venda-ajust * (1 - (wt-it-imposto.aliquota-icm / 100) * (1 - (de-perc-icmsred / 100))).

    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Antes ajuste parcial  IPI: " + STRING(de-preco-venda-ajust)).
    //ASSIGN de-preco-venda-ajust = de-preco-venda-ajust * (1 + (wt-it-imposto.aliquota-ipi / 100)).

    ASSIGN tt-item-totvs.val-inicial = tt-item-totvs.val-inicial * (1 + (wt-it-imposto.aliquota-ipi / 100)).
    ASSIGN de-preco-venda-ajust = de-preco-venda-ajust - wt-it-imposto.vl-icms-it - wt-it-imposto.vl-icmsub-it.
    ASSIGN de-preco-venda-ajust = de-preco-venda-ajust * (1 + (wt-it-imposto.aliquota-ipi / 100)).
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Depois ajuste parcial IPI: " + STRING(de-preco-venda-ajust)).


    //ASSIGN de-preco-venda-ajust = de-preco-venda-ajust * (1 + (wt-it-imposto.aliquota-ipi / 100).


/*
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|" + STRING(de-preco-venda-ajust) + " " + STRING(wt-it-imposto.aliquota-icm) + " " + STRING(de-perc-icmsred)).
    DEFINE VARIABLE de-vl-icms-par AS DECIMAL DECIMALS 4 NO-UNDO.
    ASSIGN de-vl-icms-par = tt-item-totvs.val-inicial * (wt-it-imposto.aliquota-icm / 100).


    ASSIGN de-preco-venda-ajust = de-preco-venda-ajust - de-vl-icms-par. // falta reducao.

    //ASSIGN de-preco-venda-ajust = de-preco-venda-ajust * (1 - (wt-it-imposto.aliquota-icm / 100) * (1 - (de-perc-icmsred / 100))).

    
//ASSIGN de-preco-venda-ajust = de-preco-venda-ajust * (1 - (wt-it-imposto.aliquota-icm / 100) * (1 - (de-perc-icmsred / 100))) * (1 - tt-item-totvs.perc-pis / 100) * (1 - tt-item-totvs.perc-cofins / 100).
*/
      
END PROCEDURE.
    
PROCEDURE pi-preco-total:

    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|PRECO TOTAL").

    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|PRECO CHEIO COM TODOS OS IMPOSTOS - TIRAR TODOS OS IMPOSTOS DO PRECO PARA CALCULAR NOVAMENTE COM TODOS ELES").

    ASSIGN de-preco-venda-ajust = de-preco-venda-ajust - wt-it-imposto.vl-icms-it - 

    
    /* VALOR RECALCULADO DO ITEM DIVIDIDO PELA QUANTIDADE E PELO VALOR ANTERIOR */
    ASSIGN d-fator = wt-it-docto.vl-tot-item / tt-item-totvs.quant-min / de-preco-venda-ajust.

    /* VALOR ANTERIOR MULTIPLICADO PELO FATOR */
    ASSIGN de-preco-venda-ajust = de-preco-venda-ajust / d-fator.

    ASSIGN de-preco-venda-ajust = de-preco-venda-ajust * (1 + (wt-it-imposto.aliquota-ipi / 100)).

/*
    /* PREÄO SEM PIS */
    ASSIGN de-preco-venda-ajust = de-preco-venda-ajust - (tt-item-totvs.vl-pis / tt-item-totvs.quant-min).

    /* PREÄO SEM COFINS */
    ASSIGN de-preco-venda-ajust = de-preco-venda-ajust - (tt-item-totvs.vl-cofins / tt-item-totvs.quant-min).

    /* PREÄO SEM ICMS */
    ASSIGN de-preco-venda-ajust = de-preco-venda-ajust * (1 - (wt-it-imposto.aliquota-icm / 100) * (1 - (de-perc-icmsred / 100))).
      */

    /*
    RUN pi-gerar-dados-extrato(tt-item-totvs.it-codigo + "|" + " PRECO CHEIO COM TODOS OS IMPOSTOS - TIRAR IPI E ICMS-ST "). 

    FIND FIRST Wt-It-docto 
         WHERE Wt-it-docto.seq-wt-docto    =  iSeqWtDocto
           AND Wt-it-docto.seq-wt-it-docto =  iSeqWtItDocto NO-ERROR.
   
    FIND FIRST ttWt-docto NO-ERROR.
    RUN calculaPrecos IN   h-bodi317pr (INPUT NO, OUTPUT l-procedimento-ok).  
                
    RUN setRecord    IN h-bodi321 (TABLE ttWt-It-docto).
    RUN updateRecord IN h-bodi321.
    
    RUN pi-gerar-dados-extrato("|" + tt-item-totvs.it-codigo + "|" + " Atualizar itens da nota 4" ).
    IF AVAIL wt-it-docto THEN
    RUN atualizaDadosItemNota   IN h-bodi317pr(OUTPUT l-procedimento-ok).

    RUN calculaImpostosBrasil in h-bodi317im1br(INPUT  iSeqWtDocto,
                                                OUTPUT l-proc-ok-aux).

    RUN pi-gerar-dados-extrato("|" + tt-item-totvs.it-codigo + "|" + "VL-preori: " + STRING(ttwt-it-docto.vl-preori) ).
              
     FIND FIRST estabelec WHERE estabelec.cod-estabel = ttwt-docto.cod-estabel NO-LOCK NO-ERROR.
 
     RUN pi-gerar-dados-extrato("|" + tt-item-totvs.it-codigo + "|" + "Item : " + STRING( wt-it-docto.it-codigo )).  
     RUN pi-gerar-dados-extrato("|" + tt-item-totvs.it-codigo + "|" + "Estado or: " + STRING( estabelec.estado )).   
     RUN pi-gerar-dados-extrato("|" + tt-item-totvs.it-codigo + "|" + "Estado De: " + STRING( ttwt-docto.estado )).  


     ASSIGN d-fator = 0.
     IF AVAIL estabelec  THEN
     FIND FIRST item-uf 
          WHERE ITEM-UF.it-codigo       = wt-it-docto.it-codigo
            AND item-uf.cod-estado-orig = estabelec.estado
            AND item-uf.estado          = ttwt-docto.estado NO-LOCK NO-ERROR.
     IF AVAIL item-uf THEN DO: 
        RUN pi-gerar-dados-extrato("|" + tt-item-totvs.it-codigo + "|" + " de-vl-preco " + string(de-vl-preco)).
        RUN pi-gerar-dados-extrato("|" + tt-item-totvs.it-codigo + "|" + "wt-it-imposto.aliquota-ipi      " + string(wt-it-imposto.aliquota-ipi)).   
        RUN pi-gerar-dados-extrato("|" + tt-item-totvs.it-codigo + "|" + "item-uf.per-sub-tri             " + string(item-uf.per-sub-tri       )).   
        RUN pi-gerar-dados-extrato("|" + tt-item-totvs.it-codigo + "|" + "item-uf.val-icms-est-subt       " + string(item-uf.dec-1 )).  
        RUN pi-gerar-dados-extrato("|" + tt-item-totvs.it-codigo + "|" + "item-uf.perc-red-sub            " + string(item-uf.perc-red-sub      )).   
        RUN pi-gerar-dados-extrato("|" + tt-item-totvs.it-codigo + "|" + "wt-it-imposto.aliquota-icm      " + string(wt-it-imposto.aliquota-icm )).  

        IF wt-it-imposto.vl-icmsub-it > 0 THEN DO:
           ASSIGN d-fator = (1 + wt-it-imposto.aliquota-ipi / 100) * (1 + item-uf.per-sub-tri / 100) * 
                            (item-uf.dec-1 / 100 * (1 - item-uf.perc-red-sub / 100)) - wt-it-imposto.aliquota-icm / 100.
          
        END.
       
     END.

     RUN pi-gerar-dados-extrato("|" + tt-item-totvs.it-codigo + "|" + "Vl Pre Ori: " + STRING(ttwt-it-docto.vl-preori) ).
     RUN pi-gerar-dados-extrato("|" + tt-item-totvs.it-codigo + "|" + "Fator icms subs: " + STRING(d-fator) ).
     RUN pi-gerar-dados-extrato("|" + tt-item-totvs.it-codigo + "|" + "IPI: " + STRING(wt-it-imposto.aliquota-ipi) ).
     
     ASSIGN tt-item-totvs.preco-venda = (ttwt-it-docto.vl-preori * ( 1 + d-fator + (wt-it-imposto.aliquota-ipi / 100))).

     RUN pi-gerar-dados-extrato("|" + tt-item-totvs.it-codigo + "|" + "Preco com fator aplicado: " + STRING(tt-item-totvs.preco-venda) ).
     */
    
END PROCEDURE.
*/

PROCEDURE pi-calc-sem-difal:

    DEFINE VARIABLE de-aliq-icms       AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-aliq-ipi        AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-vl-icms         AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-aliq-difal      AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-aliq-pis-cofins AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-ipi             AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-preco-final     AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-vl-pis-cofins   AS DECIMAL NO-UNDO.

    DEFINE VARIABLE de-vl-icms-sem-desc       AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-rol-sem-desc           AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-preco-difal-sem-desc   AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-vl-pis-cofins-sem-desc AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-preco-sem-ipi AS DECIMAL NO-UNDO.

    ASSIGN de-preco-difal = 0
           de-preco-difal-sem-desc = 0.

    // ALIQUOTAS
    ASSIGN de-aliq-icms        = wt-it-imposto.aliquota-icm / 100
           de-aliq-ipi         = wt-it-imposto.aliquota-ipi / 100
           de-aliq-pis-cofins  = TRUNC((1 - de-aliq-icms) * ((tt-item-totvs.perc-pis + tt-item-totvs.perc-cofins) / 100),4)
           //de-preco-sem-ipi    = tt-item-totvs.val-inicial / (1 + de-aliq-ipi).
           de-preco-sem-ipi    = TRUNC(wt-it-docto.vl-pretab-ped / (1 + de-aliq-ipi),4)
           //tt-item-totvs.val-desconto = de-preco-sem-ipi * tt-item-totvs.fator-calc-desc / 100
        .

    //RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "J|wt-it-docto.vl-preori-ped3:" + string(wt-it-docto.vl-preori-ped)).
    //RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "J|wt-it-docto.vl-pretab-ped3:" + string(wt-it-docto.vl-pretab-ped)).



    /*
    ASSIGN de-vl-icms-sem-desc       = tt-item-totvs.val-inicial * de-aliq-icms    
           de-vl-pis-cofins-sem-desc = ((tt-item-totvs.val-inicial / (1 + de-aliq-ipi)) - de-vl-icms-sem-desc) * ((tt-item-totvs.perc-pis + tt-item-totvs.perc-cofins) / 100)
           de-rol-sem-desc           = (tt-item-totvs.val-inicial / (1 + de-aliq-ipi)) - de-vl-icms-sem-desc - de-vl-pis-cofins-sem-desc
           de-preco-difal-sem-desc   = de-rol-sem-desc / (1 - (de-aliq-icms + de-aliq-pis-cofins + de-aliq-difal)).
           */

    // VAL SEM DESC
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|==============VAL SEM DESC=================="           ).

    ASSIGN de-vl-icms-sem-desc       = TRUNC(wt-it-docto.vl-pretab-ped * de-aliq-icms,4)
           de-vl-pis-cofins-sem-desc = TRUNC(((wt-it-docto.vl-pretab-ped / (1 + de-aliq-ipi)) - de-vl-icms-sem-desc) * ((tt-item-totvs.perc-pis + tt-item-totvs.perc-cofins) / 100),4)
           de-rol-sem-desc           = TRUNC((wt-it-docto.vl-pretab-ped / (1 + de-aliq-ipi)) - de-vl-icms-sem-desc - de-vl-pis-cofins-sem-desc,4)
           de-preco-difal-sem-desc   = TRUNC(de-rol-sem-desc + de-vl-icms-sem-desc + de-vl-pis-cofins-sem-desc,4).
    
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|ICMS          : " + STRING(de-vl-icms-sem-desc)). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|PIS COFINS    : " + STRING(de-vl-pis-cofins-sem-desc)). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|ROL           : " + STRING(de-rol-sem-desc)). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Preco sem Desc: " + STRING(de-preco-difal-sem-desc)).
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|============================================"           ).

    IF tt-item-totvs.val-desconto > 0 THEN DO:
        ASSIGN //tt-item-totvs.preco-unit  = wt-it-docto.vl-tot-item
               de-vl-icms          = TRUNC((wt-it-docto.vl-preori + (wt-it-docto.vl-preori * de-aliq-ipi)) * de-aliq-icms,4)
               de-vl-pis-cofins    = TRUNC((wt-it-docto.vl-preori - de-vl-icms) * ((tt-item-totvs.perc-pis + tt-item-totvs.perc-cofins) / 100),4)
               tt-item-totvs.de-rol = TRUNC((wt-it-docto.vl-preori - de-vl-pis-cofins - de-vl-icms),4).
    END.
    ELSE DO:
        ASSIGN de-vl-icms          = TRUNC((tt-item-totvs.preco-unit + (tt-item-totvs.preco-unit * de-aliq-ipi)) * de-aliq-icms,4)
               de-vl-pis-cofins    = TRUNC((tt-item-totvs.preco-unit - de-vl-icms) * ((tt-item-totvs.perc-pis + tt-item-totvs.perc-cofins) / 100),4)
               tt-item-totvs.de-rol = TRUNC(tt-item-totvs.preco-unit - de-vl-pis-cofins - de-vl-icms,4).
    END.
    
    /*
    ASSIGN de-preco-difal      = tt-item-totvs.de-rol / (1 - (de-aliq-icms + de-aliq-pis-cofins))
           de-ipi              = de-preco-difal * de-aliq-ipi
           de-preco-final      = de-preco-difal + de-ipi.
           */

    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Aliq ICMS Orig: " + STRING(wt-it-imposto.aliquota-icm) + " - " + STRING(de-perc-icmsred) + "%"). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Aliq ICMS Dest: " + STRING('')). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Aliq IPI      : " + STRING(tt-item-totvs.perc-ipi     )).
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Aliq PIS      : " + STRING(tt-item-totvs.perc-pis     )). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Aliq COFINS   : " + STRING(tt-item-totvs.perc-cofins  )).
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Aliq ISS      : " + STRING(tt-item-totvs.perc-iss     )). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Vl ICMS       : " + STRING(tt-item-totvs.vl-icms      )). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Vl ICMS ST    : " + STRING(tt-item-totvs.vl-icmsst    )). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Vl IPI        : " + STRING(tt-item-totvs.vl-ipi       )). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Vl PIS        : " + STRING(tt-item-totvs.vl-pis       )). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Vl COFINS     : " + STRING(tt-item-totvs.vl-cofins    )).
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Vl ISS        : " + STRING(tt-item-totvs.vl-iss       )). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|==============VAL PLANILHA=================="           ).
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Preco tabela  : " + STRING(wt-it-docto.vl-pretab-ped)). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Pre tab S/ IPI: " + STRING(de-preco-sem-ipi)). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|% Desconto    : " + STRING(tt-item-totvs.fator-calc-desc)). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Valor Desconto: " + STRING(tt-item-totvs.val-desconto)). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Valor Liquido : " + STRING(wt-it-docto.vl-preori)). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|IPI           : " + STRING(TRUNC(wt-it-docto.vl-preori * de-aliq-ipi,4))). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|PIS COFINS    : " + STRING(de-vl-pis-cofins)). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|ICMS          : " + STRING(de-vl-icms)). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|ROL           : " + STRING(tt-item-totvs.de-rol)). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|============================================"           ).

    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|==============SEM DIFAL====================="           ). 
    
    //ASSIGN //tt-item-totvs.preco-unit  = de-preco-difal-sem-desc
           //tt-item-totvs.vl-ipi      = de-ipi * tt-item-totvs.quant-min
           //tt-item-totvs.preco-total = de-preco-final * tt-item-totvs.quant-min
        //.

    ASSIGN //tt-item-totvs.val-desconto = tt-item-totvs.preco-unit - TRUNC(wt-it-docto.vl-preori,4)
           tt-item-totvs.preco-unit   = TRUNC(tt-item-totvs.preco-unit,4)
           tt-item-totvs.preco-total  = TRUNC(tt-item-totvs.preco-total,4). 

    RUN pi-gerar-dados-extrato(tt-item-totvs.cod-estabel + "|" + STRING(tt-item-totvs.it-codigo) + "|Val Desconto12        : " + STRING(tt-item-totvs.val-desconto)). 

    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|============================================"           ). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Preco Unit        : " + STRING(tt-item-totvs.preco-unit      )). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Vl IPI            : " + STRING(tt-item-totvs.vl-ipi          )). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Preco Total       : " + STRING(tt-item-totvs.preco-total     )). 
    

END PROCEDURE.

PROCEDURE pi-difal:

    DEFINE VARIABLE de-aliq-icms       AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-aliq-ipi        AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-vl-icms         AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-aliq-difal      AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-aliq-pis-cofins AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-ipi             AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-preco-final     AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-vl-pis-cofins   AS DECIMAL NO-UNDO.

    DEFINE VARIABLE de-vl-icms-sem-desc       AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-rol-sem-desc           AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-preco-difal-sem-desc   AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-vl-pis-cofins-sem-desc AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-preco-sem-ipi AS DECIMAL NO-UNDO.

    ASSIGN de-preco-difal = 0
           de-preco-difal-sem-desc = 0.

    // ALIQUOTAS
    ASSIGN de-aliq-icms        = wt-it-imposto.aliquota-icm / 100
           de-aliq-ipi         = wt-it-imposto.aliquota-ipi / 100
           de-aliq-pis-cofins  = TRUNC((1 - de-aliq-icms) * ((tt-item-totvs.perc-pis + tt-item-totvs.perc-cofins) / 100),4)
           de-aliq-difal       = TRUNC((DEC(item-nf-adc.cod-livre-1) - DEC(item-nf-adc.cod-livre-2)) / 100,4)
           //de-preco-sem-ipi    = tt-item-totvs.val-inicial / (1 + de-aliq-ipi).
           de-preco-sem-ipi    = TRUNC(wt-it-docto.vl-pretab-ped / (1 + de-aliq-ipi),4)
           //tt-item-totvs.val-desconto = de-preco-sem-ipi * tt-item-totvs.fator-calc-desc / 100
        .

    //RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "J|wt-it-docto.vl-preori-ped4:" + string(wt-it-docto.vl-preori-ped)).
    //RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "J|wt-it-docto.vl-pretab-ped4:" + string(wt-it-docto.vl-pretab-ped)).

    // BASE DUPLA DIFAL
    IF AVAIL emitente
         AND emitente.estado = 'SP' THEN DO:
        RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|DIFAL BASE DUPLA" ).
        ASSIGN de-aliq-difal =(((((((100 + tt-item-totvs.perc-ipi) * ( 1 - (tt-item-totvs.perc-icms / 100))) / ( 1 - (dec(item-nf-adc.cod-livre-1) / 100)) * (dec(item-nf-adc.cod-livre-1) / 100)) - 
                                   ((100 + tt-item-totvs.perc-ipi) * (tt-item-totvs.perc-icms / 100))) / ( 100 + tt-item-totvs.perc-ipi))) * 100)
               de-aliq-difal = de-aliq-difal / 100.
    END.

    /*
    ASSIGN de-vl-icms-sem-desc       = tt-item-totvs.val-inicial * de-aliq-icms    
           de-vl-pis-cofins-sem-desc = ((tt-item-totvs.val-inicial / (1 + de-aliq-ipi)) - de-vl-icms-sem-desc) * ((tt-item-totvs.perc-pis + tt-item-totvs.perc-cofins) / 100)
           de-rol-sem-desc           = (tt-item-totvs.val-inicial / (1 + de-aliq-ipi)) - de-vl-icms-sem-desc - de-vl-pis-cofins-sem-desc
           de-preco-difal-sem-desc   = de-rol-sem-desc / (1 - (de-aliq-icms + de-aliq-pis-cofins + de-aliq-difal)).
           */

    // VAL SEM DESC
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|==============VAL SEM DESC=================="           ).

    ASSIGN de-vl-icms-sem-desc       = TRUNC(wt-it-docto.vl-pretab-ped * de-aliq-icms,4)
           de-vl-pis-cofins-sem-desc = TRUNC(((wt-it-docto.vl-pretab-ped / (1 + de-aliq-ipi)) - de-vl-icms-sem-desc) * ((tt-item-totvs.perc-pis + tt-item-totvs.perc-cofins) / 100),4)
           de-rol-sem-desc           = TRUNC((wt-it-docto.vl-pretab-ped / (1 + de-aliq-ipi)) - de-vl-icms-sem-desc - de-vl-pis-cofins-sem-desc,4)
           de-preco-difal-sem-desc   = TRUNC(de-rol-sem-desc / (1 - (de-aliq-icms + de-aliq-pis-cofins + de-aliq-difal)),4).
    
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|ICMS          : " + STRING(de-vl-icms-sem-desc)). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|PIS COFINS    : " + STRING(de-vl-pis-cofins-sem-desc)). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|ROL           : " + STRING(de-rol-sem-desc)). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Preco Sem Desc: " + STRING(de-preco-difal-sem-desc)).
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|============================================"           ).

    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Aliq ICMS Orig: " + STRING(item-nf-adc.cod-livre-2)). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Aliq ICMS Dest: " + STRING(item-nf-adc.cod-livre-1)). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Aliq IPI      : " + STRING(tt-item-totvs.perc-ipi     )).
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Aliq ISS      : " + STRING(tt-item-totvs.perc-iss     )). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Aliq PIS      : " + STRING(tt-item-totvs.perc-pis     )). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Aliq COFINS   : " + STRING(tt-item-totvs.perc-cofins  )).
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Aliq ISS      : " + STRING(tt-item-totvs.perc-iss     )). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Vl ICMS       : " + STRING(tt-item-totvs.vl-icms      )). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Vl ICMS ST    : " + STRING(tt-item-totvs.vl-icmsst    )). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Vl IPI        : " + STRING(tt-item-totvs.vl-ipi       )). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Vl PIS        : " + STRING(tt-item-totvs.vl-pis       )). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Vl COFINS     : " + STRING(tt-item-totvs.vl-cofins    )).
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Vl ISS        : " + STRING(tt-item-totvs.vl-iss       )). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|============================================"           ).
        
    IF de-aliq-difal = 0 THEN NEXT.

    IF tt-item-totvs.val-desconto > 0 THEN DO:
        ASSIGN //tt-item-totvs.preco-unit  = wt-it-docto.vl-tot-item
               de-vl-icms          = TRUNC((wt-it-docto.vl-preori + (wt-it-docto.vl-preori * de-aliq-ipi)) * de-aliq-icms,4)
               de-vl-pis-cofins    = TRUNC((wt-it-docto.vl-preori - de-vl-icms) * ((tt-item-totvs.perc-pis + tt-item-totvs.perc-cofins) / 100),4)
               tt-item-totvs.de-rol              = TRUNC((wt-it-docto.vl-preori - de-vl-pis-cofins - de-vl-icms),4).
    END.
    ELSE DO:
        ASSIGN de-vl-icms          = TRUNC((tt-item-totvs.preco-unit + (tt-item-totvs.preco-unit * de-aliq-ipi)) * de-aliq-icms,4)
               de-vl-pis-cofins    = TRUNC((tt-item-totvs.preco-unit - de-vl-icms) * ((tt-item-totvs.perc-pis + tt-item-totvs.perc-cofins) / 100),4)
               tt-item-totvs.de-rol              = TRUNC(tt-item-totvs.preco-unit - de-vl-pis-cofins - de-vl-icms,4).
    END.
    
    ASSIGN de-preco-difal      = tt-item-totvs.de-rol / (1 - (de-aliq-icms + de-aliq-pis-cofins + de-aliq-difal))
           de-ipi              = de-preco-difal * de-aliq-ipi
           de-preco-final      = de-preco-difal + de-ipi.

    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|==============VAL PLANILHA=================="           ).
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Preco tabela      : " + STRING(wt-it-docto.vl-pretab-ped)). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Pre tab S/ IPI    : " + STRING(de-preco-sem-ipi)). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|% Desconto        : " + STRING(tt-item-totvs.fator-calc-desc)). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Valor Desconto    : " + STRING(tt-item-totvs.val-desconto)). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Valor Liquido     : " + STRING(wt-it-docto.vl-preori)). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|IPI               : " + STRING(TRUNC(wt-it-docto.vl-preori * de-aliq-ipi,4))). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|PIS COFINS        : " + STRING(de-vl-pis-cofins)). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|ICMS              : " + STRING(de-vl-icms)). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|ROL               : " + STRING(tt-item-totvs.de-rol)). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|============================================"           ).

    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|==============SOMA DIFAL===================="           ). 
    
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Vl PIS/COFINS     : " + STRING(de-vl-pis-cofins)). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Vl Tot Item       : " + STRING(wt-it-docto.vl-tot-item)). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|ROL               : " + STRING(tt-item-totvs.de-rol                  )). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Aliq PIS/COFINS   : (1 - " + STRING(de-aliq-icms) + ") * ((" + STRING(tt-item-totvs.perc-pis) + " + " + STRING(tt-item-totvs.perc-cofins) + ") / 100)"). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Aliq PIS/COFINS   : " + STRING(de-aliq-pis-cofins      )). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Aliq ICMS     : " + STRING(de-aliq-icms ,">>9.9999999999"            )). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Aliq DIFAL    : " + STRING(de-aliq-difal,">>9.9999999999"           )). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|============================================"           ).
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Preco DIFAL       : " + STRING(de-preco-difal          )). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Vl IPI            : " + STRING(de-ipi                  )). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Preco Final       : " + STRING(de-preco-final          )). 
    
    ASSIGN tt-item-totvs.preco-unit   = TRUNC(de-preco-difal-sem-desc,4)
           tt-item-totvs.val-desconto-pci = TRUNC(tt-item-totvs.preco-unit * tt-item-totvs.fator-calc-desc / 100,4)
           tt-item-totvs.vl-ipi       = TRUNC(de-ipi * tt-item-totvs.quant-min,4)
           tt-item-totvs.preco-total  = TRUNC(de-preco-final * tt-item-totvs.quant-min,4).

    ASSIGN tt-item-totvs.val-desconto = tt-item-totvs.val-desconto-comercial + tt-item-totvs.val-desconto-pci.

    RUN pi-gerar-dados-extrato(tt-item-totvs.cod-estabel + "|" + STRING(tt-item-totvs.it-codigo) + "|Val Desconto13        : " + STRING(tt-item-totvs.val-desconto)). 

    /* PONTO DE AJUSTE */
    
    // NENHUM
    IF tt-item-totvs.i-tributacao = 1 THEN DO:
        IF tt-item-totvs.fator-calc-desc = 0 THEN
            ASSIGN tt-item-totvs.preco-unit   = de-preco-difal
                   tt-item-totvs.val-desconto-pci = 0.
        ELSE
            ASSIGN tt-item-totvs.preco-unit   = TRUNC(de-preco-difal / ((100 - tt-item-totvs.fator-calc-desc) / 100),4)
                   tt-item-totvs.val-desconto-pci = TRUNC(tt-item-totvs.preco-unit * tt-item-totvs.fator-calc-desc / 100,4).
    END.

    ASSIGN tt-item-totvs.val-desconto = tt-item-totvs.val-desconto-comercial + tt-item-totvs.val-desconto-pci.

    RUN pi-gerar-dados-extrato(tt-item-totvs.cod-estabel + "|" + STRING(tt-item-totvs.it-codigo) + "|Val Desconto14        : " + STRING(tt-item-totvs.val-desconto)). 

    // PARCIAL
    IF tt-item-totvs.i-tributacao = 2 THEN DO:
        IF tt-item-totvs.fator-calc-desc = 0 THEN
            ASSIGN tt-item-totvs.preco-unit   = de-preco-difal
                   tt-item-totvs.val-desconto-pci = 0.
        ELSE
            ASSIGN tt-item-totvs.preco-unit   = de-preco-difal / ((100 - tt-item-totvs.fator-calc-desc) / 100)
                   tt-item-totvs.val-desconto-pci = TRUNC(tt-item-totvs.preco-unit * tt-item-totvs.fator-calc-desc / 100,4).
    END.

    ASSIGN tt-item-totvs.val-desconto = tt-item-totvs.val-desconto-comercial + tt-item-totvs.val-desconto-pci.

    RUN pi-gerar-dados-extrato(tt-item-totvs.cod-estabel + "|" + STRING(tt-item-totvs.it-codigo) + "|Val Desconto15        : " + STRING(tt-item-totvs.val-desconto)). 

    // TOTAL
    IF tt-item-totvs.i-tributacao = 3 THEN DO:
        IF tt-item-totvs.fator-calc-desc = 0 THEN
            ASSIGN tt-item-totvs.preco-unit   = de-preco-difal
                   tt-item-totvs.val-desconto-pci = 0.
        ELSE
            ASSIGN tt-item-totvs.preco-unit   = de-preco-difal / ((100 - tt-item-totvs.fator-calc-desc) / 100)
                   tt-item-totvs.val-desconto-pci = TRUNC(tt-item-totvs.preco-unit * tt-item-totvs.fator-calc-desc / 100,4).
    END.

    ASSIGN tt-item-totvs.val-desconto = tt-item-totvs.val-desconto-comercial + tt-item-totvs.val-desconto-pci.

    RUN pi-gerar-dados-extrato(tt-item-totvs.cod-estabel + "|" + STRING(tt-item-totvs.it-codigo) + "|Val Desconto16        : " + STRING(tt-item-totvs.val-desconto)). 

    // DIGITADO
    IF tt-item-totvs.i-tributacao = 4 THEN DO:
        IF tt-item-totvs.fator-calc-desc = 0 THEN
            ASSIGN tt-item-totvs.preco-unit   = de-preco-difal
                   tt-item-totvs.val-desconto-pci = 0.
        ELSE
            ASSIGN tt-item-totvs.preco-unit   = de-preco-difal / ((100 - tt-item-totvs.fator-calc-desc) / 100)
                   tt-item-totvs.val-desconto-pci = TRUNC(tt-item-totvs.preco-unit * tt-item-totvs.fator-calc-desc / 100,4).
    END.

    ASSIGN tt-item-totvs.val-desconto = tt-item-totvs.val-desconto-comercial + tt-item-totvs.val-desconto-pci.

    RUN pi-gerar-dados-extrato(tt-item-totvs.cod-estabel + "|" + STRING(tt-item-totvs.it-codigo) + "|Val Desconto17.1      : " + STRING(wt-it-docto.vl-preori-ped)). 
    RUN pi-gerar-dados-extrato(tt-item-totvs.cod-estabel + "|" + STRING(tt-item-totvs.it-codigo) + "|Val Desconto17.2      : " + STRING(de-preco-difal)). 
    RUN pi-gerar-dados-extrato(tt-item-totvs.cod-estabel + "|" + STRING(tt-item-totvs.it-codigo) + "|Val Desconto17.3      : " + STRING(tt-item-totvs.preco-unit)). 
    RUN pi-gerar-dados-extrato(tt-item-totvs.cod-estabel + "|" + STRING(tt-item-totvs.it-codigo) + "|Val Desconto17.4      : " + STRING(tt-item-totvs.val-desconto)). 

    FIND CURRENT wt-it-docto EXCLUSIVE-LOCK NO-ERROR.
    ASSIGN wt-it-docto.vl-preori-ped = de-preco-difal.
    FIND CURRENT wt-it-docto NO-LOCK NO-ERROR.

    ASSIGN //tt-item-totvs.val-desconto = tt-item-totvs.preco-unit - TRUNC(wt-it-docto.vl-preori,4)
           tt-item-totvs.preco-unit   = TRUNC(tt-item-totvs.preco-unit,4)
           tt-item-totvs.preco-total  = TRUNC(tt-item-totvs.preco-total,4).

    RUN pi-gerar-dados-extrato(tt-item-totvs.cod-estabel + "|" + STRING(tt-item-totvs.it-codigo) + "|Val Desconto18        : " + STRING(tt-item-totvs.val-desconto)). 
    
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|============================================"           ). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Preco Unit        : " + STRING(tt-item-totvs.preco-unit      )). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Vl IPI            : " + STRING(tt-item-totvs.vl-ipi          )). 
    RUN pi-gerar-dados-extrato(c-estab + "|" + STRING(tt-item-totvs.it-codigo) + "|Preco Total       : " + STRING(tt-item-totvs.preco-total     )). 


END PROCEDURE.

PROCEDURE pi-gerar-dados-extrato:
    def input param p-string as char no-undo.

    ASSIGN i-seq-log = i-seq-log + 1.
    CREATE tt-log.
    ASSIGN tt-log.seq         = i-seq-log
           tt-log.cod-estabel = ENTRY(1,p-string,"|")
           tt-log.it-codigo   = ENTRY(2,p-string,"|")
           tt-log.mensagem    = p-string.

    IF tt-log.mensagem = "||INICIO"
    OR tt-log.mensagem = "FINAL||" THEN
        ASSIGN tt-log.mensagem = tt-log.mensagem + " - " + STRING(DATETIME(TODAY, MTIME)).

END PROCEDURE.

PROCEDURE pi-grava-log:

    if  c-arquivo-log1 <> "" and c-arquivo-log1 <> ? then do:

        output to value(c-arquivo-log1) append.
        FOR EACH tt-log
            BREAK BY tt-log.cod-estabel
                  BY tt-log.it-codigo
                  BY tt-log.seq:

            IF  FIRST-OF(tt-log.cod-estabel)
            AND FIRST-OF(tt-log.it-codigo)
            AND FIRST-OF(tt-log.seq) THEN
                put SKIP.

            put tt-log.mensagem format "x(200)" skip.
            //put STRING(tt-log.seq,"9999") + "|" + tt-log.mensagem format "x(200)" skip.

            IF  LAST-OF(tt-log.cod-estabel)
            AND LAST-OF(tt-log.it-codigo)
            AND LAST-OF(tt-log.seq) THEN
                put SKIP.

        END.                                      
        output close. 
    
    end.
END.


