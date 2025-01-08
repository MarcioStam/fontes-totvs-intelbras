DEFINE VARIABLE l-primeiro AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-cod-conta AS CHAR   NO-UNDO.
DEFINE VARIABLE c-desc-ccusto AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-desc-conta AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-des-unid-neg AS CHARACTER   NO-UNDO.

DEFINE NEW GLOBAL SHARED variable v_cod_empres_usuar AS CHARACTER FORMAT "x(3)":U LABEL "Empresa" COLUMN-LABEL "Empresa" NO-UNDO.

{upc/btb910za-upc.i}



OUTPUT TO c:\temp\lista-equipamentos-final-prod.csv.

PUT UNFORMATTED
    'Estab;Equipamento;Decricao;Tipo;Descricao;Conta;Descricao;Centro Custo;Descricao;Unid Neg;Descricao;Perc Rateio' SKIP.

run prgint/utb/utb742za.py persistent set h_api_ccusto.
run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
    
FOR EACH equipamentos NO-LOCK
    WHERE equipamentos.ind-situacao = 0:

    IF equipamentos.ct-codigo = '11930045' OR
       equipamentos.ct-codigo = '11810005' OR
       equipamentos.ct-codigo = '1183005'  THEN
        NEXT.

    FOR FIRST tipo-equipamentos NO-LOCK
        WHERE tipo-equipamentos.codigo = equipamentos.tipo:
    END.

    PUT UNFORMATTED
        equipamentos.cod-estabel    ";"
        equipamentos.equipamento    ";"
        equipamentos.descricao      ";"
        equipamentos.tipo           ";"
        IF AVAIL tipo-equipamentos THEN tipo-equipamentos.descricao ELSE "" ";"
        equipamentos.ct-codigo      ";".

    /**/

        
    EMPTY TEMP-TABLE tt_log_erro.

    ASSIGN c-cod-conta = equipamentos.ct-codigo.

    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl
                                            (input        v_cod_empres_usuar,      /* EMPRESA EMS2 */
                                             input        "",                       /* PLANO DE CONTAS */
                                             input-output c-cod-conta,              /* CONTA */
                                             input        TODAY,                    /* DATA TRANSACAO */   
                                             output       c-desc-conta,       /* DESCRICAO CONTA */
                                             output       v_num_tip_cta_ctbl,       /* TIPO DA CONTA */
                                             output       v_num_sit_cta_ctbl,       /* SITUA€ÇO DA CONTA */
                                             output       v_ind_finalid_cta,        /* FINALIDADES DA CONTA */
                                             output table tt_log_erro). 

    IF c-desc-conta = ? THEN
        ASSIGN c-desc-conta = "".

    PUT UNFORMATTED c-desc-conta ";".
    

    /**/

    ASSIGN l-primeiro = TRUE.

    FOR EACH cc-equipamentos NO-LOCK
        WHERE cc-equipamentos.cod-estabel = equipamentos.cod-estabel
        AND   cc-equipamentos.equipamento = equipamentos.equipamento:

        /**/

        EMPTY TEMP-TABLE tt_log_erro.

        run pi_busca_dados_ccusto in h_api_ccusto (input  v_cod_empres_usuar,           /* EMPRESA EMS2 */
                                                   input  "",                            /* CODIGO DO PLANO CCUSTO */
                                                   input  cc-equipamentos.cc-codigo,  /* CCUSTO */
                                                   input  today,                         /* DATA DE TRANSACAO */
                                                   OUTPUT c-desc-ccusto,           /* DESCRICAO DO CCUSTO */
                                                   output table tt_log_erro).            /* ERROS */

        IF c-desc-ccusto = ? THEN
            ASSIGN c-desc-ccusto = "".

        /**/

        FIND FIRST unid_negoc NO-LOCK
            WHERE unid_negoc.cod_unid_negoc = cc-equipamentos.cod-unid-negoc NO-ERROR.
        
        ASSIGN c-des-unid-neg = IF AVAILABLE unid_negoc THEN unid_negoc.des_unid_negoc ELSE ''.

        /**/

        IF l-primeiro THEN DO:
            
            ASSIGN l-primeiro = FALSE.

        END.
        ELSE DO:

            PUT UNFORMATTED
                equipamentos.cod-estabel    ";"
                equipamentos.equipamento    ";"
                equipamentos.descricao      ";"
                equipamentos.tipo           ";"
                IF AVAIL tipo-equipamentos THEN tipo-equipamentos.descricao ELSE "" ";"
                equipamentos.ct-codigo      ";"
                c-desc-conta                ";".

        END.

        PUT UNFORMATTED
            cc-equipamentos.cc-codigo       ";"
            c-desc-ccusto                   ";"
            cc-equipamentos.cod-unid-neg    ";"
            c-des-unid-neg                  ";"
            cc-equipamentos.per-rateio  SKIP.

    END.

    IF NOT CAN-FIND(FIRST cc-equipamentos
                    WHERE cc-equipamentos.cod-estabel = equipamentos.cod-estabel
                    AND   cc-equipamentos.equipamento = equipamentos.equipamento) THEN DO:

        PUT UNFORMATTED SKIP.

    END.


END.

OUTPUT CLOSE.


if valid-handle(h_api_cta_ctbl) then
    delete object h_api_cta_ctbl.

IF VALID-HANDLE(h_api_ccusto) THEN
    DELETE OBJECT h_api_ccusto.
