/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i escep076rp 2.00.00.001}  /*** 010001 ***/
{include/i_fnctrad.i}

{utp/ut-glob.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

def var c-liter-par                  as character format "x(13)":U.
def var c-liter-sel                  as character format "x(10)":U.
def var c-liter-imp                  as character format "x(12)":U.    
def var c-destino                    as character format "x(15)":U.
def var c-imprimir                   as char format "x(30)" no-undo.
DEF VAR c-linha                      AS CHAR NO-UNDO.
DEF VAR arquivoS                     AS CHAR NO-UNDO. 
/****************************  Definitions  ****************************/

DEF STREAM str-excel.

{esp/cep/escep076tt.i}


/****************************  Temp-Tables  ****************************/
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
     create tt-digita.
     raw-transfer tt-raw-digita.raw-digita to tt-digita.
end. 

/****************************  Frames       ****************************/

def var h-acomp         as handle no-undo.    

def temp-table tt-se
    field it-codigo      like item.it-codigo
    field cod-depos      like deposito.cod-depos
    FIELD cod-estabel    LIKE saldo-estoq.cod-estabel
    field descricao      as char format "X(36)"
    field qtde           as dec format ">>>>,>>9.99"
    FIELD uniao          AS CHAR FORMAT "X(07)"
    index ch-pri is primary UNIQUE cod-estabel it-codigo cod-depos
    INDEX uniao1 uniao it-codigo.


DEF TEMP-TABLE tt-controle
    FIELD uniao  AS CHAR FORMAT "X(07)" 
    INDEX ch-pri IS PRIMARY UNIQUE uniao. 

DEF TEMP-TABLE tt-item
    FIELD it-codigo   LIKE saldo-estoq.it-codigo
    FIELD descricao   LIKE ITEM.desc-item
    INDEX ch-pri IS PRIMARY UNIQUE it-codigo.

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.


{include/i-rpvar.i}
{utp/ut-glob.i}

find empresa
    where empresa.ep-codigo = v_cdn_empres_usuar
    no-lock no-error.
find first param-global no-lock no-error.

{utp/ut-liter.i Espec¡ficos_Intelbras * }
assign c-sistema = return-value.
{utp/ut-liter.i Relat¢rio_de_Saldos_Item_Dep¢sito * }
assign c-titulo-relat = return-value.
assign c-empresa     = param-global.grupo
       c-programa    = "{&programa}":U
       c-versao      = "1.00":U
       c-revisao     = "000"
       c-destino     = {varinc/var00002.i 04 tt-param.destino}.

{include/tt-edit.i}
{include/pi-edit.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ***************************  Main Block  *************************** */

do on stop undo, leave:
    {include/i-rpout.i &pagesize="0"}

    run utp/ut-acomp.p persistent set h-acomp.  
    
    run pi-inicializar in h-acomp (input "Imprimindo":U). 

    EMPTY TEMP-TABLE tt-se.

    IF CAN-FIND (FIRST tt-digita NO-LOCK) THEN DO:
        FOR EACH tt-digita NO-LOCK:
            FOR EACH saldo-estoq no-lock
                where saldo-estoq.cod-estabel >= tt-param.cod-estabel-ini
                AND saldo-estoq.cod-estabel <= tt-param.cod-estabel-fim
                and saldo-estoq.it-codigo >= tt-param.it-codigo-ini
                and saldo-estoq.it-codigo <= tt-param.it-codigo-fim
                and saldo-estoq.cod-depos = tt-digita.cod-depos
                AND saldo-estoq.qtidade-atu > 0,
                EACH ITEM NO-LOCK WHERE ITEM.it-codigo = saldo-estoq.it-codigo :
            
                run pi-acompanhar in h-acomp (input "Lendo saldo estoque item " + saldo-estoq.it-codigo). 
            
                FIND FIRST tt-se NO-LOCK
                    WHERE  tt-se.cod-estabel = saldo-estoq.cod-estabel
                      AND  tt-se.it-codigo   = saldo-estoq.it-codigo
                      AND  tt-se.cod-depos   = saldo-estoq.cod-depos NO-ERROR.
            
                IF NOT AVAIL tt-se THEN DO:
            
                    create tt-se.
                    assign tt-se.cod-estabel = saldo-estoq.cod-estabel
                           tt-se.it-codigo   = saldo-estoq.it-codigo
                           tt-se.cod-depos   = saldo-estoq.cod-depos
                           tt-se.descricao   = ITEM.desc-item
                           tt-se.uniao       = saldo-estoq.cod-estabel + "|" + saldo-estoq.cod-depos.
        
                END.
        
                assign tt-se.qtde = tt-se.qtde +
                                   (saldo-estoq.qtidade-atu -
                                    saldo-estoq.qt-alocada -
                                    saldo-estoq.qt-aloc-prod).
            END.
        END.
    END.
    ELSE DO:
        for each saldo-estoq no-lock
            where saldo-estoq.cod-estabel >= tt-param.cod-estabel-ini
            AND saldo-estoq.cod-estabel <= tt-param.cod-estabel-fim
            and saldo-estoq.it-codigo >= tt-param.it-codigo-ini
            and saldo-estoq.it-codigo <= tt-param.it-codigo-fim
            and saldo-estoq.cod-depos >= tt-param.cod-depos-ini
            and saldo-estoq.cod-depos <= tt-param.cod-depos-fim
            AND saldo-estoq.qtidade-atu > 0,
            EACH ITEM NO-LOCK WHERE ITEM.it-codigo = saldo-estoq.it-codigo :
        
            run pi-acompanhar in h-acomp (input "Lendo saldo estoque item " + saldo-estoq.it-codigo). 
        
            FIND FIRST tt-se NO-LOCK
                WHERE  tt-se.cod-estabel = saldo-estoq.cod-estabel
                  AND  tt-se.it-codigo   = saldo-estoq.it-codigo
                  AND  tt-se.cod-depos   = saldo-estoq.cod-depos NO-ERROR.
        
            IF NOT AVAIL tt-se THEN DO:
        
                create tt-se.
                assign tt-se.cod-estabel = saldo-estoq.cod-estabel
                       tt-se.it-codigo   = saldo-estoq.it-codigo
                       tt-se.cod-depos   = saldo-estoq.cod-depos
                       tt-se.descricao   = ITEM.desc-item
                       tt-se.uniao       = saldo-estoq.cod-estabel + "|" + saldo-estoq.cod-depos.
        
            END.
            
            assign tt-se.qtde = tt-se.qtde +
                               (saldo-estoq.qtidade-atu -
                                saldo-estoq.qt-alocada -
                                saldo-estoq.qt-aloc-prod).
        END.
    END.
    
    ASSIGN arquivoS = c-dir-arquivo-session + "ESCEP076" + ".csv".
    
    PUT UNFORMATTED "Arquivo salvo em " arquivoS.
    
    OUTPUT STREAM str-excel TO VALUE (arquivoS) CONVERT TARGET "iso8859-1" .
    
    PUT STREAM str-excel "Itens;Descricao;".
    
    FOR EACH tt-se NO-LOCK
        BREAK BY tt-se.uniao: 
        
        IF FIRST-OF(tt-se.uniao) THEN DO:

            PUT STREAM str-excel  tt-se.uniao ";".
            
            CREATE tt-controle.
            ASSIGN tt-controle.uniao = tt-se.cod-estabel + "|" + tt-se.cod-depos. 
           
        
        END.

        FIND FIRST tt-item NO-LOCK
             WHERE tt-item.it-codigo = tt-se.it-codigo
               AND tt-item.descricao = tt-se.descricao  NO-ERROR.

        IF NOT AVAIL tt-item THEN DO:

            CREATE tt-item.
            ASSIGN tt-item.it-codigo = tt-se.it-codigo
                   tt-item.descricao = tt-se.descricao.
                   
        
        END.

    END.

    PUT STREAM str-excel skip.
    
   
    FOR EACH tt-item NO-LOCK: 
        
        PUT STREAM str-excel
            tt-item.it-codigo ";"
            tt-item.descricao ";" .

        FOR EACH tt-controle NO-LOCK:
        
            FIND FIRST tt-se NO-LOCK
                 WHERE tt-se.uniao       = tt-controle.uniao 
                   AND tt-se.it-codigo   = tt-item.it-codigo NO-ERROR.
    
            IF AVAIL tt-se THEN 

                PUT STREAM str-excel tt-se.qtde ";".
            ELSE 
                PUT STREAM str-excel "0;". 

        END.
        PUT STREAM str-excel SKIP.
    END. 
    OUTPUT STREAM str-excel CLOSE.

    run pi-finalizar in h-acomp.

    {include/i-rpclo.i}

    return "ok".
end.



