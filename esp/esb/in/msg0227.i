{esp/esb/esesb000.i}

DEFINE TEMP-TABLE MSG0227 NO-UNDO XML-NODE-NAME 'MSG0227'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoItemInicial     LIKE ITEM.it-codigo INITIAL ""
   FIELD CodigoItemFinal       LIKE ITEM.it-codigo INITIAL "ZZZZZZZZZZZZZZZZ"
   FIELD CodigoFornecedorEMS   LIKE emitente.cod-emitente       INITIAL ?
   FIELD MatriculaComprador    LIKE item-uni-estab.cod-comprado INITIAL ?
   FIELD MatriculaUsuario      LIKE usuar-mater.cod-usuario
   FIELD NomeProduto           LIKE ITEM.desc-item              INITIAL ?
   FIELD I18N                  AS LOGICAL.

DEFINE TEMP-TABLE Estabelecimento NO-UNDO XML-NODE-NAME 'Estabelecimento'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoEstabelecimento LIKE estabelec.cod-estabel       INITIAL ?.

DEFINE TEMP-TABLE MSG0227R1 NO-UNDO XML-NODE-NAME 'MSG0227R1'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD ExibePrecos                      AS LOG.

DEFINE TEMP-TABLE ParamItem NO-UNDO XML-NODE-NAME 'ParametrosItem'
   FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
   FIELD CodigoEstabelecimento            LIKE item-uni-estab.cod-estabel
   FIELD NomeEstabelecimento              LIKE estabelec.nome
   FIELD CodigoProduto                    LIKE item-uni-estab.it-codigo
   FIELD NomeProduto                      LIKE ITEM.desc-item
   FIELD CodigoUnidadeMedida              LIKE ITEM.un
   FIELD CodigoUnidadeNegocio             LIKE item-uni-estab.cod-unid-negoc
   FIELD NomeUnidadeNegocio               LIKE unid-negoc.des-unid-negoc
   FIELD SituacaoItemEMS                  LIKE item-uni-estab.cod-obsoleto
   FIELD CotacaoAutomatica                LIKE item-fornec-estab.cot-aut
   FIELD MatriculaComprador               LIKE item-uni-estab.cod-comprado
   FIELD NomeComprador                    LIKE usuar-mater.nome-usuar 
   FIELD PrecoMedio                       LIKE item-estab.val-unit-mat-m[1] 
   FIELD PrecoUltimaEntrada               AS DEC 
   FIELD DataUltimaEntrada                AS DATE 
   FIELD NecessitaLicencaImportacao       AS LOG
   FIELD NecessitaInspecaoOrigem          LIKE int-item-fornec-estab.log-nec-inspec
   FIELD TributacaoIPI                    LIKE item.cd-trib-ipi
   FIELD AliquotaIPI                      LIKE item-tab.aliquota-ipi
   FIELD FamiliaIPI                       LIKE item-mat.cod-familia-impto
   FIELD SuspensaoIPI                     LIKE item-mat.log-suspens-impto-import
   FIELD IPIIncluso                       AS LOGICAL
   FIELD Antidumping                      LIKE int-item.log-antidumping
   FIELD ObservacaoLogistica              LIKE int-item-uni-estab.observacao
   FIELD NCM                              LIKE item.class-fiscal
   FIELD DestaqueNCM                      LIKE int-item.destaque
   FIELD NVE                              LIKE int-item.nve
   FIELD TributacaoII                     LIKE item.cod-trib-ii
   FIELD AliquotaII                       AS DECIMAL FORMAT ">>9.99"
   FIELD SuspensaoII                      LIKE item-mat.log-suspens-impto-import
   FIELD ExTarifario                      LIKE int-item.ex-tarifario
   FIELD ConsumoMedio                     AS DEC 
   FIELD Saldo                            LIKE saldo-estoq.qtidade-atu
   FIELD ClassificacaoABC                 LIKE item-uni-estab.classif-abc
   FIELD Obtencao                         LIKE ITEM.compr-fabric
   FIELD CodigoGrupoEstoque               LIKE ITEM.ge-codigo
   FIELD NomeGrupoEstoque                 LIKE grup-estoque.descricao
   FIELD MatriculaPlanejador              LIKE item-uni-estab.cd-planejado
   FIELD NomePlanejador                   LIKE usuar_mestre.nom_usuar
   FIELD Politica                         LIKE item-uni-estab.politica
   FIELD TipoDemanda                      LIKE item-uni-estab.demanda                      
   FIELD LoteMultiploProducao             LIKE item-uni-estab.lote-multipl
   FIELD LoteMinimoProducao               LIKE item-uni-estab.lote-minimo
   FIELD PeriodoFixo                      LIKE item-uni-estab.periodo-fixo
   FIELD QuantidadePoliticaEstoque        LIKE int-item-uni-estab.qtd-pol 
   FIELD QuantidadeEstoqueSeguranca       LIKE item-uni-estab.quant-segur
   FIELD TipoEstoqueSeguranca             LIKE item-uni-estab.tipo-est-seg
   FIELD TempoSeguranca                   LIKE item-uni-estab.tempo-segur
   FIELD ConverteTempoSeguranca           LIKE item-uni-estab.conv-tempo-seg
   FIELD Reabastecimento                  AS INT
   FIELD ClasseReprogramacao              LIKE item-uni-estab.classe-repro
   FIELD EmissaoOrdens                    LIKE item-uni-estab.emissao-ord
   FIELD DivisaoOrdens                    LIKE item-uni-estab.div-ordem
   FIELD PrioridadeMRP                    LIKE item-uni-estab.int-1
   FIELD RepressaDemanda                  AS LOG
   FIELD Prioridade                       LIKE item-uni-estab.prioridade
   FIELD TempoRessuprimentoCompras        LIKE item-uni-estab.res-int-comp
   FIELD TempoRessuprimentoCQ             LIKE item-uni-estab.res-int-comp
   FIELD HorizonteLiberacao               AS INT
   FIELD HorizonteFixoProducao            LIKE item-uni-estab.horiz-fixo      
   FIELD DepositoPadrao                   LIKE item-uni-estab.deposito-pad    
   FIELD CodigoTipoDespesa                LIKE item-uni-estab.tp-desp-padrao
   FIELD DescricaoTipoDespesa             LIKE tipo-rec-desp.descricao
   FIELD CodigoOrigemItem                 LIKE item.codigo-orig
   /*FIELD DescricaoOrigem                  AS CHAR  removido pelo Francisco*/
   FIELD CodigoFornecedorEMS              LIKE emitente.cod-emitente
   FIELD NomeAbreviadoFornecedor          LIKE emitente.nome-abrev
   FIELD PercentualCompraFornecedor       LIKE item-fornec-estab.perc-compra
   FIELD Pais                             LIKE emitente.pais
   FIELD CodigoCondicaoPagamento          LIKE cond-pagto.cod-cond-pag
   FIELD NomeCondicaoPagamento            LIKE cond-pagto.descricao
   FIELD TempoRessuprimentoFornecedor     LIKE item-uni-estab.res-for-comp
   FIELD HorizonteFixo                    LIKE item-fornec-estab.horiz-fixo
   FIELD LoteMultiploItemFornecedor       LIKE item-fornec-estab.lote-mul-for
   FIELD LoteMinimoItemFornecedor         LIKE item-fornec-estab.lote-minimo
   FIELD CodigoFabricante                 LIKE fabricante.cod-fabric
   FIELD NomeFabricante                   LIKE fabricante.nome-abrev
   FIELD PartNumberItemFabricante         LIKE item-fabric.it-fabric
   FIELD PrecoItem                        LIKE item-tab.pr-item
   FIELD CodigoMoedaEMS                   LIKE moeda.mo-codigo
   FIELD CodigoUnidadeMedidaFornecedor    LIKE ITEM.un
   FIELD CodigoItinerarioPadrao           LIKE emitente-cex.cod-itiner-imp
   FIELD DescricaoItinerarioPadrao        LIKE itinerario.descricao
   FIELD CodigoPontoControleBase          LIKE pto-contr.cod-pto-contr
   FIELD DescricaoPontoControleBase       LIKE pto-contr.descricao
   FIELD CodigoIncoterm                   LIKE inco-cx.cod-incoterm       
   FIELD DescricaoIncoterm                LIKE incoterm.descricao
   FIELD IdiomaPadrao                     LIKE emitente-cex.cod-idioma
   FIELD GATT                             LIKE int-item.log-gatt
   FIELD PercentualGATT                   LIKE int-item.perc-gatt  
   FIELD SeqSuframa                       LIKE int-item.seq-suframa
   FIELD PesoLiquido                      LIKE item.peso-liquido   
   FIELD PesoBruto                        LIKE item.peso-bruto     
   FIELD TributacaoICMS                   LIKE item.cd-trib-icm    
   FIELD FatorReajusteICMS                LIKE item.fator-reaj-icms
   FIELD AliquotaICMS                     LIKE item-tab.aliquota-icm
   FIELD TributacaoISS                    LIKE item.cd-trib-iss
   FIELD AliquotaISS                      LIKE item.aliquota-iss
   FIELD TributacaoPIS                    LIKE item-mat.idi-tributac-pis
   FIELD OrigemAliquotaPIS                AS INT /*int(substr(tt-item.char-2,52,1))*/
   FIELD AliquotaPIS                      LIKE item-mat.val-aliq-ext-pis
   FIELD PercentualReducaoPIS             LIKE item-mat.val-reduc-pis-normal
   FIELD TributacaoCOFINS                 LIKE item-mat.idi-tributac-cofins
   FIELD OrigemAliquotaCOFINS             AS INT /*int(substr(tt-item.char-2,53,1))*/
   FIELD AliquotaCOFINS                   LIKE item-mat.val-aliq-ext-cofins
   FIELD PercentualReducaoCOFINS          LIKE item-mat.val-reduc-cofins-normal
   FIELD FreteIncluso                     LIKE tb-pr-cc.frete 
   FIELD ValorFrete                       LIKE tb-pr-cc.valor-frete
   FIELD EncargosFinanceiros              LIKE tb-pr-cc.taxa-financ
   FIELD FatorConversao                   AS DEC.
   
DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE VARIABLE de-indice AS DECIMAL     NO-UNDO.
