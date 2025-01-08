/********************************************************************************************/
/* Programa...: esp/esb/in/msg0191.p - REGISTRA_CLASSIFICA€ÇO CANAL                         */
/* Altor......: Roger Marcelino Bruhn                                                       */
/* Data.......: 02/04/2014                                                                  */ 
/* ObjetiVo...: Mensagem enviada quando houver um cadastro ou atualiza‡Æo                   */
/*              de Classifica‡Æo de Canal.                                                  */
/********************************************************************************************/

CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/*
DEF VAR ixml AS LONGCHAR NO-UNDO.
DEF VAR oxml AS LONGCHAR NO-UNDO.

ixml = '<?xml version="1.0" encoding="utf-8"?>
<MENSAGEM>
  <CABECALHO>
    <IdentidadeEmissor>DBFC273E-4811-40C4-8A4E-1629731ADD9A</IdentidadeEmissor>
    <NumeroOperacao>jaime / 121395850001</NumeroOperacao>
    <CodigoMensagem>MSG0191</CodigoMensagem>
  </CABECALHO>
  <CONTEUDO>
    <MSG0191>
      <NomeAbreviado>121395850001</NomeAbreviado>
      <CodigoEntrega>jaime</CodigoEntrega>
      <CodigoCliente>218546</CodigoCliente>
      <Situacao>0</Situacao>
      <CpfCnpjCodEstrangeiro>45565023000181</CpfCnpjCodEstrangeiro>
      <InscricaoEstadual>isento</InscricaoEstadual>
      <Email>yyyyy@yyyyyyyyyy</Email>
      <TipoEndereco>4</TipoEndereco>
      <NomeEndereco>RUA PREFEITO JOSE KOERING, sn - asga</NomeEndereco>
      <CEP>88140000</CEP>
      <Numero>555</Numero>
      <Bairro>CENTRO</Bairro>
      <NomeCidade>SANTO AMARO DA IMPERATRIZ</NomeCidade>
      <Cidade>SANTO AMARO DA IMPERATRIZ,SC,Brasil</Cidade>
      <UF>SC</UF>
      <Estado>Brasil,SC</Estado>
      <NomePais>Brasil</NomePais>
      <Pais>Brasil</Pais>
      <Observacao>teste</Observacao>
    </MSG0191>
  </CONTEUDO>
</MENSAGEM>'.
*/

{esp/esb/in/msg0191.i}
{esp/esb/in/msg9999.i}
DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0191
   DATA-RELATION FOR conteudo, msg0191 RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0191r, resultado
   DATA-RELATION FOR conteudor, msg0191r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0191r, resultado RELATION-FIELDS (idm, idm) NESTED.    

DEF BUFFER b-loc-entr FOR loc-entr.    

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0191R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST msg0191 NO-ERROR.

CREATE conteudor.
CREATE resultado.
CREATE msg0191r.

DISABLE TRIGGERS FOR LOAD OF loc-entr .

/* CRIA€ÇO DA CLASSIFICA€ÇO */
RUN pi-atualiza.

IF  RETURN-VALUE = "NOK" THEN DO:
    ASSIGN resultado.sucesso    = no
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "ERP - ".
    FOR EACH tt-erro:
        IF tt-erro.mensagem = ? THEN
            ASSIGN tt-erro.mensagem = "".
        ASSIGN resultado.Mensagem = resultado.Mensagem +  tt-erro.mensagem + ";".
    END.

END.

IF resultado.Mensagem = "" THEN
    ASSIGN resultado.Mensagem = ?.

DATASET mensagemr:WRITE-XML('longchar', oXML, NO).


define variable hDoc    as handle   no-undo.
create x-document hDoc.
hDoc:LOAD("longchar", iXML, NO).
hDoc:SAVE("file","C:/temp/iXML" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").


create x-document hDoc.
hDoc:LOAD("longchar", oXML, NO).
hDoc:SAVE("file","C:/temp/oXML" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml").


RETURN.

PROCEDURE pi-atualiza:

    EMPTY TEMP-TABLE tt-erro.
    
    IF  NOT CAN-FIND (FIRST mgcad.pais
                        WHERE mgcad.pais.nome-pais = msg0191.pais) THEN DO:
        RUN pi-erro (INPUT "Pais informado nÆo est  cadastrado").
        RETURN "NOK".
    END.

    IF  NOT CAN-FIND (FIRST unid-feder
                        WHERE unid-feder.estado = msg0191.uf
                          AND unid-feder.pais = MSG0191.NomePais ) THEN DO:
        RUN pi-erro (INPUT "Estado informado nÆo est  cadastrado").
        RETURN "NOK".
    END.

    IF  NOT CAN-FIND (FIRST mgcad.cidade
                        WHERE mgcad.cidade.estado = msg0191.uf
                          AND mgcad.cidade.pais   = msg0191.pais
                          AND mgcad.cidade.cidade = msg0191.NomeCidade) THEN DO:
        RUN pi-erro (INPUT "Cidade informada nÆo est  cadastrado").
        RETURN "NOK".
    END.

    FIND emitente NO-LOCK
        WHERE emitente.nome-abrev = msg0191.NomeAbreviado NO-ERROR.
    IF  NOT AVAIL emitente THEN DO:
        RUN pi-erro (INPUT "Emitente informado nÆo est  cadastrado").
        RETURN "NOK".
    END.

/*     IF  emitente.natureza = 1                                       */
/*     AND length(trim(MSG0191.CpfCnpjCodEstrangeiro)) >= 11 THEN DO:  */
/*         RUN pi-erro (INPUT "CPF inv lido.").                        */
/*         RETURN "NOK".                                               */
/*     END.                                                            */
/*                                                                     */
/*     IF  emitente.natureza <> 1                                      */
/*     AND length(trim(MSG0191.CpfCnpjCodEstrangeiro)) <= 11 THEN DO:  */
/*         RUN pi-erro (INPUT "CNPJ inv lido").                        */
/*         RETURN "NOK".                                               */
/*     END.                                                            */

    blk_principal:
    DO TRANSACTION
    ON ERROR UNDO blk_principal,LEAVE blk_principal
    ON STOP  UNDO blk_principal,LEAVE blk_principal:        

        {esp/esb/in/msg9999.i01     "b-loc-entr"
                                    " FIND FIRST b-loc-entr 
                                        WHERE b-loc-entr.nome-abrev  = msg0191.NomeAbreviado
                                          AND b-loc-entr.cod-entrega = msg0191.CodigoEntrega EXCLUSIVE-LOCK NO-WAIT NO-ERROR. "
                                    2  
                                    5  }

                /*************************** CRIA€ÇO GRUPO CLIENTE **************************/
        
        IF  NOT l-reg-disponivel AND NOT l-locked THEN DO:
            CREATE b-loc-entr.
            ASSIGN b-loc-entr.nome-abrev  = emitente.nome-abrev
                   b-loc-entr.cod-entrega = msg0191.CodigoEntrega.
        END.
        ELSE DO:
            IF  l-locked THEN DO:
                RUN pi-erro (INPUT "Registro Local de Entrega em uso por outro Usu rio. Tente novamente em alguns instantes."). 
                UNDO, RETURN "NOK".
            END.
            ELSE DO:
                IF  msg0191.situacao = 1 THEN DO: 
                    IF  msg0191.CodigoEntrega = "Padrao" THEN DO:
                        RUN pi-erro (INPUT "C¢digo de Entrega [Padrao] nÆo pode ser eliminado."). 
                        UNDO, RETURN "NOK".
                    END.

                    LOG-MANAGER:WRITE-MESSAGE ("msg0191.situacao: " + STRING(msg0191.situacao)).
                    /* Deleta o Registro */
                    DELETE b-loc-entr.


                END.
            END.
        END.
        
        /* Atualiza‡Æo */
        IF   msg0191.situacao = 0  THEN DO: 
             ASSIGN b-loc-entr.cod-tax          =  MSG0191.CodigoTaxa        
                    b-loc-entr.cod-tip-ent      =  MSG0191.CodigoTipoEntrega 
                    b-loc-entr.cgc              =  MSG0191.CpfCnpjCodEstrangeiro              
                    b-loc-entr.ins-estadual     =  MSG0191.InscricaoEstadual 
                    b-loc-entr.e-mail           =  MSG0191.Email             
                    b-loc-entr.caixa-postal     =  MSG0191.CaixaPostal       
                    b-loc-entr.bairro           =  MSG0191.Bairro      
                    b-loc-entr.cidade           =  MSG0191.NomeCidade  
                    b-loc-entr.estado           =  MSG0191.UF          
                    b-loc-entr.pais             =  MSG0191.NomePais    
                    b-loc-entr.obs-entrega      =  MSG0191.Observacao.  

            RUN pi-monta-endereco (INPUT-OUTPUT msg0191.NomeEndereco,
                                   INPUT        trim(string(msg0191.Numero)),
                                   INPUT        TRIM       (msg0191.Complemento)).

            ASSIGN b-loc-entr.cep      = REPLACE(msg0191.cep, "-":U, "")
                   b-loc-entr.endereco = msg0191.NomeEndereco.

            FIND FIRST int-loc-entr EXCLUSIVE-LOCK 
                 WHERE int-loc-entr.nome-abrev  = b-loc-entr.nome-abrev
                   AND int-loc-entr.cod-entrega = b-loc-entr.cod-entrega NO-ERROR.

            IF NOT AVAILABLE int-loc-entr THEN DO:
                CREATE int-loc-entr.
                ASSIGN int-loc-entr.nome-abrev  = b-loc-entr.nome-abrev
                       int-loc-entr.cod-entrega = b-loc-entr.cod-entrega.
            END.

            ASSIGN int-loc-entr.endereco-completo = msg0191.NomeEndereco
                   int-loc-entr.logradouro  = trim(msg0191.NomeEndereco) 
                   int-loc-entr.numero      = trim(string(msg0191.Numero))
                   int-loc-entr.complemento = trim(msg0191.Complemento).

            FIND CURRENT int-loc-entr NO-LOCK NO-ERROR.
            RELEASE int-loc-entr.

            FIND CURRENT b-loc-entr   NO-LOCK NO-ERROR.

        END.

        RELEASE b-loc-entr NO-ERROR.

    END. /* TRANZA€ÇO */

    RETURN "OK".

END.


PROCEDURE pi-monta-endereco:

    DEF INPUT-OUTPUT PARAM p-end  AS CHAR NO-UNDO.
    DEF INPUT        PARAM p-num  AS CHAR NO-UNDO.
    DEF INPUT        PARAM p-comp AS CHAR.

    DEF VAR i AS INTEGER NO-UNDO.
    
    DO  i = 1 TO NUM-ENTRIES(p-end):
    
        p-end = ENTRY(1,p-end, ",").
        LEAVE.
    
    END.
    
    ASSIGN p-end = trim(p-end) + ", " + trim(string(p-num)) + " - " + trim(p-comp).
    
END.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

END PROCEDURE.
