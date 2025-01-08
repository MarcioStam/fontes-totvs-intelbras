/********************************************************************************
**  Programa: ESWMAPI007.p                                  
**  Data....: Janeiro/2023
**  Autor...: SCM Concept Consultoria e Desenvolvimento 
**  Objetivo: API de impress∆o de etiqueta de estrutura - Renovigi
********************************************************************************/
{METHOD/dbotterr.i}
{bcp/bcapi001.i}
{bcp/bcapi002.i}
{cdp/cd0666.i}
{utp/ut-glob.i}

DEF VAR lErro       AS LOG NO-UNDO.
DEF VAR i-sequencia AS INT NO-UNDO.
DEFINE VARIABLE iSeq  AS INTEGER     NO-UNDO.

DEFINE VARIABLE i-cont      AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cont-item AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cont-qtde AS INTEGER     NO-UNDO.

DEFINE INPUT  PARAM pRowWmDocto AS ROWID NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR RowErrors.

FIND FIRST wm-docto NO-LOCK
     WHERE rowid(wm-docto) = pRowWmDocto NO-ERROR.
IF NOT AVAIL wm-docto THEN DO:
    CREATE RowErrors.
    ASSIGN i-sequencia                  = i-sequencia + 1
           RowErrors.errorsequence      = i-sequencia
           RowErrors.errornumber        = 17006
           RowErrors.errordescription   = "Documento n∆o encontrado"
           RowErrors.errortype          = "error"
           RowErrors.ErrorSubType       = "ERROR":U
           RowErrors.errorhelp          = "Documento n∆o encontrado".

    RETURN "NOK".
END.

EMPTY TEMP-TABLE tt-etiqueta NO-ERROR.
EMPTY TEMP-TABLE tt-trans NO-ERROR.
ASSIGN i-cont      = 1
       i-cont-item = 1
       i-cont-qtde = 1
       iSeq        = 1.

FOR EACH wm-docto-itens OF wm-docto NO-LOCK
    BREAK BY substring(wm-docto-itens.char-2,100,10):

    IF FIRST-OF(substring(wm-docto-itens.char-2,100,10)) THEN DO:

        CREATE tt-etiqueta.
        ASSIGN tt-etiqueta.cod-versao-integracao = 1
               tt-etiqueta.i-sequen              = iSeq
               tt-etiqueta.qt-etiqueta           = 1 /* Quantidade de repetiá‰es por etiqueta */
               tt-etiqueta.cd-trans              = "WMOUT004"
               tt-etiqueta.tipo-etiq             = 0112
               tt-etiqueta.usuario               = c-seg-usuario
               tt-etiqueta.cod-estabel           = ""
               tt-etiqueta.it-codigo             = ""
               tt-etiqueta.lote                  = ""
               tt-etiqueta.quantidade            = 1
               tt-etiqueta.auxiliar-07           = wm-docto.num-docto
               tt-etiqueta.auxiliar-12           = wm-docto.num-docto
               iSeq                              = iSeq + 1.

    END.

    FIND FIRST wm-item NO-LOCK
         WHERE wm-item.cod-item = wm-docto-itens.cod-item NO-ERROR.

    ASSIGN tt-etiqueta.auxiliar-08  = substring(wm-docto-itens.char-2,131,50) 
           tt-etiqueta.auxiliar-09  = substring(wm-docto-itens.char-2,100,10) 
           tt-etiqueta.auxiliar-11  = substring(wm-docto-itens.char-2,111,20) .

    IF i-cont <= 09 THEN
        ASSIGN overlay(tt-etiqueta.auxiliar-01,i-cont-item ,60) = wm-docto-itens.cod-item + " - " + wm-item.des-item
               overlay(tt-etiqueta.auxiliar-04,i-cont-qtde ,07) = string(wm-docto-itens.qtd-item).

    IF i-cont >= 10 AND i-cont <= 18 THEN DO:
        ASSIGN overlay(tt-etiqueta.auxiliar-02,i-cont-item ,60) = wm-docto-itens.cod-item + " - " + wm-item.des-item
               overlay(tt-etiqueta.auxiliar-05,i-cont-qtde ,07) = string(wm-docto-itens.qtd-item).
    END.

    IF i-cont >= 19 THEN
        ASSIGN overlay(tt-etiqueta.auxiliar-03,i-cont-item ,60) = wm-docto-itens.cod-item + " - " + wm-item.des-item
               overlay(tt-etiqueta.auxiliar-06,i-cont-qtde ,07) = string(wm-docto-itens.qtd-item).

    IF LAST-OF(substring(wm-docto-itens.char-2,100,10)) THEN
        ASSIGN i-cont      = 1
               i-cont-item = 1
               i-cont-qtde = 1.
    ELSE DO:
        IF i-cont = 9 OR i-cont = 18 THEN
            ASSIGN i-cont      = i-cont + 1
                   i-cont-item = 1
                   i-cont-qtde = 1.
        ELSE 
            ASSIGN i-cont      = i-cont + 1
                   i-cont-item = i-cont-item + 60
                   i-cont-qtde = i-cont-qtde + 07.
    END.

    IF LAST-OF(substring(wm-docto-itens.char-2,100,10)) THEN DO:

        /* Se estiver configurado, imprime  */
        CREATE tt-trans.
        ASSIGN tt-trans.cod-versao-integracao = 1
               tt-trans.i-sequen              = tt-etiqueta.i-sequen
               tt-trans.cd-trans              = "WMOUT004"
               tt-trans.usuario               = c-seg-usuario
               tt-trans.atualizada            = NO
               tt-trans.etiqueta              = YES
               tt-trans.detalhe               = " Usuario: "  + String(c-seg-usuario)       + 
                                                " Data: "     + String(Today,'99/99/9999')  +
                                                " Hora: "     + String(time,'hh:mm:ss').
        RAW-TRANSFER tt-etiqueta TO tt-trans.conteudo-trans.
    END.
END.

//RUN pi-acompanhar IN h-acomp (INPUT "Gerando etiquetas: " + STRING(iSequencia) ).

RUN bcp/bcapi001.p (INPUT-OUTPUT TABLE tt-trans,
                    INPUT-OUTPUT TABLE tt-erro).
    
FIND FIRST tt-erro NO-ERROR.
IF AVAIL tt-erro THEN DO:
    CREATE RowErrors.
    ASSIGN i-sequencia                  = i-sequencia + 1
           RowErrors.errorsequence      = i-sequencia
           RowErrors.errornumber        = tt-erro.cd-erro
           RowErrors.errordescription   = tt-erro.mensagem
           RowErrors.errortype          = "error"
           RowErrors.ErrorSubType       = "ERROR":U
           RowErrors.errorhelp          = tt-erro.mensagem.

    RETURN "NOK".
END.

RETURN "OK":U.
