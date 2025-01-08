/*{include/i-prgvrs.i ESUTP026 2.04.00.000}*/
/***********************************************************************
**  Programa..: ESP\UTP\ESUTP005RP.P
**  Autor.....: Raphael Paini
**  Data......: Junho/2008 - Desenvolvimento
**  Descricao.: Integra Contabilidade Telefonia
**  Vers∆o....: 001 07/06/2008
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/

/****************************  Temp-Tables  ****************************/
{esp/utp/esutp026tt.i}

/****************************  Frames       ****************************/

DEF input parameter raw-param as raw no-undo.
DEF input parameter table for tt-raw-digita.

DEFINE BUFFER b-vpc FOR vpc.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

DEF var h-acomp      as handle no-undo.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK WHERE
                 empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

DEFINE VARIABLE c-sistema      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-titulo-relat AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-empresa      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-programa     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-versao       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-revisao      AS CHARACTER   NO-UNDO.

ASSIGN c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Atualiza VPC"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "ESUTP026"
       c-versao       = "2.04"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */

DO ON STOP UNDO, LEAVE:

    OUTPUT TO VALUE(tt-param.arquivo) APPEND.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Lendo VPC...").

    PUT UNFORMATTED
        SKIP(2)
        "Data: " + STRING(TODAY,"99/99/9999") + " - Hora: " + STRING(TIME,"HH:MM:SS")    AT 01 SKIP
        "NR. VPC Anterior   Atual     " AT 01 SKIP
        "------- ---------- ----------" AT 01 SKIP.

    FOR EACH vpc NO-LOCK:
        RUN pi-acompanhar IN h-acomp (INPUT "VPC: " + STRING(vpc.nr-vpc)).
        FIND FIRST tit_ap NO-LOCK
             WHERE tit_ap.cod_estab       = vpc.cod-estabel
               AND tit_ap.cdn_fornecedor  = vpc.cod-emitente
               AND tit_ap.cod_espec_docto = vpc.cod-esp
               AND tit_ap.cod_ser_docto   = vpc.serie
               AND tit_ap.cod_tit_ap      = vpc.nro-docto
               AND tit_ap.cod_parcela     = "01" NO-ERROR.
        IF AVAIL tit_ap THEN DO:

            IF tit_ap.val_sdo_tit_ap = 0 THEN DO:
                IF CAN-FIND(FIRST movto_tit_ap OF tit_ap NO-LOCK
                            WHERE(   movto_tit_ap.ind_trans_ap = "Acerto Valor a Menor"
                                  OR movto_tit_ap.ind_trans_ap = "Acerto Valor a DÇbito"
                                  OR movto_tit_ap.ind_trans_ap = "Baixa"
                                  OR movto_tit_ap.ind_trans_ap = "Baixa por Substituiá∆o"
                                  OR movto_tit_ap.ind_trans_ap = "Baixa por Transf Estab"
                                  OR movto_tit_ap.ind_trans_ap = "Pagto Extra Fornecedor"    
                                  OR movto_tit_ap.ind_trans_ap = "Pagto Extra Fornecedor CR" 
                                  OR movto_tit_ap.ind_trans_ap = "Pagto Encontro Contas"    
                                  OR movto_tit_ap.ind_trans_ap = "Subst Nota por Duplicata" )) THEN DO:
                    IF CAN-FIND(FIRST movto_tit_ap OF tit_ap NO-LOCK
                                WHERE movto_tit_ap.ind_trans_ap = "Acerto Valor a Menor"
                                  AND movto_tit_ap.cod_refer    BEGINS "VPCV"
                                  AND movto_tit_ap.val_movto_ap = tit_ap.val_origin_tit_ap) THEN DO:
                        IF vpc.situacao <> 3 THEN DO:
                            FIND FIRST b-vpc OF vpc EXCLUSIVE-LOCK NO-ERROR.
                            IF AVAIL b-vpc THEN DO:
                                RUN pi-imprime(INPUT vpc.nr-vpc,
                                               INPUT vpc.situacao,
                                               INPUT 3).
                                ASSIGN b-vpc.situacao = 3.
                            END.
                        END.

                    END.
                    ELSE DO:
                        IF vpc.situacao <> 2 THEN DO:
                            FIND FIRST b-vpc OF vpc EXCLUSIVE-LOCK NO-ERROR.
                            IF AVAIL b-vpc THEN DO:
                                RUN pi-imprime(INPUT vpc.nr-vpc,
                                               INPUT vpc.situacao,
                                               INPUT 2).
                                ASSIGN b-vpc.situacao = 2.
                            END.
                        END.

                    END.
                END.
                ELSE DO:
                    /*n∆o encontrou baixa nem acerto valor ent∆o cancela a vpc*/
                    IF vpc.situacao <> 3 THEN DO:
                        FIND FIRST b-vpc OF vpc EXCLUSIVE-LOCK NO-ERROR.
                        IF AVAIL b-vpc THEN DO:
                            RUN pi-imprime(INPUT vpc.nr-vpc,
                                           INPUT vpc.situacao,
                                           INPUT 3).
                            ASSIGN b-vpc.situacao = 3.
                        END.
                    END.
                END.
            END.
            ELSE DO:
                IF vpc.situacao <> 1 THEN DO:
                    FIND FIRST b-vpc OF vpc EXCLUSIVE-LOCK NO-ERROR.
                    IF AVAIL b-vpc THEN DO:
                        RUN pi-imprime(INPUT vpc.nr-vpc,
                                       INPUT vpc.situacao,
                                       INPUT 1).
                        ASSIGN b-vpc.situacao = 1.
                    END.
                END.
            END.
        END.
        ELSE DO:
            IF vpc.nro-docto = "" AND vpc.data-liberacao = ? THEN NEXT.
            /*Caso nao encontre mais o t°tulo a vpc volta a ficar pendente pra liberacao*/
            FIND FIRST b-vpc OF vpc EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL b-vpc THEN DO:
                RUN pi-imprime(INPUT vpc.nr-vpc,
                               INPUT vpc.situacao,
                               INPUT 0).
                ASSIGN b-vpc.data-liberacao    = ?
                       b-vpc.usuario-liberacao = ""
                       b-vpc.nro-docto         = ""
                       b-vpc.serie             = ""
                       b-vpc.cod-esp           = ""
                       b-vpc.situacao          = 0.
            END.
        END.
    END.

    PUT UNFORMATTED SKIP(1).

    OUTPUT CLOSE.

    RUN pi-finalizar in h-acomp.

    /*{include/i-rpclo.i}*/ 

    RETURN "OK".
END.

PROCEDURE pi-imprime:
   DEFINE INPUT PARAMETER p-nr-vpc   AS INTEGER NO-UNDO.
   DEFINE INPUT PARAMETER p-anterior AS INTEGER NO-UNDO.
   DEFINE INPUT PARAMETER p-atual    AS INTEGER NO-UNDO.

   DEFINE VARIABLE c-situacao AS CHARACTER   NO-UNDO.

   ASSIGN c-situacao = "Pendente,Liberado,Finalizado,Cancelado".

   PUT UNFORMATTED
       p-nr-vpc FORMAT ">>>>>>9" AT 01
       ENTRY(p-anterior + 1,c-situacao) FORMAT "x(10)" AT 09
       ENTRY(p-atual + 1,c-situacao)    FORMAT "x(10)" AT 20 SKIP.

END PROCEDURE.
