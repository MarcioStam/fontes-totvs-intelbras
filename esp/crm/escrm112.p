/*----------------------------------------------------------------------
**  Programa..: esp/crm/escrm112.p
**  Autor.....: Cenci
**  Data......: Agosto/2011 - Desenvolvimento
**  Descricao.: Retorna pre‡o do item Portal Astec
-----------------------------------------------------------------------*/

CREATE WIDGET-POOL.

DEFINE TEMP-TABLE tt-erros NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".


DEFINE INPUT  PARAMETER pCodEstabel    AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcodEmitente   AS INTEGER     NO-UNDO.
DEFINE INPUT  PARAMETER pItem          AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pTabPreco      AS CHAR      NO-UNDO.
DEFINE OUTPUT PARAMETER pPreco         AS DEC       NO-UNDO.
DEFINE OUTPUT PARAMETER pIpi           AS DEC       NO-UNDO.
DEFINE OUTPUT PARAMETER pIcm           AS DEC       NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-erros.

DEFINE VARIABLE c-nr-tabpre    AS CHARACTER NO-UNDO.
DEFINE VARIABLE h-boes505      AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bodi317im1br AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-nat-oper     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-return       AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-log          AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-usuario            AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-senha              AS CHARACTER                   NO-UNDO.
DEF NEW GLOBAL SHARED VARIABLE g-cod-emitente-bodi317im1br AS INTEGER.

DEF NEW GLOBAL SHARED VARIABLE g-codigo-orig-bodi317sd AS INTEGER.    

{esp/es0018.i}

DEFINE VARIABLE c-dir AS CHARACTER   NO-UNDO.

ASSIGN c-nr-tabpre =  pTabPreco.
 
FOR FIRST estabelec
    WHERE estabelec.cod-estabel = pCodEstabel NO-LOCK:
END.

FIND ITEM
     WHERE ITEM.it-codigo = pItem NO-LOCK NO-ERROR.

FIND FIRST preco-item NO-LOCK
     WHERE preco-item.it-codigo  = ITEM.it-codigo 
       AND preco-item.cod-refer  = ""
       AND preco-item.nr-tabpre  = c-nr-tabpre
       AND preco-item.dt-inival <= TODAY
       AND preco-item.situacao   = 1 NO-ERROR.

IF AVAIL preco-item THEN DO:

    ASSIGN pPreco = preco-item.preco-venda 
           pIpi   = ITEM.aliquota-ipi.

    FOR FIRST emitente
        WHERE emitente.cod-emitente = pcodEmitente NO-LOCK:
    END.

    FOR FIRST loc-entr NO-LOCK
        WHERE loc-entr.nome-abrev  = emitente.nome-abrev
          AND loc-entr.cod-entrega = "Padrao": END.

    FOR FIRST ponto-programa
        WHERE ponto-programa.nome-programa = "es0576",
        FIRST conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
        AND conteudo-programa.sequencia      = int(pCodEstabel):
        IF estabelec.estado = loc-entr.estado THEN
           ASSIGN c-nat-oper =  ENTRY(1,conteudo-programa.conteudo).
        ELSE
           ASSIGN c-nat-oper   =  ENTRY(2,conteudo-programa.conteudo).
    END.

    FIND FIRST ponto-programa
        WHERE ponto-programa.nome-programa = "escrm004":U
          AND ponto-programa.ponto         = 1 NO-LOCK NO-ERROR.

    IF AVAILABLE ponto-programa THEN DO:
        FOR EACH conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
            IF conteudo-programa.sequencia = 1 THEN DO:
                ASSIGN c-usuario = ENTRY(1,conteudo-programa.conteudo,",")
                       c-senha   = ENTRY(2,conteudo-programa.conteudo,",").
            END.
        END.
    END.

    /* Login no EMS */
    RUN bi/esbi002.p (INPUT c-usuario,
                      INPUT c-senha).
    
    ASSIGN g-cod-emitente-bodi317im1br = IF AVAIL emitente THEN emitente.cod-emitente ELSE 0.
    ASSIGN g-codigo-orig-bodi317sd     = IF AVAIL ITEM THEN ITEM.codigo-orig ELSE 0.     

    RUN dibo/bodi317im1br.p PERSISTENT SET h-bodi317im1br.
    RUN calculaAliquotaICMS IN h-bodi317im1br(INPUT  emitente.contrib-icms,
                                              INPUT  emitente.natureza,
                                              INPUT  estabelec.estado,
                                              INPUT  estabelec.pais,
                                              INPUT  loc-entr.estado,
                                              INPUT  item.it-codigo,
                                              INPUT  c-nat-oper,
                                              OUTPUT pIcm, 
                                              OUTPUT l-return).
    
    ASSIGN g-cod-emitente-bodi317im1br = 0.
    ASSIGN g-codigo-orig-bodi317sd     = 0. 

    DELETE PROCEDURE h-bodi317im1br.

    IF  l-return = NO THEN DO:
        CREATE tt-erros.
        ASSIGN tt-erros.mensagem = "Erro ao buscar a Aliquota de ICMS para o Item (" + STRING(item.it-codigo) + ")!".

        IF  l-log THEN DO:
            EMPTY TEMP-TABLE tt-prog-ponto.

            IF OPSYS = "UNIX":U THEN
                RUN esp/es0018p.p (INPUT  "SPOOL-UNIX":U,
                                   INPUT  1,
                                   INPUT  0,
                                   INPUT  "":U,
                                   OUTPUT TABLE tt-prog-ponto).
            ELSE
                RUN esp/es0018p.p (INPUT  "SPOOL-WIN":U,
                                   INPUT  1,
                                   INPUT  0,
                                   INPUT  "":U,
                                   OUTPUT TABLE tt-prog-ponto).

            FOR FIRST tt-prog-ponto:
                ASSIGN c-dir = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
            END.

            IF SUBSTRING(c-dir, LENGTH(c-dir), 1) <> "/":U THEN
                ASSIGN c-dir = c-dir + "/":U.

            OUTPUT TO VALUE(c-dir + "spool/log-apis-crm.txt":U) NO-CONVERT APPEND.

            PUT UNFORMATTED "Erro na busca do ICMS! Par³mentros de Busca:" SKIP
                            " - Emitente Contribuinte: " + STRING(emitente.contrib-icms) SKIP
                            " - Emitente Natureza: " + STRING(emitente.natureza) SKIP
                            " - Estabel Estado: " estabelec.estado SKIP
                            " - Estabel Pa­s: " estabelec.pais SKIP
                            " - Loc Entrega Estado: " loc-entr.estado SKIP
                            " - Item: " item.it-codigo SKIP
                            " - Natureza: " c-nat-oper SKIP.
            OUTPUT CLOSE.
        END.
        /*****************************************************************/
        RETURN "NOK":U.
    END.


END.


