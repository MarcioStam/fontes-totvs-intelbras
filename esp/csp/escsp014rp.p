/***********************************************************************
**  Programa..: ESP\REP\ESCSP014RP.P
**  Autor.....: FELIPE PETRY VIEIRA
**  Data......: AGOSTO/2015 - Desenvolvimento
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESSCP014RP 2.04.00.001}

/****************************  Definitions  ****************************/
{esp/csp/escsp014tt.i}
{utp/ut-glob.i}
{include/i-rpvar.i}
{esp/es0018.i}
/****************************  Temp-Tables  ****************************/

/****************************  Frames       ****************************/
DEF INPUT PARAMETER raw-param as raw no-undo.
DEF INPUT PARAMETER table for tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

DEFINE VARIABLE h-acomp        AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-arquivo      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-desc-grupo   AS CHARACTER FORMAT "x(20)"  NO-UNDO.
DEFINE VARIABLE c-nome-emit    AS CHARACTER FORMAT "x(12)"  NO-UNDO.
DEFINE VARIABLE c-desc-tp-desp AS CHARACTER FORMAT "x(20)"  NO-UNDO.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK WHERE
          empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "":U
       c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE "":U
       c-programa     = "ESCSP014":U
       c-versao       = "2.04":U
       c-revisao      = "000":U .
       
FORM SKIP(1)
     "SELE€ÇO":U AT 13 SKIP(1)
     tt-param.cod-desp-ini    FORMAT ">>,>>9":U     LABEL "Despesa":U COLON 40 
     " |< >| ":U AT 59
     tt-param.cod-desp-fim    FORMAT ">>,>>9":U     NO-LABEL SKIP
     SKIP(1)
     "IMPRESSÇO":U AT 13 SKIP(1)
     tt-param.arquivo       FORMAT "x(80)":U      LABEL "Destino":U           COLON 40 SKIP
     tt-param.usuario       FORMAT "x(12)":U      LABEL "Usu rio":U           COLON 40 SKIP
     tt-param.arquivo-csv   FORMAT "x(80)":U      LABEL "Arquivo CSV":U       COLON 40 SKIP(1)
     WITH STREAM-IO SIDE-LABELS NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-impressao.
       
EMPTY TEMP-TABLE tt-prog-ponto. 

IF OPSYS = "UNIX":U THEN DO:

    RUN esp/es0018p.p (INPUT  "SPOOL-UNIX":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR FIRST tt-prog-ponto:
        ASSIGN c-arquivo = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
    END.

    IF SUBSTRING(c-arquivo, LENGTH(c-arquivo), 1) <> "/":U THEN
        ASSIGN c-arquivo = c-arquivo + "/":U.

    ASSIGN tt-param.arquivo     = c-programa + ".lst":U
           tt-param.arquivo-csv = c-arquivo + c-seg-usuario + "/":U + c-programa + ".csv":U.

END.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar in h-acomp (input "Gerando Relat¢rio...").

{include/i-rpcab.i}
{include/i-rpout.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

DISP tt-param.cod-desp-ini
     tt-param.cod-desp-fim
     tt-param.arquivo
     tt-param.usuario
     tt-param.arquivo-csv 
    WITH FRAME f-impressao.

{include/i-rpclo.i}

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar in h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    DELETE OBJECT h-acomp.
    
run pi-gera-csv.

RETURN "OK".

/*********************************************************************************/
PROCEDURE pi-gera-csv:

    DO ON STOP UNDO, LEAVE:

        OUTPUT TO VALUE(tt-param.arquivo-csv) CONVERT TARGET SESSION:CHARSET.
    
        PUT UNFORMATTED  
            "Despesa;Descricao;Tipo;Incoterm Rateio;Fator Ponder;Grupo Desp;Descricao;Fornec Padrao;Nome;Esp AP Padrao;Tipo Desp;Descricao;"
            "Imprime NF;Perm Alter Cotac;Duplicata;Embalagem;Seguro;Frete;Outras Desp;Imp Import;ICMS;IPI;ISS;PIS Vlr Adu;PIS Desp;Cofins Vlr Adu;"
            "Cofins Desp;Gera Custo;Incide Val Adu;Incide Vlr Desp;Incide Vlr Merc;Incide Tot NF " SKIP.
                
        for each desp-imp no-lock
            where desp-imp.cod-desp >= tt-param.cod-desp-ini
              and desp-imp.cod-desp <= tt-param.cod-desp-fim:
            
            /*Nome emitente*/  
            find first emitente no-lock
                where emitente.cod-emitente = desp-imp.cod-emitente no-error.
            if avail emitente then assign c-nome-emit = emitente.nome-abrev. 
            else assign c-nome-emit = ''.  
            
            /*Descri‡Æo Grupo Despesa*/
            find first grupo-desp no-lock
                where grupo-desp.cod-grup-desp = desp-imp.Cod-grup-desp no-error.
            if avail grupo-desp then assign c-desc-grupo = grupo-desp.desc-despesa.
            else assign c-desc-grupo = ''.
            
            /*Descri‡Æo Tipo Despesa*/
            find first tipo-rec-desp no-lock
                where tipo-rec-desp.tp-codigo = desp-imp.tp-despesa no-error.
            if avail tipo-rec-desp then assign c-desc-tp-desp = tipo-rec-desp.descricao.
            else assign c-desc-tp-desp = ''.
            
            PUT UNFORMATTED 
                 desp-imp.cod-desp                      ";"
                 desp-imp.descricao                     ";"
                 {cxinc/i01cx010.i 4 desp-imp.tipo}     ";"
                 desp-imp.cod-incoterm-rat              ";"
                 desp-imp.fat-ponder                    ";"
                 desp-imp.Cod-grup-desp                 ";"
                 c-desc-grupo                           ";"
                 desp-imp.cod-emitente                  ";"
                 c-nome-emit                            ";"
                 desp-imp.cod-espec-padr                ";"
                 desp-imp.tp-despesa                    ";"
                 c-desc-tp-desp                         ";"
                 desp-imp.log-1                        FORMAT "Sim/Nao"    ";"
                 desp-imp.log-permite-alter-cotac      FORMAT "Sim/Nao"    ";"
                 desp-imp.inc-val-duplic               FORMAT "Sim/Nao"    ";"
                 desp-imp.inc-val-embal                FORMAT "Sim/Nao"    ";"
                 desp-imp.inc-val-seguro               FORMAT "Sim/Nao"    ";"
                 desp-imp.inc-val-frete                FORMAT "Sim/Nao"    ";"
                 desp-imp.inc-val-outras-desp          FORMAT "Sim/Nao"    ";"
                 desp-imp.inc-base-ii                  FORMAT "Sim/Nao"    ";"
                 desp-imp.inc-base-icms                FORMAT "Sim/Nao"    ";"                 
                 desp-imp.inc-base-ipi                 FORMAT "Sim/Nao"    ";"
                 desp-imp.log-inc-base-iss             FORMAT "Sim/Nao"    ";"
                 desp-imp.log-incid-base-pis-val       FORMAT "Sim/Nao"    ";"
                 desp-imp.log-incid-base-pis-despes    FORMAT "Sim/Nao"    ";"
                 desp-imp.log-incid-base-cofins-val    FORMAT "Sim/Nao"    ";"
                 desp-imp.log-incid-base-cofins-despes FORMAT "Sim/Nao"    ";"
                 desp-imp.gera-custo                   FORMAT "Sim/Nao"    ";"
                 if SUBSTRING(desp-imp.char-1,24,1) = '1' then "Sim" else "Nao" ";"
                 desp-imp.inc-despesa-nota             FORMAT "Sim/Nao"    ";"
                 desp-imp.inc-valor-mercad             FORMAT "Sim/Nao"    ";"
                 desp-imp.inc-tot-valor                FORMAT "Sim/Nao"    ";"SKIP. 
                        
        end.
        OUTPUT CLOSE.

    END. /* DO ON STOP UNDO, LEAVE: */    
    
END PROCEDURE.
