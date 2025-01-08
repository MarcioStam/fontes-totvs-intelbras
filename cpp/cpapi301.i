{include/i_dbvers.i}
/**********************************************************************************
**
** Include - CPAPI301.I
** Fun‡Æo  - Defini‡Æo das temp-tables
**
***********************************************************************************/

def temp-table tt-ord-prod      NO-UNDO like ord-prod use-index codigo 
    field dt-disponibilidade    as date
    field ind-tipo-movto        as integer
    field faixa-numeracao       as integer init 1
    field verifica-compras      as logical 
    field aloca-reserva         as logical init ?
    field aloca-lote            as logical init ?
    field rw-ord-prod           as rowid
    field gera-relacionamentos  as logical init yes
    &IF DEFINED(bf_man_204) &THEN
    field gera-reservas         as logical init yes
    &ENDIF
    field prog-seg              as char
    field seg-usuario           as char
    field ep-codigo-usuario     LIKE empresa.ep-codigo
    field cod-versao-integracao as integer format "999"
    field considera-dias-desl   as logical init no.

def temp-table tt-reapro    NO-UNDO
    field it-codigo         like ord-prod.it-codigo
    field cod-refer         like ord-prod.cod-refer
    field descricao         as char format "x(36)"
    field un                like reservas.un
    field quant-orig        like reservas.quant-orig.
