/******************************************************************************************* */
/* Programa...: esp/esb/in/msg0165.p - 5.154	5.165	REGISTRA_BENEFICIO_CANAL             */
/* Altor......: Roger Marcelino Bruhn                                                        */
/* Data.......: 02/02/2016                                                                   */ 
/* Objetivo...: Mensagem enviada quando for criado ou atualizado benef°cio do canal.         */
/******************************************************************************************* */

CREATE WIDGET-POOL.

DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

FUNCTION fn-status RETURNS CHARACTER
  ( INPUT p-status AS CHAR  )  FORWARD.

DEF VAR l-ok AS LOG INIT NO NO-UNDO.

{esp/esb/in/msg0165.i}
{esp/esb/IN/msg9999.i}

DEFINE DATASET mensagem xml-node-name 'MENSAGEM' FOR cabecalho, conteudo, msg0165
   DATA-RELATION FOR conteudo, msg0165    RELATION-FIELDS (idm, idm) NESTED.
   
DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0165R1, resultado
    DATA-RELATION FOR conteudor, MSG0165R1                     RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR MSG0165R1, resultado                     RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0165R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

CREATE conteudor.
CREATE resultado.
CREATE MSG0165R1.

ASSIGN resultado.sucesso    = no.

DEF BUFFER b-int-benef-canal FOR int-benef-canal.


RUN pi-grava-benef.

IF  RETURN-VALUE <> "OK" THEN DO:
    ASSIGN resultado.sucesso    = no
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "(ERP) - ".

    FOR EACH tt-erro
       BREAK BY Mensagem:
       ASSIGN resultado.Mensagem =  resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.
ELSE
    ASSIGN resultado.sucesso = YES.

FIND FIRST msg0165 NO-ERROR.

/*Eliminar handles*/

DATASET mensagemr:WRITE-XML('longchar', oXML, YES).

RETURN.

PROCEDURE pi-grava-benef:

    IF OPSYS = "UNIX" THEN LOG-MANAGER:WRITE-MESSAGE ("inicio pi-grava-beneficio").
    DEF VAR c-mudancas AS CHAR FORMAT "X(100)" NO-UNDO.
    

    FIND FIRST msg0165 NO-ERROR.

    IF  NOT AVAIL msg0165 THEN DO:
        RUN pi-erro (INPUT "N∆o retornaram dados de benef°cio" ).
        RETURN "NOK".
    END.

    IF OPSYS = "UNIX" THEN LOG-MANAGER:WRITE-MESSAGE ("ponto 1").
    FIND int-emitente NO-LOCK
        WHERE int-emitente.cod-guid = msg0165.CodigoConta NO-ERROR.

    IF  NOT AVAIL int-emitente THEN DO:
        RUN pi-erro (INPUT "Emitente n∆o encontrado com o guid: " + msg0165.CodigoConta ).
        RETURN "NOK".
    END.

    IF OPSYS = "UNIX" THEN LOG-MANAGER:WRITE-MESSAGE ("ponto 2").
    blk_principal:
    DO TRANSACTION
    ON ERROR UNDO blk_principal,LEAVE blk_principal
    ON STOP  UNDO blk_principal,LEAVE blk_principal:        

        {esp/esb/in/msg9999.i01     "b-int-benef-canal"
                                    " FIND FIRST b-int-benef-canal 
                                        WHERE b-int-benef-canal.CodigoBeneficioCanal = msg0165.CodigoBeneficioCanal EXCLUSIVE-LOCK NO-WAIT NO-ERROR. "
                                    2  
                                    5  }

                /*************************** CRIAÄ«O GRUPO CLIENTE **************************/
        
        IF OPSYS = "UNIX" THEN LOG-MANAGER:WRITE-MESSAGE ("ponto 3").
        IF  NOT l-reg-disponivel AND NOT l-locked THEN DO:
            CREATE b-int-benef-canal.
            ASSIGN b-int-benef-canal.CodigoBeneficioCanal        = msg0165.CodigoBeneficioCanal
                   b-int-benef-canal.dt-trans                    = DATETIME(TODAY,MTIME)
                   b-int-benef-canal.cod-emitente                = int-emitente.cod-emitente
                   b-int-benef-canal.tipo-beneficio              = msg0165.BeneficioCodigo
                   b-int-benef-canal.NomeBeneficioCanal          = msg0165.NomeBeneficioCanal         
                   b-int-benef-canal.CodigoConta                 = msg0165.CodigoConta                
                   b-int-benef-canal.CodigoBeneficio             = msg0165.CodigoBeneficio            
                   b-int-benef-canal.BeneficioCodigo             = msg0165.BeneficioCodigo            
                   b-int-benef-canal.NomeBeneficio               = msg0165.NomeBeneficio      
                   b-int-benef-canal.CodigoCategoria             = msg0165.CodigoCategoria            
                   b-int-benef-canal.CategoriaCodigo             = msg0165.CategoriaCodigo            
                   b-int-benef-canal.NomeCategoria               = msg0165.NomeCategoria              
                   b-int-benef-canal.CodigoUnidadeNegocio        = msg0165.CodigoUnidadeNegocio       
                   b-int-benef-canal.NomeUnidadeNegocio          = msg0165.NomeUnidadeNegocio         
                   b-int-benef-canal.CodigoStatusBeneficio       = msg0165.CodigoStatusBeneficio      
                   b-int-benef-canal.NomeStatusBeneficio         = msg0165.NomeStatusBeneficio   
                   b-int-benef-canal.CalcularVerba               = msg0165.CalcularVerba               
                   b-int-benef-canal.AcumularVerba               = msg0165.AcumularVerba               
                   b-int-benef-canal.PassivelSolicitacao         = msg0165.PassivelSolicitacao        
                   b-int-benef-canal.PossuiControleContaCorrente = msg0165.PossuiControleContaCorrente
                   b-int-benef-canal.Situacao                    = msg0165.Situacao                   
                   b-int-benef-canal.Proprietario                = msg0165.Proprietario               
                   b-int-benef-canal.TipoProprietario            = msg0165.TipoProprietario.
            IF OPSYS = "UNIX" THEN LOG-MANAGER:WRITE-MESSAGE ("ponto 4").
            
        END.
        ELSE DO:
            IF OPSYS = "UNIX" THEN LOG-MANAGER:WRITE-MESSAGE ("ponto 5").
            IF  l-locked THEN DO:
                
                RUN pi-erro (INPUT "Registro Beneficio Canal em uso por outro Usu†rio. Tente novamente em alguns instantes."). 
                UNDO, RETURN "NOK".
            END.
            ELSE DO:
                /* Est† Dispon°vel para atualizaá∆o */

                IF OPSYS = "UNIX" THEN LOG-MANAGER:WRITE-MESSAGE ("ponto 6").
                RUN pi-compara-mudancas (OUTPUT c-mudancas).
            
                IF OPSYS = "UNIX" THEN LOG-MANAGER:WRITE-MESSAGE ("ponto 7").
                RUN pi-grava-historico.

                IF OPSYS = "UNIX" THEN LOG-MANAGER:WRITE-MESSAGE ("ponto 8").
                ASSIGN b-int-benef-canal.cod-emitente                = int-emitente.cod-emitente
                       b-int-benef-canal.tipo-beneficio              = msg0165.BeneficioCodigo
                       b-int-benef-canal.NomeBeneficioCanal          = msg0165.NomeBeneficioCanal         
                       b-int-benef-canal.CodigoConta                 = msg0165.CodigoConta                
                       b-int-benef-canal.CodigoBeneficio             = msg0165.CodigoBeneficio            
                       b-int-benef-canal.BeneficioCodigo             = msg0165.BeneficioCodigo            
                       b-int-benef-canal.NomeBeneficio               = msg0165.NomeBeneficio      
                       b-int-benef-canal.CodigoCategoria             = msg0165.CodigoCategoria            
                       b-int-benef-canal.CategoriaCodigo             = msg0165.CategoriaCodigo            
                       b-int-benef-canal.NomeCategoria               = msg0165.NomeCategoria              
                       b-int-benef-canal.CodigoUnidadeNegocio        = msg0165.CodigoUnidadeNegocio       
                       b-int-benef-canal.NomeUnidadeNegocio          = msg0165.NomeUnidadeNegocio         
                       b-int-benef-canal.CodigoStatusBeneficio       = msg0165.CodigoStatusBeneficio      
                       b-int-benef-canal.NomeStatusBeneficio         = msg0165.NomeStatusBeneficio   
                       b-int-benef-canal.CalcularVerba               = msg0165.CalcularVerba               
                       b-int-benef-canal.AcumularVerba               = msg0165.AcumularVerba               
                       b-int-benef-canal.PassivelSolicitacao         = msg0165.PassivelSolicitacao        
                       b-int-benef-canal.PossuiControleContaCorrente = msg0165.PossuiControleContaCorrente
                       b-int-benef-canal.Situacao                    = msg0165.Situacao                   
                       b-int-benef-canal.Proprietario                = msg0165.Proprietario               
                       b-int-benef-canal.TipoProprietario            = msg0165.TipoProprietario.

                ASSIGN b-int-benef-canal.dt-trans   = DATETIME(TODAY,MTIME)
                       b-int-benef-canal.alteracoes = c-mudancas.
                IF OPSYS = "UNIX" THEN LOG-MANAGER:WRITE-MESSAGE ("ponto 9: " + STRING(c-mudancas)).
            END.
        END.

        IF OPSYS = "UNIX" THEN LOG-MANAGER:WRITE-MESSAGE ("ponto 10").
        RELEASE b-int-benef-canal NO-ERROR.
        IF OPSYS = "UNIX" THEN LOG-MANAGER:WRITE-MESSAGE ("ponto 11").

    END. /* TRANZAÄ«O */

    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

END PROCEDURE.


PROCEDURE pi-grava-historico:

    IF OPSYS = "UNIX" THEN LOG-MANAGER:WRITE-MESSAGE ("ponto 7.5").
    CREATE int-benef-canal-hist.
    ASSIGN int-benef-canal-hist.CodigoBeneficioCanal        = b-int-benef-canal.CodigoBeneficioCanal        
           int-benef-canal-hist.dt-trans                    = b-int-benef-canal.dt-trans                    
           int-benef-canal-hist.cod-emitente                = b-int-benef-canal.cod-emitente                
           int-benef-canal-hist.tipo-beneficio              = b-int-benef-canal.tipo-beneficio              
           int-benef-canal-hist.NomeBeneficioCanal          = b-int-benef-canal.NomeBeneficioCanal          
           int-benef-canal-hist.CodigoConta                 = b-int-benef-canal.CodigoConta                 
           int-benef-canal-hist.CodigoBeneficio             = b-int-benef-canal.CodigoBeneficio             
           int-benef-canal-hist.BeneficioCodigo             = b-int-benef-canal.BeneficioCodigo             
           int-benef-canal-hist.NomeBeneficio               = b-int-benef-canal.NomeBeneficio               
           int-benef-canal-hist.CodigoCategoria             = b-int-benef-canal.CodigoCategoria             
           int-benef-canal-hist.CategoriaCodigo             = b-int-benef-canal.CategoriaCodigo             
           int-benef-canal-hist.NomeCategoria               = b-int-benef-canal.NomeCategoria               
           int-benef-canal-hist.CodigoUnidadeNegocio        = b-int-benef-canal.CodigoUnidadeNegocio        
           int-benef-canal-hist.NomeUnidadeNegocio          = b-int-benef-canal.NomeUnidadeNegocio          
           int-benef-canal-hist.CodigoStatusBeneficio       = b-int-benef-canal.CodigoStatusBeneficio       
           int-benef-canal-hist.NomeStatusBeneficio         = b-int-benef-canal.NomeStatusBeneficio         
           int-benef-canal-hist.CalcularVerba               = b-int-benef-canal.CalcularVerba               
           int-benef-canal-hist.AcumularVerba               = b-int-benef-canal.AcumularVerba               
           int-benef-canal-hist.PassivelSolicitacao         = b-int-benef-canal.PassivelSolicitacao         
           int-benef-canal-hist.PossuiControleContaCorrente = b-int-benef-canal.PossuiControleContaCorrente 
           int-benef-canal-hist.Situacao                    = b-int-benef-canal.Situacao                    
           int-benef-canal-hist.Proprietario                = b-int-benef-canal.Proprietario                
           int-benef-canal-hist.TipoProprietario            = b-int-benef-canal.TipoProprietario
           int-benef-canal-hist.alteracoes                  = b-int-benef-canal.alteracoes.            
    IF OPSYS = "UNIX" THEN LOG-MANAGER:WRITE-MESSAGE ("ponto 7.6").
           
END.


PROCEDURE pi-compara-mudancas:

    DEF OUTPUT PARAM p-mudancas AS CHAR  NO-UNDO.

    IF OPSYS = "UNIX" THEN LOG-MANAGER:WRITE-MESSAGE ("ponto 6.5").
    IF  b-int-benef-canal.cod-emitente                <> int-emitente.cod-emitente           THEN                                            
        ASSIGN p-mudancas = p-mudancas + "Alterado <cod-emitente> de " + STRING(b-int-benef-canal.cod-emitente)                               + "  para  " + STRING(int-emitente.cod-emitente) + CHR(10).
                                                                                                                                              
    IF  b-int-benef-canal.tipo-beneficio              <> msg0165.BeneficioCodigo             THEN                                             
        ASSIGN p-mudancas = p-mudancas + "Alterado <tipo-beneficio> de " + STRING(b-int-benef-canal.tipo-beneficio)                           + "  para  " + STRING(msg0165.BeneficioCodigo) + CHR(10).
                                                                                                                                              
    IF  b-int-benef-canal.NomeBeneficioCanal          <> msg0165.NomeBeneficioCanal          THEN                                             
        ASSIGN p-mudancas = p-mudancas + "Alterado <tipo-beneficio> de " + STRING(b-int-benef-canal.NomeBeneficioCanal)                       + "  para  " + STRING(msg0165.NomeBeneficioCanal) + CHR(10).
                                                                                                                                              
    IF  b-int-benef-canal.CodigoConta                 <> msg0165.CodigoConta                 THEN                                             
        ASSIGN p-mudancas = p-mudancas + "Alterado <CodigoConta> de " + STRING(b-int-benef-canal.CodigoConta) + "  para  "                      + STRING(msg0165.CodigoConta) + CHR(10).
                                                                                                                                              
    IF  b-int-benef-canal.CodigoBeneficio             <> msg0165.CodigoBeneficio             THEN                                             
        ASSIGN p-mudancas = p-mudancas + "Alterado <CodigoBeneficio> de " + STRING(b-int-benef-canal.CodigoBeneficio)                         + "  para  " + STRING(msg0165.CodigoBeneficio) + CHR(10).
                                                                                                                                              
    IF  b-int-benef-canal.BeneficioCodigo             <> msg0165.BeneficioCodigo             THEN                                             
        ASSIGN p-mudancas = p-mudancas + "Alterado <BeneficioCodigo> de " + STRING(b-int-benef-canal.BeneficioCodigo)                         + "  para  " + STRING(msg0165.BeneficioCodigo) + CHR(10).
                                                                                                                                              
    IF  b-int-benef-canal.NomeBeneficio               <> msg0165.NomeBeneficio               THEN                                             
        ASSIGN p-mudancas = p-mudancas + "Alterado <NomeBeneficio> de " + STRING(b-int-benef-canal.NomeBeneficio)                             + "  para  " + STRING(msg0165.NomeBeneficio) + CHR(10).
                                                                                                                                              
    IF  b-int-benef-canal.CodigoCategoria             <> msg0165.CodigoCategoria             THEN                                             
        ASSIGN p-mudancas = p-mudancas + "Alterado <CodigoCategoria> de " + STRING(b-int-benef-canal.CodigoCategoria)                         + "  para  " + STRING(msg0165.CodigoCategoria) + CHR(10).
                                                                                                                                              
    IF  b-int-benef-canal.CategoriaCodigo             <> msg0165.CategoriaCodigo             THEN                                             
        ASSIGN p-mudancas = p-mudancas + "Alterado <CategoriaCodigo> de " + STRING(b-int-benef-canal.CategoriaCodigo)                         + "  para  " + STRING(msg0165.CategoriaCodigo) + CHR(10).
                                                                                                                                              
    IF  b-int-benef-canal.NomeCategoria               <> msg0165.NomeCategoria               THEN                                             
        ASSIGN p-mudancas = p-mudancas + "Alterado <NomeCategoria> de " + STRING(b-int-benef-canal.NomeCategoria)                             + "  para  " + STRING(msg0165.NomeCategoria) + CHR(10).
                                                                                                                                              
    IF  b-int-benef-canal.CodigoUnidadeNegocio        <> msg0165.CodigoUnidadeNegocio        THEN                                             
        ASSIGN p-mudancas = p-mudancas + "Alterado <CodigoUnidadeNegocio> de " + STRING(b-int-benef-canal.CodigoUnidadeNegocio)               + "  para  " + STRING(msg0165.CodigoUnidadeNegocio) + CHR(10).
                                                                                                                                              
    IF  b-int-benef-canal.NomeUnidadeNegocio          <> msg0165.NomeUnidadeNegocio          THEN                                             
        ASSIGN p-mudancas = p-mudancas + "Alterado <NomeUnidadeNegocio> de " + STRING(b-int-benef-canal.NomeUnidadeNegocio)                   + "  para  " + STRING(msg0165.NomeUnidadeNegocio) + CHR(10).
                                                                                                                                              
    IF  b-int-benef-canal.CodigoStatusBeneficio       <> msg0165.CodigoStatusBeneficio       THEN                                             
        ASSIGN p-mudancas = p-mudancas + "Alterado <CodigoStatusBeneficio> de " + FN-STATUS(b-int-benef-canal.CodigoStatusBeneficio)          + "  para  " + FN-STATUS(msg0165.CodigoStatusBeneficio) + CHR(10).
                                                                                                                                              
    IF  b-int-benef-canal.NomeStatusBeneficio         <> msg0165.NomeStatusBeneficio         THEN                                             
        ASSIGN p-mudancas = p-mudancas + "Alterado <NomeStatusBeneficio> de " + STRING(b-int-benef-canal.NomeStatusBeneficio)                 + "  para  " + STRING(msg0165.NomeStatusBeneficio) + CHR(10).
                                                                                                                                              
    IF  b-int-benef-canal.CalcularVerba               <> msg0165.CalcularVerba               THEN                                             
        ASSIGN p-mudancas = p-mudancas + "Alterado <CalcularVerba> de " + STRING(b-int-benef-canal.CalcularVerba)                             + "  para  " + STRING(msg0165.CalcularVerba) + CHR(10).
                                                                                                                                              
    IF  b-int-benef-canal.AcumularVerba               <> msg0165.AcumularVerba               THEN                                             
        ASSIGN p-mudancas = p-mudancas + "Alterado <AcumularVerba> de " + STRING(b-int-benef-canal.AcumularVerba)                             + "  para  " + STRING(msg0165.AcumularVerba) + CHR(10).
                                                                                                                                              
    IF  b-int-benef-canal.PassivelSolicitacao         <> msg0165.PassivelSolicitacao         THEN                                             
        ASSIGN p-mudancas = p-mudancas + "Alterado <PassivelSolicitacao> de " + STRING(b-int-benef-canal.PassivelSolicitacao)                 + "  para  " + STRING(msg0165.PassivelSolicitacao) + CHR(10).
                                                                                                                                             
    IF  b-int-benef-canal.PossuiControleContaCorrente <> msg0165.PossuiControleContaCorrente THEN
        ASSIGN p-mudancas = p-mudancas + "Alterado <PossuiControleContaCorrente> de " + STRING(b-int-benef-canal.PossuiControleContaCorrente) + "  para  " + STRING(msg0165.PossuiControleContaCorrente) + CHR(10).

    IF  b-int-benef-canal.Situacao                    <> msg0165.Situacao                    THEN
        ASSIGN p-mudancas = p-mudancas + "Alterado <Situacao> de " + STRING(b-int-benef-canal.Situacao)                                        + "  para  " + STRING(msg0165.Situacao) + CHR(10).
                                                                                                                                            
    IF  b-int-benef-canal.Proprietario                <> msg0165.Proprietario                THEN                                           
        ASSIGN p-mudancas = p-mudancas + "Alterado <Proprietario> de " + STRING(b-int-benef-canal.Proprietario)                                + "  para  " + STRING(msg0165.Proprietario) + CHR(10).
                                                                                                                                            
    IF  b-int-benef-canal.TipoProprietario            <> msg0165.TipoProprietario            THEN                                           
        ASSIGN p-mudancas = p-mudancas + "Alterado <TipoProprietario> de " + STRING(b-int-benef-canal.TipoProprietario)                        + "  para  " + STRING(msg0165.TipoProprietario) + CHR(10).

    IF OPSYS = "UNIX" THEN LOG-MANAGER:WRITE-MESSAGE ("ponto 6.6").
END.                                                                                         

FUNCTION fn-status RETURNS CHARACTER
  ( INPUT p-status AS CHAR  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  CASE p-status:
      WHEN '35fc4a26-75ed-e311-9407-00155d013d38' THEN RETURN "ATIVO".
      WHEN 'e1654a30-75ed-e311-9407-00155d013d38' THEN RETURN "SUSPENSO".
      WHEN 'e0654a30-75ed-e311-9407-00155d013d38' THEN RETURN "BLOQUEADO".
      OTHERWISE RETURN "".
  END CASE.

END FUNCTION.
