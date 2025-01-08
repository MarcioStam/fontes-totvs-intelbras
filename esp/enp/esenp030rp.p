/***********************************************************************
**  Programa..: esp/enp/esenp030rp
**  Autor.....: Alexandre de Freitas.Campos.Gon»alves
**  Data......: Julho/2015 - Desenvolvimento
**  Descricao.: Relat¢rio de componentes da estrutura 
**  Versao....: 001 14/07/2015
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i esenp030rp 1.00.00.00}

/****************************  Definitions  ****************************/

{esp/enp/esenp030tt.i}

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita	   AS RAW.

DEFINE STREAM str-excel.

{utp/ut-glob.i}
{include/i-rpvar.i}
{esp/es0018.i}

/****************************  Frames       ****************************/

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.
      
/****************************  Variaveis  ******************************/

DEFINE VARIABLE h-acomp        AS HANDLE    NO-UNDO.
DEFINE VARIABLE c-excel        AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-nivel        AS INTEGER FORMAT "99" NO-UNDO.
DEFINE VARIABLE es-codigo      LIKE estrutura.it-codigo.
DEFINE VARIABLE es-codigo-desc LIKE ITEM.desc-item.
DEFINE VARIABLE chExcel        AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chArquivo      AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chPlanilhaMod  AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE i-seq-saida    AS INTEGER NO-UNDO.
DEFINE VARIABLE fim-mes        AS DATE NO-UNDO.
DEFINE VARIABLE d-qtd          LIKE estrutura.quant-usada NO-UNDO.
DEFINE VARIABLE dt-ini         AS DATE NO-UNDO.
DEFINE VARIABLE dt-fim         AS DATE NO-UNDO.
DEFINE VARIABLE d-aux          AS DATE NO-UNDO.

DEFINE BUFFER b-item FOR ITEM.
DEFINE BUFFER b-estrutura FOR estrutura.

DEFINE VARIABLE i-situacao      AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-sit-dif-estab AS LOGICAL     NO-UNDO.
/****************************  Temp-Tables  ****************************/

DEFINE TEMP-TABLE tt-estrutura NO-UNDO
    FIELD it-codigo      LIKE estrutura.it-codigo
    FIELD es-codigo      LIKE estrutura.es-codigo
    FIELD it-codigo-desc LIKE ITEM.desc-item
    FIELD es-codigo-desc LIKE b-item.desc-item
    FIELD tipo           AS CHARACTER FORMAT "x(10)"
    FIELD nivel          AS INTEGER FORMAT "99"
    FIELD data           AS DATE
    FIELD codigo-item    LIKE ITEM.it-codigo
    FIELD quantidade     LIKE estrutura.quant-usada.

DEFINE TEMP-TABLE tt-itens NO-UNDO
    FIELD it-codigo      AS CHAR
    FIELD es-codigo      AS CHAR
    FIELD codigo-item    LIKE ITEM.it-codigo
    FIELD it-codigo-desc LIKE ITEM.desc-item
    FIELD es-codigo-desc LIKE b-item.desc-item
    FIELD nivel          AS INTEGER FORMAT "99"
    FIELD cod-obsoleto   AS CHAR
    FIELD motivo         AS CHAR
    FIELD cod-comprador  AS CHAR
    FIELD nome-comprador AS CHAR
    FIELD nome-abrev     AS CHAR
    FIELD ressuprimento  AS INT.

DEFINE TEMP-TABLE tt-data NO-UNDO
    FIELD periodo-data AS DATE.

FOR FIRST param-global NO-LOCK. END.

FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

FIND FIRST tt-param NO-ERROR.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

EMPTY TEMP-TABLE tt-prog-ponto.

IF OPSYS = "UNIX" THEN DO:
    RUN esp/es0018p.p (INPUT "spool-unix", /* Nome do programa */
                       INPUT 1,           /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    FOR FIRST tt-prog-ponto NO-LOCK:

        ASSIGN c-excel = tt-prog-ponto.conteudo + "~/" + v_cod_usuar_corren + "~/".

        OS-CREATE-DIR VALUE(c-excel).

        ASSIGN c-excel = c-excel + "esenp030.csv".
        
    END.

END.
ELSE DO:
    RUN esp/es0018p.p (INPUT "spool-win", /* Nome do programa */
                       INPUT 1,          /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.

    FOR FIRST tt-prog-ponto NO-LOCK:

        ASSIGN c-excel = tt-prog-ponto.conteudo + "~\" + v_cod_usuar_corren + "~\".

        OS-CREATE-DIR VALUE(c-excel).

        ASSIGN c-excel = c-excel + "esenp030.csv".
    END.

END. 

OUTPUT STREAM str-excel TO VALUE(c-excel) CONVERT TARGET "iso8859-1".
PUT STREAM str-excel "Item;Descri‡Æo;Componente;Descri‡Æo".   

/*****************************  Main Block  *****************************/

DO ON STOP UNDO, LEAVE:
    
    {include/i-rpcab.i}
    {include/i-rpout.i} 
    
    ASSIGN i-seq-saida = 0.
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT "Obtendo informa‡äes..."). 
    RUN piMontaRelat.

END.

PROCEDURE piMontaRelat:

    EMPTY TEMP-TABLE tt-data.
    EMPTY TEMP-TABLE tt-estrutura.

    ASSIGN dt-ini = ?
           dt-fim = ?
           d-aux  = ?.
    
    IF INT(SUBSTRING(tt-param.periodo-ini,1,2)) = 12 THEN
        ASSIGN dt-ini = DATE(01,01,INT(SUBSTRING(tt-param.periodo-ini,3,4)) + 1) - 1.
    ELSE
        ASSIGN dt-ini = DATE(INT(SUBSTRING(tt-param.periodo-ini,1,2)) + 1,01,INT(SUBSTRING(tt-param.periodo-ini,3,4))) - 1. 

    IF INT(SUBSTRING(tt-param.periodo-fim,1,2)) = 12 THEN
        ASSIGN dt-fim = DATE(01,01,INT(SUBSTRING(tt-param.periodo-fim,3,4)) + 1) - 1.
    ELSE 
        ASSIGN dt-fim = DATE(INT(SUBSTRING(tt-param.periodo-fim,1,2)) + 1,01,INT(SUBSTRING(tt-param.periodo-fim,3,4))) - 1. 
    
    DO d-aux = dt-ini TO dt-fim:
        
        ASSIGN fim-mes = DATE(MONTH(d-aux), 20, YEAR(d-aux)) + 15
               fim-mes = fim-mes - DAY(fim-mes).

        IF d-aux = fim-mes THEN DO:
            CREATE tt-data.
            ASSIGN tt-data.periodo-data = d-aux.
        END.
    END.

    IF CAN-FIND(FIRST tt-digita) THEN DO:
        
        FOR EACH tt-digita:

            FOR FIRST ITEM NO-LOCK
                WHERE ITEM.it-codigo = tt-digita.it-codigo:
                    
                RUN pi-ini-estrutura.

            END.

        END.
    END.
    ELSE DO:

        FOR EACH ITEM NO-LOCK
            WHERE ITEM.it-codigo >= tt-param.item-ini
            AND   ITEM.it-codigo <= tt-param.item-fim:
        
            RUN pi-ini-estrutura.
                    
        END.

    END.
    
    RUN pi-finalizar in h-acomp.
END. 


PROCEDURE pi-ini-estrutura:

    FOR EACH tt-data NO-LOCK:

        FOR EACH estrutura NO-LOCK 
            WHERE estrutura.it-codigo = ITEM.it-codigo
              AND estrutura.data-inicio  <= tt-data.periodo-data
              AND estrutura.data-termino >  tt-data.periodo-data:

            FIND FIRST b-item NO-LOCK
                WHERE b-item.it-codigo = estrutura.es-codigo NO-ERROR.
            
            ASSIGN i-nivel = 1
                   i-seq-saida = i-seq-saida + 1.
            
            IF NOT CAN-FIND(FIRST b-estrutura NO-LOCK
                            WHERE b-estrutura.it-codigo = estrutura.es-codigo)THEN DO:
        
                 CREATE tt-estrutura.                                       
                 ASSIGN tt-estrutura.codigo-item    = ITEM.it-codigo        
                        tt-estrutura.it-codigo      = estrutura.it-codigo   
                        tt-estrutura.it-codigo-desc = ITEM.desc-item        
                        tt-estrutura.es-codigo      = estrutura.es-codigo   
                        tt-estrutura.es-codigo-desc = b-item.desc-item      
                        tt-estrutura.nivel          = i-nivel               
                        tt-estrutura.data           = tt-data.periodo-data
                        tt-estrutura.quantidade     = estrutura.quant-usada.


                 /*
                 assign de-quant-usada =  de-quantidade * estrutura.quant-usada *
                                        (estrutura.proporcao / 100)
                      de-quant-liquid = de-quantidade * estrutura.quant-usada *
                                        (estrutura.proporcao / 100) * (1 - (estrutura.fator-perda / 100)).            
                                        */
                
            END.
            ELSE DO:

                IF tt-param.tg-semi THEN DO:
                    CREATE tt-estrutura.                                       
                    ASSIGN tt-estrutura.codigo-item    = ITEM.it-codigo        
                           tt-estrutura.it-codigo      = estrutura.it-codigo   
                           tt-estrutura.it-codigo-desc = ITEM.desc-item        
                           tt-estrutura.es-codigo      = estrutura.es-codigo   
                           tt-estrutura.es-codigo-desc = b-item.desc-item      
                           tt-estrutura.nivel          = i-nivel               
                           tt-estrutura.data           = tt-data.periodo-data
                           tt-estrutura.quantidade     = estrutura.quant-usada.
                END.
        
                RUN pi-estrutura(INPUT estrutura.es-codigo,
                                 INPUT estrutura.quant-usada,
                                 INPUT tt-data.periodo-data).
            END.
            ASSIGN i-nivel = i-nivel - 1.

        END.

    END.

END PROCEDURE.


PROCEDURE pi-estrutura:
    
    DEFINE INPUT PARAMETER p-es-codigo LIKE estrutura.es-codigo NO-UNDO.
    DEFINE INPUT PARAMETER p-quant-usada LIKE estrutura.quant-usada NO-UNDO.
    DEFINE INPUT PARAMETER p-data AS DATE NO-UNDO.
    
    FOR EACH estrutura NO-LOCK
        WHERE estrutura.it-codigo = p-es-codigo
          AND estrutura.data-inicio <= p-data
          AND estrutura.data-termino > p-data:
        
        FIND FIRST b-item NO-LOCK
            WHERE b-item.it-codigo = estrutura.es-codigo NO-ERROR.

        ASSIGN i-nivel = i-nivel + 1
               i-seq-saida = i-seq-saida + 1.

        IF NOT CAN-FIND(FIRST b-estrutura NO-LOCK
                        WHERE b-estrutura.it-codigo = estrutura.es-codigo)THEN DO:

            CREATE tt-estrutura.                                       
            ASSIGN tt-estrutura.codigo-item    = ITEM.it-codigo        
                   tt-estrutura.it-codigo      = estrutura.it-codigo   
                   tt-estrutura.it-codigo-desc = ITEM.desc-item        
                   tt-estrutura.es-codigo      = estrutura.es-codigo   
                   tt-estrutura.es-codigo-desc = b-item.desc-item      
                   tt-estrutura.nivel          = i-nivel               
                   tt-estrutura.data           = tt-data.periodo-data
                   tt-estrutura.quantidade     = p-quant-usada * estrutura.quant-usada.
            
        END.
        ELSE DO:

            IF tt-param.tg-semi THEN DO:
                CREATE tt-estrutura.                                       
                ASSIGN tt-estrutura.codigo-item    = ITEM.it-codigo        
                       tt-estrutura.it-codigo      = estrutura.it-codigo   
                       tt-estrutura.it-codigo-desc = ITEM.desc-item        
                       tt-estrutura.es-codigo      = estrutura.es-codigo   
                       tt-estrutura.es-codigo-desc = b-item.desc-item      
                       tt-estrutura.nivel          = i-nivel               
                       tt-estrutura.data           = tt-data.periodo-data
                       tt-estrutura.quantidade     = p-quant-usada * estrutura.quant-usada.
            END.
            
            RUN pi-estrutura(INPUT estrutura.es-codigo,
                             INPUT p-quant-usada * estrutura.quant-usada,
                             INPUT p-data).
        END.
        ASSIGN i-nivel = i-nivel - 1.
    END.
END.

FOR EACH tt-data NO-LOCK:
    PUT STREAM str-excel UNFORMATTED
        ";" tt-data.periodo-data.
END. 

IF tt-param.tg-semi THEN 
    PUT STREAM str-excel UNFORMATTED ";Situa‡Æo;Motivo;Comprador;Nome;Fornecedor;Ressuprimento;".


FOR EACH tt-estrutura NO-LOCK
    BREAK BY tt-estrutura.codigo-item
          BY tt-estrutura.es-codigo:

    IF FIRST-OF(tt-estrutura.codigo-item) OR FIRST-OF(tt-estrutura.es-codigo) THEN DO:
        CREATE tt-itens.
        ASSIGN tt-itens.it-codigo      = tt-estrutura.it-codigo
               tt-itens.es-codigo      = tt-estrutura.es-codigo
               tt-itens.codigo-item    = tt-estrutura.codigo-item
               tt-itens.it-codigo-desc = tt-estrutura.it-codigo-desc
               tt-itens.es-codigo-desc = tt-estrutura.es-codigo-desc
               tt-itens.nivel          = tt-estrutura.nivel.

        IF tt-param.tg-semi THEN DO:
            FIND FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo = tt-itens.es-codigo NO-ERROR.
            IF AVAIL ITEM THEN DO:                

                find first item-fornec-estab no-lock
                     where item-fornec-estab.it-codigo    = ITEM.it-codigo
                       AND item-fornec-estab.cod-estabel = tt-param.cod-estabel
                       and item-fornec-estab.ativo
                       AND item-fornec-estab.perc-compra > 0 no-error.
                if avail item-fornec-estab then do:
                    find emitente where emitente.cod-emitente = item-fornec-estab.cod-emitente NO-LOCK NO-ERROR.
                    assign tt-itens.nome-abrev = emitente.nome-abrev.
                end.
                ELSE DO:
                    find first item-fornec no-lock
                         where item-fornec.it-codigo = ITEM.it-codigo
                           and item-fornec.ativo
                           AND item-fornec.perc-compra > 0 no-error.
                    if avail item-fornec then do:
                        find emitente where emitente.cod-emitente = item-fornec.cod-emitente NO-LOCK NO-ERROR.
                        assign tt-itens.nome-abrev = emitente.nome-abrev.
                    end.
                END.

                ASSIGN i-situacao      = 0
                       l-sit-dif-estab = NO.

                FOR EACH  item-uni-estab NO-LOCK 
                    WHERE item-uni-estab.it-codigo = ITEM.it-codigo:

                    IF i-situacao = 0 THEN
                        ASSIGN i-situacao = item-uni-estab.cod-obsoleto.
                    ELSE DO:
                        IF i-situacao <> item-uni-estab.cod-obsoleto THEN
                            ASSIGN l-sit-dif-estab = YES.
                    END.                                  
                END.

                IF NOT l-sit-dif-estab THEN DO:

                    FIND FIRST int-item NO-LOCK
                         WHERE int-item.it-codigo = tt-itens.es-codigo NO-ERROR.
                    IF AVAIL int-item THEN DO:                    
                        CASE int-item.motivo-situacao:
                            WHEN 0 THEN
                                ASSIGN tt-itens.motivo = "".
                            WHEN 1 THEN
                                ASSIGN tt-itens.motivo = "Altera‡Æo de estrutura".
                            WHEN 2 THEN
                                ASSIGN tt-itens.motivo = "Phase out produto".
                            WHEN 3 THEN
                                ASSIGN tt-itens.motivo = "Item EOL".
                            WHEN 4 THEN
                                ASSIGN tt-itens.motivo = "Bloqueado para compra".
                        END CASE.                    
                    END.
                END.

                FIND FIRST item-uni-estab NO-LOCK
                     WHERE item-uni-estab.cod-estabel = tt-param.cod-estabel
                       AND item-uni-estab.it-codigo    = item.it-codigo NO-ERROR.
                IF NOT AVAIL item-uni-estab THEN DO:
                    FIND FIRST item-uni-estab NO-LOCK
                         WHERE item-uni-estab.it-codigo    = item.it-codigo NO-ERROR.
                END.
                IF AVAIL item-uni-estab THEN DO:
                    ASSIGN tt-itens.cod-comprado  = item-uni-estab.cod-comprado                          
                           tt-itens.ressuprimento = item-uni-estab.res-for-comp.
                
                    ASSIGN tt-itens.cod-obsoleto  = {ininc/i17in172.i 4 item-uni-estab.cod-obsoleto}.                                       
                
                    FIND FIRST usuar-mater NO-LOCK
                         WHERE usuar-mater.cod-usuario = item-uni-estab.cod-comprado NO-ERROR.
                
                    ASSIGN tt-itens.nome-comprador = IF AVAIL usuar-mater THEN usuar-mater.nome-usuar ELSE "".
                
                    FIND FIRST int-item-uni-estab NO-LOCK
                         WHERE int-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel 
                           AND int-item-uni-estab.it-codigo   = item-uni-estab.it-codigo NO-ERROR.       
                    IF AVAIL int-item-uni-estab THEN DO:                           
                
                        CASE int-item-uni-estab.int-1:
                            WHEN 1 THEN
                                ASSIGN tt-itens.motivo = "Altera‡Æo estrutura".
                            WHEN 2 THEN
                                ASSIGN tt-itens.motivo = "Phase out produto".
                            WHEN 3 THEN
                                ASSIGN tt-itens.motivo = "Item EOL".
                            WHEN 4 THEN
                                ASSIGN tt-itens.motivo = "Bloqueado compra".
                        END CASE.
                    END.
                END.
            END.            
        END.
    END.
END.

FOR EACH tt-itens NO-LOCK
    BY tt-itens.codigo-item
    BY tt-itens.es-codigo:
    
    PUT STREAM str-excel UNFORMATTED SKIP.

    PUT STREAM str-excel UNFORMATTED
        tt-itens.codigo-item    ";"
        tt-itens.it-codigo-desc ";"
        tt-itens.es-codigo      ";"
        tt-itens.es-codigo-desc ";".
    
    FOR EACH tt-data
        BY tt-data.periodo-data:

        ASSIGN d-qtd = 0.
        FOR EACH tt-estrutura NO-LOCK
            WHERE tt-estrutura.codigo-item = tt-itens.codigo-item
              AND tt-estrutura.es-codigo = tt-itens.es-codigo
              AND tt-estrutura.data = tt-data.periodo-data:
            
            ASSIGN d-qtd = d-qtd + tt-estrutura.quantidade.
        END.
        PUT STREAM str-excel UNFORMATTED d-qtd ";".
    END.

    IF tt-param.tg-semi THEN DO:
        PUT STREAM str-excel UNFORMATTED 
            tt-itens.cod-obsoleto ";"
            tt-itens.motivo ";"
            tt-itens.cod-comprador ";"
            tt-itens.nome-comprador ";"
            tt-itens.nome-abrev ";"
            tt-itens.ressuprimento ";".
    END.
    PUT STREAM str-excel UNFORMATTED SKIP.
END.

OUTPUT STREAM str-excel CLOSE.

CREATE "Excel.Application":U chExcel CONNECT NO-ERROR.
IF ERROR-STATUS:ERROR THEN CREATE "Excel.Application":U chExcel.
    
ASSIGN chArquivo     = chExcel:WorkBooks:Open(c-excel).
ASSIGN chPlanilhaMod = chArquivo:Sheets:Item(1).
chPlanilhaMod:Activate().

ASSIGN chExcel:VISIBLE     = TRUE
       chExcel:WindowState = 3.

RELEASE OBJECT chExcel       NO-ERROR.
RELEASE OBJECT chArquivo     NO-ERROR.
RELEASE OBJECT chPlanilhaMod NO-ERROR. 





















