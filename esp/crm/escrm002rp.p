/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*{include/i-prgvrs.i <Nome do Programa> 2.00.00.000}  /*** 010000 ***/*/
/*******************************************************************************
**  Programa: ADEEDIT\(C).P
**  Objetivo: <comment>
**  Autor...: Intelbras - USER    
**  Data....: 19.05.2008 16:11
*******************************************************************************/

{esp/es0026.i}   
{esp/es0018.i}

DEFINE VARIABLE c-dir   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp AS HANDLE      NO-UNDO.

DEFINE INPUT  PARAMETER raw-param AS RAW         NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

EMPTY TEMP-TABLE tt-prog-ponto.

IF OPSYS = "UNIX":U THEN
    RUN esp/es0018p.p (INPUT  "SPOOL-UNIX":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).
ELSE
    RUN esp/es0018p.p (INPUT  "SPOOL-WIN":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

FOR FIRST tt-prog-ponto:
    ASSIGN c-dir = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
END.

IF SUBSTRING(c-dir, LENGTH(c-dir), 1) <> "/":U THEN
    ASSIGN c-dir = c-dir + "/":U.

IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "Imprimindo...":U).

/* ALTERAR O ENDERECO */
OUTPUT TO VALUE(c-dir + "spool/transp-nova.txt":U).
FOR EACH emitente EXCLUSIVE-LOCK
   WHERE (emitente.identific = 1
      OR  emitente.identific = 3)
     AND  emitente.cep       = "88104800":U:
             
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-acompanhar IN h-acomp (INPUT "Codigo: ":U + STRING(emitente.cod-emitente)).

    PUT emitente.cod-emitente " ":U
        emitente.nome-emit    " ":U
        emitente.endereco     " ":U
        emitente.bairro       " ":U
        emitente.cidade       " ":U
        emitente.estado       " ":U
        emitente.cep          SKIP.

    ASSIGN emitente.endereco = "Intelbras SA - Rod. BR 101, km 213":U
           emitente.bairro   = "Area Industrial":U
           emitente.cidade   = "Sao Jose":U
           emitente.estado   = "SC":U.
END.

PUT " ":U                 SKIP
    "Local de entrega ":U SKIP
    " ":U                 SKIP.

FOR EACH loc-entr EXCLUSIVE-LOCK
    WHERE loc-entr.cep = "88104800":U:

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-acompanhar IN h-acomp (INPUT "Loc Entrega ":U + STRING(loc-entr.nome-abrev)).

    PUT loc-entr.nome-abrev " ":U
        loc-entr.cod-entr   " ":U
        loc-entr.endereco   " ":U
        loc-entr.bairro     " ":U
        loc-entr.cidade     " ":U
        loc-entr.estado     SKIP.

    ASSIGN loc-entr.endereco = "Intelbras SA - Rod. BR 101, km 213":U
           loc-entr.bairro   = "Area Industrial":U
           loc-entr.cidade   = "Sao Jose":U
           loc-entr.estado   = "SC":U.

    FIND int-loc-entr
        WHERE int-loc-entr.nome-abrev = loc-entr.nome-abrev
          AND int-loc-entr.cod-entrega = loc-entr.cod-entrega EXCLUSIVE-LOCK NO-ERROR.

    IF AVAILABLE int-loc-entr THEN
        ASSIGN int-loc-entr.endereco-completo = loc-entr.endereco.
END.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

OUTPUT CLOSE.

IF VALID-HANDLE(h-acomp) THEN
    DELETE PROCEDURE h-acomp.

ASSIGN h-acomp = ?.

RETURN "OK":U.

