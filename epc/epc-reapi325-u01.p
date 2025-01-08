
/*------------------------------------------------------------------------------------------------
Programa...: epc-reapi325-u01.p
Author.....: JULIANO
Descricao..: EPC Principal
Data.......: MAIO/2023
 

------------------------------------------------------------------------------------------------*/

{include/i-prgvrs.i epc-reapi325-u01 2.04.00.000} 
{utp/ut-glob.i}

{include/i-epc200.i reapi325}
/* Definiá∆o de parÉmetros de entrada */
DEF INPUT PARAM p-ind-event AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.

DEF BUFFER b-docto-orig-cte FOR docto-orig-cte.

DEF VAR l-cte-saida         AS LOG  NO-UNDO.
DEF VAR l-ok                AS LOG  NO-UNDO.
DEF VAR l-processou         AS LOG  NO-UNDO.
DEF VAR c-chave             AS CHAR NO-UNDO.
DEF VAR c-serie             AS CHAR NO-UNDO.
DEF VAR c-nota              AS CHAR NO-UNDO.  
DEF VAR l-cte-dev           AS LOG  NO-UNDO.
DEF VAR l-cte-log           AS LOG  NO-UNDO.
DEF VAR c-tipo-entrada      AS CHAR NO-UNDO.
DEF VAR iCont               AS INT  NO-UNDO.
DEF VAR c-estab-ini         AS CHAR NO-UNDO.
DEF VAR c-estab-fim         AS CHAR NO-UNDO.
DEF VAR c-cnpj              AS CHAR NO-UNDO.
DEF VAR l-recebe-automatico AS LOG  NO-UNDO.

DEF VAR h-esreapi0708  AS HANDLE.

IF p-ind-event = "RateioNatureza"  THEN
   DO:

    IF NOT VALID-HANDLE(h-esreapi0708) THEN
       RUN upc/esreapi0708.p PERSISTENT SET h-esreapi0708.

      FIND FIRST tt-epc WHERE 
                 tt-epc.cod-event = p-ind-event       AND
                 tt-epc.cod-param = "rowid_docto-orig-cte" NO-ERROR.
      IF NOT AVAIL tt-epc THEN RETURN.

      FIND FIRST docto-orig-cte NO-LOCK WHERE
          ROWID( docto-orig-cte ) = TO-ROWID( tt-epc.val-parameter ) NO-ERROR.

      FIND FIRST emitente NO-LOCK
           WHERE emitente.cod-emitente = docto-orig-cte.cod-emitente NO-ERROR.

      ASSIGN l-recebe-automatico = SUBSTRING(emitente.char-1,6,1) = "S":U.

      IF AVAIL docto-orig-cte AND l-recebe-automatico THEN DO:

          IF CAN-FIND(FIRST int-natur-gener-cte
                      WHERE int-natur-gener-cte.nat-operacao = docto-orig-cte.nat-operacao
                        AND int-natur-gener-cte.log-ativo) THEN DO:

             IF NOT CAN-FIND(FIRST rat-docto-orig-cte 
                             WHERE rat-docto-orig-cte.cod-aces-comp-nfe = docto-orig-cte.cod-aces-comp-nfe
                               AND rat-docto-orig-cte.idi-orig-trad     = docto-orig-cte.idi-orig-trad) THEN DO:



                  FOR FIRST rat-docto-orig-cte NO-LOCK 
                      WHERE rat-docto-orig-cte.cod-aces-comp-nfe = docto-orig-cte.cod-aces-comp-nfe
                        AND rat-docto-orig-cte.idi-orig-trad     = 1:

                      RUN pi-define-tipo-entrada IN h-esreapi0708(INPUT ROWID(docto-orig-cte),
                                                                  INPUT ROWID(rat-docto-orig-cte),
                                                                  OUTPUT l-cte-dev,               
                                                                  OUTPUT l-cte-saida,             
                                                                  OUTPUT l-cte-log).

                  END.
             END.
             ELSE DO:
                 FOR FIRST rat-docto-orig-cte NO-LOCK 
                     WHERE rat-docto-orig-cte.cod-aces-comp-nfe = docto-orig-cte.cod-aces-comp-nfe
                       AND rat-docto-orig-cte.idi-orig-trad     = docto-orig-cte.idi-orig-trad:

                     RUN pi-define-tipo-entrada IN h-esreapi0708(INPUT ROWID(docto-orig-cte),
                                                                 INPUT ROWID(rat-docto-orig-cte),
                                                                 OUTPUT l-cte-dev,               
                                                                 OUTPUT l-cte-saida,             
                                                                 OUTPUT l-cte-log).

                 END.
             END.

          END.
          ELSE DO:
               PUT "Natureza Generica n∆o Cadastrada, n∆o localizada NO cadastro generico: " + docto-orig-cte.nat-operacao FORMAT "X(200)" SKIP.

               ASSIGN  l-cte-saida  = NO
                       l-cte-dev    = NO
                       l-cte-log    = NO.
          END.
           ASSIGN c-tipo-entrada = "".
           IF l-cte-saida THEN ASSIGN c-tipo-entrada = "l-cte-saida".
           IF l-cte-dev   THEN ASSIGN c-tipo-entrada = "l-cte-dev".
           IF l-cte-log   THEN ASSIGN c-tipo-entrada = "l-cte-log".

           IF c-tipo-entrada <> "" THEN DO:
               RUN pi-gera-docto-recebimento IN h-esreapi0708(INPUT  ROWID(docto-orig-cte),
                                                              INPUT  c-tipo-entrada,
                                                              OUTPUT l-processou).

               IF VALID-HANDLE(h-esreapi0708) THEN DO:

                   DELETE PROCEDURE h-esreapi0708.
                   ASSIGN h-esreapi0708 = ?.
               END.           
           END.
      END.           
      
      IF VALID-HANDLE(h-esreapi0708) THEN DO:
          DELETE PROCEDURE h-esreapi0708.
          ASSIGN h-esreapi0708 = ?.
      END.
END.
