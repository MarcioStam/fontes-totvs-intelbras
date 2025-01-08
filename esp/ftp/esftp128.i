DEF TEMP-TABLE ttPlp NO-UNDO XML-NODE-NAME 'plp'
    FIELD idm                             AS INT XML-NODE-TYPE 'HIDDEN'
	FIELD id as int
	FIELD codExterno as char
	FIELD dtEnvio as char
	FIELD tpAgrupamento as char.
	
DEF TEMP-TABLE ttResumoServicos  NO-UNDO XML-NODE-NAME 'resumoServicos'
    FIELD idm                             AS INT XML-NODE-TYPE 'HIDDEN'
	FIELD codServico as char
	FIELD nomeServico as char
	FIELD quantidadeAwbs as int.
	
DEF TEMP-TABLE ttDocsExternos  NO-UNDO XML-NODE-NAME 'docsExternos'
    FIELD idm                             AS INT XML-NODE-TYPE 'HIDDEN'
	FIELD codCliente as char
	field docExterno as char
	field dtPrometida as char
	field dtLimiteExpedicao as char
	field dtLimiteExpedicaoCompleta as char
	field tpEntrega as char
	field pesoTotal as dec
	field marca as char
	field qtVolumes as int
	field numeroContratoTransp as char
	field nomeEmbarcador as char
	field telefoneEmbarcador as int
	field emailEmbarcador as char
	field tpServico as char
	field numNotaFiscal as char
	field serieNotaFiscal as char
	field megaRota as char
	field rota as char
	field telefoneContato as char
	field vlEntrega as dec
	field cartaoPostagem as char
	field servicoAdicional as char
	field pedInLoja as char
	field tpLoja as char.
	
DEF TEMP-TABLE ttDestinatario  NO-UNDO XML-NODE-NAME 'destinatario'
    FIELD idm                             AS INT XML-NODE-TYPE 'HIDDEN'
	field nome as char
	field enderecoLogradouro as char
	field enderecoNumero as char
	field enderecoComplemento as char
	field enderecoBairro as char
	field enderecoReferencia as char
	field enderecoCidade as char
	field enderecoUf as char
	field enderecoCep as char.
	
DEF TEMP-TABLE ttRemetente  NO-UNDO XML-NODE-NAME 'remetente'
    FIELD idm                             AS INT XML-NODE-TYPE 'HIDDEN'
	field nome as char
	field enderecoLogradouro as char
	field enderecoNumero as char
	field enderecoComplemento as char
	field enderecoBairro as char
	field enderecoCidade as char
	field enderecoUf as char
	field enderecoCep as char
	field enderecoReferencia as char.	
	
DEF TEMP-TABLE ttAwbs  NO-UNDO XML-NODE-NAME 'awbs'
    FIELD idm                             AS INT XML-NODE-TYPE 'HIDDEN'
	field codigoAwb as char
	field posicaoVolume as int.
	
DEF TEMP-TABLE ttItens  NO-UNDO XML-NODE-NAME 'itens'
    FIELD idm                             AS INT XML-NODE-TYPE 'HIDDEN'
	field descricao as char
	field quantidade as int
	field peso as dec.

/***
-plp
--resumoServicos
-docsExternos[]
--destinatario
--remetente
--awbs[]
---itens[]
***/
