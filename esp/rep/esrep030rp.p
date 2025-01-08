/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/*:T*******************************************************************************
**
**  Programa.: esp/rep/esrep030rp.p
**  Objetivo.: Gerar Relat¢rios de Importa‡Æo.
**  Cria‡Æo..: 03/05/2010
**
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESREP030RP 2.04.00.004}

{esp/rep/esrep030.i} /* Defini‡Æo Temp-Table tt-param, tt-digita e tt-raw-digita */
{utp/ut-glob.i}
{include/i-rpvar.i}
{method/dbotterr.i}

define input parameter raw-param as raw no-undo.
define input parameter table for tt-raw-digita.

define variable h-acomp   as handle  no-undo.
define variable l-pri-fat as logical no-undo.

DEFINE VARIABLE d-peso-bruto   AS DECIMAL FORMAT ">>>,>>9.99999" NO-UNDO.
DEFINE VARIABLE d-peso-liquido AS DECIMAL FORMAT ">>>,>>9.99999" NO-UNDO.
DEFINE VARIABLE h-boin090a     AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-desc-item    AS CHARACTER   NO-UNDO.

DEFINE BUFFER bf-historico-embarque FOR historico-embarque.

define temp-table tt-importacao no-undo
    field estabel      like docum-est.cod-estabel
    field embarque     like embarque-imp.embarque
    field nro-docto    like docum-est.nro-docto
    field emitente     like docum-est.cod-emitente
    field nome-abrev   like emitente.nome-abrev
    field dt-entrada   like docum-est.dt-trans
    field dt-embarque  like historico-embarque.dt-efetiva
    field dt-despacho  AS CHAR FORMAT "99/99/9999"
    field awb          like embarque-imp.cod-conhecto-master
    field di           like embarque-imp.declaracao-imp
    field itin-padrao  like emitente-cex.cod-itiner-imp
    field itin-utiliz  like itinerario.cod-itiner
    FIELD transportador         LIKE embarque-imp.cod-transportador
    FIELD peso-embarque-bruto   AS DECIMAL FORMAT ">>>,>>9.99999"
    FIELD peso-embarque-liquido AS DECIMAL FORMAT ">>>,>>9.99999"
    FIELD fat-ou-desp  AS CHARACTER FORMAT "x(07)":U
    field fat-desp     AS CHARACTER FORMAT "x(12)":U
    field parc-desc    AS CHARACTER FORMAT "x(30)":U
    field vlr-fat-desp AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999":U
    field des-moeda    like moeda.descricao
    field ci           like pagamento-invoice.nr-pagamento
    field swift        like banco-emit.swift[1]
    FIELD narrativa-emb AS CHAR FORMAT "X(100)"
    FIELD cond-pagto    AS CHAR FORMAT "X(50)"
    FIELD dt-vencto     AS CHAR FORMAT "99/99/9999"
    FIELD cod-cond-pag  LIKE desp-embarque.cod-cond-pag
    FIELD cod-emitente-desp LIKE desp-embarque.cod-emi
    .


DEFINE TEMP-TABLE tt-documentos NO-UNDO
    field embarque                   LIKE embarque-imp.embarque      
    field cod-estabel                LIKE embarque-imp.cod-estabel   
    field nro-docto                  LIKE docum-est.nro-docto
    field serie-docto                LIKE docum-est.serie-docto   
    field cod-emitente               LIKE docum-est.cod-emitente
    field nat-operacao               LIKE docum-est.nat-operacao
    field idi-nf-simples-remes       LIKE docum-est.idi-nf-simples-remes
    field dt-emissao                 LIKE docum-est.dt-emissao
    field usuario                    LIKE docum-est.usuario                          
    field ce-atual                   LIKE docum-est.ce-atual    
    field embarque-ori               LIKE embarque-imp.embarque
    field log-nota-ajust-import      LIKE item-doc-est.log-nota-ajust-import
    field r-rowid as rowid
.

FUNCTION fnTipoDocumento RETURNS CHARACTER
  ( pidi-nf-simples-remes  AS INT,
    pnat-operacao AS CHAR) FORWARD.

create tt-param.
raw-transfer raw-param to tt-param.

find first tt-param no-error.

find first param-global no-lock no-error.
find first empresa no-lock
    where empresa.ep-codigo = param-global.empresa-pri.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Relat¢rio Importa‡Æo":U
       c-empresa      = if available empresa then empresa.razao-social else "":U
       c-programa     = "ESREP030":U
       c-versao       = "2.04":U
       c-revisao      = "004":U.

if opsys = "UNIX":U then
    assign tt-param.arquivo     = c-programa + ".lst":U
           tt-param.arquivo-csv = c-seg-usuario + "/":U + replace(tt-param.arquivo, entry(num-entries(tt-param.arquivo, ".":U), tt-param.arquivo, ".":U), "csv":U).

form skip(1)
     "SELE€ÇO":U  at 13 skip(1)
     tt-param.estabel-ini   format "x(03)":U      label "Estabelecimento":U colon 40 
     " |< >| ":U at 54
     tt-param.estabel-fim   format "x(03)":U      no-label skip
     tt-param.emitente-ini  format ">>>>>>>>9":U  label "Emitente":U        colon 40
     " |< >| ":U at 54
     tt-param.emitente-fim  format ">>>>>>>>9":U  no-label skip
     tt-param.dt-trans-ini  format "99/99/9999":U label "Data Transa‡Æo":U  colon 40
     " |< >| ":U at 54
     tt-param.dt-trans-fim  format "99/99/9999":U no-label skip(1)
     skip(1)
     "PAR¶METRO":U at 13 skip(1)
     tt-param.awb           format "Sim/NÆo":U label "AWB":U colon 40 skip
     tt-param.di            format "Sim/NÆo":U label "DI":U  colon 40 skip
     tt-param.dt-emb-ent    format "Sim/NÆo":U label "Data Embarque \ Entrada":U colon 40 skip
     tt-param.fat-ci-swift  format "Sim/NÆo":U label "Faturas \ CI \ Swift":U colon 40 skip
     tt-param.despesas      FORMAT "Sim/NÆo":U LABEL "Despesas":U COLON 40 SKIP
     tt-param.itinerario    format "Sim/NÆo":U label "Itiner rio PadrÆo \ Utilizado":U colon 40 skip
     tt-param.narrativa-emb FORMAT "Sim/NÆo":U LABEL "Narrativa Embarque":U COLON 40 
     tt-param.transportador FORMAT "Sim/NÆo":U LABEL "Transportador":U COLON 40 
     tt-param.peso-embarque FORMAT "Sim/NÆo":U LABEL "Peso Embarque":U COLON 40 SKIP(1)
     skip(1)
     "IMPRESSÇO":U at 13 skip(1)
     tt-param.arquivo       format "x(80)":U   label "Destino":U     colon 40 skip
     tt-param.usuario       format "x(12)":U   label "Usu rio":U     colon 40 skip
     tt-param.arquivo-csv   format "x(80)":U   label "Arquivo CSV":U colon 40 skip(1)
     with stream-io side-labels no-attr-space no-box width 132 frame f-impressao.
     
run pi-gera-csv.
       
do on stop undo, leave:
    {include/i-rpcab.i}
    {include/i-rpout.i}
    
    view frame f-cabec.
    view frame f-rodape.
    
    display tt-param.estabel-ini
            tt-param.estabel-fim
            tt-param.emitente-ini
            tt-param.emitente-fim
            tt-param.dt-trans-ini
            tt-param.dt-trans-fim
            tt-param.awb
            tt-param.di
            tt-param.dt-emb-ent
            tt-param.fat-ci-swift
            tt-param.despesas
            tt-param.itinerario
            tt-param.narrativa-emb
            tt-param.transportador
            tt-param.peso-embarque
            tt-param.arquivo
            tt-param.usuario
            tt-param.arquivo-csv
            with frame f-impressao.            
    
    {include/i-rpclo.i}
end.

return "OK":U.

procedure pi-gera-csv:
    define variable dt-aux as date no-undo.
    
    if not valid-handle(h-acomp) then
        run utp/ut-acomp.p persistent set h-acomp.
        
    if valid-handle(h-acomp) then
        run pi-inicializar in h-acomp (input "Gerando dados da importa‡Æo...":U).
        
    do dt-aux = tt-param.dt-trans-ini to tt-param.dt-trans-fim:
            bk-docum-est:
            for each docum-est no-lock
                where docum-est.dt-trans    = dt-aux
                  and docum-est.cod-estabel >= tt-param.estabel-ini
                  and docum-est.cod-estabel <= tt-param.estabel-fim:
                  
                  if docum-est.cod-emitente < tt-param.emitente-ini or
                     docum-est.cod-emitente > tt-param.emitente-fim then
                      next bk-docum-est.
                  
                  if not docum-est.nat-operacao begins "3":U then
                      next bk-docum-est.         

                  IF  substring(docum-est.char-1, 1, 12) < tt-param.embarque-ini OR
                      substring(docum-est.char-1, 1, 12) > tt-param.embarque-fim
                  THEN
                      next bk-docum-est.
                      
                  find first embarque-imp no-lock
                       where embarque-imp.cod-estabel = docum-est.cod-estabel
                         and embarque-imp.embarque    = substring(docum-est.char-1, 1, 12) no-error.
                         
                  if not available embarque-imp then
                      next bk-docum-est.                     
                      
                  find first historico-embarque no-lock
                       where historico-embarque.cod-estabel = docum-est.cod-estabel
                         and historico-embarque.embarque    = embarque-imp.embarque no-error.
                         
                  if not available historico-embarque then
                      next bk-docum-est.                    
                      
                  find first itinerario no-lock
                       where itinerario.cod-itiner = historico-embarque.cod-itiner no-error.
                       
                  if not available itinerario then
                      next bk-docum-est.                 

                  find first historico-embarque no-lock
                       where historico-embarque.cod-estabel   = docum-est.cod-estabel
                         and historico-embarque.embarque      = embarque-imp.embarque
                         and historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-embarq no-error.

                  if not available historico-embarque then
                      next bk-docum-est.                      

                  find first bf-historico-embarque no-lock
                       where bf-historico-embarque.cod-estabel   = docum-est.cod-estabel
                         and bf-historico-embarque.embarque      = embarque-imp.embarque
                         and bf-historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-despch no-error.

                  if valid-handle(h-acomp) then
                      run pi-acompanhar in h-acomp (input "Embarque: ":U + trim(embarque-imp.embarque) + " - Entrada: ":U + string(docum-est.dt-trans, "99/99/99":U)).
                      
                  find first emitente no-lock
                       where emitente.cod-emitente = docum-est.cod-emitente no-error.
                      
                  find first emitente-cex no-lock
                       where emitente-cex.cod-emitente = docum-est.cod-emitente no-error.
                      
                  create tt-importacao.
                  assign tt-importacao.estabel     = docum-est.cod-estabel
                         tt-importacao.embarque    = embarque-imp.embarque
                         tt-importacao.nro-docto   = docum-est.nro-docto
                         tt-importacao.emitente    = docum-est.cod-emitente
                         tt-importacao.nome-abrev  = if available emitente then emitente.nome-abrev else "":U
                         tt-importacao.dt-entrada  = docum-est.dt-trans
                         tt-importacao.dt-despacho = IF AVAIL bf-historico-embarque THEN STRING(bf-historico-embarque.dt-efetiva,"99/99/9999") ELSE "":U.

                  FIND FIRST ordens-embarque 
                       WHERE ordens-embarque.cod-estabel = docum-est.cod-estabel
                         AND ordens-embarque.embarque    = embarque-imp.embarque NO-LOCK NO-ERROR.
                    
                  IF AVAIL ordens-embarque THEN DO:
                      FIND FIRST cotacao-item 
                           WHERE cotacao-item.numero-ordem = ordens-embarque.numero-ordem 
                             AND cotacao-item.cot-aprovada = YES NO-LOCK NO-ERROR.

                      IF AVAIL cotacao-item THEN DO:
                          FIND FIRST cond-pagto
                               WHERE cond-pagto.cod-cond-pag = cotacao-item.cod-cond-pag NO-LOCK NO-ERROR.

                          ASSIGN tt-importacao.cond-pagto   = STRING(cotacao-item.cod-cond-pag) + " - ":U + IF AVAIL cond-pagto THEN cond-pagto.descricao ELSE "":U.                                                                                                                                                                             
                      END.
                  END.

                  FIND FIRST dupli-apagar OF docum-est NO-LOCK NO-ERROR.
                  IF AVAIL dupli-apagar THEN
                      ASSIGN tt-importacao.dt-vencto = STRING(dupli-apagar.dt-vencim,"99/99/9999").

                  if tt-param.dt-emb-ent then
                     assign tt-importacao.dt-embarque = historico-embarque.dt-efetiva.                
                         
                  if tt-param.awb then
                     assign tt-importacao.awb = embarque-imp.cod-conhecto-master.
                     
                  if tt-param.di then
                     assign tt-importacao.di = embarque-imp.declaracao-imp.

                  IF tt-param.narrativa-emb THEN
                      ASSIGN tt-importacao.narrativa-emb = TRIM(REPLACE(REPLACE(REPLACE(SUBSTRING(embarque-imp.narrativa,1,100),CHR(10),""),CHR(13),""),";","-")).
                     
                  if tt-param.itinerario then
                     assign tt-importacao.itin-padrao = if available emitente-cex then emitente-cex.cod-itiner-imp else 0
                            tt-importacao.itin-utiliz = itinerario.cod-itiner.

                  IF tt-param.transportador THEN
                        ASSIGN tt-importacao.transportador = embarque-imp.cod-transportador.
            
                  IF tt-param.peso-embarque THEN DO:

                      /* Inicio Calculo Pesos */
                        ASSIGN d-peso-liquido   = 0
                               d-peso-bruto     = 0.

                        FOR EACH ordens-embarque 
                           WHERE ordens-embarque.cod-estabel = docum-est.cod-estabel
                             AND ordens-embarque.embarque = embarque-imp.embarque NO-LOCK:

                            FOR FIRST ordem-compra WHERE
                                ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK:

                                FOR FIRST ITEM WHERE
                                    ITEM.it-codigo = ordem-compra.it-codigo NO-LOCK:
                                
                                    IF ordens-embarque.peso-liquido = 0 THEN
                                        ASSIGN d-peso-liquido = d-peso-liquido + (ITEM.peso-liquido * ordens-embarque.quantidade).
                                    ELSE
                                        ASSIGN d-peso-liquido = d-peso-liquido + ordens-embarque.peso-liquido.
                            
                                    IF ordens-embarque.peso-bruto = 0 THEN
                                        ASSIGN d-peso-bruto = d-peso-bruto + (ITEM.peso-bruto * ordens-embarque.quantidade).
                                    ELSE
                                        ASSIGN d-peso-bruto = d-peso-bruto + ordens-embarque.peso-bruto.

                                END.
                            END.
                        END.

                        ASSIGN tt-importacao.peso-embarque-bruto   = d-peso-bruto
                               tt-importacao.peso-embarque-liquido = d-peso-liquido.

                  END.
                  /* Fim Calculo Pesos */
                    
                  if tt-param.fat-ci-swift OR tt-param.despesas then do:
                         assign l-pri-fat = yes.

                         IF tt-param.fat-ci-swift THEN DO:
                             for each invoice-emb-imp no-lock
                                 where invoice-emb-imp.cod-estabel = embarque-imp.cod-estabel
                                   and invoice-emb-imp.embarque    = embarque-imp.embarque:
                                   
                                   if l-pri-fat then
                                      assign l-pri-fat = no.
                                   else do:
                                      create tt-importacao.
                                      assign tt-importacao.estabel    = docum-est.cod-estabel
                                             tt-importacao.embarque   = embarque-imp.embarque
                                             tt-importacao.nro-docto  = docum-est.nro-docto
                                             tt-importacao.emitente   = docum-est.cod-emitente
                                             tt-importacao.nome-abrev = if available emitente then emitente.nome-abrev else "":U
                                             tt-importacao.dt-entrada = docum-est.dt-trans.
                                             
                                      if tt-param.dt-emb-ent then
                                         assign tt-importacao.dt-embarque = historico-embarque.dt-efetiva.
                                             
                                      if tt-param.awb then
                                         assign tt-importacao.awb = embarque-imp.cod-conhecto-master.
                                      
                                      if tt-param.di then
                                         assign tt-importacao.di = embarque-imp.declaracao-imp.
                                      
                                      IF tt-param.narrativa-emb THEN
                                          ASSIGN tt-importacao.narrativa-emb = TRIM(REPLACE(REPLACE(REPLACE(SUBSTRING(embarque-imp.narrativa,1,100),CHR(10),""),CHR(13),""),";","-")).
    
                                      if tt-param.itinerario then
                                         assign tt-importacao.itin-padrao = if available emitente-cex then emitente-cex.cod-itiner-imp else 0
                                                tt-importacao.itin-utiliz = itinerario.cod-itiner.
                                                                           
                                   end.
                                   
                                   assign tt-importacao.fat-ou-desp  = "Fatura":U
                                          tt-importacao.fat-desp     = invoice-emb-imp.nr-invoice
                                          tt-importacao.parc-desc    = invoice-emb-imp.parcela
                                          tt-importacao.vlr-fat-desp = invoice-emb-imp.vl-invoice.
    
                                   find first moeda
                                       where moeda.mo-codigo = invoice-emb-imp.mo-codigo no-lock no-error.
    
                                   if available moeda then
                                       assign tt-importacao.des-moeda = moeda.descricao.

                                   for first pagamento-invoice no-lock
                                       where pagamento-invoice.embarque   = invoice-emb-imp.embarque
                                         and pagamento-invoice.nr-invoice = invoice-emb-imp.nr-invoice
                                         and pagamento-invoice.parcela    = invoice-emb-imp.parcela:
                                         
                                         assign tt-importacao.ci = pagamento-invoice.nr-pagamento.
                                         
                                         find first pagamento no-lock
                                              where pagamento.nr-pag = pagamento-invoice.nr-pagamento no-error.
                                              
                                         if available pagamento then
                                             assign tt-importacao.swift = TRIM(REPLACE(REPLACE(REPLACE(pagamento.swift,CHR(10),""),CHR(13),""),";","-")).
                                   end.        

                                   IF AVAIL cotacao-item THEN
                                       ASSIGN tt-importacao.cond-pagto   = STRING(cotacao-item.cod-cond-pag) + " - ":U + IF AVAIL cond-pagto THEN cond-pagto.descricao ELSE "":U.                                                                                                                                                                            
                                   IF AVAIL dupli-apagar THEN
                                       ASSIGN tt-importacao.dt-vencto = STRING(dupli-apagar.dt-vencim,"99/99/9999").                                   
                                   IF AVAIL bf-historico-embarque THEN
                                       ASSIGN tt-importacao.dt-despacho =  STRING(bf-historico-embarque.dt-efetiva,"99/99/9999").
                             end.
                         END.

                         IF  tt-param.despesas THEN DO:
                             FOR EACH desp-embarque OF embarque-imp NO-LOCK:
                                 

                                 if l-pri-fat then
                                     assign l-pri-fat = no.
                                 ELSE DO:
                                     create tt-importacao.
                                     assign tt-importacao.estabel           = docum-est.cod-estabel
                                            tt-importacao.embarque          = embarque-imp.embarque
                                            tt-importacao.nro-docto         = docum-est.nro-docto
                                            tt-importacao.emitente          = docum-est.cod-emitente
                                            tt-importacao.nome-abrev        = if available emitente then emitente.nome-abrev else "":U
                                            tt-importacao.dt-entrada        = docum-est.dt-trans.
                                            
                                                
                                     if tt-param.dt-emb-ent then
                                         assign tt-importacao.dt-embarque = historico-embarque.dt-efetiva.
                                         
                                     if tt-param.awb then
                                         assign tt-importacao.awb = embarque-imp.cod-conhecto-master.
                                     
                                     if tt-param.di then
                                         assign tt-importacao.di = embarque-imp.declaracao-imp.
                                         
                                     IF tt-param.narrativa-emb THEN
                                         ASSIGN tt-importacao.narrativa-emb = TRIM(REPLACE(REPLACE(REPLACE(SUBSTRING(embarque-imp.narrativa,1,100),CHR(10),""),CHR(13),""),";","-")).
                                         
                                     if tt-param.itinerario then
                                         assign tt-importacao.itin-padrao = if available emitente-cex then emitente-cex.cod-itiner-imp else 0
                                                tt-importacao.itin-utiliz = itinerario.cod-itiner.
                                 END.
    
                                 FIND FIRST desp-imp OF desp-embarque NO-LOCK NO-ERROR.
    
                                 FIND FIRST moeda WHERE moeda.mo-codigo = desp-embarque.mo-codigo NO-LOCK NO-ERROR.
    
                                 ASSIGN tt-importacao.fat-ou-desp       = "Despesa":U
                                        tt-importacao.fat-desp          = STRING(desp-embarque.cod-desp, ">>,>>9":U)
                                        tt-importacao.parc-desc         = IF AVAILABLE desp-imp THEN desp-imp.descricao ELSE "":U
                                        tt-importacao.vlr-fat-desp      = desp-embarque.val-desp
                                        tt-importacao.des-moeda         = IF AVAILABLE moeda THEN moeda.descricao ELSE "":U
                                        tt-importacao.cod-cond-pag      = desp-embarque.cod-cond-pag    
                                        tt-importacao.cod-emitente-desp = desp-embarque.cod-emitente    .
                             END.
                         END.

                  end. /* if tt-param.fat-ci-swift then do: */
            end.
    end.
    
    if can-find(first tt-importacao) then do:
    
        if valid-handle(h-acomp) then
            run pi-acompanhar in h-acomp (input "Imprimindo arquivo de importa‡Æo...":U).
            
        output to value(tt-param.arquivo-csv) convert target session:charset.
        
        put unformatted "Estabelecimento;Embarque;Nota Fiscal;Emitente;Nome Emitente;Data Entrada;":U.
        
        if tt-param.dt-emb-ent then
            put unformatted "Data Embarque;":U.

        put unformatted "Data Despacho;Data Vencto;Cond. Pagto;":U.

        if tt-param.awb then
            put unformatted "AWB;":U.
        
        if tt-param.di then
            put unformatted "DI;":U.
            
        if tt-param.itinerario then
            put unformatted "Itiner rio PadrÆo;Itiner rio Utilizado;":U.
            
        if tt-param.fat-ci-swift OR tt-param.despesas then
            put unformatted "Fatura ou Despesa?;Fatura/Despesa;Parcela/Descri‡Æo;Fornec Desp;CondPgt;Valor Fatura/Despesa;Moeda;":U.

        IF tt-param.fat-ci-swift THEN
            put unformatted "CI;Swift;":U.

        IF tt-param.narrativa-emb THEN
            PUT UNFORMATTED "Narrativa Embarque;":U.

        IF tt-param.transportador THEN
            PUT UNFORMATTED "Transportador;":U.

        IF tt-param.peso-embarque THEN
            PUT UNFORMATTED "Peso Embarque Bruto;Peso Embarque L¡quido;":U.
            
        put unformatted skip.
        
        RUN inbo/boin090a.p persistent set h-boin090a.
        for each tt-importacao
            BREAK BY tt-importacao.estabel
                  BY tt-importacao.embarque:
            put unformatted
                tt-importacao.estabel    ";":U
                tt-importacao.embarque   ";":U
                tt-importacao.nro-docto  ";":U
                tt-importacao.emitente   ";":U
                tt-importacao.nome-abrev ";":U
                tt-importacao.dt-entrada ";":U.
                
            if tt-param.dt-emb-ent then
                put unformatted tt-importacao.dt-embarque ";":U.

            put unformatted tt-importacao.dt-despacho ";":U
                            tt-importacao.dt-vencto   ";":U
                            tt-importacao.cond-pagto  ";":U.
            
            if tt-param.awb then
                put unformatted tt-importacao.awb ";":U.
            
            if tt-param.di then
                put unformatted tt-importacao.di ";":U.
                
            if tt-param.itinerario then
                put unformatted tt-importacao.itin-padrao ";":U
                                tt-importacao.itin-utiliz ";":U.
            
            if tt-param.fat-ci-swift OR tt-param.despesas then
                put unformatted
                    tt-importacao.fat-ou-desp       ";":U
                    tt-importacao.fat-desp          ";":U
                    tt-importacao.parc-desc         ";":U
                    tt-importacao.cod-emitente-desp ";":U
                    tt-importacao.cod-cond-pag      ";":U
                    tt-importacao.vlr-fat-desp      ";":U
                    tt-importacao.des-moeda         ";":U.

            IF tt-param.fat-ci-swift THEN
                put unformatted
                    tt-importacao.ci    ";":U
                    tt-importacao.swift ";":U.

            IF tt-param.narrativa-emb THEN
                PUT tt-importacao.narrativa-emb ";":U.

            IF tt-param.transportador THEN
                PUT unformatted
                   tt-importacao.transportador ";":U.
    
            IF tt-param.peso-embarque THEN
                PUT unformatted
                    STRING(tt-importacao.peso-embarque-bruto,">>>,>>9.99999")   ";":U
                    STRING(tt-importacao.peso-embarque-liquido,">>>,>>9.99999") ";":U.
                    
            put unformatted skip.            

            IF  LAST-OF(tt-importacao.embarque) THEN DO:
                RUN pi-retorna-documentos in h-boin090a (INPUT tt-importacao.estabel,
                                                         INPUT tt-importacao.embarque,
                                                         OUTPUT TABLE tt-documentos,
                                                         OUTPUT TABLE RowErrors).

                FOR EACH tt-documentos:
                
                    IF  fnTipoDocumento(tt-documentos.idi-nf-simples-remes , tt-documentos.nat-operacao) = "Nota Complementar" THEN DO:
    
                        FIND FIRST emitente NO-LOCK
                             WHERE emitente.cod-emitente = tt-documentos.cod-emitente NO-ERROR.
    
                        FIND FIRST docum-est NO-LOCK
                             WHERE docum-est.nro-docto    = tt-documentos.nro-docto
                               AND docum-est.serie-docto  = tt-documentos.serie-docto
                               AND docum-est.cod-emitente = tt-documentos.cod-emitente
                               AND docum-est.nat-operacao = tt-documentos.nat-operacao NO-ERROR.
    
                        FIND FIRST ITEM NO-LOCK
                             WHERE ITEM.it-codigo = SUBSTRING(docum-est.char-1,176,16) NO-ERROR.
    
                        IF AVAIL ITEM THEN
                            ASSIGN c-desc-item = ITEM.desc-item.
                        ELSE
                            ASSIGN c-desc-item = "".
    
                        PUT UNFORMATTED tt-importacao.estabel      ";":U
                                        tt-importacao.embarque     ";":U
                                        tt-documentos.nro-docto    ";":U
                                        tt-documentos.cod-emitente ";":U
                                        emitente.nome-abrev        ";":U.
    
                        if tt-param.dt-emb-ent then
                            put unformatted ";":U.
    
                        put unformatted ";":U
                                        ";":U
                                        ";":U
                                        ";":U.
                        
                        if tt-param.awb then
                            put unformatted "Lan‡amento Fiscal;":U.
                        
                        if tt-param.di then
                            put unformatted ";":U.
                            
                        if tt-param.itinerario then
                            put unformatted ";":U
                                            ";":U.
    
                        if tt-param.fat-ci-swift OR tt-param.despesas then
                            put UNFORMATTED ";":U
                                            SUBSTRING(docum-est.char-1,176,16) ";":U
                                            c-desc-item                        ";":U
                                            tt-documentos.cod-emitente         ";":U
                                            ";":U
                                            docum-est.tot-valor                ";":U.
    
                        put unformatted skip.
    
                    END.
                END.
            END.
        end.
        output close.
        
    end.
    else
        assign tt-param.arquivo-csv = "NÆo foram encontradas informa‡äes para o estabelecimento ou per¡odo.":U.
    
    if valid-handle(h-acomp) then
        run pi-finalizar in h-acomp.
        
    if valid-handle(h-acomp) then
        delete object h-acomp.
        
end procedure.

FUNCTION fnTipoDocumento RETURNS CHARACTER
  ( pidi-nf-simples-remes  AS INT,
    pnat-operacao AS CHAR):

    IF pidi-nf-simples-remes = 1 THEN DO: /* "nota m’e" */
        {utp/ut-liter.i "Nota_MÆe"}
    END.
    ELSE IF pidi-nf-simples-remes = 2 THEN DO: /* nota filha */
         {utp/ut-liter.i "Nota_Filha"}
    END.
    ELSE DO:
        IF CAN-FIND(FIRST natur-oper
                    WHERE natur-oper.nat-operacao = pnat-operacao
                      AND natur-oper.nota-rateio) THEN DO:
            {utp/ut-liter.i "Nota_Complementar"}
        END.
        ELSE DO:
            {utp/ut-liter.i "Nota_Normal"}
        END.
    END.

    RETURN RETURN-VALUE.
END FUNCTION.
