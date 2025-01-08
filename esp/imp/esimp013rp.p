/*:T***************************************************************************
**  Programa.: esp/imp/esimp013rp.p
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i esimp013rp 1.00.00.000}

{esp/imp/esimp013.i}
{utp/ut-glob.i}
{include/i-rpvar.i}

define input parameter raw-param as raw no-undo.
define input parameter table for tt-raw-digita.

define variable h-acomp   as handle  no-undo.

DEFINE NEW GLOBAL SHARED VARIABLE I-Num-Ped-Exec-Rpw      AS INTEGER   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE C-Dir-Spool-Servid-Exec AS CHARACTER NO-UNDO.

define temp-table tt-importacao no-undo
    field estabel            like docum-est.cod-estabel
    field dt-entrada         like docum-est.dt-trans
    field dt-embarque        like historico-embarque.dt-efetiva
    field embarque           like embarque-imp.embarque
    field di                 like embarque-imp.declaracao-imp
    field agente             like transporte.nome
    field NIF                like emitente.cgc
    field endereco-agente    AS   CHARACTER FORMAT 'x(200)':U
    field pais-agente        like transporte.pais
    field modal              AS   CHARACTER FORMAT "x(40)":U
    field cod-conhecto-house like embarque-imp.cod-conhecto-house
    field cod-emitente-desp  like desp-embarque.cod-emitente
    field nome-emitente-desp like emitente.nome-abrev
    field cnpj-emitente-desp like emitente.cgc
    field dt-pagto           like historico-embarque.dt-efetiva
    field fat-ou-desp        AS   CHARACTER FORMAT 'X(20)':U
    field fat-desp           like invoice-emb-imp.nr-invoice
    field parc-desc          like invoice-emb-imp.parcela
    field vlr-fat-desp       like invoice-emb-imp.vl-invoice
    field des-moeda          like moeda.descricao.

create tt-param.
raw-transfer raw-param to tt-param.

find first tt-param no-error.

find first param-global no-lock no-error.
find first empresa no-lock
    where empresa.ep-codigo = param-global.empresa-pri.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Relat¢rio Importa‡Æo":U
       c-empresa      = if available empresa then empresa.razao-social else "":U
       c-programa     = "esimp013":U
       c-versao       = "1.00":U
       c-revisao      = "000":U.


IF  i-num-ped-exec-rpw <> 0 
THEN DO:
    IF  tt-param.arquivo = "" THEN assign tt-param.arquivo = c-programa + ".lst":U.
    ASSIGN tt-param.arquivo-csv = replace(tt-param.arquivo, entry(num-entries(tt-param.arquivo, ".":U), tt-param.arquivo, ".":U), "csv":U).
END.
ELSE DO:
    assign tt-param.arquivo-csv = replace(tt-param.arquivo, entry(num-entries(tt-param.arquivo, ".":U), tt-param.arquivo, ".":U), "csv":U).
END.


form skip(1)
     "SELE€ÇO":U  at 13 skip(1)
     tt-param.estabel-ini   format "x(03)":U      label "Estabelecimento":U colon 40 
     " |< >| ":U at 54
     tt-param.estabel-fim   format "x(03)":U      no-label skip
     tt-param.dt-trans-ini  format "99/99/9999":U label "Data Transa‡Æo":U  colon 40
     " |< >| ":U at 54
     tt-param.dt-trans-fim  format "99/99/9999":U no-label skip
     tt-param.embarque-ini  format "X(12)":U      label "Embarque":U        colon 40
     " |< >| ":U at 54
     tt-param.embarque-fim  format "X(12)":U      no-label skip(1)
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
            tt-param.dt-trans-ini
            tt-param.dt-trans-fim
            tt-param.embarque-ini
            tt-param.embarque-fim
            tt-param.arquivo
            tt-param.usuario
            tt-param.arquivo-csv
            with frame f-impressao.            
    
    {include/i-rpclo.i}
end.

return "OK":U.

procedure pi-gera-csv:

    define variable dt-aux as date no-undo.
    
    if not valid-handle(h-acomp) then run utp/ut-acomp.p persistent set h-acomp.
    if     valid-handle(h-acomp) then run pi-inicializar in h-acomp (input "Gerando dados da importa‡Æo...":U).
            
    blk_principal:
    FOR EACH  embarque-imp NO-LOCK
        WHERE embarque-imp.cod-estabel >= tt-param.estabel-ini
        AND   embarque-imp.cod-estabel <= tt-param.estabel-fim
        AND   embarque-imp.embarque    >= ""
        AND   embarque-imp.embarque    <= "ZZZZZZZZZZZZ":
    
        FOR FIRST historico-embarque NO-LOCK
            WHERE historico-embarque.cod-estabel = embarque-imp.cod-estabel
            AND   historico-embarque.embarque    = embarque-imp.embarque
            AND   historico-embarque.dt-efetiva >= tt-param.dt-trans-ini
            AND   historico-embarque.dt-efetiva <= tt-param.dt-trans-fim:

            FIND FIRST itinerario NO-LOCK
                WHERE  itinerario.cod-itiner = historico-embarque.cod-itiner NO-ERROR.
            IF NOT AVAIL itinerario THEN NEXT blk_principal.

        END.
        IF  NOT AVAIL historico-embarque THEN NEXT blk_principal.
        
        FOR LAST  historico-embarque NO-LOCK
            WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel
            AND   historico-embarque.embarque      = embarque-imp.embarque
            AND   historico-embarque.cod-pto-contr = itinerario.pto-embarque
            AND   historico-embarque.dt-efetiva   >= tt-param.dt-trans-ini
            AND   historico-embarque.dt-efetiva   <= tt-param.dt-trans-fim:
        
            for FIRST docum-est no-lock
                where docum-est.cod-estabel              = historico-embarque.cod-estabel
                AND   substring(docum-est.char-1, 1, 12) = historico-embarque.embarque:
            
                if not docum-est.nat-operacao begins "3":U then next blk_principal.         
                
                if valid-handle(h-acomp) then run pi-acompanhar in h-acomp (input "Embarque: ":U + trim(embarque-imp.embarque) + 
                                                                                  " - Entrada: ":U + string(docum-est.dt-trans, "99/99/99":U)).
            
                find first emitente no-lock
                     where emitente.cod-emitente = docum-est.cod-emitente no-error.
                    
                find first emitente-cex no-lock
                     where emitente-cex.cod-emitente = docum-est.cod-emitente no-error.
                
                /*---[ Despesa ]-------------------------------------------------------------*/
                IF  NOT CAN-FIND(FIRST desp-embarque OF embarque-imp) THEN NEXT blk_principal.
                
                despesas_blk:
                FOR EACH desp-embarque OF embarque-imp NO-LOCK:
                
                    if valid-handle(h-acomp) then run pi-acompanhar in h-acomp (input "Despesas Embarque: ":U + string(desp-embarque.cod-desp)).
    
                    FIND FIRST desp-imp OF desp-embarque NO-LOCK NO-ERROR.
                    IF  NOT AVAIL desp-imp 
                    OR  (AVAIL desp-imp AND NOT desp-imp.inc-val-frete) THEN NEXT despesas_blk.
                   
                    IF  NOT CAN-FIND(FIRST tt-importacao
                                     WHERE tt-importacao.estabel      = docum-est.cod-estabel          
                                     AND   tt-importacao.embarque     = embarque-imp.embarque          
                                     AND   tt-importacao.dt-entrada   = docum-est.dt-trans             
                                     AND   tt-importacao.dt-embarque  = historico-embarque.dt-efetiva) THEN DO:
                    
                        create tt-importacao.
                        assign tt-importacao.estabel            = docum-est.cod-estabel
                               tt-importacao.embarque           = embarque-imp.embarque
                               tt-importacao.dt-entrada         = docum-est.dt-trans
                               tt-importacao.dt-embarque        = historico-embarque.dt-efetiva
                               tt-importacao.cod-conhecto-house = embarque-imp.cod-conhecto-house
                               tt-importacao.di                 = embarque-imp.declaracao-imp.
                        
                        FIND FIRST transporte NO-LOCK
                            WHERE  transporte.cod-transp = embarque-imp.cod-transportador NO-ERROR.
                        IF  AVAIL  transporte THEN DO:
                            ASSIGN tt-importacao.agente          = transporte.nome
                                   tt-importacao.endereco-agente = transporte.endereco + FILL(" ",1) +
                                                                   transporte.bairro   + FILL(" ",1) +
                                                                   transporte.cep      + FILL(" ",1) +
                                                                   transporte.cidade
                                   tt-importacao.pais-agente     = transporte.pais
                                   tt-importacao.modal           = {adinc/i01ad268.i 04 embarque-imp.cod-via-transp}
                                   tt-importacao.NIF             = transporte.cgc.
                        END. /* IF  AVAIL  transporte THEN DO: */
                        
                        FIND FIRST moeda WHERE moeda.mo-codigo = desp-embarque.mo-codigo NO-LOCK NO-ERROR.
                        
                        ASSIGN tt-importacao.fat-ou-desp       = "Despesa":U
                               tt-importacao.fat-desp          = STRING(desp-embarque.cod-desp, ">>,>>9":U)
                               tt-importacao.parc-desc         = IF AVAILABLE desp-imp THEN desp-imp.descricao ELSE "":U
                               tt-importacao.vlr-fat-desp      = desp-embarque.val-desp
                               tt-importacao.cod-emitente-desp = desp-embarque.cod-emitente
                               tt-importacao.des-moeda         = IF AVAILABLE moeda THEN moeda.descricao ELSE "":U.
                        
                        FIND FIRST emitente NO-LOCK
                            WHERE  emitente.cod-emitente = tt-importacao.cod-emitente-desp NO-ERROR.
                        IF  AVAIL  emitente
                        THEN ASSIGN tt-importacao.nome-emitente-desp = emitente.nome-abrev
                                    tt-importacao.cnpj-emitente-desp = emitente.cgc.
                        
                        FOR LAST  tit_ap NO-LOCK
                            WHERE tit_ap.cod_estab      = embarque-imp.cod-estabel
                            AND   tit_ap.cdn_fornecedor = desp-embarque.cod-emitente
                            AND   tit_ap.cod_tit_ap     = embarque-imp.embarque
                            AND   tit_ap.val_sdo_tit_ap <= 0:
                        
                            ASSIGN tt-importacao.dt-pagto = tit_ap.dat_liquidac_tit_ap.
                        END. /* FOR LAST  tit_ap NO-LOCK */
                    END. /* IF  NOT CAN-FIND(FIRST tt-importacao */
                END. /* FOR EACH desp-embarque OF embarque-imp NO-LOCK: */
            END.
        END. /* for first docum-est ...*/
    end. /* for each docum-est no-lock */

    if can-find(first tt-importacao) then do:
    
        if valid-handle(h-acomp) then run pi-acompanhar in h-acomp (input "Imprimindo arquivo de importa‡Æo...":U).
            
        IF  i-num-ped-exec-rpw <> 0 
        THEN output to value(c-dir-spool-servid-exec + "/":U + tt-param.arquivo-csv) convert target session:charset.
        ELSE output to value(tt-param.arquivo-csv) convert target session:charset.

        put unformatted "Estab;Data Entrada;Data Embarque;Embarque;DI;Agente;NIF;Endere‡o Agente;Pa¡s;Vlr Frete;Modal;Conhecimento House;Cod Fornec Despesa;Fornec Despesa;CNPJ Fornec Despesa;Data Pagto;Moeda;Desc.Despesa":U SKIP.
        
        for each tt-importacao:
            put unformatted
                tt-importacao.estabel            ";":U
                tt-importacao.dt-entrada         ";":U
                tt-importacao.dt-embarque        ";":U 
                tt-importacao.embarque           ";":U 
                tt-importacao.di                 ";":U 
                tt-importacao.agente             ";":U
                tt-importacao.NIF                ";":U
                tt-importacao.endereco-agente    ";":U 
                tt-importacao.pais-agente        ";":U 
                tt-importacao.vlr-fat-desp       ";":U 
                tt-importacao.modal              ";":U 
                tt-importacao.cod-conhecto-house ";":U 
                tt-importacao.cod-emitente-desp  ";":U 
                tt-importacao.nome-emitente-desp ";":U
                tt-importacao.cnpj-emitente-desp ";":U
                tt-importacao.dt-pagto           ";":U
                tt-importacao.des-moeda          ";":U
                tt-importacao.parc-desc          ";":U skip.            
        end.
        output close.
        
    end.
    else
        assign tt-param.arquivo-csv = "NÆo foram encontradas informa‡äes para o estabelecimento ou per¡odo.":U.
    
    if valid-handle(h-acomp) then run pi-finalizar in h-acomp.
    
end procedure.
