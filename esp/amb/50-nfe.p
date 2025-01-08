DEFINE INPUT PARAMETER c-ambiente AS CHARACTER NO-UNDO.

disable triggers for load of estabelec.
disable triggers for load of param-gener.
disable triggers for load of param-manif-destin.

// Colaboração
for each param-gener exclusive-lock
   where param-gener.cod-chave-1 = 'param-geral-tc':
   if param-gener.cod-param = 'dir-arquivos' then
      assign param-gener.cod-valor = '~\~\homo-neogrid-01~\neogrid'.
   else if param-gener.cod-param = 'dir-doctos-lidos' then
      assign param-gener.cod-valor = '~\~\homo-neogrid-01~\neogrid~\NETWORK'.
   else if param-gener.cod-param = 'dir-edi' then
      assign param-gener.cod-valor = '~\~\homo-neogrid-01~\neogrid~\NETWORK~\EDI'.
   else if param-gener.cod-param = 'dir-gfe' then
      assign param-gener.cod-valor = '~\~\homo-neogrid-01~\neogrid~\NETWORK~\GFe'.
   else if param-gener.cod-param = 'dir-mde' then
      assign param-gener.cod-valor = '~\~\homo-neogrid-01~\neogrid~\NETWORK~\MDe'.
   else if param-gener.cod-param = 'dir-recepcao-docto' then
      assign param-gener.cod-valor = '~\~\homo-neogrid-01~\neogrid~\NETWORK~\RECEPCAO'.
end.

for first ponto-programa no-lock
   where ponto-programa.nome-programa = 'cdapi590',
   first conteudo-programa of ponto-programa exclusive-lock:

   assign conteudo-programa.conteudo = '/opt/totvs/neogrid/homologacao/'.
end.

for each estabelec exclusive-lock:
    //assign estabelec.des-local-arq = '~\~\totvs~\nfe~\' + estabelec.cod-estabel + '~\insercao~\txt~\'
    assign estabelec.idi-tip-emis-nf-eletro = 2.
end.

for each param-manif-destin exclusive-lock:
  assign param-manif-destin.idi-md-ambien = 2.
end.

/*B2C*/
FOR FIRST param-b2c EXCLUSIVE-LOCK:
    ASSIGN param-b2c.url-webservices = "http://homologacao.ikeda.com.br/Intelbras2010/ikcwebservice".
END.

return 'ok'.
