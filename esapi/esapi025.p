/************************************************************************
* Programa ..: ESAPI025 - Integracao de Item Klasmatt x Datasul
* Data ......: 10/05/2021
* Autor .....: Isac Abrahao
* esp/mssp/esmssp012b.p
*************************************************************************/
CREATE WIDGET-POOL.

/*--- Definiá∆o das Vari†veis ---*/
DEFINE VARIABLE c-it-codigo      AS CHARACTER NO-UNDO.
DEFINE VARIABLE h-esmsspapi001   AS HANDLE    NO-UNDO.
DEFINE VARIABLE c-mensagem       AS CHARACTER NO-UNDO.
DEFINE VARIABLE pTipoRequisicao  AS INTEGER   NO-UNDO.
DEFINE VARIABLE l-faturavel      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE l-erro           AS LOGICAL   NO-UNDO.
DEFINE VARIABLE l-log            AS LOGICAL   NO-UNDO.
DEFINE VARIABLE l-producao       AS LOGICAL   NO-UNDO.

DEFINE VARIABLE c-item        AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-familia     AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-motivo-pend AS CHARACTER NO-UNDO.
DEFINE VARIABLE h-boes372     AS HANDLE    NO-UNDO.
DEFINE VARIABLE v_aliq_chr    AS CHARACTER NO-UNDO.
DEFINE VARIABLE v_aux_aliq    AS CHARACTER NO-UNDO.
DEFINE VARIABLE v_cont        AS INTEGER   NO-UNDO.

DEFINE BUFFER b01-item-uni-estab    FOR item-uni-estab.
DEFINE BUFFER b01-it-res-carac      FOR it-res-carac.
DEFINE BUFFER b01-item-fabric       FOR item-fabric.         
DEFINE BUFFER b01-item-proj-suframa FOR item-proj-suframa.
DEFINE BUFFER b-item                FOR item.

{esp/es0018.i}
{esapi/esapi025.i}
{esapi/esapi025a.i}

DEFINE INPUT  PARAMETER TABLE FOR tt-item-json.
DEFINE INPUT  PARAMETER TABLE FOR tt-item-fabric.
DEFINE INPUT  PARAMETER TABLE FOR tt-proj-suframa.
DEFINE OUTPUT PARAMETER TABLE FOR tt-mensagem-2.

DEF TEMP-TABLE tt-item-fabric-aux LIKE tt-item-fabric.

/*--- Bloco Principal ---*/
EMPTY TEMP-TABLE tt-versao-integr.
EMPTY TEMP-TABLE tt-erros-geral.
EMPTY TEMP-TABLE tt-item.

CREATE tt-versao-integr.
ASSIGN tt-versao-integr.cod-versao-integracao = 1.

EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p (INPUT "ambiente":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

FIND FIRST tt-prog-ponto NO-ERROR.

IF  AVAIL tt-prog-ponto
AND tt-prog-ponto.conteudo = "PRODUCAO":U THEN
    ASSIGN l-producao = YES.
ELSE
    ASSIGN l-producao = NO.

/* arquivo de log de execucao do programa */
EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p (INPUT "log-wso2":U,
                  INPUT 2,
                  INPUT 0,
                  INPUT "":U,
                  OUTPUT TABLE tt-prog-ponto).

FIND FIRST tt-prog-ponto 
   WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = 'esapi025' NO-ERROR.

IF  AVAIL tt-prog-ponto
AND ENTRY(2,tt-prog-ponto.conteudo,";") = "yes":U THEN
    ASSIGN l-log = YES.
ELSE
    ASSIGN l-log = NO.

IF  l-log = YES THEN DO:
    IF  OPSYS = 'UNIX' THEN    
        ASSIGN c-arquivo-log1 = "/usr/wrk/totvs/UNIX_esapi025_".
    ELSE
        ASSIGN c-arquivo-log1 = "\\erpapp\spool\totvs\WIN_esapi025_".

    IF  l-producao THEN
        ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'PROD.txt'.
    ELSE 
        ASSIGN c-arquivo-log1 = c-arquivo-log1 + 'HOMOL.txt'.
END.
/* arquivo de log de execucao do programa */

RUN pi-gerar-dados-extrato (" " + CHR(13) + CHR(13)).

/**** Inicio ****/
bk-integracao:
DO TRANSACTION ON ERROR UNDO bk-integracao, RETURN "NOK":U
               ON STOP  UNDO bk-integracao, RETURN "NOK":U:

   EMPTY TEMP-TABLE tt-mensagem-2.

   RUN pi-gerar-dados-extrato (">> INICIO NEW").
   RUN pi-gerar-dados-extrato (">> ANTES PI-VALIDA ").

   /* Validaá‰es */
   RUN pi-valida.

   IF CAN-FIND(FIRST tt-mensagem-2) THEN
      UNDO bk-integracao, RETURN "NOK":U.
   
   FIND FIRST tt-item-json NO-ERROR.

   IF AVAIL tt-item-json THEN DO:

      RUN pi-gerar-dados-extrato (">> ANTES pi-integra-item").
      RUN pi-gerar-dados-extrato (">>PRODUTO: " + tt-item-json.codItem).
      
      /* Cria Item */
      RUN pi-integra-item.
      
      IF RETURN-VALUE = 'NOK' THEN UNDO bk-integracao, RETURN "NOK":U.
      
      FIND FIRST ITEM WHERE ITEM.it-codigo = tt-item-json.codItem NO-LOCK NO-ERROR.

      IF NOT AVAIL ITEM THEN DO:
         RUN pi-cria-mensagem (INPUT 412,
                               INPUT "ERRO_DE_VALIDACAO",
                               INPUT "Erro inesperado. Item n∆o foi cadastrado no Totvs").
         RUN pi-gerar-dados-extrato ("Erro inesperado. Item n∆o foi cadastrado no Totvs").

         UNDO bk-integracao, RETURN "NOK":U.
      END.   
      ELSE DO:
         FIND FIRST tt-item WHERE tt-item.it-codigo = tt-item-json.codItem NO-ERROR.
            
         RUN pi-gerar-dados-extrato (">> AVAIL tt-item " + STRING(AVAIL tt-item)).

         IF AVAIL tt-item THEN DO:
            RUN pi-gerar-dados-extrato (">> ANTES pi-efetiva-distribuicao").
            
            /* Distribuicao */
            RUN pi-efetiva-distribuicao. 
    
            IF RETURN-VALUE = 'NOK' THEN UNDO bk-integracao, RETURN "NOK":U.
         END.

         FIND FIRST ITEM WHERE ITEM.it-codigo = tt-item-json.codItem NO-LOCK NO-ERROR.
    
         IF AVAILABLE ITEM THEN DO:
            RUN pi-gerar-dados-extrato (">> ANTES pi-atualiza-dados-item").
          
            /* Atualiza */
            RUN pi-atualiza-dados-item. 
    
            IF RETURN-VALUE = 'NOK' THEN UNDO bk-integracao, RETURN "NOK":U.
         END. 
      END.                                                                         
      
      FIND FIRST ITEM WHERE ITEM.it-codigo = tt-item-json.codItem NO-LOCK NO-ERROR.

      IF AVAILABLE ITEM THEN DO:
         /* Alteraá∆o */
         IF pTipoRequisicao = 2 THEN
            RUN pi-cria-mensagem (INPUT 200,
                                  INPUT ITEM.it-codigo,
                                  INPUT "Item alterado com Sucesso").
         ELSE 
            RUN pi-cria-mensagem (INPUT 200,
                                  INPUT ITEM.it-codigo,
                                  INPUT "1.Item criado com Sucesso").

         RUN pi-gerar-dados-extrato (">> GEROU ITEM NA BASE - CODIGO: " + ITEM.it-codigo).
          
         ASSIGN i-seq-histor = 0.

         /* atualiza tabela de log - ESCDP094 */
         RUN pi-cria-historico (INPUT ITEM.it-codigo,
                                INPUT-OUTPUT i-seq-histor, /*Seq Historico*/
                                INPUT tt-item-json.leiInformatica,
                                INPUT tt-item-json.tipoItem,      
                                INPUT tt-item-json.ItemOrigin,
                                INPUT tt-item-json.pais-ori).   

         IF AVAIL histor-integra-item THEN DO:
            /*Criacao*/
            IF pTipoRequisicao = 1 THEN
               ASSIGN histor-integra-item.acao = 'ADD'.
            ELSE
               ASSIGN histor-integra-item.acao = 'MOD'.   

             RUN pi-gerar-dados-extrato ("histor-integra-item.acao - "  + STRING(histor-integra-item.acao) ).
         END.
      END.
   END.
END.


/*
C2211-0831 Desativar Funcionaliade Item Fatur†vel - 09/11/2022

/* Tornar Item Faturavel */ 
FIND FIRST ITEM WHERE ITEM.it-codigo = tt-item-json.codItem NO-LOCK NO-ERROR.

IF AVAILABLE ITEM THEN DO:  
   RUN pi-gerar-dados-extrato (">> ITEM.ind-item-fat - " + STRING(ITEM.ind-item-fat)).
   
   IF ITEM.ind-item-fat THEN DO:
      ASSIGN l-faturavel = YES.

      /*
      RUN esp/es0018p.p (INPUT  'esapi025',
                         INPUT  3,
                         INPUT  0,
                         INPUT  "":U,
                         OUTPUT TABLE tt-prog-ponto).
      
      FOR EACH tt-prog-ponto:
          IF INDEX(ITEM.class-fiscal,tt-prog-ponto.conteudo) <> 0 THEN
              ASSIGN l-faturavel = NO.
      END.

      RUN pi-gerar-dados-extrato (">> TORNAR ITEM FATURAVEL ?? " + STRING(l-faturavel)).
      */


      /* Chamado C2206-0904 - Leonam - 09/06/2022 */
      FIND FIRST item-uni-estab 
           WHERE item-uni-estab.cod-estabel = tt-item-json.codEstabel
             AND item-uni-estab.it-codigo   = tt-item-json.codItem
      NO-LOCK NO-ERROR.

      IF AVAIL item-uni-estab THEN DO:
          IF item-uni-estab.ind-item-fat THEN 
             ASSIGN l-faturavel = NO.
      END.
                    
      IF l-faturavel THEN DO:
         /* Comentado para Liberacao da Integracao Item - 05/11/21 
            (Aguardando testes para liberacao de Tornar Item Faturavel) */
          
         RUN esapi/esapi025b.p (INPUT ITEM.it-codigo,
                                INPUT i-seq-histor,
                                OUTPUT c-motivo-pend).

         RUN pi-gerar-dados-extrato (">> MOTIVO PENDENCIA ITEM FAT: " + c-motivo-pend).

      END.
      ELSE DO:
         RUN pi-gerar-dados-extrato ("Item ja esta FATURAVEL: ").
      END. 
   END.   
END.
*/

/* Chamado C2206-0904 - Leonam - 09/06/2022 */
bk-ipi-dif:
DO TRANSACTION:                               
   FIND FIRST b01-item WHERE b01-item.it-codigo =  tt-item-json.codItem  EXCLUSIVE-LOCK NO-ERROR.

   IF AVAIL b01-item THEN DO:  
      IF tt-item-json.ex-ipi <> '' AND tt-item-json.ex-ipi <> '0' THEN
         ASSIGN b01-item.ind-ipi-dife = YES.
    
      IF tt-item-json.classFiscal <> '' THEN
         ASSIGN b01-item.class-fiscal = tt-item-json.classFiscal.

      RELEASE b01-item.
   END.   
END.

RUN pi-gerar-dados-extrato ("ANTES ITEM-FABRIC").

FOR EACH tt-item-fabric:
    FIND FIRST fabricante WHERE fabricante.cod-fabric = tt-item-fabric.cod-fabric NO-LOCK NO-ERROR.

    IF NOT AVAILABLE fabricante THEN DO:

       RUN pi-gerar-dados-extrato (INPUT 'Registro nao encontrado com atributo codFabric: ' + STRING(tt-item-fabric.cod-fabric) ).

       RUN pi-cria-mensagem (INPUT 404,
                             INPUT "REGISTRO_NAO_ENCONTRADO",
                             INPUT 'Registro nao encontrado com atributo codFabric: ' + STRING(tt-item-fabric.cod-fabric)). 
       NEXT.
    END.

    FIND FIRST item-fabric
         WHERE item-fabric.it-codigo  = tt-item-json.codItem
           AND item-fabric.cod-fabric = tt-item-fabric.cod-fabric 
    EXCLUSIVE-LOCK NO-ERROR.

    IF NOT AVAILABLE item-fabric THEN DO:

        RUN pi-gerar-dados-extrato ("CRIOU ITEM-FABRIC ").

        CREATE item-fabric.
        ASSIGN item-fabric.it-codigo  = tt-item-json.codItem
               item-fabric.cod-fabric = tt-item-fabric.cod-fabric.

        /*Criar campo em historico */
    END.
    
    ASSIGN item-fabric.it-fabric  = tt-item-fabric.it-fabric
           item-fabric.referencia = tt-item-fabric.referencia.

    RUN pi-gerar-dados-extrato ("item-fabric.it-codigo         - " +  STRING(item-fabric.it-codigo         ) ).
    RUN pi-gerar-dados-extrato ("item-fabric.cod-fabric        - " +  STRING(item-fabric.cod-fabric        ) ).
    RUN pi-gerar-dados-extrato ("item-fabric.it-fabric         - " +  STRING(item-fabric.it-fabric         ) ).
    RUN pi-gerar-dados-extrato ("item-fabric.referencia        - " +  STRING(item-fabric.referencia        ) ).

    RELEASE item-fabric.
END.       




/*
FIND FIRST int-item WHERE int-item.it-codigo =  tt-item-json.codItem  EXCLUSIVE-LOCK NO-ERROR.

IF AVAIL int-item THEN DO:

    //rodar o update record pra criar as informacoes da solar
    RUN esbo/boes372.p PERSISTENT SET h-boes372.
    RUN pi-gerar-dados-extrato ("DADOS SOLAR 2"  ).
    RUN openQueryStatic IN h-boes372(input "Main":U).
    RUN pi-gerar-dados-extrato ("DADOS SOLAR 3"  ).
    RUN goToKey         IN h-boes372 (INPUT int-item.it-codigo).
    RUN pi-gerar-dados-extrato ("DADOS SOLAR 4"  ).
    RUN emptyRowErrors IN h-boes372. 
    RUN pi-gerar-dados-extrato ("DADOS SOLAR 5"  ).
    RUN UpdateRecord   IN h-boes372.
    RUN pi-gerar-dados-extrato ("DADOS SOLAR 6"  ).
    //RUN getRowErrors   IN h-boes372 (OUTPUT TABLE RowErrors).
END.
*/

DELETE WIDGET-POOL.


RETURN "OK":U.

/**** Fim Programa  ****/

/*----------------------- Procedures Internas --------------------------------*/
PROCEDURE pi-valida:

    DEFINE VARIABLE c-tipo-fam     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-nova-familia AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i-cest         AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i-cod-erro     AS INTEGER   NO-UNDO.
    DEFINE VARIABLE c-destinatario AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-corpo        AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-erro-mail    AS CHARACTER NO-UNDO.

    FIND FIRST tt-item-json NO-ERROR.

    IF  NOT AVAIL tt-item-json THEN DO:
        RUN pi-gerar-dados-extrato (">> REGISTRO_NAO_ENCONTRADO").

        RUN pi-cria-mensagem (INPUT 404,
                              INPUT "REGISTRO_NAO_ENCONTRADO",
                              INPUT "Registro nao encontrado").
        RETURN 'NOK'.
    END.

    CASE tt-item-json.tipoItem:
      WHEN "33"   THEN ASSIGN tt-item-json.tipoItem = "DIVERSOS".
      WHEN "60"   THEN ASSIGN tt-item-json.tipoItem = "ITEM P/ SDCV".
      WHEN "12"   THEN ASSIGN tt-item-json.tipoItem = "MATERIA PRIMA CKD".
      WHEN "10"   THEN ASSIGN tt-item-json.tipoItem = "MATERIA PRIMA COMUM".
      WHEN "30"   THEN ASSIGN tt-item-json.tipoItem = "MATERIAL DE CONSUMO".
      WHEN "15"   THEN ASSIGN tt-item-json.tipoItem = "PECA DE REPOSICAO".
      //WHEN "40"   THEN ASSIGN tt-item-json.tipoItem = "PRODUTO P/ VENDA".
      WHEN "20"   THEN ASSIGN tt-item-json.tipoItem = "SEMIACABADO".
      WHEN "90"   THEN ASSIGN tt-item-json.tipoItem = "SERVICOS".
      WHEN "DESV" THEN ASSIGN tt-item-json.tipoItem = "PRODUTO EM DESENVOLVIMENTO".
      WHEN "42"   THEN ASSIGN tt-item-json.tipoItem = "Produto - CKD".
      //WHEN "45"   THEN ASSIGN tt-item-json.tipoItem = "Produto - E-commerce".
      WHEN "40"   THEN ASSIGN tt-item-json.tipoItem = "Gerador Solar".
      //WHEN "40"   THEN ASSIGN tt-item-json.tipoItem = "Produto - Nacional".
      WHEN "45"   THEN ASSIGN tt-item-json.tipoItem = "Produto - OEM".
      //WHEN "45"   THEN ASSIGN tt-item-json.tipoItem = "Produto - OEM c/ Retrabalho".
      //WHEN "45"   THEN ASSIGN tt-item-json.tipoItem = "Produto - Projetos Especiais".
      //WHEN "45"   THEN ASSIGN tt-item-json.tipoItem = "Produto - Verticais".
      WHEN "20"   THEN ASSIGN tt-item-json.tipoItem = "SemiAcabado - Processo Externo".
    END CASE. 

    CASE tt-item-json.ItemOrigin:
        WHEN "0" THEN ASSIGN tt-item-json.ItemOrigin2 = "Nacional".    /* Nacional, exceto as indicadas nos c¢digos 3, 4,5 e 8                                                                                                                                       */
        WHEN "1" THEN ASSIGN tt-item-json.ItemOrigin2 = "Estrangeira". /* Estrangeira - Importaá∆o direta, exceto a indicada no c¢digo 6                                                                                                                             */
        WHEN "2" THEN ASSIGN tt-item-json.ItemOrigin2 = "Estrangeira". /* Estrangeira - Adquirida no mercado interno, exceto a indicada no c¢digo 7                                                                                                                  */
        WHEN "3" THEN ASSIGN tt-item-json.ItemOrigin2 = "Nacional".    /* Nacional, mercadoria ou bem com Conte£do de Importaá∆o superior a 40% (quarenta por cento) e inferior ou igual a 70% (setenta por cento)                                                   */
        WHEN "4" THEN ASSIGN tt-item-json.ItemOrigin2 = "Nacional".    /* Nacional, cuja produá∆o tenha sido feita em conformidade com os processos produtivos b†sicos de que tratam o Decreto-Lei nß 288/67, e as Leis nßs 8.248/91, 8.387/91, 10.176/01 e 11.484/07*/
        WHEN "5" THEN ASSIGN tt-item-json.ItemOrigin2 = "Nacional".    /* Nacional, mercadoria ou bem com Conte£do de Importaá∆o inferior ou igual a 40% (quarenta por cento)                                                                                        */
        WHEN "6" THEN ASSIGN tt-item-json.ItemOrigin2 = "Estrangeira". /* Estrangeira - Importaá∆o direta, sem similar nacional, constante em lista de Resoluá∆o CAMEX e g†s natural                                                                                 */
        WHEN "7" THEN ASSIGN tt-item-json.ItemOrigin2 = "Estrangeira". /* Estrangeira - Adquirida no mercado interno, sem similar nacional, constante em lista de Resoluá∆o CAMEX e g†s natural                                                                      */
        WHEN "8" THEN ASSIGN tt-item-json.ItemOrigin2 = "Nacional".    /* Nacional, mercadoria ou bem com Conte£do de Importaá∆o superior a 70% (setenta por cento)                                                                                                  */
    END CASE.

    CASE tt-item-json.unNeg:
         WHEN 1   THEN ASSIGN tt-item-json.cod-unid-neg = "ADM".
         WHEN 3   THEN ASSIGN tt-item-json.cod-unid-neg = "TER".
         WHEN 4   THEN ASSIGN tt-item-json.cod-unid-neg = "SEC".
         WHEN 5   THEN ASSIGN tt-item-json.cod-unid-neg = "NET".
         WHEN 10  THEN ASSIGN tt-item-json.cod-unid-neg = "FIR".
         WHEN 11  THEN ASSIGN tt-item-json.cod-unid-neg = "AUT".
         WHEN 15  THEN ASSIGN tt-item-json.cod-unid-neg = "ENG".
         WHEN 16  THEN ASSIGN tt-item-json.cod-unid-neg = "ENS".
         WHEN 17  THEN ASSIGN tt-item-json.cod-unid-neg = "PRE".
         WHEN 18  THEN ASSIGN tt-item-json.cod-unid-neg = "DEC".
         WHEN 20  THEN ASSIGN tt-item-json.cod-unid-neg = "VRJ".
         WHEN 21  THEN ASSIGN tt-item-json.cod-unid-neg = "REN".
         WHEN 999 THEN ASSIGN tt-item-json.cod-unid-neg = "AST".
    END.

    IF  tt-item-json.tipoItem = 'SERVICOS' THEN
        ASSIGN tt-item-json.classFiscal = '00000000'.

    IF  tt-item-json.tipoItem = '' THEN DO:
        RUN pi-cria-mensagem (INPUT 412,
                              INPUT "ATRIBUTO_REQUERIDO",
                              INPUT 'Atributo requerido tipoItem:').

        RUN pi-gerar-dados-extrato ('Atributo requerido tipoItem:').
    END.

    IF  tt-item-json.origem > 9 THEN DO:
        RUN pi-cria-mensagem (INPUT 412,
                              INPUT "ATRIBUTO_INVALIDO",
                              INPUT 'Atributo invalido origem: ' + STRING(tt-item-json.origem)).

        RUN pi-gerar-dados-extrato ('Atributo invalido origem: ' + STRING(tt-item-json.origem)).
    END.

    /* Estabelec */
    FIND FIRST estabelec 
        WHERE estabelec.cod-estabel = tt-item-json.codEstabel NO-LOCK NO-ERROR.

    IF  NOT AVAIL estabelec THEN DO:
        RUN pi-cria-mensagem (INPUT 412,
                              INPUT "ATRIBUTO_INVALIDO",
                              INPUT "Atributo invalido codEstabel: " + tt-item-json.codEstabel ).

        RUN pi-gerar-dados-extrato ("Atributo invalido codEstabel: " + tt-item-json.codEstabel).
    END.

    FIND FIRST classif-fisc 
        WHERE classif-fisc.class-fiscal = tt-item-json.classFiscal NO-LOCK NO-ERROR.

    IF  NOT AVAIL classif-fisc THEN DO:
        RUN pi-cria-mensagem (INPUT 412,
                              INPUT "ATRIBUTO_INVALIDO",
                              INPUT "Atributo invalido classFiscal: " + tt-item-json.classFiscal).

        RUN pi-gerar-dados-extrato ("Atributo invalido classFiscal: " + tt-item-json.classFiscal).
    END.                                                                                         
   
    /* Unidade Negocio */
    FIND FIRST unid-negoc 
        WHERE unid-negoc.cod-unid-negoc = tt-item-json.cod-unid-neg NO-LOCK NO-ERROR.

    IF  NOT AVAIL unid-negoc THEN DO:
        RUN pi-cria-mensagem (INPUT 412,
                              INPUT "ATRIBUTO_INVALIDO",
                              INPUT "Atributo invalido unNeg: " + STRING(tt-item-json.unNeg)).

        RUN pi-gerar-dados-extrato ("Atributo invalido unNeg: " + STRING(tt-item-json.unNeg)).
    END.

    IF  tt-item-json.codItem = '' THEN DO:
        ASSIGN pTipoRequisicao = 1. //Inclusao

        FIND FIRST b-item
            WHERE b-item.desc-item    = tt-item-json.descItem
            AND   b-item.data-implant = TODAY NO-LOCK NO-ERROR.

        IF  AVAIL b-item THEN DO:
            /* Chamado: C2306-1968 - Caso j† exista item com a mesma descriá∆o implantado na data 
               de hoje deve ignorar esta criaá∆o e retornar para o wso2 como criado com sucesso */
            RUN pi-cria-mensagem (INPUT 200,
                                  INPUT b-item.it-codigo,
                                  INPUT "2.Item criado com Sucesso").

            RETURN "OK":U.
        END.
    END.
    ELSE
        ASSIGN pTipoRequisicao = 2. //Alteracao
  
    /* Inclusao */
    IF  pTipoRequisicao = 1 THEN DO:
        ASSIGN c-familia = SUBSTRING(tt-item-json.fmCodigo,1,3).
    
        /* Definir codigo Item */
        RUN esp/mssp/esmssp021.p (INPUT c-familia + "0001",
                                  OUTPUT TABLE tt-prod,
                                  OUTPUT TABLE tt-mensagem-aux).

        IF  NOT CAN-FIND(FIRST tt-prod) THEN DO:
            RUN pi-cria-mensagem (INPUT 412,
                                  INPUT "ATRIBUTO_INVALIDO",
                                  INPUT "Atributo invalido familiaMat: " + tt-item-json.fmCodigo).
       
            RUN pi-gerar-dados-extrato ("ERRO GERACAO COD.ITEM - RETORNO esmssp021").
            RUN pi-gerar-dados-extrato ("Atributo invalido familiaMat: " + tt-item-json.fmCodigo).
        END.

        FOR FIRST tt-prod BY tt-prod.it-codigo:
            ASSIGN tt-item-json.codItem = tt-prod.it-codigo.

            RUN pi-gerar-dados-extrato ("CODIGO GERADO ITEM: " + tt-item-json.codItem).
        END.
    
        ASSIGN l-faturavel = NO.
      
        ASSIGN c-nova-familia = tt-item-json.fmCodigo.
         
        /* Troca Familia Item Faturavel */
        IF  tt-item-json.faturavel THEN DO:
            ASSIGN l-faturavel = YES.
        
            RUN esp/es0018p.p (INPUT  'esapi025',
                               INPUT  3,
                               INPUT  0,
                               INPUT  "":U,
                               OUTPUT TABLE tt-prog-ponto).
          
            FOR EACH tt-prog-ponto:
                IF  INDEX(tt-item-json.classFiscal ,tt-prog-ponto.conteudo) <> 0 THEN
                    ASSIGN l-faturavel = NO.
            END.
          
            RUN pi-gerar-dados-extrato (">> TROCA.FAMILIA / TORNAR ITEM FATURAVEL ?? " + STRING(l-faturavel)).
                        
            IF  l-faturavel THEN DO:
                /* Verifica Regra Item*/
                ASSIGN c-ponto-faturavel = FnItemFaturavel(tt-item-json.leiInformatica,
                                                           estabelec.estado,
                                                           tt-item-json.pais-ori,
                                                           tt-item-json.grEstoque,
                                                           tt-item-json.origem,
                                                           tt-item-json.tipoItem,
                                                           tt-item-json.FmCodigo).
             
                IF  (tt-item-json.codItem >= '2880000' AND tt-item-json.codItem <= '2889999')
                OR  (tt-item-json.codItem >= '4000000' AND tt-item-json.codItem <= '4999999') THEN DO:
                    ASSIGN l-erro = NO.
      
                    RUN pi-atualiz-familia (INPUT tt-item-json.codItem, 
                                            INPUT estabelec.cod-estabel, 
                                            INPUT-OUTPUT c-nova-familia,
                                            INPUT tt-item-json.famComerc,
                                            INPUT tt-item-json.grEstoque,
                                            INPUT tt-item-json.classFiscal,
                                            OUTPUT l-erro). 
      
                 /* IF  l-erro THEN DO:
                        RUN pi-cria-mensagem (INPUT 412,
                                              INPUT "ATRIBUTO_INVALIDO",
                                              INPUT "Familia Tributaria nao configurada : " + tt-item-json.fmCodigo ).
                 
                        RUN pi-gerar-dados-extrato ("Familia Tributaria nao configurada : " + tt-item-json.fmCodigo).
                    END. */
                END.
            END.
        END.
      
        ASSIGN tt-item-json.fmCodigo = c-nova-familia.
                                        
        FIND FIRST familia 
            WHERE familia.fm-codigo = tt-item-json.fmCodigo NO-LOCK NO-ERROR.
       
        IF  NOT AVAIL familia THEN DO:
            RUN pi-cria-mensagem (INPUT 412,
                                  INPUT "ATRIBUTO_INVALIDO",
                                  INPUT "Atributo invalido familiaMat: " + tt-item-json.fmCodigo ).
        
            RUN pi-gerar-dados-extrato ("Atributo invalido familiaMat: " + tt-item-json.fmCodigo).
        END.
    END. /* pTipoRequisicao = 1 */
   
    /* Alteraá∆o */
    
    /* C2212-0320*/  
    IF  pTipoRequisicao = 2 THEN DO:
        IF  CAN-FIND(FIRST item WHERE item.it-codigo = tt-item-json.codItem AND 
                                    (item.cod-obsoleto = 3 OR /* Itens Obsoleto todas as ordens */
                                     item.cod-obsoleto = 4))  /* Totalmente Obsoleto */ THEN DO:                    
            RUN pi-cria-mensagem (INPUT 412,
                                  INPUT "ERRO_DE_VALIDACAO",
                                  INPUT "Item est† inativo e a integraá∆o n∆o foi realizada!" +                                                  
                                        "Solicite ao grupo.centraldecadastro@intelbras.com.br para ativar o item. Ap¢s a ativaá∆o o processo ser† conclu°do.").

            RUN pi-gerar-dados-extrato ("Item est† inativo e a integraá∆o n∆o foi realizada!").
        END.
    END.

    /* Item Solar */
    IF  tt-item-json.tipoItem = '40' THEN DO:
        FIND FIRST ped-venda 
            WHERE ped-venda.nr-pedcli = REPLACE(tt-item-json.ped-energia,'.','') NO-LOCK NO-ERROR.

        IF  NOT AVAIL ped-venda THEN DO:
            RUN pi-cria-mensagem (INPUT 412,
                                  INPUT "ATRIBUTO_INVALIDO",
                                  INPUT "Atributo invalido pedEnergia: " + STRING(tt-item-json.ped-energia)).

            RUN pi-gerar-dados-extrato ("Atributo invalido pedEnergia: " + STRING(tt-item-json.ped-energia)).
        END.
    END.


    IF  tt-item-json.tipoControle > 5 THEN DO:
        RUN pi-cria-mensagem (INPUT 412,
                              INPUT "ATRIBUTO_INVALIDO",
                              INPUT "Atributo invalido tipoControle: " + STRING(tt-item-json.tipoControle)).

        RUN pi-gerar-dados-extrato ("Atributo invalido tipoControle: " + STRING(tt-item-json.tipoControle)).
    END.                                                                                                    

    /*CHAMADO C2206-0904 - Leonam - 09/06/2022   */
    IF  pTipoRequisicao = 2 THEN DO: /* Alteracao */
        ASSIGN l-erro = NO.   
        
        FIND FIRST item 
            WHERE item.it-codigo = tt-item-json.codItem NO-LOCK NO-ERROR.
        
        FIND FIRST item-uni-estab 
             WHERE item-uni-estab.it-codigo   = tt-item-json.codItem
             AND   item-uni-estab.ind-item-fa NO-LOCK NO-ERROR.
        
        IF  AVAIL item THEN DO:
        
            IF  AVAIL item-uni-estab
            AND item-uni-estab.ind-item-fat THEN DO:
               
                IF  item.codigo-orig  <> tt-item-json.origem THEN 
                    ASSIGN i-cod-erro = 1
                           l-erro     = YES.
        
                IF  item.class-fiscal <> tt-item-json.classFiscal THEN 
                    ASSIGN i-cod-erro = 2
                           l-erro     = YES.
        
                ASSIGN i-cest = 0.
        
                FOR EACH sit-tribut-relacto
                    WHERE sit-tribut-relacto.cdn-tribut       = 11
                    AND   sit-tribut-relacto.cod-estab        = "*"
                    AND   sit-tribut-relacto.cod-natur-operac = "*"
                    AND   sit-tribut-relacto.cod-ncm          = "*"
                    AND   sit-tribut-relacto.cod-item         = tt-item-json.codItem
                    AND   sit-tribut-relacto.cdn-emitente     = 0 NO-LOCK:
                    ASSIGN i-cest = sit-tribut-relacto.cdn-sit-tribut.      
                END. 
        
                IF  i-cest <> 0 
                AND i-cest <> tt-item-json.cest THEN 
                    ASSIGN i-cod-erro = 3
                           l-erro     = YES.
                
                FIND FIRST int-item 
                    WHERE int-item.it-codigo = item.it-codigo NO-LOCK NO-ERROR.

                IF  tt-item-json.ex-ipi <> '' 
                AND tt-item-json.ex-ipi <> '0' THEN DO:
                    IF  AVAIL int-item THEN DO:
                        IF  int-item.exIPI <> item.class-fiscal + '-' + STRING(INT(tt-item-json.ex-ipi),'99' ) THEN 
                            ASSIGN i-cod-erro = 4
                                   l-erro     = YES.
                   END.
                END.
        
                IF  tt-item-json.aliquotaIPI <> 0 
                AND tt-item-json.aliquotaIPI <> item.aliquota-ipi THEN
                     ASSIGN i-cod-erro = 5
                            l-erro     = YES.
                
                IF  l-erro THEN DO:
                    RUN pi-gerar-dados-extrato ("Retorna Erro - alteracao: " + string(i-cod-erro)).
        
                    ASSIGN c-destinatario = ''.
        
                    RUN esp/es0018p.p (INPUT 'esapi025',
                                       INPUT 4,
                                       INPUT 0,
                                       INPUT "":U,
                                       OUTPUT TABLE tt-prog-ponto).
        
                    FOR EACH tt-prog-ponto:
                        IF  c-destinatario = '' THEN
                            ASSIGN c-destinatario = tt-prog-ponto.conteudo.
                        ELSE
                            ASSIGN c-destinatario = c-destinatario + ';' + tt-prog-ponto.conteudo.
                    END.   
        
                    ASSIGN c-corpo = "Item Ç Fatur†vel e n∆o permite alterar NCM, Origem, Cest, Al°quota Importaá∆o, Ex Tarifario, Al°quota IPI ou EX de IPI. Integraá∆o n∆o realizada. Entre em contato com o grupo tribut†rio para realizar a alteraá∆o." + CHR(13) + CHR(13).
        
                    CASE i-cod-erro:
                        WHEN 1 THEN
                           ASSIGN c-corpo = c-corpo + 'ORIGEM TOTVS:     ' + STRING(ITEM.codigo-orig) + CHR(13) +
                                                      'ORIGEM KLASSMATT: ' + STRING(tt-item-json.origem).
                        WHEN 2 THEN
                           ASSIGN c-corpo = c-corpo + 'NCM TOTVS:     ' + ITEM.class-fiscal + CHR(13) +
                                                      'NCM KLASSMATT: ' + tt-item-json.classFiscal.
                        WHEN 3 THEN
                           ASSIGN c-corpo = c-corpo + 'CEST TOTVS:     ' + STRING(i-cest) + CHR(13) +  
                                                      'CEST KLASSMATT: ' + STRING(tt-item-json.cest).  
                        WHEN 4 THEN
                           IF  AVAIL int-item THEN DO:
                               ASSIGN c-corpo = c-corpo + 'EX.IPI TOTVS:     ' + STRING(int-item.exIPI) + CHR(13) +  
                                                          'EX.IPI KLASSMATT: ' + STRING(ITEM.class-fiscal + '-' + STRING(INT(tt-item-json.ex-ipi),'99' )).
                           END.
                        WHEN 5 THEN
                           ASSIGN c-corpo = c-corpo + 'ALIQUOTA IPI TOTVS:     ' + string(item.aliquota-ipi) + CHR(13) +
                                                      'ALIQUOTA IPI KLASSMATT: ' + string(tt-item-json.aliquotaIPI).
                    END CASE. 
        
                    RUN pi-cria-mensagem (INPUT 412,
                                          INPUT "ERRO_DE_VALIDACAO",
                                          INPUT REPLACE(c-corpo,CHR(13),' - ') ).
        
                    RUN pi-email (INPUT c-destinatario,
                                  INPUT "Atualizacao Item Klassmatt Invalida - " + tt-item-json.codItem,
                                  INPUT c-corpo,
                                  OUTPUT c-erro-mail).
        
                    RUN pi-gerar-dados-extrato ("Destinatario Email: " + c-destinatario).
                    RUN pi-gerar-dados-extrato ("Corpo Email: " + c-corpo).
                    RUN pi-gerar-dados-extrato ("Erro Email: " + c-erro-mail).
                END.
            END.
        END.
    END.

    RUN pi-gerar-dados-extrato("FIM pi-valida").
END PROCEDURE.



PROCEDURE pi-integra-item:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  EMPTY TEMP-TABLE tt-erros-geral.     
  EMPTY TEMP-TABLE tt-item. 

  FIND FIRST estabelec 
      WHERE estabelec.cod-estabel = tt-item-json.codEstabel NO-LOCK NO-ERROR.
  
  RUN pi-gerar-dados-extrato (">> ENTROU pi-integra-item").
  
  /* Cria tabela temporaria tt-item */
  CREATE tt-item.
  ASSIGN tt-item.ind-tipo-movto = pTipoRequisicao
         tt-item.it-codigo      = tt-item-json.codItem
         tt-item.un             = tt-item-json.un
         tt-item.desc-item      = tt-item-json.descItem
         tt-item.desc-inter     = tt-item-json.desc-ingles
         tt-item.cod-estabel    = tt-item-json.codEstabel
         tt-item.class-fiscal   = tt-item-json.classFiscal
         tt-item.narrativa      = tt-item-json.narrativa
         tt-item.responsavel    = tt-item-json.usuario   
         tt-item.peso-liquido   = tt-item-json.pesoLiquido
         tt-item.peso-bruto     = tt-item-json.pesoBruto
         tt-item.comprim        = tt-item-json.comprim
         tt-item.largura        = tt-item-json.largura
         tt-item.altura         = tt-item-json.altura
         tt-item.cd-folh-item   = '1'  
         tt-item.ind-serv-mat   = IF tt-item-json.tipoItem = "SERVICOS" THEN 1 /*SERVICO*/ ELSE 2 /*MATERIAL*/
         tt-item.tipo-contr     = tt-item-json.tipoControle /*2 - Total */  
         tt-item.ge-codigo      = tt-item-json.grEstoque
         tt-item.contr-qualid   = tt-item-json.contrQualid
       /*tt-item.fraciona       = tt-item-json.fraciona*/
         tt-item.criticidade    = tt-item-json.criticidade
         tt-item.fm-cod-com     = tt-item-json.famComerc
         tt-item.perc-nqa       = tt-item-json.percNQA
         tt-item.cd-planejado   = "101" //tt-item-json.codEstabel   
         tt-item.reporte-ggf    = 2
         tt-item.aliquota-ipi   = tt-item-json.aliquotaIPI
         tt-item.desc-inter     = tt-item-json.desc-ingles.

  IF  pTipoRequisicao = 1 THEN 
      ASSIGN tt-item.fm-codigo    = tt-item-json.fmCodigo
             tt-item.ind-item-fat = tt-item-json.faturavel.

  IF  pTipoRequisicao = 2 THEN DO:
      FIND FIRST item-uni-estab
           WHERE item-uni-estab.it-codigo   = tt-item.it-codigo
           AND   item-uni-estab.cod-estabel = tt-item.cod-estabel NO-LOCK NO-ERROR.

      IF  AVAIL item-uni-estab THEN
          ASSIGN tt-item.nr-linha = item-uni-estab.nr-linha.
  END.
  
   //Alteracao
  IF  pTipoRequisicao = 2 THEN DO:
      /* Nao mudar familia na alteracao */
      /* Nao mudar data implantacao na alteracao */
      /* Nao mudar item faturavel na alteracao */
      FIND FIRST item 
          WHERE item.it-codigo = tt-item.it-codigo NO-LOCK NO-ERROR.

      IF  AVAIL item THEN DO:
          ASSIGN tt-item.fm-codigo    = item.fm-codigo
                 tt-item.data-implant = item.data-implant
                 tt-item.data-liberac = item.data-liberac
                 tt-item.ind-item-fat = item.ind-item-fat.
        
          /* C2212-0320 */
          /*
          if  item.cod-obsoleto = 3 OR /* Obsoleto todas as Ordens    */
              item.cod-obsoleto = 4    /* Obsoleto Ordens Automaticas */ THEN DO:
              ASSIGN tt-item.cod-obsoleto = 1.
          END.
          ELSE */
          
          ASSIGN tt-item.cod-obsoleto = item.cod-obsoleto.

          RELEASE ITEM.
      END.
  END.

  IF  tt-item-json.tipoItem = 'SERVICOS' THEN
      ASSIGN tt-item.tipo-contr = 4.  /* Debito Direto */

  /* Verifica Regra Item*/
  ASSIGN c-ponto-faturavel = FnItemFaturavel(tt-item-json.leiInformatica,
                                             estabelec.estado,
                                             tt-item-json.pais-ori,
                                             tt-item-json.grEstoque,
                                             tt-item-json.origem,
                                             tt-item-json.tipoItem,
                                             tt-item-json.FmCodigo).
    
  RUN pi-gerar-dados-extrato ('TIPO MOVTO: '              + STRING(pTipoRequisicao       )). 
  RUN pi-gerar-dados-extrato ("REGRA ITEM FATURAVEL :   " + STRING(c-ponto-faturavel     )).
  RUN pi-gerar-dados-extrato ("TIPO ITEM   -            " + STRING(tt-item-json.tipoItem )).
  RUN pi-gerar-dados-extrato ("tt-item.class-fiscal   - " + STRING(tt-item.class-fiscal  )).

  RUN pi-gerar-dados-extrato ("tt-item.ind-tipo-movt   - " + STRING(tt-item.ind-tipo-movt)).
  RUN pi-gerar-dados-extrato ("tt-item.it-codigo       - " + STRING(tt-item.it-codigo    )).
  RUN pi-gerar-dados-extrato ("tt-item.un              - " + STRING(tt-item.un           )).
  RUN pi-gerar-dados-extrato ("tt-item.desc-item       - " + STRING(tt-item.desc-item    )).
  RUN pi-gerar-dados-extrato ("tt-item.desc-inter      - " + STRING(tt-item.desc-inter   )).
  RUN pi-gerar-dados-extrato ("tt-item.cod-estabel     - " + STRING(tt-item.cod-estabel  )).
  RUN pi-gerar-dados-extrato ("tt-item.class-fiscal    - " + STRING(tt-item.class-fiscal )).
  RUN pi-gerar-dados-extrato ("tt-item.narrativa       - " + STRING(tt-item.narrativa    )).
  RUN pi-gerar-dados-extrato ("tt-item.responsavel     - " + STRING(tt-item.responsavel  )).
  RUN pi-gerar-dados-extrato ("tt-item.peso-liquido    - " + STRING(tt-item.peso-liquido )).
  RUN pi-gerar-dados-extrato ("tt-item.peso-bruto      - " + STRING(tt-item.peso-bruto   )).
  RUN pi-gerar-dados-extrato ("tt-item.comprim         - " + STRING(tt-item.comprim      )).
  RUN pi-gerar-dados-extrato ("tt-item.largura         - " + STRING(tt-item.largura      )).
  RUN pi-gerar-dados-extrato ("tt-item.altura          - " + STRING(tt-item.altura       )).
  RUN pi-gerar-dados-extrato ("tt-item.cd-folh-item    - " + STRING(tt-item.cd-folh-item )).
  RUN pi-gerar-dados-extrato ("tt-item.ind-serv-mat    - " + STRING(tt-item.ind-serv-mat )).
  RUN pi-gerar-dados-extrato ("tt-item.tipo-contr      - " + STRING(tt-item.tipo-contr   )).
  RUN pi-gerar-dados-extrato ("tt-item.ge-codigo       - " + STRING(tt-item.ge-codigo    )).
  RUN pi-gerar-dados-extrato ("tt-item.contr-qualid    - " + STRING(tt-item.contr-qualid )).
  RUN pi-gerar-dados-extrato ("tt-item.fraciona        - " + STRING(tt-item.fraciona     )).
  RUN pi-gerar-dados-extrato ("tt-item.criticidade     - " + STRING(tt-item.criticidade  )).
  RUN pi-gerar-dados-extrato ("tt-item.fm-cod-com      - " + STRING(tt-item.fm-cod-com   )).
  RUN pi-gerar-dados-extrato ("tt-item.perc-nqa        - " + STRING(tt-item.perc-nqa     )).
  RUN pi-gerar-dados-extrato ("tt-item.cd-planejado    - " + STRING(tt-item.cd-planejado )).
  RUN pi-gerar-dados-extrato ("tt-item.reporte-ggf     - " + STRING(tt-item.reporte-ggf  )).
  RUN pi-gerar-dados-extrato ("tt-item.aliquota-ipi    - " + STRING(tt-item.aliquota-ipi )).
  RUN pi-gerar-dados-extrato ("tt-item.desc-inter      - " + STRING(tt-item.desc-inter   )).
  RUN pi-gerar-dados-extrato ("tt-item.ind-item-fat    - " + STRING(tt-item.ind-item-fat )).
  RUN pi-gerar-dados-extrato ("tt-item.fm-codigo       - " + STRING(tt-item.fm-codigo    )).
  RUN pi-gerar-dados-extrato ("tt-item.nr-linha        - " + STRING(tt-item.nr-linha     )).

  RUN pi-gerar-dados-extrato (">> ANTES cdp/cdapi344.p ").

  RUN cdp/cdapi344.p (INPUT        TABLE tt-versao-integr,
                      OUTPUT       TABLE tt-erros-geral,
                      INPUT-OUTPUT TABLE tt-item).

  RUN pi-gerar-dados-extrato (">> DEPOIS cdp/cdapi344.p ").

  IF  CAN-FIND(FIRST tt-erros-geral) THEN DO:

      FOR EACH tt-erros-geral:
          RUN pi-gerar-dados-extrato (">> ERRO API CRIA ITEM cdapi344 => " + STRING(tt-erros-geral.des-erro) + '(' + STRING(tt-erros-geral.cod-erro) + ')').
          
          IF  tt-erros-geral.cod-erro = 3662
          AND tt-erros-geral.des-erro BEGINS "Tipo Controle deve estar" THEN
              RUN pi-cria-mensagem (INPUT 412,
                                    INPUT "ERRO_DE_VALIDACAO",
                                    INPUT STRING(tt-erros-geral.des-erro) + ' (1-F°sico, 2-Total, 3-Consignado, 4-DÇbito Direto, 5-N∆o Definido) ' + '(' + STRING(tt-erros-geral.cod-erro) + ')' ).
          ELSE
              RUN pi-cria-mensagem (INPUT 412,
                                    INPUT "ERRO_DE_VALIDACAO",
                                    INPUT STRING(tt-erros-geral.des-erro) + '(' + STRING(tt-erros-geral.cod-erro) + ')' ).
      END.
  
      RETURN 'NOK'.
  END. 

  RETURN 'OK'.

END PROCEDURE.


PROCEDURE pi-efetiva-distribuicao:
  EMPTY TEMP-TABLE tt-item-alt.
  EMPTY TEMP-TABLE tt-erros-geral.  

  CREATE tt-item-alt.
  BUFFER-COPY tt-item EXCEPT cod-erro des-erro ind-tipo-movto TO tt-item-alt.
  BUFFER-COPY item EXCEPT it-codigo un desc-item cod-estabel fm-codigo class-fiscal narrativa 
                          responsavel peso-liquido peso-bruto comprim largura altura cd-folh-item ind-serv-mat 
                          tipo-contr ge-codigo contr-qualid fraciona criticidade fm-cod-com perc-nqa reporte-ggf TO tt-item-alt.

  ASSIGN tt-item-alt.ind-tipo-movto = 2.

  RUN cdp/cdapi306.p (INPUT        TABLE tt-versao-integr,
                      OUTPUT       TABLE tt-erros-geral,
                      INPUT-OUTPUT TABLE tt-item-alt).

  IF  CAN-FIND(FIRST tt-erros-geral) THEN DO:
      FOR EACH tt-erros-geral:
          RUN pi-gerar-dados-extrato (">> ERRO API cdapi306 => " + STRING(tt-erros-geral.des-erro) + '(' + STRING(tt-erros-geral.cod-erro) + ')').

          RUN pi-cria-mensagem (INPUT 412,
                                INPUT "ERRO_DE_VALIDACAO",
                                INPUT STRING(tt-erros-geral.des-erro) + '(' + STRING(tt-erros-geral.cod-erro) + ')' ).
      END.                                                  
  
      RETURN 'NOK'.
  END.

  RETURN 'OK'.
END PROCEDURE.



PROCEDURE pi-atualiza-dados-item:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  RUN pi-gerar-dados-extrato ("ENTROU pi-atualiza-dados-item -TESTANDO " + STRING(TODAY)).           
  
  FIND FIRST b01-item 
      WHERE b01-item.it-codigo = item.it-codigo EXCLUSIVE-LOCK NO-ERROR.
  
  IF  AVAIL b01-item THEN DO:

      RUN pi-gerar-dados-extrato ( "tt-item-json.faturavel - " + STRING(tt-item-json.faturavel)).
      
      ASSIGN b01-item.desc-inter             = tt-item-json.desc-ingles
             b01-item.comprim                = tt-item-json.comprim 
             b01-item.largura                = tt-item-json.largura 
             b01-item.altura                 = tt-item-json.altura
             b01-item.class-fiscal           = tt-item-json.classFiscal 
             /*b01-item.fm-codigo              = tt-item-json.fmCodigo  C2205-1254 */ 
             b01-item.fm-cod-com             = tt-item-json.famComerc
             b01-item.codigo-orig            = tt-item-json.origem
             b01-item.log-necessita-li       = tt-item-json.necessitaLI.
    
      IF  pTipoRequisicao = 1 THEN
          ASSIGN b01-item.ind-item-fat       = tt-item-json.faturavel.
      
      FIND FIRST classif-fisc WHERE classif-fisc.class-fiscal =  b01-item.class-fiscal NO-LOCK NO-ERROR.

      RUN pi-gerar-dados-extrato ('avail class-fiscal  ' + STRING(AVAIL classif-fisc)).

      IF  AVAIL classif-fisc THEN DO:
         /* Nacional */
         ASSIGN OVERLAY(b01-item.char-2, 31, 5) = STRING( classif-fisc.dec-1 /*classif-fisc.val-aliq-ext-pis*/    ,"99.99":U)
                OVERLAY(b01-item.char-2, 36, 5) = STRING( classif-fisc.dec-2 /*classif-fisc.val-aliq-ext-cofins*/ ,"99.99":U).

         /* Importado */ 
         ASSIGN OVERLAY(b01-item.char-2,74,5)  = STRING(classif-fisc.val-aliq-ext-pis   ,"99.99":U) 
                OVERLAY(b01-item.char-2,79,5)  = STRING(classif-fisc.val-aliq-ext-cofins,"99.99":U).

         RUN pi-gerar-dados-extrato ("ALIQUOTA CLASSIF >>> " ).
                
         IF  SUBSTRING(classif-fisc.char-1,1,5) <> '' THEN DO:
             /* C2403-3344 - evitar o erro "** Invalid character in numeric input 0. (76)". */
             ASSIGN v_aliq_chr = SUBSTRING(classif-fisc.char-1,1,6).
            
             DO  v_cont = 1 TO 6:
                 IF  SUBSTR(v_aliq_chr,v_cont,1) = "" THEN
                     LEAVE.
            
                 ASSIGN v_aux_aliq = v_aux_aliq + SUBSTR(v_aliq_chr,v_cont,1).
             END.
             /* C2403-3344 - evitar o erro "** Invalid character in numeric input 0. (76)". */

             ASSIGN OVERLAY(b01-item.char-2, 22, 6) = STRING(dec(TRIM(SUBSTRING(v_aux_aliq,1,6))),"999.99":U).
         END.
      END.
       
      ASSIGN OVERLAY(b01-item.char-2,22,6) = STRING(tt-item-json.aliquotaII,"999.99":U).

      RUN pi-gerar-dados-extrato ("ALIQUOTA ITEM 1 >>> " + SUBSTRING(b01-item.char-2, 22, 6)).

      IF  tt-item-json.exTarifario <> '' AND tt-item-json.exTarifario <> '0' THEN DO:
         /* Importacao */                        
          ASSIGN OVERLAY(b01-item.char-2, 22, 6) = STRING(tt-item-json.aliquotaII,"999.99":U).
      END.

      RUN pi-gerar-dados-extrato ("ALIQUOTA ITEM 2 >>> " + SUBSTRING(b01-item.char-2, 22, 6)).
    
      ASSIGN b01-item.peso-liquido = tt-item-json.pesoLiquido
             b01-item.peso-bruto   = tt-item-json.pesoBruto
             b01-item.aliquota-ipi = tt-item-json.aliquotaIPI
             b01-item.usuario-alt  = tt-item-json.usuario.
             //b01-item.cod-servico  = INT(tt-item-json.lei-116).

      ASSIGN OVERLAY(b01-item.char-1,321,1) = '1'. /* Ft Conv Unidade Tributavel */

      IF  AVAIL classif-fis THEN DO:        
          IF  classif-fis.aliquota-ipi <> b01-item.aliquota-ipi THEN            
              ASSIGN b01-item.ind-ipi-dife = YES.        
          ELSE  
              ASSIGN b01-item.ind-ipi-dife = NO.    
      END.

      IF  AVAIL classif-fis THEN 
         RUN pi-gerar-dados-extrato ("classif-fis.aliquota-ipi >>> " + STRING(classif-fis.aliquota-ipi)).

      RUN pi-gerar-dados-extrato (" b01-item.aliquota-ipi >>> " + STRING( b01-item.aliquota-ipi)).
      RUN pi-gerar-dados-extrato (" b01-item.ind-ipi-dife >>> " + STRING( b01-item.ind-ipi-dife)).

      IF  tt-item-json.narrativa-manaus <> '' THEN
          ASSIGN b01-item.narrativa = b01-item.narrativa + "#MANAUS#" + tt-item-json.narrativa-manaus.   
     
      FIND FIRST unid-negoc 
          WHERE unid-negoc.cod-unid-negoc = tt-item-json.cod-unid-neg NO-LOCK NO-ERROR.
    
      IF  AVAIL unid-negoc THEN DO:
          ASSIGN b01-item.cod-unid-negoc = unid-negoc.cod-unid-negoc.
    
          FOR EACH item-uni-estab NO-LOCK
              WHERE item-uni-estab.it-codigo = tt-item-json.codItem:

              FIND FIRST b01-item-uni-estab EXCLUSIVE-LOCK
                   WHERE b01-item-uni-estab.it-codigo   = tt-item-json.codItem
                   AND   b01-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel NO-ERROR.
           
              IF  AVAIL b01-item-uni-estab THEN DO:
                  ASSIGN b01-item-uni-estab.cod-unid-negoc = unid-negoc.cod-unid-negoc.
                  RELEASE b01-item-uni-estab.
              END.

              RUN pi-gerar-dados-extrato ("item-uni-estab.it-codigo      - " +  STRING(item-uni-estab.it-codigo      ) ).
              RUN pi-gerar-dados-extrato ("item-uni-estab.cod-unid-negoc - " +  STRING(item-uni-estab.cod-unid-negoc ) ).
          END.
      END.
     
      RUN pi-gerar-dados-extrato ("ALIQUOTA ITEM 3 >>> " + SUBSTRING(b01-item.char-2, 22, 6)).

      RUN pi-gerar-dados-extrato ("b01-item.fm-codigo         - " +  STRING(b01-item.fm-codigo        )).
      RUN pi-gerar-dados-extrato ("b01-item.fm-cod-com        - " +  STRING(b01-item.fm-cod-com       )).
      RUN pi-gerar-dados-extrato ("b01-item.codigo-orig       - " +  STRING(b01-item.codigo-orig      )).
      RUN pi-gerar-dados-extrato ("b01-item.ind-item-fat      - " +  STRING(b01-item.ind-item-fat     )).
      RUN pi-gerar-dados-extrato ("b01-item.log-necessita-li  - " +  STRING(b01-item.log-necessita-li )).
      RUN pi-gerar-dados-extrato ("PIS    Nacional  - OVERLAY(b01-item.char-2, 31, 5) - " + SUBSTRING(b01-item.char-2, 31, 5) ).
      RUN pi-gerar-dados-extrato ("COFINS Nacional  - OVERLAY(b01-item.char-2, 36, 5) - " + SUBSTRING(b01-item.char-2, 36, 5) ).
      RUN pi-gerar-dados-extrato ("PIS    Importado - OVERLAY(b01-item.char-2,74,5)   - " + SUBSTRING(b01-item.char-2,74,5)   ).
      RUN pi-gerar-dados-extrato ("COFINS Importado - OVERLAY(b01-item.char-2,79,5)   - " + SUBSTRING(b01-item.char-2,79,5)   ).
      RUN pi-gerar-dados-extrato ("Aliq Importacao  - OVERLAY(b01-item.char-2, 22, 6) - " + SUBSTRING(b01-item.char-2, 22, 6) ).
      RUN pi-gerar-dados-extrato ("b01-item.peso-liquido         - " +  STRING(b01-item.peso-liquido         ) ).
      RUN pi-gerar-dados-extrato ("b01-item.peso-bruto           - " +  STRING(b01-item.peso-bruto           ) ).
      RUN pi-gerar-dados-extrato ("b01-item.class-fiscal         - " +  STRING(b01-item.class-fiscal         ) ).
      RUN pi-gerar-dados-extrato ("b01-item.aliquota-ipi         - " +  STRING(b01-item.aliquota-ipi         ) ).
      RUN pi-gerar-dados-extrato ("b01-item.usuario-alt          - " +  STRING(b01-item.usuario-alt          ) ).
      RUN pi-gerar-dados-extrato ("b01-item.cod-servico          - " +  STRING(b01-item.cod-servico          ) ).         
      RUN pi-gerar-dados-extrato ("b01-item.cod-unid-negoc       - " +  STRING(b01-item.cod-unid-negoc       ) ).
      RUN pi-gerar-dados-extrato ("b01-item.narrativa            - " +  STRING(b01-item.narrativa            ) ).

      IF b01-item.it-codigo BEGINS "226"  OR
         b01-item.it-codigo BEGINS "227"  OR
         b01-item.it-codigo BEGINS "228"  OR
         b01-item.it-codigo BEGINS "453"  OR 
         b01-item.it-codigo BEGINS "4680" OR
         b01-item.it-codigo BEGINS "998" AND (b01-item.cod-unid-negoc = "DEC" OR b01-item.cod-unid-negoc = "TER") OR
         b01-item.it-codigo BEGINS "229" AND (b01-item.cod-unid-negoc = "DEC") OR 
         b01-item.it-codigo BEGINS "468" AND b01-item.cod-unid-negoc = "TER" THEN
         ASSIGN b01-item.ind-imp-desc = 6.

      RELEASE b01-item.
  END.

  RUN pi-gerar-dados-extrato ("PASSOU 1 "  ).
  
  FIND FIRST item-mat WHERE item-mat.it-codigo = tt-item-json.codItem EXCLUSIVE-LOCK NO-ERROR.

  IF  AVAIL item-mat THEN DO:

      /*ASSIGN item-mat.val-aliq-ext-pis    = tt-item-json.aliquotaPIS
             item-mat.val-aliq-ext-cofins   = tt-item-json.aliquotaCOFINS.

      IF tt-item-json.exTarifario <> '' THEN DO:
         FIND FIRST classif-fisc WHERE classif-fisc.class-fiscal =  b01-item.class-fiscal NO-LOCK NO-ERROR.
      
         IF AVAIL classif-fisc THEN
            ASSIGN item-mat.val-aliq-ext-pis    = classif-fisc.val-aliq-ext-pis
                   item-mat.val-aliq-ext-cofins = classif-fisc.val-aliq-ext-cofins.
      END.*/

      FIND FIRST classif-fisc 
          WHERE classif-fisc.class-fiscal =  ITEM.class-fiscal NO-LOCK NO-ERROR.
      
      IF  AVAIL classif-fisc THEN DO:
          ASSIGN item-mat.val-aliq-ext-pis    = classif-fisc.val-aliq-ext-pis    
                 item-mat.val-aliq-ext-cofins = classif-fisc.val-aliq-ext-cofins.
      
          RUN pi-gerar-dados-extrato ("item-mat.val-aliq-ext-pis     - " +  STRING(item-mat.val-aliq-ext-pis     ) ).
          RUN pi-gerar-dados-extrato ("item-mat.val-aliq-ext-cofins  - " +  STRING(item-mat.val-aliq-ext-cofins  ) ).
      END.

      RELEASE item-mat.
  END.
  

  RUN pi-gerar-dados-extrato ("PASSOU 2 "  ).
  
  /*
  /*gravar aqui char-2 e char-1*/
  IF tt-item-json.tipoItem <> "x" THEN DO: //Isac - Questionar 
     FIND FIRST ITEM EXCLUSIVE-LOCK 
          WHERE ITEM.it-codigo = tt-item.it-codigo  NO-ERROR.
     IF  AVAIL ITEM THEN DO:
         ASSIGN OVERLAY(ITEM.char-2,212,1) = tt-item-json.tipoItem.
         ASSIGN ITEM.cd-planejado = tt-item-json.cdPlanejador.
         ASSIGN ITEM.desc-inter   = tt-item-json.desc-ingles.
     END.
     ELSE DO:
         CREATE tt-mensagem-2.
         ASSIGN tt-mensagem-2.tip-msgs = 1
                tt-mensagem-2.mensagem = "Item cadastrado n∆o foi localizado!".
         STOP.
     END.

     FOR EACH  item-uni-estab EXCLUSIVE-LOCK
         WHERE item-uni-estab.it-codigo = tt-item.it-codigo:
         ASSIGN OVERLAY(item-uni-estab.char-1,133,1) = tt-item-json.tipoItem.
     END.
  END.*/

  

  IF  pTipoRequisicao = 2 /* Alteraá∆o */ THEN DO:
      FOR EACH  item-fabric NO-LOCK
          WHERE item-fabric.it-codigo = tt-item-json.codItem:
      
          FIND FIRST b01-item-fabric EXCLUSIVE-LOCK 
               WHERE b01-item-fabric.it-codigo = tt-item-json.codItem NO-ERROR.
      
          IF  AVAIL b01-item-fabric THEN DO:
              DELETE b01-item-fabric.
          END.
      END.

      FOR EACH item-proj-suframa NO-LOCK
          WHERE item-proj-suframa.it-codigo = tt-item-json.codItem:

          FIND FIRST b01-item-proj-suframa EXCLUSIVE-LOCK
               WHERE b01-item-proj-suframa.it-codigo = tt-item-json.codItem NO-ERROR.

          IF  AVAIL b01-item-proj-suframa THEN DO:
              DELETE b01-item-proj-suframa.
          END.
      END.
  END.
   
  /*
  RUN pi-gerar-dados-extrato ("PASSOU 3 "  ).

  FOR EACH tt-item-fabric:
      FIND FIRST fabricante WHERE fabricante.cod-fabric = tt-item-fabric.cod-fabric NO-LOCK NO-ERROR.

      IF NOT AVAILABLE fabricante THEN DO:

         RUN pi-gerar-dados-extrato (INPUT 'Registro nao encontrado com atributo codFabric: ' + STRING(tt-item-fabric.cod-fabric) ).

         RUN pi-cria-mensagem (INPUT 404,
                               INPUT "REGISTRO_NAO_ENCONTRADO",
                               INPUT 'Registro nao encontrado com atributo codFabric: ' + STRING(tt-item-fabric.cod-fabric)). 
         NEXT.
      END.

      FIND FIRST item-fabric
           WHERE item-fabric.it-codigo  = tt-item-json.codItem
             AND item-fabric.cod-fabric = tt-item-fabric.cod-fabric 
      EXCLUSIVE-LOCK NO-ERROR.

      IF NOT AVAILABLE item-fabric THEN DO:
          CREATE item-fabric.
          ASSIGN item-fabric.it-codigo  = tt-item-json.codItem
                 item-fabric.cod-fabric = tt-item-fabric.cod-fabric.

          /*Criar campo em historico */
      END.
      
      ASSIGN item-fabric.it-fabric  = tt-item-fabric.it-fabric
             item-fabric.referencia = tt-item-fabric.referencia.

      RUN pi-gerar-dados-extrato ("item-fabric.it-codigo         - " +  STRING(item-fabric.it-codigo         ) ).
      RUN pi-gerar-dados-extrato ("item-fabric.cod-fabric        - " +  STRING(item-fabric.cod-fabric        ) ).
      RUN pi-gerar-dados-extrato ("item-fabric.it-fabric         - " +  STRING(item-fabric.it-fabric         ) ).
      RUN pi-gerar-dados-extrato ("item-fabric.referencia        - " +  STRING(item-fabric.referencia        ) ).

      RELEASE item-fabric.

  END.       

  RUN pi-gerar-dados-extrato ("PASSOU 4 "  ).*/

  
  FIND FIRST int-item 
      WHERE int-item.it-codigo = item.it-codigo EXCLUSIVE-LOCK NO-ERROR.

  IF  NOT AVAIL int-item THEN DO:
      CREATE int-item.
      ASSIGN int-item.it-codigo     = tt-item-json.codItem
            int-item.fm-codigo-ori = tt-item-json.fmCodigoOri. /* Salva a Familia Original vinda do Klassmatt */
  END.

  ASSIGN int-item.destaque        = tt-item-json.destaqNCM   
         int-item.perc-gatt       = tt-item-json.percGATT                                    
         int-item.log-gatt        = tt-item-json.percGATT  <> 0                              
         int-item.nve             = tt-item-json.nve                                         
         int-item.log-antidumping = tt-item-json.antidumping                                 
         int-item.obs-antidumping = tt-item-json.obsAntidumping.

  /*
  IF tt-item-json.seqSuframa <> '' THEN
     ASSIGN int-item.seq-suframa = tt-item-json.seqSuframa.*/

  RUN pi-gerar-dados-extrato ("tt-item-json.seqSuframa ; aqui  - " +  STRING(tt-item-json.seqSuframa) ).

  //NOVO
  ASSIGN int-item.desc-completa  = tt-item-json.desc-comp-item            
         int-item.desc-venda     = tt-item-json.desc-venda                
         int-item.tipo           = tt-item-json.tipo-ex                   
         int-item.ato-legal      = tt-item-json.ato-legal-ex              
         int-item.ato-numerico   = tt-item-json.ato-num-ex                
         int-item.orgao-emis     = tt-item-json.orgao-emis-ex             
         int-item.ano            = tt-item-json.ano-ex                    
         int-item.nr-ped-energia = REPLACE(tt-item-json.ped-energia,'.','').

  ASSIGN int-item.ex-tarifario = 'NA'
         int-item.exIPI        = 'NA'.
  
  IF  tt-item-json.exTarifario <> '' AND tt-item-json.exTarifario <> '0' THEN
      ASSIGN int-item.ex-tarifario = item.class-fiscal + '-' + STRING(INT(tt-item-json.exTarifario),'999' ).   
  
  IF  tt-item-json.ex-ipi <> '' AND tt-item-json.ex-ipi <> '0' THEN
      ASSIGN int-item.exIPI = item.class-fiscal + '-' + STRING(INT(tt-item-json.ex-ipi),'99' ).
  
  RUN pi-gerar-dados-extrato ("PASSOU 5 "  ).

  IF  AVAIL int-item THEN DO:
      RUN pi-gerar-dados-extrato ("int-item.destaque             - " +  STRING(int-item.destaque             ) ).
      RUN pi-gerar-dados-extrato ("int-item.perc-gatt            - " +  STRING(int-item.perc-gatt            ) ).
      RUN pi-gerar-dados-extrato ("int-item.log-gatt             - " +  STRING(int-item.log-gatt             ) ).
      RUN pi-gerar-dados-extrato ("int-item.ex-tarifario         - " +  STRING(int-item.ex-tarifario         ) ).
      RUN pi-gerar-dados-extrato ("int-item.nve                  - " +  STRING(int-item.nve                  ) ).
      RUN pi-gerar-dados-extrato ("int-item.log-antidumping      - " +  STRING(int-item.log-antidumping      ) ).
      RUN pi-gerar-dados-extrato ("int-item.obs-antidumping      - " +  STRING(int-item.obs-antidumping      ) ).
      RUN pi-gerar-dados-extrato ("int-item.seq-suframa          - " +  STRING(int-item.seq-suframa          ) ).
      RUN pi-gerar-dados-extrato ("int-item.desc-completa        - " +  STRING(int-item.desc-completa        ) ).
      RUN pi-gerar-dados-extrato ("int-item.desc-venda           - " +  STRING(int-item.desc-venda           ) ).
      RUN pi-gerar-dados-extrato ("int-item.tipo                 - " +  STRING(int-item.tipo                 ) ).
      RUN pi-gerar-dados-extrato ("int-item.ato-legal            - " +  STRING(int-item.ato-legal            ) ).
      RUN pi-gerar-dados-extrato ("int-item.ato-numerico         - " +  STRING(int-item.ato-numerico         ) ).
      RUN pi-gerar-dados-extrato ("int-item.orgao-emis           - " +  STRING(int-item.orgao-emis           ) ).
      RUN pi-gerar-dados-extrato ("int-item.ano                  - " +  STRING(int-item.ano                  ) ).
      RUN pi-gerar-dados-extrato ("int-item.nr-ped-energia       - " +  STRING(int-item.nr-ped-energia       ) ).
      RUN pi-gerar-dados-extrato ("tt-item-json.ex-ipi           - " +  STRING(tt-item-json.ex-ipi           ) ).
  END.

  RUN pi-gerar-dados-extrato ("PASSOU 6 "  ).


  FOR EACH tt-proj-suframa
      WHERE tt-proj-suframa.nr-projeto <> 0:
      
      FIND FIRST item-proj-suframa
           WHERE item-proj-suframa.it-codigo  = tt-item-json.codItem
           AND   item-proj-suframa.nr-projeto = tt-proj-suframa.nr-projeto EXCLUSIVE-LOCK NO-ERROR.

      IF  NOT AVAIL item-proj-suframa THEN DO:
          CREATE item-proj-suframa.
          ASSIGN item-proj-suframa.it-codigo  = tt-item-json.codItem           
                 item-proj-suframa.nr-projeto = tt-proj-suframa.nr-projeto.
      END.

      ASSIGN item-proj-suframa.controlado = tt-proj-suframa.controlado.

      IF  AVAIL int-item THEN
          ASSIGN int-item.seq-suframa = STRING(tt-proj-suframa.seq-suframa).
     
      RUN pi-gerar-dados-extrato ("avail int-item:" + STRING(AVAIL int-item)).
      RUN pi-gerar-dados-extrato ("itt-proj-suframa.seq-suframa ; NEW   - " +  STRING(tt-proj-suframa.seq-suframa) ).
      RUN pi-gerar-dados-extrato ("item-proj-suframa.it-codigo   - " +  STRING(item-proj-suframa.it-codigo   ) ).
      RUN pi-gerar-dados-extrato ("item-proj-suframa.nr-projeto  - " +  STRING(item-proj-suframa.nr-projeto  ) ).
      RUN pi-gerar-dados-extrato ("item-proj-suframa.controlado  - " +  STRING(item-proj-suframa.controlado  ) ).
       
      RELEASE int-item.
      RELEASE item-proj-suframa.
  END. 

  RUN esp/mssp/esmsspapi001.p PERSISTENT SET h-esmsspapi001.

  ASSIGN c-mensagem = "".

  RUN pi-gerar-dados-extrato("ANTES piGeraRelactoCest IN h-esmsspapi001 ").

  RUN piGeraRelactoCest IN h-esmsspapi001 (INPUT tt-item-json.cest, /* CEST */
                                           INPUT TODAY,             /* Data inicio validade */
                                           INPUT "*",               /* Estabelecimento */
                                           INPUT "*",               /* UF */
                                           INPUT "*",               /* Natureza de Operaá∆o */
                                           INPUT "*",               /* NCM */
                                           INPUT tt-item-json.codItem, /* Item */
                                           INPUT 0,                 /* Emitente */
                                           OUTPUT c-mensagem).

  IF  RETURN-VALUE <> "OK" THEN DO:
      RUN pi-gerar-dados-extrato("ERRO piGeraRelactoCest - " + c-mensagem).

      RUN pi-cria-mensagem (INPUT 412,
                            INPUT "ERRO_DE_VALIDACAO",
                            INPUT c-mensagem).
      RETURN 'NOK'.
  END.

  IF  VALID-HANDLE(h-esmsspapi001) THEN
      DELETE PROCEDURE h-esmsspapi001.
  
  /* Trata Caracter°stica do Item */
  RUN pi-caracteristica-item IN THIS-PROCEDURE.

  /*
  FIND FIRST int-item WHERE int-item.it-codigo = ITEM.it-codigo EXCLUSIVE-LOCK NO-ERROR.

  RUN pi-gerar-dados-extrato ("ANTES UPDATE SOLAR 3").

   RUN pi-gerar-dados-extrato ("AVAIL int-item ; " + STRING(AVAIL int-item)).

  IF AVAIL int-item THEN DO:
  
      //rodar o update record pra criar as informacoes da solar
      RUN esbo/boes372.p PERSISTENT SET h-boes372.
      RUN pi-gerar-dados-extrato ("DADOS SOLAR 2"  ).
      RUN openQueryStatic IN h-boes372(input "Main":U).
      RUN pi-gerar-dados-extrato ("DADOS SOLAR 3"  ).
      RUN goToKey         IN h-boes372 (INPUT int-item.it-codigo).
      RUN pi-gerar-dados-extrato ("DADOS SOLAR 4"  ).
      RUN emptyRowErrors IN h-boes372. 
      RUN pi-gerar-dados-extrato ("DADOS SOLAR 5 iiiiii"  ).
      RUN UpdateRecord   IN h-boes372.
      RUN afterUpdateRecord   IN h-boes372.
      RUN pi-gerar-dados-extrato ("DADOS SOLAR 6 aaaaaaa"  ).
      //RUN getRowErrors   IN h-boes372 (OUTPUT TABLE RowErrors).
      
    
      RELEASE int-item.

  END.*/

  IF  VALID-HANDLE(h-boes372) THEN DO:
      RUN DESTROY IN h-boes372.
      DELETE OBJECT h-boes372 NO-ERROR.
  END.

  IF RETURN-VALUE = "NOK":U THEN
     RETURN 'NOK'.
     
END PROCEDURE.



PROCEDURE pi-caracteristica-item:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN pi-gerar-dados-extrato ("ENTROU pi-caracteristica-item").

    FOR EACH  comp-folh NO-LOCK
        WHERE comp-folh.cd-folha = "1":

        FIND FIRST it-carac-tec EXCLUSIVE-LOCK
            WHERE  it-carac-tec.it-codigo = tt-item-json.codItem
            AND    it-carac-tec.cd-folha  = comp-folh.cd-folha
            AND    it-carac-tec.cd-comp   = comp-folh.cd-comp NO-ERROR.
        
        IF  NOT AVAIL it-carac-tec THEN DO:
            CREATE it-carac-tec.
            ASSIGN it-carac-tec.it-codigo = tt-item-json.codItem
                   it-carac-tec.cd-folha  = comp-folh.cd-folha 
                   it-carac-tec.cd-comp   = comp-folh.cd-comp.
        END.

        ASSIGN it-carac-tec.tipo-result = comp-folh.tipo-result.

        IF  comp-folh.nr-tabela <> 0 THEN DO:  

            IF  pTipoRequisicao = 2 /* Alteraá∆o */ THEN DO:
                FOR EACH  it-res-carac NO-LOCK
                    WHERE it-res-carac.it-codigo = tt-item-json.codItem  
                    AND   it-res-carac.cd-folha  = comp-folh.cd-folha  
                    AND   it-res-carac.cd-comp   = comp-folh.cd-comp
                    AND   it-res-carac.nr-tabela = comp-folh.nr-tabela:

                    FIND FIRST b01-it-res-carac EXCLUSIVE-LOCK
                         WHERE b01-it-res-carac.it-codigo = tt-item-json.codItem  
                           AND b01-it-res-carac.cd-folha  = comp-folh.cd-folha  
                           AND b01-it-res-carac.cd-comp   = comp-folh.cd-comp
                           AND b01-it-res-carac.nr-tabela = comp-folh.nr-tabela
                    NO-ERROR.
                    
                    IF AVAIL b01-it-res-carac THEN
                       DELETE b01-it-res-carac.
                END.
            END.                               

            /* Amostragem */
            IF  comp-folh.nr-tabela = 3 THEN DO:
                FIND FIRST it-res-carac NO-LOCK
                    WHERE  it-res-carac.it-codigo = tt-item-json.codItem
                    AND    it-res-carac.cd-folha  = comp-folh.cd-folha
                    AND    it-res-carac.cd-comp   = comp-folh.cd-comp
                    AND    it-res-carac.nr-tabela = comp-folh.nr-tabela
                    AND    it-res-carac.sequencia = tt-item-json.codAmost NO-ERROR.
                IF  NOT AVAIL it-res-carac then do:

                     RUN pi-gerar-dados-extrato("CRIA it-res-carac Amostragem : " + STRING(tt-item-json.codAmost)).

                     CREATE it-res-carac.
                     ASSIGN it-res-carac.it-codigo   = tt-item-json.codItem
                            it-res-carac.cd-folha    = comp-folh.cd-folha
                            it-res-carac.cd-comp     = comp-folh.cd-comp
                            it-res-carac.nr-tabela   = comp-folh.nr-tabela
                            it-res-carac.sequencia   = tt-item-json.codAmost
                            it-res-carac.tipo-result = comp-folh.tipo-result.
                END.
                ASSIGN it-carac-tec.observacao  = tt-item-json.desAmost .
            END. 

            /* Acondicionamento */
            IF  comp-folh.nr-tabela = 4 THEN DO:
                FIND FIRST it-res-carac NO-LOCK
                    WHERE  it-res-carac.it-codigo = tt-item-json.codItem
                    AND    it-res-carac.cd-folha  = comp-folh.cd-folha
                    AND    it-res-carac.cd-comp   = comp-folh.cd-comp
                    AND    it-res-carac.nr-tabela = comp-folh.nr-tabela
                    AND    it-res-carac.sequencia = int(tt-item-json.codAcond) NO-ERROR.
                IF  NOT AVAIL it-res-carac then do:

                     RUN pi-gerar-dados-extrato("CRIA it-res-carac Acondicionamento :" + STRING(tt-item-json.codAcond)).

                     CREATE it-res-carac.
                     ASSIGN it-res-carac.it-codigo   = tt-item-json.codItem
                            it-res-carac.cd-folha    = comp-folh.cd-folha
                            it-res-carac.cd-comp     = comp-folh.cd-comp
                            it-res-carac.nr-tabela   = comp-folh.nr-tabela
                            it-res-carac.sequencia   = int(tt-item-json.codAcond)
                            it-res-carac.tipo-result = comp-folh.tipo-result.
                END.
                ASSIGN it-carac-tec.observacao  = tt-item-json.desAcond.
            END.
        END.

        /* Vers∆o - tipo numerico = 1 */
        IF  comp-folh.tipo-result = 1 THEN DO:
            IF  comp-folh.descricao = "versao" THEN
                ASSIGN it-carac-tec.vl-result  = INT(tt-item-json.versao).
        END.

        /* Informacaoes adicionais - tipo texto = 3 */
        IF  comp-folh.tipo-result = 3 THEN DO:
            FIND FIRST it-msg-carac EXCLUSIVE-LOCK
                WHERE  it-msg-carac.it-codigo = tt-item-json.codItem
                AND    it-msg-carac.cd-folha  = comp-folh.cd-folha
                AND    it-msg-carac.cd-comp   = comp-folh.cd-comp NO-ERROR.
            IF  NOT AVAIL it-msg-carac THEN DO:

                RUN pi-gerar-dados-extrato("CRIA it-msg-carac infAdic : " + tt-item-json.infAdic).

                CREATE it-msg-carac.
                ASSIGN it-msg-carac.it-codigo = tt-item-json.codItem
                       it-msg-carac.cd-folha  = comp-folh.cd-folha
                       it-msg-carac.cd-comp   = comp-folh.cd-comp.
            END.
            ASSIGN it-msg-carac.msg-ex     = tt-item-json.infAdic
                   it-carac-tec.observacao = tt-item-json.infAdic.
        END.

        /* Responsavel - tipo observacao = 4 */
        IF  comp-folh.tipo-result = 4 THEN DO:
            IF  comp-folh.descricao = "Responsavel" THEN DO:
                ASSIGN it-carac-tec.observacao = tt-item-json.responsavel.

                RUN pi-gerar-dados-extrato("it-carac-tec.observacao - Responsavel : " + tt-item-json.responsavel).
            END.
        END.

        /* Data Versao - tipo data = 6 */
        IF  comp-folh.tipo-result = 6 THEN DO:
            IF  comp-folh.descricao = "Data da Versao" THEN DO:
                //ASSIGN it-carac-tec.dt-result  = DATE(tt-item-json.dataVersao).
            END.
        END.

        RELEASE it-carac-tec.
        RELEASE it-msg-carac.
        RELEASE it-res-carac.
    END.

    //RUN pi-gerar-dados-extrato("FIM pi-caracteristica-item").

    RETURN "OK":U.

END PROCEDURE.




PROCEDURE pi-cria-mensagem:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-codigo   AS INT  NO-UNDO.
    DEF INPUT PARAM p-inform   AS CHAR NO-UNDO.
    DEF INPUT PARAM p-mensagem AS CHAR NO-UNDO.

    CREATE tt-mensagem-2.
    ASSIGN tt-mensagem-2.tip-msgs   = p-codigo
           tt-mensagem-2.informacao = p-inform
           tt-mensagem-2.mensagem   = p-mensagem.

END PROCEDURE.





