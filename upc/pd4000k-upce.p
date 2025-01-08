/***********************************************************************
**  Programa..: UPC\PD4000K-UPC.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: Gera Transferˆncia Material
**  VersÆo....: 001 16/11/2004
**                  Desenvolvimento Programa
************************************************************************/
{cdp/cd0666.i}        /* Defini‡Æo temp-table de erros */
{esapi/esapi002tt.i}    /* Definicao da temp-table de origem */
{upc/btb910za-upc.i}
/****************************  Variaveis    ****************************/
DEF NEW GLOBAL SHARED VAR gr-ped-venda      AS ROWID         NO-UNDO.
DEF NEW GLOBAL SHARED VAR whbrEntregas      AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE cReturn AS CHARACTER  NO-UNDO.
DEF BUFFER bsaldo-estoq FOR saldo-estoq.

DEF VAR c-grupo-aloca  LIKE estabelec.grupo-aloca   NO-UNDO.
DEF VAR deQtDisponivel LIKE saldo-estoq.qtidade-atu NO-UNDO.
DEF VAR vQtAloca       LIKE saldo-estoq.qtidade-atu NO-UNDO.
DEF VAR vQtTransferida LIKE saldo-estoq.qtidade-atu NO-UNDO.
DEFINE VARIABLE c_cod_estab_usuar AS CHARACTER   NO-UNDO.
DEFINE TEMP-TABLE tt-AtuErro LIKE tt-erro.

SESSION:SET-WAIT-STATE("general":U).
FOR FIRST ped-venda 
    WHERE ROWID(ped-venda) = gr-ped-venda NO-LOCK:
    ASSIGN c_cod_estab_usuar = ped-venda.cod-estabel.
    FOR FIRST estabelec NO-LOCK 
        WHERE estabelec.cod-estabel = ped-venda.cod-estabel:
        ASSIGN c-grupo-aloca = estabelec.grupo-aloca.
    END.

    FOR EACH  estabelec      
        WHERE estabelec.grupo-aloc   = c-grupo-aloca,
        EACH  ped-ent OF ped-venda NO-LOCK
        WHERE (ped-ent.qt-pedida - ped-ent.qt-atendida) > 0:


        ASSIGN vQtAloca = (ped-ent.qt-pedida - ped-ent.qt-atendida).
        DO  WHILE vQtAloca > 0:
            FIND FIRST saldo-estoq NO-LOCK 
                 WHERE saldo-estoq.cod-estabel = estabelec.cod-estabel
                 AND   saldo-estoq.it-codigo   = ped-ent.it-codigo
                 AND   saldo-estoq.cod-refer   = ped-ent.cod-refer
                 AND  (saldo-estoq.cod-depos   = "EXP")
                 AND   saldo-estoq.cod-localiz = ""
                 AND  (saldo-estoq.qtidade-atu - 
                       (saldo-estoq.qt-alocada  + 
                        saldo-estoq.qt-aloc-ped +  
                        saldo-estoq.qt-aloc-prod)) >= (ped-ent.qt-pedida - ped-ent.qt-atendida) NO-ERROR.
            IF  NOT AVAIL saldo-estoq THEN
                RUN piTransfereMaterial. 
            ELSE ASSIGN vQtAloca = 0.

            IF NOT CAN-FIND(tt-erro) THEN
                 ASSIGN vQtAloca = vQtAloca - vQtTransferida.
            ELSE ASSIGN vQtAloca = 0.
        END.
    END.
    SESSION:SET-WAIT-STATE("":U).

    FOR EACH tt-erro. DELETE tt-erro. END.
    FOR EACH tt-AtuErro.
        CREATE tt-Erro.
        BUFFER-COPY tt-AtuErro TO tt-Erro.
    END.

    if  can-find(first tt-erro) then
        run cdp/cd0666.w (input table tt-erro).

    APPLY 'value-changed':U to whbrEntregas.

END.

SESSION:SET-WAIT-STATE("":U).

{upc/pd4000k-upce.i}

