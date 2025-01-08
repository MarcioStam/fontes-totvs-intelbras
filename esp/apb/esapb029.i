/*------------------------------------------------------------------------
    File        : ESAPB029.P
    Purpose     : Informar o pagamento … Pinho do Processo de Embarque,
                  fornecendo o N£mero da Remessa e o Processo de Embarque.
    Procedure   : informarPagamentoPorEmbarque

    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI)
    Created     : Mar‡o de 2013
    Notes       : Consumer: Intelbras, Provider: Pinho
------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt_mensagem NO-UNDO
    FIELD sequencia AS INTEGER
    FIELD tipo      AS CHARACTER
    FIELD subtipo   AS CHARACTER
    FIELD descricao AS CHARACTER
    FIELD ajuda     AS CHARACTER.

