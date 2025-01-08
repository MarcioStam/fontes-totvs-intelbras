/****** CRIA ESPECIES E SERIES PARA AGILIZAR LEITURA DE NOTAS FISCAIS E 
        TITULOS                                 ************/


def temp-table tt-ser-esp
    field tipo    as log format "Serie/Especie"
    field codigo  as char format "X(3)"
    index tt-ser-esp is primary unique tipo codigo.
 
create tt-ser-esp.
assign tt-ser-esp.tipo = yes
       tt-ser-esp.codigo = "1".
create tt-ser-esp.
assign tt-ser-esp.tipo = yes
       tt-ser-esp.codigo = "3".

create tt-ser-esp.
assign tt-ser-esp.tipo = no
       tt-ser-esp.codigo = "DM".
create tt-ser-esp.
assign tt-ser-esp.tipo = no
       tt-ser-esp.codigo = "DP".


