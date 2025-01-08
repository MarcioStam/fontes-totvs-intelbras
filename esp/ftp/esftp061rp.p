/*****************************************************************************
**     Programa.........: esp/acr/ESFTP061rp.p
**     Descricao .......: RelatΩrio Objetivo x Realizado
**     Versao...........: 1.00.000
**     Autor............: Chaves - Gestech
**     Criado...........: 29/01/2005
**     Desc. Atualizaªío: 
**     Autor............: 
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESFTP061 2.04.00.001}

{esp/ftp/esftp061tt.i}
{utp/ut-glob.i}
{include/i-rpvar.i}
{cdp/cd0666.i}
{esinc/es0006.i}  /*** include com a procedure pi-busca-unid-negoc-item ***/

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

DEFINE TEMP-TABLE tt-unid-negoc NO-UNDO
    FIELD cod-unid-negoc AS CHARACTER
    FIELD descricao      AS CHARACTER.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

def var de-total-fatura     as decimal no-undo.
def var de-total-cta-adm    as decimal no-undo.
def var de-total-cta-com    as decimal no-undo.
def var de-total-p&d-cen    as decimal no-undo.
def var de-total-p&d-ter    as decimal no-undo.
def var de-total-fatur      as decimal no-undo.

def var de-tot-qtd                 as decimal no-undo. 
def var de-tot-receita             as decimal no-undo.   
def var de-tot-ipi                 as decimal no-undo.            
def var de-tot-rec-sem-ipi         as decimal no-undo.    
def var de-tot-vl-icms             as decimal no-undo.
def var de-tot-vl-icms-cp          as decimal no-undo.
def var de-tot-vl-icms-cpi         as decimal no-undo.
DEF VAR de-tot-vl-icms-subs        AS DECIMAL NO-UNDO.
def var de-tot-vl-pis              as decimal no-undo.
def var de-tot-vl-cofins           as decimal no-undo.
def var de-tot-vl-iss              as decimal no-undo.
def var de-tot-vl-icms-est         as decimal no-undo.
def var de-tot-vl-acordo           as decimal no-undo.      
def var de-tot-comissao            as decimal no-undo.       
def var de-tot-comissao-distrato   as decimal no-undo.       
def var de-tot-frete               as decimal no-undo.           
def var de-tot-custo-fixo-pro      as decimal no-undo.  
def var de-tot-rol                 as decimal no-undo.             
def var de-tot-custo-mat           as decimal no-undo.       
def var de-tot-lucro-bruto         as decimal no-undo.     
def var de-tot-vpc                 as decimal no-undo.
DEF VAR de-tot-prot-preco          AS DECIMAL NO-UNDO.
def var de-tot-preco-medio         as decimal no-undo.
def var de-tot-margem-contribuicao as decimal no-undo.
def var de-tot-marg-contrib-p&d    as decimal no-undo.
DEF VAR de-tot-vl-bicms-it         as decimal no-undo. 
DEF VAR de-tot-vl-CPRB             AS DECIMAL NO-UNDO.
DEF VAR de-tot-de-vl-icms-fcp      as decimal no-undo. 
DEF VAR de-tot-de-vl-icms-uf-dest  as decimal no-undo. 
DEF VAR de-tot-de-vl-icms-uf-remet as decimal no-undo. 

def var de-vl-frete          as decimal no-undo.
def var de-custo-mat         as decimal no-undo.
def var de-indice            as decimal no-undo.
def var de-indice-fis        as decimal no-undo.
def var de-perc              as decimal no-undo.
DEF VAR de-vl-tot-nota-cen   AS DEC NO-UNDO FORMAT "->>>,>>>,>>9.99".
DEF VAR de-vl-tot-nota-ter   AS DEC NO-UNDO FORMAT "->>>,>>>,>>9.99".
DEF VAR de-vl-tot-acordo     AS DEC NO-UNDO FORMAT "->>>,>>>,>>9.99".
DEF VAR de-vl-vpc-cen        AS DEC NO-UNDO FORMAT "->>>,>>>,>>9.99".
DEF VAR de-vl-vpc-ter        AS DEC NO-UNDO FORMAT "->>>,>>>,>>9.99".
DEF VAR de-vl-prot-preco     AS DEC NO-UNDO FORMAT "->>>,>>>,>>9.99".
DEF VAR de-vl-tot-cp         AS DEC NO-UNDO.
DEF VAR de-vl-tot-cliente    AS DEC NO-UNDO.
DEF VAR c-unid-neg           AS CHAR FORMAT "X(3)" NO-UNDO.
DEF VAR c-desc-grupo-canais  AS CHAR FORMAT "x(80)" NO-UNDO.

def var i-dia-fim            as integer no-undo.
def var i-mes-cta            as integer no-undo.
def var i-total-cliente      as integer no-undo.
def var i-cont               AS integer no-undo.

def var l-totaliza           as logical extent 6               initial no no-undo.
def var l-preco-medio        as logical format "CIF/Medio"     initial no no-undo.
def var l-utiliza-cif        as logical                                   no-undo.

DEFINE VARIABLE da-ult-dia-mes AS DATE        NO-UNDO.
DEFINE VARIABLE c-descricaoCat LIKE categoria-produto.desc-categoria  NO-UNDO.

DEF BUFFER b-fm-cod-com-aux FOR fam-com-item.
DEF BUFFER b-ITEM           FOR ITEM.
function fn-retorna-descricao-segmento returns character
  ( p-fm-cod-com as character )  forward.

/* Qualquer alteraªío nesta deve ser feita tamb≤m no ESFTP061RP1 */

def temp-table tt-est 
    field it-codigo    like estrutura.it-codigo
    field qtde         as dec format ">>>9.99999"
    index tt-est is primary unique it-codigo.

DEF BUFFER b-tt-calcula FOR tt-calcula.

def var i-mes-fat   as integer format "99"      no-undo.
def var i-ano-fat   as integer format "9999"    no-undo.

def var h-acomp      as handle no-undo.

{include/i-rpcab.i}
{include/i-rpout.i &pagesize="0"}

for each tt-calcula:
    delete tt-calcula.
end.

assign de-total-cta-com = 0
       de-total-cta-adm = 0
       de-total-p&d-cen = 0
       de-total-p&d-ter = 0.

assign l-vl-presente = IF l-vl-presente <> 0 THEN
                          (l-vl-presente / 100) + 1
                       ELSE
                          l-vl-presente
       i-mes-fat = month(da-data-ini)
       i-ano-fat = year(da-data-ini).

IF i-mes-fat = 12 THEN
    ASSIGN da-ult-dia-mes = DATE(12,31,i-ano-fat).
ELSE
    ASSIGN da-ult-dia-mes = DATE(i-mes-fat + 1,01,i-ano-fat)
           da-ult-dia-mes = da-ult-dia-mes - 1.

assign i-cont = 0.

assign tt-param.da-data-medio = (date((if i-mes-med = 12 
                                then 01
                                else i-mes-med + 1), 
                                01, 
                               (if i-mes-med = 12 
                                then i-ano-med + 1
                                else i-ano-med)) - 1).

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

assign c-sistema      = "Espec≠ficos Intelbras"
       c-titulo-relat = "Demonstrativo de Resultado"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESFTP061"
       c-versao       = "2.04"
       c-revisao      = "001".

/******** FAZ A CARGA DOS DADOS NA TABELA TEMPORARIA *******/
run utp/ut-acomp.p persistent set h-acomp.  
run pi-inicializar in h-acomp (input "Calculando...").
  
run esp/ftp/esftp061rp1.p (INPUT  TABLE tt-param,
                           INPUT  TABLE tt-raw-digita,
                           OUTPUT TABLE tt-calcula,
                           OUTPUT TABLE tt-erro).

assign de-total-fatur = 0
       de-vl-tot-nota-cen = 0
       de-vl-tot-nota-ter = 0.


run pi-acompanhar in h-acomp (input "Rateando por unidade de negΩcio ..").
assign de-tot-receita = 0
       de-vl-tot-acordo = 0
       de-vl-tot-cliente = 0.

run pi-acompanhar in h-acomp (input "Totalizando RelatΩrio").
run pi-totaliza.

assign  de-tot-qtd                 = 0 
        de-tot-receita             = 0      
        de-tot-ipi                 = 0             
        de-tot-rec-sem-ipi         = 0     
        de-tot-vl-icms             = 0
        de-tot-vl-icms-cp          = 0
        de-tot-vl-icms-cpi         = 0
        de-tot-vl-icms-subs        = 0
        de-tot-vl-pis              = 0
        de-tot-vl-cofins           = 0
        de-tot-vl-iss              = 0
        de-tot-vl-icms-est         = 0
        de-tot-vl-acordo           = 0       
        de-tot-comissao            = 0        
        
        de-tot-frete               = 0           
        de-tot-custo-fixo-pro      = 0  
        de-tot-rol                 = 0             
        de-tot-custo-mat           = 0       
        de-tot-lucro-bruto         = 0     
        de-tot-vpc                 = 0
        de-tot-prot-preco          = 0
        de-tot-margem-contribuicao = 0
        de-tot-marg-contrib-p&d    = 0
        de-tot-preco-medio         = 0
        de-tot-de-vl-icms-fcp      = 0
        de-tot-de-vl-icms-uf-dest  = 0
        de-tot-de-vl-icms-uf-remet = 0
         .
    
def var a as int.

run pi-inicializar in h-acomp (input "Imprimindo...").
run pi-acompanhar in h-acomp (input "Imprimindo NFS").

FOR EACH tt-unid-negoc:
    DELETE tt-unid-negoc.
END.

IF NOT tt-param.l-imp-nota THEN DO:
    /*imprime cabecalho*/
    PUT UNFORMATTED
        "Tipo;Data;Estab;Esp;Grupo;Neg;Mercado;Origem;Cliente;Matriz;CNPJ;Emitente;Client GC;AT;FamCom;Desc.Produto;Repres;UF;Pais;Item;Descricao;Qtd.Vendid.;Rec Liquida;IPI;ICMS Sub.Trib.;ICMS;ICMS cred.Pres.;ICMS Cred.Pres.Impo;PIS;COFINS;CPRB;ISS;Frete;Comissao;Acordo;Custo de Mat. Prima;GGF;PeD Estr;PeD LI;Coml Estr;Aá‰es Prom;P¢s Venda;Adm;Outras Op;Outras MKT;Desp Fin;Var.Camb;IR/CSSL;PL;NCM;Desc.Segmento;FamMat;CST;CF;Base ICMS;Nat Operac;Unid Neg Fatur;DESC Unid Neg Fatur;Categoria;DESC Cat;Grupo Canais;Estab Substitu°do;Unid.Neg Substitu°da;Segto Substitu°do;Vl ICMS FCP;Vl ICMS UF Dest;Vl ICMS UF Remet;Item Pai;Peso Bru Unit; Peso Liq Unit;Cod.Transp;Nome transportadora" SKIP.
END.
ELSE DO:
    /*imprime cabecalho*/
    PUT UNFORMATTED
        "Tipo;Data;Estab;Esp;Grupo;Neg;Mercado;Origem;Cliente;Matriz;CNPJ;Emitente;Client GC;AT;FamCom;Desc.Produto;Repres;UF;Pais;Item;Descricao;Qtd.Vendid.;Rec Liquida;IPI;ICMS Sub.Trib.;ICMS;ICMS cred.Pres.;ICMS Cred.Pres.Impo;PIS;COFINS;CPRB;ISS;Frete;Comissao;Acordo;Custo de Mat. Prima;GGF;PeD Estr;PeD LI;Coml Estr;Aá‰es Prom;P¢s Venda;Adm;Outras Op;Outras MKT;Desp Fin;Var.Camb;IR/CSSL;PL;Nota Fiscal;SÇrie;Seq. Item Nota;Data Emissao;NCM;Desc.Segmento;FamMat;CST;CF;Base ICMS;Nat Operac;Unid Neg Fatur;DESC Unid Neg Fatur;Categoria;DESC Cat;Grupo Canais;Estab Substitu°do;Unid.Neg Substitu°da;Segto Substitu°do;Vl ICMS FCP;Vl ICMS UF Dest;Vl ICMS UF Remet;Item Pai;Peso Bru Unit; Peso Liq Unit;Cod.Transp;Nome transportadora;Data Prev Entrega;Data Entrega;Cidade" SKIP.
END.
DEF VAR c-desc-unid                AS CHAR NO-UNDO.
DEF VAR c-unid                     AS CHAR NO-UNDO.
DEF VAR c-desc-unid-nota           AS CHAR NO-UNDO.
DEF VAR c-unid-nota                AS CHAR NO-UNDO.
DEF VAR de-dif-rec-sem-ipi         AS DEC  NO-UNDO.
DEF VAR de-dif-ipi                 AS DEC  NO-UNDO.
DEF VAR de-dif-vl-icms-subs        AS DEC  NO-UNDO.
DEF VAR de-dif-vl-icms             AS DEC  NO-UNDO.
DEF VAR de-dif-vl-icms-cp          AS DEC  NO-UNDO.
DEF VAR de-dif-vl-icms-cpi         AS DEC  NO-UNDO.
DEF VAR de-dif-vl-pis              AS DEC  NO-UNDO.
DEF VAR de-dif-vl-cofins           AS DEC  NO-UNDO.
DEF VAR de-dif-vl-iss              AS DEC  NO-UNDO.
DEF VAR de-dif-frete               AS DEC  NO-UNDO.
DEF VAR de-dif-comissao-distrato   AS DEC  NO-UNDO.
DEF VAR de-dif-vl-acordo           AS DEC  NO-UNDO.
DEF VAR de-dif-custo-mat           AS DEC  NO-UNDO.
DEF VAR de-dif-vl-bicms-it         AS DEC  NO-UNDO.
DEF VAR de-dif-custo-fixo-pro      AS DEC  NO-UNDO.
DEF VAR de-dif-vl-CPRB             AS DEC  NO-UNDO.
DEF VAR de-dif-de-vl-icms-fcp      AS DEC  NO-UNDO.
DEF VAR de-dif-de-vl-icms-uf-dest  AS DEC  NO-UNDO.
DEF VAR de-dif-de-vl-icms-uf-remet AS DEC  NO-UNDO.

DEF VAR l-houve-rateio     AS LOG  NO-UNDO.

DEF TEMP-TABLE tt-calcula-aux LIKE tt-calcula.

FOR EACH tt-calcula:
   /*WHERE tt-calcula.nr-nota-fis = "0758949":*/

    IF  NOT CAN-FIND (FIRST int-item-nota-fisc-kit
                      WHERE int-item-nota-fisc-kit.it-codigo = tt-calcula.it-codigo) THEN
        NEXT.

   ASSIGN de-tot-rec-sem-ipi         = tt-calcula.rec-sem-ipi
          de-tot-ipi                 = tt-calcula.ipi                
          de-tot-vl-icms-subs        = tt-calcula.vl-icms-subs       
          de-tot-vl-icms             = tt-calcula.vl-icms            
          de-tot-vl-icms-cp          = tt-calcula.vl-icms-cp         
          de-tot-vl-icms-cpi         = tt-calcula.vl-icms-cpi        
          de-tot-vl-pis              = tt-calcula.vl-pis             
          de-tot-vl-cofins           = tt-calcula.vl-cofins          
          de-tot-vl-iss              = tt-calcula.vl-iss             
          de-tot-frete               = tt-calcula.frete              
          de-tot-comissao-distrato   = tt-calcula.comissao-distrato  
          de-tot-vl-acordo           = tt-calcula.vl-acordo          
          de-tot-vl-bicms-it         = tt-calcula.vl-bicms-it     
          de-tot-de-vl-icms-fcp      = tt-calcula.de-vl-icms-fcp     
          de-tot-de-vl-icms-uf-dest  = tt-calcula.de-vl-icms-uf-dest 
          de-tot-de-vl-icms-uf-remet = tt-calcula.de-vl-icms-uf-remet
          de-tot-custo-mat           = tt-calcula.custo-mat    
          de-tot-custo-fixo-pro      = tt-calcula.custo-fixo-pro
          de-tot-vl-CPRB             = tt-calcula.rec-sem-ipi * 1 / 100. 

   ASSIGN de-dif-rec-sem-ipi         = 0
          de-dif-ipi                 = 0
          de-dif-vl-icms-subs        = 0
          de-dif-vl-icms             = 0
          de-dif-vl-icms-cp          = 0
          de-dif-vl-icms-cpi         = 0
          de-dif-vl-pis              = 0
          de-dif-vl-cofins           = 0
          de-dif-vl-iss              = 0
          de-dif-frete               = 0
          de-dif-comissao-distrato   = 0
          de-dif-vl-acordo           = 0
          de-dif-vl-bicms-it         = 0
          de-dif-custo-mat           = 0 
          de-dif-custo-fixo-pro      = 0
          de-dif-vl-CPRB             = 0
          de-dif-de-vl-icms-fcp      = 0
          de-dif-de-vl-icms-uf-dest  = 0
          de-dif-de-vl-icms-uf-remet = 0.

   ASSIGN l-houve-rateio  = NO.

   FOR EACH int-item-nota-fisc-kit NO-LOCK
      WHERE int-item-nota-fisc-kit.cod-estabel = tt-calcula.cod-estab-substituido
        AND int-item-nota-fisc-kit.serie       = tt-calcula.serie 
        AND int-item-nota-fisc-kit.nr-nota-fis = tt-calcula.nr-nota-fis
        AND int-item-nota-fisc-kit.nr-seq-fat  = tt-calcula.nr-seq-fat
        AND int-item-nota-fisc-kit.it-codigo   = tt-calcula.it-codigo
        BREAK BY int-item-nota-fisc-kit.perc-fatur :
        CREATE tt-calcula-aux.
        BUFFER-COPY tt-calcula EXCEPT /*it-codigo*/
                                      rec-sem-ipi      
                                      ipi              
                                      vl-icms-subs     
                                      vl-icms          
                                      vl-icms-cp       
                                      vl-icms-cpi      
                                      vl-pis           
                                      vl-cofins        
                                      vl-iss           
                                      frete            
                                      comissao-distrato
                                      vl-acordo        
                                      vl-bicms-it      
                                      custo-mat        
                                      custo-fixo-pro  TO tt-calcula-aux.

        FIND FIRST emitente 
            WHERE emitente.cod-emitente = tt-calcula.cod-emitente NO-LOCK NO-ERROR.

        FIND ITEM NO-LOCK
            WHERE ITEM.it-codigo = int-item-nota-fisc-kit.it-componente NO-ERROR.
        IF  AVAIL ITEM THEN DO:
            ASSIGN tt-calcula-aux.it-codigo-kit      = int-item-nota-fisc-kit.it-componente
                   tt-calcula-aux.it-codigo-kit-desc = ITEM.desc-item.

            /*UNIDADE NEG‡CIO*/
            RUN pi-busca-unidade-neg-item-kit.
            
            /*GRUPO*/
            RUN pi-busca-grupo-kit.

            /* FAM÷LIA E DESCRICAO FAM÷LIA*/
            ASSIGN tt-calcula-aux.fm-cod-com = ITEM.fm-cod-com.
           
            FIND FIRST fam-com-item NO-LOCK
                 WHERE fam-com-item.fm-cod-com = tt-calcula-aux.fm-cod-com NO-ERROR.
            IF  AVAIL fam-com-item THEN
                ASSIGN tt-calcula-aux.c-desc-familia = fam-com-item.descricao.
            ELSE 
                ASSIGN tt-calcula-aux.c-desc-familia = tt-calcula-aux.fm-cod-com.

            /*Segmento e segmento substituido*/
            RUN pi-busca-segmento-kit.

        END.

        /*OMPONENTE*/
        /*ASSIGN tt-calcula-aux.it-codigo   = int-item-nota-fisc-kit.it-componente.*/
        
        ASSIGN l-houve-rateio = YES.

        ASSIGN tt-calcula-aux.rec-sem-ipi         = ROUND(((de-tot-rec-sem-ipi         * int-item-nota-fisc-kit.perc-fatur) / 100), 2)
               tt-calcula-aux.ipi                 = ROUND(((de-tot-ipi                 * int-item-nota-fisc-kit.perc-fatur) / 100), 2)     
               tt-calcula-aux.vl-icms-subs        = ROUND(((de-tot-vl-icms-subs        * int-item-nota-fisc-kit.perc-fatur) / 100), 2)
               tt-calcula-aux.vl-icms             = ROUND(((de-tot-vl-icms             * int-item-nota-fisc-kit.perc-fatur) / 100), 2)     
               tt-calcula-aux.vl-icms-cp          = ROUND(((de-tot-vl-icms-cp          * int-item-nota-fisc-kit.perc-fatur) / 100), 2)         
               tt-calcula-aux.vl-icms-cpi         = ROUND(((de-tot-vl-icms-cpi         * int-item-nota-fisc-kit.perc-fatur) / 100), 2)         
               tt-calcula-aux.vl-pis              = ROUND(((de-tot-vl-pis              * int-item-nota-fisc-kit.perc-fatur) / 100), 2)     
               tt-calcula-aux.vl-cofins           = ROUND(((de-tot-vl-cofins           * int-item-nota-fisc-kit.perc-fatur) / 100), 2)    
               tt-calcula-aux.vl-iss              = ROUND(((de-tot-vl-iss              * int-item-nota-fisc-kit.perc-fatur) / 100), 2)
               tt-calcula-aux.frete               = ROUND(((de-tot-frete               * int-item-nota-fisc-kit.perc-fatur) / 100), 2)
               tt-calcula-aux.comissao-distrato   = ROUND(((de-tot-comissao-distrato   * int-item-nota-fisc-kit.perc-fatur) / 100), 2)
               tt-calcula-aux.vl-acordo           = ROUND(((de-tot-vl-acordo           * int-item-nota-fisc-kit.perc-fatur) / 100), 2)
               tt-calcula-aux.vl-bicms-it         = ROUND(((de-tot-vl-bicms-it         * int-item-nota-fisc-kit.perc-fatur) / 100), 2)
               tt-calcula-aux.vl-CPRB             = ROUND(((de-tot-vl-CPRB             * int-item-nota-fisc-kit.perc-fatur) / 100), 2)

               tt-calcula-aux.de-vl-icms-fcp      = ROUND(((de-tot-de-vl-icms-fcp      * int-item-nota-fisc-kit.perc-fatur) / 100), 2)     
               tt-calcula-aux.de-vl-icms-uf-dest  = ROUND(((de-tot-de-vl-icms-uf-dest  * int-item-nota-fisc-kit.perc-fatur) / 100), 2)     
               tt-calcula-aux.de-vl-icms-uf-remet = ROUND(((de-tot-de-vl-icms-uf-remet * int-item-nota-fisc-kit.perc-fatur) / 100), 2)     

               tt-calcula-aux.custo-mat           = ROUND(((de-tot-custo-mat           * int-item-nota-fisc-kit.perc-custo) / 100), 2)
               tt-calcula-aux.custo-fixo-pro      = ROUND(((de-tot-custo-fixo-pro      * int-item-nota-fisc-kit.perc-custo) / 100), 2).
               

        ASSIGN de-dif-rec-sem-ipi         = de-dif-rec-sem-ipi         + tt-calcula-aux.rec-sem-ipi      
               de-dif-ipi                 = de-dif-ipi                 + tt-calcula-aux.ipi              
               de-dif-vl-icms-subs        = de-dif-vl-icms-subs        + tt-calcula-aux.vl-icms-subs     
               de-dif-vl-icms             = de-dif-vl-icms             + tt-calcula-aux.vl-icms          
               de-dif-vl-icms-cp          = de-dif-vl-icms-cp          + tt-calcula-aux.vl-icms-cp       
               de-dif-vl-icms-cpi         = de-dif-vl-icms-cpi         + tt-calcula-aux.vl-icms-cpi      
               de-dif-vl-pis              = de-dif-vl-pis              + tt-calcula-aux.vl-pis           
               de-dif-vl-cofins           = de-dif-vl-cofins           + tt-calcula-aux.vl-cofins        
               de-dif-vl-iss              = de-dif-vl-iss              + tt-calcula-aux.vl-iss           
               de-dif-frete               = de-dif-frete               + tt-calcula-aux.frete            
               de-dif-comissao-distrato   = de-dif-comissao-distrato   + tt-calcula-aux.comissao-distrato
               de-dif-vl-acordo           = de-dif-vl-acordo           + tt-calcula-aux.vl-acordo        
               de-dif-vl-bicms-it         = de-dif-vl-bicms-it         + tt-calcula-aux.vl-bicms-it
               de-dif-de-vl-icms-fcp      = de-dif-de-vl-icms-fcp      + tt-calcula-aux.de-vl-icms-fcp     
               de-dif-de-vl-icms-uf-dest  = de-dif-de-vl-icms-uf-dest  + tt-calcula-aux.de-vl-icms-uf-dest 
               de-dif-de-vl-icms-uf-remet = de-dif-de-vl-icms-uf-remet + tt-calcula-aux.de-vl-icms-uf-remet
               de-dif-custo-mat           = de-dif-custo-mat           + tt-calcula-aux.custo-mat      
               de-dif-custo-fixo-pro      = de-dif-custo-fixo-pro      + tt-calcula-aux.custo-fixo-pro
               de-dif-vl-CPRB             = de-dif-vl-CPRB             + tt-calcula-aux.vl-CPRB.

        IF  LAST(int-item-nota-fisc-kit.perc-fatur) THEN DO:
            /* ACERTO POSS÷VEIS DIFERENÄAS DE ARREDONDAMENTO */
            IF  de-dif-rec-sem-ipi         > de-tot-rec-sem-ipi         THEN ASSIGN tt-calcula-aux.rec-sem-ipi         = tt-calcula-aux.rec-sem-ipi         - (de-dif-rec-sem-ipi         - de-tot-rec-sem-ipi        ).
            IF  de-dif-vl-CPRB             > de-tot-vl-CPRB             THEN ASSIGN tt-calcula-aux.vl-CPRB             = tt-calcula-aux.vl-CPRB             - (de-dif-vl-CPRB             - de-tot-vl-CPRB            ).
            IF  de-dif-ipi                 > de-tot-ipi                 THEN ASSIGN tt-calcula-aux.ipi                 = tt-calcula-aux.ipi                 - (de-dif-ipi                 - de-tot-ipi                ).
            IF  de-dif-vl-icms-subs        > de-tot-vl-icms-subs        THEN ASSIGN tt-calcula-aux.vl-icms-subs        = tt-calcula-aux.vl-icms-subs        - (de-dif-vl-icms-subs        - de-tot-vl-icms-subs       ).
            IF  de-dif-vl-icms             > de-tot-vl-icms             THEN ASSIGN tt-calcula-aux.vl-icms             = tt-calcula-aux.vl-icms             - (de-dif-vl-icms             - de-tot-vl-icms            ).
            IF  de-dif-vl-icms-cp          > de-tot-vl-icms-cp          THEN ASSIGN tt-calcula-aux.vl-icms-cp          = tt-calcula-aux.vl-icms-cp          - (de-dif-vl-icms-cp          - de-tot-vl-icms-cp         ).
            IF  de-dif-vl-icms-cpi         > de-tot-vl-icms-cpi         THEN ASSIGN tt-calcula-aux.vl-icms-cpi         = tt-calcula-aux.vl-icms-cpi         - (de-dif-vl-icms-cpi         - de-tot-vl-icms-cpi        ).
            IF  de-dif-vl-pis              > de-tot-vl-pis              THEN ASSIGN tt-calcula-aux.vl-pis              = tt-calcula-aux.vl-pis              - (de-dif-vl-pis              - de-tot-vl-pis             ).
            IF  de-dif-vl-cofins           > de-tot-vl-cofins           THEN ASSIGN tt-calcula-aux.vl-cofins           = tt-calcula-aux.vl-cofins           - (de-dif-vl-cofins           - de-tot-vl-cofins          ).
            IF  de-dif-vl-iss              > de-tot-vl-iss              THEN ASSIGN tt-calcula-aux.vl-iss              = tt-calcula-aux.vl-iss              - (de-dif-vl-iss              - de-tot-vl-iss             ).
            IF  de-dif-frete               > de-tot-frete               THEN ASSIGN tt-calcula-aux.frete               = tt-calcula-aux.frete               - (de-dif-frete               - de-tot-frete              ).            
            IF  de-dif-comissao-distrato   > de-tot-comissao-distrato   THEN ASSIGN tt-calcula-aux.comissao-distrato   = tt-calcula-aux.comissao-distrato   - (de-dif-comissao-distrato   - de-tot-comissao-distrato  ).
            IF  de-dif-vl-acordo           > de-tot-vl-acordo           THEN ASSIGN tt-calcula-aux.vl-acordo           = tt-calcula-aux.vl-acordo           - (de-dif-vl-acordo           - de-tot-vl-acordo          ).
            IF  de-dif-vl-bicms-it         > de-tot-vl-bicms-it         THEN ASSIGN tt-calcula-aux.vl-bicms-it         = tt-calcula-aux.vl-bicms-it         - (de-dif-vl-bicms-it         - de-tot-vl-bicms-it        ).
            IF  de-dif-de-vl-icms-fcp      > de-tot-de-vl-icms-fcp      THEN ASSIGN tt-calcula-aux.de-vl-icms-fcp      = tt-calcula-aux.de-vl-icms-fcp      - (de-dif-de-vl-icms-fcp      - de-tot-de-vl-icms-fcp     ).
            IF  de-dif-de-vl-icms-uf-dest  > de-tot-de-vl-icms-uf-dest  THEN ASSIGN tt-calcula-aux.de-vl-icms-uf-dest  = tt-calcula-aux.de-vl-icms-uf-dest  - (de-dif-de-vl-icms-uf-dest  - de-tot-de-vl-icms-uf-dest ).
            IF  de-dif-de-vl-icms-uf-remet > de-tot-de-vl-icms-uf-remet THEN ASSIGN tt-calcula-aux.de-vl-icms-uf-remet = tt-calcula-aux.de-vl-icms-uf-remet - (de-dif-de-vl-icms-uf-remet - de-tot-de-vl-icms-uf-remet).
            IF  de-dif-custo-mat           > de-tot-custo-mat           THEN ASSIGN tt-calcula-aux.custo-mat           = tt-calcula-aux.custo-mat           - (de-dif-custo-mat           - de-tot-custo-mat          ).
            IF  de-dif-custo-fixo-pro      > de-tot-custo-fixo-pro      THEN ASSIGN tt-calcula-aux.custo-fixo-pro      = tt-calcula-aux.custo-fixo-pro      - (de-dif-custo-fixo-pro      - de-tot-custo-fixo-pro     ).
            
            IF  de-dif-rec-sem-ipi         < de-tot-rec-sem-ipi         THEN ASSIGN tt-calcula-aux.rec-sem-ipi         = tt-calcula-aux.rec-sem-ipi         + (de-tot-rec-sem-ipi       - de-dif-rec-sem-ipi      ).
            IF  de-dif-vl-CPRB             < de-tot-vl-CPRB             THEN ASSIGN tt-calcula-aux.vl-CPRB             = tt-calcula-aux.vl-CPRB             + (de-tot-vl-CPRB           - de-dif-vl-CPRB          ).
            IF  de-dif-ipi                 < de-tot-ipi                 THEN ASSIGN tt-calcula-aux.ipi                 = tt-calcula-aux.ipi                 + (de-tot-ipi               - de-dif-ipi              ).
            IF  de-dif-vl-icms-subs        < de-tot-vl-icms-subs        THEN ASSIGN tt-calcula-aux.vl-icms-subs        = tt-calcula-aux.vl-icms-subs        + (de-tot-vl-icms-subs      - de-dif-vl-icms-subs     ).
            IF  de-dif-vl-icms             < de-tot-vl-icms             THEN ASSIGN tt-calcula-aux.vl-icms             = tt-calcula-aux.vl-icms             + (de-tot-vl-icms           - de-dif-vl-icms          ).
            IF  de-dif-vl-icms-cp          < de-tot-vl-icms-cp          THEN ASSIGN tt-calcula-aux.vl-icms-cp          = tt-calcula-aux.vl-icms-cp          + (de-tot-vl-icms-cp        - de-dif-vl-icms-cp       ).
            IF  de-dif-vl-icms-cpi         < de-tot-vl-icms-cpi         THEN ASSIGN tt-calcula-aux.vl-icms-cpi         = tt-calcula-aux.vl-icms-cpi         + (de-tot-vl-icms-cpi       - de-dif-vl-icms-cpi      ).
            IF  de-dif-vl-pis              < de-tot-vl-pis              THEN ASSIGN tt-calcula-aux.vl-pis              = tt-calcula-aux.vl-pis              + (de-tot-vl-pis            - de-dif-vl-pis           ).
            IF  de-dif-vl-cofins           < de-tot-vl-cofins           THEN ASSIGN tt-calcula-aux.vl-cofins           = tt-calcula-aux.vl-cofins           + (de-tot-vl-cofins         - de-dif-vl-cofins        ).
            IF  de-dif-vl-iss              < de-tot-vl-iss              THEN ASSIGN tt-calcula-aux.vl-iss              = tt-calcula-aux.vl-iss              + (de-tot-vl-iss            - de-dif-vl-iss           ).
            IF  de-dif-frete               < de-tot-frete               THEN ASSIGN tt-calcula-aux.frete               = tt-calcula-aux.frete               + (de-tot-frete             - de-dif-frete            ).
            IF  de-dif-comissao-distrato   < de-tot-comissao-distrato   THEN ASSIGN tt-calcula-aux.comissao-distrato   = tt-calcula-aux.comissao-distrato   + (de-tot-comissao-distrato - de-dif-comissao-distrato).
            IF  de-dif-vl-acordo           < de-tot-vl-acordo           THEN ASSIGN tt-calcula-aux.vl-acordo           = tt-calcula-aux.vl-acordo           + (de-tot-vl-acordo         - de-dif-vl-acordo        ).
            IF  de-dif-vl-bicms-it         < de-tot-vl-bicms-it         THEN ASSIGN tt-calcula-aux.vl-bicms-it         = tt-calcula-aux.vl-bicms-it         + (de-tot-vl-bicms-it       - de-dif-vl-bicms-it      ).
            IF  de-dif-de-vl-icms-fcp      < de-tot-de-vl-icms-fcp      THEN ASSIGN tt-calcula-aux.de-vl-icms-fcp      = tt-calcula-aux.de-vl-icms-fcp      + (de-tot-de-vl-icms-fcp      - de-dif-de-vl-icms-fcp     ).
            IF  de-dif-de-vl-icms-uf-dest  < de-tot-de-vl-icms-uf-dest  THEN ASSIGN tt-calcula-aux.de-vl-icms-uf-dest  = tt-calcula-aux.de-vl-icms-uf-dest  + (de-tot-de-vl-icms-uf-dest  - de-dif-de-vl-icms-uf-dest ).
            IF  de-dif-de-vl-icms-uf-remet < de-tot-de-vl-icms-uf-remet THEN ASSIGN tt-calcula-aux.de-vl-icms-uf-remet = tt-calcula-aux.de-vl-icms-uf-remet + (de-tot-de-vl-icms-uf-remet - de-dif-de-vl-icms-uf-remet).
            IF  de-dif-custo-mat           < de-tot-custo-mat           THEN ASSIGN tt-calcula-aux.custo-mat         = tt-calcula-aux.custo-mat         + (de-tot-custo-mat         - de-dif-custo-mat        ).
            IF  de-dif-custo-fixo-pro      < de-tot-custo-fixo-pro      THEN ASSIGN tt-calcula-aux.custo-fixo-pro    = tt-calcula-aux.custo-fixo-pro    + (de-tot-custo-fixo-pro    - de-dif-custo-fixo-pro   ).
        END.

        
   END.

   /* Elimininar o registro pai */
   IF  l-houve-rateio THEN
       DELETE tt-calcula.

END.

/* COPIAR OS ITENS FILHOS QUE SUBSTITUIRAM A LISTAGEM DO ITEM PAI, DELETADO ANTERIORMENTE CONFORME CADASTRO ESFTP0121 */
FOR EACH tt-calcula-aux:
    CREATE tt-calcula.
    BUFFER-COPY tt-calcula-aux TO tt-calcula.
END.


for each tt-calcula use-index totais 
    break BY tt-calcula.ajustes
          by tt-calcula.unid-neg
          by tt-calcula.it-codigo
          BY tt-calcula.nr-nota-fis
          BY tt-calcula.serie
          BY tt-calcula.c-origem:
    run pi-acompanhar in h-acomp (input "Item.: " + tt-calcula.it-codigo).

    ASSIGN c-desc-unid = tt-calcula.descricao-un.

    for FIRST ponto-programa
        where ponto-programa.nome-programa = "esftp061"
          AND ponto-programa.ponto         = 1,
         EACH conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo   = tt-calcula.it-codigo
               AND ITEM.fm-cod-com  = ENTRY(1,conteudo-programa.conteudo,";") NO-ERROR.
        IF AVAIL ITEM THEN
            ASSIGN tt-calcula.desc-segmento     = ENTRY(2,conteudo-programa.conteudo,";")
                   tt-calcula.desc-segmento-ant = ENTRY(2,conteudo-programa.conteudo,";").
    end. 
    /*
    IF  tt-calcula.unid-neg = "SEC" OR tt-calcula.unid-neg = "ISEC" THEN
        ASSIGN c-desc-unid = "ISEC/SC".
    */


    PUT UNFORMATTED
        "Realizado"                              ";"
        da-ult-dia-mes                           ";"
        tt-calcula.cod-estabel                   ";"
        ENTRY(tt-calcula.tipo,"FAT,DEV,AJU",",") ";"
        tt-calcula.c-desc-grupo                  ";"
        c-desc-unid                              ";".

    IF tt-calcula.atendente = "50" THEN
        PUT UNFORMATTED "externo;".
    ELSE 
        PUT UNFORMATTED tt-calcula.c-mercado  ";".

    PUT UNFORMATTED    
        tt-calcula.c-origem                  ";"
        tt-calcula.nome-abrev                ";"
        tt-calcula.nome-matriz               ";"
        tt-calcula.cgc                       ";"
        tt-calcula.cod-emitente              ";"
        tt-calcula.cod-gr-cli                ";"
        tt-calcula.atendente                 ";"
        tt-calcula.fm-cod-com                ";"
        tt-calcula.c-desc-familia            ";"
        tt-calcula.nome-repres               ";"
        tt-calcula.estado                    ";"
        tt-calcula.pais                      ";".

    PUT UNFORMATTED
        (IF tt-calcula.it-codigo-kit      <> "" THEN tt-calcula.it-codigo-kit      ELSE tt-calcula.it-codigo) ";"
        (IF tt-calcula.it-codigo-kit-desc <> "" THEN tt-calcula.it-codigo-kit-desc ELSE tt-calcula.descricao) ";".

    ASSIGN c-unid-nota      = tt-calcula.unid-neg-nota    
           c-desc-unid-nota = tt-calcula.descricao-un-nota.

    /*
    IF c-unid-nota = "SEC" OR c-unid-nota = "ISEC" THEN
        ASSIGN c-unid-nota      = "ISEC/SC"   
               c-desc-unid-nota = "ISEC/SC".
    */
    IF tt-calcula.tipo = 1 THEN DO:
        PUT tt-calcula.qtd                        format "->>>>>>9.99"   ";" /*Quantidade*/
            tt-calcula.rec-sem-ipi                format "->>>>,>>9.99" ";" /*Receita Liquida*/
            tt-calcula.ipi * -1                   format "->>>>,>>9.99" ";" /*IPI Devoluªío*/          
            tt-calcula.vl-icms-subs * -1          format "->>>>,>>9.99" ";"
            tt-calcula.vl-icms * -1               format "->>>>,>>9.99" ";"
            tt-calcula.vl-icms-cp                 format "->>>>,>>9.99" ";"
            tt-calcula.vl-icms-cpi                format "->>>>,>>9.99" ";"
            tt-calcula.vl-pis * -1                format "->>>>,>>9.99" ";"
            tt-calcula.vl-cofins * -1             format "->>>>,>>9.99" ";".

        FIND INT-CLASSIF-FISC
             WHERE INT-CLASSIF-FISC.class-fiscal = tt-calcula.ncm
             NO-LOCK NO-ERROR.
        IF  AVAIL int-classif-fisc AND int-classif-fisc.inss-faturamento = YES THEN DO:
            IF  tt-calcula.vl-CPRB > 0 THEN
                PUT tt-calcula.vl-CPRB  format "->>>>,>>9.99" ";".
            else
                PUT tt-calcula.rec-sem-ip * 1 / 100    format "->>>>,>>9.99" ";".
        END.
        ELSE
            PUT ";".

        PUT tt-calcula.vl-iss * -1                format "->>>>,>>9.99" ";"
            tt-calcula.frete * -1                 format "->>>>,>>9.99" ";"
            tt-calcula.comissao-distrato * -1     format "->>>>,>>9.99" ";"
        
            tt-calcula.vl-acordo     * -1         format "->>>>,>>9.99" ";"
            
            tt-calcula.custo-mat     * -1         format "->>>>,>>9.99" ";"
            tt-calcula.custo-fixo-pro * -1        format "->>>>,>>9.99" ";"
            "0;0;0;"
            tt-calcula.vpc            * -1        format "->>>>,>>9.99" ";"
            "0;0;0;0;0;0;0;0;".

        IF tt-param.l-imp-nota THEN 
            PUT UNFORMATTED 
                tt-calcula.nr-nota-fis  FORMAT "X(20)"      ";"
                tt-calcula.serie                            ";"
                tt-calcula.nr-seq-fat                       ";"
                tt-calcula.dt-emis-nota FORMAT "99/99/9999" ";".

        PUT  tt-calcula.ncm ";".
        

        PUT UNFORMATTED (IF tt-calcula.desc-segmento-kit <> "" THEN tt-calcula.desc-segmento-kit ELSE tt-calcula.desc-segmento).

        PUT UNFORMAT ";"
            tt-calcula.fm-codigo ";"
            tt-calcula.codigo-orig ";"
            tt-calcula.consum-final ";"
            tt-calcula.vl-bicms-it ";"
            tt-calcula.nat-operacao ";"
            c-unid-nota      ";"
            c-desc-unid-nota     ";".
    END.
    ELSE DO:
        PUT tt-calcula.qtd           * -1     format "->>>>>>9.99"   ";" /*Quantidade*/
            tt-calcula.rec-sem-ipi   * -1     format "->>>>,>>9.99" ";" /*Receita Liquida*/
            tt-calcula.ipi                    format "->>>>,>>9.99" ";" /*IPI Devoluªío*/          
            tt-calcula.vl-icms-subs           format "->>>>,>>9.99" ";"
            tt-calcula.vl-icms                format "->>>>,>>9.99" ";"
            tt-calcula.vl-icms-cp    * -1     format "->>>>,>>9.99" ";"
            tt-calcula.vl-icms-cpi   * -1     format "->>>>,>>9.99" ";"
            tt-calcula.vl-pis                 format "->>>>,>>9.99" ";"
            tt-calcula.vl-cofins              format "->>>>,>>9.99" ";".

        FIND INT-CLASSIF-FISC
             WHERE INT-CLASSIF-FISC.class-fiscal = tt-calcula.ncm
             NO-LOCK NO-ERROR.
        IF  AVAIL int-classif-fisc AND int-classif-fisc.inss-faturamento = YES THEN DO:
             IF  tt-calcula.vl-CPRB > 0 THEN
                 PUT tt-calcula.vl-CPRB format "->>>>,>>9.99" ";".   
             ELSE
                 PUT tt-calcula.rec-sem-ip * 1 / 100 format "->>>>,>>9.99" ";".
        END.
        ELSE
            PUT ";".

        PUT tt-calcula.vl-iss                 format "->>>>,>>9.99" ";"
            tt-calcula.frete                  format "->>>>,>>9.99" ";"
            tt-calcula.comissao-distrato      format "->>>>,>>9.99" ";"

            tt-calcula.vl-acordo              format "->>>>,>>9.99" ";"

            tt-calcula.custo-mat              format "->>>>,>>9.99" ";"
            tt-calcula.custo-fixo-pro         format "->>>>,>>9.99" ";"
            "0;0;0;"
            tt-calcula.vpc                    format "->>>>,>>9.99" ";"
            "0;0;0;0;0;0;0;0;".

        IF tt-param.l-imp-nota THEN 
            PUT UNFORMATTED 
                tt-calcula.nr-nota-fis  FORMAT "X(20)"      ";"
                tt-calcula.serie                            ";"
                tt-calcula.nr-seq-fat                       ";"
                tt-calcula.dt-emis-nota FORMAT "99/99/9999" ";".

        PUT tt-calcula.ncm ";".

/*         IF  tt-calcula.cod-segmento <> "T.MêXICO" THEN DO:                */
/*             FIND fam-com-item                                             */
/*                  WHERE fam-com-item.fm-cod-com = tt-calcula.cod-segmento  */
/*                  NO-LOCK NO-ERROR.                                        */
/*                                                                           */
/*             IF AVAIL fam-com-item THEN                                    */
/*                 PUT fam-com-item.descricao.                               */
/*             ELSE                                                          */
/*                 PUT "".                                                   */
/*         END.                                                              */
/*         ELSE                                                              */
        PUT UNFORMATTED (IF tt-calcula.desc-segmento-kit <> "" THEN tt-calcula.desc-segmento-kit ELSE tt-calcula.desc-segmento).


        PUT ";"
            tt-calcula.fm-codigo ";"
            tt-calcula.codigo-orig ";"
            tt-calcula.consum-final ";"
            tt-calcula.vl-bicms-it ";"
            tt-calcula.nat-operacao ";"
            c-unid-nota      ";"
            c-desc-unid-nota     ";".

    END.

    ASSIGN c-descricaoCat = ''.
    FIND FIRST categoria-fmcom
        WHERE categoria-fmcom.fm-cod-com = tt-calcula.fm-cod-com NO-LOCK NO-ERROR.
    IF AVAIL categoria-fmcom THEN DO:

        FIND FIRST categoria-produto
            WHERE categoria-produto.cod-categoria = categoria-fmcom.cod-categoria NO-LOCK NO-ERROR.
        IF AVAIL categoria-produto THEN DO:

            ASSIGN c-descricaoCat = TRIM(categoria-produto.desc-categoria).
            PUT categoria-fmcom.cod-categoria ";"
                c-descricaoCat                ";".

        END. /* IF AVAIL categoria-produto THEN DO: */
        ELSE 
            PUT ";;".

    END. /* IF AVAIL categoria-fmcom THEN DO: */
    ELSE 
        PUT ";;".

    FIND FIRST emitente WHERE emitente.cod-emitente = tt-calcula.cod-emitente NO-LOCK NO-ERROR.

    FIND FIRST ped-venda 
        WHERE ped-venda.nome-abrev = tt-calcula.nome-abrev
          AND ped-venda.nr-pedcli  = tt-calcula.nr-pedcli  NO-LOCK NO-ERROR.
    ASSIGN c-desc-grupo-canais = "".
    IF AVAIL ped-venda THEN DO:
        FIND FIRST int-ped-venda2
            WHERE int-ped-venda2.cod-estabel = ped-venda.cod-estabel
              AND int-ped-venda2.nr-pedido   = ped-venda.nr-pedido  NO-LOCK NO-ERROR.
        IF AVAIL int-ped-venda2 AND int-ped-venda2.int-1 <> 0 THEN DO:
            FIND FIRST grupo-canais WHERE grupo-canais.cod-gr-canais = int-ped-venda2.int-1 NO-LOCK NO-ERROR.
            IF  AVAIL grupo-canais THEN
                ASSIGN c-desc-grupo-canais = grupo-canais.descricao.
        END.
        ELSE DO:
            FIND FIRST grupo-canais-clientes
                WHERE grupo-canais-clientes.cod-gr-cli = tt-calcula.cod-gr-cli NO-LOCK NO-ERROR.
            IF AVAIL grupo-canais-clientes THEN DO:
                FIND FIRST grupo-canais WHERE grupo-canais.cod-gr-canais = grupo-canais-clientes.cod-gr-canais NO-LOCK NO-ERROR.
                IF  AVAIL grupo-canais THEN
                    ASSIGN c-desc-grupo-canais = grupo-canais.descricao.
            END. /* IF AVAIL grupo-canais-clientes THEN DO: */
        END.
    END. /* IF AVAIL ped-venda THEN DO: */
    ELSE DO:
        FIND FIRST grupo-canais-clientes
            WHERE grupo-canais-clientes.cod-gr-cli = tt-calcula.cod-gr-cli NO-LOCK NO-ERROR.
        IF AVAIL grupo-canais-clientes THEN DO:
            FIND FIRST grupo-canais WHERE grupo-canais.cod-gr-canais = grupo-canais-clientes.cod-gr-canais NO-LOCK NO-ERROR.
            IF  AVAIL grupo-canais THEN
                ASSIGN c-desc-grupo-canais = grupo-canais.descricao.
        END. /* IF AVAIL grupo-canais-clientes THEN DO: */
    END.

    FIND FIRST b-ITEM NO-LOCK
         WHERE b-ITEM.it-codigo = tt-calcula.it-codigo NO-ERROR.

    PUT UNFORMATTED c-desc-grupo-canais   ";"
         tt-calcula.cod-estab-substituido ";"
         /*(IF tt-calcula.unid-neg-substituida = "SEC" OR tt-calcula.unid-neg-substituida = "ISEC" THEN "ISEC/SC" ELSE*/ (IF tt-calcula.desc-unidade-kit-ant <> "" THEN tt-calcula.desc-unidade-kit-ant ELSE tt-calcula.unid-neg-substituida) ";"
         (IF tt-calcula.desc-segmento-kit-ant <> "" THEN tt-calcula.desc-segmento-kit-ant ELSE tt-calcula.desc-segmento-ant)  ";"
         tt-calcula.de-vl-icms-fcp     ";" 
         tt-calcula.de-vl-icms-uf-dest ";"
         tt-calcula.de-vl-icms-uf-remet ";" 
         tt-calcula.it-codigo ";"
         b-ITEM.peso-bruto  ";"
         b-ITEM.peso-liquido ";" 
         tt-calcula.cod-transp ";"
         tt-calcula.nome-transp ";"
         tt-calcula.dt-prev-entrega ";"
         tt-calcula.dt-entrega ";"
         tt-calcula.cidade  SKIP.
    


end. 

run pi-finalizar in h-acomp.

RETURN "OK".

procedure pi-totaliza.

    ASSIGN de-vl-tot-cliente = 0.

    for each tt-calcula,
        FIRST ITEM fields(ITEM.ge-codigo ITEM.it-codigo) NO-LOCK
              WHERE ITEM.it-codigo = tt-calcula.it-codigo:

            /***** ACRESCIMO DE 1/12 SOBRE COMISSAO REFERENTE RESCISAO ******/
            
        assign tt-calcula.comissao-distrato = tt-calcula.comissao + (tt-calcula.comissao * 0.0833333).

        IF tt-calcula.tipo = 1 AND 
           (tt-calcula.vl-icms-cp <> 0 OR tt-calcula.vl-icms-cpi <> 0) THEN
           ASSIGN tt-calcula.vl-icms-est = ((tt-calcula.vl-icms-cp + tt-calcula.vl-icms-cpi) /
                                           de-vl-tot-cp) * tt-param.vl-icms-est.
            
        IF tt-calcula.vl-icms-est = ? THEN
            ASSIGN tt-calcula.vl-icms-est = 0.

        assign tt-calcula.rol              = tt-calcula.rec-sem-ipi 
                                             - tt-calcula.vl-icms 
                                             + tt-calcula.vl-icms-cp
                                             + tt-calcula.vl-icms-cpi
                                             + tt-calcula.vl-icms-est
                                             - tt-calcula.vl-pis
                                             - tt-calcula.vl-cofins
                                             - tt-calcula.vl-iss
                                             - tt-calcula.vl-fidelidade
                                               
               tt-calcula.custo-mat         = (if l-utiliza-cif = yes then
                                                  de-custo-mat
                                               else
                                                  tt-calcula.custo-mat)
               tt-calcula.lucro-bruto       = tt-calcula.rol
                                              - tt-calcula.frete
                                              - tt-calcula.comissao
                                              /*- tt-calcula.vpc*/
                                              - tt-calcula.vl-prot-preco
                                              - tt-calcula.vl-acordo
               tt-calcula.margem-contribuicao = tt-calcula.lucro-bruto
                                                - tt-calcula.custo-fixo-prod   /* MOB + GGF */
                                                - tt-calcula.custo-mat
               tt-calcula.lucro-operacional = tt-calcula.margem-contribuicao
                                               - tt-calcula.desp-adm
                                               - tt-calcula.desp-com
                                               - tt-calcula.p&d
               tt-calcula.preco-medio       = (tt-calcula.rec-sem-ipi
                                               - tt-calcula.vl-acordo)
                                               / tt-calcula.qtd.
                                                 
       ASSIGN tt-calcula.perc-lucro-rol = round((tt-calcula.lucro-operacional / tt-calcula.rol), 5).
    END.
END.

PROCEDURE pi-busca-unidade-neg-item-kit:

    ASSIGN tt-calcula-aux.descricao-un     = "Material de Consumo".

    FIND FIRST unid_negoc NO-LOCK
        WHERE unid_negoc.cod_unid_negoc = ITEM.cod-unid-negoc NO-ERROR.

    IF  AVAIL unid_negoc THEN
        ASSIGN tt-calcula-aux.descricao-un = unid_negoc.des_unid_negoc.
    
    for first ponto-programa
         where ponto-programa.nome-programa = "boes513"
           AND ponto-programa.ponto         = 1,
          EACH conteudo-programa NO-LOCK
         WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
           AND conteudo-programa.sequencia    = int(SUBSTRING(ITEM.fm-cod-com,1,2)):

        FIND FIRST unid_negoc NO-LOCK
             WHERE unid_negoc.cdn_unid_negoc = INT(conteudo-programa.conteudo) NO-ERROR.
        IF AVAIL unid_negoc THEN
            ASSIGN tt-calcula-aux.descricao-un = unid_negoc.des_unid_negoc.
        ELSE
            ASSIGN tt-calcula-aux.descricao-un = "Material de Consumo".                       

    end. 

    ASSIGN tt-calcula-aux.desc-unidade-kit-ant =  tt-calcula-aux.descricao-un.

    FIND FIRST nota-fiscal NO-LOCK
        WHERE nota-fiscal.cod-estabel = tt-calcula-aux.cod-estab-substituido      
          AND nota-fiscal.serie       = tt-calcula-aux.serie                      
          AND nota-fiscal.nr-nota-fis = tt-calcula-aux.nr-nota-fis NO-ERROR.
     IF  AVAIL nota-fiscal THEN DO:
         FIND FIRST ped-venda NO-LOCK
             WHERE ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli
               AND ped-venda.nome-abrev = nota-fiscal.nome-ab-cli NO-ERROR.

         IF  AVAIL ped-venda AND ped-venda.tp-pedido = "70" 
         OR  NOT AVAIL ped-venda AND nota-fiscal.estado = "ex" THEN
             ASSIGN tt-calcula-aux.descricao-un = "EXPO".

     END.


END.

PROCEDURE pi-busca-grupo-kit:
      FIND FIRST fam-com-item NO-LOCK
           WHERE fam-com-item.fm-cod-com = SUBSTRING(ITEM.fm-cod-com,1,7) NO-ERROR.
      IF AVAIL fam-com-item THEN
          ASSIGN tt-calcula-aux.c-desc-grupo = fam-com-item.descricao.
      ELSE
          ASSIGN tt-calcula-aux.c-desc-grupo = tt-calcula.cd-gr-com.
END.

PROCEDURE pi-busca-segmento-kit:
    DEF VAR c-descricao-segmento AS CHAR NO-UNDO.
    DEF VAR c-descricao-segmento-ant AS CHAR NO-UNDO.

    ASSIGN c-descricao-segmento     = fn-retorna-descricao-segmento(item.fm-cod-com).
           c-descricao-segmento-ant = c-descricao-segmento.

    IF  emitente.cod-emitente = 105068 then
        ASSIGN c-descricao-segmento = "T.MêXICO".
    ELSE
        IF tt-calcula-aux.descricao-un = "EXPO" THEN
            ASSIGN c-descricao-segmento = "Outros Pa°ses".

    ASSIGN tt-calcula-aux.desc-segmento-kit     = c-descricao-segmento
           tt-calcula-aux.desc-segmento-kit-ant = c-descricao-segmento-ant.

END.

function fn-retorna-descricao-segmento returns character
  ( p-fm-cod-com as character ) :
    
    find first b-fm-cod-com-aux
        where b-fm-cod-com-aux.fm-cod-com = substring(p-fm-cod-com, 1, 4) no-lock no-error.

   if available b-fm-cod-com-aux then
       return b-fm-cod-com-aux.descricao.
   else
       "".
end function.
