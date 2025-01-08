/********************************************************************************************/
/* Programa...: esp/esb/in/msg0172.p - REGISTRA_CATEGORIA_CANAL                             */
/* Altor......: Roger Marcelino Bruhn                                                       */
/* Data.......: 24/06/2014                                                                  */ 
/* Objetivo...: Listar ao Canal os t°tulos abatidos por encontro de contas                  */
/********************************************************************************************/

CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

{esp/esb/in/msg0172.i}
{esp/esb/in/msg9999.i}

DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE DATASET mensagem xml-node-name 'MENSAGEM' FOR cabecalho, conteudo, msg0172
   DATA-RELATION FOR conteudo, msg0172 RELATION-FIELDS (idm, idm) NESTED.


DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

/* define variable hDoc    as handle   no-undo.                                             */
/* create x-document hDoc.                                                                  */
/* hDoc:LOAD("longchar", iXML, NO).                                                         */
/* hDoc:SAVE("file","C:/temp/iXML" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").  */

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0172R1, msg0172r1-tit, resultado
   DATA-RELATION FOR conteudor, msg0172R1     RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0172R1, msg0172r1-tit RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0172R1, resultado     RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0172R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST msg0172 NO-ERROR.

CREATE conteudor.
CREATE resultado.
CREATE msg0172r1.

/* CRIAÄ«O CATEGORIA CANAL */
RUN pi-titulos-abatidos.


IF  RETURN-VALUE <> "OK" THEN DO:
    ASSIGN resultado.sucesso    = no
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".

    FOR EACH tt-erro
        BREAK BY Mensagem:
        ASSIGN resultado.Mensagem =  resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.


DATASET mensagemr:WRITE-XML('longchar', oXML, NO).

RETURN.

PROCEDURE pi-titulos-abatidos:

    EMPTY TEMP-TABLE tt-erro.

    DEF VAR de-total AS DEC NO-UNDO.
    DEF BUFFER b_movto_tit_acr      FOR movto_tit_acr.
    DEF BUFFER b_movto_tit_acr_tres FOR movto_tit_acr.
    DEF BUFFER b_tit_acr            FOR tit_acr.

    FIND int-solicitacao NO-LOCK
        WHERE int-solicitacao.CodigoSolicitacaoBeneficio = msg0172.CodigoSolicitacaoBeneficio NO-ERROR.

    IF  NOT AVAIL int-solicitacao THEN DO:
        RUN pi-erro (INPUT 'C¢digo de Solicitaá∆o do benef°cio n∆o encontrado.').
        RETURN "NOK".
    END.

        
    FIND FIRST int-cc-benef
        WHERE int-cc-benef.canal          = int-solicitacao.cod-emitente
          AND int-cc-benef.unid-neg       = int-solicitacao.CodigoUnidadeNegocio
          AND int-cc-benef.tipo-beneficio = int-solicitacao.tipo-beneficio
          AND int-cc-benef.dt-periodo-ini = int-solicitacao.dt-periodo-ini
          AND int-cc-benef.dt-periodo-fim = int-solicitacao.dt-periodo-fim NO-ERROR.

    IF  NOT AVAIL int-cc-benef THEN
        RETURN "OK".


    def var c-refer-consulta as char no-undo.
    
    if  int-solicitacao.dt-trans < 01/11/2016 then
        assign c-refer-consulta = substr(int-solicitacao.char-1, 9,10).
    else 
        assign c-refer-consulta = int-solicitacao.ref-encontro-contas.

        
    FIND enctro_cta NO-LOCK
       WHERE enctro_cta.cod_estab = int-cc-benef.cod_estab
         AND enctro_cta.cod_refer = c-refer-consulta NO-ERROR.
    
    IF  NOT AVAIL enctro_cta THEN
        RETURN "OK".

    for each movto_tit_acr no-lock 
        where movto_tit_acr.cod_estab = enctro_cta.cod_estab
        and   movto_tit_acr.cod_refer = enctro_cta.cod_refer
        and   movto_tit_acr.ind_trans_acr_abrev = "LQEC"
        AND   movto_tit_acr.LOG_movto_estordo   = NO:

        find b_tit_acr no-lock
           where b_tit_acr.cod_estab      = movto_tit_acr.cod_estab
           and   b_tit_acr.num_id_tit_acr = movto_tit_acr.num_id_tit_acr no-error.

        FIND FIRST b_movto_tit_acr_tres OF b_tit_acr 
             WHERE b_movto_tit_acr_tres.ind_trans_acr_abrev = "TRES" NO-LOCK NO-ERROR.

        IF AVAIL b_movto_tit_acr_tres
        THEN DO:
             FOR EACH b_movto_tit_acr NO-LOCK
                 WHERE b_movto_tit_acr.cod_estab            = b_movto_tit_acr_tres.cod_estab_tit_acr_pai
                   AND b_movto_tit_acr.num_id_movto_tit_acr = b_movto_tit_acr_tres.num_id_movto_tit_acr_pai:

                 FIND tit_acr NO-LOCK 
                     WHERE tit_acr.cod_estab      = b_movto_tit_acr.cod_estab
                       AND tit_acr.num_id_tit_acr = b_movto_tit_acr.num_id_tit_acr 
                       AND tit_acr.num_id_tit_acr <>  b_tit_acr.num_id_tit_acr    NO-ERROR.
             END.
        END.
        ELSE DO:
            find tit_acr no-lock
                where tit_acr.cod_estab      = movto_tit_acr.cod_estab
                and   tit_acr.num_id_tit_acr = movto_tit_acr.num_id_tit_acr no-error.
        END.

        IF  NOT AVAIL tit_acr THEN
            NEXT.

        FIND estabelec NO-LOCK
            WHERE estabelec.cod-estabel = tit_acr.cod_estab NO-ERROR.

        FIND emitente NO-LOCK 
            WHERE emitente.cod-emitente = tit_acr.cdn_cliente NO-ERROR.

        FIND int-emitente
            WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.

        CREATE msg0172R1-tit.
        ASSIGN msg0172r1-tit.CodigoEstabelecimento = int(tit_acr.cod_estab)
               msg0172r1-tit.CNPJEstabelecimento   = estabelec.cgc
               msg0172r1-tit.NumeroSerie           = tit_acr.cod_ser_docto  
               msg0172r1-tit.NumeroTitulo          = tit_acr.cod_tit_acr    
               msg0172r1-tit.NumeroParcela         = tit_acr.cod_parcela 
               msg0172r1-tit.CodigoConta           = int-emitente.cod-guid 
               msg0172r1-tit.CodigoCliente         = int-emitente.cod-emitente
               msg0172r1-tit.NomeConta             = emitente.nome-emit 
               msg0172r1-tit.DataVencimento        = tit_acr.dat_vencto_tit_acr
               msg0172r1-tit.ValorOriginal         = tit_acr.val_origin_tit_acr
               msg0172r1-tit.ValorAbatido          = movto_tit_acr.val_movto_tit_acr    
               msg0172r1-tit.SaldoTitulo           = tit_acr.val_sdo_tit_acr.
    end.

    RETURN "OK".

END.


PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

END PROCEDURE.

