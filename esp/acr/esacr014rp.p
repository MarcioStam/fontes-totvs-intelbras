/*****************************************************************************
**     Programa.........: esp/acr/esacr014rp.p
**     Descricao .......: Titulos em aberto por emitente
**     Versao...........: 1.00.000
**     Autor............: Anderson Silvano
**     Criado...........: 12/05/2004
**     Desc. Atualiza‡Æo: 
**     Autor............: 
*******************************************************************************/
{include/i-prgvrs.i esacr014rp 1.00.00.000}

{utp/ut-glob.i}
{include/i-rpvar.i}    
{esp/acr/esacr014tt.i}
{esp/acr/esacr014rp.i} /* Carga de Parƒmetros de emissÆo do relat¢rio */
{esp/acr/esacr016tt.i}
{utp/utapi019.i} /* Temp-table para envio de e-mail */ 

def input parameter  raw-param as raw no-undo.
def input parameter  table for tt-raw-digita.

/****************** Defini‡ao de Vari veis de Processamento do Relat¢rio *********************/
DEF VAR d-saldo                 LIKE tit_acr.val_sdo_tit_acr FORMAT ">>>>,>>9.99" NO-UNDO.
DEF VAR d-saldoc                LIKE tit_acr.val_sdo_tit_acr FORMAT ">>>>,>>9.99" NO-UNDO.
DEF VAR d-credito               like tit_acr.val_sdo_tit_acr FORMAT ">>>,>>9.99" NO-UNDO.
DEF VAR c-mensagem                AS CHAR FORMAT "x(2000)"       NO-UNDO.
DEF VAR l-tem                     AS LOG                         NO-UNDO.
DEF VAR da-atraso                 AS INT FORMAT "->>>9"          NO-UNDO.
DEF VAR c-email                 LIKE cont-emit.e-mail            NO-UNDO.
DEF VAR c-email-cc                AS CHAR                        NO-UNDO.
DEF VAR c-msg                     AS CHAR FORMAT "X(50)"         NO-UNDO.
def var t-ve-a                    as dec  format ">>,>>>,>>9.99" NO-UNDO.       
def var t-ve-b                    as dec  format ">>,>>>,>>9.99" NO-UNDO.    
def var t-ve-c                    as dec  format ">>,>>>,>>9.99" NO-UNDO.   
def var t-ve-d                    as dec  format ">>,>>>,>>9.99" NO-UNDO.    
def var t-ve-e                    as dec  format ">>,>>>,>>9.99" NO-UNDO.   
def var t-ve-f                    as dec  format ">>,>>>,>>9.99" NO-UNDO.      
DEF VAR t-ve-g                    AS DEC  FORMAT ">>,>>>,>>9.99" NO-UNDO.
def var t-av-a                    as dec  format ">>,>>>,>>9.99" NO-UNDO.       
def var t-av-b                    as dec  format ">>,>>>,>>9.99" NO-UNDO.    
def var t-av-c                    as dec  format ">>,>>>,>>9.99" NO-UNDO.    
def var t-av-d                    as dec  format ">>,>>>,>>9.99" NO-UNDO.       
DEF VAR t-av-e                    AS DEC  FORMAT ">>,>>>,>>9.99" NO-UNDO.
DEF VAR t-av-f                    AS DEC  FORMAT ">>,>>>,>>9.99" NO-UNDO.
DEF VAR t-av-g                    AS DEC  FORMAT ">>,>>>,>>9.99" NO-UNDO.
def var t-total                   as dec  format ">>,>>>,>>9.99" NO-UNDO.
DEF VAR c-cod-nota-devol          LIKE nota_devol_tit_acr.cod_nota_devol NO-UNDO.
DEF VAR c-tabela                  AS CHAR NO-UNDO.

DEFINE BUFFER b_tit_acr FOR tit_acr.

DEFINE VARIABLE c-situacao-titulo AS CHARACTER   NO-UNDO.    
DEFINE VARIABLE h-acomp           AS HANDLE      NO-UNDO.
                       
/**********************************************************************************/

FUNCTION fnformata RETURNS CHARACTER
  ( c-campo AS CHAR,
    i-tam   AS INT,
    c-pos   AS CHAR)  FORWARD.

EMPTY TEMP-TABLE tt-emitente.
EMPTY TEMP-TABLE tt-portador.
EMPTY TEMP-TABLE tt-digita.
EMPTY TEMP-TABLE tt-param.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

{include/i-rpout.i}

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Inicializando...").

FOR EACH tt-digita:

    RUN pi-acompanhar IN h-acomp (INPUT "Gerando Parƒmetros...").

    IF  tt-digita.l-portador = NO
    THEN DO:
        CREATE tt-emitente.
        BUFFER-COPY tt-digita TO tt-emitente.
    END.
    ELSE DO:
        CREATE tt-portador.
        ASSIGN tt-portador.cod_portador  = tt-digita.cod_portador
               tt-portador.cod_cart_bcia = tt-digita.cod_cart_bcia.
    END.
END.

IF  l-ve-a AND
    l-av-a
THEN
    ASSIGN c-situacao-titulo = "vencidos e a vencer".
ELSE
    IF  l-ve-a
    THEN
        ASSIGN c-situacao-titulo = "vencidos".
    ELSE
        ASSIGN c-situacao-titulo = "a vencer".

FOR EACH tt-emitente:

    RUN pi-acompanhar IN h-acomp (INPUT "Totalizando Clientes...").

    ASSIGN tt-emitente.TOTAL = 0.
    IF l-ve-a THEN ASSIGN tt-emitente.TOTAL = tt-emitente.TOTAL + tt-emitente.ve-a.
    IF l-ve-b THEN ASSIGN tt-emitente.TOTAL = tt-emitente.TOTAL + tt-emitente.ve-b.
    IF l-ve-c THEN ASSIGN tt-emitente.TOTAL = tt-emitente.TOTAL + tt-emitente.ve-c.
    IF l-ve-d THEN ASSIGN tt-emitente.TOTAL = tt-emitente.TOTAL + tt-emitente.ve-d.
    IF l-ve-e THEN ASSIGN tt-emitente.TOTAL = tt-emitente.TOTAL + tt-emitente.ve-e.
    IF l-ve-f THEN ASSIGN tt-emitente.TOTAL = tt-emitente.TOTAL + tt-emitente.ve-f.
    IF l-ve-g THEN ASSIGN tt-emitente.TOTAL = tt-emitente.TOTAL + tt-emitente.ve-g.
    IF l-av-a THEN ASSIGN tt-emitente.TOTAL = tt-emitente.TOTAL + tt-emitente.av-a.
    IF l-av-b THEN ASSIGN tt-emitente.TOTAL = tt-emitente.TOTAL + tt-emitente.av-b.
    IF l-av-c THEN ASSIGN tt-emitente.TOTAL = tt-emitente.TOTAL + tt-emitente.av-c.
    IF l-av-d THEN ASSIGN tt-emitente.TOTAL = tt-emitente.TOTAL + tt-emitente.av-d.
    IF l-av-e THEN ASSIGN tt-emitente.TOTAL = tt-emitente.TOTAL + tt-emitente.av-e.
    IF l-av-f THEN ASSIGN tt-emitente.TOTAL = tt-emitente.TOTAL + tt-emitente.av-f.
    IF l-av-g THEN ASSIGN tt-emitente.TOTAL = tt-emitente.TOTAL + tt-emitente.av-g.
END.

RUN pi-acompanhar IN h-acomp (INPUT "Gerando Relat¢rio...").

RUN piImprimeRelat.  /* Imprime relat¢rio em formato padrÆo EMS 5 */

RUN pi-acompanhar IN h-acomp (INPUT "Enviando Email...").

IF  l-email
THEN DO:
    /*RUN utp/utapi019.p PERSISTENT SET h-utapi019.*/
    RUN pi-envia-email.

    /*
    IF  VALID-HANDLE(h-utapi019) 
    THEN 
        DELETE PROCEDURE h-utapi019.

    ASSIGN h-utapi019 = ?.
    */
END.
    
RUN pi-finalizar IN h-acomp.

IF  tt-param.destino = 3 
THEN 
    RUN pi-abre-edit (INPUT tt-param.arquivo).

{include/i-rpclo.i}



RETURN "OK".

/* fim do programa */

PROCEDURE pi-trata-erro-utapi019:
    RETURN "OK".
END.


PROCEDURE pi-envia-email:

    DEFINE VARIABLE i-sequencia  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE diferenca    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE l-enviar-nfd AS LOG        NO-UNDO.

    FOR EACH tt-emitente 
       WHERE tt-emitente.mail
          OR tt-emitente.mail-ger
          OR tt-emitente.mail-rep
          OR tt-emitente.mail-cont,
        FIRST emitente NO-LOCK 
        WHERE emitente.cod-emitente = tt-emitente.cod-emitente:

        ASSIGN l-enviar-nfd = NO.

        RUN pi-acompanhar IN h-acomp (INPUT "Enviando Email Cliente: " + STRING(tt-emitente.cod-emitente)).

        RUN utp/utapi019.p PERSISTENT SET h-utapi019.
    
        FOR EACH tt-saldo:
            DELETE tt-saldo.
        END.

        run esp/acr/esacr014rpa.p (INPUT  tt-emitente.cod-emitente,
                                   OUTPUT d-saldo  ,
                                   OUTPUT d-saldoc ,
                                   OUTPUT d-credito,
                                   OUTPUT TABLE tt-saldo,
                                   INPUT  TABLE tt-portador).

        FIND FIRST mgcad.empresa NO-LOCK.

        ASSIGN c-narrativa-ini = REPLACE(c-narrativa-ini,"|",CHR(13))
               c-narrativa-fim = REPLACE(c-narrativa-fim,"|",CHR(13)).


        IF  rs-docto <> 2 THEN 
            ASSIGN c-mensagem = empresa.razao-social      + CHR(13) + CHR(13) +
                                "Departamento Financeiro" + CHR(13) + CHR(13).
        ELSE
            ASSIGN c-mensagem   = empresa.razao-social    + CHR(13) + CHR(13) +
                                "Financial Department"    + CHR(13) + CHR(13).
                       
        IF  rs-docto = 3 THEN DO:
            IF cod-mensagem-ini <> "" THEN DO:
               FIND msg_financ NO-LOCK 
                   WHERE msg_financ.cod_mensagem = cod-mensagem-ini NO-ERROR.
               IF  AVAIL msg_financ THEN
                   ASSIGN c-mensagem = c-mensagem + msg_financ.des_mensagem + CHR(13) +  CHR(13). 
            END.

            if c-narrativa-ini <> "" then 
                ASSIGN c-mensagem = c-mensagem + c-narrativa-ini + CHR(13) + CHR(13).
        END.
        ELSE DO:
            IF cod-mensagem-ini <> "" THEN DO:
               FIND msg_financ NO-LOCK 
                   WHERE msg_financ.cod_mensagem = cod-mensagem-ini NO-ERROR.
               IF AVAIL msg_financ THEN
                   ASSIGN c-mensagem = c-mensagem + msg_financ.des_mensagem + CHR(13) + CHR(13). 
            END.

            if c-narrativa-ini <> "" then 
                ASSIGN c-mensagem = c-mensagem + c-narrativa-ini + CHR(13) + CHR(13).
        END.
        
        CASE rs-docto:
            /* NF */
            WHEN 1 THEN DO:
                ASSIGN c-mensagem = c-mensagem + STRING(emitente.cod-emitente) + " - " + emitente.nome-emit + CHR(13) + CHR(13) +
                                    "Documento       EmissÆo         Vencto                Vl Cliente" + CHR(13).

                ASSIGN l-tem = no.
                FOR EACH tt-saldo:

                    /* ** Filtra t¡tulos conforme sele‡Æo de faixas de datas informada ***/
                    ASSIGN diferenca = (TODAY - tt-saldo.dat_vencto_tit_acr).

                    IF (l-ve-a AND (diferenca > 0           AND diferenca <= fx-vea-fim))
                    OR (l-ve-b AND (diferenca >= fx-veb-ini AND diferenca <= fx-veb-fim))
                    OR (l-ve-c AND (diferenca >= fx-vec-ini AND diferenca <= fx-vec-fim))
                    OR (l-ve-d AND (diferenca >= fx-ved-ini AND diferenca <= fx-ved-fim))
                    OR (l-ve-e AND (diferenca >= fx-vee-ini AND diferenca <= fx-vee-fim))
                    OR (l-ve-f AND (diferenca >= fx-vef-ini AND diferenca <= fx-vef-fim))
                    OR (l-ve-g AND (diferenca >= fx-veg-ini                            )) 

                    OR (l-av-a AND (diferenca <= 0                 AND diferenca >= (fx-ava-fim * -1)))
                    OR (l-av-b AND (diferenca <= (fx-avb-ini * -1) AND diferenca >= (fx-avb-fim * -1)))
                    OR (l-av-c AND (diferenca <= (fx-avc-ini * -1) AND diferenca >= (fx-avc-fim * -1))) 
                    OR (l-av-d AND (diferenca <= (fx-avd-ini * -1) AND diferenca >= (fx-avd-fim * -1))) 
                    OR (l-av-e AND (diferenca <= (fx-ave-ini * -1) AND diferenca >= (fx-ave-fim * -1))) 
                    OR (l-av-f AND (diferenca <= (fx-avf-ini * -1) AND diferenca >= (fx-avf-fim * -1))) 
                    OR (l-av-g AND (diferenca <= (fx-avg-ini * -1)                                   )) THEN DO:

                        /* ** Fim do Filtro de datas ***/

                        ASSIGN da-atraso = TODAY - tt-saldo.dat_vencto_tit_acr
                               l-tem     = YES.

                        ASSIGN c-mensagem = c-mensagem + 
                               trim(string(tt-saldo.cod_tit_acr, "X(10)")) + "/" + trim(string(tt-saldo.cod_parcela, "x(3)")) + fill(" ",06) +
                               string(tt-saldo.dat_emis_docto, "99/99/9999") + fill(" ",06) +
                               string(tt-saldo.dat_vencto_tit_acr, "99/99/9999" ) + fill(" ",8) + string(tt-saldo.val_sdo_tit_acr,">>,>>>,>>9.99") + CHR(13).
                    END.

                END.

                ASSIGN c-mensagem = c-mensagem + CHR(13) + "Total do Cliente: " + STRING(d-saldoc,">>,>>>,>>9.99") + CHR(13) + CHR(13) + CHR(13)
                       c-msg = "A/C Contas a Pagar - " + STRING(emitente.nome-emit).

            END.


            /* FATURA */
            WHEN 2 THEN DO:
                ASSIGN c-mensagem = c-mensagem + STRING(emitente.cod-emitente) + " - " + emitente.nome-emit             + CHR(13) + CHR(13) +
                                   "INVOICE      DATE     USD AMOUNT"    + CHR(13) +
                                   "------------ -------- -------------" + CHR(13).
                ASSIGN l-tem    = no
                       d-saldoc = 0.
                FOR EACH tt-saldo:

                    /* ** Filtra t¡tulos conforme sele‡Æo de faixas de datas informada ***/
                    ASSIGN diferenca = (TODAY - tt-saldo.dat_vencto_tit_acr).

                    IF (l-ve-a AND (diferenca > 0           AND diferenca <= fx-vea-fim))
                    OR (l-ve-b AND (diferenca >= fx-veb-ini AND diferenca <= fx-veb-fim))
                    OR (l-ve-c AND (diferenca >= fx-vec-ini AND diferenca <= fx-vec-fim))
                    OR (l-ve-d AND (diferenca >= fx-ved-ini AND diferenca <= fx-ved-fim))
                    OR (l-ve-e AND (diferenca >= fx-vee-ini AND diferenca <= fx-vee-fim))
                    OR (l-ve-f AND (diferenca >= fx-vef-ini AND diferenca <= fx-vef-fim))
                    OR (l-ve-g AND (diferenca >= fx-veg-ini                            )) 

                    OR (l-av-a AND (diferenca <= 0                 AND diferenca >= (fx-ava-fim * -1)))
                    OR (l-av-b AND (diferenca <= (fx-avb-ini * -1) AND diferenca >= (fx-avb-fim * -1)))
                    OR (l-av-c AND (diferenca <= (fx-avc-ini * -1) AND diferenca >= (fx-avc-fim * -1))) 
                    OR (l-av-d AND (diferenca <= (fx-avd-ini * -1) AND diferenca >= (fx-avd-fim * -1))) 
                    OR (l-av-e AND (diferenca <= (fx-ave-ini * -1) AND diferenca >= (fx-ave-fim * -1))) 
                    OR (l-av-f AND (diferenca <= (fx-avf-ini * -1) AND diferenca >= (fx-avf-fim * -1))) 
                    OR (l-av-g AND (diferenca <= (fx-avg-ini * -1)                                   )) THEN DO:

                    /* ** Fim do Filtro de datas ***/
                        ASSIGN l-tem     = YES.
                        FIND FIRST ped_vda_tit_acr NO-LOCK
                             WHERE ped_vda_tit_acr.cod_estab      = tt-saldo.cod_estab
                               AND ped_vda_tit_acr.num_id_tit_acr = tt-saldo.num_id_tit_acr NO-ERROR.

                        IF  AVAIL ped_vda_tit_acr THEN 
                            ASSIGN tt-saldo.cod_tit_acr = ped_vda_tit_acr.cod_ped_vda.

                        /* ** Para clientes extrangeiros, o valor apresentado ser  na moeda original ($) ***/
                        FIND FIRST tit_acr NO-LOCK
                             WHERE tit_acr.cod_estab      = tt-saldo.cod_estab
                               AND tit_acr.num_id_tit_acr = tt-saldo.num_id_tit_acr NO-ERROR.
                        IF  AVAIL tit_acr THEN  DO:
                            ASSIGN tt-saldo.val_sdo_tit_acr = tit_acr.val_sdo_tit_acr.

                            FIND FIRST nota-fiscal NO-LOCK
                                WHERE nota-fiscal.cod-estabel = tit_acr.cod_estab
                                  AND nota-fiscal.serie       = tit_acr.cod_ser
                                  AND nota-fiscal.nr-nota-fis = tit_acr.cod_tit_acr NO-ERROR.
                            IF  AVAIL nota-fiscal THEN DO:
                                FIND FIRST ped-venda NO-LOCK
                                    WHERE  ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                                      AND  ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-ERROR.
                                IF  AVAIL ped-venda THEN DO:
                                    FIND FIRST int-ped-venda NO-LOCK
                                        WHERE  int-ped-venda.cod-estabel = ped-venda.cod-estabel
                                          AND  int-ped-venda.nr-pedido   = ped-venda.nr-pedido NO-ERROR.
                                     IF  AVAIL int-ped-venda THEN
                                         ASSIGN tt-saldo.cod_tit_acr = TRIM(SUBSTRING(int-ped-venda.char-1,53,12)).
                                END.
                            END.
                            /* Fim - Pedido de Origem do Cliente */

                        END.
                        ASSIGN c-mensagem = c-mensagem + 
                                            STRING(tt-saldo.cod_tit_acr, "x(12)")            + " " +
                                            STRING(tt-saldo.dat_vencto_tit_acr,"99/99/99" )  + " " +
                                            STRING(tt-saldo.val_sdo_tit_acr,">>,>>>,>>9.99") + CHR(13).
                        ASSIGN d-saldoc = d-saldoc + tt-saldo.val_sdo_tit_acr.
                    END.
                END.
                ASSIGN c-mensagem = c-mensagem + "TOTAL   " + STRING(d-saldoc,">>,>>>,>>9.99") + CHR(13) + CHR(13) + CHR(13). 
                ASSIGN c-msg = "Collect Debts - " + STRING(emitente.nome-emit).

            END.
            
            
            /* NFD */
            WHEN 3 THEN DO:
                ASSIGN c-mensagem = c-mensagem + CHR(13) + STRING(emitente.cod-emitente) + " - " + emitente.nome-emit + CHR(13) + CHR(13).

                ASSIGN l-tem = no.


                ASSIGN c-tabela  = "NF Origem            NF Devol   EmissÆo    Valor" + CHR(13) +
                                    "-------------------- ---------- ---------- ----------------" + CHR(13).
                
                FOR EACH tt-saldo:

                    /* ** Filtra t¡tulos conforme sele‡Æo de faixas de datas informada ***/
                    ASSIGN diferenca = (TODAY - tt-saldo.dat_vencto_tit_acr)
                           c-cod-nota-devol = "".

                    IF (l-ve-a AND (diferenca > 0           AND diferenca <= fx-vea-fim))
                    OR (l-ve-b AND (diferenca >= fx-veb-ini AND diferenca <= fx-veb-fim))
                    OR (l-ve-c AND (diferenca >= fx-vec-ini AND diferenca <= fx-vec-fim))
                    OR (l-ve-d AND (diferenca >= fx-ved-ini AND diferenca <= fx-ved-fim))
                    OR (l-ve-e AND (diferenca >= fx-vee-ini AND diferenca <= fx-vee-fim))
                    OR (l-ve-f AND (diferenca >= fx-vef-ini AND diferenca <= fx-vef-fim))
                    OR (l-ve-g AND (diferenca >= fx-veg-ini                            )) 

                    OR (l-av-a AND (diferenca <= 0                 AND diferenca >= (fx-ava-fim * -1)))
                    OR (l-av-b AND (diferenca <= (fx-avb-ini * -1) AND diferenca >= (fx-avb-fim * -1)))
                    OR (l-av-c AND (diferenca <= (fx-avc-ini * -1) AND diferenca >= (fx-avc-fim * -1))) 
                    OR (l-av-d AND (diferenca <= (fx-avd-ini * -1) AND diferenca >= (fx-avd-fim * -1))) 
                    OR (l-av-e AND (diferenca <= (fx-ave-ini * -1) AND diferenca >= (fx-ave-fim * -1))) 
                    OR (l-av-f AND (diferenca <= (fx-avf-ini * -1) AND diferenca >= (fx-avf-fim * -1))) 
                    OR (l-av-g AND (diferenca <= (fx-avg-ini * -1)                                   )) THEN DO:

                        /* ** Fim do Filtro de datas ***/

                        ASSIGN da-atraso = TODAY - tt-saldo.dat_vencto_tit_acr
                               l-tem     = YES.

                        FIND FIRST nota_devol_tit_acr NO-LOCK 
                            WHERE nota_devol_tit_acr.cod_estab       = tt-saldo.cod_estab
                              AND nota_devol_tit_acr.cod_espec_docto = tt-saldo.cod_espec_docto
                              AND nota_devol_tit_acr.cod_ser_docto   = tt-saldo.cod_ser_docto
                              AND nota_devol_tit_acr.cod_tit_acr     = tt-saldo.cod_tit_acr
                              AND nota_devol_tit_acr.cod_parcela     = tt-saldo.cod_parcela NO-ERROR.

                        IF  AVAIL nota_devol_tit_acr THEN DO:
                            ASSIGN  c-cod-nota-devol = nota_devol_tit_acr.cod_nota_devol
                                    l-enviar-nfd     = YES.
                        END.
                        ELSE DO:
                            FOR FIRST movto_tit_acr FIELDS(cod_estab num_id_movto_tit_acr) NO-LOCK
                                WHERE movto_tit_acr.cod_estab      = tt-saldo.cod_estab
                                  AND movto_tit_acr.num_id_tit_acr = tt-saldo.num_id_tit_acr
                                  AND movto_tit_acr.ind_trans_acr  = "Implanta‡Æo a Cr‚dito":
                                FOR FIRST relacto_tit_acr FIELDS(cod_estab num_id_tit_acr) NO-LOCK
                                    WHERE relacto_tit_acr.cod_estab_tit_acr_pai = movto_tit_acr.cod_estab
                                      AND relacto_tit_acr.num_id_movto_tit_acr  = movto_tit_acr.num_id_movto_tit_acr:
                                    FOR FIRST b_tit_acr NO-LOCK 
                                        WHERE b_tit_acr.cod_estab      = relacto_tit_acr.cod_estab
                                          AND b_tit_acr.num_id_tit_acr = relacto_tit_acr.num_id_tit_acr:
                                        FIND nota_devol_tit_acr NO-LOCK 
                                            WHERE nota_devol_tit_acr.cod_estab       = b_tit_acr.cod_estab
                                              AND nota_devol_tit_acr.cod_espec_docto = b_tit_acr.cod_espec_docto
                                              AND nota_devol_tit_acr.cod_ser_docto   = b_tit_acr.cod_ser_docto
                                              AND nota_devol_tit_acr.cod_tit_acr     = b_tit_acr.cod_tit_acr
                                              AND nota_devol_tit_acr.cod_parcela     = b_tit_acr.cod_parcela NO-ERROR.
                                        IF AVAIL nota_devol_tit_acr THEN DO:
                                             ASSIGN c-cod-nota-devol = nota_devol_tit_acr.cod_nota_devol
                                                    l-enviar-nfd     = YES.
                                        END.
                                    END.
                                END.
                            END.
                        END.

                        ASSIGN c-tabela = c-tabela + fnFormata(string(tt-saldo.cod_tit_acr), 20, "R") + " " +
                                                     fnFormata(STRING(c-cod-nota-devol),10,"R")       + " " + 
                                                     string(tt-saldo.dat_emis_docto, "99/99/9999")    + " " + 
                                                     fnFormata(string(tt-saldo.val_sdo_tit_acr,">>>,>>>,>>9.99"), 16, "L") + CHR(13).
                    END.
                END.

                ASSIGN c-mensagem = c-mensagem + c-tabela + CHR(13) + "Total do Cliente: " + STRING(d-saldoc,">>,>>>,>>9.99") + CHR(13) + CHR(13) 
                       c-msg = "A/C Contas a Pagar - " + STRING(emitente.nome-emit).


            END.

        END CASE.

        IF  rs-docto = 3 THEN DO:

            IF  NOT l-enviar-nfd THEN
                NEXT.

            IF cod-mensagem-fim <> "" then do:
               FIND msg_financ NO-LOCK WHERE
                    msg_financ.cod_mensagem = cod-mensagem-fim NO-ERROR.
               IF AVAIL msg_financ THEN
                   ASSIGN c-mensagem = c-mensagem + CHR(13) + msg_financ.des_mensagem + CHR(13).
            END.
            IF c-narrativa-fim <> "" THEN
                ASSIGN c-mensagem = c-mensagem + CHR(13) + c-narrativa-fim.

        END.
        ELSE DO:
            IF cod-mensagem-fim <> "" then do:
               FIND msg_financ NO-LOCK WHERE
                    msg_financ.cod_mensagem = cod-mensagem-fim NO-ERROR.
               IF AVAIL msg_financ THEN
                   ASSIGN c-mensagem = c-mensagem + msg_financ.des_mensagem + CHR(13).
            END.
            IF c-narrativa-fim <> "" THEN
                ASSIGN c-mensagem = c-mensagem + c-narrativa-fim.
        END.

        ASSIGN c-email = ""
               c-email-cc = "BCC:".  /* "BCC:" pog para enviar copia oculta. Na upc do utapi019 ele identifica o BCC no inicio do endereco e envia como oculto */

        IF  tt-emitente.mail AND 
            tt-emitente.e-mail <> ""
        THEN
            ASSIGN c-email = tt-emitente.e-mail.

        IF  tt-emitente.mail-ger AND 
            tt-emitente.e-mail-ger <> ""
        THEN
            ASSIGN c-email-cc = c-email-cc + tt-emitente.e-mail-ger + ",".

        IF  tt-emitente.mail-rep AND 
            tt-emitente.e-mail-rep <> ""
        THEN
            ASSIGN c-email-cc = c-email-cc + tt-emitente.e-mail-rep + ",".

        IF  tt-emitente.mail-cont AND 
            tt-emitente.e-mail-cont <> ""
        THEN
            ASSIGN c-email-cc = c-email-cc + tt-emitente.e-mail-cont + ",".

        IF c-email-cc <> "BCC:" THEN DO:
            ASSIGN c-email-cc = SUBSTRING(c-email-cc,1,LENGTH(c-email-cc) - 1)
                   c-email-cc = REPLACE(c-email-cc,"BCC:,","BCC:")
                   c-email-cc = REPLACE(c-email-cc,",,",",").
        END.

        IF  c-email = "" THEN
            ASSIGN c-email    = TRIM(SUBSTR(c-email-cc,5,200)). /* remover o comando "BCC:" copia oculta */

        IF c-email-cc = "BCC:" THEN
            ASSIGN c-email-cc = "".

        EMPTY TEMP-TABLE tt-envio2.   
        EMPTY TEMP-TABLE tt-mensagem.
        EMPTY TEMP-TABLE tt-erros.

        IF  l-tem 
        THEN DO:
            FOR FIRST usuar_mestre NO-LOCK 
                WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren:
            END.

            CREATE tt-envio2.
            ASSIGN tt-envio2.versao-integracao = 1
                   tt-envio2.destino           = REPLACE (replace(c-email, "BCC",""), " ", "")
                   tt-envio2.remetente         = IF usuar_mestre.cod_e_mail_local = "" THEN "ems@intelbras.com.br" ELSE usuar_mestre.cod_e_mail_local
                   tt-envio2.copia             = REPLACE (c-email-cc, " ", "")
                   tt-envio2.assunto           = c-msg
                   tt-envio2.arq-anexo         = ""
                   tt-envio2.formato           = "TEXTO".

            CREATE tt-mensagem.
            ASSIGN tt-mensagem.seq-mensagem = 1
                   tt-mensagem.mensagem     = c-mensagem.
           
            RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                           INPUT  TABLE tt-mensagem,
                                           OUTPUT TABLE tt-erros).

            FIND FIRST tt-erros NO-LOCK NO-ERROR.
            IF NOT AVAIL tt-erros 
            THEN DO:
                 /* ** Gera hist¢rico do envio de e-mail para o Cliente ***/
                 FIND LAST histor_clien NO-LOCK
                     WHERE histor_clien.cod_empresa = v_cod_empres_usuar
                     AND   histor_clien.cdn_cliente = tt-emitente.cod-emitente NO-ERROR.
                 IF AVAIL histor_clien THEN
                     ASSIGN i-sequencia = histor_clien.num_seq_histor_clien + 1.
                 ELSE 
                     ASSIGN i-sequencia = 1.
    
                 FOR EACH tt_histor_clien_integr:
                     DELETE tt_histor_clien_integr.
                 END.
    
                 CREATE tt_histor_clien_integr.
                 ASSIGN tt_histor_clien_integr.tta_cod_empresa                  = v_cod_empres_usuar 
                        tt_histor_clien_integr.tta_cdn_cliente                  = tt-emitente.cod-emitente
                        tt_histor_clien_integr.tta_num_seq_histor_clien         = i-sequencia
                        tt_histor_clien_integr.tta_des_abrev_histor_clien       = STRING(TODAY,"99/99/9999") + " * Enviamos e-mail de Cobran‡a" 
                        tt_histor_clien_integr.ttv_num_tip_operac               = 1
                        tt_histor_clien_integr.tta_des_histor_clien             = "Enviado e-mail de cobran‡a de t¡tulos " + c-situacao-titulo        + " para o cliente em " + 
                                                                                  STRING(TODAY,"99/99/9999") + " as "      + STRING(TIME, "hh:mm:ss") + " por "               + 
                                                                                  v_cod_usuar_corren + "."   + CHR(13). 

                 IF  tt-emitente.mail AND 
                     tt-emitente.e-mail <> ""
                 THEN
                     ASSIGN tt_histor_clien_integr.tta_des_histor_clien = tt_histor_clien_integr.tta_des_histor_clien + 
                                                                          "E-mail do Cliente: " + tt-emitente.e-mail  + CHR(13).

                 IF  tt-emitente.mail-ger AND 
                     tt-emitente.e-mail-ger <> ""
                 THEN
                     ASSIGN tt_histor_clien_integr.tta_des_histor_clien = tt_histor_clien_integr.tta_des_histor_clien    + 
                                                                          "E-mail do Gerente: " + tt-emitente.e-mail-ger + CHR(13).
                 IF  tt-emitente.mail-rep AND 
                     tt-emitente.e-mail-rep <> ""
                 THEN
                     ASSIGN tt_histor_clien_integr.tta_des_histor_clien = tt_histor_clien_integr.tta_des_histor_clien          + 
                                                                          "E-mail do Representante: " + tt-emitente.e-mail-rep + CHR(13).
                 IF  tt-emitente.mail-cont AND 
                     tt-emitente.e-mail-cont <> ""
                 THEN
                     ASSIGN tt_histor_clien_integr.tta_des_histor_clien = tt_histor_clien_integr.tta_des_histor_clien     + 
                                                                          "E-mail do Contato: " + tt-emitente.e-mail-cont + CHR(13).

                 ASSIGN tt_histor_clien_integr.tta_des_histor_clien = tt_histor_clien_integr.tta_des_histor_clien + 
                                                                      "Total da Cobran‡a: " + STRING(d-saldoc,">>,>>>,>>9.99").
    
                 RUN prgint/utb/utb765ze.py(1,
                                            INPUT TABLE tt_cliente_integr,
                                            INPUT TABLE tt_fornecedor_integr,
                                            INPUT TABLE tt_clien_financ_integr_e,
                                            INPUT TABLE tt_fornec_financ_integr_d,
                                            INPUT TABLE tt_pessoa_jurid_integr_e,
                                            INPUT TABLE tt_pessoa_fisic_integr_e,
                                            INPUT TABLE tt_contato_integr_e,
                                            INPUT TABLE tt_contat_clas_integr,
                                            INPUT TABLE tt_estrut_clien_integr,
                                            INPUT TABLE tt_estrut_fornec_integr,
                                            INPUT TABLE tt_histor_clien_integr,
                                            INPUT TABLE tt_histor_fornec_integr,
                                            INPUT TABLE tt_ender_entreg_integr_e,
                                            INPUT TABLE tt_telef_integr,
                                            INPUT TABLE tt_telef_pessoa_integr,
                                            INPUT TABLE tt_pj_ativid_integr,
                                            INPUT TABLE tt_pj_ramo_negoc_integr,
                                            INPUT TABLE tt_porte_pj_integr,
                                            INPUT TABLE tt_idiom_pf_integr,
                                            INPUT TABLE tt_idiom_contat_integr,
                                            INPUT "", /*Matriz de Tradu‡Æo Organizacional*/
                                            INPUT "", /*Empresa*/
                                            INPUT-OUTPUT TABLE tt_retorno_clien_fornec).
            END.

            DEF VAR i-seq AS INTEGER NO-UNDO.

            IF  CAN-FIND(FIRST tt-erros) THEN DO:
                PUT skip(2) " ATEN€ÇO, erro envio emai para o cliente...." SKIP
                            "Cliente: " tt-emitente.cod-emitente     SKIP 
                            "tt-envio2.destino.: " tt-envio2.destino FORMAT "x(1000)" SKIP
                            "tt-envio2.copia...: " tt-envio2.copia   FORMAT "x(1000)" SKIP(1).
            END.

            FOR EACH tt-erros:
                IF  i-seq = 0 THEN
                    PUT skip(2) " ATEN€ÇO, existe(m) erro(s) no processo de envio de email...(tt-erros)" SKIP(1).

                ASSIGN i-seq = i-seq + 1.

                PUT "Sequˆncia Erro: " STRING(i-seq, "99") SKIP
                    "Cd Erro..: " STRING(tt-erros.cod-erro) " - " tt-erros.desc-erro SKIP.
            END.

            ASSIGN i-seq = 0.

            FOR EACH tt_retorno_clien_fornec:   
                IF  i-seq = 0 THEN
                    PUT skip(1) " ATEN€ÇO, existe(m) erro(s) no processo de envio de email...(tt_retorno_clien_fornec)" SKIP(1).

                ASSIGN i-seq = i-seq + 1.

                PUT UNFORMATTED "Sequˆncia Erro: " STRING(i-seq, "99") SKIP
                                 "ttv_cod_parameters              : " tt_retorno_clien_fornec.ttv_cod_parameters               skip
                                 "ttv_num_mensagem                : " tt_retorno_clien_fornec.ttv_num_mensagem                 skip
                                 "ttv_des_mensagem                : " tt_retorno_clien_fornec.ttv_des_mensagem                 skip
                                 "ttv_des_ajuda                   : " tt_retorno_clien_fornec.ttv_des_ajuda                    skip
                                 "ttv_cod_parameters_clien        : " tt_retorno_clien_fornec.ttv_cod_parameters_clien         skip
                                 "ttv_cod_parameters_fornec       : " tt_retorno_clien_fornec.ttv_cod_parameters_fornec        skip
                                 "ttv_log_envdo                   : " tt_retorno_clien_fornec.ttv_log_envdo                    skip
                                 "ttv_cod_parameters_clien_financ : " tt_retorno_clien_fornec.ttv_cod_parameters_clien_financ  skip
                                 "ttv_cod_parameters_fornec_financ: " tt_retorno_clien_fornec.ttv_cod_parameters_fornec_financ skip
                                 "ttv_cod_parameters_pessoa_fisic : " tt_retorno_clien_fornec.ttv_cod_parameters_pessoa_fisic  skip
                                 "ttv_cod_parameters_pessoa_jurid : " tt_retorno_clien_fornec.ttv_cod_parameters_pessoa_jurid  skip
                                 "ttv_cod_parameters_estrut_clien : " tt_retorno_clien_fornec.ttv_cod_parameters_estrut_clien  skip
                                 "ttv_cod_parameters_estrut_fornec: " tt_retorno_clien_fornec.ttv_cod_parameters_estrut_fornec skip
                                 "ttv_cod_parameters_contat       : " tt_retorno_clien_fornec.ttv_cod_parameters_contat        skip
                                 "ttv_cod_parameters_repres       : " tt_retorno_clien_fornec.ttv_cod_parameters_repres        skip
                                 "ttv_cod_parameters_ender_entreg : " tt_retorno_clien_fornec.ttv_cod_parameters_ender_entreg  skip
                                 "ttv_cod_parameters_pessoa_ativid: " tt_retorno_clien_fornec.ttv_cod_parameters_pessoa_ativid skip
                                 "ttv_cod_parameters_ramo_negoc   : " tt_retorno_clien_fornec.ttv_cod_parameters_ramo_negoc    skip
                                 "ttv_cod_parameters_porte_pessoa : " tt_retorno_clien_fornec.ttv_cod_parameters_porte_pessoa  skip
                                 "ttv_cod_parameters_idiom_pessoa : " tt_retorno_clien_fornec.ttv_cod_parameters_idiom_pessoa  skip
                                 "ttv_cod_parameters_clas_contat  : " tt_retorno_clien_fornec.ttv_cod_parameters_clas_contat   skip
                                 "ttv_cod_parameters_idiom_contat : " tt_retorno_clien_fornec.ttv_cod_parameters_idiom_contat  skip
                                 "ttv_cod_parameters_telef        : " tt_retorno_clien_fornec.ttv_cod_parameters_telef         skip
                                 "ttv_cod_parameters_telef_pessoa : " tt_retorno_clien_fornec.ttv_cod_parameters_telef_pessoa  skip
                                 "ttv_cod_parameters_histor_clien : " tt_retorno_clien_fornec.ttv_cod_parameters_histor_clien  skip
                                 "ttv_cod_parameters_histor_fornec: " tt_retorno_clien_fornec.ttv_cod_parameters_histor_fornec SKIP (2).
            END.

        END.

        /*Est  sendo intanciada por itera‡Æo do for echa, pois quando havia 1 erro para 1 registro, a utapi019 retornava erro para todos os registros. */
        IF  VALID-HANDLE(h-utapi019) 
        THEN 
            DELETE PROCEDURE h-utapi019.
    
        ASSIGN h-utapi019 = ?.


    END. /**** for each tt-emitente ***/
END.

PROCEDURE piImprimeRelat.

   PUT UNFORMATTED "Emitente;Nome Abrev;".
   IF l-ve-a THEN PUT  UNFORMATTED "Vencidos at‚ " STRING(fx-vea-fim) ";".
   IF l-ve-b THEN PUT  UNFORMATTED STRING(fx-veb-ini) " at‚ " STRING(fx-veb-fim) ";".
   IF l-ve-c THEN PUT  UNFORMATTED STRING(fx-vec-ini) " at‚ " STRING(fx-vec-fim) ";".
   IF l-ve-d THEN PUT  UNFORMATTED STRING(fx-ved-ini) " at‚ " STRING(fx-ved-fim) ";".
   IF l-ve-e THEN PUT  UNFORMATTED STRING(fx-vee-ini) " at‚ " STRING(fx-vee-fim) ";".
   IF l-ve-f THEN PUT  UNFORMATTED STRING(fx-vef-ini) " at‚ " STRING(fx-vef-fim) ";".
   IF l-ve-g THEN PUT  UNFORMATTED "acima de " STRING(fx-veg-ini)  ";".           
       
   IF l-av-a THEN PUT  UNFORMATTED "A Vencer at‚ " STRING(fx-ava-fim) ";".
   IF l-av-b THEN PUT  UNFORMATTED STRING(fx-avb-ini) " at‚ " STRING(fx-avb-fim) ";".
   IF l-av-c THEN PUT  UNFORMATTED STRING(fx-avc-ini) " at‚ " STRING(fx-avc-fim) ";".
   IF l-av-d THEN PUT  UNFORMATTED STRING(fx-avd-ini) " at‚ " STRING(fx-avd-fim) ";".
   IF l-av-e THEN PUT  UNFORMATTED STRING(fx-ave-ini) " at‚ " STRING(fx-ave-fim) ";".
   IF l-av-f THEN PUT  UNFORMATTED STRING(fx-avf-ini) " at‚ " STRING(fx-avf-fim) ";".
   IF l-av-g THEN PUT  UNFORMATTED "acima de " STRING(fx-avg-ini)  ";". 

   PUT UNFORMATTED "Total".

   IF  l-detalhes 
   THEN
       PUT UNFORMATTED ";Cidade;UF;Representante;E-mail".

   PUT UNFORMATTED SKIP.

   FOR EACH tt-emitente use-index valor,
       first emitente no-lock
       where emitente.cod-emitente = tt-emitente.cod-emitente:

       FIND FIRST gr-cli NO-LOCK 
           WHERE gr-cli.cod-gr-cli = emitente.cod-gr-cli no-error.

       assign t-ve-a  = t-ve-a  + tt-emitente.ve-a
              t-ve-b  = t-ve-b  + tt-emitente.ve-b
              t-ve-c  = t-ve-c  + tt-emitente.ve-c
              t-ve-d  = t-ve-d  + tt-emitente.ve-d
              t-ve-e  = t-ve-e  + tt-emitente.ve-e
              t-ve-f  = t-ve-f  + tt-emitente.ve-f
              t-ve-g  = t-ve-g  + tt-emitente.ve-g
              t-av-a  = t-av-a  + tt-emitente.av-a
              t-av-b  = t-av-b  + tt-emitente.av-b
              t-av-c  = t-av-c  + tt-emitente.av-c
              t-av-d  = t-av-d  + tt-emitente.av-d
              t-av-e  = t-av-e  + tt-emitente.av-e
              t-av-f  = t-av-f  + tt-emitente.av-f
              t-av-g  = t-av-g  + tt-emitente.av-g
              t-total = t-total + tt-emitente.TOTAL.

       PUT UNFORMATTED tt-emitente.cod-emitente ";"
                       emitente.nome-abrev ";".

       IF l-ve-a THEN PUT UNFORMATTED tt-emitente.ve-a ";".
       IF l-ve-b THEN PUT UNFORMATTED tt-emitente.ve-b ";".
       IF l-ve-c THEN PUT UNFORMATTED tt-emitente.ve-c ";".
       IF l-ve-d THEN PUT UNFORMATTED tt-emitente.ve-d ";".
       IF l-ve-e THEN PUT UNFORMATTED tt-emitente.ve-e ";".
       IF l-ve-f THEN PUT UNFORMATTED tt-emitente.ve-f ";".
       IF l-ve-g THEN PUT UNFORMATTED tt-emitente.ve-g ";".

       IF l-av-a THEN PUT UNFORMATTED tt-emitente.av-a ";".
       IF l-av-b THEN PUT UNFORMATTED tt-emitente.av-b ";".
       IF l-av-c THEN PUT UNFORMATTED tt-emitente.av-c ";".
       IF l-av-d THEN PUT UNFORMATTED tt-emitente.av-d ";".
       IF l-av-e THEN PUT UNFORMATTED tt-emitente.av-e ";".
       IF l-av-f THEN PUT UNFORMATTED tt-emitente.av-f ";".
       IF l-av-g THEN PUT UNFORMATTED tt-emitente.av-g ";".

       PUT UNFORMATTED tt-emitente.TOTAL.

       IF  l-detalhes 
       THEN
           PUT UNFORMATTED ";" emitente.cidade ";"
                           emitente.estado ";"
                           emitente.cod-rep ";"
                           tt-emitente.e-mail.

       PUT UNFORMATTED SKIP.
   END. /******* FOR EACH TT-EMITENTE *******/

   PUT UNFORMATTED SKIP "TOTAL:;;".

   IF l-ve-a THEN PUT UNFORMATTED t-ve-a ";".
   IF l-ve-b THEN PUT UNFORMATTED t-ve-b ";".
   IF l-ve-c THEN PUT UNFORMATTED t-ve-c ";".
   IF l-ve-d THEN PUT UNFORMATTED t-ve-d ";".
   IF l-ve-e THEN PUT UNFORMATTED t-ve-e ";".
   IF l-ve-f THEN PUT UNFORMATTED t-ve-f ";".
   IF l-ve-g THEN PUT UNFORMATTED t-ve-g ";".

   IF l-av-a THEN PUT UNFORMATTED t-av-a ";".
   IF l-av-b THEN PUT UNFORMATTED t-av-b ";".
   IF l-av-c THEN PUT UNFORMATTED t-av-c ";".
   IF l-av-d THEN PUT UNFORMATTED t-av-d ";".
   IF l-av-e THEN PUT UNFORMATTED t-av-e ";".
   IF l-av-f THEN PUT UNFORMATTED t-av-f ";".
   IF l-av-g THEN PUT UNFORMATTED t-av-g ";".

   PUT t-total SKIP.

END PROCEDURE. /* End da PROCEDURE piImprimeRelat */

PROCEDURE Pi-Abre-Edit:
  DEF INPUT PARAM P_Cod_Dwb_File AS CHAR FORM "x(40)" NO-UNDO.
  DEF VAR V_Cod_Key_Value        AS CHAR FORM "x(08)" NO-UNDO.

  GET-KEY-VALUE SECTION 'EMS' KEY 'Show-Report-Program' VALUE V_Cod_Key_Value.
  if V_Cod_Key_Value = "" OR 
     V_Cod_Key_Value = ?  THEN 
  DO.
    ASSIGN V_Cod_Key_Value = 'start'.
    PUT-KEY-VALUE SECTION 'EMS' KEY 'Show-Report-Program' VALUE V_Cod_Key_Value NO-ERROR.
  END. /* End do - if V_Cod_Key_Value = "" OR V_Cod_Key_Value = ? */

  OS-COMMAND SILENT /*NO-WAIT*/ VALUE(V_Cod_Key_Value + CHR(32) + P_Cod_Dwb_File).
END PROCEDURE.  /* End da Procedure Pi-Abre-Edit */
                 
FUNCTION fnformata RETURNS CHARACTER
  ( c-campo AS CHAR, i-tam   AS INTEGER, c-pos   AS CHAR ) :

    IF  LENGTH(trim(c-campo)) < i-tam THEN DO:
        CASE c-pos:
            WHEN "R" THEN DO:
                c-campo = c-campo + FILL(" ", i-tam - LENGTH(trim(c-campo))). 
            END.
            WHEN "L" THEN DO:
                c-campo = FILL(" ", i-tam - LENGTH(trim(c-campo))) + trim(c-campo). 
            END.
        END CASE.
    END.
    RETURN c-campo.
END FUNCTION.
