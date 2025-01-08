/********************************************************************************************/
/* Programa...: esp/esb/in/msg0143.p - REGISTRA_PORTFOLIO_REPRESENTANTE                     */
/* Altor......: Rubia Ayabe de Oliveira                                                     */
/* Data.......: 29/10/2014                                                                  */ 
/* Objetivo...: Mensagem Portfolio Representante/Supervisor  (CRM)                          */
/********************************************************************************************/

CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

{esp/esb/in/msg0143.i}
{esp/esb/in/msg9999.i}

DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE DATASET mensagem xml-node-name 'MENSAGEM' FOR cabecalho, conteudo, MSG0143
   DATA-RELATION FOR conteudo, MSG0143 RELATION-FIELDS (idm, idm) NESTED.


DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0143R1, resultado
   DATA-RELATION FOR conteudor, MSG0143R1 RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0143R1, resultado RELATION-FIELDS (idm, idm) NESTED.


CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0143R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0143 NO-ERROR.

CREATE conteudor.
CREATE resultado.
CREATE MSG0143R1.

    
        IF OPSYS = "UNIX" THEN log-manager:write-message("msg0143 -1-").

/* CRIAÄ«O PORTFOLIO REPRESENTANTE */
RUN pi-portfolio.

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

/* PROCEDURES */

PROCEDURE pi-portfolio:
    IF OPSYS = "UNIX" THEN log-manager:write-message("msg0143 -2-").

    EMPTY TEMP-TABLE tt-erro.

    /* REPRESENTANTE */
    FIND FIRST repres NO-LOCK 
        WHERE  repres.cod-rep = MSG0143.CodigoRepresentante NO-ERROR.
    IF NOT AVAIL repres THEN DO:
          RUN pi-erro (INPUT 'C¢digo Representante Inexistente').
          RETURN "NOK".
    END.

    IF OPSYS = "UNIX" THEN log-manager:write-message("msg0143 -3-").

    /* UNIDADE DE NEG‡CIO */
    FIND FIRST unid-negoc NO-LOCK
        WHERE unid-negoc.cod-unid-negoc = MSG0143.CodigoUnidadeNegocio NO-ERROR.
    IF  NOT AVAIL unid-negoc THEN DO:
        RUN pi-erro (INPUT 'Unidade de Neg¢cio inexistente').
        RETURN "NOK".
    END.

    IF OPSYS = "UNIX" THEN log-manager:write-message("msg0143 -4-").

    FIND FIRST int-portfolio-repres-canal
        WHERE int-portfolio-repres-canal.guid-portfolio-repres = MSG0143.CodigoPortfolioRepresentante
        EXCLUSIVE-LOCK NO-ERROR.


    IF OPSYS = "UNIX" THEN log-manager:write-message("msg0143 -5-").

    blk_principal:
    DO TRANSACTION
    ON ERROR UNDO blk_principal,LEAVE blk_principal
    ON STOP  UNDO blk_principal,LEAVE blk_principal:


        IF OPSYS = "UNIX" THEN log-manager:write-message("msg0143 -5-").

        /*************************** CATEGORIA **************************/
        IF  NOT AVAIL int-portfolio-repres-canal THEN DO:
            CREATE int-portfolio-repres-canal.
        END.
            
        /* Est† Dispon°vel para atualizaá∆o */
        ASSIGN int-portfolio-repres-canal.guid-portfolio-repres = MSG0143.CodigoPortfolioRepresentante
               int-portfolio-repres-canal.nome                  = MSG0143.Nome                        
               int-portfolio-repres-canal.cod-representante     = MSG0143.CodigoRepresentante         
               int-portfolio-repres-canal.cod-assistente        = MSG0143.CodigoAssistente            
               int-portfolio-repres-canal.cod-assistente-crm    = MSG0143.CodigoAssistenteCRM         
               int-portfolio-repres-canal.cod-supervisor        = MSG0143.CodigoSupervisor            
               int-portfolio-repres-canal.cod-supervisor-ems    = MSG0143.CodigoSupervisorEMS         
               int-portfolio-repres-canal.cod-unid-neg          = MSG0143.CodigoUnidadeNegocio        
               int-portfolio-repres-canal.cod-segmento          = IF MSG0143.CodigoSegmento = "0000" THEN ? ELSE MSG0143.CodigoSegmento
               int-portfolio-repres-canal.ind-situacao          = MSG0143.Situacao      .

        IF OPSYS = "UNIX" THEN log-manager:write-message("msg0143 -6-").

        RELEASE int-portfolio-repres-canal NO-ERROR.

    END.  /*TRANSAÄ«O */

    RETURN "OK".

END.


PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

END PROCEDURE.

