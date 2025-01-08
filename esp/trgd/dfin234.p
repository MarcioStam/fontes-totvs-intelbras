/* -------------------------------------------------------------------------------------------------------------
Programa : trgd/dfin234.p
Funcao   : Trigger criada para eliminar o registro da tabela de extens∆o int-portador criada no cadastro do portador do 
Autor    : Robson Jeorge Moser - Gestech
Data     : 12/2004
Alteraá∆o:
Vers∆o   : 001
-------------------------------------------------------------------------------------------------------------- */

DEFINE PARAMETER BUFFER b-portador FOR emscad.portador.
                                  
find int-portador EXCLUSIVE-LOCK
    where int-portador.cod_portador = b-portador.cod_portador NO-ERROR.
if available int-portador then do:
   DELETE int-portador.
end.
