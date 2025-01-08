def input param p-programa as char no-undo.
def input param p-prog as char no-undo.
def input param p-descon as logical no-undo.
def input param p-dir as char no-undo.
def output param p-erro as char no-undo.

if p-descon then
   disconnect ems5 no-error.
else do:
  connect /opt/ems/ems5/ems5 no-error.
  run scripts-8080/datasul-appserver-alias.p (input '1').
end.

file-info:file-name = p-dir + p-prog.
if file-info:file-type begins "D" and index(file-info:file-type, "W", 2) > 0 then do:   
    compile value(session:temp-directory + p-programa) save into value(p-dir + p-prog) no-error.
    if compiler:error then
       p-erro = codepage-convert(substitute("Erro de compilaá∆o em &1 na linha &2 coluna &3",
                           COMPILER:FILENAME,
                           string(COMPILER:ERROR-ROW),
                           string(COMPILER:ERROR-COL)), "ibm850", "iso8859-1").
end.
else 
  p-erro = codepage-convert(substitute("Diret¢rio &1 em &2 n∆o encontrado ou sem permiss∆o de escrita",
                            p-prog, p-dir), "ibm850", "iso8859-1").
                      
if not connected('ems5') then do:
  connect /opt/ems/ems5/ems5 no-error.
  run scripts-8080/datasul-appserver-alias.p (input '1').
end.
