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
**  Programa.: esp/cep/escep056rp.p
**  Objetivo.: Relat¢rio de Projeá∆o de Estoque.
**  Criado...: 03/11/2015 - Felipe Petry Vieira - SENSUS.
**
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCEP056RP 2.00.00.001}

{utp/ut-glob.i}
{include/i-rpvar.i}
{esp/es0018.i}

/*Permiss∆o para visualizar as colunas de preáo do Relat¢rio*/
EMPTY TEMP-TABLE tt-prog-ponto.
RUN esp/es0018p.p (INPUT "ESCEP055":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino                  AS INTEGER
    FIELD arquivo                  AS CHAR
    FIELD arquivo-csv              AS CHAR
    FIELD usuario                  AS CHAR FORMAT "x(12)"
    FIELD data-exec                AS DATE
    FIELD hora-exec                AS INTEGER    
    FIELD estab                    LIKE item-uni-estab.cod-estabel
    FIELD cd-plano                 AS INTEGER
    FIELD item-ini                 LIKE item-uni-estab.it-codigo
    FIELD item-fim                 LIKE item-uni-estab.it-codigo
    FIELD valor-fi                 AS DECIMAL
    FIELD valor-dolar              AS DECIMAL
    FIELD periodo-ini              AS DATE
    FIELD periodo-fim              AS DATE
    FIELD l-po-embarcado           AS LOGICAL
    FIELD l-po-confirmado          AS LOGICAL
    FIELD l-oc-confirmado          AS LOGICAL
    FIELD l-oc-planejado           AS LOGICAL
    FIELD l-saldo                  AS LOGICAL
    FIELD l-depos-saldo-diponivel  AS LOGICAL
    FIELD l-param-item             AS LOGICAL
    FIELD l-entrega-cons           AS LOGICAL
    FIELD log-ativo                AS LOGICAL 
    FIELD log-obsol-ord-auto       AS LOGICAL 
    FIELD log-obsol-todas-ord      AS LOGICAL 
    FIELD log-total-obsol          AS LOGICAL 
    FIELD log-dependente           AS LOGICAL 
    FIELD log-independente         AS LOGICAL.
        
DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem   AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo AS CHARACTER FORMAT "x(30)":U
    INDEX id ordem.
 
DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita       AS RAW.    
    
DEFINE TEMP-TABLE tt-periodo
    FIELD mes               AS INT  FORMAT "99"
    FIELD ano               AS INT  FORMAT "9999"
    FIELD anomes            AS CHAR FORMAT "x(6)"
    FIELD de-res            AS DEC  FORMAT "->>,>>>,>>>,>>9.99"
    FIELD de-pv             AS DEC  FORMAT "->>,>>>,>>>,>>9.99"
    FIELD de-pv-pr          AS DEC  FORMAT "->>,>>>,>>>,>>9.99"
    FIELD de-rpl            AS DEC  FORMAT "->>,>>>,>>>,>>9.99"
    FIELD de-pp-pr          AS DEC  FORMAT "->>,>>>,>>>,>>9.99"
    FIELD de-po-emb         AS DEC  FORMAT "->>,>>>,>>>,>>9.99"
    FIELD de-po-emb-pr      AS DEC  FORMAT "->>,>>>,>>>,>>9.99"
    FIELD de-po-conf        AS DEC  FORMAT "->>,>>>,>>>,>>9.99"
    FIELD de-po-conf-pr     AS DEC  FORMAT "->>,>>>,>>>,>>9.99"
    FIELD de-oc-conf        AS DEC  FORMAT "->>,>>>,>>>,>>9.99"
    FIELD de-oc-plan        AS DEC  FORMAT "->>,>>>,>>>,>>9.99"
    FIELD de-oc-conf-pr     AS DEC  FORMAT "->>,>>>,>>>,>>9.99"
    FIELD de-oc-plan-pr     AS DEC  FORMAT "->>,>>>,>>>,>>9.99"
    FIELD de-oc-nao-conf    AS DEC  FORMAT "->>,>>>,>>>,>>9.99"
    FIELD de-oc-nao-conf-pr AS DEC  FORMAT "->>,>>>,>>>,>>9.99"
    FIELD de-qt-total       AS DEC  FORMAT "->>,>>>,>>>,>>9.99"
    FIELD de-pr-total       AS DEC  FORMAT "->>,>>>,>>>,>>9.99"
    INDEX id AS PRIMARY UNIQUE mes ano.

DEFINE BUFFER b-usuar-mater FOR usuar-mater.
DEFINE BUFFER b3-item       FOR ITEM.
DEFINE BUFFER b1-item       FOR ITEM.
DEFINE BUFFER b-ped-item    FOR ped-item.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

/******** Variaveis do Display *******/
DEFINE VARIABLE c-item            AS CHAR FORMAT "x(16)"            NO-UNDO.
DEFINE VARIABLE c-desc-item       LIKE item.desc-item               NO-UNDO.
DEFINE VARIABLE c-situacao        AS CHAR                           NO-UNDO.
DEFINE VARIABLE c-un              AS CHAR FORMAT "x(02)"            NO-UNDO.
DEFINE VARIABLE c-cod-fornec      AS CHAR FORMAT "x(12)"            NO-UNDO.
DEFINE VARIABLE i-res-for         LIKE item-uni-estab.res-for-comp  NO-UNDO.
DEFINE VARIABLE c-desc-unid-negoc AS CHAR FORMAT "x(40)"            NO-UNDO.
DEFINE VARIABLE c-ge              AS CHAR                           NO-UNDO.
DEFINE VARIABLE i-tp-desp         AS INTEGER                        NO-UNDO.
DEFINE VARIABLE c-pais            AS CHAR                           NO-UNDO.
DEFINE VARIABLE c-nome-comprador  LIKE usuar-mater.nome-usuar       NO-UNDO.
DEFINE VARIABLE de-lote-min-for   LIKE item-uni-estab.lote-minimo   NO-UNDO.
DEFINE VARIABLE i-periodo-fixo    like item-uni-estab.periodo-fixo  NO-UNDO.
DEFINE VARIABLE de-quant-segur    like item-uni-estab.quant-segur   NO-UNDO.
DEFINE VARIABLE de-quant-polit    like int-item-uni-estab.qtd-pol   NO-UNDO.
DEFINE VARIABLE de-pr-item        LIKE item-tab.pr-item             NO-UNDO.
DEFINE VARIABLE de-pr-tab         LIKE item-tab.pr-item             NO-UNDO.
DEFINE VARIABLE de-pr-ped         LIKE item-tab.pr-item             NO-UNDO.
DEFINE VARIABLE de-saldo          LIKE saldo-estoq.qtidade-atu      NO-UNDO.
DEFINE VARIABLE de-saldo-ini      LIKE saldo-estoq.qtidade-atu      NO-UNDO.
DEFINE VARIABLE de-entregas       LIKE saldo-estoq.qtidade-atu      NO-UNDO.
DEFINE VARIABLE de-preco-ul-ent   LIKE item.preco-ul-ent            NO-UNDO.
DEFINE VARIABLE dt-ult-entrada    AS DATE      FORMAT "99/99/9999"  NO-UNDO.
DEFINE VARIABLE de-saldo-pr       LIKE item.preco-ul-ent            NO-UNDO.
DEFINE VARIABLE de-saldo-pr-ini   LIKE item.preco-ul-ent            NO-UNDO.
DEFINE VARIABLE de-pr-consumo     LIKE item.preco-ul-ent            NO-UNDO.

/******* Outras Variaveis **************/
DEFINE VARIABLE h-acomp           AS HANDLE                         NO-UNDO.
DEFINE VARIABLE i-num-calc-plano  AS INTE                           NO-UNDO.
DEFINE VARIABLE dt-aux            AS DATE      FORMAT "99/99/9999"  NO-UNDO.
DEFINE VARIABLE c-cab             AS CHARACTER                      NO-UNDO.
DEFINE VARIABLE de-consumo-pp     LIKE it-periodo.qt-res-plan       NO-UNDO.
DEFINE VARIABLE de-consumo-pv     LIKE it-periodo.qt-res-plan       NO-UNDO.
DEFINE VARIABLE l-demanda-item    AS LOGICAL FORMAT "Sim/Nao"       NO-UNDO.
DEFINE VARIABLE c-arquivo         AS CHARACTER                      NO-UNDO.
DEFINE VARIABLE c-clientes-oem    AS CHARACTER                      NO-UNDO.
DEFINE VARIABLE de-saldo-item     LIKE saldo-estoq.qtidade-atu      NO-UNDO.
DEFINE VARIABLE de-ped-saldo      LIKE saldo-estoq.qtidade-atu      NO-UNDO.
DEFINE VARIABLE de-saldo-aloc     LIKE saldo-estoq.qtidade-atu      NO-UNDO.
DEFINE VARIABLE de-vl-unit        LIKE item.preco-ul-ent            NO-UNDO.
DEFINE VARIABLE de-preco          LIKE item-tab.pr-item             NO-UNDO.

DEFINE VARIABLE i-num-casa-dec    AS INT                            NO-UNDO.
DEFINE VARIABLE de-fator-conver   AS DEC                            NO-UNDO.
DEFINE VARIABLE i-cont            AS INT                            NO-UNDO.
DEFINE VARIABLE c-nome-ab         LIKE emitente.nome-abrev          NO-UNDO.


CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.
FIND FIRST param-global NO-LOCK NO-ERROR.
FIND FIRST empresa WHERE empresa.ep-codigo = param-global.empresa-pri NO-LOCK NO-ERROR.

ASSIGN c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "":U
       c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE "":U
       c-programa     = "ESCEP056":U.

IF OPSYS = "UNIX":U THEN DO:
    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT  "SPOOL-UNIX":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR FIRST tt-prog-ponto:
        ASSIGN c-arquivo = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
    END.

    IF SUBSTRING(c-arquivo, LENGTH(c-arquivo), 1) <> "/":U THEN
        ASSIGN c-arquivo = c-arquivo + "/":U.

    ASSIGN tt-param.arquivo     = c-programa + ".lst":U
           tt-param.arquivo-csv = c-arquivo + c-seg-usuario + "/":U + tt-param.estab + "_" + c-programa + ".csv":U.
END.

FORM SKIP(1)
     "SELEÄ«O":U AT 13 SKIP(1)
     tt-param.estab             FORMAT "x(03)":U        LABEL "Estabelecimento":U COLON 40  SKIP
     tt-param.cd-plano          FORMAT ">>9":U          LABEL "Plano":U           COLON 40  SKIP
     tt-param.item-ini          FORMAT "x(16)":U        LABEL "Item":U            COLON 40
     " |< >| ":U AT 59
     tt-param.item-fim          FORMAT "x(16)":U        NO-LABEL                            SKIP
     tt-param.periodo-ini       FORMAT "99/99/9999":U   LABEL "Per°odo Consumo":U COLON 40
     " |< >| ":U AT 59
     tt-param.periodo-fim       FORMAT "99/99/9999":U   NO-LABEL SKIP
     tt-param.valor-fi          FORMAT ">,>>>,>>9.99":U LABEL "FI":U              COLON 40 SKIP
     tt-param.valor-dolar       FORMAT ">,>>>,>>9.99":U LABEL "Dolar":U           COLON 40 SKIP(1)
     "PAR∂METRO":U AT 13 SKIP(1)
     tt-param.log-ativo               FORMAT "Sim/N∆o" LABEL "Ativos":U                            COLON 40 SKIP
     tt-param.log-obsol-ord-auto      FORMAT "Sim/N∆o" LABEL "Obsoleto Ordens Autom†ticas":U       COLON 40 SKIP
     tt-param.log-obsol-todas-ord     FORMAT "Sim/N∆o" LABEL "Obsoleto Todas as Ordens":U          COLON 40 SKIP
     tt-param.log-total-obsol         FORMAT "Sim/N∆o" LABEL "Totalmente Obsoletos":U              COLON 40 SKIP
     tt-param.log-dependente          FORMAT "Sim/N∆o" LABEL "Demanda Dependente":U                COLON 40 SKIP
     tt-param.log-independente        FORMAT "Sim/N∆o" LABEL "Demanda Independente":U              COLON 40 SKIP
     tt-param.l-saldo                 FORMAT "Sim/N∆o" LABEL "Apenas Itens com Movimentaá∆o":U     COLON 40 SKIP     
     tt-param.l-depos-saldo-diponivel FORMAT "Sim/N∆o" LABEL "Somente Dep¢sito Saldo Dispon°vel":U COLON 40 SKIP     
     tt-param.l-po-embarcado          FORMAT "Sim/N∆o" LABEL "PO Embarcado":U                      COLON 40 SKIP
     tt-param.l-po-confirmado         FORMAT "Sim/N∆o" LABEL "PO Confirmado":U                     COLON 40 SKIP
     tt-param.l-oc-confirmado         FORMAT "Sim/N∆o" LABEL "OC Confirmado":U                     COLON 40 SKIP
     tt-param.l-oc-planejado          FORMAT "Sim/N∆o" LABEL "OC Planejado":U                      COLON 40 SKIP  
     SKIP(1)
     "IMPRESS«O":U AT 13 SKIP(1)
     tt-param.arquivo       FORMAT "x(80)":U      LABEL "Destino":U           COLON 40 SKIP
     tt-param.usuario       FORMAT "x(12)":U      LABEL "Usu†rio":U           COLON 40 SKIP
     tt-param.arquivo-csv   FORMAT "x(80)":U      LABEL "Arquivo CSV":U       COLON 40 SKIP(1)
     WITH STREAM-IO SIDE-LABELS NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-impressao.

IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "Gerando dados..":U).

{include/i-rpcab.i}
{include/i-rpout.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

DISP tt-param.estab
     tt-param.cd-plano
     tt-param.item-ini     
     tt-param.item-fim
     tt-param.periodo-ini
     tt-param.periodo-fim
     tt-param.valor-fi
     tt-param.valor-dolar
     tt-param.log-ativo          
     tt-param.log-obsol-ord-auto 
     tt-param.log-obsol-todas-ord
     tt-param.log-total-obsol    
     tt-param.log-dependente
     tt-param.log-independente
     tt-param.l-saldo
     tt-param.l-depos-saldo-diponivel
     tt-param.l-po-embarcado 
     tt-param.l-po-confirmado
     tt-param.l-oc-confirmado
     tt-param.l-oc-planejado 
     tt-param.arquivo
     tt-param.usuario
     tt-param.arquivo-csv 
    WITH FRAME f-impressao.

{include/i-rpclo.i}

EMPTY TEMP-TABLE tt-periodo.
RUN pi-gera-periodo.
RUN pi-gera-csv.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar in h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    DELETE OBJECT h-acomp.

RETURN "OK":U.
    
/*------------------------------------------------------------------------------
  Purpose:  pi-gera-csv   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
PROCEDURE pi-gera-csv:


    DO ON STOP UNDO, LEAVE:

        FIND FIRST pl-prod NO-LOCK 
            WHERE pl-prod.cd-plano = tt-param.cd-plano NO-ERROR.

        ASSIGN i-num-calc-plano = IF AVAIL pl-prod THEN pl-prod.num-calc-plano ELSE 0.

        OUTPUT TO VALUE(tt-param.arquivo-csv) CONVERT TARGET SESSION:CHARSET.

        ASSIGN c-cab = "Item;Descricao;Situaá∆o;Un;Fornecedor;Ressuprimento;Unid Negoc;GE;Tp Desp;Pa°s;Nome Comprador;MOQ;PF;QS;QP;Preáo Item;Custo MÇdio R$;Valor Ult Entr;Data Ult Entr;Saldo Atual;Saldo R$;".

        FOR EACH tt-periodo 
            BY tt-periodo.ano      
            BY tt-periodo.mes:

            ASSIGN c-cab = c-cab + "Consumo PP " + STRING(tt-periodo.mes,"99") + "/":U + SUBSTRING(STRING(tt-periodo.ano,"9999"),3,2) + ";":U 
                                 + "Consumo PV OEM " + STRING(tt-periodo.mes,"99") + "/":U + SUBSTRING(STRING(tt-periodo.ano,"9999"),3,2) + ";":U.

            IF tt-param.l-po-embarcado THEN
                ASSIGN c-cab = c-cab + "PO Embarcado "    + STRING(tt-periodo.mes,"99") + "/":U + SUBSTRING(STRING(tt-periodo.ano,"9999"),3,2) + ";":U 
                                     + "PO Embarcado R$ " + STRING(tt-periodo.mes,"99") + "/":U + SUBSTRING(STRING(tt-periodo.ano,"9999"),3,2) + ";":U.

            IF tt-param.l-po-confirmado THEN
                ASSIGN c-cab = c-cab + "PO Confirmado "    + STRING(tt-periodo.mes,"99") + "/":U + SUBSTRING(STRING(tt-periodo.ano,"9999"),3,2) + ";":U 
                                     + "PO Confirmado R$ " + STRING(tt-periodo.mes,"99") + "/":U + SUBSTRING(STRING(tt-periodo.ano,"9999"),3,2) + ";":U.

            IF tt-param.l-oc-confirmado THEN
                ASSIGN c-cab = c-cab + "OC Confirmada "        + STRING(tt-periodo.mes,"99") + "/":U + SUBSTRING(STRING(tt-periodo.ano,"9999"),3,2) + ";":U 
                                     + "OC Confirmada R$ "     + STRING(tt-periodo.mes,"99") + "/":U + SUBSTRING(STRING(tt-periodo.ano,"9999"),3,2) + ";":U 
                                     + "OC N∆o Confirmada "    + STRING(tt-periodo.mes,"99") + "/":U + SUBSTRING(STRING(tt-periodo.ano,"9999"),3,2) + ";":U 
                                     + "OC N∆o Confirmada R$ " + STRING(tt-periodo.mes,"99") + "/":U + SUBSTRING(STRING(tt-periodo.ano,"9999"),3,2) + ";":U.

            IF tt-param.l-oc-planejado THEN
                ASSIGN c-cab = c-cab + "OC Planejada "    + STRING(tt-periodo.mes,"99") + "/":U + SUBSTRING(STRING(tt-periodo.ano,"9999"),3,2) + ";":U 
                                     + "OC Planejada R$ " + STRING(tt-periodo.mes,"99") + "/":U + SUBSTRING(STRING(tt-periodo.ano,"9999"),3,2) + ";":U.           

            ASSIGN c-cab = c-cab + "Qt Total " + STRING(tt-periodo.mes,"99") + "/":U + SUBSTRING(STRING(tt-periodo.ano,"9999"),3,2) + ";":U 
                                 + "R$ Total " + STRING(tt-periodo.mes,"99") + "/":U + SUBSTRING(STRING(tt-periodo.ano,"9999"),3,2) + ";":U.

        END.

        PUT UNFORMATTED c-cab SKIP.

        FOR EACH item-uni-estab
            WHERE item-uni-estab.cod-estabel   = tt-param.estab
              AND item-uni-estab.it-codigo    >= tt-param.item-ini
              AND item-uni-estab.it-codigo    <= tt-param.item-fim NO-LOCK:

            IF VALID-HANDLE(h-acomp) THEN
                RUN pi-acompanhar IN h-acomp (INPUT "Item: " + STRING(item-uni-estab.it-codigo)).
        
            FIND FIRST ITEM NO-LOCK 
                 WHERE ITEM.it-codigo = item-uni-estab.it-codigo NO-ERROR.
        
            IF NOT AVAIL ITEM THEN NEXT.
        
            IF item.tipo-contr <> 2 THEN NEXT.
        
            IF  item-uni-estab.cod-obsoleto = 1 
            AND tt-param.log-ativo          = NO THEN NEXT.
        
            IF  item-uni-estab.cod-obsoleto = 2 AND
                tt-param.log-obsol-ord-auto = NO THEN NEXT.
        
            IF  item-uni-estab.cod-obsoleto  = 3 AND
                tt-param.log-obsol-todas-ord = NO THEN NEXT.
        
            IF  item-uni-estab.cod-obsoleto = 4 AND 
                tt-param.log-total-obsol    = NO THEN NEXT.
        
            IF item-uni-estab.demanda  = 1 AND
               tt-param.log-dependente = NO THEN NEXT.
        
            IF item-uni-estab.demanda    = 2 AND
               tt-param.log-independente = NO THEN NEXT.

            IF item-uni-estab.cod-obsoleto = 1 THEN 
                ASSIGN c-situacao = "Ativo".
            IF item-uni-estab.cod-obsoleto = 2 THEN 
                ASSIGN c-situacao = "Obsoleto Ordens Autom†ticas".
            IF item-uni-estab.cod-obsoleto = 3 THEN 
                ASSIGN c-situacao = "Obsoleto Todas as Ordens".
            IF item-uni-estab.cod-obsoleto = 4 THEN 
                ASSIGN c-situacao = "Totalmente Obsoleto".

            ASSIGN c-item      = item-uni-estab.it-codigo /*Item*/
                   c-desc-item = item.desc-item           /*Descriá∆o*/
                   c-un        = item.un                  /*Unidade de Medida da Intelbras*/.

            FOR FIRST item-fornec-estab 
                WHERE item-fornec-estab.it-codigo     = item-uni-estab.it-codigo
                  AND item-fornec-estab.cod-estabel   = item-uni-estab.cod-estabel
                  AND item-fornec-estab.ativo         = YES
                  AND item-fornec-estab.cot-aut       = YES
                  AND item-fornec-estab.perc-compra   > 0 NO-LOCK:                   
            END.

            IF AVAIL item-fornec-estab THEN
                ASSIGN c-cod-fornec = STRING(item-fornec-estab.cod-emitente)  /*Fornecedor*/ .
            ELSE
                ASSIGN c-cod-fornec = 'Sem Relaá∆o'.

            ASSIGN i-res-for = item-uni-estab.res-for-comp /*Ressuprimento*/ .

            FIND FIRST unid-negoc NO-LOCK
                WHERE unid-negoc.cod-unid-negoc = item-uni-estab.cod-unid-negoc NO-ERROR.

            IF AVAIL unid-negoc THEN
                ASSIGN c-desc-unid-negoc = unid-negoc.des-unid-negoc /*Unidade Negocio*/ .
            ELSE ASSIGN c-desc-unid-negoc = ''.

            FIND FIRST grup-estoque NO-LOCK
                WHERE grup-estoque.ge-codigo = ITEM.ge-codigo  NO-ERROR.

            ASSIGN c-ge      = (IF AVAIL grup-estoque THEN grup-estoque.descricao ELSE string(ITEM.ge-codigo))                 /*Grupo de Estoque*/
                   i-tp-desp = item-uni-estab.tp-desp-padrao  /*Tipo despesa*/ .

            FIND FIRST emitente NO-LOCK
                WHERE emitente.cod-emitente = INT(c-cod-fornec) NO-ERROR.

            
            IF AVAIL emitente THEN
                ASSIGN c-pais    = emitente.pais  /*Pais do Fornecedor*/
                       c-nome-ab = emitente.nome-abrev.
            ELSE
                ASSIGN c-pais    = ''
                       c-nome-ab = "Sem Relaá∆o".
                
            FIND FIRST usuar-mater NO-LOCK
                 WHERE usuar-mater.cod-usuario = item-uni-estab.cod-comprado NO-ERROR.
    
            ASSIGN c-nome-comprador = IF AVAIL usuar-mater THEN usuar-mater.nome-usuar ELSE "" /*Nome do comprador*/
                   de-lote-min-for  = item-uni-estab.lote-minimo     /*MOQ*/ 
                   i-periodo-fixo   = item-uni-estab.periodo-fixo    /*PF*/
                   de-quant-segur   = item-uni-estab.quant-segur     /*QS*/ . 

            FIND FIRST int-item-uni-estab
                WHERE int-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel
                  AND int-item-uni-estab.it-codigo   = item-uni-estab.it-codigo NO-LOCK NO-ERROR.

            IF AVAIL int-item-uni-estab THEN
                ASSIGN de-quant-polit = int-item-uni-estab.qtd-pol  /*QP*/ .
            ELSE ASSIGN de-quant-polit = 0.

            RUN pi-relat. 

            IF RETURN-VALUE <> 'OK':U THEN
                NEXT.

            PUT UNFORMATTED 
                c-item             ";"         
                c-desc-item        ";"
                c-situacao         ";"
                c-un               ";"
                c-nome-ab          ";"
                i-res-for          ";"
                c-desc-unid-negoc  ";"
                c-ge               ";"
                i-tp-desp          ";"
                c-pais             ";"
                c-nome-comprador   ";"
                de-lote-min-for    ";"
                i-periodo-fixo     ";"
                de-quant-segur     ";"
                de-quant-polit     ";"
                de-preco           ";"
                de-pr-item         ";"
                de-preco-ul-ent    ";"
                (IF dt-ult-entrada = ? THEN "" ELSE string(dt-ult-entrada, "99/99/9999"))     ";"
                string(de-saldo,"->>,>>>,>>>,>>9.99")    ";"
                string(de-saldo-pr,"->>,>>>,>>>,>>9.99") ";".
                
            assign de-saldo-ini     = de-saldo
                   de-saldo-pr-ini  = de-saldo-pr.    

            FOR EACH tt-periodo 
                BY tt-periodo.ano
                BY tt-periodo.mes:

                PUT UNFORMATTED 
                    string(tt-periodo.de-res + tt-periodo.de-rpl ,"->>,>>>,>>>,>>9.99") ";"
                    string(tt-periodo.de-pv,"->>,>>>,>>>,>>9.99")                      ";".               

                IF tt-param.l-po-embarcado THEN DO:

                    PUT UNFORMATTED
                        string(tt-periodo.de-po-emb,"->>,>>>,>>>,>>9.99")    ";"
                        IF tt-periodo.de-po-emb-pr > 0 THEN string(tt-periodo.de-po-emb-pr,"->>,>>>,>>>,>>9.99") ELSE "0"  ";" .

                    ASSIGN tt-periodo.de-qt-total = tt-periodo.de-qt-total + tt-periodo.de-po-emb
                           tt-periodo.de-pr-total = tt-periodo.de-pr-total + tt-periodo.de-po-emb-pr.

                END.

                IF tt-param.l-po-confirmado THEN DO:
                    PUT UNFORMATTED
                        string(tt-periodo.de-po-conf,"->>,>>>,>>>,>>9.99")    ";"
                        IF tt-periodo.de-po-conf-pr > 0 THEN string(tt-periodo.de-po-conf-pr,"->>,>>>,>>>,>>9.99") ELSE "0" ";". 
                    ASSIGN tt-periodo.de-qt-total = tt-periodo.de-qt-total + tt-periodo.de-po-conf
                           tt-periodo.de-pr-total = tt-periodo.de-pr-total + tt-periodo.de-po-conf-pr.
                END.
              
                IF tt-param.l-oc-confirmado THEN DO:
                    PUT UNFORMATTED 
                        string(tt-periodo.de-oc-conf,"->>,>>>,>>>,>>9.99")     ";"
                        IF  tt-periodo.de-oc-conf-pr > 0 THEN 
                            string(tt-periodo.de-oc-conf-pr,"->>,>>>,>>>,>>9.99") 
                        ELSE "0" 
                                
                        ";" string(tt-periodo.de-oc-nao-conf,"->>,>>>,>>>,>>9.99") ";" string(tt-periodo.de-oc-nao-conf-pr,"->>,>>>,>>>,>>9.99") ";".

                    ASSIGN tt-periodo.de-qt-total = tt-periodo.de-qt-total + tt-periodo.de-oc-conf
                           tt-periodo.de-pr-total = tt-periodo.de-pr-total + tt-periodo.de-oc-conf-pr.

                END.
                    
                IF tt-param.l-oc-planejado THEN DO:
                    PUT UNFORMATTED
                        string(tt-periodo.de-oc-plan,"->>,>>>,>>>,>>9.99")    ";"
                        IF tt-periodo.de-oc-plan-pr > 0 THEN string(tt-periodo.de-oc-plan-pr,"->>,>>>,>>>,>>9.99") ELSE "0" ";".
                    ASSIGN tt-periodo.de-qt-total = tt-periodo.de-qt-total + tt-periodo.de-oc-plan
                           tt-periodo.de-pr-total = tt-periodo.de-pr-total + tt-periodo.de-oc-plan-pr.
                END.

                ASSIGN tt-periodo.de-pr-total = tt-periodo.de-pr-total + de-saldo-pr-ini - dec(tt-periodo.de-pv-pr + tt-periodo.de-pp-pr)
                       tt-periodo.de-qt-total = tt-periodo.de-qt-total + de-saldo-ini - dec(tt-periodo.de-res + tt-periodo.de-rpl + tt-periodo.de-pv)
                       de-saldo-ini    = tt-periodo.de-qt-total  /*Saldo inicial de cada periodo Ç o Saldo final do periodo anterior*/
                       de-saldo-pr-ini = tt-periodo.de-pr-total. /*Saldo inicial de cada periodo Ç o Saldo final do periodo anterior*/
                
                IF tt-periodo.de-qt-total < 0 THEN DO:
                    PUT 0 ";".
                    PUT 0 ";".
                END.
                ELSE DO:
                    PUT UNFORMATTED string(tt-periodo.de-qt-total,"->>,>>>,>>>,>>9.99") ";".
                  /*PUT UNFORMATTED string(tt-periodo.de-pr-total,"->>,>>>,>>>,>>9.99") ";".*/

                    IF  de-pr-item > 0 THEN
                        PUT UNFORMATTED string(tt-periodo.de-qt-total * de-pr-item,"->>,>>>,>>>,>>9.99") ";".
                    ELSE
                        PUT UNFORMATTED string(tt-periodo.de-qt-total * de-preco,"->>,>>>,>>>,>>9.99") ";".

                END.
            END.

            PUT SKIP. 

            EMPTY TEMP-TABLE tt-periodo.
            RUN pi-gera-periodo.

        END.

        OUTPUT CLOSE.

    END. /* DO ON STOP UNDO, LEAVE: */

END PROCEDURE.

/*------------------------------------------------------------------------------
  Purpose:  pi-relat   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
PROCEDURE pi-relat:   

    /*Saldo Atual*/
    ASSIGN de-saldo    = 0
           de-entregas = 0.

    FOR EACH saldo-estoq
       WHERE saldo-estoq.cod-estabel = item-uni-estab.cod-estabel
         AND saldo-estoq.it-codigo   = item-uni-estab.it-codigo NO-LOCK:

       IF tt-param.l-depos-saldo-diponivel THEN DO:


           IF ITEM.ge-codigo = 45 THEN  DO:

               IF  saldo-estoq.cod-depos <> "ACA"
               AND saldo-estoq.cod-depos <> "EXP" 
               AND saldo-estoq.cod-depos <> "WEX" THEN DO:

                   FIND FIRST deposito NO-LOCK
                        WHERE deposito.cod-depos = saldo-estoq.cod-depos NO-ERROR.
    
                   IF AVAILABLE deposito AND NOT deposito.cons-saldo THEN NEXT.
               END.

               ASSIGN de-saldo = de-saldo + saldo-estoq.qtidade-atu.
           END.

           ELSE DO:
               FIND FIRST deposito
                   WHERE deposito.cod-depos = saldo-estoq.cod-depos NO-LOCK NO-ERROR.
                   
               IF AVAILABLE deposito AND NOT deposito.cons-saldo THEN NEXT.

               ASSIGN de-saldo = de-saldo + saldo-estoq.qtidade-atu.

           END.               
       END.
       ELSE
           ASSIGN de-saldo = de-saldo + saldo-estoq.qtidade-atu.

    END.

    /*Preáo MÇdio R$*/
    ASSIGN de-pr-item  = 0
           de-saldo-pr = 0.

    FIND item-estab  NO-LOCK 
        WHERE item-estab.cod-estabel = item-uni-estab.cod-estabel 
          AND item-estab.it-codigo   = item-uni-estab.it-codigo  NO-ERROR.

    IF AVAIL item-estab THEN
        ASSIGN de-pr-item  = item-estab.val-unit-mat-m[1] + item-estab.val-unit-mob-m[1] + item-estab.val-unit-ggf-m[1].
                  
    RUN esp/es0018p.p (INPUT  "clientes-oem":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).
    ASSIGN c-clientes-oem = "".
    
    FOR EACH tt-prog-ponto:        
        FOR FIRST emitente NO-LOCK
            WHERE emitente.cod-emitente = int(tt-prog-ponto.conteudo):
    
            ASSIGN c-clientes-oem = c-clientes-oem + emitente.nome-abrev + ";".
        END.      
    END.
    
    IF LENGTH(c-clientes-oem) > 0 THEN
        ASSIGN c-clientes-oem = SUBSTRING(c-clientes-oem, 1, LENGTH(c-clientes-oem) - 1).

    ASSIGN de-preco-ul-ent  = 0
           de-pr-consumo    = 0
           de-pr-tab        = 0
           dt-ult-entrada   = ?
           de-preco         = 0.

    FOR LAST recebimento NO-LOCK USE-INDEX ITEM
        WHERE recebimento.it-codigo = ITEM.it-codigo,
        FIRST ordem-compra NO-LOCK
        WHERE ordem-compra.numero-ordem = recebimento.numero-ordem
          AND ordem-compra.cod-estabel  = item-uni-estab.cod-estabel:
         
        run cdp/cd0812.p (INPUT 0, 
                          INPUT 0,
                          INPUT recebimento.preco-unit,
                          INPUT recebimento.data-nota,
                          OUTPUT de-preco-ul-ent).

        ASSIGN dt-ult-entrada = recebimento.data-movto .
    END.

    /*Se preáo medio = 0 ent∆o valoriza estoque pelo preáo Ult.entrada*/
    IF de-pr-item > 0 THEN
        ASSIGN de-saldo-pr = de-pr-item * de-saldo.
    ELSE
        ASSIGN de-saldo-pr = de-preco-ul-ent * de-saldo.

    assign de-pr-consumo = de-pr-item. /*Preáo MÇdio*/
    
    if de-pr-consumo = 0 then
        assign de-pr-consumo = de-preco-ul-ent.  /*Preáo Ultima Entrada*/
        
    IF AVAIL item-fornec-estab THEN DO:
        FIND FIRST cond-pagto NO-LOCK
            WHERE cond-pagto.cod-cond-pag = item-fornec-estab.cod-cond-pag NO-ERROR.

         IF AVAIL cond-pagto THEN DO:
    
            FOR EACH tb-pr-cc NO-LOCK USE-INDEX ch-codigo
                WHERE tb-pr-cc.cod-emitente = item-fornec-estab.cod-emitente
                  AND tb-pr-cc.cod-cond-pag = cond-pagto.cod-cond-pag
                  AND tb-pr-cc.situacao     = 1
                  AND tb-pr-cc.dt-inicio   <= TODAY
                  AND tb-pr-cc.dt-termino  >= TODAY
                  AND tb-pr-cc.mo-codigo    = INT(SUBSTRING(item-fornec-estab.char-1,1,2)),
                FIRST item-tab NO-LOCK USE-INDEX tab-item
                WHERE item-tab.cod-emitente = tb-pr-cc.cod-emitente
                  AND item-tab.cod-cond-pag = tb-pr-cc.cod-cond-pag
                  AND item-tab.nr-tab       = tb-pr-cc.nr-tab
                  AND item-tab.dt-inicio    = tb-pr-cc.dt-inicio
                  AND item-tab.it-codigo    = item-fornec-estab.it-codigo:

                IF  de-pr-consumo = 0 then
                    ASSIGN de-pr-tab = item-tab.pr-item.

                /*BUSCAR E CONVERTER PREÄO DO ITEM*/

                /*Despesa = 2 , Converte com FI e Dolar informado */
                IF  INT(SUBSTRING(item-fornec-estab.char-1,1,2)) = 1 /*moeda*/ THEN DO: 

                    /*Estrangeiro*/
                    IF emitente.natureza = 3 THEN 
                        RUN pi-preco (INPUT item-tab.pr-item,
                                      INPUT 1, /* (FOB x Dolar) x FI */
                                      OUTPUT de-vl-unit).
                    ELSE
                        RUN pi-preco (INPUT item-tab.pr-item,
                                      INPUT 2, /* (FOB x Dolar) */
                                      OUTPUT de-vl-unit).
                END.
                ELSE
                    ASSIGN de-vl-unit = item-tab.pr-item.


                /* Converter para unidade de medida Intelbras */
                ASSIGN de-fator-conver = 1.
                IF  AVAIL item-fornec-estab THEN DO:
                    assign i-num-casa-dec = 1.
         
                    do i-cont = 1 to item-fornec-estab.num-casa-dec:
                        assign i-num-casa-dec = i-num-casa-dec * 10.
                    end.
         
                    assign de-fator-conver = item-fornec-estab.fator-conver / i-num-casa-dec.    
                END.

                ASSIGN de-preco = de-vl-unit * de-fator-conver.
            END.
        END.
    END.
   
    IF  de-pr-consumo = 0 THEN 
        assign de-pr-consumo = de-pr-tab.

           
    /*Consumo PP*/
    ASSIGN de-consumo-pp = 0.

    FOR EACH reservas NO-LOCK USE-INDEX planejamento
       WHERE reservas.it-codigo   = ITEM.it-codigo
         AND reservas.estado      = 1
         AND reservas.dt-reserva >= tt-param.periodo-ini
         AND reservas.dt-reserva <= tt-param.periodo-fim,
       FIRST ord-prod NO-LOCK
       WHERE ord-prod.nr-ord-produ = reservas.nr-ord-produ
         AND ord-prod.cod-estabel  = item-uni-estab.cod-estabel: 

        /* Comentado porque conforme Michel n∆o precisa validar deposito nas reservas - chamado 139040
        IF tt-param.l-depos-saldo-diponivel THEN DO:
            FIND FIRST deposito
                WHERE deposito.cod-depos = ordem-compra.dep-almoxar NO-LOCK NO-ERROR.
                
            IF AVAILABLE deposito AND NOT deposito.cons-saldo THEN
                IF  deposito.cod-depos <> "ACA" 
                AND deposito.cod-depos <> "EXP" 
                AND deposito.cod-depos <> "WEX" THEN
                   NEXT.                 
        END.   */

        FIND FIRST tt-periodo WHERE
                   tt-periodo.mes = MONTH(reservas.dt-reserva) AND
                   tt-periodo.ano = YEAR(reservas.dt-reserva)  NO-LOCK NO-ERROR.

        IF AVAIL tt-periodo THEN
            ASSIGN tt-periodo.de-res   = tt-periodo.de-res + dec(reservas.quant-orig - reservas.quant-atend)
                   de-consumo-pp       = de-consumo-pp + dec(reservas.quant-orig - reservas.quant-atend)
                   tt-periodo.de-pp-pr = tt-periodo.de-pp-pr + dec(dec(reservas.quant-orig - reservas.quant-atend) * de-pr-consumo).
    END.     
    
    FOR EACH it-periodo NO-LOCK 
       WHERE it-periodo.num-calc-plano = i-num-calc-plano 
         AND it-periodo.cod-estabel    = item-uni-estab.cod-estabel
         AND it-periodo.it-codigo      = item-uni-estab.it-codigo
         AND it-periodo.data          >= tt-param.periodo-ini
         AND it-periodo.data          <= tt-param.periodo-fim:

        IF tt-param.l-depos-saldo-diponivel THEN DO:
            FIND FIRST deposito
                WHERE deposito.cod-depos = ordem-compra.dep-almoxar NO-LOCK NO-ERROR.
                
            IF AVAILABLE deposito AND NOT deposito.cons-saldo THEN
                IF  deposito.cod-depos <> "ACA" 
                AND deposito.cod-depos <> "EXP" 
                AND deposito.cod-depos <> "WEX" THEN
                   NEXT.                 
        END. 

        FIND FIRST tt-periodo WHERE
                   tt-periodo.mes = MONTH(it-periodo.data) AND
                   tt-periodo.ano = YEAR(it-periodo.data)  NO-LOCK NO-ERROR.

        IF AVAIL tt-periodo THEN DO:

            FOR EACH res-aber NO-LOCK
               WHERE res-aber.num-id-it-periodo = it-periodo.num-id-it-periodo 
                 AND res-aber.it-codigo         = it-periodo.it-codigo
                 AND res-aber.cod-refer         = it-periodo.cod-refer
                 AND res-aber.ano               = it-periodo.ano       
                 AND res-aber.periodo           = it-periodo.periodo   
                 AND res-aber.cod-estabel       = it-periodo.cod-estabel
                 AND (res-aber.tipo-res         = 4 
                   OR res-aber.tipo-res         = 7):

                ASSIGN tt-periodo.de-rpl = tt-periodo.de-rpl + res-aber.quantidad.
            END.
       

            ASSIGN de-consumo-pp       = de-consumo-pp + it-periodo.qt-res-plan
                   tt-periodo.de-pp-pr = tt-periodo.de-pp-pr + dec(it-periodo.qt-res-plan * de-pr-consumo).
        END.
    END.

    IF ITEM.ge-codigo = 45 THEN DO:

        /*Consumo PV*/
        ASSIGN de-consumo-pv = 0
               de-ped-saldo  = 0
               de-saldo-item = 0.

        FOR EACH ped-ent FIELDS (it-codigo dt-entrega cd-sit-prog cod-sit-ent nome-abrev nr-pedcli nr-sequencia cod-refer
                                 qt-pedida qt-atendida qt-alocada qt-log-aloc char-2 qtd-aloc-op qtd-reporta-op-ped)
            WHERE ped-ent.it-codigo     = item-uni-estab.it-codigo
              AND ped-ent.dt-entrega   >= tt-param.periodo-ini
              AND ped-ent.dt-entrega   <= tt-param.periodo-fim
              AND (ped-ent.qt-log-aloca = 0 OR (ped-ent.qt-pedida - ped-ent.qt-log-aloca) > 0)
              AND  ped-ent.cd-sit-prog  = 2
              AND (ped-ent.cod-sit-ent  = 1 OR ped-ent.cod-sit-ent = 2 or ped-ent.cod-sit-ent = 4) NO-LOCK,
            FIRST ped-item FIELDS (nome-abrev   nr-pedcli    nr-sequencia   it-codigo
                                   cod-refer    nat-operacao ind-componen
                                   cod-sit-item it-codigo ind-componen)
            WHERE ped-item.nome-abrev   = ped-ent.nome-abrev
              AND ped-item.nr-pedcli    = ped-ent.nr-pedcli
              AND ped-item.nr-sequencia = ped-ent.nr-sequencia
              AND ped-item.it-codigo    = ped-ent.it-codigo
              AND ped-item.cod-refer    = ped-ent.cod-refer NO-LOCK:

            IF LOOKUP(ped-ent.nome-abrev, c-clientes-oem, ";") = 0 THEN NEXT.
    
            FOR FIRST natur-oper FIELDS (nat-operacao   baixa-estoq ind-entfu)
                WHERE natur-oper.nat-operacao = ped-item.nat-operacao NO-LOCK: END.
    
            IF (AVAIL natur-oper AND NOT natur-oper.baixa-estoq
                                 AND NOT natur-oper.ind-entfu) THEN NEXT.

            IF ped-item.ind-componen = 3 THEN DO:
                FIND FIRST b-ped-item
                    WHERE b-ped-item.nome-abrev   = ped-item.nome-abrev
                      AND b-ped-item.nr-pedcli    = ped-item.nr-pedcli
                      AND b-ped-item.nr-sequencia = ped-item.nr-sequencia
                      AND b-ped-item.ind-componen = 2 NO-LOCK NO-ERROR.
                FIND b3-item WHERE b3-item.it-codigo = b-ped-item.it-codigo NO-LOCK NO-ERROR.
                IF NOT AVAIL b-ped-item OR NOT AVAIL b3-item OR b3-item.baixa-estoq THEN NEXT.
            END.  

            FOR FIRST ped-venda FIELDS (nome-abrev   nr-pedcli cod-sit-aval cod-estabel)
                WHERE ped-venda.nome-abrev  = ped-item.nome-abrev
                  AND ped-venda.nr-pedcli   = ped-item.nr-pedcli
                  AND ped-venda.completo      
                  AND ped-venda.cod-estabel = item-uni-estab.cod-estabel
                  AND NOT ped-venda.log-cotacao  NO-LOCK: END.

            IF AVAIL ped-venda THEN DO:
                
                IF ped-item.ind-componen = 2 THEN DO:              
                    /*------------------------------------------------------------*
                     * Procura um pedido de Produto Configurado                   *
                     *         A                                                  *
                     *     +---+---+   onde A eh ind-componen 1 (Configurado)     *
                     *     B       C        B e C ind-conponen 2 (Comp.do Config) *
                     * Neste caso,se A nao baixa estoque, deve considerar o pedido*
                     * de B ou C.                                                 *
                     *------------------------------------------------------------*/
    
                     FOR FIRST b-ped-item FIELDS (nome-abrev   nr-pedcli   nr-sequencia ind-componen it-codigo)
                        WHERE b-ped-item.nome-abrev   = ped-item.nome-abrev
                          AND b-ped-item.nr-pedcli    = ped-item.nr-pedcli
                          AND b-ped-item.nr-sequencia = ped-item.nr-sequencia
                          AND b-ped-item.ind-componen = 1 NO-LOCK: END.
                     IF AVAIL b-ped-item THEN  
                         FOR FIRST b1-item FIELDS (it-codigo   baixa-estoq)
                             WHERE b1-item.it-codigo = b-ped-item.it-codigo NO-LOCK: END.
                     /*-----------------------------------------------------* 
                      * Se nao encontrou ped-item com ind-componen 1,
                      * ou nao achou o item do b-ped-item, ou o item localizado
                      * baixa estoque, entao nao considera o ped b-item.
                      *-----------------------------------------------------*/
                      IF NOT AVAIL b-ped-item
                      OR NOT AVAIL b1-item 
                      OR b1-item.baixa-estoq THEN NEXT.
                END.
    
                ASSIGN de-saldo-item = 
                       IF (ped-ent.qt-pedida - ped-ent.qt-atendida ) > 0 THEN 
                          (ped-ent.qt-pedida - ped-ent.qt-atendida )      ELSE 0
                       de-saldo-aloc = 
                       IF (ped-ent.qt-alocada - ped-ent.qt-atendida)  > 0 THEN
                          (ped-ent.qt-alocada - ped-ent.qt-atendida)      ELSE 0.        
                       de-ped-saldo  =  (de-saldo-item - de-saldo-aloc).
                       
                IF ((ped-ent.qt-pedida - ped-ent.qt-log-aloc) >= 0) THEN
                    ASSIGN de-ped-saldo = de-ped-saldo - ped-ent.qt-log-aloc.
                  
                IF (( ped-ent.qtd-aloc-op - ped-ent.qtd-reporta-op-ped) > 0) THEN
                    ASSIGN de-ped-saldo = de-ped-saldo + 
                                          ped-ent.qtd-aloc-op -  /* quantidade alocada na producao */
                                          ped-ent.qtd-reporta-op-ped. /* quantidade reportada */
                
                  
                FIND FIRST tt-periodo WHERE
                           tt-periodo.mes = MONTH(ped-ent.dt-entrega) AND
                           tt-periodo.ano = YEAR(ped-ent.dt-entrega)  NO-LOCK NO-ERROR.
            
                IF AVAIL tt-periodo THEN 
                    ASSIGN tt-periodo.de-pv    = tt-periodo.de-pv + de-ped-saldo
                           tt-periodo.de-pv-pr = tt-periodo.de-pv-pr + dec(de-ped-saldo * de-pr-consumo)
                           de-consumo-pv       = de-consumo-pv + de-ped-saldo.
            END.
        END.   
    END.

    ASSIGN de-vl-unit = 0
           de-pr-ped  = 0.


    /*PO Embarcados e Confirmados*/
    FOR EACH ordem-compra NO-LOCK
        WHERE ordem-compra.cod-estabel    = item-uni-estab.cod-estabel
          AND ordem-compra.situacao       = 2 /*Confirmada*/ 
          AND ordem-compra.it-codigo      = item-uni-estab.it-codigo,
        FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = ordem-compra.it-codigo,
        FIRST pedido-compr NO-LOCK
        WHERE pedido-compr.num-pedido = ordem-compra.num-pedido,
         EACH prazo-compra OF ordem-compra NO-LOCK
        WHERE prazo-compra.situacao     = 2 /*Confirmada*/ 
          AND prazo-compra.data-entrega >= tt-param.periodo-ini
          AND prazo-compra.data-entrega <= tt-param.periodo-fim:

         IF tt-param.l-depos-saldo-diponivel THEN DO:
            FIND FIRST deposito
                WHERE deposito.cod-depos = ordem-compra.dep-almoxar NO-LOCK NO-ERROR.
                
            IF AVAILABLE deposito AND NOT deposito.cons-saldo THEN
                IF  deposito.cod-depos <> "ACA" 
                AND deposito.cod-depos <> "EXP" 
                AND deposito.cod-depos <> "WEX" THEN
                   NEXT.                 
        END.                

        FIND FIRST tt-periodo WHERE
                   tt-periodo.mes = MONTH(prazo-compra.data-entrega) AND
                   tt-periodo.ano = YEAR(prazo-compra.data-entrega)  NO-LOCK NO-ERROR.

        FIND FIRST cotacao-item NO-LOCK 
             WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
               AND cotacao-item.cod-emitente = ordem-compra.cod-emitente NO-ERROR.
    
        IF AVAIL cotacao-item THEN 
            FIND FIRST itinerario NO-LOCK 
                 WHERE itinerario.cod-itiner = cotacao-item.int-1 NO-ERROR.

        FIND LAST ordens-embarque NO-LOCK 
            WHERE ordens-embarque.numero-ordem = prazo-compra.numero-ordem 
              AND ordens-embarque.parcela      = prazo-compra.parcela NO-ERROR.
    
        FIND FIRST embarque-imp NO-LOCK 
             WHERE embarque-imp.cod-estabel = ordens-embarque.cod-estabel 
               AND embarque-imp.embarque    = ordens-embarque.embarque NO-ERROR.

        ASSIGN de-pr-ped = ordem-compra.preco-unit.

        /*Custo MÇdio*/
        IF   de-pr-item > 0  THEN
             ASSIGN de-vl-unit = de-pr-item.
        ELSE
             ASSIGN de-vl-unit = de-preco.

        /*Se n∆o tem embarque ent∆o soma na PO Confirmado */
        IF NOT AVAIL embarque-imp THEN DO:
            IF AVAIL tt-periodo THEN DO:
                ASSIGN tt-periodo.de-po-conf    = tt-periodo.de-po-conf + prazo-compra.quantidade
                       tt-periodo.de-po-conf-pr = tt-periodo.de-po-conf-pr  + DEC(prazo-compra.quantidade * de-vl-unit)
                       de-entregas = de-entregas + tt-periodo.de-po-conf.
            END.
        END.
        ELSE DO:
        
            FIND FIRST historico-embarque OF embarque-imp NO-LOCK 
                 WHERE historico-embarque.cod-pto-contr = itinerario.pto-despacho NO-ERROR.
        
            IF AVAIL historico-embarque AND
                     historico-embarque.dt-efetiva = ? 
            THEN DO:
                IF AVAIL tt-periodo THEN DO:
                    ASSIGN tt-periodo.de-po-conf = tt-periodo.de-po-conf + prazo-compra.quantidade
                           tt-periodo.de-po-conf-pr = tt-periodo.de-po-conf-pr  + DEC(prazo-compra.quantidade * de-vl-unit)
                           de-entregas = de-entregas + tt-periodo.de-po-conf.
                END.
            END.
            ELSE DO:
                IF AVAIL tt-periodo THEN DO:
                    ASSIGN tt-periodo.de-po-emb    = tt-periodo.de-po-emb + prazo-compra.quantidade
                           tt-periodo.de-po-emb-pr = tt-periodo.de-po-emb-pr  + DEC(prazo-compra.quantidade * de-vl-unit)
                           de-entregas = de-entregas + tt-periodo.de-po-emb.
                END.
            END.
        END.
        
    END.

    ASSIGN de-pr-ped  = 0
           de-vl-unit = 0. 

    /*OC Confirmadas*/
    FOR EACH ordem-compra NO-LOCK
        WHERE ordem-compra.cod-estabel    = item-uni-estab.cod-estabel
          AND ordem-compra.it-codigo      = item-uni-estab.it-codigo
          AND (ordem-compra.situacao       = 3   /*Cotada*/ 
            OR ordem-compra.situacao       = 5), /*Em cotaá∆o*/
        FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = ordem-compra.it-codigo,
        EACH prazo-compra NO-LOCK
        WHERE prazo-compra.numero-ordem  = ordem-compra.numero-ordem
          AND prazo-compra.it-codigo     = ordem-compra.it-codigo
          AND prazo-compra.situacao     <> 4 
          AND prazo-compra.situacao     <> 6
          AND prazo-compra.data-entrega >= tt-param.periodo-ini
          AND prazo-compra.data-entrega <= tt-param.periodo-fim:
        
        IF tt-param.l-depos-saldo-diponivel THEN DO:
            FIND FIRST deposito
                WHERE deposito.cod-depos = ordem-compra.dep-almoxar NO-LOCK NO-ERROR.
                
            IF AVAILABLE deposito AND NOT deposito.cons-saldo THEN
                IF ITEM.ge-codigo = 45 THEN
                    IF  deposito.cod-depos <> "ACA" 
                    AND deposito.cod-depos <> "EXP" 
                    AND deposito.cod-depos <> "WEX" THEN NEXT. 
                ELSE NEXT.
        END. 

        FIND FIRST tt-periodo WHERE
                   tt-periodo.mes = MONTH(prazo-compra.data-entrega) AND
                   tt-periodo.ano =  YEAR(prazo-compra.data-entrega) NO-LOCK NO-ERROR.

        FIND FIRST cotacao-item NO-LOCK 
             WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
               AND cotacao-item.cod-emitente = ordem-compra.cod-emitente NO-ERROR.

        IF AVAIL cotacao-item THEN
            ASSIGN de-pr-ped = cotacao-item.preco-unit.

         /*Custo MÇdio*/
         IF  de-pr-item > 0  THEN
             ASSIGN de-vl-unit = de-pr-item.
         ELSE
             ASSIGN de-vl-unit = de-preco.

        IF  AVAIL tt-periodo THEN DO:
            ASSIGN tt-periodo.de-oc-conf    = tt-periodo.de-oc-conf + ordem-compra.qt-solic
                   tt-periodo.de-oc-conf-pr = tt-periodo.de-oc-conf-pr + DEC(ordem-compra.qt-solic * (de-vl-unit))
                   de-entregas = de-entregas + tt-periodo.de-oc-conf.
        END.
        
    END.

    ASSIGN de-pr-tab  = 0
           de-vl-unit = 0.

    /*OC N«O Confirmadas*/
    FOR EACH ordem-compra NO-LOCK
        WHERE ordem-compra.cod-estabel    = item-uni-estab.cod-estabel
          AND ordem-compra.it-codigo      = item-uni-estab.it-codigo
          AND ordem-compra.situacao       = 1 /*N∆o confirmada*/ ,
        FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = ordem-compra.it-codigo,
        EACH prazo-compra NO-LOCK
        WHERE prazo-compra.numero-ordem  = ordem-compra.numero-ordem
          AND prazo-compra.it-codigo     = ordem-compra.it-codigo
          AND prazo-compra.situacao     <> 4 
          AND prazo-compra.situacao     <> 6
          AND prazo-compra.data-entrega >= tt-param.periodo-ini
          AND prazo-compra.data-entrega <= tt-param.periodo-fim:
        
        IF tt-param.l-depos-saldo-diponivel THEN DO:
            FIND FIRST deposito
                WHERE deposito.cod-depos = ordem-compra.dep-almoxar NO-LOCK NO-ERROR.
                
            IF AVAILABLE deposito AND NOT deposito.cons-saldo THEN
                IF  deposito.cod-depos <> "ACA" 
                AND deposito.cod-depos <> "EXP" 
                AND deposito.cod-depos <> "WEX" THEN
                   NEXT.                 
        END. 

        FIND FIRST tt-periodo WHERE
                   tt-periodo.mes = MONTH(prazo-compra.data-entrega) AND
                   tt-periodo.ano =  YEAR(prazo-compra.data-entrega) NO-LOCK NO-ERROR.

        FIND FIRST cotacao-item NO-LOCK 
             WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
               AND cotacao-item.cod-emitente = ordem-compra.cod-emitente NO-ERROR.

        IF AVAIL cotacao-item THEN
            ASSIGN de-pr-ped = cotacao-item.preco-unit.

        /*Custo MÇdio*/
        IF  de-pr-item > 0  THEN
            ASSIGN de-vl-unit = de-pr-item.
        ELSE
            ASSIGN de-vl-unit = de-preco.

        IF AVAIL tt-periodo THEN 
            ASSIGN tt-periodo.de-oc-nao-conf    = tt-periodo.de-oc-nao-conf    + ordem-compra.qt-solic
                   tt-periodo.de-oc-nao-conf-pr = tt-periodo.de-oc-nao-conf-pr + DEC(ordem-compra.qt-solic * de-vl-unit)
                   de-entregas                  = de-entregas + tt-periodo.de-oc-nao-conf.          
    END.

    ASSIGN de-pr-tab  = 0
           de-vl-unit = 0.

    /*OC Planejadas*/
    FOR EACH it-periodo NO-LOCK 
       WHERE it-periodo.num-calc-plano = i-num-calc-plano 
         AND it-periodo.cod-estabel    = item-uni-estab.cod-estabel
         AND it-periodo.it-codigo      = item-uni-estab.it-codigo
         AND it-periodo.data          >= tt-param.periodo-ini
         AND it-periodo.data          <= tt-param.periodo-fim,
       FIRST ITEM NO-LOCK
       WHERE ITEM.it-codigo            = it-periodo.it-codigo
         AND ITEM.compr-fabric         = 1: /*Somente itens comprados geram ordens de compra*/

        FOR FIRST item-fornec-estab 
            WHERE item-fornec-estab.it-codigo     = item-uni-estab.it-codigo
              AND item-fornec-estab.cod-estabel   = item-uni-estab.cod-estabel
              AND item-fornec-estab.ativo         = YES
              AND item-fornec-estab.cot-aut       = YES
              AND item-fornec-estab.perc-compra   > 0 NO-LOCK:                   
        END.

        IF AVAIL item-fornec-estab THEN DO:
            FIND FIRST cond-pagto NO-LOCK
                 WHERE cond-pagto.cod-cond-pag = item-fornec-estab.cod-cond-pag NO-ERROR.
    
            IF AVAIL cond-pagto THEN DO:
                
                FOR EACH tb-pr-cc NO-LOCK USE-INDEX ch-codigo
                    WHERE tb-pr-cc.cod-emitente = item-fornec-estab.cod-emitente
                      AND tb-pr-cc.cod-cond-pag = cond-pagto.cod-cond-pag
                      AND tb-pr-cc.situacao     = 1
                      AND tb-pr-cc.dt-inicio   <= TODAY
                      AND tb-pr-cc.dt-termino  >= TODAY
                      AND tb-pr-cc.mo-codigo    = INT(SUBSTRING(item-fornec-estab.char-1,1,2)),
                    FIRST item-tab NO-LOCK USE-INDEX tab-item
                    WHERE item-tab.cod-emitente = tb-pr-cc.cod-emitente
                      AND item-tab.cod-cond-pag = tb-pr-cc.cod-cond-pag
                      AND item-tab.nr-tab       = tb-pr-cc.nr-tab
                      AND item-tab.dt-inicio    = tb-pr-cc.dt-inicio
                      AND item-tab.it-codigo    = item-fornec-estab.it-codigo:
                    ASSIGN de-pr-tab = item-tab.pr-item.
                END.
            END.
        END.

        FIND FIRST tt-periodo WHERE
                   tt-periodo.mes = MONTH(it-periodo.data) AND
                   tt-periodo.ano = YEAR(it-periodo.data)  NO-LOCK NO-ERROR.

         /* Custo MÇdio */
         IF  de-pr-item > 0  THEN
             ASSIGN de-vl-unit = de-pr-item.
         ELSE 
             ASSIGN de-vl-unit = de-preco.

        IF  AVAIL tt-periodo
        AND it-periodo.qt-ord-plan > 0 THEN DO:
            ASSIGN tt-periodo.de-oc-plan    = tt-periodo.de-oc-plan + it-periodo.qt-ord-plan
                   tt-periodo.de-oc-plan-pr = tt-periodo.de-oc-plan-pr + DEC(it-periodo.qt-ord-plan * de-vl-unit)
                   de-entregas = de-entregas + tt-periodo.de-oc-plan.
        END.
    END.

    IF  tt-param.l-saldo 
    AND de-consumo-pp + de-consumo-pv <= 0 
    AND de-saldo     <= 0
    AND de-entregas  <= 0  THEN 
        RETURN 'NOK':U.     

    RETURN 'OK'.

END PROCEDURE.
/*------------------------------------------------------------------------------
  Purpose:  pi-gera-periodo   
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
PROCEDURE pi-gera-periodo:

    EMPTY TEMP-TABLE tt-periodo.

    ASSIGN dt-aux = tt-param.periodo-ini.

    DO WHILE(dt-aux <= tt-param.periodo-fim):
        CREATE tt-periodo.
        ASSIGN tt-periodo.mes    = MONTH(dt-aux)
               tt-periodo.ano    = YEAR(dt-aux)
               tt-periodo.anomes = STRING(YEAR(dt-aux), "9999":U) + STRING(MONTH(dt-aux), "99":U).

        ASSIGN dt-aux = ADD-INTERVAL(dt-aux, 1, "MONTHS":U).
    END.

    RETURN "OK":U.

END PROCEDURE.

/*------------------------------------------------------------------------------
  Purpose:  pi-gera-periodo   
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
PROCEDURE pi-preco:

    DEF INPUT  PARAM p-valor   AS DEC NO-UNDO.
    DEF INPUT  PARAM p-tipo    AS INT NO-UNDO.
    DEF OUTPUT PARAM p-convert AS DEC NO-UNDO.

    IF p-tipo = 1 THEN 
        ASSIGN p-convert = DEC((p-valor * tt-param.valor-dolar) * tt-param.valor-fi). /*Fornecedor Internacional*/ 
    ELSE
        ASSIGN p-convert = DEC(p-valor * tt-param.valor-dolar). /*Fornecedor nacional com pedido em Dolar*/ 
              
END PROCEDURE.
