{esp/es0018.i}
{method/dbotterr.i}
DEFINE STREAM str-excel.

DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-arq-excel   AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-campo     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-valor-old AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-valor-new AS CHARACTER   NO-UNDO.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    FIELD cod-estab-ini    AS CHAR
    FIELD cod-estab-fim    AS CHAR
    FIELD dt-implant-ini   AS DATE
    FIELD dt-implant-fim   AS DATE
    FIELD cod-emitente-ini AS INT
    FIELD cod-emitente-fim AS INT
    FIELD tp-pedido-ini    AS CHAR
    FIELD tp-pedido-fim    AS CHAR
    FIELD cod-priori-ini   AS INT
    FIELD cod-priori-fim   AS INT
    FIELD repres-de        AS CHAR
    FIELD repres-para      AS CHAR
    FIELD alterar-campo    AS INT
    FIELD atualiz-neg      AS INT.

define temp-table tt-ped-alterado no-undo
    field r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD nr-pedcli       LIKE ped-venda.nr-pedcli
    FIELD valor           AS CHAR FORMAT 'x(1000)'.

DEFINE VARIABLE c-dir-saida AS CHARACTER   NO-UNDO.
DEFINE BUFFER b-ped-repre FOR ped-repre.
DEFINE VARIABLE dt-implanta AS DATE        NO-UNDO.
DEFINE VARIABLE h-bodi159cal AS HANDLE      NO-UNDO.

DEFINE VARIABLE c-erro AS CHAR NO-UNDO.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

{utp/ut-glob.i}

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "ESPDP085_" + STRING(TIME) + ".csv":U.

    IF  OPSYS = "unix" THEN DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
        END. 

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END. 
    ELSE DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
        END. 

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END.
END.

DO ON STOP UNDO, LEAVE:
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar in h-acomp (input "Buscando ...").

    CASE tt-param.alterar-campo:
        WHEN 1 THEN ASSIGN c-campo = 'Cond.Pagto'.
        WHEN 2 THEN ASSIGN c-campo = 'Atendente'.
        WHEN 3 THEN ASSIGN c-campo = 'Prioridade'.
        WHEN 4 THEN ASSIGN c-campo = 'Dt.Negociacao'.
        WHEN 5 THEN ASSIGN c-campo = 'Dias Negociacao'.
        WHEN 6 THEN ASSIGN c-campo = 'Cond.Especial'.
    END CASE.

    OUTPUT STREAM str-excel TO value(c-arq-excel) NO-CONVERT.

    PUT STREAM str-excel UNFORMATTED  "Pedido;" + 
                                      c-campo + " ANTERIOR;" + 
                                      c-campo + " ATUAL;" SKIP.

    IF CAN-FIND (FIRST tt-digita) THEN DO:
        FOR EACH tt-digita:

            FIND FIRST ped-venda 
                 WHERE ped-venda.nr-pedcli   = tt-digita.nr-pedcli 
                   AND ped-venda.cod-sit-ped <= 2 EXCLUSIVE-LOCK NO-ERROR.

            IF AVAIL ped-venda THEN DO:

               ASSIGN c-erro = "".

               FIND FIRST int-emitente NO-LOCK
                    WHERE int-emitente.cod-emitente = ped-venda.cod-emitente NO-ERROR.
               IF AVAIL int-emitente
                    AND int-emitente.ind-participa-canais = 993520001
                    AND ped-venda.origem = 12
                    AND ped-venda.cod-priori = 44 THEN DO:
                    ASSIGN c-erro      = "Aten‡Æo, Pedido de OR€AMENTO ou Cota‡Æo gerada pela extranet, nÆo ‚ permitido manuten‡Æo atrav‚s deste programa, utilize a propria extranet".
               END.

               IF c-erro = "" THEN DO:
                  FIND FIRST int-ped-venda EXCLUSIVE-LOCK
                       WHERE int-ped-venda.nr-pedido = INT(tt-digita.nr-pedcli) NO-ERROR.

                  IF NOT AVAIL int-ped-venda THEN

                      FIND FIRST int-ped-venda EXCLUSIVE-LOCK
                           WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR. 
                  
                  ASSIGN c-valor-new = tt-digita.valor 
                         c-valor-old = ''.
               
                  CASE tt-param.alterar-campo:
                      WHEN 1 THEN DO:
                         ASSIGN c-valor-old            = STRING(ped-venda.cod-cond-pag)
                                ped-venda.cod-cond-pag = INT(tt-digita.valor) NO-ERROR.
                      END.
                      WHEN 2 THEN DO:
                         ASSIGN c-valor-old         = ped-venda.tp-pedido 
                                ped-venda.tp-pedido = tt-digita.valor NO-ERROR.
                      END.
                      WHEN 3 THEN DO:
                         ASSIGN c-valor-old          = STRING(ped-venda.cod-priori)
                                ped-venda.cod-priori = INT(tt-digita.valor) NO-ERROR.
                      END.
                      WHEN 4 THEN DO:
                          IF AVAIL int-ped-venda THEN DO:
                             ASSIGN c-valor-old = STRING(int-ped-venda.dt-negociacao) NO-ERROR.
               
                             IF tt-param.atualiz-neg = 1 THEN
                                ASSIGN int-ped-venda.dt-negociacao = DATE(tt-digita.valor) NO-ERROR.
                             ELSE 
                                ASSIGN int-ped-venda.dt-negociacao = ?.
                          END.
                      END.
                      WHEN 5 THEN DO:
                          IF AVAIL int-ped-venda THEN DO:
                             ASSIGN c-valor-old  = STRING(int-ped-venda.dias-negociacao) NO-ERROR.
                            
                             IF tt-param.atualiz-neg = 1 THEN
                                ASSIGN int-ped-venda.dias-negociacao = INT(tt-digita.valor) NO-ERROR.
                             ELSE 
                                ASSIGN int-ped-venda.dias-negociacao = 0.
                          END.
                      END.
                      WHEN 6 THEN DO:
                         ASSIGN c-valor-old          = ped-venda.cond-espec
                                ped-venda.cond-espec = tt-digita.valor NO-ERROR.
                      END.
                      WHEN 7 THEN DO:
                          IF ped-venda.cod-cond-pag = 0 THEN //atualiza somente em condicao 0
                             RUN pi-atualiza-cond-pagto(INPUT tt-param.atualiz-neg).
                      END.
                  END CASE.
               
                  ASSIGN ped-venda.completo = NO.
               
                  IF ERROR-STATUS:ERROR THEN DO:
                     PUT STREAM str-excel UNFORMATTED STRING(ped-venda.nr-pedido) ';'
                                'Formato informado invalido !!' SKIP .
               
                     NEXT.
                  END.
               
                  CREATE tt-ped-alterado.
                  ASSIGN tt-ped-alterado.r-rowid = ROWID(ped-venda).
               END.

               //ASSIGN ped-venda.cod-priori = tt-digita.cod-priori.
               PUT STREAM str-excel UNFORMATTED STRING(ped-venda.nr-pedido) ';'
                                                TRIM(c-valor-old) FORMAT 'x(500)' ';'
                                                TRIM(c-valor-new) FORMAT 'x(500)' ";" c-erro SKIP.
            END.
        END.
    END.
    ELSE DO:
        FOR EACH ped-venda EXCLUSIVE-LOCK
           WHERE ped-venda.dt-implant   >= tt-param.dt-implant-ini
             AND ped-venda.dt-implant   <= tt-param.dt-implant-fim
             AND ped-venda.cod-sit-ped  <= 2
             AND ped-venda.no-ab-reppri  = tt-param.repres-de
             AND ped-venda.cod-estabel  >= tt-param.cod-estab-ini
             AND ped-venda.cod-estabel  <= tt-param.cod-estab-fim
             AND ped-venda.cod-emitente >= tt-param.cod-emitente-ini 
             AND ped-venda.cod-emitente <= tt-param.cod-emitente-fim
             AND ped-venda.tp-pedido    >= tt-param.tp-pedido-ini 
             AND ped-venda.tp-pedido    <= tt-param.tp-pedido-fim 
             AND ped-venda.cod-priori   >= tt-param.cod-priori-ini 
             AND ped-venda.cod-priori   <= tt-param.cod-priori-fim:
    
            RUN pi-acompanhar in h-acomp (input "Pedido: " + string(ped-venda.nr-pedido)).
    
            ASSIGN ped-venda.no-ab-reppri = tt-param.repres-para.

            CREATE tt-ped-alterado.
            ASSIGN tt-ped-alterado.r-rowid = ROWID(ped-venda).
    
            FOR EACH b-ped-repre EXCLUSIVE-LOCK
               WHERE b-ped-repre.nr-pedido   = ped-venda.nr-pedido
                 AND b-ped-repre.nome-ab-rep = tt-param.repres-de:
    
                CREATE ped-repre.
                BUFFER-COPY b-ped-repre EXCEPT nome-ab-rep TO ped-repre.
                ASSIGN ped-repre.nome-ab-rep = tt-param.repres-para.
    
                DELETE b-ped-repre.
                RELEASE ped-repre.
            END.
    
            PUT STREAM str-excel UNFORMATTED STRING(ped-venda.nr-pedido) SKIP.
        END.
    END.
    
    OUTPUT STREAM str-excel CLOSE.
END.

IF NOT VALID-HANDLE(h-bodi159cal) THEN
    RUN dibo/bodi159com.p PERSISTENT SET h-bodi159cal.  

FOR EACH tt-ped-alterado:
    FIND FIRST ped-venda NO-LOCK
         WHERE ROWID(ped-venda) = tt-ped-alterado.r-rowid NO-ERROR.

    RUN pi-completa-pedido.
END.

DELETE PROCEDURE h-bodi159cal.

RUN pi-finalizar IN h-acomp.

IF NOT OPSYS = "unix" THEN DO:
    DOS SILENT START excel VALUE(c-arq-excel).
END.

RETURN "OK".   

PROCEDURE pi-completa-pedido:
    IF NOT ped-venda.completo THEN DO:
        RUN completeOrder IN h-bodi159cal (INPUT  ROWID(ped-venda),
                                           OUTPUT TABLE rowErrors).
    END.   
END PROCEDURE.


PROCEDURE pi-atualiza-cond-pagto:

    DEFINE INPUT PARAM pAtualiza AS INT NO-UNDO.

    // 1 - incluir, 2 - excluir.

    DEFINE VAR d-dias-parcela  AS INT NO-UNDO.
    DEFINE VAR i-num-dias      AS INT NO-UNDO.
    DEFINE VAR i-nr-parc       AS INT NO-UNDO.
    DEFINE VAR i-parcela       AS INT NO-UNDO.
    DEFINE VAR d-perc-parcela  AS DEC NO-UNDO.
    DEFINE VAR d-resto-parcela AS DEC NO-UNDO.

    IF pAtualiza = 2 THEN DO: //elimina a tabela
        FOR EACH cond-ped OF ped-venda:
            DELETE cond-ped.
        END.
    END.
    ELSE DO:
       ASSIGN i-num-dias = int(ENTRY(1,tt-digita.valor,"/"))
              i-nr-parc  = int(ENTRY(2,tt-digita.valor,"/")).
       
       ASSIGN d-dias-parcela = i-num-dias.
      
       DO i-parcela = 1 TO i-nr-parc : 
      
            CREATE cond-ped.
            ASSIGN cond-ped.nr-pedido    = ped-venda.nr-pedido
                   cond-ped.nr-sequencia = i-parcela * 10
                   //cond-ped.data-pagto   = d-data-parcela
                   cond-ped.nr-dias-venc  = d-dias-parcela
                   cond-ped.observacoes   = "".
      
            IF i-parcela = i-nr-parc THEN DO: //ultima parcela
                ASSIGN d-resto-parcela     = round(100 - d-perc-parcela,2)
                       cond-ped.perc-pagto = d-resto-parcela.
            END.
            ELSE DO:
                ASSIGN d-perc-parcela      = d-perc-parcela + ROUND((100 / i-nr-parc),2)
                       cond-ped.perc-pagto = ROUND((100 / i-nr-parc),2).
            END.
      
            ASSIGN d-dias-parcela   = d-dias-parcela + i-num-dias.
       END.
    END.

END PROCEDURE.
