/******************************************************************************************* */
/* Programa...: esp/esb/in/msg0166.p - 5.166 REGISTRA_PARAMETRO_BENEFICIO                    */
/* Altor......: Roger Marcelino Bruhn                                                        */
/* Data.......: 02/02/2016                                                                   */ 
/* Objetivo...: Mensagem enviada quando for criado ou atualizado benef¡cio do canal.         */
/******************************************************************************************* */

CREATE WIDGET-POOL.

DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

{esp/esb/in/msg0166.i}
{esp/esb/IN/msg9999.i}

DEFINE DATASET mensagem xml-node-name 'MENSAGEM' FOR cabecalho, conteudo, msg0166
   DATA-RELATION FOR conteudo, msg0166    RELATION-FIELDS (idm, idm) NESTED.
   
DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0166R1, resultado
    DATA-RELATION FOR conteudor, MSG0166R1                     RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR MSG0166R1, resultado                     RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0166R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

CREATE conteudor.
CREATE resultado.
CREATE MSG0166R1.

ASSIGN resultado.sucesso    = no.

DEF BUFFER b-int-benef-parametro FOR int-benef-parametro.

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

FIND FIRST msg0166 NO-ERROR.

/*Eliminar handles*/

DATASET mensagemr:WRITE-XML('longchar', oXML, YES).

RETURN.

PROCEDURE pi-grava-benef:
    
    DEF VAR c-mudancas AS CHAR FORMAT "X(100)" NO-UNDO.
    
    FIND FIRST msg0166 NO-ERROR.

    IF  NOT AVAIL msg0166 THEN DO:
        RUN pi-erro (INPUT "NÆo retornaram dados de benef¡cio" ).
        RETURN "NOK".
    END.

    blk_principal:
    DO TRANSACTION
    ON ERROR UNDO blk_principal,LEAVE blk_principal
    ON STOP  UNDO blk_principal,LEAVE blk_principal:        

        {esp/esb/in/msg9999.i01     "b-int-benef-parametro"
                                    " FIND FIRST b-int-benef-parametro 
                                        WHERE b-int-benef-parametro.CodigoParametroBeneficio = msg0166.CodigoParametroBeneficio EXCLUSIVE-LOCK NO-WAIT NO-ERROR. "
                                    2  
                                    5  }

        /*************************** CRIA€ÇO PARAMETRO BENEFICIO **************************/
        IF  NOT l-reg-disponivel AND NOT l-locked THEN DO:
            CREATE b-int-benef-parametro.
            ASSIGN b-int-benef-parametro.CodigoParametroBeneficio  = msg0166.CodigoParametroBeneficio
                   b-int-benef-parametro.CodigoBeneficio           = msg0166.CodigoBeneficio
                   b-int-benef-parametro.dt-trans                  = DATETIME(TODAY,MTIME)
                   b-int-benef-parametro.BeneficioCodigo           = msg0166.BeneficioCodigo          
                   b-int-benef-parametro.CodigoUnidadeNegocio      = msg0166.CodigoUnidadeNegocio     
                   b-int-benef-parametro.CodigoEstabelecimento     = msg0166.CodigoEstabelecimento         
                   b-int-benef-parametro.TipoFluxoFinanceiro       = msg0166.TipoFluxoFinanceiro           
                   b-int-benef-parametro.EspecieDocumento          = msg0166.EspecieDocumento              
                   b-int-benef-parametro.ContaContabil             = msg0166.ContaContabil                 
                   b-int-benef-parametro.CentroCusto               = msg0166.CentroCusto              
                   b-int-benef-parametro.PercentualAtingimentoMeta = msg0166.PercentualAtingimentoMeta     
                   b-int-benef-parametro.PercentualCusto           = msg0166.PercentualCusto               
                   b-int-benef-parametro.Situacao                  = msg0166.Situacao                      
                   b-int-benef-parametro.Proprietario              = msg0166.Proprietario                  
                   b-int-benef-parametro.TipoProprietario          = msg0166.TipoProprietario.

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

                ASSIGN b-int-benef-parametro.CodigoBeneficio           = msg0166.CodigoBeneficio
                       b-int-benef-parametro.BeneficioCodigo           = msg0166.BeneficioCodigo          
                       b-int-benef-parametro.CodigoUnidadeNegocio      = msg0166.CodigoUnidadeNegocio     
                       b-int-benef-parametro.CodigoEstabelecimento     = msg0166.CodigoEstabelecimento         
                       b-int-benef-parametro.TipoFluxoFinanceiro       = msg0166.TipoFluxoFinanceiro           
                       b-int-benef-parametro.EspecieDocumento          = msg0166.EspecieDocumento              
                       b-int-benef-parametro.ContaContabil             = msg0166.ContaContabil                 
                       b-int-benef-parametro.CentroCusto               = msg0166.CentroCusto              
                       b-int-benef-parametro.PercentualAtingimentoMeta = msg0166.PercentualAtingimentoMeta     
                       b-int-benef-parametro.PercentualCusto           = msg0166.PercentualCusto               
                       b-int-benef-parametro.Situacao                  = msg0166.Situacao                      
                       b-int-benef-parametro.Proprietario              = msg0166.Proprietario                  
                       b-int-benef-parametro.TipoProprietario          = msg0166.TipoProprietario.

                
                ASSIGN b-int-benef-parametro.dt-trans   = DATETIME(TODAY,MTIME)
                       b-int-benef-parametro.alteracoes = c-mudancas.

            END.
        END.

        RELEASE b-int-benef-parametro NO-ERROR.
        

    END. /* TRANZA€ÇO */

    RETURN "OK".

END PROCEDURE.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

END PROCEDURE.

PROCEDURE pi-grava-historico:

    CREATE int-benef-parametro-hist.
    ASSIGN int-benef-parametro-hist.CodigoParametroBeneficio  = b-int-benef-parametro.CodigoParametroBeneficio 
           int-benef-parametro-hist.CodigoBeneficio           = b-int-benef-parametro.CodigoBeneficio          
           int-benef-parametro-hist.dt-trans                  = b-int-benef-parametro.dt-trans                 
           int-benef-parametro-hist.BeneficioCodigo           = b-int-benef-parametro.BeneficioCodigo          
           int-benef-parametro-hist.CodigoUnidadeNegocio      = b-int-benef-parametro.CodigoUnidadeNegocio     
           int-benef-parametro-hist.CodigoEstabelecimento     = b-int-benef-parametro.CodigoEstabelecimento       
           int-benef-parametro-hist.TipoFluxoFinanceiro       = b-int-benef-parametro.TipoFluxoFinanceiro         
           int-benef-parametro-hist.EspecieDocumento          = b-int-benef-parametro.EspecieDocumento            
           int-benef-parametro-hist.ContaContabil             = b-int-benef-parametro.ContaContabil               
           int-benef-parametro-hist.CentroCusto               = b-int-benef-parametro.CentroCusto              
           int-benef-parametro-hist.PercentualAtingimentoMeta = b-int-benef-parametro.PercentualAtingimentoMeta   
           int-benef-parametro-hist.PercentualCusto           = b-int-benef-parametro.PercentualCusto  
           int-benef-parametro-hist.alteracoes                = b-int-benef-parametro.alteracoes  
           int-benef-parametro-hist.Situacao                  = b-int-benef-parametro.Situacao                    
           int-benef-parametro-hist.Proprietario              = b-int-benef-parametro.Proprietario                
           int-benef-parametro-hist.TipoProprietario          = b-int-benef-parametro.TipoProprietario.       
    
END.


PROCEDURE pi-compara-mudancas:

    DEF OUTPUT PARAM p-mudancas AS CHAR  NO-UNDO.

    if  b-int-benef-parametro.CodigoBeneficio <> msg0166.CodigoBeneficio THEN
        ASSIGN p-mudancas = p-mudancas + "Alterado <CodigoBeneficio> DE "           + STRING(b-int-benef-parametro.CodigoBeneficio)           + "  para  " + STRING(msg0166.CodigoBeneficio) + CHR(10).

    if  b-int-benef-parametro.BeneficioCodigo <> msg0166.BeneficioCodigo THEN
        ASSIGN p-mudancas = p-mudancas + "Alterado <BeneficioCodigo> DE "           + STRING(b-int-benef-parametro.BeneficioCodigo)           + "  para  " + STRING(msg0166.BeneficioCodigo) + CHR(10).
                                                                                                                                         
    if  b-int-benef-parametro.CodigoUnidadeNegocio <> msg0166.CodigoUnidadeNegocio THEN                                                      
        ASSIGN p-mudancas = p-mudancas + "Alterado <CodigoUnidadeNegocio> DE "      + STRING(b-int-benef-parametro.CodigoUnidadeNegocio)      + "  para  " + STRING(msg0166.CodigoUnidadeNegocio) + CHR(10).
                                                                                                                                         
    if  b-int-benef-parametro.CodigoEstabelecimento <> msg0166.CodigoEstabelecimento THEN                                                    
        ASSIGN p-mudancas = p-mudancas + "Alterado <CodigoEstabelecimento> DE "     + STRING(b-int-benef-parametro.CodigoEstabelecimento)     + "  para  " + STRING(msg0166.CodigoEstabelecimento) + CHR(10).
                                                                                                                                         
    if  b-int-benef-parametro.TipoFluxoFinanceiro  <> msg0166.TipoFluxoFinanceiro THEN                                                       
        ASSIGN p-mudancas = p-mudancas + "Alterado <TipoFluxoFinanceiro> DE "       + STRING(b-int-benef-parametro.TipoFluxoFinanceiro)       + "  para  " + STRING(msg0166.TipoFluxoFinanceiro) + CHR(10).
                                                                                                                                         
    if  b-int-benef-parametro.EspecieDocumento <> msg0166.EspecieDocumento THEN                                                              
        ASSIGN p-mudancas = p-mudancas + "Alterado <EspecieDocumento> DE "          + STRING(b-int-benef-parametro.EspecieDocumento)          + "  para  " + STRING(msg0166.EspecieDocumento) + CHR(10).
                                                                                                                                         
    if  b-int-benef-parametro.ContaContabil <> msg0166.ContaContabil THEN                                                                    
        ASSIGN p-mudancas = p-mudancas + "Alterado <ContaContabil> DE "             + STRING(b-int-benef-parametro.ContaContabil)             + "  para  " + STRING(msg0166.ContaContabil) + CHR(10).
                                                                                                                                         
    if  b-int-benef-parametro.CentroCusto <> msg0166.CentroCusto THEN
        ASSIGN p-mudancas = p-mudancas + "Alterado <CentroCusto> DE "               + STRING(b-int-benef-parametro.CentroCusto)               + "  para  " + STRING(msg0166.CentroCusto) + CHR(10).

    if  b-int-benef-parametro.PercentualAtingimentoMeta <> msg0166.PercentualAtingimentoMeta THEN
        ASSIGN p-mudancas = p-mudancas + "Alterado <PercentualAtingimentoMeta> DE " + STRING(b-int-benef-parametro.PercentualAtingimentoMeta) + "  para  " + STRING(msg0166.PercentualAtingimentoMeta) + CHR(10).
           
    if  b-int-benef-parametro.PercentualCusto <> msg0166.PercentualCusto THEN
        ASSIGN p-mudancas = p-mudancas + "Alterado <PercentualCusto> DE "           + STRING(b-int-benef-parametro.PercentualCusto)           + "  para  " + STRING(msg0166.PercentualCusto) + CHR(10).

    if  b-int-benef-parametro.Situacao <> msg0166.Situacao THEN
        ASSIGN p-mudancas = p-mudancas + "Alterado <Situacao> DE "                  + STRING(b-int-benef-parametro.Situacao)                  + "  para  " + STRING(msg0166.Situacao) + CHR(10).
    
    if  b-int-benef-parametro.Proprietario <> msg0166.Proprietario THEN
        ASSIGN p-mudancas = p-mudancas + "Alterado <Proprietario> DE "              + STRING(b-int-benef-parametro.Proprietario)              + "  para  " + STRING(msg0166.Proprietario) + CHR(10).

    if  b-int-benef-parametro.TipoProprietario <> msg0166.TipoProprietario THEN
        ASSIGN p-mudancas = p-mudancas + "Alterado <TipoProprietario> DE "         + STRING(b-int-benef-parametro.TipoProprietario)           + "  para  " + STRING(msg0166.TipoProprietario) + CHR(10).
     
END.
