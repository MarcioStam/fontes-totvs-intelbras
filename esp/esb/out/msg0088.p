/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0088 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0088
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/
create widget-pool.

DEFINE TEMP-TABLE tt-item LIKE item.
{utp/ut-glob.i}
{esp/esb/out/msg0088.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

create tt-item.
raw-transfer raw-param to tt-item.

FIND FIRST ITEM OF tt-item NO-LOCK NO-ERROR.

/*Definiá∆o da mensagem de envio de atualizaá∆o*/
define dataset mensagem xml-node-name 'MENSAGEM' for cabecalho, conteudo, msg0088, ProdutosFilhos, ProdutoFilho
    data-relation for conteudo, msg0088             relation-fields (idm, idm) nested
    data-relation for msg0088, ProdutosFilhos       relation-fields (idm, idm) nested
    data-relation for ProdutosFilhos, ProdutoFilho  relation-fields (idm, idm) nested.

/*Definiá∆o e leitura da mensagem de resposta da atualizaá∆o.*/
define dataset mensagemr xml-node-name 'MENSAGEM' for cabecalhor, conteudor, msg0088r, resultado
   data-relation for conteudor, msg0088r relation-fields (idm, idm) nested
   data-relation for msg0088r, resultado relation-fields (idm, idm) nested.

create cabecalho.
assign cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem    = 'MSG0088'
       cabecalho.LoginUsuario      = c-seg-usuario.
     
create conteudo.
create msg0088.

for each tt-item no-lock:

    /*N∆o integra itens com familia em branco, itens de consumo e que a familia inicie com letras*/
    IF tt-item.fm-cod-com = "" 
 /*   OR tt-item.fm-cod-com BEGINS "99"  CONFORME DEFINIDO ATRAVES DO CHAMADO 58053 */  
    OR tt-item.fm-codigo > "A"
    OR tt-item.cod-unid-neg = "" THEN
        RETURN.

    FIND FIRST int-item NO-LOCK
         WHERE int-item.it-codigo = tt-item.it-codigo NO-ERROR.
    
    FIND FIRST unid_negoc NO-LOCK
         WHERE unid_negoc.cod_unid_negoc = ITEM.cod-unid-negoc NO-ERROR.
    
    FIND FIRST fam-com-item NO-LOCK
         WHERE fam-com-item.fm-cod-com = SUBSTRING(item.fm-cod-com, 1, 4) NO-ERROR.

    /*No caso de enviar um novo campo da tabela item no XML Ç necess†rio tratar ele na trigger de item*/
    ASSIGN msg0088.CodigoProduto        = tt-item.it-codigo
           msg0088.Nome                 = tt-item.desc-item
           cabecalho.NumeroOperacao     = trim(SUBSTRING(tt-item.desc-item,1,38))
           msg0088.Descricao            = tt-item.descricao-1 + tt-item.descricao-2
           msg0088.DescricaoInternacional = tt-item.desc-inter
           msg0088.PesoEstoque          = tt-item.peso-bruto
           msg0088.Situacao             = IF AVAIL ITEM THEN 0 ELSE 1
           msg0088.TipoProduto          = IF tt-item.cod-servico = 0 THEN 11 ELSE 3
           msg0088.GrupoEstoque         = tt-item.ge-codigo
           msg0088.UnidadeNegocio       = tt-item.cod-unid-negoc
           msg0088.NomeUnidadeNegocio   = IF AVAIL unid_negoc THEN unid_negoc.des_unid_negoc ELSE ""
           msg0088.Segmento             = substring(tt-item.fm-cod-com,1,4)
           msg0088.NomeSegmento         = IF AVAIL fam-com-item THEN fam-com-item.descricao ELSE ""
           msg0088.Familia              = substring(tt-item.fm-cod-com,1,5)
           msg0088.SubFamilia           = substring(tt-item.fm-cod-com,1,7)
           msg0088.Origem               = integer(substring(tt-item.fm-cod-com,1,8))
           msg0088.UnidadeMedida        = IF tt-item.un = "" THEN "PC" ELSE tt-item.un
           msg0088.GrupoUnidadeMedida   = "Unidade Padr∆o"
           msg0088.FamiliaMaterial      = IF tt-item.fm-codigo = "" THEN "0" ELSE tt-item.fm-codigo
           msg0088.FamiliaComercial     = substring(tt-item.fm-cod-com,1,9)
           msg0088.ListaPreco           = "Lista Padr∆o"
           msg0088.Moeda                = "Real" 
           msg0088.QuantidadeDecimal    = 0  
           msg0088.PrecoLista           = 0   
           msg0088.Fabricante           = ""   
           msg0088.NumeroPecaFabricante = ""   
           msg0088.VolumeEstoque        = 0   
           msg0088.ComplementoProduto   = ""   
           msg0088.URL                  = ""   
           msg0088.QuantidadeDisponivel = 0   
           msg0088.ExigeTreinamento     = no   
           msg0088.Fornecedor           = ""   
           msg0088.CustoPadrao          = 0    
           msg0088.RebateAtivado        = no
           msg0088.ShowRoom             = NO
           msg0088.AliquotaIPI          = tt-item.aliquota-ipi
           msg0088.ncm                  = tt-item.class-fiscal
           msg0088.PassivelSolicitacaoBeneficio = NO   
           msg0088.TemMensagem                  = NO 
           msg0088.DescricaoMensagem            = ''
           msg0088.DepositoPadrao       = tt-item.deposito-pad   
           msg0088.CodigoTipoDespesa    = tt-item.tp-desp-padrao 
           msg0088.DestaqueNCM          = IF AVAIL int-item THEN int-item.destaque ELSE ?
           msg0088.NVE                  = IF AVAIL int-item THEN int-item.nve      ELSE ?
           msg0088.CodigoUnidadeFamilia = SUBSTRING(tt-item.fm-cod-com,1,2).       
    
    FIND item-mat
        WHERE item-mat.it-codigo = tt-item.it-codigo NO-LOCK NO-ERROR.
    IF AVAIL item-mat THEN ASSIGN msg0088.EAN = item-mat.cod-ean.   

    find first estrutura no-lock
        where estrutura.it-codigo = string(tt-item.it-codigo) NO-ERROR.
    if available estrutura then
        assign msg0088.NaturezaProduto  = 993520001. 
    else 
        assign msg0088.NaturezaProduto  = 993520000.

    find first item-estab no-lock 
        where item-estab.it-codigo = tt-item.it-codigo no-error.
    if available item-estab then 
        assign msg0088.CustoAtual  = item-estab.val-unit-mat-m[1] + item-estab.val-unit-ggf-m[1] + item-estab.val-unit-mob-m[1]. 

    IF CAN-FIND(FIRST prod-composto NO-LOCK
        WHERE prod-composto.it-codigo-pai    = tt-item.it-codigo
          AND prod-composto.it-codigo-filho <> '' ) THEN DO:

        ASSIGN msg0088.ekit = YES.
        CREATE ProdutosFilhos.

        FOR EACH  prod-composto NO-LOCK
            WHERE prod-composto.it-codigo-pai = tt-item.it-codigo:

            FIND FIRST ProdutoFilho NO-LOCK 
                WHERE ProdutoFilho.CodigoProduto = prod-composto.it-codigo-filho NO-ERROR.
            IF NOT AVAIL ProdutoFilho THEN DO:
                CREATE ProdutoFilho.
                ASSIGN ProdutoFilho.CodigoProduto          = prod-composto.it-codigo-filho
                       ProdutoFilho.QuantidadeProdutoFilho = prod-composto.qt-filho.
            END. /* IF NOT AVAIL ProdutoFilho THEN DO: */

        END. /* FOR EACH  prod-composto NO-LOCK */
    END.

    ASSIGN msg0088.TipoItem = "993520001".  /* Conforme chamado 133088 - emergencial para o comercial */

    /*Componente*/
    IF tt-item.ge-codigo = 10
    OR tt-item.ge-codigo = 12
    OR tt-item.ge-codigo = 15 THEN DO:
        ASSIGN msg0088.TipoItem = "993520001".
    END.
    /*Produtos*/
    ELSE IF tt-item.ge-codigo = 40
    OR tt-item.ge-codigo = 42
    OR tt-item.ge-codigo = 45 THEN DO:
        ASSIGN msg0088.TipoItem = "993520000".
    END.
    ELSE IF tt-item.ge-codigo = 20
    OR tt-item.ge-codigo = 25 THEN DO:
        /*Placas*/
        IF tt-item.desc-item BEGINS "PCI" 
        OR tt-item.desc-item BEGINS "PLACA" THEN
            ASSIGN msg0088.TipoItem = "993520004".
        /*Peáas*/
        ELSE
            ASSIGN msg0088.TipoItem = "993520002".
    END.

END. /*Fim for each*/

/* Grava o xml com o registro, conecta com o Barramento e devolve a resposta. */
{esp/esb/esesb003a.i}

RETURN.
