/*********************************************************************************
** ESPDP012 - Busca descontos do pci para  pedido
************************************************************************************/      
      
      EMPTY TEMP-TABLE tt-int-ped-item-pci. 
      
      FIND FIRST mgesp.int-ped-item-pci
           WHERE int-ped-item-pci.nome-abrev   = ped-venda.nome-abrev 
             AND int-ped-item-pci.nr-pedcli    = ped-venda.nr-pedcli
             AND int-ped-item-pci.it-codigo    = ped-item.it-codigo 
             AND int-ped-item-pci.nr-sequencia = ped-item.nr-sequencia NO-LOCK NO-ERROR.
      IF AVAIL int-ped-item-pci THEN DO:
        CREATE tt-int-ped-item-pci.
        RAW-TRANSFER int-ped-item-pci TO tt-int-ped-item-pci.
      END.
      RELEASE mgesp.int-ped-item-pci . 
      
      FIND FIRST tt-int-ped-item-pci
           WHERE tt-int-ped-item-pci.nome-abrev   = ped-venda.nome-abrev 
             AND tt-int-ped-item-pci.nr-pedcli    = ped-venda.nr-pedcli
             AND tt-int-ped-item-pci.it-codigo    = ped-item.it-codigo 
             AND tt-int-ped-item-pci.nr-sequencia = ped-item.nr-sequencia  NO-ERROR.
      IF AVAIL tt-int-ped-item-pci THEN DO:
         FIND FIRST tt-pedidosItens
             WHERE tt-pedidosItens.nome-abrev    = ped-item.nome-abrev  
               AND tt-pedidosItens.nr-pedcli     = ped-item.nr-pedcli   
               AND tt-pedidosItens.nr-sequencia  = ped-item.nr-sequencia
               AND tt-pedidosItens.it-codigo     = ped-item.it-codigo   
               AND tt-pedidosItens.cod-refer     = ped-item.cod-refer   EXCLUSIVE-LOCK NO-ERROR.
         IF NOT AVAIL tt-pedidosItens THEN DO:
            CREATE tt-pedidosItens.
            ASSIGN tt-pedidosItens.nome-abrev    = ped-item.nome-abrev  
                   tt-pedidosItens.nr-pedcli     = ped-item.nr-pedcli   
                   tt-pedidosItens.nr-sequencia  = ped-item.nr-sequencia
                   tt-pedidosItens.it-codigo     = ped-item.it-codigo   
                   tt-pedidosItens.cod-refer     = ped-item.cod-refer   
                   tt-pedidosItens.vl-preoriOld  = ped-item.vl-preori.  
         END.
         
         ASSIGN ped-item.des-pct-desconto-inform = ''.
      
        IF ped-item.des-pct-desconto-inform <> '' AND 
           tt-int-ped-item-pci.desc-kit > 0 THEN 
           ASSIGN ped-item.des-pct-desconto-inform = ped-item.des-pct-desconto-inform + '+'.
        IF dec(tt-int-ped-item-pci.desc-kit) > 0 THEN
           ASSIGN ped-item.des-pct-desconto-inform  = ped-item.des-pct-desconto-inform + string(tt-int-ped-item-pci.desc-kit).

        
        IF ped-item.des-pct-desconto-inform <> '' AND 
           tt-int-ped-item-pci.desc-comerical > 0 THEN 
           ASSIGN ped-item.des-pct-desconto-inform = ped-item.des-pct-desconto-inform + '+'.
        IF tt-int-ped-item-pci.desc-comerical > 0 THEN 
           ASSIGN ped-item.des-pct-desconto-inform = ped-item.des-pct-desconto-inform + STRING(tt-int-ped-item-pci.desc-comerical).
          
        IF ped-item.des-pct-desconto-inform <> '' AND 
           de-desco-qt > 0 THEN 
           ASSIGN ped-item.des-pct-desconto-inform = ped-item.des-pct-desconto-inform + '+'.
        IF de-desco-qt > 0 THEN 
           ASSIGN ped-item.des-pct-desconto-inform = ped-item.des-pct-desconto-inform +  STRING(de-desco-qt).

        // Zera descontos do pci

        ASSIGN tt-int-ped-item-pci.desc-topmilhao = 0
               tt-int-ped-item-pci.desc-maisverde = 0 
               tt-int-ped-item-pci.desc-focounid  = 0
               tt-int-ped-item-pci.desc-distrib20 = 0
               tt-int-ped-item-pci.desc-widecloud = 0.

        // Aplica»’o dos descontos do PCI 

        FIND FIRST int-emitente-canal 
             WHERE int-emitente-canal.cod-emitente = ped-venda.cod-emitente
                   NO-LOCK NO-ERROR.

        IF AVAIL int-emitente-canal THEN
           FIND FIRST emitente 
                WHERE emitente.cod-emitente = int-emitente-canal.cod-emitente-matriz NO-LOCK NO-ERROR.

        IF NOT AVAIL emitente THEN
           FIND FIRST emitente 
                WHERE emitente.cod-emitente = ped-venda.cod-emitente NO-LOCK NO-ERROR. 

        IF AVAIL emitente THEN DO:
            FOR EACH int-beneficio-conta NO-LOCK
               WHERE int-beneficio-conta.cod-emitente      = emitente.cod-emitente
                 AND int-beneficio-conta.log-ativo         = YES
                 AND int-beneficio-conta.log-bloq-infracao = NO:
    
               FIND FIRST ITEM
                    WHERE ITEM.it-codigo = ped-item.it-codigo NO-LOCK NO-ERROR.
    
               IF int-beneficio-conta.segmento-produto = SUBSTR(ITEM.fm-cod-com,1,4) AND 
                  int-beneficio-conta.familia-produto  = SUBSTR(item.fm-cod-com,1,5) THEN
                  RUN pi-desconto.
    
               IF int-beneficio-conta.segmento-produto = SUBSTR(ITEM.fm-cod-com,1,4) AND 
                  int-beneficio-conta.familia-produto  = '' THEN
                  RUN pi-desconto.
    
               IF int-beneficio-conta.segmento-produto = '' AND 
                  int-beneficio-conta.familia-produto  = '' THEN
                  RUN pi-desconto.
    
            END.
        END.

        IF ped-item.des-pct-desconto-inform <> '' AND 
           tt-int-ped-item-pci.desc-topmilhao > 0 THEN 
           ASSIGN ped-item.des-pct-desconto-inform = ped-item.des-pct-desconto-inform + '+'.
        IF dec(tt-int-ped-item-pci.desc-topmilhao) > 0 THEN
           ASSIGN ped-item.des-pct-desconto-inform  = ped-item.des-pct-desconto-inform + string(tt-int-ped-item-pci.desc-topmilhao).
        IF ped-item.des-pct-desconto-inform <> '' AND 
           tt-int-ped-item-pci.desc-maisverde > 0 THEN 
           ASSIGN ped-item.des-pct-desconto-inform = ped-item.des-pct-desconto-inform + '+'.
        IF dec(tt-int-ped-item-pci.desc-maisverde) > 0 THEN
           ASSIGN ped-item.des-pct-desconto-inform  = ped-item.des-pct-desconto-inform + string(tt-int-ped-item-pci.desc-maisverde).
        IF ped-item.des-pct-desconto-inform <> '' AND 
           tt-int-ped-item-pci.desc-focounid > 0 THEN 
           ASSIGN ped-item.des-pct-desconto-inform = ped-item.des-pct-desconto-inform + '+'.
        IF dec(tt-int-ped-item-pci.desc-focounid) > 0 THEN
           ASSIGN ped-item.des-pct-desconto-inform  = ped-item.des-pct-desconto-inform + string(tt-int-ped-item-pci.desc-focounid).
        IF ped-item.des-pct-desconto-inform <> '' AND 
           tt-int-ped-item-pci.desc-distrib > 0 THEN 
           ASSIGN ped-item.des-pct-desconto-inform = ped-item.des-pct-desconto-inform + '+'.
        IF dec(tt-int-ped-item-pci.desc-distrib) > 0 THEN
           ASSIGN ped-item.des-pct-desconto-inform   = ped-item.des-pct-desconto-inform + string(tt-int-ped-item-pci.desc-distrib20).
        IF ped-item.des-pct-desconto-inform <> '' AND 
           tt-int-ped-item-pci.desc-widecloud > 0 THEN 
           ASSIGN ped-item.des-pct-desconto-inform = ped-item.des-pct-desconto-inform + '+'.
        IF dec(tt-int-ped-item-pci.desc-widecloud) > 0 THEN
           ASSIGN ped-item.des-pct-desconto-inform  = ped-item.des-pct-desconto-inform + string(tt-int-ped-item-pci.desc-widecloud).
        IF tt-int-ped-item-pci.desc-neg-comercial > 0 THEN DO:
           IF ped-item.des-pct-desconto-inform = '' THEN DO:
              ASSIGN ped-item.des-pct-desconto-inform  = string(tt-int-ped-item-pci.desc-neg-comercial) .
           END.
           ELSE DO:
               ASSIGN ped-item.des-pct-desconto-inform  = ped-item.des-pct-desconto-inform + '+' +  string(tt-int-ped-item-pci.desc-neg-comercial) .
           END.
        END.
      
          ASSIGN de-perc-desc = 0.
          if  not valid-handle(h-bodi159cal)
              or  h-bodi159cal:type      <> "PROCEDURE":U
              or  h-bodi159cal:file-name <> "dibo/bodi159cal.p":U then
              run dibo/bodi159cal.p persistent set h-bodi159cal.
    
             
          run calculateTextDiscount in h-bodi159cal(input ped-item.des-pct-desconto-inform,
                                                    output de-perc-desc).

          
         IF de-perc-desc >= 0 THEN
             ASSIGN ped-item.per-des-it = de-perc-desc.
                    ped-item.vl-preuni = ped-item.vl-preuni * (1 - (ped-item.per-des-item / 100)).
      END.



    FIND FIRST mgesp.int-ped-item-pci
           WHERE int-ped-item-pci.nome-abrev   = ped-venda.nome-abrev 
             AND int-ped-item-pci.nr-pedcli    = ped-venda.nr-pedcli
             AND int-ped-item-pci.it-codigo    = ped-item.it-codigo 
             AND int-ped-item-pci.nr-sequencia = ped-item.nr-sequencia EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL int-ped-item-pci THEN DO:
         ASSIGN int-ped-item-pci.desc-topmilhao  = tt-int-ped-item-pci.desc-topmilhao.
         ASSIGN int-ped-item-pci.desc-maisverde  = tt-int-ped-item-pci.desc-maisverde. 
         ASSIGN int-ped-item-pci.desc-focounid   = tt-int-ped-item-pci.desc-focounid . 
         ASSIGN int-ped-item-pci.desc-distrib    = tt-int-ped-item-pci.desc-distrib  . 
         ASSIGN int-ped-item-pci.desc-widecloud  = tt-int-ped-item-pci.desc-widecloud. 
    END.

    RELEASE mgesp.int-ped-item-pci .
    

