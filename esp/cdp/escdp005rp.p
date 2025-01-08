/*{include/i-prgvrs.i escdp005 2.04.00.002}*/
/******************************************************************************
**       Programa: escdp005
**       Autor...: Anderson cenci
**       Objetivo: Ativa x Desativa Clientes sem faturamento nos ultimos 180 dias
**       Criacao : 17/10/2008
****************************************************************************** */
/*{esp/es0012.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

DEF input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.
{utp/ut-glob.i}
def temp-table tt-erro no-undo
    field i-sequen                as int
    field cd-erro                 as int
    field mensagem                as char format "x(255)".

DEF TEMP-TABLE rowerrors NO-UNDO    /* Temp-table dos erros */
    FIELD errorsequence           AS INT
    FIELD errornumber             AS INT
    FIELD errordescription        AS CHAR FORMAT "x(150)"
    FIELD errorparameters         AS CHAR
    FIELD errortype               AS CHAR
    FIELD errorhelp               AS CHAR FORMAT "x(150)"
    FIELD errorsubtype            AS CHAR.

DEF BUFFER b-emitente FOR emitente.
DEF BUFFER b2-emitente FOR emitente.
DEFINE VARIABLE h-acomp         AS HANDLE      NO-UNDO.
DEFINE VARIABLE l-inativa       AS LOGICAL     NO-UNDO.
/*OUTPUT TO value(session:TEMP-DIRECTORY + trim(c-seg-usuario) + "/" + "escdp005.txt"). */
OUTPUT TO value(c-dir-arquivo-session + trim(c-seg-usuario) + "/" + "escdp005.txt").
   RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
   RUN pi-inicializar IN h-acomp (INPUT "Imprimindo...").
               
   FOR EACH emitente NO-LOCK
      WHERE emitente.identific = 1 
         OR emitente.identific = 3:

       RUN pi-acompanhar IN h-acomp (INPUT "Lendo Cliente: " + STRING(emitente.cod-emitente)).

       IF (emitente.cod-gr-cli = 6 OR
           emitente.cod-gr-cli = 8) and
          emitente.natureza   = 1 THEN NEXT.

       FIND FIRST ponto-programa NO-LOCK 
            WHERE ponto-programa.nome-programa = "escdp005":U
              AND ponto-programa.ponto         = 1 NO-ERROR.
        
        IF AVAILABLE ponto-programa THEN DO:  /* chamado 79803*/
            IF CAN-FIND (FIRST conteudo-programa
                         WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa 
                           AND conteudo-programa.conteudo     = string(emitente.cod-emitente)) THEN 
                NEXT.
        END.  

      /* IF emitente.cod-emitente = 195035 OR
          emitente.cod-emitente = 195263 OR
          emitente.cod-emitente = 198486 OR
          emitente.cod-emitente = 198487 THEN NEXT. /* Plano OEM clientes fictcios */*/

        FIND FIRST ponto-programa
            WHERE ponto-programa.nome-programa = "escrm004":U
              AND ponto-programa.ponto         = 2 NO-LOCK NO-ERROR.
        
        IF AVAILABLE ponto-programa THEN DO:  /* chamado 59312 */
            IF can-find(first conteudo-programa NO-LOCK
                WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa 
                  AND emitente.cgc BEGINS ENTRY(1,conteudo-programa.conteudo,",")) THEN NEXT.
        END.

       FIND LAST int-emitente-historico
            WHERE int-emitente-historico.cod-emitente = emitente.cod-emitente
            NO-LOCK NO-ERROR.
       
       IF AVAIL INT-emitente-historico AND 
          int-emitente-historico.dt-movto > TODAY - 180 THEN NEXT.

       IF emitente.data-implant <= TODAY - 180 THEN DO:
           FIND b-emitente
               WHERE b-emitente.nome-abrev = emitente.nome-matriz
               NO-LOCK NO-ERROR.
           /*Somente altera registros implantados com mais de 180 dias*/
           FIND FIRST int-emitente
                WHERE int-emitente.cod-emitente = emitente.cod-emitente EXCLUSIVE-LOCK NO-ERROR.
           IF NOT AVAIL int-emitente  THEN DO:
               PUT "int-emitente nÆo encontrado " emitente.cod-emitente " " emitente.nome-emit SKIP.
           END.
           ELSE DO:
               ASSIGN l-inativa = YES.
               IF CAN-FIND(FIRST tit_acr NO-LOCK
                           WHERE tit_acr.cod_empresa    = "1"
                             AND tit_acr.cdn_cliente    = emitente.cod-emitente
                             AND tit_acr.dat_emis_docto >= TODAY - 180) OR 
                  CAN-FIND(FIRST tit_acr_cobr_especial NO-LOCK
                           WHERE tit_acr_cobr_especial.cod_empresa    = "1"
                             AND tit_acr_cobr_especial.cdn_cliente    = emitente.cod-emitente
                             AND tit_acr_cobr_especial.dat_emis_docto >= TODAY - 180) THEN DO:
                   ASSIGN l-inativa = NO.
               END.
               ELSE DO:
                   IF CAN-FIND(FIRST tit_acr NO-LOCK
                               WHERE tit_acr.cod_empresa    = "3"
                                 AND tit_acr.cdn_cliente    = emitente.cod-emitente
                                 AND tit_acr.dat_emis_docto >= TODAY - 180) OR 
                      CAN-FIND(FIRST tit_acr_cobr_especial NO-LOCK
                               WHERE tit_acr_cobr_especial.cod_empresa    = "3"
                                 AND tit_acr_cobr_especial.cdn_cliente    = emitente.cod-emitente
                                 AND tit_acr_cobr_especial.dat_emis_docto >= TODAY - 180) THEN DO:
                       ASSIGN l-inativa = NO.
                   END.
                   ELSE DO:
                       IF CAN-FIND(FIRST tit_acr NO-LOCK
                                   WHERE tit_acr.cod_empresa    = "1"
                                     AND tit_acr.cdn_cliente    = b-emitente.cod-emitente
                                     AND tit_acr.dat_emis_docto >= TODAY - 180) OR 
                          CAN-FIND(FIRST tit_acr_cobr_especial NO-LOCK
                                   WHERE tit_acr_cobr_especial.cod_empresa    = "1"
                                     AND tit_acr_cobr_especial.cdn_cliente    = b-emitente.cod-emitente
                                     AND tit_acr_cobr_especial.dat_emis_docto >= TODAY - 180) THEN DO:
                           ASSIGN l-inativa = NO.
                       END.
                       ELSE DO:
                           IF CAN-FIND(FIRST tit_acr NO-LOCK
                                       WHERE tit_acr.cod_empresa    = "3"
                                         AND tit_acr.cdn_cliente    = b-emitente.cod-emitente
                                         AND tit_acr.dat_emis_docto >= TODAY - 180) OR 
                              CAN-FIND(FIRST tit_acr_cobr_especial NO-LOCK
                                       WHERE tit_acr_cobr_especial.cod_empresa    = "3"
                                         AND tit_acr_cobr_especial.cdn_cliente    = b-emitente.cod-emitente
                                         AND tit_acr_cobr_especial.dat_emis_docto >= TODAY - 180) THEN DO:
                               ASSIGN l-inativa = NO.
                           END.
                           ELSE DO:
                               IF CAN-FIND(FIRST tit_acr NO-LOCK
                                           WHERE tit_acr.cod_empresa    = "1"
                                             AND tit_acr.cdn_cliente    = emitente.end-cobranca
                                             AND tit_acr.dat_emis_docto >= TODAY - 180) OR 
                                  CAN-FIND(FIRST tit_acr_cobr_especial NO-LOCK
                                           WHERE tit_acr_cobr_especial.cod_empresa    = "1"
                                             AND tit_acr_cobr_especial.cdn_cliente    = emitente.end-cobranca
                                             AND tit_acr_cobr_especial.dat_emis_docto >= TODAY - 180) THEN DO:
                                   ASSIGN l-inativa = NO.
                               END.
                               ELSE DO:
                                   IF CAN-FIND(FIRST tit_acr NO-LOCK
                                               WHERE tit_acr.cod_empresa    = "3"
                                                 AND tit_acr.cdn_cliente    = emitente.end-cobranca
                                                 AND tit_acr.dat_emis_docto >= TODAY - 180) OR 
                                      CAN-FIND(FIRST tit_acr_cobr_especial NO-LOCK
                                               WHERE tit_acr_cobr_especial.cod_empresa    = "3"
                                                 AND tit_acr_cobr_especial.cdn_cliente    = emitente.end-cobranca
                                                 AND tit_acr_cobr_especial.dat_emis_docto >= TODAY - 180) THEN DO:
                                       ASSIGN l-inativa = NO.
                                   END.
                               END.
                           END.
                       END.
                   END.
               END.
               IF l-inativa = YES THEN DO:
                   IF int-emitente.id-ativo = YES THEN DO:
                       /*ASSIGN int-emitente.id-ativo = NO.*/
                       FIND b2-emitente
                            WHERE b2-emitente.cod-emitente = emitente.cod-emitente
                            EXCLUSIVE-LOCK NO-ERROR.
                       IF AVAIL b2-emitente THEN
                          ASSIGN b2-emitente.ind-cre-cli   = 4
                                 b2-emitente.lim-credito   = 0
                                 b2-emitente.lim-adicional = 0
                                 b2-emitente.observacoes = b2-emitente.observacoes + " Suspenso por Inatividade " + STRING(TODAY, "99/99/9999").
                       PUT "Cliente Desativado " emitente.cod-emitente " " emitente.nome-emit SKIP.
                       RUN CriaHistorico(INPUT "Cliente NÆo Comprou a mais de 180 dias",
                                         INPUT NO).
                   END.
               END.

           END.                
       END.
   END.

   OUTPUT CLOSE.
   RUN pi-finalizar IN h-acomp.
hide message no-pause.
RETURN "OK".

PROCEDURE CriaHistorico:
    DEF INPUT PARAMETER c-motivo    AS CHARACTER.
    DEF INPUT PARAMETER l-ativo     AS LOGICAL.
    DEFINE VARIABLE     i-sequencia AS INTEGER     NO-UNDO.
    FIND LAST int-emitente-historico
         WHERE int-emitente-historico.cod-emitente = emitente.cod-emitente
         NO-LOCK NO-ERROR.
    IF NOT AVAIL INT-emitente-historico THEN 
        ASSIGN i-sequencia = 1.
    ELSE
        ASSIGN i-sequencia = int-emitente-historico.sequencia + 1.

    CREATE int-emitente-historico.
    ASSIGN int-emitente-historico.cod-emitente = emitente.cod-emitente
           int-emitente-historico.sequencia    = i-sequencia
           int-emitente-historico.dt-movto     = TODAY
           int-emitente-historico.hr-movto     = STRING(TIME,"HH:MM:SS")
           int-emitente-historico.id-ativo     = l-ativo
           int-emitente-historico.motivo       = c-motivo
           int-emitente-historico.usuario      = "Sistema"
           int-emitente-historico.tipo         = 1.
END PROCEDURE.
*/


/*{include/i-prgvrs.i escdp005 2.04.00.002}*/
/******************************************************************************
**       Programa: escdp005
**       Autor...: Anderson cenci
**       Objetivo: Ativa x Desativa Clientes sem faturamento nos ultimos 180 dias
**       Criacao : 17/10/2008
****************************************************************************** */
//{esp/es0012.i}
define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    FIELD grupo-cli-ini    AS CHAR
    FIELD grupo-cli-fim    AS CHAR
    FIELD tipo             AS INT.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
   field raw-digita      as raw.




{esp/es0043.i} /* <--- c-dir-arquivo-session  */

DEF input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.
{utp/ut-glob.i}
def temp-table tt-erro no-undo
    field i-sequen                as int
    field cd-erro                 as int
    field mensagem                as char format "x(255)".

DEF TEMP-TABLE rowerrors NO-UNDO    /* Temp-table dos erros */
    FIELD errorsequence           AS INT
    FIELD errornumber             AS INT
    FIELD errordescription        AS CHAR FORMAT "x(150)"
    FIELD errorparameters         AS CHAR
    FIELD errortype               AS CHAR
    FIELD errorhelp               AS CHAR FORMAT "x(150)"
    FIELD errorsubtype            AS CHAR.

DEF BUFFER b-emitente  FOR emitente.
DEF BUFFER b2-emitente FOR emitente.
DEFINE VARIABLE h-acomp   AS HANDLE      NO-UNDO.
DEFINE VARIABLE l-inativa AS LOGICAL     NO-UNDO.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-LOCK NO-ERROR.

/*OUTPUT TO value(session:TEMP-DIRECTORY + trim(c-seg-usuario) + "/" + "escdp005.txt"). */
OUTPUT TO value(c-dir-arquivo-session + trim(c-seg-usuario) + "/" + "escdp005.txt").
   RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
   RUN pi-inicializar IN h-acomp (INPUT "Imprimindo...").

   FOR EACH emitente NO-LOCK 
      WHERE (emitente.identific = 1 
         OR  emitente.identific = 3)
       AND emitente.cod-gr-cli >= int(tt-param.grupo-cli-ini)
       AND emitente.cod-gr-cli <= int(tt-param.grupo-cli-fim):

       IF emitente.natureza = 1 THEN NEXT. //natureza = 1 pessoa fisica
       
       RUN pi-acompanhar IN h-acomp (INPUT "Lendo Cliente: " + STRING(emitente.cod-emitente)).

       IF (emitente.cod-gr-cli = 6 OR
           emitente.cod-gr-cli = 8) and
          emitente.natureza   = 1 THEN NEXT.

       FIND FIRST ponto-programa NO-LOCK 
            WHERE ponto-programa.nome-programa = "escdp005":U
              AND ponto-programa.ponto         = 1 NO-ERROR.
        
        IF AVAILABLE ponto-programa THEN DO:  /* chamado 79803*/
            IF CAN-FIND (FIRST conteudo-programa
                         WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa 
                           AND conteudo-programa.conteudo     = string(emitente.cod-emitente)) THEN 
                NEXT.
        END.  

        /* IF emitente.cod-emitente = 195035 OR
          emitente.cod-emitente = 195263 OR
          emitente.cod-emitente = 198486 OR
          emitente.cod-emitente = 198487 THEN NEXT. /* Plano OEM clientes fictcios */*/

        FIND FIRST ponto-programa
             WHERE ponto-programa.nome-programa = "escrm004":U
               AND ponto-programa.ponto         = 2 NO-LOCK NO-ERROR.
        
        IF AVAILABLE ponto-programa THEN DO:  /* chamado 59312 */
            IF can-find(first conteudo-programa NO-LOCK
                WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa 
                  AND emitente.cgc BEGINS ENTRY(1,conteudo-programa.conteudo,",")) THEN NEXT.
        END.

       FIND LAST int-emitente-historico
           WHERE int-emitente-historico.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
       
       IF AVAIL INT-emitente-historico AND 
          int-emitente-historico.dt-movto > TODAY - 180 THEN NEXT.

       IF emitente.data-implant <= TODAY - 180 THEN DO:

           /* FIND b-emitente
               WHERE b-emitente.nome-abrev = emitente.nome-matriz NO-LOCK NO-ERROR. */
           /*Somente altera registros implantados com mais de 180 dias*/
           FIND FIRST int-emitente
                WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
           IF NOT AVAIL int-emitente  THEN DO:
               PUT "int-emitente nÆo encontrado " emitente.cod-emitente " " emitente.nome-emit SKIP.
           END.
           ELSE DO:
               ASSIGN l-inativa = YES.
               IF CAN-FIND(FIRST tit_acr NO-LOCK
                           WHERE tit_acr.cod_empresa    = "1"
                             AND tit_acr.cdn_cliente    = emitente.cod-emitente
                             AND tit_acr.dat_emis_docto >= TODAY - 180) OR 
                  CAN-FIND(FIRST tit_acr_cobr_especial NO-LOCK
                           WHERE tit_acr_cobr_especial.cod_empresa    = "1"
                             AND tit_acr_cobr_especial.cdn_cliente    = emitente.cod-emitente
                             AND tit_acr_cobr_especial.dat_emis_docto >= TODAY - 180) THEN DO:
                   ASSIGN l-inativa = NO.
                  
               END.
               ELSE DO:
                   IF CAN-FIND(FIRST tit_acr NO-LOCK
                               WHERE tit_acr.cod_empresa    = "3"
                                 AND tit_acr.cdn_cliente    = emitente.cod-emitente
                                 AND tit_acr.dat_emis_docto >= TODAY - 180) OR 
                      CAN-FIND(FIRST tit_acr_cobr_especial NO-LOCK
                               WHERE tit_acr_cobr_especial.cod_empresa    = "3"
                                 AND tit_acr_cobr_especial.cdn_cliente    = emitente.cod-emitente
                                 AND tit_acr_cobr_especial.dat_emis_docto >= TODAY - 180) THEN DO:
                       ASSIGN l-inativa = NO.
                      
                   END.
                   ELSE DO:
                       /*IF CAN-FIND(FIRST tit_acr NO-LOCK
                                   WHERE tit_acr.cod_empresa    = "1"
                                     AND tit_acr.cdn_cliente    = b-emitente.cod-emitente
                                     AND tit_acr.dat_emis_docto >= TODAY - 180) OR 
                          CAN-FIND(FIRST tit_acr_cobr_especial NO-LOCK
                                   WHERE tit_acr_cobr_especial.cod_empresa    = "1"
                                     AND tit_acr_cobr_especial.cdn_cliente    = b-emitente.cod-emitente
                                     AND tit_acr_cobr_especial.dat_emis_docto >= TODAY - 180) THEN DO:
                           ASSIGN l-inativa = NO.
                       END.
                       ELSE DO:
                           IF CAN-FIND(FIRST tit_acr NO-LOCK
                                       WHERE tit_acr.cod_empresa    = "3"
                                         AND tit_acr.cdn_cliente    = b-emitente.cod-emitente
                                         AND tit_acr.dat_emis_docto >= TODAY - 180) OR 
                              CAN-FIND(FIRST tit_acr_cobr_especial NO-LOCK
                                       WHERE tit_acr_cobr_especial.cod_empresa    = "3"
                                         AND tit_acr_cobr_especial.cdn_cliente    = b-emitente.cod-emitente
                                         AND tit_acr_cobr_especial.dat_emis_docto >= TODAY - 180) THEN DO:
                               ASSIGN l-inativa = NO.
                           END. 
                           ELSE DO: */
                               IF CAN-FIND(FIRST tit_acr NO-LOCK
                                           WHERE tit_acr.cod_empresa    = "1"
                                             AND tit_acr.cdn_cliente    = emitente.end-cobranca
                                             AND tit_acr.dat_emis_docto >= TODAY - 180) OR 
                                  CAN-FIND(FIRST tit_acr_cobr_especial NO-LOCK
                                           WHERE tit_acr_cobr_especial.cod_empresa    = "1"
                                             AND tit_acr_cobr_especial.cdn_cliente    = emitente.end-cobranca
                                             AND tit_acr_cobr_especial.dat_emis_docto >= TODAY - 180) THEN DO:
                                   ASSIGN l-inativa = NO.
                                   
                               END.
                               ELSE DO:
                                   IF CAN-FIND(FIRST tit_acr NO-LOCK
                                               WHERE tit_acr.cod_empresa    = "3"
                                                 AND tit_acr.cdn_cliente    = emitente.end-cobranca
                                                 AND tit_acr.dat_emis_docto >= TODAY - 180) OR 
                                      CAN-FIND(FIRST tit_acr_cobr_especial NO-LOCK
                                               WHERE tit_acr_cobr_especial.cod_empresa    = "3"
                                                 AND tit_acr_cobr_especial.cdn_cliente    = emitente.end-cobranca
                                                 AND tit_acr_cobr_especial.dat_emis_docto >= TODAY - 180) THEN DO:
                                       ASSIGN l-inativa = NO.
                                      
                                   END.
                               END.
                      //     END.
                      // END.
                   END.
               END.
               //MESSAGE l-inativa
               //    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
               IF l-inativa = YES THEN DO:
                   IF int-emitente.id-ativo = YES THEN DO:

                       IF tt-param.tipo = 2 THEN DO: //atualizacao
                           FIND CURRENT int-emitente EXCLUSIVE-LOCK NO-ERROR.
                           ASSIGN int-emitente.id-ativo = NO.
                           FIND CURRENT int-emitente NO-LOCK NO-ERROR.

                           FIND b2-emitente
                                WHERE b2-emitente.cod-emitente = emitente.cod-emitente EXCLUSIVE-LOCK NO-ERROR.
                           IF AVAIL b2-emitente THEN
                              ASSIGN b2-emitente.ind-cre-cli   = 4
                                     b2-emitente.lim-credito   = 0
                                     b2-emitente.lim-adicional = 0
                                     b2-emitente.observacoes = b2-emitente.observacoes + " Suspenso por Inatividade " + STRING(TODAY, "99/99/9999").
                        
                           PUT "Cliente Desativado " emitente.cod-emitente " " emitente.nome-emit SKIP.
                        
                           RUN CriaHistorico(INPUT "Cliente NÆo Comprou a mais de 180 dias",
                                             INPUT NO).
                        
                           FIND CURRENT b2-emitente NO-LOCK NO-ERROR.
                           RELEASE b2-emitente.

                       END.
                       ELSE DO: // apenas relatorio
                           DISP emitente.cod-emitente
                                emitente.nome-emit 
                                emitente.cod-gr-cli WITH WIDTH 300.
                       END.
                   END.
               END.
           END.                
       END.
   END. 

   OUTPUT CLOSE.
   RUN pi-finalizar IN h-acomp.
hide message no-pause.
RETURN "OK".

PROCEDURE CriaHistorico:
    DEF INPUT PARAMETER c-motivo    AS CHARACTER.
    DEF INPUT PARAMETER l-ativo     AS LOGICAL.
    DEFINE VARIABLE     i-sequencia AS INTEGER     NO-UNDO.

    FIND LAST int-emitente-historico
         WHERE int-emitente-historico.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
    IF NOT AVAIL INT-emitente-historico THEN 
        ASSIGN i-sequencia = 1.
    ELSE
        ASSIGN i-sequencia = int-emitente-historico.sequencia + 1.

    CREATE int-emitente-historico.
    ASSIGN int-emitente-historico.cod-emitente = emitente.cod-emitente
           int-emitente-historico.sequencia    = i-sequencia
           int-emitente-historico.dt-movto     = TODAY
           int-emitente-historico.hr-movto     = STRING(TIME,"HH:MM:SS")
           int-emitente-historico.id-ativo     = l-ativo
           int-emitente-historico.motivo       = c-motivo
           int-emitente-historico.usuario      = "Sistema"
           int-emitente-historico.tipo         = 1.
END PROCEDURE.


