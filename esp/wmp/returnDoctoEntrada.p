/*******************************************************************************************/
/* Autor.........: Carlos da Costa Junior                                                  */
/*                                                                                         */
/* Data..........: 22/11/2022                                                              */
/*                                                                                         */
/* Objetivo......:                          */
/*******************************************************************************************/
using esp.wmp.ReturnDocto.
{esp/es0018.i}
{esp/wmp/returnDoctoEntrada.i}
{METHOD/dbotterr.i}

DEF INPUT  PARAM pRowid     AS ROWID   NO-UNDO.
DEF OUTPUT PARAM p-erro     AS LOG     NO-UNDO.
DEF OUTPUT PARAM TABLE      FOR RowErrors.

def var oReturnDoctoEntrada      as ReturnDocto.

DEF VAR h-acomp             AS HANDLE   NO-UNDO.
DEF VAR cToken              AS CHAR     NO-UNDO.
DEF VAR cArquivoXML         AS CHAR     NO-UNDO.
DEF VAR cChaveAcesso        AS CHAR     NO-UNDO.
DEFINE VARIABLE l-erro AS LOGICAL       NO-UNDO.
DEFINE VARIABLE c-msg AS CHARACTER      NO-UNDO.

FIND FIRST wm-docto
    WHERE ROWID(wm-docto) = pRowid EXCLUSIVE-LOCK NO-ERROR.
IF AVAIL wm-docto THEN DO:

    RUN utp/ut-acomp.p persistent set h-acomp.
    RUN pi-inicializar in h-acomp (input "Retorno Protheus").
    RUN pi-acompanhar in h-acomp (input "Documento: " + wm-docto.num-docto).

    EMPTY TEMP-TABLE tt-docto-entrada.
    EMPTY TEMP-TABLE tt-docto-entrada-itens.
            
    RUN pi-acompanhar in h-acomp (input "Conectando WS... " + wm-docto.num-docto).
            
    CREATE tt-docto-entrada.
    ASSIGN tt-docto-entrada.numeroNotaFiscal = wm-docto.num-docto
           tt-docto-entrada.statusDocto      = "L".

    FOR EACH tt-prog-ponto:
        DELETE tt-prog-ponto.
    END.
    RUN esp/es0018p.p ( INPUT "wm-estab-api":U,
                        INPUT 1,
                        INPUT 0,
                        INPUT "":U,
                        OUTPUT TABLE tt-prog-ponto).
    IF CAN-FIND(FIRST tt-prog-ponto) THEN DO:
        FIND FIRST tt-prog-ponto
             WHERE ENTRY(2,tt-prog-ponto.conteudo,";") = wm-docto.cod-estabel NO-ERROR.
        IF AVAIL tt-prog-ponto THEN DO:
            ASSIGN tt-docto-entrada.filialNotaFiscal = string(ENTRY(1,tt-prog-ponto.conteudo,";")).
        END.
    END.

    ASSIGN tt-docto-entrada.serieNotaFiscal  = ENTRY(3,wm-docto.num-docto-origem,"-") NO-ERROR.
    ASSIGN tt-docto-entrada.codigoFornecedor = ENTRY(4,wm-docto.num-docto-origem,"-") NO-ERROR.

    FOR EACH wm-docto-itens OF wm-docto NO-LOCK:
        CREATE tt-docto-entrada-itens.
        ASSIGN tt-docto-entrada-itens.numeroItem    = STRING(wm-docto-itens.num-seq-item)
               tt-docto-entrada-itens.codigoProduto = wm-docto-itens.cod-item
               tt-docto-entrada-itens.quantidade    = wm-docto-itens.qtd-item.
    END.

    //Envia as informa‡äes para a Classe
    oReturnDoctoEntrada = NEW ReturnDocto().
    oReturnDoctoEntrada:returnDoctoEntrada(INPUT  TABLE tt-docto-entrada,
                                           INPUT  TABLE tt-docto-entrada-itens,
                                           OUTPUT l-erro,
                                           OUTPUT c-msg) NO-ERROR.
    delete object oReturnDoctoEntrada.
        
    RUN pi-acompanhar in h-acomp (input "Retorno WS... " + wm-docto.num-docto).

    ASSIGN p-erro = l-erro.

    //Se voltar com erro grava o Log
    IF l-erro THEN DO:
        CREATE RowErrors.
        ASSIGN RowErrors.errorNumber      = 17006
               RowErrors.errorDescription = c-msg.

    END. 
    ELSE
        ASSIGN OVERLAY(wm-docto.char-2,1,20) = string(TODAY,"99/99/9999") + " " + string(TIME,"HH:MM:SS").

END.

RUN pi-finalizar IN h-acomp.

IF l-erro = YES THEN
    RETURN "NOK":U.

RETURN "OK":U.
