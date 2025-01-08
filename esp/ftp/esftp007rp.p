/***********************************************************************
**  Programa..: ESP\FTP\esftp007RP.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: Relatorio de Vendas
**              ConversÆo do programa es0520.p - Claudiney
**  VersÆo....: 001 11/11/2004
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i esftp007 2.04.00.002}
 
/****************************  Definitions  ****************************/
{esp/ftp/esftp007tt.i}


{include/i-rpvar.i}
 
/****************************  Temp-Tables  ****************************/
/* form tt-digita.cd-gr
     fam-comerc.descricao
     with frame f-mostra row 3 12 down overlay col 30. */
/****************************  Variaveis    ****************************/
/* DEFINE BUFFER bfam-comerc FOR fam-comerc. */
def var h-boes464             as handle  no-undo.
def var da-data          as date.
def var da-data-ini      like nota-fiscal.dt-emis-nota.
def var da-data-fim      like nota-fiscal.dt-emis-nota.
def var de-perc-acordo   as decimal no-undo.
def var d-dt-ent         like ped-venda.dt-emiss.
def var c-obs            as char format "X(85)".
def var i-atendente      like ped-venda.tp-pedido.
def var c-mail           as char format "X(40)".
def var c-desc-grupo     like gr-cli.descricao.
DEFINE VARIABLE c-sit-ped AS CHARACTER FORMAT "x(12)"  NO-UNDO.
DEFINE VARIABLE c-cod-gerente AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nom-gerente AS CHARACTER   NO-UNDO.
def var i-p-medio        as dec format ">>>>>>9".
def var c-unid-neg       as char format "X(10)".
DEF VAR c-unid-nota      as char format "X(10)".
def var de-perc-comissao as dec format ">9.99".
DEF VAR c-desc-cond      LIKE cond-pagto.descricao.
DEF VAR de-preco-min     LIKE preco-item.preco-venda.
DEFINE VARIABLE dt-dt-implant LIKE ped-venda.dt-implant.
DEFINE VARIABLE c-desc-item AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-obs-aux AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-observ-item AS CHARACTER   NO-UNDO.
 
DEFINE VARIABLE hDBOcomis-rep AS HANDLE      NO-UNDO.
&GLOBAL-DEFINE ttTable        ttcomis-rep
&GLOBAL-DEFINE hDBOTable      hDBOcomis-rep
&GLOBAL-DEFINE DBOTable       comis-rep
 
def buffer b-emitente for emitente.
/****************************  Frames       ****************************/
 
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.
 
create tt-param.
raw-transfer raw-param to tt-param.
 
for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end. 
 
def var h-acomp      as handle no-undo.
FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.
 
assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Informa‡äes Adicionais"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "esftp007"
       c-versao       = "2.01"
       c-revisao      = "001".



 
/* ***************************  Main Block  *************************** */
RUN esbo/boes464.p PERSISTENT SET h-boes464.
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
DELETE PROCEDURE h-boes464.    
 
/* **********************  Internal Procedures  *********************** */
DEF VAR cRegiao AS CHAR FORMAT 'x(40)'.
DEF VAR cPerc   AS CHAR FORMAT 'x(05)'.
DEF VAR a AS DEC FORMAT ">>>,>>>,>>9.99".
    
    
 
 
PROCEDURE piImprimeRelat:
 
    PUT UNFORMATTED "Estab; Serie;   Nr Nota Fiscal      ;  Emitente ;Natur Oper  ;      Nr Sequencia ;Sequencia ; Item  ;Aliq ICMS ST; Sit Trib PIS; St Tr COFINS; "
        "St Trib ICMS; Aliq UF Dest ;Aliq Dif;UF Orig;UF Dest.;Vl ICMS FCP ;VL BC UF Dest;% ICMS FCP; VL ICMS UF Dest;Vl ICMS UF Remet;" SKIP.
    
    do da-data = tt-param.da-data-ini to tt-param.da-data-fim:
       RUN pi-acompanhar IN h-acomp (INPUT "Selecionando data:" + string(da-data,"99/99/9999")).
       FOR EACH nota-fiscal fields(nome-ab-cli  nr-nota-fis  vl-taxa-exp  serie       emite-duplic dt-emis-nota nat-operacao cod-emitente cidade      
                                   estado       cod-rep      no-ab-reppri nome-transp nr-praz-med  cod-estabel  nr-fatura    cod-cond-pag observ-nota vl-frete dt-saida dt-entr-cli) USE-INDEX ch-distancia no-lock
           WHERE nota-fiscal.dt-emis-nota = da-data
           AND   nota-fiscal.cod-estabel  >= tt-param.c-cod-estabel-ini 
           AND   nota-fiscal.cod-estabel  <= tt-param.c-cod-estabel-fim
           AND   nota-fiscal.cod-emitente >= tt-param.i-cod-cli-ini 
           AND   nota-fiscal.cod-emitente <= tt-param.i-cod-cli-fim 
           AND   nota-fiscal.estado       >= tt-param.uf-ini
           AND   nota-fiscal.estado       <= tt-param.uf-fim
           AND   nota-fiscal.dt-cancel    = ?,
           first emitente fields(nome-emit cgc e-mail cod-gr-cli cod-rep cod-emitente) no-lock 
                 WHERE emitente.cod-emitente = nota-fiscal.cod-emitente ,

           each it-nota-fisc fields(it-codigo nr-pedcli nr-seq-ped qt-faturada[1] vl-merc-liq nr-seq-fat it-codigo cod-estabel serie nr-nota-fis
                                    aliquota-icm vl-tot-item it-nota-fisc.vl-preuni vl-ipi-it nat-operacao cod-unid-neg vl-icmsub-it vl-despes-it) of nota-fiscal no-lock,
           FIRST ITEM fields(it-codigo desc-item fm-cod-com cod-unid-neg) NO-LOCK 
                 WHERE item.it-codigo  = it-nota-fisc.it-codigo:
           RUN pi-acompanhar IN h-acomp (INPUT "Selecionando data:" + string(da-data,"99/99/9999") + " - "+ nota-fiscal.nr-nota-fis).
           
           if (it-nota-fisc.it-codigo < ItCodigoIni or 
               it-nota-fisc.it-codigo > ItCodigoFim) then next. 
           FOR EACH ITEM-NF-ADC
                WHERE item-nf-adc.idi-tip-dado     = 24 /* DIFAL */
                AND ITEM-NF-ADC.cod-estab = nota-fiscal.cod-estabel
                AND ITEM-NF-ADC.cod-serie = nota-fiscal.serie
                AND ITEM-NF-ADC.cod-nota-fis = nota-fiscal.nr-nota-fis
                AND item-nf-adc.cod-natur-operac = nota-fiscal.nat-operacao
                AND item-nf-adc.num-seq-item-nf  = it-nota-fisc.nr-seq-fat
                AND item-nf-adc.cod-item         = it-nota-fisc.it-codigo NO-LOCK:
                   PUT item-nf-adc.cod-estab                     ";"
                       item-nf-adc.cod-serie                     ";"
                       item-nf-adc.cod-nota-fisc                 ";"
                       item-nf-adc.cdn-emitente                  ";"
                       item-nf-adc.cod-natur-operac              ";"
/*                        item-nf-adc.idi-tip-dado                  ";" */
                       item-nf-adc.num-seq                       ";" 
                       item-nf-adc.num-seq-item-nf               ";" 
                       item-nf-adc.cod-item                      ";" 
                       item-nf-adc.val-aliq-icms-st              ";" 
                       item-nf-adc.cod-sit-tributar-pis          ";" 
                       item-nf-adc.cod-sit-tributar-cofins       ";" 
                       item-nf-adc.cod-sit-tributar-icms         ";" 
                       item-nf-adc.cod-livre-1                   ";" 
                       item-nf-adc.cod-livre-2                   ";"
                       substring(item-nf-adc.cod-livre-3,1,2)    ";"
                       substring(item-nf-adc.cod-livre-3,3,4)    ";"
                       item-nf-adc.cod-livre-4                   ";"
/*                        item-nf-adc.dat-livre-1                   ";" */
/*                        item-nf-adc.dat-livre-2                   ";" */
/*                        item-nf-adc.dat-livre-3                   ";" */
/*                        item-nf-adc.dat-livre-4                   ";" */
/*                        item-nf-adc.log-livre-1                   ";" */
/*                        item-nf-adc.log-livre-2                   ";" */
/*                        item-nf-adc.log-livre-3                   ";" */
/*                        item-nf-adc.log-livre-4                   ";" */
/*                        item-nf-adc.num-livre-1                   ";" */
/*                        item-nf-adc.num-livre-2                   ";" */
/*                        item-nf-adc.num-livre-3                   ";" */
/*                        item-nf-adc.num-livre-4                   ";" */
                       item-nf-adc.val-livre-1                   ";" 
                       item-nf-adc.val-livre-2                   ";" 
                       item-nf-adc.val-livre-3                   ";" 
                       item-nf-adc.val-livre-4                  SKIP.








               PUT SKIP.
           END.
           
           
       END.
    END.
END PROCEDURE.
