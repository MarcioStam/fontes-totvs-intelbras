DEFINE TEMP-TABLE msg0312 NO-UNDO XML-NODE-NAME 'MSG0312'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'
    FIELD CpfCnpjCodEstrangeiro            AS CHAR
    FIELD CodigoGrupoCobranca              AS INT.

DEFINE TEMP-TABLE msg0312r1 NO-UNDO XML-NODE-NAME 'MSG0312R1'
    FIELD idm AS INT XML-NODE-TYPE 'HIDDEN'.

DEFINE temp-table msg0312r1-DadosCliente no-undo xml-node-name 'DadosCliente'
    FIELD idm                              as int xml-node-type 'hidden'
    FIELD NomeRazaoSocial                  AS CHAR FORMAT "x(80)"
    FIELD NomeFantasia                     AS CHAR FORMAT "x(60)"
    FIELD CpfCnpjCodEstrangeiro            AS CHAR
    FIELD DataConstituicao                 AS CHAR
    FIELD LimiteAdotado                    AS DEC FORMAT ">>>,>>>,>>>,>>9.99"
    FIELD LimiteDisponivel                 AS DEC FORMAT ">>>,>>>,>>>,>>9.99".
