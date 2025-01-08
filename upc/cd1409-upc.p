/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/*:T*******************************************************************************
**
**  Programa.: upc/cd1409-upc.p
**  Objetivo.: Espec¡fico do programa Atendimento Requisi‡Æo Material - CD1409
**  Cria‡Æo..: 20/05/2010
**  VersÆo...: 00001 - 20/05/2010 - Enviar E-mail com a solicita‡Æo para o
**             solicitante quando clicar em "Atende". - Fabiano Sakae Ribeiro 
**             (SQL Works).
**
*******************************************************************************/
DEFINE INPUT PARAMETER p-ind-event  AS CHARACTER       NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object AS CHARACTER       NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object AS HANDLE          NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame  AS WIDGET-HANDLE   NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table  AS CHARACTER       NO-UNDO.
DEFINE INPUT PARAMETER p-row-table  AS ROWID           NO-UNDO.

DEFINE VARIABLE c-objeto AS CHARACTER   NO-UNDO.

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "/":U), p-wgh-object:PRIVATE-DATA, "/":U).

{cep/ceapi001k.i} /* Defini‡Æo da Temp-Table ttr-movto */
{cdp/cd9590.i}
{upc/btb910za-upc.i}
{esp/eslib.i} /* enviaEmail */
{esp/es0018.i}

DEFINE VARIABLE c-email     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-mensagem  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-desc-item AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-desc-dep  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-ret-almox AS LOGICAL     NO-UNDO.

DEFINE NEW GLOBAL SHARED TEMP-TABLE tt-movto-cd1409-upc NO-UNDO LIKE tt-movto.

DEFINE VARIABLE h-buffer-tt-movto  AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-query-tt-movto   AS HANDLE      NO-UNDO.

DEFINE VARIABLE h-campo-cod-depos  AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-campo-dt-trans   AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-campo-it-codigo  AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-campo-nro-docto  AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-campo-num-sequen AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-campo-quantidade AS HANDLE      NO-UNDO.

/* Exibir mensagens com os eventos da UPC */
/* MESSAGE "Evento: ":U      p-ind-event  SKIP     */
/*         "Objeto: ":U      p-ind-object SKIP     */
/*         "Nome Objeto: ":U c-objeto     SKIP     */
/*         "Frame: ":U       p-wgh-frame  SKIP     */
/*         "Tabela: ":U      p-cod-table  SKIP     */
/*         "Rowid: ":U       STRING(p-row-table)   */
/*     VIEW-AS ALERT-BOX TITLE "Eventos da UPC":U. */

/* Imprimir arquivo texto com os eventos da UPC */
/* OUTPUT TO VALUE("C:/temp/eventos-cc0504e.txt":U) APPEND CONVERT TARGET SESSION:CHARSET. */
/* PUT UNFORMATTED                                                                         */
/*     "Evento.......: ":U p-ind-event         SKIP                                        */
/*     "Objeto.......: ":U p-ind-object        SKIP                                        */
/*     "Nome Objeto..: ":U c-objeto            SKIP                                        */
/*     "Frame........: ":U p-wgh-frame         SKIP                                        */
/*     "Tabela.......: ":U p-cod-table         SKIP                                        */
/*     "Rowid........: ":U STRING(p-row-table) SKIP                                        */
/*     FILL("-":U, 50)                         SKIP.                                       */
/* OUTPUT CLOSE.                                                                           */

IF p-ind-event  = "CREATE-MOVTO-ESTOQ":U AND
   p-ind-object = "tt-movto":U           AND
   c-objeto     = "b06in385.w":U         THEN DO:

    FOR EACH tt-movto-cd1409-upc:
        DELETE tt-movto-cd1409-upc.
    END.

    ASSIGN h-buffer-tt-movto = WIDGET-HANDLE(p-cod-table).

    CREATE QUERY h-query-tt-movto.
    h-query-tt-movto:SET-BUFFERS(h-buffer-tt-movto).
    h-query-tt-movto:QUERY-PREPARE("for each tt-movto":U).
    h-query-tt-movto:QUERY-OPEN.
    h-query-tt-movto:GET-FIRST(NO-LOCK).

    h-campo-cod-depos  = h-buffer-tt-movto:BUFFER-FIELD("cod-depos":U).
    h-campo-dt-trans   = h-buffer-tt-movto:BUFFER-FIELD("dt-trans":U).
    h-campo-it-codigo  = h-buffer-tt-movto:BUFFER-FIELD("it-codigo":U).
    h-campo-nro-docto  = h-buffer-tt-movto:BUFFER-FIELD("nro-docto":U).
    h-campo-num-sequen = h-buffer-tt-movto:BUFFER-FIELD("num-sequen":U).
    h-campo-quantidade = h-buffer-tt-movto:BUFFER-FIELD("quantidade":U).    

    REPEAT:
        CREATE tt-movto-cd1409-upc.
        ASSIGN tt-movto-cd1409-upc.cod-depos  = h-campo-cod-depos:BUFFER-VALUE
               tt-movto-cd1409-upc.dt-trans   = h-campo-dt-trans:BUFFER-VALUE
               tt-movto-cd1409-upc.it-codigo  = h-campo-it-codigo:BUFFER-VALUE
               tt-movto-cd1409-upc.nro-docto  = h-campo-nro-docto:BUFFER-VALUE
               tt-movto-cd1409-upc.num-sequen = h-campo-num-sequen:BUFFER-VALUE
               tt-movto-cd1409-upc.quantidade = h-campo-quantidade:BUFFER-VALUE.

        h-query-tt-movto:GET-NEXT().
        IF h-query-tt-movto:QUERY-OFF-END THEN LEAVE.
    END.

END.

IF p-ind-event  = "BEFORE-OPEN-QUERY":U AND
   p-ind-object = "BROWSER":U           AND
   c-objeto     = "b06in385.w":U        THEN DO:

    IF CAN-FIND(FIRST tt-movto-cd1409-upc) THEN DO:

        FIND FIRST tt-movto-cd1409-upc NO-LOCK NO-ERROR.

        FIND FIRST requisicao
            WHERE requisicao.nr-requisicao = INTEGER(tt-movto-cd1409-upc.nro-docto) NO-LOCK NO-ERROR.

        IF AVAILABLE requisicao THEN DO:

            FIND FIRST usuar_mestre
                WHERE usuar_mestre.cod_usuario = requisicao.nome-abrev NO-LOCK NO-ERROR.

            ASSIGN c-email    = IF AVAILABLE usuar_mestre THEN usuar_mestre.cod_e_mail_local ELSE "":U
                   c-mensagem = "Ol .":U                                                                                                                             + CHR(10) + CHR(10) +
                                "Sua requisi‡Æo j  foi atendida. Favor retirar o material no Almoxarifado.":U                                                                                            + CHR(10) + CHR(10) +
                                "Requisi‡Æo.....: ":U + TRIM(STRING(requisicao.nr-requisicao, ">>>,>>>,>>9":U))                                                             + CHR(10) +
                                "Requisitante...: ":U + TRIM(STRING(requisicao.nome-abrev, "x(12)":U)) + " - ":U + TRIM(STRING(usuar_mestre.nom_usuario, "x(32)":U)) + CHR(10) +
                                "Data Requisi‡Æo: ":U + TRIM(STRING(requisicao.dt-requisicao, "99/99/9999":U))                                                              + CHR(10) +
                                "Data Atedimento: ":U + TRIM(STRING(tt-movto-cd1409-upc.dt-trans, "99/99/9999":U))                                      + CHR(10) + CHR(10) + CHR(10).

            RUN esp/es0018p.p (INPUT "CD1409-UPC":U,
                               INPUT 1,
                               INPUT 0,
                               INPUT "":U,
                               OUTPUT TABLE tt-prog-ponto).

            ASSIGN l-ret-almox = NO.

            FOR EACH tt-movto-cd1409-upc:
                
                FIND FIRST item
                    WHERE item.it-codigo = tt-movto-cd1409-upc.it-codigo NO-LOCK NO-ERROR.

                FIND FIRST deposito
                    WHERE deposito.cod-depos = tt-movto-cd1409-upc.cod-depos NO-LOCK NO-ERROR.

                ASSIGN c-desc-item = IF AVAILABLE item THEN item.desc-item ELSE "":U
                       c-desc-dep  = IF AVAILABLE deposito THEN deposito.nome ELSE "":U
                       c-mensagem  = c-mensagem +
                                     "Sequˆncia.: ":U + TRIM(STRING(tt-movto-cd1409-upc.num-sequen, ">>9":U))                                                            + CHR(10) +
                                     "Item......: ":U + TRIM(STRING(tt-movto-cd1409-upc.it-codigo, "x(16)":U)) + " - ":U + TRIM(STRING(c-desc-item, "x(60)":U))          + CHR(10) +
                                     "Quantidade: ":U + TRIM(STRING(tt-movto-cd1409-upc.quantidade, ">>>,>>>,>>9.9999":U))                                               + CHR(10) +
                                     "Local.....: ":U + TRIM(STRING(tt-movto-cd1409-upc.cod-depos, "x(03)":U)) + " - ":U + TRIM(STRING(c-desc-dep, "x(40)":U)) + CHR(10) + CHR(10).

                IF AVAIL ITEM AND
                   CAN-FIND(FIRST tt-prog-ponto
                            WHERE tt-prog-ponto.conteudo = ITEM.it-codigo)
                THEN ASSIGN l-ret-almox = YES.

                DELETE tt-movto-cd1409-upc.
            END.

            IF l-ret-almox = YES 
            THEN ASSIGN SUBSTRING(c-mensagem,39,41) = "".

            RUN enviaMail (INPUT "ems@intelbras.com.br":U,
                           INPUT c-email,
                           INPUT "CD1409 - Atendimento Requisi‡Æo Materiais - Nro. ":U + TRIM(STRING(requisicao.nr-requisicao, ">>>,>>>,>>9":U)),
                           INPUT c-mensagem,
                           INPUT "":U).

        END.

    END.

END.

IF p-ind-event  = "BEFORE-DISPLAY":U AND
   p-ind-object = "VIEWER":U         AND
   c-objeto     = "v19in385.w":U     THEN DO:
    FOR EACH tt-movto-cd1409-upc:
        DELETE tt-movto-cd1409-upc.
    END.
END.

IF p-ind-event  = "DESTROY":U   AND
   p-ind-object = "CONTAINER":U AND
   c-objeto     = "cd1409.w":U  THEN DO:

    FOR EACH tt-movto-cd1409-upc:
        DELETE tt-movto-cd1409-upc.
    END.

    IF VALID-HANDLE(h-buffer-tt-movto) THEN
        DELETE OBJECT h-buffer-tt-movto.

    IF VALID-HANDLE(h-query-tt-movto) THEN
        DELETE OBJECT h-query-tt-movto.

    IF VALID-HANDLE(h-campo-cod-depos) THEN
        DELETE OBJECT h-campo-cod-depos.

    IF VALID-HANDLE(h-campo-dt-trans) THEN
        DELETE OBJECT h-campo-dt-trans.

    IF VALID-HANDLE(h-campo-it-codigo) THEN
        DELETE OBJECT h-campo-it-codigo.

    IF VALID-HANDLE(h-campo-nro-docto) THEN
        DELETE OBJECT h-campo-nro-docto.

    IF VALID-HANDLE(h-campo-num-sequen) THEN
        DELETE OBJECT h-campo-num-sequen.

    IF VALID-HANDLE(h-campo-quantidade) THEN
        DELETE OBJECT h-campo-quantidade.

END.
