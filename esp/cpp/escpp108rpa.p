/***********************************************************************
**  Programa..: ESP\CCP\escpp108rpaRP.P
**  Descricao.: Relatorio de Ordens Compra Exterma - Sem saldo de terceiros
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i escpp108rpa 2.04.00.000}

/****************************  Definitions  ****************************/
define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer.

define temp-table tt-digita no-undo
    FIELD l-sel            AS LOGICAL LABEL ''
    FIELD nr-ord-produ     LIKE ord-prod.nr-ord-prod
    FIELD quantidade       LIKE ord-prod.qt-ordem
    FIELD it-codigo        LIKE ord-prod.it-codigo
    FIELD desc-item        LIKE ITEM.desc-item
    INDEX id nr-ord-produ
    INDEX chave it-codigo.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.


{include/i-rpvar.i}

/****************************  Temp-Tables  ****************************/
/****************************  Variaveis    ****************************/
/****************************  Frames       ****************************/

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

DEFINE TEMP-TABLE tt-item-estrut NO-UNDO 
    FIELD sequencia     LIKE componente.sequencia
    FIELD it-codigo     LIKE componente.it-codigo
    FIELD nr-ord-prod   LIKE componente.nr-ord-prod
    FIELD quantidade    LIKE componente.quantidade
    FIELD preco-unit    LIKE item-doc-est.preco-unit extent 0
    FIELD preco-total   LIKE componente.preco-total  extent 0
    FIELD data-corte    LIKE componente.dt-retorno
    FIELD cod-depos     LIKE componente.cod-depos
    FIELD rw-reservas   AS   ROWID
    FIELD aux           AS   CHAR
    INDEX seq
          sequencia .

def temp-table tt-item-saldo-terc no-undo
    field rw-saldo-terc   as rowid
    field quantidade      like saldo-terc.quantidade
    field preco-total     like componente.preco-total extent 0
    field desconto        like componente.desconto    extent 0    
    field cod-depos       like saldo-terc.cod-depos
    field nr-ord-prod     like saldo-terc.nr-ord-prod.

def temp-table tt-item-saldo-terc-aux
    field rw-saldo-terc   as rowid
    field quantidade      like saldo-terc.quantidade
    field preco-total     like componente.preco-total extent 0
    field desconto        like componente.desconto    extent 0    
    field cod-depos       like saldo-terc.cod-depos
    field nr-ord-prod     like saldo-terc.nr-ord-prod
    field item-pai        like reservas.item-pai   
    field cod-roteiro     like reservas.cod-roteiro
    field op-codigo       like reservas.op-codigo
    field sequencia       as int
    field char-1          as char
    field int-i           as int
    field log-1           as log
    field date-1          as date.

DEFINE VARIABLE l-remessa       AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-retorno       AS LOGICAL     NO-UNDO.
DEFINE VARIABLE i-tipo-sal-terc AS INTEGER     NO-UNDO.

DEFINE VARIABLE de-saldo-ordem AS DECIMAL     NO-UNDO.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita to tt-digita.
END. 

ASSIGN l-remessa       = NO
       i-tipo-sal-terc = 1.

DEF VAR h-acomp        AS HANDLE NO-UNDO.
FOR FIRST param-global NO-LOCK.  END.
FOR FIRST empresa NO-LOCK WHERE
          empresa.ep-codigo = param-global.empresa-pri: END.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Saldo Terceiros x Ordem Produ‡Æo"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "escpp108rpa"
       c-versao       = "2.04"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
    
    {include/i-rpout.i &pagesize="0"}
    
   RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
   RUN pi-inicializar IN h-acomp (INPUT "Verificando Ordens Produ‡Æo").

   
   /* Coloquei estas linhas no programa - Clayton Antunes */
   DEF VAR i-nome-programa AS CHAR.
   DEF VAR i-ponto AS INT.
   DEF VAR i-sequencia AS INT.
   DEF VAR i-conteudo AS CHAR.

   PUT UNFORMATTED "ORDENS PRODUCAO" SKIP(1).
   FOR EACH tt-digita NO-LOCK
      WHERE tt-digita.l-sel = YES,
      FIRST ord-prod NO-LOCK
      WHERE ord-prod.nr-ord-produ = tt-digita.nr-ord-produ,
      FIRST ITEM NO-LOCK
      WHERE ITEM.it-codigo = ord-prod.it-codigo:

       ASSIGN de-saldo-ordem = if   ord-prod.qt-ordem - ord-prod.qt-produzida > 0
                               then ord-prod.qt-ordem - ord-prod.qt-produzida
                               else 0.

       DISP ord-prod.cod-estabel
            ord-prod.nr-ord-produ
            ord-prod.it-codigo
            ITEM.desc-item
            ord-prod.qt-ordem
            de-saldo-ordem COLUMN-LABEL "Saldo Ordem" WITH WIDTH 132 STREAM-IO.



       run createItembyOrdProd (INPUT ord-prod.nr-ord-produ, INPUT ord-prod.qt-ordem, INPUT de-saldo-ordem).
   END.

   PUT UNFORMATTED SKIP(2) "ITENS SEM SALDO TERCEIROS" SKIP(1).

   run pi-inicializar in h-acomp ("Calculando Saldo Terceiros").
   run pi-acompanhar in h-acomp ("Saldo em Terceiros").

   RUN verificaSaldoTerc (INPUT TODAY).

   RUN pi-finalizar in h-acomp.
   
   {include/i-rpclo.i}

   RETURN "OK".
END.

PROCEDURE createItembyOrdProd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piOrdProd    like componente.nr-ord-prod no-undo.
    def input param piQuantidade like componente.quantidade  no-undo.
    def input param piSaldo      like componente.quantidade  no-undo.
        
    def var de-qtd-saldo         like componente.quantidade  no-undo.
    def var i-sequencia          like componente.sequencia   no-undo.
    def var l-reserva            as logical                  no-undo.
    
    find last tt-item-estrut no-lock no-error.
    
    assign i-sequencia = if  avail tt-item-estrut then 
                             tt-item-estrut.sequencia + 10
                         else 
                             10.
                             
           
    for each reservas 
        fields (reservas.nr-ord-prod
                reservas.quant-orig 
                reservas.quant-atend
                reservas.quant-terc
                reservas.it-codigo)
        where reservas.nr-ord-prod = piOrdProd
        and   reservas.quant-orig  > 0 no-lock:
     
        assign de-qtd-saldo = reservas.quant-orig - (reservas.quant-atend + reservas.quant-terc).
     
        if  l-remessa 
        and de-qtd-saldo <= 0 then 
            next.
            

        create tt-item-estrut.
        assign tt-item-estrut.sequencia   = i-sequencia
               tt-item-estrut.aux         = "*"
               tt-item-estrut.it-codigo   = reservas.it-codigo
               tt-item-estrut.nr-ord-prod = reservas.nr-ord-prod
               /*tt-item-estrut.cod-depos   = c-deposito*/
               tt-item-estrut.quantidade  = piSaldo * reservas.quant-orig / piQuantidade
               tt-item-estrut.rw-reservas = rowid(reservas)
               i-sequencia                = i-sequencia + 10.
                                                                  
        assign l-reserva = yes.
        
        if  l-remessa 
        and tt-item-estrut.quantidade > de-qtd-saldo then 
            assign tt-item-estrut.quantidade = de-qtd-saldo.
     
        if  l-retorno 
        and tt-item-estrut.quantidade > (reservas.quant-orig - reservas.quant-atend) then 
            assign tt-item-estrut.quantidade = (reservas.quant-orig - reservas.quant-atend).

    end.
    
    if  not l-reserva then do:
        RETURN "NOK".
        
    end.
    else RETURN "OK":U.
    
END PROCEDURE.

PROCEDURE verificaSaldoTerc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        
    def input param piDataTrans        like saldo-terc.dt-retorno           no-undo.
    
    def var de-quantidade              like saldo-terc.quantidade           no-undo.
    def var de-qtd-saldo               like saldo-terc.quantidade           no-undo.
    def var de-tot-alocado             like saldo-terc.quantidade           no-undo.
    def var de-preco-total             like componente.preco-total extent 0 no-undo.
    def var de-valor-calc              like componente.preco-total extent 0 no-undo.
    def var de-valor-max               like componente.preco-total extent 0 no-undo.
    def var de-valor-min               like componente.preco-total extent 0 no-undo.
    def var de-valor-inf               like componente.preco-total extent 0 no-undo.
    DEF VAR c-item-pai                 LIKE item-doc-est.item-pai           NO-UNDO.
    DEF VAR c-cod-roteiro              LIKE item-doc-est.cod-roteiro        NO-UNDO.
    DEF VAR i-op-codigo                LIKE item-doc-est.op-codigo          NO-UNDO.
    DEF VAR c-nro-docto                LIKE item-doc-est.nro-docto          NO-UNDO.

    DEFINE VARIABLE de-diferenca LIKE saldo-terc.quantidade COLUMN-LABEL "Diferenca" FORMAT "->>>,>>>,>>9.99" NO-UNDO.
    DEFINE VARIABLE c-ordens-prod  AS CHARACTER  COLUMN-LABEL "Ordens Producao" NO-UNDO.

    
    for each tt-item-saldo-terc:
        delete tt-item-saldo-terc.
    end.

    FOR EACH tt-item-saldo-terc-aux:
        DELETE tt-item-saldo-terc-aux.
    END.

    for each tt-item-estrut BREAK BY tt-item-estrut.it-codigo:
        
        IF FIRST-OF(tt-item-estrut.it-codigo) THEN
            assign de-quantidade   = 0
                   de-preco-total  = 0
                   c-ordens-prod   = "".

        assign de-quantidade             = de-quantidade  + tt-item-estrut.quantidade
               de-preco-total            = de-preco-total + tt-item-estrut.preco-total
               c-ordens-prod             = c-ordens-prod + IF c-ordens-prod = "" THEN STRING(tt-item-estrut.nr-ord-prod) ELSE "," + STRING(tt-item-estrut.nr-ord-prod)
               tt-item-estrut.preco-unit = tt-item-estrut.preco-total / tt-item-estrut.quantidade.

        IF LAST-OF(tt-item-estrut.it-codigo) THEN DO:

            ASSIGN de-qtd-saldo = 0.

            FIND FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo = tt-item-estrut.it-codigo NO-ERROR.

            FIND FIRST ord-prod NO-LOCK 
                 WHERE ord-prod.nr-ord-produ = tt-item-estrut.nr-ord-prod NO-ERROR.

            FIND FIRST int-param-ord-prod-monitor NO-LOCK
                 WHERE int-param-ord-prod-monitor.cod-estabel = ord-prod.cod-estabel NO-ERROR.

            for each saldo-terc use-index estab-fornec
                where saldo-terc.it-codigo     = tt-item-estrut.it-codigo
                  and saldo-terc.cod-emitente  = int-param-ord-prod-monitor.cod-emitente
                  and saldo-terc.cod-estabel   = ord-prod.cod-estabel 
                  and saldo-terc.tipo-sal-terc = i-tipo-sal-terc
                  and saldo-terc.quantidade    > 0 
                  /*and (   saldo-terc.nr-ord-prod = tt-item-estrut.nr-ord-prod
                       or saldo-terc.nr-ord-prod = 0 )*/ NO-LOCK
                by saldo-terc.dt-retorno :             

                /* --- its35061 --- */
                &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN 
                   IF i-pais-impto-usuario <> 1 AND saldo-terc.log-entreg-fut THEN
                       NEXT.
                &ENDIF

                /* O CAMPO DEC-1 ESTA SENDO UTILIZADO PARA ARMAZENAR O SALDO 
                    ALOCADO, OU SEJA, QUE JA ESTEJA SENDO UTILIZADO NA DIGITACAO 
                    DE OUTRA NOTA FISCAL 
                */

                assign de-qtd-saldo = de-qtd-saldo + saldo-terc.quantidade - saldo-terc.dec-1.
            end.            

            if de-quantidade - de-qtd-saldo > 0 then do:
                ASSIGN de-diferenca = de-qtd-saldo - de-quantidade.
                DISP tt-item-estrut.it-codigo FORMAT "x(12)" COLUMN-LABEL "Item"
                     item.desc-item  FORMAT "x(40)" COLUMN-LABEL "Descricao"
                     de-quantidade  COLUMN-LABEL "Quantidade"
                     de-qtd-saldo   COLUMN-LABEL "Saldo"
                     de-diferenca   COLUMN-LABEL "Diferenca"
                     c-ordens-prod  FORMAT "x(132)"
                     WITH WIDTH 255 STREAM-IO.

            end.
        END.
    end.

    RETURN "OK":U.            
        
END PROCEDURE.

PROCEDURE getValuesTerceiros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    def input  param piDataTrans      like componente.dt-retorno            no-undo.
    def input  param piProporcao      as dec                                no-undo.
    def input  param piQtdeItem       like componente.quantidade            no-undo.
    def output param piPrecoTotal     like componente.preco-total[1]        no-undo.
    def output param piDesconto       like componente.desconto[1]           no-undo.

    def buffer b-componente           for componente.

    def var de-valor-tot              like componente.preco-total extent 0  no-undo.
    def var de-desc-tot               like componente.desconto    extent 0  no-undo.

    for first componente 
        fields ( cod-emitente nro-docto serie-docto 
                 nat-operacao it-codigo cod-refer 
                 sequencia preco-total[1] desconto[1] )
        of saldo-terc no-lock.
    end.         

    assign de-valor-tot  = componente.preco-total[1]
           de-desc-tot   = componente.desconto[1].

    for each b-componente
        fields ( quantidade dt-retorno componente
                 preco-total[1] desconto[1] )
        where b-componente.cod-emitente = componente.cod-emitente 
          and b-componente.nro-comp     = componente.nro-docto    
          and b-componente.serie-comp   = componente.serie-docto  
          and b-componente.nat-comp     = componente.nat-operacao 
          and b-componente.it-codigo    = componente.it-codigo    
          and b-componente.cod-refer    = componente.cod-refer   
          and b-componente.seq-comp     = componente.sequencia   no-lock:

        /* Considera Nota de Reajuste de Preco somente ate Data da Nota */
        if  b-componente.quantidade <> 0
        or  b-componente.dt-retorno <= piDataTrans then do:

            if  b-componente.componente = 1 then 
                assign de-valor-tot = de-valor-tot + b-componente.preco-total[1]
                       de-desc-tot  = de-desc-tot  + b-componente.desconto[1].
            else 
                assign de-valor-tot = de-valor-tot - b-componente.preco-total[1]
                       de-desc-tot  = de-desc-tot  - b-componente.desconto[1].
        end.            
    end.

    /*if  natur-oper.tp-oper-terc <> 6 then  /* Diferente de Reajuste Preco */
        assign piPrecoTotal = ( de-valor-tot / saldo-terc.quantidade ) * piQtdeItem
               piDesconto   = ( de-desc-tot  / saldo-terc.quantidade ) * piQtdeItem.
    else*/
        assign piPrecoTotal = (de-valor-tot * piProporcao) / 100
               piDesconto   = (de-desc-tot  * piProporcao) / 100.
    
    if  piDesconto < 0
    or  piDesconto = ? then
        assign piDesconto = 0.
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
