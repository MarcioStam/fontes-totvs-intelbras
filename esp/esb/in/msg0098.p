/***********************************************************************************************/
/* Programa...: esp/esb/in/msg0098.p - LISTAR_TITULO - CLIENTES                                */
/* Altor......: Roger Marcelino Bruhn                                                          */
/* Data.......: 27/04/2014                                                                     */ 
/* ObjetiVo...: Mensagem que ser† enviada para buscar a lista de t°tulos associados a um canal */                                 
/***********************************************************************************************/

create widget-pool.

DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEF TEMP-TABLE tt-canal NO-UNDO
    FIELD cod-emitente  AS INTEGER
    FIELD cod-guid      AS CHAR
    FIELD nome-cliente  AS CHAR
    FIELD cnpj          AS CHAR
        INDEX idx-canal cod-emitente.

define input  parameter iXML as longchar no-undo.
define output parameter oXML as longchar no-undo.
{esp/esb/esesbapi001.i}

{utp/ut-glob.i}
{esp/esb/in/msg0098.i}

DEFINE VARIABLE l-entrou AS LOGICAL     NO-UNDO.

define dataset mensagem for cabecalho, conteudo, msg0098, msg0098-ClienteItem
   data-relation for conteudo, msg0098            relation-fields (idm, idm) NESTED
   data-relation for msg0098, msg0098-ClienteItem relation-fields (idm, idm) nested.

dataset mensagem:read-xml('longchar', iXML, 'empty', ?, ?).

define dataset mensagemr xml-node-name 'MENSAGEM' for cabecalhor, conteudor, msg0098r1, msg0098r1-ClientesItens, msg0098r1-ClienteItem, msg0098r1-TitulosItens, msg0098r1-TituloItem, resultado
   data-relation for conteudor, msg0098r1                           relation-fields (idm, idm) NESTED
   data-relation for msg0098r1, msg0098r1-ClientesItens             relation-fields (idm, idm) NESTED
   data-relation for msg0098r1-ClientesItens, msg0098r1-ClienteItem relation-fields (idm, idm) NESTED
   data-relation for msg0098r1-ClienteItem, msg0098r1-TitulosItens  relation-fields (idm-canal-item, idm-canal-item) NESTED
   data-relation for msg0098r1-TitulosItens, msg0098r1-TituloItem   relation-fields (idm-canal-item, idm-canal-item) NESTED
   data-relation for msg0098r1, resultado                           relation-fields (idm, idm) NESTED.

create cabecalhor.
find cabecalho.
buffer-copy cabecalho EXCEPT IdentidadeEmissor to cabecalhor.
 
assign cabecalhor.CodigoMensagem    = 'MSG0098R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

create conteudor.
create resultado.
create msg0098r1.

FOR EACH msg0098-ClienteItem: 

    FIND FIRST int-emitente NO-LOCK
         WHERE int-emitente.cod-guid = msg0098-ClienteItem.CodigoConta
           AND int-emitente.ind-participa-canais = 993520001 /* Participa canais */  NO-ERROR.

    IF  NOT AVAIL int-emitente THEN DO:
        RUN pi-erro (INPUT "Cliente CRM: " + msg0098-ClienteItem.CodigoConta  + " n∆o est† marcado como participante do programa de canais no EMS.").
        LEAVE.
    END.

    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = int-emitente.cod-emitente NO-ERROR.

    IF  NOT AVAIL emitente THEN DO:
        RUN pi-erro (INPUT "N∆o foi encontrado Cliente com o c¢digo: " + STRING(int-emitente.cod-emitente) + " cadastrado.") .
        LEAVE.
    END.

    CREATE tt-canal.
    ASSIGN tt-canal.cod-emitente = emitente.cod-emitente
           tt-canal.cod-guid     = int-emitente.cod-guid
           tt-canal.nome-cliente = emitente.nome-emit
           tt-canal.CNPJ         = emitente.cgc.

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
    EMPTY TEMP-TABLE tt-canal.
    CREATE msg0098r1-ClientesItens.

END.

DEFINE VARIABLE i-idm-canal-item AS INTEGER NO-UNDO.

IF  CAN-FIND (FIRST tt-canal) THEN DO:

    CREATE msg0098r1-ClientesItens.

    FOR EACH tt-canal
        BY tt-canal.cod-emitente:

        ASSIGN i-idm-canal-item = i-idm-canal-item + 1.

        CREATE msg0098r1-ClienteItem.
        ASSIGN msg0098r1-ClienteItem.idm            = 0
               msg0098r1-ClienteItem.idm-canal-item = i-idm-canal-item
               msg0098r1-ClienteItem.CodigoConta    = tt-canal.cod-guid
               msg0098r1-ClienteItem.NomeCliente    = tt-canal.nome-cliente 
               msg0098r1-ClienteItem.CNPJ           = tt-canal.CNPJ.


        /* Carrega a tabela de titulos em aberto do cliente */
        EMPTY TEMP-TABLE tt-titulos-canal.
        RUN esp/esb/esesbapi001.p (INPUT tt-canal.cod-emitente,
                                   OUTPUT TABLE tt-titulos-canal).
    

        IF  CAN-FIND (FIRST tt-titulos-canal) THEN DO:

            CREATE msg0098r1-TitulosItens.
            ASSIGN msg0098r1-TitulosItens.idm-canal-item = msg0098r1-ClienteItem.idm-canal-item. 

            FOR EACH tt-titulos-canal:
    
                CREATE msg0098r1-TituloItem.
    
                assign msg0098r1-TituloItem.idm-canal-item               = msg0098r1-TitulosItens.idm-canal-item             
                       msg0098r1-TituloItem.NumeroTitulo                 = tt-titulos-canal.NumeroTitulo                  
                       msg0098r1-TituloItem.Carteira                     = tt-titulos-canal.Carteira                      
                       msg0098r1-TituloItem.DataEmissao                  = tt-titulos-canal.DataEmissao                   
                       msg0098r1-TituloItem.DataIndicacaoPerdaDedutivel  = tt-titulos-canal.DataIndicacaoPerdaDedutivel   
                       msg0098r1-TituloItem.DataLiquidacao               = tt-titulos-canal.DataLiquidacao                
                       msg0098r1-TituloItem.DataVencimento               = tt-titulos-canal.DataVencimento                
                       msg0098r1-TituloItem.DataVencimentoOriginal       = tt-titulos-canal.DataVencimentoOriginal        
                       msg0098r1-TituloItem.Especie                      = tt-titulos-canal.Especie                       
                       msg0098r1-TituloItem.TipoEspecie                  = tt-titulos-canal.TipoEspecie                   
                       msg0098r1-TituloItem.NumeroSerie                  = tt-titulos-canal.NumeroSerie                   
                       msg0098r1-TituloItem.CodigoEstabelecimento        = tt-titulos-canal.CodigoEstabelecimento         
                       msg0098r1-TituloItem.NomeEstabelecimento          = tt-titulos-canal.NomeEstabelecimento           
                       msg0098r1-TituloItem.Moeda                        = tt-titulos-canal.Moeda                         
                       msg0098r1-TituloItem.NumeroBancario               = tt-titulos-canal.NumeroBancario                
                       msg0098r1-TituloItem.NumeroParcela                = tt-titulos-canal.NumeroParcela                 
                       msg0098r1-TituloItem.CodigoPortador               = tt-titulos-canal.CodigoPortador                
                       msg0098r1-TituloItem.NomePortador                 = tt-titulos-canal.NomePortador                  
                       msg0098r1-TituloItem.CodigoRepresentante          = tt-titulos-canal.CodigoRepresentante           
                       msg0098r1-TituloItem.NomeRepresentante            = tt-titulos-canal.NomeRepresentante             
                       msg0098r1-TituloItem.TituloEmCobranca             = tt-titulos-canal.TituloEmCobranca              
                       msg0098r1-TituloItem.ValorOriginal                = tt-titulos-canal.ValorOriginal                 
                       msg0098r1-TituloItem.ValorSaldo                   = tt-titulos-canal.ValorSaldo                    
                       msg0098r1-TituloItem.NumeroDiasAtraso             = tt-titulos-canal.NumeroDiasAtraso .             
            END.
        END.
        ELSE DO:
            CREATE msg0098r1-TitulosItens.
            ASSIGN msg0098r1-TitulosItens.idm-canal-item = msg0098r1-ClienteItem.idm-canal-item.

        END.
    END.
END.
ELSE
    CREATE msg0098r1-ClientesItens.


IF resultado.Mensagem = "" THEN
    ASSIGN resultado.Mensagem = ?.

DATASET mensagemr:WRITE-XML('longchar', oXML, NO).

return.


PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.
END PROCEDURE.
