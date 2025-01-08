
PROCEDURE pi-retorna-trimestre-historico:
    /* Objetivo: Quando uma solicita‡Æo ‚ transferida de um trimestre para outro, ‚ criada uma c¢pia dela e mantida
                 no trimestre que se encerra. Isso para que os programas que compäem saldo (quando vocˆ consulta o
                 o esesb008 por exemplo, ele deve compor o saldo considerando essa c¢pia que possui os valores atendidos
                 parcialmente ou nÆo nesse trimestre encerrado.
                 Para mantermos a rela‡Æo entre eleas, o Guida da solicita‡Æo hist¢rica ‚ exatamente o guid da solicita‡Æo 
                 que foi transferida, por‚m com o sufixo indicando que ‚ hist¢rica; 
                 Ex: HIST_1T2016. 
                     neste caso, indica que em Abril, um solicita‡Æo do primeiro trimestre foi transferida para o segundo,
                     um c¢pia dela ‚ mantida como HIST_1T2016 */

    DEF INPUT PARAM p-data-fim-tri AS DATE NO-UNDO.
    DEF OUTPUT PARAM p-prefixo     AS CHAR NO-UNDO.

    CASE MONTH(p-data-fim-tri):
        WHEN 03 THEN ASSIGN p-prefixo = "H_1T" + string(YEAR(p-data-fim-tri), "9999") + "_".
        WHEN 06 THEN ASSIGN p-prefixo = "H_2T" + string(YEAR(p-data-fim-tri), "9999") + "_".
        WHEN 09 THEN ASSIGN p-prefixo = "H_3T" + string(YEAR(p-data-fim-tri), "9999") + "_".
        WHEN 12 THEN ASSIGN p-prefixo = "H_4T" + string(YEAR(p-data-fim-tri), "9999") + "_".
    END CASE.

END.


