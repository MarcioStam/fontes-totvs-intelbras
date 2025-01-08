{include/i-epc200.i1}
{method/dbotterr.i}
{include/boerrtab.i}
{upc/btb910za-upc.i}

/* {inbo/boin176.i tt-item-doc-est} Nao compila no unix */

DEFINE TEMP-TABLE tt-item-doc-est NO-UNDO like item-doc-est
    field r-rowid  as rowid.

DEFINE INPUT PARAMETER p-ind-event  AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-epc.

def shared var c-seg-usuario  as char format "x(12)" no-undo.
DEF VAR h-bo-handle          AS HANDLE  NO-UNDO.
def var l-perm    as logical         no-undo.
DEF BUFFER bf-item-uni-estab FOR item-uni-estab.

/* main block */
case p-ind-event:
    when 'ValidateRecord' then do:
        /* Permisso de entrada somente para depsitos cadastrados para o usurio */

        FOR FIRST tt-epc WHERE tt-epc.cod-event = p-ind-event:
            IF  NOT VALID-HANDLE(WIDGET-HANDLE(tt-epc.val-parameter)) THEN RETURN "OK".
            ASSIGN h-bo-handle = widget-handle(tt-epc.val-parameter).

            run getRecord in h-bo-handle ( output TABLE tt-item-doc-est).
            find first tt-item-doc-est no-error.
            if NOT AVAIL tt-item-doc-est then RETURN "OK".

            FIND natur-oper 
                WHERE natur-oper.nat-operacao = tt-item-doc-est.nat-operacao NO-LOCK NO-ERROR.

            IF   AVAIL natur-oper AND natur-oper.terceiros THEN DO:
                 IF  CAN-FIND (FIRST int-natur-oper-item
                                  WHERE int-natur-oper-item.nat-operacao = tt-item-doc-est.nat-operacao 
                                    AND int-natur-oper-item.it-codigo    = tt-item-doc-est.it-codigo) THEN DO:
                     
                     run _insertErrorManual in h-bo-handle (INPUT 99999,
                                                            INPUT "EMS",
                                                            INPUT "ERROR",
                                                            INPUT "Item " + tt-item-doc-est.it-codigo + " no pode ser movimentado com natureza de operao que atualiza saldo em poder de terceiros",
                                                            INPUT "Item " + tt-item-doc-est.it-codigo + " no pode ser movimentado com natureza de operao que atualiza saldo em poder de terceiros",
                                                            INPUT "").
                     RETURN "NOK".
                 END.
            END.


            FIND FIRST rat-lote
                 WHERE rat-lote.serie-docto  = tt-item-doc-est.serie-docto
                   AND rat-lote.nro-docto    = tt-item-doc-est.nro-docto
                   AND rat-lote.cod-emitente = tt-item-doc-est.cod-emitente
                   AND rat-lote.nat-operacao = tt-item-doc-est.nat-operacao
                   AND rat-lote.sequencia    = tt-item-doc-est.sequencia NO-LOCK NO-ERROR.
            IF NOT AVAIL rat-lote THEN RETURN "OK".

            find docum-est where 
                 docum-est.serie-docto  = tt-item-doc-est.serie-docto  and 
                 docum-est.nro-docto    = tt-item-doc-est.nro-docto    and 
                 docum-est.cod-emitente = tt-item-doc-est.cod-emitente and 
                 docum-est.nat-operacao = tt-item-doc-est.nat-operacao no-lock no-error.
            IF AVAIL docum-est 
                 AND docum-est.cod-estabel = "101" THEN DO:
                FIND ITEM WHERE
                     ITEM.it-codigo = tt-item-doc-est.it-codigo NO-LOCK NO-ERROR.
                IF ITEM.tipo-contr = 2 
                   and tt-item-doc-est.cod-depos <> "" THEN DO: /* Item controle total */

                    FIND FIRST usu-dep
                         WHERE usu-dep.cod-depos = rat-lote.cod-depos
                           AND usu-dep.usuario   = c-seg-usuario
                           AND usu-dep.programa  = "re1001" NO-LOCK NO-ERROR.
                    IF NOT AVAIL usu-dep
                        OR AVAIL usu-dep
                             AND usu-dep.entrada = NO THEN DO:

                        run _insertErrorManual in h-bo-handle (
                                                        INPUT 0,
                                                        INPUT "EMS":U,
                                                        INPUT "ERROR":U,
                                                        INPUT "Usurio no tem permisso de entrada neste depsito",
                                                        INPUT "Usurio no tem permisso de entrada neste depsito",
                                                        INPUT "":U).

                        RETURN "NOK".
                    END.
                END.
                /* Tarefa 3818 - Solicitado pelo Hudson. Quando desmarcado o parmetro FIFO Ordem Compra e nao informado pedido no item dever exibir uma advertncia  */
                IF tt-item-doc-est.LOG-1 = NO AND
                   tt-item-doc-est.num-pedido = 0 THEN DO:
                    FIND natur-oper WHERE
                         natur-oper.nat-operacao = tt-item-doc-est.nat-operacao NO-LOCK NO-ERROR.
                    IF natur-oper.tipo-compra = 1 THEN DO:
                        run _insertErrorManual in h-bo-handle (
                                                        INPUT 15825,
                                                        INPUT "EMS":U,
                                                        INPUT "INFORMATION":U,
                                                        INPUT "FIFO desmarcado e pedido de compra no informado.",
                                                        INPUT "FIFO desmarcado e pedido de compra no informado.",
                                                        INPUT "":U).

                        RETURN "NOK".
                    END.
                END.
                IF docum-est.esp-docto = 23 THEN DO:
                    IF docum-est.cod-estabel = "104" THEN DO:
                        FIND item-uni-estab WHERE
                             item-uni-estab.cod-estabel = docum-est.cod-estabel AND
                             item-uni-estab.it-codigo   = tt-item-doc-est.it-codigo NO-LOCK NO-ERROR.
                        IF NOT AVAIL item-uni-estab THEN DO:
                            FIND FIRST bf-item-uni-estab
                                 WHERE bf-item-uni-estab.it-codigo   = tt-item-doc-est.it-codigo 
                                   AND bf-item-uni-estab.cod-estabel = "101" NO-LOCK NO-ERROR.
                            IF AVAIL bf-item-uni-estab THEN DO:
                                CREATE item-uni-estab.
                                BUFFER-COPY bf-item-uni-estab EXCEPT cod-estabel TO item-uni-estab.
                                ASSIGN bf-item-uni-estab.cod-estabel = "104"
                                       bf-item-uni-estab.preco-ul-ent = 0.
                            END.
                        END.
                    END.
                END.
            END.
        end.
    end.
    when 'aftercreateRecord' then do:

       FOR FIRST tt-epc WHERE tt-epc.cod-event = p-ind-event:
          IF  NOT VALID-HANDLE(WIDGET-HANDLE(tt-epc.val-parameter)) THEN RETURN "OK".
          ASSIGN h-bo-handle = widget-handle(tt-epc.val-parameter).

          run getRecord in h-bo-handle ( output TABLE tt-item-doc-est).
          find first tt-item-doc-est no-error.
          if NOT AVAIL tt-item-doc-est then RETURN "OK".

          FIND FIRST docum-est where 
                     docum-est.serie-docto  = tt-item-doc-est.serie-docto  and 
                     docum-est.nro-docto    = tt-item-doc-est.nro-docto    and 
                     docum-est.cod-emitente = tt-item-doc-est.cod-emitente and 
                     docum-est.nat-operacao = tt-item-doc-est.nat-operacao 
                     no-error.

          FIND natur-oper WHERE
               natur-oper.nat-operacao = tt-item-doc-est.nat-operacao 
               NO-LOCK NO-ERROR.

          IF AVAIL natur-oper 
             AND AVAIL docum-est
             AND substring(tt-item-doc-est.char-2,941,2) = ""  /* Verifica se j tem Tipo de Servio no item */
             AND substring(docum-est.char-2,256,1)       = "S" /* Marcada Reinf no re1001 */
           /*  AND CAN-FIND(FIRST int-natur-oper NO-LOCK
                 WHERE int-natur-oper.nat-operacao = natur-oper.nat-operacao
                   AND int-natur-oper.cod-observa  = 4) /* Servio */ */
          THEN DO:
             FIND FIRST fornec_financ WHERE
                        fornec_financ.cod_empresa    = "1" AND
                        fornec_financ.cdn_fornecedor = docum-est.cod-emitente
                        NO-LOCK NO-ERROR.

             IF AVAIL fornec_financ 
             THEN DO:
                FIND FIRST tab-serv-inss WHERE
                           tab-serv-inss.cod-livre-1 = STRING(fornec_financ.num_tip_serv_mdo)
                           NO-LOCK NO-ERROR.

                FIND FIRST item-doc-est OF tt-item-doc-est NO-ERROR.

                IF  AVAIL tab-serv-inss
                AND AVAIL item-doc-est
                THEN ASSIGN substring(item-doc-est.char-2,941,2) = string(tab-serv-inss.cdn-serv-inss).
             END.
          END.

          /* Busca dados CD0303 Nicolas - Conforme Totvs no busca simples nacional quando vem do re0708 */
          FIND FIRST emitente WHERE
                     emitente.cod-emitente = docum-est.cod-emitente
                     NO-LOCK NO-ERROR.

          IF AVAIL emitente 
             AND SUBSTRING(emitente.char-1,133,1) = "S"
          THEN DO:

             FIND FIRST item-doc-est OF tt-item-doc-est NO-LOCK NO-ERROR.

             IF AVAIL item-doc-est
             THEN FIND FIRST ext-item-doc-est EXCLUSIVE-LOCK OF item-doc-est
                       WHERE ext-item-doc-est.cod-param = "simplesnacional"
                             NO-ERROR.

             IF AVAIL ext-item-doc-est 
             THEN DO:

                FIND FIRST sit-tribut-relacto WHERE
                           sit-tribut-relacto.cdn-tribut       = 4  AND
                           sit-tribut-relacto.idi-tip-docto    = 1  AND
                          (sit-tribut-relacto.cod-estab        = docum-est.cod-estabel  OR
                           sit-tribut-relacto.cod-estab        = "*") AND
                          (sit-tribut-relacto.cod-natur-operac = docum-est.nat-operacao OR
                           sit-tribut-relacto.cod-natur-operac = "*") AND
                           sit-tribut-relacto.cdn-emitente     = docum-est.cod-emitente AND
                           sit-tribut-relacto.dat-valid-inic  <= TODAY
                           NO-LOCK NO-ERROR.

                IF AVAIL sit-tribut-relacto
                     AND sit-tribut-relacto.val-livre-1 <> 0 
                     THEN ASSIGN ext-item-doc-est.val-livre-1 = sit-tribut-relacto.val-livre-1
                                 ext-item-doc-est.val-livre-2 = item-doc-est.preco-total[1]
                                 ext-item-doc-est.val-livre-3 = (ext-item-doc-est.val-livre-2 * ext-item-doc-est.val-livre-1) / 100.
             END.
          END.
       END.
    END.
end case.
RETURN "Ok":U.
