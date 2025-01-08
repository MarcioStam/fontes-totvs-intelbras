DEFINE INPUT PARAM r-item         AS ROWID.                        
DEFINE INPUT PARAM p-cod-estabel  AS CHAR.                       
DEFINE INPUT PARAM p-cod-plano    AS INT.                      
DEFINE INPUT PARAM p-item-inicial AS CHAR.                      

DEFINE VARIABLE l-nacional             AS LOGICAL     NO-UNDO.
DEFINE VARIABLE i-prox-seq             AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-criticidade-anterior AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-criticidade          AS CHARACTER FORMAT "x(18)" EXTENT 7    NO-UNDO.

ASSIGN c-criticidade[1] = "Roxo"
       c-criticidade[2] = "Vermelho"
       c-criticidade[3] = "Amarelo"
       c-criticidade[4] = "Verde"
       c-criticidade[5] = "Azul"
       c-criticidade[6] = "Cinza"
       c-criticidade[7] = "Laranja".

{esp/cep/escep082rp.i}

DEFINE BUFFER b1-tt-estoq FOR tt-estoq.
DEFINE BUFFER b-int-acao-criticidade-item FOR int-acao-criticidade-item.

DEFINE TEMP-TABLE tt-int-param-calc-crit LIKE int-param-calc-crit
    FIELD l-selected AS LOGICAL FORMAT "*/".

FUNCTION fnSaldoCriticidade RETURNS LOGICAL
    ( INPUT p-crit  AS INT,
      INPUT p-saldo AS DEC  ) FORWARD.
                                                      
FIND FIRST ITEM NO-LOCK
     WHERE ROWID(ITEM) = r-item NO-ERROR.

/*Busca a parametrizaá∆o do escep081 para a simulaá∆o de estoque*/
FIND FIRST int-param-calc-crit NO-LOCK
     WHERE int-param-calc-crit.cod-estabel  = p-cod-estabel
       AND int-param-calc-crit.cd-plano     = p-cod-plano
       AND int-param-calc-crit.item-inicial = p-item-inicial  NO-ERROR.

ASSIGN c-cod-estabel                      = p-cod-estabel
       i-cod-plano                        = p-cod-plano
       l-oem                              = int-param-calc-crit.l-oem
       l-cons-reservas-comprometidas      = int-param-calc-crit.l-cons-reservas-comprometidas     
       l-cons-pedidos-carteira            = int-param-calc-crit.l-cons-pedidos-carteira           
       l-considera-saldo-estoque          = int-param-calc-crit.l-cons-saldo-estoque         
       l-considera-remessa-beneficiamento = int-param-calc-crit.l-cons-remessa-beneficiamento
       l-considera-entrada-beneficiamento = int-param-calc-crit.l-cons-entrada-beneficiamento
       l-considera-transferencia          = int-param-calc-crit.l-cons-transferencia         
       l-considera-remessa-consignacao    = int-param-calc-crit.l-cons-remessa-consignacao   
       l-considera-entrada-consignacao    = int-param-calc-crit.l-cons-entrada-consignacao   
       l-considera-saldo-terceiros        = int-param-calc-crit.l-cons-saldo-terceiros       
       l-considera-ordens-producao        = int-param-calc-crit.l-cons-ordens-producao       
       l-ordens-compra-beneficiamento     = int-param-calc-crit.l-ordens-compra-beneficiamento    
       l-apenas-pedidos-credito-aprovado  = int-param-calc-crit.l-apenas-pedidos-cred-aprovado 
       l-considera-ordens-planejadas      = int-param-calc-crit.l-cons-ordens-planejadas     
       l-considera-reservas-planejadas    = int-param-calc-crit.l-cons-reservas-planejadas.   

/*Busca £ltimo c†lculo do dia*/
FIND LAST int-criticidade-item NO-LOCK
    WHERE int-criticidade-item.cod-estabel  = int-param-calc-crit.cod-estabel
      AND int-criticidade-item.cd-plano     = int-param-calc-crit.cd-plano   
      AND int-criticidade-item.it-codigo    = ITEM.it-codigo
      AND int-criticidade-item.data-calculo = TODAY NO-ERROR.

IF AVAIL int-criticidade-item THEN DO:
    ASSIGN i-prox-seq             = int-criticidade-item.sequencia + 1
           i-criticidade-anterior = int-criticidade-item.nivel-criticidade.
END.
ELSE DO:
    ASSIGN i-prox-seq             = 1
           i-criticidade-anterior = ?.
END.

FIND FIRST item-uni-estab NO-LOCK
     WHERE item-uni-estab.cod-estabel = int-param-calc-crit.cod-estabel 
       AND item-uni-estab.it-codigo   = ITEM.it-codigo NO-ERROR.

IF NOT AVAIL item-uni-estab THEN
    NEXT.

/*Executa simulaá∆o de estoque*/
RUN pi-calc-sim-estoque (INPUT ROWID(ITEM)).

IF CAN-FIND (FIRST tt-estoq) THEN DO:
    /*Calcula criticidade de acordo com a tt-estoq gerada na simulaá∆o*/
    RUN pi-calculo-criticidade.
END.  

PROCEDURE pi-calc-sim-estoque :
    DEF INPUT  PARAMETER r-item               AS ROWID   NO-UNDO.

    DEF VAR i-nr-linha-ini AS INT NO-UNDO.
    DEF VAR i-nr-linha-fim AS INT NO-UNDO.
    DEF VAR c-plan-ini     LIKE ITEM.cd-planejado NO-UNDO.
    DEF VAR c-plan-fim     LIKE ITEM.cd-planejado NO-UNDO.

    DEFINE BUFFER b-item FOR ITEM.
    
    FIND FIRST param-global NO-LOCK NO-ERROR.
    
    FIND FIRST ITEM NO-LOCK
         WHERE ROWID(ITEM) = r-item NO-ERROR.
    
    FIND FIRST b-item NO-LOCK
        WHERE ROWID(b-item) = r-item NO-ERROR.
    
    ASSIGN c-cod-refer  = ITEM.cod-refer
           l-apenas-oem = l-oem
           da-dt-corte  = TODAY + item-uni-estab.res-for-comp /*leadtime*/
           l-ord-comp   = YES /*Chamado 70660 considerar ordens de compra para todos os itens Nacional e Importado*/
           l-res-comp   = l-cons-reservas-comprometidas
           l-pedidos    = l-cons-pedidos-carteira
           da-dt-plan   = 12/31/9999.
    
        
    FOR EACH tt-estoq:
        DELETE tt-estoq.
    END.

    RUN pi-simulacao-estoque(BUFFER b-item,
                             INPUT l-considera-saldo-estoque,
                             INPUT l-considera-remessa-beneficiamento,
                             INPUT l-considera-entrada-beneficiamento,
                             INPUT l-considera-transferencia,
                             INPUT l-considera-remessa-consignacao,
                             INPUT l-considera-entrada-consignacao,
                             INPUT "", /**/
                             INPUT "", /**/
                             INPUT 0,  /**/
                             INPUT 0,  /**/
                             INPUT l-considera-saldo-terceiros,
                             INPUT c-cod-estabel,
                             INPUT c-cod-estabel,
                             INPUT l-considera-ordens-producao,
                             INPUT l-ordens-compra-beneficiamento,
                             INPUT l-apenas-pedidos-credito-aprovado,
                             INPUT l-considera-ordens-planejadas,
                             INPUT l-considera-reservas-planejadas,
                             INPUT i-cod-plano,
                             INPUT "",   /*Unidade de Neg¢cio Inicial*/
                             INPUT "zzz" /*Unidade de Neg¢cio Final*/ ).
    
    /*Calcula saldo inicial*/
    IF  param-global.modulo-per-ppm 
    AND AVAIL ITEM AND ITEM.tipo-formula >= 2 
    AND ITEM.tipo-formula <= 3 THEN
        ASSIGN de-saldo = de-saldo-inic-teor.
    ELSE
        ASSIGN de-saldo = de-saldo-inic.
    
END PROCEDURE.

PROCEDURE pi-calculo-criticidade:

    DEFINE VARIABLE r-prazo-compra         AS ROWID       NO-UNDO.
    DEFINE VARIABLE r-historico-embarque   AS ROWID       NO-UNDO.
    DEFINE VARIABLE l-tem-entrega-prevista AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE d-dt-prox-ent          AS DATE        NO-UNDO.
    
    /*Posiciona novamente, a pi de simulaá∆o desposiciona*/
    FIND FIRST item-uni-estab NO-LOCK
         WHERE item-uni-estab.cod-estabel = int-param-calc-crit.cod-estabel 
           AND item-uni-estab.it-codigo   = ITEM.it-codigo NO-ERROR.

    FIND FIRST int-item-uni-estab NO-LOCK 
         WHERE int-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel
           AND int-item-uni-estab.it-codigo   = item-uni-estab.it-codigo NO-ERROR.

    RUN pi-proxima-chegada (INPUT  ITEM.it-codigo,            
                            INPUT  item-uni-estab.res-for-comp,  
                            INPUT  item-uni-estab.tp-desp-padrao, 
                            INPUT  int-param-calc-crit.cod-estabel,
                            INPUT  p-cod-plano,
                            OUTPUT r-prazo-compra,         
                            OUTPUT r-historico-embarque,   
                            OUTPUT l-tem-entrega-prevista).

    FIND FIRST prazo-compra NO-LOCK
         WHERE ROWID(prazo-compra) = r-prazo-compra NO-ERROR.

    IF AVAIL prazo-compra THEN
        ASSIGN d-dt-prox-ent = prazo-compra.data-entrega.

    /*Cria tabela pai da criticidade*/
    CREATE int-criticidade-item.
    ASSIGN int-criticidade-item.cod-estabel           = int-param-calc-crit.cod-estabel
           int-criticidade-item.cd-plano              = int-param-calc-crit.cd-plano   
           int-criticidade-item.it-codigo             = ITEM.it-codigo                 
           int-criticidade-item.data-calculo          = TODAY 
           int-criticidade-item.sequencia             = i-prox-seq
           int-criticidade-item.numero-compra-chegada = IF AVAIL prazo-compra THEN prazo-compra.numero-ordem ELSE ?
           int-criticidade-item.parcela-chegada       = IF AVAIL prazo-compra THEN prazo-compra.parcela      ELSE ?.

    /*Totaliza o saldo*/
    FOR EACH tt-estoq
       BREAK BY tt-estoq.dt-termino: /*Data Prevista*/

        /*Movimentos que diminuem o saldo*/
        IF tt-estoq.tipo = c-liter[5] 
        OR tt-estoq.tipo = c-liter[6] 
        OR tt-estoq.tipo = c-liter[8] THEN DO:
            ASSIGN de-saldo      = de-saldo - tt-estoq.quantidade
                   de-quantidade = (tt-estoq.quantidade * (-1)).
        END.
        /*Movimentos que aumentam o saldo*/
        ELSE DO:
            ASSIGN de-saldo = de-saldo + IF tt-estoq.tipo = c-liter[2] THEN 0 ELSE tt-estoq.quantidade
                   de-quantidade = tt-estoq.quantidade.
        END.
    
        ASSIGN tt-estoq.saldo      = de-saldo
               tt-estoq.quantidade = de-quantidade.

        /*Cria tabela filho da criticidade com as quantidades das faltas/excessos*/
        IF  LAST-OF (tt-estoq.dt-termino) 
        AND (tt-estoq.saldo < item-uni-estab.quant-segur 
         OR tt-estoq.saldo  > IF AVAIL int-item-uni-estab THEN int-item-uni-estab.qtd-pol ELSE 0) THEN DO:
            CREATE int-falta-criticidade-item.
            ASSIGN int-falta-criticidade-item.cod-estabel      = int-param-calc-crit.cod-estabel
                   int-falta-criticidade-item.cd-plano         = int-param-calc-crit.cd-plano   
                   int-falta-criticidade-item.it-codigo        = int-criticidade-item.it-codigo                 
                   int-falta-criticidade-item.data-calculo     = int-criticidade-item.data-calculo 
                   int-falta-criticidade-item.sequencia        = int-criticidade-item.sequencia
                   int-falta-criticidade-item.data-falta       = tt-estoq.dt-termino
                   int-falta-criticidade-item.quantidade-falta = tt-estoq.saldo.
        END.
    END. /* FOR EACH tt-estoq */

    IF CAN-FIND (FIRST tt-estoq
                 WHERE tt-estoq.saldo < item-uni-estab.quant-segur
                   /*Fora do LeadTime do item, ou seja, n∆o d† mais tempo de comprar o item antes que o mesmo fique abaixo da quantidade de Seguranáa*/
                   AND tt-estoq.dt-termino < (TODAY + item-uni-estab.res-for-comp)
                   /*N∆o existe entrega embarcada dentro do per°odo de LeadTime*/
                   AND (d-dt-prox-ent = ? OR d-dt-prox-ent > (TODAY + item-uni-estab.res-for-comp))
                   /*N∆o existe entrega prevista dentro do per°odo de LeadTime*/
                   AND NOT l-tem-entrega-prevista) THEN DO:
        
        /*Roxo*/
        ASSIGN int-criticidade-item.nivel-criticidade = 0.
    END.
    /*Estoque do item negativo*/
    ELSE IF CAN-FIND (FIRST tt-estoq
                      WHERE tt-estoq.saldo < 0
                        /*Durante o per°odo de LeadTime*/
                        AND tt-estoq.dt-termino < (TODAY + item-uni-estab.res-for-comp)) THEN DO:

        /*Vermelho*/
        ASSIGN int-criticidade-item.nivel-criticidade = 1.
    END.
    /*Estoque do item 30% abaixo da quantidade de seguranáa*/
    ELSE IF CAN-FIND (FIRST tt-estoq
                      WHERE tt-estoq.saldo < ((item-uni-estab.quant-segur * 30) / 100)
                        /*Durante o per°odo de LeadTime*/
                        AND tt-estoq.dt-termino < (TODAY + item-uni-estab.res-for-comp)) THEN DO:

        /*Amarelo*/
        ASSIGN int-criticidade-item.nivel-criticidade = 6.
    END.
    /*Estoque do item abaixo da quantidade de seguranáa*/
    ELSE IF CAN-FIND (FIRST tt-estoq
                      WHERE tt-estoq.saldo < item-uni-estab.quant-segur
                        /*Durante o per°odo de LeadTime*/
                        AND tt-estoq.dt-termino < (TODAY + item-uni-estab.res-for-comp)) THEN DO:

        /*Amarelo*/
        ASSIGN int-criticidade-item.nivel-criticidade = 2.
    END.
    /*acima da quantidade politica*/
    ELSE IF  CAN-FIND (FIRST tt-estoq
                       WHERE tt-estoq.saldo > IF AVAIL int-item-uni-estab THEN int-item-uni-estab.qtd-pol ELSE 0) THEN DO:
        /*sem entregas previstas*/
        IF NOT l-tem-entrega-prevista THEN DO:
            /*Cinza*/
            ASSIGN int-criticidade-item.nivel-criticidade = 5. 
        END.
        /*possui entregas n∆o embarcadas ou n∆o possui entregas*/
        ELSE DO:    
            /*Azul*/
            ASSIGN int-criticidade-item.nivel-criticidade = 4. 
        END.
    END.
    ELSE DO:
        /*Verde*/
        ASSIGN int-criticidade-item.nivel-criticidade = 3. 
    END.

    /*Calcula data da primeira falta/excesso e quantidade da £ltima falta/excesso daquele status*/
    RUN pi-data-quantidade-status.

    /*Todo c†lculo registra uma aá∆o para o item*/
    RUN pi-cria-acao-criticidade.

    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-cria-acao-criticidade:

    FIND LAST b-int-acao-criticidade-item NO-LOCK
        WHERE b-int-acao-criticidade-item.cod-estabel  = int-criticidade-item.cod-estabel      
          AND b-int-acao-criticidade-item.cd-plano     = int-criticidade-item.cd-plano         
          AND b-int-acao-criticidade-item.it-codigo    = int-criticidade-item.it-codigo        
          AND b-int-acao-criticidade-item.data-calculo = int-criticidade-item.data-calculo     
          AND b-int-acao-criticidade-item.sequencia    = int-criticidade-item.sequencia NO-ERROR.

    FIND FIRST usuar_mestre NO-LOCK
         WHERE usuar_mestre.cod_usuar = c-seg-usuario NO-ERROR.

    CREATE int-acao-criticidade-item.
    ASSIGN int-acao-criticidade-item.cod-estabel     = int-criticidade-item.cod-estabel      
           int-acao-criticidade-item.cd-plano        = int-criticidade-item.cd-plano         
           int-acao-criticidade-item.it-codigo       = int-criticidade-item.it-codigo        
           int-acao-criticidade-item.data-calculo    = int-criticidade-item.data-calculo     
           int-acao-criticidade-item.sequencia       = int-criticidade-item.sequencia        
           int-acao-criticidade-item.sequencia-acao  = IF NOT AVAIL b-int-acao-criticidade-item THEN 1 ELSE b-int-acao-criticidade-item.sequencia-acao + 1
           int-acao-criticidade-item.autor-acao      = c-seg-usuario
           int-acao-criticidade-item.nome-autor-acao = IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE ""
           int-acao-criticidade-item.comentario-acao = "C†lculo Criticidade"
           int-acao-criticidade-item.data-acao       = TODAY
           int-acao-criticidade-item.hora-acao       = STRING(TIME, "HH:MM:SS")
           int-acao-criticidade-item.acao-sistema    = YES.

    IF  i-criticidade-anterior <> ?
    AND i-criticidade-anterior <> int-criticidade-item.nivel-criticidade THEN DO:
        CREATE int-acao-criticidade-item.
        ASSIGN int-acao-criticidade-item.cod-estabel     = int-criticidade-item.cod-estabel      
               int-acao-criticidade-item.cd-plano        = int-criticidade-item.cd-plano         
               int-acao-criticidade-item.it-codigo       = int-criticidade-item.it-codigo        
               int-acao-criticidade-item.data-calculo    = int-criticidade-item.data-calculo     
               int-acao-criticidade-item.sequencia       = int-criticidade-item.sequencia        
               int-acao-criticidade-item.sequencia-acao  = IF NOT AVAIL b-int-acao-criticidade-item THEN 2 ELSE b-int-acao-criticidade-item.sequencia-acao + 2
               int-acao-criticidade-item.autor-acao      = c-seg-usuario
               int-acao-criticidade-item.nome-autor-acao = IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE ""
               int-acao-criticidade-item.comentario-acao = "Criticidade alterada de " + c-criticidade[i-criticidade-anterior + 1] + " para " + c-criticidade[int-criticidade-item.nivel-criticidade + 1] + "."
               int-acao-criticidade-item.data-acao       = TODAY
               int-acao-criticidade-item.hora-acao       = STRING(TIME, "HH:MM:SS")
               int-acao-criticidade-item.acao-sistema    = YES.
    END.

    RETURN "OK".
END.

PROCEDURE pi-data-quantidade-status:
    DEFINE VARIABLE l-achou-primeira-falta AS LOGICAL     NO-UNDO.

    blk_dataQuantidadeStatus:
    FOR EACH tt-estoq
        BREAK BY tt-estoq.dt-termino:

        /*Encontra a primeira falta/excesso da criticidade calculada*/
        IF  NOT l-achou-primeira-falta
        AND fnSaldoCriticidade(int-criticidade-item.nivel-criticidade,tt-estoq.saldo) THEN DO:
            ASSIGN l-achou-primeira-falta = YES
                   int-criticidade-item.dt-primeira-falta = tt-estoq.dt-termino. /*Data da primeira falta da criticidade*/

            /*para as criticidades cinza e azul considera a primeira falta, n∆o a £ltima*/
            IF int-criticidade-item.nivel-criticidade = 4 
            OR int-criticidade-item.nivel-criticidade = 5 THEN DO:
                 ASSIGN int-criticidade-item.de-ultima-quantidade = tt-estoq.saldo.
                 LEAVE blk_dataQuantidadeStatus.
            END.
        END.
        
        /*Depois que encontrou a primeira falta/excesso procura a £ltima quantidade desta criticidade*/
        IF l-achou-primeira-falta THEN DO:

            /*Este saldo n∆o pertence a mesma criticidade calculada*/
            IF NOT fnSaldoCriticidade(int-criticidade-item.nivel-criticidade,tt-estoq.saldo) THEN
                LEAVE blk_dataQuantidadeStatus.

            ASSIGN int-criticidade-item.de-ultima-quantidade = tt-estoq.saldo. /*Èltima quantidade da criticidade*/
        END.
    END.

    RETURN "OK".
END.

FUNCTION fnSaldoCriticidade RETURNS LOGICAL
  ( INPUT p-crit  AS INT,
    INPUT p-saldo AS DEC  ) :
/*------------------------------------------------------------------------------
  Purpose:  Retornar se o saldo pertence a criticidade informada.
------------------------------------------------------------------------------*/
    /*Roxo,Amarelo*/
    IF p-crit = 0 
    OR p-crit = 2 THEN DO:
        IF p-saldo < item-uni-estab.quant-segur THEN DO:
            RETURN YES.
        END.
    END.
    /*Vermelho*/
    ELSE IF p-crit = 1 THEN DO:

        IF p-saldo < 0 THEN DO:
            RETURN YES.
        END.
    END.
    /*Cinza,Azul*/
    ELSE IF p-crit = 5 
         OR p-crit = 4 THEN DO:

        IF  p-saldo > IF AVAIL int-item-uni-estab THEN int-item-uni-estab.qtd-pol ELSE 0 THEN DO:
            RETURN YES.
        END.
    END.
    
    RETURN NO.
    

END FUNCTION.

/*pi-simulacao-estoque*/
{esp/ccp/esccp032.i20}

/*pi-proxima-chegada*/
{esp/cep/escep082a.i}


