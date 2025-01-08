/***********************************************************************
**  Programa..: UPC\eq0506B-UPC.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: DEZEMBRO/2004 - Desenvolvimento
**  Descricao.: UPC Manutená∆o Preparaá∆o Faturamento Manual
**  Vers∆o....: 001 06/12/2004
**                  Desenvolvimento Programa
**               UPC bot‰es "Alocaá∆o Total" e "Aloca Item Selecionado" 
**               para realizar FIFO da AE no momento alocaá∆o do item;
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEF VAR c-objeto        AS CHAR                     NO-UNDO.
DEF VAR l-ok            AS LOGICAL                  NO-UNDO.
DEF VAR h-frame         AS HANDLE                   NO-UNDO.
DEF VAR cReturn         AS CHAR                     NO-UNDO.
DEF VAR c-grupo-aloca   LIKE estabelec.grupo-aloca  NO-UNDO.
DEF VAR h-buffer        AS HANDLE                   NO-UNDO.
DEF VAR ponteiro        AS WIDGET-HANDLE            NO-UNDO.

DEF VAR vQtAloca       LIKE saldo-estoq.qtidade-atu NO-UNDO.
DEF VAR vQtTransferida LIKE saldo-estoq.qtidade-atu NO-UNDO.

DEFINE VARIABLE c_cod_estab_usuar AS CHARACTER   NO-UNDO.

DEFINE BUFFER bsaldo-estoq FOR saldo-estoq.

assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                        p-wgh-object:file-name,"~/").
{utp/ut-glob.i}  
{cdp/cd0666.i}        /* Definiá∆o temp-table de erros */
{esapi/esapi002tt.i}    /* Definicao da temp-table de origem */
{upc/btb910za-upc.i}

DEFINE TEMP-TABLE tt-AtuErro LIKE tt-erro.

/*RUN piMessage.*/
/****************************  Variaveis    ****************************/
IF  p-ind-event   = "AFTER-PI-NARRATIVA" AND 
    p-ind-object  = "CONTAINER"          AND 
    c-objeto      = "FTAPI300.P"         AND 
    p-row-table  <> ? THEN DO:

    SESSION:SET-WAIT-STATE("general":U).
    
    FOR FIRST ped-ent NO-LOCK
        WHERE ROWID(ped-ent) = p-row-table
        AND   (ped-ent.qt-pedida - ped-ent.qt-atendida) > 0,
        FIRST ped-item OF ped-ent NO-LOCK,                 
        FIRST ped-venda NO-LOCK OF ped-item:
        /*
        IF c-seg-usuario = "ADM" THEN
        MESSAGE 'Item do pedido com saldo a atender'    SKIP(2) 
                'nr-pedcli    ' ped-item.nr-pedcli      SKIP
                'nome-abrev   ' ped-item.nome-abrev     SKIP
                'nr-sequencia ' ped-item.nr-sequencia   SKIP
                'it-codigo    ' ped-item.it-codigo      SKIP
                 VIEW-AS ALERT-BOX INFO BUTTONS OK.
        */
        FOR FIRST estabelec NO-LOCK 
            WHERE estabelec.cod-estabel = ped-venda.cod-estabel:
            ASSIGN c-grupo-aloca = estabelec.grupo-aloca.
        END.
    
        FOR EACH  estabelec      
            WHERE estabelec.grupo-aloc   = c-grupo-aloca:
            ASSIGN vQtAloca = (ped-ent.qt-pedida - ped-ent.qt-atendida).
            /*
            IF c-seg-usuario = "ADM" THEN
            MESSAGE "Quatidade a alocar " vQtAloca
                VIEW-AS ALERT-BOX INFO BUTTONS OK.*/
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
                            saldo-estoq.qt-aloc-prod)) >= vQtAloca NO-ERROR.

                IF  NOT AVAIL saldo-estoq THEN
                DO:

                    ASSIGN c_cod_estab_usuar = saldo-estoq.cod-estabel.
                    /*IF c-seg-usuario = "ADM" THEN
                    MESSAGE 'Transferindo Material'
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.*/
                    RUN piTransfereMaterial. 
                END.
                ELSE DO:
                    /*
                    IF c-seg-usuario = "ADM" THEN
                    MESSAGE 'Saldo no EXP' (saldo-estoq.qtidade-atu - 
                           (saldo-estoq.qt-alocada  + 
                            saldo-estoq.qt-aloc-ped +  
                            saldo-estoq.qt-aloc-prod))
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.*/
                    ASSIGN vQtAloca = 0.
                END.
    
                IF NOT CAN-FIND(tt-erro) THEN
                     ASSIGN vQtAloca = vQtAloca - vQtTransferida.
                ELSE ASSIGN vQtAloca = 0.
            END.
        END.

/*
        FOR FIRST estabelec NO-LOCK 
            WHERE estabelec.cod-estabel = ped-venda.cod-estabel:
            ASSIGN c-grupo-aloca = estabelec.grupo-aloca.
        END.

        FOR EACH  estabelec      
            WHERE estabelec.grupo-aloc   = c-grupo-aloca:
            FOR FIRST saldo-estoq NO-LOCK 
                WHERE saldo-estoq.cod-estabel = estabelec.cod-estabel
                AND   saldo-estoq.it-codigo   = ped-ent.it-codigo
                AND   saldo-estoq.cod-refer   = ped-ent.cod-refer
                AND   saldo-estoq.cod-depos   = "EXP"
                AND   saldo-estoq.cod-localiz = ""
                AND  (saldo-estoq.qtidade-atu - 
                            (saldo-estoq.qt-alocada  + 
                             saldo-estoq.qt-aloc-ped +  
                             saldo-estoq.qt-aloc-prod)) < (ped-ent.qt-pedida - ped-ent.qt-atendida),
                FIRST deposito NO-LOCK
                WHERE deposito.cod-depos      = saldo-estoq.cod-depos
                AND   deposito.ind-acabado.
                MESSAGE 'Item sem saldo em estoque no Deposito EXP localiz BRANCO ' 
                         VIEW-AS ALERT-BOX INFO BUTTONS OK.
                RUN piTransfereMaterial.
            END.
        END.
        */
    END.
    FOR EACH tt-erro. DELETE tt-erro. END.
    FOR EACH tt-AtuErro.
        CREATE tt-Erro.
        BUFFER-COPY tt-AtuErro TO tt-Erro.
    END.

    SESSION:SET-WAIT-STATE("":U).
    /*
    IF c-seg-usuario = "ADM" THEN
    MESSAGE "ENCONTROU ERRO" can-find(first tt-erro)
        VIEW-AS ALERT-BOX INFO BUTTONS OK.*/
    if  can-find(first tt-erro) then
        run cdp/cd0666.w (input table tt-erro).
    /*
    IF cReturn = "NOK" THEN
    DO:
       if can-find(first tt-erro) then
          run cdp/cd0666.w (input table tt-erro).
       RETURN "NOK".
    END.
    */
END.

{upc/pd4000k-upce.i}

PROCEDURE piMessage:
    MESSAGE 'eq0506B' SKIP
            'p-ind-event  ' p-ind-event  SKIP
            'p-ind-object ' p-ind-object SKIP
            'p-cod-table  ' p-cod-table  SKIP
            'p-row-table  ' string(p-row-table) SKIP
             c-objeto
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
END PROCEDURE.
