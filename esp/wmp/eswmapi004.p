/********************************************************************************
**  Programa: ESWMAPI004.P
**  Data....: ABRIL / 2022
**  Autor...: STOUT / SCM Concept
**  Objetivo: API para desfazer gera‡Æo de etiqueta e saldo para ressuprimento 
**            de flow rack.
********************************************************************************/
{include/i-prgvrs.i ESWMAPI004 2.00.00.001}  /*** 010001 ***/
{include/i_dbvers.i}
{utp/ut-glob.i}
{method/dbotterr.i}

DEFINE INPUT  PARAMETER pRowid      AS ROWID       NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

DEFINE BUFFER bf-box-saldo FOR wm-box-saldo.
DEFINE BUFFER bf-box-saldo-etiqueta FOR wm-box-saldo-etiqueta.
DEFINE BUFFER bf-etiqueta FOR wm-etiqueta.
DEFINE BUFFER bf-box-sdo-alocad FOR wms-box-sdo-alocad.
DEFINE BUFFER bf-box-movto FOR wm-box-movto.
DEFINE BUFFER bf-item-embalagem-local FOR wm-item-embalagem-local.
DEFINE BUFFER bf-box FOR wm-box.

FOR FIRST wm-box-movto NO-LOCK
    WHERE ROWID(wm-box-movto) = pRowid:
END.

IF NOT AVAIL wm-box-movto THEN DO:
    RUN piCreateError (INPUT 56,
                       INPUT "Movimento de Sa¡da").
    RETURN "NOK".
END.

IF wm-box-movto.ind-tipo-movto <> 1 THEN DO:
    RUN piCreateError (INPUT 17006,
                       INPUT "Movimento deve ser de entrada").
    RETURN "NOK".
END.

IF wm-box-movto.ind-status-movto = 3 THEN DO:
    RUN piCreateError (INPUT 17006,
                       INPUT "Movimento j  concluido").
    RETURN "NOK".
END.

FOR FIRST bf-box-movto NO-LOCK
    WHERE bf-box-movto.cod-estabel    = wm-box-movto.cod-estabel
      AND bf-box-movto.cod-local      = wm-box-movto.cod-local
      AND bf-box-movto.id-movto       = wm-box-movto.id-movto
      AND bf-box-movto.ind-tipo-movto = 2:
END.

FOR FIRST wm-box-saldo USE-INDEX idx-box-saldo10 NO-LOCK
    WHERE wm-box-saldo.cod-estabel = wm-box-movto.cod-estabel
      AND wm-box-saldo.cod-local   = wm-box-movto.cod-local
      AND wm-box-saldo.id-movto    = wm-box-movto.id-movto:
END.

IF NOT AVAIL wm-box-saldo THEN 
    RETURN "OK". /* se nao achou nÆo h  o que fazer */

FOR FIRST wm-box-saldo-etiqueta NO-LOCK
    WHERE wm-box-saldo-etiqueta.cod-estabel = wm-box-saldo.cod-estabel
      AND wm-box-saldo-etiqueta.cod-local   = wm-box-saldo.cod-local
      AND wm-box-saldo-etiqueta.id-saldo    = wm-box-saldo.id-saldo:
END.

IF AVAIL wm-box-saldo-etiqueta THEN
    FOR FIRST wm-etiqueta NO-LOCK
        WHERE wm-etiqueta.id-etiqueta = wm-box-saldo-etiqueta.id-etiqueta:
    END.

FOR FIRST wm-item NO-LOCK
    WHERE wm-item.cod-item = wm-etiqueta.cod-item:
END.

FIND FIRST bf-item-embalagem-local NO-LOCK
     WHERE bf-item-embalagem-local.cod-estabel   = wm-box-saldo.cod-estabel
       AND bf-item-embalagem-local.cod-local     = wm-box-saldo.cod-local
       AND bf-item-embalagem-local.cod-item      = wm-box-saldo.cod-item
       AND bf-item-embalagem-local.cod-emb-item  = wm-box-saldo.cod-embalagem /* procura em pai da atual */
       AND bf-item-embalagem-local.log-padrao    = YES NO-ERROR.

IF NOT AVAIL bf-item-embalagem-local THEN
    FIND FIRST bf-item-embalagem-local NO-LOCK
         WHERE bf-item-embalagem-local.cod-estabel   = wm-box-saldo.cod-estabel
           AND bf-item-embalagem-local.cod-local     = wm-box-saldo.cod-local
           AND bf-item-embalagem-local.cod-item      = wm-box-saldo.cod-item
           AND bf-item-embalagem-local.cod-emb-item  = wm-box-saldo.cod-embalagem NO-ERROR.

IF NOT AVAIL bf-item-embalagem-local THEN
    FIND FIRST bf-item-embalagem-local NO-LOCK
         WHERE bf-item-embalagem-local.cod-estabel   = wm-box-saldo.cod-estabel
           AND bf-item-embalagem-local.cod-local     = wm-box-saldo.cod-local
           AND bf-item-embalagem-local.cod-item      = wm-box-saldo.cod-item
           AND bf-item-embalagem-local.log-padrao    = YES NO-ERROR.

BLOCO:
DO TRANSACTION ON ERROR UNDO BLOCO, RETURN "NOK":

    FOR FIRST wm-box EXCLUSIVE-LOCK
        WHERE wm-box.cod-estabel = wm-box-movto.cod-estabel
          AND wm-box.cod-local   = wm-box-movto.cod-local
          AND wm-box.id-box      = wm-box-movto.id-box:
    END.

    FOR FIRST bf-box EXCLUSIVE-LOCK
        WHERE bf-box.cod-estabel = bf-box-movto.cod-estabel
          AND bf-box.cod-local   = bf-box-movto.cod-local
          AND bf-box.id-box      = bf-box-movto.id-box:
    END.

    FOR FIRST bf-box-saldo
        WHERE bf-box-saldo.cod-estabel      = wm-box-saldo.cod-estabel
          AND bf-box-saldo.cod-local        = wm-box-saldo.cod-local
          AND bf-box-saldo.id-box           = bf-box-movto.id-box  /* box saida */
          AND bf-box-saldo.cod-item         = wm-box-saldo.cod-item
          AND bf-box-saldo.cod-refer        = wm-box-saldo.cod-refer
          AND bf-box-saldo.cod-lote         = wm-box-saldo.cod-lote
          AND bf-box-saldo.cod-embalagem    = bf-item-embalagem-local.cod-embalagem
          AND bf-box-saldo.ind-status-saldo = 3:
    END.

    IF NOT AVAIL bf-box-saldo THEN DO: /* se palete ja retirado do picking, so converte o saldo atual em novo saldo de palete */
        CREATE bf-box-saldo.
        ASSIGN bf-box-saldo.cod-estabel      = wm-box-movto.cod-estabel
               bf-box-saldo.cod-local        = wm-box-movto.cod-local
               bf-box-saldo.id-docto         = wm-box-movto.id-docto
               bf-box-saldo.num-seq-item     = wm-box-movto.num-seq-item
               bf-box-saldo.cod-cliente      = wm-box-saldo.cod-cliente
               bf-box-saldo.cod-embalagem    = bf-item-embalagem-local.cod-embalagem
               bf-box-saldo.cod-item         = wm-box-saldo.cod-item
               bf-box-saldo.cod-refer        = wm-box-saldo.cod-refer
               bf-box-saldo.cod-lote         = wm-box-saldo.cod-lote
               bf-box-saldo.dt-atua-saldo    = TODAY
               bf-box-saldo.dt-transacao     = TODAY
               bf-box-saldo.id-box           = wm-box-saldo.id-box
               bf-box-saldo.id-saldo         = NEXT-VALUE(id-saldo-wms)
               bf-box-saldo.ind-status-box   = 1
               bf-box-saldo.ind-status-saldo = 3
               bf-box-saldo.qtd-item         = wm-box-saldo.qtd-item
               bf-box-saldo.qtd-item-bloq    = 0
               bf-box-saldo.qtd-original     = bf-box-saldo.qtd-item
               bf-box-saldo.id-movto         = wm-box-movto.id-movto.
    
        IF AVAIL wm-box-saldo-etiqueta THEN DO:
            CREATE bf-box-saldo-etiqueta.
            ASSIGN bf-box-saldo-etiqueta.cod-estabel = bf-box-saldo.cod-estabel
                   bf-box-saldo-etiqueta.cod-local   = bf-box-saldo.cod-local
                   bf-box-saldo-etiqueta.id-saldo    = bf-box-saldo.id-saldo
                   bf-box-saldo-etiqueta.id-box      = bf-box-saldo.id-box
                   bf-box-saldo-etiqueta.id-etiqueta = wm-box-saldo-etiqueta.id-etiqueta
                   bf-box-saldo-etiqueta.dt-ent-saldo = TODAY
                   bf-box-saldo-etiqueta.id-docto     = wm-box-movto.id-docto
                   bf-box-saldo-etiqueta.num-seq-item = wm-box-movto.num-seq-item.

            FIND CURRENT wm-box-saldo-etiqueta EXCLUSIVE-LOCK NO-ERROR.
            DELETE wm-box-saldo-etiqueta.

            FIND CURRENT wm-etiqueta EXCLUSIVE-LOCK NO-ERROR.
            ASSIGN wm-etiqueta.cod-embalagem = bf-box-saldo.cod-embalagem.
        END.

        FOR FIRST wms-box-sdo-alocad EXCLUSIVE-LOCK
             WHERE wms-box-sdo-alocad.cod-estabel   = wm-box-saldo.cod-estabel
               AND wms-box-sdo-alocad.cod-local     = wm-box-saldo.cod-local
               AND wms-box-sdo-alocad.cod-cliente   = wm-box-saldo.cod-cliente
               AND wms-box-sdo-alocad.id-box        = wm-box-saldo.id-box
               AND wms-box-sdo-alocad.id-docto      = wm-box-movto.id-docto           
               AND wms-box-sdo-alocad.num-seq-item  = wm-box-movto.num-seq-item 
               AND wms-box-sdo-alocad.cod-item      = wm-box-saldo.cod-item
               AND wms-box-sdo-alocad.cod-refer     = wm-box-saldo.cod-refer
               AND wms-box-sdo-alocad.cod-lote      = wm-box-saldo.cod-lote
               AND wms-box-sdo-alocad.cod-embalagem = bf-box-saldo.cod-embalagem:
            DELETE wms-box-sdo-alocad.
        END.

        /* acrescente box saida */
        ASSIGN bf-box.qtd-capacidade-peso-util = bf-box.qtd-capacidade-peso-util + (bf-item-embalagem-local.qtd-peso-item + (wm-item.qtd-peso * (bf-box-movto.qti-embalagem * bf-box-movto.qtd-item))) 
               bf-box.qtd-capacidade-ua-util   = bf-box.qtd-capacidade-ua-util   - (bf-item-embalagem-local.qtd-volume-item ).                 

        FIND CURRENT wm-box-saldo EXCLUSIVE-LOCK NO-ERROR.
        DELETE wm-box-saldo.
    END.
    ELSE DO: /* junta com o saldo que j  est  no endere‡o */

        FOR FIRST bf-box-saldo-etiqueta EXCLUSIVE-LOCK
            WHERE bf-box-saldo-etiqueta.cod-estabel = bf-box-saldo.cod-estabel
              AND bf-box-saldo-etiqueta.cod-local   = bf-box-saldo.cod-local
              AND bf-box-saldo-etiqueta.id-saldo    = bf-box-saldo.id-saldo
              AND bf-box-saldo-etiqueta.id-box      = bf-box-saldo.id-box:
            FOR FIRST bf-etiqueta EXCLUSIVE-LOCK
                WHERE bf-etiqueta.id-etiqueta = bf-box-saldo-etiqueta.id-etiqueta:
                IF bf-etiqueta.qtd-item-retirado >= wm-box-saldo.qtd-item THEN
                    ASSIGN bf-etiqueta.qtd-item-retirado = bf-etiqueta.qtd-item-retirado - wm-box-saldo.qtd-item.
                ELSE
                    ASSIGN bf-etiqueta.qtd-item = bf-etiqueta.qtd-item + wm-box-saldo.qtd-item.
            END.
        END.

        IF bf-box-saldo.qtd-item-bloq >= wm-box-saldo.qtd-item THEN
            ASSIGN bf-box-saldo.qtd-item-bloq = bf-box-saldo.qtd-item-bloq - wm-box-saldo.qtd-item.
        ELSE
            ASSIGN bf-box-saldo.qtd-item = bf-box-saldo.qtd-item + wm-box-saldo.qtd-item.
    
        FOR FIRST bf-box-sdo-alocad EXCLUSIVE-LOCK
             WHERE bf-box-sdo-alocad.cod-estabel   = bf-box-saldo.cod-estabel
               AND bf-box-sdo-alocad.cod-local     = bf-box-saldo.cod-local
               AND bf-box-sdo-alocad.cod-cliente   = bf-box-saldo.cod-cliente
               AND bf-box-sdo-alocad.id-box        = bf-box-saldo.id-box
               AND bf-box-sdo-alocad.id-docto      = wm-box-movto.id-docto           
               AND bf-box-sdo-alocad.num-seq-item  = wm-box-movto.num-seq-item 
               AND bf-box-sdo-alocad.cod-item      = bf-box-saldo.cod-item
               AND bf-box-sdo-alocad.cod-refer     = bf-box-saldo.cod-refer
               AND bf-box-sdo-alocad.cod-lote      = bf-box-saldo.cod-lote
               AND bf-box-sdo-alocad.cod-embalagem = bf-box-saldo.cod-embalagem:
        END.
    
        IF NOT AVAIL bf-box-sdo-alocad THEN DO:
            CREATE bf-box-sdo-alocad.
            ASSIGN bf-box-sdo-alocad.cod-estabel   = bf-box-saldo.cod-estabel
                   bf-box-sdo-alocad.cod-local     = bf-box-saldo.cod-local
                   bf-box-sdo-alocad.cod-cliente   = bf-box-saldo.cod-cliente 
                   bf-box-sdo-alocad.id-box        = bf-box-saldo.id-box
                   bf-box-sdo-alocad.id-docto      = wm-box-movto.id-docto
                   bf-box-sdo-alocad.num-seq-item  = wm-box-movto.num-seq-item 
                   bf-box-sdo-alocad.cod-item      = bf-box-saldo.cod-item
                   bf-box-sdo-alocad.cod-refer     = bf-box-saldo.cod-refer
                   bf-box-sdo-alocad.cod-lote      = bf-box-saldo.cod-lote
                   bf-box-sdo-alocad.cod-embalagem = bf-box-saldo.cod-embalagem.
        END.
    
        ASSIGN bf-box-sdo-alocad.qtd-alocada = bf-box-sdo-alocad.qtd-alocada + wm-box-saldo.qtd-item.
    
        /* ajuste aloca‡Æo original */
        FOR FIRST wms-box-sdo-alocad EXCLUSIVE-LOCK
             WHERE wms-box-sdo-alocad.cod-estabel   = wm-box-saldo.cod-estabel
               AND wms-box-sdo-alocad.cod-local     = wm-box-saldo.cod-local
               AND wms-box-sdo-alocad.cod-cliente   = wm-box-saldo.cod-cliente
               AND wms-box-sdo-alocad.id-box        = wm-box-saldo.id-box
               AND wms-box-sdo-alocad.id-docto      = wm-box-movto.id-docto           
               AND wms-box-sdo-alocad.num-seq-item  = wm-box-movto.num-seq-item 
               AND wms-box-sdo-alocad.cod-item      = wm-box-saldo.cod-item
               AND wms-box-sdo-alocad.cod-refer     = wm-box-saldo.cod-refer
               AND wms-box-sdo-alocad.cod-lote      = wm-box-saldo.cod-lote
               AND wms-box-sdo-alocad.cod-embalagem = wm-box-saldo.cod-embalagem:
    
            DELETE wms-box-sdo-alocad.
        END.
    
        /* -> quem elimina e o wm9062 */
/*         FIND CURRENT wm-box-saldo EXCLUSIVE-LOCK NO-ERROR.              */
/*         DELETE wm-box-saldo.                                            */
/*         IF AVAIL wm-box-saldo-etiqueta THEN DO:                         */
/*             FIND CURRENT wm-box-saldo-etiqueta EXCLUSIVE-LOCK NO-ERROR. */
/*             DELETE wm-box-saldo-etiqueta.                               */
/*         END.                                                            */
    
        IF AVAIL wm-etiqueta THEN DO:
            FIND CURRENT wm-etiqueta EXCLUSIVE-LOCK NO-ERROR. /* zera etiqueta gerada */
            ASSIGN wm-etiqueta.qtd-item-retirado = wm-etiqueta.qtd-item.
        END.
    END.

    RELEASE wm-etiqueta NO-ERROR.
    RELEASE wm-box-saldo NO-ERROR.
    RELEASE wms-box-sdo-alocad NO-ERROR.

END. /* bloco / TRANS */


RETURN "OK".

/************************************************************/

PROCEDURE piCreateError :
    DEFINE INPUT PARAMETER pErrorNumber     AS INTE NO-UNDO.
    DEFINE INPUT PARAMETER pErrorParameters AS CHAR NO-UNDO.
    DEFINE VARIABLE i-sequencia AS INTEGER     NO-UNDO.

    FIND LAST RowErrors NO-LOCK NO-ERROR.
    IF AVAIL RowErrors THEN
        ASSIGN i-sequencia = RowErrors.ErrorSequence + 1.
    ELSE    
        ASSIGN i-sequencia = 1.

    RUN utp/ut-msgs.p (INPUT "msg",
                       INPUT pErrorNumber,
                       INPUT pErrorParameters).

    CREATE RowErrors.
    ASSIGN RowErrors.ErrorSequence    = i-sequencia
           RowErrors.ErrorNumber      = pErrorNumber
           RowErrors.ErrorParameters  = pErrorParameters
           RowErrors.ErrorType        = "EMS":U
           RowErrors.ErrorSubType     = "ERROR":U
           RowErrors.ErrorDescription = RETURN-VALUE.

    RUN utp/ut-msgs.p (INPUT "help",
                       INPUT pErrorNumber,
                       INPUT pErrorParameters).  

    ASSIGN RowErrors.ErrorHelp = RETURN-VALUE.
    
    IF TRIM(RowErrors.ErrorHelp) = "" THEN
        ASSIGN RowErrors.ErrorHelp = RowErrors.ErrorDescription.

    RETURN "OK":U.
END PROCEDURE.







