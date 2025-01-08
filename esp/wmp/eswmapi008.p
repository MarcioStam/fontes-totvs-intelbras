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

DEF INPUT PARAM p-fi-nr-volume AS INT NO-UNDO.
DEFINE INPUT  PARAM pRowWmDocto AS ROWID NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR RowErrors.

DEF VAR lErro       AS LOG NO-UNDO.
DEF VAR iSequencia AS INT NO-UNDO.
DEFINE VARIABLE i-sequencia AS INTEGER NO-UNDO.
DEFINE VARIABLE iSeq  AS INTEGER     NO-UNDO.

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
    
IF p-fi-nr-volume = 0 THEN DO:
    CREATE RowErrors.
    ASSIGN i-sequencia                  = i-sequencia + 1
           RowErrors.errorsequence      = i-sequencia
           RowErrors.errornumber        = 17006
           RowErrors.errordescription   = "Documento n∆o conferido"
           RowErrors.errortype          = "error"
           RowErrors.ErrorSubType       = "ERROR":U
           RowErrors.errorhelp          = "Documento n∆o conferido".

    RETURN "NOK".
END.

EMPTY TEMP-TABLE tt-etiqueta NO-ERROR.
REPEAT iSequencia = 1 TO p-fi-nr-volume:

    CREATE tt-etiqueta.
    ASSIGN tt-etiqueta.cod-versao-integracao = 1
           tt-etiqueta.i-sequen              = iSequencia
           tt-etiqueta.qt-etiqueta           = 1 /* Quantidade de repetiªÑes por etiqueta */
           tt-etiqueta.cd-trans              = "WMOUT004"
           tt-etiqueta.tipo-etiq             = 0106
           tt-etiqueta.usuario               = c-seg-usuario
           tt-etiqueta.cod-estabel           = wm-docto.cod-estabel
           tt-etiqueta.it-codigo             = ""
           tt-etiqueta.lote                  = ""
           tt-etiqueta.quantidade            = 1
           tt-etiqueta.auxiliar-01           = SUBSTRING(Wm-docto.char-2,161,30)    // Cidade - Estado
           tt-etiqueta.auxiliar-02           = SUBSTRING(Wm-docto.char-2,131,30)    // Nome Transportadora
           tt-etiqueta.auxiliar-03           = SUBSTRING(Wm-docto.char-2,100,30)    // Nome Cliente
           tt-etiqueta.auxiliar-04           = string(iSequencia,"999") + " / " + string(p-fi-nr-volume,"999")
           tt-etiqueta.auxiliar-05           = wm-docto.num-docto.

    //RUN pi-acompanhar IN h-acomp (INPUT "Gerando etiquetas: " + STRING(iSequencia) ).

    /* Se estiver configurado, imprime  */
    EMPTY TEMP-TABLE tt-trans NO-ERROR.
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
END.
