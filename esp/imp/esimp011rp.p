/********************************************************************************
***
***
***
*******************************************************************************/
{include/i-prgvrs.i esimp011rp 2.00.00.000 } /*** 010000 ***/

/*******************************************************************************
***
***
***
*********************************************************************************/
define temp-table tt-param no-undo
    field destino          as INTEGER
    field arquivo          as char format "x(35)":U
    field arq-anexo        as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    field modelo           AS char format "x(35)":U
    /*Alterado 15/02/2005 - tech1007 - Criado campo l¢gico para verificar se o RTF foi habilitado*/
    field l-habilitaRtf    as LOG
    /*Fim alteracao 15/02/2005*/
    FIELD arq-importa      AS CHAR.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
   field raw-digita as raw.

DEFINE TEMP-TABLE tt-despesa NO-UNDO
    FIELD cod-estabel       AS CHARACTER
    FIELD embarque          AS CHARACTER
    FIELD cod-pto-contr     AS INTEGER
    FIELD cod-desp          AS INTEGER
    FIELD cod-emitente-desp AS INTEGER
    FIELD cod-cond-pag      AS INTEGER
    FIELD mo-codigo         AS INTEGER
    FIELD val-desp          AS DECIMAL FORMAT ">>,>>>,>>>,>>9.99999".

DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD cod-estabel       AS CHARACTER
    FIELD embarque          AS CHARACTER
    FIELD desc-erro         AS CHARACTER.

DEFINE TEMP-TABLE tt-desp-embarque-criado NO-UNDO
    FIELD cod-estabel       AS CHARACTER
    FIELD embarque          AS CHARACTER
    FIELD cod-pto-contr     AS INTEGER
    FIELD cod-desp          AS INTEGER
    FIELD cod-emitente-desp AS INTEGER
    FIELD cod-cond-pag      AS INTEGER
    FIELD mo-codigo         AS INTEGER
    FIELD val-desp          AS DECIMAL FORMAT ">>,>>>,>>>,>>9.99999".

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

DEFINE BUFFER bf-desp-embarque FOR desp-embarque.

DEFINE VARIABLE h-acomp      AS HANDLE             NO-UNDO.
DEFINE VARIABLE l-erro       AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE l-sucesso    AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE c-hora       AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-data       AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-usuar      AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-texto-mail AS CHARACTER          NO-UNDO.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.
FIND FIRST tt-param NO-LOCK NO-ERROR.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

FORM "ERROS DE IMPORTA€ÇO:" SKIP
     "====================" SKIP
    WITH FRAME f-cab-erro WIDTH 132 STREAM-IO DOWN.

FORM "Importa‡Æo com sucesso:" SKIP
     "=======================" SKIP
    WITH FRAME f-cab-sucesso WIDTH 132 STREAM-IO DOWN.

FORM c-texto-mail              SKIP
     "=======================" SKIP
    WITH FRAME f-cab-sucesso-mail WIDTH 132.

FORM tt-erro.cod-estabel       FORMAT "X(5)"   COLUMN-LABEL "Estabel"       
     tt-erro.embarque          FORMAT "X(12)"  COLUMN-LABEL "Embarque"      
     tt-erro.desc-erro         FORMAT "X(109)" COLUMN-LABEL "Erro de Importa‡Æo:"
    WITH FRAME f-erro WIDTH 132 STREAM-IO DOWN.

FORM tt-desp-embarque-criado.cod-estabel       FORMAT "X(5)"        COLUMN-LABEL "Estabel"
     tt-desp-embarque-criado.embarque          FORMAT "X(12)"       COLUMN-LABEL "Embarque"
     tt-desp-embarque-criado.cod-pto-contr     FORMAT ">>,>>9"      COLUMN-LABEL "Ponto Controle"
     tt-desp-embarque-criado.cod-desp          FORMAT ">>,>>9"      COLUMN-LABEL "Despesa"
     tt-desp-embarque-criado.cod-emitente-desp FORMAT ">>>>>>>>9"   COLUMN-LABEL "Emitente"
     tt-desp-embarque-criado.cod-cond-pag      FORMAT ">>>>>>>>9"   COLUMN-LABEL "Cond Pgto"
     tt-desp-embarque-criado.mo-codigo         FORMAT ">>>9"        COLUMN-LABEL "Moeda" 
     tt-desp-embarque-criado.val-desp          FORMAT ">>,>>>,>>>,>>9.99999" COLUMN-LABEL "Valor Despesa"
    WITH FRAME f-despesa WIDTH 132 STREAM-IO DOWN.
   
/** Defini¯´es de vari˜veis e frames padr´es **/ 
{include/i-rpvar.i}

{utp/ut-liter.i InclusÆo_Despesas_do_Embarque esimp}
ASSIGN c-programa     = "ESIMP011":U
       c-versao       = "00"
       c-revisao      = "000"
       c-titulo-relat = RETURN-VALUE.

FIND FIRST param-global NO-LOCK NO-ERROR.
    IF AVAIL param-global THEN
        ASSIGN c-empresa = param-global.grupo.

{include/i-rpcab.i}                 
{include/i-rpout.i} 

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Gerando Despesas").

RUN pi-seta-titulo IN h-acomp (INPUT "Lendo Arquivo .csv").

INPUT FROM VALUE(tt-param.arq-importa).
REPEAT:
    CREATE tt-despesa.
    IMPORT DELIMITER ";" tt-despesa  NO-ERROR.

    RUN pi-acompanhar IN h-acomp (INPUT tt-despesa.embarque).
END.
INPUT CLOSE.

RUN pi-seta-titulo IN h-acomp (INPUT "Validando/Criando Despesa").

ASSIGN l-erro = NO.

blk-despesa:
FOR EACH tt-despesa:

    IF tt-despesa.cod-estabel BEGINS "Estabel" OR TRIM(tt-despesa.cod-estabel) = "" THEN DO:
        DELETE tt-despesa.
        NEXT blk-despesa.
    END.

    IF tt-despesa.embarque BEGINS "Embarque" OR TRIM(tt-despesa.embarque) = ""  THEN DO:
        DELETE tt-despesa.
        NEXT blk-despesa.
    END.

    RUN pi-acompanhar IN h-acomp (INPUT tt-despesa.embarque).

    FOR FIRST embarque-imp NO-LOCK
        WHERE embarque-imp.cod-estabel = tt-despesa.cod-estabel
          AND embarque-imp.embarque    = tt-despesa.embarque:
    END.

    FOR FIRST historico-embarque NO-LOCK OF embarque-imp
        WHERE historico-embarque.cod-pto-contr = tt-despesa.cod-pto-contr:
    END.

    FOR FIRST desp-imp NO-LOCK
        WHERE desp-imp.cod-desp = tt-despesa.cod-desp:
    END.

    FOR FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = tt-despesa.cod-emitente-desp
          AND emitente.identific    <> 1:
    END.

    FOR FIRST cond-pagto NO-LOCK
        WHERE cond-pagto.cod-cond-pag = tt-despesa.cod-cond-pag:
    END.

    FOR FIRST moeda NO-LOCK
        WHERE moeda.mo-codigo = tt-despesa.mo-codigo:
    END.

    IF NOT AVAIL embarque-imp THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.cod-estabel = tt-despesa.cod-estabel
               tt-erro.embarque    = tt-despesa.embarque
               tt-erro.desc-erro   = "Embarque inexistente!"
               l-erro              = YES.
        NEXT blk-despesa.
    END.
    IF NOT AVAIL historico-embarque THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.cod-estabel = tt-despesa.cod-estabel
               tt-erro.embarque    = tt-despesa.embarque
               tt-erro.desc-erro   = "NÆo encontrado o Ponto de Controle " + STRING(tt-despesa.cod-pto-contr) + "."
               l-erro              = YES.
        NEXT blk-despesa.
    END.
    IF NOT AVAIL desp-imp THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.cod-estabel = tt-despesa.cod-estabel
               tt-erro.embarque    = tt-despesa.embarque
               tt-erro.desc-erro   = "NÆo encontrado a Despesa " + STRING(tt-despesa.cod-desp) + "."
               l-erro              = YES.
        NEXT blk-despesa.
    END.
    IF NOT AVAIL emitente THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.cod-estabel = tt-despesa.cod-estabel
               tt-erro.embarque    = tt-despesa.embarque
               tt-erro.desc-erro   = "NÆo encontrado o emitente " + STRING(tt-despesa.cod-emitente-desp) + "."
               l-erro              = YES.
        NEXT blk-despesa.
    END.
    IF NOT AVAIL cond-pagto THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.cod-estabel = tt-despesa.cod-estabel
               tt-erro.embarque    = tt-despesa.embarque
               tt-erro.desc-erro   = "NÆo encontrada a Condi‡Æo de Pagamento " + STRING(tt-despesa.cod-cond-pag) + "."
               l-erro              = YES.
        NEXT blk-despesa.
    END.
    IF NOT AVAIL moeda THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.cod-estabel = tt-despesa.cod-estabel
               tt-erro.embarque    = tt-despesa.embarque
               tt-erro.desc-erro   = "NÆo encontrado a moeda " + STRING(tt-despesa.mo-codigo) + "."
               l-erro              = YES.
        NEXT blk-despesa.
    END.

    IF CAN-FIND(FIRST desp-embarque NO-LOCK
                WHERE desp-embarque.cod-estabel       = embarque-imp.cod-estabel
                  AND desp-embarque.embarque          = embarque-imp.embarque
                  AND desp-embarque.cod-itiner        = historico-embarque.cod-itiner
                  AND desp-embarque.cod-pto-contr     = historico-embarque.cod-pto-contr
                  AND desp-embarque.cod-desp          = tt-despesa.cod-desp
                  AND desp-embarque.cod-emitente-desp = tt-despesa.cod-emitente-desp) THEN DO:
        CREATE tt-erro.
        ASSIGN tt-erro.cod-estabel = tt-despesa.cod-estabel
               tt-erro.embarque    = tt-despesa.embarque
               tt-erro.desc-erro   = "J  existe a despesa " + STRING(tt-despesa.cod-desp) + "."
               l-erro              = YES.
        NEXT blk-despesa.
    END.

    CREATE desp-embarque.
    ASSIGN desp-embarque.cod-estabel       = embarque-imp.cod-estabel
           desp-embarque.embarque          = embarque-imp.embarque
           desp-embarque.cod-itiner        = historico-embarque.cod-itiner
           desp-embarque.cod-pto-contr     = historico-embarque.cod-pto-contr
           desp-embarque.cod-desp          = desp-imp.cod-desp
           desp-embarque.cod-emitente-desp = emitente.cod-emitente
           desp-embarque.cod-cond-pag      = cond-pagto.cod-cond-pag
           desp-embarque.val-desp          = tt-despesa.val-desp
           desp-embarque.mo-codigo         = moeda.mo-codigo
           desp-embarque.descricao       = IF AVAIL desp-imp THEN desp-imp.descricao ELSE "". 

    CREATE tt-desp-embarque-criado.
    ASSIGN tt-desp-embarque-criado.cod-estabel       = desp-embarque.cod-estabel
           tt-desp-embarque-criado.embarque          = desp-embarque.embarque
           tt-desp-embarque-criado.cod-desp          = desp-embarque.cod-desp
           tt-desp-embarque-criado.cod-pto-contr     = desp-embarque.cod-pto-contr
           tt-desp-embarque-criado.cod-emitente-desp = desp-embarque.cod-emitente-desp
           tt-desp-embarque-criado.cod-cond-pag      = desp-embarque.cod-cond-pag
           tt-desp-embarque-criado.mo-codigo         = desp-embarque.mo-codigo
           tt-desp-embarque-criado.val-desp          = desp-embarque.val-desp.
END.

RUN pi-seta-titulo IN h-acomp (INPUT "Imprindo Relat¢rio").
RUN pi-acompanhar  IN h-acomp (INPUT "Imprindo Relat¢rio").

IF l-erro = YES THEN DO:
    DISP WITH FRAME f-cab-erro WIDTH 132 STREAM-IO DOWN.
    DOWN WITH FRAME f-cab-erro.
END.

FOR EACH tt-erro:
    DISP tt-erro.cod-estabel 
         tt-erro.embarque    
         tt-erro.desc-erro
        WITH FRAME f-erro WIDTH 132 STREAM-IO DOWN.
    DOWN WITH FRAME f-erro.
END.

DISP SKIP(2).

ASSIGN l-sucesso = YES.

FOR EACH tt-desp-embarque-criado:
    IF l-sucesso = YES THEN DO:
        DISP WITH FRAME f-cab-sucesso WIDTH 132 STREAM-IO DOWN.
        DOWN WITH FRAME f-cab-sucesso.
    END.

    DISP tt-desp-embarque-criado.cod-estabel
         tt-desp-embarque-criado.embarque
         tt-desp-embarque-criado.cod-pto-contr
         tt-desp-embarque-criado.cod-desp
         tt-desp-embarque-criado.cod-emitente-desp
         tt-desp-embarque-criado.cod-cond-pag
         tt-desp-embarque-criado.mo-codigo   
         tt-desp-embarque-criado.val-desp    
        WITH FRAME f-despesa WIDTH 132 STREAM-IO DOWN.
    DOWN WITH FRAME f-despesa.

    ASSIGN l-sucesso = NO.
END.

RUN pi-finalizar IN h-acomp.

ASSIGN h-acomp = ?.

PAGE.

DEFINE VARIABLE c-selecao   AS CHARACTER FORMAT "X(07)" NO-UNDO.
DEFINE VARIABLE c-impressao AS CHARACTER FORMAT "X(09)" NO-UNDO.
DEFINE VARIABLE c-destino   AS CHARACTER FORMAT "X(07)" NO-UNDO.
DEFINE VARIABLE c-usuario   AS CHARACTER FORMAT "X(07)" NO-UNDO.

{utp/ut-liter.i SELE€ÇO *}
ASSIGN c-selecao = TRIM(RETURN-VALUE).
{utp/ut-liter.i IMPRESSÇO *}
ASSIGN c-impressao = TRIM(RETURN-VALUE).
{utp/ut-liter.i Destino *}
ASSIGN c-destino = TRIM(RETURN-VALUE).
{utp/ut-liter.i Usu rio *}
ASSIGN c-usuario = TRIM(RETURN-VALUE).


DISP SKIP(1)
     c-selecao NO-LABEL
     SKIP(1)
     WITH FRAME f-selecao WIDTH 132 STREAM-IO SIDE-LABELS.
     
DISP SKIP(3)
     c-impressao
     SKIP(1)
     c-destino ":" AT 10
     tt-param.arquivo 
     SKIP
     c-usuario ":" AT 10
     tt-param.usuario 
     WITH FRAME f-impressao WIDTH 132 STREAM-IO NO-LABELS.

RUN pi-gera-arq-anexo.

{include/i-rpclo.i} 

PROCEDURE pi-gera-arq-anexo:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN c-hora    = STRING(TIME,"HH:MM:SS")
           c-data    = STRING(TODAY)
           l-sucesso = YES
           c-texto-mail = "Importa‡Æo com sucesso feita pelo usu rio " + tt-param.usuario + " no dia " + c-data + " as " + c-hora.

    OUTPUT TO "c:\temp\esimp011-mail.txt" CONVERT TARGET "iso8859-1".

    FOR EACH tt-desp-embarque-criado:

        IF l-sucesso = YES THEN DO:
            PUT UNFORMATTED c-texto-mail SKIP
                            "================================================================================".
        END.

        DISP tt-desp-embarque-criado.cod-estabel
             tt-desp-embarque-criado.embarque
             tt-desp-embarque-criado.cod-pto-contr
             tt-desp-embarque-criado.cod-desp
             tt-desp-embarque-criado.cod-emitente-desp
             tt-desp-embarque-criado.cod-cond-pag
             tt-desp-embarque-criado.mo-codigo   
             tt-desp-embarque-criado.val-desp    
            WITH FRAME f-despesa WIDTH 132 STREAM-IO DOWN.
        DOWN WITH FRAME f-despesa.

        ASSIGN l-sucesso = NO.
    END.

    OUTPUT TO CLOSE.                 

END PROCEDURE.


RETURN "OK":U.
