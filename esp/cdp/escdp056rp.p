/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i escdp056RP 2.00.00.015 } /*** 010015 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i escdp056rp MCD}
&ENDIF

{include/i_fnctrad.i}


/******************************************************************************
**  Programa: escdp056RP.P
**  Data....: 21/12/2015
**  Autor...: DATASUL S.A.
**  Objetivo: Listagem de Naturezas de Opera‡Æo
******************************************************************************/
{utp/ut-glob.i}
{cdp/cdcfgdis.i}
{include/tt-edit.i} /* para impressÆo da narrativa do item */


define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char    format "x(40)"
    field usuario          as char    format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field c-nat-operacao-ini       as char    format "x(6)"
    field c-nat-operacao-fim       as char    format "x(6)".

/* Transfer Definitions */
DEFINE VARIABLE c-cd-trib-icm    AS CHARACTER FORMAT "x(10)"  NO-UNDO.
DEFINE VARIABLE c-cd-trib-ipi    AS CHARACTER FORMAT "x(10)"  NO-UNDO.
DEFINE VARIABLE c-cd-trib-pis    AS CHARACTER FORMAT "x(10)"  NO-UNDO.
DEFINE VARIABLE c-cd-trib-cofins AS CHARACTER FORMAT "x(10)"  NO-UNDO.
DEFINE VARIABLE c-tipo  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-ativo AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-terceiros AS CHARACTER FORMAT "x(25)"  NO-UNDO.
DEFINE VARIABLE gera-ficha-auto AS LOGICAL.
DEFINE VARIABLE ini-cred-auto AS LOGICAL.
DEFINE VARIABLE mensag-desc LIKE mensagem.texto-mensag NO-UNDO.

def temp-table tt-raw-digita
   field raw-digita      as raw.

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

/* include padrÆo para vari veis de relat¢rio */
{include/i-rpvar.i}

/* vari veis da tela de parƒmetros */


/* vari veis das descri‡äes dos folders */
DEFINE VARIABLE h-programa AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-narrativa AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-bodi465 AS HANDLE       NO-UNDO. 
{utp/ut-liter.i Listagem_Naturezas_de_Operacao * }
assign c-programa     = "escdp056"
       c-versao       = "1.00"
       c-revisao      = "000"
       c-titulo-relat = RETURN-VALUE
       c-sistema      = "".

/* Include com a defini‡Æo da frame de Cabe‡alho e Rodap‚ */
{include/i-rpout.i}
{include/i-rpcab.i}

run utp/ut-acomp.p persistent set h-programa.
run pi-inicializar in h-programa (input c-titulo-relat).
    PUT "Natureza" ";"
        "Denominacao"  ";"
        "Tipo"         ";"
        "Situacao" ";"
        "CFOP"     ";"
        "Aliq.ICM" ";"
        "Cd.Trib. ICM"           ";"
        "Cd.Trib. IPI"           ";"
        "Narrativa "   ";"
        "Baixa Estoq"  ";"
        "Emite Dupl." ";"
        "Gera OF"  ";"
        "Cd Trib PIS"           ";"
        "Cd Trib COFINS"        ";" 
        "Terceiros"           " ;"
        "Tipo Oper Terceiros " ";"
        "Dias Advertencia"     ";"
        "Prazo Retorno"        ";"
        "% Red.ICMS"           ";"
        "Averb. Seguro"        ";"
        "Compra/VendaAtivo"    ";" 
        "Gera Ficha Auto"      ";"
        "Ini Credito Auto"     ";"
        "MRI N trib coef CIAP" ";"
        "MRI coef CIAP"        ";"
        "Destino Red"          ";" //novo
        "Consum Final"         ";"
        "Item ICMS Susp"       ";"
        "ICMS Presumido"       ";"
        "Item ICMS Diferido"   ";"
        "Nao Tribut ICMS"      ";"
        "Isencao Parcial ICMS" ";"
        "Gera nota Faturamento" ";"
        "Codigo Mensagem"       ";"
        "Descricao Mensagem"
        SKIP.
FOR EACH natur-oper NO-LOCK
    WHERE natur-oper.nat-operacao >= tt-param.c-nat-operacao-ini
      AND natur-oper.nat-operacao <= tt-param.c-nat-operacao-fim:

    run pi-acompanhar in h-programa (input "Natureza Lida:":U + Natur-oper.Nat-operacao).

    IF natur-oper.tipo = 1 THEN
       ASSIGN c-tipo = "Entrada".
    ELSE
        IF natur-oper.tipo = 2 THEN
           ASSIGN c-tipo = "Saida".
        ELSE
            IF natur-oper.tipo = 3 THEN
               ASSIGN c-tipo = "Servico".

    IF natur-oper.nat-ativa THEN
        ASSIGN c-ativo = "Ativa".
    ELSE
        ASSIGN c-ativo = "Inativa".

    ASSIGN c-cd-trib-icm    = TRIM({ininc/i01in245.i 04 natur-oper.cd-trib-icm})
           c-cd-trib-ipi    = TRIM({ininc/i10in172.i 04 natur-oper.cd-trib-ipi}).

    IF  SUBSTRING(natur-oper.char-1,86,1) = "1" THEN
        ASSIGN c-cd-trib-pis = "Tributado".
    ELSE
        IF SUBSTRING(natur-oper.char-1,86,1) = "2" THEN
           ASSIGN c-cd-trib-pis = "Isento".
        ELSE
            IF SUBSTRING(natur-oper.char-1,86,1) = "3"  THEN
               ASSIGN c-cd-trib-pis = "Reduzido".

    IF  SUBSTRING(natur-oper.char-1,87,1) = "1" THEN
        ASSIGN c-cd-trib-cofins = "Tributado".
    ELSE
        IF SUBSTRING(natur-oper.char-1,87,1) = "2" THEN
           ASSIGN c-cd-trib-cofins = "Isento".
        ELSE
            IF SUBSTRING(natur-oper.char-1,87,1) = "3"  THEN
               ASSIGN c-cd-trib-cofins = "Reduzido".

    ASSIGN c-narrativa = natur-oper.narrativa.
    RUN RetiraAcentos (INPUT-OUTPUT c-narrativa).
    ASSIGN c-terceiros = "".
    IF natur-oper.terceiros THEN
       IF natur-oper.tp-oper-terc = 1 THEN
           ASSIGN c-terceiros = "Remessa Beneficiamento".
       ELSE
           IF natur-oper.tp-oper-terc = 2 THEN
               ASSIGN c-terceiros = "Retorno Beneficiamento".
           ELSE
               IF natur-oper.tp-oper-terc = 3 THEN
                   ASSIGN c-terceiros = "Remessa Consigna‡Æo".
               ELSE
                   IF natur-oper.tp-oper-terc = 4 THEN
                       ASSIGN c-terceiros = "Faturamento Consigna‡Æo".
                   ELSE
                       IF natur-oper.tp-oper-terc = 5 THEN
                           ASSIGN c-terceiros = "Devolu‡Æo Consigna‡Æo".
                       ELSE
                           IF natur-oper.tp-oper-terc = 6 THEN
                               ASSIGN c-terceiros = "Reajuste Pre‡o".

    FIND FIRST int-natur-oper NO-LOCK
         WHERE int-natur-oper.nat-operacao = natur-oper.nat-operacao NO-ERROR.

    RUN dibo/bodi465.p PERSISTENT SET h-bodi465.

    RUN pi-retornaIniCredAuto IN h-bodi465 (INPUT  natur-oper.nat-operacao,
                                            OUTPUT gera-ficha-auto,
                                            OUTPUT ini-cred-auto).

    IF VALID-HANDLE (h-bodi465) THEN
        DELETE PROCEDURE h-bodi465.

    FIND FIRST mensagem
         WHERE mensagem.cod-mensagem = natur-oper.cod-mensagem NO-LOCK NO-ERROR.

    PUT natur-oper.nat-operacao ";"
        natur-oper.denominacao  ";"
        c-tipo                  ";"
        c-ativo                 ";"
        natur-oper.cod-cfop     ";"
        natur-oper.aliquota-icm ";"
        c-cd-trib-icm           ";"
        c-cd-trib-ipi           ";"
        c-narrativa  FORMAT "x(50)"   ";"
        natur-oper.baixa-estoq  ";"
        natur-oper.emite-duplic ";"
        natur-oper.ind-gera-of  ";"
        c-cd-trib-pis           ";"
        c-cd-trib-cofins        ";"
        natur-oper.terceiros    ";"
        c-terceiros             ";".

    IF AVAIL int-natur-oper THEN DO:
        PUT int-natur-oper.dias-advertencia ";"
            int-natur-oper.dias-legislacao  ";".
    END.
    ELSE
        PUT ";;".

    PUT natur-oper.perc-red-icm ";".

    IF AVAIL int-natur-oper THEN
        PUT STRING(int-natur-oper.cons-averb-seg,"Sim/Nao") ";".
    ELSE PUT ";".
    
    PUT 
        STRING(natur-oper.venda-ativo,"Sim/Nao")     ";"
        STRING(gera-ficha-auto,"Sim/Nao")            ";"
        STRING(ini-cred-auto,"Sim/Nao")              ";"
        STRING(natur-oper.credito-ciap,"Sim/Nao")    ";"
        STRING(natur-oper.log-acum-ciap,"Sim/Nao")   ";".

    PUT IF natur-oper.dec-2 = 1 then {varinc/var00071.i 04 1} else {varinc/var00071.i 04 2} ";"
        STRING(natur-oper.consum-final,"Sim/Nao")     ";"
        //STRING(natur-oper.ind-it-sub-dif,"Sim/Nao")   ";"
        if natur-oper.ind-it-sub-dif = YES THEN "Sim" else "Nao" ";"
        STRING(natur-oper.log-icms-presmdo,"Sim/Nao") ";"
        if natur-oper.ind-it-sub-dif = ? THEN "Sim" else "Nao" ";"
        STRING(natur-oper.ind-tipo-vat,"Sim/Nao") ";"
        IF substring(natur-oper.char-1,179,1) = "1" THEN "Sim" ELSE "Nao" ";"
        STRING(natur-oper.imp-nota,"Sim/Nao") ";".

    IF AVAIL mensagem THEN DO:

        ASSIGN mensag-desc = mensagem.texto-mensag.

        ASSIGN mensag-desc = REPLACE(mensag-desc,CHR(13),"")
               mensag-desc = REPLACE(mensag-desc,CHR(10),"")
               mensag-desc = TRIM(REPLACE(mensag-desc,";"," ")). 

        PUT STRING(natur-oper.cod-mensagem) ";"
                   mensag-desc.
    END.
    ELSE 
        PUT ";;". 
        
    PUT SKIP.

END.


/* Fechamento do output do Relat¢rio */
{include/i-rpclo.i}

run pi-finalizar in h-programa.

/**************** PROCEDURES INTERNAS **************************/

PROCEDURE RetiraAcentos:

    DEF INPUT-OUTPUT PARAMETER c-texto AS CHAR.
    DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-caracter AS CHARACTER   NO-UNDO.
    

    DO i-cont = 1 TO LENGTH(c-texto):
        ASSIGN c-caracter = SUBSTRING(c-texto,i-cont,1).
        CASE trim(c-caracter):
           when "a" THEN next.
           when "b" THEN next.
           when "c" THEN next.
           when "d" THEN next.
           when "e" THEN next.
           when "f" THEN next.
           when "g" THEN next.
           when "h" THEN next.
           when "i" THEN next.
           when "j" THEN next.
           when "k" THEN next.
           when "l" THEN next.
           when "m" THEN next.
           when "n" THEN next.
           when "o" THEN next.
           when "p" THEN next.
           when "q" THEN next.
           when "r" THEN next.
           when "s" THEN next.
           when "t" THEN next.
           when "u" THEN next.
           when "v" THEN next.
           when "w" THEN next.
           when "x" THEN next.
           when "y" THEN next.
           when "z" THEN next.
           when " " THEN next.
           when "0" THEN next.
           when "1" THEN next.
           when "2" THEN next.
           when "3" THEN next.
           when "4" THEN next.
           when "5" THEN next.
           when "6" THEN next.
           when "7" THEN next.
           when "8" THEN next.
           when '9' THEN next.
           /*when '"' THEN next.*/
           when "'" THEN next.
           when "!" THEN next.
           when "[" THEN next.
           when "]" THEN next.
           when "@" THEN next.
           when "#" THEN next.
           when "$" THEN next.
           when "%" THEN next.
           when "&" THEN next.
           when "*" THEN next.
           when "(" THEN next.
           when ")" THEN next.
           when "-" THEN next.
           when "_" THEN next.
           when "=" THEN next.
           when "+" THEN next.
           when "<" THEN next.
           when ">" THEN next.
           when "," THEN next.
           when "." THEN next.
           when ":" THEN next.
           /*when ";" THEN next.*/
           when "?" THEN next.
           when "/" THEN next.
           when "~\" THEN next.
           OTHERWISE ASSIGN OVERLAY(c-texto,i-cont,1) = "".
       END.
    END.

    ASSIGN c-texto = REPLACE(c-texto,CHR(10)," ")
           c-texto = REPLACE(c-texto,CHR(11)," ")
           c-texto = REPLACE(c-texto,CHR(12)," ")
           c-texto = REPLACE(c-texto,CHR(13)," ").



END PROCEDURE.
