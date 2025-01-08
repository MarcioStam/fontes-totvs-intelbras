{esp/esb/esesb000.i}
{esp/wso/out/wso0002.i}


DEFINE VARIABLE oXML          AS LONGCHAR NO-UNDO.
DEFINE VARIABLE resposta      AS CHAR     NO-UNDO.

DEFINE INPUT PARAM p-transacao AS CHAR NO-UNDO. /*Preco, estoque, etc*/
DEFINE INPUT PARAM TABLE FOR ttEstoque.

CREATE ttProduto.
FIND FIRST ttEstoque NO-ERROR.

/*140171*/
{esp/wso/eswso003b.i}
