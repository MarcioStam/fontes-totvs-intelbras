CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

DEFINE TEMP-TABLE tt-licenciam-import-oc NO-UNDO LIKE licenciam-import-oc
    FIELD r-Rowid AS ROWID.

DEFINE TEMP-TABLE tt-licenciam-import-oc-aux NO-UNDO LIKE licenciam-import-oc
    FIELD r-Rowid AS ROWID.

DEFINE VARIABLE h-bocx351 AS HANDLE      NO-UNDO.
DEFINE VARIABLE l-create  AS LOGICAL     NO-UNDO.

/* DEFINE VAR iXML AS LONGCHAR NO-UNDO.                                                               */
/* DEFINE VAR oXML AS LONGCHAR NO-UNDO.                                                               */
/*                                                                                                    */
/* ASSIGN iXML = "<?xml version='1.0' encoding='UTF-8'?>                                              */
/*                <MENSAGEM>                                                                          */
/*                    <CABECALHO>                                                                     */
/*                        <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor> */
/*                        <NumeroOperacao>260953-ga046926</NumeroOperacao>                            */
/*                        <CodigoMensagem>MSG0226</CodigoMensagem>                                    */
/*                        <LoginUsuario>gi041250</LoginUsuario>                                       */
/*                    </CABECALHO>                                                                    */
/*                    <CONTEUDO>                                                                      */
/*                       <MSG0230>                                                                    */
/*                            <LI>                                                                    */
/*                                <NumeroEmbarque>271049</NumeroEmbarque>                             */
/*                                <CodigoEstabelecimento>101</CodigoEstabelecimento>                  */
/*                                <NumeroOrdemCompra>486700</NumeroOrdemCompra>                       */
/*                                <SequenciaParcela>1</SequenciaParcela>                              */
/*                                <NumeroLIAnuida>312</NumeroLIAnuida>                                */
/*                                <ValidadeLI></ValidadeLI>                                           */
/*                                <ExportarLI>YES</ExportarLI>                                        */
/*                            </LI>                                                                   */
/*                        </MSG0230>                                                                  */
/*                    </CONTEUDO>                                                                     */
/*                </MENSAGEM>".                                                                       */

{esp/esb/in/msg0230.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, MSG0230, LI
   DATA-RELATION FOR conteudo, MSG0230 RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0230, LI  RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0230R1, resultado
   DATA-RELATION FOR conteudor, MSG0230R1         RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0230R1, resultado         RELATION-FIELDS (idm, idm) NESTED. 

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor. 

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0230R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0230 NO-ERROR.

CREATE conteudor.
CREATE MSG0230R1.
CREATE resultado.

RUN pi-gera-fatura-embarque.

IF  RETURN-VALUE <> "OK" THEN DO:
    
    ASSIGN resultado.sucesso    = no
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".

    FOR EACH tt-erro
        BREAK BY tt-erro.Mensagem:
        ASSIGN resultado.Mensagem = resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.

DATASET mensagemr:WRITE-XML('longchar', oXML, NO).

define variable hDoc    as handle   no-undo.
create x-document hDoc.
hDoc:LOAD("longchar", oXML, NO).
hDoc:SAVE("file","C:/temp/xml-saida" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").

RETURN.

PROCEDURE pi-gera-fatura-embarque:

    blk_LI:
    DO TRANSACTION
    ON ERROR UNDO blk_LI, LEAVE blk_LI
    ON STOP  UNDO blk_LI, LEAVE blk_LI: 

        RUN cxbo/bocx351.p  PERSISTENT SET h-bocx351.
        RUN openQueryStatic IN h-bocx351 (INPUT "Main":U).

        FOR EACH LI:
            /*Carrega LIs do embarque para validar a ordem*/
            EMPTY TEMP-TABLE tt-licenciam-import-oc.
            RUN piRetornaLi IN h-bocx351 (INPUT 2,  /*Embarque Importacao*/
                                          INPUT YES,
                                          INPUT ?,  /*Processo Importacao*/
                                          INPUT LI.CodigoEstabelecimento,        
                                          INPUT LI.NumeroEmbarque,               
                                          INPUT ?,   /*Parcela*/
                                          INPUT NO,  /*Considera Parcelas Eliminadas*/
                                          INPUT YES, /*Considera Parcelas Recebidas*/
                                          INPUT 0,                  /*Ordem ini*/
                                          INPUT 99999999,           /*Ordem fim*/
                                          INPUT "",                 /*it-codigo ini*/
                                          INPUT "ZZZZZZZZZZZZZZZZ", /*it-codigo fim*/
                                          INPUT "",                 /*class fisal ini*/
                                          INPUT "999999999",        /*class fisal ini*/
                                          INPUT "", /*LI ini*/
                                          INPUT "ZZZZZZZZZZZZZZZZZZZZ", /*LI fim*/
                                          OUTPUT TABLE tt-licenciam-import-oc).   

            FIND FIRST tt-licenciam-import-oc 
                 WHERE tt-licenciam-import-oc.numero-ordem = LI.NumeroOrdemCompra
                   AND tt-licenciam-import-oc.parcela      = LI.SequenciaParcela NO-ERROR.

            IF NOT AVAIL tt-licenciam-import-oc THEN DO:
                RUN pi-erro (INPUT "NÆo encontrado necessidade de LI para a ordem " + STRING(LI.NumeroOrdemCompra) + " parcela " + STRING(LI.SequenciaParcela)).
                RETURN "NOK".
            END.

            RUN emptyRowErrors IN h-bocx351.
            RUN emptyRowObject IN h-bocx351.

            EMPTY TEMP-TABLE tt-licenciam-import-oc-aux.
            CREATE tt-licenciam-import-oc-aux.
            BUFFER-COPY tt-licenciam-import-oc TO tt-licenciam-import-oc-aux.
            ASSIGN tt-licenciam-import-oc-aux.licenca-import = LI.NumeroLIAnuida.

            RUN goToKey IN h-bocx351 (INPUT tt-licenciam-import-oc-aux.numero-ordem,
                                      INPUT tt-licenciam-import-oc-aux.parcela).

            IF RETURN-VALUE = "OK" THEN
                ASSIGN l-create = NO.
            ELSE
                ASSIGN l-create = YES.
            
            RUN setRecord IN h-bocx351 (INPUT TABLE tt-licenciam-import-oc-aux).

            IF l-create THEN
                /*Cria*/
                RUN createRecord IN h-bocx351.
            ELSE 
                /*Altera*/
                RUN updateRecord IN h-bocx351.

            IF RETURN-VALUE = "NOK" THEN DO:
            
                RUN getRowErrors IN h-bocx351 (OUTPUT TABLE RowErrors).

                IF CAN-FIND (FIRST RowErrors) THEN DO:
                    FOR EACH RowErrors NO-LOCK                                                                                                    
                       WHERE RowErrors.ErrorType   <> "INTERNAL":U                                                                                
                         AND RowErrors.ErrorSubType = "Error":U:  
                        RUN pi-erro (INPUT RowErrors.errorDescription).
                        UNDO blk_LI, LEAVE blk_LI.
                    END. 
                END.
            END.

            FIND FIRST int-licenciam-import-oc EXCLUSIVE-LOCK
                 WHERE int-licenciam-import-oc.numero-ordem = tt-licenciam-import-oc-aux.numero-ordem
                   AND int-licenciam-import-oc.parcela      = tt-licenciam-import-oc-aux.parcela NO-ERROR.

            IF NOT AVAIL int-licenciam-import-oc THEN DO:
                CREATE int-licenciam-import-oc.
                ASSIGN int-licenciam-import-oc.numero-ordem = tt-licenciam-import-oc-aux.numero-ordem 
                       int-licenciam-import-oc.parcela      = tt-licenciam-import-oc-aux.parcela.
            END.
            
            ASSIGN int-licenciam-import-oc.validade-li = LI.ValidadeLI.

            /*Exporta LI*/
            IF LI.ExportarLI THEN DO:
                FIND FIRST tt-licenciam-import-oc-aux NO-ERROR.
    
                RUN piExportaLI IN h-bocx351 (INPUT tt-licenciam-import-oc-aux.cod-livre-2,
                                              INPUT tt-licenciam-import-oc-aux.licenca-import,
                                              INPUT TABLE tt-licenciam-import-oc).

                /*Lˆ as licensas de mesma NCM para gravar o campo espec¡fico*/
                FOR EACH tt-licenciam-import-oc
                    WHERE tt-licenciam-import-oc.cod-livre-2 = tt-licenciam-import-oc-aux.cod-livre-2:

                    FIND FIRST int-licenciam-import-oc EXCLUSIVE-LOCK
                         WHERE int-licenciam-import-oc.numero-ordem = tt-licenciam-import-oc.numero-ordem
                           AND int-licenciam-import-oc.parcela      = tt-licenciam-import-oc.parcela NO-ERROR.

                    IF NOT AVAIL int-licenciam-import-oc THEN DO:
                        CREATE int-licenciam-import-oc.
                        ASSIGN int-licenciam-import-oc.numero-ordem = tt-licenciam-import-oc.numero-ordem 
                               int-licenciam-import-oc.parcela      = tt-licenciam-import-oc.parcela.
                    END.
                    
                    ASSIGN int-licenciam-import-oc.validade-li = LI.ValidadeLI.
                END.
            END.

            RELEASE int-licenciam-import-oc.
        END.    
    END.

    /*Elimina Handles*/
    IF VALID-HANDLE(h-bocx351) THEN DO:
        DELETE PROCEDURE h-bocx351 NO-ERROR.
        ASSIGN h-bocx351 = ?.
    END.
    
    IF NOT CAN-FIND (FIRST tt-erro) THEN
        RETURN "OK".
    ELSE 
        RETURN "NOK".
END PROCEDURE.


PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

    RETURN "OK".
END PROCEDURE.

    
    
