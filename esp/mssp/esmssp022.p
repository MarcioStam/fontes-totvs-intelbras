/*------------------------------------------------------------------------
    File        : ESMSSP022.P
    Purpose     : Busca Item por Campo e Faixa
    Procedure   : buscaItemCampoFaixa
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (SQL Works / Exponencial TI)
    Created     : Junho de 2012
    Notes       : <none>
------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-item NO-UNDO
    FIELD it-codigo        LIKE item.it-codigo
    FIELD desc-item        LIKE item.desc-item
    FIELD fm-codigo        LIKE item.fm-codigo
    FIELD fm-cod-com       LIKE item.fm-cod-com
    FIELD class-fiscal     LIKE item.class-fiscal
    FIELD nve              LIKE int-item.nve
    FIELD ex-tarifario     LIKE int-item.ex-tarifario
    FIELD aliquota-ipi     LIKE item.aliquota-ipi
    FIELD it-fabric        LIKE item-fabric.it-fabric
    FIELD nome-abrev       LIKE fabricante.nome-abrev
    FIELD log-necessita-li LIKE item.log-necessita-li.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE h-query AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-where AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-sort  AS CHARACTER   NO-UNDO.

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER p-campo     AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-param-ini AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-param-fin AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-item.
DEFINE OUTPUT PARAMETER p-mensagem  AS CHARACTER   NO-UNDO.


/* ***************************  Main Block  *************************** */

EMPTY TEMP-TABLE tt-item.

IF p-param-fin <> "":U        AND
   p-param-ini  > p-param-fin THEN DO:
    ASSIGN p-mensagem = "Parƒmetro inicial maior que o parƒmetro final":U.

    RETURN "NOK":U.
END.

CREATE QUERY h-query.

ASSIGN c-where = "":U
       c-sort  = "":U.

CASE p-campo:
    WHEN "":U THEN
        ASSIGN c-where = "EACH item FIELDS(it-codigo desc-item fm-codigo fm-cod-com class-fiscal aliquota-ipi log-necessita-li) NO-LOCK, ":U.
    WHEN "it-codigo":U THEN
        IF p-param-fin = "":U THEN
            ASSIGN c-where = "EACH item FIELDS(it-codigo desc-item fm-codigo fm-cod-com class-fiscal aliquota-ipi log-necessita-li) NO-LOCK ":U +
                             "    WHERE item.it-codigo BEGINS ~"":U + p-param-ini + "~", ":U.
        ELSE
            ASSIGN c-where = "EACH item FIELDS(it-codigo desc-item fm-codigo fm-cod-com class-fiscal aliquota-ipi log-necessita-li) NO-LOCK ":U +
                             "WHERE item.it-codigo >= ~"":U + p-param-ini + "~" ":U +
                             "  AND item.it-codigo <= ~"":U + p-param-fin + "~", ":U.
    WHEN "desc-item":U THEN
        IF p-param-fin = "":U THEN
            ASSIGN c-where = "EACH item FIELDS(it-codigo desc-item fm-codigo fm-cod-com class-fiscal aliquota-ipi log-necessita-li) NO-LOCK ":U +
                             "WHERE item.desc-item MATCHES ~"*":U + p-param-ini + "*~", ":U
                   c-sort  = "BY item.desc-item BY item.it-codigo":U.
        ELSE
            ASSIGN c-where = "EACH item FIELDS(it-codigo desc-item fm-codigo fm-cod-com class-fiscal aliquota-ipi log-necessita-li) NO-LOCK ":U +
                             "WHERE item.desc-item >= ~"":U + p-param-ini + "~" ":U +
                             "  AND item.desc-item <= ~"":U + p-param-fin + "~", ":U
                   c-sort  = "BY item.desc-item BY item.it-codigo":U.
    WHEN "fm-codigo":U THEN
        IF p-param-fin = "":U THEN
            ASSIGN c-where = "EACH item FIELDS(it-codigo desc-item fm-codigo fm-cod-com class-fiscal aliquota-ipi log-necessita-li) NO-LOCK ":U +
                             "WHERE item.fm-codigo = ~"":U + p-param-ini + "~", ":U
                   c-sort  = "BY item.fm-codigo BY item.it-codigo":U.
        ELSE
            ASSIGN c-where = "EACH item FIELDS(it-codigo desc-item fm-codigo fm-cod-com class-fiscal aliquota-ipi log-necessita-li) NO-LOCK ":U +
                             "WHERE item.fm-codigo >= ~"":U + p-param-ini + "~" ":U +
                             "  AND item.fm-codigo <= ~"":U + p-param-fin + "~", ":U
                   c-sort  = "BY item.fm-codigo BY item.it-codigo":U.
    WHEN "fm-cod-com":U THEN
        IF p-param-fin = "":U THEN
            ASSIGN c-where = "EACH item FIELDS(it-codigo desc-item fm-codigo fm-cod-com class-fiscal aliquota-ipi log-necessita-li) NO-LOCK ":U +
                             "WHERE item.fm-cod-com = ~"":U + p-param-ini + "~", ":U
                   c-sort  = "BY item.fm-cod-com BY item.it-codigo":U.
        ELSE
            ASSIGN c-where = "EACH item FIELDS(it-codigo desc-item fm-codigo fm-cod-com class-fiscal aliquota-ipi log-necessita-li) NO-LOCK ":U +
                             "WHERE item.fm-cod-com >= ~"":U + p-param-ini + "~" ":U +
                             "  AND item.fm-cod-com <= ~"":U + p-param-fin + "~", ":U
                   c-sort  = "BY item.fm-cod-com BY item.it-codigo":U.
    WHEN "class-fiscal":U THEN
        IF p-param-fin = "":U THEN
            ASSIGN c-where = "EACH item FIELDS(it-codigo desc-item fm-codigo fm-cod-com class-fiscal aliquota-ipi log-necessita-li) NO-LOCK ":U +
                             "WHERE item.class-fiscal = ~"":U + p-param-ini + "~", ":U
                   c-sort  = "BY item.class-fiscal BY item.it-codigo":U.
        ELSE
            ASSIGN c-where = "EACH item FIELDS(it-codigo desc-item fm-codigo fm-cod-com class-fiscal aliquota-ipi log-necessita-li) NO-LOCK ":U +
                             "WHERE item.class-fiscal >= ~"":U + p-param-ini + "~" ":U +
                             "  AND item.class-fiscal <= ~"":U + p-param-fin + "~", ":U
                   c-sort  = "BY item.class-fiscal BY item.it-codigo":U.
    WHEN "nve":U THEN
        IF p-param-fin = "":U THEN
            ASSIGN c-where = "EACH int-item FIELDS(it-codigo nve ex-tarifario) NO-LOCK ":U +
                             "WHERE int-item.nve = ~"":U + p-param-ini + "~", ":U
                   c-sort  = "BY int-item.it-codigo BY item.it-codigo ":U.
        ELSE
            ASSIGN c-where = "EACH int-item FIELDS(it-codigo nve ex-tarifario) NO-LOCK ":U +
                             "WHERE int-item.nve >= ~"":U + p-param-ini + "~" ":U +
                             "  AND int-item.nve <= ~"":U + p-param-fin + "~", ":U
                   c-sort  = "BY int-item.it-codigo BY item.it-codigo ":U.
    WHEN "ex-tarifario":U THEN
        IF p-param-fin = "":U THEN
            ASSIGN c-where = "EACH int-item FIELDS(it-codigo nve ex-tarifario) NO-LOCK ":U +
                             "WHERE int-item.ex-tarifario = ":U + p-param-ini + ", ":U
                   c-sort  = "BY int-item.it-codigo BY item.it-codigo":U.
        ELSE
            ASSIGN c-where = "EACH int-item FIELDS(it-codigo nve ex-tarifario) NO-LOCK ":U +
                             "WHERE int-item.ex-tarifario >= ":U + p-param-ini + " ":U +
                             "  AND int-item.ex-tarifario <= ":U + p-param-fin + ", ":U
                   c-sort  = "BY int-item.it-codigo BY item.it-codigo":U.
    WHEN "aliquota-ipi":U THEN
        IF p-param-fin = "":U THEN
            ASSIGN c-where = "EACH item FIELDS(it-codigo desc-item fm-codigo fm-cod-com class-fiscal aliquota-ipi log-necessita-li) NO-LOCK ":U +
                             "WHERE item.aliquota-ipi = ":U + p-param-ini + ", ":U
                   c-sort  = "BY item.aliquota-ipi BY item.it-codigo":U.
        ELSE
            ASSIGN c-where = "EACH item FIELDS(it-codigo desc-item fm-codigo fm-cod-com class-fiscal aliquota-ipi log-necessita-li) NO-LOCK ":U +
                             "WHERE item.aliquota-ipi >= ":U + p-param-ini + " ":U +
                             "  AND item.aliquota-ipi <= ":U + p-param-fin + ", ":U
                   c-sort  = "BY item.aliquota-ipi BY item.it-codigo":U.
    WHEN "it-fabric":U THEN
        IF p-param-fin = "":U THEN
            ASSIGN c-where = "EACH item-fabric FIELDS(it-fabric it-codigo) NO-LOCK ":U +
                             "WHERE item-fabric.it-fabric MATCHES ~"*":U + p-param-ini + "*~", ":U
                   c-sort  = "BY item-fabric.it-fabric":U.
        ELSE
            ASSIGN c-where = "EACH item-fabric FIELDS(it-fabric it-codigo) NO-LOCK ":U +
                             "WHERE item-fabric.it-fabric >= ~"":U + p-param-ini + "~" ":U +
                             "  AND item-fabric.it-fabric <= ~"":U + p-param-fin + "~", ":U
                   c-sort  = "BY item-fabric.it-fabric BY item.it-codigo":U.
    WHEN "nome-abrev":U THEN
        IF p-param-fin = "":U THEN
            ASSIGN c-where = "EACH fabricante FIELDS(nome-abrev) NO-LOCK ":U +
                             "WHERE fabricante.nome-abrev MATCHES ~"*":U + p-param-ini + "*~", ":U
                   c-sort  = "BY fabricante.nome-abrev BY item.it-codigo BY item-fabric.it-fabric":U.
        ELSE
            ASSIGN c-where = "EACH fabricante FIELDS(nome-abrev) NO-LOCK ":U +
                             "WHERE fabricante.nome-abrev >= ~"":U + p-param-ini + "~" ":U +
                             "  AND fabricante.nome-abrev <= ~"":U + p-param-fin + "~", ":U
                   c-sort  = "BY fabricante.nome-abrev BY item.it-codigo BY item-fabric.it-fabric":U.
    OTHERWISE DO:
        ASSIGN p-mensagem = "NÆo ‚ poss¡vel realizar busca com o campo informado!":U.

        RETURN "NOK":U.
    END.
END CASE.

IF p-campo = "":U             OR
   p-campo = "it-codigo":U    OR
   p-campo = "desc-item":U    OR
   p-campo = "fm-codigo":U    OR
   p-campo = "fm-cod-com":U   OR
   p-campo = "class-fiscal":U OR
   p-campo = "aliquota-ipi":U THEN DO:
    ASSIGN c-where = c-where +
                     "EACH int-item FIELDS(nve ex-tarifario) NO-LOCK ":U +
                     "WHERE int-item.it-codigo = item.it-codigo, ":U +
                     "EACH item-fabric FIELDS(cod-fabric it-fabric) NO-LOCK ":U +
                     "WHERE item-fabric.it-codigo = item.it-codigo OUTER-JOIN, ":U +
                     "EACH fabricante FIELDS(nome-abrev) NO-LOCK ":U +
                     "WHERE fabricante.cod-fabric = item-fabric.cod-fabric OUTER-JOIN ":U.

    h-query:SET-BUFFERS(BUFFER item:HANDLE, BUFFER int-item:HANDLE, BUFFER item-fabric:HANDLE, BUFFER fabricante:HANDLE).
END.
ELSE IF p-campo = "nve":U          OR
        p-campo = "ex-tarifario":U THEN DO:
    ASSIGN c-where = c-where +
                     "EACH item FIELDS(it-codigo desc-item class-fiscal fm-codigo fm-cod-com aliquota-ipi log-necessita-li) NO-LOCK ":U +
                     "WHERE item.it-codigo = int-item.it-codigo, ":U +
                     "EACH item-fabric FIELDS(it-fabric) NO-LOCK ":U +
                     "WHERE item-fabric.it-codigo = item.it-codigo OUTER-JOIN, ":U +
                     "EACH fabricante FIELDS(nome-abrev) NO-LOCK ":U +
                     "WHERE fabricante.cod-fabric = item-fabric.cod-fabric OUTER-JOIN ":U.

    h-query:SET-BUFFERS(BUFFER int-item:HANDLE, BUFFER item:HANDLE, BUFFER item-fabric:HANDLE, BUFFER fabricante:HANDLE).
END.
ELSE IF p-campo = "it-fabric":U THEN DO:
    ASSIGN c-where = c-where +
                     "EACH fabricante FIELDS(nome-abrev) NO-LOCK ":U +
                     "WHERE fabricante.cod-fabric = item-fabric.cod-fabric OUTER-JOIN, ":U +
                     "EACH item FIELDS(it-codigo desc-item class-fiscal fm-codigo fm-cod-com aliquota-ipi) NO-LOCK ":U +
                     "WHERE item.it-codigo = item-fabric.it-codigo, ":U +
                     "EACH int-item FIELDS(nve ex-tarifario) NO-LOCK ":U +
                     "WHERE int-item.it-codigo = item.it-codigo ":U.

    h-query:SET-BUFFERS(BUFFER item-fabric:HANDLE, BUFFER fabricante:HANDLE, BUFFER item:HANDLE, BUFFER int-item:HANDLE).
END.
ELSE IF p-campo = "nome-abrev":U THEN DO:
    ASSIGN c-where = c-where +
                     "EACH item-fabric FIELDS(it-fabric it-codigo) NO-LOCK ":U +
                     "WHERE item-fabric.cod-fabric = fabricante.cod-fabric, ":U +
                     "EACH item FIELDS(it-codigo desc-item class-fiscal fm-codigo fm-cod-com aliquota-ipi) NO-LOCK ":U +
                     "WHERE item.it-codigo = item-fabric.it-codigo, ":U +
                     "EACH int-item FIELDS(nve ex-tarifario) NO-LOCK ":U +
                     "WHERE int-item.it-codigo = item.it-codigo ":U.

    h-query:SET-BUFFERS(BUFFER fabricante:HANDLE, BUFFER item-fabric:HANDLE, BUFFER item:HANDLE, BUFFER int-item:HANDLE).
END.

IF NOT h-query:QUERY-PREPARE("PRESELECT ":U + c-where + c-sort) THEN DO:
    ASSIGN p-mensagem = "Erro na pesquisa - entre em contato com o Departamento de Inform tica":U.

    RETURN "NOK":U.
END.

h-query:QUERY-OPEN().
h-query:GET-FIRST().

DO WHILE NOT h-query:QUERY-OFF-END:
    CREATE tt-item.
    ASSIGN tt-item.it-codigo        = item.it-codigo
           tt-item.desc-item        = item.desc-item
           tt-item.fm-codigo        = item.fm-codigo
           tt-item.fm-cod-com       = item.fm-cod-com
           tt-item.class-fiscal     = item.class-fiscal
           tt-item.nve              = int-item.nve
           tt-item.ex-tarifario     = int-item.ex-tarifario
           tt-item.aliquota-ipi     = item.aliquota-ipi
           tt-item.it-fabric        = item-fabric.it-fabric
           tt-item.nome-abrev       = fabricante.nome-abrev
           tt-item.log-necessita-li = item.log-necessita-li.

    h-query:GET-NEXT().
END.

h-query:QUERY-CLOSE.

DELETE OBJECT h-query.

IF NOT CAN-FIND(FIRST tt-item) THEN DO:
    ASSIGN p-mensagem = "Item nÆo encontrado!":U.

    RETURN "NOK":U.
END.

RETURN "OK":U.

