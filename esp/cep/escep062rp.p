/*****************************************************************************
** Programa: esp/cep/escep062rp.p
** Vers∆o..: 1.00
** Data....: 13/02/2012
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: 
*****************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCEP062RP 2.00.00.001}
  

/*--- Definiá∆o das Vari†veis Locais ---*/
DEFINE VARIABLE h-acomp         AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-linha         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-destino       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-situacao-de   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-situacao-para AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cont          AS INTEGER     NO-UNDO.

{include/i-rpvar.i}



/*--- Definiá∆o de Temp-Tables e Buffers ---*/
{esp/cep/escep062.i}

DEFINE TEMP-TABLE tt-dados-import NO-UNDO
    FIELD it-codigo       LIKE item-uni-estab.it-codigo
    FIELD cod-obsoleto    LIKE item-uni-estab.cod-obsoleto
    FIELD motivo-situacao LIKE int-item.motivo-situacao
    FIELD linha           AS INTEGER.

DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD it-codigo   LIKE item-uni-estab.it-codigo
    FIELD des-erro    AS CHAR FORMAT "x(100)".

/*--- Definiá∆o dos ParÉmetros de Entrada ---*/
DEFINE INPUT  PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.

/*--- Definiá∆o das Frames ---*/
DEFINE FRAME fItens
    item-uni-estab.cod-estabel
    item-uni-estab.it-codigo
    c-situacao-de                COLUMN-LABEL "De"   FORMAT "x(28)"
    c-situacao-para              COLUMN-LABEL "Para" FORMAT "x(28)"
    c-motivo                     COLUMN-LABEL "Motivo" FORMAT "x(28)"
    WITH DOWN STREAM-IO WIDTH 132 FRAME fItens.

DEFINE FRAME fErros
    tt-erro.it-codigo
    tt-erro.des-erro   COLUMN-LABEL "Erro"
    WITH DOWN STREAM-IO WIDTH 132 FRAME fErros.

FIND FIRST param-global NO-LOCK NO-ERROR.

FIND FIRST empresa NO-LOCK
     WHERE empresa.ep-codigo = param-global.empresa-prin NO-ERROR.

ASSIGN c-programa     = "ESCEP062RP":U
       c-versao       = "2.00":U
       c-revisao      = ".00.001":U
       c-empresa      = IF AVAIL empresa THEN empresa.razao-social ELSE ""
       c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Altera Situaá∆o Item x Estab".

/* Include com a definiá∆o da frame de cabeáalho e rodapÇ */
{include/i-rpcab.i}



/*--- Inicializaá∆o das Informaá‰es ---*/
FUNCTION fnSituacao RETURNS CHARACTER ( pSituacao AS INTEGER )  FORWARD.

FUNCTION fnMotivo   RETURNS CHARACTER ( pMotivo AS INTEGER )  FORWARD.

{include/i-rpout.i}

IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.


/*--- Bloco Principal ---*/
DISABLE TRIGGERS FOR LOAD OF item-uni-estab.
 
IF  VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "Importando Dados").

INPUT FROM VALUE(tt-param.arquivo-import) NO-ECHO.
REPEAT:
    IMPORT UNFORMATTED c-linha.

    ASSIGN i-cont = i-cont + 1.

    RUN pi-acompanhar IN h-acomp (INPUT "Importando linha " + STRING(i-cont)).

    /* N∆o importa a primeira linha (Cabeáalho) */
    IF  i-cont = 1 THEN
        NEXT.

    IF ENTRY(1,c-linha,";") = "" THEN NEXT.
    
    CREATE tt-dados-import.
    ASSIGN tt-dados-import.it-codigo       = ENTRY(1,c-linha,";")
           tt-dados-import.cod-obsoleto    = INT(ENTRY(2,c-linha,";"))
           tt-dados-import.motivo-situacao = INT(ENTRY(3,c-linha,";"))
           tt-dados-import.linha           = i-cont.
END.
INPUT CLOSE.


RUN pi-seta-titulo IN h-acomp (INPUT "Processando Dados":U).


IF  CAN-FIND(FIRST tt-dados-import) THEN
    PUT UNFORMATTED "Importaá∆o efetuada com sucesso!" SKIP(2)
                    "Relacionamentos alterados:" SKIP.

FOR EACH  tt-dados-import NO-LOCK:
    
    RUN pi-acompanhar IN h-acomp (INPUT "Processando Item: " + tt-dados-import.it-codigo).

    FIND FIRST ITEM EXCLUSIVE-LOCK
         WHERE ITEM.it-codigo = tt-dados-import.it-codigo NO-ERROR.
    
    IF NOT AVAIL ITEM THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.it-codigo   = tt-dados-import.it-codigo
               tt-erro.des-erro    = "Item n∆o localizado".
        NEXT.
    END.

    FIND FIRST int-item EXCLUSIVE-LOCK
         WHERE int-item.it-codigo = tt-dados-import.it-codigo NO-ERROR.

    IF NOT AVAIL int-item THEN DO:
        CREATE int-item.
        ASSIGN int-item.it-codigo = tt-dados-import.it-codigo.
    END.

    IF  tt-dados-import.cod-obsoleto    = 2
    AND tt-dados-import.motivo-situacao = 0 THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.it-codigo   = tt-dados-import.it-codigo
               tt-erro.des-erro    = "N∆o alterado por falta de motivo de alteraá∆o para situaá∆o 2 - Obsoleto para ordens autom†tica.".
        NEXT.
    END.

    IF  tt-dados-import.cod-obsoleto    <> 2
    AND tt-dados-import.motivo-situacao <> 0 THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.it-codigo   = tt-dados-import.it-codigo
               tt-erro.des-erro    = "N∆o alterado com situaá∆o " + fnSituacao(tt-dados-import.motivo-situacao) + " pois n∆o pode receber motivo de alteraá∆o...".
        NEXT.
    END.

    ASSIGN ITEM.cod-obsoleto        = tt-dados-import.cod-obsoleto
           int-item.motivo-situacao = tt-dados-import.motivo-situacao.

    FOR EACH item-uni-estab EXCLUSIVE-LOCK
       WHERE item-uni-estab.it-codigo = tt-dados-import.it-codigo:

        DISP item-uni-estab.cod-estabel
             item-uni-estab.it-codigo
             fnSituacao(item-uni-estab.cod-obsoleto)   @ c-situacao-de
             fnSituacao(tt-dados-import.cod-obsoleto)  @ c-situacao-para
             fnMotivo(tt-dados-import.motivo-situacao) @ c-motivo
            WITH FRAME fItens.
        DOWN WITH FRAME fItens.
    
        ASSIGN item-uni-estab.cod-obsoleto = tt-dados-import.cod-obsoleto.
    END.
END.


/* Caso tenha ocorrido erro, imprime */
IF  CAN-FIND(FIRST tt-erro) THEN DO:
    PUT UNFORMATTED SKIP(2) "Erros no processo" SKIP.

    FOR EACH tt-erro NO-LOCK:
        DISP tt-erro.it-codigo
             tt-erro.des-erro
            WITH FRAME fErros.
        DOWN WITH FRAME fErros.
    END.
END.

/*--- Finalizaá∆o das Informaá‰es ---*/
{include/i-rpclo.i}

IF  VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

RETURN "OK":U.

/*--- Procedures Internas e Funá‰es ---*/
FUNCTION fnMotivo RETURNS CHARACTER
  ( pMotivo AS INTEGER ):

    CASE pMotivo:
        WHEN 1 THEN
            RETURN "Alteraá∆o de estrutura".
        WHEN 2 THEN 
            RETURN "Phase out produto".
        OTHERWISE
            RETURN "".
    END CASE.

END FUNCTION.

/*--- Procedures Internas e Funá‰es ---*/
FUNCTION fnSituacao RETURNS CHARACTER
  ( pSituacao AS INTEGER ):

    CASE pSituacao:
        WHEN 1 THEN
            RETURN "Ativo".
        WHEN 2 THEN 
            RETURN "Obsoleto Ordens Autom†ticas".
        WHEN 3 THEN
            RETURN "Obsoleto Todas as Ordens".
        WHEN 4 THEN
            RETURN "Totalmente Obsoleto".
        OTHERWISE
            RETURN "".
    END CASE.

END FUNCTION.
