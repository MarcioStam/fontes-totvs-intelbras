{esp/showmsg.i}
/* es0590a.p - checa permissao de movimentacoes do estoque */

def input parameter c-programa  like programa.programa.
def input parameter c-cod-depos like deposito.cod-depos.
def input parameter l-tipo      as logical format "Entrada/Saida".
DEF INPUT PARAMETER c-usuario   AS CHAR.
def output parameter l-perm     as logical format "Sim/Nao".

{utp/ut-glob.i} 

assign l-perm = yes.

find usu-dep no-lock 
     where usu-dep.cod-depos = c-cod-depos
       and usu-dep.programa  = c-programa
       and usu-dep.usuario   = c-usuario no-error.
if not avail usu-dep then do:
   IF NOT SESSION:REMOTE THEN
       RUN ShowMessage (1, "Usu†rio sem autorizaá∆o~nMovimento cancelado", 
                           substitute("Usu†rio n∆o tem autorizaá∆o para movimentar dep¢sito &1 ~nSolicitar acesso ao L°der de Operaá‰es LOG÷STICAS", TRIM(caps(c-cod-depos)))).
   assign l-perm = no.
   leave.
end.

if not l-tipo then do:
    if not usu-dep.saida then do:
        IF NOT SESSION:REMOTE THEN
            RUN ShowMessage (1, "Usu†rio sem autorizaá∆o~nMovimento cancelado", 
                                substitute("Usu†rio n∆o pode retirar material do dep¢sito &1 ~nSolicitar acesso ao L°der de Operaá‰es LOG÷STICAS", TRIM(caps(c-cod-depos)))).
        assign l-perm = no.
        leave.
   end.
end.
else do:
    if not usu-dep.entrada then do:
        IF NOT SESSION:REMOTE THEN
            RUN ShowMessage (1, "Usu†rio sem autorizaá∆o~nMovimento cancelado", 
                                substitute("Usu†rio n∆o pode entrar material no dep¢sito &1 ~nSolicitar acesso ao L°der de Operaá‰es LOG÷STICAS", TRIM(caps(c-cod-depos)))).
        assign l-perm = no.
        leave.
   end.
end.
