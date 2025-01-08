/*********************************************************************************
** Programa: esp/acr/esacr050rp.p
** VersÆo..: 1.00
** Data....: 19/01/2012
** Autor...: Estevan Krger - Exponencial TI
** Obs.....: Programa de relat¢rio para listagem dos Clientes que possuem
**           cartÆo Intelbras Clube
*********************************************************************************/
{include/i-prgvrs.i ESACR051RP 2.00.00.002}  /*** 010002 ***/
  

/*--- Defini‡Æo das Vari veis Locais ---*/
DEFINE VARIABLE h-acomp            AS HANDLE                   NO-UNDO.
DEFINE VARIABLE c-destino          AS CHARACTER                NO-UNDO.
DEFINE VARIABLE c-tipo-relatorio   AS CHARACTER                NO-UNDO.
DEFINE VARIABLE c-mes              AS CHARACTER                NO-UNDO.
DEFINE VARIABLE de-total           AS DECIMAL                  NO-UNDO.
DEFINE VARIABLE c-prorroga         AS CHARACTER FORMAT "x(10)" NO-UNDO. 
DEFINE VARIABLE c-cancel           AS CHARACTER FORMAT "x(10)" NO-UNDO. 
DEFINE VARIABLE c-vl-devol         AS CHARACTER FORMAT "x(19)" NO-UNDO. 
DEFINE VARIABLE c-dt-prorrog       AS CHARACTER FORMAT "x(10)" NO-UNDO.
DEFINE VARIABLE c-dt-cancel        AS CHARACTER FORMAT "x(10)" NO-UNDO.
DEFINE VARIABLE c-dt-envio         AS CHARACTER FORMAT "x(10)" NO-UNDO.

{include/i-rpvar.i}

/*--- Defini‡Æo de Temp-Tables e Buffers ---*/
DEFINE TEMP-TABLE tt-dados NO-UNDO
    FIELD cod-emitente  LIKE emitente.cod-emitente
    FIELD nome-abrev    LIKE emitente.nome-abrev
    FIELD cod-estabel   LIKE int-nfs-supcard.cod-estabel
    FIELD serie         LIKE int-nfs-supcard.serie
    FIELD nr-nota-fis   LIKE int-nfs-supcard.nr-nota-fis
    FIELD cod_cart_bcia LIKE tit_acr.cod_cart_bcia
    FIELD dt-emis-nota  LIKE nota-fiscal.dt-emis-nota
    FIELD dat-movto     LIKE int-nfs-supcard.dat-movto
    FIELD val-faturado  LIKE int-nfs-supcard.val-faturado
    FIELD cod-cond-pag  LIKE nota-fiscal.cod-cond-pag
    FIELD desc-cond-pag LIKE cond-pagto.descricao
    FIELD num-parcelas  LIKE cond-pagto.num-parcelas
    FIELD unid-negoc    AS CHARACTER
    FIELD vl-unid-negoc LIKE int-nfs-supcard.val-faturado
    FIELD dt-trans      AS DATE
    FIELD vl-taxa       AS DECIMAL FORMAT "->>>,>>>,>>9.99":U
    FIELD vl-outras     AS DECIMAL FORMAT "->>>,>>>,>>9.99"
    FIELD c-canc-devol  AS CHARACTER FORMAT "x(15)"
    FIELD vl-devol      AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99"
    FIELD cod-classe    LIKE int-emitente-supcard.cod-classe
    FIELD val-limite    LIKE int-emitente-supcard.val-limite
    FIELD dt-prorrog    LIKE int-pendencias-supcard.dat-envio
    FIELD dt-cancel     LIKE int-pendencias-supcard.dat-envio
    FIELD dt-envio      LIKE int-pendencias-supcard.dat-envio
    INDEX idx-nota      cod-estabel serie nr-nota-fis
    INDEX idx-data      dat-movto.

{esp/acr/esacr051.i}




/*--- Defini‡Æo dos Parƒmetros de Entrada ---*/
DEFINE INPUT  PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.




/*--- Defini‡Æo das Frames ---*/
DEFINE FRAME fMovtos
    tt-dados.cod-classe    COLUMN-LABEL "Classe"
    tt-dados.val-limite    COLUMN-LABEL "Limite"
    tt-dados.dat-movto     COLUMN-LABEL "Data"
    tt-dados.cod-emitente  COLUMN-LABEL "Cod Cli"
    tt-dados.nome-abrev    COLUMN-LABEL "Nome Abrev"
    tt-dados.cod-estabel   COLUMN-LABEL "Estab"
    tt-dados.serie         COLUMN-LABEL "Ser"
    tt-dados.nr-nota-fis   COLUMN-LABEL "Nota Fiscal"
    tt-dados.cod_cart_bcia COLUMN-LABEL "Gr.Cob"
    tt-dados.dt-emis-nota  COLUMN-LABEL "Dt EmissÆo"
    tt-dados.cod-cond-pag  COLUMN-LABEL "Cond"
    tt-dados.desc-cond-pag COLUMN-LABEL "Desc Cond Pagto"
    tt-dados.num-parcelas  COLUMN-LABEL "P/"
    tt-dados.unid-negoc    COLUMN-LABEL "UN"
    tt-dados.vl-unid-negoc COLUMN-LABEL "Valor UN"          FORMAT "->>>,>>>,>>9.99"
    tt-dados.val-faturado  COLUMN-LABEL "Valor Nota Fiscal" FORMAT "->>>,>>>,>>9.99"
    tt-dados.dt-trans      COLUMN-LABEL "Dt Taxas"          FORMAT "99/99/9999":U
    tt-dados.vl-taxa       COLUMN-LABEL "Valor Taxa"        FORMAT "->>>,>>>,>>9.99"
    tt-dados.vl-outras     COLUMN-LABEL "Outras Taxas"      FORMAT "->>>,>>>,>>9.99"
    tt-dados.c-canc-devol  COLUMN-LABEL "Canc/Devol"        FORMAT "x(15)"
    c-vl-devol             COLUMN-LABEL "Valor Devolu‡Æo"   FORMAT "x(19)"
    WITH DOWN STREAM-IO WIDTH 285 FRAME fMovtos.

DEFINE FRAME fTotal
    c-mes     COLUMN-LABEL "Mˆs"   FORMAT "x(14)"
    de-total  COLUMN-LABEL "TOTAL" FORMAT "->>>,>>>,>>9.99"
    WITH DOWN STREAM-IO WIDTH 285 FRAME fTotal.

DEFINE FRAME fParametros
    "Sele‡Æo"               COLON 50 SKIP(1)
    tt-param.data-inicial   COLON 39 LABEL "Per¡odo"
    "|< >|":U               COLON 51
    tt-param.data-final     NO-LABEL
    c-tipo-relatorio        COLON 39 LABEL "Tipo Relat¢rio" FORMAT "x(30)"
    SKIP(1)
    "ImpressÆo"             COLON 50 SKIP(1)
    c-destino               COLON 39 LABEL "Destino"
    " - ":U
    tt-param.arquivo        FORMAT "x(40)":U NO-LABEL SKIP
    tt-param.usuario        COLON 39 LABEL "Usu rio" SKIP(1)
    WITH WIDTH 285 SIDE-LABELS STREAM-IO.

FIND FIRST param-global NO-LOCK NO-ERROR.

FIND FIRST mgcad.empresa NO-LOCK
    WHERE  empresa.ep-codigo = param-global.empresa-prin NO-ERROR.

ASSIGN c-empresa      = IF AVAIL empresa THEN empresa.razao-social ELSE ""
       c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Extrato de Movimenta‡äes Intelbras Clube".

/* Include com a defini‡Æo da frame de cabe‡alho e rodap‚ */
{include/i-rpc255.i}




/*--- Inicializa‡Æo das Informa‡äes ---*/
FUNCTION fnMes RETURNS CHARACTER ( pMes AS INTEGER )  FORWARD.

{include/i-rpout.i}


IF  tt-param.exporta-excel THEN DO:
    PUT UNFORMATTED c-titulo-relat SKIP.
END.
ELSE DO:
    VIEW FRAME f-cabec-255.
    VIEW FRAME f-rodape-255.
END.

IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "":U).

/*--- Bloco Principal ---*/
/* Busca os dados */
RUN esp/acr/esacr051rpa.p (INPUT tt-param.data-inicial,
                           INPUT tt-param.data-final,
                           INPUT h-acomp,
                           OUTPUT TABLE tt-dados).

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-seta-titulo IN h-acomp (INPUT "Imprimindo Dados":U).


/* ImpressÆo */
IF  tt-param.exporta-excel THEN DO:
    IF  tt-param.tp-relatorio = 1 /* Anal¡tico */ THEN DO:
        PUT UNFORMATTED "Classe;Limite;Data;Cod Cli;Nome Abrev;Estabel;Serie;Nota Fiscal;Gr.Cob;Dt EmissÆo;Cond Pagto;Desc Cond Pagto;Num Parcelas;Unid Negoc;Valor Unid Negoc;Valor Nota Fiscal;Dt Trans Taxa;Valor Taxa;Outras Taxas;Canc/Devol;Valor Devolu‡Æo;Dt Envio;Dt Prorroga‡Æo;Dt Cancelamento" SKIP.
    END.
    ELSE DO:
        PUT UNFORMATTED "Per¡odo;Valor Total" SKIP.
    END.

    FOR EACH tt-dados NO-LOCK
        BREAK BY MONTH(tt-dados.dat-movto)
              BY YEAR(tt-dados.dat-movto)
              BY tt-dados.dat-movto:
    
        IF  VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Movimentos: " + STRING(tt-dados.dat-movto)).
    
        ACCUMULATE tt-dados.val-faturado (TOTAL BY MONTH(tt-dados.dat-movto) BY YEAR(tt-dados.dat-movto)).
    
        IF  tt-param.tp-relatorio = 1 /* Anal¡tico */ THEN DO:
            ASSIGN c-vl-devol = IF tt-dados.vl-devol > 0 THEN STRING(tt-dados.vl-devol, "->>>,>>>,>>>,>>9.99":U) ELSE "".

            ASSIGN c-dt-prorrog = IF tt-dados.dt-prorrog = ? THEN "" ELSE string(tt-dados.dt-prorrog)
                   c-dt-cancel  = IF tt-dados.dt-cancel  = ? THEN "" ELSE string(tt-dados.dt-cancel)
                   c-dt-envio   = IF tt-dados.dt-envio   = ? THEN "" ELSE string(tt-dados.dt-envio).

            PUT UNFORMATTED tt-dados.cod-classe    ";"
                            tt-dados.val-limite    ";"
                            tt-dados.dat-movto     ";"
                            tt-dados.cod-emitente  ";"
                            tt-dados.nome-abrev    ";"
                            tt-dados.cod-estabel   ";"
                            tt-dados.serie         ";"
                            tt-dados.nr-nota-fis   ";"
                            tt-dados.cod_cart_bcia ";"
                            tt-dados.dt-emis-nota  ";"
                            tt-dados.cod-cond-pag  ";"
                            tt-dados.desc-cond-pag ";"
                            tt-dados.num-parcelas  ";"
                            tt-dados.unid-negoc    ";"
                            tt-dados.vl-unid-negoc ";"
                            tt-dados.val-faturado  ";"
                            tt-dados.dt-trans      ";"
                            tt-dados.vl-taxa       ";"
                            tt-dados.vl-outras     ";"
                            tt-dados.c-canc-devol  ";"
                            c-vl-devol             ";"
                            c-dt-envio             ";"
                            c-dt-prorrog           ";"
                            c-dt-cancel            SKIP.
        END.
    
        IF  LAST-OF(YEAR(tt-dados.dat-movto)) THEN DO:
            IF  tt-param.tp-relatorio = 1 /* Anal¡tico */ THEN DO:
                PUT UNFORMATTED fnMes(MONTH(tt-dados.dat-movto)) + "/" + STRING(YEAR(tt-dados.dat-movto)) ";--;--;--;--;--;--;--;--;--;--;--;"
                                ACCUM TOTAL BY YEAR(tt-dados.dat-movto) tt-dados.val-faturado SKIP(1).
            END.
            ELSE DO:
                PUT UNFORMATTED fnMes(MONTH(tt-dados.dat-movto)) + "/" + STRING(YEAR(tt-dados.dat-movto)) ";"
                                ACCUM TOTAL BY YEAR(tt-dados.dat-movto) tt-dados.val-faturado SKIP.
            END.
        END.
    END.
END.
ELSE DO:
    FOR EACH tt-dados NO-LOCK
        BREAK BY MONTH(tt-dados.dat-movto)
              BY YEAR(tt-dados.dat-movto)
              BY tt-dados.dat-movto
              BY tt-dados.cod-estabel
              BY tt-dados.serie
              BY tt-dados.nr-nota-fis:
    
        IF  VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Movimentos: " + STRING(tt-dados.dat-movto)).
    
        ACCUMULATE tt-dados.val-faturado (TOTAL BY MONTH(tt-dados.dat-movto) BY YEAR(tt-dados.dat-movto)).
    
        IF  tt-param.tp-relatorio = 1 /* Anal¡tico */ THEN DO:
            ASSIGN c-vl-devol = IF tt-dados.vl-devol > 0 THEN STRING(tt-dados.vl-devol, "->>>,>>>,>>>,>>9.99":U) ELSE "".

            DISPLAY tt-dados.cod-classe
                    tt-dados.val-limite
                    tt-dados.dat-movto
                    tt-dados.cod-emitente
                    tt-dados.nome-abrev
                    tt-dados.cod-estabel
                    tt-dados.serie
                    tt-dados.nr-nota-fis
                    tt-dados.cod_cart_bcia
                    tt-dados.dt-emis-nota
                    tt-dados.cod-cond-pag
                    tt-dados.desc-cond-pag
                    tt-dados.num-parcelas
                    tt-dados.unid-negoc
                    tt-dados.vl-unid-negoc
                    tt-dados.val-faturado
                    tt-dados.dt-trans
                    tt-dados.vl-taxa
                    tt-dados.vl-outras
                    tt-dados.c-canc-devol
                    c-vl-devol
                WITH FRAME fMovtos.
            DOWN WITH FRAME fMovtos.
        END.
    
        IF  LAST-OF(YEAR(tt-dados.dat-movto)) THEN DO:
            DISPLAY fnMes(MONTH(tt-dados.dat-movto)) + "/" + STRING(YEAR(tt-dados.dat-movto)) @ c-mes
                    ACCUM TOTAL BY YEAR(tt-dados.dat-movto) tt-dados.val-faturado @ de-total
                WITH FRAME fTotal.
            DOWN WITH FRAME fTotal.
    
            IF  tt-param.tp-relatorio = 1 /* Anal¡tico */ THEN
                DISP SKIP(2).
        END.
    END.
END.




/*--- ImpressÆo da P gina de Parƒmetros ---*/
IF  NOT tt-param.exporta-excel THEN DO:
    IF  PAGE-NUMBER > 0 THEN
        PAGE.
    
    ASSIGN c-tipo-relatorio = IF tt-param.tp-relatorio = 1 THEN "Anal¡tico" ELSE "Sint‚tico"
           c-destino        = {varinc/var00002.i 04 tt-param.destino}.
    
    DISPLAY SKIP(1)
            tt-param.data-inicial
            tt-param.data-final
            c-tipo-relatorio
            c-destino
            tt-param.arquivo
            tt-param.usuario
        WITH FRAME fParametros.
END.




/*--- Finaliza‡Æo das Informa‡äes ---*/
{include/i-rpclo.i}

IF  VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

RETURN "OK":U.




/*--- Procedures Internas e Fun‡äes ---*/
FUNCTION fnMes RETURNS CHARACTER
  ( pMes AS INTEGER ):

    CASE pMes:
        WHEN 1 THEN
            RETURN "Janeiro".
        WHEN 2 THEN
            RETURN "Fevereiro".
        WHEN 3 THEN
            RETURN "Mar‡o".
        WHEN 4 THEN
            RETURN "Abril".
        WHEN 5 THEN
            RETURN "Maio".
        WHEN 6 THEN
            RETURN "Junho".
        WHEN 7 THEN
            RETURN "Julho".
        WHEN 8 THEN
            RETURN "Agosto".
        WHEN 9 THEN
            RETURN "Setembro".
        WHEN 10 THEN
            RETURN "Outubro".
        WHEN 11 THEN
            RETURN "Novembro".
        WHEN 12 THEN
            RETURN "Dezembro".
        OTHERWISE
            RETURN "".
    END CASE.

END FUNCTION.
