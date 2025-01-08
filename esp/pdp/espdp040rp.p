{include/i-prgvrs.i espdp040 2.04.00.001}
/***********************************************************************
**  Programa..: ESP\PDP\espdp040RP.P
**  Autor.....: Antonio Gallo

compile \\tsclient\c\fontes\esp\pdp\espdp040rp.p save into c:\temp\pdp.

************************************************************************/

/****************************  Definitions  ****************************/
{esp/pdp/espdp040tt.i}
{include/i-rpvar.i}
    
{include/tt-edit.i}
{include/pi-edit.i}


FIND FIRST param-global NO-LOCK.
FIND FIRST mgcad.empresa NO-LOCK
   WHERE empresa.ep-codigo = param-global.empresa-pri.
/* FIND FIRST estabelec NO-LOCK */
/*    WHERE estabelec.ep-codigo = empresa.ep-codigo. */
/*    */

/****************************  Temp-Tables  ****************************/

def temp-table tt-ped-fat
    field atendente    as char format "x(25)"
    field cod-emitente like emitente.cod-emitente
    field nome-emit    like emitente.nome-emit
    field nr-pedido    like ped-venda.nr-pedido
    field nr-pedcli    like ped-venda.nr-pedcli
    field dt-implant   like ped-venda.dt-implant
    field nr-nota-fis like nota-fiscal.nr-nota-fis
    field dt-emis-nota like nota-fiscal.dt-emis-nota
    field nome-transp  like ped-venda.nome-transp
    field cidade-cif   like ped-venda.cidade-cif
    field it-codigo    like ped-item.it-codigo
    field desc-item    like item.desc-item
    field quantidade   as dec
    field observacoes  like ped-venda.observacoes .    


    
    

    
/****************************  Variaveis    ****************************/
def var i-cont as int.
def var c-local    as char format "X(13)".
def var cObs as char no-undo.


def var c-nr-nota-fis  like nota-fiscal.nr-nota-fis.
def var d-dt-emis-nota like nota-fiscal.dt-emis-nota.
       




    /*def var i-reg as recid.
    def var i-req as int.
    def var i-sequencia as int.
    def var c-arquivo as char format "x(40)".
    def var i-quantidade like ped-item.qt-requisitada.
****************************  Frames       ****************************/

FORM    tt-ped-fat.cod-emitente
        tt-ped-fat.nome-emit
        tt-ped-fat.nr-pedcli
        tt-ped-fat.nr-pedido
        tt-ped-fat.dt-implant
        tt-ped-fat.nr-nota-fis
        tt-ped-fat.dt-emis-nota
        tt-ped-fat.nome-transp
        tt-ped-fat.cidade-cif 
        tt-ped-fat.it-codigo
        tt-ped-fat.desc-item
        tt-ped-fat.quantidade WITH FRAME fDetalhe-102 NO-ATTR-SPACE STREAM-IO WIDTH 255 DOWN.

form header
    "Ped Cli      Cliente         C¢digo      Pedido Seq  Qtde     ALM     LAB Observa‡äes" at 1 skip
    "------------ ------------ --------- ----------- --- ----- ------- ------- --------------------------------------------------------" at 1 skip    with frame fCabec-2 no-labels no-attr-space stream-io page-top width 132.  
    
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

/*
 * for each tt-raw-digita:
 *     create tt-digita.
 *     raw-transfer tt-raw-digita.raw-digita to tt-digita.
 * end. 
 */

def var h-acomp      as handle no-undo.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Relat¢rio Saldo dos Itens do Pedido"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "espdp040"
       c-versao       = "2.04"
       c-revisao      = "002".

if tt-param.cod-estabel = "102" then do:
   find first atendente where
              atendente.cd-oper = int(tt-param.tp-pedido-ini) no-lock no-error.
              
   assign c-empresa = string(tt-param.tp-pedido-ini) +  " - " + string(atendente.nm-oper).
   
   end.
   



/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    {include/i-rpcab.i}
    {include/i-rpout.i}
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

   run utp/ut-acomp.p persistent set h-acomp.  

   run pi-inicializar in h-acomp (input "Montando Relat¢rio...").
   run piMontaRelat.
   run pi-inicializar in h-acomp (input "Imprimindo...").
   run piImprimeRelat.
   run piImprimeRelat-txt.
   run pi-finalizar in h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".
end.

/* **********************  Internal Procedures  *********************** */


PROCEDURE piMontaRelat:
    EMPTY TEMP-TABLE tt-ped-fat.
    
    RUN pi-acompanhar IN h-acomp (INPUT "PiMontaRelat...").

      
    FOR EACH  ped-venda NO-LOCK WHERE 
              ped-venda.dt-implant  >= tt-param.dt-implant-ini and
              ped-venda.dt-implant  <= tt-param.dt-implant-fim and
              ped-venda.cod-sit-ped  = 3 and
              ped-venda.nr-pedido   >= tt-param.nr-pedido-ini and
              ped-venda.nr-pedido   <= tt-param.nr-pedido-fim and
              ped-venda.tp-pedido   >= tt-param.tp-pedido-ini and
              ped-venda.tp-pedido   <= tt-param.tp-pedido-fim use-index ch-implant,
        first emitente no-lock
        where emitente.nome-abrev = ped-venda.nome-abrev,
        first atendente where 
              atendente.cd-oper = int(ped-venda.tp-pedido) no-lock :
        
        if ped-venda.cod-estabel ne tt-param.cod-estabel then next.
        
        
        
        find first nota-fiscal where 
                   nota-fiscal.nome-ab-cli = ped-venda.nome-abrev and
                   nota-fiscal.nr-pedcli  = ped-venda.nr-pedcli  no-lock no-error.
                   if avail nota-fiscal then assign c-nr-nota-fis  = nota-fiscal.nr-nota-fis
                                                    d-dt-emis-nota = nota-fiscal.dt-emis-nota.
                                        else assign c-nr-nota-fis = ""
                                                    d-dt-emis-nota = ?.
                                                    
                                                    
        
        
        
        RUN pi-acompanhar IN h-acomp (INPUT "Montando Rel: " + ped-venda.nr-pedcli).
               

        FOR EACH  ped-item FIELDS(ped-item.it-codigo ped-item.qt-pedida ped-item.qt-alocada) OF ped-venda 
            WHERE NO-LOCK,
            first item where 
                  item.it-codigo = ped-item.it-codigo no-lock:
            
           /*  if (ped-item.qt-pedida - ped-item.qt-alocada) <= 0 then next. */
            
                   
            FIND FIRST tt-ped-fat 
                 WHERE tt-ped-fat.nr-pedido = ped-venda.nr-pedido 
                 AND   tt-ped-fat.it-codigo = ped-item.it-codigo NO-ERROR.
                 
            IF NOT AVAIL tt-ped-fat THEN DO:
                
                CREATE tt-ped-fat.            
                ASSIGN tt-ped-fat.atendente      = atendente.nm-oper
                       tt-ped-fat.cod-emitente   = ped-venda.cod-emitente
                       tt-ped-fat.nome-emit      = emitente.nome-emit
                       tt-ped-fat.nr-pedcli      = ped-venda.nr-pedcli
                       tt-ped-fat.nr-pedido      = ped-venda.nr-pedido 
                       tt-ped-fat.dt-implant     = ped-venda.dt-implant
                       tt-ped-fat.cidade-cif     = ped-venda.cidade-cif
                       tt-ped-fat.nome-transp    = ped-venda.nome-transp 
                       tt-ped-fat.nr-nota-fis    = c-nr-nota-fis
                       tt-ped-fat.dt-emis-nota   = d-dt-emis-nota
                       tt-ped-fat.observacoes    = ped-venda.observacoes
                       tt-ped-fat.it-codigo      = ped-item.it-codigo
                       tt-ped-fat.desc-item      = item.desc-item
                       tt-ped-fat.quantidade     = tt-ped-fat.quantidade + ped-item.qt-pedida.
            end.
                   
        END.
    END.
        
         
      
    

END PROCEDURE.


PROCEDURE piImprimeRelat:

for each tt-ped-fat where 
      by tt-ped-fat.dt-implant
      by tt-ped-fat.nr-pedido:
      

         disp tt-ped-fat.cod-emitente
              tt-ped-fat.nome-emit
              tt-ped-fat.nr-pedcli
              tt-ped-fat.nr-pedido
              tt-ped-fat.dt-implant
              tt-ped-fat.nr-nota-fis
              tt-ped-fat.dt-emis-nota
              tt-ped-fat.nome-transp
              tt-ped-fat.cidade-cif 
              tt-ped-fat.it-codigo
              tt-ped-fat.desc-item
              tt-ped-fat.quantidade WITH FRAME fDetalhe-102.
            DOWN WITH FRAME fDetalhe-102.
            
END.
            

END PROCEDURE.


PROCEDURE piImprimeRelat-txt:

    
    
            output to c:\temp\ped-fat.txt.
            
            put "Atendente;Cod-Assist.;Assistencia;Ped-Cli;Pedido;Data Implant;NF;Dt-Emis-Nota;Transportadora;Cidade;Item;Desc.Item;Quantidade;Observacao" skip.
            
            
            for each tt-ped-fat:
            
            RUN pi-acompanhar IN h-acomp (INPUT "Pedidos.102 : " + tt-ped-fat.nr-pedcli).

            
            
            
                put tt-ped-fat.atendente    ";"
                    tt-ped-fat.cod-emitente ";"
                    tt-ped-fat.nome-emit    ";"
                    tt-ped-fat.nr-pedcli    ";"
                    tt-ped-fat.nr-pedido    ";"
                    tt-ped-fat.dt-implant   ";"
                    tt-ped-fat.nr-nota-fis  ";"
                    tt-ped-fat.dt-emis-nota ";"
                    tt-ped-fat.nome-transp  ";"
                    tt-ped-fat.cidade-cif   ";"
                    tt-ped-fat.it-codigo    ";"
                    tt-ped-fat.desc-item    ";"
                    tt-ped-fat.quantidade   ";"
                    tt-ped-fat.observacoes  format "x(200)" skip .    
            end.
            
            output close.
      
    
  
    
END PROCEDURE.







