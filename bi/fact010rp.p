/**
 * Extrator para BI
 * Fato: Saldo Estoque
 *
 * Autor: Hoepers - 01/12/2011
 */

create widget-pool.

{include/i-freeac.i}

/** Include com a temp table principal e a temp table de parƒmetros **/
{bi/fact010tt.i}
{bi/esbi000.i}

define input  parameter table for tt-param.
define output parameter table for ttFactSaldoEstoque.
define output parameter table for tt-erro.

define variable dt-data          as date        no-undo.
define variable dt-inicial       as date        no-undo.
define variable dt-final         as date        no-undo.
DEFINE VARIABLE dt-final-calc    AS DATE        NO-UNDO.
DEFINE VARIABLE dt-ult-movto     AS DATE        NO-UNDO.
DEFINE VARIABLE dt-movto-tmp     AS DATE        NO-UNDO.
define variable c-cod-depos      as character   no-undo.
define variable c-cod-periodo    as character   no-undo.
DEFINE VARIABLE c-naturezas      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-cod-per-tmp    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-unid-negoc AS CHARACTER   NO-UNDO.

/************************************************************************/

EMPTY TEMP-TABLE ttFactSaldoEstoque.

ASSIGN c-naturezas = "".
FOR EACH natur-oper NO-LOCK
   WHERE natur-oper.emite-duplic:
    IF c-naturezas = "" THEN
        ASSIGN c-naturezas = natur-oper.nat-operacao.
    ELSE
        ASSIGN c-naturezas = c-naturezas + "," + natur-oper.nat-operacao.
END.
                                                     
find param-estoq no-lock.

RUN pi-le-periodo.

/* NÆo enviar registros com quantidade zerada */
FOR EACH   ttFactSaldoEstoque 
    WHERE  ttFactSaldoEstoque.NM_Qtidade_Atu < 1:
    DELETE ttFactSaldoEstoque.
END.
                               
log-manager:write-message('Find param-estoq:' + string(param-estoq.ult-fech-dia,'99/99/9999'),'DEBUG') no-error.

PROCEDURE pi-le-periodo:
    find first tt-param NO-ERROR.
    
    assign dt-inicial    = date(month(tt-param.dt-inicial), 1, year(tt-param.dt-inicial))
           dt-final      = date(month(tt-param.dt-final), 1, year(tt-param.dt-final))
           dt-inicial    = add-interval(dt-inicial, 1, 'months') - 1
           dt-final      = add-interval(dt-final,   1, 'months') - 1
           dt-data       = dt-inicial
           dt-final-calc = dt-final.
    
    /** Gambi **/
    if dt-final > today then
       assign dt-final = today.

    RUN pi-le-movto-estoq-periodo.
    
    repeat while dt-data <= dt-final:
       run pi-le-saldo.
    
       assign dt-data = date(month(dt-data), 1, year(dt-data))
              dt-data = add-interval(dt-data, 2, 'months') - 1.
    end.
    
    /** Se a data final tem que ser today, extrai s¢ isso aqui **/
    if (dt-final = today) and (dt-final-calc <> today) 
    then do:
       assign dt-data = today.
       run pi-le-saldo.
    end.

END PROCEDURE.


PROCEDURE pi-le-movto-estoq-periodo:

    EMPTY TEMP-TABLE tt-movto.

    DO dt-movto-tmp = tt-param.dt-inicial TO dt-final:
    
        bloco-movtos:
        FOR EACH  movto-estoq NO-LOCK
            WHERE movto-estoq.dt-trans   = dt-movto-tmp
              AND movto-estoq.quantidade > 0:

            ASSIGN c-cod-periodo = STRING(YEAR(movto-estoq.dt-trans),"9999") + STRING(MONTH(movto-estoq.dt-trans),"99").

            FIND FIRST tt-movto EXCLUSIVE-LOCK
                WHERE  tt-movto.cod-estabel = movto-estoq.cod-estabel
                  AND  tt-movto.cod-periodo = c-cod-periodo
                  AND  tt-movto.it-codigo   = movto-estoq.it-codigo NO-ERROR.
    
            IF  NOT AVAIL tt-movto
            THEN DO:
                CREATE tt-movto.
                ASSIGN tt-movto.it-codigo    = movto-estoq.it-codigo  
                       tt-movto.cod-estabel  = movto-estoq.cod-estabel
                       tt-movto.cod-periodo  = c-cod-periodo
                       tt-movto.dt-trans     = 01/01/0001
                       tt-movto.dt-trans-nfe = 01/01/0001.
            END.

            IF  movto-estoq.esp-docto  = 28  OR /* REQ   */
               (movto-estoq.esp-docto  = 23 AND /* NFT   */    
                movto-estoq.tipo-trans = 2)     /* Sa¡da */
            THEN
                ASSIGN tt-movto.dt-trans = MAX(tt-movto.dt-trans,movto-estoq.dt-trans).
/*    
            IF  movto-estoq.esp-docto                         = 22 AND /* NFS */ 
                LOOKUP(movto-estoq.nat-operacao,c-naturezas) <> 0 
            THEN
                ASSIGN tt-movto.dt-trans = MAX(tt-movto.dt-trans,movto-estoq.dt-trans).
    */
            IF  movto-estoq.esp-docto                         = 22 AND /* NFS */ 
               (LOOKUP(movto-estoq.nat-operacao,c-naturezas) <> 0  OR
                movto-estoq.cod-depos                         = "SUC") /* Conforme Viviane Camilo de Souza chamado 131564 */
            THEN
                ASSIGN tt-movto.dt-trans = MAX(tt-movto.dt-trans,movto-estoq.dt-trans).

            FIND ITEM NO-LOCK
                WHERE ITEM.it-codigo = movto-estoq.it-codigo NO-ERROR.
    
            IF  (movto-estoq.esp-docto   = 30  OR  /* RM  */
                 movto-estoq.esp-docto   = 28) AND /* REQ */
                AVAIL ITEM                     AND
                ITEM.ge-codigo          = 30 
            THEN
                ASSIGN tt-movto.dt-trans = MAX(tt-movto.dt-trans,movto-estoq.dt-trans).

            ASSIGN dt-ult-movto = tt-movto.dt-trans-nfe.
            IF  movto-estoq.esp-docto  <> 33 AND /* transferencia */ 
                movto-estoq.tipo-trans  = 1
            THEN DO:
                ASSIGN tt-movto.dt-trans-nfe = MAX(tt-movto.dt-trans-nfe,movto-estoq.dt-trans).

                IF  dt-ult-movto <> tt-movto.dt-trans-nfe
                THEN DO:
                    IF  movto-estoq.esp-docto = 15 /* invent rio    */ 
                    THEN
                        ASSIGN tt-movto.log-inventario = YES.
                    ELSE
                        ASSIGN tt-movto.log-inventario = NO.
                END.
            END.

            IF  tt-movto.dt-trans     = 01/01/0001 AND
                tt-movto.dt-trans-nfe = 01/01/0001
            THEN
                DELETE tt-movto.
        END. /* FOR EACH  movto-estoq NO-LOCK */
    END. /* DO dt-movto-tmp = dt-inicial TO dt-final: */

END PROCEDURE.


PROCEDURE pi-le-saldo:

    log-manager:write-message('Data :' + string(dt-data,'99/99/9999'),'DEBUG') no-error.

    IF  MONTH(dt-data) = MONTH(TODAY) AND
         YEAR(dt-data) =  YEAR(TODAY)
    THEN DO:
        FOR EACH  saldo-estoq NO-LOCK 
            WHERE saldo-estoq.qtidade-atu > 0:

            RUN pi-gera-tt (INPUT saldo-estoq.cod-estabel,
                            INPUT saldo-estoq.cod-depos,
                            INPUT saldo-estoq.it-codigo,
                            INPUT saldo-estoq.qtidade-atu,
                            INPUT saldo-estoq.qt-alocada, 
                            INPUT saldo-estoq.qt-aloc-ped).
        END.
    END.
    ELSE DO:
        if dt-data <= param-estoq.ult-fech-dia then do:
            log-manager:write-message(' Extrai sl-it-per ','DEBUG') no-error.
            FOR EACH  sl-it-per NO-LOCK
                WHERE sl-it-per.periodo = dt-data:

                RUN pi-gera-tt (INPUT sl-it-per.cod-estabel,
                                INPUT sl-it-per.cod-depos,
                                INPUT sl-it-per.it-codigo,
                                INPUT sl-it-per.quantidade,
                                INPUT 0,
                                INPUT 0).
            END.
        end.
    END.
END PROCEDURE.


PROCEDURE pi-gera-tt:
    DEF INPUT PARAM p-cod-estabel    AS CHAR                     NO-UNDO.
    DEF INPUT PARAM p-cod-depos      AS CHAR                     NO-UNDO.
    DEF INPUT PARAM p-it-codigo      AS CHAR                     NO-UNDO.
    DEF INPUT PARAM p-qtd-item     LIKE saldo-estoq.qtidade-atu  NO-UNDO.
    DEF INPUT PARAM p-qtd-alocada  LIKE saldo-estoq.qt-alocada   NO-UNDO.
    DEF INPUT PARAM p-qtd-aloc-ped LIKE saldo-estoq.qt-aloc-ped  NO-UNDO.

    assign p-cod-estabel = fn-free-accent(upper(trim(p-cod-estabel)))
           p-cod-depos   = fn-free-accent(upper(trim(p-cod-depos)))
           p-it-codigo   = fn-free-accent(upper(trim(p-it-codigo))).

    /* Criar Unidade Neg¢cio do Item */
    FIND ITEM NO-LOCK 
        WHERE ITEM.it-codigo = p-it-codigo NO-ERROR.

    find item-uni-estab no-lock
        where item-uni-estab.it-codigo   = item.it-codigo
          and item-uni-estab.cod-estabel = p-cod-estabel no-error.

    assign c-cod-unid-negoc = fn-free-accent(upper(trim(if avail item-uni-estab and item-uni-estab.cod-unid-negoc <> '' then item-uni-estab.cod-unid-negoc else 'INV'))).

    /* Criar Registros */                                 
    find ttFactSaldoEstoque
        where ttFactSaldoEstoque.CD_Estabelecimento = p-cod-estabel
          and ttFactSaldoEstoque.CD_Deposito        = p-cod-depos
          and ttFactSaldoEstoque.CD_Item            = p-it-codigo
          and ttFactSaldoEstoque.CD_Unidade_Negocio = c-cod-unid-negoc
          AND ttFactSaldoEstoque.DT_Posicao         = dt-data no-error.

    IF  NOT AVAIL(ttFactSaldoEstoque) 
    then do:
       create ttFactSaldoEstoque.
       assign ttFactSaldoEstoque.CD_Estabelecimento     = p-cod-estabel
              ttFactSaldoEstoque.CD_Deposito            = p-cod-depos  
              ttFactSaldoEstoque.CD_Item                = p-it-codigo  
              ttFactSaldoEstoque.CD_Unidade_Negocio     = upper(c-cod-unid-negoc)
              ttFactSaldoEstoque.DT_Posicao             = dt-data
              ttFactSaldoEstoque.DT_Ultima_Movimentacao = ?
              ttFactSaldoEstoque.DT_Ultima_NFE          = ?.
      
       FOR EACH reservas-ast NO-LOCK
           WHERE reservas-ast.cod-estab    = p-cod-estabel
             AND reservas-ast.it-codigo    = p-it-codigo
             AND reservas-ast.dt-reserva   <= TODAY
             AND (reservas-ast.data-limite = ? OR reservas-ast.data-limite >= TODAY) :
             ASSIGN ttFactSaldoEstoque.NM_Qtidade_Carimbada = ttFactSaldoEstoque.NM_Qtidade_Carimbada  + reservas-ast.qt-reserva.
       END.

       ASSIGN v-cod-per-tmp = STRING(YEAR(dt-data),"9999") + STRING(MONTH(dt-data),"99").
      
       FIND FIRST tt-movto NO-LOCK
           WHERE  tt-movto.cod-estabel = p-cod-estabel
             AND  tt-movto.cod-periodo = v-cod-per-tmp
             AND  tt-movto.it-codigo   = p-it-codigo NO-ERROR.
      
       IF  AVAIL tt-movto
       THEN
           ASSIGN ttFactSaldoEstoque.DT_Ultima_Movimentacao = IF tt-movto.dt-trans        = 01/01/0001 THEN ? ELSE tt-movto.dt-trans
                  ttFactSaldoEstoque.DT_Ultima_NFE          = IF tt-movto.dt-trans-nfe    = 01/01/0001 THEN ? ELSE tt-movto.dt-trans-nfe
                  ttFactSaldoEstoque.CD_Inventario          = IF tt-movto.log-inventario  = YES        THEN 1 ELSE 0.
      
       find item-estab no-lock
           where item-estab.cod-estabel = p-cod-estabel
             and item-estab.it-codigo   = p-it-codigo no-error.
      
       find pr-it-per NO-LOCK
           WHERE  pr-it-per.it-codigo   = p-it-codigo
             AND  pr-it-per.cod-estabel = p-cod-estabel
             AND  pr-it-per.periodo     = dt-data NO-ERROR.
      
      
       if year(dt-data) <> year(today)
       then do:
           if avail pr-it-per
           then
               assign ttFactSaldoEstoque.NM_Valor_Medio = pr-it-per.val-unit-mat-m[1] + pr-it-per.val-unit-mob-m[1] + pr-it-per.val-unit-ggf-m[1].
      
               if ttFactSaldoEstoque.NM_Valor_Medio = 0 AND
                   avail item-estab
                   then
                       assign ttFactSaldoEstoque.NM_Valor_Medio = item-estab.val-unit-ggf-m[1] + item-estab.val-unit-mat-m[1] + item-estab.val-unit-mob-m[1].
        end.
        else do:
            if month (dt-data) <> month(today)
            then do:
                if avail pr-it-per
                then
                    assign ttFactSaldoEstoque.NM_Valor_Medio = pr-it-per.val-unit-mat-m[1] + pr-it-per.val-unit-mob-m[1] + pr-it-per.val-unit-ggf-m[1].
      
                if ttFactSaldoEstoque.NM_Valor_Medio = 0 and
                    avail item-estab
                then
                    assign ttFactSaldoEstoque.NM_Valor_Medio = item-estab.val-unit-ggf-m[1] + item-estab.val-unit-mat-m[1] + item-estab.val-unit-mob-m[1].
            end.
            else
                if avail item-estab
                then
                    assign ttFactSaldoEstoque.NM_Valor_Medio = item-estab.val-unit-ggf-m[1] + item-estab.val-unit-mat-m[1] + item-estab.val-unit-mob-m[1].
        end.
      
        if ttFactSaldoEstoque.NM_Valor_Medio = 0 and
            avail item-estab
        then
            assign ttFactSaldoEstoque.NM_Valor_Medio = item-estab.val-unit-ggf-m[1] + item-estab.val-unit-mat-m[1] + item-estab.val-unit-mob-m[1].
     end.
      
     assign ttFactSaldoEstoque.NM_Qtidade_Atu       = ttFactSaldoEstoque.NM_Qtidade_Atu      + p-qtd-item
            ttFactSaldoEstoque.NM_Qtidade_Alocada   = ttFactSaldoEstoque.NM_Qtidade_Alocada  + p-qtd-alocada
            ttFactSaldoEstoque.NM_Qtidade_Aloc_Ped  = ttFactSaldoEstoque.NM_Qtidade_Aloc_Ped + p-qtd-aloc-ped.
      
end procedure.

RETURN "ok".

