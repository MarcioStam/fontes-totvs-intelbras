def input parameter r-item as recid.

def var c-programa as char initial "es0639".
def var c-arquivo as char.
def var c-perm          as char.
def var c-narrativa     like narrativa.descricao[1].
def var c-it-codigo     like item.it-codigo.
def var l-fm-codigo     as log format "S/N".

find first item no-lock where
     recid(item) = r-item no-error.
     
if not avail item then next.

/*************** ROTINA PARA ATUALIZAR O ITEM NOVO NO ORACLE ****************/

   run esp/es0669.p (input "yes", 
                     "item", 
                     upper(item.it-codigo), 
                     "", "", "", "", "", "", "", "").



/************ FIM DA ROTINA PARA ATUALIZAR O ITEM NOVO NO ORACLE  ***********/
