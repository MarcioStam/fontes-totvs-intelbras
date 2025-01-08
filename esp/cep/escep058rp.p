/*:T*******************************************************************************
**
**  Programa.: ESCEP058RP.P
**  Objetivo.: Listar Parcelas cuja quantidade estrapolem a quantidade da politica
               de estoque do item.
**  Cria‡Æo..: Silvio Ferrari
**
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCEP058RP 2.00.00.000}

{esp/cep/escep058.i} /* Defini‡Æo Temp-Table tt-param, tt-digita e tt-raw-digita */
{utp/ut-glob.i}
{include/i-rpvar.i}
{esp/es0006a.i}
{upc/btb910za-upc.i}
{esp/eslib.i}

DEFINE INPUT PARAMETER raw-param AS RAW         NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

DEFINE VARIABLE h-acomp             AS HANDLE                       NO-UNDO.
DEFINE VARIABLE c-it-codigo         LIKE item.it-codigo             NO-UNDO.
DEFINE VARIABLE c-dep-entrada       AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE de-saldo            LIKE saldo-estoq.qtidade-atu    NO-UNDO.
DEFINE VARIABLE de-variacao         LIKE saldo-estoq.qtidade-atu    NO-UNDO.
DEFINE VARIABLE de-pl               LIKE it-periodo.qt-res-plan     NO-UNDO.
DEFINE VARIABLE c-nome-comprador    AS CHARACTER FORMAT "X(40)"     NO-UNDO.
DEFINE VARIABLE c-fornec            AS CHARACTER FORMAT "X(12)"     NO-UNDO.
DEFINE VARIABLE dt-periodo-ini      AS DATE FORMAT "99/99/9999"     NO-UNDO.
DEFINE VARIABLE dt-periodo-fim      AS DATE FORMAT "99/99/9999"     NO-UNDO.
DEFINE VARIABLE dt-aux              AS DATE                         NO-UNDO.
DEFINE VARIABLE i-num-calc-plano    AS INTEGER                      NO-UNDO.
DEFINE VARIABLE c-mes               AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-ano               AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-remetente         AS CHAR                         NO-UNDO INITIAL "intelbras@intelbras.com.br".
DEFINE VARIABLE c-titulo            AS CHAR                         NO-UNDO INITIAL "Pedidos de Compra acima da Pol¡tica de Estoque".

DEFINE STREAM s-imp.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.

RUN pi-cria-periodo.

DEFINE TEMP-TABLE tt-periodo
    FIELD data        AS DATE FORMAT "99/99/9999"
    FIELD de-pl       LIKE it-periodo.qt-res-plan
    FIELD de-oc       AS DECIMAL FORMAT ">>,>>>,>>9.99"
    FIELD rowid-parcela AS ROWID
    INDEX id AS PRIMARY UNIQUE data.

DEFINE TEMP-TABLE tt-impressao
    FIELD estabel       LIKE ordem-compra.cod-estabel
    FIELD ITEM          LIKE prazo-compra.it-codigo
    FIELD comprador     AS CHARACTER FORMAT "X(40)" 
    FIELD politica      LIKE saldo-estoq.qtidade-atu
    FIELD pol-var       LIKE saldo-estoq.qtidade-atu
    FIELD saldo         LIKE saldo-estoq.qtidade-atu
    FIELD data          AS DATE FORMAT "99/99/9999"
    FIELD fornec        AS CHARACTER FORMAT "X(12)" 
    FIELD pedido        AS INTEGER
    FIELD qtd           LIKE prazo-compra.quant-saldo
    FIELD ordem         LIKE saldo-estoq.qtidade-atu
    FIELD parcela       AS INTEGER.

FIND FIRST param-global NO-LOCK NO-ERROR.
FIND FIRST param-estoq NO-LOCK NO-ERROR.

FIND FIRST empresa
    WHERE empresa.ep-codigo = param-global.empresa-prin NO-LOCK NO-ERROR.

ASSIGN c-sistema      = "Espec¡ficos Intelbras":U
       c-titulo-relat = "Avalia‡Æo Pol¡tica Estoque":U
       c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE "":U
       c-programa     = "ESCEP058":U
       c-versao       = "2.00":U
       c-revisao      = "000":U.

IF OPSYS = "UNIX":U THEN
    ASSIGN tt-param.arquivo     = c-programa + ".lst":U
           tt-param.arquivo-csv = c-seg-usuario + "/":U + REPLACE(tt-param.arquivo, ENTRY(NUM-ENTRIES(tt-param.arquivo, ".":U), tt-param.arquivo, ".":U), "csv":U).

FORM SKIP(1)
     "SELE€ÇO":U AT 13 SKIP(1)
     tt-param.estabel       FORMAT "x(03)":U      LABEL "Estabelecimento":U COLON 40
     tt-param.item-ini      FORMAT "x(16)":U      LABEL "Item":U COLON 40 
     " |< >| ":U AT 59                                                    
     tt-param.item-fim      FORMAT "x(16)":U      NO-LABEL SKIP           
     tt-param.comprador-ini FORMAT "x(12)":U      LABEL "Comprador":U COLON 40
     " |< >| ":U AT 59
     tt-param.comprador-fim FORMAT "x(12)":U      NO-LABEL SKIP
     SKIP(1)
     "PAR¶METRO":U AT 13 SKIP(1)
     tt-param.periodo       FORMAT "99/9999":U    LABEL "Per¡odo Final Avalia‡Æo":U COLON 40
     tt-param.variacao      FORMAT ">>9":U        LABEL "Varia‡Æo Pol¡tica Estoque":U COLON 40
     " %":U AT 59
     tt-param.email         FORMAT "x(35)":U      LABEL "E-mail":U COLON 40 SKIP 
     SKIP(1)
     "IMPRESSÇO":U AT 13 SKIP(1)
     tt-param.arquivo       FORMAT "x(80)":U      LABEL "Destino":U           COLON 40 SKIP
     tt-param.usuario       FORMAT "x(12)":U      LABEL "Usu rio":U           COLON 40 SKIP
     tt-param.arquivo-csv   FORMAT "x(80)":U      LABEL "Destino":U           COLON 40 SKIP
    WITH STREAM-IO SIDE-LABELS NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-impressao.

IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "Gerando dados..":U).

{include/i-rpcab.i}
{include/i-rpout.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

DISP tt-param.estabel
     tt-param.item-ini     
     tt-param.item-fim
     tt-param.comprador-ini
     tt-param.comprador-fim
     tt-param.periodo
     tt-param.variacao
     tt-param.email
     tt-param.arquivo
     tt-param.usuario
     tt-param.arquivo-csv
    WITH FRAME f-impressao.

{include/i-rpclo.i}

RUN pi-executar.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar in h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    DELETE OBJECT h-acomp.

RETURN "OK":U.

PROCEDURE pi-executar:

    RUN pi-acompanhar in h-acomp (INPUT "Executando...").

    ASSIGN c-endereco = tt-param.email.

    EMPTY TEMP-TABLE tt-periodo.
            
    blk-main:
    FOR EACH item-uni-estab WHERE
        item-uni-estab.cod-estabel  = tt-param.estabel         AND
        item-uni-estab.it-codigo    >= tt-param.item-ini       AND
        item-uni-estab.it-codigo    <= tt-param.item-fim       AND
        item-uni-estab.cod-comprado >= tt-param.comprador-ini  AND
        item-uni-estab.cod-comprado <= tt-param.comprador-fim  NO-LOCK:

        EMPTY TEMP-TABLE tt-periodo.

        FIND FIRST int-item-uni-estab NO-LOCK
             WHERE int-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel
               AND int-item-uni-estab.it-codigo   = item-uni-estab.it-codigo NO-ERROR.

        IF NOT AVAIL int-item-uni-estab THEN NEXT blk-main.

        IF int-item-uni-estab.qtd-pol = 0 THEN NEXT blk-main. /* NÆo verifica itens sem politica de estoque */

        FIND FIRST ITEM WHERE
            ITEM.it-codigo = item-uni-estab.it-codigo NO-LOCK NO-ERROR.

        IF NOT AVAIL ITEM THEN NEXT blk-main.

        IF NOT ITEM.tipo-contr         = 2 THEN NEXT blk-main. /* Somente tipo de Controle Total */
        IF NOT ITEM.compr-fabric       = 1 THEN NEXT blk-main. /* Somente Comprados */
        IF NOT item-uni-estab.demanda  = 1 THEN NEXT blk-main. /* Somente Tipo de Demanda Dependente */

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Item: " + STRING(item-uni-estab.it-codigo)).

        ASSIGN de-saldo         = 0
               c-fornec         = ""
               c-nome-comprador = "".

        FIND FIRST item-fornec-estab NO-LOCK
             WHERE item-fornec-estab.it-codigo   = item-uni-estab.it-codigo
               AND item-fornec-estab.cod-estabel = item-uni-estab.cod-estabel
               AND item-fornec-estab.ativo
               AND item-fornec-estab.perc-compra > 0 NO-ERROR.

        IF AVAIL item-fornec-estab THEN DO:

            FIND FIRST emitente WHERE emitente.cod-emitente = item-fornec-estab.cod-emitente NO-LOCK NO-ERROR.

            IF AVAIL emitente THEN
                ASSIGN c-fornec  = emitente.nome-abrev.
        END.

        ASSIGN de-variacao = int-item-uni-estab.qtd-pol + ((int-item-uni-estab.qtd-pol * tt-param.variacao / 100)).

        FOR EACH saldo-estoq
           WHERE saldo-estoq.cod-estabel = item-uni-estab.cod-estabel
             AND saldo-estoq.it-codigo   = item-uni-estab.it-codigo NO-LOCK:

            IF CAN-FIND(FIRST deposito
                        WHERE deposito.cod-depos = saldo-estoq.cod-depos 
                          AND NOT deposito.cons-saldo NO-LOCK) THEN NEXT. /* Somente dep¢sito que considera saldo */  

            ASSIGN de-saldo = de-saldo + saldo-estoq.qtidade-atu.
        END.

        /* Verifica ordens de produ‡Æo comprometidas */
        FOR EACH reservas NO-LOCK USE-INDEX planejamento
           WHERE reservas.it-codigo   = ITEM.it-codigo
             AND reservas.estado      = 1
             AND reservas.dt-reserva <= dt-periodo-fim,
           FIRST ord-prod NO-LOCK
           WHERE ord-prod.nr-ord-produ = reservas.nr-ord-produ
             AND ord-prod.cod-estabel  = item-uni-estab.cod-estabel: /*tem que verificar estabelecimento se nÆo fizer isso e pegar v rios estabelecimento ir  duplicar reservas*/ 

            FIND FIRST tt-periodo WHERE
                       tt-periodo.data = reservas.dt-reserva NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-periodo THEN DO:
                CREATE tt-periodo.
                ASSIGN tt-periodo.data = reservas.dt-reserva.
            END.

            ASSIGN tt-periodo.de-pl = tt-periodo.de-pl + reservas.quant-orig - reservas.quant-aloc - reservas.quant-atend.
        END.

        /* Verifica Ordens de produ‡Æo planejadas */
        FIND FIRST pl-prod WHERE
            pl-prod.cd-plano = 1 NO-LOCK NO-ERROR.

        IF AVAIL pl-prod THEN
            ASSIGN i-num-calc-plano = IF AVAIL pl-prod THEN pl-prod.num-calc-plano ELSE 0.

        FOR FIRST pl-it-calc WHERE 
                  pl-it-calc.cd-plano  = pl-prod.cd-plano AND
                  pl-it-calc.it-codigo = item-uni-estab.it-codigo NO-LOCK:

            FOR EACH it-periodo NO-LOCK
               WHERE it-periodo.num-calc-plano = i-num-calc-plano
                 AND it-periodo.cod-estabel    = item-uni-estab.cod-estabel
                 AND it-periodo.it-codigo      = pl-it-calc.it-codigo
                 AND it-periodo.data          <= dt-periodo-fim:

                FIND FIRST periodo where
                   periodo.nr-periodo = it-periodo.periodo and
                   periodo.ano        = it-periodo.ano     and
                   periodo.cd-tipo    = pl-prod.cd-tipo NO-LOCK NO-ERROR.

                IF AVAIL periodo AND periodo.dt-inicio <= dt-periodo-fim THEN DO:

                    FOR EACH res-aber 
                       WHERE res-aber.num-id-it-periodo = it-periodo.num-id-it-periodo 
                         AND res-aber.it-codigo         = it-periodo.it-codigo
                         AND res-aber.cod-refer         = it-periodo.cod-refer
                         AND res-aber.ano               = it-periodo.ano       
                         AND res-aber.periodo           = it-periodo.periodo   
                         AND res-aber.cod-estabel       = item-uni-estab.cod-estabel NO-LOCK:
        
                        IF NOT (res-aber.tipo-res   = 4 OR
                                res-aber.tipo-res   = 7) THEN NEXT.

                        FIND FIRST tt-periodo WHERE
                                   tt-periodo.data = periodo.dt-inicio NO-LOCK NO-ERROR.

                        IF NOT AVAIL tt-periodo THEN DO:
                            CREATE tt-periodo.
                            ASSIGN tt-periodo.data = periodo.dt-inicio.
                        END.
            
                        ASSIGN tt-periodo.de-pl = tt-periodo.de-pl + res-aber.quantidade.
                    END.
                END.
            END.
        END.

        /* Verifica Ordens de Compra */
        FOR EACH prazo-compra NO-LOCK
           WHERE prazo-compra.data-entrega <= dt-periodo-fim 
             AND prazo-compra.situacao = 2 
             AND prazo-compra.it-codigo = item-uni-estab.it-codigo 
             AND prazo-compra.quant-saldo <> 0,
           FIRST ordem-compra NO-LOCK 
           WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem 
             AND ordem-compra.cod-estabel  = item-uni-estab.cod-estabel
             AND ordem-compra.cod-comprado >= tt-param.comprador-ini
             AND ordem-compra.cod-comprado <= tt-param.comprador-fim
             AND ordem-compra.situacao     = 2
             AND ordem-compra.num-pedido <> 0:

            FIND FIRST tt-periodo WHERE
                       tt-periodo.data = prazo-compra.data-entrega NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-periodo THEN DO:
                CREATE tt-periodo.
                ASSIGN tt-periodo.data = prazo-compra.data-entrega.
            END.

            ASSIGN tt-periodo.de-oc = tt-periodo.de-oc + prazo-compra.quant-saldo
                   tt-periodo.rowid-parcela = ROWID(prazo-compra).
        END.

        FOR EACH tt-periodo:

            ASSIGN de-saldo = de-saldo + tt-periodo.de-oc - tt-periodo.de-pl.

            IF de-saldo > de-variacao THEN DO:
            
                RUN pi-cria-parcela(INPUT tt-periodo.rowid-parcela).
                NEXT blk-main.
            END.

        END.
    END.

    IF CAN-FIND(FIRST tt-impressao NO-LOCK) THEN DO:
        RUN pi-imprime.
        RUN pi-envia-email.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-cria-parcela:

    DEFINE INPUT PARAMETER pRowid AS ROWID.

    FOR FIRST prazo-compra WHERE
        ROWID(prazo-compra) = pRowid NO-LOCK,
        FIRST ordem-compra  
        WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem NO-LOCK:

        FIND FIRST usuar-mater NO-LOCK
             WHERE usuar-mater.cod-usuario = ordem-compra.cod-comprado NO-ERROR.

        ASSIGN c-nome-comprador = IF AVAIL usuar-mater THEN usuar-mater.nome-usuar ELSE "".

        CREATE tt-impressao.
        ASSIGN tt-impressao.estabel   = ordem-compra.cod-estabel
               tt-impressao.ITEM      = prazo-compra.it-codigo
               tt-impressao.comprador = c-nome-comprador
               tt-impressao.politica  = int-item-uni-estab.qtd-pol
               tt-impressao.pol-var   = de-variacao
               tt-impressao.saldo     = de-saldo
               tt-impressao.data      = prazo-compra.data-entrega
               tt-impressao.fornec    = c-fornec
               tt-impressao.pedido    = ordem-compra.num-pedido
               tt-impressao.qtd       = prazo-compra.quant-saldo
               tt-impressao.ordem     = ordem-compra.numero-ordem
               tt-impressao.parcela   = prazo-compra.parcela.
    END.

    RELEASE prazo-compra.
    RELEASE ordem-compra.
    RELEASE usuar-mater.

    ASSIGN pRowid = ?.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-envia-email:

    /* Anexa Arquivo Excel */
    IF SEARCH(tt-param.arquivo-csv) <> ? AND tt-param.email <> "" THEN DO:

        RUN pi-acompanhar in h-acomp (input "Enviando Email: " + c-endereco).

        RUN enviaMail (INPUT c-remetente,
                       INPUT c-endereco,
                       INPUT TRIM(c-titulo),
                       INPUT "Segue arquivo com parcelas acima da politica de estoque.",
                       INPUT tt-param.arquivo-csv).
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-imprime:

    OUTPUT TO VALUE(tt-param.arquivo-csv) CONVERT TARGET SESSION:CHARSET.

    PUT "Est"           ";"
        "Item"          ";"
        "Comprador"     ";"
        "Politica"      ";"
        "Politica + %"  ";"
        "Saldo"         ";"
        "Data"          ";"
        "Fornecedor"    ";"
        "Pedido"        ";"
        "Quantidade"    ";"
        "Ordem Compra"  ";"
        "Parcela".

    PUT "" SKIP.

    FOR EACH tt-impressao BY tt-impressao.ITEM:

        PUT tt-impressao.estabel    ";"
            tt-impressao.ITEM       ";"
            tt-impressao.comprador  ";"
            tt-impressao.politica   ";"
            tt-impressao.pol-var    ";"
            tt-impressao.saldo      ";"
            tt-impressao.data       ";"
            tt-impressao.fornec     ";"
            tt-impressao.pedido     ";"
            tt-impressao.qtd        ";"
            tt-impressao.ordem      ";"
            tt-impressao.parcela.

        PUT "" SKIP.
    END.

    OUTPUT CLOSE.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-cria-periodo:
    DEFINE VARIABLE iMes AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iAno AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iDiaFim AS INTEGER     NO-UNDO.

    ASSIGN iMes = INT(SUBSTRING(tt-param.periodo,1,2)).

    ASSIGN iAno = INT(SUBSTRING(tt-param.periodo,4,4)).

    define variable dResult     as decimal no-undo. /*** Resultado para verificar se ano ² bisexto **/

    /** Calculo para verificar se ano ² bisexto **/
    assign dResult = (iAno) mod 4.

    /** Verifica qual mes do ano **/
    case iMes:
        /** Meses com 31 dias **/
        when 1  or
        when 3  or
        when 5  or
        when 7  or 
        when 8  or
        when 10 or
        when 12 then do:
            assign iDiaFim = 31. 
        end.
        when 2 then do:
            /** Se ano ² bisexto Fevererio tem 29 dias **/             
            if dResult = 0 then 
                assign iDiaFim = 29. 
            else
                assign iDiaFim = 28.                
        end.
        otherwise do:
            /** Sen’o œltimo dia do mes ² 30 **/
            assign iDiaFim = 30. 
        end.
    end case.

    ASSIGN dt-periodo-ini = TODAY
           dt-periodo-fim = DATE(STRING(iDiaFim) + "/" + STRING(iMes) + "/" + STRING(iAno)).

    RETURN "OK":U.

END PROCEDURE.

