/*********************************************************************************
** Programa: esp/crm/escrm007.p
** Vers∆o..: 1.00
** Data....: 29/09/2010
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: API para calcular o Valor do Produto, com os poss°veis descontos do 
**           cliente, e retornar ao Portal B2B
*********************************************************************************/


CREATE WIDGET-POOL.
DEFINE TEMP-TABLE tt-preco-item UNDO
    FIELD it-codigo     LIKE preco-item.it-codigo
    FIELD desc-item     LIKE ITEM.desc-item
    FIELD fm-cod-com    LIKE ITEM.fm-cod-com
    FIELD desc-familia  LIKE fam-comerc.descricao
    FIELD preco         AS DECIMAL
    FIELD vl-ipi        AS DECIMAL
    FIELD quant-min     AS DECIMAL.

DEFINE TEMP-TABLE tt-erros NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".



/*--- Definiá∆o dos ParÉmetros ---*/
DEFINE INPUT  PARAMETER p-cod-estabel      AS CHARACTER                            NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-cliente      AS INTEGER   FORMAT ">>>>>>>>9"         NO-UNDO.
DEFINE INPUT  PARAMETER p-ds-unid-comerc   AS CHARACTER FORMAT "x(3)"              NO-UNDO.
DEFINE INPUT  PARAMETER p-cd-categoria     AS INTEGER   FORMAT ">>9"               NO-UNDO.
DEFINE INPUT  PARAMETER p-it-codigo        AS CHARACTER FORMAT "x(16)"             NO-UNDO.
DEFINE INPUT  PARAMETER p-nr-tabpre        LIKE tb-preco.nr-tabpre                 NO-UNDO.
DEFINE INPUT  PARAMETER p-lg-tb-especifica AS INTEGER                              NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-preco-item.
DEFINE OUTPUT PARAMETER TABLE FOR tt-erros.
DEF NEW GLOBAL SHARED VARIABLE g-cod-emitente-bodi317im1br AS INTEGER.

DEF NEW GLOBAL SHARED VARIABLE g-codigo-orig-bodi317sd AS INTEGER.


/*--- Definiá∆o das Vari†veis ---*/
DEFINE VARIABLE i-cd-unid-comerc   AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-nat-oper         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-usuario          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-senha            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cod-gr-cli       AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-round            AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-arred            AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cont             AS INTEGER     NO-UNDO.
DEFINE VARIABLE de-desconto        AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-preco           AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-valor           AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-aliquota-ipi    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-perc-icms       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-perc-iss        AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-descto-zf       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-desc-pis-zfm    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-desc-cofins-zfm AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-per-des-icms    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE h-boes505          AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bodi317im1br     AS HANDLE      NO-UNDO.
DEFINE VARIABLE l-return           AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-log              AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-consumidor-final AS LOGICAL     NO-UNDO.
DEFINE BUFFER b-unid-feder FOR unid-feder.



EMPTY TEMP-TABLE tt-erros.
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
                    "Inicio API BuscarPreco -- " + STRING(TODAY, "99/99/9999") + " - " + STRING(TIME, "HH:MM:SS") SKIP.
    PUT UNFORMATTED "Parametros Recebidos:" SKIP
                    " - Estabelecimento.: " p-cod-estabel SKIP
                    " - C¢d Cliente.: " p-cod-cliente SKIP
                    " - Unid Neg¢cio.: " p-ds-unid-comerc SKIP
                    " - C¢d Categoria.: " p-cd-categoria SKIP
                    " - C¢d Item.: " p-it-codigo SKIP
                    " - Nr Tab Preáo.: " p-nr-tabpre SKIP
                    " - Tab Espec°fica.: " + STRING(p-lg-tb-especifica) + " - " + IF p-lg-tb-especifica = 0 THEN "GenÇrica" ELSE "Espec°fica" SKIP.
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


/* Valida as informaá‰es recebidas como parÉmetro */
IF  NOT CAN-FIND(FIRST crm-categoria NO-LOCK
                 WHERE crm-categoria.cd-categoria = p-cd-categoria) THEN DO:
    CREATE tt-erros.
    ASSIGN tt-erros.mensagem = "Categoria n∆o encontrada!".

    /******************** Log de Execuá∆o da API *********************/
    IF  l-log THEN DO:
        IF  OPSYS = "WIN32":U THEN DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        ELSE DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        PUT UNFORMATTED "N∆o encontrou a Categoria (" + STRING(p-cd-categoria) + ")!" SKIP.
        OUTPUT CLOSE.
    END.
    /*****************************************************************/
    RETURN "NOK":U.
END.

FIND FIRST emitente NO-LOCK
    WHERE  emitente.cod-emitente = p-cod-cliente NO-ERROR.
IF  NOT AVAIL emitente THEN DO:
    CREATE tt-erros.
    ASSIGN tt-erros.mensagem = "Cliente n∆o encontrado!".

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

IF  NOT CAN-FIND(FIRST gr-cli NO-LOCK
                 WHERE gr-cli.cod-gr-cli = emitente.cod-gr-cli) THEN DO:
    CREATE tt-erros.
    ASSIGN tt-erros.mensagem = "Grupo de Cliente n∆o encontrado!".

    /******************** Log de Execuá∆o da API *********************/
    IF  l-log THEN DO:
        IF  OPSYS = "WIN32":U THEN DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        ELSE DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        PUT UNFORMATTED "N∆o encontrou o Grupo de Cliente (" + STRING(emitente.cod-gr-cli) + ")!" SKIP.
        OUTPUT CLOSE.
    END.
    /*****************************************************************/
    RETURN "NOK":U.
END.

ASSIGN i-cod-gr-cli = emitente.cod-gr-cli.

FOR FIRST loc-entr NO-LOCK
    WHERE loc-entr.nome-abrev  = emitente.nome-abrev
      AND loc-entr.cod-entrega = "Padrao": END.


FIND FIRST unid-comerc NO-LOCK
    WHERE  unid-comerc.ds-unid-comerc = p-ds-unid-comerc NO-ERROR.
IF  NOT AVAIL unid-comerc THEN DO:
    CREATE tt-erros.
    ASSIGN tt-erros.mensagem = "Unidade Comercial n∆o encontrada!".

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


/* Valida entrega da Declaraá∆o de Forma de Tributaá∆o, para Manuas */
IF  p-cod-estabel = "105" AND emitente.natureza = 2 /* Pessoa Jur°dica */ THEN DO:
    FIND FIRST int-emitente-trib NO-LOCK
        WHERE  int-emitente-trib.raiz-cnpj = SUBSTRING(emitente.cgc,1,8) NO-ERROR.
    IF  NOT AVAIL int-emitente-trib OR
        NOT int-emitente-trib.ind-declaracao THEN DO:
        CREATE tt-erros.
        ASSIGN tt-erros.mensagem = "Cliente n∆o fez a entrega da Declaraá∆o de Forma de Tributaá∆o!".
    
        /******************** Log de Execuá∆o da API *********************/
        IF  l-log THEN DO:
            IF  OPSYS = "WIN32":U THEN DO:
                OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "/log-apis-crm.txt") NO-CONVERT APPEND.
            END.
            ELSE DO:
                OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "/log-apis-crm.txt") NO-CONVERT APPEND.
            END.
            PUT UNFORMATTED "Cliente n∆o fez a entrega da Declaraá∆o de Forma de Tributaá∆o!" SKIP.
            OUTPUT CLOSE.
        END.
        /*****************************************************************/
        RETURN "NOK":U.
    END.
END.
/* Fim - Validaá∆o Declaraá∆o Forma de Tributaá∆o */


FOR FIRST para-fat FIELDS (dec-calc-int-p dec-calc-int-f arre-calc-int-p arre-calc-int-f) NO-LOCK: END.

ASSIGN i-round = para-fat.dec-calc-int-p
       i-arred = para-fat.arre-calc-int-p.
                         



/* Busca o Preáo do Item na Tabela de Preáo */
IF  NOT CAN-FIND(FIRST tb-preco NO-LOCK
                 WHERE tb-preco.nr-tabpre = p-nr-tabpre) THEN DO:
    CREATE tt-erros.
    ASSIGN tt-erros.mensagem = "Tabela de Preáo n∆o encontrada!".

    /******************** Log de Execuá∆o da API *********************/
    IF  l-log THEN DO:
        IF  OPSYS = "WIN32":U THEN DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        ELSE DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        PUT UNFORMATTED "N∆o encontrou a Tabela de Preáo (" + STRING(p-nr-tabpre) + ")!" SKIP.
        OUTPUT CLOSE.
    END.
    /*****************************************************************/
    RETURN "NOK":U.
END.

IF  p-lg-tb-especifica = 0 THEN DO:
    FIND LAST preco-item NO-LOCK
        WHERE preco-item.it-codigo  = p-it-codigo
        AND   preco-item.cod-refer  = ""
        AND   preco-item.nr-tabpre  = p-nr-tabpre
        AND   preco-item.dt-inival <= TODAY
        AND   preco-item.situacao   = 1 /* Ativo */ NO-ERROR.
    IF  NOT AVAIL preco-item THEN DO:
        CREATE tt-erros.
        /*IF  NOT AVAIL preco-item THEN*/
            ASSIGN tt-erros.mensagem = "N∆o encontrou um Preáo para o Item (" + STRING(p-it-codigo) + "), na Tabela de Preáo(" + STRING(p-nr-tabpre) + ")!".

        /*IF  AVAIL preco-item AND preco-item.situacao = 2 /* Inativo */ THEN
            ASSIGN tt-erros.mensagem = "Item (" + STRING(p-it-codigo) + ") est† com a Situaá∆o Inativa na Tabela de Preáo(" + STRING(p-nr-tabpre) + ")!".*/

        /******************** Log de Execuá∆o da API *********************/
        IF  l-log THEN DO:
            IF  OPSYS = "WIN32":U THEN DO:
                OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
            END.
            ELSE DO:
                OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
            END.
            /*IF  NOT AVAIL preco-item THEN*/
                PUT UNFORMATTED "N∆o encontrou um Preáo para o Item (" + STRING(p-it-codigo) + "), na Tabela de Preáo(" + STRING(p-nr-tabpre) + ")!" SKIP.

            /*IF  AVAIL preco-item AND preco-item.situacao = 2 /* Inativo */ THEN
                PUT UNFORMATTED "Item (" + STRING(p-it-codigo) + ") est† com a Situaá∆o Inativa na Tabela de Preáo(" + STRING(p-nr-tabpre) + ")!" SKIP.*/

            OUTPUT CLOSE.
        END.
        /*****************************************************************/

        RETURN "NOK":U.     
    END.
    ELSE DO:
        RUN BuscarPrecoItem.
    END.
END.
ELSE DO:
    /******************** Log de Execuá∆o da API *********************/
    IF  l-log THEN DO:
        IF  OPSYS = "WIN32":U THEN DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        ELSE DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        PUT UNFORMATTED "Buscando Itens para a Tabela de Preáo (" + STRING(p-nr-tabpre) + ") Espec°fica." SKIP.
        OUTPUT CLOSE.
    END.
    /*****************************************************************/

    FOR EACH  preco-item NO-LOCK
        WHERE preco-item.nr-tabpre  = p-nr-tabpre
        AND   preco-item.dt-inival <= TODAY
        AND   preco-item.situacao   = 1
        BREAK BY preco-item.it-codigo
              BY preco-item.dt-inival DESC:
        EMPTY TEMP-TABLE tt-erros.

        IF  CAN-FIND(FIRST tt-preco-item NO-LOCK
                     WHERE tt-preco-item.it-codigo = preco-item.it-codigo) THEN
            NEXT.
    
        IF  FIRST-OF(preco-item.it-codigo) THEN DO:
            /******************** Log de Execuá∆o da API *********************/
            IF  l-log THEN DO:
                IF  OPSYS = "WIN32":U THEN DO:
                    OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
                END.
                ELSE DO:
                    OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
                END.
                PUT UNFORMATTED "Item: " + STRING(p-it-codigo) + " - " + IF preco-item.situacao = 1 THEN "Ativo" ELSE "Inativo" SKIP.
                OUTPUT CLOSE.
            END.
            /*****************************************************************/

            IF  preco-item.situacao = 1 /* Ativo */ THEN DO:
                RUN BuscarPrecoItem.
            END.
            ELSE DO:
                CREATE tt-erros.
                ASSIGN tt-erros.mensagem = "Item (" + STRING(preco-item.it-codigo) + " est† com a Situaá∆o Inativa na Tabela de Preáo(" + STRING(preco-item.nr-tabpre) + ")!".
            END.
        END.
    END.
END.


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
PROCEDURE BuscarPrecoitem:
    FIND FIRST item NO-LOCK
        WHERE  item.it-codigo = preco-item.it-codigo NO-ERROR.
    IF  NOT AVAIL item THEN
        RETURN "NOK":U.


    ASSIGN de-aliquota-ipi = item.aliquota-ipi.

    FOR FIRST estabelec FIELDS (pais estado)
        WHERE estabelec.cod-estabel = p-cod-estabel NO-LOCK USE-INDEX codigo: END.

    ASSIGN l-consumidor-final = NO.
    IF  NOT emitente.contrib-icm THEN
        ASSIGN l-consumidor-final = YES.

    RUN esbo/boes505.p PERSISTENT SET h-boes505.
    RUN defineNatOperacao IN h-boes505 (INPUT  p-cod-estabel,
                                        INPUT  emitente.cod-emitente,
                                        INPUT  "padrao",
                                        INPUT  item.it-codigo,
                                        INPUT  l-consumidor-final,
                                        OUTPUT c-nat-oper,
                                        OUTPUT l-return).
    DELETE PROCEDURE h-boes505.
    IF  l-return = NO THEN DO:
        /* Retirado para nao mostrar em tela e desconsiderar o ITEM. */
/*         CREATE tt-erros.                                                                                                     */
/*         ASSIGN tt-erros.mensagem = "Erro ao localizar a Natureza de Operaá∆o para o Item (" + STRING(item.it-codigo) + ")!". */

        /******************** Log de Execuá∆o da API *********************/
        IF  l-log THEN DO:
            IF  OPSYS = "WIN32":U THEN DO:
                OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
            END.
            ELSE DO:
                OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
            END.
            PUT UNFORMATTED "Erro na busca da Natureza de Operaá∆o! ParÉmentros de Busca:" SKIP
                            " - Estabelecimento: " p-cod-estabel SKIP
                            " - Emitente: " + STRING(emitente.cod-emitente) SKIP
                            " - Item: " item.it-codigo 
                            " - Codigo Origem " item.codigo-orig SKIP.
            OUTPUT CLOSE.
        END.
        /*****************************************************************/
        RETURN "OK":U.
    END.
        
    ASSIGN g-cod-emitente-bodi317im1br = emitente.cod-emitente.
    ASSIGN g-codigo-orig-bodi317sd     = ITEM.codigo-orig.
    RUN dibo/bodi317im1br.p PERSISTENT SET h-bodi317im1br.
    assign de-perc-icms = 0.
    IF emitente.contrib-icm = YES THEN DO:
        FOR FIRST inf-compl  /* conteudo do cd0908 */
            WHERE inf-compl.cdn-identif = 5
            AND inf-compl.cod-indice = item.it-codigo + chr(2) + estabelec.estado + CHR(2) + loc-entr.estado NO-LOCK:
            assign de-perc-icms = inf-compl.val-campo.
        END.
    END.
    IF de-perc-icms = 0 THEN DO:
        RUN calculaAliquotaICMS IN h-bodi317im1br(INPUT  emitente.contrib-icms,
                                                  INPUT  emitente.natureza,
                                                  INPUT  estabelec.estado,
                                                  INPUT  estabelec.pais,
                                                  INPUT  loc-entr.estado,
                                                  INPUT  item.it-codigo,
                                                  INPUT  c-nat-oper,
                                                  OUTPUT de-perc-icms, 
                                                  OUTPUT l-return).

        FIND natur-oper NO-LOCK
            WHERE natur-oper.nat-operacao = c-nat-oper NO-ERROR.

        IF  AVAIL natur-oper
        AND ITEM.cd-trib-icm = 4 
        AND natur-oper.cd-trib-icm = 4 
        AND de-perc-icms > 0 
        AND natur-oper.perc-red-icm > 0 THEN 
            ASSIGN de-perc-icms = de-perc-icms - (de-perc-icms * natur-oper.perc-red-icm / 100).
    END.
    ASSIGN g-cod-emitente-bodi317im1br = 0.
    ASSIGN g-codigo-orig-bodi317sd     = 0.
    DELETE PROCEDURE h-bodi317im1br.
    IF  l-return = NO THEN DO:
        CREATE tt-erros.
        ASSIGN tt-erros.mensagem = "Erro ao buscar a Aliquota de ICMS para o Item (" + STRING(item.it-codigo) + ")!".

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
                            " - Loc Entrega Estado: " loc-entr.estado SKIP
                            " - Item: " item.it-codigo SKIP
                            " - Natureza: " c-nat-oper SKIP.
            OUTPUT CLOSE.
        END.
        /*****************************************************************/
        RETURN "NOK":U.
    END.

    FIND natur-oper
         WHERE natur-oper.nat-operacao = c-nat-oper NO-LOCK NO-ERROR.

    FIND cidade-zf WHERE
         cidade-zf.cidade = loc-entr.cidade AND
         cidade-zf.estado = loc-entr.estado NO-LOCK NO-ERROR.

    IF NOT AVAIL cidade-zf THEN 
        IF (ITEM.cd-trib-icm <> 1  AND 
            ITEM.cd-trib-icm <> 4) or
           (natur-oper.cd-trib-icm <> 1 AND
            natur-oper.cd-trib-icm <> 4) THEN /* quando Ç isento */
            ASSIGN de-perc-icms = 0.

    IF  de-perc-icms <> 0 THEN
        ASSIGN de-preco = preco-item.preco-venda / ((100 - de-perc-icms) / 100) .
    ELSE
        ASSIGN de-preco = preco-item.preco-venda.


    /******************** Log de Execuá∆o da API *********************/
    IF  l-log THEN DO:
        IF  OPSYS = "WIN32":U THEN DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        ELSE DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        PUT UNFORMATTED "Buscando o Preáo para o Item: " + item.it-codigo SKIP
                        " - Natureza de Operaá∆o: " c-nat-oper SKIP
                        " - Preáo na Tabela de Preáo: " + STRING(preco-item.preco-venda) SKIP
                        " - ICMS: " + STRING(de-perc-icms) + " %" SKIP
                        " - Preáo com ICMS: " + STRING(de-preco) SKIP.
        OUTPUT CLOSE.
    END.
    /*****************************************************************/




    IF  AVAIL natur-oper THEN    
        ASSIGN de-descto-zf = DEC(SUBSTR(natur-oper.char-2,66,5)).



    ASSIGN de-desc-pis-zfm    = 0
           de-desc-cofins-zfm = 0.

    IF  AVAIL natur-oper THEN
        IF  natur-oper.log-deduz-desc-zfm-tot-nf  = YES THEN
            ASSIGN de-desc-pis-zfm    = natur-oper.val-perc-desc-pis-zfm    
                   de-desc-cofins-zfm = natur-oper.val-perc-desc-cofins-zfm.

    IF  loc-entr.estado <> estabelec.estado AND
        emitente.contrib-icms = YES THEN DO:
        FOR FIRST b-unid-feder FIELDS(est-exc perc-exc desc-icms) WHERE
                  b-unid-feder.pais   = estabelec.pais AND
                  b-unid-feder.estado = estabelec.estado NO-LOCK:

            ASSIGN de-per-des-icms = 0.

            DO  i-cont = 1 TO 12:
                IF  b-unid-feder.est-exc[i-cont] = loc-entr.estado THEN DO:
                    ASSIGN de-per-des-icms = b-unid-feder.perc-exc[i-cont + 13].
                    LEAVE.
                END.
            END.

            ASSIGN de-per-des-icms = IF  de-per-des-icms <> 0 THEN
                                         de-per-des-icms
                                     ELSE 
                                         IF  b-unid-feder.desc-icms <> 0 THEN
                                             b-unid-feder.desc-icms ELSE
                                             natur-oper.per-des-icms.
        END.
    END.
    ELSE 
        ASSIGN de-per-des-icms = natur-oper.per-des-icms.


    ASSIGN de-preco = IF  i-arred = 1 
                          THEN TRUNCATE(de-preco * (1 - (de-per-des-icms / 100)), i-round)
                          ELSE ROUND(de-preco * (1 - (de-per-des-icms / 100)), i-round).

/* RETIRADO PORQUE JA ê APLICADO NO EMS QUANDO FAZ A INTEGRAÄ«O */
/*            de-preco = IF  AVAIL cidade-zf AND AVAIL natur-oper THEN                                                               */ 
/*                           IF  i-arred = 1                                                                                         */
/*                           THEN TRUNCATE(de-preco  * (1 - ((de-descto-zf + de-desc-pis-zfm + de-desc-cofins-zfm) / 100)), i-round) */
/*                           ELSE ROUND(de-preco  * (1 - ((de-descto-zf + de-desc-pis-zfm + de-desc-cofins-zfm) / 100)), i-round)    */
/*                       ELSE de-preco.                                                                                              */


    /******************** Log de Execuá∆o da API *********************/
    IF  l-log THEN DO:
        IF  OPSYS = "WIN32":U THEN DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        ELSE DO:
            OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
        END.
        PUT UNFORMATTED " - Preáo com desconto de ICMS da natureza: " + STRING(de-preco) SKIP
                        " - Desconto ZF                           : " + STRING(de-descto-zf) SKIP
                        " - Desconto Pis                          : " + STRING(de-desc-pis-zfm) SKIP
                        " - Desconto Cofins                       : " + STRING(de-desc-cofins-zfm) SKIP.
        OUTPUT CLOSE.
    END.
    /*****************************************************************/


    /* S¢ busca os descontos quando n∆o encontra a tabela de preáo para o Cliente */
    IF  p-lg-tb-especifica = 0 THEN DO:
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


        /* Acumula, caso tiver, o % de Desconto para o Cliente, na Fam°lia Comercial */
        FIND FIRST crm-desc-cli NO-LOCK
            WHERE  crm-desc-cli.cd-unid-negoc    = STRING(i-cd-unid-comerc)
            AND    crm-desc-cli.cod-emitente     = p-cod-cliente
            AND    crm-desc-cli.it-codigo        = item.it-codigo
            AND    crm-desc-cli.dt-vigencia-ini <= TODAY
            AND   (IF crm-desc-cli.dt-vigencia-fim <> ? THEN crm-desc-cli.dt-vigencia-fim > TODAY ELSE YES) NO-ERROR.
        /******************** Log de Execuá∆o da API *********************/
        IF  l-log THEN DO:
            IF  OPSYS = "WIN32":U THEN DO:
                OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
            END.
            ELSE DO:
                OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
            END.
            PUT UNFORMATTED "Encontrou Desconto para o Cliente e Item (crm-desc-cli) ? " AVAIL crm-desc-cli SKIP
                            " - Unid Comercial: " i-cd-unid-comerc SKIP
                            " - Cliente: " p-cod-cliente SKIP
                            " - item: " item.it-codigo SKIP.
            OUTPUT CLOSE.
        END.
        /*****************************************************************/
        IF  AVAIL  crm-desc-cli THEN DO:
            ASSIGN de-preco = (de-preco) * (1 - (crm-desc-cli.pc-desconto / 100)).
            /******************** Log de Execuá∆o da API *********************/
            IF  l-log THEN DO:
                IF  OPSYS = "WIN32":U THEN DO:
                    OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
                END.
                ELSE DO:
                    OUTPUT TO value(session:temp-directory + "/log-apis-crm.txt") NO-CONVERT APPEND.
                END.
                PUT UNFORMATTED "Desconto (crm-desc-cli): " + STRING(crm-desc-cli.pc-desconto) + " %" SKIP
                                "Preáo com Desconto: " + STRING(de-preco) SKIP.
                OUTPUT CLOSE.
            END.
            /*****************************************************************/
        END.


        ASSIGN de-valor = de-preco.
    END.
    ELSE /* Quando a tabela de preáo Ç para o cliente, o valor ser† o que est† na tabela de preáo (sem descontos) */
        ASSIGN de-valor = de-preco.

    FIND FIRST fam-comerc NO-LOCK
         WHERE fam-comerc.fm-cod-com = item.fm-cod-com NO-ERROR.

    CREATE tt-preco-item.
    ASSIGN tt-preco-item.it-codigo     = preco-item.it-codigo
           tt-preco-item.desc-item     = item.desc-item
           tt-preco-item.fm-cod-com    = item.fm-cod-com
           tt-preco-item.desc-familia  = IF AVAIL fam-comerc THEN fam-comerc.descricao ELSE ""
           tt-preco-item.preco         = de-valor
           tt-preco-item.vl-ipi        = de-aliquota-ipi
           tt-preco-item.quant-min     = preco-item.quant-min.


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
                        " - Fam Comercial: " + STRING(item.fm-cod-com) + " - " + IF AVAIL fam-comerc THEN fam-comerc.descricao ELSE "" SKIP
                        " - IPI: " + STRING(de-aliquota-ipi) + " %" SKIP
                        " - Preáo Final do Item: " + STRING(de-valor) SKIP
                        " - Quantidade Minima : " tt-preco-item.quant-min SKIP.
        OUTPUT CLOSE.
    END.
    /*****************************************************************/

    RETURN "OK":U.
END PROCEDURE.

