/**
 * Extrator para BI
 * Dimens∆o: Natureza de Operaá∆o
 *
 * Autor: Felipe Braun Azambuja
 */

create widget-pool.

{bi/esbi000.i}
{include/i-freeac.i}

/**
 * Leitura do XML
 */
define variable c-xml as character no-undo.
assign c-xml = entry(2,session:parameter).
file-info:file-name = c-xml.
if (index(file-info:file-type, 'f') = 0) then
   leave.
{bi/esbi001.i c-xml}

/** Valida diret¢rio de sa°da **/
assign c-diretorio = getTag("diretorio").
file-info:file-name = c-diretorio.
if (index(file-info:file-type, 'd') = 0) or (c-diretorio = "") then
   leave.

/**
 * Regra de neg¢cio a partir daqui
 */
define temp-table ttDimNaturezaOperacao no-undo
   field CD_Natureza_Operacao    like natur-oper.nat-operacao
   field TX_Natureza_Operacao    like natur-oper.denominacao
   field CD_Atualiza_Estatistica as integer
   field TX_Tipo_Natureza        as character
   field CD_Emite_Duplicata      as integer
   field CD_Tipo_Mercado         like natur-oper.mercado
   field TX_Tipo_Mercado         as character
   field CD_Considera_Compras    as integer
   index idx_pri is primary unique CD_Natureza_Operacao.

{esp/es0018.i}

run esp/es0018p.p (input "escsp007rp",
                       input 1,
                       input 0,
                       input "", 
                       output table tt-prog-ponto).

for each natur-oper no-lock:

   create ttDimNaturezaOperacao.
   assign ttDimNaturezaOperacao.CD_Natureza_Operacao    = upper(natur-oper.nat-operacao)
          ttDimNaturezaOperacao.TX_Natureza_Operacao    = natur-oper.denominacao
          ttDimNaturezaOperacao.CD_Atualiza_Estatistica = (if natur-oper.atual-estat then 1 else 0)
          ttDimNaturezaOperacao.TX_Tipo_Natureza        = (if natur-oper.tipo = 1 then 'Entrada' else if natur-oper.tipo = 2 then 'Sa°da' else 'Serviáo')
          ttDimNaturezaOperacao.CD_Emite_Duplicata      = (if natur-oper.emite-duplic then 1 else 0)
          ttDimNaturezaOperacao.CD_Tipo_Mercado         = natur-oper.mercado
          ttDimNaturezaOperacao.TX_Tipo_Mercado         = (if natur-oper.mercado = 1 then 'Interno' else if natur-oper.mercado = 2 then 'Externo' else 'Diversos').
   
   if not can-find(first tt-prog-ponto no-lock 
                   where tt-prog-ponto.conteudo = natur-oper.nat-operacao)
      and (not natur-oper.emite-duplic or natur-oper.tipo-compra <> 1) then
      assign ttDimNaturezaOperacao.CD_Considera_Compras = 0.
   else
      assign ttDimNaturezaOperacao.CD_Considera_Compras = 1.

end.

run createTxt(input buffer ttDimNaturezaOperacao:handle, "DimNaturezaOperacao").
