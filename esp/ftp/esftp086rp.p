/*----------------------------------------------------------------------
**  Programa..: esp/ftp/esftp086rp.p
**  Autor.....: Cenci
**  Data......: 29/03/2012
**  Descricao.: Reprova solicita‡Æo de nota fiscal e refaz aloca‡Æo.
-----------------------------------------------------------------------*/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i esftp086 2.00.00.000}

/*---------------------------  Variaveis    ---------------------------*/

{include/i-rpvar.i}
{utp/ut-glob.i}
{esp/ftp/esftp086tt.i}

def temp-table tt-item
    field it-codigo    like item.it-codigo
    field nr-sequencia like it-ped-fiscal.seq.

DEF TEMP-TABLE tt-item-alocados
    FIELD cod-estabel AS CHARACTER
    FIELD it-codigo LIKE item.it-codigo
    FIELD cod-depos LIKE saldo-estoq.cod-depos
    FIELD cod-localiz LIKE saldo-estoq.cod-localiz
    FIELD quantidade  AS DECIMAL
    INDEX ch-principal it-codigo cod-depos cod-localiz.
DEFINE VARIABLE c-item AS CHARACTER   NO-UNDO.
def buffer b-it-ped-fiscal for it-ped-fiscal.
def buffer b-ped-fiscal for ped-fiscal.
def buffer b-wt-fat-ser-lote for wt-fat-ser-lote.

DEFINE VARIABLE h-acomp         AS HANDLE       NO-UNDO.

/*---------------------------  Temp-Tables  ---------------------------*/



DEF VAR i-cont              AS INT.

/*---------------------------  Parƒmetros   ---------------------------*/

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.


/*---------------------------  Frames       ---------------------------*/
FIND FIRST param-global NO-LOCK.
FIND FIRST empresa      NO-LOCK WHERE empresa.ep-codigo = param-global.empresa-pri.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Bloqueia solicita‡Æo de Notas Extras"
       c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE ''
       c-programa     = "ESFTP086"
       c-versao       = "2.00"
       c-revisao      = "000".

{include/i-rpcab.i}

/*---------------------------  Main Block   ---------------------------*/
run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp (input "Imprimindo...").




run pi-acompanhar in h-acomp (input "Buscando dados...").

{include/i-rpout.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.
RUN piProcessamento.
RUN piImprimeParam.

PROCEDURE piImprimeParam:
    DEFINE VARIABLE vDestino         AS CHARACTER   NO-UNDO.
    PAGE.
    CASE tt-param.destino:
        WHEN 1 THEN ASSIGN vDestino = "Impressora". 
        WHEN 2 THEN ASSIGN vDestino = "Arquivo".
        WHEN 3 THEN ASSIGN vDestino = "Terminal".
    END.

    PUT  "SELE€ÇO:"                     SKIP(1)
         "    Digitado: " IF tt-param.digitado     THEN "Sim" ELSE "Nao" SKIP
         "   A Liberar: " IF tt-param.a-liberar    THEN "Sim" ELSE "Nao" SKIP
         "A Relacionar: " IF tt-param.a-relacionar THEN "Sim" ELSE "Nao"
         SKIP(3)
         "IMPRESSÇO:"                   SKIP(1)
         "        Destino:"     
         vDestino                       AT 20 SKIP
         "        Usu rio:"
         c-seg-usuario                  AT 20 SKIP
         "           Data:"
         tt-param.data-exec             AT 20 SKIP
         "           Hora:"
         string(tt-param.hora-exec,"hh:mm") AT 20
         SKIP(3).

END PROCEDURE.

run pi-finalizar in h-acomp.
{include/i-rpclo.i}
RETURN "OK".

/*-----------------------  Internal Procedures  -----------------------*/


PROCEDURE piProcessamento:
DO  TRANSACTION:

    for each b-ped-fiscal NO-LOCK
        where b-ped-fiscal.dt-emissao <= tt-param.da-dt-corte:
        
        IF (tt-param.digitado AND b-ped-fiscal.situacao = 0) OR
           (tt-param.a-liberar AND b-ped-fiscal.situacao = 1) OR
           (tt-param.a-relacionar AND b-ped-fiscal.situacao = 2) THEN DO:
            FIND ped-fiscal OF b-ped-fiscal EXCLUSIVE-LOCK.
            
            ASSIGN ped-fiscal.situacao = 6
                   ped-fiscal.observacao[5] = ped-fiscal.observacao[5] + " Bloqueado automaticamente - data de corte : " + STRING(tt-param.da-dt-corte) + " Usuario " + c-seg-usuario .
    
            PUT "Pedido de nota Extra: " b-ped-fiscal.nr-pedido " Solicitante " b-ped-fiscal.usuario-magnus SKIP.
    
            for each b-it-ped-fiscal where
                     b-it-ped-fiscal.nr-pedido = b-ped-fiscal.nr-pedido no-lock:
                FOR EACH ITEM NO-LOCK
                    WHERE ITEM.it-codigo = b-it-ped-fiscal.it-codigo
                
                       AND ITEM.baixa-estoq = YES:
                
                    RUN pi-acompanhar in h-acomp (input "Item " + ITEM.it-codigo ).
                    
                    PUT "" skip
                        "Item " ITEM.it-codigo SKIP
                        "" SKIP.
                                
                     find tt-item
                             where tt-item.it-codigo = item.it-codigo
                               no-lock no-error.
                    if not avail tt-item then do:
                       create tt-item.
                       assign tt-item.it-codigo    = item.it-codigo.
                    end.    
                    else 
                        next.
                        
                    FOR EACH saldo-estoq EXCLUSIVE-LOCK
                        WHERE saldo-estoq.it-codigo = ITEM.it-codigo:
                        ASSIGN saldo-estoq.qt-alocada = 0.
                    END.
                
                    FOR EACH it-pre-fat NO-LOCK
                        WHERE it-pre-fat.it-codigo = ITEM.it-codigo,
                        FIRST pre-fatur OF it-pre-fat NO-LOCK
                        WHERE pre-fatur.cod-sit-pre = 1,
                        EACH it-dep-fat NO-LOCK
                        WHERE it-dep-fat.cdd-embarq   = it-pre-fat.cdd-embarq  
                          AND it-dep-fat.nr-resumo     = it-pre-fat.nr-resumo    
                          AND it-dep-fat.nome-abrev    = it-pre-fat.nome-abrev   
                          AND it-dep-fat.nr-pedcli     = it-pre-fat.nr-pedcli    
                          AND it-dep-fat.cod-estabel   = pre-fatur.cod-estabel  
                          AND it-dep-fat.nr-sequencia  = it-pre-fat.nr-sequencia 
                          AND it-dep-fat.it-codigo     = it-pre-fat.it-codigo    
                          AND it-dep-fat.cod-refer     = it-pre-fat.cod-refer    
                          AND it-dep-fat.nr-entrega    = it-pre-fat.nr-entrega:
                
                        RUN pi-acompanhar in h-acomp (input "Pre-fatur " + ITEM.it-codigo ).
                
                          PUT "Embarque " it-pre-fat.cdd-embarq 
                              " Pedido " it-pre-fat.nr-pedcli
                              " Deposito " it-dep-fat.cod-depos
                              " Localizacao " it-dep-fat.cod-localiz
                              "qtde Alocada " it-pre-fat.qt-alocada SKIP. 
                
                          RUN pi-atualiza-temp-table (INPUT pre-fatur.cod-estabel,
                                                      INPUT it-pre-fat.it-codigo,
                                                      INPUT it-dep-fat.cod-depos,
                                                      INPUT it-dep-fat.cod-localiz,
                                                      INPUT it-dep-fat.qt-alocada).
                    END.
                
                
                    FOR EACH wt-fat-ser-lote no-LOCK
                            WHERE wt-fat-ser-lote.it-codigo = ITEM.it-codigo,
                              FIRST wt-docto OF wt-fat-ser-lote NO-LOCK
                            WHERE wt-docto.nr-pedcli = "":
                
                        RUN pi-acompanhar in h-acomp (input "wt-fat-ser-lote " + ITEM.it-codigo ).
                
                        PUT  "FAT-SER-LOTE Nota Fiscal " wt-fat-ser-lote.seq-wt-docto
                                            " Deposito " wt-fat-ser-lote.cod-depos
                                            " Quantidade " wt-fat-ser-lote.quantidade[1] SKIP.
                        find b-wt-fat-ser-lote exclusive-lock 
                            where rowid(b-wt-fat-ser-lote) = rowid(wt-fat-ser-lote) no-error.    
                        ASSIGN b-wt-fat-ser-lote.log-1 = YES.
                        release b-wt-fat-ser-lote.
                        RUN pi-atualiza-temp-table (INPUT wt-docto.cod-estabel,
                                                    INPUT wt-fat-ser-lote.it-codigo,
                                                    INPUT wt-fat-ser-lote.cod-depos,
                                                    INPUT wt-fat-ser-lote.cod-localiz,
                                                    INPUT wt-fat-ser-lote.quantidade[1]).
                    END.
                
                    FOR EACH fat-ser-lote EXCLUSIVE-LOCK
                            WHERE fat-ser-lote.it-codigo = ITEM.it-codigo,
                            FIRST nota-fiscal OF fat-ser-lote NO-LOCK
                            WHERE nota-fiscal.dt-confirma = ?
                            AND nota-fiscal.dt-cancel = ?:
                
                        RUN pi-acompanhar in h-acomp (input "fat-ser-lote " + ITEM.it-codigo ).
                
                        PUT  "FAT-SER-LOTE Nota Fiscal " fat-ser-lote.nr-nota-fis
                                          " Dt Emissao " nota-fiscal.dt-emis-nota
                                            " Deposito " fat-ser-lote.cod-depos
                                              " Pedido " nota-fiscal.nr-pedcli     FORMAT "x(7)"
                                            " qt Baixa " fat-ser-lote.qt-baixada[1] SKIP.
                            
                
                        ASSIGN fat-ser-lote.log-1 = YES.
                        RUN pi-atualiza-temp-table (INPUT nota-fiscal.cod-estabel,
                                                    INPUT fat-ser-lote.it-codigo,
                                                    INPUT fat-ser-lote.cod-depos,
                                                    INPUT fat-ser-lote.cod-localiz,
                                                    INPUT fat-ser-lote.qt-baixada[1]).
                    END.
                    
                                                                                          
                    FOR EACH it-ped-fiscal
                        WHERE it-ped-fiscal.it-codigo = ITEM.it-codigo:
        
                
                        RUN pi-acompanhar in h-acomp (input "it-ped-fiscal " + ITEM.it-codigo ).
                        FIND ped-fiscal
                            WHERE ped-fiscal.nr-pedido = it-ped-fiscal.nr-pedido
                            EXCLUSIVE-LOCK NO-ERROR.
                
                        RUN pi-atualiza-temp-table (INPUT ped-fiscal.cod-estabel,
                                                    INPUT it-ped-fiscal.it-codigo,
                                                    INPUT it-ped-fiscal.cod-depos,
                                                    INPUT it-ped-fiscal.cod-localiz,
                                                    INPUT 0).
                
                        IF ped-fiscal.situacao < 5  THEN DO:
                            put " Ped fiscal " ped-fiscal.cod-estabel
                                " IT-PED-FISCAL " it-ped-fiscal.nr-pedido 
                                " Data Emissao " ped-fiscal.dt-emissao 
                                " Deposito " it-ped-fiscal.cod-depos
                                " Quandidade  " it-ped-fiscal.qtde SKIP.
                
                            RUN pi-atualiza-temp-table (INPUT ped-fiscal.cod-estabel,
                                                        INPUT it-ped-fiscal.it-codigo,
                                                        INPUT it-ped-fiscal.cod-depos,
                                                        INPUT it-ped-fiscal.cod-localiz,
                                                        INPUT it-ped-fiscal.qtde).
                
                        END.
                    END.
                END.
            end.
        END.
    end.
    
    FOR EACH tt-item-alocados:
    
        
        for each saldo-estoq
            where saldo-estoq.it-codigo   = tt-item-alocados.it-codigo
              and saldo-estoq.cod-estabel = tt-item-alocados.cod-estabel
              and saldo-estoq.cod-depos   = tt-item-alocados.cod-depos
              and saldo-estoq.cod-local   = tt-item-alocados.cod-localiz:
    
            RUN pi-acompanhar in h-acomp (input "Atualizando Quantidade Alocada  " + saldo-estoq.it-codigo ).
    
            put tt-item-alocados.it-codigo " " tt-item-alocados.cod-estabel " " tt-item-alocados.cod-depos " " tt-item-alocados.cod-localiz
                " " tt-item-alocados.quantidade 
                " SALDO-ESTOQ " saldo-estoq.qtidade-atu  saldo-estoq.qt-aloc-ped saldo-estoq.qt-alocada 
                tt-item-alocados.quantidade SKIP.
    
            ASSIGN saldo-estoq.qt-alocada = tt-item-alocados.quantidade.
    
        END.
    
    END.
END.
END PROCEDURE.



PROCEDURE pi-atualiza-temp-table:
    DEF INPUT PARAMETER c-cod-estabel AS CHARACTER.
    DEF INPUT PARAMETER c-it-codigo LIKE it-ped-fiscal.it-codigo.
    DEF INPUT PARAMETER c-cod-depos LIKE it-ped-fiscal.cod-depos.
    DEF INPUT PARAMETER c-cod-localiz LIKE it-ped-fiscal.cod-localiz.
    DEF INPUT PARAMETER de-qtde       LIKE it-ped-fiscal.qtde.
    FIND ITEM
        WHERE ITEM.it-codigo = c-it-codigo NO-LOCK NO-ERROR.
    IF ITEM.tipo-contr <> 4 AND
       ITEM.baixa-estoq = YES THEN DO:
    

        FIND tt-item-alocados
            WHERE tt-item-alocados.cod-estabel = c-cod-estabel
              AND tt-item-alocados.it-codigo   = c-it-codigo
              AND tt-item-alocados.cod-depos   = c-cod-depos
              AND tt-item-alocados.cod-localiz = c-cod-localiz
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAIL tt-item-alocados THEN DO:
            CREATE tt-item-alocados.
            assign tt-item-alocados.cod-estabel = c-cod-estabel
                   tt-item-alocados.it-codigo   = c-it-codigo
                   tt-item-alocados.cod-depos   = c-cod-depos
                   tt-item-alocados.cod-localiz = c-cod-localiz.
    
        END.
        ASSIGN tt-item-alocados.quantidade  = tt-item-alocados.quantidade + de-qtde.
    END.
END PROCEDURE.

