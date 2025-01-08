define temp-table tt-param no-undo
   field usuario     as character
   field senha       as character
   field dt-inicial  as date
   field dt-final    as date.

define temp-table tt-unid no-undo
   field cod_unid_negoc as character format 'x(3)'
   field perc-unid-neg  as decimal   format '>>9.9999'
   index idx_pri is primary unique cod_unid_negoc.

define temp-table ttFactSaldoEstoque no-undo
   field CD_Estabelecimento     like saldo-estoq.cod-estabel
   field CD_Deposito            like saldo-estoq.cod-depos
   field CD_Item                like saldo-estoq.it-codigo
   field CD_Unidade_Negocio     like unid-neg-item.cod_unid_negoc
   FIELD CD_Inventario            AS INTEGER INITIAL 0
   field DT_Posicao               as date initial today
   FIELD DT_Ultima_Movimentacao   AS DATE INITIAL ?
   FIELD DT_Ultima_NFE            AS DATE INITIAL ?
   field NM_Qtidade_Atu         like saldo-estoq.qtidade-atu
   field NM_Qtidade_Alocada     like saldo-estoq.qt-alocada
   field NM_Qtidade_Aloc_Ped    like saldo-estoq.qt-aloc-ped
   field NM_Valor_Medio           AS DECIMAL DECIMALS 4
   field NM_Qtidade_Carimbada   LIKE reservas-ast.qt-reserva
   index idx_pri is primary unique CD_Estabelecimento CD_Deposito CD_Item CD_Unidade_Negocio DT_Posicao.

DEF TEMP-TABLE tt-movto NO-UNDO
    FIELD it-codigo    LIKE movto-estoq.it-codigo  
    FIELD cod-estabel  LIKE movto-estoq.cod-estabel
    FIELD dt-trans     LIKE movto-estoq.dt-trans   
    FIELD dt-trans-nfe LIKE movto-estoq.dt-trans
    FIELD cod-periodo    AS CHAR
    FIELD log-inventario AS  LOG
    INDEX id-item-trans
            cod-estabel
            cod-periodo
            it-codigo.


