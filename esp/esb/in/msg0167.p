/******************************************************************************************* */
/* Programa...: esp/esb/in/msg0167.p - 5.167	REGISTRA_PARAMETRO_GLOBAL                    */
/* Altor......: Roger Marcelino Bruhn                                                        */
/* Data.......: 02/02/2016                                                                   */ 
/* Objetivo...: Mensagem enviada quando for criado ou atualizado benef¡cio do canal.         */
/******************************************************************************************* */

CREATE WIDGET-POOL.

DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

{esp/esb/in/msg0167.i}
{esp/esb/IN/msg9999.i}

DEFINE DATASET mensagem xml-node-name 'MENSAGEM' FOR cabecalho, conteudo, msg0167
   DATA-RELATION FOR conteudo, msg0167    RELATION-FIELDS (idm, idm) NESTED.
   
DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0167R1, resultado
    DATA-RELATION FOR conteudor, MSG0167R1                     RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR MSG0167R1, resultado                     RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0167R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

CREATE conteudor.
CREATE resultado.
CREATE MSG0167R1.

ASSIGN resultado.sucesso    = no.

DEF BUFFER b-int-benef-canal-perc FOR int-benef-canal-perc.

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

FIND FIRST msg0167 NO-ERROR.

/*Eliminar handles*/

DATASET mensagemr:WRITE-XML('longchar', oXML, YES).

RETURN.

PROCEDURE pi-grava-benef:

    DEF VAR c-mudancas AS CHAR FORMAT "X(100)" NO-UNDO.
    
    FIND FIRST msg0167 NO-ERROR.

    IF  NOT AVAIL msg0167 THEN DO:
        RUN pi-erro (INPUT "NÆo retornaram dados de benef¡cio" ).
        RETURN "NOK".
    END.

    blk_principal:
    DO TRANSACTION
    ON ERROR UNDO blk_principal,LEAVE blk_principal
    ON STOP  UNDO blk_principal,LEAVE blk_principal:        

        {esp/esb/in/msg9999.i01     "b-int-benef-canal-perc"
                                    " FIND FIRST b-int-benef-canal-perc 
                                        WHERE b-int-benef-canal-perc.CodigoParametroGlobal = msg0167.CodigoParametroGlobal EXCLUSIVE-LOCK NO-WAIT NO-ERROR. "
                                    2  
                                    5  }

                /*************************** CRIA€ÇO GRUPO CLIENTE **************************/
        
        IF  NOT l-reg-disponivel AND NOT l-locked THEN DO:
            CREATE b-int-benef-canal-perc.
            ASSIGN b-int-benef-canal-perc.CodigoParametroGlobal = msg0167.CodigoParametroGlobal
                   b-int-benef-canal-perc.dt-trans              = DATETIME(TODAY,MTIME)
                   b-int-benef-canal-perc.NomeParametroGlobal   = msg0167.NomeParametroGlobal  
                   b-int-benef-canal-perc.TipoParametroGlobal   = msg0167.TipoParametroGlobal  
                   b-int-benef-canal-perc.CodigoClassificacao   = msg0167.CodigoClassificacao  
                   b-int-benef-canal-perc.CodigoCompromisso     = msg0167.CodigoCompromisso           
                   b-int-benef-canal-perc.CodigoCategoria       = msg0167.CodigoCategoria             
                   b-int-benef-canal-perc.CategoriaCodigo       = msg0167.CategoriaCodigo             
                   b-int-benef-canal-perc.CodigoBeneficio       = msg0167.CodigoBeneficio             
                   b-int-benef-canal-perc.BeneficioCodigo       = msg0167.BeneficioCodigo      
                   b-int-benef-canal-perc.CodigoNivelPosVenda   = msg0167.CodigoNivelPosVenda         
                   b-int-benef-canal-perc.CodigoUnidadeNegocio  = msg0167.CodigoUnidadeNegocio        
                   b-int-benef-canal-perc.TipoDado              = msg0167.TipoDado                    
                   b-int-benef-canal-perc.ValorParametroGlobal  = msg0167.ValorParametroGlobal        
                   b-int-benef-canal-perc.Situacao              = msg0167.Situacao                    
                   b-int-benef-canal-perc.Proprietario          = msg0167.Proprietario                
                   b-int-benef-canal-perc.TipoProprietario      = msg0167.TipoProprietario.     

        END.
        ELSE DO:
            IF  l-locked THEN DO:
                RUN pi-erro (INPUT "Registro Beneficio Canal em uso por outro Usu rio. Tente novamente em alguns instantes."). 
                UNDO, RETURN "NOK".
            END.
            ELSE DO:
                /* Est  Dispon¡vel para atualiza‡Æo */

                RUN pi-compara-mudancas (OUTPUT c-mudancas).
                RUN pi-grava-historico.
            
                ASSIGN b-int-benef-canal-perc.NomeParametroGlobal    = msg0167.NomeParametroGlobal         
                       b-int-benef-canal-perc.TipoParametroGlobal    = msg0167.TipoParametroGlobal         
                       b-int-benef-canal-perc.CodigoClassificacao    = msg0167.CodigoClassificacao         
                       b-int-benef-canal-perc.CodigoCompromisso      = msg0167.CodigoCompromisso           
                       b-int-benef-canal-perc.CodigoCategoria        = msg0167.CodigoCategoria       
                       b-int-benef-canal-perc.CategoriaCodigo        = msg0167.CategoriaCodigo             
                       b-int-benef-canal-perc.CodigoBeneficio        = msg0167.CodigoBeneficio             
                       b-int-benef-canal-perc.BeneficioCodigo        = msg0167.BeneficioCodigo             
                       b-int-benef-canal-perc.CodigoNivelPosVenda    = msg0167.CodigoNivelPosVenda         
                       b-int-benef-canal-perc.CodigoUnidadeNegocio   = msg0167.CodigoUnidadeNegocio        
                       b-int-benef-canal-perc.TipoDado               = msg0167.TipoDado                    
                       b-int-benef-canal-perc.ValorParametroGlobal   = msg0167.ValorParametroGlobal   
                       b-int-benef-canal-perc.Situacao               = msg0167.Situacao                     
                       b-int-benef-canal-perc.Proprietario           = msg0167.Proprietario                 
                       b-int-benef-canal-perc.TipoProprietario       = msg0167.TipoProprietario.            
                
                ASSIGN b-int-benef-canal-perc.dt-trans   = DATETIME(TODAY,MTIME)
                       b-int-benef-canal-perc.alteracoes = c-mudancas.
                

            END.
        END.

        RELEASE b-int-benef-canal-perc NO-ERROR.

    END. /* TRANZA€ÇO */

    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

END PROCEDURE.


PROCEDURE pi-grava-historico:

    CREATE int-benef-canal-perc-hist.
    ASSIGN int-benef-canal-perc-hist.CodigoParametroGlobal  = b-int-benef-canal-perc.CodigoParametroGlobal 
           int-benef-canal-perc-hist.dt-trans               = b-int-benef-canal-perc.dt-trans                
           int-benef-canal-perc-hist.NomeParametroGlobal    = b-int-benef-canal-perc.NomeParametroGlobal        
           int-benef-canal-perc-hist.TipoParametroGlobal    = b-int-benef-canal-perc.TipoParametroGlobal        
           int-benef-canal-perc-hist.CodigoClassificacao    = b-int-benef-canal-perc.CodigoClassificacao        
           int-benef-canal-perc-hist.CodigoCompromisso      = b-int-benef-canal-perc.CodigoCompromisso          
           int-benef-canal-perc-hist.CodigoCategoria        = b-int-benef-canal-perc.CodigoCategoria            
           int-benef-canal-perc-hist.CategoriaCodigo        = b-int-benef-canal-perc.CategoriaCodigo            
           int-benef-canal-perc-hist.CodigoBeneficio        = b-int-benef-canal-perc.CodigoBeneficio            
           int-benef-canal-perc-hist.BeneficioCodigo        = b-int-benef-canal-perc.BeneficioCodigo            
           int-benef-canal-perc-hist.CodigoNivelPosVenda    = b-int-benef-canal-perc.CodigoNivelPosVenda        
           int-benef-canal-perc-hist.CodigoUnidadeNegocio   = b-int-benef-canal-perc.CodigoUnidadeNegocio       
           int-benef-canal-perc-hist.TipoDado               = b-int-benef-canal-perc.TipoDado                   
           int-benef-canal-perc-hist.ValorParametroGlobal   = b-int-benef-canal-perc.ValorParametroGlobal       
           int-benef-canal-perc-hist.Situacao               = b-int-benef-canal-perc.Situacao                   
           int-benef-canal-perc-hist.Proprietario           = b-int-benef-canal-perc.Proprietario               
           int-benef-canal-perc-hist.TipoProprietario       = b-int-benef-canal-perc.TipoProprietario           
           int-benef-canal-perc-hist.alteracoes             = b-int-benef-canal-perc.alteracoes.

END.


PROCEDURE pi-compara-mudancas:

    DEF OUTPUT PARAM p-mudancas AS CHAR  NO-UNDO.

    IF  b-int-benef-canal-perc.CodigoParametroGlobal <> msg0167.CodigoParametroGlobal  THEN                                             
        ASSIGN p-mudancas = p-mudancas + "Alterado <CodigoParametroGlobal> de " + STRING(b-int-benef-canal-perc.CodigoParametroGlobal)  + "  para  " + STRING(msg0167.CodigoParametroGlobal) + CHR(10).
                                                                                                                                              
    IF  b-int-benef-canal-perc.NomeParametroGlobal <> msg0167.NomeParametroGlobal THEN                                             
        ASSIGN p-mudancas = p-mudancas + "Alterado <NomeParametroGlobal> de " + STRING(b-int-benef-canal-perc.NomeParametroGlobal)      + "  para  " + STRING(msg0167.NomeParametroGlobal) + CHR(10).
                                                                                                                                              
    IF  b-int-benef-canal-perc.TipoParametroGlobal <> msg0167.TipoParametroGlobal THEN                                             
        ASSIGN p-mudancas = p-mudancas + "Alterado <TipoParametroGlobal> de " + STRING(b-int-benef-canal-perc.TipoParametroGlobal)      + "  para  " + STRING(msg0167.TipoParametroGlobal) + CHR(10).
                                                                                                                                              
    IF  b-int-benef-canal-perc.CodigoClassificacao <> msg0167.CodigoClassificacao THEN                                             
        ASSIGN p-mudancas = p-mudancas + "Alterado <CodigoClassificacao> de " + STRING(b-int-benef-canal-perc.CodigoClassificacao)      + "  para  " + STRING(msg0167.CodigoClassificacao) + CHR(10).
                                                                                                                                              
    IF  b-int-benef-canal-perc.CodigoCompromisso <> msg0167.CodigoCompromisso THEN                                             
        ASSIGN p-mudancas = p-mudancas + "Alterado <CodigoCompromisso> de " + STRING(b-int-benef-canal-perc.CodigoCompromisso)          + "  para  " + STRING(msg0167.CodigoCompromisso) + CHR(10).
                                                                                                                                              
    IF  b-int-benef-canal-perc.CodigoCategoria  <> msg0167.CodigoCategoria  THEN                                             
        ASSIGN p-mudancas = p-mudancas + "Alterado <CodigoCategoria> de " + STRING(b-int-benef-canal-perc.CodigoCategoria)              + "  para  " + STRING(msg0167.CodigoCategoria) + CHR(10).
                                                                                                                                              
    IF  b-int-benef-canal-perc.CategoriaCodigo <> msg0167.CategoriaCodigo THEN                                             
        ASSIGN p-mudancas = p-mudancas + "Alterado <CategoriaCodigo> de " + STRING(b-int-benef-canal-perc.CategoriaCodigo)              + "  para  " + STRING(msg0167.CategoriaCodigo) + CHR(10).
                                                                                                                                              
    IF  b-int-benef-canal-perc.CodigoBeneficio <> msg0167.CodigoBeneficio THEN                                             
        ASSIGN p-mudancas = p-mudancas + "Alterado <CodigoBeneficio> de " + STRING(b-int-benef-canal-perc.CodigoBeneficio)              + "  para  " + STRING(msg0167.CodigoBeneficio) + CHR(10).
                                                                                                                                              
    IF  b-int-benef-canal-perc.BeneficioCodigo <> msg0167.BeneficioCodigo  THEN                                             
        ASSIGN p-mudancas = p-mudancas + "Alterado <BeneficioCodigo> de " + STRING(b-int-benef-canal-perc.BeneficioCodigo)              + "  para  " + STRING(msg0167.BeneficioCodigo) + CHR(10).
                                                                                                                                              
    IF  b-int-benef-canal-perc.CodigoNivelPosVenda <> msg0167.CodigoNivelPosVenda  THEN                                             
        ASSIGN p-mudancas = p-mudancas + "Alterado <CodigoNivelPosVenda> de " + STRING(b-int-benef-canal-perc.CodigoNivelPosVenda)      + "  para  " + STRING(msg0167.CodigoNivelPosVenda) + CHR(10).
                                                                                                                                              
    IF  b-int-benef-canal-perc.CodigoUnidadeNegocio <> msg0167.CodigoUnidadeNegocio THEN                                             
        ASSIGN p-mudancas = p-mudancas + "Alterado <CodigoUnidadeNegocio> de " + STRING(b-int-benef-canal-perc.CodigoUnidadeNegocio)    + "  para  " + STRING(msg0167.CodigoUnidadeNegocio) + CHR(10).
                                                                                                                                              
    IF  b-int-benef-canal-perc.TipoDado <> msg0167.TipoDado THEN                                             
        ASSIGN p-mudancas = p-mudancas + "Alterado <TipoDado> de " + STRING(b-int-benef-canal-perc.TipoDado)                            + "  para  " + STRING(msg0167.TipoDado) + CHR(10).
                                                                                                                                              
    IF  b-int-benef-canal-perc.ValorParametroGlobal <> msg0167.ValorParametroGlobal THEN                                             
        ASSIGN p-mudancas = p-mudancas + "Alterado <ValorParametroGlobal> de " + STRING(b-int-benef-canal-perc.ValorParametroGlobal)    + "  para  " + STRING(msg0167.ValorParametroGlobal) + CHR(10).
                                                                                                                                              
    IF  b-int-benef-canal-perc.Situacao <> msg0167.Situacao THEN
        ASSIGN p-mudancas = p-mudancas + "Alterado <Situacao> de " + STRING(b-int-benef-canal-perc.Situacao)                            + "  para  " + STRING(msg0167.Situacao) + CHR(10).
                                                                                                                                            
    IF  b-int-benef-canal-perc.Proprietario <> msg0167.Proprietario THEN                                           
        ASSIGN p-mudancas = p-mudancas + "Alterado <Proprietario> de " + STRING(b-int-benef-canal-perc.Proprietario)                    + "  para  " + STRING(msg0167.Proprietario) + CHR(10).
                                                                                                                                            
    IF  b-int-benef-canal-perc.TipoProprietario <> msg0167.TipoProprietario THEN                                           
        ASSIGN p-mudancas = p-mudancas + "Alterado <TipoProprietario> de " + STRING(b-int-benef-canal-perc.TipoProprietario)            + "  para  " + STRING(msg0167.TipoProprietario) + CHR(10).

END.                                                                                         
