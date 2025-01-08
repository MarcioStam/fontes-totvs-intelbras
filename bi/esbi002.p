/**
 * Login do EMS para BI
 * Fato: Faturamento
 *
 * Autor: Felipe Braun Azambuja
 */

create widget-pool.

define input parameter pUsuario as character.
define input parameter pSenha   as character.

{utp/ut-glob.i}

define temp-table ttLoginErrors no-undo
    field cod-erro  as integer
    field desc-erro as character
    field desc-arq  as character.

run btb/btapi910za.p (input pUsuario,
                      input pSenha,
                      output table ttLoginErrors).
