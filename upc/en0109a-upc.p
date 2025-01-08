/******************************************************************************
*      Programa .....: EN0109A-UPC.P                                          *
*      Data .........: 08 de Fevereiro de 2023                                *
*      Sistema ......: EN - ENGENHARIA                                        *
*      Empresa ......: iDBA                                                   *
*      Cliente ......: Intelbras                                              *
*      Programador ..: Mauricio                                               *
*      Objetivo .....: UPC para o EN0109A                                     *
*******************************************************************************
*      VERSAO      DATA        RESPONSAVEL   MOTIVO                           *
*      2.12.00.000 08/02/2023  Mauricio      Desenvolvimento                  *
******************************************************************************/
{include/i-prgvrs.i "en0109a-upc" 2.12.00.000}
{upc/en0109a-upc.i} 
{include/i-rpvar.i}
{method/dbotterr.i}

define input param p-ind-event  as char          no-undo.
define input param p-ind-object as char          no-undo.
define input param p-wgh-object as handle        no-undo.
define input param p-wgh-frame  as widget-handle no-undo.
define input param p-cod-table  as char          no-undo.
define input param p-row-table  as rowid         no-undo.

def var c-objeto   as char          no-undo.
def var h-btOK-esp as widget-handle no-undo.
def var i-aux      as inte          no-undo.

def var h-en0109a-upc  as handle no-undo.
def var ProgramHandle  as handle no-undo.
def var ProgramHandle2 as handle no-undo.

def new global shared var h-es-atual-en0109a-upc as handle no-undo.
def new global shared var h-es-novo-en0109a-upc  as handle no-undo.
def new global shared var h-it-cod-en0109a-upc   as handle no-undo.
def new global shared var h-tb-conf-en0109a-upc  as handle no-undo.
def new global shared var h-btOK-pad-en0109a-upc as handle no-undo.
def new global shared var h-dt-valid-en0109a-upc as handle no-undo.
def new global shared var lg-ctrl-en0109a-upc    as logi   no-undo.
def new global shared var lg-vl-en0109a-upc      as logi   no-undo.

def temp-table tt-alternativo no-undo like alternativo
    field r-Rowid as rowid.

def temp-table tt-alternativo-aux no-undo like alternativo
    field erro       as logi
    field cadastrado as logi
    field mensagem   as char
    index id is primary es-codigo
                        it-codigo
                        sequencia
                        ordem
                        al-codigo.

assign c-objeto = entry(num-entries(p-wgh-object:file-name,'~/'),p-wgh-object:file-name,'~/') no-error.

/* message "P-ind-event  = " p-ind-event  skip        */
/*         "P-ind-object = " p-ind-object skip        */
/*         "C-objeto     = " c-objeto     SKIP        */
/*         "P-wgh-object = " p-wgh-object skip        */
/*         "P-wgh-frame  = " p-wgh-frame  skip        */
/*         "P-cod-table  = " p-cod-table  skip        */
/*         "p-row-table  = " string(p-row-table) skip */
/*         view-as alert-box.                         */

if  p-ind-event  = 'before-initialize'
and p-ind-object = 'container'
then do:
     assign ProgramHandle = session:first-procedure
            i-aux         = 0.

     /* Verifica quantas instÉncias do programa h† na mem¢ria */
     do while valid-handle(ProgramHandle):
         if ProgramHandle:file-name = "enp/en0109a.w"
         or ProgramHandle:file-name = "enp\en0109a.w"
         then assign i-aux          = i-aux + 1
                     ProgramHandle2 = ProgramHandle.

         assign ProgramHandle = ProgramHandle:next-sibling.
     end.

     if i-aux > 1
     then do:
          run utp\ut-msgs.p(input "show", input 19085, input "EN0109A j† est† aberto!").
          delete procedure ProgramHandle2.
          return "NOK".
     end.

     run pi-zera.
end.

if  p-ind-event  = 'initialize'
and p-ind-object = 'container'
then do:
     run pi-recupera-campo (input p-wgh-frame:first-child).

     if  valid-handle(h-btOK-pad-en0109a-upc)
     and valid-handle(h-es-atual-en0109a-upc)
     and valid-handle(h-es-novo-en0109a-upc)
     and valid-handle(h-desativar-en0109a-upc)
     and valid-handle(h-dt-valid-en0109a-upc)
     and valid-handle(h-it-cod-en0109a-upc)
     and valid-handle(h-tb-conf-en0109a-upc)
     then do:
          run upc/en0109a-upc.p persistent set h-en0109a-upc(input "",            
                                                             input "",            
                                                             input p-wgh-object,  
                                                             input p-wgh-frame,   
                                                             input "",            
                                                             input p-row-table).

          create button h-btOK-esp
          assign frame     = h-btOK-pad-en0109a-upc:frame
                 width     = h-btOK-pad-en0109a-upc:width
                 height    = h-btOK-pad-en0109a-upc:height
                 row       = h-btOK-pad-en0109a-upc:row
                 column    = h-btOK-pad-en0109a-upc:column
                 label     = "OK"
                 tooltip   = "OK (UPC)"
                 sensitive = h-btOK-pad-en0109a-upc:sensitive
                 visible   = yes
                 triggers:
                      on choose persistent run pi-ok-esp in h-en0109a-upc.
                 end triggers.

          create toggle-box h-alternativo-en0109a-upc
          assign frame     = h-desativar-en0109a-upc:frame
                 width     = 18
                 height    = 0.88
                 row       = h-dt-valid-en0109a-upc:row
                 column    = h-desativar-en0109a-upc:column + 29
                 label     = "Insere Alternativo"
                 tooltip   = "Insere Componente Alternativo automaticamente"
                 sensitive = no
                 visible   = yes.

          h-alternativo-en0109a-upc:move-after-tab(h-desativar-en0109a-upc) no-error. 
          h-btOK-esp:move-after-tab(h-btOK-pad-en0109a-upc) no-error. 
          h-btOK-pad-en0109a-upc:sensitive = no.

          on 'value-changed':U of h-desativar-en0109a-upc persistent run pi-value-changed in h-en0109a-upc.
     end. /* if valid-handle(h-btOK-pad-en0109a-upc) */
     else do:
          run pi-zera.
          run utp/ut-msgs.p (input "show", input 17567, input "Inconsistània encontrada. Processo espec°fico envolvendo adiá∆o de Componente(s) Altern. n∆o se encontra funcional.").         
     end. /* else do */
end.

if  p-ind-object = 'BT-OK'
and c-objeto     = 'en0109a.w'
and (p-ind-event = 'before-item-novo'  or
     p-ind-event = 'before-item-atual' or
     p-ind-event = 'after-item-novo')
then assign lg-ctrl-en0109a-upc = yes.

if  p-ind-event  = 'destroy'
and p-ind-object = 'container'
and c-objeto     = 'en0109a.w'
and not lg-ctrl-en0109a-upc
then run pi-zera.

/********** PROCEDURES **********/
procedure pi-ok-esp:
    def var h-acomp as handle no-undo.

    empty temp-table tt-en0109a-upc-new.
    empty temp-table tt-en0109a-upc-ant.

    assign lg-ctrl-en0109a-upc = no.

    if  valid-handle(h-es-atual-en0109a-upc)
    and valid-handle(h-es-novo-en0109a-upc)
    and valid-handle(h-desativar-en0109a-upc)
    and h-desativar-en0109a-upc:screen-value = "2"
    and h-es-novo-en0109a-upc:screen-value  <> ""
    and h-es-novo-en0109a-upc:screen-value  <> h-es-atual-en0109a-upc:screen-value
    and valid-handle(h-alternativo-en0109a-upc)
    and h-alternativo-en0109a-upc:sensitive
    and h-alternativo-en0109a-upc:checked
    then do:
         run pi-estrutura (input trim(h-es-atual-en0109a-upc:screen-value)).
         run pi-estrutura (input trim(h-es-novo-en0109a-upc:screen-value)).

         find current tt-en0109a-upc-ant no-error.
         release tt-en0109a-upc-ant.
    end.

    apply 'choose' to h-btOK-pad-en0109a-upc.

    if  temp-table tt-en0109a-upc-ant:has-records
    and temp-table tt-en0109a-upc-new:has-records
    then.
    else return.

    run utp/ut-acomp.p persistent set h-acomp.
    run pi-inicializar in h-acomp (input "Processando Compon.Altern...").

    run pi-alternativo (input h-acomp).  

    if valid-handle(h-acomp)
    then run pi-finalizar in h-acomp.

    return.

    finally:
        empty temp-table tt-en0109a-upc-new.
        empty temp-table tt-en0109a-upc-ant.
        assign lg-ctrl-en0109a-upc = no.

        if valid-handle(h-acomp)
        then delete procedure h-acomp no-error.
    end.
end procedure. /* procedure pi-ok-esp */

procedure pi-recupera-campo:
    def input parameter h_frame_cad as widget-handle no-undo.

    assign h_frame_cad = h_frame_cad:first-child.

    do while valid-handle(h_frame_cad):
        if  valid-handle(h-btOK-pad-en0109a-upc)
        and valid-handle(h-es-atual-en0109a-upc)
        and valid-handle(h-es-novo-en0109a-upc)
        and valid-handle(h-desativar-en0109a-upc)
        and valid-handle(h-dt-valid-en0109a-upc)
        and valid-handle(h-it-cod-en0109a-upc)
        and valid-handle(h-tb-conf-en0109a-upc)
        then leave.

        if  h_frame_cad:type = "BUTTON"
        and h_frame_cad:name = "bt-ok"
        then assign h-btOK-pad-en0109a-upc = h_frame_cad:handle.

        if h_frame_cad:type = "FILL-IN"
        then do:
             if h_frame_cad:name = "c-es-codigo-atual"
             then assign h-es-atual-en0109a-upc = h_frame_cad:handle.

             if h_frame_cad:name = "c-es-codigo-novo"
             then assign h-es-novo-en0109a-upc = h_frame_cad:handle.

             if h_frame_cad:name = "da-data-validade"
             then assign h-dt-valid-en0109a-upc = h_frame_cad:handle.

             if h_frame_cad:name = "c-it-codigo"
             then assign h-it-cod-en0109a-upc = h_frame_cad:handle.
        end. /* if h_frame_cad:type = "FILL-IN" */

        if  h_frame_cad:type = "RADIO-SET"
        and h_frame_cad:name = "rs-desativar"
        then assign h-desativar-en0109a-upc = h_frame_cad:handle.

        if  h_frame_cad:type = "TOGGLE-BOX"
        and h_frame_cad:name = "tb-confirma"
        then assign h-tb-conf-en0109a-upc = h_frame_cad:handle.

        assign h_frame_cad = h_frame_cad:next-sibling.
    end. /* do while valid-handle(p-wh-objeto-cad) */

    return "OK":U.
end procedure. /* procedure pi-recupera-campo */

procedure pi-zera:
     assign h-btOK-pad-en0109a-upc    = ?
            h-es-atual-en0109a-upc    = ?
            h-es-novo-en0109a-upc     = ?
            h-desativar-en0109a-upc   = ?
            h-dt-valid-en0109a-upc    = ?
            h-alternativo-en0109a-upc = ?
            h-it-cod-en0109a-upc      = ?
            h-tb-conf-en0109a-upc     = ?
            lg-ctrl-en0109a-upc       = no
            lg-vl-en0109a-upc         = no.

     empty temp-table tt-en0109a-upc-new.
     empty temp-table tt-en0109a-upc-ant.

    return "OK".
end procedure. /* procedure pi-zera */

procedure pi-value-changed:
    assign h-dt-valid-en0109a-upc:sensitive = h-desativar-en0109a-upc:screen-value = "2".

    if valid-handle(h-alternativo-en0109a-upc)
    then if h-dt-valid-en0109a-upc:sensitive
         then assign h-alternativo-en0109a-upc:sensitive = yes
                     h-alternativo-en0109a-upc:checked   = lg-vl-en0109a-upc.
         else assign lg-vl-en0109a-upc                   = h-alternativo-en0109a-upc:checked
                     h-alternativo-en0109a-upc:checked   = no
                     h-alternativo-en0109a-upc:sensitive = no.
end procedure. /* procedure pi-value-changed */

procedure pi-estrutura:
    def input parameter p-es-codigo as char no-undo.

    for each estrutura fields(it-codigo sequencia es-codigo 
                              data-inicio data-termino) use-index onde-se-usa no-lock
       where estrutura.es-codigo = p-es-codigo:
        if  estrutura.data-inicio  <= today
        and estrutura.data-termino >= today
        then.
        else next.

        create tt-en0109a-upc-ant.
        assign tt-en0109a-upc-ant.it-codigo    = estrutura.it-codigo
               tt-en0109a-upc-ant.sequencia    = estrutura.sequencia
               tt-en0109a-upc-ant.es-codigo    = estrutura.es-codigo
               tt-en0109a-upc-ant.data-termino = estrutura.data-termino.
    end. /* for each estrutura */

    return "OK".
end procedure. /* procedure pi-estrutura */

procedure pi-alternativo:
    def input param p-acomp as handle no-undo.

    def var h-wprog   as handle no-undo.
    def var h-boin015 as handle no-undo.
    def var c-return  as char   no-undo.
    def var c-arquivo as char   no-undo.
    def var lg-cabec  as logi   no-undo.

    def buffer b-estrutura          for estrutura.
    def buffer b-tt-en0109a-upc-new for tt-en0109a-upc-new.

    find first param-global no-lock no-error.
    find last  param-en     no-lock no-error.

    assign c-programa     = "EN0109A-UPC":U
           c-versao       = "2.12.00":U
           c-revisao      = "000":U
           c-empresa      = param-global.grupo
           c-titulo-relat = "Inclus∆o autom†tica de Compon Alternativos via UPC"
           c-sistema      = "ESP".
    
    assign c-rodape = "iDBA - " 
                    + c-sistema 
                    + " - " 
                    + c-programa
                    + " - V:" 
                    + c-versao
                    + "."
                    + c-revisao
           c-rodape = fill("-", 172 - length(c-rodape)) + c-rodape.

    form estrutura.it-codigo format "x(16)" column-label "Onde-se-usa"
         estrutura.sequencia format ">>>>9" column-label "Seq"
         estrutura.es-codigo format "x(16)" column-label "Compon. Novo"         
         with width 172 down no-box stream-io frame f-padrao.

    form tt-alternativo-aux.erro      format "Sim/N∆o" column-label "Erro"
         tt-alternativo-aux.es-codigo format "x(16)"   column-label "Compon. Atual"
         tt-alternativo-aux.it-codigo format "x(16)"   column-label "Onde-se-usa"
         tt-alternativo-aux.sequencia format ">>>>9"   column-label "Seq"
         tt-alternativo-aux.ordem     format ">>>>9"   column-label "Ordem"
         tt-alternativo-aux.al-codigo format "x(16)"   column-label "Compon. Alt (Novo)"
         tt-alternativo-aux.mensagem  format "x(102)"  column-label "Mensagem"
         with width 172 down no-box stream-io frame f-alternativo.

    form header
         fill("-", 172) format "x(172)" skip
         c-empresa c-titulo-relat at 50
         "Folha:" at 162 page-number  at 168 format ">>>>9" skip
         fill("-", 152) format "x(150)" today format "99/99/9999"
         "-" string(time, "HH:MM:SS") skip(1)
         with stream-io width 172 no-labels no-box page-top frame f-cabec.

    form header
         c-rodape format "x(172)"
         with stream-io width 172 no-labels no-box page-bottom frame f-rodape.

    empty temp-table tt-alternativo-aux.

    run inbo/boin015.p persistent set h-boin015.
    run openQueryStatic in h-boin015 (input "Main").

    for each tt-en0109a-upc-new use-index id2
       where tt-en0109a-upc-new.lg-new    = yes
         and tt-en0109a-upc-new.es-codigo = trim(h-es-novo-en0109a-upc:screen-value),
       first estrutura no-lock
       where estrutura.it-codigo = tt-en0109a-upc-new.it-codigo
         and estrutura.sequencia = tt-en0109a-upc-new.sequencia
         and estrutura.es-codigo = tt-en0109a-upc-new.es-codigo:
        if valid-handle(p-acomp)
        then run pi-acompanhar in p-acomp (input estrutura.it-codigo).

        if can-find(first tt-en0109a-upc-ant where
                          tt-en0109a-upc-ant.it-codigo = estrutura.it-codigo
                      and tt-en0109a-upc-ant.sequencia = estrutura.sequencia
                      and tt-en0109a-upc-ant.es-codigo = estrutura.es-codigo)
        then next.

        if not lg-cabec
        then do:                   
             assign lg-cabec  = yes
                    c-arquivo = session:temp-directory
                              + "en0109a-upc.txt".

             if search(c-arquivo) <> ?
             then os-delete value(c-arquivo) no-error.
            
             output to value(c-arquivo) paged page-size 64 convert target "iso8859-1".
            
             view frame f-cabec.
             view frame f-rodape.

             put unformatted 
                "Os seguintes Componentes Novos foram adicionados no processo (padr∆o) - verifique se os Alternativos foram processados corretamente"
                skip(1).
        end. /* if not lg-cabec */

        disp estrutura.it-codigo
             estrutura.sequencia
             estrutura.es-codigo
             with frame f-padrao.
        down with frame f-padrao.

        for first b-estrutura
            where b-estrutura.it-codigo = estrutura.it-codigo
              and b-estrutura.sequencia = estrutura.sequencia
              and b-estrutura.es-codigo = trim(h-es-atual-en0109a-upc:screen-value)
                  no-lock: end.

        if not avail b-estrutura
        then next.

        for first b-tt-en0109a-upc-new use-index id2
            where b-tt-en0109a-upc-new.lg-new    = no
              and b-tt-en0109a-upc-new.es-codigo = b-estrutura.es-codigo
              and b-tt-en0109a-upc-new.it-codigo = b-estrutura.it-codigo
              and b-tt-en0109a-upc-new.sequencia = b-estrutura.sequencia: end.


        if  not avail b-tt-en0109a-upc-new
        and not can-find(first tt-en0109a-upc-ant where
                               tt-en0109a-upc-ant.it-codigo    = b-estrutura.it-codigo
                           and tt-en0109a-upc-ant.sequencia    = b-estrutura.sequencia
                           and tt-en0109a-upc-ant.es-codigo    = b-estrutura.es-codigo
                           and tt-en0109a-upc-ant.data-termino = b-estrutura.data-termino)
        then if  h-it-cod-en0109a-upc:screen-value = "*"
             and h-tb-conf-en0109a-upc:sensitive
             then next.
             else if  h-it-cod-en0109a-upc:screen-value <> "*"
                  and not h-tb-conf-en0109a-upc:sensitive
                  then if b-estrutura.data-termino <> date(h-dt-valid-en0109a-upc:screen-value)
                       then next.
                       else.
                  else next.
        else.

        for first alternativo 
            where alternativo.it-codigo = b-estrutura.it-codigo
              and alternativo.sequencia = b-estrutura.sequencia
              and alternativo.es-codigo = b-estrutura.es-codigo
              and alternativo.ordem    >= 0
              and alternativo.al-codigo = estrutura.es-codigo
                  no-lock: end.

        if avail alternativo
        then do:
             create tt-alternativo-aux.
             buffer-copy alternativo to tt-alternativo-aux
                 assign tt-alternativo-aux.cadastrado = yes
                        tt-alternativo-aux.mensagem   = "Componente Alternativo j† se encontrava cadastrado para o Componente".
             release alternativo.
             next.
        end.

        empty temp-table tt-alternativo.
        empty temp-table RowErrors.

        create tt-alternativo.
        buffer-copy estrutura except es-codigo
                                     char-1    char-2
                                     dec-1     dec-2
                                     int-1     int-2
                                     log-1     log-2
                                     data-1    data-2 to tt-alternativo
            assign tt-alternativo.ordem     = param-en.num-var-estrutura
                   tt-alternativo.es-codigo = b-estrutura.es-codigo
                   tt-alternativo.al-codigo = estrutura.es-codigo.

        for last alternativo no-lock
           where alternativo.it-codigo = b-estrutura.it-codigo
             and alternativo.sequencia = b-estrutura.sequencia
             and alternativo.es-codigo = b-estrutura.es-codigo:
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

            create tt-alternativo-aux.
            buffer-copy tt-alternativo to tt-alternativo-aux
                assign tt-alternativo-aux.mensagem = "Componente Alternativo inclu°do com sucesso".

            if  c-return = "OK":U
            and not temp-table RowErrors:has-records
            and can-find(first alternativo where
                               alternativo.it-codigo = tt-alternativo.it-codigo
                           and alternativo.sequencia = tt-alternativo.sequencia
                           and alternativo.es-codigo = tt-alternativo.es-codigo
                           and alternativo.ordem     = tt-alternativo.ordem
                           and alternativo.al-codigo = tt-alternativo.al-codigo
                               no-lock)
            then leave blk-alt.

            assign tt-alternativo-aux.erro     = yes
                   tt-alternativo-aux.mensagem = "".

            if temp-table RowErrors:has-records
            then for first RowErrors:
                     assign tt-alternativo-aux.mensagem = string(RowErrors.ErrorNumber) + "-" + trim(RowErrors.ErrorDescription).
                 end. /* for first RowErrors */
            else assign tt-alternativo-aux.mensagem = "Erro na inclus∆o do Alternativo para esse Item/Sequància".
    
            undo blk-alt, leave blk-alt.
        end. /* do transaction */
    end. /* for each tt-en0109a-upc-new */

    delete procedure h-boin015 no-error.

    if lg-cabec
    then put unformatted skip(1)
                         fill("-",172)
                         skip(1).

    if not temp-table tt-alternativo-aux:has-records
    then do:
         put unformatted "Nenhum Componente Alternativo foi processado"
                         skip(1).

         return "OK".
    end.

    if can-find(first tt-alternativo-aux where
                      tt-alternativo-aux.erro = no)
    then do:
         put unformatted /*"Observaá∆o: revise o processo de adiá∆o autom†tica de Componentes Alternativos Ö desativaá∆o de Componentes"
                         skip
                         "Informaá‰es de apoio ---> "
                         skip(1)*/
                         "Os seguintes Componentes Alternativos foram processados"
                         skip(1).

         for each tt-alternativo-aux
            where tt-alternativo-aux.erro = no:
             disp tt-alternativo-aux.erro when not tt-alternativo-aux.cadastrado
                  tt-alternativo-aux.es-codigo
                  tt-alternativo-aux.it-codigo
                  tt-alternativo-aux.sequencia
                  tt-alternativo-aux.ordem    
                  tt-alternativo-aux.al-codigo
                  tt-alternativo-aux.mensagem
                  with frame f-alternativo.
             down with frame f-alternativo.
         end. /* for each tt-alternativo-aux */

         put unformatted skip(1)
                         fill("-",172)
                         skip(1).
    end.
    else put unformatted "Nenhum Componente Alternativo foi processado"
                         skip(1).

    if can-find(first tt-alternativo-aux where
                      tt-alternativo-aux.erro = yes)
    then do:
         put unformatted "Erros encontrados (os Componentes Alternativos abaixo n∆o foram adicionados)"
                         skip(1).

         for each tt-alternativo-aux
            where tt-alternativo-aux.erro = yes:
             disp tt-alternativo-aux.erro     
                  tt-alternativo-aux.es-codigo
                  tt-alternativo-aux.it-codigo
                  tt-alternativo-aux.sequencia
                  tt-alternativo-aux.ordem    
                  tt-alternativo-aux.al-codigo
                  tt-alternativo-aux.mensagem
                  with frame f-alternativo.
             down with frame f-alternativo.
         end. /* for each tt-alternativo-aux */

         put unformatted skip(1)
                         fill("-",172)
                         skip(1).
    end.

    return "OK".
    finally:
        if valid-handle(h-boin015)
        then delete procedure h-boin015 no-error.

        if c-arquivo <> ""
        then do:
             output close.

             run utp/ut-utils.p persistent set h-wprog.
             run OpenDocument in h-wprog (input c-arquivo).
             delete procedure h-wprog no-error.
        end.
    end.
end procedure. /* procedure pi-alternativo */
