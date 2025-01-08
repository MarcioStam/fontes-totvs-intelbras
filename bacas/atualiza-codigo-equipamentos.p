/*
equipamentos.equipamento
cc-equipamentos.equipamento
fatura-equipamentos.equipamento
rateio-equipamentos.equipamento
telefonia.equipamento
usu-equipamentos.equipamento
*/


DEFINE VARIABLE c-equip-antes AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-equip-depois AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-eqp AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cce AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-fat AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-rat AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-tel AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-usu AS INTEGER     NO-UNDO.


ASSIGN c-equip-antes  = "98699945614"   
       c-equip-depois = "86999945614".   

ASSIGN i-eqp = 0
       i-cce = 0 
       i-fat = 0
       i-rat = 0
       i-tel = 0
       i-usu = 0.

FOR EACH equipamentos 
    WHERE equipamentos.equipamento = c-equip-antes
    EXCLUSIVE-LOCK:
    
    FOR EACH cc-equipamentos EXCLUSIVE-LOCK
        WHERE cc-equipamentos.cod-estabel = equipamentos.cod-estabel
        AND   cc-equipamentos.equipamento = equipamentos.equipamento:

        ASSIGN cc-equipamentos.equipamento = c-equip-depois
               i-cce = i-cce + 1.

    END.

    FOR EACH fatura-equipamentos EXCLUSIVE-LOCK
        WHERE fatura-equipamentos.cod-estabel = equipamentos.cod-estabel
        AND   fatura-equipamentos.equipamento = equipamentos.equipamento:

        ASSIGN fatura-equipamentos.equipamento = c-equip-depois
               i-fat = i-fat + 1.

    END.

    FOR EACH rateio-equipamentos EXCLUSIVE-LOCK
        WHERE rateio-equipamentos.cod-estabel = equipamentos.cod-estabel
        AND   rateio-equipamentos.equipamento = equipamento.equipamento:

        ASSIGN rateio-equipamentos.equipamento = c-equip-depois
               i-rat = i-rat + 1.

    END.

    FOR EACH telefonia EXCLUSIVE-LOCK
        WHERE telefonia.cod-estabel = equipamentos.cod-estabel
        AND   telefonia.equipamento = equipamentos.equipamento:

        ASSIGN telefonia.equipamento = c-equip-depois
               i-tel = i-tel + 1.

    END.

    FOR EACH usu-equipamentos EXCLUSIVE-LOCK
        WHERE usu-equipamentos.cod-estabel = equipamentos.cod-estabel
        AND   usu-equipamentos.equipamento = equipamentos.equipamento:

        ASSIGN usu-equipamentos.equipamento = c-equip-depois
               i-usu = i-usu + 1.

    END.

    ASSIGN equipamentos.equipamento = c-equip-depois
           i-eqp = i-eqp + 1.

END.

/**/

OUTPUT TO c:\temp\atualiza-codigo-equipamentos.txt.

PUT UNFORMATTED
    "Alterados com estabelecimento" SKIP
    "-----------------------------" SKIP
    "       equipametnos: " i-eqp SKIP
    "    cc-equipamentos: " i-cce SKIP
    "fatura-equipamentos: " i-fat SKIP
    "rateio-equipamentos: " i-rat SKIP
    "          telefonia: " i-tel SKIP
    "   usu-equipamentos: " i-usu SKIP(2).


ASSIGN i-eqp = 0
       i-cce = 0 
       i-fat = 0
       i-rat = 0
       i-tel = 0
       i-usu = 0.


FOR EACH equipamentos NO-LOCK
    WHERE equipamentos.equipamento = c-equip-antes:
    ASSIGN i-eqp = i-eqp + 1.
END.

FOR EACH cc-equipamentos NO-LOCK
    WHERE cc-equipamentos.equipamento = c-equip-antes:
    ASSIGN i-cce = i-cce + 1.
END.

FOR EACH fatura-equipamentos NO-LOCK
    WHERE fatura-equipamentos.equipamento = c-equip-antes:
    ASSIGN i-fat = i-fat + 1.
END.
    
FOR EACH rateio-equipamentos NO-LOCK
    WHERE rateio-equipamentos.equipamento = c-equip-antes:
    ASSIGN i-rat = i-rat + 1.
END.

FOR EACH telefonia NO-LOCK
    WHERE telefonia.equipamento = c-equip-antes:
    ASSIGN i-tel = i-tel + 1.
END.

FOR EACH usu-equipamentos NO-LOCK
    WHERE usu-equipamentos.equipamento = c-equip-antes:
    ASSIGN i-usu = i-usu + 1.
END.

PUT UNFORMATTED
    "Sem alterar desconsiderando estabelecimento" SKIP
    "-------------------------------------------" SKIP
    "       equipametnos: " i-eqp SKIP
    "    cc-equipamentos: " i-cce SKIP
    "fatura-equipamentos: " i-fat SKIP
    "rateio-equipamentos: " i-rat SKIP
    "          telefonia: " i-tel SKIP
    "   usu-equipamentos: " i-usu SKIP(2).

OUTPUT CLOSE.

