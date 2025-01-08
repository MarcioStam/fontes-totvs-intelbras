/*   Programa.: Esesb003.p                                                              */
/*   Fun‡Æo...: Utilizado para executar os programas com as mensagens para o Pollux.    */
/*              Deve ser chamado a partir de cada ponto/trigger do EMS que se deseja    */
/*              integrar com o barramento.                                              */
/*   Retorno..: Vai retornar Error-status e tamb‚m a temp-table com os eventuais erros  */
/*              retornados pelo barramento Pollux                                       */
/*                                                                                      */
CREATE WIDGET-POOL.

{esp/esb/esesb000.i}

DEFINE  INPUT PARAMETER cMensagem AS CHARACTER NO-UNDO.
DEFINE  INPUT PARAMETER rawtable  AS RAW       NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR resultado.

IF  cMensagem <> ? AND cMensagem <> '' THEN DO:

    IF SEARCH('esp/esb/out/' + cMensagem + '.p') <> ? 
    OR SEARCH('esp/esb/out/' + cMensagem + '.r') <> ? 
    THEN DO:

        RUN VALUE('esp/esb/out/' + cMensagem + '.p') (INPUT rawtable, OUTPUT TABLE resultado).

        IF  error-status:ERROR THEN 
            RETURN ERROR.
    END.

END.

RETURN. 
