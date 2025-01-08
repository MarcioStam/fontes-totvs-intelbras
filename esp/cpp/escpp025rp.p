/***********************************************************************
**  Programa..: ESP\CPP\ESCPP025RP.P
**  Autor.....: Giovane - Developer
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCPP025 2.04.00.001}

/****************************  Definitions  ****************************/
{esp/cpp/escpp025tt.i}
{include/i-rpvar.i}
{utp/ut-glob.i}
{cep/ceapi001k.i}
{cdp/cd0666.i}
def var i-sequen as int no-undo.
DEF VAR c-sc-codigo AS CHAR NO-UNDO.
DEF VAR c-ct-codigo AS CHAR NO-UNDO.
DEF VAR dt-data AS DATE NO-UNDO.

DEF VAR h-ceapi001k      AS HANDLE NO-UNDO.

/****************************  Temp-Tables  ****************************/

def buffer b-tt-erro for tt-erro.
def buffer b-movto-estoq for movto-estoq.

/****************************  Variaveis    ****************************/
DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.
for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

DEF VAR h-acomp      AS HANDLE NO-UNDO.
FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.


ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Requisi‡Æo de Perdas"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESCPP025"
       c-versao       = "2.04"
       c-revisao      = "001".

{esp/es0018.i}
def var l-congelado as logical no-undo.
def var i-quantidade like movto-estoq.quantidade no-undo.
def var de-perc-perda like int-familia.perc-perda no-undo.
def var l-valido as logical no-undo.
def var c-un like item.un no-undo.

def temp-table tt-itens no-undo
    field it-codigo like item.it-codigo
    field cod-estabel like movto-estoq.cod-estabel
    field desc-item like item.desc-item
    field un like item.un
    field quantidade like movto-estoq.quantidade
    field perc-perda like int-familia.perc-perda
    field dt-trans like movto-estoq.dt-trans
    field cod-depos as char
    field ct-codigo as char
    field sc-codigo as char
    index codigo is primary cod-estabel cod-depos it-codigo ct-codigo sc-codigo dt-trans.
    
def temp-table tt-itens-erro no-undo 
    field cod-estabel like movto-estoq.cod-estabel
    field cod-depos like deposito.cod-depos    
    field it-codigo like item.it-codigo
    field dt-trans  like movto-estoq.dt-trans
    field cd-erro   as inte
    field mensagem  as char format "x(60)"
    index chapri cod-estabel cod-depos it-codigo.
    
def buffer b-tt-itens for tt-itens.    

find first tt-param no-error.
if NOT tt-param.considera then
    assign tt-param.data-ini = TODAY - 1
           tt-param.data-fim = tt-param.data-ini.    


/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
    {include/i-rpcab.i}
    {include/i-rpout.i}
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
  
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar IN h-acomp (INPUT "Lendo movimentos...").
    RUN pi-gera-tt.
    RUN pi-atualiza.

    RUN pi-finalizar IN h-acomp.

    {include/i-rpclo.i}

    RETURN "OK".
END.



/* **********************  Internal Procedures  *********************** */
procedure pi-gera-tt:    
    RUN esp/es0018p.p (INPUT "ESCPP025", /* Nome do programa */
                       INPUT 1,          /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto).   

    
    DO dt-data = tt-param.data-ini TO tt-param.data-fim:
        for each movto-estoq no-lock
           where movto-estoq.cod-estabel = tt-param.cod-estabel
             AND movto-estoq.dt-trans = dt-data
             AND movto-estoq.cod-depos = tt-param.cod-depos
             AND movto-estoq.esp-docto = 28:   /* REQ */

            {esp/cpp/escpp025rp1.i}

        end. /* for each movto-estoq */
        for each movto-estoq no-lock
           where movto-estoq.cod-estabel = tt-param.cod-estabel
             AND movto-estoq.dt-trans = dt-data
             AND movto-estoq.cod-depos = tt-param.cod-depos
             AND movto-estoq.esp-docto = 31:   /* RRQ */

            {esp/cpp/escpp025rp1.i}

        end. /* for each movto-estoq */
    END.
end procedure.

procedure pi-atualiza:        
    for each tt-itens:
        if tt-itens.quantidade > 0 AND 
           tt-itens.perc-perda > 0 then do:
            assign tt-itens.quantidade = int(tt-itens.quantidade * tt-itens.perc-perda / 100).
        end.
        
        if tt-itens.quantidade <= 0 OR 
           tt-itens.perc-perda = 0 then do:
            delete tt-itens.
            next.
        end.
                
        for each tt-movto:
            delete tt-movto.
        end.
        create tt-movto.        
        assign tt-movto.cod-versao-integracao = 001
               tt-movto.cod-prog-orig  = c-programa
               tt-movto.cod-depos      = tt-itens.cod-depos
               tt-movto.cod-localiz    = ""
               tt-movto.cod-estabel    = tt-param.cod-estabel
               tt-movto.ct-codigo      = tt-itens.ct-codigo
               tt-movto.sc-codigo      = tt-itens.sc-codigo
               tt-movto.esp-docto      = 28   /* REQ */
               tt-movto.it-codigo      = tt-itens.it-codigo
               tt-movto.nro-docto      = "100"
               tt-movto.quantidade     = tt-itens.quantidade
               tt-movto.serie-docto    = "RP2"
               tt-movto.tipo-trans     = 2     /* saida */
               tt-movto.un             = tt-itens.un
               tt-movto.num-sequen     = 1
               tt-movto.dt-trans       = tt-itens.dt-trans
               tt-movto.descricao-db   = substitute("Requisi‡Æo autom tica de perda &1 %", string(tt-itens.perc-perda,">>9.99")) 
               tt-movto.usuario        = c-seg-usuario.        
   
        RUN pi-acompanhar IN h-acomp (INPUT "Gerando movimentos. Aguarde...").
        run pi-desabilita-cancela in h-acomp.

        /* Nova api de transferencia EMS206 */
        run cep/ceapi001k.p persistent set h-ceapi001k.
        if  valid-handle (h-ceapi001k) then do:
            run pi-execute IN h-ceapi001k (input-output table tt-movto,
                                           input-output table tt-erro, 
                                           input        yes).
    
            RUN pi-deleta-handle IN h-ceapi001k.
            delete procedure h-ceapi001k.
            assign h-ceapi001k = ?.
        end.
        
        find first tt-erro no-error.
        if avail tt-erro then do:
            for each tt-erro:
                create tt-itens-erro.
                assign tt-itens-erro.it-codigo   = tt-itens.it-codigo
                       tt-itens-erro.cod-estabel = tt-itens.cod-estabel                    
                       tt-itens-erro.cod-depos   = tt-itens.cod-depos
                       tt-itens-erro.dt-trans    = tt-itens.dt-trans
                       tt-itens-erro.cd-erro     = tt-erro.cd-erro
                       tt-itens-erro.mensagem    = tt-erro.mensagem + " - " + tt-itens.ct-codigo + " - " + tt-itens.sc-codigo.
                delete tt-erro.                       
            end.
        end.    
    end.
  
    find first tt-itens-erro no-error.   
    if avail tt-itens-erro AND
             tt-itens-erro.cd-erro > 0 then do:
        put "Foram encontrados ERROS durante a atualiza‡Æo. VERIFICAR ITENS COM ERROS!!!" skip(1)
            "Seq Erro    Item             Descri‡Æo" skip
            "--- ------- ---------------- ------------------------------------------------------------------------------------------------------" skip.
        for each tt-itens-erro
           where tt-itens-erro.cd-erro > 0:
            i-sequen = i-sequen + 1.
            if tt-itens-erro.dt-trans <> ? then
                assign tt-itens-erro.mensagem = string(tt-itens-erro.dt-trans) + " - " + tt-itens-erro.mensagem.
                           
            put i-sequen format ">>9" " "
                tt-itens-erro.cd-erro format ">>>,>>9" " "
                tt-itens-erro.it-codigo format "x(16)" " "
                tt-itens-erro.mensagem format "x(100)" skip. 
        end.
        put skip(1).     
    end.

    for each tt-itens:
        if can-find (first tt-itens-erro
                     where tt-itens-erro.cod-estabel = tt-itens.cod-estabel
                       and tt-itens-erro.cod-depos   = tt-itens.cod-depos
                       and tt-itens-erro.it-codigo   = tt-itens.it-codigo
                       and tt-itens-erro.dt-trans    = tt-itens.dt-trans) then next.         
           
         disp tt-itens.it-codigo
              tt-itens.desc-item
              tt-itens.dt-trans
              tt-itens.perc-perda label "% Perda"
              tt-itens.quantidade  label "Requisitado"
              tt-itens.perc-perda
              label "REQ Perda"
              with width 132 no-box stream-io.
         down.     
    end.
end procedure.

procedure congelado.
    def input parameter co-it-codigo like item.it-codigo.
    def input parameter co-cod-depos like saldo-estoq.cod-depos.
    def input parameter co-localizacao like saldo-estoq.cod-localiz.

    if co-localizacao <> ? then do:
    
        find saldo-estoq no-lock
             where saldo-estoq.cod-estabel = tt-param.cod-estabel
               and saldo-estoq.cod-depos   = co-cod-depos
               and saldo-estoq.it-codigo   = co-it-codigo
               and saldo-estoq.cod-localiz = co-localizacao no-error.
        if not avail saldo-estoq then do:
            assign l-congelado = no.
            next.
        end.
        
        find int-saldo-estoq
             where int-saldo-estoq.cod-estabel = saldo-estoq.cod-estabel
               and int-saldo-estoq.cod-depos   = saldo-estoq.cod-depos
               and int-saldo-estoq.it-codigo   = saldo-estoq.it-codigo
               and int-saldo-estoq.cod-localiz = saldo-estoq.cod-localiz
                   no-lock no-error.
        if avail int-saldo-estoq and int-saldo-estoq.log-congelado then 
                assign l-congelado = yes.
        else    
            assign l-congelado = no.


    end.
    else do:
        assign l-congelado = no.
        for each saldo-estoq no-lock
             where saldo-estoq.cod-estabel = tt-param.cod-estabel
               and saldo-estoq.cod-depos   = co-cod-depos
               and saldo-estoq.it-codigo   = co-it-codigo :
            find int-saldo-estoq
                 where int-saldo-estoq.cod-estabel = saldo-estoq.cod-estabel
                   and int-saldo-estoq.cod-depos   = saldo-estoq.cod-depos
                   and int-saldo-estoq.it-codigo   = saldo-estoq.it-codigo
                   and int-saldo-estoq.cod-localiz = saldo-estoq.cod-localiz
                       no-lock no-error.
            if avail int-saldo-estoq and int-saldo-estoq.log-congelado then 
                        assign l-congelado = yes.

        end.
    end.
end procedure.
