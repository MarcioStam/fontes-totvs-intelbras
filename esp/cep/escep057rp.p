{include/i-prgvrs.i ESCEP057 2.04.00.000}
/***********************************************************************
**  Programa..: ESP\CEP\ESCEP057RP.P
************************************************************************/

/****************************  Definitions  ****************************/
{esp/cep/escep057tt.i}

{utp/ut-glob.i}
{include/i-rpvar.i}

/****************************  Temp-Tables  ****************************/
DEFINE TEMP-TABLE tt-impressao NO-UNDO
    FIELD it-codigo         AS CHAR
    FIELD desc-item         AS CHAR
    FIELD narrativa         AS CHAR
    FIELD narrativa-suframa AS CHAR
    FIELD projeto           AS CHAR
    FIELD controle          AS CHAR
    FIELD seq-suframa       LIKE int-item.seq-suframa
    FIELD class-fiscal      LIKE ITEM.class-fiscal
    FIELD destaque          LIKE int-item.destaque
    FIELD necessita-li      AS CHAR
    FIELD nve               LIKE int-item.nve
    FIELD ex-tarifario      LIKE int-item.ex-tarifario
    FIELD exIPI             LIKE int-item.exIPI
    FIELD aliquota-ii       AS CHAR
    FIELD aliquota-ipi      LIKE ITEM.aliquota-ipi
    FIELD pis-ext           AS DEC
    FIELD cofins-ext        AS DEC
    FIELD cofins-majorado   AS DEC
    FIELD pis-majorado      AS DEC
    FIELD pis-nacional      AS DEC
    FIELD cofins-nacional   AS DEC
    FIELD cest              AS CHAR
    FIELD origem            LIKE ITEM.codigo-orig
    FIELD ge-codigo         LIKE ITEM.ge-codigo
    FIELD fm-codigo         LIKE ITEM.fm-codigo
    FIELD fm-cod-com        LIKE ITEM.fm-cod-com
    FIELD cod-obsoleto      AS CHAR
    FIELD item-fat          AS CHAR
    FIELD tp-item           AS CHAR
    FIELD peso-bruto        LIKE ITEM.peso-bruto
    FIELD peso-liquido      LIKE ITEM.peso-liquido
    FIELD altura            LIKE ITEM.altura
    FIELD largura           LIKE ITEM.largura
    FIELD comprimento       LIKE ITEM.comprim
    FIELD cod-unid-negoc    LIKE ITEM.cod-unid-negoc
    FIELD sigla-emb         AS CHAR
    FIELD altura-emb        AS DEC
    FIELD largura-emb       AS DEC
    FIELD comprimento-emb   AS DEC
    FIELD part-number       AS CHAR
    FIELD cod-fabricante    AS INT
    FIELD nome-fabricante   AS CHAR
    FIELD cod-ean           AS CHAR
    FIELD cod-dcr-item      AS CHAR.

/****************************  Frames       ****************************/
DEF INPUT PARAMETER raw-param as raw no-undo.
DEF INPUT PARAMETER table for tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

DEF VAR h-acomp      as handle no-undo.
def var c-separador  as char format "x(01)".
FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK WHERE
          empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Listagem Informa‡äes Itens"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "ESCEP057"
       c-versao       = "2.04"
       c-revisao      = "002".

assign c-separador = ";".

/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:    

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  

    EMPTY TEMP-TABLE tt-impressao.
    
    RUN piRelat.

    {include/i-rpcab.i}
    {include/i-rpout.i &pagesize="0"}

    RUN pi-inicializar IN h-acomp (INPUT "Imprimindo...").

    RUN piImpressao.

    RUN pi-finalizar in h-acomp.
    {include/i-rpclo.i}
    RETURN "OK".
END.

PROCEDURE piImpressao:

    PUT UNFORMATTED
        "Item;Descricao;".

    IF tt-param.l-imprime-narrativa THEN 
        PUT UNFORMATTED "Narrativa;Narrativa Suframa;".

    PUT UNFORMATTED 
        "Num.Proj.Suframa;Controlado;Seq Suframa;NCM;Destaque;LI;NVE;EX II;EX IPI;II(%);IPI(%);PIS EXT;COFINS EXT;PIS Majorado;COFINS Majorado;PIS;COFINS;CEST;Origem;"
        "GE;Fam.Material;Fam.Comercial;Obsoleto;ItemFat;TpItem;".
            
    IF tt-param.l-peso-medida THEN
        PUT UNFORMATTED "Peso Bruto;Peso Liq;Altura;Largura;Comprimento;".
        
    PUT UNFORMATTED "Uni.Neg;Sigla;".
        
    IF tt-param.l-peso-medida THEN
        PUT UNFORMATTED "Altura;Largura;Comprimento;".
        
    IF l-panumber-fabric THEN
        PUT UNFORMATTED "Part Number;Cod.Fabricante;Nome do Fabricante;".
        
     PUT UNFORMATTED "EAN;DCR Item" SKIP.

    FOR EACH tt-impressao.

        RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo Item: " + tt-impressao.it-codigo).                
        /*PUT UNFORMATTED
            ITEM.it-codigo                                               ";"
            TRIM(REPLACE(REPLACE(REPLACE(ITEM.desc-item,CHR(10),""),CHR(13),""),";","-")) ";"
            IF tt-param.l-imprime-narrativa THEN TRIM(c-narrativa) + ";" ELSE "" FORMAT "x(500)"
            trim(c-narrativa-manaus) FORMAT "x(500)"                     ";"
            trim(c-projeto) FORMAT "x(500)"                              ";"
            trim(c-controle) FORMAT "x(500)"                             ";"
            int-item.seq-suframa                                         ";"
            ITEM.class-fiscal                                            ";"
            int-item.destaque                                            ";"
            ITEM.log-necessita-li FORMAT "Sim/Nao"                       ";" 
            int-item.nve                                                 ";"
            if int-item.ex-tarifario <> "" then int-item.ex-tarifario else "NA" ";"
            if int-item.exIPI <> "" then int-item.exIPI else "NA" ";"
            SUBSTR(ITEM.char-2,22,6)                                     ";"
            ITEM.aliquota-ipi                                            ";"
            
            ITEM.ge-codigo                                               ";"
            ITEM.fm-codigo                                               ";"
            ITEM.fm-cod-com                                              ";"
            ENTRY(ITEM.cod-obsoleto,c-cod-obsoleto,",")                  ";"
            ENTRY(item.tipo-contr  ,c-tipo-contr,",")                    ";"
            i-tp-desp-padrao                                             ";"
            STRING(ITEM.ind-item-fat,"Sim/Nao")                          ";"
            c-tp-item                                                   SKIP.*/
        PUT UNFORMATTED
            tt-impressao.it-codigo            ";"
            tt-impressao.desc-item            ";".

        IF tt-param.l-imprime-narrativa THEN
            PUT UNFORMATTED 
            tt-impressao.narrativa            ";"
            tt-impressao.narrativa-suframa    ";".

        PUT UNFORMATTED 
            tt-impressao.projeto              ";"
            tt-impressao.controle             ";"
            tt-impressao.seq-suframa          ";"
            tt-impressao.class-fiscal         ";"
            tt-impressao.destaque             ";"
            tt-impressao.necessita-li         ";"
            tt-impressao.nve                  ";"
            tt-impressao.ex-tarifario         ";"
            tt-impressao.exIPI                ";"
            tt-impressao.aliquota-ii          ";"
            tt-impressao.aliquota-ipi         ";"
            tt-impressao.pis-ext              ";"
            tt-impressao.cofins-ext           ";"            
            tt-impressao.pis-majorado         ";"
            tt-impressao.cofins-majorado      ";"
            tt-impressao.pis-nacional         ";"
            tt-impressao.cofins-nacional      ";"
            tt-impressao.cest                 ";"
            tt-impressao.origem               ";"
            tt-impressao.ge-codigo            ";"
            tt-impressao.fm-codigo            ";"
            tt-impressao.fm-cod-com           ";"
            tt-impressao.cod-obsoleto         ";"
            tt-impressao.item-fat             ";"
            tt-impressao.tp-item              ";".

        IF tt-param.l-peso-medida THEN
            PUT UNFORMATTED tt-impressao.peso-bruto           ";"
                            tt-impressao.peso-liquido         ";"
                            tt-impressao.altura               ";"
                            tt-impressao.largura              ";"
                            tt-impressao.comprimento          ";".

        PUT UNFORMATTED    
            tt-impressao.cod-unid-negoc       ";"
            tt-impressao.sigla-emb            ";".

        IF tt-param.l-peso-medida THEN
            PUT UNFORMATTED 
            tt-impressao.altura-emb           ";"
            tt-impressao.largura-emb          ";"
            tt-impressao.comprimento-emb      ";".

        IF tt-param.l-panumber-fabric THEN
            PUT UNFORMATTED 
                tt-impressao.part-number          ";"
                tt-impressao.cod-fabricante       ";"
                tt-impressao.nome-fabricante      ";".

        PUT UNFORMATTED 
            tt-impressao.cod-ean ";"
            tt-impressao.cod-dcr-item           SKIP.
    END.
    
END PROCEDURE.

PROCEDURE piRelat:

    DEFINE VARIABLE i-num-calc-plano   AS INTEGER  NO-UNDO.
    DEFINE VARIABLE l-tem-consumo      AS LOGICAL  NO-UNDO.

    DEFINE VARIABLE c-mensagem      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE h-esmsspapi001 AS HANDLE      NO-UNDO.

    DEFINE VARIABLE i-cest AS INTEGER     NO-UNDO.
   
    RUN esp/mssp/esmsspapi001.p PERSISTENT SET h-esmsspapi001.

    RUN pi-inicializar IN h-acomp (INPUT "Gerando dados...").

    FIND FIRST pl-prod WHERE pl-prod.cd-plano = tt-param.cd-plano NO-LOCK NO-ERROR.
    ASSIGN i-num-calc-plano = IF AVAIL pl-prod THEN pl-prod.num-calc-plano ELSE 0.                                                                                        

    FOR EACH ITEM NO-LOCK
       WHERE ITEM.ge-codigo    >= tt-param.ge-codigo-ini    AND ITEM.ge-codigo    <= tt-param.ge-codigo-fim
         AND ITEM.it-codigo    >= tt-param.it-codigo-ini    AND ITEM.it-codigo    <= tt-param.it-codigo-fim
         AND ITEM.class-fiscal >= tt-param.class-fiscal-ini AND ITEM.class-fiscal <= tt-param.class-fiscal-fim
         AND ITEM.fm-codigo    >= tt-param.fm-codigo-ini    AND ITEM.fm-codigo    <= tt-param.fm-codigo-fim
         AND ITEM.fm-cod-com   >= tt-param.fm-cod-com-ini   AND ITEM.fm-cod-com   <= tt-param.fm-cod-com-fim,
       FIRST int-item OF ITEM NO-LOCK:
    
        IF NOT tt-param.l-ativo          AND ITEM.cod-obsoleto = 1 THEN NEXT.
        IF NOT tt-param.l-obso-ord-aut   AND ITEM.cod-obsoleto = 2 THEN NEXT.
        IF NOT tt-param.l-obso-todas-ord AND ITEM.cod-obsoleto = 3 THEN NEXT.
        IF NOT tt-param.l-total-obsoleto AND ITEM.cod-obsoleto = 4 THEN NEXT.

        RUN pi-acompanhar IN h-acomp (INPUT "Gerando Dados Item: " + item.it-codigo).                

        IF tt-param.l-somente-consumo THEN DO:

            ASSIGN l-tem-consumo = NO.
            FOR FIRST reservas NO-LOCK USE-INDEX planejamento
                WHERE reservas.it-codigo   = ITEM.it-codigo
                  AND reservas.estado      = 1
                  AND reservas.dt-reserva >= tt-param.periodo-ini
                  AND reservas.dt-reserva <= tt-param.periodo-fim:

                  ASSIGN l-tem-consumo = yes.
            END.

            IF NOT l-tem-consumo THEN DO:
                FOR FIRST it-periodo NO-LOCK 
                    WHERE it-periodo.num-calc-plano = i-num-calc-plano 
                      AND it-periodo.cod-estabel    = tt-param.cod-estabel
                      AND it-periodo.it-codigo      = ITEM.it-codigo
                      AND it-periodo.data          >= tt-param.periodo-ini
                      AND it-periodo.data          <= tt-param.periodo-fim:

                    ASSIGN l-tem-consumo = YES.
                END.
            END.

            IF NOT l-tem-consumo THEN NEXT.
        END.

        CREATE tt-impressao.
        ASSIGN tt-impressao.it-codigo = ITEM.it-codigo
               tt-impressao.desc-item = TRIM(REPLACE(REPLACE(REPLACE(ITEM.desc-item,CHR(10),""),CHR(13),""),";","-")). 
               tt-impressao.narrativa  = TRIM(ITEM.narrativa).

        FIND FIRST item-uni-estab NO-LOCK
             WHERE item-uni-estab.it-codigo   = ITEM.it-codigo
               AND item-uni-estab.cod-estabel = tt-param.cod-estabel NO-ERROR.
        IF AVAIL item-uni-estab THEN DO:            

            CASE SUBSTRING(item-uni-estab.char-1, 133,1):
                WHEN "0" THEN ASSIGN tt-impressao.tp-item = "0-Mercadoria para Revenda".
                WHEN "1" THEN ASSIGN tt-impressao.tp-item = "1-Mat‚ria-prima".
                WHEN "2" THEN ASSIGN tt-impressao.tp-item = "2-Embalagem".
                WHEN "3" THEN ASSIGN tt-impressao.tp-item = "3-Produto em Processo".
                WHEN "4" THEN ASSIGN tt-impressao.tp-item = "4-Produto Acabado".
                WHEN "5" THEN ASSIGN tt-impressao.tp-item = "5-Subproduto".
                WHEN "6" THEN ASSIGN tt-impressao.tp-item = "6-Produto Intermedi rio".
                WHEN "7" THEN ASSIGN tt-impressao.tp-item = "7-Material de Uso e Consumo".
                WHEN "8" THEN ASSIGN tt-impressao.tp-item = "8-Ativo Imobilizado".
                WHEN "9" THEN ASSIGN tt-impressao.tp-item = "9-Servi‡os".
                WHEN "a" THEN ASSIGN tt-impressao.tp-item = "a-Outros Insumos".
                WHEN "b" THEN ASSIGN tt-impressao.tp-item = "b-Outras".
            OTHERWISE ASSIGN tt-impressao.tp-item = "Nao Informado".
            END CASE.
        END.        

        IF INDEX(ITEM.narrativa,'#MANAUS#') <> 0 THEN
            ASSIGN tt-impressao.narrativa         = SUBSTRING(ITEM.narrativa,1,INDEX(ITEM.narrativa,'#MANAUS#') - 1)
                   tt-impressao.narrativa-suframa = SUBSTRING(ITEM.narrativa,INDEX(ITEM.narrativa,'#MANAUS#'))
                   tt-impressao.narrativa-suframa = REPLACE(tt-impressao.narrativa-suframa,'#MANAUS#','').

        FOR EACH  item-proj-suframa NO-LOCK 
            WHERE item-proj-suframa.it-codigo = ITEM.it-codigo:

            IF tt-impressao.projeto = "" THEN
                ASSIGN tt-impressao.projeto  = STRING(item-proj-suframa.nr-projeto).
            ELSE
                ASSIGN tt-impressao.projeto  = tt-impressao.projeto + "," + STRING(item-proj-suframa.nr-projeto).            

            IF tt-impressao.controle = "" THEN
                ASSIGN tt-impressao.controle = STRING(item-proj-suframa.controlado,"Sim/Nao").
            ELSE
                ASSIGN tt-impressao.controle = tt-impressao.controle + "," + STRING(item-proj-suframa.controlado,"Sim/Nao").
        END.

        ASSIGN tt-impressao.narrativa         = REPLACE(REPLACE(REPLACE(tt-impressao.narrativa,';','-'),CHR(13),''),CHR(10),'')
               tt-impressao.narrativa-suframa = REPLACE(REPLACE(REPLACE(tt-impressao.narrativa-suframa,';','-'),CHR(13),''),CHR(10),'')
               tt-impressao.seq-suframa       = int-item.seq-suframa
               tt-impressao.class-fiscal      = ITEM.class-fiscal
               tt-impressao.destaque          = int-item.destaque
               tt-impressao.necessita-li      = STRING(ITEM.log-necessita-li,"Sim/Nao")
               tt-impressao.nve               = REPLACE(REPLACE(REPLACE(int-item.nve,';','-'),CHR(13),''),CHR(10),'')
               tt-impressao.ex-tarifario      = int-item.ex-tarifario
               tt-impressao.exIPI             = int-item.exIPI
               tt-impressao.aliquota-ii       = SUBSTR(ITEM.char-2,22,6)
               tt-impressao.aliquota-ipi      = ITEM.aliquota-ipi
               tt-impressao.pis-nacional      = dec(substr(item.char-2,31,5))
               tt-impressao.cofins-nacional   = dec(substr(item.char-2,36,5))
               tt-impressao.origem            = ITEM.codigo-orig
               tt-impressao.ge-codigo         = ITEM.ge-codigo
               tt-impressao.fm-codigo         = ITEM.fm-codigo
               tt-impressao.fm-cod-com        = ITEM.fm-cod-com
               tt-impressao.item-fat          = STRING(ITEM.ind-item-fat,"Sim/Nao")
               tt-impressao.cod-unid-negoc    = ITEM.cod-unid-negoc 
               tt-impressao.cod-dcr-item      = ITEM.cod-dcr-item NO-ERROR.

        FIND FIRST item-caixa NO-LOCK
             WHERE item-caixa.it-codigo = ITEM.it-codigo NO-ERROR.
        IF AVAIL item-caixa THEN DO:

            ASSIGN tt-impressao.sigla-emb       = item-caixa.sigla-emb.

            FIND FIRST embalag OF item-caixa NO-LOCK NO-ERROR.             
        END.

        IF tt-param.l-peso-medida THEN DO:
            ASSIGN tt-impressao.peso-bruto        = ITEM.peso-bruto
                   tt-impressao.peso-liquido      = ITEM.peso-liquido
                   tt-impressao.altura            = ITEM.altura
                   tt-impressao.largura           = ITEM.largura
                   tt-impressao.comprimento       = ITEM.comprim.        
            
            IF AVAIL embalag THEN
                ASSIGN tt-impressao.altura-emb      = embalag.altura
                       tt-impressao.largura-emb     = embalag.largura
                       tt-impressao.comprimento-emb = embalag.comprim.            
        END.

        IF ITEM.cod-obsoleto = 1 THEN
            ASSIGN tt-impressao.cod-obsoleto = "Ativo".
        ELSE IF ITEM.cod-obsoleto = 2 THEN
            ASSIGN tt-impressao.cod-obsoleto = "Obsoleto Ordens Automaticas".
        ELSE IF ITEM.cod-obsoleto = 3 THEN
            ASSIGN tt-impressao.cod-obsoleto = "Obsoleto Todas as Ordens".
        ELSE IF ITEM.cod-obsoleto = 4 THEN
            ASSIGN tt-impressao.cod-obsoleto = "Totalmente Obsoleto".

        RUN piBuscaCEST IN h-esmsspapi001 (INPUT 1,
                                           INPUT IF TODAY > 04/01/2016 THEN TODAY ELSE 04/01/2016,
                                           INPUT "",
                                           INPUT "",
                                           INPUT "",
                                           INPUT ITEM.class-fiscal,
                                           INPUT ITEM.it-codigo,
                                           INPUT 0,
                                           OUTPUT c-mensagem,
                                           OUTPUT i-cest).

        IF i-cest = 0 THEN
            ASSIGN tt-impressao.cest = "0000000".
        ELSE DO:
            IF LENGTH(i-cest) = 6 THEN
                ASSIGN tt-impressao.cest = "0" + STRING(i-cest).
            ELSE
                ASSIGN tt-impressao.cest = STRING(i-cest).
        END.

        FIND FIRST item-mat NO-LOCK
             WHERE item-mat.it-codigo = ITEM.it-codigo NO-ERROR.
        IF AVAIL item-mat THEN
            ASSIGN tt-impressao.pis-ext    = item-mat.val-aliq-ext-pis
                   tt-impressao.cofins-ext = item-mat.val-aliq-ext-cofins            
                   tt-impressao.cod-ean    = item-mat.cod-ean.

        FIND FIRST classif-fisc NO-LOCK
             WHERE classif-fisc.class-fiscal = item.class-fiscal NO-ERROR.    
        IF AVAIL classif-fisc THEN
            ASSIGN tt-impressao.pis-majorado    = dec(substring(classif-fisc.char-1,65,9))
                   tt-impressao.cofins-majorado = dec(substring(classif-fisc.char-1,56,9)) NO-ERROR.

        IF tt-param.l-panumber-fabric THEN DO:
            FIND FIRST item-fabric NO-LOCK
                 WHERE item-fabric.it-codigo = ITEM.it-codigo NO-ERROR.
            IF AVAIL item-fabric THEN DO:
                FIND FIRST fabricante NO-LOCK
                     WHERE fabricante.cod-fabric = item-fabric.cod-fabric NO-ERROR.
                IF AVAIL fabricante THEN
                    ASSIGN tt-impressao.cod-fabricante  = fabricante.cod-fabric
                           tt-impressao.nome-fabricante = fabricante.nome-abrev
                           tt-impressao.part-number     = item-fabric.it-fabric.
            END.
        END.
    END.

    DELETE PROCEDURE h-esmsspapi001.

END PROCEDURE.
