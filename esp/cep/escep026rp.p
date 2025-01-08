/***********************************************************************
**  Programa..: ESP\REP\ESCEP026RP.P
**  Autor.....: Giovane Oliveira
**  Data......: FEVEREIRO/2006 - Desenvolvimento
**  Descricao.: CARTEIRA POR DATA DE ENTREGA
**  VersÆo....: 001 07/02/2006
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCEP026 2.04.00.000}

/****************************  Definitions  ****************************/
{esp/cep/escep026tt.i}

{utp/ut-glob.i}
{include/i-rpvar.i}

/****************************  Temp-Tables  ****************************/
DEFINE TEMP-TABLE tt-carteira
    FIELD it-codigo      LIKE ITEM.it-codigo
    FIELD cd-gr-com      AS CHARACTER FORMAT "x(3)"
    FIELD cd-sub-com     AS CHARACTER FORMAT "x(4)"
    FIELD saldo-fisico   AS INTEGER
    FIELD saldo-res-ped  AS INTEGER
    FIELD saldo-res-nota AS INTEGER
    FIELD saldo-cart     AS INTEGER
    FIELD saldo          AS INTEGER
    FIELD estoque        AS INTEGER
    FIELD bloq           AS INTEGER
    FIELD estoque-exp    AS INTEGER
    FIELD estoque-wex    AS INTEGER
    FIELD estoque-aca    AS INTEGER
    FIELD est-bloq-wex   AS INTEGER
    FIELD est-aloc-wex   AS INTEGER
    FIELD Bloq-Espdp080  AS INTEGER
    FIELD estoque-epe    AS INTEGER
    FIELD estoq-transito-epe AS INTEGER
    INDEX grupo IS PRIMARY UNIQUE cd-gr-com cd-sub-com it-codigo
    INDEX item it-codigo.


DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

DEFINE VARIABLE h-acomp   AS HANDLE    NO-UNDO.
DEFINE VARIABLE c-estoque AS CHARACTER NO-UNDO.

FOR FIRST param-global NO-LOCK. END.

FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

FIND FIRST tt-param NO-ERROR.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "CARTEIRA POR DATA DE ENTREGA"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESCEP026"
       c-versao       = "2.04"
       c-revisao      = "001".

{cdp/cd0666.i}          /* Definicao da temp-table de erros */
DEFINE VARIABLE p-qtd-total LIKE wm-saldo-estoque.qtd-atual NO-UNDO.
DEFINE VARIABLE p-qtd-disp  LIKE wm-saldo-estoque.qtd-atual NO-UNDO.
DEFINE VARIABLE p-qtd-bloq  LIKE wm-saldo-estoque.qtd-atual NO-UNDO.

/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
    {include/i-rpcab.i}
    {include/i-rpout.i}

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  

    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
    
    RUN piMontaRelat.
    RUN imprime-relatorio.

    RUN pi-finalizar in h-acomp.
    {include/i-rpclo.i}
    RETURN "OK".
END.

PROCEDURE piMontaRelat:
    RUN pi-inicializar in h-acomp (input "Imprimindo...").

    DEF VAR i-nr-reservas AS INTEGER NO-UNDO.

    FOR EACH fam-comerc NO-LOCK
        WHERE fam-comerc.fm-cod-com >= tt-param.ini-familia
        AND   fam-comerc.fm-cod-com <= tt-param.fim-familia,
        EACH item NO-LOCK
        WHERE item.fm-cod-com  = fam-comerc.fm-cod-com
        AND   item.it-codigo  >= tt-param.ini-it-codigo
        AND   item.it-codigo  <= tt-param.fim-it-codigo:

        RUN pi-acompanhar IN h-acomp (INPUT item.it-codigo).

        FIND FIRST item-uni-estab
            WHERE item-uni-estab.it-codigo       = item.it-codigo
            AND   item-uni-estab.cod-estabel    >= tt-param.cod-estabel-ini
            AND   item-uni-estab.cod-estabel    <= tt-param.cod-estabel-fim
            AND   item-uni-estab.cod-unid-negoc >= tt-param.cod-unid-negoc-ini
            AND   item-uni-estab.cod-unid-negoc <= tt-param.cod-unid-negoc-fim NO-LOCK NO-ERROR.

        IF NOT AVAIL item-uni-estab  THEN
            NEXT.

        FIND FIRST tt-carteira
            WHERE tt-carteira.it-codigo  = item.it-codigo
            AND   tt-carteira.cd-gr-com  = SUBSTRING(fam-comerc.fm-cod-com,1,5)
            AND   tt-carteira.cd-sub-com = SUBSTRING(fam-comerc.fm-cod-com,1,7) NO-LOCK NO-ERROR.

        ASSIGN i-nr-reservas = 0.

        IF NOT AVAIL tt-carteira THEN DO:
            CREATE tt-carteira.
            ASSIGN tt-carteira.it-codigo  = item.it-codigo
                   tt-carteira.cd-gr-com  = SUBSTRING(fam-comerc.fm-cod-com,1,5) 
                   tt-carteira.cd-sub-com = SUBSTRING(fam-comerc.fm-cod-com,1,7). 

            
            FOR EACH  saldo-estoq NO-LOCK
                WHERE saldo-estoq.cod-estabel >= tt-param.cod-estabel-ini 
                 AND  saldo-estoq.cod-estabel <= tt-param.cod-estabel-fim
                 AND (saldo-estoq.cod-depos    = "exp" OR saldo-estoq.cod-depos = "wex" OR saldo-estoq.cod-depos = "epe" )
                 AND  saldo-estoq.it-codigo    = item.it-codigo:

                IF saldo-estoq.cod-localiz = "cst" THEN
                    NEXT.

                FIND FIRST int-saldo-estoq NO-LOCK 
                    WHERE int-saldo-estoq.it-codigo   = saldo-estoq.it-codigo
                    AND   int-saldo-estoq.cod-depos   = saldo-estoq.cod-depos
                    AND   int-saldo-estoq.cod-refer   = saldo-estoq.cod-refer
                    AND   int-saldo-estoq.lote        = saldo-estoq.lote
                    AND   int-saldo-estoq.cod-localiz = saldo-estoq.cod-localiz
                    AND   int-saldo-estoq.cod-estabel = saldo-estoq.cod-estabel NO-ERROR.

                IF AVAIL int-saldo-estoq AND int-saldo-estoq.log-bloqueado THEN
                    ASSIGN tt-carteira.bloq = tt-carteira.bloq + saldo-estoq.qtidade-atu.
                ELSE DO:
                    IF saldo-estoq.cod-localiz = "BLOQUEADO" AND saldo-estoq.cod-depos = "EXP" THEN
                        ASSIGN tt-carteira.bloq = tt-carteira.bloq + saldo-estoq.qtidade-atu.
                END.

                ASSIGN tt-carteira.saldo-fisico  = tt-carteira.saldo-fisico + saldo-estoq.qtidade-atu
                       tt-carteira.saldo-res-nota = tt-carteira.saldo-res-nota + saldo-estoq.qt-alocada.

                IF saldo-estoq.cod-depos = "EXP" THEN
                    ASSIGN tt-carteira.estoque-exp = tt-carteira.estoque-exp + saldo-estoq.qtidade-atu.
                ELSE DO:
                    IF saldo-estoq.cod-depos = "WEX" THEN DO:
                        RUN esp/wmp/eswmpapi003.p (INPUT  saldo-estoq.cod-estabel,
                                                   INPUT  saldo-estoq.cod-depos,
                                                   INPUT  saldo-estoq.it-codigo,
                                                   INPUT  "",
                                                   OUTPUT p-qtd-total,
                                                   OUTPUT p-qtd-disp,
                                                   OUTPUT p-qtd-bloq,
                                                   OUTPUT TABLE tt-erro).
                      
                        ASSIGN tt-carteira.estoque-wex  = tt-carteira.estoque-wex  + saldo-estoq.qtidade-atu
                           tt-carteira.est-aloc-wex = tt-carteira.est-aloc-wex + saldo-estoq.qt-aloc-prod
                           tt-carteira.est-bloq-wex = tt-carteira.est-bloq-wex + p-qtd-bloq.
                    END.
                END.

                /* inserindo deposito EPE */

                IF saldo-estoq.cod-depos = "EPE" THEN DO:

                    FOR EACH int-it-nota-fisc-alocado NO-LOCK
                        WHERE int-it-nota-fisc-alocado.it-codigo = ITEM.it-codigo
                          AND int-it-nota-fisc-alocado.serie        = "3"
                          AND int-it-nota-fisc-alocado.log-recebida = NO:

                        ASSIGN tt-carteira.estoq-transito-epe = tt-carteira.estoq-transito-epe + int-it-nota-fisc-alocado.qt-faturada[1].
                          
                    END.
                    
                   ASSIGN tt-carteira.estoque-epe = tt-carteira.estoque-epe + saldo-estoq.qtidade-atu - tt-carteira.estoq-transito-epe.
                END.
                        

            END.
  
            IF tt-param.aca THEN DO:

                FOR EACH  saldo-estoq NO-LOCK
                    WHERE saldo-estoq.cod-estabel >= tt-param.cod-estabel-ini
                    AND   saldo-estoq.cod-estabel <= tt-param.cod-estabel-fim
                    AND   saldo-estoq.cod-depos    = "aca"
                    AND   saldo-estoq.it-codigo    = item.it-codigo: 

                    FIND FIRST int-saldo-estoq NO-LOCK
                        WHERE int-saldo-estoq.it-codigo = saldo-estoq.it-codigo
                        AND   int-saldo-estoq.cod-depos = saldo-estoq.cod-depos
                        AND   int-saldo-estoq.cod-refer = saldo-estoq.cod-refer
                        AND   int-saldo-estoq.lote  = saldo-estoq.lote
                        AND   int-saldo-estoq.cod-localiz = saldo-estoq.cod-localiz
                        AND   int-saldo-estoq.cod-estabel = saldo-estoq.cod-estabel NO-ERROR.

                    IF AVAIL int-saldo-estoq AND int-saldo-estoq.log-bloqueado THEN
                        ASSIGN tt-carteira.bloq = tt-carteira.bloq + saldo-estoq.qtidade-atu.

                    ASSIGN tt-carteira.saldo-fisico = tt-carteira.saldo-fisico + saldo-estoq.qtidade-atu
                           tt-carteira.estoque-aca  = tt-carteira.estoque-aca  + saldo-estoq.qtidade-atu.

                END.
            END.

            IF tt-param.blo THEN DO:

                FOR EACH  saldo-estoq NO-LOCK
                    WHERE saldo-estoq.cod-estabel >= tt-param.cod-estabel-ini
                    AND   saldo-estoq.cod-estabel <= tt-param.cod-estabel-fim
                    AND   saldo-estoq.cod-depos    = "blo"
                    AND   saldo-estoq.it-codigo   = item.it-codigo:

                    ASSIGN tt-carteira.bloq = tt-carteira.bloq + saldo-estoq.qtidade-atu.

                END.
            END.
        END.

        /* Totalizar as reservas */
        FOR EACH reservas-ast NO-LOCK
            WHERE reservas-ast.cod-estab    >= tt-param.cod-estabel-ini
              AND reservas-ast.cod-estab    <= tt-param.cod-estabel-fim
              AND reservas-ast.it-codigo    = item.it-codigo
              AND reservas-ast.dt-reserva   <= TODAY
              AND (reservas-ast.data-limite = ? OR reservas-ast.data-limite >= TODAY) :
              ASSIGN tt-carteira.Bloq-Espdp080 = tt-carteira.Bloq-Espdp080  + reservas-ast.qt-reserva.
        END.

        /* abaixo exitem 2 for each do ped-item a diferenca entre 1 e
           eh o ped-item.cod-sit-item, pois se usar or a leitura fica lenta */
        FOR EACH ped-item NO-LOCK USE-INDEX planejamento
            WHERE ped-item.it-codigo       = item.it-codigo
            AND   ped-item.cod-refer       = ""
            AND   ped-item.cod-sit-item   <= 2
            AND   ped-item.dt-entrega     >= tt-param.ini-data
            AND   ped-item.dt-entrega     <= tt-param.fim-data
            AND   ped-item.cod-unid-negoc >= tt-param.cod-unid-negoc-ini
            AND   ped-item.cod-unid-negoc <= tt-param.cod-unid-negoc-fim
            AND  (ped-item.qt-pedida - ped-item.qt-atendida) > 0,
            FIRST ped-venda OF ped-item
            WHERE (ped-venda.cod-sit-ped <= 2 OR ped-venda.cod-sit-ped = 5)
            AND   ped-venda.cod-estabel >=  tt-param.cod-estabel-ini 
            AND   ped-venda.cod-estabel <=  tt-param.cod-estabel-fim NO-LOCK,
            FIRST repres
            WHERE repres.nome-abrev = ped-venda.no-ab-reppri
            AND   repres.cod-rep >= tt-param.ini-rep
            AND   repres.cod-rep <= tt-param.fim-rep NO-LOCK,
            FIRST natur-oper
            WHERE natur-oper.nat-operacao = ped-item.nat-operacao
            AND   natur-oper.baixa-est NO-LOCK:

            IF ped-venda.cod-priori = 44 THEN /* Or‡amento */
                NEXT.

            IF ped-item.qt-log-aloca <> 0 THEN
                ASSIGN tt-carteira.saldo-res-ped = tt-carteira.saldo-res-ped + ped-item.qt-log-aloca.

            ASSIGN tt-carteira.saldo-cart = tt-carteira.saldo-cart + (ped-item.qt-pedida -
                                                                      ped-item.qt-atendida).
        END.

        FOR EACH ped-item NO-LOCK USE-INDEX planejamento
            WHERE ped-item.it-codigo       = item.it-codigo
            AND   ped-item.cod-refer       = ""
            AND   ped-item.cod-sit-item    = 5
            AND  (ped-item.qt-pedida - ped-item.qt-atendida) > 0
            AND   ped-item.dt-entrega     >= tt-param.ini-data
            AND   ped-item.dt-entrega     <= tt-param.fim-data
            AND   ped-item.cod-unid-negoc >= tt-param.cod-unid-negoc-ini
            AND   ped-item.cod-unid-negoc <= tt-param.cod-unid-negoc-fim,
            FIRST ped-venda OF ped-item
            WHERE (ped-venda.cod-sit-ped <= 2 OR  ped-venda.cod-sit-ped = 5)
            AND   ped-venda.cod-estabel  >=  tt-param.cod-estabel-ini
            AND   ped-venda.cod-estabel  <=  tt-param.cod-estabel-fim NO-LOCK,
            FIRST repres
            WHERE repres.nome-abrev = ped-venda.no-ab-reppri
            AND   repres.cod-rep   >= tt-param.ini-rep
            AND   repres.cod-rep   <= tt-param.fim-rep NO-LOCK,
            FIRST natur-oper
            WHERE natur-oper.nat-operacao = ped-item.nat-operacao
            AND   natur-oper.baixa-est NO-LOCK:

            ASSIGN tt-carteira.saldo-cart = tt-carteira.saldo-cart + (ped-item.qt-pedida -
                                                                      ped-item.qt-atendida).

            IF ped-item.qt-log-aloca <> 0 THEN
                ASSIGN tt-carteira.saldo-res-ped = tt-carteira.saldo-res-ped + ped-item.qt-log-aloca.
        END.

        ASSIGN tt-carteira.saldo   = tt-carteira.saldo-fisico - tt-carteira.saldo-res-nota -
                                     tt-carteira.saldo-cart - tt-carteira.bloq .
               tt-carteira.estoque = tt-carteira.saldo-fisico - tt-carteira.saldo-res-nota.
    END. /*for each fam-comerc no-lock */
END. /*PROCEDURE piMontaRelat:*/


PROCEDURE imprime-relatorio:

    for each tt-carteira
        break by tt-carteira.cd-gr-com
              by tt-carteira.cd-sub-com
              by tt-carteira.it-codigo:

        RUN pi-acompanhar IN h-acomp (INPUT tt-carteira.it-codigo).

        if first-of (tt-carteira.cd-gr-com) then do:
           
           find first fam-com-item
                where fam-com-item.fm-cod-com = tt-carteira.cd-gr-com
                no-lock no-error.

           put "GRUPO   : "
               tt-carteira.cd-gr-com.
           if avail fam-com-item then
               put " - "
                   fam-com-item.descricao.
           
           if tt-param.familia = no then
              put skip(1).
           else put skip.   
        end.
        
        if  tt-param.familia = yes
        and first-of (tt-carteira.cd-sub-com) then do:
            find first fam-com-item
                 where fam-com-item.fm-cod-com = tt-carteira.cd-sub-com
                 no-lock no-error.

            put "SUBGRUPO: "
                tt-carteira.cd-sub-com.
            if avail fam-com-item THEN
                put " - "
                    fam-com-item.descricao.
            put skip(1).
        end.

        find item where
             item.it-codigo = tt-carteira.it-codigo no-lock no-error.
        if tt-carteira.saldo-cart > 0 or 
           tt-carteira.saldo-fisico > 0 or 
           tt-carteira.saldo-res-ped > 0 or
           tt-carteira.saldo-res-nota > 0 or 
           tt-carteira.saldo > 0 OR 
           tt-carteira.bloq > 0 then
            disp tt-carteira.it-codigo     label "PRODUTO"
                 string(item.descricao-1 + item.descricao-2) format "x(35)"    label "DESCRICAO"
                 tt-carteira.saldo-cart    label "CARTEIRA"
                 tt-carteira.saldo-fisico  label "FISICO"
                 tt-carteira.saldo-res-ped  
                            column-label "RESERVADO!PEDIDO"
                 tt-carteira.saldo-res-nota 
                            column-label "RESERVADO!NOTA"
                 tt-carteira.saldo              label "DISPONIVEL"
                 tt-carteira.estoque            label "ESTOQUE"
                 tt-carteira.bloq               label "BLOQUEADO"
                 tt-carteira.estoque-exp        LABEL "ESTOQUE EXP"
                 tt-carteira.estoque-wex        LABEL "ESTOQUE WEX"
                 tt-carteira.est-aloc-wex       LABEL "QT. ALOC. PROD"
                 tt-carteira.est-bloq-wex       LABEL "EST. BLOQ. WEX"
                 tt-carteira.estoque-aca        LABEL "ESTOQUE ACA"
                 tt-carteira.Bloq-Espdp080      LABEL "Bloq.Espdp080"
                 tt-carteira.estoque-epe        LABEL "ESTOQUE EPE"
                 tt-carteira.estoq-transito-epe LABEL "EST.TRANS EPE"   
                 with width /*195*/  300 NO-BOX STREAM-IO.
        
        accum tt-carteira.saldo-cart            (total by tt-carteira.cd-gr-com)
              tt-carteira.saldo-cart            (total by tt-carteira.cd-sub-com)
              tt-carteira.saldo-fisico          (total by tt-carteira.cd-gr-com)
              tt-carteira.saldo-fisico          (total by tt-carteira.cd-sub-com)
              tt-carteira.saldo-res-ped         (total by tt-carteira.cd-gr-com)
              tt-carteira.saldo-res-ped         (total by tt-carteira.cd-sub-com)
              tt-carteira.saldo-res-nota        (total by tt-carteira.cd-gr-com)
              tt-carteira.saldo-res-nota        (total by tt-carteira.cd-sub-com)
              tt-carteira.saldo                 (total by tt-carteira.cd-gr-com)
              tt-carteira.saldo                 (total by tt-carteira.cd-sub-com)     
              tt-carteira.estoque               (total by tt-carteira.cd-gr-com)
              tt-carteira.estoque               (total by tt-carteira.cd-sub-com)
              tt-carteira.bloq                  (total by tt-carteira.cd-gr-com)
              tt-carteira.bloq                  (total by tt-carteira.cd-sub-com)
              tt-carteira.estoque-exp           (total by tt-carteira.cd-gr-com)
              tt-carteira.estoque-exp           (total by tt-carteira.cd-sub-com)
              tt-carteira.estoque-wex           (total by tt-carteira.cd-gr-com)
              tt-carteira.estoque-wex           (total by tt-carteira.cd-sub-com)
              tt-carteira.est-aloc-wex          (total by tt-carteira.cd-gr-com)
              tt-carteira.est-aloc-wex          (total by tt-carteira.cd-sub-com)
              tt-carteira.est-bloq-wex          (total by tt-carteira.cd-gr-com)
              tt-carteira.est-bloq-wex          (total by tt-carteira.cd-sub-com)
              tt-carteira.estoque-aca           (total by tt-carteira.cd-gr-com)
              tt-carteira.estoque-aca           (total by tt-carteira.cd-sub-com)
              tt-carteira.Bloq-Espdp080         (total by tt-carteira.cd-gr-com) 
              tt-carteira.Bloq-Espdp080         (total by tt-carteira.cd-sub-com)
              tt-carteira.estoque-epe           (total by tt-carteira.cd-gr-com)    
              tt-carteira.estoque-epe           (total by tt-carteira.cd-sub-com)
              tt-carteira.estoq-transito-epe    (total by tt-carteira.cd-gr-com)   
              tt-carteira.estoq-transito-epe    (total by tt-carteira.cd-sub-com).
        
        if  tt-param.familia = yes
        and last-of(tt-carteira.cd-sub-com) then do:
            put skip(1)
                "TOTAL SUBGRUPO "
                tt-carteira.cd-sub-com
                accum total by tt-carteira.cd-sub-com saldo-cart                AT 54
                accum total by tt-carteira.cd-sub-com saldo-fisico              AT 65
                accum total by tt-carteira.cd-sub-com saldo-res-ped             AT 76
                accum total by tt-carteira.cd-sub-com saldo-res-nota            AT 87
                accum total by tt-carteira.cd-sub-com saldo                     AT 98 
                accum total by tt-carteira.cd-sub-com estoque                   AT 109
                accum total by tt-carteira.cd-sub-com tt-carteira.bloq          AT 120 
                accum total by tt-carteira.cd-sub-com tt-carteira.estoque-exp   AT 132
                accum total by tt-carteira.cd-sub-com tt-carteira.estoque-wex   AT 144
                accum total by tt-carteira.cd-sub-com tt-carteira.est-aloc-wex  AT 159
                accum total by tt-carteira.cd-sub-com tt-carteira.est-bloq-wex  AT 174
                accum total by tt-carteira.cd-sub-com tt-carteira.estoque-aca   AT 186 
                accum total by tt-carteira.cd-sub-com tt-carteira.Bloq-Espdp080 AT 200 
                accum total by tt-carteira.cd-sub-com tt-carteira.estoque-exp   AT 212 SKIP
                fill("-",232) format "x(222)"
                skip.
        end.
        
        if last-of(tt-carteira.cd-gr-com) then do:
            put skip(1)
                "TOTAL GRUPO    "
                tt-carteira.cd-gr-com                                          
                accum total by tt-carteira.cd-gr-com saldo-cart                       at 54
                accum total by tt-carteira.cd-gr-com saldo-fisico                     at 65
                accum total by tt-carteira.cd-gr-com saldo-res-ped                    at 76
                accum total by tt-carteira.cd-gr-com saldo-res-nota                   at 87
                accum total by tt-carteira.cd-gr-com saldo                            at 98 
                accum total by tt-carteira.cd-gr-com estoque                          at 109 
                accum total by tt-carteira.cd-gr-com tt-carteira.bloq                 at 120 
                accum total by tt-carteira.cd-gr-com tt-carteira.estoque-exp          AT 132
                accum total by tt-carteira.cd-gr-com tt-carteira.estoque-wex          AT 144
                accum total by tt-carteira.cd-gr-com tt-carteira.est-aloc-wex         AT 159
                accum total by tt-carteira.cd-gr-com tt-carteira.est-bloq-wex         AT 174
                accum total by tt-carteira.cd-gr-com tt-carteira.estoque-aca          AT 186 
                accum total by tt-carteira.cd-gr-com tt-carteira.Bloq-Espdp080        AT 200 
                accum total by tt-carteira.cd-gr-com tt-carteira.estoque-epe          AT 212 
                accum total by tt-carteira.cd-gr-com tt-carteira.estoq-transito-epe   AT 226 SKIP
                fill("-",235) format "x(235)"
                skip(1).
        end.
    end. /*for each tt-carteira*/
 END. /*PROCEDURE imprime-relatorio:*/
         

