DEFINE VARIABLE L-CONFIRMA AS LOGICAL     NO-UNDO.
DEF TEMP-TABLE tt-web-ped-status NO-UNDO
    FIELD nr-pedido     LIKE ped-venda.nr-pedido
    FIELD aprovador     AS CHAR FORMAT "x(08)"
    FIELD it-codigo     LIKE ped-item.it-codigo
    FIELD cod-refer     LIKE ped-item.cod-refer
    FIELD nr-sequencia  LIKE ped-item.nr-sequencia
    FIELD log-aprovado  AS LOGICAL
    FIELD log-reprovado AS LOGICAL
    FIELD motivo-aprov  AS CHAR FORMAT "x(2000)".
DEF TEMP-TABLE tt-web-ped NO-UNDO
    FIELD nome-repres   LIKE repres.nome
    FIELD nome-emit     LIKE emitente.nome-emit
    FIELD nome-abrev    LIKE ped-venda.nome-abrev
    FIELD nr-pedcli     LIKE ped-venda.nr-pedcli
    FIELD it-codigo     LIKE ped-item.it-codigo
    FIELD cod-refer     LIKE ped-item.cod-refer
    FIELD nr-sequencia  LIKE ped-item.nr-sequencia
    FIELD desc-item     LIKE ITEM.DESC-item
    FIELD qt-pedida     LIKE ped-item.qt-pedida
    FIELD preco-inf     LIKE ped-item.vl-preuni
    FIELD preco-min-tab LIKE ped-item.vl-preuni
    FIELD aprovador     AS CHAR FORMAT "x(08)".

DEF TEMP-TABLE tt-erro
    FIELD codigo AS INTEGER
    FIELD descricao AS CHAR FORMAT "x(100)".

DEFINE VARIABLE c-pedido AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-aprovador AS CHARACTER FORMAT "X(20)"  NO-UNDO.
DEFINE VARIABLE c-senha AS CHARACTER FORMAT "X(20)"  NO-UNDO.
DEFINE VARIABLE c-motivo  AS CHARACTER FORMAT "X(50)"   NO-UNDO.
REPEAT:
    UPDATE c-pedido LABEL "Pedido " SKIP
           c-cod-aprovador LABEL "Aprovador" SKIP
           c-senha         LABEL "Senha" SKIP
           c-motivo        LABEL "Motivo"
        WITH SIDE-LABELS 1 COLUMN.
    RUN esp/pdp/espdp072.p (INPUT c-pedido,
                            INPUT c-cod-aprovador,
                            OUTPUT TABLE tt-web-ped,
                            OUTPUT TABLE tt-erro).
    FOR EACH tt-web-ped-status:
        DELETE tt-web-ped-status.
    END.

    FOR EACH  tt-web-ped NO-LOCK:
        DISP tt-web-ped.nr-pedcli     
             it-codigo     
             qt-pedida     
             preco-inf     
             preco-min-tab 
                 nome-emit     
            
            
            WITH WIDTH 500 64 DOWN FRAME f-lista.

        FIND ped-venda
            WHERE ped-venda.nr-pedcli  = tt-web-ped.nr-pedcli 
              AND ped-venda.nome-abrev = tt-web-ped.nome-abrev NO-LOCK NO-ERROR.
        CREATE tt-web-ped-status.
        ASSIGN tt-web-ped-status.nr-pedido = ped-venda.nr-pedido
               tt-web-ped-status.aprovador = c-cod-aprovador
               tt-web-ped-status.it-codigo = tt-web-ped.it-codigo
               tt-web-ped-status.cod-refer = tt-web-ped.cod-refer
               tt-web-ped-status.nr-sequencia = tt-web-ped.nr-sequencia
               tt-web-ped-status.log-aprovado = YES.
               tt-web-ped-status.motivo-aprov = c-motivo.
    END.

    PAUSE.
    MESSAGE "Confirma Aprovacao " 
        VIEW-AS ALERT-BOX QUESTION BUTTONS  YES-NO-CANCEL UPDATE l-confirma.

    IF l-confirma = YES THEN DO:
        RUN esp/pdp/espdp073.p (INPUT c-pedido,
                        INPUT c-cod-aprovador,
                        INPUT c-senha,
                        INPUT TABLE tt-web-ped-status,
                        OUTPUT TABLE tt-erro).
        IF CAN-FIND(FIRST tt-erro) THEN
            FOR EACH tt-erro:
                MESSAGE tt-erro.descricao
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.
         ELSE
             MESSAGE "APROVACAO OCORREU COM SUCESSO"
                 VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    ELSE 
        MESSAGE "APROVACAO DESCARTADA"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        
           
END.
