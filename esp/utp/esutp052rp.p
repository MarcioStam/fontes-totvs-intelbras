/***********************************************************************
**  Programa..: ESP\utp\ESUTP052RP.P
**  Autor.....: Raphael Matei Paini
**  Data......: Novembro/2010 - Desenvolvimento
**  Descricao.: Relat¢rio Ccontrole dos Correios
**  VersÆo....: 001 10/11/2010
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESUTP052rp 2.04.00.001}

/****************************  Definitions  ****************************/
{esp/utp/esutp052tt.i}

{utp/ut-glob.i}
{include/i-rpvar.i}

/****************************  Temp-Tables  ****************************/

DEFINE TEMP-TABLE tt-correios NO-UNDO LIKE correios
INDEX ch-correios cod-estabel mes-ref nr-cartao ct-codigo cc-codigo.

DEFINE TEMP-TABLE tt-geral NO-UNDO
    FIELD ct-codigo AS CHARACTER
    FIELD cc-codigo AS CHARACTER
    FIELD mes-ref   AS CHARACTER
    FIELD valor     AS DECIMAL.

DEFINE TEMP-TABLE tt-rateios NO-UNDO LIKE rateio-equipamentos.

DEFINE BUFFER b-tt-rateios FOR tt-rateios.

/****************************  Frames       ****************************/
DEF INPUT PARAMETER raw-param as raw no-undo.
DEF INPUT PARAMETER table for tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

DEFINE VARIABLE c-responsavel AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-desc-tipo   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-periodos    AS CHARACTER   NO-UNDO.

DEF VAR h-acomp      as handle no-undo.
def var c-separador  as char format "x(01)".
FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK WHERE
          empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Relat¢rio Correios"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESUTP052"
       c-versao       = "2.04"
       c-revisao      = "001".

assign c-separador = ";".


FOR EACH tt-rateios:
    DELETE tt-rateios.
END.

/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
    {include/i-rpcab.i}

    {include/i-rpout.i &pagesize="0"}
    
    IF tt-param.periodo-ini > tt-param.periodo-fim THEN DO:
        PUT UNFORMATTED "Periodo inicial maior que final" SKIP.
    END.
    ELSE DO:
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
        
        RUN pi-carrega-dados.
        
        RUN pi-gera-excel.
    END.

    RUN pi-finalizar in h-acomp.
    {include/i-rpclo.i}
    RETURN "OK".
END.

PROCEDURE pi-carrega-dados:
    RUN pi-inicializar in h-acomp (input "Carregando Informa‡äes...").

    DEFINE VARIABLE i-tipo AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-equipamento AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-desc-equip  AS CHARACTER   NO-UNDO.

    EMPTY TEMP-TABLE tt-correios.

    IF tt-param.i-exec = 1  /* Cartoes */
    THEN DO:

        FOR EACH correios NO-LOCK
           WHERE correios.cod-estabel >= tt-param.cod-estabel-ini
             AND correios.cod-estabel <= tt-param.cod-estabel-fim
             AND correios.mes-ref     >= tt-param.periodo-ini
             AND correios.mes-ref     <= tt-param.periodo-fim
             AND correios.nr-contrato >= tt-param.contrato-ini
             AND correios.nr-contrato <= tt-param.contrato-fim
             AND correios.nr-fatura   >= tt-param.fatura-ini
             AND correios.nr-fatura   <= tt-param.fatura-fim 
             AND correios.cod-cli     >= tt-param.cod-cli-ini
             AND correios.cod-cli     <= tt-param.cod-cli-fim
             AND correios.nr-cartao   >= tt-param.cartao-ini
             AND correios.nr-cartao   <= tt-param.cartao-fim  
             AND correios.dt-postagem >= tt-param.dt-postagem-ini
             AND correios.dt-postagem <= tt-param.dt-postagem-fim
             AND correios.servico     >= tt-param.servico-ini
             AND correios.servico     <= tt-param.servico-fim 
             AND correios.nr-docto    >= tt-param.nr-docto-ini
             AND correios.nr-docto    <= tt-param.nr-docto-fim
             AND correios.ct-codigo   >= tt-param.conta-ini
             AND correios.ct-codigo   <= tt-param.conta-fim
             AND correios.cc-codigo   >= tt-param.cc-ini
             AND correios.cc-codigo   <= tt-param.cc-fim :
             
            RUN pi-acompanhar IN h-acomp ("Cartao : " + correios.nr-cartao). 

            IF tt-param.sintetico 
            THEN DO:
                FIND FIRST tt-correios  WHERE
                           tt-correios.cod-estabel = correios.cod-estabel AND
                           tt-correios.mes-ref     = correios.mes-ref     AND
                           tt-correios.nr-cartao   = correios.nr-cartao   AND
                           tt-correios.ct-codigo   = correios.ct-codigo   AND
                           tt-correios.cc-codigo   = correios.cc-codigo   NO-ERROR.
                IF NOT AVAIL tt-correios 
                THEN DO:
                   CREATE tt-correios.
                   ASSIGN tt-correios.cod-estabel = correios.cod-estabel
                          tt-correios.mes-ref     = correios.mes-ref     
                          tt-correios.nr-cartao   = correios.nr-cartao
                          tt-correios.ct-codigo   = correios.ct-codigo
                          tt-correios.cc-codigo   = correios.cc-codigo. 
                END.

                ASSIGN tt-correios.valor = tt-correios.valor + correios.valor.
            END. 
            ELSE DO:

                FIND FIRST tt-correios WHERE 
                           tt-correios.cod-estabel = correios.cod-estabel  AND 
                           tt-correios.mes-ref     = correios.mes-ref      AND 
                           tt-correios.nr-contrato = correios.nr-contrato  AND 
                           tt-correios.nr-fatura   = correios.nr-fatura    AND 
                           tt-correios.cod-cli     = correios.cod-cli      AND 
                           tt-correios.nr-cartao   = correios.nr-cartao    AND 
                           tt-correios.dt-postagem = correios.dt-postagem  AND 
                           tt-correios.servico     = correios.servico      AND 
                           tt-correios.nr-docto    = correios.nr-docto NO-ERROR.
                IF NOT AVAIL tt-correios
                THEN DO:
                   CREATE tt-correios.
                   BUFFER-COPY correios TO tt-correios.
                END.       
                
            END.

        END. /* each correios */
        
    END.
    ELSE DO:
        
         FOR EACH rateio-equipamentos NO-LOCK
           WHERE rateio-equipamentos.tipo         = 1 /*correios*/
             AND rateio-equipamentos.cod-estabel >= tt-param.cod-estabel-ini
             AND rateio-equipamentos.cod-estabel <= tt-param.cod-estabel-fim
             AND rateio-equipamentos.mes-ref     >= tt-param.periodo-ini
             AND rateio-equipamentos.mes-ref     <= tt-param.periodo-fim
             AND rateio-equipamentos.ct-codigo   >= tt-param.conta-ini
             AND rateio-equipamentos.ct-codigo   <= tt-param.conta-fim
             AND rateio-equipamentos.cc-codigo   >= tt-param.cc-ini
             AND rateio-equipamentos.cc-codigo   <= tt-param.cc-fim
             AND rateio-equipamentos.equipamento >= tt-param.cartao-ini
             AND rateio-equipamentos.equipamento <= tt-param.cartao-fim: 
    
            IF tt-param.sintetico THEN DO:
                FIND FIRST tt-rateios NO-LOCK
                     WHERE tt-rateios.ct-codigo  = rateio-equipamentos.ct-codigo
                       AND tt-rateios.cc-codigo  = rateio-equipamentos.cc-codigo
                       AND tt-rateios.mes-ref    = rateio-equipamentos.mes-ref NO-ERROR.
                IF NOT AVAIL tt-rateios THEN DO:
                    CREATE tt-rateios.
                    ASSIGN tt-rateios.ct-codigo  = rateio-equipamentos.ct-codigo
                           tt-rateios.cc-codigo  = rateio-equipamentos.cc-codigo
                           tt-rateios.mes-ref    = rateio-equipamentos.mes-ref.
                END.
                ASSIGN tt-rateios.val-rateio = tt-rateios.val-rateio + rateio-equipamentos.val-rateio.
            END.
            ELSE DO:
                CREATE tt-rateios.
                BUFFER-COPY rateio-equipamentos TO tt-rateios.
            END.
        END. 

    END.

END PROCEDURE.

PROCEDURE pi-gera-excel:

    RUN pi-inicializar in h-acomp (input "Gerando Relat¢rio Excel...").

    IF tt-param.i-exec = 1 THEN DO:
        IF tt-param.sintetico
        THEN DO:
            PUT "Estabelecimento;Periodo;Cartao;Conta;CentroCusto;Valor" SKIP.
            
            FOR EACH tt-correios NO-LOCK
                BREAK BY tt-correios.cod-estabel
                      BY tt-correios.mes-ref    
                      BY tt-correios.nr-cartao
                      :
                 
                PUT UNFORMATTED 
                    tt-correios.cod-estabel  ";"
                    tt-correios.mes-ref      ";"
                    tt-correios.nr-cartao    ";"
                    tt-correios.ct-codigo    ";"
                    tt-correios.cc-codigo    ";"
                    tt-correios.valor      FORMAT "->>>,>>>,>>>,>>9.99" SKIP.
            END.
        END.
        ELSE DO:
            PUT "Estabelecimento;Periodo;Contrato;Fatura;Cliente;Cartao;Dt Postagem;Servico;Nr Docto;Conta;C.Custo;Serv.Adicional;Destino;Peso;Quantidade;Valor;Origem;Unidade" SKIP.

            FOR EACH tt-correios NO-LOCK
                BREAK BY tt-correios.cod-estabel
                      BY tt-correios.mes-ref    
                      BY tt-correios.cod-cliente
                      BY tt-correios.nr-cartao:
                  
                PUT UNFORMATTED 
                    tt-correios.cod-estabel       ";"
                    tt-correios.mes-ref           ";"
                    tt-correios.nr-contrato       ";"
                    tt-correios.nr-fatura         ";"
                    tt-correios.cod-cliente       ";"
                    tt-correios.nr-cartao         ";"
                    tt-correios.dt-postagem       ";"   
                    tt-correios.servico           ";"   
                    tt-correios.nr-docto          ";"   
                    tt-correios.ct-codigo         ";"   
                    tt-correios.cc-codigo         ";"   
                    tt-correios.servico-adicional ";"   
                    tt-correios.cod-destino       ";"   
                    tt-correios.peso              ";"  
                    tt-correios.qtde              ";"
                    tt-correios.valor             FORMAT "->>>,>>>,>>>,>>9.99" ";"
                    tt-correios.origem-postagem   ";"
                    tt-correios.un-postagem   SKIP.
            END.

        END.
    END.
    ELSE DO:
        
        /* IF tt-param.sintetico THEN DO:

            IF tt-param.periodo-ini > tt-param.periodo-fim  THEN
                NEXT.

            IF INT(SUBSTRING(tt-param.periodo-fim,1,4)) - INT(SUBSTRING(tt-param.periodo-ini,1,4)) > 1 THEN DO:
                PUT UNFORMATTED 
                    "Periodo mÿximo de 12 meses, favor informar periodo com diferen»a entre 0 ou 12 meses" SKIP.
                NEXT.
            END.

            
            RUN pi-calcula-periodo.
            IF NUM-ENTRIES(c-periodos,";") <= 12 THEN DO:
                PUT UNFORMATTED "Conta;C.Custo;" c-periodos SKIP.
                FOR EACH tt-rateios NO-LOCK
                    BREAK BY tt-rateios.ct-codigo
                          BY tt-rateios.cc-codigo:
                    IF FIRST-OF(tt-rateios.ct-codigo) OR FIRST-OF(tt-rateios.cc-codigo) THEN DO:
                        PUT tt-rateios.ct-codigo ";" tt-rateios.cc-codigo       ";" .

                        DO i = 1 TO NUM-ENTRIES(c-periodos,";"):
                            FIND FIRST b-tt-rateios NO-LOCK
                                 WHERE b-tt-rateios.ct-codigo = tt-rateios.ct-codigo
                                   AND b-tt-rateios.cc-codigo = tt-rateios.cc-codigo
                                   AND b-tt-rateios.mes-ref   = ENTRY(i,c-periodos,";") NO-ERROR.
                            IF NOT AVAIL b-tt-rateios THEN
                                PUT UNFORMATTED ";".
                            ELSE
                                PUT UNFORMATTED
                                    b-tt-rateios.val-rateio ";".
                        END.
                        PUT UNFORMATTED SKIP.
                    END.
                END.
            END.
            ELSE DO:
                PUT UNFORMATTED 
                    "Periodo mÿximo de 12 meses, favor informar periodo com diferen»a entre 0 ou 12 meses" SKIP.
            END.
        END.
        ELSE DO:
            PUT "Periodo;Conta;C. Custo;Equipamento;Est;Valor" SKIP.

            FOR EACH tt-rateios NO-LOCK
                BREAK BY tt-rateios.mes-ref
                      BY tt-rateios.ct-codigo
                      BY tt-rateios.cc-codigo
                      BY tt-rateios.equipamento
                      BY tt-rateios.cod-estabel:
                PUT tt-rateios.mes-ref      ";"
                    tt-rateios.ct-codigo    ";"
                    tt-rateios.cc-codigo    ";"
                    tt-rateios.equipamento  ";"
                    tt-rateios.cod-estab    ";"
                    tt-rateios.val-rateio SKIP.
            END.
        END.
        
        */
    END.


END PROCEDURE.


PROCEDURE pi-calcula-periodo:
    DEFINE VARIABLE i-ano-ini  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-ano-fim  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-mes-ini  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-mes-fim  AS INTEGER     NO-UNDO.

    DEFINE VARIABLE i AS INTEGER     NO-UNDO.
    DEFINE VARIABLE j AS INTEGER     NO-UNDO.

    ASSIGN i-ano-ini = INT(SUBSTRING(tt-param.periodo-ini,1,4))
           i-ano-fim = INT(SUBSTRING(tt-param.periodo-fim,1,4))
           i-mes-ini = INT(SUBSTRING(tt-param.periodo-ini,5,2))
           i-mes-fim = INT(SUBSTRING(tt-param.periodo-fim,5,2)). 

    IF SUBSTRING(tt-param.periodo-ini,1,4) = SUBSTRING(tt-param.periodo-fim,1,4) THEN DO:
        DO i = i-mes-ini TO i-mes-fim:
            IF c-periodos = "" THEN
                ASSIGN c-periodos = STRING(i-ano-ini,"9999") + STRING(i,"99").
            ELSE 
                ASSIGN c-periodos = c-periodos + ";" + STRING(i-ano-ini,"9999") + STRING(i,"99").
        END.
    END.
    ELSE DO:
        DO j = i-ano-ini TO i-ano-fim:
            DO i = 1 TO 12:
                IF j <> i-ano-fim THEN DO:
                    IF i < i-mes-ini THEN NEXT.
                    IF c-periodos = "" THEN
                        ASSIGN c-periodos = STRING(j,"9999") + STRING(i,"99").
                    ELSE 
                        ASSIGN c-periodos = c-periodos + ";" + STRING(j,"9999") + STRING(i,"99").
                END.
                ELSE DO:
                    IF i > i-mes-fim THEN NEXT.
                    IF c-periodos = "" THEN
                        ASSIGN c-periodos = STRING(j,"9999") + STRING(i,"99").
                    ELSE 
                        ASSIGN c-periodos = c-periodos + ";" + STRING(j,"9999") + STRING(i,"99").
                END.
            END.
        END.
    END.

END PROCEDURE.
