{include/i-prgvrs.i ESCEP001 2.04.00.001}
/***********************************************************************
**  Programa..: ESP\CEP\ESCEP001RP.P
**  Autor.....: Evandro P. Pezzi
**  Data......: FEVEREIRO/2008 - Desenvolvimento
**  Descricao.: Registrar defeitos por mes/ano/item
**  Vers∆o....: 001 26/02/2008
**                  Desenvolvimento Programa
************************************************************************/

DISABLE TRIGGERS FOR LOAD OF ITEM.

/****************************  Definitions  ****************************/
    
{cdp/cdcfgman.i} /* Pre-processadores */

/****************************  Temp-Tables  ****************************/
{cdp/cd0666.i}
{esp/cep/escep027tt.i}
{cpp/cpapi001.i}
{cpp/cpapi001.i1}
{utp/utapi019.i}
define variable cMensagem  as character   no-undo.

def temp-table tt-saldo
    field it-codigo like item.it-codigo
    field it-altern like it-altern.it-altern
    field saldo like saldo-estoq.qtidade-atu
    index codigo is primary it-codigo.

/****************************  Variaveis    ****************************/
{include/i-rpvar.i}

/****************************  Frames       ****************************/

/*form tt-ppm.it-codigo           format "x(7)"   column-label "Item"
     tt-ppm.desc-item           format "x(50)"  column-label "Descriá∆o"
     tt-ppm.qt-req                              column-label "Qtde Requisitada"
     tt-ppm.qt-cons                             column-label "Qtde Consumida"
     tt-ppm.ppm-linha                           column-label "PPM Linha"
     tt-ppm.pr-item                             column-label "Preáo Item"
     with width 132 no-box down frame f-ppm stream-io.

form tt-deposito.cod-depos                      column-label "Deposito"
     tt-deposito.quantidade                     column-label "Quantidade"
     with width 132 no-box down frame f-depos stream-io.*/


def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

def var h-acomp      as handle no-undo.

DEF BUFFER bitem FOR ITEM.

FOR FIRST param-global NO-LOCK,
    FIRST mgcad.empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-prin: END.
FOR FIRST param-estoq NO-LOCK: END.

assign c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "ACA - Gera Itens Acabados"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "ESCEP027"
       c-versao       = "2.04"
       c-revisao      = "001".

function f-gera-numero-op-automatica returns integer.
    def var i-nr-ord-prod as  integer no-undo.
    def buffer b-ord-prod for ord-prod.

    find first param-cp no-lock no-error.
    find first param-global no-lock no-error. 
    for last  b-ord-prod fields (nr-ord-produ)
        where b-ord-prod.nr-ord-produ <= param-cp.ult-ord-aut-cp
          and b-ord-prod.nr-ord-produ >= param-cp.prim-ord-aut-cp no-lock: end.
    if avail b-ord-prod then do:
       assign i-nr-ord-prod = b-ord-prod.nr-ord-produ + 1.
       if i-nr-ord-prod > param-cp.ult-ord-aut-cp then
          assign i-nr-ord-prod = param-cp.prim-ord-aut-cp.
    end.
    else 
       assign i-nr-ord-prod = param-cp.prim-ord-aut-cp.    
    repeat:
           if can-find (b-ord-prod where 
                        b-ord-prod.nr-ord-produ = i-nr-ord-prod no-lock) then do:
              assign i-nr-ord-prod = i-nr-ord-prod + 1.

              /* --- Bancos Hist¢ricos --- */
              if param-global.modulo-bh then do:
                 find last his-ord-prod no-lock no-error.
                 if avail his-ord-prod and
                    his-ord-prod.nr-ord-produ > i-nr-ord-prod then
                    assign i-nr-ord-prod = (his-ord-prod.nr-ord-produ + 1).
              end.
              /* ------------------------- */

              if i-nr-ord-prod > param-cp.ult-ord-aut-cp then return -1.         
           end. 
           else if param-global.modulo-mi and
                   can-find (ord-manut where 
                             ord-manut.nr-ord-produ = i-nr-ord-prod) then
                   assign i-nr-ord-prod = i-nr-ord-prod + 1.
                else leave.
    end.

    find current param-cp exclusive-lock.
    assign param-cp.prox-ord-aut = i-nr-ord-prod + 1.
    find current param-cp no-lock.
    return i-nr-ord-prod.

end function.

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    {include/i-rpcab.i}
    {include/i-rpout.i}
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

    RUN utp/ut-acomp.p persistent set h-acomp.  
    RUN pi-inicializar in h-acomp (input "Imprimindo...").
    RUN piImprimeRelat.

    run pi-finalizar in h-acomp.
    {include/i-rpclo.i}
    RETURN "OK".
end.

/* **********************  Internal Procedures  *********************** */

PROCEDURE piImprimeRelat:
    def var l-erro as log.
    def var i-nro-ord-seq as int.
    def var i-nr-ord-prod like ord-prod.nr-ord-prod.

    for each tt-saldo.
        delete tt-saldo.
    end.
    for each tt-erro.
        delete tt-erro.
    end.

    for each it-altern no-lock:
        for each saldo-estoq no-lock 
           where saldo-estoq.cod-estabel = tt-param.cod-estabel
             and saldo-estoq.cod-depos   = "aca"
             and saldo-estoq.cod-localiz = ""
             and saldo-estoq.it-codigo   = it-altern.it-altern
             and saldo-estoq.qtidade-atu > 0:
            create tt-saldo.
            assign tt-saldo.it-codigo = it-altern.it-codigo
                   tt-saldo.it-altern = saldo-estoq.it-codigo
                   tt-saldo.saldo     = saldo-estoq.qtidade-atu.
        end.
    end.

    IF CAN-FIND(FIRST tt-saldo) THEN DO:
        PUT UNFORMATTED 
             "Item          Alternativo   Quantidade Num.Ordem" AT 01
             "------------- ------------- ---------- ---------" AT 01 SKIP.
    END.

    assign l-erro = no.
    for each tt-saldo:
        ASSIGN i-nr-ord-prod = 0.
        
        /* Tratamento Unidade de Negocio - Emerson 16/08/2012*/

        FIND FIRST item-uni-estab 
            WHERE item-uni-estab.it-codigo   = tt-saldo.it-codigo AND
                  item-uni-estab.cod-estabel = tt-param.cod-estabel NO-LOCK NO-ERROR.
        IF (NOT AVAIL item-uni-estab) OR 
           (AVAIL item-uni-estab AND item-uni-estab.cod-unid-neg = "") THEN DO:
            NEXT.
        END.

        
        FIND FIRST bitem no-lock where bitem.it-codigo = tt-saldo.it-altern no-error.
        find item where item.it-codigo = tt-saldo.it-codigo no-error.

        IF AVAIL bitem AND 
            bitem.contr-qualid = YES AND
            ITEM.contr-qualid = NO THEN
            ASSIGN ITEM.contr-qualid = bitem.contr-qualid
                   ITEM.criticidade  = bitem.criticidade
                   ITEM.nivel        = bitem.nivel
                   ITEM.perc-nqa     = bitem.perc-nqa.

        ASSIGN i-nr-ord-prod = f-gera-numero-op-automatica().

        find first ord-prod
             where ord-prod.nr-ord-produ = i-nr-ord-prod no-lock no-error.
        if not avail ord-prod then do:
            create ord-prod.
            assign ord-prod.nr-ord-prod  = i-nr-ord-prod.
        end.            
        ELSE DO:
            PUT UNFORMATTED "Ordem Produá∆o j† existente: " i-nr-ord-prod SKIP.
            NEXT.
        END.

     /* find lin-prod no-lock 
            where lin-prod.nr-linha = item.nr-linha no-error.  */

        FIND FIRST lin-prod
            WHERE lin-prod.cod-estabel = tt-param.cod-estabel
              AND lin-prod.nr-linha    = 20 NO-LOCK NO-ERROR.

        bk-ponto-prog:
        FOR FIRST ponto-programa NO-LOCK
            WHERE ponto-programa.nome-programa = "escep027":U
              AND ponto-programa.ponto         = 1,
            EACH conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
            IF conteudo-programa.conteudo = tt-saldo.it-codigo THEN DO:
                FIND FIRST lin-prod
                    WHERE lin-prod.cod-estabel = tt-param.cod-estabel
                      AND lin-prod.nr-linha    = 15 NO-LOCK NO-ERROR.

                LEAVE bk-ponto-prog.
            END.
        END.

        assign ord-prod.it-codigo    = tt-saldo.it-codigo
               ord-prod.qt-ordem     = tt-saldo.saldo
               ord-prod.un           = item.un
               ord-prod.dt-inicio    = today
               ord-prod.dt-termino   = today
               ord-prod.cd-planejado = if avail lin-prod then lin-prod.cd-planejado else ""
               ord-prod.cod-depos    = "aca"
               ord-prod.ct-codigo    = lin-prod.ct-ordem 
               ord-prod.sc-codigo    = lin-prod.sc-ordem 
               ord-prod.conta-ordem  = lin-prod.conta-ordem
               ord-prod.nr-linha     = lin-prod.nr-linha
               ord-prod.cod-estabel  = tt-param.cod-estabel
               ord-prod.dt-orig      = today
               ord-prod.valorizada   = no
               ord-prod.reporte-mob  = 2
               ord-prod.calc-cs-mat  = 2
               ord-prod.origem       = "cp"
               ord-prod.cod-unid-neg = item-uni-estab.cod-unid-neg.

        find item no-lock where item.it-codigo = tt-saldo.it-altern.

        create reservas.
        assign reservas.nr-ord-prod = i-nr-ord-prod
               reservas.it-codigo   = tt-saldo.it-altern
               reservas.dt-reserva  = today
               reservas.quant-orig  = tt-saldo.saldo
               reservas.cod-localiz = ""
               reservas.cod-depos   = "aca"
               reservas.item-pai    = tt-saldo.it-codigo 
               reservas.un          = item.un.
        for each tt-rep-prod:
            delete tt-rep-prod.
        end.

        for each tt-res-neg:
            delete tt-res-neg.
        end.

        create tt-rep-prod.
        assign tt-rep-prod.nr-ord-prod   = i-nr-ord-prod
               tt-rep-prod.it-codigo     = tt-saldo.it-codigo
               tt-rep-prod.cod-depos-sai = "aca"
               tt-rep-prod.cod-local-sai = ""
               tt-rep-prod.data          = today
               tt-rep-prod.qt-reporte    = tt-saldo.saldo
               tt-rep-prod.qt-refugo     = 0
               tt-rep-prod.un           = item.un
               /* tt-rep-prod.conta-refugo = "000000000000000"  Retirado TOTVS11 */
               tt-rep-prod.qt-apr-cond  = 0
               tt-rep-prod.nro-docto    = string(ord-prod.nr-ord-prod)
               tt-rep-prod.serie-docto  = "MPE"
               tt-rep-prod.cod-depos    = "aca"
               tt-rep-prod.cod-localiz  = ""
               tt-rep-prod.lote-serie   = ""
               tt-rep-prod.cod-refer    = ""
               tt-rep-prod.dt-vali-lote = ?
            /*   tt-rep-prod.estado       = "I" */
           /*  i-linha                  = i-linha + 1 
               tt-rep-prod.linha        = i-linha        */
               tt-rep-prod.linha        = 20
               tt-rep-prod.reserva      = no
               i-nro-ord-seq            = i-nro-ord-seq + 1
               tt-rep-prod.nro-ord-seq  = i-nro-ord-seq
               cod-versao-integracao    = 1. 

        create tt-res-neg.
        assign tt-res-neg.nr-ord-produ  = ord-prod.nr-ord-prod
               tt-res-neg.it-codigo     = tt-saldo.it-altern
               tt-res-neg.quantidade    = tt-saldo.saldo 
               tt-res-neg.cod-depos     = "aca"
               tt-res-neg.cod-localiz   = ""
               tt-res-neg.lote-serie    = ""
               tt-res-neg.cod-refer     = ""
               tt-res-neg.dt-vali-lote  = ?
               tt-res-neg.positivo      = yes
               tt-res-neg.nro-ord-seq   = i-nro-ord-seq.

        for each tt-rep-prod :
            for each tt-res-neg
               where tt-res-neg.nro-ord-seq = tt-rep-prod.nro-ord-seq:
               find item where item.it-codigo = tt-res-neg.it-codigo EXCLUSIVE-LOCK NO-ERROR.   
               IF AVAIL ITEM AND item.tipo-requis <> 2 then do:
                    assign item.tipo-requis = 2.
                end. 
            end.
        end.

        RUN pi-acompanhar IN h-acomp (INPUT "Item: " + tt-saldo.it-codigo + " - Quant: " + STRING(tt-saldo.saldo)).
        run cpp/cpapi001.p (input-output table tt-rep-prod,
                            input        table tt-refugo,
                            input        table tt-res-neg,
                            input        table tt-apont-mob,
                            input-output table tt-erro,
                            input        yes).

        PUT UNFORMATTED
            tt-saldo.it-codigo   AT 01
            tt-saldo.it-altern   AT 15
            tt-saldo.saldo       TO 38
            i-nr-ord-prod        TO 48  SKIP.
                             
        IF NOT AVAIL tt-erro THEN DO:
            /***
            FIND FIRST reservas-ast
                WHERE reservas-ast.cod-estabel  = tt-param.cod-estabel
                  AND reservas-ast.cod-depos    = 'EXP'
                  AND reservas-ast.it-codigo    = tt-saldo.it-codigo NO-LOCK NO-ERROR.
            IF AVAIL reservas-ast THEN DO:

               assign cMensagem = cMensagem + '~nSaldo dispon°vel para movimentaá∆o: Estab: ' + reservas-ast.cod-estabel + ', Dep¢sito: ' + reservas-ast.cod-depos + ', ITEM: ' + reservas-ast.it-codigo + '~n'.
            
                /** Manda e-mail **/
                if (cMensagem <> '') THEN DO:
               
                    FOR FIRST ponto-programa
                        WHERE ponto-programa.nome-programa = "escep027"
                          AND ponto-programa.ponto         = 2,
                         EACH conteudo-programa exclusive-lock
                        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
                
                        run enviaMail (input 'ems@intelbras.com.br', input conteudo-programa.conteudo, input 'Saldo Dispon°vel para Transferància', input cMensagem).

                    END. /* FOR FIRST ponto-programa */

                END. /* if (cMensagem <> '') THEN DO: */

            END. /* IF AVAIL reservar-ast THEN DO: */
            ***/
        END. /* IF NOT AVAIL tt-erro THEN DO: */

    end. /* do for each tt-saldo */

    find first tt-erro no-lock no-error.
    if avail tt-erro then do:
        PUT UNFORMATTED 
             "Erro    Descricao" AT 01
             "------- ----------------------------------------------------------------------------------------------------" AT 01 SKIP.
        FOR EACH tt-erro:
            PUT UNFORMATTED    
                tt-erro.cd-erro  AT 01
                tt-erro.mensagem AT 08.
        END.
    end.

    PUT UNFORMATTED SKIP(1) 
        "Transferencia de Saldos Executada !" SKIP.

END PROCEDURE.


PROCEDURE enviaMail:

    define input parameter pRemetente      as character no-undo.
    define input parameter pDestinatario   as character no-undo.
    define input parameter pAssunto        as character no-undo.
    define input parameter pMensagem       as character no-undo.
    
    define variable h-utapi019 as handle      no-undo.
    
    create tt-envio2.
    assign tt-envio2.versao-integracao  = 1
           tt-envio2.servidor           = param-global.serv-mail
           tt-envio2.porta              = param-global.porta-mail
           tt-envio2.exchange           = param-global.log-1
           tt-envio2.remetente          = pRemetente
           tt-envio2.destino            = pDestinatario
           tt-envio2.assunto            = pAssunto
           tt-envio2.mensagem           = pMensagem
           tt-envio2.arq-anexo          = ''
           tt-envio2.importancia        = 1
           tt-envio2.log-enviada        = no
           tt-envio2.log-lida           = no
           tt-envio2.acomp              = no
           tt-envio2.formato            = 'TEXTO'.
    
    run utp/utapi019.p persistent set h-utapi019.
    run pi-execute in h-utapi019 (input table tt-envio2, output table tt-erros).
    delete object h-utapi019.

END PROCEDURE.

