{include/i-prgvrs.i WSO0016rp 2.00.00.000}
/***********************************************************************
**  Programa..: 
**  Autor.....: 
**              Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/
{include/i-rpvar.i}
//{method/dbotterr.i}
//{utp/ut-glob.i}
//{btb/btb008za.i0}
//{esp/es0018.i}
{esp/wso/in/wso0003.i}

DEF NEW GLOBAL SHARED VAR I-Pais-Impto-Usuario    AS   INTE   FORM ">>9" NO-UNDO.

define temp-table tt-raw-digita NO-UNDO
    field raw-digita    as raw.

/*---------------------------  Parƒmetros   ---------------------------*/
define input parameter raw-param as raw no-undo.
define input parameter table for tt-raw-digita.

define temp-table tt-param no-undo
        field destino           as integer
        field arquivo           as char format "x(35)"
        field usuario           as char format "x(12)"
        field data-exec         as date
        field hora-exec         as integer
        field r-int-pedido-vtex AS ROWID.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id ordem.

create tt-param.
raw-transfer raw-param to tt-param.

FOR each tt-raw-digita NO-LOCK:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
END.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

{include/i-rpout.i}
{include/i-rpcab.i}

ASSIGN c-sistema            = "Espec¡ficos Intelbras"
       c-titulo-relat       = "Parametros de Integra‡Æo VTEX"
       c-empresa            = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa           = "WSO0016RP"
       c-versao             = "2.00"
       c-revisao            = "000"
       i-pais-impto-usuario = 1.

/* ***************************  Main Block  *************************** */

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

FIND FIRST tt-param.

DEFINE VARIABLE iXML AS LONGCHAR   NO-UNDO.
DEFINE VARIABLE oXML AS LONGCHAR   NO-UNDO.

FIND FIRST int-pedido-vtex
     WHERE ROWID(int-pedido-vtex) = tt-param.r-int-pedido-vtex NO-LOCK NO-ERROR.
IF NOT AVAIL int-pedido-vtex THEN NEXT.

EMPTY TEMP-TABLE ttPedido.
EMPTY TEMP-TABLE ttCondicaoPagamento.
EMPTY TEMP-TABLE ttpessoaFisica.
EMPTY TEMP-TABLE ttTelefone.
EMPTY TEMP-TABLE ttEmail.
EMPTY TEMP-TABLE ttDocumento.
EMPTY TEMP-TABLE ttEndereco.
EMPTY TEMP-TABLE ttItem.

CREATE ttPedido.
ASSIGN ttPedido.numeroPedido      = int-pedido-vtex.nr-pedido
       ttPedido.sequenciaPedido   = int-pedido-vtex.seq-pedido  
       ttPedido.codigoLoja        = int-pedido-vtex.cod-loja  
       ttPedido.dataCriacao       = int-pedido-vtex.dt-criacao
       ttPedido.totalFrete        = int-pedido-vtex.vl-tot-frete  
       ttPedido.totalItens        = int-pedido-vtex.vl-tot-itens  
       ttPedido.totalPedido       = int-pedido-vtex.vl-tot-pedido
       ttPedido.totalDesconto     = int-pedido-vtex.vl-tot-desc
       ttPedido.marketplace       = int-pedido-vtex.marketplace. 

CREATE ttCondicaoPagamento.
ASSIGN ttCondicaoPagamento.formaPagamento      = int-pedido-vtex.forma-pagto    
       ttCondicaoPagamento.dataCaptura         = int-pedido-vtex.dt-pagto       
       ttCondicaoPagamento.quantidadeParcelas  = int-pedido-vtex.qtd-parcelas   
       ttCondicaoPagamento.finalCartao         = int(int-pedido-vtex.final-cartao)
       ttCondicaoPagamento.idAutorizacao       = int-pedido-vtex.id-autorizacao 
       ttCondicaoPagamento.nsu                 = int-pedido-vtex.nsu-cartao     
       ttCondicaoPagamento.valorTotal          = int-pedido-vtex.vl-tot-pagto
       ttCondicaoPagamento.numeroReferencia    = int-pedido-vtex.reference-number    
       ttCondicaoPagamento.tid                 = int-pedido-vtex.tid.

IF int-pedido-vtex.tipo-docto = "CNPJ" THEN DO:
    CREATE ttpessoaJuridica.
    ASSIGN ttpessoaJuridica.nomeFantasia = int-pedido-vtex.nome.

    CREATE ttDocumento.
    ASSIGN ttDocumento.tipoDocumento   = "inscricaoEstadual"  
           ttDocumento.numeroDocumento = int-pedido-vtex.ins-estadual.
END.
ELSE DO:
    CREATE ttpessoaFisica.
    ASSIGN ttpessoaFisica.nome = int-pedido-vtex.nome.
END.                                                     

CREATE ttDocumento.
ASSIGN ttDocumento.tipoDocumento   = int-pedido-vtex.tipo-docto  
       ttDocumento.numeroDocumento = int-pedido-vtex.num-docto.

CREATE ttTelefone.
ASSIGN ttTelefone.telefone = int-pedido-vtex.telefone     
       ttTelefone.tipo     = int-pedido-vtex.telefone-tipo.

CREATE ttEmail.
ASSIGN ttEmail.endereco = int-pedido-vtex.email     
       ttEmail.tipo     = int-pedido-vtex.email-tipo.

CREATE ttEndereco.
ASSIGN ttEndereco.logradouro  = int-pedido-vtex.endereco   
       ttEndereco.cep         = int-pedido-vtex.cep        
       ttEndereco.bairro      = int-pedido-vtex.bairro     
       ttEndereco.municipio   = int-pedido-vtex.cidade     
       ttEndereco.siglaEstado = int-pedido-vtex.estado     
       ttEndereco.complemento = int-pedido-vtex.complemento
       ttEndereco.numero      = int-pedido-vtex.numero     
       ttEndereco.siglaPais   = int-pedido-vtex.pais
       ttEndereco.tipo        = "principal". 

FOR EACH int-ped-item-vtex NO-LOCK
   WHERE int-ped-item-vtex.nr-pedido     = int-pedido-vtex.nr-pedido     
     AND int-ped-item-vtex.seq-pedido    = int-pedido-vtex.seq-pedido    
     AND int-ped-item-vtex.dt-integracao = int-pedido-vtex.dt-integracao 
     AND SUBSTRING(int-ped-item-vtex.hr-integracao,1,8) = int-pedido-vtex.hr-integracao:
    
    CREATE ttItem.
    ASSIGN ttItem.codigoItem           = int-ped-item-vtex.it-codigo          
           ttItem.precoItem            = int-ped-item-vtex.vl-preco-item      
           ttItem.estabelecimento      = int-ped-item-vtex.cod-estabel        
           ttItem.codigoTransportadora = string(int-ped-item-vtex.cod-transp)
           ttItem.quantidade           = int-ped-item-vtex.quantidade
           ttItem.valorDesconto        = int-ped-item-vtex.vl-desc-item.
END.   

FIND FIRST ttpessoaJuridica NO-ERROR.
IF AVAIL ttpessoaJuridica THEN DO:
    FOR EACH ttPedido:            CREATE ttPedidoPJ.            BUFFER-COPY ttPedido            TO ttPedidoPJ.            END.
    FOR EACH ttItem:              CREATE ttItemPJ.              BUFFER-COPY ttItem              TO ttItemPJ.              END.
    FOR EACH ttCondicaoPagamento: CREATE ttCondicaoPagamentoPJ. BUFFER-COPY ttCondicaoPagamento TO ttCondicaoPagamentoPJ. END.
    FOR EACH ttpessoaJuridica:    CREATE ttpessoaJuridicaPJ.    BUFFER-COPY ttpessoaJuridica    TO ttpessoaJuridicaPJ.    END.
    FOR EACH ttDocumento:         CREATE ttDocumentoPJ.         BUFFER-COPY ttDocumento         TO ttDocumentoPJ.         END.
    FOR EACH ttTelefone:          CREATE ttTelefonePJ.          BUFFER-COPY ttTelefone          TO ttTelefonePJ.          END.
    FOR EACH ttEmail:             CREATE ttEmailPJ.             BUFFER-COPY ttEmail             TO ttEmailPJ.             END.
    FOR EACH ttEndereco:          CREATE ttEnderecoPJ.          BUFFER-COPY ttEndereco          TO ttEnderecoPJ.          END.

    DATASET mensagemPJ:WRITE-XML('longchar', iXML, YES). 
END.
ELSE
    DATASET mensagem:WRITE-XML('longchar', iXML, YES).

RUN esp/wso/in/wso0016.p (INPUT iXML,
                          OUTPUT oXML).

{include/i-rpclo.i} 

RETURN "OK".

