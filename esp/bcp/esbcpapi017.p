{include/i-prgvrs.i ESBCPAPI017 2.00.00.013 } /*** 010013 ***/
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bcapi9018 MBC}
&ENDIF
{include/i_dbinst.i}  /* vers∆o das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bcapi9018.p                                                               **
**                                                                                         **
**   Versao....: 2.00.00.000 - outubro/2002 - Karla - Criaá∆o do programa                  **
**                                                                                         **
**   Finalidade: Api de efetivacao do Picking WMS                                          **                                                                                         **
********************************************************************************************/
{bcp/bc9102.i}     /* Definicao da temp-table de erros do coleta de dados    */
{bcp/bc9107.i}     /* Definicao dos campos de comunicacao com o adapter      */
{bcp/bcapi004.i}   /* Definicao da temp-table tt-prog-bc                     */
{esp/bcp/esbcp017.i}  /* Definicao da temp-table de transferencia do coleta de dados */
{utp/utapi009.i}   /* login */
{bcp/bc9018h.i}    /*fk - definicao das procedures utilizadas para controle ean/dun */
/*****************************************************************************/
Define Input        Parameter pNumTrans    As Integer   No-undo.
Define Input        Parameter TABLE FOR ttIntegracao.
Define Input-Output Parameter Table For tt-erro.

Define New Global Shared Variable c-seg-usuario                 As Char   Format  "x(12)":U No-undo.
Define                   Variable vNumSeq                       As Integer                  No-undo.
Define                   Variable vLogOK                        As Logical                  No-undo.
Define                   Variable vNumCont                      As Integer         Init 0   No-undo.
Define                   Variable v-cod-estabel                 As Character                No-undo.
Define                   Variable v-cod-local                   As Character                No-undo.
Define                   Variable vDesSeriais                   As Character                No-undo.
DEFINE                   VARIABLE vdetalhe                      AS CHARACTER                NO-UNDO.
DEFINE                   VARIABLE vusuario                      AS CHARACTER                NO-UNDO.
DEFINE                   VARIABLE i-cont-erro                   AS INTEGER                  NO-UNDO.

DEFINE                   VARIABLE vcod-local                   LIKE wm-box-movto.cod-local          NO-UNDO.
DEFINE                   VARIABLE vcod-estabel                 LIKE wm-box-movto.cod-estabel        NO-UNDO.
DEFINE                   VARIABLE vid-movto                    LIKE wm-box-movto.id-movto           NO-UNDO.
DEFINE                   VARIABLE vid-docto                    LIKE wm-box-movto.id-docto           NO-UNDO.
DEFINE                   VARIABLE vnum-seq-item                LIKE wm-box-movto.num-seq-item       NO-UNDO.
DEFINE                   VARIABLE vcod-item                    LIKE wm-box-movto.cod-item           NO-UNDO.
DEFINE                   VARIABLE vnum-box-lido                LIKE wm-box-movto.id-box             NO-UNDO.
DEFINE                   VARIABLE vqtd-item-digit              LIKE wm-box-movto.qtd-item           NO-UNDO.
DEFINE                   VARIABLE vqtd-item                    LIKE wm-box-movto.qtd-item-orig      NO-UNDO.
DEFINE                   VARIABLE vcod-embalagem               LIKE wm-box-movto.cod-embalagem      NO-UNDO.
DEFINE                   VARIABLE vqtd-embalagem               LIKE wm-box-movto.qti-embalagem      NO-UNDO.
DEFINE                   VARIABLE vdat-atualizacao             LIKE wm-box-movto.dt-atualizacao     NO-UNDO.
DEFINE                   VARIABLE vdat-transacao               LIKE wm-box-movto.dt-transacao       NO-UNDO.
DEFINE                   VARIABLE vnum-serial                  As DECIMAL Format '>>>>>>>>>>>>>>':U NO-UNDO.
DEFINE                   VARIABLE vsequencia                   AS INTEGER                           NO-UNDO.
DEFINE                   VARIABLE vnum-tempo-inicio            AS DECIMAL FORMAT '>>>>>>>>>>>>>9':U NO-UNDO.
DEFINE                   VARIABLE vcod-coletor                 AS CHARACTER    FORMAT 'x(14)':U     NO-UNDO.
DEFINE                   VARIABLE vcod-equipamento             As Character    Format 'x(14)':U     NO-UNDO.
Define                   Variable wgbosc074                    As Widget-handle                     No-undo.
Define                   Variable wgbosc032                    As Widget-handle                     No-undo.
DEFINE                   VARIABLE pcod-lote                    LIKE wm-etiqueta.cod-lote            NO-UNDO.
DEFINE                   VARIABLE vcod-lote-aux                LIKE wm-etiqueta.cod-lote            NO-UNDO.
DEFINE                   VARIABLE r-rowid-wm-box-movto         AS ROWID                             NO-UNDO.
DEFINE                   VARIABLE vqtd-total-item              LIKE wm-etiqueta.qtd-item            NO-UNDO.
/*****************************************************************************/

/*****************************************************************************/
Define Temp-table RowErrors No-undo 
    Field ErrorSequence    As Integer 
    Field ErrorNumber      As Integer 
    Field ErrorDescription As Character 
    Field ErrorParameters  As Character 
    Field ErrorType        As Character 
    Field ErrorHelp        As Character 
    Field ErrorSubType     As Character.

def temp-table tt-tarefa-docto no-undo
    field CodUsuario     like wm-tarefa-docto-itens.cod-usuario     
    field CodEquipamento like wm-tarefa-docto-itens.cod-equipamento 
    field CodColetor     like wm-tarefa-docto-itens.cod-coletor     
    field TempoInicio    as integer.

def temp-table tt-etiqueta no-undo
    field id-etiqueta    like wm-etiqueta.id-etiqueta
    field qtd-retirada   like wm-etiqueta.qtd-item 
    index codigo is unique id-etiqueta.

def temp-table tt-etiqueta-lote no-undo
    field id-etiqueta    like wm-etiqueta.id-etiqueta
    field qtd-retirada   like wm-etiqueta.qtd-item 
    FIELD cod-lote       LIKE wm-etiqueta.cod-lote
    INDEX codigo /*IS UNIQUE*/ id-etiqueta. /* Comentado o id-etiqueta, pois via transaá∆o sem serial poder† haver mais de uma bc-trans com num-serial igual a zero */

/*****************************************************************************/

BC9018:
DO TRANSACTION on ERROR  undo BC9018, leave BC9018
               on quit   undo BC9018, leave BC9018
               on stop   undo BC9018, leave BC9018
               on endkey undo BC9018, leave BC9018:

        Create tt-prog-bc.
        Assign tt-prog-bc.cod-prog-dtsul        = "bc9018":U
               tt-prog-bc.cod-versao-integracao = 1
               tt-prog-bc.usuario               = c-seg-usuario
               tt-prog-bc.opcao                 = 1.

        Run bcp/bcapi004.p (Input-output Table tt-prog-bc,
                            Input-output Table tt-erro).

        Find First tt-prog-bc   No-error.
        Find First tt-erro      No-error.

        If  Available tt-erro Then Do:
            Create  tt-erro.
            ASSIGN vsequencia =  vsequencia + 1.
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Erro_encontrado_quando_acessando_programa_bcapi004_(bc-prog-trans)" *}
            Assign  tt-erro.i-sequen    = vsequencia
                    tt-erro.cd-erro     = 1
                    tt-erro.mensagem    = RETURN-VALUE + '(DC)':U.
            Run deleteObjects.
            UNDO BC9018, Return 'NOK':U.
        End. /* If  Available tt-erro */

        ASSIGN vusuario = trim(_RetornaValChar('usuario':U)).
        ASSIGN vdetalhe =  _RetornaValChar('detalhe':U).
        ASSIGN vLogOk = NO.

        {bcp/bc9017.i1  vusuario}
        IF vLogOk = NO THEN DO:
            Create  tt-erro.
            ASSIGN vsequencia =  vsequencia + 1.
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-usuario AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Usu†rio" *}
            ASSIGN c-lbl-liter-usuario = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-nao-cadastrado-no-datasul-ems AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "n∆o_cadastrado_no_Datasul-EMS" *}
            ASSIGN c-lbl-liter-nao-cadastrado-no-datasul-ems = TRIM(RETURN-VALUE).
            Assign  tt-erro.i-sequen    = vsequencia
                    tt-erro.cd-erro     = 2
                    tt-erro.mensagem    = c-lbl-liter-usuario + ' ' +  _RetornaValChar('usuario') + ' ' + c-lbl-liter-nao-cadastrado-no-datasul-ems + '(DC)':U.
            Run DeleteObjects.
            UNDO BC9018, Return 'NOK':U.
         END.

         if NOT can-find(first bc-trans-filho WHERE
            bc-trans-filho.nr-trans = pNumTrans) THEN DO:
            Create tt-erro.
            ASSIGN vsequencia =  vsequencia + 1.
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "N∆o_existem_seriais_lidos_para_a_tarefa_de_picking" *}
            Assign tt-erro.i-sequen = vsequencia
                   tt-erro.cd-erro  = 3
                   tt-erro.mensagem = RETURN-VALUE + '(DC)':U.
            Run DeleteObjects.
            UNDO BC9018, Return 'NOK':U.
         END.

         ASSIGN vusuario = trim(_RetornaValChar('usuario':U))
                vdetalhe =  _RetornaValChar('detalhe':U).

         FIND FIRST bc-trans-filho WHERE bc-trans-filho.nr-trans = pNumTrans NO-LOCK NO-ERROR.
         ASSIGN vcod-local         = TRIM(entry(2, ENTRY(1,bc-trans-filho.conteudo-trans,';'),':':U))
                vcod-estabel       = TRIM(entry(2, ENTRY(2,bc-trans-filho.conteudo-trans,';'),':':U))
                vid-movto          = decimal(entry(2, ENTRY(3,bc-trans-filho.conteudo-trans,';'),':':U))
                vid-docto          = decimal(entry(2, ENTRY(5,bc-trans-filho.conteudo-trans,';'),':':U))
                vnum-seq-item      = INTEGER(entry(2, ENTRY(7,bc-trans-filho.conteudo-trans,';'),':':U))
                vcod-item          = TRIM(entry(2, ENTRY(10,bc-trans-filho.conteudo-trans,';'),':':U))
                vnum-box-lido      = DECIMAL(entry(2, ENTRY(11,bc-trans-filho.conteudo-trans,';'),':':U))
                vqtd-item-digit    = INTEGER(entry(2, ENTRY(9,bc-trans-filho.conteudo-trans,';'),':':U))
                vqtd-item          = INTEGER(entry(2, ENTRY(8,bc-trans-filho.conteudo-trans,';'),':':U))
                vcod-embalagem     = TRIM(entry(2, ENTRY(12,bc-trans-filho.conteudo-trans,';'),':':U))
                vqtd-embalagem     = INTEGER(entry(2, ENTRY(13,bc-trans-filho.conteudo-trans,';'),':':U))
                vdat-atualizacao   = DATE(entry(2, ENTRY(14,bc-trans-filho.conteudo-trans,';'),':':U))
                vdat-transacao     = DATE(entry(2, ENTRY(15,bc-trans-filho.conteudo-trans,';'),':':U))
                vnum-tempo-inicio  = DECIMAL(entry(2, ENTRY(16,bc-trans-filho.conteudo-trans,';'),':':U))
                vcod-coletor       = TRIM(entry(2, ENTRY(17,bc-trans-filho.conteudo-trans,';'),':':U))
                vcod-equipamento   = TRIM(entry(2, ENTRY(18,bc-trans-filho.conteudo-trans,';'),':':U)).

          FOR EACH tt-etiqueta-lote:
              DELETE tt-etiqueta-lote.
          END.
          IF NOT VALID-HANDLE(wgbosc074) THEN DO:
                Run scbo/bosc074.p Persistent Set wgbosc074       No-error.
                Run openQueryStatic In wgbosc074 (Input "Main":U) No-error.
          END.
          IF NOT VALID-HANDLE(wgbosc032) THEN DO:
                Run scbo/bosc032.p Persistent Set wgbosc032       No-error.
                Run openQueryStatic In wgbosc032 (Input "Main":U) No-error.
          END.

          FOR Each bc-trans-filho WHERE
              bc-trans-filho.nr-trans = pNumTrans NO-LOCK:      

              ASSIGN vnum-serial     = decimal(ENTRY(2, ENTRY(6,bc-trans-filho.conteudo-trans,';'),':':U))
                     vqtd-item-digit = DECIMAL(entry(2, ENTRY(9,bc-trans-filho.conteudo-trans,';'),':':U)).

              RUN Gotokey IN wgbosc074 (INPUT vnum-serial).
              IF RETURN-VALUE = 'ok':U THEN DO:
                 RUN getCharField IN wgbosc074 (INPUT 'cod-lote':U, OUTPUT pcod-lote).
              END.
              else do:
                 assign pcod-lote = TRIM(entry(2, ENTRY(19,bc-trans-filho.conteudo-trans,';'),':':U)).
              End.

              CREATE tt-etiqueta-lote.
              ASSIGN tt-etiqueta-lote.id-etiqueta  = vnum-serial
                     tt-etiqueta-lote.qtd-retirada = vqtd-item-digit
                     tt-etiqueta-lote.cod-lote     = pcod-lote.

           End. /*For */

           FOR EACH tt-tarefa-docto:
               DELETE tt-tarefa-docto.
           END.

           FOR EACH tt-etiqueta:
               DELETE tt-etiqueta.
           END.

           CREATE tt-tarefa-docto.
           ASSIGN tt-tarefa-docto.CodUsuario     = vusuario
                  tt-tarefa-docto.CodEquipamento = vcod-equipamento
                  tt-tarefa-docto.CodColetor     = vcod-coletor
                  tt-tarefa-docto.TempoInicio    = vnum-tempo-inicio.

           ASSIGN vcod-lote-aux = '**':U
                  vqtd-item = 0.

           FOR EACH tt-etiqueta-lote BY tt-etiqueta-lote.cod-lote:

               IF  vcod-lote-aux  <> '**':U AND
                   vcod-lote-aux  <> tt-etiqueta-lote.cod-lote THEN DO:
                   Run goToKey2 in wgbosc032 (input vcod-local,
                                              INPUT vcod-estabel,
                                              INPUT vid-movto,
    			                              Input 2) /* tipo de movimento = retirada */.

                   IF RETURN-VALUE = 'ok':U  THEN DO:
                        run getrowid in wgbosc032 (OUTPUT r-rowid-wm-box-movto).
                   END.
                   ELSE DO:
                       For Each RowErrors:
                            ASSIGN vsequencia =  vsequencia + 1
                                   ErrorDescription = ErrorDescription + '(WMS)':U.
                            Create tt-erro.
                            Assign tt-erro.i-sequen = vsequencia
                                   tt-erro.cd-erro  = ErrorNumber
                                   tt-erro.mensagem = ErrorDescription.
                        End. /* Each RowErrors */
                        if valid-handle(wgbosc032)    
                        and  wgbosc032:type = 'procedure':U 
                        and (wgbosc032:file-name = 'scbo/bosc032.p':U) 
                        then delete procedure wgbosc032. 
                        if valid-handle(wgbosc074)    
                        and  wgbosc074:type = 'procedure':U 
                        and (wgbosc074:file-name = 'scbo/bosc074.p':U) 
                        then delete procedure wgbosc074. 
                        UNDO BC9018, Return 'NOK':U.
                   END.

                   /* substituido pelo metodo confirmamovtopicking bosc096 */
                   RUN wmp/wm9021.p (INPUT vnum-box-lido,
                                     input vcod-lote-aux,
                                     input vqtd-total-item,
                                     input r-rowid-wm-box-movto, 
                                     INPUT vcod-embalagem,
                                     input table tt-etiqueta,
                                     INPUT TABLE tt-tarefa-docto,
                                     output TABLE RowErrors).
                   FIND FIRST RowErrors NO-LOCK NO-ERROR.
                   If Return-value <> 'OK':U OR AVAILABLE RowErrors Then do:
                        For Each RowErrors:
                            ASSIGN vsequencia =  vsequencia + 1.
                            Create tt-erro.
                            Assign tt-erro.i-sequen = vsequencia
                                   tt-erro.cd-erro  = ErrorNumber
                                   tt-erro.mensagem = ErrorDescription.
                        End. /* Each RowErrors */
                        if valid-handle(wgbosc032)    
                        and  wgbosc032:type = 'procedure':U 
                        and (wgbosc032:file-name = 'scbo/bosc032.p':U) 
                        then delete procedure wgbosc032. 
                        if valid-handle(wgbosc074)    
                        and  wgbosc074:type = 'procedure':U 
                        and (wgbosc074:file-name = 'scbo/bosc074.p':U) 
                        then delete procedure wgbosc074. 
                        UNDO BC9018, Return 'NOK':U.
                    End. /* If  Return-value <> 'OK' Then do: */
                    FOR EACH tt-etiqueta:
                        DELETE tt-etiqueta.
                    END.
                    ASSIGN vqtd-total-item = 0.
               END.
               If vnum-serial <> 0 then do:
                   CREATE tt-etiqueta.
                   ASSIGN tt-etiqueta.id-etiqueta  = tt-etiqueta-lote.id-etiqueta
                          tt-etiqueta.qtd-retirada = tt-etiqueta-lote.qtd-retirada. 

                   /* fk: Seta historico na bc-etiqueta, caso exista */
                   RUN piHabilitaHistoricoBcEtiqueta (pNumTrans, tt-etiqueta-lote.id-etiqueta ). /*bcp/bc9018h.i*/
                   /* fk fim */

               End.

               ASSIGN vcod-lote-aux    = tt-etiqueta-lote.cod-lote
                      vqtd-total-item  = vqtd-total-item + tt-etiqueta-lote.qtd-retirada.
           END.
           /* p pegar o ultimo lote e enviar */
           IF  vcod-lote-aux  <> '**':U THEN DO:
               Run goToKey2 in wgbosc032 (input vcod-local,
                                          INPUT vcod-estabel,
                                          INPUT vid-movto,
                                          Input 2) /* tipo de movimento = retirada */.

               IF RETURN-VALUE = 'ok':U  THEN DO:
                    run getrowid in wgbosc032 (OUTPUT r-rowid-wm-box-movto).
               END.
               ELSE DO:
                   For Each RowErrors:
                        ASSIGN vsequencia =  vsequencia + 1
                               ErrorDescription = ErrorDescription + '(WMS)':U.
                        Create tt-erro.
                        Assign tt-erro.i-sequen = vsequencia
                               tt-erro.cd-erro  = ErrorNumber
                               tt-erro.mensagem = ErrorDescription.
                    End. /* Each RowErrors */
                    if valid-handle(wgbosc032)    
                    and  wgbosc032:type = 'procedure':U 
                    and (wgbosc032:file-name = 'scbo/bosc032.p':U) 
                    then delete procedure wgbosc032. 
                    if valid-handle(wgbosc074)    
                    and  wgbosc074:type = 'procedure':U 
                    and (wgbosc074:file-name = 'scbo/bosc074.p':U) 
                    then delete procedure wgbosc074. 
                    UNDO BC9018, Return 'NOK':U.
               END.

               If vnum-serial = 0 Then empty temp-table tt-etiqueta.
               /* substituido pelo metodo confirmamovtopicking bosc096 */
               RUN wmp/wm9021.p (INPUT vnum-box-lido,
                                 input vcod-lote-aux,
                                 input vqtd-total-item,
                                 input r-rowid-wm-box-movto, 
                                 INPUT vcod-embalagem,
                                 input table tt-etiqueta,
                                 INPUT TABLE tt-tarefa-docto,
                                 output TABLE RowErrors).
               FIND FIRST RowErrors NO-LOCK NO-ERROR.
               If Return-value <> 'OK':U OR AVAILABLE RowErrors Then do:
                    For Each RowErrors:
                        ASSIGN vsequencia =  vsequencia + 1
                               ErrorDescription = ErrorDescription + '(WMS)':U.
                        Create tt-erro.
                        Assign tt-erro.i-sequen = vsequencia
                               tt-erro.cd-erro  = ErrorNumber
                               tt-erro.mensagem = ErrorDescription.
                    End. /* Each RowErrors */
                    if valid-handle(wgbosc032)    
                    and  wgbosc032:type = 'procedure':U 
                    and (wgbosc032:file-name = 'scbo/bosc032.p':U) 
                    then delete procedure wgbosc032. 
                    if valid-handle(wgbosc074)    
                    and  wgbosc074:type = 'procedure':U 
                    and (wgbosc074:file-name = 'scbo/bosc074.p':U) 
                    then delete procedure wgbosc074. 
                    UNDO BC9018, Return 'NOK':U.
                End. /* If  Return-value <> 'OK' Then do: */

                FOR EACH tt-etiqueta:
                    DELETE tt-etiqueta.
                END.
                ASSIGN vqtd-total-item = 0.
           END.     

           if valid-handle(wgbosc074)    
           and  wgbosc074:type = 'procedure':U 
           and (wgbosc074:file-name = 'scbo/bosc074.p':U) 
           then delete procedure wgbosc074. 

           if valid-handle(wgbosc032)    
           and  wgbosc032:type = 'procedure':U 
           and (wgbosc032:file-name = 'scbo/bosc032.p':U) 
           then delete procedure wgbosc032. 
           /* Processo concluido com sucesso */
           Return 'OK':U.

End. /* Do: */          
