/*****************************************************************************

    Programa    : sdin001i01.i
    
    Objetivo    : Include para vari†veis em geral do Excel
    
    Autor       : DatasulWA - Minas Gerais - Eduardo Leite
    
    Data        : 12/03/2009
    
    Revis∆o     :
    
*****************************************************************************/    

def var ChExcel                     as com-handle   no-undo.
def var ChBook                      as com-handle   no-undo.
def var ChSheet                     as com-handle   no-undo.
                                       
def var iLinha                      as integer      no-undo.
def var iColunas                    as integer      no-undo.
def var iNumCol                     as integer      no-undo.
def var iNumReg                     as integer      no-undo.
def var iNumLinha                   as integer      no-undo.

def var cNomeArqOrigem              as character    no-undo.
def var cNomeArqDestino             as character    no-undo.
def var cDiretorio                  as character    no-undo.
def var cRange                      as character    no-undo.
def var cColunas                    as character    no-undo
    init ",a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z".

do iColunas = 1 to num-entries(cColunas,","):

    assign cRange = cRange + replace(cColunas,
                                     ",",
                                     "," + entry(iColunas,cColunas,",")).

end.

assign cColunas = substr(cRange,2)
       cRange   = "".
