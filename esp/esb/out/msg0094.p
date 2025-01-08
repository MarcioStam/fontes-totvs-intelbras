
CREATE WIDGET-POOL.
DEFINE TEMP-TABLE tt-nota-fiscal LIKE nota-fiscal.

/*IF OPSYS = "UNIX" THEN  */
    log-manager:WRITE-MESSAGE("inicio msg0094").

{esp/esb/out/msg0094.i }
{utp/ut-glob.i}
{include/i-freeac.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

RAW-TRANSFER raw-param TO tt-nota-fiscal.

DEFINE VARIABLE iTipoEntrega        AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-endereco          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-rua               AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nro               AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-comp              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-cdapi704          AS HANDLE      NO-UNDO.
DEFINE VARIABLE v-tot-vl-bicms-it   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-tot-vl-icms-it    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-tot-icmssub-it    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-tot-vl-ipi-it     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-vl-finsocial      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-tot-vl-icmsub-it  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-narrativa-do-item AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-vl-pis            AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-item-substituto   AS CHARACTER   NO-UNDO.

DEFINE BUFFER b-ped-venda FOR ped-venda.

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' for cabecalho, conteudo, msg0094,EnderecoEntrega, msg0094-itens, msg0094-item, EnderecoEntregaIt
   DATA-RELATION FOR conteudo, msg0094      RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0094, EnderecoEntrega RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0094, msg0094-itens RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0094-itens, msg0094-item RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0094-item, EnderecoEntregaIt RELATION-FIELDS (idm, idm) NESTED.

DEFINE DATASET mensagemr XML-NODE-NAME "MENSAGEM" FOR cabecalhor, conteudor, msg0094r, resultado
   DATA-RELATION FOR conteudor, msg0094r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0094r, resultado RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalho.
ASSIGN cabecalho.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF"
       cabecalho.CodigoMensagem    = "MSG0094"
       cabecalho.LoginUsuario      = c-seg-usuario.

CREATE conteudo.
CREATE resultado. 

DEF BUFFER b-nota-orig FOR NOTA-FISCAL.

FOR FIRST emitente NO-LOCK
    WHERE emitente.cod-emitente = tt-nota-fiscal.cod-emitente: END.
IF  AVAIL emitente AND emitente.identific = 2 THEN
    RETURN.

FIND FIRST int-emitente NO-LOCK
    WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.

IF  int-emitente.cod-guid = "" THEN RETURN.

IF int-emitente.guid-class = "" THEN
    RETURN.

FIND natur-oper NO-LOCK
    WHERE natur-oper.nat-operacao = tt-nota-fiscal.nat-operacao NO-ERROR.


IF  AVAIL natur-oper AND (natur-oper.tipo = 1 AND natur-oper.especie-doc <> "NFD") THEN 
    RETURN.


/** Ignora notas que nío geram faturamento **/
/* IF  AVAIL natur-oper                                                                       */
/* AND NOT natur-oper.atual-estat THEN DO:                                                    */
/*                                                                                            */
/*     LOG-MANAGER:WRITE-MESSAGE("Nota n∆o enviada! Ignora notas que nío geram faturamento"). */
/*     RETURN.                                                                                */
/* END.                                                                                       */


FIND FIRST repres NO-LOCK
    WHERE repres.cod-rep = tt-nota-fiscal.cod-rep NO-ERROR.

FIND FIRST cond-pagto NO-LOCK 
    WHERE cond-pagto.cod-cond-pag = tt-nota-fiscal.cod-cond-pag NO-ERROR.

FOR FIRST ped-venda NO-LOCK
    WHERE ped-venda.nome-abrev = tt-nota-fiscal.nome-ab-cli
      AND ped-venda.nr-pedcli  = tt-nota-fiscal.nr-pedcli: END. 

FIND loc-entr NO-LOCK 
    WHERE loc-entr.nome-abrev  = tt-nota-fiscal.nome-ab-cli
      AND loc-entr.cod-entrega = tt-nota-fiscal.cod-entrega NO-ERROR.                         

FIND int-loc-entr NO-LOCK
    WHERE int-loc-entr.nome-abrev  = tt-nota-fiscal.nome-ab-cli
      AND int-loc-entr.cod-entrega = tt-nota-fiscal.cod-entrega NO-ERROR.

FIND FIRST transporte NO-LOCK
    WHERE  transporte.nome-abrev = tt-nota-fiscal.nome-transp NO-ERROR.

FIND FIRST int-nota-conhec NO-LOCK
     WHERE int-nota-conhec.nr-nota-fis = tt-nota-fiscal.nr-nota-fis
       AND int-nota-conhec.serie       = tt-nota-fiscal.serie
       AND int-nota-conhec.cod-estabel = tt-nota-fiscal.cod-estabel NO-ERROR.

CREATE msg0094.
    
IF tt-nota-fiscal.nome-transp = "Pac" OR tt-nota-fiscal.nome-transp = "E-Sedex" THEN 
    ASSIGN iTipoEntrega = 5.
ELSE IF tt-nota-fiscal.nome-transp = "SEDEX"  THEN 
    ASSIGN iTipoEntrega = 23.
ELSE IF tt-nota-fiscal.nome-transp = "FEDEX"  THEN 
    ASSIGN iTipoEntrega = 3. 
ELSE IF tt-nota-fiscal.nome-transp = "RETIRA" THEN 
    ASSIGN iTipoEntrega = 7. 
ELSE 
    ASSIGN iTipoEntrega = 17.

IF  AVAIL int-loc-entr 
AND int-loc-entr.endereco-completo <> "" THEN
    ASSIGN c-endereco = int-loc-entr.endereco-completo.
ELSE
    ASSIGN c-endereco = loc-entr.endereco.

ASSIGN c-rua      = ""
       c-nro      = ""
       c-comp     = "".

IF  INDEX(c-endereco,CHR(ASC("ß"))) > 0 THEN /* Retirar caracter especial */
    ASSIGN c-endereco = REPLACE(c-endereco,CHR(ASC("ß")),"").

RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.
RUN pi-trata-endereco IN h-cdapi704 (INPUT  c-endereco,
                                     OUTPUT c-rua, 
                                     OUTPUT c-nro, 
                                     OUTPUT c-comp).
DELETE PROCEDURE h-cdapi704.
/*Nota Fiscal*/
ASSIGN cabecalho.NumeroOperacao    =  tt-nota-fiscal.nr-nota-fis .

ASSIGN msg0094.ChaveIntegracao                 = tt-nota-fiscal.cod-estabel + "," + tt-nota-fiscal.serie + "," + tt-nota-fiscal.nr-nota-fis
       msg0094.NumeroNotaFiscal                = tt-nota-fiscal.nr-nota-fis 
       msg0094.Nome                            = STRING(tt-nota-fiscal.nr-nota-fis) + "-" + STRING(msg0094.DataEmissao) + "-" + emitente.nome-emit
       msg0094.NumeroSerie                     = tt-nota-fiscal.serie          
       msg0094.CodigoClienteCRM                = int-emitente.cod-guid
       msg0094.NumeroPedido                    = IF AVAIL ped-venda THEN ped-venda.nr-pedido ELSE 0
       msg0094.NumeroPedidoCliente             = tt-nota-fiscal.nr-pedcli     
       msg0094.Descricao                       = ""
       msg0094.Estabelecimento                 = tt-nota-fiscal.cod-estabel   
       msg0094.CondicaoPagamento               = tt-nota-fiscal.cod-cond-pag  
       msg0094.NomeAbreviadoCliente            = tt-nota-fiscal.nome-ab-cli   
       msg0094.NaturezaOperacao                = tt-nota-fiscal.nat-operacao  
       msg0094.Moeda                           = "Real"     
       msg0094.SituacaoNota                    = IF tt-nota-fiscal.dt-cancel <> ? THEN 3 ELSE 0 
       msg0094.SituacaoEntrega                 = IF tt-nota-fiscal.dt-cancel <> ? THEN 100003 ELSE 1 
       msg0094.DataEmissao                     = tt-nota-fiscal.dt-emis-nota  
       msg0094.DataSaida                       = tt-nota-fiscal.dt-saida      
       msg0094.DataEntrega                     = ?
       msg0094.DataConfirmacao                 = TODAY
       msg0094.DataCancelamento                = tt-nota-fiscal.dt-cancel  
       msg0094.DataConclusao                   = ?
       msg0094.ValorFrete                      = round(tt-nota-fiscal.vl-frete,4)    
       msg0094.PesoLiquido                     = round(tt-nota-fiscal.peso-liq-tot,4)
       msg0094.PesoBruto                       = round(tt-nota-fiscal.peso-bru-tot,4)
       msg0094.Observacao                      = fnConverteChar(tt-nota-fiscal.observ-nota)
       msg0094.Volume                          = IF  STRING(tt-nota-fiscal.nr-volume) = "" THEN "Sem Inform" ELSE STRING(tt-nota-fiscal.nr-volume)
       msg0094.ValorBaseSubstituicaoTributaria = 0
       msg0094.ValorSubstituicaoTributaria     = v-tot-vl-icmsub-it    
       msg0094.RetiraNoLocal                   = IF tt-nota-fiscal.nome-transp = "RETIRA" THEN YES ELSE NO
       msg0094.MetodoEntrega                   = iTipoEntrega 
       msg0094.Transportadora                  = IF AVAIL transporte THEN transporte.cod-transp ELSE 0
       msg0094.Frete                           = tt-nota-fiscal.cidade-cif 
       msg0094.CondicaoFreteEntrega            = 1                
       msg0094.InscricaoEstadual               = replace(replace(replace(tt-nota-fiscal.ins-estadual,'.',''),'-',''),'/','')  
       msg0094.Oportunidade                    = ?
       msg0094.PrecoBloqueado                  = NO
       msg0094.ValorDesconto                   = tt-nota-fiscal.vl-desconto
       msg0094.PercentualDesconto              = 0
       msg0094.ListaPreco                      = "Lista Padr∆o"
       msg0094.Prioridade                      = 1
       msg0094.Representante                   = tt-nota-fiscal.cod-rep
       msg0094.Proprietario                    = IF int-emitente.proprietario <> "" THEN int-emitente.proprietario ELSE ?
       msg0094.TipoProprietario                = IF int-emitente.tipo-proprietario <> "" THEN int-emitente.tipo-proprietario ELSE ?
       msg0094.ValorTotal                      = round(tt-nota-fiscal.vl-tot-nota,4)        
       msg0094.ValorTotalSemImposto            = round(tt-nota-fiscal.vl-mercad,4) 
       msg0094.ValorTotalSemFrete              = round((tt-nota-fiscal.vl-tot-nota - tt-nota-fiscal.vl-frete),4)
       msg0094.ValorTotalDesconto              = round(tt-nota-fiscal.vl-desconto,4)
       msg0094.ValorTotalProdutos              = round(tt-nota-fiscal.vl-tot-nota,4)
       msg0094.ValorTotalProdutosSemImposto    = round(tt-nota-fiscal.vl-mercad,4)    
       msg0094.TelefoneCobranca                = string(emitente.telefone[1],'X(15)')
       msg0094.FaxCobranca                     = string(emitente.telefax,'X(15)')
       msg0094.IdentificadorUnicoNFE           = IF tt-nota-fiscal.cod-chave-aces-nf-eletro <> '' THEN tt-nota-fiscal.cod-chave-aces-nf-eletro ELSE TRIM(SUBSTRING(tt-nota-fiscal.char-1,163,15)).

    /* 993520000 (Sa°da) 993520001 (Entrada) 993520002 (Serviáos) */
    IF AVAIL natur-oper THEN DO:
        CASE natur-oper.tipo:
            WHEN 1 THEN   /* entrada */
                ASSIGN msg0094.TipoNotaFiscal  = 993520001.
            WHEN 2 THEN   /* saida   */
                ASSIGN msg0094.TipoNotaFiscal  = 993520000.
            WHEN 3 THEN   /* servico */
                ASSIGN msg0094.TipoNotaFiscal  = 993520002.
        END CASE.
    END.

//ASSIGN msg0094.ConhecimentoTransporte = IF AVAIL int-nota-conhec THEN int-nota-conhec.nr-conhec ELSE "".

ASSIGN msg0094.TipoObjetoCliente = "account".

IF emitente.natureza = 1 THEN
   ASSIGN  msg0094.CPF               = tt-nota-fiscal.cgc
           msg0094.CNPJ              = ?.     
ELSE 
   ASSIGN  msg0094.CPF               = ?
           msg0094.CNPJ              = tt-nota-fiscal.cgc.     

/*Chamado 98681*/
IF emitente.natureza >= 3 /*estrangeiro ou trading*/ THEN
    ASSIGN msg0094.CNPJ              = ?
           msg0094.CPF               = ?
           msg0094.InscricaoEstadual = ?.

IF emitente.natureza = 1 THEN
    ASSIGN msg0094.InscricaoEstadual = ?.

CREATE EnderecoEntrega.
ASSIGN EnderecoEntrega.NomeEndereco = emitente.nome-emit
       EnderecoEntrega.TipoEndereco = 1
       EnderecoEntrega.CaixaPostal  = ""
       EnderecoEntrega.CEP          = string(int(tt-nota-fiscal.cep),"99999999")   
       EnderecoEntrega.Logradouro   = IF AVAIL int-loc-entr AND int-loc-entr.logradouro  <> "" THEN TRIM(SUBSTRING(int-loc-entr.logradouro,1,35))  ELSE string(c-rua,"X(35)")    
       EnderecoEntrega.Numero       = IF AVAIL int-loc-entr AND int-loc-entr.numero      <> "" THEN int-loc-entr.numero      ELSE string(c-nro,"X(5)")     
       EnderecoEntrega.Complemento  = IF AVAIL int-loc-entr AND int-loc-entr.complemento <> "" THEN TRIM(SUBSTRING(int-loc-entr.complemento,1,40)) ELSE c-comp                   
       EnderecoEntrega.Bairro       = tt-nota-fiscal.bairro
       EnderecoEntrega.NomeCidade   = tt-nota-fiscal.cidade 
       EnderecoEntrega.Cidade       = tt-nota-fiscal.cidade + "," + tt-nota-fiscal.estado + "," + tt-nota-fiscal.pais  
       EnderecoEntrega.UF           = tt-nota-fiscal.estado
       EnderecoEntrega.Estado       = tt-nota-fiscal.pais + "," + tt-nota-fiscal.estado
       EnderecoEntrega.NomePais     = tt-nota-fiscal.pais  
       EnderecoEntrega.Pais         = tt-nota-fiscal.pais  
       EnderecoEntrega.NomeContato  = SUBSTRING(emitente.nome-emit,1,40)
       EnderecoEntrega.Telefone     = string(emitente.telefone[1],'X(15)')
       EnderecoEntrega.Fax          = string(emitente.telefax,'X(15)'). 

CREATE EnderecoEntregaIt.
BUFFER-COPY EnderecoEntrega TO EnderecoEntregaIt.

CREATE msg0094-itens.

FOR EACH it-nota-fisc OF tt-nota-fiscal NO-LOCK:
    FIND FIRST ITEM NO-LOCK 
        WHERE ITEM.it-codigo = it-nota-fisc.it-codigo NO-ERROR.

    FIND FIRST unid-negoc NO-LOCK
         WHERE unid-negoc.cod-unid-negoc = it-nota-fisc.cod-unid-negoc NO-ERROR.

    RUN pi-narrativa-item (INPUT tt-nota-fiscal.cod-estabel,
                           INPUT ITEM.it-codigo,
                           OUTPUT c-narrativa-do-item).

    ASSIGN c-item-substituto = "".
    FIND FIRST b-ped-venda NO-LOCK
         WHERE b-ped-venda.nome-abrev = tt-nota-fiscal.nome-ab-cli
           AND b-ped-venda.nr-pedcli  = it-nota-fisc.nr-pedcli NO-ERROR.
    IF AVAIL b-ped-venda THEN
       FIND FIRST ped-item OF b-ped-venda NO-LOCK
            WHERE ped-item.it-codigo    = it-nota-fisc.it-codigo 
              AND ped-item.nr-sequencia = it-nota-fisc.nr-seq-ped NO-ERROR.
       IF AVAIL ped-item AND INDEX(ped-item.observacao,"Espdp054 - Substituicao do Item: ") <> 0 THEN DO:
           ASSIGN c-item-substituto = ENTRY(1, TRIM(SUBSTRING(ped-item.observacao,INDEX(ped-item.observacao,"Espdp054 - Substituicao do Item: ") + 33,LENGTH(ped-item.observacao))), ",":U). 
       END.

    /*IF OPSYS = "UNIX" THEN */
       LOG-MANAGER:WRITE-MESSAGE("Nota enviada -> " + it-nota-fisc.nr-nota-fis + " - Item: " + it-nota-fisc.it-codigo + " item substituto: " + c-item-substituto). 


    CREATE msg0094-item.
    ASSIGN msg0094-item.ChaveIntegracao              = string(msg0094.Estabelecimento) + "," + string(msg0094.NumeroSerie) + "," + string(msg0094.NumeroNotaFiscal) + "," + 
                                                       trim(string(it-nota-fisc.nr-seq-fat)) + "," + trim(string(it-nota-fisc.it-codigo))
           msg0094-item.CodigoProduto                = it-nota-fisc.it-codigo      
           msg0094-item.NomeProduto                  = Item.desc-item 
           msg0094-item.Descricao                    = fnConverteChar(Item.desc-item)
           msg0094-item.PrecoOriginal                = round(it-nota-fisc.vl-preori,4)      
           msg0094-item.PrecoUnitario                = round(it-nota-fisc.vl-preuni,4)      
           msg0094-item.PrecoLiquido                 = round(it-nota-fisc.vl-preuni,4)      
           msg0094-item.ValorMercadoriaTabela        = round(it-nota-fisc.vl-merc-tab,4)    
           msg0094-item.ValorMercadoriaOriginal      = round(it-nota-fisc.vl-merc-ori,4)    
           msg0094-item.ValorMercadoriaLiquido       = round(it-nota-fisc.vl-merc-liq,4)    
           msg0094-item.CodigoNaturezaOperacao       = it-nota-fisc.nat-operacao   
           msg0094-item.NomeNaturezaOperacao         = IF AVAIL natur-oper THEN natur-oper.denominacao ELSE ""
           msg0094-item.ProdutoForaCatalogo          = IF c-item-substituto = "" THEN NO ELSE YES
           msg0094-item.DescricaoProdutoForaCatalogo = c-item-substituto 
           msg0094-item.PermiteSubstituirPreco       = YES
           msg0094-item.UnidadeMedida                = fn-free-accent(it-nota-fisc.un-fatur[1])
           msg0094-item.ValorBaseICMS                = round(it-nota-fisc.vl-bicms-it,4)  
           msg0094-item.ValorBaseICMSSubstituicao    = round(It-nota-fisc.vl-bicms-it,4)  
           msg0094-item.ValorICMS                    = round(it-nota-fisc.vl-icms-it,4)   
           msg0094-item.ValorICMSSubstituicao        = round(it-nota-fisc.vl-icmsub-it,4) 
           msg0094-item.ValorICMSNaoTributado        = round(it-nota-fisc.vl-icmsnt-it,4) 
           msg0094-item.ValorICMSOutras              = round(it-nota-fisc.vl-icmsou-it,4) 
           msg0094-item.CodigoTributarioICMS         = it-nota-fisc.cd-trib-icm  
           msg0094-item.CodigoTributarioISS          = it-nota-fisc.cd-trib-iss  
           msg0094-item.CodigoTributarioIPI          = it-nota-fisc.cd-trib-ipi.
    ASSIGN
           msg0094-item.ValorBaseISS                 = round(it-nota-fisc.vl-biss-it,4)   
           msg0094-item.ValorBaseIPI                 = round(it-nota-fisc.vl-bipi-it,4)   
           msg0094-item.AliquotaISS                  = round(it-nota-fisc.aliquota-ISS,4) 
           msg0094-item.AliquotaIPI                  = round(it-nota-fisc.aliquota-ipi,4) 
           msg0094-item.AliquotaICMS                 = round(it-nota-fisc.aliquota-icm,4) 
           msg0094-item.ValorISS                     = round(it-nota-fisc.vl-iss-it,4)    
           msg0094-item.ValorISSNaoTributado         = round(it-nota-fisc.vl-issnt-it,4)  
           msg0094-item.ValorISSOutras               = round(it-nota-fisc.vl-issou-it,4)  
           msg0094-item.ValorIPI                     = round(it-nota-fisc.vl-ipi-it,4)    
           msg0094-item.ValorIPINaoTributado         = round(it-nota-fisc.vl-ipint-it,4)  
           msg0094-item.ValorIPIOutras               = round(it-nota-fisc.vl-ipiou-it,4).
    ASSIGN
           msg0094-item.PrecoConsumidor              = 0
           msg0094-item.QuantidadeCancelada          = IF tt-nota-fiscal.dt-cancel <> ? THEN it-nota-fisc.qt-faturada[1] ELSE 0
           msg0094-item.QuantidadePendente           = 0 
           msg0094-item.DataEntrega                  = ?
           msg0094-item.CondicaoFrete                = IF substring(tt-nota-fiscal.char-2,201,8) = "1" THEN 1 ELSE 2
           msg0094-item.ValorOriginal                = it-nota-fisc.vl-merc-ori
           msg0094-item.ValorTotalImposto            = round(it-nota-fisc.vl-icmsub-it + it-nota-fisc.vl-ipi-it,4)
           msg0094-item.ValorDescontoManual          = 0 
           msg0094-item.Quantidade                   = it-nota-fisc.qt-faturada[1]
           msg0094-item.RetiraNoLocal                = NO
           msg0094-item.QuantidadeEntregue           = 0
           msg0094-item.NumeroSequencia              = it-nota-fisc.nr-seq-fat 
           msg0094-item.CodigoUnidadeNegocio         = it-nota-fisc.cod-unid-neg
           msg0094-item.NomeUnidadeNegocio           = unid-negoc.des-unid-negoc
           msg0094-item.CodigoRepresentante          = tt-nota-fiscal.cod-rep
           msg0094-item.ValorTotal                   = round(it-nota-fisc.vl-tot-item,4)
           msg0094-item.Moeda                        = "Real"
           msg0094-item.Acao                         = "A"
           msg0094-item.NumeroPedido                 = it-nota-fisc.nr-pedido.  
    
    FIND FIRST int-ped-item-rebate
       WHERE int-ped-item-rebate.nome-abrev   = it-nota-fisc.nome-ab-cli  
         AND int-ped-item-rebate.nr-pedcli    = it-nota-fisc.nr-pedcli   
         AND int-ped-item-rebate.nr-sequencia = it-nota-fisc.nr-seq-ped
         AND int-ped-item-rebate.it-codigo    = it-nota-fisc.it-codigo   
         AND int-ped-item-rebate.cod-refer    = it-nota-fisc.cod-refer   NO-LOCK NO-ERROR.
    IF AVAIL int-ped-item-rebate THEN DO:
       ASSIGN msg0094-item.CalcularRebate = int-ped-item-rebate.log-calcrebate
              msg0094-item.PercentualDescontoVerde     = int-ped-item-rebate.perc-descto-verde      
              msg0094-item.PercentualDescontoTopMilhao = int-ped-item-rebate.perc-descto-top-milhao  
              msg0094-item.PercentualRebateAntecipado  = int-ped-item-rebate.perc-rebate-antec.
    END.

    ASSIGN v-vl-finsocial   = v-vl-finsocial   + it-nota-fisc.vl-finsocial  
           v-vl-pis         = v-vl-pis         + it-nota-fisc.vl-pis      
           v-tot-vl-ipi-it  = v-tot-vl-ipi-it  + it-nota-fisc.vl-ipi-it 
           v-tot-vl-icms-it = v-tot-vl-icms-it + it-nota-fisc.vl-icms-it
           v-tot-icmssub-it = v-tot-icmssub-it + it-nota-fisc.vl-icmsub-it.
    

END.

ASSIGN msg0094.ValorTotalImpostos = round(v-tot-icmssub-it + v-tot-vl-ipi-it,4)
       msg0094.ValorBaseICMS      = round(v-tot-vl-bicms-it,4)    
       msg0094.ValorICMS          = round(v-tot-vl-icms-it,4)  
       msg0094.ValorIPI           = round(v-tot-vl-ipi-it,4).

/* INDICAR QUE ê UMA NOTA DE DEVOLUÄ«O */
IF  tt-nota-fiscal.esp-docto = 20 THEN DO:
    ASSIGN msg0094.NotaDevolucao =  YES.
    /* ENVIAR O PEDIDO REFERENTE ∑ NOTA DE ORIGEM */
    FOR FIRST devol-cli NO-LOCK 
        WHERE devol-cli.cod-estabel = tt-nota-fiscal.cod-estabel
          AND devol-cli.serie-docto = tt-nota-fiscal.serie
          AND devol-cli.nro-docto   = tt-nota-fiscal.nr-nota-fis:
        FOR FIRST b-nota-orig no-lock
            WHERE b-nota-orig.cod-estabel = devol-cli.cod-estabel
              AND b-nota-orig.serie       = devol-cli.serie
              AND b-nota-orig.nr-nota-fis = devol-cli.nr-nota-fis:
        
            FOR FIRST ped-venda NO-LOCK
                WHERE ped-venda.nome-abrev = b-nota-orig.nome-ab-cli
                  AND ped-venda.nr-pedcli  = b-nota-orig.nr-pedcli:
                    ASSIGN msg0094.NumeroPedidoCliente = ped-venda.nr-pedcli
                           msg0094.NumeroPedido        = ped-venda.nr-pedido.
            END.
        END.
    END.
END.

IF msg0094.CNPJ              = "" THEN ASSIGN msg0094.CNPJ = ?.
IF msg0094.CPF               = "" THEN ASSIGN msg0094.CPF  = ?.
IF msg0094.InscricaoEstadual = "" THEN ASSIGN msg0094.InscricaoEstadual = ?.

/* Grava o xml com o registro, conecta com o Barramento e devolve a resposta. */
{esp/esb/esesb003a.i}



RETURN.

PROCEDURE pi-narrativa-item:
    DEF INPUT PARAMETER  c-cod-estabel LIKE estabelec.cod-estabel.
    DEF INPUT PARAMETER  c-item        LIKE ITEM.it-codigo.
    DEF OUTPUT PARAMETER c-desc-prod  AS CHARACTER.

    DEFINE VARIABLE c-narrativa AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iCont       AS INTEGER     NO-UNDO.

    /*---------------------------------------------------------------------------------+
     | Valores poss≠veis para o campos item.ind-imp-desc - Forma de Descriªío do Item: |
     |  1 - Descriªío                                                                  |
     |  2 - Descriªío + Narrativa do Item                                              |
     |  3 - Descriªío + Narrativa do Item X Cliente                                    |
     |  4 - Descriªío + Narrativa Informada                                            |
     |  5 - Narrativa do Item                                                          |
     |  6 - Uma Linha da Narrativa do Item                                             |
     |  7 - Narrativa Informada                                                        |
     |  8 - Descriªío + 24 Caracteres da Narrativa do Item X Cliente                   |
     |  9 - Descriªío + 24 Caracteres da Narrativa Informada                           | 
     | 10 - Descriªío + 24 Caracteres da Narrativa do Item                             |
     +---------------------------------------------------------------------------------*/


    /*------  PESQUISA A DESCRICAO DO PRODUTO  ------ */
              
    IF ITEM.ind-imp-desc = 1 THEN /* Descriªío */
        ASSIGN c-desc-prod = ITEM.desc-item.
    
    IF ITEM.ind-imp-desc = 2           /* Descriªío + Narrativa */
    OR ITEM.ind-imp-desc = 5           /* Narrativa Item */
    OR ITEM.ind-imp-desc = 6           /* Uma Linha Narrativa */
    OR ITEM.ind-imp-desc = 10 THEN DO: /* Descriªío + 24 Narrativa Item */
    
        IF ITEM.ind-imp-desc = 2
        OR ITEM.ind-imp-desc = 10 THEN
            ASSIGN c-desc-prod = ITEM.desc-item + " ".
        ELSE 
            ASSIGN c-desc-prod = "".
    
        FIND narrativa OF ITEM NO-LOCK NO-ERROR.
    
        IF AVAIL narrativa THEN DO:
            IF INDEX(narrativa.descricao,"#MANAUS#") <> 0 THEN DO:
                RUN esp/es0204.p (INPUT c-cod-estabel,
                                  INPUT c-item,
                                  OUTPUT c-narrativa).
            END.
            ELSE
                ASSIGN c-narrativa = narrativa.descricao.

            ASSIGN c-desc-prod = c-desc-prod +
                                 IF ITEM.ind-imp-desc = 6 THEN
                                     TRIM(ENTRY(1,SUBSTRING(c-narrativa,1,76),CHR(10)))
                                 ELSE IF ITEM.ind-imp-desc = 10 THEN
                                     TRIM(ENTRY(1,SUBSTRING(c-narrativa,1,24),CHR(10)))
                                 ELSE                        
                                     c-narrativa.

        END.
    END.
    
    IF ITEM.ind-imp-desc = 3          /* Descriªío + Narrativa Item/Cliente */
    OR ITEM.ind-imp-desc = 8 THEN DO: /* Descriªío + 24 Narrativa Item/Cliente */

        FIND item-cli NO-LOCK 
            WHERE item-cli.nome-abrev = tt-nota-fiscal.nome-ab-cli
              AND item-cli.it-codigo  = ITEM.it-codigo NO-ERROR.
        
        ASSIGN c-desc-prod = ITEM.desc-item + " ".
    
        IF AVAIL item-cli THEN DO:
            ASSIGN c-desc-prod = c-desc-prod +
                                 IF ITEM.ind-imp-desc = 3 THEN          
                                    item-cli.narrativa
                                 ELSE
                                    TRIM(ENTRY(1,SUBSTRING(item-cli.narrativa,1,24),CHR(10))).
        END.
    END.
    
    IF ITEM.ind-imp-desc = 4            /* Descriªío + Narrativa Informada */
    OR ITEM.ind-imp-desc = 7            /* Narrativa Informada */
    OR ITEM.ind-imp-desc = 9 THEN DO:   /* Descriªío + 24 Narrativa Informada */
    
        IF ITEM.ind-imp-desc = 4
        OR ITEM.ind-imp-desc = 9 THEN
            ASSIGN c-desc-prod = ITEM.desc-item + " ".
        ELSE 
            ASSIGN c-desc-prod = "".
    
        FIND nar-it-nota NO-LOCK 
            WHERE nar-it-nota.cod-estabel  = c-cod-estabel                                     
              AND   nar-it-nota.serie        = tt-nota-fiscal.serie                                                 
              AND   nar-it-nota.nr-nota-fis  = STRING(INT(tt-nota-fiscal.nr-nota-fis),"9999999")                            
              AND   nar-it-nota.nr-sequencia = iCont * 10
              AND   nar-it-nota.it-codigo    = ITEM.it-codigo NO-ERROR.
    
        IF AVAIL nar-it-nota THEN 
           ASSIGN c-desc-prod = c-desc-prod +
                                IF ITEM.ind-imp-desc = 9 THEN
                                   TRIM(ENTRY(1,SUBSTRING(nar-it-nota.narrativa,1,24),CHR(10)))
                                ELSE
                                   nar-it-nota.narrativa.
    END.
END PROCEDURE.
