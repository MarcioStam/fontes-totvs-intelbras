{esp/esb/esesb000.i}
{esp/wso/out/wso0001.i}

DEFINE VARIABLE oXML          AS LONGCHAR NO-UNDO.
DEFINE VARIABLE resposta      AS CHAR     NO-UNDO.

DEFINE INPUT PARAM p-transacao AS CHAR NO-UNDO. /*Preco, estoque, etc*/
DEFINE INPUT PARAM TABLE FOR ttPreco.
DEFINE INPUT PARAM TABLE FOR ItemTabelaPreco.

CREATE ttProduto.    
/*CREATE ListaItensTabelaPreco.*/

FIND FIRST ttPreco.
FIND FIRST ItemTabelaPreco NO-ERROR.


/*140171*/
{esp/wso/eswso003b.i}
