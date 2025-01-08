{include/i-prgvrs.i ESFTP044 2.04.00.002}
/***********************************************************************
**  Programa..: ESP\FTP\ESFTP044RP.P
**  Autor.....: Anderson Cenci
**  Data......: Mar‡o/2008 - Desenvolvimento
**  Descricao.: Relatorio do CAT - Controle de Assistˆncia T‚cnica
**  VersÆo....: 001 04/04/2008
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/
{esp/ftp/esftp044.i}
{include/i-rpvar.i}

/****************************  Temp-Tables  ****************************/
/****************************  Variaveis    ****************************/

def var i-cont                as integer no-undo.
def var c-mes as char  extent 12 initial ["Janeiro","Fevereiro","Marco","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"] format "x(20)".
{utp/utapi019.i}
{upc\btb910za-upc.i}

/****************************  Frames       ****************************/

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.
{include/tt-edit.i}
{include/pi-edit.i}

def var h-acomp      as handle no-undo.
def var de-vl-cat    as dec format ">>>,>>>,>>9.99"no-undo.
def var de-vl-a-pagar   as dec format ">>>,>>>,>>9.99" no-undo.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Controle de Assistˆncia T‚cnica"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "ESFTP044"
       c-versao       = "2.04"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    /*{include/i-rpcab.i}*/
    {include/i-rpout.i &pagesize="0"}
    /*
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
    */
   run utp/ut-acomp.p persistent set h-acomp.  
   run pi-inicializar in h-acomp (input "Imprimindo...").
   run piImprimeRelat.
   run pi-finalizar in h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".
end.

/* **********************  Internal Procedures  *********************** */


PROCEDURE piImprimeRelat:
   for each cat no-lock
       where cat.cod-estabel = "103" /*v_cod_estab_usuar*/
         and cat.nr-cat     >= tt-param.fi-cat-ini  
         and cat.nr-cat     <= tt-param.fi-cat-fim
         and cat.sequencia  >= tt-param.fi-sequencia-ini
         and cat.sequencia  <= tt-param.fi-sequencia-fim
         and cat.dt-cat >= tt-param.fi-dt-emissao-ini
         and cat.dt-cat <= tt-param.fi-dt-emissao-fim
       break by cat.nr-cat
             by cat.sequencia:
       
        if first-of(cat.nr-cat) then do:  
            find emitente where emitente.cod-emitente = cat.cod-emitente no-lock no-error.
            find first cond-pagto 
            where cond-pagto.cod-cond-pag = cat.cod-cond-pag no-lock no-error.
            find estabelec where estabelec.cod-estabel = cat.cod-estabel no-lock no-error.            
            find transporte where transporte.cod-transp = cat.cod-transp no-lock no-error.                 
        end.             
             
        RUN pi-acompanhar IN h-acomp (INPUT "Lendo CAT:" + string(cat.nr-cat) + " - " + string(cat.sequencia)).
        
        if tt-param.rs-situacao = 1 and
           cat.ind-situacao <> 2 then next.
        else
            if tt-param.rs-situacao = 2 and
               cat.ind-situacao <> 1 then next.

        put estabelec.nome                           skip
            "Endere‡o: " estabelec.endereco
            " Bairro: "                       at 47  
             estabelec.bairro                        skip
            "    Fone: " emitente.telefone
            " Cidade: " at 47
            estabelec.cidade      
            " - " estabelec.estado
            " - " estabelec.cep                      skip
            "     Fax: " emitente.telefax
            "CNPJ: "                          at 50  
            estabelec.cgc
            skip(2)   
            "Controle de Assistˆncia T‚cnica" at 44  skip(2).
        
        put "N.CAT: " cat.nr-cat format "999,999" at 12 "/"
            cat.sequencia format "99"             at 20
            "Data: "                              at 35
            cat.dt-cat
            "Validade: "                          at 55
            cat.dt-validade
            "Telefone: "                          at 79 
            emitente.telefone                           skip
            "Cod.Cliente: "  emitente.cod-emitente
            "Cliente: "                           at 32
            emitente.nome-abrev
            "Fax:"                                at 84 
            emitente.telefax                            skip
            "RazÆo Social: " emitente.nome-emit  
            "Cidade/UF/CEP: "                     at 74
             emitente.cidade + "/" + emitente.estado + "/" + emitente.cep skip
            "CNPJ: " emitente.cgc 
            "Insc.Estadual:"                      at 74 
            emitente.ins-estadual skip
            "Cond.Pagamento: " cond-pagto.descricao skip(2)
            
            "Transportadora: " transporte.nome skip(2)
            
            "C¢digo          Descri‡Æo do Produto                    Quant. Tb.MO   Vlr.Unit. Vlr.Total   Desc% Total  c/Desc" skip
            "----------------------------------------------------------------------------------------------------------------" skip.
        assign de-vl-cat = 0
               de-vl-a-pagar = 0.
        
        for each cat-item no-lock
            where cat-item.cod-estabel = cat.cod-estabel
              and cat-item.nr-cat      = cat.nr-cat
              and cat-item.sequencia   = cat.sequencia,
            first item no-lock
            where item.it-codigo = cat-item.it-codigo:            
          
            put cat-item.it-codigo
                item.desc-item       format "x(36)"
                cat-item.quantidade  format ">>,>>>.99" at 54
                cat-item.tabela-mo   format "x(08)"     at 64
                cat-item.vl-unitario format ">>,>>9.99" at 72
                cat-item.quantidade * cat-item.vl-unitario format ">>,>>9.99" at 82
                cat-item.perc-desconto format "->>9.99"   at 92
                cat-item.vl-tot-item   format ">>>>,>>>9.99" at 101 skip.                
                
            if cat-item.ind-tipo-faturamento <> 1 then
                assign de-vl-cat = de-vl-cat + (cat-item.quantidade * cat-item.vl-unitario)
                       de-vl-a-pagar = de-vl-a-pagar + cat-item.vl-tot-item.                    
        end.
        
        assign de-vl-a-pagar = de-vl-a-pagar + cat.vl-mao-obra + cat.vl-acrescimo.        
        
        put "-------------------------------------------------------------------------------------------------------------" skip

            "Valor Total da Assistˆncia T‚cnica: " at 63 de-vl-cat        format ">>>,>>>,>>9.99" skip
            "                       MÆo de Obra: " at 63 cat.vl-mao-obra  format ">>>,>>>,>>9.99" skip
            "                 Total de Desconto: " at 63 cat.vl-desconto  format ">>>,>>>,>>9.99" skip
            "                         Acr‚scimo: " at 63 cat.vl-acrescimo format ">>>,>>>,>>9.99" skip
            "       Valor da Assitˆncia T‚cnica: " at 63 de-vl-a-pagar    format ">>>,>>>,>>9.99" skip.
        put "-------------------------------------------------------------------------------------------------------------" skip
            "Observa‡Æo: " at 09.
        RUN pi-print-editor(INPUT cat.observacao, INPUT 60).
        FOR EACH tt-editor:
            put tt-editor.conteudo at 21 skip.
        END.
        put "    Consertado por: " cat.consertado-por
                                   cat.dt-conserto        skip
            "       Testado por: " cat.testado-por 
                                   cat.dt-teste           skip
            " Defeito Reclamado: " cat.defeito-reclamado  skip
            "Defeito Constatado: " cat.defeito-constatado skip
            "           Solu‡Æo: " cat.solucao skip.
        put "----------------------------------------------------------------------------------------------------------------" skip(2).
            
        page.
   end. 
   
END PROCEDURE.

