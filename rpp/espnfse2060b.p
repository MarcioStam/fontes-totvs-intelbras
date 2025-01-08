/**************************************************************************************************
** PROGRAMA...: ESPNFSE2060B - Abre IE para consultar NFSe no portal da prefeitura
**              utilizado pela UPC do FT0904 e FT0502
** AUTOR......: Ivonei Vock
** DATA.......: 19/03/2012
/**ATUALIZACAO: 20/03/2012**/
**************************************************************************************************/

DEF NEW GLOBAL SHARED VAR r-nota-fiscal_ft0502 AS ROWID                NO-UNDO.
DEF VAR chBrowserApplication                   AS COM-HANDLE           NO-UNDO.
DEF VAR p-url-consulta                         AS CHAR FORMAT "x(256)" NO-UNDO.
DEF VAR p-mensagem-ret                         AS CHAR FORMAT "x(256)" NO-UNDO.

/**REGRA: retorna url de consulta**/
RUN rpp/espnfse2060a.p (INPUT r-nota-fiscal_ft0502,
                        OUTPUT p-url-consulta,
                        OUTPUT p-mensagem-ret).

/**REGRA: nao encontrou nota fiscal para o rowid**/
IF  p-url-consulta = "" AND
    p-mensagem-ret = "" THEN DO:

    RUN utp/ut-msgs.p (INPUT "show":U,
                       INPUT 17006,
                       INPUT "NÆo foi localizada Nota Fiscal." + "~~" + "Verifique se existe a nota fiscal, se existe relacionamento v lido para o estabelecimento da nota fiscal e, se existe um relacionamento v lido para cidade/estado do estabelecimento.").
    RETURN "NOK":U.
END.

/**REGRA: nao encontrou URL**/
IF  p-mensagem-ret <> "" THEN DO:

    RUN utp/ut-msgs.p (INPUT "show":U,
                       INPUT 17006,
                       INPUT "Problema com URL." + "~~" + p-mensagem-ret).
    RETURN "NOK":U.
END.

/**REGRA: abre Browser IE com o url de consulta**/
IF  p-url-consulta <> "" THEN DO:
    CREATE "InternetExplorer.Application" chBrowserApplication.
    chBrowserApplication:VISIBLE = TRUE.
    chBrowserApplication:Navigate (p-url-consulta).
END.

RETURN "OK":U.
