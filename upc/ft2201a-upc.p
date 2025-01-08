/***********************************************************
**
** Altera situaÁ„o da nota para documento rejeitado antes de inutilizar
**
**************************************************************/
{esp/es0018.i}
{utp/ut-glob.i}
DEF NEW GLOBAL SHARED VAR wh-old-button as widget-handle no-undo.
DEFINE NEW GLOBAL SHARED VAR wh-nota             AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wh-serie            AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wh-cod-estabel      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wgh-protocolo-siare AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wgh-dt-cancela      AS WIDGET-HANDLE NO-UNDO.

DEF BUFFER bf-gati-nfe-siare FOR gati-nfe-siare.

DEFINE VARIABLE c-cod-estabel AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-serie       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nota-ini    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nota-fim    AS CHARACTER   NO-UNDO.

ASSIGN c-cod-estabel = wh-cod-estabel:SCREEN-VALUE 
       c-serie       = wh-serie:SCREEN-VALUE
       c-nota-ini    = wh-nota:SCREEN-VALUE.

FIND FIRST estabelec NO-LOCK
     WHERE estabelec.cod-estabel = c-cod-estabel NO-ERROR.

EMPTY TEMP-TABLE tt-prog-ponto.
RUN esp/es0018p.p (INPUT "ft2200rp", /* Nome do programa */
                   INPUT 3,         /* Ponto do programa */
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto) NO-ERROR.


IF NOT CAN-FIND (FIRST tt-prog-ponto
                 WHERE tt-prog-ponto.conteudo = c-seg-usuario) THEN DO:

    FOR FIRST nota-fiscal NO-LOCK
        WHERE nota-fiscal.cod-estabel = c-cod-estabel
          AND nota-fiscal.serie       = c-serie
          AND nota-fiscal.nr-nota-fis = c-nota-ini:
    
        IF MONTH(TODAY) <> MONTH(nota-fiscal.dt-emis) THEN DO:
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "Cancelamento n∆o permitido! ~~ Màs de emiss∆o da nota diferente do màs de cancelamento.").
            RETURN "NOK".
        END.
    END.
END.


EMPTY TEMP-TABLE tt-prog-ponto.
RUN esp/es0018p.p (INPUT "ft2200rp", /* Nome do programa */
                   INPUT 4,         /* Ponto do programa */
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto) NO-ERROR. //entreposto

IF NOT CAN-FIND (FIRST tt-prog-ponto
                 WHERE tt-prog-ponto.conteudo = c-seg-usuario) THEN DO:

    IF c-cod-estabel = "105" AND c-serie = "3" THEN DO:
        
       FOR FIRST nota-fiscal NO-LOCK
           WHERE nota-fiscal.cod-estabel = c-cod-estabel
             AND nota-fiscal.serie       = c-serie
             AND nota-fiscal.nr-nota-fis = c-nota-ini:
           
             RUN utp/ut-msgs.p (INPUT "show",
                                INPUT 17006,
                                INPUT "Cancelamento n∆o permitido! ~~ Nota do entreposto, Favor procurar o Grupo Fiscal Manaus ou Grupo Tributario.").
             RETURN "NOK".
       END.
    END.
END.



IF AVAIL estabelec AND
   estabelec.estado = "MG" AND
   wgh-protocolo-siare:SCREEN-VALUE <> "" THEN DO:
   FOR FIRST nota-fiscal NO-LOCK
       WHERE nota-fiscal.cod-estabel = c-cod-estabel
       AND   nota-fiscal.serie       = c-serie
       AND   nota-fiscal.nr-nota-fis = c-nota-ini:
      FIND FIRST bf-gati-nfe-siare NO-LOCK
           WHERE bf-gati-nfe-siare.cod-estabel  = c-cod-estabel
             AND bf-gati-nfe-siare.serie        = c-serie      
             AND bf-gati-nfe-siare.nr-nota-fis  = c-nota-ini NO-ERROR.
      IF NOT AVAIL bf-gati-nfe-siare THEN DO:
         FIND FIRST gati-nfe-siare NO-LOCK
              WHERE gati-nfe-siare.nr-protocolo = wgh-protocolo-siare:SCREEN-VALUE NO-ERROR.
         IF NOT AVAIL gati-nfe-siare THEN DO:
            CREATE gati-nfe-siare.
            ASSIGN gati-nfe-siare.cod-estabel    = c-cod-estabel
                   gati-nfe-siare.serie          = c-serie      
                   gati-nfe-siare.nr-nota-fis    = c-nota-ini
                   gati-nfe-siare.nat-operacao   = nota-fiscal.nat-operacao
                   gati-nfe-siare.nr-protocolo   = wgh-protocolo-siare:SCREEN-VALUE
                   gati-nfe-siare.usuario        = c-seg-usuario.
         END.
         ELSE DO:
            MESSAGE "J† existe este numero de protocolo para outra nota."
               VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN "NOK".
         END.
      END.
      /*ELSE DO:
         MESSAGE "J† existe protocolo para esta nota."
             VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN "NOK".
      END.*/
   END.
END.

APPLY "CHOOSE" TO wh-old-button.


   
