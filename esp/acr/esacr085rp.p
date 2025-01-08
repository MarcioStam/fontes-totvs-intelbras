/****************************************************************************
** Programa: ESACR085RP.P
** Autor...: Andrey M Oliveira
** Data....: 18/04/2023
****************************************************************************/

define temp-TABLE tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    FIELD arquivo-import   AS CHAR.

def temp-table tt_file_import no-undo
    field tta_num_line             AS INT
    field tta_num_pedido           LIKE ped-venda.nr-pedido
    field tta_status               AS CHAR.

DEFINE TEMP-TABLE tt_relat
   FIELD num_pedido  LIKE ped-venda.nr-pedido
   FIELD cod_sit_ped AS CHAR
   FIELD mensagem    AS CHAR FORMAT "x(50)".

{esp/esb/esesb000.i}

DEFINE TEMP-TABLE tt-pedido-integra NO-UNDO
    FIELD r-rowid        AS ROWID
    FIELD i-origem-inegr AS INT. /*1 - Completa Pedido, 2 - Faturamento, 3 - Atualiza saldo, 4 - Cancelamento */

DEF VAR raw-deps   AS RAW    NO-UNDO.
DEF VAR h-acomp    AS HANDLE NO-UNDO.
DEF VAR v_num_line AS INT    NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHAR NO-UNDO.

def temp-TABLE tt-raw-digita NO-UNDO
    field raw-digita   as raw.

DEFINE VARIABLE c-linha         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arquivo-saida AS CHARACTER   NO-UNDO.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-LOCK NO-ERROR.

IF  tt-param.arquivo-import <> "" THEN DO:

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (INPUT "Executando...").

    EMPTY TEMP-TABLE tt_file_import NO-ERROR.
    INPUT FROM VALUE(tt-param.arquivo-import) NO-CONVERT.
    
    REPEAT:
        ASSIGN v_num_line = v_num_line + 1.
        IMPORT UNFORMATTED c-linha.
    
        RUN pi-acompanhar IN h-acomp (INPUT "Importando: " + STRING(v_num_line)).
    
        IF  ENTRY(1, c-linha, ";") BEGINS "Ped" THEN
            NEXT.

        CREATE tt_file_import.
        ASSIGN tt_file_import.tta_num_line   = v_num_line
               tt_file_import.tta_num_pedido = int(ENTRY(1, c-linha, ";"))
               tt_file_import.tta_status     = TRIM(ENTRY(3, c-linha, ";")).
    END.

    ASSIGN v_num_line = 0.
    
    FOR EACH tt_file_import NO-LOCK:
        ASSIGN v_num_line = v_num_line + 1.
    
        RUN pi-acompanhar IN h-acomp (INPUT "Integrando - Linha: " + STRING(v_num_line) 
                                                                   + " - Pedido: " 
                                                                   + STRING(tt_file_import.tta_num_pedido)).

        FIND FIRST ped-venda 
            WHERE ped-venda.nr-pedido = tt_file_import.tta_num_pedido NO-LOCK NO-ERROR.
        
        IF  AVAIL ped-venda THEN DO:
        
            IF  tt_file_import.tta_status = "Cancelado" THEN DO:
                
                IF  ped-venda.cod-sit-ped = 6 THEN DO: /* Cancelado */
                    EMPTY TEMP-TABLE tt-pedido-integra.

                    CREATE tt-pedido-integra.
                    ASSIGN tt-pedido-integra.r-rowid        = ROWID(ped-venda)
                           tt-pedido-integra.i-origem-inegr = 4.

                    RAW-TRANSFER tt-pedido-integra TO raw-deps.

                    RUN esp/trgw/wdi154a.p (INPUT raw-deps,
                                            INPUT 'msg0310',
                                            OUTPUT TABLE resultado).

                    IF  RETURN-VALUE = "OK" THEN DO:
                        CREATE tt_relat.
                        ASSIGN tt_relat.num_pedido  = ped-venda.nr-pedido
                               tt_relat.cod_sit_ped = tt_file_import.tta_status
                               tt_relat.mensagem    = "Integra‡Æo efetuada com sucesso".
                    END.
                END.
                ELSE DO:
                    CREATE tt_relat.
                    ASSIGN tt_relat.num_pedido  = ped-venda.nr-pedido
                           tt_relat.cod_sit_ped = tt_file_import.tta_status
                           tt_relat.mensagem    = "Situa‡Æo do pedido no TOTVS diferente de Cancelado".
                END.
            END.

            IF  tt_file_import.tta_status = "Atendido Total" THEN DO:
                
                IF  ped-venda.cod-sit-ped = 3 /* Atendido Total */ THEN DO:            
                    EMPTY TEMP-TABLE tt-pedido-integra.
                    
                    CREATE tt-pedido-integra.
                    ASSIGN tt-pedido-integra.r-rowid        = ROWID(ped-venda)
                           tt-pedido-integra.i-origem-inegr = 3.
                    
                    RAW-TRANSFER tt-pedido-integra TO raw-deps.
                    
                    RUN esp/trgw/wdi154a.p (INPUT raw-deps,
                                            INPUT 'msg0310',
                                            OUTPUT TABLE resultado).
            
                    IF  RETURN-VALUE = "OK" THEN DO:
                        CREATE tt_relat.
                        ASSIGN tt_relat.num_pedido  = ped-venda.nr-pedido
                               tt_relat.cod_sit_ped = tt_file_import.tta_status
                               tt_relat.mensagem    = "Integra‡Æo efetuada com sucesso".
                    END.
                END.
                ELSE DO:
                    CREATE tt_relat.
                    ASSIGN tt_relat.num_pedido  = ped-venda.nr-pedido
                           tt_relat.cod_sit_ped = tt_file_import.tta_status
                           tt_relat.mensagem    = "Situa‡Æo do pedido no TOTVS diferente de Atendido Total".
                END.
            END.
        END.
    END.
    
    IF  NOT OPSYS = "unix" THEN
        ASSIGN c-arquivo-saida = "\\erpapp\spool\" + v_cod_usuar_corren + "\" + STRING(TIME) + "_esacr085.csv".
    ELSE
        ASSIGN c-arquivo-saida = "/mnt/spool/" + v_cod_usuar_corren + "/" + STRING(TIME) + "_esacr085.csv".

    OUTPUT TO VALUE (c-arquivo-saida) NO-CONVERT.

    PUT UNFORMATTED "Pedido;Status;Mensagem" SKIP.

    FOR EACH tt_relat:
        PUT UNFORMATTED string(tt_relat.num_pedido) + ";" +
                               tt_relat.cod_sit_ped + ";" +
                               tt_relat.mensagem SKIP.
    END.

    IF  NOT OPSYS = "unix" THEN DO:
        DOS SILENT START excel VALUE(c-arquivo-saida).
    END.
    
    OUTPUT CLOSE.
    INPUT CLOSE.

    RUN pi-finalizar in h-acomp.
END.

RETURN "OK":U.
