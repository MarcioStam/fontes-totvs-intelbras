CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

{esp/esb/in/msg0001.i}


DEFINE DATASET mensagem FOR cabecalho, conteudo, msg0001
   DATA-RELATION FOR conteudo, msg0001 RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('longchar', iXML, 'empty', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0001r, EnderecoCEP, resultado
   DATA-RELATION FOR conteudor, msg0001r   RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0001r, EnderecoCEP RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0001r, resultado   RELATION-FIELDS (idm, idm) NESTED.

FIND msg0001.

CREATE cabecalhor.
FIND cabecalho.
BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor .
ASSIGN cabecalhor.CodigoMensagem = 'MSG0001R1'.

CREATE conteudor.
CREATE resultado.
CREATE msg0001r.

FIND cep NO-LOCK
   WHERE cep.cep = INT(msg0001.cep) NO-ERROR.


IF NOT AVAILABLE cep THEN DO:
   RUN pi-erro (INPUT "CEP n∆o cadastrato!").
/*    ASSIGN EnderecoCEP.CEP = msg0001.CEP. */
END.
ELSE DO:           
   CREATE EnderecoCEP.
   ASSIGN resultado.Sucesso       = YES
          EnderecoCEP.CEP         = STRING(cep.cep,"99999999")
          EnderecoCEP.Endereco    = TRIM(TRIM(cep.tipo-log)      + " " + 
                                    (IF cep.preposicao <> "" THEN TRIM(cep.preposicao) + " " ELSE "") +
                                    (IF cep.tit-pat-log <> "" THEN TRIM(cep.tit-pat-log) + " " ELSE "") +
                                    TRIM(cep.nome-log)      + " " + 
                                    /* trim(string(cep.nr-lote-ini))   + " " +  */
                                    TRIM(cep.nome-complto)  + " " + 
                                    TRIM(cep.nr-complto)    + " " +
                                    TRIM(cep.nome-complto2) + " " +  
                                    TRIM(cep.nr-complto2)) + " "
          EnderecoCEP.Bairro     = substring(TRIM(cep.bairro-ini),1,30)
          EnderecoCEP.Cidade     = TRIM(SUBSTRING(cep.localidade,1,35)) + "," + TRIM(cep.uf) + "," + "Brasil":U
          EnderecoCEP.NomeCidade = TRIM(SUBSTRING(cep.localidade,1,35)) 
          EnderecoCEP.Estado     = "Brasil":U + "," + TRIM(cep.uf)
          EnderecoCEP.UF         = TRIM(cep.uf)
          EnderecoCEP.Pais       = "Brasil":U
          EnderecoCEP.CidadeZonaFranca   = CAN-FIND(FIRST cidade-zf NO-LOCK
                                                    WHERE cidade-zf.cidade = EnderecoCEP.Cidade
                                                      AND cidade-zf.estado = EnderecoCEP.UF)
          EnderecoCEP.CodigoIbge       = cep.ibge
          .
END.

IF CAN-FIND (FIRST tt-erro) THEN DO:
    ASSIGN resultado.sucesso    = NO
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".
    FOR EACH tt-erro:
        IF tt-erro.mensagem = ? THEN
            ASSIGN tt-erro.mensagem = "".
        ASSIGN resultado.Mensagem = resultado.Mensagem +  tt-erro.mensagem + ";".
    END.
END.

DATASET mensagemr:WRITE-XML('LONGCHAR', oXML, NO).

return.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.
END PROCEDURE.
