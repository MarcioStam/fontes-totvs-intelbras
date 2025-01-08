/******************************************************************************
**
**  CQ0203A.I - Imprime os Roteiros de Inspeá∆o
**
*******************************************************************************/
{include/pi-edit.i}  

{fch/fchmat/fchmatroutings.i7 ttGenerateManualRoutingVO} 
{fch/fchmat/fchmatroutings.i8 ttProductionOrderVO} 

{esp/es0018.i}

DEFINE VARIABLE c-observacao AS CHARACTER FORMAT "X(15)" NO-UNDO.
define variable h-cqapi304fx as handle no-undo.
define variable h-cdapi024 as handle no-undo.
define variable c-deposito-cq as character no-undo.
define variable p-ficha-num as integer no-undo.
DEFINE VARIABLE c-item-fabric AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-fab-inf AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-acond AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-volume       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-tipo-pedido  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-localizacao1 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-localizacao2 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-localizacao3 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-localizacao4 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-localizacao5 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-pag-ini      AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-tipos        AS CHARACTER   NO-UNDO.

RUN esp/es0018p.p (INPUT "cc0300a", /* Nome do programa */
                   INPUT 1,          /* Ponto do programa */
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto).    


//ASSIGN c-tipos = "Amostra,Autom†tico,Comum,Homologaá∆o,Independente,Ressarcimento,Spot,Troca de Modal,Para Manaus,CKD Comum,CKD Amostra,Para Engesul,Para Automatiza,Back to back".

RUN esp/es0018p.p (INPUT "cc0300a", /* Nome do programa */
                   INPUT 1,          /* Ponto do programa */
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto).    

FOR EACH tt-prog-ponto:                                                  
    ASSIGN c-tipos = c-tipos + ENTRY(2,tt-prog-ponto.conteudo,';') + ','.
END.

DEF TEMP-TABLE RowErrors NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.


FORM ficha-cq.nr-ficha COLUMN-LABEL "Roteiro Inspeá∆o"  
     RowErrors.ErrorNumber COLUMN-LABEL "Erro" 
     RowErrors.ErrorDescription COLUMN-LABEL "mensagem" FORMAT "X(130)"
     WITH WIDTH 132 FRAME f-erros STREAM-IO.
DO TRANS:
/* Nao Imprime CKD */    
    
for each ficha-cq use-index {1}
    where ficha-cq.nr-ficha     >= tt-param.i-ficha-ini
    and   ficha-cq.nr-ficha     <= tt-param.i-ficha-fim
    and   ficha-cq.cod-estabel  >= tt-param.c-estab-ini
    and   ficha-cq.cod-estabel  <= tt-param.c-estab-fim
    and   ficha-cq.cod-depos    >= tt-param.c-depos-ini
    and   ficha-cq.cod-depos    <= tt-param.c-depos-fim
    and   ficha-cq.it-codigo    >= tt-param.c-item-ini
    and   ficha-cq.it-codigo    <= tt-param.c-item-fim
    and   ficha-cq.cod-emitente >= tt-param.c-cod-emitente-ini
    and   ficha-cq.cod-emitente <= tt-param.c-cod-emitente-fim
    and   ficha-cq.cod-localiz  >= tt-param.c-local-ini
    and   ficha-cq.cod-localiz  <= tt-param.c-local-fim
    and   ficha-cq.lote         >= tt-param.c-lote-ini
    and   ficha-cq.lote         <= tt-param.c-lote-fim
    and   ficha-cq.serie-docto  >= tt-param.c-serie-ini
    and   ficha-cq.serie-docto  <= tt-param.c-serie-fim
    and   ficha-cq.nro-docto    >= tt-param.c-docto-ini
    and   ficha-cq.nro-docto    <= tt-param.c-docto-fim
    and   not ficha-cq.inspecionado
    and   (ficha-cq.estado = 1 or tt-param.l-ja-impresso = yes) exclusive-lock,
    FIRST ITEM NO-LOCK
    WHERE ITEM.it-codigo = ficha-cq.it-codigo,
    FIRST in-grup-estoq NO-LOCK
    WHERE in-grup-estoq.ge-codigo = ITEM.ge-codigo
      AND in-grup-estoq.log-ckd   = NO
 BREAK BY {2} {3}:
    
    /* Inicio -- Projeto Internacional */
    RUN utp/ut-trfrrp.p (INPUT FRAME f-erros:HANDLE).

    run pi-acompanhar in h-acomp (input ficha-cq.it-codigo).

    ASSIGN i-pag-ini = PAGE-NUMBER.

    IF ficha-cq.log-1 = YES THEN DO:
        RUN utp/ut-msgs.p (INPUT "help":U,
                           INPUT 51423,
                           INPUT ficha-cq.nr-ficha).
        DISP ficha-cq.nr-ficha
             51423 @ RowErrors.ErrorNumber
             RETURN-VALUE @ RowErrors.ErrorDescription
             WITH FRAME f-erros WIDTH 132 STREAM-IO. 
        NEXT.
    END.
    find docum-est
        where docum-est.serie-docto  = ficha-cq.serie-docto
        and   docum-est.nro-docto    = ficha-cq.nro-docto
        and   docum-est.cod-emitente = ficha-cq.cod-emitente
        and   docum-est.nat-operacao = ficha-cq.nat-operacao no-lock no-error.

    ASSIGN c-nat-operacao = ficha-cq.nat-operacao.
    find FIRST item-doc-est
         where item-doc-est.serie-docto  = ficha-cq.serie-docto
         and   item-doc-est.nro-docto    = ficha-cq.nro-docto
         and   item-doc-est.cod-emitente = ficha-cq.cod-emitente
         and   item-doc-est.nat-operacao = ficha-cq.nat-operacao 
         AND   item-doc-est.it-codigo    = ficha-cq.it-codigo 
         AND   item-doc-est.numero-ordem = ficha-cq.nr-ordem no-lock no-error.
    IF AVAIL item-doc-est THEN
       ASSIGN c-nat-operacao = item-doc-est.nat-of.

    find ordem-compra
        where ordem-compra.numero-ordem = ficha-cq.nr-ordem no-lock no-error.

    find emitente
        where ficha-cq.cod-emitente = emitente.cod-emitente no-lock no-error.

    find first estabelec
        where estabelec.cod-estabel = ficha-cq.cod-estabel  no-lock no-error.

    find first deposito
        where deposito.cod-depos = ficha-cq.cod-depos no-lock no-error.

    ASSIGN c-item-fabric = ""
           c-fab-inf     = ""
           c-acond       = ""
           c-awb         = "".

    /******************************************************************************************/
    //INI-Luciano Leonhardt
    ASSIGN cTextoSkipLote = "".
    FOR FIRST rat-lote FIELDS (int-1 char-1) NO-LOCK
        WHERE rat-lote.serie-docto  = ficha-cq.serie-docto
          AND rat-lote.nro-docto    = ficha-cq.nro-docto
          AND rat-lote.cod-emitente = ficha-cq.cod-emitente
          AND rat-lote.nat-operacao = ficha-cq.nat-operacao
          AND rat-lote.nr-ficha     = ficha-cq.nr-ficha:

        IF rat-lote.int-1 > 0 THEN
            ASSIGN cTextoSkipLote = "*** AQ Inspecionar ***".
        ELSE 
            ASSIGN cTextoSkipLote = "*** SKIP LOTE ***".
    END.
    //FIM-Luciano Leonhardt
    /******************************************************************************************/

    IF AVAIL docum-est AND docum-est.nat-operacao BEGINS "3" THEN DO:
       FIND FIRST embarque-imp
            WHERE embarque-imp.cod-estabel = docum-est.cod-estabel 
            AND   embarque-imp.embarque    = TRIM(SUBSTRING(docum-est.char-1,1,20)) NO-LOCK NO-ERROR.
       IF AVAIL embarque-imp THEN
          ASSIGN c-awb = TRIM(embarque-imp.cod-conhecto-maste).
    END.    

    find first item-fabric no-lock
         where item-fabric.it-codigo  = item.it-codigo 
           and item-fabric.cod-fabric = emitente.cod-emitente no-error.
    if avail item-fabric then do:
        assign c-item-fabric = item-fabric.it-fabric.
    end.
    else do:
        for each item-fabric no-lock  
           where item-fabric.it-codigo = item.it-codigo,
            each fabricante no-lock
           where fabricante.cod-fabric = item-fabric.cod-fabric:
             IF c-item-fabric = "" THEN
                ASSIGN c-item-fabric = fabricante.nome-abrev + "  " + item-fabric.it-fabric.
             ELSE 
                ASSIGN c-item-fabric = c-item-fabric + " / " + fabricante.nome-abrev + "  " + item-fabric.it-fabric.
        end.
    end.

    for each it-res-carac no-lock
        where it-res-carac.it-codigo = item.it-codigo:
        
        if it-res-carac.nr-tabela <> 0 then do:
            FIND c-tab-res 
                where c-tab-res.nr-tabela = it-res-carac.nr-tabela
                  and c-tab-res.sequencia = it-res-carac.sequencia
                    no-lock no-error.
            if avail c-tab-res then do:
                CASE it-res-carac.nr-tabela:
                    WHEN 1 THEN ASSIGN c-fab-inf    = c-tab-res.descricao.
                    WHEN 4 THEN ASSIGN c-acond      = c-tab-res.descricao.
                END CASE.
            end.
         end.
    end.

    FIND FIRST familia
        WHERE familia.fm-codigo = ITEM.fm-codigo NO-LOCK NO-ERROR.
    IF AVAIL familia THEN
        FIND FIRST int-familia OF familia NO-LOCK NO-ERROR.
    IF AVAIL int-familia THEN
        ASSIGN c-fab-inf  = STRING(int-familia.meses-validade) + " Meses".

    FIND FIRST ae-entrada WHERE
         ae-entrada.cod-estabel  = ficha-cq.cod-estabel and
         ae-entrada.cod-emitente = ficha-cq.cod-emitente AND
         ae-entrada.nro-docto    = int(ficha-cq.nro-docto) NO-LOCK NO-ERROR. /* FALTA COMPILAR */
    IF AVAIL ae-entrada THEN DO:
       ASSIGN c-volume       = ae-entrada.estrado[1]
              c-localizacao1 = ae-entrada.localizacao[1]
              c-localizacao2 = ae-entrada.localizacao[2]
              c-localizacao3 = ae-entrada.localizacao[3]
              c-localizacao4 = ae-entrada.localizacao[4]
              c-localizacao5 = ae-entrada.localizacao[5].
    END.
    ELSE DO:
        ASSIGN c-volume       = ""
               c-localizacao1 = ""
               c-localizacao2 = ""
               c-localizacao3 = ""
               c-localizacao4 = ""
               c-localizacao5 = "".
    END.
        
	If can-find (first funcao where funcao.cd-funcao = "lote-avancado":U) then do:
	    
        IF ficha-cq.origem <> 4
       AND ficha-cq.origem <> 1 
       AND ficha-cq.estado = 1
       AND NOT deposito.ind-dep-cq THEN DO:
            run cqp/cqapi304fx.p persistent set h-cqapi304fx.			
    
    	
            run buscaDepositoCQ (input ficha-cq.cod-estabel,
        						 input ficha-cq.it-codigo,
        						 input ficha-cq.cod-depos,
        						 output c-deposito-cq).
		
    	    empty temp-table ttGenerateManualRoutingVO.
		
            create ttGenerateManualRoutingVO.
    	    assign ttGenerateManualRoutingVO.siteCode       = ficha-cq.cod-estabel
        		   ttGenerateManualRoutingVO.warehouseCode		= ficha-cq.cod-depos
        		   ttGenerateManualRoutingVO.locationCode		= ficha-cq.cod-localiz
        		   ttGenerateManualRoutingVO.itemCode			= ficha-cq.it-codigo
        		   ttGenerateManualRoutingVO.vendorCode			= ficha-cq.cod-emitente
        		   ttGenerateManualRoutingVO.lotCode			= ficha-cq.lote
        		   ttGenerateManualRoutingVO.referenceCode      = ficha-cq.cod-refer
        		   ttGenerateManualRoutingVO.quantity           = ficha-cq.qt-original
        		   ttGenerateManualRoutingVO.warehouseCq        = c-deposito-cq
        		   ttGenerateManualRoutingVO.checkTransferCQ    = TRUE
        		   ttGenerateManualRoutingVO.documentNumber     = ficha-cq.nro-docto
        		   ttGenerateManualRoutingVO.seriesNumber       = ficha-cq.serie-docto
    		       ttGenerateManualRoutingVO.operationType      = ficha-cq.nat-operacao
        		   ttGenerateManualRoutingVO.locationCQ         = "":U.
        
            empty temp-table RowErrors.
    	
            run gera-movimento-cq in h-cqapi304fx (input table ttGenerateManualRoutingVO,
        	    								   input table ttProductionOrderVO,
        		    							   input ficha-cq.nr-ficha,
        			    						   output p-ficha-num,
        				    					   output table RowErrors).
            if can-find(first RowErrors 
        			    where RowErrors.ErrorSubType = "ERROR":U) then do:
        	    for each RowErrors no-lock:
                    DISP ficha-cq.nr-ficha
                         RowErrors.ErrorNumber
                         RowErrors.ErrorDescription
                      WITH FRAME f-erros WIDTH 132 STREAM-IO. 
        	    end.
        	    undo,next.
            end.
        END.
    end.
    assign c-descricao = item.desc-item.

    if  tt-param.l-um-por-pag = no then do:
        disp ficha-cq.cod-estabel
             ficha-cq.cod-localiz
             ficha-cq.lote
             ficha-cq.nr-ficha
             ficha-cq.cod-depos
             c-nat-operacao
             cTextoSkipLote
             with frame f-ficha.
        if avail estabelec then
            disp estabelec.nome with frame f-ficha.
        else
            disp "" @ estabelec.nome with frame f-ficha.
        if avail deposito then
            disp deposito.nome with frame f-ficha.
        else
            disp "" @ deposito.nome with frame f-ficha.
        if avail docum-est then
            disp docum-est.dt-emissao with frame f-ficha.
        else
            disp "" @ docum-est.dt-emissao with frame f-ficha.

        RELEASE rat-ordem.

        FIND FIRST int-pedido-compr NO-LOCK
             WHERE int-pedido-compr.num-pedido = ordem-compra.num-pedido NO-ERROR.

        ASSIGN c-tipo-pedido = "".
        IF AVAIL int-pedido-compr THEN
            ASSIGN c-tipo-pedido = ENTRY(int-pedido-compr.tp-pedido,c-tipos,",").

        IF NOT AVAIL int-pedido-compr AND AVAIL docum-est THEN DO:
            FOR FIRST item-doc-est OF docum-est NO-LOCK
                WHERE item-doc-est.it-codigo = ficha-cq.it-codigo,
                FIRST rat-ordem OF item-doc-est NO-LOCK,
                FIRST int-pedido-compr NO-LOCK
                WHERE int-pedido-compr.num-pedido = rat-ordem.num-pedido:
                ASSIGN c-tipo-pedido = ENTRY(int-pedido-compr.tp-pedido,c-tipos,",").
            END.
        END.

        if  ficha-cq.origem = 3 then do:
            find first oper-ord
                where oper-ord.nr-ord-prod = ficha-cq.nr-ord-prod
                and   oper-ord.sequencia   = ficha-cq.op-seq
                no-lock no-error.
            disp ficha-cq.nr-ord-prod
                 ficha-cq.serie-docto
                 ficha-cq.nro-docto
                 c-descricao
                 ficha-cq.qt-original
                 with frame f-comp-fic2.
            if avail emitente then
                disp ficha-cq.cod-emitente
                     emitente.nome-emit with frame f-comp-fic2.
            else
                disp "" @ ficha-cq.cod-emitente
                     "" @ emitente.nome-emit with frame f-comp-fic2.

            disp c-awb with frame f-comp-fic2.

            if avail item then
                disp item.it-codigo
                     item.un with frame f-comp-fic2.
            else
                disp "" @ item.it-codigo
                     "" @ item.un with frame f-comp-fic2.
            if avail oper-ord then
                disp oper-ord.cod-roteiro
                     oper-ord.op-codigo with frame f-comp-fic2.
            else
                disp "" @ oper-ord.cod-roteiro
                     "" @ oper-ord.op-codigo with frame f-comp-fic2.
        end.
        else do:
            IF AVAIL rat-ordem THEN DO:
               disp ficha-cq.serie-docto
                    ficha-cq.nro-docto
                    item.it-codigo
                    item.un
                    c-descricao
                    rat-ordem.numero-ordem @ ficha-cq.nr-ordem
                    rat-ordem.parcela      @ ficha-cq.parcela
                    ficha-cq.qt-original
                    with frame f-comp-fic1.
               if avail emitente then
                   disp ficha-cq.cod-emitente
                        emitente.nome-emit with frame f-comp-fic1.
               else
                   disp "" @ ficha-cq.cod-emitente
                        "" @ emitente.nome-emit with frame f-comp-fic1.
               
               disp c-awb with frame f-comp-fic1.
               
               disp rat-ordem.num-pedido @ ordem-compra.num-pedido with frame f-comp-fic1.
            END.
            ELSE DO:
               disp ficha-cq.serie-docto
                    ficha-cq.nro-docto
                    item.it-codigo
                    item.un
                    c-descricao
                    ficha-cq.nr-ordem
                    ficha-cq.parcela
                    ficha-cq.qt-original
                    with frame f-comp-fic1.
               if avail emitente then
                   disp ficha-cq.cod-emitente
                        emitente.nome-emit with frame f-comp-fic1.
               else
                   disp "" @ ficha-cq.cod-emitente
                        "" @ emitente.nome-emit with frame f-comp-fic1.
               
               disp c-awb with frame f-comp-fic1.
               
               if avail ordem-compra then
                   disp ordem-compra.num-pedido with frame f-comp-fic1.
               else
                   disp "" @ ordem-compra.num-pedido with frame f-comp-fic1.
            END.
        end.

        PUT UNFORMATTED "     Fabr.Inferior: " c-fab-inf       
                        "Acondicionamento: " AT 75 c-acond  SKIP
                        /*"               AWB: " c-awb      SKIP*/
                        "   Item Fabricante: " c-item-fabric SKIP
                        "           Volumes: " c-volume              skip
                        "     Tipo Pedido: " AT 75 c-tipo-pedido  SKIP
                        "       Localizaá∆o: " "1- " c-localizacao1              skip
                        "                    2- " c-localizacao2              skip
                        "                    3- " c-localizacao3              skip
                        "                    4- " c-localizacao4              skip
                        "                    5- " c-localizacao5              SKIP (1).

        RUN pi-obs-insp.

        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "ObservaÁ„o: " *}
        ASSIGN c-observacao = RETURN-VALUE.

        RUN pi-narrativa.
        if tt-param.l-observacao then do:
           run pi-print-editor (ficha-cq.observacao, 110).                  
           find first tt-editor no-error.
           put c-observacao at 12.
           if avail tt-editor then
           put tt-editor.conteudo at 24.              
           for each tt-editor
              where tt-editor.linha > 1:
              put tt-editor.conteudo at 24.
           end.
        end. 
        view frame f-traco.
    end.
    
    for each exam-ficha no-lock
        where exam-ficha.nr-ficha = ficha-cq.nr-ficha:
            run pi-acompanhar in h-acomp (input exam-ficha.it-codigo).
            if  tt-param.l-um-por-pag = yes then do:
                disp ficha-cq.cod-estabel
                     estabelec.nome
                     ficha-cq.cod-localiz
                     ficha-cq.lote
                     ficha-cq.nr-ficha
                     ficha-cq.cod-depos
                     c-nat-operacao
                     deposito.nome
                     with frame f-ficha.
                if avail docum-est then
                    disp docum-est.dt-emissao with frame f-ficha.
                else 
                    disp "" @ docum-est.dt-emissao with frame f-ficha.
                if  ficha-cq.origem = 3 then do:
                    find first oper-ord
                        where oper-ord.nr-ord-prod = ficha-cq.nr-ord-prod
                        and   oper-ord.sequencia   = ficha-cq.op-seq
                        no-lock no-error.
                    disp ficha-cq.nr-ord-prod 
                         ficha-cq.serie-docto
                         ficha-cq.nro-docto
                         item.it-codigo
                         item.un
                         c-descricao
                         ficha-cq.qt-original
                         with frame f-comp-fic2.
                    if avail emitente then
                        disp ficha-cq.cod-emitente 
                             emitente.nome-emit with frame f-comp-fic2.
                    else
                        disp "" @ ficha-cq.cod-emitente
                             "" @ emitente.nome-emit with frame f-comp-fic2.

                    disp c-awb with frame f-comp-fic2.

                    if avail oper-ord then
                        disp oper-ord.cod-roteiro
                             oper-ord.op-codigo with frame f-comp-fic2.
                    else
                        disp "" @ oper-ord.cod-roteiro
                             "" @ oper-ord.op-codigo with frame f-comp-fic2.
                end.
                else do:
                    disp ficha-cq.serie-docto
                         ficha-cq.nro-docto
                         item.it-codigo
                         item.un
                         c-descricao
                         ficha-cq.nr-ordem
                         ficha-cq.parcela
                         ficha-cq.qt-original
                         with frame f-comp-fic1.
                    if avail emitente then
                        disp ficha-cq.cod-emitente
                             emitente.nome-emit with frame f-comp-fic1.
                    else
                        disp "" @ ficha-cq.cod-emitente
                             "" @ emitente.nome-emit with frame f-comp-fic1.

                    disp c-awb with frame f-comp-fic1.

                    if avail ordem-compra then
                        disp ordem-compra.num-pedido with frame f-comp-fic1.
                    else
                        disp "" @ ordem-compra.num-pedido with frame f-comp-fic1.
                end.
                RUN pi-narrativa.
                view frame f-traco1.
            end.
            find first exame
                where exame.cod-exame = exam-ficha.cod-exame no-lock no-error.
            disp exam-ficha.cod-exame
                 exame.descricao
                 exam-ficha.responsavel
                 exam-ficha.nr-aceita
                 exam-ficha.nr-rejeita
                 exam-ficha.tam-amostra
                 exame.frequencia
                 exame.rejeita-lote
                 with frame f-exame.
			if exam-ficha.laudo <> "" then 
				disp exam-ficha.laudo with frame f-laudo-exam.
            {esp/cqp/escqp012.i1}
            view frame f-132.
    end.
    
    /*-------------------------- ATENCAO -------------------------*/
    /*    C¢digo para atualizar arquivo ficha-cq - NAO RETIRAR    */
    assign c-revisao = "001".
    if  ficha-cq.estado = 1 then do:
        assign ficha-cq.estado = 2.
	end.
    else do:
        if  ficha-cq.estado = 2 then do:		
            assign ficha-cq.estado = 3.
		end.
	end.
    if  ficha-cq.situacao = 1 then do:
        assign ficha-cq.situacao   = 2
               ficha-cq.dt-analise = today
               ficha-cq.dt-ult-sit = today.
	end.

	if  tt-param.classifica = 3 
    AND LAST-OF ({2}) then do:
        IF PAGE-NUMBER MOD 2 = 0 THEN
            PAGE.
        ELSE DO:
            PAGE.
            PUT "".
            PAGE.
        END.

        {include/i-rpclo.i}

        {include/i-rpout.i &APPEND=APPEND}
        view frame f-cabec.
        view frame f-rodape.

    END.
    
    
end.

/* Imprime CKD (muda o Break By) */
for each ficha-cq use-index {1}
    where ficha-cq.nr-ficha     >= tt-param.i-ficha-ini
    and   ficha-cq.nr-ficha     <= tt-param.i-ficha-fim
    and   ficha-cq.cod-estabel  >= tt-param.c-estab-ini
    and   ficha-cq.cod-estabel  <= tt-param.c-estab-fim
    and   ficha-cq.cod-depos    >= tt-param.c-depos-ini
    and   ficha-cq.cod-depos    <= tt-param.c-depos-fim
    and   ficha-cq.it-codigo    >= tt-param.c-item-ini
    and   ficha-cq.it-codigo    <= tt-param.c-item-fim
    and   ficha-cq.cod-emitente >= tt-param.c-cod-emitente-ini
    and   ficha-cq.cod-emitente <= tt-param.c-cod-emitente-fim
    and   ficha-cq.cod-localiz  >= tt-param.c-local-ini
    and   ficha-cq.cod-localiz  <= tt-param.c-local-fim
    and   ficha-cq.lote         >= tt-param.c-lote-ini
    and   ficha-cq.lote         <= tt-param.c-lote-fim
    and   ficha-cq.serie-docto  >= tt-param.c-serie-ini
    and   ficha-cq.serie-docto  <= tt-param.c-serie-fim
    and   ficha-cq.nro-docto    >= tt-param.c-docto-ini
    and   ficha-cq.nro-docto    <= tt-param.c-docto-fim
    and   not ficha-cq.inspecionado
    and   (ficha-cq.estado = 1 or tt-param.l-ja-impresso = yes) exclusive-lock,
    FIRST ITEM NO-LOCK
    WHERE ITEM.it-codigo = ficha-cq.it-codigo,
    FIRST in-grup-estoq NO-LOCK
    WHERE in-grup-estoq.ge-codigo = ITEM.ge-codigo
      AND in-grup-estoq.log-ckd   = YES
 BREAK BY {2} BY ficha-cq.lote {3}:
    
    /* Inicio -- Projeto Internacional */
    RUN utp/ut-trfrrp.p (INPUT FRAME f-erros:HANDLE).

    run pi-acompanhar in h-acomp (input ficha-cq.it-codigo).

    ASSIGN i-pag-ini = PAGE-NUMBER.

    IF ficha-cq.log-1 = YES THEN DO:
        RUN utp/ut-msgs.p (INPUT "help":U,
                           INPUT 51423,
                           INPUT ficha-cq.nr-ficha).
        DISP ficha-cq.nr-ficha
             51423 @ RowErrors.ErrorNumber
             RETURN-VALUE @ RowErrors.ErrorDescription
             WITH FRAME f-erros WIDTH 132 STREAM-IO. 
        NEXT.
    END.
    find docum-est
        where docum-est.serie-docto  = ficha-cq.serie-docto
        and   docum-est.nro-docto    = ficha-cq.nro-docto
        and   docum-est.cod-emitente = ficha-cq.cod-emitente
        and   docum-est.nat-operacao = ficha-cq.nat-operacao no-lock no-error.

    ASSIGN c-nat-operacao = ficha-cq.nat-operacao.
    find FIRST item-doc-est
         where item-doc-est.serie-docto  = ficha-cq.serie-docto
         and   item-doc-est.nro-docto    = ficha-cq.nro-docto
         and   item-doc-est.cod-emitente = ficha-cq.cod-emitente
         and   item-doc-est.nat-operacao = ficha-cq.nat-operacao 
         AND   item-doc-est.it-codigo    = ficha-cq.it-codigo 
         AND   item-doc-est.numero-ordem = ficha-cq.nr-ordem no-lock no-error.
    IF AVAIL item-doc-est THEN
       ASSIGN c-nat-operacao = item-doc-est.nat-of.

    find ordem-compra
        where ordem-compra.numero-ordem = ficha-cq.nr-ordem no-lock no-error.

    find emitente
        where ficha-cq.cod-emitente = emitente.cod-emitente no-lock no-error.

    find first estabelec
        where estabelec.cod-estabel = ficha-cq.cod-estabel  no-lock no-error.

    find first deposito
        where deposito.cod-depos = ficha-cq.cod-depos no-lock no-error.

    ASSIGN c-item-fabric = ""
           c-fab-inf     = ""
           c-acond       = ""
           c-awb         = "".

    IF AVAIL docum-est AND docum-est.nat-operacao BEGINS "3" THEN DO:
       FIND FIRST embarque-imp
            WHERE embarque-imp.cod-estabel = docum-est.cod-estabel 
            AND   embarque-imp.embarque    = TRIM(SUBSTRING(docum-est.char-1,1,20)) NO-LOCK NO-ERROR.
       IF AVAIL embarque-imp THEN
          ASSIGN c-awb = TRIM(embarque-imp.cod-conhecto-maste).
    END.    

    find first item-fabric no-lock
         where item-fabric.it-codigo  = item.it-codigo 
           and item-fabric.cod-fabric = emitente.cod-emitente no-error.
    if avail item-fabric then do:
        assign c-item-fabric = item-fabric.it-fabric.
    end.
    else do:
        for each item-fabric no-lock  
           where item-fabric.it-codigo = item.it-codigo,
            each fabricante no-lock
           where fabricante.cod-fabric = item-fabric.cod-fabric:
             IF c-item-fabric = "" THEN
                ASSIGN c-item-fabric = fabricante.nome-abrev + "  " + item-fabric.it-fabric.
             ELSE 
                ASSIGN c-item-fabric = c-item-fabric + " / " + fabricante.nome-abrev + "  " + item-fabric.it-fabric.
        end.
    end.

    for each it-res-carac no-lock
        where it-res-carac.it-codigo = item.it-codigo:
        
        if it-res-carac.nr-tabela <> 0 then do:
            FIND c-tab-res 
                where c-tab-res.nr-tabela = it-res-carac.nr-tabela
                  and c-tab-res.sequencia = it-res-carac.sequencia
                    no-lock no-error.
            if avail c-tab-res then do:
                CASE it-res-carac.nr-tabela:
                    WHEN 1 THEN ASSIGN c-fab-inf    = c-tab-res.descricao.
                    WHEN 4 THEN ASSIGN c-acond      = c-tab-res.descricao.
                END CASE.
            end.
         end.
    end.

    FIND FIRST familia
        WHERE familia.fm-codigo = ITEM.fm-codigo NO-LOCK NO-ERROR.
    IF AVAIL familia THEN
        FIND FIRST int-familia OF familia NO-LOCK NO-ERROR.
    IF AVAIL int-familia THEN
        ASSIGN c-fab-inf  = STRING(int-familia.meses-validade) + " Meses".

    FIND FIRST ae-entrada WHERE
         ae-entrada.cod-estabel  = ficha-cq.cod-estabel and
         ae-entrada.cod-emitente = ficha-cq.cod-emitente AND
         ae-entrada.nro-docto    = int(ficha-cq.nro-docto) NO-LOCK NO-ERROR. /* FALTA COMPILAR */
    IF AVAIL ae-entrada THEN DO:
       ASSIGN c-volume       = ae-entrada.estrado[1]
              c-localizacao1 = ae-entrada.localizacao[1]
              c-localizacao2 = ae-entrada.localizacao[2]
              c-localizacao3 = ae-entrada.localizacao[3]
              c-localizacao4 = ae-entrada.localizacao[4]
              c-localizacao5 = ae-entrada.localizacao[5].
    END.
    ELSE DO:
        ASSIGN c-volume       = ""
               c-localizacao1 = ""
               c-localizacao2 = ""
               c-localizacao3 = ""
               c-localizacao4 = ""
               c-localizacao5 = "".
    END.
        
	If can-find (first funcao where funcao.cd-funcao = "lote-avancado":U) then do:
	    
        IF ficha-cq.origem <> 4
       AND ficha-cq.origem <> 1 
       AND ficha-cq.estado = 1
       AND NOT deposito.ind-dep-cq THEN DO:
            run cqp/cqapi304fx.p persistent set h-cqapi304fx.			
    
    	
            run buscaDepositoCQ (input ficha-cq.cod-estabel,
        						 input ficha-cq.it-codigo,
        						 input ficha-cq.cod-depos,
        						 output c-deposito-cq).
		
    	    empty temp-table ttGenerateManualRoutingVO.
		
            create ttGenerateManualRoutingVO.
    	    assign ttGenerateManualRoutingVO.siteCode       = ficha-cq.cod-estabel
        		   ttGenerateManualRoutingVO.warehouseCode		= ficha-cq.cod-depos
        		   ttGenerateManualRoutingVO.locationCode		= ficha-cq.cod-localiz
        		   ttGenerateManualRoutingVO.itemCode			= ficha-cq.it-codigo
        		   ttGenerateManualRoutingVO.vendorCode			= ficha-cq.cod-emitente
        		   ttGenerateManualRoutingVO.lotCode			= ficha-cq.lote
        		   ttGenerateManualRoutingVO.referenceCode      = ficha-cq.cod-refer
        		   ttGenerateManualRoutingVO.quantity           = ficha-cq.qt-original
        		   ttGenerateManualRoutingVO.warehouseCq        = c-deposito-cq
        		   ttGenerateManualRoutingVO.checkTransferCQ    = TRUE
        		   ttGenerateManualRoutingVO.documentNumber     = ficha-cq.nro-docto
        		   ttGenerateManualRoutingVO.seriesNumber       = ficha-cq.serie-docto
    		       ttGenerateManualRoutingVO.operationType      = ficha-cq.nat-operacao
        		   ttGenerateManualRoutingVO.locationCQ         = "":U.
        
            empty temp-table RowErrors.
    	
            run gera-movimento-cq in h-cqapi304fx (input table ttGenerateManualRoutingVO,
        	    								   input table ttProductionOrderVO,
        		    							   input ficha-cq.nr-ficha,
        			    						   output p-ficha-num,
        				    					   output table RowErrors).
            if can-find(first RowErrors 
        			    where RowErrors.ErrorSubType = "ERROR":U) then do:
        	    for each RowErrors no-lock:
                    DISP ficha-cq.nr-ficha
                         RowErrors.ErrorNumber
                         RowErrors.ErrorDescription
                      WITH FRAME f-erros WIDTH 132 STREAM-IO. 
        	    end.
        	    undo,next.
            end.
        END.
    end.
    assign c-descricao = item.desc-item.

    if  tt-param.l-um-por-pag = no then do:
        disp ficha-cq.cod-estabel
             ficha-cq.cod-localiz
             ficha-cq.lote
             ficha-cq.nr-ficha
             ficha-cq.cod-depos
             c-nat-operacao
             with frame f-ficha.
        if avail estabelec then
            disp estabelec.nome with frame f-ficha.
        else
            disp "" @ estabelec.nome with frame f-ficha.
        if avail deposito then
            disp deposito.nome with frame f-ficha.
        else
            disp "" @ deposito.nome with frame f-ficha.
        if avail docum-est then
            disp docum-est.dt-emissao with frame f-ficha.
        else
            disp "" @ docum-est.dt-emissao with frame f-ficha.

        RELEASE rat-ordem.

        FIND FIRST int-pedido-compr NO-LOCK
             WHERE int-pedido-compr.num-pedido = ordem-compra.num-pedido NO-ERROR.

        ASSIGN c-tipo-pedido = "".
        IF AVAIL int-pedido-compr THEN
            ASSIGN c-tipo-pedido = ENTRY(int-pedido-compr.tp-pedido,c-tipos,",").

        IF NOT AVAIL int-pedido-compr AND AVAIL docum-est THEN DO:
            FOR FIRST item-doc-est OF docum-est NO-LOCK
                WHERE item-doc-est.it-codigo = ficha-cq.it-codigo,
                FIRST rat-ordem OF item-doc-est NO-LOCK,
                FIRST int-pedido-compr NO-LOCK
                WHERE int-pedido-compr.num-pedido = rat-ordem.num-pedido:
                ASSIGN c-tipo-pedido = ENTRY(int-pedido-compr.tp-pedido,c-tipos,",").
            END.
        END.

        if  ficha-cq.origem = 3 then do:
            find first oper-ord
                where oper-ord.nr-ord-prod = ficha-cq.nr-ord-prod
                and   oper-ord.sequencia   = ficha-cq.op-seq
                no-lock no-error.
            disp ficha-cq.nr-ord-prod
                 ficha-cq.serie-docto
                 ficha-cq.nro-docto
                 c-descricao
                 ficha-cq.qt-original
                 with frame f-comp-fic2.
            if avail emitente then
                disp ficha-cq.cod-emitente
                     emitente.nome-emit with frame f-comp-fic2.
            else
                disp "" @ ficha-cq.cod-emitente
                     "" @ emitente.nome-emit with frame f-comp-fic2.

            disp c-awb with frame f-comp-fic2.

            if avail item then
                disp item.it-codigo
                     item.un with frame f-comp-fic2.
            else
                disp "" @ item.it-codigo
                     "" @ item.un with frame f-comp-fic2.
            if avail oper-ord then
                disp oper-ord.cod-roteiro
                     oper-ord.op-codigo with frame f-comp-fic2.
            else
                disp "" @ oper-ord.cod-roteiro
                     "" @ oper-ord.op-codigo with frame f-comp-fic2.
        end.
        else do:
            IF AVAIL rat-ordem THEN DO:
               disp ficha-cq.serie-docto
                    ficha-cq.nro-docto
                    item.it-codigo
                    item.un
                    c-descricao
                    rat-ordem.numero-ordem @ ficha-cq.nr-ordem
                    rat-ordem.parcela      @ ficha-cq.parcela
                    ficha-cq.qt-original
                    with frame f-comp-fic1.
               if avail emitente then
                   disp ficha-cq.cod-emitente
                        emitente.nome-emit with frame f-comp-fic1.
               else
                   disp "" @ ficha-cq.cod-emitente
                        "" @ emitente.nome-emit with frame f-comp-fic1.
               
               disp c-awb with frame f-comp-fic1.
               
               disp rat-ordem.num-pedido @ ordem-compra.num-pedido with frame f-comp-fic1.
            END.
            ELSE DO:
               disp ficha-cq.serie-docto
                    ficha-cq.nro-docto
                    item.it-codigo
                    item.un
                    c-descricao
                    ficha-cq.nr-ordem
                    ficha-cq.parcela
                    ficha-cq.qt-original
                    with frame f-comp-fic1.
               if avail emitente then
                   disp ficha-cq.cod-emitente
                        emitente.nome-emit with frame f-comp-fic1.
               else
                   disp "" @ ficha-cq.cod-emitente
                        "" @ emitente.nome-emit with frame f-comp-fic1.
               
               disp c-awb with frame f-comp-fic1.
               
               if avail ordem-compra then
                   disp ordem-compra.num-pedido with frame f-comp-fic1.
               else
                   disp "" @ ordem-compra.num-pedido with frame f-comp-fic1.
            END.
        end.

        PUT UNFORMATTED "     Fabr.Inferior: " c-fab-inf       
                        "Acondicionamento: " AT 75 c-acond  SKIP
                        /*"               AWB: " c-awb      SKIP*/
                        "   Item Fabricante: " c-item-fabric SKIP
                        "           Volumes: " c-volume              skip
                        "     Tipo Pedido: " AT 75 c-tipo-pedido  SKIP
                        "       Localizaá∆o: " "1- " c-localizacao1              skip
                        "                    2- " c-localizacao2              skip
                        "                    3- " c-localizacao3              skip
                        "                    4- " c-localizacao4              skip
                        "                    5- " c-localizacao5              SKIP (1).

        RUN pi-obs-insp.

        /* Inicio -- Projeto Internacional */
        
        {utp/ut-liter.i "ObservaÁ„o: " *}
        ASSIGN c-observacao = RETURN-VALUE.

        RUN pi-narrativa.
        if tt-param.l-observacao then do:
           run pi-print-editor (ficha-cq.observacao, 110).                  
           find first tt-editor no-error.
           put c-observacao at 12.
           if avail tt-editor then
           put tt-editor.conteudo at 24.              
           for each tt-editor
              where tt-editor.linha > 1:
              put tt-editor.conteudo at 24.
           end.
        end. 
        view frame f-traco.
    end.

    
    for each exam-ficha no-lock
        where exam-ficha.nr-ficha = ficha-cq.nr-ficha:
            run pi-acompanhar in h-acomp (input exam-ficha.it-codigo).
            if  tt-param.l-um-por-pag = yes then do:
                disp ficha-cq.cod-estabel
                     estabelec.nome
                     ficha-cq.cod-localiz
                     ficha-cq.lote
                     ficha-cq.nr-ficha
                     ficha-cq.cod-depos
                     c-nat-operacao
                     deposito.nome
                     with frame f-ficha.
                if avail docum-est then
                    disp docum-est.dt-emissao with frame f-ficha.
                else 
                    disp "" @ docum-est.dt-emissao with frame f-ficha.
                if  ficha-cq.origem = 3 then do:
                    find first oper-ord
                        where oper-ord.nr-ord-prod = ficha-cq.nr-ord-prod
                        and   oper-ord.sequencia   = ficha-cq.op-seq
                        no-lock no-error.
                    disp ficha-cq.nr-ord-prod 
                         ficha-cq.serie-docto
                         ficha-cq.nro-docto
                         item.it-codigo
                         item.un
                         c-descricao
                         ficha-cq.qt-original
                         with frame f-comp-fic2.
                    if avail emitente then
                        disp ficha-cq.cod-emitente 
                             emitente.nome-emit with frame f-comp-fic2.
                    else
                        disp "" @ ficha-cq.cod-emitente
                             "" @ emitente.nome-emit with frame f-comp-fic2.

                    disp c-awb with frame f-comp-fic2.

                    if avail oper-ord then
                        disp oper-ord.cod-roteiro
                             oper-ord.op-codigo with frame f-comp-fic2.
                    else
                        disp "" @ oper-ord.cod-roteiro
                             "" @ oper-ord.op-codigo with frame f-comp-fic2.
                end.
                else do:
                    disp ficha-cq.serie-docto
                         ficha-cq.nro-docto
                         item.it-codigo
                         item.un
                         c-descricao
                         ficha-cq.nr-ordem
                         ficha-cq.parcela
                         ficha-cq.qt-original
                         with frame f-comp-fic1.
                    if avail emitente then
                        disp ficha-cq.cod-emitente
                             emitente.nome-emit with frame f-comp-fic1.
                    else
                        disp "" @ ficha-cq.cod-emitente
                             "" @ emitente.nome-emit with frame f-comp-fic1.

                    disp c-awb with frame f-comp-fic1.

                    if avail ordem-compra then
                        disp ordem-compra.num-pedido with frame f-comp-fic1.
                    else
                        disp "" @ ordem-compra.num-pedido with frame f-comp-fic1.
                end.
                RUN pi-narrativa.
                view frame f-traco1.
            end.

            
            find first exame
                where exame.cod-exame = exam-ficha.cod-exame no-lock no-error.
            
            disp exam-ficha.cod-exame
                 exame.descricao
                 exam-ficha.responsavel
                 exam-ficha.nr-aceita
                 exam-ficha.nr-rejeita
                 exam-ficha.tam-amostra
                 exame.frequencia
                 exame.rejeita-lote
                 with frame f-exame.
            /*     
			if exam-ficha.laudo <> "" then 
				disp exam-ficha.laudo with frame f-laudo-exam.
                */
            
            {esp/cqp/escqp012.i1}
            view frame f-132.
            
    end.
    
    /*-------------------------- ATENCAO -------------------------*/
    /*    C¢digo para atualizar arquivo ficha-cq - NAO RETIRAR    */
    assign c-revisao = "001".
    if  ficha-cq.estado = 1 then do:
        assign ficha-cq.estado = 2.
	end.
    else do:
        if  ficha-cq.estado = 2 then do:		
            assign ficha-cq.estado = 3.
		end.
	end.
    if  ficha-cq.situacao = 1 then do:
        assign ficha-cq.situacao   = 2
               ficha-cq.dt-analise = today
               ficha-cq.dt-ult-sit = today.
	end.

	if  tt-param.classifica = 3 
    AND LAST-OF (ficha-cq.lote) then do:
        IF PAGE-NUMBER MOD 2 = 0 THEN
            PAGE.
        ELSE DO:
            PAGE.
            PUT "".
            PAGE.
        END.

        {include/i-rpclo.i}

        {include/i-rpout.i &APPEND=APPEND}
        view frame f-cabec.
        view frame f-rodape.

    END.
    
end.
END.
PROCEDURE pi-narrativa:
    IF tt-param.l-narrativa-item THEN DO:
        FIND FIRST narrativa
            WHERE narrativa.it-codigo = ficha-cq.it-codigo NO-LOCK NO-ERROR.
        IF AVAIL narrativa THEN DO:
            RUN pi-print-editor (narrativa.descricao, 80).
            FOR EACH tt-editor 
                WHERE tt-editor.linha > 0:
                DISP tt-editor.conteudo 
                    WITH FRAME f-narrativa-1.
                DOWN WITH FRAME f-narrativa-1.
            END.
            PUT SKIP(1).
            DOWN WITH FRAME f-narrativa-1.
        END.
    END.
END PROCEDURE.

PROCEDURE pi-obs-insp:

    FIND FIRST item-fornec-estab NO-LOCK 
         WHERE item-fornec-estab.cod-estabel  = ficha-cq.cod-estabel
           AND item-fornec-estab.it-codigo    = ficha-cq.it-codigo
           AND item-fornec-estab.cod-emitente = ficha-cq.cod-emitente NO-ERROR.
    
    IF AVAIL item-fornec-estab THEN DO:
        FIND FIRST int-item-fornec OF item-fornec-estab NO-LOCK NO-ERROR.
    
        IF AVAIL int-item-fornec THEN DO:
            
/*             IF int-item-fornec.obs-insp <> "" THEN DO:             */
/*                RUN pi-print-editor (int-item-fornec.obs-insp, 80). */
/*                FOR EACH tt-editor                                  */
/*                    WHERE tt-editor.linha > 0:                      */
/*                    PUT UNFORMATTED tt-editor.conteudo SKIP.        */
/*                END.                                                */
/*             END.                                                   */
            IF int-item-fornec.obs-rec <> "" THEN DO:
                RUN pi-print-editor (int-item-fornec.obs-rec, 110).
                PUT UNFORMATTED "           OBS REC: ".
                FOR EACH tt-editor 
                    WHERE tt-editor.linha > 0:
                    IF tt-editor.linha = 1 THEN
                        PUT UNFORMATTED tt-editor.conteudo SKIP.
                    ELSE
                        PUT UNFORMATTED "                    " tt-editor.conteudo SKIP.
                END.
            END.
        END.
    END.
END.

/* Fim Include */
procedure buscaDepositoCQ:
	define input param pEstab as character no-undo.
	define input param pItem as character no-undo.
	define input param pDeposito as character no-undo.
    def output param c-cod-depos-cq like rat-lote.cod-depos no-undo.    
    
   DEFINE VARIABLE c-unid-neg-aux AS CHARACTER  NO-UNDO.   
    
   if not valid-handle(h-cdapi024) 
	   or h-cdapi024:type <> "PROCEDURE"
	   or h-cdapi024:file-name <> "cdp/cdapi024.p" then do:
	   run cdp/cdapi024.p persistent set h-cdapi024.
   end.

	   /*Se a UN n∆o foi informada no item do documento,
	   buscar† unidade de neg¢cio do relacionamento ITEM X ESTABELECIMENTO X DEP‡SITO,
	   se n∆o existir, retornar† UN do relacionamento ITEM X ESTABELECIMENTO. */
	   /*andre: RowObject*/
	   if item.cod-unid-negoc = "" then do:
	
		   if valid-handle(h-cdapi024) then 
			   run RetornaUnidadeNegocioExternaliz in h-cdapi024 (input pEstab,
																  input item.it-codigo,
																  input ficha-cq.cod-depos,
																  output c-unid-neg-aux).
	   end.
	   else
		   assign c-unid-neg-aux = item.cod-unid-negoc.
	
	   /*Relacionamento entre UN e Estabel, para determinaá∆o dos dep¢sitos,
	   se n∆o encontrar, utilizar† o dep¢sito informado para o estabelecimento*/
	   find first unid-negoc-cq
		   where unid-negoc-cq.cod-estabel    = pEstab
		   and   unid-negoc-cq.cod-unid-negoc = c-unid-neg-aux no-lock no-error.
	   if avail unid-negoc-cq then
		   assign c-cod-depos-cq = unid-negoc-cq.cod-depos-cq.
	   else
		   assign c-cod-depos-cq = estabelec.deposito-cq.
		   
	if valid-handle(h-cdapi024) then do:
		delete procedure h-cdapi024.
		assign h-cdapi024 = ?.
	end.
	
end procedure.
