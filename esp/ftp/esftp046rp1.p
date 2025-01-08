/****************************  Definitions  ****************************/
{include/i-prgvrs.i ESFTP046 2.04.00.001}

{esp/ftp/esftp046.i}
{utp/ut-glob.i}
{include/i-rpvar.i}
/****************************  Temp-Tables  ****************************/

def temp-table tt-nf
    field i-tipo        as int format "9" /* 1-Nacional s/ZF 2-Nac. C/ZF 3-Exportacao */
    field it-codigo     like item.it-codigo format "X(07)"
    field descricao     as char format "X(36)" label "Descricao"
    field class-fiscal  like item.class-fiscal
    field nat-operacao  like it-nota-fisc.nat-operacao
    field nr-nota-fis   like nota-fiscal.nr-nota-fis
    field serie-docto   like docum-est.serie-docto
    field dt-emis-nota  like nota-fiscal.dt-emis-nota
    field dt-trans      like docum-est.dt-trans
    field fm-codigo     like item.fm-codigo
    field qt-fatura     like it-nota-fisc.qt-faturada[1] 
    field vl-merc-liq   like it-nota-fisc.vl-merc-liq  
    field vl-ipi-it     like it-nota-fisc.vl-ipi-it    
    field vl-icms-it    like it-nota-fisc.vl-icms-it
    field vl-pis-cofins as dec format ">,>>>,>>>,>>9.99" label "PIS/COFINS"
    field qt-devolvida  like devol-cli.qt-devolvida format "->,>>>,>>>,>>9.99"
    field vl-devol      like devol-cli.vl-devol
    field vl-ipi-devol  as dec format "->,>>>,>>>,>>9.99" label "IPI Devol"
    field vl-icms-devol as dec format "->,>>>,>>>,>>9.99" label "ICMS Devol"
    field vl-pis-cofins-devol as dec format "->,>>>,>>>,>>9.99" 
                              label "PIS/COFINS Devol"
    field estado        like emitente.estado
    field cod-emitente  like emitente.cod-emitente
    field vl-taxa-exp   like nota-fiscal.vl-taxa-exp
    field cod-estabel   like docum-est.cod-estabel
    field portaria      as char format "x(20)" label "Portaria"
    index tt-nf is primary unique i-tipo cod-emitente dt-emis-nota nat-operacao nr-nota-fis
                                  class-fiscal fm-codigo it-codigo.


def input parameter table for tt-param.
def input parameter table for tt-nf.


/* ***************************  Main Block  *************************** */
find first tt-param no-error.


{include/i-rpcab.i}
{include/i-rpout.i}
/*
put "T Item    Descricao                            Class Fisc"
    " Nat Op NF                  Emissao Familia    Quant Fatur    Vl Mercad Liq   "
    "Valor IPI Item     Vl ICMS Item       PIS/COFINS       Quant Devol      Vl Devolucao         "
    "IPI Devol        ICMS Devol    PIS/COFINS Dev  UF      Cliente   Taxa exportacao" skip.
*/  
for each tt-nf where tt-nf.i-tipo <= 6:
    put tt-nf.i-tipo ";"
        tt-nf.it-codigo ";"
        tt-nf.descricao ";"
        tt-nf.class-fiscal ";"
        tt-nf.nat-operacao ";"
        tt-nf.nr-nota-fis ";"
        tt-nf.dt-emis-nota ";"
        tt-nf.fm-codigo ";"
        tt-nf.qt-fatura ";"
        tt-nf.vl-merc-liq ";"
        tt-nf.vl-ipi-it ";"    
        tt-nf.vl-icms-it ";"   
        tt-nf.vl-pis-cofins ";"
        tt-nf.qt-devolvida ";" 
        tt-nf.vl-devol ";"    
        tt-nf.vl-ipi-devol ";"
        tt-nf.vl-icms-devol ";"
        tt-nf.vl-pis-cofins-devol ";"
        tt-nf.estado ";"
        tt-nf.cod-emitente ";"
        tt-nf.vl-taxa-exp 
        skip. 
end.

for each tt-nf where tt-nf.i-tipo = 7:
    put tt-nf.i-tipo ";"
        tt-nf.cod-estabel ";"
        tt-nf.cod-emitente ";"
        tt-nf.nr-nota-fis ";"
        tt-nf.serie-docto ";"
        tt-nf.dt-emis-nota ";"            
        tt-nf.nat-operacao ";"
        tt-nf.dt-trans ";" 
        tt-nf.descricao ";"
        tt-nf.portaria ";"
        tt-nf.qt-fatura ";"
        tt-nf.vl-merc-liq ";"
        tt-nf.vl-ipi-it ";"    
        tt-nf.vl-icms-it ";"   
        skip. 
end.

{include/i-rpclo.i}
RETURN "OK".    


