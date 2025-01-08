/*********************************************************************************
** Programa: esp/crm/escrm024.p
** Vers∆o..: 1.00
** Data....: 09/11/2010
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Relat¢rio do Portal B2B.
**           C¢pia da procedure "process-zoom-tabpreco-pecas", programa "soap-b2b-tabpreco"
**           Listagem de Tabela de Preáos de Peáas
*********************************************************************************/

CREATE WIDGET-POOL.


/*--- Definiá∆o das Temp-Tables ---*/
DEF TEMP-TABLE tt-prog-ponto NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo        nome-programa ponto sequencia.

DEFINE TEMP-TABLE tt-preco-item NO-UNDO
    FIELD it-codigo             LIKE item.it-codigo
    FIELD desc-item             LIKE item.desc-item
    FIELD aliquota-ipi          LIKE item.aliquota-ipi
    FIELD ge-codigo             LIKE item.ge-codigo
    FIELD preco-lai             AS DECIMAL
    FIELD preco-lai-sem-ipi     AS DECIMAL
    FIELD preco-revenda         AS DECIMAL
    FIELD preco-revenda-sem-ipi AS DECIMAL
    FIELD preco-consumidor      AS DECIMAL.



/*--- Definiá∆o dos ParÉmetros ---*/
DEFINE INPUT  PARAMETER p-cod-estabel  AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-pais         AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-item         AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-tipo-busca   AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-emitente AS INTEGER     NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-preco-item.



/*--- Definiá∆o das Vari†veis ---*/
DEFINE VARIABLE hQuery      AS HANDLE      NO-UNDO.
DEFINE VARIABLE hBuffer     AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-where     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-sort      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-estado    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-ok        AS LOGICAL     NO-UNDO.
DEFINE VARIABLE i           AS INTEGER     NO-UNDO.
DEFINE VARIABLE d-intelbras AS DECIMAL     NO-UNDO.
DEFINE VARIABLE d-lai       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE d-icms      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE d-ipi       AS DECIMAL     NO-UNDO.



/*--- Bloco Principal ---*/
CREATE QUERY hQuery.

ASSIGN c-where = "EACH item FIELDS (it-codigo desc-item aliquota-ipi ge-codigo) NO-LOCK ".

CASE p-tipo-busca:
    WHEN "codigo" THEN
        ASSIGN c-where = c-where + " WHERE item.it-codigo MATCHES '*" + p-item + "*' ".
    WHEN "descricao" THEN
        ASSIGN c-where = c-where + " WHERE item.desc-item MATCHES '*" + p-item + "*' ".
END CASE.

ASSIGN c-where = c-where + ", FIRST preco-item FIELDS (preco-venda) NO-LOCK
                              WHERE preco-item.it-codigo  = item.it-codigo
                              AND   preco-item.situacao   = 1
                              AND   preco-item.cod-refer  = ''
                              AND   preco-item.nr-tabpre  = 'LAI02'
                              AND   preco-item.dt-inival <= TODAY ".

ASSIGN c-sort = " BY item.it-codigo".

hQuery:SET-BUFFERS(BUFFER item:HANDLE, BUFFER preco-item:HANDLE).


/** Regra para utilizar o ICMS correto
*   Alterada devido ao uso das exceá‰es */
FIND FIRST estabelec NO-LOCK
    WHERE  estabelec.cod-estabel = p-cod-estabel NO-ERROR.
IF  AVAIL  estabelec THEN DO:
    FIND FIRST unid-feder NO-LOCK
        WHERE  unid-feder.pais   = estabelec.pais
        AND    unid-feder.estado = estabelec.estado NO-ERROR.
    IF  AVAIL  unid-feder THEN DO:

        FIND FIRST emitente NO-LOCK
            WHERE  emitente.cod-emitente = p-cod-emitente NO-ERROR.
        IF  AVAIL  emitente THEN
            ASSIGN c-estado = emitente.estado.

        ASSIGN d-icms = 1
               l-ok   = NO.

        IF (unid-feder.estado = c-estado) THEN
            ASSIGN d-icms = unid-feder.per-icms-int / 100.
        ELSE DO:
            DO i = 1 TO 25:
                IF (unid-feder.est-exc[i] = c-estado) AND NOT (l-ok) THEN
                    ASSIGN d-icms = unid-feder.perc-exc[i] / 100
                           l-ok   = YES.
            END.

            IF NOT (l-ok) THEN
                ASSIGN d-icms = unid-feder.per-icms-ext / 100.
        END.
    END.
END.


IF (hQuery:QUERY-PREPARE("PRESELECT " + c-where + c-sort) = FALSE) THEN DO:
    LEAVE.
END.

hQuery:QUERY-OPEN.


RUN esp/es0018p.p (INPUT  "es0778", /* Nome do programa */
                   INPUT  3,        /* Ponto do programa */
                   INPUT  0,
                   INPUT  "",
                   OUTPUT TABLE tt-prog-ponto).

IF (hQuery:NUM-RESULTS <> 0) THEN DO:
    REPEAT:
        hQuery:GET-NEXT.

        IF (hQuery:QUERY-OFF-END) THEN
            LEAVE.
    
        /** Seta a variavel referente ao IPI **/
        ASSIGN d-ipi = item.aliquota-ipi / 100.
    
        CREATE tt-preco-item.
        ASSIGN tt-preco-item.it-codigo    = item.it-codigo
               tt-preco-item.desc-item    = item.desc-item
               tt-preco-item.aliquota-ipi = item.aliquota-ipi
               tt-preco-item.ge-codigo    = item.ge-codigo.
    
        /**
        * Explicaá∆o do 0.495:
        * - LAI tem 25% de desconto em cima do preáo de revenda, mais uma
        *   bonificaá∆o de 12% -- conforme explicado por Lazare em 27.04,
        *   para Felipe e Claudiney.
        * - 0.495 = 0.75 * 0.75 * 0.88
        */
        /**
        * Alteraá∆o de desconto de 25% + 25% + 12% para 20% + 20% + 12%,
        * conforme combinado com Cida e M†rcio
        */ 
        /**
        * Removido os 12% conforme solicitado pela Cida
        */
        /**
        * Alterada a forma de c†lculo conforme solicitado pelo Lazare. Agora tem um valor
        * para matÇria prima, outro pro restante.
        */
        /**
        * Incidente 18513: alterando percentuais para alguns itens
        */
        IF  CAN-FIND(FIRST tt-prog-ponto
                     WHERE tt-prog-ponto.conteudo = item.it-codigo) THEN
            ASSIGN d-intelbras = 1.25
                   d-lai       = 1.12.
        ELSE
            ASSIGN d-intelbras = 1.25
                   d-lai       = (IF item.desc-item BEGINS 'PLACA' THEN 1.3 ELSE 1.51).


        ASSIGN tt-preco-item.preco-lai         = (preco-item.preco-venda / (1 - d-icms) * (1 + d-ipi) / d-intelbras / d-lai)
               tt-preco-item.preco-lai-sem-ipi = (preco-item.preco-venda / (1 - d-icms) / d-intelbras / d-lai).


        /**
        * Preáo de revenda: 25% de desconto no preáo de tabela
        *
        * Alterado para 20% em 13/07/2009
        */
        ASSIGN tt-preco-item.preco-revenda         = (preco-item.preco-venda / (1 - d-icms) * (1 + d-ipi) / 1.25)
               tt-preco-item.preco-revenda-sem-ipi = (preco-item.preco-venda / (1 - d-icms) / 1.25).

    
        /**
        * Preáo do consumidor final: 17% de acrÇscimo no preáo de tabela
        */
        ASSIGN tt-preco-item.preco-consumidor = (preco-item.preco-venda / (1 - d-icms) * (1 + d-ipi)).
    END.
END.

DELETE OBJECT hQuery.


DELETE WIDGET-POOL.
RETURN "OK":U.
