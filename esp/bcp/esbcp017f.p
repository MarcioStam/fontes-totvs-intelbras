/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESBCP017F 2.00.00.023 } /*** 010023 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i esbcp017f MBC}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9018f.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - outubro/2002 - karla Klemke                                 **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Picking WMS - Fun‡äes            **
**                                                                                         **
********************************************************************************************/
&if '{&mgscm_version}' >= '2.04' &then

{cdp/cd0666.i}      /* Definicao da temp-table de erros         */
{bcp/bcapi001.i}    /* Definicao da temp-table de transacoes    */
{bcp/bc1000.i}      /* Procedure geraTTErro */
{include/i_dbtype.i}
{include/i_dbvers.i}
&global-define TempTable tt-picking-wms
def temp-table tt-erro-aux no-undo  like tt-erro.
{esp/bcp/esbcp017.i   " "}
{esp/bcp/esbcp017.i1 "New"}
def buffer bbc-trans-aux for bc-trans.

PROCEDURE pi-inicializa-tt-picking-wms-table:            
    DEFINE INPUT  PARAMETER pcod-estabel     LIKE tt-picking-wms.cod-estabel    NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-local       LIKE tt-picking-wms.cod-local      NO-UNDO.
    DEFINE INPUT  PARAMETER pid-movto        LIKE Wm-box-movto.id-movto         NO-UNDO.
    DEFINE INPUT  PARAMETER pind-tipo-movto  LIKE wm-box-movto.ind-tipo-movto   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-picking-wms-table.

    DEFINE VARIABLE v-detalhe LIKE bc-trans.detalhe NO-UNDO.

    FOR EACH tt-picking-wms-table:
        DELETE tt-picking-wms-table.
    END.
    ASSIGN v-detalhe = 'Est:':U  + trim(pcod-estabel) + ';':U +
                       'Loc:':U  + trim(pcod-local)   + ';':U +
                       'IMo:':U  + trim(string(pid-movto,'>>>>>>>>>9':U)) + ';':U + 
                       'ITM:':U  + trim(string(pind-tipo-movto, '>9':U)).
    
    FIND FIRST bc-trans USE-INDEX bctrans-06
         WHERE bc-trans.detalhe      = v-detalhe  
           and bc-trans.estado-trans = 4 
           AND (bc-trans.cd-trans = 'WMSai001':U) NO-LOCK NO-ERROR.
    
    IF AVAILABLE bc-trans THEN DO:
        FOR EACH bc-trans-filho NO-LOCK WHERE
            bc-trans-filho.nr-trans = bc-trans.nr-trans:
            CREATE tt-picking-wms-table.
            ASSIGN tt-picking-wms-table.num-serial        = decimal(ENTRY(2, ENTRY(6,bc-trans-filho.conteudo-trans,';'),':':U))
                   tt-picking-wms-table.id-docto          = decimal(entry(2, ENTRY(5,bc-trans-filho.conteudo-trans,';'),':':U))
                   tt-picking-wms-table.id-movto          = decimal(entry(2, ENTRY(3,bc-trans-filho.conteudo-trans,';'),':':U))
                   tt-picking-wms-table.num-seq-item      = INTEGER(entry(2, ENTRY(7,bc-trans-filho.conteudo-trans,';'),':':U))
                   tt-picking-wms-table.ind-tipo-movto    = INTEGER(entry(2, ENTRY(4,bc-trans-filho.conteudo-trans,';'),':':U))
                   tt-picking-wms-table.qtd-item          = DECIMAL(entry(2, ENTRY(8,bc-trans-filho.conteudo-trans,';'),':':U))
                   tt-picking-wms-table.qtd-item-digit    = DECIMAL(entry(2, ENTRY(9,bc-trans-filho.conteudo-trans,';'),':':U))
                   tt-picking-wms-table.cod-item          = TRIM(entry(2, ENTRY(10,bc-trans-filho.conteudo-trans,';'),':':U))
                   tt-picking-wms-table.num-box-lido      = DECIMAL(entry(2, ENTRY(11,bc-trans-filho.conteudo-trans,';'),':':U))
                   tt-picking-wms-table.cod-embalagem     = TRIM(entry(2, ENTRY(12,bc-trans-filho.conteudo-trans,';'),':':U))
                   tt-picking-wms-table.qtd-embalagem     = INTEGER(entry(2, ENTRY(13,bc-trans-filho.conteudo-trans,';'),':':U))
                   tt-picking-wms-table.dat-atualizacao   = DATE(entry(2, ENTRY(14,bc-trans-filho.conteudo-trans,';'),':':U))
                   tt-picking-wms-table.dat-transacao     = DATE(entry(2, ENTRY(15,bc-trans-filho.conteudo-trans,';'),':':U))
                   tt-picking-wms-table.num-tempo-inicio  = DECIMAL(entry(2, ENTRY(16,bc-trans-filho.conteudo-trans,';'),':':U))
                   tt-picking-wms-table.cod-coletor       = TRIM(entry(2, ENTRY(17,bc-trans-filho.conteudo-trans,';'),':':U))
                   tt-picking-wms-table.cod-equipamento   = TRIM(entry(2, ENTRY(18,bc-trans-filho.conteudo-trans,';'),':':U)).
        END.
    END.
    
    RETURN 'OK':U.    

END PROCEDURE.

PROCEDURE pi-cria-tt-picking-ems-table:

    DEFINE INPUT  PARAMETER pcod-estabel      LIKE tt-picking-wms.cod-estabel      NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-local        LIKE tt-picking-wms.cod-local        NO-UNDO.
    DEFINE INPUT  PARAMETER pid-movto         LIKE Wm-box-movto.id-movto           NO-UNDO.
    DEFINE INPUT  PARAMETER pind-tipo-movto   LIKE wm-box-movto.ind-tipo-movto     NO-UNDO.
    DEFINE INPUT  PARAMETER pid-docto         LIKE wm-box-movto.id-docto           NO-UNDO.
    DEFINE INPUT  PARAMETER pnum-serial       LIKE tt-picking-wms.num-serial       NO-UNDO.
    DEFINE INPUT  PARAMETER pnum-seq-item     LIKE tt-picking-wms.num-seq-item     NO-UNDO.
    DEFINE INPUT  PARAMETER pnum-itens-serial LIKE tt-picking-wms.qtd-item         NO-UNDO.
    DEFINE INPUT  PARAMETER pnum-itens-digit  LIKE tt-picking-wms.qtd-item-digit   NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-item         LIKE tt-picking-wms.cod-item         no-undo.
    DEFINE INPUT  PARAMETER pnum-box-lido     LIKE tt-picking-wms.num-box-lido     NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-embalagem    LIKE tt-picking-wms.cod-embalagem    NO-UNDO.
    DEFINE INPUT  PARAMETER pqti-embalagem    LIKE tt-picking-wms.qtd-embalagem    NO-UNDO.
    DEFINE INPUT  PARAMETER pdat-atualizacao  LIKE tt-picking-wms.dat-atualizacao  NO-UNDO.
    DEFINE INPUT  PARAMETER pdat-transacao    LIKE tt-picking-wms.dat-transacao    NO-UNDO.
    DEFINE INPUT  PARAMETER pnum-tempo-inicio AS DECIMAL FORMAT '>>>>>>>>>>>>>9':U NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-coletor      AS CHARACTER    FORMAT 'x(14)':U     NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-equipamento  As Character    Format 'x(14)':U     NO-UNDO.
    define input  parameter pcod-lote         like tt-picking-wms.cod-lote         no-undo.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-picking-wms-table                          .
    DEFINE output param table for tt-erro                                                 .
        
    DEFINE VARIABLE v-detalhe LIKE bc-trans.detalhe NO-UNDO.
    Define            Variable wgbcapi001              As handle                 No-undo.
    
    ASSIGN v-detalhe = 'Est:':U  + trim(pcod-estabel) + ';':U +
                       'Loc:':U  + trim(pcod-local)   + ';':U +
                       'IMo:':U  + trim(string(pid-movto,'>>>>>>>>>9':U)) + ';':U + 
                       'ITM:':U  + trim(string(pind-tipo-movto, '>9':U)).
   
    /* cria‡ao da bc-trans */
    FOR EACH tt-trans:
        DELETE tt-trans.
    END.
    FOR EACH tt-trans-filho:
        DELETE tt-trans-filho.
    END.
    FOR EACH tt-erro:
        DELETE tt-erro.
    END.
    CREATE tt-trans.
    ASSIGN tt-trans.cod-versao-integracao = 1
           tt-trans.i-sequen = 1
           tt-trans.cd-trans = 'WMSai001':U
           tt-trans.detalhe = v-detalhe.
           tt-trans.usuario = v_cod_usuar_corren.
           tt-trans.etiqueta = NO.
    
    CREATE tt-trans-filho.
    ASSIGN  tt-trans-filho.i-sequen-pai = 1
            TT-trans-filho.i-sequen     = 1    
            TT-trans-filho.num-versao   = 1
            TT-trans-filho.conteudo-xml = 
                                          'Est:':U  + trim(pcod-estabel)                                + ';':U +
                                          'Loc:':U  + trim(pcod-local)                                  + ';':U +
                                          'IMo:':U  + trim(string(pid-movto,'>>>>>>>>>9':U))            + ';':U + 
                                          'ITM:':U  + trim(string(pind-tipo-movto, '>9':U))             + ';':U +
                                          'IDo:':U  + trim(STRING(pid-docto, '>>>>>>>>>9':U))           + ';':U + 
                                          'Ser:':U  + trim(string(pnum-serial, '>>>>>>>>>>>>>>':U))     + ';':U + 
                                          'SIt:':U  + trim(string(pnum-seq-item, '>>>>9':U))            + ';':U + 
                                          'Qtd:':U  + trim(string(pnum-itens-serial,'>>>>>9.9999':U))    + ';':U +
                                          'QtI:':U  + trim(STRING(pnum-itens-digit,'>>>>>9.9999':U))     + ';':U +
                                          'Ite:':U  + trim(pcod-item)                                   + ';':U +
                                          'Box:':U  + trim(STRING(pnum-box-lido,'>>>>>>>>>9':U))        + ';':U +     
                                          'Emb:':U  + trim(pcod-embalagem)                              + ';':U +     
                                          'QEm:':U  + trim(string(pqti-embalagem, '>>>>>>>>9':U))       + ';':U .
     /* caso tenha o conteudo nulo... ira passar nulo p todo atributo conteudo-xml */
     IF pdat-atualizacao =  ? THEN ASSIGN tt-trans-filho.conteudo-xml = tt-trans-filho.conteudo-xml +  'DtA:':U  + '?':U + ';':U .
     IF pdat-atualizacao <> ? THEN ASSIGN tt-trans-filho.conteudo-xml = tt-trans-filho.conteudo-xml +  'DtA:':U  + trim(string(pdat-atualizacao)) + ';':U .
     ASSIGN tt-trans-filho.conteudo-xml = tt-trans-filho.conteudo-xml +
                                          'DtT:':U  + trim(STRING(pdat-transacao))                      + ';':U +
                                          'Tem:':U  + trim(string(pnum-tempo-inicio, '>>>>>>>>>>>>>9')) + ';':U +
                                          'Col:':U  + trim(pcod-coletor)                                + ';':U +
                                          'Eqp:':U  + trim(pcod-equipamento)                            + ';':U +
                                          'Lot:':U  + trim(pcod-lote).

    IF NOT VALID-HANDLE(wgbcapi001) THEN DO:
        run bcp/bcapi001.p persistent set wgbcapi001 (input-output table tt-trans,
                                                      input-output table tt-erro).
    END.

    
    RUN cria_reg_wms  in wgbcapi001 (INPUT 4,INPUT-OUTPUT TABLE tt-trans, INPUT-OUTPUT TABLE tt-trans-filho,INPUT-OUTPUT TABLE tt-erro).
    /* 4 = Estado da Transacao = Em Processo */

    delete procedure wgbcapi001.
    find first tt-erro no-error.
    if  avail tt-erro THEN DO: 
         RETURN 'nok':U.
    END.
    CREATE tt-picking-wms-table.
    ASSIGN tt-picking-wms-table.num-serial       = pnum-serial
           tt-picking-wms-table.id-docto         = pid-docto
           tt-picking-wms-table.id-movto         = pid-movto
           tt-picking-wms-table.num-seq-item     = pnum-seq-item
           tt-picking-wms-table.ind-tipo-movto   = pind-tipo-movto
           tt-picking-wms-table.qtd-item         = pnum-itens-serial
           tt-picking-wms-table.qtd-item-digit   = pnum-itens-digit 
           tt-picking-wms-table.cod-item         = pcod-item
           tt-picking-wms-table.num-box-lido     = pnum-box-lido
           tt-picking-wms-table.cod-embalagem    = pcod-embalagem
           tt-picking-wms-table.qtd-embalagem    = pqti-embalagem
           tt-picking-wms-table.dat-atualizacao  = pdat-atualizacao
           tt-picking-wms-table.dat-transacao    = pdat-transacao
           tt-picking-wms-table.num-tempo-inicio = pnum-tempo-inicio
           tt-picking-wms-table.cod-coletor      = pcod-coletor
           tt-picking-wms-table.cod-equipamento  = pcod-equipamento
           tt-picking-wms-table.cod-lote         = pcod-lote.
    RETURN 'ok':U.
END PROCEDURE.

PROCEDURE pi-atualiza-qtd-digitada:
    DEFINE INPUT  PARAMETER pcod-estabel      LIKE tt-picking-wms.cod-estabel    NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-local        LIKE tt-picking-wms.cod-local      NO-UNDO.
    DEFINE INPUT  PARAMETER pid-movto         LIKE Wm-box-movto.id-movto         NO-UNDO.
    DEFINE INPUT  PARAMETER pind-tipo-movto   LIKE wm-box-movto.ind-tipo-movto   NO-UNDO.
    DEFINE INPUT  PARAMETER pid-docto         LIKE wm-box-movto.id-docto         NO-UNDO.
    DEFINE INPUT  PARAMETER pnum-serial       LIKE tt-picking-wms.num-serial     NO-UNDO.
    DEFINE INPUT  PARAMETER pnum-seq-item     LIKE tt-picking-wms.num-seq-item   NO-UNDO.
    DEFINE INPUT  PARAMETER pnum-itens-serial LIKE tt-picking-wms.qtd-item       NO-UNDO.
    DEFINE INPUT  PARAMETER pnum-itens-digit  LIKE tt-picking-wms.qtd-item-digit NO-UNDO.
    DEFINE input-output param table for tt-erro                                         .

    DEFINE VARIABLE v-detalhe LIKE bc-trans.detalhe NO-UNDO.
    DEFINE VARIABLE v-conteudo-trans AS CHAR NO-UNDO.
    DEFINE VARIABLE v-num-itens-digit LIKE tt-picking-wms.qtd-item-digit NO-UNDO.
    
    ASSIGN v-detalhe = 'Est:':U  + trim(pcod-estabel) + ';':U +
                       'Loc:':U  + trim(pcod-local)   + ';':U +
                       'IMo:':U  + trim(string(pid-movto,'>>>>>>>>>9':U)) + ';':U + 
                       'ITM:':U  + trim(string(pind-tipo-movto, '>9':U)).
   
    FIND FIRST bc-trans USE-INDEX bctrans-06
        WHERE bc-trans.detalhe  = v-detalhe    
          AND bc-trans.estado-trans = 4        
          AND bc-trans.cd-trans = 'WMSai001':U NO-LOCK NO-ERROR.
    
    IF AVAILABLE bc-trans THEN DO:
        ASSIGN v-conteudo-trans = 
                                'Est:':U  + trim(pcod-estabel)                              + ';':U +
                                'Loc:':U  + trim(pcod-local)                                + ';':U +
                                'IMo:':U  + trim(string(pid-movto,'>>>>>>>>>9':U))          + ';':U + 
                                'ITM:':U  + trim(string(pind-tipo-movto, '>9':U))           + ';':U +
                                'IDo:':U  + trim(STRING(pid-docto, '>>>>>>>>>9':U))         + ';':U + 
                                'Ser:':U  + trim(string(pnum-serial, '>>>>>>>>>>>>>>':U))   + ';':U + 
                                'SIt:':U  + trim(string(pnum-seq-item, '>>>>9':U)).

        DO TRANSACTION:
            
            FIND bc-trans-filho WHERE
                 bc-trans-filho.nr-trans = bc-trans.nr-trans AND
                 bc-trans-filho.conteudo-trans BEGINS v-conteudo-trans EXCLUSIVE-LOCK NO-ERROR.
            
            IF AVAILABLE bc-trans-filho THEN DO:
                ASSIGN v-num-itens-digit = decimal(ENTRY(2,entry(9,bc-trans-filho.conteudo-trans,';':U),':':U)) + pnum-itens-digit.
                ASSIGN entry(9,bc-trans-filho.conteudo-trans,';':U) = 'Qtd:':U  + trim(STRING(v-num-itens-digit, '>>>>>9.9999':U)).
                
            END.
        END.
    END.
    RETURN 'ok':U.
END PROCEDURE.

PROCEDURE finaliza-picking:
    DEF INPUT  PARAM TABLE FOR tt-trans.
    DEF OUTPUT PARAM TABLE FOR tt-erro.

    DEF VAR vcontreg    AS INTEGER.
    DEF VAR vcont       AS INTEGER.
    DEF VAR i-cont-erro AS INTEGER.
    DEF VAR l-erro      AS LOGICAL.


        FOR EACH tt-erro:
            DELETE tt-erro.
        END.
        FOR EACH tt-trans:

             if  tt-trans.cod-versao-integracao <> 1 then do:
                run utp/ut-msgs.p (input "msg",
                                   input 3941,
                                   input "").
                create tt-erro.
                assign i-cont-erro = i-cont-erro + 1.
                assign tt-erro.i-sequen = i-cont-erro
                       tt-erro.cd-erro  = 3941
                       tt-erro.mensagem = RETURN-VALUE + "(DC)":U
                       l-erro = yes.
            end.

            find first bc-tipo-trans
                where bc-tipo-trans.cd-trans = tt-trans.cd-trans
                no-lock no-error.
            if  not available(bc-tipo-trans) then do:
                {utp/ut-field.i mgcld bc-tipo-trans cd-trans 1}
                run utp/ut-msgs.p (input "msg",
                                   input 56,
                                   input trim(return-value)).
                create tt-erro.
                assign i-cont-erro = i-cont-erro + 1.
                ASSIGN tt-erro.i-sequen = i-cont-erro
                       tt-erro.cd-erro  = 56
                       tt-erro.mensagem = RETURN-VALUE + "(DC)":U
                       l-erro = yes.
            end.
            if  (   tt-trans.detalhe = ?
                 or tt-trans.detalhe = "")
            then do:
                {utp/ut-field.i mgcld bc-trans detalhe 1}
                run utp/ut-msgs.p (input "msg",
                                   input 5793,
                                   input trim(return-value)).
                create tt-erro.
                assign i-cont-erro = i-cont-erro + 1.
                assign tt-erro.i-sequen = i-cont-erro
                       tt-erro.cd-erro  = 5793
                       tt-erro.mensagem = RETURN-VALUE + "(DC)":U
                       l-erro = yes.
            end.
            if  (   tt-trans.usuario = ?
                 or tt-trans.usuario = "")
            then do:
                {utp/ut-field.i mgcld bc-trans usuario 1}
                run utp/ut-msgs.p (input "msg",
                                   input 5793,
                                   input trim(return-value)).
                create tt-erro.
                assign i-cont-erro = i-cont-erro + 1.
                ASSIGN tt-erro.i-sequen = i-cont-erro
                       tt-erro.cd-erro  = 5793
                       tt-erro.mensagem = RETURN-VALUE + "(DC)":U
                       l-erro = yes.
            end.

            if  l-erro = yes then undo, next.
            FIND FIRST bbc-trans-aux WHERE bbc-trans-aux.estado-trans = 4 AND
                       bbc-trans-aux.detalhe = tt-trans.detalhe NO-LOCK NO-ERROR. 
            IF AVAILABLE bbc-trans-aux THEN DO:
               DO TRANSACTION:

                    FIND bc-trans WHERE RECID(bc-trans) = RECID(bbc-trans-aux) EXCLUSIVE-LOCK NO-ERROR.

                    IF NOT AVAILABLE bc-trans THEN DO:
                        create tt-erro.
                        assign i-cont-erro = i-cont-erro + 1.
                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-detalhe AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Detalhe" *}
                        ASSIGN c-lbl-liter-detalhe = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-liter-inexistente-dc AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Inexistente_(DC)" *}
                        ASSIGN c-lbl-liter-inexistente-dc = TRIM(RETURN-VALUE).
                        ASSIGN tt-erro.i-sequen = i-cont-erro
                               tt-erro.cd-erro  = 56
                               tt-erro.mensagem = c-lbl-liter-detalhe + ": " +  tt-trans.detalhe + " " + c-lbl-liter-inexistente-dc.
                    END.
                    ELSE DO:
                        ASSIGN tt-trans.nr-trans = bc-trans.nr-trans.
    
                        IF bc-trans.estado-trans  = 4 THEN DO:
                            ASSIGN bc-trans.estado-trans = 1. /** 1-Nova, 2-Atualizada, 3-Com Erro */ 
                        END.
                        ELSE DO:
                             run utp/ut-msgs.p (input "msg",
                                                input 27845,
                                                input trim(return-value)).
                             create tt-erro.
                             assign i-cont-erro = i-cont-erro + 1.
                             ASSIGN tt-erro.i-sequen = i-cont-erro
                                    tt-erro.cd-erro  = 27845
                                    tt-erro.mensagem = RETURN-VALUE + "(DC)":U.
                             ASSIGN l-erro = yes.
                        END.
                    END.
                END. /* do transaction */
            END. /* if */
            ELSE DO:
                create tt-erro.
                assign i-cont-erro = i-cont-erro + 1.
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-detalhe-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Detalhe" *}
                ASSIGN c-lbl-liter-detalhe-2 = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-inexistente-dc-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Inexistente_(DC)" *}
                ASSIGN c-lbl-liter-inexistente-dc-2 = TRIM(RETURN-VALUE).
                ASSIGN tt-erro.i-sequen = i-cont-erro
                       tt-erro.cd-erro  = 56
                       tt-erro.mensagem = c-lbl-liter-detalhe-2 + ": " +  tt-trans.detalhe + " " + c-lbl-liter-inexistente-dc-2.
                ASSIGN l-erro = yes.
            END. /* else */
            if  l-erro = yes then undo, next.
        END.
        RETURN 'ok':U.
END PROCEDURE.

PROCEDURE picking-pre-api-wms:

DEF INPUT-OUTPUT  PARAM TABLE FOR tt-trans.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-erro.

DEF VARIABLE i-cont-erro AS INTEGER.
DEF VARIABLE i-cont      AS INTEGER.
DEF VARIABLE i-cod-erro  AS INTEGER.

    FOR EACH tt-trans:
        find first bc-tipo-trans
             where bc-tipo-trans.cd-trans = tt-trans.cd-trans no-lock no-error.

        FOR FIRST bbc-trans-aux NO-LOCK
            WHERE (&IF "{&mgcld_dbtype}" = "PROGRESS":U
                   &THEN bbc-trans-aux.detalhe CONTAINS tt-trans.detalhe
                   &ELSE bbc-trans-aux.detalhe MATCHES ("*" + tt-trans.detalhe + "*")
                   &ENDIF)
              AND bbc-trans-aux.estado-trans = 1:
        END.

        IF AVAILABLE bbc-trans-aux THEN DO:

            DO TRANSACTION:
            
            FIND bc-trans WHERE 
                 RECID(bc-trans) = RECID(bbc-trans-aux) EXCLUSIVE-LOCK NO-ERROR. 
            
            IF AVAILABLE bc-trans THEN ASSIGN tt-trans.nr-trans = bc-trans.nr-trans.
            if      bc-trans.estado-trans   = 1             /* estado da transa‡Æo = 1-Nova  log-1 = yes (atualiza-on-line) */
            and (   bc-tipo-trans.atualiza-on-line  = yes
                 or bc-tipo-trans.imp-apos-trans    = yes)
            then do:
    
                for each tt-erro-aux:
                    delete tt-erro-aux.
                end.
    
                /***** execucao da pre-api ***/  
                erro:
                do  on error  undo erro, leave erro
                    on quit   undo erro, leave erro
                    on stop   undo erro, leave erro
                    on endkey undo erro, leave erro:
    
                    
                    if  not tt-trans.etiqueta           /* tt-trans.etiqueta = <NO> - Gera Transa‡Æo Movimento */
                    and bc-tipo-trans.atualiza-on-line
                    then do:
                        if  bc-tipo-trans.api-atualizacao <> ""
                        then do:
                            
                            run value(bc-tipo-trans.api-atualizacao)
                                     (  input tt-trans.nr-trans,
                                        input tt-trans.conteudo-trans,
                                        input-output table tt-erro-aux) no-error.
                                assign  bc-trans.estado-trans     = 2
                                        bc-trans.data-atualizacao = today
                                        bc-trans.hora-atualizacao = string(time,"HH:MM:SS":U).
                            
                        end.
                        else do:
                            run utp/ut-msgs.p ( input "msg",
                                                input 4,
                                                input return-value).
    
                            create tt-erro.
                            assign i-cont-erro = i-cont-erro + 1.
                            assign tt-erro.i-sequen = i-cont-erro
                                   tt-erro.cd-erro  = 4
                                   tt-erro.mensagem = RETURN-VALUE + "(DC)".
                        end.
                    end.
                
                    if  tt-trans.etiqueta               /* tt-trans.etiqueta = <YES> - Gera Transa‡Æo Etiqueta */
                    and bc-tipo-trans.imp-apos-trans
                    then do:
                        if  bc-tipo-trans.prog-etiq <> ""
                        then do:
                            run value(bc-tipo-trans.prog-etiq)
                                     (  input tt-trans.nr-trans,
                                        input tt-trans.conteudo-trans,
                                        input-output table tt-erro-aux) no-error.
    
                            
                                assign  bc-trans.estado-trans     = 2
                                        bc-trans.data-atualizacao = today
                                        bc-trans.hora-atualizacao = string(time,"HH:MM:SS":U).
                            
                        end.
                        else do:
                            run utp/ut-msgs.p ( input "msg":U,
                                                input 4,
                                                input return-value).
                            create tt-erro.
                            assign i-cont-erro             = i-cont-erro + 1.
                            assign tt-erro.i-sequen = i-cont-erro
                                   tt-erro.cd-erro  = 4
                                   tt-erro.mensagem = RETURN-VALUE + "(DC)":U.
                        end.
                    end.
                end.
            
                if  error-status:error
                    or  (    error-status:get-number(1) <> 138
                         and error-status:num-messages <> 0)
                then do:
                    do  i-cont = 1 to error-status:num-messages
                           while(error-status:get-message(i-cont) <> ""):
                        
                        assign i-cod-erro = error-status:get-number(i-cont).
                    
                        run utp/ut-msgs.p (input "msg":U,
                                           input 15837,
                                           input (if  bc-trans.log-1 = no 
                                                  then
                                                      bc-tipo-trans.api-atualizacao
                                                  else 
                                                      bc-tipo-trans.prog-etiq) ).
    
                        create tt-erro.
                        assign i-cont-erro      = i-cont-erro + 1
                               tt-erro.i-sequen = i-cont-erro
                               tt-erro.cd-erro  = 15837
                               tt-erro.mensagem = trim(return-value) + "(DC)":U. 
                           
                        {utp/ut-liter.i Transa‡Æo * L}       
                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter AS CHARACTER NO-UNDO.
                        ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-liter-dc AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "DC" *}
                        ASSIGN c-lbl-liter-dc = TRIM(RETURN-VALUE).
                        assign tt-erro.mensagem     = tt-erro.mensagem      
                                                            + " " + trim(c-lbl-liter)       
                                                            + " (" 
                                                            + bc-trans.cd-trans
                                                            + ") (" + c-lbl-liter-dc + ")".
                        {utp/ut-liter.i Erro_Progress * L}                                   
                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-2 AS CHARACTER NO-UNDO.
                        ASSIGN c-lbl-liter-2 = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-liter-dc-2 AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "DC" *}
                        ASSIGN c-lbl-liter-dc-2 = TRIM(RETURN-VALUE).
                        assign tt-erro.mensagem =  tt-erro.mensagem      
                                                            + " - " + trim(c-lbl-liter-2)       
                                                            + " (" 
                                                            + string(i-cod-erro)
                                                            + ") (" + c-lbl-liter-dc-2 + ")".
                    end.
                end.
    
                find first tt-erro-aux no-error.
                if  available(tt-erro-aux) then do:
                    for each tt-erro-aux:
                        create tt-erro.
                        assign i-cont-erro      = i-cont-erro + 1.
                        assign tt-erro.i-sequen = i-cont-erro
                               tt-erro.cd-erro  = tt-erro-aux.cd-erro
                               tt-erro.mensagem = tt-erro-aux.mensagem.
                        
                        create bc-trans-erro.
                        assign i-cont-erro             = i-cont-erro + 1
                               bc-trans-erro.nr-trans  = tt-trans.nr-trans
                               bc-trans-erro.cd-msg    = tt-erro-aux.cd-erro
                               bc-trans-erro.texto-msg = tt-erro-aux.mensagem
                               bc-trans-erro.num-sequencia = i-cont-erro.
                    end.
                    
                        assign bc-trans.estado-trans     = 3
                               bc-trans.data-atualizacao = ?
                               bc-trans.hora-atualizacao = "".
                    
                end.
            END.
            END. /* transaction */
        END. /* if */
    END.
    RETURN 'ok':U.
END PROCEDURE.

&if '{&mgscm_version}' >= '2.07' &then     /* FLAVIO-INI FO 1389.034*/
PROCEDURE picking-get-endereco-transito:
    DEFINE INPUT        PARAMETER pc-cod-estabel       AS CHARACTER  NO-UNDO.
    DEFINE INPUT        PARAMETER pc-cod-local         AS CHARACTER  NO-UNDO.
    DEFINE INPUT        PARAMETER pde-id-docto         AS DECIMAL    NO-UNDO.
    DEFINE INPUT        PARAMETER pde-id-movto         AS DECIMAL    NO-UNDO.
    
    DEFINE       OUTPUT PARAMETER pc-endereco-transito AS CHARACTER  NO-UNDO.
    DEFINE       OUTPUT PARAMETER pde-id-box           AS DECIMAL    NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-erro.

    DEFINE VARIABLE lc-cod-bloco      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lc-cod-rua        AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lc-cod-nivel      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lc-cod-coluna     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lc-posicao        AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE li-origem-docto   AS INTEGER    NO-UNDO.
    DEFINE VARIABLE li-cont-erro      AS INTEGER    NO-UNDO.
    DEFINE VARIABLE ldt-implant-docto AS DATE       NO-UNDO. /* Somente para a chamada da procedure goToKey */
    
    /* CASO FOR DOCUMENTO CONSOLIDADO O PARAMETRO ENDERECO TRANSITO TERA VALOR */
    ASSIGN pc-endereco-transito= "":U
           pde-id-box          = 0.
    
    RUN goToKey IN wgbosc038 (INPUT pc-cod-estabel,
                              INPUT pc-cod-local,
                              INPUT ldt-implant-docto,
                              INPUT pde-id-docto).
    IF RETURN-VALUE <> "OK":U THEN DO:
        {utp/ut-field.i mgscm wm-docto num-docto 1}
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 56,
                           INPUT TRIM(RETURN-VALUE)).
        
        CREATE tt-erro.
        ASSIGN li-cont-erro = li-cont-erro + 1.
        ASSIGN tt-erro.i-sequen = li-cont-erro
               tt-erro.cd-erro  = 56
               tt-erro.mensagem = RETURN-VALUE + "(DC)":U.
        
        RETURN "NOK":U.
    END.

    RUN getIntField IN wgbosc038 (INPUT "ind-origem-docto":U,
                                  OUTPUT li-origem-docto).

    /* Documento nÆo CONSOLIDADO */
    IF li-origem-docto <> 15 THEN RETURN "OK":U.
        
    RUN goToKey2 IN wgbosc032 (INPUT pc-cod-estabel,
                               INPUT pc-cod-local,
                               INPUT pde-id-movto,
                               INPUT 1). /* ENTRADA */
    IF RETURN-VALUE <> "OK":U THEN DO:
        {utp/ut-field.i mgscm wm-box-movto id-movto 1}
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 56,
                           INPUT TRIM(RETURN-VALUE)).
        
        CREATE tt-erro.
        ASSIGN li-cont-erro = li-cont-erro + 1.
        ASSIGN tt-erro.i-sequen = li-cont-erro
               tt-erro.cd-erro  = 56
               tt-erro.mensagem = RETURN-VALUE + "(DC)":U.
        
        RETURN "NOK":U.
    END.

    RUN getDecField IN wgbosc032 (INPUT "id-box":U,
                                  OUTPUT pde-id-box).

    RUN getCodAddress IN wgbosc032 (INPUT  pc-cod-estabel,
                                    INPUT  pc-cod-local,
                                    INPUT  pde-id-box,
                                    OUTPUT lc-cod-bloco, 
                                    OUTPUT lc-cod-rua, 
                                    OUTPUT lc-cod-nivel, 
                                    OUTPUT lc-cod-coluna).
    IF RETURN-VALUE <> "OK":U THEN DO:
        {utp/ut-liter.i Endere‡o_trƒnsito_do_movimento * L}
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 47,
                           INPUT TRIM(RETURN-VALUE)).
        
        CREATE tt-erro.
        ASSIGN li-cont-erro = li-cont-erro + 1.
        ASSIGN tt-erro.i-sequen = li-cont-erro
               tt-erro.cd-erro  = 47
               tt-erro.mensagem = RETURN-VALUE + "(DC)":U.
        
        RETURN "NOK":U.
    END.

    RUN getPosicao IN wgbosc032 (INPUT  pc-cod-estabel,
                                 INPUT  pc-cod-local,
                                 INPUT  pde-id-box,
                                 OUTPUT lc-posicao).
    IF RETURN-VALUE <> "OK":U THEN DO:
        {utp/ut-liter.i Posi‡Æo_endere‡o_trƒnsito_do_movimento * L}
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 47,
                           INPUT TRIM(RETURN-VALUE)).
        
        CREATE tt-erro.
        ASSIGN li-cont-erro = li-cont-erro + 1.
        ASSIGN tt-erro.i-sequen = li-cont-erro
               tt-erro.cd-erro  = 47
               tt-erro.mensagem = RETURN-VALUE + "(DC)":U.
        
        RETURN "NOK":U.
    END.

    ASSIGN pc-endereco-transito = lc-cod-bloco  + "/" + ~
                                  lc-cod-rua    + "/" + ~
                                  lc-cod-nivel  + "/" + ~
                                  lc-cod-coluna + "/" + ~
                                  IF SUBSTRING(lc-posicao,1,1)='R' THEN 'D' ELSE IF SUBSTRING(lc-posicao,1,1)='L' THEN 'E' ELSE SUBSTRING(lc-posicao,1,1).
    RETURN "OK":U.
END.

PROCEDURE pi-verifica-etiqueta-end-transito:
    DEFINE INPUT        PARAMETER pc-cod-estabel AS CHARACTER  NO-UNDO.
    DEFINE INPUT        PARAMETER pc-cod-local   AS CHARACTER  NO-UNDO.
    DEFINE INPUT        PARAMETER pde-id-box     AS DECIMAL    NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-erro.

    DEFINE VARIABLE lc-mensagem   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE li-cont-erro  AS INTEGER    NO-UNDO.
    DEFINE VARIABLE li-tipo-box   AS INTEGER    NO-UNDO.
    DEFINE VARIABLE li-status-box AS INTEGER    NO-UNDO.

    RUN goToKey IN wgbosc030 (INPUT  pc-cod-estabel,
                              INPUT  pc-cod-local,
                              INPUT  pde-id-box).
    IF RETURN-VALUE <> "OK":U THEN DO:
        {utp/ut-field.i mgscm wm-box id-box 1}
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 56,
                           INPUT TRIM(RETURN-VALUE)).
        
        CREATE tt-erro.
        ASSIGN li-cont-erro = li-cont-erro + 1.
        ASSIGN tt-erro.i-sequen = li-cont-erro
               tt-erro.cd-erro  = 56
               tt-erro.mensagem = RETURN-VALUE + "(DC)":U.
        
        RETURN "NOK":U.
    END.

    RUN getIntField IN wgbosc030 (INPUT  "cdn-tipo-box":U,
                                  OUTPUT li-tipo-box).

    RUN goToKey IN wgBOSC060 (INPUT li-tipo-box).
    IF RETURN-VALUE <> "OK":U THEN DO:
        {utp/ut-field.i mgscm wm-box cdn-tipo-box 1}
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 56,
                           INPUT TRIM(RETURN-VALUE)).
        
        CREATE tt-erro.
        ASSIGN li-cont-erro = li-cont-erro + 1.
        ASSIGN tt-erro.i-sequen = li-cont-erro
               tt-erro.cd-erro  = 56
               tt-erro.mensagem = RETURN-VALUE + "(DC)":U.
        
        RETURN "NOK":U.
    END.

    RUN getIntField IN wgBOSC060 (INPUT  "ind-status-box":U,
                                  OUTPUT li-status-box).
    IF li-status-box <> 7 THEN DO:
        {utp/ut-field.i mgscm wm-box cdn-tipo-box 1}
        ASSIGN lc-mensagem = RETURN-VALUE.
        {utp/ut-liter.i endere‡o_trƒnsito 1}
        ASSIGN lc-mensagem = lc-mensagem + "~~":U + RETURN-VALUE.
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 17195,
                           INPUT TRIM(lc-mensagem)).
        
        CREATE tt-erro.
        ASSIGN li-cont-erro = li-cont-erro + 1.
        ASSIGN tt-erro.i-sequen = li-cont-erro
               tt-erro.cd-erro  = 17195
               tt-erro.mensagem = RETURN-VALUE + "(DC)":U.
        
        RETURN "NOK":U.
    END.

    RETURN "OK":U.
END.


PROCEDURE picking-get-endereco-doca:
    DEFINE INPUT        PARAMETER pc-cod-estabel    AS CHARACTER  NO-UNDO.
    DEFINE INPUT        PARAMETER pc-cod-local      AS CHARACTER  NO-UNDO.
    DEFINE INPUT        PARAMETER pde-id-docto      AS DECIMAL    NO-UNDO.
    DEFINE INPUT        PARAMETER pde-id-movto      AS DECIMAL    NO-UNDO.
    
    DEFINE       OUTPUT PARAMETER pc-endereco-doca  AS CHARACTER  NO-UNDO.
    DEFINE       OUTPUT PARAMETER pi-cod-doca       AS INTEGER    NO-UNDO.
    DEFINE       OUTPUT PARAMETER pde-id-box        AS DECIMAL    NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-erro.

    DEFINE VARIABLE lc-cod-bloco      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lc-cod-rua        AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lc-cod-nivel      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lc-cod-coluna     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lc-posicao        AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE li-cont-erro      AS INTEGER    NO-UNDO.
    DEFINE VARIABLE ldt-implant-docto AS DATE       NO-UNDO. /* Somente para a chamada da procedure goToKey */
    DEFINE VARIABLE llg-le-end-doca   AS LOGICAL    NO-UNDO.

    ASSIGN pc-endereco-doca = "":U
           pi-cod-doca      = 0
           pde-id-box       = 0.
    
    /* Verificar se o parametro esta ligado */
    RUN getParLerEnderecoDoca IN THIS-PROCEDURE (OUTPUT llg-le-end-doca).
    IF RETURN-VALUE <> "OK":U THEN DO:
        CREATE tt-erro.
        ASSIGN li-cont-erro = li-cont-erro + 1.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Erro_ao_ler_o_parƒmetro_Solicitar_Leitura_Endere‡o_da_Doca_(DC)" *}
        ASSIGN tt-erro.i-sequen = li-cont-erro
               tt-erro.cd-erro  = 56
               tt-erro.mensagem = RETURN-VALUE.
        
        RETURN "NOK":U.
    END.
    IF NOT llg-le-end-doca THEN RETURN "OK":U.     /* bc0116c.w Parametro que indica se devera obrigar a leitura do endereco da doca */

    RUN goToKey IN wgbosc038 (INPUT pc-cod-estabel,
                              INPUT pc-cod-local,
                              INPUT ldt-implant-docto,
                              INPUT pde-id-docto).
    IF RETURN-VALUE <> "OK":U THEN DO:
        {utp/ut-field.i mgscm wm-docto num-docto 1}
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 56,
                           INPUT TRIM(RETURN-VALUE)).
        
        CREATE tt-erro.
        ASSIGN li-cont-erro = li-cont-erro + 1.
        ASSIGN tt-erro.i-sequen = li-cont-erro
               tt-erro.cd-erro  = 56
               tt-erro.mensagem = RETURN-VALUE + "(DC)":U.
        
        RETURN "NOK":U.
    END.

    RUN getIntField IN wgbosc038 (INPUT  "cod-doca":U,
                                  OUTPUT pi-cod-doca).

    RUN getIdBoxDoca IN wgbosc078 (INPUT  pi-cod-doca,
                                   OUTPUT pde-id-box).
    IF RETURN-VALUE <> "OK":U THEN DO:
        {utp/ut-field.i mgscm wm-docto num-docto 1}
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 56,
                           INPUT TRIM(RETURN-VALUE)).
        
        CREATE tt-erro.
        ASSIGN li-cont-erro = li-cont-erro + 1.
        ASSIGN tt-erro.i-sequen = li-cont-erro
               tt-erro.cd-erro  = 56
               tt-erro.mensagem = RETURN-VALUE + "(DC)":U.
        
        RETURN "NOK":U.
    END.

/************ 
    RUN getCharField IN wgbosc078 (INPUT  "des-doca":U,
                                   OUTPUT pc-desc-doca).
*************/
    RUN getCodAddress IN wgbosc032 (INPUT  pc-cod-estabel,
                                    INPUT  pc-cod-local,
                                    INPUT  pde-id-box,
                                    OUTPUT lc-cod-bloco, 
                                    OUTPUT lc-cod-rua, 
                                    OUTPUT lc-cod-nivel, 
                                    OUTPUT lc-cod-coluna).
    IF RETURN-VALUE <> "OK":U THEN DO:
        /* Endereco doca invalido */
        {utp/ut-liter.i Endere‡o_doca * L}
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 47,
                           INPUT TRIM(RETURN-VALUE)).
        
        CREATE tt-erro.
        ASSIGN li-cont-erro = li-cont-erro + 1.
        ASSIGN tt-erro.i-sequen = li-cont-erro
               tt-erro.cd-erro  = 47
               tt-erro.mensagem = RETURN-VALUE + "(DC)":U.
        
        RETURN "NOK":U.
    END.

    RUN getPosicao IN wgbosc032 (INPUT  pc-cod-estabel,
                                 INPUT  pc-cod-local,
                                 INPUT  pde-id-box,
                                 OUTPUT lc-posicao).
    IF RETURN-VALUE <> "OK":U THEN DO:
        {utp/ut-liter.i Posi‡Æo_endere‡o_doca * L}
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 47,
                           INPUT TRIM(RETURN-VALUE)).
        
        CREATE tt-erro.
        ASSIGN li-cont-erro = li-cont-erro + 1.
        ASSIGN tt-erro.i-sequen = li-cont-erro
               tt-erro.cd-erro  = 47
               tt-erro.mensagem = RETURN-VALUE + "(DC)":U.
        
        RETURN "NOK":U.
    END.

    ASSIGN pc-endereco-doca = lc-cod-bloco  + "/" + ~
                              lc-cod-rua    + "/" + ~
                              lc-cod-nivel  + "/" + ~
                              lc-cod-coluna + "/" + ~
                              IF SUBSTRING(lc-posicao,1,1)='R' THEN 'D' ELSE IF SUBSTRING(lc-posicao,1,1)='L' THEN 'E' ELSE SUBSTRING(lc-posicao,1,1).
    
    RETURN "OK":U.
END.

PROCEDURE pi-verifica-etiqueta-endereco:
    DEFINE INPUT        PARAMETER pc-cod-estabel AS CHARACTER  NO-UNDO.
    DEFINE INPUT        PARAMETER pc-cod-local   AS CHARACTER  NO-UNDO.
    DEFINE INPUT        PARAMETER pde-id-box     AS DECIMAL    NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-erro.

    DEFINE VARIABLE li-cont-erro AS INTEGER NO-UNDO.

    RUN goToKey IN wgbosc030 (INPUT  pc-cod-estabel,
                              INPUT  pc-cod-local,
                              INPUT  pde-id-box).
    IF RETURN-VALUE <> "OK":U THEN DO:
        {utp/ut-field.i mgscm wm-box id-box 1}
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 56,
                           INPUT TRIM(RETURN-VALUE)).
        
        CREATE tt-erro.
        ASSIGN li-cont-erro = li-cont-erro + 1.
        ASSIGN tt-erro.i-sequen = li-cont-erro
               tt-erro.cd-erro  = 56
               tt-erro.mensagem = RETURN-VALUE + "(DC)":U.
        
        RETURN "NOK":U.
    END.

    RETURN "OK":U.
END.

PROCEDURE getParLerEnderecoDoca:
    DEFINE OUTPUT PARAMETER l-le-end-doca AS LOGICAL  NO-UNDO.

    FIND FIRST bc-param-ext NO-LOCK
         WHERE bc-param-ext.cod-entidade-param-ext   = "bc-tipo-trans" 
           AND bc-param-ext.cod-chave-param-ext      = "wmsai001"
           AND bc-param-ext.cod-param-ext            = "LE-ENDERECO-DOCA"
      NO-ERROR.

    IF ERROR-STATUS:ERROR OR
      (ERROR-STATUS:GET-NUMBER(1) <> 138 AND ERROR-STATUS:NUM-MESSAGES <> 0) THEN DO:
        RETURN "NOK":U.
    END.

    /* Se nÆo encontrou, adiciona o valor default */
    IF AVAIL bc-param-ext THEN ASSIGN l-le-end-doca = bc-param-ext.param-logico.
                          ELSE ASSIGN l-le-end-doca = FALSE.

    RETURN "OK":U.
END.

PROCEDURE pi-initialize-dbo:
    IF NOT VALID-HANDLE(wgbosc030) THEN DO:
        RUN scbo/bosc030.p PERSISTENT SET wgbosc030       NO-ERROR.
        RUN openQueryStatic IN wgbosc030 (INPUT "Main":U) NO-ERROR.
    END.
    IF NOT VALID-HANDLE(wgbosc032) THEN DO:
        RUN scbo/bosc032.p PERSISTENT SET wgbosc032       NO-ERROR.
        RUN openQueryStatic IN wgbosc032 (INPUT "Main":U) NO-ERROR.
    END.
    IF NOT VALID-HANDLE(wgbosc038) THEN DO:
        RUN scbo/bosc038.p PERSISTENT SET wgbosc038       NO-ERROR.
        RUN openQueryStatic IN wgbosc038 (INPUT "Main":U) NO-ERROR.
    END.
    IF NOT VALID-HANDLE(wgBOSC060) THEN DO:
        RUN scbo/bosc060.p PERSISTENT SET wgBOSC060       NO-ERROR.
        RUN openQueryStatic IN wgBOSC060 (INPUT "Main":U) NO-ERROR.
    END.
    IF NOT VALID-HANDLE(wgbosc078) THEN DO:
        RUN scbo/bosc078.p PERSISTENT SET wgbosc078       NO-ERROR.
        RUN openQueryStatic IN wgbosc078 (INPUT "Main":U) NO-ERROR.
    END.
END.

PROCEDURE pi-destroy-dbo:

    IF VALID-HANDLE(wgbosc032) THEN DELETE PROCEDURE wgbosc032.
    
    IF VALID-HANDLE(wgbosc038) THEN DELETE PROCEDURE wgbosc038.
    
    IF VALID-HANDLE(wgBOSC060) THEN DELETE PROCEDURE wgBOSC060.
    
    IF VALID-HANDLE(wgbosc078) THEN DELETE PROCEDURE wgbosc078.
END.
&endif


&else 
    run utp/ut-msgs.p (input "show":U, 
                       input 28036,
                       INPUT "").
&endif
