
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i escdp060RP 2.00.00.015 } /*** 010015 ***/ 

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i escdp060rp MCD}
&ENDIF

{include/i_fnctrad.i}


/******************************************************************************
**  Programa: escdp060RP.P
**  Data....: 20/01/2000
**  Autor...: DATASUL S.A.
**  Objetivo: Listagem de Itens
******************************************************************************/
{utp/ut-glob.i}
{cdp/cdcfgdis.i}
{include/tt-edit.i} /* para impress∆o da narrativa do item */

/* Transfer Definitions */
DEFINE TEMP-TABLE tt-digita
    FIELD it-codigo LIKE item.it-codigo
    FIELD desc-item LIKE item.desc-item
    INDEX item it-codigo.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char    format "x(40)"
    field usuario          as char    format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field c-item-ini       as char    format "x(16)"
    field c-item-fim       as char    format "x(16)"
    field c-gr-estoq-ini   as integer format ">9"
    field c-gr-estoq-fim   as integer format ">9"
    field c-fam-mat-ini    as char    format "x(8)"
    field c-fam-mat-fim    as char    format "x(8)"
    field c-fam-coml-ini   as char    format "x(8)"
    field c-fam-coml-fim   as char    format "x(8)"
    field l-tipo           as logical format "Sim/N∆o"
    field rs-lista         as integer
    field l-narrativa      as logical format "Sim/N∆o"
    FIELD c-ncm-ini        AS CHAR    
    FIELD c-ncm-fim        AS CHAR    FORMAT 9999.99.99.

/* Transfer Definitions */

DEF TEMP-TABLE tt-fat-estab-item
    FIELD cod-estabel AS CHAR
    FIELD log-fat     AS LOG FORMAT 'SIM/N«O'
    FIELD origem      AS CHAR
    INDEX idx cod-estabel.

def temp-table tt-raw-digita
   field raw-digita      as raw.

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

/* include padr∆o para vari†veis de relat¢rio */
{include/i-rpvar.i}

/* vari†veis da tela de parÉmetros */
DEFINE VARIABLE c-mensagem      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-opcao AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-esmsspapi001 AS HANDLE      NO-UNDO.
DEFINE VARIABLE i-cest AS INTEGER   COLUMN-LABEL "CEST"  FORMAT "99,999,99" NO-UNDO .
DEFINE VARIABLE l-nem-dun-nem-embalag AS LOG INIT NO NO-UNDO.

def var h-programa    as handle                     no-undo.
def var c-selecao     as char format "x(10)"        no-undo.
def var c-param       as char format "x(14)"        no-undo.
def var c-lista       as char format "x(20)"        no-undo.
def var c-class       as char format "x(14)"        no-undo.
def var c-classifica  as char format "x(20)"        no-undo.
def var c-imp         as char format "x(12)"        no-undo.
def var c-destino     as char format "x(15)"        no-undo.
DEF VAR c-ind-inf-qtf AS CHAR FORMAT "x(25)"        NO-UNDO.
def var c-destino-impressao as char format "x(15)"  NO-UNDO.

DEFINE VARIABLE v-cd-trib-ipi AS CHARACTER FORMAT "x(15)"   NO-UNDO.


/* vari†veis do cabeáalho itens - resumido ************************************/

def var c-item            as char    format "x(05)"  no-undo.
def var c-desc            as char    format "x(10)"  no-undo.
def var c-dep-pad         as char    format "x(03)"  no-undo.
def var c-curva           as char    format "x(03)"  no-undo.
def var c-class-fiscal    as char    format "x(10)"  no-undo.
DEF VAR c-cd-trib-ipi     AS CHAR    FORMAT "x(10)"  NO-UNDO.
DEF VAR c-aliquota-ipi    AS CHAR    FORMAT "x(03)"  NO-UNDO.
def var c-peso            as char    format "x(13)"  no-undo.
def var c-un              as char    format "x(02)"  no-undo.
def var c-ft-conversao    as char    format "x(10)"  no-undo.
def var c-dec-ftcon       as char    format "x(01)"  no-undo.
def var c-fm-codigo       as char    format "x(08)"  no-undo.
def var c-fm-cod-com      as char    format "x(08)"  no-undo.
def var c-ge-codigo       as char    format "x(03)"  no-undo.
def var c-desc-tax        as char    format "x(20)"  no-undo.
def var c-cd-origem       as char    format "x(03)"  no-undo.
def var c-ind-item-fat    as char    format "x(20)"  no-undo.
def var c-fat-estabel-101 as char    format "x(3)"  no-undo.
def var c-fat-estabel-103 as char    format "x(3)"  no-undo.
def var c-fat-estabel-104 as char    format "x(3)"  no-undo.
def var c-fat-estabel-105 as char    format "x(3)"  no-undo.
DEF VAR c-fat-estabel-106 AS CHAR    FORMAT "x(3)"  NO-UNDO.
DEF VAR c-fat-estabel-107 AS CHAR    FORMAT "x(3)"  NO-UNDO.
DEF VAR c-cest            AS CHAR                   NO-UNDO.

def var c-cod-imposto  as char    format "x(7)"  no-undo.
def var c-perc-taxa    as char    format "x(5)"  no-undo.
def var de-tax-perc  like tipo-tax.tax-perc        no-undo.

DEFINE VARIABLE c-ean          AS CHARACTER FORMAT "X(13)" NO-UNDO.
DEFINE VARIABLE c-fam-comerc   AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VARIABLE c-familia-desc AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VARIABLE c-gp-desc      AS CHARACTER FORMAT "X(40)" NO-UNDO.
/* vari†veis dos campos que n∆o s∆o fill-in */

/* def var c-cd-trib-ipi      as char    format "x(10)"  no-undo. */
def var c-trib-icms        AS CHAR                    NO-UNDO.
def var c-cd-trib-icm      as char    format "x(10)"  no-undo.
def var c-cd-trib-iss      as char    format "x(10)"  no-undo.
def var c-tipo-contr       as char    format "x(10)"  no-undo.
def var c-tipo-con-est     as char    format "x(10)"  no-undo.
def var c-ind-imp-desc     as char    format "x(20)"  no-undo.
def var de-aliq-pis        as dec     format ">9.99"  no-undo.
def var de-aliq-cofins     as dec     format ">9.99"  no-undo.
def var de-red-pis         as dec     format ">9.99"  no-undo.
def var de-red-cofins      as dec     format ">9.99"  no-undo.
def var c-op-susp-ipi      as char    format "x(10)"  no-undo.
def var c-orig-aliq-pis    as char    format "x(15)"  no-undo.
def var c-orig-aliq-cofins as char    format "x(15)"  no-undo.
DEF VAR c-tp-apur-ipi      AS CHAR    FORMAT "x(10)"  NO-UNDO.
DEF VAR c-familia-ipi      AS CHAR    FORMAT "x(08)"  NO-UNDO.
def var c-cod-sefazsp      as INT     format ">>>9"   no-undo.
def var c-cod-ean          as char    format "x(14)"  no-undo.
def var c-combust          as char    format "x(03)"  no-undo.
def var c-nr-dcr-item      as char    format "x(12)" LABEL "N£mero Item DCR"  no-undo.
DEFINE VARIABLE c-cod-obsoleto AS CHARACTER  FORMAT "x(20)" NO-UNDO.
DEFINE VAR c-fat-tribut    AS CHAR NO-UNDO.
DEFINE VAR c-orig-unid-tribut AS CHAR NO-UNDO FORMAT "x(30)".
DEFINE VAR c-unid-trbut       AS CHAR NO-UNDO.

DEFINE VARIABLE c-fat-estab    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE log-fat-estab  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE c-origem-estab AS CHARACTER  NO-UNDO.
DEFINE VARIABLE origem-estab   AS CHARACTER  NO-UNDO.


/* vari†veis das descriá‰es dos folders */

def var c-geral            as char format "x(20)"   no-undo.
def var c-complementar     as char format "x(30)"   no-undo.
def var c-fiscal           as char format "x(20)"   no-undo.
def var c-narrativa        as char format "x(10)"   no-undo.
DEF VAR i-cont             AS INT                   NO-UNDO.
DEF VAR i-tam-fam-mat      AS INT                   NO-UNDO.
DEF VAR c-aux-orig         AS CHAR                  NO-UNDO.
DEF VAR c-aux-fam-mat      AS CHAR                  NO-UNDO.

DEFINE BUFFER b-item-caixa FOR item-caixa.
DEFINE VAR d-it-caixa AS DEC NO-UNDO.

DEF TEMP-TABLE tt-aux
    FIELD it-codigo LIKE ITEM.it-codigo
    FIELD sigla-emb LIKE embalag.sigla-emb
    FIELD altura    LIKE embalag.altura  
    FIELD largura   LIKE embalag.largura 
    FIELD Comprim   LIKE embalag.Comprim 
    FIELD cod-dun   LIKE item-dun.cod-dun
    FIELD qtd-emb   LIKE item-dun.qtd-emb
         INDEX i it-codigo .

/* definiá∆o das frames dos relat¢rios */

form header
    skip(1)
        "I"                
    ";" "I"                
    ";" "P"                
    ";" "C"                
    ";" c-item             
    ";" c-desc             
    ";" c-dep-pad          
    ";" c-curva            
    ";" c-class-fiscal     
    ";" c-aliquota-ipi     
    ";" "Tribut IPI"                
    ";" "M"                
    ";" c-peso             
    ";" c-un               
    ";" c-ft-conversao     
    ";" c-dec-ftcon        
    ";" c-fm-codigo        
    ";" c-fm-cod-com       
    ";" c-ge-codigo        
    ";" "Orig" 
    ";" "Ft conv unid tribut"
    ";" "Orig Unid Trib"
    ";" "Unid Tribut"
    SKIP
    ";" "----------------" 
    ";" "--------------------------------------" 
    ";" "---"              
    ";" "---"              
    ";" "------------"     
    ";" "------"           
    ";" "-"                
    ";" "-"                
    ";" "-------------"    
    ";" "--"               
    ";" "----------"       
    ";" "-"                
    ";" "--------"         
    ";" "--------"         
    ";" "--"               
    ";" "--"      
    SKIP
    with stream-io no-label no-box width 550 /*page-top*/ frame f-cab-resumido.        

/*/
form header
        "I"                                                 
        "P"                                                 
        c-item                                              
    ";" c-desc                                              
    ";" c-dep-pad                                           
    ";" c-curva                                             
    ";" c-class-fiscal                                      
    ";" "% IPI"                                             
    ";" "I"                                                 
    ";" "Peso Bruto"
    ";" c-peso                                              
    ";" c-un                                                
    ";" c-ft-conversao                                      
    ";" c-dec-ftcon                                         
    ";" c-fm-codigo                                         
    ";" c-fm-cod-com                                        
    ";" c-ge-codigo                                         
    ";" "Orig"                                              
    ";" "Fat 101"                                           
    ";" "Fat 103"                                           
    ";" "Fat 104"                                           
    ";" "Fat 105"                                           
    ";" "Fat 106"                                           
    ";" "Fat 107"                                           
    ";" "Altura"
    ";" "Largura"
    ";" "Comprimento"
    ";" "EAN"
    ";" "Fat."                                              
    ";" "Uni.Neg"                                             
    ";" "Implant."    
    ";" "Servico"
    ";" "Aliq.ISS"
    ";" "Status"
    ";" "CEST"
    ";" "Sigla"
    ";" "Altura"
    ";" "Largura"
    ";" "Comprimento"
    ";" "DUN14"
    ";" "QTD"
    SKIP
    with stream-io no-label no-box width 620 /*page-top*/ frame f-cab-resumido-arg.
*/
form header
        "" 
    with stream-io no-label no-box width 620 /*page-top*/ frame f-cab-resumido-arg.

form 
   skip(1)
   item.fm-codigo    
   " - "   
   c-familia-desc no-label skip(1)
   with down width 132 side-labels no-box stream-io frame f-familia.

form 
   skip(1)
   item.ge-codigo         
   " - "                  
   c-gp-desc no-label skip(1)
   with down width 132 side-labels no-box stream-io frame f-estoque.

form 
   skip(1)
   item.fm-cod-com        
   " - "                  
   c-fam-comerc no-label skip(1)
   with down width 132 side-labels no-box stream-io frame f-familia-coml.

form
       item.it-codigo      
   ";" item.desc-item      
   ";" item.deposito-pad   
   ";" item.curva-abc      
   ";" item.class-fiscal 
   ";" item.aliquota-ipi   
   ";" c-cd-trib-ipi       
   ";" c-cd-trib-icm       
   ";" item.peso-liquido   
   ";" item.un             
   ";" item.ft-conversao   
   ";" item.dec-ftcon      
   ";" item.fm-codigo      
   ";" ITEM.fm-cod-com     
   ";" item.ge-codigo      
    SKIP
   with stream-io no-box no-labels width 170 down frame f-item-resumido.

form
       item.it-codigo      
   ";" item.desc-item      
   ";" item.deposito-pad   
   ";" item.curva-abc      
   ";" item.class-fiscal  
   ";" item.aliquota-ipi   
   ";" v-cd-trib-ipi       
   ";" ITEM.peso-bruto     
   ";" item.peso-liquido    
   ";" item.un             
   ";" item.ft-conversao   
   ";" item.dec-ftcon      
   ";" item.fm-codigo      
   ";" ITEM.fm-cod-com     
   ";" item.ge-codigo      
   ";" item.codigo-orig    
   ";" c-fat-estabel-101   
   ";" c-fat-estabel-103   
   ";" c-fat-estabel-104   
   ";" c-fat-estabel-105   
   ";" c-fat-estabel-106   
   ";" c-fat-estabel-107   
   ";" ITEM.altura         
   ";" ITEM.largura        
   ";" ITEM.comprim
   ";" c-ean               
   ";" ITEM.ind-item-fat   
   ";" item.cod-unid-neg   
   ";" item.data-implant   
   ";" ITEM.cod-servico    
   ";" ITEM.aliquota-iss   
   ";" c-cod-obsoleto      
   ";" i-cest
   ";" tt-aux.sigla-emb
   ";" tt-aux.altura 
   ";" tt-aux.largura
   ";" tt-aux.Comprim
   ";" tt-aux.cod-dun
   ";" tt-aux.qtd-emb
   ";" c-trib-icms
   ";" c-fat-tribut
   ";" c-orig-unid-tribut
   ";" c-unid-trbut

    SKIP
    with stream-io no-box no-labels width 630 down frame f-item-resumido-arg.

form
      skip(1)
      item.it-codigo      colon 32
      "-"                 space (1)
      item.desc-item      no-label skip(1)
      c-geral             no-label colon 32 skip(1)
      item.un             colon 32
      item.fm-codigo      colon 95  skip
      familia.un          colon 32
      item.ge-codigo      colon 95  skip
      item.fm-cod-com     colon 32
      c-ind-imp-desc      colon 95  skip
      item.fator-conver   colon 32
      item.ft-conversao   colon 95
      item.dec-ftcon      no-labels skip
      item.lote-mulven    colon 32
      item.fraciona       colon 95  skip
      item.ind-especifico colon 32  
      item.curva-abc      colon 95  skip(1)
      c-complementar      no-label colon 32 skip(1)
      item.peso-bruto     colon 32
      item.peso-liquido   colon 95  skip
      item.deposito-pad   colon 32
      item.cod-localiz    colon 95  skip
      item.codigo-orig    colon 32
      item.altura         colon 95  skip
      item.largura        colon 32
      item.comprim        colon 95  skip
      item.ind-item-fat   colon 32
      c-ind-inf-qtf       colon 95  skip
      item.baixa-estoq    colon 32 
      item.loc-unica      colon 95  skip
      c-tipo-contr        colon 32
      c-tipo-con-est      colon 95  skip
      item.desc-nacional  colon 32  skip
      item.desc-inter     colon 32  skip(1)
      with no-box width 132 down side-labels stream-io frame f-item-detalhado.


if i-pais-impto-usuario = 1 /* Brasil */ then
    form
       c-fiscal            no-label colon 32 skip(1)
       item.class-fiscal   colon 32 /*format {cdp/cd0603.i3}*/ 
       "-"                 space(1)
       classif-fisc.unidade no-labels
       item.cod-servico    colon 95  skip 
       c-cd-trib-iss       colon 32
       item.aliquota-iss   colon 95  skip
       c-cd-trib-ipi       colon 32 
       item.aliquota-ipi   colon 95  skip
       item.ind-ipi-dife   colon 32
       c-op-susp-ipi       colon 95  skip
       c-cd-trib-icm       colon 32
       &if "{&bf_dis_versao_ems}" >= "2.062" &then
        c-familia-ipi      colon 95  skip
       &endif
       de-aliq-pis         colon 32  
       c-nr-dcr-item       colon 95 skip
       de-aliq-cofins      colon 32  
       de-red-pis          colon 95  skip
       c-orig-aliq-pis     colon 32
       de-red-cofins       colon 95  skip
       c-tp-apur-ipi       COLON 32
       c-orig-aliq-cofins  colon 95  skip
       c-cod-sefazsp       colon 32
       c-cod-ean           colon 95  skip
       c-combust           colon 32  skip(1)
       c-narrativa         no-label colon 32 skip(1)
       with no-box width 132 down side-labels stream-io frame f-item-impto-brasil.

{utp/ut-liter.i Sim/N∆o *}
ASSIGN item.fraciona:FORMAT       IN FRAME f-item-detalhado = RETURN-VALUE
       item.ind-especifico:FORMAT IN FRAME f-item-detalhado = RETURN-VALUE
       item.curva-abc:FORMAT      IN FRAME f-item-detalhado = RETURN-VALUE
       item.curva-abc:FORMAT      IN FRAME f-item-resumido = RETURN-VALUE
       item.curva-abc:FORMAT      IN FRAME f-item-resumido-arg = RETURN-VALUE
       item.ind-item-fat:FORMAT   IN FRAME f-item-detalhado = RETURN-VALUE
       item.loc-unica:FORMAT      IN FRAME f-item-detalhado = RETURN-VALUE
       item.ind-ipi-dife:FORMAT   IN FRAME f-item-impto-brasil = RETURN-VALUE
       item.baixa-estoq:FORMAT    IN FRAME f-item-detalhado = RETURN-VALUE.


    RUN esp/mssp/esmsspapi001.p PERSISTENT SET h-esmsspapi001.
if  i-pais-impto-usuario <> 1 
AND i-pais-impto-usuario <> 3 then
    form
       c-fiscal            no-label colon 32 skip(1)
       item.cod-tax        colon 32
       c-desc-tax          colon 38  no-label skip(1)
       with no-box width 132 down side-labels stream-io frame f-item-impto-argentina.

       /*
       find tipo-tax where tipo-tax.cod-tax = item.cod-tax no-lock no-error.
       assign c-desc-tax = tipo-tax.descricao.
       */

if i-pais-impto-usuario = 3 /* EUA */ then
    form
       c-fiscal            no-label colon 32 skip(1)
       item.cod-tax        colon 32
       c-desc-tax          colon 38  no-label skip(1)
       c-narrativa         no-label colon 32 skip(1)
       with no-box width 132 down side-labels stream-io frame f-item-impto-eua.

       /*
       find tipo-tax where tipo-tax.cod-tax = item.cod-tax no-lock no-error.
       assign c-desc-tax = tipo-tax.descricao.
       */


form
   skip(1)
   c-selecao                no-label            at  20  skip(1)
   c-item-ini               colon 40 " |< >| "  at  60
   c-item-fim               no-label skip
   c-gr-estoq-ini           colon 40 " |< >| "  at  60
   c-gr-estoq-fim           no-label skip
   c-fam-mat-ini            colon 40 " |< >| "  at  60
   c-fam-mat-fim            no-label skip
   c-fam-coml-ini           colon 40 " |< >| "  at  60
   c-fam-coml-fim           no-label skip(2)
   c-param                  no-label            at  20  skip(1)
   l-tipo                   colon 40 skip
   c-lista                  colon 40 skip
   l-narrativa              colon 40 skip(2)
   c-class                  no-label            at  20  skip(1)
   c-classifica             colon 40 skip(2)
   c-imp                    no-label            at  20  skip(1)
   c-destino                colon 40
   c-destino-impressao      no-label
   arquivo                  no-label skip
   with stream-io frame f-param attr-space side-labels no-box width 132.

{utp/ut-liter.i Listagem_Itens * }
assign c-programa     = "escdp060"
       c-versao       = "1.00"
       c-revisao      = "000"
       c-titulo-relat = RETURN-VALUE
       c-sistema      = "".

/* traduá‰es dos parÉmetros de impress∆o */
{utp/ut-liter.i Sim/N∆o * }
ASSIGN l-tipo:FORMAT IN FRAME f-param = RETURN-VALUE
       l-narrativa:FORMAT IN FRAME f-param = RETURN-VALUE.

{utp/ut-liter.i Seleá∆o * L} 
assign c-selecao = trim(return-value).

{utp/ut-field.i mgind item it-codigo 1}
assign c-item-ini:label in frame f-param = trim(return-value).

{utp/ut-field.i mgind item ge-codigo 1}
assign c-gr-estoq-ini:label in frame f-param = trim(return-value).

{utp/ut-field.i mgind item fm-codigo 1}
assign c-fam-mat-ini:label in frame f-param = trim(return-value).

{utp/ut-field.i mgind item fm-cod-com 1}
assign c-fam-coml-ini:label in frame f-param = trim(return-value).

{utp/ut-liter.i ParÉmetros * L}
assign c-param = trim(return-value) .

{utp/ut-liter.i Resumido/Detalhado MFT c}
assign l-tipo:format in frame f-param = trim(return-value).

{utp/ut-liter.i Tipo_do_Relat¢rio * L}
assign l-tipo:label in frame f-param = trim(return-value).

{utp/ut-liter.i Lista_Itens * L}
assign c-lista:label in frame f-param = trim(return-value).

{utp/ut-liter.i Listar_Narrativa * L}
assign l-narrativa:label in frame f-param = trim(return-value).

{utp/ut-liter.i Sim/N∆o *}
assign l-narrativa:format in frame f-param = trim(return-value).

case tt-param.rs-lista :
     when 1 then do:
          {utp/ut-liter.i Todos * c} c-lista = trim(return-value).
     end.
     when 2 then do:
          {utp/ut-liter.i Somente_os_Ativos * c} c-lista = trim(return-value).
     end.
     when 3 then do:
          {utp/ut-liter.i Somente_os_Obsoletos_Ordens_Autom†ticas * c} c-lista = trim(return-value).
     end.
     when 4 then do:
          {utp/ut-liter.i Somente_os_Obsoletos_Todas_as_Ordens * c} c-lista = trim(return-value).
     end.
     when 5 then do:
          {utp/ut-liter.i Totalmente_Obsoletos * c} c-lista = trim(return-value).
     end.
end case.

{utp/ut-liter.i Classificaá∆o * L}
assign c-class = trim(return-value).

{utp/ut-liter.i Classificado_Por * L}
assign c-classifica:label in frame f-param = trim(return-value).

{utp/ut-liter.i Destino * L}
assign c-destino:label in frame f-param = trim(return-value).

RUN utp/ut-liter.p (trim({varinc/var00002.i 04 tt-param.destino}), "*", "").
assign c-destino-impressao = RETURN-VALUE.

{utp/ut-liter.i Listagem_de_Itens * L}
assign c-titulo-relat = trim(return-value).

{utp/ut-liter.i Impress∆o * L}
assign c-imp = trim(return-value).

/* Vari†veis do cabeáalho resumido */
{utp/ut-field.i mgind item aliquota-ipi 2}
assign c-aliquota-ipi  = trim(return-value).

{utp/ut-field.i mgind item cd-trib-ipi 2}
assign c-cd-trib-ipi  = trim(return-value).

{utp/ut-field.i mgind item cod-tax 2}
assign c-cod-imposto  = trim(return-value).

{utp/ut-field.i mgdis tipo-tax tax-perc 2}
assign c-perc-taxa = trim(return-value).

{utp/ut-field.i mgind item it-codigo 2}
assign c-item = trim(return-value).

{utp/ut-field.i mgind item desc-item 2}
assign c-desc = trim(return-value).

{utp/ut-field.i mgind item deposito-pad 2}
assign c-dep-pad = trim(return-value).

{utp/ut-field.i mgind item curva-abc 2}
assign c-curva = substring(return-value,7,4).

{utp/ut-field.i mgind item class-fiscal 2}
assign c-class-fiscal = trim(return-value).

{utp/ut-field.i mgind item aliquota-ipi 2}
assign c-aliquota-ipi = trim(return-value).

{utp/ut-field.i mgind item peso-liquido 2}
assign c-peso = trim(return-value).

{utp/ut-field.i mgind item un 2}
assign c-un = trim(return-value).

{utp/ut-field.i mgind item ft-conversao 2}
assign c-ft-conversao = trim(return-value).

{utp/ut-field.i mgind item dec-ftcon 2}
assign c-dec-ftcon = trim(return-value).

{utp/ut-field.i mgind item fm-codigo 2}
assign c-fm-codigo = trim(return-value).

{utp/ut-field.i mgind item fm-cod-com 2}
assign c-fm-cod-com = trim(return-value).


{utp/ut-field.i mgind item ge-codigo 2}
assign c-ge-codigo = trim(return-value).

{utp/ut-field.i mgind item cd-origem 2}
assign c-cd-origem = trim(return-value).

{utp/ut-field.i mgind item ind-item-fat 2}
assign c-ind-item-fat = trim(return-value).

{utp/ut-liter.i C¢digo_SEFAZ_-_SP}
assign c-cod-sefazsp:label in frame f-item-impto-brasil = trim(return-value).

{utp/ut-liter.i C¢d_GTIN_(Trib)}
assign c-cod-ean:label in frame f-item-impto-brasil = trim(return-value).

{utp/ut-liter.i Combust°vel_/_Solvente}
assign c-combust:label in frame f-item-impto-brasil = trim(return-value).

{utp/ut-liter.i Informaá‰es_Gerais}
assign c-geral = trim(return-value).

{utp/ut-liter.i Informaá‰es_Complementares}
assign c-complementar= trim(return-value).

{utp/ut-liter.i Informaá‰es_Fiscais}
assign c-fiscal = trim(return-value).

{utp/ut-liter.i Narrativa}
assign c-narrativa = trim(return-value).

/*** Vari†veis dos labels detalhado ***/

{utp/ut-liter.i Forma_Descriá∆o_Item * L}
assign c-ind-imp-desc:label in frame f-item-detalhado = trim(return-value).

{utp/ut-liter.i Quantidade_Fracionada * L}
assign item.fraciona:label in frame f-item-detalhado = trim(return-value).

{utp/ut-liter.i Espec°fico * L}
assign item.ind-especifico:label in frame f-item-detalhado = trim(return-value).

{utp/ut-liter.i Emiss∆o_Curva_ABC * L}
assign item.curva-abc:label in frame f-item-detalhado = trim(return-value).

{utp/ut-liter.i Item_Fatur†vel * L}
assign item.ind-item-fat:label in frame f-item-detalhado = trim(return-value).

&IF DEFINED (bf_dis_versao_ems) &THEN
  &IF '{&bf_dis_versao_ems}'  = '2.04'  OR 
      '{&bf_dis_versao_ems}' >= '2.062' &THEN
    {utp/ut-liter.i Unidade_Faturamento * L}
  &ELSE
    {utp/ut-liter.i Fatura_QTD_Fam°lia * L}
  &ENDIF
&ENDIF 

assign c-ind-inf-qtf:label in frame f-item-detalhado = trim(return-value).

{utp/ut-liter.i Baixa_Estoque * L}
assign item.baixa-estoq:label in frame f-item-detalhado = trim(return-value).

{utp/ut-liter.i Localizaá∆o_Ènica * L}
assign item.loc-unica:label in frame f-item-detalhado = trim(return-value).

{utp/ut-liter.i Tipo_Controle * L}
assign c-tipo-contr:label in frame f-item-detalhado = trim(return-value).

{utp/ut-liter.i Tipo_Controle_Estq * L}
assign c-tipo-con-est:label in frame f-item-detalhado = trim(return-value).

{utp/ut-liter.i C¢digo_Tributaá∆o_ISS * L}
assign c-cd-trib-iss:label in frame f-item-impto-brasil = trim(return-value).

{utp/ut-liter.i C¢digo_Tributaá∆o_IPI * L}
assign c-cd-trib-ipi:label in frame f-item-impto-brasil = trim(return-value).

{utp/ut-liter.i Possui_IPI_Diferenciado * L}
assign item.ind-ipi-dife:label in frame f-item-impto-brasil = trim(return-value).

{utp/ut-liter.i C¢digo_Tributaá∆o_ICMS * L}
assign c-cd-trib-icm:label in frame f-item-impto-brasil = trim(return-value).

{utp/ut-liter.i Al°quota_PIS * L}
assign de-aliq-pis:label in frame f-item-impto-brasil = trim(return-value).

{utp/ut-liter.i Al°quota_COFINS * L}
assign de-aliq-cofins:label in frame f-item-impto-brasil = trim(return-value).

{utp/ut-liter.i Reduá∆o_PIS * L}
assign de-red-pis:label in frame f-item-impto-brasil = trim(return-value).

{utp/ut-liter.i Reduá∆o_COFINS * L}
assign de-red-cofins:label in frame f-item-impto-brasil = trim(return-value).

{utp/ut-liter.i Optante_Suspens∆o_IPI * L}
assign c-op-susp-ipi:label in frame f-item-impto-brasil = trim(return-value).

{utp/ut-liter.i Origem_Al°quota_PIS * L}
assign c-orig-aliq-pis:label in frame f-item-impto-brasil = trim(return-value).

{utp/ut-liter.i Origem_Al°quota_COFINS * L}
assign c-orig-aliq-cofins:label in frame f-item-impto-brasil = trim(return-value).

{utp/ut-liter.i Tp_Apuraá∆o_IPI * L}
assign c-tp-apur-ipi:label in frame f-item-impto-brasil = trim(return-value).

&if "{&bf_dis_versao_ems}" >= "2.062" &then
{utp/ut-liter.i Fam°lia_IPI * L}
assign c-familia-ipi:label in frame f-item-impto-brasil = trim(return-value).
&endif

/* Include Padr∆o para Output de Relat¢rio */
run utp/ut-trfrrp.p (input frame f-item-impto-eua:handle).
run utp/ut-trfrrp.p (input frame f-item-impto-argentina:handle).
run utp/ut-trfrrp.p (input frame f-item-impto-brasil:handle).
run utp/ut-trfrrp.p (input frame f-item-detalhado:handle).
run utp/ut-trfrrp.p (input frame f-item-resumido-arg:handle).
run utp/ut-trfrrp.p (input frame f-item-resumido:handle).
run utp/ut-trfrrp.p (input frame f-familia-coml:handle).
run utp/ut-trfrrp.p (input frame f-estoque:handle).
run utp/ut-trfrrp.p (input frame f-familia:handle).
run utp/ut-trfrrp.p (input frame f-cab-resumido-arg:handle).
run utp/ut-trfrrp.p (input frame f-cab-resumido:handle).
{include/i-rpout.i &STREAM="stream str-rp" &pagesize="0"}


FOR EACH tt-fat-estab-item: DELETE tt-fat-estab-item. END.


FOR EACH ponto-programa NO-LOCK 
    where ponto-programa.nome-programa = 'escdp060'
      AND ponto-programa.ponto = 1,
    EACH conteudo-programa OF ponto-programa NO-LOCK:

    ASSIGN c-fat-estab    = c-fat-estab    + ';' + 'Fat '  + conteudo-programa.conteudo
           c-origem-estab = c-origem-estab + ';' + 'Orig ' + conteudo-programa.conteudo .


    CREATE tt-fat-estab-item.
    ASSIGN tt-fat-estab-item.cod-estabel = conteudo-programa.conteudo.
END.



view stream str-rp frame f-cab-resumido-arg.
PUT 
     STREAM str-rp
      UNFORMATTED 
                    "I "                                                 
                    "P "                                                 
                    c-item                                              
                ";" c-desc                                              
                ";" c-dep-pad                                           
                ";" c-curva                                             
                ";" c-class-fiscal                                      
                ";" "% IPI"                                             
                ";" "Tribut IPI"                                                 
                ";" "Peso Bruto"
                ";" c-peso                                              
                ";" c-un                                                
                ";" c-ft-conversao                                      
                ";" c-dec-ftcon                                         
                ";" c-fm-codigo
                ";" "Desc Familia Mat"
                ";" c-fm-cod-com                                        
                ";" c-ge-codigo                                         
                ";" "Orig" 

                c-fat-estab 
                
                /*
                ";" "Fat 101"                                           
                ";" "Fat 103"                                           
                ";" "Fat 104"                                           
                ";" "Fat 105"                                           
                ";" "Fat 106"                                           
                ";" "Fat 107"                                           
                */

                ";" "Altura"
                ";" "Largura"
                ";" "Comprimento"
                ";" "EAN"
                ";" "Fat."                                              
                ";" "Uni.Neg"                                             
                ";" "Implant."    
                ";" "Servico"
                ";" "Aliq.ISS"
                ";" "Status"
                ";" "CEST"
                ";" "Sigla"
                ";" "Altura"
                ";" "Largura"
                ";" "Comprimento"
                ";" "DUN14"
                ";" "QTD"
                ";" "Est Padr∆o"
                ";" "Qtde"
                ";" "Tribut ICMS"
                ";" "Ft conv unid trib"
                ";" "Orig Unid Trib"
                ";" "Unid Tribut"
                ";" c-origem-estab
                ";" "Descr. Resumida Inglàs"
                ";" "Tipo Controle"   
                ";" "Acondicionamento"   
                ";" "Inf.Adicionais"   
                ";" "Fabricante"   
                ";" "NVE"   
                ";" "Cod Excec Tarifaria"   
                ";" "Aliquota II"   
                ";" "Antidumping"   
                ";" "Observacoes"   
                ";" "GATT"   
                ";" "Perc GATT"   
                ";" "Narrativa"   
                ";" "Seq Suframa"   
                ";" "Narrativa Manaus"   
                ";" "Item Contr Suframa"   
                ";" "Num Proj.Suframa"   
                ";" "Destaque" 
                ";" "LI"
                ";" "Ex.IPI"
                ";" "Origem".  

IF  tt-param.l-narrativa THEN
    PUT STREAM str-rp UNFORMATTED 
        ';' 'Narrativa'.

PUT STREAM str-rp '' SKIP.

/* view stream str-rp frame f-cabec.  */
/* view stream str-rp frame f-rodape. */

/* Include com a definiá∆o da frame de Cabeáalho e RodapÇ */
{include/i-rpcab.i &STREAM="str-rp"}

run utp/ut-acomp.p persistent set h-programa.
run pi-inicializar in h-programa (input c-titulo-relat).

case tt-param.classifica :
     when 1 then do:
          {utp/ut-liter.i Item * c} c-classifica = trim(return-value).
          run pi-imprime-por-item.
     end.
     when 2 then do:
          {utp/ut-liter.i Grupo_de_Estoque * c} c-classifica = trim(return-value).
          run pi-imprime-por-grupo-estoq.
     end.
     when 3 then do:
          {utp/ut-liter.i Fam°lia_de_Material * c} c-classifica = trim(return-value).
          run pi-imprime-por-fam-mat.
     end.
     when 4 then do:
          {utp/ut-liter.i Fam°lia_Comercial * c} c-classifica = trim(return-value).
          run pi-imprime-por-fam-coml.
     end.
end case.

/*page stream str-rp.*/

/*if  i-pais-impto-usuario <> 1
AND i-pais-impto-usuario <> 3 then*/
    /*
    hide stream str-rp frame f-cab-resumido-arg.
    */
/*else
    hide stream str-rp frame f-cab-resumido.*/




disp stream str-rp
    c-selecao
    c-item-ini
    c-item-fim
    c-gr-estoq-ini
    c-gr-estoq-fim
    c-fam-mat-ini
    c-fam-mat-fim
    c-fam-coml-ini
    c-fam-coml-fim
    c-param
    l-tipo
    c-lista
    l-narrativa
    c-class
    c-classifica
    c-imp
    c-destino
    c-destino-impressao
    arquivo
    with frame f-param.
    down with frame f-param.

hide stream str-rp frame f-cab-resumido-arg.

/* Fechamento do output do Relat¢rio */
{include/i-rpclo.i &STREAM="stream str-rp"}
DELETE PROCEDURE h-esmsspapi001.
run pi-finalizar in h-programa.

/**************** PROCEDURES INTERNAS **************************/

/* Classificaá∆o da impress∆o por Itens */
PROCEDURE pi-imprime-por-item:

    DEFINE VARIABLE ii AS INTEGER     NO-UNDO.

    IF NOT AVAIL tt-digita THEN DO:
        FOR EACH ITEM
            WHERE item.it-codigo    >= tt-param.c-item-ini
            AND   item.it-codigo    <= tt-param.c-item-fim
            AND   item.ge-codigo    >= tt-param.c-gr-estoq-ini
            AND   item.ge-codigo    <= tt-param.c-gr-estoq-fim
            AND   item.fm-codigo    >= tt-param.c-fam-mat-ini
            AND   item.fm-codigo    <= tt-param.c-fam-mat-fim
            AND   item.fm-cod-com   >= tt-param.c-fam-coml-ini
            AND   item.fm-cod-com   <= tt-param.c-fam-coml-fim
            AND   item.class-fiscal >= tt-param.c-ncm-ini
            AND   item.class-fiscal <= tt-param.c-ncm-fim
            AND  ((tt-param.rs-lista = 2 AND item.cod-obsoleto = 1)
              OR  (tt-param.rs-lista = 3 AND item.cod-obsoleto = 2)
              OR  (tt-param.rs-lista = 4 AND item.cod-obsoleto = 3)
              OR  (tt-param.rs-lista = 5 AND item.cod-obsoleto = 4)
              OR  (tt-param.rs-lista = 1)) NO-LOCK BREAK BY item.it-codigo:
        
            {utp/ut-liter.i Itens_da_Nota: *}
            RUN pi-acompanhar in h-programa (INPUT RETURN-VALUE + item.it-codigo).
        
            IF i-pais-impto-usuario = 1 THEN DO:
                ASSIGN c-cd-trib-ipi = TRIM({ininc/i10in172.i 04 item.cd-trib-ipi})
                       c-cd-trib-icm = TRIM({ininc/i01in245.i 04 item.cd-trib-icm}).

        
                &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
                
                    RUN utp/ut-liter.p (TRIM(c-cd-trib-ipi), "*", "").
                    ASSIGN c-cd-trib-ipi = RETURN-VALUE.
        
                    RUN utp/ut-liter.p (TRIM(c-cd-trib-icm), "*", "").
                    ASSIGN c-cd-trib-icm = RETURN-VALUE.
                &ENDIF
            END.
        
            RUN pi-impressao-resumido.
            
            /*** Impress∆o da Narrativa ***/
            IF  tt-param.l-narrativa THEN
                RUN pi-imprime-narrativa.

            /* Chamado: C2304-0823 - tratamento para n∆o quebrar linhas indevidamente */
            IF  l-nem-dun-nem-embalag = YES THEN
                PUT STREAM str-rp '' SKIP.
        END.
    END.
    ELSE DO:
        FOR EACH tt-digita:
            FOR EACH ITEM
                WHERE item.it-codigo    = tt-digita.it-codigo
                AND   item.ge-codigo    >= tt-param.c-gr-estoq-ini
                AND   item.ge-codigo    <= tt-param.c-gr-estoq-fim
                AND   item.fm-codigo    >= tt-param.c-fam-mat-ini
                AND   item.fm-codigo    <= tt-param.c-fam-mat-fim
                AND   item.fm-cod-com   >= tt-param.c-fam-coml-ini
                AND   item.fm-cod-com   <= tt-param.c-fam-coml-fim
                AND   item.class-fiscal >= tt-param.c-ncm-ini
                AND   item.class-fiscal <= tt-param.c-ncm-fim
                AND  ((tt-param.rs-lista = 2 AND item.cod-obsoleto = 1)
                  OR  (tt-param.rs-lista = 3 AND item.cod-obsoleto = 2)
                  OR  (tt-param.rs-lista = 4 AND item.cod-obsoleto = 3)
                  OR  (tt-param.rs-lista = 5 AND item.cod-obsoleto = 4)
                  OR  (tt-param.rs-lista = 1)) NO-LOCK BREAK BY item.it-codigo:
            
                {utp/ut-liter.i Itens_da_Nota: *}
                RUN pi-acompanhar in h-programa (INPUT RETURN-VALUE + item.it-codigo).
            
                IF i-pais-impto-usuario = 1 THEN DO:
                    ASSIGN c-cd-trib-ipi = TRIM({ininc/i10in172.i 04 item.cd-trib-ipi})
                           c-cd-trib-icm = TRIM({ininc/i01in245.i 04 item.cd-trib-icm}).
            
                    &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
                    
                        RUN utp/ut-liter.p (TRIM(c-cd-trib-ipi), "*", "").
                        ASSIGN c-cd-trib-ipi = RETURN-VALUE.
            
                        RUN utp/ut-liter.p (TRIM(c-cd-trib-icm), "*", "").
                        ASSIGN c-cd-trib-icm = RETURN-VALUE.
                    &ENDIF
                END.
            
                RUN pi-impressao-resumido.
                
                /*** Impress∆o da Narrativa ***/
                 IF  tt-param.l-narrativa THEN
                     RUN pi-imprime-narrativa.

                PUT STREAM str-rp '' SKIP.
            END.
        END.
    END.
END.



/* Classificaá∆o da impress∆o por Grupo de Estoque */
PROCEDURE pi-imprime-por-grupo-estoq:
    
    IF NOT AVAIL tt-digita THEN DO:
        FOR EACH item
            WHERE item.it-codigo    >= tt-param.c-item-ini
            AND   item.it-codigo    <= c-item-fim
            AND   item.ge-codigo    >= c-gr-estoq-ini
            AND   item.ge-codigo    <= c-gr-estoq-fim
            AND   item.fm-codigo    >= c-fam-mat-ini
            AND   item.fm-codigo    <= c-fam-mat-fim
            AND   item.fm-cod-com   >= c-fam-coml-ini
            AND   item.fm-cod-com   <= c-fam-coml-fim
            AND   item.class-fiscal >= tt-param.c-ncm-ini
            AND   item.class-fiscal <= tt-param.c-ncm-fim
            AND  ((tt-param.rs-lista = 2 AND item.cod-obsoleto = 1)
              OR  (tt-param.rs-lista = 3 AND item.cod-obsoleto = 2)
              OR  (tt-param.rs-lista = 4 AND item.cod-obsoleto = 3)
              OR  (tt-param.rs-lista = 5 AND item.cod-obsoleto = 4)
              OR  (tt-param.rs-lista = 1)) NO-LOCK BREAK BY item.ge-codigo:
        
            RUN pi-acompanhar IN h-programa (INPUT "Itens da Nota:":U + item.it-codigo).
        
            IF  i-pais-impto-usuario = 1 THEN DO:
                ASSIGN c-cd-trib-ipi = TRIM({ininc/i10in172.i 04 item.cd-trib-ipi})
                       c-cd-trib-icm = TRIM({ininc/i01in245.i 04 item.cd-trib-icm}).
        
                &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
                    RUN utp/ut-liter.p (TRIM(c-cd-trib-ipi), "*", "").
                    ASSIGN c-cd-trib-ipi = RETURN-VALUE.
        
                    RUN utp/ut-liter.p (TRIM(c-cd-trib-icm), "*", "").
                    ASSIGN c-cd-trib-icm = RETURN-VALUE.
                &ENDIF
            END.
        
            FOR FIRST grup-estoque FIELDS(descricao)
                WHERE grup-estoque.ge-codigo = item.ge-codigo NO-LOCK:

                ASSIGN c-gp-desc = grup-estoque.descricao.
            END.
        
            IF  FIRST-OF(item.ge-codigo) THEN
                DISP STREAM str-rp 
                     item.ge-codigo
                     c-gp-desc SKIP WITH FRAME f-estoque.
        
            RUN pi-impressao-resumido.
            
            /*** Impress∆o da Narrativa ***/
            IF  tt-param.l-narrativa THEN
                RUN pi-imprime-narrativa.

            PUT STREAM str-rp '' SKIP.
        END.
    END.
    ELSE DO:
        FOR EACH tt-digita:
            FOR EACH item
                WHERE item.it-codigo     = tt-digita.it-codigo
                AND   item.ge-codigo    >= c-gr-estoq-ini
                AND   item.ge-codigo    <= c-gr-estoq-fim
                AND   item.fm-codigo    >= c-fam-mat-ini
                AND   item.fm-codigo    <= c-fam-mat-fim
                AND   item.fm-cod-com   >= c-fam-coml-ini
                AND   item.fm-cod-com   <= c-fam-coml-fim
                AND   item.class-fiscal >= tt-param.c-ncm-ini
                AND   item.class-fiscal <= tt-param.c-ncm-fim
                AND  ((tt-param.rs-lista = 2 AND item.cod-obsoleto = 1)
                  OR  (tt-param.rs-lista = 3 AND item.cod-obsoleto = 2)
                  OR  (tt-param.rs-lista = 4 AND item.cod-obsoleto = 3)
                  OR  (tt-param.rs-lista = 5 AND item.cod-obsoleto = 4)
                  OR  (tt-param.rs-lista = 1)) NO-LOCK BREAK BY item.ge-codigo:
            
                RUN pi-acompanhar IN h-programa (INPUT "Itens da Nota:":U + item.it-codigo).
            
                IF  i-pais-impto-usuario = 1 THEN DO:
                    ASSIGN c-cd-trib-ipi = TRIM({ininc/i10in172.i 04 item.cd-trib-ipi})
                           c-cd-trib-icm = TRIM({ininc/i01in245.i 04 item.cd-trib-icm}).
            
                    &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
                        RUN utp/ut-liter.p (TRIM(c-cd-trib-ipi), "*", "").
                        ASSIGN c-cd-trib-ipi = RETURN-VALUE.
            
                        RUN utp/ut-liter.p (TRIM(c-cd-trib-icm), "*", "").
                        ASSIGN c-cd-trib-icm = RETURN-VALUE.
                    &ENDIF
                END.
            
                FOR FIRST grup-estoque FIELDS(descricao)
                    WHERE grup-estoque.ge-codigo = item.ge-codigo NO-LOCK:
                
                    ASSIGN c-gp-desc = grup-estoque.descricao.
                END.
            
                IF  FIRST-OF(item.ge-codigo) THEN
                    DISP STREAM str-rp 
                         item.ge-codigo
                         c-gp-desc SKIP WITH FRAME f-estoque.
            
                RUN pi-impressao-resumido.
                
                /*** Impress∆o da Narrativa ***/
                IF  tt-param.l-narrativa THEN
                    RUN pi-imprime-narrativa.

                PUT STREAM str-rp '' SKIP.
            END.
        END.
    END.
END.

/* Classificaá∆o da impress∆o por Fam°lia de Material */
PROCEDURE pi-imprime-por-fam-mat:    

    IF NOT AVAIL tt-digita THEN DO:
        FOR EACH ITEM
            WHERE item.it-codigo    >= tt-param.c-item-ini
            AND   item.it-codigo    <= c-item-fim
            AND   item.ge-codigo    >= c-gr-estoq-ini
            AND   item.ge-codigo    <= c-gr-estoq-fim
            AND   item.fm-codigo    >= c-fam-mat-ini
            AND   item.fm-codigo    <= c-fam-mat-fim
            AND   item.fm-cod-com   >= c-fam-coml-ini
            AND   item.fm-cod-com   <= c-fam-coml-fim
            AND   item.class-fiscal >= tt-param.c-ncm-ini
            AND   item.class-fiscal <= tt-param.c-ncm-fim
            AND  ((tt-param.rs-lista = 2 AND item.cod-obsoleto = 1)
              OR  (tt-param.rs-lista = 3 AND item.cod-obsoleto = 2)
              OR  (tt-param.rs-lista = 4 AND item.cod-obsoleto = 3)
              OR  (tt-param.rs-lista = 5 AND item.cod-obsoleto = 4)
              OR  (tt-param.rs-lista = 1)) NO-LOCK BREAK BY item.fm-codigo:
        
            RUN pi-acompanhar IN h-programa (INPUT "Itens da Nota:":U + item.it-codigo).
        
            IF  i-pais-impto-usuario = 1 THEN DO:
                ASSIGN c-cd-trib-ipi = TRIM({ininc/i10in172.i 04 item.cd-trib-ipi})
                       c-cd-trib-icm = TRIM({ininc/i01in245.i 04 item.cd-trib-icm}).
        
                &IF "{&FNC_MULTI_IDIOMA}" = "YES" &THEN
                    RUN utp/ut-liter.p (TRIM(c-cd-trib-ipi), "*", "").
                    ASSIGN c-cd-trib-ipi = RETURN-VALUE.
        
                    RUN utp/ut-liter.p (TRIM(c-cd-trib-icm), "*", "").
                    ASSIGN c-cd-trib-icm = RETURN-VALUE.
                &ENDIF
            END.
        
            FOR FIRST familia FIELDS(descricao)
                WHERE familia.fm-codigo = item.fm-codigo NO-LOCK:

                ASSIGN c-familia-desc = familia.descricao.
            END.
        
            IF  FIRST-OF(item.fm-codigo) THEN
                DISP STREAM str-rp 
                     item.fm-codigo WHEN AVAIL ITEM
                     c-familia-desc WHEN AVAIL familia SKIP WITH FRAME f-familia.
        
            RUN pi-impressao-resumido.
            
            /*** Impress∆o da Narrativa ***/
             IF  tt-param.l-narrativa THEN
                 RUN pi-imprime-narrativa.

             PUT STREAM str-rp '' SKIP.
        END.
    END.
    ELSE DO:
        FOR EACH tt-digita:
            FOR EACH ITEM
                WHERE item.it-codigo     = tt-digita.it-codigo
                AND   item.ge-codigo    >= c-gr-estoq-ini
                AND   item.ge-codigo    <= c-gr-estoq-fim
                AND   item.fm-codigo    >= c-fam-mat-ini
                AND   item.fm-codigo    <= c-fam-mat-fim
                AND   item.fm-cod-com   >= c-fam-coml-ini
                AND   item.fm-cod-com   <= c-fam-coml-fim
                AND   item.class-fiscal >= tt-param.c-ncm-ini
                AND   item.class-fiscal <= tt-param.c-ncm-fim
                AND  ((tt-param.rs-lista = 2 AND item.cod-obsoleto = 1)
                  OR  (tt-param.rs-lista = 3 AND item.cod-obsoleto = 2)
                  OR  (tt-param.rs-lista = 4 AND item.cod-obsoleto = 3)
                  OR  (tt-param.rs-lista = 5 AND item.cod-obsoleto = 4)
                  OR  (tt-param.rs-lista = 1)) NO-LOCK BREAK BY item.fm-codigo:
            
                RUN pi-acompanhar IN h-programa (INPUT "Itens da Nota:":U + item.it-codigo).
            
                IF  i-pais-impto-usuario = 1 THEN DO:
                    ASSIGN c-cd-trib-ipi = TRIM({ininc/i10in172.i 04 item.cd-trib-ipi})
                           c-cd-trib-icm = TRIM({ininc/i01in245.i 04 item.cd-trib-icm}).
            
                    &IF "{&FNC_MULTI_IDIOMA}" = "YES" &THEN
                        RUN utp/ut-liter.p (TRIM(c-cd-trib-ipi), "*", "").
                        ASSIGN c-cd-trib-ipi = RETURN-VALUE.
            
                        RUN utp/ut-liter.p (TRIM(c-cd-trib-icm), "*", "").
                        ASSIGN c-cd-trib-icm = RETURN-VALUE.
                    &ENDIF
                END.
            
                FOR FIRST familia FIELDS(descricao)
                    WHERE familia.fm-codigo = item.fm-codigo NO-LOCK:
                
                    ASSIGN c-familia-desc = familia.descricao.
                END.
            
                IF  FIRST-OF(item.fm-codigo) THEN
                    DISP STREAM str-rp 
                         item.fm-codigo WHEN AVAIL ITEM
                         c-familia-desc WHEN AVAIL familia SKIP WITH FRAME f-familia.
            
                RUN pi-impressao-resumido.
                
                /*** Impress∆o da Narrativa ***/
                 IF  tt-param.l-narrativa THEN
                     RUN pi-imprime-narrativa.

                 PUT STREAM str-rp '' SKIP.
            END.
        END.
    END.
END.


/* Classificaá∆o da impress∆o por Fam°lia Comercial */
PROCEDURE pi-imprime-por-fam-coml:

    IF NOT AVAIL tt-digita THEN DO:
        FOR EACH item
            WHERE item.it-codigo    >= tt-param.c-item-ini
            AND   item.it-codigo    <= c-item-fim
            AND   item.ge-codigo    >= c-gr-estoq-ini
            AND   item.ge-codigo    <= c-gr-estoq-fim
            AND   item.fm-codigo    >= c-fam-mat-ini
            AND   item.fm-codigo    <= c-fam-mat-fim
            AND   item.fm-cod-com   >= c-fam-coml-ini
            AND   item.fm-cod-com   <= c-fam-coml-fim
            AND   item.class-fiscal >= tt-param.c-ncm-ini
            AND   item.class-fiscal <= tt-param.c-ncm-fim
            AND  ((tt-param.rs-lista = 2 AND item.cod-obsoleto = 1)
              OR  (tt-param.rs-lista = 3 AND item.cod-obsoleto = 2)
              OR  (tt-param.rs-lista = 4 AND item.cod-obsoleto = 3)
              OR  (tt-param.rs-lista = 5 AND item.cod-obsoleto = 4)
              OR  (tt-param.rs-lista = 1)) NO-LOCK BREAK BY item.fm-cod-com:
        
            RUN pi-acompanhar IN h-programa (INPUT "Itens da Nota:":U + item.it-codigo).
        
            IF  i-pais-impto-usuario =1 THEN DO:
                ASSIGN c-cd-trib-ipi = TRIM({ininc/i10in172.i 04 item.cd-trib-ipi})
                       c-cd-trib-icm = TRIM({ininc/i01in245.i 04 item.cd-trib-icm}).
        
                &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
                    RUN utp/ut-liter.p (TRIM(c-cd-trib-ipi), "*", "").
                    ASSIGN c-cd-trib-ipi = RETURN-VALUE.
        
                    RUN utp/ut-liter.p (TRIM(c-cd-trib-icm), "*", "").
                    ASSIGN c-cd-trib-icm = RETURN-VALUE.
                &ENDIF
            END.
        
            FOR FIRST fam-comerc FIELDS(descricao)
                WHERE fam-comerc.fm-cod-com = item.fm-cod-com NO-LOCK:

                ASSIGN c-fam-comerc = fam-comerc.descricao.
            END.
        
            IF FIRST-OF(item.fm-cod-com) THEN
                DISP STREAM str-rp
                     item.fm-cod-com
                     c-fam-comerc SKIP WITH FRAME f-familia-coml.
        
            RUN pi-impressao-resumido.
        
            /*** Impress∆o da Narrativa ***/
            IF  tt-param.l-narrativa THEN
                RUN pi-imprime-narrativa.

            PUT STREAM str-rp '' SKIP.
        END.
    END.
    ELSE DO:
        FOR EACH tt-digita:
            FOR EACH item
                WHERE item.it-codigo     = tt-digita.it-codigo
                AND   item.ge-codigo    >= c-gr-estoq-ini
                AND   item.ge-codigo    <= c-gr-estoq-fim
                AND   item.fm-codigo    >= c-fam-mat-ini
                AND   item.fm-codigo    <= c-fam-mat-fim
                AND   item.fm-cod-com   >= c-fam-coml-ini
                AND   item.fm-cod-com   <= c-fam-coml-fim
                AND   item.class-fiscal >= tt-param.c-ncm-ini
                AND   item.class-fiscal <= tt-param.c-ncm-fim
                AND  ((tt-param.rs-lista = 2 AND item.cod-obsoleto = 1)
                  OR  (tt-param.rs-lista = 3 AND item.cod-obsoleto = 2)
                  OR  (tt-param.rs-lista = 4 AND item.cod-obsoleto = 3)
                  OR  (tt-param.rs-lista = 5 AND item.cod-obsoleto = 4)
                  OR  (tt-param.rs-lista = 1)) NO-LOCK BREAK BY item.fm-cod-com:
            
                RUN pi-acompanhar IN h-programa (INPUT "Itens da Nota:":U + item.it-codigo).
            
                IF  i-pais-impto-usuario =1 THEN DO:
                    ASSIGN c-cd-trib-ipi = TRIM({ininc/i10in172.i 04 item.cd-trib-ipi})
                           c-cd-trib-icm = TRIM({ininc/i01in245.i 04 item.cd-trib-icm}).
            
                    &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
                        RUN utp/ut-liter.p (TRIM(c-cd-trib-ipi), "*", "").
                        ASSIGN c-cd-trib-ipi = RETURN-VALUE.
            
                        RUN utp/ut-liter.p (TRIM(c-cd-trib-icm), "*", "").
                        ASSIGN c-cd-trib-icm = RETURN-VALUE.
                    &ENDIF
                END.
            
                FOR FIRST fam-comerc FIELDS(descricao)
                    WHERE fam-comerc.fm-cod-com = item.fm-cod-com NO-LOCK:

                    ASSIGN c-fam-comerc = fam-comerc.descricao.
                END.
            
                IF FIRST-OF(item.fm-cod-com) THEN
                    DISP STREAM str-rp
                         item.fm-cod-com
                         c-fam-comerc SKIP WITH FRAME f-familia-coml.
            
                RUN pi-impressao-resumido.
            
                /*** Impress∆o da Narrativa ***/
                IF  tt-param.l-narrativa THEN
                    RUN pi-imprime-narrativa.

                PUT STREAM str-rp '' SKIP.
            END.
        END.
    END.
END.

/* Procedure impress∆o de item resumido */
procedure pi-impressao-resumido:

    find tipo-tax where tipo-tax.cod-tax = item.cod-tax no-lock no-error.
    if avail tipo-tax then
        assign de-tax-perc = tipo-tax.tax-perc.
    else
        assign de-tax-perc = ?.

        ASSIGN v-cd-trib-ipi = SUBSTRING({ininc/i10in172.i 04 ITEM.cd-trib-ipi}, 1, 15). 

    ASSIGN c-fat-estabel-101 = ""
           c-fat-estabel-103 = ""
           c-fat-estabel-104 = ""
           c-fat-estabel-105 = ""
           c-fat-estabel-106 = ""
           c-fat-estabel-107 = "".

    ASSIGN c-fat-estab = ''
           c-origem-estab = ''.

    FOR EACH tt-fat-estab-item:

        ASSIGN log-fat-estab = NO
               origem-estab  = "".

        FOR EACH item-uni-estab
            WHERE item-uni-estab.it-codigo = ITEM.it-codigo 
             AND item-uni-estab.cod-estabel = tt-fat-estab-item.cod-estabel NO-LOCK:
           
            IF item-uni-estab.ind-item-fat = YES THEN
               ASSIGN log-fat-estab = YES.
            ELSE
               ASSIGN log-fat-estab = NO.

            ASSIGN origem-estab = SUBSTRING(item-uni-estab.char-2,18,3).

            /*
            IF item-uni-estab.cod-estabel = tt-fat-estab-item.cod-estabel THEN 
               ASSIGN log-fat-estab = YES.
            ELSE
               ASSIGN log-fat-estab = NO.
            */

            /* 
             IF item-uni-estab.cod-estabel = "101" THEN          /* Se Ç faturavel para o estabelecimento 101*/
                 IF item-uni-estab.ind-item-fat = YES THEN
                     ASSIGN c-fat-estabel-101 =  "SIM".
                 ELSE
                     ASSIGN c-fat-estabel-101 =  "N«O".
                     
             ELSE IF item-uni-estab.cod-estabel = "103" THEN      /* Se Ç faturavel para o estabelecimento 103*/
                 IF item-uni-estab.ind-item-fat = YES THEN
                     ASSIGN c-fat-estabel-103 =  "SIM".
                 ELSE
                     ASSIGN c-fat-estabel-103 =  "N«O".
             
             ELSE IF item-uni-estab.cod-estabel = "104" THEN      /* Se Ç faturavel para o estabelecimento 104*/
                 IF item-uni-estab.ind-item-fat = YES THEN
                     ASSIGN c-fat-estabel-104 =  "SIM".
                 ELSE
                     ASSIGN c-fat-estabel-104 =  "N«O".
             
             ELSE IF item-uni-estab.cod-estabel = "105" THEN      /* Se Ç faturavel para o estabelecimento 105*/
                 IF item-uni-estab.ind-item-fat = YES THEN
                     ASSIGN c-fat-estabel-105 =  "SIM".
                 ELSE
                     ASSIGN c-fat-estabel-105 =  "N«O".
        
             ELSE IF item-uni-estab.cod-estabel = "106" THEN      /* Se Ç faturavel para o estabelecimento 106*/
                     IF item-uni-estab.ind-item-fat = YES THEN
                         ASSIGN c-fat-estabel-106 =  "SIM".
                      ELSE
                         ASSIGN c-fat-estabel-106 =  "N«O".
                     ELSE IF item-uni-estab.cod-estabel = "107" THEN      /* Se Ç faturavel para o estabelecimento 107*/
                         IF item-uni-estab.ind-item-fat = YES THEN
                             ASSIGN c-fat-estabel-107 =  "SIM".
                         ELSE
                             ASSIGN c-fat-estabel-107 =  "N«O".
            */ 
        
        END.

        ASSIGN c-fat-estab = c-fat-estab + STRING(log-fat-estab,'SIM/NAO') + ';'
               c-origem-estab = c-origem-estab + origem-estab + ";".

    END.

    ASSIGN c-ean = "".

    FOR FIRST item-mat NO-LOCK
        WHERE item-mat.it-codigo = ITEM.it-codigo:

        ASSIGN c-ean = item-mat.cod-ean.

    END.
    IF ITEM.cod-obsoleto = 1 THEN
        ASSIGN c-cod-obsoleto = "Ativo".
    ELSE
        IF ITEM.cod-obsoleto = 2 THEN
            ASSIGN c-cod-obsoleto = "Obsoleto Ordens Automaticas".
        ELSE
            IF ITEM.cod-obsoleto = 3 THEN
                ASSIGN c-cod-obsoleto = "Obsoleto Todas as Ordens".
            ELSE
                IF ITEM.cod-obsoleto = 4 THEN
                   ASSIGN c-cod-obsoleto = "Totalmente Obsoleto".
     RUN piBuscaCEST IN h-esmsspapi001 (INPUT 1,
                                        INPUT IF TODAY > 04/01/2016 THEN TODAY ELSE 04/01/2016,
                                        INPUT "",
                                        INPUT "",
                                        INPUT "",
                                        INPUT ITEM.class-fiscal,
                                        INPUT ITEM.it-codigo,
                                        INPUT 0,
                                        OUTPUT c-mensagem,
                                        OUTPUT i-cest).

    IF i-cest = 0 THEN
        ASSIGN c-cest = "0000000".
    ELSE DO:
        IF LENGTH(i-cest) = 6 THEN
           ASSIGN c-cest = "0" + STRING(i-cest).
        ELSE
            ASSIGN c-cest = STRING(i-cest).

    END.


                                
    EMPTY TEMP-TABLE tt-aux.
    ASSIGN l-nem-dun-nem-embalag = NO.

    /* EXISTE EMBALAGEM PARA O ITEM? */
    IF  CAN-FIND(FIRST item-caixa
                     WHERE item-caixa.it-codigo = ITEM.it-codigo) THEN DO:

        IF NOT CAN-FIND (FIRST item-dun
                            WHERE item-dun.it-codigo = ITEM.it-codigo) THEN DO:
            FOR EACH item-caixa NO-LOCK
                WHERE item-caixa.it-codigo = ITEM.it-codigo
                   ,FIRST embalag no-lock
                        WHERE embalag.sigla-emb = item-caixa.sigla-emb:
                CREATE tt-aux.
                ASSIGN tt-aux.it-codigo  = ITEM.it-codigo
                       tt-aux.sigla-emb  = embalag.sigla-emb
                       tt-aux.altura     = embalag.altura
                       tt-aux.largura    = embalag.largura
                       tt-aux.Comprim    = embalag.comprim.
            END.
        END.
        ELSE DO:
            FOR EACH item-dun NO-LOCK
                 WHERE item-dun.it-codigo = ITEM.it-codigo:
                FOR EACH item-caixa NO-LOCK
                    WHERE item-caixa.it-codigo = ITEM.it-codigo
                       ,FIRST embalag no-lock
                            WHERE embalag.sigla-emb = item-caixa.sigla-emb:
                      CREATE tt-aux.
                      ASSIGN tt-aux.it-codigo  = ITEM.it-codigo
                             tt-aux.sigla-emb  = embalag.sigla-emb
                             tt-aux.altura     = embalag.altura
                             tt-aux.largura    = embalag.largura
                             tt-aux.Comprim    = embalag.comprim
                             tt-aux.cod-dun    = item-dun.cod-dun  
                             tt-aux.qtd-emb    = item-dun.qtd-emb. 
                 END.
            END.
        END.
    END.
    ELSE /*EXISTE DUN PARA O ITEM ? */
        IF  CAN-FIND (FIRST item-dun
                       WHERE item-dun.it-codigo = ITEM.it-codigo) THEN DO:

            IF  NOT CAN-FIND (FIRST item-caixa
                                WHERE item-caixa.it-codigo = ITEM.it-codigo) THEN DO:
                FOR EACH item-dun NO-LOCK
                     WHERE item-dun.it-codigo = ITEM.it-codigo:
                     CREATE tt-aux.
                     ASSIGN tt-aux.it-codigo  = ITEM.it-codigo
                            tt-aux.cod-dun    = item-dun.cod-dun  
                            tt-aux.qtd-emb    = item-dun.qtd-emb. 
                END.
            END.
            ELSE DO:
            FOR EACH item-caixa NO-LOCK
                WHERE item-caixa.it-codigo = ITEM.it-codigo
                   ,FIRST embalag no-lock
                        WHERE embalag.sigla-emb = item-caixa.sigla-emb:
                     FOR EACH item-dun NO-LOCK
                          WHERE item-dun.it-codigo = ITEM.it-codigo.
                          CREATE tt-aux.
                          ASSIGN tt-aux.it-codigo  = ITEM.it-codigo
                                 tt-aux.sigla-emb  = embalag.sigla-emb
                                 tt-aux.altura     = embalag.altura
                                 tt-aux.largura    = embalag.largura
                                 tt-aux.Comprim    = embalag.comprim
                                 tt-aux.cod-dun    = item-dun.cod-dun  
                                 tt-aux.qtd-emb    = item-dun.qtd-emb. 
                     END.
                END.
            END.
        END.
        ELSE 
            l-nem-dun-nem-embalag = YES.

    FIND FIRST b-item-caixa NO-LOCK
         WHERE b-item-caixa.it-codigo = item.it-codigo NO-ERROR.
    
    IF  AVAIL b-item-caixa THEN
        ASSIGN d-it-caixa = b-item-caixa.qt-item.
    ELSE
        ASSIGN d-it-caixa = 0.

    IF  item.cd-trib-icm = 1 THEN
        ASSIGN c-trib-icms = "Tributado".
    ELSE 
        IF  item.cd-trib-icm = 2 THEN
            ASSIGN c-trib-icms = "Isento".
        ELSE 
            IF  item.cd-trib-icm = 3 THEN
                ASSIGN c-trib-icms = "Outros".
            ELSE
                ASSIGN c-trib-icms = "Reduzido".

    ASSIGN c-fat-tribut = SUBSTR(item.char-1,321,20).

    IF  substring(item.char-1,341,1) = "1"  THEN
        ASSIGN c-orig-unid-tribut = "Unidade ncm".
    ELSE 
        IF  substring(item.char-1,341,1) = "2" THEN
            ASSIGN c-orig-unid-tribut = "Unidade da familia".
        ELSE 
            IF  substring(item.char-1,341,1) = "3" THEN
                ASSIGN c-orig-unid-tribut = "Unidade de faturamento".
            ELSE 
                IF  substring(item.char-1,341,1) = "4" THEN
                    ASSIGN c-orig-unid-tribut = "Peso liquido".
                ELSE
                    ASSIGN c-orig-unid-tribut = "Peso bruto".

   /* 1 - unidade ncm
      2 - unidade da familia
      3 - unidade de faturamento
      4 - peso liquido
      5 - peso bruto */

    FIND FIRST classif-fisc NO-LOCK
         WHERE classif-fisc.class-fiscal = item.class-fiscal NO-ERROR.

    ASSIGN c-unid-trbut = IF AVAIL classif-fisc THEN SUBSTRING(classif-fisc.char-2,2,3) ELSE "".
    
    /* inicio origem */
    ASSIGN i-tam-fam-mat = LENGTH(item.fm-codigo)
           c-aux-orig    = ""
           c-aux-fam-mat = "".

    DO  i-cont = 1 TO i-tam-fam-mat:
        IF  (i-tam-fam-mat - i-cont) < 3 THEN
            ASSIGN c-aux-fam-mat = c-aux-fam-mat + SUBSTR(item.fm-codigo,i-cont,1).
    END.

    IF  c-aux-fam-mat = "540" THEN
        ASSIGN c-aux-orig = "Manaus".
    ELSE DO:
        IF  item.ge-codigo = 40 
        OR  item.ge-codigo = 42 THEN
            ASSIGN c-aux-orig = "Brasil".
        ELSE DO:
            FIND LAST item-fornec-estab NO-LOCK
                 WHERE item-fornec-estab.it-codigo   = item.it-codigo
                   AND item-fornec-estab.cod-estabel = item.cod-estabel
                   AND item-fornec-estab.ativo       = YES
                   AND item-fornec-estab.perc-compra > 0 NO-ERROR.
            
            IF  NOT AVAIL item-fornec-estab THEN
                FIND LAST item-fornec-estab NO-LOCK
                     WHERE item-fornec-estab.it-codigo   = item.it-codigo
                     AND   item-fornec-estab.cod-estabel = item.cod-estabel NO-ERROR.
    
            IF  AVAIL item-fornec-estab THEN DO:
                FIND FIRST emitente 
                    WHERE emitente.cod-emitente = item-fornec-estab.cod-emitente NO-LOCK NO-ERROR.

                IF  AVAIL emitente THEN
                    ASSIGN c-aux-orig = emitente.pais.
            end.
        END.
    END.
    /* fim origem */

    IF  l-nem-dun-nem-embalag THEN DO:
        PUT STREAM str-rp UNFORMATTED 
            item.it-codigo                        ";"
            item.desc-item FORMAT "x(60)"         ";"
            item.deposito-pad                     ";"
            STRING(item.curva-abc,"SIM/NAO")      ";"
            item.class-fiscal FORMAT "9999.99.99" ";"
            item.aliquota-ipi                     ";"
            v-cd-trib-ipi                         ";"
            item.peso-bruto                       ";"
            item.peso-liquido                     ";"
            item.un                               ";"
            item.ft-conversao                     ";"
            item.dec-ftcon                        ";"
            item.fm-codigo                        ";"
            c-familia-desc                        ";"
            item.fm-cod-com                       ";"
            item.ge-codigo                        ";"
            item.codigo-orig                      ";"
            c-fat-estab
         /* c-fat-estabel-101                     ";"
            c-fat-estabel-103                     ";"
            c-fat-estabel-104                     ";"
            c-fat-estabel-105                     ";"
            c-fat-estabel-106                     ";"
            c-fat-estabel-107                     ";"  */
            item.altura                           ";"
            item.largura                          ";"
            item.comprim                          ";" 
            c-ean                                 ";"
            string(item.ind-item-fat,"SIM/NAO")   ";"
            item.cod-unid-neg                     ";"
            item.data-implant                     ";"
            item.cod-servico                      ";"
            item.aliquota-iss                     ";"
            c-cod-obsoleto                        ";"
            string(c-cest) FORMAT "99.999.99"     ";" 
                                             ";;;;;;" 
            item.cod-estabel                      ";" 
            d-it-caixa                            ";"
            c-trib-icms                           ";"
            c-fat-tribut                          ";"
            c-orig-unid-tribut                    ";"
            c-unid-trbut                          ";" 
            c-origem-estab.

        RUN pi-imprime-int-item.
    END.
    ELSE DO:
        FOR EACH tt-aux.
            PUT STREAM str-rp UNFORMATTED  
                item.it-codigo                        ";"
                item.desc-item format "x(60)"         ";"
                item.deposito-pad                     ";"
                string(item.curva-abc,"SIM/NAO")      ";"
                item.class-fiscal FORMAT "9999.99.99" ";"
                item.aliquota-ipi                     ";"
                v-cd-trib-ipi                         ";"
                item.peso-bruto                       ";"
                item.peso-liquido                     ";"
                item.un                               ";"
                item.ft-conversao                     ";"
                item.dec-ftcon                        ";"
                item.fm-codigo                        ";"
                c-familia-desc                        ";"
                item.fm-cod-com                       ";"
                item.ge-codigo                        ";"
                item.codigo-orig                      ";"
                c-fat-estab                            
             /* c-fat-estabel-101                     ";"
                c-fat-estabel-103                     ";"
                c-fat-estabel-104                     ";"
                c-fat-estabel-105                     ";"
                c-fat-estabel-106                     ";"
                c-fat-estabel-107                     ";"  */                                     
                item.altura                           ";"
                item.largura                          ";"
                item.comprim                          ";" 
                c-ean                                 ";"
                string(item.ind-item-fat,"SIM/NAO")   ";"
                item.cod-unid-neg                     ";"
                item.data-implant                     ";"
                item.cod-servico                      ";"
                item.aliquota-iss                     ";"
                c-cod-obsoleto                        ";"
                string(c-cest) FORMAT "99.999.99"     ";"
                tt-aux.sigla-emb                      ";"
                tt-aux.altura                         ";"
                tt-aux.largura                        ";"
                tt-aux.Comprim                        ";"
                tt-aux.cod-dun                        ";"
                tt-aux.qtd-emb                        ";"
                item.cod-estabel                      ";" 
                d-it-caixa                            ";"
                c-trib-icms                           ";"
                c-fat-tribut                          ";"
                c-orig-unid-tribut                    ";"
                c-unid-trbut                          ";"
                c-origem-estab.

             RUN pi-imprime-int-item.

             /* Chamado: C2304-0823 - tratamento para n∆o quebrar linhas indevidamente */
             PUT STREAM str-rp '' SKIP.
        END.
    END.

END PROCEDURE.

/** procedure de impressao da narrativa **/
{include/pi-edit.i} 

procedure pi-imprime-narrativa:

    DEFINE VARIABLE c-narrativa AS CHARACTER   NO-UNDO.

    ASSIGN c-narrativa = REPLACE(item.narrativa,';',':')
           c-narrativa = REPLACE(c-narrativa,CHR(9),' ')
           c-narrativa = REPLACE(c-narrativa,CHR(10),' ')
           c-narrativa = REPLACE(c-narrativa,CHR(13),' ').

    PUT stream str-rp       
         UNFORMATTED  c-narrativa ';'.

    /*
    run pi-print-editor (item.narrativa, 132).
    for each tt-editor:
        disp stream str-rp
             tt-editor.conteudo format "x(132)" no-label
             with no-box stream-io width 132 frame f-narrativa.
        down with stream-io frame f-narrativa.
    end.
    */
end.

PROCEDURE pi-imprime-int-item:

    DEFINE VARIABLE c-acond    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-inf-adic AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-fabric   AS CHARACTER NO-UNDO.
    
    DEFINE VARIABLE c-desc-inter       AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-narrativa        AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-narrativa-manaus AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE c-nve             AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-ex-tarifario    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-obs-antidumping AS CHARACTER NO-UNDO.
    DEFINE VARIABLE de-perc-gatt      AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE c-seq-suframa     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i-destaque        AS INTEGER   NO-UNDO.
    DEFINE VARIABLE c-ex-ipi          AS CHARACTER NO-UNDO.

    DEFINE VARIABLE c-projeto         AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-controle        AS CHARACTER NO-UNDO.

    FOR EACH comp-folh NO-LOCK
        WHERE comp-folh.cd-folha = "1":

        FIND FIRST it-carac-tec 
             WHERE it-carac-tec.it-codigo = ITEM.it-codigo
               AND it-carac-tec.cd-folha  = comp-folh.cd-folha
               AND it-carac-tec.cd-comp   = comp-folh.cd-comp 
        NO-LOCK NO-ERROR.

        IF AVAIL it-carac-tec THEN DO:
           /* Acondicionamento */
           IF comp-folh.nr-tabela = 4 THEN DO:
              ASSIGN c-acond = it-carac-tec.observacao.
           END.
           
           /* Informacaoes adicionais - tipo texto = 3 */
           IF comp-folh.tipo-result = 3 THEN DO:
              ASSIGN c-inf-adic = it-carac-tec.observacao.

              FIND it-msg-carac OF it-carac-tec NO-LOCK NO-ERROR. 

              IF AVAIL it-msg-carac THEN DO:
                 IF it-msg-carac.msg-exp <> '' THEN
                    ASSIGN c-inf-adic = it-msg-carac.msg-exp.
              END.
           END.
        END.
    END.
   
    FIND FIRST int-item WHERE int-item.it-codigo = ITEM.it-codigo NO-LOCK NO-ERROR.

    IF AVAIL int-item THEN DO:
       ASSIGN c-nve             = int-item.nve           
              c-ex-tarifario    = int-item.ex-tarifario
              c-obs-antidumping = int-item.obs-antidumping  
              de-perc-gatt      = int-item.perc-gatt
              c-seq-suframa     = int-item.seq-suframa  
              i-destaque        = int-item.destaque
              c-ex-ipi          = int-item.exIPI.
              
        ASSIGN c-nve             = REPLACE(REPLACE(REPLACE(c-nve             ,';',':'),CHR(13),''),CHR(10),'')           
               c-obs-antidumping = REPLACE(REPLACE(REPLACE(c-obs-antidumping ,';',':'),CHR(13),''),CHR(10),'')  .
              
    END.

    FOR EACH item-fabric NO-LOCK
        WHERE item-fabric.it-codigo  = ITEM.it-codigo:
        ASSIGN c-fabric = c-fabric + (IF c-fabric <> '' THEN ' , ' ELSE '') + string(item-fabric.cod-fabric).
    END.

    FOR EACH item-proj-suframa NO-LOCK 
        WHERE item-proj-suframa.it-codigo = ITEM.it-codigo:
        ASSIGN c-projeto  = c-projeto  + STRING(item-proj-suframa.nr-projeto) + (IF c-projeto  <> '' THEN ' , ' ELSE '')
               c-controle = c-controle + STRING(item-proj-suframa.controlado) + (IF c-controle <> '' THEN ' , ' ELSE '').
    END.       
    
    ASSIGN c-narrativa  = TRIM(ITEM.narrativa)
           c-desc-inter = TRIM(ITEM.desc-inter).

    IF INDEX(ITEM.narrativa,'#MANAUS#') <> 0 THEN
       ASSIGN c-narrativa        = SUBSTRING(ITEM.narrativa,1,INDEX(ITEM.narrativa,'#MANAUS#') - 1)
              c-narrativa-manaus = SUBSTRING(ITEM.narrativa,INDEX(ITEM.narrativa,'#MANAUS#'))
              c-narrativa-manaus = REPLACE(c-narrativa-manaus,'#MANAUS#','').
    
    ASSIGN c-desc-inter       = REPLACE(REPLACE(REPLACE(c-desc-inter      ,';',':'),CHR(13),''),CHR(10),'')
           c-acond            = REPLACE(REPLACE(REPLACE(c-acond           ,';',':'),CHR(13),''),CHR(10),'')
           c-inf-adic         = REPLACE(REPLACE(REPLACE(c-inf-adic        ,';',':'),CHR(13),''),CHR(10),'')
           c-obs-antidumping  = REPLACE(REPLACE(REPLACE(c-obs-antidumping ,';',':'),CHR(13),''),CHR(10),'')
           c-narrativa        = REPLACE(REPLACE(REPLACE(c-narrativa       ,';',':'),CHR(13),''),CHR(10),'')
           c-narrativa-manaus = REPLACE(REPLACE(REPLACE(c-narrativa-manaus,';',':'),CHR(13),''),CHR(10),''). 

    IF de-perc-gatt = ? THEN
       ASSIGN de-perc-gatt = 0.
    
    PUT STREAM str-rp
                                                                             ";"       
  /*  "Descr. Resumida Inglàs" */  c-desc-inter              FORMAT 'x(60)'  ";" 
  /*  "Tipo Controle"          */  ITEM.tipo-contr                           ";" 
  /*  "Acondicionamento"       */  TRIM(c-acond)             FORMAT 'x(500)' ";" 
  /*  "Inf.Adicionais"         */  TRIM(c-inf-adic)          FORMAT 'x(500)' ";" 
  /*  "Fabricante"             */  TRIM(c-fabric)            FORMAT 'x(500)' ";" 
  /*  "NVE"                    */  TRIM(c-nve)               FORMAT 'x(500)' ";" 
  /*  "Cod Excec Tarifaria"    */  c-ex-tarifario            FORMAT 'x(50)'  ";" 
  /*  "Aliquota II"            */  SUBSTRING(ITEM.char-2, 22, 6)             ";" 
  /*  "Antidumping"            */  TRIM(c-obs-antidumping) FORMAT 'x(500)'   ";" 
  /*  "Observacoes"            */                                            ";" 
  /*  "GATT"                   */  IF de-perc-gatt <> 0 THEN YES ELSE NO     ";" 
  /*  "Perc GATT"              */  de-perc-gatt                              ";" 
  /*  "Narrativa"              */  TRIM(c-narrativa)         FORMAT 'x(500)' ";" 
  /*  "Seq Suframa"            */  c-seq-suframa                             ";" 
  /*  "Narrativa Manaus"       */  TRIM(c-narrativa-manaus)  FORMAT 'x(500)' ";" 
  /*  "Item Contr Suframa"     */  TRIM(c-controle)          FORMAT 'x(500)' ";" 
  /*  "Num Proj.Suframa"       */  TRIM(c-projeto)           FORMAT 'x(500)' ";" 
  /*  "Destaque"               */  i-destaque                                ";" 
  /*  "LI"                     */  ITEM.log-necessita-li                     ";"
  /*  "EX.IPI"                 */  c-ex-ipi                 FORMAT 'x(50)'   ";"
  /*  "Origem"                 */  c-aux-orig               FORMAT 'x(20)'   ";". 


END PROCEDURE.

