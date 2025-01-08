/** temp-tables de integra‡Æo da cdapi329 **/

define temp-table tt-emitente no-undo like emitente
   field cod-maq-origem as int format "9999"
   field num-processo   as int format ">>>>>>>>9" init 0
   field num-sequencia  as int format ">>>>>9"    init 0
   field ind-tipo-movto as int format "99"        init 1
   index ch-codigo is primary cod-maq-origem num-processo num-sequencia.

define temp-table tt-dist-emitente no-undo like dist-emitente
   field cod-maq-origem   as   integer format "9999"
   field num-processo     as   integer format ">>>>>>>>9" initial 0
   field num-sequencia    as   integer format ">>>>>9"    initial 0
   field ind-tipo-movto   as   integer format "99"        initial 1
   index ch-codigo is primary cod-maq-origem num-processo num-sequencia.

define temp-table tt-loc-entr  NO-UNDO  like loc-entr
    field cod-maq-origem        as integer 
    field num-processo          as integer format "999999999"
    field num-sequencia         as integer format "999999"
    field ind-tipo-movto        as integer format "99".

define temp-table tt-loc-entr-aux no-undo like tt-loc-entr
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.

define temp-table tt-int-loc-entr no-undo like int-loc-entr.

define temp-table tt-versao-integr no-undo
   field cod-versao-integracao as integer format "999"
   field ind-origem-msg        as integer format "99" /* i01mp900.i */.

define temp-table tt-erros-geral no-undo
   field identif-msg           as char    format "x(60)"
   field num-sequencia-erro    as integer format "999"
   field cod-erro              as integer format "99999"   
   field des-erro              as char    format "x(60)"
   field cod-maq-origem        as integer format "999"
   field num-processo          as integer format "999999999".

/** temp-tables do WS **/

define temp-table ttUsuario no-undo
   field LojaCodigo           as character
   field UsuarioCodigo        as character
   field UsuarioCodigoInterno as character
   field ContaCodigo          as character
   field LogOn                as character
   field LogOnNovo            as character
   field Senha                as character
   field SenhaAntiga          as character
   field SenhaNova            as character
   field Nome                 as character
   field Sobrenome            as character
   field Email                as character
   field Newsletter           as character
   field Sexo                 as character
   field UsuarioStatus        as character
   field StatusIntegracao     as character
   field DataInicio           as character
   field DataFim              as character
   field Texto1               as character
   field Texto2               as character
   field Texto3               as character
   field Numero1              as character
   field Numero2              as character
   field Numero3              as character
   index ch_pri LojaCodigo UsuarioCodigo.

define temp-table ttEnderecos no-undo
   field LojaCodigo            as character
   field EnderecoCodigo        as character
   field ContaCodigo           as character
   field AfiliadoCodigo        as character
   field Nome                  as character
   field Email                 as character
   field Cargo                 as character
   field Tipo                  as character
   field Finalidade            as character
   field TipoLogradouro        as character
   field Logradouro            as character
   field Numero                as character
   field Complemento           as character
   field Bairro                as character
   field Cidade                as character
   field Estado                as character
   field Pais                  as character
   field CEP                   as character
   field DDD1                  as character
   field Telefone1             as character
   field Ramal1                as character
   field DDD2                  as character
   field Telefone2             as character
   field Ramal2                as character
   field DDD3                  as character
   field Telefone3             as character
   field Ramal3                as character
   field DDDCelular            as character
   field Celular               as character
   field DDDFax                as character
   field Fax                   as character
   field Referencia            as character
   field EnderecoStatus        as character
   field DataInclusao          as character
   field Texto1                as character
   field Texto2                as character
   field Texto3                as character
   field Numero1               as character
   field Numero2               as character
   field Numero3               as character
   field EnderecoCodigoInterno as character
   index ch_pri LojaCodigo ContaCodigo EnderecoCodigo.

define temp-table ttConta no-undo
   field LojaCodigo         as character
   field ContaCodigo        as character
   field ContaCodigoInterno as character
   field ParceiroCodigo     as character
   field AfiliadoCodigo     as character
   field ValorGasto1ano     as character
   field ValorGasto90dias   as character
   field ValorGasto30dias   as character
   field Ranking            as character
   field Tipo               as character
   field Nome               as character
   field Sobrenome          as character
   field RazaoSocial        as character
   field NomeFantasia       as character
   field CPF                as character
   field CNPJ               as character
   field RG                 as character
   field IE                 as character
   field IM                 as character
   field DataNascimento     as character
   field ContaStatus        as character
   field DataInclusao       as character
   field Desconto           as character
   field LimiteCredito      as character
   field Texto1             as character
   field Texto2             as character
   field Texto3             as character
   field Numero1            as character
   field Numero2            as character
   field Numero3            as character
   index ch_pri LojaCodigo ContaCodigo.

define temp-table ttGrupos no-undo
   field LojaCodigo  as character
   field GrupoCodigo as character
   field Nome        as character
   field Descricao   as character
   field GrupoStatus as character
   field AcessoAdm   as character
   index ch_pri LojaCodigo GrupoCodigo.
