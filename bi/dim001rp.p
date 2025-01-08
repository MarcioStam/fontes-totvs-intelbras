/**
 * Extrator para BI
 * DimensÆo: Emitente
 *
 * Autor: Felipe Braun Azambuja
 */

create widget-pool.

{include/i-freeac.i}

/** Include com a temp table principal e a temp table de parƒmetros **/
{bi/dim001tt.i}

define input  parameter table for tt-param.
define output parameter table for ttDimEmitente.

define variable c-identific          as character               no-undo.
define variable c-nome-emit          like emitente.nome-emit    no-undo.
define variable c-nome-abrev         like emitente.nome-abrev   no-undo.
define variable c-cidade             like emitente.cidade       no-undo.
define variable c-estado             like emitente.estado       no-undo.
define variable c-pais               like emitente.pais         no-undo.
define variable i-cod-matriz         like emitente.cod-emitente no-undo.
define variable c-abrev-matriz       like emitente.nome-abrev   no-undo.
define variable c-nome-matriz        like emitente.nome-emit    no-undo.
define variable i-cod-matriz-canal   like emitente.cod-emitente no-undo.
define variable c-abrev-matriz-canal like emitente.nome-abrev   no-undo.
define variable c-nome-matriz-canal  like emitente.nome-emit    no-undo.

define buffer b-matriz for emitente.
define buffer b-matriz-canal for emitente.

for each emitente no-lock:
   find int-emitente no-lock
      where int-emitente.cod-emitente = emitente.cod-emitente no-error.
   find dist-emitente no-lock
      where dist-emitente.cod-emitente = emitente.cod-emitente no-error.
   find b-matriz no-lock
      where b-matriz.nome-abrev = emitente.nome-matriz no-error.
   find gr-cli no-lock
      where gr-cli.cod-gr-cli = emitente.cod-gr-cli no-error.
   find grupo-fornec no-lock
      where grupo-fornec.cod-gr-forn = emitente.cod-gr-forn no-error.
   find int-emitente-canal no-lock
      where int-emitente-canal.cod-emitente = emitente.cod-emitente no-error.
   find b-matriz-canal no-lock
      where b-matriz-canal.cod-emitente = int-emitente-canal.cod-emitente-matriz no-error.

   if available b-matriz then
      assign i-cod-matriz   = b-matriz.cod-emitente
             c-abrev-matriz = b-matriz.nome-abrev
             c-nome-matriz  = b-matriz.nome-emit.
   else
      assign i-cod-matriz   = emitente.cod-emitente
             c-abrev-matriz = emitente.nome-abrev
             c-nome-matriz  = emitente.nome-emit.

   if available b-matriz-canal then
      assign i-cod-matriz-canal   = b-matriz-canal.cod-emitente
             c-abrev-matriz-canal = b-matriz-canal.nome-abrev
             c-nome-matriz-canal  = b-matriz-canal.nome-emit.
   else
      assign i-cod-matriz-canal   = emitente.cod-emitente
             c-abrev-matriz-canal = emitente.nome-abrev
             c-nome-matriz-canal  = emitente.nome-emit.
   
   assign c-identific          = (if emitente.identific = 1 then 'Cliente'
                                  else if emitente.identific = 2 then 'Fornecedor'
                                  else 'Ambos')
          c-nome-emit          = fn-free-accent(upper(trim(emitente.nome-emit)))
          c-nome-abrev         = fn-free-accent(upper(trim(emitente.nome-abrev)))
          c-cidade             = fn-free-accent(upper(trim(emitente.cidade)))
          c-estado             = fn-free-accent(upper(trim(emitente.estado)))
          c-pais               = fn-free-accent(upper(trim(emitente.pais)))
          c-abrev-matriz       = fn-free-accent(upper(trim(c-abrev-matriz)))
          c-nome-matriz        = fn-free-accent(upper(trim(c-nome-matriz)))
          c-abrev-matriz-canal = fn-free-accent(upper(trim(c-abrev-matriz-canal)))
          c-nome-matriz-canal  = fn-free-accent(upper(trim(c-nome-matriz-canal))).

   create ttDimEmitente.
   assign ttDimEmitente.CD_Emitente                = emitente.cod-emitente
          ttDimEmitente.TX_Emitente                = c-nome-emit
          ttDimEmitente.TX_Nome_Abreviado          = c-nome-abrev
          ttDimEmitente.TX_Identificador           = c-identific
          ttDimEmitente.CD_CGC                     = emitente.cgc
          ttDimEmitente.CD_Pais                    = c-pais
          ttDimEmitente.CD_Estado                  = c-estado
          ttDimEmitente.CD_Cidade                  = c-cidade
          ttDimEmitente.CD_Grupo_Cliente           = emitente.cod-gr-cli
          ttDimEmitente.TX_Grupo_Cliente           = (if available gr-cli then gr-cli.descricao else '')
          ttDimEmitente.CD_Grupo_Fornecedor        = emitente.cod-gr-forn
          ttDimEmitente.TX_Grupo_Fornecedor        = (if available grupo-fornec then grupo-fornec.descricao else '')
          ttDimEmitente.CD_Matriz                  = i-cod-matriz
          ttDimEmitente.TX_Matriz                  = c-nome-matriz
          ttDimEmitente.TX_Nome_Abrev_Matriz       = c-abrev-matriz
          ttDimEmitente.CD_Ativo_Cliente           = (if available int-emitente and int-emitente.id-ativo then 1 else 0)
          ttDimEmitente.CD_Ativo_Fornecedor        = (if available dist-emitente and dist-emitente.idi-sit-fornec = 1 then 1 else 0)
          ttDimEmitente.CD_Grupo_Cobranca          = (if available int-emitente then int-emitente.cod-gr-cob else 0)
          ttDimEmitente.CD_Representante           = emitente.cod-rep
          ttDimEmitente.DT_Implantacao             = emitente.data-implant
          ttDimEmitente.CD_Natureza                = {adinc/i03ad098.i 04 emitente.natureza}
          ttDimEmitente.CD_Canal                   = (if available int-emitente and int-emitente.ind-participa-canais = 993520001 then 1 else 0)
          ttDimEmitente.CD_GUID                    = (if available int-emitente and int-emitente.cod-guid <> '' then chr(123) + int-emitente.cod-guid + chr(125) else '')
          ttDimEmitente.CD_Matriz_Canal            = i-cod-matriz-canal
          ttDimEmitente.TX_Nome_Abrev_Matriz_Canal = c-abrev-matriz-canal
          ttDimEmitente.TX_Matriz_Canal            = c-nome-matriz-canal.
end.
