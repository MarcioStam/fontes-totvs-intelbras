/**
 * Extrator para BI
 * Fato: Faturamento Resumido
 *
 * Autor: Cleto May
 */
 
create widget-pool.

{include/i-freeac.i}

/** Include com a temp table principal e a temp table de parÉmetros **/
{bi/fact018tt.i}
{bi/esbi000.i}

define input  parameter table for tt-param.
define output parameter table for ttFactFaturamentoResumo.
define output parameter table for tt-erro.

find first tt-param.

define variable dt-data         as date   no-undo.
define variable d-quantidade    as decimal no-undo.
define variable d-vl-unitario   as decimal no-undo.
define variable d-vl-tot-merc   as decimal no-undo.
define variable d-vl-total      as decimal no-undo.
define variable c-pais          as character no-undo.
define variable c-estado        as character no-undo.
define variable c-cidade        as character no-undo.
define variable c-item          as character no-undo.
define variable c-unid-negoc    as character no-undo.
define variable i               as integer no-undo.

DEFINE VARIABLE i-qtd-item-doc AS INTEGER  NO-UNDO.
DEFINE VARIABLE r-docum-est    AS ROWID    NO-UNDO.

DEF BUFFER b-item-doc-est FOR item-doc-est.

define buffer b-matriz for emitente.

/* Notas de saida */
do dt-data = tt-param.dt-inicial to tt-param.dt-final:

   for each nota-fiscal no-lock use-index ch-distancia
      where nota-fiscal.dt-emis-nota = dt-data,
      each it-nota-fisc of nota-fiscal no-lock:

      find first int-it-nota-fisc
         where int-it-nota-fisc.cod-estabel = it-nota-fisc.cod-estabel
           and int-it-nota-fisc.serie       = it-nota-fisc.serie
           and int-it-nota-fisc.nr-nota-fis = it-nota-fisc.nr-nota-fis
           and int-it-nota-fisc.nr-seq-fat  = it-nota-fisc.nr-seq-fat
           and int-it-nota-fisc.it-codigo   = it-nota-fisc.it-codigo no-lock no-error.

      find natur-oper no-lock
         where natur-oper.nat-operacao = it-nota-fisc.nat-operacao no-error.

      /** Ignora notas de entrada **/
      if available natur-oper and natur-oper.tipo = 1 then
         next.

      /** Ignora notas que n∆o geram faturamento **/
      if not natur-oper.atual-estat then 
          next.

      find estabelec no-lock 
         where estabelec.cod-estabel = nota-fiscal.cod-estabel no-error.

      find ped-venda no-lock
         where ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
           and ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli no-error.
      
      assign c-pais      = fn-free-accent(upper(trim(nota-fiscal.pais)))
             c-estado    = fn-free-accent(upper(trim(nota-fiscal.estado)))
             c-cidade    = fn-free-accent(upper(trim(nota-fiscal.cidade)))
             c-item      = fn-free-accent(upper(trim(it-nota-fisc.it-codigo))).

      if c-estado = 'DF' then
         assign c-cidade = 'BRASILIA'.

      find emitente no-lock
         where emitente.cod-emitente = nota-fiscal.cod-emitente no-error.

      find first b-matriz no-lock
         where b-matriz.nome-abrev = emitente.nome-matriz no-error.

      find item no-lock
         where item.it-codigo = it-nota-fisc.it-codigo no-error.

      find repres no-lock
          where repres.cod-rep = nota-fiscal.cod-rep no-error.

      /** Atribui e corrige unidade de neg¢cio **/
      if it-nota-fisc.cod-unid-negoc = ? then
         assign c-unid-negoc = 'INV'.
      else if (nota-fiscal.cod-estabel = '102' and it-nota-fisc.cod-unid-negoc = 'ADM') then
         assign c-unid-negoc = 'COM'.
      else if (nota-fiscal.cod-estabel = '301' and it-nota-fisc.cod-unid-negoc = 'ADM') then
         assign c-unid-negoc = 'MAX'.
      else 
         assign c-unid-negoc = it-nota-fisc.cod-unid-negoc.

      find unid_negoc no-lock
          where unid_negoc.cod_unid_negoc = c-unid-negoc no-error.

      assign d-quantidade     = if it-nota-fisc.qt-faturada[1] = ? then 0 else it-nota-fisc.qt-faturada[1]
             d-vl-unitario    = if it-nota-fisc.vl-preuni      = ? then 0 else it-nota-fisc.vl-preuni
             d-vl-tot-merc    = if it-nota-fisc.vl-merc-liq    = ? then 0 else it-nota-fisc.vl-merc-liq
             d-vl-total       = if it-nota-fisc.vl-tot-item    = ? then 0 else it-nota-fisc.vl-tot-item.

      create ttFactFaturamentoResumo.
      assign ttFactFaturamentoResumo.CD_Estabelecimento              = nota-fiscal.cod-estabel
             ttFactFaturamentoResumo.CD_Serie                        = nota-fiscal.serie
             ttFactFaturamentoResumo.CD_Nota_Fiscal                  = nota-fiscal.nr-nota-fis
             ttFactFaturamentoResumo.CD_Sequencia                    = it-nota-fisc.nr-seq-fat
             ttFactFaturamentoResumo.CD_Item                         = c-item
             ttFactFaturamentoResumo.CD_Unidade_Negocio              = c-unid-negoc
             ttFactFaturamentoResumo.CD_Emitente                     = nota-fiscal.cod-emitente
             ttFactFaturamentoResumo.CD_Grupo_Cliente                = emitente.cod-gr-cli
             ttFactFaturamentoResumo.CD_Representante                = nota-fiscal.cod-rep
             ttFactFaturamentoResumo.CD_Pais                         = c-pais
             ttFactFaturamentoResumo.CD_Estado                       = c-estado
             ttFactFaturamentoResumo.CD_Cidade                       = c-cidade
             ttFactFaturamentoResumo.CD_Devolucao                    = 0
             ttFactFaturamentoResumo.CD_Cancelada                    = (if nota-fiscal.dt-cancel = ? then 0 else 1)
             ttFactFaturamentoResumo.TX_Emitente_Nome_Abreviado      = fn-free-accent(upper(trim(emitente.nome-abrev)))
             ttFactFaturamentoResumo.TX_Emitente_Nome_Abrev_Matriz   = (if available b-matriz then b-matriz.nome-abrev else emitente.nome-abrev)
             ttFactFaturamentoResumo.TX_Representante_Nome_Abreviado = repres.nome-abrev
             ttFactFaturamentoResumo.TX_Unidade_Negocio              = unid_negoc.des_unid_negoc
             ttFactFaturamentoResumo.TX_Item                         = item.desc-item
             ttFactFaturamentoResumo.DT_Emissao                      = nota-fiscal.dt-emis-nota
             ttFactFaturamentoResumo.NM_Quantidade                   = d-quantidade
             ttFactFaturamentoResumo.NM_Vl_Unitario                  = d-vl-unitario
             ttFactFaturamentoResumo.NM_Vl_Liquido                   = d-vl-tot-merc
             ttFactFaturamentoResumo.NM_Vl_Total                     = d-vl-total.
      
      if (item.fm-cod-com <> '') and can-find (first fam-com-item
                                            where fam-com-item.fm-cod-com = item.fm-cod-com) then do:
         repeat i = 1 to 8:
            if (i = 1) or
               (i = 2) or
               (i = 3) or
               (i = 6) then
               next.

            find fam-com-item no-lock
               where fam-com-item.fm-cod-com = substring(item.fm-cod-com, 1, i) no-error.

            if not available (fam-com-item) then
               next.

            case i:
               when 4 then
                  assign ttFactFaturamentoResumo.TX_Segmento = fam-com-item.descricao.
               when 5 then
                  assign ttFactFaturamentoResumo.TX_Familia = fam-com-item.descricao.
               when 7 then
                  assign ttFactFaturamentoResumo.TX_Subfamilia = fam-com-item.descricao.
               when 8 then
                  assign ttFactFaturamentoResumo.TX_Origem = fam-com-item.descricao.
            end case.
         end.
      end.
   end.
end.

/* Devolucoes */
ASSIGN r-docum-est = ?.
for each devol-cli no-lock
   where devol-cli.dt-devol >= tt-param.dt-inicial
     and devol-cli.dt-devol <= tt-param.dt-final,
   each item-doc-est of devol-cli no-lock,
   first docum-est of item-doc-est no-lock:

   IF  docum-est.valor-frete  > 0 AND 
       r-docum-est           <> ROWID(docum-est)
   THEN DO:
       ASSIGN r-docum-est    = ROWID(docum-est)
              i-qtd-item-doc = 0.

       FOR EACH b-item-doc-est OF docum-est NO-LOCK:
           ASSIGN i-qtd-item-doc = i-qtd-item-doc + 1.
       END.
   END.

   IF  i-qtd-item-doc = 0
   THEN
       ASSIGN i-qtd-item-doc = 1.

   find it-nota-fisc no-lock
      where it-nota-fisc.cod-estabel = devol-cli.cod-estabel
        and it-nota-fisc.serie       = devol-cli.serie
        and it-nota-fisc.nr-nota-fis = devol-cli.nr-nota-fis
        and it-nota-fisc.nr-seq-fat  = devol-cli.nr-sequencia
        and it-nota-fisc.it-codigo   = devol-cli.it-codigo no-error.

   find first int-it-nota-fisc
       where int-it-nota-fisc.cod-estabel = it-nota-fisc.cod-estabel
         and int-it-nota-fisc.serie       = it-nota-fisc.serie
         and int-it-nota-fisc.nr-nota-fis = it-nota-fisc.nr-nota-fis
         and int-it-nota-fisc.nr-seq-fat  = it-nota-fisc.nr-seq-fat
         and int-it-nota-fisc.it-codigo   = it-nota-fisc.it-codigo no-lock no-error.

   find nota-fiscal of it-nota-fisc no-lock no-error.

   find natur-oper no-lock
      where natur-oper.nat-operacao = it-nota-fisc.nat-operacao no-error.

   /** Ignora notas que n∆o geram faturamento **/
   if not natur-oper.atual-estat then 
      next.

   find ped-venda no-lock
      where ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
        and ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli no-error.

   assign c-pais      = fn-free-accent(upper(trim(nota-fiscal.pais)))
          c-estado    = fn-free-accent(upper(trim(nota-fiscal.estado)))
          c-cidade    = fn-free-accent(upper(trim(nota-fiscal.cidade)))
          c-item      = fn-free-accent(upper(trim(devol-cli.it-codigo))).

   if c-estado = 'DF' then
      assign c-cidade = 'BRASILIA'.

   find emitente no-lock
      where emitente.cod-emitente = nota-fiscal.cod-emitente no-error.

   find first b-matriz no-lock
         where b-matriz.nome-abrev = emitente.nome-matriz no-error.

   find item no-lock
      where item.it-codigo = it-nota-fisc.it-codigo no-error.

   find repres no-lock
          where repres.cod-rep = nota-fiscal.cod-rep no-error.

   /** Atribui e corrige unidade de neg¢cio **/
   if it-nota-fisc.cod-unid-negoc = ? then
      assign c-unid-negoc = 'INV'.
   else if (nota-fiscal.cod-estabel = '102' and it-nota-fisc.cod-unid-negoc = 'ADM') then
      assign c-unid-negoc = 'COM'.
   else if (nota-fiscal.cod-estabel = '301' and it-nota-fisc.cod-unid-negoc = 'ADM') then
      assign c-unid-negoc = 'MAX'.
   else 
      assign c-unid-negoc = it-nota-fisc.cod-unid-negoc.

   find unid_negoc no-lock
          where unid_negoc.cod_unid_negoc = c-unid-negoc no-error.

   create ttFactFaturamentoResumo.
   assign ttFactFaturamentoResumo.CD_Estabelecimento              = devol-cli.cod-estabel
          ttFactFaturamentoResumo.CD_Serie                        = devol-cli.serie
          ttFactFaturamentoResumo.CD_Nota_Fiscal                  = devol-cli.nr-nota-fis
          ttFactFaturamentoResumo.CD_Sequencia                    = devol-cli.nr-sequencia
          ttFactFaturamentoResumo.CD_Item                         = c-item
          ttFactFaturamentoResumo.CD_Unidade_Negocio              = upper(c-unid-negoc)
          ttFactFaturamentoResumo.CD_Emitente                     = devol-cli.cod-emitente
          ttFactFaturamentoResumo.CD_Grupo_Cliente                = emitente.cod-gr-cli
          ttFactFaturamentoResumo.CD_Representante                = nota-fiscal.cod-rep
          ttFactFaturamentoResumo.CD_Pais                         = c-pais
          ttFactFaturamentoResumo.CD_Estado                       = c-estado
          ttFactFaturamentoResumo.CD_Cidade                       = c-cidade
          ttFactFaturamentoResumo.CD_Serie_Devolucao              = devol-cli.serie-docto
          ttFactFaturamentoResumo.CD_Nro_Devolucao                = devol-cli.nro-docto
          ttFactFaturamentoResumo.CD_Seq_Devolucao                = devol-cli.sequencia
          ttFactFaturamentoResumo.CD_Devolucao                    = 1
          ttFactFaturamentoResumo.CD_Cancelada                    = 0                 
          ttFactFaturamentoResumo.TX_Emitente_Nome_Abreviado      = fn-free-accent(upper(trim(emitente.nome-abrev)))
          ttFactFaturamentoResumo.TX_Emitente_Nome_Abrev_Matriz   = (if available b-matriz then b-matriz.nome-abrev else emitente.nome-abrev)
          ttFactFaturamentoResumo.TX_Representante_Nome_Abreviado = repres.nome-abrev
          ttFactFaturamentoResumo.TX_Unidade_Negocio              = unid_negoc.des_unid_negoc
          ttFactFaturamentoResumo.TX_Item                         = item.desc-item
          ttFactFaturamentoResumo.DT_Emissao                      = devol-cli.dt-devol
          ttFactFaturamentoResumo.NM_Quantidade                   = (item-doc-est.quantidade * -1)
          ttFactFaturamentoResumo.NM_Vl_Unitario                  = (item-doc-est.preco-unit[1] * -1)
          ttFactFaturamentoResumo.NM_Vl_Liquido                   = (item-doc-est.preco-total[1] * -1)
          ttFactFaturamentoResumo.NM_Vl_Total                     = ((item-doc-est.preco-total[1] + item-doc-est.valor-ipi[1] + (docum-est.valor-frete / i-qtd-item-doc)) * -1).

   if (item.fm-cod-com <> '') and can-find (first fam-com-item
                                            where fam-com-item.fm-cod-com = item.fm-cod-com) then do:
      repeat i = 1 to 8:
         if (i = 1) or
            (i = 2) or
            (i = 3) or
            (i = 6) then
             next.

         find fam-com-item no-lock
            where fam-com-item.fm-cod-com = substring(item.fm-cod-com, 1, i) no-error.

         if not available (fam-com-item) then
            next.

         case i:
            when 4 then
               assign ttFactFaturamentoResumo.TX_Segmento = fam-com-item.descricao.
            when 5 then
               assign ttFactFaturamentoResumo.TX_Familia = fam-com-item.descricao.
            when 7 then
               assign ttFactFaturamentoResumo.TX_Subfamilia = fam-com-item.descricao.
            when 8 then
               assign ttFactFaturamentoResumo.TX_Origem = fam-com-item.descricao.
         end case.
      end.
   end.

end.
