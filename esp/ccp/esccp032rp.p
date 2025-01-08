
/*********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esccp032RP 2.00.01.084 } /*** 010184 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i esccp032rp MCD}
&ENDIF

{include/i_fnctrad.i}
{cdp/cdcfgman.i} /******* Include para mini-flexibiliza‡Æo *********/
{esp/es0018.i}

DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHAR NO-UNDO.

define temp-table tt-raw-digita NO-UNDO
    field raw-digita     as raw.

def var da-data-aux as date   no-undo.
def var da-termino-f as date   no-undo.
DEFINE VARIABLE c-clientes-oem AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-item-selec NO-UNDO
    FIELD rowid-item AS ROWID
    FIELD cd-planej  LIKE planejad.cd-planejad
    FIELD nome       LIKE planejad.nome
    index codigo cd-planej.

&IF defined(bf_man_206b) &THEN
    define variable l-usa-unid-negoc as logical init no no-undo.
    if(can-find(funcao where funcao.cd-funcao = "ems2-unidade-negocio":U and 
            funcao.ativo    = yes)) then do:
        assign l-usa-unid-negoc = yes.
    end.

    DEF VAR h-cdapi024    AS HANDLE NO-UNDO.
&endif

/* esta temp-table ‚ criada na pi-cria-ord-res e vai servir para que se 
   diminua o acesso a disco quando estiver no for each de reservas na 
   cd0284.i */
DEFINE TEMP-TABLE tt-ord-res NO-UNDO
    FIELD nr-ord-produ AS INTEGER
    FIELD cod-estabel  AS CHARACTER
    FIELD estado       AS INTEGER
    FIELD it-codigo    AS CHARACTER
    INDEX id IS PRIMARY UNIQUE
        nr-ord-produ.
DEF TEMP-TABLE tt-itens-excluir NO-UNDO
    FIELD it-codigo LIKE ITEM.it-codigo.

def input param raw-param as raw no-undo.
def input param table     for tt-raw-digita.

/* Defini‡äes de Vari veis p/ P gina de Parƒmetros */
def var l-param    like param-global.exp-cep no-undo.                 
def var c-lb-tit   as char no-undo extent 2.
def var c-lb-est   as char no-undo extent 2.
def var c-lb-lin   as char no-undo extent 2.
def var c-lb-dest  as char no-undo.
def var c-lb-usuar as char no-undo.
def var c-compr    as char no-undo.
def var c-fabr     as char no-undo.
def var c-ord-pla  as char no-undo.
def var c-ord-com  as char no-undo.
def var c-ord-pro  as char no-undo.


def var c-res-com  as char no-undo.
def var c-res-pla  as char no-undo.
def var c-sld-est  as char no-undo.
def var c-sld-ter  as char no-undo.
def var c-remessa  as char no-undo.
def var c-entrada  as char no-undo.
def var c-transfer as char no-undo.
def var c-re-con   as char no-undo.
def var c-en-con   as char no-undo.
def var c-ped-crt  as char no-undo.
def var c-it-mov   as char no-undo.
def var c-comp     as char no-undo.
&IF defined(bf_man_206b) &THEN
    def var c-cod-unid-negoc    like unid-negoc.cod-unid-negoc.
&ENDIF
def var c-cred-apr as char no-undo.
def var c-inf-dep  as char no-undo.
def var c-lb-obsol as char no-undo.
def var c-lb-form  as char no-undo.
def var c-lb-nivel as char no-undo.
def var c-lb-corte as char no-undo.
def var c-lb-op    as char no-undo.
def var c-lb-benef as char no-undo.
def var c-lb-sel   as char no-undo.
def var c-lb-cla   as char no-undo.
def var c-lb-par   as char no-undo.
def var c-lb-imp   as char no-undo.
def var c-lb-dig   as char no-undo.
def var c-lb-dep   as char no-undo.
def var c-lb-plano as char no-undo.
def var l-ord-aber as log  init no no-undo.
DEF VAR i-cont     AS INT NO-UNDO.

DEFINE VARIABLE c-excel        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE chExcel        AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chArquivo      AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chPlanilhaMod  AS COM-HANDLE NO-UNDO.

DEFINE VARIABLE c-item-impr    AS CHARACTER  NO-UNDO.

DEFINE STREAM str-excel.


&IF DEFINED(bf_man_206b) &THEN
    if l-usa-unid-negoc then do:
        RUN cdp/cdapi024.p PERSISTENT SET h-cdapi024.
    end.
&ENDIF

/* Definicao de elementos referentes a UPC */
{include/i-epc200.i "esccp032rp"}

/* {cdp/cdcfgman.i} */
&IF defined (bf_man_per_ppm) &THEN
    {esp/ccp/esccp032.i22}
    {esp/ccp/esccp032.i24}
    {esp/ccp/esccp032.i25}
&ENDIF

DEFINE VARIABLE l-apenas-oem AS LOGICAL     NO-UNDO.

{esp/ccp/esccp032.i11} /* Defini‡Æo de Vari veis */
{esp/ccp/esccp032.i20}   /* pi-simula‡Æo-estoque */
{esp/ccp/esccp032.i}   /* pi-simulacao */  /* Impressao - ADICIONADO GERACAO EM CSV */
{esp/ccp/esccp032.i12} /* pi-digitacao */

{esp/ccp/esccp032.i1}  /* pi-classifica-1 */
{esp/ccp/esccp032.i2}  /* pi-classifica-2 */
{esp/ccp/esccp032.i6}  /* pi-classifica-3 */
{esp/ccp/esccp032.i7}  /* pi-classifica-4 */
{esp/ccp/esccp032.i8}  /* pi-classifica-5 */
{esp/ccp/esccp032.i9}  /* pi-classifica-6 */  

{esp/ccp/esccp032.i13} /* pi-processa-componentes */

{include/i-rpvar.i}

&IF defined (bf_man_per_ppm) &THEN
    IF CAN-FIND(FIRST param-global WHERE param-global.modulo-per-ppm) THEN DO:
        run cpp/cpapi020.p persistent set h-cpapi020(INPUT-OUTPUT table tt-balanceia,
                                                     input-output table tt-erro,
                                                     INPUT        yes,
                                                     INPUT-OUTPUT TABLE tt-veiculos).
    END.
&ENDIF

{utp/ut-liter.i O_P * r}
assign c-liter[1] = trim (return-value).

{utp/ut-liter.i O_C* * r}
assign c-liter[2] = trim (return-value).

{utp/ut-liter.i O_C * r}
assign c-liter[3] = trim (return-value).

{utp/ut-liter.i O.S. * r}
assign c-liter[4] = trim (return-value).

{utp/ut-liter.i Res * r}
assign c-liter[5] = trim (return-value).

{utp/ut-liter.i P_V * r}
assign c-liter[6] = trim (return-value).

{utp/ut-liter.i O_Pl * r}
assign c-liter[7] = trim (return-value).

{utp/ut-liter.i R_Pl * r}
assign c-liter[8] = trim (return-value).

{utp/ut-liter.i Negativo * r}
assign c-liter[9] = trim (return-value).

{utp/ut-liter.i Abaixo_Qt_Segur * r}
assign c-liter[10] = trim (return-value).

create tt-param.
raw-transfer raw-param to tt-param.

ASSIGN l-apenas-oem = tt-param.apenas-oem.

for each tt-raw-digita NO-LOCK:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

for each tt-digita where tt-digita.l-dep = YES NO-LOCK:
    create tt-depositos.
    assign tt-depositos.cod-estabel = tt-digita.c-estab
           tt-depositos.cod-depos   = tt-digita.c-depos.
    delete tt-digita.
end.

/* Cria 1 Registros para individualizacao do Processamento pelo rowid */

create tt-estoq.
assign c-tempo            = string(rowid(tt-estoq))
       tt-estoq.tempo     = c-tempo
       tt-estoq.dt-inicio = today
       tt-estoq.tipo      = "".

find first param-global no-lock no-error.
assign c-empresa  = (if avail param-global then param-global.grupo else "")
       c-programa = "CD/0420RP".

{utp/ut-liter.i Simula‡Æo_do_Estoque * r}
assign c-titulo-relat = trim(return-value).
{utp/ut-liter.i CONTROLE_DA_PRODU€ÇO * r}
assign c-sistema = trim(return-value).


IF OPSYS = "UNIX" THEN DO:
    RUN esp/es0018p.p (INPUT "spool-unix", /* Nome do programa */
                       INPUT 1,           /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    FOR FIRST tt-prog-ponto NO-LOCK:

        ASSIGN c-excel = tt-prog-ponto.conteudo + "~/" + v_cod_usuar_corren + "~/".

        OS-CREATE-DIR VALUE(c-excel).

        ASSIGN c-excel = c-excel + "esccp032.csv".
        
    END.

END.
ELSE DO:
    RUN esp/es0018p.p (INPUT "spool-win", /* Nome do programa */
                       INPUT 1,          /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.

    FOR FIRST tt-prog-ponto NO-LOCK:

        ASSIGN c-excel = tt-prog-ponto.conteudo + "~\" + v_cod_usuar_corren + "~\".

        OS-CREATE-DIR VALUE(c-excel).

        ASSIGN c-excel = c-excel + "esccp032.csv".
    END.

END. 


{include/i-rpcab.i}
{include/i-rpout.i} 
view frame f-cabec.
view frame f-rodape.


OUTPUT STREAM str-excel TO VALUE(c-excel) CONVERT TARGET "iso8859-1".

PUT STREAM str-excel 
    UNFORMATTED 'Item;Descricao;Qtde Segur;Un;Ref;Tipo;Saldo Inicial;Referencia;Quantidade;Dt In¡cio;Dt Termino;Dispon¡vel;Observacao U.Neg;Acao Anterior' SKIP.


run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Simula‡Æo_de_Estoque *}
run pi-inicializar in h-acomp (input  Return-value ).



if can-find (first tt-digita) then
   run pi-digitacao.
else do:
     case tt-param.classifica:
          when 1 then run pi-classifica-1.
          when 2 then run pi-classifica-2.
          when 3 then run pi-classifica-3.
          when 4 then run pi-classifica-4.     
          when 5 then run pi-classifica-5.
          when 6 then run pi-classifica-6.          
     end case.
end.

if tt-param.l-impr-parametro =  yes THEN do:

    {utp/ut-liter.i Sele‡Æo_de_Itens * r}
    assign c-lb-tit[1] = trim(return-value).
    {utp/ut-liter.i Sele‡Æo_dos_Componentes_do_Item * r}
    assign c-lb-tit[2] = trim(return-value).
    {utp/ut-liter.i Estabelecimento * r}
    assign c-lb-est[1] = trim(return-value)
           c-lb-est[2] = trim(return-value).
    {utp/ut-liter.i Linha_Produ‡Æo * r}
    assign c-lb-lin[1] = trim(return-value)
           c-lb-lin[2] = trim(return-value).
    {utp/ut-liter.i Destino * r}
    assign c-lb-dest = trim(return-value).
    {utp/ut-liter.i Usu rio * r}
    assign c-lb-usuar = trim(return-value).
    {utp/ut-liter.i Comprados * r}
    assign c-compr = trim(return-value).
    {utp/ut-liter.i Fabricados * r}
    assign c-fabr = trim(return-value).
    {utp/ut-liter.i Plano * r}
    assign c-lb-plano = trim(return-value).
    {utp/ut-liter.i Ordens_Planejadas * r}
    assign c-ord-pla = trim(return-value).
    {utp/ut-liter.i Ordens_de_Compra * r}
    assign c-ord-com = trim(return-value).
    {utp/ut-liter.i Ordens_de_Produ‡Æo * r}
    assign c-ord-pro = trim(return-value).
    {utp/ut-liter.i Reservas_Comprometidas * r}
    assign c-res-com = trim(return-value).
    {utp/ut-liter.i Reservas_Planejadas * r}
    assign c-res-pla = trim(return-value).
    {utp/ut-liter.i Saldos_em_Estoque * r}
    assign c-sld-est = trim(return-value).
    {utp/ut-liter.i Saldos_em_Poder_de_Terceiros * r}
    assign c-sld-ter = trim(return-value).
    {utp/ut-liter.i Remessa_para_Beneficiamento * r}
    assign c-remessa = trim(return-value).
    {utp/ut-liter.i Entrada_para_Beneficiamento * r}
    assign c-entrada = trim(return-value).
    {utp/ut-liter.i Transferˆncia * r}
    assign c-transfer = trim(return-value).
    {utp/ut-liter.i Remessa_em_Consigna‡Æo * r}
    assign c-re-con = trim(return-value).
    {utp/ut-liter.i Entrada_em_Consigna‡Æo * r}
    assign c-en-con = trim(return-value).
    {utp/ut-liter.i Pedidos_em_Carteira * r}
    assign c-ped-crt = trim(return-value).
    {utp/ut-liter.i Itens_sem_Reservas/Ordens * r}
    assign c-it-mov = trim(return-value).
    {utp/ut-liter.i Componentes_do_Item * r}
    assign c-comp = trim(return-value).
    &if defined(bf_man_206b) &then
            {utp/ut-field.i mgind unid-negoc cod-unid-negoc 1}
            assign c-cod-unid-negoc = trim(return-value).
    &endif
    {utp/ut-liter.i Apenas_Pedidos_com_Cr‚ditos_Aprovados * r}
    assign c-cred-apr = trim(return-value).
    {utp/ut-liter.i Informa_Dep¢sitos * r}
    assign c-inf-dep = trim(return-value).
    {utp/ut-liter.i Obsoleto * r}
    assign c-lb-obsol = trim(return-value).
    {utp/ut-liter.i Formato * r}
    assign c-lb-form = trim(return-value).
    {utp/ut-liter.i N£mero_de_N¡veis_a_Listar * r}
    assign c-lb-nivel = trim(return-value).
    {utp/ut-liter.i Data_de_Corte * r}
    assign c-lb-corte = trim(return-value).
    {utp/ut-liter.i Data_de_Corte_para_Ordens_Planejadas * r}
    assign c-lb-op = trim(return-value).
    {utp/ut-liter.i Ordem_Compra_Beneficiamento * r}
    assign c-lb-benef = trim(return-value).
    {utp/ut-liter.i Tipo * r}
    assign c-lb-tipo = trim(return-value).
    {utp/ut-liter.i SELE€ÇO * r}
    assign c-lb-sel = trim(return-value).
    {utp/ut-liter.i CLASSIFICA€ÇO * r}
    assign c-lb-cla = trim(return-value).
    {utp/ut-liter.i PAR¶METROS * r}
    assign c-lb-par = trim(return-value).
    {utp/ut-liter.i IMPRESSÇO * r}
    assign c-lb-imp = trim(return-value).
    {utp/ut-liter.i DIGITA€ÇO * r}
    assign c-lb-dig = trim(return-value).
    {utp/ut-liter.i DEPàSITOS * r}
    assign c-lb-dep = trim(return-value).

    page.

    hide all no-pause.

    view frame f-cabec.
    view frame f-rodape.

    put unformatted c-lb-par skip(1).

    assign l-param = tt-param.l-comprado.
    put c-compr    at 33 format "x(9)"  ": " l-param.
    assign l-param = tt-param.l-fabricado.
    put c-fabr     at 32 format "x(10)" ": " l-param.
    assign l-param = tt-param.l-planejada.
    put c-ord-pla  at 25 format "x(17)" ": " l-param.
    assign l-param = tt-param.l-ord-com.
    put c-ord-com  at 26 format "x(16)" ": " l-param.
    assign l-param = tt-param.l-ord-prod.
    put c-ord-pro  at 24 format "x(18)" ": " l-param.
    assign l-param = tt-param.l-res-com.
    put c-res-com  at 20 format "x(22)" ": " l-param.
    assign l-param = tt-param.l-res-pla.
    put c-res-pla  at 23 format "x(19)" ": " l-param.
    assign l-param = tt-param.l-sld-est.
    put c-sld-est  at 25 format "x(17)" ": " l-param.
    assign l-param = tt-param.l-sld-ter.
    put c-sld-ter  at 14 format "x(28)" ": " l-param.
    assign l-param = tt-param.l-remessa.
    put c-remessa  at 51 format "x(28)" ": " l-param.
    assign l-param = tt-param.l-entrada.
    put c-entrada  at 51 format "x(28)" ": " l-param.
    assign l-param = tt-param.l-transfer.
    put c-transfer  at 51 format "x(28)" ": " l-param.
    assign l-param = tt-param.l-re-con.
    put c-re-con  at 51 format "x(28)" ": " l-param.
    assign l-param = tt-param.l-en-con.
    put c-en-con  at 51 format "x(28)" ": " l-param.
    assign l-param = tt-param.l-ped-crt.
    put c-ped-crt  at 23 format "x(19)" ": " l-param.
    assign l-param = tt-param.l-it-sem-mov.
    put c-it-mov   at 17 format "x(25)" ": " l-param.
    assign l-param = tt-param.l-componente.
    put c-comp     at 23 format "x(19)" ": " l-param.
    assign l-param = tt-param.l-comp-comp.
    put c-compr    at 51 format "x(9)"  ": " l-param.
    assign l-param = tt-param.l-comp-fabr.
    put c-fabr     at 50 format "x(10)" ": " l-param.
    assign l-param = tt-param.l-cred-aprov.
    put c-cred-apr at 5  format "x(37)" ": " l-param.
    assign l-param = tt-param.l-deposito.
    put c-inf-dep  at 25 format "x(17)" ": " l-param skip(1).


    if  tt-param.l-deposito then do:
        put unformatted c-lb-dep at 29 skip(1).
        for each tt-depositos:
            disp tt-depositos.cod-estabel at 30
                 tt-depositos.cod-depos
                 with stream-io no-box width 132 down frame f-depositos.
            down with frame f-depositos.
        end.
        put skip(1).
    end.

    &IF defined(bf_man_206b) &THEN
        if l-usa-unid-negoc then do:
            put unformatted
                    c-lb-plano   at 37 ": " tt-param.i-cod-plano
                    c-lb-obsol   at 34 ": " tt-param.c-obsoleto
                    c-lb-form    at 35 ": " tt-param.c-formato
                    c-lb-nivel   at 17 ": " tt-param.i-niveis
                    c-lb-corte   at 29 ": " tt-param.da-corte
                    c-lb-op      at 6  ": " tt-param.da-op-corte
                    c-lb-benef   at 15 ": " tt-param.c-beneficio
                    c-lb-tipo    at 38 ": " tt-param.c-tipo skip(1)
                    c-lb-sel     skip(1)
                    c-lb-tit[1]  at 5  skip(1)
                    c-lb-est[1]  at 10 ": " tt-param.c-estab-ini    "|<  >| " at 44 tt-param.c-estab-fim
                    c-lb-lin[1]  at 11 ": " tt-param.i-linha-ini    "|<  >| " at 44 tt-param.i-linha-fim
                    c-lb-item[1] at 21 ": " tt-param.c-item-ini     "|<  >| " at 44 tt-param.c-item-fim
                    c-lb-fam[1]  at 18 ": " tt-param.c-fami-ini     "|<  >| " at 44 tt-param.c-fami-fim
                    c-lb-plan[1] at 15 ": " tt-param.c-plan-ini     "|<  >| " at 44 tt-param.c-plan-fim
                    c-lb-ge[1]   at 12 ": " tt-param.i-ge-ini       "|<  >| " at 44 tt-param.i-ge-fim
                    c-lb-comp[1] at 16 ": " tt-param.c-comp-ini     "|<  >| " at 44 tt-param.c-comp-fim
                    c-lb-cod-unid-negoc[1] at 10 ": " tt-param.c-cod-unid-negoc-ini "|<  >| " at 44 tt-param.c-cod-unid-negoc-fim skip(1)
                    c-lb-tit[2]  at 5  skip(1)
                    c-lb-est[2]  at 10 ": " tt-param.c-ci-estab-ini "|<  >| " at 44 tt-param.c-ci-estab-fim
                    c-lb-lin[2]  at 11 ": " tt-param.i-ci-linha-ini "|<  >| " at 44 tt-param.i-ci-linha-fim
                    c-lb-item[2] at 21 ": " tt-param.c-ci-item-ini  "|<  >| " at 44 tt-param.c-ci-item-fim
                    c-lb-fam[2]  at 18 ": " tt-param.c-ci-fami-ini  "|<  >| " at 44 tt-param.c-ci-fami-fim
                    c-lb-plan[2] at 15 ": " tt-param.c-ci-plan-ini  "|<  >| " at 44 tt-param.c-ci-plan-fim
                    c-lb-ge[2]   at 12 ": " tt-param.i-ci-ge-ini    "|<  >| " at 44 tt-param.i-ci-ge-fim
                    c-lb-comp[2] at 16 ": " tt-param.c-ci-comp-ini  "|<  >| " at 44 tt-param.c-ci-comp-fim
                    c-lb-cod-unid-negoc[2] at 10 ": " tt-param.c-ci-cod-unid-negoc-ini "|<  >| " at 44 tt-param.c-ci-cod-unid-negoc-fim.
        end.
        else do:
    &ENDIF

        put unformatted
            c-lb-plano   at 37 ": " tt-param.i-cod-plano
            c-lb-obsol   at 34 ": " tt-param.c-obsoleto
            c-lb-form    at 35 ": " tt-param.c-formato
            c-lb-nivel   at 17 ": " tt-param.i-niveis
            c-lb-corte   at 29 ": " tt-param.da-corte
            c-lb-op      at 6  ": " tt-param.da-op-corte
            c-lb-benef   at 15 ": " tt-param.c-beneficio
            c-lb-tipo    at 38 ": " tt-param.c-tipo skip(1)
            c-lb-sel     skip(1)
            c-lb-tit[1]  at 5  skip(1)
            c-lb-est[1]  at 10 ": " tt-param.c-estab-ini    "|<  >| " at 44 tt-param.c-estab-fim
            c-lb-lin[1]  at 11 ": " tt-param.i-linha-ini    "|<  >| " at 44 tt-param.i-linha-fim
            c-lb-item[1] at 21 ": " tt-param.c-item-ini     "|<  >| " at 44 tt-param.c-item-fim
            c-lb-fam[1]  at 18 ": " tt-param.c-fami-ini     "|<  >| " at 44 tt-param.c-fami-fim
            c-lb-plan[1] at 15 ": " tt-param.c-plan-ini     "|<  >| " at 44 tt-param.c-plan-fim
            c-lb-ge[1]   at 12 ": " tt-param.i-ge-ini       "|<  >| " at 44 tt-param.i-ge-fim
            c-lb-comp[1] at 16 ": " tt-param.c-comp-ini     "|<  >| " at 44 tt-param.c-comp-fim skip(1)
            c-lb-tit[2]  at 5  skip(1)
            c-lb-est[2]  at 10 ": " tt-param.c-ci-estab-ini "|<  >| " at 44 tt-param.c-ci-estab-fim
            c-lb-lin[2]  at 11 ": " tt-param.i-ci-linha-ini "|<  >| " at 44 tt-param.i-ci-linha-fim
            c-lb-item[2] at 21 ": " tt-param.c-ci-item-ini  "|<  >| " at 44 tt-param.c-ci-item-fim
            c-lb-fam[2]  at 18 ": " tt-param.c-ci-fami-ini  "|<  >| " at 44 tt-param.c-ci-fami-fim
            c-lb-plan[2] at 15 ": " tt-param.c-ci-plan-ini  "|<  >| " at 44 tt-param.c-ci-plan-fim
            c-lb-ge[2]   at 12 ": " tt-param.i-ci-ge-ini    "|<  >| " at 44 tt-param.i-ci-ge-fim
            c-lb-comp[2] at 16 ": " tt-param.c-ci-comp-ini  "|<  >| " at 44 tt-param.c-ci-comp-fim.
    
    &IF defined(bf_man_206b) &THEN
        end.
    &ENDIF
    
    if  line-counter > 40 then page.
    put unformatted
        c-lb-cla     skip(1)   tt-param.c-classe at 5 skip(1)
        c-lb-imp     skip(1)
        c-lb-dest    at 5 ": " tt-param.c-destino " - " tt-param.arquivo
        c-lb-usuar   at 5 ": " tt-param.usuario.

    if  can-find(first tt-digita where not tt-digita.l-dep) then
        put unformatted skip(1) c-lb-dig skip(1).

    for each tt-digita where not tt-digita.l-dep NO-LOCK:
        disp tt-digita.c-it-codigo at 5
             tt-digita.c-cod-refer
             tt-digita.c-desc-item
             tt-digita.c-un
             tt-digita.fm-codigo
             tt-digita.cd-planejado
             tt-digita.ge-codigo
             with stream-io no-box width 132 down frame f-digita.
        down with frame f-digita.
    end.
end.

&IF DEFINED(bf_man_206b) &THEN
    if l-usa-unid-negoc then
        IF VALID-HANDLE(h-cdapi024) THEN DO:
                    DELETE PROCEDURE h-cdapi024.
                    ASSIGN h-cdapi024 = ?.
        END.
&endif

run pi-finalizar in h-acomp.

&IF defined (bf_man_per_ppm) &THEN
    IF VALID-HANDLE(h-cpapi020) THEN
        DELETE PROCEDURE h-cpapi020.
&ENDIF

{include/i-rpclo.i}


OUTPUT STREAM str-excel CLOSE.         


CREATE "Excel.Application":U chExcel CONNECT NO-ERROR.
IF ERROR-STATUS:ERROR THEN CREATE "Excel.Application":U chExcel NO-ERROR.

    
IF NOT ERROR-STATUS:ERROR THEN
DO:
    ASSIGN chArquivo     = chExcel:WorkBooks:Open(c-excel).
    ASSIGN chPlanilhaMod = chArquivo:Sheets:Item(1).
    chPlanilhaMod:Activate().
    
    ASSIGN chExcel:VISIBLE     = TRUE
           chExcel:WindowState = 3.
    
    RELEASE OBJECT chExcel       NO-ERROR.
    RELEASE OBJECT chArquivo     NO-ERROR.
    RELEASE OBJECT chPlanilhaMod NO-ERROR.             
END.

return "ok".

/****************************************************************************************/

PROCEDURE pi-cria-tt-ord-res:

   DEFINE INPUT  PARAMETER p-ordem AS INTEGER    NO-UNDO.

   FIND FIRST tt-ord-res WHERE
              tt-ord-res.nr-ord-produ = p-ordem NO-ERROR.

   IF  NOT AVAIL tt-ord-res THEN DO:
       for first ord-prod fields (it-codigo   dt-termino   cod-estabel   cod-depos
                                  qt-ordem    qt-produzida estado        nr-ord-produ
                                  nr-pedido) where
                 ord-prod.nr-ord-produ = p-ordem NO-LOCK:

           CREATE tt-ord-res.
           ASSIGN tt-ord-res.nr-ord-produ = ord-prod.nr-ord-produ
                  tt-ord-res.cod-estabel  = ORD-PROD.COD-ESTABEL
                  tt-ord-res.estado       = ord-prod.estado
                  tt-ord-res.it-codigo    = ord-prod.it-codigo.
       END.
   END.

END PROCEDURE.

