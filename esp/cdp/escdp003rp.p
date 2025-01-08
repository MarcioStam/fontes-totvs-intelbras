{include/i-prgvrs.i ESCDP003RP 1.00.00.000}
/* defini‡Æo das temp-tables para recebimento de parƒmetros */
{esp\cdp\escdp003tt.i}

/* recebimento de parƒmetros */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param NO-ERROR.

/* include padrÆo para vari veis para o log  */
{include/i-rpvar.i}
{include/i-freeac.i}

/* defini‡Æo de vari veis e streams */
DEFINE STREAM s-imp.
DEFINE VARIABLE h-acomp        AS HANDLE    NO-UNDO.
DEFINE VARIABLE c-linha        AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-linha        AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-cest         AS CHARACTER NO-UNDO.
DEFINE VARIABLE dt-valid       AS DATE      NO-UNDO.
DEFINE VARIABLE c-ncm          AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-item         AS CHARACTER NO-UNDO.
DEFINE VARIABLE h-esmsspapi001 AS HANDLE    NO-UNDO.
DEFINE VARIABLE c-mensagem     AS CHARACTER NO-UNDO.

DEFINE TEMP-TABLE tt-erro
    FIELD i-linha AS INTEGER
    FIELD c-erro  AS CHARACTER FORMAT "X(40)"
    FIELD l-erro  AS LOGICAL.
                                               
FORM
    tt-erro.i-linha AT 10 COLUMN-LABEL "Linha"
    tt-erro.c-erro        COLUMN-LABEL "Descri‡Æo Erro"
    WITH FRAME f-erro NO-BOX DOWN NO-ATTR-SPACE WIDTH 132 STREAM-IO. 

DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER FORMAT "X(12)" NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE v_cod_estab_usuar
    AS CHARACTER
    FORMAT "x(3)"
    LABEL "Estabelecimento"
    COLUMN-LABEL "Estab"
    NO-UNDO.

/* defini‡Æo de frames do log */

/* include padrÆo para output de log */
{include/i-rpout.i &STREAM="stream str-rp" &TOFILE=tt-param.arq-destino}

/* include com a defini‡Æo da frame de cabe‡alho e rodap‚ */
{include/i-rpcab.i &STREAM="str-rp"}

FIND FIRST param-global NO-LOCK NO-ERROR. 

/* bloco principal do programa */
ASSIGN	c-programa 	= "ESCDP003RP"
        c-versao	= "1.00"
        c-revisao	= ".00.000"
        c-empresa	= param-global.grupo
        c-titulo-relat = "Importa‡Æo de CEST".

VIEW STREAM str-rp FRAME f-cabec.
VIEW STREAM str-rp FRAME f-rodape.
RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
{utp/ut-liter.i Importando *}

RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

/* define o arquivo de entrada informando na p gina de parƒmetros */
INPUT STREAM s-imp FROM VALUE(tt-param.arq-entrada).

/* CEST - C½digo especificador da substitui»’o tributÿria - Carlos Daniel - 04/03/2016*/
RUN esp/mssp/esmsspapi001.p PERSISTENT SET h-esmsspapi001.

/* bloco principal do programa */
REPEAT ON STOP UNDO, LEAVE:
    ASSIGN i-linha = i-linha + 1.
    IMPORT STREAM s-imp UNFORMATTED c-linha.
    
	RUN pi-acompanhar IN h-acomp (INPUT i-linha).

    IF i-linha <> 1 THEN DO:
	    ASSIGN dt-valid = DATE(ENTRY(1, c-linha, ";"))
               c-item   = ENTRY(2, c-linha, ";")
               c-ncm    = ENTRY(3, c-linha, ";")
               c-cest   = ENTRY(4, c-linha, ";").
                
        ASSIGN c-mensagem = "".
        
        RUN piGeraRelactoCest IN h-esmsspapi001 (INPUT INTEGER(c-cest), /* CEST */
                                                 INPUT dt-valid,        /* Data inicio validade */
                                                 INPUT "*",             /* Estabelecimento */
                                                 INPUT "*",             /* UF */
                                                 INPUT "*",             /* Natureza de Opera‡Æo */
                                                 INPUT c-ncm,           /* NCM */
                                                 INPUT c-item,          /* Item */
                                                 INPUT 0,               /* Emitente */
                                                 OUTPUT c-mensagem).

        IF RETURN-VALUE <> "OK" THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.i-linha = i-linha
                   tt-erro.c-erro  = c-mensagem + "(" + c-item + ")".
                   tt-erro.l-erro  = YES.
        END.
        ELSE DO:
            CREATE tt-erro.
            ASSIGN tt-erro.i-linha = i-linha
                   tt-erro.c-erro  = "Item " + c-item + " importado com sucesso."
                   tt-erro.l-erro  = NO.
        END.
        ASSIGN c-item = ""
               c-cest = "".
    END.
END.

IF VALID-HANDLE(h-esmsspapi001) THEN
    DELETE PROCEDURE h-esmsspapi001.

INPUT STREAM s-imp CLOSE.

FOR EACH tt-erro
    WHERE (IF tt-param.todos = 2 THEN tt-erro.l-erro ELSE tt-erro.i-linha > 0):

    DISP STREAM str-rp
        tt-erro.i-linha
        tt-erro.c-erro
        WITH FRAME f-erro.
        DOWN WITH FRAME f-erro.
END.

/* fechamento do output do log */
{include/i-rpclo.i &STREAM="stream str-rp"}

RUN pi-finalizar IN h-acomp.

RETURN "Ok":U.
