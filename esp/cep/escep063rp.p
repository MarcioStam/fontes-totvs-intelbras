/*****************************************************************************
** Programa: esp/cep/escep063rp.p
** Vers∆o..: 1.00
** Data....: 14/02/2012
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Programa para alterar o comprador das ordens e pedidos
*****************************************************************************/
{include/i-prgvrs.i ESCEP063RP 2.00.00.001}
  

/*--- Definiá∆o das Vari†veis Locais ---*/
DEFINE VARIABLE h-acomp         AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-linha         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-destino       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cont          AS INTEGER     NO-UNDO.

{include/i-rpvar.i}



/*--- Definiá∆o de Temp-Tables e Buffers ---*/
{esp/cep/escep063.i}

DEFINE TEMP-TABLE tt-dados-import NO-UNDO
    FIELD num-pedido    LIKE pedido-compr.num-pedido
    FIELD cod-comprador LIKE ordem-compra.cod-comprado
    FIELD linha         AS INTEGER.

DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD num-pedido LIKE pedido-compr.num-pedido
    FIELD des-erro   AS CHAR FORMAT "x(100)".




/*--- Definiá∆o dos ParÉmetros de Entrada ---*/
DEFINE INPUT  PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.




/*--- Definiá∆o das Frames ---*/
DEFINE FRAME fPedidos
    pedido-compr.num-pedido
    WITH DOWN STREAM-IO WIDTH 132 FRAME fPedidos.

DEFINE FRAME fErros
    tt-erro.num-pedido
    tt-erro.des-erro   COLUMN-LABEL "Erro"
    WITH DOWN STREAM-IO WIDTH 132 FRAME fErros.

FIND FIRST param-global NO-LOCK NO-ERROR.

FIND FIRST mgcad.empresa NO-LOCK
    WHERE  empresa.ep-codigo = param-global.empresa-prin NO-ERROR.

ASSIGN c-programa     = "ESCEP062RP":U
       c-versao       = "2.00":U
       c-revisao      = ".00.001":U
       c-empresa      = IF AVAIL empresa THEN empresa.razao-social ELSE ""
       c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Altera Comprador Ordens e Pedidos".

/* Include com a definiá∆o da frame de cabeáalho e rodapÇ */
{include/i-rpcab.i}



/*--- Inicializaá∆o das Informaá‰es ---*/
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

    CREATE tt-dados-import.
    ASSIGN tt-dados-import.num-pedido    = INT(ENTRY(1,c-linha,";"))
           tt-dados-import.cod-comprador = ENTRY(2,c-linha,";")
           tt-dados-import.linha         = i-cont.
END.
INPUT CLOSE.


RUN pi-seta-titulo IN h-acomp (INPUT "Processando Dados":U).


IF  CAN-FIND(FIRST tt-dados-import) THEN
    PUT UNFORMATTED "Importaá∆o efetuada com sucesso!" SKIP(2)
                    "Pedidos alterados:" SKIP.

FOR EACH  tt-dados-import NO-LOCK
    WHERE tt-dados-import.num-pedido <> 0:
    RUN pi-acompanhar IN h-acomp (INPUT "Processando Pedido: " + STRING(tt-dados-import.num-pedido)).

    FIND FIRST pedido-compr EXCLUSIVE-LOCK
        WHERE  pedido-compr.num-pedido = tt-dados-import.num-pedido NO-ERROR.
    IF  NOT AVAIL pedido-compr THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.num-pedido = tt-dados-import.num-pedido
               tt-erro.des-erro   = "Pedido de Compra n∆o localizado".
        NEXT.
    END.

    FOR EACH  ordem-compra EXCLUSIVE-LOCK
        WHERE ordem-compra.num-pedido = pedido-compr.num-pedido:
        ASSIGN ordem-compra.cod-comprado = tt-dados-import.cod-comprador.
    END.

    ASSIGN pedido-compr.responsavel = tt-dados-import.cod-comprador.

    DISP pedido-compr.num-pedido
        WITH FRAME fPedidos.
    DOWN WITH FRAME fPedidos.
END.


/* Caso tenha ocorrido erro, imprime */
IF  CAN-FIND(FIRST tt-erro) THEN DO:
    PUT UNFORMATTED SKIP(2) "Erros no processo" SKIP.

    FOR EACH tt-erro NO-LOCK:
        DISP tt-erro.num-pedido
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

