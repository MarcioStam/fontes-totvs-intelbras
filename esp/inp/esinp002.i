/*********************************************************************************
** Programa: esp/inp/esinp002.i
** Vers∆o..: 1.00
** Data....: 21/02/2011
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Definiá∆o das Temp-Tables criadas com base nas informaá‰es do FISCOSoft
*********************************************************************************/

define temp-table tt-ncm no-undo
   field sequencia_ncm        as integer
   field codigo               as character format 'x(15)'
   field descricao            as character format 'x(40)'
   field aliquota             as character
   field indicadores          as character
   field ipi                  as character
   field pis                  as character
   field cofins               as character
   field icms                 as character
   field ume                  as character
   field vigencia_de          as character format 'x(10)'
   field vigencia_ate         as character format 'x(10)'
   field ver_excecao_tec      as character
   field ver_excecao_tipi     as character
   field ponteiro_atualizacao as DEC DECIMALS 0
   index ch-pri is primary unique sequencia_ncm.

define temp-table tt-acordos no-undo
   field sequencia_ncm  as integer
   field sequencia      as integer
   field ex             as character
   field tipo_codigo    as character
   field acordo         as character
   field anotacoes_imp  as character
   field anotacoes_exp  as character
   field aliq           as character
   field pp_imp         as character
   field pp_exp         as character
   field vigencia_de    as character
   field vigencia_ate   as character
   index ch-pri is primary unique sequencia_ncm sequencia.

define temp-table tt-list-ex no-undo
   field sequencia_ncm  as integer
   field sequencia      as integer
   field ex             as character
   field descricao      as character
   field aliquota       as character
   field observacoes    as character
   field indicadores    as character
   field vigencia_de    as character
   field vigencia_ate   as character
   index ch-pri is primary unique sequencia_ncm sequencia.

define temp-table tt-list-ex-bit no-undo
   field sequencia_ncm  as integer
   field sequencia      as integer
   field descricao      as character
   field aliquota       as character
   field observacoes    as character
   field indicadores    as character
   field vigencia_de    as character
   field vigencia_ate   as character
   index ch-pri is primary unique sequencia_ncm sequencia.

define temp-table tt-ex-br-simples no-undo
   field sequencia_ncm  as integer
   field sequencia      as integer
   field ex             as character
   field descricao      as character
   field aliquota       as character
   field bkbit          as character
   field observacoes    as character
   field vigencia_de    as character
   field vigencia_ate   as character
   index ch-pri is primary unique sequencia_ncm sequencia.

define temp-table tt-sistemas no-undo
   field sequencia_ncm  as integer
   field sequencia      as integer
   field descricao      as character
   field aliquota       as character
   field observacoes    as character
   field vigencia_de    as character
   field vigencia_ate   as character
   index ch-pri is primary unique sequencia_ncm sequencia.

define temp-table tt-red-import no-undo
   field sequencia_ncm  as integer
   field sequencia      as integer
   field ex             as character
   field descricao      as character
   field aliquota       as character
   field quota          as character
   field observacoes    as character
   field indicadores    as character
   field vigencia_de    as character
   field vigencia_ate   as character
   index ch-pri is primary unique sequencia_ncm sequencia.

/* define temp-table tt-nve no-undo                            */
/*    field sequencia_ncm  as integer                          */
/*    field sequencia      as integer                          */
/*    field nivel          as character                        */
/*    field produto        as character                        */
/*    index ch-pri is primary unique sequencia_ncm sequencia.  */


define temp-table tt-nve no-undo
   field sequencia_ncm  as integer
   field sequencia      as integer
   field nivel          as character
   field atributo       as character
   FIELD especificacao  as character
   index ch-pri is primary unique sequencia_ncm sequencia.

define temp-table tt-naladi-1996 no-undo
   field sequencia_ncm  as integer
   field sequencia      as integer
   field codigo         as character
   field descricao      as character
   index ch-pri is primary unique sequencia_ncm sequencia.

define temp-table tt-naladi-2002 no-undo like tt-naladi-1996.

define temp-table tt-naladi-2007 no-undo like tt-naladi-1996.

define temp-table tt-defesa-comercial no-undo
   field sequencia_ncm     as integer
   field sequencia         as integer
   field produto           as character
   field pais              as character
   field medida            as character
   field direito_aplicado  as character
   field observacoes       as character
   field vigencia_de       as character
   field vigencia_ate      as character
   index ch-pri is primary unique sequencia_ncm sequencia.

define temp-table tt-acordo-ptr04 no-undo
   field sequencia_ncm  as integer
   field sequencia      as integer
   field naladi_1996    as character
   field exceto         as character
   index ch-pri is primary unique sequencia_ncm sequencia.

define temp-table tt-icms-convenio no-undo
   field sequencia_ncm  as integer
   field sequencia      as integer
   field descriminacao  as character
   field convenio       as character
   field anexo          as character
   field tratamento     as character
   field resumo         as character
   index ch-pri is primary unique sequencia_ncm sequencia.

define temp-table tt-tra-siscomex no-undo
   field sequencia_ncm        as integer
   field sequencia            as integer
   field ncm                  as character
   field orgao_anuente        as character
   field indicadores          as character
   field tratamento           as character
   field ex                   as character
   field ex_descricao         as character
   field fundamento_legal     as character
   field descricao_mercadoria as character
   field excecoes             as character
   field vigencia_de          as character
   field vigencia_ate         as character
   index ch-pri is primary unique sequencia_ncm sequencia.

define temp-table tt-pis-cofins no-undo
   field sequencia_ncm  as integer
   field sequencia      as integer
   field pis            as character
   field cofins         as character
   field anotacao       as character
   field grupo          as character
   field classificacao  as character
   field principal      as character
   field vigencia_de    as character
   field vigencia_ate   as character
   index ch-pri is primary unique sequencia_ncm sequencia.

define temp-table tt-ipi-det no-undo
   field sequencia_ncm  as integer
   field sequencia      as integer
   field descricao      as character
   field anotacoes      as character
   field ex             as character
   field aliquota       as character
   field vigencia_de    as character
   field vigencia_ate   as character
   index ch-pri is primary unique sequencia_ncm sequencia.

define temp-table tt-notas-complementares no-undo
   field sequencia_ncm  as integer
   field seq_ipi_det    as integer
   field sequencia      as integer
   field codigo         as character
   field nota           as CLOB
   field observacao     as character
   field vigencia_de    as character
   field vigencia_ate   as character
   index ch-pri is primary unique sequencia_ncm seq_ipi_det sequencia.
