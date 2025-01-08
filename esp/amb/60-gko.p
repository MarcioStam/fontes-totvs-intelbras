DEFINE INPUT PARAMETER c-ambiente AS CHARACTER NO-UNDO.
    
for first ponto-programa
   where ponto-programa.nome-programa = "gk0001"
     and ponto-programa.ponto         = 1,
   each conteudo-programa exclusive-lock
      where conteudo-programa.cod-programa = ponto-programa.cod-programa:

   if entry(1,conteudo-programa.conteudo,";") = "ENTRADAGKOWIN32" then
      assign conteudo-programa.conteudo = "ENTRADAGKOWIN32;~\~\erpintelbras~\arquivos$~\transport~\gko~\entrada~\teste~\".
   if entry(1,conteudo-programa.conteudo,";") = "ENTRADAGKOUNIX" then
      assign conteudo-programa.conteudo = "ENTRADAGKOUNIX;/opt/totvs/arquivos/transport/gko/entrada/teste/".
end.

for first ponto-programa
   where ponto-programa.nome-programa = "gk0002"
     and ponto-programa.ponto         = 1,
   each conteudo-programa exclusive-lock
      where conteudo-programa.cod-programa = ponto-programa.cod-programa:

   if entry(1,conteudo-programa.conteudo,";") = "SAIDAGKOWIN32" then
      assign conteudo-programa.conteudo = "SAIDAGKOWIN32;~\~\erpintelbras~\arquivos$~\transport~\gko~\saida~\teste~\".
   if entry(1,conteudo-programa.conteudo,";") = "SAIDAGKOUNIX" then
      assign conteudo-programa.conteudo = "SAIDAGKOUNIX;/opt/totvs/arquivos/transport/gko/saida/teste/".
   if entry(1,conteudo-programa.conteudo,";") = "BACKUPGKOWIN32" then
      assign conteudo-programa.conteudo = "BACKUPGKOWIN32;~\~\erpintelbras~\arquivos$~\transport~\gko~\integradoems~\teste~\".
   if entry(1,conteudo-programa.conteudo,";") = "BACKUPGKOUNIX" then
      assign conteudo-programa.conteudo = "BACKUPGKOUNIX;/opt/totvs/arquivos/transport/gko/integradoems/teste/".
end.

for first ponto-programa
   where ponto-programa.nome-programa = "gk0004"
     and ponto-programa.ponto         = 1,
   each conteudo-programa exclusive-lock
      where conteudo-programa.cod-programa = ponto-programa.cod-programa:

   if entry(1,conteudo-programa.conteudo,";") = "BACKUPGKOWIN32" then
      assign conteudo-programa.conteudo = "BACKUPGKOWIN32;~\~\erpintelbras~\arquivos$~\transport~\gko~\integradoems~\teste~\".
   if entry(1,conteudo-programa.conteudo,";") = "BACKUPGKOUNIX" then
      assign conteudo-programa.conteudo = "BACKUPGKOUNIX;/opt/totvs/arquivos/transport/gko/integradoems/teste/".
   if entry(1,conteudo-programa.conteudo,";") = "SAIDAGKOWIN32" then
      assign conteudo-programa.conteudo = "SAIDAGKOWIN32;~\~\erpintelbras~\arquivos$~\transport~\gko~\saida~\teste~\".
   if entry(1,conteudo-programa.conteudo,";") = "SAIDAGKOUNIX" then
      assign conteudo-programa.conteudo = "SAIDAGKOUNIX;/opt/totvs/transport/arquivos/gko/saida/teste/".
end.

for first ponto-programa
   where ponto-programa.nome-programa = "gk0005"
     and ponto-programa.ponto         = 1,
   each conteudo-programa exclusive-lock
      where conteudo-programa.cod-programa = ponto-programa.cod-programa:

   if entry(1,conteudo-programa.conteudo,";") = "SAIDAGKOWIN32" then
      assign conteudo-programa.conteudo = "SAIDAGKOWIN32;~\~\erpintelbras~\arquivos$~\transport~\gko~\saida~\teste~\".
   if entry(1,conteudo-programa.conteudo,";") = "SAIDAGKOUNIX" then
      assign conteudo-programa.conteudo = "SAIDAGKOUNIX;/opt/totvs/arquivos/transport/gko/saida/teste/".
   if entry(1,conteudo-programa.conteudo,";") = "BACKUPGKOWIN32" then
      assign conteudo-programa.conteudo = "BACKUPGKOWIN32;~\~\erpintelbras~\arquivos$~\transport~\gko~\integradoems~\teste~\".
   if entry(1,conteudo-programa.conteudo,";") = "BACKUPGKOUNIX" then
      assign conteudo-programa.conteudo = "BACKUPGKOUNIX;/opt/totvs/arquivos/transport/gko/integradoems/teste/".
end.

for first ponto-programa
   where ponto-programa.nome-programa = "gk0006"
     and ponto-programa.ponto         = 1,
   each conteudo-programa exclusive-lock
      where conteudo-programa.cod-programa = ponto-programa.cod-programa:

   if entry(1,conteudo-programa.conteudo,";") = "SAIDAGKOWIN32" then
      assign conteudo-programa.conteudo = "SAIDAGKOWIN32;~\~\erpintelbras~\arquivos$~\transport~\gko~\saida~\teste~\".
   if entry(1,conteudo-programa.conteudo,";") = "SAIDAGKOUNIX" then
      assign conteudo-programa.conteudo = "SAIDAGKOUNIX;/opt/totvs/arquivos/transport/gko/saida/teste/".
   if entry(1,conteudo-programa.conteudo,";") = "BACKUPGKOWIN32" then
      assign conteudo-programa.conteudo = "BACKUPGKOWIN32;~\~\erpintelbras~\arquivos$~\transport~\gko~\integradoems~\teste~\".
   if entry(1,conteudo-programa.conteudo,";") = "BACKUPGKOUNIX" then
      assign conteudo-programa.conteudo = "BACKUPGKOUNIX;/opt/totvs/arquivos/transport/gko/integradoems/teste/".
end.

for first ponto-programa
   where ponto-programa.nome-programa = "gk0007"
     and ponto-programa.ponto         = 1,
   each conteudo-programa exclusive-lock
      where conteudo-programa.cod-programa = ponto-programa.cod-programa:

   if entry(1,conteudo-programa.conteudo,";") = "ARQSPEDGKOWIN32" then
      assign conteudo-programa.conteudo = "ARQSPEDGKOWIN32;~\~\erpintelbras~\arquivos$~\transport~\gko~\saida~\sped~\sped.csv".
   if entry(1,conteudo-programa.conteudo,";") = "ARQSPEDGKOUNIX" then
      assign conteudo-programa.conteudo = "ARQSPEDGKOUNIX;/opt/totvs/arquivos/transport/gko/saida/sped/sped.csv".
end.

for first ponto-programa
   where ponto-programa.nome-programa = "gk0011"
     and ponto-programa.ponto         = 1,
   each conteudo-programa exclusive-lock
      where conteudo-programa.cod-programa = ponto-programa.cod-programa:

   if conteudo-programa.sequencia = 1 then
      assign conteudo-programa.conteudo = "~\~\erpintelbras~\arquivos$~\transport~\gko~\saida~\nfentregues~\teste~\".
   else if conteudo-programa.sequencia = 2 then
      assign conteudo-programa.conteudo = "/opt/totvs/arquivos/transport/gko/saida/nfentregues/teste/".
end.

for first ponto-programa
   where ponto-programa.nome-programa = "gk0011"
     and ponto-programa.ponto         = 2,
   each conteudo-programa exclusive-lock
      where conteudo-programa.cod-programa = ponto-programa.cod-programa:

   if conteudo-programa.sequencia = 1 then
      assign conteudo-programa.conteudo = "~\~\erpintelbras~\arquivos$~\transport~\gko~\saida~\nfentregues~\backup~\teste~\".
   else if conteudo-programa.sequencia = 2 then
      assign conteudo-programa.conteudo = "/opt/totvs/arquivos/transport/gko/nfentregues/backup/teste/".
end.

return 'ok'.
