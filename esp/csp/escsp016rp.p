/******************************************************************************
* Programa .....: escsp016rp.p                                                *
* Data .........: 10 de agosto de 2022                                        *
* Empresa ......: Jeferson Consulting                                         *
* Cliente ......: Intelbras                                                   *
* Programador ..: Jeferson Souza                                              *
* Objetivo .....: Recalculo horas reportadas                                  *
* RevisÑes .....: 001 - 10/08/2022 - JS - Criaªío                             *  
******************************************************************************/

using OpenEdge.Net.HTTP.*.
using OpenEdge.Net.URI.
using progress.Json.ObjectModel.ObjectModelParser.
using progress.Json.*.
using progress.Json.ObjectModel.*.

{include/i-prgvrs.i ESCSP016rp 12.01.34.000}  
{utp/ut-glob.i}
{cdp/cd0666.i}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
        {include/i-license-manager.i ESCSP016 MCD}
&ENDIF

// Temporarias
define temp-table tt-param no-undo
    field destino            as integer
    field arquivo            as char format "x(35)"
    field usuario            as char format "x(12)"
    field data-exec          as date
    field hora-exec          as integer
    field classifica         as integer
    field desc-classifica    as char format "x(40)"
    field modelo-rtf         as char format "x(35)"
    field l-habilitaRtf      as LOG
    field dt-per-ini         as date
    field dt-per-fim         as date
    field opcao              as int
    field lg-detalha-calc    as log.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id ordem.

define temp-table tt-raw-digita
    field raw-digita as raw.

def temp-table tt-grup-maquina-uep
    field gm-codigo             like grup-maquina.gm-codigo
    field dt-atualizacao        as date
    field de-indice-uepH        as dec
    index ch-codigo gm-codigo.

def temp-table tt-ferr-prod-uep
    field cod-ferr-prod         like ferr-prod.cod-ferr-prod
    field dt-atualizacao        as date
    field de-indice-uepH        as dec
    index ch-codigo cod-ferr-prod.

def temp-table tt-grup-maquina
    field gm-codigo             like grup-maquina.gm-codigo
    field tot-horas-report      as dec
    field tot-horas-report-new  as dec
    index ch-codigo gm-codigo.

def temp-table tt-detalhe-grup-maquina-uep
    field gm-codigo             like grup-maquina.gm-codigo    
    field nr-ord-prod           like ord-prod.nr-ord-prod
    field it-codigo             like item.it-codigo
    field ferramenta            like oper-ord.ferramenta
    field horas-report          as dec
    field horas-report-new      as dec
    field tipo-trans            as int
    field c-tipo-trans          as char
    index ch-codigo gm-codigo.

def temp-table tt-rep-cc
    field cod-estabel           like movto-ggf.cod-estabel
    field cc-codigo             like movto-ggf.cc-codigo
    field horas-report          as dec
    field de-indice-uepH        as dec
    index ch-codigo cod-estabel
                    cc-codigo.

// Buffer
def buffer b-tt-grup-maquina-uep for tt-grup-maquina-uep.
def buffer b-tt-ferr-prod-uep    for tt-ferr-prod-uep.
def buffer b-movto-ggf           for movto-ggf.

// Vari†veis
def var dt-aux                  as date                                     no-undo.
def var de-perc                 as dec                                      no-undo.
def var de-horas-report-new     as dec                                      no-undo.
def var h-acomp                 as handle                                   no-undo.
def var chExcel                 as office.iface.excel.ExcelWrapper          no-undo.
def var chWorkBook              as office.iface.excel.Workbook              no-undo.
def var chWorkSheet             as office.iface.excel.WorkSheet             no-undo.
def var chRange                 as office.iface.excel.Range                 no-undo.
def var lg-retorna-horas        as log                                      no-undo.
def var de-indice-uepH-ferr     like tt-ferr-prod-uep.de-indice-uepH        no-undo.
def var de-indice-uepH-tot      like tt-ferr-prod-uep.de-indice-uepH        no-undo.

// Forms
form tt-grup-maquina.gm-codigo
     grup-maquina.descricao
     tt-grup-maquina.tot-horas-report             column-label "Hr.Report."
     tt-grup-maquina-uep.de-indice-uepH           column-label "UEP/H"    
     tt-grup-maquina.tot-horas-report-new         column-label "Hr.Recalc."
     with stream-io no-box down width 132 frame f-gm-maq.

form tt-detalhe-grup-maquina-uep.nr-ord-prod     
     tt-detalhe-grup-maquina-uep.it-codigo
     item.desc-item                         
     tt-detalhe-grup-maquina-uep.ferramenta      
     tt-detalhe-grup-maquina-uep.c-tipo-trans     column-label "Tp.Trans"
     tt-detalhe-grup-maquina-uep.horas-report     column-label "Hr.Movto."
     tt-ferr-prod-uep.de-indice-uepH              column-label "UEP/H"     
     tt-detalhe-grup-maquina-uep.horas-report-new column-label "Hr.Recalc."
     with stream-io no-box down width 132 frame f-det-gm-maq.

// Parametros
define input parameter raw-param as raw no-undo.
define input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

//{office/office.i Excel chExcel}
{include/i-rpvar.i}

find first param-global 
           no-lock no-error.

find first mguni.empresa 
     where empresa.ep-codigo = param-global.empresa-prin 
           no-lock no-error.

assign c-programa     = "ESCSP016"
       c-versao	      = "12.01.34"
       c-revisao	  = ".000"
       c-empresa      = empresa.nome   
       c-sistema	  = "MCS"
       c-titulo-relat = "Rec†lculo Horas Reportadas".

{include/i-rpout.i}
{include/i-rpcab.i}

view frame f-cabec.
view frame f-rodape.

if tt-param.opcao = 3 // Retorna horas
then do:

    run utp/ut-acomp.p persistent set h-acomp.
    run pi-inicializar in h-acomp (input "Retornando Movimentos...").

    do dt-aux = tt-param.dt-per-ini to tt-param.dt-per-fim:

        run pi-acompanhar IN h-acomp ("Data: " + string(dt-aux)).
    
        for each movto-ggf use-index data where
                 movto-ggf.dt-trans    = dt-aux
                 no-lock:
            
            // Se existe extens∆o Ç porque j† foi calculado e atualizado, logo precisa voltar as horas...
            find first es-movto-ggf
                 where es-movto-ggf.num-id-movto-ggf = movto-ggf.num-id-movto-ggf
                       no-lock no-error.
    
            if avail es-movto-ggf 
            then do:
                find current movto-ggf exclusive-lock no-error.
    
                assign movto-ggf.horas-report = es-movto-ggf.horas-report-orig
                       lg-retorna-horas       = yes.
    
                find current movto-ggf no-lock no-error.
            end.
        end.
    end.
    
    if lg-retorna-horas
    then put unformat
            "As horas originais dos movimentos foram retornadas."           at 10
            skip(1).
    else put unformat
            "N∆o foram encontrados movimentos com horas recalculadas."      at 10
            skip(1).
end.
else do:
    // Chama Serviáo para retorno dos °ndices por GM
    run pi-busca-gm-UEP.

    // Deixa apenas o registro da £ltima data
    for each b-tt-grup-maquina-uep
             break by b-tt-grup-maquina-uep.gm-codigo
                   by b-tt-grup-maquina-uep.dt-atualizacao:

        if last-of (b-tt-grup-maquina-uep.gm-codigo) 
        then do:
            for each tt-grup-maquina-uep where
                     tt-grup-maquina-uep.gm-codigo  = b-tt-grup-maquina-uep.gm-codigo
                 and rowid(tt-grup-maquina-uep)    <> rowid(b-tt-grup-maquina-uep):

                delete tt-grup-maquina-uep.
            end.
        end.
    end.

    // Deixa apenas o registro da £ltima data
    for each b-tt-ferr-prod-uep
             break by b-tt-ferr-prod-uep.cod-ferr-prod
                   by b-tt-ferr-prod-uep.dt-atualizacao:

        if last-of (b-tt-ferr-prod-uep.cod-ferr-prod) 
        then do:
            for each tt-ferr-prod-uep where
                     tt-ferr-prod-uep.cod-ferr-prod  = b-tt-ferr-prod-uep.cod-ferr-prod
                 and rowid(tt-ferr-prod-uep)    <> rowid(b-tt-ferr-prod-uep):

                delete tt-ferr-prod-uep.
            end.
        end.
    end.
    
    if tt-param.opcao = 2 // Atualiza horas 
    then do:
        for each tt-grup-maquina-uep
                 no-lock:
    
            find first grup-maquina
                 where grup-maquina.gm-codigo = tt-grup-maquina-uep.gm-codigo
                       exclusive-lock no-error.
    
            if avail grup-maquina 
            then assign grup-maquina.nr-up-hora = tt-grup-maquina-uep.de-indice-uepH.
    
            release grup-maquina.
        end.

        for each tt-ferr-prod-uep
                 no-lock:

            find first es-ferr-prod
                 where es-ferr-prod.cod-ferr-prod = tt-ferr-prod-uep.cod-ferr-prod
                       exclusive-lock no-error.

            if not avail es-ferr-prod 
            then do:
                create es-ferr-prod.
                assign es-ferr-prod.cod-ferr-prod = tt-ferr-prod-uep.cod-ferr-prod.
            end.

            assign es-ferr-prod.nr-up-hora = tt-ferr-prod-uep.de-indice-uepH.

            release es-ferr-prod.
        end.
    end.

    run utp/ut-acomp.p persistent set h-acomp.
    run pi-inicializar in h-acomp (input "Lendo Movimentos...").
    
    do dt-aux = tt-param.dt-per-ini to tt-param.dt-per-fim:
    
        run pi-acompanhar IN h-acomp ("Data: " + string(dt-aux)).
    
        for each movto-ggf use-index data where
                 movto-ggf.dt-trans    = dt-aux
                 no-lock,
           first tt-grup-maquina-uep where
                 tt-grup-maquina-uep.gm-codigo = movto-ggf.gm-codigo
                 no-lock:

            find first tt-grup-maquina
                 where tt-grup-maquina.gm-codigo = movto-ggf.gm-codigo
                       no-error.

            if not avail tt-grup-maquina 
            then do:
                create tt-grup-maquina.
                assign tt-grup-maquina.gm-codigo = movto-ggf.gm-codigo.
            end.
            
            // Se existe extens∆o Ç porque j† foi calculado e atualizado, logo precisa voltar as horas...
            find first es-movto-ggf
                 where es-movto-ggf.num-id-movto-ggf = movto-ggf.num-id-movto-ggf
                       no-lock no-error.
    
            if avail es-movto-ggf 
            then do:
                find current movto-ggf exclusive-lock no-error.
    
                assign movto-ggf.horas-report = es-movto-ggf.horas-report-orig.
    
                find current movto-ggf no-lock no-error.
            end.

            if movto-ggf.tipo-trans = 1 // 1 - Reporte | 2 - Estorno
            then assign tt-grup-maquina.tot-horas-report = tt-grup-maquina.tot-horas-report + movto-ggf.horas-report.
            else assign tt-grup-maquina.tot-horas-report = tt-grup-maquina.tot-horas-report - movto-ggf.horas-report.

            release oper-ord.
            
            assign de-indice-uepH-ferr = 0.
            
            // Busca operacao da ordem
            find first oper-ord
                 where oper-ord.nr-ord-produ = movto-ggf.nr-ord-produ
                   and oper-ord.it-codigo    = movto-ggf.it-codigo   
                   and oper-ord.cod-roteiro  = movto-ggf.cod-roteiro 
                   and oper-ord.op-codigo    = movto-ggf.op-codigo   
                       no-lock no-error.
            
            if avail oper-ord
            and oper-ord.ferramenta <> ""
            then do:
                find first tt-ferr-prod-uep
                     where tt-ferr-prod-uep.cod-ferr-prod = oper-ord.ferramenta
                           no-lock no-error.
                
                if avail tt-ferr-prod-uep 
                then assign de-indice-uepH-ferr = tt-ferr-prod-uep.de-indice-uepH.
            end.
            
            // Totaliza por estab x cc
            find first tt-rep-cc
                 where tt-rep-cc.cod-estabel = movto-ggf.cod-estabel
                   and tt-rep-cc.cc-codigo   = movto-ggf.cc-codigo
                       no-lock no-error.

            if not avail tt-rep-cc 
            then do:
                create tt-rep-cc.
                assign tt-rep-cc.cod-estabel = movto-ggf.cod-estabel
                       tt-rep-cc.cc-codigo   = movto-ggf.cc-codigo.
            end.

            // Somatorio e tratativa dos indices uepH
            assign de-indice-uepH-tot = tt-grup-maquina-uep.de-indice-uepH + de-indice-uepH-ferr.

            if de-indice-uepH-tot = 0 
            then assign de-indice-uepH-tot = 1.

            if movto-ggf.tipo-trans = 1 // 1 - Reporte | 2 - Estorno
            then assign tt-rep-cc.horas-report   = tt-rep-cc.horas-report   + movto-ggf.horas-report
                        tt-rep-cc.de-indice-uepH = tt-rep-cc.de-indice-uepH + movto-ggf.horas-report * de-indice-uepH-tot.
            else assign tt-rep-cc.horas-report   = tt-rep-cc.horas-report   - movto-ggf.horas-report
                        tt-rep-cc.de-indice-uepH = tt-rep-cc.de-indice-uepH - movto-ggf.horas-report * de-indice-uepH-tot.

            //assign horas-report-aux     = horas-report-aux     + movto-ggf.horas-report
            //       horas-report-UEP-aux = horas-report-UEP-aux + movto-ggf.horas-report * de-indice-uepH-tot.

        end.
    
    end.

    run pi-seta-titulo IN h-acomp ("Recalculando Horas...").
    
    do dt-aux = dt-per-ini to dt-per-fim:
    
        run pi-acompanhar IN h-acomp ("Data: " + string(dt-aux)).
        
        for each movto-ggf use-index data where
                 movto-ggf.dt-trans = dt-aux
                 no-lock,
           first tt-grup-maquina where
                 tt-grup-maquina.gm-codigo = movto-ggf.gm-codigo
                 no-lock,
           first tt-grup-maquina-uep where
                 tt-grup-maquina-uep.gm-codigo = movto-ggf.gm-codigo
                 no-lock:

            release oper-ord.
            
            find first tt-rep-cc
                 where tt-rep-cc.cod-estabel = movto-ggf.cod-estabel
                   and tt-rep-cc.cc-codigo   = movto-ggf.cc-codigo
                       no-lock no-error.

            assign de-indice-uepH-ferr = 0.
            
            // Busca operacao da ordem
            find first oper-ord
                 where oper-ord.nr-ord-produ = movto-ggf.nr-ord-produ
                   and oper-ord.it-codigo    = movto-ggf.it-codigo   
                   and oper-ord.cod-roteiro  = movto-ggf.cod-roteiro 
                   and oper-ord.op-codigo    = movto-ggf.op-codigo   
                       no-lock no-error.

            if avail oper-ord
            and oper-ord.ferramenta <> ""
            then do:
                find first tt-ferr-prod-uep
                     where tt-ferr-prod-uep.cod-ferr-prod = oper-ord.ferramenta
                           no-lock no-error.
                
                if avail tt-ferr-prod-uep 
                then assign de-indice-uepH-ferr = tt-ferr-prod-uep.de-indice-uepH.
            end.

            // Somatorio e tratativa dos indices uepH
            assign de-indice-uepH-tot = tt-grup-maquina-uep.de-indice-uepH + de-indice-uepH-ferr.

            if de-indice-uepH-tot = 0 
            then assign de-indice-uepH-tot = 1.

            assign de-perc             = ((movto-ggf.horas-report * de-indice-uepH-tot) * 100) / tt-rep-cc.de-indice-uepH
                   de-horas-report-new = (tt-rep-cc.horas-report * de-perc) / 100.
            
            if movto-ggf.tipo-trans = 1 // 1 - Reporte | 2 - Estorno
            then assign tt-grup-maquina.tot-horas-report-new = tt-grup-maquina.tot-horas-report-new + de-horas-report-new.
            else assign tt-grup-maquina.tot-horas-report-new = tt-grup-maquina.tot-horas-report-new - de-horas-report-new.
            
            // Registra detalhe
            if tt-param.lg-detalha-calc 
            then do:
                create tt-detalhe-grup-maquina-uep.
                assign tt-detalhe-grup-maquina-uep.gm-codigo        = movto-ggf.gm-codigo   
                       tt-detalhe-grup-maquina-uep.nr-ord-prod      = movto-ggf.nr-ord-produ   
                       tt-detalhe-grup-maquina-uep.it-codigo        = movto-ggf.it-codigo
                       tt-detalhe-grup-maquina-uep.ferramenta       = oper-ord.ferramenta when avail oper-ord
                       tt-detalhe-grup-maquina-uep.horas-report     = movto-ggf.horas-report
                       tt-detalhe-grup-maquina-uep.horas-report-new = de-horas-report-new
                       tt-detalhe-grup-maquina-uep.tipo-trans       = movto-ggf.tipo-trans
                       tt-detalhe-grup-maquina-uep.c-tipo-trans     = if movto-ggf.tipo-trans = 1 then "REP" else "EST".
            end.

            if tt-param.opcao = 2 // Atualiza
            //and avail b-movto-ggf 
            then do:
                // Salva horas originais
                find first es-movto-ggf
                     where es-movto-ggf.num-id-movto-ggf = movto-ggf.num-id-movto-ggf
                           exclusive-lock no-error.
        
                if not avail es-movto-ggf 
                then do:
                    create es-movto-ggf.
                    assign es-movto-ggf.num-id-movto-ggf = movto-ggf.num-id-movto-ggf.
                end.
    
                assign es-movto-ggf.horas-report-orig = movto-ggf.horas-report.
    
                release es-movto-ggf.
    
                // Atualiza novas horas
                find current movto-ggf exclusive-lock no-error.
    
                assign movto-ggf.horas-report = de-horas-report-new.
    
                find current movto-ggf no-lock no-error.
            end.
        end.
    end.
    
    run pi-seta-titulo IN h-acomp ("Imprimindo...").
    
    for each tt-grup-maquina
             no-lock,
       first tt-grup-maquina-uep where  
             tt-grup-maquina-uep.gm-codigo = tt-grup-maquina.gm-codigo
             no-lock,
       first grup-maquina where
             grup-maquina.gm-codigo = tt-grup-maquina.gm-codigo
             no-lock
             break by tt-grup-maquina.gm-codigo:
    
        run pi-acompanhar IN h-acomp ("Grupo de M†quina: " + tt-grup-maquina.gm-codigo).
        
        disp tt-grup-maquina.gm-codigo
             grup-maquina.descricao
             tt-grup-maquina.tot-horas-report
             tt-grup-maquina-uep.de-indice-uepH
             tt-grup-maquina.tot-horas-report-new
             with frame f-gm-maq.
        down with frame f-gm-maq.

        accumulate tt-grup-maquina.tot-horas-report     (total by tt-grup-maquina.gm-codigo).
        accumulate tt-grup-maquina.tot-horas-report-new (total by tt-grup-maquina.gm-codigo).

        if tt-param.lg-detalha-calc 
        then do:
            
            put skip(1).

            for each tt-detalhe-grup-maquina-uep where
                     tt-detalhe-grup-maquina-uep.gm-codigo = tt-grup-maquina.gm-codigo
                     no-lock,
               first item where
                     item.it-codigo = tt-detalhe-grup-maquina-uep.it-codigo
                     no-lock:

                find first tt-ferr-prod-uep
                     where tt-ferr-prod-uep.cod-ferr-prod = tt-detalhe-grup-maquina-uep.ferramenta
                           no-lock no-error.

                disp tt-detalhe-grup-maquina-uep.nr-ord-prod     
                     tt-detalhe-grup-maquina-uep.it-codigo
                     item.desc-item                               format 'x(40)'
                     tt-detalhe-grup-maquina-uep.ferramenta
                     tt-detalhe-grup-maquina-uep.c-tipo-trans
                     tt-detalhe-grup-maquina-uep.horas-report
                     (if avail tt-ferr-prod-uep then tt-ferr-prod-uep.de-indice-uepH else 0) @ tt-ferr-prod-uep.de-indice-uepH
                     tt-detalhe-grup-maquina-uep.horas-report-new
                     with frame f-det-gm-maq.
                down with frame f-det-gm-maq.
            end.

            put skip(1).
        end.

        if last (tt-grup-maquina.gm-codigo) 
        then do:
            underline tt-grup-maquina.gm-codigo
                      grup-maquina.descricao
                      tt-grup-maquina.tot-horas-report
                      tt-grup-maquina-uep.de-indice-uepH
                      tt-grup-maquina.tot-horas-report-new
                      with frame f-gm-maq.
            down with frame f-gm-maq.

            disp 'TOTAL'                                            @ tt-grup-maquina.gm-codigo
                 (accum total tt-grup-maquina.tot-horas-report)     @ tt-grup-maquina.tot-horas-report
                 (accum total tt-grup-maquina.tot-horas-report-new) @ tt-grup-maquina.tot-horas-report-new
                 with frame f-gm-maq.
            down with frame f-gm-maq.
        end.
    
    end.

end.

run pi-finalizar in h-acomp.

{include/i-rpclo.i}

return "OK".

/******************************* PROCEDURES *******************************/
procedure pi-busca-gm-UEP:

    // Variaveis
    define variable oClient             as IHttpClient                              no-undo.
    define variable oURI                as URI                                      no-undo.
    define variable oRequest            as IHttpRequest                             no-undo. 
    define variable oResponse           as IHttpResponse                            no-undo.
    define variable oJsonObject         as Progress.Json.ObjectModel.jSonObject     no-undo.
    define variable JsonString          as longchar                                 no-undo.
    define variable oResponseBody       as OpenEdge.Core.String                     no-undo.
    define variable c-id-URI            as char init 'UEP_OP'                       no-undo.
    
    find first es-api-URI
         where es-api-URI.id-URI = c-id-URI
               no-lock no-error.

    if not avail es-api-URI or
      (avail es-api-URI
    and es-api-URI.ent-PRD = '')
    then do:
        put unformat
            "Integraá∆o WSO2 " + c-id-URI + " n∆o cadastra no programa ESAPI503, ou URL n∆o foi informada."
            skip(1).
        return "nok".
    end.
    
    //Build a request
    assign oURI = URI:Parse(es-api-URI.ent-PRD).

    //assign oURI = URI:Parse("http://micro-integrator-aps-homolog.apps.intelbras.com.br/odata/IntegracoesAPSDSS/UEP/UP_PO").

    //Execute a request
    oRequest = RequestBuilder:GET(oURI):AddHeader("x-forwarded-proto","https"):AddHeader("Content-Type","application/json"):Request.
    oClient = ClientBuilder:Build():Client.
    oResponse = oClient:Execute(oRequest).

    //Process the response
    if oResponse:StatusCode <> 200 
    then put unformat
             "Erro de reposta para o serviáo UEP: " + string(oResponse:StatusCode)
             skip(1).
    else do:
        assign oJsonObject = CAST(oResponse:Entity, Progress.Json.ObjectModel.jSonObject).

        oJsonObject:Write(JsonString, true).
        oJsonObject:WriteFile(session:temp-directory + "JSON_UEP_RET" +  ".json", yes).
        //put unformat string(JsonString).

        run ProcessObject (input "ROOT", INPUT oJsonObject).
    end.

end.

procedure ProcessObject:

    // Parametros
    define input parameter pParentName      as char                                         no-undo.
    define input parameter oJsonObject      as Progress.Json.ObjectModel.jSonObject         no-undo.

    // Variˇveis
    define variable myArray         as character extent                         no-undo.
    define variable i-cont          as integer                                  no-undo.  
    define variable cText           as longchar                                 no-undo.  
    define variable cParent         as character                                no-undo.
    define variable oJsonObject2    as Progress.Json.ObjectModel.jSonObject     no-undo.
    define variable c-tributo       as char                                     no-undo.
    define variable oParser         as ObjectModelParser                        no-undo.
    define variable oJsonArray      as JsonArray                                no-undo.
    define variable cString         as character                                no-undo.
    define variable gm-codigo-aux   as char                                     no-undo.
    define variable data-atualiz    as date                                     no-undo.
    define variable de-indice-aux   as dec                                      no-undo.

    assign oParser = new ObjectModelParser()
           myArray = oJsonObject:GetNames() no-error.

    do i-cont = 1 to extent(myArray):
        
        assign cText   = oJsonObject:getJsonText(myArray[i-cont]) no-error.
        assign cString = string(cText) no-error.
        assign cParent = myArray[i-cont] no-error.
        
        if cParent = 'CODIGO' 
        then assign gm-codigo-aux = cString.

        if cParent = 'DATA_ATUALIZACAO'
        then do:
            if cString <> 'null' 
            then assign data-atualiz = date(int(substring(cString,6,2)),int(substring(cString,9,2)),int(substring(cString,1,4))).
            else assign data-atualiz = ?.
        end.
        
        if cParent = 'QTDUPHR' 
        and (avail tt-grup-maquina-uep or
             avail tt-ferr-prod-uep)
        then assign de-indice-aux = dec(replace(cString,".",",")).

        if data-atualiz <> ?
        then do:
            // Verifica se e grupo de maquina...
            if can-find (first grup-maquina where
                               grup-maquina.gm-codigo = gm-codigo-aux) 
            then do:
                find first tt-grup-maquina-uep
                     where tt-grup-maquina-uep.gm-codigo      = gm-codigo-aux
                       and tt-grup-maquina-uep.dt-atualizacao = data-atualiz
                           no-error.
    
                if not avail tt-grup-maquina-uep 
                then do:
                    create tt-grup-maquina-uep.
                    assign tt-grup-maquina-uep.gm-codigo      = gm-codigo-aux
                           tt-grup-maquina-uep.dt-atualizacao = data-atualiz.
                end.
    
                assign tt-grup-maquina-uep.de-indice-uepH = de-indice-aux.

            end.
            else do:
                // Atualiza por ferramenta
                if can-find (first ferr-prod where
                                   ferr-prod.cod-ferr-prod = gm-codigo-aux)
                then do:
                    find first tt-ferr-prod-uep
                         where tt-ferr-prod-uep.cod-ferr-prod  = gm-codigo-aux
                           and tt-ferr-prod-uep.dt-atualizacao = data-atualiz
                               no-error.
                    
                    if not avail tt-ferr-prod-uep 
                    then do:
                        create tt-ferr-prod-uep.
                        assign tt-ferr-prod-uep.cod-ferr-prod  = gm-codigo-aux
                               tt-ferr-prod-uep.dt-atualizacao = data-atualiz.
                    end.
                    
                    assign tt-ferr-prod-uep.de-indice-uepH = de-indice-aux.

                end.
            end.
        end.

        if oJsonObject:GetType(myArray[i-cont]) = JsonDataType:object 
        then do:
            assign oJsonObject2 = CAST(oParser:Parse( oJsonObject:getJsonText(myArray[i-cont]) ), JsonObject) no-error.
            run ProcessObject (input cParent, input oJsonObject2). /* Process the JSON Object */ 
        end.
        
        if oJsonObject:GetType(myArray[i-cont]) = JsonDataType:ARRAY
        then do:
            assign oJsonArray = CAST(oParser:Parse( oJsonObject:getJsonText(myArray[i-cont]) ), JsonArray) no-error.
        
            run ProcessArray (input cParent, input oJsonArray). /* Process the JSON Array */     
        end.
    end.
end.

procedure ProcessArray:

    // Parametros
    define input parameter pParentName      as char              no-undo.
    define input parameter oJsonArray       as JsonArray         no-undo.

    define variable i-cont      as integer                no-undo.  
    define variable cText       as longchar               no-undo.  
    define variable oJsonObject as JsonObject             no-undo.
    define variable oParser     as ObjectModelParser      no-undo.

    assign oParser = new ObjectModelParser().

    /* Process each object in the JSON array */
    do i-cont = 1 to oJsonArray:length:

        assign cText = oJsonArray:getJsonText(i-cont).

        assign oJsonObject = cast(oParser:Parse(cText), JsonObject) no-error.
                                                       
        run ProcessObject (input pParentName, input oJsonObject). /* Process the JSON Object */
    end.  
end.
