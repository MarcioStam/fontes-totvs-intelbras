DEF INPUT PARAMETER p-nr-pedido AS INT NO-UNDO.

define temp-table RowErrors no-undo
   field ErrorSequence    as integer
   field ErrorNumber      as integer
   field ErrorDescription as character format "x(150)"
   field ErrorParameters  as character
   field ErrorType        as character
   field ErrorHelp        as character format "x(150)"
   field ErrorSubtype     as character.

DEF VAR d-fator      AS DECIMAL NO-UNDO.
DEF VAR de-vl-frete  AS DECIMAL NO-UNDO.
DEF VAR d-totalItens AS DEC     NO-UNDO.
DEF VAR de-vl-preco  AS DECIMAL NO-UNDO.
DEF VAR d-aliq-ipi   AS DECIMAL NO-UNDO.
DEF VAR d-vl-frete-com-impto AS DEC NO-UNDO.

DO TRANS:

    FIND FIRST ped-venda
         WHERE ped-venda.nr-pedido = p-nr-pedido NO-LOCK NO-ERROR.
    IF NOT AVAIL ped-venda THEN NEXT.    

    FIND CURRENT ped-venda EXCLUSIVE-LOCK NO-ERROR.
    ASSIGN ped-venda.dsp-pre-fat  = YES
           ped-venda.cod-sit-aval = 3
           ped-venda.completo = NO.
    FIND CURRENT ped-venda NO-LOCK NO-ERROR.

    /* COMPLETA O PEDIDO PARA CALCULAR O VALOR DOS IMPOSTOS */
    IF ped-venda.completo = NO THEN
        RUN pi-completa-pedido.

    ASSIGN d-vl-frete-com-impto = ped-venda.vl-tot-ped.

    /* GRAVA O VALOR DO FRETE NA VARIAVEL E ZERO O VALOR NA TABELA */
    FIND FIRST int-ped-venda EXCLUSIVE-LOCK
         WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
    IF  AVAILABLE (int-ped-venda) THEN DO:
        ASSIGN de-vl-frete = int-ped-venda.vl-frete.
        ASSIGN int-ped-venda.vl-frete = 0
               int-ped-venda.ValorFrete = 0.
    END.

    FIND CURRENT ped-venda EXCLUSIVE-LOCK NO-ERROR.
    ASSIGN ped-venda.dsp-pre-fat  = YES
           ped-venda.cod-sit-aval = 3
           ped-venda.completo = NO.
    FIND CURRENT ped-venda NO-LOCK NO-ERROR.

    /* COMPLETA O PEDIDO PARA CALCULAR O VALOR DOS IMPOSTOS */
    IF ped-venda.completo = NO THEN
        RUN pi-completa-pedido.

    ASSIGN d-vl-frete-com-impto = d-vl-frete-com-impto - ped-venda.vl-tot-ped.

    FOR EACH ped-item OF ped-venda NO-LOCK:
        /* CALCULA O FATOR PARA SER MULTIPLICADO PELO VALOR ORIGINAL DO ITEM GERANDO O VALOR DO ITEM SEM IMPOSTOS */
        ASSIGN d-fator = ped-item.vl-preori * ped-item.vl-preori / (ped-item.vl-tot-it / ped-item.qt-pedida) / ped-item.vl-preori.
        ASSIGN de-vl-preco = ped-item.vl-preori * d-fator.

        FIND FIRST ITEM
            WHERE ITEM.it-codigo = ped-item.it-codigo NO-LOCK NO-ERROR.
        
        IF AVAIL ITEM
            AND item.cod-servico <> 0 THEN DO:
            
            IF TRUNC(de-vl-preco,2) <> de-vl-preco THEN
                ASSIGN de-vl-preco = TRUNC(de-vl-preco,2) + 0.01.
            
            FIND CURRENT ped-item EXCLUSIVE-LOCK NO-ERROR.
            ASSIGN ped-item.vl-pretab   = de-vl-preco
                   ped-item.vl-preori   = de-vl-preco
                   ped-item.vl-preuni   = de-vl-preco
                   ped-item.vl-preori-un-fat = de-vl-preco.
            FIND CURRENT ped-item NO-LOCK NO-ERROR.
            RELEASE ped-item.
        END.
        ELSE
            IF TRUNC(de-vl-preco,3) <> de-vl-preco THEN          
                ASSIGN de-vl-preco = TRUNC(de-vl-preco,3) + 0.001.
                                                                 
            FIND CURRENT ped-item EXCLUSIVE-LOCK NO-ERROR.       
            ASSIGN ped-item.vl-pretab   = de-vl-preco            
                   ped-item.vl-preori   = de-vl-preco            
                   ped-item.vl-preuni   = de-vl-preco            
                   ped-item.vl-preori-un-fat = de-vl-preco.      
            FIND CURRENT ped-item NO-LOCK NO-ERROR.              
            RELEASE ped-item.                                    
    END.

    /* GRAVA O VALOR DO FRETE NA TABELA */
    FIND FIRST int-ped-venda EXCLUSIVE-LOCK
         WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
    IF  AVAILABLE (int-ped-venda) THEN DO:
        ASSIGN int-ped-venda.vl-frete = de-vl-frete.
        ASSIGN int-ped-venda.ValorFrete = de-vl-frete / d-vl-frete-com-impto * de-vl-frete.

        IF int-ped-venda.ValorFrete = ? OR int-ped-venda.ValorFrete < 0 THEN
            ASSIGN int-ped-venda.ValorFrete = int-ped-venda.vl-frete.
    END.
END.

FIND CURRENT ped-venda EXCLUSIVE-LOCK NO-ERROR.
ASSIGN ped-venda.dsp-pre-fat  = YES
       ped-venda.cod-sit-aval = 3
       ped-venda.completo = NO.
FIND CURRENT ped-venda NO-LOCK NO-ERROR.

/* COMPLETA NOVAMENTE O PEDIDO PARA CALCULAR O VALOR DOS IMPOSTOS */
IF ped-venda.completo = NO THEN
    RUN pi-completa-pedido.
    
PROCEDURE pi-completa-pedido:

    DEFINE VARIABLE h-bodi159cal      AS HANDLE      NO-UNDO.
    DEFINE VARIABLE l-erro            AS LOGICAL     NO-UNDO.

    /************************/
    /* COMPLETANDO O PEDIDO */
    /************************/
    EMPTY TEMP-TABLE RowErrors.
    RUN dibo/bodi159com.p PERSISTENT SET h-bodi159cal.
    RUN completeOrder in h-bodi159cal (INPUT ROWID(ped-venda), OUTPUT TABLE RowErrors).
  
    FOR EACH RowErrors NO-LOCK
       WHERE RowErrors.ErrorNumber <> 8259 /** cr‚dito nÆo aprovado **/
         AND RowErrors.ErrorSubType = 'Error':
       RUN incluiMsgErro IN THIS-PROCEDURE ("Pedido", STRING(RowErrors.errorNumber), RowErrors.ERRORDescription + " - " + RowErrors.ErrorHelp).
       ASSIGN l-erro = YES.
    END.
     
    IF  VALID-HANDLE(h-bodi159cal) AND h-bodi159cal:file-name = 'dibo/bodi159com.p' AND h-bodi159cal:type = 'procedure' THEN
        RUN destroyBO IN  h-bodi159cal.
    IF  VALID-HANDLE(h-bodi159cal) THEN DO:
        DELETE PROCEDURE h-bodi159cal.
        ASSIGN h-bodi159cal = ?.
    END.

END PROCEDURE.

