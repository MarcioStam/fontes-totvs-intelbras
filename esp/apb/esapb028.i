/*------------------------------------------------------------------------
    File        : ESAPB028.I
    Purpose     : Buscar os Processos de Embarque no Web Service da Pinho,
                  fornecendo o N£mero da Remessa.
    Procedure   : getListaReferenciasPorRemessa

    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI)
    Created     : Mar‡o de 2013
    Notes       : Consumer: Intelbras, Provider: Pinho
------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt_processo_embarque NO-UNDO
    FIELD processo_embarque AS CHARACTER FORMAT "x(12)":U                        INITIAL "":U LABEL "Processo Embarque":U COLUMN-LABEL "Proces Embarq":U
    FIELD valor_embarque    AS DECIMAL   FORMAT "->,>>>,>>>,>>9.99":U DECIMALS 2 INITIAL 0    LABEL "Valor Embarque":U    COLUMN-LABEL "Vlr Embarq":U
    INDEX idx_primario IS PRIMARY
        processo_embarque.

DEFINE TEMP-TABLE tt_mensagem NO-UNDO
    FIELD sequencia AS INTEGER
    FIELD tipo      AS CHARACTER
    FIELD descricao AS CHARACTER
    FIELD ajuda     AS CHARACTER.

