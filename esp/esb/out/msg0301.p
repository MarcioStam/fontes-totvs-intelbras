/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0301 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0301
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/
create widget-pool.

{utp/ut-glob.i}
{esp/esb/out/msg0301.i}

DEFINE INPUT  PARAM raw-param AS RAW NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR resultado.

DEF VAR iXml AS LONGCHAR NO-UNDO.
DEF VAR oXML AS LONGCHAR NO-UNDO.

DEFINE VARIABLE h-boes727     AS HANDLE      NO-UNDO.
DEFINE VARIABLE iRowsReturned AS INTEGER     NO-UNDO.

/* CREATE tt-estrutura-integra.                           */
/* ASSIGN tt-estrutura-integra.CodigoProduto = "4760050". */

CREATE tt-estrutura-integra.
RAW-TRANSFER raw-param TO tt-estrutura-integra.

/*Definiá∆o da mensagem de envio de atualizaá∆o*/
DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, msg0301, EstuturaASTEC, ItemEstrutura
    DATA-RELATION FOR conteudo, msg0301             RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR msg0301, EstuturaASTEC        RELATION-FIELDS (idm, idm) NESTED
    DATA-RELATION FOR EstuturaASTEC, ItemEstrutura  RELATION-FIELDS (idm, idm) NESTED.

/*Definiá∆o e leitura da mensagem de resposta da atualizaá∆o.*/
DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0301r, resultado
   DATA-RELATION FOR conteudor, msg0301r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0301r, resultado RELATION-FIELDS (idm, idm) NESTED.

CREATE cabecalho.
ASSIGN cabecalho.IdentidadeEmissor = '64546C2E-6DAB-4311-A74A-5ACA96134AFF'
       cabecalho.CodigoMensagem    = 'MSG0301'
       cabecalho.LoginUsuario      = c-seg-usuario.
     
CREATE conteudo.
CREATE msg0301.

FOR FIRST tt-estrutura-integra:
    FIND FIRST altern-astec NO-LOCK
         WHERE altern-astec.it-altern = tt-estrutura-integra.CodigoProduto NO-ERROR.
    
    CREATE EstuturaASTEC.
    ASSIGN EstuturaASTEC.CodigoProduto = IF AVAIL altern-astec THEN altern-astec.it-codigo ELSE tt-estrutura-integra.CodigoProduto
           cabecalho.NumeroOperacao = IF AVAIL altern-astec THEN altern-astec.it-codigo ELSE tt-estrutura-integra.CodigoProduto.

    RUN pi-carga-astec.
    RUN pi-carrega-estrutura (INPUT tt-estrutura-integra.CodigoProduto).
END.

PROCEDURE pi-carga-astec:
    /*Astec padr∆o*/
    RUN esbo/boes727.p PERSISTENT SET h-boes727.
    RUN setConstraintItem IN h-boes727 (INPUT tt-estrutura-integra.CodigoProduto).
    RUN openQueryStatic   IN h-boes727 (INPUT "Item").
    RUN getBatchRecords   IN h-boes727 (INPUT  ?,
                                        INPUT  ?,
                                        INPUT  ?,
                                        OUTPUT iRowsReturned,
                                        OUTPUT TABLE tt-estrut-astec).

    FOR EACH tt-estrut-astec:

        FOR FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = tt-estrut-astec.es-codigo:
        END.

        CREATE ItemEstrutura.             
        ASSIGN ItemEstrutura.CodigoItemEstrutura = tt-estrut-astec.es-codigo
               ItemEstrutura.DescricaoItem       = ITEM.desc-item
               ItemEstrutura.QuantidadeUsada     = ROUND(tt-estrut-astec.quantidade,2).

        FOR FIRST int-estrutura NO-LOCK
            WHERE int-estrutura.it-codigo = tt-estrut-astec.it-codigo
              AND int-estrutura.sequencia = tt-estrut-astec.sequencia
              AND int-estrutura.es-codigo = tt-estrut-astec.es-codigo:
               
            ASSIGN ItemEstrutura.TempoGarantia      = int-estrutura.garantia
                   ItemEstrutura.PermiteVenda       = int-estrutura.venda
                   ItemEstrutura.PermiteDiagnostico = IF int-estrutura.garantia <> 0 THEN YES ELSE NO.

        END.

        RUN pi-tipo-item.
    END.
    DELETE PROCEDURE h-boes727.
    ASSIGN h-boes727 = ?.

    /*Astec alternativo*/
    FOR EACH altern-astec NO-LOCK
       WHERE altern-astec.it-codigo = tt-estrutura-integra.CodigoProduto:

        FOR EACH estrutura NO-LOCK
           WHERE estrutura.it-codigo    =  altern-astec.it-altern
             AND estrutura.data-inicio  <= TODAY 
             AND estrutura.data-termino >  TODAY:
            
            FOR FIRST ITEM NO-LOCK
                WHERE ITEM.it-codigo = estrutura.es-codigo:
            END.

            CREATE ItemEstrutura.             
            ASSIGN ItemEstrutura.CodigoItemEstrutura = estrutura.es-codigo
                   ItemEstrutura.DescricaoItem       = ITEM.desc-item
                   ItemEstrutura.QuantidadeUsada     = round(estrutura.quant-usada,2).
    
            FOR FIRST int-estrutura NO-LOCK
                WHERE int-estrutura.it-codigo = estrutura.it-codigo
                  AND int-estrutura.sequencia = estrutura.sequencia
                  AND int-estrutura.es-codigo = estrutura.es-codigo:
                   
                ASSIGN ItemEstrutura.TempoGarantia      = int-estrutura.garantia
                       ItemEstrutura.PermiteVenda       = int-estrutura.venda
                       ItemEstrutura.PermiteDiagnostico = IF int-estrutura.garantia <> 0 THEN YES ELSE NO.
    
            END.

            RUN pi-tipo-item.
        END.
    END.
END PROCEDURE.

PROCEDURE pi-carrega-estrutura:
    DEF INPUT PARAMETER p-it-codigo LIKE item.it-codigo NO-UNDO.

    FOR EACH estrutura 
       WHERE estrutura.it-codigo = p-it-codigo 
         AND estrutura.data-inicio <= TODAY 
         AND estrutura.data-termino > TODAY NO-LOCK:

        FOR FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = estrutura.es-codigo:
        END.

        CREATE ItemEstrutura.             
        ASSIGN ItemEstrutura.CodigoItemEstrutura = estrutura.es-codigo
               ItemEstrutura.DescricaoItem       = ITEM.desc-item
               ItemEstrutura.QuantidadeUsada     = round(estrutura.quant-usada,2)
               ItemEstrutura.LocalMontagem       = estrutura.local-montag.

        FOR FIRST int-estrutura NO-LOCK
            WHERE int-estrutura.it-codigo = estrutura.it-codigo
              AND int-estrutura.sequencia = estrutura.sequencia
              AND int-estrutura.es-codigo = estrutura.es-codigo:
               
            ASSIGN ItemEstrutura.TempoGarantia      = int-estrutura.garantia
                   ItemEstrutura.PermiteVenda       = int-estrutura.venda
                   ItemEstrutura.PermiteDiagnostico = IF int-estrutura.garantia <> 0 THEN YES ELSE NO.

        END.

        RUN pi-tipo-item.
        RUN pi-carrega-estrutura (INPUT estrutura.es-codigo).
    END.
    
END PROCEDURE.

PROCEDURE pi-tipo-item:
    /*Componente*/
     IF ITEM.ge-codigo = 10
     OR ITEM.ge-codigo = 12
     OR ITEM.ge-codigo = 15 THEN
         ASSIGN ItemEstrutura.TipoItem = "993520001".
     /*Acess¢rios*/
     ELSE IF ITEM.ge-codigo = 40 
     OR ITEM.ge-codigo = 42
     OR ITEM.ge-codigo = 45 THEN
         ASSIGN ItemEstrutura.TipoItem = "993520003".
     ELSE IF ITEM.ge-codigo = 20
     OR ITEM.ge-codigo = 25 THEN DO:
         /*Placas*/
         IF ITEM.desc-item BEGINS "PLACA" 
         OR ITEM.desc-item BEGINS "PCI" THEN
             ASSIGN ItemEstrutura.TipoItem = "993520004".
         /*Peáas*/
         ELSE 
             ASSIGN ItemEstrutura.TipoItem = "993520002".
     END.
     ELSE 
         ASSIGN ItemEstrutura.TipoItem = "993520001".
END PROCEDURE.

/* Grava o xml com o registro, conecta com o Barramento e devolve a resposta. */
{esp/esb/esesb003a.i}

RETURN.
