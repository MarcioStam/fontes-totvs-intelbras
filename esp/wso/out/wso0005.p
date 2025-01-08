{esp/esb/esesb000.i}
{esp/wso/out/wso0005.i}


DEFINE VARIABLE oXML          AS LONGCHAR NO-UNDO.
DEFINE VARIABLE resposta      AS CHAR     NO-UNDO.

DEFINE INPUT PARAM p-transacao AS CHAR NO-UNDO. /*Preco, estoque, , etc*/
DEFINE INPUT PARAM TABLE FOR ttNotaFiscal.
DEFINE INPUT PARAM TABLE FOR ttItemNota.

/*140171*/
{esp/wso/eswso003b.i}
    
