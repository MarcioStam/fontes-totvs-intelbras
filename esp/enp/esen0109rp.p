/********************************************************************************
*      Programa .....: esen0109rp.p                                             *
*      Data .........: 03 de fevereiro de 2023                                  *
*      Sistema ......: ENP                                                      *
*      Empresa ......: iDBA                                                     *
*      Cliente ......: Intelbras                                                *
*      Programador ..: Maur°cio C.                                              *
*      Objetivo .....: Inclus∆o de Componentes Alternativos                     *
*********************************************************************************
*      VERSAO       DATA        RESPONSAVEL   MOTIVO                            *
*      1.00.00.000  03/02/2023  Mauricio C.   Desenvolvimento                   *
********************************************************************************/
function fn-get-copy returns character (input c-file as character) forwards.
{include/i-prgvrs.i esen0109rp 1.00.00.000}
{cdp/cdcfgman.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i esen0109rp ENP}
&ENDIF

define temp-table tt-param no-undo
    field destino         as integer
    field arquivo         as char format "x(35)"
    field usuario         as char format "x(12)"
    field data-exec       as date
    field hora-exec       as integer
    field classifica      as integer
    field desc-classifica as char format "x(40)"
    field modelo-rtf      as char format "x(35)"
    field l-habilitaRtf   as logi
    field execucao        as inte
    field es-codigo       as char
    field es-codigo-alt   as char.

define temp-table tt-digita no-undo
    field it-codigo   as char
    field desc-item   as char
    field sequencia   as inte
    field quantidade  as deci
    field dt-inicio   as char
    field dt-termino  as char
    field ativo       as logi
    field r-estrutura as rowid
    index id is primary it-codigo
                        sequencia
    index id2 ativo.

def temp-table tt-alternativo no-undo like alternativo
    field r-Rowid as rowid.

define temp-table tt-ocorrencia no-undo
    field it-codigo as char
    field sequencia as inte
    field cont      as inte
    field mensagem  as char format "x(70)"
    index id is primary it-codigo
                        sequencia
                        cont.

define temp-table tt-raw-digita
    field raw-digita    as raw.

/*  Recebimento de parametros --- */
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end. /* for each tt-raw-digita */
find current tt-param  no-error.    
find current tt-digita no-error.  

/***** VARIµVEIS *****/
{include/i-rpvar.i}
{utp/ut-glob.i}
{method/dbotterr.i}

def var h-acomp      as handle no-undo.
def var c-param-arq  as char   no-undo.
def var c-arq-copy   as char   no-undo.
def var i-cont       as inte   no-undo.
def var lg-process   as logi   no-undo.
def var iNumMessages as inte   no-undo.

def var i-fill as inte init 90 no-undo.

def buffer b-item for item.

/***** FRAMES *****/
form tt-ocorrencia.it-codigo format "x(16)" column-label "Onde-se-usa"
     tt-ocorrencia.sequencia format ">>>>9" column-label "Seq"
     tt-ocorrencia.mensagem format "x(148)" column-label "Mensagem"
     with width 172 down no-box stream-io frame f-dados.

find first param-global no-lock no-error.
find last  param-en     no-lock no-error.

assign c-programa     = "ESEN0109":U
       c-versao       = "1.00.00":U
       c-revisao      = "000":U
       c-empresa      = param-global.grupo
       c-titulo-relat = "Inclus∆o de Componentes Alternativos"
       c-sistema      = "ENP".

assign c-rodape = "iDBA - " 
                + c-sistema 
                + " - " 
                + c-programa
                + " - V:" 
                + c-versao
                + "."
                + c-revisao
       c-rodape = fill("-", 132 - length(c-rodape)) + c-rodape.

form header
     fill("-", 132) format "x(132)" skip
     c-empresa c-titulo-relat at 50
     "Folha:" at 122 page-number  at 128 format ">>>>9" skip
     fill("-", 112) format "x(110)" today format "99/99/9999"
     "-" string(time, "HH:MM:SS") skip(1)
     with stream-io width 132 no-labels no-box page-top frame f-cabec.

form header
     c-rodape format "x(132)"
     with stream-io width 132 no-labels no-box page-bottom frame f-rodape.

if tt-param.execucao = 1 /* Online */
then do:
     run utp/ut-acomp.p persistent set h-acomp.
     run pi-inicializar in h-acomp(input "Processando...").
end. /* if tt-param.execucao = 1 */

if tt-param.destino > 1
then do:
     file-info:file-name = trim(tt-param.arquivo).
     assign c-param-arq = file-info:full-pathname.

     if c-param-arq = ?
     then assign c-param-arq = trim(tt-param.arquivo).

     assign c-arq-copy = fn-get-copy(input c-param-arq).
end. /* if tt-param.destino > 1 */

{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.

put unformatted
    "Usu†rio               : " c-seg-usuario    skip
    "Arquivo               : " tt-param.arquivo skip.

if c-arq-copy <> ""
then put unformatted
         "LOG                   : " c-arq-copy skip.

put unformatted                                       skip
    "Componente            : " tt-param.es-codigo     skip
    "Componente Alternativo: " tt-param.es-codigo-alt skip
    fill("-",i-fill)                                  skip(1)
    "*** Verifique no final do arquivo a ocorrància de poss°veis erros ***" skip(1)
    fill("-",i-fill)                                  skip(1).

for first item
    where item.it-codigo   = tt-param.es-codigo
          no-lock: end.

for first b-item
    where b-item.it-codigo = tt-param.es-codigo-alt
          no-lock: end.

if  avail item
and avail b-item
then if (item.tipo-con-est    = 4 and 
         b-item.tipo-con-est <> 4) 
     or (item.tipo-con-est   <> 4 and 
         b-item.tipo-con-est  = 4) 
     then run pi-cria-ocorrencia (input tt-param.es-codigo-alt,
                                  input 0,
                                  input "Componente Alternativo possui Tipo de Controle inv†lido").
     else if  item.cod-obsoleto   = 1
          and b-item.cod-obsoleto = 1
          and b-item.tipo-contr  <> 4
          then run pi-exe.
          else do:
               if item.cod-obsoleto > 1
               then run pi-cria-ocorrencia (input tt-param.es-codigo,
                                            input 0,
                                            input "Componente n∆o se encontra ativo").
          
               if b-item.cod-obsoleto > 1
               then run pi-cria-ocorrencia (input tt-param.es-codigo-alt,
                                            input 0,
                                            input "Componente Alternativo n∆o se encontra ativo").
          
               if b-item.tipo-contr = 4
               then run pi-cria-ocorrencia (input tt-param.es-codigo-alt,
                                            input 0,
                                            input "Tipo Controle do Componente Alternativo n∆o pode ser DÇbito Direto").
          end. /* else do */
else do:
     if not avail item
     then run pi-cria-ocorrencia (input tt-param.es-codigo,
                                  input 0,
                                  input "Componente n∆o cadastrado").

     if not avail b-item
     then run pi-cria-ocorrencia (input tt-param.es-codigo-alt,
                                  input 0,
                                  input "Componente Alternativo n∆o cadastrado").
end. /* else do */

if  not temp-table tt-ocorrencia:has-records
and not lg-process
then put unformatted
         "NENHUM REGISTRO FOI PROCESSADO!".

run pi-mostra-ocorrencia.

if valid-handle(h-acomp)
then run pi-finalizar in h-acomp.

{include/i-rpclo.i}

return "OK":U.
{esp/enp/esen0109rp.i} /* catch */

finally:
    run pi-mostra-ocorrencia.

    if valid-handle(h-acomp)
    then run pi-finalizar in h-acomp.

    /* Salva Log */
    if  c-arq-copy          <> ""
    and search(c-param-arq) <> ?
    then os-copy value(c-param-arq) value(c-arq-copy).
end.

/******************** PROCEDURES e FUNÄÂES ********************/
procedure pi-exe:
    def var h-boin015 as handle no-undo.
    def var c-return  as char   no-undo.

    run inbo/boin015.p persistent set h-boin015.
    run openQueryStatic in h-boin015 (input "Main").

    for each tt-digita:
        if valid-handle(h-acomp)
        then run pi-acompanhar in h-acomp (input "Estrutura " + tt-digita.it-codigo).

        assign i-cont = 0.
    
        for first estrutura 
            where estrutura.it-codigo = tt-digita.it-codigo
              and estrutura.sequencia = tt-digita.sequencia
              and estrutura.es-codigo = item.it-codigo
                  no-lock: end.
    
        if not avail estrutura
        then do:
             run pi-cria-ocorrencia (input tt-digita.it-codigo,
                                     input tt-digita.sequencia,
                                     input "Componente/sequància foi eliminado da estrutura").
             next.
        end.
    
        if  estrutura.data-inicio  <= today
        and estrutura.data-termino >= today
        then.
        else do:
             run pi-cria-ocorrencia (input tt-digita.it-codigo,
                                     input tt-digita.sequencia,
                                     input "Componente/sequància fora da validade").
             next.
        end. /* else do */

        &IF DEFINED (bf_man_sfc_lc) &THEN
        if not estrutura.cod-lista-compon = ""
        then do:
             run pi-cria-ocorrencia (input tt-digita.it-codigo,
                                     input tt-digita.sequencia,
                                     input "L.Compon inconsistente").
             next.
        end.
        &ENDIF
    
        if can-find(first alternativo where
                          alternativo.it-codigo = estrutura.it-codigo
                      and alternativo.sequencia = estrutura.sequencia
                      and alternativo.es-codigo = estrutura.es-codigo
                      and alternativo.ordem    >= 0
                      and alternativo.al-codigo = b-item.it-codigo
                          no-lock)
        then do:
             run pi-cria-ocorrencia (input tt-digita.it-codigo,
                                     input tt-digita.sequencia,
                                     input "Alternativo j† consta do Componente, nessa estrutura").
             next.
        end.

        &if defined(bf_man_per_ppm) &then
          if  param-global.modulo-per-ppm 
          and estrutura.veiculo 
          and b-item.tipo-formula <> 4 
          then do:
               run pi-cria-ocorrencia (input tt-digita.it-codigo,
                                       input tt-digita.sequencia,
                                       input "Tipo de Formulaá∆o do Componente Alternativo tem de ser Ve°culo").
               next.
          end.
        &endif       

        empty temp-table tt-alternativo.
        empty temp-table RowErrors.

        create tt-alternativo.
        buffer-copy estrutura except char-1 char-2
                                     dec-1  dec-2
                                     int-1  int-2
                                     log-1  log-2
                                     data-1 data-2 to tt-alternativo
            assign tt-alternativo.ordem     = param-en.num-var-estrutura
                   tt-alternativo.al-codigo = b-item.it-codigo.

        for last alternativo no-lock
           where alternativo.it-codigo = estrutura.it-codigo
             and alternativo.sequencia = estrutura.sequencia
             and alternativo.es-codigo = estrutura.es-codigo:
            assign tt-alternativo.ordem = alternativo.ordem + param-en.num-var-estrutura.
        end.
    
        find current tt-alternativo no-error.

        run emptyRowObject    in h-boin015.
        run emptyRowObjectAux in h-boin015.
        run emptyRowErrors    in h-boin015.
        run setRecord         in h-boin015 (input table tt-alternativo).

        blk-alt:
        do transaction on error   undo, leave
                       on stop    undo, leave
                       on end-key undo, leave:
            run validateRecord in h-boin015 (input "Create").
            assign c-return = return-value.
            run getRowErrors   in h-boin015 (output table RowErrors).

            if  c-return = "OK":U
            and not temp-table RowErrors:has-records
            then do:
                 run createRecord in h-boin015.
                 assign c-return = return-value.
                 run getRowErrors in h-boin015 (output table RowErrors).
            end.

            if  c-return = "OK":U
            and not temp-table RowErrors:has-records
            and can-find(first alternativo where
                               alternativo.it-codigo = tt-alternativo.it-codigo
                           and alternativo.sequencia = tt-alternativo.sequencia
                           and alternativo.es-codigo = tt-alternativo.es-codigo
                           and alternativo.ordem     = tt-alternativo.ordem
                           and alternativo.al-codigo = tt-alternativo.al-codigo
                               no-lock)
            then do:
                 if not lg-process
                 then put unformatted 
                          "REGISTROS INCLU÷DOS ----->"
                          skip(1).

                 assign lg-process = yes.

                 disp tt-alternativo.it-codigo                      @ tt-ocorrencia.it-codigo
                      tt-alternativo.sequencia                      @ tt-ocorrencia.sequencia
                      "Componente Alternativo inclu°do com sucesso" @ tt-ocorrencia.mensagem
                      with frame f-dados.
                 down with frame f-dados.
                 
                 leave blk-alt.
            end.

            if temp-table RowErrors:has-records
            then for each RowErrors:
                     run pi-cria-ocorrencia (input tt-digita.it-codigo,
                                             input tt-digita.sequencia,
                                             input string(RowErrors.ErrorNumber) + "-" + trim(RowErrors.ErrorDescription)).
                 end. /* for each RowErrors */
            else run pi-cria-ocorrencia (input tt-digita.it-codigo,
                                         input tt-digita.sequencia,
                                         input "BO: Erro na inclus∆o do Alternativo para esse Item/Sequància").
    
            undo blk-alt, leave blk-alt.
        end. /* do transaction */    
    end. /* for each tt-digita */

    delete procedure h-boin015 no-error.

    if lg-process
    then put unformatted
             skip(1)
             fill("-",i-fill)
             skip(1).

    return "OK".
    {esp/enp/esen0109rp.i} /* catch */

    finally:
        if valid-handle(h-boin015)
        then delete procedure h-boin015 no-error.
    end.
end procedure. /* procedure pi-exe */

procedure pi-cria-ocorrencia:
    def input parameter p-it-codigo as char no-undo.
    def input parameter p-sequencia as inte no-undo.
    def input parameter p-msg       as char no-undo.

    assign i-cont = i-cont + 1.

    create tt-ocorrencia.
    assign tt-ocorrencia.it-codigo = p-it-codigo
           tt-ocorrencia.sequencia = p-sequencia
           tt-ocorrencia.cont      = i-cont
           tt-ocorrencia.mensagem  = p-msg.
    find current tt-ocorrencia no-error.

    return "OK".
end procedure. /* procedure pi-cria-ocorrencia */

procedure pi-mostra-ocorrencia:
    find current tt-ocorrencia no-error.
    release tt-ocorrencia.

    if not temp-table tt-ocorrencia:has-records
    then return "OK".

    put unformatted
        "OCORR“NCIAS ENCONTRADAS (os registros correspondentes n∆o foram processados) ----->"
        skip(1).

    for each tt-ocorrencia
             break by tt-ocorrencia.it-codigo
                   by tt-ocorrencia.sequencia:
        if first-of(tt-ocorrencia.sequencia)
        then disp tt-ocorrencia.it-codigo
                  tt-ocorrencia.sequencia
                  with frame f-dados.

        disp tt-ocorrencia.mensagem
             with frame f-dados.
        down with frame f-dados.
    end. /* for each tt-ocorrencia */

    empty temp-table tt-ocorrencia.

    put unformatted
        skip(1)
        fill("-",i-fill)
        skip(1).

    return "OK".
end procedure. /* procedure pi-mostra-ocorrencia */

function fn-get-copy returns character (input c-file as character):
    def var c-arq-aux as char no-undo.
    def var c-dir-aux as char no-undo.
    def var c-result  as char no-undo.

    assign c-dir-aux = replace(c-file,"\","/")
           c-arq-aux = substr(c-dir-aux,r-index(c-dir-aux,"/"),length(c-dir-aux))
           c-arq-aux = substr(c-arq-aux,1,r-index(c-arq-aux,".") - 1)
                     + "_LOG"
                     + replace(iso-date(today),"-","")
                     + replace(string(time,"HH:MM:SS"),":","")
                     + substr(c-arq-aux,r-index(c-arq-aux,"."),length(c-arq-aux))
                     no-error.

    if error-status:error
    then return "".

    assign file-info:file-name = substr(c-dir-aux,1,r-index(c-dir-aux,"/")).
    assign c-result = file-info:full-pathname
                    + c-arq-aux
           c-result = replace(c-result,"\","/").

    if c-result = ?
    then return "".

    return c-result.
end function.
