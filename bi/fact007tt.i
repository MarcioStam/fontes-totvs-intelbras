define temp-table tt-param no-undo
   field usuario     as character
   field senha       as character.

define temp-table tt-unid no-undo
   field cod_unid_negoc as character format 'x(3)'
   field perc-unid-neg  as decimal   format '>>9.9999'
   FIELD val-utilizado  AS DECIMAL
   index idx_pri is primary unique cod_unid_negoc.

define temp-table tt-unid-aux no-undo
   FIELD cdn_cliente    AS INT
   field cod_unid_negoc as character format 'x(3)'
   field perc-unid-neg  as decimal   format '>>9.9999'
   FIELD val-utilizado  AS DECIMAL
   index idx_pri is primary unique cdn_cliente cod_unid_negoc.

define temp-table ttFactLimiteCredito no-undo
   field CD_Emitente            like emitente.cod-emitente
   field CD_Representante       like emitente.cod-rep
   field CD_Pais                like emitente.pais
   field CD_Estado              like emitente.estado
   field CD_Cidade              like emitente.cidade
   field CD_Indicador_Credito   like emitente.ind-cre-cli
   field CD_Unidade_Negocio     like unid-neg-fat.cod_unid_negoc
   FIELD CD_Moeda               LIKE moeda.mo-codigo
   FIELD CD_Tipo_Limite_Credito AS INT /* ** 1 - Intelbras, 2 - SC,  3 - HSBC ***/
   field DT_Limite_Credito      as date
   field NM_Limite_Total        as decimal
   field NM_Limite_Utilizado    as decimal
   index idx_pri is primary unique CD_Emitente CD_Tipo_Limite_Credito CD_Unidade_Negocio CD_Moeda.
