/*********************************************************************************
** Programa: esp/crm/escrm030.p
** Vers∆o..: 1.00
** Data....: 07/12/2010
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: API para retornar a Listagem da Tabela de Preáo dos Itens do Cliente
*********************************************************************************/


CREATE WIDGET-POOL.


/*--- Definiá∆o dos ParÉmetros ---*/
DEFINE TEMP-TABLE tt-preco-item NO-UNDO
    FIELD lay-nome         LIKE layout-tabpreco.lay-nome
    FIELD it-codigo        LIKE preco-item.it-codigo
    FIELD desc-item        LIKE item.desc-item
    FIELD fm-cod-com       LIKE fam-comerc.fm-cod-com
    FIELD ds-fm-cod-com    LIKE fam-comerc.descricao
    FIELD vl-preco-pma     LIKE int-preco-item.pma
    FIELD vl-preco-pmd     LIKE int-preco-item.pmd
    FIELD vl-preco-sem-ipi LIKE preco-item.preco-venda
    FIELD vl-preco-com-ipi LIKE preco-item.preco-venda.

DEFINE INPUT  PARAMETER p-cod-estabel-orig AS CHARACTER FORMAT "x(3)"          NO-UNDO.
DEFINE INPUT  PARAMETER p-estado-dest      AS CHARACTER FORMAT "x(2)"          NO-UNDO.
DEFINE INPUT  PARAMETER p-cd-categoria     AS INTEGER   FORMAT ">>9"           NO-UNDO.
DEFINE INPUT  PARAMETER p-ds-unid-comerc   AS CHARACTER FORMAT "x(5)"          NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-gr-cli       AS INTEGER   FORMAT ">9"            NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-cliente      AS INTEGER   FORMAT ">>>>>>>>9"     NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-preco-item.
DEF NEW GLOBAL SHARED VARIABLE g-cod-emitente-bodi317im1br AS INTEGER.

DEF NEW GLOBAL SHARED VARIABLE g-codigo-orig-bodi317sd AS INTEGER.

/*--- Definiá∆o das Vari†veis ---*/
DEFINE VARIABLE i-cd-unid-comerc AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cod-gr-cli     AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cont           AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-round          AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-arred          AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-tb-especifica  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-log            AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-return         AS LOGICAL     NO-UNDO.
DEFINE VARIABLE de-preco         AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-preco-com-ipi AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-desconto      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-perc-icms     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-per-des-icms  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-usuario        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-senha          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nat-oper       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-boes505        AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bodi317im1br   AS HANDLE      NO-UNDO.



/*--- Definiá∆o das Temp-Tables ----*/
DEFINE TEMP-TABLE tt-tb-preco NO-UNDO
    FIELD nr-tabpre           LIKE tb-preco.nr-tabpre
    FIELD ds-descricao        AS CHARACTER FORMAT "x(30)"
    FIELD cod-rep             LIKE crm-relacionamento-cliente.cod-rep
    FIELD cd-categoria        LIKE crm-relacionamento-cliente.cd-categoria
    FIELD cd-unid-negoc       AS CHARACTER
    FIELD lg-tb-especifica    AS INTEGER.




/*--- Bloco Principal ---*/
ASSIGN l-log = YES.

/******************** Log de Execuá∆o da API *********************/
IF  l-log THEN DO:
    IF  OPSYS = "WIN32":U THEN DO:
        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
    END.
    ELSE DO:
        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
    END.
    PUT UNFORMATTED "--------------------------------------------------------------------------------" SKIP
                    "Inicio API ListagemPrecoCliente -- " + STRING(TODAY, "99/99/9999") + " - " + STRING(TIME, "HH:MM:SS") SKIP.
    PUT UNFORMATTED "Parametros Recebidos:" SKIP
                    " - Estab Origem: " p-cod-estabel-orig SKIP
                    " - Estado Destino: " p-estado-dest SKIP
                    " - Categoria: " p-cd-categoria SKIP
                    " - Unid Comercial: " p-ds-unid-comerc SKIP
                    " - C¢d Cliente.: " p-cod-cliente SKIP.
    OUTPUT CLOSE.
END.
/*****************************************************************/


FIND FIRST ponto-programa NO-LOCK
    WHERE  ponto-programa.nome-programa = "escrm004":U
    AND    ponto-programa.ponto         = 1 NO-ERROR.
IF  AVAIL  ponto-programa THEN DO:
    FOR EACH  conteudo-programa NO-LOCK
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


FIND FIRST unid-comerc NO-LOCK
    WHERE  unid-comerc.ds-unid-comerc = p-ds-unid-comerc NO-ERROR.
IF  NOT AVAIL unid-comerc THEN DO:
    /******************** Log de Execuá∆o da API *********************/
    IF  l-log THEN DO:
        IF  OPSYS = "WIN32":U THEN DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        ELSE DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        PUT UNFORMATTED "N∆o encontrou a Unidade Comercial (" + STRING(p-ds-unid-comerc) + ")!" SKIP.
        OUTPUT CLOSE.
    END.
    /*****************************************************************/
    RETURN "NOK":U.
END.

ASSIGN i-cd-unid-comerc = unid-comerc.cd-unid-comerc.


FOR FIRST para-fat FIELDS (dec-calc-int-p arre-calc-int-p) NO-LOCK: END.

ASSIGN i-round = para-fat.dec-calc-int-p
       i-arred = para-fat.arre-calc-int-p.


IF  NOT VALID-HANDLE(h-boes505) THEN
    RUN esbo/boes505.p PERSISTENT SET h-boes505.

IF  NOT VALID-HANDLE(h-bodi317im1br) THEN
    RUN dibo/bodi317im1br.p PERSISTENT SET h-bodi317im1br.


IF  p-cod-cliente = 0 THEN DO:
    ASSIGN l-tb-especifica = NO.

    ASSIGN i-cod-gr-cli = p-cod-gr-cli.

    FOR EACH  crm-un-tb-preco NO-LOCK
        WHERE crm-un-tb-preco.cd-unid-negoc    = STRING(i-cd-unid-comerc)
        AND   crm-un-tb-preco.dt-vigencia-ini <= TODAY
        AND  (IF crm-un-tb-preco.dt-vigencia-fim <> ? THEN crm-un-tb-preco.dt-vigencia-fim > TODAY ELSE YES):

        IF  NOT CAN-FIND(FIRST tt-tb-preco NO-LOCK
                         WHERE tt-tb-preco.nr-tabpre = crm-un-tb-preco.nr-tabpre) THEN DO:
            FIND FIRST tb-preco NO-LOCK
                WHERE  tb-preco.nr-tabpre = crm-un-tb-preco.nr-tabpre NO-ERROR.

            FOR EACH  preco-item NO-LOCK
                WHERE preco-item.nr-tabpre  = tb-preco.nr-tabpre
                AND   preco-item.dt-inival <= TODAY
                AND   preco-item.situacao   = 1 /* Ativo */
                BREAK BY preco-item.it-codigo
                      BY preco-item.dt-inival DESC:


                /******************** Log de Execuá∆o da API *********************/
                IF  l-log THEN DO:
                    IF  OPSYS = "WIN32":U THEN DO:
                        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
                    END.
                    ELSE DO:
                        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
                    END.
                    PUT UNFORMATTED "Tabela de Preáo por Unidade de Neg¢cio (genÇrica): " + STRING(crm-un-tb-preco.nr-tabpre) SKIP.
                    OUTPUT CLOSE.
                END.
                /*****************************************************************/

                RUN pi-busca-preco-item IN THIS-PROCEDURE.
            END.
            
            CREATE tt-tb-preco.
            ASSIGN tt-tb-preco.nr-tabpre     = crm-un-tb-preco.nr-tabpre
                   tt-tb-preco.ds-descricao  = tb-preco.descricao
                   tt-tb-preco.cd-categoria  = p-cd-categoria
                   tt-tb-preco.cd-unid-negoc = unid-comerc.ds-unid-comerc.
        END.
    END.
END.
ELSE DO:
    /* Busca todas as Tabelas do Cliente, e n∆o d† desconto no preáo */
    ASSIGN l-tb-especifica = YES.

    FIND FIRST emitente NO-LOCK
        WHERE  emitente.cod-emitente = p-cod-cliente NO-ERROR.
    IF  NOT AVAIL emitente THEN DO:
        /******************** Log de Execuá∆o da API *********************/
        IF  l-log THEN DO:
            IF  OPSYS = "WIN32":U THEN DO:
                OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
            END.
            ELSE DO:
                OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
            END.
            PUT UNFORMATTED "N∆o encontrou o Cliente (" + STRING(p-cod-cliente) + ")!" SKIP.
            OUTPUT CLOSE.
        END.
        /*****************************************************************/
        RETURN "NOK":U.
    END.

    ASSIGN i-cod-gr-cli = emitente.cod-gr-cli.

    FOR EACH  crm-un-cli-tb-preco NO-LOCK
        WHERE crm-un-cli-tb-preco.cd-unid-negoc    = STRING(i-cd-unid-comerc)
        AND   crm-un-cli-tb-preco.cod-emitente     = p-cod-cliente
        AND   crm-un-cli-tb-preco.dt-vigencia-ini <= TODAY
        AND  (IF crm-un-cli-tb-preco.dt-vigencia-fim <> ? THEN crm-un-cli-tb-preco.dt-vigencia-fim > TODAY ELSE YES):

        FIND FIRST tt-tb-preco NO-LOCK
            WHERE  tt-tb-preco.nr-tabpre = crm-un-cli-tb-preco.nr-tabpre NO-ERROR.
        IF  NOT AVAIL tt-tb-preco THEN DO:
            FIND FIRST tb-preco NO-LOCK
                WHERE  tb-preco.nr-tabpre = crm-un-cli-tb-preco.nr-tabpre NO-ERROR.

            FOR EACH  preco-item NO-LOCK
                WHERE preco-item.nr-tabpre  = tb-preco.nr-tabpre
                AND   preco-item.dt-inival <= TODAY
                AND   preco-item.situacao   = 1 /* Ativo */
                BREAK BY preco-item.it-codigo
                      BY preco-item.dt-inival DESC:

                /******************** Log de Execuá∆o da API *********************/
                IF  l-log THEN DO:
                    IF  OPSYS = "WIN32":U THEN DO:
                        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
                    END.
                    ELSE DO:
                        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
                    END.
                    PUT UNFORMATTED "Tabela de Preáo por Cliente (espec°fica): " + STRING(crm-un-cli-tb-preco.nr-tabpre) + " - " + tb-preco.descricao SKIP.
                    OUTPUT CLOSE.
                END.
                /*****************************************************************/

                RUN pi-busca-preco-item IN THIS-PROCEDURE.
            END.

            CREATE tt-tb-preco.
            ASSIGN tt-tb-preco.nr-tabpre     = crm-un-cli-tb-preco.nr-tabpre
                   tt-tb-preco.ds-descricao  = tb-preco.descricao
                   tt-tb-preco.cd-categoria  = p-cd-categoria
                   tt-tb-preco.cd-unid-negoc = unid-comerc.ds-unid-comerc.
        END.
    END.


    /* Todas as Tabelas de Unidade Comercial do Cliente, e d† desconto no preáo */
    ASSIGN l-tb-especifica = NO.

    FOR EACH  crm-un-tb-preco NO-LOCK
        WHERE crm-un-tb-preco.cd-unid-negoc    = STRING(i-cd-unid-comerc)
        AND   crm-un-tb-preco.dt-vigencia-ini <= TODAY
        AND  (IF crm-un-tb-preco.dt-vigencia-fim <> ? THEN crm-un-tb-preco.dt-vigencia-fim > TODAY ELSE YES):

        IF  NOT CAN-FIND(FIRST tt-tb-preco NO-LOCK
                         WHERE tt-tb-preco.nr-tabpre = crm-un-tb-preco.nr-tabpre) THEN DO:
            FIND FIRST tb-preco NO-LOCK
                WHERE  tb-preco.nr-tabpre = crm-un-tb-preco.nr-tabpre NO-ERROR.

            FOR EACH  preco-item NO-LOCK
                WHERE preco-item.nr-tabpre  = tb-preco.nr-tabpre
                AND   preco-item.dt-inival <= TODAY
                AND   preco-item.situacao   = 1 /* Ativo */
                BREAK BY preco-item.it-codigo
                      BY preco-item.dt-inival DESC:


                /******************** Log de Execuá∆o da API *********************/
                IF  l-log THEN DO:
                    IF  OPSYS = "WIN32":U THEN DO:
                        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
                    END.
                    ELSE DO:
                        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
                    END.
                    PUT UNFORMATTED "Tabela de Preáo por Unidade de Neg¢cio (genÇrica): " + STRING(crm-un-tb-preco.nr-tabpre) SKIP.
                    OUTPUT CLOSE.
                END.
                /*****************************************************************/

                RUN pi-busca-preco-item IN THIS-PROCEDURE.
            END.

            CREATE tt-tb-preco.
            ASSIGN tt-tb-preco.nr-tabpre     = crm-un-tb-preco.nr-tabpre
                   tt-tb-preco.ds-descricao  = tb-preco.descricao
                   tt-tb-preco.cd-categoria  = p-cd-categoria
                   tt-tb-preco.cd-unid-negoc = unid-comerc.ds-unid-comerc.
        END.
    END.
END.


IF  VALID-HANDLE(h-boes505) THEN
    RUN destroy IN h-boes505.

IF  VALID-HANDLE(h-boes505) THEN
    DELETE PROCEDURE h-boes505.

IF  VALID-HANDLE(h-bodi317im1br) THEN
    RUN destroy IN h-bodi317im1br.

IF  VALID-HANDLE(h-bodi317im1br) THEN
    DELETE PROCEDURE h-bodi317im1br.

/******************** Log de Execuá∆o da API *********************/
IF  l-log THEN DO:
    IF  OPSYS = "WIN32":U THEN DO:
        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
    END.
    ELSE DO:
        OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
    END.
    PUT UNFORMATTED "--------------------------------------------------------------------------------" SKIP(2).
    OUTPUT CLOSE.
END.
/*****************************************************************/


DELETE WIDGET-POOL.
RETURN "OK":U.




/*--- Procedure Internas ---*/
PROCEDURE pi-busca-preco-item:
    FIND FIRST item NO-LOCK
        WHERE  item.it-codigo = preco-item.it-codigo NO-ERROR.
    IF  NOT AVAIL item THEN
        RETURN "NOK":U.

    FOR FIRST estabelec FIELDS (cod-estabel pais estado)
        WHERE estabelec.cod-estabel = p-cod-estabel-orig NO-LOCK USE-INDEX codigo: END.

    IF  VALID-HANDLE(h-boes505) THEN DO:

        RUN defineNatOperacaoSemEmitente IN h-boes505 (INPUT  estabelec.cod-estabel,
                                                       INPUT  p-estado-dest,
                                                       INPUT  item.it-codigo,
                                                       INPUT  NO,
                                                       OUTPUT c-nat-oper,
                                                       OUTPUT l-return).

        IF  l-return = NO THEN DO:
            /******************** Log de Execuá∆o da API *********************/
            IF  l-log THEN DO:
                IF  OPSYS = "WIN32":U THEN DO:
                    OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
                END.
                ELSE DO:
                    OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
                END.
                PUT UNFORMATTED "Erro na busca da Natureza de Operaá∆o! ParÉmentros de Busca:" SKIP
                                " - Estabelecimento: " p-cod-estabel-orig SKIP
                                " - Estado: " p-estado-dest SKIP
                                " - Item: " item.it-codigo SKIP.
                OUTPUT CLOSE.
            END.
            /*****************************************************************/
            RETURN "NOK":U.
        END.
    END.


    IF  VALID-HANDLE(h-bodi317im1br) THEN DO:
        ASSIGN g-cod-emitente-bodi317im1br = IF AVAIL emitente THEN emitente.cod-emitente ELSE 0.
        ASSIGN g-codigo-orig-bodi317sd     = IF AVAIL ITEM THEN ITEM.codigo-orig ELSE 0. 
        RUN calculaAliquotaICMS IN h-bodi317im1br(INPUT  YES,
                                                  INPUT  2 /* Pessoal Jur°dica */,
                                                  INPUT  estabelec.estado,
                                                  INPUT  estabelec.pais,
                                                  INPUT  p-estado-dest,
                                                  INPUT  item.it-codigo,
                                                  INPUT  c-nat-oper,
                                                  OUTPUT de-perc-icms,
                                                  OUTPUT l-return).
        ASSIGN g-cod-emitente-bodi317im1br = 0.
        ASSIGN g-codigo-orig-bodi317sd     = 0.

        IF  l-return = NO THEN DO:
            /******************** Log de Execuá∆o da API *********************/
            IF  l-log THEN DO:
                IF  OPSYS = "WIN32":U THEN DO:
                    OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
                END.
                ELSE DO:
                    OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
                END.
                PUT UNFORMATTED "Erro na busca do ICMS! ParÉmentros de Busca:" SKIP
                                " - Emitente Contribuinte: " + STRING(emitente.contrib-icms) SKIP
                                " - Emitente Natureza: " + STRING(emitente.natureza) SKIP
                                " - Estabel Estado: " estabelec.estado SKIP
                                " - Estabel Pa°s: " estabelec.pais SKIP
                                " - Estado de Entrega: " p-estado-dest SKIP
                                " - Item: " item.it-codigo SKIP
                                " - Natureza: " c-nat-oper SKIP.
                OUTPUT CLOSE.
            END.
            /*****************************************************************/
            RETURN "NOK":U.
        END.
    END.

    IF  de-perc-icms <> 0 THEN
        ASSIGN de-preco = preco-item.preco-venda / ((100 - de-perc-icms) / 100) .
    ELSE
        ASSIGN de-preco = preco-item.preco-venda.

    FIND FIRST natur-oper NO-LOCK
        WHERE  natur-oper.nat-operacao = c-nat-oper NO-ERROR.
    IF  NOT AVAIL natur-oper THEN DO:
        /******************** Log de Execuá∆o da API *********************/
        IF  l-log THEN DO:
            IF  OPSYS = "WIN32":U THEN DO:
                OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
            END.
            ELSE DO:
                OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
            END.
            PUT UNFORMATTED "Natureza de Operaá∆o (" + c-nat-oper + ") n∆o encontrada!" SKIP.
            OUTPUT CLOSE.
        END.
        /*****************************************************************/
    END.

    IF  p-estado-dest <> estabelec.estado THEN DO:
        FOR FIRST unid-feder FIELDS(est-exc perc-exc desc-icms)
            WHERE unid-feder.pais   = estabelec.pais
            AND   unid-feder.estado = estabelec.estado NO-LOCK:

            ASSIGN de-per-des-icms = 0.

            DO  i-cont = 1 TO 12:
                IF  unid-feder.est-exc[i-cont] = p-estado-dest THEN DO:
                    ASSIGN de-per-des-icms = unid-feder.perc-exc[i-cont + 13].
                    LEAVE.
                END.
            END.

            ASSIGN de-per-des-icms = IF  de-per-des-icms <> 0 THEN
                                         de-per-des-icms
                                     ELSE 
                                         IF  unid-feder.desc-icms <> 0 THEN
                                             unid-feder.desc-icms ELSE
                                             natur-oper.per-des-icms.
        END.
    END.
    ELSE 
        ASSIGN de-per-des-icms = natur-oper.per-des-icms.

    /******************** Log de Execuá∆o da API *********************/
    IF  l-log THEN DO:
        IF  OPSYS = "WIN32":U THEN DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        ELSE DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        PUT UNFORMATTED "Percentual desconto ICMS = " de-per-des-icms SKIP.
        OUTPUT CLOSE.
    END.
    /*****************************************************************/

    ASSIGN de-preco = IF  i-arred = 1 
                          THEN TRUNCATE(de-preco * (1 - (de-per-des-icms / 100)), i-round)
                          ELSE ROUND(de-preco * (1 - (de-per-des-icms / 100)), i-round).

    /******************** Log de Execuá∆o da API *********************/
    IF  l-log THEN DO:
        IF  OPSYS = "WIN32":U THEN DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        ELSE DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        PUT UNFORMATTED "Preco com Desconto ICMS = "  de-preco  SKIP.
        OUTPUT CLOSE.
    END.
    /*****************************************************************/


    /* S¢ busca os descontos quando n∆o encontra a tabela de preáo para o Cliente.
       Quando a tabela for espec°fica para o cliente, o preáo ser† o que est† na Tabela de Preáo */
    IF  NOT l-tb-especifica THEN DO:
        /* Busca o % de Desconto com base na UN, Grp Cliente e Categoria */
        FIND FIRST crm-desc-gc-cat NO-LOCK
            WHERE  crm-desc-gc-cat.cd-unid-negoc    = STRING(i-cd-unid-comerc)
            AND    crm-desc-gc-cat.cod-gr-cli       = i-cod-gr-cli
            AND    crm-desc-gc-cat.cd-categoria     = p-cd-categoria
            AND    crm-desc-gc-cat.dt-vigencia-ini <= TODAY
            AND   (IF crm-desc-gc-cat.dt-vigencia-fim <> ? THEN crm-desc-gc-cat.dt-vigencia-fim >= TODAY ELSE YES) NO-ERROR.
        /******************** Log de Execuá∆o da API *********************/
        IF  l-log THEN DO:
            IF  OPSYS = "WIN32":U THEN DO:
                OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
            END.
            ELSE DO:
                OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
            END.
            PUT UNFORMATTED "Encontrou Desconto para o Grupo de Cliente e Categoria (crm-desc-gc-cat): " AVAIL crm-desc-gc-cat SKIP
                            " - Unidade Comercial: " i-cd-unid-comerc SKIP
                            " - Grupo Cliente: " i-cod-gr-cli SKIP
                            " - Categoria: " p-cd-categoria SKIP.
            OUTPUT CLOSE.
        END.
        /*****************************************************************/

        IF  AVAIL  crm-desc-gc-cat THEN DO:
            ASSIGN de-preco = (de-preco) * (1 - (crm-desc-gc-cat.pc-desconto / 100)).

            /******************** Log de Execuá∆o da API *********************/
            IF  l-log THEN DO:
                IF  OPSYS = "WIN32":U THEN DO:
                    OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
                END.
                ELSE DO:
                    OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
                END.
                PUT UNFORMATTED "Desconto (crm-desc-gc-cat): " + STRING(crm-desc-gc-cat.pc-desconto) + " %" SKIP
                                "Preáo com Desconto: " + STRING(de-preco) SKIP.
                OUTPUT CLOSE.
            END.
            /*****************************************************************/
        END.

        /* Acumula, caso tiver, o % de Desconto para a UN, Grp Cliente, Categoria e Item */
        FIND FIRST crm-desc-prod NO-LOCK
            WHERE  crm-desc-prod.cd-unid-negoc    = STRING(i-cd-unid-comerc)
            AND    crm-desc-prod.cod-gr-cli       = i-cod-gr-cli
            AND    crm-desc-prod.cd-categoria     = p-cd-categoria
            AND    crm-desc-prod.it-codigo        = item.it-codigo
            AND    crm-desc-prod.dt-vigencia-ini <= TODAY
            AND   (IF crm-desc-prod.dt-vigencia-fim <> ? THEN crm-desc-prod.dt-vigencia-fim >= TODAY ELSE YES) NO-ERROR.
        /******************** Log de Execuá∆o da API *********************/
        IF  l-log THEN DO:
            IF  OPSYS = "WIN32":U THEN DO:
                OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
            END.
            ELSE DO:
                OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
            END.
            PUT UNFORMATTED "Encontrou Desconto para o Produto, Grp Cliente e Categoria (crm-desc-prod): " AVAIL crm-desc-prod SKIP
                            " - Unidade Comercial: " i-cd-unid-comerc SKIP
                            " - Grupo Cliente: " i-cod-gr-cli SKIP
                            " - Categoria: " p-cd-categoria SKIP
                            " - Item: " item.it-codigo SKIP.
            OUTPUT CLOSE.
        END.
        /*****************************************************************/

        IF  AVAIL  crm-desc-prod THEN DO:
            ASSIGN de-preco = (de-preco) * (1 - (crm-desc-prod.pc-desconto / 100)).

            /******************** Log de Execuá∆o da API *********************/
            IF  l-log THEN DO:
                IF  OPSYS = "WIN32":U THEN DO:
                    OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
                END.
                ELSE DO:
                    OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
                END.
                PUT UNFORMATTED "Desconto (crm-desc-prod): " + STRING(crm-desc-prod.pc-desconto) + " %" SKIP
                                "Preáo com Desconto: " + STRING(de-preco) SKIP.
                OUTPUT CLOSE.
            END.
            /*****************************************************************/
        END.
    END.

    ASSIGN de-preco-com-ipi = de-preco.

    /* Verificar validaá∆o do IPI */
    IF  natur-oper.cd-trib-ipi <> 2 /* Isento */ THEN
        ASSIGN de-preco-com-ipi = (de-preco-com-ipi) * (1 + (item.aliquota-ipi / 100)).


    FIND FIRST fam-comerc NO-LOCK
        WHERE  fam-comerc.fm-cod-com = item.fm-cod-com NO-ERROR.

    FIND FIRST int-preco-item NO-LOCK
        WHERE  int-preco-item.it-codigo = preco-item.it-codigo
        AND    int-preco-item.cod-refer = preco-item.cod-refer
        AND    int-preco-item.nr-tabpre = preco-item.nr-tabpre
        AND    int-preco-item.dt-inival = preco-item.dt-inival
        AND    int-preco-item.quant-min = preco-item.quant-min NO-ERROR.

    FOR EACH item-layout-tabpreco
       WHERE item-layout-tabpreco.it-codigo = preco-item.it-codigo NO-LOCK:

        FIND FIRST layout-tabpreco WHERE
            layout-tabpreco.lay-codigo = item-layout-tabpreco.lay-codigo NO-LOCK NO-ERROR.

        /* Cria a tabela de retorno */
        CREATE tt-preco-item.
        ASSIGN tt-preco-item.it-codigo        = preco-item.it-codigo
               tt-preco-item.desc-item        = item.desc-item
               tt-preco-item.fm-cod-com       = item.fm-cod-com
               tt-preco-item.ds-fm-cod-com    = IF AVAIL fam-comerc     THEN fam-comerc.descricao ELSE ""
               tt-preco-item.vl-preco-pma     = IF AVAIL int-preco-item THEN int-preco-item.pma   ELSE 0
               tt-preco-item.vl-preco-pmd     = IF AVAIL int-preco-item THEN int-preco-item.pmd   ELSE 0
               tt-preco-item.vl-preco-sem-ipi = de-preco
               tt-preco-item.vl-preco-com-ipi = de-preco-com-ipi
               tt-preco-item.lay-nome         = IF AVAIL layout-tabpreco THEN layout-tabpreco.lay-nome ELSE "".
    END.

    /******************** Log de Execuá∆o da API *********************/
    IF  l-log THEN DO:
        IF  OPSYS = "WIN32":U THEN DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        ELSE DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        PUT UNFORMATTED "Informaá‰es que ser∆o retornadas:" SKIP
                        " - Item: " preco-item.it-codigo + " - " + item.desc-item SKIP
                        " - Preáo PMA: " tt-preco-item.vl-preco-pma SKIP
                        " - Preáo PMD: " tt-preco-item.vl-preco-pmd SKIP
                        " - Preáo sem IPI: " tt-preco-item.vl-preco-sem-ipi SKIP
                        " - Preáo com IPI: " tt-preco-item.vl-preco-com-ipi SKIP.
        OUTPUT CLOSE.
    END.
    /*****************************************************************/

    RETURN "OK":U.
END PROCEDURE.
