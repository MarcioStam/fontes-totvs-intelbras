/******************************************************************************
*      Programa .....: EN0503-UPC.P                                           *
*      Data .........: 04 de Abril de 2022                                    *
*      Sistema ......: EN - ENGENHARIA                                        *
*      Empresa ......: iDBA                                                   *
*      Cliente ......: Intelbras                                              *
*      Programador ..: Mauricio                                               *
*      Objetivo .....: UPC para o EN0503                                      *
*******************************************************************************
*      VERSAO      DATA        RESPONSAVEL   MOTIVO                           *
*      1.00.00.000 04/04/2022  Mauricio      Desenvolvimento                  *
*      1.00.00.001 20/05/2022  Mauricio      Qtd Cons.                        *
******************************************************************************/
{include/i-prgvrs.i "en0503-epc" 1.00.00.001}

define input param p-ind-event  as char          no-undo.
define input param p-ind-object as char          no-undo.
define input param p-wgh-object as handle        no-undo.
define input param p-wgh-frame  as widget-handle no-undo.
define input param p-cod-table  as char          no-undo.
define input param p-row-table  as rowid         no-undo.

def var c-objeto     as char          no-undo.
def var h-br-table   AS handle        no-undo.
def var wh-qtde-cons as widget-handle no-undo.
def var wh-desc-item as widget-handle no-undo.
def var i-cont       as inte          no-undo.

def var h-objeto         as widget-handle no-undo.
def var h-this-procedure as widget-handle no-undo.
DEF VAR h-field          AS        HANDLE NO-UNDO.

def new global shared var h-container as handle no-undo.

/* Tempor ria para controle */
{upc/en0503-upc.i}

assign c-objeto = entry(num-entries(p-wgh-object:file-name,'~/'),p-wgh-object:file-name,'~/') no-error.

/* message "P-ind-event  = " p-ind-event    skip        */
/*           "P-ind-object = " p-ind-object skip        */
/*           "P-wgh-object = " p-wgh-object skip        */
/*           "P-wgh-frame  = " p-wgh-frame  skip        */
/*           "P-cod-table  = " p-cod-table  skip        */
/*           "p-row-table  = " string(p-row-table) skip */
/*           view-as alert-box.                         */

if  p-ind-event  = 'before-initialize'
and p-ind-object = 'container'
then do:
     assign h-container = p-wgh-object
            h-br-table  = ?.

     run pi-recupera-campo (input p-wgh-frame:first-child).

     assign h-objeto = p-wgh-object.
     
     do while valid-handle(h-objeto):
         if h-objeto:file-name = "enp/en0503.w"
         then do:
              assign h-this-procedure = h-objeto.
              leave.
         end.
     
         assign h-objeto = h-objeto:next-sibling.
     end.

     if valid-handle(h-br-table)
     then do:
          IF VALID-HANDLE(h-this-procedure)
          THEN DO:
               ASSIGN h-field = h-br-table:GET-BROWSE-COLUMN(4).

               IF VALID-HANDLE(h-field)
               THEN DO:
                    IF h-field:LABEL = "Un Ciclo"
                    THEN.
                    else DO i-cont = 1 TO h-br-table:NUM-COLUMNS:
                             assign h-field = h-br-table:get-browse-column(i-cont).

                             IF h-field:LABEL = "Un Ciclo"
                             THEN leave.
                             
                             assign h-field = ?.
                         END.

                    IF VALID-HANDLE(h-field)
                    THEN DO:
                         assign h-field:label   = "".
                         assign h-field:visible = no.
            
                         assign wh-qtde-cons           = h-br-table:add-calc-column("INTEGER",">>>>>>>>9","","Qtd Cons",4)
                                wh-qtde-cons:read-only = true.
                    END. /* if valid-handle(h-field) */
               END. /* if valid-handle(h-field) */
          END. /* IF VALID-HANDLE(h-this-procedure) */

          for first tt-esen0503
              where tt-esen0503.br-table = h-br-table:
              delete tt-esen0503.
          end.

          create tt-esen0503.
          assign tt-esen0503.br-table      = h-br-table
                 tt-esen0503.wgh-container = h-container
/*                  tt-esen0503.ult-camp      = "ferramenta" */
                 tt-esen0503.ult-camp      = "i-sequencia"
                 tt-esen0503.lg-desc       = yes.
          find current tt-esen0503 no-error.

          assign wh-desc-item           = h-br-table:add-calc-column("CHARACTER","x(15)","","Tipo",20)
                 wh-desc-item:read-only = true.

/*           assign h-br-table:allow-column-searching = true.                                   */
/*                                                                                              */
/*           ON start-search OF h-br-table persistent run upc/en0503-upca.p (input h-br-table). */
          ON row-display  of h-br-table persistent run upc/en0503-upcb.p (input h-br-table:query,
                                                                          input wh-desc-item,
                                                                          INPUT wh-qtde-cons).
     end.
end.

if  p-ind-event  = 'before-initialize'
and p-ind-object = 'browser'
and valid-handle(h-container)
then do:
     for first tt-esen0503
         where tt-esen0503.wgh-container = h-container: end.

     assign tt-esen0503.wgh-browser = p-wgh-object
            h-container             = ?.
end.

if  p-ind-event  = 'after-open-query'
and p-ind-object = 'browser'
and p-cod-table  = 'op-ferram'
then do:
     for first tt-esen0503
         where tt-esen0503.wgh-browser = p-wgh-object: end.

     if not avail tt-esen0503
     then return.

     assign tt-esen0503.r-rowid = ?.

     if can-find(first op-ferram where
                       rowid(op-ferram) = p-row-table
                       no-lock)
     then assign tt-esen0503.r-rowid = p-row-table.

    /*if  tt-esen0503.ult-camp = "ferramenta"
     and tt-esen0503.lg-desc  = yes
     then.
     else*/ run pi-ordena.
end.

if  p-ind-event  = 'destroy'
and p-ind-object = 'container'
then for first tt-esen0503
         where tt-esen0503.wgh-container = p-wgh-object:
         delete tt-esen0503.
     end.

/********** PROCEDURES **********/
procedure pi-recupera-campo:
    def input parameter h_frame_cad as widget-handle no-undo.

    def var h_frame_cad2 as widget-handle no-undo.

    assign h_frame_cad = h_frame_cad:parent.

    do while valid-handle(h_frame_cad):
        assign h_frame_cad2 = h_frame_cad
               h_frame_cad  = h_frame_cad:parent.
    end.

    assign h_frame_cad = h_frame_cad2.
    assign h_frame_cad = h_frame_cad:first-child.

    run pi-localiza (input h_frame_cad,
                     input h_frame_cad2).

    return "OK":U.
end procedure. /* procedure pi-recupera-campo */

procedure pi-localiza:
    def input param p-wh-objeto-cad as widget-handle no-undo.
    def input param p-wh-frame-cad  as widget-handle no-undo.

    def var wh-objeto-cad as widget-handle no-undo.

    if valid-handle(h-br-table)
    then return "OK".

    do while valid-handle(p-wh-objeto-cad):
        if p-wh-objeto-cad:type = 'FRAME'
        then do:
             assign wh-objeto-cad = p-wh-objeto-cad:first-child.
             assign wh-objeto-cad = wh-objeto-cad:first-child.

             run pi-localiza (input  wh-objeto-cad,
                              input  p-wh-objeto-cad).
        end.

        if  p-wh-objeto-cad:type = "BROWSE"
        and p-wh-objeto-cad:name = "br-table"
        then do:
             assign h-br-table = p-wh-objeto-cad:handle.
             return "OK".
        end.

        assign p-wh-objeto-cad = p-wh-objeto-cad:next-sibling.
    end. /* do while valid-handle(p-wh-objeto-cad) */

    return "OK".
end procedure. /* pi-localiza */

procedure pi-ordena:
    def buffer bb-op-ferram for op-ferram.

    for first b-op-ferram fields(num-id-operacao)
        where rowid(b-op-ferram) = tt-esen0503.r-rowid
              no-lock: end.
    
    if not avail b-op-ferram
    then return.

    find bb-op-ferram where
         bb-op-ferram.num-id-operacao = b-op-ferram.num-id-operacao
     and bb-op-ferram.op-altern       = 0
         no-lock no-error.

    if avail bb-op-ferram
    then return.

    assign c-leitura = "for each op-ferram where 
                                 op-ferram.num-id-operacao = " + string(b-op-ferram.num-id-operacao) + " 
                             and op-ferram.op-altern = 0 no-lock,
                            each ferr-prod where
                                 ferr-prod.cod-ferr-prod = op-ferram.ferramenta outer-join no-lock".
    
    case tt-esen0503.ult-camp:
        when "ferramenta"
        then assign c-leitura = c-leitura + " by op-ferram.ferramenta".
        when "i-sequencia"
        then assign c-leitura = c-leitura + " by int(substring(op-ferram.char-1,1,3))".
        otherwise return.
    end case.   
    
    if not tt-esen0503.lg-desc
    then do:
         assign c-leitura = c-leitura + " desc".
    
         if tt-esen0503.ult-camp = "i-sequencia"
         then assign c-leitura = c-leitura + " by op-ferram.ferramenta desc".
    end.    
    
    h-qry-hdl = tt-esen0503.br-table:query.
    h-qry-hdl:query-close().
    h-qry-hdl:query-prepare(c-leitura).
    h-qry-hdl:query-open().
end procedure. /* procedure pi-ordena */

