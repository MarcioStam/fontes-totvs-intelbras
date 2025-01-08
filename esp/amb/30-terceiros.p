DEFINE INPUT PARAMETER c-ambiente AS CHARACTER NO-UNDO.

define buffer b-usuar_grp_usuar for usuar_grp_usuar.

define buffer b-user-coml for user-coml.
FIND FIRST user-coml no-lock
     WHERE user-coml.usuario = 'ca051844'.

define buffer b-param-re for param-re.
find param-re no-lock
  where param-re.usuario = 'cl048739'.

define buffer b-conteudo-programa for conteudo-programa.
define variable i-seq       as integer   no-undo.
define variable c-programas as character no-undo.
assign c-programas = 'ft2200,espdp006,cd0202,bodi317va,gk0001,pd4000,ft0709,esftp012'.

for each usuar_grp_usuar no-lock
  where usuar_grp_usuar.cod_grp_usuar = 't62' /** Terceiros **/,
each usuar_mestre exclusive-lock
  where usuar_mestre.cod_usuario = usuar_grp_usuar.cod_usuario:

  assign usuar_mestre.dat_fim_valid = 12/31/9999
         usuar_mestre.cod_senha = base64-encode(sha1-digest('teste123'))
         usuar_mestre.cod_senha_framework = usuar_mestre.cod_senha
         usuar_mestre.dat_valid_senha = today - 1.

  // ADM
  if not can-find (first b-usuar_grp_usuar no-lock
                      where b-usuar_grp_usuar.cod_grp_usuar = 'adm'
                        and b-usuar_grp_usuar.cod_usuario = usuar_mestre.cod_usuario) then do:
    create b-usuar_grp_usuar.
    buffer-copy usuar_grp_usuar except cod_grp_usuar to b-usuar_grp_usuar.
    assign b-usuar_grp_usuar.cod_grp_usuar = 'adm'.
  end.

  // Libera todas as naturezas
  if not can-find (first usuar-nat-operacao no-lock
                     where usuar-nat-operacao.cod-usuario = usuar_mestre.cod_usuario) then do:
    create usuar-nat-operacao.
    assign usuar-nat-operacao.cod-usuario  = usuar_mestre.cod_usuario 
           usuar-nat-operacao.nat-operacao = '*'.
  end.

  // Permissoes no comercial
  if not can-find (first b-user-coml no-lock
                     where b-user-coml.usuario = usuar_mestre.cod_usuario) then do:
    create b-user-coml.
    buffer-copy user-coml except usuario to b-user-coml.
    assign b-user-coml.usuario = usuar_mestre.cod_usuario.
  end.

  // Permissoes no recebimento
  if not can-find (first b-param-re no-lock
                     where b-param-re.usuario = usuar_mestre.cod_usuario) then do:
    create b-param-re.
    buffer-copy param-re except usuario to b-param-re.
    assign b-param-re.usuario = usuar_mestre.cod_usuario.
  end.

  for each conteudo-programa no-lock
    where conteudo-programa.conteudo = 'ca051844',
    first ponto-programa no-lock
      where ponto-programa.cod-programa = conteudo-programa.cod-programa
        and lookup(ponto-programa.nome-programa, c-programas) > 0:

    find last b-conteudo-programa no-lock
      where b-conteudo-programa.cod-programa = ponto-programa.cod-programa.

    assign i-seq = b-conteudo-programa.sequencia + 1.

    if not can-find (first b-conteudo-programa no-lock
                     where b-conteudo-programa.cod-programa = ponto-programa.cod-programa
                       and b-conteudo-programa.conteudo     = usuar_mestre.cod_usuario) then do:
      create b-conteudo-programa.
      buffer-copy conteudo-programa except sequencia conteudo to b-conteudo-programa.
      assign b-conteudo-programa.sequencia = i-seq
             b-conteudo-programa.conteudo  = usuar_mestre.cod_usuario.
    end.
  end.

  for each ponto-programa no-lock
    where ponto-programa.nome-programa = 'espdp006'
      and ponto-programa.ponto = 5,
    each conteudo-programa no-lock
      where conteudo-programa.cod-programa = ponto-programa.cod-programa
        and conteudo-programa.conteudo matches '*ca051844*':

    find last b-conteudo-programa no-lock
      where b-conteudo-programa.cod-programa = ponto-programa.cod-programa.

    assign i-seq = b-conteudo-programa.sequencia + 1.

    if not can-find (first b-conteudo-programa no-lock
                     where b-conteudo-programa.cod-programa = ponto-programa.cod-programa
                       and b-conteudo-programa.conteudo     = replace(conteudo-programa.conteudo, 'ca051844', usuar_mestre.cod_usuario)) then do:
      create b-conteudo-programa.
      buffer-copy conteudo-programa except sequencia conteudo to b-conteudo-programa.
      assign b-conteudo-programa.sequencia = i-seq
             b-conteudo-programa.conteudo  = replace(conteudo-programa.conteudo, 'ca051844', usuar_mestre.cod_usuario).
    end.
  end.
end.

return 'ok'.
