/*------------------------------------------------------------------------
    File        : GKAPI001.P
    Purpose     : Defini‡Æo da temp-table para gerar hist¢rico de
                  integra‡Æo GKO X EMS.
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (SQL Works / Exponencial TI)
    Created     : Maio de 2012
    Notes       : <none>
------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-log-gko NO-UNDO
    FIELD nom-arquivo-integracao LIKE gko-importacao.nom-arquivo-integracao
    FIELD cod-arquivo-integracao LIKE gko-importacao.nom-arquivo-integracao
    FIELD log-imp-erro           LIKE gko-importacao.log-imp-erro           /* YES - Erro e NO - Importado com sucesso */
    FIELD ind-tipo-integracao    LIKE gko-importacao.ind-tipo-integracao    /* 1 - Conhecimento, 2 - Fatura e 3 - Data de Sa¡da */
    FIELD des-erro-imp           LIKE gko-log-importacao.des-erro-imp       /* Descri‡Æo do Erro (Caso o campo "log-imp-erro" estiver marcado com "YES") */
    INDEX id-arquivo AS PRIMARY
        nom-arquivo-integracao.
