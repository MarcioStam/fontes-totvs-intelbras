{cdp/cd0666.i}
{utp/ut-glob.i}
{cep/ceapi001k.i}

DEFINE TEMP-TABLE tt-ficha NO-UNDO
    FIELD l-marcado          AS LOG FORM "*/"  
    FIELD nr-ficha           LIKE ficha-cq.nr-ficha
    FIELD cod-emitente       LIKE movto-estoq.cod-emitente
    FIELD it-codigo          LIKE ficha-cq.it-codigo
    FIELD desc-item          LIKE ITEM.desc-item
    FIELD quantidade         LIKE movto-estoq.quantidade
    FIELD nat-operacao       LIKE ficha-cq.nat-operacao
    FIELD situacao           AS CHAR FORMAT "x(20)"
    FIELD cod-estabel        LIKE ficha-cq.cod-estabel
    FIELD cod-depos          LIKE ficha-cq.cod-depos
    FIELD cod-localiz        LIKE ficha-cq.cod-localiz
    FIELD lote               LIKE ficha-cq.lote
    FIELD dt-vali            LIKE saldo-estoq.dt-vali-lote
    FIELD cod-refer          LIKE movto-estoq.cod-refer
    FIELD un                 LIKE movto-estoq.un
    FIELD cod-resp           LIKE ficha-cq.cod-resp
    FIELD dt-trans           AS DATE FORMAT 99/99/9999
    FIELD serie-docto        LIKE movto-estoq.serie-docto
    FIELD nro-docto          LIKE movto-estoq.nro-docto
    FIELD conta-contabil     LIKE movto-estoq.conta-contabil
    FIELD mov-cod-estabel    LIKE ficha-cq.cod-estabel
    FIELD mov-cod-depos      LIKE ficha-cq.cod-depos
    FIELD mov-cod-localiz    LIKE ficha-cq.cod-localiz
    FIELD mov-lote           LIKE ficha-cq.lote
    FIELD mov-dt-vali        LIKE saldo-estoq.dt-vali-lote
    FIELD mov-cod-refer      LIKE movto-estoq.cod-refer
    FIELD per-ppm            LIKE saldo-estoq.per-ppm
    FIELD valida-retorno     AS LOGICAL INITIAL YES
    FIELD origem             LIKE ficha-cq.origem
    FIELD baixa-estoq        LIKE ficha-cq.baixa-estoq.

DEFINE BUFFER b-responsavel FOR responsavel.
DEFINE BUFFER b-ficha-cq    FOR ficha-cq.

DEFINE VARIABLE l-erro         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE l-ok           AS LOGICAL   NO-UNDO.
DEFINE VARIABLE c-lb-ficha     AS CHAR      NO-UNDO.
DEFINE VARIABLE c-lb-exame     AS CHAR      NO-UNDO.
DEFINE VARIABLE l-todos        AS LOGICAL   NO-UNDO.
DEFINE VARIABLE l-nr-ac-ex     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE l-rejeita      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE l-rej-desab    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE l-disab        AS LOGICAL   NO-UNDO.
DEFINE VARIABLE c-op-des       AS CHARACTER NO-UNDO.
DEFINE VARIABLE de-inspecao    AS DATE      NO-UNDO.
DEFINE VARIABLE c-rejeitado    AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-codigo       AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-emite        AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-cancela      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE l-cliente      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE c-texto        AS CHARACTER NO-UNDO.
DEFINE VARIABLE r-ficha-cq     AS ROWID     NO-UNDO.
DEFINE VARIABLE h-acomp        AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-ceapi001k    AS HANDLE    NO-UNDO.
DEFINE VARIABLE l-deleta-erros AS LOGICAL   NO-UNDO.
DEFINE VARIABLE i-insp         AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-var-aux      AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-var-aux-tot  AS INTEGER   NO-UNDO.
DEFINE VARIABLE l-leitura-item-fornec-estab AS LOGICAL INIT NO    NO-UNDO.

/* Variaveis utilizadas na cd9320.i1 */
&IF '{&bf_lote_avancado_liberado}' = 'yes' &THEN
    DEF VAR severa-normal-lote        AS INT NO-UNDO.
    DEF VAR severa-normal-rejeitado   AS INT NO-UNDO.
    DEF VAR normal-severa-lote        AS INT NO-UNDO.
    DEF VAR normal-severa-rejeitado   AS INT NO-UNDO.
    DEF VAR normal-atenuada-lote      AS INT NO-UNDO.
    DEF VAR normal-atenuada-rejeitado AS INT NO-UNDO.
    DEF VAR atenuada-normal-lote      AS INT NO-UNDO.
    DEF VAR atenuada-normal-rejeitado AS INT NO-UNDO.
&endif

DEF TEMP-TABLE tt-gera-transf NO-UNDO
    FIELD l-considera   AS CHAR FORMAT "x(01)" LABEL "Retorna Roteiro?"
    FIELD cod-estabel   LIKE ficha-cq.cod-estabel
    FIELD nr-ficha      LIKE ficha-cq.nr-ficha
    FIELD it-codigo     LIKE ficha-cq.it-codigo
    FIELD desc-item     LIKE ITEM.desc-item
    FIELD dt-fabricacao AS DATE FORMAT "99/99/9999" LABEL "DT Fabrica‡Æo"
    FIELD quantidade    LIKE ficha-cq.qt-original
    FIELD dep-saida     LIKE ficha-cq.cod-depos
    FIELD loc-saida     LIKE ficha-cq.cod-localiz
    FIELD cod-refer     LIKE ficha-cq.cod-refer
    FIELD lote          LIKE ficha-cq.lote
    FIELD dep-entrada   LIKE saldo-estoq.cod-depos
    FIELD loc-entrada   LIKE saldo-estoq.cod-localiz
    FIELD dt-trans      LIKE movto-estoq.dt-trans
    FIELD nro-docto     LIKE movto-estoq.nro-docto   
    FIELD serie-docto   LIKE movto-estoq.serie-docto
    FIELD narrativa     LIKE ficha-cq.narrativa
    FIELD cod-emitente  LIKE ficha-cq.cod-emitente
    FIELD cod-rej       LIKE cod-rejeicao.codigo-rejei
    FIELD nat-operacao  LIKE ficha-cq.nat-operacao
    FIELD obs           LIKE ficha-cq.narrativa
    FIELD ct-codigo     AS CHAR
    FIELD sc-codigo     AS CHAR. 

DEFINE INPUT PARAM p-nr-ficha  LIKE ficha-cq.nr-ficha.     
DEFINE INPUT PARAM p-row-exame AS ROWID.
DEFINE INPUT PARAM TABLE FOR tt-ficha.

ASSIGN l-cliente  = NO
       l-nr-ac-ex = NO.
    
BlocoRetorno:
DO TRANSACTION:

    FIND FIRST param-cq NO-LOCK NO-ERROR.

    FIND FIRST exame NO-LOCK
         WHERE ROWID(exame) = p-row-exame NO-ERROR.

    find ficha-cq where ficha-cq.nr-ficha = p-nr-ficha NO-LOCK no-error.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF AVAIL ficha-cq 
         AND ficha-cq.origem = 2 
         AND ficha-cq.nat-operacao <> "" then do:
        
        find b-responsavel where b-responsavel.cod-resp = c-seg-usuario no-lock no-error.

        if  avail b-responsavel and ficha-cq.cod-resp <> "" then do:

            if  ficha-cq.cod-resp <> c-seg-usuario and b-responsavel.log-1 = no then do:
                run utp/ut-msgs.p (input "show", input 15636, input ""). /* Este roteiro n’o ² de responsabilidade deste usuÿrio. */
                UNDO BlocoRetorno, return no-apply.
            end.
        end.

        if  ficha-cq.origem       = 1
        and ficha-cq.baixa-estoq  = no
        and ficha-cq.inspecionado = yes
        and ficha-cq.situacao     = 4
        and ficha-cq.liberada     = yes then do:
            run utp/ut-msgs.p (input "show", input 829, input ""). /* Quantidade em CQ igual a zero, Roteiro jÿ inspecionado */
            UNDO BlocoRetorno, RETURN NO-APPLY.
        end.
        if  ficha-cq.qt-original  - ficha-cq.qt-aprovada
          - ficha-cq.qt-consumida - ficha-cq.qt-rejeitada
          - ficha-cq.qt-apr-cond <= 0 then do:
            run utp/ut-msgs.p (input "show", input 829, input ""). /* Quantidade em CQ igual a zero, Roteiro jÿ inspecionado */
            UNDO BlocoRetorno, RETURN NO-APPLY.
        end.
        assign l-todos = yes.
        
        IF NOT CAN-FIND (FIRST exam-ficha WHERE exam-ficha.nr-ficha = ficha-cq.nr-ficha) THEN DO:
                {utp/ut-liter.i "Roteiro_Inspe»’o"}
                    ASSIGN c-lb-ficha = RETURN-VALUE.
                {utp/ut-liter.i "Exames"}
                    ASSIGN c-lb-exame = RETURN-VALUE.
                {utp/ut-liter.i "continuar"}
                 run utp/ut-msgs.p (input "show", input 25508, INPUT c-lb-ficha + " " + string(ficha-cq.nr-ficha) + "~~" +
                                                                     c-lb-exame + "~~" + RETURN-VALUE + "~~" + c-lb-exame). 
                  /*Roteiro Inspe»’o n’o possui Exames. Deseja continuar?*/                                           
                 if  return-value = 'no' then
                     return 'adm-error'.
        END.
        ELSE DO:
            for each  exam-ficha use-index codigo no-lock
                where exam-ficha.nr-ficha = ficha-cq.nr-ficha:

                if avail exam-ficha and
                   exam-ficha.nr-ac-ex > exam-ficha.nr-aceita then do:

                   if  exame.homogeneo = no then do:
                       if  exam-ficha.nr-ac-ex > 0 and 
                           exam-ficha.nr-ac-ex >= exam-ficha.nr-rejeita then
                           assign l-nr-ac-ex = yes. 
                   end.

                   if  exame.homogeneo = yes then do:
                       if  exam-ficha.nr-ac-ex > 0 then
                           assign l-nr-ac-ex = yes.                                       
                   end.

                end.

                if can-find (first it-comp-exame where
                       it-comp-exame.cod-exame = exam-ficha.cod-exame) then
                for each  it-comp-exame no-lock
                    where it-comp-exame.cod-exame = exam-ficha.cod-exame and 
                          it-comp-exame.it-codigo = ficha-cq.it-codigo and
                          it-comp-exame.situacao = 1:

                    find first res-fic-cq
                        where  res-fic-cq.nr-ficha = ficha-cq.nr-ficha
                        and   res-fic-cq.it-codigo = ficha-cq.it-codigo
                        and   res-fic-cq.cod-exame = exam-ficha.cod-exame
                        and   res-fic-cq.cod-comp  = it-comp-exame.cod-comp
                        no-lock no-error.
                    if  not avail res-fic-cq then assign l-todos = no.
                end.
                else 
                for each  comp-exame no-lock
                    where comp-exame.cod-exame  = exam-ficha.cod-exame
                      and comp-exame.cdn-versao = exam-ficha.cdn-versao
                      and comp-exame.log-1 :

                    find first res-fic-cq
                         where res-fic-cq.nr-ficha = ficha-cq.nr-ficha
                         and   res-fic-cq.it-codigo = ficha-cq.it-codigo
                         and   res-fic-cq.cod-exame = exam-ficha.cod-exame
                         and   res-fic-cq.cod-comp  = comp-exame.cod-comp
                         no-lock no-error.
                    if  not avail res-fic-cq then assign l-todos = no.
                end.
            end.
        END.

        if  l-todos = no then do:
            run utp/ut-msgs.p (input "show", input 1162, input ""). /* Existem componentes sem resultado. Continua? */
            if  return-value = 'no' then 
                UNDO BlocoRetorno, RETURN NO-APPLY.
        end.

        if  ficha-cq.origem = 2 then do:
            assign l-rejeita = no.
            find estabelec where estabel.cod-estabel = ficha-cq.cod-estabel NO-LOCK no-error.
            if  avail estabelec then do:
                if  estabelec.dep-rej-cq = ""
                    then assign l-rej-desab = no.
                    else assign l-rej-desab = yes.
            end.                        
            if  l-nr-ac-ex = no then do:
                assign l-disab = no.
                run cqp/escq0210d.w (input-output l-disab,
                                     input-output c-op-des,
                                     input-output de-inspecao,
                                     input-output c-rejeitado,
                                     input-output c-codigo,
                                     input-output c-emite,
                                     output       l-cancela,
                                     input-output l-rej-desab,
                                     input        l-cliente).
                if  l-cancela = no then 
                    UNDO BlocoRetorno, RETURN NO-APPLY.

                run cqp/escq0211b.w (input-output c-texto).
            end.
            else do:
                assign l-rejeita = yes
                       l-disab   = yes.
                if ficha-cq.sit-rot <> 0 then do:
                   if exame.rejeita-lote = no then do:
                       run utp/ut-msgs.p (input "show", input 1163, input ""). 
                      /* Lote possui N’o Conformes. Confirma Rejei»’o? */
                      if  return-value = 'no' then do:
                          assign l-nr-ac-ex = no.
                          UNDO BlocoRetorno, RETURN NO-APPLY.
                      end.
                      else do:
                         run cqp/escq0210d.w (input-output l-disab,
                                           input-output c-op-des,
                                           input-output de-inspecao,
                                           input-output c-rejeitado,
                                           input-output c-codigo,
                                           input-output c-emite,
                                           output       l-cancela,
                                           input-output l-rej-desab,
                                           input        l-cliente). 
                         if  l-cancela = no then do:
                             assign l-nr-ac-ex = no.
                             UNDO BlocoRetorno, RETURN NO-APPLY. 
                         end.               
                         run cqp/escq0211b.w (input-output c-texto).
                         assign c-op-des = "3".
                      end.
                   end.
                   else do:            
                      run utp/ut-msgs.p (input "show", input 17095, input ""). 
                      /* Lote possui N’o Conformes. Serÿ Rejeitado automaticamente! */
                      run cqp/escq0210d.w (input-output l-disab,
                                        input-output c-op-des,
                                        input-output de-inspecao,
                                        input-output c-rejeitado,
                                        input-output c-codigo,
                                        input-output c-emite,
                                        output       l-cancela,
                                        input-output l-rej-desab,
                                        input        l-cliente).       
                      run cqp/escq0211b.w (input-output c-texto).
                   end.   
                end.   
                ELSE DO:
                   assign l-disab = no.
                   RUN cqp/escq0210d.w (input-output l-disab,
                                  input-output c-op-des,
                                  input-output de-inspecao,
                                  input-output c-rejeitado,
                                  input-output c-codigo,
                                  input-output c-emite,
                                  output       l-cancela,
                                  input-output l-rej-desab,
                                  input        l-cliente).
                   if  l-cancela = no then 
                   UNDO BlocoRetorno, RETURN NO-APPLY.
                   run cqp/escq0211b.w (input-output c-texto).
                END.
            end. 
            assign r-ficha-cq = rowid(ficha-cq)
/*                        c-texto    = ""                 */
/*                        c-texto    = ficha-cq.narrativa */
                   l-nr-ac-ex = no.
            
            find ficha-cq where rowid(ficha-cq) = r-ficha-cq EXCLUSIVE-LOCK no-error.
            if  avail ficha-cq THEN
                assign ficha-cq.narrativa = c-texto.

            /* APROVADO */
            if  c-op-des = "1" then do:

               EMPTY TEMP-TABLE tt-gera-transf.
               EMPTY TEMP-TABLE tt-movto.

               FIND FIRST ficha-cq NO-LOCK
                    WHERE ROWID(ficha-cq) = r-ficha-cq NO-ERROR.

               IF AVAIL ficha-cq THEN DO:

                   FOR EACH b-ficha-cq NO-LOCK
                      WHERE b-ficha-cq.cod-emitente = ficha-cq.cod-emitente
                        AND b-ficha-cq.serie-docto  = ficha-cq.serie-docto
                        AND b-ficha-cq.nat-operacao = ficha-cq.nat-operacao
                        AND b-ficha-cq.nro-docto    = ficha-cq.nro-docto
                        AND b-ficha-cq.lote         = ficha-cq.lote 
                        AND b-ficha-cq.situacao    >= 1
                        AND b-ficha-cq.situacao    <= 3,
                      FIRST tt-ficha
                      WHERE tt-ficha.l-marcado
                        AND tt-ficha.nr-ficha       = b-ficha-cq.nr-ficha.

                       CREATE tt-gera-transf.
                       ASSIGN tt-gera-transf.l-considera   = "*"
                              tt-gera-transf.cod-estabel   = b-ficha-cq.cod-estabel
                              tt-gera-transf.nr-ficha      = b-ficha-cq.nr-ficha
                              tt-gera-transf.it-codigo     = b-ficha-cq.it-codigo
                              tt-gera-transf.quantidade    = (b-ficha-cq.qt-original - b-ficha-cq.qt-consumida -
                                                              b-ficha-cq.qt-aprovada - b-ficha-cq.qt-rejeitada -
                                                              b-ficha-cq.qt-apr-cond)
                              tt-gera-transf.lote          = b-ficha-cq.lote
                              tt-gera-transf.dep-saida     = b-ficha-cq.cod-depos
                              tt-gera-transf.loc-saida     = b-ficha-cq.cod-localiz
                              tt-gera-transf.cod-refer     = b-ficha-cq.cod-refer
                              tt-gera-transf.dt-fabricacao = b-ficha-cq.dt-ficha
                              tt-gera-transf.nro-docto     = b-ficha-cq.nro-docto
                              tt-gera-transf.serie-docto   = b-ficha-cq.serie-docto
                              tt-gera-transf.narrativa     = b-ficha-cq.narrativa
                              tt-gera-transf.cod-emitente  = b-ficha-cq.cod-emitente
                              tt-gera-transf.dt-trans      = de-inspecao.

                       FIND FIRST ITEM NO-LOCK
                            WHERE ITEM.it-codigo = b-ficha-cq.it-codigo NO-ERROR.

                       IF AVAIL ITEM THEN DO:

                           ASSIGN tt-gera-transf.desc-item = ITEM.desc-item.

                       END.

                       //Valida se Observacao na ficha de inspecao esta preenchida - M2008-082 - 08/03/21 - IAB 
                       RUN pi-valida-obs-insp.

                       IF RETURN-VALUE = "NOK" THEN
                          DELETE tt-gera-transf.

                   END.


                   FIND FIRST tt-gera-transf NO-ERROR.

                   IF NOT AVAIL tt-gera-transf THEN 
                      UNDO BlocoRetorno, RETURN NO-APPLY.


                   RUN cqp/escq0210e-ap.w (INPUT-OUTPUT TABLE tt-gera-transf,
                                           OUTPUT l-ok).  

                   IF l-ok = NO THEN DO:

                        UNDO BlocoRetorno, RETURN NO-APPLY.
                                
                   END.

                   ELSE DO:

                       RUN pi-inicializar in h-acomp ("Processando Retorno"). 

                       EMPTY TEMP-TABLE tt-movto.

                       FOR EACH tt-gera-transf NO-LOCK
                          WHERE tt-gera-transf.l-considera = "*".

                             FIND FIRST ITEM NO-LOCK
                                  WHERE ITEM.it-codigo = tt-gera-transf.it-codigo NO-ERROR.
                            
                             find estab-mat where
                                  estab-mat.cod-estabel = tt-gera-transf.cod-estabel no-lock no-error.

                             FIND FIRST item-uni-estab NO-LOCK
                                  WHERE item-uni-estab.it-codigo   = tt-gera-transf.it-codigo
                                    AND item-uni-estab.cod-estabel = tt-gera-transf.cod-estabel NO-ERROR.

                             FIND FIRST int-familia NO-LOCK
                                  WHERE int-familia.fm-codigo = ITEM.fm-codigo NO-ERROR.

                             IF AVAIL int-familia THEN DO: 
                                 
                                 ASSIGN tt-gera-transf.dt-fabricacao = tt-gera-transf.dt-fabricacao + (int-familia.meses-validade * 30).

                             END.

                             IF tt-gera-transf.dt-fabricacao < TODAY THEN DO:

                                 RUN utp/ut-msgs.p (INPUT 'show',
                                                    INPUT 17006,
                                                    INPUT "Data de Fabrica‡Æo Inv lida!"
                                                    + "~~" +
                                                    "A data de fabrica‡Æo informada + os meses de validade da fam¡lia resultam numa data de validade inferior ao dia de hoje. Revise a data de fabrica‡Æo informada.").

                                 RUN pi-finalizar IN h-acomp.
                                   
                                 UNDO BlocoRetorno, RETURN NO-APPLY.

                             END.

                             CREATE tt-movto.

                             assign tt-movto.ct-codigo = estab-mat.cod-cta-transf-unif
                                    tt-movto.sc-codigo = estab-mat.cod-ccusto-transf-unif.  

                             assign tt-movto.cod-versao-integracao = 1 
                                    tt-movto.dt-trans       = tt-gera-transf.dt-trans
                                    tt-movto.nro-docto      = tt-gera-transf.nro-docto
                                    tt-movto.serie-docto    = tt-gera-transf.serie-docto
                                    tt-movto.cod-depos      = tt-gera-transf.dep-saida
                                    tt-movto.cod-estabel    = tt-gera-transf.cod-estabel
                                    tt-movto.it-codigo      = tt-gera-transf.it-codigo
                                    tt-movto.cod-localiz    = tt-gera-transf.loc-saida
                                    tt-movto.lote           = tt-gera-transf.lote
                                    tt-movto.dt-vali-lote   = date(month(tt-gera-transf.dt-fabricacao), 1, year(tt-gera-transf.dt-fabricacao))
                                    tt-movto.cod-refer      = tt-gera-transf.cod-refer
                                    tt-movto.quantidade     = tt-gera-transf.quantidade
                                    tt-movto.un             = ITEM.un
                                    tt-movto.esp-docto      = 33
                                    tt-movto.tipo-trans     = 2
                                    tt-movto.descricao-db   = tt-gera-transf.narrativa
                                    tt-movto.cod-prog-orig  = "v03in218"
                                    tt-movto.cod-emitente   = tt-gera-transf.cod-emitente
                                    tt-movto.usuario        = c-seg-usuario
                                    tt-movto.cod-unid-negoc = item-uni-estab.cod-unid-negoc.

                             CREATE tt-movto.

                             assign tt-movto.ct-codigo = estab-mat.cod-cta-transf-unif
                                    tt-movto.sc-codigo = estab-mat.cod-ccusto-transf-unif.  

                             assign tt-movto.cod-versao-integracao = 1 
                                    tt-movto.dt-trans       = tt-gera-transf.dt-trans
                                    tt-movto.nro-docto      = tt-gera-transf.nro-docto
                                    tt-movto.serie-docto    = tt-gera-transf.serie-docto
                                    tt-movto.cod-depos      = tt-gera-transf.dep-ent
                                    tt-movto.cod-estabel    = tt-gera-transf.cod-estabel
                                    tt-movto.it-codigo      = tt-gera-transf.it-codigo
                                    tt-movto.cod-localiz    = tt-gera-transf.loc-ent
                                    tt-movto.lote           = tt-gera-transf.lote
                                    tt-movto.dt-vali-lote   = date(month(tt-gera-transf.dt-fabricacao), 1, year(tt-gera-transf.dt-fabricacao))
                                    tt-movto.cod-refer      = tt-gera-transf.cod-refer
                                    tt-movto.quantidade     = tt-gera-transf.quantidade
                                    tt-movto.un             = ITEM.un
                                    tt-movto.esp-docto      = 33
                                    tt-movto.tipo-trans     = 1
                                    tt-movto.descricao-db   = tt-gera-transf.narrativa
                                    tt-movto.cod-prog-orig  = "v03in218"
                                    tt-movto.cod-emitente   = tt-gera-transf.cod-emitente
                                    tt-movto.usuario        = c-seg-usuario
                                    tt-movto.cod-unid-negoc = item-uni-estab.cod-unid-negoc.

                       END.

                       RUN pi-acompanhar IN h-acomp (INPUT "Gerando Transferˆncia").

                       RUN cep/ceapi001k.p persistent set h-ceapi001k.
                       
                       RUN pi-execute IN h-ceapi001k (input-output table tt-movto,
                                                      input-output table tt-erro, 
                                                      INPUT l-deleta-erros).

                       FIND FIRST tt-erro NO-LOCK no-error.

                       IF RETURN-VALUE = "NOK":U OR AVAIL tt-erro THEN DO:
                            run cdp/cd0666.w (input table tt-erro).
                            l-erro = yes.  

                            RUN pi-finalizar IN h-acomp.

                            FOR EACH tt-erro.
                                DELETE tt-erro.
                            END.

                            UNDO BlocoRetorno, RETURN NO-APPLY.

                       END.

                       ELSE DO:

                           FOR EACH tt-gera-transf NO-LOCK
                              WHERE tt-gera-transf.l-considera = "*",
                               EACH ITEM NO-LOCK 
                              WHERE ITEM.it-codigo = tt-gera-transf.it-codigo
                               AND (ITEM.tipo-con-est = 3 OR ITEM.tipo-con-est = 4),
                               EACH saldo-estoq EXCLUSIVE-LOCK
                              WHERE saldo-estoq.it-codigo = tt-gera-transf.it-codigo
                                AND saldo-estoq.lote      = tt-gera-transf.lote:

                                   ASSIGN saldo-estoq.dt-vali-lote = date(month(tt-gera-transf.dt-fabricacao), 1, year(tt-gera-transf.dt-fabricacao)).

                           END.

                           /* WMS X CQ */
                           RUN wmp/eswm9035.p (INPUT-OUTPUT table tt-gera-transf,
                                               INPUT-OUTPUT table tt-erro).

                           FIND FIRST tt-erro NO-LOCK no-error.

                           IF RETURN-VALUE = "NOK":U OR AVAIL tt-erro THEN DO:

                                 run cdp/cd0666.w (input table tt-erro).

                                 l-erro = yes.  
                
                                 RUN pi-finalizar IN h-acomp.
                
                                 FOR EACH tt-erro.
                                     DELETE tt-erro.
                                 END.
                
                                 UNDO BlocoRetorno, RETURN NO-APPLY.
                
                           END.

                       END.

                       RUN pi-finalizar IN h-acomp.
                       
                       FOR EACH tt-gera-transf NO-LOCK
                          WHERE tt-gera-transf.l-considera = "*".
    
                           FIND FIRST ficha-cq 
                                WHERE ficha-cq.nr-ficha = tt-gera-transf.nr-ficha NO-ERROR.
    
                           IF AVAIL ficha-cq THEN DO: 
                               
                               ASSIGN ficha-cq.qt-aprovada  = ficha-cq.qt-aprovada + tt-gera-transf.quantidade
                                      ficha-cq.inspecionado = YES
                                      ficha-cq.situacao     = 4
                                      ficha-cq.dt-ult-sit   = TODAY
                                      ficha-cq.liberada     = YES
                                      ficha-cq.cod-resp     = c-seg-usuario
                                      ficha-cq.narrativa    = c-texto.
    
                               IF ficha-cq.dt-inspecao = ? THEN ASSIGN ficha-cq.dt-inspecao = tt-gera-transf.dt-trans.
    
                               /* ATUALIZA€ÇO DA INSPE€ÇO DO FORNECEDOR */
                               {cdp/cd9320.i}

                               RELEASE item-fornec.
                               RELEASE item-fornec-estab.

                           END.

                       END.

                   END.

               END.

            END.
                         
            /* APROVADO CONDICIONAL */
            if  c-op-des = "2" then do:
               
               EMPTY TEMP-TABLE tt-gera-transf.
               EMPTY TEMP-TABLE tt-movto.

               FIND FIRST ficha-cq NO-LOCK
                    WHERE ROWID(ficha-cq) = r-ficha-cq NO-ERROR.

               IF AVAIL ficha-cq THEN DO:

                   FOR EACH b-ficha-cq NO-LOCK
                      WHERE b-ficha-cq.cod-emitente = ficha-cq.cod-emitente
                        AND b-ficha-cq.serie-docto  = ficha-cq.serie-docto
                        AND b-ficha-cq.nat-operacao = ficha-cq.nat-operacao
                        AND b-ficha-cq.nro-docto    = ficha-cq.nro-docto
                        AND b-ficha-cq.lote         = ficha-cq.lote 
                        AND b-ficha-cq.situacao    >= 1
                        AND b-ficha-cq.situacao    <= 3,
                      FIRST tt-ficha
                      WHERE tt-ficha.l-marcado
                        AND tt-ficha.nr-ficha       = b-ficha-cq.nr-ficha.

                       CREATE tt-gera-transf.
                       ASSIGN tt-gera-transf.l-considera   = "*"
                              tt-gera-transf.cod-estabel   = b-ficha-cq.cod-estabel
                              tt-gera-transf.nr-ficha      = b-ficha-cq.nr-ficha
                              tt-gera-transf.it-codigo     = b-ficha-cq.it-codigo
                              tt-gera-transf.quantidade    = (b-ficha-cq.qt-original - b-ficha-cq.qt-consumida -
                                                              b-ficha-cq.qt-aprovada - b-ficha-cq.qt-rejeitada -
                                                              b-ficha-cq.qt-apr-cond)
                              tt-gera-transf.lote          = b-ficha-cq.lote
                              tt-gera-transf.dep-saida     = b-ficha-cq.cod-depos
                              tt-gera-transf.loc-saida     = b-ficha-cq.cod-localiz
                              tt-gera-transf.cod-refer     = b-ficha-cq.cod-refer
                              tt-gera-transf.dt-fabricacao = b-ficha-cq.dt-ficha
                              tt-gera-transf.nro-docto     = b-ficha-cq.nro-docto
                              tt-gera-transf.serie-docto   = b-ficha-cq.serie-docto
                              tt-gera-transf.narrativa     = b-ficha-cq.narrativa
                              tt-gera-transf.cod-emitente  = b-ficha-cq.cod-emitente
                              tt-gera-transf.dt-trans      = de-inspecao.

                       FIND FIRST ITEM NO-LOCK
                            WHERE ITEM.it-codigo = b-ficha-cq.it-codigo NO-ERROR.

                              IF AVAIL ITEM THEN DO:

                                  ASSIGN tt-gera-transf.desc-item = ITEM.desc-item.

                              END.

                       //Valida se Observacao na ficha de inspecao esta preenchida - M2008-082 - 08/03/21 - IAB 
                       RUN pi-valida-obs-insp.

                       IF RETURN-VALUE = "NOK" THEN
                          DELETE tt-gera-transf.
                   END.


                   FIND FIRST tt-gera-transf NO-ERROR.

                   IF NOT AVAIL tt-gera-transf THEN 
                      UNDO BlocoRetorno, RETURN NO-APPLY.


                   RUN cqp/escq0210e-ac.w (INPUT-OUTPUT TABLE tt-gera-transf,
                                           OUTPUT l-ok).  

                   IF l-ok = NO THEN DO:

                        UNDO BlocoRetorno, RETURN NO-APPLY.
                                
                   END.

                   ELSE DO:

                       RUN pi-inicializar in h-acomp ("Processando Retorno"). 

                       EMPTY TEMP-TABLE tt-movto.

                       FOR EACH tt-gera-transf NO-LOCK
                          WHERE tt-gera-transf.l-considera = "*".

                             FIND FIRST ITEM NO-LOCK
                                  WHERE ITEM.it-codigo = tt-gera-transf.it-codigo NO-ERROR.
                            
                             find estab-mat where
                                  estab-mat.cod-estabel = tt-gera-transf.cod-estabel no-lock no-error.

                             FIND FIRST item-uni-estab NO-LOCK
                                  WHERE item-uni-estab.it-codigo   = tt-gera-transf.it-codigo
                                    AND item-uni-estab.cod-estabel = tt-gera-transf.cod-estabel NO-ERROR.

                             FIND FIRST int-familia NO-LOCK
                                  WHERE int-familia.fm-codigo = ITEM.fm-codigo NO-ERROR.

                             IF AVAIL int-familia THEN DO: 
                                 
                                 ASSIGN tt-gera-transf.dt-fabricacao = tt-gera-transf.dt-fabricacao + (int-familia.meses-validade * 30).

                             END.

                             IF tt-gera-transf.dt-fabricacao < TODAY THEN DO:

                                 RUN utp/ut-msgs.p (INPUT 'show',
                                                    INPUT 17006,
                                                    INPUT "Data de Fabrica‡Æo Inv lida!"
                                                    + "~~" +
                                                    "A data de fabrica‡Æo informada + os meses de validade da fam¡lia resultam numa data de validade inferior ao dia de hoje. Revise a data de fabrica‡Æo informada.").

                                 RUN pi-finalizar IN h-acomp.
                                   
                                 UNDO BlocoRetorno, RETURN NO-APPLY.

                             END.

                             CREATE tt-movto.

                             assign tt-movto.ct-codigo = estab-mat.cod-cta-transf-unif
                                    tt-movto.sc-codigo = estab-mat.cod-ccusto-transf-unif.  

                             assign tt-movto.cod-versao-integracao = 1 
                                    tt-movto.dt-trans       = tt-gera-transf.dt-trans
                                    tt-movto.nro-docto      = tt-gera-transf.nro-docto
                                    tt-movto.serie-docto    = tt-gera-transf.serie-docto
                                    tt-movto.cod-depos      = tt-gera-transf.dep-saida
                                    tt-movto.cod-estabel    = tt-gera-transf.cod-estabel
                                    tt-movto.it-codigo      = tt-gera-transf.it-codigo
                                    tt-movto.cod-localiz    = tt-gera-transf.loc-saida
                                    tt-movto.lote           = tt-gera-transf.lote
                                    tt-movto.dt-vali-lote   = date(month(tt-gera-transf.dt-fabricacao), 1, year(tt-gera-transf.dt-fabricacao))
                                    tt-movto.cod-refer      = tt-gera-transf.cod-refer
                                    tt-movto.quantidade     = tt-gera-transf.quantidade
                                    tt-movto.un             = ITEM.un
                                    tt-movto.esp-docto      = 33
                                    tt-movto.tipo-trans     = 2
                                    tt-movto.descricao-db   = tt-gera-transf.narrativa
                                    tt-movto.cod-prog-orig  = "v03in218"
                                    tt-movto.cod-emitente   = tt-gera-transf.cod-emitente
                                    tt-movto.usuario        = c-seg-usuario
                                    tt-movto.cod-unid-negoc = item-uni-estab.cod-unid-negoc.

                             CREATE tt-movto.

                             assign tt-movto.ct-codigo = estab-mat.cod-cta-transf-unif
                                    tt-movto.sc-codigo = estab-mat.cod-ccusto-transf-unif.  

                             assign tt-movto.cod-versao-integracao = 1 
                                    tt-movto.dt-trans       = tt-gera-transf.dt-trans
                                    tt-movto.nro-docto      = tt-gera-transf.nro-docto
                                    tt-movto.serie-docto    = tt-gera-transf.serie-docto
                                    tt-movto.cod-depos      = tt-gera-transf.dep-ent
                                    tt-movto.cod-estabel    = tt-gera-transf.cod-estabel
                                    tt-movto.it-codigo      = tt-gera-transf.it-codigo
                                    tt-movto.cod-localiz    = tt-gera-transf.loc-ent
                                    tt-movto.lote           = tt-gera-transf.lote
                                    tt-movto.dt-vali-lote   = date(month(tt-gera-transf.dt-fabricacao), 1, year(tt-gera-transf.dt-fabricacao))
                                    tt-movto.cod-refer      = tt-gera-transf.cod-refer
                                    tt-movto.quantidade     = tt-gera-transf.quantidade
                                    tt-movto.un             = ITEM.un
                                    tt-movto.esp-docto      = 33
                                    tt-movto.tipo-trans     = 1
                                    tt-movto.descricao-db   = tt-gera-transf.narrativa
                                    tt-movto.cod-prog-orig  = "v03in218"
                                    tt-movto.cod-emitente   = tt-gera-transf.cod-emitente
                                    tt-movto.usuario        = c-seg-usuario
                                    tt-movto.cod-unid-negoc = item-uni-estab.cod-unid-negoc.

                       END.

                       RUN pi-acompanhar IN h-acomp (INPUT "Gerando Transferˆncia").

                       RUN cep/ceapi001k.p persistent set h-ceapi001k.
                       
                       RUN pi-execute IN h-ceapi001k (input-output table tt-movto,
                                                      input-output table tt-erro, 
                                                      INPUT l-deleta-erros).

                       FIND FIRST tt-erro NO-LOCK no-error.

                       IF RETURN-VALUE = "NOK":U OR AVAIL tt-erro THEN DO:
                            run cdp/cd0666.w (input table tt-erro).
                            l-erro = yes.  

                            RUN pi-finalizar IN h-acomp.

                            FOR EACH tt-erro.
                                DELETE tt-erro.
                            END.

                            UNDO BlocoRetorno, RETURN NO-APPLY.

                       END.

                       ELSE DO:

                           FOR EACH tt-gera-transf NO-LOCK
                              WHERE tt-gera-transf.l-considera = "*",
                               EACH ITEM NO-LOCK 
                              WHERE ITEM.it-codigo = tt-gera-transf.it-codigo
                               AND (ITEM.tipo-con-est = 3 OR ITEM.tipo-con-est = 4),
                               EACH saldo-estoq EXCLUSIVE-LOCK
                              WHERE saldo-estoq.it-codigo = tt-gera-transf.it-codigo
                                AND saldo-estoq.lote      = tt-gera-transf.lote:

                                   ASSIGN saldo-estoq.dt-vali-lote = date(month(tt-gera-transf.dt-fabricacao), 1, year(tt-gera-transf.dt-fabricacao)).

                           END.

                            /* WMS X CQ */
                           RUN wmp/eswm9035.p (INPUT-OUTPUT table tt-gera-transf,
                                               INPUT-OUTPUT table tt-erro).

                           FIND FIRST tt-erro NO-LOCK no-error.

                           IF RETURN-VALUE = "NOK":U OR AVAIL tt-erro THEN DO:

                                 run cdp/cd0666.w (input table tt-erro).

                                 l-erro = yes.  
                
                                 RUN pi-finalizar IN h-acomp.
                
                                 FOR EACH tt-erro.
                                     DELETE tt-erro.
                                 END.
                
                                 UNDO BlocoRetorno, RETURN NO-APPLY.
                
                           END.

                       END.

                       RUN pi-finalizar IN h-acomp.
                       
                       FOR EACH tt-gera-transf NO-LOCK
                          WHERE tt-gera-transf.l-considera = "*".
    
                           FIND FIRST ficha-cq 
                                WHERE ficha-cq.nr-ficha = tt-gera-transf.nr-ficha NO-ERROR.
    
                           IF AVAIL ficha-cq THEN DO: 
                               
                               ASSIGN ficha-cq.qt-apr-cond      = ficha-cq.qt-apr-cond + tt-gera-transf.quantidade
                                      ficha-cq.inspecionado     = YES
                                      ficha-cq.situacao         = 4
                                      ficha-cq.dt-ult-sit       = TODAY
                                      ficha-cq.liberada         = YES
                                      ficha-cq.cod-resp         = c-seg-usuario
                                      ficha-cq.narrativa        = c-texto.
    
                               IF ficha-cq.dt-inspecao = ? THEN ASSIGN ficha-cq.dt-inspecao = tt-gera-transf.dt-trans.
    
                               /* ATUALIZA€ÇO DA INSPE€ÇO DO FORNECEDOR */
                               {cdp/cd9320.i}

                               RELEASE item-fornec.
                               RELEASE item-fornec-estab.

                           END.

                       END.

                   END.

               END.

            END.

            /* REJEITADO */
            if  c-op-des = "3" then do:

               EMPTY TEMP-TABLE tt-gera-transf.
               EMPTY TEMP-TABLE tt-movto.

               FIND FIRST ficha-cq NO-LOCK
                    WHERE ROWID(ficha-cq) = r-ficha-cq NO-ERROR.

               IF AVAIL ficha-cq THEN DO:

                   FOR EACH b-ficha-cq NO-LOCK
                      WHERE b-ficha-cq.cod-emitente = ficha-cq.cod-emitente
                        AND b-ficha-cq.serie-docto  = ficha-cq.serie-docto
                        AND b-ficha-cq.nat-operacao = ficha-cq.nat-operacao
                        AND b-ficha-cq.nro-docto    = ficha-cq.nro-docto
                        AND b-ficha-cq.lote         = ficha-cq.lote 
                        AND b-ficha-cq.situacao    >= 1
                        AND b-ficha-cq.situacao    <= 3,
                      FIRST tt-ficha
                      WHERE tt-ficha.l-marcado
                        AND tt-ficha.nr-ficha       = b-ficha-cq.nr-ficha.

                       CREATE tt-gera-transf.
                       ASSIGN tt-gera-transf.l-considera   = ""
                              tt-gera-transf.cod-estabel   = b-ficha-cq.cod-estabel
                              tt-gera-transf.nr-ficha      = b-ficha-cq.nr-ficha
                              tt-gera-transf.it-codigo     = b-ficha-cq.it-codigo
                              tt-gera-transf.quantidade    = (b-ficha-cq.qt-original - b-ficha-cq.qt-consumida -
                                                              b-ficha-cq.qt-aprovada - b-ficha-cq.qt-rejeitada -
                                                              b-ficha-cq.qt-apr-cond)
                              tt-gera-transf.lote          = b-ficha-cq.lote
                              tt-gera-transf.dep-saida     = b-ficha-cq.cod-depos
                              tt-gera-transf.loc-saida     = b-ficha-cq.cod-localiz
                              tt-gera-transf.cod-refer     = b-ficha-cq.cod-refer
                              tt-gera-transf.dt-fabricacao = b-ficha-cq.dt-ficha
                              tt-gera-transf.nro-docto     = b-ficha-cq.nro-docto
                              tt-gera-transf.serie-docto   = b-ficha-cq.serie-docto
                              tt-gera-transf.narrativa     = b-ficha-cq.narrativa
                              tt-gera-transf.cod-emitente  = b-ficha-cq.cod-emitente
                              tt-gera-transf.dt-trans      = de-inspecao.

                       FIND FIRST ITEM NO-LOCK
                            WHERE ITEM.it-codigo = b-ficha-cq.it-codigo NO-ERROR.

                              IF AVAIL ITEM THEN DO:

                                  ASSIGN tt-gera-transf.desc-item = ITEM.desc-item.

                              END.

                       //Valida se Observacao na ficha de inspecao esta preenchida - M2008-082 - 08/03/21 - IAB 
                       RUN pi-valida-obs-insp.

                       IF RETURN-VALUE = "NOK" THEN
                          DELETE tt-gera-transf.

                   END.


                   FIND FIRST tt-gera-transf NO-ERROR.

                   IF NOT AVAIL tt-gera-transf THEN 
                      UNDO BlocoRetorno, RETURN NO-APPLY.


                   RUN cqp/escq0210e-re.w (INPUT-OUTPUT TABLE tt-gera-transf,
                                           OUTPUT l-ok).  

                   IF l-ok = NO THEN DO:

                        UNDO BlocoRetorno, RETURN NO-APPLY.
                                
                   END.

                   ELSE DO:

                       RUN pi-inicializar in h-acomp ("Processando Retorno"). 

                       EMPTY TEMP-TABLE tt-movto.

                       FOR EACH tt-gera-transf NO-LOCK
                          WHERE tt-gera-transf.l-considera = "*".

                             FIND FIRST ITEM NO-LOCK
                                  WHERE ITEM.it-codigo = tt-gera-transf.it-codigo NO-ERROR.
                            
                             find estab-mat where
                                  estab-mat.cod-estabel = tt-gera-transf.cod-estabel no-lock no-error.

                             FIND FIRST item-uni-estab NO-LOCK
                                  WHERE item-uni-estab.it-codigo   = tt-gera-transf.it-codigo
                                    AND item-uni-estab.cod-estabel = tt-gera-transf.cod-estabel NO-ERROR.

                             FIND FIRST int-familia NO-LOCK
                                  WHERE int-familia.fm-codigo = ITEM.fm-codigo NO-ERROR.

                             IF AVAIL int-familia THEN DO: 
                                 
                                 ASSIGN tt-gera-transf.dt-fabricacao = tt-gera-transf.dt-fabricacao + (int-familia.meses-validade * 30).

                             END.

                             IF tt-gera-transf.dt-fabricacao < TODAY THEN DO:

                                 RUN utp/ut-msgs.p (INPUT 'show',
                                                    INPUT 17006,
                                                    INPUT "Data de Fabrica‡Æo Inv lida!"
                                                    + "~~" +
                                                    "A data de fabrica‡Æo informada + os meses de validade da fam¡lia resultam numa data de validade inferior ao dia de hoje. Revise a data de fabrica‡Æo informada.").

                                 RUN pi-finalizar IN h-acomp.
                                   
                                 UNDO BlocoRetorno, RETURN NO-APPLY.

                             END.

                             CREATE tt-movto.

                             assign tt-movto.ct-codigo = estab-mat.cod-cta-transf-unif
                                    tt-movto.sc-codigo = estab-mat.cod-ccusto-transf-unif.  

                             assign tt-movto.cod-versao-integracao = 1 
                                    tt-movto.dt-trans       = tt-gera-transf.dt-trans
                                    tt-movto.nro-docto      = tt-gera-transf.nro-docto
                                    tt-movto.serie-docto    = tt-gera-transf.serie-docto
                                    tt-movto.cod-depos      = tt-gera-transf.dep-saida
                                    tt-movto.cod-estabel    = tt-gera-transf.cod-estabel
                                    tt-movto.it-codigo      = tt-gera-transf.it-codigo
                                    tt-movto.cod-localiz    = tt-gera-transf.loc-saida
                                    tt-movto.lote           = tt-gera-transf.lote
                                    tt-movto.dt-vali-lote   = date(month(tt-gera-transf.dt-fabricacao), 1, year(tt-gera-transf.dt-fabricacao))
                                    tt-movto.cod-refer      = tt-gera-transf.cod-refer
                                    tt-movto.quantidade     = tt-gera-transf.quantidade
                                    tt-movto.un             = ITEM.un
                                    tt-movto.esp-docto      = 33
                                    tt-movto.tipo-trans     = 2
                                    tt-movto.descricao-db   = tt-gera-transf.narrativa
                                    tt-movto.cod-prog-orig  = "v03in218"
                                    tt-movto.cod-emitente   = tt-gera-transf.cod-emitente
                                    tt-movto.usuario        = c-seg-usuario
                                    tt-movto.cod-unid-negoc = item-uni-estab.cod-unid-negoc.

                             CREATE tt-movto.

                             assign tt-movto.ct-codigo = estab-mat.cod-cta-transf-unif
                                    tt-movto.sc-codigo = estab-mat.cod-ccusto-transf-unif.  

                             assign tt-movto.cod-versao-integracao = 1 
                                    tt-movto.dt-trans       = tt-gera-transf.dt-trans
                                    tt-movto.nro-docto      = tt-gera-transf.nro-docto
                                    tt-movto.serie-docto    = tt-gera-transf.serie-docto
                                    tt-movto.cod-depos      = tt-gera-transf.dep-ent
                                    tt-movto.cod-estabel    = tt-gera-transf.cod-estabel
                                    tt-movto.it-codigo      = tt-gera-transf.it-codigo
                                    tt-movto.cod-localiz    = tt-gera-transf.loc-ent
                                    tt-movto.lote           = tt-gera-transf.lote
                                    tt-movto.dt-vali-lote   = date(month(tt-gera-transf.dt-fabricacao), 1, year(tt-gera-transf.dt-fabricacao))
                                    tt-movto.cod-refer      = tt-gera-transf.cod-refer
                                    tt-movto.quantidade     = tt-gera-transf.quantidade
                                    tt-movto.un             = ITEM.un
                                    tt-movto.esp-docto      = 33
                                    tt-movto.tipo-trans     = 1
                                    tt-movto.descricao-db   = tt-gera-transf.narrativa
                                    tt-movto.cod-prog-orig  = "v03in218"
                                    tt-movto.cod-emitente   = tt-gera-transf.cod-emitente
                                    tt-movto.usuario        = c-seg-usuario
                                    tt-movto.cod-unid-negoc = item-uni-estab.cod-unid-negoc.

                       END.

                       RUN pi-acompanhar IN h-acomp (INPUT "Gerando Transferˆncia").

                       RUN cep/ceapi001k.p persistent set h-ceapi001k.
                       
                       RUN pi-execute IN h-ceapi001k (input-output table tt-movto,
                                                      input-output table tt-erro, 
                                                      INPUT l-deleta-erros).

                       FIND FIRST tt-erro NO-LOCK no-error.

                       IF RETURN-VALUE = "NOK":U OR AVAIL tt-erro THEN DO:
                            run cdp/cd0666.w (input table tt-erro).
                            l-erro = yes.  

                            RUN pi-finalizar IN h-acomp.

                            FOR EACH tt-erro.
                                DELETE tt-erro.
                            END.

                            UNDO BlocoRetorno, RETURN NO-APPLY.

                       END.

                       ELSE DO:

                           RUN pi-finalizar IN h-acomp.

                           FOR EACH tt-gera-transf NO-LOCK
                              WHERE tt-gera-transf.l-considera = "*".

                               FIND FIRST ficha-cq 
                                    WHERE ficha-cq.nr-ficha = tt-gera-transf.nr-ficha NO-ERROR.

                               IF AVAIL ficha-cq THEN DO: 
                                   
                                   ASSIGN ficha-cq.qt-rejeitada  = ficha-cq.qt-rejeitada + tt-gera-transf.quantidade
                                          ficha-cq.qt-a-liberar  = ficha-cq.qt-a-liberar + tt-gera-transf.quantidade
                                          ficha-cq.inspecionado = YES
                                          ficha-cq.situacao     = 4
                                          ficha-cq.dt-ult-sit   = TODAY
                                          ficha-cq.cod-resp     = c-seg-usuario
                                          ficha-cq.narrativa    = c-texto.

                                   IF ficha-cq.dt-inspecao = ? THEN ASSIGN ficha-cq.dt-inspecao = tt-gera-transf.dt-trans.

                                        FIND FIRST rej-ficha NO-LOCK
                                             WHERE rej-ficha.nr-ficha = ficha-cq.nr-ficha NO-ERROR.

                                        IF NOT AVAIL rej-ficha THEN DO:

                                           create rej-ficha.
                                           assign rej-ficha.nr-ficha     = ficha-cq.nr-ficha 
                                                  rej-ficha.dep-rej      = tt-gera-transf.dep-ent
                                                  rej-ficha.codigo-rejei = tt-gera-transf.cod-rej
                                                  rej-ficha.observacao   = tt-gera-transf.obs
                                                  rej-ficha.qt-rejeitada = tt-gera-transf.quantidade
                                                  rej-ficha.quant-rej    = tt-gera-transf.quantidade.  
                                        END.

                                   /* ATUALIZA€ÇO DA INSPE€ÇO DO FORNECEDOR */
                                   {cdp/cd9320.i}

                                   RELEASE item-fornec.
                                   RELEASE item-fornec-estab.

                               END.

                           END.

                       END.

                   END.

               END.

            END.

            /* PERDA */
            if  c-op-des = "4" THEN DO:

               EMPTY TEMP-TABLE tt-gera-transf.
               EMPTY TEMP-TABLE tt-movto.

               FIND FIRST ficha-cq NO-LOCK
                    WHERE ROWID(ficha-cq) = r-ficha-cq NO-ERROR.

               IF AVAIL ficha-cq THEN DO:

                   FOR EACH b-ficha-cq NO-LOCK
                      WHERE b-ficha-cq.cod-emitente = ficha-cq.cod-emitente
                        AND b-ficha-cq.serie-docto  = ficha-cq.serie-docto
                        AND b-ficha-cq.nat-operacao = ficha-cq.nat-operacao
                        AND b-ficha-cq.nro-docto    = ficha-cq.nro-docto
                        AND b-ficha-cq.lote         = ficha-cq.lote 
                        AND b-ficha-cq.situacao    >= 1
                        AND b-ficha-cq.situacao    <= 3,
                      FIRST tt-ficha
                      WHERE tt-ficha.l-marcado
                        AND tt-ficha.nr-ficha       = b-ficha-cq.nr-ficha.

                       CREATE tt-gera-transf.
                       ASSIGN tt-gera-transf.l-considera   = ""
                              tt-gera-transf.cod-estabel   = b-ficha-cq.cod-estabel
                              tt-gera-transf.nr-ficha      = b-ficha-cq.nr-ficha
                              tt-gera-transf.it-codigo     = b-ficha-cq.it-codigo
                              tt-gera-transf.quantidade    = (b-ficha-cq.qt-original - b-ficha-cq.qt-consumida -
                                                              b-ficha-cq.qt-aprovada - b-ficha-cq.qt-rejeitada -
                                                              b-ficha-cq.qt-apr-cond)
                              tt-gera-transf.lote          = b-ficha-cq.lote
                              tt-gera-transf.dep-saida     = b-ficha-cq.cod-depos
                              tt-gera-transf.loc-saida     = b-ficha-cq.cod-localiz
                              tt-gera-transf.cod-refer     = b-ficha-cq.cod-refer
                              tt-gera-transf.dt-fabricacao = b-ficha-cq.dt-ficha
                              tt-gera-transf.nro-docto     = b-ficha-cq.nro-docto
                              tt-gera-transf.serie-docto   = b-ficha-cq.serie-docto
                              tt-gera-transf.narrativa     = b-ficha-cq.narrativa
                              tt-gera-transf.cod-emitente  = b-ficha-cq.cod-emitente
                              tt-gera-transf.dt-trans      = de-inspecao.

                       FIND FIRST ITEM NO-LOCK
                            WHERE ITEM.it-codigo = b-ficha-cq.it-codigo NO-ERROR.

                              IF AVAIL ITEM THEN DO:

                                  ASSIGN tt-gera-transf.desc-item = ITEM.desc-item.

                              END.

                       //Valida se Observacao na ficha de inspecao esta preenchida - M2008-082 - 08/03/21 - IAB 
                       RUN pi-valida-obs-insp.

                       IF RETURN-VALUE = "NOK" THEN
                          DELETE tt-gera-transf.

                   END.


                   FIND FIRST tt-gera-transf NO-ERROR.

                   IF NOT AVAIL tt-gera-transf THEN 
                      UNDO BlocoRetorno, RETURN NO-APPLY.



                   RUN cqp/escq0210e-pe.w (INPUT-OUTPUT TABLE tt-gera-transf,
                                           OUTPUT l-ok).  

                   IF l-ok = NO THEN DO:

                        UNDO BlocoRetorno, RETURN NO-APPLY.
                                
                   END.

                   ELSE DO:

                       RUN pi-inicializar in h-acomp ("Processando Retorno"). 

                       EMPTY TEMP-TABLE tt-movto.

                       FOR EACH tt-gera-transf NO-LOCK
                          WHERE tt-gera-transf.l-considera = "*".

                             CREATE tt-movto.

                             FIND FIRST ITEM NO-LOCK
                                  WHERE ITEM.it-codigo = tt-gera-transf.it-codigo NO-ERROR.

                             FIND FIRST item-uni-estab NO-LOCK
                                  WHERE item-uni-estab.it-codigo   = tt-gera-transf.it-codigo
                                    AND item-uni-estab.cod-estabel = tt-gera-transf.cod-estabel NO-ERROR.

                             assign tt-movto.cod-versao-integracao = 1 
                                    tt-movto.ct-codigo      = tt-gera-transf.ct-codigo
                                    tt-movto.sc-codigo      = tt-gera-transf.sc-codigo
                                    tt-movto.dt-trans       = tt-gera-transf.dt-trans
                                    tt-movto.nro-docto      = tt-gera-transf.nro-docto
                                    tt-movto.serie-docto    = tt-gera-transf.serie-docto
                                    tt-movto.cod-depos      = tt-gera-transf.dep-saida
                                    tt-movto.cod-estabel    = tt-gera-transf.cod-estabel
                                    tt-movto.it-codigo      = tt-gera-transf.it-codigo
                                    tt-movto.cod-localiz    = tt-gera-transf.loc-saida
                                    tt-movto.lote           = tt-gera-transf.lote
                                    tt-movto.dt-vali-lote   = tt-gera-transf.dt-fabricacao
                                    tt-movto.cod-refer      = tt-gera-transf.cod-refer
                                    tt-movto.quantidade     = tt-gera-transf.quantidade
                                    tt-movto.un             = ITEM.un
                                    tt-movto.esp-docto      = 28
                                    tt-movto.tipo-trans     = 2
                                    tt-movto.descricao-db   = tt-gera-transf.narrativa
                                    tt-movto.cod-prog-orig  = "v04in218"
                                    tt-movto.cod-emitente   = tt-gera-transf.cod-emitente
                                    tt-movto.usuario        = c-seg-usuario
                                    tt-movto.cod-unid-negoc = item-uni-estab.cod-unid-negoc.

                       END.

                       RUN pi-acompanhar IN h-acomp (INPUT "Gerando Baixa").

                       RUN cep/ceapi001k.p persistent set h-ceapi001k.
                       
                       RUN pi-execute IN h-ceapi001k (input-output table tt-movto,
                                                      input-output table tt-erro, 
                                                      INPUT l-deleta-erros).

                       FIND FIRST tt-erro NO-LOCK no-error.

                       IF RETURN-VALUE = "NOK":U OR AVAIL tt-erro THEN DO:
                            run cdp/cd0666.w (input table tt-erro).
                            l-erro = yes.  

                            RUN pi-finalizar IN h-acomp.

                            FOR EACH tt-erro.
                                DELETE tt-erro.
                            END.

                            UNDO BlocoRetorno, RETURN NO-APPLY.

                       END.

                       ELSE DO:

                           RUN pi-finalizar IN h-acomp.

                           FOR EACH tt-gera-transf NO-LOCK
                              WHERE tt-gera-transf.l-considera = "*".

                               FIND FIRST ficha-cq 
                                    WHERE ficha-cq.nr-ficha = tt-gera-transf.nr-ficha NO-ERROR.

                               IF AVAIL ficha-cq THEN DO: 
                                   
                                   ASSIGN ficha-cq.qt-consumida = ficha-cq.qt-consumida + tt-gera-transf.quantidade
                                          ficha-cq.inspecionado = YES
                                          ficha-cq.situacao     = 4
                                          ficha-cq.dt-ult-sit   = TODAY
                                          ficha-cq.liberada     = YES
                                          ficha-cq.cod-resp     = c-seg-usuario
                                          ficha-cq.narrativa    = c-texto.

                                   IF ficha-cq.dt-inspecao = ? THEN ASSIGN ficha-cq.dt-inspecao = tt-gera-transf.dt-trans.

                                   /* ATUALIZA€ÇO DA INSPE€ÇO DO FORNECEDOR */
                                   {cdp/cd9320.i}

                                   RELEASE item-fornec.
                                   RELEASE item-fornec-estab.
                               END.
                           END.
                       END.
                   END.
               END.
            END.
        END.
    END.

    ELSE DO:
        RUN utp/ut-msgs.p (INPUT 'show',
                           INPUT 17006,
                           INPUT "Origem roteiro inv lida!"
                           + "~~" +
                           "Este programa aceita apenas roteiros originados no recebimento.").
        
        UNDO BlocoRetorno, RETURN NO-APPLY.

    END.
END.


//Valida se Observacao na ficha de inspecao esta preenchida - M2008-082 - 08/03/21 - IAB 
PROCEDURE pi-valida-obs-insp:

   FIND FIRST int-item-fornec NO-LOCK 
        WHERE int-item-fornec.cod-emitente = b-ficha-cq.cod-emitente 
          AND int-item-fornec.it-codigo = b-ficha-cq.it-codigo 
   NO-ERROR.
   
   IF AVAIL int-item-fornec THEN
   DO:
       IF int-item-fornec.obs-rec <> '' THEN
       DO:
           run utp/ut-msgs.p (input "show":U,
                   input 27100,                                            
                   input 'Deseja realmente liberar o Roteiro ?~~' + 'Item ' + upper(int-item-fornec.it-codigo) + ' possui observacao' +  CHR(13) + CHR(13) + 
                         'Conteudo: ' + upper(int-item-fornec.obs-rec)  ).
   
           IF RETURN-VALUE = 'no' THEN
              RETURN "NOK":U. 
       END.
   END.    
                       
END PROCEDURE.
