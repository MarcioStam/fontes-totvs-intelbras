CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

DEFINE VARIABLE h-cdapi704         AS HANDLE      NO-UNDO.
DEFINE VARIABLE p-prox-emitente    AS INTEGER     NO-UNDO.
DEFINE VARIABLE v-vl-pis           AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-tot-vl-bicms-it  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-tot-vl-icms-it   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-tot-vl-ipi-it    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-vl-finsocial     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-tot-icmsub-it    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v-tot-vl-icmsub-it AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-endereco         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-rua              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nro              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-comp             AS CHARACTER   NO-UNDO.

DEFINE BUFFER b-emitente FOR emitente.

{esp/esb/in/msg0096.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0096
   DATA-RELATION FOR conteudo, msg0096 RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('longchar', iXML, 'empty', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0096r, EnderecoEntrega, msg0096R-itens, msg0096R-item, EnderecoEntregaIt, resultado,  msg0096R-nota 
   DATA-RELATION FOR conteudor, msg0096r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0096r, msg0096R-nota RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0096R-nota, EnderecoEntrega RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0096R-nota, msg0096R-itens RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0096R-itens, msg0096R-item RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0096R-item, EnderecoEntregaIt RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0096r, resultado RELATION-FIELDS (idm, idm) NESTED.

FIND msg0096 NO-ERROR.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

CREATE conteudor.
CREATE resultado.
CREATE msg0096r.

/*BUFFER-COPY cabecalho TO cabecalhor.*/
ASSIGN cabecalhor.CodigoMensagem    = 'MSG0096R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF"
       cabecalhor.NumeroOperacao    = entry(1,msg0096.NumeroNotaFiscal,"/").

DEF BUFFER b-nota-orig FOR nota-fiscal.

FOR FIRST nota-fiscal NO-LOCK
    WHERE nota-fiscal.cod-estabel = entry(3,msg0096.NumeroNotaFiscal,"/")
      AND nota-fiscal.serie       = entry(2,msg0096.NumeroNotaFiscal,"/")
      AND nota-fiscal.nr-nota-fis = entry(1,msg0096.NumeroNotaFiscal,"/"):

    IF nota-fiscal.nr-nota-fis <> '' THEN
    ASSIGN cabecalhor.NumeroOperacao = nota-fiscal.nr-nota-fis.

    FOR FIRST ped-venda NO-LOCK
        WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
          AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli: 
    END.

    /* DEVOLUÄ«O */
    IF  NOT AVAIL ped-venda AND nota-fiscal.esp-docto = 20 THEN DO:
        FOR FIRST devol-cli NO-LOCK
            WHERE devol-cli.cod-estabel = nota-fiscal.cod-estabel  
              AND devol-cli.serie-docto = nota-fiscal.serie       
              AND devol-cli.nro-docto   = nota-fiscal.nr-nota-fis :
            FOR FIRST b-nota-orig NO-LOCK
                WHERE b-nota-orig.cod-estabel = devol-cli.cod-estabel
                  AND b-nota-orig.serie       = devol-cli.serie
                  AND b-nota-orig.nr-nota-fis = devol-cli.nr-nota-fis :
                    FOR FIRST ped-venda NO-LOCK
                        WHERE ped-venda.nome-abrev = b-nota-orig.nome-ab-cli
                          AND ped-venda.nr-pedcli  = b-nota-orig.nr-pedcli: 
                    END.
            END.
        END.
    END.

    FIND FIRST repres NO-LOCK
        WHERE repres.cod-rep = nota-fiscal.cod-rep NO-ERROR.

    FIND FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.

    FIND FIRST int-emitente NO-LOCK
        WHERE int-emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.

    FIND FIRST cond-pagto NO-LOCK
        WHERE cond-pagto.cod-cond-pag = nota-fiscal.cod-cond-pag NO-ERROR.

    FIND FIRST natur-oper NO-LOCK
        WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-ERROR.

    FIND FIRST transporte NO-LOCK
        WHERE transporte.nome-abrev = nota-fiscal.nome-transp NO-ERROR.

    FIND FIRST estabelec NO-LOCK
         WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel NO-ERROR.

    FIND loc-entr NO-LOCK 
        WHERE loc-entr.nome-abrev  = nota-fiscal.nome-ab-cli
          AND loc-entr.cod-entrega = nota-fiscal.cod-entrega NO-ERROR.                         
    
    FIND int-loc-entr NO-LOCK
        WHERE int-loc-entr.nome-abrev  = nota-fiscal.nome-ab-cli
          AND int-loc-entr.cod-entrega = nota-fiscal.cod-entrega NO-ERROR.

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

    LOG-MANAGER:WRITE-MESSAGE ("nota-fiscal.cod-estabel  : " + nota-fiscal.cod-estabel  ).
    CREATE msg0096R-nota.
    ASSIGN msg0096R-nota.NumeroNotaFiscal                = nota-fiscal.nr-nota-fis
           msg0096R-nota.Nome                            = STRING(nota-fiscal.nr-nota-fis) + "-" + STRING(msg0096R-nota.DataEmissao) + "-" + emitente.nome-emit
           msg0096R-nota.NumeroSerie                     = nota-fiscal.serie                  
           msg0096R-nota.CodigoClienteCRM                = int-emitente.cod-guid
           msg0096R-nota.TipoObjetoCliente               = "account"
           msg0096R-nota.NumeroPedido                    = ped-venda.nr-pedido WHEN AVAIL ped-venda               
           msg0096R-nota.NumeroPedido                    = ped-venda.nr-pedido  WHEN AVAIL ped-venda           
           msg0096R-nota.NumeroPedidoCliente             = nota-fiscal.nr-pedcli              
           msg0096R-nota.Descricao                       = ""                                
           msg0096R-nota.CodigoEstabelecimento           = nota-fiscal.cod-estabel            
           msg0096R-nota.NomeEstabelecimento             = estabelec.nome                     
           msg0096R-nota.CodigoCondicaoPagamento         = nota-fiscal.cod-cond-pag           
           msg0096R-nota.NomeCondicaoPagamento           = IF AVAIL cond-pagto THEN cond-pagto.descricao ELSE ""                                 
           msg0096R-nota.NomeAbreviadoCliente            = nota-fiscal.nome-ab-cli            
           msg0096R-nota.CodigoNaturezaOperacao          = nota-fiscal.nat-operacao           
           msg0096R-nota.NomeNaturezaOperacao            = IF AVAIL natur-oper THEN natur-oper.denominacao ELSE ""                                 
           msg0096R-nota.Moeda                           = nota-fiscal.mo-codigo              
           msg0096R-nota.SituacaoNota                    = IF nota-fiscal.dt-cancel <> ? THEN 3 ELSE 0 
           msg0096R-nota.SituacaoEntrega                 = 1
           msg0096R-nota.DataEmissao                     = nota-fiscal.dt-emis-nota           
           msg0096R-nota.DataSaida                       = nota-fiscal.dt-saida               
           msg0096R-nota.DataEntrega                     = ?                                 
           msg0096R-nota.DataConfirmacao                 = IF nota-fiscal.dt-confirma = ? THEN nota-fiscal.dt-emis-nota ELSE nota-fiscal.dt-confirma           
           msg0096R-nota.DataCancelamento                = nota-fiscal.dt-cancel              
           msg0096R-nota.DataConclusao                   = ?                                 
           msg0096R-nota.ValorFrete                      = round(nota-fiscal.vl-frete,4)               
           msg0096R-nota.PesoLiquido                     = round(nota-fiscal.peso-liq-tot,3)           
           msg0096R-nota.PesoBruto                       = round(nota-fiscal.peso-bru-tot,3)           
           msg0096R-nota.Observacao                      = nota-fiscal.observ-nota            
           msg0096R-nota.Volume                          = IF  STRING(nota-fiscal.nr-volume) = "" THEN "Sem Inform" ELSE STRING(nota-fiscal.nr-volume)
           msg0096R-nota.RetiraNoLocal                   = NO
           msg0096R-nota.MetodoEntrega                   = 17 /**/
           msg0096R-nota.CodigoTransportadora            = string(transporte.cod-transp)
           msg0096R-nota.NomeTransportadora              = IF AVAIL transporte THEN transporte.nome ELSE ""
           msg0096R-nota.Frete                           = nota-fiscal.cidade-cif             
           msg0096R-nota.CondicaoFreteEntrega            = 1                             
           msg0096R-nota.InscricaoEstadual               = replace(replace(replace(nota-fiscal.ins-estadual,'.',''),'-',''),'/','')   
           msg0096R-nota.CodigoOportunidade              = ?                              
           msg0096R-nota.NomeOportunidade                = ""                             
           msg0096R-nota.PrecoBloqueado                  = NO                            
           msg0096R-nota.ValorDesconto                   = round(nota-fiscal.vl-desconto,4)            
           msg0096R-nota.PercentualDesconto              = 0
           msg0096R-nota.ListaPreco                      = "Lista Padr∆o"
           msg0096R-nota.Prioridade                      = 0                             
           msg0096R-nota.CodigoRepresentante             = nota-fiscal.cod-rep         
           msg0096R-nota.NomeRepresentante               = repres.nome
/*            msg0096R-nota.CodigoProprietario              = "" /**/                        */
/*            msg0096R-nota.NomeProprietario                = "" /**/                        */
/*            msg0096R-nota.TipoProprietario                = int-emitente.tipo-proprietario */
           msg0096R-nota.ValorTotal                      = round(nota-fiscal.vl-tot-nota,4)   
           msg0096R-nota.ValorTotalSemImposto            = round(nota-fiscal.vl-mercad,4)     
           msg0096R-nota.ValorTotalSemFrete              = round(nota-fiscal.vl-tot-nota - nota-fiscal.vl-frete,4)
           msg0096R-nota.ValorTotalDesconto              = round(nota-fiscal.vl-desconto,4)  
           msg0096R-nota.ValorTotalProdutos              = round(nota-fiscal.vl-tot-nota,4)  
           msg0096R-nota.ValorTotalProdutosSemImposto    = round(nota-fiscal.vl-mercad,4)    
           msg0096R-nota.TelefoneCobranca                = STRING(emitente.telefone[1] + "|" + emitente.telefone[2],'X(15)')
           msg0096R-nota.FaxCobranca                     = STRING(emitente.telefax,'X(15)')
           msg0096R-nota.NotaDevolucao                   = IF nota-fiscal.esp-docto = 20 THEN YES ELSE NO.

    LOG-MANAGER:WRITE-MESSAGE ("msg0096R-nota.CodigoEstabelecimentol: " + msg0096R-nota.CodigoEstabelecimento  ).
    IF natur-oper.tipo = 1  THEN
       ASSIGN msg0096R-nota.TipoNotaFiscal = 993520001. /* (Entrada)*/
    ELSE
        IF natur-oper.tipo = 2  THEN
           ASSIGN msg0096R-nota.TipoNotaFiscal = 993520000. /* (Sa°da) */
        ELSE
            ASSIGN msg0096R-nota.TipoNotaFiscal = 993520002. /*  (Serviáos) */

    IF emitente.natureza = 1 THEN
        ASSIGN msg0096R-nota.CPF  = nota-fiscal.cgc
               msg0096R-nota.CNPJ = ?.     
    ELSE                          
        ASSIGN msg0096R-nota.CPF  = ?
               msg0096R-nota.CNPJ = nota-fiscal.cgc.     


    CREATE EnderecoEntrega.
    ASSIGN EnderecoEntrega.NomeEndereco = emitente.nome-emit
           EnderecoEntrega.TipoEndereco = 1
           EnderecoEntrega.CaixaPostal  = ""
           EnderecoEntrega.CEP          = nota-fiscal.cep   
           EnderecoEntrega.Logradouro   = IF AVAIL int-loc-entr AND int-loc-entr.logradouro  <> "" THEN int-loc-entr.logradouro  ELSE string(c-rua,"X(35)")    
           EnderecoEntrega.Numero       = IF AVAIL int-loc-entr AND int-loc-entr.numero      <> "" THEN int-loc-entr.numero      ELSE string(c-nro,"X(5)")                
           EnderecoEntrega.Complemento  = IF AVAIL int-loc-entr AND int-loc-entr.complemento <> "" THEN int-loc-entr.complemento ELSE c-comp                   
           EnderecoEntrega.Bairro       = nota-fiscal.bairro
           EnderecoEntrega.NomeCidade   = nota-fiscal.cidade
           EnderecoEntrega.Cidade       = nota-fiscal.cidade
           EnderecoEntrega.UF           = nota-fiscal.estado
           EnderecoEntrega.Estado       = nota-fiscal.estado
           EnderecoEntrega.NomePais     = nota-fiscal.pais  
           EnderecoEntrega.Pais         = nota-fiscal.pais  
           EnderecoEntrega.NomeContato  = SUBSTRING(emitente.nome-emit,1,40)               
           EnderecoEntrega.Telefone     = string(emitente.telefone[1] + "|" + emitente.telefone[2],'X(15)')
           EnderecoEntrega.Fax          = string(emitente.telefax,'X(15)'). 

    CREATE msg0096R-itens.

    CREATE EnderecoEntregaIt.
    BUFFER-COPY EnderecoEntrega TO EnderecoEntregaIt.

    FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:

        ASSIGN msg0096R-nota.ValorBaseSubstituicaoTributaria = round(msg0096R-nota.ValorBaseSubstituicaoTributaria + it-nota-fisc.vl-bsubs-it,4)
               msg0096R-nota.ValorSubstituicaoTributaria     = round(msg0096R-nota.ValorSubstituicaoTributaria     + it-nota-fisc.vl-icmsub-it,4).

        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = it-nota-fisc.it-codigo NO-ERROR.

        FIND FIRST natur-oper NO-LOCK
             WHERE natur-oper.nat-operacao = it-nota-fisc.nat-operacao NO-ERROR.

        FIND FIRST unid-negoc NO-LOCK
             WHERE unid-negoc.cod-unid-negoc = it-nota-fisc.cod-unid-negoc NO-ERROR.

        CREATE msg0096R-item.
        ASSIGN msg0096R-item.ChaveIntegracao              = nota-fiscal.cod-estabel + "," + nota-fiscal.serie + "," + nota-fiscal.nr-nota-fis + "," + 
                                                            string(it-nota-fisc.nr-seq-fat) + "," + it-nota-fisc.it-codigo 
               msg0096R-item.CodigoProduto                = it-nota-fisc.it-codigo   
               msg0096R-item.NomeProduto                  = ITEM.desc-item           
               msg0096R-item.Descricao                    = ""
               msg0096R-item.PrecoOriginal                = it-nota-fisc.vl-preori   
               msg0096R-item.PrecoUnitario                = it-nota-fisc.vl-preuni   
               msg0096R-item.PrecoLiquido                 = 0                   
               msg0096R-item.ValorMercadoriaTabela        = round(it-nota-fisc.vl-pretab,4)   
               msg0096R-item.ValorMercadoriaOriginal      = round(it-nota-fisc.vl-merc-ori,4) 
               msg0096R-item.ValorMercadoriaLiquido       = round(it-nota-fisc.vl-merc-liq,4) 
               msg0096R-item.CodigoNaturezaOperacao       = it-nota-fisc.nat-operacao
               msg0096R-item.NomeNaturezaOperacao         = natur-oper.denominacao
               msg0096R-item.ProdutoForaCatalogo          = NO
               msg0096R-item.DescricaoProdutoForaCatalogo = ""
               msg0096R-item.PermiteSubstituirPreco       = YES 
               msg0096R-item.UnidadeMedida                = it-nota-fisc.un-fatur[1]
               msg0096R-item.ValorBaseICMS                = round(it-nota-fisc.vl-bicms-it,4) 
               msg0096R-item.ValorBaseICMSSubstituicao    = round(It-nota-fisc.vl-bicms-it,4) 
               msg0096R-item.ValorICMS                    = round(it-nota-fisc.vl-icms-it,4)  
               msg0096R-item.ValorICMSSubstituicao        = round(it-nota-fisc.vl-icmsub-it,4)
               msg0096R-item.ValorICMSNaoTributado        = round(it-nota-fisc.vl-icmsnt-it,4)
               msg0096R-item.ValorICMSOutras              = round(it-nota-fisc.vl-icmsou-it,4)
               msg0096R-item.CodigoTributarioICMS         = it-nota-fisc.cd-trib-icm 
               msg0096R-item.CodigoTributarioISS          = it-nota-fisc.cd-trib-iss 
               msg0096R-item.CodigoTributarioIPI          = it-nota-fisc.cd-trib-ipi 
               msg0096R-item.ValorBaseISS                 = round(it-nota-fisc.vl-biss-it,4)  
               msg0096R-item.ValorBaseIPI                 = round(it-nota-fisc.vl-bipi-it,4)  
               msg0096R-item.AliquotaISS                  = it-nota-fisc.aliquota-ISS
               msg0096R-item.AliquotaIPI                  = it-nota-fisc.aliquota-ipi
               msg0096R-item.AliquotaICMS                 = it-nota-fisc.aliquota-icm
               msg0096R-item.ValorISS                     = round(it-nota-fisc.vl-iss-it,4)   
               msg0096R-item.ValorISSNaoTributado         = round(it-nota-fisc.vl-issnt-it,4) 
               msg0096R-item.ValorISSOutras               = round(it-nota-fisc.vl-issou-it,4) 
               msg0096R-item.ValorIPI                     = round(it-nota-fisc.vl-ipi-it,4)   
               msg0096R-item.ValorIPINaoTributado         = round(it-nota-fisc.vl-ipint-it,4) 
               msg0096R-item.ValorIPIOutras               = round(it-nota-fisc.vl-ipiou-it,4) 
               msg0096R-item.PrecoConsumidor              = 0
               msg0096R-item.QuantidadeCancelada          = IF nota-fiscal.dt-cancel <> ? THEN it-nota-fisc.qt-faturada[1] ELSE 0
               msg0096R-item.QuantidadePendente           = 0
               /*msg0096R-item.DataEntrega                  */
               msg0096R-item.CondicaoFrete                = IF substring(nota-fiscal.char-2,201,8) = "1" THEN 1 ELSE 2
               msg0096R-item.ValorOriginal                = round(it-nota-fisc.vl-merc-ori,4)  
               msg0096R-item.ValorTotalImposto            = round(it-nota-fisc.vl-icmsub-it + it-nota-fisc.vl-ipi-it,4) 
               msg0096R-item.ValorDescontoManual          = 0
               msg0096R-item.Quantidade                   = it-nota-fisc.qt-faturada[1]
               msg0096R-item.RetiraNoLocal                = NO 
               msg0096R-item.QuantidadeEntregue           = 0
               msg0096R-item.NumeroSequencia              = it-nota-fisc.nr-seq-fat  
               msg0096R-item.CodigoUnidadeNegocio         = it-nota-fisc.cod-unid-neg
               msg0096R-item.NomeUnidadeNegocio           = unid-negoc.des-unid-negoc
               msg0096R-item.CodigoRepresentante          = nota-fiscal.cod-rep      
               msg0096R-item.NomeRepresentante            = repres.nome                    
               msg0096R-item.ValorTotal                   = round(it-nota-fisc.vl-tot-item,4)  
               msg0096R-item.Moeda                        = nota-fiscal.mo-codigo    
               msg0096R-item.Acao                         = "A".             

        ASSIGN v-tot-vl-bicms-it = v-tot-vl-bicms-it + it-nota-fisc.vl-bicms-it
               v-vl-finsocial    = v-vl-finsocial    + it-nota-fisc.vl-finsocial  
               v-vl-pis          = v-vl-pis          + it-nota-fisc.vl-pis      
               v-tot-vl-ipi-it   = v-tot-vl-ipi-it   + it-nota-fisc.vl-ipi-it 
               v-tot-vl-icms-it  = v-tot-vl-icms-it  + it-nota-fisc.vl-icms-it
               v-tot-icmsub-it   = v-tot-icmsub-it   + it-nota-fisc.vl-icmsub-it.
    END.

    ASSIGN msg0096R-nota.ValorTotalImpostos              = round(v-tot-icmsub-it + v-tot-vl-ipi-it,4)
           msg0096R-nota.ValorBaseICMS                   = round(v-tot-vl-bicms-it,4)          
           msg0096R-nota.ValorICMS                       = round(v-tot-vl-icms-it,4)
           msg0096R-nota.ValorIPI                        = round(v-tot-vl-ipi-it,4).         
END.

DATASET mensagemr:WRITE-XML('LONGCHAR', oXML, NO).

OUTPUT CLOSE.

RETURN.
